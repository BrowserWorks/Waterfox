/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "GeneratedJNIWrappers.h"
#include "MediaInfo.h"
#include "MediaPrefs.h"
#include "OpusDecoder.h"
#include "RemoteDataDecoder.h"
#include "VPXDecoder.h"
#include "VorbisDecoder.h"

#include "nsIGfxInfo.h"
#include "nsPromiseFlatString.h"

#include "prlog.h"

#include <jni.h>

#undef LOG
#define LOG(arg, ...)                                                          \
  MOZ_LOG(                                                                     \
    sAndroidDecoderModuleLog,                                                  \
    mozilla::LogLevel::Debug,                                                  \
    ("AndroidDecoderModule(%p)::%s: " arg, this, __func__, ##__VA_ARGS__))

using namespace mozilla;
using namespace mozilla::gl;
using namespace mozilla::java::sdk;
using media::TimeUnit;

namespace mozilla {

mozilla::LazyLogModule sAndroidDecoderModuleLog("AndroidDecoderModule");

static const char*
TranslateMimeType(const nsACString& aMimeType)
{
  if (VPXDecoder::IsVPX(aMimeType, VPXDecoder::VP8)) {
    return "video/x-vnd.on2.vp8";
  } else if (VPXDecoder::IsVPX(aMimeType, VPXDecoder::VP9)) {
    return "video/x-vnd.on2.vp9";
  }
  return PromiseFlatCString(aMimeType).get();
}

static bool
GetFeatureStatus(int32_t aFeature)
{
  nsCOMPtr<nsIGfxInfo> gfxInfo = services::GetGfxInfo();
  int32_t status = nsIGfxInfo::FEATURE_STATUS_UNKNOWN;
  nsCString discardFailureId;
  if (!gfxInfo || NS_FAILED(gfxInfo->GetFeatureStatus(
                    aFeature, discardFailureId, &status))) {
    return false;
  }
  return status == nsIGfxInfo::FEATURE_STATUS_OK;
};

CryptoInfo::LocalRef
GetCryptoInfoFromSample(const MediaRawData* aSample)
{
  auto& cryptoObj = aSample->mCrypto;

  if (!cryptoObj.mValid) {
    return nullptr;
  }

  CryptoInfo::LocalRef cryptoInfo;
  nsresult rv = CryptoInfo::New(&cryptoInfo);
  NS_ENSURE_SUCCESS(rv, nullptr);

  uint32_t numSubSamples = std::min<uint32_t>(
    cryptoObj.mPlainSizes.Length(), cryptoObj.mEncryptedSizes.Length());

  uint32_t totalSubSamplesSize = 0;
  for (auto& size : cryptoObj.mEncryptedSizes) {
    totalSubSamplesSize += size;
  }

  // mPlainSizes is uint16_t, need to transform to uint32_t first.
  nsTArray<uint32_t> plainSizes;
  for (auto& size : cryptoObj.mPlainSizes) {
    totalSubSamplesSize += size;
    plainSizes.AppendElement(size);
  }

  uint32_t codecSpecificDataSize = aSample->Size() - totalSubSamplesSize;
  // Size of codec specific data("CSD") for Android MediaCodec usage should be
  // included in the 1st plain size.
  plainSizes[0] += codecSpecificDataSize;

  static const int kExpectedIVLength = 16;
  auto tempIV(cryptoObj.mIV);
  auto tempIVLength = tempIV.Length();
  MOZ_ASSERT(tempIVLength <= kExpectedIVLength);
  for (size_t i = tempIVLength; i < kExpectedIVLength; i++) {
    // Padding with 0
    tempIV.AppendElement(0);
  }

  auto numBytesOfPlainData = mozilla::jni::IntArray::New(
                              reinterpret_cast<int32_t*>(&plainSizes[0]),
                              plainSizes.Length());

  auto numBytesOfEncryptedData = mozilla::jni::IntArray::New(
    reinterpret_cast<const int32_t*>(&cryptoObj.mEncryptedSizes[0]),
    cryptoObj.mEncryptedSizes.Length());
  auto iv = mozilla::jni::ByteArray::New(reinterpret_cast<int8_t*>(&tempIV[0]),
                                         tempIV.Length());
  auto keyId = mozilla::jni::ByteArray::New(
    reinterpret_cast<const int8_t*>(&cryptoObj.mKeyId[0]),
    cryptoObj.mKeyId.Length());
  cryptoInfo->Set(numSubSamples, numBytesOfPlainData, numBytesOfEncryptedData,
                  keyId, iv, MediaCodec::CRYPTO_MODE_AES_CTR);

  return cryptoInfo;
}

AndroidDecoderModule::AndroidDecoderModule(CDMProxy* aProxy)
{
  mProxy = static_cast<MediaDrmCDMProxy*>(aProxy);
}

bool
AndroidDecoderModule::SupportsMimeType(
  const nsACString& aMimeType,
  DecoderDoctorDiagnostics* aDiagnostics) const
{
  if (jni::GetAPIVersion() < 16) {
    return false;
  }

  if (aMimeType.EqualsLiteral("video/mp4") ||
      aMimeType.EqualsLiteral("video/avc")) {
    return true;
  }

  // When checking "audio/x-wav", CreateDecoder can cause a JNI ERROR by
  // Accessing a stale local reference leading to a SIGSEGV crash.
  // To avoid this we check for wav types here.
  if (aMimeType.EqualsLiteral("audio/x-wav")
      || aMimeType.EqualsLiteral("audio/wave; codecs=1")
      || aMimeType.EqualsLiteral("audio/wave; codecs=6")
      || aMimeType.EqualsLiteral("audio/wave; codecs=7")
      || aMimeType.EqualsLiteral("audio/wave; codecs=65534")) {
    return false;
  }

  if ((VPXDecoder::IsVPX(aMimeType, VPXDecoder::VP8)
       && !GetFeatureStatus(nsIGfxInfo::FEATURE_VP8_HW_DECODE))
      || (VPXDecoder::IsVPX(aMimeType, VPXDecoder::VP9)
          && !GetFeatureStatus(nsIGfxInfo::FEATURE_VP9_HW_DECODE))) {
    return false;
  }

  // Prefer the gecko decoder for opus and vorbis; stagefright crashes
  // on content demuxed from mp4.
  if (OpusDataDecoder::IsOpus(aMimeType)
      || VorbisDataDecoder::IsVorbis(aMimeType)) {
    LOG("Rejecting audio of type %s", aMimeType.Data());
    return false;
  }

  return java::HardwareCodecCapabilityUtils::FindDecoderCodecInfoForMimeType(
    nsCString(TranslateMimeType(aMimeType)));
}

already_AddRefed<MediaDataDecoder>
AndroidDecoderModule::CreateVideoDecoder(const CreateDecoderParams& aParams)
{
  // Temporary - forces use of VPXDecoder when alpha is present.
  // Bug 1263836 will handle alpha scenario once implemented. It will shift
  // the check for alpha to PDMFactory but not itself remove the need for a
  // check.
  if (aParams.VideoConfig().HasAlpha()) {
    return nullptr;
  }

  nsString drmStubId;
  if (mProxy) {
    drmStubId = mProxy->GetMediaDrmStubId();
  }

  RefPtr<MediaDataDecoder> decoder =
    RemoteDataDecoder::CreateVideoDecoder(aParams, drmStubId, mProxy);
  return decoder.forget();
}

already_AddRefed<MediaDataDecoder>
AndroidDecoderModule::CreateAudioDecoder(const CreateDecoderParams& aParams)
{
  const AudioInfo& config = aParams.AudioConfig();
  if (config.mBitDepth != 16) {
    // We only handle 16-bit audio.
    return nullptr;
  }

  LOG("CreateAudioFormat with mimeType=%s, mRate=%d, channels=%d",
      config.mMimeType.Data(), config.mRate, config.mChannels);

  nsString drmStubId;
  if (mProxy) {
    drmStubId = mProxy->GetMediaDrmStubId();
  }
  RefPtr<MediaDataDecoder> decoder =
   RemoteDataDecoder::CreateAudioDecoder(aParams, drmStubId, mProxy);
  return decoder.forget();
}

} // mozilla
