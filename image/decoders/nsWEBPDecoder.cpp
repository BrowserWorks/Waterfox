/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
/* Contributor(s):
 *   Vikas Arora <vikasa@google.com> */

#include "nsWEBPDecoder.h"

#include "ImageLogging.h"
#include "gfxColor.h"
#include "gfxPlatform.h"

namespace mozilla {
namespace image {

#if defined(PR_LOGGING)
static PRLogModuleInfo* gWEBPDecoderAccountingLog =
  PR_NewLogModule("WEBPDecoderAccounting");
#else
#define gWEBPDecoderAccountingLog
#endif

nsWEBPDecoder::nsWEBPDecoder(RasterImage* aImage)
  : Decoder(aImage)
  , mDecoder(nullptr)
  , mLastLine(0)
  , haveSize(false)
{
  PR_LOG(gWEBPDecoderAccountingLog, PR_LOG_DEBUG,
         ("nsWEBPDecoder::nsWEBPDecoder: Creating WEBP decoder %p",
          this));
}

nsWEBPDecoder::~nsWEBPDecoder()
{
  PR_LOG(gWEBPDecoderAccountingLog, PR_LOG_DEBUG,
         ("nsWEBPDecoder::~nsWEBPDecoder: Destroying WEBP decoder %p",
          this));
}

void
nsWEBPDecoder::InitInternal()
{
  // No decoder instance is necessary for a size-only decode.
  if (IsSizeDecode()) {
    return;
  }

  if (!WebPInitDecBuffer(&mDecBuf)) {
    PostDecoderError(NS_ERROR_FAILURE);
    return;
  }
  // TODO: verify libwebp is handling endianness correctly
  mDecBuf.colorspace = MODE_bgrA;
  mDecBuf.is_external_memory = 1;
  mDecBuf.u.RGBA.rgba = mImageData;
  mDecoder = WebPINewDecoder(&mDecBuf);
  if (!mDecoder) {
    PostDecoderError(NS_ERROR_FAILURE);
  }
}

void
nsWEBPDecoder::FinishInternal()
{
  // We should never make multiple frames
  MOZ_ASSERT(GetFrameCount() <= 1, "Multiple WebP frames?");

  // Send notifications if appropriate
  if (!IsSizeDecode() && (GetFrameCount() == 1)) {
    // Flush the decoder
    WebPIDelete(mDecoder);
    WebPFreeDecBuffer(&mDecBuf);

    PostFrameStop();
    PostDecodeDone();
  }
}

void
nsWEBPDecoder::WriteInternal(const char* aBuffer, uint32_t aCount)
{
  const uint8_t* buf = (const uint8_t*)aBuffer;

  if (IsSizeDecode() || !haveSize) {
    WebPBitstreamFeatures features;
    const VP8StatusCode rv = WebPGetFeatures(buf, aCount, &features);

    if (rv == VP8_STATUS_OK) {
      if (features.has_animation) {
        PostDecoderError(NS_ERROR_FAILURE);
        return;
      }
      if (features.has_alpha) {
        PostHasTransparency();
      }
      // Post our size to the superclass
      if (IsSizeDecode()) {
        PostSize(features.width, features.height);
      }
      mDecBuf.width = features.width;
      mDecBuf.height = features.height;
      mDecBuf.u.RGBA.stride = mDecBuf.width * sizeof(uint32_t);
      mDecBuf.u.RGBA.size = mDecBuf.u.RGBA.stride * mDecBuf.height;
      haveSize = true;
    } else if (rv != VP8_STATUS_NOT_ENOUGH_DATA) {
      PostDecoderError(NS_ERROR_FAILURE);
      return;
    } else {
      return;
    }

    // If we're doing a size decode, we're done.
    if (IsSizeDecode()) return;
  }

  mDecBuf.u.RGBA.rgba = mImageData;
  const VP8StatusCode rv = WebPIAppend(mDecoder, buf, aCount);

  if (rv == VP8_STATUS_OUT_OF_MEMORY) {
    PostDecoderError(NS_ERROR_OUT_OF_MEMORY);
    return;
  } else if (rv == VP8_STATUS_INVALID_PARAM ||
             rv == VP8_STATUS_BITSTREAM_ERROR) {
    PostDataError();
    return;
  } else if (rv == VP8_STATUS_UNSUPPORTED_FEATURE ||
             rv == VP8_STATUS_USER_ABORT) {
    PostDecoderError(NS_ERROR_FAILURE);
    return;
  }

  // Catch any remaining erroneous return value.
  if (rv != VP8_STATUS_OK && rv != VP8_STATUS_SUSPENDED) {
    PostDecoderError(NS_ERROR_FAILURE);
    return;
  }

  int lastLineRead = -1;
  int width = 0;
  int height = 0;
  int stride = 0;

  const uint8_t* data =
    WebPIDecGetRGB(mDecoder, &lastLineRead, &width, &height, &stride);

  // WebP encoded image data hasn't been read yet, return.
  if (lastLineRead == -1 || !data) {
    return;
  }

  // Ensure valid image height & width.
  if (width <= 0 || height <= 0) {
    PostDataError();
    return;
  }

  if (!mImageData) {
    PostDecoderError(NS_ERROR_FAILURE);
    return;
  }

  if (lastLineRead > mLastLine) {
    // Invalidate
    nsIntRect r(0, mLastLine, width, lastLineRead - mLastLine);
    PostInvalidation(r);
    mLastLine = lastLineRead;
  }
}

} // namespace image
} // namespace mozilla
