/*
 *  Copyright (c) 2012 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "webrtc/audio/utility/audio_frame_operations.h"
#include "webrtc/base/checks.h"
#include "webrtc/modules/include/module_common_types.h"
#include "webrtc/test/gtest.h"

namespace webrtc {
namespace {

class AudioFrameOperationsTest : public ::testing::Test {
 protected:
  AudioFrameOperationsTest() {
    // Set typical values.
    frame_.samples_per_channel_ = 320;
    frame_.num_channels_ = 2;
  }

  AudioFrame frame_;
};

void SetFrameData(AudioFrame* frame, int16_t left, int16_t right) {
  for (size_t i = 0; i < frame->samples_per_channel_ * 2; i += 2) {
    frame->data_[i] = left;
    frame->data_[i + 1] = right;
  }
}

void SetFrameData(AudioFrame* frame, int16_t data) {
  for (size_t i = 0; i < frame->samples_per_channel_; i++) {
    frame->data_[i] = data;
  }
}

void VerifyFramesAreEqual(const AudioFrame& frame1, const AudioFrame& frame2) {
  EXPECT_EQ(frame1.num_channels_, frame2.num_channels_);
  EXPECT_EQ(frame1.samples_per_channel_,
            frame2.samples_per_channel_);
  for (size_t i = 0; i < frame1.samples_per_channel_ * frame1.num_channels_;
      i++) {
    EXPECT_EQ(frame1.data_[i], frame2.data_[i]);
  }
}

void InitFrame(AudioFrame* frame, size_t channels, size_t samples_per_channel,
               int16_t left_data, int16_t right_data) {
  RTC_DCHECK(frame);
  RTC_DCHECK_GE(2, channels);
  RTC_DCHECK_GE(AudioFrame::kMaxDataSizeSamples,
                samples_per_channel * channels);
  frame->samples_per_channel_ = samples_per_channel;
  frame->num_channels_ = channels;
  if (channels == 2) {
    SetFrameData(frame, left_data, right_data);
  } else if (channels == 1) {
    SetFrameData(frame, left_data);
  }
}

int16_t GetChannelData(const AudioFrame& frame, size_t channel, size_t index) {
  RTC_DCHECK_LT(channel, frame.num_channels_);
  RTC_DCHECK_LT(index, frame.samples_per_channel_);
  return frame.data_[index * frame.num_channels_ + channel];
}

void VerifyFrameDataBounds(const AudioFrame& frame, size_t channel, int16_t max,
                           int16_t min) {
  for (size_t i = 0; i < frame.samples_per_channel_; ++i) {
    int16_t s = GetChannelData(frame, channel, i);
    EXPECT_LE(min, s);
    EXPECT_GE(max, s);
  }
}

TEST_F(AudioFrameOperationsTest, MonoToStereoFailsWithBadParameters) {
  EXPECT_EQ(-1, AudioFrameOperations::MonoToStereo(&frame_));

  frame_.samples_per_channel_ = AudioFrame::kMaxDataSizeSamples;
  frame_.num_channels_ = 1;
  EXPECT_EQ(-1, AudioFrameOperations::MonoToStereo(&frame_));
}

TEST_F(AudioFrameOperationsTest, MonoToStereoSucceeds) {
  frame_.num_channels_ = 1;
  SetFrameData(&frame_, 1);
  AudioFrame temp_frame;
  temp_frame.CopyFrom(frame_);
  EXPECT_EQ(0, AudioFrameOperations::MonoToStereo(&frame_));

  AudioFrame stereo_frame;
  stereo_frame.samples_per_channel_ = 320;
  stereo_frame.num_channels_ = 2;
  SetFrameData(&stereo_frame, 1, 1);
  VerifyFramesAreEqual(stereo_frame, frame_);

  SetFrameData(&frame_, 0);
  AudioFrameOperations::MonoToStereo(temp_frame.data_,
                                     frame_.samples_per_channel_,
                                     frame_.data_);
  frame_.num_channels_ = 2;  // Need to set manually.
  VerifyFramesAreEqual(stereo_frame, frame_);
}

TEST_F(AudioFrameOperationsTest, StereoToMonoFailsWithBadParameters) {
  frame_.num_channels_ = 1;
  EXPECT_EQ(-1, AudioFrameOperations::StereoToMono(&frame_));
}

TEST_F(AudioFrameOperationsTest, StereoToMonoSucceeds) {
  SetFrameData(&frame_, 4, 2);
  AudioFrame temp_frame;
  temp_frame.CopyFrom(frame_);
  EXPECT_EQ(0, AudioFrameOperations::StereoToMono(&frame_));

  AudioFrame mono_frame;
  mono_frame.samples_per_channel_ = 320;
  mono_frame.num_channels_ = 1;
  SetFrameData(&mono_frame, 3);
  VerifyFramesAreEqual(mono_frame, frame_);

  SetFrameData(&frame_, 0);
  AudioFrameOperations::StereoToMono(temp_frame.data_,
                                     frame_.samples_per_channel_,
                                     frame_.data_);
  frame_.num_channels_ = 1;  // Need to set manually.
  VerifyFramesAreEqual(mono_frame, frame_);
}

TEST_F(AudioFrameOperationsTest, StereoToMonoDoesNotWrapAround) {
  SetFrameData(&frame_, -32768, -32768);
  EXPECT_EQ(0, AudioFrameOperations::StereoToMono(&frame_));

  AudioFrame mono_frame;
  mono_frame.samples_per_channel_ = 320;
  mono_frame.num_channels_ = 1;
  SetFrameData(&mono_frame, -32768);
  VerifyFramesAreEqual(mono_frame, frame_);
}

TEST_F(AudioFrameOperationsTest, SwapStereoChannelsSucceedsOnStereo) {
  SetFrameData(&frame_, 0, 1);

  AudioFrame swapped_frame;
  swapped_frame.samples_per_channel_ = 320;
  swapped_frame.num_channels_ = 2;
  SetFrameData(&swapped_frame, 1, 0);

  AudioFrameOperations::SwapStereoChannels(&frame_);
  VerifyFramesAreEqual(swapped_frame, frame_);
}

TEST_F(AudioFrameOperationsTest, SwapStereoChannelsFailsOnMono) {
  frame_.num_channels_ = 1;
  // Set data to "stereo", despite it being a mono frame.
  SetFrameData(&frame_, 0, 1);

  AudioFrame orig_frame;
  orig_frame.CopyFrom(frame_);
  AudioFrameOperations::SwapStereoChannels(&frame_);
  // Verify that no swap occurred.
  VerifyFramesAreEqual(orig_frame, frame_);
}

TEST_F(AudioFrameOperationsTest, MuteDisabled) {
  SetFrameData(&frame_, 1000, -1000);
  AudioFrameOperations::Mute(&frame_, false, false);

  AudioFrame muted_frame;
  muted_frame.samples_per_channel_ = 320;
  muted_frame.num_channels_ = 2;
  SetFrameData(&muted_frame, 1000, -1000);
  VerifyFramesAreEqual(muted_frame, frame_);
}

TEST_F(AudioFrameOperationsTest, MuteEnabled) {
  SetFrameData(&frame_, 1000, -1000);
  AudioFrameOperations::Mute(&frame_, true, true);

  AudioFrame muted_frame;
  muted_frame.samples_per_channel_ = 320;
  muted_frame.num_channels_ = 2;
  SetFrameData(&muted_frame, 0, 0);
  VerifyFramesAreEqual(muted_frame, frame_);
}

// Verify that *beginning* to mute works for short and long (>128) frames, mono
// and stereo. Beginning mute should yield a ramp down to zero.
TEST_F(AudioFrameOperationsTest, MuteBeginMonoLong) {
  InitFrame(&frame_, 1, 228, 1000, -1000);
  AudioFrameOperations::Mute(&frame_, false, true);
  VerifyFrameDataBounds(frame_, 0, 1000, 0);
  EXPECT_EQ(1000, GetChannelData(frame_, 0, 99));
  EXPECT_EQ(992, GetChannelData(frame_, 0, 100));
  EXPECT_EQ(7, GetChannelData(frame_, 0, 226));
  EXPECT_EQ(0, GetChannelData(frame_, 0, 227));
}

TEST_F(AudioFrameOperationsTest, MuteBeginMonoShort) {
  InitFrame(&frame_, 1, 93, 1000, -1000);
  AudioFrameOperations::Mute(&frame_, false, true);
  VerifyFrameDataBounds(frame_, 0, 1000, 0);
  EXPECT_EQ(989, GetChannelData(frame_, 0, 0));
  EXPECT_EQ(978, GetChannelData(frame_, 0, 1));
  EXPECT_EQ(10, GetChannelData(frame_, 0, 91));
  EXPECT_EQ(0, GetChannelData(frame_, 0, 92));
}

TEST_F(AudioFrameOperationsTest, MuteBeginStereoLong) {
  InitFrame(&frame_, 2, 228, 1000, -1000);
  AudioFrameOperations::Mute(&frame_, false, true);
  VerifyFrameDataBounds(frame_, 0, 1000, 0);
  VerifyFrameDataBounds(frame_, 1, 0, -1000);
  EXPECT_EQ(1000, GetChannelData(frame_, 0, 99));
  EXPECT_EQ(-1000, GetChannelData(frame_, 1, 99));
  EXPECT_EQ(992, GetChannelData(frame_, 0, 100));
  EXPECT_EQ(-992, GetChannelData(frame_, 1, 100));
  EXPECT_EQ(7, GetChannelData(frame_, 0, 226));
  EXPECT_EQ(-7, GetChannelData(frame_, 1, 226));
  EXPECT_EQ(0, GetChannelData(frame_, 0, 227));
  EXPECT_EQ(0, GetChannelData(frame_, 1, 227));
}

TEST_F(AudioFrameOperationsTest, MuteBeginStereoShort) {
  InitFrame(&frame_, 2, 93, 1000, -1000);
  AudioFrameOperations::Mute(&frame_, false, true);
  VerifyFrameDataBounds(frame_, 0, 1000, 0);
  VerifyFrameDataBounds(frame_, 1, 0, -1000);
  EXPECT_EQ(989, GetChannelData(frame_, 0, 0));
  EXPECT_EQ(-989, GetChannelData(frame_, 1, 0));
  EXPECT_EQ(978, GetChannelData(frame_, 0, 1));
  EXPECT_EQ(-978, GetChannelData(frame_, 1, 1));
  EXPECT_EQ(10, GetChannelData(frame_, 0, 91));
  EXPECT_EQ(-10, GetChannelData(frame_, 1, 91));
  EXPECT_EQ(0, GetChannelData(frame_, 0, 92));
  EXPECT_EQ(0, GetChannelData(frame_, 1, 92));
}

// Verify that *ending* to mute works for short and long (>128) frames, mono
// and stereo. Ending mute should yield a ramp up from zero.
TEST_F(AudioFrameOperationsTest, MuteEndMonoLong) {
  InitFrame(&frame_, 1, 228, 1000, -1000);
  AudioFrameOperations::Mute(&frame_, true, false);
  VerifyFrameDataBounds(frame_, 0, 1000, 0);
  EXPECT_EQ(7, GetChannelData(frame_, 0, 0));
  EXPECT_EQ(15, GetChannelData(frame_, 0, 1));
  EXPECT_EQ(1000, GetChannelData(frame_, 0, 127));
  EXPECT_EQ(1000, GetChannelData(frame_, 0, 128));
}

TEST_F(AudioFrameOperationsTest, MuteEndMonoShort) {
  InitFrame(&frame_, 1, 93, 1000, -1000);
  AudioFrameOperations::Mute(&frame_, true, false);
  VerifyFrameDataBounds(frame_, 0, 1000, 0);
  EXPECT_EQ(10, GetChannelData(frame_, 0, 0));
  EXPECT_EQ(21, GetChannelData(frame_, 0, 1));
  EXPECT_EQ(989, GetChannelData(frame_, 0, 91));
  EXPECT_EQ(999, GetChannelData(frame_, 0, 92));
}

TEST_F(AudioFrameOperationsTest, MuteEndStereoLong) {
  InitFrame(&frame_, 2, 228, 1000, -1000);
  AudioFrameOperations::Mute(&frame_, true, false);
  VerifyFrameDataBounds(frame_, 0, 1000, 0);
  VerifyFrameDataBounds(frame_, 1, 0, -1000);
  EXPECT_EQ(7, GetChannelData(frame_, 0, 0));
  EXPECT_EQ(-7, GetChannelData(frame_, 1, 0));
  EXPECT_EQ(15, GetChannelData(frame_, 0, 1));
  EXPECT_EQ(-15, GetChannelData(frame_, 1, 1));
  EXPECT_EQ(1000, GetChannelData(frame_, 0, 127));
  EXPECT_EQ(-1000, GetChannelData(frame_, 1, 127));
  EXPECT_EQ(1000, GetChannelData(frame_, 0, 128));
  EXPECT_EQ(-1000, GetChannelData(frame_, 1, 128));
}

TEST_F(AudioFrameOperationsTest, MuteEndStereoShort) {
  InitFrame(&frame_, 2, 93, 1000, -1000);
  AudioFrameOperations::Mute(&frame_, true, false);
  VerifyFrameDataBounds(frame_, 0, 1000, 0);
  VerifyFrameDataBounds(frame_, 1, 0, -1000);
  EXPECT_EQ(10, GetChannelData(frame_, 0, 0));
  EXPECT_EQ(-10, GetChannelData(frame_, 1, 0));
  EXPECT_EQ(21, GetChannelData(frame_, 0, 1));
  EXPECT_EQ(-21, GetChannelData(frame_, 1, 1));
  EXPECT_EQ(989, GetChannelData(frame_, 0, 91));
  EXPECT_EQ(-989, GetChannelData(frame_, 1, 91));
  EXPECT_EQ(999, GetChannelData(frame_, 0, 92));
  EXPECT_EQ(-999, GetChannelData(frame_, 1, 92));
}

// TODO(andrew): should not allow negative scales.
TEST_F(AudioFrameOperationsTest, DISABLED_ScaleFailsWithBadParameters) {
  frame_.num_channels_ = 1;
  EXPECT_EQ(-1, AudioFrameOperations::Scale(1.0, 1.0, frame_));

  frame_.num_channels_ = 3;
  EXPECT_EQ(-1, AudioFrameOperations::Scale(1.0, 1.0, frame_));

  frame_.num_channels_ = 2;
  EXPECT_EQ(-1, AudioFrameOperations::Scale(-1.0, 1.0, frame_));
  EXPECT_EQ(-1, AudioFrameOperations::Scale(1.0, -1.0, frame_));
}

// TODO(andrew): fix the wraparound bug. We should always saturate.
TEST_F(AudioFrameOperationsTest, DISABLED_ScaleDoesNotWrapAround) {
  SetFrameData(&frame_, 4000, -4000);
  EXPECT_EQ(0, AudioFrameOperations::Scale(10.0, 10.0, frame_));

  AudioFrame clipped_frame;
  clipped_frame.samples_per_channel_ = 320;
  clipped_frame.num_channels_ = 2;
  SetFrameData(&clipped_frame, 32767, -32768);
  VerifyFramesAreEqual(clipped_frame, frame_);
}

TEST_F(AudioFrameOperationsTest, ScaleSucceeds) {
  SetFrameData(&frame_, 1, -1);
  EXPECT_EQ(0, AudioFrameOperations::Scale(2.0, 3.0, frame_));

  AudioFrame scaled_frame;
  scaled_frame.samples_per_channel_ = 320;
  scaled_frame.num_channels_ = 2;
  SetFrameData(&scaled_frame, 2, -3);
  VerifyFramesAreEqual(scaled_frame, frame_);
}

// TODO(andrew): should fail with a negative scale.
TEST_F(AudioFrameOperationsTest, DISABLED_ScaleWithSatFailsWithBadParameters) {
  EXPECT_EQ(-1, AudioFrameOperations::ScaleWithSat(-1.0, frame_));
}

TEST_F(AudioFrameOperationsTest, ScaleWithSatDoesNotWrapAround) {
  frame_.num_channels_ = 1;
  SetFrameData(&frame_, 4000);
  EXPECT_EQ(0, AudioFrameOperations::ScaleWithSat(10.0, frame_));

  AudioFrame clipped_frame;
  clipped_frame.samples_per_channel_ = 320;
  clipped_frame.num_channels_ = 1;
  SetFrameData(&clipped_frame, 32767);
  VerifyFramesAreEqual(clipped_frame, frame_);

  SetFrameData(&frame_, -4000);
  EXPECT_EQ(0, AudioFrameOperations::ScaleWithSat(10.0, frame_));
  SetFrameData(&clipped_frame, -32768);
  VerifyFramesAreEqual(clipped_frame, frame_);
}

TEST_F(AudioFrameOperationsTest, ScaleWithSatSucceeds) {
  frame_.num_channels_ = 1;
  SetFrameData(&frame_, 1);
  EXPECT_EQ(0, AudioFrameOperations::ScaleWithSat(2.0, frame_));

  AudioFrame scaled_frame;
  scaled_frame.samples_per_channel_ = 320;
  scaled_frame.num_channels_ = 1;
  SetFrameData(&scaled_frame, 2);
  VerifyFramesAreEqual(scaled_frame, frame_);
}

TEST_F(AudioFrameOperationsTest, AddingXToEmptyGivesX) {
  // When samples_per_channel_ is 0, the frame counts as empty and zero.
  AudioFrame frame_to_add_to;
  frame_to_add_to.samples_per_channel_ = 0;
  frame_to_add_to.num_channels_ = frame_.num_channels_;

  AudioFrameOperations::Add(frame_, &frame_to_add_to);
  VerifyFramesAreEqual(frame_, frame_to_add_to);
}

TEST_F(AudioFrameOperationsTest, AddingTwoFramesProducesTheirSum) {
  AudioFrame frame_to_add_to;
  frame_to_add_to.samples_per_channel_ = frame_.samples_per_channel_;
  frame_to_add_to.num_channels_ = frame_.num_channels_;
  SetFrameData(&frame_to_add_to, 1000);

  AudioFrameOperations::Add(frame_, &frame_to_add_to);
  SetFrameData(&frame_, frame_.data_[0] + 1000);
  VerifyFramesAreEqual(frame_, frame_to_add_to);
}
}  // namespace
}  // namespace webrtc
