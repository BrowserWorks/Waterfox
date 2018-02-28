# Copyright (c) 2012 The WebRTC project authors. All Rights Reserved.
#
# Use of this source code is governed by a BSD-style license
# that can be found in the LICENSE file in the root of the source
# tree. An additional intellectual property rights grant can be found
# in the file PATENTS.  All contributing project authors may
# be found in the AUTHORS file in the root of the source tree.

{
  'includes': [
    '../../build/common.gypi',
  ],
  'variables': {
    'shared_generated_dir': '<(SHARED_INTERMEDIATE_DIR)/audio_processing/asm_offsets',
    'apm_debug_dump%': 1,
  },
  'targets': [
    {
      'target_name': 'audio_processing',
      'type': 'static_library',
      'variables': {
        # Outputs some low-level debug files.
        'agc_debug_dump%': 0,

        # Disables the usual mode where we trust the reported system delay
        # values the AEC receives. The corresponding define is set appropriately
        # in the code, but it can be force-enabled here for testing.
        'aec_untrusted_delay_for_testing%': 0,
      },
      'dependencies': [
        '<(webrtc_root)/base/base.gyp:rtc_base_approved',
        '<(webrtc_root)/common.gyp:webrtc_common',
        '<(webrtc_root)/common_audio/common_audio.gyp:common_audio',
#        '<(webrtc_root)/modules/modules.gyp:isac',
        '<(webrtc_root)/system_wrappers/system_wrappers.gyp:system_wrappers',
      ],
      'sources': [
        'aec/aec_core.cc',
        'aec/aec_core.h',
        'aec/aec_core_optimized_methods.h',
        'aec/aec_resampler.cc',
        'aec/aec_resampler.h',
        'aec/echo_cancellation.cc',
        'aec/echo_cancellation.h',
        'aec3/aec3_constants.h',
        'aec3/block_framer.cc',
        'aec3/block_framer.h',
        'aec3/block_processor.cc',
        'aec3/block_processor.h',
        'aec3/cascaded_biquad_filter.cc',
        'aec3/cascaded_biquad_filter.h',
        'aec3/echo_canceller3.cc',
        'aec3/echo_canceller3.h',
        'aec3/frame_blocker.cc',
        'aec3/frame_blocker.h',
        'aecm/aecm_core.cc',
        'aecm/aecm_core.h',
        'aecm/echo_control_mobile.cc',
        'aecm/echo_control_mobile.h',
        'agc/agc.cc',
        'agc/agc.h',
        'agc/agc_manager_direct.cc',
        'agc/agc_manager_direct.h',
        'agc/gain_map_internal.h',
        'agc/legacy/analog_agc.c',
        'agc/legacy/analog_agc.h',
        'agc/legacy/digital_agc.c',
        'agc/legacy/digital_agc.h',
        'agc/legacy/gain_control.h',
        'agc/loudness_histogram.cc',
        'agc/loudness_histogram.h',
        'agc/legacy/gain_control.h',
        'agc/utility.cc',
        'agc/utility.h',
        'audio_buffer.cc',
        'audio_buffer.h',
        'audio_processing_impl.cc',
        'audio_processing_impl.h',
        'beamformer/array_util.cc',
        'beamformer/array_util.h',
        'beamformer/complex_matrix.h',
        'beamformer/covariance_matrix_generator.cc',
        'beamformer/covariance_matrix_generator.h',
        'beamformer/matrix.h',
        'beamformer/nonlinear_beamformer.cc',
        'beamformer/nonlinear_beamformer.h',
        'common.h',
        'echo_cancellation_impl.cc',
        'echo_cancellation_impl.h',
        'echo_control_mobile_impl.cc',
        'echo_control_mobile_impl.h',
        'echo_detector/circular_buffer.cc',
        'echo_detector/circular_buffer.h',
        'echo_detector/mean_variance_estimator.cc',
        'echo_detector/mean_variance_estimator.h',
        'echo_detector/moving_max.cc',
        'echo_detector/moving_max.h',
        'echo_detector/normalized_covariance_estimator.cc',
        'echo_detector/normalized_covariance_estimator.h',
        'gain_control_for_experimental_agc.cc',
        'gain_control_for_experimental_agc.h',
        'gain_control_impl.cc',
        'gain_control_impl.h',
        'include/audio_processing.cc',
        'include/audio_processing.h',
        'include/config.cc',
        'include/config.h',
        'level_controller/biquad_filter.cc',
        'level_controller/biquad_filter.h',
        'level_controller/down_sampler.cc',
        'level_controller/down_sampler.h',
        'level_controller/gain_applier.cc',
        'level_controller/gain_applier.h',
        'level_controller/gain_selector.cc',
        'level_controller/gain_selector.h',
        'level_controller/lc_constants.h',
        'level_controller/level_controller.cc',
        'level_controller/level_controller.h',
        'level_controller/noise_spectrum_estimator.cc',
        'level_controller/noise_spectrum_estimator.h',
        'level_controller/noise_level_estimator.cc',
        'level_controller/noise_level_estimator.h',
        'level_controller/peak_level_estimator.cc',
        'level_controller/peak_level_estimator.h',
        'level_controller/saturating_gain_estimator.cc',
        'level_controller/saturating_gain_estimator.h',
        'level_controller/signal_classifier.cc',
        'level_controller/signal_classifier.h',
        'level_estimator_impl.cc',
        'level_estimator_impl.h',
        'logging/apm_data_dumper.cc',
        'logging/apm_data_dumper.h',
        'low_cut_filter.cc',
        'low_cut_filter.h',
        'noise_suppression_impl.cc',
        'noise_suppression_impl.h',
        'render_queue_item_verifier.h',
        'residual_echo_detector.cc',
        'residual_echo_detector.h',
        'rms_level.cc',
        'rms_level.h',
        'splitting_filter.cc',
        'splitting_filter.h',
        'three_band_filter_bank.cc',
        'three_band_filter_bank.h',
        'transient/common.h',
        'transient/daubechies_8_wavelet_coeffs.h',
        'transient/dyadic_decimator.h',
        'transient/moving_moments.cc',
        'transient/moving_moments.h',
        'transient/transient_detector.cc',
        'transient/transient_detector.h',
        'transient/transient_suppressor.cc',
        'transient/transient_suppressor.h',
        'transient/wpd_node.cc',
        'transient/wpd_node.h',
        'transient/wpd_tree.cc',
        'transient/wpd_tree.h',
        'typing_detection.cc',
        'typing_detection.h',
        'utility/block_mean_calculator.cc',
        'utility/block_mean_calculator.h',
        'utility/delay_estimator.cc',
        'utility/delay_estimator.h',
        'utility/delay_estimator_internal.h',
        'utility/delay_estimator_wrapper.cc',
        'utility/delay_estimator_wrapper.h',
        'utility/ooura_fft.cc',
        'utility/ooura_fft.h',
        'utility/ooura_fft_tables_common.h',
        'vad/common.h',
        'vad/gmm.cc',
        'vad/gmm.h',
        'vad/noise_gmm_tables.h',
        'vad/pitch_based_vad.cc',
        'vad/pitch_based_vad.h',
        'vad/pitch_internal.cc',
        'vad/pitch_internal.h',
        'vad/pole_zero_filter.cc',
        'vad/pole_zero_filter.h',
        'vad/standalone_vad.cc',
        'vad/standalone_vad.h',
        'vad/vad_audio_proc.cc',
        'vad/vad_audio_proc.h',
        'vad/vad_audio_proc_internal.h',
        'vad/vad_circular_buffer.cc',
        'vad/vad_circular_buffer.h',
        'vad/voice_activity_detector.cc',
        'vad/voice_activity_detector.h',
        'vad/voice_gmm_tables.h',
        'voice_detection_impl.cc',
        'voice_detection_impl.h',
      ],
      'conditions': [
        ['apm_debug_dump==1', {
          'defines': ['WEBRTC_APM_DEBUG_DUMP=1',],
        }, {
          'defines': ['WEBRTC_APM_DEBUG_DUMP=0',],
        }],
        ['aec_untrusted_delay_for_testing==1', {
          'defines': ['WEBRTC_UNTRUSTED_DELAY',],
        }],
        ['agc_debug_dump==1', {
          'defines': ['WEBRTC_AGC_DEBUG_DUMP',],
        }],
        ['enable_protobuf==1', {
          'dependencies': ['audioproc_debug_proto'],
          'defines': ['WEBRTC_AUDIOPROC_DEBUG_DUMP'],
        }],
        ['enable_intelligibility_enhancer==1', {
          'defines': ['WEBRTC_INTELLIGIBILITY_ENHANCER=1',],
          'sources': [
            'intelligibility/intelligibility_enhancer.cc',
            'intelligibility/intelligibility_enhancer.h',
            'intelligibility/intelligibility_utils.cc',
            'intelligibility/intelligibility_utils.h',
          ],
        }, {
          'defines': ['WEBRTC_INTELLIGIBILITY_ENHANCER=0',],
        }],
        ['prefer_fixed_point==1', {
          'defines': ['WEBRTC_NS_FIXED'],
          'sources': [
            'ns/noise_suppression_x.h',
            'ns/noise_suppression_x.c',
            'ns/nsx_core.c',
            'ns/nsx_core.h',
            'ns/nsx_defines.h',
          ],
          'conditions': [
            ['target_arch=="mipsel" and mips_arch_variant!="r6"', {
              'sources': [
                'ns/nsx_core_mips.c',
              ],
            }, {
              'sources': [
                'ns/nsx_core_c.c',
              ],
            }],
          ],
        }, {
          'defines': ['WEBRTC_NS_FLOAT'],
          'sources': [
            'ns/defines.h',
            'ns/noise_suppression.h',
            'ns/noise_suppression.c',
            'ns/ns_core.c',
            'ns/ns_core.h',
            'ns/windows_private.h',
          ],
        }],
        ['target_arch=="ia32" or target_arch=="x64"', {
          'dependencies': ['audio_processing_sse2',],
        }],
        ['build_with_neon==1', {
          'dependencies': ['audio_processing_neon',],
        }],
        ['target_arch=="mipsel" and mips_arch_variant!="r6"', {
          'sources': [
            'aecm/aecm_core_mips.cc',
          ],
          'conditions': [
            ['mips_float_abi=="hard"', {
              'sources': [
                'aec/aec_core_mips.cc',
                'aec/aec_rdft_mips.cc',
                'utility/ooura_fft_mips.cc',
              ],
            }],
          ],
        }, {
          'sources': [
            'aecm/aecm_core_c.cc',
          ],
        }],
      ],
      # TODO(jschuh): Bug 1348: fix size_t to int truncations.
      'msvs_disabled_warnings': [ 4267, ],
    },
  ],
  'conditions': [
    ['enable_protobuf==1', {
      'targets': [
        {
          'target_name': 'audioproc_debug_proto',
          'type': 'static_library',
          'sources': ['debug.proto',],
          'variables': {
            'proto_in_dir': '.',
            # Workaround to protect against gyp's pathname relativization when
            # this file is included by modules.gyp.
            'proto_out_protected': 'webrtc/modules/audio_processing',
            'proto_out_dir': '<(proto_out_protected)',
          },
          'includes': ['../../build/protoc.gypi',],
        },
      ],
    }],
    ['target_arch=="ia32" or target_arch=="x64"', {
      'targets': [
        {
          'target_name': 'audio_processing_sse2',
          'type': 'static_library',
          'sources': [
            'aec/aec_core_sse2.cc',
            'utility/ooura_fft_sse2.cc',
            'utility/ooura_fft_tables_neon_sse2.h',
          ],
          'conditions': [
            ['apm_debug_dump==1', {
              'defines': ['WEBRTC_APM_DEBUG_DUMP=1',],
            }, {
              'defines': ['WEBRTC_APM_DEBUG_DUMP=0',],
            }],
            ['os_posix==1', {
              'cflags': [ '-msse2', ],
              'cflags_mozilla': [ '-msse2', ],
              'xcode_settings': {
                'OTHER_CFLAGS': [ '-msse2', ],
              },
            }],
          ],
        },
      ],
    }],
    ['build_with_neon==1', {
      'targets': [{
        'target_name': 'audio_processing_neon',
        'type': 'static_library',
        'includes': ['../../build/arm_neon.gypi',],
        'dependencies': [
          '<(webrtc_root)/common_audio/common_audio.gyp:common_audio',
        ],
        'sources': [
          'aec/aec_core_neon.cc',
          'aecm/aecm_core_neon.cc',
          'ns/nsx_core_neon.c',
          'utility/ooura_fft_neon.cc',
        ],
        'conditions': [
          ['apm_debug_dump==1', {
            'defines': ['WEBRTC_APM_DEBUG_DUMP=1',],
          }],
          ['apm_debug_dump==0', {
            'defines': ['WEBRTC_APM_DEBUG_DUMP=0',],
          }],
        ],
      }],
    }],
  ],
}
