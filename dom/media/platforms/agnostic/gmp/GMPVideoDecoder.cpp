/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "GMPVideoDecoder.h"
#include "GMPVideoHost.h"
#include "mozilla/EndianUtils.h"
#include "prsystem.h"
#include "MediaData.h"
#include "GMPDecoderModule.h"
#include "VPXDecoder.h"

namespace mozilla {

#if defined(DEBUG)
extern bool IsOnGMPThread();
#endif

void
VideoCallbackAdapter::Decoded(GMPVideoi420Frame* aDecodedFrame)
{
  GMPUniquePtr<GMPVideoi420Frame> decodedFrame(aDecodedFrame);

  MOZ_ASSERT(IsOnGMPThread());

  VideoData::YCbCrBuffer b;
  for (int i = 0; i < kGMPNumOfPlanes; ++i) {
    b.mPlanes[i].mData = decodedFrame->Buffer(GMPPlaneType(i));
    b.mPlanes[i].mStride = decodedFrame->Stride(GMPPlaneType(i));
    if (i == kGMPYPlane) {
      b.mPlanes[i].mWidth = decodedFrame->Width();
      b.mPlanes[i].mHeight = decodedFrame->Height();
    } else {
      b.mPlanes[i].mWidth = (decodedFrame->Width() + 1) / 2;
      b.mPlanes[i].mHeight = (decodedFrame->Height() + 1) / 2;
    }
    b.mPlanes[i].mOffset = 0;
    b.mPlanes[i].mSkip = 0;
  }

  gfx::IntRect pictureRegion(0, 0, decodedFrame->Width(), decodedFrame->Height());
  RefPtr<VideoData> v =
    VideoData::CreateAndCopyData(mVideoInfo,
                                 mImageContainer,
                                 mLastStreamOffset,
                                 decodedFrame->Timestamp(),
                                 decodedFrame->Duration(),
                                 b,
                                 false,
                                 -1,
                                 pictureRegion);
  if (v) {
    mCallback->Output(v);
  } else {
    mCallback->Error(MediaResult(NS_ERROR_OUT_OF_MEMORY, __func__));
  }
}

void
VideoCallbackAdapter::ReceivedDecodedReferenceFrame(const uint64_t aPictureId)
{
  MOZ_ASSERT(IsOnGMPThread());
}

void
VideoCallbackAdapter::ReceivedDecodedFrame(const uint64_t aPictureId)
{
  MOZ_ASSERT(IsOnGMPThread());
}

void
VideoCallbackAdapter::InputDataExhausted()
{
  MOZ_ASSERT(IsOnGMPThread());
  mCallback->InputExhausted();
}

void
VideoCallbackAdapter::DrainComplete()
{
  MOZ_ASSERT(IsOnGMPThread());
  mCallback->DrainComplete();
}

void
VideoCallbackAdapter::ResetComplete()
{
  MOZ_ASSERT(IsOnGMPThread());
  mCallback->FlushComplete();
}

void
VideoCallbackAdapter::Error(GMPErr aErr)
{
  MOZ_ASSERT(IsOnGMPThread());
  mCallback->Error(MediaResult(aErr == GMPDecodeErr
                               ? NS_ERROR_DOM_MEDIA_DECODE_ERR
                               : NS_ERROR_DOM_MEDIA_FATAL_ERR,
                               RESULT_DETAIL("GMPErr:%x", aErr)));
}

void
VideoCallbackAdapter::Terminated()
{
  // Note that this *may* be called from the proxy thread also.
  mCallback->Error(MediaResult(NS_ERROR_DOM_MEDIA_FATAL_ERR,
                               RESULT_DETAIL("Video GMP decoder terminated.")));
}

GMPVideoDecoderParams::GMPVideoDecoderParams(const CreateDecoderParams& aParams)
  : mConfig(aParams.VideoConfig())
  , mTaskQueue(aParams.mTaskQueue)
  , mCallback(nullptr)
  , mAdapter(nullptr)
  , mImageContainer(aParams.mImageContainer)
  , mLayersBackend(aParams.GetLayersBackend())
  , mCrashHelper(aParams.mCrashHelper)
{}

GMPVideoDecoderParams&
GMPVideoDecoderParams::WithCallback(MediaDataDecoderProxy* aWrapper)
{
  MOZ_ASSERT(aWrapper);
  MOZ_ASSERT(!mCallback); // Should only be called once per instance.
  mCallback = aWrapper->Callback();
  mAdapter = nullptr;
  return *this;
}

GMPVideoDecoderParams&
GMPVideoDecoderParams::WithAdapter(VideoCallbackAdapter* aAdapter)
{
  MOZ_ASSERT(aAdapter);
  MOZ_ASSERT(!mAdapter); // Should only be called once per instance.
  mCallback = aAdapter->Callback();
  mAdapter = aAdapter;
  return *this;
}

GMPVideoDecoder::GMPVideoDecoder(const GMPVideoDecoderParams& aParams)
  : mConfig(aParams.mConfig)
  , mCallback(aParams.mCallback)
  , mGMP(nullptr)
  , mHost(nullptr)
  , mAdapter(aParams.mAdapter)
  , mConvertNALUnitLengths(false)
  , mCrashHelper(aParams.mCrashHelper)
{
  MOZ_ASSERT(!mAdapter || mCallback == mAdapter->Callback());
  if (!mAdapter) {
    mAdapter = new VideoCallbackAdapter(mCallback,
                                        VideoInfo(mConfig.mDisplay.width,
                                                  mConfig.mDisplay.height),
                                        aParams.mImageContainer);
  }
}

void
GMPVideoDecoder::InitTags(nsTArray<nsCString>& aTags)
{
  if (MP4Decoder::IsH264(mConfig.mMimeType)) {
    aTags.AppendElement(NS_LITERAL_CSTRING("h264"));
    const Maybe<nsCString> gmp(
      GMPDecoderModule::PreferredGMP(NS_LITERAL_CSTRING("video/avc")));
    if (gmp.isSome()) {
      aTags.AppendElement(gmp.value());
    }
  } else if (VPXDecoder::IsVP8(mConfig.mMimeType)) {
    aTags.AppendElement(NS_LITERAL_CSTRING("vp8"));
  } else if (VPXDecoder::IsVP9(mConfig.mMimeType)) {
    aTags.AppendElement(NS_LITERAL_CSTRING("vp9"));
  }
}

nsCString
GMPVideoDecoder::GetNodeId()
{
  return SHARED_GMP_DECODING_NODE_ID;
}

GMPUniquePtr<GMPVideoEncodedFrame>
GMPVideoDecoder::CreateFrame(MediaRawData* aSample)
{
  GMPVideoFrame* ftmp = nullptr;
  GMPErr err = mHost->CreateFrame(kGMPEncodedVideoFrame, &ftmp);
  if (GMP_FAILED(err)) {
    mCallback->Error(MediaResult(NS_ERROR_OUT_OF_MEMORY,
                                 RESULT_DETAIL("Host::CreateFrame:%x", err)));
    return nullptr;
  }

  GMPUniquePtr<GMPVideoEncodedFrame> frame(static_cast<GMPVideoEncodedFrame*>(ftmp));
  err = frame->CreateEmptyFrame(aSample->Size());
  if (GMP_FAILED(err)) {
    mCallback->Error(MediaResult(NS_ERROR_OUT_OF_MEMORY,
                                 RESULT_DETAIL("GMPVideoEncodedFrame::CreateEmptyFrame:%x", err)));
    return nullptr;
  }

  memcpy(frame->Buffer(), aSample->Data(), frame->Size());

  // Convert 4-byte NAL unit lengths to host-endian 4-byte buffer lengths to
  // suit the GMP API.
  if (mConvertNALUnitLengths) {
    const int kNALLengthSize = 4;
    uint8_t* buf = frame->Buffer();
    while (buf < frame->Buffer() + frame->Size() - kNALLengthSize) {
      uint32_t length = BigEndian::readUint32(buf) + kNALLengthSize;
      *reinterpret_cast<uint32_t *>(buf) = length;
      buf += length;
    }
  }

  frame->SetBufferType(GMP_BufferLength32);

  frame->SetEncodedWidth(mConfig.mDisplay.width);
  frame->SetEncodedHeight(mConfig.mDisplay.height);
  frame->SetTimeStamp(aSample->mTime);
  frame->SetCompleteFrame(true);
  frame->SetDuration(aSample->mDuration);
  frame->SetFrameType(aSample->mKeyframe ? kGMPKeyFrame : kGMPDeltaFrame);

  return frame;
}

const VideoInfo&
GMPVideoDecoder::GetConfig() const
{
  return mConfig;
}

void
GMPVideoDecoder::GMPInitDone(GMPVideoDecoderProxy* aGMP, GMPVideoHost* aHost)
{
  MOZ_ASSERT(IsOnGMPThread());

  if (!aGMP) {
    mInitPromise.RejectIfExists(NS_ERROR_DOM_MEDIA_FATAL_ERR, __func__);
    return;
  }
  MOZ_ASSERT(aHost);

  if (mInitPromise.IsEmpty()) {
    // GMP must have been shutdown while we were waiting for Init operation
    // to complete.
    aGMP->Close();
    return;
  }

  GMPVideoCodec codec;
  memset(&codec, 0, sizeof(codec));

  codec.mGMPApiVersion = kGMPVersion33;
  nsTArray<uint8_t> codecSpecific;
  if (MP4Decoder::IsH264(mConfig.mMimeType)) {
    codec.mCodecType = kGMPVideoCodecH264;
    codecSpecific.AppendElement(0); // mPacketizationMode.
    codecSpecific.AppendElements(mConfig.mExtraData->Elements(),
                                 mConfig.mExtraData->Length());
  } else if (VPXDecoder::IsVP8(mConfig.mMimeType)) {
    codec.mCodecType = kGMPVideoCodecVP8;
  } else if (VPXDecoder::IsVP9(mConfig.mMimeType)) {
    codec.mCodecType = kGMPVideoCodecVP9;
  } else {
    // Unrecognized mime type
    aGMP->Close();
    mInitPromise.Reject(NS_ERROR_DOM_MEDIA_FATAL_ERR, __func__);
    return;
  }
  codec.mWidth = mConfig.mImage.width;
  codec.mHeight = mConfig.mImage.height;

  nsresult rv = aGMP->InitDecode(codec,
                                 codecSpecific,
                                 mAdapter,
                                 PR_GetNumberOfProcessors());
  if (NS_FAILED(rv)) {
    aGMP->Close();
    mInitPromise.Reject(NS_ERROR_DOM_MEDIA_FATAL_ERR, __func__);
    return;
  }

  mGMP = aGMP;
  mHost = aHost;

  // GMP implementations have interpreted the meaning of GMP_BufferLength32
  // differently.  The OpenH264 GMP expects GMP_BufferLength32 to behave as
  // specified in the GMP API, where each buffer is prefixed by a 32-bit
  // host-endian buffer length that includes the size of the buffer length
  // field.  Other existing GMPs currently expect GMP_BufferLength32 (when
  // combined with kGMPVideoCodecH264) to mean "like AVCC but restricted to
  // 4-byte NAL lengths" (i.e. buffer lengths are specified in big-endian
  // and do not include the length of the buffer length field.
  mConvertNALUnitLengths = mGMP->GetDisplayName().EqualsLiteral("gmpopenh264");

  mInitPromise.Resolve(TrackInfo::kVideoTrack, __func__);
}

RefPtr<MediaDataDecoder::InitPromise>
GMPVideoDecoder::Init()
{
  MOZ_ASSERT(IsOnGMPThread());

  mMPS = do_GetService("@mozilla.org/gecko-media-plugin-service;1");
  MOZ_ASSERT(mMPS);

  RefPtr<InitPromise> promise(mInitPromise.Ensure(__func__));

  nsTArray<nsCString> tags;
  InitTags(tags);
  UniquePtr<GetGMPVideoDecoderCallback> callback(new GMPInitDoneCallback(this));
  if (NS_FAILED(mMPS->GetDecryptingGMPVideoDecoder(mCrashHelper,
                                                   &tags,
                                                   GetNodeId(),
                                                   Move(callback),
                                                   DecryptorId()))) {
    mInitPromise.Reject(NS_ERROR_DOM_MEDIA_FATAL_ERR, __func__);
  }

  return promise;
}

void
GMPVideoDecoder::Input(MediaRawData* aSample)
{
  MOZ_ASSERT(IsOnGMPThread());

  RefPtr<MediaRawData> sample(aSample);
  if (!mGMP) {
    mCallback->Error(MediaResult(NS_ERROR_DOM_MEDIA_FATAL_ERR,
                                 RESULT_DETAIL("mGMP not initialized")));
    return;
  }

  mAdapter->SetLastStreamOffset(sample->mOffset);

  GMPUniquePtr<GMPVideoEncodedFrame> frame = CreateFrame(sample);
  if (!frame) {
    mCallback->Error(MediaResult(NS_ERROR_OUT_OF_MEMORY,
                                 RESULT_DETAIL("CreateFrame returned null")));
    return;
  }
  nsTArray<uint8_t> info; // No codec specific per-frame info to pass.
  nsresult rv = mGMP->Decode(Move(frame), false, info, 0);
  if (NS_FAILED(rv)) {
    mCallback->Error(MediaResult(NS_ERROR_DOM_MEDIA_DECODE_ERR,
                                 RESULT_DETAIL("mGMP->Decode:%x", rv)));
  }
}

void
GMPVideoDecoder::Flush()
{
  MOZ_ASSERT(IsOnGMPThread());

  if (!mGMP || NS_FAILED(mGMP->Reset())) {
    // Abort the flush.
    mCallback->FlushComplete();
  }
}

void
GMPVideoDecoder::Drain()
{
  MOZ_ASSERT(IsOnGMPThread());

  if (!mGMP || NS_FAILED(mGMP->Drain())) {
    mCallback->DrainComplete();
  }
}

void
GMPVideoDecoder::Shutdown()
{
  mInitPromise.RejectIfExists(NS_ERROR_DOM_MEDIA_CANCELED, __func__);
  // Note that this *may* be called from the proxy thread also.
  if (!mGMP) {
    return;
  }
  // Note this unblocks flush and drain operations waiting for callbacks.
  mGMP->Close();
  mGMP = nullptr;
}

} // namespace mozilla
