/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
 * Definitions for managing off-thread work using a process wide list
 * of worklist items and pool of threads. Worklist items are engine internal,
 * and are distinct from e.g. web workers.
 */

#ifndef vm_HelperThreads_h
#define vm_HelperThreads_h

#include "mozilla/Attributes.h"
#include "mozilla/GuardObjects.h"
#include "mozilla/PodOperations.h"
#include "mozilla/TimeStamp.h"
#include "mozilla/Utf8.h"  // mozilla::Utf8Unit
#include "mozilla/Variant.h"

#include "jsapi.h"

#include "ds/Fifo.h"
#include "jit/JitContext.h"
#include "js/BinASTFormat.h"  // JS::BinASTFormat
#include "js/CompileOptions.h"
#include "js/SourceText.h"
#include "js/TypeDecls.h"
#include "threading/ConditionVariable.h"
#include "vm/JSContext.h"
#include "vm/MutexIDs.h"
#include "vm/OffThreadPromiseRuntimeState.h"  // js::OffThreadPromiseTask
#include "vm/PromiseObject.h"                 // js::PromiseObject

namespace JS {
class OffThreadToken {};
}  // namespace JS

namespace js {

class AutoLockHelperThreadState;
class AutoUnlockHelperThreadState;
class CompileError;
struct HelperThread;
struct ParseTask;
struct PromiseHelperTask;
namespace jit {
class IonCompileTask;
}  // namespace jit
namespace wasm {
struct Tier2GeneratorTask;
}  // namespace wasm

enum class ParseTaskKind {
  Script,
  Module,
  ScriptDecode,
  BinAST,
  MultiScriptsDecode
};

namespace wasm {

struct CompileTask;
typedef Fifo<CompileTask*, 0, SystemAllocPolicy> CompileTaskPtrFifo;

struct Tier2GeneratorTask : public RunnableTask {
  virtual ~Tier2GeneratorTask() = default;
  virtual void cancel() = 0;
};

using UniqueTier2GeneratorTask = UniquePtr<Tier2GeneratorTask>;
typedef Vector<Tier2GeneratorTask*, 0, SystemAllocPolicy>
    Tier2GeneratorTaskPtrVector;

}  // namespace wasm

// Per-process state for off thread work items.
class GlobalHelperThreadState {
  friend class AutoLockHelperThreadState;
  friend class AutoUnlockHelperThreadState;

 public:
  // A single tier-2 ModuleGenerator job spawns many compilation jobs, and we
  // do not want to allow more than one such ModuleGenerator to run at a time.
  static const size_t MaxTier2GeneratorTasks = 1;

  // Number of CPUs to treat this machine as having when creating threads.
  // May be accessed without locking.
  size_t cpuCount;

  // Number of threads to create. May be accessed without locking.
  size_t threadCount;

  typedef Vector<jit::IonCompileTask*, 0, SystemAllocPolicy>
      IonCompileTaskVector;
  typedef Vector<ParseTask*, 0, SystemAllocPolicy> ParseTaskVector;
  using ParseTaskList = mozilla::LinkedList<ParseTask>;
  typedef Vector<UniquePtr<SourceCompressionTask>, 0, SystemAllocPolicy>
      SourceCompressionTaskVector;
  using GCParallelTaskList = mozilla::LinkedList<GCParallelTask>;
  typedef Vector<PromiseHelperTask*, 0, SystemAllocPolicy>
      PromiseHelperTaskVector;
  typedef Vector<JSContext*, 0, SystemAllocPolicy> ContextVector;

  // List of available threads, or null if the thread state has not been
  // initialized.
  using HelperThreadVector = Vector<HelperThread, 0, SystemAllocPolicy>;
  UniquePtr<HelperThreadVector> threads;

  WriteOnceData<JS::RegisterThreadCallback> registerThread;
  WriteOnceData<JS::UnregisterThreadCallback> unregisterThread;

 private:
  // The lists below are all protected by |lock|.

  // Ion compilation worklist and finished jobs.
  IonCompileTaskVector ionWorklist_, ionFinishedList_, ionFreeList_;

  // wasm worklists.
  wasm::CompileTaskPtrFifo wasmWorklist_tier1_;
  wasm::CompileTaskPtrFifo wasmWorklist_tier2_;
  wasm::Tier2GeneratorTaskPtrVector wasmTier2GeneratorWorklist_;

  // Count of finished Tier2Generator tasks.
  uint32_t wasmTier2GeneratorsFinished_;

  // Async tasks that, upon completion, are dispatched back to the JSContext's
  // owner thread via embedding callbacks instead of a finished list.
  PromiseHelperTaskVector promiseHelperTasks_;

  // Script parsing/emitting worklist and finished jobs.
  ParseTaskVector parseWorklist_;
  ParseTaskList parseFinishedList_;

  // Parse tasks waiting for an atoms-zone GC to complete.
  ParseTaskVector parseWaitingOnGC_;

  // Source compression worklist of tasks that we do not yet know can start.
  SourceCompressionTaskVector compressionPendingList_;

  // Source compression worklist of tasks that can start.
  SourceCompressionTaskVector compressionWorklist_;

  // Finished source compression tasks.
  SourceCompressionTaskVector compressionFinishedList_;

  // GC tasks needing to be done in parallel.
  GCParallelTaskList gcParallelWorklist_;

  // Global list of JSContext for GlobalHelperThreadState to use.
  ContextVector helperContexts_;

  ParseTask* removeFinishedParseTask(ParseTaskKind kind,
                                     JS::OffThreadToken* token);

 public:
  void addSizeOfIncludingThis(JS::GlobalStats* stats,
                              AutoLockHelperThreadState& lock) const;

  size_t maxIonCompilationThreads() const;
  size_t maxWasmCompilationThreads() const;
  size_t maxWasmTier2GeneratorThreads() const;
  size_t maxPromiseHelperThreads() const;
  size_t maxParseThreads() const;
  size_t maxCompressionThreads() const;
  size_t maxGCParallelThreads() const;

  GlobalHelperThreadState();

  bool ensureInitialized();
  void finish();
  void finishThreads();

  MOZ_MUST_USE bool ensureContextListForThreadCount();
  JSContext* getFirstUnusedContext(AutoLockHelperThreadState& locked);
  void destroyHelperContexts(AutoLockHelperThreadState& lock);

#ifdef DEBUG
  bool isLockedByCurrentThread() const;
#endif

  enum CondVar {
    // For notifying threads waiting for work that they may be able to make
    // progress, ie, a work item has been completed by a helper thread and
    // the thread that created the work item can now consume it.
    CONSUMER,

    // For notifying helper threads doing the work that they may be able to
    // make progress, ie, a work item has been enqueued and an idle helper
    // thread may pick up up the work item and perform it.
    PRODUCER,
  };

  void wait(AutoLockHelperThreadState& locked, CondVar which,
            mozilla::TimeDuration timeout = mozilla::TimeDuration::Forever());
  void notifyAll(CondVar which, const AutoLockHelperThreadState&);
  void notifyOne(CondVar which, const AutoLockHelperThreadState&);

  // Helper method for removing items from the vectors below while iterating
  // over them.
  template <typename T>
  void remove(T& vector, size_t* index) {
    // Self-moving is undefined behavior.
    if (*index != vector.length() - 1) {
      vector[*index] = std::move(vector.back());
    }
    (*index)--;
    vector.popBack();
  }

  IonCompileTaskVector& ionWorklist(const AutoLockHelperThreadState&) {
    return ionWorklist_;
  }
  IonCompileTaskVector& ionFinishedList(const AutoLockHelperThreadState&) {
    return ionFinishedList_;
  }
  IonCompileTaskVector& ionFreeList(const AutoLockHelperThreadState&) {
    return ionFreeList_;
  }

  wasm::CompileTaskPtrFifo& wasmWorklist(const AutoLockHelperThreadState&,
                                         wasm::CompileMode m) {
    switch (m) {
      case wasm::CompileMode::Once:
      case wasm::CompileMode::Tier1:
        return wasmWorklist_tier1_;
      case wasm::CompileMode::Tier2:
        return wasmWorklist_tier2_;
      default:
        MOZ_CRASH();
    }
  }

  wasm::Tier2GeneratorTaskPtrVector& wasmTier2GeneratorWorklist(
      const AutoLockHelperThreadState&) {
    return wasmTier2GeneratorWorklist_;
  }

  void incWasmTier2GeneratorsFinished(const AutoLockHelperThreadState&) {
    wasmTier2GeneratorsFinished_++;
  }

  uint32_t wasmTier2GeneratorsFinished(const AutoLockHelperThreadState&) const {
    return wasmTier2GeneratorsFinished_;
  }

  PromiseHelperTaskVector& promiseHelperTasks(
      const AutoLockHelperThreadState&) {
    return promiseHelperTasks_;
  }

  ParseTaskVector& parseWorklist(const AutoLockHelperThreadState&) {
    return parseWorklist_;
  }
  ParseTaskList& parseFinishedList(const AutoLockHelperThreadState&) {
    return parseFinishedList_;
  }
  ParseTaskVector& parseWaitingOnGC(const AutoLockHelperThreadState&) {
    return parseWaitingOnGC_;
  }

  SourceCompressionTaskVector& compressionPendingList(
      const AutoLockHelperThreadState&) {
    return compressionPendingList_;
  }

  SourceCompressionTaskVector& compressionWorklist(
      const AutoLockHelperThreadState&) {
    return compressionWorklist_;
  }

  SourceCompressionTaskVector& compressionFinishedList(
      const AutoLockHelperThreadState&) {
    return compressionFinishedList_;
  }

  GCParallelTaskList& gcParallelWorklist(const AutoLockHelperThreadState&) {
    return gcParallelWorklist_;
  }

  bool canStartWasmCompile(const AutoLockHelperThreadState& lock,
                           wasm::CompileMode mode);

  bool canStartWasmTier1Compile(const AutoLockHelperThreadState& lock);
  bool canStartWasmTier2Compile(const AutoLockHelperThreadState& lock);
  bool canStartWasmTier2Generator(const AutoLockHelperThreadState& lock);
  bool canStartPromiseHelperTask(const AutoLockHelperThreadState& lock);
  bool canStartIonCompile(const AutoLockHelperThreadState& lock);
  bool canStartIonFreeTask(const AutoLockHelperThreadState& lock);
  bool canStartParseTask(const AutoLockHelperThreadState& lock);
  bool canStartCompressionTask(const AutoLockHelperThreadState& lock);
  bool canStartGCParallelTask(const AutoLockHelperThreadState& lock);

  enum class ScheduleCompressionTask { GC, API };

  // Used by a major GC to signal processing enqueued compression tasks.
  void startHandlingCompressionTasks(const AutoLockHelperThreadState&,
                                     ScheduleCompressionTask schedule);

  jit::IonCompileTask* highestPriorityPendingIonCompile(
      const AutoLockHelperThreadState& lock);

 private:
  void scheduleCompressionTasks(const AutoLockHelperThreadState&,
                                ScheduleCompressionTask schedule);

  UniquePtr<ParseTask> finishParseTaskCommon(JSContext* cx, ParseTaskKind kind,
                                             JS::OffThreadToken* token);

  JSScript* finishSingleParseTask(JSContext* cx, ParseTaskKind kind,
                                  JS::OffThreadToken* token);
  bool finishMultiParseTask(JSContext* cx, ParseTaskKind kind,
                            JS::OffThreadToken* token,
                            MutableHandle<ScriptVector> scripts);

  void mergeParseTaskRealm(JSContext* cx, ParseTask* parseTask,
                           JS::Realm* dest);

 public:
  void cancelParseTask(JSRuntime* rt, ParseTaskKind kind,
                       JS::OffThreadToken* token);
  void destroyParseTask(JSRuntime* rt, ParseTask* parseTask);

  void trace(JSTracer* trc);

  JSScript* finishScriptParseTask(JSContext* cx, JS::OffThreadToken* token);
  JSScript* finishScriptDecodeTask(JSContext* cx, JS::OffThreadToken* token);
  bool finishMultiScriptsDecodeTask(JSContext* cx, JS::OffThreadToken* token,
                                    MutableHandle<ScriptVector> scripts);
  JSObject* finishModuleParseTask(JSContext* cx, JS::OffThreadToken* token);

#if defined(JS_BUILD_BINAST)
  JSScript* finishBinASTDecodeTask(JSContext* cx, JS::OffThreadToken* token);
#endif

  bool hasActiveThreads(const AutoLockHelperThreadState&);
  void waitForAllThreads();
  void waitForAllThreadsLocked(AutoLockHelperThreadState&);

  template <typename T>
  bool checkTaskThreadLimit(size_t maxThreads, bool isMaster = false) const;

  void triggerFreeUnusedMemory();

 private:
  /*
   * Lock protecting all mutable shared state accessed by helper threads, and
   * used by all condition variables.
   */
  js::Mutex helperLock;

  /* Condvars for threads waiting/notifying each other. */
  js::ConditionVariable consumerWakeup;
  js::ConditionVariable producerWakeup;

  js::ConditionVariable& whichWakeup(CondVar which) {
    switch (which) {
      case CONSUMER:
        return consumerWakeup;
      case PRODUCER:
        return producerWakeup;
      default:
        MOZ_CRASH("Invalid CondVar in |whichWakeup|");
    }
  }
};

static inline GlobalHelperThreadState& HelperThreadState() {
  extern GlobalHelperThreadState* gHelperThreadState;

  MOZ_ASSERT(gHelperThreadState);
  return *gHelperThreadState;
}

typedef mozilla::Variant<jit::IonCompileTask*, wasm::CompileTask*,
                         wasm::Tier2GeneratorTask*, PromiseHelperTask*,
                         ParseTask*, SourceCompressionTask*, GCParallelTask*>
    HelperTaskUnion;

/* Individual helper thread, one allocated per core. */
struct HelperThread {
  mozilla::Maybe<Thread> thread;

  /*
   * Indicate to a thread that it should terminate itself. This is only read
   * or written with the helper thread state lock held.
   */
  bool terminate;

  /* The current task being executed by this thread, if any. */
  mozilla::Maybe<HelperTaskUnion> currentTask;

  bool idle() const { return currentTask.isNothing(); }

  /* Any builder currently being compiled by Ion on this thread. */
  jit::IonCompileTask* ionCompileTask() {
    return maybeCurrentTaskAs<jit::IonCompileTask*>();
  }

  /* Any wasm data currently being optimized on this thread. */
  wasm::CompileTask* wasmTask() {
    return maybeCurrentTaskAs<wasm::CompileTask*>();
  }

  wasm::Tier2GeneratorTask* wasmTier2GeneratorTask() {
    return maybeCurrentTaskAs<wasm::Tier2GeneratorTask*>();
  }

  /* Any source being parsed/emitted on this thread. */
  ParseTask* parseTask() { return maybeCurrentTaskAs<ParseTask*>(); }

  /* Any source being compressed on this thread. */
  SourceCompressionTask* compressionTask() {
    return maybeCurrentTaskAs<SourceCompressionTask*>();
  }

  /* State required to perform a GC parallel task. */
  GCParallelTask* gcParallelTask() {
    return maybeCurrentTaskAs<GCParallelTask*>();
  }

  void destroy();

  static void ThreadMain(void* arg);
  void threadLoop();

  void ensureRegisteredWithProfiler();
  void unregisterWithProfilerIfNeeded();

 private:
  struct AutoProfilerLabel {
    AutoProfilerLabel(HelperThread* helperThread, const char* label,
                      JS::ProfilingCategoryPair categoryPair);
    ~AutoProfilerLabel();

   private:
    ProfilingStack* profilingStack;
  };

  /*
   * The profiling thread for this helper thread, which can be used to push
   * and pop label frames.
   * This field being non-null Indicates that this thread has been registered
   * and needs to be unregistered at shutdown.
   */
  ProfilingStack* profilingStack;

  struct TaskSpec {
    using Selector =
        bool (GlobalHelperThreadState::*)(const AutoLockHelperThreadState&);
    using Handler = void (HelperThread::*)(AutoLockHelperThreadState&);

    js::ThreadType type;
    Selector canStart;
    Handler handleWorkload;
  };

  static const TaskSpec taskSpecs[];

  const TaskSpec* findHighestPriorityTask(
      const AutoLockHelperThreadState& locked);

  template <typename T>
  T maybeCurrentTaskAs() {
    if (currentTask.isSome() && currentTask->is<T>()) {
      return currentTask->as<T>();
    }

    return nullptr;
  }

  void handleWasmWorkload(AutoLockHelperThreadState& locked,
                          wasm::CompileMode mode);

  void handleWasmTier1Workload(AutoLockHelperThreadState& locked);
  void handleWasmTier2Workload(AutoLockHelperThreadState& locked);
  void handleWasmTier2GeneratorWorkload(AutoLockHelperThreadState& locked);
  void handlePromiseHelperTaskWorkload(AutoLockHelperThreadState& locked);
  void handleIonWorkload(AutoLockHelperThreadState& locked);
  void handleIonFreeWorkload(AutoLockHelperThreadState& locked);
  void handleParseWorkload(AutoLockHelperThreadState& locked);
  void handleCompressionWorkload(AutoLockHelperThreadState& locked);
  void handleGCParallelWorkload(AutoLockHelperThreadState& locked);
};

/* Methods for interacting with helper threads. */

// Create data structures used by helper threads.
bool CreateHelperThreadsState();

// Destroy data structures used by helper threads.
void DestroyHelperThreadsState();

// Initialize helper threads unless already initialized.
bool EnsureHelperThreadsInitialized();

// This allows the JS shell to override GetCPUCount() when passed the
// --thread-count=N option.
bool SetFakeCPUCount(size_t count);

// Get the current helper thread, or null.
HelperThread* CurrentHelperThread();

// Enqueues a wasm compilation task.
bool StartOffThreadWasmCompile(wasm::CompileTask* task, wasm::CompileMode mode);

namespace wasm {

// Called on a helper thread after StartOffThreadWasmCompile.
void ExecuteCompileTaskFromHelperThread(CompileTask* task);

}  // namespace wasm

// Enqueues a wasm compilation task.
void StartOffThreadWasmTier2Generator(wasm::UniqueTier2GeneratorTask task);

// Cancel all background Wasm Tier-2 compilations.
void CancelOffThreadWasmTier2Generator();

/*
 * If helper threads are available, call execute() then dispatchResolve() on the
 * given task in a helper thread. If no helper threads are available, the given
 * task is executed and resolved synchronously.
 *
 * This function takes ownership of task unconditionally; if it fails, task is
 * deleted.
 */
bool StartOffThreadPromiseHelperTask(JSContext* cx,
                                     UniquePtr<PromiseHelperTask> task);

/*
 * Like the JSContext-accepting version, but only safe to use when helper
 * threads are available, so we can be sure we'll never need to fall back on
 * synchronous execution.
 *
 * This function can be called from any thread, but takes ownership of the task
 * only on success. On OOM, it is the caller's responsibility to arrange for the
 * task to be cleaned up properly.
 */
bool StartOffThreadPromiseHelperTask(PromiseHelperTask* task);

/*
 * Schedule an off-thread Ion compilation for a script, given a task.
 */
bool StartOffThreadIonCompile(jit::IonCompileTask* task,
                              const AutoLockHelperThreadState& lock);

/*
 * Schedule deletion of Ion compilation data.
 */
bool StartOffThreadIonFree(jit::IonCompileTask* task,
                           const AutoLockHelperThreadState& lock);

struct ZonesInState {
  JSRuntime* runtime;
  JS::shadow::Zone::GCState state;
};
struct CompilationsUsingNursery {
  JSRuntime* runtime;
};

using CompilationSelector =
    mozilla::Variant<JSScript*, JS::Realm*, Zone*, ZonesInState, JSRuntime*,
                     CompilationsUsingNursery>;

/*
 * Cancel scheduled or in progress Ion compilations.
 */
void CancelOffThreadIonCompile(const CompilationSelector& selector);

inline void CancelOffThreadIonCompile(JSScript* script) {
  CancelOffThreadIonCompile(CompilationSelector(script));
}

inline void CancelOffThreadIonCompile(JS::Realm* realm) {
  CancelOffThreadIonCompile(CompilationSelector(realm));
}

inline void CancelOffThreadIonCompile(Zone* zone) {
  CancelOffThreadIonCompile(CompilationSelector(zone));
}

inline void CancelOffThreadIonCompile(JSRuntime* runtime,
                                      JS::shadow::Zone::GCState state) {
  CancelOffThreadIonCompile(CompilationSelector(ZonesInState{runtime, state}));
}

inline void CancelOffThreadIonCompile(JSRuntime* runtime) {
  CancelOffThreadIonCompile(CompilationSelector(runtime));
}

inline void CancelOffThreadIonCompilesUsingNurseryPointers(JSRuntime* runtime) {
  CancelOffThreadIonCompile(
      CompilationSelector(CompilationsUsingNursery{runtime}));
}

#ifdef DEBUG
bool HasOffThreadIonCompile(JS::Realm* realm);
#endif

/* Cancel all scheduled, in progress or finished parses for runtime. */
void CancelOffThreadParses(JSRuntime* runtime);

/*
 * Start a parse/emit cycle for a stream of source. The characters must stay
 * alive until the compilation finishes.
 */
bool StartOffThreadParseScript(JSContext* cx,
                               const JS::ReadOnlyCompileOptions& options,
                               JS::SourceText<char16_t>& srcBuf,
                               JS::OffThreadCompileCallback callback,
                               void* callbackData);
bool StartOffThreadParseScript(JSContext* cx,
                               const JS::ReadOnlyCompileOptions& options,
                               JS::SourceText<mozilla::Utf8Unit>& srcBuf,
                               JS::OffThreadCompileCallback callback,
                               void* callbackData);

bool StartOffThreadParseModule(JSContext* cx,
                               const JS::ReadOnlyCompileOptions& options,
                               JS::SourceText<char16_t>& srcBuf,
                               JS::OffThreadCompileCallback callback,
                               void* callbackData);
bool StartOffThreadParseModule(JSContext* cx,
                               const JS::ReadOnlyCompileOptions& options,
                               JS::SourceText<mozilla::Utf8Unit>& srcBuf,
                               JS::OffThreadCompileCallback callback,
                               void* callbackData);

bool StartOffThreadDecodeScript(JSContext* cx,
                                const JS::ReadOnlyCompileOptions& options,
                                const JS::TranscodeRange& range,
                                JS::OffThreadCompileCallback callback,
                                void* callbackData);

#if defined(JS_BUILD_BINAST)

bool StartOffThreadDecodeBinAST(JSContext* cx,
                                const JS::ReadOnlyCompileOptions& options,
                                const uint8_t* buf, size_t length,
                                JS::BinASTFormat format,
                                JS::OffThreadCompileCallback callback,
                                void* callbackData);

#endif /* JS_BUILD_BINAST */

bool StartOffThreadDecodeMultiScripts(JSContext* cx,
                                      const JS::ReadOnlyCompileOptions& options,
                                      JS::TranscodeSources& sources,
                                      JS::OffThreadCompileCallback callback,
                                      void* callbackData);

/*
 * Called at the end of GC to enqueue any Parse tasks that were waiting on an
 * atoms-zone GC to finish.
 */
void EnqueuePendingParseTasksAfterGC(JSRuntime* rt);

struct AutoEnqueuePendingParseTasksAfterGC {
  const gc::GCRuntime& gc_;
  explicit AutoEnqueuePendingParseTasksAfterGC(const gc::GCRuntime& gc)
      : gc_(gc) {}
  ~AutoEnqueuePendingParseTasksAfterGC();
};

// Enqueue a compression job to be processed if there's a major GC.
bool EnqueueOffThreadCompression(JSContext* cx,
                                 UniquePtr<SourceCompressionTask> task);

// Cancel all scheduled, in progress, or finished compression tasks for
// runtime.
void CancelOffThreadCompressions(JSRuntime* runtime);

void AttachFinishedCompressions(JSRuntime* runtime,
                                AutoLockHelperThreadState& lock);

// Run all pending source compression tasks synchronously, for testing purposes
void RunPendingSourceCompressions(JSRuntime* runtime);

class MOZ_RAII AutoLockHelperThreadState : public LockGuard<Mutex> {
  using Base = LockGuard<Mutex>;

  MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER

 public:
  explicit AutoLockHelperThreadState(MOZ_GUARD_OBJECT_NOTIFIER_ONLY_PARAM)
      : Base(HelperThreadState().helperLock) {
    MOZ_GUARD_OBJECT_NOTIFIER_INIT;
  }
};

class MOZ_RAII AutoUnlockHelperThreadState : public UnlockGuard<Mutex> {
  using Base = UnlockGuard<Mutex>;

  MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER

 public:
  explicit AutoUnlockHelperThreadState(
      AutoLockHelperThreadState& locked MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
      : Base(locked) {
    MOZ_GUARD_OBJECT_NOTIFIER_INIT;
  }
};

struct MOZ_RAII AutoSetHelperThreadContext {
  JSContext* cx;
  explicit AutoSetHelperThreadContext();
  ~AutoSetHelperThreadContext() {
    AutoLockHelperThreadState lock;
    cx->tempLifoAlloc().releaseAll();
    if (cx->shouldFreeUnusedMemory()) {
      cx->tempLifoAlloc().freeAll();
      cx->setFreeUnusedMemory(false);
    }
    cx->clearHelperThread(lock);
    cx = nullptr;
  }
};

struct MOZ_RAII AutoSetContextRuntime {
  explicit AutoSetContextRuntime(JSRuntime* rt) {
    TlsContext.get()->setRuntime(rt);
  }
  ~AutoSetContextRuntime() { TlsContext.get()->setRuntime(nullptr); }
};

struct ParseTask : public mozilla::LinkedListElement<ParseTask>,
                   public JS::OffThreadToken,
                   public RunnableTask {
  ParseTaskKind kind;
  JS::OwningCompileOptions options;

  // The global object to use while parsing.
  JSObject* parseGlobal;

  // Callback invoked off thread when the parse finishes.
  JS::OffThreadCompileCallback callback;
  void* callbackData;

  // Holds the final scripts between the invocation of the callback and the
  // point where FinishOffThreadScript is called, which will destroy the
  // ParseTask.
  GCVector<JSScript*, 1, SystemAllocPolicy> scripts;

  // Holds the ScriptSourceObjects generated for the script compilation.
  GCVector<ScriptSourceObject*, 1, SystemAllocPolicy> sourceObjects;

  // Any errors or warnings produced during compilation. These are reported
  // when finishing the script.
  Vector<UniquePtr<CompileError>, 0, SystemAllocPolicy> errors;
  bool overRecursed;
  bool outOfMemory;

  ParseTask(ParseTaskKind kind, JSContext* cx,
            JS::OffThreadCompileCallback callback, void* callbackData);
  virtual ~ParseTask();

  bool init(JSContext* cx, const JS::ReadOnlyCompileOptions& options,
            JSObject* global);

  void activate(JSRuntime* rt);
  virtual void parse(JSContext* cx) = 0;

  bool runtimeMatches(JSRuntime* rt) {
    return parseGlobal->runtimeFromAnyThread() == rt;
  }

  void trace(JSTracer* trc);

  size_t sizeOfExcludingThis(mozilla::MallocSizeOf mallocSizeOf) const;
  size_t sizeOfIncludingThis(mozilla::MallocSizeOf mallocSizeOf) const {
    return mallocSizeOf(this) + sizeOfExcludingThis(mallocSizeOf);
  }

  void runTask() override;
  ThreadType threadType() override { return ThreadType::THREAD_TYPE_PARSE; }
};

struct ScriptDecodeTask : public ParseTask {
  const JS::TranscodeRange range;

  ScriptDecodeTask(JSContext* cx, const JS::TranscodeRange& range,
                   JS::OffThreadCompileCallback callback, void* callbackData);
  void parse(JSContext* cx) override;
};

#if defined(JS_BUILD_BINAST)

struct BinASTDecodeTask : public ParseTask {
  mozilla::Range<const uint8_t> data;
  JS::BinASTFormat format;

  BinASTDecodeTask(JSContext* cx, const uint8_t* buf, size_t length,
                   JS::BinASTFormat format,
                   JS::OffThreadCompileCallback callback, void* callbackData);
  void parse(JSContext* cx) override;
};

#endif /* JS_BUILD_BINAST */

struct MultiScriptsDecodeTask : public ParseTask {
  JS::TranscodeSources* sources;

  MultiScriptsDecodeTask(JSContext* cx, JS::TranscodeSources& sources,
                         JS::OffThreadCompileCallback callback,
                         void* callbackData);
  void parse(JSContext* cx) override;
};

// Return whether, if a new parse task was started, it would need to wait for
// an in-progress GC to complete before starting.
extern bool OffThreadParsingMustWaitForGC(JSRuntime* rt);

// It is not desirable to eagerly compress: if lazy functions that are tied to
// the ScriptSource were to be executed relatively soon after parsing, they
// would need to block on decompression, which hurts responsiveness.
//
// To this end, compression tasks are heap allocated and enqueued in a pending
// list by ScriptSource::setSourceCopy. When a major GC occurs, we schedule
// pending compression tasks and move the ones that are ready to be compressed
// to the worklist. Currently, a compression task is considered ready 2 major
// GCs after being enqueued. Completed tasks are handled during the sweeping
// phase by AttachCompressedSourcesTask, which runs in parallel with other GC
// sweeping tasks.
class SourceCompressionTask : public RunnableTask {
  friend struct HelperThread;
  friend class ScriptSource;

  // The runtime that the ScriptSource is associated with, in the sense that
  // it uses the runtime's immutable string cache.
  JSRuntime* runtime_;

  // The major GC number of the runtime when the task was enqueued.
  uint64_t majorGCNumber_;

  // The source to be compressed.
  ScriptSourceHolder sourceHolder_;

  // The resultant compressed string. If the compressed string is larger
  // than the original, or we OOM'd during compression, or nothing else
  // except the task is holding the ScriptSource alive when scheduled to
  // compress, this will remain None upon completion.
  mozilla::Maybe<SharedImmutableString> resultString_;

 public:
  // The majorGCNumber is used for scheduling tasks.
  SourceCompressionTask(JSRuntime* rt, ScriptSource* source)
      : runtime_(rt),
        majorGCNumber_(rt->gc.majorGCCount()),
        sourceHolder_(source) {}
  virtual ~SourceCompressionTask() = default;

  bool runtimeMatches(JSRuntime* runtime) const { return runtime == runtime_; }
  bool shouldStart() const {
    // We wait 2 major GCs to start compressing, in order to avoid
    // immediate compression.
    return runtime_->gc.majorGCCount() > majorGCNumber_ + 1;
  }

  bool shouldCancel() const {
    // If the refcount is exactly 1, then nothing else is holding on to the
    // ScriptSource, so no reason to compress it and we should cancel the task.
    return sourceHolder_.get()->refs == 1;
  }

  void runTask() override;
  void complete();

  ThreadType threadType() override { return ThreadType::THREAD_TYPE_COMPRESS; }

 private:
  struct PerformTaskWork;
  friend struct PerformTaskWork;

  // The work algorithm, aware whether it's compressing one-byte UTF-8 source
  // text or UTF-16, for CharT either Utf8Unit or char16_t.  Invoked by
  // work() after doing a type-test of the ScriptSource*.
  template <typename CharT>
  void workEncodingSpecific();
};

// A PromiseHelperTask is an OffThreadPromiseTask that executes a single job on
// a helper thread. Call js::StartOffThreadPromiseHelperTask to submit a
// PromiseHelperTask for execution.
//
// Concrete subclasses must implement execute and OffThreadPromiseTask::resolve.
// The helper thread will call execute() to do the main work. Then, the thread
// of the JSContext used to create the PromiseHelperTask will call resolve() to
// resolve promise according to those results.
struct PromiseHelperTask : OffThreadPromiseTask, public RunnableTask {
  PromiseHelperTask(JSContext* cx, Handle<PromiseObject*> promise)
      : OffThreadPromiseTask(cx, promise) {}

  // To be called on a helper thread and implemented by the derived class.
  virtual void execute() = 0;

  // May be called in the absence of helper threads or off-thread promise
  // support to synchronously execute and resolve a PromiseTask.
  //
  // Warning: After this function returns, 'this' can be deleted at any time, so
  // the caller must immediately return from the stream callback.
  void executeAndResolveAndDestroy(JSContext* cx);
  void runTask() override;
  ThreadType threadType() override { return THREAD_TYPE_PROMISE_TASK; }
};

} /* namespace js */

#endif /* vm_HelperThreads_h */
