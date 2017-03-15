/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/TabContext.h"
#include "mozilla/dom/PTabContext.h"
#include "mozilla/dom/TabParent.h"
#include "mozilla/dom/TabChild.h"
#include "nsIAppsService.h"
#include "nsIScriptSecurityManager.h"
#include "nsServiceManagerUtils.h"

#define NO_APP_ID (nsIScriptSecurityManager::NO_APP_ID)

using namespace mozilla::dom::ipc;
using namespace mozilla::layout;

namespace mozilla {
namespace dom {

TabContext::TabContext()
  : mIsPrerendered(false)
  , mInitialized(false)
  , mIsMozBrowserElement(false)
  , mContainingAppId(NO_APP_ID)
  , mShowAccelerators(UIStateChangeType_NoChange)
  , mShowFocusRings(UIStateChangeType_NoChange)
{
}

bool
TabContext::IsMozBrowserElement() const
{
  return mIsMozBrowserElement;
}

bool
TabContext::IsIsolatedMozBrowserElement() const
{
  return mOriginAttributes.mInIsolatedMozBrowser;
}

bool
TabContext::IsMozBrowserOrApp() const
{
  return HasOwnApp() || IsMozBrowserElement();
}

uint32_t
TabContext::OwnAppId() const
{
  return mOriginAttributes.mAppId;
}

already_AddRefed<mozIApplication>
TabContext::GetOwnApp() const
{
  nsCOMPtr<mozIApplication> ownApp = mOwnApp;
  return ownApp.forget();
}

bool
TabContext::HasOwnApp() const
{
  nsCOMPtr<mozIApplication> ownApp = GetOwnApp();
  return !!ownApp;
}

uint32_t
TabContext::BrowserOwnerAppId() const
{
  if (IsMozBrowserElement()) {
    return mContainingAppId;
  }
  return NO_APP_ID;
}

already_AddRefed<mozIApplication>
TabContext::GetBrowserOwnerApp() const
{
  nsCOMPtr<mozIApplication> ownerApp;
  if (IsMozBrowserElement()) {
    ownerApp = mContainingApp;
  }
  return ownerApp.forget();
}

bool
TabContext::HasBrowserOwnerApp() const
{
  nsCOMPtr<mozIApplication> ownerApp = GetBrowserOwnerApp();
  return !!ownerApp;
}

uint32_t
TabContext::AppOwnerAppId() const
{
  if (HasOwnApp()) {
    return mContainingAppId;
  }
  return NO_APP_ID;
}

already_AddRefed<mozIApplication>
TabContext::GetAppOwnerApp() const
{
  nsCOMPtr<mozIApplication> ownerApp;
  if (HasOwnApp()) {
    ownerApp = mContainingApp;
  }
  return ownerApp.forget();
}

bool
TabContext::HasAppOwnerApp() const
{
  nsCOMPtr<mozIApplication> ownerApp = GetAppOwnerApp();
  return !!ownerApp;
}

uint32_t
TabContext::OwnOrContainingAppId() const
{
  if (HasOwnApp()) {
    return mOriginAttributes.mAppId;
  }

  return mContainingAppId;
}

already_AddRefed<mozIApplication>
TabContext::GetOwnOrContainingApp() const
{
  nsCOMPtr<mozIApplication> ownOrContainingApp;
  if (HasOwnApp()) {
    ownOrContainingApp = mOwnApp;
  } else {
    ownOrContainingApp = mContainingApp;
  }

  return ownOrContainingApp.forget();
}

bool
TabContext::HasOwnOrContainingApp() const
{
  nsCOMPtr<mozIApplication> ownOrContainingApp = GetOwnOrContainingApp();
  return !!ownOrContainingApp;
}

bool
TabContext::SetTabContext(const TabContext& aContext)
{
  NS_ENSURE_FALSE(mInitialized, false);

  *this = aContext;
  mInitialized = true;

  return true;
}

void
TabContext::SetPrivateBrowsingAttributes(bool aIsPrivateBrowsing)
{
  mOriginAttributes.SyncAttributesWithPrivateBrowsing(aIsPrivateBrowsing);
}

bool
TabContext::UpdateTabContextAfterSwap(const TabContext& aContext)
{
  // This is only used after already initialized.
  MOZ_ASSERT(mInitialized);

  // The only permissable change is to `mIsMozBrowserElement`.  All other fields
  // must match for the change to be accepted.
  if (aContext.OwnAppId() != OwnAppId() ||
      aContext.mContainingAppId != mContainingAppId ||
      aContext.mOriginAttributes != mOriginAttributes) {
    return false;
  }

  mIsMozBrowserElement = aContext.mIsMozBrowserElement;
  return true;
}

const DocShellOriginAttributes&
TabContext::OriginAttributesRef() const
{
  return mOriginAttributes;
}

const nsAString&
TabContext::PresentationURL() const
{
  return mPresentationURL;
}

UIStateChangeType
TabContext::ShowAccelerators() const
{
  return mShowAccelerators;
}

UIStateChangeType
TabContext::ShowFocusRings() const
{
  return mShowFocusRings;
}

bool
TabContext::SetTabContext(bool aIsMozBrowserElement,
                          bool aIsPrerendered,
                          mozIApplication* aOwnApp,
                          mozIApplication* aAppFrameOwnerApp,
                          UIStateChangeType aShowAccelerators,
                          UIStateChangeType aShowFocusRings,
                          const DocShellOriginAttributes& aOriginAttributes,
                          const nsAString& aPresentationURL)
{
  NS_ENSURE_FALSE(mInitialized, false);

  // Get ids for both apps and only write to our member variables after we've
  // verified that this worked.
  uint32_t ownAppId = NO_APP_ID;
  if (aOwnApp) {
    nsresult rv = aOwnApp->GetLocalId(&ownAppId);
    NS_ENSURE_SUCCESS(rv, false);
    NS_ENSURE_TRUE(ownAppId != NO_APP_ID, false);
  }

  uint32_t containingAppId = NO_APP_ID;
  if (aAppFrameOwnerApp) {
    nsresult rv = aAppFrameOwnerApp->GetLocalId(&containingAppId);
    NS_ENSURE_SUCCESS(rv, false);
    NS_ENSURE_TRUE(containingAppId != NO_APP_ID, false);
  }

  // Veryify that app id matches mAppId passed in originAttributes
  MOZ_RELEASE_ASSERT((aOwnApp && aOriginAttributes.mAppId == ownAppId) ||
                     (aAppFrameOwnerApp && aOriginAttributes.mAppId == containingAppId) ||
                     aOriginAttributes.mAppId == NO_APP_ID);

  mInitialized = true;
  mIsMozBrowserElement = aIsMozBrowserElement;
  mIsPrerendered = aIsPrerendered;
  mOriginAttributes = aOriginAttributes;
  mContainingAppId = containingAppId;
  mOwnApp = aOwnApp;
  mContainingApp = aAppFrameOwnerApp;
  mPresentationURL = aPresentationURL;
  mShowAccelerators = aShowAccelerators;
  mShowFocusRings = aShowFocusRings;
  return true;
}

IPCTabContext
TabContext::AsIPCTabContext() const
{
  return IPCTabContext(FrameIPCTabContext(mOriginAttributes,
                                          mContainingAppId,
                                          mIsMozBrowserElement,
                                          mIsPrerendered,
                                          mPresentationURL,
                                          mShowAccelerators,
                                          mShowFocusRings));
}

static already_AddRefed<mozIApplication>
GetAppForId(uint32_t aAppId)
{
  nsCOMPtr<nsIAppsService> appsService = do_GetService(APPS_SERVICE_CONTRACTID);
  NS_ENSURE_TRUE(appsService, nullptr);

  nsCOMPtr<mozIApplication> app;
  appsService->GetAppByLocalId(aAppId, getter_AddRefs(app));

  return app.forget();
}

MaybeInvalidTabContext::MaybeInvalidTabContext(const IPCTabContext& aParams)
  : mInvalidReason(nullptr)
{
  bool isMozBrowserElement = false;
  bool isPrerendered = false;
  uint32_t containingAppId = NO_APP_ID;
  DocShellOriginAttributes originAttributes;
  nsAutoString presentationURL;
  UIStateChangeType showAccelerators = UIStateChangeType_NoChange;
  UIStateChangeType showFocusRings = UIStateChangeType_NoChange;

  switch(aParams.type()) {
    case IPCTabContext::TPopupIPCTabContext: {
      const PopupIPCTabContext &ipcContext = aParams.get_PopupIPCTabContext();

      TabContext *context;
      if (ipcContext.opener().type() == PBrowserOrId::TPBrowserParent) {
        context = TabParent::GetFrom(ipcContext.opener().get_PBrowserParent());
        if (!context) {
          mInvalidReason = "Child is-browser process tried to "
                           "open a null tab.";
          return;
        }
        if (context->IsMozBrowserElement() &&
            !ipcContext.isMozBrowserElement()) {
          // If the TabParent corresponds to a browser element, then it can only
          // open other browser elements, for security reasons.  We should have
          // checked this before calling the TabContext constructor, so this is
          // a fatal error.
          mInvalidReason = "Child is-browser process tried to "
                           "open a non-browser tab.";
          return;
        }
      } else if (ipcContext.opener().type() == PBrowserOrId::TPBrowserChild) {
        context = static_cast<TabChild*>(ipcContext.opener().get_PBrowserChild());
      } else if (ipcContext.opener().type() == PBrowserOrId::TTabId) {
        // We should never get here because this PopupIPCTabContext is only
        // used for allocating a new tab id, not for allocating a PBrowser.
        mInvalidReason = "Child process tried to open an tab without the opener information.";
        return;
      } else {
        // This should be unreachable because PopupIPCTabContext::opener is not a
        // nullable field.
        mInvalidReason = "PopupIPCTabContext::opener was null (?!).";
        return;
      }

      // Browser elements can't nest other browser elements.  So if
      // our opener is browser element, we must be a new DOM window
      // opened by it.  In that case we inherit our containing app ID
      // (if any).
      //
      // Otherwise, we're a new app window and we inherit from our
      // opener app.
      isMozBrowserElement = ipcContext.isMozBrowserElement();
      originAttributes = context->mOriginAttributes;
      if (isMozBrowserElement) {
        containingAppId = context->OwnOrContainingAppId();
      } else {
        containingAppId = context->mContainingAppId;
      }
      break;
    }
    case IPCTabContext::TFrameIPCTabContext: {
      const FrameIPCTabContext &ipcContext =
        aParams.get_FrameIPCTabContext();

      isMozBrowserElement = ipcContext.isMozBrowserElement();
      isPrerendered = ipcContext.isPrerendered();
      containingAppId = ipcContext.frameOwnerAppId();
      presentationURL = ipcContext.presentationURL();
      showAccelerators = ipcContext.showAccelerators();
      showFocusRings = ipcContext.showFocusRings();
      originAttributes = ipcContext.originAttributes();
      break;
    }
    case IPCTabContext::TUnsafeIPCTabContext: {
      // XXXcatalinb: This used *only* by ServiceWorkerClients::OpenWindow.
      // It is meant as a temporary solution until service workers can
      // provide a TabChild equivalent. Don't allow this on b2g since
      // it might be used to escalate privileges.
#ifdef MOZ_B2G
      mInvalidReason = "ServiceWorkerClients::OpenWindow is not supported.";
      return;
#endif
      if (!Preferences::GetBool("dom.serviceWorkers.enabled", false)) {
        mInvalidReason = "ServiceWorkers should be enabled.";
        return;
      }

      containingAppId = NO_APP_ID;
      break;
    }
    default: {
      MOZ_CRASH();
    }
  }

  nsCOMPtr<mozIApplication> ownApp;
  if (!isMozBrowserElement) {
    // mAppId corresponds to OwnOrContainingAppId; if isMozBrowserElement is
    // false then it's ownApp otherwise it's containingApp
    ownApp = GetAppForId(originAttributes.mAppId);
    if ((ownApp == nullptr) != (originAttributes.mAppId == NO_APP_ID)) {
      mInvalidReason = "Got an ownAppId that didn't correspond to an app.";
      return;
    }
  }

  nsCOMPtr<mozIApplication> containingApp = GetAppForId(containingAppId);
  if ((containingApp == nullptr) != (containingAppId == NO_APP_ID)) {
    mInvalidReason = "Got a containingAppId that didn't correspond to an app.";
    return;
  }

  bool rv;
  rv = mTabContext.SetTabContext(isMozBrowserElement,
                                 isPrerendered,
                                 ownApp,
                                 containingApp,
                                 showAccelerators,
                                 showFocusRings,
                                 originAttributes,
                                 presentationURL);
  if (!rv) {
    mInvalidReason = "Couldn't initialize TabContext.";
  }
}

bool
MaybeInvalidTabContext::IsValid()
{
  return mInvalidReason == nullptr;
}

const char*
MaybeInvalidTabContext::GetInvalidReason()
{
  return mInvalidReason;
}

const TabContext&
MaybeInvalidTabContext::GetTabContext()
{
  if (!IsValid()) {
    MOZ_CRASH("Can't GetTabContext() if !IsValid().");
  }

  return mTabContext;
}

} // namespace dom
} // namespace mozilla
