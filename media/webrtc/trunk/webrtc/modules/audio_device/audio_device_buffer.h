/*
 *  Copyright (c) 2012 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_MODULES_AUDIO_DEVICE_AUDIO_DEVICE_BUFFER_H_
#define WEBRTC_MODULES_AUDIO_DEVICE_AUDIO_DEVICE_BUFFER_H_

#include "webrtc/base/buffer.h"
#include "webrtc/base/task_queue.h"
#include "webrtc/base/thread_annotations.h"
#include "webrtc/base/thread_checker.h"
#include "webrtc/modules/audio_device/include/audio_device.h"
#include "webrtc/system_wrappers/include/file_wrapper.h"
#include "webrtc/typedefs.h"

namespace webrtc {
// Delta times between two successive playout callbacks are limited to this
// value before added to an internal array.
const size_t kMaxDeltaTimeInMs = 500;
// TODO(henrika): remove when no longer used by external client.
const size_t kMaxBufferSizeBytes = 3840;  // 10ms in stereo @ 96kHz

class AudioDeviceObserver;

class AudioDeviceBuffer {
 public:
  enum LogState {
    LOG_START = 0,
    LOG_STOP,
    LOG_ACTIVE,
  };

  AudioDeviceBuffer();
  virtual ~AudioDeviceBuffer();

  void SetId(uint32_t id) {};
  int32_t RegisterAudioCallback(AudioTransport* audio_callback);

  void StartPlayout();
  void StartRecording();
  void StopPlayout();
  void StopRecording();

  int32_t SetRecordingSampleRate(uint32_t fsHz);
  int32_t SetPlayoutSampleRate(uint32_t fsHz);
  int32_t RecordingSampleRate() const;
  int32_t PlayoutSampleRate() const;

  int32_t SetRecordingChannels(size_t channels);
  int32_t SetPlayoutChannels(size_t channels);
  size_t RecordingChannels() const;
  size_t PlayoutChannels() const;
  int32_t SetRecordingChannel(const AudioDeviceModule::ChannelType channel);
  int32_t RecordingChannel(AudioDeviceModule::ChannelType& channel) const;

  virtual int32_t SetRecordedBuffer(const void* audio_buffer,
                                    size_t samples_per_channel);
  int32_t SetCurrentMicLevel(uint32_t level);
  virtual void SetVQEData(int play_delay_ms, int rec_delay_ms, int clock_drift);
  virtual int32_t DeliverRecordedData();
  uint32_t NewMicLevel() const;

  virtual int32_t RequestPlayoutData(size_t samples_per_channel);
  virtual int32_t GetPlayoutData(void* audio_buffer);

  // TODO(henrika): these methods should not be used and does not contain any
  // valid implementation. Investigate the possibility to either remove them
  // or add a proper implementation if needed.
  int32_t StartInputFileRecording(const char fileName[kAdmMaxFileNameSize]);
  int32_t StopInputFileRecording();
  int32_t StartOutputFileRecording(const char fileName[kAdmMaxFileNameSize]);
  int32_t StopOutputFileRecording();

  int32_t SetTypingStatus(bool typing_status);

 private:
  // Starts/stops periodic logging of audio stats.
  void StartPeriodicLogging();
  void StopPeriodicLogging();

  // Called periodically on the internal thread created by the TaskQueue.
  // Updates some stats but dooes it on the task queue to ensure that access of
  // members is serialized hence avoiding usage of locks.
  // state = LOG_START => members are initialized and the timer starts.
  // state = LOG_STOP => no logs are printed and the timer stops.
  // state = LOG_ACTIVE => logs are printed and the timer is kept alive.
  void LogStats(LogState state);

  // Updates counters in each play/record callback but does it on the task
  // queue to ensure that they can be read by LogStats() without any locks since
  // each task is serialized by the task queue.
  void UpdateRecStats(int16_t max_abs, size_t samples_per_channel);
  void UpdatePlayStats(int16_t max_abs, size_t samples_per_channel);

  // Clears all members tracking stats for recording and playout.
  // These methods both run on the task queue.
  void ResetRecStats();
  void ResetPlayStats();

  // This object lives on the main (creating) thread and most methods are
  // called on that same thread. When audio has started some methods will be
  // called on either a native audio thread for playout or a native thread for
  // recording. Some members are not annotated since they are "protected by
  // design" and adding e.g. a race checker can cause failuries for very few
  // edge cases and it is IMHO not worth the risk to use them in this class.
  // TODO(henrika): see if it is possible to refactor and annotate all members.

  // Main thread on which this object is created.
  rtc::ThreadChecker main_thread_checker_;

  // Native (platform specific) audio thread driving the playout side.
  rtc::ThreadChecker playout_thread_checker_;

  // Native (platform specific) audio thread driving the recording side.
  rtc::ThreadChecker recording_thread_checker_;

  // Task queue used to invoke LogStats() periodically. Tasks are executed on a
  // worker thread but it does not necessarily have to be the same thread for
  // each task.
  rtc::TaskQueue task_queue_;

  // Raw pointer to AudioTransport instance. Supplied to RegisterAudioCallback()
  // and it must outlive this object. It is not possible to change this member
  // while any media is active. It is possible to start media without calling
  // RegisterAudioCallback() but that will lead to ignored audio callbacks in
  // both directions where native audio will be acive but no audio samples will
  // be transported.
  AudioTransport* audio_transport_cb_;

  // The members below that are not annotated are protected by design. They are
  // all set on the main thread (verified by |main_thread_checker_|) and then
  // read on either the playout or recording audio thread. But, media will never
  // be active when the member is set; hence no conflict exists. It is too
  // complex to ensure and verify that this is actually the case.

  // Sample rate in Hertz.
  uint32_t rec_sample_rate_;
  uint32_t play_sample_rate_;

  // Number of audio channels.
  size_t rec_channels_;
  size_t play_channels_;

  // Keeps track of if playout/recording are active or not. A combination
  // of these states are used to determine when to start and stop the timer.
  // Only used on the creating thread and not used to control any media flow.
  bool playing_ ACCESS_ON(main_thread_checker_);
  bool recording_ ACCESS_ON(main_thread_checker_);

  // Buffer used for audio samples to be played out. Size can be changed
  // dynamically. The 16-bit samples are interleaved, hence the size is
  // proportional to the number of channels.
  rtc::BufferT<int16_t> play_buffer_ ACCESS_ON(playout_thread_checker_);

  // Byte buffer used for recorded audio samples. Size can be changed
  // dynamically.
  rtc::BufferT<int16_t> rec_buffer_ ACCESS_ON(recording_thread_checker_);

  // AGC parameters.
#if !defined(WEBRTC_WIN)
  uint32_t current_mic_level_ ACCESS_ON(recording_thread_checker_);
#else
  // Windows uses a dedicated thread for volume APIs.
  uint32_t current_mic_level_;
#endif
  uint32_t new_mic_level_ ACCESS_ON(recording_thread_checker_);

  // Contains true of a key-press has been detected.
  bool typing_status_ ACCESS_ON(recording_thread_checker_);

  // Delay values used by the AEC.
  int play_delay_ms_ ACCESS_ON(recording_thread_checker_);
  int rec_delay_ms_ ACCESS_ON(recording_thread_checker_);

  // Contains a clock-drift measurement.
  int clock_drift_ ACCESS_ON(recording_thread_checker_);

  // Counts number of times LogStats() has been called.
  size_t num_stat_reports_ ACCESS_ON(task_queue_);

  // Total number of recording callbacks where the source provides 10ms audio
  // data each time.
  uint64_t rec_callbacks_ ACCESS_ON(task_queue_);

  // Total number of recording callbacks stored at the last timer task.
  uint64_t last_rec_callbacks_ ACCESS_ON(task_queue_);

  // Total number of playback callbacks where the sink asks for 10ms audio
  // data each time.
  uint64_t play_callbacks_ ACCESS_ON(task_queue_);

  // Total number of playout callbacks stored at the last timer task.
  uint64_t last_play_callbacks_ ACCESS_ON(task_queue_);

  // Total number of recorded audio samples.
  uint64_t rec_samples_ ACCESS_ON(task_queue_);

  // Total number of recorded samples stored at the previous timer task.
  uint64_t last_rec_samples_ ACCESS_ON(task_queue_);

  // Total number of played audio samples.
  uint64_t play_samples_ ACCESS_ON(task_queue_);

  // Total number of played samples stored at the previous timer task.
  uint64_t last_play_samples_ ACCESS_ON(task_queue_);

  // Contains max level (max(abs(x))) of recorded audio packets over the last
  // 10 seconds where a new measurement is done twice per second. The level
  // is reset to zero at each call to LogStats().
  int16_t max_rec_level_ ACCESS_ON(task_queue_);

  // Contains max level of recorded audio packets over the last 10 seconds
  // where a new measurement is done twice per second.
  int16_t max_play_level_ ACCESS_ON(task_queue_);

  // Time stamp of last timer task (drives logging).
  int64_t last_timer_task_time_ ACCESS_ON(task_queue_);

  // Counts number of audio callbacks modulo 50 to create a signal when
  // a new storage of audio stats shall be done.
  int16_t rec_stat_count_ ACCESS_ON(recording_thread_checker_);
  int16_t play_stat_count_ ACCESS_ON(playout_thread_checker_);

  // Time stamps of when playout and recording starts.
  int64_t play_start_time_ ACCESS_ON(main_thread_checker_);
  int64_t rec_start_time_ ACCESS_ON(main_thread_checker_);

  // Set to true at construction and modified to false as soon as one audio-
  // level estimate larger than zero is detected.
  bool only_silence_recorded_;

  // Set to true when logging of audio stats is enabled for the first time in
  // StartPeriodicLogging() and set to false by StopPeriodicLogging().
  // Setting this member to false prevents (possiby invalid) log messages from
  // being printed in the LogStats() task.
  bool log_stats_ ACCESS_ON(task_queue_);
};

}  // namespace webrtc

#endif  // WEBRTC_MODULES_AUDIO_DEVICE_AUDIO_DEVICE_BUFFER_H_
