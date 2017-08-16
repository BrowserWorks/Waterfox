/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "AudioSampleFormat.h"
#include "WAVDecoder.h"
#include "mozilla/SyncRunnable.h"

using mp4_demuxer::ByteReader;

namespace mozilla {

int16_t
DecodeALawSample(uint8_t aValue)
{
  aValue = aValue ^ 0x55;
  int8_t sign = (aValue & 0x80) ? -1 : 1;
  uint8_t exponent = (aValue & 0x70) >> 4;
  uint8_t mantissa = aValue & 0x0F;
  int16_t sample = mantissa << 4;
  switch (exponent) {
    case 0:
      sample += 8;
      break;
    case 1:
      sample += 0x108;
      break;
    default:
      sample += 0x108;
      sample <<= exponent - 1;
  }
  return sign * sample;
}

int16_t
DecodeULawSample(uint8_t aValue)
{
  aValue = aValue ^ 0xFF;
  int8_t sign = (aValue & 0x80) ? -1 : 1;
  uint8_t exponent = (aValue & 0x70) >> 4;
  uint8_t mantissa = aValue & 0x0F;
  int16_t sample = (33 + 2 * mantissa) * (2 << (exponent + 1)) - 33;
  return sign * sample;
}

WaveDataDecoder::WaveDataDecoder(const CreateDecoderParams& aParams)
  : mInfo(aParams.AudioConfig())
  , mTaskQueue(aParams.mTaskQueue)
{
}

RefPtr<ShutdownPromise>
WaveDataDecoder::Shutdown()
{
  RefPtr<WaveDataDecoder> self = this;
  return InvokeAsync(mTaskQueue, __func__, [self]() {
    return ShutdownPromise::CreateAndResolve(true, __func__);
  });
}

RefPtr<MediaDataDecoder::InitPromise>
WaveDataDecoder::Init()
{
  return InitPromise::CreateAndResolve(TrackInfo::kAudioTrack, __func__);
}

RefPtr<MediaDataDecoder::DecodePromise>
WaveDataDecoder::Decode(MediaRawData* aSample)
{
  return InvokeAsync<MediaRawData*>(mTaskQueue, this, __func__,
                                    &WaveDataDecoder::ProcessDecode, aSample);
}

RefPtr<MediaDataDecoder::DecodePromise>
WaveDataDecoder::ProcessDecode(MediaRawData* aSample)
{
  size_t aLength = aSample->Size();
  ByteReader aReader(aSample->Data(), aLength);
  int64_t aOffset = aSample->mOffset;

  int32_t frames = aLength * 8 / mInfo.mBitDepth / mInfo.mChannels;

  AlignedAudioBuffer buffer(frames * mInfo.mChannels);
  if (!buffer) {
    return DecodePromise::CreateAndReject(
      MediaResult(NS_ERROR_OUT_OF_MEMORY, __func__), __func__);
  }
  for (int i = 0; i < frames; ++i) {
    for (unsigned int j = 0; j < mInfo.mChannels; ++j) {
      if (mInfo.mProfile == 6) {                              //ALAW Data
        uint8_t v = aReader.ReadU8();
        int16_t decoded = DecodeALawSample(v);
        buffer[i * mInfo.mChannels + j] =
            IntegerToAudioSample<AudioDataValue>(decoded);
      } else if (mInfo.mProfile == 7) {                       //ULAW Data
        uint8_t v = aReader.ReadU8();
        int16_t decoded = DecodeULawSample(v);
        buffer[i * mInfo.mChannels + j] =
            IntegerToAudioSample<AudioDataValue>(decoded);
      } else {                                                //PCM Data
        if (mInfo.mBitDepth == 8) {
          uint8_t v = aReader.ReadU8();
          buffer[i * mInfo.mChannels + j] =
              UInt8bitToAudioSample<AudioDataValue>(v);
        } else if (mInfo.mBitDepth == 16) {
          int16_t v = aReader.ReadLE16();
          buffer[i * mInfo.mChannels + j] =
              IntegerToAudioSample<AudioDataValue>(v);
        } else if (mInfo.mBitDepth == 24) {
          int32_t v = aReader.ReadLE24();
          buffer[i * mInfo.mChannels + j] =
              Int24bitToAudioSample<AudioDataValue>(v);
        }
      }
    }
  }

  auto duration = FramesToTimeUnit(frames, mInfo.mRate);

  return DecodePromise::CreateAndResolve(
    DecodedData{ new AudioData(aOffset, aSample->mTime, duration, frames,
                               Move(buffer), mInfo.mChannels, mInfo.mRate) },
    __func__);
}

RefPtr<MediaDataDecoder::DecodePromise>
WaveDataDecoder::Drain()
{
  return InvokeAsync(mTaskQueue, __func__, [] {
    return DecodePromise::CreateAndResolve(DecodedData(), __func__);
  });
}

RefPtr<MediaDataDecoder::FlushPromise>
WaveDataDecoder::Flush()
{
  return InvokeAsync(mTaskQueue, __func__, []() {
    return FlushPromise::CreateAndResolve(true, __func__);
  });
}

/* static */
bool
WaveDataDecoder::IsWave(const nsACString& aMimeType)
{
  // Some WebAudio uses "audio/x-wav",
  // WAVdemuxer uses "audio/wave; codecs=aNum".
  return aMimeType.EqualsLiteral("audio/x-wav") ||
         aMimeType.EqualsLiteral("audio/wave; codecs=1") ||
         aMimeType.EqualsLiteral("audio/wave; codecs=6") ||
         aMimeType.EqualsLiteral("audio/wave; codecs=7") ||
         aMimeType.EqualsLiteral("audio/wave; codecs=65534");
}

} // namespace mozilla
#undef LOG
