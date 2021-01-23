/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef __FFmpegVideoDecoder_h__
#define __FFmpegVideoDecoder_h__

#include "FFmpegLibWrapper.h"
#include "FFmpegDataDecoder.h"
#include "SimpleMap.h"
#ifdef MOZ_WAYLAND_USE_VAAPI
#  include "mozilla/widget/WaylandDMABufSurface.h"
#  include <list>
#endif

namespace mozilla {

#ifdef MOZ_WAYLAND_USE_VAAPI
// When VA-API decoding is running, ffmpeg allocates AVHWFramesContext - a pool
// of "hardware" frames. Every "hardware" frame (VASurface) is backed
// by actual piece of GPU memory which holds the decoded image data.
//
// The VASurface is wrapped by WaylandDMABufSurface and transferred to
// rendering queue by WaylandDMABUFSurfaceImage, where TextureClient is
// created and VASurface is used as a texture there.
//
// As there's a limited number of VASurfaces, ffmpeg reuses them to decode
// next frames ASAP even if they are still attached to WaylandDMABufSurface
// and used as a texture in our rendering engine.
//
// Unfortunately there isn't any obvious way how to mark particular VASurface
// as used. The best we can do is to hold a reference to particular AVBuffer
// from decoded AVFrame and AVHWFramesContext which owns the AVBuffer.

class VAAPIFrameHolder final {
 public:
  VAAPIFrameHolder(FFmpegLibWrapper* aLib, WaylandDMABufSurface* aSurface,
                   AVCodecContext* aAVCodecContext, AVFrame* aAVFrame);
  ~VAAPIFrameHolder();

  // Check if WaylandDMABufSurface is used by any gecko rendering process
  // (WebRender or GL compositor) or by WaylandDMABUFSurfaceImage/VideoData.
  bool IsUsed() const { return mSurface->IsGlobalRefSet(); }

 private:
  const FFmpegLibWrapper* mLib;
  const RefPtr<WaylandDMABufSurface> mSurface;
  AVBufferRef* mAVHWFramesContext;
  AVBufferRef* mHWAVBuffer;
};
#endif

template <int V>
class FFmpegVideoDecoder : public FFmpegDataDecoder<V> {};

template <>
class FFmpegVideoDecoder<LIBAV_VER>;
DDLoggedTypeNameAndBase(FFmpegVideoDecoder<LIBAV_VER>,
                        FFmpegDataDecoder<LIBAV_VER>);

template <>
class FFmpegVideoDecoder<LIBAV_VER>
    : public FFmpegDataDecoder<LIBAV_VER>,
      public DecoderDoctorLifeLogger<FFmpegVideoDecoder<LIBAV_VER>> {
  typedef mozilla::layers::Image Image;
  typedef mozilla::layers::ImageContainer ImageContainer;
  typedef mozilla::layers::KnowsCompositor KnowsCompositor;
  typedef SimpleMap<int64_t> DurationMap;

 public:
  FFmpegVideoDecoder(FFmpegLibWrapper* aLib, TaskQueue* aTaskQueue,
                     const VideoInfo& aConfig, KnowsCompositor* aAllocator,
                     ImageContainer* aImageContainer, bool aLowLatency,
                     bool aDisableHardwareDecoding);

  RefPtr<InitPromise> Init() override;
  void InitCodecContext() override;
  nsCString GetDescriptionName() const override {
#ifdef USING_MOZFFVPX
    return NS_LITERAL_CSTRING("ffvpx video decoder");
#else
    return NS_LITERAL_CSTRING("ffmpeg video decoder");
#endif
  }
  ConversionRequired NeedsConversion() const override {
    return ConversionRequired::kNeedAVCC;
  }

  static AVCodecID GetCodecId(const nsACString& aMimeType);

 private:
  RefPtr<FlushPromise> ProcessFlush() override;
  void ProcessShutdown() override;
  MediaResult DoDecode(MediaRawData* aSample, uint8_t* aData, int aSize,
                       bool* aGotFrame, DecodedData& aResults) override;
  void OutputDelayedFrames();
  bool NeedParser() const override {
    return
#if LIBAVCODEC_VERSION_MAJOR >= 58
        false;
#else
#  if LIBAVCODEC_VERSION_MAJOR >= 55
        mCodecID == AV_CODEC_ID_VP9 ||
#  endif
        mCodecID == AV_CODEC_ID_VP8;
#endif
  }
  gfx::YUVColorSpace GetFrameColorSpace();

  MediaResult CreateImage(int64_t aOffset, int64_t aPts, int64_t aDuration,
                          MediaDataDecoder::DecodedData& aResults);

#ifdef MOZ_WAYLAND_USE_VAAPI
  MediaResult InitVAAPIDecoder();
  bool CreateVAAPIDeviceContext();
  void InitVAAPICodecContext();
  AVCodec* FindVAAPICodec();
  bool IsHardwareAccelerated(nsACString& aFailureReason) const override;

  MediaResult CreateImageVAAPI(int64_t aOffset, int64_t aPts, int64_t aDuration,
                               MediaDataDecoder::DecodedData& aResults);
  void ReleaseUnusedVAAPIFrames();
  void ReleaseAllVAAPIFrames();
#endif

  /**
   * This method allocates a buffer for FFmpeg's decoder, wrapped in an Image.
   * Currently it only supports Planar YUV420, which appears to be the only
   * non-hardware accelerated image format that FFmpeg's H264 decoder is
   * capable of outputting.
   */
  int AllocateYUV420PVideoBuffer(AVCodecContext* aCodecContext,
                                 AVFrame* aFrame);

#ifdef MOZ_WAYLAND_USE_VAAPI
  AVBufferRef* mVAAPIDeviceContext;
  const bool mDisableHardwareDecoding;
  VADisplay mDisplay;
  std::list<UniquePtr<VAAPIFrameHolder>> mFrameHolders;
#endif
  RefPtr<KnowsCompositor> mImageAllocator;
  RefPtr<ImageContainer> mImageContainer;
  VideoInfo mInfo;

  class PtsCorrectionContext {
   public:
    PtsCorrectionContext();
    int64_t GuessCorrectPts(int64_t aPts, int64_t aDts);
    void Reset();
    int64_t LastDts() const { return mLastDts; }

   private:
    int64_t mNumFaultyPts;  /// Number of incorrect PTS values so far
    int64_t mNumFaultyDts;  /// Number of incorrect DTS values so far
    int64_t mLastPts;       /// PTS of the last frame
    int64_t mLastDts;       /// DTS of the last frame
  };

  PtsCorrectionContext mPtsContext;

  DurationMap mDurationMap;
  const bool mLowLatency;
};

}  // namespace mozilla

#endif  // __FFmpegVideoDecoder_h__
