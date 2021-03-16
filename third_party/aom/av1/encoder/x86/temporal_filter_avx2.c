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

#include <assert.h>
#include <immintrin.h>

#include "config/av1_rtcd.h"
#include "av1/encoder/encoder.h"
#include "av1/encoder/temporal_filter.h"

#define SSE_STRIDE (BW + 2)

DECLARE_ALIGNED(32, static const uint32_t, sse_bytemask[4][8]) = {
  { 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0, 0, 0 },
  { 0, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0, 0 },
  { 0, 0, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0 },
  { 0, 0, 0, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF }
};

DECLARE_ALIGNED(32, static const uint8_t, shufflemask_16b[2][16]) = {
  { 0, 1, 0, 1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
  { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 10, 11, 10, 11 }
};

static AOM_FORCE_INLINE void get_squared_error_16x16_avx2(
    const uint8_t *frame1, const unsigned int stride, const uint8_t *frame2,
    const unsigned int stride2, const int block_width, const int block_height,
    uint16_t *frame_sse, const unsigned int sse_stride) {
  (void)block_width;
  const uint8_t *src1 = frame1;
  const uint8_t *src2 = frame2;
  uint16_t *dst = frame_sse;
  for (int i = 0; i < block_height; i++) {
    __m128i vf1_128, vf2_128;
    __m256i vf1, vf2, vdiff1, vsqdiff1;

    vf1_128 = _mm_loadu_si128((__m128i *)(src1));
    vf2_128 = _mm_loadu_si128((__m128i *)(src2));
    vf1 = _mm256_cvtepu8_epi16(vf1_128);
    vf2 = _mm256_cvtepu8_epi16(vf2_128);
    vdiff1 = _mm256_sub_epi16(vf1, vf2);
    vsqdiff1 = _mm256_mullo_epi16(vdiff1, vdiff1);

    _mm256_storeu_si256((__m256i *)(dst), vsqdiff1);
    // Set zero to uninitialized memory to avoid uninitialized loads later
    *(uint32_t *)(dst + 16) = _mm_cvtsi128_si32(_mm_setzero_si128());

    src1 += stride, src2 += stride2;
    dst += sse_stride;
  }
}

static AOM_FORCE_INLINE void get_squared_error_32x32_avx2(
    const uint8_t *frame1, const unsigned int stride, const uint8_t *frame2,
    const unsigned int stride2, const int block_width, const int block_height,
    uint16_t *frame_sse, const unsigned int sse_stride) {
  (void)block_width;
  const uint8_t *src1 = frame1;
  const uint8_t *src2 = frame2;
  uint16_t *dst = frame_sse;
  for (int i = 0; i < block_height; i++) {
    __m256i vsrc1, vsrc2, vmin, vmax, vdiff, vdiff1, vdiff2, vres1, vres2;

    vsrc1 = _mm256_loadu_si256((__m256i *)src1);
    vsrc2 = _mm256_loadu_si256((__m256i *)src2);
    vmax = _mm256_max_epu8(vsrc1, vsrc2);
    vmin = _mm256_min_epu8(vsrc1, vsrc2);
    vdiff = _mm256_subs_epu8(vmax, vmin);

    __m128i vtmp1 = _mm256_castsi256_si128(vdiff);
    __m128i vtmp2 = _mm256_extracti128_si256(vdiff, 1);
    vdiff1 = _mm256_cvtepu8_epi16(vtmp1);
    vdiff2 = _mm256_cvtepu8_epi16(vtmp2);

    vres1 = _mm256_mullo_epi16(vdiff1, vdiff1);
    vres2 = _mm256_mullo_epi16(vdiff2, vdiff2);
    _mm256_storeu_si256((__m256i *)(dst), vres1);
    _mm256_storeu_si256((__m256i *)(dst + 16), vres2);
    // Set zero to uninitialized memory to avoid uninitialized loads later
    *(uint32_t *)(dst + 32) = _mm_cvtsi128_si32(_mm_setzero_si128());

    src1 += stride;
    src2 += stride2;
    dst += sse_stride;
  }
}

static AOM_FORCE_INLINE __m256i xx_load_and_pad(uint16_t *src, int col,
                                                int block_width) {
  __m128i v128tmp = _mm_loadu_si128((__m128i *)(src));
  if (col == 0) {
    // For the first column, replicate the first element twice to the left
    v128tmp = _mm_shuffle_epi8(v128tmp, *(__m128i *)shufflemask_16b[0]);
  }
  if (col == block_width - 4) {
    // For the last column, replicate the last element twice to the right
    v128tmp = _mm_shuffle_epi8(v128tmp, *(__m128i *)shufflemask_16b[1]);
  }
  return _mm256_cvtepu16_epi32(v128tmp);
}

static AOM_FORCE_INLINE int32_t xx_mask_and_hadd(__m256i vsum, int i) {
  // Mask the required 5 values inside the vector
  __m256i vtmp = _mm256_and_si256(vsum, *(__m256i *)sse_bytemask[i]);
  __m128i v128a, v128b;
  // Extract 256b as two 128b registers A and B
  v128a = _mm256_castsi256_si128(vtmp);
  v128b = _mm256_extracti128_si256(vtmp, 1);
  // A = [A0+B0, A1+B1, A2+B2, A3+B3]
  v128a = _mm_add_epi32(v128a, v128b);
  // B = [A2+B2, A3+B3, 0, 0]
  v128b = _mm_srli_si128(v128a, 8);
  // A = [A0+B0+A2+B2, A1+B1+A3+B3, X, X]
  v128a = _mm_add_epi32(v128a, v128b);
  // B = [A1+B1+A3+B3, 0, 0, 0]
  v128b = _mm_srli_si128(v128a, 4);
  // A = [A0+B0+A2+B2+A1+B1+A3+B3, X, X, X]
  v128a = _mm_add_epi32(v128a, v128b);
  return _mm_extract_epi32(v128a, 0);
}

static void apply_temporal_filter_planewise(
    const uint8_t *frame1, const unsigned int stride, const uint8_t *frame2,
    const unsigned int stride2, const int block_width, const int block_height,
    const double sigma, const int decay_control, const int use_subblock,
    const int block_mse, const int *subblock_mses, const int q_factor,
    unsigned int *accumulator, uint16_t *count, uint16_t *luma_sq_error,
    uint16_t *chroma_sq_error, int plane, int ss_x_shift, int ss_y_shift) {
  assert(TF_PLANEWISE_FILTER_WINDOW_LENGTH == 5);
  assert(((block_width == 16) || (block_width == 32)) &&
         ((block_height == 16) || (block_height == 32)));
  if (plane > PLANE_TYPE_Y) assert(chroma_sq_error != NULL);

  uint32_t acc_5x5_sse[BH][BW];
  const double h = decay_control * (0.7 + log(sigma + 1.0));
  const double q = AOMMIN((double)(q_factor * q_factor) / 256.0, 1);
  uint16_t *frame_sse =
      (plane == PLANE_TYPE_Y) ? luma_sq_error : chroma_sq_error;

  if (block_width == 32) {
    get_squared_error_32x32_avx2(frame1, stride, frame2, stride2, block_width,
                                 block_height, frame_sse, SSE_STRIDE);
  } else {
    get_squared_error_16x16_avx2(frame1, stride, frame2, stride2, block_width,
                                 block_height, frame_sse, SSE_STRIDE);
  }

  __m256i vsrc[5];

  // Traverse 4 columns at a time
  // First and last columns will require padding
  for (int col = 0; col < block_width; col += 4) {
    uint16_t *src = (col) ? frame_sse + col - 2 : frame_sse;

    // Load and pad(for first and last col) 3 rows from the top
    for (int i = 2; i < 5; i++) {
      vsrc[i] = xx_load_and_pad(src, col, block_width);
      src += SSE_STRIDE;
    }

    // Copy first row to first 2 vectors
    vsrc[0] = vsrc[2];
    vsrc[1] = vsrc[2];

    for (int row = 0; row < block_height; row++) {
      __m256i vsum = _mm256_setzero_si256();

      // Add 5 consecutive rows
      for (int i = 0; i < 5; i++) {
        vsum = _mm256_add_epi32(vsum, vsrc[i]);
      }

      // Push all elements by one element to the top
      for (int i = 0; i < 4; i++) {
        vsrc[i] = vsrc[i + 1];
      }

      // Load next row to the last element
      if (row <= block_height - 4) {
        vsrc[4] = xx_load_and_pad(src, col, block_width);
        src += SSE_STRIDE;
      } else {
        vsrc[4] = vsrc[3];
      }

      // Accumulate the sum horizontally
      for (int i = 0; i < 4; i++) {
        acc_5x5_sse[row][col + i] = xx_mask_and_hadd(vsum, i);
      }
    }
  }

  for (int i = 0, k = 0; i < block_height; i++) {
    for (int j = 0; j < block_width; j++, k++) {
      const int pixel_value = frame2[i * stride2 + j];

      int diff_sse = acc_5x5_sse[i][j];
      int num_ref_pixels =
          TF_PLANEWISE_FILTER_WINDOW_LENGTH * TF_PLANEWISE_FILTER_WINDOW_LENGTH;

      // Filter U-plane and V-plane using Y-plane. This is because motion
      // search is only done on Y-plane, so the information from Y-plane will
      // be more accurate.
      if (plane != PLANE_TYPE_Y) {
        for (int ii = 0; ii < (1 << ss_y_shift); ++ii) {
          for (int jj = 0; jj < (1 << ss_x_shift); ++jj) {
            const int yy = (i << ss_y_shift) + ii;  // Y-coord on Y-plane.
            const int xx = (j << ss_x_shift) + jj;  // X-coord on Y-plane.
            diff_sse += luma_sq_error[yy * SSE_STRIDE + xx];
            ++num_ref_pixels;
          }
        }
      }

      const double window_error = (double)(diff_sse) / num_ref_pixels;
      const int subblock_idx =
          (i >= block_height / 2) * 2 + (j >= block_width / 2);
      const double block_error =
          (double)(use_subblock ? subblock_mses[subblock_idx] : block_mse);

      const double scaled_diff =
          AOMMAX(-(window_error + block_error / 10) / (2 * h * h * q), -15.0);
      const int adjusted_weight =
          (int)(exp(scaled_diff) * TF_PLANEWISE_FILTER_WEIGHT_SCALE);

      count[k] += adjusted_weight;
      accumulator[k] += adjusted_weight * pixel_value;
    }
  }
}

void av1_apply_temporal_filter_planewise_avx2(
    const YV12_BUFFER_CONFIG *ref_frame, const MACROBLOCKD *mbd,
    const BLOCK_SIZE block_size, const int mb_row, const int mb_col,
    const int num_planes, const double *noise_levels, const int use_subblock,
    const int block_mse, const int *subblock_mses, const int q_factor,
    const uint8_t *pred, uint32_t *accum, uint16_t *count) {
  const int is_high_bitdepth = ref_frame->flags & YV12_FLAG_HIGHBITDEPTH;
  if (is_high_bitdepth) {
    assert(0 && "Only support low bit-depth with avx2!");
  }
  assert(num_planes >= 1 && num_planes <= MAX_MB_PLANE);

  const int frame_height = ref_frame->heights[0] << mbd->plane[0].subsampling_y;
  const int decay_control = frame_height >= 720 ? 4 : 3;

  const int mb_height = block_size_high[block_size];
  const int mb_width = block_size_wide[block_size];
  const int mb_pels = mb_height * mb_width;
  uint16_t luma_sq_error[SSE_STRIDE * BH];
  uint16_t *chroma_sq_error =
      (num_planes > 0)
          ? (uint16_t *)aom_malloc(SSE_STRIDE * BH * sizeof(uint16_t))
          : NULL;

  for (int plane = 0; plane < num_planes; ++plane) {
    const uint32_t plane_h = mb_height >> mbd->plane[plane].subsampling_y;
    const uint32_t plane_w = mb_width >> mbd->plane[plane].subsampling_x;
    const uint32_t frame_stride = ref_frame->strides[plane == 0 ? 0 : 1];
    const int frame_offset = mb_row * plane_h * frame_stride + mb_col * plane_w;

    const uint8_t *ref = ref_frame->buffers[plane] + frame_offset;
    const int ss_x_shift =
        mbd->plane[plane].subsampling_x - mbd->plane[0].subsampling_x;
    const int ss_y_shift =
        mbd->plane[plane].subsampling_y - mbd->plane[0].subsampling_y;

    apply_temporal_filter_planewise(
        ref, frame_stride, pred + mb_pels * plane, plane_w, plane_w, plane_h,
        noise_levels[plane], decay_control, use_subblock, block_mse,
        subblock_mses, q_factor, accum + mb_pels * plane,
        count + mb_pels * plane, luma_sq_error, chroma_sq_error, plane,
        ss_x_shift, ss_y_shift);
  }
  if (chroma_sq_error != NULL) aom_free(chroma_sq_error);
}
