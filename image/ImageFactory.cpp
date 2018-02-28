/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ImageFactory.h"

#include <algorithm>

#include "mozilla/Likely.h"

#include "nsIHttpChannel.h"
#include "nsIFileChannel.h"
#include "nsIFile.h"
#include "nsMimeTypes.h"
#include "nsIRequest.h"

#include "MultipartImage.h"
#include "RasterImage.h"
#include "VectorImage.h"
#include "Image.h"
#include "nsMediaFragmentURIParser.h"
#include "nsContentUtils.h"
#include "nsIScriptSecurityManager.h"

#include "gfxPrefs.h"

namespace mozilla {
namespace image {

/*static*/ void
ImageFactory::Initialize()
{ }

static uint32_t
ComputeImageFlags(ImageURL* uri, const nsCString& aMimeType, bool isMultiPart)
{
  nsresult rv;

  // We default to the static globals.
  bool isDiscardable = gfxPrefs::ImageMemDiscardable();
  bool doDecodeImmediately = gfxPrefs::ImageDecodeImmediatelyEnabled();

  // We want UI to be as snappy as possible and not to flicker. Disable
  // discarding for chrome URLS.
  bool isChrome = false;
  rv = uri->SchemeIs("chrome", &isChrome);
  if (NS_SUCCEEDED(rv) && isChrome) {
    isDiscardable = false;
  }

  // We don't want resources like the "loading" icon to be discardable either.
  bool isResource = false;
  rv = uri->SchemeIs("resource", &isResource);
  if (NS_SUCCEEDED(rv) && isResource) {
    isDiscardable = false;
  }

  // For multipart/x-mixed-replace, we basically want a direct channel to the
  // decoder. Disable everything for this case.
  if (isMultiPart) {
    isDiscardable = false;
  }

  // We have all the information we need.
  uint32_t imageFlags = Image::INIT_FLAG_NONE;
  if (isDiscardable) {
    imageFlags |= Image::INIT_FLAG_DISCARDABLE;
  }
  if (doDecodeImmediately) {
    imageFlags |= Image::INIT_FLAG_DECODE_IMMEDIATELY;
  }
  if (isMultiPart) {
    imageFlags |= Image::INIT_FLAG_TRANSIENT;
  }

  // Synchronously decode metadata (including size) if we have a data URI since
  // the data is immediately available.
  bool isDataURI = false;
  rv = uri->SchemeIs("data", &isDataURI);
  if (NS_SUCCEEDED(rv) && isDataURI) {
    imageFlags |= Image::INIT_FLAG_SYNC_LOAD;
  }

  return imageFlags;
}

/* static */ already_AddRefed<Image>
ImageFactory::CreateImage(nsIRequest* aRequest,
                          ProgressTracker* aProgressTracker,
                          const nsCString& aMimeType,
                          ImageURL* aURI,
                          bool aIsMultiPart,
                          uint32_t aInnerWindowId)
{
  MOZ_ASSERT(gfxPrefs::SingletonExists(),
             "Pref observers should have been initialized already");

  // Compute the image's initialization flags.
  uint32_t imageFlags = ComputeImageFlags(aURI, aMimeType, aIsMultiPart);

#ifdef DEBUG
  // Record the image load for startup performance testing.
  if (NS_IsMainThread()) {
    nsCOMPtr<nsIObserverService> obs = services::GetObserverService();
    NS_WARNING_ASSERTION(obs, "Can't get an observer service handle");
    if (obs) {
      nsAutoCString spec;
      aURI->GetSpec(spec);
      obs->NotifyObservers(nullptr, "image-loading", NS_ConvertUTF8toUTF16(spec).get());
    }
  }
#endif

  // Select the type of image to create based on MIME type.
  if (aMimeType.EqualsLiteral(IMAGE_SVG_XML)) {
    return CreateVectorImage(aRequest, aProgressTracker, aMimeType,
                             aURI, imageFlags, aInnerWindowId);
  } else {
    return CreateRasterImage(aRequest, aProgressTracker, aMimeType,
                             aURI, imageFlags, aInnerWindowId);
  }
}

// Marks an image as having an error before returning it.
template <typename T>
static already_AddRefed<Image>
BadImage(const char* aMessage, RefPtr<T>& aImage)
{
  aImage->SetHasError();
  return aImage.forget();
}

static void
SetSourceSizeHint(RasterImage* aImage, uint32_t aSize)
{
  // Pass anything usable on so that the RasterImage can preallocate
  // its source buffer.
  if (aSize == 0) {
    return;
  }

  // Bound by something reasonable
  uint32_t sizeHint = std::min<uint32_t>(aSize, 20000000);
  nsresult rv = aImage->SetSourceSizeHint(sizeHint);
  if (NS_FAILED(rv)) {
    // Flush memory, try to get some back, and try again.
    rv = nsMemory::HeapMinimize(true);
    nsresult rv2 = aImage->SetSourceSizeHint(sizeHint);
    // If we've still failed at this point, things are going downhill.
    if (NS_FAILED(rv) || NS_FAILED(rv2)) {
      NS_WARNING("About to hit OOM in imagelib!");
    }
  }
}

/* static */ already_AddRefed<Image>
ImageFactory::CreateAnonymousImage(const nsCString& aMimeType,
                                   uint32_t aSizeHint /* = 0 */)
{
  nsresult rv;

  RefPtr<RasterImage> newImage = new RasterImage();

  RefPtr<ProgressTracker> newTracker = new ProgressTracker();
  newTracker->SetImage(newImage);
  newImage->SetProgressTracker(newTracker);

  rv = newImage->Init(aMimeType.get(), Image::INIT_FLAG_SYNC_LOAD);
  if (NS_FAILED(rv)) {
    return BadImage("RasterImage::Init failed", newImage);
  }

  SetSourceSizeHint(newImage, aSizeHint);
  return newImage.forget();
}

/* static */ already_AddRefed<MultipartImage>
ImageFactory::CreateMultipartImage(Image* aFirstPart,
                                   ProgressTracker* aProgressTracker)
{
  MOZ_ASSERT(aFirstPart);
  MOZ_ASSERT(aProgressTracker);

  RefPtr<MultipartImage> newImage = new MultipartImage(aFirstPart);
  aProgressTracker->SetImage(newImage);
  newImage->SetProgressTracker(aProgressTracker);

  newImage->Init();

  return newImage.forget();
}

int32_t
SaturateToInt32(int64_t val)
{
  if (val > INT_MAX) {
    return INT_MAX;
  }
  if (val < INT_MIN) {
    return INT_MIN;
  }

  return static_cast<int32_t>(val);
}

uint32_t
GetContentSize(nsIRequest* aRequest)
{
  nsCOMPtr<nsIChannel> channel(do_QueryInterface(aRequest));
  if (channel) {
    int64_t size;
    nsresult rv = channel->GetContentLength(&size);
    if (NS_SUCCEEDED(rv)) {
      return std::max(SaturateToInt32(size), 0);
    }
  }

  // Use the file size as a size hint for file channels.
  nsCOMPtr<nsIFileChannel> fileChannel(do_QueryInterface(aRequest));
  if (fileChannel) {
    nsCOMPtr<nsIFile> file;
    nsresult rv = fileChannel->GetFile(getter_AddRefs(file));
    if (NS_SUCCEEDED(rv)) {
      int64_t filesize;
      rv = file->GetFileSize(&filesize);
      if (NS_SUCCEEDED(rv)) {
        return std::max(SaturateToInt32(filesize), 0);
      }
    }
  }

  // Fallback - neither http nor file. We'll use dynamic allocation.
  return 0;
}

/* static */ already_AddRefed<Image>
ImageFactory::CreateRasterImage(nsIRequest* aRequest,
                                ProgressTracker* aProgressTracker,
                                const nsCString& aMimeType,
                                ImageURL* aURI,
                                uint32_t aImageFlags,
                                uint32_t aInnerWindowId)
{
  MOZ_ASSERT(aProgressTracker);

  nsresult rv;

  RefPtr<RasterImage> newImage = new RasterImage(aURI);
  aProgressTracker->SetImage(newImage);
  newImage->SetProgressTracker(aProgressTracker);

  rv = newImage->Init(aMimeType.get(), aImageFlags);
  if (NS_FAILED(rv)) {
    return BadImage("RasterImage::Init failed", newImage);
  }

  newImage->SetInnerWindowID(aInnerWindowId);

  SetSourceSizeHint(newImage, GetContentSize(aRequest));
  return newImage.forget();
}

/* static */ already_AddRefed<Image>
ImageFactory::CreateVectorImage(nsIRequest* aRequest,
                                ProgressTracker* aProgressTracker,
                                const nsCString& aMimeType,
                                ImageURL* aURI,
                                uint32_t aImageFlags,
                                uint32_t aInnerWindowId)
{
  MOZ_ASSERT(aProgressTracker);

  nsresult rv;

  RefPtr<VectorImage> newImage = new VectorImage(aURI);
  aProgressTracker->SetImage(newImage);
  newImage->SetProgressTracker(aProgressTracker);

  rv = newImage->Init(aMimeType.get(), aImageFlags);
  if (NS_FAILED(rv)) {
    return BadImage("VectorImage::Init failed", newImage);
  }

  newImage->SetInnerWindowID(aInnerWindowId);

  rv = newImage->OnStartRequest(aRequest, nullptr);
  if (NS_FAILED(rv)) {
    return BadImage("VectorImage::OnStartRequest failed", newImage);
  }

  return newImage.forget();
}

} // namespace image
} // namespace mozilla
