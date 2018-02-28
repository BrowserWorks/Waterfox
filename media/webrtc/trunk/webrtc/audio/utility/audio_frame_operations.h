/*
 *  Copyright (c) 2012 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_AUDIO_UTILITY_AUDIO_FRAME_OPERATIONS_H_
#define WEBRTC_AUDIO_UTILITY_AUDIO_FRAME_OPERATIONS_H_

#include <stddef.h>

#include "webrtc/typedefs.h"

namespace webrtc {

class AudioFrame;

// TODO(andrew): consolidate this with utility.h and audio_frame_manipulator.h.
// Change reference parameters to pointers. Consider using a namespace rather
// than a class.
class AudioFrameOperations {
 public:
  // Add samples in |frame_to_add| with samples in |result_frame|
  // putting the results in |results_frame|.  The fields
  // |vad_activity_| and |speech_type_| of the result frame are
  // updated. If |result_frame| is empty (|samples_per_channel_|==0),
  // the samples in |frame_to_add| are added to it.  The number of
  // channels and number of samples per channel must match except when
  // |result_frame| is empty.
  static void Add(const AudioFrame& frame_to_add, AudioFrame* result_frame);

  // Upmixes mono |src_audio| to stereo |dst_audio|. This is an out-of-place
  // operation, meaning src_audio and dst_audio must point to different
  // buffers. It is the caller's responsibility to ensure that |dst_audio| is
  // sufficiently large.
  static void MonoToStereo(const int16_t* src_audio,
                           size_t samples_per_channel,
                           int16_t* dst_audio);
  // |frame.num_channels_| will be updated. This version checks for sufficient
  // buffer size and that |num_channels_| is mono.
  static int MonoToStereo(AudioFrame* frame);

  // Downmixes stereo |src_audio| to mono |dst_audio|. This is an in-place
  // operation, meaning |src_audio| and |dst_audio| may point to the same
  // buffer.
  static void StereoToMono(const int16_t* src_audio,
                           size_t samples_per_channel,
                           int16_t* dst_audio);
  // |frame.num_channels_| will be updated. This version checks that
  // |num_channels_| is stereo.
  static int StereoToMono(AudioFrame* frame);

  // Swap the left and right channels of |frame|. Fails silently if |frame| is
  // not stereo.
  static void SwapStereoChannels(AudioFrame* frame);

  // Conditionally zero out contents of |frame| for implementing audio mute:
  //  |previous_frame_muted| &&  |current_frame_muted| - Zero out whole frame.
  //  |previous_frame_muted| && !|current_frame_muted| - Fade-in at frame start.
  // !|previous_frame_muted| &&  |current_frame_muted| - Fade-out at frame end.
  // !|previous_frame_muted| && !|current_frame_muted| - Leave frame untouched.
  static void Mute(AudioFrame* frame,
                   bool previous_frame_muted,
                   bool current_frame_muted);

  // Zero out contents of frame.
  static void Mute(AudioFrame* frame);

  // Halve samples in |frame|.
  static void ApplyHalfGain(AudioFrame* frame);

  static int Scale(float left, float right, AudioFrame& frame);

  static int ScaleWithSat(float scale, AudioFrame& frame);
};

}  // namespace webrtc

#endif  // WEBRTC_AUDIO_UTILITY_AUDIO_FRAME_OPERATIONS_H_
