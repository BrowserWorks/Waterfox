/*
 *  Copyright (c) 2012 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_MODULES_AUDIO_MIXER_AUDIO_MIXER_IMPL_H_
#define WEBRTC_MODULES_AUDIO_MIXER_AUDIO_MIXER_IMPL_H_

#include <memory>
#include <vector>

#include "webrtc/api/audio/audio_mixer.h"
#include "webrtc/base/scoped_ref_ptr.h"
#include "webrtc/base/thread_annotations.h"
#include "webrtc/base/race_checker.h"
#include "webrtc/modules/audio_mixer/output_rate_calculator.h"
#include "webrtc/modules/audio_processing/include/audio_processing.h"
#include "webrtc/modules/include/module_common_types.h"
#include "webrtc/system_wrappers/include/critical_section_wrapper.h"
#include "webrtc/typedefs.h"

namespace webrtc {

typedef std::vector<AudioFrame*> AudioFrameList;

class AudioMixerImpl : public AudioMixer {
 public:
  struct SourceStatus {
    SourceStatus(Source* audio_source, bool is_mixed, float gain)
        : audio_source(audio_source), is_mixed(is_mixed), gain(gain) {}
    Source* audio_source = nullptr;
    bool is_mixed = false;
    float gain = 0.0f;

    // A frame that will be passed to audio_source->GetAudioFrameWithInfo.
    AudioFrame audio_frame;
  };

  using SourceStatusList = std::vector<std::unique_ptr<SourceStatus>>;

  // AudioProcessing only accepts 10 ms frames.
  static const int kFrameDurationInMs = 10;
  static const int kMaximumAmountOfMixedAudioSources = 3;

  static rtc::scoped_refptr<AudioMixerImpl> Create();
  static rtc::scoped_refptr<AudioMixerImpl> CreateWithOutputRateCalculator(
      std::unique_ptr<OutputRateCalculator> output_rate_calculator);

  ~AudioMixerImpl() override;

  // AudioMixer functions
  bool AddSource(Source* audio_source) override;
  void RemoveSource(Source* audio_source) override;

  void Mix(size_t number_of_channels,
           AudioFrame* audio_frame_for_mixing) override LOCKS_EXCLUDED(crit_);

  // Returns true if the source was mixed last round. Returns
  // false and logs an error if the source was never added to the
  // mixer.
  bool GetAudioSourceMixabilityStatusForTest(Source* audio_source) const;

 protected:
  AudioMixerImpl(std::unique_ptr<AudioProcessing> limiter,
                 std::unique_ptr<OutputRateCalculator> output_rate_calculator);

 private:
  // Set mixing frequency through OutputFrequencyCalculator.
  void CalculateOutputFrequency();
  // Get mixing frequency.
  int OutputFrequency() const;

  // Compute what audio sources to mix from audio_source_list_. Ramp
  // in and out. Update mixed status. Mixes up to
  // kMaximumAmountOfMixedAudioSources audio sources.
  AudioFrameList GetAudioFromSources() EXCLUSIVE_LOCKS_REQUIRED(crit_);

  // Add/remove the MixerAudioSource to the specified
  // MixerAudioSource list.
  bool AddAudioSourceToList(Source* audio_source,
                            SourceStatusList* audio_source_list) const;
  bool RemoveAudioSourceFromList(Source* remove_audio_source,
                                 SourceStatusList* audio_source_list) const;

  bool LimitMixedAudio(AudioFrame* mixed_audio) const;

  // The critical section lock guards audio source insertion and
  // removal, which can be done from any thread. The race checker
  // checks that mixing is done sequentially.
  rtc::CriticalSection crit_;
  rtc::RaceChecker race_checker_;

  std::unique_ptr<OutputRateCalculator> output_rate_calculator_;
  // The current sample frequency and sample size when mixing.
  int output_frequency_ GUARDED_BY(race_checker_);
  size_t sample_size_ GUARDED_BY(race_checker_);

  // List of all audio sources. Note all lists are disjunct
  SourceStatusList audio_source_list_ GUARDED_BY(crit_);  // May be mixed.

  // Determines if we will use a limiter for clipping protection during
  // mixing.
  bool use_limiter_ GUARDED_BY(race_checker_);

  uint32_t time_stamp_ GUARDED_BY(race_checker_);

  // Used for inhibiting saturation in mixing.
  std::unique_ptr<AudioProcessing> limiter_ GUARDED_BY(race_checker_);

  RTC_DISALLOW_COPY_AND_ASSIGN(AudioMixerImpl);
};
}  // namespace webrtc

#endif  // WEBRTC_MODULES_AUDIO_MIXER_AUDIO_MIXER_IMPL_H_
