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

#include <cmath>
#include <cstdlib>
#include <string>
#include <tuple>

#include "third_party/googletest/src/googletest/include/gtest/gtest.h"

#include "config/aom_config.h"
#include "config/aom_dsp_rtcd.h"
#include "config/av1_rtcd.h"

#include "aom_ports/mem.h"
#include "test/acm_random.h"
#include "test/clear_system_state.h"
#include "test/register_state_check.h"
#include "test/util.h"
#include "test/function_equivalence_test.h"

using libaom_test::ACMRandom;
using libaom_test::FunctionEquivalenceTest;
using ::testing::Combine;
using ::testing::Range;
using ::testing::Values;
using ::testing::ValuesIn;

#if !CONFIG_REALTIME_ONLY
namespace {

typedef void (*TemporalFilterPlanewiseFunc)(
    const YV12_BUFFER_CONFIG *ref_frame, const MACROBLOCKD *mbd,
    const BLOCK_SIZE block_size, const int mb_row, const int mb_col,
    const int num_planes, const double *noise_level, const int use_subblock,
    const int block_mse, const int *subblock_mses, const int q_factor,
    const uint8_t *pred, uint32_t *accum, uint16_t *count);
typedef libaom_test::FuncParam<TemporalFilterPlanewiseFunc>
    TemporalFilterPlanewiseFuncParam;

typedef std::tuple<TemporalFilterPlanewiseFuncParam, int>
    TemporalFilterPlanewiseWithParam;

class TemporalFilterPlanewiseTest
    : public ::testing::TestWithParam<TemporalFilterPlanewiseWithParam> {
 public:
  virtual ~TemporalFilterPlanewiseTest() {}
  virtual void SetUp() {
    params_ = GET_PARAM(0);
    rnd_.Reset(ACMRandom::DeterministicSeed());
    src1_ = reinterpret_cast<uint8_t *>(aom_memalign(8, 256 * 256));
    src2_ = reinterpret_cast<uint8_t *>(aom_memalign(8, 256 * 256));

    ASSERT_TRUE(src1_ != NULL);
    ASSERT_TRUE(src2_ != NULL);
  }

  virtual void TearDown() {
    libaom_test::ClearSystemState();
    aom_free(src1_);
    aom_free(src2_);
  }
  void RunTest(int isRandom, int width, int height, int run_times);

  void GenRandomData(int width, int height, int stride, int stride2) {
    for (int ii = 0; ii < height; ii++) {
      for (int jj = 0; jj < width; jj++) {
        src1_[ii * stride + jj] = rnd_.Rand8();
        src2_[ii * stride2 + jj] = rnd_.Rand8();
      }
    }
  }

  void GenExtremeData(int width, int height, int stride, uint8_t *data,
                      int stride2, uint8_t *data2, uint8_t val) {
    for (int ii = 0; ii < height; ii++) {
      for (int jj = 0; jj < width; jj++) {
        data[ii * stride + jj] = val;
        data2[ii * stride2 + jj] = (255 - val);
      }
    }
  }

 protected:
  TemporalFilterPlanewiseFuncParam params_;
  uint8_t *src1_;
  uint8_t *src2_;
  ACMRandom rnd_;
};

void TemporalFilterPlanewiseTest::RunTest(int isRandom, int width, int height,
                                          int run_times) {
  aom_usec_timer ref_timer, test_timer;
  for (int k = 0; k < 3; k++) {
    const int stride = width;
    const int stride2 = width;
    if (isRandom) {
      GenRandomData(width, height, stride, stride2);
    } else {
      const int msb = 8;  // Up to 8 bit input
      const int limit = (1 << msb) - 1;
      if (k == 0) {
        GenExtremeData(width, height, stride, src1_, stride2, src2_, limit);
      } else {
        GenExtremeData(width, height, stride, src1_, stride2, src2_, 0);
      }
    }
    double sigma[1] = { 2.1002103677063437 };
    DECLARE_ALIGNED(16, unsigned int, accumulator_ref[1024 * 3]);
    DECLARE_ALIGNED(16, uint16_t, count_ref[1024 * 3]);
    memset(accumulator_ref, 0, 1024 * 3 * sizeof(accumulator_ref[0]));
    memset(count_ref, 0, 1024 * 3 * sizeof(count_ref[0]));
    DECLARE_ALIGNED(16, unsigned int, accumulator_mod[1024 * 3]);
    DECLARE_ALIGNED(16, uint16_t, count_mod[1024 * 3]);
    memset(accumulator_mod, 0, 1024 * 3 * sizeof(accumulator_mod[0]));
    memset(count_mod, 0, 1024 * 3 * sizeof(count_mod[0]));

    assert(width == 32 && height == 32);
    const BLOCK_SIZE block_size = BLOCK_32X32;
    const int use_subblock = 0;
    const int block_mse = 20;
    const int subblock_mses[4] = { 15, 16, 17, 18 };
    const int q_factor = 12;
    const int mb_row = 0;
    const int mb_col = 0;
    const int num_planes = 1;
    YV12_BUFFER_CONFIG *ref_frame =
        (YV12_BUFFER_CONFIG *)malloc(sizeof(YV12_BUFFER_CONFIG));
    ref_frame->heights[0] = height;
    ref_frame->strides[0] = stride;
    DECLARE_ALIGNED(16, uint8_t, src[1024 * 3]);
    ref_frame->buffer_alloc = src;
    ref_frame->buffers[0] = ref_frame->buffer_alloc;
    ref_frame->flags = 0;  // Only support low bit-depth test.
    memcpy(src, src1_, 1024 * 3 * sizeof(uint8_t));

    MACROBLOCKD *mbd = (MACROBLOCKD *)malloc(sizeof(MACROBLOCKD));
    mbd->plane[0].subsampling_y = 0;
    mbd->plane[0].subsampling_x = 0;
    mbd->bd = 8;

    params_.ref_func(ref_frame, mbd, block_size, mb_row, mb_col, num_planes,
                     sigma, use_subblock, block_mse, subblock_mses, q_factor,
                     src2_, accumulator_ref, count_ref);
    params_.tst_func(ref_frame, mbd, block_size, mb_row, mb_col, num_planes,
                     sigma, use_subblock, block_mse, subblock_mses, q_factor,
                     src2_, accumulator_mod, count_mod);

    if (run_times > 1) {
      aom_usec_timer_start(&ref_timer);
      for (int j = 0; j < run_times; j++) {
        params_.ref_func(ref_frame, mbd, block_size, mb_row, mb_col, num_planes,
                         sigma, use_subblock, block_mse, subblock_mses,
                         q_factor, src2_, accumulator_ref, count_ref);
      }
      aom_usec_timer_mark(&ref_timer);
      const int elapsed_time_c =
          static_cast<int>(aom_usec_timer_elapsed(&ref_timer));

      aom_usec_timer_start(&test_timer);
      for (int j = 0; j < run_times; j++) {
        params_.tst_func(ref_frame, mbd, block_size, mb_row, mb_col, num_planes,
                         sigma, use_subblock, block_mse, subblock_mses,
                         q_factor, src2_, accumulator_mod, count_mod);
      }
      aom_usec_timer_mark(&test_timer);
      const int elapsed_time_simd =
          static_cast<int>(aom_usec_timer_elapsed(&test_timer));

      printf(
          "c_time=%d \t simd_time=%d \t "
          "gain=%f\t width=%d\t height=%d \n",
          elapsed_time_c, elapsed_time_simd,
          (float)((float)elapsed_time_c / (float)elapsed_time_simd), width,
          height);

    } else {
      for (int i = 0, l = 0; i < height; i++) {
        for (int j = 0; j < width; j++, l++) {
          EXPECT_EQ(accumulator_ref[l], accumulator_mod[l])
              << "Error:" << k << " SSE Sum Test [" << width << "x" << height
              << "] C accumulator does not match optimized accumulator.";
          EXPECT_EQ(count_ref[l], count_mod[l])
              << "Error:" << k << " SSE Sum Test [" << width << "x" << height
              << "] C count does not match optimized count.";
        }
      }
    }

    free(ref_frame);
    free(mbd);
  }
}

TEST_P(TemporalFilterPlanewiseTest, OperationCheck) {
  for (int height = 32; height <= 32; height = height * 2) {
    RunTest(1, height, height, 1);  // GenRandomData
  }
}

TEST_P(TemporalFilterPlanewiseTest, ExtremeValues) {
  for (int height = 32; height <= 32; height = height * 2) {
    RunTest(0, height, height, 1);
  }
}

TEST_P(TemporalFilterPlanewiseTest, DISABLED_Speed) {
  for (int height = 32; height <= 32; height = height * 2) {
    RunTest(1, height, height, 100000);
  }
}

#if HAVE_AVX2
TemporalFilterPlanewiseFuncParam temporal_filter_planewise_test_avx2[] = {
  TemporalFilterPlanewiseFuncParam(&av1_apply_temporal_filter_planewise_c,
                                   &av1_apply_temporal_filter_planewise_avx2)
};
INSTANTIATE_TEST_SUITE_P(AVX2, TemporalFilterPlanewiseTest,
                         Combine(ValuesIn(temporal_filter_planewise_test_avx2),
                                 Range(64, 65, 4)));
#endif  // HAVE_AVX2

#if HAVE_SSE2
TemporalFilterPlanewiseFuncParam temporal_filter_planewise_test_sse2[] = {
  TemporalFilterPlanewiseFuncParam(&av1_apply_temporal_filter_planewise_c,
                                   &av1_apply_temporal_filter_planewise_sse2)
};
INSTANTIATE_TEST_SUITE_P(SSE2, TemporalFilterPlanewiseTest,
                         Combine(ValuesIn(temporal_filter_planewise_test_sse2),
                                 Range(64, 65, 4)));
#endif  // HAVE_SSE2

}  // namespace
#endif
