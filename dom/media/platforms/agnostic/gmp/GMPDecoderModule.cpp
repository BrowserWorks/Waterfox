/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "GMPDecoderModule.h"
#include "DecoderDoctorDiagnostics.h"
#include "GMPAudioDecoder.h"
#include "GMPVideoDecoder.h"
#include "GMPUtils.h"
#include "MediaDataDecoderProxy.h"
#include "MediaPrefs.h"
#include "VideoUtils.h"
#include "mozIGeckoMediaPluginService.h"
#include "nsServiceManagerUtils.h"
#include "mozilla/StaticMutex.h"
#include "gmp-audio-decode.h"
#include "gmp-video-decode.h"
#include "MP4Decoder.h"
#include "VPXDecoder.h"
#ifdef XP_WIN
#include "WMFDecoderModule.h"
#endif

namespace mozilla {

GMPDecoderModule::GMPDecoderModule()
{
}

GMPDecoderModule::~GMPDecoderModule()
{
}

static already_AddRefed<MediaDataDecoderProxy>
CreateDecoderWrapper(MediaDataDecoderCallback* aCallback)
{
  RefPtr<gmp::GeckoMediaPluginService> s(gmp::GeckoMediaPluginService::GetGeckoMediaPluginService());
  if (!s) {
    return nullptr;
  }
  RefPtr<AbstractThread> thread(s->GetAbstractGMPThread());
  if (!thread) {
    return nullptr;
  }
  RefPtr<MediaDataDecoderProxy> decoder(new MediaDataDecoderProxy(thread.forget(), aCallback));
  return decoder.forget();
}

already_AddRefed<MediaDataDecoder>
GMPDecoderModule::CreateVideoDecoder(const CreateDecoderParams& aParams)
{
  if (!MP4Decoder::IsH264(aParams.mConfig.mMimeType) &&
      !VPXDecoder::IsVP8(aParams.mConfig.mMimeType) &&
      !VPXDecoder::IsVP9(aParams.mConfig.mMimeType)) {
    return nullptr;
  }

  if (aParams.mDiagnostics) {
    const Maybe<nsCString> preferredGMP = PreferredGMP(aParams.mConfig.mMimeType);
    if (preferredGMP.isSome()) {
      aParams.mDiagnostics->SetGMP(preferredGMP.value());
    }
  }

  RefPtr<MediaDataDecoderProxy> wrapper = CreateDecoderWrapper(aParams.mCallback);
  auto params = GMPVideoDecoderParams(aParams).WithCallback(wrapper);
  wrapper->SetProxyTarget(new GMPVideoDecoder(params));
  return wrapper.forget();
}

already_AddRefed<MediaDataDecoder>
GMPDecoderModule::CreateAudioDecoder(const CreateDecoderParams& aParams)
{
  if (!aParams.mConfig.mMimeType.EqualsLiteral("audio/mp4a-latm")) {
    return nullptr;
  }

  if (aParams.mDiagnostics) {
    const Maybe<nsCString> preferredGMP = PreferredGMP(aParams.mConfig.mMimeType);
    if (preferredGMP.isSome()) {
      aParams.mDiagnostics->SetGMP(preferredGMP.value());
    }
  }

  RefPtr<MediaDataDecoderProxy> wrapper = CreateDecoderWrapper(aParams.mCallback);
  auto params = GMPAudioDecoderParams(aParams).WithCallback(wrapper);
  wrapper->SetProxyTarget(new GMPAudioDecoder(params));
  return wrapper.forget();
}

PlatformDecoderModule::ConversionRequired
GMPDecoderModule::DecoderNeedsConversion(const TrackInfo& aConfig) const
{
  // GMPVideoCodecType::kGMPVideoCodecH264 specifies that encoded frames must be in AVCC format.
  if (aConfig.IsVideo() && MP4Decoder::IsH264(aConfig.mMimeType)) {
    return ConversionRequired::kNeedAVCC;
  } else {
    return ConversionRequired::kNeedNone;
  }
}

/* static */
const Maybe<nsCString>
GMPDecoderModule::PreferredGMP(const nsACString& aMimeType)
{
  Maybe<nsCString> rv;
  if (aMimeType.EqualsLiteral("audio/mp4a-latm")) {
    switch (MediaPrefs::GMPAACPreferred()) {
      case 1: rv.emplace(kEMEKeySystemClearkey); break;
      case 2: rv.emplace(kEMEKeySystemPrimetime); break;
      default: break;
    }
  }

  if (MP4Decoder::IsH264(aMimeType)) {
    switch (MediaPrefs::GMPH264Preferred()) {
      case 1: rv.emplace(kEMEKeySystemClearkey); break;
      case 2: rv.emplace(kEMEKeySystemPrimetime); break;
      default: break;
    }
  }

  return rv;
}

/* static */
bool
GMPDecoderModule::SupportsMimeType(const nsACString& aMimeType,
                                   const Maybe<nsCString>& aGMP)
{
  if (aGMP.isNothing()) {
    return false;
  }

  if (MP4Decoder::IsH264(aMimeType)) {
    return HaveGMPFor(NS_LITERAL_CSTRING(GMP_API_VIDEO_DECODER),
                      { NS_LITERAL_CSTRING("h264"), aGMP.value()});
  }

  if (VPXDecoder::IsVP9(aMimeType)) {
    return HaveGMPFor(NS_LITERAL_CSTRING(GMP_API_VIDEO_DECODER),
                      { NS_LITERAL_CSTRING("vp9"), aGMP.value()});
  }

  if (VPXDecoder::IsVP8(aMimeType)) {
    return HaveGMPFor(NS_LITERAL_CSTRING(GMP_API_VIDEO_DECODER),
                      { NS_LITERAL_CSTRING("vp8"), aGMP.value()});
  }

  if (MP4Decoder::IsAAC(aMimeType)) {
    return HaveGMPFor(NS_LITERAL_CSTRING(GMP_API_AUDIO_DECODER),
                      { NS_LITERAL_CSTRING("aac"), aGMP.value()});
  }

  return false;
}

bool
GMPDecoderModule::SupportsMimeType(const nsACString& aMimeType,
                                   DecoderDoctorDiagnostics* aDiagnostics) const
{
  const Maybe<nsCString> preferredGMP = PreferredGMP(aMimeType);
  bool rv = SupportsMimeType(aMimeType, preferredGMP);
  if (rv && aDiagnostics && preferredGMP.isSome()) {
    aDiagnostics->SetGMP(preferredGMP.value());
  }
  return rv;
}

} // namespace mozilla
