/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "jit/mips32/MacroAssembler-mips32.h"

#include "mozilla/DebugOnly.h"
#include "mozilla/MathAlgorithms.h"

#include "jit/Bailouts.h"
#include "jit/BaselineFrame.h"
#include "jit/JitFrames.h"
#include "jit/MacroAssembler.h"
#include "jit/mips32/Simulator-mips32.h"
#include "jit/MoveEmitter.h"
#include "jit/SharedICRegisters.h"

#include "jit/MacroAssembler-inl.h"

using namespace js;
using namespace jit;

using mozilla::Abs;

static const int32_t PAYLOAD_OFFSET = NUNBOX32_PAYLOAD_OFFSET;
static const int32_t TAG_OFFSET = NUNBOX32_TYPE_OFFSET;

static_assert(sizeof(intptr_t) == 4, "Not 64-bit clean.");

void
MacroAssemblerMIPSCompat::convertBoolToInt32(Register src, Register dest)
{
    // Note that C++ bool is only 1 byte, so zero extend it to clear the
    // higher-order bits.
    ma_and(dest, src, Imm32(0xff));
}

void
MacroAssemblerMIPSCompat::convertInt32ToDouble(Register src, FloatRegister dest)
{
    as_mtc1(src, dest);
    as_cvtdw(dest, dest);
}

void
MacroAssemblerMIPSCompat::convertInt32ToDouble(const Address& src, FloatRegister dest)
{
    ma_ls(dest, src);
    as_cvtdw(dest, dest);
}

void
MacroAssemblerMIPSCompat::convertInt32ToDouble(const BaseIndex& src, FloatRegister dest)
{
    computeScaledAddress(src, ScratchRegister);
    convertInt32ToDouble(Address(ScratchRegister, src.offset), dest);
}

void
MacroAssemblerMIPSCompat::convertUInt32ToDouble(Register src, FloatRegister dest)
{
    // We use SecondScratchDoubleReg because MacroAssembler::loadFromTypedArray
    // calls with ScratchDoubleReg as dest.
    MOZ_ASSERT(dest != SecondScratchDoubleReg);

    // Subtract INT32_MIN to get a positive number
    ma_subu(ScratchRegister, src, Imm32(INT32_MIN));

    // Convert value
    as_mtc1(ScratchRegister, dest);
    as_cvtdw(dest, dest);

    // Add unsigned value of INT32_MIN
    ma_lid(SecondScratchDoubleReg, 2147483648.0);
    as_addd(dest, dest, SecondScratchDoubleReg);
}

static const double TO_DOUBLE_HIGH_SCALE = 0x100000000;

bool
MacroAssemblerMIPSCompat::convertUInt64ToDoubleNeedsTemp()
{
    return false;
}

void
MacroAssemblerMIPSCompat::convertUInt64ToDouble(Register64 src, FloatRegister dest, Register temp)
{
    MOZ_ASSERT(temp == Register::Invalid());
    convertUInt32ToDouble(src.high, dest);
    loadConstantDouble(TO_DOUBLE_HIGH_SCALE, ScratchDoubleReg);
    asMasm().mulDouble(ScratchDoubleReg, dest);
    convertUInt32ToDouble(src.low, ScratchDoubleReg);
    asMasm().addDouble(ScratchDoubleReg, dest);
}

void
MacroAssemblerMIPSCompat::convertUInt32ToFloat32(Register src, FloatRegister dest)
{
    Label positive, done;
    ma_b(src, src, &positive, NotSigned, ShortJump);

    // We cannot do the same as convertUInt32ToDouble because float32 doesn't
    // have enough precision.
    convertUInt32ToDouble(src, dest);
    convertDoubleToFloat32(dest, dest);
    ma_b(&done, ShortJump);

    bind(&positive);
    convertInt32ToFloat32(src, dest);

    bind(&done);
}

void
MacroAssemblerMIPSCompat::convertDoubleToFloat32(FloatRegister src, FloatRegister dest)
{
    as_cvtsd(dest, src);
}

// Checks whether a double is representable as a 32-bit integer. If so, the
// integer is written to the output register. Otherwise, a bailout is taken to
// the given snapshot. This function overwrites the scratch float register.
void
MacroAssemblerMIPSCompat::convertDoubleToInt32(FloatRegister src, Register dest,
                                         Label* fail, bool negativeZeroCheck)
{
    if (negativeZeroCheck) {
        moveFromDoubleHi(src, dest);
        moveFromDoubleLo(src, ScratchRegister);
        as_movn(dest, zero, ScratchRegister);
        ma_b(dest, Imm32(INT32_MIN), fail, Assembler::Equal);
    }

    // Convert double to int, then convert back and check if we have the
    // same number.
    as_cvtwd(ScratchDoubleReg, src);
    as_mfc1(dest, ScratchDoubleReg);
    as_cvtdw(ScratchDoubleReg, ScratchDoubleReg);
    ma_bc1d(src, ScratchDoubleReg, fail, Assembler::DoubleNotEqualOrUnordered);
}

// Checks whether a float32 is representable as a 32-bit integer. If so, the
// integer is written to the output register. Otherwise, a bailout is taken to
// the given snapshot. This function overwrites the scratch float register.
void
MacroAssemblerMIPSCompat::convertFloat32ToInt32(FloatRegister src, Register dest,
                                          Label* fail, bool negativeZeroCheck)
{
    if (negativeZeroCheck) {
        moveFromFloat32(src, dest);
        ma_b(dest, Imm32(INT32_MIN), fail, Assembler::Equal);
    }

    // Converting the floating point value to an integer and then converting it
    // back to a float32 would not work, as float to int32 conversions are
    // clamping (e.g. float(INT32_MAX + 1) would get converted into INT32_MAX
    // and then back to float(INT32_MAX + 1)).  If this ever happens, we just
    // bail out.
    as_cvtws(ScratchFloat32Reg, src);
    as_mfc1(dest, ScratchFloat32Reg);
    as_cvtsw(ScratchFloat32Reg, ScratchFloat32Reg);
    ma_bc1s(src, ScratchFloat32Reg, fail, Assembler::DoubleNotEqualOrUnordered);

    // Bail out in the clamped cases.
    ma_b(dest, Imm32(INT32_MAX), fail, Assembler::Equal);
}

void
MacroAssemblerMIPSCompat::convertFloat32ToDouble(FloatRegister src, FloatRegister dest)
{
    as_cvtds(dest, src);
}

void
MacroAssemblerMIPSCompat::convertInt32ToFloat32(Register src, FloatRegister dest)
{
    as_mtc1(src, dest);
    as_cvtsw(dest, dest);
}

void
MacroAssemblerMIPSCompat::convertInt32ToFloat32(const Address& src, FloatRegister dest)
{
    ma_ls(dest, src);
    as_cvtsw(dest, dest);
}

void
MacroAssemblerMIPS::ma_li(Register dest, CodeOffset* label)
{
    BufferOffset bo = m_buffer.nextOffset();
    ma_liPatchable(dest, ImmWord(/* placeholder */ 0));
    label->bind(bo.getOffset());
}

void
MacroAssemblerMIPS::ma_li(Register dest, ImmWord imm)
{
    ma_li(dest, Imm32(uint32_t(imm.value)));
}

// This method generates lui and ori instruction pair that can be modified by
// UpdateLuiOriValue, either during compilation (eg. Assembler::bind), or
// during execution (eg. jit::PatchJump).
void
MacroAssemblerMIPS::ma_liPatchable(Register dest, Imm32 imm)
{
    m_buffer.ensureSpace(2 * sizeof(uint32_t));
    as_lui(dest, Imm16::Upper(imm).encode());
    as_ori(dest, dest, Imm16::Lower(imm).encode());
}

void
MacroAssemblerMIPS::ma_liPatchable(Register dest, ImmPtr imm)
{
    ma_liPatchable(dest, ImmWord(uintptr_t(imm.value)));
}

void
MacroAssemblerMIPS::ma_liPatchable(Register dest, ImmWord imm)
{
    ma_liPatchable(dest, Imm32(int32_t(imm.value)));
}

// Arithmetic-based ops.

// Add.
template <typename L>
void
MacroAssemblerMIPS::ma_addTestOverflow(Register rd, Register rs, Register rt, L overflow)
{
    Label goodAddition;
    as_addu(rd, rs, rt);

    as_xor(ScratchRegister, rs, rt); // If different sign, no overflow
    ma_b(ScratchRegister, Imm32(0), &goodAddition, Assembler::LessThan, ShortJump);

    // If different sign, then overflow
    as_xor(ScratchRegister, rs, rd);
    ma_b(ScratchRegister, Imm32(0), overflow, Assembler::LessThan);

    bind(&goodAddition);
}

template void
MacroAssemblerMIPS::ma_addTestOverflow<Label*>(Register rd, Register rs,
                                               Register rt, Label* overflow);
template void
MacroAssemblerMIPS::ma_addTestOverflow<wasm::TrapDesc>(Register rd, Register rs, Register rt,
                                                       wasm::TrapDesc overflow);

template <typename L>
void
MacroAssemblerMIPS::ma_addTestOverflow(Register rd, Register rs, Imm32 imm, L overflow)
{
    // Check for signed range because of as_addiu
    // Check for unsigned range because of as_xori
    if (Imm16::IsInSignedRange(imm.value) && Imm16::IsInUnsignedRange(imm.value)) {
        Label goodAddition;
        as_addiu(rd, rs, imm.value);

        // If different sign, no overflow
        as_xori(ScratchRegister, rs, imm.value);
        ma_b(ScratchRegister, Imm32(0), &goodAddition, Assembler::LessThan, ShortJump);

        // If different sign, then overflow
        as_xor(ScratchRegister, rs, rd);
        ma_b(ScratchRegister, Imm32(0), overflow, Assembler::LessThan);

        bind(&goodAddition);
    } else {
        ma_li(ScratchRegister, imm);
        ma_addTestOverflow(rd, rs, ScratchRegister, overflow);
    }
}

template void
MacroAssemblerMIPS::ma_addTestOverflow<Label*>(Register rd, Register rs,
                                               Imm32 imm, Label* overflow);
template void
MacroAssemblerMIPS::ma_addTestOverflow<wasm::TrapDesc>(Register rd, Register rs, Imm32 imm,
                                                       wasm::TrapDesc overflow);

// Subtract.
void
MacroAssemblerMIPS::ma_subTestOverflow(Register rd, Register rs, Register rt, Label* overflow)
{
    Label goodSubtraction;
    // Use second scratch. The instructions generated by ma_b don't use the
    // second scratch register.
    as_subu(rd, rs, rt);

    as_xor(ScratchRegister, rs, rt); // If same sign, no overflow
    ma_b(ScratchRegister, Imm32(0), &goodSubtraction, Assembler::GreaterThanOrEqual, ShortJump);

    // If different sign, then overflow
    as_xor(ScratchRegister, rs, rd);
    ma_b(ScratchRegister, Imm32(0), overflow, Assembler::LessThan);

    bind(&goodSubtraction);
}

// Memory.

void
MacroAssemblerMIPS::ma_load(Register dest, Address address,
                            LoadStoreSize size, LoadStoreExtension extension)
{
    int16_t encodedOffset;
    Register base;

    if (isLoongson() && ZeroExtend != extension &&
        !Imm16::IsInSignedRange(address.offset))
    {
        ma_li(ScratchRegister, Imm32(address.offset));
        base = address.base;

        switch (size) {
          case SizeByte:
            as_gslbx(dest, base, ScratchRegister, 0);
            break;
          case SizeHalfWord:
            as_gslhx(dest, base, ScratchRegister, 0);
            break;
          case SizeWord:
            as_gslwx(dest, base, ScratchRegister, 0);
            break;
          case SizeDouble:
            as_gsldx(dest, base, ScratchRegister, 0);
            break;
          default:
            MOZ_CRASH("Invalid argument for ma_load");
        }
        return;
    }

    if (!Imm16::IsInSignedRange(address.offset)) {
        ma_li(ScratchRegister, Imm32(address.offset));
        as_addu(ScratchRegister, address.base, ScratchRegister);
        base = ScratchRegister;
        encodedOffset = Imm16(0).encode();
    } else {
        encodedOffset = Imm16(address.offset).encode();
        base = address.base;
    }

    switch (size) {
      case SizeByte:
        if (ZeroExtend == extension)
            as_lbu(dest, base, encodedOffset);
        else
            as_lb(dest, base, encodedOffset);
        break;
      case SizeHalfWord:
        if (ZeroExtend == extension)
            as_lhu(dest, base, encodedOffset);
        else
            as_lh(dest, base, encodedOffset);
        break;
      case SizeWord:
        as_lw(dest, base, encodedOffset);
        break;
      default:
        MOZ_CRASH("Invalid argument for ma_load");
    }
}

void
MacroAssemblerMIPS::ma_store(Register data, Address address, LoadStoreSize size,
                             LoadStoreExtension extension)
{
    int16_t encodedOffset;
    Register base;

    if (isLoongson() && !Imm16::IsInSignedRange(address.offset)) {
        ma_li(ScratchRegister, Imm32(address.offset));
        base = address.base;

        switch (size) {
          case SizeByte:
            as_gssbx(data, base, ScratchRegister, 0);
            break;
          case SizeHalfWord:
            as_gsshx(data, base, ScratchRegister, 0);
            break;
          case SizeWord:
            as_gsswx(data, base, ScratchRegister, 0);
            break;
          case SizeDouble:
            as_gssdx(data, base, ScratchRegister, 0);
            break;
          default:
            MOZ_CRASH("Invalid argument for ma_store");
        }
        return;
    }

    if (!Imm16::IsInSignedRange(address.offset)) {
        ma_li(ScratchRegister, Imm32(address.offset));
        as_addu(ScratchRegister, address.base, ScratchRegister);
        base = ScratchRegister;
        encodedOffset = Imm16(0).encode();
    } else {
        encodedOffset = Imm16(address.offset).encode();
        base = address.base;
    }

    switch (size) {
      case SizeByte:
        as_sb(data, base, encodedOffset);
        break;
      case SizeHalfWord:
        as_sh(data, base, encodedOffset);
        break;
      case SizeWord:
        as_sw(data, base, encodedOffset);
        break;
      default:
        MOZ_CRASH("Invalid argument for ma_store");
    }
}

void
MacroAssemblerMIPSCompat::computeScaledAddress(const BaseIndex& address, Register dest)
{
    int32_t shift = Imm32::ShiftOf(address.scale).value;
    if (shift) {
        ma_sll(ScratchRegister, address.index, Imm32(shift));
        as_addu(dest, address.base, ScratchRegister);
    } else {
        as_addu(dest, address.base, address.index);
    }
}

// Shortcut for when we know we're transferring 32 bits of data.
void
MacroAssemblerMIPS::ma_lw(Register data, Address address)
{
    ma_load(data, address, SizeWord);
}

void
MacroAssemblerMIPS::ma_sw(Register data, Address address)
{
    ma_store(data, address, SizeWord);
}

void
MacroAssemblerMIPS::ma_sw(Imm32 imm, Address address)
{
    MOZ_ASSERT(address.base != ScratchRegister);
    ma_li(ScratchRegister, imm);

    if (Imm16::IsInSignedRange(address.offset)) {
        as_sw(ScratchRegister, address.base, address.offset);
    } else {
        MOZ_ASSERT(address.base != SecondScratchReg);

        ma_li(SecondScratchReg, Imm32(address.offset));
        as_addu(SecondScratchReg, address.base, SecondScratchReg);
        as_sw(ScratchRegister, SecondScratchReg, 0);
    }
}

void
MacroAssemblerMIPS::ma_sw(Register data, BaseIndex& address)
{
    ma_store(data, address, SizeWord);
}

void
MacroAssemblerMIPS::ma_pop(Register r)
{
    as_lw(r, StackPointer, 0);
    as_addiu(StackPointer, StackPointer, sizeof(intptr_t));
}

void
MacroAssemblerMIPS::ma_push(Register r)
{
    if (r == sp) {
        // Pushing sp requires one more instruction.
        ma_move(ScratchRegister, sp);
        r = ScratchRegister;
    }

    as_addiu(StackPointer, StackPointer, -sizeof(intptr_t));
    as_sw(r, StackPointer, 0);
}

// Branches when done from within mips-specific code.
void
MacroAssemblerMIPS::ma_b(Register lhs, Address addr, Label* label, Condition c, JumpKind jumpKind)
{
    MOZ_ASSERT(lhs != ScratchRegister);
    ma_lw(ScratchRegister, addr);
    ma_b(lhs, ScratchRegister, label, c, jumpKind);
}

void
MacroAssemblerMIPS::ma_b(Address addr, Imm32 imm, Label* label, Condition c, JumpKind jumpKind)
{
    ma_lw(SecondScratchReg, addr);
    ma_b(SecondScratchReg, imm, label, c, jumpKind);
}

void
MacroAssemblerMIPS::ma_b(Address addr, ImmGCPtr imm, Label* label, Condition c, JumpKind jumpKind)
{
    ma_lw(SecondScratchReg, addr);
    ma_b(SecondScratchReg, imm, label, c, jumpKind);
}

void
MacroAssemblerMIPS::ma_bal(Label* label, DelaySlotFill delaySlotFill)
{
    if (label->bound()) {
        // Generate the long jump for calls because return address has to be
        // the address after the reserved block.
        addLongJump(nextOffset());
        ma_liPatchable(ScratchRegister, Imm32(label->offset()));
        as_jalr(ScratchRegister);
        if (delaySlotFill == FillDelaySlot)
            as_nop();
        return;
    }

    // Second word holds a pointer to the next branch in label's chain.
    uint32_t nextInChain = label->used() ? label->offset() : LabelBase::INVALID_OFFSET;

    // Make the whole branch continous in the buffer.
    m_buffer.ensureSpace(4 * sizeof(uint32_t));

    BufferOffset bo = writeInst(getBranchCode(BranchIsCall).encode());
    writeInst(nextInChain);
    if (!oom())
        label->use(bo.getOffset());
    // Leave space for long jump.
    as_nop();
    if (delaySlotFill == FillDelaySlot)
        as_nop();
}

void
MacroAssemblerMIPS::branchWithCode(InstImm code, Label* label, JumpKind jumpKind)
{
    MOZ_ASSERT(code.encode() != InstImm(op_regimm, zero, rt_bgezal, BOffImm16(0)).encode());
    InstImm inst_beq = InstImm(op_beq, zero, zero, BOffImm16(0));

    if (label->bound()) {
        int32_t offset = label->offset() - m_buffer.nextOffset().getOffset();

        if (BOffImm16::IsInRange(offset))
            jumpKind = ShortJump;

        if (jumpKind == ShortJump) {
            MOZ_ASSERT(BOffImm16::IsInRange(offset));
            code.setBOffImm16(BOffImm16(offset));
            writeInst(code.encode());
            as_nop();
            return;
        }

        if (code.encode() == inst_beq.encode()) {
            // Handle long jump
            addLongJump(nextOffset());
            ma_liPatchable(ScratchRegister, Imm32(label->offset()));
            as_jr(ScratchRegister);
            as_nop();
            return;
        }

        // Handle long conditional branch
        writeInst(invertBranch(code, BOffImm16(5 * sizeof(uint32_t))).encode());
        // No need for a "nop" here because we can clobber scratch.
        addLongJump(nextOffset());
        ma_liPatchable(ScratchRegister, Imm32(label->offset()));
        as_jr(ScratchRegister);
        as_nop();
        return;
    }

    // Generate open jump and link it to a label.

    // Second word holds a pointer to the next branch in label's chain.
    uint32_t nextInChain = label->used() ? label->offset() : LabelBase::INVALID_OFFSET;

    if (jumpKind == ShortJump) {
        // Make the whole branch continous in the buffer.
        m_buffer.ensureSpace(2 * sizeof(uint32_t));

        // Indicate that this is short jump with offset 4.
        code.setBOffImm16(BOffImm16(4));
        BufferOffset bo = writeInst(code.encode());
        writeInst(nextInChain);
        if (!oom())
            label->use(bo.getOffset());
        return;
    }

    bool conditional = code.encode() != inst_beq.encode();

    // Make the whole branch continous in the buffer.
    m_buffer.ensureSpace((conditional ? 5 : 4) * sizeof(uint32_t));

    BufferOffset bo = writeInst(code.encode());
    writeInst(nextInChain);
    if (!oom())
        label->use(bo.getOffset());
    // Leave space for potential long jump.
    as_nop();
    as_nop();
    if (conditional)
        as_nop();
}

void
MacroAssemblerMIPS::ma_cmp_set(Register rd, Register rs, Address addr, Condition c)
{
    ma_lw(ScratchRegister, addr);
    ma_cmp_set(rd, rs, ScratchRegister, c);
}

void
MacroAssemblerMIPS::ma_cmp_set(Register dst, Address lhs, Register rhs, Condition c)
{
    ma_lw(ScratchRegister, lhs);
    ma_cmp_set(dst, ScratchRegister, rhs, c);
}

// fp instructions
void
MacroAssemblerMIPS::ma_lid(FloatRegister dest, double value)
{
    struct DoubleStruct {
        uint32_t lo;
        uint32_t hi;
    } ;
    DoubleStruct intStruct = mozilla::BitwiseCast<DoubleStruct>(value);

    // put hi part of 64 bit value into the odd register
    if (intStruct.hi == 0) {
        moveToDoubleHi(zero, dest);
    } else {
        ma_li(ScratchRegister, Imm32(intStruct.hi));
        moveToDoubleHi(ScratchRegister, dest);
    }

    // put low part of 64 bit value into the even register
    if (intStruct.lo == 0) {
        moveToDoubleLo(zero, dest);
    } else {
        ma_li(ScratchRegister, Imm32(intStruct.lo));
        moveToDoubleLo(ScratchRegister, dest);
    }
}

void
MacroAssemblerMIPS::ma_mv(FloatRegister src, ValueOperand dest)
{
    moveFromDoubleLo(src, dest.payloadReg());
    moveFromDoubleHi(src, dest.typeReg());
}

void
MacroAssemblerMIPS::ma_mv(ValueOperand src, FloatRegister dest)
{
    moveToDoubleLo(src.payloadReg(), dest);
    moveToDoubleHi(src.typeReg(), dest);
}

void
MacroAssemblerMIPS::ma_ls(FloatRegister ft, Address address)
{
    if (Imm16::IsInSignedRange(address.offset)) {
        as_ls(ft, address.base, address.offset);
    } else {
        MOZ_ASSERT(address.base != ScratchRegister);
        ma_li(ScratchRegister, Imm32(address.offset));
        if (isLoongson()) {
            as_gslsx(ft, address.base, ScratchRegister, 0);
        } else {
            as_addu(ScratchRegister, address.base, ScratchRegister);
            as_ls(ft, ScratchRegister, 0);
        }
    }
}

void
MacroAssemblerMIPS::ma_ld(FloatRegister ft, Address address)
{
    // Use single precision load instructions so we don't have to worry about
    // alignment.

    int32_t off2 = address.offset + TAG_OFFSET;
    if (Imm16::IsInSignedRange(address.offset) && Imm16::IsInSignedRange(off2)) {
        as_ls(ft, address.base, address.offset);
        as_ls(getOddPair(ft), address.base, off2);
    } else {
        MOZ_ASSERT(address.base != ScratchRegister);
        ma_li(ScratchRegister, Imm32(address.offset));
        as_addu(ScratchRegister, address.base, ScratchRegister);
        as_ls(ft, ScratchRegister, PAYLOAD_OFFSET);
        as_ls(getOddPair(ft), ScratchRegister, TAG_OFFSET);
    }
}

void
MacroAssemblerMIPS::ma_sd(FloatRegister ft, Address address)
{
    int32_t off2 = address.offset + TAG_OFFSET;
    if (Imm16::IsInSignedRange(address.offset) && Imm16::IsInSignedRange(off2)) {
        as_ss(ft, address.base, address.offset);
        as_ss(getOddPair(ft), address.base, off2);
    } else {
        MOZ_ASSERT(address.base != ScratchRegister);
        ma_li(ScratchRegister, Imm32(address.offset));
        as_addu(ScratchRegister, address.base, ScratchRegister);
        as_ss(ft, ScratchRegister, PAYLOAD_OFFSET);
        as_ss(getOddPair(ft), ScratchRegister, TAG_OFFSET);
    }
}

void
MacroAssemblerMIPS::ma_ss(FloatRegister ft, Address address)
{
    if (Imm16::IsInSignedRange(address.offset)) {
        as_ss(ft, address.base, address.offset);
    } else {
        MOZ_ASSERT(address.base != ScratchRegister);
        ma_li(ScratchRegister, Imm32(address.offset));
        if (isLoongson()) {
            as_gsssx(ft, address.base, ScratchRegister, 0);
        } else {
            as_addu(ScratchRegister, address.base, ScratchRegister);
            as_ss(ft, ScratchRegister, 0);
        }
    }
}

void
MacroAssemblerMIPS::ma_pop(FloatRegister fs)
{
    ma_ld(fs.doubleOverlay(0), Address(StackPointer, 0));
    as_addiu(StackPointer, StackPointer, sizeof(double));
}

void
MacroAssemblerMIPS::ma_push(FloatRegister fs)
{
    as_addiu(StackPointer, StackPointer, -sizeof(double));
    ma_sd(fs.doubleOverlay(0), Address(StackPointer, 0));
}

bool
MacroAssemblerMIPSCompat::buildOOLFakeExitFrame(void* fakeReturnAddr)
{
    uint32_t descriptor = MakeFrameDescriptor(asMasm().framePushed(), JitFrame_IonJS,
                                              ExitFrameLayout::Size());

    asMasm().Push(Imm32(descriptor)); // descriptor_
    asMasm().Push(ImmPtr(fakeReturnAddr));

    return true;
}

void
MacroAssemblerMIPSCompat::move32(Imm32 imm, Register dest)
{
    ma_li(dest, imm);
}

void
MacroAssemblerMIPSCompat::move32(Register src, Register dest)
{
    ma_move(dest, src);
}

void
MacroAssemblerMIPSCompat::movePtr(Register src, Register dest)
{
    ma_move(dest, src);
}
void
MacroAssemblerMIPSCompat::movePtr(ImmWord imm, Register dest)
{
    ma_li(dest, imm);
}

void
MacroAssemblerMIPSCompat::movePtr(ImmGCPtr imm, Register dest)
{
    ma_li(dest, imm);
}

void
MacroAssemblerMIPSCompat::movePtr(ImmPtr imm, Register dest)
{
    movePtr(ImmWord(uintptr_t(imm.value)), dest);
}
void
MacroAssemblerMIPSCompat::movePtr(wasm::SymbolicAddress imm, Register dest)
{
    append(wasm::SymbolicAccess(CodeOffset(nextOffset().getOffset()), imm));
    ma_liPatchable(dest, ImmWord(-1));
}

void
MacroAssemblerMIPSCompat::load8ZeroExtend(const Address& address, Register dest)
{
    ma_load(dest, address, SizeByte, ZeroExtend);
}

void
MacroAssemblerMIPSCompat::load8ZeroExtend(const BaseIndex& src, Register dest)
{
    ma_load(dest, src, SizeByte, ZeroExtend);
}

void
MacroAssemblerMIPSCompat::load8SignExtend(const Address& address, Register dest)
{
    ma_load(dest, address, SizeByte, SignExtend);
}

void
MacroAssemblerMIPSCompat::load8SignExtend(const BaseIndex& src, Register dest)
{
    ma_load(dest, src, SizeByte, SignExtend);
}

void
MacroAssemblerMIPSCompat::load16ZeroExtend(const Address& address, Register dest)
{
    ma_load(dest, address, SizeHalfWord, ZeroExtend);
}

void
MacroAssemblerMIPSCompat::load16ZeroExtend(const BaseIndex& src, Register dest)
{
    ma_load(dest, src, SizeHalfWord, ZeroExtend);
}

void
MacroAssemblerMIPSCompat::load16SignExtend(const Address& address, Register dest)
{
    ma_load(dest, address, SizeHalfWord, SignExtend);
}

void
MacroAssemblerMIPSCompat::load16SignExtend(const BaseIndex& src, Register dest)
{
    ma_load(dest, src, SizeHalfWord, SignExtend);
}

void
MacroAssemblerMIPSCompat::load32(const Address& address, Register dest)
{
    ma_load(dest, address, SizeWord);
}

void
MacroAssemblerMIPSCompat::load32(const BaseIndex& address, Register dest)
{
    ma_load(dest, address, SizeWord);
}

void
MacroAssemblerMIPSCompat::load32(AbsoluteAddress address, Register dest)
{
    movePtr(ImmPtr(address.addr), ScratchRegister);
    load32(Address(ScratchRegister, 0), dest);
}

void
MacroAssemblerMIPSCompat::load32(wasm::SymbolicAddress address, Register dest)
{
    movePtr(address, ScratchRegister);
    load32(Address(ScratchRegister, 0), dest);
}

void
MacroAssemblerMIPSCompat::loadPtr(const Address& address, Register dest)
{
    ma_load(dest, address, SizeWord);
}

void
MacroAssemblerMIPSCompat::loadPtr(const BaseIndex& src, Register dest)
{
    ma_load(dest, src, SizeWord);
}

void
MacroAssemblerMIPSCompat::loadPtr(AbsoluteAddress address, Register dest)
{
    movePtr(ImmPtr(address.addr), ScratchRegister);
    loadPtr(Address(ScratchRegister, 0), dest);
}

void
MacroAssemblerMIPSCompat::loadPtr(wasm::SymbolicAddress address, Register dest)
{
    movePtr(address, ScratchRegister);
    loadPtr(Address(ScratchRegister, 0), dest);
}

void
MacroAssemblerMIPSCompat::loadPrivate(const Address& address, Register dest)
{
    ma_lw(dest, Address(address.base, address.offset + PAYLOAD_OFFSET));
}

void
MacroAssemblerMIPSCompat::loadDouble(const Address& address, FloatRegister dest)
{
    ma_ld(dest, address);
}

void
MacroAssemblerMIPSCompat::loadDouble(const BaseIndex& src, FloatRegister dest)
{
    computeScaledAddress(src, SecondScratchReg);
    ma_ld(dest, Address(SecondScratchReg, src.offset));
}

void
MacroAssemblerMIPSCompat::loadUnalignedDouble(const BaseIndex& src, Register temp,
                                              FloatRegister dest)
{
    computeScaledAddress(src, SecondScratchReg);

    if (Imm16::IsInSignedRange(src.offset) && Imm16::IsInSignedRange(src.offset + 7)) {
        as_lwl(temp, SecondScratchReg, src.offset + INT64LOW_OFFSET + 3);
        as_lwr(temp, SecondScratchReg, src.offset + INT64LOW_OFFSET);
        moveToDoubleLo(temp, dest);
        as_lwl(temp, SecondScratchReg, src.offset + INT64HIGH_OFFSET + 3);
        as_lwr(temp, SecondScratchReg, src.offset + INT64HIGH_OFFSET);
        moveToDoubleHi(temp, dest);
    } else {
        ma_li(ScratchRegister, Imm32(src.offset));
        as_daddu(ScratchRegister, SecondScratchReg, ScratchRegister);
        as_lwl(temp, ScratchRegister, INT64LOW_OFFSET + 3);
        as_lwr(temp, ScratchRegister, INT64LOW_OFFSET);
        moveToDoubleLo(temp, dest);
        as_lwl(temp, ScratchRegister, INT64HIGH_OFFSET + 3);
        as_lwr(temp, ScratchRegister, INT64HIGH_OFFSET);
        moveToDoubleHi(temp, dest);
    }
}

void
MacroAssemblerMIPSCompat::loadFloatAsDouble(const Address& address, FloatRegister dest)
{
    ma_ls(dest, address);
    as_cvtds(dest, dest);
}

void
MacroAssemblerMIPSCompat::loadFloatAsDouble(const BaseIndex& src, FloatRegister dest)
{
    loadFloat32(src, dest);
    as_cvtds(dest, dest);
}

void
MacroAssemblerMIPSCompat::loadFloat32(const Address& address, FloatRegister dest)
{
    ma_ls(dest, address);
}

void
MacroAssemblerMIPSCompat::loadFloat32(const BaseIndex& src, FloatRegister dest)
{
    computeScaledAddress(src, SecondScratchReg);
    ma_ls(dest, Address(SecondScratchReg, src.offset));
}

void
MacroAssemblerMIPSCompat::loadUnalignedFloat32(const BaseIndex& src, Register temp,
                                               FloatRegister dest)
{
    computeScaledAddress(src, SecondScratchReg);

    if (Imm16::IsInSignedRange(src.offset) && Imm16::IsInSignedRange(src.offset + 3)) {
        as_lwl(temp, SecondScratchReg, src.offset + 3);
        as_lwr(temp, SecondScratchReg, src.offset);
    } else {
        ma_li(ScratchRegister, Imm32(src.offset));
        as_daddu(ScratchRegister, SecondScratchReg, ScratchRegister);
        as_lwl(temp, ScratchRegister, 3);
        as_lwr(temp, ScratchRegister, 0);
    }

    moveToFloat32(temp, dest);
}

void
MacroAssemblerMIPSCompat::store8(Imm32 imm, const Address& address)
{
    ma_li(SecondScratchReg, imm);
    ma_store(SecondScratchReg, address, SizeByte);
}

void
MacroAssemblerMIPSCompat::store8(Register src, const Address& address)
{
    ma_store(src, address, SizeByte);
}

void
MacroAssemblerMIPSCompat::store8(Imm32 imm, const BaseIndex& dest)
{
    ma_store(imm, dest, SizeByte);
}

void
MacroAssemblerMIPSCompat::store8(Register src, const BaseIndex& dest)
{
    ma_store(src, dest, SizeByte);
}

void
MacroAssemblerMIPSCompat::store16(Imm32 imm, const Address& address)
{
    ma_li(SecondScratchReg, imm);
    ma_store(SecondScratchReg, address, SizeHalfWord);
}

void
MacroAssemblerMIPSCompat::store16(Register src, const Address& address)
{
    ma_store(src, address, SizeHalfWord);
}

void
MacroAssemblerMIPSCompat::store16(Imm32 imm, const BaseIndex& dest)
{
    ma_store(imm, dest, SizeHalfWord);
}

void
MacroAssemblerMIPSCompat::store16(Register src, const BaseIndex& address)
{
    ma_store(src, address, SizeHalfWord);
}

void
MacroAssemblerMIPSCompat::store32(Register src, AbsoluteAddress address)
{
    movePtr(ImmPtr(address.addr), ScratchRegister);
    store32(src, Address(ScratchRegister, 0));
}

void
MacroAssemblerMIPSCompat::store32(Register src, const Address& address)
{
    ma_store(src, address, SizeWord);
}

void
MacroAssemblerMIPSCompat::store32(Imm32 src, const Address& address)
{
    move32(src, SecondScratchReg);
    ma_store(SecondScratchReg, address, SizeWord);
}

void
MacroAssemblerMIPSCompat::store32(Imm32 imm, const BaseIndex& dest)
{
    ma_store(imm, dest, SizeWord);
}

void
MacroAssemblerMIPSCompat::store32(Register src, const BaseIndex& dest)
{
    ma_store(src, dest, SizeWord);
}

template <typename T>
void
MacroAssemblerMIPSCompat::storePtr(ImmWord imm, T address)
{
    ma_li(SecondScratchReg, imm);
    ma_store(SecondScratchReg, address, SizeWord);
}

template void MacroAssemblerMIPSCompat::storePtr<Address>(ImmWord imm, Address address);
template void MacroAssemblerMIPSCompat::storePtr<BaseIndex>(ImmWord imm, BaseIndex address);

template <typename T>
void
MacroAssemblerMIPSCompat::storePtr(ImmPtr imm, T address)
{
    storePtr(ImmWord(uintptr_t(imm.value)), address);
}

template void MacroAssemblerMIPSCompat::storePtr<Address>(ImmPtr imm, Address address);
template void MacroAssemblerMIPSCompat::storePtr<BaseIndex>(ImmPtr imm, BaseIndex address);

template <typename T>
void
MacroAssemblerMIPSCompat::storePtr(ImmGCPtr imm, T address)
{
    movePtr(imm, SecondScratchReg);
    storePtr(SecondScratchReg, address);
}

template void MacroAssemblerMIPSCompat::storePtr<Address>(ImmGCPtr imm, Address address);
template void MacroAssemblerMIPSCompat::storePtr<BaseIndex>(ImmGCPtr imm, BaseIndex address);

void
MacroAssemblerMIPSCompat::storePtr(Register src, const Address& address)
{
    ma_store(src, address, SizeWord);
}

void
MacroAssemblerMIPSCompat::storePtr(Register src, const BaseIndex& address)
{
    ma_store(src, address, SizeWord);
}

void
MacroAssemblerMIPSCompat::storePtr(Register src, AbsoluteAddress dest)
{
    movePtr(ImmPtr(dest.addr), ScratchRegister);
    storePtr(src, Address(ScratchRegister, 0));
}

void
MacroAssemblerMIPSCompat::storeUnalignedFloat32(FloatRegister src, Register temp,
                                                const BaseIndex& dest)
{
    computeScaledAddress(dest, SecondScratchReg);
    moveFromFloat32(src, temp);

    if (Imm16::IsInSignedRange(dest.offset) && Imm16::IsInSignedRange(dest.offset + 3)) {
        as_swl(temp, SecondScratchReg, dest.offset + 3);
        as_swr(temp, SecondScratchReg, dest.offset);
    } else {
        ma_li(ScratchRegister, Imm32(dest.offset));
        as_daddu(ScratchRegister, SecondScratchReg, ScratchRegister);
        as_swl(temp, ScratchRegister, 3);
        as_swr(temp, ScratchRegister, 0);
    }
}

void
MacroAssemblerMIPSCompat::storeUnalignedDouble(FloatRegister src, Register temp,
                                               const BaseIndex& dest)
{
    computeScaledAddress(dest, SecondScratchReg);

    if (Imm16::IsInSignedRange(dest.offset) && Imm16::IsInSignedRange(dest.offset + 7)) {
        moveFromDoubleLo(src, temp);
        as_swl(temp, SecondScratchReg, dest.offset + INT64LOW_OFFSET + 3);
        as_swr(temp, SecondScratchReg, dest.offset + INT64LOW_OFFSET);
        moveFromDoubleHi(src, temp);
        as_swl(temp, SecondScratchReg, dest.offset + INT64HIGH_OFFSET + 3);
        as_swr(temp, SecondScratchReg, dest.offset + INT64HIGH_OFFSET);
    } else {
        ma_li(ScratchRegister, Imm32(dest.offset));
        as_daddu(ScratchRegister, SecondScratchReg, ScratchRegister);
        moveFromDoubleLo(src, temp);
        as_swl(temp, ScratchRegister, INT64LOW_OFFSET + 3);
        as_swr(temp, ScratchRegister, INT64LOW_OFFSET);
        moveFromDoubleHi(src, temp);
        as_swl(temp, ScratchRegister, INT64HIGH_OFFSET + 3);
        as_swr(temp, ScratchRegister, INT64HIGH_OFFSET);
    }
}

// Note: this function clobbers the input register.
void
MacroAssembler::clampDoubleToUint8(FloatRegister input, Register output)
{
    MOZ_ASSERT(input != ScratchDoubleReg);
    Label positive, done;

    // <= 0 or NaN --> 0
    zeroDouble(ScratchDoubleReg);
    branchDouble(DoubleGreaterThan, input, ScratchDoubleReg, &positive);
    {
        move32(Imm32(0), output);
        jump(&done);
    }

    bind(&positive);

    // Add 0.5 and truncate.
    loadConstantDouble(0.5, ScratchDoubleReg);
    addDouble(ScratchDoubleReg, input);

    Label outOfRange;

    branchTruncateDoubleMaybeModUint32(input, output, &outOfRange);
    asMasm().branch32(Assembler::Above, output, Imm32(255), &outOfRange);
    {
        // Check if we had a tie.
        convertInt32ToDouble(output, ScratchDoubleReg);
        branchDouble(DoubleNotEqual, input, ScratchDoubleReg, &done);

        // It was a tie. Mask out the ones bit to get an even value.
        // See also js_TypedArray_uint8_clamp_double.
        and32(Imm32(~1), output);
        jump(&done);
    }

    // > 255 --> 255
    bind(&outOfRange);
    {
        move32(Imm32(255), output);
    }

    bind(&done);
}

// higher level tag testing code
Operand
MacroAssemblerMIPSCompat::ToPayload(Operand base)
{
    return Operand(Register::FromCode(base.base()), base.disp() + PAYLOAD_OFFSET);
}

Operand
MacroAssemblerMIPSCompat::ToType(Operand base)
{
    return Operand(Register::FromCode(base.base()), base.disp() + TAG_OFFSET);
}

void
MacroAssemblerMIPSCompat::testNullSet(Condition cond, const ValueOperand& value, Register dest)
{
    MOZ_ASSERT(cond == Equal || cond == NotEqual);
    ma_cmp_set(dest, value.typeReg(), ImmType(JSVAL_TYPE_NULL), cond);
}

void
MacroAssemblerMIPSCompat::testObjectSet(Condition cond, const ValueOperand& value, Register dest)
{
    MOZ_ASSERT(cond == Equal || cond == NotEqual);
    ma_cmp_set(dest, value.typeReg(), ImmType(JSVAL_TYPE_OBJECT), cond);
}

void
MacroAssemblerMIPSCompat::testUndefinedSet(Condition cond, const ValueOperand& value, Register dest)
{
    MOZ_ASSERT(cond == Equal || cond == NotEqual);
    ma_cmp_set(dest, value.typeReg(), ImmType(JSVAL_TYPE_UNDEFINED), cond);
}

// unboxing code
void
MacroAssemblerMIPSCompat::unboxNonDouble(const ValueOperand& operand, Register dest)
{
    if (operand.payloadReg() != dest)
        ma_move(dest, operand.payloadReg());
}

void
MacroAssemblerMIPSCompat::unboxNonDouble(const Address& src, Register dest)
{
    ma_lw(dest, Address(src.base, src.offset + PAYLOAD_OFFSET));
}

void
MacroAssemblerMIPSCompat::unboxNonDouble(const BaseIndex& src, Register dest)
{
    computeScaledAddress(src, SecondScratchReg);
    ma_lw(dest, Address(SecondScratchReg, src.offset + PAYLOAD_OFFSET));
}

void
MacroAssemblerMIPSCompat::unboxInt32(const ValueOperand& operand, Register dest)
{
    ma_move(dest, operand.payloadReg());
}

void
MacroAssemblerMIPSCompat::unboxInt32(const Address& src, Register dest)
{
    ma_lw(dest, Address(src.base, src.offset + PAYLOAD_OFFSET));
}

void
MacroAssemblerMIPSCompat::unboxBoolean(const ValueOperand& operand, Register dest)
{
    ma_move(dest, operand.payloadReg());
}

void
MacroAssemblerMIPSCompat::unboxBoolean(const Address& src, Register dest)
{
    ma_lw(dest, Address(src.base, src.offset + PAYLOAD_OFFSET));
}

void
MacroAssemblerMIPSCompat::unboxDouble(const ValueOperand& operand, FloatRegister dest)
{
    moveToDoubleLo(operand.payloadReg(), dest);
    moveToDoubleHi(operand.typeReg(), dest);
}

void
MacroAssemblerMIPSCompat::unboxDouble(const Address& src, FloatRegister dest)
{
    ma_lw(ScratchRegister, Address(src.base, src.offset + PAYLOAD_OFFSET));
    moveToDoubleLo(ScratchRegister, dest);
    ma_lw(ScratchRegister, Address(src.base, src.offset + TAG_OFFSET));
    moveToDoubleHi(ScratchRegister, dest);
}

void
MacroAssemblerMIPSCompat::unboxString(const ValueOperand& operand, Register dest)
{
    ma_move(dest, operand.payloadReg());
}

void
MacroAssemblerMIPSCompat::unboxString(const Address& src, Register dest)
{
    ma_lw(dest, Address(src.base, src.offset + PAYLOAD_OFFSET));
}

void
MacroAssemblerMIPSCompat::unboxObject(const ValueOperand& src, Register dest)
{
    ma_move(dest, src.payloadReg());
}

void
MacroAssemblerMIPSCompat::unboxObject(const Address& src, Register dest)
{
    ma_lw(dest, Address(src.base, src.offset + PAYLOAD_OFFSET));
}

void
MacroAssemblerMIPSCompat::unboxValue(const ValueOperand& src, AnyRegister dest)
{
    if (dest.isFloat()) {
        Label notInt32, end;
        asMasm().branchTestInt32(Assembler::NotEqual, src, &notInt32);
        convertInt32ToDouble(src.payloadReg(), dest.fpu());
        ma_b(&end, ShortJump);
        bind(&notInt32);
        unboxDouble(src, dest.fpu());
        bind(&end);
    } else if (src.payloadReg() != dest.gpr()) {
        ma_move(dest.gpr(), src.payloadReg());
    }
}

void
MacroAssemblerMIPSCompat::unboxPrivate(const ValueOperand& src, Register dest)
{
    ma_move(dest, src.payloadReg());
}

void
MacroAssemblerMIPSCompat::boxDouble(FloatRegister src, const ValueOperand& dest)
{
    moveFromDoubleLo(src, dest.payloadReg());
    moveFromDoubleHi(src, dest.typeReg());
}

void
MacroAssemblerMIPSCompat::boxNonDouble(JSValueType type, Register src,
                                       const ValueOperand& dest)
{
    if (src != dest.payloadReg())
        ma_move(dest.payloadReg(), src);
    ma_li(dest.typeReg(), ImmType(type));
}

void
MacroAssemblerMIPSCompat::boolValueToDouble(const ValueOperand& operand, FloatRegister dest)
{
    convertBoolToInt32(operand.payloadReg(), ScratchRegister);
    convertInt32ToDouble(ScratchRegister, dest);
}

void
MacroAssemblerMIPSCompat::int32ValueToDouble(const ValueOperand& operand,
                                             FloatRegister dest)
{
    convertInt32ToDouble(operand.payloadReg(), dest);
}

void
MacroAssemblerMIPSCompat::boolValueToFloat32(const ValueOperand& operand,
                                             FloatRegister dest)
{

    convertBoolToInt32(operand.payloadReg(), ScratchRegister);
    convertInt32ToFloat32(ScratchRegister, dest);
}

void
MacroAssemblerMIPSCompat::int32ValueToFloat32(const ValueOperand& operand,
                                              FloatRegister dest)
{
    convertInt32ToFloat32(operand.payloadReg(), dest);
}

void
MacroAssemblerMIPSCompat::loadConstantFloat32(float f, FloatRegister dest)
{
    ma_lis(dest, f);
}

void
MacroAssemblerMIPSCompat::loadConstantFloat32(wasm::RawF32 f, FloatRegister dest)
{
    ma_lis(dest, f);
}

void
MacroAssemblerMIPSCompat::loadInt32OrDouble(const Address& src, FloatRegister dest)
{
    Label notInt32, end;
    // If it's an int, convert it to double.
    ma_lw(SecondScratchReg, Address(src.base, src.offset + TAG_OFFSET));
    asMasm().branchTestInt32(Assembler::NotEqual, SecondScratchReg, &notInt32);
    ma_lw(SecondScratchReg, Address(src.base, src.offset + PAYLOAD_OFFSET));
    convertInt32ToDouble(SecondScratchReg, dest);
    ma_b(&end, ShortJump);

    // Not an int, just load as double.
    bind(&notInt32);
    ma_ld(dest, src);
    bind(&end);
}

void
MacroAssemblerMIPSCompat::loadInt32OrDouble(Register base, Register index,
                                            FloatRegister dest, int32_t shift)
{
    Label notInt32, end;

    // If it's an int, convert it to double.

    computeScaledAddress(BaseIndex(base, index, ShiftToScale(shift)), SecondScratchReg);
    // Since we only have one scratch, we need to stomp over it with the tag.
    load32(Address(SecondScratchReg, TAG_OFFSET), SecondScratchReg);
    asMasm().branchTestInt32(Assembler::NotEqual, SecondScratchReg, &notInt32);

    computeScaledAddress(BaseIndex(base, index, ShiftToScale(shift)), SecondScratchReg);
    load32(Address(SecondScratchReg, PAYLOAD_OFFSET), SecondScratchReg);
    convertInt32ToDouble(SecondScratchReg, dest);
    ma_b(&end, ShortJump);

    // Not an int, just load as double.
    bind(&notInt32);
    // First, recompute the offset that had been stored in the scratch register
    // since the scratch register was overwritten loading in the type.
    computeScaledAddress(BaseIndex(base, index, ShiftToScale(shift)), SecondScratchReg);
    loadDouble(Address(SecondScratchReg, 0), dest);
    bind(&end);
}

void
MacroAssemblerMIPSCompat::loadConstantDouble(double dp, FloatRegister dest)
{
    ma_lid(dest, dp);
}

void
MacroAssemblerMIPSCompat::loadConstantDouble(wasm::RawF64 d, FloatRegister dest)
{
    struct DoubleStruct {
        uint32_t lo;
        uint32_t hi;
    } ;
    DoubleStruct intStruct = mozilla::BitwiseCast<DoubleStruct>(d.bits());

    // put hi part of 64 bit value into the odd register
    if (intStruct.hi == 0) {
        moveToDoubleHi(zero, dest);
    } else {
        ScratchRegisterScope scratch(asMasm());
        ma_li(scratch, Imm32(intStruct.hi));
        moveToDoubleHi(scratch, dest);
    }

    // put low part of 64 bit value into the even register
    if (intStruct.lo == 0) {
        moveToDoubleLo(zero, dest);
    } else {
        ScratchRegisterScope scratch(asMasm());
        ma_li(scratch, Imm32(intStruct.lo));
        moveToDoubleLo(scratch, dest);
    }
}

Register
MacroAssemblerMIPSCompat::extractObject(const Address& address, Register scratch)
{
    ma_lw(scratch, Address(address.base, address.offset + PAYLOAD_OFFSET));
    return scratch;
}

Register
MacroAssemblerMIPSCompat::extractTag(const Address& address, Register scratch)
{
    ma_lw(scratch, Address(address.base, address.offset + TAG_OFFSET));
    return scratch;
}

Register
MacroAssemblerMIPSCompat::extractTag(const BaseIndex& address, Register scratch)
{
    computeScaledAddress(address, scratch);
    return extractTag(Address(scratch, address.offset), scratch);
}


uint32_t
MacroAssemblerMIPSCompat::getType(const Value& val)
{
    return val.toNunboxTag();
}

void
MacroAssemblerMIPSCompat::moveData(const Value& val, Register data)
{
    if (val.isMarkable())
        ma_li(data, ImmGCPtr(val.toMarkablePointer()));
    else
        ma_li(data, Imm32(val.toNunboxPayload()));
}

void
MacroAssemblerMIPSCompat::moveValue(const Value& val, Register type, Register data)
{
    MOZ_ASSERT(type != data);
    ma_li(type, Imm32(getType(val)));
    moveData(val, data);
}
void
MacroAssemblerMIPSCompat::moveValue(const Value& val, const ValueOperand& dest)
{
    moveValue(val, dest.typeReg(), dest.payloadReg());
}

/* There are 3 paths trough backedge jump. They are listed here in the order
 * in which instructions are executed.
 *  - The short jump is simple:
 *     b offset            # Jumps directly to target.
 *     lui at, addr1_hi    # In delay slot. Don't care about 'at' here.
 *
 *  - The long jump to loop header:
 *      b label1
 *      lui at, addr1_hi   # In delay slot. We use the value in 'at' later.
 *    label1:
 *      ori at, addr1_lo
 *      jr at
 *      lui at, addr2_hi   # In delay slot. Don't care about 'at' here.
 *
 *  - The long jump to interrupt loop:
 *      b label2
 *      lui at, addr1_hi   # In delay slot. Don't care about 'at' here.
 *    label2:
 *      lui at, addr2_hi
 *      ori at, addr2_lo
 *      jr at
 *      nop                # In delay slot.
 *
 * The backedge is done this way to avoid patching lui+ori pair while it is
 * being executed. Look also at jit::PatchBackedge().
 */
CodeOffsetJump
MacroAssemblerMIPSCompat::backedgeJump(RepatchLabel* label, Label* documentation)
{
    // Only one branch per label.
    MOZ_ASSERT(!label->used());
    uint32_t dest = label->bound() ? label->offset() : LabelBase::INVALID_OFFSET;
    BufferOffset bo = nextOffset();
    label->use(bo.getOffset());

    // Backedges are short jumps when bound, but can become long when patched.
    m_buffer.ensureSpace(8 * sizeof(uint32_t));
    if (label->bound()) {
        int32_t offset = label->offset() - bo.getOffset();
        MOZ_ASSERT(BOffImm16::IsInRange(offset));
        as_b(BOffImm16(offset));
    } else {
        // Jump to "label1" by default to jump to the loop header.
        as_b(BOffImm16(2 * sizeof(uint32_t)));
    }
    // No need for nop here. We can safely put next instruction in delay slot.
    ma_liPatchable(ScratchRegister, Imm32(dest));
    MOZ_ASSERT(nextOffset().getOffset() - bo.getOffset() == 3 * sizeof(uint32_t));
    as_jr(ScratchRegister);
    // No need for nop here. We can safely put next instruction in delay slot.
    ma_liPatchable(ScratchRegister, Imm32(dest));
    as_jr(ScratchRegister);
    as_nop();
    MOZ_ASSERT(nextOffset().getOffset() - bo.getOffset() == 8 * sizeof(uint32_t));
    return CodeOffsetJump(bo.getOffset());
}

CodeOffsetJump
MacroAssemblerMIPSCompat::jumpWithPatch(RepatchLabel* label, Label* documentation)
{
    // Only one branch per label.
    MOZ_ASSERT(!label->used());
    uint32_t dest = label->bound() ? label->offset() : LabelBase::INVALID_OFFSET;

    BufferOffset bo = nextOffset();
    label->use(bo.getOffset());
    addLongJump(bo);
    ma_liPatchable(ScratchRegister, Imm32(dest));
    as_jr(ScratchRegister);
    as_nop();
    return CodeOffsetJump(bo.getOffset());
}

/////////////////////////////////////////////////////////////////
// X86/X64-common/ARM/MIPS interface.
/////////////////////////////////////////////////////////////////
void
MacroAssemblerMIPSCompat::storeValue(ValueOperand val, Operand dst)
{
    storeValue(val, Address(Register::FromCode(dst.base()), dst.disp()));
}

void
MacroAssemblerMIPSCompat::storeValue(ValueOperand val, const BaseIndex& dest)
{
    computeScaledAddress(dest, SecondScratchReg);
    storeValue(val, Address(SecondScratchReg, dest.offset));
}

void
MacroAssemblerMIPSCompat::storeValue(JSValueType type, Register reg, BaseIndex dest)
{
    computeScaledAddress(dest, ScratchRegister);

    // Make sure that ma_sw doesn't clobber ScratchRegister
    int32_t offset = dest.offset;
    if (!Imm16::IsInSignedRange(offset)) {
        ma_li(SecondScratchReg, Imm32(offset));
        as_addu(ScratchRegister, ScratchRegister, SecondScratchReg);
        offset = 0;
    }

    storeValue(type, reg, Address(ScratchRegister, offset));
}

void
MacroAssemblerMIPSCompat::storeValue(ValueOperand val, const Address& dest)
{
    ma_sw(val.payloadReg(), Address(dest.base, dest.offset + PAYLOAD_OFFSET));
    ma_sw(val.typeReg(), Address(dest.base, dest.offset + TAG_OFFSET));
}

void
MacroAssemblerMIPSCompat::storeValue(JSValueType type, Register reg, Address dest)
{
    MOZ_ASSERT(dest.base != SecondScratchReg);

    ma_sw(reg, Address(dest.base, dest.offset + PAYLOAD_OFFSET));
    ma_li(SecondScratchReg, ImmTag(JSVAL_TYPE_TO_TAG(type)));
    ma_sw(SecondScratchReg, Address(dest.base, dest.offset + TAG_OFFSET));
}

void
MacroAssemblerMIPSCompat::storeValue(const Value& val, Address dest)
{
    MOZ_ASSERT(dest.base != SecondScratchReg);

    ma_li(SecondScratchReg, Imm32(getType(val)));
    ma_sw(SecondScratchReg, Address(dest.base, dest.offset + TAG_OFFSET));
    moveData(val, SecondScratchReg);
    ma_sw(SecondScratchReg, Address(dest.base, dest.offset + PAYLOAD_OFFSET));
}

void
MacroAssemblerMIPSCompat::storeValue(const Value& val, BaseIndex dest)
{
    computeScaledAddress(dest, ScratchRegister);

    // Make sure that ma_sw doesn't clobber ScratchRegister
    int32_t offset = dest.offset;
    if (!Imm16::IsInSignedRange(offset)) {
        ma_li(SecondScratchReg, Imm32(offset));
        as_addu(ScratchRegister, ScratchRegister, SecondScratchReg);
        offset = 0;
    }
    storeValue(val, Address(ScratchRegister, offset));
}

void
MacroAssemblerMIPSCompat::loadValue(const BaseIndex& addr, ValueOperand val)
{
    computeScaledAddress(addr, SecondScratchReg);
    loadValue(Address(SecondScratchReg, addr.offset), val);
}

void
MacroAssemblerMIPSCompat::loadValue(Address src, ValueOperand val)
{
    // Ensure that loading the payload does not erase the pointer to the
    // Value in memory.
    if (src.base != val.payloadReg()) {
        ma_lw(val.payloadReg(), Address(src.base, src.offset + PAYLOAD_OFFSET));
        ma_lw(val.typeReg(), Address(src.base, src.offset + TAG_OFFSET));
    } else {
        ma_lw(val.typeReg(), Address(src.base, src.offset + TAG_OFFSET));
        ma_lw(val.payloadReg(), Address(src.base, src.offset + PAYLOAD_OFFSET));
    }
}

void
MacroAssemblerMIPSCompat::tagValue(JSValueType type, Register payload, ValueOperand dest)
{
    MOZ_ASSERT(payload != dest.typeReg());
    ma_li(dest.typeReg(), ImmType(type));
    if (payload != dest.payloadReg())
        ma_move(dest.payloadReg(), payload);
}

void
MacroAssemblerMIPSCompat::pushValue(ValueOperand val)
{
    // Allocate stack slots for type and payload. One for each.
    asMasm().subPtr(Imm32(sizeof(Value)), StackPointer);
    // Store type and payload.
    storeValue(val, Address(StackPointer, 0));
}

void
MacroAssemblerMIPSCompat::pushValue(const Address& addr)
{
    // Allocate stack slots for type and payload. One for each.
    ma_subu(StackPointer, StackPointer, Imm32(sizeof(Value)));
    // Store type and payload.
    ma_lw(ScratchRegister, Address(addr.base, addr.offset + TAG_OFFSET));
    ma_sw(ScratchRegister, Address(StackPointer, TAG_OFFSET));
    ma_lw(ScratchRegister, Address(addr.base, addr.offset + PAYLOAD_OFFSET));
    ma_sw(ScratchRegister, Address(StackPointer, PAYLOAD_OFFSET));
}

void
MacroAssemblerMIPSCompat::popValue(ValueOperand val)
{
    // Load payload and type.
    as_lw(val.payloadReg(), StackPointer, PAYLOAD_OFFSET);
    as_lw(val.typeReg(), StackPointer, TAG_OFFSET);
    // Free stack.
    as_addiu(StackPointer, StackPointer, sizeof(Value));
}

void
MacroAssemblerMIPSCompat::storePayload(const Value& val, Address dest)
{
    moveData(val, SecondScratchReg);
    ma_sw(SecondScratchReg, Address(dest.base, dest.offset + PAYLOAD_OFFSET));
}

void
MacroAssemblerMIPSCompat::storePayload(Register src, Address dest)
{
    ma_sw(src, Address(dest.base, dest.offset + PAYLOAD_OFFSET));
    return;
}

void
MacroAssemblerMIPSCompat::storePayload(const Value& val, const BaseIndex& dest)
{
    MOZ_ASSERT(dest.offset == 0);

    computeScaledAddress(dest, SecondScratchReg);

    moveData(val, ScratchRegister);

    as_sw(ScratchRegister, SecondScratchReg, NUNBOX32_PAYLOAD_OFFSET);
}

void
MacroAssemblerMIPSCompat::storePayload(Register src, const BaseIndex& dest)
{
    MOZ_ASSERT(dest.offset == 0);

    computeScaledAddress(dest, SecondScratchReg);
    as_sw(src, SecondScratchReg, NUNBOX32_PAYLOAD_OFFSET);
}

void
MacroAssemblerMIPSCompat::storeTypeTag(ImmTag tag, Address dest)
{
    ma_li(SecondScratchReg, tag);
    ma_sw(SecondScratchReg, Address(dest.base, dest.offset + TAG_OFFSET));
}

void
MacroAssemblerMIPSCompat::storeTypeTag(ImmTag tag, const BaseIndex& dest)
{
    MOZ_ASSERT(dest.offset == 0);

    computeScaledAddress(dest, SecondScratchReg);
    ma_li(ScratchRegister, tag);
    as_sw(ScratchRegister, SecondScratchReg, TAG_OFFSET);
}

void
MacroAssemblerMIPSCompat::breakpoint()
{
    as_break(0);
}

void
MacroAssemblerMIPSCompat::ensureDouble(const ValueOperand& source, FloatRegister dest,
                                       Label* failure)
{
    Label isDouble, done;
    asMasm().branchTestDouble(Assembler::Equal, source.typeReg(), &isDouble);
    asMasm().branchTestInt32(Assembler::NotEqual, source.typeReg(), failure);

    convertInt32ToDouble(source.payloadReg(), dest);
    jump(&done);

    bind(&isDouble);
    unboxDouble(source, dest);

    bind(&done);
}

void
MacroAssemblerMIPSCompat::checkStackAlignment()
{
#ifdef DEBUG
    Label aligned;
    as_andi(ScratchRegister, sp, ABIStackAlignment - 1);
    ma_b(ScratchRegister, zero, &aligned, Equal, ShortJump);
    as_break(BREAK_STACK_UNALIGNED);
    bind(&aligned);
#endif
}

void
MacroAssemblerMIPSCompat::alignStackPointer()
{
    movePtr(StackPointer, SecondScratchReg);
    asMasm().subPtr(Imm32(sizeof(uintptr_t)), StackPointer);
    asMasm().andPtr(Imm32(~(ABIStackAlignment - 1)), StackPointer);
    storePtr(SecondScratchReg, Address(StackPointer, 0));
}

void
MacroAssemblerMIPSCompat::restoreStackPointer()
{
    loadPtr(Address(StackPointer, 0), StackPointer);
}

void
MacroAssembler::alignFrameForICArguments(AfterICSaveLive& aic)
{
    if (framePushed() % ABIStackAlignment != 0) {
        aic.alignmentPadding = ABIStackAlignment - (framePushed() % ABIStackAlignment);
        reserveStack(aic.alignmentPadding);
    } else {
        aic.alignmentPadding = 0;
    }
    MOZ_ASSERT(framePushed() % ABIStackAlignment == 0);
    checkStackAlignment();
}

void
MacroAssembler::restoreFrameAlignmentForICArguments(AfterICSaveLive& aic)
{
    if (aic.alignmentPadding != 0)
        freeStack(aic.alignmentPadding);
}

void
MacroAssemblerMIPSCompat::handleFailureWithHandlerTail(void* handler)
{
    // Reserve space for exception information.
    int size = (sizeof(ResumeFromException) + ABIStackAlignment) & ~(ABIStackAlignment - 1);
    asMasm().subPtr(Imm32(size), StackPointer);
    ma_move(a0, StackPointer); // Use a0 since it is a first function argument

    // Call the handler.
    asMasm().setupUnalignedABICall(a1);
    asMasm().passABIArg(a0);
    asMasm().callWithABI(handler);

    Label entryFrame;
    Label catch_;
    Label finally;
    Label return_;
    Label bailout;

    // Already clobbered a0, so use it...
    load32(Address(StackPointer, offsetof(ResumeFromException, kind)), a0);
    asMasm().branch32(Assembler::Equal, a0, Imm32(ResumeFromException::RESUME_ENTRY_FRAME),
                      &entryFrame);
    asMasm().branch32(Assembler::Equal, a0, Imm32(ResumeFromException::RESUME_CATCH), &catch_);
    asMasm().branch32(Assembler::Equal, a0, Imm32(ResumeFromException::RESUME_FINALLY), &finally);
    asMasm().branch32(Assembler::Equal, a0, Imm32(ResumeFromException::RESUME_FORCED_RETURN),
                      &return_);
    asMasm().branch32(Assembler::Equal, a0, Imm32(ResumeFromException::RESUME_BAILOUT), &bailout);

    breakpoint(); // Invalid kind.

    // No exception handler. Load the error value, load the new stack pointer
    // and return from the entry frame.
    bind(&entryFrame);
    moveValue(MagicValue(JS_ION_ERROR), JSReturnOperand);
    loadPtr(Address(StackPointer, offsetof(ResumeFromException, stackPointer)), StackPointer);

    // We're going to be returning by the ion calling convention
    ma_pop(ra);
    as_jr(ra);
    as_nop();

    // If we found a catch handler, this must be a baseline frame. Restore
    // state and jump to the catch block.
    bind(&catch_);
    loadPtr(Address(StackPointer, offsetof(ResumeFromException, target)), a0);
    loadPtr(Address(StackPointer, offsetof(ResumeFromException, framePointer)), BaselineFrameReg);
    loadPtr(Address(StackPointer, offsetof(ResumeFromException, stackPointer)), StackPointer);
    jump(a0);

    // If we found a finally block, this must be a baseline frame. Push
    // two values expected by JSOP_RETSUB: BooleanValue(true) and the
    // exception.
    bind(&finally);
    ValueOperand exception = ValueOperand(a1, a2);
    loadValue(Address(sp, offsetof(ResumeFromException, exception)), exception);

    loadPtr(Address(sp, offsetof(ResumeFromException, target)), a0);
    loadPtr(Address(sp, offsetof(ResumeFromException, framePointer)), BaselineFrameReg);
    loadPtr(Address(sp, offsetof(ResumeFromException, stackPointer)), sp);

    pushValue(BooleanValue(true));
    pushValue(exception);
    jump(a0);

    // Only used in debug mode. Return BaselineFrame->returnValue() to the
    // caller.
    bind(&return_);
    loadPtr(Address(StackPointer, offsetof(ResumeFromException, framePointer)), BaselineFrameReg);
    loadPtr(Address(StackPointer, offsetof(ResumeFromException, stackPointer)), StackPointer);
    loadValue(Address(BaselineFrameReg, BaselineFrame::reverseOffsetOfReturnValue()),
              JSReturnOperand);
    ma_move(StackPointer, BaselineFrameReg);
    pop(BaselineFrameReg);

    // If profiling is enabled, then update the lastProfilingFrame to refer to caller
    // frame before returning.
    {
        Label skipProfilingInstrumentation;
        // Test if profiler enabled.
        AbsoluteAddress addressOfEnabled(GetJitContext()->runtime->spsProfiler().addressOfEnabled());
        asMasm().branch32(Assembler::Equal, addressOfEnabled, Imm32(0),
                          &skipProfilingInstrumentation);
        profilerExitFrame();
        bind(&skipProfilingInstrumentation);
    }

    ret();

    // If we are bailing out to baseline to handle an exception, jump to
    // the bailout tail stub.
    bind(&bailout);
    loadPtr(Address(sp, offsetof(ResumeFromException, bailoutInfo)), a2);
    ma_li(ReturnReg, Imm32(BAILOUT_RETURN_OK));
    loadPtr(Address(sp, offsetof(ResumeFromException, target)), a1);
    jump(a1);
}

template<typename T>
void
MacroAssemblerMIPSCompat::compareExchangeToTypedIntArray(Scalar::Type arrayType, const T& mem,
                                                         Register oldval, Register newval,
                                                         Register temp, Register valueTemp,
                                                         Register offsetTemp, Register maskTemp,
                                                         AnyRegister output)
{
    switch (arrayType) {
      case Scalar::Int8:
        compareExchange8SignExtend(mem, oldval, newval, valueTemp, offsetTemp, maskTemp, output.gpr());
        break;
      case Scalar::Uint8:
        compareExchange8ZeroExtend(mem, oldval, newval, valueTemp, offsetTemp, maskTemp, output.gpr());
        break;
      case Scalar::Int16:
        compareExchange16SignExtend(mem, oldval, newval, valueTemp, offsetTemp, maskTemp, output.gpr());
        break;
      case Scalar::Uint16:
        compareExchange16ZeroExtend(mem, oldval, newval, valueTemp, offsetTemp, maskTemp, output.gpr());
        break;
      case Scalar::Int32:
        compareExchange32(mem, oldval, newval, valueTemp, offsetTemp, maskTemp, output.gpr());
        break;
      case Scalar::Uint32:
        // At the moment, the code in MCallOptimize.cpp requires the output
        // type to be double for uint32 arrays.  See bug 1077305.
        MOZ_ASSERT(output.isFloat());
        compareExchange32(mem, oldval, newval, valueTemp, offsetTemp, maskTemp, temp);
        convertUInt32ToDouble(temp, output.fpu());
        break;
      default:
        MOZ_CRASH("Invalid typed array type");
    }
}

template void
MacroAssemblerMIPSCompat::compareExchangeToTypedIntArray(Scalar::Type arrayType, const Address& mem,
                                                         Register oldval, Register newval, Register temp,
                                                         Register valueTemp, Register offsetTemp, Register maskTemp,
                                                         AnyRegister output);
template void
MacroAssemblerMIPSCompat::compareExchangeToTypedIntArray(Scalar::Type arrayType, const BaseIndex& mem,
                                                         Register oldval, Register newval, Register temp,
                                                         Register valueTemp, Register offsetTemp, Register maskTemp,
                                                         AnyRegister output);

template<typename T>
void
MacroAssemblerMIPSCompat::atomicExchangeToTypedIntArray(Scalar::Type arrayType, const T& mem,
                                                        Register value, Register temp, Register valueTemp,
                                                        Register offsetTemp, Register maskTemp,
                                                        AnyRegister output)
{
    switch (arrayType) {
      case Scalar::Int8:
        atomicExchange8SignExtend(mem, value, valueTemp, offsetTemp, maskTemp, output.gpr());
        break;
      case Scalar::Uint8:
        atomicExchange8ZeroExtend(mem, value, valueTemp, offsetTemp, maskTemp, output.gpr());
        break;
      case Scalar::Int16:
        atomicExchange16SignExtend(mem, value, valueTemp, offsetTemp, maskTemp, output.gpr());
        break;
      case Scalar::Uint16:
        atomicExchange16ZeroExtend(mem, value, valueTemp, offsetTemp, maskTemp, output.gpr());
        break;
      case Scalar::Int32:
        atomicExchange32(mem, value, valueTemp, offsetTemp, maskTemp, output.gpr());
        break;
      case Scalar::Uint32:
        // At the moment, the code in MCallOptimize.cpp requires the output
        // type to be double for uint32 arrays.  See bug 1077305.
        MOZ_ASSERT(output.isFloat());
        atomicExchange32(mem, value, valueTemp, offsetTemp, maskTemp, temp);
        convertUInt32ToDouble(temp, output.fpu());
        break;
      default:
        MOZ_CRASH("Invalid typed array type");
    }
}

template void
MacroAssemblerMIPSCompat::atomicExchangeToTypedIntArray(Scalar::Type arrayType, const Address& mem,
                                                        Register value, Register temp, Register valueTemp,
                                                        Register offsetTemp, Register maskTemp,
                                                        AnyRegister output);
template void
MacroAssemblerMIPSCompat::atomicExchangeToTypedIntArray(Scalar::Type arrayType, const BaseIndex& mem,
                                                        Register value, Register temp, Register valueTemp,
                                                        Register offsetTemp, Register maskTemp,
                                                        AnyRegister output);

CodeOffset
MacroAssemblerMIPSCompat::toggledJump(Label* label)
{
    CodeOffset ret(nextOffset().getOffset());
    ma_b(label);
    return ret;
}

CodeOffset
MacroAssemblerMIPSCompat::toggledCall(JitCode* target, bool enabled)
{
    BufferOffset bo = nextOffset();
    CodeOffset offset(bo.getOffset());
    addPendingJump(bo, ImmPtr(target->raw()), Relocation::JITCODE);
    ma_liPatchable(ScratchRegister, ImmPtr(target->raw()));
    if (enabled) {
        as_jalr(ScratchRegister);
        as_nop();
    } else {
        as_nop();
        as_nop();
    }
    MOZ_ASSERT_IF(!oom(), nextOffset().getOffset() - offset.offset() == ToggledCallSize(nullptr));
    return offset;
}

void
MacroAssemblerMIPSCompat::profilerEnterFrame(Register framePtr, Register scratch)
{
    AbsoluteAddress activation(GetJitContext()->runtime->addressOfProfilingActivation());
    loadPtr(activation, scratch);
    storePtr(framePtr, Address(scratch, JitActivation::offsetOfLastProfilingFrame()));
    storePtr(ImmPtr(nullptr), Address(scratch, JitActivation::offsetOfLastProfilingCallSite()));
}

void
MacroAssemblerMIPSCompat::profilerExitFrame()
{
    branch(GetJitContext()->runtime->jitRuntime()->getProfilerExitFrameTail());
}

void
MacroAssembler::subFromStackPtr(Imm32 imm32)
{
    if (imm32.value)
        asMasm().subPtr(imm32, StackPointer);
}

//{{{ check_macroassembler_style
// ===============================================================
// Stack manipulation functions.

void
MacroAssembler::PushRegsInMask(LiveRegisterSet set)
{
    int32_t diffF = set.fpus().getPushSizeInBytes();
    int32_t diffG = set.gprs().size() * sizeof(intptr_t);

    reserveStack(diffG);
    for (GeneralRegisterBackwardIterator iter(set.gprs()); iter.more(); ++iter) {
        diffG -= sizeof(intptr_t);
        storePtr(*iter, Address(StackPointer, diffG));
    }
    MOZ_ASSERT(diffG == 0);

    // Double values have to be aligned. We reserve extra space so that we can
    // start writing from the first aligned location.
    // We reserve a whole extra double so that the buffer has even size.
    ma_and(SecondScratchReg, sp, Imm32(~(ABIStackAlignment - 1)));
    reserveStack(diffF + sizeof(double));

    for (FloatRegisterForwardIterator iter(set.fpus().reduceSetForPush()); iter.more(); ++iter) {
        if ((*iter).code() % 2 == 0)
            as_sd(*iter, SecondScratchReg, -diffF);
        diffF -= sizeof(double);
    }
    MOZ_ASSERT(diffF == 0);
}

void
MacroAssembler::PopRegsInMaskIgnore(LiveRegisterSet set, LiveRegisterSet ignore)
{
    int32_t diffG = set.gprs().size() * sizeof(intptr_t);
    int32_t diffF = set.fpus().getPushSizeInBytes();
    const int32_t reservedG = diffG;
    const int32_t reservedF = diffF;

    // Read the buffer form the first aligned location.
    ma_addu(SecondScratchReg, sp, Imm32(reservedF + sizeof(double)));
    ma_and(SecondScratchReg, SecondScratchReg, Imm32(~(ABIStackAlignment - 1)));

    for (FloatRegisterForwardIterator iter(set.fpus().reduceSetForPush()); iter.more(); ++iter) {
        if (!ignore.has(*iter) && ((*iter).code() % 2 == 0))
            // Use assembly l.d because we have alligned the stack.
            as_ld(*iter, SecondScratchReg, -diffF);
        diffF -= sizeof(double);
    }
    freeStack(reservedF + sizeof(double));
    MOZ_ASSERT(diffF == 0);

    for (GeneralRegisterBackwardIterator iter(set.gprs()); iter.more(); ++iter) {
        diffG -= sizeof(intptr_t);
        if (!ignore.has(*iter))
            loadPtr(Address(StackPointer, diffG), *iter);
    }
    freeStack(reservedG);
    MOZ_ASSERT(diffG == 0);
}

// ===============================================================
// ABI function calls.

void
MacroAssembler::setupUnalignedABICall(Register scratch)
{
    setupABICall();
    dynamicAlignment_ = true;

    ma_move(scratch, StackPointer);

    // Force sp to be aligned
    asMasm().subPtr(Imm32(sizeof(uintptr_t)), StackPointer);
    ma_and(StackPointer, StackPointer, Imm32(~(ABIStackAlignment - 1)));
    storePtr(scratch, Address(StackPointer, 0));
}

void
MacroAssembler::callWithABIPre(uint32_t* stackAdjust, bool callFromWasm)
{
    MOZ_ASSERT(inCall_);
    uint32_t stackForCall = abiArgs_.stackBytesConsumedSoFar();

    // Reserve place for $ra.
    stackForCall += sizeof(intptr_t);

    if (dynamicAlignment_) {
        stackForCall += ComputeByteAlignment(stackForCall, ABIStackAlignment);
    } else {
        uint32_t alignmentAtPrologue = callFromWasm ? sizeof(wasm::Frame) : 0;
        stackForCall += ComputeByteAlignment(stackForCall + framePushed() + alignmentAtPrologue,
                                             ABIStackAlignment);
    }

    *stackAdjust = stackForCall;
    reserveStack(stackForCall);

    // Save $ra because call is going to clobber it. Restore it in
    // callWithABIPost. NOTE: This is needed for calls from SharedIC.
    // Maybe we can do this differently.
    storePtr(ra, Address(StackPointer, stackForCall - sizeof(intptr_t)));

    // Position all arguments.
    {
        enoughMemory_ = enoughMemory_ && moveResolver_.resolve();
        if (!enoughMemory_)
            return;

        MoveEmitter emitter(*this);
        emitter.emit(moveResolver_);
        emitter.finish();
    }

    assertStackAlignment(ABIStackAlignment);
}

void
MacroAssembler::callWithABIPost(uint32_t stackAdjust, MoveOp::Type result)
{
    // Restore ra value (as stored in callWithABIPre()).
    loadPtr(Address(StackPointer, stackAdjust - sizeof(intptr_t)), ra);

    if (dynamicAlignment_) {
        // Restore sp value from stack (as stored in setupUnalignedABICall()).
        loadPtr(Address(StackPointer, stackAdjust), StackPointer);
        // Use adjustFrame instead of freeStack because we already restored sp.
        adjustFrame(-stackAdjust);
    } else {
        freeStack(stackAdjust);
    }

#ifdef DEBUG
    MOZ_ASSERT(inCall_);
    inCall_ = false;
#endif
}

void
MacroAssembler::callWithABINoProfiler(Register fun, MoveOp::Type result)
{
    // Load the callee in t9, no instruction between the lw and call
    // should clobber it. Note that we can't use fun.base because it may
    // be one of the IntArg registers clobbered before the call.
    ma_move(t9, fun);
    uint32_t stackAdjust;
    callWithABIPre(&stackAdjust);
    call(t9);
    callWithABIPost(stackAdjust, result);
}

void
MacroAssembler::callWithABINoProfiler(const Address& fun, MoveOp::Type result)
{
    // Load the callee in t9, as above.
    loadPtr(Address(fun.base, fun.offset), t9);
    uint32_t stackAdjust;
    callWithABIPre(&stackAdjust);
    call(t9);
    callWithABIPost(stackAdjust, result);
}

// ===============================================================
// Branch functions

void
MacroAssembler::branchValueIsNurseryObject(Condition cond, const Address& address,
                                           Register temp, Label* label)
{
    MOZ_ASSERT(cond == Assembler::Equal || cond == Assembler::NotEqual);

    Label done;

    branchTestObject(Assembler::NotEqual, address, cond == Assembler::Equal ? &done : label);
    loadPtr(address, temp);
    branchPtrInNurseryChunk(cond, temp, InvalidReg, label);

    bind(&done);
}

void
MacroAssembler::branchValueIsNurseryObject(Condition cond, ValueOperand value,
                                           Register temp, Label* label)
{
    MOZ_ASSERT(cond == Assembler::Equal || cond == Assembler::NotEqual);

    Label done;

    branchTestObject(Assembler::NotEqual, value, cond == Assembler::Equal ? &done : label);
    branchPtrInNurseryChunk(cond, value.payloadReg(), temp, label);

    bind(&done);
}

void
MacroAssembler::branchTestValue(Condition cond, const ValueOperand& lhs,
                                const Value& rhs, Label* label)
{
    MOZ_ASSERT(cond == Equal || cond == NotEqual);
    ScratchRegisterScope scratch(*this);
    moveData(rhs, scratch);

    if (cond == Equal) {
        Label done;
        ma_b(lhs.payloadReg(), scratch, &done, NotEqual, ShortJump);
        {
            ma_b(lhs.typeReg(), Imm32(getType(rhs)), label, Equal);
        }
        bind(&done);
    } else {
        ma_b(lhs.payloadReg(), scratch, label, NotEqual);

        ma_b(lhs.typeReg(), Imm32(getType(rhs)), label, NotEqual);
    }
}

// ========================================================================
// Memory access primitives.
template <typename T>
void
MacroAssembler::storeUnboxedValue(const ConstantOrRegister& value, MIRType valueType,
                                  const T& dest, MIRType slotType)
{
    if (valueType == MIRType::Double) {
        storeDouble(value.reg().typedReg().fpu(), dest);
        return;
    }

    // Store the type tag if needed.
    if (valueType != slotType)
        storeTypeTag(ImmType(ValueTypeFromMIRType(valueType)), dest);

    // Store the payload.
    if (value.constant())
        storePayload(value.value(), dest);
    else
        storePayload(value.reg().typedReg().gpr(), dest);
}

template void
MacroAssembler::storeUnboxedValue(const ConstantOrRegister& value, MIRType valueType,
                                  const Address& dest, MIRType slotType);
template void
MacroAssembler::storeUnboxedValue(const ConstantOrRegister& value, MIRType valueType,
                                  const BaseIndex& dest, MIRType slotType);

//}}} check_macroassembler_style
