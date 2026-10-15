/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_BlobImpl_h
#define mozilla_dom_BlobImpl_h

#include "mozilla/ThreadSafeWeakPtr.h"
#include "nsISupports.h"
#include "nsString.h"

#define BLOBIMPL_IID \
  {0xbccb3275, 0x6778, 0x4ac5, {0xaf, 0x03, 0x90, 0xed, 0x37, 0xad, 0xdf, 0x5d}}

class nsIInputStream;

namespace mozilla {
class ErrorResult;

namespace dom {

class SystemCallerGuarantee;
template <typename T>
class Optional;

// This is the abstract class for any File backend. It must be ref-counted and
// implement nsISupports so it can be used with IPC. It also supports
// thread-safe weak references, allowing BlobImpl instances to be used as weak
// keys without keeping them alive (e.g. for IndexedDB blob sharing/dedup).
class BlobImpl : public SupportsThreadSafeWeakPtr<BlobImpl>,
                 public nsISupports {
 public:
  NS_INLINE_DECL_STATIC_IID(BLOBIMPL_IID)
  NS_INLINE_DECL_REFCOUNTING_INHERITED(BlobImpl,
                                       SupportsThreadSafeWeakPtr<BlobImpl>);
  NS_IMETHOD QueryInterface(REFNSIID aIID, void** aInstancePtr) override;
  MOZ_DECLARE_REFCOUNTED_TYPENAME(BlobImpl);

  BlobImpl() = default;

  virtual void GetName(nsAString& aName) const = 0;

  virtual void GetDOMPath(nsAString& aName) const = 0;

  virtual void SetDOMPath(const nsAString& aName) = 0;

  virtual int64_t GetLastModified(ErrorResult& aRv) = 0;

  virtual void GetMozFullPath(nsAString& aName,
                              SystemCallerGuarantee /* unused */,
                              ErrorResult& aRv) = 0;

  virtual void GetMozFullPathInternal(nsAString& aFileName,
                                      ErrorResult& aRv) = 0;

  virtual uint64_t GetSize(ErrorResult& aRv) = 0;

  virtual void GetType(nsAString& aType) = 0;

  virtual void GetBlobImplType(nsAString& aBlobImplType) const = 0;

  virtual size_t GetAllocationSize() const = 0;
  virtual size_t GetAllocationSize(
      FallibleTArray<BlobImpl*>& aVisitedBlobImpls) const = 0;

  /**
   * An effectively-unique serial number identifying this instance of FileImpl.
   *
   * Implementations should obtain a serial number from
   * FileImplBase::NextSerialNumber().
   */
  virtual uint64_t GetSerialNumber() const = 0;

  already_AddRefed<BlobImpl> Slice(const Optional<int64_t>& aStart,
                                   const Optional<int64_t>& aEnd,
                                   const nsAString& aContentType,
                                   ErrorResult& aRv);

  virtual already_AddRefed<BlobImpl> CreateSlice(uint64_t aStart,
                                                 uint64_t aLength,
                                                 const nsAString& aContentType,
                                                 ErrorResult& aRv) const = 0;

  virtual const nsTArray<RefPtr<BlobImpl>>* GetSubBlobImpls() const = 0;

  virtual void CreateInputStream(nsIInputStream** aStream,
                                 ErrorResult& aRv) const = 0;

  virtual int64_t GetFileId() const = 0;

  nsresult GetSendInfo(nsIInputStream** aBody, uint64_t* aContentLength,
                       nsACString& aContentType, nsACString& aCharset);

  virtual void SetLazyData(const nsAString& aName,
                           const nsAString& aContentType, uint64_t aLength,
                           int64_t aLastModifiedDate) = 0;

  virtual bool IsMemoryFile() const = 0;

  virtual bool IsFile() const = 0;

  // Returns true if the BlobImpl is backed by an nsIFile and the underlying
  // file is a directory.
  virtual bool IsDirectory() const { return false; }

 protected:
  friend SupportsThreadSafeWeakPtr<BlobImpl>;

  virtual ~BlobImpl() = default;
};

}  // namespace dom
}  // namespace mozilla

#endif  // mozilla_dom_BlobImpl_h
