/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "StringBlobImpl.h"

#include "BlobMemoryReporter.h"
#include "nsStringStream.h"

namespace mozilla::dom {

MOZ_DEFINE_MALLOC_SIZE_OF(StringBlobImplMallocSizeOf)

/* static */
already_AddRefed<StringBlobImpl> StringBlobImpl::Create(
    const nsACString& aData, const nsAString& aContentType) {
  RefPtr<StringBlobImpl> blobImpl = new StringBlobImpl(aData, aContentType);
  BlobMemoryReporter::Register(blobImpl);
  return blobImpl.forget();
}

StringBlobImpl::StringBlobImpl(const nsACString& aData,
                               const nsAString& aContentType)
    : BaseBlobImpl(aContentType, aData.Length()), mData(aData) {}

StringBlobImpl::~StringBlobImpl() { BlobMemoryReporter::Unregister(this); }

already_AddRefed<BlobImpl> StringBlobImpl::CreateSlice(
    uint64_t aStart, uint64_t aLength, const nsAString& aContentType,
    ErrorResult& aRv) const {
  RefPtr<BlobImpl> impl =
      new StringBlobImpl(Substring(mData, aStart, aLength), aContentType);
  BlobMemoryReporter::Register(impl);
  return impl.forget();
}

void StringBlobImpl::CreateInputStream(nsIInputStream** aStream,
                                       ErrorResult& aRv) const {
  aRv = NS_NewCStringInputStream(aStream, mData);
}

nsresult StringBlobImpl::CollectReports(nsIHandleReportCallback* aHandleReport,
                                        nsISupports* aData, bool aAnonymize) {
  MOZ_COLLECT_REPORT(
      "explicit/dom/memory-file-data/string", nsIMemoryReporter::KIND_HEAP,
      nsIMemoryReporter::UNITS_BYTES,
      mData.SizeOfExcludingThisIfUnshared(StringBlobImplMallocSizeOf),
      "Memory used to back a File/Blob based on a string.");
  return NS_OK;
}

}  // namespace mozilla::dom
