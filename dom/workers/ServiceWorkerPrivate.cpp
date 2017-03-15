/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ServiceWorkerPrivate.h"

#include "ServiceWorkerManager.h"
#include "nsContentUtils.h"
#include "nsIHttpChannelInternal.h"
#include "nsIHttpHeaderVisitor.h"
#include "nsINetworkInterceptController.h"
#include "nsIPushErrorReporter.h"
#include "nsISupportsImpl.h"
#include "nsIUploadChannel2.h"
#include "nsNetUtil.h"
#include "nsProxyRelease.h"
#include "nsQueryObject.h"
#include "nsStreamUtils.h"
#include "nsStringStream.h"
#include "WorkerRunnable.h"
#include "WorkerScope.h"
#include "mozilla/Assertions.h"
#include "mozilla/dom/FetchUtil.h"
#include "mozilla/dom/IndexedDatabaseManager.h"
#include "mozilla/dom/InternalHeaders.h"
#include "mozilla/dom/NotificationEvent.h"
#include "mozilla/dom/PromiseNativeHandler.h"
#include "mozilla/dom/PushEventBinding.h"
#include "mozilla/dom/RequestBinding.h"
#include "mozilla/Unused.h"

using namespace mozilla;
using namespace mozilla::dom;

BEGIN_WORKERS_NAMESPACE

NS_IMPL_CYCLE_COLLECTING_ADDREF(ServiceWorkerPrivate)
NS_IMPL_CYCLE_COLLECTING_RELEASE(ServiceWorkerPrivate)
NS_IMPL_CYCLE_COLLECTION(ServiceWorkerPrivate, mSupportsArray)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(ServiceWorkerPrivate)
  NS_INTERFACE_MAP_ENTRY(nsISupports)
  NS_INTERFACE_MAP_ENTRY_AMBIGUOUS(nsISupports, nsIObserver)
NS_INTERFACE_MAP_END

// Tracks the "dom.disable_open_click_delay" preference.  Modified on main
// thread, read on worker threads.
// It is updated every time a "notificationclick" event is dispatched. While
// this is done without synchronization, at the worst, the thread will just get
// an older value within which a popup is allowed to be displayed, which will
// still be a valid value since it was set prior to dispatching the runnable.
Atomic<uint32_t> gDOMDisableOpenClickDelay(0);

// Used to keep track of pending waitUntil as well as in-flight extendable events.
// When the last token is released, we attempt to terminate the worker.
class KeepAliveToken final : public nsISupports
{
public:
  NS_DECL_ISUPPORTS

  explicit KeepAliveToken(ServiceWorkerPrivate* aPrivate)
    : mPrivate(aPrivate)
  {
    AssertIsOnMainThread();
    MOZ_ASSERT(aPrivate);
    mPrivate->AddToken();
  }

private:
  ~KeepAliveToken()
  {
    AssertIsOnMainThread();
    mPrivate->ReleaseToken();
  }

  RefPtr<ServiceWorkerPrivate> mPrivate;
};

NS_IMPL_ISUPPORTS0(KeepAliveToken)

ServiceWorkerPrivate::ServiceWorkerPrivate(ServiceWorkerInfo* aInfo)
  : mInfo(aInfo)
  , mDebuggerCount(0)
  , mTokenCount(0)
{
  AssertIsOnMainThread();
  MOZ_ASSERT(aInfo);

  mIdleWorkerTimer = do_CreateInstance(NS_TIMER_CONTRACTID);
  MOZ_ASSERT(mIdleWorkerTimer);
}

ServiceWorkerPrivate::~ServiceWorkerPrivate()
{
  MOZ_ASSERT(!mWorkerPrivate);
  MOZ_ASSERT(!mTokenCount);
  MOZ_ASSERT(!mInfo);
  MOZ_ASSERT(mSupportsArray.IsEmpty());

  mIdleWorkerTimer->Cancel();
}

namespace {

class MessageWaitUntilHandler final : public PromiseNativeHandler
{
 nsMainThreadPtrHandle<nsISupports> mKeepAliveToken;

  ~MessageWaitUntilHandler()
  {
  }

public:
  explicit MessageWaitUntilHandler(const nsMainThreadPtrHandle<nsISupports>& aKeepAliveToken)
    : mKeepAliveToken(aKeepAliveToken)
  {
    MOZ_ASSERT(mKeepAliveToken);
  }

  void
  ResolvedCallback(JSContext* aCx, JS::Handle<JS::Value> aValue) override
  {
    mKeepAliveToken = nullptr;
  }

  void
  RejectedCallback(JSContext* aCx, JS::Handle<JS::Value> aValue) override
  {
    mKeepAliveToken = nullptr;
  }

  NS_DECL_THREADSAFE_ISUPPORTS
};

NS_IMPL_ISUPPORTS0(MessageWaitUntilHandler)

} // anonymous namespace

nsresult
ServiceWorkerPrivate::SendMessageEvent(JSContext* aCx,
                                       JS::Handle<JS::Value> aMessage,
                                       const Optional<Sequence<JS::Value>>& aTransferable,
                                       UniquePtr<ServiceWorkerClientInfo>&& aClientInfo)
{
  ErrorResult rv(SpawnWorkerIfNeeded(MessageEvent, nullptr));
  if (NS_WARN_IF(rv.Failed())) {
    return rv.StealNSResult();
  }

  nsMainThreadPtrHandle<nsISupports> token(
    new nsMainThreadPtrHolder<nsISupports>(CreateEventKeepAliveToken()));

  RefPtr<PromiseNativeHandler> handler = new MessageWaitUntilHandler(token);

  mWorkerPrivate->PostMessageToServiceWorker(aCx, aMessage, aTransferable,
                                             Move(aClientInfo), handler,
                                             rv);
  return rv.StealNSResult();
}

namespace {

class CheckScriptEvaluationWithCallback final : public WorkerRunnable
{
  nsMainThreadPtrHandle<KeepAliveToken> mKeepAliveToken;
  RefPtr<LifeCycleEventCallback> mCallback;
#ifdef DEBUG
  bool mDone;
#endif

public:
  CheckScriptEvaluationWithCallback(WorkerPrivate* aWorkerPrivate,
                                    KeepAliveToken* aKeepAliveToken,
                                    LifeCycleEventCallback* aCallback)
    : WorkerRunnable(aWorkerPrivate)
    , mKeepAliveToken(new nsMainThreadPtrHolder<KeepAliveToken>(aKeepAliveToken))
    , mCallback(aCallback)
#ifdef DEBUG
    , mDone(false)
#endif
  {
    AssertIsOnMainThread();
  }

  ~CheckScriptEvaluationWithCallback()
  {
    MOZ_ASSERT(mDone);
  }

  bool
  WorkerRun(JSContext* aCx, WorkerPrivate* aWorkerPrivate) override
  {
    aWorkerPrivate->AssertIsOnWorkerThread();
    Done(aWorkerPrivate->WorkerScriptExecutedSuccessfully());

    return true;
  }

  nsresult
  Cancel() override
  {
    Done(false);
    return WorkerRunnable::Cancel();
  }

private:
  void
  Done(bool aResult)
  {
#ifdef DEBUG
    mDone = true;
#endif
    mCallback->SetResult(aResult);
    MOZ_ALWAYS_SUCCEEDS(mWorkerPrivate->DispatchToMainThread(mCallback));
  }
};

} // anonymous namespace

nsresult
ServiceWorkerPrivate::CheckScriptEvaluation(LifeCycleEventCallback* aCallback)
{
  nsresult rv = SpawnWorkerIfNeeded(LifeCycleEvent, nullptr);
  NS_ENSURE_SUCCESS(rv, rv);

  RefPtr<KeepAliveToken> token = CreateEventKeepAliveToken();
  RefPtr<WorkerRunnable> r = new CheckScriptEvaluationWithCallback(mWorkerPrivate,
                                                                   token,
                                                                   aCallback);
  if (NS_WARN_IF(!r->Dispatch())) {
    return NS_ERROR_FAILURE;
  }

  return NS_OK;
}

namespace {

// Holds the worker alive until the waitUntil promise is resolved or
// rejected.
class KeepAliveHandler final
{
  // Use an internal class to listen for the promise resolve/reject
  // callbacks.  This class also registers a feature so that it can
  // preemptively cleanup if the service worker is timed out and
  // terminated.
  class InternalHandler final : public PromiseNativeHandler
                              , public WorkerHolder
  {
    nsMainThreadPtrHandle<KeepAliveToken> mKeepAliveToken;

    // Worker thread only
    WorkerPrivate* mWorkerPrivate;
    RefPtr<Promise> mPromise;
    bool mWorkerHolderAdded;

    ~InternalHandler()
    {
      MaybeCleanup();
    }

    bool
    UseWorkerHolder()
    {
      MOZ_ASSERT(mWorkerPrivate);
      mWorkerPrivate->AssertIsOnWorkerThread();
      MOZ_ASSERT(!mWorkerHolderAdded);
      mWorkerHolderAdded = HoldWorker(mWorkerPrivate, Terminating);
      return mWorkerHolderAdded;
    }

    void
    MaybeCleanup()
    {
      MOZ_ASSERT(mWorkerPrivate);
      mWorkerPrivate->AssertIsOnWorkerThread();
      if (!mPromise) {
        return;
      }
      if (mWorkerHolderAdded) {
        ReleaseWorker();
      }
      mPromise = nullptr;
      mKeepAliveToken = nullptr;
    }

    void
    ResolvedCallback(JSContext* aCx, JS::Handle<JS::Value> aValue) override
    {
      MOZ_ASSERT(mWorkerPrivate);
      mWorkerPrivate->AssertIsOnWorkerThread();
      MaybeCleanup();
    }

    void
    RejectedCallback(JSContext* aCx, JS::Handle<JS::Value> aValue) override
    {
      MOZ_ASSERT(mWorkerPrivate);
      mWorkerPrivate->AssertIsOnWorkerThread();
      MaybeCleanup();
    }

    bool
    Notify(Status aStatus) override
    {
      MOZ_ASSERT(mWorkerPrivate);
      mWorkerPrivate->AssertIsOnWorkerThread();
      if (aStatus < Terminating) {
        return true;
      }
      MaybeCleanup();
      return true;
    }

    InternalHandler(const nsMainThreadPtrHandle<KeepAliveToken>& aKeepAliveToken,
                    WorkerPrivate* aWorkerPrivate,
                    Promise* aPromise)
      : mKeepAliveToken(aKeepAliveToken)
      , mWorkerPrivate(aWorkerPrivate)
      , mPromise(aPromise)
      , mWorkerHolderAdded(false)
    {
      MOZ_ASSERT(mKeepAliveToken);
      MOZ_ASSERT(mWorkerPrivate);
      MOZ_ASSERT(mPromise);
    }

  public:
    static already_AddRefed<InternalHandler>
    Create(const nsMainThreadPtrHandle<KeepAliveToken>& aKeepAliveToken,
           WorkerPrivate* aWorkerPrivate,
           Promise* aPromise)
    {
      RefPtr<InternalHandler> ref = new InternalHandler(aKeepAliveToken,
                                                        aWorkerPrivate,
                                                        aPromise);

      if (NS_WARN_IF(!ref->UseWorkerHolder())) {
        return nullptr;
      }

      return ref.forget();
    }

    NS_DECL_ISUPPORTS
  };

  // This is really just a wrapper class to keep the InternalHandler
  // private.  We don't want any code to accidentally call
  // Promise::AppendNativeHandler() without also referencing the promise.
  // Therefore we force all code through the static CreateAndAttachToPromise()
  // and use the private InternalHandler object.
  KeepAliveHandler() = delete;
  ~KeepAliveHandler() = delete;

public:
  // Create a private handler object and attach it to the given Promise.
  // This will also create a strong ref to the Promise in a ref cycle.  The
  // ref cycle is broken when the Promise is fulfilled or the worker thread
  // is Terminated.
  static void
  CreateAndAttachToPromise(const nsMainThreadPtrHandle<KeepAliveToken>& aKeepAliveToken,
                           Promise* aPromise)
  {
    WorkerPrivate* workerPrivate = GetCurrentThreadWorkerPrivate();
    MOZ_ASSERT(workerPrivate);
    workerPrivate->AssertIsOnWorkerThread();
    MOZ_ASSERT(aKeepAliveToken);
    MOZ_ASSERT(aPromise);

    // This creates a strong ref to the promise.
    RefPtr<InternalHandler> handler = InternalHandler::Create(aKeepAliveToken,
                                                              workerPrivate,
                                                              aPromise);
    if (NS_WARN_IF(!handler)) {
      return;
    }

    // This then creates a strong ref cycle between the promise and the
    // handler.  The cycle is broken when the Promise is fulfilled or
    // the worker thread is Terminated.
    aPromise->AppendNativeHandler(handler);
  }
};

NS_IMPL_ISUPPORTS0(KeepAliveHandler::InternalHandler)

class RegistrationUpdateRunnable : public Runnable
{
  nsMainThreadPtrHandle<ServiceWorkerRegistrationInfo> mRegistration;
  const bool mNeedTimeCheck;

public:
  RegistrationUpdateRunnable(nsMainThreadPtrHandle<ServiceWorkerRegistrationInfo>& aRegistration,
                             bool aNeedTimeCheck)
    : mRegistration(aRegistration)
    , mNeedTimeCheck(aNeedTimeCheck)
  {
    MOZ_DIAGNOSTIC_ASSERT(mRegistration);
  }

  NS_IMETHOD
  Run() override
  {
    if (mNeedTimeCheck) {
      mRegistration->MaybeScheduleTimeCheckAndUpdate();
    } else {
      mRegistration->MaybeScheduleUpdate();
    }
    return NS_OK;
  }
};

class ExtendableEventWorkerRunnable : public WorkerRunnable
{
protected:
  nsMainThreadPtrHandle<KeepAliveToken> mKeepAliveToken;

public:
  ExtendableEventWorkerRunnable(WorkerPrivate* aWorkerPrivate,
                                KeepAliveToken* aKeepAliveToken)
    : WorkerRunnable(aWorkerPrivate)
  {
    AssertIsOnMainThread();
    MOZ_ASSERT(aWorkerPrivate);
    MOZ_ASSERT(aKeepAliveToken);

    mKeepAliveToken =
      new nsMainThreadPtrHolder<KeepAliveToken>(aKeepAliveToken);
  }

  bool
  DispatchExtendableEventOnWorkerScope(JSContext* aCx,
                                       WorkerGlobalScope* aWorkerScope,
                                       ExtendableEvent* aEvent,
                                       PromiseNativeHandler* aPromiseHandler)
  {
    MOZ_ASSERT(aWorkerScope);
    MOZ_ASSERT(aEvent);
    nsCOMPtr<nsIGlobalObject> sgo = aWorkerScope;
    WidgetEvent* internalEvent = aEvent->WidgetEventPtr();

    ErrorResult result;
    result = aWorkerScope->DispatchDOMEvent(nullptr, aEvent, nullptr, nullptr);
    if (NS_WARN_IF(result.Failed()) || internalEvent->mFlags.mExceptionWasRaised) {
      result.SuppressException();
      return false;
    }

    RefPtr<Promise> waitUntilPromise = aEvent->GetPromise();
    if (!waitUntilPromise) {
      waitUntilPromise =
        Promise::Resolve(sgo, aCx, JS::UndefinedHandleValue, result);
      MOZ_RELEASE_ASSERT(!result.Failed());
    }

    MOZ_ASSERT(waitUntilPromise);

    // Make sure to append the caller's promise handler before attaching
    // our keep alive handler.  This can avoid terminating the worker
    // before a success result is delivered to the caller in cases where
    // the idle timeout has been set to zero.  This low timeout value is
    // sometimes set in tests.
    if (aPromiseHandler) {
      waitUntilPromise->AppendNativeHandler(aPromiseHandler);
    }

    KeepAliveHandler::CreateAndAttachToPromise(mKeepAliveToken,
                                               waitUntilPromise);

    return true;
  }
};

// Handle functional event
// 9.9.7 If the time difference in seconds calculated by the current time minus
// registration's last update check time is greater than 86400, invoke Soft Update
// algorithm.
class ExtendableFunctionalEventWorkerRunnable : public ExtendableEventWorkerRunnable
{
protected:
  nsMainThreadPtrHandle<ServiceWorkerRegistrationInfo> mRegistration;
public:
  ExtendableFunctionalEventWorkerRunnable(WorkerPrivate* aWorkerPrivate,
                                          KeepAliveToken* aKeepAliveToken,
                                          nsMainThreadPtrHandle<ServiceWorkerRegistrationInfo>& aRegistration)
    : ExtendableEventWorkerRunnable(aWorkerPrivate, aKeepAliveToken)
    , mRegistration(aRegistration)
  {
    MOZ_DIAGNOSTIC_ASSERT(aRegistration);
  }

  void
  PostRun(JSContext* aCx, WorkerPrivate* aWorkerPrivate, bool aRunResult)
  {
    // Sub-class PreRun() or WorkerRun() methods could clear our mRegistration.
    if (mRegistration) {
      nsCOMPtr<nsIRunnable> runnable =
        new RegistrationUpdateRunnable(mRegistration, true /* time check */);
      aWorkerPrivate->DispatchToMainThread(runnable.forget());
    }

    ExtendableEventWorkerRunnable::PostRun(aCx, aWorkerPrivate, aRunResult);
  }
};

/*
 * Fires 'install' event on the ServiceWorkerGlobalScope. Modifies busy count
 * since it fires the event. This is ok since there can't be nested
 * ServiceWorkers, so the parent thread -> worker thread requirement for
 * runnables is satisfied.
 */
class LifecycleEventWorkerRunnable : public ExtendableEventWorkerRunnable
{
  nsString mEventName;
  RefPtr<LifeCycleEventCallback> mCallback;

public:
  LifecycleEventWorkerRunnable(WorkerPrivate* aWorkerPrivate,
                               KeepAliveToken* aToken,
                               const nsAString& aEventName,
                               LifeCycleEventCallback* aCallback)
      : ExtendableEventWorkerRunnable(aWorkerPrivate, aToken)
      , mEventName(aEventName)
      , mCallback(aCallback)
  {
    AssertIsOnMainThread();
  }

  bool
  WorkerRun(JSContext* aCx, WorkerPrivate* aWorkerPrivate) override
  {
    MOZ_ASSERT(aWorkerPrivate);
    return DispatchLifecycleEvent(aCx, aWorkerPrivate);
  }

  nsresult
  Cancel() override
  {
    mCallback->SetResult(false);
    MOZ_ALWAYS_SUCCEEDS(mWorkerPrivate->DispatchToMainThread(mCallback));

    return WorkerRunnable::Cancel();
  }

private:
  bool
  DispatchLifecycleEvent(JSContext* aCx, WorkerPrivate* aWorkerPrivate);

};

/*
 * Used to handle ExtendableEvent::waitUntil() and catch abnormal worker
 * termination during the execution of life cycle events. It is responsible
 * with advancing the job queue for install/activate tasks.
 */
class LifeCycleEventWatcher final : public PromiseNativeHandler,
                                    public WorkerHolder
{
  WorkerPrivate* mWorkerPrivate;
  RefPtr<LifeCycleEventCallback> mCallback;
  bool mDone;

  ~LifeCycleEventWatcher()
  {
    if (mDone) {
      return;
    }

    MOZ_ASSERT(GetCurrentThreadWorkerPrivate() == mWorkerPrivate);
    // XXXcatalinb: If all the promises passed to waitUntil go out of scope,
    // the resulting Promise.all will be cycle collected and it will drop its
    // native handlers (including this object). Instead of waiting for a timeout
    // we report the failure now.
    ReportResult(false);
  }

public:
  NS_DECL_ISUPPORTS

  LifeCycleEventWatcher(WorkerPrivate* aWorkerPrivate,
                        LifeCycleEventCallback* aCallback)
    : mWorkerPrivate(aWorkerPrivate)
    , mCallback(aCallback)
    , mDone(false)
  {
    MOZ_ASSERT(aWorkerPrivate);
    aWorkerPrivate->AssertIsOnWorkerThread();
  }

  bool
  Init()
  {
    MOZ_ASSERT(mWorkerPrivate);
    mWorkerPrivate->AssertIsOnWorkerThread();

    // We need to listen for worker termination in case the event handler
    // never completes or never resolves the waitUntil promise. There are
    // two possible scenarios:
    // 1. The keepAlive token expires and the worker is terminated, in which
    //    case the registration/update promise will be rejected
    // 2. A new service worker is registered which will terminate the current
    //    installing worker.
    if (NS_WARN_IF(!HoldWorker(mWorkerPrivate, Terminating))) {
      NS_WARNING("LifeCycleEventWatcher failed to add feature.");
      ReportResult(false);
      return false;
    }

    return true;
  }

  bool
  Notify(Status aStatus) override
  {
    if (aStatus < Terminating) {
      return true;
    }

    MOZ_ASSERT(GetCurrentThreadWorkerPrivate() == mWorkerPrivate);
    ReportResult(false);

    return true;
  }

  void
  ReportResult(bool aResult)
  {
    mWorkerPrivate->AssertIsOnWorkerThread();

    if (mDone) {
      return;
    }
    mDone = true;

    mCallback->SetResult(aResult);
    nsresult rv = mWorkerPrivate->DispatchToMainThread(mCallback);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      NS_RUNTIMEABORT("Failed to dispatch life cycle event handler.");
    }

    ReleaseWorker();
  }

  void
  ResolvedCallback(JSContext* aCx, JS::Handle<JS::Value> aValue) override
  {
    MOZ_ASSERT(GetCurrentThreadWorkerPrivate() == mWorkerPrivate);
    mWorkerPrivate->AssertIsOnWorkerThread();

    ReportResult(true);
  }

  void
  RejectedCallback(JSContext* aCx, JS::Handle<JS::Value> aValue) override
  {
    MOZ_ASSERT(GetCurrentThreadWorkerPrivate() == mWorkerPrivate);
    mWorkerPrivate->AssertIsOnWorkerThread();

    ReportResult(false);

    // Note, all WaitUntil() rejections are reported to client consoles
    // by the WaitUntilHandler in ServiceWorkerEvents.  This ensures that
    // errors in non-lifecycle events like FetchEvent and PushEvent are
    // reported properly.
  }
};

NS_IMPL_ISUPPORTS0(LifeCycleEventWatcher)

bool
LifecycleEventWorkerRunnable::DispatchLifecycleEvent(JSContext* aCx,
                                                     WorkerPrivate* aWorkerPrivate)
{
  aWorkerPrivate->AssertIsOnWorkerThread();
  MOZ_ASSERT(aWorkerPrivate->IsServiceWorker());

  RefPtr<ExtendableEvent> event;
  RefPtr<EventTarget> target = aWorkerPrivate->GlobalScope();

  if (mEventName.EqualsASCII("install") || mEventName.EqualsASCII("activate")) {
    ExtendableEventInit init;
    init.mBubbles = false;
    init.mCancelable = false;
    event = ExtendableEvent::Constructor(target, mEventName, init);
  } else {
    MOZ_CRASH("Unexpected lifecycle event");
  }

  event->SetTrusted(true);

  // It is important to initialize the watcher before actually dispatching
  // the event in order to catch worker termination while the event handler
  // is still executing. This can happen with infinite loops, for example.
  RefPtr<LifeCycleEventWatcher> watcher =
    new LifeCycleEventWatcher(aWorkerPrivate, mCallback);

  if (!watcher->Init()) {
    return true;
  }

  if (!DispatchExtendableEventOnWorkerScope(aCx, aWorkerPrivate->GlobalScope(),
                                       event, watcher)) {
    watcher->ReportResult(false);
  }

  return true;
}

} // anonymous namespace

nsresult
ServiceWorkerPrivate::SendLifeCycleEvent(const nsAString& aEventType,
                                         LifeCycleEventCallback* aCallback,
                                         nsIRunnable* aLoadFailure)
{
  nsresult rv = SpawnWorkerIfNeeded(LifeCycleEvent, aLoadFailure);
  NS_ENSURE_SUCCESS(rv, rv);

  RefPtr<KeepAliveToken> token = CreateEventKeepAliveToken();
  RefPtr<WorkerRunnable> r = new LifecycleEventWorkerRunnable(mWorkerPrivate,
                                                              token,
                                                              aEventType,
                                                              aCallback);
  if (NS_WARN_IF(!r->Dispatch())) {
    return NS_ERROR_FAILURE;
  }

  return NS_OK;
}

namespace {

class PushErrorReporter final : public PromiseNativeHandler
{
  WorkerPrivate* mWorkerPrivate;
  nsString mMessageId;

  ~PushErrorReporter()
  {
  }

public:
  NS_DECL_THREADSAFE_ISUPPORTS

  PushErrorReporter(WorkerPrivate* aWorkerPrivate,
                    const nsAString& aMessageId)
    : mWorkerPrivate(aWorkerPrivate)
    , mMessageId(aMessageId)
  {
    mWorkerPrivate->AssertIsOnWorkerThread();
  }

  void ResolvedCallback(JSContext* aCx, JS::Handle<JS::Value> aValue) override
  {
    mWorkerPrivate->AssertIsOnWorkerThread();
    mWorkerPrivate = nullptr;
    // Do nothing; we only use this to report errors to the Push service.
  }

  void RejectedCallback(JSContext* aCx, JS::Handle<JS::Value> aValue) override
  {
    Report(nsIPushErrorReporter::DELIVERY_UNHANDLED_REJECTION);
  }

  void Report(uint16_t aReason = nsIPushErrorReporter::DELIVERY_INTERNAL_ERROR)
  {
    WorkerPrivate* workerPrivate = mWorkerPrivate;
    mWorkerPrivate->AssertIsOnWorkerThread();
    mWorkerPrivate = nullptr;

    if (NS_WARN_IF(aReason > nsIPushErrorReporter::DELIVERY_INTERNAL_ERROR) ||
        mMessageId.IsEmpty()) {
      return;
    }
    nsCOMPtr<nsIRunnable> runnable =
      NewRunnableMethod<uint16_t>(this,
        &PushErrorReporter::ReportOnMainThread, aReason);
    MOZ_ALWAYS_TRUE(NS_SUCCEEDED(
      workerPrivate->DispatchToMainThread(runnable.forget())));
  }

  void ReportOnMainThread(uint16_t aReason)
  {
    AssertIsOnMainThread();
    nsCOMPtr<nsIPushErrorReporter> reporter =
      do_GetService("@mozilla.org/push/Service;1");
    if (reporter) {
      nsresult rv = reporter->ReportDeliveryError(mMessageId, aReason);
      Unused << NS_WARN_IF(NS_FAILED(rv));
    }
  }
};

NS_IMPL_ISUPPORTS0(PushErrorReporter)

class SendPushEventRunnable final : public ExtendableFunctionalEventWorkerRunnable
{
  nsString mMessageId;
  Maybe<nsTArray<uint8_t>> mData;

public:
  SendPushEventRunnable(WorkerPrivate* aWorkerPrivate,
                        KeepAliveToken* aKeepAliveToken,
                        const nsAString& aMessageId,
                        const Maybe<nsTArray<uint8_t>>& aData,
                        nsMainThreadPtrHandle<ServiceWorkerRegistrationInfo> aRegistration)
      : ExtendableFunctionalEventWorkerRunnable(
          aWorkerPrivate, aKeepAliveToken, aRegistration)
      , mMessageId(aMessageId)
      , mData(aData)
  {
    AssertIsOnMainThread();
    MOZ_ASSERT(aWorkerPrivate);
    MOZ_ASSERT(aWorkerPrivate->IsServiceWorker());
  }

  bool
  WorkerRun(JSContext* aCx, WorkerPrivate* aWorkerPrivate) override
  {
    MOZ_ASSERT(aWorkerPrivate);
    GlobalObject globalObj(aCx, aWorkerPrivate->GlobalScope()->GetWrapper());

    RefPtr<PushErrorReporter> errorReporter =
      new PushErrorReporter(aWorkerPrivate, mMessageId);

    PushEventInit pei;
    if (mData) {
      const nsTArray<uint8_t>& bytes = mData.ref();
      JSObject* data = Uint8Array::Create(aCx, bytes.Length(), bytes.Elements());
      if (!data) {
        errorReporter->Report();
        return false;
      }
      pei.mData.Construct().SetAsArrayBufferView().Init(data);
    }
    pei.mBubbles = false;
    pei.mCancelable = false;

    ErrorResult result;
    RefPtr<PushEvent> event =
      PushEvent::Constructor(globalObj, NS_LITERAL_STRING("push"), pei, result);
    if (NS_WARN_IF(result.Failed())) {
      result.SuppressException();
      errorReporter->Report();
      return false;
    }
    event->SetTrusted(true);

    if (!DispatchExtendableEventOnWorkerScope(aCx, aWorkerPrivate->GlobalScope(),
                                              event, errorReporter)) {
      errorReporter->Report(nsIPushErrorReporter::DELIVERY_UNCAUGHT_EXCEPTION);
    }

    return true;
  }
};

class SendPushSubscriptionChangeEventRunnable final : public ExtendableEventWorkerRunnable
{

public:
  explicit SendPushSubscriptionChangeEventRunnable(
    WorkerPrivate* aWorkerPrivate, KeepAliveToken* aKeepAliveToken)
      : ExtendableEventWorkerRunnable(aWorkerPrivate, aKeepAliveToken)
  {
    AssertIsOnMainThread();
    MOZ_ASSERT(aWorkerPrivate);
    MOZ_ASSERT(aWorkerPrivate->IsServiceWorker());
  }

  bool
  WorkerRun(JSContext* aCx, WorkerPrivate* aWorkerPrivate) override
  {
    MOZ_ASSERT(aWorkerPrivate);

    RefPtr<EventTarget> target = aWorkerPrivate->GlobalScope();

    ExtendableEventInit init;
    init.mBubbles = false;
    init.mCancelable = false;

    RefPtr<ExtendableEvent> event =
      ExtendableEvent::Constructor(target,
                                   NS_LITERAL_STRING("pushsubscriptionchange"),
                                   init);

    event->SetTrusted(true);

    DispatchExtendableEventOnWorkerScope(aCx, aWorkerPrivate->GlobalScope(),
                                         event, nullptr);

    return true;
  }
};

} // anonymous namespace

nsresult
ServiceWorkerPrivate::SendPushEvent(const nsAString& aMessageId,
                                    const Maybe<nsTArray<uint8_t>>& aData,
                                    ServiceWorkerRegistrationInfo* aRegistration)
{
  nsresult rv = SpawnWorkerIfNeeded(PushEvent, nullptr);
  NS_ENSURE_SUCCESS(rv, rv);

  RefPtr<KeepAliveToken> token = CreateEventKeepAliveToken();

  nsMainThreadPtrHandle<ServiceWorkerRegistrationInfo> regInfo(
    new nsMainThreadPtrHolder<ServiceWorkerRegistrationInfo>(aRegistration, false));

  RefPtr<WorkerRunnable> r = new SendPushEventRunnable(mWorkerPrivate,
                                                       token,
                                                       aMessageId,
                                                       aData,
                                                       regInfo);

  if (mInfo->State() == ServiceWorkerState::Activating) {
    mPendingFunctionalEvents.AppendElement(r.forget());
    return NS_OK;
  }

  MOZ_ASSERT(mInfo->State() == ServiceWorkerState::Activated);

  if (NS_WARN_IF(!r->Dispatch())) {
    return NS_ERROR_FAILURE;
  }

  return NS_OK;
}

nsresult
ServiceWorkerPrivate::SendPushSubscriptionChangeEvent()
{
  nsresult rv = SpawnWorkerIfNeeded(PushSubscriptionChangeEvent, nullptr);
  NS_ENSURE_SUCCESS(rv, rv);

  RefPtr<KeepAliveToken> token = CreateEventKeepAliveToken();
  RefPtr<WorkerRunnable> r =
    new SendPushSubscriptionChangeEventRunnable(mWorkerPrivate, token);
  if (NS_WARN_IF(!r->Dispatch())) {
    return NS_ERROR_FAILURE;
  }

  return NS_OK;
}

namespace {

static void
DummyNotificationTimerCallback(nsITimer* aTimer, void* aClosure)
{
  // Nothing.
}

class AllowWindowInteractionHandler;

class ClearWindowAllowedRunnable final : public WorkerRunnable
{
public:
  ClearWindowAllowedRunnable(WorkerPrivate* aWorkerPrivate,
                             AllowWindowInteractionHandler* aHandler)
  : WorkerRunnable(aWorkerPrivate, WorkerThreadUnchangedBusyCount)
  , mHandler(aHandler)
  { }

private:
  bool
  PreDispatch(WorkerPrivate* aWorkerPrivate) override
  {
    // WorkerRunnable asserts that the dispatch is from parent thread if
    // the busy count modification is WorkerThreadUnchangedBusyCount.
    // Since this runnable will be dispatched from the timer thread, we override
    // PreDispatch and PostDispatch to skip the check.
    return true;
  }

  void
  PostDispatch(WorkerPrivate* aWorkerPrivate, bool aDispatchResult) override
  {
    // Silence bad assertions.
  }

  bool
  WorkerRun(JSContext* aCx, WorkerPrivate* aWorkerPrivate) override;

  nsresult
  Cancel() override
  {
    // Always ensure the handler is released on the worker thread, even if we
    // are cancelled.
    mHandler = nullptr;
    return WorkerRunnable::Cancel();
  }

  RefPtr<AllowWindowInteractionHandler> mHandler;
};

class AllowWindowInteractionHandler final : public PromiseNativeHandler
{
  friend class ClearWindowAllowedRunnable;
  nsCOMPtr<nsITimer> mTimer;

  ~AllowWindowInteractionHandler()
  {
  }

  void
  ClearWindowAllowed(WorkerPrivate* aWorkerPrivate)
  {
    MOZ_ASSERT(aWorkerPrivate);
    aWorkerPrivate->AssertIsOnWorkerThread();

    if (!mTimer) {
      return;
    }

    // XXXcatalinb: This *might* be executed after the global was unrooted, in
    // which case GlobalScope() will return null. Making the check here just
    // to be safe.
    WorkerGlobalScope* globalScope = aWorkerPrivate->GlobalScope();
    if (!globalScope) {
      return;
    }

    globalScope->ConsumeWindowInteraction();
    mTimer->Cancel();
    mTimer = nullptr;
    MOZ_ALWAYS_TRUE(aWorkerPrivate->ModifyBusyCountFromWorker(false));
  }

  void
  StartClearWindowTimer(WorkerPrivate* aWorkerPrivate)
  {
    MOZ_ASSERT(aWorkerPrivate);
    aWorkerPrivate->AssertIsOnWorkerThread();
    MOZ_ASSERT(!mTimer);

    nsresult rv;
    nsCOMPtr<nsITimer> timer = do_CreateInstance(NS_TIMER_CONTRACTID, &rv);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return;
    }

    RefPtr<ClearWindowAllowedRunnable> r =
      new ClearWindowAllowedRunnable(aWorkerPrivate, this);

    RefPtr<TimerThreadEventTarget> target =
      new TimerThreadEventTarget(aWorkerPrivate, r);

    rv = timer->SetTarget(target);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return;
    }

    // The important stuff that *has* to be reversed.
    if (NS_WARN_IF(!aWorkerPrivate->ModifyBusyCountFromWorker(true))) {
      return;
    }
    aWorkerPrivate->GlobalScope()->AllowWindowInteraction();
    timer.swap(mTimer);

    // We swap first and then initialize the timer so that even if initializing
    // fails, we still clean the busy count and interaction count correctly.
    // The timer can't be initialized before modifying the busy count since the
    // timer thread could run and call the timeout but the worker may
    // already be terminating and modifying the busy count could fail.
    rv = mTimer->InitWithFuncCallback(DummyNotificationTimerCallback, nullptr,
                                      gDOMDisableOpenClickDelay,
                                      nsITimer::TYPE_ONE_SHOT);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      ClearWindowAllowed(aWorkerPrivate);
      return;
    }
  }

public:
  NS_DECL_ISUPPORTS

  explicit AllowWindowInteractionHandler(WorkerPrivate* aWorkerPrivate)
  {
    StartClearWindowTimer(aWorkerPrivate);
  }

  void
  ResolvedCallback(JSContext* aCx, JS::Handle<JS::Value> aValue) override
  {
    WorkerPrivate* workerPrivate = GetWorkerPrivateFromContext(aCx);
    ClearWindowAllowed(workerPrivate);
  }

  void
  RejectedCallback(JSContext* aCx, JS::Handle<JS::Value> aValue) override
  {
    WorkerPrivate* workerPrivate = GetWorkerPrivateFromContext(aCx);
    ClearWindowAllowed(workerPrivate);
  }
};

NS_IMPL_ISUPPORTS0(AllowWindowInteractionHandler)

bool
ClearWindowAllowedRunnable::WorkerRun(JSContext* aCx, WorkerPrivate* aWorkerPrivate)
{
  mHandler->ClearWindowAllowed(aWorkerPrivate);
  mHandler = nullptr;
  return true;
}

class SendNotificationEventRunnable final : public ExtendableEventWorkerRunnable
{
  const nsString mEventName;
  const nsString mID;
  const nsString mTitle;
  const nsString mDir;
  const nsString mLang;
  const nsString mBody;
  const nsString mTag;
  const nsString mIcon;
  const nsString mData;
  const nsString mBehavior;
  const nsString mScope;

public:
  SendNotificationEventRunnable(WorkerPrivate* aWorkerPrivate,
                                KeepAliveToken* aKeepAliveToken,
                                const nsAString& aEventName,
                                const nsAString& aID,
                                const nsAString& aTitle,
                                const nsAString& aDir,
                                const nsAString& aLang,
                                const nsAString& aBody,
                                const nsAString& aTag,
                                const nsAString& aIcon,
                                const nsAString& aData,
                                const nsAString& aBehavior,
                                const nsAString& aScope)
      : ExtendableEventWorkerRunnable(aWorkerPrivate, aKeepAliveToken)
      , mEventName(aEventName)
      , mID(aID)
      , mTitle(aTitle)
      , mDir(aDir)
      , mLang(aLang)
      , mBody(aBody)
      , mTag(aTag)
      , mIcon(aIcon)
      , mData(aData)
      , mBehavior(aBehavior)
      , mScope(aScope)
  {
    AssertIsOnMainThread();
    MOZ_ASSERT(aWorkerPrivate);
    MOZ_ASSERT(aWorkerPrivate->IsServiceWorker());
  }

  bool
  WorkerRun(JSContext* aCx, WorkerPrivate* aWorkerPrivate) override
  {
    MOZ_ASSERT(aWorkerPrivate);

    RefPtr<EventTarget> target = do_QueryObject(aWorkerPrivate->GlobalScope());

    ErrorResult result;
    RefPtr<Notification> notification =
      Notification::ConstructFromFields(aWorkerPrivate->GlobalScope(), mID,
                                        mTitle, mDir, mLang, mBody, mTag, mIcon,
                                        mData, mScope, result);
    if (NS_WARN_IF(result.Failed())) {
      return false;
    }

    NotificationEventInit nei;
    nei.mNotification = notification;
    nei.mBubbles = false;
    nei.mCancelable = false;

    RefPtr<NotificationEvent> event =
      NotificationEvent::Constructor(target, mEventName,
                                     nei, result);
    if (NS_WARN_IF(result.Failed())) {
      return false;
    }

    event->SetTrusted(true);
    aWorkerPrivate->GlobalScope()->AllowWindowInteraction();
    RefPtr<AllowWindowInteractionHandler> allowWindowInteraction =
      new AllowWindowInteractionHandler(aWorkerPrivate);
    if (!DispatchExtendableEventOnWorkerScope(aCx, aWorkerPrivate->GlobalScope(),
                                              event, allowWindowInteraction)) {
      allowWindowInteraction->RejectedCallback(aCx, JS::UndefinedHandleValue);
    }
    aWorkerPrivate->GlobalScope()->ConsumeWindowInteraction();

    return true;
  }
};

} // namespace anonymous

nsresult
ServiceWorkerPrivate::SendNotificationEvent(const nsAString& aEventName,
                                            const nsAString& aID,
                                            const nsAString& aTitle,
                                            const nsAString& aDir,
                                            const nsAString& aLang,
                                            const nsAString& aBody,
                                            const nsAString& aTag,
                                            const nsAString& aIcon,
                                            const nsAString& aData,
                                            const nsAString& aBehavior,
                                            const nsAString& aScope)
{
  WakeUpReason why;
  if (aEventName.EqualsLiteral(NOTIFICATION_CLICK_EVENT_NAME)) {
    why = NotificationClickEvent;
    gDOMDisableOpenClickDelay = Preferences::GetInt("dom.disable_open_click_delay");
  } else if (aEventName.EqualsLiteral(NOTIFICATION_CLOSE_EVENT_NAME)) {
    why = NotificationCloseEvent;
  } else {
    MOZ_ASSERT_UNREACHABLE("Invalid notification event name");
    return NS_ERROR_FAILURE;
  }

  nsresult rv = SpawnWorkerIfNeeded(why, nullptr);
  NS_ENSURE_SUCCESS(rv, rv);

  RefPtr<KeepAliveToken> token = CreateEventKeepAliveToken();

  RefPtr<WorkerRunnable> r =
    new SendNotificationEventRunnable(mWorkerPrivate, token,
                                      aEventName, aID, aTitle, aDir, aLang,
                                      aBody, aTag, aIcon, aData, aBehavior,
                                      aScope);
  if (NS_WARN_IF(!r->Dispatch())) {
    return NS_ERROR_FAILURE;
  }

  return NS_OK;
}

namespace {

// Inheriting ExtendableEventWorkerRunnable so that the worker is not terminated
// while handling the fetch event, though that's very unlikely.
class FetchEventRunnable : public ExtendableFunctionalEventWorkerRunnable
                         , public nsIHttpHeaderVisitor {
  nsMainThreadPtrHandle<nsIInterceptedChannel> mInterceptedChannel;
  const nsCString mScriptSpec;
  nsTArray<nsCString> mHeaderNames;
  nsTArray<nsCString> mHeaderValues;
  nsCString mSpec;
  nsCString mFragment;
  nsCString mMethod;
  nsString mClientId;
  bool mIsReload;
  RequestCache mCacheMode;
  RequestMode mRequestMode;
  RequestRedirect mRequestRedirect;
  RequestCredentials mRequestCredentials;
  nsContentPolicyType mContentPolicyType;
  nsCOMPtr<nsIInputStream> mUploadStream;
  nsCString mReferrer;
  ReferrerPolicy mReferrerPolicy;
  nsString mIntegrity;
public:
  FetchEventRunnable(WorkerPrivate* aWorkerPrivate,
                     KeepAliveToken* aKeepAliveToken,
                     nsMainThreadPtrHandle<nsIInterceptedChannel>& aChannel,
                     // CSP checks might require the worker script spec
                     // later on.
                     const nsACString& aScriptSpec,
                     nsMainThreadPtrHandle<ServiceWorkerRegistrationInfo>& aRegistration,
                     const nsAString& aDocumentId,
                     bool aIsReload)
    : ExtendableFunctionalEventWorkerRunnable(
        aWorkerPrivate, aKeepAliveToken, aRegistration)
    , mInterceptedChannel(aChannel)
    , mScriptSpec(aScriptSpec)
    , mClientId(aDocumentId)
    , mIsReload(aIsReload)
    , mCacheMode(RequestCache::Default)
    , mRequestMode(RequestMode::No_cors)
    , mRequestRedirect(RequestRedirect::Follow)
    // By default we set it to same-origin since normal HTTP fetches always
    // send credentials to same-origin websites unless explicitly forbidden.
    , mRequestCredentials(RequestCredentials::Same_origin)
    , mContentPolicyType(nsIContentPolicy::TYPE_INVALID)
    , mReferrer(kFETCH_CLIENT_REFERRER_STR)
    , mReferrerPolicy(ReferrerPolicy::_empty)
  {
    MOZ_ASSERT(aWorkerPrivate);
  }

  NS_DECL_ISUPPORTS_INHERITED

  NS_IMETHOD
  VisitHeader(const nsACString& aHeader, const nsACString& aValue) override
  {
    mHeaderNames.AppendElement(aHeader);
    mHeaderValues.AppendElement(aValue);
    return NS_OK;
  }

  nsresult
  Init()
  {
    AssertIsOnMainThread();
    nsCOMPtr<nsIChannel> channel;
    nsresult rv = mInterceptedChannel->GetChannel(getter_AddRefs(channel));
    NS_ENSURE_SUCCESS(rv, rv);

    nsCOMPtr<nsIURI> uri;
    rv = mInterceptedChannel->GetSecureUpgradedChannelURI(getter_AddRefs(uri));
    NS_ENSURE_SUCCESS(rv, rv);

    // Normally we rely on the Request constructor to strip the fragment, but
    // when creating the FetchEvent we bypass the constructor.  So strip the
    // fragment manually here instead.  We can't do it later when we create
    // the Request because that code executes off the main thread.
    nsCOMPtr<nsIURI> uriNoFragment;
    rv = uri->CloneIgnoringRef(getter_AddRefs(uriNoFragment));
    NS_ENSURE_SUCCESS(rv, rv);
    rv = uriNoFragment->GetSpec(mSpec);
    NS_ENSURE_SUCCESS(rv, rv);
    rv = uri->GetRef(mFragment);
    NS_ENSURE_SUCCESS(rv, rv);

    uint32_t loadFlags;
    rv = channel->GetLoadFlags(&loadFlags);
    NS_ENSURE_SUCCESS(rv, rv);
    nsCOMPtr<nsILoadInfo> loadInfo;
    rv = channel->GetLoadInfo(getter_AddRefs(loadInfo));
    NS_ENSURE_SUCCESS(rv, rv);
    mContentPolicyType = loadInfo->InternalContentPolicyType();

    nsCOMPtr<nsIHttpChannel> httpChannel = do_QueryInterface(channel);
    MOZ_ASSERT(httpChannel, "How come we don't have an HTTP channel?");

    nsAutoCString referrer;
    // Ignore the return value since the Referer header may not exist.
    httpChannel->GetRequestHeader(NS_LITERAL_CSTRING("Referer"), referrer);
    if (!referrer.IsEmpty()) {
      mReferrer = referrer;
    }

    uint32_t referrerPolicy = 0;
    rv = httpChannel->GetReferrerPolicy(&referrerPolicy);
    NS_ENSURE_SUCCESS(rv, rv);
    switch (referrerPolicy) {
    case nsIHttpChannel::REFERRER_POLICY_NO_REFERRER:
      mReferrerPolicy = ReferrerPolicy::No_referrer;
      break;
    case nsIHttpChannel::REFERRER_POLICY_ORIGIN:
      mReferrerPolicy = ReferrerPolicy::Origin;
      break;
    case nsIHttpChannel::REFERRER_POLICY_NO_REFERRER_WHEN_DOWNGRADE:
      mReferrerPolicy = ReferrerPolicy::No_referrer_when_downgrade;
      break;
    case nsIHttpChannel::REFERRER_POLICY_ORIGIN_WHEN_XORIGIN:
      mReferrerPolicy = ReferrerPolicy::Origin_when_cross_origin;
      break;
    case nsIHttpChannel::REFERRER_POLICY_UNSAFE_URL:
      mReferrerPolicy = ReferrerPolicy::Unsafe_url;
      break;
    default:
      MOZ_ASSERT_UNREACHABLE("Invalid Referrer Policy enum value?");
      break;
    }

    rv = httpChannel->GetRequestMethod(mMethod);
    NS_ENSURE_SUCCESS(rv, rv);

    nsCOMPtr<nsIHttpChannelInternal> internalChannel = do_QueryInterface(httpChannel);
    NS_ENSURE_TRUE(internalChannel, NS_ERROR_NOT_AVAILABLE);

    mRequestMode = InternalRequest::MapChannelToRequestMode(channel);

    // This is safe due to static_asserts in ServiceWorkerManager.cpp.
    uint32_t redirectMode;
    internalChannel->GetRedirectMode(&redirectMode);
    mRequestRedirect = static_cast<RequestRedirect>(redirectMode);

    // This is safe due to static_asserts in ServiceWorkerManager.cpp.
    uint32_t cacheMode;
    internalChannel->GetFetchCacheMode(&cacheMode);
    mCacheMode = static_cast<RequestCache>(cacheMode);

    internalChannel->GetIntegrityMetadata(mIntegrity);

    mRequestCredentials = InternalRequest::MapChannelToRequestCredentials(channel);

    rv = httpChannel->VisitNonDefaultRequestHeaders(this);
    NS_ENSURE_SUCCESS(rv, rv);

    nsCOMPtr<nsIUploadChannel2> uploadChannel = do_QueryInterface(httpChannel);
    if (uploadChannel) {
      MOZ_ASSERT(!mUploadStream);
      bool bodyHasHeaders = false;
      rv = uploadChannel->GetUploadStreamHasHeaders(&bodyHasHeaders);
      NS_ENSURE_SUCCESS(rv, rv);
      nsCOMPtr<nsIInputStream> uploadStream;
      rv = uploadChannel->CloneUploadStream(getter_AddRefs(uploadStream));
      NS_ENSURE_SUCCESS(rv, rv);
      if (bodyHasHeaders) {
        HandleBodyWithHeaders(uploadStream);
      } else {
        mUploadStream = uploadStream;
      }
    }

    return NS_OK;
  }

  bool
  WorkerRun(JSContext* aCx, WorkerPrivate* aWorkerPrivate) override
  {
    MOZ_ASSERT(aWorkerPrivate);
    return DispatchFetchEvent(aCx, aWorkerPrivate);
  }

  nsresult
  Cancel() override
  {
    nsCOMPtr<nsIRunnable> runnable = new ResumeRequest(mInterceptedChannel);
    if (NS_FAILED(mWorkerPrivate->DispatchToMainThread(runnable))) {
      NS_WARNING("Failed to resume channel on FetchEventRunnable::Cancel()!\n");
    }
    WorkerRunnable::Cancel();
    return NS_OK;
  }

private:
  ~FetchEventRunnable() {}

  class ResumeRequest final : public Runnable {
    nsMainThreadPtrHandle<nsIInterceptedChannel> mChannel;
  public:
    explicit ResumeRequest(nsMainThreadPtrHandle<nsIInterceptedChannel>& aChannel)
      : mChannel(aChannel)
    {
    }

    NS_IMETHOD Run() override
    {
      AssertIsOnMainThread();
      nsresult rv = mChannel->ResetInterception();
      NS_WARNING_ASSERTION(NS_SUCCEEDED(rv),
                           "Failed to resume intercepted network request");
      return rv;
    }
  };

  bool
  DispatchFetchEvent(JSContext* aCx, WorkerPrivate* aWorkerPrivate)
  {
    MOZ_ASSERT(aCx);
    MOZ_ASSERT(aWorkerPrivate);
    MOZ_ASSERT(aWorkerPrivate->IsServiceWorker());
    GlobalObject globalObj(aCx, aWorkerPrivate->GlobalScope()->GetWrapper());

    RefPtr<InternalHeaders> internalHeaders = new InternalHeaders(HeadersGuardEnum::Request);
    MOZ_ASSERT(mHeaderNames.Length() == mHeaderValues.Length());
    for (uint32_t i = 0; i < mHeaderNames.Length(); i++) {
      ErrorResult result;
      internalHeaders->Set(mHeaderNames[i], mHeaderValues[i], result);
      if (NS_WARN_IF(result.Failed())) {
        result.SuppressException();
        return false;
      }
    }

    ErrorResult result;
    internalHeaders->SetGuard(HeadersGuardEnum::Immutable, result);
    if (NS_WARN_IF(result.Failed())) {
      result.SuppressException();
      return false;
    }
    RefPtr<InternalRequest> internalReq = new InternalRequest(mSpec,
                                                              mFragment,
                                                              mMethod,
                                                              internalHeaders.forget(),
                                                              mCacheMode,
                                                              mRequestMode,
                                                              mRequestRedirect,
                                                              mRequestCredentials,
                                                              NS_ConvertUTF8toUTF16(mReferrer),
                                                              mReferrerPolicy,
                                                              mContentPolicyType,
                                                              mIntegrity);
    internalReq->SetBody(mUploadStream);
    // For Telemetry, note that this Request object was created by a Fetch event.
    internalReq->SetCreatedByFetchEvent();

    nsCOMPtr<nsIGlobalObject> global = do_QueryInterface(globalObj.GetAsSupports());
    if (NS_WARN_IF(!global)) {
      return false;
    }
    RefPtr<Request> request = new Request(global, internalReq);

    MOZ_ASSERT_IF(internalReq->IsNavigationRequest(),
                  request->Redirect() == RequestRedirect::Manual);

    RootedDictionary<FetchEventInit> init(aCx);
    init.mRequest = request;
    init.mBubbles = false;
    init.mCancelable = true;
    if (!mClientId.IsEmpty()) {
      init.mClientId = mClientId;
    }
    init.mIsReload = mIsReload;
    RefPtr<FetchEvent> event =
      FetchEvent::Constructor(globalObj, NS_LITERAL_STRING("fetch"), init, result);
    if (NS_WARN_IF(result.Failed())) {
      result.SuppressException();
      return false;
    }

    event->PostInit(mInterceptedChannel, mRegistration, mScriptSpec);
    event->SetTrusted(true);

    RefPtr<EventTarget> target = do_QueryObject(aWorkerPrivate->GlobalScope());
    nsresult rv2 = target->DispatchDOMEvent(nullptr, event, nullptr, nullptr);
    if (NS_WARN_IF(NS_FAILED(rv2)) || !event->WaitToRespond()) {
      nsCOMPtr<nsIRunnable> runnable;
      if (event->DefaultPrevented(aCx)) {
        event->ReportCanceled();
      } else if (event->WidgetEventPtr()->mFlags.mExceptionWasRaised) {
        // Exception logged via the WorkerPrivate ErrorReporter
      } else {
        runnable = new ResumeRequest(mInterceptedChannel);
      }

      if (!runnable) {
        runnable = new CancelChannelRunnable(mInterceptedChannel,
                                             mRegistration,
                                             NS_ERROR_INTERCEPTION_FAILED);
      }

      MOZ_ALWAYS_SUCCEEDS(mWorkerPrivate->DispatchToMainThread(runnable.forget()));
    }

    RefPtr<Promise> waitUntilPromise = event->GetPromise();
    if (waitUntilPromise) {
      KeepAliveHandler::CreateAndAttachToPromise(mKeepAliveToken,
                                                 waitUntilPromise);
    }

    return true;
  }

  nsresult
  HandleBodyWithHeaders(nsIInputStream* aUploadStream)
  {
    // We are dealing with an nsMIMEInputStream which uses string input streams
    // under the hood, so all of the data is available synchronously.
    bool nonBlocking = false;
    nsresult rv = aUploadStream->IsNonBlocking(&nonBlocking);
    NS_ENSURE_SUCCESS(rv, rv);
    if (NS_WARN_IF(!nonBlocking)) {
      return NS_ERROR_NOT_AVAILABLE;
    }
    nsAutoCString body;
    rv = NS_ConsumeStream(aUploadStream, UINT32_MAX, body);
    NS_ENSURE_SUCCESS(rv, rv);

    // Extract the headers in the beginning of the buffer
    nsAutoCString::const_iterator begin, end;
    body.BeginReading(begin);
    body.EndReading(end);
    const nsAutoCString::const_iterator body_end = end;
    nsAutoCString headerName, headerValue;
    bool emptyHeader = false;
    while (FetchUtil::ExtractHeader(begin, end, headerName,
                                    headerValue, &emptyHeader) &&
           !emptyHeader) {
      mHeaderNames.AppendElement(headerName);
      mHeaderValues.AppendElement(headerValue);
      headerName.Truncate();
      headerValue.Truncate();
    }

    // Replace the upload stream with one only containing the body text.
    nsCOMPtr<nsIStringInputStream> strStream =
      do_CreateInstance(NS_STRINGINPUTSTREAM_CONTRACTID, &rv);
    NS_ENSURE_SUCCESS(rv, rv);
    // Skip past the "\r\n" that separates the headers and the body.
    ++begin;
    ++begin;
    body.Assign(Substring(begin, body_end));
    rv = strStream->SetData(body.BeginReading(), body.Length());
    NS_ENSURE_SUCCESS(rv, rv);
    mUploadStream = strStream;

    return NS_OK;
  }
};

NS_IMPL_ISUPPORTS_INHERITED(FetchEventRunnable, WorkerRunnable, nsIHttpHeaderVisitor)

} // anonymous namespace

nsresult
ServiceWorkerPrivate::SendFetchEvent(nsIInterceptedChannel* aChannel,
                                     nsILoadGroup* aLoadGroup,
                                     const nsAString& aDocumentId,
                                     bool aIsReload)
{
  AssertIsOnMainThread();

  // if the ServiceWorker script fails to load for some reason, just resume
  // the original channel.
  nsCOMPtr<nsIRunnable> failRunnable =
    NewRunnableMethod(aChannel, &nsIInterceptedChannel::ResetInterception);

  nsresult rv = SpawnWorkerIfNeeded(FetchEvent, failRunnable, aLoadGroup);
  NS_ENSURE_SUCCESS(rv, rv);

  nsMainThreadPtrHandle<nsIInterceptedChannel> handle(
    new nsMainThreadPtrHolder<nsIInterceptedChannel>(aChannel, false));

  RefPtr<ServiceWorkerManager> swm = ServiceWorkerManager::GetInstance();
  if (NS_WARN_IF(!mInfo || !swm)) {
    return NS_ERROR_FAILURE;
  }

  RefPtr<ServiceWorkerRegistrationInfo> registration =
    swm->GetRegistration(mInfo->GetPrincipal(), mInfo->Scope());

  // Its possible the registration is removed between starting the interception
  // and actually dispatching the fetch event.  In these cases we simply
  // want to restart the original network request.  Since this is a normal
  // condition we handle the reset here instead of returning an error which
  // would in turn trigger a console report.
  if (!registration) {
    aChannel->ResetInterception();
    return NS_OK;
  }

  nsMainThreadPtrHandle<ServiceWorkerRegistrationInfo> regInfo(
    new nsMainThreadPtrHolder<ServiceWorkerRegistrationInfo>(registration, false));

  RefPtr<KeepAliveToken> token = CreateEventKeepAliveToken();

  RefPtr<FetchEventRunnable> r =
    new FetchEventRunnable(mWorkerPrivate, token, handle,
                           mInfo->ScriptSpec(), regInfo,
                           aDocumentId, aIsReload);
  rv = r->Init();
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  if (mInfo->State() == ServiceWorkerState::Activating) {
    mPendingFunctionalEvents.AppendElement(r.forget());
    return NS_OK;
  }

  MOZ_ASSERT(mInfo->State() == ServiceWorkerState::Activated);

  if (NS_WARN_IF(!r->Dispatch())) {
    return NS_ERROR_FAILURE;
  }

  return NS_OK;
}

nsresult
ServiceWorkerPrivate::SpawnWorkerIfNeeded(WakeUpReason aWhy,
                                          nsIRunnable* aLoadFailedRunnable,
                                          nsILoadGroup* aLoadGroup)
{
  AssertIsOnMainThread();

  // XXXcatalinb: We need to have a separate load group that's linked to
  // an existing tab child to pass security checks on b2g.
  // This should be fixed in bug 1125961, but for now we enforce updating
  // the overriden load group when intercepting a fetch.
  MOZ_ASSERT_IF(aWhy == FetchEvent, aLoadGroup);

  if (mWorkerPrivate) {
    mWorkerPrivate->UpdateOverridenLoadGroup(aLoadGroup);
    RenewKeepAliveToken(aWhy);

    return NS_OK;
  }

  // Sanity check: mSupportsArray should be empty if we're about to
  // spin up a new worker.
  MOZ_ASSERT(mSupportsArray.IsEmpty());

  if (NS_WARN_IF(!mInfo)) {
    NS_WARNING("Trying to wake up a dead service worker.");
    return NS_ERROR_FAILURE;
  }

  // TODO(catalinb): Bug 1192138 - Add telemetry for service worker wake-ups.

  // Ensure that the IndexedDatabaseManager is initialized
  Unused << NS_WARN_IF(!IndexedDatabaseManager::GetOrCreate());

  WorkerLoadInfo info;
  nsresult rv = NS_NewURI(getter_AddRefs(info.mBaseURI), mInfo->ScriptSpec(),
                          nullptr, nullptr);

  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  info.mResolvedScriptURI = info.mBaseURI;
  MOZ_ASSERT(!mInfo->CacheName().IsEmpty());
  info.mServiceWorkerCacheName = mInfo->CacheName();
  info.mServiceWorkerID = mInfo->ID();
  info.mLoadGroup = aLoadGroup;
  info.mLoadFailedAsyncRunnable = aLoadFailedRunnable;

  rv = info.mBaseURI->GetHost(info.mDomain);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  info.mPrincipal = mInfo->GetPrincipal();

  nsContentUtils::StorageAccess access =
    nsContentUtils::StorageAllowedForPrincipal(info.mPrincipal);
  info.mStorageAllowed = access > nsContentUtils::StorageAccess::ePrivateBrowsing;
  info.mOriginAttributes = mInfo->GetOriginAttributes();

  nsCOMPtr<nsIContentSecurityPolicy> csp;
  rv = info.mPrincipal->GetCsp(getter_AddRefs(csp));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  info.mCSP = csp;
  if (info.mCSP) {
    rv = info.mCSP->GetAllowsEval(&info.mReportCSPViolations,
                                  &info.mEvalAllowed);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }
  } else {
    info.mEvalAllowed = true;
    info.mReportCSPViolations = false;
  }

  WorkerPrivate::OverrideLoadInfoLoadGroup(info);

  AutoJSAPI jsapi;
  jsapi.Init();
  ErrorResult error;
  NS_ConvertUTF8toUTF16 scriptSpec(mInfo->ScriptSpec());

  mWorkerPrivate = WorkerPrivate::Constructor(jsapi.cx(),
                                              scriptSpec,
                                              false, WorkerTypeService,
                                              mInfo->Scope(), &info, error);
  if (NS_WARN_IF(error.Failed())) {
    return error.StealNSResult();
  }

  RenewKeepAliveToken(aWhy);

  return NS_OK;
}

void
ServiceWorkerPrivate::StoreISupports(nsISupports* aSupports)
{
  AssertIsOnMainThread();
  MOZ_ASSERT(mWorkerPrivate);
  MOZ_ASSERT(!mSupportsArray.Contains(aSupports));

  mSupportsArray.AppendElement(aSupports);
}

void
ServiceWorkerPrivate::RemoveISupports(nsISupports* aSupports)
{
  AssertIsOnMainThread();
  mSupportsArray.RemoveElement(aSupports);
}

void
ServiceWorkerPrivate::TerminateWorker()
{
  AssertIsOnMainThread();

  mIdleWorkerTimer->Cancel();
  mIdleKeepAliveToken = nullptr;
  if (mWorkerPrivate) {
    if (Preferences::GetBool("dom.serviceWorkers.testing.enabled")) {
      nsCOMPtr<nsIObserverService> os = services::GetObserverService();
      if (os) {
        os->NotifyObservers(this, "service-worker-shutdown", nullptr);
      }
    }

    Unused << NS_WARN_IF(!mWorkerPrivate->Terminate());
    mWorkerPrivate = nullptr;
    mSupportsArray.Clear();

    // Any pending events are never going to fire on this worker.  Cancel
    // them so that intercepted channels can be reset and other resources
    // cleaned up.
    nsTArray<RefPtr<WorkerRunnable>> pendingEvents;
    mPendingFunctionalEvents.SwapElements(pendingEvents);
    for (uint32_t i = 0; i < pendingEvents.Length(); ++i) {
      pendingEvents[i]->Cancel();
    }
  }
}

void
ServiceWorkerPrivate::NoteDeadServiceWorkerInfo()
{
  AssertIsOnMainThread();
  mInfo = nullptr;
  TerminateWorker();
}

void
ServiceWorkerPrivate::Activated()
{
  AssertIsOnMainThread();

  // If we had to queue up events due to the worker activating, that means
  // the worker must be currently running.  We should be called synchronously
  // when the worker becomes activated.
  MOZ_ASSERT_IF(!mPendingFunctionalEvents.IsEmpty(), mWorkerPrivate);

  nsTArray<RefPtr<WorkerRunnable>> pendingEvents;
  mPendingFunctionalEvents.SwapElements(pendingEvents);

  for (uint32_t i = 0; i < pendingEvents.Length(); ++i) {
    RefPtr<WorkerRunnable> r = pendingEvents[i].forget();
    if (NS_WARN_IF(!r->Dispatch())) {
      NS_WARNING("Failed to dispatch pending functional event!");
    }
  }
}

nsresult
ServiceWorkerPrivate::GetDebugger(nsIWorkerDebugger** aResult)
{
  AssertIsOnMainThread();
  MOZ_ASSERT(aResult);

  if (!mDebuggerCount) {
    return NS_OK;
  }

  MOZ_ASSERT(mWorkerPrivate);

  nsCOMPtr<nsIWorkerDebugger> debugger = do_QueryInterface(mWorkerPrivate->Debugger());
  debugger.forget(aResult);

  return NS_OK;
}

nsresult
ServiceWorkerPrivate::AttachDebugger()
{
  AssertIsOnMainThread();

  // When the first debugger attaches to a worker, we spawn a worker if needed,
  // and cancel the idle timeout. The idle timeout should not be reset until
  // the last debugger detached from the worker.
  if (!mDebuggerCount) {
    nsresult rv = SpawnWorkerIfNeeded(AttachEvent, nullptr);
    NS_ENSURE_SUCCESS(rv, rv);

    mIdleWorkerTimer->Cancel();
  }

  ++mDebuggerCount;

  return NS_OK;
}

nsresult
ServiceWorkerPrivate::DetachDebugger()
{
  AssertIsOnMainThread();

  if (!mDebuggerCount) {
    return NS_ERROR_UNEXPECTED;
  }

  --mDebuggerCount;

  // When the last debugger detaches from a worker, we either reset the idle
  // timeout, or terminate the worker if there are no more active tokens.
  if (!mDebuggerCount) {
    if (mTokenCount) {
      ResetIdleTimeout();
    } else {
      TerminateWorker();
    }
  }

  return NS_OK;
}

bool
ServiceWorkerPrivate::IsIdle() const
{
  AssertIsOnMainThread();
  return mTokenCount == 0 || (mTokenCount == 1 && mIdleKeepAliveToken);
}

namespace {

class ServiceWorkerPrivateTimerCallback final : public nsITimerCallback
{
public:
  typedef void (ServiceWorkerPrivate::*Method)(nsITimer*);

  ServiceWorkerPrivateTimerCallback(ServiceWorkerPrivate* aServiceWorkerPrivate,
                                    Method aMethod)
    : mServiceWorkerPrivate(aServiceWorkerPrivate)
    , mMethod(aMethod)
  {
  }

  NS_IMETHOD
  Notify(nsITimer* aTimer) override
  {
    (mServiceWorkerPrivate->*mMethod)(aTimer);
    mServiceWorkerPrivate = nullptr;
    return NS_OK;
  }

private:
  ~ServiceWorkerPrivateTimerCallback() = default;

  RefPtr<ServiceWorkerPrivate> mServiceWorkerPrivate;
  Method mMethod;

  NS_DECL_THREADSAFE_ISUPPORTS
};

NS_IMPL_ISUPPORTS(ServiceWorkerPrivateTimerCallback, nsITimerCallback);

} // anonymous namespace

void
ServiceWorkerPrivate::NoteIdleWorkerCallback(nsITimer* aTimer)
{
  AssertIsOnMainThread();

  MOZ_ASSERT(aTimer == mIdleWorkerTimer, "Invalid timer!");

  // Release ServiceWorkerPrivate's token, since the grace period has ended.
  mIdleKeepAliveToken = nullptr;

  if (mWorkerPrivate) {
    // If we still have a workerPrivate at this point it means there are pending
    // waitUntil promises. Wait a bit more until we forcibly terminate the
    // worker.
    uint32_t timeout = Preferences::GetInt("dom.serviceWorkers.idle_extended_timeout");
    nsCOMPtr<nsITimerCallback> cb = new ServiceWorkerPrivateTimerCallback(
      this, &ServiceWorkerPrivate::TerminateWorkerCallback);
    DebugOnly<nsresult> rv =
      mIdleWorkerTimer->InitWithCallback(cb, timeout, nsITimer::TYPE_ONE_SHOT);
    MOZ_ASSERT(NS_SUCCEEDED(rv));
  }
}

void
ServiceWorkerPrivate::TerminateWorkerCallback(nsITimer* aTimer)
{
  AssertIsOnMainThread();

  MOZ_ASSERT(aTimer == this->mIdleWorkerTimer, "Invalid timer!");

  // mInfo must be non-null at this point because NoteDeadServiceWorkerInfo
  // which zeroes it calls TerminateWorker which cancels our timer which will
  // ensure we don't get invoked even if the nsTimerEvent is in the event queue.
  ServiceWorkerManager::LocalizeAndReportToAllClients(
    mInfo->Scope(),
    "ServiceWorkerGraceTimeoutTermination",
    nsTArray<nsString> { NS_ConvertUTF8toUTF16(mInfo->Scope()) });

  TerminateWorker();
}

void
ServiceWorkerPrivate::RenewKeepAliveToken(WakeUpReason aWhy)
{
  // We should have an active worker if we're renewing the keep alive token.
  MOZ_ASSERT(mWorkerPrivate);

  // If there is at least one debugger attached to the worker, the idle worker
  // timeout was canceled when the first debugger attached to the worker. It
  // should not be reset until the last debugger detaches from the worker.
  if (!mDebuggerCount) {
    ResetIdleTimeout();
  }

  if (!mIdleKeepAliveToken) {
    mIdleKeepAliveToken = new KeepAliveToken(this);
  }
}

void
ServiceWorkerPrivate::ResetIdleTimeout()
{
  uint32_t timeout = Preferences::GetInt("dom.serviceWorkers.idle_timeout");
  nsCOMPtr<nsITimerCallback> cb = new ServiceWorkerPrivateTimerCallback(
    this, &ServiceWorkerPrivate::NoteIdleWorkerCallback);
  DebugOnly<nsresult> rv =
    mIdleWorkerTimer->InitWithCallback(cb, timeout, nsITimer::TYPE_ONE_SHOT);
  MOZ_ASSERT(NS_SUCCEEDED(rv));
}

void
ServiceWorkerPrivate::AddToken()
{
  AssertIsOnMainThread();
  ++mTokenCount;
}

void
ServiceWorkerPrivate::ReleaseToken()
{
  AssertIsOnMainThread();

  MOZ_ASSERT(mTokenCount > 0);
  --mTokenCount;
  if (!mTokenCount) {
    TerminateWorker();
  }

  // mInfo can be nullptr here if NoteDeadServiceWorkerInfo() is called while
  // the KeepAliveToken is being proxy released as a runnable.
  else if (mInfo && IsIdle()) {
    RefPtr<ServiceWorkerManager> swm = ServiceWorkerManager::GetInstance();
    if (swm) {
      swm->WorkerIsIdle(mInfo);
    }
  }
}

already_AddRefed<KeepAliveToken>
ServiceWorkerPrivate::CreateEventKeepAliveToken()
{
  AssertIsOnMainThread();
  MOZ_ASSERT(mWorkerPrivate);
  MOZ_ASSERT(mIdleKeepAliveToken);
  RefPtr<KeepAliveToken> ref = new KeepAliveToken(this);
  return ref.forget();
}

void
ServiceWorkerPrivate::AddPendingWindow(Runnable* aPendingWindow)
{
  AssertIsOnMainThread();
  pendingWindows.AppendElement(aPendingWindow);
}

nsresult
ServiceWorkerPrivate::Observe(nsISupports* aSubject, const char* aTopic, const char16_t* aData)
{
  AssertIsOnMainThread();

  nsCString topic(aTopic);
  if (!topic.Equals(NS_LITERAL_CSTRING("BrowserChrome:Ready"))) {
    MOZ_ASSERT(false, "Unexpected topic.");
    return NS_ERROR_FAILURE;
  }

  nsCOMPtr<nsIObserverService> os = services::GetObserverService();
  NS_ENSURE_STATE(os);
  os->RemoveObserver(static_cast<nsIObserver*>(this), "BrowserChrome:Ready");

  size_t len = pendingWindows.Length();
  for (int i = len-1; i >= 0; i--) {
    RefPtr<Runnable> runnable = pendingWindows[i];
    MOZ_ALWAYS_SUCCEEDS(NS_DispatchToMainThread(runnable));
    pendingWindows.RemoveElementAt(i);
  }

  return NS_OK;
}

END_WORKERS_NAMESPACE
