/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "PermissionRequestBase.h"

#include "MainThreadUtils.h"
#include "mozilla/Assertions.h"
#include "mozilla/Services.h"
#include "mozilla/dom/Element.h"
#include "nsIObserverService.h"
#include "nsIPrincipal.h"
#include "nsXULAppAPI.h"

namespace mozilla {
namespace dom {
namespace indexedDB {

using namespace mozilla::services;

namespace {

#define IDB_PREFIX "indexedDB"
#define TOPIC_PREFIX IDB_PREFIX "-permissions-"

const nsLiteralCString kPermissionString = NS_LITERAL_CSTRING(IDB_PREFIX);

const char kPermissionPromptTopic[] = TOPIC_PREFIX "prompt";

#ifdef DEBUG
const char kPermissionResponseTopic[] = TOPIC_PREFIX "response";
#endif

#undef TOPIC_PREFIX
#undef IDB_PREFIX

const uint32_t kPermissionDefault = nsIPermissionManager::UNKNOWN_ACTION;

void AssertSanity() {
  MOZ_ASSERT(XRE_IsParentProcess());
  MOZ_ASSERT(NS_IsMainThread());
}

}  // namespace

PermissionRequestBase::PermissionRequestBase(Element* aOwnerElement,
                                             nsIPrincipal* aPrincipal)
    : mOwnerElement(aOwnerElement), mPrincipal(aPrincipal) {
  AssertSanity();
  MOZ_ASSERT(aOwnerElement);
  MOZ_ASSERT(aPrincipal);
}

PermissionRequestBase::~PermissionRequestBase() { AssertSanity(); }

// static
nsresult PermissionRequestBase::GetCurrentPermission(
    nsIPrincipal* aPrincipal, PermissionValue* aCurrentValue) {
  AssertSanity();
  MOZ_ASSERT(aPrincipal);
  MOZ_ASSERT(aCurrentValue);

  nsCOMPtr<nsIPermissionManager> permMan = GetPermissionManager();
  if (NS_WARN_IF(!permMan)) {
    return NS_ERROR_FAILURE;
  }

  uint32_t intPermission;
  nsresult rv = permMan->TestExactPermissionFromPrincipal(
      aPrincipal, kPermissionString, &intPermission);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  PermissionValue permission = PermissionValueForIntPermission(intPermission);

  MOZ_ASSERT(permission == kPermissionAllowed ||
             permission == kPermissionDenied ||
             permission == kPermissionPrompt);

  *aCurrentValue = permission;
  return NS_OK;
}

// static
auto PermissionRequestBase::PermissionValueForIntPermission(
    uint32_t aIntPermission) -> PermissionValue {
  AssertSanity();

  switch (aIntPermission) {
    case kPermissionDefault:
      return kPermissionPrompt;
    case kPermissionAllowed:
      return kPermissionAllowed;
    case kPermissionDenied:
      return kPermissionDenied;
    default:
      MOZ_CRASH("Bad permission!");
  }

  MOZ_CRASH("Should never get here!");
}

nsresult PermissionRequestBase::PromptIfNeeded(PermissionValue* aCurrentValue) {
  AssertSanity();
  MOZ_ASSERT(aCurrentValue);
  MOZ_ASSERT(mPrincipal);

  // Tricky, we want to release the window and principal in all cases except
  // when we successfully prompt.
  nsCOMPtr<Element> element = std::move(mOwnerElement);
  nsCOMPtr<nsIPrincipal> principal = std::move(mPrincipal);

  PermissionValue currentValue;
  nsresult rv = GetCurrentPermission(principal, &currentValue);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  MOZ_ASSERT(currentValue != kPermissionDefault);

  if (currentValue == kPermissionPrompt) {
    nsCOMPtr<nsIObserverService> obsSvc = GetObserverService();
    if (NS_WARN_IF(!obsSvc)) {
      return NS_ERROR_FAILURE;
    }

    // We're about to prompt so move the members back.
    mOwnerElement = std::move(element);
    mPrincipal = std::move(principal);

    rv = obsSvc->NotifyObservers(static_cast<nsIObserver*>(this),
                                 kPermissionPromptTopic, nullptr);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      // Finally release if we failed the prompt.
      mOwnerElement = nullptr;
      mPrincipal = nullptr;
      return rv;
    }
  }

  *aCurrentValue = currentValue;
  return NS_OK;
}

void PermissionRequestBase::SetExplicitPermission(nsIPrincipal* aPrincipal,
                                                  uint32_t aIntPermission) {
  AssertSanity();
  MOZ_ASSERT(aPrincipal);
  MOZ_ASSERT(aIntPermission == kPermissionAllowed ||
             aIntPermission == kPermissionDenied);

  nsCOMPtr<nsIPermissionManager> permMan = GetPermissionManager();
  if (NS_WARN_IF(!permMan)) {
    return;
  }

  nsresult rv =
      permMan->AddFromPrincipal(aPrincipal, kPermissionString, aIntPermission,
                                nsIPermissionManager::EXPIRE_NEVER,
                                /* aExpireTime */ 0);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return;
  }
}

NS_IMPL_ISUPPORTS(PermissionRequestBase, nsIObserver, nsIIDBPermissionsRequest)

NS_IMETHODIMP
PermissionRequestBase::GetBrowserElement(Element** aElement) {
  AssertSanity();
  *aElement = do_AddRef(mOwnerElement).take();
  return NS_OK;
}

NS_IMETHODIMP
PermissionRequestBase::GetResponseObserver(nsIObserver** aObserver) {
  AssertSanity();
  *aObserver = do_AddRef(this).take();
  return NS_OK;
}

NS_IMETHODIMP
PermissionRequestBase::Observe(nsISupports* aSubject, const char* aTopic,
                               const char16_t* aData) {
  AssertSanity();
  MOZ_ASSERT(!strcmp(aTopic, kPermissionResponseTopic));
  MOZ_ASSERT(mOwnerElement);
  MOZ_ASSERT(mPrincipal);

  const nsCOMPtr<Element> element = std::move(mOwnerElement);
  Unused << element;
  const nsCOMPtr<nsIPrincipal> principal = std::move(mPrincipal);

  nsresult rv;
  uint32_t promptResult = nsDependentString(aData).ToInteger(&rv);
  MOZ_ALWAYS_SUCCEEDS(rv);

  // The UI prompt code will only return one of these three values. We have to
  // transform it to our values.
  MOZ_ASSERT(promptResult == kPermissionDefault ||
             promptResult == kPermissionAllowed ||
             promptResult == kPermissionDenied);

  if (promptResult != kPermissionDefault) {
    // Save explicitly allowed or denied permissions now.
    SetExplicitPermission(principal, promptResult);
  }

  PermissionValue permission;
  switch (promptResult) {
    case kPermissionDefault:
      permission = kPermissionPrompt;
      break;

    case kPermissionAllowed:
      permission = kPermissionAllowed;
      break;

    case kPermissionDenied:
      permission = kPermissionDenied;
      break;

    default:
      MOZ_CRASH("Bad prompt result!");
  }

  OnPromptComplete(permission);
  return NS_OK;
}

}  // namespace indexedDB
}  // namespace dom
}  // namespace mozilla
