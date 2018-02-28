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

namespace mozilla
{

template <int V>
class FFmpegVideoDecoder : public FFmpegDataDecoder<V>
{
};

template <>
class FFmpegVideoDecoder<LIBAV_VER> : public FFmpegDataDecoder<LIBAV_VER>
{
  typedef mozilla::layers::Image Image;
  typedef mozilla::layers::ImageContainer ImageContainer;
  typedef mozilla::layers::KnowsCompositor KnowsCompositor;
  typedef SimpleMap<int64_t> DurationMap;

public:
  FFmpegVideoDecoder(FFmpegLibWrapper* aLib, TaskQueue* aTaskQueue,
                     const VideoInfo& aConfig,
                     KnowsCompositor* aAllocator,
                     ImageContainer* aImageContainer,
                     bool aLowLatency);
  virtual ~FFmpegVideoDecoder();

  RefPtr<InitPromise> Init() override;
  void InitCodecContext() override;
  const char* GetDescriptionName() const override
  {
#ifdef USING_MOZFFVPX
    return "ffvpx video decoder";
#else
    return "ffmpeg video decoder";
#endif
  }
  ConversionRequired NeedsConversion() const override
  {
    return ConversionRequired::kNeedAVCC;
  }

  static AVCodecID GetCodecId(const nsACString& aMimeType);

private:
  RefPtr<DecodePromise> ProcessDecode(MediaRawData* aSample) override;
  RefPtr<DecodePromise> ProcessDrain() override;
  RefPtr<FlushPromise> ProcessFlush() override;
  MediaResult DoDecode(MediaRawData* aSample, bool* aGotFrame,
                       DecodedData& aResults);
  MediaResult DoDecode(MediaRawData* aSample, uint8_t* aData, int aSize,
                       bool* aGotFrame, DecodedData& aResults);
  void OutputDelayedFrames();

  /**
   * This method allocates a buffer for FFmpeg's decoder, wrapped in an Image.
   * Currently it only supports Planar YUV420, which appears to be the only
   * non-hardware accelerated image format that FFmpeg's H264 decoder is
   * capable of outputting.
   */
  int AllocateYUV420PVideoBuffer(AVCodecContext* aCodecContext,
                                 AVFrame* aFrame);

  RefPtr<KnowsCompositor> mImageAllocator;
  RefPtr<ImageContainer> mImageContainer;
  VideoInfo mInfo;

  // Parser used for VP8 and VP9 decoding.
  AVCodecParserContext* mCodecParser;

  class PtsCorrectionContext
  {
  public:
    PtsCorrectionContext();
    int64_t GuessCorrectPts(int64_t aPts, int64_t aDts);
    void Reset();
    int64_t LastDts() const { return mLastDts; }

  private:
    int64_t mNumFaultyPts; /// Number of incorrect PTS values so far
    int64_t mNumFaultyDts; /// Number of incorrect DTS values so far
    int64_t mLastPts;      /// PTS of the last frame
    int64_t mLastDts;      /// DTS of the last frame
  };

  PtsCorrectionContext mPtsContext;
  int64_t mLastInputDts;

  DurationMap mDurationMap;
  const bool mLowLatency;
};

} // namespace mozilla

#endif // __FFmpegVideoDecoder_h__
