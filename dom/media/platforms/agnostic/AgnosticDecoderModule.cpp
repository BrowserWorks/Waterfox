/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "AgnosticDecoderModule.h"
#include "OpusDecoder.h"
#include "TheoraDecoder.h"
#include "VPXDecoder.h"
#include "VorbisDecoder.h"
#include "WAVDecoder.h"
#include "mozilla/Logging.h"
#include "mozilla/StaticPrefs_media.h"

#ifdef MOZ_AV1
#  include "AOMDecoder.h"
#  include "DAV1DDecoder.h"
#endif

namespace mozilla {

bool AgnosticDecoderModule::SupportsMimeType(
    const nsACString& aMimeType, DecoderDoctorDiagnostics* aDiagnostics) const {
  bool supports =
      VPXDecoder::IsVPX(aMimeType) || TheoraDecoder::IsTheora(aMimeType);
#if defined(__MINGW32__)
  // If this is a MinGW build we need to force AgnosticDecoderModule to
  // handle the decision to support Vorbis decoding (instead of
  // RDD/RemoteDecoderModule) because of Bug 1597408 (Vorbis decoding on
  // RDD causing sandboxing failure on MinGW-clang).  Typically this
  // would be dealt with using defines in StaticPrefList.yaml, but we
  // must handle it here because of Bug 1598426 (the __MINGW32__ define
  // isn't supported in StaticPrefList.yaml).
  supports |= VorbisDataDecoder::IsVorbis(aMimeType);
#else
  if (!StaticPrefs::media_rdd_vorbis_enabled() ||
      !StaticPrefs::media_rdd_process_enabled() ||
      !BrowserTabsRemoteAutostart()) {
    supports |= VorbisDataDecoder::IsVorbis(aMimeType);
  }
#endif
  if (!StaticPrefs::media_rdd_wav_enabled() ||
      !StaticPrefs::media_rdd_process_enabled() ||
      !BrowserTabsRemoteAutostart()) {
    supports |= WaveDataDecoder::IsWave(aMimeType);
  }
  if (!StaticPrefs::media_rdd_opus_enabled() ||
      !StaticPrefs::media_rdd_process_enabled() ||
      !BrowserTabsRemoteAutostart()) {
    supports |= OpusDataDecoder::IsOpus(aMimeType);
  }
#ifdef MOZ_AV1
  // We remove support for decoding AV1 here if RDD is enabled so that
  // decoding on the content process doesn't accidentally happen in case
  // something goes wrong with launching the RDD process.
  if (StaticPrefs::media_av1_enabled() &&
      !StaticPrefs::media_rdd_process_enabled()) {
    supports |= AOMDecoder::IsAV1(aMimeType);
  }
#endif
  MOZ_LOG(sPDMLog, LogLevel::Debug,
          ("Agnostic decoder %s requested type",
           supports ? "supports" : "rejects"));
  return supports;
}

already_AddRefed<MediaDataDecoder> AgnosticDecoderModule::CreateVideoDecoder(
    const CreateDecoderParams& aParams) {
  RefPtr<MediaDataDecoder> m;

  if (VPXDecoder::IsVPX(aParams.mConfig.mMimeType)) {
    m = new VPXDecoder(aParams);
  }
#ifdef MOZ_AV1
  // see comment above about AV1 and the RDD process
  else if (AOMDecoder::IsAV1(aParams.mConfig.mMimeType) &&
           !StaticPrefs::media_rdd_process_enabled() &&
           StaticPrefs::media_av1_enabled()) {
    if (StaticPrefs::media_av1_use_dav1d()) {
      m = new DAV1DDecoder(aParams);
    } else {
      m = new AOMDecoder(aParams);
    }
  }
#endif
  else if (TheoraDecoder::IsTheora(aParams.mConfig.mMimeType)) {
    m = new TheoraDecoder(aParams);
  }

  return m.forget();
}

already_AddRefed<MediaDataDecoder> AgnosticDecoderModule::CreateAudioDecoder(
    const CreateDecoderParams& aParams) {
  RefPtr<MediaDataDecoder> m;

  const TrackInfo& config = aParams.mConfig;
  if (VorbisDataDecoder::IsVorbis(config.mMimeType)) {
    m = new VorbisDataDecoder(aParams);
  } else if (OpusDataDecoder::IsOpus(config.mMimeType)) {
    CreateDecoderParams params(aParams);
    // Check IsDefaultPlaybackDeviceMono here and set the option in
    // mOptions so OpusDataDecoder doesn't have to do it later (in case
    // it is running on RDD).
    if (IsDefaultPlaybackDeviceMono()) {
      params.mOptions += CreateDecoderParams::Option::DefaultPlaybackDeviceMono;
    }
    m = new OpusDataDecoder(params);
  } else if (WaveDataDecoder::IsWave(config.mMimeType)) {
    m = new WaveDataDecoder(aParams);
  }

  return m.forget();
}

}  // namespace mozilla
