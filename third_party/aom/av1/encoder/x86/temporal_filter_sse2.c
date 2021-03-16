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
#include <emmintrin.h>

#include "config/av1_rtcd.h"
#include "av1/encoder/encoder.h"
#include "av1/encoder/temporal_filter.h"

// For the squared error buffer, keep a padding for 4 samples
#define SSE_STRIDE (BW + 4)

DECLARE_ALIGNED(32, static const uint32_t, sse_bytemask_2x4[4][2][4]) = {
  { { 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF },
    { 0xFFFFFFFF, 0x00000000, 0x00000000, 0x00000000 } },
  { { 0x00000000, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF },
    { 0xFFFFFFFF, 0xFFFFFFFF, 0x00000000, 0x00000000 } },
  { { 0x00000000, 0x00000000, 0xFFFFFFFF, 0xFFFFFFFF },
    { 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0x00000000 } },
  { { 0x00000000, 0x00000000, 0x00000000, 0xFFFFFFFF },
    { 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF } }
};

static void get_squared_error(const uint8_t *frame1, const unsigned int stride,
                              const uint8_t *frame2, const unsigned int stride2,
                              const int block_width, const int block_height,
                              uint16_t *frame_sse,
                              const unsigned int dst_stride) {
  const uint8_t *src1 = frame1;
  const uint8_t *src2 = frame2;
  uint16_t *dst = frame_sse;

  for (int i = 0; i < block_height; i++) {
    for (int j = 0; j < block_width; j += 16) {
      // Set zero to uninitialized memory to avoid uninitialized loads later
      *(uint32_t *)(dst) = _mm_cvtsi128_si32(_mm_setzero_si128());

      __m128i vsrc1 = _mm_loadu_si128((__m128i *)(src1 + j));
      __m128i vsrc2 = _mm_loadu_si128((__m128i *)(src2 + j));

      __m128i vmax = _mm_max_epu8(vsrc1, vsrc2);
      __m128i vmin = _mm_min_epu8(vsrc1, vsrc2);
      __m128i vdiff = _mm_subs_epu8(vmax, vmin);

      __m128i vzero = _mm_setzero_si128();
      __m128i vdiff1 = _mm_unpacklo_epi8(vdiff, vzero);
      __m128i vdiff2 = _mm_unpackhi_epi8(vdiff, vzero);

      __m128i vres1 = _mm_mullo_epi16(vdiff1, vdiff1);
      __m128i vres2 = _mm_mullo_epi16(vdiff2, vdiff2);

      _mm_storeu_si128((__m128i *)(dst + j + 2), vres1);
      _mm_storeu_si128((__m128i *)(dst + j + 10), vres2);
    }

    // Set zero to uninitialized memory to avoid uninitialized loads later
    *(uint32_t *)(dst + block_width + 2) =
        _mm_cvtsi128_si32(_mm_setzero_si128());

    src1 += stride;
    src2 += stride2;
    dst += dst_stride;
  }
}

static void xx_load_and_pad(uint16_t *src, __m128i *dstvec, int col,
                            int block_width) {
  __m128i vtmp = _mm_loadu_si128((__m128i *)src);
  __m128i vzero = _mm_setzero_si128();
  __m128i vtmp1 = _mm_unpacklo_epi16(vtmp, vzero);
  __m128i vtmp2 = _mm_unpackhi_epi16(vtmp, vzero);
  // For the first column, replicate the first element twice to the left
  dstvec[0] = (col) ? vtmp1 : _mm_shuffle_epi32(vtmp1, 0xEA);
  // For the last column, replicate the last element twice to the right
  dstvec[1] = (col < block_width - 4) ? vtmp2 : _mm_shuffle_epi32(vtmp2, 0x54);
}

static int32_t xx_mask_and_hadd(__m128i vsum1, __m128i vsum2, int i) {
  __m128i veca, vecb;
  // Mask and obtain the required 5 values inside the vector
  veca = _mm_and_si128(vsum1, *(__m128i *)sse_bytemask_2x4[i][0]);
  vecb = _mm_and_si128(vsum2, *(__m128i *)sse_bytemask_2x4[i][1]);
  // A = [A0+B0, A1+B1, A2+B2, A3+B3]
  veca = _mm_add_epi32(veca, vecb);
  // B = [A2+B2, A3+B3, 0, 0]
  vecb = _mm_srli_si128(veca, 8);
  // A = [A0+B0+A2+B2, A1+B1+A3+B3, X, X]
  veca = _mm_add_epi32(veca, vecb);
  // B = [A1+B1+A3+B3, 0, 0, 0]
  vecb = _mm_srli_si128(veca, 4);
  // A = [A0+B0+A2+B2+A1+B1+A3+B3, X, X, X]
  veca = _mm_add_epi32(veca, vecb);
  return _mm_cvtsi128_si32(veca);
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

  get_squared_error(frame1, stride, frame2, stride2, block_width, block_height,
                    frame_sse, SSE_STRIDE);

  __m128i vsrc[5][2];

  // Traverse 4 columns at a time
  // First and last columns will require padding
  for (int col = 0; col < block_width; col += 4) {
    uint16_t *src = frame_sse + col;

    // Load and pad(for first and last col) 3 rows from the top
    for (int i = 2; i < 5; i++) {
      xx_load_and_pad(src, vsrc[i], col, block_width);
      src += SSE_STRIDE;
    }

    // Padding for top 2 rows
    vsrc[0][0] = vsrc[2][0];
    vsrc[0][1] = vsrc[2][1];
    vsrc[1][0] = vsrc[2][0];
    vsrc[1][1] = vsrc[2][1];

    for (int row = 0; row < block_height; row++) {
      __m128i vsum1 = _mm_setzero_si128();
      __m128i vsum2 = _mm_setzero_si128();

      // Add 5 consecutive rows
      for (int i = 0; i < 5; i++) {
        vsum1 = _mm_add_epi32(vsrc[i][0], vsum1);
        vsum2 = _mm_add_epi32(vsrc[i][1], vsum2);
      }

      // Push all elements by one element to the top
      for (int i = 0; i < 4; i++) {
        vsrc[i][0] = vsrc[i + 1][0];
        vsrc[i][1] = vsrc[i + 1][1];
      }

      if (row <= block_height - 4) {
        // Load next row
        xx_load_and_pad(src, vsrc[4], col, block_width);
        src += SSE_STRIDE;
      } else {
        // Padding for bottom 2 rows
        vsrc[4][0] = vsrc[3][0];
        vsrc[4][1] = vsrc[3][1];
      }

      // Accumulate the sum horizontally
      for (int i = 0; i < 4; i++) {
        acc_5x5_sse[row][col + i] = xx_mask_and_hadd(vsum1, vsum2, i);
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
            const int yy = (i << ss_y_shift) + ii;      // Y-coord on Y-plane.
            const int xx = (j << ss_x_shift) + jj + 2;  // X-coord on Y-plane.
            const int ww = SSE_STRIDE;                  // Stride of Y-plane.
            diff_sse += luma_sq_error[yy * ww + xx];
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

void av1_apply_temporal_filter_planewise_sse2(
    const YV12_BUFFER_CONFIG *ref_frame, const MACROBLOCKD *mbd,
    const BLOCK_SIZE block_size, const int mb_row, const int mb_col,
    const int num_planes, const double *noise_levels, const int use_subblock,
    const int block_mse, const int *subblock_mses, const int q_factor,
    const uint8_t *pred, uint32_t *accum, uint16_t *count) {
  const int is_high_bitdepth = ref_frame->flags & YV12_FLAG_HIGHBITDEPTH;
  if (is_high_bitdepth) {
    assert(0 && "Only support low bit-depth with sse2!");
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
