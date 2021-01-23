/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ImageLogging.h"  // Must appear first

#include "nsAVIFDecoder.h"

#include "aom/aomdx.h"

#include "mozilla/gfx/Types.h"
#include "YCbCrUtils.h"

#include "SurfacePipeFactory.h"

using namespace mozilla::gfx;

namespace mozilla {
namespace image {

static LazyLogModule sAVIFLog("AVIFDecoder");

// Wrapper to allow rust to call our read adaptor.
intptr_t nsAVIFDecoder::ReadSource(uint8_t* aDestBuf, uintptr_t aDestBufSize,
                                   void* aUserData) {
  MOZ_ASSERT(aDestBuf);
  MOZ_ASSERT(aUserData);

  MOZ_LOG(sAVIFLog, LogLevel::Verbose,
          ("AVIF ReadSource, aDestBufSize: %zu", aDestBufSize));

  auto* decoder = reinterpret_cast<nsAVIFDecoder*>(aUserData);

  MOZ_ASSERT(decoder->mReadCursor);

  size_t bufferLength = decoder->mBufferedData.end() - decoder->mReadCursor;
  size_t n_bytes = std::min(aDestBufSize, bufferLength);

  MOZ_LOG(
      sAVIFLog, LogLevel::Verbose,
      ("AVIF ReadSource, %zu bytes ready, copying %zu", bufferLength, n_bytes));

  memcpy(aDestBuf, decoder->mReadCursor, n_bytes);
  decoder->mReadCursor += n_bytes;

  return n_bytes;
}

nsAVIFDecoder::nsAVIFDecoder(RasterImage* aImage)
    : Decoder(aImage), mParser(nullptr) {
  MOZ_LOG(sAVIFLog, LogLevel::Debug,
          ("[this=%p] nsAVIFDecoder::nsAVIFDecoder", this));
}

nsAVIFDecoder::~nsAVIFDecoder() {
  MOZ_LOG(sAVIFLog, LogLevel::Debug,
          ("[this=%p] nsAVIFDecoder::~nsAVIFDecoder", this));

  if (mParser) {
    MOZ_LOG(sAVIFLog, LogLevel::Debug,
            ("[this=%p] freeing parser due to nsAVIFDecoder destructor", this));
    mp4parse_avif_free(mParser);
    mParser = nullptr;
  }

  if (mDav1dPicture) {
    // TODO: Make this more ergonomic, see bug 1639637
    dav1d_picture_unref(mDav1dPicture.ptr());
    mDav1dPicture.reset();
  }

  if (mCodecContext) {
    if (mCodecContext->is<Dav1dContext*>()) {
      dav1d_close(&mCodecContext->as<Dav1dContext*>());
      MOZ_LOG(sAVIFLog, LogLevel::Debug, ("[this=%p] dav1d_close", this));
    } else {
      MOZ_ASSERT(mCodecContext->is<aom_codec_ctx_t>());
      aom_codec_err_t res =
          aom_codec_destroy(&mCodecContext->as<aom_codec_ctx_t>());
      MOZ_LOG(sAVIFLog, LogLevel::Debug,
              ("[this=%p] aom_codec_destroy -> %d", this, res));
    }
  } else {
    MOZ_LOG(sAVIFLog, LogLevel::Debug,
            ("[this=%p] no codec context to destruct", this));
  }
}

void nsAVIFDecoder::FreeDav1dData(const uint8_t* buf, void* cookie) {
  auto* decoder = static_cast<nsAVIFDecoder*>(cookie);
  if (decoder->mParser) {
    MOZ_LOG(sAVIFLog, LogLevel::Debug,
            ("[this=%p] freeing parser %p due to dav1d_data_wrap callback",
             decoder, decoder->mParser));
    mp4parse_avif_free(decoder->mParser);
    decoder->mParser = nullptr;
  }
}

bool nsAVIFDecoder::DecodeWithDav1d(const Mp4parseByteData& aPrimaryItem,
                                    layers::PlanarYCbCrData& aDecodedData) {
  Dav1dSettings settings;
  dav1d_default_settings(&settings);
  // TODO: tune settings a la DAV1DDecoder for AV1

  Dav1dContext* ctx = nullptr;
  int res = dav1d_open(&ctx, &settings);

  if (res == 0) {
    mCodecContext = Some(AsVariant(ctx));
  } else {
    return false;
  }

  Dav1dData dav1dData;
  res = dav1d_data_wrap(&dav1dData, aPrimaryItem.data, aPrimaryItem.length,
                        nsAVIFDecoder::FreeDav1dData, this);

  if (res != 0) {
    MOZ_LOG(sAVIFLog, LogLevel::Error,
            ("[this=%p] dav1d_data_wrap(%p, %zu) -> %d", this, dav1dData.data,
             dav1dData.sz, res));
    return false;
  }

  res = dav1d_send_data(ctx, &dav1dData);

  if (res != 0) {
    MOZ_LOG(sAVIFLog, LogLevel::Error,
            ("[this=%p] dav1d_send_data -> %d", this, res));
    return false;
  }

  MOZ_ASSERT(!mDav1dPicture.isSome());
  mDav1dPicture.emplace();
  res = dav1d_get_picture(ctx, mDav1dPicture.ptr());

  if (res != 0) {
    MOZ_LOG(sAVIFLog, LogLevel::Error,
            ("[this=%p] dav1d_get_picture -> %d", this, res));
    return false;
  }

  static_assert(std::is_same<int, decltype(mDav1dPicture->p.w)>::value);
  static_assert(std::is_same<int, decltype(mDav1dPicture->p.h)>::value);

  aDecodedData.mYChannel = static_cast<uint8_t*>(mDav1dPicture->data[0]);
  aDecodedData.mYStride = mDav1dPicture->stride[0];
  aDecodedData.mYSize = gfx::IntSize(mDav1dPicture->p.w, mDav1dPicture->p.h);
  aDecodedData.mYSkip = mDav1dPicture->stride[0] - mDav1dPicture->p.w;
  aDecodedData.mCbChannel = static_cast<uint8_t*>(mDav1dPicture->data[1]);
  aDecodedData.mCrChannel = static_cast<uint8_t*>(mDav1dPicture->data[2]);
  aDecodedData.mCbCrStride = mDav1dPicture->stride[1];

  switch (mDav1dPicture->p.layout) {
    case DAV1D_PIXEL_LAYOUT_I400:  // Monochrome, so no Cb or Cr channels
      aDecodedData.mCbCrSize = gfx::IntSize(0, 0);
      break;
    case DAV1D_PIXEL_LAYOUT_I420:
      aDecodedData.mCbCrSize = gfx::IntSize((mDav1dPicture->p.w + 1) / 2,
                                            (mDav1dPicture->p.h + 1) / 2);
      break;
    case DAV1D_PIXEL_LAYOUT_I422:
      aDecodedData.mCbCrSize =
          gfx::IntSize((mDav1dPicture->p.w + 1) / 2, mDav1dPicture->p.h);
      break;
    case DAV1D_PIXEL_LAYOUT_I444:
      aDecodedData.mCbCrSize =
          gfx::IntSize(mDav1dPicture->p.w, mDav1dPicture->p.h);
      break;
    default:
      MOZ_ASSERT_UNREACHABLE("Unknown pixel layout");
  }

  aDecodedData.mCbSkip = mDav1dPicture->stride[1] - mDav1dPicture->p.w;
  aDecodedData.mCrSkip = mDav1dPicture->stride[1] - mDav1dPicture->p.w;
  aDecodedData.mPicX = 0;
  aDecodedData.mPicY = 0;
  aDecodedData.mPicSize = aDecodedData.mYSize;
  aDecodedData.mStereoMode = StereoMode::MONO;
  aDecodedData.mColorDepth = ColorDepthForBitDepth(mDav1dPicture->p.bpc);

  switch (mDav1dPicture->seq_hdr->pri) {
    case DAV1D_COLOR_PRI_BT601:
      aDecodedData.mYUVColorSpace = gfx::YUVColorSpace::BT601;
      break;
    case DAV1D_COLOR_PRI_BT709:
      aDecodedData.mYUVColorSpace = gfx::YUVColorSpace::BT709;
      break;
    case DAV1D_COLOR_PRI_BT2020:
      aDecodedData.mYUVColorSpace = gfx::YUVColorSpace::BT2020;
      break;
    case DAV1D_COLOR_PRI_UNKNOWN:
      aDecodedData.mYUVColorSpace = gfx::YUVColorSpace::UNKNOWN;
      break;
    default:
      MOZ_LOG(sAVIFLog, LogLevel::Debug,
              ("[this=%p] unsupported color primaries value: %u", this,
               mDav1dPicture->seq_hdr->pri));
      aDecodedData.mYUVColorSpace = gfx::YUVColorSpace::UNKNOWN;
  }

  aDecodedData.mColorRange = mDav1dPicture->seq_hdr->color_range
                                 ? gfx::ColorRange::FULL
                                 : gfx::ColorRange::LIMITED;

  return true;
}

bool nsAVIFDecoder::DecodeWithAOM(const Mp4parseByteData& aPrimaryItem,
                                  layers::PlanarYCbCrData& aDecodedData) {
  aom_codec_iface_t* iface = aom_codec_av1_dx();
  aom_codec_ctx_t ctx;
  aom_codec_err_t res =
      aom_codec_dec_init(&ctx, iface, /* cfg = */ nullptr, /* flags = */ 0);

  MOZ_LOG(
      sAVIFLog, LogLevel::Error,
      ("[this=%p] aom_codec_dec_init -> %d, name = %s", this, res, ctx.name));

  if (res == AOM_CODEC_OK) {
    mCodecContext = Some(AsVariant(ctx));
  } else {
    return false;
  }

  res = aom_codec_decode(&mCodecContext->as<aom_codec_ctx_t>(),
                         aPrimaryItem.data, aPrimaryItem.length, nullptr);

  if (res != AOM_CODEC_OK) {
    MOZ_LOG(sAVIFLog, LogLevel::Error,
            ("[this=%p] aom_codec_decode -> %d", this, res));
    return false;
  }

  MOZ_LOG(sAVIFLog, LogLevel::Debug,
          ("[this=%p] aom_codec_decode -> %d", this, res));

  aom_codec_iter_t iter = nullptr;
  const aom_image_t* img =
      aom_codec_get_frame(&mCodecContext->as<aom_codec_ctx_t>(), &iter);

  if (img == nullptr) {
    MOZ_LOG(sAVIFLog, LogLevel::Error,
            ("[this=%p] aom_codec_get_frame -> %p", this, img));
    return false;
  }

  const CheckedInt<int> decoded_width = img->d_w;
  const CheckedInt<int> decoded_height = img->d_h;

  if (!decoded_height.isValid() || !decoded_width.isValid()) {
    MOZ_LOG(
        sAVIFLog, LogLevel::Debug,
        ("[this=%p] image dimensions can't be stored in int: d_w: %u, d_h: %u",
         this, img->d_w, img->d_h));
    return false;
  }

  PostSize(decoded_width.value(), decoded_height.value());

  MOZ_ASSERT(img->stride[AOM_PLANE_Y] == img->stride[AOM_PLANE_ALPHA]);
  MOZ_ASSERT(img->stride[AOM_PLANE_Y] >= aom_img_plane_width(img, AOM_PLANE_Y));
  MOZ_ASSERT(img->stride[AOM_PLANE_U] == img->stride[AOM_PLANE_V]);
  MOZ_ASSERT(img->stride[AOM_PLANE_U] >= aom_img_plane_width(img, AOM_PLANE_U));
  MOZ_ASSERT(img->stride[AOM_PLANE_V] >= aom_img_plane_width(img, AOM_PLANE_V));
  MOZ_ASSERT(aom_img_plane_width(img, AOM_PLANE_U) ==
             aom_img_plane_width(img, AOM_PLANE_V));
  MOZ_ASSERT(aom_img_plane_height(img, AOM_PLANE_U) ==
             aom_img_plane_height(img, AOM_PLANE_V));

  aDecodedData.mYChannel = img->planes[AOM_PLANE_Y];
  aDecodedData.mYStride = img->stride[AOM_PLANE_Y];
  aDecodedData.mYSize = gfx::IntSize(aom_img_plane_width(img, AOM_PLANE_Y),
                                     aom_img_plane_height(img, AOM_PLANE_Y));
  aDecodedData.mYSkip =
      img->stride[AOM_PLANE_Y] - aom_img_plane_width(img, AOM_PLANE_Y);
  aDecodedData.mCbChannel = img->planes[AOM_PLANE_U];
  aDecodedData.mCrChannel = img->planes[AOM_PLANE_V];
  aDecodedData.mCbCrStride = img->stride[AOM_PLANE_U];
  aDecodedData.mCbCrSize = gfx::IntSize(aom_img_plane_width(img, AOM_PLANE_U),
                                        aom_img_plane_height(img, AOM_PLANE_U));
  aDecodedData.mCbSkip =
      img->stride[AOM_PLANE_U] - aom_img_plane_width(img, AOM_PLANE_U);
  aDecodedData.mCrSkip =
      img->stride[AOM_PLANE_V] - aom_img_plane_width(img, AOM_PLANE_V);
  aDecodedData.mPicX = 0;
  aDecodedData.mPicY = 0;
  aDecodedData.mPicSize =
      gfx::IntSize(decoded_width.value(), decoded_height.value());
  aDecodedData.mStereoMode = StereoMode::MONO;
  aDecodedData.mColorDepth = ColorDepthForBitDepth(img->bit_depth);

  switch (img->cp) {
    case AOM_CICP_CP_BT_601:
      aDecodedData.mYUVColorSpace = gfx::YUVColorSpace::BT601;
      break;
    case AOM_CICP_CP_BT_709:
      aDecodedData.mYUVColorSpace = gfx::YUVColorSpace::BT709;
      break;
    case AOM_CICP_CP_BT_2020:
      aDecodedData.mYUVColorSpace = gfx::YUVColorSpace::BT2020;
      break;
    case AOM_CICP_CP_UNSPECIFIED:
      aDecodedData.mYUVColorSpace = gfx::YUVColorSpace::UNKNOWN;
      break;
    default:
      MOZ_LOG(sAVIFLog, LogLevel::Debug,
              ("[this=%p] unsupported aom_color_primaries value: %u", this,
               img->cp));
      aDecodedData.mYUVColorSpace = gfx::YUVColorSpace::UNKNOWN;
  }

  switch (img->range) {
    case AOM_CR_STUDIO_RANGE:
      aDecodedData.mColorRange = gfx::ColorRange::LIMITED;
      break;
    case AOM_CR_FULL_RANGE:
      aDecodedData.mColorRange = gfx::ColorRange::FULL;
      break;
    default:
      MOZ_ASSERT_UNREACHABLE("unknown color range");
  }

  return true;
}

LexerResult nsAVIFDecoder::DoDecode(SourceBufferIterator& aIterator,
                                    IResumable* aOnResume) {
  MOZ_LOG(sAVIFLog, LogLevel::Debug,
          ("[this=%p] nsAVIFDecoder::DoDecode", this));

  // Since the SourceBufferIterator doesn't guarantee a contiguous buffer,
  // but the current mp4parse-rust implementation requires it, always buffer
  // locally. This keeps the code simpler at the cost of some performance, but
  // this implementation is only experimental, so we don't want to spend time
  // optimizing it prematurely.
  while (!mReadCursor) {
    SourceBufferIterator::State state =
        aIterator.AdvanceOrScheduleResume(SIZE_MAX, aOnResume);

    MOZ_LOG(sAVIFLog, LogLevel::Debug,
            ("[this=%p] After advance, iterator state is %d", this, state));

    switch (state) {
      case SourceBufferIterator::WAITING:
        return LexerResult(Yield::NEED_MORE_DATA);

      case SourceBufferIterator::COMPLETE:
        mReadCursor = mBufferedData.begin();
        break;

      case SourceBufferIterator::READY: {  // copy new data to buffer
        MOZ_LOG(sAVIFLog, LogLevel::Debug,
                ("[this=%p] SourceBufferIterator ready, %zu bytes available",
                 this, aIterator.Length()));

        bool appendSuccess =
            mBufferedData.append(aIterator.Data(), aIterator.Length());

        if (!appendSuccess) {
          MOZ_LOG(sAVIFLog, LogLevel::Error,
                  ("[this=%p] Failed to append %zu bytes to buffer", this,
                   aIterator.Length()));
        }

        break;
      }

      default:
        MOZ_ASSERT_UNREACHABLE("unexpected SourceBufferIterator state");
    }
  }

  Mp4parseIo io = {nsAVIFDecoder::ReadSource, this};
  if (!mParser) {
    Mp4parseStatus status = mp4parse_avif_new(&io, &mParser);

    MOZ_LOG(sAVIFLog, LogLevel::Debug,
            ("[this=%p] mp4parse_avif_new status: %d", this, status));
  }

  if (!mParser) {
    return LexerResult(TerminalState::FAILURE);
  }

  Mp4parseByteData primaryItem = {};
  Mp4parseStatus status = mp4parse_avif_get_primary_item(mParser, &primaryItem);

  MOZ_LOG(sAVIFLog, LogLevel::Debug,
          ("[this=%p] mp4parse_avif_get_primary_item -> %d; length: %u", this,
           status, primaryItem.length));

  if (status != MP4PARSE_STATUS_OK) {
    return LexerResult(TerminalState::FAILURE);
  }

  layers::PlanarYCbCrData decodedData;
  bool decodeOK = StaticPrefs::image_avif_use_dav1d()
                      ? DecodeWithDav1d(primaryItem, decodedData)
                      : DecodeWithAOM(primaryItem, decodedData);

  MOZ_LOG(sAVIFLog, LogLevel::Debug,
          ("[this=%p] DecodeWith%s() -> %s", this,
           StaticPrefs::image_avif_use_dav1d() ? "Dav1d" : "AOM",
           decodeOK ? "OK" : "Fail"));
  if (!decodeOK) {
    return LexerResult(TerminalState::FAILURE);
  }

  PostSize(decodedData.mPicSize.width, decodedData.mPicSize.height);

  // TODO: This doesn't account for the alpha plane in a separate frame
  const bool hasAlpha = false;
  if (hasAlpha) {
    PostHasTransparency();
  }

  if (IsMetadataDecode()) {
    return LexerResult(TerminalState::SUCCESS);
  }

  gfx::SurfaceFormat format =
      hasAlpha ? SurfaceFormat::OS_RGBA : SurfaceFormat::OS_RGBX;
  const IntSize intrinsicSize = Size();
  IntSize rgbSize = intrinsicSize;

  gfx::GetYCbCrToRGBDestFormatAndSize(decodedData, format, rgbSize);
  const int bytesPerPixel = BytesPerPixel(format);

  const CheckedInt rgbStride = CheckedInt<int>(rgbSize.width) * bytesPerPixel;
  const CheckedInt rgbBufLength = rgbStride * rgbSize.height;

  if (!rgbStride.isValid() || !rgbBufLength.isValid()) {
    MOZ_LOG(sAVIFLog, LogLevel::Debug,
            ("[this=%p] overflow calculating rgbBufLength: rbgSize.width: %d, "
             "rgbSize.height: %d, "
             "bytesPerPixel: %u",
             this, rgbSize.width, rgbSize.height, bytesPerPixel));
    return LexerResult(TerminalState::FAILURE);
  }

  UniquePtr<uint8_t[]> rgbBuf = MakeUnique<uint8_t[]>(rgbBufLength.value());
  const uint8_t* endOfRgbBuf = {rgbBuf.get() + rgbBufLength.value()};

  if (!rgbBuf) {
    MOZ_LOG(sAVIFLog, LogLevel::Debug,
            ("[this=%p] allocation of %u-byte rgbBuf failed", this,
             rgbBufLength.value()));
    return LexerResult(TerminalState::FAILURE);
  }

  MOZ_LOG(sAVIFLog, LogLevel::Debug,
          ("[this=%p] calling gfx::ConvertYCbCrToRGB", this));
  gfx::ConvertYCbCrToRGB(decodedData, format, rgbSize, rgbBuf.get(),
                         rgbStride.value());

  MOZ_LOG(sAVIFLog, LogLevel::Debug,
          ("[this=%p] calling SurfacePipeFactory::CreateSurfacePipe", this));
  Maybe<SurfacePipe> pipe = SurfacePipeFactory::CreateSurfacePipe(
      this, rgbSize, OutputSize(), FullFrame(), format, format, Nothing(),
      nullptr, SurfacePipeFlags());

  if (!pipe) {
    MOZ_LOG(sAVIFLog, LogLevel::Debug,
            ("[this=%p] could not initialize surface pipe", this));
    return LexerResult(TerminalState::FAILURE);
  }

  MOZ_LOG(sAVIFLog, LogLevel::Debug, ("[this=%p] writing to surface", this));
  WriteState writeBufferResult = WriteState::NEED_MORE_DATA;
  for (uint8_t* rowPtr = rgbBuf.get(); rowPtr < endOfRgbBuf;
       rowPtr += rgbStride.value()) {
    writeBufferResult = pipe->WriteBuffer(reinterpret_cast<uint32_t*>(rowPtr));

    Maybe<SurfaceInvalidRect> invalidRect = pipe->TakeInvalidRect();
    if (invalidRect) {
      PostInvalidation(invalidRect->mInputSpaceRect,
                       Some(invalidRect->mOutputSpaceRect));
    }

    if (writeBufferResult == WriteState::FAILURE) {
      MOZ_LOG(sAVIFLog, LogLevel::Debug,
              ("[this=%p] error writing rowPtr to surface pipe", this));

    } else if (writeBufferResult == WriteState::FINISHED) {
      MOZ_ASSERT(rowPtr + rgbStride.value() == endOfRgbBuf);
    }
  }

  MOZ_LOG(sAVIFLog, LogLevel::Debug,
          ("[this=%p] writing to surface complete", this));

  if (writeBufferResult == WriteState::FINISHED) {
    PostFrameStop(hasAlpha ? Opacity::SOME_TRANSPARENCY
                           : Opacity::FULLY_OPAQUE);
    PostDecodeDone();
    return LexerResult(TerminalState::SUCCESS);
  }

  return LexerResult(TerminalState::FAILURE);
}

}  // namespace image
}  // namespace mozilla
