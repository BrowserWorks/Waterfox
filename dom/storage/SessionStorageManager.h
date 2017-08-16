/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_SessionStorageManager_h
#define mozilla_dom_SessionStorageManager_h

#include "nsIDOMStorageManager.h"
#include "nsClassHashtable.h"
#include "nsRefPtrHashtable.h"
#include "StorageObserver.h"

namespace mozilla {
namespace dom {

class SessionStorageCache;

class SessionStorageManager final : public nsIDOMStorageManager
                                  , public StorageObserverSink
{
public:
  SessionStorageManager();

  NS_DECL_ISUPPORTS
  NS_DECL_NSIDOMSTORAGEMANAGER

private:
  ~SessionStorageManager();

  // StorageObserverSink, handler to various chrome clearing notification
  nsresult
  Observe(const char* aTopic,
          const nsAString& aOriginAttributesPattern,
          const nsACString& aOriginScope) override;

  enum ClearStorageType {
    eAll,
    eSessionOnly,
  };

  void
  ClearStorages(ClearStorageType aType,
                const OriginAttributesPattern& aPattern,
                const nsACString& aOriginScope);

  typedef nsRefPtrHashtable<nsCStringHashKey, SessionStorageCache> OriginKeyHashTable;
  nsClassHashtable<nsCStringHashKey, OriginKeyHashTable> mOATable;
};

} // dom namespace
} // mozilla namespace

#endif // mozilla_dom_SessionStorageManager_h
