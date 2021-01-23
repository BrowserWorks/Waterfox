/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsOfflineCacheUpdateChild_h
#define nsOfflineCacheUpdateChild_h

#include "mozilla/docshell/POfflineCacheUpdateChild.h"
#include "nsIOfflineCacheUpdate.h"

#include "nsCOMArray.h"
#include "nsCOMPtr.h"
#include "mozilla/dom/Document.h"
#include "nsIObserver.h"
#include "nsIObserverService.h"
#include "nsIURI.h"
#include "nsIWeakReference.h"
#include "nsString.h"

class nsPIDOMWindowInner;

namespace mozilla {
namespace docshell {

class OfflineCacheUpdateChild : public nsIOfflineCacheUpdate,
                                public POfflineCacheUpdateChild {
 public:
  NS_DECL_ISUPPORTS
  NS_DECL_NSIOFFLINECACHEUPDATE

  mozilla::ipc::IPCResult RecvNotifyStateEvent(const uint32_t& stateEvent,
                                               const uint64_t& byteProgress);

  mozilla::ipc::IPCResult RecvAssociateDocuments(
      const nsCString& cacheGroupId, const nsCString& cacheClientId);

  mozilla::ipc::IPCResult RecvFinish(const bool& succeeded,
                                     const bool& isUpgrade);

  explicit OfflineCacheUpdateChild(nsPIDOMWindowInner* aWindow);

  void SetDocument(dom::Document* aDocument);

 private:
  ~OfflineCacheUpdateChild();

  nsresult AssociateDocument(dom::Document* aDocument,
                             nsIApplicationCache* aApplicationCache);
  void GatherObservers(nsCOMArray<nsIOfflineCacheUpdateObserver>& aObservers);
  nsresult Finish();

  enum {
    STATE_UNINITIALIZED,
    STATE_INITIALIZED,
    STATE_CHECKING,
    STATE_DOWNLOADING,
    STATE_CANCELLED,
    STATE_FINISHED
  } mState;

  bool mIsUpgrade;
  bool mSucceeded;

  nsCString mUpdateDomain;
  nsCOMPtr<nsIURI> mManifestURI;
  nsCOMPtr<nsIURI> mDocumentURI;
  nsCOMPtr<nsIPrincipal> mLoadingPrincipal;
  nsCOMPtr<nsICookieJarSettings> mCookieJarSettings;

  nsCOMPtr<nsIObserverService> mObserverService;

  /* Clients watching this update for changes */
  nsCOMArray<nsIWeakReference> mWeakObservers;
  nsCOMArray<nsIOfflineCacheUpdateObserver> mObservers;

  /* Document that requested this update */
  nsCOMPtr<dom::Document> mDocument;

  /* Keep reference to the window that owns this update to call the
     parent offline cache update construcor */
  nsCOMPtr<nsPIDOMWindowInner> mWindow;

  uint64_t mByteProgress;
};

}  // namespace docshell
}  // namespace mozilla

#endif
