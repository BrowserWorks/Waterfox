//! This module defines aarch64-specific machine instruction types.

// Some variants are not constructed, but we still want them as options in the future.
#![allow(dead_code)]

use crate::binemit::CodeOffset;
use crate::ir::types::{B1, B16, B32, B64, B8, F32, F64, FFLAGS, I16, I32, I64, I8, IFLAGS};
use crate::ir::{ExternalName, Opcode, SourceLoc, TrapCode, Type};
use crate::machinst::*;
use crate::{settings, CodegenError, CodegenResult};

use regalloc::{RealRegUniverse, Reg, RegClass, SpillSlot, VirtualReg, Writable};
use regalloc::{RegUsageCollector, RegUsageMapper, Set};

use alloc::vec::Vec;
use core::convert::TryFrom;
use smallvec::{smallvec, SmallVec};
use std::string::{String, ToString};

pub mod regs;
pub use self::regs::*;
pub mod imms;
pub use self::imms::*;
pub mod args;
pub use self::args::*;
pub mod emit;
pub use self::emit::*;

#[cfg(test)]
mod emit_tests;

//=============================================================================
// Instructions (top level): definition

/// An ALU operation. This can be paired with several instruction formats
/// below (see `Inst`) in any combination.
#[derive(Copy, Clone, Debug, PartialEq, Eq, Hash)]
pub enum ALUOp {
    Add32,
    Add64,
    Sub32,
    Sub64,
    Orr32,
    Orr64,
    /// NOR
    OrrNot32,
    /// NOR
    OrrNot64,
    And32,
    And64,
    /// NAND
    AndNot32,
    /// NAND
    AndNot64,
    /// XOR (AArch64 calls this "EOR")
    Eor32,
    /// XOR (AArch64 calls this "EOR")
    Eor64,
    /// XNOR (AArch64 calls this "EOR-NOT")
    EorNot32,
    /// XNOR (AArch64 calls this "EOR-NOT")
    EorNot64,
    /// Add, setting flags
    AddS32,
    /// Add, setting flags
    AddS64,
    /// Sub, setting flags
    SubS32,
    /// Sub, setting flags
    SubS64,
    /// Sub, setting flags, using extended registers
    SubS64XR,
    /// Multiply-add
    MAdd32,
    /// Multiply-add
    MAdd64,
    /// Multiply-sub
    MSub32,
    /// Multiply-sub
    MSub64,
    /// Signed multiply, high-word result
    SMulH,
    /// Unsigned multiply, high-word result
    UMulH,
    SDiv64,
    UDiv64,
    RotR32,
    RotR64,
    Lsr32,
    Lsr64,
    Asr32,
    Asr64,
    Lsl32,
    Lsl64,
}

/// A floating-point unit (FPU) operation with one arg.
#[derive(Copy, Clone, Debug, PartialEq, Eq, Hash)]
pub enum FPUOp1 {
    Abs32,
    Abs64,
    Neg32,
    Neg64,
    Sqrt32,
    Sqrt64,
    Cvt32To64,
    Cvt64To32,
}

/// A floating-point unit (FPU) operation with two args.
#[derive(Copy, Clone, Debug, PartialEq, Eq, Hash)]
pub enum FPUOp2 {
    Add32,
    Add64,
    Sub32,
    Sub64,
    Mul32,
    Mul64,
    Div32,
    Div64,
    Max32,
    Max64,
    Min32,
    Min64,
}

/// A floating-point unit (FPU) operation with three args.
#[derive(Copy, Clone, Debug, PartialEq, Eq, Hash)]
pub enum FPUOp3 {
    MAdd32,
    MAdd64,
}

/// A conversion from an FP to an integer value.
#[derive(Copy, Clone, Debug, PartialEq, Eq, Hash)]
pub enum FpuToIntOp {
    F32ToU32,
    F32ToI32,
    F32ToU64,
    F32ToI64,
    F64ToU32,
    F64ToI32,
    F64ToU64,
    F64ToI64,
}

/// A conversion from an integer to an FP value.
#[derive(Copy, Clone, Debug, PartialEq, Eq, Hash)]
pub enum IntToFpuOp {
    U32ToF32,
    I32ToF32,
    U32ToF64,
    I32ToF64,
    U64ToF32,
    I64ToF32,
    U64ToF64,
    I64ToF64,
}

/// Modes for FP rounding ops: round down (floor) or up (ceil), or toward zero (trunc), or to
/// nearest, and for 32- or 64-bit FP values.
#[derive(Copy, Clone, Debug, PartialEq, Eq, Hash)]
pub enum FpuRoundMode {
    Minus32,
    Minus64,
    Plus32,
    Plus64,
    Zero32,
    Zero64,
    Nearest32,
    Nearest64,
}

/// A vector ALU operation.
#[derive(Copy, Clone, Debug, PartialEq, Eq, Hash)]
pub enum VecALUOp {
    /// Signed saturating add
    SQAddScalar,
    /// Unsigned saturating add
    UQAddScalar,
    /// Signed saturating subtract
    SQSubScalar,
    /// Unsigned saturating subtract
    UQSubScalar,
}

/// An operation on the bits of a register. This can be paired with several instruction formats
/// below (see `Inst`) in any combination.
#[derive(Copy, Clone, Debug, PartialEq, Eq, Hash)]
pub enum BitOp {
    /// Bit reverse
    RBit32,
    /// Bit reverse
    RBit64,
    Clz32,
    Clz64,
    Cls32,
    Cls64,
}

impl BitOp {
    /// What is the opcode's native width?
    pub fn inst_size(&self) -> InstSize {
        match self {
            BitOp::RBit32 | BitOp::Clz32 | BitOp::Cls32 => InstSize::Size32,
            _ => InstSize::Size64,
        }
    }

    /// Get the assembly mnemonic for this opcode.
    pub fn op_str(&self) -> &'static str {
        match self {
            BitOp::RBit32 | BitOp::RBit64 => "rbit",
            BitOp::Clz32 | BitOp::Clz64 => "clz",
            BitOp::Cls32 | BitOp::Cls64 => "cls",
        }
    }
}

impl From<(Opcode, Type)> for BitOp {
    /// Get the BitOp from the IR opcode.
    fn from(op_ty: (Opcode, Type)) -> BitOp {
        match op_ty {
            (Opcode::Bitrev, I32) => BitOp::RBit32,
            (Opcode::Bitrev, I64) => BitOp::RBit64,
            (Opcode::Clz, I32) => BitOp::Clz32,
            (Opcode::Clz, I64) => BitOp::Clz64,
            (Opcode::Cls, I32) => BitOp::Cls32,
            (Opcode::Cls, I64) => BitOp::Cls64,
            _ => unreachable!("Called with non-bit op!: {:?}", op_ty),
        }
    }
}

/// Instruction formats.
#[derive(Clone, Debug)]
pub enum Inst {
    /// A no-op of zero size.
    Nop0,

    /// A no-op that is one instruction large.
    Nop4,

    /// An ALU operation with two register sources and a register destination.
    AluRRR {
        alu_op: ALUOp,
        rd: Writable<Reg>,
        rn: Reg,
        rm: Reg,
    },
    /// An ALU operation with three register sources and a register destination.
    AluRRRR {
        alu_op: ALUOp,
        rd: Writable<Reg>,
        rn: Reg,
        rm: Reg,
        ra: Reg,
    },
    /// An ALU operation with a register source and an immediate-12 source, and a register
    /// destination.
    AluRRImm12 {
        alu_op: ALUOp,
        rd: Writable<Reg>,
        rn: Reg,
        imm12: Imm12,
    },
    /// An ALU operation with a register source and an immediate-logic source, and a register destination.
    AluRRImmLogic {
        alu_op: ALUOp,
        rd: Writable<Reg>,
        rn: Reg,
        imml: ImmLogic,
    },
    /// An ALU operation with a register source and an immediate-shiftamt source, and a register destination.
    AluRRImmShift {
        alu_op: ALUOp,
        rd: Writable<Reg>,
        rn: Reg,
        immshift: ImmShift,
    },
    /// An ALU operation with two register sources, one of which can be shifted, and a register
    /// destination.
    AluRRRShift {
        alu_op: ALUOp,
        rd: Writable<Reg>,
        rn: Reg,
        rm: Reg,
        shiftop: ShiftOpAndAmt,
    },
    /// An ALU operation with two register sources, one of which can be {zero,sign}-extended and
    /// shifted, and a register destination.
    AluRRRExtend {
        alu_op: ALUOp,
        rd: Writable<Reg>,
        rn: Reg,
        rm: Reg,
        extendop: ExtendOp,
    },

    /// A bit op instruction with a single register source.
    BitRR {
        op: BitOp,
        rd: Writable<Reg>,
        rn: Reg,
    },

    /// An unsigned (zero-extending) 8-bit load.
    ULoad8 {
        rd: Writable<Reg>,
        mem: MemArg,
        srcloc: Option<SourceLoc>,
    },
    /// A signed (sign-extending) 8-bit load.
    SLoad8 {
        rd: Writable<Reg>,
        mem: MemArg,
        srcloc: Option<SourceLoc>,
    },
    /// An unsigned (zero-extending) 16-bit load.
    ULoad16 {
        rd: Writable<Reg>,
        mem: MemArg,
        srcloc: Option<SourceLoc>,
    },
    /// A signed (sign-extending) 16-bit load.
    SLoad16 {
        rd: Writable<Reg>,
        mem: MemArg,
        srcloc: Option<SourceLoc>,
    },
    /// An unsigned (zero-extending) 32-bit load.
    ULoad32 {
        rd: Writable<Reg>,
        mem: MemArg,
        srcloc: Option<SourceLoc>,
    },
    /// A signed (sign-extending) 32-bit load.
    SLoad32 {
        rd: Writable<Reg>,
        mem: MemArg,
        srcloc: Option<SourceLoc>,
    },
    /// A 64-bit load.
    ULoad64 {
        rd: Writable<Reg>,
        mem: MemArg,
        srcloc: Option<SourceLoc>,
    },

    /// An 8-bit store.
    Store8 {
        rd: Reg,
        mem: MemArg,
        srcloc: Option<SourceLoc>,
    },
    /// A 16-bit store.
    Store16 {
        rd: Reg,
        mem: MemArg,
        srcloc: Option<SourceLoc>,
    },
    /// A 32-bit store.
    Store32 {
        rd: Reg,
        mem: MemArg,
        srcloc: Option<SourceLoc>,
    },
    /// A 64-bit store.
    Store64 {
        rd: Reg,
        mem: MemArg,
        srcloc: Option<SourceLoc>,
    },

    /// A store of a pair of registers.
    StoreP64 {
        rt: Reg,
        rt2: Reg,
        mem: PairMemArg,
    },
    /// A load of a pair of registers.
    LoadP64 {
        rt: Writable<Reg>,
        rt2: Writable<Reg>,
        mem: PairMemArg,
    },

    /// A MOV instruction. These are encoded as ORR's (AluRRR form) but we
    /// keep them separate at the `Inst` level for better pretty-printing
    /// and faster `is_move()` logic.
    Mov {
        rd: Writable<Reg>,
        rm: Reg,
    },

    /// A 32-bit MOV. Zeroes the top 32 bits of the destination. This is
    /// effectively an alias for an unsigned 32-to-64-bit extension.
    Mov32 {
        rd: Writable<Reg>,
        rm: Reg,
    },

    /// A MOVZ with a 16-bit immediate.
    MovZ {
        rd: Writable<Reg>,
        imm: MoveWideConst,
    },

    /// A MOVN with a 16-bit immediate.
    MovN {
        rd: Writable<Reg>,
        imm: MoveWideConst,
    },

    /// A MOVK with a 16-bit immediate.
    MovK {
        rd: Writable<Reg>,
        imm: MoveWideConst,
    },

    /// A sign- or zero-extend operation.
    Extend {
        rd: Writable<Reg>,
        rn: Reg,
        signed: bool,
        from_bits: u8,
        to_bits: u8,
    },

    /// A conditional-select operation.
    CSel {
        rd: Writable<Reg>,
        cond: Cond,
        rn: Reg,
        rm: Reg,
    },

    /// A conditional-set operation.
    CSet {
        rd: Writable<Reg>,
        cond: Cond,
    },

    /// A conditional comparison with an immediate.
    CCmpImm {
        size: InstSize,
        rn: Reg,
        imm: UImm5,
        nzcv: NZCV,
        cond: Cond,
    },

    /// FPU move. Note that this is distinct from a vector-register
    /// move; moving just 64 bits seems to be significantly faster.
    FpuMove64 {
        rd: Writable<Reg>,
        rn: Reg,
    },

    /// 1-op FPU instruction.
    FpuRR {
        fpu_op: FPUOp1,
        rd: Writable<Reg>,
        rn: Reg,
    },

    /// 2-op FPU instruction.
    FpuRRR {
        fpu_op: FPUOp2,
        rd: Writable<Reg>,
        rn: Reg,
        rm: Reg,
    },

    /// 3-op FPU instruction.
    FpuRRRR {
        fpu_op: FPUOp3,
        rd: Writable<Reg>,
        rn: Reg,
        rm: Reg,
        ra: Reg,
    },

    /// FPU comparison, single-precision (32 bit).
    FpuCmp32 {
        rn: Reg,
        rm: Reg,
    },

    /// FPU comparison, double-precision (64 bit).
    FpuCmp64 {
        rn: Reg,
        rm: Reg,
    },

    /// Floating-point load, single-precision (32 bit).
    FpuLoad32 {
        rd: Writable<Reg>,
        mem: MemArg,
        srcloc: Option<SourceLoc>,
    },
    /// Floating-point store, single-precision (32 bit).
    FpuStore32 {
        rd: Reg,
        mem: MemArg,
        srcloc: Option<SourceLoc>,
    },
    /// Floating-point load, double-precision (64 bit).
    FpuLoad64 {
        rd: Writable<Reg>,
        mem: MemArg,
        srcloc: Option<SourceLoc>,
    },
    /// Floating-point store, double-precision (64 bit).
    FpuStore64 {
        rd: Reg,
        mem: MemArg,
        srcloc: Option<SourceLoc>,
    },
    /// Floating-point/vector load, 128 bit.
    FpuLoad128 {
        rd: Writable<Reg>,
        mem: MemArg,
        srcloc: Option<SourceLoc>,
    },
    /// Floating-point/vector store, 128 bit.
    FpuStore128 {
        rd: Reg,
        mem: MemArg,
        srcloc: Option<SourceLoc>,
    },

    LoadFpuConst32 {
        rd: Writable<Reg>,
        const_data: f32,
    },

    LoadFpuConst64 {
        rd: Writable<Reg>,
        const_data: f64,
    },

    /// Conversion: FP -> integer.
    FpuToInt {
        op: FpuToIntOp,
        rd: Writable<Reg>,
        rn: Reg,
    },

    /// Conversion: integer -> FP.
    IntToFpu {
        op: IntToFpuOp,
        rd: Writable<Reg>,
        rn: Reg,
    },

    /// FP conditional select, 32 bit.
    FpuCSel32 {
        rd: Writable<Reg>,
        rn: Reg,
        rm: Reg,
        cond: Cond,
    },
    /// FP conditional select, 64 bit.
    FpuCSel64 {
        rd: Writable<Reg>,
        rn: Reg,
        rm: Reg,
        cond: Cond,
    },

    /// Round to integer.
    FpuRound {
        op: FpuRoundMode,
        rd: Writable<Reg>,
        rn: Reg,
    },

    /// Move to a vector register from a GPR.
    MovToVec64 {
        rd: Writable<Reg>,
        rn: Reg,
    },

    /// Move to a GPR from a vector register.
    MovFromVec64 {
        rd: Writable<Reg>,
        rn: Reg,
    },

    /// A vector ALU op.
    VecRRR {
        alu_op: VecALUOp,
        rd: Writable<Reg>,
        rn: Reg,
        rm: Reg,
    },

    /// Move to the NZCV flags (actually a `MSR NZCV, Xn` insn).
    MovToNZCV {
        rn: Reg,
    },

    /// Move from the NZCV flags (actually a `MRS Xn, NZCV` insn).
    MovFromNZCV {
        rd: Writable<Reg>,
    },

    /// Set a register to 1 if condition, else 0.
    CondSet {
        rd: Writable<Reg>,
        cond: Cond,
    },

    /// A machine call instruction.
    Call {
        dest: ExternalName,
        uses: Set<Reg>,
        defs: Set<Writable<Reg>>,
        loc: SourceLoc,
        opcode: Opcode,
    },
    /// A machine indirect-call instruction.
    CallInd {
        rn: Reg,
        uses: Set<Reg>,
        defs: Set<Writable<Reg>>,
        loc: SourceLoc,
        opcode: Opcode,
    },

    // ---- branches (exactly one must appear at end of BB) ----
    /// A machine return instruction.
    Ret,

    /// A placeholder instruction, generating no code, meaning that a function epilogue must be
    /// inserted there.
    EpiloguePlaceholder,

    /// An unconditional branch.
    Jump {
        dest: BranchTarget,
    },

    /// A conditional branch.
    CondBr {
        taken: BranchTarget,
        not_taken: BranchTarget,
        kind: CondBrKind,
    },

    /// Lowered conditional branch: contains the original branch kind (or the
    /// inverse), but only one BranchTarget is retained. The other is
    /// implicitly the next instruction, given the final basic-block layout.
    CondBrLowered {
        target: BranchTarget,
        kind: CondBrKind,
    },

    /// As for `CondBrLowered`, but represents a condbr/uncond-br sequence (two
    /// actual machine instructions). Needed when the final block layout implies
    /// that neither arm of a conditional branch targets the fallthrough block.
    CondBrLoweredCompound {
        taken: BranchTarget,
        not_taken: BranchTarget,
        kind: CondBrKind,
    },

    /// An indirect branch through a register, augmented with set of all
    /// possible successors.
    IndirectBr {
        rn: Reg,
        targets: Vec<BlockIndex>,
    },

    /// A "break" instruction, used for e.g. traps and debug breakpoints.
    Brk,

    /// An instruction guaranteed to always be undefined and to trigger an illegal instruction at
    /// runtime.
    Udf {
        trap_info: (SourceLoc, TrapCode),
    },

    /// Load the address (using a PC-relative offset) of a MemLabel, using the
    /// `ADR` instruction.
    Adr {
        rd: Writable<Reg>,
        label: MemLabel,
    },

    /// Raw 32-bit word, used for inline constants and jump-table entries.
    Word4 {
        data: u32,
    },

    /// Raw 64-bit word, used for inline constants.
    Word8 {
        data: u64,
    },

    /// Jump-table sequence, as one compound instruction (see note in lower.rs
    /// for rationale).
    JTSequence {
        targets: Vec<BranchTarget>,
        targets_for_term: Vec<BlockIndex>, // needed for MachTerminator.
        ridx: Reg,
        rtmp1: Writable<Reg>,
        rtmp2: Writable<Reg>,
    },

    /// Load an inline constant.
    LoadConst64 {
        rd: Writable<Reg>,
        const_data: u64,
    },

    /// Load an inline symbol reference.
    LoadExtName {
        rd: Writable<Reg>,
        name: ExternalName,
        srcloc: SourceLoc,
        offset: i64,
    },

    /// Load address referenced by `mem` into `rd`.
    LoadAddr {
        rd: Writable<Reg>,
        mem: MemArg,
    },

    /// Sets the value of the pinned register to the given register target.
    GetPinnedReg {
        rd: Writable<Reg>,
    },

    /// Writes the value of the given source register to the pinned register.
    SetPinnedReg {
        rm: Reg,
    },
}

fn count_zero_half_words(mut value: u64) -> usize {
    let mut count = 0;
    for _ in 0..4 {
        if value & 0xffff == 0 {
            count += 1;
        }
        value >>= 16;
    }

    count
}

impl Inst {
    /// Create a move instruction.
    pub fn mov(to_reg: Writable<Reg>, from_reg: Reg) -> Inst {
        assert!(to_reg.to_reg().get_class() == from_reg.get_class());
        if from_reg.get_class() == RegClass::I64 {
            Inst::Mov {
                rd: to_reg,
                rm: from_reg,
            }
        } else {
            Inst::FpuMove64 {
                rd: to_reg,
                rn: from_reg,
            }
        }
    }

    /// Create a 32-bit move instruction.
    pub fn mov32(to_reg: Writable<Reg>, from_reg: Reg) -> Inst {
        Inst::Mov32 {
            rd: to_reg,
            rm: from_reg,
        }
    }

    /// Create an instruction that loads a constant, using one of serveral options (MOVZ, MOVN,
    /// logical immediate, or constant pool).
    pub fn load_constant(rd: Writable<Reg>, value: u64) -> SmallVec<[Inst; 4]> {
        if let Some(imm) = MoveWideConst::maybe_from_u64(value) {
            // 16-bit immediate (shifted by 0, 16, 32 or 48 bits) in MOVZ
            smallvec![Inst::MovZ { rd, imm }]
        } else if let Some(imm) = MoveWideConst::maybe_from_u64(!value) {
            // 16-bit immediate (shifted by 0, 16, 32 or 48 bits) in MOVN
            smallvec![Inst::MovN { rd, imm }]
        } else if let Some(imml) = ImmLogic::maybe_from_u64(value, I64) {
            // Weird logical-instruction immediate in ORI using zero register
            smallvec![Inst::AluRRImmLogic {
                alu_op: ALUOp::Orr64,
                rd,
                rn: zero_reg(),
                imml,
            }]
        } else {
            let mut insts = smallvec![];

            // If the number of 0xffff half words is greater than the number of 0x0000 half words
            // it is more efficient to use `movn` for the first instruction.
            let first_is_inverted = count_zero_half_words(!value) > count_zero_half_words(value);
            // Either 0xffff or 0x0000 half words can be skipped, depending on the first
            // instruction used.
            let ignored_halfword = if first_is_inverted { 0xffff } else { 0 };
            let mut first_mov_emitted = false;

            for i in 0..4 {
                let imm16 = (value >> (16 * i)) & 0xffff;
                if imm16 != ignored_halfword {
                    if !first_mov_emitted {
                        first_mov_emitted = true;
                        if first_is_inverted {
                            let imm =
                                MoveWideConst::maybe_with_shift(((!imm16) & 0xffff) as u16, i * 16)
                                    .unwrap();
                            insts.push(Inst::MovN { rd, imm });
                        } else {
                            let imm =
                                MoveWideConst::maybe_with_shift(imm16 as u16, i * 16).unwrap();
                            insts.push(Inst::MovZ { rd, imm });
                        }
                    } else {
                        let imm = MoveWideConst::maybe_with_shift(imm16 as u16, i * 16).unwrap();
                        insts.push(Inst::MovK { rd, imm });
                    }
                }
            }

            assert!(first_mov_emitted);

            insts
        }
    }

    /// Create an instruction that loads a 32-bit floating-point constant.
    pub fn load_fp_constant32(rd: Writable<Reg>, value: f32) -> Inst {
        // TODO: use FMOV immediate form when `value` has sufficiently few mantissa/exponent bits.
        Inst::LoadFpuConst32 {
            rd,
            const_data: value,
        }
    }

    /// Create an instruction that loads a 64-bit floating-point constant.
    pub fn load_fp_constant64(rd: Writable<Reg>, value: f64) -> Inst {
        // TODO: use FMOV immediate form when `value` has sufficiently few mantissa/exponent bits.
        Inst::LoadFpuConst64 {
            rd,
            const_data: value,
        }
    }
}

//=============================================================================
// Instructions: get_regs

fn memarg_regs(memarg: &MemArg, collector: &mut RegUsageCollector) {
    match memarg {
        &MemArg::Unscaled(reg, ..) | &MemArg::UnsignedOffset(reg, ..) => {
            collector.add_use(reg);
        }
        &MemArg::RegReg(r1, r2, ..)
        | &MemArg::RegScaled(r1, r2, ..)
        | &MemArg::RegScaledExtended(r1, r2, ..) => {
            collector.add_use(r1);
            collector.add_use(r2);
        }
        &MemArg::Label(..) => {}
        &MemArg::PreIndexed(reg, ..) | &MemArg::PostIndexed(reg, ..) => {
            collector.add_mod(reg);
        }
        &MemArg::FPOffset(..) => {
            collector.add_use(fp_reg());
        }
        &MemArg::SPOffset(..) => {
            collector.add_use(stack_reg());
        }
    }
}

fn pairmemarg_regs(pairmemarg: &PairMemArg, collector: &mut RegUsageCollector) {
    match pairmemarg {
        &PairMemArg::SignedOffset(reg, ..) => {
            collector.add_use(reg);
        }
        &PairMemArg::PreIndexed(reg, ..) | &PairMemArg::PostIndexed(reg, ..) => {
            collector.add_mod(reg);
        }
    }
}

fn aarch64_get_regs(inst: &Inst, collector: &mut RegUsageCollector) {
    match inst {
        &Inst::AluRRR { rd, rn, rm, .. } => {
            collector.add_def(rd);
            collector.add_use(rn);
            collector.add_use(rm);
        }
        &Inst::AluRRRR { rd, rn, rm, ra, .. } => {
            collector.add_def(rd);
            collector.add_use(rn);
            collector.add_use(rm);
            collector.add_use(ra);
        }
        &Inst::AluRRImm12 { rd, rn, .. } => {
            collector.add_def(rd);
            collector.add_use(rn);
        }
        &Inst::AluRRImmLogic { rd, rn, .. } => {
            collector.add_def(rd);
            collector.add_use(rn);
        }
        &Inst::AluRRImmShift { rd, rn, .. } => {
            collector.add_def(rd);
            collector.add_use(rn);
        }
        &Inst::AluRRRShift { rd, rn, rm, .. } => {
            collector.add_def(rd);
            collector.add_use(rn);
            collector.add_use(rm);
        }
        &Inst::AluRRRExtend { rd, rn, rm, .. } => {
            collector.add_def(rd);
            collector.add_use(rn);
            collector.add_use(rm);
        }
        &Inst::BitRR { rd, rn, .. } => {
            collector.add_def(rd);
            collector.add_use(rn);
        }
        &Inst::ULoad8 { rd, ref mem, .. }
        | &Inst::SLoad8 { rd, ref mem, .. }
        | &Inst::ULoad16 { rd, ref mem, .. }
        | &Inst::SLoad16 { rd, ref mem, .. }
        | &Inst::ULoad32 { rd, ref mem, .. }
        | &Inst::SLoad32 { rd, ref mem, .. }
        | &Inst::ULoad64 { rd, ref mem, .. } => {
            collector.add_def(rd);
            memarg_regs(mem, collector);
        }
        &Inst::Store8 { rd, ref mem, .. }
        | &Inst::Store16 { rd, ref mem, .. }
        | &Inst::Store32 { rd, ref mem, .. }
        | &Inst::Store64 { rd, ref mem, .. } => {
            collector.add_use(rd);
            memarg_regs(mem, collector);
        }
        &Inst::StoreP64 {
            rt, rt2, ref mem, ..
        } => {
            collector.add_use(rt);
            collector.add_use(rt2);
            pairmemarg_regs(mem, collector);
        }
        &Inst::LoadP64 {
            rt, rt2, ref mem, ..
        } => {
            collector.add_def(rt);
            collector.add_def(rt2);
            pairmemarg_regs(mem, collector);
        }
        &Inst::Mov { rd, rm } => {
            collector.add_def(rd);
            collector.add_use(rm);
        }
        &Inst::Mov32 { rd, rm } => {
            collector.add_def(rd);
            collector.add_use(rm);
        }
        &Inst::MovZ { rd, .. } | &Inst::MovN { rd, .. } => {
            collector.add_def(rd);
        }
        &Inst::MovK { rd, .. } => {
            collector.add_mod(rd);
        }
        &Inst::CSel { rd, rn, rm, .. } => {
            collector.add_def(rd);
            collector.add_use(rn);
            collector.add_use(rm);
        }
        &Inst::CSet { rd, .. } => {
            collector.add_def(rd);
        }
        &Inst::CCmpImm { rn, .. } => {
            collector.add_use(rn);
        }
        &Inst::FpuMove64 { rd, rn } => {
            collector.add_def(rd);
            collector.add_use(rn);
        }
        &Inst::FpuRR { rd, rn, .. } => {
            collector.add_def(rd);
            collector.add_use(rn);
        }
        &Inst::FpuRRR { rd, rn, rm, .. } => {
            collector.add_def(rd);
            collector.add_use(rn);
            collector.add_use(rm);
        }
        &Inst::FpuRRRR { rd, rn, rm, ra, .. } => {
            collector.add_def(rd);
            collector.add_use(rn);
            collector.add_use(rm);
            collector.add_use(ra);
        }
        &Inst::FpuCmp32 { rn, rm } | &Inst::FpuCmp64 { rn, rm } => {
            collector.add_use(rn);
            collector.add_use(rm);
        }
        &Inst::FpuLoad32 { rd, ref mem, .. } => {
            collector.add_def(rd);
            memarg_regs(mem, collector);
        }
        &Inst::FpuLoad64 { rd, ref mem, .. } => {
            collector.add_def(rd);
            memarg_regs(mem, collector);
        }
        &Inst::FpuLoad128 { rd, ref mem, .. } => {
            collector.add_def(rd);
            memarg_regs(mem, collector);
        }
        &Inst::FpuStore32 { rd, ref mem, .. } => {
            collector.add_use(rd);
            memarg_regs(mem, collector);
        }
        &Inst::FpuStore64 { rd, ref mem, .. } => {
            collector.add_use(rd);
            memarg_regs(mem, collector);
        }
        &Inst::FpuStore128 { rd, ref mem, .. } => {
            collector.add_use(rd);
            memarg_regs(mem, collector);
        }
        &Inst::LoadFpuConst32 { rd, .. } | &Inst::LoadFpuConst64 { rd, .. } => {
            collector.add_def(rd);
        }
        &Inst::FpuToInt { rd, rn, .. } => {
            collector.add_def(rd);
            collector.add_use(rn);
        }
        &Inst::IntToFpu { rd, rn, .. } => {
            collector.add_def(rd);
            collector.add_use(rn);
        }
        &Inst::FpuCSel32 { rd, rn, rm, .. } | &Inst::FpuCSel64 { rd, rn, rm, .. } => {
            collector.add_def(rd);
            collector.add_use(rn);
            collector.add_use(rm);
        }
        &Inst::FpuRound { rd, rn, .. } => {
            collector.add_def(rd);
            collector.add_use(rn);
        }
        &Inst::MovToVec64 { rd, rn } => {
            collector.add_def(rd);
            collector.add_use(rn);
        }
        &Inst::MovFromVec64 { rd, rn } => {
            collector.add_def(rd);
            collector.add_use(rn);
        }
        &Inst::VecRRR { rd, rn, rm, .. } => {
            collector.add_def(rd);
            collector.add_use(rn);
            collector.add_use(rm);
        }
        &Inst::MovToNZCV { rn } => {
            collector.add_use(rn);
        }
        &Inst::MovFromNZCV { rd } => {
            collector.add_def(rd);
        }
        &Inst::CondSet { rd, .. } => {
            collector.add_def(rd);
        }
        &Inst::Extend { rd, rn, .. } => {
            collector.add_def(rd);
            collector.add_use(rn);
        }
        &Inst::Jump { .. } | &Inst::Ret | &Inst::EpiloguePlaceholder => {}
        &Inst::Call {
            ref uses, ref defs, ..
        } => {
            collector.add_uses(uses);
            collector.add_defs(defs);
        }
        &Inst::CallInd {
            ref uses,
            ref defs,
            rn,
            ..
        } => {
            collector.add_uses(uses);
            collector.add_defs(defs);
            collector.add_use(rn);
        }
        &Inst::CondBr { ref kind, .. }
        | &Inst::CondBrLowered { ref kind, .. }
        | &Inst::CondBrLoweredCompound { ref kind, .. } => match kind {
            CondBrKind::Zero(rt) | CondBrKind::NotZero(rt) => {
                collector.add_use(*rt);
            }
            CondBrKind::Cond(_) => {}
        },
        &Inst::IndirectBr { rn, .. } => {
            collector.add_use(rn);
        }
        &Inst::Nop0 | Inst::Nop4 => {}
        &Inst::Brk => {}
        &Inst::Udf { .. } => {}
        &Inst::Adr { rd, .. } => {
            collector.add_def(rd);
        }
        &Inst::Word4 { .. } | &Inst::Word8 { .. } => {}
        &Inst::JTSequence {
            ridx, rtmp1, rtmp2, ..
        } => {
            collector.add_use(ridx);
            collector.add_def(rtmp1);
            collector.add_def(rtmp2);
        }
        &Inst::LoadConst64 { rd, .. } | &Inst::LoadExtName { rd, .. } => {
            collector.add_def(rd);
        }
        &Inst::LoadAddr { rd, mem: _ } => {
            collector.add_def(rd);
        }
        &Inst::GetPinnedReg { rd } => {
            collector.add_def(rd);
        }
        &Inst::SetPinnedReg { rm } => {
            collector.add_use(rm);
        }
    }
}

//=============================================================================
// Instructions: map_regs

fn aarch64_map_regs(inst: &mut Inst, mapper: &RegUsageMapper) {
    fn map_use(m: &RegUsageMapper, r: &mut Reg) {
        if r.is_virtual() {
            let new = m.get_use(r.to_virtual_reg()).unwrap().to_reg();
            *r = new;
        }
    }

    fn map_def(m: &RegUsageMapper, r: &mut Writable<Reg>) {
        if r.to_reg().is_virtual() {
            let new = m.get_def(r.to_reg().to_virtual_reg()).unwrap().to_reg();
            *r = Writable::from_reg(new);
        }
    }

    fn map_mod(m: &RegUsageMapper, r: &mut Writable<Reg>) {
        if r.to_reg().is_virtual() {
            let new = m.get_mod(r.to_reg().to_virtual_reg()).unwrap().to_reg();
            *r = Writable::from_reg(new);
        }
    }

    fn map_mem(m: &RegUsageMapper, mem: &mut MemArg) {
        // N.B.: we take only the pre-map here, but this is OK because the
        // only addressing modes that update registers (pre/post-increment on
        // AArch64) both read and write registers, so they are "mods" rather
        // than "defs", so must be the same in both the pre- and post-map.
        match mem {
            &mut MemArg::Unscaled(ref mut reg, ..) => map_use(m, reg),
            &mut MemArg::UnsignedOffset(ref mut reg, ..) => map_use(m, reg),
            &mut MemArg::RegReg(ref mut r1, ref mut r2) => {
                map_use(m, r1);
                map_use(m, r2);
            }
            &mut MemArg::RegScaled(ref mut r1, ref mut r2, ..) => {
                map_use(m, r1);
                map_use(m, r2);
            }
            &mut MemArg::RegScaledExtended(ref mut r1, ref mut r2, ..) => {
                map_use(m, r1);
                map_use(m, r2);
            }
            &mut MemArg::Label(..) => {}
            &mut MemArg::PreIndexed(ref mut r, ..) => map_mod(m, r),
            &mut MemArg::PostIndexed(ref mut r, ..) => map_mod(m, r),
            &mut MemArg::FPOffset(..) | &mut MemArg::SPOffset(..) => {}
        };
    }

    fn map_pairmem(m: &RegUsageMapper, mem: &mut PairMemArg) {
        match mem {
            &mut PairMemArg::SignedOffset(ref mut reg, ..) => map_use(m, reg),
            &mut PairMemArg::PreIndexed(ref mut reg, ..) => map_def(m, reg),
            &mut PairMemArg::PostIndexed(ref mut reg, ..) => map_def(m, reg),
        }
    }

    fn map_br(m: &RegUsageMapper, br: &mut CondBrKind) {
        match br {
            &mut CondBrKind::Zero(ref mut reg) => map_use(m, reg),
            &mut CondBrKind::NotZero(ref mut reg) => map_use(m, reg),
            &mut CondBrKind::Cond(..) => {}
        };
    }

    match inst {
        &mut Inst::AluRRR {
            ref mut rd,
            ref mut rn,
            ref mut rm,
            ..
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
            map_use(mapper, rm);
        }
        &mut Inst::AluRRRR {
            ref mut rd,
            ref mut rn,
            ref mut rm,
            ref mut ra,
            ..
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
            map_use(mapper, rm);
            map_use(mapper, ra);
        }
        &mut Inst::AluRRImm12 {
            ref mut rd,
            ref mut rn,
            ..
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
        }
        &mut Inst::AluRRImmLogic {
            ref mut rd,
            ref mut rn,
            ..
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
        }
        &mut Inst::AluRRImmShift {
            ref mut rd,
            ref mut rn,
            ..
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
        }
        &mut Inst::AluRRRShift {
            ref mut rd,
            ref mut rn,
            ref mut rm,
            ..
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
            map_use(mapper, rm);
        }
        &mut Inst::AluRRRExtend {
            ref mut rd,
            ref mut rn,
            ref mut rm,
            ..
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
            map_use(mapper, rm);
        }
        &mut Inst::BitRR {
            ref mut rd,
            ref mut rn,
            ..
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
        }
        &mut Inst::ULoad8 {
            ref mut rd,
            ref mut mem,
            ..
        } => {
            map_def(mapper, rd);
            map_mem(mapper, mem);
        }
        &mut Inst::SLoad8 {
            ref mut rd,
            ref mut mem,
            ..
        } => {
            map_def(mapper, rd);
            map_mem(mapper, mem);
        }
        &mut Inst::ULoad16 {
            ref mut rd,
            ref mut mem,
            ..
        } => {
            map_def(mapper, rd);
            map_mem(mapper, mem);
        }
        &mut Inst::SLoad16 {
            ref mut rd,
            ref mut mem,
            ..
        } => {
            map_def(mapper, rd);
            map_mem(mapper, mem);
        }
        &mut Inst::ULoad32 {
            ref mut rd,
            ref mut mem,
            ..
        } => {
            map_def(mapper, rd);
            map_mem(mapper, mem);
        }
        &mut Inst::SLoad32 {
            ref mut rd,
            ref mut mem,
            ..
        } => {
            map_def(mapper, rd);
            map_mem(mapper, mem);
        }

        &mut Inst::ULoad64 {
            ref mut rd,
            ref mut mem,
            ..
        } => {
            map_def(mapper, rd);
            map_mem(mapper, mem);
        }
        &mut Inst::Store8 {
            ref mut rd,
            ref mut mem,
            ..
        } => {
            map_use(mapper, rd);
            map_mem(mapper, mem);
        }
        &mut Inst::Store16 {
            ref mut rd,
            ref mut mem,
            ..
        } => {
            map_use(mapper, rd);
            map_mem(mapper, mem);
        }
        &mut Inst::Store32 {
            ref mut rd,
            ref mut mem,
            ..
        } => {
            map_use(mapper, rd);
            map_mem(mapper, mem);
        }
        &mut Inst::Store64 {
            ref mut rd,
            ref mut mem,
            ..
        } => {
            map_use(mapper, rd);
            map_mem(mapper, mem);
        }

        &mut Inst::StoreP64 {
            ref mut rt,
            ref mut rt2,
            ref mut mem,
        } => {
            map_use(mapper, rt);
            map_use(mapper, rt2);
            map_pairmem(mapper, mem);
        }
        &mut Inst::LoadP64 {
            ref mut rt,
            ref mut rt2,
            ref mut mem,
        } => {
            map_def(mapper, rt);
            map_def(mapper, rt2);
            map_pairmem(mapper, mem);
        }
        &mut Inst::Mov {
            ref mut rd,
            ref mut rm,
        } => {
            map_def(mapper, rd);
            map_use(mapper, rm);
        }
        &mut Inst::Mov32 {
            ref mut rd,
            ref mut rm,
        } => {
            map_def(mapper, rd);
            map_use(mapper, rm);
        }
        &mut Inst::MovZ { ref mut rd, .. } => {
            map_def(mapper, rd);
        }
        &mut Inst::MovN { ref mut rd, .. } => {
            map_def(mapper, rd);
        }
        &mut Inst::MovK { ref mut rd, .. } => {
            map_def(mapper, rd);
        }
        &mut Inst::CSel {
            ref mut rd,
            ref mut rn,
            ref mut rm,
            ..
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
            map_use(mapper, rm);
        }
        &mut Inst::CSet { ref mut rd, .. } => {
            map_def(mapper, rd);
        }
        &mut Inst::CCmpImm { ref mut rn, .. } => {
            map_use(mapper, rn);
        }
        &mut Inst::FpuMove64 {
            ref mut rd,
            ref mut rn,
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
        }
        &mut Inst::FpuRR {
            ref mut rd,
            ref mut rn,
            ..
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
        }
        &mut Inst::FpuRRR {
            ref mut rd,
            ref mut rn,
            ref mut rm,
            ..
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
            map_use(mapper, rm);
        }
        &mut Inst::FpuRRRR {
            ref mut rd,
            ref mut rn,
            ref mut rm,
            ref mut ra,
            ..
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
            map_use(mapper, rm);
            map_use(mapper, ra);
        }
        &mut Inst::FpuCmp32 {
            ref mut rn,
            ref mut rm,
        } => {
            map_use(mapper, rn);
            map_use(mapper, rm);
        }
        &mut Inst::FpuCmp64 {
            ref mut rn,
            ref mut rm,
        } => {
            map_use(mapper, rn);
            map_use(mapper, rm);
        }
        &mut Inst::FpuLoad32 {
            ref mut rd,
            ref mut mem,
            ..
        } => {
            map_def(mapper, rd);
            map_mem(mapper, mem);
        }
        &mut Inst::FpuLoad64 {
            ref mut rd,
            ref mut mem,
            ..
        } => {
            map_def(mapper, rd);
            map_mem(mapper, mem);
        }
        &mut Inst::FpuLoad128 {
            ref mut rd,
            ref mut mem,
            ..
        } => {
            map_def(mapper, rd);
            map_mem(mapper, mem);
        }
        &mut Inst::FpuStore32 {
            ref mut rd,
            ref mut mem,
            ..
        } => {
            map_use(mapper, rd);
            map_mem(mapper, mem);
        }
        &mut Inst::FpuStore64 {
            ref mut rd,
            ref mut mem,
            ..
        } => {
            map_use(mapper, rd);
            map_mem(mapper, mem);
        }
        &mut Inst::FpuStore128 {
            ref mut rd,
            ref mut mem,
            ..
        } => {
            map_use(mapper, rd);
            map_mem(mapper, mem);
        }
        &mut Inst::LoadFpuConst32 { ref mut rd, .. } => {
            map_def(mapper, rd);
        }
        &mut Inst::LoadFpuConst64 { ref mut rd, .. } => {
            map_def(mapper, rd);
        }
        &mut Inst::FpuToInt {
            ref mut rd,
            ref mut rn,
            ..
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
        }
        &mut Inst::IntToFpu {
            ref mut rd,
            ref mut rn,
            ..
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
        }
        &mut Inst::FpuCSel32 {
            ref mut rd,
            ref mut rn,
            ref mut rm,
            ..
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
            map_use(mapper, rm);
        }
        &mut Inst::FpuCSel64 {
            ref mut rd,
            ref mut rn,
            ref mut rm,
            ..
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
            map_use(mapper, rm);
        }
        &mut Inst::FpuRound {
            ref mut rd,
            ref mut rn,
            ..
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
        }
        &mut Inst::MovToVec64 {
            ref mut rd,
            ref mut rn,
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
        }
        &mut Inst::MovFromVec64 {
            ref mut rd,
            ref mut rn,
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
        }
        &mut Inst::VecRRR {
            ref mut rd,
            ref mut rn,
            ref mut rm,
            ..
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
            map_use(mapper, rm);
        }
        &mut Inst::MovToNZCV { ref mut rn } => {
            map_use(mapper, rn);
        }
        &mut Inst::MovFromNZCV { ref mut rd } => {
            map_def(mapper, rd);
        }
        &mut Inst::CondSet { ref mut rd, .. } => {
            map_def(mapper, rd);
        }
        &mut Inst::Extend {
            ref mut rd,
            ref mut rn,
            ..
        } => {
            map_def(mapper, rd);
            map_use(mapper, rn);
        }
        &mut Inst::Jump { .. } => {}
        &mut Inst::Call {
            ref mut uses,
            ref mut defs,
            ..
        } => {
            // TODO: add `map_mut()` to regalloc.rs's Set.
            let new_uses = uses.map(|r| {
                let mut r = *r;
                map_use(mapper, &mut r);
                r
            });
            let new_defs = defs.map(|r| {
                let mut r = *r;
                map_def(mapper, &mut r);
                r
            });
            *uses = new_uses;
            *defs = new_defs;
        }
        &mut Inst::Ret | &mut Inst::EpiloguePlaceholder => {}
        &mut Inst::CallInd {
            ref mut uses,
            ref mut defs,
            ref mut rn,
            ..
        } => {
            // TODO: add `map_mut()` to regalloc.rs's Set.
            let new_uses = uses.map(|r| {
                let mut r = *r;
                map_use(mapper, &mut r);
                r
            });
            let new_defs = defs.map(|r| {
                let mut r = *r;
                map_def(mapper, &mut r);
                r
            });
            *uses = new_uses;
            *defs = new_defs;
            map_use(mapper, rn);
        }
        &mut Inst::CondBr { ref mut kind, .. } => {
            map_br(mapper, kind);
        }
        &mut Inst::CondBrLowered { ref mut kind, .. } => {
            map_br(mapper, kind);
        }
        &mut Inst::CondBrLoweredCompound { ref mut kind, .. } => {
            map_br(mapper, kind);
        }
        &mut Inst::IndirectBr { ref mut rn, .. } => {
            map_use(mapper, rn);
        }
        &mut Inst::Nop0 | &mut Inst::Nop4 | &mut Inst::Brk | &mut Inst::Udf { .. } => {}
        &mut Inst::Adr { ref mut rd, .. } => {
            map_def(mapper, rd);
        }
        &mut Inst::Word4 { .. } | &mut Inst::Word8 { .. } => {}
        &mut Inst::JTSequence {
            ref mut ridx,
            ref mut rtmp1,
            ref mut rtmp2,
            ..
        } => {
            map_use(mapper, ridx);
            map_def(mapper, rtmp1);
            map_def(mapper, rtmp2);
        }
        &mut Inst::LoadConst64 { ref mut rd, .. } => {
            map_def(mapper, rd);
        }
        &mut Inst::LoadExtName { ref mut rd, .. } => {
            map_def(mapper, rd);
        }
        &mut Inst::LoadAddr {
            ref mut rd,
            ref mut mem,
        } => {
            map_def(mapper, rd);
            map_mem(mapper, mem);
        }
        &mut Inst::GetPinnedReg { ref mut rd } => {
            map_def(mapper, rd);
        }
        &mut Inst::SetPinnedReg { ref mut rm } => {
            map_use(mapper, rm);
        }
    }
}

//=============================================================================
// Instructions: misc functions and external interface

impl MachInst for Inst {
    fn get_regs(&self, collector: &mut RegUsageCollector) {
        aarch64_get_regs(self, collector)
    }

    fn map_regs(&mut self, mapper: &RegUsageMapper) {
        aarch64_map_regs(self, mapper);
    }

    fn is_move(&self) -> Option<(Writable<Reg>, Reg)> {
        match self {
            &Inst::Mov { rd, rm } => Some((rd, rm)),
            &Inst::FpuMove64 { rd, rn } => Some((rd, rn)),
            _ => None,
        }
    }

    fn is_epilogue_placeholder(&self) -> bool {
        if let Inst::EpiloguePlaceholder = self {
            true
        } else {
            false
        }
    }

    fn is_term<'a>(&'a self) -> MachTerminator<'a> {
        match self {
            &Inst::Ret | &Inst::EpiloguePlaceholder => MachTerminator::Ret,
            &Inst::Jump { dest } => MachTerminator::Uncond(dest.as_block_index().unwrap()),
            &Inst::CondBr {
                taken, not_taken, ..
            } => MachTerminator::Cond(
                taken.as_block_index().unwrap(),
                not_taken.as_block_index().unwrap(),
            ),
            &Inst::CondBrLowered { .. } => {
                // When this is used prior to branch finalization for branches
                // within an open-coded sequence, i.e. with ResolvedOffsets,
                // do not consider it a terminator. From the point of view of CFG analysis,
                // it is part of a black-box single-in single-out region, hence is not
                // denoted a terminator.
                MachTerminator::None
            }
            &Inst::CondBrLoweredCompound { .. } => {
                panic!("is_term() called after lowering branches");
            }
            &Inst::IndirectBr { ref targets, .. } => MachTerminator::Indirect(&targets[..]),
            &Inst::JTSequence {
                ref targets_for_term,
                ..
            } => MachTerminator::Indirect(&targets_for_term[..]),
            _ => MachTerminator::None,
        }
    }

    fn gen_move(to_reg: Writable<Reg>, from_reg: Reg, ty: Type) -> Inst {
        assert!(ty.bits() <= 64); // no vector support yet!
        Inst::mov(to_reg, from_reg)
    }

    fn gen_zero_len_nop() -> Inst {
        Inst::Nop0
    }

    fn gen_nop(preferred_size: usize) -> Inst {
        // We can't give a NOP (or any insn) < 4 bytes.
        assert!(preferred_size >= 4);
        Inst::Nop4
    }

    fn maybe_direct_reload(&self, _reg: VirtualReg, _slot: SpillSlot) -> Option<Inst> {
        None
    }

    fn rc_for_type(ty: Type) -> CodegenResult<RegClass> {
        match ty {
            I8 | I16 | I32 | I64 | B1 | B8 | B16 | B32 | B64 => Ok(RegClass::I64),
            F32 | F64 => Ok(RegClass::V128),
            IFLAGS | FFLAGS => Ok(RegClass::I64),
            _ => Err(CodegenError::Unsupported(format!(
                "Unexpected SSA-value type: {}",
                ty
            ))),
        }
    }

    fn gen_jump(blockindex: BlockIndex) -> Inst {
        Inst::Jump {
            dest: BranchTarget::Block(blockindex),
        }
    }

    fn with_block_rewrites(&mut self, block_target_map: &[BlockIndex]) {
        match self {
            &mut Inst::Jump { ref mut dest } => {
                dest.map(block_target_map);
            }
            &mut Inst::CondBr {
                ref mut taken,
                ref mut not_taken,
                ..
            } => {
                taken.map(block_target_map);
                not_taken.map(block_target_map);
            }
            &mut Inst::CondBrLowered { .. } => {
                // See note in `is_term()`: this is used in open-coded sequences
                // within blocks and should be left alone.
            }
            &mut Inst::CondBrLoweredCompound { .. } => {
                panic!("with_block_rewrites called after branch lowering!");
            }
            _ => {}
        }
    }

    fn with_fallthrough_block(&mut self, fallthrough: Option<BlockIndex>) {
        match self {
            &mut Inst::CondBr {
                taken,
                not_taken,
                kind,
            } => {
                if taken.as_block_index() == fallthrough
                    && not_taken.as_block_index() == fallthrough
                {
                    *self = Inst::Nop0;
                } else if taken.as_block_index() == fallthrough {
                    *self = Inst::CondBrLowered {
                        target: not_taken,
                        kind: kind.invert(),
                    };
                } else if not_taken.as_block_index() == fallthrough {
                    *self = Inst::CondBrLowered {
                        target: taken,
                        kind,
                    };
                } else {
                    // We need a compound sequence (condbr / uncond-br).
                    *self = Inst::CondBrLoweredCompound {
                        taken,
                        not_taken,
                        kind,
                    };
                }
            }
            &mut Inst::Jump { dest } => {
                if dest.as_block_index() == fallthrough {
                    *self = Inst::Nop0;
                }
            }
            _ => {}
        }
    }

    fn with_block_offsets(&mut self, my_offset: CodeOffset, targets: &[CodeOffset]) {
        match self {
            &mut Inst::CondBrLowered { ref mut target, .. } => {
                target.lower(targets, my_offset);
            }
            &mut Inst::CondBrLoweredCompound {
                ref mut taken,
                ref mut not_taken,
                ..
            } => {
                taken.lower(targets, my_offset);
                not_taken.lower(targets, my_offset + 4);
            }
            &mut Inst::Jump { ref mut dest } => {
                dest.lower(targets, my_offset);
            }
            &mut Inst::JTSequence {
                targets: ref mut t, ..
            } => {
                for target in t {
                    // offset+20: jumptable is 20 bytes into compound sequence.
                    target.lower(targets, my_offset + 20);
                }
            }
            _ => {}
        }
    }

    fn reg_universe(flags: &settings::Flags) -> RealRegUniverse {
        create_reg_universe(flags)
    }
}

//=============================================================================
// Pretty-printing of instructions.

fn mem_finalize_for_show(mem: &MemArg, mb_rru: Option<&RealRegUniverse>) -> (String, MemArg) {
    let (mem_insts, mem) = mem_finalize(0, mem);
    let mut mem_str = mem_insts
        .into_iter()
        .map(|inst| inst.show_rru(mb_rru))
        .collect::<Vec<_>>()
        .join(" ; ");
    if !mem_str.is_empty() {
        mem_str += " ; ";
    }

    (mem_str, mem)
}

impl ShowWithRRU for Inst {
    fn show_rru(&self, mb_rru: Option<&RealRegUniverse>) -> String {
        fn op_name_size(alu_op: ALUOp) -> (&'static str, InstSize) {
            match alu_op {
                ALUOp::Add32 => ("add", InstSize::Size32),
                ALUOp::Add64 => ("add", InstSize::Size64),
                ALUOp::Sub32 => ("sub", InstSize::Size32),
                ALUOp::Sub64 => ("sub", InstSize::Size64),
                ALUOp::Orr32 => ("orr", InstSize::Size32),
                ALUOp::Orr64 => ("orr", InstSize::Size64),
                ALUOp::And32 => ("and", InstSize::Size32),
                ALUOp::And64 => ("and", InstSize::Size64),
                ALUOp::Eor32 => ("eor", InstSize::Size32),
                ALUOp::Eor64 => ("eor", InstSize::Size64),
                ALUOp::AddS32 => ("adds", InstSize::Size32),
                ALUOp::AddS64 => ("adds", InstSize::Size64),
                ALUOp::SubS32 => ("subs", InstSize::Size32),
                ALUOp::SubS64 => ("subs", InstSize::Size64),
                ALUOp::SubS64XR => ("subs", InstSize::Size64),
                ALUOp::MAdd32 => ("madd", InstSize::Size32),
                ALUOp::MAdd64 => ("madd", InstSize::Size64),
                ALUOp::MSub32 => ("msub", InstSize::Size32),
                ALUOp::MSub64 => ("msub", InstSize::Size64),
                ALUOp::SMulH => ("smulh", InstSize::Size64),
                ALUOp::UMulH => ("umulh", InstSize::Size64),
                ALUOp::SDiv64 => ("sdiv", InstSize::Size64),
                ALUOp::UDiv64 => ("udiv", InstSize::Size64),
                ALUOp::AndNot32 => ("bic", InstSize::Size32),
                ALUOp::AndNot64 => ("bic", InstSize::Size64),
                ALUOp::OrrNot32 => ("orn", InstSize::Size32),
                ALUOp::OrrNot64 => ("orn", InstSize::Size64),
                ALUOp::EorNot32 => ("eon", InstSize::Size32),
                ALUOp::EorNot64 => ("eon", InstSize::Size64),
                ALUOp::RotR32 => ("ror", InstSize::Size32),
                ALUOp::RotR64 => ("ror", InstSize::Size64),
                ALUOp::Lsr32 => ("lsr", InstSize::Size32),
                ALUOp::Lsr64 => ("lsr", InstSize::Size64),
                ALUOp::Asr32 => ("asr", InstSize::Size32),
                ALUOp::Asr64 => ("asr", InstSize::Size64),
                ALUOp::Lsl32 => ("lsl", InstSize::Size32),
                ALUOp::Lsl64 => ("lsl", InstSize::Size64),
            }
        }

        match self {
            &Inst::Nop0 => "nop-zero-len".to_string(),
            &Inst::Nop4 => "nop".to_string(),
            &Inst::AluRRR { alu_op, rd, rn, rm } => {
                let (op, size) = op_name_size(alu_op);
                let rd = show_ireg_sized(rd.to_reg(), mb_rru, size);
                let rn = show_ireg_sized(rn, mb_rru, size);
                let rm = show_ireg_sized(rm, mb_rru, size);
                format!("{} {}, {}, {}", op, rd, rn, rm)
            }
            &Inst::AluRRRR {
                alu_op,
                rd,
                rn,
                rm,
                ra,
            } => {
                let (op, size) = op_name_size(alu_op);
                let four_args = alu_op != ALUOp::SMulH && alu_op != ALUOp::UMulH;
                let rd = show_ireg_sized(rd.to_reg(), mb_rru, size);
                let rn = show_ireg_sized(rn, mb_rru, size);
                let rm = show_ireg_sized(rm, mb_rru, size);
                let ra = show_ireg_sized(ra, mb_rru, size);
                if four_args {
                    format!("{} {}, {}, {}, {}", op, rd, rn, rm, ra)
                } else {
                    // smulh and umulh have Ra "hard-wired" to the zero register
                    // and the canonical assembly form has only three regs.
                    format!("{} {}, {}, {}", op, rd, rn, rm)
                }
            }
            &Inst::AluRRImm12 {
                alu_op,
                rd,
                rn,
                ref imm12,
            } => {
                let (op, size) = op_name_size(alu_op);
                let rd = show_ireg_sized(rd.to_reg(), mb_rru, size);
                let rn = show_ireg_sized(rn, mb_rru, size);

                if imm12.bits == 0 && alu_op == ALUOp::Add64 {
                    // special-case MOV (used for moving into SP).
                    format!("mov {}, {}", rd, rn)
                } else {
                    let imm12 = imm12.show_rru(mb_rru);
                    format!("{} {}, {}, {}", op, rd, rn, imm12)
                }
            }
            &Inst::AluRRImmLogic {
                alu_op,
                rd,
                rn,
                ref imml,
            } => {
                let (op, size) = op_name_size(alu_op);
                let rd = show_ireg_sized(rd.to_reg(), mb_rru, size);
                let rn = show_ireg_sized(rn, mb_rru, size);
                let imml = imml.show_rru(mb_rru);
                format!("{} {}, {}, {}", op, rd, rn, imml)
            }
            &Inst::AluRRImmShift {
                alu_op,
                rd,
                rn,
                ref immshift,
            } => {
                let (op, size) = op_name_size(alu_op);
                let rd = show_ireg_sized(rd.to_reg(), mb_rru, size);
                let rn = show_ireg_sized(rn, mb_rru, size);
                let immshift = immshift.show_rru(mb_rru);
                format!("{} {}, {}, {}", op, rd, rn, immshift)
            }
            &Inst::AluRRRShift {
                alu_op,
                rd,
                rn,
                rm,
                ref shiftop,
            } => {
                let (op, size) = op_name_size(alu_op);
                let rd = show_ireg_sized(rd.to_reg(), mb_rru, size);
                let rn = show_ireg_sized(rn, mb_rru, size);
                let rm = show_ireg_sized(rm, mb_rru, size);
                let shiftop = shiftop.show_rru(mb_rru);
                format!("{} {}, {}, {}, {}", op, rd, rn, rm, shiftop)
            }
            &Inst::AluRRRExtend {
                alu_op,
                rd,
                rn,
                rm,
                ref extendop,
            } => {
                let (op, size) = op_name_size(alu_op);
                let rd = show_ireg_sized(rd.to_reg(), mb_rru, size);
                let rn = show_ireg_sized(rn, mb_rru, size);
                let rm = show_ireg_sized(rm, mb_rru, size);
                let extendop = extendop.show_rru(mb_rru);
                format!("{} {}, {}, {}, {}", op, rd, rn, rm, extendop)
            }
            &Inst::BitRR { op, rd, rn } => {
                let size = op.inst_size();
                let op = op.op_str();
                let rd = show_ireg_sized(rd.to_reg(), mb_rru, size);
                let rn = show_ireg_sized(rn, mb_rru, size);
                format!("{} {}, {}", op, rd, rn)
            }
            &Inst::ULoad8 {
                rd,
                ref mem,
                srcloc: _srcloc,
            }
            | &Inst::SLoad8 {
                rd,
                ref mem,
                srcloc: _srcloc,
            }
            | &Inst::ULoad16 {
                rd,
                ref mem,
                srcloc: _srcloc,
            }
            | &Inst::SLoad16 {
                rd,
                ref mem,
                srcloc: _srcloc,
            }
            | &Inst::ULoad32 {
                rd,
                ref mem,
                srcloc: _srcloc,
            }
            | &Inst::SLoad32 {
                rd,
                ref mem,
                srcloc: _srcloc,
            }
            | &Inst::ULoad64 {
                rd,
                ref mem,
                srcloc: _srcloc,
                ..
            } => {
                let (mem_str, mem) = mem_finalize_for_show(mem, mb_rru);

                let is_unscaled = match &mem {
                    &MemArg::Unscaled(..) => true,
                    _ => false,
                };
                let (op, size) = match (self, is_unscaled) {
                    (&Inst::ULoad8 { .. }, false) => ("ldrb", InstSize::Size32),
                    (&Inst::ULoad8 { .. }, true) => ("ldurb", InstSize::Size32),
                    (&Inst::SLoad8 { .. }, false) => ("ldrsb", InstSize::Size64),
                    (&Inst::SLoad8 { .. }, true) => ("ldursb", InstSize::Size64),
                    (&Inst::ULoad16 { .. }, false) => ("ldrh", InstSize::Size32),
                    (&Inst::ULoad16 { .. }, true) => ("ldurh", InstSize::Size32),
                    (&Inst::SLoad16 { .. }, false) => ("ldrsh", InstSize::Size64),
                    (&Inst::SLoad16 { .. }, true) => ("ldursh", InstSize::Size64),
                    (&Inst::ULoad32 { .. }, false) => ("ldr", InstSize::Size32),
                    (&Inst::ULoad32 { .. }, true) => ("ldur", InstSize::Size32),
                    (&Inst::SLoad32 { .. }, false) => ("ldrsw", InstSize::Size64),
                    (&Inst::SLoad32 { .. }, true) => ("ldursw", InstSize::Size64),
                    (&Inst::ULoad64 { .. }, false) => ("ldr", InstSize::Size64),
                    (&Inst::ULoad64 { .. }, true) => ("ldur", InstSize::Size64),
                    _ => unreachable!(),
                };
                let rd = show_ireg_sized(rd.to_reg(), mb_rru, size);
                let mem = mem.show_rru(mb_rru);
                format!("{}{} {}, {}", mem_str, op, rd, mem)
            }
            &Inst::Store8 {
                rd,
                ref mem,
                srcloc: _srcloc,
            }
            | &Inst::Store16 {
                rd,
                ref mem,
                srcloc: _srcloc,
            }
            | &Inst::Store32 {
                rd,
                ref mem,
                srcloc: _srcloc,
            }
            | &Inst::Store64 {
                rd,
                ref mem,
                srcloc: _srcloc,
                ..
            } => {
                let (mem_str, mem) = mem_finalize_for_show(mem, mb_rru);

                let is_unscaled = match &mem {
                    &MemArg::Unscaled(..) => true,
                    _ => false,
                };
                let (op, size) = match (self, is_unscaled) {
                    (&Inst::Store8 { .. }, false) => ("strb", InstSize::Size32),
                    (&Inst::Store8 { .. }, true) => ("sturb", InstSize::Size32),
                    (&Inst::Store16 { .. }, false) => ("strh", InstSize::Size32),
                    (&Inst::Store16 { .. }, true) => ("sturh", InstSize::Size32),
                    (&Inst::Store32 { .. }, false) => ("str", InstSize::Size32),
                    (&Inst::Store32 { .. }, true) => ("stur", InstSize::Size32),
                    (&Inst::Store64 { .. }, false) => ("str", InstSize::Size64),
                    (&Inst::Store64 { .. }, true) => ("stur", InstSize::Size64),
                    _ => unreachable!(),
                };
                let rd = show_ireg_sized(rd, mb_rru, size);
                let mem = mem.show_rru(mb_rru);
                format!("{}{} {}, {}", mem_str, op, rd, mem)
            }
            &Inst::StoreP64 { rt, rt2, ref mem } => {
                let rt = rt.show_rru(mb_rru);
                let rt2 = rt2.show_rru(mb_rru);
                let mem = mem.show_rru_sized(mb_rru, /* size = */ 8);
                format!("stp {}, {}, {}", rt, rt2, mem)
            }
            &Inst::LoadP64 { rt, rt2, ref mem } => {
                let rt = rt.to_reg().show_rru(mb_rru);
                let rt2 = rt2.to_reg().show_rru(mb_rru);
                let mem = mem.show_rru_sized(mb_rru, /* size = */ 8);
                format!("ldp {}, {}, {}", rt, rt2, mem)
            }
            &Inst::Mov { rd, rm } => {
                let rd = rd.to_reg().show_rru(mb_rru);
                let rm = rm.show_rru(mb_rru);
                format!("mov {}, {}", rd, rm)
            }
            &Inst::Mov32 { rd, rm } => {
                let rd = show_ireg_sized(rd.to_reg(), mb_rru, InstSize::Size32);
                let rm = show_ireg_sized(rm, mb_rru, InstSize::Size32);
                format!("mov {}, {}", rd, rm)
            }
            &Inst::MovZ { rd, ref imm } => {
                let rd = rd.to_reg().show_rru(mb_rru);
                let imm = imm.show_rru(mb_rru);
                format!("movz {}, {}", rd, imm)
            }
            &Inst::MovN { rd, ref imm } => {
                let rd = rd.to_reg().show_rru(mb_rru);
                let imm = imm.show_rru(mb_rru);
                format!("movn {}, {}", rd, imm)
            }
            &Inst::MovK { rd, ref imm } => {
                let rd = rd.to_reg().show_rru(mb_rru);
                let imm = imm.show_rru(mb_rru);
                format!("movk {}, {}", rd, imm)
            }
            &Inst::CSel { rd, rn, rm, cond } => {
                let rd = rd.to_reg().show_rru(mb_rru);
                let rn = rn.show_rru(mb_rru);
                let rm = rm.show_rru(mb_rru);
                let cond = cond.show_rru(mb_rru);
                format!("csel {}, {}, {}, {}", rd, rn, rm, cond)
            }
            &Inst::CSet { rd, cond } => {
                let rd = rd.to_reg().show_rru(mb_rru);
                let cond = cond.show_rru(mb_rru);
                format!("cset {}, {}", rd, cond)
            }
            &Inst::CCmpImm {
                size,
                rn,
                imm,
                nzcv,
                cond,
            } => {
                let rn = show_ireg_sized(rn, mb_rru, size);
                let imm = imm.show_rru(mb_rru);
                let nzcv = nzcv.show_rru(mb_rru);
                let cond = cond.show_rru(mb_rru);
                format!("ccmp {}, {}, {}, {}", rn, imm, nzcv, cond)
            }
            &Inst::FpuMove64 { rd, rn } => {
                let rd = rd.to_reg().show_rru(mb_rru);
                let rn = rn.show_rru(mb_rru);
                format!("mov {}.8b, {}.8b", rd, rn)
            }
            &Inst::FpuRR { fpu_op, rd, rn } => {
                let (op, sizesrc, sizedest) = match fpu_op {
                    FPUOp1::Abs32 => ("fabs", InstSize::Size32, InstSize::Size32),
                    FPUOp1::Abs64 => ("fabs", InstSize::Size64, InstSize::Size64),
                    FPUOp1::Neg32 => ("fneg", InstSize::Size32, InstSize::Size32),
                    FPUOp1::Neg64 => ("fneg", InstSize::Size64, InstSize::Size64),
                    FPUOp1::Sqrt32 => ("fsqrt", InstSize::Size32, InstSize::Size32),
                    FPUOp1::Sqrt64 => ("fsqrt", InstSize::Size64, InstSize::Size64),
                    FPUOp1::Cvt32To64 => ("fcvt", InstSize::Size32, InstSize::Size64),
                    FPUOp1::Cvt64To32 => ("fcvt", InstSize::Size64, InstSize::Size32),
                };
                let rd = show_freg_sized(rd.to_reg(), mb_rru, sizedest);
                let rn = show_freg_sized(rn, mb_rru, sizesrc);
                format!("{} {}, {}", op, rd, rn)
            }
            &Inst::FpuRRR { fpu_op, rd, rn, rm } => {
                let (op, size) = match fpu_op {
                    FPUOp2::Add32 => ("fadd", InstSize::Size32),
                    FPUOp2::Add64 => ("fadd", InstSize::Size64),
                    FPUOp2::Sub32 => ("fsub", InstSize::Size32),
                    FPUOp2::Sub64 => ("fsub", InstSize::Size64),
                    FPUOp2::Mul32 => ("fmul", InstSize::Size32),
                    FPUOp2::Mul64 => ("fmul", InstSize::Size64),
                    FPUOp2::Div32 => ("fdiv", InstSize::Size32),
                    FPUOp2::Div64 => ("fdiv", InstSize::Size64),
                    FPUOp2::Max32 => ("fmax", InstSize::Size32),
                    FPUOp2::Max64 => ("fmax", InstSize::Size64),
                    FPUOp2::Min32 => ("fmin", InstSize::Size32),
                    FPUOp2::Min64 => ("fmin", InstSize::Size64),
                };
                let rd = show_freg_sized(rd.to_reg(), mb_rru, size);
                let rn = show_freg_sized(rn, mb_rru, size);
                let rm = show_freg_sized(rm, mb_rru, size);
                format!("{} {}, {}, {}", op, rd, rn, rm)
            }
            &Inst::FpuRRRR {
                fpu_op,
                rd,
                rn,
                rm,
                ra,
            } => {
                let (op, size) = match fpu_op {
                    FPUOp3::MAdd32 => ("fmadd", InstSize::Size32),
                    FPUOp3::MAdd64 => ("fmadd", InstSize::Size64),
                };
                let rd = show_freg_sized(rd.to_reg(), mb_rru, size);
                let rn = show_freg_sized(rn, mb_rru, size);
                let rm = show_freg_sized(rm, mb_rru, size);
                let ra = show_freg_sized(ra, mb_rru, size);
                format!("{} {}, {}, {}, {}", op, rd, rn, rm, ra)
            }
            &Inst::FpuCmp32 { rn, rm } => {
                let rn = show_freg_sized(rn, mb_rru, InstSize::Size32);
                let rm = show_freg_sized(rm, mb_rru, InstSize::Size32);
                format!("fcmp {}, {}", rn, rm)
            }
            &Inst::FpuCmp64 { rn, rm } => {
                let rn = show_freg_sized(rn, mb_rru, InstSize::Size64);
                let rm = show_freg_sized(rm, mb_rru, InstSize::Size64);
                format!("fcmp {}, {}", rn, rm)
            }
            &Inst::FpuLoad32 { rd, ref mem, .. } => {
                let rd = show_freg_sized(rd.to_reg(), mb_rru, InstSize::Size32);
                let (mem_str, mem) = mem_finalize_for_show(mem, mb_rru);
                let mem = mem.show_rru(mb_rru);
                format!("{}ldr {}, {}", mem_str, rd, mem)
            }
            &Inst::FpuLoad64 { rd, ref mem, .. } => {
                let rd = show_freg_sized(rd.to_reg(), mb_rru, InstSize::Size64);
                let (mem_str, mem) = mem_finalize_for_show(mem, mb_rru);
                let mem = mem.show_rru(mb_rru);
                format!("{}ldr {}, {}", mem_str, rd, mem)
            }
            &Inst::FpuLoad128 { rd, ref mem, .. } => {
                let rd = rd.to_reg().show_rru(mb_rru);
                let rd = "q".to_string() + &rd[1..];
                let (mem_str, mem) = mem_finalize_for_show(mem, mb_rru);
                let mem = mem.show_rru(mb_rru);
                format!("{}ldr {}, {}", mem_str, rd, mem)
            }
            &Inst::FpuStore32 { rd, ref mem, .. } => {
                let rd = show_freg_sized(rd, mb_rru, InstSize::Size32);
                let (mem_str, mem) = mem_finalize_for_show(mem, mb_rru);
                let mem = mem.show_rru(mb_rru);
                format!("{}str {}, {}", mem_str, rd, mem)
            }
            &Inst::FpuStore64 { rd, ref mem, .. } => {
                let rd = show_freg_sized(rd, mb_rru, InstSize::Size64);
                let (mem_str, mem) = mem_finalize_for_show(mem, mb_rru);
                let mem = mem.show_rru(mb_rru);
                format!("{}str {}, {}", mem_str, rd, mem)
            }
            &Inst::FpuStore128 { rd, ref mem, .. } => {
                let rd = rd.show_rru(mb_rru);
                let rd = "q".to_string() + &rd[1..];
                let (mem_str, mem) = mem_finalize_for_show(mem, mb_rru);
                let mem = mem.show_rru(mb_rru);
                format!("{}str {}, {}", mem_str, rd, mem)
            }
            &Inst::LoadFpuConst32 { rd, const_data } => {
                let rd = show_freg_sized(rd.to_reg(), mb_rru, InstSize::Size32);
                format!("ldr {}, pc+8 ; b 8 ; data.f32 {}", rd, const_data)
            }
            &Inst::LoadFpuConst64 { rd, const_data } => {
                let rd = show_freg_sized(rd.to_reg(), mb_rru, InstSize::Size64);
                format!("ldr {}, pc+8 ; b 12 ; data.f64 {}", rd, const_data)
            }
            &Inst::FpuToInt { op, rd, rn } => {
                let (op, sizesrc, sizedest) = match op {
                    FpuToIntOp::F32ToI32 => ("fcvtzs", InstSize::Size32, InstSize::Size32),
                    FpuToIntOp::F32ToU32 => ("fcvtzu", InstSize::Size32, InstSize::Size32),
                    FpuToIntOp::F32ToI64 => ("fcvtzs", InstSize::Size32, InstSize::Size64),
                    FpuToIntOp::F32ToU64 => ("fcvtzu", InstSize::Size32, InstSize::Size64),
                    FpuToIntOp::F64ToI32 => ("fcvtzs", InstSize::Size64, InstSize::Size32),
                    FpuToIntOp::F64ToU32 => ("fcvtzu", InstSize::Size64, InstSize::Size32),
                    FpuToIntOp::F64ToI64 => ("fcvtzs", InstSize::Size64, InstSize::Size64),
                    FpuToIntOp::F64ToU64 => ("fcvtzu", InstSize::Size64, InstSize::Size64),
                };
                let rd = show_ireg_sized(rd.to_reg(), mb_rru, sizedest);
                let rn = show_freg_sized(rn, mb_rru, sizesrc);
                format!("{} {}, {}", op, rd, rn)
            }
            &Inst::IntToFpu { op, rd, rn } => {
                let (op, sizesrc, sizedest) = match op {
                    IntToFpuOp::I32ToF32 => ("scvtf", InstSize::Size32, InstSize::Size32),
                    IntToFpuOp::U32ToF32 => ("ucvtf", InstSize::Size32, InstSize::Size32),
                    IntToFpuOp::I64ToF32 => ("scvtf", InstSize::Size64, InstSize::Size32),
                    IntToFpuOp::U64ToF32 => ("ucvtf", InstSize::Size64, InstSize::Size32),
                    IntToFpuOp::I32ToF64 => ("scvtf", InstSize::Size32, InstSize::Size64),
                    IntToFpuOp::U32ToF64 => ("ucvtf", InstSize::Size32, InstSize::Size64),
                    IntToFpuOp::I64ToF64 => ("scvtf", InstSize::Size64, InstSize::Size64),
                    IntToFpuOp::U64ToF64 => ("ucvtf", InstSize::Size64, InstSize::Size64),
                };
                let rd = show_freg_sized(rd.to_reg(), mb_rru, sizedest);
                let rn = show_ireg_sized(rn, mb_rru, sizesrc);
                format!("{} {}, {}", op, rd, rn)
            }
            &Inst::FpuCSel32 { rd, rn, rm, cond } => {
                let rd = show_freg_sized(rd.to_reg(), mb_rru, InstSize::Size32);
                let rn = show_freg_sized(rn, mb_rru, InstSize::Size32);
                let rm = show_freg_sized(rm, mb_rru, InstSize::Size32);
                let cond = cond.show_rru(mb_rru);
                format!("fcsel {}, {}, {}, {}", rd, rn, rm, cond)
            }
            &Inst::FpuCSel64 { rd, rn, rm, cond } => {
                let rd = show_freg_sized(rd.to_reg(), mb_rru, InstSize::Size64);
                let rn = show_freg_sized(rn, mb_rru, InstSize::Size64);
                let rm = show_freg_sized(rm, mb_rru, InstSize::Size64);
                let cond = cond.show_rru(mb_rru);
                format!("fcsel {}, {}, {}, {}", rd, rn, rm, cond)
            }
            &Inst::FpuRound { op, rd, rn } => {
                let (inst, size) = match op {
                    FpuRoundMode::Minus32 => ("frintm", InstSize::Size32),
                    FpuRoundMode::Minus64 => ("frintm", InstSize::Size64),
                    FpuRoundMode::Plus32 => ("frintp", InstSize::Size32),
                    FpuRoundMode::Plus64 => ("frintp", InstSize::Size64),
                    FpuRoundMode::Zero32 => ("frintz", InstSize::Size32),
                    FpuRoundMode::Zero64 => ("frintz", InstSize::Size64),
                    FpuRoundMode::Nearest32 => ("frintn", InstSize::Size32),
                    FpuRoundMode::Nearest64 => ("frintn", InstSize::Size64),
                };
                let rd = show_freg_sized(rd.to_reg(), mb_rru, size);
                let rn = show_freg_sized(rn, mb_rru, size);
                format!("{} {}, {}", inst, rd, rn)
            }
            &Inst::MovToVec64 { rd, rn } => {
                let rd = rd.to_reg().show_rru(mb_rru);
                let rn = rn.show_rru(mb_rru);
                format!("mov {}.d[0], {}", rd, rn)
            }
            &Inst::MovFromVec64 { rd, rn } => {
                let rd = rd.to_reg().show_rru(mb_rru);
                let rn = rn.show_rru(mb_rru);
                format!("mov {}, {}.d[0]", rd, rn)
            }
            &Inst::VecRRR { rd, rn, rm, alu_op } => {
                let op = match alu_op {
                    VecALUOp::SQAddScalar => "sqadd",
                    VecALUOp::UQAddScalar => "uqadd",
                    VecALUOp::SQSubScalar => "sqsub",
                    VecALUOp::UQSubScalar => "uqsub",
                };
                let rd = show_vreg_scalar(rd.to_reg(), mb_rru);
                let rn = show_vreg_scalar(rn, mb_rru);
                let rm = show_vreg_scalar(rm, mb_rru);
                format!("{} {}, {}, {}", op, rd, rn, rm)
            }
            &Inst::MovToNZCV { rn } => {
                let rn = rn.show_rru(mb_rru);
                format!("msr nzcv, {}", rn)
            }
            &Inst::MovFromNZCV { rd } => {
                let rd = rd.to_reg().show_rru(mb_rru);
                format!("mrs {}, nzcv", rd)
            }
            &Inst::CondSet { rd, cond } => {
                let rd = rd.to_reg().show_rru(mb_rru);
                let cond = cond.show_rru(mb_rru);
                format!("cset {}, {}", rd, cond)
            }
            &Inst::Extend {
                rd,
                rn,
                signed,
                from_bits,
                to_bits,
            } if from_bits >= 8 => {
                // Is the destination a 32-bit register? Corresponds to whether
                // extend-to width is <= 32 bits, *unless* we have an unsigned
                // 32-to-64-bit extension, which is implemented with a "mov" to a
                // 32-bit (W-reg) dest, because this zeroes the top 32 bits.
                let dest_size = if !signed && from_bits == 32 && to_bits == 64 {
                    InstSize::Size32
                } else {
                    InstSize::from_bits(to_bits)
                };
                let rd = show_ireg_sized(rd.to_reg(), mb_rru, dest_size);
                let rn = show_ireg_sized(rn, mb_rru, InstSize::from_bits(from_bits));
                let op = match (signed, from_bits, to_bits) {
                    (false, 8, 32) => "uxtb",
                    (true, 8, 32) => "sxtb",
                    (false, 16, 32) => "uxth",
                    (true, 16, 32) => "sxth",
                    (false, 8, 64) => "uxtb",
                    (true, 8, 64) => "sxtb",
                    (false, 16, 64) => "uxth",
                    (true, 16, 64) => "sxth",
                    (false, 32, 64) => "mov", // special case (see above).
                    (true, 32, 64) => "sxtw",
                    _ => panic!("Unsupported Extend case: {:?}", self),
                };
                format!("{} {}, {}", op, rd, rn)
            }
            &Inst::Extend {
                rd,
                rn,
                signed,
                from_bits,
                to_bits,
            } if from_bits == 1 && signed => {
                let dest_size = InstSize::from_bits(to_bits);
                let zr = if dest_size.is32() { "wzr" } else { "xzr" };
                let rd32 = show_ireg_sized(rd.to_reg(), mb_rru, InstSize::Size32);
                let rd = show_ireg_sized(rd.to_reg(), mb_rru, dest_size);
                let rn = show_ireg_sized(rn, mb_rru, InstSize::Size32);
                format!("and {}, {}, #1 ; sub {}, {}, {}", rd32, rn, rd, zr, rd)
            }
            &Inst::Extend {
                rd,
                rn,
                signed,
                from_bits,
                ..
            } if from_bits == 1 && !signed => {
                let rd = show_ireg_sized(rd.to_reg(), mb_rru, InstSize::Size32);
                let rn = show_ireg_sized(rn, mb_rru, InstSize::Size32);
                format!("and {}, {}, #1", rd, rn)
            }
            &Inst::Extend { .. } => {
                panic!("Unsupported Extend case");
            }
            &Inst::Call { dest: _, .. } => format!("bl 0"),
            &Inst::CallInd { rn, .. } => {
                let rn = rn.show_rru(mb_rru);
                format!("blr {}", rn)
            }
            &Inst::Ret => "ret".to_string(),
            &Inst::EpiloguePlaceholder => "epilogue placeholder".to_string(),
            &Inst::Jump { ref dest } => {
                let dest = dest.show_rru(mb_rru);
                format!("b {}", dest)
            }
            &Inst::CondBr {
                ref taken,
                ref not_taken,
                ref kind,
            } => {
                let taken = taken.show_rru(mb_rru);
                let not_taken = not_taken.show_rru(mb_rru);
                match kind {
                    &CondBrKind::Zero(reg) => {
                        let reg = reg.show_rru(mb_rru);
                        format!("cbz {}, {} ; b {}", reg, taken, not_taken)
                    }
                    &CondBrKind::NotZero(reg) => {
                        let reg = reg.show_rru(mb_rru);
                        format!("cbnz {}, {} ; b {}", reg, taken, not_taken)
                    }
                    &CondBrKind::Cond(c) => {
                        let c = c.show_rru(mb_rru);
                        format!("b.{} {} ; b {}", c, taken, not_taken)
                    }
                }
            }
            &Inst::CondBrLowered {
                ref target,
                ref kind,
            } => {
                let target = target.show_rru(mb_rru);
                match &kind {
                    &CondBrKind::Zero(reg) => {
                        let reg = reg.show_rru(mb_rru);
                        format!("cbz {}, {}", reg, target)
                    }
                    &CondBrKind::NotZero(reg) => {
                        let reg = reg.show_rru(mb_rru);
                        format!("cbnz {}, {}", reg, target)
                    }
                    &CondBrKind::Cond(c) => {
                        let c = c.show_rru(mb_rru);
                        format!("b.{} {}", c, target)
                    }
                }
            }
            &Inst::CondBrLoweredCompound {
                ref taken,
                ref not_taken,
                ref kind,
            } => {
                let first = Inst::CondBrLowered {
                    target: taken.clone(),
                    kind: kind.clone(),
                };
                let second = Inst::Jump {
                    dest: not_taken.clone(),
                };
                first.show_rru(mb_rru) + " ; " + &second.show_rru(mb_rru)
            }
            &Inst::IndirectBr { rn, .. } => {
                let rn = rn.show_rru(mb_rru);
                format!("br {}", rn)
            }
            &Inst::Brk => "brk #0".to_string(),
            &Inst::Udf { .. } => "udf".to_string(),
            &Inst::Adr { rd, ref label } => {
                let rd = rd.show_rru(mb_rru);
                let label = label.show_rru(mb_rru);
                format!("adr {}, {}", rd, label)
            }
            &Inst::Word4 { data } => format!("data.i32 {}", data),
            &Inst::Word8 { data } => format!("data.i64 {}", data),
            &Inst::JTSequence {
                ref targets,
                ridx,
                rtmp1,
                rtmp2,
                ..
            } => {
                let ridx = ridx.show_rru(mb_rru);
                let rtmp1 = rtmp1.show_rru(mb_rru);
                let rtmp2 = rtmp2.show_rru(mb_rru);
                format!(
                    concat!(
                        "adr {}, pc+16 ; ",
                        "ldrsw {}, [{}, {}, LSL 2] ; ",
                        "add {}, {}, {} ; ",
                        "br {} ; ",
                        "jt_entries {:?}"
                    ),
                    rtmp1, rtmp2, rtmp1, ridx, rtmp1, rtmp1, rtmp2, rtmp1, targets
                )
            }
            &Inst::LoadConst64 { rd, const_data } => {
                let rd = rd.show_rru(mb_rru);
                format!("ldr {}, 8 ; b 12 ; data {:?}", rd, const_data)
            }
            &Inst::LoadExtName {
                rd,
                ref name,
                offset,
                srcloc: _srcloc,
            } => {
                let rd = rd.show_rru(mb_rru);
                format!("ldr {}, 8 ; b 12 ; data {:?} + {}", rd, name, offset)
            }
            &Inst::LoadAddr { rd, ref mem } => match *mem {
                MemArg::FPOffset(fp_off) => {
                    let alu_op = if fp_off < 0 {
                        ALUOp::Sub64
                    } else {
                        ALUOp::Add64
                    };
                    if let Some(imm12) = Imm12::maybe_from_u64(u64::try_from(fp_off.abs()).unwrap())
                    {
                        let inst = Inst::AluRRImm12 {
                            alu_op,
                            rd,
                            imm12,
                            rn: fp_reg(),
                        };
                        inst.show_rru(mb_rru)
                    } else {
                        let mut res = String::new();
                        let const_insts =
                            Inst::load_constant(rd, u64::try_from(fp_off.abs()).unwrap());
                        for inst in const_insts {
                            res.push_str(&inst.show_rru(mb_rru));
                            res.push_str("; ");
                        }
                        let inst = Inst::AluRRR {
                            alu_op,
                            rd,
                            rn: fp_reg(),
                            rm: rd.to_reg(),
                        };
                        res.push_str(&inst.show_rru(mb_rru));
                        res
                    }
                }
                _ => unimplemented!("{:?}", mem),
            },
            &Inst::GetPinnedReg { rd } => {
                let rd = rd.show_rru(mb_rru);
                format!("get_pinned_reg {}", rd)
            }
            &Inst::SetPinnedReg { rm } => {
                let rm = rm.show_rru(mb_rru);
                format!("set_pinned_reg {}", rm)
            }
        }
    }
}
