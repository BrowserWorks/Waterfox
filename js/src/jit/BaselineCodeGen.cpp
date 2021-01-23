/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "jit/BaselineCodeGen.h"

#include "mozilla/Casting.h"

#include "jit/BaselineIC.h"
#include "jit/BaselineJIT.h"
#include "jit/FixedList.h"
#include "jit/IonAnalysis.h"
#include "jit/JitcodeMap.h"
#include "jit/JitSpewer.h"
#include "jit/Linker.h"
#ifdef JS_ION_PERF
#  include "jit/PerfSpewer.h"
#endif
#include "jit/SharedICHelpers.h"
#include "jit/VMFunctions.h"
#include "js/UniquePtr.h"
#include "vm/AsyncFunction.h"
#include "vm/AsyncIteration.h"
#include "vm/EnvironmentObject.h"
#include "vm/FunctionFlags.h"  // js::FunctionFlags
#include "vm/Interpreter.h"
#include "vm/JSFunction.h"
#include "vm/TraceLogging.h"
#ifdef MOZ_VTUNE
#  include "vtune/VTuneWrapper.h"
#endif

#include "debugger/DebugAPI-inl.h"
#include "jit/BaselineFrameInfo-inl.h"
#include "jit/MacroAssembler-inl.h"
#include "jit/SharedICHelpers-inl.h"
#include "jit/VMFunctionList-inl.h"
#include "vm/Interpreter-inl.h"
#include "vm/JSScript-inl.h"
#include "vm/NativeObject-inl.h"
#include "vm/TypeInference-inl.h"

using namespace js;
using namespace js::jit;

using JS::TraceKind;

using mozilla::AssertedCast;
using mozilla::Maybe;

namespace js {

class PlainObject;

namespace jit {

BaselineCompilerHandler::BaselineCompilerHandler(JSContext* cx,
                                                 MacroAssembler& masm,
                                                 TempAllocator& alloc,
                                                 JSScript* script)
    : frame_(script, masm),
      alloc_(alloc),
      analysis_(alloc, script),
#ifdef DEBUG
      masm_(masm),
#endif
      script_(script),
      pc_(script->code()),
      icEntryIndex_(0),
      compileDebugInstrumentation_(script->isDebuggee()),
      ionCompileable_(IsIonEnabled(cx) && CanIonCompileScript(cx, script)) {
}

BaselineInterpreterHandler::BaselineInterpreterHandler(JSContext* cx,
                                                       MacroAssembler& masm)
    : frame_(masm) {}

template <typename Handler>
template <typename... HandlerArgs>
BaselineCodeGen<Handler>::BaselineCodeGen(JSContext* cx, HandlerArgs&&... args)
    : handler(cx, masm, std::forward<HandlerArgs>(args)...),
      cx(cx),
      frame(handler.frame()),
      traceLoggerToggleOffsets_(cx) {}

BaselineCompiler::BaselineCompiler(JSContext* cx, TempAllocator& alloc,
                                   JSScript* script)
    : BaselineCodeGen(cx, /* HandlerArgs = */ alloc, script),
      profilerPushToggleOffset_(),
      traceLoggerScriptTextIdOffset_() {
#ifdef JS_CODEGEN_NONE
  MOZ_CRASH();
#endif
}

BaselineInterpreterGenerator::BaselineInterpreterGenerator(JSContext* cx)
    : BaselineCodeGen(cx /* no handlerArgs */) {}

bool BaselineCompilerHandler::init(JSContext* cx) {
  if (!analysis_.init(alloc_)) {
    return false;
  }

  uint32_t len = script_->length();

  if (!labels_.init(alloc_, len)) {
    return false;
  }

  for (size_t i = 0; i < len; i++) {
    new (&labels_[i]) Label();
  }

  if (!frame_.init(alloc_)) {
    return false;
  }

  return true;
}

bool BaselineCompiler::init() {
  if (!handler.init(cx)) {
    return false;
  }

  return true;
}

bool BaselineCompilerHandler::recordCallRetAddr(JSContext* cx,
                                                RetAddrEntry::Kind kind,
                                                uint32_t retOffset) {
  uint32_t pcOffset = script_->pcToOffset(pc_);

  // Entries must be sorted by pcOffset for binary search to work.
  // See BaselineScript::retAddrEntryFromPCOffset.
  MOZ_ASSERT_IF(!retAddrEntries_.empty(),
                retAddrEntries_.back().pcOffset() <= pcOffset);

  // Similarly, entries must be sorted by return offset and this offset must be
  // unique. See BaselineScript::retAddrEntryFromReturnOffset.
  MOZ_ASSERT_IF(!retAddrEntries_.empty() && !masm_.oom(),
                retAddrEntries_.back().returnOffset().offset() < retOffset);

  if (!retAddrEntries_.emplaceBack(pcOffset, kind, CodeOffset(retOffset))) {
    ReportOutOfMemory(cx);
    return false;
  }

  return true;
}

bool BaselineInterpreterHandler::recordCallRetAddr(JSContext* cx,
                                                   RetAddrEntry::Kind kind,
                                                   uint32_t retOffset) {
  switch (kind) {
    case RetAddrEntry::Kind::DebugPrologue:
      MOZ_ASSERT(callVMOffsets_.debugPrologueOffset == 0,
                 "expected single DebugPrologue call");
      callVMOffsets_.debugPrologueOffset = retOffset;
      break;
    case RetAddrEntry::Kind::DebugEpilogue:
      MOZ_ASSERT(callVMOffsets_.debugEpilogueOffset == 0,
                 "expected single DebugEpilogue call");
      callVMOffsets_.debugEpilogueOffset = retOffset;
      break;
    case RetAddrEntry::Kind::DebugAfterYield:
      MOZ_ASSERT(callVMOffsets_.debugAfterYieldOffset == 0,
                 "expected single DebugAfterYield call");
      callVMOffsets_.debugAfterYieldOffset = retOffset;
      break;
    default:
      break;
  }

  return true;
}

bool BaselineInterpreterHandler::addDebugInstrumentationOffset(
    JSContext* cx, CodeOffset offset) {
  if (!debugInstrumentationOffsets_.append(offset.offset())) {
    ReportOutOfMemory(cx);
    return false;
  }
  return true;
}

MethodStatus BaselineCompiler::compile() {
  JSScript* script = handler.script();
  JitSpew(JitSpew_BaselineScripts, "Baseline compiling script %s:%u:%u (%p)",
          script->filename(), script->lineno(), script->column(), script);

  JitSpew(JitSpew_Codegen, "# Emitting baseline code for script %s:%u:%u",
          script->filename(), script->lineno(), script->column());

  TraceLoggerThread* logger = TraceLoggerForCurrentThread(cx);
  TraceLoggerEvent scriptEvent(TraceLogger_AnnotateScripts, script);
  AutoTraceLog logScript(logger, scriptEvent);
  AutoTraceLog logCompile(logger, TraceLogger_BaselineCompilation);

  AutoKeepJitScripts keepJitScript(cx);
  if (!script->ensureHasJitScript(cx, keepJitScript)) {
    return Method_Error;
  }

  // When code coverage is only enabled for optimizations, or when a Debugger
  // set the collectCoverageInfo flag, we have to create the ScriptCounts if
  // they do not exist.
  if (!script->hasScriptCounts() && cx->realm()->collectCoverage()) {
    if (!script->initScriptCounts(cx)) {
      return Method_Error;
    }
  }

  // Pin analysis info during compilation.
  AutoEnterAnalysis autoEnterAnalysis(cx);

  MOZ_ASSERT(!script->hasBaselineScript());

  if (!emitPrologue()) {
    return Method_Error;
  }

  MethodStatus status = emitBody();
  if (status != Method_Compiled) {
    return status;
  }

  if (!emitEpilogue()) {
    return Method_Error;
  }

  if (!emitOutOfLinePostBarrierSlot()) {
    return Method_Error;
  }

  Linker linker(masm);
  if (masm.oom()) {
    ReportOutOfMemory(cx);
    return Method_Error;
  }

  JitCode* code = linker.newCode(cx, CodeKind::Baseline);
  if (!code) {
    return Method_Error;
  }

  UniquePtr<BaselineScript> baselineScript(
      BaselineScript::New(
          cx, warmUpCheckPrologueOffset_.offset(),
          profilerEnterFrameToggleOffset_.offset(),
          profilerExitFrameToggleOffset_.offset(),
          handler.retAddrEntries().length(), handler.osrEntries().length(),
          debugTrapEntries_.length(), script->resumeOffsets().size(),
          traceLoggerToggleOffsets_.length()),
      JS::DeletePolicy<BaselineScript>(cx->runtime()));
  if (!baselineScript) {
    ReportOutOfMemory(cx);
    return Method_Error;
  }

  baselineScript->setMethod(code);

  JitSpew(JitSpew_BaselineScripts,
          "Created BaselineScript %p (raw %p) for %s:%u:%u",
          (void*)baselineScript.get(), (void*)code->raw(), script->filename(),
          script->lineno(), script->column());

  baselineScript->copyRetAddrEntries(handler.retAddrEntries().begin());
  baselineScript->copyOSREntries(handler.osrEntries().begin());
  baselineScript->copyDebugTrapEntries(debugTrapEntries_.begin());

  // If profiler instrumentation is enabled, toggle instrumentation on.
  if (cx->runtime()->jitRuntime()->isProfilerInstrumentationEnabled(
          cx->runtime())) {
    baselineScript->toggleProfilerInstrumentation(true);
  }

#ifdef JS_TRACE_LOGGING
  // Initialize the tracelogger instrumentation.
  if (JS::TraceLoggerSupported()) {
    baselineScript->initTraceLogger(script, traceLoggerToggleOffsets_);
  }
#endif

  // Compute native resume addresses for the script's resume offsets.
  baselineScript->computeResumeNativeOffsets(script, resumeOffsetEntries_);

  if (compileDebugInstrumentation()) {
    baselineScript->setHasDebugInstrumentation();
  }

  // Always register a native => bytecode mapping entry, since profiler can be
  // turned on with baseline jitcode on stack, and baseline jitcode cannot be
  // invalidated.
  {
    JitSpew(JitSpew_Profiling,
            "Added JitcodeGlobalEntry for baseline script %s:%u:%u (%p)",
            script->filename(), script->lineno(), script->column(),
            baselineScript.get());

    // Generate profiling string.
    UniqueChars str = GeckoProfilerRuntime::allocProfileString(cx, script);
    if (!str) {
      return Method_Error;
    }

    JitcodeGlobalEntry::BaselineEntry entry;
    entry.init(code, code->raw(), code->rawEnd(), script, str.release());

    JitcodeGlobalTable* globalTable =
        cx->runtime()->jitRuntime()->getJitcodeGlobalTable();
    if (!globalTable->addEntry(entry)) {
      entry.destroy();
      ReportOutOfMemory(cx);
      return Method_Error;
    }

    // Mark the jitcode as having a bytecode map.
    code->setHasBytecodeMap();
  }

  script->jitScript()->setBaselineScript(script, baselineScript.release());

#ifdef JS_ION_PERF
  writePerfSpewerBaselineProfile(script, code);
#endif

#ifdef MOZ_VTUNE
  vtune::MarkScript(code, script, "baseline");
#endif

  return Method_Compiled;
}

// On most platforms we use a dedicated bytecode PC register to avoid many
// dependent loads and stores for sequences of simple bytecode ops. This
// register must be saved/restored around VM and IC calls.
//
// On 32-bit x86 we don't have enough registers for this (because R0-R2 require
// 6 registers) so there we always store the pc on the frame.
static constexpr bool HasInterpreterPCReg() {
  return InterpreterPCReg != InvalidReg;
}

static Register LoadBytecodePC(MacroAssembler& masm, Register scratch) {
  if (HasInterpreterPCReg()) {
    return InterpreterPCReg;
  }

  Address pcAddr(BaselineFrameReg,
                 BaselineFrame::reverseOffsetOfInterpreterPC());
  masm.loadPtr(pcAddr, scratch);
  return scratch;
}

static void LoadInt8Operand(MacroAssembler& masm, Register dest) {
  Register pc = LoadBytecodePC(masm, dest);
  masm.load8SignExtend(Address(pc, sizeof(jsbytecode)), dest);
}

static void LoadUint8Operand(MacroAssembler& masm, Register dest) {
  Register pc = LoadBytecodePC(masm, dest);
  masm.load8ZeroExtend(Address(pc, sizeof(jsbytecode)), dest);
}

static void LoadUint16Operand(MacroAssembler& masm, Register dest) {
  Register pc = LoadBytecodePC(masm, dest);
  masm.load16ZeroExtend(Address(pc, sizeof(jsbytecode)), dest);
}

static void LoadInt32Operand(MacroAssembler& masm, Register dest) {
  Register pc = LoadBytecodePC(masm, dest);
  masm.load32(Address(pc, sizeof(jsbytecode)), dest);
}

static void LoadInt32OperandSignExtendToPtr(MacroAssembler& masm, Register pc,
                                            Register dest) {
  masm.load32SignExtendToPtr(Address(pc, sizeof(jsbytecode)), dest);
}

static void LoadUint24Operand(MacroAssembler& masm, size_t offset,
                              Register dest) {
  // Load the opcode and operand, then left shift to discard the opcode.
  Register pc = LoadBytecodePC(masm, dest);
  masm.load32(Address(pc, offset), dest);
  masm.rshift32(Imm32(8), dest);
}

static void LoadInlineValueOperand(MacroAssembler& masm, ValueOperand dest) {
  // Note: the Value might be unaligned but as above we rely on all our
  // platforms having appropriate support for unaligned accesses (except for
  // floating point instructions on ARM).
  Register pc = LoadBytecodePC(masm, dest.scratchReg());
  masm.loadUnalignedValue(Address(pc, sizeof(jsbytecode)), dest);
}

template <>
void BaselineCompilerCodeGen::loadScript(Register dest) {
  masm.movePtr(ImmGCPtr(handler.script()), dest);
}

template <>
void BaselineInterpreterCodeGen::loadScript(Register dest) {
  masm.loadPtr(frame.addressOfInterpreterScript(), dest);
}

template <>
void BaselineCompilerCodeGen::saveInterpreterPCReg() {}

template <>
void BaselineInterpreterCodeGen::saveInterpreterPCReg() {
  if (HasInterpreterPCReg()) {
    masm.storePtr(InterpreterPCReg, frame.addressOfInterpreterPC());
  }
}

template <>
void BaselineCompilerCodeGen::restoreInterpreterPCReg() {}

template <>
void BaselineInterpreterCodeGen::restoreInterpreterPCReg() {
  if (HasInterpreterPCReg()) {
    masm.loadPtr(frame.addressOfInterpreterPC(), InterpreterPCReg);
  }
}

template <>
void BaselineCompilerCodeGen::emitInitializeLocals() {
  // Initialize all locals to |undefined|. Lexical bindings are temporal
  // dead zoned in bytecode.

  size_t n = frame.nlocals();
  if (n == 0) {
    return;
  }

  // Use R0 to minimize code size. If the number of locals to push is <
  // LOOP_UNROLL_FACTOR, then the initialization pushes are emitted directly
  // and inline.  Otherwise, they're emitted in a partially unrolled loop.
  static const size_t LOOP_UNROLL_FACTOR = 4;
  size_t toPushExtra = n % LOOP_UNROLL_FACTOR;

  masm.moveValue(UndefinedValue(), R0);

  // Handle any extra pushes left over by the optional unrolled loop below.
  for (size_t i = 0; i < toPushExtra; i++) {
    masm.pushValue(R0);
  }

  // Partially unrolled loop of pushes.
  if (n >= LOOP_UNROLL_FACTOR) {
    size_t toPush = n - toPushExtra;
    MOZ_ASSERT(toPush % LOOP_UNROLL_FACTOR == 0);
    MOZ_ASSERT(toPush >= LOOP_UNROLL_FACTOR);
    masm.move32(Imm32(toPush), R1.scratchReg());
    // Emit unrolled loop with 4 pushes per iteration.
    Label pushLoop;
    masm.bind(&pushLoop);
    for (size_t i = 0; i < LOOP_UNROLL_FACTOR; i++) {
      masm.pushValue(R0);
    }
    masm.branchSub32(Assembler::NonZero, Imm32(LOOP_UNROLL_FACTOR),
                     R1.scratchReg(), &pushLoop);
  }
}

template <>
void BaselineInterpreterCodeGen::emitInitializeLocals() {
  // Push |undefined| for all locals.

  Register scratch = R0.scratchReg();
  loadScript(scratch);
  masm.loadPtr(Address(scratch, JSScript::offsetOfSharedData()), scratch);
  masm.loadPtr(Address(scratch, RuntimeScriptData::offsetOfISD()), scratch);
  masm.load32(Address(scratch, ImmutableScriptData::offsetOfNfixed()), scratch);

  Label top, done;
  masm.branchTest32(Assembler::Zero, scratch, scratch, &done);
  masm.bind(&top);
  {
    masm.pushValue(UndefinedValue());
    masm.branchSub32(Assembler::NonZero, Imm32(1), scratch, &top);
  }
  masm.bind(&done);
}

// On input:
//  R2.scratchReg() contains object being written to.
//  Called with the baseline stack synced, except for R0 which is preserved.
//  All other registers are usable as scratch.
// This calls:
//    void PostWriteBarrier(JSRuntime* rt, JSObject* obj);
template <typename Handler>
bool BaselineCodeGen<Handler>::emitOutOfLinePostBarrierSlot() {
  masm.bind(&postBarrierSlot_);

  saveInterpreterPCReg();

  Register objReg = R2.scratchReg();
  AllocatableGeneralRegisterSet regs(GeneralRegisterSet::All());
  regs.take(R0);
  regs.take(objReg);
  regs.take(BaselineFrameReg);
  Register scratch = regs.takeAny();
#if defined(JS_CODEGEN_ARM) || defined(JS_CODEGEN_ARM64)
  // On ARM, save the link register before calling.  It contains the return
  // address.  The |masm.ret()| later will pop this into |pc| to return.
  masm.push(lr);
#elif defined(JS_CODEGEN_MIPS32) || defined(JS_CODEGEN_MIPS64)
  masm.push(ra);
#endif
  masm.pushValue(R0);

  masm.setupUnalignedABICall(scratch);
  masm.movePtr(ImmPtr(cx->runtime()), scratch);
  masm.passABIArg(scratch);
  masm.passABIArg(objReg);
  masm.callWithABI(JS_FUNC_TO_DATA_PTR(void*, PostWriteBarrier));

  restoreInterpreterPCReg();

  masm.popValue(R0);
  masm.ret();
  return true;
}

template <>
bool BaselineCompilerCodeGen::emitNextIC() {
  // Emit a call to an IC stored in JitScript. Calls to this must match the
  // ICEntry order in JitScript: first the non-op IC entries for |this| and
  // formal arguments, then the for-op IC entries for JOF_IC ops.

  JSScript* script = handler.script();
  uint32_t pcOffset = script->pcToOffset(handler.pc());

  // We don't use every ICEntry and we can skip unreachable ops, so we have
  // to loop until we find an ICEntry for the current pc.
  const ICEntry* entry;
  do {
    entry = &script->jitScript()->icEntry(handler.icEntryIndex());
    handler.moveToNextICEntry();
  } while (entry->pcOffset() < pcOffset);

  MOZ_RELEASE_ASSERT(entry->pcOffset() == pcOffset);
  MOZ_ASSERT_IF(!entry->isForPrologue(), BytecodeOpHasIC(JSOp(*handler.pc())));

  CodeOffset returnOffset;
  EmitCallIC(masm, entry, &returnOffset);

  RetAddrEntry::Kind kind = entry->isForPrologue()
                                ? RetAddrEntry::Kind::PrologueIC
                                : RetAddrEntry::Kind::IC;

  if (!handler.retAddrEntries().emplaceBack(pcOffset, kind, returnOffset)) {
    ReportOutOfMemory(cx);
    return false;
  }

  return true;
}

template <>
bool BaselineInterpreterCodeGen::emitNextIC() {
  saveInterpreterPCReg();
  masm.loadPtr(frame.addressOfInterpreterICEntry(), ICStubReg);
  masm.loadPtr(Address(ICStubReg, ICEntry::offsetOfFirstStub()), ICStubReg);
  masm.call(Address(ICStubReg, ICStub::offsetOfStubCode()));
  uint32_t returnOffset = masm.currentOffset();
  restoreInterpreterPCReg();

  // If this is an IC for a bytecode op where Ion may inline scripts, we need to
  // record the return offset for Ion bailouts.
  if (handler.currentOp()) {
    JSOp op = *handler.currentOp();
    MOZ_ASSERT(BytecodeOpHasIC(op));
    if (IsIonInlinableOp(op)) {
      if (!handler.icReturnOffsets().emplaceBack(returnOffset, op)) {
        return false;
      }
    }
  }

  return true;
}

template <>
void BaselineCompilerCodeGen::computeFrameSize(Register dest) {
  MOZ_ASSERT(!inCall_, "must not be called in the middle of a VM call");
  masm.move32(Imm32(frame.frameSize()), dest);
}

template <>
void BaselineInterpreterCodeGen::computeFrameSize(Register dest) {
  // dest = FramePointer + BaselineFrame::FramePointerOffset - StackPointer.
  MOZ_ASSERT(!inCall_, "must not be called in the middle of a VM call");
  masm.computeEffectiveAddress(
      Address(BaselineFrameReg, BaselineFrame::FramePointerOffset), dest);
  masm.subStackPtrFrom(dest);
}

template <typename Handler>
void BaselineCodeGen<Handler>::prepareVMCall() {
  pushedBeforeCall_ = masm.framePushed();
#ifdef DEBUG
  inCall_ = true;
#endif

  // Ensure everything is synced.
  frame.syncStack(0);
}

template <>
void BaselineCompilerCodeGen::storeFrameSizeAndPushDescriptor(
    uint32_t argSize, Register scratch1, Register scratch2) {
  uint32_t frameFullSize = frame.frameSize();

#ifdef DEBUG
  masm.store32(Imm32(frameFullSize), frame.addressOfDebugFrameSize());
#endif

  uint32_t descriptor = MakeFrameDescriptor(
      frameFullSize + argSize, FrameType::BaselineJS, ExitFrameLayout::Size());
  masm.push(Imm32(descriptor));
}

template <>
void BaselineInterpreterCodeGen::storeFrameSizeAndPushDescriptor(
    uint32_t argSize, Register scratch1, Register scratch2) {
  // scratch1 = FramePointer + BaselineFrame::FramePointerOffset - StackPointer.
  masm.computeEffectiveAddress(
      Address(BaselineFrameReg, BaselineFrame::FramePointerOffset), scratch1);
  masm.subStackPtrFrom(scratch1);

#ifdef DEBUG
  // Store the frame size without VMFunction arguments in debug builds.
  masm.computeEffectiveAddress(Address(scratch1, -int32_t(argSize)), scratch2);
  masm.store32(scratch2, frame.addressOfDebugFrameSize());
#endif

  // Push frame descriptor based on the full frame size.
  masm.makeFrameDescriptor(scratch1, FrameType::BaselineJS,
                           ExitFrameLayout::Size());
  masm.push(scratch1);
}

static uint32_t GetVMFunctionArgSize(const VMFunctionData& fun) {
  return fun.explicitStackSlots() * sizeof(void*);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::callVMInternal(VMFunctionId id,
                                              RetAddrEntry::Kind kind,
                                              CallVMPhase phase) {
#ifdef DEBUG
  // Assert prepareVMCall() has been called.
  MOZ_ASSERT(inCall_);
  inCall_ = false;
#endif

  TrampolinePtr code = cx->runtime()->jitRuntime()->getVMWrapper(id);
  const VMFunctionData& fun = GetVMFunction(id);

  uint32_t argSize = GetVMFunctionArgSize(fun);

  // Assert all arguments were pushed.
  MOZ_ASSERT(masm.framePushed() - pushedBeforeCall_ == argSize);

  saveInterpreterPCReg();

  if (phase == CallVMPhase::AfterPushingLocals) {
    storeFrameSizeAndPushDescriptor(argSize, R0.scratchReg(), R1.scratchReg());
  } else {
    MOZ_ASSERT(phase == CallVMPhase::BeforePushingLocals);
    uint32_t frameBaseSize = BaselineFrame::frameSizeForNumValueSlots(0);
#ifdef DEBUG
    masm.store32(Imm32(frameBaseSize), frame.addressOfDebugFrameSize());
#endif
    uint32_t descriptor =
        MakeFrameDescriptor(frameBaseSize + argSize, FrameType::BaselineJS,
                            ExitFrameLayout::Size());
    masm.push(Imm32(descriptor));
  }
  MOZ_ASSERT(fun.expectTailCall == NonTailCall);
  // Perform the call.
  masm.call(code);
  uint32_t callOffset = masm.currentOffset();

  // Pop arguments from framePushed.
  masm.implicitPop(argSize);

  restoreInterpreterPCReg();

  return handler.recordCallRetAddr(cx, kind, callOffset);
}

template <typename Handler>
template <typename Fn, Fn fn>
bool BaselineCodeGen<Handler>::callVM(RetAddrEntry::Kind kind,
                                      CallVMPhase phase) {
  VMFunctionId fnId = VMFunctionToId<Fn, fn>::id;
  return callVMInternal(fnId, kind, phase);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitStackCheck() {
  Label skipCall;
  if (handler.mustIncludeSlotsInStackCheck()) {
    // Subtract the size of script->nslots() first.
    Register scratch = R1.scratchReg();
    masm.moveStackPtrTo(scratch);
    subtractScriptSlotsSize(scratch, R2.scratchReg());
    masm.branchPtr(Assembler::BelowOrEqual,
                   AbsoluteAddress(cx->addressOfJitStackLimit()), scratch,
                   &skipCall);
  } else {
    masm.branchStackPtrRhs(Assembler::BelowOrEqual,
                           AbsoluteAddress(cx->addressOfJitStackLimit()),
                           &skipCall);
  }

  prepareVMCall();
  masm.loadBaselineFramePtr(BaselineFrameReg, R1.scratchReg());
  pushArg(R1.scratchReg());

  const CallVMPhase phase = CallVMPhase::BeforePushingLocals;
  const RetAddrEntry::Kind kind = RetAddrEntry::Kind::StackCheck;

  using Fn = bool (*)(JSContext*, BaselineFrame*);
  if (!callVM<Fn, CheckOverRecursedBaseline>(kind, phase)) {
    return false;
  }

  masm.bind(&skipCall);
  return true;
}

static void EmitCallFrameIsDebuggeeCheck(MacroAssembler& masm) {
  masm.setupUnalignedABICall(R0.scratchReg());
  masm.loadBaselineFramePtr(BaselineFrameReg, R0.scratchReg());
  masm.passABIArg(R0.scratchReg());
  masm.callWithABI(JS_FUNC_TO_DATA_PTR(void*, jit::FrameIsDebuggeeCheck));
}

template <>
bool BaselineCompilerCodeGen::emitIsDebuggeeCheck() {
  if (handler.compileDebugInstrumentation()) {
    EmitCallFrameIsDebuggeeCheck(masm);
  }
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emitIsDebuggeeCheck() {
  // Use a toggled jump to call FrameIsDebuggeeCheck only if the debugger is
  // enabled.
  //
  // TODO(bug 1522394): consider having a cx->realm->isDebuggee guard before the
  // call. Consider moving the callWithABI out-of-line.

  Label skipCheck;
  CodeOffset toggleOffset = masm.toggledJump(&skipCheck);
  {
    saveInterpreterPCReg();
    EmitCallFrameIsDebuggeeCheck(masm);
    restoreInterpreterPCReg();
  }
  masm.bind(&skipCheck);
  return handler.addDebugInstrumentationOffset(cx, toggleOffset);
}

static void MaybeIncrementCodeCoverageCounter(MacroAssembler& masm,
                                              JSScript* script,
                                              jsbytecode* pc) {
  if (!script->hasScriptCounts()) {
    return;
  }
  PCCounts* counts = script->maybeGetPCCounts(pc);
  uint64_t* counterAddr = &counts->numExec();
  masm.inc64(AbsoluteAddress(counterAddr));
}

template <>
bool BaselineCompilerCodeGen::emitHandleCodeCoverageAtPrologue() {
  // If the main instruction is not a jump target, then we emit the
  // corresponding code coverage counter.
  JSScript* script = handler.script();
  jsbytecode* main = script->main();
  if (!BytecodeIsJumpTarget(JSOp(*main))) {
    MaybeIncrementCodeCoverageCounter(masm, script, main);
  }
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emitHandleCodeCoverageAtPrologue() {
  Label skipCoverage;
  CodeOffset toggleOffset = masm.toggledJump(&skipCoverage);
  masm.call(handler.codeCoverageAtPrologueLabel());
  masm.bind(&skipCoverage);
  return handler.codeCoverageOffsets().append(toggleOffset.offset());
}

template <>
void BaselineCompilerCodeGen::subtractScriptSlotsSize(Register reg,
                                                      Register scratch) {
  uint32_t slotsSize = handler.script()->nslots() * sizeof(Value);
  masm.subPtr(Imm32(slotsSize), reg);
}

template <>
void BaselineInterpreterCodeGen::subtractScriptSlotsSize(Register reg,
                                                         Register scratch) {
  // reg = reg - script->nslots() * sizeof(Value)
  MOZ_ASSERT(reg != scratch);
  loadScript(scratch);
  masm.loadPtr(Address(scratch, JSScript::offsetOfSharedData()), scratch);
  masm.loadPtr(Address(scratch, RuntimeScriptData::offsetOfISD()), scratch);
  masm.load32(Address(scratch, ImmutableScriptData::offsetOfNslots()), scratch);
  static_assert(sizeof(Value) == 8,
                "shift by 3 below assumes Value is 8 bytes");
  masm.lshiftPtr(Imm32(3), scratch);
  masm.subPtr(scratch, reg);
}

template <>
void BaselineCompilerCodeGen::loadGlobalLexicalEnvironment(Register dest) {
  masm.movePtr(ImmGCPtr(&cx->global()->lexicalEnvironment()), dest);
}

template <>
void BaselineInterpreterCodeGen::loadGlobalLexicalEnvironment(Register dest) {
  masm.loadPtr(AbsoluteAddress(cx->addressOfRealm()), dest);
  masm.loadPtr(Address(dest, Realm::offsetOfActiveLexicalEnvironment()), dest);
}

template <>
void BaselineCompilerCodeGen::pushGlobalLexicalEnvironmentValue(
    ValueOperand scratch) {
  frame.push(ObjectValue(cx->global()->lexicalEnvironment()));
}

template <>
void BaselineInterpreterCodeGen::pushGlobalLexicalEnvironmentValue(
    ValueOperand scratch) {
  loadGlobalLexicalEnvironment(scratch.scratchReg());
  masm.tagValue(JSVAL_TYPE_OBJECT, scratch.scratchReg(), scratch);
  frame.push(scratch);
}

template <>
void BaselineCompilerCodeGen::loadGlobalThisValue(ValueOperand dest) {
  masm.moveValue(cx->global()->lexicalEnvironment().thisValue(), dest);
}

template <>
void BaselineInterpreterCodeGen::loadGlobalThisValue(ValueOperand dest) {
  Register scratch = dest.scratchReg();
  loadGlobalLexicalEnvironment(scratch);
  static constexpr size_t SlotOffset =
      LexicalEnvironmentObject::offsetOfThisValueOrScopeSlot();
  masm.loadValue(Address(scratch, SlotOffset), dest);
}

template <>
void BaselineCompilerCodeGen::pushScriptArg() {
  pushArg(ImmGCPtr(handler.script()));
}

template <>
void BaselineInterpreterCodeGen::pushScriptArg() {
  pushArg(frame.addressOfInterpreterScript());
}

template <>
void BaselineCompilerCodeGen::pushBytecodePCArg() {
  pushArg(ImmPtr(handler.pc()));
}

template <>
void BaselineInterpreterCodeGen::pushBytecodePCArg() {
  if (HasInterpreterPCReg()) {
    pushArg(InterpreterPCReg);
  } else {
    pushArg(frame.addressOfInterpreterPC());
  }
}

static gc::Cell* GetScriptGCThing(JSScript* script, jsbytecode* pc,
                                  ScriptGCThingType type) {
  switch (type) {
    case ScriptGCThingType::Atom:
      return script->getAtom(pc);
    case ScriptGCThingType::RegExp:
      return script->getRegExp(pc);
    case ScriptGCThingType::Function:
      return script->getFunction(pc);
    case ScriptGCThingType::Scope:
      return script->getScope(pc);
    case ScriptGCThingType::BigInt:
      return script->getBigInt(pc);
  }
  MOZ_CRASH("Unexpected GCThing type");
}

template <>
void BaselineCompilerCodeGen::loadScriptGCThing(ScriptGCThingType type,
                                                Register dest,
                                                Register scratch) {
  gc::Cell* thing = GetScriptGCThing(handler.script(), handler.pc(), type);
  masm.movePtr(ImmGCPtr(thing), dest);
}

template <>
void BaselineInterpreterCodeGen::loadScriptGCThing(ScriptGCThingType type,
                                                   Register dest,
                                                   Register scratch) {
  MOZ_ASSERT(dest != scratch);

  // Load the index in |scratch|.
  LoadInt32Operand(masm, scratch);

  // Load the GCCellPtr.
  loadScript(dest);
  masm.loadPtr(Address(dest, JSScript::offsetOfPrivateData()), dest);
  masm.loadPtr(BaseIndex(dest, scratch, ScalePointer,
                         PrivateScriptData::offsetOfGCThings()),
               dest);

  // Clear the tag bits.
  switch (type) {
    case ScriptGCThingType::Atom:
      // Use xorPtr with a 32-bit immediate because it's more efficient than
      // andPtr on 64-bit.
      static_assert(uintptr_t(TraceKind::String) == 2,
                    "Unexpected tag bits for string GCCellPtr");
      masm.xorPtr(Imm32(2), dest);
      break;
    case ScriptGCThingType::RegExp:
    case ScriptGCThingType::Function:
      // No-op because GCCellPtr tag bits are zero for objects.
      static_assert(uintptr_t(TraceKind::Object) == 0,
                    "Unexpected tag bits for object GCCellPtr");
      break;
    case ScriptGCThingType::BigInt:
      // Use xorPtr with a 32-bit immediate because it's more efficient than
      // andPtr on 64-bit.
      static_assert(uintptr_t(TraceKind::BigInt) == 1,
                    "Unexpected tag bits for BigInt GCCellPtr");
      masm.xorPtr(Imm32(1), dest);
      break;
    case ScriptGCThingType::Scope:
      // Use xorPtr with a 32-bit immediate because it's more efficient than
      // andPtr on 64-bit.
      static_assert(uintptr_t(TraceKind::Scope) >= JS::OutOfLineTraceKindMask,
                    "Expected Scopes to have OutOfLineTraceKindMask tag");
      masm.xorPtr(Imm32(JS::OutOfLineTraceKindMask), dest);
      break;
  }

#ifdef DEBUG
  // Assert low bits are not set.
  Label ok;
  masm.branchTestPtr(Assembler::Zero, dest, Imm32(0b111), &ok);
  masm.assumeUnreachable("GC pointer with tag bits set");
  masm.bind(&ok);
#endif
}

template <>
void BaselineCompilerCodeGen::pushScriptGCThingArg(ScriptGCThingType type,
                                                   Register scratch1,
                                                   Register scratch2) {
  gc::Cell* thing = GetScriptGCThing(handler.script(), handler.pc(), type);
  pushArg(ImmGCPtr(thing));
}

template <>
void BaselineInterpreterCodeGen::pushScriptGCThingArg(ScriptGCThingType type,
                                                      Register scratch1,
                                                      Register scratch2) {
  loadScriptGCThing(type, scratch1, scratch2);
  pushArg(scratch1);
}

template <typename Handler>
void BaselineCodeGen<Handler>::pushScriptNameArg(Register scratch1,
                                                 Register scratch2) {
  pushScriptGCThingArg(ScriptGCThingType::Atom, scratch1, scratch2);
}

template <>
void BaselineCompilerCodeGen::pushUint8BytecodeOperandArg(Register) {
  MOZ_ASSERT(JOF_OPTYPE(JSOp(*handler.pc())) == JOF_UINT8);
  pushArg(Imm32(GET_UINT8(handler.pc())));
}

template <>
void BaselineInterpreterCodeGen::pushUint8BytecodeOperandArg(Register scratch) {
  LoadUint8Operand(masm, scratch);
  pushArg(scratch);
}

template <>
void BaselineCompilerCodeGen::pushUint16BytecodeOperandArg(Register) {
  MOZ_ASSERT(JOF_OPTYPE(JSOp(*handler.pc())) == JOF_UINT16);
  pushArg(Imm32(GET_UINT16(handler.pc())));
}

template <>
void BaselineInterpreterCodeGen::pushUint16BytecodeOperandArg(
    Register scratch) {
  LoadUint16Operand(masm, scratch);
  pushArg(scratch);
}

template <>
void BaselineCompilerCodeGen::loadInt32LengthBytecodeOperand(Register dest) {
  uint32_t length = GET_UINT32(handler.pc());
  MOZ_ASSERT(length <= INT32_MAX,
             "the bytecode emitter must fail to compile code that would "
             "produce a length exceeding int32_t range");
  masm.move32(Imm32(AssertedCast<int32_t>(length)), dest);
}

template <>
void BaselineInterpreterCodeGen::loadInt32LengthBytecodeOperand(Register dest) {
  LoadInt32Operand(masm, dest);
}

template <>
void BaselineCompilerCodeGen::loadInt32IndexBytecodeOperand(ValueOperand dest) {
  uint32_t index = GET_UINT32(handler.pc());
  MOZ_ASSERT(index <= INT32_MAX,
             "the bytecode emitter must fail to compile code that would "
             "produce an index exceeding int32_t range");
  masm.moveValue(Int32Value(AssertedCast<int32_t>(index)), dest);
}

template <>
void BaselineInterpreterCodeGen::loadInt32IndexBytecodeOperand(
    ValueOperand dest) {
  Register scratch = dest.scratchReg();
  LoadInt32Operand(masm, scratch);
  masm.tagValue(JSVAL_TYPE_INT32, scratch, dest);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitDebugPrologue() {
  auto ifDebuggee = [this]() {
    // Load pointer to BaselineFrame in R0.
    masm.loadBaselineFramePtr(BaselineFrameReg, R0.scratchReg());

    prepareVMCall();
    pushArg(R0.scratchReg());

    const RetAddrEntry::Kind kind = RetAddrEntry::Kind::DebugPrologue;

    using Fn = bool (*)(JSContext*, BaselineFrame*);
    if (!callVM<Fn, jit::DebugPrologue>(kind)) {
      return false;
    }

    return true;
  };
  return emitDebugInstrumentation(ifDebuggee);
}

template <>
void BaselineCompilerCodeGen::emitInitFrameFields(Register nonFunctionEnv) {
  masm.store32(Imm32(0), frame.addressOfFlags());
  if (handler.function()) {
    Register scratch = R0.scratchReg();
    masm.loadFunctionFromCalleeToken(frame.addressOfCalleeToken(), scratch);
    masm.loadPtr(Address(scratch, JSFunction::offsetOfEnvironment()), scratch);
    masm.storePtr(scratch, frame.addressOfEnvironmentChain());
  } else {
    masm.storePtr(nonFunctionEnv, frame.addressOfEnvironmentChain());
  }
}

template <>
void BaselineInterpreterCodeGen::emitInitFrameFields(Register nonFunctionEnv) {
  MOZ_ASSERT(nonFunctionEnv == R1.scratchReg(),
             "Don't clobber nonFunctionEnv below");

  // If we have a dedicated PC register we use it as scratch1 to avoid a
  // register move below.
  Register scratch1 =
      HasInterpreterPCReg() ? InterpreterPCReg : R0.scratchReg();
  Register scratch2 = R2.scratchReg();

  masm.store32(Imm32(BaselineFrame::RUNNING_IN_INTERPRETER),
               frame.addressOfFlags());

  // Initialize interpreterScript.
  Label notFunction, done;
  masm.loadPtr(frame.addressOfCalleeToken(), scratch1);
  masm.branchTestPtr(Assembler::NonZero, scratch1, Imm32(CalleeTokenScriptBit),
                     &notFunction);
  {
    // CalleeToken_Function or CalleeToken_FunctionConstructing.
    masm.andPtr(Imm32(uint32_t(CalleeTokenMask)), scratch1);
    masm.loadPtr(Address(scratch1, JSFunction::offsetOfEnvironment()),
                 scratch2);
    masm.storePtr(scratch2, frame.addressOfEnvironmentChain());
    masm.loadPtr(Address(scratch1, JSFunction::offsetOfScript()), scratch1);
    masm.jump(&done);
  }
  masm.bind(&notFunction);
  {
    // CalleeToken_Script.
    masm.andPtr(Imm32(uint32_t(CalleeTokenMask)), scratch1);
    masm.storePtr(nonFunctionEnv, frame.addressOfEnvironmentChain());
  }
  masm.bind(&done);
  masm.storePtr(scratch1, frame.addressOfInterpreterScript());

  // Initialize interpreterICEntry.
  masm.loadJitScript(scratch1, scratch2);
  masm.computeEffectiveAddress(
      Address(scratch2, JitScript::offsetOfICEntries()), scratch2);
  masm.storePtr(scratch2, frame.addressOfInterpreterICEntry());

  // Initialize interpreter pc.
  masm.loadPtr(Address(scratch1, JSScript::offsetOfSharedData()), scratch1);
  masm.loadPtr(Address(scratch1, RuntimeScriptData::offsetOfISD()), scratch1);
  masm.addPtr(Imm32(ImmutableScriptData::offsetOfCode()), scratch1);

  if (HasInterpreterPCReg()) {
    MOZ_ASSERT(scratch1 == InterpreterPCReg,
               "pc must be stored in the pc register");
  } else {
    masm.storePtr(scratch1, frame.addressOfInterpreterPC());
  }
}

template <>
template <typename F>
bool BaselineCompilerCodeGen::initEnvironmentChainHelper(
    const F& initFunctionEnv) {
  if (handler.function()) {
    return initFunctionEnv();
  }
  return true;
}

template <>
template <typename F>
bool BaselineInterpreterCodeGen::initEnvironmentChainHelper(
    const F& initFunctionEnv) {
  // For function scripts use the code emitted by initFunctionEnv. For other
  // scripts this is a no-op.

  Label done;
  masm.branchTestPtr(Assembler::NonZero, frame.addressOfCalleeToken(),
                     Imm32(CalleeTokenScriptBit), &done);
  {
    if (!initFunctionEnv()) {
      return false;
    }
  }

  masm.bind(&done);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::initEnvironmentChain() {
  auto initFunctionEnv = [this]() {
    auto initEnv = [this]() {
      // Call into the VM to create the proper environment objects.
      prepareVMCall();

      masm.loadBaselineFramePtr(BaselineFrameReg, R0.scratchReg());
      pushArg(R0.scratchReg());

      const CallVMPhase phase = CallVMPhase::BeforePushingLocals;

      using Fn = bool (*)(JSContext*, BaselineFrame*);
      return callVMNonOp<Fn, jit::InitFunctionEnvironmentObjects>(phase);
    };
    return emitTestScriptFlag(
        JSScript::ImmutableFlags::NeedsFunctionEnvironmentObjects, true,
        initEnv, R2.scratchReg());
  };

  return initEnvironmentChainHelper(initFunctionEnv);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitInterruptCheck() {
  frame.syncStack(0);

  Label done;
  masm.branch32(Assembler::Equal, AbsoluteAddress(cx->addressOfInterruptBits()),
                Imm32(0), &done);

  prepareVMCall();

  // Use a custom RetAddrEntry::Kind so DebugModeOSR can distinguish this call
  // from other callVMs that might happen at this pc.
  const RetAddrEntry::Kind kind = RetAddrEntry::Kind::InterruptCheck;

  using Fn = bool (*)(JSContext*);
  if (!callVM<Fn, InterruptCheck>(kind)) {
    return false;
  }

  masm.bind(&done);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emitWarmUpCounterIncrement() {
  frame.assertSyncedStack();

  // Record native code offset for OSR from Baseline Interpreter into Baseline
  // JIT code. This is right before the warm-up check in the Baseline JIT code,
  // to make sure we can immediately enter Ion if the script is warm enough or
  // if --ion-eager is used.
  JSScript* script = handler.script();
  jsbytecode* pc = handler.pc();
  if (JSOp(*pc) == JSOp::LoopHead) {
    uint32_t pcOffset = script->pcToOffset(pc);
    uint32_t nativeOffset = masm.currentOffset();
    if (!handler.osrEntries().emplaceBack(pcOffset, nativeOffset)) {
      ReportOutOfMemory(cx);
      return false;
    }
  }

  // Emit no warm-up counter increments if Ion is not enabled or if the script
  // will never be Ion-compileable.
  if (!handler.maybeIonCompileable()) {
    return true;
  }

  Register scriptReg = R2.scratchReg();
  Register countReg = R0.scratchReg();

  // Load the JitScript* in scriptReg.
  masm.movePtr(ImmPtr(script->jitScript()), scriptReg);

  // Bump warm-up counter.
  Address warmUpCounterAddr(scriptReg, JitScript::offsetOfWarmUpCount());
  masm.load32(warmUpCounterAddr, countReg);
  masm.add32(Imm32(1), countReg);
  masm.store32(countReg, warmUpCounterAddr);

  if (JSOp(*pc) == JSOp::LoopHead) {
    // If this is a loop inside a catch or finally block, increment the warmup
    // counter but don't attempt OSR (Ion only compiles the try block).
    if (handler.analysis().info(pc).loopHeadInCatchOrFinally) {
      return true;
    }
  }

  Label done;

  const OptimizationInfo* info =
      IonOptimizations.get(IonOptimizations.firstLevel());
  uint32_t warmUpThreshold = info->compilerWarmUpThreshold(script, pc);
  masm.branch32(Assembler::LessThan, countReg, Imm32(warmUpThreshold), &done);

  // Do nothing if Ion is already compiling this script off-thread or if Ion has
  // been disabled for this script.
  masm.loadPtr(Address(scriptReg, JitScript::offsetOfIonScript()), scriptReg);
  masm.branchPtr(Assembler::Equal, scriptReg, ImmPtr(IonCompilingScriptPtr),
                 &done);
  masm.branchPtr(Assembler::Equal, scriptReg, ImmPtr(IonDisabledScriptPtr),
                 &done);

  // Try to compile and/or finish a compilation.
  if (JSOp(*pc) == JSOp::LoopHead) {
    // Try to OSR into Ion.
    computeFrameSize(R0.scratchReg());

    prepareVMCall();

    pushBytecodePCArg();
    pushArg(R0.scratchReg());
    masm.PushBaselineFramePtr(BaselineFrameReg, R0.scratchReg());

    using Fn = bool (*)(JSContext*, BaselineFrame*, uint32_t, jsbytecode*,
                        IonOsrTempData**);
    if (!callVM<Fn, IonCompileScriptForBaselineOSR>()) {
      return false;
    }

    // The return register holds the IonOsrTempData*. Perform OSR if it's not
    // nullptr.
    static_assert(ReturnReg != OsrFrameReg,
                  "Code below depends on osrDataReg != OsrFrameReg");
    Register osrDataReg = ReturnReg;
    masm.branchTestPtr(Assembler::Zero, osrDataReg, osrDataReg, &done);

    // Success! Switch from Baseline JIT code to Ion JIT code.

    // At this point, stack looks like:
    //
    //  +-> [...Calling-Frame...]
    //  |   [...Actual-Args/ThisV/ArgCount/Callee...]
    //  |   [Descriptor]
    //  |   [Return-Addr]
    //  +---[Saved-FramePtr]
    //      [...Baseline-Frame...]

    // Restore the stack pointer so that the return address is on top of
    // the stack.
    masm.addToStackPtr(Imm32(frame.frameSize()));

#ifdef DEBUG
    // Get a scratch register that's not osrDataReg or OsrFrameReg.
    AllocatableGeneralRegisterSet regs(GeneralRegisterSet::All());
    regs.take(BaselineFrameReg);
    regs.take(osrDataReg);
    regs.take(OsrFrameReg);

    Register scratchReg = regs.takeAny();

    // If profiler instrumentation is on, ensure that lastProfilingFrame is
    // the frame currently being OSR-ed
    {
      Label checkOk;
      AbsoluteAddress addressOfEnabled(
          cx->runtime()->geckoProfiler().addressOfEnabled());
      masm.branch32(Assembler::Equal, addressOfEnabled, Imm32(0), &checkOk);
      masm.loadPtr(AbsoluteAddress((void*)&cx->jitActivation), scratchReg);
      masm.loadPtr(
          Address(scratchReg, JitActivation::offsetOfLastProfilingFrame()),
          scratchReg);

      // It may be the case that we entered the baseline frame with
      // profiling turned off on, then in a call within a loop (i.e. a
      // callee frame), turn on profiling, then return to this frame,
      // and then OSR with profiling turned on.  In this case, allow for
      // lastProfilingFrame to be null.
      masm.branchPtr(Assembler::Equal, scratchReg, ImmWord(0), &checkOk);

      masm.branchStackPtr(Assembler::Equal, scratchReg, &checkOk);
      masm.assumeUnreachable("Baseline OSR lastProfilingFrame mismatch.");
      masm.bind(&checkOk);
    }
#endif

    // Jump into Ion.
    masm.loadPtr(Address(osrDataReg, IonOsrTempData::offsetOfBaselineFrame()),
                 OsrFrameReg);
    masm.jump(Address(osrDataReg, IonOsrTempData::offsetOfJitCode()));
  } else {
    prepareVMCall();

    masm.PushBaselineFramePtr(BaselineFrameReg, R0.scratchReg());

    const RetAddrEntry::Kind kind = RetAddrEntry::Kind::WarmupCounter;

    using Fn = bool (*)(JSContext*, BaselineFrame*);
    if (!callVM<Fn, IonCompileScriptForBaselineAtEntry>(kind)) {
      return false;
    }
  }

  masm.bind(&done);
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emitWarmUpCounterIncrement() {
  Register scriptReg = R2.scratchReg();
  Register countReg = R0.scratchReg();

  // Load the JitScript* in scriptReg.
  loadScript(scriptReg);
  masm.loadJitScript(scriptReg, scriptReg);

  // Bump warm-up counter.
  Address warmUpCounterAddr(scriptReg, JitScript::offsetOfWarmUpCount());
  masm.load32(warmUpCounterAddr, countReg);
  masm.add32(Imm32(1), countReg);
  masm.store32(countReg, warmUpCounterAddr);

  // If the script is warm enough for Baseline compilation, call into the VM to
  // compile it.
  Label done;
  masm.branch32(Assembler::BelowOrEqual, countReg,
                Imm32(JitOptions.baselineJitWarmUpThreshold), &done);
  masm.branchPtr(Assembler::Equal,
                 Address(scriptReg, JitScript::offsetOfBaselineScript()),
                 ImmPtr(BaselineDisabledScriptPtr), &done);
  {
    prepareVMCall();

    masm.PushBaselineFramePtr(BaselineFrameReg, R0.scratchReg());

    using Fn = bool (*)(JSContext*, BaselineFrame*, uint8_t**);
    if (!callVM<Fn, BaselineCompileFromBaselineInterpreter>()) {
      return false;
    }

    // If the function returned nullptr we either skipped compilation or were
    // unable to compile the script. Continue running in the interpreter.
    masm.branchTestPtr(Assembler::Zero, ReturnReg, ReturnReg, &done);

    // Success! Switch from interpreter to JIT code by jumping to the
    // corresponding code in the BaselineScript.
    //
    // This works because BaselineCompiler uses the same frame layout (stack is
    // synced at OSR points) and BaselineCompileFromBaselineInterpreter has
    // already cleared the RUNNING_IN_INTERPRETER flag for us.
    // See BaselineFrame::prepareForBaselineInterpreterToJitOSR.
    masm.jump(ReturnReg);
  }

  masm.bind(&done);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emitArgumentTypeChecks() {
  if (!IsTypeInferenceEnabled()) {
    return true;
  }

  if (!handler.function()) {
    return true;
  }

  frame.pushThis();
  frame.popRegsAndSync(1);

  if (!emitNextIC()) {
    return false;
  }

  size_t nargs = handler.function()->nargs();

  for (size_t i = 0; i < nargs; i++) {
    frame.pushArg(i);
    frame.popRegsAndSync(1);

    if (!emitNextIC()) {
      return false;
    }
  }

  return true;
}

template <>
bool BaselineInterpreterCodeGen::emitArgumentTypeChecks() {
  if (!IsTypeInferenceEnabled()) {
    return true;
  }

  Register scratch1 = R1.scratchReg();

  // If the script is not a function, we're done.
  Label done;
  masm.loadPtr(frame.addressOfCalleeToken(), scratch1);
  masm.branchTestPtr(Assembler::NonZero, scratch1, Imm32(CalleeTokenScriptBit),
                     &done);

  // CalleeToken_Function or CalleeToken_FunctionConstructing.
  masm.andPtr(Imm32(uint32_t(CalleeTokenMask)), scratch1);

  // The frame's scratch slot is used to store two 32-bit values: nargs (lower
  // half) and the argument index (upper half).
  masm.load16ZeroExtend(Address(scratch1, JSFunction::offsetOfNargs()),
                        scratch1);
  masm.store32(scratch1, frame.addressOfScratchValueLow32());

  // Type check |this|.
  masm.loadValue(frame.addressOfThis(), R0);
  if (!emitNextIC()) {
    return false;
  }
  frame.bumpInterpreterICEntry();

  // Type check arguments. Scratch1 holds the next argument's index.
  masm.move32(Imm32(0), scratch1);

  // Bounds check.
  Label top;
  masm.bind(&top);
  masm.branch32(Assembler::Equal, frame.addressOfScratchValueLow32(), scratch1,
                &done);
  {
    // Load the argument, increment argument index and store the index in the
    // scratch slot.
    BaseValueIndex addr(BaselineFrameReg, scratch1,
                        BaselineFrame::offsetOfArg(0));
    masm.loadValue(addr, R0);
    masm.add32(Imm32(1), scratch1);
    masm.store32(scratch1, frame.addressOfScratchValueHigh32());

    // Type check the argument.
    if (!emitNextIC()) {
      return false;
    }
    frame.bumpInterpreterICEntry();

    // Restore argument index.
    masm.load32(frame.addressOfScratchValueHigh32(), scratch1);
    masm.jump(&top);
  }

  masm.bind(&done);
  return true;
}

bool BaselineCompiler::emitDebugTrap() {
  MOZ_ASSERT(compileDebugInstrumentation());
  MOZ_ASSERT(frame.numUnsyncedSlots() == 0);

  JSScript* script = handler.script();
  bool enabled = DebugAPI::stepModeEnabled(script) ||
                 DebugAPI::hasBreakpointsAt(script, handler.pc());

  // Emit patchable call to debug trap handler.
  JitCode* handlerCode = cx->runtime()->jitRuntime()->debugTrapHandler(
      cx, DebugTrapHandlerKind::Compiler);
  if (!handlerCode) {
    return false;
  }

  CodeOffset nativeOffset = masm.toggledCall(handlerCode, enabled);

  uint32_t pcOffset = script->pcToOffset(handler.pc());
  if (!debugTrapEntries_.emplaceBack(pcOffset, nativeOffset.offset())) {
    ReportOutOfMemory(cx);
    return false;
  }

  // Add a RetAddrEntry for the return offset -> pc mapping.
  return handler.recordCallRetAddr(cx, RetAddrEntry::Kind::DebugTrap,
                                   masm.currentOffset());
}

#ifdef JS_TRACE_LOGGING
template <>
bool BaselineCompilerCodeGen::emitTraceLoggerEnter() {
  AllocatableRegisterSet regs(RegisterSet::Volatile());
  Register loggerReg = regs.takeAnyGeneral();
  Register scriptReg = regs.takeAnyGeneral();

  Label noTraceLogger;
  if (!traceLoggerToggleOffsets_.append(masm.toggledJump(&noTraceLogger))) {
    return false;
  }

  masm.Push(loggerReg);
  masm.Push(scriptReg);

  masm.loadTraceLogger(loggerReg);

  // Script start.
  masm.movePtr(ImmPtr(handler.script()->jitScript()), scriptReg);
  masm.loadPtr(Address(scriptReg, JitScript::offsetOfBaselineScript()),
               scriptReg);
  Address scriptEvent(scriptReg,
                      BaselineScript::offsetOfTraceLoggerScriptEvent());
  masm.computeEffectiveAddress(scriptEvent, scriptReg);
  masm.tracelogStartEvent(loggerReg, scriptReg);

  // Engine start.
  masm.tracelogStartId(loggerReg, TraceLogger_Baseline, /* force = */ true);

  masm.Pop(scriptReg);
  masm.Pop(loggerReg);

  masm.bind(&noTraceLogger);

  return true;
}

template <>
bool BaselineInterpreterCodeGen::emitTraceLoggerEnter() {
  if (JS::TraceLoggerSupported()) {
    MOZ_CRASH("NYI: interpreter emitTraceLoggerEnter");
  }
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitTraceLoggerExit() {
  AllocatableRegisterSet regs(RegisterSet::Volatile());
  Register loggerReg = regs.takeAnyGeneral();

  Label noTraceLogger;
  if (!traceLoggerToggleOffsets_.append(masm.toggledJump(&noTraceLogger))) {
    return false;
  }

  masm.Push(loggerReg);
  masm.loadTraceLogger(loggerReg);

  masm.tracelogStopId(loggerReg, TraceLogger_Baseline, /* force = */ true);
  masm.tracelogStopId(loggerReg, TraceLogger_Scripts, /* force = */ true);

  masm.Pop(loggerReg);

  masm.bind(&noTraceLogger);

  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitTraceLoggerResume(
    Register baselineScript, AllocatableGeneralRegisterSet& regs) {
  Register scriptId = regs.takeAny();
  Register loggerReg = regs.takeAny();

  Label noTraceLogger;
  if (!traceLoggerToggleOffsets_.append(masm.toggledJump(&noTraceLogger))) {
    return false;
  }

  masm.loadTraceLogger(loggerReg);

  Address scriptEvent(baselineScript,
                      BaselineScript::offsetOfTraceLoggerScriptEvent());
  masm.computeEffectiveAddress(scriptEvent, scriptId);
  masm.tracelogStartEvent(loggerReg, scriptId);
  masm.tracelogStartId(loggerReg, TraceLogger_Baseline, /* force = */ true);

  regs.add(loggerReg);
  regs.add(scriptId);

  masm.bind(&noTraceLogger);

  return true;
}
#endif

template <typename Handler>
void BaselineCodeGen<Handler>::emitProfilerEnterFrame() {
  // Store stack position to lastProfilingFrame variable, guarded by a toggled
  // jump. Starts off initially disabled.
  Label noInstrument;
  CodeOffset toggleOffset = masm.toggledJump(&noInstrument);
  masm.profilerEnterFrame(masm.getStackPointer(), R0.scratchReg());
  masm.bind(&noInstrument);

  // Store the start offset in the appropriate location.
  MOZ_ASSERT(!profilerEnterFrameToggleOffset_.bound());
  profilerEnterFrameToggleOffset_ = toggleOffset;
}

template <typename Handler>
void BaselineCodeGen<Handler>::emitProfilerExitFrame() {
  // Store previous frame to lastProfilingFrame variable, guarded by a toggled
  // jump. Starts off initially disabled.
  Label noInstrument;
  CodeOffset toggleOffset = masm.toggledJump(&noInstrument);
  masm.profilerExitFrame();
  masm.bind(&noInstrument);

  // Store the start offset in the appropriate location.
  MOZ_ASSERT(!profilerExitFrameToggleOffset_.bound());
  profilerExitFrameToggleOffset_ = toggleOffset;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Nop() {
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_IterNext() {
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_NopDestructuring() {
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_TryDestructuring() {
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Pop() {
  frame.pop();
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_PopN() {
  frame.popn(GET_UINT16(handler.pc()));
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_PopN() {
  LoadUint16Operand(masm, R0.scratchReg());
  frame.popn(R0.scratchReg());
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_DupAt() {
  frame.syncStack(0);

  // DupAt takes a value on the stack and re-pushes it on top.  It's like
  // GetLocal but it addresses from the top of the stack instead of from the
  // stack frame.

  int depth = -(GET_UINT24(handler.pc()) + 1);
  masm.loadValue(frame.addressOfStackValue(depth), R0);
  frame.push(R0);
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_DupAt() {
  LoadUint24Operand(masm, 0, R0.scratchReg());
  masm.loadValue(frame.addressOfStackValue(R0.scratchReg()), R0);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Dup() {
  // Keep top stack value in R0, sync the rest so that we can use R1. We use
  // separate registers because every register can be used by at most one
  // StackValue.
  frame.popRegsAndSync(1);
  masm.moveValue(R0, R1);

  // inc/dec ops use Dup followed by Inc/Dec. Push R0 last to avoid a move.
  frame.push(R1);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Dup2() {
  frame.syncStack(0);

  masm.loadValue(frame.addressOfStackValue(-2), R0);
  masm.loadValue(frame.addressOfStackValue(-1), R1);

  frame.push(R0);
  frame.push(R1);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Swap() {
  // Keep top stack values in R0 and R1.
  frame.popRegsAndSync(2);

  frame.push(R1);
  frame.push(R0);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_Pick() {
  frame.syncStack(0);

  // Pick takes a value on the stack and moves it to the top.
  // For instance, pick 2:
  //     before: A B C D E
  //     after : A B D E C

  // First, move value at -(amount + 1) into R0.
  int32_t depth = -(GET_INT8(handler.pc()) + 1);
  masm.loadValue(frame.addressOfStackValue(depth), R0);

  // Move the other values down.
  depth++;
  for (; depth < 0; depth++) {
    Address source = frame.addressOfStackValue(depth);
    Address dest = frame.addressOfStackValue(depth - 1);
    masm.loadValue(source, R1);
    masm.storeValue(R1, dest);
  }

  // Push R0.
  frame.pop();
  frame.push(R0);
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_Pick() {
  // First, move the value to move up into R0.
  Register scratch = R2.scratchReg();
  LoadUint8Operand(masm, scratch);
  masm.loadValue(frame.addressOfStackValue(scratch), R0);

  // Move the other values down.
  Label top, done;
  masm.bind(&top);
  masm.branchSub32(Assembler::Signed, Imm32(1), scratch, &done);
  {
    masm.loadValue(frame.addressOfStackValue(scratch), R1);
    masm.storeValue(R1, frame.addressOfStackValue(scratch, sizeof(Value)));
    masm.jump(&top);
  }

  masm.bind(&done);

  // Replace value on top of the stack with R0.
  masm.storeValue(R0, frame.addressOfStackValue(-1));
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_Unpick() {
  frame.syncStack(0);

  // Pick takes the top of the stack value and moves it under the nth value.
  // For instance, unpick 2:
  //     before: A B C D E
  //     after : A B E C D

  // First, move value at -1 into R0.
  masm.loadValue(frame.addressOfStackValue(-1), R0);

  MOZ_ASSERT(GET_INT8(handler.pc()) > 0,
             "Interpreter code assumes JSOp::Unpick operand > 0");

  // Move the other values up.
  int32_t depth = -(GET_INT8(handler.pc()) + 1);
  for (int32_t i = -1; i > depth; i--) {
    Address source = frame.addressOfStackValue(i - 1);
    Address dest = frame.addressOfStackValue(i);
    masm.loadValue(source, R1);
    masm.storeValue(R1, dest);
  }

  // Store R0 under the nth value.
  Address dest = frame.addressOfStackValue(depth);
  masm.storeValue(R0, dest);
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_Unpick() {
  Register scratch = R2.scratchReg();
  LoadUint8Operand(masm, scratch);

  // Move the top value into R0.
  masm.loadValue(frame.addressOfStackValue(-1), R0);

  // Overwrite the nth stack value with R0 but first save the old value in R1.
  masm.loadValue(frame.addressOfStackValue(scratch), R1);
  masm.storeValue(R0, frame.addressOfStackValue(scratch));

  // Now for each slot x in [n-1, 1] do the following:
  //
  // * Store the value in slot x in R0.
  // * Store the value in the previous slot (now in R1) in slot x.
  // * Move R0 to R1.

#ifdef DEBUG
  // Assert the operand > 0 so the branchSub32 below doesn't "underflow" to
  // negative values.
  {
    Label ok;
    masm.branch32(Assembler::GreaterThan, scratch, Imm32(0), &ok);
    masm.assumeUnreachable("JSOp::Unpick with operand <= 0?");
    masm.bind(&ok);
  }
#endif

  Label top, done;
  masm.bind(&top);
  masm.branchSub32(Assembler::Zero, Imm32(1), scratch, &done);
  {
    // Overwrite stack slot x with slot x + 1, saving the old value in R1.
    masm.loadValue(frame.addressOfStackValue(scratch), R0);
    masm.storeValue(R1, frame.addressOfStackValue(scratch));
    masm.moveValue(R0, R1);
    masm.jump(&top);
  }

  // Finally, replace the value on top of the stack (slot 0) with R1. This is
  // the value that used to be in slot 1.
  masm.bind(&done);
  masm.storeValue(R1, frame.addressOfStackValue(-1));
  return true;
}

template <>
void BaselineCompilerCodeGen::emitJump() {
  jsbytecode* pc = handler.pc();
  MOZ_ASSERT(IsJumpOpcode(JSOp(*pc)));
  frame.assertSyncedStack();

  jsbytecode* target = pc + GET_JUMP_OFFSET(pc);
  masm.jump(handler.labelOf(target));
}

template <>
void BaselineInterpreterCodeGen::emitJump() {
  // We have to add the current pc's jump offset to the current pc. We can use
  // R0 and R1 as scratch because we jump to the "next op" label so these
  // registers aren't in use at this point.
  Register scratch1 = R0.scratchReg();
  Register scratch2 = R1.scratchReg();
  Register pc = LoadBytecodePC(masm, scratch1);
  LoadInt32OperandSignExtendToPtr(masm, pc, scratch2);
  if (HasInterpreterPCReg()) {
    masm.addPtr(scratch2, InterpreterPCReg);
  } else {
    masm.addPtr(pc, scratch2);
    masm.storePtr(scratch2, frame.addressOfInterpreterPC());
  }
  masm.jump(handler.interpretOpWithPCRegLabel());
}

template <>
void BaselineCompilerCodeGen::emitTestBooleanTruthy(bool branchIfTrue,
                                                    ValueOperand val) {
  jsbytecode* pc = handler.pc();
  MOZ_ASSERT(IsJumpOpcode(JSOp(*pc)));
  frame.assertSyncedStack();

  jsbytecode* target = pc + GET_JUMP_OFFSET(pc);
  masm.branchTestBooleanTruthy(branchIfTrue, val, handler.labelOf(target));
}

template <>
void BaselineInterpreterCodeGen::emitTestBooleanTruthy(bool branchIfTrue,
                                                       ValueOperand val) {
  Label done;
  masm.branchTestBooleanTruthy(!branchIfTrue, val, &done);
  emitJump();
  masm.bind(&done);
}

template <>
template <typename F1, typename F2>
MOZ_MUST_USE bool BaselineCompilerCodeGen::emitTestScriptFlag(
    JSScript::ImmutableFlags flag, const F1& ifSet, const F2& ifNotSet,
    Register scratch) {
  return handler.script()->hasFlag(flag) ? ifSet() : ifNotSet();
}

template <>
template <typename F1, typename F2>
MOZ_MUST_USE bool BaselineInterpreterCodeGen::emitTestScriptFlag(
    JSScript::ImmutableFlags flag, const F1& ifSet, const F2& ifNotSet,
    Register scratch) {
  Label flagNotSet, done;
  loadScript(scratch);
  masm.branchTest32(Assembler::Zero,
                    Address(scratch, JSScript::offsetOfImmutableFlags()),
                    Imm32(uint32_t(flag)), &flagNotSet);
  {
    if (!ifSet()) {
      return false;
    }
    masm.jump(&done);
  }
  masm.bind(&flagNotSet);
  {
    if (!ifNotSet()) {
      return false;
    }
  }

  masm.bind(&done);
  return true;
}

template <>
template <typename F>
MOZ_MUST_USE bool BaselineCompilerCodeGen::emitTestScriptFlag(
    JSScript::ImmutableFlags flag, bool value, const F& emit,
    Register scratch) {
  if (handler.script()->hasFlag(flag) == value) {
    return emit();
  }
  return true;
}

template <>
template <typename F>
MOZ_MUST_USE bool BaselineCompilerCodeGen::emitTestScriptFlag(
    JSScript::MutableFlags flag, bool value, const F& emit, Register scratch) {
  if (handler.script()->hasFlag(flag) == value) {
    return emit();
  }
  return true;
}

template <>
template <typename F>
MOZ_MUST_USE bool BaselineInterpreterCodeGen::emitTestScriptFlag(
    JSScript::ImmutableFlags flag, bool value, const F& emit,
    Register scratch) {
  Label done;
  loadScript(scratch);
  masm.branchTest32(value ? Assembler::Zero : Assembler::NonZero,
                    Address(scratch, JSScript::offsetOfImmutableFlags()),
                    Imm32(uint32_t(flag)), &done);
  {
    if (!emit()) {
      return false;
    }
  }

  masm.bind(&done);
  return true;
}

template <>
template <typename F>
MOZ_MUST_USE bool BaselineInterpreterCodeGen::emitTestScriptFlag(
    JSScript::MutableFlags flag, bool value, const F& emit, Register scratch) {
  Label done;
  loadScript(scratch);
  masm.branchTest32(value ? Assembler::Zero : Assembler::NonZero,
                    Address(scratch, JSScript::offsetOfMutableFlags()),
                    Imm32(uint32_t(flag)), &done);
  {
    if (!emit()) {
      return false;
    }
  }

  masm.bind(&done);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Goto() {
  frame.syncStack(0);
  emitJump();
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitToBoolean() {
  Label skipIC;
  masm.branchTestBoolean(Assembler::Equal, R0, &skipIC);

  // Call IC
  if (!emitNextIC()) {
    return false;
  }

  masm.bind(&skipIC);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitTest(bool branchIfTrue) {
  bool knownBoolean = frame.stackValueHasKnownType(-1, JSVAL_TYPE_BOOLEAN);

  // Keep top stack value in R0.
  frame.popRegsAndSync(1);

  if (!knownBoolean && !emitToBoolean()) {
    return false;
  }

  // IC will leave a BooleanValue in R0, just need to branch on it.
  emitTestBooleanTruthy(branchIfTrue, R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_IfEq() {
  return emitTest(false);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_IfNe() {
  return emitTest(true);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitAndOr(bool branchIfTrue) {
  bool knownBoolean = frame.stackValueHasKnownType(-1, JSVAL_TYPE_BOOLEAN);

  // And and Or leave the original value on the stack.
  frame.syncStack(0);

  masm.loadValue(frame.addressOfStackValue(-1), R0);
  if (!knownBoolean && !emitToBoolean()) {
    return false;
  }

  emitTestBooleanTruthy(branchIfTrue, R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_And() {
  return emitAndOr(false);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Or() {
  return emitAndOr(true);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Coalesce() {
  // Coalesce leaves the original value on the stack.
  frame.syncStack(0);

  masm.loadValue(frame.addressOfStackValue(-1), R0);

  Label undefinedOrNull;

  masm.branchTestUndefined(Assembler::Equal, R0, &undefinedOrNull);
  masm.branchTestNull(Assembler::Equal, R0, &undefinedOrNull);
  emitJump();

  masm.bind(&undefinedOrNull);
  // fall through
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Not() {
  bool knownBoolean = frame.stackValueHasKnownType(-1, JSVAL_TYPE_BOOLEAN);

  // Keep top stack value in R0.
  frame.popRegsAndSync(1);

  if (!knownBoolean && !emitToBoolean()) {
    return false;
  }

  masm.notBoolean(R0);

  frame.push(R0, JSVAL_TYPE_BOOLEAN);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Pos() {
  return emitUnaryArith();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_ToNumeric() {
  return emitUnaryArith();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_LoopHead() {
  if (!emit_JumpTarget()) {
    return false;
  }
  if (!emitInterruptCheck()) {
    return false;
  }
  if (!emitWarmUpCounterIncrement()) {
    return false;
  }
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Void() {
  frame.pop();
  frame.push(UndefinedValue());
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Undefined() {
  // If this ever changes, change what JSOp::GImplicitThis does too.
  frame.push(UndefinedValue());
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Hole() {
  frame.push(MagicValue(JS_ELEMENTS_HOLE));
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Null() {
  frame.push(NullValue());
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_CheckIsObj() {
  frame.syncStack(0);
  masm.loadValue(frame.addressOfStackValue(-1), R0);

  Label ok;
  masm.branchTestObject(Assembler::Equal, R0, &ok);

  prepareVMCall();

  pushUint8BytecodeOperandArg(R0.scratchReg());

  using Fn = bool (*)(JSContext*, CheckIsObjectKind);
  if (!callVM<Fn, ThrowCheckIsObject>()) {
    return false;
  }

  masm.bind(&ok);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_CheckThis() {
  frame.syncStack(0);
  masm.loadValue(frame.addressOfStackValue(-1), R0);

  return emitCheckThis(R0);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_CheckThisReinit() {
  frame.syncStack(0);
  masm.loadValue(frame.addressOfStackValue(-1), R0);

  return emitCheckThis(R0, /* reinit = */ true);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitCheckThis(ValueOperand val, bool reinit) {
  Label thisOK;
  if (reinit) {
    masm.branchTestMagic(Assembler::Equal, val, &thisOK);
  } else {
    masm.branchTestMagic(Assembler::NotEqual, val, &thisOK);
  }

  prepareVMCall();

  if (reinit) {
    using Fn = bool (*)(JSContext*);
    if (!callVM<Fn, ThrowInitializedThis>()) {
      return false;
    }
  } else {
    using Fn = bool (*)(JSContext*);
    if (!callVM<Fn, ThrowUninitializedThis>()) {
      return false;
    }
  }

  masm.bind(&thisOK);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_CheckReturn() {
  MOZ_ASSERT_IF(handler.maybeScript(),
                handler.maybeScript()->isDerivedClassConstructor());

  // Load |this| in R0, return value in R1.
  frame.popRegsAndSync(1);
  emitLoadReturnValue(R1);

  Label done, returnOK;
  masm.branchTestObject(Assembler::Equal, R1, &done);
  masm.branchTestUndefined(Assembler::Equal, R1, &returnOK);

  prepareVMCall();
  pushArg(R1);

  using Fn = bool (*)(JSContext*, HandleValue);
  if (!callVM<Fn, ThrowBadDerivedReturn>()) {
    return false;
  }
  masm.assumeUnreachable("Should throw on bad derived constructor return");

  masm.bind(&returnOK);

  if (!emitCheckThis(R0)) {
    return false;
  }

  // Store |this| in the return value slot.
  masm.storeValue(R0, frame.addressOfReturnValue());
  masm.or32(Imm32(BaselineFrame::HAS_RVAL), frame.addressOfFlags());

  masm.bind(&done);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_FunctionThis() {
  MOZ_ASSERT_IF(handler.maybeFunction(), !handler.maybeFunction()->isArrow());

  frame.pushThis();

  auto boxThis = [this]() {
    // Load |thisv| in R0. Skip the call if it's already an object.
    Label skipCall;
    frame.popRegsAndSync(1);
    masm.branchTestObject(Assembler::Equal, R0, &skipCall);

    prepareVMCall();
    masm.loadBaselineFramePtr(BaselineFrameReg, R1.scratchReg());

    pushArg(R1.scratchReg());

    using Fn = bool (*)(JSContext*, BaselineFrame*, MutableHandleValue);
    if (!callVM<Fn, BaselineGetFunctionThis>()) {
      return false;
    }

    masm.bind(&skipCall);
    frame.push(R0);
    return true;
  };

  // In strict mode code, |this| is left alone.
  return emitTestScriptFlag(JSScript::ImmutableFlags::Strict, false, boxThis,
                            R2.scratchReg());
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_GlobalThis() {
  frame.syncStack(0);

  auto getNonSyntacticThis = [this]() {
    prepareVMCall();

    masm.loadPtr(frame.addressOfEnvironmentChain(), R0.scratchReg());
    pushArg(R0.scratchReg());

    using Fn = void (*)(JSContext*, HandleObject, MutableHandleValue);
    if (!callVM<Fn, GetNonSyntacticGlobalThis>()) {
      return false;
    }

    frame.push(R0);
    return true;
  };
  auto getGlobalThis = [this]() {
    loadGlobalThisValue(R0);
    frame.push(R0);
    return true;
  };
  return emitTestScriptFlag(JSScript::ImmutableFlags::HasNonSyntacticScope,
                            getNonSyntacticThis, getGlobalThis,
                            R2.scratchReg());
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_True() {
  frame.push(BooleanValue(true));
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_False() {
  frame.push(BooleanValue(false));
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Zero() {
  frame.push(Int32Value(0));
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_One() {
  frame.push(Int32Value(1));
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_Int8() {
  frame.push(Int32Value(GET_INT8(handler.pc())));
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_Int8() {
  LoadInt8Operand(masm, R0.scratchReg());
  masm.tagValue(JSVAL_TYPE_INT32, R0.scratchReg(), R0);
  frame.push(R0);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_Int32() {
  frame.push(Int32Value(GET_INT32(handler.pc())));
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_Int32() {
  LoadInt32Operand(masm, R0.scratchReg());
  masm.tagValue(JSVAL_TYPE_INT32, R0.scratchReg(), R0);
  frame.push(R0);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_Uint16() {
  frame.push(Int32Value(GET_UINT16(handler.pc())));
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_Uint16() {
  LoadUint16Operand(masm, R0.scratchReg());
  masm.tagValue(JSVAL_TYPE_INT32, R0.scratchReg(), R0);
  frame.push(R0);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_Uint24() {
  frame.push(Int32Value(GET_UINT24(handler.pc())));
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_Uint24() {
  LoadUint24Operand(masm, 0, R0.scratchReg());
  masm.tagValue(JSVAL_TYPE_INT32, R0.scratchReg(), R0);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_ResumeIndex() {
  return emit_Uint24();
}

template <>
bool BaselineCompilerCodeGen::emit_Double() {
  frame.push(GET_INLINE_VALUE(handler.pc()));
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_Double() {
  LoadInlineValueOperand(masm, R0);
  frame.push(R0);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_BigInt() {
  BigInt* bi = handler.script()->getBigInt(handler.pc());
  frame.push(BigIntValue(bi));
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_BigInt() {
  Register scratch1 = R0.scratchReg();
  Register scratch2 = R1.scratchReg();
  loadScriptGCThing(ScriptGCThingType::BigInt, scratch1, scratch2);
  masm.tagValue(JSVAL_TYPE_BIGINT, scratch1, R0);
  frame.push(R0);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_String() {
  frame.push(StringValue(handler.script()->getAtom(handler.pc())));
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_String() {
  Register scratch1 = R0.scratchReg();
  Register scratch2 = R1.scratchReg();
  loadScriptGCThing(ScriptGCThingType::Atom, scratch1, scratch2);
  masm.tagValue(JSVAL_TYPE_STRING, scratch1, R0);
  frame.push(R0);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_Symbol() {
  unsigned which = GET_UINT8(handler.pc());
  JS::Symbol* sym = cx->runtime()->wellKnownSymbols->get(which);
  frame.push(SymbolValue(sym));
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_Symbol() {
  Register scratch1 = R0.scratchReg();
  Register scratch2 = R1.scratchReg();
  LoadUint8Operand(masm, scratch1);

  masm.movePtr(ImmPtr(cx->runtime()->wellKnownSymbols), scratch2);
  masm.loadPtr(BaseIndex(scratch2, scratch1, ScalePointer), scratch1);

  masm.tagValue(JSVAL_TYPE_SYMBOL, scratch1, R0);
  frame.push(R0);
  return true;
}

JSObject* BaselineCompilerHandler::maybeNoCloneSingletonObject() {
  Realm* realm = script()->realm();
  if (realm->creationOptions().cloneSingletons()) {
    return nullptr;
  }

  realm->behaviors().setSingletonsAsValues();
  return script()->getObject(pc());
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Object() {
  // If we know we don't have to clone the object literal, just push it
  // directly. Note that the interpreter always does the VM call; that's fine
  // because this op is only used in run-once code.
  if (JSObject* obj = handler.maybeNoCloneSingletonObject()) {
    frame.push(ObjectValue(*obj));
    return true;
  }

  prepareVMCall();

  pushBytecodePCArg();
  pushScriptArg();

  using Fn = JSObject* (*)(JSContext*, HandleScript, jsbytecode*);
  if (!callVM<Fn, SingletonObjectLiteralOperation>()) {
    return false;
  }

  // Box and push return value.
  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.push(R0);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_CallSiteObj() {
  RootedScript script(cx, handler.script());
  JSObject* cso = ProcessCallSiteObjOperation(cx, script, handler.pc());
  if (!cso) {
    return false;
  }

  frame.push(ObjectValue(*cso));
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_CallSiteObj() {
  prepareVMCall();

  pushBytecodePCArg();
  pushScriptArg();

  using Fn = ArrayObject* (*)(JSContext*, HandleScript, jsbytecode*);
  if (!callVM<Fn, ProcessCallSiteObjOperation>()) {
    return false;
  }

  // Box and push return value.
  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_RegExp() {
  prepareVMCall();
  pushScriptGCThingArg(ScriptGCThingType::RegExp, R0.scratchReg(),
                       R1.scratchReg());

  using Fn = JSObject* (*)(JSContext*, Handle<RegExpObject*>);
  if (!callVM<Fn, CloneRegExpObject>()) {
    return false;
  }

  // Box and push return value.
  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Lambda() {
  prepareVMCall();
  masm.loadPtr(frame.addressOfEnvironmentChain(), R0.scratchReg());

  pushArg(R0.scratchReg());
  pushScriptGCThingArg(ScriptGCThingType::Function, R0.scratchReg(),
                       R1.scratchReg());

  using Fn = JSObject* (*)(JSContext*, HandleFunction, HandleObject);
  if (!callVM<Fn, js::Lambda>()) {
    return false;
  }

  // Box and push return value.
  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_LambdaArrow() {
  // Keep pushed newTarget in R0.
  frame.popRegsAndSync(1);

  prepareVMCall();
  masm.loadPtr(frame.addressOfEnvironmentChain(), R2.scratchReg());

  pushArg(R0);
  pushArg(R2.scratchReg());
  pushScriptGCThingArg(ScriptGCThingType::Function, R0.scratchReg(),
                       R1.scratchReg());

  using Fn =
      JSObject* (*)(JSContext*, HandleFunction, HandleObject, HandleValue);
  if (!callVM<Fn, js::LambdaArrow>()) {
    return false;
  }

  // Box and push return value.
  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_SetFunName() {
  frame.popRegsAndSync(2);

  frame.push(R0);
  frame.syncStack(0);

  masm.unboxObject(R0, R0.scratchReg());

  prepareVMCall();

  pushUint8BytecodeOperandArg(R2.scratchReg());
  pushArg(R1);
  pushArg(R0.scratchReg());

  using Fn =
      bool (*)(JSContext*, HandleFunction, HandleValue, FunctionPrefixKind);
  return callVM<Fn, SetFunctionName>();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_BitOr() {
  return emitBinaryArith();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_BitXor() {
  return emitBinaryArith();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_BitAnd() {
  return emitBinaryArith();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Lsh() {
  return emitBinaryArith();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Rsh() {
  return emitBinaryArith();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Ursh() {
  return emitBinaryArith();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Add() {
  return emitBinaryArith();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Sub() {
  return emitBinaryArith();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Mul() {
  return emitBinaryArith();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Div() {
  return emitBinaryArith();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Mod() {
  return emitBinaryArith();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Pow() {
  return emitBinaryArith();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitBinaryArith() {
  // Keep top JSStack value in R0 and R2
  frame.popRegsAndSync(2);

  // Call IC
  if (!emitNextIC()) {
    return false;
  }

  // Mark R0 as pushed stack value.
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitUnaryArith() {
  // Keep top stack value in R0.
  frame.popRegsAndSync(1);

  // Call IC
  if (!emitNextIC()) {
    return false;
  }

  // Mark R0 as pushed stack value.
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_BitNot() {
  return emitUnaryArith();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Neg() {
  return emitUnaryArith();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Inc() {
  return emitUnaryArith();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Dec() {
  return emitUnaryArith();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Lt() {
  return emitCompare();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Le() {
  return emitCompare();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Gt() {
  return emitCompare();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Ge() {
  return emitCompare();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Eq() {
  return emitCompare();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Ne() {
  return emitCompare();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitCompare() {
  // CODEGEN

  // Keep top JSStack value in R0 and R1.
  frame.popRegsAndSync(2);

  // Call IC.
  if (!emitNextIC()) {
    return false;
  }

  // Mark R0 as pushed stack value.
  frame.push(R0, JSVAL_TYPE_BOOLEAN);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_StrictEq() {
  return emitCompare();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_StrictNe() {
  return emitCompare();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Case() {
  frame.popRegsAndSync(1);

  Label done;
  masm.branchTestBooleanTruthy(/* branchIfTrue */ false, R0, &done);
  {
    // Pop the switch value if the case matches.
    masm.addToStackPtr(Imm32(sizeof(Value)));
    emitJump();
  }
  masm.bind(&done);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Default() {
  frame.pop();
  return emit_Goto();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Lineno() {
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_NewArray() {
  frame.syncStack(0);

  // Pass length in R0.
  loadInt32LengthBytecodeOperand(R0.scratchReg());

  if (!emitNextIC()) {
    return false;
  }

  frame.push(R0);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_NewArrayCopyOnWrite() {
  // This is like the interpreter implementation, but we can call
  // getOrFixupCopyOnWriteObject at compile-time.

  RootedScript scriptRoot(cx, handler.script());
  JSObject* obj =
      ObjectGroup::getOrFixupCopyOnWriteObject(cx, scriptRoot, handler.pc());
  if (!obj) {
    return false;
  }

  prepareVMCall();

  pushArg(ImmGCPtr(obj));

  using Fn = ArrayObject* (*)(JSContext*, HandleArrayObject);
  if (!callVM<Fn, js::NewDenseCopyOnWriteArray>()) {
    return false;
  }

  // Box and push return value.
  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.push(R0);
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_NewArrayCopyOnWrite() {
  prepareVMCall();

  pushBytecodePCArg();
  pushScriptArg();

  using Fn = ArrayObject* (*)(JSContext*, HandleScript, jsbytecode*);
  if (!callVM<Fn, NewArrayCopyOnWriteOperation>()) {
    return false;
  }

  // Box and push return value.
  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitElemArray() {
  // Keep the object and rhs on the stack.
  frame.syncStack(0);

  // Load object in R0, index in R1.
  masm.loadValue(frame.addressOfStackValue(-2), R0);
  loadInt32IndexBytecodeOperand(R1);

  // Call IC.
  if (!emitNextIC()) {
    return false;
  }

  // Pop the rhs, so that the object is on the top of the stack.
  frame.pop();
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_NewObject() {
  return emitNewObject();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_NewObjectWithGroup() {
  return emitNewObject();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_NewInit() {
  return emitNewObject();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitNewObject() {
  frame.syncStack(0);

  if (!emitNextIC()) {
    return false;
  }

  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitElem() {
  // Store RHS in the scratch slot.
  frame.storeStackValue(-1, frame.addressOfScratchValue(), R2);
  frame.pop();

  // Keep object and index in R0 and R1.
  frame.popRegsAndSync(2);

  // Push the object to store the result of the IC.
  frame.push(R0);
  frame.syncStack(0);

  // Keep RHS on the stack.
  frame.pushScratchValue();

  // Call IC.
  if (!emitNextIC()) {
    return false;
  }

  // Pop the rhs, so that the object is on the top of the stack.
  frame.pop();
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitHiddenElem() {
  return emit_InitElem();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_MutateProto() {
  // Keep values on the stack for the decompiler.
  frame.syncStack(0);

  masm.unboxObject(frame.addressOfStackValue(-2), R0.scratchReg());
  masm.loadValue(frame.addressOfStackValue(-1), R1);

  prepareVMCall();

  pushArg(R1);
  pushArg(R0.scratchReg());

  using Fn = bool (*)(JSContext*, HandlePlainObject, HandleValue);
  if (!callVM<Fn, MutatePrototype>()) {
    return false;
  }

  frame.pop();
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitProp() {
  // Load lhs in R0, rhs in R1.
  frame.syncStack(0);
  masm.loadValue(frame.addressOfStackValue(-2), R0);
  masm.loadValue(frame.addressOfStackValue(-1), R1);

  // Call IC.
  if (!emitNextIC()) {
    return false;
  }

  // Leave the object on the stack.
  frame.pop();
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitLockedProp() {
  return emit_InitProp();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitHiddenProp() {
  return emit_InitProp();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_GetElem() {
  // Keep top two stack values in R0 and R1.
  frame.popRegsAndSync(2);

  // Call IC.
  if (!emitNextIC()) {
    return false;
  }

  // Mark R0 as pushed stack value.
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_GetElemSuper() {
  // Store obj in the scratch slot.
  frame.storeStackValue(-1, frame.addressOfScratchValue(), R2);
  frame.pop();

  // Keep receiver and index in R0 and R1.
  frame.popRegsAndSync(2);

  // Keep obj on the stack.
  frame.pushScratchValue();

  if (!emitNextIC()) {
    return false;
  }

  frame.pop();
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_CallElem() {
  return emit_GetElem();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_SetElem() {
  // Store RHS in the scratch slot.
  frame.storeStackValue(-1, frame.addressOfScratchValue(), R2);
  frame.pop();

  // Keep object and index in R0 and R1.
  frame.popRegsAndSync(2);

  // Keep RHS on the stack.
  frame.pushScratchValue();

  // Call IC.
  if (!emitNextIC()) {
    return false;
  }

  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_StrictSetElem() {
  return emit_SetElem();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitSetElemSuper(bool strict) {
  // Incoming stack is |receiver, propval, obj, rval|. We need to shuffle
  // stack to leave rval when operation is complete.

  // Pop rval into R0, then load receiver into R1 and replace with rval.
  frame.popRegsAndSync(1);
  masm.loadValue(frame.addressOfStackValue(-3), R1);
  masm.storeValue(R0, frame.addressOfStackValue(-3));

  prepareVMCall();

  pushArg(Imm32(strict));
  pushArg(R1);  // receiver
  pushArg(R0);  // rval
  masm.loadValue(frame.addressOfStackValue(-2), R0);
  pushArg(R0);  // propval
  masm.unboxObject(frame.addressOfStackValue(-1), R0.scratchReg());
  pushArg(R0.scratchReg());  // obj

  using Fn = bool (*)(JSContext*, HandleObject, HandleValue, HandleValue,
                      HandleValue, bool);
  if (!callVM<Fn, js::SetObjectElementWithReceiver>()) {
    return false;
  }

  frame.popn(2);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_SetElemSuper() {
  return emitSetElemSuper(/* strict = */ false);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_StrictSetElemSuper() {
  return emitSetElemSuper(/* strict = */ true);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitDelElem(bool strict) {
  // Keep values on the stack for the decompiler.
  frame.syncStack(0);
  masm.loadValue(frame.addressOfStackValue(-2), R0);
  masm.loadValue(frame.addressOfStackValue(-1), R1);

  prepareVMCall();

  pushArg(R1);
  pushArg(R0);

  using Fn = bool (*)(JSContext*, HandleValue, HandleValue, bool*);
  if (strict) {
    if (!callVM<Fn, DelElemOperation<true>>()) {
      return false;
    }
  } else {
    if (!callVM<Fn, DelElemOperation<false>>()) {
      return false;
    }
  }

  masm.boxNonDouble(JSVAL_TYPE_BOOLEAN, ReturnReg, R1);
  frame.popn(2);
  frame.push(R1);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_DelElem() {
  return emitDelElem(/* strict = */ false);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_StrictDelElem() {
  return emitDelElem(/* strict = */ true);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_In() {
  frame.popRegsAndSync(2);

  if (!emitNextIC()) {
    return false;
  }

  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_HasOwn() {
  frame.popRegsAndSync(2);

  if (!emitNextIC()) {
    return false;
  }

  frame.push(R0);
  return true;
}

template <>
bool BaselineCompilerCodeGen::tryOptimizeGetGlobalName() {
  PropertyName* name = handler.script()->getName(handler.pc());

  // These names are non-configurable on the global and cannot be shadowed.
  if (name == cx->names().undefined) {
    frame.push(UndefinedValue());
    return true;
  }
  if (name == cx->names().NaN) {
    frame.push(JS::NaNValue());
    return true;
  }
  if (name == cx->names().Infinity) {
    frame.push(JS::InfinityValue());
    return true;
  }

  return false;
}

template <>
bool BaselineInterpreterCodeGen::tryOptimizeGetGlobalName() {
  // Interpreter doesn't optimize simple GETGNAMEs.
  return false;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_GetGName() {
  auto getName = [this]() { return emit_GetName(); };

  auto getGlobalName = [this]() {
    if (tryOptimizeGetGlobalName()) {
      return true;
    }

    frame.syncStack(0);

    loadGlobalLexicalEnvironment(R0.scratchReg());

    // Call IC.
    if (!emitNextIC()) {
      return false;
    }

    // Mark R0 as pushed stack value.
    frame.push(R0);
    return true;
  };
  return emitTestScriptFlag(JSScript::ImmutableFlags::HasNonSyntacticScope,
                            getName, getGlobalName, R2.scratchReg());
}

template <>
bool BaselineCompilerCodeGen::tryOptimizeBindGlobalName() {
  JSScript* script = handler.script();
  if (script->hasNonSyntacticScope()) {
    return false;
  }

  // We can bind name to the global lexical scope if the binding already
  // exists, is initialized, and is writable (i.e., an initialized
  // 'let') at compile time.
  RootedPropertyName name(cx, script->getName(handler.pc()));
  Rooted<LexicalEnvironmentObject*> env(cx,
                                        &script->global().lexicalEnvironment());
  if (Shape* shape = env->lookup(cx, name)) {
    if (shape->writable() &&
        !env->getSlot(shape->slot()).isMagic(JS_UNINITIALIZED_LEXICAL)) {
      frame.push(ObjectValue(*env));
      return true;
    }
    return false;
  }

  if (Shape* shape = script->global().lookup(cx, name)) {
    // If the property does not currently exist on the global lexical
    // scope, we can bind name to the global object if the property
    // exists on the global and is non-configurable, as then it cannot
    // be shadowed.
    if (!shape->configurable()) {
      frame.push(ObjectValue(script->global()));
      return true;
    }
  }

  return false;
}

template <>
bool BaselineInterpreterCodeGen::tryOptimizeBindGlobalName() {
  // Interpreter doesn't optimize simple BINDGNAMEs.
  return false;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_BindGName() {
  if (tryOptimizeBindGlobalName()) {
    return true;
  }
  return emitBindName(JSOp::BindGName);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_BindVar() {
  frame.syncStack(0);
  masm.loadPtr(frame.addressOfEnvironmentChain(), R0.scratchReg());

  prepareVMCall();
  pushArg(R0.scratchReg());

  using Fn = JSObject* (*)(JSContext*, JSObject*);
  if (!callVM<Fn, BindVarOperation>()) {
    return false;
  }

  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_SetProp() {
  // Keep lhs in R0, rhs in R1.
  frame.popRegsAndSync(2);

  // Keep RHS on the stack.
  frame.push(R1);
  frame.syncStack(0);

  // Call IC.
  if (!emitNextIC()) {
    return false;
  }

  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_StrictSetProp() {
  return emit_SetProp();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_SetName() {
  return emit_SetProp();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_StrictSetName() {
  return emit_SetProp();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_SetGName() {
  return emit_SetProp();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_StrictSetGName() {
  return emit_SetProp();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitSetPropSuper(bool strict) {
  // Incoming stack is |receiver, obj, rval|. We need to shuffle stack to
  // leave rval when operation is complete.

  // Pop rval into R0, then load receiver into R1 and replace with rval.
  frame.popRegsAndSync(1);
  masm.loadValue(frame.addressOfStackValue(-2), R1);
  masm.storeValue(R0, frame.addressOfStackValue(-2));

  prepareVMCall();

  pushArg(Imm32(strict));
  pushArg(R0);  // rval
  pushScriptNameArg(R0.scratchReg(), R2.scratchReg());
  pushArg(R1);  // receiver
  masm.unboxObject(frame.addressOfStackValue(-1), R0.scratchReg());
  pushArg(R0.scratchReg());  // obj

  using Fn = bool (*)(JSContext*, HandleObject, HandleValue, HandlePropertyName,
                      HandleValue, bool);
  if (!callVM<Fn, js::SetPropertySuper>()) {
    return false;
  }

  frame.pop();
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_SetPropSuper() {
  return emitSetPropSuper(/* strict = */ false);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_StrictSetPropSuper() {
  return emitSetPropSuper(/* strict = */ true);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_GetProp() {
  // Keep object in R0.
  frame.popRegsAndSync(1);

  // Call IC.
  if (!emitNextIC()) {
    return false;
  }

  // Mark R0 as pushed stack value.
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_CallProp() {
  return emit_GetProp();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Length() {
  return emit_GetProp();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_GetBoundName() {
  return emit_GetProp();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_GetPropSuper() {
  // Receiver -> R1, Object -> R0
  frame.popRegsAndSync(1);
  masm.loadValue(frame.addressOfStackValue(-1), R1);
  frame.pop();

  if (!emitNextIC()) {
    return false;
  }

  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitDelProp(bool strict) {
  // Keep value on the stack for the decompiler.
  frame.syncStack(0);
  masm.loadValue(frame.addressOfStackValue(-1), R0);

  prepareVMCall();

  pushScriptNameArg(R1.scratchReg(), R2.scratchReg());
  pushArg(R0);

  using Fn = bool (*)(JSContext*, HandleValue, HandlePropertyName, bool*);
  if (strict) {
    if (!callVM<Fn, DelPropOperation<true>>()) {
      return false;
    }
  } else {
    if (!callVM<Fn, DelPropOperation<false>>()) {
      return false;
    }
  }

  masm.boxNonDouble(JSVAL_TYPE_BOOLEAN, ReturnReg, R1);
  frame.pop();
  frame.push(R1);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_DelProp() {
  return emitDelProp(/* strict = */ false);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_StrictDelProp() {
  return emitDelProp(/* strict = */ true);
}

template <>
void BaselineCompilerCodeGen::getEnvironmentCoordinateObject(Register reg) {
  EnvironmentCoordinate ec(handler.pc());

  masm.loadPtr(frame.addressOfEnvironmentChain(), reg);
  for (unsigned i = ec.hops(); i; i--) {
    masm.unboxObject(
        Address(reg, EnvironmentObject::offsetOfEnclosingEnvironment()), reg);
  }
}

template <>
void BaselineInterpreterCodeGen::getEnvironmentCoordinateObject(Register reg) {
  MOZ_CRASH("Shouldn't call this for interpreter");
}

template <>
Address BaselineCompilerCodeGen::getEnvironmentCoordinateAddressFromObject(
    Register objReg, Register reg) {
  EnvironmentCoordinate ec(handler.pc());

  if (EnvironmentObject::nonExtensibleIsFixedSlot(ec)) {
    return Address(objReg, NativeObject::getFixedSlotOffset(ec.slot()));
  }

  uint32_t slot = EnvironmentObject::nonExtensibleDynamicSlotIndex(ec);
  masm.loadPtr(Address(objReg, NativeObject::offsetOfSlots()), reg);
  return Address(reg, slot * sizeof(Value));
}

template <>
Address BaselineInterpreterCodeGen::getEnvironmentCoordinateAddressFromObject(
    Register objReg, Register reg) {
  MOZ_CRASH("Shouldn't call this for interpreter");
}

template <typename Handler>
Address BaselineCodeGen<Handler>::getEnvironmentCoordinateAddress(
    Register reg) {
  getEnvironmentCoordinateObject(reg);
  return getEnvironmentCoordinateAddressFromObject(reg, reg);
}

// For a JOF_ENVCOORD op load the number of hops from the bytecode and skip this
// number of environment objects.
static void LoadAliasedVarEnv(MacroAssembler& masm, Register env,
                              Register scratch) {
  static_assert(ENVCOORD_HOPS_LEN == 1,
                "Code assumes number of hops is stored in uint8 operand");
  LoadUint8Operand(masm, scratch);

  Label top, done;
  masm.branchTest32(Assembler::Zero, scratch, scratch, &done);
  masm.bind(&top);
  {
    Address nextEnv(env, EnvironmentObject::offsetOfEnclosingEnvironment());
    masm.unboxObject(nextEnv, env);
    masm.branchSub32(Assembler::NonZero, Imm32(1), scratch, &top);
  }
  masm.bind(&done);
}

template <>
void BaselineCompilerCodeGen::emitGetAliasedVar(ValueOperand dest) {
  frame.syncStack(0);

  Address address = getEnvironmentCoordinateAddress(R0.scratchReg());
  masm.loadValue(address, dest);
}

template <>
void BaselineInterpreterCodeGen::emitGetAliasedVar(ValueOperand dest) {
  Register env = R0.scratchReg();
  Register scratch = R1.scratchReg();

  // Load the right environment object.
  masm.loadPtr(frame.addressOfEnvironmentChain(), env);
  LoadAliasedVarEnv(masm, env, scratch);

  // Load the slot index.
  static_assert(ENVCOORD_SLOT_LEN == 3,
                "Code assumes slot is stored in uint24 operand");
  LoadUint24Operand(masm, ENVCOORD_HOPS_LEN, scratch);

  // Load the Value from a fixed or dynamic slot.
  // See EnvironmentObject::nonExtensibleIsFixedSlot.
  Label isDynamic, done;
  masm.branch32(Assembler::AboveOrEqual, scratch,
                Imm32(NativeObject::MAX_FIXED_SLOTS), &isDynamic);
  {
    uint32_t offset = NativeObject::getFixedSlotOffset(0);
    masm.loadValue(BaseValueIndex(env, scratch, offset), dest);
    masm.jump(&done);
  }
  masm.bind(&isDynamic);
  {
    masm.loadPtr(Address(env, NativeObject::offsetOfSlots()), env);

    // Use an offset to subtract the number of fixed slots.
    int32_t offset = -int32_t(NativeObject::MAX_FIXED_SLOTS * sizeof(Value));
    masm.loadValue(BaseValueIndex(env, scratch, offset), dest);
  }
  masm.bind(&done);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_GetAliasedVar() {
  emitGetAliasedVar(R0);

  if (IsTypeInferenceEnabled() && handler.maybeIonCompileable()) {
    // No need to monitor types if we know Ion can't compile this script.
    if (!emitNextIC()) {
      return false;
    }
  }

  frame.push(R0);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_SetAliasedVar() {
  // Keep rvalue in R0.
  frame.popRegsAndSync(1);
  Register objReg = R2.scratchReg();

  getEnvironmentCoordinateObject(objReg);
  Address address =
      getEnvironmentCoordinateAddressFromObject(objReg, R1.scratchReg());
  masm.guardedCallPreBarrier(address, MIRType::Value);
  masm.storeValue(R0, address);
  frame.push(R0);

  // Only R0 is live at this point.
  // Scope coordinate object is already in R2.scratchReg().
  Register temp = R1.scratchReg();

  Label skipBarrier;
  masm.branchPtrInNurseryChunk(Assembler::Equal, objReg, temp, &skipBarrier);
  masm.branchValueIsNurseryCell(Assembler::NotEqual, R0, temp, &skipBarrier);

  masm.call(&postBarrierSlot_);  // Won't clobber R0

  masm.bind(&skipBarrier);
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_SetAliasedVar() {
  AllocatableGeneralRegisterSet regs(GeneralRegisterSet::All());
  regs.take(BaselineFrameReg);
  regs.take(R2);
  if (HasInterpreterPCReg()) {
    regs.take(InterpreterPCReg);
  }

  Register env = regs.takeAny();
  Register scratch1 = regs.takeAny();
  Register scratch2 = regs.takeAny();
  Register scratch3 = regs.takeAny();

  // Load the right environment object.
  masm.loadPtr(frame.addressOfEnvironmentChain(), env);
  LoadAliasedVarEnv(masm, env, scratch1);

  // Load the slot index.
  static_assert(ENVCOORD_SLOT_LEN == 3,
                "Code assumes slot is stored in uint24 operand");
  LoadUint24Operand(masm, ENVCOORD_HOPS_LEN, scratch1);

  // Store the RHS Value in R2.
  masm.loadValue(frame.addressOfStackValue(-1), R2);

  // Load a pointer to the fixed or dynamic slot into scratch2. We want to call
  // guardedCallPreBarrierAnyZone once to avoid code bloat.

  // See EnvironmentObject::nonExtensibleIsFixedSlot.
  Label isDynamic, done;
  masm.branch32(Assembler::AboveOrEqual, scratch1,
                Imm32(NativeObject::MAX_FIXED_SLOTS), &isDynamic);
  {
    uint32_t offset = NativeObject::getFixedSlotOffset(0);
    BaseValueIndex slotAddr(env, scratch1, offset);
    masm.computeEffectiveAddress(slotAddr, scratch2);
    masm.jump(&done);
  }
  masm.bind(&isDynamic);
  {
    masm.loadPtr(Address(env, NativeObject::offsetOfSlots()), scratch2);

    // Use an offset to subtract the number of fixed slots.
    int32_t offset = -int32_t(NativeObject::MAX_FIXED_SLOTS * sizeof(Value));
    BaseValueIndex slotAddr(scratch2, scratch1, offset);
    masm.computeEffectiveAddress(slotAddr, scratch2);
  }
  masm.bind(&done);

  // Pre-barrier and store.
  Address slotAddr(scratch2, 0);
  masm.guardedCallPreBarrierAnyZone(slotAddr, MIRType::Value, scratch3);
  masm.storeValue(R2, slotAddr);

  // Post barrier.
  Label skipBarrier;
  masm.branchPtrInNurseryChunk(Assembler::Equal, env, scratch1, &skipBarrier);
  masm.branchValueIsNurseryCell(Assembler::NotEqual, R2, scratch1,
                                &skipBarrier);
  {
    // Post barrier code expects the object in R2.
    masm.movePtr(env, R2.scratchReg());
    masm.call(&postBarrierSlot_);
  }
  masm.bind(&skipBarrier);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_GetName() {
  frame.syncStack(0);

  masm.loadPtr(frame.addressOfEnvironmentChain(), R0.scratchReg());

  // Call IC.
  if (!emitNextIC()) {
    return false;
  }

  // Mark R0 as pushed stack value.
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitBindName(JSOp op) {
  // If we have a BindGName without a non-syntactic scope, we pass the global
  // lexical environment to the IC instead of the frame's environment.

  frame.syncStack(0);

  auto loadGlobalLexical = [this]() {
    loadGlobalLexicalEnvironment(R0.scratchReg());
    return true;
  };
  auto loadFrameEnv = [this]() {
    masm.loadPtr(frame.addressOfEnvironmentChain(), R0.scratchReg());
    return true;
  };

  if (op == JSOp::BindName) {
    if (!loadFrameEnv()) {
      return false;
    }
  } else {
    MOZ_ASSERT(op == JSOp::BindGName);
    if (!emitTestScriptFlag(JSScript::ImmutableFlags::HasNonSyntacticScope,
                            loadFrameEnv, loadGlobalLexical, R2.scratchReg())) {
      return false;
    }
  }

  // Call IC.
  if (!emitNextIC()) {
    return false;
  }

  // Mark R0 as pushed stack value.
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_BindName() {
  return emitBindName(JSOp::BindName);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_DelName() {
  frame.syncStack(0);
  masm.loadPtr(frame.addressOfEnvironmentChain(), R0.scratchReg());

  prepareVMCall();

  pushArg(R0.scratchReg());
  pushScriptNameArg(R1.scratchReg(), R2.scratchReg());

  using Fn = bool (*)(JSContext*, HandlePropertyName, HandleObject,
                      MutableHandleValue);
  if (!callVM<Fn, js::DeleteNameOperation>()) {
    return false;
  }

  frame.push(R0);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_GetImport() {
  JSScript* script = handler.script();
  ModuleEnvironmentObject* env = GetModuleEnvironmentForScript(script);
  MOZ_ASSERT(env);

  jsid id = NameToId(script->getName(handler.pc()));
  ModuleEnvironmentObject* targetEnv;
  Shape* shape;
  MOZ_ALWAYS_TRUE(env->lookupImport(id, &targetEnv, &shape));

  frame.syncStack(0);

  uint32_t slot = shape->slot();
  Register scratch = R0.scratchReg();
  masm.movePtr(ImmGCPtr(targetEnv), scratch);
  if (slot < targetEnv->numFixedSlots()) {
    masm.loadValue(Address(scratch, NativeObject::getFixedSlotOffset(slot)),
                   R0);
  } else {
    masm.loadPtr(Address(scratch, NativeObject::offsetOfSlots()), scratch);
    masm.loadValue(
        Address(scratch, (slot - targetEnv->numFixedSlots()) * sizeof(Value)),
        R0);
  }

  // Imports are initialized by this point except in rare circumstances, so
  // don't emit a check unless we have to.
  if (targetEnv->getSlot(shape->slot()).isMagic(JS_UNINITIALIZED_LEXICAL)) {
    if (!emitUninitializedLexicalCheck(R0)) {
      return false;
    }
  }

  if (IsTypeInferenceEnabled() && handler.maybeIonCompileable()) {
    // No need to monitor types if we know Ion can't compile this script.
    if (!emitNextIC()) {
      return false;
    }
  }

  frame.push(R0);
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_GetImport() {
  frame.syncStack(0);

  masm.loadPtr(frame.addressOfEnvironmentChain(), R0.scratchReg());

  prepareVMCall();

  pushBytecodePCArg();
  pushScriptArg();
  pushArg(R0.scratchReg());

  using Fn = bool (*)(JSContext*, HandleObject, HandleScript, jsbytecode*,
                      MutableHandleValue);
  if (!callVM<Fn, GetImportOperation>()) {
    return false;
  }

  // Enter the type monitor IC.
  if (IsTypeInferenceEnabled() && !emitNextIC()) {
    return false;
  }

  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_GetIntrinsic() {
  frame.syncStack(0);

  if (!emitNextIC()) {
    return false;
  }

  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_SetIntrinsic() {
  frame.syncStack(0);
  masm.loadValue(frame.addressOfStackValue(-1), R0);

  prepareVMCall();

  pushArg(R0);
  pushBytecodePCArg();
  pushScriptArg();

  using Fn = bool (*)(JSContext*, JSScript*, jsbytecode*, HandleValue);
  return callVM<Fn, SetIntrinsicOperation>();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_DefVar() {
  frame.syncStack(0);

  masm.loadPtr(frame.addressOfEnvironmentChain(), R0.scratchReg());

  prepareVMCall();

  pushBytecodePCArg();
  pushScriptArg();
  pushArg(R0.scratchReg());

  using Fn = bool (*)(JSContext*, HandleObject, HandleScript, jsbytecode*);
  return callVM<Fn, DefVarOperation>();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitDefLexical(JSOp op) {
  MOZ_ASSERT(op == JSOp::DefConst || op == JSOp::DefLet);

  frame.syncStack(0);

  masm.loadPtr(frame.addressOfEnvironmentChain(), R0.scratchReg());

  prepareVMCall();

  pushBytecodePCArg();
  pushScriptArg();
  pushArg(R0.scratchReg());

  using Fn = bool (*)(JSContext*, HandleObject, HandleScript, jsbytecode*);
  return callVM<Fn, DefLexicalOperation>();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_DefConst() {
  return emitDefLexical(JSOp::DefConst);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_DefLet() {
  return emitDefLexical(JSOp::DefLet);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_DefFun() {
  frame.popRegsAndSync(1);
  masm.unboxObject(R0, R0.scratchReg());
  masm.loadPtr(frame.addressOfEnvironmentChain(), R1.scratchReg());

  prepareVMCall();

  pushArg(R0.scratchReg());
  pushArg(R1.scratchReg());
  pushScriptArg();

  using Fn = bool (*)(JSContext*, HandleScript, HandleObject, HandleFunction);
  return callVM<Fn, DefFunOperation>();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_CheckGlobalOrEvalDecl() {
  frame.syncStack(0);

  prepareVMCall();

  pushScriptArg();
  masm.loadPtr(frame.addressOfEnvironmentChain(), R0.scratchReg());
  pushArg(R0.scratchReg());

  using Fn = bool (*)(JSContext*, HandleObject, HandleScript);
  return callVM<Fn, js::CheckGlobalOrEvalDeclarationConflicts>();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitInitPropGetterSetter() {
  // Keep values on the stack for the decompiler.
  frame.syncStack(0);

  prepareVMCall();

  masm.unboxObject(frame.addressOfStackValue(-1), R0.scratchReg());
  masm.unboxObject(frame.addressOfStackValue(-2), R1.scratchReg());

  pushArg(R0.scratchReg());
  pushScriptNameArg(R0.scratchReg(), R2.scratchReg());
  pushArg(R1.scratchReg());
  pushBytecodePCArg();

  using Fn = bool (*)(JSContext*, jsbytecode*, HandleObject, HandlePropertyName,
                      HandleObject);
  if (!callVM<Fn, InitPropGetterSetterOperation>()) {
    return false;
  }

  frame.pop();
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitPropGetter() {
  return emitInitPropGetterSetter();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitHiddenPropGetter() {
  return emitInitPropGetterSetter();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitPropSetter() {
  return emitInitPropGetterSetter();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitHiddenPropSetter() {
  return emitInitPropGetterSetter();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitInitElemGetterSetter() {
  // Load index and value in R0 and R1, but keep values on the stack for the
  // decompiler.
  frame.syncStack(0);
  masm.loadValue(frame.addressOfStackValue(-2), R0);
  masm.unboxObject(frame.addressOfStackValue(-1), R1.scratchReg());

  prepareVMCall();

  pushArg(R1.scratchReg());
  pushArg(R0);
  masm.unboxObject(frame.addressOfStackValue(-3), R0.scratchReg());
  pushArg(R0.scratchReg());
  pushBytecodePCArg();

  using Fn = bool (*)(JSContext*, jsbytecode*, HandleObject, HandleValue,
                      HandleObject);
  if (!callVM<Fn, InitElemGetterSetterOperation>()) {
    return false;
  }

  frame.popn(2);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitElemGetter() {
  return emitInitElemGetterSetter();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitHiddenElemGetter() {
  return emitInitElemGetterSetter();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitElemSetter() {
  return emitInitElemGetterSetter();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitHiddenElemSetter() {
  return emitInitElemGetterSetter();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitElemInc() {
  // Keep the object and rhs on the stack.
  frame.syncStack(0);

  // Load object in R0, index in R1.
  masm.loadValue(frame.addressOfStackValue(-3), R0);
  masm.loadValue(frame.addressOfStackValue(-2), R1);

  // Call IC.
  if (!emitNextIC()) {
    return false;
  }

  // Pop the rhs
  frame.pop();

  // Increment index
  Address indexAddr = frame.addressOfStackValue(-1);
#ifdef DEBUG
  Label isInt32;
  masm.branchTestInt32(Assembler::Equal, indexAddr, &isInt32);
  masm.assumeUnreachable("INITELEM_INC index must be Int32");
  masm.bind(&isInt32);
#endif
  masm.incrementInt32Value(indexAddr);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_GetLocal() {
  frame.pushLocal(GET_LOCALNO(handler.pc()));
  return true;
}

static BaseValueIndex ComputeAddressOfLocal(MacroAssembler& masm,
                                            Register indexScratch) {
  // Locals are stored in memory at a negative offset from the frame pointer. We
  // negate the index first to effectively subtract it.
  masm.negPtr(indexScratch);
  return BaseValueIndex(BaselineFrameReg, indexScratch,
                        BaselineFrame::reverseOffsetOfLocal(0));
}

template <>
bool BaselineInterpreterCodeGen::emit_GetLocal() {
  Register scratch = R0.scratchReg();
  LoadUint24Operand(masm, 0, scratch);
  BaseValueIndex addr = ComputeAddressOfLocal(masm, scratch);
  masm.loadValue(addr, R0);
  frame.push(R0);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_SetLocal() {
  // Ensure no other StackValue refers to the old value, for instance i + (i =
  // 3). This also allows us to use R0 as scratch below.
  frame.syncStack(1);

  uint32_t local = GET_LOCALNO(handler.pc());
  frame.storeStackValue(-1, frame.addressOfLocal(local), R0);
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_SetLocal() {
  Register scratch = R0.scratchReg();
  LoadUint24Operand(masm, 0, scratch);
  BaseValueIndex addr = ComputeAddressOfLocal(masm, scratch);
  masm.loadValue(frame.addressOfStackValue(-1), R1);
  masm.storeValue(R1, addr);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emitFormalArgAccess(JSOp op) {
  MOZ_ASSERT(op == JSOp::GetArg || op == JSOp::SetArg);

  uint32_t arg = GET_ARGNO(handler.pc());

  // Fast path: the script does not use |arguments| or formals don't
  // alias the arguments object.
  if (!handler.script()->argumentsAliasesFormals()) {
    if (op == JSOp::GetArg) {
      frame.pushArg(arg);
    } else {
      // See the comment in emit_SetLocal.
      frame.syncStack(1);
      frame.storeStackValue(-1, frame.addressOfArg(arg), R0);
    }

    return true;
  }

  // Sync so that we can use R0.
  frame.syncStack(0);

  // If the script is known to have an arguments object, we can just use it.
  // Else, we *may* have an arguments object (because we can't invalidate
  // when needsArgsObj becomes |true|), so we have to test HAS_ARGS_OBJ.
  Label done;
  if (!handler.script()->needsArgsObj()) {
    Label hasArgsObj;
    masm.branchTest32(Assembler::NonZero, frame.addressOfFlags(),
                      Imm32(BaselineFrame::HAS_ARGS_OBJ), &hasArgsObj);
    if (op == JSOp::GetArg) {
      masm.loadValue(frame.addressOfArg(arg), R0);
    } else {
      frame.storeStackValue(-1, frame.addressOfArg(arg), R0);
    }
    masm.jump(&done);
    masm.bind(&hasArgsObj);
  }

  // Load the arguments object data vector.
  Register reg = R2.scratchReg();
  masm.loadPtr(frame.addressOfArgsObj(), reg);
  masm.loadPrivate(Address(reg, ArgumentsObject::getDataSlotOffset()), reg);

  // Load/store the argument.
  Address argAddr(reg, ArgumentsData::offsetOfArgs() + arg * sizeof(Value));
  if (op == JSOp::GetArg) {
    masm.loadValue(argAddr, R0);
    frame.push(R0);
  } else {
    Register temp = R1.scratchReg();
    masm.guardedCallPreBarrierAnyZone(argAddr, MIRType::Value, temp);
    masm.loadValue(frame.addressOfStackValue(-1), R0);
    masm.storeValue(R0, argAddr);

    MOZ_ASSERT(frame.numUnsyncedSlots() == 0);

    // Reload the arguments object.
    Register reg = R2.scratchReg();
    masm.loadPtr(frame.addressOfArgsObj(), reg);

    Label skipBarrier;

    masm.branchPtrInNurseryChunk(Assembler::Equal, reg, temp, &skipBarrier);
    masm.branchValueIsNurseryCell(Assembler::NotEqual, R0, temp, &skipBarrier);

    masm.call(&postBarrierSlot_);

    masm.bind(&skipBarrier);
  }

  masm.bind(&done);
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emitFormalArgAccess(JSOp op) {
  MOZ_ASSERT(op == JSOp::GetArg || op == JSOp::SetArg);

  // Load the index.
  Register argReg = R1.scratchReg();
  LoadUint16Operand(masm, argReg);

  // If the frame has no arguments object, this must be an unaliased access.
  Label isUnaliased, done;
  masm.branchTest32(Assembler::Zero, frame.addressOfFlags(),
                    Imm32(BaselineFrame::HAS_ARGS_OBJ), &isUnaliased);
  {
    Register reg = R2.scratchReg();

    // If it's an unmapped arguments object, this is an unaliased access.
    loadScript(reg);
    masm.branchTest32(
        Assembler::Zero, Address(reg, JSScript::offsetOfImmutableFlags()),
        Imm32(uint32_t(JSScript::ImmutableFlags::HasMappedArgsObj)),
        &isUnaliased);

    // Load the arguments object data vector.
    masm.loadPtr(frame.addressOfArgsObj(), reg);
    masm.loadPrivate(Address(reg, ArgumentsObject::getDataSlotOffset()), reg);

    // Load/store the argument.
    BaseValueIndex argAddr(reg, argReg, ArgumentsData::offsetOfArgs());
    if (op == JSOp::GetArg) {
      masm.loadValue(argAddr, R0);
      frame.push(R0);
    } else {
      masm.guardedCallPreBarrierAnyZone(argAddr, MIRType::Value,
                                        R0.scratchReg());
      masm.loadValue(frame.addressOfStackValue(-1), R0);
      masm.storeValue(R0, argAddr);

      // Reload the arguments object.
      masm.loadPtr(frame.addressOfArgsObj(), reg);

      Register temp = R1.scratchReg();
      masm.branchPtrInNurseryChunk(Assembler::Equal, reg, temp, &done);
      masm.branchValueIsNurseryCell(Assembler::NotEqual, R0, temp, &done);

      masm.call(&postBarrierSlot_);
    }
    masm.jump(&done);
  }
  masm.bind(&isUnaliased);
  {
    BaseValueIndex addr(BaselineFrameReg, argReg,
                        BaselineFrame::offsetOfArg(0));
    if (op == JSOp::GetArg) {
      masm.loadValue(addr, R0);
      frame.push(R0);
    } else {
      masm.loadValue(frame.addressOfStackValue(-1), R0);
      masm.storeValue(R0, addr);
    }
  }

  masm.bind(&done);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_GetArg() {
  return emitFormalArgAccess(JSOp::GetArg);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_SetArg() {
  return emitFormalArgAccess(JSOp::SetArg);
}

template <>
void BaselineCompilerCodeGen::loadNumFormalArguments(Register dest) {
  masm.move32(Imm32(handler.function()->nargs()), dest);
}

template <>
void BaselineInterpreterCodeGen::loadNumFormalArguments(Register dest) {
  masm.loadFunctionFromCalleeToken(frame.addressOfCalleeToken(), dest);
  masm.load16ZeroExtend(Address(dest, JSFunction::offsetOfNargs()), dest);
}

template <typename Handler>
void BaselineCodeGen<Handler>::emitPushNonArrowFunctionNewTarget() {
  // if (isConstructing()) push(argv[Max(numActualArgs, numFormalArgs)])
  Label notConstructing, done;
  masm.branchTestPtr(Assembler::Zero, frame.addressOfCalleeToken(),
                     Imm32(CalleeToken_FunctionConstructing), &notConstructing);
  {
    Register argvLen = R0.scratchReg();
    Register nformals = R1.scratchReg();
    Address actualArgs(BaselineFrameReg,
                       BaselineFrame::offsetOfNumActualArgs());
    masm.loadPtr(actualArgs, argvLen);

    // If argvLen < nformals, set argvlen := nformals.
    loadNumFormalArguments(nformals);
    masm.cmp32Move32(Assembler::Below, argvLen, nformals, nformals, argvLen);

    BaseValueIndex newTarget(BaselineFrameReg, argvLen,
                             BaselineFrame::offsetOfArg(0));
    masm.loadValue(newTarget, R0);
    masm.jump(&done);
  }
  // else push(undefined)
  masm.bind(&notConstructing);
  masm.moveValue(UndefinedValue(), R0);

  masm.bind(&done);
  frame.push(R0);
}

template <>
bool BaselineCompilerCodeGen::emit_NewTarget() {
  if (handler.script()->isForEval()) {
    frame.pushEvalNewTarget();
    return true;
  }

  MOZ_ASSERT(handler.function());
  frame.syncStack(0);

  if (handler.function()->isArrow()) {
    // Arrow functions store their |new.target| value in an
    // extended slot.
    Register scratch = R0.scratchReg();
    masm.loadFunctionFromCalleeToken(frame.addressOfCalleeToken(), scratch);
    masm.loadValue(
        Address(scratch, FunctionExtended::offsetOfArrowNewTargetSlot()), R0);
    frame.push(R0);
    return true;
  }

  emitPushNonArrowFunctionNewTarget();
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_NewTarget() {
  Register scratch1 = R0.scratchReg();
  Register scratch2 = R1.scratchReg();

  Label isFunction, done;
  masm.loadPtr(frame.addressOfCalleeToken(), scratch1);
  masm.branchTestPtr(Assembler::Zero, scratch1, Imm32(CalleeTokenScriptBit),
                     &isFunction);
  {
    // Case 1: eval.
    frame.pushEvalNewTarget();
    masm.jump(&done);
  }

  masm.bind(&isFunction);

  Label notArrow;
  masm.andPtr(Imm32(uint32_t(CalleeTokenMask)), scratch1);
  masm.branchFunctionKind(Assembler::NotEqual,
                          FunctionFlags::FunctionKind::Arrow, scratch1,
                          scratch2, &notArrow);
  {
    // Case 2: arrow function.
    masm.pushValue(
        Address(scratch1, FunctionExtended::offsetOfArrowNewTargetSlot()));
    masm.jump(&done);
  }

  masm.bind(&notArrow);

  // Case 3: non-arrow function.
  emitPushNonArrowFunctionNewTarget();

  masm.bind(&done);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_ThrowSetConst() {
  prepareVMCall();
  pushArg(Imm32(JSMSG_BAD_CONST_ASSIGN));

  using Fn = bool (*)(JSContext*, unsigned);
  return callVM<Fn, jit::ThrowRuntimeLexicalError>();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitUninitializedLexicalCheck(
    const ValueOperand& val) {
  Label done;
  masm.branchTestMagicValue(Assembler::NotEqual, val, JS_UNINITIALIZED_LEXICAL,
                            &done);

  prepareVMCall();
  pushArg(Imm32(JSMSG_UNINITIALIZED_LEXICAL));

  using Fn = bool (*)(JSContext*, unsigned);
  if (!callVM<Fn, jit::ThrowRuntimeLexicalError>()) {
    return false;
  }

  masm.bind(&done);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_CheckLexical() {
  frame.syncStack(0);
  masm.loadValue(frame.addressOfStackValue(-1), R0);
  return emitUninitializedLexicalCheck(R0);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_CheckAliasedLexical() {
  return emit_CheckLexical();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitLexical() {
  return emit_SetLocal();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitGLexical() {
  frame.popRegsAndSync(1);
  pushGlobalLexicalEnvironmentValue(R1);
  frame.push(R0);
  return emit_SetProp();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitAliasedLexical() {
  return emit_SetAliasedVar();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Uninitialized() {
  frame.push(MagicValue(JS_UNINITIALIZED_LEXICAL));
  return true;
}

template <>
bool BaselineCompilerCodeGen::emitCall(JSOp op) {
  MOZ_ASSERT(IsInvokeOp(op));

  frame.syncStack(0);

  uint32_t argc = GET_ARGC(handler.pc());
  masm.move32(Imm32(argc), R0.scratchReg());

  // Call IC
  if (!emitNextIC()) {
    return false;
  }

  // Update FrameInfo.
  bool construct = IsConstructOp(op);
  frame.popn(2 + argc + construct);
  frame.push(R0);
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emitCall(JSOp op) {
  MOZ_ASSERT(IsInvokeOp(op));

  // The IC expects argc in R0.
  LoadUint16Operand(masm, R0.scratchReg());
  if (!emitNextIC()) {
    return false;
  }

  // Pop the arguments. We have to reload pc/argc because the IC clobbers them.
  // The return value is in R0 so we can't use that.
  Register scratch = R1.scratchReg();
  uint32_t extraValuesToPop = IsConstructOp(op) ? 3 : 2;
  Register spReg = AsRegister(masm.getStackPointer());
  LoadUint16Operand(masm, scratch);
  masm.computeEffectiveAddress(
      BaseValueIndex(spReg, scratch, extraValuesToPop * sizeof(Value)), spReg);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitSpreadCall(JSOp op) {
  MOZ_ASSERT(IsInvokeOp(op));

  frame.syncStack(0);
  masm.move32(Imm32(1), R0.scratchReg());

  // Call IC
  if (!emitNextIC()) {
    return false;
  }

  // Update FrameInfo.
  bool construct = op == JSOp::SpreadNew || op == JSOp::SpreadSuperCall;
  frame.popn(3 + construct);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Call() {
  return emitCall(JSOp::Call);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_CallIgnoresRv() {
  return emitCall(JSOp::CallIgnoresRv);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_CallIter() {
  return emitCall(JSOp::CallIter);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_New() {
  return emitCall(JSOp::New);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_SuperCall() {
  return emitCall(JSOp::SuperCall);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_FunCall() {
  return emitCall(JSOp::FunCall);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_FunApply() {
  return emitCall(JSOp::FunApply);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Eval() {
  return emitCall(JSOp::Eval);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_StrictEval() {
  return emitCall(JSOp::StrictEval);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_SpreadCall() {
  return emitSpreadCall(JSOp::SpreadCall);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_SpreadNew() {
  return emitSpreadCall(JSOp::SpreadNew);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_SpreadSuperCall() {
  return emitSpreadCall(JSOp::SpreadSuperCall);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_SpreadEval() {
  return emitSpreadCall(JSOp::SpreadEval);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_StrictSpreadEval() {
  return emitSpreadCall(JSOp::StrictSpreadEval);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_OptimizeSpreadCall() {
  frame.syncStack(0);
  masm.loadValue(frame.addressOfStackValue(-1), R0);

  prepareVMCall();
  pushArg(R0);

  using Fn = bool (*)(JSContext*, HandleValue, bool*);
  if (!callVM<Fn, OptimizeSpreadCall>()) {
    return false;
  }

  masm.boxNonDouble(JSVAL_TYPE_BOOLEAN, ReturnReg, R0);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_ImplicitThis() {
  frame.syncStack(0);
  masm.loadPtr(frame.addressOfEnvironmentChain(), R0.scratchReg());

  prepareVMCall();

  pushScriptNameArg(R1.scratchReg(), R2.scratchReg());
  pushArg(R0.scratchReg());

  using Fn = bool (*)(JSContext*, HandleObject, HandlePropertyName,
                      MutableHandleValue);
  if (!callVM<Fn, ImplicitThisOperation>()) {
    return false;
  }

  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_GImplicitThis() {
  auto pushUndefined = [this]() {
    frame.push(UndefinedValue());
    return true;
  };
  auto emitImplicitThis = [this]() { return emit_ImplicitThis(); };
  return emitTestScriptFlag(JSScript::ImmutableFlags::HasNonSyntacticScope,
                            emitImplicitThis, pushUndefined, R2.scratchReg());
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Instanceof() {
  frame.popRegsAndSync(2);

  if (!emitNextIC()) {
    return false;
  }

  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Typeof() {
  frame.popRegsAndSync(1);

  if (!emitNextIC()) {
    return false;
  }

  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_TypeofExpr() {
  return emit_Typeof();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_ThrowMsg() {
  prepareVMCall();
  pushUint8BytecodeOperandArg(R2.scratchReg());

  using Fn = bool (*)(JSContext*, const unsigned);
  return callVM<Fn, js::ThrowMsgOperation>();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Throw() {
  // Keep value to throw in R0.
  frame.popRegsAndSync(1);

  prepareVMCall();
  pushArg(R0);

  using Fn = bool (*)(JSContext*, HandleValue);
  return callVM<Fn, js::ThrowOperation>();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Try() {
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Finally() {
  // JSOp::Finally has a def count of 2, but these values are already on the
  // stack (they're pushed by JSOp::Gosub). Update the compiler's stack state.
  frame.incStackDepth(2);

  // To match the interpreter, emit an interrupt check at the start of the
  // finally block.
  return emitInterruptCheck();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Gosub() {
  // Jump to the finally block.
  frame.syncStack(0);
  emitJump();
  return true;
}

static void LoadBaselineScriptResumeEntries(MacroAssembler& masm,
                                            JSScript* script, Register dest,
                                            Register scratch) {
  MOZ_ASSERT(dest != scratch);

  masm.movePtr(ImmPtr(script->jitScript()), dest);
  masm.loadPtr(Address(dest, JitScript::offsetOfBaselineScript()), dest);
  masm.load32(Address(dest, BaselineScript::offsetOfResumeEntriesOffset()),
              scratch);
  masm.addPtr(scratch, dest);
}

template <typename Handler>
void BaselineCodeGen<Handler>::emitInterpJumpToResumeEntry(Register script,
                                                           Register resumeIndex,
                                                           Register scratch) {
  // Load JSScript::immutableScriptData() into |script|.
  masm.loadPtr(Address(script, JSScript::offsetOfSharedData()), script);
  masm.loadPtr(Address(script, RuntimeScriptData::offsetOfISD()), script);

  // Load the resume pcOffset in |resumeIndex|.
  masm.load32(
      Address(script, ImmutableScriptData::offsetOfResumeOffsetsOffset()),
      scratch);
  masm.computeEffectiveAddress(BaseIndex(scratch, resumeIndex, TimesFour),
                               scratch);
  masm.load32(BaseIndex(script, scratch, TimesOne), resumeIndex);

  // Add resume offset to PC, jump to it.
  masm.computeEffectiveAddress(BaseIndex(script, resumeIndex, TimesOne,
                                         ImmutableScriptData::offsetOfCode()),
                               script);
  Address pcAddr(BaselineFrameReg,
                 BaselineFrame::reverseOffsetOfInterpreterPC());
  masm.storePtr(script, pcAddr);
  emitJumpToInterpretOpLabel();
}

template <>
void BaselineCompilerCodeGen::jumpToResumeEntry(Register resumeIndex,
                                                Register scratch1,
                                                Register scratch2) {
  LoadBaselineScriptResumeEntries(masm, handler.script(), scratch1, scratch2);
  masm.loadPtr(
      BaseIndex(scratch1, resumeIndex, ScaleFromElemWidth(sizeof(uintptr_t))),
      scratch1);
  masm.jump(scratch1);
}

template <>
void BaselineInterpreterCodeGen::jumpToResumeEntry(Register resumeIndex,
                                                   Register scratch1,
                                                   Register scratch2) {
  loadScript(scratch1);
  emitInterpJumpToResumeEntry(scratch1, resumeIndex, scratch2);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Retsub() {
  frame.popRegsAndSync(2);

  Label isReturn;
  masm.branchTestBooleanTruthy(/* branchIfTrue = */ false, R0, &isReturn);

  // R0 is |true|. We need to throw R1.
  prepareVMCall();
  pushArg(R1);

  using Fn = bool (*)(JSContext*, HandleValue);
  if (!callVM<Fn, js::ThrowOperation>()) {
    return false;
  }

  masm.bind(&isReturn);

  // R0 is |false|. R1 contains the resumeIndex to jump to.
  Register resumeIndexReg = R1.scratchReg();
  masm.unboxInt32(R1, resumeIndexReg);

  Register scratch1 = R2.scratchReg();
  Register scratch2 = R0.scratchReg();
  jumpToResumeEntry(resumeIndexReg, scratch1, scratch2);
  return true;
}

template <>
template <typename F1, typename F2>
MOZ_MUST_USE bool BaselineCompilerCodeGen::emitDebugInstrumentation(
    const F1& ifDebuggee, const Maybe<F2>& ifNotDebuggee) {
  // The JIT calls either ifDebuggee or (if present) ifNotDebuggee, because it
  // knows statically whether we're compiling with debug instrumentation.

  if (handler.compileDebugInstrumentation()) {
    return ifDebuggee();
  }

  if (ifNotDebuggee) {
    return (*ifNotDebuggee)();
  }

  return true;
}

template <>
template <typename F1, typename F2>
MOZ_MUST_USE bool BaselineInterpreterCodeGen::emitDebugInstrumentation(
    const F1& ifDebuggee, const Maybe<F2>& ifNotDebuggee) {
  // The interpreter emits both ifDebuggee and (if present) ifNotDebuggee
  // paths, with a toggled jump followed by a branch on the frame's DEBUGGEE
  // flag.

  Label isNotDebuggee, done;

  CodeOffset toggleOffset = masm.toggledJump(&isNotDebuggee);
  if (!handler.addDebugInstrumentationOffset(cx, toggleOffset)) {
    return false;
  }

  masm.branchTest32(Assembler::Zero, frame.addressOfFlags(),
                    Imm32(BaselineFrame::DEBUGGEE), &isNotDebuggee);

  if (!ifDebuggee()) {
    return false;
  }

  if (ifNotDebuggee) {
    masm.jump(&done);
  }

  masm.bind(&isNotDebuggee);

  if (ifNotDebuggee && !(*ifNotDebuggee)()) {
    return false;
  }

  masm.bind(&done);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_PushLexicalEnv() {
  // Call a stub to push the block on the block chain.
  prepareVMCall();
  masm.loadBaselineFramePtr(BaselineFrameReg, R0.scratchReg());

  pushScriptGCThingArg(ScriptGCThingType::Scope, R1.scratchReg(),
                       R2.scratchReg());
  pushArg(R0.scratchReg());

  using Fn = bool (*)(JSContext*, BaselineFrame*, Handle<LexicalScope*>);
  return callVM<Fn, jit::PushLexicalEnv>();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_PopLexicalEnv() {
  frame.syncStack(0);

  masm.loadBaselineFramePtr(BaselineFrameReg, R0.scratchReg());

  auto ifDebuggee = [this]() {
    prepareVMCall();
    pushBytecodePCArg();
    pushArg(R0.scratchReg());

    using Fn = bool (*)(JSContext*, BaselineFrame*, jsbytecode*);
    return callVM<Fn, jit::DebugLeaveThenPopLexicalEnv>();
  };
  auto ifNotDebuggee = [this]() {
    prepareVMCall();
    pushArg(R0.scratchReg());

    using Fn = bool (*)(JSContext*, BaselineFrame*);
    return callVM<Fn, jit::PopLexicalEnv>();
  };
  return emitDebugInstrumentation(ifDebuggee, mozilla::Some(ifNotDebuggee));
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_FreshenLexicalEnv() {
  frame.syncStack(0);

  masm.loadBaselineFramePtr(BaselineFrameReg, R0.scratchReg());

  auto ifDebuggee = [this]() {
    prepareVMCall();
    pushBytecodePCArg();
    pushArg(R0.scratchReg());

    using Fn = bool (*)(JSContext*, BaselineFrame*, jsbytecode*);
    return callVM<Fn, jit::DebugLeaveThenFreshenLexicalEnv>();
  };
  auto ifNotDebuggee = [this]() {
    prepareVMCall();
    pushArg(R0.scratchReg());

    using Fn = bool (*)(JSContext*, BaselineFrame*);
    return callVM<Fn, jit::FreshenLexicalEnv>();
  };
  return emitDebugInstrumentation(ifDebuggee, mozilla::Some(ifNotDebuggee));
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_RecreateLexicalEnv() {
  frame.syncStack(0);

  masm.loadBaselineFramePtr(BaselineFrameReg, R0.scratchReg());

  auto ifDebuggee = [this]() {
    prepareVMCall();
    pushBytecodePCArg();
    pushArg(R0.scratchReg());

    using Fn = bool (*)(JSContext*, BaselineFrame*, jsbytecode*);
    return callVM<Fn, jit::DebugLeaveThenRecreateLexicalEnv>();
  };
  auto ifNotDebuggee = [this]() {
    prepareVMCall();
    pushArg(R0.scratchReg());

    using Fn = bool (*)(JSContext*, BaselineFrame*);
    return callVM<Fn, jit::RecreateLexicalEnv>();
  };
  return emitDebugInstrumentation(ifDebuggee, mozilla::Some(ifNotDebuggee));
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_DebugLeaveLexicalEnv() {
  auto ifDebuggee = [this]() {
    prepareVMCall();
    masm.loadBaselineFramePtr(BaselineFrameReg, R0.scratchReg());
    pushBytecodePCArg();
    pushArg(R0.scratchReg());

    using Fn = bool (*)(JSContext*, BaselineFrame*, jsbytecode*);
    return callVM<Fn, jit::DebugLeaveLexicalEnv>();
  };
  return emitDebugInstrumentation(ifDebuggee);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_PushVarEnv() {
  prepareVMCall();
  masm.loadBaselineFramePtr(BaselineFrameReg, R0.scratchReg());
  pushScriptGCThingArg(ScriptGCThingType::Scope, R1.scratchReg(),
                       R2.scratchReg());
  pushArg(R0.scratchReg());

  using Fn = bool (*)(JSContext*, BaselineFrame*, HandleScope);
  return callVM<Fn, jit::PushVarEnv>();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_EnterWith() {
  // Pop "with" object to R0.
  frame.popRegsAndSync(1);

  // Call a stub to push the object onto the environment chain.
  prepareVMCall();

  pushScriptGCThingArg(ScriptGCThingType::Scope, R1.scratchReg(),
                       R2.scratchReg());
  pushArg(R0);
  masm.loadBaselineFramePtr(BaselineFrameReg, R1.scratchReg());
  pushArg(R1.scratchReg());

  using Fn =
      bool (*)(JSContext*, BaselineFrame*, HandleValue, Handle<WithScope*>);
  return callVM<Fn, jit::EnterWith>();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_LeaveWith() {
  // Call a stub to pop the with object from the environment chain.
  prepareVMCall();

  masm.loadBaselineFramePtr(BaselineFrameReg, R0.scratchReg());
  pushArg(R0.scratchReg());

  using Fn = bool (*)(JSContext*, BaselineFrame*);
  return callVM<Fn, jit::LeaveWith>();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Exception() {
  prepareVMCall();

  using Fn = bool (*)(JSContext*, MutableHandleValue);
  if (!callVM<Fn, GetAndClearException>()) {
    return false;
  }

  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Debugger() {
  prepareVMCall();

  frame.assertSyncedStack();
  masm.loadBaselineFramePtr(BaselineFrameReg, R0.scratchReg());
  pushArg(R0.scratchReg());

  using Fn = bool (*)(JSContext*, BaselineFrame*);
  if (!callVM<Fn, jit::OnDebuggerStatement>()) {
    return false;
  }

  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitDebugEpilogue() {
  auto ifDebuggee = [this]() {
    // Move return value into the frame's rval slot.
    masm.storeValue(JSReturnOperand, frame.addressOfReturnValue());
    masm.or32(Imm32(BaselineFrame::HAS_RVAL), frame.addressOfFlags());

    // Load BaselineFrame pointer in R0.
    frame.syncStack(0);
    masm.loadBaselineFramePtr(BaselineFrameReg, R0.scratchReg());

    prepareVMCall();
    pushBytecodePCArg();
    pushArg(R0.scratchReg());

    const RetAddrEntry::Kind kind = RetAddrEntry::Kind::DebugEpilogue;

    using Fn = bool (*)(JSContext*, BaselineFrame*, jsbytecode*);
    if (!callVM<Fn, jit::DebugEpilogueOnBaselineReturn>(kind)) {
      return false;
    }

    masm.loadValue(frame.addressOfReturnValue(), JSReturnOperand);
    return true;
  };
  return emitDebugInstrumentation(ifDebuggee);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitReturn() {
  if (handler.shouldEmitDebugEpilogueAtReturnOp()) {
    if (!emitDebugEpilogue()) {
      return false;
    }
  }

  // Only emit the jump if this JSOp::RetRval is not the last instruction.
  // Not needed for last instruction, because last instruction flows
  // into return label.
  if (!handler.isDefinitelyLastOp()) {
    masm.jump(&return_);
  }

  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Return() {
  frame.assertStackDepth(1);

  frame.popValue(JSReturnOperand);
  return emitReturn();
}

template <typename Handler>
void BaselineCodeGen<Handler>::emitLoadReturnValue(ValueOperand val) {
  Label done, noRval;
  masm.branchTest32(Assembler::Zero, frame.addressOfFlags(),
                    Imm32(BaselineFrame::HAS_RVAL), &noRval);
  masm.loadValue(frame.addressOfReturnValue(), val);
  masm.jump(&done);

  masm.bind(&noRval);
  masm.moveValue(UndefinedValue(), val);

  masm.bind(&done);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_RetRval() {
  frame.assertStackDepth(0);

  masm.moveValue(UndefinedValue(), JSReturnOperand);

  if (!handler.maybeScript() || !handler.maybeScript()->noScriptRval()) {
    // Return the value in the return value slot, if any.
    Label done;
    Address flags = frame.addressOfFlags();
    masm.branchTest32(Assembler::Zero, flags, Imm32(BaselineFrame::HAS_RVAL),
                      &done);
    masm.loadValue(frame.addressOfReturnValue(), JSReturnOperand);
    masm.bind(&done);
  }

  return emitReturn();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_ToId() {
  // Load index in R0, but keep values on the stack for the decompiler.
  frame.syncStack(0);
  masm.loadValue(frame.addressOfStackValue(-1), R0);

  // No-op if the index is trivally convertable to an id.
  Label done;
  masm.branchTestInt32(Assembler::Equal, R0, &done);
  masm.branchTestString(Assembler::Equal, R0, &done);
  masm.branchTestSymbol(Assembler::Equal, R0, &done);

  prepareVMCall();

  pushArg(R0);

  using Fn = bool (*)(JSContext*, HandleValue, MutableHandleValue);
  if (!callVM<Fn, js::ToIdOperation>()) {
    return false;
  }

  masm.bind(&done);
  frame.pop();  // Pop index.
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_ToAsyncIter() {
  frame.syncStack(0);
  masm.unboxObject(frame.addressOfStackValue(-2), R0.scratchReg());
  masm.loadValue(frame.addressOfStackValue(-1), R1);

  prepareVMCall();
  pushArg(R1);
  pushArg(R0.scratchReg());

  using Fn = JSObject* (*)(JSContext*, HandleObject, HandleValue);
  if (!callVM<Fn, js::CreateAsyncFromSyncIterator>()) {
    return false;
  }

  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.popn(2);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_TrySkipAwait() {
  frame.syncStack(0);
  masm.loadValue(frame.addressOfStackValue(-1), R0);

  prepareVMCall();
  pushArg(R0);

  using Fn = bool (*)(JSContext*, HandleValue, MutableHandleValue);
  if (!callVM<Fn, jit::TrySkipAwait>()) {
    return false;
  }

  Label cannotSkip, done;
  masm.branchTestMagicValue(Assembler::Equal, R0, JS_CANNOT_SKIP_AWAIT,
                            &cannotSkip);
  masm.moveValue(BooleanValue(true), R1);
  masm.jump(&done);

  masm.bind(&cannotSkip);
  masm.loadValue(frame.addressOfStackValue(-1), R0);
  masm.moveValue(BooleanValue(false), R1);

  masm.bind(&done);

  frame.pop();
  frame.push(R0);
  frame.push(R1);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_AsyncAwait() {
  frame.syncStack(0);
  masm.loadValue(frame.addressOfStackValue(-2), R1);
  masm.unboxObject(frame.addressOfStackValue(-1), R0.scratchReg());

  prepareVMCall();
  pushArg(R1);
  pushArg(R0.scratchReg());

  using Fn = JSObject* (*)(JSContext*, Handle<AsyncFunctionGeneratorObject*>,
                           HandleValue);
  if (!callVM<Fn, js::AsyncFunctionAwait>()) {
    return false;
  }

  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.popn(2);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_AsyncResolve() {
  frame.syncStack(0);
  masm.loadValue(frame.addressOfStackValue(-2), R1);
  masm.unboxObject(frame.addressOfStackValue(-1), R0.scratchReg());

  prepareVMCall();
  pushUint8BytecodeOperandArg(R2.scratchReg());
  pushArg(R1);
  pushArg(R0.scratchReg());

  using Fn = JSObject* (*)(JSContext*, Handle<AsyncFunctionGeneratorObject*>,
                           HandleValue, AsyncFunctionResolveKind);
  if (!callVM<Fn, js::AsyncFunctionResolve>()) {
    return false;
  }

  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.popn(2);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_CheckObjCoercible() {
  frame.syncStack(0);
  masm.loadValue(frame.addressOfStackValue(-1), R0);

  Label fail, done;

  masm.branchTestUndefined(Assembler::Equal, R0, &fail);
  masm.branchTestNull(Assembler::NotEqual, R0, &done);

  masm.bind(&fail);
  prepareVMCall();

  pushArg(R0);

  using Fn = bool (*)(JSContext*, HandleValue);
  if (!callVM<Fn, ThrowObjectCoercible>()) {
    return false;
  }

  masm.bind(&done);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_ToString() {
  // Keep top stack value in R0.
  frame.popRegsAndSync(1);

  // Inline path for string.
  Label done;
  masm.branchTestString(Assembler::Equal, R0, &done);

  prepareVMCall();

  pushArg(R0);

  // Call ToStringSlow which doesn't handle string inputs.
  using Fn = JSString* (*)(JSContext*, HandleValue);
  if (!callVM<Fn, ToStringSlow<CanGC>>()) {
    return false;
  }

  masm.tagValue(JSVAL_TYPE_STRING, ReturnReg, R0);

  masm.bind(&done);
  frame.push(R0);
  return true;
}

static constexpr uint32_t TableSwitchOpLowOffset = 1 * JUMP_OFFSET_LEN;
static constexpr uint32_t TableSwitchOpHighOffset = 2 * JUMP_OFFSET_LEN;
static constexpr uint32_t TableSwitchOpFirstResumeIndexOffset =
    3 * JUMP_OFFSET_LEN;

template <>
void BaselineCompilerCodeGen::emitGetTableSwitchIndex(ValueOperand val,
                                                      Register dest,
                                                      Register scratch1,
                                                      Register scratch2) {
  jsbytecode* pc = handler.pc();
  jsbytecode* defaultpc = pc + GET_JUMP_OFFSET(pc);
  Label* defaultLabel = handler.labelOf(defaultpc);

  int32_t low = GET_JUMP_OFFSET(pc + TableSwitchOpLowOffset);
  int32_t high = GET_JUMP_OFFSET(pc + TableSwitchOpHighOffset);
  int32_t length = high - low + 1;

  // Jump to the 'default' pc if not int32 (tableswitch is only used when
  // all cases are int32).
  masm.branchTestInt32(Assembler::NotEqual, val, defaultLabel);
  masm.unboxInt32(val, dest);

  // Subtract 'low'. Bounds check.
  if (low != 0) {
    masm.sub32(Imm32(low), dest);
  }
  masm.branch32(Assembler::AboveOrEqual, dest, Imm32(length), defaultLabel);
}

template <>
void BaselineInterpreterCodeGen::emitGetTableSwitchIndex(ValueOperand val,
                                                         Register dest,
                                                         Register scratch1,
                                                         Register scratch2) {
  // Jump to the 'default' pc if not int32 (tableswitch is only used when
  // all cases are int32).
  Label done, jumpToDefault;
  masm.branchTestInt32(Assembler::NotEqual, val, &jumpToDefault);
  masm.unboxInt32(val, dest);

  Register pcReg = LoadBytecodePC(masm, scratch1);
  Address lowAddr(pcReg, sizeof(jsbytecode) + TableSwitchOpLowOffset);
  Address highAddr(pcReg, sizeof(jsbytecode) + TableSwitchOpHighOffset);

  // Jump to default if val > high.
  masm.branch32(Assembler::LessThan, highAddr, dest, &jumpToDefault);

  // Jump to default if val < low.
  masm.load32(lowAddr, scratch2);
  masm.branch32(Assembler::GreaterThan, scratch2, dest, &jumpToDefault);

  // index := val - low.
  masm.sub32(scratch2, dest);
  masm.jump(&done);

  masm.bind(&jumpToDefault);
  emitJump();

  masm.bind(&done);
}

template <>
void BaselineCompilerCodeGen::emitTableSwitchJump(Register key,
                                                  Register scratch1,
                                                  Register scratch2) {
  // Jump to resumeEntries[firstResumeIndex + key].

  // Note: BytecodeEmitter::allocateResumeIndex static_asserts
  // |firstResumeIndex * sizeof(uintptr_t)| fits in int32_t.
  uint32_t firstResumeIndex =
      GET_RESUMEINDEX(handler.pc() + TableSwitchOpFirstResumeIndexOffset);
  LoadBaselineScriptResumeEntries(masm, handler.script(), scratch1, scratch2);
  masm.loadPtr(BaseIndex(scratch1, key, ScaleFromElemWidth(sizeof(uintptr_t)),
                         firstResumeIndex * sizeof(uintptr_t)),
               scratch1);
  masm.jump(scratch1);
}

template <>
void BaselineInterpreterCodeGen::emitTableSwitchJump(Register key,
                                                     Register scratch1,
                                                     Register scratch2) {
  // Load the op's firstResumeIndex in scratch1.
  LoadUint24Operand(masm, TableSwitchOpFirstResumeIndexOffset, scratch1);

  masm.add32(key, scratch1);
  jumpToResumeEntry(scratch1, key, scratch2);
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_TableSwitch() {
  frame.popRegsAndSync(1);

  Register key = R0.scratchReg();
  Register scratch1 = R1.scratchReg();
  Register scratch2 = R2.scratchReg();

  // Call a stub to convert R0 from double to int32 if needed.
  // Note: this stub may clobber scratch1.
  masm.call(cx->runtime()->jitRuntime()->getDoubleToInt32ValueStub());

  // Load the index in the jump table in |key|, or branch to default pc if not
  // int32 or out-of-range.
  emitGetTableSwitchIndex(R0, key, scratch1, scratch2);

  // Jump to the target pc.
  emitTableSwitchJump(key, scratch1, scratch2);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Iter() {
  frame.popRegsAndSync(1);

  if (!emitNextIC()) {
    return false;
  }

  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_MoreIter() {
  frame.syncStack(0);

  masm.unboxObject(frame.addressOfStackValue(-1), R1.scratchReg());

  masm.iteratorMore(R1.scratchReg(), R0, R2.scratchReg());
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitIsMagicValue() {
  frame.syncStack(0);

  Label isMagic, done;
  masm.branchTestMagic(Assembler::Equal, frame.addressOfStackValue(-1),
                       &isMagic);
  masm.moveValue(BooleanValue(false), R0);
  masm.jump(&done);

  masm.bind(&isMagic);
  masm.moveValue(BooleanValue(true), R0);

  masm.bind(&done);
  frame.push(R0, JSVAL_TYPE_BOOLEAN);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_IsNoIter() {
  return emitIsMagicValue();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_EndIter() {
  // Pop iterator value.
  frame.pop();

  // Pop the iterator object to close in R0.
  frame.popRegsAndSync(1);

  AllocatableGeneralRegisterSet regs(GeneralRegisterSet::All());
  regs.take(BaselineFrameReg);
  if (HasInterpreterPCReg()) {
    regs.take(InterpreterPCReg);
  }

  Register obj = R0.scratchReg();
  regs.take(obj);
  masm.unboxObject(R0, obj);

  Register temp1 = regs.takeAny();
  Register temp2 = regs.takeAny();
  Register temp3 = regs.takeAny();
  masm.iteratorClose(obj, temp1, temp2, temp3);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_IsGenClosing() {
  return emitIsMagicValue();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_GetRval() {
  frame.syncStack(0);

  emitLoadReturnValue(R0);

  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_SetRval() {
  // Store to the frame's return value slot.
  frame.storeStackValue(-1, frame.addressOfReturnValue(), R2);
  masm.or32(Imm32(BaselineFrame::HAS_RVAL), frame.addressOfFlags());
  frame.pop();
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Callee() {
  MOZ_ASSERT_IF(handler.maybeScript(), handler.maybeScript()->function());
  frame.syncStack(0);
  masm.loadFunctionFromCalleeToken(frame.addressOfCalleeToken(),
                                   R0.scratchReg());
  masm.tagValue(JSVAL_TYPE_OBJECT, R0.scratchReg(), R0);
  frame.push(R0);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_EnvCallee() {
  frame.syncStack(0);
  uint8_t numHops = GET_UINT8(handler.pc());
  Register scratch = R0.scratchReg();

  masm.loadPtr(frame.addressOfEnvironmentChain(), scratch);
  for (unsigned i = 0; i < numHops; i++) {
    Address nextAddr(scratch,
                     EnvironmentObject::offsetOfEnclosingEnvironment());
    masm.unboxObject(nextAddr, scratch);
  }

  masm.loadValue(Address(scratch, CallObject::offsetOfCallee()), R0);
  frame.push(R0);
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_EnvCallee() {
  Register scratch = R0.scratchReg();
  Register env = R1.scratchReg();

  static_assert(JSOpLength_EnvCallee - sizeof(jsbytecode) == ENVCOORD_HOPS_LEN,
                "op must have uint8 operand for LoadAliasedVarEnv");

  // Load the right environment object.
  masm.loadPtr(frame.addressOfEnvironmentChain(), env);
  LoadAliasedVarEnv(masm, env, scratch);

  masm.pushValue(Address(env, CallObject::offsetOfCallee()));
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_SuperBase() {
  frame.popRegsAndSync(1);

  Register scratch = R0.scratchReg();
  Register proto = R1.scratchReg();

  // Unbox callee.
  masm.unboxObject(R0, scratch);

  // Load [[HomeObject]]
  Address homeObjAddr(scratch,
                      FunctionExtended::offsetOfMethodHomeObjectSlot());
#ifdef DEBUG
  Label isObject;
  masm.branchTestObject(Assembler::Equal, homeObjAddr, &isObject);
  masm.assumeUnreachable("[[HomeObject]] must be Object");
  masm.bind(&isObject);
#endif
  masm.unboxObject(homeObjAddr, scratch);

  // Load prototype from [[HomeObject]]
  masm.loadObjProto(scratch, proto);

#ifdef DEBUG
  // We won't encounter a lazy proto, because the prototype is guaranteed to
  // either be a JSFunction or a PlainObject, and only proxy objects can have a
  // lazy proto.
  MOZ_ASSERT(uintptr_t(TaggedProto::LazyProto) == 1);

  Label proxyCheckDone;
  masm.branchPtr(Assembler::NotEqual, proto, ImmWord(1), &proxyCheckDone);
  masm.assumeUnreachable("Unexpected lazy proto in JSOp::SuperBase");
  masm.bind(&proxyCheckDone);
#endif

  Label hasProto;
  masm.branchPtr(Assembler::NotEqual, proto, ImmWord(0), &hasProto);

  // Throw an error if |proto| is null.
  prepareVMCall();

  using Fn = bool (*)(JSContext*);
  if (!callVM<Fn, ThrowHomeObjectNotObject>()) {
    return false;
  }

  // Box prototype and return
  masm.bind(&hasProto);
  masm.tagValue(JSVAL_TYPE_OBJECT, proto, R1);
  frame.push(R1);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_SuperFun() {
  frame.popRegsAndSync(1);

  Register callee = R0.scratchReg();
  Register proto = R1.scratchReg();
#ifdef DEBUG
  Register scratch = R2.scratchReg();
#endif

  // Unbox callee.
  masm.unboxObject(R0, callee);

#ifdef DEBUG
  Label classCheckDone;
  masm.branchTestObjClass(Assembler::Equal, callee, &JSFunction::class_,
                          scratch, callee, &classCheckDone);
  masm.assumeUnreachable("Unexpected non-JSFunction callee in JSOp::SuperFun");
  masm.bind(&classCheckDone);
#endif

  // Load prototype of callee
  masm.loadObjProto(callee, proto);

#ifdef DEBUG
  // We won't encounter a lazy proto, because |callee| is guaranteed to be a
  // JSFunction and only proxy objects can have a lazy proto.
  MOZ_ASSERT(uintptr_t(TaggedProto::LazyProto) == 1);

  Label proxyCheckDone;
  masm.branchPtr(Assembler::NotEqual, proto, ImmWord(1), &proxyCheckDone);
  masm.assumeUnreachable("Unexpected lazy proto in JSOp::SuperFun");
  masm.bind(&proxyCheckDone);
#endif

  Label nullProto, done;
  masm.branchPtr(Assembler::Equal, proto, ImmWord(0), &nullProto);

  // Box prototype and return
  masm.tagValue(JSVAL_TYPE_OBJECT, proto, R1);
  masm.jump(&done);

  masm.bind(&nullProto);
  masm.moveValue(NullValue(), R1);

  masm.bind(&done);
  frame.push(R1);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Arguments() {
  frame.syncStack(0);

  MOZ_ASSERT_IF(handler.maybeScript(),
                handler.maybeScript()->argumentsHasVarBinding());

  Label done;
  if (!handler.maybeScript() || !handler.maybeScript()->needsArgsObj()) {
    // We assume the script does not need an arguments object. However, this
    // assumption can be invalidated later, see argumentsOptimizationFailed
    // in JSScript. Guard on the script's NeedsArgsObj flag.
    masm.moveValue(MagicValue(JS_OPTIMIZED_ARGUMENTS), R0);

    // If we don't need an arguments object, skip the VM call.
    Register scratch = R1.scratchReg();
    loadScript(scratch);
    masm.branchTest32(
        Assembler::Zero, Address(scratch, JSScript::offsetOfMutableFlags()),
        Imm32(uint32_t(JSScript::MutableFlags::NeedsArgsObj)), &done);
  }

  prepareVMCall();

  masm.loadBaselineFramePtr(BaselineFrameReg, R0.scratchReg());
  pushArg(R0.scratchReg());

  using Fn = bool (*)(JSContext*, BaselineFrame*, MutableHandleValue);
  if (!callVM<Fn, jit::NewArgumentsObject>()) {
    return false;
  }

  masm.bind(&done);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Rest() {
  frame.syncStack(0);

  if (!emitNextIC()) {
    return false;
  }

  // Mark R0 as pushed stack value.
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Generator() {
  frame.assertStackDepth(0);

  masm.loadBaselineFramePtr(BaselineFrameReg, R0.scratchReg());

  prepareVMCall();
  pushArg(R0.scratchReg());

  using Fn = JSObject* (*)(JSContext*, BaselineFrame*);
  if (!callVM<Fn, jit::CreateGenerator>()) {
    return false;
  }

  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitialYield() {
  frame.syncStack(0);
  frame.assertStackDepth(1);

  Register genObj = R2.scratchReg();
  masm.unboxObject(frame.addressOfStackValue(-1), genObj);

  MOZ_ASSERT_IF(handler.maybePC(), GET_RESUMEINDEX(handler.maybePC()) == 0);
  masm.storeValue(
      Int32Value(0),
      Address(genObj, AbstractGeneratorObject::offsetOfResumeIndexSlot()));

  Register envObj = R0.scratchReg();
  Register temp = R1.scratchReg();
  Address envChainSlot(genObj,
                       AbstractGeneratorObject::offsetOfEnvironmentChainSlot());
  masm.loadPtr(frame.addressOfEnvironmentChain(), envObj);
  masm.guardedCallPreBarrierAnyZone(envChainSlot, MIRType::Value, temp);
  masm.storeValue(JSVAL_TYPE_OBJECT, envObj, envChainSlot);

  Label skipBarrier;
  masm.branchPtrInNurseryChunk(Assembler::Equal, genObj, temp, &skipBarrier);
  masm.branchPtrInNurseryChunk(Assembler::NotEqual, envObj, temp, &skipBarrier);
  masm.push(genObj);
  MOZ_ASSERT(genObj == R2.scratchReg());
  masm.call(&postBarrierSlot_);
  masm.pop(genObj);
  masm.bind(&skipBarrier);

  masm.tagValue(JSVAL_TYPE_OBJECT, genObj, JSReturnOperand);
  if (!emitReturn()) {
    return false;
  }

  // Two extra stack values will be pushed when resuming the generator.
  frame.incStackDepth(2);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Yield() {
  // Store generator in R0.
  frame.popRegsAndSync(1);

  Register genObj = R2.scratchReg();
  masm.unboxObject(R0, genObj);

  if (frame.hasKnownStackDepth(1)) {
    // If the expression stack is empty, we can inline the Yield. Note that this
    // branch is never taken for the interpreter because it doesn't know static
    // stack depths.

    Register temp = R1.scratchReg();
    Address resumeIndexSlot(genObj,
                            AbstractGeneratorObject::offsetOfResumeIndexSlot());
    jsbytecode* pc = handler.maybePC();
    MOZ_ASSERT(pc, "compiler-only code never has a null pc");
    masm.move32(Imm32(GET_RESUMEINDEX(pc)), temp);
    masm.storeValue(JSVAL_TYPE_INT32, temp, resumeIndexSlot);

    Register envObj = R0.scratchReg();
    Address envChainSlot(
        genObj, AbstractGeneratorObject::offsetOfEnvironmentChainSlot());
    masm.loadPtr(frame.addressOfEnvironmentChain(), envObj);
    masm.guardedCallPreBarrier(envChainSlot, MIRType::Value);
    masm.storeValue(JSVAL_TYPE_OBJECT, envObj, envChainSlot);

    Label skipBarrier;
    masm.branchPtrInNurseryChunk(Assembler::Equal, genObj, temp, &skipBarrier);
    masm.branchPtrInNurseryChunk(Assembler::NotEqual, envObj, temp,
                                 &skipBarrier);
    MOZ_ASSERT(genObj == R2.scratchReg());
    masm.call(&postBarrierSlot_);
    masm.bind(&skipBarrier);
  } else {
    masm.loadBaselineFramePtr(BaselineFrameReg, R1.scratchReg());
    computeFrameSize(R0.scratchReg());

    prepareVMCall();
    pushBytecodePCArg();
    pushArg(R0.scratchReg());
    pushArg(R1.scratchReg());
    pushArg(genObj);

    using Fn = bool (*)(JSContext*, HandleObject, BaselineFrame*, uint32_t,
                        jsbytecode*);
    if (!callVM<Fn, jit::NormalSuspend>()) {
      return false;
    }
  }

  masm.loadValue(frame.addressOfStackValue(-1), JSReturnOperand);
  if (!emitReturn()) {
    return false;
  }

  // Two extra stack values will be pushed when resuming the generator.
  frame.incStackDepth(2);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Await() {
  return emit_Yield();
}

template <>
template <typename F>
bool BaselineCompilerCodeGen::emitAfterYieldDebugInstrumentation(
    const F& ifDebuggee, Register) {
  if (handler.compileDebugInstrumentation()) {
    return ifDebuggee();
  }
  return true;
}

template <>
template <typename F>
bool BaselineInterpreterCodeGen::emitAfterYieldDebugInstrumentation(
    const F& ifDebuggee, Register scratch) {
  // Note that we can't use emitDebugInstrumentation here because the frame's
  // DEBUGGEE flag hasn't been initialized yet.

  // If the current Realm is not a debuggee we're done.
  Label done;
  CodeOffset toggleOffset = masm.toggledJump(&done);
  if (!handler.addDebugInstrumentationOffset(cx, toggleOffset)) {
    return false;
  }
  masm.loadPtr(AbsoluteAddress(cx->addressOfRealm()), scratch);
  masm.branchTest32(Assembler::Zero,
                    Address(scratch, Realm::offsetOfDebugModeBits()),
                    Imm32(Realm::debugModeIsDebuggeeBit()), &done);

  if (!ifDebuggee()) {
    return false;
  }

  masm.bind(&done);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_AfterYield() {
  if (!emit_JumpTarget()) {
    return false;
  }

  auto ifDebuggee = [this]() {
    frame.assertSyncedStack();
    masm.loadBaselineFramePtr(BaselineFrameReg, R0.scratchReg());
    prepareVMCall();
    pushArg(R0.scratchReg());

    const RetAddrEntry::Kind kind = RetAddrEntry::Kind::DebugAfterYield;

    using Fn = bool (*)(JSContext*, BaselineFrame*);
    if (!callVM<Fn, jit::DebugAfterYield>(kind)) {
      return false;
    }

    return true;
  };
  return emitAfterYieldDebugInstrumentation(ifDebuggee, R0.scratchReg());
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_FinalYieldRval() {
  // Store generator in R0.
  frame.popRegsAndSync(1);
  masm.unboxObject(R0, R0.scratchReg());

  prepareVMCall();
  pushBytecodePCArg();
  pushArg(R0.scratchReg());

  using Fn = bool (*)(JSContext*, HandleObject, jsbytecode*);
  if (!callVM<Fn, jit::FinalSuspend>()) {
    return false;
  }

  masm.loadValue(frame.addressOfReturnValue(), JSReturnOperand);
  return emitReturn();
}

template <>
void BaselineCompilerCodeGen::emitJumpToInterpretOpLabel() {
  TrampolinePtr code =
      cx->runtime()->jitRuntime()->baselineInterpreter().interpretOpAddr();
  masm.jump(code);
}

template <>
void BaselineInterpreterCodeGen::emitJumpToInterpretOpLabel() {
  masm.jump(handler.interpretOpLabel());
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitEnterGeneratorCode(Register script,
                                                      Register resumeIndex,
                                                      Register scratch) {
  // Resume in either the BaselineScript (if present) or Baseline Interpreter.

  static_assert(BaselineDisabledScript == 0x1,
                "Comparison below requires specific sentinel encoding");

  Label noBaselineScript;
  masm.loadJitScript(script, scratch);
  masm.loadPtr(Address(scratch, JitScript::offsetOfBaselineScript()), scratch);
  masm.branchPtr(Assembler::BelowOrEqual, scratch,
                 ImmPtr(BaselineDisabledScriptPtr), &noBaselineScript);
  masm.load32(Address(scratch, BaselineScript::offsetOfResumeEntriesOffset()),
              script);
  masm.addPtr(scratch, script);
  masm.loadPtr(
      BaseIndex(script, resumeIndex, ScaleFromElemWidth(sizeof(uintptr_t))),
      scratch);
  masm.jump(scratch);

  masm.bind(&noBaselineScript);

  // Initialize interpreter frame fields.
  Address flagsAddr(BaselineFrameReg, BaselineFrame::reverseOffsetOfFlags());
  Address scriptAddr(BaselineFrameReg,
                     BaselineFrame::reverseOffsetOfInterpreterScript());
  masm.or32(Imm32(BaselineFrame::RUNNING_IN_INTERPRETER), flagsAddr);
  masm.storePtr(script, scriptAddr);

  // Initialize pc and jump to it.
  emitInterpJumpToResumeEntry(script, resumeIndex, scratch);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_Resume() {
  frame.syncStack(0);
  masm.assertStackAlignment(sizeof(Value), 0);

  AllocatableGeneralRegisterSet regs(GeneralRegisterSet::All());
  regs.take(BaselineFrameReg);
  if (HasInterpreterPCReg()) {
    regs.take(InterpreterPCReg);
  }

  saveInterpreterPCReg();

  // Load generator object.
  Register genObj = regs.takeAny();
  masm.unboxObject(frame.addressOfStackValue(-3), genObj);

  // Load callee.
  Register callee = regs.takeAny();
  masm.unboxObject(
      Address(genObj, AbstractGeneratorObject::offsetOfCalleeSlot()), callee);

  // Save a pointer to the JSOp::Resume operand stack Values.
  Register callerStackPtr = regs.takeAny();
  masm.computeEffectiveAddress(frame.addressOfStackValue(-1), callerStackPtr);

  // Branch to |interpret| to resume the generator in the C++ interpreter if the
  // script does not have a JitScript.
  Label interpret;
  Register scratch1 = regs.takeAny();
  masm.loadPtr(Address(callee, JSFunction::offsetOfScript()), scratch1);
  masm.branchIfScriptHasNoJitScript(scratch1, &interpret);

#ifdef JS_TRACE_LOGGING
  if (JS::TraceLoggerSupported()) {
    // TODO (bug 1565788): add Baseline Interpreter support.
    MOZ_CRASH("Unimplemented Baseline Interpreter TraceLogger support");
    masm.loadJitScript(scratch1, scratch1);
    Address baselineAddr(scratch1, JitScript::offsetOfBaselineScript());
    masm.loadPtr(baselineAddr, scratch1);
    if (!emitTraceLoggerResume(scratch1, regs)) {
      return false;
    }
  }
#endif

  // Push |undefined| for all formals.
  Register scratch2 = regs.takeAny();
  Label loop, loopDone;
  masm.load16ZeroExtend(Address(callee, JSFunction::offsetOfNargs()), scratch2);
  masm.branchTest32(Assembler::Zero, scratch2, scratch2, &loopDone);
  masm.bind(&loop);
  {
    masm.pushValue(UndefinedValue());
    masm.branchSub32(Assembler::NonZero, Imm32(1), scratch2, &loop);
  }
  masm.bind(&loopDone);

  // Push |undefined| for |this|.
  masm.pushValue(UndefinedValue());

  // Update BaselineFrame frameSize field and create the frame descriptor.
  masm.computeEffectiveAddress(
      Address(BaselineFrameReg, BaselineFrame::FramePointerOffset), scratch2);
  masm.subStackPtrFrom(scratch2);
#ifdef DEBUG
  masm.store32(scratch2, frame.addressOfDebugFrameSize());
#endif
  masm.makeFrameDescriptor(scratch2, FrameType::BaselineJS,
                           JitFrameLayout::Size());

  masm.push(Imm32(0));  // actual argc
  masm.PushCalleeToken(callee, /* constructing = */ false);
  masm.push(scratch2);  // frame descriptor

  // PushCalleeToken bumped framePushed. Reset it.
  MOZ_ASSERT(masm.framePushed() == sizeof(uintptr_t));
  masm.setFramePushed(0);

  regs.add(callee);

  // Push a fake return address on the stack. We will resume here when the
  // generator returns.
  Label genStart, returnTarget;
#ifdef JS_USE_LINK_REGISTER
  masm.call(&genStart);
#else
  masm.callAndPushReturnAddress(&genStart);
#endif

  // Record the return address so the return offset -> pc mapping works.
  if (!handler.recordCallRetAddr(cx, RetAddrEntry::Kind::IC,
                                 masm.currentOffset())) {
    return false;
  }

  masm.jump(&returnTarget);
  masm.bind(&genStart);
#ifdef JS_USE_LINK_REGISTER
  masm.pushReturnAddress();
#endif

  // If profiler instrumentation is on, update lastProfilingFrame on
  // current JitActivation
  {
    Register scratchReg = scratch2;
    Label skip;
    AbsoluteAddress addressOfEnabled(
        cx->runtime()->geckoProfiler().addressOfEnabled());
    masm.branch32(Assembler::Equal, addressOfEnabled, Imm32(0), &skip);
    masm.loadJSContext(scratchReg);
    masm.loadPtr(Address(scratchReg, JSContext::offsetOfProfilingActivation()),
                 scratchReg);
    masm.storeStackPtr(
        Address(scratchReg, JitActivation::offsetOfLastProfilingFrame()));
    masm.bind(&skip);
  }

  // Construct BaselineFrame.
  masm.push(BaselineFrameReg);
  masm.moveStackPtrTo(BaselineFrameReg);
  masm.subFromStackPtr(Imm32(BaselineFrame::Size()));
  masm.assertStackAlignment(sizeof(Value), 0);

  // Store flags and env chain.
  masm.store32(Imm32(BaselineFrame::HAS_INITIAL_ENV), frame.addressOfFlags());
  masm.unboxObject(
      Address(genObj, AbstractGeneratorObject::offsetOfEnvironmentChainSlot()),
      scratch2);
  masm.storePtr(scratch2, frame.addressOfEnvironmentChain());

  // Store the arguments object if there is one.
  Label noArgsObj;
  Address argsObjSlot(genObj, AbstractGeneratorObject::offsetOfArgsObjSlot());
  masm.branchTestUndefined(Assembler::Equal, argsObjSlot, &noArgsObj);
  masm.unboxObject(argsObjSlot, scratch2);
  {
    masm.storePtr(scratch2, frame.addressOfArgsObj());
    masm.or32(Imm32(BaselineFrame::HAS_ARGS_OBJ), frame.addressOfFlags());
  }
  masm.bind(&noArgsObj);

  // Push expression slots if needed.
  Label noExprStack;
  Address exprStackSlot(genObj,
                        AbstractGeneratorObject::offsetOfExpressionStackSlot());
  masm.branchTestNull(Assembler::Equal, exprStackSlot, &noExprStack);
  {
    masm.unboxObject(exprStackSlot, scratch2);

    Register initLength = regs.takeAny();
    masm.loadPtr(Address(scratch2, NativeObject::offsetOfElements()), scratch2);
    masm.load32(Address(scratch2, ObjectElements::offsetOfInitializedLength()),
                initLength);
    masm.store32(
        Imm32(0),
        Address(scratch2, ObjectElements::offsetOfInitializedLength()));

    Label loop, loopDone;
    masm.branchTest32(Assembler::Zero, initLength, initLength, &loopDone);
    masm.bind(&loop);
    {
      masm.pushValue(Address(scratch2, 0));
      masm.guardedCallPreBarrierAnyZone(Address(scratch2, 0), MIRType::Value,
                                        scratch1);
      masm.addPtr(Imm32(sizeof(Value)), scratch2);
      masm.branchSub32(Assembler::NonZero, Imm32(1), initLength, &loop);
    }
    masm.bind(&loopDone);
    regs.add(initLength);
  }

  masm.bind(&noExprStack);

  // Push arg, generator, resumeKind stack Values, in that order.
  masm.pushValue(Address(callerStackPtr, sizeof(Value)));
  masm.pushValue(JSVAL_TYPE_OBJECT, genObj);
  masm.pushValue(Address(callerStackPtr, 0));

  masm.switchToObjectRealm(genObj, scratch2);

  // Load script in scratch1.
  masm.unboxObject(
      Address(genObj, AbstractGeneratorObject::offsetOfCalleeSlot()), scratch1);
  masm.loadPtr(Address(scratch1, JSFunction::offsetOfScript()), scratch1);

  // Load resume index in scratch2 and mark generator as running.
  Address resumeIndexSlot(genObj,
                          AbstractGeneratorObject::offsetOfResumeIndexSlot());
  masm.unboxInt32(resumeIndexSlot, scratch2);
  masm.storeValue(Int32Value(AbstractGeneratorObject::RESUME_INDEX_RUNNING),
                  resumeIndexSlot);

  if (!emitEnterGeneratorCode(scratch1, scratch2, regs.getAny())) {
    return false;
  }

  // Call into the VM to resume the generator in the C++ interpreter if there's
  // no JitScript.
  masm.bind(&interpret);

  prepareVMCall();

  pushArg(callerStackPtr);
  pushArg(genObj);

  using Fn = bool (*)(JSContext*, HandleObject, Value*, MutableHandleValue);
  if (!callVM<Fn, jit::InterpretResume>()) {
    return false;
  }

  // After the generator returns, we restore the stack pointer, switch back to
  // the current realm, push the return value, and we're done.
  masm.bind(&returnTarget);
  masm.computeEffectiveAddress(frame.addressOfStackValue(-1),
                               masm.getStackPointer());
  if (JSScript* script = handler.maybeScript()) {
    masm.switchToRealm(script->realm(), R2.scratchReg());
  } else {
    masm.switchToBaselineFrameRealm(R2.scratchReg());
  }
  restoreInterpreterPCReg();
  frame.popn(3);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_CheckResumeKind() {
  // Load resumeKind in R1, generator in R0.
  frame.popRegsAndSync(2);

#ifdef DEBUG
  Label ok;
  masm.branchTestInt32(Assembler::Equal, R1, &ok);
  masm.assumeUnreachable("Expected int32 resumeKind");
  masm.bind(&ok);
#endif

  // If resumeKind is 'next' we don't have to do anything.
  Label done;
  masm.unboxInt32(R1, R1.scratchReg());
  masm.branch32(Assembler::Equal, R1.scratchReg(),
                Imm32(int32_t(GeneratorResumeKind::Next)), &done);

  prepareVMCall();

  pushArg(R1.scratchReg());  // resumeKind

  masm.loadValue(frame.addressOfStackValue(-1), R2);
  pushArg(R2);  // arg

  masm.unboxObject(R0, R0.scratchReg());
  pushArg(R0.scratchReg());  // genObj

  masm.loadBaselineFramePtr(BaselineFrameReg, R2.scratchReg());
  pushArg(R2.scratchReg());  // frame

  using Fn = bool (*)(JSContext*, BaselineFrame*,
                      Handle<AbstractGeneratorObject*>, HandleValue, int32_t);
  if (!callVM<Fn, jit::GeneratorThrowOrReturn>()) {
    return false;
  }

  masm.bind(&done);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_ResumeKind() {
  GeneratorResumeKind resumeKind = ResumeKindFromPC(handler.pc());
  frame.push(Int32Value(int32_t(resumeKind)));
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_ResumeKind() {
  LoadUint8Operand(masm, R0.scratchReg());
  masm.tagValue(JSVAL_TYPE_INT32, R0.scratchReg(), R0);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_DebugCheckSelfHosted() {
#ifdef DEBUG
  frame.syncStack(0);

  masm.loadValue(frame.addressOfStackValue(-1), R0);

  prepareVMCall();
  pushArg(R0);

  using Fn = bool (*)(JSContext*, HandleValue);
  if (!callVM<Fn, js::Debug_CheckSelfHosted>()) {
    return false;
  }
#endif
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_IsConstructing() {
  frame.push(MagicValue(JS_IS_CONSTRUCTING));
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_JumpTarget() {
  MaybeIncrementCodeCoverageCounter(masm, handler.script(), handler.pc());
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_JumpTarget() {
  Register scratch1 = R0.scratchReg();
  Register scratch2 = R1.scratchReg();

  Label skipCoverage;
  CodeOffset toggleOffset = masm.toggledJump(&skipCoverage);
  masm.call(handler.codeCoverageAtPCLabel());
  masm.bind(&skipCoverage);
  if (!handler.codeCoverageOffsets().append(toggleOffset.offset())) {
    return false;
  }

  // Load icIndex in scratch1.
  LoadInt32Operand(masm, scratch1);

  // scratch1 := scratch1 * sizeof(ICEntry)
  static_assert(sizeof(ICEntry) == 8 || sizeof(ICEntry) == 16,
                "shift below depends on ICEntry size");
  uint32_t shift = (sizeof(ICEntry) == 16) ? 4 : 3;
  masm.lshiftPtr(Imm32(shift), scratch1);

  // Compute ICEntry* and store to frame->interpreterICEntry.
  loadScript(scratch2);
  masm.loadJitScript(scratch2, scratch2);
  masm.computeEffectiveAddress(
      BaseIndex(scratch2, scratch1, TimesOne, JitScript::offsetOfICEntries()),
      scratch2);
  masm.storePtr(scratch2, frame.addressOfInterpreterICEntry());
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_CheckClassHeritage() {
  frame.syncStack(0);

  // Leave the heritage value on the stack.
  masm.loadValue(frame.addressOfStackValue(-1), R0);

  prepareVMCall();
  pushArg(R0);

  using Fn = bool (*)(JSContext*, HandleValue);
  return callVM<Fn, js::CheckClassHeritageOperation>();
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_InitHomeObject() {
  // Load HomeObject in R0.
  frame.popRegsAndSync(1);

  // Load function off stack
  Register func = R2.scratchReg();
  masm.unboxObject(frame.addressOfStackValue(-1), func);

  // Set HOMEOBJECT_SLOT
  Register temp = R1.scratchReg();
  Address addr(func, FunctionExtended::offsetOfMethodHomeObjectSlot());
  masm.guardedCallPreBarrierAnyZone(addr, MIRType::Value, temp);
  masm.storeValue(R0, addr);

  Label skipBarrier;
  masm.branchPtrInNurseryChunk(Assembler::Equal, func, temp, &skipBarrier);
  masm.branchValueIsNurseryCell(Assembler::NotEqual, R0, temp, &skipBarrier);
  masm.call(&postBarrierSlot_);
  masm.bind(&skipBarrier);

  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_FunctionProto() {
  // The function prototype is a constant for a given global.
  JSObject* funProto = FunctionProtoOperation(cx);
  if (!funProto) {
    return false;
  }
  frame.push(ObjectValue(*funProto));
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_FunctionProto() {
  prepareVMCall();

  using Fn = JSObject* (*)(JSContext*);
  if (!callVM<Fn, FunctionProtoOperation>()) {
    return false;
  }

  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_ObjWithProto() {
  frame.syncStack(0);

  // Leave the proto value on the stack for the decompiler
  masm.loadValue(frame.addressOfStackValue(-1), R0);

  prepareVMCall();
  pushArg(R0);

  using Fn = PlainObject* (*)(JSContext*, HandleValue);
  if (!callVM<Fn, js::ObjectWithProtoOperation>()) {
    return false;
  }

  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.pop();
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_FunWithProto() {
  frame.popRegsAndSync(1);

  masm.unboxObject(R0, R0.scratchReg());
  masm.loadPtr(frame.addressOfEnvironmentChain(), R1.scratchReg());

  prepareVMCall();
  pushArg(R0.scratchReg());
  pushArg(R1.scratchReg());
  pushScriptGCThingArg(ScriptGCThingType::Function, R0.scratchReg(),
                       R1.scratchReg());

  using Fn =
      JSObject* (*)(JSContext*, HandleFunction, HandleObject, HandleObject);
  if (!callVM<Fn, js::FunWithProtoOperation>()) {
    return false;
  }

  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_ClassConstructor() {
  frame.syncStack(0);

  // Pass nullptr as prototype to MakeDefaultConstructor
  prepareVMCall();
  pushArg(ImmPtr(nullptr));
  pushBytecodePCArg();
  pushScriptArg();

  using Fn =
      JSFunction* (*)(JSContext*, HandleScript, jsbytecode*, HandleObject);
  if (!callVM<Fn, js::MakeDefaultConstructor>()) {
    return false;
  }

  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_DerivedConstructor() {
  frame.popRegsAndSync(1);

  masm.unboxObject(R0, R0.scratchReg());

  prepareVMCall();
  pushArg(R0.scratchReg());
  pushBytecodePCArg();
  pushScriptArg();

  using Fn =
      JSFunction* (*)(JSContext*, HandleScript, jsbytecode*, HandleObject);
  if (!callVM<Fn, js::MakeDefaultConstructor>()) {
    return false;
  }

  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.push(R0);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_ImportMeta() {
  // Note: this is like the interpreter implementation, but optimized a bit by
  // calling GetModuleObjectForScript at compile-time.

  RootedModuleObject module(cx, GetModuleObjectForScript(handler.script()));
  MOZ_ASSERT(module);

  frame.syncStack(0);

  prepareVMCall();
  pushArg(ImmGCPtr(module));

  using Fn = JSObject* (*)(JSContext*, HandleObject);
  if (!callVM<Fn, js::GetOrCreateModuleMetaObject>()) {
    return false;
  }

  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.push(R0);
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_ImportMeta() {
  prepareVMCall();

  pushScriptArg();

  using Fn = JSObject* (*)(JSContext*, HandleScript);
  if (!callVM<Fn, ImportMetaOperation>()) {
    return false;
  }

  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.push(R0);
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emit_DynamicImport() {
  // Put specifier value in R0.
  frame.popRegsAndSync(1);

  prepareVMCall();
  pushArg(R0);
  pushScriptArg();

  using Fn = JSObject* (*)(JSContext*, HandleScript, HandleValue);
  if (!callVM<Fn, js::StartDynamicModuleImport>()) {
    return false;
  }

  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.push(R0);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_InstrumentationActive() {
  frame.syncStack(0);

  // RealmInstrumentation cannot be removed from a global without destroying the
  // entire realm, so its active address can be embedded into jitcode.
  const int32_t* address = RealmInstrumentation::addressOfActive(cx->global());

  Register scratch = R0.scratchReg();
  masm.load32(AbsoluteAddress(address), scratch);
  masm.tagValue(JSVAL_TYPE_BOOLEAN, scratch, R0);
  frame.push(R0, JSVAL_TYPE_BOOLEAN);

  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_InstrumentationActive() {
  prepareVMCall();

  using Fn = bool (*)(JSContext*, MutableHandleValue);
  if (!callVM<Fn, InstrumentationActiveOperation>()) {
    return false;
  }

  frame.push(R0);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_InstrumentationCallback() {
  JSObject* obj = RealmInstrumentation::getCallback(cx->global());
  MOZ_ASSERT(obj);
  frame.push(ObjectValue(*obj));
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_InstrumentationCallback() {
  prepareVMCall();

  using Fn = JSObject* (*)(JSContext*);
  if (!callVM<Fn, InstrumentationCallbackOperation>()) {
    return false;
  }

  masm.tagValue(JSVAL_TYPE_OBJECT, ReturnReg, R0);
  frame.push(R0);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_InstrumentationScriptId() {
  int32_t scriptId;
  RootedScript script(cx, handler.script());
  if (!RealmInstrumentation::getScriptId(cx, cx->global(), script, &scriptId)) {
    return false;
  }
  frame.push(Int32Value(scriptId));
  return true;
}

template <>
bool BaselineInterpreterCodeGen::emit_InstrumentationScriptId() {
  prepareVMCall();
  pushScriptArg();

  using Fn = bool (*)(JSContext*, HandleScript, MutableHandleValue);
  if (!callVM<Fn, InstrumentationScriptIdOperation>()) {
    return false;
  }

  frame.push(R0);
  return true;
}

template <>
bool BaselineCompilerCodeGen::emit_ForceInterpreter() {
  // Caller is responsible for checking script->hasForceInterpreterOp().
  MOZ_CRASH("JSOp::ForceInterpreter in baseline");
}

template <>
bool BaselineInterpreterCodeGen::emit_ForceInterpreter() {
  masm.assumeUnreachable("JSOp::ForceInterpreter");
  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitPrologue() {
#ifdef JS_USE_LINK_REGISTER
  // Push link register from generateEnterJIT()'s BLR.
  masm.pushReturnAddress();
  masm.checkStackAlignment();
#endif
  emitProfilerEnterFrame();

  masm.push(BaselineFrameReg);
  masm.moveStackPtrTo(BaselineFrameReg);
  masm.subFromStackPtr(Imm32(BaselineFrame::Size()));

  // Initialize BaselineFrame. Also handles env chain pre-initialization (in
  // case GC gets run during stack check). For global and eval scripts, the env
  // chain is in R1. For function scripts, the env chain is in the callee.
  emitInitFrameFields(R1.scratchReg());

  // When compiling with Debugger instrumentation, set the debuggeeness of
  // the frame before any operation that can call into the VM.
  if (!emitIsDebuggeeCheck()) {
    return false;
  }

  // Initialize the env chain before any operation that may call into the VM and
  // trigger a GC.
  if (!initEnvironmentChain()) {
    return false;
  }

  // Check for overrecursion before initializing locals.
  if (!emitStackCheck()) {
    return false;
  }

  emitInitializeLocals();

#ifdef JS_TRACE_LOGGING
  if (JS::TraceLoggerSupported() && !emitTraceLoggerEnter()) {
    return false;
  }
#endif

  // Ion prologue bailouts will enter here in the Baseline Interpreter.
  masm.bind(&bailoutPrologue_);

  frame.assertSyncedStack();

  if (JSScript* script = handler.maybeScript()) {
    masm.debugAssertContextRealm(script->realm(), R1.scratchReg());
  }

  if (!emitDebugPrologue()) {
    return false;
  }

  if (!emitHandleCodeCoverageAtPrologue()) {
    return false;
  }

  if (!emitWarmUpCounterIncrement()) {
    return false;
  }

  warmUpCheckPrologueOffset_ = CodeOffset(masm.currentOffset());

  if (!emitArgumentTypeChecks()) {
    return false;
  }

  return true;
}

template <typename Handler>
bool BaselineCodeGen<Handler>::emitEpilogue() {
  masm.bind(&return_);

  if (!handler.shouldEmitDebugEpilogueAtReturnOp()) {
    if (!emitDebugEpilogue()) {
      return false;
    }
  }

#ifdef JS_TRACE_LOGGING
  if (JS::TraceLoggerSupported() && !emitTraceLoggerExit()) {
    return false;
  }
#endif

  masm.moveToStackPtr(BaselineFrameReg);
  masm.pop(BaselineFrameReg);

  emitProfilerExitFrame();

  masm.ret();
  return true;
}

MethodStatus BaselineCompiler::emitBody() {
  JSScript* script = handler.script();
  MOZ_ASSERT(handler.pc() == script->code());

  mozilla::DebugOnly<jsbytecode*> prevpc = handler.pc();

  while (true) {
    JSOp op = JSOp(*handler.pc());
    JitSpew(JitSpew_BaselineOp, "Compiling op @ %d: %s",
            int(script->pcToOffset(handler.pc())), CodeName(op));

    BytecodeInfo* info = handler.analysis().maybeInfo(handler.pc());

    // Skip unreachable ops.
    if (!info) {
      // Test if last instructions and stop emitting in that case.
      handler.moveToNextPC();
      if (handler.pc() >= script->codeEnd()) {
        break;
      }

      prevpc = handler.pc();
      continue;
    }

    if (info->jumpTarget) {
      // Fully sync the stack if there are incoming jumps.
      frame.syncStack(0);
      frame.setStackDepth(info->stackDepth);
      masm.bind(handler.labelOf(handler.pc()));
    } else if (MOZ_UNLIKELY(compileDebugInstrumentation())) {
      // Also fully sync the stack if the debugger is enabled.
      frame.syncStack(0);
    } else {
      // At the beginning of any op, at most the top 2 stack-values are
      // unsynced.
      if (frame.stackDepth() > 2) {
        frame.syncStack(2);
      }
    }

    frame.assertValidState(*info);

    // If the script has a resume offset for this pc we need to keep track of
    // the native code offset.
    if (info->hasResumeOffset) {
      frame.assertSyncedStack();
      uint32_t pcOffset = script->pcToOffset(handler.pc());
      uint32_t nativeOffset = masm.currentOffset();
      if (!resumeOffsetEntries_.emplaceBack(pcOffset, nativeOffset)) {
        ReportOutOfMemory(cx);
        return Method_Error;
      }
    }

    // Emit traps for breakpoints and step mode.
    if (MOZ_UNLIKELY(compileDebugInstrumentation()) && !emitDebugTrap()) {
      return Method_Error;
    }

#define EMIT_OP(OP, ...)                                       \
  case JSOp::OP:                                               \
    if (MOZ_UNLIKELY(!this->emit_##OP())) return Method_Error; \
    break;

    switch (op) {
      FOR_EACH_OPCODE(EMIT_OP)
      default:
        MOZ_CRASH("Unexpected op");
    }

#undef EMIT_OP

    MOZ_ASSERT(masm.framePushed() == 0);

    // Test if last instructions and stop emitting in that case.
    handler.moveToNextPC();
    if (handler.pc() >= script->codeEnd()) {
      break;
    }

#ifdef DEBUG
    prevpc = handler.pc();
#endif
  }

  MOZ_ASSERT(JSOp(*prevpc) == JSOp::RetRval);
  return Method_Compiled;
}

bool BaselineInterpreterGenerator::emitDebugTrap() {
  CodeOffset offset = masm.nopPatchableToCall();
  if (!debugTrapOffsets_.append(offset.offset())) {
    ReportOutOfMemory(cx);
    return false;
  }

  return true;
}

// Register holding the bytecode pc during dispatch. This exists so the debug
// trap handler can reload the pc into this register when it's done.
static constexpr Register InterpreterPCRegAtDispatch =
    HasInterpreterPCReg() ? InterpreterPCReg : R0.scratchReg();

bool BaselineInterpreterGenerator::emitInterpreterLoop() {
  Register scratch1 = R0.scratchReg();
  Register scratch2 = R1.scratchReg();

  // Entry point for interpreting a bytecode op. No registers are live except
  // for InterpreterPCReg.
  masm.bind(handler.interpretOpWithPCRegLabel());

  // Emit a patchable call for debugger breakpoints/stepping.
  if (!emitDebugTrap()) {
    return false;
  }
  Label interpretOpAfterDebugTrap;
  masm.bind(&interpretOpAfterDebugTrap);

  // Load pc, bytecode op.
  Register pcReg = LoadBytecodePC(masm, scratch1);
  masm.load8ZeroExtend(Address(pcReg, 0), scratch1);

  // Jump to table[op].
  {
    CodeOffset label = masm.moveNearAddressWithPatch(scratch2);
    if (!tableLabels_.append(label)) {
      return false;
    }
    BaseIndex pointer(scratch2, scratch1, ScalePointer);
    masm.branchToComputedAddress(pointer);
  }

  // At the end of each op, emit code to bump the pc and jump to the
  // next op (this is also known as a threaded interpreter).
  auto opEpilogue = [&](JSOp op, size_t opLength) -> bool {
    MOZ_ASSERT(masm.framePushed() == 0);

    if (!BytecodeFallsThrough(op)) {
      // Nothing to do.
      masm.assumeUnreachable("unexpected fall through");
      return true;
    }

    // Bump frame->interpreterICEntry if needed.
    if (BytecodeOpHasIC(op)) {
      frame.bumpInterpreterICEntry();
    }

    // Bump bytecode PC.
    if (HasInterpreterPCReg()) {
      MOZ_ASSERT(InterpreterPCRegAtDispatch == InterpreterPCReg);
      masm.addPtr(Imm32(opLength), InterpreterPCReg);
    } else {
      MOZ_ASSERT(InterpreterPCRegAtDispatch == scratch1);
      masm.loadPtr(frame.addressOfInterpreterPC(), InterpreterPCRegAtDispatch);
      masm.addPtr(Imm32(opLength), InterpreterPCRegAtDispatch);
      masm.storePtr(InterpreterPCRegAtDispatch, frame.addressOfInterpreterPC());
    }

    if (!emitDebugTrap()) {
      return false;
    }

    // Load the opcode, jump to table[op].
    masm.load8ZeroExtend(Address(InterpreterPCRegAtDispatch, 0), scratch1);
    CodeOffset label = masm.moveNearAddressWithPatch(scratch2);
    if (!tableLabels_.append(label)) {
      return false;
    }
    BaseIndex pointer(scratch2, scratch1, ScalePointer);
    masm.branchToComputedAddress(pointer);
    return true;
  };

  // Emit code for each bytecode op.
  Label opLabels[JSOP_LIMIT];
#define EMIT_OP(OP, ...)                          \
  {                                               \
    masm.bind(&opLabels[uint8_t(JSOp::OP)]);      \
    handler.setCurrentOp(JSOp::OP);               \
    if (!this->emit_##OP()) {                     \
      return false;                               \
    }                                             \
    if (!opEpilogue(JSOp::OP, JSOpLength_##OP)) { \
      return false;                               \
    }                                             \
    handler.resetCurrentOp();                     \
  }
  FOR_EACH_OPCODE(EMIT_OP)
#undef EMIT_OP

  // External entry point to start interpreting bytecode ops. This is used for
  // things like exception handling and OSR. DebugModeOSR patches JIT frames to
  // return here from the DebugTrapHandler.
  masm.bind(handler.interpretOpLabel());
  interpretOpOffset_ = masm.currentOffset();
  restoreInterpreterPCReg();
  masm.jump(handler.interpretOpWithPCRegLabel());

  // Second external entry point: this skips the debug trap for the first op
  // and is used by OSR.
  interpretOpNoDebugTrapOffset_ = masm.currentOffset();
  restoreInterpreterPCReg();
  masm.jump(&interpretOpAfterDebugTrap);

  // External entry point for Ion prologue bailouts.
  bailoutPrologueOffset_ = CodeOffset(masm.currentOffset());
  restoreInterpreterPCReg();
  masm.jump(&bailoutPrologue_);

  // Emit debug trap handler code (target of patchable call instructions). This
  // is just a tail call to the debug trap handler trampoline code.
  {
    JitRuntime* jrt = cx->runtime()->jitRuntime();
    JitCode* handlerCode =
        jrt->debugTrapHandler(cx, DebugTrapHandlerKind::Interpreter);
    if (!handlerCode) {
      return false;
    }

    debugTrapHandlerOffset_ = masm.currentOffset();
    masm.jump(handlerCode);
  }

  // Emit the table.
  masm.haltingAlign(sizeof(void*));

#if defined(JS_CODEGEN_ARM) || defined(JS_CODEGEN_ARM64)
  size_t numInstructions = JSOP_LIMIT * (sizeof(uintptr_t) / sizeof(uint32_t));
  AutoForbidPoolsAndNops afp(&masm, numInstructions);
#endif

  tableOffset_ = masm.currentOffset();

  for (size_t i = 0; i < JSOP_LIMIT; i++) {
    const Label& opLabel = opLabels[i];
    MOZ_ASSERT(opLabel.bound());
    CodeLabel cl;
    masm.writeCodePointer(&cl);
    cl.target()->bind(opLabel.offset());
    masm.addCodeLabel(cl);
  }

  return true;
}

void BaselineInterpreterGenerator::emitOutOfLineCodeCoverageInstrumentation() {
  masm.bind(handler.codeCoverageAtPrologueLabel());
#ifdef JS_USE_LINK_REGISTER
  masm.pushReturnAddress();
#endif

  saveInterpreterPCReg();

  masm.setupUnalignedABICall(R0.scratchReg());
  masm.loadBaselineFramePtr(BaselineFrameReg, R0.scratchReg());
  masm.passABIArg(R0.scratchReg());
  masm.callWithABI(
      JS_FUNC_TO_DATA_PTR(void*, jit::HandleCodeCoverageAtPrologue));

  restoreInterpreterPCReg();
  masm.ret();

  masm.bind(handler.codeCoverageAtPCLabel());
#ifdef JS_USE_LINK_REGISTER
  masm.pushReturnAddress();
#endif

  saveInterpreterPCReg();

  masm.setupUnalignedABICall(R0.scratchReg());
  masm.loadBaselineFramePtr(BaselineFrameReg, R0.scratchReg());
  masm.passABIArg(R0.scratchReg());
  Register pcReg = LoadBytecodePC(masm, R2.scratchReg());
  masm.passABIArg(pcReg);
  masm.callWithABI(JS_FUNC_TO_DATA_PTR(void*, jit::HandleCodeCoverageAtPC));

  restoreInterpreterPCReg();
  masm.ret();
}

bool BaselineInterpreterGenerator::generate(BaselineInterpreter& interpreter) {
  if (!emitPrologue()) {
    return false;
  }

  if (!emitInterpreterLoop()) {
    return false;
  }

  if (!emitEpilogue()) {
    return false;
  }

  if (!emitOutOfLinePostBarrierSlot()) {
    return false;
  }

  emitOutOfLineCodeCoverageInstrumentation();

  {
    Linker linker(masm);
    if (masm.oom()) {
      ReportOutOfMemory(cx);
      return false;
    }

    JitCode* code = linker.newCode(cx, CodeKind::Other);
    if (!code) {
      return false;
    }

    // Register BaselineInterpreter code with the profiler's JitCode table.
    {
      JitcodeGlobalEntry::BaselineInterpreterEntry entry;
      entry.init(code, code->raw(), code->rawEnd());

      JitcodeGlobalTable* globalTable =
          cx->runtime()->jitRuntime()->getJitcodeGlobalTable();
      if (!globalTable->addEntry(entry)) {
        ReportOutOfMemory(cx);
        return false;
      }

      code->setHasBytecodeMap();
    }

    // Patch loads now that we know the tableswitch base address.
    CodeLocationLabel tableLoc(code, CodeOffset(tableOffset_));
    for (CodeOffset off : tableLabels_) {
      MacroAssembler::patchNearAddressMove(CodeLocationLabel(code, off),
                                           tableLoc);
    }

#ifdef JS_ION_PERF
    writePerfSpewerJitCodeProfile(code, "BaselineInterpreter");
#endif

#ifdef MOZ_VTUNE
    vtune::MarkStub(code, "BaselineInterpreter");
#endif

    interpreter.init(
        code, interpretOpOffset_, interpretOpNoDebugTrapOffset_,
        bailoutPrologueOffset_.offset(),
        profilerEnterFrameToggleOffset_.offset(),
        profilerExitFrameToggleOffset_.offset(), debugTrapHandlerOffset_,
        std::move(handler.debugInstrumentationOffsets()),
        std::move(debugTrapOffsets_), std::move(handler.codeCoverageOffsets()),
        std::move(handler.icReturnOffsets()), handler.callVMOffsets());
  }

  if (cx->runtime()->geckoProfiler().enabled()) {
    interpreter.toggleProfilerInstrumentation(true);
  }

  if (coverage::IsLCovEnabled()) {
    interpreter.toggleCodeCoverageInstrumentationUnchecked(true);
  }

  return true;
}

JitCode* JitRuntime::generateDebugTrapHandler(JSContext* cx,
                                              DebugTrapHandlerKind kind) {
  StackMacroAssembler masm;

  AllocatableGeneralRegisterSet regs(GeneralRegisterSet::All());
  regs.takeUnchecked(BaselineFrameReg);
  regs.takeUnchecked(ICStubReg);
  if (HasInterpreterPCReg()) {
    regs.takeUnchecked(InterpreterPCReg);
  }
#ifdef JS_CODEGEN_ARM
  regs.takeUnchecked(BaselineSecondScratchReg);
  masm.setSecondScratchReg(BaselineSecondScratchReg);
#endif
  Register scratch1 = regs.takeAny();
  Register scratch2 = regs.takeAny();
  Register scratch3 = regs.takeAny();

  if (kind == DebugTrapHandlerKind::Interpreter) {
    // The interpreter calls this for every script when debugging, so check if
    // the script has any breakpoints or is in step mode before calling into
    // C++.
    Label hasDebugScript;
    Address scriptAddr(BaselineFrameReg,
                       BaselineFrame::reverseOffsetOfInterpreterScript());
    masm.loadPtr(scriptAddr, scratch1);
    masm.branchTest32(Assembler::NonZero,
                      Address(scratch1, JSScript::offsetOfMutableFlags()),
                      Imm32(int32_t(JSScript::MutableFlags::HasDebugScript)),
                      &hasDebugScript);
    masm.abiret();
    masm.bind(&hasDebugScript);

    if (HasInterpreterPCReg()) {
      // Update frame's bytecode pc because the debugger depends on it.
      Address pcAddr(BaselineFrameReg,
                     BaselineFrame::reverseOffsetOfInterpreterPC());
      masm.storePtr(InterpreterPCReg, pcAddr);
    }
  }

  // Load the return address in scratch1.
  masm.loadAbiReturnAddress(scratch1);

  // Load BaselineFrame pointer in scratch2.
  masm.loadBaselineFramePtr(BaselineFrameReg, scratch2);

  // Enter a stub frame and call the HandleDebugTrap VM function. Ensure
  // the stub frame has a nullptr ICStub pointer, since this pointer is marked
  // during GC.
  masm.movePtr(ImmPtr(nullptr), ICStubReg);
  EmitBaselineEnterStubFrame(masm, scratch3);

  using Fn = bool (*)(JSContext*, BaselineFrame*, uint8_t*);
  VMFunctionId id = VMFunctionToId<Fn, jit::HandleDebugTrap>::id;
  TrampolinePtr code = cx->runtime()->jitRuntime()->getVMWrapper(id);

  masm.push(scratch1);
  masm.push(scratch2);
  EmitBaselineCallVM(code, masm);

  EmitBaselineLeaveStubFrame(masm);

  if (kind == DebugTrapHandlerKind::Interpreter) {
    // We have to reload the bytecode pc register.
    Address pcAddr(BaselineFrameReg,
                   BaselineFrame::reverseOffsetOfInterpreterPC());
    masm.loadPtr(pcAddr, InterpreterPCRegAtDispatch);
  }
  masm.abiret();

  Linker linker(masm);
  JitCode* handlerCode = linker.newCode(cx, CodeKind::Other);
  if (!handlerCode) {
    return nullptr;
  }

#ifdef JS_ION_PERF
  writePerfSpewerJitCodeProfile(handlerCode, "DebugTrapHandler");
#endif
#ifdef MOZ_VTUNE
  vtune::MarkStub(handlerCode, "DebugTrapHandler");
#endif

  return handlerCode;
}

}  // namespace jit
}  // namespace js
