/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ServiceWorkerRegistrationImpl.h"

#include "ipc/ErrorIPCUtils.h"
#include "mozilla/dom/Promise.h"
#include "mozilla/dom/PromiseWorkerProxy.h"
#include "mozilla/dom/PushManagerBinding.h"
#include "mozilla/dom/PushManager.h"
#include "mozilla/dom/ServiceWorkerRegistrationBinding.h"
#include "mozilla/dom/WorkerCommon.h"
#include "mozilla/dom/WorkerPrivate.h"
#include "mozilla/dom/WorkerRef.h"
#include "mozilla/dom/WorkerScope.h"
#include "mozilla/Services.h"
#include "mozilla/Unused.h"
#include "nsCycleCollectionParticipant.h"
#include "nsIPrincipal.h"
#include "nsNetUtil.h"
#include "nsServiceManagerUtils.h"
#include "ServiceWorker.h"
#include "ServiceWorkerManager.h"
#include "ServiceWorkerPrivate.h"
#include "ServiceWorkerRegistration.h"
#include "ServiceWorkerUnregisterCallback.h"

#include "mozilla/dom/Document.h"
#include "nsIServiceWorkerManager.h"
#include "nsPIDOMWindow.h"
#include "nsContentUtils.h"

namespace mozilla {
namespace dom {

////////////////////////////////////////////////////
// Main Thread implementation

ServiceWorkerRegistrationMainThread::ServiceWorkerRegistrationMainThread(
    const ServiceWorkerRegistrationDescriptor& aDescriptor)
    : mOuter(nullptr),
      mDescriptor(aDescriptor),
      mScope(NS_ConvertUTF8toUTF16(aDescriptor.Scope())),
      mListeningForEvents(false) {
  MOZ_ASSERT(NS_IsMainThread());
}

ServiceWorkerRegistrationMainThread::~ServiceWorkerRegistrationMainThread() {
  MOZ_DIAGNOSTIC_ASSERT(!mListeningForEvents);
  MOZ_DIAGNOSTIC_ASSERT(!mOuter);
}

// XXXnsm, maybe this can be optimized to only add when a event handler is
// registered.
void ServiceWorkerRegistrationMainThread::StartListeningForEvents() {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(!mListeningForEvents);
  MOZ_DIAGNOSTIC_ASSERT(!mInfo);

  RefPtr<ServiceWorkerManager> swm = ServiceWorkerManager::GetInstance();
  NS_ENSURE_TRUE_VOID(swm);

  mInfo =
      swm->GetRegistration(mDescriptor.PrincipalInfo(), mDescriptor.Scope());
  NS_ENSURE_TRUE_VOID(mInfo);

  mInfo->AddInstance(this, mDescriptor);
  mListeningForEvents = true;
}

void ServiceWorkerRegistrationMainThread::StopListeningForEvents() {
  MOZ_ASSERT(NS_IsMainThread());
  if (!mListeningForEvents) {
    return;
  }

  MOZ_DIAGNOSTIC_ASSERT(mInfo);
  mInfo->RemoveInstance(this);
  mInfo = nullptr;

  mListeningForEvents = false;
}

void ServiceWorkerRegistrationMainThread::RegistrationClearedInternal() {
  MOZ_ASSERT(NS_IsMainThread());
  // Its possible for the binding object to be collected while we the
  // runnable to call this method is in the event queue.  Double check
  // whether there is still anything to do here.
  if (mOuter) {
    mOuter->RegistrationCleared();
  }
  StopListeningForEvents();
}

// NB: These functions use NS_ENSURE_TRUE_VOID to be noisy about preconditions
// that would otherwise cause things to silently not happen if they were false.
void ServiceWorkerRegistrationMainThread::UpdateState(
    const ServiceWorkerRegistrationDescriptor& aDescriptor) {
  NS_ENSURE_TRUE_VOID(mOuter);

  nsIGlobalObject* global = mOuter->GetParentObject();
  NS_ENSURE_TRUE_VOID(global);

  RefPtr<ServiceWorkerRegistrationMainThread> self = this;
  nsCOMPtr<nsIRunnable> r =
      NS_NewRunnableFunction("ServiceWorkerRegistrationMainThread::UpdateState",
                             [self, desc = std::move(aDescriptor)]() mutable {
                               self->mDescriptor = std::move(desc);
                               NS_ENSURE_TRUE_VOID(self->mOuter);
                               self->mOuter->UpdateState(self->mDescriptor);
                             });

  Unused << global->EventTargetFor(TaskCategory::Other)
                ->Dispatch(r.forget(), NS_DISPATCH_NORMAL);
}

void ServiceWorkerRegistrationMainThread::FireUpdateFound() {
  NS_ENSURE_TRUE_VOID(mOuter);

  nsIGlobalObject* global = mOuter->GetParentObject();
  NS_ENSURE_TRUE_VOID(global);

  RefPtr<ServiceWorkerRegistrationMainThread> self = this;
  nsCOMPtr<nsIRunnable> r = NS_NewRunnableFunction(
      "ServiceWorkerRegistrationMainThread::FireUpdateFound", [self]() mutable {
        NS_ENSURE_TRUE_VOID(self->mOuter);
        self->mOuter->MaybeDispatchUpdateFoundRunnable();
      });

  Unused << global->EventTargetFor(TaskCategory::Other)
                ->Dispatch(r.forget(), NS_DISPATCH_NORMAL);
}

void ServiceWorkerRegistrationMainThread::RegistrationCleared() {
  NS_ENSURE_TRUE_VOID(mOuter);

  nsIGlobalObject* global = mOuter->GetParentObject();
  NS_ENSURE_TRUE_VOID(global);

  // Queue a runnable to clean up the registration.  This is necessary
  // because there may be runnables in the event queue already to
  // update the registration state.  We want to let those run
  // if possible before clearing our mOuter reference.
  nsCOMPtr<nsIRunnable> r = NewRunnableMethod(
      "ServiceWorkerRegistrationMainThread::RegistrationCleared", this,
      &ServiceWorkerRegistrationMainThread::RegistrationClearedInternal);

  Unused << global->EventTargetFor(TaskCategory::Other)
                ->Dispatch(r.forget(), NS_DISPATCH_NORMAL);
}

bool ServiceWorkerRegistrationMainThread::MatchesDescriptor(
    const ServiceWorkerRegistrationDescriptor& aDescriptor) {
  return mOuter->MatchesDescriptor(aDescriptor);
}

void ServiceWorkerRegistrationMainThread::SetServiceWorkerRegistration(
    ServiceWorkerRegistration* aReg) {
  MOZ_DIAGNOSTIC_ASSERT(aReg);
  MOZ_DIAGNOSTIC_ASSERT(!mOuter);
  mOuter = aReg;
  StartListeningForEvents();
}

void ServiceWorkerRegistrationMainThread::ClearServiceWorkerRegistration(
    ServiceWorkerRegistration* aReg) {
  MOZ_ASSERT_IF(mOuter, mOuter == aReg);
  StopListeningForEvents();
  mOuter = nullptr;
}

namespace {

void UpdateInternal(nsIPrincipal* aPrincipal, const nsACString& aScope,
                    nsCString aNewestWorkerScriptUrl,
                    ServiceWorkerUpdateFinishCallback* aCallback) {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aPrincipal);
  MOZ_ASSERT(aCallback);

  RefPtr<ServiceWorkerManager> swm = ServiceWorkerManager::GetInstance();
  if (!swm) {
    // browser shutdown
    return;
  }

  swm->Update(aPrincipal, aScope, std::move(aNewestWorkerScriptUrl), aCallback);
}

class MainThreadUpdateCallback final
    : public ServiceWorkerUpdateFinishCallback {
  RefPtr<ServiceWorkerRegistrationPromise::Private> mPromise;

  ~MainThreadUpdateCallback() {
    mPromise->Reject(NS_ERROR_DOM_ABORT_ERR, __func__);
  }

 public:
  MainThreadUpdateCallback()
      : mPromise(new ServiceWorkerRegistrationPromise::Private(__func__)) {}

  void UpdateSucceeded(ServiceWorkerRegistrationInfo* aRegistration) override {
    mPromise->Resolve(aRegistration->Descriptor(), __func__);
  }

  void UpdateFailed(ErrorResult& aStatus) override {
    mPromise->Reject(std::move(aStatus), __func__);
  }

  RefPtr<ServiceWorkerRegistrationPromise> Promise() const { return mPromise; }
};

class WorkerThreadUpdateCallback final
    : public ServiceWorkerUpdateFinishCallback {
  RefPtr<ThreadSafeWorkerRef> mWorkerRef;
  RefPtr<ServiceWorkerRegistrationPromise::Private> mPromise;

  ~WorkerThreadUpdateCallback() = default;

 public:
  WorkerThreadUpdateCallback(
      RefPtr<ThreadSafeWorkerRef>&& aWorkerRef,
      ServiceWorkerRegistrationPromise::Private* aPromise)
      : mWorkerRef(std::move(aWorkerRef)), mPromise(aPromise) {
    MOZ_ASSERT(NS_IsMainThread());
  }

  void UpdateSucceeded(ServiceWorkerRegistrationInfo* aRegistration) override {
    mPromise->Resolve(aRegistration->Descriptor(), __func__);
    mWorkerRef = nullptr;
  }

  void UpdateFailed(ErrorResult& aStatus) override {
    mPromise->Reject(std::move(aStatus), __func__);
    mWorkerRef = nullptr;
  }
};

class SWRUpdateRunnable final : public Runnable {
  class TimerCallback final : public nsITimerCallback {
    RefPtr<ServiceWorkerPrivate> mPrivate;
    RefPtr<Runnable> mRunnable;

   public:
    TimerCallback(ServiceWorkerPrivate* aPrivate, Runnable* aRunnable)
        : mPrivate(aPrivate), mRunnable(aRunnable) {
      MOZ_ASSERT(mPrivate);
      MOZ_ASSERT(aRunnable);
    }

    NS_IMETHOD
    Notify(nsITimer* aTimer) override {
      mRunnable->Run();
      mPrivate->RemoveISupports(aTimer);

      return NS_OK;
    }

    NS_DECL_THREADSAFE_ISUPPORTS

   private:
    ~TimerCallback() = default;
  };

 public:
  SWRUpdateRunnable(StrongWorkerRef* aWorkerRef,
                    ServiceWorkerRegistrationPromise::Private* aPromise,
                    const ServiceWorkerDescriptor& aDescriptor,
                    const nsCString& aNewestWorkerScriptUrl)
      : Runnable("dom::SWRUpdateRunnable"),
        mMutex("SWRUpdateRunnable"),
        mWorkerRef(new ThreadSafeWorkerRef(aWorkerRef)),
        mPromise(aPromise),
        mDescriptor(aDescriptor),
        mDelayed(false),
        mNewestWorkerScriptUrl(aNewestWorkerScriptUrl) {
    MOZ_DIAGNOSTIC_ASSERT(mWorkerRef);
    MOZ_DIAGNOSTIC_ASSERT(mPromise);
  }

  NS_IMETHOD
  Run() override {
    MOZ_ASSERT(NS_IsMainThread());
    ErrorResult result;

    auto principalOrErr = mDescriptor.GetPrincipal();
    if (NS_WARN_IF(principalOrErr.isErr())) {
      mPromise->Reject(NS_ERROR_DOM_INVALID_STATE_ERR, __func__);
      return NS_OK;
    }

    RefPtr<ServiceWorkerManager> swm = ServiceWorkerManager::GetInstance();
    if (NS_WARN_IF(!swm)) {
      mPromise->Reject(NS_ERROR_DOM_INVALID_STATE_ERR, __func__);
      return NS_OK;
    }

    nsCOMPtr<nsIPrincipal> principal = principalOrErr.unwrap();

    // This will delay update jobs originating from a service worker thread.
    // We don't currently handle ServiceWorkerRegistration.update() from other
    // worker types. Also, we assume this registration matches self.registration
    // on the service worker global. This is ok for now because service worker
    // globals are the only worker contexts where we expose
    // ServiceWorkerRegistration.
    RefPtr<ServiceWorkerRegistrationInfo> registration =
        swm->GetRegistration(principal, mDescriptor.Scope());
    if (NS_WARN_IF(!registration)) {
      return NS_OK;
    }

    RefPtr<ServiceWorkerInfo> worker =
        registration->GetByDescriptor(mDescriptor);
    uint32_t delay = registration->GetUpdateDelay();

    // if we have a timer object, it means we've already been delayed once.
    if (delay && !mDelayed) {
      nsCOMPtr<nsITimerCallback> cb =
          new TimerCallback(worker->WorkerPrivate(), this);
      Result<nsCOMPtr<nsITimer>, nsresult> result =
          NS_NewTimerWithCallback(cb, delay, nsITimer::TYPE_ONE_SHOT);

      nsCOMPtr<nsITimer> timer = result.unwrapOr(nullptr);
      if (NS_WARN_IF(!timer)) {
        return NS_OK;
      }

      mDelayed = true;

      // We're storing the timer object on the calling service worker's private.
      // ServiceWorkerPrivate will drop the reference if the worker terminates,
      // which will cancel the timer.
      if (!worker->WorkerPrivate()->MaybeStoreISupports(timer)) {
        // The worker thread is already shutting down.  Just cancel the timer
        // and let the update runnable be destroyed.
        timer->Cancel();
        return NS_OK;
      }

      return NS_OK;
    }

    RefPtr<ServiceWorkerRegistrationPromise::Private> promise;
    {
      MutexAutoLock lock(mMutex);
      promise.swap(mPromise);
    }

    RefPtr<WorkerThreadUpdateCallback> cb =
        new WorkerThreadUpdateCallback(std::move(mWorkerRef), promise);
    UpdateInternal(principal, mDescriptor.Scope(),
                   std::move(mNewestWorkerScriptUrl), cb);

    return NS_OK;
  }

 private:
  ~SWRUpdateRunnable() {
    MutexAutoLock lock(mMutex);
    if (mPromise) {
      mPromise->Reject(NS_ERROR_DOM_INVALID_STATE_ERR, __func__);
    }
  }

  // Protects promise access across threads
  Mutex mMutex;

  RefPtr<ThreadSafeWorkerRef> mWorkerRef;
  RefPtr<ServiceWorkerRegistrationPromise::Private> mPromise;
  const ServiceWorkerDescriptor mDescriptor;
  bool mDelayed;
  nsCString mNewestWorkerScriptUrl;
};

NS_IMPL_ISUPPORTS(SWRUpdateRunnable::TimerCallback, nsITimerCallback)

class WorkerUnregisterCallback final
    : public nsIServiceWorkerUnregisterCallback {
  RefPtr<ThreadSafeWorkerRef> mWorkerRef;
  RefPtr<GenericPromise::Private> mPromise;

 public:
  NS_DECL_ISUPPORTS

  WorkerUnregisterCallback(RefPtr<ThreadSafeWorkerRef>&& aWorkerRef,
                           RefPtr<GenericPromise::Private>&& aPromise)
      : mWorkerRef(std::move(aWorkerRef)), mPromise(std::move(aPromise)) {
    MOZ_DIAGNOSTIC_ASSERT(mWorkerRef);
    MOZ_DIAGNOSTIC_ASSERT(mPromise);
  }

  NS_IMETHOD
  UnregisterSucceeded(bool aState) override {
    mPromise->Resolve(aState, __func__);
    mWorkerRef = nullptr;
    return NS_OK;
  }

  NS_IMETHOD
  UnregisterFailed() override {
    mPromise->Reject(NS_ERROR_DOM_SECURITY_ERR, __func__);
    mWorkerRef = nullptr;
    return NS_OK;
  }

 private:
  ~WorkerUnregisterCallback() = default;
};

NS_IMPL_ISUPPORTS(WorkerUnregisterCallback, nsIServiceWorkerUnregisterCallback);

/*
 * If the worker goes away, we still continue to unregister, but we don't try to
 * resolve the worker Promise (which doesn't exist by that point).
 */
class StartUnregisterRunnable final : public Runnable {
  // The promise is protected by the mutex.
  Mutex mMutex;

  RefPtr<ThreadSafeWorkerRef> mWorkerRef;
  RefPtr<GenericPromise::Private> mPromise;
  const ServiceWorkerRegistrationDescriptor mDescriptor;

  ~StartUnregisterRunnable() {
    MutexAutoLock lock(mMutex);
    if (mPromise) {
      mPromise->Reject(NS_ERROR_DOM_INVALID_STATE_ERR, __func__);
    }
  }

 public:
  StartUnregisterRunnable(
      StrongWorkerRef* aWorkerRef, GenericPromise::Private* aPromise,
      const ServiceWorkerRegistrationDescriptor& aDescriptor)
      : Runnable("dom::StartUnregisterRunnable"),
        mMutex("StartUnregisterRunnable"),
        mWorkerRef(new ThreadSafeWorkerRef(aWorkerRef)),
        mPromise(aPromise),
        mDescriptor(aDescriptor) {
    MOZ_DIAGNOSTIC_ASSERT(mWorkerRef);
    MOZ_DIAGNOSTIC_ASSERT(mPromise);
  }

  NS_IMETHOD
  Run() override {
    MOZ_ASSERT(NS_IsMainThread());

    auto principalOrErr = mDescriptor.GetPrincipal();
    if (NS_WARN_IF(principalOrErr.isErr())) {
      mPromise->Reject(NS_ERROR_DOM_INVALID_STATE_ERR, __func__);
      return NS_OK;
    }

    nsCOMPtr<nsIPrincipal> principal = principalOrErr.unwrap();

    nsCOMPtr<nsIServiceWorkerManager> swm =
        mozilla::services::GetServiceWorkerManager();
    if (!swm) {
      mPromise->Reject(NS_ERROR_DOM_INVALID_STATE_ERR, __func__);
      return NS_OK;
    }

    RefPtr<GenericPromise::Private> promise;
    {
      MutexAutoLock lock(mMutex);
      promise = std::move(mPromise);
    }

    RefPtr<WorkerUnregisterCallback> cb =
        new WorkerUnregisterCallback(std::move(mWorkerRef), std::move(promise));

    nsresult rv = swm->Unregister(principal, cb,
                                  NS_ConvertUTF8toUTF16(mDescriptor.Scope()));
    if (NS_WARN_IF(NS_FAILED(rv))) {
      mPromise->Reject(rv, __func__);
      return NS_OK;
    }

    return NS_OK;
  }
};

}  // namespace

void ServiceWorkerRegistrationMainThread::Update(
    const nsCString& aNewestWorkerScriptUrl,
    ServiceWorkerRegistrationCallback&& aSuccessCB,
    ServiceWorkerFailureCallback&& aFailureCB) {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_DIAGNOSTIC_ASSERT(mOuter);

  nsIGlobalObject* global = mOuter->GetParentObject();
  if (!global) {
    aFailureCB(CopyableErrorResult(NS_ERROR_DOM_INVALID_STATE_ERR));
    return;
  }

  auto principalOrErr = mDescriptor.GetPrincipal();
  if (NS_WARN_IF(principalOrErr.isErr())) {
    aFailureCB(CopyableErrorResult(NS_ERROR_DOM_INVALID_STATE_ERR));
    return;
  }

  nsCOMPtr<nsIPrincipal> principal = principalOrErr.unwrap();

  RefPtr<MainThreadUpdateCallback> cb = new MainThreadUpdateCallback();
  UpdateInternal(principal, NS_ConvertUTF16toUTF8(mScope),
                 aNewestWorkerScriptUrl, cb);

  auto holder =
      MakeRefPtr<DOMMozPromiseRequestHolder<ServiceWorkerRegistrationPromise>>(
          global);

  cb->Promise()
      ->Then(
          global->EventTargetFor(TaskCategory::Other), __func__,
          [successCB = std::move(aSuccessCB),
           holder](const ServiceWorkerRegistrationDescriptor& aDescriptor) {
            holder->Complete();
            successCB(aDescriptor);
          },
          [failureCB = std::move(aFailureCB),
           holder](const CopyableErrorResult& aRv) {
            holder->Complete();
            failureCB(CopyableErrorResult(aRv));
          })
      ->Track(*holder);
}

void ServiceWorkerRegistrationMainThread::Unregister(
    ServiceWorkerBoolCallback&& aSuccessCB,
    ServiceWorkerFailureCallback&& aFailureCB) {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_DIAGNOSTIC_ASSERT(mOuter);

  nsIGlobalObject* global = mOuter->GetParentObject();
  if (!global) {
    aFailureCB(CopyableErrorResult(NS_ERROR_DOM_INVALID_STATE_ERR));
    return;
  }

  nsCOMPtr<nsIServiceWorkerManager> swm =
      mozilla::services::GetServiceWorkerManager();
  if (!swm) {
    aFailureCB(CopyableErrorResult(NS_ERROR_DOM_INVALID_STATE_ERR));
    return;
  }

  auto principalOrErr = mDescriptor.GetPrincipal();
  if (NS_WARN_IF(principalOrErr.isErr())) {
    aFailureCB(CopyableErrorResult(NS_ERROR_DOM_INVALID_STATE_ERR));
    return;
  }

  nsCOMPtr<nsIPrincipal> principal = principalOrErr.unwrap();

  RefPtr<UnregisterCallback> cb = new UnregisterCallback();

  nsresult rv = swm->Unregister(principal, cb,
                                NS_ConvertUTF8toUTF16(mDescriptor.Scope()));
  if (NS_FAILED(rv)) {
    aFailureCB(CopyableErrorResult(rv));
    return;
  }

  auto holder = MakeRefPtr<DOMMozPromiseRequestHolder<GenericPromise>>(global);

  cb->Promise()
      ->Then(
          global->EventTargetFor(TaskCategory::Other), __func__,
          [successCB = std::move(aSuccessCB), holder](bool aResult) {
            holder->Complete();
            successCB(aResult);
          },
          [failureCB = std::move(aFailureCB), holder](nsresult aRv) {
            holder->Complete();
            failureCB(CopyableErrorResult(aRv));
          })
      ->Track(*holder);
}

////////////////////////////////////////////////////
// Worker Thread implementation

class WorkerListener final : public ServiceWorkerRegistrationListener {
  ServiceWorkerRegistrationDescriptor mDescriptor;
  nsMainThreadPtrHandle<ServiceWorkerRegistrationInfo> mInfo;
  nsCOMPtr<nsISerialEventTarget> mEventTarget;
  bool mListeningForEvents;

  // Set and unset on worker thread, used on main-thread and protected by mutex.
  ServiceWorkerRegistrationWorkerThread* mRegistration;

  Mutex mMutex;

 public:
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(WorkerListener, override)

  WorkerListener(ServiceWorkerRegistrationWorkerThread* aReg,
                 const ServiceWorkerRegistrationDescriptor& aDescriptor,
                 nsISerialEventTarget* aEventTarget)
      : mDescriptor(aDescriptor),
        mEventTarget(aEventTarget),
        mListeningForEvents(false),
        mRegistration(aReg),
        mMutex("WorkerListener::mMutex") {
    MOZ_ASSERT(IsCurrentThreadRunningWorker());
    MOZ_ASSERT(mEventTarget);
    MOZ_ASSERT(mRegistration);
  }

  void StartListeningForEvents() {
    MOZ_ASSERT(NS_IsMainThread());
    MOZ_DIAGNOSTIC_ASSERT(!mListeningForEvents);
    MOZ_DIAGNOSTIC_ASSERT(!mInfo);

    RefPtr<ServiceWorkerManager> swm = ServiceWorkerManager::GetInstance();
    NS_ENSURE_TRUE_VOID(swm);

    RefPtr<ServiceWorkerRegistrationInfo> info =
        swm->GetRegistration(mDescriptor.PrincipalInfo(), mDescriptor.Scope());
    NS_ENSURE_TRUE_VOID(info);

    mInfo = new nsMainThreadPtrHolder<ServiceWorkerRegistrationInfo>(
        "WorkerListener::mInfo", info);

    mInfo->AddInstance(this, mDescriptor);
    mListeningForEvents = true;
  }

  void StopListeningForEvents() {
    MOZ_ASSERT(NS_IsMainThread());

    if (!mListeningForEvents) {
      return;
    }

    MOZ_DIAGNOSTIC_ASSERT(mInfo);
    mInfo->RemoveInstance(this);
    mListeningForEvents = false;
  }

  // ServiceWorkerRegistrationListener
  void UpdateState(
      const ServiceWorkerRegistrationDescriptor& aDescriptor) override {
    MOZ_ASSERT(NS_IsMainThread());

    mDescriptor = aDescriptor;

    nsCOMPtr<nsIRunnable> r =
        NewCancelableRunnableMethod<ServiceWorkerRegistrationDescriptor>(
            "WorkerListener::UpdateState", this,
            &WorkerListener::UpdateStateOnWorkerThread, aDescriptor);

    Unused << mEventTarget->Dispatch(r.forget(), NS_DISPATCH_NORMAL);
  }

  void FireUpdateFound() override {
    MOZ_ASSERT(NS_IsMainThread());

    nsCOMPtr<nsIRunnable> r = NewCancelableRunnableMethod(
        "WorkerListener::FireUpdateFound", this,
        &WorkerListener::FireUpdateFoundOnWorkerThread);

    Unused << mEventTarget->Dispatch(r.forget(), NS_DISPATCH_NORMAL);
  }

  void UpdateStateOnWorkerThread(
      const ServiceWorkerRegistrationDescriptor& aDescriptor) {
    MOZ_ASSERT(IsCurrentThreadRunningWorker());
    if (mRegistration) {
      mRegistration->UpdateState(aDescriptor);
    }
  }

  void FireUpdateFoundOnWorkerThread() {
    MOZ_ASSERT(IsCurrentThreadRunningWorker());
    if (mRegistration) {
      mRegistration->FireUpdateFound();
    }
  }

  void RegistrationCleared() override;

  void GetScope(nsAString& aScope) const override {
    CopyUTF8toUTF16(mDescriptor.Scope(), aScope);
  }

  bool MatchesDescriptor(
      const ServiceWorkerRegistrationDescriptor& aDescriptor) override {
    // TODO: Not implemented
    return false;
  }

  void ClearRegistration() {
    MOZ_ASSERT(IsCurrentThreadRunningWorker());
    MutexAutoLock lock(mMutex);
    mRegistration = nullptr;
  }

 private:
  ~WorkerListener() { MOZ_ASSERT(!mListeningForEvents); }
};

ServiceWorkerRegistrationWorkerThread::ServiceWorkerRegistrationWorkerThread(
    const ServiceWorkerRegistrationDescriptor& aDescriptor)
    : mOuter(nullptr),
      mDescriptor(aDescriptor),
      mScope(NS_ConvertUTF8toUTF16(aDescriptor.Scope())) {}

ServiceWorkerRegistrationWorkerThread::
    ~ServiceWorkerRegistrationWorkerThread() {
  MOZ_DIAGNOSTIC_ASSERT(!mListener);
  MOZ_DIAGNOSTIC_ASSERT(!mOuter);
}

void ServiceWorkerRegistrationWorkerThread::RegistrationCleared() {
  // The SWM notifying us that the registration was removed on the MT may
  // race with ClearServiceWorkerRegistration() on the worker thread.  So
  // double-check that mOuter is still valid.
  if (mOuter) {
    mOuter->RegistrationCleared();
  }
}

void ServiceWorkerRegistrationWorkerThread::SetServiceWorkerRegistration(
    ServiceWorkerRegistration* aReg) {
  MOZ_DIAGNOSTIC_ASSERT(aReg);
  MOZ_DIAGNOSTIC_ASSERT(!mOuter);
  mOuter = aReg;
  InitListener();
}

void ServiceWorkerRegistrationWorkerThread::ClearServiceWorkerRegistration(
    ServiceWorkerRegistration* aReg) {
  MOZ_ASSERT_IF(mOuter, mOuter == aReg);
  ReleaseListener();
  mOuter = nullptr;
}

void ServiceWorkerRegistrationWorkerThread::Update(
    const nsCString& aNewestWorkerScriptUrl,
    ServiceWorkerRegistrationCallback&& aSuccessCB,
    ServiceWorkerFailureCallback&& aFailureCB) {
  if (NS_WARN_IF(!mWorkerRef->GetPrivate())) {
    aFailureCB(CopyableErrorResult(NS_ERROR_DOM_INVALID_STATE_ERR));
    return;
  }

  RefPtr<StrongWorkerRef> workerRef = StrongWorkerRef::Create(
      mWorkerRef->GetPrivate(), "ServiceWorkerRegistration::Update");
  if (NS_WARN_IF(!workerRef)) {
    aFailureCB(CopyableErrorResult(NS_ERROR_DOM_INVALID_STATE_ERR));
    return;
  }

  nsIGlobalObject* global = workerRef->Private()->GlobalScope();
  if (NS_WARN_IF(!global)) {
    aFailureCB(CopyableErrorResult(NS_ERROR_DOM_INVALID_STATE_ERR));
    return;
  }

  // Eventually we need to support all workers, but for right now this
  // code assumes we're on a service worker global as self.registration.
  if (NS_WARN_IF(!workerRef->Private()->IsServiceWorker())) {
    aFailureCB(CopyableErrorResult(NS_ERROR_DOM_INVALID_STATE_ERR));
    return;
  }

  // Avoid infinite update loops by ignoring update() calls during top
  // level script evaluation.  See:
  // https://github.com/slightlyoff/ServiceWorker/issues/800
  if (workerRef->Private()->IsLoadingWorkerScript()) {
    aSuccessCB(mDescriptor);
    return;
  }

  auto promise =
      MakeRefPtr<ServiceWorkerRegistrationPromise::Private>(__func__);
  auto holder =
      MakeRefPtr<DOMMozPromiseRequestHolder<ServiceWorkerRegistrationPromise>>(
          global);

  promise
      ->Then(
          global->EventTargetFor(TaskCategory::Other), __func__,
          [successCB = std::move(aSuccessCB),
           holder](const ServiceWorkerRegistrationDescriptor& aDescriptor) {
            holder->Complete();
            successCB(aDescriptor);
          },
          [failureCB = std::move(aFailureCB),
           holder](const CopyableErrorResult& aRv) {
            holder->Complete();
            failureCB(CopyableErrorResult(aRv));
          })
      ->Track(*holder);

  RefPtr<SWRUpdateRunnable> r = new SWRUpdateRunnable(
      workerRef, promise, workerRef->Private()->GetServiceWorkerDescriptor(),
      aNewestWorkerScriptUrl);

  nsresult rv = workerRef->Private()->DispatchToMainThread(r.forget());
  if (NS_FAILED(rv)) {
    promise->Reject(NS_ERROR_DOM_INVALID_STATE_ERR, __func__);
    return;
  }
}

void ServiceWorkerRegistrationWorkerThread::Unregister(
    ServiceWorkerBoolCallback&& aSuccessCB,
    ServiceWorkerFailureCallback&& aFailureCB) {
  if (NS_WARN_IF(!mWorkerRef->GetPrivate())) {
    aFailureCB(CopyableErrorResult(NS_ERROR_DOM_INVALID_STATE_ERR));
    return;
  }

  RefPtr<StrongWorkerRef> workerRef =
      StrongWorkerRef::Create(mWorkerRef->GetPrivate(), __func__);
  if (NS_WARN_IF(!workerRef)) {
    aFailureCB(CopyableErrorResult(NS_ERROR_DOM_INVALID_STATE_ERR));
    return;
  }

  // Eventually we need to support all workers, but for right now this
  // code assumes we're on a service worker global as self.registration.
  if (NS_WARN_IF(!workerRef->Private()->IsServiceWorker())) {
    aFailureCB(CopyableErrorResult(NS_ERROR_DOM_INVALID_STATE_ERR));
    return;
  }

  nsIGlobalObject* global = workerRef->Private()->GlobalScope();
  if (!global) {
    aFailureCB(CopyableErrorResult(NS_ERROR_DOM_INVALID_STATE_ERR));
    return;
  }

  auto promise = MakeRefPtr<GenericPromise::Private>(__func__);
  auto holder = MakeRefPtr<DOMMozPromiseRequestHolder<GenericPromise>>(global);

  promise
      ->Then(
          global->EventTargetFor(TaskCategory::Other), __func__,
          [successCB = std::move(aSuccessCB), holder](bool aResult) {
            holder->Complete();
            successCB(aResult);
          },
          [failureCB = std::move(aFailureCB), holder](nsresult aRv) {
            holder->Complete();
            failureCB(CopyableErrorResult(aRv));
          })
      ->Track(*holder);

  RefPtr<StartUnregisterRunnable> r =
      new StartUnregisterRunnable(workerRef, promise, mDescriptor);

  nsresult rv = workerRef->Private()->DispatchToMainThread(r);
  if (NS_FAILED(rv)) {
    promise->Reject(NS_ERROR_DOM_INVALID_STATE_ERR, __func__);
    return;
  }
}

void ServiceWorkerRegistrationWorkerThread::InitListener() {
  MOZ_ASSERT(!mListener);
  WorkerPrivate* worker = GetCurrentThreadWorkerPrivate();
  MOZ_ASSERT(worker);
  worker->AssertIsOnWorkerThread();

  RefPtr<ServiceWorkerRegistrationWorkerThread> self = this;
  mWorkerRef = WeakWorkerRef::Create(worker, [self]() {
    self->ReleaseListener();

    // Break the ref-cycle immediately when the worker thread starts to
    // teardown.  We must make sure its GC'd before the worker RuntimeService is
    // destroyed.  The WorkerListener may not be able to post a runnable
    // clearing this value after shutdown begins and thus delaying cleanup too
    // late.
    self->mOuter = nullptr;
  });

  if (NS_WARN_IF(!mWorkerRef)) {
    return;
  }

  mListener =
      new WorkerListener(this, mDescriptor, worker->HybridEventTarget());

  nsCOMPtr<nsIRunnable> r =
      NewRunnableMethod("dom::WorkerListener::StartListeningForEvents",
                        mListener, &WorkerListener::StartListeningForEvents);
  MOZ_ALWAYS_SUCCEEDS(worker->DispatchToMainThread(r.forget()));
}

void ServiceWorkerRegistrationWorkerThread::ReleaseListener() {
  if (!mListener) {
    return;
  }

  MOZ_ASSERT(IsCurrentThreadRunningWorker());

  mListener->ClearRegistration();

  nsCOMPtr<nsIRunnable> r = NewCancelableRunnableMethod(
      "dom::WorkerListener::StopListeningForEvents", mListener,
      &WorkerListener::StopListeningForEvents);
  // Calling GetPrivate() is safe because this method is called when the
  // WorkerRef is notified.
  MOZ_ALWAYS_SUCCEEDS(
      mWorkerRef->GetPrivate()->DispatchToMainThread(r.forget()));

  mListener = nullptr;
  mWorkerRef = nullptr;
}

void ServiceWorkerRegistrationWorkerThread::UpdateState(
    const ServiceWorkerRegistrationDescriptor& aDescriptor) {
  if (mOuter) {
    mOuter->UpdateState(aDescriptor);
  }
}

void ServiceWorkerRegistrationWorkerThread::FireUpdateFound() {
  if (mOuter) {
    mOuter->MaybeDispatchUpdateFoundRunnable();
  }
}

class RegistrationClearedWorkerRunnable final : public WorkerRunnable {
  RefPtr<WorkerListener> mListener;

 public:
  RegistrationClearedWorkerRunnable(WorkerPrivate* aWorkerPrivate,
                                    WorkerListener* aListener)
      : WorkerRunnable(aWorkerPrivate), mListener(aListener) {
    // Need this assertion for now since runnables which modify busy count can
    // only be dispatched from parent thread to worker thread and we don't deal
    // with nested workers. SW threads can't be nested.
    MOZ_ASSERT(aWorkerPrivate->IsServiceWorker());
  }

  bool WorkerRun(JSContext* aCx, WorkerPrivate* aWorkerPrivate) override {
    MOZ_ASSERT(aWorkerPrivate);
    aWorkerPrivate->AssertIsOnWorkerThread();
    mListener->RegistrationCleared();
    return true;
  }
};

void WorkerListener::RegistrationCleared() {
  MutexAutoLock lock(mMutex);
  if (!mRegistration) {
    return;
  }

  if (NS_IsMainThread()) {
    RefPtr<WorkerRunnable> r = new RegistrationClearedWorkerRunnable(
        mRegistration->GetWorkerPrivate(lock), this);
    Unused << r->Dispatch();

    StopListeningForEvents();
    return;
  }

  mRegistration->RegistrationCleared();
}

WorkerPrivate* ServiceWorkerRegistrationWorkerThread::GetWorkerPrivate(
    const MutexAutoLock& aProofOfLock) {
  // In this case, calling GetUnsafePrivate() is ok because we have a proof of
  // mutex lock.
  MOZ_ASSERT(mWorkerRef && mWorkerRef->GetUnsafePrivate());
  return mWorkerRef->GetUnsafePrivate();
}

}  // namespace dom
}  // namespace mozilla
