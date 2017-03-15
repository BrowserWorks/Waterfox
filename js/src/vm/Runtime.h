/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef vm_Runtime_h
#define vm_Runtime_h

#include "mozilla/Atomics.h"
#include "mozilla/Attributes.h"
#include "mozilla/LinkedList.h"
#include "mozilla/MemoryReporting.h"
#include "mozilla/PodOperations.h"
#include "mozilla/Scoped.h"
#include "mozilla/ThreadLocal.h"
#include "mozilla/Vector.h"

#include <setjmp.h>

#include "jsatom.h"
#include "jsclist.h"
#include "jsscript.h"

#ifdef XP_DARWIN
# include "wasm/WasmSignalHandlers.h"
#endif
#include "builtin/AtomicsObject.h"
#include "builtin/Intl.h"
#include "builtin/Promise.h"
#include "ds/FixedSizeHash.h"
#include "frontend/NameCollections.h"
#include "gc/GCRuntime.h"
#include "gc/Tracer.h"
#include "irregexp/RegExpStack.h"
#include "js/Debug.h"
#include "js/GCVector.h"
#include "js/HashTable.h"
#ifdef DEBUG
# include "js/Proxy.h" // For AutoEnterPolicy
#endif
#include "js/UniquePtr.h"
#include "js/Vector.h"
#include "threading/Thread.h"
#include "vm/CodeCoverage.h"
#include "vm/CommonPropertyNames.h"
#include "vm/DateTime.h"
#include "vm/MallocProvider.h"
#include "vm/Scope.h"
#include "vm/SharedImmutableStringsCache.h"
#include "vm/SPSProfiler.h"
#include "vm/Stack.h"
#include "vm/Stopwatch.h"
#include "vm/Symbol.h"

#ifdef _MSC_VER
#pragma warning(push)
#pragma warning(disable:4100) /* Silence unreferenced formal parameter warnings */
#endif

namespace js {

class PerThreadData;
class ExclusiveContext;
class AutoKeepAtoms;
class EnterDebuggeeNoExecute;
#ifdef JS_TRACE_LOGGING
class TraceLoggerThread;
#endif

typedef Vector<UniquePtr<PromiseTask>, 0, SystemAllocPolicy> PromiseTaskPtrVector;

/* Thread Local Storage slot for storing the runtime for a thread. */
extern MOZ_THREAD_LOCAL(PerThreadData*) TlsPerThreadData;

} // namespace js

struct DtoaState;

#ifdef JS_SIMULATOR_ARM64
namespace vixl {
class Simulator;
}
#endif

namespace js {

extern MOZ_COLD void
ReportOutOfMemory(ExclusiveContext* cx);

extern MOZ_COLD void
ReportAllocationOverflow(ExclusiveContext* maybecx);

extern MOZ_COLD void
ReportOverRecursed(ExclusiveContext* cx);

class Activation;
class ActivationIterator;
class WasmActivation;

namespace jit {
class JitRuntime;
class JitActivation;
struct PcScriptCache;
struct AutoFlushICache;
class CompileRuntime;

#ifdef JS_SIMULATOR_ARM64
typedef vixl::Simulator Simulator;
#elif defined(JS_SIMULATOR)
class Simulator;
#endif
} // namespace jit

/*
 * A FreeOp can do one thing: free memory. For convenience, it has delete_
 * convenience methods that also call destructors.
 *
 * FreeOp is passed to finalizers and other sweep-phase hooks so that we do not
 * need to pass a JSContext to those hooks.
 */
class FreeOp : public JSFreeOp
{
    Vector<void*, 0, SystemAllocPolicy> freeLaterList;
    jit::JitPoisonRangeVector jitPoisonRanges;

  public:
    static FreeOp* get(JSFreeOp* fop) {
        return static_cast<FreeOp*>(fop);
    }

    explicit FreeOp(JSRuntime* maybeRuntime);
    ~FreeOp();

    bool onMainThread() const {
        return runtime_ != nullptr;
    }

    bool maybeOffMainThread() const {
        // Sometimes background finalization happens on the main thread so
        // runtime_ being null doesn't always mean we are off the main thread.
        return !runtime_;
    }

    bool isDefaultFreeOp() const;

    inline void free_(void* p);
    inline void freeLater(void* p);

    inline bool appendJitPoisonRange(const jit::JitPoisonRange& range);

    template <class T>
    inline void delete_(T* p) {
        if (p) {
            p->~T();
            free_(p);
        }
    }
};

} /* namespace js */

namespace JS {
struct RuntimeSizes;
} // namespace JS

/* Various built-in or commonly-used names pinned on first context. */
struct JSAtomState
{
#define PROPERTYNAME_FIELD(idpart, id, text) js::ImmutablePropertyNamePtr id;
    FOR_EACH_COMMON_PROPERTYNAME(PROPERTYNAME_FIELD)
#undef PROPERTYNAME_FIELD
#define PROPERTYNAME_FIELD(name, code, init, clasp) js::ImmutablePropertyNamePtr name;
    JS_FOR_EACH_PROTOTYPE(PROPERTYNAME_FIELD)
#undef PROPERTYNAME_FIELD
#define PROPERTYNAME_FIELD(name) js::ImmutablePropertyNamePtr name;
    JS_FOR_EACH_WELL_KNOWN_SYMBOL(PROPERTYNAME_FIELD)
#undef PROPERTYNAME_FIELD
#define PROPERTYNAME_FIELD(name) js::ImmutablePropertyNamePtr Symbol_##name;
    JS_FOR_EACH_WELL_KNOWN_SYMBOL(PROPERTYNAME_FIELD)
#undef PROPERTYNAME_FIELD

    js::ImmutablePropertyNamePtr* wellKnownSymbolNames() {
#define FIRST_PROPERTYNAME_FIELD(name) return &name;
    JS_FOR_EACH_WELL_KNOWN_SYMBOL(FIRST_PROPERTYNAME_FIELD)
#undef FIRST_PROPERTYNAME_FIELD
    }

    js::ImmutablePropertyNamePtr* wellKnownSymbolDescriptions() {
#define FIRST_PROPERTYNAME_FIELD(name) return &Symbol_ ##name;
    JS_FOR_EACH_WELL_KNOWN_SYMBOL(FIRST_PROPERTYNAME_FIELD)
#undef FIRST_PROPERTYNAME_FIELD
    }
};

namespace js {

/*
 * Storage for well-known symbols. It's a separate struct from the Runtime so
 * that it can be shared across multiple runtimes. As in JSAtomState, each
 * field is a smart pointer that's immutable once initialized.
 * `rt->wellKnownSymbols->iterator` is convertible to Handle<Symbol*>.
 *
 * Well-known symbols are never GC'd. The description() of each well-known
 * symbol is a permanent atom.
 */
struct WellKnownSymbols
{
#define DECLARE_SYMBOL(name) js::ImmutableSymbolPtr name;
    JS_FOR_EACH_WELL_KNOWN_SYMBOL(DECLARE_SYMBOL)
#undef DECLARE_SYMBOL

    const ImmutableSymbolPtr& get(size_t u) const {
        MOZ_ASSERT(u < JS::WellKnownSymbolLimit);
        const ImmutableSymbolPtr* symbols = reinterpret_cast<const ImmutableSymbolPtr*>(this);
        return symbols[u];
    }

    const ImmutableSymbolPtr& get(JS::SymbolCode code) const {
        return get(size_t(code));
    }

    WellKnownSymbols() {}
    WellKnownSymbols(const WellKnownSymbols&) = delete;
    WellKnownSymbols& operator=(const WellKnownSymbols&) = delete;
};

#define NAME_OFFSET(name)       offsetof(JSAtomState, name)

inline HandlePropertyName
AtomStateOffsetToName(const JSAtomState& atomState, size_t offset)
{
    return *reinterpret_cast<js::ImmutablePropertyNamePtr*>((char*)&atomState + offset);
}

// There are several coarse locks in the enum below. These may be either
// per-runtime or per-process. When acquiring more than one of these locks,
// the acquisition must be done in the order below to avoid deadlocks.
enum RuntimeLock {
    ExclusiveAccessLock,
    HelperThreadStateLock,
    GCLock
};

inline bool
CanUseExtraThreads()
{
    extern bool gCanUseExtraThreads;
    return gCanUseExtraThreads;
}

void DisableExtraThreads();

/*
 * Encapsulates portions of the runtime/context that are tied to a
 * single active thread.  Instances of this structure can occur for
 * the main thread as |JSRuntime::mainThread|, for select operations
 * performed off thread, such as parsing.
 */
class PerThreadData
{
    /*
     * Backpointer to the full shared JSRuntime* with which this
     * thread is associated.  This is private because accessing the
     * fields of this runtime can provoke race conditions, so the
     * intention is that access will be mediated through safe
     * functions like |runtimeFromMainThread| and |associatedWith()| below.
     */
    JSRuntime* runtime_;

  public:
#ifdef JS_TRACE_LOGGING
    TraceLoggerMainThread*  traceLogger;
#endif

    /* Pointer to the current AutoFlushICache. */
    js::jit::AutoFlushICache* autoFlushICache_;

  public:
    /* State used by jsdtoa.cpp. */
    DtoaState*          dtoaState;

    /*
     * When this flag is non-zero, any attempt to GC will be skipped. It is used
     * to suppress GC when reporting an OOM (see ReportOutOfMemory) and in
     * debugging facilities that cannot tolerate a GC and would rather OOM
     * immediately, such as utilities exposed to GDB. Setting this flag is
     * extremely dangerous and should only be used when in an OOM situation or
     * in non-exposed debugging facilities.
     */
    int32_t suppressGC;

#ifdef DEBUG
    // Whether this thread is actively Ion compiling.
    bool ionCompiling;

    // Whether this thread is actively Ion compiling in a context where a minor
    // GC could happen simultaneously. If this is true, this thread cannot use
    // any pointers into the nursery.
    bool ionCompilingSafeForMinorGC;

    // Whether this thread is currently performing GC.  This thread could be the
    // main thread or a helper thread while the main thread is running the
    // collector.
    bool performingGC;

    // Whether this thread is currently sweeping GC things.  This thread could
    // be the main thread or a helper thread while the main thread is running
    // the mutator.  This is used to assert that destruction of GCPtr only
    // happens when we are sweeping.
    bool gcSweeping;
#endif

    // Pools used for recycling name maps and vectors when parsing and
    // emitting bytecode. Purged on GC when there are no active script
    // compilations.
    frontend::NameCollectionPool frontendCollectionPool;

    explicit PerThreadData(JSRuntime* runtime);
    ~PerThreadData();

    bool init();

    bool associatedWith(const JSRuntime* rt) { return runtime_ == rt; }
    inline JSRuntime* runtimeFromMainThread();
    inline JSRuntime* runtimeIfOnOwnerThread();

    JSContext* contextFromMainThread();

    inline bool exclusiveThreadsPresent();

    // For threads which may be associated with different runtimes, depending
    // on the work they are doing.
    class MOZ_STACK_CLASS AutoEnterRuntime
    {
        PerThreadData* pt;

      public:
        AutoEnterRuntime(PerThreadData* pt, JSRuntime* rt)
          : pt(pt)
        {
            MOZ_ASSERT(!pt->runtime_);
            pt->runtime_ = rt;
        }

        ~AutoEnterRuntime() {
            pt->runtime_ = nullptr;
        }
    };

    js::jit::AutoFlushICache* autoFlushICache() const;
    void setAutoFlushICache(js::jit::AutoFlushICache* afc);

#ifdef JS_SIMULATOR
    js::jit::Simulator* simulator() const;
#endif
};

using ScriptAndCountsVector = GCVector<ScriptAndCounts, 0, SystemAllocPolicy>;

class AutoLockForExclusiveAccess;
} // namespace js

struct JSRuntime : public JS::shadow::Runtime,
                   public js::MallocProvider<JSRuntime>
{
    /*
     * Per-thread data for the main thread that is associated with
     * this JSRuntime, as opposed to any worker threads used in
     * parallel sections.  See definition of |PerThreadData| struct
     * above for more details.
     *
     * NB: This field is statically asserted to be at offset
     * sizeof(js::shadow::Runtime). See
     * PerThreadDataFriendFields::getMainThread.
     */
    js::PerThreadData mainThread;

    /*
     * If Baseline or Ion code is on the stack, and has called into C++, this
     * will be aligned to an exit frame.
     */
    uint8_t*            jitTop;

     /*
     * Points to the most recent JitActivation pushed on the thread.
     * See JitActivation constructor in vm/Stack.cpp
     */
    js::jit::JitActivation* jitActivation;

    /* See comment for JSRuntime::interrupt_. */
  protected:
    mozilla::Atomic<uintptr_t, mozilla::Relaxed> jitStackLimit_;

    // Like jitStackLimit_, but not reset to trigger interrupts.
    uintptr_t jitStackLimitNoInterrupt_;

  public:
    uintptr_t jitStackLimit() const { return jitStackLimit_; }

    // For read-only JIT use:
    void* addressOfJitStackLimit() { return &jitStackLimit_; }
    static size_t offsetOfJitStackLimit() { return offsetof(JSRuntime, jitStackLimit_); }

    void* addressOfJitStackLimitNoInterrupt() { return &jitStackLimitNoInterrupt_; }

    // Information about the heap allocated backtrack stack used by RegExp JIT code.
    js::irregexp::RegExpStack regexpStack;

#ifdef DEBUG
  private:
    // The number of possible bailing places encounters before forcefully bailing
    // in that place. Zero means inactive.
    uint32_t ionBailAfter_;

  public:
    void* addressOfIonBailAfter() { return &ionBailAfter_; }

    // Set after how many bailing places we should forcefully bail.
    // Zero disables this feature.
    void setIonBailAfter(uint32_t after) {
        ionBailAfter_ = after;
    }
#endif

  private:
    friend class js::Activation;
    friend class js::ActivationIterator;
    friend class js::jit::JitActivation;
    friend class js::WasmActivation;
    friend class js::jit::CompileRuntime;

  protected:
    /*
     * Points to the most recent activation running on the thread.
     * See Activation comment in vm/Stack.h.
     */
    js::Activation* activation_;

    /*
     * Points to the most recent profiling activation running on the
     * thread.
     */
    js::Activation * volatile profilingActivation_;

    /*
     * The profiler sampler generation after the latest sample.
     *
     * The lapCount indicates the number of largest number of 'laps'
     * (wrapping from high to low) that occurred when writing entries
     * into the sample buffer.  All JitcodeGlobalMap entries referenced
     * from a given sample are assigned the generation of the sample buffer
     * at the START of the run.  If multiple laps occur, then some entries
     * (towards the end) will be written out with the "wrong" generation.
     * The lapCount indicates the required fudge factor to use to compare
     * entry generations with the sample buffer generation.
     */
    mozilla::Atomic<uint32_t, mozilla::ReleaseAcquire> profilerSampleBufferGen_;
    mozilla::Atomic<uint32_t, mozilla::ReleaseAcquire> profilerSampleBufferLapCount_;

    /* See WasmActivation comment. */
    js::WasmActivation * volatile wasmActivationStack_;

  public:
    /* If non-null, report JavaScript entry points to this monitor. */
    JS::dbg::AutoEntryMonitor* entryMonitor;

    /*
     * Stack of debuggers that currently disallow debuggee execution.
     *
     * When we check for NX we are inside the debuggee compartment, and thus a
     * stack of Debuggers that have prevented execution need to be tracked to
     * enter the correct Debugger compartment to report the error.
     */
    js::EnterDebuggeeNoExecute* noExecuteDebuggerTop;

    js::Activation* const* addressOfActivation() const {
        return &activation_;
    }
    static unsigned offsetOfActivation() {
        return offsetof(JSRuntime, activation_);
    }

    js::Activation* profilingActivation() const {
        return profilingActivation_;
    }
    void* addressOfProfilingActivation() {
        return (void*) &profilingActivation_;
    }
    static unsigned offsetOfProfilingActivation() {
        return offsetof(JSRuntime, profilingActivation_);
    }

    uint32_t profilerSampleBufferGen() {
        return profilerSampleBufferGen_;
    }
    void resetProfilerSampleBufferGen() {
        profilerSampleBufferGen_ = 0;
    }
    void setProfilerSampleBufferGen(uint32_t gen) {
        // May be called from sampler thread or signal handler; use
        // compareExchange to make sure we have monotonic increase.
        for (;;) {
            uint32_t curGen = profilerSampleBufferGen_;
            if (curGen >= gen)
                break;

            if (profilerSampleBufferGen_.compareExchange(curGen, gen))
                break;
        }
    }

    uint32_t profilerSampleBufferLapCount() {
        MOZ_ASSERT(profilerSampleBufferLapCount_ > 0);
        return profilerSampleBufferLapCount_;
    }
    void resetProfilerSampleBufferLapCount() {
        profilerSampleBufferLapCount_ = 1;
    }
    void updateProfilerSampleBufferLapCount(uint32_t lapCount) {
        MOZ_ASSERT(profilerSampleBufferLapCount_ > 0);

        // May be called from sampler thread or signal handler; use
        // compareExchange to make sure we have monotonic increase.
        for (;;) {
            uint32_t curLapCount = profilerSampleBufferLapCount_;
            if (curLapCount >= lapCount)
                break;

            if (profilerSampleBufferLapCount_.compareExchange(curLapCount, lapCount))
                break;
        }
    }

    js::WasmActivation* wasmActivationStack() const {
        return wasmActivationStack_;
    }
    static js::WasmActivation* innermostWasmActivation() {
        js::PerThreadData* ptd = js::TlsPerThreadData.get();
        return ptd ? ptd->runtimeFromMainThread()->wasmActivationStack_ : nullptr;
    }

    js::Activation* activation() const {
        return activation_;
    }

    /*
     * If non-null, another runtime guaranteed to outlive this one and whose
     * permanent data may be used by this one where possible.
     */
    JSRuntime* parentRuntime;

  private:
#ifdef DEBUG
    /* The number of child runtimes that have this runtime as their parent. */
    mozilla::Atomic<size_t> childRuntimeCount;

    class AutoUpdateChildRuntimeCount
    {
        JSRuntime* parent_;

      public:
        explicit AutoUpdateChildRuntimeCount(JSRuntime* parent)
          : parent_(parent)
        {
            if (parent_)
                parent_->childRuntimeCount++;
        }

        ~AutoUpdateChildRuntimeCount() {
            if (parent_)
                parent_->childRuntimeCount--;
        }
    };

    AutoUpdateChildRuntimeCount updateChildRuntimeCount;
#endif

    mozilla::Atomic<uint32_t, mozilla::Relaxed> interrupt_;

    /* Call this to accumulate telemetry data. */
    JSAccumulateTelemetryDataCallback telemetryCallback;
  public:
    // Accumulates data for Firefox telemetry. |id| is the ID of a JS_TELEMETRY_*
    // histogram. |key| provides an additional key to identify the histogram.
    // |sample| is the data to add to the histogram.
    void addTelemetry(int id, uint32_t sample, const char* key = nullptr);

    void setTelemetryCallback(JSRuntime* rt, JSAccumulateTelemetryDataCallback callback);

    enum InterruptMode {
        RequestInterruptUrgent,
        RequestInterruptCanWait
    };

    // Any thread can call requestInterrupt() to request that the main JS thread
    // stop running and call the interrupt callback (allowing the interrupt
    // callback to halt execution). To stop the main JS thread, requestInterrupt
    // sets two fields: interrupt_ (set to true) and jitStackLimit_ (set to
    // UINTPTR_MAX). The JS engine must continually poll one of these fields
    // and call handleInterrupt if either field has the interrupt value. (The
    // point of setting jitStackLimit_ to UINTPTR_MAX is that JIT code already
    // needs to guard on jitStackLimit_ in every function prologue to avoid
    // stack overflow, so we avoid a second branch on interrupt_ by setting
    // jitStackLimit_ to a value that is guaranteed to fail the guard.)
    //
    // Note that the writes to interrupt_ and jitStackLimit_ use a Relaxed
    // Atomic so, while the writes are guaranteed to eventually be visible to
    // the main thread, it can happen in any order. handleInterrupt calls the
    // interrupt callback if either is set, so it really doesn't matter as long
    // as the JS engine is continually polling at least one field. In corner
    // cases, this relaxed ordering could lead to an interrupt handler being
    // called twice in succession after a single requestInterrupt call, but
    // that's fine.
    void requestInterrupt(InterruptMode mode);
    bool handleInterrupt(JSContext* cx);

    MOZ_ALWAYS_INLINE bool hasPendingInterrupt() const {
        return interrupt_;
    }

    // For read-only JIT use:
    void* addressOfInterruptUint32() {
        static_assert(sizeof(interrupt_) == sizeof(uint32_t), "Assumed by JIT callers");
        return &interrupt_;
    }

    // Set when handling a segfault in the wasm signal handler.
    bool handlingSegFault;

  private:
    // Set when we're handling an interrupt of JIT/wasm code in
    // InterruptRunningJitCode.
    mozilla::Atomic<bool> handlingJitInterrupt_;

  public:
    bool startHandlingJitInterrupt() {
        // Return true if we changed handlingJitInterrupt_ from
        // false to true.
        return handlingJitInterrupt_.compareExchange(false, true);
    }
    void finishHandlingJitInterrupt() {
        MOZ_ASSERT(handlingJitInterrupt_);
        handlingJitInterrupt_ = false;
    }
    bool handlingJitInterrupt() const {
        return handlingJitInterrupt_;
    }

    using InterruptCallbackVector = js::Vector<JSInterruptCallback, 2, js::SystemAllocPolicy>;
    InterruptCallbackVector interruptCallbacks;
    bool interruptCallbackDisabled;

    JSGetIncumbentGlobalCallback getIncumbentGlobalCallback;
    JSEnqueuePromiseJobCallback enqueuePromiseJobCallback;
    void* enqueuePromiseJobCallbackData;

    JSPromiseRejectionTrackerCallback promiseRejectionTrackerCallback;
    void* promiseRejectionTrackerCallbackData;

    JS::StartAsyncTaskCallback startAsyncTaskCallback;
    JS::FinishAsyncTaskCallback finishAsyncTaskCallback;
    js::ExclusiveData<js::PromiseTaskPtrVector> promiseTasksToDestroy;

  private:
    /*
     * Lock taken when using per-runtime or per-zone data that could otherwise
     * be accessed simultaneously by both the main thread and another thread
     * with an ExclusiveContext.
     *
     * Locking this only occurs if there is actually a thread other than the
     * main thread with an ExclusiveContext which could access such data.
     */
    js::Mutex exclusiveAccessLock;
#ifdef DEBUG
    bool mainThreadHasExclusiveAccess;
#endif

    /* Number of non-main threads with an ExclusiveContext. */
    size_t numExclusiveThreads;

    friend class js::AutoLockForExclusiveAccess;

  public:
    void setUsedByExclusiveThread(JS::Zone* zone);
    void clearUsedByExclusiveThread(JS::Zone* zone);

    bool exclusiveThreadsPresent() const {
        return numExclusiveThreads > 0;
    }

    // How many compartments there are across all zones. This number includes
    // ExclusiveContext compartments, so it isn't necessarily equal to the
    // number of compartments visited by CompartmentsIter.
    size_t              numCompartments;

    /* Locale-specific callbacks for string conversion. */
    const JSLocaleCallbacks* localeCallbacks;

    /* Default locale for Internationalization API */
    char* defaultLocale;

    /* Default JSVersion. */
    JSVersion defaultVersion_;

    /* Futex state, used by Atomics.wait() and Atomics.wake() on the Atomics object */
    js::FutexRuntime fx;

  private:
    /* See comment for JS_AbortIfWrongThread in jsapi.h. */
    js::Thread::Id ownerThread_;
    size_t ownerThreadNative_;
    friend bool js::CurrentThreadCanAccessRuntime(const JSRuntime* rt);
  public:

    size_t ownerThreadNative() const {
        return ownerThreadNative_;
    }

    /* Temporary arena pool used while compiling and decompiling. */
    static const size_t TEMP_LIFO_ALLOC_PRIMARY_CHUNK_SIZE = 4 * 1024;
    js::LifoAlloc tempLifoAlloc;

  private:
    js::jit::JitRuntime* jitRuntime_;

    /*
     * Self-hosting state cloned on demand into other compartments. Shared with the parent
     * runtime if there is one.
     */
    js::NativeObject* selfHostingGlobal_;

    static js::GlobalObject*
    createSelfHostingGlobal(JSContext* cx);

    bool getUnclonedSelfHostedValue(JSContext* cx, js::HandlePropertyName name,
                                    js::MutableHandleValue vp);
    JSFunction* getUnclonedSelfHostedFunction(JSContext* cx, js::HandlePropertyName name);

    /* Space for interpreter frames. */
    js::InterpreterStack interpreterStack_;

    js::jit::JitRuntime* createJitRuntime(JSContext* cx);

  public:
    js::jit::JitRuntime* getJitRuntime(JSContext* cx) {
        return jitRuntime_ ? jitRuntime_ : createJitRuntime(cx);
    }
    js::jit::JitRuntime* jitRuntime() const {
        return jitRuntime_;
    }
    bool hasJitRuntime() const {
        return !!jitRuntime_;
    }
    js::InterpreterStack& interpreterStack() {
        return interpreterStack_;
    }

    inline JSContext* unsafeContextFromAnyThread();
    inline JSContext* contextFromMainThread();

    JSObject* getIncumbentGlobal(JSContext* cx);
    bool enqueuePromiseJob(JSContext* cx, js::HandleFunction job, js::HandleObject promise,
                           js::HandleObject incumbentGlobal);
    void addUnhandledRejectedPromise(JSContext* cx, js::HandleObject promise);
    void removeUnhandledRejectedPromise(JSContext* cx, js::HandleObject promise);

  private:
    // Used to generate random keys for hash tables.
    mozilla::Maybe<mozilla::non_crypto::XorShift128PlusRNG> randomKeyGenerator_;
    mozilla::non_crypto::XorShift128PlusRNG& randomKeyGenerator();

  public:
    mozilla::HashCodeScrambler randomHashCodeScrambler();
    mozilla::non_crypto::XorShift128PlusRNG forkRandomKeyGenerator();

    //-------------------------------------------------------------------------
    // Self-hosting support
    //-------------------------------------------------------------------------

    bool hasInitializedSelfHosting() const {
        return selfHostingGlobal_;
    }

    bool initSelfHosting(JSContext* cx);
    void finishSelfHosting();
    void markSelfHostingGlobal(JSTracer* trc);
    bool isSelfHostingGlobal(JSObject* global) {
        return global == selfHostingGlobal_;
    }
    bool isSelfHostingCompartment(JSCompartment* comp) const;
    bool isSelfHostingZone(const JS::Zone* zone) const;
    bool createLazySelfHostedFunctionClone(JSContext* cx, js::HandlePropertyName selfHostedName,
                                           js::HandleAtom name, unsigned nargs,
                                           js::HandleObject proto,
                                           js::NewObjectKind newKind,
                                           js::MutableHandleFunction fun);
    bool cloneSelfHostedFunctionScript(JSContext* cx, js::Handle<js::PropertyName*> name,
                                       js::Handle<JSFunction*> targetFun);
    bool cloneSelfHostedValue(JSContext* cx, js::Handle<js::PropertyName*> name,
                              js::MutableHandleValue vp);
    void assertSelfHostedFunctionHasCanonicalName(JSContext* cx, js::HandlePropertyName name);

    //-------------------------------------------------------------------------
    // Locale information
    //-------------------------------------------------------------------------

    /*
     * Set the default locale for the ECMAScript Internationalization API
     * (Intl.Collator, Intl.NumberFormat, Intl.DateTimeFormat).
     * Note that the Internationalization API encourages clients to
     * specify their own locales.
     * The locale string remains owned by the caller.
     */
    bool setDefaultLocale(const char* locale);

    /* Reset the default locale to OS defaults. */
    void resetDefaultLocale();

    /* Gets current default locale. String remains owned by context. */
    const char* getDefaultLocale();

    /* Shared Intl data for this runtime. */
    js::SharedIntlData sharedIntlData;

    void traceSharedIntlData(JSTracer* trc);

    JSVersion defaultVersion() const { return defaultVersion_; }
    void setDefaultVersion(JSVersion v) { defaultVersion_ = v; }

    /* Base address of the native stack for the current thread. */
    const uintptr_t     nativeStackBase;

    /* The native stack size limit that runtime should not exceed. */
    size_t              nativeStackQuota[js::StackKindCount];

    /* Compartment destroy callback. */
    JSDestroyCompartmentCallback destroyCompartmentCallback;

    /* Compartment memory reporting callback. */
    JSSizeOfIncludingThisCompartmentCallback sizeOfIncludingThisCompartmentCallback;

    /* Zone destroy callback. */
    JSZoneCallback destroyZoneCallback;

    /* Zone sweep callback. */
    JSZoneCallback sweepZoneCallback;

    /* Call this to get the name of a compartment. */
    JSCompartmentNameCallback compartmentNameCallback;

    js::ActivityCallback  activityCallback;
    void*                activityCallbackArg;
    void triggerActivityCallback(bool active);

    /* The request depth for this thread. */
    unsigned            requestDepth;

#ifdef DEBUG
    unsigned            checkRequestDepth;
#endif

    /* Garbage collector state, used by jsgc.c. */
    js::gc::GCRuntime   gc;

    /* Garbage collector state has been successfully initialized. */
    bool                gcInitialized;

    bool hasZealMode(js::gc::ZealMode mode) { return gc.hasZealMode(mode); }

    void lockGC() {
        gc.lockGC();
    }

    void unlockGC() {
        gc.unlockGC();
    }

#ifdef JS_SIMULATOR
    js::jit::Simulator* simulator_;
#endif

  public:
#ifdef JS_SIMULATOR
    js::jit::Simulator* simulator() const;
    uintptr_t* addressOfSimulatorStackLimit();
#endif

    /* Strong references on scripts held for PCCount profiling API. */
    JS::PersistentRooted<js::ScriptAndCountsVector>* scriptAndCountsVector;

    /* Code coverage output. */
    js::coverage::LCovRuntime lcovOutput;

    /* Well-known numbers. */
    const js::Value     NaNValue;
    const js::Value     negativeInfinityValue;
    const js::Value     positiveInfinityValue;

    js::PropertyName*   emptyString;

    mozilla::UniquePtr<js::SourceHook> sourceHook;

    /* SPS profiling metadata */
    js::SPSProfiler     spsProfiler;

    /* If true, new scripts must be created with PC counter information. */
    bool                profilingScripts;

    /* Whether sampling should be enabled or not. */
  private:
    mozilla::Atomic<bool, mozilla::SequentiallyConsistent> suppressProfilerSampling;

  public:
    bool isProfilerSamplingEnabled() const {
        return !suppressProfilerSampling;
    }
    void disableProfilerSampling() {
        suppressProfilerSampling = true;
    }
    void enableProfilerSampling() {
        suppressProfilerSampling = false;
    }

    /* Had an out-of-memory error which did not populate an exception. */
    bool                hadOutOfMemory;

#if defined(DEBUG) || defined(JS_OOM_BREAKPOINT)
    /* We are currently running a simulated OOM test. */
    bool runningOOMTest;
#endif

    /*
     * Allow relazifying functions in compartments that are active. This is
     * only used by the relazifyFunctions() testing function.
     */
    bool                allowRelazificationForTesting;

    /* Linked list of all Debugger objects in the runtime. */
    mozilla::LinkedList<js::Debugger> debuggerList;

    /*
     * Head of circular list of all enabled Debuggers that have
     * onNewGlobalObject handler methods established.
     */
    JSCList             onNewGlobalObjectWatchers;

#if defined(XP_DARWIN)
    js::wasm::MachExceptionHandler wasmMachExceptionHandler;
#endif

  private:
    js::FreeOp*         defaultFreeOp_;

  public:
    js::FreeOp* defaultFreeOp() {
        MOZ_ASSERT(defaultFreeOp_);
        return defaultFreeOp_;
    }

    uint32_t            debuggerMutations;

    const JSSecurityCallbacks* securityCallbacks;
    const js::DOMCallbacks* DOMcallbacks;
    JSDestroyPrincipalsOp destroyPrincipals;
    JSReadPrincipalsOp readPrincipals;

    /* Optional warning reporter. */
    JS::WarningReporter warningReporter;

    JS::BuildIdOp buildIdOp;

    /* AsmJSCache callbacks are runtime-wide. */
    JS::AsmJSCacheOps   asmJSCacheOps;

    /*
     * The propertyRemovals counter is incremented for every JSObject::clear,
     * and for each JSObject::remove method call that frees a slot in the given
     * object. See js_NativeGet and js_NativeSet in jsobj.cpp.
     */
    uint32_t            propertyRemovals;

#if !EXPOSE_INTL_API
    /* Number localization, used by jsnum.cpp. */
    const char*         thousandsSeparator;
    const char*         decimalSeparator;
    const char*         numGrouping;
#endif

  private:
    mozilla::Maybe<js::SharedImmutableStringsCache> sharedImmutableStrings_;

  public:
    // If this particular JSRuntime has a SharedImmutableStringsCache, return a
    // pointer to it, otherwise return nullptr.
    js::SharedImmutableStringsCache* maybeThisRuntimeSharedImmutableStrings() {
        return sharedImmutableStrings_.isSome() ? &*sharedImmutableStrings_ : nullptr;
    }

    // Get a reference to this JSRuntime's or its parent's
    // SharedImmutableStringsCache.
    js::SharedImmutableStringsCache& sharedImmutableStrings() {
        MOZ_ASSERT_IF(parentRuntime, !sharedImmutableStrings_);
        MOZ_ASSERT_IF(!parentRuntime, sharedImmutableStrings_);
        return parentRuntime ? parentRuntime->sharedImmutableStrings() : *sharedImmutableStrings_;
    }

    // Count of AutoKeepAtoms instances on the main thread's stack. When any
    // instances exist, atoms in the runtime will not be collected. Threads
    // with an ExclusiveContext do not increment this value, but the presence
    // of any such threads also inhibits collection of atoms. We don't scan the
    // stacks of exclusive threads, so we need to avoid collecting their
    // objects in another way. The only GC thing pointers they have are to
    // their exclusive compartment (which is not collected) or to the atoms
    // compartment. Therefore, we avoid collecting the atoms compartment when
    // exclusive threads are running.
  private:
    unsigned keepAtoms_;
    friend class js::AutoKeepAtoms;
  public:
    bool keepAtoms() {
        return keepAtoms_ != 0 || exclusiveThreadsPresent();
    }

  private:
    const JSPrincipals* trustedPrincipals_;
  public:
    void setTrustedPrincipals(const JSPrincipals* p) { trustedPrincipals_ = p; }
    const JSPrincipals* trustedPrincipals() const { return trustedPrincipals_; }

  private:
    bool beingDestroyed_;
  public:
    bool isBeingDestroyed() const {
        return beingDestroyed_;
    }

  private:
    // Set of all atoms other than those in permanentAtoms and staticStrings.
    // Reading or writing this set requires the calling thread to have an
    // ExclusiveContext and hold a lock. Use AutoLockForExclusiveAccess.
    js::AtomSet* atoms_;

    // Compartment and associated zone containing all atoms in the runtime, as
    // well as runtime wide IonCode stubs. Modifying the contents of this
    // compartment requires the calling thread to have an ExclusiveContext and
    // hold a lock. Use AutoLockForExclusiveAccess.
    JSCompartment* atomsCompartment_;

    // Set of all live symbols produced by Symbol.for(). All such symbols are
    // allocated in the atomsCompartment. Reading or writing the symbol
    // registry requires the calling thread to have an ExclusiveContext and
    // hold a lock. Use AutoLockForExclusiveAccess.
    js::SymbolRegistry symbolRegistry_;

  public:
    bool initializeAtoms(JSContext* cx);
    void finishAtoms();
    bool atomsAreFinished() const { return !atoms_; }

    void sweepAtoms();

    js::AtomSet& atoms(js::AutoLockForExclusiveAccess& lock) {
        return *atoms_;
    }
    JSCompartment* atomsCompartment(js::AutoLockForExclusiveAccess& lock) {
        return atomsCompartment_;
    }

    bool isAtomsCompartment(JSCompartment* comp) {
        return comp == atomsCompartment_;
    }

    // The atoms compartment is the only one in its zone.
    inline bool isAtomsZone(const JS::Zone* zone) const;

    bool activeGCInAtomsZone();

    js::SymbolRegistry& symbolRegistry(js::AutoLockForExclusiveAccess& lock) {
        return symbolRegistry_;
    }

    // Permanent atoms are fixed during initialization of the runtime and are
    // not modified or collected until the runtime is destroyed. These may be
    // shared with another, longer living runtime through |parentRuntime| and
    // can be freely accessed with no locking necessary.

    // Permanent atoms pre-allocated for general use.
    js::StaticStrings* staticStrings;

    // Cached pointers to various permanent property names.
    JSAtomState* commonNames;

    // All permanent atoms in the runtime, other than those in staticStrings.
    // Unlike |atoms_|, access to this does not require
    // AutoLockForExclusiveAccess because it is frozen and thus read-only.
    js::FrozenAtomSet* permanentAtoms;

    bool transformToPermanentAtoms(JSContext* cx);

    // Cached well-known symbols (ES6 rev 24 6.1.5.1). Like permanent atoms,
    // these are shared with the parentRuntime, if any.
    js::WellKnownSymbols* wellKnownSymbols;

    const JSWrapObjectCallbacks*           wrapObjectCallbacks;
    js::PreserveWrapperCallback            preserveWrapperCallback;

    // Table of bytecode and other data that may be shared across scripts
    // within the runtime. This may be modified by threads with an
    // ExclusiveContext and requires a lock.
  private:
    js::ScriptDataTable scriptDataTable_;
  public:
    js::ScriptDataTable& scriptDataTable(js::AutoLockForExclusiveAccess& lock) {
        return scriptDataTable_;
    }

    bool jitSupportsFloatingPoint;
    bool jitSupportsUnalignedAccesses;
    bool jitSupportsSimd;

    // Cache for jit::GetPcScript().
    js::jit::PcScriptCache* ionPcScriptCache;

    js::ScriptEnvironmentPreparer* scriptEnvironmentPreparer;

    js::CTypesActivityCallback  ctypesActivityCallback;

  private:
    static mozilla::Atomic<size_t> liveRuntimesCount;

  public:
    static bool hasLiveRuntimes() {
        return liveRuntimesCount > 0;
    }

  protected:
    explicit JSRuntime(JSRuntime* parentRuntime);

    // destroyRuntime is used instead of a destructor, to ensure the downcast
    // to JSContext remains valid. The final GC triggered here depends on this.
    void destroyRuntime();

    bool init(uint32_t maxbytes, uint32_t maxNurseryBytes);

    JSRuntime* thisFromCtor() { return this; }

  public:
    /*
     * Call this after allocating memory held by GC things, to update memory
     * pressure counters or report the OOM error if necessary. If oomError and
     * cx is not null the function also reports OOM error.
     *
     * The function must be called outside the GC lock and in case of OOM error
     * the caller must ensure that no deadlock possible during OOM reporting.
     */
    void updateMallocCounter(size_t nbytes);
    void updateMallocCounter(JS::Zone* zone, size_t nbytes);

    void reportAllocationOverflow() { js::ReportAllocationOverflow(nullptr); }

    /*
     * This should be called after system malloc/calloc/realloc returns nullptr
     * to try to recove some memory or to report an error.  For realloc, the
     * original pointer must be passed as reallocPtr.
     *
     * The function must be called outside the GC lock.
     */
    JS_FRIEND_API(void*) onOutOfMemory(js::AllocFunction allocator, size_t nbytes,
                                       void* reallocPtr = nullptr, JSContext* maybecx = nullptr);

    /*  onOutOfMemory but can call the largeAllocationFailureCallback. */
    JS_FRIEND_API(void*) onOutOfMemoryCanGC(js::AllocFunction allocator, size_t nbytes,
                                            void* reallocPtr = nullptr);

    void addSizeOfIncludingThis(mozilla::MallocSizeOf mallocSizeOf, JS::RuntimeSizes* runtime);

  private:
    const js::Class* windowProxyClass_;

    // Settings for how helper threads can be used.
    bool offthreadIonCompilationEnabled_;
    bool parallelParsingEnabled_;

    bool autoWritableJitCodeActive_;

  public:

    // Note: these values may be toggled dynamically (in response to about:config
    // prefs changing).
    void setOffthreadIonCompilationEnabled(bool value) {
        offthreadIonCompilationEnabled_ = value;
    }
    bool canUseOffthreadIonCompilation() const {
        return offthreadIonCompilationEnabled_;
    }
    void setParallelParsingEnabled(bool value) {
        parallelParsingEnabled_ = value;
    }
    bool canUseParallelParsing() const {
        return parallelParsingEnabled_;
    }

    void toggleAutoWritableJitCodeActive(bool b) {
        MOZ_ASSERT(autoWritableJitCodeActive_ != b, "AutoWritableJitCode should not be nested.");
        MOZ_ASSERT(CurrentThreadCanAccessRuntime(this));
        autoWritableJitCodeActive_ = b;
    }

    const js::Class* maybeWindowProxyClass() const {
        return windowProxyClass_;
    }
    void setWindowProxyClass(const js::Class* clasp) {
        windowProxyClass_ = clasp;
    }

#ifdef DEBUG
  public:
    js::AutoEnterPolicy* enteredPolicy;
#endif

    /* See comment for JS::SetLargeAllocationFailureCallback in jsapi.h. */
    JS::LargeAllocationFailureCallback largeAllocationFailureCallback;
    void* largeAllocationFailureCallbackData;

    /* See comment for JS::SetOutOfMemoryCallback in jsapi.h. */
    JS::OutOfMemoryCallback oomCallback;
    void* oomCallbackData;

    /*
     * These variations of malloc/calloc/realloc will call the
     * large-allocation-failure callback on OOM and retry the allocation.
     */

    static const unsigned LARGE_ALLOCATION = 25 * 1024 * 1024;

    template <typename T>
    T* pod_callocCanGC(size_t numElems) {
        T* p = pod_calloc<T>(numElems);
        if (MOZ_LIKELY(!!p))
            return p;
        size_t bytes;
        if (MOZ_UNLIKELY(!js::CalculateAllocSize<T>(numElems, &bytes))) {
            reportAllocationOverflow();
            return nullptr;
        }
        return static_cast<T*>(onOutOfMemoryCanGC(js::AllocFunction::Calloc, bytes));
    }

    template <typename T>
    T* pod_reallocCanGC(T* p, size_t oldSize, size_t newSize) {
        T* p2 = pod_realloc<T>(p, oldSize, newSize);
        if (MOZ_LIKELY(!!p2))
            return p2;
        size_t bytes;
        if (MOZ_UNLIKELY(!js::CalculateAllocSize<T>(newSize, &bytes))) {
            reportAllocationOverflow();
            return nullptr;
        }
        return static_cast<T*>(onOutOfMemoryCanGC(js::AllocFunction::Realloc, bytes, p));
    }

    /*
     * Debugger.Memory functions like takeCensus use this embedding-provided
     * function to assess the size of malloc'd blocks of memory.
     */
    mozilla::MallocSizeOf debuggerMallocSizeOf;

    /* Last time at which an animation was played for this runtime. */
    int64_t lastAnimationTime;

  public:
    js::PerformanceMonitoring performanceMonitoring;

  private:
    /* List of Ion compilation waiting to get linked. */
    typedef mozilla::LinkedList<js::jit::IonBuilder> IonBuilderList;

    IonBuilderList ionLazyLinkList_;
    size_t ionLazyLinkListSize_;

  public:
    IonBuilderList& ionLazyLinkList();

    size_t ionLazyLinkListSize() {
        return ionLazyLinkListSize_;
    }

    void ionLazyLinkListRemove(js::jit::IonBuilder* builder);
    void ionLazyLinkListAdd(js::jit::IonBuilder* builder);

  private:
    /* The stack format for the current runtime.  Only valid on non-child
     * runtimes. */
    mozilla::Atomic<js::StackFormat, mozilla::ReleaseAcquire> stackFormat_;

  public:
    js::StackFormat stackFormat() const {
        const JSRuntime* rt = this;
        while (rt->parentRuntime) {
            MOZ_ASSERT(rt->stackFormat_ == js::StackFormat::Default);
            rt = rt->parentRuntime;
        }
        MOZ_ASSERT(rt->stackFormat_ != js::StackFormat::Default);
        return rt->stackFormat_;
    }
    void setStackFormat(js::StackFormat format) {
        MOZ_ASSERT(!parentRuntime);
        MOZ_ASSERT(format != js::StackFormat::Default);
        stackFormat_ = format;
    }

    // For inherited heap state accessors.
    friend class js::gc::AutoTraceSession;
    friend class JS::AutoEnterCycleCollection;
};

namespace js {

static inline JSContext*
GetJSContextFromMainThread()
{
    return js::TlsPerThreadData.get()->contextFromMainThread();
}

/*
 * Flags accompany script version data so that a) dynamically created scripts
 * can inherit their caller's compile-time properties and b) scripts can be
 * appropriately compared in the eval cache across global option changes. An
 * example of the latter is enabling the top-level-anonymous-function-is-error
 * option: subsequent evals of the same, previously-valid script text may have
 * become invalid.
 */
namespace VersionFlags {
static const unsigned MASK      = 0x0FFF; /* see JSVersion in jspubtd.h */
} /* namespace VersionFlags */

static inline JSVersion
VersionNumber(JSVersion version)
{
    return JSVersion(uint32_t(version) & VersionFlags::MASK);
}

static inline JSVersion
VersionExtractFlags(JSVersion version)
{
    return JSVersion(uint32_t(version) & ~VersionFlags::MASK);
}

static inline void
VersionCopyFlags(JSVersion* version, JSVersion from)
{
    *version = JSVersion(VersionNumber(*version) | VersionExtractFlags(from));
}

static inline bool
VersionHasFlags(JSVersion version)
{
    return !!VersionExtractFlags(version);
}

static inline bool
VersionIsKnown(JSVersion version)
{
    return VersionNumber(version) != JSVERSION_UNKNOWN;
}

inline void
FreeOp::free_(void* p)
{
    js_free(p);
}

inline void
FreeOp::freeLater(void* p)
{
    // FreeOps other than the defaultFreeOp() are constructed on the stack,
    // and won't hold onto the pointers to free indefinitely.
    MOZ_ASSERT(!isDefaultFreeOp());

    AutoEnterOOMUnsafeRegion oomUnsafe;
    if (!freeLaterList.append(p))
        oomUnsafe.crash("FreeOp::freeLater");
}

inline bool
FreeOp::appendJitPoisonRange(const jit::JitPoisonRange& range)
{
    // FreeOps other than the defaultFreeOp() are constructed on the stack,
    // and won't hold onto the pointers to free indefinitely.
    MOZ_ASSERT(!isDefaultFreeOp());

    return jitPoisonRanges.append(range);
}

/*
 * RAII class that takes the GC lock while it is live.
 *
 * Note that the lock may be temporarily released by use of AutoUnlockGC when
 * passed a non-const reference to this class.
 */
class MOZ_RAII AutoLockGC
{
  public:
    explicit AutoLockGC(JSRuntime* rt
                        MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
      : runtime_(rt)
    {
        MOZ_GUARD_OBJECT_NOTIFIER_INIT;
        lock();
    }

    ~AutoLockGC() {
        unlock();
    }

    void lock() {
        MOZ_ASSERT(lockGuard_.isNothing());
        lockGuard_.emplace(runtime_->gc.lock);
    }

    void unlock() {
        MOZ_ASSERT(lockGuard_.isSome());
        lockGuard_.reset();
    }

    js::LockGuard<js::Mutex>& guard() {
        return lockGuard_.ref();
    }

  private:
    JSRuntime* runtime_;
    mozilla::Maybe<js::LockGuard<js::Mutex>> lockGuard_;
    MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER

    AutoLockGC(const AutoLockGC&) = delete;
    AutoLockGC& operator=(const AutoLockGC&) = delete;
};

class MOZ_RAII AutoUnlockGC
{
  public:
    explicit AutoUnlockGC(AutoLockGC& lock
                          MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
      : lock(lock)
    {
        MOZ_GUARD_OBJECT_NOTIFIER_INIT;
        lock.unlock();
    }

    ~AutoUnlockGC() {
        lock.lock();
    }

  private:
    AutoLockGC& lock;
    MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER

    AutoUnlockGC(const AutoUnlockGC&) = delete;
    AutoUnlockGC& operator=(const AutoUnlockGC&) = delete;
};

class MOZ_RAII AutoKeepAtoms
{
    PerThreadData* pt;
    MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER

  public:
    explicit AutoKeepAtoms(PerThreadData* pt
                           MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
      : pt(pt)
    {
        MOZ_GUARD_OBJECT_NOTIFIER_INIT;
        if (JSRuntime* rt = pt->runtimeIfOnOwnerThread()) {
            rt->keepAtoms_++;
        } else {
            // This should be a thread with an exclusive context, which will
            // always inhibit collection of atoms.
            MOZ_ASSERT(pt->exclusiveThreadsPresent());
        }
    }
    ~AutoKeepAtoms() {
        if (JSRuntime* rt = pt->runtimeIfOnOwnerThread()) {
            MOZ_ASSERT(rt->keepAtoms_);
            rt->keepAtoms_--;
            if (rt->gc.fullGCForAtomsRequested() && !rt->keepAtoms())
                rt->gc.triggerFullGCForAtoms();
        }
    }
};

inline JSRuntime*
PerThreadData::runtimeFromMainThread()
{
    MOZ_ASSERT(CurrentThreadCanAccessRuntime(runtime_));
    return runtime_;
}

inline JSRuntime*
PerThreadData::runtimeIfOnOwnerThread()
{
    return (runtime_ && CurrentThreadCanAccessRuntime(runtime_)) ? runtime_ : nullptr;
}

inline bool
PerThreadData::exclusiveThreadsPresent()
{
    return runtime_->exclusiveThreadsPresent();
}

/************************************************************************/

static MOZ_ALWAYS_INLINE void
MakeRangeGCSafe(Value* vec, size_t len)
{
    mozilla::PodZero(vec, len);
}

static MOZ_ALWAYS_INLINE void
MakeRangeGCSafe(Value* beg, Value* end)
{
    mozilla::PodZero(beg, end - beg);
}

static MOZ_ALWAYS_INLINE void
MakeRangeGCSafe(jsid* beg, jsid* end)
{
    for (jsid* id = beg; id != end; ++id)
        *id = INT_TO_JSID(0);
}

static MOZ_ALWAYS_INLINE void
MakeRangeGCSafe(jsid* vec, size_t len)
{
    MakeRangeGCSafe(vec, vec + len);
}

static MOZ_ALWAYS_INLINE void
MakeRangeGCSafe(Shape** beg, Shape** end)
{
    mozilla::PodZero(beg, end - beg);
}

static MOZ_ALWAYS_INLINE void
MakeRangeGCSafe(Shape** vec, size_t len)
{
    mozilla::PodZero(vec, len);
}

static MOZ_ALWAYS_INLINE void
SetValueRangeToUndefined(Value* beg, Value* end)
{
    for (Value* v = beg; v != end; ++v)
        v->setUndefined();
}

static MOZ_ALWAYS_INLINE void
SetValueRangeToUndefined(Value* vec, size_t len)
{
    SetValueRangeToUndefined(vec, vec + len);
}

static MOZ_ALWAYS_INLINE void
SetValueRangeToNull(Value* beg, Value* end)
{
    for (Value* v = beg; v != end; ++v)
        v->setNull();
}

static MOZ_ALWAYS_INLINE void
SetValueRangeToNull(Value* vec, size_t len)
{
    SetValueRangeToNull(vec, vec + len);
}

/*
 * Allocation policy that uses JSRuntime::pod_malloc and friends, so that
 * memory pressure is properly accounted for. This is suitable for
 * long-lived objects owned by the JSRuntime.
 *
 * Since it doesn't hold a JSContext (those may not live long enough), it
 * can't report out-of-memory conditions itself; the caller must check for
 * OOM and take the appropriate action.
 *
 * FIXME bug 647103 - replace these *AllocPolicy names.
 */
class RuntimeAllocPolicy
{
    JSRuntime* const runtime;

  public:
    MOZ_IMPLICIT RuntimeAllocPolicy(JSRuntime* rt) : runtime(rt) {}

    template <typename T>
    T* maybe_pod_malloc(size_t numElems) {
        return runtime->maybe_pod_malloc<T>(numElems);
    }

    template <typename T>
    T* maybe_pod_calloc(size_t numElems) {
        return runtime->maybe_pod_calloc<T>(numElems);
    }

    template <typename T>
    T* maybe_pod_realloc(T* p, size_t oldSize, size_t newSize) {
        return runtime->maybe_pod_realloc<T>(p, oldSize, newSize);
    }

    template <typename T>
    T* pod_malloc(size_t numElems) {
        return runtime->pod_malloc<T>(numElems);
    }

    template <typename T>
    T* pod_calloc(size_t numElems) {
        return runtime->pod_calloc<T>(numElems);
    }

    template <typename T>
    T* pod_realloc(T* p, size_t oldSize, size_t newSize) {
        return runtime->pod_realloc<T>(p, oldSize, newSize);
    }

    void free_(void* p) { js_free(p); }
    void reportAllocOverflow() const {}

    bool checkSimulatedOOM() const {
        return !js::oom::ShouldFailWithOOM();
    }
};

extern const JSSecurityCallbacks NullSecurityCallbacks;

// Debugging RAII class which marks the current thread as performing an Ion
// compilation, for use by CurrentThreadCan{Read,Write}CompilationData
class MOZ_RAII AutoEnterIonCompilation
{
  public:
    explicit AutoEnterIonCompilation(bool safeForMinorGC
                                     MOZ_GUARD_OBJECT_NOTIFIER_PARAM) {
        MOZ_GUARD_OBJECT_NOTIFIER_INIT;

#ifdef DEBUG
        PerThreadData* pt = js::TlsPerThreadData.get();
        MOZ_ASSERT(!pt->ionCompiling);
        MOZ_ASSERT(!pt->ionCompilingSafeForMinorGC);
        pt->ionCompiling = true;
        pt->ionCompilingSafeForMinorGC = safeForMinorGC;
#endif
    }

    ~AutoEnterIonCompilation() {
#ifdef DEBUG
        PerThreadData* pt = js::TlsPerThreadData.get();
        MOZ_ASSERT(pt->ionCompiling);
        pt->ionCompiling = false;
        pt->ionCompilingSafeForMinorGC = false;
#endif
    }

    MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER
};

namespace gc {

// In debug builds, set/unset the performing GC flag for the current thread.
struct MOZ_RAII AutoSetThreadIsPerformingGC
{
#ifdef DEBUG
    AutoSetThreadIsPerformingGC()
      : threadData_(js::TlsPerThreadData.get())
    {
        MOZ_ASSERT(!threadData_->performingGC);
        threadData_->performingGC = true;
    }

    ~AutoSetThreadIsPerformingGC() {
        MOZ_ASSERT(threadData_->performingGC);
        threadData_->performingGC = false;
    }

  private:
    PerThreadData* threadData_;
#else
    AutoSetThreadIsPerformingGC() {}
#endif
};

// In debug builds, set/unset the GC sweeping flag for the current thread.
struct MOZ_RAII AutoSetThreadIsSweeping
{
#ifdef DEBUG
    AutoSetThreadIsSweeping()
      : threadData_(js::TlsPerThreadData.get())
    {
        MOZ_ASSERT(!threadData_->gcSweeping);
        threadData_->gcSweeping = true;
    }

    ~AutoSetThreadIsSweeping() {
        MOZ_ASSERT(threadData_->gcSweeping);
        threadData_->gcSweeping = false;
    }

  private:
    PerThreadData* threadData_;
#else
    AutoSetThreadIsSweeping() {}
#endif
};

} // namespace gc

/*
 * Provides a delete policy that can be used for objects which have their
 * lifetime managed by the GC and can only safely be destroyed while the nursery
 * is empty.
 *
 * This is necessary when initializing such an object may fail after the initial
 * allocation.  The partially-initialized object must be destroyed, but it may
 * not be safe to do so at the current time.  This policy puts the object on a
 * queue to be destroyed at a safe time.
 */
template <typename T>
struct GCManagedDeletePolicy
{
    void operator()(const T* ptr) {
        if (ptr) {
            JSRuntime* rt = TlsPerThreadData.get()->runtimeIfOnOwnerThread();
            if (rt && rt->gc.nursery.isEnabled()) {
                // The object may contain nursery pointers and must only be
                // destroyed after a minor GC.
                rt->gc.callAfterMinorGC(deletePtr, const_cast<T*>(ptr));
            } else {
                // The object cannot contain nursery pointers so can be
                // destroyed immediately.
                gc::AutoSetThreadIsSweeping threadIsSweeping;
                js_delete(const_cast<T*>(ptr));
            }
        }
    }

  private:
    static void deletePtr(void* data) {
        js_delete(reinterpret_cast<T*>(data));
    }
};

} /* namespace js */

namespace JS {

template <typename T>
struct DeletePolicy<js::GCPtr<T>> : public js::GCManagedDeletePolicy<js::GCPtr<T>>
{};

// Scope data that contain GCPtrs must use the correct DeletePolicy.
//
// This is defined here because vm/Scope.h cannot #include "vm/Runtime.h"

template <>
struct DeletePolicy<js::FunctionScope::Data>
  : public js::GCManagedDeletePolicy<js::FunctionScope::Data>
{ };

template <>
struct DeletePolicy<js::ModuleScope::Data>
  : public js::GCManagedDeletePolicy<js::ModuleScope::Data>
{ };

} /* namespace JS */

#ifdef _MSC_VER
#pragma warning(pop)
#endif

#endif /* vm_Runtime_h */
