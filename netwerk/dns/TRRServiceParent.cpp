/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set sw=2 ts=8 et tw=80 : */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/net/TRRServiceParent.h"

#include "mozilla/ipc/FileDescriptor.h"
#include "mozilla/net/SocketProcessParent.h"
#include "mozilla/psm/PSMIPCTypes.h"
#include "mozilla/Unused.h"
#include "nsICaptivePortalService.h"
#include "nsIParentalControlsService.h"
#include "nsINetworkLinkService.h"
#include "nsIObserverService.h"
#include "nsIOService.h"
#include "TRRService.h"

namespace mozilla {
namespace net {

static const char* gTRRUriCallbackPrefs[] = {
    "network.trr.uri", "network.trr.mode", kRolloutURIPref, kRolloutURIPref,
    nullptr,
};

NS_IMPL_ISUPPORTS(TRRServiceParent, nsIObserver, nsISupportsWeakReference)

void TRRServiceParent::Init() {
  MOZ_ASSERT(gIOService);

  if (!gIOService->SocketProcessReady()) {
    RefPtr<TRRServiceParent> self = this;
    gIOService->CallOrWaitForSocketProcess([self]() { self->Init(); });
    return;
  }

  SocketProcessParent* socketParent = SocketProcessParent::GetSingleton();
  if (!socketParent) {
    return;
  }

  TRRService::AddObserver(this);
  bool captiveIsPassed = TRRService::CheckCaptivePortalIsPassed();
  bool parentalControlEnabled = TRRService::GetParentalControlEnabledInternal();

  nsCOMPtr<nsINetworkLinkService> nls =
      do_GetService(NS_NETWORK_LINK_SERVICE_CONTRACTID);
  nsTArray<nsCString> suffixList;
  if (nls) {
    nls->GetDnsSuffixList(suffixList);
  }

  Preferences::RegisterPrefixCallbacks(TRRServiceParent::PrefsChanged,
                                       gTRRUriCallbackPrefs, this);
  prefsChanged(nullptr);

  Unused << socketParent->SendPTRRServiceConstructor(
      this, captiveIsPassed, parentalControlEnabled, suffixList);
}

NS_IMETHODIMP
TRRServiceParent::Observe(nsISupports* aSubject, const char* aTopic,
                          const char16_t* aData) {
  if (!strcmp(aTopic, kOpenCaptivePortalLoginEvent)) {
    Unused << SendNotifyObserver(
        nsDependentCString(aTopic),
        aData ? nsDependentString(aData) : VoidString());
  } else if (!strcmp(aTopic, NS_CAPTIVE_PORTAL_CONNECTIVITY)) {
    if (!mTRRBLStorageInited) {
      RefPtr<DataStorage> storage =
          DataStorage::Get(DataStorageClass::TRRBlacklist);
      if (storage) {
        nsresult rv = storage->Init(nullptr);
        if (NS_WARN_IF(NS_FAILED(rv))) {
          Unused << SendNotifyObserver(
              nsDependentCString(aTopic),
              aData ? nsDependentString(aData) : VoidString());
          return NS_OK;
        }

        psm::DataStorageEntry entry;
        storage->GetAll(&entry.items());

        RefPtr<TRRServiceParent> self = this;
        nsCString topic(aTopic);
        nsString data(aData);
        rv = storage->AsyncTakeFileDesc(
            [self, entry, topic, data](ipc::FileDescriptor&& aWriteFd) {
              // We need to send this message before
              // NS_CAPTIVE_PORTAL_CONNECTIVITY notification to make sure
              // TRRBLStorage got inited properly.
              Unused << self->SendInitTRRBLStorage(entry, aWriteFd);
              Unused << self->SendNotifyObserver(topic, data);
              self->mTRRBLStorageInited = true;
            });

        if (NS_SUCCEEDED(rv)) {
          return NS_OK;
        }
      }
    }

    Unused << SendNotifyObserver(
        nsDependentCString(aTopic),
        aData ? nsDependentString(aData) : VoidString());
  } else if (!strcmp(aTopic, kClearPrivateData) || !strcmp(aTopic, kPurge)) {
    Unused << SendNotifyObserver(
        nsDependentCString(aTopic),
        aData ? nsDependentString(aData) : VoidString());
  } else if (!strcmp(aTopic, NS_DNS_SUFFIX_LIST_UPDATED_TOPIC) ||
             !strcmp(aTopic, NS_NETWORK_LINK_TOPIC)) {
    nsCOMPtr<nsINetworkLinkService> link = do_QueryInterface(aSubject);
    // The network link service notification normally passes itself as the
    // subject, but some unit tests will sometimes pass a null subject.
    if (link) {
      nsTArray<nsCString> suffixList;
      link->GetDnsSuffixList(suffixList);
      bool platformDisabledTRR = TRRService::CheckPlatformDNSStatus(link);
      Unused << SendUpdatePlatformDNSInformation(suffixList,
                                                 platformDisabledTRR);
    }

    if (!strcmp(aTopic, NS_NETWORK_LINK_TOPIC) && mURISetByDetection) {
      Unused << SendNotifyObserver(
          nsDependentCString(aTopic),
          aData ? nsDependentString(aData) : VoidString());
      CheckURIPrefs();
    }
  }

  return NS_OK;
}

bool TRRServiceParent::MaybeSetPrivateURI(const nsACString& aURI) {
  nsAutoCString newURI(aURI);
  ProcessURITemplate(newURI);

  if (mPrivateURI.Equals(newURI)) {
    return false;
  }

  mPrivateURI = newURI;

  nsCOMPtr<nsIObserverService> obs = mozilla::services::GetObserverService();
  if (obs) {
    obs->NotifyObservers(nullptr, NS_NETWORK_TRR_URI_CHANGED_TOPIC, nullptr);
  }
  return true;
}

void TRRServiceParent::SetDetectedTrrURI(const nsACString& aURI) {
  if (mURIPrefHasUserValue) {
    return;
  }

  mURISetByDetection = MaybeSetPrivateURI(aURI);
  RefPtr<TRRServiceParent> self = this;
  nsCString uri(aURI);
  gIOService->CallOrWaitForSocketProcess(
      [self, uri]() { Unused << self->SendSetDetectedTrrURI(uri); });
}

void TRRServiceParent::GetTrrURI(nsACString& aURI) { aURI = mPrivateURI; }

void TRRServiceParent::UpdateParentalControlEnabled() {
  bool enabled = TRRService::GetParentalControlEnabledInternal();
  RefPtr<TRRServiceParent> self = this;
  gIOService->CallOrWaitForSocketProcess([self, enabled]() {
    Unused << self->SendUpdateParentalControlEnabled(enabled);
  });
}

// static
void TRRServiceParent::PrefsChanged(const char* aName, void* aSelf) {
  static_cast<TRRServiceParent*>(aSelf)->prefsChanged(aName);
}

void TRRServiceParent::prefsChanged(const char* aName) {
  if (!aName || !strcmp(aName, "network.trr.uri") ||
      !strcmp(aName, kRolloutURIPref)) {
    OnTRRURIChange();
  }

  if (!aName || !strcmp(aName, "network.trr.mode") ||
      !strcmp(aName, kRolloutModePref)) {
    OnTRRModeChange();
  }
}

void TRRServiceParent::ActorDestroy(ActorDestroyReason why) {
  Preferences::UnregisterPrefixCallbacks(TRRServiceParent::PrefsChanged,
                                         gTRRUriCallbackPrefs, this);
}

}  // namespace net
}  // namespace mozilla
