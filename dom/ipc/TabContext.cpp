/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/TabContext.h"
#include "mozilla/dom/PTabContext.h"
#include "mozilla/dom/TabParent.h"
#include "mozilla/dom/TabChild.h"
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
  , mJSPluginID(-1)
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
TabContext::IsMozBrowser() const
{
  return IsMozBrowserElement();
}

bool
TabContext::IsJSPlugin() const
{
  return mJSPluginID >= 0;
}

int32_t
TabContext::JSPluginId() const
{
  return mJSPluginID;
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
  if (aContext.mOriginAttributes != mOriginAttributes) {
    return false;
  }

  mIsMozBrowserElement = aContext.mIsMozBrowserElement;
  return true;
}

const OriginAttributes&
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
                          UIStateChangeType aShowAccelerators,
                          UIStateChangeType aShowFocusRings,
                          const OriginAttributes& aOriginAttributes,
                          const nsAString& aPresentationURL)
{
  NS_ENSURE_FALSE(mInitialized, false);

  // Veryify that app id matches mAppId passed in originAttributes
  MOZ_RELEASE_ASSERT(aOriginAttributes.mAppId == NO_APP_ID);

  mInitialized = true;
  mIsMozBrowserElement = aIsMozBrowserElement;
  mIsPrerendered = aIsPrerendered;
  mOriginAttributes = aOriginAttributes;
  mPresentationURL = aPresentationURL;
  mShowAccelerators = aShowAccelerators;
  mShowFocusRings = aShowFocusRings;
  return true;
}

bool
TabContext::SetTabContextForJSPluginFrame(int32_t aJSPluginID)
{
  NS_ENSURE_FALSE(mInitialized, false);

  mInitialized = true;
  mJSPluginID = aJSPluginID;
  return true;
}

IPCTabContext
TabContext::AsIPCTabContext() const
{
  if (IsJSPlugin()) {
    return IPCTabContext(JSPluginFrameIPCTabContext(mJSPluginID));
  }

  return IPCTabContext(FrameIPCTabContext(mOriginAttributes,
                                          mIsMozBrowserElement,
                                          mIsPrerendered,
                                          mPresentationURL,
                                          mShowAccelerators,
                                          mShowFocusRings));
}

MaybeInvalidTabContext::MaybeInvalidTabContext(const IPCTabContext& aParams)
  : mInvalidReason(nullptr)
{
  bool isMozBrowserElement = false;
  bool isPrerendered = false;
  int32_t jsPluginId = -1;
  OriginAttributes originAttributes;
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
      break;
    }
    case IPCTabContext::TJSPluginFrameIPCTabContext: {
      const JSPluginFrameIPCTabContext &ipcContext =
        aParams.get_JSPluginFrameIPCTabContext();

      jsPluginId = ipcContext.jsPluginId();
      break;
    }
    case IPCTabContext::TFrameIPCTabContext: {
      const FrameIPCTabContext &ipcContext =
        aParams.get_FrameIPCTabContext();

      isMozBrowserElement = ipcContext.isMozBrowserElement();
      isPrerendered = ipcContext.isPrerendered();
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

      break;
    }
    default: {
      MOZ_CRASH();
    }
  }

  bool rv;
  if (jsPluginId >= 0) {
    rv = mTabContext.SetTabContextForJSPluginFrame(jsPluginId);
  } else {
    rv = mTabContext.SetTabContext(isMozBrowserElement,
                                   isPrerendered,
                                   showAccelerators,
                                   showFocusRings,
                                   originAttributes,
                                   presentationURL);
  }
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
