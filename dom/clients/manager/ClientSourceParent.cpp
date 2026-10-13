/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ClientSourceParent.h"

#include "ClientHandleParent.h"
#include "ClientManagerService.h"
#include "ClientPrincipalUtils.h"
#include "ClientSourceOpParent.h"
#include "ClientValidation.h"
#include "mozilla/SchedulerGroup.h"
#include "mozilla/dom/ClientIPCTypes.h"
#include "mozilla/dom/ContentParent.h"
#include "mozilla/dom/PClientManagerParent.h"
#include "mozilla/dom/ServiceWorkerManager.h"
#include "mozilla/dom/ServiceWorkerUtils.h"
#include "mozilla/ipc/BackgroundParent.h"

namespace mozilla::dom {

using mozilla::ipc::AssertIsOnBackgroundThread;
using mozilla::ipc::BackgroundParent;
using mozilla::ipc::IPCResult;
using mozilla::ipc::PrincipalInfo;

mozilla::ipc::IPCResult ClientSourceParent::RecvWorkerSyncPing() {
  AssertIsOnBackgroundThread();
  // Do nothing here.  This is purely a sync message allowing the child to
  // confirm that the actor has been created on the parent process.
  return IPC_OK();
}

IPCResult ClientSourceParent::RecvTeardown() {
  (void)Send__delete__(this);
  return IPC_OK();
}

IPCResult ClientSourceParent::RecvExecutionReady(
    const ClientSourceExecutionReadyArgs& aArgs) {
  // Now that we have the creation URL for the Client we can do some validation
  // to make sure the child actor is not giving us garbage.  Since we validate
  // on the child side as well we treat a failure here as fatal.
  if (!ClientIsValidCreationURL(mClientInfo.PrincipalInfo(), aArgs.url())) {
    return IPC_FAIL(this, "Invalid creation URL!");
  }

  mClientInfo.SetURL(aArgs.url());
  mClientInfo.SetFrameType(aArgs.frameType());
  mExecutionReady = true;

  for (ClientHandleParent* handle : mHandleList) {
    (void)handle->SendExecutionReady(mClientInfo.ToIPC());
  }

  mExecutionReadyPromise.ResolveIfExists(true, __func__);

  return IPC_OK();
};

IPCResult ClientSourceParent::RecvFreeze() {
#ifdef FUZZING_SNAPSHOT
  if (mFrozen) {
    return IPC_FAIL(this, "Freezing when already frozen");
  }
#endif
  MOZ_DIAGNOSTIC_ASSERT(!mFrozen);
  mFrozen = true;

  return IPC_OK();
}

IPCResult ClientSourceParent::RecvThaw() {
#ifdef FUZZING_SNAPSHOT
  if (!mFrozen) {
    return IPC_FAIL(this, "Thawing when not already frozen");
  }
#endif
  MOZ_DIAGNOSTIC_ASSERT(mFrozen);
  mFrozen = false;
  return IPC_OK();
}

IPCResult ClientSourceParent::RecvInheritController(
    const ClientControlledArgs& aArgs) {
  // A Client may only inherit a controller from a same-origin service worker.
  // A cross-origin controller would be a same-origin policy violation, so
  // since the child side enforces this with a release assertion we treat a
  // failure here as fatal.
  if (NS_WARN_IF(
          !ClientMatchPrincipalInfo(mClientInfo.PrincipalInfo(),
                                    aArgs.serviceWorker().principalInfo()))) {
    return IPC_FAIL(this, "Invalid controller principal!");
  }

  mController.reset();
  mController.emplace(aArgs.serviceWorker());

  // We must tell the parent-side SWM about this controller inheritance.
  nsCOMPtr<nsIRunnable> r = NS_NewRunnableFunction(
      "ClientSourceParent::RecvInheritController",
      [clientInfo = mClientInfo, controller = mController.ref()]() {
        RefPtr<ServiceWorkerManager> swm = ServiceWorkerManager::GetInstance();
        NS_ENSURE_TRUE_VOID(swm);

        swm->NoteInheritedController(clientInfo, controller);
      });

  MOZ_ALWAYS_SUCCEEDS(SchedulerGroup::Dispatch(r.forget()));

  return IPC_OK();
}

IPCResult ClientSourceParent::RecvNoteDOMContentLoaded() {
  if (mController.isSome()) {
    nsCOMPtr<nsIRunnable> r =
        NS_NewRunnableFunction("ClientSourceParent::RecvNoteDOMContentLoaded",
                               [clientInfo = mClientInfo]() {
                                 RefPtr<ServiceWorkerManager> swm =
                                     ServiceWorkerManager::GetInstance();
                                 NS_ENSURE_TRUE_VOID(swm);

                                 swm->MaybeCheckNavigationUpdate(clientInfo);
                               });

    MOZ_ALWAYS_SUCCEEDS(SchedulerGroup::Dispatch(r.forget()));
  }
  return IPC_OK();
}

void ClientSourceParent::ActorDestroy(ActorDestroyReason aReason) {
  DebugOnly<bool> removed = mService->RemoveSource(this);
  MOZ_ASSERT(removed);

  for (ClientHandleParent* handle : mHandleList.Clone()) {
    // This should trigger DetachHandle() to be called removing
    // the entry from the mHandleList.
    (void)ClientHandleParent::Send__delete__(handle);
  }
  MOZ_DIAGNOSTIC_ASSERT(mHandleList.IsEmpty());
}

PClientSourceOpParent* ClientSourceParent::AllocPClientSourceOpParent(
    const ClientOpConstructorArgs& aArgs) {
  MOZ_ASSERT_UNREACHABLE(
      "ClientSourceOpParent should be explicitly constructed.");
  return nullptr;
}

bool ClientSourceParent::DeallocPClientSourceOpParent(
    PClientSourceOpParent* aActor) {
  delete aActor;
  return true;
}

ClientSourceParent::ClientSourceParent(
    const ClientSourceConstructorArgs& aArgs,
    ThreadsafeContentParentHandle* aContentParentHandle)
    : mClientInfo(aArgs.id(), aArgs.agentClusterId(), aArgs.type(),
                  aArgs.principalInfo(), aArgs.creationTime(), aArgs.url(),
                  aArgs.frameType()),
      mContentParentHandle(aContentParentHandle),
      mService(ClientManagerService::GetOrCreateInstance()),
      mExecutionReady(false),
      mFrozen(false) {}

ClientSourceParent::~ClientSourceParent() {
  MOZ_DIAGNOSTIC_ASSERT(mHandleList.IsEmpty());

  mExecutionReadyPromise.RejectIfExists(NS_ERROR_FAILURE, __func__);
}

IPCResult ClientSourceParent::Init() {
  // Ensure the principal is reasonable before adding ourself to the service.
  // Since we validate the principal on the child side as well, any failure
  // here is treated as fatal.
  if (NS_WARN_IF(!ClientIsValidPrincipalInfo(
          mClientInfo.PrincipalInfo(),
          mContentParentHandle ? mContentParentHandle->GetRemoteType()
                               : NOT_REMOTE_TYPE))) {
    mService->ForgetFutureSource(mClientInfo.ToIPC());
    return IPC_FAIL(Manager(), "Invalid PrincipalInfo!");
  }

  // Its possible for AddSource() to fail if there is already an entry for
  // our UUID.  This should not normally happen, but could if someone is
  // spoofing IPC messages.
  if (NS_WARN_IF(!mService->AddSource(this))) {
    return IPC_FAIL(Manager(), "Already registered!");
  }

  return IPC_OK();
}

const ClientInfo& ClientSourceParent::Info() const { return mClientInfo; }

bool ClientSourceParent::IsFrozen() const { return mFrozen; }

bool ClientSourceParent::ExecutionReady() const { return mExecutionReady; }

RefPtr<GenericNonExclusivePromise> ClientSourceParent::ExecutionReadyPromise() {
  // Only call if ClientSourceParent::ExecutionReady() is false; otherwise,
  // the promise will never resolve
  MOZ_ASSERT(!mExecutionReady);
  return mExecutionReadyPromise.Ensure(__func__);
}

const Maybe<ServiceWorkerDescriptor>& ClientSourceParent::GetController()
    const {
  return mController;
}

void ClientSourceParent::ClearController() { mController.reset(); }

void ClientSourceParent::AttachHandle(ClientHandleParent* aClientHandle) {
  MOZ_DIAGNOSTIC_ASSERT(aClientHandle);
  MOZ_ASSERT(!mHandleList.Contains(aClientHandle));
  mHandleList.AppendElement(aClientHandle);
}

void ClientSourceParent::DetachHandle(ClientHandleParent* aClientHandle) {
  MOZ_DIAGNOSTIC_ASSERT(aClientHandle);
  MOZ_ASSERT(mHandleList.Contains(aClientHandle));
  mHandleList.RemoveElement(aClientHandle);
}

RefPtr<ClientOpPromise> ClientSourceParent::StartOp(
    ClientOpConstructorArgs&& aArgs) {
  RefPtr<ClientOpPromise::Private> promise =
      new ClientOpPromise::Private(__func__);

  // If we are being controlled, remember that data before propagating
  // on to the ClientSource.  This must be set prior to triggering
  // the controllerchange event from the ClientSource since some tests
  // expect matchAll() to find the controlled client immediately after.
  // If the control operation fails, then we reset the controller value
  // to reflect the final state.
  if (aArgs.type() == ClientOpConstructorArgs::TClientControlledArgs) {
    mController.reset();
    mController.emplace(aArgs.get_ClientControlledArgs().serviceWorker());
  }

  // Constructor failure will reject the promise via ActorDestroy().
  ClientSourceOpParent* actor =
      new ClientSourceOpParent(std::move(aArgs), promise);
  (void)SendPClientSourceOpConstructor(actor, actor->Args());

  return promise;
}

}  // namespace mozilla::dom
