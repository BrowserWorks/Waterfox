/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef LoadContext_h
#define LoadContext_h

#include "SerializedLoadContext.h"
#include "mozilla/Attributes.h"
#include "mozilla/BasePrincipal.h"
#include "nsIWeakReferenceUtils.h"
#include "mozilla/dom/Element.h"
#include "nsIInterfaceRequestor.h"
#include "nsILoadContext.h"

namespace mozilla {

/**
 * Class that provides nsILoadContext info in Parent process.  Typically copied
 * from Child via SerializedLoadContext.
 *
 * Note: this is not the "normal" or "original" nsILoadContext.  That is
 * typically provided by nsDocShell.  This is only used when the original
 * docshell is in a different process and we need to copy certain values from
 * it.
 */

class LoadContext final
  : public nsILoadContext
  , public nsIInterfaceRequestor
{
public:
  NS_DECL_ISUPPORTS
  NS_DECL_NSILOADCONTEXT
  NS_DECL_NSIINTERFACEREQUESTOR

  // appId/inIsolatedMozBrowser arguments override those in SerializedLoadContext
  // provided by child process.
  LoadContext(const IPC::SerializedLoadContext& aToCopy,
              dom::Element* aTopFrameElement,
              OriginAttributes& aAttrs)
    : mTopFrameElement(do_GetWeakReference(aTopFrameElement))
    , mNestedFrameId(0)
    , mIsContent(aToCopy.mIsContent)
    , mUseRemoteTabs(aToCopy.mUseRemoteTabs)
    , mUseTrackingProtection(aToCopy.mUseTrackingProtection)
    , mOriginAttributes(aAttrs)
#ifdef DEBUG
    , mIsNotNull(aToCopy.mIsNotNull)
#endif
  {
  }

  // appId/inIsolatedMozBrowser arguments override those in SerializedLoadContext
  // provided by child process.
  LoadContext(const IPC::SerializedLoadContext& aToCopy,
              uint64_t aNestedFrameId,
              OriginAttributes& aAttrs)
    : mTopFrameElement(nullptr)
    , mNestedFrameId(aNestedFrameId)
    , mIsContent(aToCopy.mIsContent)
    , mUseRemoteTabs(aToCopy.mUseRemoteTabs)
    , mUseTrackingProtection(aToCopy.mUseTrackingProtection)
    , mOriginAttributes(aAttrs)
#ifdef DEBUG
    , mIsNotNull(aToCopy.mIsNotNull)
#endif
  {
  }

  LoadContext(dom::Element* aTopFrameElement,
              bool aIsContent,
              bool aUsePrivateBrowsing,
              bool aUseRemoteTabs,
              bool aUseTrackingProtection,
              const OriginAttributes& aAttrs)
    : mTopFrameElement(do_GetWeakReference(aTopFrameElement))
    , mNestedFrameId(0)
    , mIsContent(aIsContent)
    , mUseRemoteTabs(aUseRemoteTabs)
    , mUseTrackingProtection(aUseTrackingProtection)
    , mOriginAttributes(aAttrs)
#ifdef DEBUG
    , mIsNotNull(true)
#endif
  {
    MOZ_DIAGNOSTIC_ASSERT(aUsePrivateBrowsing == (aAttrs.mPrivateBrowsingId > 0));
  }

  // Constructor taking reserved origin attributes.
  explicit LoadContext(OriginAttributes& aAttrs)
    : mTopFrameElement(nullptr)
    , mNestedFrameId(0)
    , mIsContent(false)
    , mUseRemoteTabs(false)
    , mUseTrackingProtection(false)
    , mOriginAttributes(aAttrs)
#ifdef DEBUG
    , mIsNotNull(true)
#endif
  {
  }

  // Constructor for creating a LoadContext with a given principal's appId and
  // browser flag.
  explicit LoadContext(nsIPrincipal* aPrincipal,
                       nsILoadContext* aOptionalBase = nullptr);

private:
  ~LoadContext() {}

  nsWeakPtr mTopFrameElement;
  uint64_t mNestedFrameId;
  bool mIsContent;
  bool mUseRemoteTabs;
  bool mUseTrackingProtection;
  OriginAttributes mOriginAttributes;
#ifdef DEBUG
  bool mIsNotNull;
#endif
};

nsresult CreateTestLoadContext(nsISupports *aOuter, REFNSIID aIID, void **aResult);
nsresult CreatePrivateTestLoadContext(nsISupports *aOuter, REFNSIID aIID, void **aResult);

} // namespace mozilla

#endif // LoadContext_h
