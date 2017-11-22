# Copyright (c) 2011 The WebRTC project authors. All Rights Reserved.
#
# Use of this source code is governed by a BSD-style license
# that can be found in the LICENSE file in the root of the source
# tree. An additional intellectual property rights grant can be found
# in the file PATENTS.  All contributing project authors may
# be found in the AUTHORS file in the root of the source tree.

{
  'includes': [
    '../build/common.gypi',
  ],
  'targets': [
    {
      'target_name': 'audio_coder',
      'type': 'static_library',
      'dependencies': [
        '<(webrtc_root)/common.gyp:webrtc_common',
      ],
      'sources': [
        'coder.cc',
        'coder.h',
      ]
    },
    {
      'target_name': 'file_player',
      'type': 'static_library',
      'dependencies': [
        '<(webrtc_root)/common.gyp:webrtc_common',
      ],
      'sources': [
        'file_player.cc',
        'file_player.h',
      ]
    },
    {
      'target_name': 'file_recorder',
      'type': 'static_library',
      'dependencies': [
        '<(webrtc_root)/common.gyp:webrtc_common',
      ],
      'sources': [
        'file_recorder.cc',
        'file_recorder.h',
      ]
    },
    {
      'target_name': 'voice_engine',
      'type': 'static_library',
      'dependencies': [
        '<(webrtc_root)/api/api.gyp:call_api',
        '<(webrtc_root)/base/base.gyp:rtc_base_approved',
        '<(webrtc_root)/common.gyp:webrtc_common',
        '<(webrtc_root)/common_audio/common_audio.gyp:common_audio',
        '<(webrtc_root)/modules/modules.gyp:audio_coding_module',
        '<(webrtc_root)/modules/modules.gyp:audio_conference_mixer',
        '<(webrtc_root)/modules/modules.gyp:audio_device',
        '<(webrtc_root)/modules/modules.gyp:audio_processing',
        '<(webrtc_root)/modules/modules.gyp:bitrate_controller',
        '<(webrtc_root)/modules/modules.gyp:media_file',
        '<(webrtc_root)/modules/modules.gyp:paced_sender',
        '<(webrtc_root)/modules/modules.gyp:rtp_rtcp',
        '<(webrtc_root)/modules/modules.gyp:webrtc_utility',
        '<(webrtc_root)/system_wrappers/system_wrappers.gyp:system_wrappers',
        '<(webrtc_root)/webrtc.gyp:rtc_event_log_api',
        'audio_coder',
        'file_player',
        'file_recorder',
        'level_indicator',
      ],
      'export_dependent_settings': [
        '<(webrtc_root)/modules/modules.gyp:audio_coding_module',
      ],
      'sources': [
        'include/voe_audio_processing.h',
        'include/voe_base.h',
        'include/voe_codec.h',
        'include/voe_errors.h',
        'include/voe_external_media.h',
        'include/voe_file.h',
        'include/voe_hardware.h',
        'include/voe_neteq_stats.h',
        'include/voe_network.h',
        'include/voe_rtp_rtcp.h',
        'include/voe_video_sync.h',
        'include/voe_volume_control.h',
        'channel.cc',
        'channel.h',
        'channel_manager.cc',
        'channel_manager.h',
        'channel_proxy.cc',
        'channel_proxy.h',
        'monitor_module.cc',
        'monitor_module.h',
        'output_mixer.cc',
        'output_mixer.h',
        'shared_data.cc',
        'shared_data.h',
        'statistics.cc',
        'statistics.h',
        'transmit_mixer.cc',
        'transmit_mixer.h',
        'utility.cc',
        'utility.h',
        'voe_audio_processing_impl.cc',
        'voe_audio_processing_impl.h',
        'voe_base_impl.cc',
        'voe_base_impl.h',
        'voe_codec_impl.cc',
        'voe_codec_impl.h',
        'voe_external_media_impl.cc',
        'voe_external_media_impl.h',
        'voe_file_impl.cc',
        'voe_file_impl.h',
        'voe_hardware_impl.cc',
        'voe_hardware_impl.h',
        'voe_neteq_stats_impl.cc',
        'voe_neteq_stats_impl.h',
        'voe_network_impl.cc',
        'voe_network_impl.h',
        'voe_rtp_rtcp_impl.cc',
        'voe_rtp_rtcp_impl.h',
        'voe_video_sync_impl.cc',
        'voe_video_sync_impl.h',
        'voe_volume_control_impl.cc',
        'voe_volume_control_impl.h',
        'voice_engine_defines.h',
        'voice_engine_impl.cc',
        'voice_engine_impl.h',
      ],
    },
    {
      'target_name': 'level_indicator',
      'type': 'static_library',
      'dependencies': [
        '<(webrtc_root)/base/base.gyp:rtc_base_approved',
        '<(webrtc_root)/common.gyp:webrtc_common',
        '<(webrtc_root)/common_audio/common_audio.gyp:common_audio',
      ],
      'sources': [
        'level_indicator.cc',
        'level_indicator.h',
      ]
    },
  ],
}
