/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "MediaData.h"

#include "ImageContainer.h"
#include "MediaInfo.h"
#include "VideoUtils.h"
#include "YCbCrUtils.h"
#include "mozilla/layers/ImageBridgeChild.h"
#include "mozilla/layers/KnowsCompositor.h"
#include "mozilla/layers/SharedRGBImage.h"

#include <stdint.h>

#ifdef XP_WIN
#include "mozilla/WindowsVersion.h"
#include "mozilla/layers/D3D11YCbCrImage.h"
#endif

namespace mozilla {

using namespace mozilla::gfx;
using layers::ImageContainer;
using layers::PlanarYCbCrImage;
using layers::PlanarYCbCrData;
using media::TimeUnit;

const char* AudioData::sTypeName = "audio";
const char* VideoData::sTypeName = "video";

bool
IsDataLoudnessHearable(const AudioDataValue aData)
{
  // We can transfer the digital value to dBFS via following formula. According
  // to American SMPTE standard, 0 dBu equals -20 dBFS. In theory 0 dBu is still
  // hearable, so we choose a smaller value as our threshold. If the loudness
  // is under this threshold, it might not be hearable.
  return 20.0f * std::log10(AudioSampleToFloat(aData)) > -100;
}

void
AudioData::EnsureAudioBuffer()
{
  if (mAudioBuffer)
    return;
  mAudioBuffer = SharedBuffer::Create(mFrames*mChannels*sizeof(AudioDataValue));

  AudioDataValue* data = static_cast<AudioDataValue*>(mAudioBuffer->Data());
  for (uint32_t i = 0; i < mFrames; ++i) {
    for (uint32_t j = 0; j < mChannels; ++j) {
      data[j*mFrames + i] = mAudioData[i*mChannels + j];
    }
  }
}

size_t
AudioData::SizeOfIncludingThis(MallocSizeOf aMallocSizeOf) const
{
  size_t size =
    aMallocSizeOf(this) + mAudioData.SizeOfExcludingThis(aMallocSizeOf);
  if (mAudioBuffer) {
    size += mAudioBuffer->SizeOfIncludingThis(aMallocSizeOf);
  }
  return size;
}

bool
AudioData::IsAudible() const
{
  if (!mAudioData) {
    return false;
  }

  for (uint32_t frame = 0; frame < mFrames; ++frame) {
    for (uint32_t channel = 0; channel < mChannels; ++channel) {
      if (IsDataLoudnessHearable(mAudioData[frame * mChannels + channel])) {
        return true;
      }
    }
  }
  return false;
}

/* static */
already_AddRefed<AudioData>
AudioData::TransferAndUpdateTimestampAndDuration(AudioData* aOther,
                                                 const TimeUnit& aTimestamp,
                                                 const TimeUnit& aDuration)
{
  NS_ENSURE_TRUE(aOther, nullptr);
  RefPtr<AudioData> v = new AudioData(aOther->mOffset,
                                      aTimestamp,
                                      aDuration,
                                      aOther->mFrames,
                                      Move(aOther->mAudioData),
                                      aOther->mChannels,
                                      aOther->mRate);
  return v.forget();
}

static bool
ValidatePlane(const VideoData::YCbCrBuffer::Plane& aPlane)
{
  return aPlane.mWidth <= PlanarYCbCrImage::MAX_DIMENSION
         && aPlane.mHeight <= PlanarYCbCrImage::MAX_DIMENSION
         && aPlane.mWidth * aPlane.mHeight < MAX_VIDEO_WIDTH * MAX_VIDEO_HEIGHT
         && aPlane.mStride > 0;
}

static bool ValidateBufferAndPicture(const VideoData::YCbCrBuffer& aBuffer,
                                     const IntRect& aPicture)
{
  // The following situation should never happen unless there is a bug
  // in the decoder
  if (aBuffer.mPlanes[1].mWidth != aBuffer.mPlanes[2].mWidth
      || aBuffer.mPlanes[1].mHeight != aBuffer.mPlanes[2].mHeight) {
    NS_ERROR("C planes with different sizes");
    return false;
  }

  // The following situations could be triggered by invalid input
  if (aPicture.width <= 0 || aPicture.height <= 0) {
    // In debug mode, makes the error more noticeable
    MOZ_ASSERT(false, "Empty picture rect");
    return false;
  }
  if (!ValidatePlane(aBuffer.mPlanes[0])
      || !ValidatePlane(aBuffer.mPlanes[1])
      || !ValidatePlane(aBuffer.mPlanes[2])) {
    NS_WARNING("Invalid plane size");
    return false;
  }

  // Ensure the picture size specified in the headers can be extracted out of
  // the frame we've been supplied without indexing out of bounds.
  CheckedUint32 xLimit = aPicture.x + CheckedUint32(aPicture.width);
  CheckedUint32 yLimit = aPicture.y + CheckedUint32(aPicture.height);
  if (!xLimit.isValid()
      || xLimit.value() > aBuffer.mPlanes[0].mStride
      || !yLimit.isValid()
      || yLimit.value() > aBuffer.mPlanes[0].mHeight)
  {
    // The specified picture dimensions can't be contained inside the video
    // frame, we'll stomp memory if we try to copy it. Fail.
    NS_WARNING("Overflowing picture rect");
    return false;
  }
  return true;
}

VideoData::VideoData(int64_t aOffset,
                     const TimeUnit& aTime,
                     const TimeUnit& aDuration,
                     bool aKeyframe,
                     const TimeUnit& aTimecode,
                     IntSize aDisplay,
                     layers::ImageContainer::FrameID aFrameID)
  : MediaData(VIDEO_DATA, aOffset, aTime, aDuration, 1)
  , mDisplay(aDisplay)
  , mFrameID(aFrameID)
  , mSentToCompositor(false)
  , mNextKeyFrameTime(TimeUnit::Invalid())
{
  MOZ_ASSERT(!mDuration.IsNegative(), "Frame must have non-negative duration.");
  mKeyframe = aKeyframe;
  mTimecode = aTimecode;
}

VideoData::~VideoData()
{
}

void
VideoData::SetListener(UniquePtr<Listener> aListener)
{
  MOZ_ASSERT(!mSentToCompositor,
             "Listener should be registered before sending data");

  mListener = Move(aListener);
}

void
VideoData::MarkSentToCompositor()
{
  if (mSentToCompositor) {
    return;
  }

  mSentToCompositor = true;
  if (mListener != nullptr) {
    mListener->OnSentToCompositor();
    mListener = nullptr;
  }
}

size_t
VideoData::SizeOfIncludingThis(MallocSizeOf aMallocSizeOf) const
{
  size_t size = aMallocSizeOf(this);

  // Currently only PLANAR_YCBCR has a well defined function for determining
  // it's size, so reporting is limited to that type.
  if (mImage && mImage->GetFormat() == ImageFormat::PLANAR_YCBCR) {
    const mozilla::layers::PlanarYCbCrImage* img =
        static_cast<const mozilla::layers::PlanarYCbCrImage*>(mImage.get());
    size += img->SizeOfIncludingThis(aMallocSizeOf);
  }

  return size;
}

void
VideoData::UpdateDuration(const TimeUnit& aDuration)
{
  MOZ_ASSERT(!aDuration.IsNegative());
  mDuration = aDuration;
}

void
VideoData::UpdateTimestamp(const TimeUnit& aTimestamp)
{
  MOZ_ASSERT(!aTimestamp.IsNegative());

  auto updatedDuration = GetEndTime() - aTimestamp;
  MOZ_ASSERT(!updatedDuration.IsNegative());

  mTime = aTimestamp;
  mDuration = updatedDuration;
}

PlanarYCbCrData
ConstructPlanarYCbCrData(const VideoInfo& aInfo,
                         const VideoData::YCbCrBuffer& aBuffer,
                         const IntRect& aPicture)
{
  const VideoData::YCbCrBuffer::Plane& Y = aBuffer.mPlanes[0];
  const VideoData::YCbCrBuffer::Plane& Cb = aBuffer.mPlanes[1];
  const VideoData::YCbCrBuffer::Plane& Cr = aBuffer.mPlanes[2];

  PlanarYCbCrData data;
  data.mYChannel = Y.mData + Y.mOffset;
  data.mYSize = IntSize(Y.mWidth, Y.mHeight);
  data.mYStride = Y.mStride;
  data.mYSkip = Y.mSkip;
  data.mCbChannel = Cb.mData + Cb.mOffset;
  data.mCrChannel = Cr.mData + Cr.mOffset;
  data.mCbCrSize = IntSize(Cb.mWidth, Cb.mHeight);
  data.mCbCrStride = Cb.mStride;
  data.mCbSkip = Cb.mSkip;
  data.mCrSkip = Cr.mSkip;
  data.mPicX = aPicture.x;
  data.mPicY = aPicture.y;
  data.mPicSize = aPicture.Size();
  data.mStereoMode = aInfo.mStereoMode;
  data.mYUVColorSpace = aBuffer.mYUVColorSpace;
  return data;
}

/* static */ bool
VideoData::SetVideoDataToImage(PlanarYCbCrImage* aVideoImage,
                               const VideoInfo& aInfo,
                               const YCbCrBuffer &aBuffer,
                               const IntRect& aPicture,
                               bool aCopyData)
{
  if (!aVideoImage) {
    return false;
  }

  PlanarYCbCrData data = ConstructPlanarYCbCrData(aInfo, aBuffer, aPicture);

  aVideoImage->SetDelayedConversion(true);
  if (aCopyData) {
    return aVideoImage->CopyData(data);
  } else {
    return aVideoImage->AdoptData(data);
  }
}

/* static */
already_AddRefed<VideoData>
VideoData::CreateAndCopyData(const VideoInfo& aInfo,
                             ImageContainer* aContainer,
                             int64_t aOffset,
                             const TimeUnit& aTime,
                             const TimeUnit& aDuration,
                             const YCbCrBuffer& aBuffer,
                             bool aKeyframe,
                             const TimeUnit& aTimecode,
                             const IntRect& aPicture,
                             layers::KnowsCompositor* aAllocator)
{
  if (!aContainer) {
    // Create a dummy VideoData with no image. This gives us something to
    // send to media streams if necessary.
    RefPtr<VideoData> v(new VideoData(aOffset,
                                      aTime,
                                      aDuration,
                                      aKeyframe,
                                      aTimecode,
                                      aInfo.mDisplay,
                                      0));
    return v.forget();
  }

  if (!ValidateBufferAndPicture(aBuffer, aPicture)) {
    return nullptr;
  }

  RefPtr<VideoData> v(new VideoData(aOffset,
                                    aTime,
                                    aDuration,
                                    aKeyframe,
                                    aTimecode,
                                    aInfo.mDisplay,
                                    0));

  // Currently our decoder only knows how to output to ImageFormat::PLANAR_YCBCR
  // format.
#if XP_WIN
  // We disable this code path on Windows version earlier of Windows 8 due to
  // intermittent crashes with old drivers. See bug 1405110.
  if (IsWin8OrLater() && aAllocator && aAllocator->GetCompositorBackendType()
                    == layers::LayersBackend::LAYERS_D3D11) {
    RefPtr<layers::D3D11YCbCrImage> d3d11Image = new layers::D3D11YCbCrImage();
    PlanarYCbCrData data = ConstructPlanarYCbCrData(aInfo, aBuffer, aPicture);
    if (d3d11Image->SetData(layers::ImageBridgeChild::GetSingleton()
                            ? layers::ImageBridgeChild::GetSingleton().get()
                            : aAllocator,
                            aContainer, data)) {
      v->mImage = d3d11Image;
      return v.forget();
    }
  }
#endif
  if (!v->mImage) {
    v->mImage = aContainer->CreatePlanarYCbCrImage();
  }

  if (!v->mImage) {
    return nullptr;
  }
  NS_ASSERTION(v->mImage->GetFormat() == ImageFormat::PLANAR_YCBCR,
               "Wrong format?");
  PlanarYCbCrImage* videoImage = v->mImage->AsPlanarYCbCrImage();
  MOZ_ASSERT(videoImage);

  if (!VideoData::SetVideoDataToImage(videoImage, aInfo, aBuffer, aPicture,
                                      true /* aCopyData */)) {
    return nullptr;
  }

  return v.forget();
}


/* static */
already_AddRefed<VideoData>
VideoData::CreateAndCopyData(const VideoInfo& aInfo,
                             ImageContainer* aContainer,
                             int64_t aOffset,
                             const TimeUnit& aTime,
                             const TimeUnit& aDuration,
                             const YCbCrBuffer& aBuffer,
                             const YCbCrBuffer::Plane &aAlphaPlane,
                             bool aKeyframe,
                             const TimeUnit& aTimecode,
                             const IntRect& aPicture)
{
  if (!aContainer) {
    // Create a dummy VideoData with no image. This gives us something to
    // send to media streams if necessary.
    RefPtr<VideoData> v(new VideoData(aOffset,
                                      aTime,
                                      aDuration,
                                      aKeyframe,
                                      aTimecode,
                                      aInfo.mDisplay,
                                      0));
    return v.forget();
  }

  if (!ValidateBufferAndPicture(aBuffer, aPicture)) {
    return nullptr;
  }

  RefPtr<VideoData> v(new VideoData(aOffset,
                                    aTime,
                                    aDuration,
                                    aKeyframe,
                                    aTimecode,
                                    aInfo.mDisplay,
                                    0));

  // Convert from YUVA to BGRA format on the software side.
  RefPtr<layers::SharedRGBImage> videoImage =
    aContainer->CreateSharedRGBImage();
  v->mImage = videoImage;

  if (!v->mImage) {
    return nullptr;
  }
  if (!videoImage->Allocate(IntSize(aBuffer.mPlanes[0].mWidth,
                                    aBuffer.mPlanes[0].mHeight),
                            SurfaceFormat::B8G8R8A8)) {
    return nullptr;
  }
  uint8_t* argb_buffer = videoImage->GetBuffer();
  IntSize size = videoImage->GetSize();

  // The naming convention for libyuv and associated utils is word-order.
  // The naming convention in the gfx stack is byte-order.
  ConvertYCbCrAToARGB(aBuffer.mPlanes[0].mData,
                      aBuffer.mPlanes[1].mData,
                      aBuffer.mPlanes[2].mData,
                      aAlphaPlane.mData,
                      aBuffer.mPlanes[0].mStride, aBuffer.mPlanes[1].mStride,
                      argb_buffer, size.width * 4,
                      size.width, size.height);

  return v.forget();
}

/* static */
already_AddRefed<VideoData>
VideoData::CreateFromImage(const IntSize& aDisplay,
                           int64_t aOffset,
                           const TimeUnit& aTime,
                           const TimeUnit& aDuration,
                           const RefPtr<Image>& aImage,
                           bool aKeyframe,
                           const TimeUnit& aTimecode)
{
  RefPtr<VideoData> v(new VideoData(aOffset,
                                    aTime,
                                    aDuration,
                                    aKeyframe,
                                    aTimecode,
                                    aDisplay,
                                    0));
  v->mImage = aImage;
  return v.forget();
}

MediaRawData::MediaRawData()
  : MediaData(RAW_DATA, 0)
  , mCrypto(mCryptoInternal)
{
}

MediaRawData::MediaRawData(const uint8_t* aData, size_t aSize)
  : MediaData(RAW_DATA, 0)
  , mCrypto(mCryptoInternal)
  , mBuffer(aData, aSize)
{
}

MediaRawData::MediaRawData(const uint8_t* aData, size_t aSize,
                           const uint8_t* aAlphaData, size_t aAlphaSize)
  : MediaData(RAW_DATA, 0)
  , mCrypto(mCryptoInternal)
  , mBuffer(aData, aSize)
  , mAlphaBuffer(aAlphaData, aAlphaSize)
{
}

already_AddRefed<MediaRawData>
MediaRawData::Clone() const
{
  RefPtr<MediaRawData> s = new MediaRawData;
  s->mTimecode = mTimecode;
  s->mTime = mTime;
  s->mDuration = mDuration;
  s->mOffset = mOffset;
  s->mKeyframe = mKeyframe;
  s->mExtraData = mExtraData;
  s->mCryptoInternal = mCryptoInternal;
  s->mTrackInfo = mTrackInfo;
  s->mEOS = mEOS;
  if (!s->mBuffer.Append(mBuffer.Data(), mBuffer.Length())) {
    return nullptr;
  }
  if (!s->mAlphaBuffer.Append(mAlphaBuffer.Data(), mAlphaBuffer.Length())) {
    return nullptr;
  }
  return s.forget();
}

MediaRawData::~MediaRawData()
{
}

size_t
MediaRawData::SizeOfIncludingThis(MallocSizeOf aMallocSizeOf) const
{
  size_t size = aMallocSizeOf(this);
  size += mBuffer.SizeOfExcludingThis(aMallocSizeOf);
  return size;
}

MediaRawDataWriter*
MediaRawData::CreateWriter()
{
  return new MediaRawDataWriter(this);
}

MediaRawDataWriter::MediaRawDataWriter(MediaRawData* aMediaRawData)
  : mCrypto(aMediaRawData->mCryptoInternal)
  , mTarget(aMediaRawData)
{
}

bool
MediaRawDataWriter::SetSize(size_t aSize)
{
  return mTarget->mBuffer.SetLength(aSize);
}

bool
MediaRawDataWriter::Prepend(const uint8_t* aData, size_t aSize)
{
  return mTarget->mBuffer.Prepend(aData, aSize);
}

bool
MediaRawDataWriter::Replace(const uint8_t* aData, size_t aSize)
{
  return mTarget->mBuffer.Replace(aData, aSize);
}

void
MediaRawDataWriter::Clear()
{
  mTarget->mBuffer.Clear();
}

uint8_t*
MediaRawDataWriter::Data()
{
  return mTarget->mBuffer.Data();
}

size_t
MediaRawDataWriter::Size()
{
  return mTarget->Size();
}

} // namespace mozilla
