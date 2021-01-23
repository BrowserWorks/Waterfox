/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_URLSearchParams_h
#define mozilla_dom_URLSearchParams_h

#include "js/StructuredClone.h"
#include "mozilla/dom/BindingDeclarations.h"
#include "mozilla/ErrorResult.h"
#include "nsCycleCollectionParticipant.h"
#include "nsWrapperCache.h"
#include "nsISupports.h"
#include "nsIInputStream.h"

class nsIGlobalObject;

namespace mozilla {
namespace dom {

class URLSearchParams;
class USVStringSequenceSequenceOrUSVStringUSVStringRecordOrUSVString;

class URLSearchParamsObserver : public nsISupports {
 public:
  virtual ~URLSearchParamsObserver() = default;

  virtual void URLSearchParamsUpdated(URLSearchParams* aFromThis) = 0;
};

// This class is used in BasePrincipal and it's _extremely_ important that the
// attributes are kept in the correct order. If this changes, please, update
// BasePrincipal code.

class URLParams final {
 public:
  URLParams() = default;

  ~URLParams() { DeleteAll(); }

  class ForEachIterator {
   public:
    virtual bool URLParamsIterator(const nsAString& aName,
                                   const nsAString& aValue) = 0;
  };

  static bool Parse(const nsACString& aInput, ForEachIterator& aIterator);

  static bool Extract(const nsACString& aInput, const nsAString& aName,
                      nsAString& aValue);

  void ParseInput(const nsACString& aInput);

  void Serialize(nsAString& aValue) const;

  void Get(const nsAString& aName, nsString& aRetval);

  void GetAll(const nsAString& aName, nsTArray<nsString>& aRetval);

  void Set(const nsAString& aName, const nsAString& aValue);

  void Append(const nsAString& aName, const nsAString& aValue);

  bool Has(const nsAString& aName);

  void Delete(const nsAString& aName);

  void DeleteAll() { mParams.Clear(); }

  uint32_t Length() const { return mParams.Length(); }

  const nsAString& GetKeyAtIndex(uint32_t aIndex) const {
    MOZ_ASSERT(aIndex < mParams.Length());
    return mParams[aIndex].mKey;
  }

  const nsAString& GetValueAtIndex(uint32_t aIndex) const {
    MOZ_ASSERT(aIndex < mParams.Length());
    return mParams[aIndex].mValue;
  }

  nsresult Sort();

  bool ReadStructuredClone(JSStructuredCloneReader* aReader);

  bool WriteStructuredClone(JSStructuredCloneWriter* aWriter) const;

 private:
  static void DecodeString(const nsACString& aInput, nsAString& aOutput);
  static void ConvertString(const nsACString& aInput, nsAString& aOutput);

  struct Param {
    nsString mKey;
    nsString mValue;
  };

  nsTArray<Param> mParams;
};

class URLSearchParams final : public nsISupports, public nsWrapperCache {
  ~URLSearchParams();

 public:
  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS(URLSearchParams)

  explicit URLSearchParams(nsISupports* aParent,
                           URLSearchParamsObserver* aObserver = nullptr);

  // WebIDL methods
  nsISupports* GetParentObject() const { return mParent; }

  virtual JSObject* WrapObject(JSContext* aCx,
                               JS::Handle<JSObject*> aGivenProto) override;

  static already_AddRefed<URLSearchParams> Constructor(
      const GlobalObject& aGlobal,
      const USVStringSequenceSequenceOrUSVStringUSVStringRecordOrUSVString&
          aInit,
      ErrorResult& aRv);

  void ParseInput(const nsACString& aInput);

  void Serialize(nsAString& aValue) const;

  void Get(const nsAString& aName, nsString& aRetval);

  void GetAll(const nsAString& aName, nsTArray<nsString>& aRetval);

  void Set(const nsAString& aName, const nsAString& aValue);

  void Append(const nsAString& aName, const nsAString& aValue);

  bool Has(const nsAString& aName);

  void Delete(const nsAString& aName);

  uint32_t GetIterableLength() const;
  const nsAString& GetKeyAtIndex(uint32_t aIndex) const;
  const nsAString& GetValueAtIndex(uint32_t aIndex) const;

  void Sort(ErrorResult& aRv);

  void Stringify(nsString& aRetval) const { Serialize(aRetval); }

  static already_AddRefed<URLSearchParams> ReadStructuredClone(
      JSContext* aCx, nsIGlobalObject* aGlobal,
      JSStructuredCloneReader* aReader);

  bool WriteStructuredClone(JSContext* aCx,
                            JSStructuredCloneWriter* aWriter) const;

  nsresult GetSendInfo(nsIInputStream** aBody, uint64_t* aContentLength,
                       nsACString& aContentTypeWithCharset,
                       nsACString& aCharset) const;

 private:
  void AppendInternal(const nsAString& aName, const nsAString& aValue);

  void DeleteAll();

  void NotifyObserver();

  UniquePtr<URLParams> mParams;
  nsCOMPtr<nsISupports> mParent;
  RefPtr<URLSearchParamsObserver> mObserver;
};

}  // namespace dom
}  // namespace mozilla

#endif /* mozilla_dom_URLSearchParams_h */
