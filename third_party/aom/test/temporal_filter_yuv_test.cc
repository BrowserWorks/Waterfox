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

#include "config/av1_rtcd.h"
#include "test/acm_random.h"
#include "test/register_state_check.h"
#include "aom_ports/aom_timer.h"
#include "aom_ports/mem.h"

namespace {

using ::libaom_test::ACMRandom;

const int MAX_WIDTH = 32;
const int MAX_HEIGHT = 32;

typedef void (*TemporalFilterYUVFunc)(
    const YV12_BUFFER_CONFIG *ref_frame, const MACROBLOCKD *mbd,
    const BLOCK_SIZE block_size, const int mb_row, const int mb_col,
    const int num_planes, const int strength, const int use_subblock,
    const int *blk_fw, const uint8_t *pred, uint32_t *accum, uint16_t *count);

struct TemporalFilterWithBd {
  TemporalFilterWithBd(TemporalFilterYUVFunc func, int bitdepth)
      : temporal_filter(func), bd(bitdepth) {}

  TemporalFilterYUVFunc temporal_filter;
  int bd;
};

std::ostream &operator<<(std::ostream &os, const TemporalFilterWithBd &tf) {
  return os << "Bitdepth: " << tf.bd;
}

int GetFilterWeight(unsigned int row, unsigned int col,
                    unsigned int block_height, unsigned int block_width,
                    const int *const blk_fw, int use_32x32) {
  if (use_32x32) {
    return blk_fw[0];
  }

  return blk_fw[2 * (row >= block_height / 2) + (col >= block_width / 2)];
}

template <typename PixelType>
int GetModIndex(int sum_dist, int index, int rounding, int strength,
                int filter_weight) {
  int mod = sum_dist * 3 / index;
  mod += rounding;
  mod >>= strength;

  mod = AOMMIN(16, mod);

  mod = 16 - mod;
  mod *= filter_weight;

  return mod;
}

// Lowbitdepth version
template <>
int GetModIndex<uint8_t>(int sum_dist, int index, int rounding, int strength,
                         int filter_weight) {
  unsigned int index_mult[14] = { 0,     0,     0,     0,     49152,
                                  39322, 32768, 28087, 24576, 21846,
                                  19661, 17874, 0,     15124 };

  assert(index >= 0 && index <= 13);
  assert(index_mult[index] != 0);

  int mod = (clamp(sum_dist, 0, UINT16_MAX) * index_mult[index]) >> 16;
  mod += rounding;
  mod >>= strength;

  mod = AOMMIN(16, mod);

  mod = 16 - mod;
  mod *= filter_weight;

  return mod;
}

// Highbitdepth version
template <>
int GetModIndex<uint16_t>(int sum_dist, int index, int rounding, int strength,
                          int filter_weight) {
  int64_t index_mult[14] = { 0U,          0U,          0U,          0U,
                             3221225472U, 2576980378U, 2147483648U, 1840700270U,
                             1610612736U, 1431655766U, 1288490189U, 1171354718U,
                             0U,          991146300U };

  assert(index >= 0 && index <= 13);
  assert(index_mult[index] != 0);

  int mod = static_cast<int>((sum_dist * index_mult[index]) >> 32);
  mod += rounding;
  mod >>= strength;

  mod = AOMMIN(16, mod);

  mod = 16 - mod;
  mod *= filter_weight;

  return mod;
}

template <typename PixelType>
void SetArray(PixelType *pixel_array, int width, int height, int stride,
              int val) {
  for (int row = 0; row < height; row++) {
    for (int col = 0; col < width; col++) {
      pixel_array[col] = val;
    }
    pixel_array += stride;
  }
}

template <typename PixelType>
void SetArray(PixelType *pixel_array, int width, int height, int stride,
              ACMRandom *rnd, int low_val, int high_val) {
  EXPECT_LE(low_val, high_val);

  for (int row = 0; row < height; row++) {
    for (int col = 0; col < width; col++) {
      const int val =
          static_cast<int>((*rnd).PseudoUniform(high_val - low_val));
      pixel_array[col] = low_val + val;
    }
    pixel_array += stride;
  }
}

template <typename ValueType>
bool CheckArrayEqual(const ValueType *arr_1, const ValueType *arr_2, int width,
                     int height, int stride_1, int stride_2) {
  for (int row = 0; row < height; row++) {
    for (int col = 0; col < width; col++) {
      if (arr_1[col] != arr_2[col]) {
        return false;
      }
    }
    arr_1 += stride_1;
    arr_2 += stride_2;
  }
  return true;
}

template <typename ValueType>
void PrintArrayDiff(const ValueType *arr_1, const ValueType *arr_2, int width,
                    int height, int stride_1, int stride_2) {
  const ValueType *arr_1_start = arr_1, *arr_2_start = arr_2;

  printf("Array 1:\n");
  for (int row = 0; row < height; ++row) {
    for (int col = 0; col < width; ++col) {
      if (arr_1[col] != arr_2[col]) {
        printf("*%3d", arr_1[col]);
      } else {
        printf("%4d", arr_1[col]);
      }
    }
    printf("\n");
    arr_1 += stride_1;
    arr_2 += stride_2;
  }

  arr_1 = arr_1_start;
  arr_2 = arr_2_start;

  printf("Array 2:\n");
  for (int row = 0; row < height; ++row) {
    for (int col = 0; col < width; ++col) {
      if (arr_1[col] != arr_2[col]) {
        printf("*%3d", arr_2[col]);
      } else {
        printf("%4d", arr_2[col]);
      }
    }
    printf("\n");
    arr_1 += stride_1;
    arr_2 += stride_2;
  }

  arr_1 = arr_1_start;
  arr_2 = arr_2_start;
  printf("Difference:\n");
  for (int row = 0; row < height; ++row) {
    for (int col = 0; col < width; ++col) {
      printf("%4d", arr_1[col] - arr_2[col]);
    }
    printf("\n");
    arr_1 += stride_1;
    arr_2 += stride_2;
  }
}

template <typename PixelType>
void ApplyReferenceFilter(const PixelType *y_src, const PixelType *y_pre,
                          const PixelType *u_src, const PixelType *v_src,
                          const PixelType *u_pre, const PixelType *v_pre,
                          unsigned int block_width, unsigned int block_height,
                          int ss_x, int ss_y, int strength,
                          const int *const blk_fw, int use_32x32,
                          uint32_t *y_accum, uint16_t *y_count,
                          uint32_t *u_accum, uint16_t *u_count,
                          uint32_t *v_accum, uint16_t *v_count) {
  const int uv_block_width = block_width >> ss_x,
            uv_block_height = block_height >> ss_y;
  const int y_src_stride = block_width, y_pre_stride = block_width;
  const int uv_src_stride = uv_block_width, uv_pre_stride = uv_block_width;
  const int y_diff_stride = block_width, uv_diff_stride = uv_block_width;
  const int y_count_stride = block_width, u_count_stride = uv_block_width,
            v_count_stride = uv_block_width;
  const int y_accum_stride = block_width, u_accum_stride = uv_block_width,
            v_accum_stride = uv_block_width;

  int y_dif[MAX_WIDTH * MAX_HEIGHT] = { 0 };
  int u_dif[MAX_WIDTH * MAX_HEIGHT] = { 0 };
  int v_dif[MAX_WIDTH * MAX_HEIGHT] = { 0 };

  const int rounding = (1 << strength) >> 1;

  // Get the square diffs
  for (int row = 0; row < (int)block_height; row++) {
    for (int col = 0; col < (int)block_width; col++) {
      const int diff =
          y_src[row * y_src_stride + col] - y_pre[row * y_pre_stride + col];
      y_dif[row * y_diff_stride + col] = diff * diff;
    }
  }

  for (int row = 0; row < (int)uv_block_height; row++) {
    for (int col = 0; col < (int)uv_block_width; col++) {
      const int u_diff =
          u_src[row * uv_src_stride + col] - u_pre[row * uv_pre_stride + col];
      const int v_diff =
          v_src[row * uv_src_stride + col] - v_pre[row * uv_pre_stride + col];
      u_dif[row * uv_diff_stride + col] = u_diff * u_diff;
      v_dif[row * uv_diff_stride + col] = v_diff * v_diff;
    }
  }

  // Apply the filter to luma
  for (int row = 0; row < (int)block_height; row++) {
    for (int col = 0; col < (int)block_width; col++) {
      const int uv_row = row >> ss_y;
      const int uv_col = col >> ss_x;
      const int filter_weight = GetFilterWeight(row, col, block_height,
                                                block_width, blk_fw, use_32x32);

      // First we get the modifier for the current y pixel
      const int y_pixel = y_pre[row * y_pre_stride + col];
      int y_num_used = 0;
      int y_mod = 0;

      // Sum the neighboring 3x3 y pixels
      for (int row_step = -1; row_step <= 1; row_step++) {
        for (int col_step = -1; col_step <= 1; col_step++) {
          const int sub_row = row + row_step;
          const int sub_col = col + col_step;

          if (sub_row >= 0 && sub_row < (int)block_height && sub_col >= 0 &&
              sub_col < (int)block_width) {
            y_mod += y_dif[sub_row * y_diff_stride + sub_col];
            y_num_used++;
          }
        }
      }

      // Sum the corresponding uv pixels to the current y modifier
      // Note we are rounding down instead of rounding to the nearest pixel.
      y_mod += u_dif[uv_row * uv_diff_stride + uv_col];
      y_mod += v_dif[uv_row * uv_diff_stride + uv_col];

      y_num_used += 2;

      // Set the modifier
      y_mod = GetModIndex<PixelType>(y_mod, y_num_used, rounding, strength,
                                     filter_weight);

      // Accumulate the result
      y_count[row * y_count_stride + col] += y_mod;
      y_accum[row * y_accum_stride + col] += y_mod * y_pixel;
    }
  }

  // Apply the filter to chroma
  for (int uv_row = 0; uv_row < (int)uv_block_height; uv_row++) {
    for (int uv_col = 0; uv_col < (int)uv_block_width; uv_col++) {
      const int y_row = uv_row << ss_y;
      const int y_col = uv_col << ss_x;
      const int filter_weight = GetFilterWeight(
          uv_row, uv_col, uv_block_height, uv_block_width, blk_fw, use_32x32);

      const int u_pixel = u_pre[uv_row * uv_pre_stride + uv_col];
      const int v_pixel = v_pre[uv_row * uv_pre_stride + uv_col];

      int uv_num_used = 0;
      int u_mod = 0, v_mod = 0;

      // Sum the neighboring 3x3 chromal pixels to the chroma modifier
      for (int row_step = -1; row_step <= 1; row_step++) {
        for (int col_step = -1; col_step <= 1; col_step++) {
          const int sub_row = uv_row + row_step;
          const int sub_col = uv_col + col_step;

          if (sub_row >= 0 && sub_row < uv_block_height && sub_col >= 0 &&
              sub_col < uv_block_width) {
            u_mod += u_dif[sub_row * uv_diff_stride + sub_col];
            v_mod += v_dif[sub_row * uv_diff_stride + sub_col];
            uv_num_used++;
          }
        }
      }

      // Sum all the luma pixels associated with the current luma pixel
      for (int row_step = 0; row_step < 1 + ss_y; row_step++) {
        for (int col_step = 0; col_step < 1 + ss_x; col_step++) {
          const int sub_row = y_row + row_step;
          const int sub_col = y_col + col_step;
          const int y_diff = y_dif[sub_row * y_diff_stride + sub_col];

          u_mod += y_diff;
          v_mod += y_diff;
          uv_num_used++;
        }
      }

      // Set the modifier
      u_mod = GetModIndex<PixelType>(u_mod, uv_num_used, rounding, strength,
                                     filter_weight);
      v_mod = GetModIndex<PixelType>(v_mod, uv_num_used, rounding, strength,
                                     filter_weight);

      // Accumulate the result
      u_count[uv_row * u_count_stride + uv_col] += u_mod;
      u_accum[uv_row * u_accum_stride + uv_col] += u_mod * u_pixel;
      v_count[uv_row * v_count_stride + uv_col] += v_mod;
      v_accum[uv_row * v_accum_stride + uv_col] += v_mod * v_pixel;
    }
  }
}

class TemporalFilterYUVTest
    : public ::testing::TestWithParam<TemporalFilterWithBd> {
 public:
  virtual void SetUp() {
    filter_func_ = GetParam().temporal_filter;
    bd_ = GetParam().bd;
    use_highbd_ = (bd_ != 8);

    rnd_.Reset(ACMRandom::DeterministicSeed());
    saturate_test_ = 0;
    num_repeats_ = 10;

    ASSERT_TRUE(bd_ == 8 || bd_ == 10 || bd_ == 12);
  }

 protected:
  template <typename PixelType>
  void CompareTestWithParam(int width, int height, int ss_x, int ss_y,
                            int filter_strength, int use_32x32,
                            const int *filter_weight);
  template <typename PixelType>
  void RunTestFilterWithParam(int width, int height, int ss_x, int ss_y,
                              int filter_strength, int use_32x32,
                              const int *filter_weight);
  template <typename PixelType>
  void ApplyTestFilter(const PixelType *y_src, int y_src_stride,
                       const PixelType *y_pre, int y_pre_stride,
                       const PixelType *u_src, const PixelType *v_src,
                       int uv_src_stride, const PixelType *u_pre,
                       const PixelType *v_pre, int uv_pre_stride,
                       unsigned int block_width, unsigned int block_height,
                       int ss_x, int ss_y, int strength, const int *blk_fw,
                       int use_32x32, uint32_t *y_accum, uint16_t *y_count,
                       uint32_t *u_accumu, uint16_t *u_count, uint32_t *v_accum,
                       uint16_t *v_count);

  TemporalFilterYUVFunc filter_func_;
  ACMRandom rnd_;
  int saturate_test_;
  int num_repeats_;
  int use_highbd_;
  int bd_;
};

template <>
void TemporalFilterYUVTest::ApplyTestFilter<uint8_t>(
    const uint8_t *y_src, int y_src_stride, const uint8_t *y_pre,
    int y_pre_stride, const uint8_t *u_src, const uint8_t *v_src,
    int uv_src_stride, const uint8_t *u_pre, const uint8_t *v_pre,
    int uv_pre_stride, unsigned int block_width, unsigned int block_height,
    int ss_x, int ss_y, int strength, const int *blk_fw, int use_32x32,
    uint32_t *y_accum, uint16_t *y_count, uint32_t *u_accum, uint16_t *u_count,
    uint32_t *v_accum, uint16_t *v_count) {
  (void)block_width;
  (void)block_height;
  (void)y_src_stride;
  (void)uv_src_stride;

  assert(block_width == MAX_WIDTH && MAX_WIDTH == 32);
  assert(block_height == MAX_HEIGHT && MAX_HEIGHT == 32);
  const BLOCK_SIZE block_size = BLOCK_32X32;
  const int num_planes = 3;
  const int mb_pels = MAX_WIDTH * MAX_HEIGHT;
  const int mb_row = 0;
  const int mb_col = 0;
  const int use_subblock = !(use_32x32);

  YV12_BUFFER_CONFIG *ref_frame =
      (YV12_BUFFER_CONFIG *)malloc(sizeof(YV12_BUFFER_CONFIG));
  ref_frame->strides[0] = y_pre_stride;
  ref_frame->strides[1] = uv_pre_stride;
  const int alloc_size = MAX_MB_PLANE * mb_pels;
  DECLARE_ALIGNED(16, uint8_t, src[alloc_size]);
  ref_frame->buffer_alloc = src;
  ref_frame->buffers[0] = ref_frame->buffer_alloc + 0 * mb_pels;
  ref_frame->buffers[1] = ref_frame->buffer_alloc + 1 * mb_pels;
  ref_frame->buffers[2] = ref_frame->buffer_alloc + 2 * mb_pels;
  ref_frame->flags = bd_ > 8 ? YV12_FLAG_HIGHBITDEPTH : 0;

  MACROBLOCKD *mbd = (MACROBLOCKD *)malloc(sizeof(MACROBLOCKD));
  mbd->plane[0].subsampling_y = 0;
  mbd->plane[0].subsampling_x = 0;
  mbd->plane[1].subsampling_y = ss_y;
  mbd->plane[1].subsampling_x = ss_x;
  mbd->plane[2].subsampling_y = ss_y;
  mbd->plane[2].subsampling_x = ss_x;

  DECLARE_ALIGNED(16, uint8_t, pred[alloc_size]);
  DECLARE_ALIGNED(16, uint32_t, accum[alloc_size]);
  DECLARE_ALIGNED(16, uint16_t, count[alloc_size]);
  memcpy(src + 0 * mb_pels, y_src, mb_pels * sizeof(uint8_t));
  memcpy(src + 1 * mb_pels, u_src, mb_pels * sizeof(uint8_t));
  memcpy(src + 2 * mb_pels, v_src, mb_pels * sizeof(uint8_t));
  memcpy(pred + 0 * mb_pels, y_pre, mb_pels * sizeof(uint8_t));
  memcpy(pred + 1 * mb_pels, u_pre, mb_pels * sizeof(uint8_t));
  memcpy(pred + 2 * mb_pels, v_pre, mb_pels * sizeof(uint8_t));
  memcpy(accum + 0 * mb_pels, y_accum, mb_pels * sizeof(uint32_t));
  memcpy(accum + 1 * mb_pels, u_accum, mb_pels * sizeof(uint32_t));
  memcpy(accum + 2 * mb_pels, v_accum, mb_pels * sizeof(uint32_t));
  memcpy(count + 0 * mb_pels, y_count, mb_pels * sizeof(uint16_t));
  memcpy(count + 1 * mb_pels, u_count, mb_pels * sizeof(uint16_t));
  memcpy(count + 2 * mb_pels, v_count, mb_pels * sizeof(uint16_t));

  ASM_REGISTER_STATE_CHECK(
      filter_func_(ref_frame, mbd, block_size, mb_row, mb_col, num_planes,
                   strength, use_subblock, blk_fw, pred, accum, count));

  memcpy(y_accum, accum + 0 * mb_pels, mb_pels * sizeof(uint32_t));
  memcpy(u_accum, accum + 1 * mb_pels, mb_pels * sizeof(uint32_t));
  memcpy(v_accum, accum + 2 * mb_pels, mb_pels * sizeof(uint32_t));
  memcpy(y_count, count + 0 * mb_pels, mb_pels * sizeof(uint16_t));
  memcpy(u_count, count + 1 * mb_pels, mb_pels * sizeof(uint16_t));
  memcpy(v_count, count + 2 * mb_pels, mb_pels * sizeof(uint16_t));

  free(ref_frame);
  free(mbd);
}

template <>
void TemporalFilterYUVTest::ApplyTestFilter<uint16_t>(
    const uint16_t *y_src, int y_src_stride, const uint16_t *y_pre,
    int y_pre_stride, const uint16_t *u_src, const uint16_t *v_src,
    int uv_src_stride, const uint16_t *u_pre, const uint16_t *v_pre,
    int uv_pre_stride, unsigned int block_width, unsigned int block_height,
    int ss_x, int ss_y, int strength, const int *blk_fw, int use_32x32,
    uint32_t *y_accum, uint16_t *y_count, uint32_t *u_accum, uint16_t *u_count,
    uint32_t *v_accum, uint16_t *v_count) {
  (void)block_width;
  (void)block_height;
  (void)y_src_stride;
  (void)uv_src_stride;

  assert(block_width == MAX_WIDTH && MAX_WIDTH == 32);
  assert(block_height == MAX_HEIGHT && MAX_HEIGHT == 32);
  const BLOCK_SIZE block_size = BLOCK_32X32;
  const int num_planes = 3;
  const int mb_pels = MAX_WIDTH * MAX_HEIGHT;
  const int mb_row = 0;
  const int mb_col = 0;
  const int use_subblock = !(use_32x32);

  YV12_BUFFER_CONFIG *ref_frame =
      (YV12_BUFFER_CONFIG *)malloc(sizeof(YV12_BUFFER_CONFIG));
  ref_frame->strides[0] = y_pre_stride;
  ref_frame->strides[1] = uv_pre_stride;
  const int alloc_size = MAX_MB_PLANE * mb_pels;
  DECLARE_ALIGNED(16, uint16_t, src16[alloc_size]);
  ref_frame->buffer_alloc = CONVERT_TO_BYTEPTR(src16);
  ref_frame->buffers[0] = ref_frame->buffer_alloc + 0 * mb_pels;
  ref_frame->buffers[1] = ref_frame->buffer_alloc + 1 * mb_pels;
  ref_frame->buffers[2] = ref_frame->buffer_alloc + 2 * mb_pels;
  ref_frame->flags = bd_ > 8 ? YV12_FLAG_HIGHBITDEPTH : 0;

  MACROBLOCKD *mbd = (MACROBLOCKD *)malloc(sizeof(MACROBLOCKD));
  mbd->plane[0].subsampling_y = 0;
  mbd->plane[0].subsampling_x = 0;
  mbd->plane[1].subsampling_y = ss_y;
  mbd->plane[1].subsampling_x = ss_x;
  mbd->plane[2].subsampling_y = ss_y;
  mbd->plane[2].subsampling_x = ss_x;

  DECLARE_ALIGNED(16, uint16_t, pred16[alloc_size]);
  DECLARE_ALIGNED(16, uint32_t, accum[alloc_size]);
  DECLARE_ALIGNED(16, uint16_t, count[alloc_size]);
  memcpy(src16 + 0 * mb_pels, y_src, mb_pels * sizeof(uint16_t));
  memcpy(src16 + 1 * mb_pels, u_src, mb_pels * sizeof(uint16_t));
  memcpy(src16 + 2 * mb_pels, v_src, mb_pels * sizeof(uint16_t));
  memcpy(pred16 + 0 * mb_pels, y_pre, mb_pels * sizeof(uint16_t));
  memcpy(pred16 + 1 * mb_pels, u_pre, mb_pels * sizeof(uint16_t));
  memcpy(pred16 + 2 * mb_pels, v_pre, mb_pels * sizeof(uint16_t));
  memcpy(accum + 0 * mb_pels, y_accum, mb_pels * sizeof(uint32_t));
  memcpy(accum + 1 * mb_pels, u_accum, mb_pels * sizeof(uint32_t));
  memcpy(accum + 2 * mb_pels, v_accum, mb_pels * sizeof(uint32_t));
  memcpy(count + 0 * mb_pels, y_count, mb_pels * sizeof(uint16_t));
  memcpy(count + 1 * mb_pels, u_count, mb_pels * sizeof(uint16_t));
  memcpy(count + 2 * mb_pels, v_count, mb_pels * sizeof(uint16_t));
  const uint8_t *pred = CONVERT_TO_BYTEPTR(pred16);

  ASM_REGISTER_STATE_CHECK(
      filter_func_(ref_frame, mbd, block_size, mb_row, mb_col, num_planes,
                   strength, use_subblock, blk_fw, pred, accum, count));

  memcpy(y_accum, accum + 0 * mb_pels, mb_pels * sizeof(uint32_t));
  memcpy(u_accum, accum + 1 * mb_pels, mb_pels * sizeof(uint32_t));
  memcpy(v_accum, accum + 2 * mb_pels, mb_pels * sizeof(uint32_t));
  memcpy(y_count, count + 0 * mb_pels, mb_pels * sizeof(uint16_t));
  memcpy(u_count, count + 1 * mb_pels, mb_pels * sizeof(uint16_t));
  memcpy(v_count, count + 2 * mb_pels, mb_pels * sizeof(uint16_t));

  free(ref_frame);
  free(mbd);
}

template <typename PixelType>
void TemporalFilterYUVTest::CompareTestWithParam(int width, int height,
                                                 int ss_x, int ss_y,
                                                 int filter_strength,
                                                 int use_32x32,
                                                 const int *filter_weight) {
  const int uv_width = width >> ss_x, uv_height = height >> ss_y;
  const int y_stride = width, uv_stride = uv_width;

  DECLARE_ALIGNED(16, PixelType, y_src[MAX_WIDTH * MAX_HEIGHT]) = { 0 };
  DECLARE_ALIGNED(16, PixelType, y_pre[MAX_WIDTH * MAX_HEIGHT]) = { 0 };
  DECLARE_ALIGNED(16, uint16_t, y_count_ref[MAX_WIDTH * MAX_HEIGHT]) = { 0 };
  DECLARE_ALIGNED(16, uint32_t, y_accum_ref[MAX_WIDTH * MAX_HEIGHT]) = { 0 };
  DECLARE_ALIGNED(16, uint16_t, y_count_tst[MAX_WIDTH * MAX_HEIGHT]) = { 0 };
  DECLARE_ALIGNED(16, uint32_t, y_accum_tst[MAX_WIDTH * MAX_HEIGHT]) = { 0 };

  DECLARE_ALIGNED(16, PixelType, u_src[MAX_WIDTH * MAX_HEIGHT]) = { 0 };
  DECLARE_ALIGNED(16, PixelType, u_pre[MAX_WIDTH * MAX_HEIGHT]) = { 0 };
  DECLARE_ALIGNED(16, uint16_t, u_count_ref[MAX_WIDTH * MAX_HEIGHT]) = { 0 };
  DECLARE_ALIGNED(16, uint32_t, u_accum_ref[MAX_WIDTH * MAX_HEIGHT]) = { 0 };
  DECLARE_ALIGNED(16, uint16_t, u_count_tst[MAX_WIDTH * MAX_HEIGHT]) = { 0 };
  DECLARE_ALIGNED(16, uint32_t, u_accum_tst[MAX_WIDTH * MAX_HEIGHT]) = { 0 };

  DECLARE_ALIGNED(16, PixelType, v_src[MAX_WIDTH * MAX_HEIGHT]) = { 0 };
  DECLARE_ALIGNED(16, PixelType, v_pre[MAX_WIDTH * MAX_HEIGHT]) = { 0 };
  DECLARE_ALIGNED(16, uint16_t, v_count_ref[MAX_WIDTH * MAX_HEIGHT]) = { 0 };
  DECLARE_ALIGNED(16, uint32_t, v_accum_ref[MAX_WIDTH * MAX_HEIGHT]) = { 0 };
  DECLARE_ALIGNED(16, uint16_t, v_count_tst[MAX_WIDTH * MAX_HEIGHT]) = { 0 };
  DECLARE_ALIGNED(16, uint32_t, v_accum_tst[MAX_WIDTH * MAX_HEIGHT]) = { 0 };

  for (int repeats = 0; repeats < num_repeats_; repeats++) {
    if (saturate_test_) {
      const int max_val = (1 << bd_) - 1;
      SetArray(y_src, width, height, y_stride, max_val);
      SetArray(y_pre, width, height, y_stride, 0);
      SetArray(u_src, uv_width, uv_height, uv_stride, max_val);
      SetArray(u_pre, uv_width, uv_height, uv_stride, 0);
      SetArray(v_src, uv_width, uv_height, uv_stride, max_val);
      SetArray(v_pre, uv_width, uv_height, uv_stride, 0);
    } else {
      const int max_val = 7 << (bd_ - 8);
      SetArray(y_src, width, height, y_stride, &rnd_, 0, max_val);
      SetArray(y_pre, width, height, y_stride, &rnd_, 0, max_val);
      SetArray(u_src, uv_width, uv_height, uv_stride, &rnd_, 0, max_val);
      SetArray(u_pre, uv_width, uv_height, uv_stride, &rnd_, 0, max_val);
      SetArray(v_src, uv_width, uv_height, uv_stride, &rnd_, 0, max_val);
      SetArray(v_pre, uv_width, uv_height, uv_stride, &rnd_, 0, max_val);
    }

    ApplyReferenceFilter<PixelType>(
        y_src, y_pre, u_src, v_src, u_pre, v_pre, width, height, ss_x, ss_y,
        filter_strength, filter_weight, use_32x32, y_accum_ref, y_count_ref,
        u_accum_ref, u_count_ref, v_accum_ref, v_count_ref);

    ApplyTestFilter(y_src, y_stride, y_pre, y_stride, u_src, v_src, uv_stride,
                    u_pre, v_pre, uv_stride, width, height, ss_x, ss_y,
                    filter_strength, filter_weight, use_32x32, y_accum_tst,
                    y_count_tst, u_accum_tst, u_count_tst, v_accum_tst,
                    v_count_tst);

    EXPECT_TRUE(CheckArrayEqual(y_accum_tst, y_accum_ref, width, height,
                                y_stride, y_stride));
    EXPECT_TRUE(CheckArrayEqual(y_count_tst, y_count_ref, width, height,
                                y_stride, y_stride));
    EXPECT_TRUE(CheckArrayEqual(u_accum_tst, u_accum_ref, uv_width, uv_height,
                                uv_stride, uv_stride));
    EXPECT_TRUE(CheckArrayEqual(u_count_tst, u_count_ref, uv_width, uv_height,
                                uv_stride, uv_stride));
    EXPECT_TRUE(CheckArrayEqual(v_accum_tst, v_accum_ref, uv_width, uv_height,
                                uv_stride, uv_stride));
    EXPECT_TRUE(CheckArrayEqual(v_count_tst, v_count_ref, uv_width, uv_height,
                                uv_stride, uv_stride));

    if (HasFailure()) {
      if (use_32x32) {
        printf("SS_X: %d, SS_Y: %d, Strength: %d, Weight: %d\n", ss_x, ss_y,
               filter_strength, *filter_weight);
      } else {
        printf("SS_X: %d, SS_Y: %d, Strength: %d, Weights: %d,%d,%d,%d\n", ss_x,
               ss_y, filter_strength, filter_weight[0], filter_weight[1],
               filter_weight[2], filter_weight[3]);
      }

      PrintArrayDiff(y_accum_ref, y_accum_tst, width, height, y_stride,
                     y_stride);
      PrintArrayDiff(y_count_ref, y_count_tst, width, height, y_stride,
                     y_stride);
      PrintArrayDiff(u_accum_ref, v_accum_tst, uv_width, uv_height, uv_stride,
                     uv_stride);
      PrintArrayDiff(u_count_ref, v_count_tst, uv_width, uv_height, uv_stride,
                     uv_stride);
      PrintArrayDiff(u_accum_ref, v_accum_tst, uv_width, uv_height, uv_stride,
                     uv_stride);
      PrintArrayDiff(u_count_ref, v_count_tst, uv_width, uv_height, uv_stride,
                     uv_stride);

      return;
    }
  }
}

template <typename PixelType>
void TemporalFilterYUVTest::RunTestFilterWithParam(int width, int height,
                                                   int ss_x, int ss_y,
                                                   int filter_strength,
                                                   int use_32x32,
                                                   const int *filter_weight) {
  PixelType y_src[MAX_WIDTH * MAX_HEIGHT] = { 0 };
  PixelType y_pre[MAX_WIDTH * MAX_HEIGHT] = { 0 };
  uint16_t y_count[MAX_WIDTH * MAX_HEIGHT] = { 0 };
  uint32_t y_accum[MAX_WIDTH * MAX_HEIGHT] = { 0 };

  PixelType u_src[MAX_WIDTH * MAX_HEIGHT] = { 0 };
  PixelType u_pre[MAX_WIDTH * MAX_HEIGHT] = { 0 };
  uint16_t u_count[MAX_WIDTH * MAX_HEIGHT] = { 0 };
  uint32_t u_accum[MAX_WIDTH * MAX_HEIGHT] = { 0 };

  PixelType v_src[MAX_WIDTH * MAX_HEIGHT] = { 0 };
  PixelType v_pre[MAX_WIDTH * MAX_HEIGHT] = { 0 };
  uint16_t v_count[MAX_WIDTH * MAX_HEIGHT] = { 0 };
  uint32_t v_accum[MAX_WIDTH * MAX_HEIGHT] = { 0 };

  SetArray(y_src, width, height, MAX_WIDTH, &rnd_, 0, 7 << (bd_ = 8));
  SetArray(y_pre, width, height, MAX_WIDTH, &rnd_, 0, 7 << (bd_ = 8));
  SetArray(u_src, width, height, MAX_WIDTH, &rnd_, 0, 7 << (bd_ = 8));
  SetArray(u_pre, width, height, MAX_WIDTH, &rnd_, 0, 7 << (bd_ = 8));
  SetArray(v_src, width, height, MAX_WIDTH, &rnd_, 0, 7 << (bd_ = 8));
  SetArray(v_pre, width, height, MAX_WIDTH, &rnd_, 0, 7 << (bd_ = 8));

  for (int repeats = 0; repeats < num_repeats_; repeats++) {
    ApplyTestFilter(y_src, MAX_WIDTH, y_pre, MAX_WIDTH, u_src, v_src, MAX_WIDTH,
                    u_pre, v_pre, MAX_WIDTH, width, height, ss_x, ss_y,
                    filter_strength, filter_weight, use_32x32, y_accum, y_count,
                    u_accum, u_count, v_accum, v_count);
  }
}

TEST_P(TemporalFilterYUVTest, Use32x32) {
  const int width = 32, height = 32;
  const int use_32x32 = 1;

  for (int ss_x = 0; ss_x <= 1; ss_x++) {
    for (int ss_y = 0; ss_y <= 1; ss_y++) {
      for (int filter_strength = 0; filter_strength <= 6;
           filter_strength += 2) {
        for (int filter_weight = 0; filter_weight <= 2; filter_weight++) {
          if (use_highbd_) {
            const int adjusted_strength = filter_strength + 2 * (bd_ - 8);
            CompareTestWithParam<uint16_t>(width, height, ss_x, ss_y,
                                           adjusted_strength, use_32x32,
                                           &filter_weight);
          } else {
            CompareTestWithParam<uint8_t>(width, height, ss_x, ss_y,
                                          filter_strength, use_32x32,
                                          &filter_weight);
          }
          ASSERT_FALSE(HasFailure());
        }
      }
    }
  }
}

TEST_P(TemporalFilterYUVTest, Use16x16) {
  const int width = 32, height = 32;
  const int use_32x32 = 0;

  for (int ss_x = 0; ss_x <= 1; ss_x++) {
    for (int ss_y = 0; ss_y <= 1; ss_y++) {
      for (int filter_idx = 0; filter_idx < 3 * 3 * 3 * 3; filter_idx++) {
        // Set up the filter
        int filter_weight[4];
        int filter_idx_cp = filter_idx;
        for (int idx = 0; idx < 4; idx++) {
          filter_weight[idx] = filter_idx_cp % 3;
          filter_idx_cp /= 3;
        }

        // Test each parameter
        for (int filter_strength = 0; filter_strength <= 6;
             filter_strength += 2) {
          if (use_highbd_) {
            const int adjusted_strength = filter_strength + 2 * (bd_ - 8);
            CompareTestWithParam<uint16_t>(width, height, ss_x, ss_y,
                                           adjusted_strength, use_32x32,
                                           filter_weight);
          } else {
            CompareTestWithParam<uint8_t>(width, height, ss_x, ss_y,
                                          filter_strength, use_32x32,
                                          filter_weight);
          }

          ASSERT_FALSE(HasFailure());
        }
      }
    }
  }
}

TEST_P(TemporalFilterYUVTest, SaturationTest) {
  const int width = 32, height = 32;
  const int use_32x32 = 1;
  const int filter_weight = 1;
  saturate_test_ = 1;

  for (int ss_x = 0; ss_x <= 1; ss_x++) {
    for (int ss_y = 0; ss_y <= 1; ss_y++) {
      for (int filter_strength = 0; filter_strength <= 6;
           filter_strength += 2) {
        if (use_highbd_) {
          const int adjusted_strength = filter_strength + 2 * (bd_ - 8);
          CompareTestWithParam<uint16_t>(width, height, ss_x, ss_y,
                                         adjusted_strength, use_32x32,
                                         &filter_weight);
        } else {
          CompareTestWithParam<uint8_t>(width, height, ss_x, ss_y,
                                        filter_strength, use_32x32,
                                        &filter_weight);
        }

        ASSERT_FALSE(HasFailure());
      }
    }
  }
}

TEST_P(TemporalFilterYUVTest, DISABLED_Speed) {
  const int width = 32, height = 32;
  num_repeats_ = 1000;

  for (int use_32x32 = 0; use_32x32 <= 1; use_32x32++) {
    const int num_filter_weights = use_32x32 ? 3 : 3 * 3 * 3 * 3;
    for (int ss_x = 0; ss_x <= 1; ss_x++) {
      for (int ss_y = 0; ss_y <= 1; ss_y++) {
        for (int filter_idx = 0; filter_idx < num_filter_weights;
             filter_idx++) {
          // Set up the filter
          int filter_weight[4];
          int filter_idx_cp = filter_idx;
          for (int idx = 0; idx < 4; idx++) {
            filter_weight[idx] = filter_idx_cp % 3;
            filter_idx_cp /= 3;
          }

          // Test each parameter
          for (int filter_strength = 0; filter_strength <= 6;
               filter_strength += 2) {
            aom_usec_timer timer;
            aom_usec_timer_start(&timer);

            if (use_highbd_) {
              RunTestFilterWithParam<uint16_t>(width, height, ss_x, ss_y,
                                               filter_strength, use_32x32,
                                               filter_weight);
            } else {
              RunTestFilterWithParam<uint8_t>(width, height, ss_x, ss_y,
                                              filter_strength, use_32x32,
                                              filter_weight);
            }

            aom_usec_timer_mark(&timer);
            const int elapsed_time =
                static_cast<int>(aom_usec_timer_elapsed(&timer));

            printf(
                "Bitdepth: %d, Use 32X32: %d, SS_X: %d, SS_Y: %d, Weight Idx: "
                "%d, Strength: %d, Time: %5d\n",
                bd_, use_32x32, ss_x, ss_y, filter_idx, filter_strength,
                elapsed_time);
          }
        }
      }
    }
  }
}

INSTANTIATE_TEST_SUITE_P(
    C, TemporalFilterYUVTest,
    ::testing::Values(
        TemporalFilterWithBd(&av1_apply_temporal_filter_yuv_c, 8),
        TemporalFilterWithBd(&av1_apply_temporal_filter_yuv_c, 10),
        TemporalFilterWithBd(&av1_apply_temporal_filter_yuv_c, 12)));

#if HAVE_SSE4_1
INSTANTIATE_TEST_SUITE_P(
    SSE4_1, TemporalFilterYUVTest,
    ::testing::Values(
        TemporalFilterWithBd(&av1_apply_temporal_filter_yuv_sse4_1, 8),
        TemporalFilterWithBd(&av1_apply_temporal_filter_yuv_sse4_1, 10),
        TemporalFilterWithBd(&av1_apply_temporal_filter_yuv_sse4_1, 12)));
#endif  // HAVE_SSE4_1

}  // namespace
