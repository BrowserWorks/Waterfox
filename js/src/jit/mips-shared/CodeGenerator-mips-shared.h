/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef jit_mips_shared_CodeGenerator_mips_shared_h
#define jit_mips_shared_CodeGenerator_mips_shared_h

#include "jit/shared/CodeGenerator-shared.h"

namespace js {
namespace jit {

class OutOfLineBailout;
class OutOfLineTableSwitch;

class CodeGeneratorMIPSShared : public CodeGeneratorShared
{
    friend class MoveResolverMIPS;

    CodeGeneratorMIPSShared* thisFromCtor() {
        return this;
    }

  protected:
    NonAssertingLabel deoptLabel_;

    Operand ToOperand(const LAllocation& a);
    Operand ToOperand(const LAllocation* a);
    Operand ToOperand(const LDefinition* def);

#ifdef JS_PUNBOX64
    Operand ToOperandOrRegister64(const LInt64Allocation input);
#else
    Register64 ToOperandOrRegister64(const LInt64Allocation input);
#endif

    MoveOperand toMoveOperand(LAllocation a) const;

    template <typename T1, typename T2>
    void bailoutCmp32(Assembler::Condition c, T1 lhs, T2 rhs, LSnapshot* snapshot) {
        Label bail;
        masm.branch32(c, lhs, rhs, &bail);
        bailoutFrom(&bail, snapshot);
    }
    template<typename T>
    void bailoutTest32(Assembler::Condition c, Register lhs, T rhs, LSnapshot* snapshot) {
        Label bail;
        masm.branchTest32(c, lhs, rhs, &bail);
        bailoutFrom(&bail, snapshot);
    }
    template <typename T1, typename T2>
    void bailoutCmpPtr(Assembler::Condition c, T1 lhs, T2 rhs, LSnapshot* snapshot) {
        Label bail;
        masm.branchPtr(c, lhs, rhs, &bail);
        bailoutFrom(&bail, snapshot);
    }
    void bailoutTestPtr(Assembler::Condition c, Register lhs, Register rhs, LSnapshot* snapshot) {
        Label bail;
        masm.branchTestPtr(c, lhs, rhs, &bail);
        bailoutFrom(&bail, snapshot);
    }
    void bailoutIfFalseBool(Register reg, LSnapshot* snapshot) {
        Label bail;
        masm.branchTest32(Assembler::Zero, reg, Imm32(0xFF), &bail);
        bailoutFrom(&bail, snapshot);
    }

    void bailoutFrom(Label* label, LSnapshot* snapshot);
    void bailout(LSnapshot* snapshot);

  protected:
    bool generateOutOfLineCode();

    template <typename T>
    void branchToBlock(Register lhs, T rhs, MBasicBlock* mir, Assembler::Condition cond)
    {
        mir = skipTrivialBlocks(mir);

        Label* label = mir->lir()->label();
        if (Label* oolEntry = labelForBackedgeWithImplicitCheck(mir)) {
            // Note: the backedge is initially a jump to the next instruction.
            // It will be patched to the target block's label during link().
            RepatchLabel rejoin;
            CodeOffsetJump backedge;
            Label skip;

            masm.ma_b(lhs, rhs, &skip, Assembler::InvertCondition(cond), ShortJump);
            backedge = masm.backedgeJump(&rejoin);
            masm.bind(&rejoin);
            masm.bind(&skip);

            if (!patchableBackedges_.append(PatchableBackedgeInfo(backedge, label, oolEntry)))
                MOZ_CRASH();
        } else {
            masm.ma_b(lhs, rhs, label, cond);
        }
    }
    void branchToBlock(Assembler::FloatFormat fmt, FloatRegister lhs, FloatRegister rhs,
                       MBasicBlock* mir, Assembler::DoubleCondition cond);

    // Emits a branch that directs control flow to the true block if |cond| is
    // true, and the false block if |cond| is false.
    template <typename T>
    void emitBranch(Register lhs, T rhs, Assembler::Condition cond,
                    MBasicBlock* mirTrue, MBasicBlock* mirFalse)
    {
        if (isNextBlock(mirFalse->lir())) {
            branchToBlock(lhs, rhs, mirTrue, cond);
        } else {
            branchToBlock(lhs, rhs, mirFalse, Assembler::InvertCondition(cond));
            jumpToBlock(mirTrue);
        }
    }
    void testZeroEmitBranch(Assembler::Condition cond, Register reg,
                            MBasicBlock* ifTrue, MBasicBlock* ifFalse)
    {
        emitBranch(reg, Imm32(0), cond, ifTrue, ifFalse);
    }

    template <typename T>
    void emitWasmLoad(T* ins);
    template <typename T>
    void emitWasmStore(T* ins);

  public:
    // Instruction visitors.
    virtual void visitMinMaxD(LMinMaxD* ins);
    virtual void visitMinMaxF(LMinMaxF* ins);
    virtual void visitAbsD(LAbsD* ins);
    virtual void visitAbsF(LAbsF* ins);
    virtual void visitSqrtD(LSqrtD* ins);
    virtual void visitSqrtF(LSqrtF* ins);
    virtual void visitAddI(LAddI* ins);
    virtual void visitAddI64(LAddI64* ins);
    virtual void visitSubI(LSubI* ins);
    virtual void visitSubI64(LSubI64* ins);
    virtual void visitBitNotI(LBitNotI* ins);
    virtual void visitBitOpI(LBitOpI* ins);
    virtual void visitBitOpI64(LBitOpI64* ins);

    virtual void visitMulI(LMulI* ins);
    virtual void visitMulI64(LMulI64* ins);

    virtual void visitDivI(LDivI* ins);
    virtual void visitDivPowTwoI(LDivPowTwoI* ins);
    virtual void visitModI(LModI* ins);
    virtual void visitModPowTwoI(LModPowTwoI* ins);
    virtual void visitModMaskI(LModMaskI* ins);
    virtual void visitPowHalfD(LPowHalfD* ins);
    virtual void visitShiftI(LShiftI* ins);
    virtual void visitShiftI64(LShiftI64* ins);
    virtual void visitRotateI64(LRotateI64* lir);
    virtual void visitUrshD(LUrshD* ins);

    virtual void visitClzI(LClzI* ins);
    virtual void visitCtzI(LCtzI* ins);
    virtual void visitPopcntI(LPopcntI* ins);
    virtual void visitPopcntI64(LPopcntI64* lir);

    virtual void visitTestIAndBranch(LTestIAndBranch* test);
    virtual void visitCompare(LCompare* comp);
    virtual void visitCompareAndBranch(LCompareAndBranch* comp);
    virtual void visitTestDAndBranch(LTestDAndBranch* test);
    virtual void visitTestFAndBranch(LTestFAndBranch* test);
    virtual void visitCompareD(LCompareD* comp);
    virtual void visitCompareF(LCompareF* comp);
    virtual void visitCompareDAndBranch(LCompareDAndBranch* comp);
    virtual void visitCompareFAndBranch(LCompareFAndBranch* comp);
    virtual void visitBitAndAndBranch(LBitAndAndBranch* lir);
    virtual void visitWasmUint32ToDouble(LWasmUint32ToDouble* lir);
    virtual void visitWasmUint32ToFloat32(LWasmUint32ToFloat32* lir);
    virtual void visitNotI(LNotI* ins);
    virtual void visitNotD(LNotD* ins);
    virtual void visitNotF(LNotF* ins);

    virtual void visitMathD(LMathD* math);
    virtual void visitMathF(LMathF* math);
    virtual void visitFloor(LFloor* lir);
    virtual void visitFloorF(LFloorF* lir);
    virtual void visitCeil(LCeil* lir);
    virtual void visitCeilF(LCeilF* lir);
    virtual void visitRound(LRound* lir);
    virtual void visitRoundF(LRoundF* lir);
    virtual void visitTruncateDToInt32(LTruncateDToInt32* ins);
    virtual void visitTruncateFToInt32(LTruncateFToInt32* ins);

    void visitWasmTruncateToInt32(LWasmTruncateToInt32* lir);
    void visitWasmLoadGlobalVar(LWasmLoadGlobalVar* ins);
    void visitWasmStoreGlobalVar(LWasmStoreGlobalVar* ins);

    // Out of line visitors.
    virtual void visitOutOfLineBailout(OutOfLineBailout* ool) = 0;
    void visitOutOfLineWasmTruncateCheck(OutOfLineWasmTruncateCheck* ool);
    void visitCopySignD(LCopySignD* ins);
    void visitCopySignF(LCopySignF* ins);

  protected:
    virtual ValueOperand ToOutValue(LInstruction* ins) = 0;

  public:
    CodeGeneratorMIPSShared(MIRGenerator* gen, LIRGraph* graph, MacroAssembler* masm);

    void visitValue(LValue* value);
    void visitDouble(LDouble* ins);
    void visitFloat32(LFloat32* ins);

    void visitGuardShape(LGuardShape* guard);
    void visitGuardObjectGroup(LGuardObjectGroup* guard);
    void visitGuardClass(LGuardClass* guard);

    void visitNegI(LNegI* lir);
    void visitNegD(LNegD* lir);
    void visitNegF(LNegF* lir);
    void visitLoadTypedArrayElementStatic(LLoadTypedArrayElementStatic* ins);
    void visitStoreTypedArrayElementStatic(LStoreTypedArrayElementStatic* ins);
    void visitWasmCall(LWasmCall* ins);
    void visitWasmCallI64(LWasmCallI64* ins);
    void visitWasmLoad(LWasmLoad* ins);
    void visitWasmUnalignedLoad(LWasmUnalignedLoad* ins);
    void visitWasmStore(LWasmStore* ins);
    void visitWasmUnalignedStore(LWasmUnalignedStore* ins);
    void visitWasmAddOffset(LWasmAddOffset* ins);
    void visitAsmJSLoadHeap(LAsmJSLoadHeap* ins);
    void visitAsmJSStoreHeap(LAsmJSStoreHeap* ins);
    void visitAsmJSCompareExchangeHeap(LAsmJSCompareExchangeHeap* ins);
    void visitAsmJSAtomicExchangeHeap(LAsmJSAtomicExchangeHeap* ins);
    void visitAsmJSAtomicBinopHeap(LAsmJSAtomicBinopHeap* ins);
    void visitAsmJSAtomicBinopHeapForEffect(LAsmJSAtomicBinopHeapForEffect* ins);

    void visitWasmStackArg(LWasmStackArg* ins);
    void visitWasmStackArgI64(LWasmStackArgI64* ins);
    void visitWasmSelect(LWasmSelect* ins);
    void visitWasmReinterpret(LWasmReinterpret* ins);

    void visitMemoryBarrier(LMemoryBarrier* ins);
    void visitAtomicTypedArrayElementBinop(LAtomicTypedArrayElementBinop* lir);
    void visitAtomicTypedArrayElementBinopForEffect(LAtomicTypedArrayElementBinopForEffect* lir);
    void visitCompareExchangeTypedArrayElement(LCompareExchangeTypedArrayElement* lir);
    void visitAtomicExchangeTypedArrayElement(LAtomicExchangeTypedArrayElement* lir);

    void generateInvalidateEpilogue();

    // Generating a result.
    template<typename S, typename T>
    void atomicBinopToTypedIntArray(AtomicOp op, Scalar::Type arrayType, const S& value,
                                    const T& mem, Register flagTemp, Register outTemp,
                                    Register valueTemp, Register offsetTemp, Register maskTemp,
                                    AnyRegister output);

    // Generating no result.
    template<typename S, typename T>
    void atomicBinopToTypedIntArray(AtomicOp op, Scalar::Type arrayType, const S& value,
                                    const T& mem, Register flagTemp, Register valueTemp,
                                    Register offsetTemp, Register maskTemp);

  protected:
    void visitEffectiveAddress(LEffectiveAddress* ins);
    void visitUDivOrMod(LUDivOrMod* ins);

  public:
    // Unimplemented SIMD instructions
    void visitSimdSplatX4(LSimdSplatX4* lir) { MOZ_CRASH("NYI"); }
    void visitSimd128Int(LSimd128Int* ins) { MOZ_CRASH("NYI"); }
    void visitSimd128Float(LSimd128Float* ins) { MOZ_CRASH("NYI"); }
    void visitSimdReinterpretCast(LSimdReinterpretCast* ins) { MOZ_CRASH("NYI"); }
    void visitSimdExtractElementI(LSimdExtractElementI* ins) { MOZ_CRASH("NYI"); }
    void visitSimdExtractElementF(LSimdExtractElementF* ins) { MOZ_CRASH("NYI"); }
    void visitSimdBinaryCompIx4(LSimdBinaryCompIx4* lir) { MOZ_CRASH("NYI"); }
    void visitSimdBinaryCompFx4(LSimdBinaryCompFx4* lir) { MOZ_CRASH("NYI"); }
    void visitSimdBinaryArithIx4(LSimdBinaryArithIx4* lir) { MOZ_CRASH("NYI"); }
    void visitSimdBinaryArithFx4(LSimdBinaryArithFx4* lir) { MOZ_CRASH("NYI"); }
    void visitSimdBinaryBitwise(LSimdBinaryBitwise* lir) { MOZ_CRASH("NYI"); }
    void visitSimdGeneralShuffleI(LSimdGeneralShuffleI* lir) { MOZ_CRASH("NYI"); }
    void visitSimdGeneralShuffleF(LSimdGeneralShuffleF* lir) { MOZ_CRASH("NYI"); }
};

// An out-of-line bailout thunk.
class OutOfLineBailout : public OutOfLineCodeBase<CodeGeneratorMIPSShared>
{
    LSnapshot* snapshot_;
    uint32_t frameSize_;

  public:
    OutOfLineBailout(LSnapshot* snapshot, uint32_t frameSize)
      : snapshot_(snapshot),
        frameSize_(frameSize)
    { }

    void accept(CodeGeneratorMIPSShared* codegen);

    LSnapshot* snapshot() const {
        return snapshot_;
    }
};

} // namespace jit
} // namespace js

#endif /* jit_mips_shared_CodeGenerator_mips_shared_h */
