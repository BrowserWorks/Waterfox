/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsIGlobalObject.h"

#include "mozilla/dom/BlobURLProtocolHandler.h"
#include "mozilla/dom/ServiceWorker.h"
#include "mozilla/dom/ServiceWorkerRegistration.h"
#include "nsContentUtils.h"
#include "nsThreadUtils.h"
#include "nsGlobalWindowInner.h"

using mozilla::DOMEventTargetHelper;
using mozilla::MallocSizeOf;
using mozilla::Maybe;
using mozilla::dom::BlobURLProtocolHandler;
using mozilla::dom::ClientInfo;
using mozilla::dom::ServiceWorker;
using mozilla::dom::ServiceWorkerDescriptor;
using mozilla::dom::ServiceWorkerRegistration;
using mozilla::dom::ServiceWorkerRegistrationDescriptor;

bool nsIGlobalObject::IsScriptForbidden(JSObject* aCallback,
                                        bool aIsJSImplementedWebIDL) const {
  if (mIsScriptForbidden) {
    return true;
  }

  if (NS_IsMainThread()) {
    if (aIsJSImplementedWebIDL) {
      return false;
    }
    if (!xpc::Scriptability::Get(aCallback).Allowed()) {
      return true;
    }
  }

  return false;
}

nsIGlobalObject::~nsIGlobalObject() {
  UnlinkHostObjectURIs();
  DisconnectEventTargetObjects();
  MOZ_DIAGNOSTIC_ASSERT(mEventTargetObjects.isEmpty());
}

nsIPrincipal* nsIGlobalObject::PrincipalOrNull() {
  JSObject* global = GetGlobalJSObjectPreserveColor();
  if (NS_WARN_IF(!global)) return nullptr;

  return nsContentUtils::ObjectPrincipal(global);
}

void nsIGlobalObject::RegisterHostObjectURI(const nsACString& aURI) {
  MOZ_ASSERT(!mHostObjectURIs.Contains(aURI));
  mHostObjectURIs.AppendElement(aURI);
}

void nsIGlobalObject::UnregisterHostObjectURI(const nsACString& aURI) {
  mHostObjectURIs.RemoveElement(aURI);
}

namespace {

class UnlinkHostObjectURIsRunnable final : public mozilla::Runnable {
 public:
  explicit UnlinkHostObjectURIsRunnable(nsTArray<nsCString>& aURIs)
      : mozilla::Runnable("UnlinkHostObjectURIsRunnable") {
    mURIs.SwapElements(aURIs);
  }

  NS_IMETHOD Run() override {
    MOZ_ASSERT(NS_IsMainThread());

    for (uint32_t index = 0; index < mURIs.Length(); ++index) {
      BlobURLProtocolHandler::RemoveDataEntry(mURIs[index]);
    }

    return NS_OK;
  }

 private:
  ~UnlinkHostObjectURIsRunnable() {}

  nsTArray<nsCString> mURIs;
};

}  // namespace

void nsIGlobalObject::UnlinkHostObjectURIs() {
  if (mHostObjectURIs.IsEmpty()) {
    return;
  }

  if (NS_IsMainThread()) {
    for (uint32_t index = 0; index < mHostObjectURIs.Length(); ++index) {
      BlobURLProtocolHandler::RemoveDataEntry(mHostObjectURIs[index]);
    }

    mHostObjectURIs.Clear();
    return;
  }

  // BlobURLProtocolHandler is main-thread only.

  RefPtr<UnlinkHostObjectURIsRunnable> runnable =
      new UnlinkHostObjectURIsRunnable(mHostObjectURIs);
  MOZ_ASSERT(mHostObjectURIs.IsEmpty());

  nsresult rv = NS_DispatchToMainThread(runnable);
  if (NS_FAILED(rv)) {
    NS_WARNING("Failed to dispatch a runnable to the main-thread.");
  }
}

void nsIGlobalObject::TraverseHostObjectURIs(
    nsCycleCollectionTraversalCallback& aCb) {
  if (mHostObjectURIs.IsEmpty()) {
    return;
  }

  // Currently we only store BlobImpl objects off the the main-thread and they
  // are not CCed.
  if (!NS_IsMainThread()) {
    return;
  }

  for (uint32_t index = 0; index < mHostObjectURIs.Length(); ++index) {
    BlobURLProtocolHandler::Traverse(mHostObjectURIs[index], aCb);
  }
}

void nsIGlobalObject::AddEventTargetObject(DOMEventTargetHelper* aObject) {
  MOZ_DIAGNOSTIC_ASSERT(aObject);
  MOZ_ASSERT(!aObject->isInList());
  mEventTargetObjects.insertBack(aObject);
}

void nsIGlobalObject::RemoveEventTargetObject(DOMEventTargetHelper* aObject) {
  MOZ_DIAGNOSTIC_ASSERT(aObject);
  MOZ_ASSERT(aObject->isInList());
  MOZ_ASSERT(aObject->GetOwnerGlobal() == this);
  aObject->remove();
}

void nsIGlobalObject::ForEachEventTargetObject(
    const std::function<void(DOMEventTargetHelper*, bool* aDoneOut)>& aFunc)
    const {
  // Protect against the function call triggering a mutation of the list
  // while we are iterating by copying the DETH references to a temporary
  // list.
  AutoTArray<RefPtr<DOMEventTargetHelper>, 64> targetList;
  for (const DOMEventTargetHelper* deth = mEventTargetObjects.getFirst(); deth;
       deth = deth->getNext()) {
    targetList.AppendElement(const_cast<DOMEventTargetHelper*>(deth));
  }

  // Iterate the target list and call the function on each one.
  bool done = false;
  for (auto target : targetList) {
    // Check to see if a previous iteration's callback triggered the removal
    // of this target as a side-effect.  If it did, then just ignore it.
    if (target->GetOwnerGlobal() != this) {
      continue;
    }
    aFunc(target, &done);
    if (done) {
      break;
    }
  }
}

void nsIGlobalObject::DisconnectEventTargetObjects() {
  ForEachEventTargetObject([&](DOMEventTargetHelper* aTarget, bool* aDoneOut) {
    aTarget->DisconnectFromOwner();

    // Calling DisconnectFromOwner() should result in
    // RemoveEventTargetObject() being called.
    MOZ_DIAGNOSTIC_ASSERT(aTarget->GetOwnerGlobal() != this);
  });
}

Maybe<ClientInfo> nsIGlobalObject::GetClientInfo() const {
  // By default globals do not expose themselves as a client.  Only real
  // window and worker globals are currently considered clients.
  return Maybe<ClientInfo>();
}

Maybe<ServiceWorkerDescriptor> nsIGlobalObject::GetController() const {
  // By default globals do not have a service worker controller.  Only real
  // window and worker globals can currently be controlled as a client.
  return Maybe<ServiceWorkerDescriptor>();
}

RefPtr<ServiceWorker> nsIGlobalObject::GetOrCreateServiceWorker(
    const ServiceWorkerDescriptor& aDescriptor) {
  MOZ_DIAGNOSTIC_ASSERT(false,
                        "this global should not have any service workers");
  return nullptr;
}

RefPtr<ServiceWorkerRegistration> nsIGlobalObject::GetServiceWorkerRegistration(
    const mozilla::dom::ServiceWorkerRegistrationDescriptor& aDescriptor)
    const {
  MOZ_DIAGNOSTIC_ASSERT(false,
                        "this global should not have any service workers");
  return nullptr;
}

RefPtr<ServiceWorkerRegistration>
nsIGlobalObject::GetOrCreateServiceWorkerRegistration(
    const ServiceWorkerRegistrationDescriptor& aDescriptor) {
  MOZ_DIAGNOSTIC_ASSERT(
      false, "this global should not have any service worker registrations");
  return nullptr;
}

nsPIDOMWindowInner* nsIGlobalObject::AsInnerWindow() {
  if (MOZ_LIKELY(mIsInnerWindow)) {
    return static_cast<nsPIDOMWindowInner*>(
        static_cast<nsGlobalWindowInner*>(this));
  }
  return nullptr;
}

size_t nsIGlobalObject::ShallowSizeOfExcludingThis(MallocSizeOf aSizeOf) const {
  size_t rtn = mHostObjectURIs.ShallowSizeOfExcludingThis(aSizeOf);
  return rtn;
}
