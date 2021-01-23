/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef jit_CodeGenerator_h
#define jit_CodeGenerator_h

#include "jsfriendapi.h"

#include "jit/CacheIR.h"
#if defined(JS_ION_PERF)
#  include "jit/PerfSpewer.h"
#endif

#if defined(JS_CODEGEN_X86)
#  include "jit/x86/CodeGenerator-x86.h"
#elif defined(JS_CODEGEN_X64)
#  include "jit/x64/CodeGenerator-x64.h"
#elif defined(JS_CODEGEN_ARM)
#  include "jit/arm/CodeGenerator-arm.h"
#elif defined(JS_CODEGEN_ARM64)
#  include "jit/arm64/CodeGenerator-arm64.h"
#elif defined(JS_CODEGEN_MIPS32)
#  include "jit/mips32/CodeGenerator-mips32.h"
#elif defined(JS_CODEGEN_MIPS64)
#  include "jit/mips64/CodeGenerator-mips64.h"
#elif defined(JS_CODEGEN_NONE)
#  include "jit/none/CodeGenerator-none.h"
#else
#  error "Unknown architecture!"
#endif

#include "wasm/WasmGC.h"

namespace js {
namespace jit {

template <typename Fn, Fn fn, class ArgSeq, class StoreOutputTo>
class OutOfLineCallVM;

enum class SwitchTableType { Inline, OutOfLine };

template <SwitchTableType tableType>
class OutOfLineSwitch;
class OutOfLineTestObject;
class OutOfLineNewArray;
class OutOfLineNewObject;
class CheckOverRecursedFailure;
class OutOfLineUnboxFloatingPoint;
class OutOfLineStoreElementHole;
class OutOfLineTypeOfV;
class OutOfLineUpdateCache;
class OutOfLineICFallback;
class OutOfLineCallPostWriteBarrier;
class OutOfLineCallPostWriteElementBarrier;
class OutOfLineIsCallable;
class OutOfLineIsConstructor;
class OutOfLineRegExpMatcher;
class OutOfLineRegExpSearcher;
class OutOfLineRegExpTester;
class OutOfLineRegExpPrototypeOptimizable;
class OutOfLineRegExpInstanceOptimizable;
class OutOfLineNaNToZero;
class OutOfLineZeroIfNaN;
class OutOfLineTypedArrayIndexToInt32;

class CodeGenerator final : public CodeGeneratorSpecific {
  void generateArgumentsChecks(bool assert = false);
  MOZ_MUST_USE bool generateBody();

  ConstantOrRegister toConstantOrRegister(LInstruction* lir, size_t n,
                                          MIRType type);

#ifdef CHECK_OSIPOINT_REGISTERS
  void resetOsiPointRegs(LSafepoint* safepoint);
  bool shouldVerifyOsiPointRegs(LSafepoint* safepoint);
  void verifyOsiPointRegs(LSafepoint* safepoint);
#endif

  void callVMInternal(VMFunctionId id, LInstruction* ins,
                      const Register* dynStack);

  template <typename Fn, Fn fn>
  void callVM(LInstruction* ins, const Register* dynStack = nullptr);

  template <typename Fn, Fn fn, class ArgSeq, class StoreOutputTo>
  inline OutOfLineCode* oolCallVM(LInstruction* ins, const ArgSeq& args,
                                  const StoreOutputTo& out);

 public:
  CodeGenerator(MIRGenerator* gen, LIRGraph* graph,
                MacroAssembler* masm = nullptr);
  ~CodeGenerator();

  MOZ_MUST_USE bool generate();
  MOZ_MUST_USE bool generateWasm(wasm::FuncTypeIdDesc funcTypeId,
                                 wasm::BytecodeOffset trapOffset,
                                 const wasm::ArgTypeVector& argTys,
                                 const MachineState& trapExitLayout,
                                 size_t trapExitLayoutNumWords,
                                 wasm::FuncOffsets* offsets,
                                 wasm::StackMaps* stackMaps);

  MOZ_MUST_USE bool link(JSContext* cx, CompilerConstraintList* constraints);

  void emitOOLTestObject(Register objreg, Label* ifTruthy, Label* ifFalsy,
                         Register scratch);
  void emitIntToString(Register input, Register output, Label* ool);

  template <typename Fn, Fn fn, class ArgSeq, class StoreOutputTo>
  void visitOutOfLineCallVM(
      OutOfLineCallVM<Fn, fn, ArgSeq, StoreOutputTo>* ool);

  void visitOutOfLineRegExpMatcher(OutOfLineRegExpMatcher* ool);
  void visitOutOfLineRegExpSearcher(OutOfLineRegExpSearcher* ool);
  void visitOutOfLineRegExpTester(OutOfLineRegExpTester* ool);
  void visitOutOfLineRegExpPrototypeOptimizable(
      OutOfLineRegExpPrototypeOptimizable* ool);
  void visitOutOfLineRegExpInstanceOptimizable(
      OutOfLineRegExpInstanceOptimizable* ool);

  void visitOutOfLineTypeOfV(OutOfLineTypeOfV* ool);

  template <SwitchTableType tableType>
  void visitOutOfLineSwitch(OutOfLineSwitch<tableType>* ool);

  void visitOutOfLineIsCallable(OutOfLineIsCallable* ool);
  void visitOutOfLineIsConstructor(OutOfLineIsConstructor* ool);

  void visitOutOfLineNaNToZero(OutOfLineNaNToZero* ool);
  void visitOutOfLineZeroIfNaN(OutOfLineZeroIfNaN* ool);

  void visitCheckOverRecursedFailure(CheckOverRecursedFailure* ool);

  void visitOutOfLineUnboxFloatingPoint(OutOfLineUnboxFloatingPoint* ool);
  void visitOutOfLineStoreElementHole(OutOfLineStoreElementHole* ool);

  void visitOutOfLineICFallback(OutOfLineICFallback* ool);

  void visitOutOfLineCallPostWriteBarrier(OutOfLineCallPostWriteBarrier* ool);
  void visitOutOfLineCallPostWriteElementBarrier(
      OutOfLineCallPostWriteElementBarrier* ool);

  void visitOutOfLineNewArray(OutOfLineNewArray* ool);
  void visitOutOfLineNewObject(OutOfLineNewObject* ool);

  void visitOutOfLineTypedArrayIndexToInt32(
      OutOfLineTypedArrayIndexToInt32* ool);

 private:
  void emitPostWriteBarrier(const LAllocation* obj);
  void emitPostWriteBarrier(Register objreg);
  void emitPostWriteBarrierS(Address address, Register prev, Register next);

  template <class LPostBarrierType, MIRType nurseryType>
  void visitPostWriteBarrierCommon(LPostBarrierType* lir, OutOfLineCode* ool);
  template <class LPostBarrierType>
  void visitPostWriteBarrierCommonV(LPostBarrierType* lir, OutOfLineCode* ool);

  void emitCallInvokeFunction(LInstruction* call, Register callereg,
                              bool isConstructing, bool ignoresReturnValue,
                              uint32_t argc, uint32_t unusedStack);
  template <typename T>
  void emitApplyGeneric(T* apply);
  template <typename T>
  void emitCallInvokeFunction(T* apply, Register extraStackSize);
  void emitAllocateSpaceForApply(Register argcreg, Register extraStackSpace);
  void emitAllocateSpaceForConstructAndPushNewTarget(
      Register argcreg, Register newTargetAndExtraStackSpace);
  void emitCopyValuesForApply(Register argvSrcBase, Register argvIndex,
                              Register copyreg, size_t argvSrcOffset,
                              size_t argvDstOffset);
  void emitPopArguments(Register extraStackSize);
  void emitPushElementsAsArguments(Register tmpArgc, Register elementsAndArgc,
                                   Register extraStackSpace);
  void emitPushArguments(LApplyArgsGeneric* apply, Register extraStackSpace);
  void emitPushArguments(LApplyArrayGeneric* apply, Register extraStackSpace);
  void emitPushArguments(LConstructArrayGeneric* construct,
                         Register extraStackSpace);

  void visitNewArrayCallVM(LNewArray* lir);
  void visitNewObjectVMCall(LNewObject* lir);

  void emitGetPropertyPolymorphic(LInstruction* lir, Register obj,
                                  Register scratch,
                                  const TypedOrValueRegister& output);
  void emitSetPropertyPolymorphic(LInstruction* lir, Register obj,
                                  Register scratch,
                                  const ConstantOrRegister& value);
  void emitCompareS(LInstruction* lir, JSOp op, Register left, Register right,
                    Register output);
  void emitSameValue(FloatRegister left, FloatRegister right,
                     FloatRegister temp, Register output);

  void emitConcat(LInstruction* lir, Register lhs, Register rhs,
                  Register output);
  template <typename T>
  void emitLoadElementT(LLoadElementT* lir, const T& source);

  template <typename T>
  void emitStoreElementHoleT(T* lir);
  template <typename T>
  void emitStoreElementHoleV(T* lir);

  void emitArrayPopShift(LInstruction* lir, const MArrayPopShift* mir,
                         Register obj, Register elementsTemp,
                         Register lengthTemp, TypedOrValueRegister out);
  void emitArrayPush(LInstruction* lir, Register obj,
                     const ConstantOrRegister& value, Register elementsTemp,
                     Register length, Register spectreTemp);

  void emitRest(LInstruction* lir, Register array, Register numActuals,
                Register temp0, Register temp1, unsigned numFormals,
                JSObject* templateObject, bool saveAndRestore,
                Register resultreg);
  void emitInstanceOf(LInstruction* ins, JSObject* prototypeObject);

  void loadJSScriptForBlock(MBasicBlock* block, Register reg);
  void loadOutermostJSScript(Register reg);

#ifdef DEBUG
  void emitAssertResultV(const ValueOperand output, const MDefinition* mir);
  void emitAssertGCThingResult(Register input, const MDefinition* mir);
#endif

#ifdef DEBUG
  void emitDebugForceBailing(LInstruction* lir);
#endif

  IonScriptCounts* extractScriptCounts() {
    IonScriptCounts* counts = scriptCounts_;
    scriptCounts_ = nullptr;  // prevent delete in dtor
    return counts;
  }

  void addGetPropertyCache(LInstruction* ins, LiveRegisterSet liveRegs,
                           TypedOrValueRegister value,
                           const ConstantOrRegister& id,
                           TypedOrValueRegister output, Register maybeTemp,
                           GetPropertyResultFlags flags);
  void addSetPropertyCache(LInstruction* ins, LiveRegisterSet liveRegs,
                           Register objReg, Register temp,
                           const ConstantOrRegister& id,
                           const ConstantOrRegister& value, bool strict,
                           bool needsPostBarrier, bool needsTypeBarrier,
                           bool guardHoles);

  MOZ_MUST_USE bool generateBranchV(const ValueOperand& value, Label* ifTrue,
                                    Label* ifFalse, FloatRegister fr);

  void emitLambdaInit(Register resultReg, Register envChainReg,
                      const LambdaFunctionInfo& info);

  void emitFilterArgumentsOrEval(LInstruction* lir, Register string,
                                 Register temp1, Register temp2);

  template <class IteratorObject, class OrderedHashTable>
  void emitGetNextEntryForIterator(LGetNextEntryForIterator* lir);

  template <class OrderedHashTable>
  void emitLoadIteratorValues(Register result, Register temp, Register front);

  void emitStringToInt64(LInstruction* lir, Register input, Register64 output);

  void emitCreateBigInt(LInstruction* lir, Scalar::Type type, Register64 input,
                        Register output, Register maybeTemp);

  template <size_t NumDefs>
  void emitIonToWasmCallBase(LIonToWasmCallBase<NumDefs>* lir);

  IonScriptCounts* maybeCreateScriptCounts();

  // This function behaves like testValueTruthy with the exception that it can
  // choose to let control flow fall through when the object is truthy, as
  // an optimization. Use testValueTruthy when it's required to branch to one
  // of the two labels.
  void testValueTruthyKernel(const ValueOperand& value,
                             const LDefinition* scratch1,
                             const LDefinition* scratch2, FloatRegister fr,
                             Label* ifTruthy, Label* ifFalsy,
                             OutOfLineTestObject* ool, MDefinition* valueMIR);

  // Test whether value is truthy or not and jump to the corresponding label.
  // If the value can be an object that emulates |undefined|, |ool| must be
  // non-null; otherwise it may be null (and the scratch definitions should
  // be bogus), in which case an object encountered here will always be
  // truthy.
  void testValueTruthy(const ValueOperand& value, const LDefinition* scratch1,
                       const LDefinition* scratch2, FloatRegister fr,
                       Label* ifTruthy, Label* ifFalsy,
                       OutOfLineTestObject* ool, MDefinition* valueMIR);

  // This function behaves like testObjectEmulatesUndefined with the exception
  // that it can choose to let control flow fall through when the object
  // doesn't emulate undefined, as an optimization. Use the regular
  // testObjectEmulatesUndefined when it's required to branch to one of the
  // two labels.
  void testObjectEmulatesUndefinedKernel(Register objreg,
                                         Label* ifEmulatesUndefined,
                                         Label* ifDoesntEmulateUndefined,
                                         Register scratch,
                                         OutOfLineTestObject* ool);

  // Test whether an object emulates |undefined|.  If it does, jump to
  // |ifEmulatesUndefined|; the caller is responsible for binding this label.
  // If it doesn't, fall through; the label |ifDoesntEmulateUndefined| (which
  // must be initially unbound) will be bound at this point.
  void branchTestObjectEmulatesUndefined(Register objreg,
                                         Label* ifEmulatesUndefined,
                                         Label* ifDoesntEmulateUndefined,
                                         Register scratch,
                                         OutOfLineTestObject* ool);

  // Test whether an object emulates |undefined|, and jump to the
  // corresponding label.
  //
  // This method should be used when subsequent code can't be laid out in a
  // straight line; if it can, branchTest* should be used instead.
  void testObjectEmulatesUndefined(Register objreg, Label* ifEmulatesUndefined,
                                   Label* ifDoesntEmulateUndefined,
                                   Register scratch, OutOfLineTestObject* ool);

  void emitStoreElementTyped(const LAllocation* value, MIRType valueType,
                             MIRType elementType, Register elements,
                             const LAllocation* index);

  // Bailout if an element about to be written to is a hole.
  void emitStoreHoleCheck(Register elements, const LAllocation* index,
                          LSnapshot* snapshot);

  void emitAssertRangeI(const Range* r, Register input);
  void emitAssertRangeD(const Range* r, FloatRegister input,
                        FloatRegister temp);

  void maybeEmitGlobalBarrierCheck(const LAllocation* maybeGlobal,
                                   OutOfLineCode* ool);

  Vector<CodeOffset, 0, JitAllocPolicy> ionScriptLabels_;

  void branchIfInvalidated(Register temp, Label* invalidated);

#ifdef DEBUG
  void emitDebugResultChecks(LInstruction* ins);
  void emitGCThingResultChecks(LInstruction* lir, MDefinition* mir);
  void emitValueResultChecks(LInstruction* lir, MDefinition* mir);
#endif

  // Script counts created during code generation.
  IonScriptCounts* scriptCounts_;

#if defined(JS_ION_PERF)
  PerfSpewer perfSpewer_;
#endif

  // Bit mask of JitRealm stubs that are to be read-barriered.
  uint32_t realmStubsToReadBarrier_;

#define LIR_OP(op) void visit##op(L##op* ins);
  LIR_OPCODE_LIST(LIR_OP)
#undef LIR_OP
};

}  // namespace jit
}  // namespace js

#endif /* jit_CodeGenerator_h */
