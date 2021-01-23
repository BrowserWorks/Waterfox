/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsThreadUtils.h"

#include "LeakRefPtr.h"
#include "mozilla/Attributes.h"
#include "mozilla/Likely.h"
#include "mozilla/TimeStamp.h"
#include "nsComponentManagerUtils.h"
#include "nsExceptionHandler.h"
#include "nsITimer.h"
#include "prsystem.h"

#ifdef MOZILLA_INTERNAL_API
#  include "nsThreadManager.h"
#else
#  include "nsIThreadManager.h"
#  include "nsServiceManagerUtils.h"
#  include "nsXPCOMCIDInternal.h"
#endif

#ifdef XP_WIN
#  include <windows.h>
#elif defined(XP_MACOSX)
#  include <sys/resource.h>
#endif

#if defined(ANDROID)
#  include <sys/prctl.h>
#endif

static LazyLogModule sEventDispatchAndRunLog("events");
#ifdef LOG1
#  undef LOG1
#endif
#define LOG1(args) \
  MOZ_LOG(sEventDispatchAndRunLog, mozilla::LogLevel::Error, args)

using namespace mozilla;

NS_IMPL_ISUPPORTS(TailDispatchingTarget, nsIEventTarget, nsISerialEventTarget)

#ifndef XPCOM_GLUE_AVOID_NSPR

NS_IMPL_ISUPPORTS(IdlePeriod, nsIIdlePeriod)

NS_IMETHODIMP
IdlePeriod::GetIdlePeriodHint(TimeStamp* aIdleDeadline) {
  *aIdleDeadline = TimeStamp();
  return NS_OK;
}

// NS_IMPL_NAMED_* relies on the mName field, which is not present on
// release or beta. Instead, fall back to using "Runnable" for all
// runnables.
#  ifndef MOZ_COLLECTING_RUNNABLE_TELEMETRY
NS_IMPL_ISUPPORTS(Runnable, nsIRunnable)
#  else
NS_IMPL_NAMED_ADDREF(Runnable, mName)
NS_IMPL_NAMED_RELEASE(Runnable, mName)
NS_IMPL_QUERY_INTERFACE(Runnable, nsIRunnable, nsINamed)
#  endif

NS_IMETHODIMP
Runnable::Run() {
  // Do nothing
  return NS_OK;
}

#  ifdef MOZ_COLLECTING_RUNNABLE_TELEMETRY
NS_IMETHODIMP
Runnable::GetName(nsACString& aName) {
  if (mName) {
    aName.AssignASCII(mName);
  } else {
    aName.Truncate();
  }
  return NS_OK;
}
#  endif

NS_IMPL_ISUPPORTS_INHERITED(CancelableRunnable, Runnable, nsICancelableRunnable)

nsresult CancelableRunnable::Cancel() {
  // Do nothing
  return NS_OK;
}

NS_IMPL_ISUPPORTS_INHERITED(IdleRunnable, CancelableRunnable, nsIIdleRunnable)

NS_IMPL_ISUPPORTS_INHERITED(PrioritizableRunnable, Runnable,
                            nsIRunnablePriority)

PrioritizableRunnable::PrioritizableRunnable(
    already_AddRefed<nsIRunnable>&& aRunnable, uint32_t aPriority)
    // Real runnable name is managed by overridding the GetName function.
    : Runnable("PrioritizableRunnable"),
      mRunnable(std::move(aRunnable)),
      mPriority(aPriority) {
#  if DEBUG
  nsCOMPtr<nsIRunnablePriority> runnablePrio = do_QueryInterface(mRunnable);
  MOZ_ASSERT(!runnablePrio);
#  endif
}

#  ifdef MOZ_COLLECTING_RUNNABLE_TELEMETRY
NS_IMETHODIMP
PrioritizableRunnable::GetName(nsACString& aName) {
  // Try to get a name from the underlying runnable.
  nsCOMPtr<nsINamed> named = do_QueryInterface(mRunnable);
  if (named) {
    named->GetName(aName);
  }
  return NS_OK;
}
#  endif

NS_IMETHODIMP
PrioritizableRunnable::Run() {
  MOZ_RELEASE_ASSERT(NS_IsMainThread());
  return mRunnable->Run();
}

NS_IMETHODIMP
PrioritizableRunnable::GetPriority(uint32_t* aPriority) {
  *aPriority = mPriority;
  return NS_OK;
}

already_AddRefed<nsIRunnable> mozilla::CreateMediumHighRunnable(
    already_AddRefed<nsIRunnable>&& aRunnable) {
  nsCOMPtr<nsIRunnable> runnable = new PrioritizableRunnable(
      std::move(aRunnable), nsIRunnablePriority::PRIORITY_MEDIUMHIGH);
  return runnable.forget();
}

#endif  // XPCOM_GLUE_AVOID_NSPR

//-----------------------------------------------------------------------------

nsresult NS_NewNamedThread(const nsACString& aName, nsIThread** aResult,
                           nsIRunnable* aInitialEvent, uint32_t aStackSize) {
  nsCOMPtr<nsIRunnable> event = aInitialEvent;
  return NS_NewNamedThread(aName, aResult, event.forget(), aStackSize);
}

nsresult NS_NewNamedThread(const nsACString& aName, nsIThread** aResult,
                           already_AddRefed<nsIRunnable> aInitialEvent,
                           uint32_t aStackSize) {
  nsCOMPtr<nsIRunnable> event = std::move(aInitialEvent);
  nsCOMPtr<nsIThread> thread;
#ifdef MOZILLA_INTERNAL_API
  nsresult rv = nsThreadManager::get().nsThreadManager::NewNamedThread(
      aName, aStackSize, getter_AddRefs(thread));
#else
  nsresult rv;
  nsCOMPtr<nsIThreadManager> mgr =
      do_GetService(NS_THREADMANAGER_CONTRACTID, &rv);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  rv = mgr->NewNamedThread(aName, aStackSize, getter_AddRefs(thread));
#endif
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  if (event) {
    rv = thread->Dispatch(event.forget(), NS_DISPATCH_NORMAL);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }
  }

  *aResult = nullptr;
  thread.swap(*aResult);
  return NS_OK;
}

nsresult NS_GetCurrentThread(nsIThread** aResult) {
#ifdef MOZILLA_INTERNAL_API
  return nsThreadManager::get().nsThreadManager::GetCurrentThread(aResult);
#else
  nsresult rv;
  nsCOMPtr<nsIThreadManager> mgr =
      do_GetService(NS_THREADMANAGER_CONTRACTID, &rv);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  return mgr->GetCurrentThread(aResult);
#endif
}

nsresult NS_GetMainThread(nsIThread** aResult) {
#ifdef MOZILLA_INTERNAL_API
  return nsThreadManager::get().nsThreadManager::GetMainThread(aResult);
#else
  nsresult rv;
  nsCOMPtr<nsIThreadManager> mgr =
      do_GetService(NS_THREADMANAGER_CONTRACTID, &rv);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  return mgr->GetMainThread(aResult);
#endif
}

nsresult NS_DispatchToCurrentThread(already_AddRefed<nsIRunnable>&& aEvent) {
  nsresult rv;
  nsCOMPtr<nsIRunnable> event(aEvent);
#ifdef MOZILLA_INTERNAL_API
  nsIEventTarget* thread = GetCurrentThreadEventTarget();
  if (!thread) {
    return NS_ERROR_UNEXPECTED;
  }
#else
  nsCOMPtr<nsIThread> thread;
  rv = NS_GetCurrentThread(getter_AddRefs(thread));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
#endif
  // To keep us from leaking the runnable if dispatch method fails,
  // we grab the reference on failures and release it.
  nsIRunnable* temp = event.get();
  rv = thread->Dispatch(event.forget(), NS_DISPATCH_NORMAL);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    // Dispatch() leaked the reference to the event, but due to caller's
    // assumptions, we shouldn't leak here. And given we are on the same
    // thread as the dispatch target, it's mostly safe to do it here.
    NS_RELEASE(temp);
  }
  return rv;
}

// It is common to call NS_DispatchToCurrentThread with a newly
// allocated runnable with a refcount of zero. To keep us from leaking
// the runnable if the dispatch method fails, we take a death grip.
nsresult NS_DispatchToCurrentThread(nsIRunnable* aEvent) {
  nsCOMPtr<nsIRunnable> event(aEvent);
  return NS_DispatchToCurrentThread(event.forget());
}

nsresult NS_DispatchToMainThread(already_AddRefed<nsIRunnable>&& aEvent,
                                 uint32_t aDispatchFlags) {
  LeakRefPtr<nsIRunnable> event(std::move(aEvent));
  nsCOMPtr<nsIThread> thread;
  nsresult rv = NS_GetMainThread(getter_AddRefs(thread));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    NS_ASSERTION(false,
                 "Failed NS_DispatchToMainThread() in shutdown; leaking");
    // NOTE: if you stop leaking here, adjust Promise::MaybeReportRejected(),
    // which assumes a leak here, or split into leaks and no-leaks versions
    return rv;
  }
  return thread->Dispatch(event.take(), aDispatchFlags);
}

// In the case of failure with a newly allocated runnable with a
// refcount of zero, we intentionally leak the runnable, because it is
// likely that the runnable is being dispatched to the main thread
// because it owns main thread only objects, so it is not safe to
// release them here.
nsresult NS_DispatchToMainThread(nsIRunnable* aEvent, uint32_t aDispatchFlags) {
  nsCOMPtr<nsIRunnable> event(aEvent);
  return NS_DispatchToMainThread(event.forget(), aDispatchFlags);
}

nsresult NS_DelayedDispatchToCurrentThread(
    already_AddRefed<nsIRunnable>&& aEvent, uint32_t aDelayMs) {
  nsCOMPtr<nsIRunnable> event(aEvent);
#ifdef MOZILLA_INTERNAL_API
  nsIEventTarget* thread = GetCurrentThreadEventTarget();
  if (!thread) {
    return NS_ERROR_UNEXPECTED;
  }
#else
  nsresult rv;
  nsCOMPtr<nsIThread> thread;
  rv = NS_GetCurrentThread(getter_AddRefs(thread));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
#endif

  return thread->DelayedDispatch(event.forget(), aDelayMs);
}

nsresult NS_DispatchToThreadQueue(already_AddRefed<nsIRunnable>&& aEvent,
                                  nsIThread* aThread,
                                  EventQueuePriority aQueue) {
  nsresult rv;
  nsCOMPtr<nsIRunnable> event(aEvent);
  NS_ENSURE_TRUE(event, NS_ERROR_INVALID_ARG);
  if (!aThread) {
    return NS_ERROR_UNEXPECTED;
  }
  // To keep us from leaking the runnable if dispatch method fails,
  // we grab the reference on failures and release it.
  nsIRunnable* temp = event.get();
  rv = aThread->DispatchToQueue(event.forget(), aQueue);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    // Dispatch() leaked the reference to the event, but due to caller's
    // assumptions, we shouldn't leak here. And given we are on the same
    // thread as the dispatch target, it's mostly safe to do it here.
    NS_RELEASE(temp);
  }

  return rv;
}

nsresult NS_DispatchToCurrentThreadQueue(already_AddRefed<nsIRunnable>&& aEvent,
                                         EventQueuePriority aQueue) {
  return NS_DispatchToThreadQueue(std::move(aEvent), NS_GetCurrentThread(),
                                  aQueue);
}

extern nsresult NS_DispatchToMainThreadQueue(
    already_AddRefed<nsIRunnable>&& aEvent, EventQueuePriority aQueue) {
  nsCOMPtr<nsIThread> mainThread;
  nsresult rv = NS_GetMainThread(getter_AddRefs(mainThread));
  if (NS_SUCCEEDED(rv)) {
    return NS_DispatchToThreadQueue(std::move(aEvent), mainThread, aQueue);
  }
  return rv;
}

class IdleRunnableWrapper final : public IdleRunnable {
 public:
  explicit IdleRunnableWrapper(already_AddRefed<nsIRunnable>&& aEvent)
      : mRunnable(std::move(aEvent)) {}

  NS_IMETHOD Run() override {
    if (!mRunnable) {
      return NS_OK;
    }
    CancelTimer();
    nsCOMPtr<nsIRunnable> runnable = std::move(mRunnable);
    return runnable->Run();
  }

  static void TimedOut(nsITimer* aTimer, void* aClosure) {
    RefPtr<IdleRunnableWrapper> runnable =
        static_cast<IdleRunnableWrapper*>(aClosure);
    LogRunnable::Run log(runnable);
    runnable->Run();
    runnable = nullptr;
  }

  void SetTimer(uint32_t aDelay, nsIEventTarget* aTarget) override {
    MOZ_ASSERT(aTarget);
    MOZ_ASSERT(!mTimer);
    NS_NewTimerWithFuncCallback(getter_AddRefs(mTimer), TimedOut, this, aDelay,
                                nsITimer::TYPE_ONE_SHOT,
                                "IdleRunnableWrapper::SetTimer", aTarget);
  }

#ifdef MOZ_COLLECTING_RUNNABLE_TELEMETRY
  NS_IMETHOD GetName(nsACString& aName) override {
    aName.AssignLiteral("IdleRunnableWrapper");
    if (nsCOMPtr<nsINamed> named = do_QueryInterface(mRunnable)) {
      nsAutoCString name;
      named->GetName(name);
      if (!name.IsEmpty()) {
        aName.AppendLiteral(" for ");
        aName.Append(name);
      }
    }
    return NS_OK;
  }
#endif

 private:
  ~IdleRunnableWrapper() { CancelTimer(); }

  void CancelTimer() {
    if (mTimer) {
      mTimer->Cancel();
    }
  }

  nsCOMPtr<nsITimer> mTimer;
  nsCOMPtr<nsIRunnable> mRunnable;
};

extern nsresult NS_DispatchToThreadQueue(already_AddRefed<nsIRunnable>&& aEvent,
                                         uint32_t aTimeout, nsIThread* aThread,
                                         EventQueuePriority aQueue) {
  nsCOMPtr<nsIRunnable> event(std::move(aEvent));
  NS_ENSURE_TRUE(event, NS_ERROR_INVALID_ARG);
  MOZ_ASSERT(aQueue == EventQueuePriority::Idle ||
             aQueue == EventQueuePriority::DeferredTimers);

  // XXX Using current thread for now as the nsIEventTarget.
  nsIEventTarget* target = mozilla::GetCurrentThreadEventTarget();
  if (!target) {
    return NS_ERROR_UNEXPECTED;
  }

  nsCOMPtr<nsIIdleRunnable> idleEvent = do_QueryInterface(event);

  if (!idleEvent) {
    idleEvent = new IdleRunnableWrapper(event.forget());
    event = do_QueryInterface(idleEvent);
    MOZ_DIAGNOSTIC_ASSERT(event);
  }
  idleEvent->SetTimer(aTimeout, target);

  return NS_DispatchToThreadQueue(event.forget(), aThread, aQueue);
}

extern nsresult NS_DispatchToCurrentThreadQueue(
    already_AddRefed<nsIRunnable>&& aEvent, uint32_t aTimeout,
    EventQueuePriority aQueue) {
  return NS_DispatchToThreadQueue(std::move(aEvent), aTimeout,
                                  NS_GetCurrentThread(), aQueue);
}

#ifndef XPCOM_GLUE_AVOID_NSPR
nsresult NS_ProcessPendingEvents(nsIThread* aThread, PRIntervalTime aTimeout) {
  nsresult rv = NS_OK;

#  ifdef MOZILLA_INTERNAL_API
  if (!aThread) {
    aThread = NS_GetCurrentThread();
    if (NS_WARN_IF(!aThread)) {
      return NS_ERROR_UNEXPECTED;
    }
  }
#  else
  nsCOMPtr<nsIThread> current;
  if (!aThread) {
    rv = NS_GetCurrentThread(getter_AddRefs(current));
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }
    aThread = current.get();
  }
#  endif

  PRIntervalTime start = PR_IntervalNow();
  for (;;) {
    bool processedEvent;
    rv = aThread->ProcessNextEvent(false, &processedEvent);
    if (NS_FAILED(rv) || !processedEvent) {
      break;
    }
    if (PR_IntervalNow() - start > aTimeout) {
      break;
    }
  }
  return rv;
}
#endif  // XPCOM_GLUE_AVOID_NSPR

inline bool hasPendingEvents(nsIThread* aThread) {
  bool val;
  return NS_SUCCEEDED(aThread->HasPendingEvents(&val)) && val;
}

bool NS_HasPendingEvents(nsIThread* aThread) {
  if (!aThread) {
#ifndef MOZILLA_INTERNAL_API
    nsCOMPtr<nsIThread> current;
    NS_GetCurrentThread(getter_AddRefs(current));
    return hasPendingEvents(current);
#else
    aThread = NS_GetCurrentThread();
    if (NS_WARN_IF(!aThread)) {
      return false;
    }
#endif
  }
  return hasPendingEvents(aThread);
}

bool NS_ProcessNextEvent(nsIThread* aThread, bool aMayWait) {
#ifdef MOZILLA_INTERNAL_API
  if (!aThread) {
    aThread = NS_GetCurrentThread();
    if (NS_WARN_IF(!aThread)) {
      return false;
    }
  }
#else
  nsCOMPtr<nsIThread> current;
  if (!aThread) {
    NS_GetCurrentThread(getter_AddRefs(current));
    if (NS_WARN_IF(!current)) {
      return false;
    }
    aThread = current.get();
  }
#endif
  bool val;
  return NS_SUCCEEDED(aThread->ProcessNextEvent(aMayWait, &val)) && val;
}

void NS_SetCurrentThreadName(const char* aName) {
#if defined(ANDROID)
  // Workaround for Bug 1541216 - PR_SetCurrentThreadName() Fails to set the
  // thread name on Android.
  prctl(PR_SET_NAME, reinterpret_cast<unsigned long>(aName));
#else
  PR_SetCurrentThreadName(aName);
#endif
  CrashReporter::SetCurrentThreadName(aName);
}

#ifdef MOZILLA_INTERNAL_API
nsIThread* NS_GetCurrentThread() {
  return nsThreadManager::get().GetCurrentThread();
}

nsIThread* NS_GetCurrentThreadNoCreate() {
  if (nsThreadManager::get().IsNSThread()) {
    return NS_GetCurrentThread();
  }
  return nullptr;
}
#endif

// nsThreadPoolNaming
nsCString nsThreadPoolNaming::GetNextThreadName(const nsACString& aPoolName) {
  nsCString name(aPoolName);
  name.AppendLiteral(" #");
  name.AppendInt(++mCounter, 10);  // The counter is declared as atomic
  return name;
}

nsresult NS_DispatchBackgroundTask(already_AddRefed<nsIRunnable> aEvent,
                                   uint32_t aDispatchFlags) {
  nsCOMPtr<nsIRunnable> event(aEvent);
  return nsThreadManager::get().DispatchToBackgroundThread(event,
                                                           aDispatchFlags);
}

// nsAutoLowPriorityIO
nsAutoLowPriorityIO::nsAutoLowPriorityIO() {
#if defined(XP_WIN)
  lowIOPrioritySet =
      SetThreadPriority(GetCurrentThread(), THREAD_MODE_BACKGROUND_BEGIN);
#elif defined(XP_MACOSX)
  oldPriority = getiopolicy_np(IOPOL_TYPE_DISK, IOPOL_SCOPE_THREAD);
  lowIOPrioritySet =
      oldPriority != -1 &&
      setiopolicy_np(IOPOL_TYPE_DISK, IOPOL_SCOPE_THREAD, IOPOL_THROTTLE) != -1;
#else
  lowIOPrioritySet = false;
#endif
}

nsAutoLowPriorityIO::~nsAutoLowPriorityIO() {
#if defined(XP_WIN)
  if (MOZ_LIKELY(lowIOPrioritySet)) {
    // On Windows the old thread priority is automatically restored
    SetThreadPriority(GetCurrentThread(), THREAD_MODE_BACKGROUND_END);
  }
#elif defined(XP_MACOSX)
  if (MOZ_LIKELY(lowIOPrioritySet)) {
    setiopolicy_np(IOPOL_TYPE_DISK, IOPOL_SCOPE_THREAD, oldPriority);
  }
#endif
}

namespace mozilla {

nsIEventTarget* GetCurrentThreadEventTarget() {
  nsCOMPtr<nsIThread> thread;
  nsresult rv = NS_GetCurrentThread(getter_AddRefs(thread));
  if (NS_FAILED(rv)) {
    return nullptr;
  }

  return thread->EventTarget();
}

nsIEventTarget* GetMainThreadEventTarget() {
  return GetMainThreadSerialEventTarget();
}

nsISerialEventTarget* GetCurrentThreadSerialEventTarget() {
  nsCOMPtr<nsIThread> thread;
  nsresult rv = NS_GetCurrentThread(getter_AddRefs(thread));
  if (NS_FAILED(rv)) {
    return nullptr;
  }

  return thread->SerialEventTarget();
}

nsISerialEventTarget* GetMainThreadSerialEventTarget() {
  return static_cast<nsThread*>(nsThreadManager::get().GetMainThreadWeak());
}

size_t GetNumberOfProcessors() {
#if defined(XP_LINUX) && defined(MOZ_SANDBOX)
  static const PRInt32 procs = PR_GetNumberOfProcessors();
#else
  PRInt32 procs = PR_GetNumberOfProcessors();
#endif
  MOZ_ASSERT(procs > 0);
  return static_cast<size_t>(procs);
}

template <typename T>
void LogTaskBase<T>::LogDispatch(T* aEvent) {
  LOG1(("DISP %p", aEvent));
}

template <typename T>
LogTaskBase<T>::Run::Run(T* aEvent, bool aWillRunAgain)
    : mEvent(aEvent), mWillRunAgain(aWillRunAgain) {
  LOG1(("EXEC %p", mEvent));
}

template <typename T>
LogTaskBase<T>::Run::~Run() {
  LOG1((mWillRunAgain ? "INTERRUPTED %p" : "DONE %p", mEvent));
}

template class LogTaskBase<nsIRunnable>;

}  // namespace mozilla

bool nsIEventTarget::IsOnCurrentThread() {
  if (mThread) {
    return mThread == PR_GetCurrentThread();
  }
  return IsOnCurrentThreadInfallible();
}

extern "C" {
// These functions use the C language linkage because they're exposed to Rust
// via the xpcom/rust/moz_task crate, which wraps them in safe Rust functions
// that enable Rust code to get/create threads and dispatch runnables on them.

nsresult NS_GetCurrentThreadEventTarget(nsIEventTarget** aResult) {
  nsCOMPtr<nsIEventTarget> target = mozilla::GetCurrentThreadEventTarget();
  if (!target) {
    return NS_ERROR_UNEXPECTED;
  }
  target.forget(aResult);
  return NS_OK;
}

nsresult NS_GetMainThreadEventTarget(nsIEventTarget** aResult) {
  nsCOMPtr<nsIEventTarget> target = mozilla::GetMainThreadEventTarget();
  if (!target) {
    return NS_ERROR_UNEXPECTED;
  }
  target.forget(aResult);
  return NS_OK;
}

// NS_NewNamedThread's aStackSize parameter has the default argument
// nsIThreadManager::DEFAULT_STACK_SIZE, but we can't omit default arguments
// when calling a C++ function from Rust, and we can't access
// nsIThreadManager::DEFAULT_STACK_SIZE in Rust to pass it explicitly,
// since it is defined in a %{C++ ... %} block within nsIThreadManager.idl.
// So we indirect through this function.
nsresult NS_NewNamedThreadWithDefaultStackSize(const nsACString& aName,
                                               nsIThread** aResult,
                                               nsIRunnable* aEvent) {
  return NS_NewNamedThread(aName, aResult, aEvent);
}

bool NS_IsCurrentThread(nsIEventTarget* aThread) {
  return aThread->IsOnCurrentThread();
}

nsresult NS_DispatchBackgroundTask(nsIRunnable* aEvent,
                                   uint32_t aDispatchFlags) {
  return nsThreadManager::get().DispatchToBackgroundThread(aEvent,
                                                           aDispatchFlags);
}

nsresult NS_CreateBackgroundTaskQueue(const char* aName,
                                      nsISerialEventTarget** aTarget) {
  nsCOMPtr<nsISerialEventTarget> target =
      nsThreadManager::get().CreateBackgroundTaskQueue(aName);
  if (!target) {
    return NS_ERROR_FAILURE;
  }

  target.forget(aTarget);
  return NS_OK;
}

}  // extern "C"
