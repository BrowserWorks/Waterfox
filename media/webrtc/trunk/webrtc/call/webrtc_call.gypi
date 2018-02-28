# Copyright (c) 2013 The WebRTC project authors. All Rights Reserved.
#
# Use of this source code is governed by a BSD-style license
# that can be found in the LICENSE file in the root of the source
# tree. An additional intellectual property rights grant can be found
# in the file PATENTS.  All contributing project authors may
# be found in the AUTHORS file in the root of the source tree.
{
  'variables': {
    'webrtc_call_dependencies': [
      '<(webrtc_root)/common.gyp:webrtc_common',
      '<(webrtc_root)/modules/modules.gyp:congestion_controller',
      '<(webrtc_root)/modules/modules.gyp:rtp_rtcp',
      '<(webrtc_root)/system_wrappers/system_wrappers.gyp:system_wrappers',
      '<(webrtc_root)/webrtc.gyp:rtc_event_log_impl',
    ],
    'webrtc_call_sources': [
      'call/audio_receive_stream.h',
      'call/audio_send_stream_call.cc',
      'call/bitrate_allocator.cc',
      'call/call.h',
      'call/call.cc',
      'call/flexfec_receive_stream.h',
      'call/flexfec_receive_stream_impl.cc',
    ],
  },
}
