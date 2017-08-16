/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_Storage_h
#define mozilla_dom_Storage_h

#include "mozilla/Attributes.h"
#include "mozilla/ErrorResult.h"
#include "mozilla/Maybe.h"
#include "nsIDOMStorage.h"
#include "nsCycleCollectionParticipant.h"
#include "nsWeakReference.h"
#include "nsWrapperCache.h"
#include "nsISupports.h"

class nsIPrincipal;
class nsPIDOMWindowInner;

namespace mozilla {
namespace dom {

class Storage : public nsIDOMStorage
              , public nsWrapperCache
{
public:
  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS_AMBIGUOUS(Storage,
                                                         nsIDOMStorage)

  Storage(nsPIDOMWindowInner* aWindow, nsIPrincipal* aPrincipal);

  enum StorageType {
    eSessionStorage,
    eLocalStorage,
  };

  virtual StorageType Type() const = 0;

  virtual bool IsForkOf(const Storage* aStorage) const = 0;

  virtual int64_t GetOriginQuotaUsage() const = 0;

  nsIPrincipal*
  Principal() const
  {
    return mPrincipal;
  }

  // WebIDL
  JSObject* WrapObject(JSContext* aCx,
                       JS::Handle<JSObject*> aGivenProto) override;

  nsPIDOMWindowInner* GetParentObject() const
  {
    return mWindow;
  }

  virtual uint32_t
  GetLength(nsIPrincipal& aSubjectPrincipal, ErrorResult& aRv) = 0;

  virtual void
  Key(uint32_t aIndex, nsAString& aResult,
      nsIPrincipal& aSubjectPrincipal, ErrorResult& aRv) = 0;

  virtual void
  GetItem(const nsAString& aKey, nsAString& aResult,
          nsIPrincipal& aSubjectPrincipal, ErrorResult& aRv) = 0;

  virtual void
  GetSupportedNames(nsTArray<nsString>& aKeys) = 0;

  void NamedGetter(const nsAString& aKey, bool& aFound, nsAString& aResult,
                   nsIPrincipal& aSubjectPrincipal,
                   ErrorResult& aRv)
  {
    GetItem(aKey, aResult, aSubjectPrincipal, aRv);
    aFound = !aResult.IsVoid();
  }

  virtual void
  SetItem(const nsAString& aKey, const nsAString& aValue,
          nsIPrincipal& aSubjectPrincipal, ErrorResult& aRv) = 0;

  void NamedSetter(const nsAString& aKey, const nsAString& aValue,
                   nsIPrincipal& aSubjectPrincipal,
                   ErrorResult& aRv)
  {
    SetItem(aKey, aValue, aSubjectPrincipal, aRv);
  }

  virtual void
  RemoveItem(const nsAString& aKey, nsIPrincipal& aSubjectPrincipal,
             ErrorResult& aRv) = 0;

  void NamedDeleter(const nsAString& aKey, bool& aFound,
                    nsIPrincipal& aSubjectPrincipal,
                    ErrorResult& aRv)
  {
    RemoveItem(aKey, aSubjectPrincipal, aRv);

    aFound = !aRv.ErrorCodeIs(NS_SUCCESS_DOM_NO_OPERATION);
  }

  virtual void
  Clear(nsIPrincipal& aSubjectPrincipal, ErrorResult& aRv) = 0;

  bool IsSessionOnly() const { return mIsSessionOnly; }

  static void
  NotifyChange(Storage* aStorage, nsIPrincipal* aPrincipal,
               const nsAString& aKey, const nsAString& aOldValue,
               const nsAString& aNewValue, const char16_t* aStorageType,
               const nsAString& aDocumentURI, bool aIsPrivate,
               bool aImmediateDispatch);

protected:
  virtual ~Storage();

  // The method checks whether the caller can use a storage.
  // CanUseStorage is called before any DOM initiated operation
  // on a storage is about to happen and ensures that the storage's
  // session-only flag is properly set according the current settings.
  // It is an optimization since the privileges check and session only
  // state determination are complex and share the code (comes hand in
  // hand together).
  bool CanUseStorage(nsIPrincipal& aSubjectPrincipal);

private:
  nsCOMPtr<nsPIDOMWindowInner> mWindow;
  nsCOMPtr<nsIPrincipal> mPrincipal;

  // Whether storage is set to persist data only per session, may change
  // dynamically and is set by CanUseStorage function that is called
  // before any operation on the storage.
  bool mIsSessionOnly : 1;
};

} // namespace dom
} // namespace mozilla

#endif // mozilla_dom_Storage_h
