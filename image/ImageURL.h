/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_image_ImageURL_h
#define mozilla_image_ImageURL_h

#include "nsIURI.h"
#include "MainThreadUtils.h"
#include "nsNetUtil.h"
#include "mozilla/HashFunctions.h"
#include "nsHashKeys.h"
#include "nsProxyRelease.h"

namespace mozilla {
namespace image {

class ImageCacheKey;

/** ImageURL
 *
 * nsStandardURL is not threadsafe, so this class is created to hold only the
 * necessary URL data required for image loading and decoding.
 *
 * Note: Although several APIs have the same or similar prototypes as those
 * found in nsIURI/nsStandardURL, the class does not implement nsIURI. This is
 * intentional; functionality is limited, and is only useful for imagelib code.
 * By not implementing nsIURI, external code cannot unintentionally be given an
 * nsIURI pointer with this limited class behind it; instead, conversion to a
 * fully implemented nsIURI is required (e.g. through NS_NewURI).
 */
class ImageURL
{
public:
  explicit ImageURL(nsIURI* aURI, nsresult& aRv)
    : mURI(new nsMainThreadPtrHolder<nsIURI>("ImageURL::mURI", aURI))
  {
    MOZ_ASSERT(NS_IsMainThread(), "Cannot use nsIURI off main thread!");

    aRv = aURI->GetSpec(mSpec);
    NS_ENSURE_SUCCESS_VOID(aRv);

    aRv = aURI->GetScheme(mScheme);
    NS_ENSURE_SUCCESS_VOID(aRv);

    aRv = aURI->GetRef(mRef);
    NS_ENSURE_SUCCESS_VOID(aRv);
  }

  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(ImageURL)

  nsresult GetSpec(nsACString& result)
  {
    result = mSpec;
    return NS_OK;
  }

  /// A weak pointer to the URI spec for this ImageURL. For logging only.
  const char* Spec() const { return mSpec.get(); }

  enum TruncatedSpecStatus {
    FitsInto1k,
    TruncatedTo1k
  };
  TruncatedSpecStatus GetSpecTruncatedTo1k(nsACString& result)
  {
    static const size_t sMaxTruncatedLength = 1024;

    if (sMaxTruncatedLength >= mSpec.Length()) {
      result = mSpec;
      return FitsInto1k;
    }

    result = Substring(mSpec, 0, sMaxTruncatedLength);
    return TruncatedTo1k;
  }

  nsresult GetScheme(nsACString& result)
  {
    result = mScheme;
    return NS_OK;
  }

  nsresult SchemeIs(const char* scheme, bool* result)
  {
    NS_PRECONDITION(scheme, "scheme is null");
    NS_PRECONDITION(result, "result is null");

    *result = mScheme.Equals(scheme);
    return NS_OK;
  }

  nsresult GetRef(nsACString& result)
  {
    result = mRef;
    return NS_OK;
  }

  already_AddRefed<nsIURI> ToIURI()
  {
    nsCOMPtr<nsIURI> newURI = mURI.get();
    return newURI.forget();
  }

  bool operator==(const ImageURL& aOther) const
  {
    // Note that we don't need to consider mScheme and mRef, because they're
    // already represented in mSpec.
    return mSpec == aOther.mSpec;
  }

  bool HasSameRef(const ImageURL& aOther) const
  {
    return mRef == aOther.mRef;
  }

private:
  friend class ImageCacheKey;

  PLDHashNumber ComputeHash(const Maybe<uint64_t>& aBlobSerial) const
  {
    if (aBlobSerial) {
      // For blob URIs, we hash the serial number of the underlying blob, so that
      // different blob URIs which point to the same blob share a cache entry. We
      // also include the ref portion of the URI to support media fragments which
      // requires us to create different Image objects even if the source data is
      // the same.
      return HashGeneric(*aBlobSerial, HashString(mRef));
    }
    // For non-blob URIs, we hash the URI spec.
    return HashString(mSpec);
  }

  nsMainThreadPtrHandle<nsIURI> mURI;

  // Since this is a basic storage class, no duplication of spec parsing is
  // included in the functionality. Instead, the class depends upon the
  // parsing implementation in the nsIURI class used in object construction.
  // This means each field is stored separately, but since only a few are
  // required, this small memory tradeoff for threadsafe usage should be ok.
  nsAutoCString mSpec;
  nsAutoCString mScheme;
  nsAutoCString mRef;

  ~ImageURL() { }
};

} // namespace image
} // namespace mozilla

#endif // mozilla_image_ImageURL_h
