/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ServiceWorker.h"

#include "mozilla/dom/Document.h"
#include "nsPIDOMWindow.h"
#include "RemoteServiceWorkerImpl.h"
#include "ServiceWorkerCloneData.h"
#include "ServiceWorkerImpl.h"
#include "ServiceWorkerManager.h"
#include "ServiceWorkerPrivate.h"
#include "ServiceWorkerRegistration.h"
#include "ServiceWorkerUtils.h"

#include "mozilla/dom/ClientIPCTypes.h"
#include "mozilla/dom/ClientState.h"
#include "mozilla/dom/MessagePortBinding.h"
#include "mozilla/dom/Promise.h"
#include "mozilla/dom/ServiceWorkerGlobalScopeBinding.h"
#include "mozilla/dom/WorkerPrivate.h"
#include "mozilla/StaticPrefs_dom.h"
#include "mozilla/StorageAccess.h"

#ifdef XP_WIN
#  undef PostMessage
#endif

using mozilla::ErrorResult;
using namespace mozilla::dom;

namespace mozilla {
namespace dom {

bool ServiceWorkerVisible(JSContext* aCx, JSObject* aObj) {
  if (NS_IsMainThread()) {
    return StaticPrefs::dom_serviceWorkers_enabled();
  }

  return IS_INSTANCE_OF(ServiceWorkerGlobalScope, aObj);
}

// static
already_AddRefed<ServiceWorker> ServiceWorker::Create(
    nsIGlobalObject* aOwner, const ServiceWorkerDescriptor& aDescriptor) {
  RefPtr<ServiceWorker> ref;
  RefPtr<ServiceWorker::Inner> inner;

  if (ServiceWorkerParentInterceptEnabled()) {
    inner = new RemoteServiceWorkerImpl(aDescriptor);
  } else {
    RefPtr<ServiceWorkerManager> swm = ServiceWorkerManager::GetInstance();
    NS_ENSURE_TRUE(swm, nullptr);

    RefPtr<ServiceWorkerRegistrationInfo> reg =
        swm->GetRegistration(aDescriptor.PrincipalInfo(), aDescriptor.Scope());
    NS_ENSURE_TRUE(reg, nullptr);

    RefPtr<ServiceWorkerInfo> info = reg->GetByDescriptor(aDescriptor);
    NS_ENSURE_TRUE(info, nullptr);

    inner = new ServiceWorkerImpl(info, reg);
  }

  NS_ENSURE_TRUE(inner, nullptr);

  ref = new ServiceWorker(aOwner, aDescriptor, inner);
  return ref.forget();
}

ServiceWorker::ServiceWorker(nsIGlobalObject* aGlobal,
                             const ServiceWorkerDescriptor& aDescriptor,
                             ServiceWorker::Inner* aInner)
    : DOMEventTargetHelper(aGlobal),
      mDescriptor(aDescriptor),
      mInner(aInner),
      mLastNotifiedState(ServiceWorkerState::Installing) {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_DIAGNOSTIC_ASSERT(aGlobal);
  MOZ_DIAGNOSTIC_ASSERT(mInner);

  KeepAliveIfHasListenersFor(NS_LITERAL_STRING("statechange"));

  // The error event handler is required by the spec currently, but is not used
  // anywhere.  Don't keep the object alive in that case.

  // This will update our state too.
  mInner->AddServiceWorker(this);

  // Attempt to get an existing binding object for the registration
  // associated with this ServiceWorker.
  RefPtr<ServiceWorkerRegistration> reg =
      aGlobal->GetServiceWorkerRegistration(ServiceWorkerRegistrationDescriptor(
          mDescriptor.RegistrationId(), mDescriptor.RegistrationVersion(),
          mDescriptor.PrincipalInfo(), mDescriptor.Scope(),
          ServiceWorkerUpdateViaCache::Imports));
  if (reg) {
    MaybeAttachToRegistration(reg);
  } else {
    RefPtr<ServiceWorker> self = this;

    mInner->GetRegistration(
        [self = std::move(self)](
            const ServiceWorkerRegistrationDescriptor& aDescriptor) {
          nsIGlobalObject* global = self->GetParentObject();
          NS_ENSURE_TRUE_VOID(global);
          RefPtr<ServiceWorkerRegistration> reg =
              global->GetOrCreateServiceWorkerRegistration(aDescriptor);
          self->MaybeAttachToRegistration(reg);
        },
        [](ErrorResult&& aRv) {
          // do nothing
          aRv.SuppressException();
        });
  }
}

ServiceWorker::~ServiceWorker() {
  MOZ_ASSERT(NS_IsMainThread());
  mInner->RemoveServiceWorker(this);
}

NS_IMPL_CYCLE_COLLECTION_INHERITED(ServiceWorker, DOMEventTargetHelper,
                                   mRegistration);

NS_IMPL_ADDREF_INHERITED(ServiceWorker, DOMEventTargetHelper)
NS_IMPL_RELEASE_INHERITED(ServiceWorker, DOMEventTargetHelper)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(ServiceWorker)
  NS_INTERFACE_MAP_ENTRY(ServiceWorker)
NS_INTERFACE_MAP_END_INHERITING(DOMEventTargetHelper)

JSObject* ServiceWorker::WrapObject(JSContext* aCx,
                                    JS::Handle<JSObject*> aGivenProto) {
  MOZ_ASSERT(NS_IsMainThread());

  return ServiceWorker_Binding::Wrap(aCx, this, aGivenProto);
}

ServiceWorkerState ServiceWorker::State() const { return mDescriptor.State(); }

void ServiceWorker::SetState(ServiceWorkerState aState) {
  NS_ENSURE_TRUE_VOID(aState >= mDescriptor.State());
  mDescriptor.SetState(aState);
}

void ServiceWorker::MaybeDispatchStateChangeEvent() {
  if (mDescriptor.State() <= mLastNotifiedState || !GetParentObject()) {
    return;
  }
  mLastNotifiedState = mDescriptor.State();

  DOMEventTargetHelper::DispatchTrustedEvent(NS_LITERAL_STRING("statechange"));

  // Once we have transitioned to the redundant state then no
  // more statechange events will occur.  We can allow the DOM
  // object to GC if script is not holding it alive.
  if (mLastNotifiedState == ServiceWorkerState::Redundant) {
    IgnoreKeepAliveIfHasListenersFor(NS_LITERAL_STRING("statechange"));
  }
}

void ServiceWorker::GetScriptURL(nsString& aURL) const {
  CopyUTF8toUTF16(mDescriptor.ScriptURL(), aURL);
}

void ServiceWorker::PostMessage(JSContext* aCx, JS::Handle<JS::Value> aMessage,
                                const Sequence<JSObject*>& aTransferable,
                                ErrorResult& aRv) {
  if (State() == ServiceWorkerState::Redundant) {
    aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
    return;
  }

  nsPIDOMWindowInner* window = GetOwner();
  if (NS_WARN_IF(!window || !window->GetExtantDoc())) {
    aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
    return;
  }

  auto storageAllowed = StorageAllowedForWindow(window);
  if (storageAllowed != StorageAccess::eAllow) {
    ServiceWorkerManager::LocalizeAndReportToAllClients(
        mDescriptor.Scope(), "ServiceWorkerPostMessageStorageError",
        nsTArray<nsString>{NS_ConvertUTF8toUTF16(mDescriptor.Scope())});
    aRv.Throw(NS_ERROR_DOM_SECURITY_ERR);
    return;
  }

  Maybe<ClientInfo> clientInfo = window->GetClientInfo();
  Maybe<ClientState> clientState = window->GetClientState();
  if (NS_WARN_IF(clientInfo.isNothing() || clientState.isNothing())) {
    aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
    return;
  }

  JS::Rooted<JS::Value> transferable(aCx, JS::UndefinedValue());
  aRv = nsContentUtils::CreateJSValueFromSequenceOfObject(aCx, aTransferable,
                                                          &transferable);
  if (aRv.Failed()) {
    return;
  }

  RefPtr<ServiceWorkerCloneData> data = new ServiceWorkerCloneData();
  data->Write(aCx, aMessage, transferable, JS::CloneDataPolicy(), aRv);
  if (aRv.Failed()) {
    return;
  }

  mInner->PostMessage(std::move(data), clientInfo.ref(), clientState.ref());
}

void ServiceWorker::PostMessage(JSContext* aCx, JS::Handle<JS::Value> aMessage,
                                const PostMessageOptions& aOptions,
                                ErrorResult& aRv) {
  PostMessage(aCx, aMessage, aOptions.mTransfer, aRv);
}

const ServiceWorkerDescriptor& ServiceWorker::Descriptor() const {
  return mDescriptor;
}

void ServiceWorker::DisconnectFromOwner() {
  DOMEventTargetHelper::DisconnectFromOwner();
}

void ServiceWorker::MaybeAttachToRegistration(
    ServiceWorkerRegistration* aRegistration) {
  MOZ_DIAGNOSTIC_ASSERT(aRegistration);
  MOZ_DIAGNOSTIC_ASSERT(!mRegistration);

  // If the registration no longer actually references this ServiceWorker
  // then we must be in the redundant state.
  if (!aRegistration->Descriptor().HasWorker(mDescriptor)) {
    SetState(ServiceWorkerState::Redundant);
    MaybeDispatchStateChangeEvent();
    return;
  }

  mRegistration = aRegistration;
}

}  // namespace dom
}  // namespace mozilla
