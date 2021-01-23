/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ServiceWorkerManagerParent.h"
#include "ServiceWorkerManagerService.h"
#include "ServiceWorkerUpdaterParent.h"
#include "mozilla/dom/ContentParent.h"
#include "mozilla/dom/ServiceWorkerRegistrar.h"
#include "mozilla/ipc/BackgroundParent.h"
#include "mozilla/ipc/BackgroundUtils.h"
#include "mozilla/Unused.h"
#include "nsThreadUtils.h"

namespace mozilla {

using namespace ipc;

namespace dom {

namespace {

uint64_t sServiceWorkerManagerParentID = 0;

class RegisterServiceWorkerCallback final : public Runnable {
 public:
  RegisterServiceWorkerCallback(const ServiceWorkerRegistrationData& aData,
                                uint64_t aParentID)
      : Runnable("dom::RegisterServiceWorkerCallback"),
        mData(aData),
        mParentID(aParentID) {
    AssertIsInMainProcess();
    AssertIsOnBackgroundThread();
  }

  NS_IMETHOD
  Run() override {
    AssertIsInMainProcess();
    AssertIsOnBackgroundThread();

    RefPtr<dom::ServiceWorkerRegistrar> service =
        dom::ServiceWorkerRegistrar::Get();

    // Shutdown during the process of trying to update the registrar.  Give
    // up on this modification.
    if (!service) {
      return NS_OK;
    }

    service->RegisterServiceWorker(mData);

    RefPtr<ServiceWorkerManagerService> managerService =
        ServiceWorkerManagerService::Get();
    if (managerService) {
      managerService->PropagateRegistration(mParentID, mData);
    }

    return NS_OK;
  }

 private:
  ServiceWorkerRegistrationData mData;
  const uint64_t mParentID;
};

class UnregisterServiceWorkerCallback final : public Runnable {
 public:
  UnregisterServiceWorkerCallback(const PrincipalInfo& aPrincipalInfo,
                                  const nsString& aScope, uint64_t aParentID)
      : Runnable("dom::UnregisterServiceWorkerCallback"),
        mPrincipalInfo(aPrincipalInfo),
        mScope(aScope),
        mParentID(aParentID) {
    AssertIsInMainProcess();
    AssertIsOnBackgroundThread();
  }

  NS_IMETHOD
  Run() override {
    AssertIsInMainProcess();
    AssertIsOnBackgroundThread();

    RefPtr<dom::ServiceWorkerRegistrar> service =
        dom::ServiceWorkerRegistrar::Get();

    // Shutdown during the process of trying to update the registrar.  Give
    // up on this modification.
    if (!service) {
      return NS_OK;
    }

    service->UnregisterServiceWorker(mPrincipalInfo,
                                     NS_ConvertUTF16toUTF8(mScope));

    // We do not propagate the unregister in parent-intercept mode because the
    // only point of PropagateUnregister historically is:
    // 1. Tell other ServiceWorkerManagers about the removal.  There is only 1
    //    ServiceWorkerManager in parent-intercept mode.
    // 2. To remove the registration as an awkward API for privacy and devtools
    //    purposes.  Although the unregister method is idempotent, it's
    //    preferable to only call the method once if possible.  And we're now
    //    re-enabling the removal in PropagateUnregister due to a privacy
    //    regression in bug 1589708, so it makes sense to bail now.
    if (ServiceWorkerParentInterceptEnabled()) {
      return NS_OK;
    }

    RefPtr<ServiceWorkerManagerService> managerService =
        ServiceWorkerManagerService::Get();
    if (managerService) {
      managerService->PropagateUnregister(mParentID, mPrincipalInfo, mScope);
    }

    return NS_OK;
  }

 private:
  const PrincipalInfo mPrincipalInfo;
  nsString mScope;
  uint64_t mParentID;
};

class CheckPrincipalWithCallbackRunnable final : public Runnable {
 public:
  CheckPrincipalWithCallbackRunnable(already_AddRefed<ContentParent> aParent,
                                     const PrincipalInfo& aPrincipalInfo,
                                     Runnable* aCallback)
      : Runnable("dom::CheckPrincipalWithCallbackRunnable"),
        mContentParent(aParent),
        mPrincipalInfo(aPrincipalInfo),
        mCallback(aCallback),
        mBackgroundEventTarget(GetCurrentThreadEventTarget()) {
    AssertIsInMainProcess();
    AssertIsOnBackgroundThread();

    MOZ_ASSERT(mContentParent);
    MOZ_ASSERT(mCallback);
    MOZ_ASSERT(mBackgroundEventTarget);
  }

  NS_IMETHOD Run() override {
    if (NS_IsMainThread()) {
      mContentParent = nullptr;

      mBackgroundEventTarget->Dispatch(this, NS_DISPATCH_NORMAL);
      return NS_OK;
    }

    AssertIsOnBackgroundThread();
    mCallback->Run();
    mCallback = nullptr;

    return NS_OK;
  }

 private:
  RefPtr<ContentParent> mContentParent;
  PrincipalInfo mPrincipalInfo;
  RefPtr<Runnable> mCallback;
  nsCOMPtr<nsIEventTarget> mBackgroundEventTarget;
};

}  // namespace

ServiceWorkerManagerParent::ServiceWorkerManagerParent()
    : mService(ServiceWorkerManagerService::GetOrCreate()),
      mID(++sServiceWorkerManagerParentID) {
  AssertIsOnBackgroundThread();
  mService->RegisterActor(this);
}

ServiceWorkerManagerParent::~ServiceWorkerManagerParent() {
  AssertIsOnBackgroundThread();
}

mozilla::ipc::IPCResult ServiceWorkerManagerParent::RecvRegister(
    const ServiceWorkerRegistrationData& aData) {
  AssertIsInMainProcess();
  AssertIsOnBackgroundThread();

  // Basic validation.
  if (aData.scope().IsEmpty() ||
      aData.principal().type() == PrincipalInfo::TNullPrincipalInfo ||
      aData.principal().type() == PrincipalInfo::TSystemPrincipalInfo) {
    return IPC_FAIL_NO_REASON(this);
  }

  RefPtr<RegisterServiceWorkerCallback> callback =
      new RegisterServiceWorkerCallback(aData, mID);

  RefPtr<ContentParent> parent = BackgroundParent::GetContentParent(Manager());

  // If the ContentParent is null we are dealing with a same-process actor.
  if (!parent) {
    callback->Run();
    return IPC_OK();
  }

  RefPtr<CheckPrincipalWithCallbackRunnable> runnable =
      new CheckPrincipalWithCallbackRunnable(parent.forget(), aData.principal(),
                                             callback);
  MOZ_ALWAYS_SUCCEEDS(NS_DispatchToMainThread(runnable));

  return IPC_OK();
}

mozilla::ipc::IPCResult ServiceWorkerManagerParent::RecvUnregister(
    const PrincipalInfo& aPrincipalInfo, const nsString& aScope) {
  AssertIsInMainProcess();
  AssertIsOnBackgroundThread();

  // Basic validation.
  if (aScope.IsEmpty() ||
      aPrincipalInfo.type() == PrincipalInfo::TNullPrincipalInfo ||
      aPrincipalInfo.type() == PrincipalInfo::TSystemPrincipalInfo) {
    return IPC_FAIL_NO_REASON(this);
  }

  RefPtr<UnregisterServiceWorkerCallback> callback =
      new UnregisterServiceWorkerCallback(aPrincipalInfo, aScope, mID);

  RefPtr<ContentParent> parent = BackgroundParent::GetContentParent(Manager());

  // If the ContentParent is null we are dealing with a same-process actor.
  if (!parent) {
    callback->Run();
    return IPC_OK();
  }

  RefPtr<CheckPrincipalWithCallbackRunnable> runnable =
      new CheckPrincipalWithCallbackRunnable(parent.forget(), aPrincipalInfo,
                                             callback);
  MOZ_ALWAYS_SUCCEEDS(NS_DispatchToMainThread(runnable));

  return IPC_OK();
}

mozilla::ipc::IPCResult ServiceWorkerManagerParent::RecvPropagateSoftUpdate(
    const OriginAttributes& aOriginAttributes, const nsString& aScope) {
  AssertIsOnBackgroundThread();

  if (NS_WARN_IF(!mService)) {
    return IPC_FAIL_NO_REASON(this);
  }

  mService->PropagateSoftUpdate(mID, aOriginAttributes, aScope);
  return IPC_OK();
}

mozilla::ipc::IPCResult ServiceWorkerManagerParent::RecvPropagateUnregister(
    const PrincipalInfo& aPrincipalInfo, const nsString& aScope) {
  AssertIsOnBackgroundThread();

  if (NS_WARN_IF(!mService)) {
    return IPC_FAIL_NO_REASON(this);
  }

  mService->PropagateUnregister(mID, aPrincipalInfo, aScope);
  return IPC_OK();
}

mozilla::ipc::IPCResult ServiceWorkerManagerParent::RecvPropagateRemove(
    const nsCString& aHost) {
  AssertIsOnBackgroundThread();

  if (NS_WARN_IF(!mService)) {
    return IPC_FAIL_NO_REASON(this);
  }

  mService->PropagateRemove(mID, aHost);
  return IPC_OK();
}

mozilla::ipc::IPCResult ServiceWorkerManagerParent::RecvPropagateRemoveAll() {
  AssertIsOnBackgroundThread();

  if (NS_WARN_IF(!mService)) {
    return IPC_FAIL_NO_REASON(this);
  }

  mService->PropagateRemoveAll(mID);
  return IPC_OK();
}

mozilla::ipc::IPCResult ServiceWorkerManagerParent::RecvShutdown() {
  AssertIsOnBackgroundThread();

  if (NS_WARN_IF(!mService)) {
    return IPC_FAIL_NO_REASON(this);
  }

  mService->UnregisterActor(this);
  mService = nullptr;

  Unused << Send__delete__(this);
  return IPC_OK();
}

PServiceWorkerUpdaterParent*
ServiceWorkerManagerParent::AllocPServiceWorkerUpdaterParent(
    const OriginAttributes& aOriginAttributes, const nsCString& aScope) {
  AssertIsOnBackgroundThread();
  return new ServiceWorkerUpdaterParent();
}

mozilla::ipc::IPCResult
ServiceWorkerManagerParent::RecvPServiceWorkerUpdaterConstructor(
    PServiceWorkerUpdaterParent* aActor,
    const OriginAttributes& aOriginAttributes, const nsCString& aScope) {
  AssertIsOnBackgroundThread();

  if (NS_WARN_IF(!mService)) {
    return IPC_FAIL_NO_REASON(this);
  }

  mService->ProcessUpdaterActor(
      static_cast<ServiceWorkerUpdaterParent*>(aActor), aOriginAttributes,
      aScope, mID);
  return IPC_OK();
}

bool ServiceWorkerManagerParent::DeallocPServiceWorkerUpdaterParent(
    PServiceWorkerUpdaterParent* aActor) {
  AssertIsOnBackgroundThread();
  delete aActor;
  return true;
}

void ServiceWorkerManagerParent::ActorDestroy(ActorDestroyReason aWhy) {
  AssertIsOnBackgroundThread();

  if (mService) {
    // This object is about to be released and with it, also mService will be
    // released too.
    mService->UnregisterActor(this);
  }
}

}  // namespace dom
}  // namespace mozilla
