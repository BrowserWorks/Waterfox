/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef jit_shared_Assembler_shared_h
#define jit_shared_Assembler_shared_h

#include "mozilla/PodOperations.h"

#include <limits.h>

#include "jit/AtomicOp.h"
#include "jit/JitAllocPolicy.h"
#include "jit/Label.h"
#include "jit/Registers.h"
#include "jit/RegisterSets.h"
#include "vm/HelperThreads.h"
#include "wasm/WasmTypes.h"

#if defined(JS_CODEGEN_ARM) || defined(JS_CODEGEN_ARM64) || \
    defined(JS_CODEGEN_MIPS32) || defined(JS_CODEGEN_MIPS64)
// Push return addresses callee-side.
# define JS_USE_LINK_REGISTER
#endif

#if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_ARM) || defined(JS_CODEGEN_ARM64)
// JS_SMALL_BRANCH means the range on a branch instruction
// is smaller than the whole address space
# define JS_SMALL_BRANCH
#endif

namespace js {
namespace jit {

namespace Disassembler {
class HeapAccess;
} // namespace Disassembler

static const uint32_t Simd128DataSize = 4 * sizeof(int32_t);
static_assert(Simd128DataSize == 4 * sizeof(int32_t), "SIMD data should be able to contain int32x4");
static_assert(Simd128DataSize == 4 * sizeof(float), "SIMD data should be able to contain float32x4");
static_assert(Simd128DataSize == 2 * sizeof(double), "SIMD data should be able to contain float64x2");

enum Scale {
    TimesOne = 0,
    TimesTwo = 1,
    TimesFour = 2,
    TimesEight = 3
};

static_assert(sizeof(JS::Value) == 8,
              "required for TimesEight and 3 below to be correct");
static const Scale ValueScale = TimesEight;
static const size_t ValueShift = 3;

static inline unsigned
ScaleToShift(Scale scale)
{
    return unsigned(scale);
}

static inline bool
IsShiftInScaleRange(int i)
{
    return i >= TimesOne && i <= TimesEight;
}

static inline Scale
ShiftToScale(int i)
{
    MOZ_ASSERT(IsShiftInScaleRange(i));
    return Scale(i);
}

static inline Scale
ScaleFromElemWidth(int shift)
{
    switch (shift) {
      case 1:
        return TimesOne;
      case 2:
        return TimesTwo;
      case 4:
        return TimesFour;
      case 8:
        return TimesEight;
    }

    MOZ_CRASH("Invalid scale");
}

// Used for 32-bit immediates which do not require relocation.
struct Imm32
{
    int32_t value;

    explicit Imm32(int32_t value) : value(value)
    { }

    static inline Imm32 ShiftOf(enum Scale s) {
        switch (s) {
          case TimesOne:
            return Imm32(0);
          case TimesTwo:
            return Imm32(1);
          case TimesFour:
            return Imm32(2);
          case TimesEight:
            return Imm32(3);
        };
        MOZ_CRASH("Invalid scale");
    }

    static inline Imm32 FactorOf(enum Scale s) {
        return Imm32(1 << ShiftOf(s).value);
    }
};

// Pointer-sized integer to be embedded as an immediate in an instruction.
struct ImmWord
{
    uintptr_t value;

    explicit ImmWord(uintptr_t value) : value(value)
    { }
};

// Used for 64-bit immediates which do not require relocation.
struct Imm64
{
    uint64_t value;

    explicit Imm64(int64_t value) : value(value)
    { }

    Imm32 low() const {
        return Imm32(int32_t(value));
    }

    Imm32 hi() const {
        return Imm32(int32_t(value >> 32));
    }

    inline Imm32 firstHalf() const;
    inline Imm32 secondHalf() const;
};

#ifdef DEBUG
static inline bool
IsCompilingWasm()
{
    // wasm compilation pushes a JitContext with a null JSCompartment.
    return GetJitContext()->compartment == nullptr;
}
#endif

// Pointer to be embedded as an immediate in an instruction.
struct ImmPtr
{
    void* value;

    explicit ImmPtr(const void* value) : value(const_cast<void*>(value))
    {
        // To make code serialization-safe, wasm compilation should only
        // compile pointer immediates using a SymbolicAddress.
        MOZ_ASSERT(!IsCompilingWasm());
    }

    template <class R>
    explicit ImmPtr(R (*pf)())
      : value(JS_FUNC_TO_DATA_PTR(void*, pf))
    {
        MOZ_ASSERT(!IsCompilingWasm());
    }

    template <class R, class A1>
    explicit ImmPtr(R (*pf)(A1))
      : value(JS_FUNC_TO_DATA_PTR(void*, pf))
    {
        MOZ_ASSERT(!IsCompilingWasm());
    }

    template <class R, class A1, class A2>
    explicit ImmPtr(R (*pf)(A1, A2))
      : value(JS_FUNC_TO_DATA_PTR(void*, pf))
    {
        MOZ_ASSERT(!IsCompilingWasm());
    }

    template <class R, class A1, class A2, class A3>
    explicit ImmPtr(R (*pf)(A1, A2, A3))
      : value(JS_FUNC_TO_DATA_PTR(void*, pf))
    {
        MOZ_ASSERT(!IsCompilingWasm());
    }

    template <class R, class A1, class A2, class A3, class A4>
    explicit ImmPtr(R (*pf)(A1, A2, A3, A4))
      : value(JS_FUNC_TO_DATA_PTR(void*, pf))
    {
        MOZ_ASSERT(!IsCompilingWasm());
    }

};

// The same as ImmPtr except that the intention is to patch this
// instruction. The initial value of the immediate is 'addr' and this value is
// either clobbered or used in the patching process.
struct PatchedImmPtr {
    void* value;

    explicit PatchedImmPtr()
      : value(nullptr)
    { }
    explicit PatchedImmPtr(const void* value)
      : value(const_cast<void*>(value))
    { }
};

class AssemblerShared;
class ImmGCPtr;

// Used for immediates which require relocation.
class ImmGCPtr
{
  public:
    const gc::Cell* value;

    explicit ImmGCPtr(const gc::Cell* ptr) : value(ptr)
    {
        // Nursery pointers can't be used if the main thread might be currently
        // performing a minor GC.
        MOZ_ASSERT_IF(ptr && !ptr->isTenured(),
                      !CurrentThreadIsIonCompilingSafeForMinorGC());

        // wasm shouldn't be creating GC things
        MOZ_ASSERT(!IsCompilingWasm());
    }

  private:
    ImmGCPtr() : value(0) {}
};

// Pointer to be embedded as an immediate that is loaded/stored from by an
// instruction.
struct AbsoluteAddress
{
    void* addr;

    explicit AbsoluteAddress(const void* addr)
      : addr(const_cast<void*>(addr))
    {
        MOZ_ASSERT(!IsCompilingWasm());
    }

    AbsoluteAddress offset(ptrdiff_t delta) {
        return AbsoluteAddress(((uint8_t*) addr) + delta);
    }
};

// The same as AbsoluteAddress except that the intention is to patch this
// instruction. The initial value of the immediate is 'addr' and this value is
// either clobbered or used in the patching process.
struct PatchedAbsoluteAddress
{
    void* addr;

    explicit PatchedAbsoluteAddress()
      : addr(nullptr)
    { }
    explicit PatchedAbsoluteAddress(const void* addr)
      : addr(const_cast<void*>(addr))
    { }
    explicit PatchedAbsoluteAddress(uintptr_t addr)
      : addr(reinterpret_cast<void*>(addr))
    { }
};

// Specifies an address computed in the form of a register base and a constant,
// 32-bit offset.
struct Address
{
    Register base;
    int32_t offset;

    Address(Register base, int32_t offset) : base(base), offset(offset)
    { }

    Address() { mozilla::PodZero(this); }
};

// Specifies an address computed in the form of a register base, a register
// index with a scale, and a constant, 32-bit offset.
struct BaseIndex
{
    Register base;
    Register index;
    Scale scale;
    int32_t offset;

    BaseIndex(Register base, Register index, Scale scale, int32_t offset = 0)
      : base(base), index(index), scale(scale), offset(offset)
    { }

    BaseIndex() { mozilla::PodZero(this); }
};

// A BaseIndex used to access Values.  Note that |offset| is *not* scaled by
// sizeof(Value).  Use this *only* if you're indexing into a series of Values
// that aren't object elements or object slots (for example, values on the
// stack, values in an arguments object, &c.).  If you're indexing into an
// object's elements or slots, don't use this directly!  Use
// BaseObject{Element,Slot}Index instead.
struct BaseValueIndex : BaseIndex
{
    BaseValueIndex(Register base, Register index, int32_t offset = 0)
      : BaseIndex(base, index, ValueScale, offset)
    { }
};

// Specifies the address of an indexed Value within object elements from a
// base.  The index must not already be scaled by sizeof(Value)!
struct BaseObjectElementIndex : BaseValueIndex
{
    BaseObjectElementIndex(Register base, Register index, int32_t offset = 0)
      : BaseValueIndex(base, index, offset)
    {
        NativeObject::elementsSizeMustNotOverflow();
    }
};

// Like BaseObjectElementIndex, except for object slots.
struct BaseObjectSlotIndex : BaseValueIndex
{
    BaseObjectSlotIndex(Register base, Register index)
      : BaseValueIndex(base, index)
    {
        NativeObject::slotsSizeMustNotOverflow();
    }
};

class Relocation {
  public:
    enum Kind {
        // The target is immovable, so patching is only needed if the source
        // buffer is relocated and the reference is relative.
        HARDCODED,

        // The target is the start of a JitCode buffer, which must be traced
        // during garbage collection. Relocations and patching may be needed.
        JITCODE
    };
};

class RepatchLabel
{
    static const int32_t INVALID_OFFSET = 0xC0000000;
    int32_t offset_ : 31;
    uint32_t bound_ : 1;
  public:

    RepatchLabel() : offset_(INVALID_OFFSET), bound_(0) {}

    void use(uint32_t newOffset) {
        MOZ_ASSERT(offset_ == INVALID_OFFSET);
        MOZ_ASSERT(newOffset != (uint32_t)INVALID_OFFSET);
        offset_ = newOffset;
    }
    bool bound() const {
        return bound_;
    }
    void bind(int32_t dest) {
        MOZ_ASSERT(!bound_);
        MOZ_ASSERT(dest != INVALID_OFFSET);
        offset_ = dest;
        bound_ = true;
    }
    int32_t target() {
        MOZ_ASSERT(bound());
        int32_t ret = offset_;
        offset_ = INVALID_OFFSET;
        return ret;
    }
    int32_t offset() {
        MOZ_ASSERT(!bound());
        return offset_;
    }
    bool used() const {
        return !bound() && offset_ != (INVALID_OFFSET);
    }

};
// An absolute label is like a Label, except it represents an absolute
// reference rather than a relative one. Thus, it cannot be patched until after
// linking.
struct AbsoluteLabel : public LabelBase
{
  public:
    AbsoluteLabel()
    { }
    AbsoluteLabel(const AbsoluteLabel& label) : LabelBase(label)
    { }
    int32_t prev() const {
        MOZ_ASSERT(!bound());
        if (!used())
            return INVALID_OFFSET;
        return offset();
    }
    void setPrev(int32_t offset) {
        use(offset);
    }
    void bind() {
        bound_ = true;

        // These labels cannot be used after being bound.
        offset_ = -1;
    }
};

class CodeOffset
{
    size_t offset_;

    static const size_t NOT_BOUND = size_t(-1);

  public:
    explicit CodeOffset(size_t offset) : offset_(offset) {}
    CodeOffset() : offset_(NOT_BOUND) {}

    size_t offset() const {
        MOZ_ASSERT(bound());
        return offset_;
    }

    void bind(size_t offset) {
        MOZ_ASSERT(!bound());
        offset_ = offset;
        MOZ_ASSERT(bound());
    }
    bool bound() const {
        return offset_ != NOT_BOUND;
    }

    void offsetBy(size_t delta) {
        MOZ_ASSERT(bound());
        MOZ_ASSERT(offset_ + delta >= offset_, "no overflow");
        offset_ += delta;
    }
};

// A code label contains an absolute reference to a point in the code. Thus, it
// cannot be patched until after linking.
// When the source label is resolved into a memory address, this address is
// patched into the destination address.
class CodeLabel
{
    // The destination position, where the absolute reference should get
    // patched into.
    CodeOffset patchAt_;

    // The source label (relative) in the code to where the destination should
    // get patched to.
    CodeOffset target_;

  public:
    CodeLabel()
    { }
    explicit CodeLabel(const CodeOffset& patchAt)
      : patchAt_(patchAt)
    { }
    CodeLabel(const CodeOffset& patchAt, const CodeOffset& target)
      : patchAt_(patchAt),
        target_(target)
    { }
    CodeOffset* patchAt() {
        return &patchAt_;
    }
    CodeOffset* target() {
        return &target_;
    }
    void offsetBy(size_t delta) {
        patchAt_.offsetBy(delta);
        target_.offsetBy(delta);
    }
};

// Location of a jump or label in a generated JitCode block, relative to the
// start of the block.

class CodeOffsetJump
{
    size_t offset_;

#ifdef JS_SMALL_BRANCH
    size_t jumpTableIndex_;
#endif

  public:

#ifdef JS_SMALL_BRANCH
    CodeOffsetJump(size_t offset, size_t jumpTableIndex)
        : offset_(offset), jumpTableIndex_(jumpTableIndex)
    {}
    size_t jumpTableIndex() const {
        return jumpTableIndex_;
    }
#else
    explicit CodeOffsetJump(size_t offset) : offset_(offset) {}
#endif

    CodeOffsetJump() {
        mozilla::PodZero(this);
    }

    size_t offset() const {
        return offset_;
    }
    void fixup(MacroAssembler* masm);
};

// Absolute location of a jump or a label in some generated JitCode block.
// Can also encode a CodeOffset{Jump,Label}, such that the offset is initially
// set and the absolute location later filled in after the final JitCode is
// allocated.

class CodeLocationJump
{
    uint8_t* raw_;
#ifdef DEBUG
    enum State { Uninitialized, Absolute, Relative };
    State state_;
    void setUninitialized() {
        state_ = Uninitialized;
    }
    void setAbsolute() {
        state_ = Absolute;
    }
    void setRelative() {
        state_ = Relative;
    }
#else
    void setUninitialized() const {
    }
    void setAbsolute() const {
    }
    void setRelative() const {
    }
#endif

#ifdef JS_SMALL_BRANCH
    uint8_t* jumpTableEntry_;
#endif

  public:
    CodeLocationJump() {
        raw_ = nullptr;
        setUninitialized();
#ifdef JS_SMALL_BRANCH
        jumpTableEntry_ = (uint8_t*) uintptr_t(0xdeadab1e);
#endif
    }
    CodeLocationJump(JitCode* code, CodeOffsetJump base) {
        *this = base;
        repoint(code);
    }

    void operator = (CodeOffsetJump base) {
        raw_ = (uint8_t*) base.offset();
        setRelative();
#ifdef JS_SMALL_BRANCH
        jumpTableEntry_ = (uint8_t*) base.jumpTableIndex();
#endif
    }

    void repoint(JitCode* code, MacroAssembler* masm = nullptr);

    uint8_t* raw() const {
        MOZ_ASSERT(state_ == Absolute);
        return raw_;
    }
    uint8_t* offset() const {
        MOZ_ASSERT(state_ == Relative);
        return raw_;
    }

#ifdef JS_SMALL_BRANCH
    uint8_t* jumpTableEntry() const {
        MOZ_ASSERT(state_ == Absolute);
        return jumpTableEntry_;
    }
#endif
};

class CodeLocationLabel
{
    uint8_t* raw_;
#ifdef DEBUG
    enum State { Uninitialized, Absolute, Relative };
    State state_;
    void setUninitialized() {
        state_ = Uninitialized;
    }
    void setAbsolute() {
        state_ = Absolute;
    }
    void setRelative() {
        state_ = Relative;
    }
#else
    void setUninitialized() const {
    }
    void setAbsolute() const {
    }
    void setRelative() const {
    }
#endif

  public:
    CodeLocationLabel() {
        raw_ = nullptr;
        setUninitialized();
    }
    CodeLocationLabel(JitCode* code, CodeOffset base) {
        *this = base;
        repoint(code);
    }
    explicit CodeLocationLabel(JitCode* code) {
        raw_ = code->raw();
        setAbsolute();
    }
    explicit CodeLocationLabel(uint8_t* raw) {
        raw_ = raw;
        setAbsolute();
    }

    void operator = (CodeOffset base) {
        raw_ = (uint8_t*)base.offset();
        setRelative();
    }
    ptrdiff_t operator - (const CodeLocationLabel& other) {
        return raw_ - other.raw_;
    }

    void repoint(JitCode* code, MacroAssembler* masm = nullptr);

#ifdef DEBUG
    bool isSet() const {
        return state_ != Uninitialized;
    }
#endif

    uint8_t* raw() const {
        MOZ_ASSERT(state_ == Absolute);
        return raw_;
    }
    uint8_t* offset() const {
        MOZ_ASSERT(state_ == Relative);
        return raw_;
    }
};

} // namespace jit

namespace wasm {

// As an invariant across architectures, within wasm code:
//   $sp % WasmStackAlignment = (sizeof(wasm::Frame) + masm.framePushed) % WasmStackAlignment
// Thus, wasm::Frame represents the bytes pushed after the call (which occurred
// with a WasmStackAlignment-aligned StackPointer) that are not included in
// masm.framePushed.

struct Frame
{
    // The caller's saved frame pointer. In non-profiling mode, internal
    // wasm-to-wasm calls don't update fp and thus don't save the caller's
    // frame pointer; the space is reserved, however, so that profiling mode can
    // reuse the same function body without recompiling.
    uint8_t* callerFP;

    // The return address pushed by the call (in the case of ARM/MIPS the return
    // address is pushed by the first instruction of the prologue).
    void* returnAddress;
};

static_assert(sizeof(Frame) == 2 * sizeof(void*), "?!");
static const uint32_t FrameBytesAfterReturnAddress = sizeof(void*);

// Represents an instruction to be patched and the intended pointee. These
// links are accumulated in the MacroAssembler, but patching is done outside
// the MacroAssembler (in Module::staticallyLink).

struct SymbolicAccess
{
    SymbolicAccess(jit::CodeOffset patchAt, SymbolicAddress target)
      : patchAt(patchAt), target(target) {}

    jit::CodeOffset patchAt;
    SymbolicAddress target;
};

typedef Vector<SymbolicAccess, 0, SystemAllocPolicy> SymbolicAccessVector;

// Describes a single wasm or asm.js memory access for the purpose of generating
// code and metadata.

class MemoryAccessDesc
{
    uint32_t offset_;
    uint32_t align_;
    Scalar::Type type_;
    unsigned numSimdElems_;
    jit::MemoryBarrierBits barrierBefore_;
    jit::MemoryBarrierBits barrierAfter_;
    mozilla::Maybe<wasm::TrapOffset> trapOffset_;

  public:
    explicit MemoryAccessDesc(Scalar::Type type, uint32_t align, uint32_t offset,
                              mozilla::Maybe<TrapOffset> trapOffset,
                              unsigned numSimdElems = 0,
                              jit::MemoryBarrierBits barrierBefore = jit::MembarNobits,
                              jit::MemoryBarrierBits barrierAfter = jit::MembarNobits)
      : offset_(offset),
        align_(align),
        type_(type),
        numSimdElems_(numSimdElems),
        barrierBefore_(barrierBefore),
        barrierAfter_(barrierAfter),
        trapOffset_(trapOffset)
    {
        MOZ_ASSERT(Scalar::isSimdType(type) == (numSimdElems > 0));
        MOZ_ASSERT(numSimdElems <= jit::ScalarTypeToLength(type));
        MOZ_ASSERT(mozilla::IsPowerOfTwo(align));
        MOZ_ASSERT_IF(isSimd(), hasTrap());
        MOZ_ASSERT_IF(isAtomic(), hasTrap());
    }

    uint32_t offset() const { return offset_; }
    uint32_t align() const { return align_; }
    Scalar::Type type() const { return type_; }
    unsigned byteSize() const {
        return Scalar::isSimdType(type())
               ? Scalar::scalarByteSize(type()) * numSimdElems()
               : Scalar::byteSize(type());
    }
    unsigned numSimdElems() const { MOZ_ASSERT(isSimd()); return numSimdElems_; }
    jit::MemoryBarrierBits barrierBefore() const { return barrierBefore_; }
    jit::MemoryBarrierBits barrierAfter() const { return barrierAfter_; }
    bool hasTrap() const { return !!trapOffset_; }
    TrapOffset trapOffset() const { return *trapOffset_; }
    bool isAtomic() const { return (barrierBefore_ | barrierAfter_) != jit::MembarNobits; }
    bool isSimd() const { return Scalar::isSimdType(type_); }
    bool isUnaligned() const { return align() && align() < byteSize(); }
    bool isPlainAsmJS() const { return !hasTrap(); }

    void clearOffset() { offset_ = 0; }
};

// Summarizes a global access for a mutable (in asm.js) or immutable value (in
// asm.js or the wasm MVP) that needs to get patched later.

struct GlobalAccess
{
    GlobalAccess(jit::CodeOffset patchAt, unsigned globalDataOffset)
      : patchAt(patchAt), globalDataOffset(globalDataOffset)
    {}

    jit::CodeOffset patchAt;
    unsigned globalDataOffset;
};

typedef Vector<GlobalAccess, 0, SystemAllocPolicy> GlobalAccessVector;

// The TrapDesc struct describes a wasm trap that is about to be emitted. This
// includes the logical wasm bytecode offset to report, the kind of instruction
// causing the trap, and the stack depth right before control is transferred to
// the trap out-of-line path.

struct TrapDesc : TrapOffset
{
    enum Kind { Jump, MemoryAccess };
    Kind kind;
    Trap trap;
    uint32_t framePushed;

    TrapDesc(TrapOffset offset, Trap trap, uint32_t framePushed, Kind kind = Jump)
      : TrapOffset(offset), kind(kind), trap(trap), framePushed(framePushed)
    {}
};

// A TrapSite captures all relevant information at the point of emitting the
// in-line trapping instruction for the purpose of generating the out-of-line
// trap code (at the end of the function).

struct TrapSite : TrapDesc
{
    uint32_t codeOffset;

    TrapSite(TrapDesc trap, uint32_t codeOffset)
      : TrapDesc(trap), codeOffset(codeOffset)
    {}
};

typedef Vector<TrapSite, 0, SystemAllocPolicy> TrapSiteVector;

// A TrapFarJump records the offset of a jump that needs to be patched to a trap
// exit at the end of the module when trap exits are emitted.

struct TrapFarJump
{
    Trap trap;
    jit::CodeOffset jump;

    TrapFarJump(Trap trap, jit::CodeOffset jump)
      : trap(trap), jump(jump)
    {}

    void offsetBy(size_t delta) {
        jump.offsetBy(delta);
    }
};

typedef Vector<TrapFarJump, 0, SystemAllocPolicy> TrapFarJumpVector;

} // namespace wasm

namespace jit {

// The base class of all Assemblers for all archs.
class AssemblerShared
{
    wasm::CallSiteAndTargetVector callSites_;
    wasm::TrapSiteVector trapSites_;
    wasm::TrapFarJumpVector trapFarJumps_;
    wasm::MemoryAccessVector memoryAccesses_;
    wasm::MemoryPatchVector memoryPatches_;
    wasm::BoundsCheckVector boundsChecks_;
    wasm::GlobalAccessVector globalAccesses_;
    wasm::SymbolicAccessVector symbolicAccesses_;

  protected:
    Vector<CodeLabel, 0, SystemAllocPolicy> codeLabels_;

    bool enoughMemory_;
    bool embedsNurseryPointers_;

  public:
    AssemblerShared()
     : enoughMemory_(true),
       embedsNurseryPointers_(false)
    {}

    void propagateOOM(bool success) {
        enoughMemory_ &= success;
    }

    void setOOM() {
        enoughMemory_ = false;
    }

    bool oom() const {
        return !enoughMemory_;
    }

    bool embedsNurseryPointers() const {
        return embedsNurseryPointers_;
    }

    template <typename... Args>
    void append(const wasm::CallSiteDesc& desc, CodeOffset retAddr, size_t framePushed,
                Args&&... args)
    {
        // framePushed does not include sizeof(wasm:Frame), so add it in explicitly when
        // setting the CallSite::stackDepth.
        wasm::CallSite cs(desc, retAddr.offset(), framePushed + sizeof(wasm::Frame));
        enoughMemory_ &= callSites_.emplaceBack(cs, mozilla::Forward<Args>(args)...);
    }
    wasm::CallSiteAndTargetVector& callSites() { return callSites_; }

    void append(wasm::TrapSite trapSite) {
        enoughMemory_ &= trapSites_.append(trapSite);
    }
    const wasm::TrapSiteVector& trapSites() const { return trapSites_; }
    void clearTrapSites() { trapSites_.clear(); }

    void append(wasm::TrapFarJump jmp) {
        enoughMemory_ &= trapFarJumps_.append(jmp);
    }
    const wasm::TrapFarJumpVector& trapFarJumps() const { return trapFarJumps_; }

    void append(wasm::MemoryAccess access) { enoughMemory_ &= memoryAccesses_.append(access); }
    wasm::MemoryAccessVector&& extractMemoryAccesses() { return Move(memoryAccesses_); }

    void append(const wasm::MemoryAccessDesc& access, size_t codeOffset, size_t framePushed) {
        if (access.hasTrap()) {
            // If a memory access is trapping (wasm, SIMD.js, Atomics), create a
            // TrapSite now which will generate a trap out-of-line path at the end
            // of the function which will *then* append a MemoryAccess.
            wasm::TrapDesc trap(access.trapOffset(), wasm::Trap::OutOfBounds, framePushed,
                                wasm::TrapSite::MemoryAccess);
            append(wasm::TrapSite(trap, codeOffset));
        } else {
            // Otherwise, this is a plain asm.js access. On WASM_HUGE_MEMORY
            // platforms, asm.js uses signal handlers to remove bounds checks
            // and thus requires a MemoryAccess.
            MOZ_ASSERT(access.isPlainAsmJS());
#ifdef WASM_HUGE_MEMORY
            append(wasm::MemoryAccess(codeOffset));
#endif
        }
    }

    void append(wasm::MemoryPatch patch) { enoughMemory_ &= memoryPatches_.append(patch); }
    wasm::MemoryPatchVector&& extractMemoryPatches() { return Move(memoryPatches_); }

    void append(wasm::BoundsCheck check) { enoughMemory_ &= boundsChecks_.append(check); }
    wasm::BoundsCheckVector&& extractBoundsChecks() { return Move(boundsChecks_); }

    void append(wasm::GlobalAccess access) { enoughMemory_ &= globalAccesses_.append(access); }
    const wasm::GlobalAccessVector& globalAccesses() const { return globalAccesses_; }

    void append(wasm::SymbolicAccess access) { enoughMemory_ &= symbolicAccesses_.append(access); }
    size_t numSymbolicAccesses() const { return symbolicAccesses_.length(); }
    wasm::SymbolicAccess symbolicAccess(size_t i) const { return symbolicAccesses_[i]; }

    static bool canUseInSingleByteInstruction(Register reg) { return true; }

    void addCodeLabel(CodeLabel label) {
        propagateOOM(codeLabels_.append(label));
    }
    size_t numCodeLabels() const {
        return codeLabels_.length();
    }
    CodeLabel codeLabel(size_t i) {
        return codeLabels_[i];
    }

    // Merge this assembler with the other one, invalidating it, by shifting all
    // offsets by a delta.
    bool asmMergeWith(size_t delta, const AssemblerShared& other) {
        size_t i = callSites_.length();
        enoughMemory_ &= callSites_.appendAll(other.callSites_);
        for (; i < callSites_.length(); i++)
            callSites_[i].offsetReturnAddressBy(delta);

        MOZ_ASSERT(other.trapSites_.empty(), "should have been cleared by wasmEmitTrapOutOfLineCode");

        i = trapFarJumps_.length();
        enoughMemory_ &= trapFarJumps_.appendAll(other.trapFarJumps_);
        for (; i < trapFarJumps_.length(); i++)
            trapFarJumps_[i].offsetBy(delta);

        i = memoryAccesses_.length();
        enoughMemory_ &= memoryAccesses_.appendAll(other.memoryAccesses_);
        for (; i < memoryAccesses_.length(); i++)
            memoryAccesses_[i].offsetBy(delta);

        i = memoryPatches_.length();
        enoughMemory_ &= memoryPatches_.appendAll(other.memoryPatches_);
        for (; i < memoryPatches_.length(); i++)
            memoryPatches_[i].offsetBy(delta);

        i = boundsChecks_.length();
        enoughMemory_ &= boundsChecks_.appendAll(other.boundsChecks_);
        for (; i < boundsChecks_.length(); i++)
            boundsChecks_[i].offsetBy(delta);

        i = globalAccesses_.length();
        enoughMemory_ &= globalAccesses_.appendAll(other.globalAccesses_);
        for (; i < globalAccesses_.length(); i++)
            globalAccesses_[i].patchAt.offsetBy(delta);

        i = symbolicAccesses_.length();
        enoughMemory_ &= symbolicAccesses_.appendAll(other.symbolicAccesses_);
        for (; i < symbolicAccesses_.length(); i++)
            symbolicAccesses_[i].patchAt.offsetBy(delta);

        i = codeLabels_.length();
        enoughMemory_ &= codeLabels_.appendAll(other.codeLabels_);
        for (; i < codeLabels_.length(); i++)
            codeLabels_[i].offsetBy(delta);

        return !oom();
    }
};

} // namespace jit
} // namespace js

#endif /* jit_shared_Assembler_shared_h */
