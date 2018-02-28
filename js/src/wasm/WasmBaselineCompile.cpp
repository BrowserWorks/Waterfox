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

/* WebAssembly baseline compiler ("RabaldrMonkey")
 *
 * General status notes:
 *
 * "FIXME" indicates a known or suspected bug.  Always has a bug#.
 *
 * "TODO" indicates an opportunity for a general improvement, with an additional
 * tag to indicate the area of improvement.  Usually has a bug#.
 *
 * Unimplemented functionality:
 *
 *  - Tiered compilation (bug 1277562)
 *
 * There are lots of machine dependencies here but they are pretty well isolated
 * to a segment of the compiler.  Many dependencies will eventually be factored
 * into the MacroAssembler layer and shared with other code generators.
 *
 *
 * High-value compiler performance improvements:
 *
 * - (Bug 1316802) The specific-register allocator (the needI32(r), needI64(r)
 *   etc methods) can avoid syncing the value stack if the specific register is
 *   in use but there is a free register to shuffle the specific register into.
 *   (This will also improve the generated code.)  The sync happens often enough
 *   here to show up in profiles, because it is triggered by integer multiply
 *   and divide.
 *
 *
 * High-value code generation improvements:
 *
 * - (Bug 1316804) brTable pessimizes by always dispatching to code that pops
 *   the stack and then jumps to the code for the target case.  If no cleanup is
 *   needed we could just branch conditionally to the target; if the same amount
 *   of cleanup is needed for all cases then the cleanup can be done before the
 *   dispatch.  Both are highly likely.
 *
 * - (Bug 1316806) Register management around calls: At the moment we sync the
 *   value stack unconditionally (this is simple) but there are probably many
 *   common cases where we could instead save/restore live caller-saves
 *   registers and perform parallel assignment into argument registers.  This
 *   may be important if we keep some locals in registers.
 *
 * - (Bug 1316808) Allocate some locals to registers on machines where there are
 *   enough registers.  This is probably hard to do well in a one-pass compiler
 *   but it might be that just keeping register arguments and the first few
 *   locals in registers is a viable strategy; another (more general) strategy
 *   is caching locals in registers in straight-line code.  Such caching could
 *   also track constant values in registers, if that is deemed valuable.  A
 *   combination of techniques may be desirable: parameters and the first few
 *   locals could be cached on entry to the function but not statically assigned
 *   to registers throughout.
 *
 *   (On a large corpus of code it should be possible to compute, for every
 *   signature comprising the types of parameters and locals, and using a static
 *   weight for loops, a list in priority order of which parameters and locals
 *   that should be assigned to registers.  Or something like that.  Wasm makes
 *   this simple.  Static assignments are desirable because they are not flushed
 *   to memory by the pre-block sync() call.)
 */

#include "wasm/WasmBaselineCompile.h"

#include "mozilla/MathAlgorithms.h"

#include "jit/AtomicOp.h"
#include "jit/IonTypes.h"
#include "jit/JitAllocPolicy.h"
#include "jit/Label.h"
#include "jit/MacroAssembler.h"
#include "jit/MIR.h"
#include "jit/Registers.h"
#include "jit/RegisterSets.h"
#if defined(JS_CODEGEN_ARM)
# include "jit/arm/Assembler-arm.h"
#endif
#if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_X86)
# include "jit/x86-shared/Architecture-x86-shared.h"
# include "jit/x86-shared/Assembler-x86-shared.h"
#endif

#include "wasm/WasmBinaryIterator.h"
#include "wasm/WasmGenerator.h"
#include "wasm/WasmSignalHandlers.h"
#include "wasm/WasmValidate.h"

#include "jit/MacroAssembler-inl.h"

using mozilla::DebugOnly;
using mozilla::FloatingPoint;
using mozilla::FloorLog2;
using mozilla::IsPowerOfTwo;
using mozilla::SpecificNaN;

namespace js {
namespace wasm {

using namespace js::jit;
using JS::GenericNaN;

typedef bool HandleNaNSpecially;
typedef bool InvertBranch;
typedef bool IsKnownNotZero;
typedef bool IsSigned;
typedef bool IsUnsigned;
typedef bool NeedsBoundsCheck;
typedef bool PopStack;
typedef bool ZeroOnOverflow;

typedef unsigned ByteSize;
typedef unsigned BitSize;

// UseABI::Wasm implies that the Tls/Heap/Global registers are nonvolatile,
// except when InterModule::True is also set, when they are volatile.
//
// UseABI::System implies that the Tls/Heap/Global registers are volatile.
// Additionally, the parameter passing mechanism may be slightly different from
// the UseABI::Wasm convention.
//
// When the Tls/Heap/Global registers are not volatile, the baseline compiler
// will restore the Tls register from its save slot before the call, since the
// baseline compiler uses the Tls register for other things.
//
// When those registers are volatile, the baseline compiler will reload them
// after the call (it will restore the Tls register from the save slot and load
// the other two from the Tls data).

enum class UseABI { Wasm, System };
enum class InterModule { False = false, True = true };

#ifdef JS_CODEGEN_ARM64
// FIXME: This is not correct, indeed for ARM64 there is no reliable
// StackPointer and we'll need to change the abstractions that use
// SP-relative addressing.  There's a guard in emitFunction() below to
// prevent this workaround from having any consequence.  This hack
// exists only as a stopgap; there is no ARM64 JIT support yet.
static const Register StackPointer = RealStackPointer;
#endif

#ifdef JS_CODEGEN_X86
// The selection of EBX here steps gingerly around: the need for EDX
// to be allocatable for multiply/divide; ECX to be allocatable for
// shift/rotate; EAX (= ReturnReg) to be allocatable as the joinreg;
// EBX not being one of the WasmTableCall registers; and needing a
// temp register for load/store that has a single-byte persona.
static const Register ScratchRegX86 = ebx;

# define INT_DIV_I64_CALLOUT
#endif

#ifdef JS_CODEGEN_ARM
// We need a temp for funcPtrCall.  It can't be any of the
// WasmTableCall registers, an argument register, or a scratch
// register, and probably should not be ReturnReg.
static const Register FuncPtrCallTemp = CallTempReg1;

// We use our own scratch register, because the macro assembler uses
// the regular scratch register(s) pretty liberally.  We could
// work around that in several cases but the mess does not seem
// worth it yet.  CallTempReg2 seems safe.
static const Register ScratchRegARM = CallTempReg2;

# define INT_DIV_I64_CALLOUT
# define I64_TO_FLOAT_CALLOUT
# define FLOAT_TO_I64_CALLOUT
#endif

template<MIRType t>
struct RegTypeOf {
    static_assert(t == MIRType::Float32 || t == MIRType::Double, "Float mask type");
};

template<> struct RegTypeOf<MIRType::Float32> {
    static constexpr RegTypeName value = RegTypeName::Float32;
};
template<> struct RegTypeOf<MIRType::Double> {
    static constexpr RegTypeName value = RegTypeName::Float64;
};

BaseLocalIter::BaseLocalIter(const ValTypeVector& locals,
                             size_t argsLength,
                             bool debugEnabled)
  : locals_(locals),
    argsLength_(argsLength),
    argsRange_(locals.begin(), argsLength),
    argsIter_(argsRange_),
    index_(0),
    localSize_(debugEnabled ? DebugFrame::offsetOfFrame() : 0),
    reservedSize_(localSize_),
    done_(false)
{
    MOZ_ASSERT(argsLength <= locals.length());

    settle();
}

int32_t
BaseLocalIter::pushLocal(size_t nbytes)
{
    if (nbytes == 8)
        localSize_ = AlignBytes(localSize_, 8u);
    else if (nbytes == 16)
        localSize_ = AlignBytes(localSize_, 16u);
    localSize_ += nbytes;
    return localSize_;          // Locals grow down so capture base address
}

void
BaseLocalIter::settle()
{
    if (index_ < argsLength_) {
        MOZ_ASSERT(!argsIter_.done());
        mirType_ = argsIter_.mirType();
        switch (mirType_) {
          case MIRType::Int32:
            if (argsIter_->argInRegister())
                frameOffset_ = pushLocal(4);
            else
                frameOffset_ = -(argsIter_->offsetFromArgBase() + sizeof(Frame));
            break;
          case MIRType::Int64:
            if (argsIter_->argInRegister())
                frameOffset_ = pushLocal(8);
            else
                frameOffset_ = -(argsIter_->offsetFromArgBase() + sizeof(Frame));
            break;
          case MIRType::Double:
            if (argsIter_->argInRegister())
                frameOffset_ = pushLocal(8);
            else
                frameOffset_ = -(argsIter_->offsetFromArgBase() + sizeof(Frame));
            break;
          case MIRType::Float32:
            if (argsIter_->argInRegister())
                frameOffset_ = pushLocal(4);
            else
                frameOffset_ = -(argsIter_->offsetFromArgBase() + sizeof(Frame));
            break;
          default:
            MOZ_CRASH("Argument type");
        }
        return;
    }

    MOZ_ASSERT(argsIter_.done());
    if (index_ < locals_.length()) {
        switch (locals_[index_]) {
          case ValType::I32:
            mirType_ = jit::MIRType::Int32;
            frameOffset_ = pushLocal(4);
            break;
          case ValType::F32:
            mirType_ = jit::MIRType::Float32;
            frameOffset_ = pushLocal(4);
            break;
          case ValType::F64:
            mirType_ = jit::MIRType::Double;
            frameOffset_ = pushLocal(8);
            break;
          case ValType::I64:
            mirType_ = jit::MIRType::Int64;
            frameOffset_ = pushLocal(8);
            break;
          default:
            MOZ_CRASH("Compiler bug: Unexpected local type");
        }
        return;
    }

    done_ = true;
}

void
BaseLocalIter::operator++(int)
{
    MOZ_ASSERT(!done_);
    index_++;
    if (!argsIter_.done())
        argsIter_++;
    settle();
}

class BaseCompiler
{
    // We define our own ScratchRegister abstractions, deferring to
    // the platform's when possible.

#if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_ARM)
    typedef ScratchDoubleScope ScratchF64;
#else
    class ScratchF64
    {
      public:
        ScratchF64(BaseCompiler& b) {}
        operator FloatRegister() const {
            MOZ_CRASH("BaseCompiler platform hook - ScratchF64");
        }
    };
#endif

#if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_ARM)
    typedef ScratchFloat32Scope ScratchF32;
#else
    class ScratchF32
    {
      public:
        ScratchF32(BaseCompiler& b) {}
        operator FloatRegister() const {
            MOZ_CRASH("BaseCompiler platform hook - ScratchF32");
        }
    };
#endif

#if defined(JS_CODEGEN_X64)
    typedef ScratchRegisterScope ScratchI32;
#elif defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_ARM)
    class ScratchI32
    {
# ifdef DEBUG
        BaseCompiler& bc;
      public:
        explicit ScratchI32(BaseCompiler& bc) : bc(bc) {
            MOZ_ASSERT(!bc.scratchRegisterTaken());
            bc.setScratchRegisterTaken(true);
        }
        ~ScratchI32() {
            MOZ_ASSERT(bc.scratchRegisterTaken());
            bc.setScratchRegisterTaken(false);
        }
# else
      public:
        explicit ScratchI32(BaseCompiler& bc) {}
# endif
        operator Register() const {
# ifdef JS_CODEGEN_X86
            return ScratchRegX86;
# else
            return ScratchRegARM;
# endif
        }
    };
#else
    class ScratchI32
    {
      public:
        ScratchI32(BaseCompiler& bc) {}
        operator Register() const {
            MOZ_CRASH("BaseCompiler platform hook - ScratchI32");
        }
    };
#endif

    typedef Vector<NonAssertingLabel, 8, SystemAllocPolicy> LabelVector;

    // The strongly typed register wrappers have saved my bacon a few
    // times; though they are largely redundant they stay, for now.

    struct RegI32 : public Register
    {
        RegI32() : Register(Register::Invalid()) {}
        explicit RegI32(Register reg) : Register(reg) {}
    };

    struct RegI64 : public Register64
    {
        RegI64() : Register64(Register64::Invalid()) {}
        explicit RegI64(Register64 reg) : Register64(reg) {}
    };

    struct RegF32 : public FloatRegister
    {
        RegF32() : FloatRegister() {}
        explicit RegF32(FloatRegister reg) : FloatRegister(reg) {}
    };

    struct RegF64 : public FloatRegister
    {
        RegF64() : FloatRegister() {}
        explicit RegF64(FloatRegister reg) : FloatRegister(reg) {}
    };

    struct AnyReg
    {
        AnyReg() { tag = NONE; }
        explicit AnyReg(RegI32 r) { tag = I32; i32_ = r; }
        explicit AnyReg(RegI64 r) { tag = I64; i64_ = r; }
        explicit AnyReg(RegF32 r) { tag = F32; f32_ = r; }
        explicit AnyReg(RegF64 r) { tag = F64; f64_ = r; }

        RegI32 i32() {
            MOZ_ASSERT(tag == I32);
            return i32_;
        }
        RegI64 i64() {
            MOZ_ASSERT(tag == I64);
            return i64_;
        }
        RegF32 f32() {
            MOZ_ASSERT(tag == F32);
            return f32_;
        }
        RegF64 f64() {
            MOZ_ASSERT(tag == F64);
            return f64_;
        }
        AnyRegister any() {
            switch (tag) {
              case F32: return AnyRegister(f32_);
              case F64: return AnyRegister(f64_);
              case I32: return AnyRegister(i32_);
              case I64:
#ifdef JS_PUNBOX64
                return AnyRegister(i64_.reg);
#else
                // The compiler is written so that this is never needed: any() is called
                // on arbitrary registers for asm.js but asm.js does not have 64-bit ints.
                // For wasm, any() is called on arbitrary registers only on 64-bit platforms.
                MOZ_CRASH("AnyReg::any() on 32-bit platform");
#endif
              case NONE:
                MOZ_CRASH("AnyReg::any() on NONE");
            }
            // Work around GCC 5 analysis/warning bug.
            MOZ_CRASH("AnyReg::any(): impossible case");
        }

        union {
            RegI32 i32_;
            RegI64 i64_;
            RegF32 f32_;
            RegF64 f64_;
        };
        enum { NONE, I32, I64, F32, F64 } tag;
    };

    struct Local
    {
        Local() : type_(MIRType::None), offs_(UINT32_MAX) {}
        Local(MIRType type, uint32_t offs) : type_(type), offs_(offs) {}

        void init(MIRType type_, uint32_t offs_) {
            this->type_ = type_;
            this->offs_ = offs_;
        }

        MIRType  type_;              // Type of the value, or MIRType::None
        uint32_t offs_;              // Zero-based frame offset of value, or UINT32_MAX

        MIRType type() const { MOZ_ASSERT(type_ != MIRType::None); return type_; }
        uint32_t offs() const { MOZ_ASSERT(offs_ != UINT32_MAX); return offs_; }
    };

    // Bit set used for simple bounds check elimination.  Capping this at 64
    // locals makes sense; even 32 locals would probably be OK in practice.
    //
    // For more information about BCE, see the block comment above
    // popMemoryAccess(), below.

    typedef uint64_t BCESet;

    // Control node, representing labels and stack heights at join points.

    struct Control
    {
        Control()
            : framePushed(UINT32_MAX),
              stackSize(UINT32_MAX),
              bceSafeOnEntry(0),
              bceSafeOnExit(~BCESet(0)),
              deadOnArrival(false),
              deadThenBranch(false)
        {}

        NonAssertingLabel label;        // The "exit" label
        NonAssertingLabel otherLabel;   // Used for the "else" branch of if-then-else
        uint32_t framePushed;           // From masm
        uint32_t stackSize;             // Value stack height
        BCESet bceSafeOnEntry;          // Bounds check info flowing into the item
        BCESet bceSafeOnExit;           // Bounds check info flowing out of the item
        bool deadOnArrival;             // deadCode_ was set on entry to the region
        bool deadThenBranch;            // deadCode_ was set on exit from "then"
    };

    struct BaseCompilePolicy
    {
        // The baseline compiler tracks values on a stack of its own -- it
        // needs to scan that stack for spilling -- and thus has no need
        // for the values maintained by the iterator.
        typedef Nothing Value;

        // The baseline compiler uses the iterator's control stack, attaching
        // its own control information.
        typedef Control ControlItem;
    };

    typedef OpIter<BaseCompilePolicy> BaseOpIter;

    // Volatile registers except ReturnReg.

    static LiveRegisterSet VolatileReturnGPR;

    // The baseline compiler will use OOL code more sparingly than
    // Baldr since our code is not high performance and frills like
    // code density and branch prediction friendliness will be less
    // important.

    class OutOfLineCode : public TempObject
    {
      private:
        NonAssertingLabel entry_;
        NonAssertingLabel rejoin_;
        uint32_t framePushed_;

      public:
        OutOfLineCode() : framePushed_(UINT32_MAX) {}

        Label* entry() { return &entry_; }
        Label* rejoin() { return &rejoin_; }

        void setFramePushed(uint32_t framePushed) {
            MOZ_ASSERT(framePushed_ == UINT32_MAX);
            framePushed_ = framePushed;
        }

        void bind(MacroAssembler& masm) {
            MOZ_ASSERT(framePushed_ != UINT32_MAX);
            masm.bind(&entry_);
            masm.setFramePushed(framePushed_);
        }

        // The generate() method must be careful about register use
        // because it will be invoked when there is a register
        // assignment in the BaseCompiler that does not correspond
        // to the available registers when the generated OOL code is
        // executed.  The register allocator *must not* be called.
        //
        // The best strategy is for the creator of the OOL object to
        // allocate all temps that the OOL code will need.
        //
        // Input, output, and temp registers are embedded in the OOL
        // object and are known to the code generator.
        //
        // Scratch registers are available to use in OOL code.
        //
        // All other registers must be explicitly saved and restored
        // by the OOL code before being used.

        virtual void generate(MacroAssembler& masm) = 0;
    };

    enum class LatentOp {
        None,
        Compare,
        Eqz
    };

    const ModuleEnvironment&    env_;
    BaseOpIter                  iter_;
    const FuncBytes&            func_;
    size_t                      lastReadCallSite_;
    TempAllocator&              alloc_;
    const ValTypeVector&        locals_;         // Types of parameters and locals
    int32_t                     localSize_;      // Size of local area in bytes (stable after beginFunction)
    int32_t                     varLow_;         // Low byte offset of local area for true locals (not parameters)
    int32_t                     varHigh_;        // High byte offset + 1 of local area for true locals
    int32_t                     maxFramePushed_; // Max value of masm.framePushed() observed
    bool                        deadCode_;       // Flag indicating we should decode & discard the opcode
    bool                        debugEnabled_;
    BCESet                      bceSafe_;        // Locals that have been bounds checked and not updated since
    ValTypeVector               SigI64I64_;
    ValTypeVector               SigD_;
    ValTypeVector               SigF_;
    MIRTypeVector               SigPI_;
    MIRTypeVector               SigP_;
    NonAssertingLabel           returnLabel_;
    NonAssertingLabel           stackOverflowLabel_;
    CodeOffset                  stackAddOffset_;

    LatentOp                    latentOp_;       // Latent operation for branch (seen next)
    ValType                     latentType_;     // Operand type, if latentOp_ is true
    Assembler::Condition        latentIntCmp_;   // Comparison operator, if latentOp_ == Compare, int types
    Assembler::DoubleCondition  latentDoubleCmp_;// Comparison operator, if latentOp_ == Compare, float types

    FuncOffsets                 offsets_;
    MacroAssembler&             masm;            // No '_' suffix - too tedious...

    AllocatableGeneralRegisterSet availGPR_;
    AllocatableFloatRegisterSet   availFPU_;
#ifdef DEBUG
    bool                          scratchRegisterTaken_;
    AllocatableGeneralRegisterSet allGPR_;       // The registers available to the compiler
    AllocatableFloatRegisterSet   allFPU_;       //   after removing ScratchReg, HeapReg, etc
#endif

    Vector<Local, 8, SystemAllocPolicy> localInfo_;
    Vector<OutOfLineCode*, 8, SystemAllocPolicy> outOfLine_;

    // On specific platforms we sometimes need to use specific registers.

#ifdef JS_CODEGEN_X64
    RegI64 specific_rax;
    RegI64 specific_rcx;
    RegI64 specific_rdx;
#endif

#if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_X86)
    RegI32 specific_eax;
    RegI32 specific_ecx;
    RegI32 specific_edx;
#endif

#if defined(JS_CODEGEN_X86)
    AllocatableGeneralRegisterSet singleByteRegs_;
#endif
#if defined(JS_NUNBOX32)
    RegI64 abiReturnRegI64;
#endif

    // The join registers are used to carry values out of blocks.
    // JoinRegI32 and joinRegI64 must overlap: emitBrIf and
    // emitBrTable assume that.

    RegI32 joinRegI32;
    RegI64 joinRegI64;
    RegF32 joinRegF32;
    RegF64 joinRegF64;

    // There are more members scattered throughout.

  public:
    BaseCompiler(const ModuleEnvironment& env,
                 Decoder& decoder,
                 const FuncBytes& func,
                 const ValTypeVector& locals,
                 bool debugEnabled,
                 TempAllocator* alloc,
                 MacroAssembler* masm);

    MOZ_MUST_USE bool init();

    FuncOffsets finish();

    MOZ_MUST_USE bool emitFunction();

    // Used by some of the ScratchRegister implementations.
    operator MacroAssembler&() const { return masm; }

#ifdef DEBUG
    bool scratchRegisterTaken() const {
        return scratchRegisterTaken_;
    }
    void setScratchRegisterTaken(bool state) {
        scratchRegisterTaken_ = state;
    }
#endif

  private:

    ////////////////////////////////////////////////////////////
    //
    // Out of line code management.

    MOZ_MUST_USE OutOfLineCode* addOutOfLineCode(OutOfLineCode* ool) {
        if (!ool || !outOfLine_.append(ool))
            return nullptr;
        ool->setFramePushed(masm.framePushed());
        return ool;
    }

    MOZ_MUST_USE bool generateOutOfLineCode() {
        for (uint32_t i = 0; i < outOfLine_.length(); i++) {
            OutOfLineCode* ool = outOfLine_[i];
            ool->bind(masm);
            ool->generate(masm);
        }

        return !masm.oom();
    }

    ////////////////////////////////////////////////////////////
    //
    // The stack frame.

    // SP-relative load and store.

    int32_t localOffsetToSPOffset(int32_t offset) {
        return masm.framePushed() - offset;
    }

    void storeToFrameI32(Register r, int32_t offset) {
        masm.store32(r, Address(StackPointer, localOffsetToSPOffset(offset)));
    }

    void storeToFrameI64(Register64 r, int32_t offset) {
        masm.store64(r, Address(StackPointer, localOffsetToSPOffset(offset)));
    }

    void storeToFramePtr(Register r, int32_t offset) {
        masm.storePtr(r, Address(StackPointer, localOffsetToSPOffset(offset)));
    }

    void storeToFrameF64(FloatRegister r, int32_t offset) {
        masm.storeDouble(r, Address(StackPointer, localOffsetToSPOffset(offset)));
    }

    void storeToFrameF32(FloatRegister r, int32_t offset) {
        masm.storeFloat32(r, Address(StackPointer, localOffsetToSPOffset(offset)));
    }

    void loadFromFrameI32(Register r, int32_t offset) {
        masm.load32(Address(StackPointer, localOffsetToSPOffset(offset)), r);
    }

    void loadFromFrameI64(Register64 r, int32_t offset) {
        masm.load64(Address(StackPointer, localOffsetToSPOffset(offset)), r);
    }

    void loadFromFramePtr(Register r, int32_t offset) {
        masm.loadPtr(Address(StackPointer, localOffsetToSPOffset(offset)), r);
    }

    void loadFromFrameF64(FloatRegister r, int32_t offset) {
        masm.loadDouble(Address(StackPointer, localOffsetToSPOffset(offset)), r);
    }

    void loadFromFrameF32(FloatRegister r, int32_t offset) {
        masm.loadFloat32(Address(StackPointer, localOffsetToSPOffset(offset)), r);
    }

    int32_t frameOffsetFromSlot(uint32_t slot, MIRType type) {
        MOZ_ASSERT(localInfo_[slot].type() == type);
        return localInfo_[slot].offs();
    }

    ////////////////////////////////////////////////////////////
    //
    // Low-level register allocation.

    bool isAvailable(Register r) {
        return availGPR_.has(r);
    }

    bool hasGPR() {
        return !availGPR_.empty();
    }

    void allocGPR(Register r) {
        MOZ_ASSERT(isAvailable(r));
        availGPR_.take(r);
    }

    Register allocGPR() {
        MOZ_ASSERT(hasGPR());
        return availGPR_.takeAny();
    }

    void freeGPR(Register r) {
        availGPR_.add(r);
    }

    bool isAvailable(Register64 r) {
#ifdef JS_PUNBOX64
        return isAvailable(r.reg);
#else
        return isAvailable(r.low) && isAvailable(r.high);
#endif
    }

    bool hasInt64() {
#ifdef JS_PUNBOX64
        return !availGPR_.empty();
#else
        if (availGPR_.empty())
            return false;
        Register r = allocGPR();
        bool available = !availGPR_.empty();
        freeGPR(r);
        return available;
#endif
    }

    void allocInt64(Register64 r) {
        MOZ_ASSERT(isAvailable(r));
#ifdef JS_PUNBOX64
        availGPR_.take(r.reg);
#else
        availGPR_.take(r.low);
        availGPR_.take(r.high);
#endif
    }

    Register64 allocInt64() {
        MOZ_ASSERT(hasInt64());
#ifdef JS_PUNBOX64
        return Register64(availGPR_.takeAny());
#else
        Register high = availGPR_.takeAny();
        Register low = availGPR_.takeAny();
        return Register64(high, low);
#endif
    }

    void freeInt64(Register64 r) {
#ifdef JS_PUNBOX64
        availGPR_.add(r.reg);
#else
        availGPR_.add(r.low);
        availGPR_.add(r.high);
#endif
    }

    // Notes on float register allocation.
    //
    // The general rule in SpiderMonkey is that float registers can
    // alias double registers, but there are predicates to handle
    // exceptions to that rule: hasUnaliasedDouble() and
    // hasMultiAlias().  The way aliasing actually works is platform
    // dependent and exposed through the aliased(n, &r) predicate,
    // etc.
    //
    //  - hasUnaliasedDouble(): on ARM VFPv3-D32 there are double
    //    registers that cannot be treated as float.
    //  - hasMultiAlias(): on ARM and MIPS a double register aliases
    //    two float registers.
    //  - notes in Architecture-arm.h indicate that when we use a
    //    float register that aliases a double register we only use
    //    the low float register, never the high float register.  I
    //    think those notes lie, or at least are confusing.
    //  - notes in Architecture-mips32.h suggest that the MIPS port
    //    will use both low and high float registers except on the
    //    Longsoon, which may be the only MIPS that's being tested, so
    //    who knows what's working.
    //  - SIMD is not yet implemented on ARM or MIPS so constraints
    //    may change there.
    //
    // On some platforms (x86, x64, ARM64) but not all (ARM)
    // ScratchFloat32Register is the same as ScratchDoubleRegister.
    //
    // It's a basic invariant of the AllocatableRegisterSet that it
    // deals properly with aliasing of registers: if s0 or s1 are
    // allocated then d0 is not allocatable; if s0 and s1 are freed
    // individually then d0 becomes allocatable.

    template<MIRType t>
    bool hasFPU() {
        return availFPU_.hasAny<RegTypeOf<t>::value>();
    }

    bool isAvailable(FloatRegister r) {
        return availFPU_.has(r);
    }

    void allocFPU(FloatRegister r) {
        MOZ_ASSERT(isAvailable(r));
        availFPU_.take(r);
    }

    template<MIRType t>
    FloatRegister allocFPU() {
        return availFPU_.takeAny<RegTypeOf<t>::value>();
    }

    void freeFPU(FloatRegister r) {
        availFPU_.add(r);
    }

    ////////////////////////////////////////////////////////////
    //
    // Value stack and high-level register allocation.
    //
    // The value stack facilitates some on-the-fly register allocation
    // and immediate-constant use.  It tracks constants, latent
    // references to locals, register contents, and values on the CPU
    // stack.
    //
    // The stack can be flushed to memory using sync().  This is handy
    // to avoid problems with control flow and messy register usage
    // patterns.

    struct Stk
    {
        enum Kind
        {
            // The Mem opcodes are all clustered at the beginning to
            // allow for a quick test within sync().
            MemI32,               // 32-bit integer stack value ("offs")
            MemI64,               // 64-bit integer stack value ("offs")
            MemF32,               // 32-bit floating stack value ("offs")
            MemF64,               // 64-bit floating stack value ("offs")

            // The Local opcodes follow the Mem opcodes for a similar
            // quick test within hasLocal().
            LocalI32,             // Local int32 var ("slot")
            LocalI64,             // Local int64 var ("slot")
            LocalF32,             // Local float32 var ("slot")
            LocalF64,             // Local double var ("slot")

            RegisterI32,          // 32-bit integer register ("i32reg")
            RegisterI64,          // 64-bit integer register ("i64reg")
            RegisterF32,          // 32-bit floating register ("f32reg")
            RegisterF64,          // 64-bit floating register ("f64reg")

            ConstI32,             // 32-bit integer constant ("i32val")
            ConstI64,             // 64-bit integer constant ("i64val")
            ConstF32,             // 32-bit floating constant ("f32val")
            ConstF64,             // 64-bit floating constant ("f64val")

            None                  // Uninitialized or void
        };

        Kind kind_;

        static const Kind MemLast = MemF64;
        static const Kind LocalLast = LocalF64;

        union {
            RegI32   i32reg_;
            RegI64   i64reg_;
            RegF32   f32reg_;
            RegF64   f64reg_;
            int32_t  i32val_;
            int64_t  i64val_;
            float    f32val_;
            double   f64val_;
            uint32_t slot_;
            uint32_t offs_;
        };

        Stk() { kind_ = None; }

        Kind kind() const { return kind_; }
        bool isMem() const { return kind_ <= MemLast; }

        RegI32   i32reg() const { MOZ_ASSERT(kind_ == RegisterI32); return i32reg_; }
        RegI64   i64reg() const { MOZ_ASSERT(kind_ == RegisterI64); return i64reg_; }
        RegF32   f32reg() const { MOZ_ASSERT(kind_ == RegisterF32); return f32reg_; }
        RegF64   f64reg() const { MOZ_ASSERT(kind_ == RegisterF64); return f64reg_; }
        int32_t  i32val() const { MOZ_ASSERT(kind_ == ConstI32); return i32val_; }
        int64_t  i64val() const { MOZ_ASSERT(kind_ == ConstI64); return i64val_; }
        // For these two, use an out-param instead of simply returning, to
        // use the normal stack and not the x87 FP stack (which has effect on
        // NaNs with the signaling bit set).
        void     f32val(float* out) const { MOZ_ASSERT(kind_ == ConstF32); *out = f32val_; }
        void     f64val(double* out) const { MOZ_ASSERT(kind_ == ConstF64); *out = f64val_; }
        uint32_t slot() const { MOZ_ASSERT(kind_ > MemLast && kind_ <= LocalLast); return slot_; }
        uint32_t offs() const { MOZ_ASSERT(isMem()); return offs_; }

        void setI32Reg(RegI32 r) { kind_ = RegisterI32; i32reg_ = r; }
        void setI64Reg(RegI64 r) { kind_ = RegisterI64; i64reg_ = r; }
        void setF32Reg(RegF32 r) { kind_ = RegisterF32; f32reg_ = r; }
        void setF64Reg(RegF64 r) { kind_ = RegisterF64; f64reg_ = r; }
        void setI32Val(int32_t v) { kind_ = ConstI32; i32val_ = v; }
        void setI64Val(int64_t v) { kind_ = ConstI64; i64val_ = v; }
        void setF32Val(float v) { kind_ = ConstF32; f32val_ = v; }
        void setF64Val(double v) { kind_ = ConstF64; f64val_ = v; }
        void setSlot(Kind k, uint32_t v) { MOZ_ASSERT(k > MemLast && k <= LocalLast); kind_ = k; slot_ = v; }
        void setOffs(Kind k, uint32_t v) { MOZ_ASSERT(k <= MemLast); kind_ = k; offs_ = v; }
    };

    Vector<Stk, 8, SystemAllocPolicy> stk_;

    Stk& push() {
        stk_.infallibleEmplaceBack(Stk());
        return stk_.back();
    }

    Register64 invalidRegister64() {
        return Register64::Invalid();
    }

    RegI32 invalidI32() {
        return RegI32(Register::Invalid());
    }

    RegI64 invalidI64() {
        return RegI64(invalidRegister64());
    }

    RegF64 invalidF64() {
        return RegF64(InvalidFloatReg);
    }

    RegI32 fromI64(RegI64 r) {
        return RegI32(lowPart(r));
    }

    RegI64 widenI32(RegI32 r) {
        MOZ_ASSERT(!isAvailable(r));
#ifdef JS_PUNBOX64
        return RegI64(Register64(r));
#else
        RegI32 high = needI32();
        return RegI64(Register64(high, r));
#endif
    }

    Register lowPart(RegI64 r) {
#ifdef JS_PUNBOX64
        return r.reg;
#else
        return r.low;
#endif
    }

    Register maybeHighPart(RegI64 r) {
#ifdef JS_PUNBOX64
        return Register::Invalid();
#else
        return r.high;
#endif
    }

    void maybeClearHighPart(RegI64 r) {
#ifdef JS_NUNBOX32
        masm.move32(Imm32(0), r.high);
#endif
    }

    void freeI32(RegI32 r) {
        freeGPR(r);
    }

    void freeI64(RegI64 r) {
        freeInt64(r);
    }

    void freeI64Except(RegI64 r, RegI32 except) {
#ifdef JS_PUNBOX64
        MOZ_ASSERT(r.reg == except);
#else
        MOZ_ASSERT(r.high == except || r.low == except);
        freeI64(r);
        needI32(except);
#endif
    }

    void freeF64(RegF64 r) {
        freeFPU(r);
    }

    void freeF32(RegF32 r) {
        freeFPU(r);
    }

    MOZ_MUST_USE RegI32 needI32() {
        if (!hasGPR())
            sync();            // TODO / OPTIMIZE: improve this (Bug 1316802)
        return RegI32(allocGPR());
    }

    void needI32(RegI32 specific) {
        if (!isAvailable(specific))
            sync();            // TODO / OPTIMIZE: improve this (Bug 1316802)
        allocGPR(specific);
    }

    // TODO / OPTIMIZE: need2xI32() can be optimized along with needI32()
    // to avoid sync(). (Bug 1316802)

    void need2xI32(RegI32 r0, RegI32 r1) {
        needI32(r0);
        needI32(r1);
    }

    MOZ_MUST_USE RegI64 needI64() {
        if (!hasInt64())
            sync();            // TODO / OPTIMIZE: improve this (Bug 1316802)
        return RegI64(allocInt64());
    }

    void needI64(RegI64 specific) {
        if (!isAvailable(specific))
            sync();            // TODO / OPTIMIZE: improve this (Bug 1316802)
        allocInt64(specific);
    }

    void need2xI64(RegI64 r0, RegI64 r1) {
        needI64(r0);
        needI64(r1);
    }

    MOZ_MUST_USE RegF32 needF32() {
        if (!hasFPU<MIRType::Float32>())
            sync();            // TODO / OPTIMIZE: improve this (Bug 1316802)
        return RegF32(allocFPU<MIRType::Float32>());
    }

    void needF32(RegF32 specific) {
        if (!isAvailable(specific))
            sync();            // TODO / OPTIMIZE: improve this (Bug 1316802)
        allocFPU(specific);
    }

    MOZ_MUST_USE RegF64 needF64() {
        if (!hasFPU<MIRType::Double>())
            sync();            // TODO / OPTIMIZE: improve this (Bug 1316802)
        return RegF64(allocFPU<MIRType::Double>());
    }

    void needF64(RegF64 specific) {
        if (!isAvailable(specific))
            sync();            // TODO / OPTIMIZE: improve this (Bug 1316802)
        allocFPU(specific);
    }

    void moveI32(RegI32 src, RegI32 dest) {
        if (src != dest)
            masm.move32(src, dest);
    }

    void moveI64(RegI64 src, RegI64 dest) {
        if (src != dest)
            masm.move64(src, dest);
    }

    void moveF64(RegF64 src, RegF64 dest) {
        if (src != dest)
            masm.moveDouble(src, dest);
    }

    void moveF32(RegF32 src, RegF32 dest) {
        if (src != dest)
            masm.moveFloat32(src, dest);
    }

    void setI64(int64_t v, RegI64 r) {
        masm.move64(Imm64(v), r);
    }

    void loadConstI32(Register r, Stk& src) {
        masm.mov(ImmWord(uint32_t(src.i32val())), r);
    }

    void loadConstI32(Register r, int32_t v) {
        masm.mov(ImmWord(uint32_t(v)), r);
    }

    void loadMemI32(Register r, Stk& src) {
        loadFromFrameI32(r, src.offs());
    }

    void loadLocalI32(Register r, Stk& src) {
        loadFromFrameI32(r, frameOffsetFromSlot(src.slot(), MIRType::Int32));
    }

    void loadRegisterI32(Register r, Stk& src) {
        if (src.i32reg() != r)
            masm.move32(src.i32reg(), r);
    }

    void loadConstI64(Register64 r, Stk &src) {
        masm.move64(Imm64(src.i64val()), r);
    }

    void loadMemI64(Register64 r, Stk& src) {
        loadFromFrameI64(r, src.offs());
    }

    void loadLocalI64(Register64 r, Stk& src) {
        loadFromFrameI64(r, frameOffsetFromSlot(src.slot(), MIRType::Int64));
    }

    void loadRegisterI64(Register64 r, Stk& src) {
        if (src.i64reg() != r)
            masm.move64(src.i64reg(), r);
    }

    void loadConstF64(FloatRegister r, Stk &src) {
        double d;
        src.f64val(&d);
        masm.loadConstantDouble(d, r);
    }

    void loadMemF64(FloatRegister r, Stk& src) {
        loadFromFrameF64(r, src.offs());
    }

    void loadLocalF64(FloatRegister r, Stk& src) {
        loadFromFrameF64(r, frameOffsetFromSlot(src.slot(), MIRType::Double));
    }

    void loadRegisterF64(FloatRegister r, Stk& src) {
        if (src.f64reg() != r)
            masm.moveDouble(src.f64reg(), r);
    }

    void loadConstF32(FloatRegister r, Stk &src) {
        float f;
        src.f32val(&f);
        masm.loadConstantFloat32(f, r);
    }

    void loadMemF32(FloatRegister r, Stk& src) {
        loadFromFrameF32(r, src.offs());
    }

    void loadLocalF32(FloatRegister r, Stk& src) {
        loadFromFrameF32(r, frameOffsetFromSlot(src.slot(), MIRType::Float32));
    }

    void loadRegisterF32(FloatRegister r, Stk& src) {
        if (src.f32reg() != r)
            masm.moveFloat32(src.f32reg(), r);
    }

    void loadI32(Register r, Stk& src) {
        switch (src.kind()) {
          case Stk::ConstI32:
            loadConstI32(r, src);
            break;
          case Stk::MemI32:
            loadMemI32(r, src);
            break;
          case Stk::LocalI32:
            loadLocalI32(r, src);
            break;
          case Stk::RegisterI32:
            loadRegisterI32(r, src);
            break;
          case Stk::None:
          default:
            MOZ_CRASH("Compiler bug: Expected I32 on stack");
        }
    }

    void loadI64(Register64 r, Stk& src) {
        switch (src.kind()) {
          case Stk::ConstI64:
            loadConstI64(r, src);
            break;
          case Stk::MemI64:
            loadMemI64(r, src);
            break;
          case Stk::LocalI64:
            loadLocalI64(r, src);
            break;
          case Stk::RegisterI64:
            loadRegisterI64(r, src);
            break;
          case Stk::None:
          default:
            MOZ_CRASH("Compiler bug: Expected I64 on stack");
        }
    }

#ifdef JS_NUNBOX32
    void loadI64Low(Register r, Stk& src) {
        switch (src.kind()) {
          case Stk::ConstI64:
            masm.move32(Imm64(src.i64val()).low(), r);
            break;
          case Stk::MemI64:
            loadFromFrameI32(r, src.offs() - INT64LOW_OFFSET);
            break;
          case Stk::LocalI64:
            loadFromFrameI32(r, frameOffsetFromSlot(src.slot(), MIRType::Int64) - INT64LOW_OFFSET);
            break;
          case Stk::RegisterI64:
            if (src.i64reg().low != r)
                masm.move32(src.i64reg().low, r);
            break;
          case Stk::None:
          default:
            MOZ_CRASH("Compiler bug: Expected I64 on stack");
        }
    }

    void loadI64High(Register r, Stk& src) {
        switch (src.kind()) {
          case Stk::ConstI64:
            masm.move32(Imm64(src.i64val()).hi(), r);
            break;
          case Stk::MemI64:
            loadFromFrameI32(r, src.offs() - INT64HIGH_OFFSET);
            break;
          case Stk::LocalI64:
            loadFromFrameI32(r, frameOffsetFromSlot(src.slot(), MIRType::Int64) - INT64HIGH_OFFSET);
            break;
          case Stk::RegisterI64:
            if (src.i64reg().high != r)
                masm.move32(src.i64reg().high, r);
            break;
          case Stk::None:
          default:
            MOZ_CRASH("Compiler bug: Expected I64 on stack");
        }
    }
#endif

    void loadF64(FloatRegister r, Stk& src) {
        switch (src.kind()) {
          case Stk::ConstF64:
            loadConstF64(r, src);
            break;
          case Stk::MemF64:
            loadMemF64(r, src);
            break;
          case Stk::LocalF64:
            loadLocalF64(r, src);
            break;
          case Stk::RegisterF64:
            loadRegisterF64(r, src);
            break;
          case Stk::None:
          default:
            MOZ_CRASH("Compiler bug: expected F64 on stack");
        }
    }

    void loadF32(FloatRegister r, Stk& src) {
        switch (src.kind()) {
          case Stk::ConstF32:
            loadConstF32(r, src);
            break;
          case Stk::MemF32:
            loadMemF32(r, src);
            break;
          case Stk::LocalF32:
            loadLocalF32(r, src);
            break;
          case Stk::RegisterF32:
            loadRegisterF32(r, src);
            break;
          case Stk::None:
          default:
            MOZ_CRASH("Compiler bug: expected F32 on stack");
        }
    }

    // Flush all local and register value stack elements to memory.
    //
    // TODO / OPTIMIZE: As this is fairly expensive and causes worse
    // code to be emitted subsequently, it is useful to avoid calling
    // it.  (Bug 1316802)
    //
    // Some optimization has been done already.  Remaining
    // opportunities:
    //
    //  - It would be interesting to see if we can specialize it
    //    before calls with particularly simple signatures, or where
    //    we can do parallel assignment of register arguments, or
    //    similar.  See notes in emitCall().
    //
    //  - Operations that need specific registers: multiply, quotient,
    //    remainder, will tend to sync because the registers we need
    //    will tend to be allocated.  We may be able to avoid that by
    //    prioritizing registers differently (takeLast instead of
    //    takeFirst) but we may also be able to allocate an unused
    //    register on demand to free up one we need, thus avoiding the
    //    sync.  That type of fix would go into needI32().

    void sync() {
        size_t start = 0;
        size_t lim = stk_.length();

        for (size_t i = lim; i > 0; i--) {
            // Memory opcodes are first in the enum, single check against MemLast is fine.
            if (stk_[i - 1].kind() <= Stk::MemLast) {
                start = i;
                break;
            }
        }

        for (size_t i = start; i < lim; i++) {
            Stk& v = stk_[i];
            switch (v.kind()) {
              case Stk::LocalI32: {
                ScratchI32 scratch(*this);
                loadLocalI32(scratch, v);
                masm.Push(scratch);
                v.setOffs(Stk::MemI32, masm.framePushed());
                break;
              }
              case Stk::RegisterI32: {
                masm.Push(v.i32reg());
                freeI32(v.i32reg());
                v.setOffs(Stk::MemI32, masm.framePushed());
                break;
              }
              case Stk::LocalI64: {
                ScratchI32 scratch(*this);
#ifdef JS_PUNBOX64
                loadI64(Register64(scratch), v);
                masm.Push(scratch);
#else
                int32_t offset = frameOffsetFromSlot(v.slot(), MIRType::Int64);
                loadFromFrameI32(scratch, offset - INT64HIGH_OFFSET);
                masm.Push(scratch);
                loadFromFrameI32(scratch, offset - INT64LOW_OFFSET);
                masm.Push(scratch);
#endif
                v.setOffs(Stk::MemI64, masm.framePushed());
                break;
              }
              case Stk::RegisterI64: {
#ifdef JS_PUNBOX64
                masm.Push(v.i64reg().reg);
                freeI64(v.i64reg());
#else
                masm.Push(v.i64reg().high);
                masm.Push(v.i64reg().low);
                freeI64(v.i64reg());
#endif
                v.setOffs(Stk::MemI64, masm.framePushed());
                break;
              }
              case Stk::LocalF64: {
                ScratchF64 scratch(*this);
                loadF64(scratch, v);
                masm.Push(scratch);
                v.setOffs(Stk::MemF64, masm.framePushed());
                break;
              }
              case Stk::RegisterF64: {
                masm.Push(v.f64reg());
                freeF64(v.f64reg());
                v.setOffs(Stk::MemF64, masm.framePushed());
                break;
              }
              case Stk::LocalF32: {
                ScratchF32 scratch(*this);
                loadF32(scratch, v);
                masm.Push(scratch);
                v.setOffs(Stk::MemF32, masm.framePushed());
                break;
              }
              case Stk::RegisterF32: {
                masm.Push(v.f32reg());
                freeF32(v.f32reg());
                v.setOffs(Stk::MemF32, masm.framePushed());
                break;
              }
              default: {
                break;
              }
            }
        }

        maxFramePushed_ = Max(maxFramePushed_, int32_t(masm.framePushed()));
    }

    // This is an optimization used to avoid calling sync() for
    // setLocal(): if the local does not exist unresolved on the stack
    // then we can skip the sync.

    bool hasLocal(uint32_t slot) {
        for (size_t i = stk_.length(); i > 0; i--) {
            // Memory opcodes are first in the enum, single check against MemLast is fine.
            Stk::Kind kind = stk_[i-1].kind();
            if (kind <= Stk::MemLast)
                return false;

            // Local opcodes follow memory opcodes in the enum, single check against
            // LocalLast is sufficient.
            if (kind <= Stk::LocalLast && stk_[i-1].slot() == slot)
                return true;
        }
        return false;
    }

    void syncLocal(uint32_t slot) {
        if (hasLocal(slot))
            sync();            // TODO / OPTIMIZE: Improve this?  (Bug 1316817)
    }

    // Push the register r onto the stack.

    void pushI32(RegI32 r) {
        MOZ_ASSERT(!isAvailable(r));
        Stk& x = push();
        x.setI32Reg(r);
    }

    void pushI64(RegI64 r) {
        MOZ_ASSERT(!isAvailable(r));
        Stk& x = push();
        x.setI64Reg(r);
    }

    void pushF64(RegF64 r) {
        MOZ_ASSERT(!isAvailable(r));
        Stk& x = push();
        x.setF64Reg(r);
    }

    void pushF32(RegF32 r) {
        MOZ_ASSERT(!isAvailable(r));
        Stk& x = push();
        x.setF32Reg(r);
    }

    // Push the value onto the stack.

    void pushI32(int32_t v) {
        Stk& x = push();
        x.setI32Val(v);
    }

    void pushI64(int64_t v) {
        Stk& x = push();
        x.setI64Val(v);
    }

    void pushF64(double v) {
        Stk& x = push();
        x.setF64Val(v);
    }

    void pushF32(float v) {
        Stk& x = push();
        x.setF32Val(v);
    }

    // Push the local slot onto the stack.  The slot will not be read
    // here; it will be read when it is consumed, or when a side
    // effect to the slot forces its value to be saved.

    void pushLocalI32(uint32_t slot) {
        Stk& x = push();
        x.setSlot(Stk::LocalI32, slot);
    }

    void pushLocalI64(uint32_t slot) {
        Stk& x = push();
        x.setSlot(Stk::LocalI64, slot);
    }

    void pushLocalF64(uint32_t slot) {
        Stk& x = push();
        x.setSlot(Stk::LocalF64, slot);
    }

    void pushLocalF32(uint32_t slot) {
        Stk& x = push();
        x.setSlot(Stk::LocalF32, slot);
    }

    // PRIVATE.  Call only from other popI32() variants.
    // v must be the stack top.

    void popI32(Stk& v, RegI32 r) {
        switch (v.kind()) {
          case Stk::ConstI32:
            loadConstI32(r, v);
            break;
          case Stk::LocalI32:
            loadLocalI32(r, v);
            break;
          case Stk::MemI32:
            masm.Pop(r);
            break;
          case Stk::RegisterI32:
            loadRegisterI32(r, v);
            break;
          case Stk::None:
          default:
            MOZ_CRASH("Compiler bug: expected int on stack");
        }
    }

    MOZ_MUST_USE RegI32 popI32() {
        Stk& v = stk_.back();
        RegI32 r;
        if (v.kind() == Stk::RegisterI32)
            r = v.i32reg();
        else
            popI32(v, (r = needI32()));
        stk_.popBack();
        return r;
    }

    RegI32 popI32(RegI32 specific) {
        Stk& v = stk_.back();

        if (!(v.kind() == Stk::RegisterI32 && v.i32reg() == specific)) {
            needI32(specific);
            popI32(v, specific);
            if (v.kind() == Stk::RegisterI32)
                freeI32(v.i32reg());
        }

        stk_.popBack();
        return specific;
    }

    // PRIVATE.  Call only from other popI64() variants.
    // v must be the stack top.

    void popI64(Stk& v, RegI64 r) {
        switch (v.kind()) {
          case Stk::ConstI64:
            loadConstI64(r, v);
            break;
          case Stk::LocalI64:
            loadLocalI64(r, v);
            break;
          case Stk::MemI64:
#ifdef JS_PUNBOX64
            masm.Pop(r.reg);
#else
            masm.Pop(r.low);
            masm.Pop(r.high);
#endif
            break;
          case Stk::RegisterI64:
            loadRegisterI64(r, v);
            break;
          case Stk::None:
          default:
            MOZ_CRASH("Compiler bug: expected long on stack");
        }
    }

    MOZ_MUST_USE RegI64 popI64() {
        Stk& v = stk_.back();
        RegI64 r;
        if (v.kind() == Stk::RegisterI64)
            r = v.i64reg();
        else
            popI64(v, (r = needI64()));
        stk_.popBack();
        return r;
    }

    // Note, the stack top can be in one half of "specific" on 32-bit
    // systems.  We can optimize, but for simplicity, if the register
    // does not match exactly, then just force the stack top to memory
    // and then read it back in.

    RegI64 popI64(RegI64 specific) {
        Stk& v = stk_.back();

        if (!(v.kind() == Stk::RegisterI64 && v.i64reg() == specific)) {
            needI64(specific);
            popI64(v, specific);
            if (v.kind() == Stk::RegisterI64)
                freeI64(v.i64reg());
        }

        stk_.popBack();
        return specific;
    }

    // PRIVATE.  Call only from other popF64() variants.
    // v must be the stack top.

    void popF64(Stk& v, RegF64 r) {
        switch (v.kind()) {
          case Stk::ConstF64:
            loadConstF64(r, v);
            break;
          case Stk::LocalF64:
            loadLocalF64(r, v);
            break;
          case Stk::MemF64:
            masm.Pop(r);
            break;
          case Stk::RegisterF64:
            loadRegisterF64(r, v);
            break;
          case Stk::None:
          default:
            MOZ_CRASH("Compiler bug: expected double on stack");
        }
    }

    MOZ_MUST_USE RegF64 popF64() {
        Stk& v = stk_.back();
        RegF64 r;
        if (v.kind() == Stk::RegisterF64)
            r = v.f64reg();
        else
            popF64(v, (r = needF64()));
        stk_.popBack();
        return r;
    }

    RegF64 popF64(RegF64 specific) {
        Stk& v = stk_.back();

        if (!(v.kind() == Stk::RegisterF64 && v.f64reg() == specific)) {
            needF64(specific);
            popF64(v, specific);
            if (v.kind() == Stk::RegisterF64)
                freeF64(v.f64reg());
        }

        stk_.popBack();
        return specific;
    }

    // PRIVATE.  Call only from other popF32() variants.
    // v must be the stack top.

    void popF32(Stk& v, RegF32 r) {
        switch (v.kind()) {
          case Stk::ConstF32:
            loadConstF32(r, v);
            break;
          case Stk::LocalF32:
            loadLocalF32(r, v);
            break;
          case Stk::MemF32:
            masm.Pop(r);
            break;
          case Stk::RegisterF32:
            loadRegisterF32(r, v);
            break;
          case Stk::None:
          default:
            MOZ_CRASH("Compiler bug: expected float on stack");
        }
    }

    MOZ_MUST_USE RegF32 popF32() {
        Stk& v = stk_.back();
        RegF32 r;
        if (v.kind() == Stk::RegisterF32)
            r = v.f32reg();
        else
            popF32(v, (r = needF32()));
        stk_.popBack();
        return r;
    }

    RegF32 popF32(RegF32 specific) {
        Stk& v = stk_.back();

        if (!(v.kind() == Stk::RegisterF32 && v.f32reg() == specific)) {
            needF32(specific);
            popF32(v, specific);
            if (v.kind() == Stk::RegisterF32)
                freeF32(v.f32reg());
        }

        stk_.popBack();
        return specific;
    }

    MOZ_MUST_USE bool popConstI32(int32_t* c) {
        Stk& v = stk_.back();
        if (v.kind() != Stk::ConstI32)
            return false;
        *c = v.i32val();
        stk_.popBack();
        return true;
    }

    MOZ_MUST_USE bool popConstI64(int64_t* c) {
        Stk& v = stk_.back();
        if (v.kind() != Stk::ConstI64)
            return false;
        *c = v.i64val();
        stk_.popBack();
        return true;
    }

    MOZ_MUST_USE bool peekConstI32(int32_t* c) {
        Stk& v = stk_.back();
        if (v.kind() != Stk::ConstI32)
            return false;
        *c = v.i32val();
        return true;
    }

    MOZ_MUST_USE bool peekConstI64(int64_t* c) {
        Stk& v = stk_.back();
        if (v.kind() != Stk::ConstI64)
            return false;
        *c = v.i64val();
        return true;
    }

    MOZ_MUST_USE bool popConstPositivePowerOfTwoI32(int32_t* c,
                                                    uint_fast8_t* power,
                                                    int32_t cutoff)
    {
        Stk& v = stk_.back();
        if (v.kind() != Stk::ConstI32)
            return false;
        *c = v.i32val();
        if (*c <= cutoff || !IsPowerOfTwo(static_cast<uint32_t>(*c)))
            return false;
        *power = FloorLog2(*c);
        stk_.popBack();
        return true;
    }

    MOZ_MUST_USE bool popConstPositivePowerOfTwoI64(int64_t* c,
                                                    uint_fast8_t* power,
                                                    int64_t cutoff)
    {
        Stk& v = stk_.back();
        if (v.kind() != Stk::ConstI64)
            return false;
        *c = v.i64val();
        if (*c <= cutoff || !IsPowerOfTwo(static_cast<uint64_t>(*c)))
            return false;
        *power = FloorLog2(*c);
        stk_.popBack();
        return true;
    }

    MOZ_MUST_USE bool peekLocalI32(uint32_t* local) {
        Stk& v = stk_.back();
        if (v.kind() != Stk::LocalI32)
            return false;
        *local = v.slot();
        return true;
    }

    // TODO / OPTIMIZE (Bug 1316818): At the moment we use ReturnReg
    // for JoinReg.  It is possible other choices would lead to better
    // register allocation, as ReturnReg is often first in the
    // register set and will be heavily wanted by the register
    // allocator that uses takeFirst().
    //
    // Obvious options:
    //  - pick a register at the back of the register set
    //  - pick a random register per block (different blocks have
    //    different join regs)
    //
    // On the other hand, we sync() before every block and only the
    // JoinReg is live out of the block.  But on the way out, we
    // currently pop the JoinReg before freeing regs to be discarded,
    // so there is a real risk of some pointless shuffling there.  If
    // we instead integrate the popping of the join reg into the
    // popping of the stack we can just use the JoinReg as it will
    // become available in that process.

    MOZ_MUST_USE AnyReg popJoinRegUnlessVoid(ExprType type) {
        switch (type) {
          case ExprType::Void: {
            return AnyReg();
          }
          case ExprType::I32: {
            DebugOnly<Stk::Kind> k(stk_.back().kind());
            MOZ_ASSERT(k == Stk::RegisterI32 || k == Stk::ConstI32 || k == Stk::MemI32 ||
                       k == Stk::LocalI32);
            return AnyReg(popI32(joinRegI32));
          }
          case ExprType::I64: {
            DebugOnly<Stk::Kind> k(stk_.back().kind());
            MOZ_ASSERT(k == Stk::RegisterI64 || k == Stk::ConstI64 || k == Stk::MemI64 ||
                       k == Stk::LocalI64);
            return AnyReg(popI64(joinRegI64));
          }
          case ExprType::F64: {
            DebugOnly<Stk::Kind> k(stk_.back().kind());
            MOZ_ASSERT(k == Stk::RegisterF64 || k == Stk::ConstF64 || k == Stk::MemF64 ||
                       k == Stk::LocalF64);
            return AnyReg(popF64(joinRegF64));
          }
          case ExprType::F32: {
            DebugOnly<Stk::Kind> k(stk_.back().kind());
            MOZ_ASSERT(k == Stk::RegisterF32 || k == Stk::ConstF32 || k == Stk::MemF32 ||
                       k == Stk::LocalF32);
            return AnyReg(popF32(joinRegF32));
          }
          default: {
            MOZ_CRASH("Compiler bug: unexpected expression type");
          }
        }
    }

    // If we ever start not sync-ing on entry to Block (but instead try to sync
    // lazily) then this may start asserting because it does not spill the
    // joinreg if the joinreg is already allocated.  Note, it *can't* spill the
    // joinreg in the contexts it's being used, so some other solution will need
    // to be found.

    MOZ_MUST_USE AnyReg captureJoinRegUnlessVoid(ExprType type) {
        switch (type) {
          case ExprType::I32:
            allocGPR(joinRegI32);
            return AnyReg(joinRegI32);
          case ExprType::I64:
            allocInt64(joinRegI64);
            return AnyReg(joinRegI64);
          case ExprType::F32:
            allocFPU(joinRegF32);
            return AnyReg(joinRegF32);
          case ExprType::F64:
            allocFPU(joinRegF64);
            return AnyReg(joinRegF64);
          case ExprType::Void:
            return AnyReg();
          default:
            MOZ_CRASH("Compiler bug: unexpected type");
        }
    }

    void pushJoinRegUnlessVoid(AnyReg r) {
        switch (r.tag) {
          case AnyReg::NONE:
            break;
          case AnyReg::I32:
            pushI32(r.i32());
            break;
          case AnyReg::I64:
            pushI64(r.i64());
            break;
          case AnyReg::F64:
            pushF64(r.f64());
            break;
          case AnyReg::F32:
            pushF32(r.f32());
            break;
        }
    }

    void freeJoinRegUnlessVoid(AnyReg r) {
        switch (r.tag) {
          case AnyReg::NONE:
            break;
          case AnyReg::I32:
            freeI32(r.i32());
            break;
          case AnyReg::I64:
            freeI64(r.i64());
            break;
          case AnyReg::F64:
            freeF64(r.f64());
            break;
          case AnyReg::F32:
            freeF32(r.f32());
            break;
        }
    }

    void maybeReserveJoinRegI(ExprType type) {
        if (type == ExprType::I32)
            needI32(joinRegI32);
        else if (type == ExprType::I64)
            needI64(joinRegI64);
    }

    void maybeUnreserveJoinRegI(ExprType type) {
        if (type == ExprType::I32)
            freeI32(joinRegI32);
        else if (type == ExprType::I64)
            freeI64(joinRegI64);
    }

    void maybeReserveJoinReg(ExprType type) {
        switch (type) {
          case ExprType::I32:
            needI32(joinRegI32);
            break;
          case ExprType::I64:
            needI64(joinRegI64);
            break;
          case ExprType::F32:
            needF32(joinRegF32);
            break;
          case ExprType::F64:
            needF64(joinRegF64);
            break;
          default:
            break;
        }
    }

    void maybeUnreserveJoinReg(ExprType type) {
        switch (type) {
          case ExprType::I32:
            freeI32(joinRegI32);
            break;
          case ExprType::I64:
            freeI64(joinRegI64);
            break;
          case ExprType::F32:
            freeF32(joinRegF32);
            break;
          case ExprType::F64:
            freeF64(joinRegF64);
            break;
          default:
            break;
        }
    }

    // Return the amount of execution stack consumed by the top numval
    // values on the value stack.

    size_t stackConsumed(size_t numval) {
        size_t size = 0;
        MOZ_ASSERT(numval <= stk_.length());
        for (uint32_t i = stk_.length() - 1; numval > 0; numval--, i--) {
            // The size computations come from the implementation of Push() in
            // MacroAssembler-x86-shared.cpp and MacroAssembler-arm-shared.cpp,
            // and from VFPRegister::size() in Architecture-arm.h.
            //
            // On ARM unlike on x86 we push a single for float.

            Stk& v = stk_[i];
            switch (v.kind()) {
              case Stk::MemI32:
#if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_ARM)
                size += sizeof(intptr_t);
#else
                MOZ_CRASH("BaseCompiler platform hook: stackConsumed I32");
#endif
                break;
              case Stk::MemI64:
#if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_ARM)
                size += sizeof(int64_t);
#else
                MOZ_CRASH("BaseCompiler platform hook: stackConsumed I64");
#endif
                break;
              case Stk::MemF64:
#if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_ARM)
                size += sizeof(double);
#else
                MOZ_CRASH("BaseCompiler platform hook: stackConsumed F64");
#endif
                break;
              case Stk::MemF32:
#if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_X86)
                size += sizeof(double);
#elif defined(JS_CODEGEN_ARM)
                size += sizeof(float);
#else
                MOZ_CRASH("BaseCompiler platform hook: stackConsumed F32");
#endif
                break;
              default:
                break;
            }
        }
        return size;
    }

    void popValueStackTo(uint32_t stackSize) {
        for (uint32_t i = stk_.length(); i > stackSize; i--) {
            Stk& v = stk_[i-1];
            switch (v.kind()) {
              case Stk::RegisterI32:
                freeI32(v.i32reg());
                break;
              case Stk::RegisterI64:
                freeI64(v.i64reg());
                break;
              case Stk::RegisterF64:
                freeF64(v.f64reg());
                break;
              case Stk::RegisterF32:
                freeF32(v.f32reg());
                break;
              default:
                break;
            }
        }
        stk_.shrinkTo(stackSize);
    }

    void popValueStackBy(uint32_t items) {
        popValueStackTo(stk_.length() - items);
    }

    // Before branching to an outer control label, pop the execution
    // stack to the level expected by that region, but do not free the
    // stack as that will happen as compilation leaves the block.

    void popStackBeforeBranch(uint32_t framePushed) {
        uint32_t frameHere = masm.framePushed();
        if (frameHere > framePushed)
            masm.addPtr(ImmWord(frameHere - framePushed), StackPointer);
    }

    bool willPopStackBeforeBranch(uint32_t framePushed) {
        uint32_t frameHere = masm.framePushed();
        return frameHere > framePushed;
    }

    // Before exiting a nested control region, pop the execution stack
    // to the level expected by the nesting region, and free the
    // stack.

    void popStackOnBlockExit(uint32_t framePushed) {
        uint32_t frameHere = masm.framePushed();
        if (frameHere > framePushed) {
            if (deadCode_)
                masm.adjustStack(frameHere - framePushed);
            else
                masm.freeStack(frameHere - framePushed);
        }
    }

    void popStackIfMemory() {
        if (peek(0).isMem())
            masm.freeStack(stackConsumed(1));
    }

    // Peek at the stack, for calls.

    Stk& peek(uint32_t relativeDepth) {
        return stk_[stk_.length()-1-relativeDepth];
    }

#ifdef DEBUG
    // Check that we're not leaking registers by comparing the
    // state of the stack + available registers with the set of
    // all available registers.

    // Call this before compiling any code.
    void setupRegisterLeakCheck() {
        allGPR_ = availGPR_;
        allFPU_ = availFPU_;
    }

    // Call this between opcodes.
    void performRegisterLeakCheck() {
        AllocatableGeneralRegisterSet knownGPR_ = availGPR_;
        AllocatableFloatRegisterSet knownFPU_ = availFPU_;
        for (size_t i = 0 ; i < stk_.length() ; i++) {
            Stk& item = stk_[i];
            switch (item.kind_) {
              case Stk::RegisterI32:
                knownGPR_.add(item.i32reg());
                break;
              case Stk::RegisterI64:
#ifdef JS_PUNBOX64
                knownGPR_.add(item.i64reg().reg);
#else
                knownGPR_.add(item.i64reg().high);
                knownGPR_.add(item.i64reg().low);
#endif
                break;
              case Stk::RegisterF32:
                knownFPU_.add(item.f32reg());
                break;
              case Stk::RegisterF64:
                knownFPU_.add(item.f64reg());
                break;
              default:
                break;
            }
        }
        MOZ_ASSERT(knownGPR_.bits() == allGPR_.bits());
        MOZ_ASSERT(knownFPU_.bits() == allFPU_.bits());
    }
#endif

    ////////////////////////////////////////////////////////////
    //
    // Control stack

    void initControl(Control& item)
    {
        // Make sure the constructor was run properly
        MOZ_ASSERT(item.framePushed == UINT32_MAX && item.stackSize == UINT32_MAX);

        item.framePushed = masm.framePushed();
        item.stackSize = stk_.length();
        item.deadOnArrival = deadCode_;
        item.bceSafeOnEntry = bceSafe_;
    }

    Control& controlItem() {
        return iter_.controlItem();
    }

    Control& controlItem(uint32_t relativeDepth) {
        return iter_.controlItem(relativeDepth);
    }

    Control& controlOutermost() {
        return iter_.controlOutermost();
    }

    ////////////////////////////////////////////////////////////
    //
    // Labels

    void insertBreakablePoint(CallSiteDesc::Kind kind) {
        // The debug trap exit requires WasmTlsReg be loaded. However, since we
        // are emitting millions of these breakable points inline, we push this
        // loading of TLS into the FarJumpIsland created by patchCallSites.
        masm.nopPatchableToCall(CallSiteDesc(iter_.lastOpcodeOffset(), kind));
    }

    //////////////////////////////////////////////////////////////////////
    //
    // Function prologue and epilogue.

    void beginFunction() {
        JitSpew(JitSpew_Codegen, "# Emitting wasm baseline code");

        SigIdDesc sigId = env_.funcSigs[func_.index()]->id;
        GenerateFunctionPrologue(masm, localSize_, sigId, &offsets_);

        MOZ_ASSERT(masm.framePushed() == uint32_t(localSize_));

        maxFramePushed_ = localSize_;

        if (debugEnabled_) {
            // Initialize funcIndex and flag fields of DebugFrame.
            size_t debugFrame = masm.framePushed() - DebugFrame::offsetOfFrame();
            masm.store32(Imm32(func_.index()),
                         Address(masm.getStackPointer(), debugFrame + DebugFrame::offsetOfFuncIndex()));
            masm.storePtr(ImmWord(0),
                          Address(masm.getStackPointer(), debugFrame + DebugFrame::offsetOfFlagsWord()));
        }

        // We won't know until after we've generated code how big the frame will
        // be (we may need arbitrary spill slots and outgoing param slots) so
        // emit a patchable add that is patched in endFunction().
        //
        // ScratchReg may be used by branchPtr(), so use ABINonArgReg0/1 for
        // temporaries.

        stackAddOffset_ = masm.add32ToPtrWithPatch(StackPointer, ABINonArgReg0);
        masm.wasmEmitStackCheck(ABINonArgReg0, ABINonArgReg1, &stackOverflowLabel_);

        // Copy arguments from registers to stack.

        const ValTypeVector& args = func_.sig().args();

        for (ABIArgIter<const ValTypeVector> i(args); !i.done(); i++) {
            Local& l = localInfo_[i.index()];
            switch (i.mirType()) {
              case MIRType::Int32:
                if (i->argInRegister())
                    storeToFrameI32(i->gpr(), l.offs());
                break;
              case MIRType::Int64:
                if (i->argInRegister())
                    storeToFrameI64(i->gpr64(), l.offs());
                break;
              case MIRType::Double:
                if (i->argInRegister())
                    storeToFrameF64(i->fpu(), l.offs());
                break;
              case MIRType::Float32:
                if (i->argInRegister())
                    storeToFrameF32(i->fpu(), l.offs());
                break;
              default:
                MOZ_CRASH("Function argument type");
            }
        }

        // Initialize the stack locals to zero.
        //
        // The following are all Bug 1316820:
        //
        // TODO / OPTIMIZE: on x64, at least, scratch will be a 64-bit
        // register and we can move 64 bits at a time.
        //
        // TODO / OPTIMIZE: On SSE2 or better SIMD systems we may be
        // able to store 128 bits at a time.  (I suppose on some
        // systems we have 512-bit SIMD for that matter.)
        //
        // TODO / OPTIMIZE: if we have only one initializing store
        // then it's better to store a zero literal, probably.

        if (varLow_ < varHigh_) {
            ScratchI32 scratch(*this);
            masm.mov(ImmWord(0), scratch);
            for (int32_t i = varLow_ ; i < varHigh_ ; i += 4)
                storeToFrameI32(scratch, i + 4);
        }

        if (debugEnabled_)
            insertBreakablePoint(CallSiteDesc::EnterFrame);
    }

    void saveResult() {
        MOZ_ASSERT(debugEnabled_);
        size_t debugFrameOffset = masm.framePushed() - DebugFrame::offsetOfFrame();
        Address resultsAddress(StackPointer, debugFrameOffset + DebugFrame::offsetOfResults());
        switch (func_.sig().ret()) {
          case ExprType::Void:
            break;
          case ExprType::I32:
            masm.store32(RegI32(ReturnReg), resultsAddress);
            break;

          case ExprType::I64:
            masm.store64(RegI64(ReturnReg64), resultsAddress);
            break;
          case ExprType::F64:
            masm.storeDouble(RegF64(ReturnDoubleReg), resultsAddress);
            break;
          case ExprType::F32:
            masm.storeFloat32(RegF32(ReturnFloat32Reg), resultsAddress);
            break;
          default:
            MOZ_CRASH("Function return type");
        }
    }

    void restoreResult() {
        MOZ_ASSERT(debugEnabled_);
        size_t debugFrameOffset = masm.framePushed() - DebugFrame::offsetOfFrame();
        Address resultsAddress(StackPointer, debugFrameOffset + DebugFrame::offsetOfResults());
        switch (func_.sig().ret()) {
          case ExprType::Void:
            break;
          case ExprType::I32:
            masm.load32(resultsAddress, RegI32(ReturnReg));
            break;
          case ExprType::I64:
            masm.load64(resultsAddress, RegI64(ReturnReg64));
            break;
          case ExprType::F64:
            masm.loadDouble(resultsAddress, RegF64(ReturnDoubleReg));
            break;
          case ExprType::F32:
            masm.loadFloat32(resultsAddress, RegF32(ReturnFloat32Reg));
            break;
          default:
            MOZ_CRASH("Function return type");
        }
    }

    bool endFunction() {
        // Always branch to stackOverflowLabel_ or returnLabel_.
        masm.breakpoint();

        // Patch the add in the prologue so that it checks against the correct
        // frame size. Flush the constant pool in case it needs to be patched.
        MOZ_ASSERT(maxFramePushed_ >= localSize_);
        masm.flush();

        // Precondition for patching.
        if (masm.oom())
            return false;
        masm.patchAdd32ToPtr(stackAddOffset_, Imm32(-int32_t(maxFramePushed_ - localSize_)));

        // Since we just overflowed the stack, to be on the safe side, pop the
        // stack so that, when the trap exit stub executes, it is a safe
        // distance away from the end of the native stack. If debugEnabled_ is
        // set, we pop all locals space except allocated for DebugFrame to
        // maintain the invariant that, when debugEnabled_, all wasm::Frames
        // are valid wasm::DebugFrames which is observable by WasmHandleThrow.
        masm.bind(&stackOverflowLabel_);
        int32_t debugFrameReserved = debugEnabled_ ? DebugFrame::offsetOfFrame() : 0;
        MOZ_ASSERT(localSize_ >= debugFrameReserved);
        if (localSize_ > debugFrameReserved)
            masm.addToStackPtr(Imm32(localSize_ - debugFrameReserved));
        BytecodeOffset prologueTrapOffset(func_.lineOrBytecode());
        masm.jump(TrapDesc(prologueTrapOffset, Trap::StackOverflow, debugFrameReserved));

        masm.bind(&returnLabel_);

        if (debugEnabled_) {
            // Store and reload the return value from DebugFrame::return so that
            // it can be clobbered, and/or modified by the debug trap.
            saveResult();
            insertBreakablePoint(CallSiteDesc::Breakpoint);
            insertBreakablePoint(CallSiteDesc::LeaveFrame);
            restoreResult();
        }

        GenerateFunctionEpilogue(masm, localSize_, &offsets_);

#if defined(JS_ION_PERF)
        // FIXME - profiling code missing.  No bug for this.

        // Note the end of the inline code and start of the OOL code.
        //gen->perfSpewer().noteEndInlineCode(masm);
#endif

        if (!generateOutOfLineCode())
            return false;

        masm.wasmEmitTrapOutOfLineCode();

        offsets_.end = masm.currentOffset();

        // A frame greater than 256KB is implausible, probably an attack,
        // so fail the compilation.

        if (maxFramePushed_ > 256 * 1024)
            return false;

        return !masm.oom();
    }

    //////////////////////////////////////////////////////////////////////
    //
    // Calls.

    struct FunctionCall
    {
        explicit FunctionCall(uint32_t lineOrBytecode)
          : lineOrBytecode(lineOrBytecode),
            reloadMachineStateAfter(false),
            usesSystemAbi(false),
#ifdef JS_CODEGEN_ARM
            hardFP(true),
#endif
            frameAlignAdjustment(0),
            stackArgAreaSize(0)
        {}

        uint32_t lineOrBytecode;
        ABIArgGenerator abi;
        bool reloadMachineStateAfter;
        bool usesSystemAbi;
#ifdef JS_CODEGEN_ARM
        bool hardFP;
#endif
        size_t frameAlignAdjustment;
        size_t stackArgAreaSize;
    };

    void beginCall(FunctionCall& call, UseABI useABI, InterModule interModule)
    {
        call.reloadMachineStateAfter = interModule == InterModule::True || useABI == UseABI::System;
        call.usesSystemAbi = useABI == UseABI::System;

        if (call.usesSystemAbi) {
            // Call-outs need to use the appropriate system ABI.
#if defined(JS_CODEGEN_ARM)
# if defined(JS_SIMULATOR_ARM)
            call.hardFP = UseHardFpABI();
# elif defined(JS_CODEGEN_ARM_HARDFP)
            call.hardFP = true;
# else
            call.hardFP = false;
# endif
            call.abi.setUseHardFp(call.hardFP);
#endif
        }

        call.frameAlignAdjustment = ComputeByteAlignment(masm.framePushed() + sizeof(Frame),
                                                         JitStackAlignment);
    }

    void endCall(FunctionCall& call, size_t stackSpace)
    {
        size_t adjustment = call.stackArgAreaSize + call.frameAlignAdjustment;
        masm.freeStack(stackSpace + adjustment);

        if (call.reloadMachineStateAfter) {
            // On x86 there are no pinned registers, so don't waste time
            // reloading the Tls.
#ifndef JS_CODEGEN_X86
            masm.loadWasmTlsRegFromFrame();
            masm.loadWasmPinnedRegsFromTls();
#endif
        }
    }

    // TODO / OPTIMIZE (Bug 1316821): This is expensive; let's roll the iterator
    // walking into the walking done for passArg.  See comments in passArg.

    // Note, stackArgAreaSize() must process all the arguments to get the
    // alignment right; the signature must therefore be the complete call
    // signature.

    template<class T>
    size_t stackArgAreaSize(const T& args) {
        ABIArgIter<const T> i(args);
        while (!i.done())
            i++;
        return AlignBytes(i.stackBytesConsumedSoFar(), 16u);
    }

    void startCallArgs(FunctionCall& call, size_t stackArgAreaSize)
    {
        call.stackArgAreaSize = stackArgAreaSize;

        size_t adjustment = call.stackArgAreaSize + call.frameAlignAdjustment;
        if (adjustment)
            masm.reserveStack(adjustment);
    }

    const ABIArg reservePointerArgument(FunctionCall& call) {
        return call.abi.next(MIRType::Pointer);
    }

    // TODO / OPTIMIZE (Bug 1316821): Note passArg is used only in one place.
    // (Or it was, until Luke wandered through, but that can be fixed again.)
    // I'm not saying we should manually inline it, but we could hoist the
    // dispatch into the caller and have type-specific implementations of
    // passArg: passArgI32(), etc.  Then those might be inlined, at least in PGO
    // builds.
    //
    // The bulk of the work here (60%) is in the next() call, though.
    //
    // Notably, since next() is so expensive, stackArgAreaSize() becomes
    // expensive too.
    //
    // Somehow there could be a trick here where the sequence of
    // argument types (read from the input stream) leads to a cached
    // entry for stackArgAreaSize() and for how to pass arguments...
    //
    // But at least we could reduce the cost of stackArgAreaSize() by
    // first reading the argument types into a (reusable) vector, then
    // we have the outgoing size at low cost, and then we can pass
    // args based on the info we read.

    void passArg(FunctionCall& call, ValType type, Stk& arg) {
        switch (type) {
          case ValType::I32: {
            ABIArg argLoc = call.abi.next(MIRType::Int32);
            if (argLoc.kind() == ABIArg::Stack) {
                ScratchI32 scratch(*this);
                loadI32(scratch, arg);
                masm.store32(scratch, Address(StackPointer, argLoc.offsetFromArgBase()));
            } else {
                loadI32(argLoc.gpr(), arg);
            }
            break;
          }
          case ValType::I64: {
            ABIArg argLoc = call.abi.next(MIRType::Int64);
            if (argLoc.kind() == ABIArg::Stack) {
                ScratchI32 scratch(*this);
#if defined(JS_CODEGEN_X64)
                loadI64(Register64(scratch), arg);
                masm.movq(scratch, Operand(StackPointer, argLoc.offsetFromArgBase()));
#elif defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_ARM)
                loadI64Low(scratch, arg);
                masm.store32(scratch, Address(StackPointer, argLoc.offsetFromArgBase() + INT64LOW_OFFSET));
                loadI64High(scratch, arg);
                masm.store32(scratch, Address(StackPointer, argLoc.offsetFromArgBase() + INT64HIGH_OFFSET));
#else
                MOZ_CRASH("BaseCompiler platform hook: passArg I64");
#endif
            } else {
                loadI64(argLoc.gpr64(), arg);
            }
            break;
          }
          case ValType::F64: {
            ABIArg argLoc = call.abi.next(MIRType::Double);
            switch (argLoc.kind()) {
              case ABIArg::Stack: {
                ScratchF64 scratch(*this);
                loadF64(scratch, arg);
                masm.storeDouble(scratch, Address(StackPointer, argLoc.offsetFromArgBase()));
                break;
              }
#if defined(JS_CODEGEN_REGISTER_PAIR)
              case ABIArg::GPR_PAIR: {
# ifdef JS_CODEGEN_ARM
                ScratchF64 scratch(*this);
                loadF64(scratch, arg);
                masm.ma_vxfer(scratch, argLoc.evenGpr(), argLoc.oddGpr());
                break;
# else
                MOZ_CRASH("BaseCompiler platform hook: passArg F64 pair");
# endif
              }
#endif
              case ABIArg::FPU: {
                loadF64(argLoc.fpu(), arg);
                break;
              }
              case ABIArg::GPR: {
                MOZ_CRASH("Unexpected parameter passing discipline");
              }
            }
            break;
          }
          case ValType::F32: {
            ABIArg argLoc = call.abi.next(MIRType::Float32);
            switch (argLoc.kind()) {
              case ABIArg::Stack: {
                ScratchF32 scratch(*this);
                loadF32(scratch, arg);
                masm.storeFloat32(scratch, Address(StackPointer, argLoc.offsetFromArgBase()));
                break;
              }
              case ABIArg::GPR: {
                ScratchF32 scratch(*this);
                loadF32(scratch, arg);
                masm.moveFloat32ToGPR(scratch, argLoc.gpr());
                break;
              }
              case ABIArg::FPU: {
                loadF32(argLoc.fpu(), arg);
                break;
              }
#if defined(JS_CODEGEN_REGISTER_PAIR)
              case ABIArg::GPR_PAIR: {
                MOZ_CRASH("Unexpected parameter passing discipline");
              }
#endif
            }
            break;
          }
          default:
            MOZ_CRASH("Function argument type");
        }
    }

    void callDefinition(uint32_t funcIndex, const FunctionCall& call)
    {
        CallSiteDesc desc(call.lineOrBytecode, CallSiteDesc::Func);
        masm.call(desc, funcIndex);
    }

    void callSymbolic(SymbolicAddress callee, const FunctionCall& call) {
        CallSiteDesc desc(call.lineOrBytecode, CallSiteDesc::Symbolic);
        masm.call(desc, callee);
    }

    // Precondition: sync()

    void callIndirect(uint32_t sigIndex, Stk& indexVal, const FunctionCall& call)
    {
        const SigWithId& sig = env_.sigs[sigIndex];
        MOZ_ASSERT(sig.id.kind() != SigIdDesc::Kind::None);

        MOZ_ASSERT(env_.tables.length() == 1);
        const TableDesc& table = env_.tables[0];

        loadI32(WasmTableCallIndexReg, indexVal);

        CallSiteDesc desc(call.lineOrBytecode, CallSiteDesc::Dynamic);
        CalleeDesc callee = CalleeDesc::wasmTable(table, sig.id);
        masm.wasmCallIndirect(desc, callee, NeedsBoundsCheck(true));
    }

    // Precondition: sync()

    void callImport(unsigned globalDataOffset, const FunctionCall& call)
    {
        CallSiteDesc desc(call.lineOrBytecode, CallSiteDesc::Dynamic);
        CalleeDesc callee = CalleeDesc::import(globalDataOffset);
        masm.wasmCallImport(desc, callee);
    }

    void builtinCall(SymbolicAddress builtin, const FunctionCall& call)
    {
        callSymbolic(builtin, call);
    }

    void builtinInstanceMethodCall(SymbolicAddress builtin, const ABIArg& instanceArg,
                                   const FunctionCall& call)
    {
        // Builtin method calls assume the TLS register has been set.
        masm.loadWasmTlsRegFromFrame();

        CallSiteDesc desc(call.lineOrBytecode, CallSiteDesc::Symbolic);
        masm.wasmCallBuiltinInstanceMethod(desc, instanceArg, builtin);
    }

    //////////////////////////////////////////////////////////////////////
    //
    // Sundry low-level code generators.

    void addInterruptCheck()
    {
        // Always use signals for interrupts with Asm.JS/Wasm
        MOZ_RELEASE_ASSERT(HaveSignalHandlers());
    }

    void jumpTable(LabelVector& labels, Label* theTable) {
        // Flush constant pools to ensure that the table is never interrupted by
        // constant pool entries.
        masm.flush();

        masm.bind(theTable);

#if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_ARM)
        for (uint32_t i = 0; i < labels.length(); i++) {
            CodeLabel cl;
            masm.writeCodePointer(cl.patchAt());
            cl.target()->bind(labels[i].offset());
            masm.addCodeLabel(cl);
        }
#else
        MOZ_CRASH("BaseCompiler platform hook: jumpTable");
#endif
    }

    void tableSwitch(Label* theTable, RegI32 switchValue, Label* dispatchCode) {
        masm.bind(dispatchCode);

#if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_X86)
        ScratchI32 scratch(*this);
        CodeLabel tableCl;

        masm.mov(tableCl.patchAt(), scratch);

        tableCl.target()->bind(theTable->offset());
        masm.addCodeLabel(tableCl);

        masm.jmp(Operand(scratch, switchValue, ScalePointer));
#elif defined(JS_CODEGEN_ARM)
        // Flush constant pools: offset must reflect the distance from the MOV
        // to the start of the table; as the address of the MOV is given by the
        // label, nothing must come between the bind() and the ma_mov().
        masm.flush();

        ScratchI32 scratch(*this);

        // Compute the offset from the ma_mov instruction to the jump table.
        Label here;
        masm.bind(&here);
        uint32_t offset = here.offset() - theTable->offset();

        // Read PC+8
        masm.ma_mov(pc, scratch);

        // ARM scratch register is required by ma_sub.
        ScratchRegisterScope arm_scratch(*this);

        // Compute the absolute table base pointer into `scratch`, offset by 8
        // to account for the fact that ma_mov read PC+8.
        masm.ma_sub(Imm32(offset + 8), scratch, arm_scratch);

        // Jump indirect via table element.
        masm.ma_ldr(DTRAddr(scratch, DtrRegImmShift(switchValue, LSL, 2)), pc, Offset,
                    Assembler::Always);
#else
        MOZ_CRASH("BaseCompiler platform hook: tableSwitch");
#endif
    }

    RegI32 captureReturnedI32() {
        RegI32 rv = RegI32(ReturnReg);
        MOZ_ASSERT(isAvailable(rv));
        needI32(rv);
        return rv;
    }

    RegI64 captureReturnedI64() {
        RegI64 rv = RegI64(ReturnReg64);
        MOZ_ASSERT(isAvailable(rv));
        needI64(rv);
        return rv;
    }

    RegF32 captureReturnedF32(const FunctionCall& call) {
        RegF32 rv = RegF32(ReturnFloat32Reg);
        MOZ_ASSERT(isAvailable(rv));
        needF32(rv);
#if defined(JS_CODEGEN_ARM)
        if (call.usesSystemAbi && !call.hardFP)
            masm.ma_vxfer(r0, rv);
#endif
        return rv;
    }

    RegF64 captureReturnedF64(const FunctionCall& call) {
        RegF64 rv = RegF64(ReturnDoubleReg);
        MOZ_ASSERT(isAvailable(rv));
        needF64(rv);
#if defined(JS_CODEGEN_ARM)
        if (call.usesSystemAbi && !call.hardFP)
            masm.ma_vxfer(r0, r1, rv);
#endif
        return rv;
    }

    void returnCleanup(bool popStack) {
        if (popStack)
            popStackBeforeBranch(controlOutermost().framePushed);
        masm.jump(&returnLabel_);
    }

    void pop2xI32ForIntMulDiv(RegI32* r0, RegI32* r1) {
#if defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_X64)
        // srcDest must be eax, and edx will be clobbered.
        need2xI32(specific_eax, specific_edx);
        *r1 = popI32();
        *r0 = popI32ToSpecific(specific_eax);
        freeI32(specific_edx);
#else
        pop2xI32(r0, r1);
#endif
    }

    void pop2xI64ForIntDiv(RegI64* r0, RegI64* r1) {
#ifdef JS_CODEGEN_X64
        // srcDest must be rax, and rdx will be clobbered.
        need2xI64(specific_rax, specific_rdx);
        *r1 = popI64();
        *r0 = popI64ToSpecific(specific_rax);
        freeI64(specific_rdx);
#else
        pop2xI64(r0, r1);
#endif
    }

    void checkDivideByZeroI32(RegI32 rhs, RegI32 srcDest, Label* done) {
        masm.branchTest32(Assembler::Zero, rhs, rhs, trap(Trap::IntegerDivideByZero));
    }

    void checkDivideByZeroI64(RegI64 r) {
        ScratchI32 scratch(*this);
        masm.branchTest64(Assembler::Zero, r, r, scratch, trap(Trap::IntegerDivideByZero));
    }

    void checkDivideSignedOverflowI32(RegI32 rhs, RegI32 srcDest, Label* done, bool zeroOnOverflow) {
        Label notMin;
        masm.branch32(Assembler::NotEqual, srcDest, Imm32(INT32_MIN), &notMin);
        if (zeroOnOverflow) {
            masm.branch32(Assembler::NotEqual, rhs, Imm32(-1), &notMin);
            masm.move32(Imm32(0), srcDest);
            masm.jump(done);
        } else {
            masm.branch32(Assembler::Equal, rhs, Imm32(-1), trap(Trap::IntegerOverflow));
        }
        masm.bind(&notMin);
    }

    void checkDivideSignedOverflowI64(RegI64 rhs, RegI64 srcDest, Label* done, bool zeroOnOverflow) {
        Label notmin;
        masm.branch64(Assembler::NotEqual, srcDest, Imm64(INT64_MIN), &notmin);
        masm.branch64(Assembler::NotEqual, rhs, Imm64(-1), &notmin);
        if (zeroOnOverflow) {
            masm.xor64(srcDest, srcDest);
            masm.jump(done);
        } else {
            masm.jump(trap(Trap::IntegerOverflow));
        }
        masm.bind(&notmin);
    }

#ifndef INT_DIV_I64_CALLOUT
    void quotientI64(RegI64 rhs, RegI64 srcDest, IsUnsigned isUnsigned,
                     bool isConst, int64_t c)
    {
        Label done;

        if (!isConst || c == 0)
            checkDivideByZeroI64(rhs);

        if (!isUnsigned && (!isConst || c == -1))
            checkDivideSignedOverflowI64(rhs, srcDest, &done, ZeroOnOverflow(false));

# if defined(JS_CODEGEN_X64)
        // The caller must set up the following situation.
        MOZ_ASSERT(srcDest.reg == rax);
        MOZ_ASSERT(isAvailable(rdx));
        if (isUnsigned) {
            masm.xorq(rdx, rdx);
            masm.udivq(rhs.reg);
        } else {
            masm.cqo();
            masm.idivq(rhs.reg);
        }
# else
        MOZ_CRASH("BaseCompiler platform hook: quotientI64");
# endif
        masm.bind(&done);
    }

    void remainderI64(RegI64 rhs, RegI64 srcDest, IsUnsigned isUnsigned,
                      bool isConst, int64_t c)
    {
        Label done;

        if (!isConst || c == 0)
            checkDivideByZeroI64(rhs);

        if (!isUnsigned && (!isConst || c == -1))
            checkDivideSignedOverflowI64(rhs, srcDest, &done, ZeroOnOverflow(true));

# if defined(JS_CODEGEN_X64)
        // The caller must set up the following situation.
        MOZ_ASSERT(srcDest.reg == rax);
        MOZ_ASSERT(isAvailable(rdx));

        if (isUnsigned) {
            masm.xorq(rdx, rdx);
            masm.udivq(rhs.reg);
        } else {
            masm.cqo();
            masm.idivq(rhs.reg);
        }
        masm.movq(rdx, rax);
# else
        MOZ_CRASH("BaseCompiler platform hook: remainderI64");
# endif
        masm.bind(&done);
    }
#endif // INT_DIV_I64_CALLOUT

    void pop2xI32ForShiftOrRotate(RegI32* r0, RegI32* r1) {
#if defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_X64)
        *r1 = popI32(specific_ecx);
        *r0 = popI32();
#else
        pop2xI32(r0, r1);
#endif
    }

    void pop2xI64ForShiftOrRotate(RegI64* r0, RegI64* r1) {
#if defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_X64)
        needI32(specific_ecx);
        *r1 = widenI32(specific_ecx);
        *r1 = popI64ToSpecific(*r1);
        *r0 = popI64();
#else
        pop2xI64(r0, r1);
#endif
    }

    bool rotate64NeedsTemp() const {
#if defined(JS_CODEGEN_X86)
        return true;
#else
        return false;
#endif
    }

    void maskShiftCount32(RegI32 r) {
#if defined(JS_CODEGEN_ARM)
        masm.and32(Imm32(31), r);
#endif
    }

    bool popcnt32NeedsTemp() const {
#if defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_X64)
        return !AssemblerX86Shared::HasPOPCNT();
#elif defined(JS_CODEGEN_ARM)
        return true;
#else
        MOZ_CRASH("BaseCompiler platform hook: popcnt32NeedsTemp");
#endif
    }

    bool popcnt64NeedsTemp() const {
#if defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_X64)
        return !AssemblerX86Shared::HasPOPCNT();
#elif defined(JS_CODEGEN_ARM)
        return true;
#else
        MOZ_CRASH("BaseCompiler platform hook: popcnt64NeedsTemp");
#endif
    }

    void reinterpretI64AsF64(RegI64 src, RegF64 dest) {
#if defined(JS_CODEGEN_X64)
        masm.vmovq(src.reg, dest);
#elif defined(JS_CODEGEN_X86)
        masm.Push(src.high);
        masm.Push(src.low);
        masm.vmovq(Operand(esp, 0), dest);
        masm.freeStack(sizeof(uint64_t));
#elif defined(JS_CODEGEN_ARM)
        masm.ma_vxfer(src.low, src.high, dest);
#else
        MOZ_CRASH("BaseCompiler platform hook: reinterpretI64AsF64");
#endif
    }

    void reinterpretF64AsI64(RegF64 src, RegI64 dest) {
#if defined(JS_CODEGEN_X64)
        masm.vmovq(src, dest.reg);
#elif defined(JS_CODEGEN_X86)
        masm.reserveStack(sizeof(uint64_t));
        masm.vmovq(src, Operand(esp, 0));
        masm.Pop(dest.low);
        masm.Pop(dest.high);
#elif defined(JS_CODEGEN_ARM)
        masm.ma_vxfer(src, dest.low, dest.high);
#else
        MOZ_CRASH("BaseCompiler platform hook: reinterpretF64AsI64");
#endif
    }

    void wrapI64ToI32(RegI64 src, RegI32 dest) {
#if defined(JS_CODEGEN_X64)
        // movl clears the high bits if the two registers are the same.
        masm.movl(src.reg, dest);
#elif defined(JS_NUNBOX32)
        if (src.low != dest)
            masm.move32(src.low, dest);
#else
        MOZ_CRASH("BaseCompiler platform hook: wrapI64ToI32");
#endif
    }

    RegI64 popI32ForSignExtendI64() {
#if defined(JS_CODEGEN_X86)
        need2xI32(specific_edx, specific_eax);
        RegI32 r0 = popI32ToSpecific(specific_eax);
        RegI64 x0 = RegI64(Register64(specific_edx, specific_eax));
        (void)r0;               // x0 is the widening of r0
#else
        RegI32 r0 = popI32();
        RegI64 x0 = widenI32(r0);
#endif
        return x0;
    }

    void signExtendI32ToI64(RegI32 src, RegI64 dest) {
#if defined(JS_CODEGEN_X64)
        masm.movslq(src, dest.reg);
#elif defined(JS_CODEGEN_X86)
        MOZ_ASSERT(dest.low == src);
        MOZ_ASSERT(dest.low == eax);
        MOZ_ASSERT(dest.high == edx);
        masm.cdq();
#elif defined(JS_CODEGEN_ARM)
        masm.ma_mov(src, dest.low);
        masm.ma_asr(Imm32(31), src, dest.high);
#else
        MOZ_CRASH("BaseCompiler platform hook: signExtendI32ToI64");
#endif
    }

    void extendU32ToI64(RegI32 src, RegI64 dest) {
#if defined(JS_CODEGEN_X64)
        masm.movl(src, dest.reg);
#elif defined(JS_NUNBOX32)
        if (src != dest.low)
            masm.move32(src, dest.low);
        masm.move32(Imm32(0), dest.high);
#else
        MOZ_CRASH("BaseCompiler platform hook: extendU32ToI64");
#endif
    }

    class OutOfLineTruncateF32OrF64ToI32 : public OutOfLineCode
    {
        AnyReg src;
        RegI32 dest;
        bool isUnsigned;
        BytecodeOffset off;

      public:
        OutOfLineTruncateF32OrF64ToI32(AnyReg src, RegI32 dest, bool isUnsigned, BytecodeOffset off)
          : src(src),
            dest(dest),
            isUnsigned(isUnsigned),
            off(off)
        {}

        virtual void generate(MacroAssembler& masm) {
            bool isFloat = src.tag == AnyReg::F32;
            FloatRegister fsrc = isFloat ? static_cast<FloatRegister>(src.f32())
                                         : static_cast<FloatRegister>(src.f64());
#if defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_X64)
            if (isFloat)
                masm.outOfLineWasmTruncateFloat32ToInt32(fsrc, isUnsigned, off, rejoin());
            else
                masm.outOfLineWasmTruncateDoubleToInt32(fsrc, isUnsigned, off, rejoin());
#elif defined(JS_CODEGEN_ARM)
            masm.outOfLineWasmTruncateToIntCheck(fsrc,
                                                 isFloat ? MIRType::Float32 : MIRType::Double,
                                                 MIRType::Int32, isUnsigned, rejoin(), off);
#else
            (void)isUnsigned;
            (void)off;
            (void)isFloat;
            (void)fsrc;
            MOZ_CRASH("BaseCompiler platform hook: OutOfLineTruncateF32OrF64ToI32 wasm");
#endif
        }
    };

    MOZ_MUST_USE bool truncateF32ToI32(RegF32 src, RegI32 dest, bool isUnsigned) {
        BytecodeOffset off = bytecodeOffset();
        OutOfLineCode* ool;
#if defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_ARM)
        ool = new(alloc_) OutOfLineTruncateF32OrF64ToI32(AnyReg(src), dest, isUnsigned, off);
        ool = addOutOfLineCode(ool);
        if (!ool)
            return false;
        if (isUnsigned)
            masm.wasmTruncateFloat32ToUInt32(src, dest, ool->entry());
        else
            masm.wasmTruncateFloat32ToInt32(src, dest, ool->entry());
#else
        (void)off;
        MOZ_CRASH("BaseCompiler platform hook: truncateF32ToI32 wasm");
#endif
        masm.bind(ool->rejoin());
        return true;
    }

    MOZ_MUST_USE bool truncateF64ToI32(RegF64 src, RegI32 dest, bool isUnsigned) {
        BytecodeOffset off = bytecodeOffset();
        OutOfLineCode* ool;
#if defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_ARM)
        ool = new(alloc_) OutOfLineTruncateF32OrF64ToI32(AnyReg(src), dest, isUnsigned, off);
        ool = addOutOfLineCode(ool);
        if (!ool)
            return false;
        if (isUnsigned)
            masm.wasmTruncateDoubleToUInt32(src, dest, ool->entry());
        else
            masm.wasmTruncateDoubleToInt32(src, dest, ool->entry());
#else
        (void)off;
        MOZ_CRASH("BaseCompiler platform hook: truncateF64ToI32 wasm");
#endif
        masm.bind(ool->rejoin());
        return true;
    }

    // This does not generate a value; if the truncation failed then it traps.

    class OutOfLineTruncateCheckF32OrF64ToI64 : public OutOfLineCode
    {
        AnyReg src;
        bool isUnsigned;
        BytecodeOffset off;

      public:
        OutOfLineTruncateCheckF32OrF64ToI64(AnyReg src, bool isUnsigned, BytecodeOffset off)
          : src(src),
            isUnsigned(isUnsigned),
            off(off)
        {}

        virtual void generate(MacroAssembler& masm) {
#if defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_X64)
            if (src.tag == AnyReg::F32)
                masm.outOfLineWasmTruncateFloat32ToInt64(src.f32(), isUnsigned, off, rejoin());
            else if (src.tag == AnyReg::F64)
                masm.outOfLineWasmTruncateDoubleToInt64(src.f64(), isUnsigned, off, rejoin());
            else
                MOZ_CRASH("unexpected type");
#elif defined(JS_CODEGEN_ARM)
            if (src.tag == AnyReg::F32)
                masm.outOfLineWasmTruncateToIntCheck(src.f32(), MIRType::Float32,
                                                     MIRType::Int64, isUnsigned, rejoin(), off);
            else if (src.tag == AnyReg::F64)
                masm.outOfLineWasmTruncateToIntCheck(src.f64(), MIRType::Double, MIRType::Int64,
                                                     isUnsigned, rejoin(), off);
            else
                MOZ_CRASH("unexpected type");
#else
            (void)src;
            (void)isUnsigned;
            (void)off;
            MOZ_CRASH("BaseCompiler platform hook: OutOfLineTruncateCheckF32OrF64ToI64");
#endif
        }
    };

#ifndef FLOAT_TO_I64_CALLOUT
    MOZ_MUST_USE bool truncateF32ToI64(RegF32 src, RegI64 dest, bool isUnsigned, RegF64 temp) {
# if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_X86)
        OutOfLineCode* ool =
            addOutOfLineCode(new (alloc_) OutOfLineTruncateCheckF32OrF64ToI64(AnyReg(src),
                                                                              isUnsigned,
                                                                              bytecodeOffset()));
        if (!ool)
            return false;
        if (isUnsigned)
            masm.wasmTruncateFloat32ToUInt64(src, dest, ool->entry(),
                                             ool->rejoin(), temp);
        else
            masm.wasmTruncateFloat32ToInt64(src, dest, ool->entry(),
                                            ool->rejoin(), temp);
# else
        MOZ_CRASH("BaseCompiler platform hook: truncateF32ToI64");
# endif
        return true;
    }

    MOZ_MUST_USE bool truncateF64ToI64(RegF64 src, RegI64 dest, bool isUnsigned, RegF64 temp) {
# if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_X86)
        OutOfLineCode* ool =
            addOutOfLineCode(new (alloc_) OutOfLineTruncateCheckF32OrF64ToI64(AnyReg(src),
                                                                              isUnsigned,
                                                                              bytecodeOffset()));
        if (!ool)
            return false;
        if (isUnsigned)
            masm.wasmTruncateDoubleToUInt64(src, dest, ool->entry(),
                                            ool->rejoin(), temp);
        else
            masm.wasmTruncateDoubleToInt64(src, dest, ool->entry(),
                                           ool->rejoin(), temp);
# else
        MOZ_CRASH("BaseCompiler platform hook: truncateF64ToI64");
# endif
        return true;
    }
#endif // FLOAT_TO_I64_CALLOUT

#ifndef I64_TO_FLOAT_CALLOUT
    bool convertI64ToFloatNeedsTemp(ValType to, bool isUnsigned) const {
# if defined(JS_CODEGEN_X86)
        return isUnsigned &&
               ((to == ValType::F64 && AssemblerX86Shared::HasSSE3()) ||
               to == ValType::F32);
# else
        return isUnsigned;
# endif
    }

    void convertI64ToF32(RegI64 src, bool isUnsigned, RegF32 dest, RegI32 temp) {
# if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_X86)
        if (isUnsigned)
            masm.convertUInt64ToFloat32(src, dest, temp);
        else
            masm.convertInt64ToFloat32(src, dest);
# else
        MOZ_CRASH("BaseCompiler platform hook: convertI64ToF32");
# endif
    }

    void convertI64ToF64(RegI64 src, bool isUnsigned, RegF64 dest, RegI32 temp) {
# if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_X86)
        if (isUnsigned)
            masm.convertUInt64ToDouble(src, dest, temp);
        else
            masm.convertInt64ToDouble(src, dest);
# else
        MOZ_CRASH("BaseCompiler platform hook: convertI64ToF64");
# endif
    }
#endif // I64_TO_FLOAT_CALLOUT

    void cmp64Set(Assembler::Condition cond, RegI64 lhs, RegI64 rhs, RegI32 dest) {
#if defined(JS_CODEGEN_X64)
        masm.cmpq(rhs.reg, lhs.reg);
        masm.emitSet(cond, dest);
#elif defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_ARM)
        // TODO / OPTIMIZE (Bug 1316822): This is pretty branchy, we should be
        // able to do better.
        Label done, condTrue;
        masm.branch64(cond, lhs, rhs, &condTrue);
        masm.move32(Imm32(0), dest);
        masm.jump(&done);
        masm.bind(&condTrue);
        masm.move32(Imm32(1), dest);
        masm.bind(&done);
#else
        MOZ_CRASH("BaseCompiler platform hook: cmp64Set");
#endif
    }

    void eqz64(RegI64 src, RegI32 dest) {
#if defined(JS_CODEGEN_X64)
        masm.cmpq(Imm32(0), src.reg);
        masm.emitSet(Assembler::Equal, dest);
#elif defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_ARM)
        masm.or32(src.high, src.low);
        masm.cmp32(src.low, Imm32(0));
        masm.emitSet(Assembler::Equal, dest);
#else
        MOZ_CRASH("BaseCompiler platform hook: eqz64");
#endif
    }

    void unreachableTrap()
    {
        masm.jump(trap(Trap::Unreachable));
#ifdef DEBUG
        masm.breakpoint();
#endif
    }

    //////////////////////////////////////////////////////////////////////
    //
    // Global variable access.

    uint32_t globalToTlsOffset(uint32_t globalOffset) {
        return offsetof(TlsData, globalArea) + globalOffset;
    }

    void loadGlobalVarI32(unsigned globalDataOffset, RegI32 r)
    {
        ScratchI32 tmp(*this);
        masm.loadWasmTlsRegFromFrame(tmp);
        masm.load32(Address(tmp, globalToTlsOffset(globalDataOffset)), r);
    }

    void loadGlobalVarI64(unsigned globalDataOffset, RegI64 r)
    {
        ScratchI32 tmp(*this);
        masm.loadWasmTlsRegFromFrame(tmp);
        masm.load64(Address(tmp, globalToTlsOffset(globalDataOffset)), r);
    }

    void loadGlobalVarF32(unsigned globalDataOffset, RegF32 r)
    {
        ScratchI32 tmp(*this);
        masm.loadWasmTlsRegFromFrame(tmp);
        masm.loadFloat32(Address(tmp, globalToTlsOffset(globalDataOffset)), r);
    }

    void loadGlobalVarF64(unsigned globalDataOffset, RegF64 r)
    {
        ScratchI32 tmp(*this);
        masm.loadWasmTlsRegFromFrame(tmp);
        masm.loadDouble(Address(tmp, globalToTlsOffset(globalDataOffset)), r);
    }

    void storeGlobalVarI32(unsigned globalDataOffset, RegI32 r)
    {
        ScratchI32 tmp(*this);
        masm.loadWasmTlsRegFromFrame(tmp);
        masm.store32(r, Address(tmp, globalToTlsOffset(globalDataOffset)));
    }

    void storeGlobalVarI64(unsigned globalDataOffset, RegI64 r)
    {
        ScratchI32 tmp(*this);
        masm.loadWasmTlsRegFromFrame(tmp);
        masm.store64(r, Address(tmp, globalToTlsOffset(globalDataOffset)));
    }

    void storeGlobalVarF32(unsigned globalDataOffset, RegF32 r)
    {
        ScratchI32 tmp(*this);
        masm.loadWasmTlsRegFromFrame(tmp);
        masm.storeFloat32(r, Address(tmp, globalToTlsOffset(globalDataOffset)));
    }

    void storeGlobalVarF64(unsigned globalDataOffset, RegF64 r)
    {
        ScratchI32 tmp(*this);
        masm.loadWasmTlsRegFromFrame(tmp);
        masm.storeDouble(r, Address(tmp, globalToTlsOffset(globalDataOffset)));
    }

    //////////////////////////////////////////////////////////////////////
    //
    // Heap access.

    void bceCheckLocal(MemoryAccessDesc* access, uint32_t local, bool* omitBoundsCheck) {
        if (local >= sizeof(BCESet)*8)
            return;

        if ((bceSafe_ & (BCESet(1) << local)) && access->offset() < wasm::OffsetGuardLimit)
            *omitBoundsCheck = true;

        // The local becomes safe even if the offset is beyond the guard limit.
        bceSafe_ |= (BCESet(1) << local);
    }

    void bceLocalIsUpdated(uint32_t local) {
        if (local >= sizeof(BCESet)*8)
            return;

        bceSafe_ &= ~(BCESet(1) << local);
    }

    void checkOffset(MemoryAccessDesc* access, RegI32 ptr) {
        if (access->offset() >= OffsetGuardLimit) {
            masm.branchAdd32(Assembler::CarrySet, Imm32(access->offset()), ptr,
                             trap(Trap::OutOfBounds));
            access->clearOffset();
        }
    }

    // This is the temp register passed as the last argument to load()
    MOZ_MUST_USE size_t loadTemps(MemoryAccessDesc& access) {
#if defined(JS_CODEGEN_ARM)
        if (IsUnaligned(access)) {
            switch (access.type()) {
              case Scalar::Float32:
                return 2;
              case Scalar::Float64:
                return 3;
              default:
                return 1;
            }
        }
        return 0;
#else
        return 0;
#endif
    }

    MOZ_MUST_USE bool needTlsForAccess(bool omitBoundsCheck) {
#if defined(JS_CODEGEN_ARM)
        return !omitBoundsCheck;
#elif defined(JS_CODEGEN_X86)
        return true;
#else
        return false;
#endif
    }

    // ptr and dest may be the same iff dest is I32.
    // This may destroy ptr even if ptr and dest are not the same.
    MOZ_MUST_USE bool load(MemoryAccessDesc* access, RegI32 tls, RegI32 ptr, bool omitBoundsCheck,
                           AnyReg dest, RegI32 tmp1, RegI32 tmp2, RegI32 tmp3)
    {
        checkOffset(access, ptr);

#ifdef WASM_HUGE_MEMORY
        // We have HeapReg and no bounds checking and need load neither
        // memoryBase nor boundsCheckLimit from tls.
        MOZ_ASSERT(tls == invalidI32());
#endif
#ifdef JS_CODEGEN_ARM
        // We have HeapReg on ARM and don't need to load the memoryBase from tls.
        MOZ_ASSERT_IF(omitBoundsCheck, tls == invalidI32());
#endif

#ifndef WASM_HUGE_MEMORY
        if (!omitBoundsCheck) {
            masm.wasmBoundsCheck(Assembler::AboveOrEqual, ptr,
                                 Address(tls, offsetof(TlsData, boundsCheckLimit)),
                                 trap(Trap::OutOfBounds));
        }
#endif

#if defined(JS_CODEGEN_X64)
        Operand srcAddr(HeapReg, ptr, TimesOne, access->offset());

        if (dest.tag == AnyReg::I64)
            masm.wasmLoadI64(*access, srcAddr, dest.i64());
        else
            masm.wasmLoad(*access, srcAddr, dest.any());
#elif defined(JS_CODEGEN_X86)
        masm.addPtr(Address(tls, offsetof(TlsData, memoryBase)), ptr);
        Operand srcAddr(ptr, access->offset());

        if (dest.tag == AnyReg::I64) {
            MOZ_ASSERT(dest.i64() == abiReturnRegI64);
            masm.wasmLoadI64(*access, srcAddr, dest.i64());
        } else {
            bool byteRegConflict = access->byteSize() == 1 && !singleByteRegs_.has(dest.i32());
            AnyRegister out = byteRegConflict ? AnyRegister(ScratchRegX86) : dest.any();

            masm.wasmLoad(*access, srcAddr, out);

            if (byteRegConflict)
                masm.mov(ScratchRegX86, dest.i32());
        }
#elif defined(JS_CODEGEN_ARM)
        if (IsUnaligned(*access)) {
            switch (dest.tag) {
              case AnyReg::I64:
                masm.wasmUnalignedLoadI64(*access, HeapReg, ptr, ptr, dest.i64(), tmp1);
                break;
              case AnyReg::F32:
                masm.wasmUnalignedLoadFP(*access, HeapReg, ptr, ptr, dest.f32(), tmp1, tmp2,
                                         Register::Invalid());
                break;
              case AnyReg::F64:
                masm.wasmUnalignedLoadFP(*access, HeapReg, ptr, ptr, dest.f64(), tmp1, tmp2, tmp3);
                break;
              default:
                masm.wasmUnalignedLoad(*access, HeapReg, ptr, ptr, dest.i32(), tmp1);
                break;
            }
        } else {
            if (dest.tag == AnyReg::I64)
                masm.wasmLoadI64(*access, HeapReg, ptr, ptr, dest.i64());
            else
                masm.wasmLoad(*access, HeapReg, ptr, ptr, dest.any());
        }
#else
        MOZ_CRASH("BaseCompiler platform hook: load");
#endif

        return true;
    }

    MOZ_MUST_USE size_t storeTemps(const MemoryAccessDesc& access, ValType srcType) {
#if defined(JS_CODEGEN_ARM)
        if (IsUnaligned(access) && srcType != ValType::I32)
            return 1;
#endif
        return 0;
    }

    // ptr and src must not be the same register.
    // This may destroy ptr and src.
    MOZ_MUST_USE bool store(MemoryAccessDesc* access, RegI32 tls, RegI32 ptr, bool omitBoundsCheck,
                            AnyReg src, RegI32 tmp)
    {
        checkOffset(access, ptr);

#ifdef WASM_HUGE_MEMORY
        // We have HeapReg and no bounds checking and need load neither
        // memoryBase nor boundsCheckLimit from tls.
        MOZ_ASSERT(tls == invalidI32());
#endif
#ifdef JS_CODEGEN_ARM
        // We have HeapReg on ARM and don't need to load the memoryBase from tls.
        MOZ_ASSERT_IF(omitBoundsCheck, tls == invalidI32());
#endif

#ifndef WASM_HUGE_MEMORY
        if (!omitBoundsCheck) {
            masm.wasmBoundsCheck(Assembler::AboveOrEqual, ptr,
                                 Address(tls, offsetof(TlsData, boundsCheckLimit)),
                                 trap(Trap::OutOfBounds));
        }
#endif

        // Emit the store
#if defined(JS_CODEGEN_X64)
        MOZ_ASSERT(tmp == Register::Invalid());
        Operand dstAddr(HeapReg, ptr, TimesOne, access->offset());

        masm.wasmStore(*access, src.any(), dstAddr);
#elif defined(JS_CODEGEN_X86)
        MOZ_ASSERT(tmp == Register::Invalid());
        masm.addPtr(Address(tls, offsetof(TlsData, memoryBase)), ptr);
        Operand dstAddr(ptr, access->offset());

        if (access->type() == Scalar::Int64) {
            masm.wasmStoreI64(*access, src.i64(), dstAddr);
        } else {
            AnyRegister value;
            if (src.tag == AnyReg::I64) {
                if (access->byteSize() == 1 && !singleByteRegs_.has(src.i64().low)) {
                    masm.mov(src.i64().low, ScratchRegX86);
                    value = AnyRegister(ScratchRegX86);
                } else {
                    value = AnyRegister(src.i64().low);
                }
            } else if (access->byteSize() == 1 && !singleByteRegs_.has(src.i32())) {
                masm.mov(src.i32(), ScratchRegX86);
                value = AnyRegister(ScratchRegX86);
            } else {
                value = src.any();
            }

            masm.wasmStore(*access, value, dstAddr);
        }
#elif defined(JS_CODEGEN_ARM)
        if (IsUnaligned(*access)) {
            switch (src.tag) {
              case AnyReg::I64:
                masm.wasmUnalignedStoreI64(*access, src.i64(), HeapReg, ptr, ptr, tmp);
                break;
              case AnyReg::F32:
                masm.wasmUnalignedStoreFP(*access, src.f32(), HeapReg, ptr, ptr, tmp);
                break;
              case AnyReg::F64:
                masm.wasmUnalignedStoreFP(*access, src.f64(), HeapReg, ptr, ptr, tmp);
                break;
              default:
                MOZ_ASSERT(tmp == Register::Invalid());
                masm.wasmUnalignedStore(*access, src.i32(), HeapReg, ptr, ptr);
                break;
            }
        } else {
            MOZ_ASSERT(tmp == Register::Invalid());
            if (access->type() == Scalar::Int64)
                masm.wasmStoreI64(*access, src.i64(), HeapReg, ptr, ptr);
            else if (src.tag == AnyReg::I64)
                masm.wasmStore(*access, AnyRegister(src.i64().low), HeapReg, ptr, ptr);
            else
                masm.wasmStore(*access, src.any(), HeapReg, ptr, ptr);
        }
#else
        MOZ_CRASH("BaseCompiler platform hook: store");
#endif

        return true;
    }

    MOZ_MUST_USE bool
    supportsRoundInstruction(RoundingMode mode)
    {
#if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_X86)
        return Assembler::HasRoundInstruction(mode);
#else
        return false;
#endif
    }

    void
    roundF32(RoundingMode roundingMode, RegF32 f0)
    {
#if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_X86)
        masm.vroundss(Assembler::ToX86RoundingMode(roundingMode), f0, f0, f0);
#else
        MOZ_CRASH("NYI");
#endif
    }

    void
    roundF64(RoundingMode roundingMode, RegF64 f0)
    {
#if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_X86)
        masm.vroundsd(Assembler::ToX86RoundingMode(roundingMode), f0, f0, f0);
#else
        MOZ_CRASH("NYI");
#endif
    }

    ////////////////////////////////////////////////////////////

    // Generally speaking, ABOVE this point there should be no value
    // stack manipulation (calls to popI32 etc).

    // Generally speaking, BELOW this point there should be no
    // platform dependencies.  We make an exception for x86 register
    // targeting, which is not too hard to keep clean.

    ////////////////////////////////////////////////////////////
    //
    // Sundry wrappers.

    void pop2xI32(RegI32* r0, RegI32* r1) {
        *r1 = popI32();
        *r0 = popI32();
    }

    RegI32 popI32ToSpecific(RegI32 specific) {
        freeI32(specific);
        return popI32(specific);
    }

    void pop2xI64(RegI64* r0, RegI64* r1) {
        *r1 = popI64();
        *r0 = popI64();
    }

    RegI64 popI64ToSpecific(RegI64 specific) {
        freeI64(specific);
        return popI64(specific);
    }

    void pop2xF32(RegF32* r0, RegF32* r1) {
        *r1 = popF32();
        *r0 = popF32();
    }

    void pop2xF64(RegF64* r0, RegF64* r1) {
        *r1 = popF64();
        *r0 = popF64();
    }

    RegI32 popMemoryAccess(MemoryAccessDesc* access, bool* omitBoundsCheck);

    ////////////////////////////////////////////////////////////
    //
    // Sundry helpers.

    uint32_t readCallSiteLineOrBytecode() {
        if (!func_.callSiteLineNums().empty())
            return func_.callSiteLineNums()[lastReadCallSite_++];
        return iter_.lastOpcodeOffset();
    }

    bool done() const {
        return iter_.done();
    }

    BytecodeOffset bytecodeOffset() const {
        return iter_.bytecodeOffset();
    }

    TrapDesc trap(Trap t) const {
        return TrapDesc(bytecodeOffset(), t, masm.framePushed());
    }

    ////////////////////////////////////////////////////////////
    //
    // Machinery for optimized conditional branches.
    //
    // To disable this optimization it is enough always to return false from
    // sniffConditionalControl{Cmp,Eqz}.

    struct BranchState {
        static const int32_t NoPop = ~0;

        union {
            struct {
                RegI32 lhs;
                RegI32 rhs;
                int32_t imm;
                bool rhsImm;
            } i32;
            struct {
                RegI64 lhs;
                RegI64 rhs;
                int64_t imm;
                bool rhsImm;
            } i64;
            struct {
                RegF32 lhs;
                RegF32 rhs;
            } f32;
            struct {
                RegF64 lhs;
                RegF64 rhs;
            } f64;
        };

        Label* const label;        // The target of the branch, never NULL
        const int32_t framePushed; // Either NoPop, or the value to pop to along the taken edge
        const bool invertBranch;   // If true, invert the sense of the branch
        const ExprType resultType; // The result propagated along the edges, or Void

        explicit BranchState(Label* label, int32_t framePushed = NoPop,
                             uint32_t invertBranch = false, ExprType resultType = ExprType::Void)
          : label(label),
            framePushed(framePushed),
            invertBranch(invertBranch),
            resultType(resultType)
        {}
    };

    void setLatentCompare(Assembler::Condition compareOp, ValType operandType) {
        latentOp_ = LatentOp::Compare;
        latentType_ = operandType;
        latentIntCmp_ = compareOp;
    }

    void setLatentCompare(Assembler::DoubleCondition compareOp, ValType operandType) {
        latentOp_ = LatentOp::Compare;
        latentType_ = operandType;
        latentDoubleCmp_ = compareOp;
    }

    void setLatentEqz(ValType operandType) {
        latentOp_ = LatentOp::Eqz;
        latentType_ = operandType;
    }

    void resetLatentOp() {
        latentOp_ = LatentOp::None;
    }

    void branchTo(Assembler::DoubleCondition c, RegF64 lhs, RegF64 rhs, Label* l) {
        masm.branchDouble(c, lhs, rhs, l);
    }

    void branchTo(Assembler::DoubleCondition c, RegF32 lhs, RegF32 rhs, Label* l) {
        masm.branchFloat(c, lhs, rhs, l);
    }

    void branchTo(Assembler::Condition c, RegI32 lhs, RegI32 rhs, Label* l) {
        masm.branch32(c, lhs, rhs, l);
    }

    void branchTo(Assembler::Condition c, RegI32 lhs, Imm32 rhs, Label* l) {
        masm.branch32(c, lhs, rhs, l);
    }

    void branchTo(Assembler::Condition c, RegI64 lhs, RegI64 rhs, Label* l) {
        masm.branch64(c, lhs, rhs, l);
    }

    void branchTo(Assembler::Condition c, RegI64 lhs, Imm64 rhs, Label* l) {
        masm.branch64(c, lhs, rhs, l);
    }

    // Emit a conditional branch that optionally and optimally cleans up the CPU
    // stack before we branch.
    //
    // Cond is either Assembler::Condition or Assembler::DoubleCondition.
    //
    // Lhs is Register, Register64, or FloatRegister.
    //
    // Rhs is either the same as Lhs, or an immediate expression compatible with
    // Lhs "when applicable".

    template<typename Cond, typename Lhs, typename Rhs>
    void jumpConditionalWithJoinReg(BranchState* b, Cond cond, Lhs lhs, Rhs rhs)
    {
        AnyReg r = popJoinRegUnlessVoid(b->resultType);

        if (b->framePushed != BranchState::NoPop && willPopStackBeforeBranch(b->framePushed)) {
            Label notTaken;
            branchTo(b->invertBranch ? cond : Assembler::InvertCondition(cond), lhs, rhs, &notTaken);
            popStackBeforeBranch(b->framePushed);
            masm.jump(b->label);
            masm.bind(&notTaken);
        } else {
            branchTo(b->invertBranch ? Assembler::InvertCondition(cond) : cond, lhs, rhs, b->label);
        }

        pushJoinRegUnlessVoid(r);
    }

    // sniffConditionalControl{Cmp,Eqz} may modify the latentWhatever_ state in
    // the BaseCompiler so that a subsequent conditional branch can be compiled
    // optimally.  emitBranchSetup() and emitBranchPerform() will consume that
    // state.  If the latter methods are not called because deadCode_ is true
    // then the compiler MUST instead call resetLatentOp() to reset the state.

    template<typename Cond> bool sniffConditionalControlCmp(Cond compareOp, ValType operandType);
    bool sniffConditionalControlEqz(ValType operandType);
    void emitBranchSetup(BranchState* b);
    void emitBranchPerform(BranchState* b);

    //////////////////////////////////////////////////////////////////////

    MOZ_MUST_USE bool emitBody();
    MOZ_MUST_USE bool emitBlock();
    MOZ_MUST_USE bool emitLoop();
    MOZ_MUST_USE bool emitIf();
    MOZ_MUST_USE bool emitElse();
    MOZ_MUST_USE bool emitEnd();
    MOZ_MUST_USE bool emitBr();
    MOZ_MUST_USE bool emitBrIf();
    MOZ_MUST_USE bool emitBrTable();
    MOZ_MUST_USE bool emitDrop();
    MOZ_MUST_USE bool emitReturn();
    MOZ_MUST_USE bool emitCallArgs(const ValTypeVector& args, FunctionCall& baselineCall);
    MOZ_MUST_USE bool emitCall();
    MOZ_MUST_USE bool emitCallIndirect();
    MOZ_MUST_USE bool emitUnaryMathBuiltinCall(SymbolicAddress callee, ValType operandType);
    MOZ_MUST_USE bool emitGetLocal();
    MOZ_MUST_USE bool emitSetLocal();
    MOZ_MUST_USE bool emitTeeLocal();
    MOZ_MUST_USE bool emitGetGlobal();
    MOZ_MUST_USE bool emitSetGlobal();
    MOZ_MUST_USE RegI32 maybeLoadTlsForAccess(bool omitBoundsCheck);
    MOZ_MUST_USE bool emitLoad(ValType type, Scalar::Type viewType);
    MOZ_MUST_USE bool emitStore(ValType resultType, Scalar::Type viewType);
    MOZ_MUST_USE bool emitSelect();

    // Mark these templates as inline to work around a compiler crash in
    // gcc 4.8.5 when compiling for linux64-opt.

    template<bool isSetLocal> MOZ_MUST_USE inline bool emitSetOrTeeLocal(uint32_t slot);

    void endBlock(ExprType type);
    void endLoop(ExprType type);
    void endIfThen();
    void endIfThenElse(ExprType type);

    void doReturn(ExprType returnType, bool popStack);
    void pushReturned(const FunctionCall& call, ExprType type);

    void emitCompareI32(Assembler::Condition compareOp, ValType compareType);
    void emitCompareI64(Assembler::Condition compareOp, ValType compareType);
    void emitCompareF32(Assembler::DoubleCondition compareOp, ValType compareType);
    void emitCompareF64(Assembler::DoubleCondition compareOp, ValType compareType);

    void emitAddI32();
    void emitAddI64();
    void emitAddF64();
    void emitAddF32();
    void emitSubtractI32();
    void emitSubtractI64();
    void emitSubtractF32();
    void emitSubtractF64();
    void emitMultiplyI32();
    void emitMultiplyI64();
    void emitMultiplyF32();
    void emitMultiplyF64();
    void emitQuotientI32();
    void emitQuotientU32();
    void emitRemainderI32();
    void emitRemainderU32();
#ifdef INT_DIV_I64_CALLOUT
    void emitDivOrModI64BuiltinCall(SymbolicAddress callee, ValType operandType);
#else
    void emitQuotientI64();
    void emitQuotientU64();
    void emitRemainderI64();
    void emitRemainderU64();
#endif
    void emitDivideF32();
    void emitDivideF64();
    void emitMinF32();
    void emitMaxF32();
    void emitMinF64();
    void emitMaxF64();
    void emitCopysignF32();
    void emitCopysignF64();
    void emitOrI32();
    void emitOrI64();
    void emitAndI32();
    void emitAndI64();
    void emitXorI32();
    void emitXorI64();
    void emitShlI32();
    void emitShlI64();
    void emitShrI32();
    void emitShrI64();
    void emitShrU32();
    void emitShrU64();
    void emitRotrI32();
    void emitRotrI64();
    void emitRotlI32();
    void emitRotlI64();
    void emitEqzI32();
    void emitEqzI64();
    void emitClzI32();
    void emitClzI64();
    void emitCtzI32();
    void emitCtzI64();
    void emitPopcntI32();
    void emitPopcntI64();
    void emitAbsF32();
    void emitAbsF64();
    void emitNegateF32();
    void emitNegateF64();
    void emitSqrtF32();
    void emitSqrtF64();
    template<bool isUnsigned> MOZ_MUST_USE bool emitTruncateF32ToI32();
    template<bool isUnsigned> MOZ_MUST_USE bool emitTruncateF64ToI32();
#ifdef FLOAT_TO_I64_CALLOUT
    MOZ_MUST_USE bool emitConvertFloatingToInt64Callout(SymbolicAddress callee, ValType operandType,
                                                        ValType resultType);
#else
    template<bool isUnsigned> MOZ_MUST_USE bool emitTruncateF32ToI64();
    template<bool isUnsigned> MOZ_MUST_USE bool emitTruncateF64ToI64();
#endif
    void emitWrapI64ToI32();
    void emitExtendI32ToI64();
    void emitExtendU32ToI64();
    void emitReinterpretF32AsI32();
    void emitReinterpretF64AsI64();
    void emitConvertF64ToF32();
    void emitConvertI32ToF32();
    void emitConvertU32ToF32();
    void emitConvertF32ToF64();
    void emitConvertI32ToF64();
    void emitConvertU32ToF64();
#ifdef I64_TO_FLOAT_CALLOUT
    MOZ_MUST_USE bool emitConvertInt64ToFloatingCallout(SymbolicAddress callee, ValType operandType,
                                                        ValType resultType);
#else
    void emitConvertI64ToF32();
    void emitConvertU64ToF32();
    void emitConvertI64ToF64();
    void emitConvertU64ToF64();
#endif
    void emitReinterpretI32AsF32();
    void emitReinterpretI64AsF64();
    void emitRound(RoundingMode roundingMode, ValType operandType);
    MOZ_MUST_USE bool emitGrowMemory();
    MOZ_MUST_USE bool emitCurrentMemory();
};

void
BaseCompiler::emitAddI32()
{
    int32_t c;
    if (popConstI32(&c)) {
        RegI32 r = popI32();
        masm.add32(Imm32(c), r);
        pushI32(r);
    } else {
        RegI32 r0, r1;
        pop2xI32(&r0, &r1);
        masm.add32(r1, r0);
        freeI32(r1);
        pushI32(r0);
    }
}

void
BaseCompiler::emitAddI64()
{
    int64_t c;
    if (popConstI64(&c)) {
        RegI64 r = popI64();
        masm.add64(Imm64(c), r);
        pushI64(r);
    } else {
        RegI64 r0, r1;
        pop2xI64(&r0, &r1);
        masm.add64(r1, r0);
        freeI64(r1);
        pushI64(r0);
    }
}

void
BaseCompiler::emitAddF64()
{
    RegF64 r0, r1;
    pop2xF64(&r0, &r1);
    masm.addDouble(r1, r0);
    freeF64(r1);
    pushF64(r0);
}

void
BaseCompiler::emitAddF32()
{
    RegF32 r0, r1;
    pop2xF32(&r0, &r1);
    masm.addFloat32(r1, r0);
    freeF32(r1);
    pushF32(r0);
}

void
BaseCompiler::emitSubtractI32()
{
    int32_t c;
    if (popConstI32(&c)) {
        RegI32 r = popI32();
        masm.sub32(Imm32(c), r);
        pushI32(r);
    } else {
        RegI32 r0, r1;
        pop2xI32(&r0, &r1);
        masm.sub32(r1, r0);
        freeI32(r1);
        pushI32(r0);
    }
}

void
BaseCompiler::emitSubtractI64()
{
    int64_t c;
    if (popConstI64(&c)) {
        RegI64 r = popI64();
        masm.sub64(Imm64(c), r);
        pushI64(r);
    } else {
        RegI64 r0, r1;
        pop2xI64(&r0, &r1);
        masm.sub64(r1, r0);
        freeI64(r1);
        pushI64(r0);
    }
}

void
BaseCompiler::emitSubtractF32()
{
    RegF32 r0, r1;
    pop2xF32(&r0, &r1);
    masm.subFloat32(r1, r0);
    freeF32(r1);
    pushF32(r0);
}

void
BaseCompiler::emitSubtractF64()
{
    RegF64 r0, r1;
    pop2xF64(&r0, &r1);
    masm.subDouble(r1, r0);
    freeF64(r1);
    pushF64(r0);
}

void
BaseCompiler::emitMultiplyI32()
{
    RegI32 r0, r1;
    pop2xI32ForIntMulDiv(&r0, &r1);
    masm.mul32(r1, r0);
    freeI32(r1);
    pushI32(r0);
}

void
BaseCompiler::emitMultiplyI64()
{
    RegI64 r0, r1;
    RegI32 temp;
#if defined(JS_CODEGEN_X64)
    // srcDest must be rax, and rdx will be clobbered.
    need2xI64(specific_rax, specific_rdx);
    r1 = popI64();
    r0 = popI64ToSpecific(specific_rax);
    freeI64(specific_rdx);
#elif defined(JS_CODEGEN_X86)
    need2xI32(specific_eax, specific_edx);
    r1 = popI64();
    r0 = popI64ToSpecific(RegI64(Register64(specific_edx, specific_eax)));
    temp = needI32();
#else
    pop2xI64(&r0, &r1);
    temp = needI32();
#endif
    masm.mul64(r1, r0, temp);
    if (temp != Register::Invalid())
        freeI32(temp);
    freeI64(r1);
    pushI64(r0);
}

void
BaseCompiler::emitMultiplyF32()
{
    RegF32 r0, r1;
    pop2xF32(&r0, &r1);
    masm.mulFloat32(r1, r0);
    freeF32(r1);
    pushF32(r0);
}

void
BaseCompiler::emitMultiplyF64()
{
    RegF64 r0, r1;
    pop2xF64(&r0, &r1);
    masm.mulDouble(r1, r0);
    freeF64(r1);
    pushF64(r0);
}

void
BaseCompiler::emitQuotientI32()
{
    int32_t c;
    uint_fast8_t power;
    if (popConstPositivePowerOfTwoI32(&c, &power, 0)) {
        if (power != 0) {
            RegI32 r = popI32();
            Label positive;
            masm.branchTest32(Assembler::NotSigned, r, r, &positive);
            masm.add32(Imm32(c-1), r);
            masm.bind(&positive);

            masm.rshift32Arithmetic(Imm32(power & 31), r);
            pushI32(r);
        }
    } else {
        bool isConst = peekConstI32(&c);
        RegI32 r0, r1;
        pop2xI32ForIntMulDiv(&r0, &r1);

        Label done;
        if (!isConst || c == 0)
            checkDivideByZeroI32(r1, r0, &done);
        if (!isConst || c == -1)
            checkDivideSignedOverflowI32(r1, r0, &done, ZeroOnOverflow(false));
        masm.quotient32(r1, r0, IsUnsigned(false));
        masm.bind(&done);

        freeI32(r1);
        pushI32(r0);
    }
}

void
BaseCompiler::emitQuotientU32()
{
    int32_t c;
    uint_fast8_t power;
    if (popConstPositivePowerOfTwoI32(&c, &power, 0)) {
        if (power != 0) {
            RegI32 r = popI32();
            masm.rshift32(Imm32(power & 31), r);
            pushI32(r);
        }
    } else {
        bool isConst = peekConstI32(&c);
        RegI32 r0, r1;
        pop2xI32ForIntMulDiv(&r0, &r1);

        Label done;
        if (!isConst || c == 0)
            checkDivideByZeroI32(r1, r0, &done);
        masm.quotient32(r1, r0, IsUnsigned(true));
        masm.bind(&done);

        freeI32(r1);
        pushI32(r0);
    }
}

void
BaseCompiler::emitRemainderI32()
{
    int32_t c;
    uint_fast8_t power;
    if (popConstPositivePowerOfTwoI32(&c, &power, 1)) {
        RegI32 r = popI32();
        RegI32 temp = needI32();
        moveI32(r, temp);

        Label positive;
        masm.branchTest32(Assembler::NotSigned, temp, temp, &positive);
        masm.add32(Imm32(c-1), temp);
        masm.bind(&positive);

        masm.rshift32Arithmetic(Imm32(power & 31), temp);
        masm.lshift32(Imm32(power & 31), temp);
        masm.sub32(temp, r);
        freeI32(temp);

        pushI32(r);
    } else {
        bool isConst = peekConstI32(&c);
        RegI32 r0, r1;
        pop2xI32ForIntMulDiv(&r0, &r1);

        Label done;
        if (!isConst || c == 0)
            checkDivideByZeroI32(r1, r0, &done);
        if (!isConst || c == -1)
            checkDivideSignedOverflowI32(r1, r0, &done, ZeroOnOverflow(true));
        masm.remainder32(r1, r0, IsUnsigned(false));
        masm.bind(&done);

        freeI32(r1);
        pushI32(r0);
    }
}

void
BaseCompiler::emitRemainderU32()
{
    int32_t c;
    uint_fast8_t power;
    if (popConstPositivePowerOfTwoI32(&c, &power, 1)) {
        RegI32 r = popI32();
        masm.and32(Imm32(c-1), r);
        pushI32(r);
    } else {
        bool isConst = peekConstI32(&c);
        RegI32 r0, r1;
        pop2xI32ForIntMulDiv(&r0, &r1);

        Label done;
        if (!isConst || c == 0)
            checkDivideByZeroI32(r1, r0, &done);
        masm.remainder32(r1, r0, IsUnsigned(true));
        masm.bind(&done);

        freeI32(r1);
        pushI32(r0);
    }
}

#ifndef INT_DIV_I64_CALLOUT
void
BaseCompiler::emitQuotientI64()
{
# ifdef JS_PUNBOX64
    int64_t c;
    uint_fast8_t power;
    if (popConstPositivePowerOfTwoI64(&c, &power, 0)) {
        if (power != 0) {
            RegI64 r = popI64();
            Label positive;
            masm.branchTest64(Assembler::NotSigned, r, r, Register::Invalid(),
                              &positive);
            masm.add64(Imm32(c-1), r);
            masm.bind(&positive);

            masm.rshift64Arithmetic(Imm32(power & 63), r);
            pushI64(r);
        }
    } else {
        bool isConst = peekConstI64(&c);
        RegI64 r0, r1;
        pop2xI64ForIntDiv(&r0, &r1);
        quotientI64(r1, r0, IsUnsigned(false), isConst, c);
        freeI64(r1);
        pushI64(r0);
    }
# else
    MOZ_CRASH("BaseCompiler platform hook: emitQuotientI64");
# endif
}

void
BaseCompiler::emitQuotientU64()
{
# ifdef JS_PUNBOX64
    int64_t c;
    uint_fast8_t power;
    if (popConstPositivePowerOfTwoI64(&c, &power, 0)) {
        if (power != 0) {
            RegI64 r = popI64();
            masm.rshift64(Imm32(power & 63), r);
            pushI64(r);
        }
    } else {
        bool isConst = peekConstI64(&c);
        RegI64 r0, r1;
        pop2xI64ForIntDiv(&r0, &r1);
        quotientI64(r1, r0, IsUnsigned(true), isConst, c);
        freeI64(r1);
        pushI64(r0);
    }
# else
    MOZ_CRASH("BaseCompiler platform hook: emitQuotientU64");
# endif
}

void
BaseCompiler::emitRemainderI64()
{
# ifdef JS_PUNBOX64
    int64_t c;
    uint_fast8_t power;
    if (popConstPositivePowerOfTwoI64(&c, &power, 1)) {
        RegI64 r = popI64();
        RegI64 temp = needI64();
        moveI64(r, temp);

        Label positive;
        masm.branchTest64(Assembler::NotSigned, temp, temp,
                          Register::Invalid(), &positive);
        masm.add64(Imm64(c-1), temp);
        masm.bind(&positive);

        masm.rshift64Arithmetic(Imm32(power & 63), temp);
        masm.lshift64(Imm32(power & 63), temp);
        masm.sub64(temp, r);
        freeI64(temp);

        pushI64(r);
    } else {
        bool isConst = peekConstI64(&c);
        RegI64 r0, r1;
        pop2xI64ForIntDiv(&r0, &r1);
        remainderI64(r1, r0, IsUnsigned(false), isConst, c);
        freeI64(r1);
        pushI64(r0);
    }
# else
    MOZ_CRASH("BaseCompiler platform hook: emitRemainderI64");
# endif
}

void
BaseCompiler::emitRemainderU64()
{
# ifdef JS_PUNBOX64
    int64_t c;
    uint_fast8_t power;
    if (popConstPositivePowerOfTwoI64(&c, &power, 1)) {
        RegI64 r = popI64();
        masm.and64(Imm64(c-1), r);
        pushI64(r);
    } else {
        bool isConst = peekConstI64(&c);
        RegI64 r0, r1;
        pop2xI64ForIntDiv(&r0, &r1);
        remainderI64(r1, r0, IsUnsigned(true), isConst, c);
        freeI64(r1);
        pushI64(r0);
    }
# else
    MOZ_CRASH("BaseCompiler platform hook: emitRemainderU64");
# endif
}
#endif // INT_DIV_I64_CALLOUT

void
BaseCompiler::emitDivideF32()
{
    RegF32 r0, r1;
    pop2xF32(&r0, &r1);
    masm.divFloat32(r1, r0);
    freeF32(r1);
    pushF32(r0);
}

void
BaseCompiler::emitDivideF64()
{
    RegF64 r0, r1;
    pop2xF64(&r0, &r1);
    masm.divDouble(r1, r0);
    freeF64(r1);
    pushF64(r0);
}

void
BaseCompiler::emitMinF32()
{
    RegF32 r0, r1;
    pop2xF32(&r0, &r1);
    // Convert signaling NaN to quiet NaNs.
    //
    // TODO / OPTIMIZE (bug 1316824): Don't do this if one of the operands
    // is known to be a constant.
    ScratchF32 zero(*this);
    masm.loadConstantFloat32(0.f, zero);
    masm.subFloat32(zero, r0);
    masm.subFloat32(zero, r1);
    masm.minFloat32(r1, r0, HandleNaNSpecially(true));
    freeF32(r1);
    pushF32(r0);
}

void
BaseCompiler::emitMaxF32()
{
    RegF32 r0, r1;
    pop2xF32(&r0, &r1);
    // Convert signaling NaN to quiet NaNs.
    //
    // TODO / OPTIMIZE (bug 1316824): see comment in emitMinF32.
    ScratchF32 zero(*this);
    masm.loadConstantFloat32(0.f, zero);
    masm.subFloat32(zero, r0);
    masm.subFloat32(zero, r1);
    masm.maxFloat32(r1, r0, HandleNaNSpecially(true));
    freeF32(r1);
    pushF32(r0);
}

void
BaseCompiler::emitMinF64()
{
    RegF64 r0, r1;
    pop2xF64(&r0, &r1);
    // Convert signaling NaN to quiet NaNs.
    //
    // TODO / OPTIMIZE (bug 1316824): see comment in emitMinF32.
    ScratchF64 zero(*this);
    masm.loadConstantDouble(0, zero);
    masm.subDouble(zero, r0);
    masm.subDouble(zero, r1);
    masm.minDouble(r1, r0, HandleNaNSpecially(true));
    freeF64(r1);
    pushF64(r0);
}

void
BaseCompiler::emitMaxF64()
{
    RegF64 r0, r1;
    pop2xF64(&r0, &r1);
    // Convert signaling NaN to quiet NaNs.
    //
    // TODO / OPTIMIZE (bug 1316824): see comment in emitMinF32.
    ScratchF64 zero(*this);
    masm.loadConstantDouble(0, zero);
    masm.subDouble(zero, r0);
    masm.subDouble(zero, r1);
    masm.maxDouble(r1, r0, HandleNaNSpecially(true));
    freeF64(r1);
    pushF64(r0);
}

void
BaseCompiler::emitCopysignF32()
{
    RegF32 r0, r1;
    pop2xF32(&r0, &r1);
    RegI32 i0 = needI32();
    RegI32 i1 = needI32();
    masm.moveFloat32ToGPR(r0, i0);
    masm.moveFloat32ToGPR(r1, i1);
    masm.and32(Imm32(INT32_MAX), i0);
    masm.and32(Imm32(INT32_MIN), i1);
    masm.or32(i1, i0);
    masm.moveGPRToFloat32(i0, r0);
    freeI32(i0);
    freeI32(i1);
    freeF32(r1);
    pushF32(r0);
}

void
BaseCompiler::emitCopysignF64()
{
    RegF64 r0, r1;
    pop2xF64(&r0, &r1);
    RegI64 x0 = needI64();
    RegI64 x1 = needI64();
    reinterpretF64AsI64(r0, x0);
    reinterpretF64AsI64(r1, x1);
    masm.and64(Imm64(INT64_MAX), x0);
    masm.and64(Imm64(INT64_MIN), x1);
    masm.or64(x1, x0);
    reinterpretI64AsF64(x0, r0);
    freeI64(x0);
    freeI64(x1);
    freeF64(r1);
    pushF64(r0);
}

void
BaseCompiler::emitOrI32()
{
    int32_t c;
    if (popConstI32(&c)) {
        RegI32 r = popI32();
        masm.or32(Imm32(c), r);
        pushI32(r);
    } else {
        RegI32 r0, r1;
        pop2xI32(&r0, &r1);
        masm.or32(r1, r0);
        freeI32(r1);
        pushI32(r0);
    }
}

void
BaseCompiler::emitOrI64()
{
    int64_t c;
    if (popConstI64(&c)) {
        RegI64 r = popI64();
        masm.or64(Imm64(c), r);
        pushI64(r);
    } else {
        RegI64 r0, r1;
        pop2xI64(&r0, &r1);
        masm.or64(r1, r0);
        freeI64(r1);
        pushI64(r0);
    }
}

void
BaseCompiler::emitAndI32()
{
    int32_t c;
    if (popConstI32(&c)) {
        RegI32 r = popI32();
        masm.and32(Imm32(c), r);
        pushI32(r);
    } else {
        RegI32 r0, r1;
        pop2xI32(&r0, &r1);
        masm.and32(r1, r0);
        freeI32(r1);
        pushI32(r0);
    }
}

void
BaseCompiler::emitAndI64()
{
    int64_t c;
    if (popConstI64(&c)) {
        RegI64 r = popI64();
        masm.and64(Imm64(c), r);
        pushI64(r);
    } else {
        RegI64 r0, r1;
        pop2xI64(&r0, &r1);
        masm.and64(r1, r0);
        freeI64(r1);
        pushI64(r0);
    }
}

void
BaseCompiler::emitXorI32()
{
    int32_t c;
    if (popConstI32(&c)) {
        RegI32 r = popI32();
        masm.xor32(Imm32(c), r);
        pushI32(r);
    } else {
        RegI32 r0, r1;
        pop2xI32(&r0, &r1);
        masm.xor32(r1, r0);
        freeI32(r1);
        pushI32(r0);
    }
}

void
BaseCompiler::emitXorI64()
{
    int64_t c;
    if (popConstI64(&c)) {
        RegI64 r = popI64();
        masm.xor64(Imm64(c), r);
        pushI64(r);
    } else {
        RegI64 r0, r1;
        pop2xI64(&r0, &r1);
        masm.xor64(r1, r0);
        freeI64(r1);
        pushI64(r0);
    }
}

void
BaseCompiler::emitShlI32()
{
    int32_t c;
    if (popConstI32(&c)) {
        RegI32 r = popI32();
        masm.lshift32(Imm32(c & 31), r);
        pushI32(r);
    } else {
        RegI32 r0, r1;
        pop2xI32ForShiftOrRotate(&r0, &r1);
        maskShiftCount32(r1);
        masm.lshift32(r1, r0);
        freeI32(r1);
        pushI32(r0);
    }
}

void
BaseCompiler::emitShlI64()
{
    int64_t c;
    if (popConstI64(&c)) {
        RegI64 r = popI64();
        masm.lshift64(Imm32(c & 63), r);
        pushI64(r);
    } else {
        RegI64 r0, r1;
        pop2xI64ForShiftOrRotate(&r0, &r1);
        masm.lshift64(lowPart(r1), r0);
        freeI64(r1);
        pushI64(r0);
    }
}

void
BaseCompiler::emitShrI32()
{
    int32_t c;
    if (popConstI32(&c)) {
        RegI32 r = popI32();
        masm.rshift32Arithmetic(Imm32(c & 31), r);
        pushI32(r);
    } else {
        RegI32 r0, r1;
        pop2xI32ForShiftOrRotate(&r0, &r1);
        maskShiftCount32(r1);
        masm.rshift32Arithmetic(r1, r0);
        freeI32(r1);
        pushI32(r0);
    }
}

void
BaseCompiler::emitShrI64()
{
    int64_t c;
    if (popConstI64(&c)) {
        RegI64 r = popI64();
        masm.rshift64Arithmetic(Imm32(c & 63), r);
        pushI64(r);
    } else {
        RegI64 r0, r1;
        pop2xI64ForShiftOrRotate(&r0, &r1);
        masm.rshift64Arithmetic(lowPart(r1), r0);
        freeI64(r1);
        pushI64(r0);
    }
}

void
BaseCompiler::emitShrU32()
{
    int32_t c;
    if (popConstI32(&c)) {
        RegI32 r = popI32();
        masm.rshift32(Imm32(c & 31), r);
        pushI32(r);
    } else {
        RegI32 r0, r1;
        pop2xI32ForShiftOrRotate(&r0, &r1);
        maskShiftCount32(r1);
        masm.rshift32(r1, r0);
        freeI32(r1);
        pushI32(r0);
    }
}

void
BaseCompiler::emitShrU64()
{
    int64_t c;
    if (popConstI64(&c)) {
        RegI64 r = popI64();
        masm.rshift64(Imm32(c & 63), r);
        pushI64(r);
    } else {
        RegI64 r0, r1;
        pop2xI64ForShiftOrRotate(&r0, &r1);
        masm.rshift64(lowPart(r1), r0);
        freeI64(r1);
        pushI64(r0);
    }
}

void
BaseCompiler::emitRotrI32()
{
    int32_t c;
    if (popConstI32(&c)) {
        RegI32 r = popI32();
        masm.rotateRight(Imm32(c & 31), r, r);
        pushI32(r);
    } else {
        RegI32 r0, r1;
        pop2xI32ForShiftOrRotate(&r0, &r1);
        masm.rotateRight(r1, r0, r0);
        freeI32(r1);
        pushI32(r0);
    }
}

void
BaseCompiler::emitRotrI64()
{
    int64_t c;
    if (popConstI64(&c)) {
        RegI64 r = popI64();
        RegI32 temp;
        if (rotate64NeedsTemp())
            temp = needI32();
        masm.rotateRight64(Imm32(c & 63), r, r, temp);
        if (temp != Register::Invalid())
            freeI32(temp);
        pushI64(r);
    } else {
        RegI64 r0, r1;
        pop2xI64ForShiftOrRotate(&r0, &r1);
        masm.rotateRight64(lowPart(r1), r0, r0, maybeHighPart(r1));
        freeI64(r1);
        pushI64(r0);
    }
}

void
BaseCompiler::emitRotlI32()
{
    int32_t c;
    if (popConstI32(&c)) {
        RegI32 r = popI32();
        masm.rotateLeft(Imm32(c & 31), r, r);
        pushI32(r);
    } else {
        RegI32 r0, r1;
        pop2xI32ForShiftOrRotate(&r0, &r1);
        masm.rotateLeft(r1, r0, r0);
        freeI32(r1);
        pushI32(r0);
    }
}

void
BaseCompiler::emitRotlI64()
{
    int64_t c;
    if (popConstI64(&c)) {
        RegI64 r = popI64();
        RegI32 temp;
        if (rotate64NeedsTemp())
            temp = needI32();
        masm.rotateLeft64(Imm32(c & 63), r, r, temp);
        if (temp != Register::Invalid())
            freeI32(temp);
        pushI64(r);
    } else {
        RegI64 r0, r1;
        pop2xI64ForShiftOrRotate(&r0, &r1);
        masm.rotateLeft64(lowPart(r1), r0, r0, maybeHighPart(r1));
        freeI64(r1);
        pushI64(r0);
    }
}

void
BaseCompiler::emitEqzI32()
{
    if (sniffConditionalControlEqz(ValType::I32))
        return;

    RegI32 r0 = popI32();
    masm.cmp32Set(Assembler::Equal, r0, Imm32(0), r0);
    pushI32(r0);
}

void
BaseCompiler::emitEqzI64()
{
    if (sniffConditionalControlEqz(ValType::I64))
        return;

    RegI64 r0 = popI64();
    RegI32 i0 = fromI64(r0);
    eqz64(r0, i0);
    freeI64Except(r0, i0);
    pushI32(i0);
}

void
BaseCompiler::emitClzI32()
{
    RegI32 r0 = popI32();
    masm.clz32(r0, r0, IsKnownNotZero(false));
    pushI32(r0);
}

void
BaseCompiler::emitClzI64()
{
    RegI64 r0 = popI64();
    masm.clz64(r0, lowPart(r0));
    maybeClearHighPart(r0);
    pushI64(r0);
}

void
BaseCompiler::emitCtzI32()
{
    RegI32 r0 = popI32();
    masm.ctz32(r0, r0, IsKnownNotZero(false));
    pushI32(r0);
}

void
BaseCompiler::emitCtzI64()
{
    RegI64 r0 = popI64();
    masm.ctz64(r0, lowPart(r0));
    maybeClearHighPart(r0);
    pushI64(r0);
}

void
BaseCompiler::emitPopcntI32()
{
    RegI32 r0 = popI32();
    if (popcnt32NeedsTemp()) {
        RegI32 tmp = needI32();
        masm.popcnt32(r0, r0, tmp);
        freeI32(tmp);
    } else {
        masm.popcnt32(r0, r0, invalidI32());
    }
    pushI32(r0);
}

void
BaseCompiler::emitPopcntI64()
{
    RegI64 r0 = popI64();
    if (popcnt64NeedsTemp()) {
        RegI32 tmp = needI32();
        masm.popcnt64(r0, r0, tmp);
        freeI32(tmp);
    } else {
        masm.popcnt64(r0, r0, invalidI32());
    }
    pushI64(r0);
}

void
BaseCompiler::emitAbsF32()
{
    RegF32 r0 = popF32();
    masm.absFloat32(r0, r0);
    pushF32(r0);
}

void
BaseCompiler::emitAbsF64()
{
    RegF64 r0 = popF64();
    masm.absDouble(r0, r0);
    pushF64(r0);
}

void
BaseCompiler::emitNegateF32()
{
    RegF32 r0 = popF32();
    masm.negateFloat(r0);
    pushF32(r0);
}

void
BaseCompiler::emitNegateF64()
{
    RegF64 r0 = popF64();
    masm.negateDouble(r0);
    pushF64(r0);
}

void
BaseCompiler::emitSqrtF32()
{
    RegF32 r0 = popF32();
    masm.sqrtFloat32(r0, r0);
    pushF32(r0);
}

void
BaseCompiler::emitSqrtF64()
{
    RegF64 r0 = popF64();
    masm.sqrtDouble(r0, r0);
    pushF64(r0);
}

template<bool isUnsigned>
bool
BaseCompiler::emitTruncateF32ToI32()
{
    RegF32 r0 = popF32();
    RegI32 i0 = needI32();
    if (!truncateF32ToI32(r0, i0, isUnsigned))
        return false;
    freeF32(r0);
    pushI32(i0);
    return true;
}

template<bool isUnsigned>
bool
BaseCompiler::emitTruncateF64ToI32()
{
    RegF64 r0 = popF64();
    RegI32 i0 = needI32();
    if (!truncateF64ToI32(r0, i0, isUnsigned))
        return false;
    freeF64(r0);
    pushI32(i0);
    return true;
}

#ifndef FLOAT_TO_I64_CALLOUT
template<bool isUnsigned>
bool
BaseCompiler::emitTruncateF32ToI64()
{
    RegF32 r0 = popF32();
    RegI64 x0 = needI64();
    if (isUnsigned) {
        RegF64 tmp = needF64();
        if (!truncateF32ToI64(r0, x0, isUnsigned, tmp))
            return false;
        freeF64(tmp);
    } else {
        if (!truncateF32ToI64(r0, x0, isUnsigned, invalidF64()))
            return false;
    }
    freeF32(r0);
    pushI64(x0);
    return true;
}

template<bool isUnsigned>
bool
BaseCompiler::emitTruncateF64ToI64()
{
    RegF64 r0 = popF64();
    RegI64 x0 = needI64();
    if (isUnsigned) {
        RegF64 tmp = needF64();
        if (!truncateF64ToI64(r0, x0, isUnsigned, tmp))
            return false;
        freeF64(tmp);
    } else {
        if (!truncateF64ToI64(r0, x0, isUnsigned, invalidF64()))
            return false;
    }
    freeF64(r0);
    pushI64(x0);
    return true;
}
#endif // FLOAT_TO_I64_CALLOUT

void
BaseCompiler::emitWrapI64ToI32()
{
    RegI64 r0 = popI64();
    RegI32 i0 = fromI64(r0);
    wrapI64ToI32(r0, i0);
    freeI64Except(r0, i0);
    pushI32(i0);
}

void
BaseCompiler::emitExtendI32ToI64()
{
    RegI64 x0 = popI32ForSignExtendI64();
    RegI32 r0 = RegI32(lowPart(x0));
    signExtendI32ToI64(r0, x0);
    pushI64(x0);
    // Note: no need to free r0, since it is part of x0
}

void
BaseCompiler::emitExtendU32ToI64()
{
    RegI32 r0 = popI32();
    RegI64 x0 = widenI32(r0);
    extendU32ToI64(r0, x0);
    pushI64(x0);
    // Note: no need to free r0, since it is part of x0
}

void
BaseCompiler::emitReinterpretF32AsI32()
{
    RegF32 r0 = popF32();
    RegI32 i0 = needI32();
    masm.moveFloat32ToGPR(r0, i0);
    freeF32(r0);
    pushI32(i0);
}

void
BaseCompiler::emitReinterpretF64AsI64()
{
    RegF64 r0 = popF64();
    RegI64 x0 = needI64();
    reinterpretF64AsI64(r0, x0);
    freeF64(r0);
    pushI64(x0);
}

void
BaseCompiler::emitConvertF64ToF32()
{
    RegF64 r0 = popF64();
    RegF32 f0 = needF32();
    masm.convertDoubleToFloat32(r0, f0);
    freeF64(r0);
    pushF32(f0);
}

void
BaseCompiler::emitConvertI32ToF32()
{
    RegI32 r0 = popI32();
    RegF32 f0 = needF32();
    masm.convertInt32ToFloat32(r0, f0);
    freeI32(r0);
    pushF32(f0);
}

void
BaseCompiler::emitConvertU32ToF32()
{
    RegI32 r0 = popI32();
    RegF32 f0 = needF32();
    masm.convertUInt32ToFloat32(r0, f0);
    freeI32(r0);
    pushF32(f0);
}

#ifndef I64_TO_FLOAT_CALLOUT
void
BaseCompiler::emitConvertI64ToF32()
{
    RegI64 r0 = popI64();
    RegF32 f0 = needF32();
    convertI64ToF32(r0, IsUnsigned(false), f0, RegI32());
    freeI64(r0);
    pushF32(f0);
}

void
BaseCompiler::emitConvertU64ToF32()
{
    RegI64 r0 = popI64();
    RegF32 f0 = needF32();
    RegI32 temp;
    if (convertI64ToFloatNeedsTemp(ValType::F32, IsUnsigned(true)))
        temp = needI32();
    convertI64ToF32(r0, IsUnsigned(true), f0, temp);
    if (temp != Register::Invalid())
        freeI32(temp);
    freeI64(r0);
    pushF32(f0);
}
#endif

void
BaseCompiler::emitConvertF32ToF64()
{
    RegF32 r0 = popF32();
    RegF64 d0 = needF64();
    masm.convertFloat32ToDouble(r0, d0);
    freeF32(r0);
    pushF64(d0);
}

void
BaseCompiler::emitConvertI32ToF64()
{
    RegI32 r0 = popI32();
    RegF64 d0 = needF64();
    masm.convertInt32ToDouble(r0, d0);
    freeI32(r0);
    pushF64(d0);
}

void
BaseCompiler::emitConvertU32ToF64()
{
    RegI32 r0 = popI32();
    RegF64 d0 = needF64();
    masm.convertUInt32ToDouble(r0, d0);
    freeI32(r0);
    pushF64(d0);
}

#ifndef I64_TO_FLOAT_CALLOUT
void
BaseCompiler::emitConvertI64ToF64()
{
    RegI64 r0 = popI64();
    RegF64 d0 = needF64();
    convertI64ToF64(r0, IsUnsigned(false), d0, RegI32());
    freeI64(r0);
    pushF64(d0);
}

void
BaseCompiler::emitConvertU64ToF64()
{
    RegI64 r0 = popI64();
    RegF64 d0 = needF64();
    RegI32 temp;
    if (convertI64ToFloatNeedsTemp(ValType::F64, IsUnsigned(true)))
        temp = needI32();
    convertI64ToF64(r0, IsUnsigned(true), d0, temp);
    if (temp != Register::Invalid())
        freeI32(temp);
    freeI64(r0);
    pushF64(d0);
}
#endif // I64_TO_FLOAT_CALLOUT

void
BaseCompiler::emitReinterpretI32AsF32()
{
    RegI32 r0 = popI32();
    RegF32 f0 = needF32();
    masm.moveGPRToFloat32(r0, f0);
    freeI32(r0);
    pushF32(f0);
}

void
BaseCompiler::emitReinterpretI64AsF64()
{
    RegI64 r0 = popI64();
    RegF64 d0 = needF64();
    reinterpretI64AsF64(r0, d0);
    freeI64(r0);
    pushF64(d0);
}

template<typename Cond>
bool
BaseCompiler::sniffConditionalControlCmp(Cond compareOp, ValType operandType)
{
    MOZ_ASSERT(latentOp_ == LatentOp::None, "Latent comparison state not properly reset");

    OpBytes op;
    iter_.peekOp(&op);
    switch (op.b0) {
      case uint16_t(Op::Select):
#ifdef JS_CODEGEN_X86
        // On x86, with only 5 available registers, a latent i64 binary
        // comparison takes 4 leaving only 1 which is not enough for select.
        if (operandType == ValType::I64)
            return false;
#endif
        MOZ_FALLTHROUGH;
      case uint16_t(Op::BrIf):
      case uint16_t(Op::If):
        setLatentCompare(compareOp, operandType);
        return true;
      default:
        return false;
    }
}

bool
BaseCompiler::sniffConditionalControlEqz(ValType operandType)
{
    MOZ_ASSERT(latentOp_ == LatentOp::None, "Latent comparison state not properly reset");

    OpBytes op;
    iter_.peekOp(&op);
    switch (op.b0) {
      case uint16_t(Op::BrIf):
      case uint16_t(Op::Select):
      case uint16_t(Op::If):
        setLatentEqz(operandType);
        return true;
      default:
        return false;
    }
}

void
BaseCompiler::emitBranchSetup(BranchState* b)
{
    maybeReserveJoinReg(b->resultType);

    // Set up fields so that emitBranchPerform() need not switch on latentOp_.
    switch (latentOp_) {
      case LatentOp::None: {
        latentIntCmp_ = Assembler::NotEqual;
        latentType_ = ValType::I32;
        b->i32.lhs = popI32();
        b->i32.rhsImm = true;
        b->i32.imm = 0;
        break;
      }
      case LatentOp::Compare: {
        switch (latentType_) {
          case ValType::I32: {
            if (popConstI32(&b->i32.imm)) {
                b->i32.lhs = popI32();
                b->i32.rhsImm = true;
            } else {
                pop2xI32(&b->i32.lhs, &b->i32.rhs);
                b->i32.rhsImm = false;
            }
            break;
          }
          case ValType::I64: {
            pop2xI64(&b->i64.lhs, &b->i64.rhs);
            b->i64.rhsImm = false;
            break;
          }
          case ValType::F32: {
            pop2xF32(&b->f32.lhs, &b->f32.rhs);
            break;
          }
          case ValType::F64: {
            pop2xF64(&b->f64.lhs, &b->f64.rhs);
            break;
          }
          default: {
            MOZ_CRASH("Unexpected type for LatentOp::Compare");
          }
        }
        break;
      }
      case LatentOp::Eqz: {
        switch (latentType_) {
          case ValType::I32: {
            latentIntCmp_ = Assembler::Equal;
            b->i32.lhs = popI32();
            b->i32.rhsImm = true;
            b->i32.imm = 0;
            break;
          }
          case ValType::I64: {
            latentIntCmp_ = Assembler::Equal;
            b->i64.lhs = popI64();
            b->i64.rhsImm = true;
            b->i64.imm = 0;
            break;
          }
          default: {
            MOZ_CRASH("Unexpected type for LatentOp::Eqz");
          }
        }
        break;
      }
    }

    maybeUnreserveJoinReg(b->resultType);
}

void
BaseCompiler::emitBranchPerform(BranchState* b)
{
    switch (latentType_) {
      case ValType::I32: {
        if (b->i32.rhsImm) {
            jumpConditionalWithJoinReg(b, latentIntCmp_, b->i32.lhs, Imm32(b->i32.imm));
        } else {
            jumpConditionalWithJoinReg(b, latentIntCmp_, b->i32.lhs, b->i32.rhs);
            freeI32(b->i32.rhs);
        }
        freeI32(b->i32.lhs);
        break;
      }
      case ValType::I64: {
        if (b->i64.rhsImm) {
            jumpConditionalWithJoinReg(b, latentIntCmp_, b->i64.lhs, Imm64(b->i64.imm));
        } else {
            jumpConditionalWithJoinReg(b, latentIntCmp_, b->i64.lhs, b->i64.rhs);
            freeI64(b->i64.rhs);
        }
        freeI64(b->i64.lhs);
        break;
      }
      case ValType::F32: {
        jumpConditionalWithJoinReg(b, latentDoubleCmp_, b->f32.lhs, b->f32.rhs);
        freeF32(b->f32.lhs);
        freeF32(b->f32.rhs);
        break;
      }
      case ValType::F64: {
        jumpConditionalWithJoinReg(b, latentDoubleCmp_, b->f64.lhs, b->f64.rhs);
        freeF64(b->f64.lhs);
        freeF64(b->f64.rhs);
        break;
      }
      default: {
        MOZ_CRASH("Unexpected type for LatentOp::Compare");
      }
    }
    resetLatentOp();
}

// For blocks and loops and ifs:
//
//  - Sync the value stack before going into the block in order to simplify exit
//    from the block: all exits from the block can assume that there are no
//    live registers except the one carrying the exit value.
//  - The block can accumulate a number of dead values on the stacks, so when
//    branching out of the block or falling out at the end be sure to
//    pop the appropriate stacks back to where they were on entry, while
//    preserving the exit value.
//  - A continue branch in a loop is much like an exit branch, but the branch
//    value must not be preserved.
//  - The exit value is always in a designated join register (type dependent).

bool
BaseCompiler::emitBlock()
{
    if (!iter_.readBlock())
        return false;

    if (!deadCode_)
        sync();                    // Simplifies branching out from block

    initControl(controlItem());

    return true;
}

void
BaseCompiler::endBlock(ExprType type)
{
    Control& block = controlItem();

    // Save the value.
    AnyReg r;
    if (!deadCode_) {
        r = popJoinRegUnlessVoid(type);
        block.bceSafeOnExit &= bceSafe_;
    }

    // Leave the block.
    popStackOnBlockExit(block.framePushed);
    popValueStackTo(block.stackSize);

    // Bind after cleanup: branches out will have popped the stack.
    if (block.label.used()) {
        masm.bind(&block.label);
        // No value was provided by the fallthrough but the branch out will
        // have stored one in joinReg, so capture that.
        if (deadCode_)
            r = captureJoinRegUnlessVoid(type);
        deadCode_ = false;
    }

    bceSafe_ = block.bceSafeOnExit;

    // Retain the value stored in joinReg by all paths, if there are any.
    if (!deadCode_)
        pushJoinRegUnlessVoid(r);
}

bool
BaseCompiler::emitLoop()
{
    if (!iter_.readLoop())
        return false;

    if (!deadCode_)
        sync();                    // Simplifies branching out from block

    initControl(controlItem());
    bceSafe_ = 0;

    if (!deadCode_) {
        masm.nopAlign(CodeAlignment);
        masm.bind(&controlItem(0).label);
        addInterruptCheck();
    }

    return true;
}

void
BaseCompiler::endLoop(ExprType type)
{
    Control& block = controlItem();

    AnyReg r;
    if (!deadCode_) {
        r = popJoinRegUnlessVoid(type);
        // block.bceSafeOnExit need not be updated because it won't be used for
        // the fallthrough path.
    }

    popStackOnBlockExit(block.framePushed);
    popValueStackTo(block.stackSize);

    // bceSafe_ stays the same along the fallthrough path because branches to
    // loops branch to the top.

    // Retain the value stored in joinReg by all paths.
    if (!deadCode_)
        pushJoinRegUnlessVoid(r);
}

// The bodies of the "then" and "else" arms can be arbitrary sequences
// of expressions, they push control and increment the nesting and can
// even be targeted by jumps.  A branch to the "if" block branches to
// the exit of the if, ie, it's like "break".  Consider:
//
//      (func (result i32)
//       (if (i32.const 1)
//           (begin (br 1) (unreachable))
//           (begin (unreachable)))
//       (i32.const 1))
//
// The branch causes neither of the unreachable expressions to be
// evaluated.

bool
BaseCompiler::emitIf()
{
    Nothing unused_cond;
    if (!iter_.readIf(&unused_cond))
        return false;

    BranchState b(&controlItem().otherLabel, BranchState::NoPop, InvertBranch(true));
    if (!deadCode_) {
        emitBranchSetup(&b);
        sync();
    } else {
        resetLatentOp();
    }

    initControl(controlItem());

    if (!deadCode_)
        emitBranchPerform(&b);

    return true;
}

void
BaseCompiler::endIfThen()
{
    Control& ifThen = controlItem();

    popStackOnBlockExit(ifThen.framePushed);
    popValueStackTo(ifThen.stackSize);

    if (ifThen.otherLabel.used())
        masm.bind(&ifThen.otherLabel);

    if (ifThen.label.used())
        masm.bind(&ifThen.label);

    if (!deadCode_)
        ifThen.bceSafeOnExit &= bceSafe_;

    deadCode_ = ifThen.deadOnArrival;

    bceSafe_ = ifThen.bceSafeOnExit & ifThen.bceSafeOnEntry;
}

bool
BaseCompiler::emitElse()
{
    ExprType thenType;
    Nothing unused_thenValue;

    if (!iter_.readElse(&thenType, &unused_thenValue))
        return false;

    Control& ifThenElse = controlItem(0);

    // See comment in endIfThenElse, below.

    // Exit the "then" branch.

    ifThenElse.deadThenBranch = deadCode_;

    AnyReg r;
    if (!deadCode_)
        r = popJoinRegUnlessVoid(thenType);

    popStackOnBlockExit(ifThenElse.framePushed);
    popValueStackTo(ifThenElse.stackSize);

    if (!deadCode_)
        masm.jump(&ifThenElse.label);

    if (ifThenElse.otherLabel.used())
        masm.bind(&ifThenElse.otherLabel);

    // Reset to the "else" branch.

    if (!deadCode_) {
        freeJoinRegUnlessVoid(r);
        ifThenElse.bceSafeOnExit &= bceSafe_;
    }

    deadCode_ = ifThenElse.deadOnArrival;
    bceSafe_ = ifThenElse.bceSafeOnEntry;

    return true;
}

void
BaseCompiler::endIfThenElse(ExprType type)
{
    Control& ifThenElse = controlItem();

    // The expression type is not a reliable guide to what we'll find
    // on the stack, we could have (if E (i32.const 1) (unreachable))
    // in which case the "else" arm is AnyType but the type of the
    // full expression is I32.  So restore whatever's there, not what
    // we want to find there.  The "then" arm has the same constraint.

    AnyReg r;

    if (!deadCode_) {
        r = popJoinRegUnlessVoid(type);
        ifThenElse.bceSafeOnExit &= bceSafe_;
    }

    popStackOnBlockExit(ifThenElse.framePushed);
    popValueStackTo(ifThenElse.stackSize);

    if (ifThenElse.label.used())
        masm.bind(&ifThenElse.label);

    bool joinLive = !ifThenElse.deadOnArrival &&
                    (!ifThenElse.deadThenBranch || !deadCode_ || ifThenElse.label.bound());

    if (joinLive) {
        // No value was provided by the "then" path but capture the one
        // provided by the "else" path.
        if (deadCode_)
            r = captureJoinRegUnlessVoid(type);
        deadCode_ = false;
    }

    bceSafe_ = ifThenElse.bceSafeOnExit;

    if (!deadCode_)
        pushJoinRegUnlessVoid(r);
}

bool
BaseCompiler::emitEnd()
{
    LabelKind kind;
    ExprType type;
    Nothing unused_value;
    if (!iter_.readEnd(&kind, &type, &unused_value))
        return false;

    switch (kind) {
      case LabelKind::Block: endBlock(type); break;
      case LabelKind::Loop:  endLoop(type); break;
      case LabelKind::Then:  endIfThen(); break;
      case LabelKind::Else:  endIfThenElse(type); break;
    }

    iter_.popEnd();

    return true;
}

bool
BaseCompiler::emitBr()
{
    uint32_t relativeDepth;
    ExprType type;
    Nothing unused_value;
    if (!iter_.readBr(&relativeDepth, &type, &unused_value))
        return false;

    if (deadCode_)
        return true;

    Control& target = controlItem(relativeDepth);
    target.bceSafeOnExit &= bceSafe_;

    // Save any value in the designated join register, where the
    // normal block exit code will also leave it.

    AnyReg r = popJoinRegUnlessVoid(type);

    popStackBeforeBranch(target.framePushed);
    masm.jump(&target.label);

    // The register holding the join value is free for the remainder
    // of this block.

    freeJoinRegUnlessVoid(r);

    deadCode_ = true;

    return true;
}

bool
BaseCompiler::emitBrIf()
{
    uint32_t relativeDepth;
    ExprType type;
    Nothing unused_value, unused_condition;
    if (!iter_.readBrIf(&relativeDepth, &type, &unused_value, &unused_condition))
        return false;

    if (deadCode_) {
        resetLatentOp();
        return true;
    }

    Control& target = controlItem(relativeDepth);
    target.bceSafeOnExit &= bceSafe_;

    BranchState b(&target.label, target.framePushed, InvertBranch(false), type);
    emitBranchSetup(&b);
    emitBranchPerform(&b);

    return true;
}

bool
BaseCompiler::emitBrTable()
{
    Uint32Vector depths;
    uint32_t defaultDepth;
    ExprType branchValueType;
    Nothing unused_value, unused_index;
    if (!iter_.readBrTable(&depths, &defaultDepth, &branchValueType, &unused_value, &unused_index))
        return false;

    if (deadCode_)
        return true;

    // Don't use joinReg for rc
    maybeReserveJoinRegI(branchValueType);

    // Table switch value always on top.
    RegI32 rc = popI32();

    maybeUnreserveJoinRegI(branchValueType);

    AnyReg r = popJoinRegUnlessVoid(branchValueType);

    Label dispatchCode;
    masm.branch32(Assembler::Below, rc, Imm32(depths.length()), &dispatchCode);

    // This is the out-of-range stub.  rc is dead here but we don't need it.

    popStackBeforeBranch(controlItem(defaultDepth).framePushed);
    controlItem(defaultDepth).bceSafeOnExit &= bceSafe_;
    masm.jump(&controlItem(defaultDepth).label);

    // Emit stubs.  rc is dead in all of these but we don't need it.
    //
    // The labels in the vector are in the TempAllocator and will
    // be freed by and by.
    //
    // TODO / OPTIMIZE (Bug 1316804): Branch directly to the case code if we
    // can, don't emit an intermediate stub.

    LabelVector stubs;
    if (!stubs.reserve(depths.length()))
        return false;

    for (uint32_t depth : depths) {
        stubs.infallibleEmplaceBack(NonAssertingLabel());
        masm.bind(&stubs.back());
        popStackBeforeBranch(controlItem(depth).framePushed);
        controlItem(depth).bceSafeOnExit &= bceSafe_;
        masm.jump(&controlItem(depth).label);
    }

    // Emit table.

    Label theTable;
    jumpTable(stubs, &theTable);

    // Emit indirect jump.  rc is live here.

    tableSwitch(&theTable, rc, &dispatchCode);

    deadCode_ = true;

    // Clean up.

    freeI32(rc);
    freeJoinRegUnlessVoid(r);

    return true;
}

bool
BaseCompiler::emitDrop()
{
    if (!iter_.readDrop())
        return false;

    if (deadCode_)
        return true;

    popStackIfMemory();
    popValueStackBy(1);
    return true;
}

void
BaseCompiler::doReturn(ExprType type, bool popStack)
{
    switch (type) {
      case ExprType::Void: {
        returnCleanup(popStack);
        break;
      }
      case ExprType::I32: {
        RegI32 rv = popI32(RegI32(ReturnReg));
        returnCleanup(popStack);
        freeI32(rv);
        break;
      }
      case ExprType::I64: {
        RegI64 rv = popI64(RegI64(ReturnReg64));
        returnCleanup(popStack);
        freeI64(rv);
        break;
      }
      case ExprType::F64: {
        RegF64 rv = popF64(RegF64(ReturnDoubleReg));
        returnCleanup(popStack);
        freeF64(rv);
        break;
      }
      case ExprType::F32: {
        RegF32 rv = popF32(RegF32(ReturnFloat32Reg));
        returnCleanup(popStack);
        freeF32(rv);
        break;
      }
      default: {
        MOZ_CRASH("Function return type");
      }
    }
}

bool
BaseCompiler::emitReturn()
{
    Nothing unused_value;
    if (!iter_.readReturn(&unused_value))
        return false;

    if (deadCode_)
        return true;

    doReturn(func_.sig().ret(), PopStack(true));
    deadCode_ = true;

    return true;
}

bool
BaseCompiler::emitCallArgs(const ValTypeVector& argTypes, FunctionCall& baselineCall)
{
    MOZ_ASSERT(!deadCode_);

    startCallArgs(baselineCall, stackArgAreaSize(argTypes));

    uint32_t numArgs = argTypes.length();
    for (size_t i = 0; i < numArgs; ++i)
        passArg(baselineCall, argTypes[i], peek(numArgs - 1 - i));

    masm.loadWasmTlsRegFromFrame();
    return true;
}

void
BaseCompiler::pushReturned(const FunctionCall& call, ExprType type)
{
    switch (type) {
      case ExprType::Void:
        MOZ_CRASH("Compiler bug: attempt to push void return");
        break;
      case ExprType::I32: {
        RegI32 rv = captureReturnedI32();
        pushI32(rv);
        break;
      }
      case ExprType::I64: {
        RegI64 rv = captureReturnedI64();
        pushI64(rv);
        break;
      }
      case ExprType::F32: {
        RegF32 rv = captureReturnedF32(call);
        pushF32(rv);
        break;
      }
      case ExprType::F64: {
        RegF64 rv = captureReturnedF64(call);
        pushF64(rv);
        break;
      }
      default:
        MOZ_CRASH("Function return type");
    }
}

// For now, always sync() at the beginning of the call to easily save live
// values.
//
// TODO / OPTIMIZE (Bug 1316806): We may be able to avoid a full sync(), since
// all we want is to save live registers that won't be saved by the callee or
// that we need for outgoing args - we don't need to sync the locals.  We can
// just push the necessary registers, it'll be like a lightweight sync.
//
// Even some of the pushing may be unnecessary if the registers will be consumed
// by the call, because then what we want is parallel assignment to the argument
// registers or onto the stack for outgoing arguments.  A sync() is just
// simpler.

bool
BaseCompiler::emitCall()
{
    uint32_t lineOrBytecode = readCallSiteLineOrBytecode();

    uint32_t funcIndex;
    BaseOpIter::ValueVector args_;
    if (!iter_.readCall(&funcIndex, &args_))
        return false;

    if (deadCode_)
        return true;

    sync();

    const Sig& sig = *env_.funcSigs[funcIndex];
    bool import = env_.funcIsImport(funcIndex);

    uint32_t numArgs = sig.args().length();
    size_t stackSpace = stackConsumed(numArgs);

    FunctionCall baselineCall(lineOrBytecode);
    beginCall(baselineCall, UseABI::Wasm, import ? InterModule::True : InterModule::False);

    if (!emitCallArgs(sig.args(), baselineCall))
        return false;

    if (import)
        callImport(env_.funcImportGlobalDataOffsets[funcIndex], baselineCall);
    else
        callDefinition(funcIndex, baselineCall);

    endCall(baselineCall, stackSpace);

    popValueStackBy(numArgs);

    if (!IsVoid(sig.ret()))
        pushReturned(baselineCall, sig.ret());

    return true;
}

bool
BaseCompiler::emitCallIndirect()
{
    uint32_t lineOrBytecode = readCallSiteLineOrBytecode();

    uint32_t sigIndex;
    Nothing callee_;
    BaseOpIter::ValueVector args_;
    if (!iter_.readCallIndirect(&sigIndex, &callee_, &args_))
        return false;

    if (deadCode_)
        return true;

    sync();

    const SigWithId& sig = env_.sigs[sigIndex];

    // Stack: ... arg1 .. argn callee

    uint32_t numArgs = sig.args().length();
    size_t stackSpace = stackConsumed(numArgs + 1);

    // The arguments must be at the stack top for emitCallArgs, so pop the
    // callee if it is on top.  Note this only pops the compiler's stack,
    // not the CPU stack.

    Stk callee = stk_.popCopy();

    FunctionCall baselineCall(lineOrBytecode);
    beginCall(baselineCall, UseABI::Wasm, InterModule::True);

    if (!emitCallArgs(sig.args(), baselineCall))
        return false;

    callIndirect(sigIndex, callee, baselineCall);

    endCall(baselineCall, stackSpace);

    popValueStackBy(numArgs);

    if (!IsVoid(sig.ret()))
        pushReturned(baselineCall, sig.ret());

    return true;
}

void
BaseCompiler::emitRound(RoundingMode roundingMode, ValType operandType)
{
    if (operandType == ValType::F32) {
        RegF32 f0 = popF32();
        roundF32(roundingMode, f0);
        pushF32(f0);
    } else if (operandType == ValType::F64) {
        RegF64 f0 = popF64();
        roundF64(roundingMode, f0);
        pushF64(f0);
    } else {
        MOZ_CRASH("unexpected type");
    }
}

bool
BaseCompiler::emitUnaryMathBuiltinCall(SymbolicAddress callee, ValType operandType)
{
    uint32_t lineOrBytecode = readCallSiteLineOrBytecode();

    Nothing operand_;
    if (!iter_.readUnary(operandType, &operand_))
        return false;

    if (deadCode_)
        return true;

    RoundingMode roundingMode;
    if (IsRoundingFunction(callee, &roundingMode) && supportsRoundInstruction(roundingMode)) {
        emitRound(roundingMode, operandType);
        return true;
    }

    sync();

    ValTypeVector& signature = operandType == ValType::F32 ? SigF_ : SigD_;
    ExprType retType = operandType == ValType::F32 ? ExprType::F32 : ExprType::F64;
    uint32_t numArgs = signature.length();
    size_t stackSpace = stackConsumed(numArgs);

    FunctionCall baselineCall(lineOrBytecode);
    beginCall(baselineCall, UseABI::System, InterModule::False);

    if (!emitCallArgs(signature, baselineCall))
        return false;

    builtinCall(callee, baselineCall);

    endCall(baselineCall, stackSpace);

    popValueStackBy(numArgs);

    pushReturned(baselineCall, retType);

    return true;
}

#ifdef INT_DIV_I64_CALLOUT
void
BaseCompiler::emitDivOrModI64BuiltinCall(SymbolicAddress callee, ValType operandType)
{
    MOZ_ASSERT(operandType == ValType::I64);
    MOZ_ASSERT(!deadCode_);

    sync();

    needI64(abiReturnRegI64);

    RegI64 rhs = popI64();
    RegI64 srcDest = popI64ToSpecific(abiReturnRegI64);

    Label done;

    checkDivideByZeroI64(rhs);

    if (callee == SymbolicAddress::DivI64)
        checkDivideSignedOverflowI64(rhs, srcDest, &done, ZeroOnOverflow(false));
    else if (callee == SymbolicAddress::ModI64)
        checkDivideSignedOverflowI64(rhs, srcDest, &done, ZeroOnOverflow(true));

    masm.setupWasmABICall();
    masm.passABIArg(srcDest.high);
    masm.passABIArg(srcDest.low);
    masm.passABIArg(rhs.high);
    masm.passABIArg(rhs.low);
    masm.callWithABI(bytecodeOffset(), callee);

    masm.bind(&done);

    freeI64(rhs);
    pushI64(srcDest);
}
#endif // INT_DIV_I64_CALLOUT

#ifdef I64_TO_FLOAT_CALLOUT
bool
BaseCompiler::emitConvertInt64ToFloatingCallout(SymbolicAddress callee, ValType operandType,
                                                ValType resultType)
{
    sync();

    RegI64 input = popI64();

    FunctionCall call(0);

    masm.setupWasmABICall();
# ifdef JS_NUNBOX32
    masm.passABIArg(input.high);
    masm.passABIArg(input.low);
# else
    MOZ_CRASH("BaseCompiler platform hook: emitConvertInt64ToFloatingCallout");
# endif
    masm.callWithABI(bytecodeOffset(), callee,
                     resultType == ValType::F32 ? MoveOp::FLOAT32 : MoveOp::DOUBLE);

    freeI64(input);

    if (resultType == ValType::F32)
        pushF32(captureReturnedF32(call));
    else
        pushF64(captureReturnedF64(call));

    return true;
}
#endif // I64_TO_FLOAT_CALLOUT

#ifdef FLOAT_TO_I64_CALLOUT
// `Callee` always takes a double, so a float32 input must be converted.
bool
BaseCompiler::emitConvertFloatingToInt64Callout(SymbolicAddress callee, ValType operandType,
                                                ValType resultType)
{
    RegF64 doubleInput;
    if (operandType == ValType::F32) {
        doubleInput = needF64();
        RegF32 input = popF32();
        masm.convertFloat32ToDouble(input, doubleInput);
        freeF32(input);
    } else {
        doubleInput = popF64();
    }

    // We may need the value after the call for the ool check.
    RegF64 otherReg = needF64();
    moveF64(doubleInput, otherReg);
    pushF64(otherReg);

    sync();

    FunctionCall call(0);

    masm.setupWasmABICall();
    masm.passABIArg(doubleInput, MoveOp::DOUBLE);
    masm.callWithABI(bytecodeOffset(), callee);

    freeF64(doubleInput);

    RegI64 rv = captureReturnedI64();

    RegF64 inputVal = popF64();

    bool isUnsigned = callee == SymbolicAddress::TruncateDoubleToUint64;

    // The OOL check just succeeds or fails, it does not generate a value.
    OutOfLineCode* ool = new (alloc_) OutOfLineTruncateCheckF32OrF64ToI64(AnyReg(inputVal),
                                                                          isUnsigned,
                                                                          bytecodeOffset());
    ool = addOutOfLineCode(ool);
    if (!ool)
        return false;

    masm.branch64(Assembler::Equal, rv, Imm64(0x8000000000000000), ool->entry());
    masm.bind(ool->rejoin());

    pushI64(rv);
    freeF64(inputVal);

    return true;
}
#endif // FLOAT_TO_I64_CALLOUT

bool
BaseCompiler::emitGetLocal()
{
    uint32_t slot;
    if (!iter_.readGetLocal(locals_, &slot))
        return false;

    if (deadCode_)
        return true;

    // Local loads are pushed unresolved, ie, they may be deferred
    // until needed, until they may be affected by a store, or until a
    // sync.  This is intended to reduce register pressure.

    switch (locals_[slot]) {
      case ValType::I32:
        pushLocalI32(slot);
        break;
      case ValType::I64:
        pushLocalI64(slot);
        break;
      case ValType::F64:
        pushLocalF64(slot);
        break;
      case ValType::F32:
        pushLocalF32(slot);
        break;
      default:
        MOZ_CRASH("Local variable type");
    }

    return true;
}

template<bool isSetLocal>
bool
BaseCompiler::emitSetOrTeeLocal(uint32_t slot)
{
    if (deadCode_)
        return true;

    bceLocalIsUpdated(slot);
    switch (locals_[slot]) {
      case ValType::I32: {
        RegI32 rv = popI32();
        syncLocal(slot);
        storeToFrameI32(rv, frameOffsetFromSlot(slot, MIRType::Int32));
        if (isSetLocal)
            freeI32(rv);
        else
            pushI32(rv);
        break;
      }
      case ValType::I64: {
        RegI64 rv = popI64();
        syncLocal(slot);
        storeToFrameI64(rv, frameOffsetFromSlot(slot, MIRType::Int64));
        if (isSetLocal)
            freeI64(rv);
        else
            pushI64(rv);
        break;
      }
      case ValType::F64: {
        RegF64 rv = popF64();
        syncLocal(slot);
        storeToFrameF64(rv, frameOffsetFromSlot(slot, MIRType::Double));
        if (isSetLocal)
            freeF64(rv);
        else
            pushF64(rv);
        break;
      }
      case ValType::F32: {
        RegF32 rv = popF32();
        syncLocal(slot);
        storeToFrameF32(rv, frameOffsetFromSlot(slot, MIRType::Float32));
        if (isSetLocal)
            freeF32(rv);
        else
            pushF32(rv);
        break;
      }
      default:
        MOZ_CRASH("Local variable type");
    }

    return true;
}

bool
BaseCompiler::emitSetLocal()
{
    uint32_t slot;
    Nothing unused_value;
    if (!iter_.readSetLocal(locals_, &slot, &unused_value))
        return false;
    return emitSetOrTeeLocal<true>(slot);
}

bool
BaseCompiler::emitTeeLocal()
{
    uint32_t slot;
    Nothing unused_value;
    if (!iter_.readTeeLocal(locals_, &slot, &unused_value))
        return false;
    return emitSetOrTeeLocal<false>(slot);
}

bool
BaseCompiler::emitGetGlobal()
{
    uint32_t id;
    if (!iter_.readGetGlobal(&id))
        return false;

    if (deadCode_)
        return true;

    const GlobalDesc& global = env_.globals[id];

    if (global.isConstant()) {
        Val value = global.constantValue();
        switch (value.type()) {
          case ValType::I32:
            pushI32(value.i32());
            break;
          case ValType::I64:
            pushI64(value.i64());
            break;
          case ValType::F32:
            pushF32(value.f32());
            break;
          case ValType::F64:
            pushF64(value.f64());
            break;
          default:
            MOZ_CRASH("Global constant type");
        }
        return true;
    }

    switch (global.type()) {
      case ValType::I32: {
        RegI32 rv = needI32();
        loadGlobalVarI32(global.offset(), rv);
        pushI32(rv);
        break;
      }
      case ValType::I64: {
        RegI64 rv = needI64();
        loadGlobalVarI64(global.offset(), rv);
        pushI64(rv);
        break;
      }
      case ValType::F32: {
        RegF32 rv = needF32();
        loadGlobalVarF32(global.offset(), rv);
        pushF32(rv);
        break;
      }
      case ValType::F64: {
        RegF64 rv = needF64();
        loadGlobalVarF64(global.offset(), rv);
        pushF64(rv);
        break;
      }
      default:
        MOZ_CRASH("Global variable type");
        break;
    }
    return true;
}

bool
BaseCompiler::emitSetGlobal()
{
    uint32_t id;
    Nothing unused_value;
    if (!iter_.readSetGlobal(&id, &unused_value))
        return false;

    if (deadCode_)
        return true;

    const GlobalDesc& global = env_.globals[id];

    switch (global.type()) {
      case ValType::I32: {
        RegI32 rv = popI32();
        storeGlobalVarI32(global.offset(), rv);
        freeI32(rv);
        break;
      }
      case ValType::I64: {
        RegI64 rv = popI64();
        storeGlobalVarI64(global.offset(), rv);
        freeI64(rv);
        break;
      }
      case ValType::F32: {
        RegF32 rv = popF32();
        storeGlobalVarF32(global.offset(), rv);
        freeF32(rv);
        break;
      }
      case ValType::F64: {
        RegF64 rv = popF64();
        storeGlobalVarF64(global.offset(), rv);
        freeF64(rv);
        break;
      }
      default:
        MOZ_CRASH("Global variable type");
        break;
    }
    return true;
}

// Bounds check elimination.
//
// We perform BCE on two kinds of address expressions: on constant heap pointers
// that are known to be in the heap or will be handled by the out-of-bounds trap
// handler; and on local variables that have been checked in dominating code
// without being updated since.
//
// For an access through a constant heap pointer + an offset we can eliminate
// the bounds check if the sum of the address and offset is below the sum of the
// minimum memory length and the offset guard length.
//
// For an access through a local variable + an offset we can eliminate the
// bounds check if the local variable has already been checked and has not been
// updated since, and the offset is less than the guard limit.
//
// To track locals for which we can eliminate checks we use a bit vector
// bceSafe_ that has a bit set for those locals whose bounds have been checked
// and which have not subsequently been set.  Initially this vector is zero.
//
// In straight-line code a bit is set when we perform a bounds check on an
// access via the local and is reset when the variable is updated.
//
// In control flow, the bit vector is manipulated as follows.  Each ControlItem
// has a value bceSafeOnEntry, which is the value of bceSafe_ on entry to the
// item, and a value bceSafeOnExit, which is initially ~0.  On a branch (br,
// brIf, brTable), we always AND the branch target's bceSafeOnExit with the
// value of bceSafe_ at the branch point.  On exiting an item by falling out of
// it, provided we're not in dead code, we AND the current value of bceSafe_
// into the item's bceSafeOnExit.  Additional processing depends on the item
// type:
//
//  - After a block, set bceSafe_ to the block's bceSafeOnExit.
//
//  - On loop entry, after pushing the ControlItem, set bceSafe_ to zero; the
//    back edges would otherwise require us to iterate to a fixedpoint.
//
//  - After a loop, the bceSafe_ is left unchanged, because only fallthrough
//    control flow will reach that point and the bceSafe_ value represents the
//    correct state of the fallthrough path.
//
//  - Set bceSafe_ to the ControlItem's bceSafeOnEntry at both the 'then' branch
//    and the 'else' branch.
//
//  - After an if-then-else, set bceSafe_ to the if-then-else's bceSafeOnExit.
//
//  - After an if-then, set bceSafe_ to the if-then's bceSafeOnExit AND'ed with
//    the if-then's bceSafeOnEntry.
//
// Finally, when the debugger allows locals to be mutated we must disable BCE
// for references via a local, by returning immediately from bceCheckLocal if
// debugEnabled_ is true.

// TODO / OPTIMIZE (bug 1329576): There are opportunities to generate better
// code by not moving a constant address with a zero offset into a register.

BaseCompiler::RegI32
BaseCompiler::popMemoryAccess(MemoryAccessDesc* access, bool* omitBoundsCheck)
{
    // Caller must initialize.
    MOZ_ASSERT(!*omitBoundsCheck);

    int32_t addrTmp;
    if (popConstI32(&addrTmp)) {
        uint32_t addr = addrTmp;

        uint64_t ea = uint64_t(addr) + uint64_t(access->offset());
        uint64_t limit = uint64_t(env_.minMemoryLength) + uint64_t(wasm::OffsetGuardLimit);

        *omitBoundsCheck = ea < limit;

        // Fold the offset into the pointer if we can, as this is always
        // beneficial.

        if (ea <= UINT32_MAX) {
            addr = uint32_t(ea);
            access->clearOffset();
        }

        RegI32 r = needI32();
        loadConstI32(r, int32_t(addr));
        return r;
    }

    uint32_t local;
    if (peekLocalI32(&local))
        bceCheckLocal(access, local, omitBoundsCheck);

    return popI32();
}

BaseCompiler::RegI32
BaseCompiler::maybeLoadTlsForAccess(bool omitBoundsCheck)
{
    RegI32 tls = invalidI32();
    if (needTlsForAccess(omitBoundsCheck)) {
        tls = needI32();
        masm.loadWasmTlsRegFromFrame(tls);
    }
    return tls;
}

bool
BaseCompiler::emitLoad(ValType type, Scalar::Type viewType)
{
    LinearMemoryAddress<Nothing> addr;
    if (!iter_.readLoad(type, Scalar::byteSize(viewType), &addr))
        return false;

    if (deadCode_)
        return true;

    bool omitBoundsCheck = false;
    MemoryAccessDesc access(viewType, addr.align, addr.offset, Some(bytecodeOffset()));

    size_t temps = loadTemps(access);
    MOZ_ASSERT(temps <= 3);
    RegI32 tmp1 = temps >= 1 ? needI32() : invalidI32();
    RegI32 tmp2 = temps >= 2 ? needI32() : invalidI32();
    RegI32 tmp3 = temps >= 3 ? needI32() : invalidI32();
    RegI32 tls = invalidI32();

    switch (type) {
      case ValType::I32: {
        RegI32 rp = popMemoryAccess(&access, &omitBoundsCheck);
#ifdef JS_CODEGEN_ARM
        RegI32 rv = IsUnaligned(access) ? needI32() : rp;
#else
        RegI32 rv = rp;
#endif
        tls = maybeLoadTlsForAccess(omitBoundsCheck);
        if (!load(&access, tls, rp, omitBoundsCheck, AnyReg(rv), tmp1, tmp2, tmp3))
            return false;
        pushI32(rv);
        if (rp != rv)
            freeI32(rp);
        break;
      }
      case ValType::I64: {
        RegI64 rv;
        RegI32 rp;
#ifdef JS_CODEGEN_X86
        rv = abiReturnRegI64;
        needI64(rv);
        rp = popMemoryAccess(&access, &omitBoundsCheck);
#else
        rp = popMemoryAccess(&access, &omitBoundsCheck);
        rv = needI64();
#endif
        tls = maybeLoadTlsForAccess(omitBoundsCheck);
        if (!load(&access, tls, rp, omitBoundsCheck, AnyReg(rv), tmp1, tmp2, tmp3))
            return false;
        pushI64(rv);
        freeI32(rp);
        break;
      }
      case ValType::F32: {
        RegI32 rp = popMemoryAccess(&access, &omitBoundsCheck);
        RegF32 rv = needF32();
        tls = maybeLoadTlsForAccess(omitBoundsCheck);
        if (!load(&access, tls, rp, omitBoundsCheck, AnyReg(rv), tmp1, tmp2, tmp3))
            return false;
        pushF32(rv);
        freeI32(rp);
        break;
      }
      case ValType::F64: {
        RegI32 rp = popMemoryAccess(&access, &omitBoundsCheck);
        RegF64 rv = needF64();
        tls = maybeLoadTlsForAccess(omitBoundsCheck);
        if (!load(&access, tls, rp, omitBoundsCheck, AnyReg(rv), tmp1, tmp2, tmp3))
            return false;
        pushF64(rv);
        freeI32(rp);
        break;
      }
      default:
        MOZ_CRASH("load type");
        break;
    }

    if (tls != invalidI32())
        freeI32(tls);

    MOZ_ASSERT(temps <= 3);
    if (temps >= 1)
        freeI32(tmp1);
    if (temps >= 2)
        freeI32(tmp2);
    if (temps >= 3)
        freeI32(tmp3);

    return true;
}

bool
BaseCompiler::emitStore(ValType resultType, Scalar::Type viewType)
{
    LinearMemoryAddress<Nothing> addr;
    Nothing unused_value;
    if (!iter_.readStore(resultType, Scalar::byteSize(viewType), &addr, &unused_value))
        return false;

    if (deadCode_)
        return true;

    bool omitBoundsCheck = false;
    MemoryAccessDesc access(viewType, addr.align, addr.offset, Some(bytecodeOffset()));

    size_t temps = storeTemps(access, resultType);

    MOZ_ASSERT(temps <= 1);
    RegI32 tmp = temps >= 1 ? needI32() : invalidI32();
    RegI32 tls = invalidI32();

    switch (resultType) {
      case ValType::I32: {
        RegI32 rv = popI32();
        RegI32 rp = popMemoryAccess(&access, &omitBoundsCheck);
        tls = maybeLoadTlsForAccess(omitBoundsCheck);
        if (!store(&access, tls, rp, omitBoundsCheck, AnyReg(rv), tmp))
            return false;
        freeI32(rp);
        freeI32(rv);
        break;
      }
      case ValType::I64: {
        RegI64 rv = popI64();
        RegI32 rp = popMemoryAccess(&access, &omitBoundsCheck);
        tls = maybeLoadTlsForAccess(omitBoundsCheck);
        if (!store(&access, tls, rp, omitBoundsCheck, AnyReg(rv), tmp))
            return false;
        freeI32(rp);
        freeI64(rv);
        break;
      }
      case ValType::F32: {
        RegF32 rv = popF32();
        RegI32 rp = popMemoryAccess(&access, &omitBoundsCheck);
        tls = maybeLoadTlsForAccess(omitBoundsCheck);
        if (!store(&access, tls, rp, omitBoundsCheck, AnyReg(rv), tmp))
            return false;
        freeI32(rp);
        freeF32(rv);
        break;
      }
      case ValType::F64: {
        RegF64 rv = popF64();
        RegI32 rp = popMemoryAccess(&access, &omitBoundsCheck);
        tls = maybeLoadTlsForAccess(omitBoundsCheck);
        if (!store(&access, tls, rp, omitBoundsCheck, AnyReg(rv), tmp))
            return false;
        freeI32(rp);
        freeF64(rv);
        break;
      }
      default:
        MOZ_CRASH("store type");
        break;
    }

    if (tls != invalidI32())
        freeI32(tls);

    MOZ_ASSERT(temps <= 1);
    if (temps >= 1)
        freeI32(tmp);

    return true;
}

bool
BaseCompiler::emitSelect()
{
    StackType type;
    Nothing unused_trueValue;
    Nothing unused_falseValue;
    Nothing unused_condition;
    if (!iter_.readSelect(&type, &unused_trueValue, &unused_falseValue, &unused_condition))
        return false;

    if (deadCode_) {
        resetLatentOp();
        return true;
    }

    // I32 condition on top, then false, then true.

    Label done;
    BranchState b(&done);
    emitBranchSetup(&b);

    switch (NonAnyToValType(type)) {
      case ValType::I32: {
        RegI32 r0, r1;
        pop2xI32(&r0, &r1);
        emitBranchPerform(&b);
        moveI32(r1, r0);
        masm.bind(&done);
        freeI32(r1);
        pushI32(r0);
        break;
      }
      case ValType::I64: {
#ifdef JS_CODEGEN_X86
        // There may be as many as four Int64 values in registers at a time: two
        // for the latent branch operands, and two for the true/false values we
        // normally pop before executing the branch.  On x86 this is one value
        // too many, so we need to generate more complicated code here, and for
        // simplicity's sake we do so even if the branch operands are not Int64.
        // However, the resulting control flow diamond is complicated since the
        // arms of the diamond will have to stay synchronized with respect to
        // their evaluation stack and regalloc state.  To simplify further, we
        // use a double branch and a temporary boolean value for now.
        RegI32 tmp = needI32();
        loadConstI32(tmp, 0);
        emitBranchPerform(&b);
        loadConstI32(tmp, 1);
        masm.bind(&done);

        Label trueValue;
        RegI64 r0, r1;
        pop2xI64(&r0, &r1);
        masm.branch32(Assembler::Equal, tmp, Imm32(0), &trueValue);
        moveI64(r1, r0);
        masm.bind(&trueValue);
        freeI32(tmp);
        freeI64(r1);
        pushI64(r0);
#else
        RegI64 r0, r1;
        pop2xI64(&r0, &r1);
        emitBranchPerform(&b);
        moveI64(r1, r0);
        masm.bind(&done);
        freeI64(r1);
        pushI64(r0);
#endif
        break;
      }
      case ValType::F32: {
        RegF32 r0, r1;
        pop2xF32(&r0, &r1);
        emitBranchPerform(&b);
        moveF32(r1, r0);
        masm.bind(&done);
        freeF32(r1);
        pushF32(r0);
        break;
      }
      case ValType::F64: {
        RegF64 r0, r1;
        pop2xF64(&r0, &r1);
        emitBranchPerform(&b);
        moveF64(r1, r0);
        masm.bind(&done);
        freeF64(r1);
        pushF64(r0);
        break;
      }
      default: {
        MOZ_CRASH("select type");
      }
    }

    return true;
}

void
BaseCompiler::emitCompareI32(Assembler::Condition compareOp, ValType compareType)
{
    MOZ_ASSERT(compareType == ValType::I32);

    if (sniffConditionalControlCmp(compareOp, compareType))
        return;

    int32_t c;
    if (popConstI32(&c)) {
        RegI32 r0 = popI32();
        masm.cmp32Set(compareOp, r0, Imm32(c), r0);
        pushI32(r0);
    } else {
        RegI32 r0, r1;
        pop2xI32(&r0, &r1);
        masm.cmp32Set(compareOp, r0, r1, r0);
        freeI32(r1);
        pushI32(r0);
    }
}

void
BaseCompiler::emitCompareI64(Assembler::Condition compareOp, ValType compareType)
{
    MOZ_ASSERT(compareType == ValType::I64);

    if (sniffConditionalControlCmp(compareOp, compareType))
        return;

    RegI64 r0, r1;
    pop2xI64(&r0, &r1);
    RegI32 i0(fromI64(r0));
    cmp64Set(compareOp, r0, r1, i0);
    freeI64(r1);
    freeI64Except(r0, i0);
    pushI32(i0);
}

void
BaseCompiler::emitCompareF32(Assembler::DoubleCondition compareOp, ValType compareType)
{
    MOZ_ASSERT(compareType == ValType::F32);

    if (sniffConditionalControlCmp(compareOp, compareType))
        return;

    Label across;
    RegF32 r0, r1;
    pop2xF32(&r0, &r1);
    RegI32 i0 = needI32();
    masm.mov(ImmWord(1), i0);
    masm.branchFloat(compareOp, r0, r1, &across);
    masm.mov(ImmWord(0), i0);
    masm.bind(&across);
    freeF32(r0);
    freeF32(r1);
    pushI32(i0);
}

void
BaseCompiler::emitCompareF64(Assembler::DoubleCondition compareOp, ValType compareType)
{
    MOZ_ASSERT(compareType == ValType::F64);

    if (sniffConditionalControlCmp(compareOp, compareType))
        return;

    Label across;
    RegF64 r0, r1;
    pop2xF64(&r0, &r1);
    RegI32 i0 = needI32();
    masm.mov(ImmWord(1), i0);
    masm.branchDouble(compareOp, r0, r1, &across);
    masm.mov(ImmWord(0), i0);
    masm.bind(&across);
    freeF64(r0);
    freeF64(r1);
    pushI32(i0);
}

bool
BaseCompiler::emitGrowMemory()
{
    uint32_t lineOrBytecode = readCallSiteLineOrBytecode();

    Nothing arg;
    if (!iter_.readGrowMemory(&arg))
        return false;

    if (deadCode_)
        return true;

    sync();

    uint32_t numArgs = 1;
    size_t stackSpace = stackConsumed(numArgs);

    FunctionCall baselineCall(lineOrBytecode);
    beginCall(baselineCall, UseABI::System, InterModule::True);

    ABIArg instanceArg = reservePointerArgument(baselineCall);

    startCallArgs(baselineCall, stackArgAreaSize(SigPI_));
    passArg(baselineCall, ValType::I32, peek(0));
    builtinInstanceMethodCall(SymbolicAddress::GrowMemory, instanceArg, baselineCall);
    endCall(baselineCall, stackSpace);

    popValueStackBy(numArgs);

    pushReturned(baselineCall, ExprType::I32);

    return true;
}

bool
BaseCompiler::emitCurrentMemory()
{
    uint32_t lineOrBytecode = readCallSiteLineOrBytecode();

    if (!iter_.readCurrentMemory())
        return false;

    if (deadCode_)
        return true;

    sync();

    FunctionCall baselineCall(lineOrBytecode);
    beginCall(baselineCall, UseABI::System, InterModule::False);

    ABIArg instanceArg = reservePointerArgument(baselineCall);

    startCallArgs(baselineCall, stackArgAreaSize(SigP_));
    builtinInstanceMethodCall(SymbolicAddress::CurrentMemory, instanceArg, baselineCall);
    endCall(baselineCall, 0);

    pushReturned(baselineCall, ExprType::I32);

    return true;
}

bool
BaseCompiler::emitBody()
{
    if (!iter_.readFunctionStart(func_.sig().ret()))
        return false;

    initControl(controlItem());

    uint32_t overhead = 0;

    for (;;) {

        Nothing unused_a, unused_b;

#ifdef DEBUG
        performRegisterLeakCheck();
#endif

#define emitBinary(doEmit, type) \
        iter_.readBinary(type, &unused_a, &unused_b) && (deadCode_ || (doEmit(), true))

#define emitUnary(doEmit, type) \
        iter_.readUnary(type, &unused_a) && (deadCode_ || (doEmit(), true))

#define emitComparison(doEmit, operandType, compareOp) \
        iter_.readComparison(operandType, &unused_a, &unused_b) && \
            (deadCode_ || (doEmit(compareOp, operandType), true))

#define emitConversion(doEmit, inType, outType) \
        iter_.readConversion(inType, outType, &unused_a) && (deadCode_ || (doEmit(), true))

#define emitConversionOOM(doEmit, inType, outType) \
        iter_.readConversion(inType, outType, &unused_a) && (deadCode_ || doEmit())

#define emitCalloutConversionOOM(doEmit, symbol, inType, outType) \
        iter_.readConversion(inType, outType, &unused_a) && \
            (deadCode_ || doEmit(symbol, inType, outType))

#define emitIntDivCallout(doEmit, symbol, type) \
        iter_.readBinary(type, &unused_a, &unused_b) && (deadCode_ || (doEmit(symbol, type), true))

#define CHECK(E)      if (!(E)) return false
#define NEXT()        continue
#define CHECK_NEXT(E) if (!(E)) return false; continue

        // TODO / EVALUATE (bug 1316845): Not obvious that this attempt at
        // reducing overhead is really paying off relative to making the check
        // every iteration.

        if (overhead == 0) {
            // Check every 50 expressions -- a happy medium between
            // memory usage and checking overhead.
            overhead = 50;

            // Checking every 50 expressions should be safe, as the
            // baseline JIT does very little allocation per expression.
            CHECK(alloc_.ensureBallast());

            // The pushiest opcode is LOOP, which pushes two values
            // per instance.
            CHECK(stk_.reserve(stk_.length() + overhead * 2));
        }

        overhead--;

        OpBytes op;
        CHECK(iter_.readOp(&op));

        // When debugEnabled_, every operator has breakpoint site but Op::End.
        if (debugEnabled_ && op.b0 != (uint16_t)Op::End) {
            // TODO sync only registers that can be clobbered by the exit
            // prologue/epilogue or disable these registers for use in
            // baseline compiler when debugEnabled_ is set.
            sync();

            insertBreakablePoint(CallSiteDesc::Breakpoint);
        }

        switch (op.b0) {
          case uint16_t(Op::End):
            if (!emitEnd())
                return false;

            if (iter_.controlStackEmpty()) {
                if (!deadCode_)
                    doReturn(func_.sig().ret(), PopStack(false));
                return iter_.readFunctionEnd(iter_.end());
            }
            NEXT();

          // Control opcodes
          case uint16_t(Op::Nop):
            CHECK_NEXT(iter_.readNop());
          case uint16_t(Op::Drop):
            CHECK_NEXT(emitDrop());
          case uint16_t(Op::Block):
            CHECK_NEXT(emitBlock());
          case uint16_t(Op::Loop):
            CHECK_NEXT(emitLoop());
          case uint16_t(Op::If):
            CHECK_NEXT(emitIf());
          case uint16_t(Op::Else):
            CHECK_NEXT(emitElse());
          case uint16_t(Op::Br):
            CHECK_NEXT(emitBr());
          case uint16_t(Op::BrIf):
            CHECK_NEXT(emitBrIf());
          case uint16_t(Op::BrTable):
            CHECK_NEXT(emitBrTable());
          case uint16_t(Op::Return):
            CHECK_NEXT(emitReturn());
          case uint16_t(Op::Unreachable):
            CHECK(iter_.readUnreachable());
            if (!deadCode_) {
                unreachableTrap();
                deadCode_ = true;
            }
            NEXT();

          // Calls
          case uint16_t(Op::Call):
            CHECK_NEXT(emitCall());
          case uint16_t(Op::CallIndirect):
            CHECK_NEXT(emitCallIndirect());

          // Locals and globals
          case uint16_t(Op::GetLocal):
            CHECK_NEXT(emitGetLocal());
          case uint16_t(Op::SetLocal):
            CHECK_NEXT(emitSetLocal());
          case uint16_t(Op::TeeLocal):
            CHECK_NEXT(emitTeeLocal());
          case uint16_t(Op::GetGlobal):
            CHECK_NEXT(emitGetGlobal());
          case uint16_t(Op::SetGlobal):
            CHECK_NEXT(emitSetGlobal());

          // Select
          case uint16_t(Op::Select):
            CHECK_NEXT(emitSelect());

          // I32
          case uint16_t(Op::I32Const): {
            int32_t i32;
            CHECK(iter_.readI32Const(&i32));
            if (!deadCode_)
                pushI32(i32);
            NEXT();
          }
          case uint16_t(Op::I32Add):
            CHECK_NEXT(emitBinary(emitAddI32, ValType::I32));
          case uint16_t(Op::I32Sub):
            CHECK_NEXT(emitBinary(emitSubtractI32, ValType::I32));
          case uint16_t(Op::I32Mul):
            CHECK_NEXT(emitBinary(emitMultiplyI32, ValType::I32));
          case uint16_t(Op::I32DivS):
            CHECK_NEXT(emitBinary(emitQuotientI32, ValType::I32));
          case uint16_t(Op::I32DivU):
            CHECK_NEXT(emitBinary(emitQuotientU32, ValType::I32));
          case uint16_t(Op::I32RemS):
            CHECK_NEXT(emitBinary(emitRemainderI32, ValType::I32));
          case uint16_t(Op::I32RemU):
            CHECK_NEXT(emitBinary(emitRemainderU32, ValType::I32));
          case uint16_t(Op::I32Eqz):
            CHECK_NEXT(emitConversion(emitEqzI32, ValType::I32, ValType::I32));
          case uint16_t(Op::I32TruncSF32):
            CHECK_NEXT(emitConversionOOM(emitTruncateF32ToI32<false>, ValType::F32, ValType::I32));
          case uint16_t(Op::I32TruncUF32):
            CHECK_NEXT(emitConversionOOM(emitTruncateF32ToI32<true>, ValType::F32, ValType::I32));
          case uint16_t(Op::I32TruncSF64):
            CHECK_NEXT(emitConversionOOM(emitTruncateF64ToI32<false>, ValType::F64, ValType::I32));
          case uint16_t(Op::I32TruncUF64):
            CHECK_NEXT(emitConversionOOM(emitTruncateF64ToI32<true>, ValType::F64, ValType::I32));
          case uint16_t(Op::I32WrapI64):
            CHECK_NEXT(emitConversion(emitWrapI64ToI32, ValType::I64, ValType::I32));
          case uint16_t(Op::I32ReinterpretF32):
            CHECK_NEXT(emitConversion(emitReinterpretF32AsI32, ValType::F32, ValType::I32));
          case uint16_t(Op::I32Clz):
            CHECK_NEXT(emitUnary(emitClzI32, ValType::I32));
          case uint16_t(Op::I32Ctz):
            CHECK_NEXT(emitUnary(emitCtzI32, ValType::I32));
          case uint16_t(Op::I32Popcnt):
            CHECK_NEXT(emitUnary(emitPopcntI32, ValType::I32));
          case uint16_t(Op::I32Or):
            CHECK_NEXT(emitBinary(emitOrI32, ValType::I32));
          case uint16_t(Op::I32And):
            CHECK_NEXT(emitBinary(emitAndI32, ValType::I32));
          case uint16_t(Op::I32Xor):
            CHECK_NEXT(emitBinary(emitXorI32, ValType::I32));
          case uint16_t(Op::I32Shl):
            CHECK_NEXT(emitBinary(emitShlI32, ValType::I32));
          case uint16_t(Op::I32ShrS):
            CHECK_NEXT(emitBinary(emitShrI32, ValType::I32));
          case uint16_t(Op::I32ShrU):
            CHECK_NEXT(emitBinary(emitShrU32, ValType::I32));
          case uint16_t(Op::I32Load8S):
            CHECK_NEXT(emitLoad(ValType::I32, Scalar::Int8));
          case uint16_t(Op::I32Load8U):
            CHECK_NEXT(emitLoad(ValType::I32, Scalar::Uint8));
          case uint16_t(Op::I32Load16S):
            CHECK_NEXT(emitLoad(ValType::I32, Scalar::Int16));
          case uint16_t(Op::I32Load16U):
            CHECK_NEXT(emitLoad(ValType::I32, Scalar::Uint16));
          case uint16_t(Op::I32Load):
            CHECK_NEXT(emitLoad(ValType::I32, Scalar::Int32));
          case uint16_t(Op::I32Store8):
            CHECK_NEXT(emitStore(ValType::I32, Scalar::Int8));
          case uint16_t(Op::I32Store16):
            CHECK_NEXT(emitStore(ValType::I32, Scalar::Int16));
          case uint16_t(Op::I32Store):
            CHECK_NEXT(emitStore(ValType::I32, Scalar::Int32));
          case uint16_t(Op::I32Rotr):
            CHECK_NEXT(emitBinary(emitRotrI32, ValType::I32));
          case uint16_t(Op::I32Rotl):
            CHECK_NEXT(emitBinary(emitRotlI32, ValType::I32));

          // I64
          case uint16_t(Op::I64Const): {
            int64_t i64;
            CHECK(iter_.readI64Const(&i64));
            if (!deadCode_)
                pushI64(i64);
            NEXT();
          }
          case uint16_t(Op::I64Add):
            CHECK_NEXT(emitBinary(emitAddI64, ValType::I64));
          case uint16_t(Op::I64Sub):
            CHECK_NEXT(emitBinary(emitSubtractI64, ValType::I64));
          case uint16_t(Op::I64Mul):
            CHECK_NEXT(emitBinary(emitMultiplyI64, ValType::I64));
          case uint16_t(Op::I64DivS):
#ifdef INT_DIV_I64_CALLOUT
            CHECK_NEXT(emitIntDivCallout(emitDivOrModI64BuiltinCall, SymbolicAddress::DivI64,
                                         ValType::I64));
#else
            CHECK_NEXT(emitBinary(emitQuotientI64, ValType::I64));
#endif
          case uint16_t(Op::I64DivU):
#ifdef INT_DIV_I64_CALLOUT
            CHECK_NEXT(emitIntDivCallout(emitDivOrModI64BuiltinCall, SymbolicAddress::UDivI64,
                                         ValType::I64));
#else
            CHECK_NEXT(emitBinary(emitQuotientU64, ValType::I64));
#endif
          case uint16_t(Op::I64RemS):
#ifdef INT_DIV_I64_CALLOUT
            CHECK_NEXT(emitIntDivCallout(emitDivOrModI64BuiltinCall, SymbolicAddress::ModI64,
                                         ValType::I64));
#else
            CHECK_NEXT(emitBinary(emitRemainderI64, ValType::I64));
#endif
          case uint16_t(Op::I64RemU):
#ifdef INT_DIV_I64_CALLOUT
            CHECK_NEXT(emitIntDivCallout(emitDivOrModI64BuiltinCall, SymbolicAddress::UModI64,
                                         ValType::I64));
#else
            CHECK_NEXT(emitBinary(emitRemainderU64, ValType::I64));
#endif
          case uint16_t(Op::I64TruncSF32):
#ifdef FLOAT_TO_I64_CALLOUT
            CHECK_NEXT(emitCalloutConversionOOM(emitConvertFloatingToInt64Callout,
                                                SymbolicAddress::TruncateDoubleToInt64,
                                                ValType::F32, ValType::I64));
#else
            CHECK_NEXT(emitConversionOOM(emitTruncateF32ToI64<false>, ValType::F32, ValType::I64));
#endif
          case uint16_t(Op::I64TruncUF32):
#ifdef FLOAT_TO_I64_CALLOUT
            CHECK_NEXT(emitCalloutConversionOOM(emitConvertFloatingToInt64Callout,
                                                SymbolicAddress::TruncateDoubleToUint64,
                                                ValType::F32, ValType::I64));
#else
            CHECK_NEXT(emitConversionOOM(emitTruncateF32ToI64<true>, ValType::F32, ValType::I64));
#endif
          case uint16_t(Op::I64TruncSF64):
#ifdef FLOAT_TO_I64_CALLOUT
            CHECK_NEXT(emitCalloutConversionOOM(emitConvertFloatingToInt64Callout,
                                                SymbolicAddress::TruncateDoubleToInt64,
                                                ValType::F64, ValType::I64));
#else
            CHECK_NEXT(emitConversionOOM(emitTruncateF64ToI64<false>, ValType::F64, ValType::I64));
#endif
          case uint16_t(Op::I64TruncUF64):
#ifdef FLOAT_TO_I64_CALLOUT
            CHECK_NEXT(emitCalloutConversionOOM(emitConvertFloatingToInt64Callout,
                                                SymbolicAddress::TruncateDoubleToUint64,
                                                ValType::F64, ValType::I64));
#else
            CHECK_NEXT(emitConversionOOM(emitTruncateF64ToI64<true>, ValType::F64, ValType::I64));
#endif
          case uint16_t(Op::I64ExtendSI32):
            CHECK_NEXT(emitConversion(emitExtendI32ToI64, ValType::I32, ValType::I64));
          case uint16_t(Op::I64ExtendUI32):
            CHECK_NEXT(emitConversion(emitExtendU32ToI64, ValType::I32, ValType::I64));
          case uint16_t(Op::I64ReinterpretF64):
            CHECK_NEXT(emitConversion(emitReinterpretF64AsI64, ValType::F64, ValType::I64));
          case uint16_t(Op::I64Or):
            CHECK_NEXT(emitBinary(emitOrI64, ValType::I64));
          case uint16_t(Op::I64And):
            CHECK_NEXT(emitBinary(emitAndI64, ValType::I64));
          case uint16_t(Op::I64Xor):
            CHECK_NEXT(emitBinary(emitXorI64, ValType::I64));
          case uint16_t(Op::I64Shl):
            CHECK_NEXT(emitBinary(emitShlI64, ValType::I64));
          case uint16_t(Op::I64ShrS):
            CHECK_NEXT(emitBinary(emitShrI64, ValType::I64));
          case uint16_t(Op::I64ShrU):
            CHECK_NEXT(emitBinary(emitShrU64, ValType::I64));
          case uint16_t(Op::I64Rotr):
            CHECK_NEXT(emitBinary(emitRotrI64, ValType::I64));
          case uint16_t(Op::I64Rotl):
            CHECK_NEXT(emitBinary(emitRotlI64, ValType::I64));
          case uint16_t(Op::I64Clz):
            CHECK_NEXT(emitUnary(emitClzI64, ValType::I64));
          case uint16_t(Op::I64Ctz):
            CHECK_NEXT(emitUnary(emitCtzI64, ValType::I64));
          case uint16_t(Op::I64Popcnt):
            CHECK_NEXT(emitUnary(emitPopcntI64, ValType::I64));
          case uint16_t(Op::I64Eqz):
            CHECK_NEXT(emitConversion(emitEqzI64, ValType::I64, ValType::I32));
          case uint16_t(Op::I64Load8S):
            CHECK_NEXT(emitLoad(ValType::I64, Scalar::Int8));
          case uint16_t(Op::I64Load16S):
            CHECK_NEXT(emitLoad(ValType::I64, Scalar::Int16));
          case uint16_t(Op::I64Load32S):
            CHECK_NEXT(emitLoad(ValType::I64, Scalar::Int32));
          case uint16_t(Op::I64Load8U):
            CHECK_NEXT(emitLoad(ValType::I64, Scalar::Uint8));
          case uint16_t(Op::I64Load16U):
            CHECK_NEXT(emitLoad(ValType::I64, Scalar::Uint16));
          case uint16_t(Op::I64Load32U):
            CHECK_NEXT(emitLoad(ValType::I64, Scalar::Uint32));
          case uint16_t(Op::I64Load):
            CHECK_NEXT(emitLoad(ValType::I64, Scalar::Int64));
          case uint16_t(Op::I64Store8):
            CHECK_NEXT(emitStore(ValType::I64, Scalar::Int8));
          case uint16_t(Op::I64Store16):
            CHECK_NEXT(emitStore(ValType::I64, Scalar::Int16));
          case uint16_t(Op::I64Store32):
            CHECK_NEXT(emitStore(ValType::I64, Scalar::Int32));
          case uint16_t(Op::I64Store):
            CHECK_NEXT(emitStore(ValType::I64, Scalar::Int64));

          // F32
          case uint16_t(Op::F32Const): {
            float f32;
            CHECK(iter_.readF32Const(&f32));
            if (!deadCode_)
                pushF32(f32);
            NEXT();
          }
          case uint16_t(Op::F32Add):
            CHECK_NEXT(emitBinary(emitAddF32, ValType::F32));
          case uint16_t(Op::F32Sub):
            CHECK_NEXT(emitBinary(emitSubtractF32, ValType::F32));
          case uint16_t(Op::F32Mul):
            CHECK_NEXT(emitBinary(emitMultiplyF32, ValType::F32));
          case uint16_t(Op::F32Div):
            CHECK_NEXT(emitBinary(emitDivideF32, ValType::F32));
          case uint16_t(Op::F32Min):
            CHECK_NEXT(emitBinary(emitMinF32, ValType::F32));
          case uint16_t(Op::F32Max):
            CHECK_NEXT(emitBinary(emitMaxF32, ValType::F32));
          case uint16_t(Op::F32Neg):
            CHECK_NEXT(emitUnary(emitNegateF32, ValType::F32));
          case uint16_t(Op::F32Abs):
            CHECK_NEXT(emitUnary(emitAbsF32, ValType::F32));
          case uint16_t(Op::F32Sqrt):
            CHECK_NEXT(emitUnary(emitSqrtF32, ValType::F32));
          case uint16_t(Op::F32Ceil):
            CHECK_NEXT(emitUnaryMathBuiltinCall(SymbolicAddress::CeilF, ValType::F32));
          case uint16_t(Op::F32Floor):
            CHECK_NEXT(emitUnaryMathBuiltinCall(SymbolicAddress::FloorF, ValType::F32));
          case uint16_t(Op::F32DemoteF64):
            CHECK_NEXT(emitConversion(emitConvertF64ToF32, ValType::F64, ValType::F32));
          case uint16_t(Op::F32ConvertSI32):
            CHECK_NEXT(emitConversion(emitConvertI32ToF32, ValType::I32, ValType::F32));
          case uint16_t(Op::F32ConvertUI32):
            CHECK_NEXT(emitConversion(emitConvertU32ToF32, ValType::I32, ValType::F32));
          case uint16_t(Op::F32ConvertSI64):
#ifdef I64_TO_FLOAT_CALLOUT
            CHECK_NEXT(emitCalloutConversionOOM(emitConvertInt64ToFloatingCallout,
                                                SymbolicAddress::Int64ToFloat32,
                                                ValType::I64, ValType::F32));
#else
            CHECK_NEXT(emitConversion(emitConvertI64ToF32, ValType::I64, ValType::F32));
#endif
          case uint16_t(Op::F32ConvertUI64):
#ifdef I64_TO_FLOAT_CALLOUT
            CHECK_NEXT(emitCalloutConversionOOM(emitConvertInt64ToFloatingCallout,
                                                SymbolicAddress::Uint64ToFloat32,
                                                ValType::I64, ValType::F32));
#else
            CHECK_NEXT(emitConversion(emitConvertU64ToF32, ValType::I64, ValType::F32));
#endif
          case uint16_t(Op::F32ReinterpretI32):
            CHECK_NEXT(emitConversion(emitReinterpretI32AsF32, ValType::I32, ValType::F32));
          case uint16_t(Op::F32Load):
            CHECK_NEXT(emitLoad(ValType::F32, Scalar::Float32));
          case uint16_t(Op::F32Store):
            CHECK_NEXT(emitStore(ValType::F32, Scalar::Float32));
          case uint16_t(Op::F32CopySign):
            CHECK_NEXT(emitBinary(emitCopysignF32, ValType::F32));
          case uint16_t(Op::F32Nearest):
            CHECK_NEXT(emitUnaryMathBuiltinCall(SymbolicAddress::NearbyIntF, ValType::F32));
          case uint16_t(Op::F32Trunc):
            CHECK_NEXT(emitUnaryMathBuiltinCall(SymbolicAddress::TruncF, ValType::F32));

          // F64
          case uint16_t(Op::F64Const): {
            double f64;
            CHECK(iter_.readF64Const(&f64));
            if (!deadCode_)
                pushF64(f64);
            NEXT();
          }
          case uint16_t(Op::F64Add):
            CHECK_NEXT(emitBinary(emitAddF64, ValType::F64));
          case uint16_t(Op::F64Sub):
            CHECK_NEXT(emitBinary(emitSubtractF64, ValType::F64));
          case uint16_t(Op::F64Mul):
            CHECK_NEXT(emitBinary(emitMultiplyF64, ValType::F64));
          case uint16_t(Op::F64Div):
            CHECK_NEXT(emitBinary(emitDivideF64, ValType::F64));
          case uint16_t(Op::F64Min):
            CHECK_NEXT(emitBinary(emitMinF64, ValType::F64));
          case uint16_t(Op::F64Max):
            CHECK_NEXT(emitBinary(emitMaxF64, ValType::F64));
          case uint16_t(Op::F64Neg):
            CHECK_NEXT(emitUnary(emitNegateF64, ValType::F64));
          case uint16_t(Op::F64Abs):
            CHECK_NEXT(emitUnary(emitAbsF64, ValType::F64));
          case uint16_t(Op::F64Sqrt):
            CHECK_NEXT(emitUnary(emitSqrtF64, ValType::F64));
          case uint16_t(Op::F64Ceil):
            CHECK_NEXT(emitUnaryMathBuiltinCall(SymbolicAddress::CeilD, ValType::F64));
          case uint16_t(Op::F64Floor):
            CHECK_NEXT(emitUnaryMathBuiltinCall(SymbolicAddress::FloorD, ValType::F64));
          case uint16_t(Op::F64PromoteF32):
            CHECK_NEXT(emitConversion(emitConvertF32ToF64, ValType::F32, ValType::F64));
          case uint16_t(Op::F64ConvertSI32):
            CHECK_NEXT(emitConversion(emitConvertI32ToF64, ValType::I32, ValType::F64));
          case uint16_t(Op::F64ConvertUI32):
            CHECK_NEXT(emitConversion(emitConvertU32ToF64, ValType::I32, ValType::F64));
          case uint16_t(Op::F64ConvertSI64):
#ifdef I64_TO_FLOAT_CALLOUT
            CHECK_NEXT(emitCalloutConversionOOM(emitConvertInt64ToFloatingCallout,
                                                SymbolicAddress::Int64ToDouble,
                                                ValType::I64, ValType::F64));
#else
            CHECK_NEXT(emitConversion(emitConvertI64ToF64, ValType::I64, ValType::F64));
#endif
          case uint16_t(Op::F64ConvertUI64):
#ifdef I64_TO_FLOAT_CALLOUT
            CHECK_NEXT(emitCalloutConversionOOM(emitConvertInt64ToFloatingCallout,
                                                SymbolicAddress::Uint64ToDouble,
                                                ValType::I64, ValType::F64));
#else
            CHECK_NEXT(emitConversion(emitConvertU64ToF64, ValType::I64, ValType::F64));
#endif
          case uint16_t(Op::F64Load):
            CHECK_NEXT(emitLoad(ValType::F64, Scalar::Float64));
          case uint16_t(Op::F64Store):
            CHECK_NEXT(emitStore(ValType::F64, Scalar::Float64));
          case uint16_t(Op::F64ReinterpretI64):
            CHECK_NEXT(emitConversion(emitReinterpretI64AsF64, ValType::I64, ValType::F64));
          case uint16_t(Op::F64CopySign):
            CHECK_NEXT(emitBinary(emitCopysignF64, ValType::F64));
          case uint16_t(Op::F64Nearest):
            CHECK_NEXT(emitUnaryMathBuiltinCall(SymbolicAddress::NearbyIntD, ValType::F64));
          case uint16_t(Op::F64Trunc):
            CHECK_NEXT(emitUnaryMathBuiltinCall(SymbolicAddress::TruncD, ValType::F64));

          // Comparisons
          case uint16_t(Op::I32Eq):
            CHECK_NEXT(emitComparison(emitCompareI32, ValType::I32, Assembler::Equal));
          case uint16_t(Op::I32Ne):
            CHECK_NEXT(emitComparison(emitCompareI32, ValType::I32, Assembler::NotEqual));
          case uint16_t(Op::I32LtS):
            CHECK_NEXT(emitComparison(emitCompareI32, ValType::I32, Assembler::LessThan));
          case uint16_t(Op::I32LeS):
            CHECK_NEXT(emitComparison(emitCompareI32, ValType::I32, Assembler::LessThanOrEqual));
          case uint16_t(Op::I32GtS):
            CHECK_NEXT(emitComparison(emitCompareI32, ValType::I32, Assembler::GreaterThan));
          case uint16_t(Op::I32GeS):
            CHECK_NEXT(emitComparison(emitCompareI32, ValType::I32, Assembler::GreaterThanOrEqual));
          case uint16_t(Op::I32LtU):
            CHECK_NEXT(emitComparison(emitCompareI32, ValType::I32, Assembler::Below));
          case uint16_t(Op::I32LeU):
            CHECK_NEXT(emitComparison(emitCompareI32, ValType::I32, Assembler::BelowOrEqual));
          case uint16_t(Op::I32GtU):
            CHECK_NEXT(emitComparison(emitCompareI32, ValType::I32, Assembler::Above));
          case uint16_t(Op::I32GeU):
            CHECK_NEXT(emitComparison(emitCompareI32, ValType::I32, Assembler::AboveOrEqual));
          case uint16_t(Op::I64Eq):
            CHECK_NEXT(emitComparison(emitCompareI64, ValType::I64, Assembler::Equal));
          case uint16_t(Op::I64Ne):
            CHECK_NEXT(emitComparison(emitCompareI64, ValType::I64, Assembler::NotEqual));
          case uint16_t(Op::I64LtS):
            CHECK_NEXT(emitComparison(emitCompareI64, ValType::I64, Assembler::LessThan));
          case uint16_t(Op::I64LeS):
            CHECK_NEXT(emitComparison(emitCompareI64, ValType::I64, Assembler::LessThanOrEqual));
          case uint16_t(Op::I64GtS):
            CHECK_NEXT(emitComparison(emitCompareI64, ValType::I64, Assembler::GreaterThan));
          case uint16_t(Op::I64GeS):
            CHECK_NEXT(emitComparison(emitCompareI64, ValType::I64, Assembler::GreaterThanOrEqual));
          case uint16_t(Op::I64LtU):
            CHECK_NEXT(emitComparison(emitCompareI64, ValType::I64, Assembler::Below));
          case uint16_t(Op::I64LeU):
            CHECK_NEXT(emitComparison(emitCompareI64, ValType::I64, Assembler::BelowOrEqual));
          case uint16_t(Op::I64GtU):
            CHECK_NEXT(emitComparison(emitCompareI64, ValType::I64, Assembler::Above));
          case uint16_t(Op::I64GeU):
            CHECK_NEXT(emitComparison(emitCompareI64, ValType::I64, Assembler::AboveOrEqual));
          case uint16_t(Op::F32Eq):
            CHECK_NEXT(emitComparison(emitCompareF32, ValType::F32, Assembler::DoubleEqual));
          case uint16_t(Op::F32Ne):
            CHECK_NEXT(emitComparison(emitCompareF32, ValType::F32, Assembler::DoubleNotEqualOrUnordered));
          case uint16_t(Op::F32Lt):
            CHECK_NEXT(emitComparison(emitCompareF32, ValType::F32, Assembler::DoubleLessThan));
          case uint16_t(Op::F32Le):
            CHECK_NEXT(emitComparison(emitCompareF32, ValType::F32, Assembler::DoubleLessThanOrEqual));
          case uint16_t(Op::F32Gt):
            CHECK_NEXT(emitComparison(emitCompareF32, ValType::F32, Assembler::DoubleGreaterThan));
          case uint16_t(Op::F32Ge):
            CHECK_NEXT(emitComparison(emitCompareF32, ValType::F32, Assembler::DoubleGreaterThanOrEqual));
          case uint16_t(Op::F64Eq):
            CHECK_NEXT(emitComparison(emitCompareF64, ValType::F64, Assembler::DoubleEqual));
          case uint16_t(Op::F64Ne):
            CHECK_NEXT(emitComparison(emitCompareF64, ValType::F64, Assembler::DoubleNotEqualOrUnordered));
          case uint16_t(Op::F64Lt):
            CHECK_NEXT(emitComparison(emitCompareF64, ValType::F64, Assembler::DoubleLessThan));
          case uint16_t(Op::F64Le):
            CHECK_NEXT(emitComparison(emitCompareF64, ValType::F64, Assembler::DoubleLessThanOrEqual));
          case uint16_t(Op::F64Gt):
            CHECK_NEXT(emitComparison(emitCompareF64, ValType::F64, Assembler::DoubleGreaterThan));
          case uint16_t(Op::F64Ge):
            CHECK_NEXT(emitComparison(emitCompareF64, ValType::F64, Assembler::DoubleGreaterThanOrEqual));

          // Memory Related
          case uint16_t(Op::GrowMemory):
            CHECK_NEXT(emitGrowMemory());
          case uint16_t(Op::CurrentMemory):
            CHECK_NEXT(emitCurrentMemory());

          default:
            return iter_.unrecognizedOpcode(&op);
        }

#undef CHECK
#undef NEXT
#undef CHECK_NEXT
#undef emitBinary
#undef emitUnary
#undef emitComparison
#undef emitConversion
#undef emitConversionOOM
#undef emitCalloutConversionOOM

        MOZ_CRASH("unreachable");
    }

    MOZ_CRASH("unreachable");
}

bool
BaseCompiler::emitFunction()
{
    beginFunction();

    if (!emitBody())
        return false;

    if (!endFunction())
        return false;

    return true;
}

BaseCompiler::BaseCompiler(const ModuleEnvironment& env,
                           Decoder& decoder,
                           const FuncBytes& func,
                           const ValTypeVector& locals,
                           bool debugEnabled,
                           TempAllocator* alloc,
                           MacroAssembler* masm)
    : env_(env),
      iter_(env, decoder),
      func_(func),
      lastReadCallSite_(0),
      alloc_(*alloc),
      locals_(locals),
      localSize_(0),
      varLow_(0),
      varHigh_(0),
      maxFramePushed_(0),
      deadCode_(false),
      debugEnabled_(debugEnabled),
      bceSafe_(0),
      stackAddOffset_(0),
      latentOp_(LatentOp::None),
      latentType_(ValType::I32),
      latentIntCmp_(Assembler::Equal),
      latentDoubleCmp_(Assembler::DoubleEqual),
      masm(*masm),
      availGPR_(GeneralRegisterSet::All()),
      availFPU_(FloatRegisterSet::All()),
#ifdef DEBUG
      scratchRegisterTaken_(false),
#endif
#ifdef JS_CODEGEN_X64
      specific_rax(RegI64(Register64(rax))),
      specific_rcx(RegI64(Register64(rcx))),
      specific_rdx(RegI64(Register64(rdx))),
#endif
#if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_X86)
      specific_eax(RegI32(eax)),
      specific_ecx(RegI32(ecx)),
      specific_edx(RegI32(edx)),
#endif
#ifdef JS_CODEGEN_X86
      singleByteRegs_(GeneralRegisterSet(Registers::SingleByteRegs)),
      abiReturnRegI64(RegI64(Register64(edx, eax))),
#endif
#ifdef JS_CODEGEN_ARM
      abiReturnRegI64(ReturnReg64),
#endif
      joinRegI32(RegI32(ReturnReg)),
      joinRegI64(RegI64(ReturnReg64)),
      joinRegF32(RegF32(ReturnFloat32Reg)),
      joinRegF64(RegF64(ReturnDoubleReg))
{
    // jit/RegisterAllocator.h: RegisterAllocator::RegisterAllocator()

#if defined(JS_CODEGEN_X64)
    availGPR_.take(HeapReg);
#elif defined(JS_CODEGEN_ARM)
    availGPR_.take(HeapReg);
    availGPR_.take(ScratchRegARM);
#elif defined(JS_CODEGEN_ARM64)
    availGPR_.take(HeapReg);
    availGPR_.take(HeapLenReg);
#elif defined(JS_CODEGEN_X86)
    availGPR_.take(ScratchRegX86);
#elif defined(JS_CODEGEN_MIPS32) || defined(JS_CODEGEN_MIPS64)
    availGPR_.take(HeapReg);
#endif
    availGPR_.take(FramePointer);

#ifdef DEBUG
    setupRegisterLeakCheck();
#endif
}

bool
BaseCompiler::init()
{
    if (!SigD_.append(ValType::F64))
        return false;
    if (!SigF_.append(ValType::F32))
        return false;
    if (!SigP_.append(MIRType::Pointer))
        return false;
    if (!SigPI_.append(MIRType::Pointer) || !SigPI_.append(MIRType::Int32))
        return false;
    if (!SigI64I64_.append(ValType::I64) || !SigI64I64_.append(ValType::I64))
        return false;

    const ValTypeVector& args = func_.sig().args();

    if (!localInfo_.resize(locals_.length()))
        return false;

    BaseLocalIter i(locals_, args.length(), debugEnabled_);
    varLow_ = i.reservedSize();
    for (; !i.done() && i.index() < args.length(); i++) {
        MOZ_ASSERT(i.isArg());
        Local& l = localInfo_[i.index()];
        l.init(i.mirType(), i.frameOffset());
        varLow_ = i.currentLocalSize();
    }

    varHigh_ = varLow_;
    for (; !i.done() ; i++) {
        MOZ_ASSERT(!i.isArg());
        Local& l = localInfo_[i.index()];
        l.init(i.mirType(), i.frameOffset());
        varHigh_ = i.currentLocalSize();
    }

    localSize_ = AlignBytes(varHigh_, 16u);

    addInterruptCheck();

    return true;
}

FuncOffsets
BaseCompiler::finish()
{
    MOZ_ASSERT(done(), "all bytes must be consumed");
    MOZ_ASSERT(func_.callSiteLineNums().length() == lastReadCallSite_);

    masm.flushBuffer();

    return offsets_;
}

} // wasm
} // js

bool
js::wasm::BaselineCanCompile()
{
    // On all platforms we require signals for Wasm.
    // If we made it this far we must have signals.
    MOZ_RELEASE_ASSERT(wasm::HaveSignalHandlers());

#if defined(JS_CODEGEN_ARM)
    // Simplifying assumption: require SDIV and UDIV.
    //
    // I have no good data on ARM populations allowing me to say that
    // X% of devices in the market implement SDIV and UDIV.  However,
    // they are definitely implemented on the Cortex-A7 and Cortex-A15
    // and on all ARMv8 systems.
    if (!HasIDIV())
        return false;
#endif

#if defined(JS_CODEGEN_X64) || defined(JS_CODEGEN_X86) || defined(JS_CODEGEN_ARM)
    return true;
#else
    return false;
#endif
}

bool
js::wasm::BaselineCompileFunction(CompileTask* task, FuncCompileUnit* unit, UniqueChars *error)
{
    MOZ_ASSERT(task->tier() == Tier::Baseline);
    MOZ_ASSERT(task->env().kind == ModuleKind::Wasm);

    const FuncBytes& func = unit->func();

    Decoder d(func.bytes().begin(), func.bytes().end(), func.lineOrBytecode(), error);

    // Build the local types vector.

    ValTypeVector locals;
    if (!locals.appendAll(func.sig().args()))
        return false;
    if (!DecodeLocalEntries(d, task->env().kind, &locals))
        return false;

    // The MacroAssembler will sometimes access the jitContext.

    JitContext jitContext(&task->alloc());

    // One-pass baseline compilation.

    BaseCompiler f(task->env(), d, func, locals, task->debugEnabled(), &task->alloc(), &task->masm());
    if (!f.init())
        return false;

    if (!f.emitFunction())
        return false;

    unit->finish(f.finish());
    return true;
}

#undef INT_DIV_I64_CALLOUT
#undef I64_TO_FLOAT_CALLOUT
#undef FLOAT_TO_I64_CALLOUT
