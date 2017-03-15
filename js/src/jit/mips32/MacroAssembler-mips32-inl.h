/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef jit_mips32_MacroAssembler_mips32_inl_h
#define jit_mips32_MacroAssembler_mips32_inl_h

#include "jit/mips32/MacroAssembler-mips32.h"

#include "jit/mips-shared/MacroAssembler-mips-shared-inl.h"

namespace js {
namespace jit {

//{{{ check_macroassembler_style

void
MacroAssembler::move64(Register64 src, Register64 dest)
{
    move32(src.low, dest.low);
    move32(src.high, dest.high);
}

void
MacroAssembler::move64(Imm64 imm, Register64 dest)
{
    move32(Imm32(imm.value & 0xFFFFFFFFL), dest.low);
    move32(Imm32((imm.value >> 32) & 0xFFFFFFFFL), dest.high);
}

// ===============================================================
// Logical instructions

void
MacroAssembler::andPtr(Register src, Register dest)
{
    ma_and(dest, src);
}

void
MacroAssembler::andPtr(Imm32 imm, Register dest)
{
    ma_and(dest, imm);
}

void
MacroAssembler::and64(Imm64 imm, Register64 dest)
{
    if (imm.low().value != int32_t(0xFFFFFFFF))
        and32(imm.low(), dest.low);
    if (imm.hi().value != int32_t(0xFFFFFFFF))
        and32(imm.hi(), dest.high);
}

void
MacroAssembler::and64(Register64 src, Register64 dest)
{
    and32(src.low, dest.low);
    and32(src.high, dest.high);
}

void
MacroAssembler::or64(Imm64 imm, Register64 dest)
{
    if (imm.low().value)
        or32(imm.low(), dest.low);
    if (imm.hi().value)
        or32(imm.hi(), dest.high);
}

void
MacroAssembler::xor64(Imm64 imm, Register64 dest)
{
    if (imm.low().value)
        xor32(imm.low(), dest.low);
    if (imm.hi().value)
        xor32(imm.hi(), dest.high);
}

void
MacroAssembler::orPtr(Register src, Register dest)
{
    ma_or(dest, src);
}

void
MacroAssembler::orPtr(Imm32 imm, Register dest)
{
    ma_or(dest, imm);
}

void
MacroAssembler::or64(Register64 src, Register64 dest)
{
    or32(src.low, dest.low);
    or32(src.high, dest.high);
}

void
MacroAssembler::xor64(Register64 src, Register64 dest)
{
    ma_xor(dest.low, src.low);
    ma_xor(dest.high, src.high);
}

void
MacroAssembler::xorPtr(Register src, Register dest)
{
    ma_xor(dest, src);
}

void
MacroAssembler::xorPtr(Imm32 imm, Register dest)
{
    ma_xor(dest, imm);
}

// ===============================================================
// Arithmetic functions

void
MacroAssembler::addPtr(Register src, Register dest)
{
    ma_addu(dest, src);
}

void
MacroAssembler::addPtr(Imm32 imm, Register dest)
{
    ma_addu(dest, imm);
}

void
MacroAssembler::addPtr(ImmWord imm, Register dest)
{
    addPtr(Imm32(imm.value), dest);
}

void
MacroAssembler::add64(Register64 src, Register64 dest)
{
    as_addu(dest.low, dest.low, src.low);
    as_sltu(ScratchRegister, dest.low, src.low);
    as_addu(dest.high, dest.high, src.high);
    as_addu(dest.high, dest.high, ScratchRegister);
}

void
MacroAssembler::add64(Imm32 imm, Register64 dest)
{
    ma_li(ScratchRegister, imm);
    as_addu(dest.low, dest.low, ScratchRegister);
    as_sltu(ScratchRegister, dest.low, ScratchRegister);
    as_addu(dest.high, dest.high, ScratchRegister);
}

void
MacroAssembler::add64(Imm64 imm, Register64 dest)
{
    add64(imm.low(), dest);
    ma_addu(dest.high, dest.high, imm.hi());
}

void
MacroAssembler::subPtr(Register src, Register dest)
{
    as_subu(dest, dest, src);
}

void
MacroAssembler::subPtr(Imm32 imm, Register dest)
{
    ma_subu(dest, dest, imm);
}

void
MacroAssembler::sub64(Register64 src, Register64 dest)
{
    as_sltu(ScratchRegister, dest.low, src.low);
    as_subu(dest.high, dest.high, ScratchRegister);
    as_subu(dest.low, dest.low, src.low);
    as_subu(dest.high, dest.high, src.high);
}

void
MacroAssembler::sub64(Imm64 imm, Register64 dest)
{
    ma_li(ScratchRegister, imm.low());
    as_sltu(ScratchRegister, dest.low, ScratchRegister);
    as_subu(dest.high, dest.high, ScratchRegister);
    ma_subu(dest.low, dest.low, imm.low());
    ma_subu(dest.high, dest.high, imm.hi());
}

void
MacroAssembler::mul64(Imm64 imm, const Register64& dest)
{
    // LOW32  = LOW(LOW(dest) * LOW(imm));
    // HIGH32 = LOW(HIGH(dest) * LOW(imm)) [multiply imm into upper bits]
    //        + LOW(LOW(dest) * HIGH(imm)) [multiply dest into upper bits]
    //        + HIGH(LOW(dest) * LOW(imm)) [carry]

    // HIGH(dest) = LOW(HIGH(dest) * LOW(imm));
    ma_li(ScratchRegister, Imm32(imm.value & LOW_32_MASK));
    as_multu(dest.high, ScratchRegister);
    as_mflo(dest.high);

    // mfhi:mflo = LOW(dest) * LOW(imm);
    as_multu(dest.low, ScratchRegister);

    // HIGH(dest) += mfhi;
    as_mfhi(ScratchRegister);
    as_addu(dest.high, dest.high, ScratchRegister);

    if (((imm.value >> 32) & LOW_32_MASK) == 5) {
        // Optimized case for Math.random().

        // HIGH(dest) += LOW(LOW(dest) * HIGH(imm));
        as_sll(ScratchRegister, dest.low, 2);
        as_addu(ScratchRegister, ScratchRegister, dest.low);
        as_addu(dest.high, dest.high, ScratchRegister);

        // LOW(dest) = mflo;
        as_mflo(dest.low);
    } else {
        // tmp = mflo
        as_mflo(SecondScratchReg);

        // HIGH(dest) += LOW(LOW(dest) * HIGH(imm));
        ma_li(ScratchRegister, Imm32((imm.value >> 32) & LOW_32_MASK));
        as_multu(dest.low, ScratchRegister);
        as_mflo(ScratchRegister);
        as_addu(dest.high, dest.high, ScratchRegister);

        // LOW(dest) = tmp;
        ma_move(dest.low, SecondScratchReg);
    }
}

void
MacroAssembler::mul64(Imm64 imm, const Register64& dest, const Register temp)
{
    // LOW32  = LOW(LOW(dest) * LOW(imm));
    // HIGH32 = LOW(HIGH(dest) * LOW(imm)) [multiply imm into upper bits]
    //        + LOW(LOW(dest) * HIGH(imm)) [multiply dest into upper bits]
    //        + HIGH(LOW(dest) * LOW(imm)) [carry]

    // HIGH(dest) = LOW(HIGH(dest) * LOW(imm));
    MOZ_ASSERT(temp != dest.high && temp != dest.low);

    ma_li(ScratchRegister, imm.firstHalf());
    as_multu(dest.high, ScratchRegister);
    as_mflo(dest.high);

    ma_li(ScratchRegister, imm.secondHalf());
    as_multu(dest.low, ScratchRegister);
    as_mflo(temp);
    as_addu(temp, dest.high, temp);

    ma_li(ScratchRegister, imm.firstHalf());
    as_multu(dest.low, ScratchRegister);
    as_mfhi(dest.high);
    as_mflo(dest.low);
    as_addu(dest.high, dest.high, temp);
}

void
MacroAssembler::mul64(const Register64& src, const Register64& dest, const Register temp)
{
    // LOW32  = LOW(LOW(dest) * LOW(imm));
    // HIGH32 = LOW(HIGH(dest) * LOW(imm)) [multiply imm into upper bits]
    //        + LOW(LOW(dest) * HIGH(imm)) [multiply dest into upper bits]
    //        + HIGH(LOW(dest) * LOW(imm)) [carry]

    // HIGH(dest) = LOW(HIGH(dest) * LOW(imm));
    MOZ_ASSERT(dest != src);
    MOZ_ASSERT(dest.low != src.high && dest.high != src.low);

    as_multu(dest.high, src.low); // (2)
    as_mflo(dest.high);
    as_multu(dest.low, src.high); // (3)
    as_mflo(temp);
    as_addu(temp, dest.high, temp);
    as_multu(dest.low, src.low);  // (4) + (1)
    as_mfhi(dest.high);
    as_mflo(dest.low);
    as_addu(dest.high, dest.high, temp);
}

void
MacroAssembler::neg64(Register64 reg)
{
    ma_li(ScratchRegister, Imm32(1));
    as_movz(ScratchRegister, zero, reg.low);
    ma_negu(reg.low, reg.low);
    as_addu(reg.high, reg.high, ScratchRegister);
    ma_negu(reg.high, reg.high);
}

void
MacroAssembler::mulBy3(Register src, Register dest)
{
    as_addu(dest, src, src);
    as_addu(dest, dest, src);
}

void
MacroAssembler::inc64(AbsoluteAddress dest)
{
    ma_li(ScratchRegister, Imm32((int32_t)dest.addr));
    as_lw(SecondScratchReg, ScratchRegister, 0);

    as_addiu(SecondScratchReg, SecondScratchReg, 1);
    as_sw(SecondScratchReg, ScratchRegister, 0);

    as_sltiu(SecondScratchReg, SecondScratchReg, 1);
    as_lw(ScratchRegister, ScratchRegister, 4);

    as_addu(SecondScratchReg, ScratchRegister, SecondScratchReg);

    ma_li(ScratchRegister, Imm32((int32_t)dest.addr));
    as_sw(SecondScratchReg, ScratchRegister, 4);
}

// ===============================================================
// Shift functions

void
MacroAssembler::lshiftPtr(Imm32 imm, Register dest)
{
    MOZ_ASSERT(0 <= imm.value && imm.value < 32);
    ma_sll(dest, dest, imm);
}

void
MacroAssembler::lshift64(Imm32 imm, Register64 dest)
{
    MOZ_ASSERT(0 <= imm.value && imm.value < 64);
    ScratchRegisterScope scratch(*this);

    if (imm.value == 0) {
        return;
    } else if (imm.value < 32) {
        as_sll(dest.high, dest.high, imm.value);
        as_srl(scratch, dest.low, 32 - imm.value);
        as_or(dest.high, dest.high, scratch);
        as_sll(dest.low, dest.low, imm.value);
    } else {
        as_sll(dest.high, dest.low, imm.value - 32);
        move32(Imm32(0), dest.low);
    }
}

void
MacroAssembler::lshift64(Register unmaskedShift, Register64 dest)
{
    Label done, less;
    ScratchRegisterScope shift(*this);

    ma_and(shift, unmaskedShift, Imm32(0x3f));
    ma_b(shift, Imm32(0), &done, Equal);

    ma_sll(dest.high, dest.high, shift);
    ma_subu(shift, shift, Imm32(32));
    ma_b(shift, Imm32(0), &less, LessThan);

    ma_sll(dest.high, dest.low, shift);
    move32(Imm32(0), dest.low);
    ma_b(&done);

    bind(&less);
    ma_li(SecondScratchReg, Imm32(0));
    as_subu(shift, SecondScratchReg, shift);
    ma_srl(SecondScratchReg, dest.low, shift);
    as_or(dest.high, dest.high, SecondScratchReg);
    ma_and(shift, unmaskedShift, Imm32(0x3f));
    ma_sll(dest.low, dest.low, shift);

    bind(&done);
}

void
MacroAssembler::rshiftPtr(Imm32 imm, Register dest)
{
    MOZ_ASSERT(0 <= imm.value && imm.value < 32);
    ma_srl(dest, dest, imm);
}

void
MacroAssembler::rshiftPtrArithmetic(Imm32 imm, Register dest)
{
    MOZ_ASSERT(0 <= imm.value && imm.value < 32);
    ma_sra(dest, dest, imm);
}

void
MacroAssembler::rshift64(Imm32 imm, Register64 dest)
{
    MOZ_ASSERT(0 <= imm.value && imm.value < 64);
    ScratchRegisterScope scratch(*this);

    if (imm.value < 32) {
        as_srl(dest.low, dest.low, imm.value);
        as_sll(scratch, dest.high, 32 - imm.value);
        as_or(dest.low, dest.low, scratch);
        as_srl(dest.high, dest.high, imm.value);
    } else if (imm.value == 32) {
        ma_move(dest.low, dest.high);
        move32(Imm32(0), dest.high);
    } else {
        ma_srl(dest.low, dest.high, Imm32(imm.value - 32));
        move32(Imm32(0), dest.high);
    }
}

void
MacroAssembler::rshift64(Register unmaskedShift, Register64 dest)
{
    Label done, less;
    ScratchRegisterScope shift(*this);

    ma_and(shift, unmaskedShift, Imm32(0x3f));
    ma_srl(dest.low, dest.low, shift);
    ma_subu(shift, shift, Imm32(32));
    ma_b(shift, Imm32(0), &less, LessThan);

    ma_srl(dest.low, dest.high, shift);
    move32(Imm32(0), dest.high);
    ma_b(&done);

    bind(&less);
    ma_li(SecondScratchReg, Imm32(0));
    as_subu(shift, SecondScratchReg, shift);
    ma_sll(SecondScratchReg, dest.high, shift);
    as_or(dest.low, dest.low, SecondScratchReg);
    ma_and(shift, unmaskedShift, Imm32(0x3f));
    ma_srl(dest.high, dest.high, shift);

    bind(&done);
}

void
MacroAssembler::rshift64Arithmetic(Imm32 imm, Register64 dest)
{
    MOZ_ASSERT(0 <= imm.value && imm.value < 64);
    ScratchRegisterScope scratch(*this);

    if (imm.value < 32) {
        as_srl(dest.low, dest.low, imm.value);
        as_sll(scratch, dest.high, 32 - imm.value);
        as_or(dest.low, dest.low, scratch);
        as_sra(dest.high, dest.high, imm.value);
    } else if (imm.value == 32) {
        ma_move(dest.low, dest.high);
        as_sra(dest.high, dest.high, 31);
    } else {
        as_sra(dest.low, dest.high, imm.value - 32);
        as_sra(dest.high, dest.high, 31);
    }
}

void
MacroAssembler::rshift64Arithmetic(Register unmaskedShift, Register64 dest)
{
    Label done, less;

    ScratchRegisterScope shift(*this);
    ma_and(shift, unmaskedShift, Imm32(0x3f));

    ma_srl(dest.low, dest.low, shift);
    ma_subu(shift, shift, Imm32(32));
    ma_b(shift, Imm32(0), &less, LessThan);

    ma_sra(dest.low, dest.high, shift);
    as_sra(dest.high, dest.high, 31);
    ma_b(&done);

    bind(&less);
    ma_li(SecondScratchReg, Imm32(0));
    as_subu(shift, SecondScratchReg, shift);
    ma_sll(SecondScratchReg, dest.high, shift);
    as_or(dest.low, dest.low, SecondScratchReg);
    ma_and(shift, unmaskedShift, Imm32(0x3f));
    ma_sra(dest.high, dest.high, shift);

    bind(&done);
}

// ===============================================================
// Rotation functions

void
MacroAssembler::rotateLeft64(Imm32 count, Register64 input, Register64 dest, Register temp)
{
    MOZ_ASSERT(temp == InvalidReg);
    MOZ_ASSERT(input.low != dest.high && input.high != dest.low);

    int32_t amount = count.value & 0x3f;
    if (amount > 32) {
        rotateRight64(Imm32(64 - amount), input, dest, temp);
    } else {
        ScratchRegisterScope scratch(*this);
        if (amount == 0) {
            ma_move(dest.low, input.low);
            ma_move(dest.high, input.high);
        } else if (amount == 32) {
            ma_move(scratch, input.low);
            ma_move(dest.low, input.high);
            ma_move(dest.high, scratch);
        } else {
            MOZ_ASSERT(0 < amount && amount < 32);
            ma_move(scratch, input.high);
            ma_sll(dest.high, input.high, Imm32(amount));
            ma_srl(SecondScratchReg, input.low, Imm32(32 - amount));
            as_or(dest.high, dest.high, SecondScratchReg);
            ma_sll(dest.low, input.low, Imm32(amount));
            ma_srl(SecondScratchReg, scratch, Imm32(32 - amount));
            as_or(dest.low, dest.low, SecondScratchReg);

        }
    }
}

void
MacroAssembler::rotateLeft64(Register shift, Register64 src, Register64 dest, Register temp)
{
    MOZ_ASSERT(temp != src.low && temp != src.high);
    MOZ_ASSERT(shift != src.low && shift != src.high);
    MOZ_ASSERT(temp != InvalidReg);

    ScratchRegisterScope shift_value(*this);
    Label high, done, zero;

    ma_and(temp, shift, Imm32(0x3f));
    ma_b(temp, Imm32(32), &high, GreaterThanOrEqual);

    // high = high << shift | low >> 32 - shift
    // low = low << shift | high >> 32 - shift
    ma_sll(dest.high, src.high, temp);
    ma_b(temp, Imm32(0), &zero, Equal);
    ma_li(SecondScratchReg, Imm32(32));
    as_subu(shift_value, SecondScratchReg, temp);

    ma_srl(SecondScratchReg, src.low, shift_value);
    as_or(dest.high, dest.high, SecondScratchReg);

    ma_sll(dest.low, src.low, temp);
    ma_srl(SecondScratchReg, src.high, shift_value);
    as_or(dest.low, dest.low, SecondScratchReg);
    ma_b(&done);

    bind(&zero);
    ma_move(dest.low, src.low);
    ma_move(dest.high, src.high);
    ma_b(&done);

    // A 32 - 64 shift is a 0 - 32 shift in the other direction.
    bind(&high);
    ma_and(shift, shift, Imm32(0x3f));
    ma_li(SecondScratchReg, Imm32(64));
    as_subu(temp, SecondScratchReg, shift);

    ma_srl(dest.high, src.high, temp);
    ma_li(SecondScratchReg, Imm32(32));
    as_subu(shift_value, SecondScratchReg, temp);
    ma_sll(SecondScratchReg, src.low, shift_value);
    as_or(dest.high, dest.high, SecondScratchReg);

    ma_srl(dest.low, src.low, temp);
    ma_sll(SecondScratchReg, src.high, shift_value);
    as_or(dest.low, dest.low, SecondScratchReg);

    bind(&done);
}

void
MacroAssembler::rotateRight64(Imm32 count, Register64 input, Register64 dest, Register temp)
{
    MOZ_ASSERT(temp == InvalidReg);
    MOZ_ASSERT(input.low != dest.high && input.high != dest.low);

    int32_t amount = count.value & 0x3f;
    if (amount > 32) {
        rotateLeft64(Imm32(64 - amount), input, dest, temp);
    } else {
        ScratchRegisterScope scratch(*this);
        if (amount == 0) {
            ma_move(dest.low, input.low);
            ma_move(dest.high, input.high);
        } else if (amount == 32) {
            ma_move(scratch, input.low);
            ma_move(dest.low, input.high);
            ma_move(dest.high, scratch);
        } else {
            MOZ_ASSERT(0 < amount && amount < 32);
            ma_move(scratch, input.high);
            ma_srl(dest.high, input.high, Imm32(amount));
            ma_sll(SecondScratchReg, input.low, Imm32(32 - amount));
            as_or(dest.high, dest.high, SecondScratchReg);
            ma_srl(dest.low, input.low, Imm32(amount));
            ma_sll(SecondScratchReg, scratch, Imm32(32 - amount));
            as_or(dest.low, dest.low, SecondScratchReg);
        }
    }
}

void
MacroAssembler::rotateRight64(Register shift, Register64 src, Register64 dest, Register temp)
{
    MOZ_ASSERT(temp != src.low && temp != src.high);
    MOZ_ASSERT(shift != src.low && shift != src.high);
    MOZ_ASSERT(temp != InvalidReg);

    ScratchRegisterScope shift_value(*this);
    Label high, done, zero;

    ma_and(temp, shift, Imm32(0x3f));
    ma_b(temp, Imm32(32), &high, GreaterThanOrEqual);

    // high = high >> shift | low << 32 - shift
    // low = low >> shift | high << 32 - shift
    ma_srl(dest.high, src.high, temp);
    ma_b(temp, Imm32(0), &zero, Equal);
    ma_li(SecondScratchReg, Imm32(32));
    as_subu(shift_value, SecondScratchReg, temp);

    ma_sll(SecondScratchReg, src.low, shift_value);
    as_or(dest.high, dest.high, SecondScratchReg);

    ma_srl(dest.low, src.low, temp);

    //ma_li(SecondScratchReg, Imm32(32));
    //as_subu(shift_value, SecondScratchReg, shift_value);
    ma_sll(SecondScratchReg, src.high, shift_value);
    as_or(dest.low, dest.low, SecondScratchReg);

    ma_b(&done);

    bind(&zero);
    ma_move(dest.low, src.low);
    ma_move(dest.high, src.high);
    ma_b(&done);

    // A 32 - 64 shift is a 0 - 32 shift in the other direction.
    bind(&high);
    ma_and(shift, shift, Imm32(0x3f));
    ma_li(SecondScratchReg, Imm32(64));
    as_subu(temp, SecondScratchReg, shift);

    ma_sll(dest.high, src.high, temp);
    ma_li(SecondScratchReg, Imm32(32));
    as_subu(shift_value, SecondScratchReg, temp);

    ma_srl(SecondScratchReg, src.low, shift_value);
    as_or(dest.high, dest.high, SecondScratchReg);

    ma_sll(dest.low, src.low, temp);
    ma_srl(SecondScratchReg, src.high, shift_value);
    as_or(dest.low, dest.low, SecondScratchReg);

    bind(&done);
}

template <typename T1, typename T2>
void
MacroAssembler::cmpPtrSet(Condition cond, T1 lhs, T2 rhs, Register dest)
{
    ma_cmp_set(dest, lhs, rhs, cond);
}

template <typename T1, typename T2>
void
MacroAssembler::cmp32Set(Condition cond, T1 lhs, T2 rhs, Register dest)
{
    ma_cmp_set(dest, lhs, rhs, cond);
}

// ===============================================================
// Bit counting functions

void
MacroAssembler::clz64(Register64 src, Register dest)
{
    Label done, low;

    ma_b(src.high, Imm32(0), &low, Equal);
    as_clz(dest, src.high);
    ma_b(&done);

    bind(&low);
    as_clz(dest, src.low);
    ma_addu(dest, Imm32(32));

    bind(&done);
}

void
MacroAssembler::ctz64(Register64 src, Register dest)
{
    Label done, high;

    ma_b(src.low, Imm32(0), &high, Equal);

    ma_ctz(dest, src.low);
    ma_b(&done);

    bind(&high);
    ma_ctz(dest, src.high);
    ma_addu(dest, Imm32(32));

    bind(&done);
}

void
MacroAssembler::popcnt64(Register64 src, Register64 dest, Register tmp)
{
    MOZ_ASSERT(dest.low != tmp);
    MOZ_ASSERT(dest.high != tmp);
    MOZ_ASSERT(dest.low != dest.high);

    if (dest.low != src.high) {
        popcnt32(src.low, dest.low, tmp);
        popcnt32(src.high, dest.high, tmp);
    } else {
        MOZ_ASSERT(dest.high != src.high);
        popcnt32(src.low, dest.high, tmp);
        popcnt32(src.high, dest.low, tmp);
    }

    ma_addu(dest.low, dest.high);
    move32(Imm32(0), dest.high);
}

// ===============================================================
// Branch functions

void
MacroAssembler::branch64(Condition cond, const Address& lhs, Imm64 val, Label* label)
{
    MOZ_ASSERT(cond == Assembler::NotEqual,
               "other condition codes not supported");

    branch32(cond, lhs, val.firstHalf(), label);
    branch32(cond, Address(lhs.base, lhs.offset + sizeof(uint32_t)), val.secondHalf(), label);
}

void
MacroAssembler::branch64(Condition cond, const Address& lhs, const Address& rhs, Register scratch,
                         Label* label)
{
    MOZ_ASSERT(cond == Assembler::NotEqual,
               "other condition codes not supported");
    MOZ_ASSERT(lhs.base != scratch);
    MOZ_ASSERT(rhs.base != scratch);

    load32(rhs, scratch);
    branch32(cond, lhs, scratch, label);

    load32(Address(rhs.base, rhs.offset + sizeof(uint32_t)), scratch);
    branch32(cond, Address(lhs.base, lhs.offset + sizeof(uint32_t)), scratch, label);
}

void
MacroAssembler::branch64(Condition cond, Register64 lhs, Imm64 val, Label* success, Label* fail)
{
    bool fallthrough = false;
    Label fallthroughLabel;

    if (!fail) {
        fail = &fallthroughLabel;
        fallthrough = true;
    }

    switch(cond) {
      case Assembler::Equal:
        branch32(Assembler::NotEqual, lhs.low, val.low(), fail);
        branch32(Assembler::Equal, lhs.high, val.hi(), success);
        if (!fallthrough)
            jump(fail);
        break;
      case Assembler::NotEqual:
        branch32(Assembler::NotEqual, lhs.low, val.low(), success);
        branch32(Assembler::NotEqual, lhs.high, val.hi(), success);
        if (!fallthrough)
            jump(fail);
        break;
      case Assembler::LessThan:
      case Assembler::LessThanOrEqual:
      case Assembler::GreaterThan:
      case Assembler::GreaterThanOrEqual:
      case Assembler::Below:
      case Assembler::BelowOrEqual:
      case Assembler::Above:
      case Assembler::AboveOrEqual: {
        Assembler::Condition invert_cond = Assembler::InvertCondition(cond);
        Assembler::Condition cond1 = Assembler::ConditionWithoutEqual(cond);
        Assembler::Condition cond2 = Assembler::ConditionWithoutEqual(invert_cond);
        Assembler::Condition cond3 = Assembler::UnsignedCondition(cond);

        ma_b(lhs.high, val.hi(), success, cond1);
        ma_b(lhs.high, val.hi(), fail, cond2);
        ma_b(lhs.low, val.low(), success, cond3);
        if (!fallthrough)
            jump(fail);
        break;
      }
      default:
        MOZ_CRASH("Condition code not supported");
        break;
    }

    if (fallthrough)
        bind(fail);
}

void
MacroAssembler::branch64(Condition cond, Register64 lhs, Register64 rhs, Label* success, Label* fail)
{
    bool fallthrough = false;
    Label fallthroughLabel;

    if (!fail) {
        fail = &fallthroughLabel;
        fallthrough = true;
    }

    switch(cond) {
      case Assembler::Equal:
        branch32(Assembler::NotEqual, lhs.low, rhs.low, fail);
        branch32(Assembler::Equal, lhs.high, rhs.high, success);
        if (!fallthrough)
            jump(fail);
        break;
      case Assembler::NotEqual:
        branch32(Assembler::NotEqual, lhs.low, rhs.low, success);
        branch32(Assembler::NotEqual, lhs.high, rhs.high, success);
        if (!fallthrough)
            jump(fail);
        break;
      case Assembler::LessThan:
      case Assembler::LessThanOrEqual:
      case Assembler::GreaterThan:
      case Assembler::GreaterThanOrEqual:
      case Assembler::Below:
      case Assembler::BelowOrEqual:
      case Assembler::Above:
      case Assembler::AboveOrEqual: {
        Assembler::Condition invert_cond = Assembler::InvertCondition(cond);
        Assembler::Condition cond1 = Assembler::ConditionWithoutEqual(cond);
        Assembler::Condition cond2 = Assembler::ConditionWithoutEqual(invert_cond);
        Assembler::Condition cond3 = Assembler::UnsignedCondition(cond);

        ma_b(lhs.high, rhs.high, success, cond1);
        ma_b(lhs.high, rhs.high, fail, cond2);
        ma_b(lhs.low, rhs.low, success, cond3);
        if (!fallthrough)
            jump(fail);
        break;
      }
      default:
        MOZ_CRASH("Condition code not supported");
        break;
    }

    if (fallthrough)
        bind(fail);
}

void
MacroAssembler::branchPrivatePtr(Condition cond, const Address& lhs, Register rhs, Label* label)
{
    branchPtr(cond, lhs, rhs, label);
}

template <class L>
void
MacroAssembler::branchTest64(Condition cond, Register64 lhs, Register64 rhs, Register temp,
                             L label)
{
    if (cond == Assembler::Zero) {
        MOZ_ASSERT(lhs.low == rhs.low);
        MOZ_ASSERT(lhs.high == rhs.high);
        as_or(ScratchRegister, lhs.low, lhs.high);
        branchTestPtr(cond, ScratchRegister, ScratchRegister, label);
    } else {
        MOZ_CRASH("Unsupported condition");
    }
}

void
MacroAssembler::branchTestUndefined(Condition cond, const ValueOperand& value, Label* label)
{
    branchTestUndefined(cond, value.typeReg(), label);
}

void
MacroAssembler::branchTestInt32(Condition cond, const ValueOperand& value, Label* label)
{
    branchTestInt32(cond, value.typeReg(), label);
}

void
MacroAssembler::branchTestInt32Truthy(bool b, const ValueOperand& value, Label* label)
{
    ScratchRegisterScope scratch(*this);
    as_and(scratch, value.payloadReg(), value.payloadReg());
    ma_b(scratch, scratch, label, b ? NonZero : Zero);
}

void
MacroAssembler::branchTestDouble(Condition cond, Register tag, Label* label)
{
    MOZ_ASSERT(cond == Equal || cond == NotEqual);
    Condition actual = (cond == Equal) ? Below : AboveOrEqual;
    ma_b(tag, ImmTag(JSVAL_TAG_CLEAR), label, actual);
}

void
MacroAssembler::branchTestDouble(Condition cond, const ValueOperand& value, Label* label)
{
    branchTestDouble(cond, value.typeReg(), label);
}

void
MacroAssembler::branchTestNumber(Condition cond, const ValueOperand& value, Label* label)
{
    branchTestNumber(cond, value.typeReg(), label);
}

void
MacroAssembler::branchTestBoolean(Condition cond, const ValueOperand& value, Label* label)
{
    MOZ_ASSERT(cond == Equal || cond == NotEqual);
    ma_b(value.typeReg(), ImmType(JSVAL_TYPE_BOOLEAN), label, cond);
}

void
MacroAssembler::branchTestBooleanTruthy(bool b, const ValueOperand& value, Label* label)
{
    ma_b(value.payloadReg(), value.payloadReg(), label, b ? NonZero : Zero);
}

void
MacroAssembler::branchTestString(Condition cond, const ValueOperand& value, Label* label)
{
    branchTestString(cond, value.typeReg(), label);
}

void
MacroAssembler::branchTestStringTruthy(bool b, const ValueOperand& value, Label* label)
{
    Register string = value.payloadReg();
    SecondScratchRegisterScope scratch2(*this);
    ma_lw(scratch2, Address(string, JSString::offsetOfLength()));
    ma_b(scratch2, Imm32(0), label, b ? NotEqual : Equal);
}

void
MacroAssembler::branchTestSymbol(Condition cond, const ValueOperand& value, Label* label)
{
    branchTestSymbol(cond, value.typeReg(), label);
}

void
MacroAssembler::branchTestNull(Condition cond, const ValueOperand& value, Label* label)
{
    branchTestNull(cond, value.typeReg(), label);
}

void
MacroAssembler::branchTestObject(Condition cond, const ValueOperand& value, Label* label)
{
    branchTestObject(cond, value.typeReg(), label);
}

void
MacroAssembler::branchTestPrimitive(Condition cond, const ValueOperand& value, Label* label)
{
    branchTestPrimitive(cond, value.typeReg(), label);
}

template <class L>
void
MacroAssembler::branchTestMagic(Condition cond, const ValueOperand& value, L label)
{
    ma_b(value.typeReg(), ImmTag(JSVAL_TAG_MAGIC), label, cond);
}

void
MacroAssembler::branchTestMagic(Condition cond, const Address& valaddr, JSWhyMagic why, Label* label)
{
    branchTestMagic(cond, valaddr, label);
    branch32(cond, ToPayload(valaddr), Imm32(why), label);
}

// ========================================================================
// Memory access primitives.
void
MacroAssembler::storeUncanonicalizedDouble(FloatRegister src, const Address& addr)
{
    ma_sd(src, addr);
}
void
MacroAssembler::storeUncanonicalizedDouble(FloatRegister src, const BaseIndex& addr)
{
    MOZ_ASSERT(addr.offset == 0);
    ma_sd(src, addr);
}

void
MacroAssembler::storeUncanonicalizedFloat32(FloatRegister src, const Address& addr)
{
    ma_ss(src, addr);
}
void
MacroAssembler::storeUncanonicalizedFloat32(FloatRegister src, const BaseIndex& addr)
{
    MOZ_ASSERT(addr.offset == 0);
    ma_ss(src, addr);
}

// ========================================================================
// wasm support

template <class L>
void
MacroAssembler::wasmBoundsCheck(Condition cond, Register index, L label)
{
    BufferOffset bo = ma_BoundsCheck(ScratchRegister);
    append(wasm::BoundsCheck(bo.getOffset()));

    ma_b(index, ScratchRegister, label, cond);
}

void
MacroAssembler::wasmPatchBoundsCheck(uint8_t* patchAt, uint32_t limit)
{
    Instruction* inst = (Instruction*) patchAt;
    InstImm* i0 = (InstImm*) inst;
    InstImm* i1 = (InstImm*) i0->next();

    // Replace with new value
    Assembler::UpdateLuiOriValue(i0, i1, limit);
}

//}}} check_macroassembler_style
// ===============================================================

void
MacroAssemblerMIPSCompat::incrementInt32Value(const Address& addr)
{
    asMasm().add32(Imm32(1), ToPayload(addr));
}

void
MacroAssemblerMIPSCompat::computeEffectiveAddress(const BaseIndex& address, Register dest)
{
    computeScaledAddress(address, dest);
    if (address.offset)
        asMasm().addPtr(Imm32(address.offset), dest);
}

void
MacroAssemblerMIPSCompat::retn(Imm32 n) {
    // pc <- [sp]; sp += n
    loadPtr(Address(StackPointer, 0), ra);
    asMasm().addPtr(n, StackPointer);
    as_jr(ra);
    as_nop();
}

} // namespace jit
} // namespace js

#endif /* jit_mips32_MacroAssembler_mips32_inl_h */
