/* -*- mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "OfflineCacheUpdateGlue.h"
#include "nsOfflineCacheUpdate.h"
#include "mozilla/Services.h"

#include "nsIApplicationCache.h"
#include "nsIApplicationCacheChannel.h"
#include "nsIChannel.h"
#include "mozilla/dom/Document.h"
#include "mozilla/Logging.h"

using mozilla::dom::Document;

//
// To enable logging (see mozilla/Logging.h for full details):
//
//    set MOZ_LOG=nsOfflineCacheUpdate:5
//    set MOZ_LOG_FILE=offlineupdate.log
//
// this enables LogLevel::Info level information and places all output in
// the file offlineupdate.log
//
extern mozilla::LazyLogModule gOfflineCacheUpdateLog;

#undef LOG
#define LOG(args) \
  MOZ_LOG(gOfflineCacheUpdateLog, mozilla::LogLevel::Debug, args)

#undef LOG_ENABLED
#define LOG_ENABLED() \
  MOZ_LOG_TEST(gOfflineCacheUpdateLog, mozilla::LogLevel::Debug)

namespace mozilla {
namespace docshell {

//-----------------------------------------------------------------------------
// OfflineCacheUpdateGlue::nsISupports
//-----------------------------------------------------------------------------

NS_IMPL_ISUPPORTS(OfflineCacheUpdateGlue, nsIOfflineCacheUpdate,
                  nsIOfflineCacheUpdateObserver, nsISupportsWeakReference)

//-----------------------------------------------------------------------------
// OfflineCacheUpdateGlue <public>
//-----------------------------------------------------------------------------

OfflineCacheUpdateGlue::OfflineCacheUpdateGlue() : mCoalesced(false) {
  LOG(("OfflineCacheUpdateGlue::OfflineCacheUpdateGlue [%p]", this));
}

OfflineCacheUpdateGlue::~OfflineCacheUpdateGlue() {
  LOG(("OfflineCacheUpdateGlue::~OfflineCacheUpdateGlue [%p]", this));
}

nsIOfflineCacheUpdate* OfflineCacheUpdateGlue::EnsureUpdate() {
  if (!mUpdate) {
    mUpdate = new nsOfflineCacheUpdate();
    LOG(("OfflineCacheUpdateGlue [%p] is using update [%p]", this,
         mUpdate.get()));

    mUpdate->SetCookieJarSettings(mCookieJarSettings);
  }

  return mUpdate;
}

NS_IMETHODIMP
OfflineCacheUpdateGlue::Schedule() {
  nsCOMPtr<nsIObserverService> observerService =
      mozilla::services::GetObserverService();
  if (observerService) {
    LOG(("Calling offline-cache-update-added"));
    observerService->NotifyObservers(static_cast<nsIOfflineCacheUpdate*>(this),
                                     "offline-cache-update-added", nullptr);
    LOG(("Done offline-cache-update-added"));
  }

  if (!EnsureUpdate()) return NS_ERROR_NULL_POINTER;

  // Do not use weak reference, we must survive!
  mUpdate->AddObserver(this, false);

  if (mCoalesced)  // already scheduled
    return NS_OK;

  return mUpdate->Schedule();
}

NS_IMETHODIMP
OfflineCacheUpdateGlue::Init(nsIURI* aManifestURI, nsIURI* aDocumentURI,
                             nsIPrincipal* aLoadingPrincipal,
                             Document* aDocument, nsIFile* aCustomProfileDir) {
  nsresult rv;

  nsAutoCString originSuffix;
  rv = aLoadingPrincipal->GetOriginSuffix(originSuffix);
  NS_ENSURE_SUCCESS(rv, rv);

  nsOfflineCacheUpdateService* service =
      nsOfflineCacheUpdateService::EnsureService();
  if (service) {
    service->FindUpdate(aManifestURI, originSuffix, aCustomProfileDir,
                        getter_AddRefs(mUpdate));
    mCoalesced = !!mUpdate;
  }

  if (!EnsureUpdate()) return NS_ERROR_NULL_POINTER;

  mDocumentURI = aDocumentURI;
  mLoadingPrincipal = aLoadingPrincipal;

  if (aDocument) SetDocument(aDocument);

  if (mCoalesced) {  // already initialized
    LOG(("OfflineCacheUpdateGlue %p coalesced with update %p", this,
         mUpdate.get()));
    return NS_OK;
  }

  rv = mUpdate->Init(aManifestURI, aDocumentURI, aLoadingPrincipal, nullptr,
                     aCustomProfileDir);

  mUpdate->SetCookieJarSettings(mCookieJarSettings);

  return rv;
}

void OfflineCacheUpdateGlue::SetDocument(Document* aDocument) {
  // The design is one document for one cache update on the content process.
  NS_ASSERTION(!mDocument,
               "Setting more then a single document on an instance of "
               "OfflineCacheUpdateGlue");

  LOG(("Document %p added to update glue %p", aDocument, this));

  // Add document only if it was not loaded from an offline cache.
  // If it were loaded from an offline cache then it has already
  // been associated with it and must not be again cached as
  // implicit (which are the reasons we collect documents here).
  if (!aDocument) return;

  mCookieJarSettings = aDocument->CookieJarSettings();

  nsIChannel* channel = aDocument->GetChannel();
  nsCOMPtr<nsIApplicationCacheChannel> appCacheChannel =
      do_QueryInterface(channel);
  if (!appCacheChannel) return;

  bool loadedFromAppCache;
  appCacheChannel->GetLoadedFromApplicationCache(&loadedFromAppCache);
  if (loadedFromAppCache) return;

  if (EnsureUpdate()) {
    mUpdate->StickDocument(mDocumentURI);
  }

  mDocument = aDocument;
}

NS_IMETHODIMP
OfflineCacheUpdateGlue::UpdateStateChanged(nsIOfflineCacheUpdate* aUpdate,
                                           uint32_t state) {
  if (state == nsIOfflineCacheUpdateObserver::STATE_FINISHED) {
    LOG(("OfflineCacheUpdateGlue got STATE_FINISHED [%p]", this));

    nsCOMPtr<nsIObserverService> observerService =
        mozilla::services::GetObserverService();
    if (observerService) {
      LOG(("Calling offline-cache-update-completed"));
      observerService->NotifyObservers(
          static_cast<nsIOfflineCacheUpdate*>(this),
          "offline-cache-update-completed", nullptr);
      LOG(("Done offline-cache-update-completed"));
    }

    aUpdate->RemoveObserver(this);
  }

  return NS_OK;
}

NS_IMETHODIMP
OfflineCacheUpdateGlue::ApplicationCacheAvailable(
    nsIApplicationCache* aApplicationCache) {
  NS_ENSURE_ARG(aApplicationCache);

  // Check that the document that requested this update was
  // previously associated with an application cache.  If not, it
  // should be associated with the new one.
  if (!mDocument) {
    return NS_OK;
  }

  nsCOMPtr<nsIApplicationCache> existingCache;
  nsresult rv = mDocument->GetApplicationCache(getter_AddRefs(existingCache));
  NS_ENSURE_SUCCESS(rv, rv);

  if (!existingCache) {
    if (LOG_ENABLED()) {
      nsAutoCString clientID;
      if (aApplicationCache) {
        aApplicationCache->GetClientID(clientID);
      }
      LOG(("Update %p: associating app cache %s to document %p", this,
           clientID.get(), mDocument.get()));
    }

    rv = mDocument->SetApplicationCache(aApplicationCache);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  return NS_OK;
}

}  // namespace docshell
}  // namespace mozilla
