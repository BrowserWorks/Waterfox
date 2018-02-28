/*
 *  Copyright (c) 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include <stdio.h>

#include <memory>
#include <string>

#include "webrtc/test/frame_generator.h"
#include "webrtc/test/gtest.h"
#include "webrtc/test/testsupport/fileutils.h"

namespace webrtc {
namespace test {

static const int kFrameWidth = 4;
static const int kFrameHeight = 4;

class FrameGeneratorTest : public ::testing::Test {
 public:
  void SetUp() override {
    two_frame_filename_ =
        test::TempFilename(test::OutputPath(), "2_frame_yuv_file");
    one_frame_filename_ =
        test::TempFilename(test::OutputPath(), "1_frame_yuv_file");

    FILE* file = fopen(two_frame_filename_.c_str(), "wb");
    WriteYuvFile(file, 0, 0, 0);
    WriteYuvFile(file, 127, 127, 127);
    fclose(file);
    file = fopen(one_frame_filename_.c_str(), "wb");
    WriteYuvFile(file, 255, 255, 255);
    fclose(file);
  }
  void TearDown() override {
    remove(one_frame_filename_.c_str());
    remove(two_frame_filename_.c_str());
  }

 protected:
  void WriteYuvFile(FILE* file, uint8_t y, uint8_t u, uint8_t v) {
    assert(file);
    std::unique_ptr<uint8_t[]> plane_buffer(new uint8_t[y_size]);
    memset(plane_buffer.get(), y, y_size);
    fwrite(plane_buffer.get(), 1, y_size, file);
    memset(plane_buffer.get(), u, uv_size);
    fwrite(plane_buffer.get(), 1, uv_size, file);
    memset(plane_buffer.get(), v, uv_size);
    fwrite(plane_buffer.get(), 1, uv_size, file);
  }

  void CheckFrameAndMutate(VideoFrame* frame, uint8_t y, uint8_t u, uint8_t v) {
    // Check that frame is valid, has the correct color and timestamp are clean.
    ASSERT_NE(nullptr, frame);
    const uint8_t* buffer;
    buffer = frame->video_frame_buffer()->DataY();
    for (int i = 0; i < y_size; ++i)
      ASSERT_EQ(y, buffer[i]);
    buffer = frame->video_frame_buffer()->DataU();
    for (int i = 0; i < uv_size; ++i)
      ASSERT_EQ(u, buffer[i]);
    buffer = frame->video_frame_buffer()->DataV();
    for (int i = 0; i < uv_size; ++i)
      ASSERT_EQ(v, buffer[i]);
    EXPECT_EQ(0, frame->ntp_time_ms());
    EXPECT_EQ(0, frame->render_time_ms());
    EXPECT_EQ(0u, frame->timestamp());

    // Mutate to something arbitrary non-zero.
    frame->set_ntp_time_ms(11);
    frame->set_render_time_ms(12);
    frame->set_timestamp(13);
  }

  std::string two_frame_filename_;
  std::string one_frame_filename_;
  const int y_size = kFrameWidth * kFrameHeight;
  const int uv_size = ((kFrameHeight + 1) / 2) * ((kFrameWidth + 1) / 2);
};

TEST_F(FrameGeneratorTest, SingleFrameFile) {
  std::unique_ptr<FrameGenerator> generator(FrameGenerator::CreateFromYuvFile(
      std::vector<std::string>(1, one_frame_filename_), kFrameWidth,
      kFrameHeight, 1));
  CheckFrameAndMutate(generator->NextFrame(), 255, 255, 255);
  CheckFrameAndMutate(generator->NextFrame(), 255, 255, 255);
}

TEST_F(FrameGeneratorTest, TwoFrameFile) {
  std::unique_ptr<FrameGenerator> generator(FrameGenerator::CreateFromYuvFile(
      std::vector<std::string>(1, two_frame_filename_), kFrameWidth,
      kFrameHeight, 1));
  CheckFrameAndMutate(generator->NextFrame(), 0, 0, 0);
  CheckFrameAndMutate(generator->NextFrame(), 127, 127, 127);
  CheckFrameAndMutate(generator->NextFrame(), 0, 0, 0);
}

TEST_F(FrameGeneratorTest, MultipleFrameFiles) {
  std::vector<std::string> files;
  files.push_back(two_frame_filename_);
  files.push_back(one_frame_filename_);

  std::unique_ptr<FrameGenerator> generator(
      FrameGenerator::CreateFromYuvFile(files, kFrameWidth, kFrameHeight, 1));
  CheckFrameAndMutate(generator->NextFrame(), 0, 0, 0);
  CheckFrameAndMutate(generator->NextFrame(), 127, 127, 127);
  CheckFrameAndMutate(generator->NextFrame(), 255, 255, 255);
  CheckFrameAndMutate(generator->NextFrame(), 0, 0, 0);
}

TEST_F(FrameGeneratorTest, TwoFrameFileWithRepeat) {
  const int kRepeatCount = 3;
  std::unique_ptr<FrameGenerator> generator(FrameGenerator::CreateFromYuvFile(
      std::vector<std::string>(1, two_frame_filename_), kFrameWidth,
      kFrameHeight, kRepeatCount));
  for (int i = 0; i < kRepeatCount; ++i)
    CheckFrameAndMutate(generator->NextFrame(), 0, 0, 0);
  for (int i = 0; i < kRepeatCount; ++i)
    CheckFrameAndMutate(generator->NextFrame(), 127, 127, 127);
  CheckFrameAndMutate(generator->NextFrame(), 0, 0, 0);
}

TEST_F(FrameGeneratorTest, MultipleFrameFilesWithRepeat) {
  const int kRepeatCount = 3;
  std::vector<std::string> files;
  files.push_back(two_frame_filename_);
  files.push_back(one_frame_filename_);
  std::unique_ptr<FrameGenerator> generator(FrameGenerator::CreateFromYuvFile(
      files, kFrameWidth, kFrameHeight, kRepeatCount));
  for (int i = 0; i < kRepeatCount; ++i)
    CheckFrameAndMutate(generator->NextFrame(), 0, 0, 0);
  for (int i = 0; i < kRepeatCount; ++i)
    CheckFrameAndMutate(generator->NextFrame(), 127, 127, 127);
  for (int i = 0; i < kRepeatCount; ++i)
    CheckFrameAndMutate(generator->NextFrame(), 255, 255, 255);
  CheckFrameAndMutate(generator->NextFrame(), 0, 0, 0);
}

}  // namespace test
}  // namespace webrtc
