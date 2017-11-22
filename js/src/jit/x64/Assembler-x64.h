/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef jit_x64_Assembler_x64_h
#define jit_x64_Assembler_x64_h

#include "mozilla/ArrayUtils.h"

#include "jit/IonCode.h"
#include "jit/JitCompartment.h"
#include "jit/shared/Assembler-shared.h"

namespace js {
namespace jit {

static constexpr Register rax { X86Encoding::rax };
static constexpr Register rbx { X86Encoding::rbx };
static constexpr Register rcx { X86Encoding::rcx };
static constexpr Register rdx { X86Encoding::rdx };
static constexpr Register rsi { X86Encoding::rsi };
static constexpr Register rdi { X86Encoding::rdi };
static constexpr Register rbp { X86Encoding::rbp };
static constexpr Register r8  { X86Encoding::r8  };
static constexpr Register r9  { X86Encoding::r9  };
static constexpr Register r10 { X86Encoding::r10 };
static constexpr Register r11 { X86Encoding::r11 };
static constexpr Register r12 { X86Encoding::r12 };
static constexpr Register r13 { X86Encoding::r13 };
static constexpr Register r14 { X86Encoding::r14 };
static constexpr Register r15 { X86Encoding::r15 };
static constexpr Register rsp { X86Encoding::rsp };

static constexpr FloatRegister xmm0 = FloatRegister(X86Encoding::xmm0, FloatRegisters::Double);
static constexpr FloatRegister xmm1 = FloatRegister(X86Encoding::xmm1, FloatRegisters::Double);
static constexpr FloatRegister xmm2 = FloatRegister(X86Encoding::xmm2, FloatRegisters::Double);
static constexpr FloatRegister xmm3 = FloatRegister(X86Encoding::xmm3, FloatRegisters::Double);
static constexpr FloatRegister xmm4 = FloatRegister(X86Encoding::xmm4, FloatRegisters::Double);
static constexpr FloatRegister xmm5 = FloatRegister(X86Encoding::xmm5, FloatRegisters::Double);
static constexpr FloatRegister xmm6 = FloatRegister(X86Encoding::xmm6, FloatRegisters::Double);
static constexpr FloatRegister xmm7 = FloatRegister(X86Encoding::xmm7, FloatRegisters::Double);
static constexpr FloatRegister xmm8 = FloatRegister(X86Encoding::xmm8, FloatRegisters::Double);
static constexpr FloatRegister xmm9 = FloatRegister(X86Encoding::xmm9, FloatRegisters::Double);
static constexpr FloatRegister xmm10 = FloatRegister(X86Encoding::xmm10, FloatRegisters::Double);
static constexpr FloatRegister xmm11 = FloatRegister(X86Encoding::xmm11, FloatRegisters::Double);
static constexpr FloatRegister xmm12 = FloatRegister(X86Encoding::xmm12, FloatRegisters::Double);
static constexpr FloatRegister xmm13 = FloatRegister(X86Encoding::xmm13, FloatRegisters::Double);
static constexpr FloatRegister xmm14 = FloatRegister(X86Encoding::xmm14, FloatRegisters::Double);
static constexpr FloatRegister xmm15 = FloatRegister(X86Encoding::xmm15, FloatRegisters::Double);

// X86-common synonyms.
static constexpr Register eax = rax;
static constexpr Register ebx = rbx;
static constexpr Register ecx = rcx;
static constexpr Register edx = rdx;
static constexpr Register esi = rsi;
static constexpr Register edi = rdi;
static constexpr Register ebp = rbp;
static constexpr Register esp = rsp;

static constexpr Register InvalidReg { X86Encoding::invalid_reg };
static constexpr FloatRegister InvalidFloatReg = FloatRegister();

static constexpr Register StackPointer = rsp;
static constexpr Register FramePointer = rbp;
static constexpr Register JSReturnReg = rcx;
// Avoid, except for assertions.
static constexpr Register JSReturnReg_Type = JSReturnReg;
static constexpr Register JSReturnReg_Data = JSReturnReg;

static constexpr Register ScratchReg = r11;

// Helper class for ScratchRegister usage. Asserts that only one piece
// of code thinks it has exclusive ownership of the scratch register.
struct ScratchRegisterScope : public AutoRegisterScope
{
    explicit ScratchRegisterScope(MacroAssembler& masm)
      : AutoRegisterScope(masm, ScratchReg)
    { }
};

static constexpr Register ReturnReg = rax;
static constexpr Register HeapReg = r15;
static constexpr Register64 ReturnReg64(rax);
static constexpr FloatRegister ReturnFloat32Reg = FloatRegister(X86Encoding::xmm0, FloatRegisters::Single);
static constexpr FloatRegister ReturnDoubleReg = FloatRegister(X86Encoding::xmm0, FloatRegisters::Double);
static constexpr FloatRegister ReturnSimd128Reg = FloatRegister(X86Encoding::xmm0, FloatRegisters::Simd128);
static constexpr FloatRegister ScratchFloat32Reg = FloatRegister(X86Encoding::xmm15, FloatRegisters::Single);
static constexpr FloatRegister ScratchDoubleReg = FloatRegister(X86Encoding::xmm15, FloatRegisters::Double);
static constexpr FloatRegister ScratchSimd128Reg = xmm15;

// Avoid rbp, which is the FramePointer, which is unavailable in some modes.
static constexpr Register ArgumentsRectifierReg = r8;
static constexpr Register CallTempReg0 = rax;
static constexpr Register CallTempReg1 = rdi;
static constexpr Register CallTempReg2 = rbx;
static constexpr Register CallTempReg3 = rcx;
static constexpr Register CallTempReg4 = rsi;
static constexpr Register CallTempReg5 = rdx;

// Different argument registers for WIN64
#if defined(_WIN64)
static constexpr Register IntArgReg0 = rcx;
static constexpr Register IntArgReg1 = rdx;
static constexpr Register IntArgReg2 = r8;
static constexpr Register IntArgReg3 = r9;
static constexpr uint32_t NumIntArgRegs = 4;
// Use "const" instead of constexpr here to work around a bug
// of VS2015 Update 1. See bug 1229604.
static const Register IntArgRegs[NumIntArgRegs] = { rcx, rdx, r8, r9 };

static const Register CallTempNonArgRegs[] = { rax, rdi, rbx, rsi };
static const uint32_t NumCallTempNonArgRegs =
    mozilla::ArrayLength(CallTempNonArgRegs);

static constexpr FloatRegister FloatArgReg0 = xmm0;
static constexpr FloatRegister FloatArgReg1 = xmm1;
static constexpr FloatRegister FloatArgReg2 = xmm2;
static constexpr FloatRegister FloatArgReg3 = xmm3;
static const uint32_t NumFloatArgRegs = 4;
static constexpr FloatRegister FloatArgRegs[NumFloatArgRegs] = { xmm0, xmm1, xmm2, xmm3 };
#else
static constexpr Register IntArgReg0 = rdi;
static constexpr Register IntArgReg1 = rsi;
static constexpr Register IntArgReg2 = rdx;
static constexpr Register IntArgReg3 = rcx;
static constexpr Register IntArgReg4 = r8;
static constexpr Register IntArgReg5 = r9;
static constexpr uint32_t NumIntArgRegs = 6;
static const Register IntArgRegs[NumIntArgRegs] = { rdi, rsi, rdx, rcx, r8, r9 };

// Use "const" instead of constexpr here to work around a bug
// of VS2015 Update 1. See bug 1229604.
static const Register CallTempNonArgRegs[] = { rax, rbx };
static const uint32_t NumCallTempNonArgRegs =
    mozilla::ArrayLength(CallTempNonArgRegs);

static constexpr FloatRegister FloatArgReg0 = xmm0;
static constexpr FloatRegister FloatArgReg1 = xmm1;
static constexpr FloatRegister FloatArgReg2 = xmm2;
static constexpr FloatRegister FloatArgReg3 = xmm3;
static constexpr FloatRegister FloatArgReg4 = xmm4;
static constexpr FloatRegister FloatArgReg5 = xmm5;
static constexpr FloatRegister FloatArgReg6 = xmm6;
static constexpr FloatRegister FloatArgReg7 = xmm7;
static constexpr uint32_t NumFloatArgRegs = 8;
static constexpr FloatRegister FloatArgRegs[NumFloatArgRegs] = { xmm0, xmm1, xmm2, xmm3, xmm4, xmm5, xmm6, xmm7 };
#endif

// Registers used in the GenerateFFIIonExit Enable Activation block.
static constexpr Register WasmIonExitRegCallee = r10;
static constexpr Register WasmIonExitRegE0 = rax;
static constexpr Register WasmIonExitRegE1 = rdi;

// Registers used in the GenerateFFIIonExit Disable Activation block.
static constexpr Register WasmIonExitRegReturnData = ecx;
static constexpr Register WasmIonExitRegReturnType = ecx;
static constexpr Register WasmIonExitTlsReg = r14;
static constexpr Register WasmIonExitRegD0 = rax;
static constexpr Register WasmIonExitRegD1 = rdi;
static constexpr Register WasmIonExitRegD2 = rbx;

// Registerd used in RegExpMatcher instruction (do not use JSReturnOperand).
static constexpr Register RegExpMatcherRegExpReg = CallTempReg0;
static constexpr Register RegExpMatcherStringReg = CallTempReg1;
static constexpr Register RegExpMatcherLastIndexReg = CallTempReg2;

// Registerd used in RegExpTester instruction (do not use ReturnReg).
static constexpr Register RegExpTesterRegExpReg = CallTempReg1;
static constexpr Register RegExpTesterStringReg = CallTempReg2;
static constexpr Register RegExpTesterLastIndexReg = CallTempReg3;

class ABIArgGenerator
{
#if defined(XP_WIN)
    unsigned regIndex_;
#else
    unsigned intRegIndex_;
    unsigned floatRegIndex_;
#endif
    uint32_t stackOffset_;
    ABIArg current_;

  public:
    ABIArgGenerator();
    ABIArg next(MIRType argType);
    ABIArg& current() { return current_; }
    uint32_t stackBytesConsumedSoFar() const { return stackOffset_; }
};

// Avoid r11, which is the MacroAssembler's ScratchReg.
static constexpr Register ABINonArgReg0 = rax;
static constexpr Register ABINonArgReg1 = rbx;
static constexpr Register ABINonArgReg2 = r10;

// Note: these three registers are all guaranteed to be different
static constexpr Register ABINonArgReturnReg0 = r10;
static constexpr Register ABINonArgReturnReg1 = r12;
static constexpr Register ABINonVolatileReg = r13;

// TLS pointer argument register for WebAssembly functions. This must not alias
// any other register used for passing function arguments or return values.
// Preserved by WebAssembly functions.
static constexpr Register WasmTlsReg = r14;

// Registers used for asm.js/wasm table calls. These registers must be disjoint
// from the ABI argument registers, WasmTlsReg and each other.
static constexpr Register WasmTableCallScratchReg = ABINonArgReg0;
static constexpr Register WasmTableCallSigReg = ABINonArgReg1;
static constexpr Register WasmTableCallIndexReg = ABINonArgReg2;

static constexpr Register OsrFrameReg = IntArgReg3;

static constexpr Register PreBarrierReg = rdx;

static constexpr uint32_t ABIStackAlignment = 16;
static constexpr uint32_t CodeAlignment = 16;
static constexpr uint32_t JitStackAlignment = 16;

static constexpr uint32_t JitStackValueAlignment = JitStackAlignment / sizeof(Value);
static_assert(JitStackAlignment % sizeof(Value) == 0 && JitStackValueAlignment >= 1,
  "Stack alignment should be a non-zero multiple of sizeof(Value)");

// This boolean indicates whether we support SIMD instructions flavoured for
// this architecture or not. Rather than a method in the LIRGenerator, it is
// here such that it is accessible from the entire codebase. Once full support
// for SIMD is reached on all tier-1 platforms, this constant can be deleted.
static constexpr bool SupportsSimd = true;
static constexpr uint32_t SimdMemoryAlignment = 16;

static_assert(CodeAlignment % SimdMemoryAlignment == 0,
  "Code alignment should be larger than any of the alignments which are used for "
  "the constant sections of the code buffer.  Thus it should be larger than the "
  "alignment for SIMD constants.");

static_assert(JitStackAlignment % SimdMemoryAlignment == 0,
  "Stack alignment should be larger than any of the alignments which are used for "
  "spilled values.  Thus it should be larger than the alignment for SIMD accesses.");

static const uint32_t WasmStackAlignment = SimdMemoryAlignment;

static const Scale ScalePointer = TimesEight;

} // namespace jit
} // namespace js

#include "jit/x86-shared/Assembler-x86-shared.h"

namespace js {
namespace jit {

// Return operand from a JS -> JS call.
static constexpr ValueOperand JSReturnOperand = ValueOperand(JSReturnReg);

class Assembler : public AssemblerX86Shared
{
    // x64 jumps may need extra bits of relocation, because a jump may extend
    // beyond the signed 32-bit range. To account for this we add an extended
    // jump table at the bottom of the instruction stream, and if a jump
    // overflows its range, it will redirect here.
    //
    // In our relocation table, we store two offsets instead of one: the offset
    // to the original jump, and an offset to the extended jump if we will need
    // to use it instead. The offsets are stored as:
    //    [unsigned] Unsigned offset to short jump, from the start of the code.
    //    [unsigned] Unsigned offset to the extended jump, from the start of
    //               the jump table, in units of SizeOfJumpTableEntry.
    //
    // The start of the relocation table contains the offset from the code
    // buffer to the start of the extended jump table.
    //
    // Each entry in this table is a jmp [rip], followed by a ud2 to hint to the
    // hardware branch predictor that there is no fallthrough, followed by the
    // eight bytes containing an immediate address. This comes out to 16 bytes.
    //    +1 byte for opcode
    //    +1 byte for mod r/m
    //    +4 bytes for rip-relative offset (2)
    //    +2 bytes for ud2 instruction
    //    +8 bytes for 64-bit address
    //
    static const uint32_t SizeOfExtendedJump = 1 + 1 + 4 + 2 + 8;
    static const uint32_t SizeOfJumpTableEntry = 16;

    uint32_t extendedJumpTable_;

    static JitCode* CodeFromJump(JitCode* code, uint8_t* jump);

  private:
    void writeRelocation(JmpSrc src, Relocation::Kind reloc);
    void addPendingJump(JmpSrc src, ImmPtr target, Relocation::Kind reloc);

  protected:
    size_t addPatchableJump(JmpSrc src, Relocation::Kind reloc);

  public:
    using AssemblerX86Shared::j;
    using AssemblerX86Shared::jmp;
    using AssemblerX86Shared::push;
    using AssemblerX86Shared::pop;
    using AssemblerX86Shared::vmovq;

    static uint8_t* PatchableJumpAddress(JitCode* code, size_t index);
    static void PatchJumpEntry(uint8_t* entry, uint8_t* target, ReprotectCode reprotect);

    Assembler()
      : extendedJumpTable_(0)
    {
    }

    static void TraceJumpRelocations(JSTracer* trc, JitCode* code, CompactBufferReader& reader);

    // The buffer is about to be linked, make sure any constant pools or excess
    // bookkeeping has been flushed to the instruction stream.
    void finish();

    // Copy the assembly code to the given buffer, and perform any pending
    // relocations relying on the target address.
    void executableCopy(uint8_t* buffer, bool flushICache = true);

    // Actual assembly emitting functions.

    void push(const ImmGCPtr ptr) {
        movq(ptr, ScratchReg);
        push(ScratchReg);
    }
    void push(const ImmWord ptr) {
        // We often end up with ImmWords that actually fit into int32.
        // Be aware of the sign extension behavior.
        if (ptr.value <= INT32_MAX) {
            push(Imm32(ptr.value));
        } else {
            movq(ptr, ScratchReg);
            push(ScratchReg);
        }
    }
    void push(ImmPtr imm) {
        push(ImmWord(uintptr_t(imm.value)));
    }
    void push(FloatRegister src) {
        subq(Imm32(sizeof(double)), StackPointer);
        vmovsd(src, Address(StackPointer, 0));
    }
    CodeOffset pushWithPatch(ImmWord word) {
        CodeOffset label = movWithPatch(word, ScratchReg);
        push(ScratchReg);
        return label;
    }

    void pop(FloatRegister src) {
        vmovsd(Address(StackPointer, 0), src);
        addq(Imm32(sizeof(double)), StackPointer);
    }

    CodeOffset movWithPatch(ImmWord word, Register dest) {
        masm.movq_i64r(word.value, dest.encoding());
        return CodeOffset(masm.currentOffset());
    }
    CodeOffset movWithPatch(ImmPtr imm, Register dest) {
        return movWithPatch(ImmWord(uintptr_t(imm.value)), dest);
    }

    // This is for patching during code generation, not after.
    void patchAddq(CodeOffset offset, int32_t n) {
        unsigned char* code = masm.data();
        X86Encoding::SetInt32(code + offset.offset(), n);
    }

    // Load an ImmWord value into a register. Note that this instruction will
    // attempt to optimize its immediate field size. When a full 64-bit
    // immediate is needed for a relocation, use movWithPatch.
    void movq(ImmWord word, Register dest) {
        // Load a 64-bit immediate into a register. If the value falls into
        // certain ranges, we can use specialized instructions which have
        // smaller encodings.
        if (word.value <= UINT32_MAX) {
            // movl has a 32-bit unsigned (effectively) immediate field.
            masm.movl_i32r((uint32_t)word.value, dest.encoding());
        } else if ((intptr_t)word.value >= INT32_MIN && (intptr_t)word.value <= INT32_MAX) {
            // movq has a 32-bit signed immediate field.
            masm.movq_i32r((int32_t)(intptr_t)word.value, dest.encoding());
        } else {
            // Otherwise use movabs.
            masm.movq_i64r(word.value, dest.encoding());
        }
    }
    void movq(ImmPtr imm, Register dest) {
        movq(ImmWord(uintptr_t(imm.value)), dest);
    }
    void movq(ImmGCPtr ptr, Register dest) {
        masm.movq_i64r(uintptr_t(ptr.value), dest.encoding());
        writeDataRelocation(ptr);
    }
    void movq(const Operand& src, Register dest) {
        switch (src.kind()) {
          case Operand::REG:
            masm.movq_rr(src.reg(), dest.encoding());
            break;
          case Operand::MEM_REG_DISP:
            masm.movq_mr(src.disp(), src.base(), dest.encoding());
            break;
          case Operand::MEM_SCALE:
            masm.movq_mr(src.disp(), src.base(), src.index(), src.scale(), dest.encoding());
            break;
          case Operand::MEM_ADDRESS32:
            masm.movq_mr(src.address(), dest.encoding());
            break;
          default:
            MOZ_CRASH("unexpected operand kind");
        }
    }
    void movq(Register src, const Operand& dest) {
        switch (dest.kind()) {
          case Operand::REG:
            masm.movq_rr(src.encoding(), dest.reg());
            break;
          case Operand::MEM_REG_DISP:
            masm.movq_rm(src.encoding(), dest.disp(), dest.base());
            break;
          case Operand::MEM_SCALE:
            masm.movq_rm(src.encoding(), dest.disp(), dest.base(), dest.index(), dest.scale());
            break;
          case Operand::MEM_ADDRESS32:
            masm.movq_rm(src.encoding(), dest.address());
            break;
          default:
            MOZ_CRASH("unexpected operand kind");
        }
    }
    void movq(Imm32 imm32, const Operand& dest) {
        switch (dest.kind()) {
          case Operand::REG:
            masm.movl_i32r(imm32.value, dest.reg());
            break;
          case Operand::MEM_REG_DISP:
            masm.movq_i32m(imm32.value, dest.disp(), dest.base());
            break;
          case Operand::MEM_SCALE:
            masm.movq_i32m(imm32.value, dest.disp(), dest.base(), dest.index(), dest.scale());
            break;
          case Operand::MEM_ADDRESS32:
            masm.movq_i32m(imm32.value, dest.address());
            break;
          default:
            MOZ_CRASH("unexpected operand kind");
        }
    }
    void vmovq(Register src, FloatRegister dest) {
        masm.vmovq_rr(src.encoding(), dest.encoding());
    }
    void vmovq(FloatRegister src, Register dest) {
        masm.vmovq_rr(src.encoding(), dest.encoding());
    }
    void movq(Register src, Register dest) {
        masm.movq_rr(src.encoding(), dest.encoding());
    }

    void cmovzq(const Operand& src, Register dest) {
        switch (src.kind()) {
          case Operand::REG:
            masm.cmovzq_rr(src.reg(), dest.encoding());
            break;
          case Operand::MEM_REG_DISP:
            masm.cmovzq_mr(src.disp(), src.base(), dest.encoding());
            break;
          case Operand::MEM_SCALE:
            masm.cmovzq_mr(src.disp(), src.base(), src.index(), src.scale(), dest.encoding());
            break;
          default:
            MOZ_CRASH("unexpected operand kind");
        }
    }

    void xchgq(Register src, Register dest) {
        masm.xchgq_rr(src.encoding(), dest.encoding());
    }

    void movsbq(const Operand& src, Register dest) {
        switch (src.kind()) {
          case Operand::MEM_REG_DISP:
            masm.movsbq_mr(src.disp(), src.base(), dest.encoding());
            break;
          case Operand::MEM_SCALE:
            masm.movsbq_mr(src.disp(), src.base(), src.index(), src.scale(), dest.encoding());
            break;
          default:
            MOZ_CRASH("unexpected operand kind");
        }
    }

    void movzbq(const Operand& src, Register dest) {
        // movzbl zero-extends to 64 bits and is one byte smaller, so use that
        // instead.
        movzbl(src, dest);
    }

    void movswq(const Operand& src, Register dest) {
        switch (src.kind()) {
          case Operand::MEM_REG_DISP:
            masm.movswq_mr(src.disp(), src.base(), dest.encoding());
            break;
          case Operand::MEM_SCALE:
            masm.movswq_mr(src.disp(), src.base(), src.index(), src.scale(), dest.encoding());
            break;
          default:
            MOZ_CRASH("unexpected operand kind");
        }
    }

    void movzwq(const Operand& src, Register dest) {
        // movzwl zero-extends to 64 bits and is one byte smaller, so use that
        // instead.
        movzwl(src, dest);
    }

    void movslq(Register src, Register dest) {
        masm.movslq_rr(src.encoding(), dest.encoding());
    }
    void movslq(const Operand& src, Register dest) {
        switch (src.kind()) {
          case Operand::REG:
            masm.movslq_rr(src.reg(), dest.encoding());
            break;
          case Operand::MEM_REG_DISP:
            masm.movslq_mr(src.disp(), src.base(), dest.encoding());
            break;
          case Operand::MEM_SCALE:
            masm.movslq_mr(src.disp(), src.base(), src.index(), src.scale(), dest.encoding());
            break;
          default:
            MOZ_CRASH("unexpected operand kind");
        }
    }

    void andq(Register src, Register dest) {
        masm.andq_rr(src.encoding(), dest.encoding());
    }
    void andq(Imm32 imm, Register dest) {
        masm.andq_ir(imm.value, dest.encoding());
    }
    void andq(const Operand& src, Register dest) {
        switch (src.kind()) {
          case Operand::REG:
            masm.andq_rr(src.reg(), dest.encoding());
            break;
          case Operand::MEM_REG_DISP:
            masm.andq_mr(src.disp(), src.base(), dest.encoding());
            break;
          case Operand::MEM_SCALE:
            masm.andq_mr(src.disp(), src.base(), src.index(), src.scale(), dest.encoding());
            break;
          case Operand::MEM_ADDRESS32:
            masm.andq_mr(src.address(), dest.encoding());
            break;
          default:
            MOZ_CRASH("unexpected operand kind");
        }
    }

    void addq(Imm32 imm, Register dest) {
        masm.addq_ir(imm.value, dest.encoding());
    }
    CodeOffset addqWithPatch(Imm32 imm, Register dest) {
        masm.addq_i32r(imm.value, dest.encoding());
        return CodeOffset(masm.currentOffset());
    }
    void addq(Imm32 imm, const Operand& dest) {
        switch (dest.kind()) {
          case Operand::REG:
            masm.addq_ir(imm.value, dest.reg());
            break;
          case Operand::MEM_REG_DISP:
            masm.addq_im(imm.value, dest.disp(), dest.base());
            break;
          case Operand::MEM_ADDRESS32:
            masm.addq_im(imm.value, dest.address());
            break;
          default:
            MOZ_CRASH("unexpected operand kind");
        }
    }
    void addq(Register src, Register dest) {
        masm.addq_rr(src.encoding(), dest.encoding());
    }
    void addq(const Operand& src, Register dest) {
        switch (src.kind()) {
          case Operand::REG:
            masm.addq_rr(src.reg(), dest.encoding());
            break;
          case Operand::MEM_REG_DISP:
            masm.addq_mr(src.disp(), src.base(), dest.encoding());
            break;
          case Operand::MEM_ADDRESS32:
            masm.addq_mr(src.address(), dest.encoding());
            break;
          default:
            MOZ_CRASH("unexpected operand kind");
        }
    }

    void subq(Imm32 imm, Register dest) {
        masm.subq_ir(imm.value, dest.encoding());
    }
    void subq(Register src, Register dest) {
        masm.subq_rr(src.encoding(), dest.encoding());
    }
    void subq(const Operand& src, Register dest) {
        switch (src.kind()) {
          case Operand::REG:
            masm.subq_rr(src.reg(), dest.encoding());
            break;
          case Operand::MEM_REG_DISP:
            masm.subq_mr(src.disp(), src.base(), dest.encoding());
            break;
          case Operand::MEM_ADDRESS32:
            masm.subq_mr(src.address(), dest.encoding());
            break;
          default:
            MOZ_CRASH("unexpected operand kind");
        }
    }
    void subq(Register src, const Operand& dest) {
        switch (dest.kind()) {
          case Operand::REG:
            masm.subq_rr(src.encoding(), dest.reg());
            break;
          case Operand::MEM_REG_DISP:
            masm.subq_rm(src.encoding(), dest.disp(), dest.base());
            break;
          default:
            MOZ_CRASH("unexpected operand kind");
        }
    }
    void shlq(Imm32 imm, Register dest) {
        masm.shlq_ir(imm.value, dest.encoding());
    }
    void shrq(Imm32 imm, Register dest) {
        masm.shrq_ir(imm.value, dest.encoding());
    }
    void sarq(Imm32 imm, Register dest) {
        masm.sarq_ir(imm.value, dest.encoding());
    }
    void shlq_cl(Register dest) {
        masm.shlq_CLr(dest.encoding());
    }
    void shrq_cl(Register dest) {
        masm.shrq_CLr(dest.encoding());
    }
    void sarq_cl(Register dest) {
        masm.sarq_CLr(dest.encoding());
    }
    void rolq(Imm32 imm, Register dest) {
        masm.rolq_ir(imm.value, dest.encoding());
    }
    void rolq_cl(Register dest) {
        masm.rolq_CLr(dest.encoding());
    }
    void rorq(Imm32 imm, Register dest) {
        masm.rorq_ir(imm.value, dest.encoding());
    }
    void rorq_cl(Register dest) {
        masm.rorq_CLr(dest.encoding());
    }
    void orq(Imm32 imm, Register dest) {
        masm.orq_ir(imm.value, dest.encoding());
    }
    void orq(Register src, Register dest) {
        masm.orq_rr(src.encoding(), dest.encoding());
    }
    void orq(const Operand& src, Register dest) {
        switch (src.kind()) {
          case Operand::REG:
            masm.orq_rr(src.reg(), dest.encoding());
            break;
          case Operand::MEM_REG_DISP:
            masm.orq_mr(src.disp(), src.base(), dest.encoding());
            break;
          case Operand::MEM_ADDRESS32:
            masm.orq_mr(src.address(), dest.encoding());
            break;
          default:
            MOZ_CRASH("unexpected operand kind");
        }
    }
    void xorq(Register src, Register dest) {
        masm.xorq_rr(src.encoding(), dest.encoding());
    }
    void xorq(Imm32 imm, Register dest) {
        masm.xorq_ir(imm.value, dest.encoding());
    }
    void xorq(const Operand& src, Register dest) {
        switch (src.kind()) {
          case Operand::REG:
            masm.xorq_rr(src.reg(), dest.encoding());
            break;
          case Operand::MEM_REG_DISP:
            masm.xorq_mr(src.disp(), src.base(), dest.encoding());
            break;
          case Operand::MEM_ADDRESS32:
            masm.xorq_mr(src.address(), dest.encoding());
            break;
          default:
            MOZ_CRASH("unexpected operand kind");
        }
    }

    void bsrq(const Register& src, const Register& dest) {
        masm.bsrq_rr(src.encoding(), dest.encoding());
    }
    void bsfq(const Register& src, const Register& dest) {
        masm.bsfq_rr(src.encoding(), dest.encoding());
    }
    void popcntq(const Register& src, const Register& dest) {
        masm.popcntq_rr(src.encoding(), dest.encoding());
    }

    void imulq(Register src, Register dest) {
        masm.imulq_rr(src.encoding(), dest.encoding());
    }
    void imulq(const Operand& src, Register dest) {
        switch (src.kind()) {
          case Operand::REG:
            masm.imulq_rr(src.reg(), dest.encoding());
            break;
          case Operand::MEM_REG_DISP:
            masm.imulq_mr(src.disp(), src.base(), dest.encoding());
            break;
          case Operand::MEM_ADDRESS32:
            MOZ_CRASH("NYI");
            break;
          default:
            MOZ_CRASH("unexpected operand kind");
        }
    }

    void cqo() {
        masm.cqo();
    }
    void idivq(Register divisor) {
        masm.idivq_r(divisor.encoding());
    }
    void udivq(Register divisor) {
        masm.divq_r(divisor.encoding());
    }

    void vcvtsi2sdq(Register src, FloatRegister dest) {
        masm.vcvtsi2sdq_rr(src.encoding(), dest.encoding());
    }

    void negq(Register reg) {
        masm.negq_r(reg.encoding());
    }

    void mov(ImmWord word, Register dest) {
        // Use xor for setting registers to zero, as it is specially optimized
        // for this purpose on modern hardware. Note that it does clobber FLAGS
        // though. Use xorl instead of xorq since they are functionally
        // equivalent (32-bit instructions zero-extend their results to 64 bits)
        // and xorl has a smaller encoding.
        if (word.value == 0)
            xorl(dest, dest);
        else
            movq(word, dest);
    }
    void mov(ImmPtr imm, Register dest) {
        movq(imm, dest);
    }
    void mov(wasm::SymbolicAddress imm, Register dest) {
        masm.movq_i64r(-1, dest.encoding());
        append(wasm::SymbolicAccess(CodeOffset(masm.currentOffset()), imm));
    }
    void mov(const Operand& src, Register dest) {
        movq(src, dest);
    }
    void mov(Register src, const Operand& dest) {
        movq(src, dest);
    }
    void mov(Imm32 imm32, const Operand& dest) {
        movq(imm32, dest);
    }
    void mov(Register src, Register dest) {
        movq(src, dest);
    }
    void mov(CodeOffset* label, Register dest) {
        masm.movq_i64r(/* placeholder */ 0, dest.encoding());
        label->bind(masm.size());
    }
    void xchg(Register src, Register dest) {
        xchgq(src, dest);
    }
    void lea(const Operand& src, Register dest) {
        switch (src.kind()) {
          case Operand::MEM_REG_DISP:
            masm.leaq_mr(src.disp(), src.base(), dest.encoding());
            break;
          case Operand::MEM_SCALE:
            masm.leaq_mr(src.disp(), src.base(), src.index(), src.scale(), dest.encoding());
            break;
          default:
            MOZ_CRASH("unexepcted operand kind");
        }
    }

    CodeOffset loadRipRelativeInt32(Register dest) {
        return CodeOffset(masm.movl_ripr(dest.encoding()).offset());
    }
    CodeOffset loadRipRelativeInt64(Register dest) {
        return CodeOffset(masm.movq_ripr(dest.encoding()).offset());
    }
    CodeOffset loadRipRelativeDouble(FloatRegister dest) {
        return CodeOffset(masm.vmovsd_ripr(dest.encoding()).offset());
    }
    CodeOffset loadRipRelativeFloat32(FloatRegister dest) {
        return CodeOffset(masm.vmovss_ripr(dest.encoding()).offset());
    }
    CodeOffset loadRipRelativeInt32x4(FloatRegister dest) {
        return CodeOffset(masm.vmovdqa_ripr(dest.encoding()).offset());
    }
    CodeOffset loadRipRelativeFloat32x4(FloatRegister dest) {
        return CodeOffset(masm.vmovaps_ripr(dest.encoding()).offset());
    }
    CodeOffset storeRipRelativeInt32(Register dest) {
        return CodeOffset(masm.movl_rrip(dest.encoding()).offset());
    }
    CodeOffset storeRipRelativeInt64(Register dest) {
        return CodeOffset(masm.movq_rrip(dest.encoding()).offset());
    }
    CodeOffset storeRipRelativeDouble(FloatRegister dest) {
        return CodeOffset(masm.vmovsd_rrip(dest.encoding()).offset());
    }
    CodeOffset storeRipRelativeFloat32(FloatRegister dest) {
        return CodeOffset(masm.vmovss_rrip(dest.encoding()).offset());
    }
    CodeOffset storeRipRelativeInt32x4(FloatRegister dest) {
        return CodeOffset(masm.vmovdqa_rrip(dest.encoding()).offset());
    }
    CodeOffset storeRipRelativeFloat32x4(FloatRegister dest) {
        return CodeOffset(masm.vmovaps_rrip(dest.encoding()).offset());
    }
    CodeOffset leaRipRelative(Register dest) {
        return CodeOffset(masm.leaq_rip(dest.encoding()).offset());
    }

    void cmpq(Register rhs, Register lhs) {
        masm.cmpq_rr(rhs.encoding(), lhs.encoding());
    }
    void cmpq(Register rhs, const Operand& lhs) {
        switch (lhs.kind()) {
          case Operand::REG:
            masm.cmpq_rr(rhs.encoding(), lhs.reg());
            break;
          case Operand::MEM_REG_DISP:
            masm.cmpq_rm(rhs.encoding(), lhs.disp(), lhs.base());
            break;
          case Operand::MEM_ADDRESS32:
            masm.cmpq_rm(rhs.encoding(), lhs.address());
            break;
          default:
            MOZ_CRASH("unexpected operand kind");
        }
    }
    void cmpq(Imm32 rhs, Register lhs) {
        masm.cmpq_ir(rhs.value, lhs.encoding());
    }
    void cmpq(Imm32 rhs, const Operand& lhs) {
        switch (lhs.kind()) {
          case Operand::REG:
            masm.cmpq_ir(rhs.value, lhs.reg());
            break;
          case Operand::MEM_REG_DISP:
            masm.cmpq_im(rhs.value, lhs.disp(), lhs.base());
            break;
          case Operand::MEM_SCALE:
            masm.cmpq_im(rhs.value, lhs.disp(), lhs.base(), lhs.index(), lhs.scale());
            break;
          case Operand::MEM_ADDRESS32:
            masm.cmpq_im(rhs.value, lhs.address());
            break;
          default:
            MOZ_CRASH("unexpected operand kind");
        }
    }
    void cmpq(const Operand& rhs, Register lhs) {
        switch (rhs.kind()) {
          case Operand::REG:
            masm.cmpq_rr(rhs.reg(), lhs.encoding());
            break;
          case Operand::MEM_REG_DISP:
            masm.cmpq_mr(rhs.disp(), rhs.base(), lhs.encoding());
            break;
          default:
            MOZ_CRASH("unexpected operand kind");
        }
    }

    void testq(Imm32 rhs, Register lhs) {
        masm.testq_ir(rhs.value, lhs.encoding());
    }
    void testq(Register rhs, Register lhs) {
        masm.testq_rr(rhs.encoding(), lhs.encoding());
    }
    void testq(Imm32 rhs, const Operand& lhs) {
        switch (lhs.kind()) {
          case Operand::REG:
            masm.testq_ir(rhs.value, lhs.reg());
            break;
          case Operand::MEM_REG_DISP:
            masm.testq_i32m(rhs.value, lhs.disp(), lhs.base());
            break;
          default:
            MOZ_CRASH("unexpected operand kind");
            break;
        }
    }

    void jmp(ImmPtr target, Relocation::Kind reloc = Relocation::HARDCODED) {
        JmpSrc src = masm.jmp();
        addPendingJump(src, target, reloc);
    }
    void j(Condition cond, ImmPtr target,
           Relocation::Kind reloc = Relocation::HARDCODED) {
        JmpSrc src = masm.jCC(static_cast<X86Encoding::Condition>(cond));
        addPendingJump(src, target, reloc);
    }

    void jmp(JitCode* target) {
        jmp(ImmPtr(target->raw()), Relocation::JITCODE);
    }
    void j(Condition cond, JitCode* target) {
        j(cond, ImmPtr(target->raw()), Relocation::JITCODE);
    }
    void call(JitCode* target) {
        JmpSrc src = masm.call();
        addPendingJump(src, ImmPtr(target->raw()), Relocation::JITCODE);
    }
    void call(ImmWord target) {
        call(ImmPtr((void*)target.value));
    }
    void call(ImmPtr target) {
        JmpSrc src = masm.call();
        addPendingJump(src, target, Relocation::HARDCODED);
    }

    // Emit a CALL or CMP (nop) instruction. ToggleCall can be used to patch
    // this instruction.
    CodeOffset toggledCall(JitCode* target, bool enabled) {
        CodeOffset offset(size());
        JmpSrc src = enabled ? masm.call() : masm.cmp_eax();
        addPendingJump(src, ImmPtr(target->raw()), Relocation::JITCODE);
        MOZ_ASSERT_IF(!oom(), size() - offset.offset() == ToggledCallSize(nullptr));
        return offset;
    }

    static size_t ToggledCallSize(uint8_t* code) {
        // Size of a call instruction.
        return 5;
    }

    // Do not mask shared implementations.
    using AssemblerX86Shared::call;

    void vcvttsd2sq(FloatRegister src, Register dest) {
        masm.vcvttsd2sq_rr(src.encoding(), dest.encoding());
    }
    void vcvttss2sq(FloatRegister src, Register dest) {
        masm.vcvttss2sq_rr(src.encoding(), dest.encoding());
    }
    void vcvtsq2sd(Register src1, FloatRegister src0, FloatRegister dest) {
        masm.vcvtsq2sd_rr(src1.encoding(), src0.encoding(), dest.encoding());
    }
    void vcvtsq2ss(Register src1, FloatRegister src0, FloatRegister dest) {
        masm.vcvtsq2ss_rr(src1.encoding(), src0.encoding(), dest.encoding());
    }
};

static inline void
PatchJump(CodeLocationJump jump, CodeLocationLabel label, ReprotectCode reprotect = DontReprotect)
{
    if (X86Encoding::CanRelinkJump(jump.raw(), label.raw())) {
        MaybeAutoWritableJitCode awjc(jump.raw() - 8, 8, reprotect);
        X86Encoding::SetRel32(jump.raw(), label.raw());
    } else {
        {
            MaybeAutoWritableJitCode awjc(jump.raw() - 8, 8, reprotect);
            X86Encoding::SetRel32(jump.raw(), jump.jumpTableEntry());
        }
        Assembler::PatchJumpEntry(jump.jumpTableEntry(), label.raw(), reprotect);
    }
}

static inline void
PatchBackedge(CodeLocationJump& jump_, CodeLocationLabel label, JitZoneGroup::BackedgeTarget target)
{
    PatchJump(jump_, label);
}

static inline bool
GetIntArgReg(uint32_t intArg, uint32_t floatArg, Register* out)
{
#if defined(_WIN64)
    uint32_t arg = intArg + floatArg;
#else
    uint32_t arg = intArg;
#endif
    if (arg >= NumIntArgRegs)
        return false;
    *out = IntArgRegs[arg];
    return true;
}

// Get a register in which we plan to put a quantity that will be used as an
// integer argument.  This differs from GetIntArgReg in that if we have no more
// actual argument registers to use we will fall back on using whatever
// CallTempReg* don't overlap the argument registers, and only fail once those
// run out too.
static inline bool
GetTempRegForIntArg(uint32_t usedIntArgs, uint32_t usedFloatArgs, Register* out)
{
    if (GetIntArgReg(usedIntArgs, usedFloatArgs, out))
        return true;
    // Unfortunately, we have to assume things about the point at which
    // GetIntArgReg returns false, because we need to know how many registers it
    // can allocate.
#if defined(_WIN64)
    uint32_t arg = usedIntArgs + usedFloatArgs;
#else
    uint32_t arg = usedIntArgs;
#endif
    arg -= NumIntArgRegs;
    if (arg >= NumCallTempNonArgRegs)
        return false;
    *out = CallTempNonArgRegs[arg];
    return true;
}

static inline bool
GetFloatArgReg(uint32_t intArg, uint32_t floatArg, FloatRegister* out)
{
#if defined(_WIN64)
    uint32_t arg = intArg + floatArg;
#else
    uint32_t arg = floatArg;
#endif
    if (floatArg >= NumFloatArgRegs)
        return false;
    *out = FloatArgRegs[arg];
    return true;
}

} // namespace jit
} // namespace js

#endif /* jit_x64_Assembler_x64_h */
