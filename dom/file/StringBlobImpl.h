/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_StringBlobImpl_h
#define mozilla_dom_StringBlobImpl_h

#include "BaseBlobImpl.h"

namespace mozilla::dom {

class StringBlobImpl final : public BaseBlobImpl {
 public:
  NS_INLINE_DECL_REFCOUNTING_INHERITED(StringBlobImpl, BaseBlobImpl)

  static already_AddRefed<StringBlobImpl> Create(const nsACString& aData,
                                                 const nsAString& aContentType);

  void CreateInputStream(nsIInputStream** aStream,
                         ErrorResult& aRv) const override;

  already_AddRefed<BlobImpl> CreateSlice(uint64_t aStart, uint64_t aLength,
                                         const nsAString& aContentType,
                                         ErrorResult& aRv) const override;

  size_t GetAllocationSize() const override { return mData.Length(); }

  size_t GetAllocationSize(
      FallibleTArray<BlobImpl*>& aVisitedBlobImpls) const override {
    return GetAllocationSize();
  }

  void GetBlobImplType(nsAString& aBlobImplType) const override {
    aBlobImplType = u"StringBlobImpl"_ns;
  }

 private:
  StringBlobImpl(const nsACString& aData, const nsAString& aContentType);

  ~StringBlobImpl() override;

  nsresult CollectReports(nsIHandleReportCallback* aHandleReport,
                          nsISupports* aData, bool aAnonymize) override;

  nsCString mData;
};

}  // namespace mozilla::dom

#endif  // mozilla_dom_StringBlobImpl_h
