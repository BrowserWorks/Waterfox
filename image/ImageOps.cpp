/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ImageOps.h"

#include "ClippedImage.h"
#include "DecodePool.h"
#include "Decoder.h"
#include "DecoderFactory.h"
#include "DynamicImage.h"
#include "FrozenImage.h"
#include "IDecodingTask.h"
#include "Image.h"
#include "ImageMetadata.h"
#include "imgIContainer.h"
#include "mozilla/gfx/2D.h"
#include "nsStreamUtils.h"
#include "OrientedImage.h"
#include "SourceBuffer.h"

using namespace mozilla::gfx;

namespace mozilla {
namespace image {

/* static */ already_AddRefed<Image>
ImageOps::Freeze(Image* aImage)
{
  RefPtr<Image> frozenImage = new FrozenImage(aImage);
  return frozenImage.forget();
}

/* static */ already_AddRefed<imgIContainer>
ImageOps::Freeze(imgIContainer* aImage)
{
  nsCOMPtr<imgIContainer> frozenImage =
    new FrozenImage(static_cast<Image*>(aImage));
  return frozenImage.forget();
}

/* static */ already_AddRefed<Image>
ImageOps::Clip(Image* aImage, nsIntRect aClip,
               const Maybe<nsSize>& aSVGViewportSize)
{
  RefPtr<Image> clippedImage = new ClippedImage(aImage, aClip, aSVGViewportSize);
  return clippedImage.forget();
}

/* static */ already_AddRefed<imgIContainer>
ImageOps::Clip(imgIContainer* aImage, nsIntRect aClip,
               const Maybe<nsSize>& aSVGViewportSize)
{
  nsCOMPtr<imgIContainer> clippedImage =
    new ClippedImage(static_cast<Image*>(aImage), aClip, aSVGViewportSize);
  return clippedImage.forget();
}

/* static */ already_AddRefed<Image>
ImageOps::Orient(Image* aImage, Orientation aOrientation)
{
  RefPtr<Image> orientedImage = new OrientedImage(aImage, aOrientation);
  return orientedImage.forget();
}

/* static */ already_AddRefed<imgIContainer>
ImageOps::Orient(imgIContainer* aImage, Orientation aOrientation)
{
  nsCOMPtr<imgIContainer> orientedImage =
    new OrientedImage(static_cast<Image*>(aImage), aOrientation);
  return orientedImage.forget();
}

/* static */ already_AddRefed<imgIContainer>
ImageOps::CreateFromDrawable(gfxDrawable* aDrawable)
{
  nsCOMPtr<imgIContainer> drawableImage = new DynamicImage(aDrawable);
  return drawableImage.forget();
}

class ImageOps::ImageBufferImpl final : public ImageOps::ImageBuffer {
public:
  explicit ImageBufferImpl(already_AddRefed<SourceBuffer> aSourceBuffer)
    : mSourceBuffer(aSourceBuffer)
  { }

protected:
  ~ImageBufferImpl() override { }

  already_AddRefed<SourceBuffer> GetSourceBuffer() const override
  {
    RefPtr<SourceBuffer> sourceBuffer = mSourceBuffer;
    return sourceBuffer.forget();
  }

private:
  RefPtr<SourceBuffer> mSourceBuffer;
};

/* static */ already_AddRefed<ImageOps::ImageBuffer>
ImageOps::CreateImageBuffer(nsIInputStream* aInputStream)
{
  MOZ_ASSERT(aInputStream);

  nsresult rv;

  // Prepare the input stream.
  nsCOMPtr<nsIInputStream> inputStream = aInputStream;
  if (!NS_InputStreamIsBuffered(aInputStream)) {
    nsCOMPtr<nsIInputStream> bufStream;
    rv = NS_NewBufferedInputStream(getter_AddRefs(bufStream),
                                   aInputStream, 1024);
    if (NS_SUCCEEDED(rv)) {
      inputStream = bufStream;
    }
  }

  // Figure out how much data we've been passed.
  uint64_t length;
  rv = inputStream->Available(&length);
  if (NS_FAILED(rv) || length > UINT32_MAX) {
    return nullptr;
  }

  // Write the data into a SourceBuffer.
  RefPtr<SourceBuffer> sourceBuffer = new SourceBuffer();
  sourceBuffer->ExpectLength(length);
  rv = sourceBuffer->AppendFromInputStream(inputStream, length);
  if (NS_FAILED(rv)) {
    return nullptr;
  }
  // Make sure our sourceBuffer is marked as complete.
  if (sourceBuffer->IsComplete()) {
    NS_WARNING("The SourceBuffer was unexpectedly marked as complete. This may "
               "indicate either an OOM condition, or that imagelib was not "
               "initialized properly.");
    return nullptr;
  }
  sourceBuffer->Complete(NS_OK);

  RefPtr<ImageBuffer> imageBuffer = new ImageBufferImpl(sourceBuffer.forget());
  return imageBuffer.forget();
}

/* static */ nsresult
ImageOps::DecodeMetadata(nsIInputStream* aInputStream,
                         const nsACString& aMimeType,
                         ImageMetadata& aMetadata)
{
  RefPtr<ImageBuffer> buffer = CreateImageBuffer(aInputStream);
  return DecodeMetadata(buffer, aMimeType, aMetadata);
}

/* static */ nsresult
ImageOps::DecodeMetadata(ImageBuffer* aBuffer,
                         const nsACString& aMimeType,
                         ImageMetadata& aMetadata)
{
  if (!aBuffer) {
    return NS_ERROR_FAILURE;
  }

  RefPtr<SourceBuffer> sourceBuffer = aBuffer->GetSourceBuffer();
  if (NS_WARN_IF(!sourceBuffer)) {
    return NS_ERROR_FAILURE;
  }

  // Create a decoder.
  DecoderType decoderType =
    DecoderFactory::GetDecoderType(PromiseFlatCString(aMimeType).get());
  RefPtr<Decoder> decoder =
    DecoderFactory::CreateAnonymousMetadataDecoder(decoderType,
                                                   WrapNotNull(sourceBuffer));
  if (!decoder) {
    return NS_ERROR_FAILURE;
  }

  // Run the decoder synchronously.
  RefPtr<IDecodingTask> task = new AnonymousDecodingTask(WrapNotNull(decoder));
  task->Run();
  if (!decoder->GetDecodeDone() || decoder->HasError()) {
    return NS_ERROR_FAILURE;
  }

  aMetadata = decoder->GetImageMetadata();
  if (aMetadata.GetNativeSizes().IsEmpty() && aMetadata.HasSize()) {
    aMetadata.AddNativeSize(aMetadata.GetSize());
  }

  return NS_OK;
}

/* static */ already_AddRefed<gfx::SourceSurface>
ImageOps::DecodeToSurface(nsIInputStream* aInputStream,
                          const nsACString& aMimeType,
                          uint32_t aFlags,
                          const Maybe<IntSize>& aSize /* = Nothing() */)
{
  RefPtr<ImageBuffer> buffer = CreateImageBuffer(aInputStream);
  return DecodeToSurface(buffer, aMimeType, aFlags, aSize);
}

/* static */ already_AddRefed<gfx::SourceSurface>
ImageOps::DecodeToSurface(ImageBuffer* aBuffer,
                          const nsACString& aMimeType,
                          uint32_t aFlags,
                          const Maybe<IntSize>& aSize /* = Nothing() */)
{
  if (!aBuffer) {
    return nullptr;
  }

  RefPtr<SourceBuffer> sourceBuffer = aBuffer->GetSourceBuffer();
  if (NS_WARN_IF(!sourceBuffer)) {
    return nullptr;
  }

  // Create a decoder.
  DecoderType decoderType =
    DecoderFactory::GetDecoderType(PromiseFlatCString(aMimeType).get());
  RefPtr<Decoder> decoder =
    DecoderFactory::CreateAnonymousDecoder(decoderType,
                                           WrapNotNull(sourceBuffer),
                                           aSize, ToSurfaceFlags(aFlags));
  if (!decoder) {
    return nullptr;
  }

  // Run the decoder synchronously.
  RefPtr<IDecodingTask> task = new AnonymousDecodingTask(WrapNotNull(decoder));
  task->Run();
  if (!decoder->GetDecodeDone() || decoder->HasError()) {
    return nullptr;
  }

  // Pull out the surface.
  RawAccessFrameRef frame = decoder->GetCurrentFrameRef();
  if (!frame) {
    return nullptr;
  }

  RefPtr<SourceSurface> surface = frame->GetSourceSurface();
  if (!surface) {
    return nullptr;
  }

  return surface.forget();
}

} // namespace image
} // namespace mozilla
