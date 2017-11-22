# Copyright (c) 2012 The WebRTC project authors. All Rights Reserved.
#
# Use of this source code is governed by a BSD-style license
# that can be found in the LICENSE file in the root of the source
# tree. An additional intellectual property rights grant can be found
# in the file PATENTS.  All contributing project authors may
# be found in the AUTHORS file in the root of the source tree.

{
  'targets': [
    {
      # Note this library is missing an implementation for the video capture.
      # Targets must link with either 'video_capture' or
      # 'video_capture_module_internal_impl' depending on whether they want to
      # use the internal capturer.
      'target_name': 'video_capture_module',
      'type': 'static_library',
      'dependencies': [
        'webrtc_utility',
        '<(webrtc_root)/common_video/common_video.gyp:common_video',
        '<(webrtc_root)/system_wrappers/system_wrappers.gyp:system_wrappers',
      ],
      'cflags_mozilla': [
        '$(NSPR_CFLAGS)',
      ],
      'sources': [
        'device_info_impl.cc',
        'device_info_impl.h',
        'video_capture.h',
        'video_capture_config.h',
        'video_capture_defines.h',
        'video_capture_delay.h',
        'video_capture_factory.h',
        'video_capture_factory.cc',
        'video_capture_impl.cc',
        'video_capture_impl.h',
      ],
    },
    {
      # Default video capture module implementation that only supports external
      # capture.
      'target_name': 'video_capture',
      'type': 'static_library',
      'dependencies': [
        'video_capture_module',
      ],
      'cflags_mozilla': [
        '$(NSPR_CFLAGS)',
      ],
      'sources': [
        'external/device_info_external.cc',
        'external/video_capture_external.cc',
      ],
    },
  ], # targets
  'conditions': [
    ['build_with_chromium==0', {
      'targets': [
        {
          'target_name': 'video_capture_module_internal_impl',
          'type': 'static_library',
          'dependencies': [
            'video_capture_module',
            '<(webrtc_root)/common.gyp:webrtc_common',
           ],
          'cflags_mozilla': [
            '$(NSPR_CFLAGS)',
          ],
          'conditions': [
            ['include_v4l2_video_capture==1', {
              'sources': [
                'linux/device_info_linux.cc',
                'linux/device_info_linux.h',
                'linux/video_capture_linux.cc',
                'linux/video_capture_linux.h',
              ],
            }],
            ['OS=="mac"', {
              'sources': [
                'mac/avfoundation/video_capture_avfoundation.h',
                'mac/avfoundation/video_capture_avfoundation.mm',
                'mac/avfoundation/video_capture_avfoundation_info.h',
                'mac/avfoundation/video_capture_avfoundation_info.mm',
                'mac/avfoundation/video_capture_avfoundation_info_objc.h',
                'mac/avfoundation/video_capture_avfoundation_info_objc.mm',
                'mac/avfoundation/video_capture_avfoundation_objc.h',
                'mac/avfoundation/video_capture_avfoundation_objc.mm',
                'mac/avfoundation/video_capture_avfoundation_utility.h',
                'mac/video_capture_mac.mm',
              ],
              'link_settings': {
                'xcode_settings': {
                  'OTHER_LDFLAGS': [
                    '-framework Cocoa',
                    '-framework CoreVideo',
                  ],
                },
              },
            }],  # mac
            ['OS=="win"', {
              'conditions': [
                ['build_with_mozilla==0', {
                  'dependencies': [
                    '<(DEPTH)/third_party/winsdk_samples/winsdk_samples.gyp:directshow_baseclasses',
                  ],
                }],
	      ],
              'sources': [
                'windows/device_info_ds.cc',
                'windows/device_info_ds.h',
                'windows/device_info_mf.cc',
                'windows/device_info_mf.h',
                'windows/help_functions_ds.cc',
                'windows/help_functions_ds.h',
                'windows/sink_filter_ds.cc',
                'windows/sink_filter_ds.h',
                'windows/video_capture_ds.cc',
                'windows/video_capture_ds.h',
                'windows/video_capture_factory_windows.cc',
                'windows/video_capture_mf.cc',
                'windows/video_capture_mf.h',
                'windows/BasePin.cpp',
                'windows/BaseFilter.cpp',
                'windows/BaseInputPin.cpp',
                'windows/MediaType.cpp',
              ],
              'link_settings': {
                'libraries': [
                  '-lStrmiids.lib',
                ],
              },
            }],  # win
            ['OS=="win" and clang==1', {
              'msvs_settings': {
                'VCCLCompilerTool': {
                  'AdditionalOptions': [
                    # Disable warnings failing when compiling with Clang on Windows.
                    # https://bugs.chromium.org/p/webrtc/issues/detail?id=5366
                    '-Wno-comment',
                    '-Wno-ignored-attributes',
                    '-Wno-microsoft-extra-qualification',
                    '-Wno-missing-braces',
                    '-Wno-overloaded-virtual',
                    '-Wno-reorder',
                    '-Wno-writable-strings',
                  ],
                },
              },
            }],
            ['OS=="android"', {
              'sources': [
                'android/device_info_android.cc',
                'android/device_info_android.h',
                'android/video_capture_android.cc',
                'android/video_capture_android.h',
              ],
            }],  # android
            ['OS=="ios"', {
              'sources': [
                'objc/device_info.h',
                'objc/device_info.mm',
                'objc/device_info_objc.h',
                'objc/device_info_objc.mm',
                'objc/rtc_video_capture_objc.h',
                'objc/rtc_video_capture_objc.mm',
                'objc/video_capture.h',
                'objc/video_capture.mm',
              ],
              'xcode_settings': {
                'CLANG_ENABLE_OBJC_ARC': 'YES',
              },
              'cflags_mozilla': [
                '-fobjc-arc',
              ],
              'all_dependent_settings': {
                'xcode_settings': {
                  'OTHER_LDFLAGS': [
                    '-framework AVFoundation',
                    '-framework CoreMedia',
                    '-framework CoreVideo',
                  ],
                },
              },
            }],  # ios
            ['OS=="ios"', {
              'all_dependent_settings': {
                'xcode_settings': {
                  'OTHER_LDFLAGS': [
                    '-framework UIKit',
                  ],
                },
              },
            }],  # ios
          ], # conditions
        },
      ],
    }], # build_with_chromium==0
  ],
}

