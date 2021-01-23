/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ImageCacheKey.h"

#include <utility>

#include "mozilla/ContentBlocking.h"
#include "mozilla/HashFunctions.h"
#include "mozilla/StorageAccess.h"
#include "mozilla/StoragePrincipalHelper.h"
#include "mozilla/Unused.h"
#include "mozilla/dom/BlobURLProtocolHandler.h"
#include "mozilla/dom/Document.h"
#include "mozilla/dom/File.h"
#include "mozilla/dom/ServiceWorkerManager.h"
#include "mozilla/StaticPrefs_privacy.h"
#include "nsContentUtils.h"
#include "nsHashKeys.h"
#include "nsLayoutUtils.h"
#include "nsPrintfCString.h"
#include "nsString.h"

namespace mozilla {

using namespace dom;

namespace image {

static Maybe<uint64_t> BlobSerial(nsIURI* aURI) {
  nsAutoCString spec;
  aURI->GetSpec(spec);

  RefPtr<BlobImpl> blob;
  if (NS_SUCCEEDED(NS_GetBlobForBlobURISpec(spec, getter_AddRefs(blob))) &&
      blob) {
    return Some(blob->GetSerialNumber());
  }

  return Nothing();
}

ImageCacheKey::ImageCacheKey(nsIURI* aURI, const OriginAttributes& aAttrs,
                             Document* aDocument)
    : mURI(aURI),
      mOriginAttributes(aAttrs),
      mControlledDocument(GetSpecialCaseDocumentToken(aDocument)),
      mIsolationKey(GetIsolationKey(aDocument, aURI)),
      mIsChrome(false) {
  if (mURI->SchemeIs("blob")) {
    mBlobSerial = BlobSerial(mURI);
  } else if (mURI->SchemeIs("chrome")) {
    mIsChrome = true;
  }
}

ImageCacheKey::ImageCacheKey(const ImageCacheKey& aOther)
    : mURI(aOther.mURI),
      mBlobSerial(aOther.mBlobSerial),
      mBlobRef(aOther.mBlobRef),
      mOriginAttributes(aOther.mOriginAttributes),
      mControlledDocument(aOther.mControlledDocument),
      mIsolationKey(aOther.mIsolationKey),
      mHash(aOther.mHash),
      mIsChrome(aOther.mIsChrome) {}

ImageCacheKey::ImageCacheKey(ImageCacheKey&& aOther)
    : mURI(std::move(aOther.mURI)),
      mBlobSerial(std::move(aOther.mBlobSerial)),
      mBlobRef(std::move(aOther.mBlobRef)),
      mOriginAttributes(aOther.mOriginAttributes),
      mControlledDocument(aOther.mControlledDocument),
      mIsolationKey(aOther.mIsolationKey),
      mHash(aOther.mHash),
      mIsChrome(aOther.mIsChrome) {}

bool ImageCacheKey::operator==(const ImageCacheKey& aOther) const {
  // Don't share the image cache between a controlled document and anything
  // else.
  if (mControlledDocument != aOther.mControlledDocument) {
    return false;
  }
  // Don't share the image cache between two top-level documents of different
  // base domains.
  if (!mIsolationKey.Equals(aOther.mIsolationKey,
                            nsCaseInsensitiveCStringComparator)) {
    return false;
  }
  // The origin attributes always have to match.
  if (mOriginAttributes != aOther.mOriginAttributes) {
    return false;
  }
  if (mBlobSerial || aOther.mBlobSerial) {
    if (mBlobSerial && mBlobRef.IsEmpty()) {
      EnsureBlobRef();
    }
    if (aOther.mBlobSerial && aOther.mBlobRef.IsEmpty()) {
      aOther.EnsureBlobRef();
    }
    // If at least one of us has a blob serial, just compare the blob serial and
    // the ref portion of the URIs.
    return mBlobSerial == aOther.mBlobSerial && mBlobRef == aOther.mBlobRef;
  }

  // For non-blob URIs, compare the URIs.
  bool equals = false;
  nsresult rv = mURI->Equals(aOther.mURI, &equals);
  return NS_SUCCEEDED(rv) && equals;
}

void ImageCacheKey::EnsureBlobRef() const {
  MOZ_ASSERT(mBlobSerial);
  MOZ_ASSERT(mBlobRef.IsEmpty());

  nsresult rv = mURI->GetRef(mBlobRef);
  NS_ENSURE_SUCCESS_VOID(rv);
}

void ImageCacheKey::EnsureHash() const {
  MOZ_ASSERT(mHash.isNothing());
  PLDHashNumber hash = 0;

  // Since we frequently call Hash() several times in a row on the same
  // ImageCacheKey, as an optimization we compute our hash once and store it.

  nsPrintfCString ptr("%p", mControlledDocument);
  nsAutoCString suffix;
  mOriginAttributes.CreateSuffix(suffix);

  if (mBlobSerial) {
    if (mBlobRef.IsEmpty()) {
      EnsureBlobRef();
    }
    hash = HashGeneric(*mBlobSerial, HashString(mBlobRef));
  } else {
    nsAutoCString spec;
    Unused << mURI->GetSpec(spec);
    hash = HashString(spec);
  }

  hash = AddToHash(hash, HashString(suffix), HashString(mIsolationKey),
                   HashString(ptr));
  mHash.emplace(hash);
}

/* static */
void* ImageCacheKey::GetSpecialCaseDocumentToken(Document* aDocument) {
  // Cookie-averse documents can never have storage granted to them.  Since they
  // may not have inner windows, they would require special handling below, so
  // just bail out early here.
  if (!aDocument || aDocument->IsCookieAverse()) {
    return nullptr;
  }

  // For controlled documents, we cast the pointer into a void* to avoid
  // dereferencing it (since we only use it for comparisons).
  RefPtr<ServiceWorkerManager> swm = ServiceWorkerManager::GetInstance();
  if (swm && aDocument->GetController().isSome()) {
    return aDocument;
  }

  return nullptr;
}

/* static */
nsCString ImageCacheKey::GetIsolationKey(Document* aDocument, nsIURI* aURI) {
  if (!aDocument || !aDocument->GetInnerWindow()) {
    return EmptyCString();
  }

  // Network-state isolation
  if (StaticPrefs::privacy_partition_network_state()) {
    OriginAttributes oa;
    StoragePrincipalHelper::GetOriginAttributesForNetworkState(aDocument, oa);

    nsAutoCString suffix;
    oa.CreateSuffix(suffix);

    return std::move(suffix);
  }

  // If the window is 3rd party resource, let's see if first-party storage
  // access is granted for this image.
  if (nsContentUtils::IsThirdPartyWindowOrChannel(aDocument->GetInnerWindow(),
                                                  nullptr, nullptr)) {
    return StorageDisabledByAntiTracking(aDocument, aURI)
               ? aDocument->GetBaseDomain()
               : EmptyCString();
  }

  // Another scenario is if this image is a 3rd party resource loaded by a
  // first party context. In this case, we should check if the nsIChannel has
  // been marked as tracking resource, but we don't have the channel yet at
  // this point.  The best approach here is to be conservative: if we are sure
  // that the permission is granted, let's return 0. Otherwise, let's make a
  // unique image cache per the top-level document eTLD+1.
  if (!ContentBlocking::ApproximateAllowAccessForWithoutChannel(
          aDocument->GetInnerWindow(), aURI)) {
    nsPIDOMWindowOuter* top =
        aDocument->GetInnerWindow()->GetInProcessScriptableTop();
    nsPIDOMWindowInner* topInner = top ? top->GetCurrentInnerWindow() : nullptr;
    if (!topInner) {
      return aDocument
          ->GetBaseDomain();  // because we don't have anything better!
    }
    return topInner->GetExtantDoc() ? topInner->GetExtantDoc()->GetBaseDomain()
                                    : EmptyCString();
  }

  return EmptyCString();
}

}  // namespace image
}  // namespace mozilla
