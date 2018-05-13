/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */


#include <string.h>
#ifdef __GNUC__
#include <unistd.h>
#endif

#include "FFmpegLog.h"
#include "FFmpegDataDecoder.h"
#include "mozilla/TaskQueue.h"
#include "prsystem.h"

namespace mozilla {

StaticMutex FFmpegDataDecoder<LIBAV_VER>::sMonitor;

FFmpegDataDecoder<LIBAV_VER>::FFmpegDataDecoder(FFmpegLibWrapper* aLib,
                                                TaskQueue* aTaskQueue,
                                                AVCodecID aCodecID)
  : mLib(aLib)
  , mCodecContext(nullptr)
  , mFrame(NULL)
  , mExtraData(nullptr)
  , mCodecID(aCodecID)
  , mTaskQueue(aTaskQueue)
{
  MOZ_ASSERT(aLib);
  MOZ_COUNT_CTOR(FFmpegDataDecoder);
}

FFmpegDataDecoder<LIBAV_VER>::~FFmpegDataDecoder()
{
  MOZ_COUNT_DTOR(FFmpegDataDecoder);
}

nsresult
FFmpegDataDecoder<LIBAV_VER>::InitDecoder()
{
  FFMPEG_LOG("Initialising FFmpeg decoder.");

  AVCodec* codec = FindAVCodec(mLib, mCodecID);
  if (!codec) {
    NS_WARNING("Couldn't find ffmpeg decoder");
    return NS_ERROR_FAILURE;
  }

  StaticMutexAutoLock mon(sMonitor);

  if (!(mCodecContext = mLib->avcodec_alloc_context3(codec))) {
    NS_WARNING("Couldn't init ffmpeg context");
    return NS_ERROR_FAILURE;
  }

  mCodecContext->opaque = this;

  InitCodecContext();

  if (mExtraData) {
    mCodecContext->extradata_size = mExtraData->Length();
    // FFmpeg may use SIMD instructions to access the data which reads the
    // data in 32 bytes block. Must ensure we have enough data to read.
#if LIBAVCODEC_VERSION_MAJOR >= 58
    mExtraData->AppendElements(AV_INPUT_BUFFER_PADDING_SIZE);
#else
    mExtraData->AppendElements(FF_INPUT_BUFFER_PADDING_SIZE);
#endif
    mCodecContext->extradata = mExtraData->Elements();
  } else {
    mCodecContext->extradata_size = 0;
  }

#if LIBAVCODEC_VERSION_MAJOR < 57
  if (codec->capabilities & CODEC_CAP_DR1) {
    mCodecContext->flags |= CODEC_FLAG_EMU_EDGE;
  }
#endif

  if (mLib->avcodec_open2(mCodecContext, codec, nullptr) < 0) {
    NS_WARNING("Couldn't initialise ffmpeg decoder");
    mLib->avcodec_close(mCodecContext);
    mLib->av_freep(&mCodecContext);
    return NS_ERROR_FAILURE;
  }

  FFMPEG_LOG("FFmpeg init successful.");
  return NS_OK;
}

RefPtr<ShutdownPromise>
FFmpegDataDecoder<LIBAV_VER>::Shutdown()
{
  if (mTaskQueue) {
    RefPtr<FFmpegDataDecoder<LIBAV_VER>> self = this;
    return InvokeAsync(mTaskQueue, __func__, [self, this]() {
      ProcessShutdown();
      return ShutdownPromise::CreateAndResolve(true, __func__);
    });
  }
  ProcessShutdown();
  return ShutdownPromise::CreateAndResolve(true, __func__);
}

RefPtr<MediaDataDecoder::DecodePromise>
FFmpegDataDecoder<LIBAV_VER>::Decode(MediaRawData* aSample)
{
  return InvokeAsync<MediaRawData*>(mTaskQueue, this, __func__,
                                    &FFmpegDataDecoder::ProcessDecode, aSample);
}

RefPtr<MediaDataDecoder::FlushPromise>
FFmpegDataDecoder<LIBAV_VER>::Flush()
{
  return InvokeAsync(mTaskQueue, this, __func__,
                     &FFmpegDataDecoder<LIBAV_VER>::ProcessFlush);
}

RefPtr<MediaDataDecoder::DecodePromise>
FFmpegDataDecoder<LIBAV_VER>::Drain()
{
  return InvokeAsync(mTaskQueue, this, __func__,
                     &FFmpegDataDecoder<LIBAV_VER>::ProcessDrain);
}

RefPtr<MediaDataDecoder::FlushPromise>
FFmpegDataDecoder<LIBAV_VER>::ProcessFlush()
{
  MOZ_ASSERT(mTaskQueue->IsCurrentThreadIn());
  if (mCodecContext) {
    mLib->avcodec_flush_buffers(mCodecContext);
  }
  return FlushPromise::CreateAndResolve(true, __func__);
}

void
FFmpegDataDecoder<LIBAV_VER>::ProcessShutdown()
{
  StaticMutexAutoLock mon(sMonitor);

  if (mCodecContext) {
    mLib->avcodec_close(mCodecContext);
    mLib->av_freep(&mCodecContext);
#if LIBAVCODEC_VERSION_MAJOR >= 55
    mLib->av_frame_free(&mFrame);
#elif LIBAVCODEC_VERSION_MAJOR == 54
    mLib->avcodec_free_frame(&mFrame);
#else
    mLib->av_freep(&mFrame);
#endif
  }
}

AVFrame*
FFmpegDataDecoder<LIBAV_VER>::PrepareFrame()
{
  MOZ_ASSERT(mTaskQueue->IsCurrentThreadIn());
#if LIBAVCODEC_VERSION_MAJOR >= 55
  if (mFrame) {
    mLib->av_frame_unref(mFrame);
  } else {
    mFrame = mLib->av_frame_alloc();
  }
#elif LIBAVCODEC_VERSION_MAJOR == 54
  if (mFrame) {
    mLib->avcodec_get_frame_defaults(mFrame);
  } else {
    mFrame = mLib->avcodec_alloc_frame();
  }
#else
  mLib->av_freep(&mFrame);
  mFrame = mLib->avcodec_alloc_frame();
#endif
  return mFrame;
}

/* static */ AVCodec*
FFmpegDataDecoder<LIBAV_VER>::FindAVCodec(FFmpegLibWrapper* aLib,
                                          AVCodecID aCodec)
{
  return aLib->avcodec_find_decoder(aCodec);
}

} // namespace mozilla
