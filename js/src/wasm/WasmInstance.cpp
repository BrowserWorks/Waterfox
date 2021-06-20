/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 *
 * Copyright 2016 Mozilla Foundation
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

#include "wasm/WasmInstance.h"

#include "mozilla/DebugOnly.h"

#include <algorithm>

#include "jit/AtomicOperations.h"
#include "jit/Disassemble.h"
#include "jit/InlinableNatives.h"
#include "jit/JitCommon.h"
#include "jit/JitRealm.h"
#include "jit/JitScript.h"
#include "js/ForOfIterator.h"
#include "util/StringBuffer.h"
#include "util/Text.h"
#include "vm/BigIntType.h"
#include "vm/PlainObject.h"  // js::PlainObject
#include "wasm/WasmBuiltins.h"
#include "wasm/WasmModule.h"
#include "wasm/WasmStubs.h"

#include "gc/StoreBuffer-inl.h"
#include "vm/ArrayBufferObject-inl.h"
#include "vm/JSObject-inl.h"

using namespace js;
using namespace js::jit;
using namespace js::wasm;
using mozilla::BitwiseCast;
using mozilla::DebugOnly;

using CheckedU32 = CheckedInt<uint32_t>;

class FuncTypeIdSet {
  typedef HashMap<const FuncType*, uint32_t, FuncTypeHashPolicy,
                  SystemAllocPolicy>
      Map;
  Map map_;

 public:
  ~FuncTypeIdSet() {
    MOZ_ASSERT_IF(!JSRuntime::hasLiveRuntimes(), map_.empty());
  }

  bool allocateFuncTypeId(JSContext* cx, const FuncType& funcType,
                          const void** funcTypeId) {
    Map::AddPtr p = map_.lookupForAdd(funcType);
    if (p) {
      MOZ_ASSERT(p->value() > 0);
      p->value()++;
      *funcTypeId = p->key();
      return true;
    }

    UniquePtr<FuncType> clone = MakeUnique<FuncType>();
    if (!clone || !clone->clone(funcType) || !map_.add(p, clone.get(), 1)) {
      ReportOutOfMemory(cx);
      return false;
    }

    *funcTypeId = clone.release();
    MOZ_ASSERT(!(uintptr_t(*funcTypeId) & FuncTypeIdDesc::ImmediateBit));
    return true;
  }

  void deallocateFuncTypeId(const FuncType& funcType, const void* funcTypeId) {
    Map::Ptr p = map_.lookup(funcType);
    MOZ_RELEASE_ASSERT(p && p->key() == funcTypeId && p->value() > 0);

    p->value()--;
    if (!p->value()) {
      js_delete(p->key());
      map_.remove(p);
    }
  }
};

ExclusiveData<FuncTypeIdSet> funcTypeIdSet(mutexid::WasmFuncTypeIdSet);

const void** Instance::addressOfFuncTypeId(
    const FuncTypeIdDesc& funcTypeId) const {
  return (const void**)(globalData() + funcTypeId.globalDataOffset());
}

FuncImportTls& Instance::funcImportTls(const FuncImport& fi) {
  return *(FuncImportTls*)(globalData() + fi.tlsDataOffset());
}

TableTls& Instance::tableTls(const TableDesc& td) const {
  return *(TableTls*)(globalData() + td.globalDataOffset);
}

class NoDebug {
 public:
  template <typename T>
  static void print(T v) {}
};

class DebugCodegenVal {
  template <typename T>
  static void print(const char* fmt, T v) {
    DebugCodegen(DebugChannel::Function, fmt, v);
  }

 public:
  static void print(int32_t v) { print(" i32(%d)", v); }
  static void print(int64_t v) { print(" i64(%" PRId64 ")", v); }
  static void print(float v) { print(" f32(%f)", v); }
  static void print(double v) { print(" f64(%lf)", v); }
  static void print(void* v) { print(" ptr(%p)", v); }
};

template <typename Debug = NoDebug>
static bool ToWebAssemblyValue_i32(JSContext* cx, HandleValue val, int32_t* loc,
                                   bool mustWrite64) {
  bool ok = ToInt32(cx, val, loc);
  if (ok && mustWrite64) {
#if defined(JS_CODEGEN_MIPS32) || defined(JS_CODEGEN_MIPS64)
    loc[1] = loc[0] >> 31;
#else
    loc[1] = 0;
#endif
  }
  Debug::print(*loc);
  return ok;
}
template <typename Debug = NoDebug>
static bool ToWebAssemblyValue_i64(JSContext* cx, HandleValue val, int64_t* loc,
                                   bool mustWrite64) {
  MOZ_ASSERT(mustWrite64);
  JS_TRY_VAR_OR_RETURN_FALSE(cx, *loc, ToBigInt64(cx, val));
  Debug::print(*loc);
  return true;
}
template <typename Debug = NoDebug>
static bool ToWebAssemblyValue_f32(JSContext* cx, HandleValue val, float* loc,
                                   bool mustWrite64) {
  bool ok = RoundFloat32(cx, val, loc);
  if (ok && mustWrite64) {
    loc[1] = 0.0;
  }
  Debug::print(*loc);
  return ok;
}
template <typename Debug = NoDebug>
static bool ToWebAssemblyValue_f64(JSContext* cx, HandleValue val, double* loc,
                                   bool mustWrite64) {
  MOZ_ASSERT(mustWrite64);
  bool ok = ToNumber(cx, val, loc);
  Debug::print(*loc);
  return ok;
}
template <typename Debug = NoDebug>
static bool ToWebAssemblyValue_anyref(JSContext* cx, HandleValue val,
                                      void** loc, bool mustWrite64) {
  RootedAnyRef result(cx, AnyRef::null());
  if (!BoxAnyRef(cx, val, &result)) {
    return false;
  }
  *loc = result.get().forCompiledCode();
#ifndef JS_64BIT
  if (mustWrite64) {
    loc[1] = nullptr;
  }
#endif
  Debug::print(*loc);
  return true;
}
template <typename Debug = NoDebug>
static bool ToWebAssemblyValue_funcref(JSContext* cx, HandleValue val,
                                       void** loc, bool mustWrite64) {
  RootedFunction fun(cx);
  if (!CheckFuncRefValue(cx, val, &fun)) {
    return false;
  }
  *loc = fun;
#ifndef JS_64BIT
  if (mustWrite64) {
    loc[1] = nullptr;
  }
#endif
  Debug::print(*loc);
  return true;
}
template <typename Debug = NoDebug>
static bool ToWebAssemblyValue_typeref(JSContext* cx, HandleValue val,
                                       void** loc, bool mustWrite64) {
  JS_ReportErrorNumberUTF8(cx, GetErrorMessage, nullptr,
                           JSMSG_WASM_TYPEREF_FROM_JS);
  return false;
}

template <typename Debug = NoDebug>
static bool ToWebAssemblyValue(JSContext* cx, HandleValue val, ValType type,
                               void* loc, bool mustWrite64) {
  switch (type.kind()) {
    case ValType::I32:
      return ToWebAssemblyValue_i32<Debug>(cx, val, (int32_t*)loc, mustWrite64);
    case ValType::I64:
      return ToWebAssemblyValue_i64<Debug>(cx, val, (int64_t*)loc, mustWrite64);
    case ValType::F32:
      return ToWebAssemblyValue_f32<Debug>(cx, val, (float*)loc, mustWrite64);
    case ValType::F64:
      return ToWebAssemblyValue_f64<Debug>(cx, val, (double*)loc, mustWrite64);
    case ValType::V128:
      MOZ_CRASH("unexpected v128 in ToWebAssemblyValue");
    case ValType::Ref:
      switch (type.refTypeKind()) {
        case RefType::Func:
          return ToWebAssemblyValue_funcref<Debug>(cx, val, (void**)loc,
                                                   mustWrite64);
        case RefType::Any:
          return ToWebAssemblyValue_anyref<Debug>(cx, val, (void**)loc,
                                                  mustWrite64);
        case RefType::TypeIndex:
          return ToWebAssemblyValue_typeref<Debug>(cx, val, (void**)loc,
                                                   mustWrite64);
      }
  }
  MOZ_CRASH("unreachable");
}

template <typename Debug = NoDebug>
static bool ToJSValue_i32(JSContext* cx, int32_t src, MutableHandleValue dst) {
  dst.set(Int32Value(src));
  Debug::print(src);
  return true;
}
template <typename Debug = NoDebug>
static bool ToJSValue_i64(JSContext* cx, int64_t src, MutableHandleValue dst) {
  // If bi is manipulated other than test & storing, it would need
  // to be rooted here.
  BigInt* bi = BigInt::createFromInt64(cx, src);
  if (!bi) {
    return false;
  }
  dst.set(BigIntValue(bi));
  Debug::print(src);
  return true;
}
template <typename Debug = NoDebug>
static bool ToJSValue_f32(JSContext* cx, float src, MutableHandleValue dst) {
  dst.set(JS::CanonicalizedDoubleValue(src));
  Debug::print(src);
  return true;
}
template <typename Debug = NoDebug>
static bool ToJSValue_f64(JSContext* cx, double src, MutableHandleValue dst) {
  dst.set(JS::CanonicalizedDoubleValue(src));
  Debug::print(src);
  return true;
}
template <typename Debug = NoDebug>
static bool ToJSValue_funcref(JSContext* cx, void* src,
                              MutableHandleValue dst) {
  dst.set(UnboxFuncRef(FuncRef::fromCompiledCode(src)));
  Debug::print(src);
  return true;
}
template <typename Debug = NoDebug>
static bool ToJSValue_anyref(JSContext* cx, void* src, MutableHandleValue dst) {
  dst.set(UnboxAnyRef(AnyRef::fromCompiledCode(src)));
  Debug::print(src);
  return true;
}
template <typename Debug = NoDebug>
static bool ToJSValue_typeref(JSContext* cx, void* src,
                              MutableHandleValue dst) {
  JS_ReportErrorNumberUTF8(cx, GetErrorMessage, nullptr,
                           JSMSG_WASM_TYPEREF_TO_JS);
  return false;
}

template <typename Debug = NoDebug>
static bool ToJSValue(JSContext* cx, const void* src, ValType type,
                      MutableHandleValue dst) {
  switch (type.kind()) {
    case ValType::I32:
      return ToJSValue_i32<Debug>(cx, *reinterpret_cast<const int32_t*>(src),
                                  dst);
    case ValType::I64:
      return ToJSValue_i64<Debug>(cx, *reinterpret_cast<const int64_t*>(src),
                                  dst);
    case ValType::F32:
      return ToJSValue_f32<Debug>(cx, *reinterpret_cast<const float*>(src),
                                  dst);
    case ValType::F64:
      return ToJSValue_f64<Debug>(cx, *reinterpret_cast<const double*>(src),
                                  dst);
    case ValType::V128:
      MOZ_CRASH("unhandled type in ToJSValue");
    case ValType::Ref:
      switch (type.refTypeKind()) {
        case RefType::Func:
          return ToJSValue_funcref<Debug>(
              cx, *reinterpret_cast<void* const*>(src), dst);
        case RefType::Any:
          return ToJSValue_anyref<Debug>(
              cx, *reinterpret_cast<void* const*>(src), dst);
        case RefType::TypeIndex:
          return ToJSValue_typeref<Debug>(
              cx, *reinterpret_cast<void* const*>(src), dst);
      }
  }
  MOZ_CRASH("unreachable");
}

// TODO(1626251): Consolidate definitions into Iterable.h
static bool IterableToArray(JSContext* cx, HandleValue iterable,
                            MutableHandle<ArrayObject*> array) {
  JS::ForOfIterator iterator(cx);
  if (!iterator.init(iterable, JS::ForOfIterator::ThrowOnNonIterable)) {
    return false;
  }

  array.set(NewDenseEmptyArray(cx));
  if (!array) {
    return false;
  }

  RootedValue nextValue(cx);
  while (true) {
    bool done;
    if (!iterator.next(&nextValue, &done)) {
      return false;
    }
    if (done) {
      break;
    }

    if (!NewbornArrayPush(cx, array, nextValue)) {
      return false;
    }
  }
  return true;
}

static bool UnpackResults(JSContext* cx, const ValTypeVector& resultTypes,
                          const Maybe<char*> stackResultsArea,
                          MutableHandleValue rval) {
  if (!stackResultsArea) {
    MOZ_ASSERT(resultTypes.length() <= 1);
    // Result is either one scalar value to unpack to a wasm value, or
    // an ignored value for a zero-valued function.
    return true;
  }

  MOZ_ASSERT(stackResultsArea.isSome());
  RootedArrayObject array(cx);
  if (!IterableToArray(cx, rval, &array)) {
    return false;
  }

  if (resultTypes.length() != array->length()) {
    UniqueChars expected(JS_smprintf("%zu", resultTypes.length()));
    UniqueChars got(JS_smprintf("%u", array->length()));

    JS_ReportErrorNumberUTF8(cx, GetErrorMessage, nullptr,
                             JSMSG_WASM_WRONG_NUMBER_OF_VALUES, expected.get(),
                             got.get());
    return false;
  }

  DebugOnly<uint64_t> previousOffset = ~(uint64_t)0;

  ABIResultIter iter(ResultType::Vector(resultTypes));
  // The values are converted in the order they are pushed on the
  // abstract WebAssembly stack; switch to iterate in push order.
  while (!iter.done()) {
    iter.next();
  }
  DebugOnly<bool> seenRegisterResult = false;
  for (iter.switchToPrev(); !iter.done(); iter.prev()) {
    const ABIResult& result = iter.cur();
    MOZ_ASSERT(!seenRegisterResult);
    // Use rval as a scratch area to hold the extracted result.
    rval.set(array->getDenseElement(iter.index()));
    if (result.inRegister()) {
      // Currently, if a function type has results, there can be only
      // one register result.  If there is only one result, it is
      // returned as a scalar and not an iterable, so we don't get here.
      // If there are multiple results, we extract the register result
      // and leave `rval` set to the extracted result, to be converted
      // by the caller.  The register result follows any stack results,
      // so this preserves conversion order.
      seenRegisterResult = true;
      continue;
    }
    uint32_t result_size = result.size();
    MOZ_ASSERT(result_size == 4 || result_size == 8);
#ifdef DEBUG
    if (previousOffset == ~(uint64_t)0) {
      previousOffset = result.stackOffset();
    } else {
      MOZ_ASSERT(previousOffset - (uint64_t)result_size ==
                 (uint64_t)result.stackOffset());
      previousOffset -= result_size;
    }
#endif
    char* loc = stackResultsArea.value() + result.stackOffset();
    if (!ToWebAssemblyValue(cx, rval, result.type(), loc, result_size == 8)) {
      return false;
    }
  }

  return true;
}

bool Instance::callImport(JSContext* cx, uint32_t funcImportIndex,
                          unsigned argc, const uint64_t* argv,
                          MutableHandleValue rval) {
  AssertRealmUnchanged aru(cx);

  Tier tier = code().bestTier();

  const FuncImport& fi = metadata(tier).funcImports[funcImportIndex];

  ArgTypeVector argTypes(fi.funcType());
  InvokeArgs args(cx);
  if (!args.init(cx, argTypes.lengthWithoutStackResults())) {
    return false;
  }

#ifdef ENABLE_WASM_SIMD
  if (fi.funcType().hasV128ArgOrRet()) {
    JS_ReportErrorNumberUTF8(cx, GetErrorMessage, nullptr,
                             JSMSG_WASM_BAD_VAL_TYPE);
    return false;
  }
#endif

  MOZ_ASSERT(argTypes.lengthWithStackResults() == argc);
  Maybe<char*> stackResultPointer;
  for (size_t i = 0; i < argc; i++) {
    const void* rawArgLoc = &argv[i];
    if (argTypes.isSyntheticStackResultPointerArg(i)) {
      stackResultPointer = Some(*(char**)rawArgLoc);
      continue;
    }
    size_t naturalIndex = argTypes.naturalIndex(i);
    ValType type = fi.funcType().args()[naturalIndex];
    MutableHandleValue argValue = args[naturalIndex];
    if (!ToJSValue(cx, rawArgLoc, type, argValue)) {
      return false;
    }
  }

  FuncImportTls& import = funcImportTls(fi);
  RootedFunction importFun(cx, import.fun);
  MOZ_ASSERT(cx->realm() == importFun->realm());

  RootedValue fval(cx, ObjectValue(*importFun));
  RootedValue thisv(cx, UndefinedValue());
  if (!Call(cx, fval, thisv, args, rval)) {
    return false;
  }

  if (!UnpackResults(cx, fi.funcType().results(), stackResultPointer, rval)) {
    return false;
  }

  if (!JitOptions.enableWasmJitExit) {
    return true;
  }

  // The import may already have become optimized.
  for (auto t : code().tiers()) {
    void* jitExitCode = codeBase(t) + fi.jitExitCodeOffset();
    if (import.code == jitExitCode) {
      return true;
    }
  }

  void* jitExitCode = codeBase(tier) + fi.jitExitCodeOffset();

  // Test if the function is JIT compiled.
  if (!importFun->hasBytecode()) {
    return true;
  }

  JSScript* script = importFun->nonLazyScript();
  if (!script->hasJitScript()) {
    return true;
  }

  if (!fi.canHaveJitExit()) {
    return true;
  }

  JitScript* jitScript = script->jitScript();

  // Ensure the argument types are included in the argument TypeSets stored in
  // the JitScript. This is necessary for Ion, because the import will use
  // the skip-arg-checks entry point. When the JitScript is discarded the import
  // is patched back.
  if (IsTypeInferenceEnabled()) {
    AutoSweepJitScript sweep(script);

    StackTypeSet* thisTypes = jitScript->thisTypes(sweep, script);
    if (!thisTypes->hasType(TypeSet::UndefinedType())) {
      return true;
    }

    const ValTypeVector& importArgs = fi.funcType().args();

    size_t numKnownArgs = std::min(importArgs.length(), importFun->nargs());
    for (uint32_t i = 0; i < numKnownArgs; i++) {
      StackTypeSet* argTypes = jitScript->argTypes(sweep, script, i);
      switch (importArgs[i].kind()) {
        case ValType::I32:
          if (!argTypes->hasType(TypeSet::Int32Type())) {
            return true;
          }
          break;
        case ValType::I64:
          if (!argTypes->hasType(TypeSet::BigIntType())) {
            return true;
          }
          break;
        case ValType::V128:
          MOZ_CRASH("Not needed per spec");
        case ValType::F32:
          if (!argTypes->hasType(TypeSet::DoubleType())) {
            return true;
          }
          break;
        case ValType::F64:
          if (!argTypes->hasType(TypeSet::DoubleType())) {
            return true;
          }
          break;
        case ValType::Ref:
          switch (importArgs[i].refTypeKind()) {
            case RefType::Any:
              // We don't know what type the value will be, so we can't really
              // check whether the callee will accept it.  It doesn't make much
              // sense to see if the callee accepts all of the types an AnyRef
              // might represent because most callees will not have been exposed
              // to all those types and so we'll never pass the test.  Instead,
              // we must use the callee's arg-type-checking entry point, and not
              // check anything here.  See FuncType::jitExitRequiresArgCheck().
              break;
            case RefType::Func:
              // We handle FuncRef as we do AnyRef: by checking the type
              // dynamically in the callee.  Code in the stubs layer must box up
              // the FuncRef as a Value.
              break;
            case RefType::TypeIndex:
              // Guarded by temporarilyUnsupportedReftypeForExit()
              MOZ_CRASH("case guarded above");
          }
          break;
      }
    }

    // These arguments will be filled with undefined at runtime by the
    // arguments rectifier: check that the imported function can handle
    // undefined there.
    for (uint32_t i = importArgs.length(); i < importFun->nargs(); i++) {
      StackTypeSet* argTypes = jitScript->argTypes(sweep, script, i);
      if (!argTypes->hasType(TypeSet::UndefinedType())) {
        return true;
      }
    }
  }

  // Let's optimize it!
  if (!jitScript->addDependentWasmImport(cx, *this, funcImportIndex)) {
    return false;
  }

  import.code = jitExitCode;
  import.jitScript = jitScript;
  return true;
}

/* static */ int32_t /* 0 to signal trap; 1 to signal OK */
Instance::callImport_void(Instance* instance, int32_t funcImportIndex,
                          int32_t argc, uint64_t* argv) {
  JSContext* cx = TlsContext.get();
  RootedValue rval(cx);
  return instance->callImport(cx, funcImportIndex, argc, argv, &rval);
}

/* static */ int32_t /* 0 to signal trap; 1 to signal OK */
Instance::callImport_i32(Instance* instance, int32_t funcImportIndex,
                         int32_t argc, uint64_t* argv) {
  JSContext* cx = TlsContext.get();
  RootedValue rval(cx);
  if (!instance->callImport(cx, funcImportIndex, argc, argv, &rval)) {
    return false;
  }
  return ToWebAssemblyValue_i32(cx, rval, (int32_t*)argv, true);
}

/* static */ int32_t /* 0 to signal trap; 1 to signal OK */
Instance::callImport_i64(Instance* instance, int32_t funcImportIndex,
                         int32_t argc, uint64_t* argv) {
  JSContext* cx = TlsContext.get();
  RootedValue rval(cx);
  if (!instance->callImport(cx, funcImportIndex, argc, argv, &rval)) {
    return false;
  }
  return ToWebAssemblyValue_i64(cx, rval, (int64_t*)argv, true);
}

/* static */ int32_t /* 0 to signal trap; 1 to signal OK */
Instance::callImport_v128(Instance* instance, int32_t funcImportIndex,
                          int32_t argc, uint64_t* argv) {
  JSContext* cx = TlsContext.get();
  JS_ReportErrorNumberUTF8(cx, GetErrorMessage, nullptr,
                           JSMSG_WASM_BAD_VAL_TYPE);
  return false;
}

/* static */ int32_t /* 0 to signal trap; 1 to signal OK */
Instance::callImport_f64(Instance* instance, int32_t funcImportIndex,
                         int32_t argc, uint64_t* argv) {
  JSContext* cx = TlsContext.get();
  RootedValue rval(cx);
  if (!instance->callImport(cx, funcImportIndex, argc, argv, &rval)) {
    return false;
  }
  return ToWebAssemblyValue_f64(cx, rval, (double*)argv, true);
}

/* static */ int32_t /* 0 to signal trap; 1 to signal OK */
Instance::callImport_anyref(Instance* instance, int32_t funcImportIndex,
                            int32_t argc, uint64_t* argv) {
  JSContext* cx = TlsContext.get();
  RootedValue rval(cx);
  if (!instance->callImport(cx, funcImportIndex, argc, argv, &rval)) {
    return false;
  }
  static_assert(sizeof(argv[0]) >= sizeof(void*), "fits");
  return ToWebAssemblyValue_anyref(cx, rval, (void**)argv, true);
}

/* static */ int32_t /* 0 to signal trap; 1 to signal OK */
Instance::callImport_funcref(Instance* instance, int32_t funcImportIndex,
                             int32_t argc, uint64_t* argv) {
  JSContext* cx = TlsContext.get();
  RootedValue rval(cx);
  if (!instance->callImport(cx, funcImportIndex, argc, argv, &rval)) {
    return false;
  }
  return ToWebAssemblyValue_funcref(cx, rval, (void**)argv, true);
}

/* static */ uint32_t Instance::memoryGrow_i32(Instance* instance,
                                               uint32_t delta) {
  MOZ_ASSERT(SASigMemoryGrow.failureMode == FailureMode::Infallible);
  MOZ_ASSERT(!instance->isAsmJS());

  JSContext* cx = TlsContext.get();
  RootedWasmMemoryObject memory(cx, instance->memory_);

  uint32_t ret = WasmMemoryObject::grow(memory, delta, cx);

  // If there has been a moving grow, this Instance should have been notified.
  MOZ_RELEASE_ASSERT(instance->tlsData()->memoryBase ==
                     instance->memory_->buffer().dataPointerEither());

  return ret;
}

/* static */ uint32_t Instance::memorySize_i32(Instance* instance) {
  MOZ_ASSERT(SASigMemorySize.failureMode == FailureMode::Infallible);

  // This invariant must hold when running Wasm code. Assert it here so we can
  // write tests for cross-realm calls.
  MOZ_ASSERT(TlsContext.get()->realm() == instance->realm());

  uint32_t byteLength = instance->memory()->volatileMemoryLength();
  MOZ_ASSERT(byteLength % wasm::PageSize == 0);
  return byteLength / wasm::PageSize;
}

template <typename T>
static int32_t PerformWait(Instance* instance, uint32_t byteOffset, T value,
                           int64_t timeout_ns) {
  JSContext* cx = TlsContext.get();

  if (byteOffset & (sizeof(T) - 1)) {
    JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr,
                              JSMSG_WASM_UNALIGNED_ACCESS);
    return -1;
  }

  if (byteOffset + sizeof(T) > instance->memory()->volatileMemoryLength()) {
    JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr,
                              JSMSG_WASM_OUT_OF_BOUNDS);
    return -1;
  }

  mozilla::Maybe<mozilla::TimeDuration> timeout;
  if (timeout_ns >= 0) {
    timeout = mozilla::Some(
        mozilla::TimeDuration::FromMicroseconds(timeout_ns / 1000));
  }

  switch (atomics_wait_impl(cx, instance->sharedMemoryBuffer(), byteOffset,
                            value, timeout)) {
    case FutexThread::WaitResult::OK:
      return 0;
    case FutexThread::WaitResult::NotEqual:
      return 1;
    case FutexThread::WaitResult::TimedOut:
      return 2;
    case FutexThread::WaitResult::Error:
      return -1;
    default:
      MOZ_CRASH();
  }
}

/* static */ int32_t Instance::wait_i32(Instance* instance, uint32_t byteOffset,
                                        int32_t value, int64_t timeout_ns) {
  MOZ_ASSERT(SASigWaitI32.failureMode == FailureMode::FailOnNegI32);
  return PerformWait<int32_t>(instance, byteOffset, value, timeout_ns);
}

/* static */ int32_t Instance::wait_i64(Instance* instance, uint32_t byteOffset,
                                        int64_t value, int64_t timeout_ns) {
  MOZ_ASSERT(SASigWaitI64.failureMode == FailureMode::FailOnNegI32);
  return PerformWait<int64_t>(instance, byteOffset, value, timeout_ns);
}

/* static */ int32_t Instance::wake(Instance* instance, uint32_t byteOffset,
                                    int32_t count) {
  MOZ_ASSERT(SASigWake.failureMode == FailureMode::FailOnNegI32);

  JSContext* cx = TlsContext.get();

  // The alignment guard is not in the wasm spec as of 2017-11-02, but is
  // considered likely to appear, as 4-byte alignment is required for WAKE by
  // the spec's validation algorithm.

  if (byteOffset & 3) {
    JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr,
                              JSMSG_WASM_UNALIGNED_ACCESS);
    return -1;
  }

  if (byteOffset >= instance->memory()->volatileMemoryLength()) {
    JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr,
                              JSMSG_WASM_OUT_OF_BOUNDS);
    return -1;
  }

  int64_t woken = atomics_notify_impl(instance->sharedMemoryBuffer(),
                                      byteOffset, int64_t(count));

  if (woken > INT32_MAX) {
    JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr,
                              JSMSG_WASM_WAKE_OVERFLOW);
    return -1;
  }

  return int32_t(woken);
}

template <typename T, typename F>
inline int32_t WasmMemoryCopy(T memBase, uint32_t memLen,
                              uint32_t dstByteOffset, uint32_t srcByteOffset,
                              uint32_t len, F memMove) {
  // Bounds check and deal with arithmetic overflow.
  uint64_t dstOffsetLimit = uint64_t(dstByteOffset) + uint64_t(len);
  uint64_t srcOffsetLimit = uint64_t(srcByteOffset) + uint64_t(len);

  if (dstOffsetLimit > memLen || srcOffsetLimit > memLen) {
    JSContext* cx = TlsContext.get();
    JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr,
                              JSMSG_WASM_OUT_OF_BOUNDS);
    return -1;
  }

  memMove(memBase + dstByteOffset, memBase + srcByteOffset, size_t(len));
  return 0;
}

/* static */ int32_t Instance::memCopy(Instance* instance,
                                       uint32_t dstByteOffset,
                                       uint32_t srcByteOffset, uint32_t len,
                                       uint8_t* memBase) {
  MOZ_ASSERT(SASigMemCopy.failureMode == FailureMode::FailOnNegI32);

  const WasmArrayRawBuffer* rawBuf = WasmArrayRawBuffer::fromDataPtr(memBase);
  uint32_t memLen = rawBuf->byteLength();

  return WasmMemoryCopy(memBase, memLen, dstByteOffset, srcByteOffset, len,
                        memmove);
}

/* static */ int32_t Instance::memCopyShared(Instance* instance,
                                             uint32_t dstByteOffset,
                                             uint32_t srcByteOffset,
                                             uint32_t len, uint8_t* memBase) {
  MOZ_ASSERT(SASigMemCopy.failureMode == FailureMode::FailOnNegI32);

  using RacyMemMove =
      void (*)(SharedMem<uint8_t*>, SharedMem<uint8_t*>, size_t);

  const SharedArrayRawBuffer* rawBuf =
      SharedArrayRawBuffer::fromDataPtr(memBase);
  uint32_t memLen = rawBuf->volatileByteLength();

  return WasmMemoryCopy<SharedMem<uint8_t*>, RacyMemMove>(
      SharedMem<uint8_t*>::shared(memBase), memLen, dstByteOffset,
      srcByteOffset, len, AtomicOperations::memmoveSafeWhenRacy);
}

/* static */ int32_t Instance::dataDrop(Instance* instance, uint32_t segIndex) {
  MOZ_ASSERT(SASigDataDrop.failureMode == FailureMode::FailOnNegI32);

  MOZ_RELEASE_ASSERT(size_t(segIndex) < instance->passiveDataSegments_.length(),
                     "ensured by validation");

  if (!instance->passiveDataSegments_[segIndex]) {
    return 0;
  }

  SharedDataSegment& segRefPtr = instance->passiveDataSegments_[segIndex];
  MOZ_RELEASE_ASSERT(!segRefPtr->active());

  // Drop this instance's reference to the DataSegment so it can be released.
  segRefPtr = nullptr;
  return 0;
}

template <typename T, typename F>
inline int32_t WasmMemoryFill(T memBase, uint32_t memLen, uint32_t byteOffset,
                              uint32_t value, uint32_t len, F memSet) {
  // Bounds check and deal with arithmetic overflow.
  uint64_t offsetLimit = uint64_t(byteOffset) + uint64_t(len);

  if (offsetLimit > memLen) {
    JSContext* cx = TlsContext.get();
    JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr,
                              JSMSG_WASM_OUT_OF_BOUNDS);
    return -1;
  }

  // The required write direction is upward, but that is not currently
  // observable as there are no fences nor any read/write protect operation.
  memSet(memBase + byteOffset, int(value), size_t(len));
  return 0;
}

/* static */ int32_t Instance::memFill(Instance* instance, uint32_t byteOffset,
                                       uint32_t value, uint32_t len,
                                       uint8_t* memBase) {
  MOZ_ASSERT(SASigMemFill.failureMode == FailureMode::FailOnNegI32);

  const WasmArrayRawBuffer* rawBuf = WasmArrayRawBuffer::fromDataPtr(memBase);
  uint32_t memLen = rawBuf->byteLength();

  return WasmMemoryFill(memBase, memLen, byteOffset, value, len, memset);
}

/* static */ int32_t Instance::memFillShared(Instance* instance,
                                             uint32_t byteOffset,
                                             uint32_t value, uint32_t len,
                                             uint8_t* memBase) {
  MOZ_ASSERT(SASigMemFill.failureMode == FailureMode::FailOnNegI32);

  const SharedArrayRawBuffer* rawBuf =
      SharedArrayRawBuffer::fromDataPtr(memBase);
  uint32_t memLen = rawBuf->volatileByteLength();

  return WasmMemoryFill(SharedMem<uint8_t*>::shared(memBase), memLen,
                        byteOffset, value, len,
                        AtomicOperations::memsetSafeWhenRacy);
}

/* static */ int32_t Instance::memInit(Instance* instance, uint32_t dstOffset,
                                       uint32_t srcOffset, uint32_t len,
                                       uint32_t segIndex) {
  MOZ_ASSERT(SASigMemInit.failureMode == FailureMode::FailOnNegI32);

  MOZ_RELEASE_ASSERT(size_t(segIndex) < instance->passiveDataSegments_.length(),
                     "ensured by validation");

  if (!instance->passiveDataSegments_[segIndex]) {
    if (len == 0 && srcOffset == 0) {
      return 0;
    }

    JS_ReportErrorNumberASCII(TlsContext.get(), GetErrorMessage, nullptr,
                              JSMSG_WASM_OUT_OF_BOUNDS);
    return -1;
  }

  const DataSegment& seg = *instance->passiveDataSegments_[segIndex];
  MOZ_RELEASE_ASSERT(!seg.active());

  const uint32_t segLen = seg.bytes.length();

  WasmMemoryObject* mem = instance->memory();
  const uint32_t memLen = mem->volatileMemoryLength();

  // We are proposing to copy
  //
  //   seg.bytes.begin()[ srcOffset .. srcOffset + len - 1 ]
  // to
  //   memoryBase[ dstOffset .. dstOffset + len - 1 ]

  // Bounds check and deal with arithmetic overflow.
  uint64_t dstOffsetLimit = uint64_t(dstOffset) + uint64_t(len);
  uint64_t srcOffsetLimit = uint64_t(srcOffset) + uint64_t(len);

  if (dstOffsetLimit > memLen || srcOffsetLimit > segLen) {
    JS_ReportErrorNumberASCII(TlsContext.get(), GetErrorMessage, nullptr,
                              JSMSG_WASM_OUT_OF_BOUNDS);
    return -1;
  }

  // The required read/write direction is upward, but that is not currently
  // observable as there are no fences nor any read/write protect operation.
  SharedMem<uint8_t*> dataPtr = mem->buffer().dataPointerEither();
  if (mem->isShared()) {
    AtomicOperations::memcpySafeWhenRacy(
        dataPtr + dstOffset, (uint8_t*)seg.bytes.begin() + srcOffset, len);
  } else {
    uint8_t* rawBuf = dataPtr.unwrap(/*Unshared*/);
    memcpy(rawBuf + dstOffset, (const char*)seg.bytes.begin() + srcOffset, len);
  }
  return 0;
}

/* static */ int32_t Instance::tableCopy(Instance* instance, uint32_t dstOffset,
                                         uint32_t srcOffset, uint32_t len,
                                         uint32_t dstTableIndex,
                                         uint32_t srcTableIndex) {
  MOZ_ASSERT(SASigMemCopy.failureMode == FailureMode::FailOnNegI32);

  const SharedTable& srcTable = instance->tables()[srcTableIndex];
  uint32_t srcTableLen = srcTable->length();

  const SharedTable& dstTable = instance->tables()[dstTableIndex];
  uint32_t dstTableLen = dstTable->length();

  // Bounds check and deal with arithmetic overflow.
  uint64_t dstOffsetLimit = uint64_t(dstOffset) + len;
  uint64_t srcOffsetLimit = uint64_t(srcOffset) + len;

  if (dstOffsetLimit > dstTableLen || srcOffsetLimit > srcTableLen) {
    JS_ReportErrorNumberASCII(TlsContext.get(), GetErrorMessage, nullptr,
                              JSMSG_WASM_OUT_OF_BOUNDS);
    return -1;
  }

  bool isOOM = false;

  if (&srcTable == &dstTable && dstOffset > srcOffset) {
    for (uint32_t i = len; i > 0; i--) {
      if (!dstTable->copy(*srcTable, dstOffset + (i - 1),
                          srcOffset + (i - 1))) {
        isOOM = true;
        break;
      }
    }
  } else if (&srcTable == &dstTable && dstOffset == srcOffset) {
    // No-op
  } else {
    for (uint32_t i = 0; i < len; i++) {
      if (!dstTable->copy(*srcTable, dstOffset + i, srcOffset + i)) {
        isOOM = true;
        break;
      }
    }
  }

  if (isOOM) {
    return -1;
  }
  return 0;
}

/* static */ int32_t Instance::elemDrop(Instance* instance, uint32_t segIndex) {
  MOZ_ASSERT(SASigDataDrop.failureMode == FailureMode::FailOnNegI32);

  MOZ_RELEASE_ASSERT(size_t(segIndex) < instance->passiveElemSegments_.length(),
                     "ensured by validation");

  if (!instance->passiveElemSegments_[segIndex]) {
    return 0;
  }

  SharedElemSegment& segRefPtr = instance->passiveElemSegments_[segIndex];
  MOZ_RELEASE_ASSERT(!segRefPtr->active());

  // Drop this instance's reference to the ElemSegment so it can be released.
  segRefPtr = nullptr;
  return 0;
}

bool Instance::initElems(uint32_t tableIndex, const ElemSegment& seg,
                         uint32_t dstOffset, uint32_t srcOffset, uint32_t len) {
  Table& table = *tables_[tableIndex];
  MOZ_ASSERT(dstOffset <= table.length());
  MOZ_ASSERT(len <= table.length() - dstOffset);

  Tier tier = code().bestTier();
  const MetadataTier& metadataTier = metadata(tier);
  const FuncImportVector& funcImports = metadataTier.funcImports;
  const CodeRangeVector& codeRanges = metadataTier.codeRanges;
  const Uint32Vector& funcToCodeRange = metadataTier.funcToCodeRange;
  const Uint32Vector& elemFuncIndices = seg.elemFuncIndices;
  MOZ_ASSERT(srcOffset <= elemFuncIndices.length());
  MOZ_ASSERT(len <= elemFuncIndices.length() - srcOffset);

  uint8_t* codeBaseTier = codeBase(tier);
  for (uint32_t i = 0; i < len; i++) {
    uint32_t funcIndex = elemFuncIndices[srcOffset + i];
    if (funcIndex == NullFuncIndex) {
      table.setNull(dstOffset + i);
    } else if (!table.isFunction()) {
      // Note, fnref must be rooted if we do anything more than just store it.
      void* fnref = Instance::refFunc(this, funcIndex);
      if (fnref == AnyRef::invalid().forCompiledCode()) {
        return false;  // OOM, which has already been reported.
      }
      table.fillAnyRef(dstOffset + i, 1, AnyRef::fromCompiledCode(fnref));
    } else {
      if (funcIndex < funcImports.length()) {
        FuncImportTls& import = funcImportTls(funcImports[funcIndex]);
        JSFunction* fun = import.fun;
        if (IsWasmExportedFunction(fun)) {
          // This element is a wasm function imported from another
          // instance. To preserve the === function identity required by
          // the JS embedding spec, we must set the element to the
          // imported function's underlying CodeRange.funcTableEntry and
          // Instance so that future Table.get()s produce the same
          // function object as was imported.
          WasmInstanceObject* calleeInstanceObj =
              ExportedFunctionToInstanceObject(fun);
          Instance& calleeInstance = calleeInstanceObj->instance();
          Tier calleeTier = calleeInstance.code().bestTier();
          const CodeRange& calleeCodeRange =
              calleeInstanceObj->getExportedFunctionCodeRange(fun, calleeTier);
          void* code = calleeInstance.codeBase(calleeTier) +
                       calleeCodeRange.funcTableEntry();
          table.setFuncRef(dstOffset + i, code, &calleeInstance);
          continue;
        }
      }
      void* code = codeBaseTier +
                   codeRanges[funcToCodeRange[funcIndex]].funcTableEntry();
      table.setFuncRef(dstOffset + i, code, this);
    }
  }
  return true;
}

/* static */ int32_t Instance::tableInit(Instance* instance, uint32_t dstOffset,
                                         uint32_t srcOffset, uint32_t len,
                                         uint32_t segIndex,
                                         uint32_t tableIndex) {
  MOZ_ASSERT(SASigTableInit.failureMode == FailureMode::FailOnNegI32);

  MOZ_RELEASE_ASSERT(size_t(segIndex) < instance->passiveElemSegments_.length(),
                     "ensured by validation");

  if (!instance->passiveElemSegments_[segIndex]) {
    if (len == 0 && srcOffset == 0) {
      return 0;
    }

    JS_ReportErrorNumberASCII(TlsContext.get(), GetErrorMessage, nullptr,
                              JSMSG_WASM_OUT_OF_BOUNDS);
    return -1;
  }

  const ElemSegment& seg = *instance->passiveElemSegments_[segIndex];
  MOZ_RELEASE_ASSERT(!seg.active());
  const uint32_t segLen = seg.length();

  const Table& table = *instance->tables()[tableIndex];
  const uint32_t tableLen = table.length();

  // We are proposing to copy
  //
  //   seg[ srcOffset .. srcOffset + len - 1 ]
  // to
  //   tableBase[ dstOffset .. dstOffset + len - 1 ]

  // Bounds check and deal with arithmetic overflow.
  uint64_t dstOffsetLimit = uint64_t(dstOffset) + uint64_t(len);
  uint64_t srcOffsetLimit = uint64_t(srcOffset) + uint64_t(len);

  if (dstOffsetLimit > tableLen || srcOffsetLimit > segLen) {
    JS_ReportErrorNumberASCII(TlsContext.get(), GetErrorMessage, nullptr,
                              JSMSG_WASM_OUT_OF_BOUNDS);
    return -1;
  }

  if (!instance->initElems(tableIndex, seg, dstOffset, srcOffset, len)) {
    return -1;  // OOM, which has already been reported.
  }

  return 0;
}

/* static */ int32_t Instance::tableFill(Instance* instance, uint32_t start,
                                         void* value, uint32_t len,
                                         uint32_t tableIndex) {
  MOZ_ASSERT(SASigTableFill.failureMode == FailureMode::FailOnNegI32);

  JSContext* cx = TlsContext.get();
  Table& table = *instance->tables()[tableIndex];

  // Bounds check and deal with arithmetic overflow.
  uint64_t offsetLimit = uint64_t(start) + uint64_t(len);

  if (offsetLimit > table.length()) {
    JS_ReportErrorNumberASCII(cx, GetErrorMessage, nullptr,
                              JSMSG_WASM_OUT_OF_BOUNDS);
    return -1;
  }

  switch (table.repr()) {
    case TableRepr::Ref:
      table.fillAnyRef(start, len, AnyRef::fromCompiledCode(value));
      break;
    case TableRepr::Func:
      MOZ_RELEASE_ASSERT(table.kind() == TableKind::FuncRef);
      table.fillFuncRef(start, len, FuncRef::fromCompiledCode(value), cx);
      break;
  }

  return 0;
}

/* static */ void* Instance::tableGet(Instance* instance, uint32_t index,
                                      uint32_t tableIndex) {
  MOZ_ASSERT(SASigTableGet.failureMode == FailureMode::FailOnInvalidRef);

  const Table& table = *instance->tables()[tableIndex];
  if (index >= table.length()) {
    JS_ReportErrorNumberASCII(TlsContext.get(), GetErrorMessage, nullptr,
                              JSMSG_WASM_TABLE_OUT_OF_BOUNDS);
    return AnyRef::invalid().forCompiledCode();
  }

  if (table.repr() == TableRepr::Ref) {
    return table.getAnyRef(index).forCompiledCode();
  }

  MOZ_RELEASE_ASSERT(table.kind() == TableKind::FuncRef);

  JSContext* cx = TlsContext.get();
  RootedFunction fun(cx);
  if (!table.getFuncRef(cx, index, &fun)) {
    return AnyRef::invalid().forCompiledCode();
  }

  return FuncRef::fromJSFunction(fun).forCompiledCode();
}

/* static */ uint32_t Instance::tableGrow(Instance* instance, void* initValue,
                                          uint32_t delta, uint32_t tableIndex) {
  MOZ_ASSERT(SASigTableGrow.failureMode == FailureMode::Infallible);

  RootedAnyRef ref(TlsContext.get(), AnyRef::fromCompiledCode(initValue));
  Table& table = *instance->tables()[tableIndex];

  uint32_t oldSize = table.grow(delta);

  if (oldSize != uint32_t(-1) && initValue != nullptr) {
    switch (table.repr()) {
      case TableRepr::Ref:
        table.fillAnyRef(oldSize, delta, ref);
        break;
      case TableRepr::Func:
        MOZ_RELEASE_ASSERT(table.kind() == TableKind::FuncRef);
        table.fillFuncRef(oldSize, delta, FuncRef::fromAnyRefUnchecked(ref),
                          TlsContext.get());
        break;
    }
  }

  return oldSize;
}

/* static */ int32_t Instance::tableSet(Instance* instance, uint32_t index,
                                        void* value, uint32_t tableIndex) {
  MOZ_ASSERT(SASigTableSet.failureMode == FailureMode::FailOnNegI32);

  Table& table = *instance->tables()[tableIndex];
  if (index >= table.length()) {
    JS_ReportErrorNumberASCII(TlsContext.get(), GetErrorMessage, nullptr,
                              JSMSG_WASM_TABLE_OUT_OF_BOUNDS);
    return -1;
  }

  switch (table.repr()) {
    case TableRepr::Ref:
      table.fillAnyRef(index, 1, AnyRef::fromCompiledCode(value));
      break;
    case TableRepr::Func:
      MOZ_RELEASE_ASSERT(table.kind() == TableKind::FuncRef);
      table.fillFuncRef(index, 1, FuncRef::fromCompiledCode(value),
                        TlsContext.get());
      break;
  }

  return 0;
}

/* static */ uint32_t Instance::tableSize(Instance* instance,
                                          uint32_t tableIndex) {
  MOZ_ASSERT(SASigTableSize.failureMode == FailureMode::Infallible);
  Table& table = *instance->tables()[tableIndex];
  return table.length();
}

/* static */ void* Instance::refFunc(Instance* instance, uint32_t funcIndex) {
  MOZ_ASSERT(SASigRefFunc.failureMode == FailureMode::FailOnInvalidRef);
  JSContext* cx = TlsContext.get();

  Tier tier = instance->code().bestTier();
  const MetadataTier& metadataTier = instance->metadata(tier);
  const FuncImportVector& funcImports = metadataTier.funcImports;

  // If this is an import, we need to recover the original function to maintain
  // reference equality between a re-exported function and 'ref.func'. The
  // identity of the imported function object is stable across tiers, which is
  // what we want.
  //
  // Use the imported function only if it is an exported function, otherwise
  // fall through to get a (possibly new) exported function.
  if (funcIndex < funcImports.length()) {
    FuncImportTls& import = instance->funcImportTls(funcImports[funcIndex]);
    if (IsWasmExportedFunction(import.fun)) {
      return FuncRef::fromJSFunction(import.fun).forCompiledCode();
    }
  }

  RootedFunction fun(cx);
  RootedWasmInstanceObject instanceObj(cx, instance->object());
  if (!WasmInstanceObject::getExportedFunction(cx, instanceObj, funcIndex,
                                               &fun)) {
    // Validation ensures that we always have a valid funcIndex, so we must
    // have OOM'ed
    ReportOutOfMemory(cx);
    return AnyRef::invalid().forCompiledCode();
  }

  return FuncRef::fromJSFunction(fun).forCompiledCode();
}

/* static */ void Instance::preBarrierFiltering(Instance* instance,
                                                gc::Cell** location) {
  MOZ_ASSERT(SASigPreBarrierFiltering.failureMode == FailureMode::Infallible);
  MOZ_ASSERT(location);
  JSObject::writeBarrierPre(*reinterpret_cast<JSObject**>(location));
}

/* static */ void Instance::postBarrier(Instance* instance,
                                        gc::Cell** location) {
  MOZ_ASSERT(SASigPostBarrier.failureMode == FailureMode::Infallible);
  MOZ_ASSERT(location);
  TlsContext.get()->runtime()->gc.storeBuffer().putCell(
      reinterpret_cast<JSObject**>(location));
}

/* static */ void Instance::postBarrierFiltering(Instance* instance,
                                                 gc::Cell** location) {
  MOZ_ASSERT(SASigPostBarrier.failureMode == FailureMode::Infallible);
  MOZ_ASSERT(location);
  if (*location == nullptr || !gc::IsInsideNursery(*location)) {
    return;
  }
  TlsContext.get()->runtime()->gc.storeBuffer().putCell(
      reinterpret_cast<JSObject**>(location));
}

// The typeIndex is an index into the structTypeDescrs_ table in the instance.
// That table holds TypeDescr objects.
//
// When we fail to allocate we return a nullptr; the wasm side must check this
// and propagate it as an error.

/* static */ void* Instance::structNew(Instance* instance, uint32_t typeIndex) {
  MOZ_ASSERT(SASigStructNew.failureMode == FailureMode::FailOnNullPtr);
  JSContext* cx = TlsContext.get();
  Rooted<TypeDescr*> typeDescr(cx, instance->structTypeDescrs_[typeIndex]);
  return TypedObject::createZeroed(cx, typeDescr);
}

/* static */ void* Instance::structNarrow(Instance* instance,
                                          uint32_t mustUnboxAnyref,
                                          uint32_t outputTypeIndex,
                                          void* maybeNullPtr) {
  MOZ_ASSERT(SASigStructNarrow.failureMode == FailureMode::Infallible);

  JSContext* cx = TlsContext.get();

  Rooted<TypedObject*> obj(cx);
  Rooted<StructTypeDescr*> typeDescr(cx);

  if (maybeNullPtr == nullptr) {
    return maybeNullPtr;
  }

  void* nonnullPtr = maybeNullPtr;
  if (mustUnboxAnyref) {
    // TODO/AnyRef-boxing: With boxed immediates and strings, unboxing
    // AnyRef is not a no-op.
    ASSERT_ANYREF_IS_JSOBJECT;

    Rooted<NativeObject*> no(cx, static_cast<NativeObject*>(nonnullPtr));
    if (!no->is<TypedObject>()) {
      return nullptr;
    }
    obj = &no->as<TypedObject>();
    Rooted<TypeDescr*> td(cx, &obj->typeDescr());
    if (td->kind() != type::Struct) {
      return nullptr;
    }
    typeDescr = &td->as<StructTypeDescr>();
  } else {
    obj = static_cast<TypedObject*>(nonnullPtr);
    typeDescr = &obj->typeDescr().as<StructTypeDescr>();
  }

  // Optimization opportunity: instead of this loop we could perhaps load an
  // index from `typeDescr` and use that to index into the structTypes table
  // of the instance.  If the index is in bounds and the desc at that index is
  // the desc we have then we know the index is good, and we can use that for
  // the prefix check.

  uint32_t found = UINT32_MAX;
  for (uint32_t i = 0; i < instance->structTypeDescrs_.length(); i++) {
    if (instance->structTypeDescrs_[i] == typeDescr) {
      found = i;
      break;
    }
  }

  if (found == UINT32_MAX) {
    return nullptr;
  }

  // Also asserted in constructor; let's just be double sure.

  MOZ_ASSERT(instance->structTypeDescrs_.length() ==
             instance->structTypes().length());

  // Now we know that the object was created by the instance, and we know its
  // concrete type.  We need to check that its type is an extension of the
  // type of outputTypeIndex.

  if (!instance->structTypes()[found].hasPrefix(
          instance->structTypes()[outputTypeIndex])) {
    return nullptr;
  }

  return nonnullPtr;
}

// Note, dst must point into nonmoveable storage that is not in the nursery,
// this matters for the write barriers.  Furthermore, for pointer types the
// current value of *dst must be null so that only a post-barrier is required.
//
// Regarding the destination not being in the nursery, we have these cases.
// Either the written location is in the global data section in the
// WasmInstanceObject, or the Cell of a WasmGlobalObject:
//
// - WasmInstanceObjects are always tenured and u.ref_ may point to a
//   nursery object, so we need a post-barrier since the global data of an
//   instance is effectively a field of the WasmInstanceObject.
//
// - WasmGlobalObjects are always tenured, and they have a Cell field, so a
//   post-barrier may be needed for the same reason as above.

void CopyValPostBarriered(uint8_t* dst, const Val& src) {
  switch (src.type().kind()) {
    case ValType::I32: {
      int32_t x = src.i32();
      memcpy(dst, &x, sizeof(x));
      break;
    }
    case ValType::I64: {
      int64_t x = src.i64();
      memcpy(dst, &x, sizeof(x));
      break;
    }
    case ValType::F32: {
      float x = src.f32();
      memcpy(dst, &x, sizeof(x));
      break;
    }
    case ValType::F64: {
      double x = src.f64();
      memcpy(dst, &x, sizeof(x));
      break;
    }
    case ValType::V128: {
      V128 x = src.v128();
      memcpy(dst, &x, sizeof(x));
      break;
    }
    case ValType::Ref: {
      // TODO/AnyRef-boxing: With boxed immediates and strings, the write
      // barrier is going to have to be more complicated.
      ASSERT_ANYREF_IS_JSOBJECT;
      MOZ_ASSERT(*(void**)dst == nullptr,
                 "should be null so no need for a pre-barrier");
      AnyRef x = src.ref();
      memcpy(dst, x.asJSObjectAddress(), sizeof(*x.asJSObjectAddress()));
      if (!x.isNull()) {
        JSObject::writeBarrierPost((JSObject**)dst, nullptr, x.asJSObject());
      }
      break;
    }
  }
}

Instance::Instance(JSContext* cx, Handle<WasmInstanceObject*> object,
                   SharedCode code, UniqueTlsData tlsDataIn,
                   HandleWasmMemoryObject memory, SharedTableVector&& tables,
                   StructTypeDescrVector&& structTypeDescrs,
                   UniqueDebugState maybeDebug)
    : realm_(cx->realm()),
      object_(object),
      jsJitArgsRectifier_(
          cx->runtime()->jitRuntime()->getArgumentsRectifier().value),
      jsJitExceptionHandler_(
          cx->runtime()->jitRuntime()->getExceptionTail().value),
      preBarrierCode_(
          cx->runtime()->jitRuntime()->preBarrier(MIRType::Object).value),
      code_(code),
      tlsData_(std::move(tlsDataIn)),
      memory_(memory),
      tables_(std::move(tables)),
      maybeDebug_(std::move(maybeDebug)),
      structTypeDescrs_(std::move(structTypeDescrs)) {}

bool Instance::init(JSContext* cx, const JSFunctionVector& funcImports,
                    const ValVector& globalImportValues,
                    const WasmGlobalObjectVector& globalObjs,
                    const DataSegmentVector& dataSegments,
                    const ElemSegmentVector& elemSegments) {
  MOZ_ASSERT(!!maybeDebug_ == metadata().debugEnabled);
  MOZ_ASSERT(structTypeDescrs_.length() == structTypes().length());

#ifdef DEBUG
  for (auto t : code_->tiers()) {
    MOZ_ASSERT(funcImports.length() == metadata(t).funcImports.length());
  }
#endif
  MOZ_ASSERT(tables_.length() == metadata().tables.length());

  tlsData()->memoryBase =
      memory_ ? memory_->buffer().dataPointerEither().unwrap() : nullptr;
  tlsData()->boundsCheckLimit = memory_ ? memory_->boundsCheckLimit() : 0;
  tlsData()->instance = this;
  tlsData()->realm = realm_;
  tlsData()->cx = cx;
  tlsData()->valueBoxClass = &WasmValueBox::class_;
  tlsData()->resetInterrupt(cx);
  tlsData()->jumpTable = code_->tieringJumpTable();
  tlsData()->addressOfNeedsIncrementalBarrier =
      (uint8_t*)cx->compartment()->zone()->addressOfNeedsIncrementalBarrier();

  // Initialize function imports in the tls data
  Tier callerTier = code_->bestTier();
  for (size_t i = 0; i < metadata(callerTier).funcImports.length(); i++) {
    JSFunction* f = funcImports[i];
    const FuncImport& fi = metadata(callerTier).funcImports[i];
    FuncImportTls& import = funcImportTls(fi);
    import.fun = f;
    if (!isAsmJS() && IsWasmExportedFunction(f)) {
      WasmInstanceObject* calleeInstanceObj =
          ExportedFunctionToInstanceObject(f);
      Instance& calleeInstance = calleeInstanceObj->instance();
      Tier calleeTier = calleeInstance.code().bestTier();
      const CodeRange& codeRange =
          calleeInstanceObj->getExportedFunctionCodeRange(f, calleeTier);
      import.tls = calleeInstance.tlsData();
      import.realm = f->realm();
      import.code =
          calleeInstance.codeBase(calleeTier) + codeRange.funcNormalEntry();
      import.jitScript = nullptr;
    } else if (void* thunk = MaybeGetBuiltinThunk(f, fi.funcType())) {
      import.tls = tlsData();
      import.realm = f->realm();
      import.code = thunk;
      import.jitScript = nullptr;
    } else {
      import.tls = tlsData();
      import.realm = f->realm();
      import.code = codeBase(callerTier) + fi.interpExitCodeOffset();
      import.jitScript = nullptr;
    }
  }

  // Initialize tables in the tls data
  for (size_t i = 0; i < tables_.length(); i++) {
    const TableDesc& td = metadata().tables[i];
    TableTls& table = tableTls(td);
    table.length = tables_[i]->length();
    table.functionBase = tables_[i]->functionBase();
  }

  // Initialize globals in the tls data
  for (size_t i = 0; i < metadata().globals.length(); i++) {
    const GlobalDesc& global = metadata().globals[i];

    // Constants are baked into the code, never stored in the global area.
    if (global.isConstant()) {
      continue;
    }

    uint8_t* globalAddr = globalData() + global.offset();
    switch (global.kind()) {
      case GlobalKind::Import: {
        size_t imported = global.importIndex();
        if (global.isIndirect()) {
          *(void**)globalAddr = globalObjs[imported]->cell();
        } else {
          CopyValPostBarriered(globalAddr, globalImportValues[imported]);
        }
        break;
      }
      case GlobalKind::Variable: {
        const InitExpr& init = global.initExpr();

        RootedVal val(cx);
        switch (init.kind()) {
          case InitExpr::Kind::Constant: {
            val = Val(init.val());
            break;
          }
          case InitExpr::Kind::GetGlobal: {
            const GlobalDesc& imported = metadata().globals[init.globalIndex()];

            // Global-ref initializers cannot reference mutable globals, so
            // the source global should never be indirect.
            MOZ_ASSERT(!imported.isIndirect());

            val = globalImportValues[imported.importIndex()];
            break;
          }
          case InitExpr::Kind::RefFunc: {
            void* fnref = Instance::refFunc(this, init.refFuncIndex());
            if (fnref == AnyRef::invalid().forCompiledCode()) {
              return false;  // OOM, which has already been reported.
            }
            val =
                Val(ValType(RefType::func()), FuncRef::fromCompiledCode(fnref));
            break;
          }
        }

        if (global.isIndirect()) {
          void* address = globalObjs[i]->cell();
          *(void**)globalAddr = address;
          CopyValPostBarriered((uint8_t*)address, val.get());
        } else {
          CopyValPostBarriered(globalAddr, val.get());
        }
        break;
      }
      case GlobalKind::Constant: {
        MOZ_CRASH("skipped at the top");
      }
    }
  }

  // Add observer if our memory base may grow
  if (memory_ && memory_->movingGrowable() &&
      !memory_->addMovingGrowObserver(cx, object_)) {
    return false;
  }

  // Add observers if our tables may grow
  for (const SharedTable& table : tables_) {
    if (table->movingGrowable() && !table->addMovingGrowObserver(cx, object_)) {
      return false;
    }
  }

  // Allocate in the global function type set for structural signature checks
  if (!metadata().funcTypeIds.empty()) {
    ExclusiveData<FuncTypeIdSet>::Guard lockedFuncTypeIdSet =
        funcTypeIdSet.lock();

    for (const FuncTypeWithId& funcType : metadata().funcTypeIds) {
      const void* funcTypeId;
      if (!lockedFuncTypeIdSet->allocateFuncTypeId(cx, funcType, &funcTypeId)) {
        return false;
      }

      *addressOfFuncTypeId(funcType.id) = funcTypeId;
    }
  }

  // Take references to the passive data segments
  if (!passiveDataSegments_.resize(dataSegments.length())) {
    return false;
  }
  for (size_t i = 0; i < dataSegments.length(); i++) {
    if (!dataSegments[i]->active()) {
      passiveDataSegments_[i] = dataSegments[i];
    }
  }

  // Take references to the passive element segments
  if (!passiveElemSegments_.resize(elemSegments.length())) {
    return false;
  }
  for (size_t i = 0; i < elemSegments.length(); i++) {
    if (elemSegments[i]->kind == ElemSegment::Kind::Passive) {
      passiveElemSegments_[i] = elemSegments[i];
    }
  }

  return true;
}

Instance::~Instance() {
  realm_->wasm.unregisterInstance(*this);

  const FuncImportVector& funcImports =
      metadata(code().stableTier()).funcImports;

  for (unsigned i = 0; i < funcImports.length(); i++) {
    FuncImportTls& import = funcImportTls(funcImports[i]);
    if (import.jitScript) {
      import.jitScript->removeDependentWasmImport(*this, i);
    }
  }

  if (!metadata().funcTypeIds.empty()) {
    ExclusiveData<FuncTypeIdSet>::Guard lockedFuncTypeIdSet =
        funcTypeIdSet.lock();

    for (const FuncTypeWithId& funcType : metadata().funcTypeIds) {
      if (const void* funcTypeId = *addressOfFuncTypeId(funcType.id)) {
        lockedFuncTypeIdSet->deallocateFuncTypeId(funcType, funcTypeId);
      }
    }
  }
}

size_t Instance::memoryMappedSize() const {
  return memory_->buffer().wasmMappedSize();
}

bool Instance::memoryAccessInGuardRegion(uint8_t* addr,
                                         unsigned numBytes) const {
  MOZ_ASSERT(numBytes > 0);

  if (!metadata().usesMemory()) {
    return false;
  }

  uint8_t* base = memoryBase().unwrap(/* comparison */);
  if (addr < base) {
    return false;
  }

  size_t lastByteOffset = addr - base + (numBytes - 1);
  return lastByteOffset >= memory()->volatileMemoryLength() &&
         lastByteOffset < memoryMappedSize();
}

bool Instance::memoryAccessInBounds(uint8_t* addr, unsigned numBytes) const {
  MOZ_ASSERT(numBytes > 0 && numBytes <= sizeof(double));

  if (!metadata().usesMemory()) {
    return false;
  }

  uint8_t* base = memoryBase().unwrap(/* comparison */);
  if (addr < base) {
    return false;
  }

  uint32_t length = memory()->volatileMemoryLength();
  if (addr >= base + length) {
    return false;
  }

  // The pointer points into the memory.  Now check for partial OOB.
  //
  // This calculation can't wrap around because the access is small and there
  // always is a guard page following the memory.
  size_t lastByteOffset = addr - base + (numBytes - 1);
  if (lastByteOffset >= length) {
    return false;
  }

  return true;
}

void Instance::tracePrivate(JSTracer* trc) {
  // This method is only called from WasmInstanceObject so the only reason why
  // TraceEdge is called is so that the pointer can be updated during a moving
  // GC.
  MOZ_ASSERT_IF(trc->isMarkingTracer(), gc::IsMarked(trc->runtime(), &object_));
  TraceEdge(trc, &object_, "wasm instance object");

  // OK to just do one tier here; though the tiers have different funcImports
  // tables, they share the tls object.
  for (const FuncImport& fi : metadata(code().stableTier()).funcImports) {
    TraceNullableEdge(trc, &funcImportTls(fi).fun, "wasm import");
  }

  for (const SharedTable& table : tables_) {
    table->trace(trc);
  }

  for (const GlobalDesc& global : code().metadata().globals) {
    // Indirect reference globals get traced by the owning WebAssembly.Global.
    if (!global.type().isReference() || global.isConstant() ||
        global.isIndirect()) {
      continue;
    }
    GCPtrObject* obj = (GCPtrObject*)(globalData() + global.offset());
    TraceNullableEdge(trc, obj, "wasm reference-typed global");
  }

  TraceNullableEdge(trc, &memory_, "wasm buffer");
  structTypeDescrs_.trace(trc);

  if (maybeDebug_) {
    maybeDebug_->trace(trc);
  }
}

void Instance::trace(JSTracer* trc) {
  // Technically, instead of having this method, the caller could use
  // Instance::object() to get the owning WasmInstanceObject to mark,
  // but this method is simpler and more efficient. The trace hook of
  // WasmInstanceObject will call Instance::tracePrivate at which point we
  // can mark the rest of the children.
  TraceEdge(trc, &object_, "wasm instance object");
}

uintptr_t Instance::traceFrame(JSTracer* trc, const wasm::WasmFrameIter& wfi,
                               uint8_t* nextPC,
                               uintptr_t highestByteVisitedInPrevFrame) {
  const StackMap* map = code().lookupStackMap(nextPC);
  if (!map) {
    return 0;
  }

  Frame* frame = wfi.frame();

  // |frame| points somewhere in the middle of the area described by |map|.
  // We have to calculate |scanStart|, the lowest address that is described by
  // |map|, by consulting |map->frameOffsetFromTop|.

  const size_t numMappedBytes = map->numMappedWords * sizeof(void*);
  const uintptr_t scanStart = uintptr_t(frame) +
                              (map->frameOffsetFromTop * sizeof(void*)) -
                              numMappedBytes;
  MOZ_ASSERT(0 == scanStart % sizeof(void*));

  // Do what we can to assert that, for consecutive wasm frames, their stack
  // maps also abut exactly.  This is a useful sanity check on the sizing of
  // stack maps.
  //
  // In debug builds, the stackmap construction machinery goes to considerable
  // efforts to ensure that the stackmaps for consecutive frames abut exactly.
  // This is so as to ensure there are no areas of stack inadvertently ignored
  // by a stackmap, nor covered by two stackmaps.  Hence any failure of this
  // assertion is serious and should be investigated.
  MOZ_ASSERT_IF(highestByteVisitedInPrevFrame != 0,
                highestByteVisitedInPrevFrame + 1 == scanStart);

  uintptr_t* stackWords = (uintptr_t*)scanStart;

  // If we have some exit stub words, this means the map also covers an area
  // created by a exit stub, and so the highest word of that should be a
  // constant created by (code created by) GenerateTrapExit.
  MOZ_ASSERT_IF(
      map->numExitStubWords > 0,
      stackWords[map->numExitStubWords - 1 - TrapExitDummyValueOffsetFromTop] ==
          TrapExitDummyValue);

  // And actually hand them off to the GC.
  for (uint32_t i = 0; i < map->numMappedWords; i++) {
    if (map->getBit(i) == 0) {
      continue;
    }

    // TODO/AnyRef-boxing: With boxed immediates and strings, the value may
    // not be a traceable JSObject*.
    ASSERT_ANYREF_IS_JSOBJECT;

    // This assertion seems at least moderately effective in detecting
    // discrepancies or misalignments between the map and reality.
    MOZ_ASSERT(js::gc::IsCellPointerValidOrNull((const void*)stackWords[i]));

    if (stackWords[i]) {
      TraceRoot(trc, (JSObject**)&stackWords[i],
                "Instance::traceWasmFrame: normal word");
    }
  }

  // Finally, deal with any GC-managed fields in the DebugFrame, if it is
  // present.
  if (map->hasDebugFrame) {
    DebugFrame* debugFrame = DebugFrame::from(frame);
    char* debugFrameP = (char*)debugFrame;

    // TODO/AnyRef-boxing: With boxed immediates and strings, the value may
    // not be a traceable JSObject*.
    ASSERT_ANYREF_IS_JSOBJECT;

    for (size_t i = 0; i < MaxRegisterResults; i++) {
      if (debugFrame->hasSpilledRegisterRefResult(i)) {
        char* resultRefP = debugFrameP + DebugFrame::offsetOfRegisterResult(i);
        TraceNullableRoot(
            trc, (JSObject**)resultRefP,
            "Instance::traceWasmFrame: DebugFrame::resultResults_");
      }
    }

    if (debugFrame->hasCachedReturnJSValue()) {
      char* cachedReturnJSValueP =
          debugFrameP + DebugFrame::offsetOfCachedReturnJSValue();
      TraceRoot(trc, (js::Value*)cachedReturnJSValueP,
                "Instance::traceWasmFrame: DebugFrame::cachedReturnJSValue_");
    }
  }

  return scanStart + numMappedBytes - 1;
}

WasmMemoryObject* Instance::memory() const { return memory_; }

SharedMem<uint8_t*> Instance::memoryBase() const {
  MOZ_ASSERT(metadata().usesMemory());
  MOZ_ASSERT(tlsData()->memoryBase == memory_->buffer().dataPointerEither());
  return memory_->buffer().dataPointerEither();
}

SharedArrayRawBuffer* Instance::sharedMemoryBuffer() const {
  MOZ_ASSERT(memory_->isShared());
  return memory_->sharedArrayRawBuffer();
}

WasmInstanceObject* Instance::objectUnbarriered() const {
  return object_.unbarrieredGet();
}

WasmInstanceObject* Instance::object() const { return object_; }

static bool EnsureEntryStubs(const Instance& instance, uint32_t funcIndex,
                             const FuncExport** funcExport,
                             void** interpEntry) {
  Tier tier = instance.code().bestTier();

  size_t funcExportIndex;
  *funcExport =
      &instance.metadata(tier).lookupFuncExport(funcIndex, &funcExportIndex);

  const FuncExport& fe = **funcExport;
  if (fe.hasEagerStubs()) {
    *interpEntry = instance.codeBase(tier) + fe.eagerInterpEntryOffset();
    return true;
  }

  MOZ_ASSERT(!instance.isAsmJS(), "only wasm can lazily export functions");

  // If the best tier is Ion, life is simple: background compilation has
  // already completed and has been committed, so there's no risk of race
  // conditions here.
  //
  // If the best tier is Baseline, there could be a background compilation
  // happening at the same time. The background compilation will lock the
  // first tier lazy stubs first to stop new baseline stubs from being
  // generated, then the second tier stubs to generate them.
  //
  // - either we take the tier1 lazy stub lock before the background
  // compilation gets it, then we generate the lazy stub for tier1. When the
  // background thread gets the tier1 lazy stub lock, it will see it has a
  // lazy stub and will recompile it for tier2.
  // - or we don't take the lock here first. Background compilation won't
  // find a lazy stub for this function, thus won't generate it. So we'll do
  // it ourselves after taking the tier2 lock.

  auto stubs = instance.code(tier).lazyStubs().lock();
  *interpEntry = stubs->lookupInterpEntry(fe.funcIndex());
  if (*interpEntry) {
    return true;
  }

  // The best tier might have changed after we've taken the lock.
  Tier prevTier = tier;
  tier = instance.code().bestTier();
  const CodeTier& codeTier = instance.code(tier);
  if (tier == prevTier) {
    if (!stubs->createOne(funcExportIndex, codeTier)) {
      return false;
    }

    *interpEntry = stubs->lookupInterpEntry(fe.funcIndex());
    MOZ_ASSERT(*interpEntry);
    return true;
  }

  MOZ_RELEASE_ASSERT(prevTier == Tier::Baseline && tier == Tier::Optimized);
  auto stubs2 = instance.code(tier).lazyStubs().lock();

  // If it didn't have a stub in the first tier, background compilation
  // shouldn't have made one in the second tier.
  MOZ_ASSERT(!stubs2->hasStub(fe.funcIndex()));

  if (!stubs2->createOne(funcExportIndex, codeTier)) {
    return false;
  }

  *interpEntry = stubs2->lookupInterpEntry(fe.funcIndex());
  MOZ_ASSERT(*interpEntry);
  return true;
}

static bool GetInterpEntry(Instance& instance, uint32_t funcIndex,
                           CallArgs args, void** interpEntry,
                           const FuncType** funcType) {
  const FuncExport* funcExport;
  if (!EnsureEntryStubs(instance, funcIndex, &funcExport, interpEntry)) {
    return false;
  }

  // EnsureEntryStubs() has ensured jit-entry stubs have been created and
  // installed in funcIndex's JumpTable entry, so we can now set the
  // JSFunction's jit-entry. See WasmInstanceObject::getExportedFunction().
  if (!funcExport->hasEagerStubs() && funcExport->canHaveJitEntry()) {
    JSFunction& callee = args.callee().as<JSFunction>();
    MOZ_ASSERT(!callee.isAsmJSNative(), "asm.js only has eager stubs");
    if (!callee.isWasmWithJitEntry()) {
      callee.setWasmJitEntry(instance.code().getAddressOfJitEntry(funcIndex));
    }
  }

  *funcType = &funcExport->funcType();
  return true;
}

bool wasm::ResultsToJSValue(JSContext* cx, ResultType type,
                            void* registerResultLoc,
                            Maybe<char*> stackResultsLoc,
                            MutableHandleValue rval) {
  if (type.empty()) {
    // No results: set to undefined, and we're done.
    rval.setUndefined();
    return true;
  }

  // If we added support for multiple register results, we'd need to establish a
  // convention for how to store them to memory in registerResultLoc.  For now
  // we can punt.
  static_assert(MaxRegisterResults == 1);

  // Stack results written to stackResultsLoc; register result written
  // to registerResultLoc.

  // First, convert the register return value, and prepare to iterate in
  // push order.  Note that if the register result is a reference type,
  // it may be unrooted, so ToJSValue_anyref must not GC in that case.
  ABIResultIter iter(type);
  DebugOnly<bool> usedRegisterResult = false;
  for (; !iter.done(); iter.next()) {
    if (iter.cur().inRegister()) {
      MOZ_ASSERT(!usedRegisterResult);
      if (!ToJSValue<DebugCodegenVal>(cx, registerResultLoc, iter.cur().type(),
                                      rval)) {
        return false;
      }
      usedRegisterResult = true;
    }
  }
  MOZ_ASSERT(usedRegisterResult);

  MOZ_ASSERT((stackResultsLoc.isSome()) == (iter.count() > 1));
  if (!stackResultsLoc) {
    // A single result: we're done.
    return true;
  }

  // Otherwise, collect results in an array, in push order.
  Rooted<ArrayObject*> array(cx, NewDenseEmptyArray(cx));
  if (!array) {
    return false;
  }
  RootedValue tmp(cx);
  for (iter.switchToPrev(); !iter.done(); iter.prev()) {
    const ABIResult& result = iter.cur();
    if (result.onStack()) {
      char* loc = stackResultsLoc.value() + result.stackOffset();
      if (!ToJSValue<DebugCodegenVal>(cx, loc, result.type(), &tmp)) {
        return false;
      }
      if (!NewbornArrayPush(cx, array, tmp)) {
        return false;
      }
    } else {
      if (!NewbornArrayPush(cx, array, rval)) {
        return false;
      }
    }
  }
  rval.set(ObjectValue(*array));
  return true;
}

class MOZ_RAII ReturnToJSResultCollector {
  class MOZ_RAII StackResultsRooter : public JS::CustomAutoRooter {
    ReturnToJSResultCollector& collector_;

   public:
    StackResultsRooter(JSContext* cx, ReturnToJSResultCollector& collector)
        : JS::CustomAutoRooter(cx), collector_(collector) {}

    void trace(JSTracer* trc) final {
      for (ABIResultIter iter(collector_.type_); !iter.done(); iter.next()) {
        const ABIResult& result = iter.cur();
        if (result.onStack() && result.type().isReference()) {
          char* loc = collector_.stackResultsArea_.get() + result.stackOffset();
          JSObject** refLoc = reinterpret_cast<JSObject**>(loc);
          TraceNullableRoot(trc, refLoc, "StackResultsRooter::trace");
        }
      }
    }
  };
  friend class StackResultsRooter;

  ResultType type_;
  UniquePtr<char[], JS::FreePolicy> stackResultsArea_;
  Maybe<StackResultsRooter> rooter_;

 public:
  explicit ReturnToJSResultCollector(const ResultType& type) : type_(type){};
  bool init(JSContext* cx) {
    bool needRooter = false;
    ABIResultIter iter(type_);
    for (; !iter.done(); iter.next()) {
      const ABIResult& result = iter.cur();
      if (result.onStack() && result.type().isReference()) {
        needRooter = true;
      }
    }
    uint32_t areaBytes = iter.stackBytesConsumedSoFar();
    MOZ_ASSERT_IF(needRooter, areaBytes > 0);
    if (areaBytes > 0) {
      // It is necessary to zero storage for ref results, and it doesn't
      // hurt to do so for other POD results.
      stackResultsArea_ = cx->make_zeroed_pod_array<char>(areaBytes);
      if (!stackResultsArea_) {
        return false;
      }
      if (needRooter) {
        rooter_.emplace(cx, *this);
      }
    }
    return true;
  }

  void* stackResultsArea() {
    MOZ_ASSERT(stackResultsArea_);
    return stackResultsArea_.get();
  }

  bool collect(JSContext* cx, void* registerResultLoc,
               MutableHandleValue rval) {
    Maybe<char*> stackResultsLoc =
        stackResultsArea_ ? Some(stackResultsArea_.get()) : Nothing();
    return ResultsToJSValue(cx, type_, registerResultLoc, stackResultsLoc,
                            rval);
  }
};

bool Instance::callExport(JSContext* cx, uint32_t funcIndex, CallArgs args) {
  if (memory_) {
    // If there has been a moving grow, this Instance should have been notified.
    MOZ_RELEASE_ASSERT(memory_->buffer().dataPointerEither() == memoryBase());
  }

  void* interpEntry;
  const FuncType* funcType;
  if (!GetInterpEntry(*this, funcIndex, args, &interpEntry, &funcType)) {
    return false;
  }

#ifdef ENABLE_WASM_SIMD
  if (funcType->hasV128ArgOrRet()) {
    JS_ReportErrorNumberUTF8(cx, GetErrorMessage, nullptr,
                             JSMSG_WASM_BAD_VAL_TYPE);
    return false;
  }
#endif

  ArgTypeVector argTypes(*funcType);
  ResultType resultType(ResultType::Vector(funcType->results()));
  ReturnToJSResultCollector results(resultType);
  if (!results.init(cx)) {
    return false;
  }

  // The calling convention for an external call into wasm is to pass an
  // array of 16-byte values where each value contains either a coerced int32
  // (in the low word), or a double value (in the low dword) value, with the
  // coercions specified by the wasm signature. The external entry point
  // unpacks this array into the system-ABI-specified registers and stack
  // memory and then calls into the internal entry point. The return value is
  // stored in the first element of the array (which, therefore, must have
  // length >= 1).
  Vector<ExportArg, 8> exportArgs(cx);
  if (!exportArgs.resize(
          std::max<size_t>(1, argTypes.lengthWithStackResults()))) {
    return false;
  }

  ASSERT_ANYREF_IS_JSOBJECT;
  Rooted<GCVector<JSObject*, 8, SystemAllocPolicy>> refs(cx);

  DebugCodegen(DebugChannel::Function, "wasm-function[%d] arguments [",
               funcIndex);
  RootedValue v(cx);
  for (size_t i = 0; i < argTypes.lengthWithStackResults(); ++i) {
    void* rawArgLoc = &exportArgs[i];
    if (argTypes.isSyntheticStackResultPointerArg(i)) {
      *reinterpret_cast<void**>(rawArgLoc) = results.stackResultsArea();
      continue;
    }
    size_t naturalIdx = argTypes.naturalIndex(i);
    v = naturalIdx < args.length() ? args[naturalIdx] : UndefinedValue();
    ValType type = funcType->arg(naturalIdx);
    if (!ToWebAssemblyValue<DebugCodegenVal>(cx, v, type, rawArgLoc, true)) {
      return false;
    }
    if (type.isReference()) {
      void* ptr = *reinterpret_cast<void**>(rawArgLoc);
      // Store in rooted array until no more GC is possible.
      switch (type.refTypeKind()) {
        case RefType::Func: {
          RootedFunction ref(cx, FuncRef::fromCompiledCode(ptr).asJSFunction());
          if (!refs.emplaceBack(ref)) {
            return false;
          }
          break;
        }
        case RefType::Any: {
          RootedAnyRef ref(cx, AnyRef::fromCompiledCode(ptr));
          ASSERT_ANYREF_IS_JSOBJECT;
          if (!refs.emplaceBack(ref.get().asJSObject())) {
            return false;
          }
          break;
        }
        case RefType::TypeIndex:
          MOZ_CRASH("temporarily unsupported Ref type in callExport");
      }
      DebugCodegen(DebugChannel::Function, "/(#%d)", int(refs.length() - 1));
    }
  }

  // Copy over reference values from the rooted array, if any.
  if (refs.length() > 0) {
    DebugCodegen(DebugChannel::Function, "; ");
    size_t nextRef = 0;
    for (size_t i = 0; i < argTypes.lengthWithStackResults(); ++i) {
      if (argTypes.isSyntheticStackResultPointerArg(i)) {
        continue;
      }
      size_t naturalIdx = argTypes.naturalIndex(i);
      ValType type = funcType->arg(naturalIdx);
      if (type.isReference()) {
        void** rawArgLoc = (void**)&exportArgs[i];
        *rawArgLoc = refs[nextRef++];
        DebugCodegen(DebugChannel::Function, " ref(#%d) := %p ",
                     int(nextRef - 1), *rawArgLoc);
      }
    }
    refs.clear();
  }

  DebugCodegen(DebugChannel::Function, "]\n");

  {
    JitActivation activation(cx);

    // Call the per-exported-function trampoline created by GenerateEntry.
    auto funcPtr = JS_DATA_TO_FUNC_PTR(ExportFuncPtr, interpEntry);
    if (!CALL_GENERATED_2(funcPtr, exportArgs.begin(), tlsData())) {
      return false;
    }
  }

  if (isAsmJS() && args.isConstructing()) {
    // By spec, when a JS function is called as a constructor and this
    // function returns a primary type, which is the case for all asm.js
    // exported functions, the returned value is discarded and an empty
    // object is returned instead.
    PlainObject* obj = NewBuiltinClassInstance<PlainObject>(cx);
    if (!obj) {
      return false;
    }
    args.rval().set(ObjectValue(*obj));
    return true;
  }

  // Note that we're not rooting the register result, if any; we depend
  // on ResultsCollector::collect to root the value on our behalf,
  // before causing any GC.
  void* registerResultLoc = &exportArgs[0];
  DebugCodegen(DebugChannel::Function, "wasm-function[%d]; results [",
               funcIndex);
  if (!results.collect(cx, registerResultLoc, args.rval())) {
    return false;
  }
  DebugCodegen(DebugChannel::Function, "]\n");

  return true;
}

JSAtom* Instance::getFuncDisplayAtom(JSContext* cx, uint32_t funcIndex) const {
  // The "display name" of a function is primarily shown in Error.stack which
  // also includes location, so use getFuncNameBeforeLocation.
  UTF8Bytes name;
  if (!metadata().getFuncNameBeforeLocation(funcIndex, &name)) {
    return nullptr;
  }

  return AtomizeUTF8Chars(cx, name.begin(), name.length());
}

void Instance::ensureProfilingLabels(bool profilingEnabled) const {
  return code_->ensureProfilingLabels(profilingEnabled);
}

void Instance::onMovingGrowMemory() {
  MOZ_ASSERT(!isAsmJS());
  MOZ_ASSERT(!memory_->isShared());

  ArrayBufferObject& buffer = memory_->buffer().as<ArrayBufferObject>();
  tlsData()->memoryBase = buffer.dataPointer();
  tlsData()->boundsCheckLimit = memory_->boundsCheckLimit();
}

void Instance::onMovingGrowTable(const Table* theTable) {
  MOZ_ASSERT(!isAsmJS());

  // `theTable` has grown and we must update cached data for it.  Importantly,
  // we can have cached those data in more than one location: we'll have
  // cached them once for each time the table was imported into this instance.
  //
  // When an instance is registered as an observer of a table it is only
  // registered once, regardless of how many times the table was imported.
  // Thus when a table is grown, onMovingGrowTable() is only invoked once for
  // the table.
  //
  // Ergo we must go through the entire list of tables in the instance here
  // and check for the table in all the cached-data slots; we can't exit after
  // the first hit.

  for (uint32_t i = 0; i < tables_.length(); i++) {
    if (tables_[i] == theTable) {
      TableTls& table = tableTls(metadata().tables[i]);
      table.length = tables_[i]->length();
      table.functionBase = tables_[i]->functionBase();
    }
  }
}

void Instance::deoptimizeImportExit(uint32_t funcImportIndex) {
  Tier t = code().bestTier();
  const FuncImport& fi = metadata(t).funcImports[funcImportIndex];
  FuncImportTls& import = funcImportTls(fi);
  import.code = codeBase(t) + fi.interpExitCodeOffset();
  import.jitScript = nullptr;
}

JSString* Instance::createDisplayURL(JSContext* cx) {
  // In the best case, we simply have a URL, from a streaming compilation of a
  // fetched Response.

  if (metadata().filenameIsURL) {
    return NewStringCopyZ<CanGC>(cx, metadata().filename.get());
  }

  // Otherwise, build wasm module URL from following parts:
  // - "wasm:" as protocol;
  // - URI encoded filename from metadata (if can be encoded), plus ":";
  // - 64-bit hash of the module bytes (as hex dump).

  JSStringBuilder result(cx);
  if (!result.append("wasm:")) {
    return nullptr;
  }

  if (const char* filename = metadata().filename.get()) {
    // EncodeURI returns false due to invalid chars or OOM -- fail only
    // during OOM.
    JSString* filenamePrefix = EncodeURI(cx, filename, strlen(filename));
    if (!filenamePrefix) {
      if (cx->isThrowingOutOfMemory()) {
        return nullptr;
      }

      MOZ_ASSERT(!cx->isThrowingOverRecursed());
      cx->clearPendingException();
      return nullptr;
    }

    if (!result.append(filenamePrefix)) {
      return nullptr;
    }
  }

  if (metadata().debugEnabled) {
    if (!result.append(":")) {
      return nullptr;
    }

    const ModuleHash& hash = metadata().debugHash;
    for (size_t i = 0; i < sizeof(ModuleHash); i++) {
      char digit1 = hash[i] / 16, digit2 = hash[i] % 16;
      if (!result.append(
              (char)(digit1 < 10 ? digit1 + '0' : digit1 + 'a' - 10))) {
        return nullptr;
      }
      if (!result.append(
              (char)(digit2 < 10 ? digit2 + '0' : digit2 + 'a' - 10))) {
        return nullptr;
      }
    }
  }

  return result.finishString();
}

WasmBreakpointSite* Instance::getOrCreateBreakpointSite(JSContext* cx,
                                                        uint32_t offset) {
  MOZ_ASSERT(debugEnabled());
  return debug().getOrCreateBreakpointSite(cx, this, offset);
}

void Instance::destroyBreakpointSite(JSFreeOp* fop, uint32_t offset) {
  MOZ_ASSERT(debugEnabled());
  return debug().destroyBreakpointSite(fop, this, offset);
}

void Instance::disassembleExport(JSContext* cx, uint32_t funcIndex, Tier tier,
                                 PrintCallback callback) const {
  const MetadataTier& metadataTier = metadata(tier);
  const FuncExport& funcExport = metadataTier.lookupFuncExport(funcIndex);
  const CodeRange& range = metadataTier.codeRange(funcExport);
  const CodeTier& codeTier = code(tier);
  const ModuleSegment& segment = codeTier.segment();

  MOZ_ASSERT(range.begin() < segment.length());
  MOZ_ASSERT(range.end() < segment.length());

  uint8_t* functionCode = segment.base() + range.begin();
  jit::Disassemble(functionCode, range.end() - range.begin(), callback);
}

void Instance::addSizeOfMisc(MallocSizeOf mallocSizeOf,
                             Metadata::SeenSet* seenMetadata,
                             Code::SeenSet* seenCode,
                             Table::SeenSet* seenTables, size_t* code,
                             size_t* data) const {
  *data += mallocSizeOf(this);
  *data += mallocSizeOf(tlsData_.get());
  for (const SharedTable& table : tables_) {
    *data += table->sizeOfIncludingThisIfNotSeen(mallocSizeOf, seenTables);
  }

  if (maybeDebug_) {
    maybeDebug_->addSizeOfMisc(mallocSizeOf, seenMetadata, seenCode, code,
                               data);
  }

  code_->addSizeOfMiscIfNotSeen(mallocSizeOf, seenMetadata, seenCode, code,
                                data);
}
