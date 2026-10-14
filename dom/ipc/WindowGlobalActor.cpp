/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/WindowGlobalActor.h"

#include "AutoplayPolicy.h"
#include "mozilla/Components.h"
#include "mozilla/ContentBlockingAllowList.h"
#include "mozilla/Logging.h"
#include "mozilla/dom/Document.h"
#include "mozilla/dom/JSActorService.h"
#include "mozilla/dom/JSWindowActorChild.h"
#include "mozilla/dom/JSWindowActorParent.h"
#include "mozilla/dom/JSWindowActorProtocol.h"
#include "mozilla/dom/ParentProcessChannelHandle.h"
#include "mozilla/dom/PopupBlocker.h"
#include "mozilla/dom/WindowContext.h"
#include "mozilla/dom/WindowGlobalChild.h"
#include "mozilla/dom/WindowGlobalParent.h"
#include "mozilla/net/CookieJarSettings.h"
#include "nsContentUtils.h"
#include "nsGlobalWindowInner.h"
#include "nsNetUtil.h"
#include "nsPIDOMWindowInlines.h"

namespace mozilla::dom {

// Common WindowGlobalInit creation code used by both `AboutBlankInitializer`
// and `WindowInitializer`.
WindowGlobalInit WindowGlobalActor::BaseInitializer(
    dom::BrowsingContext* aBrowsingContext, uint64_t aInnerWindowId,
    uint64_t aOuterWindowId) {
  MOZ_DIAGNOSTIC_ASSERT(aBrowsingContext);

  WindowGlobalInit init;
  auto& ctx = init.context();
  ctx.mInnerWindowId = aInnerWindowId;
  ctx.mOuterWindowId = aOuterWindowId;
  ctx.mBrowsingContextId = aBrowsingContext->Id();
  ctx.mFields = ComputeInitialFields(aBrowsingContext);
  return init;
}

/* static */
WindowContext::FieldValues WindowGlobalActor::ComputeInitialFields(
    dom::BrowsingContext* aBrowsingContext) {
  MOZ_DIAGNOSTIC_ASSERT(aBrowsingContext);

  WindowContext::FieldValues fields;
  if (WindowContext* parent = aBrowsingContext->GetParentWindowContext()) {
    // CORPP 3.1.3 https://mikewest.github.io/corpp/#integration-html
    fields.Get<WindowContext::IDX_EmbedderPolicy>() =
        parent->GetEmbedderPolicy();
  }
  fields.Get<WindowContext::IDX_IsFramebustingAllowed>() =
      aBrowsingContext->IsTop();
  return fields;
}

WindowGlobalInit WindowGlobalActor::AboutBlankInitializer(
    dom::BrowsingContext* aBrowsingContext, nsIPrincipal* aPrincipal) {
  MOZ_DIAGNOSTIC_ASSERT(
      aPrincipal && aPrincipal->GetIsNullPrincipal(),
      "AboutBlankInitializer is a dummy that should not be web-exposed");

  WindowGlobalInit init =
      BaseInitializer(aBrowsingContext, nsContentUtils::GenerateWindowId(),
                      nsContentUtils::GenerateWindowId());

  init.principal() = aPrincipal;
  init.storagePrincipal() = aPrincipal;
  (void)NS_NewURI(getter_AddRefs(init.documentURI()), "about:blank");
  init.isInitialDocument() = true;
  init.isUncommittedInitialDocument() = true;

  return init;
}

WindowGlobalInit WindowGlobalActor::WindowInitializer(
    nsGlobalWindowInner* aWindow) {
  WindowGlobalInit init =
      BaseInitializer(aWindow->GetBrowsingContext(), aWindow->WindowID(),
                      aWindow->GetOuterWindow()->WindowID());

  init.principal() = aWindow->GetPrincipal();
  init.storagePrincipal() = aWindow->GetEffectiveStoragePrincipal();
  init.documentURI() = aWindow->GetDocumentURI();

  Document* doc = aWindow->GetDocument();

  init.isInitialDocument() = doc->IsInitialDocument();
  if (Document* original = doc->GetOriginalDocument()) {
    init.staticCloneOf() = original->GetWindowContext();
  }
  init.isUncommittedInitialDocument() = doc->IsUncommittedInitialDocument();
  init.blockAllMixedContent() = doc->GetBlockAllMixedContent(false);
  init.upgradeInsecureRequests() = doc->GetUpgradeInsecureRequests(false);
  init.sandboxFlags() = doc->GetSandboxFlags();
  net::CookieJarSettings::Cast(doc->CookieJarSettings())
      ->Serialize(init.cookieJarSettings());
  init.httpsOnlyStatus() = doc->HttpsOnlyStatus();

  if (nsIChannel* chan = doc->GetChannel()) {
    (void)chan->GetParentProcessChannelHandle(
        getter_AddRefs(init.documentChannelHandle()));
  }
  if (nsIChannel* chan = doc->GetFailedChannel()) {
    (void)chan->GetParentProcessChannelHandle(
        getter_AddRefs(init.failedChannelHandle()));
  }

  using Indexes = WindowContext::FieldIndexes;

  auto& fields = init.context().mFields;
  fields.Get<Indexes::IDX_CookieBehavior>() =
      Some(doc->CookieJarSettings()->GetCookieBehavior());
  fields.Get<Indexes::IDX_IsOnContentBlockingAllowList>() =
      doc->CookieJarSettings()->GetIsOnContentBlockingAllowList();
  fields.Get<Indexes::IDX_IsThirdPartyWindow>() = doc->HasThirdPartyChannel();
  fields.Get<Indexes::IDX_IsThirdPartyTrackingResourceWindow>() =
      nsContentUtils::IsThirdPartyTrackingResourceWindow(aWindow);
  fields.Get<Indexes::IDX_ShouldResistFingerprinting>() =
      doc->ShouldResistFingerprinting(RFPTarget::IsAlwaysEnabledForPrecompute);
  fields.Get<Indexes::IDX_OverriddenFingerprintingSettings>() =
      doc->GetOverriddenFingerprintingSettings();
  fields.Get<Indexes::IDX_IsSecureContext>() = aWindow->IsSecureContext();
  fields.Get<Indexes::IDX_IsFramebustingAllowed>() =
      aWindow->GetBrowsingContext()->ComputeIsFramebustingAllowed();

  // Initialze permission fields
  fields.Get<Indexes::IDX_AutoplayPermission>() =
      media::AutoplayPolicy::GetSiteAutoplayPermission(init.principal());
  fields.Get<Indexes::IDX_PopupPermission>() =
      PopupBlocker::GetPopupPermission(init.principal());

  // Initialize top level permission fields
  if (aWindow->GetBrowsingContext()->IsTop()) {
    fields.Get<Indexes::IDX_ShortcutsPermission>() =
        nsGlobalWindowInner::GetShortcutsPermission(init.principal());
  }

  if (auto policy = doc->GetEmbedderPolicy()) {
    fields.Get<Indexes::IDX_EmbedderPolicy>() = *policy;
  }

  // Init Mixed Content Fields
  nsCOMPtr<nsIURI> innerDocURI = NS_GetInnermostURI(doc->GetDocumentURI());
  fields.Get<Indexes::IDX_IsSecure>() =
      innerDocURI && innerDocURI->SchemeIs("https");

  if (nsCOMPtr<nsIChannel> channel = doc->GetChannel()) {
    nsCOMPtr<nsILoadInfo> loadInfo(channel->LoadInfo());
    fields.Get<Indexes::IDX_IsOriginalFrameSource>() =
        loadInfo->GetOriginalFrameSrcLoad();

    nsILoadInfo::StoragePermissionState storageAccess =
        loadInfo->GetStoragePermission();
    fields.Get<Indexes::IDX_UsingStorageAccess>() =
        storageAccess == nsILoadInfo::HasStoragePermission ||
        storageAccess == nsILoadInfo::StoragePermissionAllowListed;
  }

  fields.Get<Indexes::IDX_IsLocalIP>() =
      init.principal()->GetIsLocalIpAddress();

  // Most data here is specific to the Document, which can change without
  // creating a new WindowGlobal. Anything new added here which fits that
  // description should also be synchronized in
  // WindowGlobalChild::OnNewDocument.
  return init;
}

already_AddRefed<JSActorProtocol> WindowGlobalActor::MatchingJSActorProtocol(
    JSActorService* aActorSvc, const nsACString& aName, ErrorResult& aRv) {
  RefPtr<JSWindowActorProtocol> proto =
      aActorSvc->GetJSWindowActorProtocol(aName);
  if (!proto) {
    aRv.ThrowNotFoundError(nsPrintfCString("No such JSWindowActor '%s'",
                                           PromiseFlatCString(aName).get()));
    return nullptr;
  }

  if (!proto->Matches(BrowsingContext(), GetDocumentURI(), GetRemoteType(),
                      aRv)) {
    MOZ_ASSERT(aRv.Failed());
    return nullptr;
  }
  MOZ_ASSERT(!aRv.Failed());
  return proto.forget();
}

}  // namespace mozilla::dom
