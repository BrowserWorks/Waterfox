/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_LocalStorage_h
#define mozilla_dom_LocalStorage_h

#include "Storage.h"
#include "nsWeakReference.h"

namespace mozilla {
namespace dom {

class LocalStorageCache;
class LocalStorageManager;
class StorageEvent;

class LocalStorage final : public Storage
                         , public nsSupportsWeakReference
{
public:
  NS_DECL_ISUPPORTS_INHERITED
  NS_DECL_CYCLE_COLLECTION_CLASS_INHERITED(LocalStorage, Storage)

  StorageType Type() const override { return eLocalStorage; }

  LocalStorageManager* GetManager() const
  {
    return mManager;
  }

  LocalStorageCache const* GetCache() const
  {
    return mCache;
  }

  bool PrincipalEquals(nsIPrincipal* aPrincipal);

  LocalStorage(nsPIDOMWindowInner* aWindow,
               LocalStorageManager* aManager,
               LocalStorageCache* aCache,
               const nsAString& aDocumentURI,
               nsIPrincipal* aPrincipal,
               bool aIsPrivate);

  bool IsForkOf(const Storage* aOther) const override;

  // WebIDL

  int64_t GetOriginQuotaUsage() const override;

  uint32_t GetLength(nsIPrincipal& aSubjectPrincipal,
                     ErrorResult& aRv) override;

  void Key(uint32_t aIndex, nsAString& aResult,
           nsIPrincipal& aSubjectPrincipal,
           ErrorResult& aRv) override;

  void GetItem(const nsAString& aKey, nsAString& aResult,
               nsIPrincipal& aSubjectPrincipal,
               ErrorResult& aRv) override;

  void GetSupportedNames(nsTArray<nsString>& aKeys) override;

  void SetItem(const nsAString& aKey, const nsAString& aValue,
               nsIPrincipal& aSubjectPrincipal,
               ErrorResult& aRv) override;

  void RemoveItem(const nsAString& aKey,
                  nsIPrincipal& aSubjectPrincipal,
                  ErrorResult& aRv) override;

  void Clear(nsIPrincipal& aSubjectPrincipal,
             ErrorResult& aRv) override;

  bool IsPrivate() const { return mIsPrivate; }

  // aStorage can be null if this method is called by ContentChild.
  //
  // aImmediateDispatch is for use by (main-thread) IPC code so that PContent
  // ordering can be maintained.  Without this, the event would be enqueued and
  // run in a future turn of the event loop, potentially allowing other PContent
  // Recv* methods to trigger script that wants to assume our localstorage
  // changes have already been applied.  This is the case for message manager
  // messages which are used by ContentTask testing logic and webextensions.
  static void
  DispatchStorageEvent(const nsAString& aDocumentURI,
                       const nsAString& aKey,
                       const nsAString& aOldValue,
                       const nsAString& aNewValue,
                       nsIPrincipal* aPrincipal,
                       bool aIsPrivate,
                       Storage* aStorage,
                       bool aImmediateDispatch);

  void
  ApplyEvent(StorageEvent* aStorageEvent);

private:
  ~LocalStorage();

  friend class LocalStorageManager;
  friend class LocalStorageCache;

  RefPtr<LocalStorageManager> mManager;
  RefPtr<LocalStorageCache> mCache;
  nsString mDocumentURI;

  // Principal this Storage (i.e. localStorage or sessionStorage) has
  // been created for
  nsCOMPtr<nsIPrincipal> mPrincipal;

  // Whether this storage is running in private-browsing window.
  bool mIsPrivate : 1;

  void BroadcastChangeNotification(const nsAString& aKey,
                                   const nsAString& aOldValue,
                                   const nsAString& aNewValue);
};

} // namespace dom
} // namespace mozilla

#endif // mozilla_dom_LocalStorage_h
