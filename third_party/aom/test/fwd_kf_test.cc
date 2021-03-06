/*
 * Copyright (c) 2019, Alliance for Open Media. All rights reserved
 *
 * This source code is subject to the terms of the BSD 2 Clause License and
 * the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
 * was not distributed with this source code in the LICENSE file, you can
 * obtain it at www.aomedia.org/license/software. If the Alliance for Open
 * Media Patent License 1.0 was not distributed with this source code in the
 * PATENTS file, you can obtain it at www.aomedia.org/license/patent.
 */

#include <ostream>

#include "third_party/googletest/src/googletest/include/gtest/gtest.h"
#include "test/codec_factory.h"
#include "test/encode_test_driver.h"
#include "test/i420_video_source.h"
#include "test/util.h"

namespace {

typedef struct {
  const int max_kf_dist;
  const double psnr_thresh;
} FwdKfTestParam;

const FwdKfTestParam kTestParams[] = {
  { 4, 33.4 },  { 6, 32.9 },  { 8, 32.6 },
  { 12, 32.4 }, { 16, 32.3 }, { 18, 32.1 }
};

std::ostream &operator<<(std::ostream &os, const FwdKfTestParam &test_arg) {
  return os << "FwdKfTestParam { max_kf_dist:" << test_arg.max_kf_dist
            << " psnr_thresh:" << test_arg.psnr_thresh << " }";
}

class ForwardKeyTest
    : public ::libaom_test::CodecTestWith2Params<libaom_test::TestMode,
                                                 FwdKfTestParam>,
      public ::libaom_test::EncoderTest {
 protected:
  ForwardKeyTest()
      : EncoderTest(GET_PARAM(0)), encoding_mode_(GET_PARAM(1)),
        kf_max_dist_param_(GET_PARAM(2)) {}
  virtual ~ForwardKeyTest() {}

  virtual void SetUp() {
    InitializeConfig();
    SetMode(encoding_mode_);
    const aom_rational timebase = { 1, 30 };
    cfg_.g_timebase = timebase;
    cpu_used_ = 2;
    kf_max_dist_ = kf_max_dist_param_.max_kf_dist;
    psnr_threshold_ = kf_max_dist_param_.psnr_thresh;
    cfg_.rc_end_usage = AOM_VBR;
    cfg_.rc_target_bitrate = 200;
    cfg_.g_lag_in_frames = 10;
    cfg_.fwd_kf_enabled = 1;
    cfg_.kf_max_dist = kf_max_dist_;
    cfg_.g_threads = 0;
    init_flags_ = AOM_CODEC_USE_PSNR;
  }

  virtual void BeginPassHook(unsigned int) {
    psnr_ = 0.0;
    nframes_ = 0;
  }

  virtual void PSNRPktHook(const aom_codec_cx_pkt_t *pkt) {
    psnr_ += pkt->data.psnr.psnr[0];
    nframes_++;
  }

  virtual void PreEncodeFrameHook(::libaom_test::VideoSource *video,
                                  ::libaom_test::Encoder *encoder) {
    if (video->frame() == 0) {
      encoder->Control(AOME_SET_CPUUSED, cpu_used_);
      if (encoding_mode_ != ::libaom_test::kRealTime) {
        encoder->Control(AOME_SET_ENABLEAUTOALTREF, 1);
        encoder->Control(AOME_SET_ARNR_MAXFRAMES, 7);
        encoder->Control(AOME_SET_ARNR_STRENGTH, 5);
      }
    }
  }

  double GetAveragePsnr() const {
    if (nframes_) return psnr_ / nframes_;
    return 0.0;
  }

  double GetPsnrThreshold() { return psnr_threshold_; }

  ::libaom_test::TestMode encoding_mode_;
  const FwdKfTestParam kf_max_dist_param_;
  double psnr_threshold_;
  int kf_max_dist_;
  int cpu_used_;
  int nframes_;
  double psnr_;
};

TEST_P(ForwardKeyTest, ForwardKeyEncodeTest) {
  libaom_test::I420VideoSource video("hantro_collage_w352h288.yuv", 352, 288,
                                     cfg_.g_timebase.den, cfg_.g_timebase.num,
                                     0, 20);
  ASSERT_NO_FATAL_FAILURE(RunLoop(&video));
  // TODO(sarahparker) Add functionality to assert the minimum number of
  // keyframes were placed.
  EXPECT_GT(GetAveragePsnr(), GetPsnrThreshold())
      << "kf max dist = " << kf_max_dist_;
}

AV1_INSTANTIATE_TEST_CASE(ForwardKeyTest,
                          ::testing::Values(::libaom_test::kTwoPassGood),
                          ::testing::ValuesIn(kTestParams));
}  // namespace
