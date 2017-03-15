/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "jit/mips-shared/CodeGenerator-mips-shared.h"

#include "mozilla/DebugOnly.h"
#include "mozilla/MathAlgorithms.h"

#include "jscntxt.h"
#include "jscompartment.h"
#include "jsnum.h"

#include "jit/CodeGenerator.h"
#include "jit/JitCompartment.h"
#include "jit/JitFrames.h"
#include "jit/MIR.h"
#include "jit/MIRGraph.h"
#include "js/Conversions.h"
#include "vm/Shape.h"
#include "vm/TraceLogging.h"

#include "jsscriptinlines.h"

#include "jit/MacroAssembler-inl.h"
#include "jit/shared/CodeGenerator-shared-inl.h"

using namespace js;
using namespace js::jit;

using mozilla::DebugOnly;
using mozilla::FloorLog2;
using mozilla::NegativeInfinity;
using JS::GenericNaN;
using JS::ToInt32;

// shared
CodeGeneratorMIPSShared::CodeGeneratorMIPSShared(MIRGenerator* gen, LIRGraph* graph, MacroAssembler* masm)
  : CodeGeneratorShared(gen, graph, masm)
{
}

Operand
CodeGeneratorMIPSShared::ToOperand(const LAllocation& a)
{
    if (a.isGeneralReg())
        return Operand(a.toGeneralReg()->reg());
    if (a.isFloatReg())
        return Operand(a.toFloatReg()->reg());
    return Operand(masm.getStackPointer(), ToStackOffset(&a));
}

Operand
CodeGeneratorMIPSShared::ToOperand(const LAllocation* a)
{
    return ToOperand(*a);
}

Operand
CodeGeneratorMIPSShared::ToOperand(const LDefinition* def)
{
    return ToOperand(def->output());
}

#ifdef JS_PUNBOX64
Operand
CodeGeneratorMIPSShared::ToOperandOrRegister64(const LInt64Allocation input)
{
    return ToOperand(input.value());
}
#else
Register64
CodeGeneratorMIPSShared::ToOperandOrRegister64(const LInt64Allocation input)
{
    return ToRegister64(input);
}
#endif

void
CodeGeneratorMIPSShared::branchToBlock(Assembler::FloatFormat fmt, FloatRegister lhs, FloatRegister rhs,
                                       MBasicBlock* mir, Assembler::DoubleCondition cond)
{
    // Skip past trivial blocks.
    mir = skipTrivialBlocks(mir);

    Label* label = mir->lir()->label();
    if (Label* oolEntry = labelForBackedgeWithImplicitCheck(mir)) {
        // Note: the backedge is initially a jump to the next instruction.
        // It will be patched to the target block's label during link().
        RepatchLabel rejoin;

        CodeOffsetJump backedge;
        Label skip;
        if (fmt == Assembler::DoubleFloat)
            masm.ma_bc1d(lhs, rhs, &skip, Assembler::InvertCondition(cond), ShortJump);
        else
            masm.ma_bc1s(lhs, rhs, &skip, Assembler::InvertCondition(cond), ShortJump);

        backedge = masm.backedgeJump(&rejoin);
        masm.bind(&rejoin);
        masm.bind(&skip);

        if (!patchableBackedges_.append(PatchableBackedgeInfo(backedge, label, oolEntry)))
            MOZ_CRASH();
    } else {
        if (fmt == Assembler::DoubleFloat)
            masm.branchDouble(cond, lhs, rhs, mir->lir()->label());
        else
            masm.branchFloat(cond, lhs, rhs, mir->lir()->label());
    }
}

void
OutOfLineBailout::accept(CodeGeneratorMIPSShared* codegen)
{
    codegen->visitOutOfLineBailout(this);
}

void
CodeGeneratorMIPSShared::visitTestIAndBranch(LTestIAndBranch* test)
{
    const LAllocation* opd = test->getOperand(0);
    MBasicBlock* ifTrue = test->ifTrue();
    MBasicBlock* ifFalse = test->ifFalse();

    emitBranch(ToRegister(opd), Imm32(0), Assembler::NonZero, ifTrue, ifFalse);
}

void
CodeGeneratorMIPSShared::visitCompare(LCompare* comp)
{
    MCompare* mir = comp->mir();
    Assembler::Condition cond = JSOpToCondition(mir->compareType(), comp->jsop());
    const LAllocation* left = comp->getOperand(0);
    const LAllocation* right = comp->getOperand(1);
    const LDefinition* def = comp->getDef(0);

#ifdef JS_CODEGEN_MIPS64
    if (mir->compareType() == MCompare::Compare_Object) {
        if (right->isGeneralReg())
            masm.cmpPtrSet(cond, ToRegister(left), ToRegister(right), ToRegister(def));
        else
            masm.cmpPtrSet(cond, ToRegister(left), ToAddress(right), ToRegister(def));
        return;
    }
#endif

    if (right->isConstant())
        masm.cmp32Set(cond, ToRegister(left), Imm32(ToInt32(right)), ToRegister(def));
    else if (right->isGeneralReg())
        masm.cmp32Set(cond, ToRegister(left), ToRegister(right), ToRegister(def));
    else
        masm.cmp32Set(cond, ToRegister(left), ToAddress(right), ToRegister(def));
}

void
CodeGeneratorMIPSShared::visitCompareAndBranch(LCompareAndBranch* comp)
{
    MCompare* mir = comp->cmpMir();
    Assembler::Condition cond = JSOpToCondition(mir->compareType(), comp->jsop());

#ifdef JS_CODEGEN_MIPS64
    if (mir->compareType() == MCompare::Compare_Object) {
        if (comp->right()->isGeneralReg()) {
            emitBranch(ToRegister(comp->left()), ToRegister(comp->right()), cond,
                       comp->ifTrue(), comp->ifFalse());
        } else {
            masm.loadPtr(ToAddress(comp->right()), ScratchRegister);
            emitBranch(ToRegister(comp->left()), ScratchRegister, cond,
                       comp->ifTrue(), comp->ifFalse());
        }
        return;
    }
#endif

    if (comp->right()->isConstant()) {
        emitBranch(ToRegister(comp->left()), Imm32(ToInt32(comp->right())), cond,
                   comp->ifTrue(), comp->ifFalse());
    } else if (comp->right()->isGeneralReg()) {
        emitBranch(ToRegister(comp->left()), ToRegister(comp->right()), cond,
                   comp->ifTrue(), comp->ifFalse());
    } else {
        masm.load32(ToAddress(comp->right()), ScratchRegister);
        emitBranch(ToRegister(comp->left()), ScratchRegister, cond,
                   comp->ifTrue(), comp->ifFalse());
    }
}

bool
CodeGeneratorMIPSShared::generateOutOfLineCode()
{
    if (!CodeGeneratorShared::generateOutOfLineCode())
        return false;

    if (deoptLabel_.used()) {
        // All non-table-based bailouts will go here.
        masm.bind(&deoptLabel_);

        // Push the frame size, so the handler can recover the IonScript.
        // Frame size is stored in 'ra' and pushed by GenerateBailoutThunk
        // We have to use 'ra' because generateBailoutTable will implicitly do
        // the same.
        masm.move32(Imm32(frameSize()), ra);

        JitCode* handler = gen->jitRuntime()->getGenericBailoutHandler();

        masm.branch(handler);
    }

    return !masm.oom();
}

void
CodeGeneratorMIPSShared::bailoutFrom(Label* label, LSnapshot* snapshot)
{
    if (masm.bailed())
        return;

    MOZ_ASSERT_IF(!masm.oom(), label->used());
    MOZ_ASSERT_IF(!masm.oom(), !label->bound());

    encode(snapshot);

    // Though the assembler doesn't track all frame pushes, at least make sure
    // the known value makes sense. We can't use bailout tables if the stack
    // isn't properly aligned to the static frame size.
    MOZ_ASSERT_IF(frameClass_ != FrameSizeClass::None(),
                  frameClass_.frameSize() == masm.framePushed());

    // We don't use table bailouts because retargeting is easier this way.
    InlineScriptTree* tree = snapshot->mir()->block()->trackedTree();
    OutOfLineBailout* ool = new(alloc()) OutOfLineBailout(snapshot, masm.framePushed());
    addOutOfLineCode(ool, new(alloc()) BytecodeSite(tree, tree->script()->code()));

    masm.retarget(label, ool->entry());
}

void
CodeGeneratorMIPSShared::bailout(LSnapshot* snapshot)
{
    Label label;
    masm.jump(&label);
    bailoutFrom(&label, snapshot);
}

void
CodeGeneratorMIPSShared::visitMinMaxD(LMinMaxD* ins)
{
    FloatRegister first = ToFloatRegister(ins->first());
    FloatRegister second = ToFloatRegister(ins->second());

    MOZ_ASSERT(first == ToFloatRegister(ins->output()));

    if (ins->mir()->isMax())
        masm.maxDouble(second, first, true);
    else
        masm.minDouble(second, first, true);
}

void
CodeGeneratorMIPSShared::visitMinMaxF(LMinMaxF* ins)
{
    FloatRegister first = ToFloatRegister(ins->first());
    FloatRegister second = ToFloatRegister(ins->second());

    MOZ_ASSERT(first == ToFloatRegister(ins->output()));

    if (ins->mir()->isMax())
        masm.maxFloat32(second, first, true);
    else
        masm.minFloat32(second, first, true);
}

void
CodeGeneratorMIPSShared::visitAbsD(LAbsD* ins)
{
    FloatRegister input = ToFloatRegister(ins->input());
    MOZ_ASSERT(input == ToFloatRegister(ins->output()));
    masm.as_absd(input, input);
}

void
CodeGeneratorMIPSShared::visitAbsF(LAbsF* ins)
{
    FloatRegister input = ToFloatRegister(ins->input());
    MOZ_ASSERT(input == ToFloatRegister(ins->output()));
    masm.as_abss(input, input);
}

void
CodeGeneratorMIPSShared::visitSqrtD(LSqrtD* ins)
{
    FloatRegister input = ToFloatRegister(ins->input());
    FloatRegister output = ToFloatRegister(ins->output());
    masm.as_sqrtd(output, input);
}

void
CodeGeneratorMIPSShared::visitSqrtF(LSqrtF* ins)
{
    FloatRegister input = ToFloatRegister(ins->input());
    FloatRegister output = ToFloatRegister(ins->output());
    masm.as_sqrts(output, input);
}

void
CodeGeneratorMIPSShared::visitAddI(LAddI* ins)
{
    const LAllocation* lhs = ins->getOperand(0);
    const LAllocation* rhs = ins->getOperand(1);
    const LDefinition* dest = ins->getDef(0);

    MOZ_ASSERT(rhs->isConstant() || rhs->isGeneralReg());

    // If there is no snapshot, we don't need to check for overflow
    if (!ins->snapshot()) {
        if (rhs->isConstant())
            masm.ma_addu(ToRegister(dest), ToRegister(lhs), Imm32(ToInt32(rhs)));
        else
            masm.as_addu(ToRegister(dest), ToRegister(lhs), ToRegister(rhs));
        return;
    }

    Label overflow;
    if (rhs->isConstant())
        masm.ma_addTestOverflow(ToRegister(dest), ToRegister(lhs), Imm32(ToInt32(rhs)), &overflow);
    else
        masm.ma_addTestOverflow(ToRegister(dest), ToRegister(lhs), ToRegister(rhs), &overflow);

    bailoutFrom(&overflow, ins->snapshot());
}

void
CodeGeneratorMIPSShared::visitAddI64(LAddI64* lir)
{
    const LInt64Allocation lhs = lir->getInt64Operand(LAddI64::Lhs);
    const LInt64Allocation rhs = lir->getInt64Operand(LAddI64::Rhs);

    MOZ_ASSERT(ToOutRegister64(lir) == ToRegister64(lhs));

    if (IsConstant(rhs)) {
        masm.add64(Imm64(ToInt64(rhs)), ToRegister64(lhs));
        return;
    }

    masm.add64(ToOperandOrRegister64(rhs), ToRegister64(lhs));
}

void
CodeGeneratorMIPSShared::visitSubI(LSubI* ins)
{
    const LAllocation* lhs = ins->getOperand(0);
    const LAllocation* rhs = ins->getOperand(1);
    const LDefinition* dest = ins->getDef(0);

    MOZ_ASSERT(rhs->isConstant() || rhs->isGeneralReg());

    // If there is no snapshot, we don't need to check for overflow
    if (!ins->snapshot()) {
        if (rhs->isConstant())
            masm.ma_subu(ToRegister(dest), ToRegister(lhs), Imm32(ToInt32(rhs)));
        else
            masm.as_subu(ToRegister(dest), ToRegister(lhs), ToRegister(rhs));
        return;
    }

    Label overflow;
    if (rhs->isConstant())
        masm.ma_subTestOverflow(ToRegister(dest), ToRegister(lhs), Imm32(ToInt32(rhs)), &overflow);
    else
        masm.ma_subTestOverflow(ToRegister(dest), ToRegister(lhs), ToRegister(rhs), &overflow);

    bailoutFrom(&overflow, ins->snapshot());
}

void
CodeGeneratorMIPSShared::visitSubI64(LSubI64* lir)
{
    const LInt64Allocation lhs = lir->getInt64Operand(LSubI64::Lhs);
    const LInt64Allocation rhs = lir->getInt64Operand(LSubI64::Rhs);

    MOZ_ASSERT(ToOutRegister64(lir) == ToRegister64(lhs));

    if (IsConstant(rhs)) {
        masm.sub64(Imm64(ToInt64(rhs)), ToRegister64(lhs));
        return;
    }

    masm.sub64(ToOperandOrRegister64(rhs), ToRegister64(lhs));
}

void
CodeGeneratorMIPSShared::visitMulI(LMulI* ins)
{
    const LAllocation* lhs = ins->lhs();
    const LAllocation* rhs = ins->rhs();
    Register dest = ToRegister(ins->output());
    MMul* mul = ins->mir();

    MOZ_ASSERT_IF(mul->mode() == MMul::Integer, !mul->canBeNegativeZero() && !mul->canOverflow());

    if (rhs->isConstant()) {
        int32_t constant = ToInt32(rhs);
        Register src = ToRegister(lhs);

        // Bailout on -0.0
        if (mul->canBeNegativeZero() && constant <= 0) {
            Assembler::Condition cond = (constant == 0) ? Assembler::LessThan : Assembler::Equal;
            bailoutCmp32(cond, src, Imm32(0), ins->snapshot());
        }

        switch (constant) {
          case -1:
            if (mul->canOverflow())
                bailoutCmp32(Assembler::Equal, src, Imm32(INT32_MIN), ins->snapshot());

            masm.ma_negu(dest, src);
            break;
          case 0:
            masm.move32(Imm32(0), dest);
            break;
          case 1:
            masm.move32(src, dest);
            break;
          case 2:
            if (mul->canOverflow()) {
                Label mulTwoOverflow;
                masm.ma_addTestOverflow(dest, src, src, &mulTwoOverflow);

                bailoutFrom(&mulTwoOverflow, ins->snapshot());
            } else {
                masm.as_addu(dest, src, src);
            }
            break;
          default:
            uint32_t shift = FloorLog2(constant);

            if (!mul->canOverflow() && (constant > 0)) {
                // If it cannot overflow, we can do lots of optimizations.
                uint32_t rest = constant - (1 << shift);

                // See if the constant has one bit set, meaning it can be
                // encoded as a bitshift.
                if ((1 << shift) == constant) {
                    masm.ma_sll(dest, src, Imm32(shift));
                    return;
                }

                // If the constant cannot be encoded as (1<<C1), see if it can
                // be encoded as (1<<C1) | (1<<C2), which can be computed
                // using an add and a shift.
                uint32_t shift_rest = FloorLog2(rest);
                if (src != dest && (1u << shift_rest) == rest) {
                    masm.ma_sll(dest, src, Imm32(shift - shift_rest));
                    masm.add32(src, dest);
                    if (shift_rest != 0)
                        masm.ma_sll(dest, dest, Imm32(shift_rest));
                    return;
                }
            }

            if (mul->canOverflow() && (constant > 0) && (src != dest)) {
                // To stay on the safe side, only optimize things that are a
                // power of 2.

                if ((1 << shift) == constant) {
                    // dest = lhs * pow(2, shift)
                    masm.ma_sll(dest, src, Imm32(shift));
                    // At runtime, check (lhs == dest >> shift), if this does
                    // not hold, some bits were lost due to overflow, and the
                    // computation should be resumed as a double.
                    masm.ma_sra(ScratchRegister, dest, Imm32(shift));
                    bailoutCmp32(Assembler::NotEqual, src, ScratchRegister, ins->snapshot());
                    return;
                }
            }

            if (mul->canOverflow()) {
                Label mulConstOverflow;
                masm.ma_mul_branch_overflow(dest, ToRegister(lhs), Imm32(ToInt32(rhs)),
                                            &mulConstOverflow);

                bailoutFrom(&mulConstOverflow, ins->snapshot());
            } else {
                masm.ma_mul(dest, src, Imm32(ToInt32(rhs)));
            }
            break;
        }
    } else {
        Label multRegOverflow;

        if (mul->canOverflow()) {
            masm.ma_mul_branch_overflow(dest, ToRegister(lhs), ToRegister(rhs), &multRegOverflow);
            bailoutFrom(&multRegOverflow, ins->snapshot());
        } else {
            masm.as_mul(dest, ToRegister(lhs), ToRegister(rhs));
        }

        if (mul->canBeNegativeZero()) {
            Label done;
            masm.ma_b(dest, dest, &done, Assembler::NonZero, ShortJump);

            // Result is -0 if lhs or rhs is negative.
            // In that case result must be double value so bailout
            Register scratch = SecondScratchReg;
            masm.as_or(scratch, ToRegister(lhs), ToRegister(rhs));
            bailoutCmp32(Assembler::Signed, scratch, scratch, ins->snapshot());

            masm.bind(&done);
        }
    }
}

void
CodeGeneratorMIPSShared::visitMulI64(LMulI64* lir)
{
    const LInt64Allocation lhs = lir->getInt64Operand(LMulI64::Lhs);
    const LInt64Allocation rhs = lir->getInt64Operand(LMulI64::Rhs);

    MOZ_ASSERT(ToRegister64(lhs) == ToOutRegister64(lir));

    if (IsConstant(rhs)) {
        int64_t constant = ToInt64(rhs);
        switch (constant) {
          case -1:
            masm.neg64(ToRegister64(lhs));
            return;
          case 0:
            masm.xor64(ToRegister64(lhs), ToRegister64(lhs));
            return;
          case 1:
            // nop
            return;
          case 2:
            masm.add64(ToRegister64(lhs), ToRegister64(lhs));
            return;
          default:
            if (constant > 0) {
                // Use shift if constant is power of 2.
                int32_t shift = mozilla::FloorLog2(constant);
                if (int64_t(1) << shift == constant) {
                    masm.lshift64(Imm32(shift), ToRegister64(lhs));
                    return;
                }
            }
            Register temp = ToTempRegisterOrInvalid(lir->temp());
            masm.mul64(Imm64(constant), ToRegister64(lhs), temp);
        }
    } else {
        Register temp = ToTempRegisterOrInvalid(lir->temp());
        masm.mul64(ToOperandOrRegister64(rhs), ToRegister64(lhs), temp);
    }
}

void
CodeGeneratorMIPSShared::visitDivI(LDivI* ins)
{
    // Extract the registers from this instruction
    Register lhs = ToRegister(ins->lhs());
    Register rhs = ToRegister(ins->rhs());
    Register dest = ToRegister(ins->output());
    Register temp = ToRegister(ins->getTemp(0));
    MDiv* mir = ins->mir();

    Label done;

    // Handle divide by zero.
    if (mir->canBeDivideByZero()) {
        if (mir->trapOnError()) {
            masm.ma_b(rhs, rhs, trap(mir, wasm::Trap::IntegerDivideByZero), Assembler::Zero);
        } else if (mir->canTruncateInfinities()) {
            // Truncated division by zero is zero (Infinity|0 == 0)
            Label notzero;
            masm.ma_b(rhs, rhs, &notzero, Assembler::NonZero, ShortJump);
            masm.move32(Imm32(0), dest);
            masm.ma_b(&done, ShortJump);
            masm.bind(&notzero);
        } else {
            MOZ_ASSERT(mir->fallible());
            bailoutCmp32(Assembler::Zero, rhs, rhs, ins->snapshot());
        }
    }

    // Handle an integer overflow exception from -2147483648 / -1.
    if (mir->canBeNegativeOverflow()) {
        Label notMinInt;
        masm.move32(Imm32(INT32_MIN), temp);
        masm.ma_b(lhs, temp, &notMinInt, Assembler::NotEqual, ShortJump);

        masm.move32(Imm32(-1), temp);
        if (mir->trapOnError()) {
            masm.ma_b(rhs, temp, trap(mir, wasm::Trap::IntegerOverflow), Assembler::Equal);
        } else if (mir->canTruncateOverflow()) {
            // (-INT32_MIN)|0 == INT32_MIN
            Label skip;
            masm.ma_b(rhs, temp, &skip, Assembler::NotEqual, ShortJump);
            masm.move32(Imm32(INT32_MIN), dest);
            masm.ma_b(&done, ShortJump);
            masm.bind(&skip);
        } else {
            MOZ_ASSERT(mir->fallible());
            bailoutCmp32(Assembler::Equal, rhs, temp, ins->snapshot());
        }
        masm.bind(&notMinInt);
    }

    // Handle negative 0. (0/-Y)
    if (!mir->canTruncateNegativeZero() && mir->canBeNegativeZero()) {
        Label nonzero;
        masm.ma_b(lhs, lhs, &nonzero, Assembler::NonZero, ShortJump);
        bailoutCmp32(Assembler::LessThan, rhs, Imm32(0), ins->snapshot());
        masm.bind(&nonzero);
    }
    // Note: above safety checks could not be verified as Ion seems to be
    // smarter and requires double arithmetic in such cases.

    // All regular. Lets call div.
    if (mir->canTruncateRemainder()) {
        masm.as_div(lhs, rhs);
        masm.as_mflo(dest);
    } else {
        MOZ_ASSERT(mir->fallible());

        Label remainderNonZero;
        masm.ma_div_branch_overflow(dest, lhs, rhs, &remainderNonZero);
        bailoutFrom(&remainderNonZero, ins->snapshot());
    }

    masm.bind(&done);
}

void
CodeGeneratorMIPSShared::visitDivPowTwoI(LDivPowTwoI* ins)
{
    Register lhs = ToRegister(ins->numerator());
    Register dest = ToRegister(ins->output());
    Register tmp = ToRegister(ins->getTemp(0));
    int32_t shift = ins->shift();

    if (shift != 0) {
        MDiv* mir = ins->mir();
        if (!mir->isTruncated()) {
            // If the remainder is going to be != 0, bailout since this must
            // be a double.
            masm.ma_sll(tmp, lhs, Imm32(32 - shift));
            bailoutCmp32(Assembler::NonZero, tmp, tmp, ins->snapshot());
        }

        if (!mir->canBeNegativeDividend()) {
            // Numerator is unsigned, so needs no adjusting. Do the shift.
            masm.ma_sra(dest, lhs, Imm32(shift));
            return;
        }

        // Adjust the value so that shifting produces a correctly rounded result
        // when the numerator is negative. See 10-1 "Signed Division by a Known
        // Power of 2" in Henry S. Warren, Jr.'s Hacker's Delight.
        if (shift > 1) {
            masm.ma_sra(tmp, lhs, Imm32(31));
            masm.ma_srl(tmp, tmp, Imm32(32 - shift));
            masm.add32(lhs, tmp);
        } else {
            masm.ma_srl(tmp, lhs, Imm32(32 - shift));
            masm.add32(lhs, tmp);
        }

        // Do the shift.
        masm.ma_sra(dest, tmp, Imm32(shift));
    } else {
        masm.move32(lhs, dest);
    }
}

void
CodeGeneratorMIPSShared::visitModI(LModI* ins)
{
    // Extract the registers from this instruction
    Register lhs = ToRegister(ins->lhs());
    Register rhs = ToRegister(ins->rhs());
    Register dest = ToRegister(ins->output());
    Register callTemp = ToRegister(ins->callTemp());
    MMod* mir = ins->mir();
    Label done, prevent;

    masm.move32(lhs, callTemp);

    // Prevent INT_MIN % -1;
    // The integer division will give INT_MIN, but we want -(double)INT_MIN.
    if (mir->canBeNegativeDividend()) {
        masm.ma_b(lhs, Imm32(INT_MIN), &prevent, Assembler::NotEqual, ShortJump);
        if (mir->isTruncated()) {
            // (INT_MIN % -1)|0 == 0
            Label skip;
            masm.ma_b(rhs, Imm32(-1), &skip, Assembler::NotEqual, ShortJump);
            masm.move32(Imm32(0), dest);
            masm.ma_b(&done, ShortJump);
            masm.bind(&skip);
        } else {
            MOZ_ASSERT(mir->fallible());
            bailoutCmp32(Assembler::Equal, rhs, Imm32(-1), ins->snapshot());
        }
        masm.bind(&prevent);
    }

    // 0/X (with X < 0) is bad because both of these values *should* be
    // doubles, and the result should be -0.0, which cannot be represented in
    // integers. X/0 is bad because it will give garbage (or abort), when it
    // should give either \infty, -\infty or NAN.

    // Prevent 0 / X (with X < 0) and X / 0
    // testing X / Y.  Compare Y with 0.
    // There are three cases: (Y < 0), (Y == 0) and (Y > 0)
    // If (Y < 0), then we compare X with 0, and bail if X == 0
    // If (Y == 0), then we simply want to bail.
    // if (Y > 0), we don't bail.

    if (mir->canBeDivideByZero()) {
        if (mir->isTruncated()) {
            if (mir->trapOnError()) {
                masm.ma_b(rhs, rhs, trap(mir, wasm::Trap::IntegerDivideByZero), Assembler::Zero);
            } else {
                Label skip;
                masm.ma_b(rhs, Imm32(0), &skip, Assembler::NotEqual, ShortJump);
                masm.move32(Imm32(0), dest);
                masm.ma_b(&done, ShortJump);
                masm.bind(&skip);
            }
        } else {
            MOZ_ASSERT(mir->fallible());
            bailoutCmp32(Assembler::Equal, rhs, Imm32(0), ins->snapshot());
        }
    }

    if (mir->canBeNegativeDividend()) {
        Label notNegative;
        masm.ma_b(rhs, Imm32(0), &notNegative, Assembler::GreaterThan, ShortJump);
        if (mir->isTruncated()) {
            // NaN|0 == 0 and (0 % -X)|0 == 0
            Label skip;
            masm.ma_b(lhs, Imm32(0), &skip, Assembler::NotEqual, ShortJump);
            masm.move32(Imm32(0), dest);
            masm.ma_b(&done, ShortJump);
            masm.bind(&skip);
        } else {
            MOZ_ASSERT(mir->fallible());
            bailoutCmp32(Assembler::Equal, lhs, Imm32(0), ins->snapshot());
        }
        masm.bind(&notNegative);
    }

    masm.as_div(lhs, rhs);
    masm.as_mfhi(dest);

    // If X%Y == 0 and X < 0, then we *actually* wanted to return -0.0
    if (mir->canBeNegativeDividend()) {
        if (mir->isTruncated()) {
            // -0.0|0 == 0
        } else {
            MOZ_ASSERT(mir->fallible());
            // See if X < 0
            masm.ma_b(dest, Imm32(0), &done, Assembler::NotEqual, ShortJump);
            bailoutCmp32(Assembler::Signed, callTemp, Imm32(0), ins->snapshot());
        }
    }
    masm.bind(&done);
}

void
CodeGeneratorMIPSShared::visitModPowTwoI(LModPowTwoI* ins)
{
    Register in = ToRegister(ins->getOperand(0));
    Register out = ToRegister(ins->getDef(0));
    MMod* mir = ins->mir();
    Label negative, done;

    masm.move32(in, out);
    masm.ma_b(in, in, &done, Assembler::Zero, ShortJump);
    // Switch based on sign of the lhs.
    // Positive numbers are just a bitmask
    masm.ma_b(in, in, &negative, Assembler::Signed, ShortJump);
    {
        masm.and32(Imm32((1 << ins->shift()) - 1), out);
        masm.ma_b(&done, ShortJump);
    }

    // Negative numbers need a negate, bitmask, negate
    {
        masm.bind(&negative);
        masm.neg32(out);
        masm.and32(Imm32((1 << ins->shift()) - 1), out);
        masm.neg32(out);
    }
    if (mir->canBeNegativeDividend()) {
        if (!mir->isTruncated()) {
            MOZ_ASSERT(mir->fallible());
            bailoutCmp32(Assembler::Equal, out, zero, ins->snapshot());
        } else {
            // -0|0 == 0
        }
    }
    masm.bind(&done);
}

void
CodeGeneratorMIPSShared::visitModMaskI(LModMaskI* ins)
{
    Register src = ToRegister(ins->getOperand(0));
    Register dest = ToRegister(ins->getDef(0));
    Register tmp0 = ToRegister(ins->getTemp(0));
    Register tmp1 = ToRegister(ins->getTemp(1));
    MMod* mir = ins->mir();

    if (!mir->isTruncated() && mir->canBeNegativeDividend()) {
        MOZ_ASSERT(mir->fallible());

        Label bail;
        masm.ma_mod_mask(src, dest, tmp0, tmp1, ins->shift(), &bail);
        bailoutFrom(&bail, ins->snapshot());
    } else {
        masm.ma_mod_mask(src, dest, tmp0, tmp1, ins->shift(), nullptr);
    }
}

void
CodeGeneratorMIPSShared::visitBitNotI(LBitNotI* ins)
{
    const LAllocation* input = ins->getOperand(0);
    const LDefinition* dest = ins->getDef(0);
    MOZ_ASSERT(!input->isConstant());

    masm.ma_not(ToRegister(dest), ToRegister(input));
}

void
CodeGeneratorMIPSShared::visitBitOpI(LBitOpI* ins)
{
    const LAllocation* lhs = ins->getOperand(0);
    const LAllocation* rhs = ins->getOperand(1);
    const LDefinition* dest = ins->getDef(0);
    // all of these bitops should be either imm32's, or integer registers.
    switch (ins->bitop()) {
      case JSOP_BITOR:
        if (rhs->isConstant())
            masm.ma_or(ToRegister(dest), ToRegister(lhs), Imm32(ToInt32(rhs)));
        else
            masm.as_or(ToRegister(dest), ToRegister(lhs), ToRegister(rhs));
        break;
      case JSOP_BITXOR:
        if (rhs->isConstant())
            masm.ma_xor(ToRegister(dest), ToRegister(lhs), Imm32(ToInt32(rhs)));
        else
            masm.as_xor(ToRegister(dest), ToRegister(lhs), ToRegister(rhs));
        break;
      case JSOP_BITAND:
        if (rhs->isConstant())
            masm.ma_and(ToRegister(dest), ToRegister(lhs), Imm32(ToInt32(rhs)));
        else
            masm.as_and(ToRegister(dest), ToRegister(lhs), ToRegister(rhs));
        break;
      default:
        MOZ_CRASH("unexpected binary opcode");
    }
}

void
CodeGeneratorMIPSShared::visitBitOpI64(LBitOpI64* lir)
{
    const LInt64Allocation lhs = lir->getInt64Operand(LBitOpI64::Lhs);
    const LInt64Allocation rhs = lir->getInt64Operand(LBitOpI64::Rhs);

    MOZ_ASSERT(ToOutRegister64(lir) == ToRegister64(lhs));

    switch (lir->bitop()) {
      case JSOP_BITOR:
        if (IsConstant(rhs))
            masm.or64(Imm64(ToInt64(rhs)), ToRegister64(lhs));
        else
            masm.or64(ToOperandOrRegister64(rhs), ToRegister64(lhs));
        break;
      case JSOP_BITXOR:
        if (IsConstant(rhs))
            masm.xor64(Imm64(ToInt64(rhs)), ToRegister64(lhs));
        else
            masm.xor64(ToOperandOrRegister64(rhs), ToRegister64(lhs));
        break;
      case JSOP_BITAND:
        if (IsConstant(rhs))
            masm.and64(Imm64(ToInt64(rhs)), ToRegister64(lhs));
        else
            masm.and64(ToOperandOrRegister64(rhs), ToRegister64(lhs));
        break;
      default:
        MOZ_CRASH("unexpected binary opcode");
    }
}

void
CodeGeneratorMIPSShared::visitShiftI(LShiftI* ins)
{
    Register lhs = ToRegister(ins->lhs());
    const LAllocation* rhs = ins->rhs();
    Register dest = ToRegister(ins->output());

    if (rhs->isConstant()) {
        int32_t shift = ToInt32(rhs) & 0x1F;
        switch (ins->bitop()) {
          case JSOP_LSH:
            if (shift)
                masm.ma_sll(dest, lhs, Imm32(shift));
            else
                masm.move32(lhs, dest);
            break;
          case JSOP_RSH:
            if (shift)
                masm.ma_sra(dest, lhs, Imm32(shift));
            else
                masm.move32(lhs, dest);
            break;
          case JSOP_URSH:
            if (shift) {
                masm.ma_srl(dest, lhs, Imm32(shift));
            } else {
                // x >>> 0 can overflow.
                if (ins->mir()->toUrsh()->fallible())
                    bailoutCmp32(Assembler::LessThan, lhs, Imm32(0), ins->snapshot());
                masm.move32(lhs, dest);
            }
            break;
          default:
            MOZ_CRASH("Unexpected shift op");
        }
    } else {
        // The shift amounts should be AND'ed into the 0-31 range
        masm.ma_and(dest, ToRegister(rhs), Imm32(0x1F));

        switch (ins->bitop()) {
          case JSOP_LSH:
            masm.ma_sll(dest, lhs, dest);
            break;
          case JSOP_RSH:
            masm.ma_sra(dest, lhs, dest);
            break;
          case JSOP_URSH:
            masm.ma_srl(dest, lhs, dest);
            if (ins->mir()->toUrsh()->fallible()) {
                // x >>> 0 can overflow.
                bailoutCmp32(Assembler::LessThan, dest, Imm32(0), ins->snapshot());
            }
            break;
          default:
            MOZ_CRASH("Unexpected shift op");
        }
    }
}

void
CodeGeneratorMIPSShared::visitShiftI64(LShiftI64* lir)
{
    const LInt64Allocation lhs = lir->getInt64Operand(LShiftI64::Lhs);
    LAllocation* rhs = lir->getOperand(LShiftI64::Rhs);

    MOZ_ASSERT(ToOutRegister64(lir) == ToRegister64(lhs));

    if (rhs->isConstant()) {
        int32_t shift = int32_t(rhs->toConstant()->toInt64() & 0x3F);
        switch (lir->bitop()) {
          case JSOP_LSH:
            if (shift)
                masm.lshift64(Imm32(shift), ToRegister64(lhs));
            break;
          case JSOP_RSH:
            if (shift)
                masm.rshift64Arithmetic(Imm32(shift), ToRegister64(lhs));
            break;
          case JSOP_URSH:
            if (shift)
                masm.rshift64(Imm32(shift), ToRegister64(lhs));
            break;
          default:
            MOZ_CRASH("Unexpected shift op");
        }
        return;
    }

    switch (lir->bitop()) {
      case JSOP_LSH:
        masm.lshift64(ToRegister(rhs), ToRegister64(lhs));
        break;
      case JSOP_RSH:
        masm.rshift64Arithmetic(ToRegister(rhs), ToRegister64(lhs));
        break;
      case JSOP_URSH:
        masm.rshift64(ToRegister(rhs), ToRegister64(lhs));
        break;
      default:
        MOZ_CRASH("Unexpected shift op");
    }
}

void
CodeGeneratorMIPSShared::visitRotateI64(LRotateI64* lir)
{
    MRotate* mir = lir->mir();
    LAllocation* count = lir->count();

    Register64 input = ToRegister64(lir->input());
    Register64 output = ToOutRegister64(lir);
    Register temp = ToTempRegisterOrInvalid(lir->temp());

    MOZ_ASSERT(input == output);

    if (count->isConstant()) {
        int32_t c = int32_t(count->toConstant()->toInt64() & 0x3F);
        if (!c)
            return;
        if (mir->isLeftRotate())
            masm.rotateLeft64(Imm32(c), input, output, temp);
        else
            masm.rotateRight64(Imm32(c), input, output, temp);
    } else {
        if (mir->isLeftRotate())
            masm.rotateLeft64(ToRegister(count), input, output, temp);
        else
            masm.rotateRight64(ToRegister(count), input, output, temp);
    }
}

void
CodeGeneratorMIPSShared::visitUrshD(LUrshD* ins)
{
    Register lhs = ToRegister(ins->lhs());
    Register temp = ToRegister(ins->temp());

    const LAllocation* rhs = ins->rhs();
    FloatRegister out = ToFloatRegister(ins->output());

    if (rhs->isConstant()) {
        masm.ma_srl(temp, lhs, Imm32(ToInt32(rhs)));
    } else {
        masm.ma_srl(temp, lhs, ToRegister(rhs));
    }

    masm.convertUInt32ToDouble(temp, out);
}

void
CodeGeneratorMIPSShared::visitClzI(LClzI* ins)
{
    Register input = ToRegister(ins->input());
    Register output = ToRegister(ins->output());

    masm.as_clz(output, input);
}

void
CodeGeneratorMIPSShared::visitCtzI(LCtzI* ins)
{
    Register input = ToRegister(ins->input());
    Register output = ToRegister(ins->output());

    masm.ma_ctz(output, input);
}

void
CodeGeneratorMIPSShared::visitPopcntI(LPopcntI* ins)
{
    Register input = ToRegister(ins->input());
    Register output = ToRegister(ins->output());
    Register tmp = ToRegister(ins->temp());

    masm.popcnt32(input, output, tmp);
}

void
CodeGeneratorMIPSShared::visitPopcntI64(LPopcntI64* ins)
{
    Register64 input = ToRegister64(ins->getInt64Operand(0));
    Register64 output = ToOutRegister64(ins);
    Register tmp = ToRegister(ins->getTemp(0));

    masm.popcnt64(input, output, tmp);
}

void
CodeGeneratorMIPSShared::visitPowHalfD(LPowHalfD* ins)
{
    FloatRegister input = ToFloatRegister(ins->input());
    FloatRegister output = ToFloatRegister(ins->output());

    Label done, skip;

    // Masm.pow(-Infinity, 0.5) == Infinity.
    masm.loadConstantDouble(NegativeInfinity<double>(), ScratchDoubleReg);
    masm.ma_bc1d(input, ScratchDoubleReg, &skip, Assembler::DoubleNotEqualOrUnordered, ShortJump);
    masm.as_negd(output, ScratchDoubleReg);
    masm.ma_b(&done, ShortJump);

    masm.bind(&skip);
    // Math.pow(-0, 0.5) == 0 == Math.pow(0, 0.5).
    // Adding 0 converts any -0 to 0.
    masm.loadConstantDouble(0.0, ScratchDoubleReg);
    masm.as_addd(output, input, ScratchDoubleReg);
    masm.as_sqrtd(output, output);

    masm.bind(&done);
}

MoveOperand
CodeGeneratorMIPSShared::toMoveOperand(LAllocation a) const
{
    if (a.isGeneralReg())
        return MoveOperand(ToRegister(a));
    if (a.isFloatReg()) {
        return MoveOperand(ToFloatRegister(a));
    }
    int32_t offset = ToStackOffset(a);
    MOZ_ASSERT((offset & 3) == 0);

    return MoveOperand(StackPointer, offset);
}

void
CodeGeneratorMIPSShared::visitMathD(LMathD* math)
{
    FloatRegister src1 = ToFloatRegister(math->getOperand(0));
    FloatRegister src2 = ToFloatRegister(math->getOperand(1));
    FloatRegister output = ToFloatRegister(math->getDef(0));

    switch (math->jsop()) {
      case JSOP_ADD:
        masm.as_addd(output, src1, src2);
        break;
      case JSOP_SUB:
        masm.as_subd(output, src1, src2);
        break;
      case JSOP_MUL:
        masm.as_muld(output, src1, src2);
        break;
      case JSOP_DIV:
        masm.as_divd(output, src1, src2);
        break;
      default:
        MOZ_CRASH("unexpected opcode");
    }
}

void
CodeGeneratorMIPSShared::visitMathF(LMathF* math)
{
    FloatRegister src1 = ToFloatRegister(math->getOperand(0));
    FloatRegister src2 = ToFloatRegister(math->getOperand(1));
    FloatRegister output = ToFloatRegister(math->getDef(0));

    switch (math->jsop()) {
      case JSOP_ADD:
        masm.as_adds(output, src1, src2);
        break;
      case JSOP_SUB:
        masm.as_subs(output, src1, src2);
        break;
      case JSOP_MUL:
        masm.as_muls(output, src1, src2);
        break;
      case JSOP_DIV:
        masm.as_divs(output, src1, src2);
        break;
      default:
        MOZ_CRASH("unexpected opcode");
    }
}

void
CodeGeneratorMIPSShared::visitFloor(LFloor* lir)
{
    FloatRegister input = ToFloatRegister(lir->input());
    FloatRegister scratch = ScratchDoubleReg;
    Register output = ToRegister(lir->output());

    Label skipCheck, done;

    // If Nan, 0 or -0 check for bailout
    masm.loadConstantDouble(0.0, scratch);
    masm.ma_bc1d(input, scratch, &skipCheck, Assembler::DoubleNotEqual, ShortJump);

    // If high part is not zero, it is NaN or -0, so we bail.
    masm.moveFromDoubleHi(input, SecondScratchReg);
    bailoutCmp32(Assembler::NotEqual, SecondScratchReg, Imm32(0), lir->snapshot());

    // Input was zero, so return zero.
    masm.move32(Imm32(0), output);
    masm.ma_b(&done, ShortJump);

    masm.bind(&skipCheck);
    masm.as_floorwd(scratch, input);
    masm.moveFromDoubleLo(scratch, output);

    bailoutCmp32(Assembler::Equal, output, Imm32(INT_MIN), lir->snapshot());
    bailoutCmp32(Assembler::Equal, output, Imm32(INT_MAX), lir->snapshot());

    masm.bind(&done);
}

void
CodeGeneratorMIPSShared::visitFloorF(LFloorF* lir)
{
    FloatRegister input = ToFloatRegister(lir->input());
    FloatRegister scratch = ScratchFloat32Reg;
    Register output = ToRegister(lir->output());

    Label skipCheck, done;

    // If Nan, 0 or -0 check for bailout
    masm.loadConstantFloat32(0.0f, scratch);
    masm.ma_bc1s(input, scratch, &skipCheck, Assembler::DoubleNotEqual, ShortJump);

    // If binary value is not zero, it is NaN or -0, so we bail.
    masm.moveFromDoubleLo(input, SecondScratchReg);
    bailoutCmp32(Assembler::NotEqual, SecondScratchReg, Imm32(0), lir->snapshot());

    // Input was zero, so return zero.
    masm.move32(Imm32(0), output);
    masm.ma_b(&done, ShortJump);

    masm.bind(&skipCheck);
    masm.as_floorws(scratch, input);
    masm.moveFromDoubleLo(scratch, output);

    bailoutCmp32(Assembler::Equal, output, Imm32(INT_MIN), lir->snapshot());
    bailoutCmp32(Assembler::Equal, output, Imm32(INT_MAX), lir->snapshot());

    masm.bind(&done);
}

void
CodeGeneratorMIPSShared::visitCeil(LCeil* lir)
{
    FloatRegister input = ToFloatRegister(lir->input());
    FloatRegister scratch = ScratchDoubleReg;
    Register output = ToRegister(lir->output());

    Label performCeil, done;

    // If x < -1 or x > 0 then perform ceil.
    masm.loadConstantDouble(0, scratch);
    masm.branchDouble(Assembler::DoubleGreaterThan, input, scratch, &performCeil);
    masm.loadConstantDouble(-1, scratch);
    masm.branchDouble(Assembler::DoubleLessThanOrEqual, input, scratch, &performCeil);

    // If high part is not zero, the input was not 0, so we bail.
    masm.moveFromDoubleHi(input, SecondScratchReg);
    bailoutCmp32(Assembler::NotEqual, SecondScratchReg, Imm32(0), lir->snapshot());

    // Input was zero, so return zero.
    masm.move32(Imm32(0), output);
    masm.ma_b(&done, ShortJump);

    masm.bind(&performCeil);
    masm.as_ceilwd(scratch, input);
    masm.moveFromDoubleLo(scratch, output);

    bailoutCmp32(Assembler::Equal, output, Imm32(INT_MIN), lir->snapshot());
    bailoutCmp32(Assembler::Equal, output, Imm32(INT_MAX), lir->snapshot());

    masm.bind(&done);
}

void
CodeGeneratorMIPSShared::visitCeilF(LCeilF* lir)
{
    FloatRegister input = ToFloatRegister(lir->input());
    FloatRegister scratch = ScratchFloat32Reg;
    Register output = ToRegister(lir->output());

    Label performCeil, done;

    // If x < -1 or x > 0 then perform ceil.
    masm.loadConstantFloat32(0.0f, scratch);
    masm.branchFloat(Assembler::DoubleGreaterThan, input, scratch, &performCeil);
    masm.loadConstantFloat32(-1.0f, scratch);
    masm.branchFloat(Assembler::DoubleLessThanOrEqual, input, scratch, &performCeil);

    // If binary value is not zero, the input was not 0, so we bail.
    masm.moveFromFloat32(input, SecondScratchReg);
    bailoutCmp32(Assembler::NotEqual, SecondScratchReg, Imm32(0), lir->snapshot());

    // Input was zero, so return zero.
    masm.move32(Imm32(0), output);
    masm.ma_b(&done, ShortJump);

    masm.bind(&performCeil);
    masm.as_ceilws(scratch, input);
    masm.moveFromFloat32(scratch, output);

    bailoutCmp32(Assembler::Equal, output, Imm32(INT_MIN), lir->snapshot());
    bailoutCmp32(Assembler::Equal, output, Imm32(INT_MAX), lir->snapshot());

    masm.bind(&done);
}

void
CodeGeneratorMIPSShared::visitRound(LRound* lir)
{
    FloatRegister input = ToFloatRegister(lir->input());
    FloatRegister temp = ToFloatRegister(lir->temp());
    FloatRegister scratch = ScratchDoubleReg;
    Register output = ToRegister(lir->output());

    Label bail, negative, end, skipCheck;

    // Load biggest number less than 0.5 in the temp register.
    masm.loadConstantDouble(GetBiggestNumberLessThan(0.5), temp);

    // Branch to a slow path for negative inputs. Doesn't catch NaN or -0.
    masm.loadConstantDouble(0.0, scratch);
    masm.ma_bc1d(input, scratch, &negative, Assembler::DoubleLessThan, ShortJump);

    // If Nan, 0 or -0 check for bailout
    masm.ma_bc1d(input, scratch, &skipCheck, Assembler::DoubleNotEqual, ShortJump);

    // If high part is not zero, it is NaN or -0, so we bail.
    masm.moveFromDoubleHi(input, SecondScratchReg);
    bailoutCmp32(Assembler::NotEqual, SecondScratchReg, Imm32(0), lir->snapshot());

    // Input was zero, so return zero.
    masm.move32(Imm32(0), output);
    masm.ma_b(&end, ShortJump);

    masm.bind(&skipCheck);
    masm.as_addd(scratch, input, temp);
    masm.as_floorwd(scratch, scratch);

    masm.moveFromDoubleLo(scratch, output);

    bailoutCmp32(Assembler::Equal, output, Imm32(INT_MIN), lir->snapshot());
    bailoutCmp32(Assembler::Equal, output, Imm32(INT_MAX), lir->snapshot());

    masm.jump(&end);

    // Input is negative, but isn't -0.
    masm.bind(&negative);

    // Inputs in ]-0.5; 0] need to be added 0.5, other negative inputs need to
    // be added the biggest double less than 0.5.
    Label loadJoin;
    masm.loadConstantDouble(-0.5, scratch);
    masm.branchDouble(Assembler::DoubleLessThan, input, scratch, &loadJoin);
    masm.loadConstantDouble(0.5, temp);
    masm.bind(&loadJoin);

    masm.addDouble(input, temp);

    // If input + 0.5 >= 0, input is a negative number >= -0.5 and the
    // result is -0.
    masm.branchDouble(Assembler::DoubleGreaterThanOrEqual, temp, scratch, &bail);
    bailoutFrom(&bail, lir->snapshot());

    // Truncate and round toward zero.
    // This is off-by-one for everything but integer-valued inputs.
    masm.as_floorwd(scratch, temp);
    masm.moveFromDoubleLo(scratch, output);

    bailoutCmp32(Assembler::Equal, output, Imm32(INT_MIN), lir->snapshot());

    masm.bind(&end);
}

void
CodeGeneratorMIPSShared::visitRoundF(LRoundF* lir)
{
    FloatRegister input = ToFloatRegister(lir->input());
    FloatRegister temp = ToFloatRegister(lir->temp());
    FloatRegister scratch = ScratchFloat32Reg;
    Register output = ToRegister(lir->output());

    Label bail, negative, end, skipCheck;

    // Load biggest number less than 0.5 in the temp register.
    masm.loadConstantFloat32(GetBiggestNumberLessThan(0.5f), temp);

    // Branch to a slow path for negative inputs. Doesn't catch NaN or -0.
    masm.loadConstantFloat32(0.0f, scratch);
    masm.ma_bc1s(input, scratch, &negative, Assembler::DoubleLessThan, ShortJump);

    // If Nan, 0 or -0 check for bailout
    masm.ma_bc1s(input, scratch, &skipCheck, Assembler::DoubleNotEqual, ShortJump);

    // If binary value is not zero, it is NaN or -0, so we bail.
    masm.moveFromFloat32(input, SecondScratchReg);
    bailoutCmp32(Assembler::NotEqual, SecondScratchReg, Imm32(0), lir->snapshot());

    // Input was zero, so return zero.
    masm.move32(Imm32(0), output);
    masm.ma_b(&end, ShortJump);

    masm.bind(&skipCheck);
    masm.as_adds(scratch, input, temp);
    masm.as_floorws(scratch, scratch);

    masm.moveFromFloat32(scratch, output);

    bailoutCmp32(Assembler::Equal, output, Imm32(INT_MIN), lir->snapshot());
    bailoutCmp32(Assembler::Equal, output, Imm32(INT_MAX), lir->snapshot());

    masm.jump(&end);

    // Input is negative, but isn't -0.
    masm.bind(&negative);

    // Inputs in ]-0.5; 0] need to be added 0.5, other negative inputs need to
    // be added the biggest double less than 0.5.
    Label loadJoin;
    masm.loadConstantFloat32(-0.5f, scratch);
    masm.branchFloat(Assembler::DoubleLessThan, input, scratch, &loadJoin);
    masm.loadConstantFloat32(0.5f, temp);
    masm.bind(&loadJoin);

    masm.as_adds(temp, input, temp);

    // If input + 0.5 >= 0, input is a negative number >= -0.5 and the
    // result is -0.
    masm.branchFloat(Assembler::DoubleGreaterThanOrEqual, temp, scratch, &bail);
    bailoutFrom(&bail, lir->snapshot());

    // Truncate and round toward zero.
    // This is off-by-one for everything but integer-valued inputs.
    masm.as_floorws(scratch, temp);
    masm.moveFromFloat32(scratch, output);

    bailoutCmp32(Assembler::Equal, output, Imm32(INT_MIN), lir->snapshot());

    masm.bind(&end);
}

void
CodeGeneratorMIPSShared::visitTruncateDToInt32(LTruncateDToInt32* ins)
{
    emitTruncateDouble(ToFloatRegister(ins->input()), ToRegister(ins->output()),
                       ins->mir());
}

void
CodeGeneratorMIPSShared::visitTruncateFToInt32(LTruncateFToInt32* ins)
{
    emitTruncateFloat32(ToFloatRegister(ins->input()), ToRegister(ins->output()),
                        ins->mir());
}

void
CodeGeneratorMIPSShared::visitWasmTruncateToInt32(LWasmTruncateToInt32* lir)
{
    auto input = ToFloatRegister(lir->input());
    auto output = ToRegister(lir->output());

    MWasmTruncateToInt32* mir = lir->mir();
    MIRType fromType = mir->input()->type();

    auto* ool = new (alloc()) OutOfLineWasmTruncateCheck(mir, input);
    addOutOfLineCode(ool, mir);

    if (mir->isUnsigned()) {
        // When the input value is Infinity, NaN, or rounds to an integer outside the
        // range [INT64_MIN; INT64_MAX + 1[, the Invalid Operation flag is set in the FCSR.
        if (fromType == MIRType::Double)
            masm.as_truncld(ScratchDoubleReg, input);
        else if (fromType == MIRType::Float32)
            masm.as_truncls(ScratchDoubleReg, input);
        else
            MOZ_CRASH("unexpected type in visitWasmTruncateToInt32");

        // Check that the result is in the uint32_t range.
        masm.moveFromDoubleHi(ScratchDoubleReg, output);
        masm.as_cfc1(ScratchRegister, Assembler::FCSR);
        masm.as_ext(ScratchRegister, ScratchRegister, 16, 1);
        masm.ma_or(output, ScratchRegister);
        masm.ma_b(output, Imm32(0), ool->entry(), Assembler::NotEqual);

        masm.moveFromFloat32(ScratchDoubleReg, output);
        return;
    }

    // When the input value is Infinity, NaN, or rounds to an integer outside the
    // range [INT32_MIN; INT32_MAX + 1[, the Invalid Operation flag is set in the FCSR.
    if (fromType == MIRType::Double)
        masm.as_truncwd(ScratchFloat32Reg, input);
    else if (fromType == MIRType::Float32)
        masm.as_truncws(ScratchFloat32Reg, input);
    else
        MOZ_CRASH("unexpected type in visitWasmTruncateToInt32");

    // Check that the result is in the int32_t range.
    masm.as_cfc1(output, Assembler::FCSR);
    masm.as_ext(output, output, 16, 1);
    masm.ma_b(output, Imm32(0), ool->entry(), Assembler::NotEqual);

    masm.bind(ool->rejoin());
    masm.moveFromFloat32(ScratchFloat32Reg, output);
}

void
CodeGeneratorMIPSShared::visitOutOfLineWasmTruncateCheck(OutOfLineWasmTruncateCheck* ool)
{
    FloatRegister input = ool->input();
    MIRType fromType = ool->fromType();
    MIRType toType = ool->toType();

    // Eagerly take care of NaNs.
    Label inputIsNaN;
    if (fromType == MIRType::Double)
        masm.branchDouble(Assembler::DoubleUnordered, input, input, &inputIsNaN);
    else if (fromType == MIRType::Float32)
        masm.branchFloat(Assembler::DoubleUnordered, input, input, &inputIsNaN);
    else
        MOZ_CRASH("unexpected type in visitOutOfLineWasmTruncateCheck");

    Label fail;

    // Handle special values (not needed for unsigned values).
    if (!ool->isUnsigned()) {
        if (toType == MIRType::Int32) {
            // MWasmTruncateToInt32
            if (fromType == MIRType::Double) {
                // we've used truncwd. the only valid double values that can
                // truncate to INT32_MIN are in ]INT32_MIN - 1; INT32_MIN].
                masm.loadConstantDouble(double(INT32_MIN) - 1.0, ScratchDoubleReg);
                masm.branchDouble(Assembler::DoubleLessThanOrEqual, input, ScratchDoubleReg, &fail);

                masm.loadConstantDouble(double(INT32_MIN), ScratchDoubleReg);
                masm.branchDouble(Assembler::DoubleGreaterThan, input, ScratchDoubleReg, &fail);

                masm.as_truncwd(ScratchFloat32Reg, ScratchDoubleReg);
                masm.jump(ool->rejoin());
            }
        } else if (toType == MIRType::Int64) {
            if (fromType == MIRType::Double) {
                masm.loadConstantDouble(double(INT64_MIN), ScratchDoubleReg);
                masm.branchDouble(Assembler::DoubleLessThan, input, ScratchDoubleReg, &fail);

                masm.loadConstantDouble(double(INT64_MAX) + 1.0, ScratchDoubleReg);
                masm.branchDouble(Assembler::DoubleGreaterThanOrEqual, input,
                                  ScratchDoubleReg, &fail);
                masm.jump(ool->rejoin());
            }
        }
    } else {
        if (toType == MIRType::Int64) {
            if (fromType == MIRType::Double) {
                masm.loadConstantDouble(double(-1), ScratchDoubleReg);
                masm.branchDouble(Assembler::DoubleLessThanOrEqual, input, ScratchDoubleReg, &fail);

                masm.loadConstantDouble(double(UINT64_MAX) + 1.0, ScratchDoubleReg);
                masm.branchDouble(Assembler::DoubleGreaterThanOrEqual, input,
                                  ScratchDoubleReg, &fail);
                masm.jump(ool->rejoin());
            }
       }
    }

    // Handle errors.
    masm.bind(&fail);
    masm.jump(trap(ool, wasm::Trap::IntegerOverflow));

    masm.bind(&inputIsNaN);
    masm.jump(trap(ool, wasm::Trap::InvalidConversionToInteger));
}

void
CodeGeneratorMIPSShared::visitCopySignF(LCopySignF* ins)
{
    FloatRegister lhs = ToFloatRegister(ins->getOperand(0));
    FloatRegister rhs = ToFloatRegister(ins->getOperand(1));
    FloatRegister output = ToFloatRegister(ins->getDef(0));

    Register lhsi = ToRegister(ins->getTemp(0));
    Register rhsi = ToRegister(ins->getTemp(1));

    masm.moveFromFloat32(lhs, lhsi);
    masm.moveFromFloat32(rhs, rhsi);

    // Combine.
    masm.as_ins(rhsi, lhsi, 0, 31);

    masm.moveToFloat32(rhsi, output);
}

void
CodeGeneratorMIPSShared::visitCopySignD(LCopySignD* ins)
{
    FloatRegister lhs = ToFloatRegister(ins->getOperand(0));
    FloatRegister rhs = ToFloatRegister(ins->getOperand(1));
    FloatRegister output = ToFloatRegister(ins->getDef(0));

    Register lhsi = ToRegister(ins->getTemp(0));
    Register rhsi = ToRegister(ins->getTemp(1));

    // Manipulate high words of double inputs.
    masm.moveFromDoubleHi(lhs, lhsi);
    masm.moveFromDoubleHi(rhs, rhsi);

    // Combine.
    masm.as_ins(rhsi, lhsi, 0, 31);

    masm.moveToDoubleHi(rhsi, output);
}

void
CodeGeneratorMIPSShared::visitValue(LValue* value)
{
    const ValueOperand out = ToOutValue(value);

    masm.moveValue(value->value(), out);
}

void
CodeGeneratorMIPSShared::visitDouble(LDouble* ins)
{
    const LDefinition* out = ins->getDef(0);

    masm.loadConstantDouble(ins->getDouble(), ToFloatRegister(out));
}

void
CodeGeneratorMIPSShared::visitFloat32(LFloat32* ins)
{
    const LDefinition* out = ins->getDef(0);
    masm.loadConstantFloat32(ins->getFloat(), ToFloatRegister(out));
}

void
CodeGeneratorMIPSShared::visitTestDAndBranch(LTestDAndBranch* test)
{
    FloatRegister input = ToFloatRegister(test->input());

    MBasicBlock* ifTrue = test->ifTrue();
    MBasicBlock* ifFalse = test->ifFalse();

    masm.loadConstantDouble(0.0, ScratchDoubleReg);
    // If 0, or NaN, the result is false.

    if (isNextBlock(ifFalse->lir())) {
        branchToBlock(Assembler::DoubleFloat, input, ScratchDoubleReg, ifTrue,
                      Assembler::DoubleNotEqual);
    } else {
        branchToBlock(Assembler::DoubleFloat, input, ScratchDoubleReg, ifFalse,
                      Assembler::DoubleEqualOrUnordered);
        jumpToBlock(ifTrue);
    }
}

void
CodeGeneratorMIPSShared::visitTestFAndBranch(LTestFAndBranch* test)
{
    FloatRegister input = ToFloatRegister(test->input());

    MBasicBlock* ifTrue = test->ifTrue();
    MBasicBlock* ifFalse = test->ifFalse();

    masm.loadConstantFloat32(0.0f, ScratchFloat32Reg);
    // If 0, or NaN, the result is false.

    if (isNextBlock(ifFalse->lir())) {
        branchToBlock(Assembler::SingleFloat, input, ScratchFloat32Reg, ifTrue,
                      Assembler::DoubleNotEqual);
    } else {
        branchToBlock(Assembler::SingleFloat, input, ScratchFloat32Reg, ifFalse,
                      Assembler::DoubleEqualOrUnordered);
        jumpToBlock(ifTrue);
    }
}

void
CodeGeneratorMIPSShared::visitCompareD(LCompareD* comp)
{
    FloatRegister lhs = ToFloatRegister(comp->left());
    FloatRegister rhs = ToFloatRegister(comp->right());
    Register dest = ToRegister(comp->output());

    Assembler::DoubleCondition cond = JSOpToDoubleCondition(comp->mir()->jsop());
    masm.ma_cmp_set_double(dest, lhs, rhs, cond);
}

void
CodeGeneratorMIPSShared::visitCompareF(LCompareF* comp)
{
    FloatRegister lhs = ToFloatRegister(comp->left());
    FloatRegister rhs = ToFloatRegister(comp->right());
    Register dest = ToRegister(comp->output());

    Assembler::DoubleCondition cond = JSOpToDoubleCondition(comp->mir()->jsop());
    masm.ma_cmp_set_float32(dest, lhs, rhs, cond);
}

void
CodeGeneratorMIPSShared::visitCompareDAndBranch(LCompareDAndBranch* comp)
{
    FloatRegister lhs = ToFloatRegister(comp->left());
    FloatRegister rhs = ToFloatRegister(comp->right());

    Assembler::DoubleCondition cond = JSOpToDoubleCondition(comp->cmpMir()->jsop());
    MBasicBlock* ifTrue = comp->ifTrue();
    MBasicBlock* ifFalse = comp->ifFalse();

    if (isNextBlock(ifFalse->lir())) {
        branchToBlock(Assembler::DoubleFloat, lhs, rhs, ifTrue, cond);
    } else {
        branchToBlock(Assembler::DoubleFloat, lhs, rhs, ifFalse,
                      Assembler::InvertCondition(cond));
        jumpToBlock(ifTrue);
    }
}

void
CodeGeneratorMIPSShared::visitCompareFAndBranch(LCompareFAndBranch* comp)
{
    FloatRegister lhs = ToFloatRegister(comp->left());
    FloatRegister rhs = ToFloatRegister(comp->right());

    Assembler::DoubleCondition cond = JSOpToDoubleCondition(comp->cmpMir()->jsop());
    MBasicBlock* ifTrue = comp->ifTrue();
    MBasicBlock* ifFalse = comp->ifFalse();

    if (isNextBlock(ifFalse->lir())) {
        branchToBlock(Assembler::SingleFloat, lhs, rhs, ifTrue, cond);
    } else {
        branchToBlock(Assembler::SingleFloat, lhs, rhs, ifFalse,
                      Assembler::InvertCondition(cond));
        jumpToBlock(ifTrue);
    }
}

void
CodeGeneratorMIPSShared::visitBitAndAndBranch(LBitAndAndBranch* lir)
{
    if (lir->right()->isConstant())
        masm.ma_and(ScratchRegister, ToRegister(lir->left()), Imm32(ToInt32(lir->right())));
    else
        masm.as_and(ScratchRegister, ToRegister(lir->left()), ToRegister(lir->right()));
    emitBranch(ScratchRegister, ScratchRegister, Assembler::NonZero, lir->ifTrue(),
               lir->ifFalse());
}

void
CodeGeneratorMIPSShared::visitWasmUint32ToDouble(LWasmUint32ToDouble* lir)
{
    masm.convertUInt32ToDouble(ToRegister(lir->input()), ToFloatRegister(lir->output()));
}

void
CodeGeneratorMIPSShared::visitWasmUint32ToFloat32(LWasmUint32ToFloat32* lir)
{
    masm.convertUInt32ToFloat32(ToRegister(lir->input()), ToFloatRegister(lir->output()));
}

void
CodeGeneratorMIPSShared::visitNotI(LNotI* ins)
{
    masm.cmp32Set(Assembler::Equal, ToRegister(ins->input()), Imm32(0),
                  ToRegister(ins->output()));
}

void
CodeGeneratorMIPSShared::visitNotD(LNotD* ins)
{
    // Since this operation is not, we want to set a bit if
    // the double is falsey, which means 0.0, -0.0 or NaN.
    FloatRegister in = ToFloatRegister(ins->input());
    Register dest = ToRegister(ins->output());

    masm.loadConstantDouble(0.0, ScratchDoubleReg);
    masm.ma_cmp_set_double(dest, in, ScratchDoubleReg, Assembler::DoubleEqualOrUnordered);
}

void
CodeGeneratorMIPSShared::visitNotF(LNotF* ins)
{
    // Since this operation is not, we want to set a bit if
    // the float32 is falsey, which means 0.0, -0.0 or NaN.
    FloatRegister in = ToFloatRegister(ins->input());
    Register dest = ToRegister(ins->output());

    masm.loadConstantFloat32(0.0f, ScratchFloat32Reg);
    masm.ma_cmp_set_float32(dest, in, ScratchFloat32Reg, Assembler::DoubleEqualOrUnordered);
}

void
CodeGeneratorMIPSShared::visitGuardShape(LGuardShape* guard)
{
    Register obj = ToRegister(guard->input());
    Register tmp = ToRegister(guard->tempInt());

    masm.loadPtr(Address(obj, ShapedObject::offsetOfShape()), tmp);
    bailoutCmpPtr(Assembler::NotEqual, tmp, ImmGCPtr(guard->mir()->shape()),
                  guard->snapshot());
}

void
CodeGeneratorMIPSShared::visitGuardObjectGroup(LGuardObjectGroup* guard)
{
    Register obj = ToRegister(guard->input());
    Register tmp = ToRegister(guard->tempInt());
    MOZ_ASSERT(obj != tmp);

    masm.loadPtr(Address(obj, JSObject::offsetOfGroup()), tmp);
    Assembler::Condition cond = guard->mir()->bailOnEquality()
                                ? Assembler::Equal
                                : Assembler::NotEqual;
    bailoutCmpPtr(cond, tmp, ImmGCPtr(guard->mir()->group()), guard->snapshot());
}

void
CodeGeneratorMIPSShared::visitGuardClass(LGuardClass* guard)
{
    Register obj = ToRegister(guard->input());
    Register tmp = ToRegister(guard->tempInt());

    masm.loadObjClass(obj, tmp);
    bailoutCmpPtr(Assembler::NotEqual, tmp, ImmPtr(guard->mir()->getClass()),
                  guard->snapshot());
}

void
CodeGeneratorMIPSShared::visitMemoryBarrier(LMemoryBarrier* ins)
{
    masm.memoryBarrier(ins->type());
}

void
CodeGeneratorMIPSShared::generateInvalidateEpilogue()
{
    // Ensure that there is enough space in the buffer for the OsiPoint
    // patching to occur. Otherwise, we could overwrite the invalidation
    // epilogue.
    for (size_t i = 0; i < sizeof(void*); i += Assembler::NopSize())
        masm.nop();

    masm.bind(&invalidate_);

    // Push the return address of the point that we bailed out at to the stack
    masm.Push(ra);

    // Push the Ion script onto the stack (when we determine what that
    // pointer is).
    invalidateEpilogueData_ = masm.pushWithPatch(ImmWord(uintptr_t(-1)));
    JitCode* thunk = gen->jitRuntime()->getInvalidationThunk();

    masm.branch(thunk);

    // We should never reach this point in JIT code -- the invalidation thunk
    // should pop the invalidated JS frame and return directly to its caller.
    masm.assumeUnreachable("Should have returned directly to its caller instead of here.");
}

void
CodeGeneratorMIPSShared::visitLoadTypedArrayElementStatic(LLoadTypedArrayElementStatic* ins)
{
    MOZ_CRASH("NYI");
}

void
CodeGeneratorMIPSShared::visitStoreTypedArrayElementStatic(LStoreTypedArrayElementStatic* ins)
{
    MOZ_CRASH("NYI");
}

void
CodeGeneratorMIPSShared::visitWasmCall(LWasmCall* ins)
{
    emitWasmCallBase(ins);
}

void
CodeGeneratorMIPSShared::visitWasmCallI64(LWasmCallI64* ins)
{
    emitWasmCallBase(ins);
}

template <typename T>
void
CodeGeneratorMIPSShared::emitWasmLoad(T* lir)
{
    const MWasmLoad* mir = lir->mir();

    uint32_t offset = mir->access().offset();
    MOZ_ASSERT(offset <= INT32_MAX);

    Register ptr = ToRegister(lir->ptr());

    // Maybe add the offset.
    if (offset) {
        Register ptrPlusOffset = ToRegister(lir->ptrCopy());
        masm.addPtr(Imm32(offset), ptrPlusOffset);
        ptr = ptrPlusOffset;
    } else {
        MOZ_ASSERT(lir->ptrCopy()->isBogusTemp());
    }

    unsigned byteSize = mir->access().byteSize();
    bool isSigned;
    bool isFloat = false;

    switch (mir->access().type()) {
      case Scalar::Int8:    isSigned = true;  break;
      case Scalar::Uint8:   isSigned = false; break;
      case Scalar::Int16:   isSigned = true;  break;
      case Scalar::Uint16:  isSigned = false; break;
      case Scalar::Int32:   isSigned = true;  break;
      case Scalar::Uint32:  isSigned = false; break;
      case Scalar::Float64: isFloat  = true;  break;
      case Scalar::Float32: isFloat  = true;  break;
      default: MOZ_CRASH("unexpected array type");
    }

    masm.memoryBarrier(mir->access().barrierBefore());

    BaseIndex address(HeapReg, ptr, TimesOne);

    if (mir->access().isUnaligned()) {
        Register temp = ToRegister(lir->getTemp(1));

        if (isFloat) {
            if (byteSize == 4)
                masm.loadUnalignedFloat32(address, temp, ToFloatRegister(lir->output()));
            else
                masm.loadUnalignedDouble(address, temp, ToFloatRegister(lir->output()));
        } else {
            masm.ma_load_unaligned(ToRegister(lir->output()), address, temp,
                                   static_cast<LoadStoreSize>(8 * byteSize),
                                   isSigned ? SignExtend : ZeroExtend);
        }

        masm.memoryBarrier(mir->access().barrierAfter());
        return;
    }

    if (isFloat) {
        if (byteSize == 4)
            masm.loadFloat32(address, ToFloatRegister(lir->output()));
        else
            masm.loadDouble(address, ToFloatRegister(lir->output()));
    } else {
        masm.ma_load(ToRegister(lir->output()), address,
                     static_cast<LoadStoreSize>(8 * byteSize),
                     isSigned ? SignExtend : ZeroExtend);
    }

    masm.memoryBarrier(mir->access().barrierAfter());
}

void
CodeGeneratorMIPSShared::visitWasmLoad(LWasmLoad* lir)
{
    emitWasmLoad(lir);
}

void
CodeGeneratorMIPSShared::visitWasmUnalignedLoad(LWasmUnalignedLoad* lir)
{
    emitWasmLoad(lir);
}

template <typename T>
void
CodeGeneratorMIPSShared::emitWasmStore(T* lir)
{
    const MWasmStore* mir = lir->mir();

    uint32_t offset = mir->access().offset();
    MOZ_ASSERT(offset <= INT32_MAX);

    Register ptr = ToRegister(lir->ptr());

    // Maybe add the offset.
    if (offset) {
        Register ptrPlusOffset = ToRegister(lir->ptrCopy());
        masm.addPtr(Imm32(offset), ptrPlusOffset);
        ptr = ptrPlusOffset;
    } else {
        MOZ_ASSERT(lir->ptrCopy()->isBogusTemp());
    }

    unsigned byteSize = mir->access().byteSize();
    bool isSigned;
    bool isFloat = false;

    switch (mir->access().type()) {
      case Scalar::Int8:    isSigned = true;  break;
      case Scalar::Uint8:   isSigned = false; break;
      case Scalar::Int16:   isSigned = true;  break;
      case Scalar::Uint16:  isSigned = false; break;
      case Scalar::Int32:   isSigned = true;  break;
      case Scalar::Uint32:  isSigned = false; break;
      case Scalar::Int64:   isSigned = true;  break;
      case Scalar::Float64: isFloat  = true;  break;
      case Scalar::Float32: isFloat  = true;  break;
      default: MOZ_CRASH("unexpected array type");
    }

    masm.memoryBarrier(mir->access().barrierBefore());

    BaseIndex address(HeapReg, ptr, TimesOne);

    if (mir->access().isUnaligned()) {
        Register temp = ToRegister(lir->getTemp(1));

        if (isFloat) {
            if (byteSize == 4)
                masm.storeUnalignedFloat32(ToFloatRegister(lir->value()), temp, address);
            else
                masm.storeUnalignedDouble(ToFloatRegister(lir->value()), temp, address);
        } else {
            masm.ma_store_unaligned(ToRegister(lir->value()), address, temp,
                                    static_cast<LoadStoreSize>(8 * byteSize),
                                    isSigned ? SignExtend : ZeroExtend);
        }

        masm.memoryBarrier(mir->access().barrierAfter());
        return;
    }

    if (isFloat) {
        if (byteSize == 4) {
            masm.storeFloat32(ToFloatRegister(lir->value()), address);
        } else
            masm.storeDouble(ToFloatRegister(lir->value()), address);
    } else {
        masm.ma_store(ToRegister(lir->value()), address,
                      static_cast<LoadStoreSize>(8 * byteSize),
                      isSigned ? SignExtend : ZeroExtend);
    }

    masm.memoryBarrier(mir->access().barrierAfter());
}

void
CodeGeneratorMIPSShared::visitWasmStore(LWasmStore* lir)
{
    emitWasmStore(lir);
}

void
CodeGeneratorMIPSShared::visitWasmUnalignedStore(LWasmUnalignedStore* lir)
{
    emitWasmStore(lir);
}

void
CodeGeneratorMIPSShared::visitAsmJSLoadHeap(LAsmJSLoadHeap* ins)
{
    const MAsmJSLoadHeap* mir = ins->mir();
    const LAllocation* ptr = ins->ptr();
    const LDefinition* out = ins->output();

    bool isSigned;
    int size;
    bool isFloat = false;
    switch (mir->access().type()) {
      case Scalar::Int8:    isSigned = true;  size =  8; break;
      case Scalar::Uint8:   isSigned = false; size =  8; break;
      case Scalar::Int16:   isSigned = true;  size = 16; break;
      case Scalar::Uint16:  isSigned = false; size = 16; break;
      case Scalar::Int32:   isSigned = true;  size = 32; break;
      case Scalar::Uint32:  isSigned = false; size = 32; break;
      case Scalar::Float64: isFloat  = true;  size = 64; break;
      case Scalar::Float32: isFloat  = true;  size = 32; break;
      default: MOZ_CRASH("unexpected array type");
    }

    if (ptr->isConstant()) {
        MOZ_ASSERT(!mir->needsBoundsCheck());
        int32_t ptrImm = ptr->toConstant()->toInt32();
        MOZ_ASSERT(ptrImm >= 0);
        if (isFloat) {
            if (size == 32) {
                masm.loadFloat32(Address(HeapReg, ptrImm), ToFloatRegister(out));
            } else {
                masm.loadDouble(Address(HeapReg, ptrImm), ToFloatRegister(out));
            }
        }  else {
            masm.ma_load(ToRegister(out), Address(HeapReg, ptrImm),
                         static_cast<LoadStoreSize>(size), isSigned ? SignExtend : ZeroExtend);
        }
        return;
    }

    Register ptrReg = ToRegister(ptr);

    if (!mir->needsBoundsCheck()) {
        if (isFloat) {
            if (size == 32) {
                masm.loadFloat32(BaseIndex(HeapReg, ptrReg, TimesOne), ToFloatRegister(out));
            } else {
                masm.loadDouble(BaseIndex(HeapReg, ptrReg, TimesOne), ToFloatRegister(out));
            }
        } else {
            masm.ma_load(ToRegister(out), BaseIndex(HeapReg, ptrReg, TimesOne),
                         static_cast<LoadStoreSize>(size), isSigned ? SignExtend : ZeroExtend);
        }
        return;
    }

    BufferOffset bo = masm.ma_BoundsCheck(ScratchRegister);

    Label done, outOfRange;
    masm.ma_b(ptrReg, ScratchRegister, &outOfRange, Assembler::AboveOrEqual, ShortJump);
    // Offset is ok, let's load value.
    if (isFloat) {
        if (size == 32)
            masm.loadFloat32(BaseIndex(HeapReg, ptrReg, TimesOne), ToFloatRegister(out));
        else
            masm.loadDouble(BaseIndex(HeapReg, ptrReg, TimesOne), ToFloatRegister(out));
    } else {
        masm.ma_load(ToRegister(out), BaseIndex(HeapReg, ptrReg, TimesOne),
                     static_cast<LoadStoreSize>(size), isSigned ? SignExtend : ZeroExtend);
    }
    masm.ma_b(&done, ShortJump);
    masm.bind(&outOfRange);
    // Offset is out of range. Load default values.
    if (isFloat) {
        if (size == 32)
            masm.loadFloat32(Address(GlobalReg, wasm::NaN32GlobalDataOffset - WasmGlobalRegBias),
                             ToFloatRegister(out));
        else
            masm.loadDouble(Address(GlobalReg, wasm::NaN64GlobalDataOffset - WasmGlobalRegBias),
                            ToFloatRegister(out));
    } else {
        masm.move32(Imm32(0), ToRegister(out));
    }
    masm.bind(&done);

    masm.append(wasm::BoundsCheck(bo.getOffset()));
}

void
CodeGeneratorMIPSShared::visitAsmJSStoreHeap(LAsmJSStoreHeap* ins)
{
    const MAsmJSStoreHeap* mir = ins->mir();
    const LAllocation* value = ins->value();
    const LAllocation* ptr = ins->ptr();

    bool isSigned;
    int size;
    bool isFloat = false;
    switch (mir->access().type()) {
      case Scalar::Int8:    isSigned = true;  size =  8; break;
      case Scalar::Uint8:   isSigned = false; size =  8; break;
      case Scalar::Int16:   isSigned = true;  size = 16; break;
      case Scalar::Uint16:  isSigned = false; size = 16; break;
      case Scalar::Int32:   isSigned = true;  size = 32; break;
      case Scalar::Uint32:  isSigned = false; size = 32; break;
      case Scalar::Float64: isFloat  = true;  size = 64; break;
      case Scalar::Float32: isFloat  = true;  size = 32; break;
      default: MOZ_CRASH("unexpected array type");
    }

    if (ptr->isConstant()) {
        MOZ_ASSERT(!mir->needsBoundsCheck());
        int32_t ptrImm = ptr->toConstant()->toInt32();
        MOZ_ASSERT(ptrImm >= 0);

        if (isFloat) {
            FloatRegister freg = ToFloatRegister(value);
            Address addr(HeapReg, ptrImm);
            if (size == 32)
                masm.storeFloat32(freg, addr);
            else
                masm.storeDouble(freg, addr);
        }  else {
            masm.ma_store(ToRegister(value), Address(HeapReg, ptrImm),
                          static_cast<LoadStoreSize>(size), isSigned ? SignExtend : ZeroExtend);
        }
        return;
    }

    Register ptrReg = ToRegister(ptr);
    Address dstAddr(ptrReg, 0);

    if (!mir->needsBoundsCheck()) {
        if (isFloat) {
            FloatRegister freg = ToFloatRegister(value);
            BaseIndex bi(HeapReg, ptrReg, TimesOne);
            if (size == 32)
                masm.storeFloat32(freg, bi);
            else
                masm.storeDouble(freg, bi);
        } else {
            masm.ma_store(ToRegister(value), BaseIndex(HeapReg, ptrReg, TimesOne),
                          static_cast<LoadStoreSize>(size), isSigned ? SignExtend : ZeroExtend);
        }
        return;
    }

    BufferOffset bo = masm.ma_BoundsCheck(ScratchRegister);

    Label outOfRange;
    masm.ma_b(ptrReg, ScratchRegister, &outOfRange, Assembler::AboveOrEqual, ShortJump);

    // Offset is ok, let's store value.
    if (isFloat) {
        if (size == 32) {
            masm.storeFloat32(ToFloatRegister(value), BaseIndex(HeapReg, ptrReg, TimesOne));
        } else
            masm.storeDouble(ToFloatRegister(value), BaseIndex(HeapReg, ptrReg, TimesOne));
    } else {
        masm.ma_store(ToRegister(value), BaseIndex(HeapReg, ptrReg, TimesOne),
                      static_cast<LoadStoreSize>(size), isSigned ? SignExtend : ZeroExtend);
    }

    masm.bind(&outOfRange);
    masm.append(wasm::BoundsCheck(bo.getOffset()));
}

void
CodeGeneratorMIPSShared::visitAsmJSCompareExchangeHeap(LAsmJSCompareExchangeHeap* ins)
{
    MAsmJSCompareExchangeHeap* mir = ins->mir();
    Scalar::Type vt = mir->access().type();
    const LAllocation* ptr = ins->ptr();
    Register ptrReg = ToRegister(ptr);
    BaseIndex srcAddr(HeapReg, ptrReg, TimesOne);
    MOZ_ASSERT(ins->addrTemp()->isBogusTemp());

    Register oldval = ToRegister(ins->oldValue());
    Register newval = ToRegister(ins->newValue());
    Register valueTemp = ToRegister(ins->valueTemp());
    Register offsetTemp = ToRegister(ins->offsetTemp());
    Register maskTemp = ToRegister(ins->maskTemp());

    masm.compareExchangeToTypedIntArray(vt == Scalar::Uint32 ? Scalar::Int32 : vt,
                                        srcAddr, oldval, newval, InvalidReg,
                                        valueTemp, offsetTemp, maskTemp,
                                        ToAnyRegister(ins->output()));
}

void
CodeGeneratorMIPSShared::visitAsmJSAtomicExchangeHeap(LAsmJSAtomicExchangeHeap* ins)
{
    MAsmJSAtomicExchangeHeap* mir = ins->mir();
    Scalar::Type vt = mir->access().type();
    Register ptrReg = ToRegister(ins->ptr());
    Register value = ToRegister(ins->value());
    BaseIndex srcAddr(HeapReg, ptrReg, TimesOne);
    MOZ_ASSERT(ins->addrTemp()->isBogusTemp());

    Register valueTemp = ToRegister(ins->valueTemp());
    Register offsetTemp = ToRegister(ins->offsetTemp());
    Register maskTemp = ToRegister(ins->maskTemp());

    masm.atomicExchangeToTypedIntArray(vt == Scalar::Uint32 ? Scalar::Int32 : vt,
                                       srcAddr, value, InvalidReg, valueTemp,
                                       offsetTemp, maskTemp, ToAnyRegister(ins->output()));
}

void
CodeGeneratorMIPSShared::visitAsmJSAtomicBinopHeap(LAsmJSAtomicBinopHeap* ins)
{
    MOZ_ASSERT(ins->mir()->hasUses());
    MOZ_ASSERT(ins->addrTemp()->isBogusTemp());

    MAsmJSAtomicBinopHeap* mir = ins->mir();
    Scalar::Type vt = mir->access().type();
    Register ptrReg = ToRegister(ins->ptr());
    Register flagTemp = ToRegister(ins->flagTemp());
    Register valueTemp = ToRegister(ins->valueTemp());
    Register offsetTemp = ToRegister(ins->offsetTemp());
    Register maskTemp = ToRegister(ins->maskTemp());
    const LAllocation* value = ins->value();
    AtomicOp op = mir->operation();

    BaseIndex srcAddr(HeapReg, ptrReg, TimesOne);

    if (value->isConstant())
        atomicBinopToTypedIntArray(op, vt == Scalar::Uint32 ? Scalar::Int32 : vt,
                                   Imm32(ToInt32(value)), srcAddr, flagTemp, InvalidReg,
                                   valueTemp, offsetTemp, maskTemp,
                                   ToAnyRegister(ins->output()));
    else
        atomicBinopToTypedIntArray(op, vt == Scalar::Uint32 ? Scalar::Int32 : vt,
                                   ToRegister(value), srcAddr, flagTemp, InvalidReg,
                                   valueTemp, offsetTemp, maskTemp,
                                   ToAnyRegister(ins->output()));
}

void
CodeGeneratorMIPSShared::visitAsmJSAtomicBinopHeapForEffect(LAsmJSAtomicBinopHeapForEffect* ins)
{
    MOZ_ASSERT(!ins->mir()->hasUses());
    MOZ_ASSERT(ins->addrTemp()->isBogusTemp());

    MAsmJSAtomicBinopHeap* mir = ins->mir();
    Scalar::Type vt = mir->access().type();
    Register ptrReg = ToRegister(ins->ptr());
    Register flagTemp = ToRegister(ins->flagTemp());
    Register valueTemp = ToRegister(ins->valueTemp());
    Register offsetTemp = ToRegister(ins->offsetTemp());
    Register maskTemp = ToRegister(ins->maskTemp());
    const LAllocation* value = ins->value();
    AtomicOp op = mir->operation();

    BaseIndex srcAddr(HeapReg, ptrReg, TimesOne);

    if (value->isConstant())
        atomicBinopToTypedIntArray(op, vt, Imm32(ToInt32(value)), srcAddr, flagTemp,
                                   valueTemp, offsetTemp, maskTemp);
    else
        atomicBinopToTypedIntArray(op, vt, ToRegister(value), srcAddr, flagTemp,
                                   valueTemp, offsetTemp, maskTemp);
}

void
CodeGeneratorMIPSShared::visitWasmStackArg(LWasmStackArg* ins)
{
    const MWasmStackArg* mir = ins->mir();
    if (ins->arg()->isConstant()) {
        masm.storePtr(ImmWord(ToInt32(ins->arg())), Address(StackPointer, mir->spOffset()));
    } else {
        if (ins->arg()->isGeneralReg()) {
            masm.storePtr(ToRegister(ins->arg()), Address(StackPointer, mir->spOffset()));
        } else {
            masm.storeDouble(ToFloatRegister(ins->arg()).doubleOverlay(),
                             Address(StackPointer, mir->spOffset()));
        }
    }
}

void
CodeGeneratorMIPSShared::visitWasmStackArgI64(LWasmStackArgI64* ins)
{
    const MWasmStackArg* mir = ins->mir();
    Address dst(StackPointer, mir->spOffset());
    if (IsConstant(ins->arg()))
        masm.store64(Imm64(ToInt64(ins->arg())), dst);
    else
        masm.store64(ToRegister64(ins->arg()), dst);
}

void
CodeGeneratorMIPSShared::visitWasmSelect(LWasmSelect* ins)
{
    MIRType mirType = ins->mir()->type();

    Register cond = ToRegister(ins->condExpr());
    const LAllocation* falseExpr = ins->falseExpr();

    if (mirType == MIRType::Int32) {
        Register out = ToRegister(ins->output());
        MOZ_ASSERT(ToRegister(ins->trueExpr()) == out, "true expr input is reused for output");
        masm.as_movz(out, ToRegister(falseExpr), cond);
        return;
    }

    FloatRegister out = ToFloatRegister(ins->output());
    MOZ_ASSERT(ToFloatRegister(ins->trueExpr()) == out, "true expr input is reused for output");

    if (falseExpr->isFloatReg()) {
        if (mirType == MIRType::Float32)
            masm.as_movz(Assembler::SingleFloat, out, ToFloatRegister(falseExpr), cond);
        else if (mirType == MIRType::Double)
            masm.as_movz(Assembler::DoubleFloat, out, ToFloatRegister(falseExpr), cond);
        else
            MOZ_CRASH("unhandled type in visitWasmSelect!");
    } else {
        Label done;
        masm.ma_b(cond, cond, &done, Assembler::NonZero, ShortJump);

        if (mirType == MIRType::Float32)
            masm.loadFloat32(ToAddress(falseExpr), out);
        else if (mirType == MIRType::Double)
            masm.loadDouble(ToAddress(falseExpr), out);
        else
            MOZ_CRASH("unhandled type in visitWasmSelect!");

        masm.bind(&done);
    }
}

void
CodeGeneratorMIPSShared::visitWasmReinterpret(LWasmReinterpret* lir)
{
    MOZ_ASSERT(gen->compilingWasm());
    MWasmReinterpret* ins = lir->mir();

    MIRType to = ins->type();
    DebugOnly<MIRType> from = ins->input()->type();

    switch (to) {
      case MIRType::Int32:
        MOZ_ASSERT(from == MIRType::Float32);
        masm.as_mfc1(ToRegister(lir->output()), ToFloatRegister(lir->input()));
        break;
      case MIRType::Float32:
        MOZ_ASSERT(from == MIRType::Int32);
        masm.as_mtc1(ToRegister(lir->input()), ToFloatRegister(lir->output()));
        break;
      case MIRType::Double:
      case MIRType::Int64:
        MOZ_CRASH("not handled by this LIR opcode");
      default:
        MOZ_CRASH("unexpected WasmReinterpret");
    }
}

void
CodeGeneratorMIPSShared::visitUDivOrMod(LUDivOrMod* ins)
{
    Register lhs = ToRegister(ins->lhs());
    Register rhs = ToRegister(ins->rhs());
    Register output = ToRegister(ins->output());
    Label done;

    // Prevent divide by zero.
    if (ins->canBeDivideByZero()) {
        if (ins->mir()->isTruncated()) {
            if (ins->trapOnError()) {
                masm.ma_b(rhs, rhs, trap(ins, wasm::Trap::InvalidConversionToInteger), Assembler::Zero);
            } else {
                // Infinity|0 == 0
                Label notzero;
                masm.ma_b(rhs, rhs, &notzero, Assembler::NonZero, ShortJump);
                masm.move32(Imm32(0), output);
                masm.ma_b(&done, ShortJump);
                masm.bind(&notzero);
            }
        } else {
            bailoutCmp32(Assembler::Equal, rhs, Imm32(0), ins->snapshot());
        }
    }

    masm.as_divu(lhs, rhs);
    masm.as_mfhi(output);

    // If the remainder is > 0, bailout since this must be a double.
    if (ins->mir()->isDiv()) {
        if (!ins->mir()->toDiv()->canTruncateRemainder())
          bailoutCmp32(Assembler::NonZero, output, output, ins->snapshot());
        // Get quotient
        masm.as_mflo(output);
    }

    if (!ins->mir()->isTruncated())
        bailoutCmp32(Assembler::LessThan, output, Imm32(0), ins->snapshot());

    masm.bind(&done);
}

void
CodeGeneratorMIPSShared::visitEffectiveAddress(LEffectiveAddress* ins)
{
    const MEffectiveAddress* mir = ins->mir();
    Register base = ToRegister(ins->base());
    Register index = ToRegister(ins->index());
    Register output = ToRegister(ins->output());

    BaseIndex address(base, index, mir->scale(), mir->displacement());
    masm.computeEffectiveAddress(address, output);
}

void
CodeGeneratorMIPSShared::visitWasmLoadGlobalVar(LWasmLoadGlobalVar* ins)
{
    const MWasmLoadGlobalVar* mir = ins->mir();
    unsigned addr = mir->globalDataOffset() - WasmGlobalRegBias;
    if (mir->type() == MIRType::Int32)
        masm.load32(Address(GlobalReg, addr), ToRegister(ins->output()));
    else if (mir->type() == MIRType::Float32)
        masm.loadFloat32(Address(GlobalReg, addr), ToFloatRegister(ins->output()));
    else
        masm.loadDouble(Address(GlobalReg, addr), ToFloatRegister(ins->output()));
}

void
CodeGeneratorMIPSShared::visitWasmStoreGlobalVar(LWasmStoreGlobalVar* ins)
{
    const MWasmStoreGlobalVar* mir = ins->mir();

    MOZ_ASSERT(IsNumberType(mir->value()->type()));
    unsigned addr = mir->globalDataOffset() - WasmGlobalRegBias;
    if (mir->value()->type() == MIRType::Int32)
        masm.store32(ToRegister(ins->value()), Address(GlobalReg, addr));
    else if (mir->value()->type() == MIRType::Float32)
        masm.storeFloat32(ToFloatRegister(ins->value()), Address(GlobalReg, addr));
    else
        masm.storeDouble(ToFloatRegister(ins->value()), Address(GlobalReg, addr));
}

void
CodeGeneratorMIPSShared::visitNegI(LNegI* ins)
{
    Register input = ToRegister(ins->input());
    Register output = ToRegister(ins->output());

    masm.ma_negu(output, input);
}

void
CodeGeneratorMIPSShared::visitNegD(LNegD* ins)
{
    FloatRegister input = ToFloatRegister(ins->input());
    FloatRegister output = ToFloatRegister(ins->output());

    masm.as_negd(output, input);
}

void
CodeGeneratorMIPSShared::visitNegF(LNegF* ins)
{
    FloatRegister input = ToFloatRegister(ins->input());
    FloatRegister output = ToFloatRegister(ins->output());

    masm.as_negs(output, input);
}

template<typename S, typename T>
void
CodeGeneratorMIPSShared::atomicBinopToTypedIntArray(AtomicOp op, Scalar::Type arrayType,
                                                    const S& value, const T& mem, Register flagTemp,
                                                    Register outTemp, Register valueTemp,
                                                    Register offsetTemp, Register maskTemp,
                                                    AnyRegister output)
{
    MOZ_ASSERT(flagTemp != InvalidReg);
    MOZ_ASSERT_IF(arrayType == Scalar::Uint32, outTemp != InvalidReg);

    switch (arrayType) {
      case Scalar::Int8:
        switch (op) {
          case AtomicFetchAddOp:
            masm.atomicFetchAdd8SignExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchSubOp:
            masm.atomicFetchSub8SignExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchAndOp:
            masm.atomicFetchAnd8SignExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchOrOp:
            masm.atomicFetchOr8SignExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchXorOp:
            masm.atomicFetchXor8SignExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          default:
            MOZ_CRASH("Invalid typed array atomic operation");
        }
        break;
      case Scalar::Uint8:
        switch (op) {
          case AtomicFetchAddOp:
            masm.atomicFetchAdd8ZeroExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchSubOp:
            masm.atomicFetchSub8ZeroExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchAndOp:
            masm.atomicFetchAnd8ZeroExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchOrOp:
            masm.atomicFetchOr8ZeroExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchXorOp:
            masm.atomicFetchXor8ZeroExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          default:
            MOZ_CRASH("Invalid typed array atomic operation");
        }
        break;
      case Scalar::Int16:
        switch (op) {
          case AtomicFetchAddOp:
            masm.atomicFetchAdd16SignExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchSubOp:
            masm.atomicFetchSub16SignExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchAndOp:
            masm.atomicFetchAnd16SignExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchOrOp:
            masm.atomicFetchOr16SignExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchXorOp:
            masm.atomicFetchXor16SignExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          default:
            MOZ_CRASH("Invalid typed array atomic operation");
        }
        break;
      case Scalar::Uint16:
        switch (op) {
          case AtomicFetchAddOp:
            masm.atomicFetchAdd16ZeroExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchSubOp:
            masm.atomicFetchSub16ZeroExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchAndOp:
            masm.atomicFetchAnd16ZeroExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchOrOp:
            masm.atomicFetchOr16ZeroExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchXorOp:
            masm.atomicFetchXor16ZeroExtend(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          default:
            MOZ_CRASH("Invalid typed array atomic operation");
        }
        break;
      case Scalar::Int32:
        switch (op) {
          case AtomicFetchAddOp:
            masm.atomicFetchAdd32(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchSubOp:
            masm.atomicFetchSub32(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchAndOp:
            masm.atomicFetchAnd32(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchOrOp:
            masm.atomicFetchOr32(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          case AtomicFetchXorOp:
            masm.atomicFetchXor32(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, output.gpr());
            break;
          default:
            MOZ_CRASH("Invalid typed array atomic operation");
        }
        break;
      case Scalar::Uint32:
        // At the moment, the code in MCallOptimize.cpp requires the output
        // type to be double for uint32 arrays.  See bug 1077305.
        MOZ_ASSERT(output.isFloat());
        switch (op) {
          case AtomicFetchAddOp:
            masm.atomicFetchAdd32(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, outTemp);
            break;
          case AtomicFetchSubOp:
            masm.atomicFetchSub32(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, outTemp);
            break;
          case AtomicFetchAndOp:
            masm.atomicFetchAnd32(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, outTemp);
            break;
          case AtomicFetchOrOp:
            masm.atomicFetchOr32(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, outTemp);
            break;
          case AtomicFetchXorOp:
            masm.atomicFetchXor32(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp, outTemp);
            break;
          default:
            MOZ_CRASH("Invalid typed array atomic operation");
        }
        masm.convertUInt32ToDouble(outTemp, output.fpu());
        break;
      default:
        MOZ_CRASH("Invalid typed array type");
    }
}

template void
CodeGeneratorMIPSShared::atomicBinopToTypedIntArray(AtomicOp op, Scalar::Type arrayType,
                                                    const Imm32& value, const Address& mem,
                                                    Register flagTemp, Register outTemp,
                                                    Register valueTemp, Register offsetTemp,
                                                    Register maskTemp, AnyRegister output);
template void
CodeGeneratorMIPSShared::atomicBinopToTypedIntArray(AtomicOp op, Scalar::Type arrayType,
                                                    const Imm32& value, const BaseIndex& mem,
                                                    Register flagTemp, Register outTemp,
                                                    Register valueTemp, Register offsetTemp,
                                                    Register maskTemp, AnyRegister output);
template void
CodeGeneratorMIPSShared::atomicBinopToTypedIntArray(AtomicOp op, Scalar::Type arrayType,
                                                    const Register& value, const Address& mem,
                                                    Register flagTemp, Register outTemp,
                                                    Register valueTemp, Register offsetTemp,
                                                    Register maskTemp, AnyRegister output);
template void
CodeGeneratorMIPSShared::atomicBinopToTypedIntArray(AtomicOp op, Scalar::Type arrayType,
                                                    const Register& value, const BaseIndex& mem,
                                                    Register flagTemp, Register outTemp,
                                                    Register valueTemp, Register offsetTemp,
                                                    Register maskTemp, AnyRegister output);

// Binary operation for effect, result discarded.
template<typename S, typename T>
void
CodeGeneratorMIPSShared::atomicBinopToTypedIntArray(AtomicOp op, Scalar::Type arrayType, const S& value,
                                                    const T& mem, Register flagTemp, Register valueTemp,
                                                    Register offsetTemp, Register maskTemp)
{
    MOZ_ASSERT(flagTemp != InvalidReg);

    switch (arrayType) {
      case Scalar::Int8:
      case Scalar::Uint8:
        switch (op) {
          case AtomicFetchAddOp:
            masm.atomicAdd8(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
            break;
          case AtomicFetchSubOp:
            masm.atomicSub8(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
            break;
          case AtomicFetchAndOp:
            masm.atomicAnd8(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
            break;
          case AtomicFetchOrOp:
            masm.atomicOr8(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
            break;
          case AtomicFetchXorOp:
            masm.atomicXor8(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
            break;
          default:
            MOZ_CRASH("Invalid typed array atomic operation");
        }
        break;
      case Scalar::Int16:
      case Scalar::Uint16:
        switch (op) {
          case AtomicFetchAddOp:
            masm.atomicAdd16(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
            break;
          case AtomicFetchSubOp:
            masm.atomicSub16(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
            break;
          case AtomicFetchAndOp:
            masm.atomicAnd16(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
            break;
          case AtomicFetchOrOp:
            masm.atomicOr16(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
            break;
          case AtomicFetchXorOp:
            masm.atomicXor16(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
            break;
          default:
            MOZ_CRASH("Invalid typed array atomic operation");
        }
        break;
      case Scalar::Int32:
      case Scalar::Uint32:
        switch (op) {
          case AtomicFetchAddOp:
            masm.atomicAdd32(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
            break;
          case AtomicFetchSubOp:
            masm.atomicSub32(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
            break;
          case AtomicFetchAndOp:
            masm.atomicAnd32(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
            break;
          case AtomicFetchOrOp:
            masm.atomicOr32(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
            break;
          case AtomicFetchXorOp:
            masm.atomicXor32(value, mem, flagTemp, valueTemp, offsetTemp, maskTemp);
            break;
          default:
            MOZ_CRASH("Invalid typed array atomic operation");
        }
        break;
      default:
        MOZ_CRASH("Invalid typed array type");
    }
}

template void
CodeGeneratorMIPSShared::atomicBinopToTypedIntArray(AtomicOp op, Scalar::Type arrayType,
                                                    const Imm32& value, const Address& mem,
                                                    Register flagTemp, Register valueTemp,
                                                    Register offsetTemp, Register maskTemp);
template void
CodeGeneratorMIPSShared::atomicBinopToTypedIntArray(AtomicOp op, Scalar::Type arrayType,
                                                    const Imm32& value, const BaseIndex& mem,
                                                    Register flagTemp, Register valueTemp,
                                                    Register offsetTemp, Register maskTemp);
template void
CodeGeneratorMIPSShared::atomicBinopToTypedIntArray(AtomicOp op, Scalar::Type arrayType,
                                                    const Register& value, const Address& mem,
                                                    Register flagTemp, Register valueTemp,
                                                    Register offsetTemp, Register maskTemp);
template void
CodeGeneratorMIPSShared::atomicBinopToTypedIntArray(AtomicOp op, Scalar::Type arrayType,
                                                    const Register& value, const BaseIndex& mem,
                                                    Register flagTemp, Register valueTemp,
                                                    Register offsetTemp, Register maskTemp);


void
CodeGeneratorMIPSShared::visitWasmAddOffset(LWasmAddOffset* lir)
{
    MWasmAddOffset* mir = lir->mir();
    Register base = ToRegister(lir->base());
    Register out = ToRegister(lir->output());

    masm.ma_addTestCarry(out, base, Imm32(mir->offset()), trap(mir, wasm::Trap::OutOfBounds));
}

template <typename T>
static inline void
AtomicBinopToTypedArray(CodeGeneratorMIPSShared* cg, AtomicOp op,
                        Scalar::Type arrayType, const LAllocation* value, const T& mem,
                        Register flagTemp, Register outTemp, Register valueTemp,
                        Register offsetTemp, Register maskTemp, AnyRegister output)
{
    if (value->isConstant())
        cg->atomicBinopToTypedIntArray(op, arrayType, Imm32(ToInt32(value)), mem, flagTemp, outTemp,
                                       valueTemp, offsetTemp, maskTemp, output);
    else
        cg->atomicBinopToTypedIntArray(op, arrayType, ToRegister(value), mem, flagTemp, outTemp,
                                       valueTemp, offsetTemp, maskTemp, output);
}

void
CodeGeneratorMIPSShared::visitAtomicTypedArrayElementBinop(LAtomicTypedArrayElementBinop* lir)
{
    MOZ_ASSERT(lir->mir()->hasUses());

    AnyRegister output = ToAnyRegister(lir->output());
    Register elements = ToRegister(lir->elements());
    Register flagTemp = ToRegister(lir->temp1());
    Register outTemp = lir->temp2()->isBogusTemp() ? InvalidReg : ToRegister(lir->temp2());
    Register valueTemp = ToRegister(lir->valueTemp());
    Register offsetTemp = ToRegister(lir->offsetTemp());
    Register maskTemp = ToRegister(lir->maskTemp());
    const LAllocation* value = lir->value();

    Scalar::Type arrayType = lir->mir()->arrayType();
    int width = Scalar::byteSize(arrayType);

    if (lir->index()->isConstant()) {
        Address mem(elements, ToInt32(lir->index()) * width);
        AtomicBinopToTypedArray(this, lir->mir()->operation(), arrayType, value, mem, flagTemp, outTemp,
                                valueTemp, offsetTemp, maskTemp, output);
    } else {
        BaseIndex mem(elements, ToRegister(lir->index()), ScaleFromElemWidth(width));
        AtomicBinopToTypedArray(this, lir->mir()->operation(), arrayType, value, mem, flagTemp, outTemp,
                                valueTemp, offsetTemp, maskTemp, output);
    }
}

template <typename T>
static inline void
AtomicBinopToTypedArray(CodeGeneratorMIPSShared* cg, AtomicOp op, Scalar::Type arrayType,
                        const LAllocation* value, const T& mem, Register flagTemp,
                        Register valueTemp, Register offsetTemp, Register maskTemp)
{
    if (value->isConstant())
        cg->atomicBinopToTypedIntArray(op, arrayType, Imm32(ToInt32(value)), mem,
                                       flagTemp, valueTemp, offsetTemp, maskTemp);
    else
        cg->atomicBinopToTypedIntArray(op, arrayType, ToRegister(value), mem,
                                       flagTemp, valueTemp, offsetTemp, maskTemp);
}

void
CodeGeneratorMIPSShared::visitAtomicTypedArrayElementBinopForEffect(LAtomicTypedArrayElementBinopForEffect* lir)
{
    MOZ_ASSERT(!lir->mir()->hasUses());

    Register elements = ToRegister(lir->elements());
    Register flagTemp = ToRegister(lir->flagTemp());
    Register valueTemp = ToRegister(lir->valueTemp());
    Register offsetTemp = ToRegister(lir->offsetTemp());
    Register maskTemp = ToRegister(lir->maskTemp());
    const LAllocation* value = lir->value();
    Scalar::Type arrayType = lir->mir()->arrayType();
    int width = Scalar::byteSize(arrayType);

    if (lir->index()->isConstant()) {
        Address mem(elements, ToInt32(lir->index()) * width);
        AtomicBinopToTypedArray(this, lir->mir()->operation(), arrayType, value, mem,
                                flagTemp, valueTemp, offsetTemp, maskTemp);
    } else {
        BaseIndex mem(elements, ToRegister(lir->index()), ScaleFromElemWidth(width));
        AtomicBinopToTypedArray(this, lir->mir()->operation(), arrayType, value, mem,
                                flagTemp, valueTemp, offsetTemp, maskTemp);
    }
}

void
CodeGeneratorMIPSShared::visitCompareExchangeTypedArrayElement(LCompareExchangeTypedArrayElement* lir)
{
    Register elements = ToRegister(lir->elements());
    AnyRegister output = ToAnyRegister(lir->output());
    Register temp = lir->temp()->isBogusTemp() ? InvalidReg : ToRegister(lir->temp());

    Register oldval = ToRegister(lir->oldval());
    Register newval = ToRegister(lir->newval());
    Register valueTemp = ToRegister(lir->valueTemp());
    Register offsetTemp = ToRegister(lir->offsetTemp());
    Register maskTemp = ToRegister(lir->maskTemp());

    Scalar::Type arrayType = lir->mir()->arrayType();
    int width = Scalar::byteSize(arrayType);

    if (lir->index()->isConstant()) {
        Address dest(elements, ToInt32(lir->index()) * width);
        masm.compareExchangeToTypedIntArray(arrayType, dest, oldval, newval, temp,
                                            valueTemp, offsetTemp, maskTemp, output);
    } else {
        BaseIndex dest(elements, ToRegister(lir->index()), ScaleFromElemWidth(width));
        masm.compareExchangeToTypedIntArray(arrayType, dest, oldval, newval, temp,
                                            valueTemp, offsetTemp, maskTemp, output);
    }
}

void
CodeGeneratorMIPSShared::visitAtomicExchangeTypedArrayElement(LAtomicExchangeTypedArrayElement* lir)
{
    Register elements = ToRegister(lir->elements());
    AnyRegister output = ToAnyRegister(lir->output());
    Register temp = lir->temp()->isBogusTemp() ? InvalidReg : ToRegister(lir->temp());

    Register value = ToRegister(lir->value());
    Register valueTemp = ToRegister(lir->valueTemp());
    Register offsetTemp = ToRegister(lir->offsetTemp());
    Register maskTemp = ToRegister(lir->maskTemp());

    Scalar::Type arrayType = lir->mir()->arrayType();
    int width = Scalar::byteSize(arrayType);

    if (lir->index()->isConstant()) {
        Address dest(elements, ToInt32(lir->index()) * width);
        masm.atomicExchangeToTypedIntArray(arrayType, dest, value, temp,
                                           valueTemp, offsetTemp, maskTemp, output);
    } else {
        BaseIndex dest(elements, ToRegister(lir->index()), ScaleFromElemWidth(width));
        masm.atomicExchangeToTypedIntArray(arrayType, dest, value, temp,
                                           valueTemp, offsetTemp, maskTemp, output);
    }
}
