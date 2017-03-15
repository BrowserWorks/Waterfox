/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/net/CookieServiceParent.h"
#include "mozilla/dom/PContentParent.h"
#include "mozilla/net/NeckoParent.h"

#include "mozilla/BasePrincipal.h"
#include "mozilla/ipc/URIUtils.h"
#include "nsCookieService.h"
#include "nsIChannel.h"
#include "nsIScriptSecurityManager.h"
#include "nsIPrivateBrowsingChannel.h"
#include "nsNetCID.h"
#include "nsPrintfCString.h"

using namespace mozilla::ipc;
using mozilla::BasePrincipal;
using mozilla::NeckoOriginAttributes;
using mozilla::PrincipalOriginAttributes;
using mozilla::dom::PContentParent;
using mozilla::net::NeckoParent;

namespace {

// Ignore failures from this function, as they only affect whether we do or
// don't show a dialog box in private browsing mode if the user sets a pref.
void
CreateDummyChannel(nsIURI* aHostURI, NeckoOriginAttributes& aAttrs, bool aIsPrivate,
                   nsIChannel** aChannel)
{
  MOZ_ASSERT(aAttrs.mAppId != nsIScriptSecurityManager::UNKNOWN_APP_ID);

  PrincipalOriginAttributes attrs;
  attrs.InheritFromNecko(aAttrs);

  nsCOMPtr<nsIPrincipal> principal =
    BasePrincipal::CreateCodebasePrincipal(aHostURI, attrs);
  if (!principal) {
    return;
  }

  nsCOMPtr<nsIURI> dummyURI;
  nsresult rv = NS_NewURI(getter_AddRefs(dummyURI), "about:blank");
  if (NS_FAILED(rv)) {
      return;
  }

  // The following channel is never openend, so it does not matter what
  // securityFlags we pass; let's follow the principle of least privilege.
  nsCOMPtr<nsIChannel> dummyChannel;
  NS_NewChannel(getter_AddRefs(dummyChannel), dummyURI, principal,
                nsILoadInfo::SEC_REQUIRE_SAME_ORIGIN_DATA_IS_BLOCKED,
                nsIContentPolicy::TYPE_INVALID);
  nsCOMPtr<nsIPrivateBrowsingChannel> pbChannel = do_QueryInterface(dummyChannel);
  if (!pbChannel) {
    return;
  }

  pbChannel->SetPrivate(aIsPrivate);
  dummyChannel.forget(aChannel);
  return;
}

}

namespace mozilla {
namespace net {

CookieServiceParent::CookieServiceParent()
{
  // Instantiate the cookieservice via the service manager, so it sticks around
  // until shutdown.
  nsCOMPtr<nsICookieService> cs = do_GetService(NS_COOKIESERVICE_CONTRACTID);

  // Get the nsCookieService instance directly, so we can call internal methods.
  mCookieService =
    already_AddRefed<nsCookieService>(nsCookieService::GetSingleton());
  NS_ASSERTION(mCookieService, "couldn't get nsICookieService");
}

CookieServiceParent::~CookieServiceParent()
{
}

void
CookieServiceParent::ActorDestroy(ActorDestroyReason aWhy)
{
  // Nothing needed here. Called right before destructor since this is a
  // non-refcounted class.
}

bool
CookieServiceParent::RecvGetCookieString(const URIParams& aHost,
                                         const bool& aIsForeign,
                                         const bool& aFromHttp,
                                         const NeckoOriginAttributes& aAttrs,
                                         nsCString* aResult)
{
  if (!mCookieService)
    return true;

  // Deserialize URI. Having a host URI is mandatory and should always be
  // provided by the child; thus we consider failure fatal.
  nsCOMPtr<nsIURI> hostURI = DeserializeURI(aHost);
  if (!hostURI)
    return false;

  bool isPrivate = aAttrs.mPrivateBrowsingId > 0;
  mCookieService->GetCookieStringInternal(hostURI, aIsForeign, aFromHttp, aAttrs,
                                          isPrivate, *aResult);
  return true;
}

bool
CookieServiceParent::RecvSetCookieString(const URIParams& aHost,
                                         const bool& aIsForeign,
                                         const nsCString& aCookieString,
                                         const nsCString& aServerTime,
                                         const bool& aFromHttp,
                                         const NeckoOriginAttributes& aAttrs)
{
  if (!mCookieService)
    return true;

  // Deserialize URI. Having a host URI is mandatory and should always be
  // provided by the child; thus we consider failure fatal.
  nsCOMPtr<nsIURI> hostURI = DeserializeURI(aHost);
  if (!hostURI)
    return false;

  bool isPrivate = aAttrs.mPrivateBrowsingId > 0;

  // This is a gross hack. We've already computed everything we need to know
  // for whether to set this cookie or not, but we need to communicate all of
  // this information through to nsICookiePermission, which indirectly
  // computes the information from the channel. We only care about the
  // aIsPrivate argument as nsCookieService::SetCookieStringInternal deals
  // with aIsForeign before we have to worry about nsCookiePermission trying
  // to use the channel to inspect it.
  nsCOMPtr<nsIChannel> dummyChannel;
  CreateDummyChannel(hostURI, const_cast<NeckoOriginAttributes&>(aAttrs),
                     isPrivate, getter_AddRefs(dummyChannel));

  // NB: dummyChannel could be null if something failed in CreateDummyChannel.
  nsDependentCString cookieString(aCookieString, 0);
  mCookieService->SetCookieStringInternal(hostURI, aIsForeign, cookieString,
                                          aServerTime, aFromHttp, aAttrs,
                                          isPrivate, dummyChannel);
  return true;
}

} // namespace net
} // namespace mozilla

