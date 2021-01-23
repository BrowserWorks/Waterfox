/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "MediaDataCodec.h"
#include "WebrtcMediaDataDecoderCodec.h"
#include "WebrtcMediaDataEncoderCodec.h"
#include "WebrtcGmpVideoCodec.h"
#include "mozilla/StaticPrefs_media.h"

namespace mozilla {

/* static */
WebrtcVideoEncoder* MediaDataCodec::CreateEncoder(
    webrtc::VideoCodecType aCodecType) {
#if defined(MOZ_APPLEMEDIA) || defined(MOZ_WIDGET_ANDROID)
  if (aCodecType == webrtc::VideoCodecType::kVideoCodecH264) {
    return new WebrtcVideoEncoderProxy(new WebrtcMediaDataEncoder());
  }
#endif
  return nullptr;
}

/* static */
WebrtcVideoDecoder* MediaDataCodec::CreateDecoder(
    webrtc::VideoCodecType aCodecType) {
  switch (aCodecType) {
    case webrtc::VideoCodecType::kVideoCodecVP8:
    case webrtc::VideoCodecType::kVideoCodecVP9:
      if (!StaticPrefs::media_navigator_mediadatadecoder_vpx_enabled()) {
        return nullptr;
      }
      break;
    case webrtc::VideoCodecType::kVideoCodecH264:
      if (!StaticPrefs::media_navigator_mediadatadecoder_h264_enabled()) {
        return nullptr;
      }
      break;
    default:
      return nullptr;
  }
  return new WebrtcMediaDataDecoder();
}

}  // namespace mozilla
