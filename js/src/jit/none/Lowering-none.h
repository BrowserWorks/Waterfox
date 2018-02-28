/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef jit_none_Lowering_none_h
#define jit_none_Lowering_none_h

#include "jit/shared/Lowering-shared.h"

namespace js {
namespace jit {

class LIRGeneratorNone : public LIRGeneratorShared
{
  public:
    LIRGeneratorNone(MIRGenerator* gen, MIRGraph& graph, LIRGraph& lirGraph)
      : LIRGeneratorShared(gen, graph, lirGraph)
    {
        MOZ_CRASH();
    }

    LBoxAllocation useBoxFixed(MDefinition*, Register, Register, bool useAtStart = false) { MOZ_CRASH(); }

    LAllocation useByteOpRegister(MDefinition*) { MOZ_CRASH(); }
    LAllocation useByteOpRegisterAtStart(MDefinition*) { MOZ_CRASH(); }
    LAllocation useByteOpRegisterOrNonDoubleConstant(MDefinition*) { MOZ_CRASH(); }
    LDefinition tempByteOpRegister() { MOZ_CRASH(); }
    LDefinition tempToUnbox() { MOZ_CRASH(); }
    bool needTempForPostBarrier() { MOZ_CRASH(); }
    void lowerUntypedPhiInput(MPhi*, uint32_t, LBlock*, size_t) { MOZ_CRASH(); }
    void lowerInt64PhiInput(MPhi*, uint32_t, LBlock*, size_t) { MOZ_CRASH(); }
    void defineUntypedPhi(MPhi*, size_t) { MOZ_CRASH(); }
    void defineInt64Phi(MPhi*, size_t) { MOZ_CRASH(); }
    void lowerForShift(LInstructionHelper<1, 2, 0>*, MDefinition*, MDefinition*, MDefinition*) {
        MOZ_CRASH();
    }
    void lowerUrshD(MUrsh*) { MOZ_CRASH(); }
    template <typename T>
    void lowerForALU(T, MDefinition*, MDefinition*, MDefinition* v = nullptr) { MOZ_CRASH(); }
    template <typename T>
    void lowerForFPU(T, MDefinition*, MDefinition*, MDefinition* v = nullptr) { MOZ_CRASH(); }
    template <typename T>
    void lowerForALUInt64(T, MDefinition*, MDefinition*, MDefinition* v = nullptr) { MOZ_CRASH(); }
    void lowerForMulInt64(LMulI64*, MMul*, MDefinition*, MDefinition* v = nullptr) { MOZ_CRASH(); }
    template <typename T>
    void lowerForShiftInt64(T, MDefinition*, MDefinition*, MDefinition* v = nullptr) { MOZ_CRASH(); }
    void lowerForCompIx4(LSimdBinaryCompIx4* ins, MSimdBinaryComp* mir,
                         MDefinition* lhs, MDefinition* rhs) {
        MOZ_CRASH();
    }
    void lowerForCompFx4(LSimdBinaryCompFx4* ins, MSimdBinaryComp* mir,
                         MDefinition* lhs, MDefinition* rhs) {
        MOZ_CRASH();
    }
    void lowerForBitAndAndBranch(LBitAndAndBranch*, MInstruction*,
                                 MDefinition*, MDefinition*) {
        MOZ_CRASH();
    }

    void lowerConstantDouble(double, MInstruction*) { MOZ_CRASH(); }
    void lowerConstantFloat32(float, MInstruction*) { MOZ_CRASH(); }
    void lowerTruncateDToInt32(MTruncateToInt32*) { MOZ_CRASH(); }
    void lowerTruncateFToInt32(MTruncateToInt32*) { MOZ_CRASH(); }
    void lowerDivI(MDiv*) { MOZ_CRASH(); }
    void lowerModI(MMod*) { MOZ_CRASH(); }
    void lowerDivI64(MDiv*) { MOZ_CRASH(); }
    void lowerModI64(MMod*) { MOZ_CRASH(); }
    void lowerMulI(MMul*, MDefinition*, MDefinition*) { MOZ_CRASH(); }
    void lowerUDiv(MDiv*) { MOZ_CRASH(); }
    void lowerUMod(MMod*) { MOZ_CRASH(); }
    void visitBox(MBox* box) { MOZ_CRASH(); }
    void visitUnbox(MUnbox* unbox) { MOZ_CRASH(); }
    void visitReturn(MReturn* ret) { MOZ_CRASH(); }
    void visitPowHalf(MPowHalf*) { MOZ_CRASH(); }
    void visitWasmNeg(MWasmNeg*) { MOZ_CRASH(); }
    void visitGuardShape(MGuardShape* ins) { MOZ_CRASH(); }
    void visitGuardObjectGroup(MGuardObjectGroup* ins) { MOZ_CRASH(); }
    void visitWasmUnsignedToDouble(MWasmUnsignedToDouble* ins) { MOZ_CRASH(); }
    void visitWasmUnsignedToFloat32(MWasmUnsignedToFloat32* ins) { MOZ_CRASH(); }
    void visitAsmJSLoadHeap(MAsmJSLoadHeap* ins) { MOZ_CRASH(); }
    void visitAsmJSStoreHeap(MAsmJSStoreHeap* ins) { MOZ_CRASH(); }
    void visitStoreTypedArrayElementStatic(MStoreTypedArrayElementStatic* ins) { MOZ_CRASH(); }
    void visitAtomicTypedArrayElementBinop(MAtomicTypedArrayElementBinop* ins) { MOZ_CRASH(); }
    void visitCompareExchangeTypedArrayElement(MCompareExchangeTypedArrayElement* ins) { MOZ_CRASH(); }
    void visitAtomicExchangeTypedArrayElement(MAtomicExchangeTypedArrayElement* ins) { MOZ_CRASH(); }
    void visitAsmJSCompareExchangeHeap(MAsmJSCompareExchangeHeap* ins) { MOZ_CRASH(); }
    void visitAsmJSAtomicExchangeHeap(MAsmJSAtomicExchangeHeap* ins) { MOZ_CRASH(); }
    void visitAsmJSAtomicBinopHeap(MAsmJSAtomicBinopHeap* ins) { MOZ_CRASH(); }
    void visitWasmSelect(MWasmSelect*) { MOZ_CRASH(); }
    void visitWasmBoundsCheck(MWasmBoundsCheck* ins) { MOZ_CRASH(); }
    void visitWasmLoad(MWasmLoad* ins) { MOZ_CRASH(); }
    void visitWasmStore(MWasmStore* ins) { MOZ_CRASH(); }

    LTableSwitch* newLTableSwitch(LAllocation, LDefinition, MTableSwitch*) { MOZ_CRASH(); }
    LTableSwitchV* newLTableSwitchV(MTableSwitch*) { MOZ_CRASH(); }
    void visitSimdSelect(MSimdSelect* ins) { MOZ_CRASH(); }
    void visitSimdSplat(MSimdSplat* ins) { MOZ_CRASH(); }
    void visitSimdSwizzle(MSimdSwizzle* ins) { MOZ_CRASH(); }
    void visitSimdShuffle(MSimdShuffle* ins) { MOZ_CRASH(); }
    void visitSimdValueX4(MSimdValueX4* lir) { MOZ_CRASH(); }
    void visitSubstr(MSubstr*) { MOZ_CRASH(); }
    void visitSimdBinaryArith(js::jit::MSimdBinaryArith*) { MOZ_CRASH(); }
    void visitSimdBinarySaturating(MSimdBinarySaturating* ins) { MOZ_CRASH(); }
    void visitRandom(js::jit::MRandom*) { MOZ_CRASH(); }
    void visitCopySign(js::jit::MCopySign*) { MOZ_CRASH(); }
    void visitWasmTruncateToInt64(MWasmTruncateToInt64*) { MOZ_CRASH(); }
    void visitInt64ToFloatingPoint(MInt64ToFloatingPoint*) { MOZ_CRASH(); }
    void visitExtendInt32ToInt64(MExtendInt32ToInt64* ins) { MOZ_CRASH(); }
};

typedef LIRGeneratorNone LIRGeneratorSpecific;

} // namespace jit
} // namespace js

#endif /* jit_none_Lowering_none_h */
