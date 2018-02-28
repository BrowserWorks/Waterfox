/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef jit_x86_shared_Lowering_x86_shared_h
#define jit_x86_shared_Lowering_x86_shared_h

#include "jit/shared/Lowering-shared.h"

namespace js {
namespace jit {

class LIRGeneratorX86Shared : public LIRGeneratorShared
{
  protected:
    LIRGeneratorX86Shared(MIRGenerator* gen, MIRGraph& graph, LIRGraph& lirGraph)
      : LIRGeneratorShared(gen, graph, lirGraph)
    {}

    LTableSwitch* newLTableSwitch(const LAllocation& in, const LDefinition& inputCopy,
                                  MTableSwitch* ins);
    LTableSwitchV* newLTableSwitchV(MTableSwitch* ins);

    void visitGuardShape(MGuardShape* ins);
    void visitGuardObjectGroup(MGuardObjectGroup* ins);
    void visitPowHalf(MPowHalf* ins);
    void lowerForShift(LInstructionHelper<1, 2, 0>* ins, MDefinition* mir, MDefinition* lhs,
                       MDefinition* rhs);
    void lowerForALU(LInstructionHelper<1, 1, 0>* ins, MDefinition* mir, MDefinition* input);
    void lowerForALU(LInstructionHelper<1, 2, 0>* ins, MDefinition* mir, MDefinition* lhs,
                     MDefinition* rhs);

    template<size_t Temps>
    void lowerForShiftInt64(LInstructionHelper<INT64_PIECES, INT64_PIECES + 1, Temps>* ins,
                            MDefinition* mir, MDefinition* lhs, MDefinition* rhs);

    template<size_t Temps>
    void lowerForFPU(LInstructionHelper<1, 2, Temps>* ins, MDefinition* mir, MDefinition* lhs,
                     MDefinition* rhs);
    void lowerForCompIx4(LSimdBinaryCompIx4* ins, MSimdBinaryComp* mir,
                         MDefinition* lhs, MDefinition* rhs);
    void lowerForCompFx4(LSimdBinaryCompFx4* ins, MSimdBinaryComp* mir,
                         MDefinition* lhs, MDefinition* rhs);
    void lowerForBitAndAndBranch(LBitAndAndBranch* baab, MInstruction* mir,
                                 MDefinition* lhs, MDefinition* rhs);
    void visitWasmNeg(MWasmNeg* ins);
    void visitWasmSelect(MWasmSelect* ins);
    void lowerMulI(MMul* mul, MDefinition* lhs, MDefinition* rhs);
    void lowerDivI(MDiv* div);
    void lowerModI(MMod* mod);
    void lowerUDiv(MDiv* div);
    void lowerUMod(MMod* mod);
    void lowerUrshD(MUrsh* mir);
    void lowerTruncateDToInt32(MTruncateToInt32* ins);
    void lowerTruncateFToInt32(MTruncateToInt32* ins);
    void visitSimdInsertElement(MSimdInsertElement* ins);
    void visitSimdExtractElement(MSimdExtractElement* ins);
    void visitSimdBinaryArith(MSimdBinaryArith* ins);
    void visitSimdBinarySaturating(MSimdBinarySaturating* ins);
    void visitSimdSelect(MSimdSelect* ins);
    void visitSimdSplat(MSimdSplat* ins);
    void visitSimdSwizzle(MSimdSwizzle* ins);
    void visitSimdShuffle(MSimdShuffle* ins);
    void visitSimdGeneralShuffle(MSimdGeneralShuffle* ins);
    void visitSimdValueX4(MSimdValueX4* ins);
    void lowerCompareExchangeTypedArrayElement(MCompareExchangeTypedArrayElement* ins,
                                               bool useI386ByteRegisters);
    void lowerAtomicExchangeTypedArrayElement(MAtomicExchangeTypedArrayElement* ins,
                                              bool useI386ByteRegisters);
    void lowerAtomicTypedArrayElementBinop(MAtomicTypedArrayElementBinop* ins,
                                           bool useI386ByteRegisters);
    void visitCopySign(MCopySign* ins);
};

} // namespace jit
} // namespace js

#endif /* jit_x86_shared_Lowering_x86_shared_h */
