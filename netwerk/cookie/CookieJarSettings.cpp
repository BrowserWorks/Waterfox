/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/AntiTrackingUtils.h"
#include "mozilla/ClearOnShutdown.h"
#include "mozilla/ContentBlockingAllowList.h"
#include "mozilla/dom/BrowsingContext.h"
#include "mozilla/net/CookieJarSettings.h"
#include "mozilla/net/NeckoChannelParams.h"
#include "mozilla/Permission.h"
#include "mozilla/PermissionManager.h"
#include "mozilla/SchedulerGroup.h"
#include "mozilla/StaticPrefs_network.h"
#include "mozilla/Unused.h"
#include "nsGlobalWindowInner.h"
#include "nsIPrincipal.h"
#if defined(MOZ_THUNDERBIRD) || defined(MOZ_SUITE)
#  include "nsIProtocolHandler.h"
#endif
#include "nsICookieManager.h"
#include "nsICookieService.h"
#include "nsNetUtil.h"

namespace mozilla {
namespace net {

static StaticRefPtr<CookieJarSettings> sBlockinAll;

namespace {

class PermissionComparator {
 public:
  static bool Equals(nsIPermission* aA, nsIPermission* aB) {
    nsCOMPtr<nsIPrincipal> principalA;
    nsresult rv = aA->GetPrincipal(getter_AddRefs(principalA));
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return false;
    }

    nsCOMPtr<nsIPrincipal> principalB;
    rv = aB->GetPrincipal(getter_AddRefs(principalB));
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return false;
    }

    bool equals = false;
    rv = principalA->Equals(principalB, &equals);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return false;
    }

    return equals;
  }
};

class ReleaseCookiePermissions final : public Runnable {
 public:
  explicit ReleaseCookiePermissions(nsTArray<RefPtr<nsIPermission>>& aArray)
      : Runnable("ReleaseCookiePermissions") {
    mArray.SwapElements(aArray);
  }

  NS_IMETHOD Run() override {
    MOZ_ASSERT(NS_IsMainThread());
    mArray.Clear();
    return NS_OK;
  }

 private:
  nsTArray<RefPtr<nsIPermission>> mArray;
};

}  // namespace

// static
already_AddRefed<nsICookieJarSettings> CookieJarSettings::GetBlockingAll() {
  MOZ_ASSERT(NS_IsMainThread());

  if (sBlockinAll) {
    return do_AddRef(sBlockinAll);
  }

  sBlockinAll =
      new CookieJarSettings(nsICookieService::BEHAVIOR_REJECT,
                            OriginAttributes::IsFirstPartyEnabled(), eFixed);
  ClearOnShutdown(&sBlockinAll);

  return do_AddRef(sBlockinAll);
}

// static
already_AddRefed<nsICookieJarSettings> CookieJarSettings::Create() {
  MOZ_ASSERT(NS_IsMainThread());

  RefPtr<CookieJarSettings> cookieJarSettings = new CookieJarSettings(
      nsICookieManager::GetCookieBehavior(),
      OriginAttributes::IsFirstPartyEnabled(), eProgressive);
  return cookieJarSettings.forget();
}

// static
already_AddRefed<nsICookieJarSettings> CookieJarSettings::Create(
    uint32_t aCookieBehavior, const nsAString& aFirstPartyDomain,
    bool aIsFirstPartyIsolated, bool aIsOnContentBlockingAllowList) {
  MOZ_ASSERT(NS_IsMainThread());

  RefPtr<CookieJarSettings> cookieJarSettings = new CookieJarSettings(
      aCookieBehavior, aIsFirstPartyIsolated, eProgressive);
  cookieJarSettings->mFirstPartyDomain = aFirstPartyDomain;
  cookieJarSettings->mIsOnContentBlockingAllowList =
      aIsOnContentBlockingAllowList;

  return cookieJarSettings.forget();
}

CookieJarSettings::CookieJarSettings(uint32_t aCookieBehavior,
                                     bool aIsFirstPartyIsolated, State aState)
    : mCookieBehavior(aCookieBehavior),
      mIsFirstPartyIsolated(aIsFirstPartyIsolated),
      mIsOnContentBlockingAllowList(false),
      mState(aState),
      mToBeMerged(false) {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT_IF(
      mIsFirstPartyIsolated,
      mCookieBehavior !=
          nsICookieService::BEHAVIOR_REJECT_TRACKER_AND_PARTITION_FOREIGN);
}

CookieJarSettings::~CookieJarSettings() {
  if (!NS_IsMainThread() && !mCookiePermissions.IsEmpty()) {
    RefPtr<Runnable> r = new ReleaseCookiePermissions(mCookiePermissions);
    MOZ_ASSERT(mCookiePermissions.IsEmpty());

    SchedulerGroup::Dispatch(TaskCategory::Other, r.forget());
  }
}

NS_IMETHODIMP
CookieJarSettings::GetCookieBehavior(uint32_t* aCookieBehavior) {
  *aCookieBehavior = mCookieBehavior;
  return NS_OK;
}

NS_IMETHODIMP
CookieJarSettings::GetIsFirstPartyIsolated(bool* aIsFirstPartyIsolated) {
  *aIsFirstPartyIsolated = mIsFirstPartyIsolated;
  return NS_OK;
}

NS_IMETHODIMP
CookieJarSettings::GetRejectThirdPartyContexts(
    bool* aRejectThirdPartyContexts) {
  *aRejectThirdPartyContexts =
      CookieJarSettings::IsRejectThirdPartyContexts(mCookieBehavior);
  return NS_OK;
}

NS_IMETHODIMP
CookieJarSettings::GetLimitForeignContexts(bool* aLimitForeignContexts) {
  *aLimitForeignContexts =
      mCookieBehavior == nsICookieService::BEHAVIOR_LIMIT_FOREIGN ||
      (StaticPrefs::privacy_dynamic_firstparty_limitForeign() &&
       mCookieBehavior ==
           nsICookieService::BEHAVIOR_REJECT_TRACKER_AND_PARTITION_FOREIGN);
  return NS_OK;
}

NS_IMETHODIMP
CookieJarSettings::GetPartitionForeign(bool* aPartitionForeign) {
  *aPartitionForeign =
      mCookieBehavior ==
      nsICookieService::BEHAVIOR_REJECT_TRACKER_AND_PARTITION_FOREIGN;
  return NS_OK;
}

NS_IMETHODIMP
CookieJarSettings::SetPartitionForeign(bool aPartitionForeign) {
  if (mIsFirstPartyIsolated) {
    return NS_OK;
  }

  if (aPartitionForeign) {
    mCookieBehavior =
        nsICookieService::BEHAVIOR_REJECT_TRACKER_AND_PARTITION_FOREIGN;
  }
  return NS_OK;
}

NS_IMETHODIMP
CookieJarSettings::GetIsOnContentBlockingAllowList(
    bool* aIsOnContentBlockingAllowList) {
  *aIsOnContentBlockingAllowList = mIsOnContentBlockingAllowList;
  return NS_OK;
}

NS_IMETHODIMP
CookieJarSettings::GetFirstPartyDomain(nsAString& aFirstPartyDomain) {
  aFirstPartyDomain = mFirstPartyDomain;
  return NS_OK;
}

NS_IMETHODIMP
CookieJarSettings::CookiePermission(nsIPrincipal* aPrincipal,
                                    uint32_t* aCookiePermission) {
  MOZ_ASSERT(NS_IsMainThread());
  NS_ENSURE_ARG_POINTER(aPrincipal);
  NS_ENSURE_ARG_POINTER(aCookiePermission);

  *aCookiePermission = nsIPermissionManager::UNKNOWN_ACTION;

  nsresult rv;

  // Let's see if we know this permission.
  if (!mCookiePermissions.IsEmpty()) {
    nsCOMPtr<nsIPrincipal> principal =
        Permission::ClonePrincipalForPermission(aPrincipal);
    if (NS_WARN_IF(!principal)) {
      return NS_ERROR_FAILURE;
    }

    for (const RefPtr<nsIPermission>& permission : mCookiePermissions) {
      bool match = false;
      rv = permission->MatchesPrincipalForPermission(principal, false, &match);
      if (NS_WARN_IF(NS_FAILED(rv)) || !match) {
        continue;
      }

      rv = permission->GetCapability(aCookiePermission);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }

      return NS_OK;
    }
  }

  // Let's ask the permission manager.
  PermissionManager* pm = PermissionManager::GetInstance();
  if (NS_WARN_IF(!pm)) {
    return NS_ERROR_FAILURE;
  }

#if defined(MOZ_THUNDERBIRD) || defined(MOZ_SUITE)
  // Check if this protocol doesn't allow cookies.
  bool hasFlags;
  nsCOMPtr<nsIURI> uri;
  BasePrincipal::Cast(aPrincipal)->GetURI(getter_AddRefs(uri));

  rv = NS_URIChainHasFlags(uri, nsIProtocolHandler::URI_FORBIDS_COOKIE_ACCESS,
                           &hasFlags);
  if (NS_FAILED(rv) || hasFlags) {
    *aCookiePermission = PermissionManager::DENY_ACTION;
    rv = NS_OK;  // Reset, so it's not caught as a bad status after the `else`.
  } else         // Note the tricky `else` which controls the call below.
#endif

    rv = pm->TestPermissionFromPrincipal(
        aPrincipal, NS_LITERAL_CSTRING("cookie"), aCookiePermission);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  // Let's store the permission, also if the result is UNKNOWN in order to avoid
  // race conditions.

  nsCOMPtr<nsIPermission> permission = Permission::Create(
      aPrincipal, NS_LITERAL_CSTRING("cookie"), *aCookiePermission, 0, 0, 0);
  if (permission) {
    mCookiePermissions.AppendElement(permission);
  }

  mToBeMerged = true;
  return NS_OK;
}

void CookieJarSettings::Serialize(CookieJarSettingsArgs& aData) {
  MOZ_ASSERT(NS_IsMainThread());

  aData.isFixed() = mState == eFixed;
  aData.cookieBehavior() = mCookieBehavior;
  aData.isFirstPartyIsolated() = mIsFirstPartyIsolated;
  aData.isOnContentBlockingAllowList() = mIsOnContentBlockingAllowList;
  aData.firstPartyDomain() = mFirstPartyDomain;

  for (const RefPtr<nsIPermission>& permission : mCookiePermissions) {
    nsCOMPtr<nsIPrincipal> principal;
    nsresult rv = permission->GetPrincipal(getter_AddRefs(principal));
    if (NS_WARN_IF(NS_FAILED(rv))) {
      continue;
    }

    ipc::PrincipalInfo principalInfo;
    rv = PrincipalToPrincipalInfo(principal, &principalInfo,
                                  true /* aSkipBaseDomain */);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      continue;
    }

    uint32_t cookiePermission = 0;
    rv = permission->GetCapability(&cookiePermission);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      continue;
    }

    aData.cookiePermissions().AppendElement(
        CookiePermissionData(principalInfo, cookiePermission));
  }

  mToBeMerged = false;
}

/* static */ void CookieJarSettings::Deserialize(
    const CookieJarSettingsArgs& aData,
    nsICookieJarSettings** aCookieJarSettings) {
  MOZ_ASSERT(NS_IsMainThread());

  CookiePermissionList list;
  for (const CookiePermissionData& data : aData.cookiePermissions()) {
    auto principalOrErr = PrincipalInfoToPrincipal(data.principalInfo());
    if (NS_WARN_IF(principalOrErr.isErr())) {
      continue;
    }

    nsCOMPtr<nsIPrincipal> principal = principalOrErr.unwrap();

    nsCOMPtr<nsIPermission> permission =
        Permission::Create(principal, NS_LITERAL_CSTRING("cookie"),
                           data.cookiePermission(), 0, 0, 0);
    if (NS_WARN_IF(!permission)) {
      continue;
    }

    list.AppendElement(permission);
  }

  RefPtr<CookieJarSettings> cookieJarSettings = new CookieJarSettings(
      aData.cookieBehavior(), aData.isFirstPartyIsolated(),
      aData.isFixed() ? eFixed : eProgressive);

  cookieJarSettings->mIsOnContentBlockingAllowList =
      aData.isOnContentBlockingAllowList();
  cookieJarSettings->mCookiePermissions.SwapElements(list);
  cookieJarSettings->mFirstPartyDomain = aData.firstPartyDomain();

  cookieJarSettings.forget(aCookieJarSettings);
}

void CookieJarSettings::Merge(const CookieJarSettingsArgs& aData) {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(
      mCookieBehavior == aData.cookieBehavior() ||
      (mCookieBehavior == nsICookieService::BEHAVIOR_REJECT_TRACKER &&
       aData.cookieBehavior() ==
           nsICookieService::BEHAVIOR_REJECT_TRACKER_AND_PARTITION_FOREIGN) ||
      (mCookieBehavior ==
           nsICookieService::BEHAVIOR_REJECT_TRACKER_AND_PARTITION_FOREIGN &&
       aData.cookieBehavior() == nsICookieService::BEHAVIOR_REJECT_TRACKER));

  if (mState == eFixed) {
    return;
  }

  // Merge cookie behavior pref values
  if (mCookieBehavior == nsICookieService::BEHAVIOR_REJECT_TRACKER &&
      aData.cookieBehavior() ==
          nsICookieService::BEHAVIOR_REJECT_TRACKER_AND_PARTITION_FOREIGN) {
    // If the other side has decided to partition third-party cookies, update
    // our side when first-party isolation is disabled.
    if (!mIsFirstPartyIsolated) {
      mCookieBehavior =
          nsICookieService::BEHAVIOR_REJECT_TRACKER_AND_PARTITION_FOREIGN;
    }
  }
  if (mCookieBehavior ==
          nsICookieService::BEHAVIOR_REJECT_TRACKER_AND_PARTITION_FOREIGN &&
      aData.cookieBehavior() == nsICookieService::BEHAVIOR_REJECT_TRACKER) {
    // If we've decided to partition third-party cookies, the other side may not
    // have caught up yet unless it has first-party isolation enabled.
    if (aData.isFirstPartyIsolated()) {
      mCookieBehavior = nsICookieService::BEHAVIOR_REJECT_TRACKER;
      mIsFirstPartyIsolated = true;
    }
  }
  // Ignore all other cases.
  MOZ_ASSERT_IF(
      mIsFirstPartyIsolated,
      mCookieBehavior !=
          nsICookieService::BEHAVIOR_REJECT_TRACKER_AND_PARTITION_FOREIGN);

  PermissionComparator comparator;

  for (const CookiePermissionData& data : aData.cookiePermissions()) {
    auto principalOrErr = PrincipalInfoToPrincipal(data.principalInfo());
    if (NS_WARN_IF(principalOrErr.isErr())) {
      continue;
    }

    nsCOMPtr<nsIPrincipal> principal = principalOrErr.unwrap();
    nsCOMPtr<nsIPermission> permission =
        Permission::Create(principal, NS_LITERAL_CSTRING("cookie"),
                           data.cookiePermission(), 0, 0, 0);
    if (NS_WARN_IF(!permission)) {
      continue;
    }

    if (!mCookiePermissions.Contains(permission, comparator)) {
      mCookiePermissions.AppendElement(permission);
    }
  }
}

void CookieJarSettings::SetFirstPartyDomain(nsIURI* aURI) {
  MOZ_ASSERT(aURI);

  OriginAttributes attrs;
  attrs.SetFirstPartyDomain(true, aURI, true);
  mFirstPartyDomain = std::move(attrs.mFirstPartyDomain);
}

void CookieJarSettings::UpdateIsOnContentBlockingAllowList(
    nsIChannel* aChannel) {
  MOZ_DIAGNOSTIC_ASSERT(XRE_IsParentProcess());
  MOZ_ASSERT(aChannel);
  nsCOMPtr<nsILoadInfo> loadInfo = aChannel->LoadInfo();

  nsCOMPtr<nsIURI> uri;
  nsresult rv = aChannel->GetURI(getter_AddRefs(uri));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return;
  }

  // We need to recompute the ContentBlockingAllowListPrincipal here for the
  // top level channel because we might navigate from the the initial
  // about:blank page or the existing page which may have a different origin
  // than the URI we are going to load here. Thus, we need to recompute the
  // prinicpal in order to get the correct ContentBlockingAllowListPrincipal.
  nsCOMPtr<nsIPrincipal> contentBlockingAllowListPrincipal;
  OriginAttributes attrs;
  loadInfo->GetOriginAttributes(&attrs);
  ContentBlockingAllowList::RecomputePrincipal(
      uri, attrs, getter_AddRefs(contentBlockingAllowListPrincipal));

  if (!contentBlockingAllowListPrincipal ||
      !contentBlockingAllowListPrincipal->GetIsContentPrincipal()) {
    return;
  }

  Unused << ContentBlockingAllowList::Check(contentBlockingAllowListPrincipal,
                                            NS_UsePrivateBrowsing(aChannel),
                                            mIsOnContentBlockingAllowList);
}

// static
bool CookieJarSettings::IsRejectThirdPartyContexts(uint32_t aCookieBehavior) {
  return aCookieBehavior == nsICookieService::BEHAVIOR_REJECT_TRACKER ||
         aCookieBehavior ==
             nsICookieService::BEHAVIOR_REJECT_TRACKER_AND_PARTITION_FOREIGN ||
         IsRejectThirdPartyWithExceptions(aCookieBehavior);
}

// static
bool CookieJarSettings::IsRejectThirdPartyWithExceptions(
    uint32_t aCookieBehavior) {
  return aCookieBehavior == nsICookieService::BEHAVIOR_REJECT_FOREIGN &&
         StaticPrefs::network_cookie_rejectForeignWithExceptions_enabled();
}

NS_IMPL_ISUPPORTS(CookieJarSettings, nsICookieJarSettings)

}  // namespace net
}  // namespace mozilla
