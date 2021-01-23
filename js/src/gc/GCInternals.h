/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
 * GC-internal definitions.
 */

#ifndef gc_GCInternals_h
#define gc_GCInternals_h

#include "mozilla/ArrayUtils.h"
#include "mozilla/Maybe.h"

#include "gc/GC.h"
#include "vm/JSContext.h"

namespace js {
namespace gc {

/*
 * There are a couple of classes here that serve mostly as "tokens" indicating
 * that a precondition holds. Some functions force the caller to possess such a
 * token because they require the precondition to hold, and it is better to make
 * the precondition explicit at the API entry point than to crash in an
 * assertion later on when it is relied upon.
 */

struct MOZ_RAII AutoAssertNoNurseryAlloc {
#ifdef DEBUG
  AutoAssertNoNurseryAlloc();
  ~AutoAssertNoNurseryAlloc();
#else
  AutoAssertNoNurseryAlloc() {}
#endif
};

/*
 * A class that serves as a token that the nursery in the current thread's zone
 * group is empty.
 */
class MOZ_RAII AutoAssertEmptyNursery {
 protected:
  JSContext* cx;

  mozilla::Maybe<AutoAssertNoNurseryAlloc> noAlloc;

  // Check that the nursery is empty.
  void checkCondition(JSContext* cx);

  // For subclasses that need to empty the nursery in their constructors.
  AutoAssertEmptyNursery() : cx(nullptr) {}

 public:
  explicit AutoAssertEmptyNursery(JSContext* cx) : cx(nullptr) {
    checkCondition(cx);
  }

  AutoAssertEmptyNursery(const AutoAssertEmptyNursery& other)
      : AutoAssertEmptyNursery(other.cx) {}
};

/*
 * Evict the nursery upon construction. Serves as a token indicating that the
 * nursery is empty. (See AutoAssertEmptyNursery, above.)
 */
class MOZ_RAII AutoEmptyNursery : public AutoAssertEmptyNursery {
 public:
  explicit AutoEmptyNursery(JSContext* cx);
};

class MOZ_RAII AutoCheckCanAccessAtomsDuringGC {
#ifdef DEBUG
  JSRuntime* runtime;

 public:
  explicit AutoCheckCanAccessAtomsDuringGC(JSRuntime* rt) : runtime(rt) {
    // Ensure we're only used from within the GC.
    MOZ_ASSERT(JS::RuntimeHeapIsMajorCollecting());

    // Ensure there is no off-thread parsing running.
    MOZ_ASSERT(!rt->hasHelperThreadZones());

    // Set up a check to assert if we try to start an off-thread parse.
    runtime->setOffThreadParsingBlocked(true);
  }
  ~AutoCheckCanAccessAtomsDuringGC() {
    runtime->setOffThreadParsingBlocked(false);
  }
#else
 public:
  explicit AutoCheckCanAccessAtomsDuringGC(JSRuntime* rt) {}
#endif
};

// Abstract base class for exclusive heap access for tracing or GC.
class MOZ_RAII AutoHeapSession {
 public:
  ~AutoHeapSession();

 protected:
  AutoHeapSession(GCRuntime* gc, JS::HeapState state);

 private:
  AutoHeapSession(const AutoHeapSession&) = delete;
  void operator=(const AutoHeapSession&) = delete;

  GCRuntime* gc;
  JS::HeapState prevState;
  AutoGeckoProfilerEntry profilingStackFrame;
};

class MOZ_RAII AutoGCSession : public AutoHeapSession {
 public:
  explicit AutoGCSession(GCRuntime* gc, JS::HeapState state)
      : AutoHeapSession(gc, state) {}

  AutoCheckCanAccessAtomsDuringGC& checkAtomsAccess() {
    return maybeCheckAtomsAccess.ref();
  }

  // During a GC we can check that it's not possible for anything else to be
  // using the atoms zone.
  mozilla::Maybe<AutoCheckCanAccessAtomsDuringGC> maybeCheckAtomsAccess;
};

class MOZ_RAII AutoTraceSession : public AutoLockAllAtoms,
                                  public AutoHeapSession {
 public:
  explicit AutoTraceSession(JSRuntime* rt)
      : AutoLockAllAtoms(rt),
        AutoHeapSession(&rt->gc, JS::HeapState::Tracing) {}
};

struct MOZ_RAII AutoFinishGC {
  explicit AutoFinishGC(JSContext* cx, JS::GCReason reason) {
    FinishGC(cx, reason);
  }
};

// This class should be used by any code that needs exclusive access to the heap
// in order to trace through it.
class MOZ_RAII AutoPrepareForTracing : private AutoFinishGC,
                                       public AutoTraceSession {
 public:
  explicit AutoPrepareForTracing(JSContext* cx)
      : AutoFinishGC(cx, JS::GCReason::PREPARE_FOR_TRACING),
        AutoTraceSession(cx->runtime()) {}
};

// This class should be used by any code that needs exclusive access to the heap
// in order to trace through it.
//
// This version also empties the nursery after finishing any ongoing GC.
class MOZ_RAII AutoEmptyNurseryAndPrepareForTracing : private AutoFinishGC,
                                                      public AutoEmptyNursery,
                                                      public AutoTraceSession {
 public:
  explicit AutoEmptyNurseryAndPrepareForTracing(JSContext* cx)
      : AutoFinishGC(cx, JS::GCReason::PREPARE_FOR_TRACING),
        AutoEmptyNursery(cx),
        AutoTraceSession(cx->runtime()) {}
};

AbortReason IsIncrementalGCUnsafe(JSRuntime* rt);

#ifdef JS_GC_ZEAL

class MOZ_RAII AutoStopVerifyingBarriers {
  GCRuntime* gc;
  bool restartPreVerifier;

 public:
  AutoStopVerifyingBarriers(JSRuntime* rt, bool isShutdown) : gc(&rt->gc) {
    if (gc->isVerifyPreBarriersEnabled()) {
      gc->endVerifyPreBarriers();
      restartPreVerifier = !isShutdown;
    } else {
      restartPreVerifier = false;
    }
  }

  ~AutoStopVerifyingBarriers() {
    // Nasty special case: verification runs a minor GC, which *may* nest
    // inside of an outer minor GC. This is not allowed by the
    // gc::Statistics phase tree. So we pause the "real" GC, if in fact one
    // is in progress.
    gcstats::PhaseKind outer = gc->stats().currentPhaseKind();
    if (outer != gcstats::PhaseKind::NONE) {
      gc->stats().endPhase(outer);
    }
    MOZ_ASSERT(gc->stats().currentPhaseKind() == gcstats::PhaseKind::NONE);

    if (restartPreVerifier) {
      gc->startVerifyPreBarriers();
    }

    if (outer != gcstats::PhaseKind::NONE) {
      gc->stats().beginPhase(outer);
    }
  }
};
#else
struct MOZ_RAII AutoStopVerifyingBarriers {
  AutoStopVerifyingBarriers(JSRuntime*, bool) {}
};
#endif /* JS_GC_ZEAL */

#ifdef JSGC_HASH_TABLE_CHECKS
void CheckHashTablesAfterMovingGC(JSRuntime* rt);
void CheckHeapAfterGC(JSRuntime* rt);
#endif

struct MovingTracer final : public JS::CallbackTracer {
  explicit MovingTracer(JSRuntime* rt)
      : CallbackTracer(rt, TraceWeakMapKeysValues) {}

  bool onObjectEdge(JSObject** objp) override;
  bool onShapeEdge(Shape** shapep) override;
  bool onStringEdge(JSString** stringp) override;
  bool onScriptEdge(js::BaseScript** scriptp) override;
  bool onBaseShapeEdge(BaseShape** basep) override;
  bool onScopeEdge(Scope** scopep) override;
  bool onRegExpSharedEdge(RegExpShared** sharedp) override;
  bool onBigIntEdge(BigInt** bip) override;
  bool onChild(const JS::GCCellPtr& thing) override {
    MOZ_ASSERT(!thing.asCell()->isForwarded());
    return true;
  }

#ifdef DEBUG
  TracerKind getTracerKind() const override { return TracerKind::Moving; }
#endif

 private:
  template <typename T>
  bool updateEdge(T** thingp);
};

struct SweepingTracer final : public JS::CallbackTracer {
  explicit SweepingTracer(JSRuntime* rt)
      : CallbackTracer(rt, TraceWeakMapKeysValues) {}

  bool onObjectEdge(JSObject** objp) override;
  bool onShapeEdge(Shape** shapep) override;
  bool onStringEdge(JSString** stringp) override;
  bool onScriptEdge(js::BaseScript** scriptp) override;
  bool onBaseShapeEdge(BaseShape** basep) override;
  bool onJitCodeEdge(jit::JitCode** jitp) override;
  bool onScopeEdge(Scope** scopep) override;
  bool onRegExpSharedEdge(RegExpShared** sharedp) override;
  bool onBigIntEdge(BigInt** bip) override;
  bool onObjectGroupEdge(js::ObjectGroup** groupp) override;
  bool onChild(const JS::GCCellPtr& thing) override {
    MOZ_CRASH("unexpected edge.");
    return true;
  }

#ifdef DEBUG
  TracerKind getTracerKind() const override { return TracerKind::Sweeping; }
#endif

 private:
  template <typename T>
  bool sweepEdge(T** thingp);
};

// Structure for counting how many times objects in a particular group have
// been tenured during a minor collection.
struct TenureCount {
  ObjectGroup* group;
  unsigned count;

  // ObjectGroups are never nursery-allocated, and TenureCounts are only used
  // in minor GC (not compacting GC), so prevent the analysis from
  // complaining about TenureCounts being held live across a minor GC.
} JS_HAZ_NON_GC_POINTER;

// Keep rough track of how many times we tenure objects in particular groups
// during minor collections, using a fixed size hash for efficiency at the cost
// of potential collisions.
struct TenureCountCache {
  static const size_t EntryShift = 4;
  static const size_t EntryCount = 1 << EntryShift;

  TenureCount entries[EntryCount] = {};  // zeroes

  TenureCountCache() = default;

  HashNumber hash(ObjectGroup* group) {
#if JS_BITS_PER_WORD == 32
    static const size_t ZeroBits = 3;
#else
    static const size_t ZeroBits = 4;
#endif

    uintptr_t word = uintptr_t(group);
    MOZ_ASSERT((word & ((1 << ZeroBits) - 1)) == 0);
    word >>= ZeroBits;
    return HashNumber((word >> EntryShift) ^ word);
  }

  TenureCount& findEntry(ObjectGroup* group) {
    return entries[hash(group) % EntryCount];
  }
};

extern void DelayCrossCompartmentGrayMarking(JSObject* src);

inline bool IsOOMReason(JS::GCReason reason) {
  return reason == JS::GCReason::LAST_DITCH ||
         reason == JS::GCReason::MEM_PRESSURE;
}

TenuredCell* AllocateCellInGC(JS::Zone* zone, AllocKind thingKind);

} /* namespace gc */
} /* namespace js */

#endif /* gc_GCInternals_h */
