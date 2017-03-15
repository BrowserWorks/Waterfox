/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 *
 * Copyright 2016 Mozilla Foundation
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

#include "wasm/WasmCode.h"

#include "mozilla/Atomics.h"
#include "mozilla/BinarySearch.h"
#include "mozilla/EnumeratedRange.h"

#include "jsprf.h"

#include "jit/ExecutableAllocator.h"
#include "jit/MacroAssembler.h"
#ifdef JS_ION_PERF
# include "jit/PerfSpewer.h"
#endif
#include "vm/StringBuffer.h"
#ifdef MOZ_VTUNE
# include "vtune/VTuneWrapper.h"
#endif
#include "wasm/WasmBinaryToText.h"
#include "wasm/WasmModule.h"
#include "wasm/WasmSerialize.h"

#include "jit/MacroAssembler-inl.h"
#include "vm/ArrayBufferObject-inl.h"

using namespace js;
using namespace js::jit;
using namespace js::wasm;
using mozilla::Atomic;
using mozilla::BinarySearch;
using mozilla::MakeEnumeratedRange;
using JS::GenericNaN;

// Limit the number of concurrent wasm code allocations per process. Note that
// on Linux, the real maximum is ~32k, as each module requires 2 maps (RW/RX),
// and the kernel's default max_map_count is ~65k.
//
// Note: this can be removed once writable/non-executable global data stops
// being stored in the code segment.
static Atomic<uint32_t> wasmCodeAllocations(0);
static const uint32_t MaxWasmCodeAllocations = 16384;

static uint8_t*
AllocateCodeSegment(JSContext* cx, uint32_t totalLength)
{
    if (wasmCodeAllocations >= MaxWasmCodeAllocations)
        return nullptr;

    // codeLength is a multiple of the system's page size, but not necessarily
    // a multiple of ExecutableCodePageSize.
    totalLength = JS_ROUNDUP(totalLength, ExecutableCodePageSize);

    void* p = AllocateExecutableMemory(totalLength, ProtectionSetting::Writable);

    // If the allocation failed and the embedding gives us a last-ditch attempt
    // to purge all memory (which, in gecko, does a purging GC/CC/GC), do that
    // then retry the allocation.
    if (!p) {
        JSRuntime* rt = cx->runtime();
        if (rt->largeAllocationFailureCallback) {
            rt->largeAllocationFailureCallback(rt->largeAllocationFailureCallbackData);
            p = AllocateExecutableMemory(totalLength, ProtectionSetting::Writable);
        }
    }

    if (!p) {
        ReportOutOfMemory(cx);
        return nullptr;
    }

    wasmCodeAllocations++;
    return (uint8_t*)p;
}

static void
StaticallyLink(CodeSegment& cs, const LinkData& linkData, ExclusiveContext* cx)
{
    for (LinkData::InternalLink link : linkData.internalLinks) {
        uint8_t* patchAt = cs.base() + link.patchAtOffset;
        void* target = cs.base() + link.targetOffset;
        if (link.isRawPointerPatch())
            *(void**)(patchAt) = target;
        else
            Assembler::PatchInstructionImmediate(patchAt, PatchedImmPtr(target));
    }

    for (auto imm : MakeEnumeratedRange(SymbolicAddress::Limit)) {
        const Uint32Vector& offsets = linkData.symbolicLinks[imm];
        for (size_t i = 0; i < offsets.length(); i++) {
            uint8_t* patchAt = cs.base() + offsets[i];
            void* target = AddressOf(imm, cx);
            Assembler::PatchDataWithValueCheck(CodeLocationLabel(patchAt),
                                               PatchedImmPtr(target),
                                               PatchedImmPtr((void*)-1));
        }
    }

    // These constants are logically part of the code:

    *(double*)(cs.globalData() + NaN64GlobalDataOffset) = GenericNaN();
    *(float*)(cs.globalData() + NaN32GlobalDataOffset) = GenericNaN();
}

static void
SpecializeToMemory(uint8_t* prevMemoryBase, CodeSegment& cs, const Metadata& metadata,
                   ArrayBufferObjectMaybeShared& buffer)
{
#ifdef WASM_HUGE_MEMORY
    MOZ_RELEASE_ASSERT(metadata.boundsChecks.empty());
#else
    uint32_t limit = buffer.wasmBoundsCheckLimit();
    MOZ_RELEASE_ASSERT(IsValidBoundsCheckImmediate(limit));

    for (const BoundsCheck& check : metadata.boundsChecks)
        MacroAssembler::wasmPatchBoundsCheck(check.patchAt(cs.base()), limit);
#endif

#if defined(JS_CODEGEN_X86)
    uint8_t* memoryBase = buffer.dataPointerEither().unwrap(/* code patching */);
    if (prevMemoryBase != memoryBase) {
        for (MemoryPatch patch : metadata.memoryPatches) {
            void* patchAt = cs.base() + patch.offset;

            uint8_t* prevImm = (uint8_t*)X86Encoding::GetPointer(patchAt);
            MOZ_ASSERT(prevImm >= prevMemoryBase);

            uint32_t offset = prevImm - prevMemoryBase;
            MOZ_ASSERT(offset <= INT32_MAX);

            X86Encoding::SetPointer(patchAt, memoryBase + offset);
        }
    }
#else
    MOZ_RELEASE_ASSERT(metadata.memoryPatches.empty());
#endif
}

static bool
SendCodeRangesToProfiler(JSContext* cx, CodeSegment& cs, const Bytes& bytecode,
                         const Metadata& metadata)
{
    bool enabled = false;
#ifdef JS_ION_PERF
    enabled |= PerfFuncEnabled();
#endif
#ifdef MOZ_VTUNE
    enabled |= IsVTuneProfilingActive();
#endif
    if (!enabled)
        return true;

    for (const CodeRange& codeRange : metadata.codeRanges) {
        if (!codeRange.isFunction())
            continue;

        uintptr_t start = uintptr_t(cs.base() + codeRange.begin());
        uintptr_t end = uintptr_t(cs.base() + codeRange.end());
        uintptr_t size = end - start;

        TwoByteName name(cx);
        if (!metadata.getFuncName(cx, &bytecode, codeRange.funcIndex(), &name))
            return false;

        UniqueChars chars(
            (char*)JS::LossyTwoByteCharsToNewLatin1CharsZ(cx, name.begin(), name.length()).get());
        if (!chars)
            return false;

        // Avoid "unused" warnings
        (void)start;
        (void)size;

#ifdef JS_ION_PERF
        if (PerfFuncEnabled()) {
            const char* file = metadata.filename.get();
            unsigned line = codeRange.funcLineOrBytecode();
            unsigned column = 0;
            writePerfSpewerAsmJSFunctionMap(start, size, file, line, column, chars.get());
        }
#endif
#ifdef MOZ_VTUNE
        if (IsVTuneProfilingActive()) {
            unsigned method_id = iJIT_GetNewMethodID();
            if (method_id == 0)
                return true;
            iJIT_Method_Load method;
            method.method_id = method_id;
            method.method_name = chars.get();
            method.method_load_address = (void*)start;
            method.method_size = size;
            method.line_number_size = 0;
            method.line_number_table = nullptr;
            method.class_id = 0;
            method.class_file_name = nullptr;
            method.source_file_name = nullptr;
            iJIT_NotifyEvent(iJVM_EVENT_TYPE_METHOD_LOAD_FINISHED, (void*)&method);
        }
#endif
    }

    return true;
}

/* static */ UniqueCodeSegment
CodeSegment::create(JSContext* cx,
                    const Bytes& bytecode,
                    const LinkData& linkData,
                    const Metadata& metadata,
                    HandleWasmMemoryObject memory)
{
    MOZ_ASSERT(bytecode.length() % gc::SystemPageSize() == 0);
    MOZ_ASSERT(linkData.globalDataLength % gc::SystemPageSize() == 0);
    MOZ_ASSERT(linkData.functionCodeLength < bytecode.length());

    auto cs = cx->make_unique<CodeSegment>();
    if (!cs)
        return nullptr;

    cs->bytes_ = AllocateCodeSegment(cx, bytecode.length() + linkData.globalDataLength);
    if (!cs->bytes_)
        return nullptr;

    uint8_t* codeBase = cs->base();

    cs->functionCodeLength_ = linkData.functionCodeLength;
    cs->codeLength_ = bytecode.length();
    cs->globalDataLength_ = linkData.globalDataLength;
    cs->interruptCode_ = codeBase + linkData.interruptOffset;
    cs->outOfBoundsCode_ = codeBase + linkData.outOfBoundsOffset;
    cs->unalignedAccessCode_ = codeBase + linkData.unalignedAccessOffset;

    {
        JitContext jcx(CompileRuntime::get(cx->compartment()->runtimeFromAnyThread()));
        AutoFlushICache afc("CodeSegment::create");
        AutoFlushICache::setRange(uintptr_t(codeBase), cs->codeLength());

        memcpy(codeBase, bytecode.begin(), bytecode.length());
        StaticallyLink(*cs, linkData, cx);
        if (memory)
            SpecializeToMemory(nullptr, *cs, metadata, memory->buffer());
    }

    if (!ExecutableAllocator::makeExecutable(codeBase, cs->codeLength())) {
        ReportOutOfMemory(cx);
        return nullptr;
    }

    if (!SendCodeRangesToProfiler(cx, *cs, bytecode, metadata))
        return nullptr;

    return cs;
}

CodeSegment::~CodeSegment()
{
    if (!bytes_)
        return;

    MOZ_ASSERT(wasmCodeAllocations > 0);
    wasmCodeAllocations--;

    MOZ_ASSERT(totalLength() > 0);

    // Match AllocateCodeSegment.
    uint32_t size = JS_ROUNDUP(totalLength(), ExecutableCodePageSize);
    DeallocateExecutableMemory(bytes_, size);
}

void
CodeSegment::onMovingGrow(uint8_t* prevMemoryBase, const Metadata& metadata, ArrayBufferObject& buffer)
{
    AutoWritableJitCode awjc(base(), codeLength());
    AutoFlushICache afc("CodeSegment::onMovingGrow");
    AutoFlushICache::setRange(uintptr_t(base()), codeLength());

    SpecializeToMemory(prevMemoryBase, *this, metadata, buffer);
}

size_t
FuncExport::serializedSize() const
{
    return sig_.serializedSize() +
           sizeof(pod);
}

uint8_t*
FuncExport::serialize(uint8_t* cursor) const
{
    cursor = sig_.serialize(cursor);
    cursor = WriteBytes(cursor, &pod, sizeof(pod));
    return cursor;
}

const uint8_t*
FuncExport::deserialize(const uint8_t* cursor)
{
    (cursor = sig_.deserialize(cursor)) &&
    (cursor = ReadBytes(cursor, &pod, sizeof(pod)));
    return cursor;
}

size_t
FuncExport::sizeOfExcludingThis(MallocSizeOf mallocSizeOf) const
{
    return sig_.sizeOfExcludingThis(mallocSizeOf);
}

size_t
FuncImport::serializedSize() const
{
    return sig_.serializedSize() +
           sizeof(pod);
}

uint8_t*
FuncImport::serialize(uint8_t* cursor) const
{
    cursor = sig_.serialize(cursor);
    cursor = WriteBytes(cursor, &pod, sizeof(pod));
    return cursor;
}

const uint8_t*
FuncImport::deserialize(const uint8_t* cursor)
{
    (cursor = sig_.deserialize(cursor)) &&
    (cursor = ReadBytes(cursor, &pod, sizeof(pod)));
    return cursor;
}

size_t
FuncImport::sizeOfExcludingThis(MallocSizeOf mallocSizeOf) const
{
    return sig_.sizeOfExcludingThis(mallocSizeOf);
}

CodeRange::CodeRange(Kind kind, Offsets offsets)
  : begin_(offsets.begin),
    profilingReturn_(0),
    end_(offsets.end),
    funcIndex_(0),
    funcLineOrBytecode_(0),
    funcBeginToTableEntry_(0),
    funcBeginToTableProfilingJump_(0),
    funcBeginToNonProfilingEntry_(0),
    funcProfilingJumpToProfilingReturn_(0),
    funcProfilingEpilogueToProfilingReturn_(0),
    kind_(kind)
{
    MOZ_ASSERT(begin_ <= end_);
    MOZ_ASSERT(kind_ == Entry || kind_ == Inline || kind_ == FarJumpIsland);
}

CodeRange::CodeRange(Kind kind, ProfilingOffsets offsets)
  : begin_(offsets.begin),
    profilingReturn_(offsets.profilingReturn),
    end_(offsets.end),
    funcIndex_(0),
    funcLineOrBytecode_(0),
    funcBeginToTableEntry_(0),
    funcBeginToTableProfilingJump_(0),
    funcBeginToNonProfilingEntry_(0),
    funcProfilingJumpToProfilingReturn_(0),
    funcProfilingEpilogueToProfilingReturn_(0),
    kind_(kind)
{
    MOZ_ASSERT(begin_ < profilingReturn_);
    MOZ_ASSERT(profilingReturn_ < end_);
    MOZ_ASSERT(kind_ == ImportJitExit || kind_ == ImportInterpExit || kind_ == TrapExit);
}

CodeRange::CodeRange(uint32_t funcIndex, uint32_t funcLineOrBytecode, FuncOffsets offsets)
  : begin_(offsets.begin),
    profilingReturn_(offsets.profilingReturn),
    end_(offsets.end),
    funcIndex_(funcIndex),
    funcLineOrBytecode_(funcLineOrBytecode),
    funcBeginToTableEntry_(offsets.tableEntry - begin_),
    funcBeginToTableProfilingJump_(offsets.tableProfilingJump - begin_),
    funcBeginToNonProfilingEntry_(offsets.nonProfilingEntry - begin_),
    funcProfilingJumpToProfilingReturn_(profilingReturn_ - offsets.profilingJump),
    funcProfilingEpilogueToProfilingReturn_(profilingReturn_ - offsets.profilingEpilogue),
    kind_(Function)
{
    MOZ_ASSERT(begin_ < profilingReturn_);
    MOZ_ASSERT(profilingReturn_ < end_);
    MOZ_ASSERT(funcBeginToTableEntry_ == offsets.tableEntry - begin_);
    MOZ_ASSERT(funcBeginToTableProfilingJump_ == offsets.tableProfilingJump - begin_);
    MOZ_ASSERT(funcBeginToNonProfilingEntry_ == offsets.nonProfilingEntry - begin_);
    MOZ_ASSERT(funcProfilingJumpToProfilingReturn_ == profilingReturn_ - offsets.profilingJump);
    MOZ_ASSERT(funcProfilingEpilogueToProfilingReturn_ == profilingReturn_ - offsets.profilingEpilogue);
}

static size_t
StringLengthWithNullChar(const char* chars)
{
    return chars ? strlen(chars) + 1 : 0;
}

size_t
CacheableChars::serializedSize() const
{
    return sizeof(uint32_t) + StringLengthWithNullChar(get());
}

uint8_t*
CacheableChars::serialize(uint8_t* cursor) const
{
    uint32_t lengthWithNullChar = StringLengthWithNullChar(get());
    cursor = WriteScalar<uint32_t>(cursor, lengthWithNullChar);
    cursor = WriteBytes(cursor, get(), lengthWithNullChar);
    return cursor;
}

const uint8_t*
CacheableChars::deserialize(const uint8_t* cursor)
{
    uint32_t lengthWithNullChar;
    cursor = ReadBytes(cursor, &lengthWithNullChar, sizeof(uint32_t));

    if (lengthWithNullChar) {
        reset(js_pod_malloc<char>(lengthWithNullChar));
        if (!get())
            return nullptr;

        cursor = ReadBytes(cursor, get(), lengthWithNullChar);
    } else {
        MOZ_ASSERT(!get());
    }

    return cursor;
}

size_t
CacheableChars::sizeOfExcludingThis(MallocSizeOf mallocSizeOf) const
{
    return mallocSizeOf(get());
}

size_t
Metadata::serializedSize() const
{
    return sizeof(pod()) +
           SerializedVectorSize(funcImports) +
           SerializedVectorSize(funcExports) +
           SerializedVectorSize(sigIds) +
           SerializedPodVectorSize(globals) +
           SerializedPodVectorSize(tables) +
           SerializedPodVectorSize(memoryAccesses) +
           SerializedPodVectorSize(memoryPatches) +
           SerializedPodVectorSize(boundsChecks) +
           SerializedPodVectorSize(codeRanges) +
           SerializedPodVectorSize(callSites) +
           SerializedPodVectorSize(callThunks) +
           SerializedPodVectorSize(funcNames) +
           filename.serializedSize();
}

uint8_t*
Metadata::serialize(uint8_t* cursor) const
{
    cursor = WriteBytes(cursor, &pod(), sizeof(pod()));
    cursor = SerializeVector(cursor, funcImports);
    cursor = SerializeVector(cursor, funcExports);
    cursor = SerializeVector(cursor, sigIds);
    cursor = SerializePodVector(cursor, globals);
    cursor = SerializePodVector(cursor, tables);
    cursor = SerializePodVector(cursor, memoryAccesses);
    cursor = SerializePodVector(cursor, memoryPatches);
    cursor = SerializePodVector(cursor, boundsChecks);
    cursor = SerializePodVector(cursor, codeRanges);
    cursor = SerializePodVector(cursor, callSites);
    cursor = SerializePodVector(cursor, callThunks);
    cursor = SerializePodVector(cursor, funcNames);
    cursor = filename.serialize(cursor);
    return cursor;
}

/* static */ const uint8_t*
Metadata::deserialize(const uint8_t* cursor)
{
    (cursor = ReadBytes(cursor, &pod(), sizeof(pod()))) &&
    (cursor = DeserializeVector(cursor, &funcImports)) &&
    (cursor = DeserializeVector(cursor, &funcExports)) &&
    (cursor = DeserializeVector(cursor, &sigIds)) &&
    (cursor = DeserializePodVector(cursor, &globals)) &&
    (cursor = DeserializePodVector(cursor, &tables)) &&
    (cursor = DeserializePodVector(cursor, &memoryAccesses)) &&
    (cursor = DeserializePodVector(cursor, &memoryPatches)) &&
    (cursor = DeserializePodVector(cursor, &boundsChecks)) &&
    (cursor = DeserializePodVector(cursor, &codeRanges)) &&
    (cursor = DeserializePodVector(cursor, &callSites)) &&
    (cursor = DeserializePodVector(cursor, &callThunks)) &&
    (cursor = DeserializePodVector(cursor, &funcNames)) &&
    (cursor = filename.deserialize(cursor));
    return cursor;
}

size_t
Metadata::sizeOfExcludingThis(MallocSizeOf mallocSizeOf) const
{
    return SizeOfVectorExcludingThis(funcImports, mallocSizeOf) +
           SizeOfVectorExcludingThis(funcExports, mallocSizeOf) +
           SizeOfVectorExcludingThis(sigIds, mallocSizeOf) +
           globals.sizeOfExcludingThis(mallocSizeOf) +
           tables.sizeOfExcludingThis(mallocSizeOf) +
           memoryAccesses.sizeOfExcludingThis(mallocSizeOf) +
           memoryPatches.sizeOfExcludingThis(mallocSizeOf) +
           boundsChecks.sizeOfExcludingThis(mallocSizeOf) +
           codeRanges.sizeOfExcludingThis(mallocSizeOf) +
           callSites.sizeOfExcludingThis(mallocSizeOf) +
           callThunks.sizeOfExcludingThis(mallocSizeOf) +
           funcNames.sizeOfExcludingThis(mallocSizeOf) +
           filename.sizeOfExcludingThis(mallocSizeOf);
}

struct ProjectFuncIndex
{
    const FuncExportVector& funcExports;

    explicit ProjectFuncIndex(const FuncExportVector& funcExports)
      : funcExports(funcExports)
    {}
    uint32_t operator[](size_t index) const {
        return funcExports[index].funcIndex();
    }
};

const FuncExport&
Metadata::lookupFuncExport(uint32_t funcIndex) const
{
    size_t match;
    if (!BinarySearch(ProjectFuncIndex(funcExports), 0, funcExports.length(), funcIndex, &match))
        MOZ_CRASH("missing function export");

    return funcExports[match];
}

bool
Metadata::getFuncName(JSContext* cx, const Bytes* maybeBytecode, uint32_t funcIndex,
                      TwoByteName* name) const
{
    if (funcIndex < funcNames.length()) {
        MOZ_ASSERT(maybeBytecode, "NameInBytecode requires preserved bytecode");

        const NameInBytecode& n = funcNames[funcIndex];
        MOZ_ASSERT(n.offset + n.length < maybeBytecode->length());

        if (n.length == 0)
            goto invalid;

        UTF8Chars utf8((const char*)maybeBytecode->begin() + n.offset, n.length);

        // This code could be optimized by having JS::UTF8CharsToNewTwoByteCharsZ
        // return a Vector directly.
        size_t twoByteLength;
        UniqueTwoByteChars chars(JS::UTF8CharsToNewTwoByteCharsZ(cx, utf8, &twoByteLength).get());
        if (!chars)
            goto invalid;

        if (!name->growByUninitialized(twoByteLength))
            return false;

        PodCopy(name->begin(), chars.get(), twoByteLength);
        return true;
    }

  invalid:

    // For names that are out of range or invalid, synthesize a name.

    UniqueChars chars(JS_smprintf("wasm-function[%u]", funcIndex));
    if (!chars) {
        ReportOutOfMemory(cx);
        return false;
    }

    if (!name->growByUninitialized(strlen(chars.get())))
        return false;

    CopyAndInflateChars(name->begin(), chars.get(), name->length());
    return true;
}

Code::Code(UniqueCodeSegment segment,
           const Metadata& metadata,
           const ShareableBytes* maybeBytecode)
  : segment_(Move(segment)),
    metadata_(&metadata),
    maybeBytecode_(maybeBytecode),
    profilingEnabled_(false)
{}

struct CallSiteRetAddrOffset
{
    const CallSiteVector& callSites;
    explicit CallSiteRetAddrOffset(const CallSiteVector& callSites) : callSites(callSites) {}
    uint32_t operator[](size_t index) const {
        return callSites[index].returnAddressOffset();
    }
};

const CallSite*
Code::lookupCallSite(void* returnAddress) const
{
    uint32_t target = ((uint8_t*)returnAddress) - segment_->base();
    size_t lowerBound = 0;
    size_t upperBound = metadata_->callSites.length();

    size_t match;
    if (!BinarySearch(CallSiteRetAddrOffset(metadata_->callSites), lowerBound, upperBound, target, &match))
        return nullptr;

    return &metadata_->callSites[match];
}

const CodeRange*
Code::lookupRange(void* pc) const
{
    CodeRange::PC target((uint8_t*)pc - segment_->base());
    size_t lowerBound = 0;
    size_t upperBound = metadata_->codeRanges.length();

    size_t match;
    if (!BinarySearch(metadata_->codeRanges, lowerBound, upperBound, target, &match))
        return nullptr;

    return &metadata_->codeRanges[match];
}

struct MemoryAccessOffset
{
    const MemoryAccessVector& accesses;
    explicit MemoryAccessOffset(const MemoryAccessVector& accesses) : accesses(accesses) {}
    uintptr_t operator[](size_t index) const {
        return accesses[index].insnOffset();
    }
};

const MemoryAccess*
Code::lookupMemoryAccess(void* pc) const
{
    MOZ_ASSERT(segment_->containsFunctionPC(pc));

    uint32_t target = ((uint8_t*)pc) - segment_->base();
    size_t lowerBound = 0;
    size_t upperBound = metadata_->memoryAccesses.length();

    size_t match;
    if (!BinarySearch(MemoryAccessOffset(metadata_->memoryAccesses), lowerBound, upperBound, target, &match))
        return nullptr;

    return &metadata_->memoryAccesses[match];
}

bool
Code::getFuncName(JSContext* cx, uint32_t funcIndex, TwoByteName* name) const
{
    const Bytes* maybeBytecode = maybeBytecode_ ? &maybeBytecode_.get()->bytes : nullptr;
    return metadata_->getFuncName(cx, maybeBytecode, funcIndex, name);
}

JSAtom*
Code::getFuncAtom(JSContext* cx, uint32_t funcIndex) const
{
    TwoByteName name(cx);
    if (!getFuncName(cx, funcIndex, &name))
        return nullptr;

    return AtomizeChars(cx, name.begin(), name.length());
}

const char experimentalWarning[] =
    ".--.      .--.   ____       .-'''-. ,---.    ,---.\n"
    "|  |_     |  | .'  __ `.   / _     \\|    \\  /    |\n"
    "| _( )_   |  |/   '  \\  \\ (`' )/`--'|  ,  \\/  ,  |\n"
    "|(_ o _)  |  ||___|  /  |(_ o _).   |  |\\_   /|  |\n"
    "| (_,_) \\ |  |   _.-`   | (_,_). '. |  _( )_/ |  |\n"
    "|  |/    \\|  |.'   _    |.---.  \\  :| (_ o _) |  |\n"
    "|  '  /\\  `  ||  _( )_  |\\    `-'  ||  (_,_)  |  |\n"
    "|    /  \\    |\\ (_ o _) / \\       / |  |      |  |\n"
    "`---'    `---` '.(_,_).'   `-...-'  '--'      '--'\n"
    "WebAssembly text support and debugging is not supported in this version. You can download\n"
    "and use the following versions which have experimental debugger support:\n"
    "- Firefox Developer Edition: https://www.mozilla.org/en-US/firefox/developer/\n"
    "- Firefox Nightly: https://www.mozilla.org/en-US/firefox/nightly"
    ;

const size_t experimentalWarningLinesCount = 13;

struct LineComparator
{
    const uint32_t lineno;
    explicit LineComparator(uint32_t lineno) : lineno(lineno) {}

    int operator()(const ExprLoc& loc) const {
        return lineno == loc.lineno ? 0 : lineno < loc.lineno ? -1 : 1;
    }
};

JSString*
Code::createText(JSContext* cx)
{
    StringBuffer buffer(cx);
    if (!buffer.append(experimentalWarning))
        return nullptr;
    return buffer.finishString();
}

bool
Code::getLineOffsets(size_t lineno, Vector<uint32_t>& offsets) const
{
    // TODO Ensure text was generated?
    if (!maybeSourceMap_)
        return false;

    if (lineno < experimentalWarningLinesCount)
        return true;

    lineno -= experimentalWarningLinesCount;

    ExprLocVector& exprlocs = maybeSourceMap_->exprlocs();

    // Binary search for the expression with the specified line number and
    // rewind to the first expression, if more than one expression on the same line.
    size_t match;
    if (!BinarySearchIf(exprlocs, 0, exprlocs.length(), LineComparator(lineno), &match))
        return true;

    while (match > 0 && exprlocs[match - 1].lineno == lineno)
        match--;

    // Return all expression offsets that were printed on the specified line.
    for (size_t i = match; i < exprlocs.length() && exprlocs[i].lineno == lineno; i++) {
        if (!offsets.append(exprlocs[i].offset))
            return false;
    }

    return true;
}

bool
Code::ensureProfilingState(JSContext* cx, bool newProfilingEnabled)
{
    if (profilingEnabled_ == newProfilingEnabled)
        return true;

    // When enabled, generate profiling labels for every name in funcNames_
    // that is the name of some Function CodeRange. This involves malloc() so
    // do it now since, once we start sampling, we'll be in a signal-handing
    // context where we cannot malloc.
    if (newProfilingEnabled) {
        for (const CodeRange& codeRange : metadata_->codeRanges) {
            if (!codeRange.isFunction())
                continue;

            TwoByteName name(cx);
            if (!getFuncName(cx, codeRange.funcIndex(), &name))
                return false;
            if (!name.append('\0'))
                return false;

            TwoByteChars chars(name.begin(), name.length());
            UniqueChars utf8Name(JS::CharsToNewUTF8CharsZ(nullptr, chars).c_str());
            UniqueChars label(JS_smprintf("%s (%s:%u)",
                                          utf8Name.get(),
                                          metadata_->filename.get(),
                                          codeRange.funcLineOrBytecode()));
            if (!label) {
                ReportOutOfMemory(cx);
                return false;
            }

            if (codeRange.funcIndex() >= funcLabels_.length()) {
                if (!funcLabels_.resize(codeRange.funcIndex() + 1))
                    return false;
            }
            funcLabels_[codeRange.funcIndex()] = Move(label);
        }
    } else {
        funcLabels_.clear();
    }

    // Only mutate the code after the fallible operations are complete to avoid
    // the need to rollback.
    profilingEnabled_ = newProfilingEnabled;

    {
        AutoWritableJitCode awjc(cx->runtime(), segment_->base(), segment_->codeLength());
        AutoFlushICache afc("Code::ensureProfilingState");
        AutoFlushICache::setRange(uintptr_t(segment_->base()), segment_->codeLength());

        for (const CallSite& callSite : metadata_->callSites)
            ToggleProfiling(*this, callSite, newProfilingEnabled);
        for (const CallThunk& callThunk : metadata_->callThunks)
            ToggleProfiling(*this, callThunk, newProfilingEnabled);
        for (const CodeRange& codeRange : metadata_->codeRanges)
            ToggleProfiling(*this, codeRange, newProfilingEnabled);
    }

    return true;
}

void
Code::addSizeOfMisc(MallocSizeOf mallocSizeOf,
                    Metadata::SeenSet* seenMetadata,
                    ShareableBytes::SeenSet* seenBytes,
                    size_t* code,
                    size_t* data) const
{
    *code += segment_->codeLength();
    *data += mallocSizeOf(this) +
             segment_->globalDataLength() +
             metadata_->sizeOfIncludingThisIfNotSeen(mallocSizeOf, seenMetadata);

    if (maybeBytecode_)
        *data += maybeBytecode_->sizeOfIncludingThisIfNotSeen(mallocSizeOf, seenBytes);
}
