/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "RemoteServiceWorkerRegistrationImpl.h"

#include "ServiceWorkerRegistrationChild.h"

namespace mozilla {
namespace dom {

using mozilla::ipc::IPCResult;
using mozilla::ipc::ResponseRejectReason;

RemoteServiceWorkerRegistrationImpl::~RemoteServiceWorkerRegistrationImpl() {
  MOZ_DIAGNOSTIC_ASSERT(!mOuter);
  Shutdown();
}

void RemoteServiceWorkerRegistrationImpl::Shutdown() {
  if (mShutdown) {
    return;
  }
  mShutdown = true;

  if (mActor) {
    mActor->RevokeOwner(this);
    mActor->MaybeStartTeardown();
    mActor = nullptr;
  }
}

void RemoteServiceWorkerRegistrationImpl::SetServiceWorkerRegistration(
    ServiceWorkerRegistration* aReg) {
  NS_ASSERT_OWNINGTHREAD(RemoteServiceWorkerRegistrationImpl);
  MOZ_DIAGNOSTIC_ASSERT(!mOuter);
  MOZ_DIAGNOSTIC_ASSERT(aReg);
  mOuter = aReg;
}

void RemoteServiceWorkerRegistrationImpl::ClearServiceWorkerRegistration(
    ServiceWorkerRegistration* aReg) {
  NS_ASSERT_OWNINGTHREAD(RemoteServiceWorkerRegistrationImpl);
  MOZ_DIAGNOSTIC_ASSERT(mOuter);
  MOZ_DIAGNOSTIC_ASSERT(aReg == mOuter);
  mOuter = nullptr;
}

void RemoteServiceWorkerRegistrationImpl::Update(
    const nsCString& aNewestWorkerScriptUrl,
    ServiceWorkerRegistrationCallback&& aSuccessCB,
    ServiceWorkerFailureCallback&& aFailureCB) {
  if (!mActor) {
    aFailureCB(CopyableErrorResult(NS_ERROR_DOM_INVALID_STATE_ERR));
    return;
  }

  mActor->SendUpdate(
      aNewestWorkerScriptUrl,
      [successCB = std::move(aSuccessCB), aFailureCB](
          const IPCServiceWorkerRegistrationDescriptorOrCopyableErrorResult&
              aResult) {
        if (aResult.type() ==
            IPCServiceWorkerRegistrationDescriptorOrCopyableErrorResult::
                TCopyableErrorResult) {
          // application layer error
          auto& rv = aResult.get_CopyableErrorResult();
          MOZ_DIAGNOSTIC_ASSERT(rv.Failed());
          aFailureCB(CopyableErrorResult(rv));
          return;
        }
        // success
        auto& ipcDesc = aResult.get_IPCServiceWorkerRegistrationDescriptor();
        successCB(ServiceWorkerRegistrationDescriptor(ipcDesc));
      },
      [aFailureCB](ResponseRejectReason&& aReason) {
        // IPC layer error
        aFailureCB(CopyableErrorResult(NS_ERROR_DOM_INVALID_STATE_ERR));
      });
}

void RemoteServiceWorkerRegistrationImpl::Unregister(
    ServiceWorkerBoolCallback&& aSuccessCB,
    ServiceWorkerFailureCallback&& aFailureCB) {
  if (!mActor) {
    aFailureCB(CopyableErrorResult(NS_ERROR_DOM_INVALID_STATE_ERR));
    return;
  }

  mActor->SendUnregister(
      [successCB = std::move(aSuccessCB),
       aFailureCB](Tuple<bool, CopyableErrorResult>&& aResult) {
        if (Get<1>(aResult).Failed()) {
          // application layer error
          aFailureCB(std::move(Get<1>(aResult)));
          return;
        }
        // success
        successCB(Get<0>(aResult));
      },
      [aFailureCB](ResponseRejectReason&& aReason) {
        // IPC layer error
        aFailureCB(CopyableErrorResult(NS_ERROR_DOM_INVALID_STATE_ERR));
      });
}

RemoteServiceWorkerRegistrationImpl::RemoteServiceWorkerRegistrationImpl(
    const ServiceWorkerRegistrationDescriptor& aDescriptor)
    : mActor(nullptr), mOuter(nullptr), mShutdown(false) {
  PBackgroundChild* parentActor =
      BackgroundChild::GetOrCreateForCurrentThread();
  if (NS_WARN_IF(!parentActor)) {
    Shutdown();
    return;
  }

  ServiceWorkerRegistrationChild* actor =
      ServiceWorkerRegistrationChild::Create();
  if (NS_WARN_IF(!actor)) {
    Shutdown();
    return;
  }

  PServiceWorkerRegistrationChild* sentActor =
      parentActor->SendPServiceWorkerRegistrationConstructor(
          actor, aDescriptor.ToIPC());
  if (NS_WARN_IF(!sentActor)) {
    Shutdown();
    return;
  }
  MOZ_DIAGNOSTIC_ASSERT(sentActor == actor);

  mActor = actor;
  mActor->SetOwner(this);
}

void RemoteServiceWorkerRegistrationImpl::RevokeActor(
    ServiceWorkerRegistrationChild* aActor) {
  MOZ_DIAGNOSTIC_ASSERT(mActor);
  MOZ_DIAGNOSTIC_ASSERT(mActor == aActor);
  mActor->RevokeOwner(this);
  mActor = nullptr;

  mShutdown = true;

  if (mOuter) {
    RefPtr<ServiceWorkerRegistration> outer = mOuter;
    outer->RegistrationCleared();
  }
}

void RemoteServiceWorkerRegistrationImpl::UpdateState(
    const ServiceWorkerRegistrationDescriptor& aDescriptor) {
  if (mOuter) {
    RefPtr<ServiceWorkerRegistration> outer = mOuter;
    outer->UpdateState(aDescriptor);
  }
}

void RemoteServiceWorkerRegistrationImpl::FireUpdateFound() {
  if (mOuter) {
    mOuter->MaybeDispatchUpdateFoundRunnable();
  }
}

}  // namespace dom
}  // namespace mozilla
