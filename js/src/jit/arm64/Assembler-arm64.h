/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef A64_ASSEMBLER_A64_H_
#define A64_ASSEMBLER_A64_H_

#include "jit/arm64/vixl/Assembler-vixl.h"

#include "jit/JitRealm.h"
#include "jit/shared/Disassembler-shared.h"

namespace js {
namespace jit {

// VIXL imports.
typedef vixl::Register ARMRegister;
typedef vixl::FPRegister ARMFPRegister;
using vixl::ARMBuffer;
using vixl::Instruction;

using LabelDoc = DisassemblerSpew::LabelDoc;
using LiteralDoc = DisassemblerSpew::LiteralDoc;

static const uint32_t AlignmentAtPrologue = 0;
static const uint32_t AlignmentMidPrologue = 8;
static const Scale ScalePointer = TimesEight;

// The MacroAssembler uses scratch registers extensively and unexpectedly.
// For safety, scratch registers should always be acquired using
// vixl::UseScratchRegisterScope.
static constexpr Register ScratchReg{Registers::ip0};
static constexpr ARMRegister ScratchReg64 = {ScratchReg, 64};

static constexpr Register ScratchReg2{Registers::ip1};
static constexpr ARMRegister ScratchReg2_64 = {ScratchReg2, 64};

static constexpr FloatRegister ReturnDoubleReg = {FloatRegisters::d0,
                                                  FloatRegisters::Double};
static constexpr FloatRegister ScratchDoubleReg = {FloatRegisters::d31,
                                                   FloatRegisters::Double};
struct ScratchDoubleScope : public AutoFloatRegisterScope {
  explicit ScratchDoubleScope(MacroAssembler& masm)
      : AutoFloatRegisterScope(masm, ScratchDoubleReg) {}
};

static constexpr FloatRegister ReturnFloat32Reg = {FloatRegisters::s0,
                                                   FloatRegisters::Single};
static constexpr FloatRegister ScratchFloat32Reg = {FloatRegisters::s31,
                                                    FloatRegisters::Single};
struct ScratchFloat32Scope : public AutoFloatRegisterScope {
  explicit ScratchFloat32Scope(MacroAssembler& masm)
      : AutoFloatRegisterScope(masm, ScratchFloat32Reg) {}
};

static constexpr Register InvalidReg{Registers::Invalid};
static constexpr FloatRegister InvalidFloatReg = {};

static constexpr Register OsrFrameReg{Registers::x3};
static constexpr Register CallTempReg0{Registers::x9};
static constexpr Register CallTempReg1{Registers::x10};
static constexpr Register CallTempReg2{Registers::x11};
static constexpr Register CallTempReg3{Registers::x12};
static constexpr Register CallTempReg4{Registers::x13};
static constexpr Register CallTempReg5{Registers::x14};

static constexpr Register PreBarrierReg{Registers::x1};

static constexpr Register InterpreterPCReg{Registers::x9};

static constexpr Register ReturnReg{Registers::x0};
static constexpr Register64 ReturnReg64(ReturnReg);
static constexpr Register JSReturnReg{Registers::x2};
static constexpr Register FramePointer{Registers::fp};
static constexpr Register ZeroRegister{Registers::sp};
static constexpr ARMRegister ZeroRegister64 = {Registers::sp, 64};
static constexpr ARMRegister ZeroRegister32 = {Registers::sp, 32};

static constexpr FloatRegister ReturnSimd128Reg = InvalidFloatReg;
static constexpr FloatRegister ScratchSimd128Reg = InvalidFloatReg;

// StackPointer is intentionally undefined on ARM64 to prevent misuse:
//  using sp as a base register is only valid if sp % 16 == 0.
static constexpr Register RealStackPointer{Registers::sp};

static constexpr Register PseudoStackPointer{Registers::x28};
static constexpr ARMRegister PseudoStackPointer64 = {Registers::x28, 64};
static constexpr ARMRegister PseudoStackPointer32 = {Registers::x28, 32};

// StackPointer for use by irregexp.
static constexpr Register RegExpStackPointer = PseudoStackPointer;

static constexpr Register IntArgReg0{Registers::x0};
static constexpr Register IntArgReg1{Registers::x1};
static constexpr Register IntArgReg2{Registers::x2};
static constexpr Register IntArgReg3{Registers::x3};
static constexpr Register IntArgReg4{Registers::x4};
static constexpr Register IntArgReg5{Registers::x5};
static constexpr Register IntArgReg6{Registers::x6};
static constexpr Register IntArgReg7{Registers::x7};
static constexpr Register HeapReg{Registers::x21};

// Define unsized Registers.
#define DEFINE_UNSIZED_REGISTERS(N) \
  static constexpr Register r##N{Registers::x##N};
REGISTER_CODE_LIST(DEFINE_UNSIZED_REGISTERS)
#undef DEFINE_UNSIZED_REGISTERS
static constexpr Register ip0{Registers::x16};
static constexpr Register ip1{Registers::x17};
static constexpr Register fp{Registers::x29};
static constexpr Register lr{Registers::x30};
static constexpr Register rzr{Registers::xzr};

// Import VIXL registers into the js::jit namespace.
#define IMPORT_VIXL_REGISTERS(N)                  \
  static constexpr ARMRegister w##N = vixl::w##N; \
  static constexpr ARMRegister x##N = vixl::x##N;
REGISTER_CODE_LIST(IMPORT_VIXL_REGISTERS)
#undef IMPORT_VIXL_REGISTERS
static constexpr ARMRegister wzr = vixl::wzr;
static constexpr ARMRegister xzr = vixl::xzr;
static constexpr ARMRegister wsp = vixl::wsp;
static constexpr ARMRegister sp = vixl::sp;

// Import VIXL VRegisters into the js::jit namespace.
#define IMPORT_VIXL_VREGISTERS(N)                   \
  static constexpr ARMFPRegister s##N = vixl::s##N; \
  static constexpr ARMFPRegister d##N = vixl::d##N;
REGISTER_CODE_LIST(IMPORT_VIXL_VREGISTERS)
#undef IMPORT_VIXL_VREGISTERS

static constexpr ValueOperand JSReturnOperand = ValueOperand(JSReturnReg);

// Registerd used in RegExpMatcher instruction (do not use JSReturnOperand).
static constexpr Register RegExpMatcherRegExpReg = CallTempReg0;
static constexpr Register RegExpMatcherStringReg = CallTempReg1;
static constexpr Register RegExpMatcherLastIndexReg = CallTempReg2;

// Registerd used in RegExpTester instruction (do not use ReturnReg).
static constexpr Register RegExpTesterRegExpReg = CallTempReg0;
static constexpr Register RegExpTesterStringReg = CallTempReg1;
static constexpr Register RegExpTesterLastIndexReg = CallTempReg2;

static constexpr Register JSReturnReg_Type = r3;
static constexpr Register JSReturnReg_Data = r2;

static constexpr FloatRegister NANReg = {FloatRegisters::d14,
                                         FloatRegisters::Single};
// N.B. r8 isn't listed as an aapcs temp register, but we can use it as such
// because we never use return-structs.
static constexpr Register CallTempNonArgRegs[] = {r8,  r9,  r10, r11,
                                                  r12, r13, r14, r15};
static const uint32_t NumCallTempNonArgRegs =
    mozilla::ArrayLength(CallTempNonArgRegs);

static constexpr uint32_t JitStackAlignment = 16;

static constexpr uint32_t JitStackValueAlignment =
    JitStackAlignment / sizeof(Value);
static_assert(JitStackAlignment % sizeof(Value) == 0 &&
                  JitStackValueAlignment >= 1,
              "Stack alignment should be a non-zero multiple of sizeof(Value)");

static constexpr uint32_t SimdMemoryAlignment = 16;

static_assert(CodeAlignment % SimdMemoryAlignment == 0,
              "Code alignment should be larger than any of the alignments "
              "which are used for "
              "the constant sections of the code buffer.  Thus it should be "
              "larger than the "
              "alignment for SIMD constants.");

static const uint32_t WasmStackAlignment = SimdMemoryAlignment;
static const uint32_t WasmTrapInstructionLength = 4;

class Assembler : public vixl::Assembler {
 public:
  Assembler() : vixl::Assembler() {}

  typedef vixl::Condition Condition;

  void finish();
  bool appendRawCode(const uint8_t* code, size_t numBytes);
  bool reserve(size_t size);
  bool swapBuffer(wasm::Bytes& bytes);

  // Emit the jump table, returning the BufferOffset to the first entry in the
  // table.
  BufferOffset emitExtendedJumpTable();
  BufferOffset ExtendedJumpTable_;
  void executableCopy(uint8_t* buffer);

  BufferOffset immPool(ARMRegister dest, uint8_t* value, vixl::LoadLiteralOp op,
                       const LiteralDoc& doc,
                       ARMBuffer::PoolEntry* pe = nullptr);
  BufferOffset immPool64(ARMRegister dest, uint64_t value,
                         ARMBuffer::PoolEntry* pe = nullptr);
  BufferOffset fImmPool(ARMFPRegister dest, uint8_t* value,
                        vixl::LoadLiteralOp op, const LiteralDoc& doc);
  BufferOffset fImmPool64(ARMFPRegister dest, double value);
  BufferOffset fImmPool32(ARMFPRegister dest, float value);

  uint32_t currentOffset() const { return nextOffset().getOffset(); }

  void bind(Label* label) { bind(label, nextOffset()); }
  void bind(Label* label, BufferOffset boff);
  void bind(CodeLabel* label) { label->target()->bind(currentOffset()); }

  void setUnlimitedBuffer() { armbuffer_.setUnlimited(); }
  bool oom() const {
    return AssemblerShared::oom() || armbuffer_.oom() ||
           jumpRelocations_.oom() || dataRelocations_.oom();
  }

  void copyJumpRelocationTable(uint8_t* dest) const {
    if (jumpRelocations_.length()) {
      memcpy(dest, jumpRelocations_.buffer(), jumpRelocations_.length());
    }
  }
  void copyDataRelocationTable(uint8_t* dest) const {
    if (dataRelocations_.length()) {
      memcpy(dest, dataRelocations_.buffer(), dataRelocations_.length());
    }
  }

  size_t jumpRelocationTableBytes() const { return jumpRelocations_.length(); }
  size_t dataRelocationTableBytes() const { return dataRelocations_.length(); }
  size_t bytesNeeded() const {
    return SizeOfCodeGenerated() + jumpRelocationTableBytes() +
           dataRelocationTableBytes();
  }

  void processCodeLabels(uint8_t* rawCode) {
    for (const CodeLabel& label : codeLabels_) {
      Bind(rawCode, label);
    }
  }

  static void UpdateLoad64Value(Instruction* inst0, uint64_t value);

  static void Bind(uint8_t* rawCode, const CodeLabel& label) {
    auto mode = label.linkMode();
    size_t patchAtOffset = label.patchAt().offset();
    size_t targetOffset = label.target().offset();

    if (mode == CodeLabel::MoveImmediate) {
      Instruction* inst = (Instruction*)(rawCode + patchAtOffset);
      Assembler::UpdateLoad64Value(inst, (uint64_t)(rawCode + targetOffset));
    } else {
      *reinterpret_cast<const void**>(rawCode + patchAtOffset) =
          rawCode + targetOffset;
    }
  }

  void retarget(Label* cur, Label* next);

  // The buffer is about to be linked. Ensure any constant pools or
  // excess bookkeeping has been flushed to the instruction stream.
  void flush() { armbuffer_.flushPool(); }

  void comment(const char* msg) {
#ifdef JS_DISASM_ARM64
    spew_.spew("; %s", msg);
#endif
  }

  void setPrinter(Sprinter* sp) {
#ifdef JS_DISASM_ARM64
    spew_.setPrinter(sp);
#endif
  }

  static bool SupportsFloatingPoint() { return true; }
  static bool SupportsUnalignedAccesses() { return true; }
  static bool SupportsFastUnalignedAccesses() { return true; }

  static bool HasRoundInstruction(RoundingMode mode) { return false; }

  // Tracks a jump that is patchable after finalization.
  void addJumpRelocation(BufferOffset src, RelocationKind reloc);

 protected:
  // Add a jump whose target is unknown until finalization.
  // The jump may not be patched at runtime.
  void addPendingJump(BufferOffset src, ImmPtr target, RelocationKind kind);

  // Add a jump whose target is unknown until finalization, and may change
  // thereafter. The jump is patchable at runtime.
  size_t addPatchableJump(BufferOffset src, RelocationKind kind);

 public:
  static uint32_t PatchWrite_NearCallSize() { return 4; }

  static uint32_t NopSize() { return 4; }

  static void PatchWrite_NearCall(CodeLocationLabel start,
                                  CodeLocationLabel toCall);
  static void PatchDataWithValueCheck(CodeLocationLabel label,
                                      PatchedImmPtr newValue,
                                      PatchedImmPtr expected);

  static void PatchDataWithValueCheck(CodeLocationLabel label, ImmPtr newValue,
                                      ImmPtr expected);

  static void PatchWrite_Imm32(CodeLocationLabel label, Imm32 imm) {
    // Raw is going to be the return address.
    uint32_t* raw = (uint32_t*)label.raw();
    // Overwrite the 4 bytes before the return address, which will end up being
    // the call instruction.
    *(raw - 1) = imm.value;
  }
  static uint32_t AlignDoubleArg(uint32_t offset) {
    MOZ_CRASH("AlignDoubleArg()");
  }
  static uintptr_t GetPointer(uint8_t* ptr) {
    Instruction* i = reinterpret_cast<Instruction*>(ptr);
    uint64_t ret = i->Literal64();
    return ret;
  }

  // Toggle a jmp or cmp emitted by toggledJump().
  static void ToggleToJmp(CodeLocationLabel inst_);
  static void ToggleToCmp(CodeLocationLabel inst_);
  static void ToggleCall(CodeLocationLabel inst_, bool enabled);

  static void TraceJumpRelocations(JSTracer* trc, JitCode* code,
                                   CompactBufferReader& reader);
  static void TraceDataRelocations(JSTracer* trc, JitCode* code,
                                   CompactBufferReader& reader);

  void assertNoGCThings() const {
#ifdef DEBUG
    MOZ_ASSERT(dataRelocations_.length() == 0);
    for (auto& j : pendingJumps_) {
      MOZ_ASSERT(j.kind == RelocationKind::HARDCODED);
    }
#endif
  }

 public:
  // A Jump table entry is 2 instructions, with 8 bytes of raw data
  static const size_t SizeOfJumpTableEntry = 16;

  struct JumpTableEntry {
    uint32_t ldr;
    uint32_t br;
    void* data;

    Instruction* getLdr() { return reinterpret_cast<Instruction*>(&ldr); }
  };

  // Offset of the patchable target for the given entry.
  static const size_t OffsetOfJumpTableEntryPointer = 8;

 public:
  void writeCodePointer(CodeLabel* label) {
    armbuffer_.assertNoPoolAndNoNops();
    uintptr_t x = uintptr_t(-1);
    BufferOffset off = EmitData(&x, sizeof(uintptr_t));
    label->patchAt()->bind(off.getOffset());
  }

  void verifyHeapAccessDisassembly(uint32_t begin, uint32_t end,
                                   const Disassembler::HeapAccess& heapAccess) {
    MOZ_CRASH("verifyHeapAccessDisassembly");
  }

 protected:
  // Because jumps may be relocated to a target inaccessible by a short jump,
  // each relocatable jump must have a unique entry in the extended jump table.
  // Valid relocatable targets are of type RelocationKind::JITCODE.
  struct JumpRelocation {
    BufferOffset
        jump;  // Offset to the short jump, from the start of the code buffer.
    uint32_t
        extendedTableIndex;  // Unique index within the extended jump table.

    JumpRelocation(BufferOffset jump, uint32_t extendedTableIndex)
        : jump(jump), extendedTableIndex(extendedTableIndex) {}
  };

  // Structure for fixing up pc-relative loads/jumps when the machine
  // code gets moved (executable copy, gc, etc.).
  struct RelativePatch {
    BufferOffset offset;
    void* target;
    RelocationKind kind;

    RelativePatch(BufferOffset offset, void* target, RelocationKind kind)
        : offset(offset), target(target), kind(kind) {}
  };

  // List of jumps for which the target is either unknown until finalization,
  // or cannot be known due to GC. Each entry here requires a unique entry
  // in the extended jump table, and is patched at finalization.
  js::Vector<RelativePatch, 8, SystemAllocPolicy> pendingJumps_;

  // Final output formatters.
  CompactBufferWriter jumpRelocations_;
  CompactBufferWriter dataRelocations_;
};

static const uint32_t NumIntArgRegs = 8;
static const uint32_t NumFloatArgRegs = 8;

class ABIArgGenerator {
 public:
  ABIArgGenerator()
      : intRegIndex_(0), floatRegIndex_(0), stackOffset_(0), current_() {}

  ABIArg next(MIRType argType);
  ABIArg& current() { return current_; }
  uint32_t stackBytesConsumedSoFar() const { return stackOffset_; }

 protected:
  unsigned intRegIndex_;
  unsigned floatRegIndex_;
  uint32_t stackOffset_;
  ABIArg current_;
};

// These registers may be volatile or nonvolatile.
static constexpr Register ABINonArgReg0 = r8;
static constexpr Register ABINonArgReg1 = r9;
static constexpr Register ABINonArgReg2 = r10;
static constexpr Register ABINonArgReg3 = r11;

// This register may be volatile or nonvolatile. Avoid d31 which is the
// ScratchDoubleReg.
static constexpr FloatRegister ABINonArgDoubleReg = {FloatRegisters::s16,
                                                     FloatRegisters::Single};

// These registers may be volatile or nonvolatile.
// Note: these three registers are all guaranteed to be different
static constexpr Register ABINonArgReturnReg0 = r8;
static constexpr Register ABINonArgReturnReg1 = r9;
static constexpr Register ABINonVolatileReg{Registers::x19};

// This register is guaranteed to be clobberable during the prologue and
// epilogue of an ABI call which must preserve both ABI argument, return
// and non-volatile registers.
static constexpr Register ABINonArgReturnVolatileReg = lr;

// TLS pointer argument register for WebAssembly functions. This must not alias
// any other register used for passing function arguments or return values.
// Preserved by WebAssembly functions.  Must be nonvolatile.
static constexpr Register WasmTlsReg{Registers::x23};

// Registers used for wasm table calls. These registers must be disjoint
// from the ABI argument registers, WasmTlsReg and each other.
static constexpr Register WasmTableCallScratchReg0 = ABINonArgReg0;
static constexpr Register WasmTableCallScratchReg1 = ABINonArgReg1;
static constexpr Register WasmTableCallSigReg = ABINonArgReg2;
static constexpr Register WasmTableCallIndexReg = ABINonArgReg3;

// Register used as a scratch along the return path in the fast js -> wasm stub
// code.  This must not overlap ReturnReg, JSReturnOperand, or WasmTlsReg.  It
// must be a volatile register.
static constexpr Register WasmJitEntryReturnScratch = r9;

static inline bool GetIntArgReg(uint32_t usedIntArgs, uint32_t usedFloatArgs,
                                Register* out) {
  if (usedIntArgs >= NumIntArgRegs) {
    return false;
  }
  *out = Register::FromCode(usedIntArgs);
  return true;
}

static inline bool GetFloatArgReg(uint32_t usedIntArgs, uint32_t usedFloatArgs,
                                  FloatRegister* out) {
  if (usedFloatArgs >= NumFloatArgRegs) {
    return false;
  }
  *out = FloatRegister::FromCode(usedFloatArgs);
  return true;
}

// Get a register in which we plan to put a quantity that will be used as an
// integer argument.  This differs from GetIntArgReg in that if we have no more
// actual argument registers to use we will fall back on using whatever
// CallTempReg* don't overlap the argument registers, and only fail once those
// run out too.
static inline bool GetTempRegForIntArg(uint32_t usedIntArgs,
                                       uint32_t usedFloatArgs, Register* out) {
  if (GetIntArgReg(usedIntArgs, usedFloatArgs, out)) {
    return true;
  }
  // Unfortunately, we have to assume things about the point at which
  // GetIntArgReg returns false, because we need to know how many registers it
  // can allocate.
  usedIntArgs -= NumIntArgRegs;
  if (usedIntArgs >= NumCallTempNonArgRegs) {
    return false;
  }
  *out = CallTempNonArgRegs[usedIntArgs];
  return true;
}

inline Imm32 Imm64::firstHalf() const { return low(); }

inline Imm32 Imm64::secondHalf() const { return hi(); }

// Forbids nop filling for testing purposes. Not nestable.
class AutoForbidNops {
 protected:
  Assembler* asm_;

 public:
  explicit AutoForbidNops(Assembler* asm_) : asm_(asm_) { asm_->enterNoNops(); }
  ~AutoForbidNops() { asm_->leaveNoNops(); }
};

// Forbids pool generation during a specified interval. Not nestable.
class AutoForbidPoolsAndNops : public AutoForbidNops {
 public:
  AutoForbidPoolsAndNops(Assembler* asm_, size_t maxInst)
      : AutoForbidNops(asm_) {
    asm_->enterNoPool(maxInst);
  }
  ~AutoForbidPoolsAndNops() { asm_->leaveNoPool(); }
};

}  // namespace jit
}  // namespace js

#endif  // A64_ASSEMBLER_A64_H_
