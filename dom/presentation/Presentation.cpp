/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "Presentation.h"

#include <ctype.h>

#include "mozilla/dom/PresentationBinding.h"
#include "mozilla/dom/Promise.h"
#include "nsContentUtils.h"
#include "nsCycleCollectionParticipant.h"
#include "nsIDocShell.h"
#include "nsIScriptSecurityManager.h"
#include "nsJSUtils.h"
#include "nsNetUtil.h"
#include "nsPIDOMWindow.h"
#include "nsSandboxFlags.h"
#include "nsServiceManagerUtils.h"
#include "PresentationReceiver.h"

namespace mozilla {
namespace dom {

NS_IMPL_CYCLE_COLLECTION_WRAPPERCACHE(Presentation, mWindow, mDefaultRequest,
                                      mReceiver)

NS_IMPL_CYCLE_COLLECTING_ADDREF(Presentation)
NS_IMPL_CYCLE_COLLECTING_RELEASE(Presentation)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(Presentation)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

/* static */
already_AddRefed<Presentation> Presentation::Create(
    nsPIDOMWindowInner* aWindow) {
  RefPtr<Presentation> presentation = new Presentation(aWindow);
  return presentation.forget();
}

Presentation::Presentation(nsPIDOMWindowInner* aWindow) : mWindow(aWindow) {}

Presentation::~Presentation() = default;

/* virtual */
JSObject* Presentation::WrapObject(JSContext* aCx,
                                   JS::Handle<JSObject*> aGivenProto) {
  return Presentation_Binding::Wrap(aCx, this, aGivenProto);
}

void Presentation::SetDefaultRequest(PresentationRequest* aRequest) {
  if (nsContentUtils::ShouldResistFingerprinting()) {
    return;
  }

  nsCOMPtr<Document> doc = mWindow ? mWindow->GetExtantDoc() : nullptr;
  if (NS_WARN_IF(!doc)) {
    return;
  }

  if (doc->GetSandboxFlags() & SANDBOXED_PRESENTATION) {
    return;
  }

  mDefaultRequest = aRequest;
}

already_AddRefed<PresentationRequest> Presentation::GetDefaultRequest() const {
  if (nsContentUtils::ShouldResistFingerprinting()) {
    return nullptr;
  }

  RefPtr<PresentationRequest> request = mDefaultRequest;
  return request.forget();
}

already_AddRefed<PresentationReceiver> Presentation::GetReceiver() {
  if (nsContentUtils::ShouldResistFingerprinting()) {
    return nullptr;
  }

  // return the same receiver if already created
  if (mReceiver) {
    RefPtr<PresentationReceiver> receiver = mReceiver;
    return receiver.forget();
  }

  if (!HasReceiverSupport() || !IsInPresentedContent()) {
    return nullptr;
  }

  mReceiver = PresentationReceiver::Create(mWindow);
  if (NS_WARN_IF(!mReceiver)) {
    MOZ_ASSERT(mReceiver);
    return nullptr;
  }

  RefPtr<PresentationReceiver> receiver = mReceiver;
  return receiver.forget();
}

void Presentation::SetStartSessionUnsettled(bool aIsUnsettled) {
  mStartSessionUnsettled = aIsUnsettled;
}

bool Presentation::IsStartSessionUnsettled() const {
  return mStartSessionUnsettled;
}

bool Presentation::HasReceiverSupport() const {
  if (!mWindow) {
    return false;
  }

  // Grant access to browser receiving pages and their same-origin iframes. (App
  // pages should be controlled by "presentation" permission in app manifests.)
  nsCOMPtr<nsIDocShell> docShell = mWindow->GetDocShell();
  if (!docShell) {
    return false;
  }

  if (!StaticPrefs::dom_presentation_testing_simulate_receiver() &&
      !docShell->GetIsTopLevelContentDocShell()) {
    return false;
  }

  nsAutoString presentationURL;
  nsContentUtils::GetPresentationURL(docShell, presentationURL);

  if (presentationURL.IsEmpty()) {
    return false;
  }

  nsCOMPtr<nsIScriptSecurityManager> securityManager =
      nsContentUtils::GetSecurityManager();
  if (!securityManager) {
    return false;
  }

  nsCOMPtr<nsIURI> presentationURI;
  nsresult rv = NS_NewURI(getter_AddRefs(presentationURI), presentationURL);
  if (NS_FAILED(rv)) {
    return false;
  }

  bool isPrivateWin = false;
  nsCOMPtr<Document> doc = mWindow->GetExtantDoc();
  if (doc) {
    isPrivateWin =
        doc->NodePrincipal()->OriginAttributesRef().mPrivateBrowsingId > 0;
  }

  nsCOMPtr<nsIURI> docURI = mWindow->GetDocumentURI();
  return NS_SUCCEEDED(securityManager->CheckSameOriginURI(
      presentationURI, docURI, false, isPrivateWin));
}

bool Presentation::IsInPresentedContent() const {
  if (!mWindow) {
    return false;
  }

  nsCOMPtr<nsIDocShell> docShell = mWindow->GetDocShell();
  MOZ_ASSERT(docShell);

  nsAutoString presentationURL;
  nsContentUtils::GetPresentationURL(docShell, presentationURL);

  return !presentationURL.IsEmpty();
}

}  // namespace dom
}  // namespace mozilla
