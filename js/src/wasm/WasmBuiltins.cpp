/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 *
 * Copyright 2017 Mozilla Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "wasm/WasmBuiltins.h"

#include "mozilla/Atomics.h"

#include "fdlibm.h"
#include "jslibmath.h"

#include "gc/Allocator.h"
#include "jit/AtomicOperations.h"
#include "jit/InlinableNatives.h"
#include "jit/MacroAssembler.h"
#include "jit/Simulator.h"
#include "threading/Mutex.h"
#include "util/Memory.h"
#include "util/Poison.h"
#include "vm/BigIntType.h"
#include "wasm/WasmInstance.h"
#include "wasm/WasmStubs.h"
#include "wasm/WasmTypes.h"

#include "debugger/DebugAPI-inl.h"
#include "vm/Stack-inl.h"

using namespace js;
using namespace jit;
using namespace wasm;

using mozilla::HashGeneric;
using mozilla::IsNaN;
using mozilla::MakeEnumeratedRange;

static const unsigned BUILTIN_THUNK_LIFO_SIZE = 64 * 1024;

// ============================================================================
// WebAssembly builtin C++ functions called from wasm code to implement internal
// wasm operations: type descriptions.

// Some abbreviations, for the sake of conciseness.
#define _F64 MIRType::Double
#define _F32 MIRType::Float32
#define _I32 MIRType::Int32
#define _I64 MIRType::Int64
#define _PTR MIRType::Pointer
#define _RoN MIRType::RefOrNull
#define _VOID MIRType::None
#define _END MIRType::None
#define _Infallible FailureMode::Infallible
#define _FailOnNegI32 FailureMode::FailOnNegI32
#define _FailOnNullPtr FailureMode::FailOnNullPtr
#define _FailOnInvalidRef FailureMode::FailOnInvalidRef

namespace js {
namespace wasm {

const SymbolicAddressSignature SASigSinD = {
    SymbolicAddress::SinD, _F64, _Infallible, 1, {_F64, _END}};
const SymbolicAddressSignature SASigCosD = {
    SymbolicAddress::CosD, _F64, _Infallible, 1, {_F64, _END}};
const SymbolicAddressSignature SASigTanD = {
    SymbolicAddress::TanD, _F64, _Infallible, 1, {_F64, _END}};
const SymbolicAddressSignature SASigASinD = {
    SymbolicAddress::ASinD, _F64, _Infallible, 1, {_F64, _END}};
const SymbolicAddressSignature SASigACosD = {
    SymbolicAddress::ACosD, _F64, _Infallible, 1, {_F64, _END}};
const SymbolicAddressSignature SASigATanD = {
    SymbolicAddress::ATanD, _F64, _Infallible, 1, {_F64, _END}};
const SymbolicAddressSignature SASigCeilD = {
    SymbolicAddress::CeilD, _F64, _Infallible, 1, {_F64, _END}};
const SymbolicAddressSignature SASigCeilF = {
    SymbolicAddress::CeilF, _F32, _Infallible, 1, {_F32, _END}};
const SymbolicAddressSignature SASigFloorD = {
    SymbolicAddress::FloorD, _F64, _Infallible, 1, {_F64, _END}};
const SymbolicAddressSignature SASigFloorF = {
    SymbolicAddress::FloorF, _F32, _Infallible, 1, {_F32, _END}};
const SymbolicAddressSignature SASigTruncD = {
    SymbolicAddress::TruncD, _F64, _Infallible, 1, {_F64, _END}};
const SymbolicAddressSignature SASigTruncF = {
    SymbolicAddress::TruncF, _F32, _Infallible, 1, {_F32, _END}};
const SymbolicAddressSignature SASigNearbyIntD = {
    SymbolicAddress::NearbyIntD, _F64, _Infallible, 1, {_F64, _END}};
const SymbolicAddressSignature SASigNearbyIntF = {
    SymbolicAddress::NearbyIntF, _F32, _Infallible, 1, {_F32, _END}};
const SymbolicAddressSignature SASigExpD = {
    SymbolicAddress::ExpD, _F64, _Infallible, 1, {_F64, _END}};
const SymbolicAddressSignature SASigLogD = {
    SymbolicAddress::LogD, _F64, _Infallible, 1, {_F64, _END}};
const SymbolicAddressSignature SASigPowD = {
    SymbolicAddress::PowD, _F64, _Infallible, 2, {_F64, _F64, _END}};
const SymbolicAddressSignature SASigATan2D = {
    SymbolicAddress::ATan2D, _F64, _Infallible, 2, {_F64, _F64, _END}};
const SymbolicAddressSignature SASigMemoryGrow = {
    SymbolicAddress::MemoryGrow, _I32, _Infallible, 2, {_PTR, _I32, _END}};
const SymbolicAddressSignature SASigMemorySize = {
    SymbolicAddress::MemorySize, _I32, _Infallible, 1, {_PTR, _END}};
const SymbolicAddressSignature SASigWaitI32 = {SymbolicAddress::WaitI32,
                                               _I32,
                                               _FailOnNegI32,
                                               4,
                                               {_PTR, _I32, _I32, _I64, _END}};
const SymbolicAddressSignature SASigWaitI64 = {SymbolicAddress::WaitI64,
                                               _I32,
                                               _FailOnNegI32,
                                               4,
                                               {_PTR, _I32, _I64, _I64, _END}};
const SymbolicAddressSignature SASigWake = {
    SymbolicAddress::Wake, _I32, _FailOnNegI32, 3, {_PTR, _I32, _I32, _END}};
const SymbolicAddressSignature SASigMemCopy = {
    SymbolicAddress::MemCopy,
    _VOID,
    _FailOnNegI32,
    5,
    {_PTR, _I32, _I32, _I32, _PTR, _END}};
const SymbolicAddressSignature SASigMemCopyShared = {
    SymbolicAddress::MemCopyShared,
    _VOID,
    _FailOnNegI32,
    5,
    {_PTR, _I32, _I32, _I32, _PTR, _END}};
const SymbolicAddressSignature SASigDataDrop = {
    SymbolicAddress::DataDrop, _VOID, _FailOnNegI32, 2, {_PTR, _I32, _END}};
const SymbolicAddressSignature SASigMemFill = {
    SymbolicAddress::MemFill,
    _VOID,
    _FailOnNegI32,
    5,
    {_PTR, _I32, _I32, _I32, _PTR, _END}};
const SymbolicAddressSignature SASigMemFillShared = {
    SymbolicAddress::MemFillShared,
    _VOID,
    _FailOnNegI32,
    5,
    {_PTR, _I32, _I32, _I32, _PTR, _END}};
const SymbolicAddressSignature SASigMemInit = {
    SymbolicAddress::MemInit,
    _VOID,
    _FailOnNegI32,
    5,
    {_PTR, _I32, _I32, _I32, _I32, _END}};
const SymbolicAddressSignature SASigTableCopy = {
    SymbolicAddress::TableCopy,
    _VOID,
    _FailOnNegI32,
    6,
    {_PTR, _I32, _I32, _I32, _I32, _I32, _END}};
const SymbolicAddressSignature SASigElemDrop = {
    SymbolicAddress::ElemDrop, _VOID, _FailOnNegI32, 2, {_PTR, _I32, _END}};
const SymbolicAddressSignature SASigTableFill = {
    SymbolicAddress::TableFill,
    _VOID,
    _FailOnNegI32,
    5,
    {_PTR, _I32, _RoN, _I32, _I32, _END}};
const SymbolicAddressSignature SASigTableGet = {SymbolicAddress::TableGet,
                                                _RoN,
                                                _FailOnInvalidRef,
                                                3,
                                                {_PTR, _I32, _I32, _END}};
const SymbolicAddressSignature SASigTableGrow = {
    SymbolicAddress::TableGrow,
    _I32,
    _Infallible,
    4,
    {_PTR, _RoN, _I32, _I32, _END}};
const SymbolicAddressSignature SASigTableInit = {
    SymbolicAddress::TableInit,
    _VOID,
    _FailOnNegI32,
    6,
    {_PTR, _I32, _I32, _I32, _I32, _I32, _END}};
const SymbolicAddressSignature SASigTableSet = {SymbolicAddress::TableSet,
                                                _VOID,
                                                _FailOnNegI32,
                                                4,
                                                {_PTR, _I32, _RoN, _I32, _END}};
const SymbolicAddressSignature SASigTableSize = {
    SymbolicAddress::TableSize, _I32, _Infallible, 2, {_PTR, _I32, _END}};
const SymbolicAddressSignature SASigRefFunc = {
    SymbolicAddress::RefFunc, _RoN, _FailOnInvalidRef, 2, {_PTR, _I32, _END}};
const SymbolicAddressSignature SASigPreBarrierFiltering = {
    SymbolicAddress::PreBarrierFiltering,
    _VOID,
    _Infallible,
    2,
    {_PTR, _PTR, _END}};
const SymbolicAddressSignature SASigPostBarrier = {
    SymbolicAddress::PostBarrier, _VOID, _Infallible, 2, {_PTR, _PTR, _END}};
const SymbolicAddressSignature SASigPostBarrierFiltering = {
    SymbolicAddress::PostBarrierFiltering,
    _VOID,
    _Infallible,
    2,
    {_PTR, _PTR, _END}};
const SymbolicAddressSignature SASigStructNew = {
    SymbolicAddress::StructNew, _RoN, _FailOnNullPtr, 2, {_PTR, _I32, _END}};
const SymbolicAddressSignature SASigStructNarrow = {
    SymbolicAddress::StructNarrow,
    _RoN,
    _Infallible,
    4,
    {_PTR, _I32, _I32, _RoN, _END}};

}  // namespace wasm
}  // namespace js

#undef _F64
#undef _F32
#undef _I32
#undef _I64
#undef _PTR
#undef _RoN
#undef _VOID
#undef _END
#undef _Infallible
#undef _FailOnNegI32
#undef _FailOnNullPtr

#ifdef DEBUG
ABIArgType ToABIType(FailureMode mode) {
  switch (mode) {
    case FailureMode::FailOnNegI32:
      return ArgType_Int32;
    case FailureMode::FailOnNullPtr:
    case FailureMode::FailOnInvalidRef:
      return ArgType_General;
    default:
      MOZ_CRASH("unexpected failure mode");
  }
}

ABIArgType ToABIType(MIRType type) {
  switch (type) {
    case MIRType::None:
    case MIRType::Int32:
      return ArgType_Int32;
    case MIRType::Int64:
      return ArgType_Int64;
    case MIRType::Pointer:
    case MIRType::RefOrNull:
      return ArgType_General;
    case MIRType::Float32:
      return ArgType_Float32;
    case MIRType::Double:
      return ArgType_Float64;
    default:
      MOZ_CRASH("unexpected type");
  }
}

ABIFunctionType ToABIType(const SymbolicAddressSignature& sig) {
  MOZ_ASSERT_IF(sig.failureMode != FailureMode::Infallible,
                ToABIType(sig.failureMode) == ToABIType(sig.retType));
  int abiType = ToABIType(sig.retType) << RetType_Shift;
  for (int i = 0; i < sig.numArgs; i++) {
    abiType |= (ToABIType(sig.argTypes[i]) << (ArgType_Shift * (i + 1)));
  }
  return ABIFunctionType(abiType);
}
#endif

// ============================================================================
// WebAssembly builtin C++ functions called from wasm code to implement internal
// wasm operations: implementations.

#if defined(JS_CODEGEN_ARM)
extern "C" {

extern MOZ_EXPORT int64_t __aeabi_idivmod(int, int);

extern MOZ_EXPORT int64_t __aeabi_uidivmod(int, int);
}
#endif

// This utility function can only be called for builtins that are called
// directly from wasm code.
static JitActivation* CallingActivation() {
  Activation* act = TlsContext.get()->activation();
  MOZ_ASSERT(act->asJit()->hasWasmExitFP());
  return act->asJit();
}

static bool WasmHandleDebugTrap() {
  JitActivation* activation = CallingActivation();
  JSContext* cx = activation->cx();
  Frame* fp = activation->wasmExitFP();
  Instance* instance = fp->tls->instance;
  const Code& code = instance->code();
  MOZ_ASSERT(code.metadata().debugEnabled);

  // The debug trap stub is the innermost frame. It's return address is the
  // actual trap site.
  const CallSite* site = code.lookupCallSite(fp->returnAddress);
  MOZ_ASSERT(site);

  // Advance to the actual trapping frame.
  fp = fp->callerFP;
  DebugFrame* debugFrame = DebugFrame::from(fp);

  if (site->kind() == CallSite::EnterFrame) {
    if (!instance->debug().enterFrameTrapsEnabled()) {
      return true;
    }
    debugFrame->setIsDebuggee();
    debugFrame->observe(cx);
    if (!DebugAPI::onEnterFrame(cx, debugFrame)) {
      if (cx->isPropagatingForcedReturn()) {
        cx->clearPropagatingForcedReturn();
        // Ignoring forced return because changing code execution order is
        // not yet implemented in the wasm baseline.
        // TODO properly handle forced return and resume wasm execution.
        JS_ReportErrorASCII(cx,
                            "Unexpected resumption value from onEnterFrame");
      }
      return false;
    }
    return true;
  }
  if (site->kind() == CallSite::LeaveFrame) {
    if (!debugFrame->updateReturnJSValue(cx)) {
      return false;
    }
    bool ok = DebugAPI::onLeaveFrame(cx, debugFrame, nullptr, true);
    debugFrame->leave(cx);
    return ok;
  }

  DebugState& debug = instance->debug();
  MOZ_ASSERT(debug.hasBreakpointTrapAtOffset(site->lineOrBytecode()));
  if (debug.stepModeEnabled(debugFrame->funcIndex())) {
    if (!DebugAPI::onSingleStep(cx)) {
      if (cx->isPropagatingForcedReturn()) {
        cx->clearPropagatingForcedReturn();
        // TODO properly handle forced return.
        JS_ReportErrorASCII(cx,
                            "Unexpected resumption value from onSingleStep");
      }
      return false;
    }
  }
  if (debug.hasBreakpointSite(site->lineOrBytecode())) {
    if (!DebugAPI::onTrap(cx)) {
      if (cx->isPropagatingForcedReturn()) {
        cx->clearPropagatingForcedReturn();
        // TODO properly handle forced return.
        JS_ReportErrorASCII(
            cx, "Unexpected resumption value from breakpoint handler");
      }
      return false;
    }
  }
  return true;
}

// Unwind the entire activation in response to a thrown exception. This function
// is responsible for notifying the debugger of each unwound frame. The return
// value is the new stack address which the calling stub will set to the sp
// register before executing a return instruction.

void* wasm::HandleThrow(JSContext* cx, WasmFrameIter& iter) {
  // WasmFrameIter iterates down wasm frames in the activation starting at
  // JitActivation::wasmExitFP(). Calling WasmFrameIter::startUnwinding pops
  // JitActivation::wasmExitFP() once each time WasmFrameIter is incremented,
  // ultimately leaving exit FP null when the WasmFrameIter is done().  This
  // is necessary to prevent a DebugFrame from being observed again after we
  // just called onLeaveFrame (which would lead to the frame being re-added
  // to the map of live frames, right as it becomes trash).

  MOZ_ASSERT(CallingActivation() == iter.activation());
  MOZ_ASSERT(!iter.done());
  iter.setUnwind(WasmFrameIter::Unwind::True);

  // Live wasm code on the stack is kept alive (in TraceJitActivation) by
  // marking the instance of every wasm::Frame found by WasmFrameIter.
  // However, as explained above, we're popping frames while iterating which
  // means that a GC during this loop could collect the code of frames whose
  // code is still on the stack. This is actually mostly fine: as soon as we
  // return to the throw stub, the entire stack will be popped as a whole,
  // returning to the C++ caller. However, we must keep the throw stub alive
  // itself which is owned by the innermost instance.
  RootedWasmInstanceObject keepAlive(cx, iter.instance()->object());

  for (; !iter.done(); ++iter) {
    // Wasm code can enter same-compartment realms, so reset cx->realm to
    // this frame's realm.
    cx->setRealmForJitExceptionHandler(iter.instance()->realm());

    if (!iter.debugEnabled()) {
      continue;
    }

    DebugFrame* frame = iter.debugFrame();
    frame->clearReturnJSValue();

    // Assume ResumeMode::Terminate if no exception is pending --
    // no onExceptionUnwind handlers must be fired.
    if (cx->isExceptionPending()) {
      if (!DebugAPI::onExceptionUnwind(cx, frame)) {
        if (cx->isPropagatingForcedReturn()) {
          cx->clearPropagatingForcedReturn();
          // Unexpected trap return -- raising error since throw recovery
          // is not yet implemented in the wasm baseline.
          // TODO properly handle forced return and resume wasm execution.
          JS_ReportErrorASCII(
              cx, "Unexpected resumption value from onExceptionUnwind");
        }
      }
    }

    bool ok = DebugAPI::onLeaveFrame(cx, frame, nullptr, false);
    if (ok) {
      // Unexpected success from the handler onLeaveFrame -- raising error
      // since throw recovery is not yet implemented in the wasm baseline.
      // TODO properly handle success and resume wasm execution.
      JS_ReportErrorASCII(cx, "Unexpected success from onLeaveFrame");
    }
    frame->leave(cx);
  }

  MOZ_ASSERT(!cx->activation()->asJit()->isWasmTrapping(),
             "unwinding clears the trapping state");

  return iter.unwoundAddressOfReturnAddress();
}

static void* WasmHandleThrow() {
  JitActivation* activation = CallingActivation();
  JSContext* cx = activation->cx();
  WasmFrameIter iter(activation);
  return HandleThrow(cx, iter);
}

// Unconditionally returns nullptr per calling convention of HandleTrap().
static void* ReportError(JSContext* cx, unsigned errorNumber) {
  JS_ReportErrorNumberUTF8(cx, GetErrorMessage, nullptr, errorNumber);
  return nullptr;
};

// Has the same return-value convention as HandleTrap().
static void* CheckInterrupt(JSContext* cx, JitActivation* activation) {
  ResetInterruptState(cx);

  if (!CheckForInterrupt(cx)) {
    return nullptr;
  }

  void* resumePC = activation->wasmTrapData().resumePC;
  activation->finishWasmTrap();
  return resumePC;
}

// The calling convention between this function and its caller in the stub
// generated by GenerateTrapExit() is:
//   - return nullptr if the stub should jump to the throw stub to unwind
//     the activation;
//   - return the (non-null) resumePC that should be jumped if execution should
//     resume after the trap.
static void* WasmHandleTrap() {
  JitActivation* activation = CallingActivation();
  JSContext* cx = activation->cx();

  switch (activation->wasmTrapData().trap) {
    case Trap::Unreachable:
      return ReportError(cx, JSMSG_WASM_UNREACHABLE);
    case Trap::IntegerOverflow:
      return ReportError(cx, JSMSG_WASM_INTEGER_OVERFLOW);
    case Trap::InvalidConversionToInteger:
      return ReportError(cx, JSMSG_WASM_INVALID_CONVERSION);
    case Trap::IntegerDivideByZero:
      return ReportError(cx, JSMSG_WASM_INT_DIVIDE_BY_ZERO);
    case Trap::IndirectCallToNull:
      return ReportError(cx, JSMSG_WASM_IND_CALL_TO_NULL);
    case Trap::IndirectCallBadSig:
      return ReportError(cx, JSMSG_WASM_IND_CALL_BAD_SIG);
    case Trap::NullPointerDereference:
      return ReportError(cx, JSMSG_WASM_DEREF_NULL);
    case Trap::OutOfBounds:
      return ReportError(cx, JSMSG_WASM_OUT_OF_BOUNDS);
    case Trap::UnalignedAccess:
      return ReportError(cx, JSMSG_WASM_UNALIGNED_ACCESS);
    case Trap::CheckInterrupt:
      return CheckInterrupt(cx, activation);
    case Trap::StackOverflow:
      // TlsData::setInterrupt() causes a fake stack overflow. Since
      // TlsData::setInterrupt() is called racily, it's possible for a real
      // stack overflow to trap, followed by a racy call to setInterrupt().
      // Thus, we must check for a real stack overflow first before we
      // CheckInterrupt() and possibly resume execution.
      if (!CheckRecursionLimit(cx)) {
        return nullptr;
      }
      if (activation->wasmExitFP()->tls->isInterrupted()) {
        return CheckInterrupt(cx, activation);
      }
      return ReportError(cx, JSMSG_OVER_RECURSED);
    case Trap::ThrowReported:
      // Error was already reported under another name.
      return nullptr;
    case Trap::Limit:
      break;
  }

  MOZ_CRASH("unexpected trap");
}

static void WasmReportV128JSCall() {
  JSContext* cx = TlsContext.get();
  JS_ReportErrorNumberUTF8(cx, GetErrorMessage, nullptr,
                           JSMSG_WASM_BAD_VAL_TYPE);
}

static int32_t CoerceInPlace_ToInt32(Value* rawVal) {
  JSContext* cx = TlsContext.get();

  int32_t i32;
  RootedValue val(cx, *rawVal);
  if (!ToInt32(cx, val, &i32)) {
    *rawVal = PoisonedObjectValue(0x42);
    return false;
  }

  *rawVal = Int32Value(i32);
  return true;
}

static int32_t CoerceInPlace_ToBigInt(Value* rawVal) {
  JSContext* cx = TlsContext.get();

  RootedValue val(cx, *rawVal);
  BigInt* bi = ToBigInt(cx, val);
  if (!bi) {
    *rawVal = PoisonedObjectValue(0x43);
    return false;
  }

  *rawVal = BigIntValue(bi);
  return true;
}

static int32_t CoerceInPlace_ToNumber(Value* rawVal) {
  JSContext* cx = TlsContext.get();

  double dbl;
  RootedValue val(cx, *rawVal);
  if (!ToNumber(cx, val, &dbl)) {
    *rawVal = PoisonedObjectValue(0x42);
    return false;
  }

  *rawVal = DoubleValue(dbl);
  return true;
}

static void* BoxValue_Anyref(Value* rawVal) {
  JSContext* cx = TlsContext.get();
  RootedValue val(cx, *rawVal);
  RootedAnyRef result(cx, AnyRef::null());
  if (!BoxAnyRef(cx, val, &result)) {
    return nullptr;
  }
  return result.get().forCompiledCode();
}

static int32_t CoerceInPlace_JitEntry(int funcExportIndex, TlsData* tlsData,
                                      Value* argv) {
  JSContext* cx = CallingActivation()->cx();

  const Code& code = tlsData->instance->code();
  const FuncExport& fe =
      code.metadata(code.stableTier()).funcExports[funcExportIndex];

  for (size_t i = 0; i < fe.funcType().args().length(); i++) {
    HandleValue arg = HandleValue::fromMarkedLocation(&argv[i]);
    switch (fe.funcType().args()[i].kind()) {
      case ValType::I32: {
        int32_t i32;
        if (!ToInt32(cx, arg, &i32)) {
          return false;
        }
        argv[i] = Int32Value(i32);
        break;
      }
      case ValType::I64: {
        // In this case we store a BigInt value as there is no value type
        // corresponding directly to an I64. The conversion to I64 happens
        // in the JIT entry stub.
        BigInt* bigint = ToBigInt(cx, arg);
        if (!bigint) {
          return false;
        }
        argv[i] = BigIntValue(bigint);
        break;
      }
      case ValType::F32:
      case ValType::F64: {
        double dbl;
        if (!ToNumber(cx, arg, &dbl)) {
          return false;
        }
        // No need to convert double-to-float for f32, it's done inline
        // in the wasm stub later.
        argv[i] = DoubleValue(dbl);
        break;
      }
      case ValType::Ref: {
        switch (fe.funcType().args()[i].refTypeKind()) {
          case RefType::Any:
            // Leave Object and Null alone, we will unbox inline.  All we need
            // to do is convert other values to an Object representation.
            if (!arg.isObjectOrNull()) {
              RootedAnyRef result(cx, AnyRef::null());
              if (!BoxAnyRef(cx, arg, &result)) {
                return false;
              }
              argv[i].setObject(*result.get().asJSObject());
            }
            break;
          case RefType::Func:
          case RefType::TypeIndex:
            // Guarded against by temporarilyUnsupportedReftypeForEntry()
            MOZ_CRASH("unexpected input argument in CoerceInPlace_JitEntry");
        }
        break;
      }
      case ValType::V128: {
        // Guarded against by hasV128ArgOrRet()
        MOZ_CRASH("unexpected input argument in CoerceInPlace_JitEntry");
      }
      default: {
        MOZ_CRASH("unexpected input argument in CoerceInPlace_JitEntry");
      }
    }
  }

  return true;
}

// Allocate a BigInt without GC, corresponds to the similar VMFunction.
static BigInt* AllocateBigIntTenuredNoGC() {
  JSContext* cx = TlsContext.get();

  return js::AllocateBigInt<NoGC>(cx, gc::TenuredHeap);
}

static int64_t DivI64(uint32_t x_hi, uint32_t x_lo, uint32_t y_hi,
                      uint32_t y_lo) {
  int64_t x = ((uint64_t)x_hi << 32) + x_lo;
  int64_t y = ((uint64_t)y_hi << 32) + y_lo;
  MOZ_ASSERT(x != INT64_MIN || y != -1);
  MOZ_ASSERT(y != 0);
  return x / y;
}

static int64_t UDivI64(uint32_t x_hi, uint32_t x_lo, uint32_t y_hi,
                       uint32_t y_lo) {
  uint64_t x = ((uint64_t)x_hi << 32) + x_lo;
  uint64_t y = ((uint64_t)y_hi << 32) + y_lo;
  MOZ_ASSERT(y != 0);
  return x / y;
}

static int64_t ModI64(uint32_t x_hi, uint32_t x_lo, uint32_t y_hi,
                      uint32_t y_lo) {
  int64_t x = ((uint64_t)x_hi << 32) + x_lo;
  int64_t y = ((uint64_t)y_hi << 32) + y_lo;
  MOZ_ASSERT(x != INT64_MIN || y != -1);
  MOZ_ASSERT(y != 0);
  return x % y;
}

static int64_t UModI64(uint32_t x_hi, uint32_t x_lo, uint32_t y_hi,
                       uint32_t y_lo) {
  uint64_t x = ((uint64_t)x_hi << 32) + x_lo;
  uint64_t y = ((uint64_t)y_hi << 32) + y_lo;
  MOZ_ASSERT(y != 0);
  return x % y;
}

static int64_t TruncateDoubleToInt64(double input) {
  // Note: INT64_MAX is not representable in double. It is actually
  // INT64_MAX + 1.  Therefore also sending the failure value.
  if (input >= double(INT64_MAX) || input < double(INT64_MIN) || IsNaN(input)) {
    return 0x8000000000000000;
  }
  return int64_t(input);
}

static uint64_t TruncateDoubleToUint64(double input) {
  // Note: UINT64_MAX is not representable in double. It is actually
  // UINT64_MAX + 1.  Therefore also sending the failure value.
  if (input >= double(UINT64_MAX) || input <= -1.0 || IsNaN(input)) {
    return 0x8000000000000000;
  }
  return uint64_t(input);
}

static int64_t SaturatingTruncateDoubleToInt64(double input) {
  // Handle in-range values (except INT64_MIN).
  if (fabs(input) < -double(INT64_MIN)) {
    return int64_t(input);
  }
  // Handle NaN.
  if (IsNaN(input)) {
    return 0;
  }
  // Handle positive overflow.
  if (input > 0) {
    return INT64_MAX;
  }
  // Handle negative overflow.
  return INT64_MIN;
}

static uint64_t SaturatingTruncateDoubleToUint64(double input) {
  // Handle positive overflow.
  if (input >= -double(INT64_MIN) * 2.0) {
    return UINT64_MAX;
  }
  // Handle in-range values.
  if (input > -1.0) {
    return uint64_t(input);
  }
  // Handle NaN and negative overflow.
  return 0;
}

static double Int64ToDouble(int32_t x_hi, uint32_t x_lo) {
  int64_t x = int64_t((uint64_t(x_hi) << 32)) + int64_t(x_lo);
  return double(x);
}

static float Int64ToFloat32(int32_t x_hi, uint32_t x_lo) {
  int64_t x = int64_t((uint64_t(x_hi) << 32)) + int64_t(x_lo);
  return float(x);
}

static double Uint64ToDouble(int32_t x_hi, uint32_t x_lo) {
  uint64_t x = (uint64_t(x_hi) << 32) + uint64_t(x_lo);
  return double(x);
}

static float Uint64ToFloat32(int32_t x_hi, uint32_t x_lo) {
  uint64_t x = (uint64_t(x_hi) << 32) + uint64_t(x_lo);
  return float(x);
}

template <class F>
static inline void* FuncCast(F* funcPtr, ABIFunctionType abiType) {
  void* pf = JS_FUNC_TO_DATA_PTR(void*, funcPtr);
#ifdef JS_SIMULATOR
  pf = Simulator::RedirectNativeFunction(pf, abiType);
#endif
  return pf;
}

#ifdef WASM_CODEGEN_DEBUG
void wasm::PrintI32(int32_t val) { fprintf(stderr, "i32(%d) ", val); }

void wasm::PrintPtr(uint8_t* val) { fprintf(stderr, "ptr(%p) ", val); }

void wasm::PrintF32(float val) { fprintf(stderr, "f32(%f) ", val); }

void wasm::PrintF64(double val) { fprintf(stderr, "f64(%lf) ", val); }

void wasm::PrintText(const char* out) { fprintf(stderr, "%s", out); }
#endif

void* wasm::AddressOf(SymbolicAddress imm, ABIFunctionType* abiType) {
  switch (imm) {
    case SymbolicAddress::HandleDebugTrap:
      *abiType = Args_General0;
      return FuncCast(WasmHandleDebugTrap, *abiType);
    case SymbolicAddress::HandleThrow:
      *abiType = Args_General0;
      return FuncCast(WasmHandleThrow, *abiType);
    case SymbolicAddress::HandleTrap:
      *abiType = Args_General0;
      return FuncCast(WasmHandleTrap, *abiType);
    case SymbolicAddress::ReportV128JSCall:
      *abiType = Args_General0;
      return FuncCast(WasmReportV128JSCall, *abiType);
    case SymbolicAddress::CallImport_Void:
      *abiType = MakeABIFunctionType(
          ArgType_Int32,
          {ArgType_General, ArgType_Int32, ArgType_Int32, ArgType_General});
      return FuncCast(Instance::callImport_void, *abiType);
    case SymbolicAddress::CallImport_I32:
      *abiType = MakeABIFunctionType(
          ArgType_Int32,
          {ArgType_General, ArgType_Int32, ArgType_Int32, ArgType_General});
      return FuncCast(Instance::callImport_i32, *abiType);
    case SymbolicAddress::CallImport_I64:
      *abiType = MakeABIFunctionType(
          ArgType_Int32,
          {ArgType_General, ArgType_Int32, ArgType_Int32, ArgType_General});
      return FuncCast(Instance::callImport_i64, *abiType);
    case SymbolicAddress::CallImport_V128:
      *abiType = Args_General4;
      return FuncCast(Instance::callImport_v128, *abiType);
    case SymbolicAddress::CallImport_F64:
      *abiType = MakeABIFunctionType(
          ArgType_Int32,
          {ArgType_General, ArgType_Int32, ArgType_Int32, ArgType_General});
      return FuncCast(Instance::callImport_f64, *abiType);
    case SymbolicAddress::CallImport_FuncRef:
      *abiType = MakeABIFunctionType(
          ArgType_Int32,
          {ArgType_General, ArgType_Int32, ArgType_Int32, ArgType_General});
      return FuncCast(Instance::callImport_funcref, *abiType);
    case SymbolicAddress::CallImport_AnyRef:
      *abiType = MakeABIFunctionType(
          ArgType_Int32,
          {ArgType_General, ArgType_Int32, ArgType_Int32, ArgType_General});
      return FuncCast(Instance::callImport_anyref, *abiType);
    case SymbolicAddress::CoerceInPlace_ToInt32:
      *abiType = Args_General1;
      return FuncCast(CoerceInPlace_ToInt32, *abiType);
    case SymbolicAddress::CoerceInPlace_ToBigInt:
      *abiType = Args_General1;
      return FuncCast(CoerceInPlace_ToBigInt, *abiType);
    case SymbolicAddress::CoerceInPlace_ToNumber:
      *abiType = Args_General1;
      return FuncCast(CoerceInPlace_ToNumber, *abiType);
    case SymbolicAddress::CoerceInPlace_JitEntry:
      *abiType = Args_General3;
      return FuncCast(CoerceInPlace_JitEntry, *abiType);
    case SymbolicAddress::ToInt32:
      *abiType = Args_Int_Double;
      return FuncCast<int32_t(double)>(JS::ToInt32, *abiType);
    case SymbolicAddress::BoxValue_Anyref:
      *abiType = Args_General1;
      return FuncCast(BoxValue_Anyref, *abiType);
    case SymbolicAddress::AllocateBigInt:
      *abiType = Args_General0;
      return FuncCast(AllocateBigIntTenuredNoGC, *abiType);
    case SymbolicAddress::DivI64:
      *abiType = Args_General4;
      return FuncCast(DivI64, *abiType);
    case SymbolicAddress::UDivI64:
      *abiType = Args_General4;
      return FuncCast(UDivI64, *abiType);
    case SymbolicAddress::ModI64:
      *abiType = Args_General4;
      return FuncCast(ModI64, *abiType);
    case SymbolicAddress::UModI64:
      *abiType = Args_General4;
      return FuncCast(UModI64, *abiType);
    case SymbolicAddress::TruncateDoubleToUint64:
      *abiType = Args_Int64_Double;
      return FuncCast(TruncateDoubleToUint64, *abiType);
    case SymbolicAddress::TruncateDoubleToInt64:
      *abiType = Args_Int64_Double;
      return FuncCast(TruncateDoubleToInt64, *abiType);
    case SymbolicAddress::SaturatingTruncateDoubleToUint64:
      *abiType = Args_Int64_Double;
      return FuncCast(SaturatingTruncateDoubleToUint64, *abiType);
    case SymbolicAddress::SaturatingTruncateDoubleToInt64:
      *abiType = Args_Int64_Double;
      return FuncCast(SaturatingTruncateDoubleToInt64, *abiType);
    case SymbolicAddress::Uint64ToDouble:
      *abiType = Args_Double_IntInt;
      return FuncCast(Uint64ToDouble, *abiType);
    case SymbolicAddress::Uint64ToFloat32:
      *abiType = Args_Float32_IntInt;
      return FuncCast(Uint64ToFloat32, *abiType);
    case SymbolicAddress::Int64ToDouble:
      *abiType = Args_Double_IntInt;
      return FuncCast(Int64ToDouble, *abiType);
    case SymbolicAddress::Int64ToFloat32:
      *abiType = Args_Float32_IntInt;
      return FuncCast(Int64ToFloat32, *abiType);
#if defined(JS_CODEGEN_ARM)
    case SymbolicAddress::aeabi_idivmod:
      *abiType = Args_General2;
      return FuncCast(__aeabi_idivmod, *abiType);
    case SymbolicAddress::aeabi_uidivmod:
      *abiType = Args_General2;
      return FuncCast(__aeabi_uidivmod, *abiType);
#endif
    case SymbolicAddress::ModD:
      *abiType = Args_Double_DoubleDouble;
      return FuncCast(NumberMod, *abiType);
    case SymbolicAddress::SinD:
      *abiType = Args_Double_Double;
      return FuncCast<double(double)>(sin, *abiType);
    case SymbolicAddress::CosD:
      *abiType = Args_Double_Double;
      return FuncCast<double(double)>(cos, *abiType);
    case SymbolicAddress::TanD:
      *abiType = Args_Double_Double;
      return FuncCast<double(double)>(tan, *abiType);
    case SymbolicAddress::ASinD:
      *abiType = Args_Double_Double;
      return FuncCast<double(double)>(fdlibm::asin, *abiType);
    case SymbolicAddress::ACosD:
      *abiType = Args_Double_Double;
      return FuncCast<double(double)>(fdlibm::acos, *abiType);
    case SymbolicAddress::ATanD:
      *abiType = Args_Double_Double;
      return FuncCast<double(double)>(fdlibm::atan, *abiType);
    case SymbolicAddress::CeilD:
      *abiType = Args_Double_Double;
      return FuncCast<double(double)>(fdlibm::ceil, *abiType);
    case SymbolicAddress::CeilF:
      *abiType = Args_Float32_Float32;
      return FuncCast<float(float)>(fdlibm::ceilf, *abiType);
    case SymbolicAddress::FloorD:
      *abiType = Args_Double_Double;
      return FuncCast<double(double)>(fdlibm::floor, *abiType);
    case SymbolicAddress::FloorF:
      *abiType = Args_Float32_Float32;
      return FuncCast<float(float)>(fdlibm::floorf, *abiType);
    case SymbolicAddress::TruncD:
      *abiType = Args_Double_Double;
      return FuncCast<double(double)>(fdlibm::trunc, *abiType);
    case SymbolicAddress::TruncF:
      *abiType = Args_Float32_Float32;
      return FuncCast<float(float)>(fdlibm::truncf, *abiType);
    case SymbolicAddress::NearbyIntD:
      *abiType = Args_Double_Double;
      return FuncCast<double(double)>(fdlibm::nearbyint, *abiType);
    case SymbolicAddress::NearbyIntF:
      *abiType = Args_Float32_Float32;
      return FuncCast<float(float)>(fdlibm::nearbyintf, *abiType);
    case SymbolicAddress::ExpD:
      *abiType = Args_Double_Double;
      return FuncCast<double(double)>(fdlibm::exp, *abiType);
    case SymbolicAddress::LogD:
      *abiType = Args_Double_Double;
      return FuncCast<double(double)>(fdlibm::log, *abiType);
    case SymbolicAddress::PowD:
      *abiType = Args_Double_DoubleDouble;
      return FuncCast(ecmaPow, *abiType);
    case SymbolicAddress::ATan2D:
      *abiType = Args_Double_DoubleDouble;
      return FuncCast(ecmaAtan2, *abiType);

    case SymbolicAddress::MemoryGrow:
      *abiType =
          MakeABIFunctionType(ArgType_Int32, {ArgType_General, ArgType_Int32});
      MOZ_ASSERT(*abiType == ToABIType(SASigMemoryGrow));
      return FuncCast(Instance::memoryGrow_i32, *abiType);
    case SymbolicAddress::MemorySize:
      *abiType = MakeABIFunctionType(ArgType_Int32, {ArgType_General});
      MOZ_ASSERT(*abiType == ToABIType(SASigMemorySize));
      return FuncCast(Instance::memorySize_i32, *abiType);
    case SymbolicAddress::WaitI32:
      *abiType = MakeABIFunctionType(
          ArgType_Int32,
          {ArgType_General, ArgType_Int32, ArgType_Int32, ArgType_Int64});
      MOZ_ASSERT(*abiType == ToABIType(SASigWaitI32));
      return FuncCast(Instance::wait_i32, *abiType);
    case SymbolicAddress::WaitI64:
      *abiType = MakeABIFunctionType(
          ArgType_Int32,
          {ArgType_General, ArgType_Int32, ArgType_Int64, ArgType_Int64});
      MOZ_ASSERT(*abiType == ToABIType(SASigWaitI64));
      return FuncCast(Instance::wait_i64, *abiType);
    case SymbolicAddress::Wake:
      *abiType = MakeABIFunctionType(
          ArgType_Int32, {ArgType_General, ArgType_Int32, ArgType_Int32});
      MOZ_ASSERT(*abiType == ToABIType(SASigWake));
      return FuncCast(Instance::wake, *abiType);
    case SymbolicAddress::MemCopy:
      *abiType = MakeABIFunctionType(
          ArgType_Int32, {ArgType_General, ArgType_Int32, ArgType_Int32,
                          ArgType_Int32, ArgType_General});
      MOZ_ASSERT(*abiType == ToABIType(SASigMemCopy));
      return FuncCast(Instance::memCopy, *abiType);
    case SymbolicAddress::MemCopyShared:
      *abiType = MakeABIFunctionType(
          ArgType_Int32, {ArgType_General, ArgType_Int32, ArgType_Int32,
                          ArgType_Int32, ArgType_General});
      MOZ_ASSERT(*abiType == ToABIType(SASigMemCopyShared));
      return FuncCast(Instance::memCopyShared, *abiType);
    case SymbolicAddress::DataDrop:
      *abiType =
          MakeABIFunctionType(ArgType_Int32, {ArgType_General, ArgType_Int32});
      MOZ_ASSERT(*abiType == ToABIType(SASigDataDrop));
      return FuncCast(Instance::dataDrop, *abiType);
    case SymbolicAddress::MemFill:
      *abiType = MakeABIFunctionType(
          ArgType_Int32, {ArgType_General, ArgType_Int32, ArgType_Int32,
                          ArgType_Int32, ArgType_General});
      MOZ_ASSERT(*abiType == ToABIType(SASigMemFill));
      return FuncCast(Instance::memFill, *abiType);
    case SymbolicAddress::MemFillShared:
      *abiType = MakeABIFunctionType(
          ArgType_Int32, {ArgType_General, ArgType_Int32, ArgType_Int32,
                          ArgType_Int32, ArgType_General});
      MOZ_ASSERT(*abiType == ToABIType(SASigMemFillShared));
      return FuncCast(Instance::memFillShared, *abiType);
    case SymbolicAddress::MemInit:
      *abiType = MakeABIFunctionType(
          ArgType_Int32, {ArgType_General, ArgType_Int32, ArgType_Int32,
                          ArgType_Int32, ArgType_Int32});
      MOZ_ASSERT(*abiType == ToABIType(SASigMemInit));
      return FuncCast(Instance::memInit, *abiType);
    case SymbolicAddress::TableCopy:
      *abiType = MakeABIFunctionType(
          ArgType_Int32, {ArgType_General, ArgType_Int32, ArgType_Int32,
                          ArgType_Int32, ArgType_Int32, ArgType_Int32});
      MOZ_ASSERT(*abiType == ToABIType(SASigTableCopy));
      return FuncCast(Instance::tableCopy, *abiType);
    case SymbolicAddress::ElemDrop:
      *abiType =
          MakeABIFunctionType(ArgType_Int32, {ArgType_General, ArgType_Int32});
      MOZ_ASSERT(*abiType == ToABIType(SASigElemDrop));
      return FuncCast(Instance::elemDrop, *abiType);
    case SymbolicAddress::TableFill:
      *abiType = MakeABIFunctionType(
          ArgType_Int32, {ArgType_General, ArgType_Int32, ArgType_General,
                          ArgType_Int32, ArgType_Int32});
      MOZ_ASSERT(*abiType == ToABIType(SASigTableFill));
      return FuncCast(Instance::tableFill, *abiType);
    case SymbolicAddress::TableInit:
      *abiType = MakeABIFunctionType(
          ArgType_Int32, {ArgType_General, ArgType_Int32, ArgType_Int32,
                          ArgType_Int32, ArgType_Int32, ArgType_Int32});
      MOZ_ASSERT(*abiType == ToABIType(SASigTableInit));
      return FuncCast(Instance::tableInit, *abiType);
    case SymbolicAddress::TableGet:
      *abiType = MakeABIFunctionType(
          ArgType_General, {ArgType_General, ArgType_Int32, ArgType_Int32});
      MOZ_ASSERT(*abiType == ToABIType(SASigTableGet));
      return FuncCast(Instance::tableGet, *abiType);
    case SymbolicAddress::TableGrow:
      *abiType = MakeABIFunctionType(
          ArgType_Int32,
          {ArgType_General, ArgType_General, ArgType_Int32, ArgType_Int32});
      MOZ_ASSERT(*abiType == ToABIType(SASigTableGrow));
      return FuncCast(Instance::tableGrow, *abiType);
    case SymbolicAddress::TableSet:
      *abiType = MakeABIFunctionType(
          ArgType_Int32,
          {ArgType_General, ArgType_Int32, ArgType_General, ArgType_Int32});
      MOZ_ASSERT(*abiType == ToABIType(SASigTableSet));
      return FuncCast(Instance::tableSet, *abiType);
    case SymbolicAddress::TableSize:
      *abiType =
          MakeABIFunctionType(ArgType_Int32, {ArgType_General, ArgType_Int32});
      MOZ_ASSERT(*abiType == ToABIType(SASigTableSize));
      return FuncCast(Instance::tableSize, *abiType);
    case SymbolicAddress::RefFunc:
      *abiType = MakeABIFunctionType(ArgType_General,
                                     {ArgType_General, ArgType_Int32});
      MOZ_ASSERT(*abiType == ToABIType(SASigRefFunc));
      return FuncCast(Instance::refFunc, *abiType);
    case SymbolicAddress::PostBarrier:
      *abiType = MakeABIFunctionType(ArgType_Int32,
                                     {ArgType_General, ArgType_General});
      MOZ_ASSERT(*abiType == ToABIType(SASigPostBarrier));
      return FuncCast(Instance::postBarrier, *abiType);
    case SymbolicAddress::PreBarrierFiltering:
      *abiType = MakeABIFunctionType(ArgType_Int32,
                                     {ArgType_General, ArgType_General});
      MOZ_ASSERT(*abiType == ToABIType(SASigPreBarrierFiltering));
      return FuncCast(Instance::preBarrierFiltering, *abiType);
    case SymbolicAddress::PostBarrierFiltering:
      *abiType = MakeABIFunctionType(ArgType_Int32,
                                     {ArgType_General, ArgType_General});
      MOZ_ASSERT(*abiType == ToABIType(SASigPostBarrierFiltering));
      return FuncCast(Instance::postBarrierFiltering, *abiType);
    case SymbolicAddress::StructNew:
      *abiType = MakeABIFunctionType(ArgType_General,
                                     {ArgType_General, ArgType_Int32});
      MOZ_ASSERT(*abiType == ToABIType(SASigStructNew));
      return FuncCast(Instance::structNew, *abiType);
    case SymbolicAddress::StructNarrow:
      *abiType = MakeABIFunctionType(
          ArgType_General,
          {ArgType_General, ArgType_Int32, ArgType_Int32, ArgType_General});
      MOZ_ASSERT(*abiType == ToABIType(SASigStructNarrow));
      return FuncCast(Instance::structNarrow, *abiType);

#if defined(JS_CODEGEN_MIPS32)
    case SymbolicAddress::js_jit_gAtomic64Lock:
      return &js::jit::gAtomic64Lock;
#endif
#ifdef WASM_CODEGEN_DEBUG
    case SymbolicAddress::PrintI32:
      *abiType = Args_General1;
      return FuncCast(PrintI32, *abiType);
    case SymbolicAddress::PrintPtr:
      *abiType = Args_General1;
      return FuncCast(PrintPtr, *abiType);
    case SymbolicAddress::PrintF32:
      *abiType = Args_Int_Float32;
      return FuncCast(PrintF32, *abiType);
    case SymbolicAddress::PrintF64:
      *abiType = Args_Int_Double;
      return FuncCast(PrintF64, *abiType);
    case SymbolicAddress::PrintText:
      *abiType = Args_General1;
      return FuncCast(PrintText, *abiType);
#endif
    case SymbolicAddress::Limit:
      break;
  }

  MOZ_CRASH("Bad SymbolicAddress");
}

bool wasm::NeedsBuiltinThunk(SymbolicAddress sym) {
  // Some functions don't want to a thunk, because they already have one or
  // they don't have frame info.
  switch (sym) {
    case SymbolicAddress::HandleDebugTrap:  // GenerateDebugTrapStub
    case SymbolicAddress::HandleThrow:      // GenerateThrowStub
    case SymbolicAddress::HandleTrap:       // GenerateTrapExit
    case SymbolicAddress::CallImport_Void:  // GenerateImportInterpExit
    case SymbolicAddress::CallImport_I32:
    case SymbolicAddress::CallImport_I64:
    case SymbolicAddress::CallImport_V128:
    case SymbolicAddress::CallImport_F64:
    case SymbolicAddress::CallImport_FuncRef:
    case SymbolicAddress::CallImport_AnyRef:
    case SymbolicAddress::CoerceInPlace_ToInt32:  // GenerateImportJitExit
    case SymbolicAddress::CoerceInPlace_ToNumber:
    case SymbolicAddress::CoerceInPlace_ToBigInt:
    case SymbolicAddress::BoxValue_Anyref:
#if defined(JS_CODEGEN_MIPS32)
    case SymbolicAddress::js_jit_gAtomic64Lock:
#endif
#ifdef WASM_CODEGEN_DEBUG
    case SymbolicAddress::PrintI32:
    case SymbolicAddress::PrintPtr:
    case SymbolicAddress::PrintF32:
    case SymbolicAddress::PrintF64:
    case SymbolicAddress::PrintText:  // Used only in stubs
#endif
      return false;
    case SymbolicAddress::ToInt32:
    case SymbolicAddress::DivI64:
    case SymbolicAddress::UDivI64:
    case SymbolicAddress::ModI64:
    case SymbolicAddress::UModI64:
    case SymbolicAddress::TruncateDoubleToUint64:
    case SymbolicAddress::TruncateDoubleToInt64:
    case SymbolicAddress::SaturatingTruncateDoubleToUint64:
    case SymbolicAddress::SaturatingTruncateDoubleToInt64:
    case SymbolicAddress::Uint64ToDouble:
    case SymbolicAddress::Uint64ToFloat32:
    case SymbolicAddress::Int64ToDouble:
    case SymbolicAddress::Int64ToFloat32:
#if defined(JS_CODEGEN_ARM)
    case SymbolicAddress::aeabi_idivmod:
    case SymbolicAddress::aeabi_uidivmod:
#endif
    case SymbolicAddress::AllocateBigInt:
    case SymbolicAddress::ModD:
    case SymbolicAddress::SinD:
    case SymbolicAddress::CosD:
    case SymbolicAddress::TanD:
    case SymbolicAddress::ASinD:
    case SymbolicAddress::ACosD:
    case SymbolicAddress::ATanD:
    case SymbolicAddress::CeilD:
    case SymbolicAddress::CeilF:
    case SymbolicAddress::FloorD:
    case SymbolicAddress::FloorF:
    case SymbolicAddress::TruncD:
    case SymbolicAddress::TruncF:
    case SymbolicAddress::NearbyIntD:
    case SymbolicAddress::NearbyIntF:
    case SymbolicAddress::ExpD:
    case SymbolicAddress::LogD:
    case SymbolicAddress::PowD:
    case SymbolicAddress::ATan2D:
    case SymbolicAddress::MemoryGrow:
    case SymbolicAddress::MemorySize:
    case SymbolicAddress::WaitI32:
    case SymbolicAddress::WaitI64:
    case SymbolicAddress::Wake:
    case SymbolicAddress::CoerceInPlace_JitEntry:
    case SymbolicAddress::ReportV128JSCall:
    case SymbolicAddress::MemCopy:
    case SymbolicAddress::MemCopyShared:
    case SymbolicAddress::DataDrop:
    case SymbolicAddress::MemFill:
    case SymbolicAddress::MemFillShared:
    case SymbolicAddress::MemInit:
    case SymbolicAddress::TableCopy:
    case SymbolicAddress::ElemDrop:
    case SymbolicAddress::TableFill:
    case SymbolicAddress::TableGet:
    case SymbolicAddress::TableGrow:
    case SymbolicAddress::TableInit:
    case SymbolicAddress::TableSet:
    case SymbolicAddress::TableSize:
    case SymbolicAddress::RefFunc:
    case SymbolicAddress::PreBarrierFiltering:
    case SymbolicAddress::PostBarrier:
    case SymbolicAddress::PostBarrierFiltering:
    case SymbolicAddress::StructNew:
    case SymbolicAddress::StructNarrow:
      return true;
    case SymbolicAddress::Limit:
      break;
  }

  MOZ_CRASH("unexpected symbolic address");
}

// ============================================================================
// JS builtins that can be imported by wasm modules and called efficiently
// through thunks. These thunks conform to the internal wasm ABI and thus can be
// patched in for import calls. Calling a JS builtin through a thunk is much
// faster than calling out through the generic import call trampoline which will
// end up in the slowest C++ Instance::callImport path.
//
// Each JS builtin can have several overloads. These must all be enumerated in
// PopulateTypedNatives() so they can be included in the process-wide thunk set.

#define FOR_EACH_UNARY_NATIVE(_) \
  _(math_sin, MathSin)           \
  _(math_tan, MathTan)           \
  _(math_cos, MathCos)           \
  _(math_exp, MathExp)           \
  _(math_log, MathLog)           \
  _(math_asin, MathASin)         \
  _(math_atan, MathATan)         \
  _(math_acos, MathACos)         \
  _(math_log10, MathLog10)       \
  _(math_log2, MathLog2)         \
  _(math_log1p, MathLog1P)       \
  _(math_expm1, MathExpM1)       \
  _(math_sinh, MathSinH)         \
  _(math_tanh, MathTanH)         \
  _(math_cosh, MathCosH)         \
  _(math_asinh, MathASinH)       \
  _(math_atanh, MathATanH)       \
  _(math_acosh, MathACosH)       \
  _(math_sign, MathSign)         \
  _(math_trunc, MathTrunc)       \
  _(math_cbrt, MathCbrt)

#define FOR_EACH_BINARY_NATIVE(_) \
  _(ecmaAtan2, MathATan2)         \
  _(ecmaHypot, MathHypot)         \
  _(ecmaPow, MathPow)

#define DEFINE_UNARY_FLOAT_WRAPPER(func, _) \
  static float func##_impl_f32(float x) {   \
    return float(func##_impl(double(x)));   \
  }

#define DEFINE_BINARY_FLOAT_WRAPPER(func, _)  \
  static float func##_f32(float x, float y) { \
    return float(func(double(x), double(y))); \
  }

FOR_EACH_UNARY_NATIVE(DEFINE_UNARY_FLOAT_WRAPPER)
FOR_EACH_BINARY_NATIVE(DEFINE_BINARY_FLOAT_WRAPPER)

#undef DEFINE_UNARY_FLOAT_WRAPPER
#undef DEFINE_BINARY_FLOAT_WRAPPER

struct TypedNative {
  InlinableNative native;
  ABIFunctionType abiType;

  TypedNative(InlinableNative native, ABIFunctionType abiType)
      : native(native), abiType(abiType) {}

  using Lookup = TypedNative;
  static HashNumber hash(const Lookup& l) {
    return HashGeneric(uint32_t(l.native), uint32_t(l.abiType));
  }
  static bool match(const TypedNative& lhs, const Lookup& rhs) {
    return lhs.native == rhs.native && lhs.abiType == rhs.abiType;
  }
};

using TypedNativeToFuncPtrMap =
    HashMap<TypedNative, void*, TypedNative, SystemAllocPolicy>;

static bool PopulateTypedNatives(TypedNativeToFuncPtrMap* typedNatives) {
#define ADD_OVERLOAD(funcName, native, abiType)                            \
  if (!typedNatives->putNew(TypedNative(InlinableNative::native, abiType), \
                            FuncCast(funcName, abiType)))                  \
    return false;

#define ADD_UNARY_OVERLOADS(funcName, native)               \
  ADD_OVERLOAD(funcName##_impl, native, Args_Double_Double) \
  ADD_OVERLOAD(funcName##_impl_f32, native, Args_Float32_Float32)

#define ADD_BINARY_OVERLOADS(funcName, native)             \
  ADD_OVERLOAD(funcName, native, Args_Double_DoubleDouble) \
  ADD_OVERLOAD(funcName##_f32, native, Args_Float32_Float32Float32)

  FOR_EACH_UNARY_NATIVE(ADD_UNARY_OVERLOADS)
  FOR_EACH_BINARY_NATIVE(ADD_BINARY_OVERLOADS)

#undef ADD_UNARY_OVERLOADS
#undef ADD_BINARY_OVERLOADS

  return true;
}

#undef FOR_EACH_UNARY_NATIVE
#undef FOR_EACH_BINARY_NATIVE

// ============================================================================
// Process-wide builtin thunk set
//
// Thunks are inserted between wasm calls and the C++ callee and achieve two
// things:
//  - bridging the few differences between the internal wasm ABI and the
//    external native ABI (viz. float returns on x86 and soft-fp ARM)
//  - executing an exit prologue/epilogue which in turn allows any profiling
//    iterator to see the full stack up to the wasm operation that called out
//
// Thunks are created for two kinds of C++ callees, enumerated above:
//  - SymbolicAddress: for statically compiled calls in the wasm module
//  - Imported JS builtins: optimized calls to imports
//
// All thunks are created up front, lazily, when the first wasm module is
// compiled in the process. Thunks are kept alive until the JS engine shuts down
// in the process. No thunks are created at runtime after initialization. This
// simple scheme allows several simplifications:
//  - no reference counting to keep thunks alive
//  - no problems toggling W^X permissions which, because of multiple executing
//    threads, would require each thunk allocation to be on its own page
// The cost for creating all thunks at once is relatively low since all thunks
// fit within the smallest executable quanta (64k).

using TypedNativeToCodeRangeMap =
    HashMap<TypedNative, uint32_t, TypedNative, SystemAllocPolicy>;

using SymbolicAddressToCodeRangeArray =
    EnumeratedArray<SymbolicAddress, SymbolicAddress::Limit, uint32_t>;

struct BuiltinThunks {
  uint8_t* codeBase;
  size_t codeSize;
  CodeRangeVector codeRanges;
  TypedNativeToCodeRangeMap typedNativeToCodeRange;
  SymbolicAddressToCodeRangeArray symbolicAddressToCodeRange;

  BuiltinThunks() : codeBase(nullptr), codeSize(0) {}

  ~BuiltinThunks() {
    if (codeBase) {
      DeallocateExecutableMemory(codeBase, codeSize);
    }
  }
};

Mutex initBuiltinThunks(mutexid::WasmInitBuiltinThunks);
Atomic<const BuiltinThunks*> builtinThunks;

bool wasm::EnsureBuiltinThunksInitialized() {
  LockGuard<Mutex> guard(initBuiltinThunks);
  if (builtinThunks) {
    return true;
  }

  auto thunks = MakeUnique<BuiltinThunks>();
  if (!thunks) {
    return false;
  }

  LifoAlloc lifo(BUILTIN_THUNK_LIFO_SIZE);
  TempAllocator tempAlloc(&lifo);
  WasmMacroAssembler masm(tempAlloc);

  for (auto sym : MakeEnumeratedRange(SymbolicAddress::Limit)) {
    if (!NeedsBuiltinThunk(sym)) {
      thunks->symbolicAddressToCodeRange[sym] = UINT32_MAX;
      continue;
    }

    uint32_t codeRangeIndex = thunks->codeRanges.length();
    thunks->symbolicAddressToCodeRange[sym] = codeRangeIndex;

    ABIFunctionType abiType;
    void* funcPtr = AddressOf(sym, &abiType);

    ExitReason exitReason(sym);

    CallableOffsets offsets;
    if (!GenerateBuiltinThunk(masm, abiType, exitReason, funcPtr, &offsets)) {
      return false;
    }
    if (!thunks->codeRanges.emplaceBack(CodeRange::BuiltinThunk, offsets)) {
      return false;
    }
  }

  TypedNativeToFuncPtrMap typedNatives;
  if (!PopulateTypedNatives(&typedNatives)) {
    return false;
  }

  for (TypedNativeToFuncPtrMap::Range r = typedNatives.all(); !r.empty();
       r.popFront()) {
    TypedNative typedNative = r.front().key();

    uint32_t codeRangeIndex = thunks->codeRanges.length();
    if (!thunks->typedNativeToCodeRange.putNew(typedNative, codeRangeIndex)) {
      return false;
    }

    ABIFunctionType abiType = typedNative.abiType;
    void* funcPtr = r.front().value();

    ExitReason exitReason = ExitReason::Fixed::BuiltinNative;

    CallableOffsets offsets;
    if (!GenerateBuiltinThunk(masm, abiType, exitReason, funcPtr, &offsets)) {
      return false;
    }
    if (!thunks->codeRanges.emplaceBack(CodeRange::BuiltinThunk, offsets)) {
      return false;
    }
  }

  masm.finish();
  if (masm.oom()) {
    return false;
  }

  size_t allocSize = AlignBytes(masm.bytesNeeded(), ExecutableCodePageSize);

  thunks->codeSize = allocSize;
  thunks->codeBase = (uint8_t*)AllocateExecutableMemory(
      allocSize, ProtectionSetting::Writable, MemCheckKind::MakeUndefined);
  if (!thunks->codeBase) {
    return false;
  }

  masm.executableCopy(thunks->codeBase);
  memset(thunks->codeBase + masm.bytesNeeded(), 0,
         allocSize - masm.bytesNeeded());

  masm.processCodeLabels(thunks->codeBase);
  PatchDebugSymbolicAccesses(thunks->codeBase, masm);

  MOZ_ASSERT(masm.callSites().empty());
  MOZ_ASSERT(masm.callSiteTargets().empty());
  MOZ_ASSERT(masm.trapSites().empty());

  if (!ExecutableAllocator::makeExecutableAndFlushICache(thunks->codeBase,
                                                         thunks->codeSize)) {
    return false;
  }

  builtinThunks = thunks.release();
  return true;
}

void wasm::ReleaseBuiltinThunks() {
  if (builtinThunks) {
    const BuiltinThunks* ptr = builtinThunks;
    js_delete(const_cast<BuiltinThunks*>(ptr));
    builtinThunks = nullptr;
  }
}

void* wasm::SymbolicAddressTarget(SymbolicAddress sym) {
  MOZ_ASSERT(builtinThunks);

  ABIFunctionType abiType;
  void* funcPtr = AddressOf(sym, &abiType);

  if (!NeedsBuiltinThunk(sym)) {
    return funcPtr;
  }

  const BuiltinThunks& thunks = *builtinThunks;
  uint32_t codeRangeIndex = thunks.symbolicAddressToCodeRange[sym];
  return thunks.codeBase + thunks.codeRanges[codeRangeIndex].begin();
}

static Maybe<ABIFunctionType> ToBuiltinABIFunctionType(
    const FuncType& funcType) {
  const ValTypeVector& args = funcType.args();
  const ValTypeVector& results = funcType.results();

  if (results.length() != 1) {
    return Nothing();
  }

  uint32_t abiType;
  switch (results[0].kind()) {
    case ValType::F32:
      abiType = ArgType_Float32 << RetType_Shift;
      break;
    case ValType::F64:
      abiType = ArgType_Float64 << RetType_Shift;
      break;
    default:
      return Nothing();
  }

  if ((args.length() + 1) > (sizeof(uint32_t) * 8 / ArgType_Shift)) {
    return Nothing();
  }

  for (size_t i = 0; i < args.length(); i++) {
    switch (args[i].kind()) {
      case ValType::F32:
        abiType |= (ArgType_Float32 << (ArgType_Shift * (i + 1)));
        break;
      case ValType::F64:
        abiType |= (ArgType_Float64 << (ArgType_Shift * (i + 1)));
        break;
      default:
        return Nothing();
    }
  }

  return Some(ABIFunctionType(abiType));
}

void* wasm::MaybeGetBuiltinThunk(JSFunction* f, const FuncType& funcType) {
  MOZ_ASSERT(builtinThunks);

  if (!f->isNative() || !f->hasJitInfo() ||
      f->jitInfo()->type() != JSJitInfo::InlinableNative) {
    return nullptr;
  }

  Maybe<ABIFunctionType> abiType = ToBuiltinABIFunctionType(funcType);
  if (!abiType) {
    return nullptr;
  }

  TypedNative typedNative(f->jitInfo()->inlinableNative, *abiType);

  const BuiltinThunks& thunks = *builtinThunks;
  auto p = thunks.typedNativeToCodeRange.readonlyThreadsafeLookup(typedNative);
  if (!p) {
    return nullptr;
  }

  return thunks.codeBase + thunks.codeRanges[p->value()].begin();
}

bool wasm::LookupBuiltinThunk(void* pc, const CodeRange** codeRange,
                              uint8_t** codeBase) {
  if (!builtinThunks) {
    return false;
  }

  const BuiltinThunks& thunks = *builtinThunks;
  if (pc < thunks.codeBase || pc >= thunks.codeBase + thunks.codeSize) {
    return false;
  }

  *codeBase = thunks.codeBase;

  CodeRange::OffsetInCode target((uint8_t*)pc - thunks.codeBase);
  *codeRange = LookupInSorted(thunks.codeRanges, target);

  return !!*codeRange;
}
