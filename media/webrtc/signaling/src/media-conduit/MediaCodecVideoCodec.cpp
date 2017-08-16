/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "CSFLog.h"
#include "nspr.h"

#include "WebrtcMediaCodecVP8VideoCodec.h"
#include "MediaCodecVideoCodec.h"
#include "MediaPrefs.h"

namespace mozilla {

static const char* logTag ="MediaCodecVideoCodec";

WebrtcVideoEncoder* MediaCodecVideoCodec::CreateEncoder(CodecType aCodecType) {
  CSFLogDebug(logTag,  "%s ", __FUNCTION__);
  if (aCodecType == CODEC_VP8) {
    if (MediaPrefs::RemoteMediaCodecVP8EncoderEnabled()) {
      return new WebrtcMediaCodecVP8VideoRemoteEncoder();
    } else {
      return new WebrtcMediaCodecVP8VideoEncoder();
    }
  }
  return nullptr;
}

WebrtcVideoDecoder* MediaCodecVideoCodec::CreateDecoder(CodecType aCodecType) {
  CSFLogDebug(logTag,  "%s ", __FUNCTION__);
  if (aCodecType == CODEC_VP8) {
    return new WebrtcMediaCodecVP8VideoDecoder();
  }
  return nullptr;
}

}
