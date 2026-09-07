/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "LNAPermissionRequest.h"
#include "mozilla/dom/ClientInfo.h"
#include "nsGlobalWindowInner.h"
#include "mozilla/dom/Document.h"
#include "nsPIDOMWindow.h"
#include "mozilla/Preferences.h"
#include "nsContentUtils.h"
#include "mozilla/glean/NetwerkMetrics.h"

#include "mozilla/dom/WindowGlobalParent.h"
#include "nsIContentPolicy.h"
#include "nsIIOService.h"
#include "nsIOService.h"
#include "mozilla/dom/CanonicalBrowsingContext.h"
#include "mozilla/dom/FeaturePolicy.h"
#include "mozilla/Components.h"
#include "nsIConsoleService.h"
#include "nsIPermissionManager.h"
#include "xpcpublic.h"

namespace mozilla::net {

//-------------------------------------------------
// LNA Permission Requests
//-------------------------------------------------

NS_IMPL_ISUPPORTS_CYCLE_COLLECTION_INHERITED_0(LNAPermissionRequest,
                                               ContentPermissionRequestBase)

NS_IMPL_CYCLE_COLLECTION_INHERITED(LNAPermissionRequest,
                                   ContentPermissionRequestBase,
                                   mBrowsingContext)

LNAPermissionRequest::LNAPermissionRequest(PermissionPromptCallback&& aCallback,
                                           nsILoadInfo* aLoadInfo,
                                           const nsACString& aType)
    : dom::ContentPermissionRequestBase(
          aLoadInfo->GetLoadingPrincipal(), nullptr,
          (aType.Equals(LOOPBACK_NETWORK_PERMISSION_KEY)
               ? "network.loopback-network"_ns
               : "network.localnetwork"_ns),
          aType),
      mPermissionPromptCallback(std::move(aCallback)) {
  MOZ_ASSERT(aLoadInfo);

  aLoadInfo->GetTriggeringPrincipal(getter_AddRefs(mPrincipal));

  aLoadInfo->GetBrowsingContext(getter_AddRefs(mBrowsingContext));
  // For worker-initiated requests, the browsing context is null.
  // Fall back to the associated browsing context which points to the
  // worker's parent document's BC.
  if (!mBrowsingContext) {
    Maybe<dom::ClientInfo> clientInfo = aLoadInfo->GetClientInfo();
    if (clientInfo.isSome() && clientInfo->Type() != dom::ClientType::Window) {
      aLoadInfo->GetAssociatedBrowsingContext(getter_AddRefs(mBrowsingContext));
    }
  }
  if (mBrowsingContext && mBrowsingContext->Top()) {
    if (mBrowsingContext->Top()->Canonical()) {
      RefPtr<mozilla::dom::WindowGlobalParent> topWindowGlobal =
          mBrowsingContext->Top()->Canonical()->GetCurrentWindowGlobal();
      if (topWindowGlobal) {
        mTopLevelPrincipal = topWindowGlobal->DocumentPrincipal();
      }
    }
  }

  if (!mTopLevelPrincipal && xpc::IsInAutomation()) {
    // In test environments, the browsing context may not be fully set up.
    // Fall back to triggering principal to allow tests to proceed.
    mTopLevelPrincipal = mPrincipal;
  }

  mLoadInfo = aLoadInfo;

  MOZ_ASSERT(mPrincipal);
}

NS_IMETHODIMP
LNAPermissionRequest::GetElement(mozilla::dom::Element** aElement) {
  NS_ENSURE_ARG_POINTER(aElement);
  if (!mBrowsingContext) {
    return NS_ERROR_FAILURE;
  }

  return mBrowsingContext->GetTopFrameElement(aElement);
}

// callback when the permission request is denied
NS_IMETHODIMP
LNAPermissionRequest::Cancel() {
  // callback to the http channel on the prompt failure result
  mPermissionPromptCallback(false, mType, mPromptWasShown);
  return NS_OK;
}

// callback when the permission request is allowed
NS_IMETHODIMP
LNAPermissionRequest::Allow(JS::Handle<JS::Value> aChoices) {
  // callback to the http channel on the prompt success result
  mPermissionPromptCallback(true, mType, mPromptWasShown);
  return NS_OK;
}

// callback when the permission prompt is shown
NS_IMETHODIMP
LNAPermissionRequest::NotifyShown() {
  // Mark that the prompt was shown to the user
  mPromptWasShown = true;

  // Record telemetry for permission prompts shown to users
  // Skip telemetry if we don't have both principals (e.g., in test
  // environments)
  if (!mPrincipal || !mTopLevelPrincipal) {
    return NS_OK;
  }

  // Check if this is a cross-origin request
  bool isCrossOrigin = !mPrincipal->Equals(mTopLevelPrincipal);
  if (mType.Equals(LOOPBACK_NETWORK_PERMISSION_KEY)) {
    if (isCrossOrigin) {
      mozilla::glean::networking::local_network_access_prompts_shown
          .Get("localhost_cross_site"_ns)
          .Add(1);
    } else {
      mozilla::glean::networking::local_network_access_prompts_shown
          .Get("localhost"_ns)
          .Add(1);
    }
  } else if (mType.Equals(LOCAL_NETWORK_PERMISSION_KEY)) {
    if (isCrossOrigin) {
      mozilla::glean::networking::local_network_access_prompts_shown
          .Get("local_network_cross_site"_ns)
          .Add(1);
    } else {
      mozilla::glean::networking::local_network_access_prompts_shown
          .Get("local_network"_ns)
          .Add(1);
    }
  }

  return NS_OK;
}

nsresult LNAPermissionRequest::RequestPermission() {
  MOZ_ASSERT(NS_IsMainThread());

  // Enforce Feature Policy for Local Network Access (Bug 1978550)
  if (!mLoadInfo) {
    NS_WARNING("LNA permission request without load info");
    return Cancel();
  }

  // Retrieve the canonical browsing context for feature policy checks
  RefPtr<dom::CanonicalBrowsingContext> bc;
  if (mBrowsingContext) {
    bc = mBrowsingContext->Canonical();
  }

  if (!bc) {
    // for unit tests, we may not have a browsing context, so we dont treat this
    // as hard error for automation
    if (!xpc::IsInAutomation()) {
      NS_WARNING("local network access without browsing context");
      return Cancel();
    }
  } else {
    Maybe<dom::FeaturePolicyInfo> fpInfo = bc->GetContainerFeaturePolicy();
    // Feature Policy is populated in the canonical browsing context via
    // HTMLIFrameElement::MaybeStoreCrossOriginFeaturePolicy() (for <iframe>)
    // nsObjectLoadingContent::MaybeStoreCrossOriginFeaturePolicy() (for
    // <object>/<embed>)
    // Hence, it's safe to ignore feature policy when it's missing as that
    // would only mean the request is from a top-level document, which should
    // be allowed to request local network access without being blocked by
    // feature policy.
    if (fpInfo.isSome()) {
      nsAutoString featureName;
      if (mType.Equals(LOOPBACK_NETWORK_PERMISSION_KEY)) {
        featureName = u"loopback-network"_ns;
      } else {
        featureName = u"local-network"_ns;
      }

      if (fpInfo->mInheritedDeniedFeatureNames.Contains(featureName)) {
        NS_WARNING("Feature policy denying the request");
        return Cancel();
      }
    }
  }

  // Check if the domain should skip LNA checks
  if (mPrincipal && gIOService) {
    nsAutoCString origin;
    nsresult rv = mPrincipal->GetAsciiHost(origin);
    if (NS_SUCCEEDED(rv) && !origin.IsEmpty()) {
      if (gIOService->ShouldSkipDomainForLNA(origin)) {
        // Domain is in the skip list, grant permission automatically
        return Allow(JS::UndefinedHandleValue);
      }
    }
  }

  PromptResult pr = CheckPromptPrefs();
  if (pr == PromptResult::Granted) {
    return Allow(JS::UndefinedHandleValue);
  }

  if (pr == PromptResult::Denied) {
    return Cancel();
  }

  // For shared and service workers, do not show a permission prompt.
  // Only grant access if the origin already has a persistent LNA permission.
  //
  // Notification icons are fetched without a requesting node, and possibly
  // long after the page that created the notification is gone, so there is no
  // context to prompt in either.
  bool isNotificationIcon = mLoadInfo->InternalContentPolicyType() ==
                            nsIContentPolicy::TYPE_INTERNAL_IMAGE_NOTIFICATION;
  Maybe<dom::ClientInfo> clientInfo = mLoadInfo->GetClientInfo();
  if (isNotificationIcon ||
      (clientInfo.isSome() &&
       (clientInfo->Type() == dom::ClientType::Sharedworker ||
        clientInfo->Type() == dom::ClientType::Serviceworker))) {
    nsCOMPtr<nsIPermissionManager> permMgr =
        mozilla::components::PermissionManager::Service();
    if (!permMgr || !mPrincipal) {
      NS_WARNING(
          "LNA non-prompting permission check failed: no permission manager or "
          "principal");
      return Cancel();
    }
    uint32_t permission = nsIPermissionManager::UNKNOWN_ACTION;
    nsresult rv =
        permMgr->TestPermissionFromPrincipal(mPrincipal, mType, &permission);
    if (NS_SUCCEEDED(rv) && permission == nsIPermissionManager::ALLOW_ACTION) {
      return Allow(JS::UndefinedHandleValue);
    }
    // Log the denial to the browser console so developers can diagnose why
    // these requests are being blocked.
    nsCOMPtr<nsIConsoleService> console =
        do_GetService(NS_CONSOLESERVICE_CONTRACTID);
    if (console && mPrincipal) {
      nsAutoCString origin;
      mPrincipal->GetOrigin(origin);
      nsAutoString msg;
      msg.AppendLiteral("Local Network Access blocked: ");
      if (isNotificationIcon) {
        msg.AppendLiteral("notification icon load");
      } else {
        msg.AppendLiteral("worker");
      }
      msg.AppendLiteral(" from origin ");
      msg.Append(NS_ConvertUTF8toUTF16(origin));
      msg.AppendLiteral(" attempted ");
      msg.Append(NS_ConvertUTF8toUTF16(mType));
      msg.AppendLiteral(" access but no persistent permission was granted.");
      console->LogStringMessage(msg.get());
    }
    return Cancel();
  }

  // Ensure we have a top-level principal before showing the permission prompt
  if (!mTopLevelPrincipal) {
    NS_WARNING("Cannot show permission prompt without top-level principal");
    return Cancel();
  }

  if (NS_SUCCEEDED(
          dom::nsContentPermissionUtils::AskPermission(this, mWindow))) {
    // Here we could be getting synchronous callback from the prompts depending
    // on whether there is already a permission for this or not. If we have a
    // permission, we will get a synchronous callback Allow/Deny and async if
    // we don't have a permission yet and waiting for user permission.
    return NS_OK;
  }

  return Cancel();
}

}  // namespace mozilla::net
