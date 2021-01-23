/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 *
 * Copyright 2015 Mozilla Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "wasm/WasmGenerator.h"

#include "mozilla/CheckedInt.h"
#include "mozilla/EnumeratedRange.h"
#include "mozilla/SHA1.h"
#include "mozilla/Unused.h"

#include <algorithm>
#include <thread>

#include "util/Memory.h"
#include "util/Text.h"
#include "wasm/WasmBaselineCompile.h"
#include "wasm/WasmCompile.h"
#include "wasm/WasmCraneliftCompile.h"
#include "wasm/WasmIonCompile.h"
#include "wasm/WasmStubs.h"

#include "jit/MacroAssembler-inl.h"

using namespace js;
using namespace js::jit;
using namespace js::wasm;

using mozilla::CheckedInt;
using mozilla::MakeEnumeratedRange;
using mozilla::Unused;

bool CompiledCode::swap(MacroAssembler& masm) {
  MOZ_ASSERT(bytes.empty());
  if (!masm.swapBuffer(bytes)) {
    return false;
  }

  callSites.swap(masm.callSites());
  callSiteTargets.swap(masm.callSiteTargets());
  trapSites.swap(masm.trapSites());
  symbolicAccesses.swap(masm.symbolicAccesses());
  codeLabels.swap(masm.codeLabels());
  return true;
}

bool CompiledCode::swapCranelift(MacroAssembler& masm,
                                 CraneliftReusableData& data) {
  if (!swap(masm)) {
    return false;
  }
  std::swap(data, craneliftReusableData);
  return true;
}

// ****************************************************************************
// ModuleGenerator

static const unsigned GENERATOR_LIFO_DEFAULT_CHUNK_SIZE = 4 * 1024;
static const unsigned COMPILATION_LIFO_DEFAULT_CHUNK_SIZE = 64 * 1024;
static const uint32_t BAD_CODE_RANGE = UINT32_MAX;

ModuleGenerator::ModuleGenerator(const CompileArgs& args,
                                 ModuleEnvironment* env,
                                 const Atomic<bool>* cancelled,
                                 UniqueChars* error)
    : compileArgs_(&args),
      error_(error),
      cancelled_(cancelled),
      env_(env),
      linkData_(nullptr),
      metadataTier_(nullptr),
      taskState_(mutexid::WasmCompileTaskState),
      lifo_(GENERATOR_LIFO_DEFAULT_CHUNK_SIZE),
      masmAlloc_(&lifo_),
      masm_(masmAlloc_, /* limitedSize= */ false),
      debugTrapCodeOffset_(),
      lastPatchedCallSite_(0),
      startOfUnpatchedCallsites_(0),
      parallel_(false),
      outstanding_(0),
      currentTask_(nullptr),
      batchedBytecode_(0),
      finishedFuncDefs_(false) {
  MOZ_ASSERT(IsCompilingWasm());
}

ModuleGenerator::~ModuleGenerator() {
  MOZ_ASSERT_IF(finishedFuncDefs_, !batchedBytecode_);
  MOZ_ASSERT_IF(finishedFuncDefs_, !currentTask_);

  if (parallel_) {
    if (outstanding_) {
      // Remove any pending compilation tasks from the worklist.
      {
        AutoLockHelperThreadState lock;
        CompileTaskPtrFifo& worklist =
            HelperThreadState().wasmWorklist(lock, mode());
        auto pred = [this](CompileTask* task) {
          return &task->state == &taskState_;
        };
        size_t removed = worklist.eraseIf(pred);
        MOZ_ASSERT(outstanding_ >= removed);
        outstanding_ -= removed;
      }

      // Wait until all active compilation tasks have finished.
      {
        auto taskState = taskState_.lock();
        while (true) {
          MOZ_ASSERT(outstanding_ >= taskState->finished.length());
          outstanding_ -= taskState->finished.length();
          taskState->finished.clear();

          MOZ_ASSERT(outstanding_ >= taskState->numFailed);
          outstanding_ -= taskState->numFailed;
          taskState->numFailed = 0;

          if (!outstanding_) {
            break;
          }

          taskState.wait(/* failed or finished */);
        }
      }
    }
  } else {
    MOZ_ASSERT(!outstanding_);
  }

  // Propagate error state.
  if (error_ && !*error_) {
    *error_ = std::move(taskState_.lock()->errorMessage);
  }
}

bool ModuleGenerator::allocateGlobalBytes(uint32_t bytes, uint32_t align,
                                          uint32_t* globalDataOffset) {
  CheckedInt<uint32_t> newGlobalDataLength(metadata_->globalDataLength);

  newGlobalDataLength +=
      ComputeByteAlignment(newGlobalDataLength.value(), align);
  if (!newGlobalDataLength.isValid()) {
    return false;
  }

  *globalDataOffset = newGlobalDataLength.value();
  newGlobalDataLength += bytes;

  if (!newGlobalDataLength.isValid()) {
    return false;
  }

  metadata_->globalDataLength = newGlobalDataLength.value();
  return true;
}

bool ModuleGenerator::init(Metadata* maybeAsmJSMetadata) {
  // Perform fallible metadata, linkdata, assumption allocations.

  MOZ_ASSERT(isAsmJS() == !!maybeAsmJSMetadata);
  if (maybeAsmJSMetadata) {
    metadata_ = maybeAsmJSMetadata;
  } else {
    metadata_ = js_new<Metadata>();
    if (!metadata_) {
      return false;
    }
  }

  if (compileArgs_->scriptedCaller.filename) {
    metadata_->filename =
        DuplicateString(compileArgs_->scriptedCaller.filename.get());
    if (!metadata_->filename) {
      return false;
    }

    metadata_->filenameIsURL = compileArgs_->scriptedCaller.filenameIsURL;
  } else {
    MOZ_ASSERT(!compileArgs_->scriptedCaller.filenameIsURL);
  }

  if (compileArgs_->sourceMapURL) {
    metadata_->sourceMapURL = DuplicateString(compileArgs_->sourceMapURL.get());
    if (!metadata_->sourceMapURL) {
      return false;
    }
  }

  linkData_ = js::MakeUnique<LinkData>(tier());
  if (!linkData_) {
    return false;
  }

  metadataTier_ = js::MakeUnique<MetadataTier>(tier());
  if (!metadataTier_) {
    return false;
  }

  // funcToCodeRange maps function indices to code-range indices and all
  // elements will be initialized by the time module generation is finished.

  if (!metadataTier_->funcToCodeRange.appendN(BAD_CODE_RANGE,
                                              env_->funcTypes.length())) {
    return false;
  }

  // Pre-reserve space for large Vectors to avoid the significant cost of the
  // final reallocs. In particular, the MacroAssembler can be enormous, so be
  // extra conservative. Since large over-reservations may fail when the
  // actual allocations will succeed, ignore OOM failures. Note,
  // shrinkStorageToFit calls at the end will trim off unneeded capacity.

  size_t codeSectionSize = env_->codeSection ? env_->codeSection->size : 0;

  size_t estimatedCodeSize =
      1.2 * EstimateCompiledCodeSize(tier(), codeSectionSize);
  Unused << masm_.reserve(std::min(estimatedCodeSize, MaxCodeBytesPerProcess));

  Unused << metadataTier_->codeRanges.reserve(2 * env_->numFuncDefs());

  const size_t ByteCodesPerCallSite = 50;
  Unused << metadataTier_->callSites.reserve(codeSectionSize /
                                             ByteCodesPerCallSite);

  const size_t ByteCodesPerOOBTrap = 10;
  Unused << metadataTier_->trapSites[Trap::OutOfBounds].reserve(
      codeSectionSize / ByteCodesPerOOBTrap);

  // Allocate space in TlsData for declarations that need it.

  MOZ_ASSERT(metadata_->globalDataLength == 0);

  for (size_t i = 0; i < env_->funcImportGlobalDataOffsets.length(); i++) {
    uint32_t globalDataOffset;
    if (!allocateGlobalBytes(sizeof(FuncImportTls), sizeof(void*),
                             &globalDataOffset)) {
      return false;
    }

    env_->funcImportGlobalDataOffsets[i] = globalDataOffset;

    FuncType copy;
    if (!copy.clone(*env_->funcTypes[i])) {
      return false;
    }
    if (!metadataTier_->funcImports.emplaceBack(std::move(copy),
                                                globalDataOffset)) {
      return false;
    }
  }

  for (TableDesc& table : env_->tables) {
    if (!allocateGlobalBytes(sizeof(TableTls), sizeof(void*),
                             &table.globalDataOffset)) {
      return false;
    }
  }

  if (!isAsmJS()) {
    for (TypeDef& td : env_->types) {
      if (!td.isFuncType()) {
        continue;
      }

      FuncTypeWithId& funcType = td.funcType();
      if (FuncTypeIdDesc::isGlobal(funcType)) {
        uint32_t globalDataOffset;
        if (!allocateGlobalBytes(sizeof(void*), sizeof(void*),
                                 &globalDataOffset)) {
          return false;
        }

        funcType.id = FuncTypeIdDesc::global(funcType, globalDataOffset);

        FuncType copy;
        if (!copy.clone(funcType)) {
          return false;
        }

        if (!metadata_->funcTypeIds.emplaceBack(std::move(copy), funcType.id)) {
          return false;
        }
      } else {
        funcType.id = FuncTypeIdDesc::immediate(funcType);
      }
    }
  }

  for (GlobalDesc& global : env_->globals) {
    if (global.isConstant()) {
      continue;
    }

    uint32_t width =
        global.isIndirect() ? sizeof(void*) : SizeOf(global.type());

    uint32_t globalDataOffset;
    if (!allocateGlobalBytes(width, width, &globalDataOffset)) {
      return false;
    }

    global.setOffset(globalDataOffset);
  }

  // Accumulate all exported functions:
  // - explicitly marked as such;
  // - implicitly exported by being an element of function tables;
  // - implicitly exported by being the start function;
  // The FuncExportVector stored in Metadata needs to be sorted (to allow
  // O(log(n)) lookup at runtime) and deduplicated. Use a vector with invalid
  // entries for every single function, that we'll fill as we go through the
  // exports, and in which we'll remove invalid entries after the fact.

  static_assert(((uint64_t(MaxFuncs) << 1) | 1) < uint64_t(UINT32_MAX),
                "bit packing won't work in ExportedFunc");

  class ExportedFunc {
    uint32_t value;

   public:
    ExportedFunc() : value(UINT32_MAX) {}
    ExportedFunc(uint32_t index, bool isExplicit)
        : value((index << 1) | (isExplicit ? 1 : 0)) {}
    uint32_t index() const { return value >> 1; }
    bool isExplicit() const { return value & 0x1; }
    bool operator<(const ExportedFunc& other) const {
      return index() < other.index();
    }
    bool operator==(const ExportedFunc& other) const {
      return index() == other.index();
    }
    bool isInvalid() const { return value == UINT32_MAX; }
    void mergeExplicit(bool explicitBit) {
      if (!isExplicit() && explicitBit) {
        value |= 0x1;
      }
    }
  };

  Vector<ExportedFunc, 8, SystemAllocPolicy> exportedFuncs;
  if (!exportedFuncs.resize(env_->numFuncs())) {
    return false;
  }

  auto addOrMerge = [&exportedFuncs](ExportedFunc newEntry) {
    uint32_t index = newEntry.index();
    if (exportedFuncs[index].isInvalid()) {
      exportedFuncs[index] = newEntry;
    } else {
      exportedFuncs[index].mergeExplicit(newEntry.isExplicit());
    }
  };

  for (const Export& exp : env_->exports) {
    if (exp.kind() == DefinitionKind::Function) {
      addOrMerge(ExportedFunc(exp.funcIndex(), true));
    }
  }

  if (env_->startFuncIndex) {
    addOrMerge(ExportedFunc(*env_->startFuncIndex, true));
  }

  for (const ElemSegment* seg : env_->elemSegments) {
    // For now, the segments always carry function indices regardless of the
    // segment's declared element type; this works because the only legal
    // element types are funcref and anyref and the only legal values are
    // functions and null.  We always add functions in segments as exported
    // functions, regardless of the segment's type.  In the future, if we make
    // the representation of AnyRef segments different, we will have to consider
    // function values in those segments specially.
    bool isAsmJS =
        seg->active() && env_->tables[seg->tableIndex].kind == TableKind::AsmJS;
    if (!isAsmJS) {
      for (uint32_t funcIndex : seg->elemFuncIndices) {
        if (funcIndex != NullFuncIndex) {
          addOrMerge(ExportedFunc(funcIndex, false));
        }
      }
    }
  }

  for (const GlobalDesc& global : env_->globals) {
    if (global.isVariable() &&
        global.initExpr().kind() == InitExpr::Kind::RefFunc) {
      addOrMerge(ExportedFunc(global.initExpr().refFuncIndex(), false));
    }
  }

  auto* newEnd =
      std::remove_if(exportedFuncs.begin(), exportedFuncs.end(),
                     [](const ExportedFunc& exp) { return exp.isInvalid(); });
  exportedFuncs.erase(newEnd, exportedFuncs.end());

  if (!metadataTier_->funcExports.reserve(exportedFuncs.length())) {
    return false;
  }

  for (const ExportedFunc& funcIndex : exportedFuncs) {
    FuncType funcType;
    if (!funcType.clone(*env_->funcTypes[funcIndex.index()])) {
      return false;
    }
    metadataTier_->funcExports.infallibleEmplaceBack(
        std::move(funcType), funcIndex.index(), funcIndex.isExplicit());
  }

  // Determine whether parallel or sequential compilation is to be used and
  // initialize the CompileTasks that will be used in either mode.

  GlobalHelperThreadState& threads = HelperThreadState();
  MOZ_ASSERT(threads.threadCount > 1);

  uint32_t numTasks;
  if (CanUseExtraThreads() && threads.cpuCount > 1) {
    parallel_ = true;
    numTasks = 2 * threads.maxWasmCompilationThreads();
  } else {
    numTasks = 1;
  }

  if (!tasks_.initCapacity(numTasks)) {
    return false;
  }
  for (size_t i = 0; i < numTasks; i++) {
    tasks_.infallibleEmplaceBack(*env_, taskState_,
                                 COMPILATION_LIFO_DEFAULT_CHUNK_SIZE);
  }

  if (!freeTasks_.reserve(numTasks)) {
    return false;
  }
  for (size_t i = 0; i < numTasks; i++) {
    freeTasks_.infallibleAppend(&tasks_[i]);
  }

  // Fill in function stubs for each import so that imported functions can be
  // used in all the places that normal function definitions can (table
  // elements, export calls, etc).

  CompiledCode& importCode = tasks_[0].output;
  MOZ_ASSERT(importCode.empty());

  if (!GenerateImportFunctions(*env_, metadataTier_->funcImports,
                               &importCode)) {
    return false;
  }

  if (!linkCompiledCode(importCode)) {
    return false;
  }

  importCode.clear();
  return true;
}

bool ModuleGenerator::funcIsCompiled(uint32_t funcIndex) const {
  return metadataTier_->funcToCodeRange[funcIndex] != BAD_CODE_RANGE;
}

const CodeRange& ModuleGenerator::funcCodeRange(uint32_t funcIndex) const {
  MOZ_ASSERT(funcIsCompiled(funcIndex));
  const CodeRange& cr =
      metadataTier_->codeRanges[metadataTier_->funcToCodeRange[funcIndex]];
  MOZ_ASSERT(cr.isFunction());
  return cr;
}

static bool InRange(uint32_t caller, uint32_t callee) {
  // We assume JumpImmediateRange is defined conservatively enough that the
  // slight difference between 'caller' (which is really the return address
  // offset) and the actual base of the relative displacement computation
  // isn't significant.
  uint32_t range = std::min(JitOptions.jumpThreshold, JumpImmediateRange);
  if (caller < callee) {
    return callee - caller < range;
  }
  return caller - callee < range;
}

typedef HashMap<uint32_t, uint32_t, DefaultHasher<uint32_t>, SystemAllocPolicy>
    OffsetMap;
typedef EnumeratedArray<Trap, Trap::Limit, Maybe<uint32_t>>
    TrapMaybeOffsetArray;

bool ModuleGenerator::linkCallSites() {
  masm_.haltingAlign(CodeAlignment);

  // Create far jumps for calls that have relative offsets that may otherwise
  // go out of range. This method is called both between function bodies (at a
  // frequency determined by the ISA's jump range) and once at the very end of
  // a module's codegen after all possible calls/traps have been emitted.

  OffsetMap existingCallFarJumps;
  for (; lastPatchedCallSite_ < metadataTier_->callSites.length();
       lastPatchedCallSite_++) {
    const CallSite& callSite = metadataTier_->callSites[lastPatchedCallSite_];
    const CallSiteTarget& target = callSiteTargets_[lastPatchedCallSite_];
    uint32_t callerOffset = callSite.returnAddressOffset();
    switch (callSite.kind()) {
      case CallSiteDesc::Dynamic:
      case CallSiteDesc::Symbolic:
        break;
      case CallSiteDesc::Func: {
        if (funcIsCompiled(target.funcIndex())) {
          uint32_t calleeOffset =
              funcCodeRange(target.funcIndex()).funcNormalEntry();
          if (InRange(callerOffset, calleeOffset)) {
            masm_.patchCall(callerOffset, calleeOffset);
            break;
          }
        }

        OffsetMap::AddPtr p =
            existingCallFarJumps.lookupForAdd(target.funcIndex());
        if (!p) {
          Offsets offsets;
          offsets.begin = masm_.currentOffset();
          if (!callFarJumps_.emplaceBack(target.funcIndex(),
                                         masm_.farJumpWithPatch())) {
            return false;
          }
          offsets.end = masm_.currentOffset();
          if (masm_.oom()) {
            return false;
          }
          if (!metadataTier_->codeRanges.emplaceBack(CodeRange::FarJumpIsland,
                                                     offsets)) {
            return false;
          }
          if (!existingCallFarJumps.add(p, target.funcIndex(), offsets.begin)) {
            return false;
          }
        }

        masm_.patchCall(callerOffset, p->value());
        break;
      }
      case CallSiteDesc::Breakpoint:
      case CallSiteDesc::EnterFrame:
      case CallSiteDesc::LeaveFrame: {
        Uint32Vector& jumps = metadataTier_->debugTrapFarJumpOffsets;
        if (jumps.empty() || !InRange(jumps.back(), callerOffset)) {
          // See BaseCompiler::insertBreakablePoint for why we must
          // reload the TLS register on this path.
          Offsets offsets;
          offsets.begin = masm_.currentOffset();
          masm_.loadPtr(Address(FramePointer, offsetof(Frame, tls)),
                        WasmTlsReg);
          CodeOffset jumpOffset = masm_.farJumpWithPatch();
          offsets.end = masm_.currentOffset();
          if (masm_.oom()) {
            return false;
          }
          if (!metadataTier_->codeRanges.emplaceBack(CodeRange::FarJumpIsland,
                                                     offsets)) {
            return false;
          }
          if (!debugTrapFarJumps_.emplaceBack(jumpOffset)) {
            return false;
          }
          if (!jumps.emplaceBack(offsets.begin)) {
            return false;
          }
        }
        break;
      }
    }
  }

  masm_.flushBuffer();
  return !masm_.oom();
}

void ModuleGenerator::noteCodeRange(uint32_t codeRangeIndex,
                                    const CodeRange& codeRange) {
  switch (codeRange.kind()) {
    case CodeRange::Function:
      MOZ_ASSERT(metadataTier_->funcToCodeRange[codeRange.funcIndex()] ==
                 BAD_CODE_RANGE);
      metadataTier_->funcToCodeRange[codeRange.funcIndex()] = codeRangeIndex;
      break;
    case CodeRange::InterpEntry:
      metadataTier_->lookupFuncExport(codeRange.funcIndex())
          .initEagerInterpEntryOffset(codeRange.begin());
      break;
    case CodeRange::JitEntry:
      // Nothing to do: jit entries are linked in the jump tables.
      break;
    case CodeRange::ImportJitExit:
      metadataTier_->funcImports[codeRange.funcIndex()].initJitExitOffset(
          codeRange.begin());
      break;
    case CodeRange::ImportInterpExit:
      metadataTier_->funcImports[codeRange.funcIndex()].initInterpExitOffset(
          codeRange.begin());
      break;
    case CodeRange::DebugTrap:
      MOZ_ASSERT(!debugTrapCodeOffset_);
      debugTrapCodeOffset_ = codeRange.begin();
      break;
    case CodeRange::TrapExit:
      MOZ_ASSERT(!linkData_->trapOffset);
      linkData_->trapOffset = codeRange.begin();
      break;
    case CodeRange::Throw:
      // Jumped to by other stubs, so nothing to do.
      break;
    case CodeRange::FarJumpIsland:
    case CodeRange::BuiltinThunk:
      MOZ_CRASH("Unexpected CodeRange kind");
  }
}

template <class Vec, class Op>
static bool AppendForEach(Vec* dstVec, const Vec& srcVec, Op op) {
  if (!dstVec->growByUninitialized(srcVec.length())) {
    return false;
  }

  using T = typename Vec::ElementType;

  const T* src = srcVec.begin();

  T* dstBegin = dstVec->begin();
  T* dstEnd = dstVec->end();
  T* dstStart = dstEnd - srcVec.length();

  for (T* dst = dstStart; dst != dstEnd; dst++, src++) {
    new (dst) T(*src);
    op(dst - dstBegin, dst);
  }

  return true;
}

bool ModuleGenerator::linkCompiledCode(CompiledCode& code) {
  // Before merging in new code, if calls in a prior code range might go out of
  // range, insert far jumps to extend the range.

  if (!InRange(startOfUnpatchedCallsites_,
               masm_.size() + code.bytes.length())) {
    startOfUnpatchedCallsites_ = masm_.size();
    if (!linkCallSites()) {
      return false;
    }
  }

  // All code offsets in 'code' must be incremented by their position in the
  // overall module when the code was appended.

  masm_.haltingAlign(CodeAlignment);
  const size_t offsetInModule = masm_.size();
  if (!masm_.appendRawCode(code.bytes.begin(), code.bytes.length())) {
    return false;
  }

  auto codeRangeOp = [=](uint32_t codeRangeIndex, CodeRange* codeRange) {
    codeRange->offsetBy(offsetInModule);
    noteCodeRange(codeRangeIndex, *codeRange);
  };
  if (!AppendForEach(&metadataTier_->codeRanges, code.codeRanges,
                     codeRangeOp)) {
    return false;
  }

  auto callSiteOp = [=](uint32_t, CallSite* cs) {
    cs->offsetBy(offsetInModule);
  };
  if (!AppendForEach(&metadataTier_->callSites, code.callSites, callSiteOp)) {
    return false;
  }

  if (!callSiteTargets_.appendAll(code.callSiteTargets)) {
    return false;
  }

  for (Trap trap : MakeEnumeratedRange(Trap::Limit)) {
    auto trapSiteOp = [=](uint32_t, TrapSite* ts) {
      ts->offsetBy(offsetInModule);
    };
    if (!AppendForEach(&metadataTier_->trapSites[trap], code.trapSites[trap],
                       trapSiteOp)) {
      return false;
    }
  }

  for (const SymbolicAccess& access : code.symbolicAccesses) {
    uint32_t patchAt = offsetInModule + access.patchAt.offset();
    if (!linkData_->symbolicLinks[access.target].append(patchAt)) {
      return false;
    }
  }

  for (const CodeLabel& codeLabel : code.codeLabels) {
    LinkData::InternalLink link;
    link.patchAtOffset = offsetInModule + codeLabel.patchAt().offset();
    link.targetOffset = offsetInModule + codeLabel.target().offset();
#ifdef JS_CODELABEL_LINKMODE
    link.mode = codeLabel.linkMode();
#endif
    if (!linkData_->internalLinks.append(link)) {
      return false;
    }
  }

  for (size_t i = 0; i < code.stackMaps.length(); i++) {
    StackMaps::Maplet maplet = code.stackMaps.move(i);
    maplet.offsetBy(offsetInModule);
    if (!metadataTier_->stackMaps.add(maplet)) {
      // This function is now the only owner of maplet.map, so we'd better
      // free it right now.
      maplet.map->destroy();
      return false;
    }
  }

  return true;
}

static bool ExecuteCompileTask(CompileTask* task, UniqueChars* error) {
  MOZ_ASSERT(task->lifo.isEmpty());
  MOZ_ASSERT(task->output.empty());

  switch (task->env.tier()) {
    case Tier::Optimized:
      switch (task->env.optimizedBackend()) {
        case OptimizedBackend::Cranelift:
          if (!CraneliftCompileFunctions(task->env, task->lifo, task->inputs,
                                         &task->output, error)) {
            return false;
          }
          break;
        case OptimizedBackend::Ion:
          if (!IonCompileFunctions(task->env, task->lifo, task->inputs,
                                   &task->output, error)) {
            return false;
          }
          break;
      }
      break;
    case Tier::Baseline:
      if (!BaselineCompileFunctions(task->env, task->lifo, task->inputs,
                                    &task->output, error)) {
        return false;
      }
      break;
  }

  MOZ_ASSERT(task->lifo.isEmpty());
  MOZ_ASSERT(task->inputs.length() == task->output.codeRanges.length());
  task->inputs.clear();
  return true;
}

void wasm::ExecuteCompileTaskFromHelperThread(CompileTask* task) {
  TraceLoggerThread* logger = TraceLoggerForCurrentThread();
  AutoTraceLog logCompile(logger, TraceLogger_WasmCompilation);

  UniqueChars error;
  bool ok = ExecuteCompileTask(task, &error);

  auto taskState = task->state.lock();

  if (!ok || !taskState->finished.append(task)) {
    taskState->numFailed++;
    if (!taskState->errorMessage) {
      taskState->errorMessage = std::move(error);
    }
  }

  taskState.notify_one(/* failed or finished */);
}

bool ModuleGenerator::locallyCompileCurrentTask() {
  if (!ExecuteCompileTask(currentTask_, error_)) {
    return false;
  }
  if (!finishTask(currentTask_)) {
    return false;
  }
  currentTask_ = nullptr;
  batchedBytecode_ = 0;
  return true;
}

bool ModuleGenerator::finishTask(CompileTask* task) {
  masm_.haltingAlign(CodeAlignment);

  if (!linkCompiledCode(task->output)) {
    return false;
  }

  task->output.clear();

  MOZ_ASSERT(task->inputs.empty());
  MOZ_ASSERT(task->output.empty());
  MOZ_ASSERT(task->lifo.isEmpty());
  freeTasks_.infallibleAppend(task);
  return true;
}

bool ModuleGenerator::launchBatchCompile() {
  MOZ_ASSERT(currentTask_);

  if (cancelled_ && *cancelled_) {
    return false;
  }

  if (!parallel_) {
    return locallyCompileCurrentTask();
  }

  if (!StartOffThreadWasmCompile(currentTask_, mode())) {
    return false;
  }
  outstanding_++;
  currentTask_ = nullptr;
  batchedBytecode_ = 0;
  return true;
}

bool ModuleGenerator::finishOutstandingTask() {
  MOZ_ASSERT(parallel_);

  CompileTask* task = nullptr;
  {
    auto taskState = taskState_.lock();
    while (true) {
      MOZ_ASSERT(outstanding_ > 0);

      if (taskState->numFailed > 0) {
        return false;
      }

      if (!taskState->finished.empty()) {
        outstanding_--;
        task = taskState->finished.popCopy();
        break;
      }

      taskState.wait(/* failed or finished */);
    }
  }

  // Call outside of the compilation lock.
  return finishTask(task);
}

bool ModuleGenerator::compileFuncDef(uint32_t funcIndex,
                                     uint32_t lineOrBytecode,
                                     const uint8_t* begin, const uint8_t* end,
                                     Uint32Vector&& lineNums) {
  MOZ_ASSERT(!finishedFuncDefs_);
  MOZ_ASSERT(funcIndex < env_->numFuncs());

  uint32_t threshold;
  switch (tier()) {
    case Tier::Baseline:
      threshold = JitOptions.wasmBatchBaselineThreshold;
      break;
    case Tier::Optimized:
      switch (env_->optimizedBackend()) {
        case OptimizedBackend::Ion:
          threshold = JitOptions.wasmBatchIonThreshold;
          break;
        case OptimizedBackend::Cranelift:
          threshold = JitOptions.wasmBatchCraneliftThreshold;
          break;
        default:
          MOZ_CRASH("Invalid optimizedBackend value");
      }
      break;
    default:
      MOZ_CRASH("Invalid tier value");
      break;
  }

  uint32_t funcBytecodeLength = end - begin;

  // Do not go over the threshold if we can avoid it: spin off the compilation
  // before appending the function if we would go over.  (Very large single
  // functions may still exceed the threshold but this is fine; it'll be very
  // uncommon and is in any case safely handled by the MacroAssembler's buffer
  // limit logic.)

  if (currentTask_ && currentTask_->inputs.length() &&
      batchedBytecode_ + funcBytecodeLength > threshold) {
    if (!launchBatchCompile()) {
      return false;
    }
  }

  if (!currentTask_) {
    if (freeTasks_.empty() && !finishOutstandingTask()) {
      return false;
    }
    currentTask_ = freeTasks_.popCopy();
  }

  if (!currentTask_->inputs.emplaceBack(funcIndex, lineOrBytecode, begin, end,
                                        std::move(lineNums))) {
    return false;
  }

  batchedBytecode_ += funcBytecodeLength;
  MOZ_ASSERT(batchedBytecode_ <= MaxCodeSectionBytes);
  return true;
}

bool ModuleGenerator::finishFuncDefs() {
  MOZ_ASSERT(!finishedFuncDefs_);

  if (currentTask_ && !locallyCompileCurrentTask()) {
    return false;
  }

  finishedFuncDefs_ = true;
  return true;
}

bool ModuleGenerator::finishCodegen() {
  // Now that all functions and stubs are generated and their CodeRanges
  // known, patch all calls (which can emit far jumps) and far jumps. Linking
  // can emit tiny far-jump stubs, so there is an ordering dependency here.

  if (!linkCallSites()) {
    return false;
  }

  for (CallFarJump far : callFarJumps_) {
    masm_.patchFarJump(far.jump,
                       funcCodeRange(far.funcIndex).funcNormalEntry());
  }

  for (CodeOffset farJump : debugTrapFarJumps_) {
    masm_.patchFarJump(farJump, debugTrapCodeOffset_);
  }

  // None of the linking or far-jump operations should emit masm metadata.

  MOZ_ASSERT(masm_.callSites().empty());
  MOZ_ASSERT(masm_.callSiteTargets().empty());
  MOZ_ASSERT(masm_.trapSites().empty());
  MOZ_ASSERT(masm_.symbolicAccesses().empty());
  MOZ_ASSERT(masm_.codeLabels().empty());

  masm_.finish();
  return !masm_.oom();
}

bool ModuleGenerator::finishMetadataTier() {
  // The stack maps aren't yet sorted.  Do so now, since we'll need to
  // binary-search them at GC time.
  metadataTier_->stackMaps.sort();

#ifdef DEBUG
  // Check that the stack map contains no duplicates, since that could lead to
  // ambiguities about stack slot pointerness.
  uint8_t* previousNextInsnAddr = nullptr;
  for (size_t i = 0; i < metadataTier_->stackMaps.length(); i++) {
    const StackMaps::Maplet& maplet = metadataTier_->stackMaps.get(i);
    MOZ_ASSERT_IF(i > 0, uintptr_t(maplet.nextInsnAddr) >
                             uintptr_t(previousNextInsnAddr));
    previousNextInsnAddr = maplet.nextInsnAddr;
  }

  // Assert all sorted metadata is sorted.
  uint32_t last = 0;
  for (const CodeRange& codeRange : metadataTier_->codeRanges) {
    MOZ_ASSERT(codeRange.begin() >= last);
    last = codeRange.end();
  }

  last = 0;
  for (const CallSite& callSite : metadataTier_->callSites) {
    MOZ_ASSERT(callSite.returnAddressOffset() >= last);
    last = callSite.returnAddressOffset();
  }

  for (Trap trap : MakeEnumeratedRange(Trap::Limit)) {
    last = 0;
    for (const TrapSite& trapSite : metadataTier_->trapSites[trap]) {
      MOZ_ASSERT(trapSite.pcOffset >= last);
      last = trapSite.pcOffset;
    }
  }

  last = 0;
  for (uint32_t debugTrapFarJumpOffset :
       metadataTier_->debugTrapFarJumpOffsets) {
    MOZ_ASSERT(debugTrapFarJumpOffset >= last);
    last = debugTrapFarJumpOffset;
  }
#endif

  // These Vectors can get large and the excess capacity can be significant,
  // so realloc them down to size.

  metadataTier_->funcToCodeRange.shrinkStorageToFit();
  metadataTier_->codeRanges.shrinkStorageToFit();
  metadataTier_->callSites.shrinkStorageToFit();
  metadataTier_->trapSites.shrinkStorageToFit();
  metadataTier_->debugTrapFarJumpOffsets.shrinkStorageToFit();
  for (Trap trap : MakeEnumeratedRange(Trap::Limit)) {
    metadataTier_->trapSites[trap].shrinkStorageToFit();
  }

  return true;
}

UniqueCodeTier ModuleGenerator::finishCodeTier() {
  MOZ_ASSERT(finishedFuncDefs_);

  while (outstanding_ > 0) {
    if (!finishOutstandingTask()) {
      return nullptr;
    }
  }

#ifdef DEBUG
  for (uint32_t codeRangeIndex : metadataTier_->funcToCodeRange) {
    MOZ_ASSERT(codeRangeIndex != BAD_CODE_RANGE);
  }
#endif

  // Now that all imports/exports are known, we can generate a special
  // CompiledCode containing stubs.

  CompiledCode& stubCode = tasks_[0].output;
  MOZ_ASSERT(stubCode.empty());

  if (!GenerateStubs(*env_, metadataTier_->funcImports,
                     metadataTier_->funcExports, &stubCode)) {
    return nullptr;
  }

  if (!linkCompiledCode(stubCode)) {
    return nullptr;
  }

  // Finish linking and metadata.

  if (!finishCodegen()) {
    return nullptr;
  }

  if (!finishMetadataTier()) {
    return nullptr;
  }

  UniqueModuleSegment segment =
      ModuleSegment::create(tier(), masm_, *linkData_);
  if (!segment) {
    return nullptr;
  }

  metadataTier_->stackMaps.offsetBy(uintptr_t(segment->base()));

#ifdef DEBUG
  // Check that each stack map is associated with a plausible instruction.
  for (size_t i = 0; i < metadataTier_->stackMaps.length(); i++) {
    MOZ_ASSERT(IsValidStackMapKey(env_->debugEnabled(),
                                  metadataTier_->stackMaps.get(i).nextInsnAddr),
               "wasm stack map does not reference a valid insn");
  }
#endif

  return js::MakeUnique<CodeTier>(std::move(metadataTier_), std::move(segment));
}

SharedMetadata ModuleGenerator::finishMetadata(const Bytes& bytecode) {
  // Finish initialization of Metadata, which is only needed for constructing
  // the initial Module, not for tier-2 compilation.
  MOZ_ASSERT(mode() != CompileMode::Tier2);

  // Copy over data from the ModuleEnvironment.

  metadata_->memoryUsage = env_->memoryUsage;
  metadata_->minMemoryLength = env_->minMemoryLength;
  metadata_->maxMemoryLength = env_->maxMemoryLength;
  metadata_->startFuncIndex = env_->startFuncIndex;
  metadata_->tables = std::move(env_->tables);
  metadata_->globals = std::move(env_->globals);
  metadata_->nameCustomSectionIndex = env_->nameCustomSectionIndex;
  metadata_->moduleName = env_->moduleName;
  metadata_->funcNames = std::move(env_->funcNames);
  metadata_->omitsBoundsChecks = env_->hugeMemoryEnabled();
  metadata_->v128Enabled = env_->v128Enabled();

  // Copy over additional debug information.

  if (env_->debugEnabled()) {
    metadata_->debugEnabled = true;

    const size_t numFuncTypes = env_->funcTypes.length();
    if (!metadata_->debugFuncArgTypes.resize(numFuncTypes)) {
      return nullptr;
    }
    if (!metadata_->debugFuncReturnTypes.resize(numFuncTypes)) {
      return nullptr;
    }
    for (size_t i = 0; i < numFuncTypes; i++) {
      if (!metadata_->debugFuncArgTypes[i].appendAll(
              env_->funcTypes[i]->args())) {
        return nullptr;
      }
      if (!metadata_->debugFuncReturnTypes[i].appendAll(
              env_->funcTypes[i]->results())) {
        return nullptr;
      }
    }

    static_assert(sizeof(ModuleHash) <= sizeof(mozilla::SHA1Sum::Hash),
                  "The ModuleHash size shall not exceed the SHA1 hash size.");
    mozilla::SHA1Sum::Hash hash;
    mozilla::SHA1Sum sha1Sum;
    sha1Sum.update(bytecode.begin(), bytecode.length());
    sha1Sum.finish(hash);
    memcpy(metadata_->debugHash, hash, sizeof(ModuleHash));
  }

  MOZ_ASSERT_IF(env_->nameCustomSectionIndex, !!metadata_->namePayload);

  // Metadata shouldn't be mutably modified after finishMetadata().
  SharedMetadata metadata = metadata_;
  metadata_ = nullptr;
  return metadata;
}

SharedModule ModuleGenerator::finishModule(
    const ShareableBytes& bytecode,
    JS::OptimizedEncodingListener* maybeTier2Listener) {
  MOZ_ASSERT(mode() == CompileMode::Once || mode() == CompileMode::Tier1);

  UniqueCodeTier codeTier = finishCodeTier();
  if (!codeTier) {
    return nullptr;
  }

  JumpTables jumpTables;
  if (!jumpTables.init(mode(), codeTier->segment(),
                       codeTier->metadata().codeRanges)) {
    return nullptr;
  }

  // Copy over data from the Bytecode, which is going away at the end of
  // compilation.

  DataSegmentVector dataSegments;
  if (!dataSegments.reserve(env_->dataSegments.length())) {
    return nullptr;
  }
  for (const DataSegmentEnv& srcSeg : env_->dataSegments) {
    MutableDataSegment dstSeg = js_new<DataSegment>(srcSeg);
    if (!dstSeg) {
      return nullptr;
    }
    if (!dstSeg->bytes.append(bytecode.begin() + srcSeg.bytecodeOffset,
                              srcSeg.length)) {
      return nullptr;
    }
    dataSegments.infallibleAppend(std::move(dstSeg));
  }

  CustomSectionVector customSections;
  if (!customSections.reserve(env_->customSections.length())) {
    return nullptr;
  }
  for (const CustomSectionEnv& srcSec : env_->customSections) {
    CustomSection sec;
    if (!sec.name.append(bytecode.begin() + srcSec.nameOffset,
                         srcSec.nameLength)) {
      return nullptr;
    }
    MutableBytes payload = js_new<ShareableBytes>();
    if (!payload) {
      return nullptr;
    }
    if (!payload->append(bytecode.begin() + srcSec.payloadOffset,
                         srcSec.payloadLength)) {
      return nullptr;
    }
    sec.payload = std::move(payload);
    customSections.infallibleAppend(std::move(sec));
  }

  if (env_->nameCustomSectionIndex) {
    metadata_->namePayload =
        customSections[*env_->nameCustomSectionIndex].payload;
  }

  SharedMetadata metadata = finishMetadata(bytecode.bytes);
  if (!metadata) {
    return nullptr;
  }

  StructTypeVector structTypes;
  for (TypeDef& td : env_->types) {
    if (td.isStructType() && !structTypes.append(std::move(td.structType()))) {
      return nullptr;
    }
  }

  MutableCode code =
      js_new<Code>(std::move(codeTier), *metadata, std::move(jumpTables),
                   std::move(structTypes));
  if (!code || !code->initialize(*linkData_)) {
    return nullptr;
  }

  // See Module debugCodeClaimed_ comments for why we need to make a separate
  // debug copy.

  UniqueBytes debugUnlinkedCode;
  UniqueLinkData debugLinkData;
  const ShareableBytes* debugBytecode = nullptr;
  if (env_->debugEnabled()) {
    MOZ_ASSERT(mode() == CompileMode::Once);
    MOZ_ASSERT(tier() == Tier::Debug);

    debugUnlinkedCode = js::MakeUnique<Bytes>();
    if (!debugUnlinkedCode || !debugUnlinkedCode->resize(masm_.bytesNeeded())) {
      return nullptr;
    }

    masm_.executableCopy(debugUnlinkedCode->begin());

    debugLinkData = std::move(linkData_);
    debugBytecode = &bytecode;
  }

  // All the components are finished, so create the complete Module and start
  // tier-2 compilation if requested.

  MutableModule module =
      js_new<Module>(*code, std::move(env_->imports), std::move(env_->exports),
                     std::move(dataSegments), std::move(env_->elemSegments),
                     std::move(customSections), std::move(debugUnlinkedCode),
                     std::move(debugLinkData), debugBytecode);
  if (!module) {
    return nullptr;
  }

  if (mode() == CompileMode::Tier1) {
    module->startTier2(*compileArgs_, bytecode, maybeTier2Listener);
  } else if (tier() == Tier::Serialized && maybeTier2Listener) {
    module->serialize(*linkData_, *maybeTier2Listener);
  }

  return module;
}

bool ModuleGenerator::finishTier2(const Module& module) {
  MOZ_ASSERT(mode() == CompileMode::Tier2);
  MOZ_ASSERT(tier() == Tier::Optimized);
  MOZ_ASSERT(!env_->debugEnabled());

  if (cancelled_ && *cancelled_) {
    return false;
  }

  UniqueCodeTier codeTier = finishCodeTier();
  if (!codeTier) {
    return false;
  }

  if (MOZ_UNLIKELY(JitOptions.wasmDelayTier2)) {
    // Introduce an artificial delay when testing wasmDelayTier2, since we
    // want to exercise both tier1 and tier2 code in this case.
    std::this_thread::sleep_for(std::chrono::milliseconds(500));
  }

  return module.finishTier2(*linkData_, std::move(codeTier));
}

void CompileTask::runTask() { ExecuteCompileTaskFromHelperThread(this); }

size_t CompiledCode::sizeOfExcludingThis(
    mozilla::MallocSizeOf mallocSizeOf) const {
  size_t trapSitesSize = 0;
  for (const TrapSiteVector& vec : trapSites) {
    trapSitesSize += vec.sizeOfExcludingThis(mallocSizeOf);
  }

  return bytes.sizeOfExcludingThis(mallocSizeOf) +
         codeRanges.sizeOfExcludingThis(mallocSizeOf) +
         callSites.sizeOfExcludingThis(mallocSizeOf) +
         callSiteTargets.sizeOfExcludingThis(mallocSizeOf) + trapSitesSize +
         symbolicAccesses.sizeOfExcludingThis(mallocSizeOf) +
         codeLabels.sizeOfExcludingThis(mallocSizeOf);
}

size_t CompileTask::sizeOfExcludingThis(
    mozilla::MallocSizeOf mallocSizeOf) const {
  return lifo.sizeOfExcludingThis(mallocSizeOf) +
         inputs.sizeOfExcludingThis(mallocSizeOf) +
         output.sizeOfExcludingThis(mallocSizeOf);
}
