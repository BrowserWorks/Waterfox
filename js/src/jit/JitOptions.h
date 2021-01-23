/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef jit_JitOptions_h
#define jit_JitOptions_h

#include "mozilla/Maybe.h"

#include "jit/IonTypes.h"
#include "js/TypeDecls.h"

namespace js {
namespace jit {

// Possible register allocators which may be used.
enum IonRegisterAllocator {
  RegisterAllocator_Backtracking,
  RegisterAllocator_Testbed,
};

static inline mozilla::Maybe<IonRegisterAllocator> LookupRegisterAllocator(
    const char* name) {
  if (!strcmp(name, "backtracking")) {
    return mozilla::Some(RegisterAllocator_Backtracking);
  }
  if (!strcmp(name, "testbed")) {
    return mozilla::Some(RegisterAllocator_Testbed);
  }
  return mozilla::Nothing();
}

struct DefaultJitOptions {
  bool checkGraphConsistency;
#ifdef CHECK_OSIPOINT_REGISTERS
  bool checkOsiPointRegisters;
#endif
  bool checkRangeAnalysis;
  bool runExtraChecks;
  bool disableInlineBacktracking;
  bool disableAma;
  bool disableEaa;
  bool disableEdgeCaseAnalysis;
  bool disableGvn;
  bool disableInlining;
  bool disableLicm;
  bool disablePgo;
  bool disableInstructionReordering;
  bool disableRangeAnalysis;
  bool disableRecoverIns;
  bool disableScalarReplacement;
  bool disableCacheIR;
  bool disableSink;
  bool disableOptimizationLevels;
  bool baselineInterpreter;
  bool baselineJit;
  bool ion;
#ifdef NIGHTLY_BUILD
  bool typeInference;
#endif
  bool warpBuilder;
  bool jitForTrustedPrincipals;
  bool nativeRegExp;
  bool forceInlineCaches;
  bool fullDebugChecks;
  bool limitScriptSize;
  bool osr;
  bool wasmFoldOffsets;
  bool wasmDelayTier2;
#ifdef JS_TRACE_LOGGING
  bool enableTraceLogger;
#endif
#ifdef ENABLE_NEW_REGEXP
  bool traceRegExpParser;
  bool traceRegExpAssembler;
  bool traceRegExpInterpreter;
  bool traceRegExpPeephole;
#endif
  bool enableWasmJitExit;
  bool enableWasmJitEntry;
  bool enableWasmIonFastCalls;
#ifdef WASM_CODEGEN_DEBUG
  bool enableWasmImportCallSpew;
  bool enableWasmFuncCallSpew;
#endif
  uint32_t baselineInterpreterWarmUpThreshold;
  uint32_t baselineJitWarmUpThreshold;
  uint32_t normalIonWarmUpThreshold;
  uint32_t fullIonWarmUpThreshold;
#ifdef ENABLE_NEW_REGEXP
  uint32_t regexpWarmUpThreshold;
#endif
  uint32_t exceptionBailoutThreshold;
  uint32_t frequentBailoutThreshold;
  uint32_t maxStackArgs;
  uint32_t osrPcMismatchesBeforeRecompile;
  uint32_t smallFunctionMaxBytecodeLength_;
  uint32_t jumpThreshold;
  uint32_t branchPruningHitCountFactor;
  uint32_t branchPruningInstFactor;
  uint32_t branchPruningBlockSpanFactor;
  uint32_t branchPruningEffectfulInstFactor;
  uint32_t branchPruningThreshold;
  uint32_t ionMaxScriptSize;
  uint32_t ionMaxScriptSizeMainThread;
  uint32_t ionMaxLocalsAndArgs;
  uint32_t ionMaxLocalsAndArgsMainThread;
  uint32_t wasmBatchBaselineThreshold;
  uint32_t wasmBatchIonThreshold;
  uint32_t wasmBatchCraneliftThreshold;
  mozilla::Maybe<IonRegisterAllocator> forcedRegisterAllocator;

  // Spectre mitigation flags. Each mitigation has its own flag in order to
  // measure the effectiveness of each mitigation with various proof of
  // concept.
  bool spectreIndexMasking;
  bool spectreObjectMitigationsBarriers;
  bool spectreObjectMitigationsMisc;
  bool spectreStringMitigations;
  bool spectreValueMasking;
  bool spectreJitToCxxCalls;

  bool supportsFloatingPoint;
  bool supportsUnalignedAccesses;

  DefaultJitOptions();
  bool isSmallFunction(JSScript* script) const;
  void setEagerBaselineCompilation();
  void setEagerIonCompilation();
  void setNormalIonWarmUpThreshold(uint32_t warmUpThreshold);
  void setFullIonWarmUpThreshold(uint32_t warmUpThreshold);
  void resetNormalIonWarmUpThreshold();
  void resetFullIonWarmUpThreshold();
  void enableGvn(bool val);

  bool eagerIonCompilation() const { return normalIonWarmUpThreshold == 0; }
};

extern DefaultJitOptions JitOptions;

inline bool IsBaselineInterpreterEnabled() {
#ifdef JS_CODEGEN_NONE
  return false;
#else
  return JitOptions.baselineInterpreter && JitOptions.supportsFloatingPoint;
#endif
}

}  // namespace jit

inline bool IsTypeInferenceEnabled() {
#ifdef NIGHTLY_BUILD
  return jit::JitOptions.typeInference;
#else
  // Always enable TI on non-Nightly for now to avoid performance overhead.
  return true;
#endif
}

}  // namespace js

#endif /* jit_JitOptions_h */
