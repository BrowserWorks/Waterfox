/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/TaskQueue.h"

#include "nsThreadUtils.h"
#include "ImageContainer.h"

#include "MediaInfo.h"
#include "VPXDecoder.h"
#include "MP4Decoder.h"

#include "FFmpegVideoDecoder.h"
#include "FFmpegLog.h"
#include "mozilla/PodOperations.h"

#include "libavutil/pixfmt.h"
#if LIBAVCODEC_VERSION_MAJOR < 54
#define AVPixelFormat PixelFormat
#define AV_PIX_FMT_YUV420P PIX_FMT_YUV420P
#define AV_PIX_FMT_YUVJ420P PIX_FMT_YUVJ420P
#define AV_PIX_FMT_YUV444P PIX_FMT_YUV444P
#define AV_PIX_FMT_NONE PIX_FMT_NONE
#endif

typedef mozilla::layers::Image Image;
typedef mozilla::layers::PlanarYCbCrImage PlanarYCbCrImage;

namespace mozilla
{

/**
 * FFmpeg calls back to this function with a list of pixel formats it supports.
 * We choose a pixel format that we support and return it.
 * For now, we just look for YUV420P, YUVJ420P and YUV444 as those are the only
 * only non-HW accelerated format supported by FFmpeg's H264 and VP9 decoder.
 */
static AVPixelFormat
ChoosePixelFormat(AVCodecContext* aCodecContext, const AVPixelFormat* aFormats)
{
  FFMPEG_LOG("Choosing FFmpeg pixel format for video decoding.");
  for (; *aFormats > -1; aFormats++) {
    switch (*aFormats) {
      case AV_PIX_FMT_YUV444P:
        FFMPEG_LOG("Requesting pixel format YUV444P.");
        return AV_PIX_FMT_YUV444P;
      case AV_PIX_FMT_YUV420P:
        FFMPEG_LOG("Requesting pixel format YUV420P.");
        return AV_PIX_FMT_YUV420P;
      case AV_PIX_FMT_YUVJ420P:
        FFMPEG_LOG("Requesting pixel format YUVJ420P.");
        return AV_PIX_FMT_YUVJ420P;
      default:
        break;
    }
  }

  NS_WARNING("FFmpeg does not share any supported pixel formats.");
  return AV_PIX_FMT_NONE;
}

FFmpegVideoDecoder<LIBAV_VER>::PtsCorrectionContext::PtsCorrectionContext()
  : mNumFaultyPts(0)
  , mNumFaultyDts(0)
  , mLastPts(INT64_MIN)
  , mLastDts(INT64_MIN)
{
}

int64_t
FFmpegVideoDecoder<LIBAV_VER>::PtsCorrectionContext::GuessCorrectPts(int64_t aPts, int64_t aDts)
{
  int64_t pts = AV_NOPTS_VALUE;

  if (aDts != int64_t(AV_NOPTS_VALUE)) {
    mNumFaultyDts += aDts <= mLastDts;
    mLastDts = aDts;
  }
  if (aPts != int64_t(AV_NOPTS_VALUE)) {
    mNumFaultyPts += aPts <= mLastPts;
    mLastPts = aPts;
  }
  if ((mNumFaultyPts <= mNumFaultyDts || aDts == int64_t(AV_NOPTS_VALUE)) &&
      aPts != int64_t(AV_NOPTS_VALUE)) {
    pts = aPts;
  } else {
    pts = aDts;
  }
  return pts;
}

void
FFmpegVideoDecoder<LIBAV_VER>::PtsCorrectionContext::Reset()
{
  mNumFaultyPts = 0;
  mNumFaultyDts = 0;
  mLastPts = INT64_MIN;
  mLastDts = INT64_MIN;
}

FFmpegVideoDecoder<LIBAV_VER>::FFmpegVideoDecoder(FFmpegLibWrapper* aLib,
  TaskQueue* aTaskQueue, MediaDataDecoderCallback* aCallback,
  const VideoInfo& aConfig,
  ImageContainer* aImageContainer)
  : FFmpegDataDecoder(aLib, aTaskQueue, aCallback, GetCodecId(aConfig.mMimeType))
  , mImageContainer(aImageContainer)
  , mInfo(aConfig)
  , mCodecParser(nullptr)
  , mLastInputDts(INT64_MIN)
{
  MOZ_COUNT_CTOR(FFmpegVideoDecoder);
  // Use a new MediaByteBuffer as the object will be modified during initialization.
  mExtraData = new MediaByteBuffer;
  mExtraData->AppendElements(*aConfig.mExtraData);
}

RefPtr<MediaDataDecoder::InitPromise>
FFmpegVideoDecoder<LIBAV_VER>::Init()
{
  if (NS_FAILED(InitDecoder())) {
    return InitPromise::CreateAndReject(NS_ERROR_DOM_MEDIA_FATAL_ERR, __func__);
  }

  return InitPromise::CreateAndResolve(TrackInfo::kVideoTrack, __func__);
}

void
FFmpegVideoDecoder<LIBAV_VER>::InitCodecContext()
{
  mCodecContext->width = mInfo.mImage.width;
  mCodecContext->height = mInfo.mImage.height;

  // We use the same logic as libvpx in determining the number of threads to use
  // so that we end up behaving in the same fashion when using ffmpeg as
  // we would otherwise cause various crashes (see bug 1236167)
  int decode_threads = 1;
  if (mInfo.mDisplay.width >= 2048) {
    decode_threads = 8;
  } else if (mInfo.mDisplay.width >= 1024) {
    decode_threads = 4;
  } else if (mInfo.mDisplay.width >= 320) {
    decode_threads = 2;
  }

  decode_threads = std::min(decode_threads, PR_GetNumberOfProcessors() - 1);
  decode_threads = std::max(decode_threads, 1);
  mCodecContext->thread_count = decode_threads;
  if (decode_threads > 1) {
    mCodecContext->thread_type = FF_THREAD_SLICE | FF_THREAD_FRAME;
  }

  // FFmpeg will call back to this to negotiate a video pixel format.
  mCodecContext->get_format = ChoosePixelFormat;

  mCodecParser = mLib->av_parser_init(mCodecID);
  if (mCodecParser) {
    mCodecParser->flags |= PARSER_FLAG_COMPLETE_FRAMES;
  }
}

MediaResult
FFmpegVideoDecoder<LIBAV_VER>::DoDecode(MediaRawData* aSample)
{
  bool gotFrame = false;
  return DoDecode(aSample, &gotFrame);
}

MediaResult
FFmpegVideoDecoder<LIBAV_VER>::DoDecode(MediaRawData* aSample, bool* aGotFrame)
{
  uint8_t* inputData = const_cast<uint8_t*>(aSample->Data());
  size_t inputSize = aSample->Size();

#if LIBAVCODEC_VERSION_MAJOR >= 54
  if (inputSize && mCodecParser && (mCodecID == AV_CODEC_ID_VP8
#if LIBAVCODEC_VERSION_MAJOR >= 55
      || mCodecID == AV_CODEC_ID_VP9
#endif
      )) {
    while (inputSize) {
      uint8_t* data;
      int size;
      int len = mLib->av_parser_parse2(mCodecParser, mCodecContext, &data, &size,
                                       inputData, inputSize,
                                       aSample->mTime, aSample->mTimecode,
                                       aSample->mOffset);
      if (size_t(len) > inputSize) {
        return NS_ERROR_DOM_MEDIA_DECODE_ERR;
      }
      inputData += len;
      inputSize -= len;
      if (size) {
        bool gotFrame = false;
        MediaResult rv = DoDecode(aSample, data, size, &gotFrame);
        if (NS_FAILED(rv)) {
          return rv;
        }
        if (gotFrame && aGotFrame) {
          *aGotFrame = true;
        }
      }
    }
    return NS_OK;
  }
#endif
  return DoDecode(aSample, inputData, inputSize, aGotFrame);
}

MediaResult
FFmpegVideoDecoder<LIBAV_VER>::DoDecode(MediaRawData* aSample,
                                        uint8_t* aData, int aSize,
                                        bool* aGotFrame)
{
  AVPacket packet;
  mLib->av_init_packet(&packet);

  packet.data = aData;
  packet.size = aSize;
  packet.dts = mLastInputDts = aSample->mTimecode;
  packet.pts = aSample->mTime;
  packet.flags = aSample->mKeyframe ? AV_PKT_FLAG_KEY : 0;
  packet.pos = aSample->mOffset;

  // LibAV provides no API to retrieve the decoded sample's duration.
  // (FFmpeg >= 1.0 provides av_frame_get_pkt_duration)
  // As such we instead use a map using the dts as key that we will retrieve
  // later.
  // The map will have a typical size of 16 entry.
  mDurationMap.Insert(aSample->mTimecode, aSample->mDuration);

  if (!PrepareFrame()) {
    NS_WARNING("FFmpeg h264 decoder failed to allocate frame.");
    return MediaResult(NS_ERROR_OUT_OF_MEMORY, __func__);
  }

  // Required with old version of FFmpeg/LibAV
  mFrame->reordered_opaque = AV_NOPTS_VALUE;

  int decoded;
  int bytesConsumed =
    mLib->avcodec_decode_video2(mCodecContext, mFrame, &decoded, &packet);

  FFMPEG_LOG("DoDecodeFrame:decode_video: rv=%d decoded=%d "
             "(Input: pts(%lld) dts(%lld) Output: pts(%lld) "
             "opaque(%lld) pkt_pts(%lld) pkt_dts(%lld))",
             bytesConsumed, decoded, packet.pts, packet.dts, mFrame->pts,
             mFrame->reordered_opaque, mFrame->pkt_pts, mFrame->pkt_dts);

  if (bytesConsumed < 0) {
    return MediaResult(NS_ERROR_DOM_MEDIA_DECODE_ERR,
                       RESULT_DETAIL("FFmpeg video error:%d", bytesConsumed));
  }

  if (!decoded) {
    if (aGotFrame) {
      *aGotFrame = false;
    }
    return NS_OK;
  }

  // If we've decoded a frame then we need to output it
  int64_t pts = mPtsContext.GuessCorrectPts(mFrame->pkt_pts, mFrame->pkt_dts);
  // Retrieve duration from dts.
  // We use the first entry found matching this dts (this is done to
  // handle damaged file with multiple frames with the same dts)

  int64_t duration;
  if (!mDurationMap.Find(mFrame->pkt_dts, duration)) {
    NS_WARNING("Unable to retrieve duration from map");
    duration = aSample->mDuration;
    // dts are probably incorrectly reported ; so clear the map as we're
    // unlikely to find them in the future anyway. This also guards
    // against the map becoming extremely big.
    mDurationMap.Clear();
  }
  FFMPEG_LOG("Got one frame output with pts=%lld dts=%lld duration=%lld opaque=%lld",
              pts, mFrame->pkt_dts, duration, mCodecContext->reordered_opaque);

  VideoData::YCbCrBuffer b;
  b.mPlanes[0].mData = mFrame->data[0];
  b.mPlanes[1].mData = mFrame->data[1];
  b.mPlanes[2].mData = mFrame->data[2];

  b.mPlanes[0].mStride = mFrame->linesize[0];
  b.mPlanes[1].mStride = mFrame->linesize[1];
  b.mPlanes[2].mStride = mFrame->linesize[2];

  b.mPlanes[0].mOffset = b.mPlanes[0].mSkip = 0;
  b.mPlanes[1].mOffset = b.mPlanes[1].mSkip = 0;
  b.mPlanes[2].mOffset = b.mPlanes[2].mSkip = 0;

  b.mPlanes[0].mWidth = mFrame->width;
  b.mPlanes[0].mHeight = mFrame->height;
  if (mCodecContext->pix_fmt == AV_PIX_FMT_YUV444P) {
    b.mPlanes[1].mWidth = b.mPlanes[2].mWidth = mFrame->width;
    b.mPlanes[1].mHeight = b.mPlanes[2].mHeight = mFrame->height;
  } else {
    b.mPlanes[1].mWidth = b.mPlanes[2].mWidth = (mFrame->width + 1) >> 1;
    b.mPlanes[1].mHeight = b.mPlanes[2].mHeight = (mFrame->height + 1) >> 1;
  }
  if (mLib->av_frame_get_colorspace) {
    switch (mLib->av_frame_get_colorspace(mFrame)) {
      case AVCOL_SPC_BT709:
        b.mYUVColorSpace = YUVColorSpace::BT709;
        break;
      case AVCOL_SPC_SMPTE170M:
      case AVCOL_SPC_BT470BG:
        b.mYUVColorSpace = YUVColorSpace::BT601;
        break;
      default:
        break;
    }
  }
  RefPtr<VideoData> v =
    VideoData::CreateAndCopyData(mInfo,
                                  mImageContainer,
                                  aSample->mOffset,
                                  pts,
                                  duration,
                                  b,
                                  !!mFrame->key_frame,
                                  -1,
                                  mInfo.ScaledImageRect(mFrame->width,
                                                        mFrame->height));

  if (!v) {
    return MediaResult(NS_ERROR_OUT_OF_MEMORY,
                       RESULT_DETAIL("image allocation error"));
  }
  mCallback->Output(v);
  if (aGotFrame) {
    *aGotFrame = true;
  }
  return NS_OK;
}

void
FFmpegVideoDecoder<LIBAV_VER>::ProcessDrain()
{
  RefPtr<MediaRawData> empty(new MediaRawData());
  empty->mTimecode = mLastInputDts;
  bool gotFrame = false;
  while (NS_SUCCEEDED(DoDecode(empty, &gotFrame)) && gotFrame);
  mCallback->DrainComplete();
}

void
FFmpegVideoDecoder<LIBAV_VER>::ProcessFlush()
{
  mPtsContext.Reset();
  mDurationMap.Clear();
  FFmpegDataDecoder::ProcessFlush();
}

FFmpegVideoDecoder<LIBAV_VER>::~FFmpegVideoDecoder()
{
  MOZ_COUNT_DTOR(FFmpegVideoDecoder);
  if (mCodecParser) {
    mLib->av_parser_close(mCodecParser);
    mCodecParser = nullptr;
  }
}

AVCodecID
FFmpegVideoDecoder<LIBAV_VER>::GetCodecId(const nsACString& aMimeType)
{
  if (MP4Decoder::IsH264(aMimeType)) {
    return AV_CODEC_ID_H264;
  }

  if (aMimeType.EqualsLiteral("video/x-vnd.on2.vp6")) {
    return AV_CODEC_ID_VP6F;
  }

#if LIBAVCODEC_VERSION_MAJOR >= 54
  if (VPXDecoder::IsVP8(aMimeType)) {
    return AV_CODEC_ID_VP8;
  }
#endif

#if LIBAVCODEC_VERSION_MAJOR >= 55
  if (VPXDecoder::IsVP9(aMimeType)) {
    return AV_CODEC_ID_VP9;
  }
#endif

  return AV_CODEC_ID_NONE;
}

} // namespace mozilla
