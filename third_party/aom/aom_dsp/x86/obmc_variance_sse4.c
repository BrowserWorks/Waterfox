/*
 * Copyright (c) 2016, Alliance for Open Media. All rights reserved
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

#include "./aom_config.h"
#include "aom_ports/mem.h"
#include "aom/aom_integer.h"

#include "aom_dsp/aom_dsp_common.h"
#include "aom_dsp/aom_filter.h"
#include "aom_dsp/x86/obmc_intrinsic_ssse3.h"
#include "aom_dsp/x86/synonyms.h"

////////////////////////////////////////////////////////////////////////////////
// 8 bit
////////////////////////////////////////////////////////////////////////////////

static INLINE void obmc_variance_w4(const uint8_t *pre, const int pre_stride,
                                    const int32_t *wsrc, const int32_t *mask,
                                    unsigned int *const sse, int *const sum,
                                    const int h) {
  const int pre_step = pre_stride - 4;
  int n = 0;
  __m128i v_sum_d = _mm_setzero_si128();
  __m128i v_sse_d = _mm_setzero_si128();

  assert(IS_POWER_OF_TWO(h));

  do {
    const __m128i v_p_b = xx_loadl_32(pre + n);
    const __m128i v_m_d = xx_load_128(mask + n);
    const __m128i v_w_d = xx_load_128(wsrc + n);

    const __m128i v_p_d = _mm_cvtepu8_epi32(v_p_b);

    // Values in both pre and mask fit in 15 bits, and are packed at 32 bit
    // boundaries. We use pmaddwd, as it has lower latency on Haswell
    // than pmulld but produces the same result with these inputs.
    const __m128i v_pm_d = _mm_madd_epi16(v_p_d, v_m_d);

    const __m128i v_diff_d = _mm_sub_epi32(v_w_d, v_pm_d);
    const __m128i v_rdiff_d = xx_roundn_epi32(v_diff_d, 12);
    const __m128i v_sqrdiff_d = _mm_mullo_epi32(v_rdiff_d, v_rdiff_d);

    v_sum_d = _mm_add_epi32(v_sum_d, v_rdiff_d);
    v_sse_d = _mm_add_epi32(v_sse_d, v_sqrdiff_d);

    n += 4;

    if (n % 4 == 0) pre += pre_step;
  } while (n < 4 * h);

  *sum = xx_hsum_epi32_si32(v_sum_d);
  *sse = xx_hsum_epi32_si32(v_sse_d);
}

static INLINE void obmc_variance_w8n(const uint8_t *pre, const int pre_stride,
                                     const int32_t *wsrc, const int32_t *mask,
                                     unsigned int *const sse, int *const sum,
                                     const int w, const int h) {
  const int pre_step = pre_stride - w;
  int n = 0;
  __m128i v_sum_d = _mm_setzero_si128();
  __m128i v_sse_d = _mm_setzero_si128();

  assert(w >= 8);
  assert(IS_POWER_OF_TWO(w));
  assert(IS_POWER_OF_TWO(h));

  do {
    const __m128i v_p1_b = xx_loadl_32(pre + n + 4);
    const __m128i v_m1_d = xx_load_128(mask + n + 4);
    const __m128i v_w1_d = xx_load_128(wsrc + n + 4);
    const __m128i v_p0_b = xx_loadl_32(pre + n);
    const __m128i v_m0_d = xx_load_128(mask + n);
    const __m128i v_w0_d = xx_load_128(wsrc + n);

    const __m128i v_p0_d = _mm_cvtepu8_epi32(v_p0_b);
    const __m128i v_p1_d = _mm_cvtepu8_epi32(v_p1_b);

    // Values in both pre and mask fit in 15 bits, and are packed at 32 bit
    // boundaries. We use pmaddwd, as it has lower latency on Haswell
    // than pmulld but produces the same result with these inputs.
    const __m128i v_pm0_d = _mm_madd_epi16(v_p0_d, v_m0_d);
    const __m128i v_pm1_d = _mm_madd_epi16(v_p1_d, v_m1_d);

    const __m128i v_diff0_d = _mm_sub_epi32(v_w0_d, v_pm0_d);
    const __m128i v_diff1_d = _mm_sub_epi32(v_w1_d, v_pm1_d);

    const __m128i v_rdiff0_d = xx_roundn_epi32(v_diff0_d, 12);
    const __m128i v_rdiff1_d = xx_roundn_epi32(v_diff1_d, 12);
    const __m128i v_rdiff01_w = _mm_packs_epi32(v_rdiff0_d, v_rdiff1_d);
    const __m128i v_sqrdiff_d = _mm_madd_epi16(v_rdiff01_w, v_rdiff01_w);

    v_sum_d = _mm_add_epi32(v_sum_d, v_rdiff0_d);
    v_sum_d = _mm_add_epi32(v_sum_d, v_rdiff1_d);
    v_sse_d = _mm_add_epi32(v_sse_d, v_sqrdiff_d);

    n += 8;

    if (n % w == 0) pre += pre_step;
  } while (n < w * h);

  *sum = xx_hsum_epi32_si32(v_sum_d);
  *sse = xx_hsum_epi32_si32(v_sse_d);
}

#define OBMCVARWXH(W, H)                                               \
  unsigned int aom_obmc_variance##W##x##H##_sse4_1(                    \
      const uint8_t *pre, int pre_stride, const int32_t *wsrc,         \
      const int32_t *mask, unsigned int *sse) {                        \
    int sum;                                                           \
    if (W == 4) {                                                      \
      obmc_variance_w4(pre, pre_stride, wsrc, mask, sse, &sum, H);     \
    } else {                                                           \
      obmc_variance_w8n(pre, pre_stride, wsrc, mask, sse, &sum, W, H); \
    }                                                                  \
    return *sse - (unsigned int)(((int64_t)sum * sum) / (W * H));      \
  }

#if CONFIG_EXT_PARTITION
OBMCVARWXH(128, 128)
OBMCVARWXH(128, 64)
OBMCVARWXH(64, 128)
#endif  // CONFIG_EXT_PARTITION
OBMCVARWXH(64, 64)
OBMCVARWXH(64, 32)
OBMCVARWXH(32, 64)
OBMCVARWXH(32, 32)
OBMCVARWXH(32, 16)
OBMCVARWXH(16, 32)
OBMCVARWXH(16, 16)
OBMCVARWXH(16, 8)
OBMCVARWXH(8, 16)
OBMCVARWXH(8, 8)
OBMCVARWXH(8, 4)
OBMCVARWXH(4, 8)
OBMCVARWXH(4, 4)

////////////////////////////////////////////////////////////////////////////////
// High bit-depth
////////////////////////////////////////////////////////////////////////////////

#if CONFIG_HIGHBITDEPTH
static INLINE void hbd_obmc_variance_w4(
    const uint8_t *pre8, const int pre_stride, const int32_t *wsrc,
    const int32_t *mask, uint64_t *const sse, int64_t *const sum, const int h) {
  const uint16_t *pre = CONVERT_TO_SHORTPTR(pre8);
  const int pre_step = pre_stride - 4;
  int n = 0;
  __m128i v_sum_d = _mm_setzero_si128();
  __m128i v_sse_d = _mm_setzero_si128();

  assert(IS_POWER_OF_TWO(h));

  do {
    const __m128i v_p_w = xx_loadl_64(pre + n);
    const __m128i v_m_d = xx_load_128(mask + n);
    const __m128i v_w_d = xx_load_128(wsrc + n);

    const __m128i v_p_d = _mm_cvtepu16_epi32(v_p_w);

    // Values in both pre and mask fit in 15 bits, and are packed at 32 bit
    // boundaries. We use pmaddwd, as it has lower latency on Haswell
    // than pmulld but produces the same result with these inputs.
    const __m128i v_pm_d = _mm_madd_epi16(v_p_d, v_m_d);

    const __m128i v_diff_d = _mm_sub_epi32(v_w_d, v_pm_d);
    const __m128i v_rdiff_d = xx_roundn_epi32(v_diff_d, 12);
    const __m128i v_sqrdiff_d = _mm_mullo_epi32(v_rdiff_d, v_rdiff_d);

    v_sum_d = _mm_add_epi32(v_sum_d, v_rdiff_d);
    v_sse_d = _mm_add_epi32(v_sse_d, v_sqrdiff_d);

    n += 4;

    if (n % 4 == 0) pre += pre_step;
  } while (n < 4 * h);

  *sum = xx_hsum_epi32_si32(v_sum_d);
  *sse = xx_hsum_epi32_si32(v_sse_d);
}

static INLINE void hbd_obmc_variance_w8n(
    const uint8_t *pre8, const int pre_stride, const int32_t *wsrc,
    const int32_t *mask, uint64_t *const sse, int64_t *const sum, const int w,
    const int h) {
  const uint16_t *pre = CONVERT_TO_SHORTPTR(pre8);
  const int pre_step = pre_stride - w;
  int n = 0;
  __m128i v_sum_d = _mm_setzero_si128();
  __m128i v_sse_d = _mm_setzero_si128();

  assert(w >= 8);
  assert(IS_POWER_OF_TWO(w));
  assert(IS_POWER_OF_TWO(h));

  do {
    const __m128i v_p1_w = xx_loadl_64(pre + n + 4);
    const __m128i v_m1_d = xx_load_128(mask + n + 4);
    const __m128i v_w1_d = xx_load_128(wsrc + n + 4);
    const __m128i v_p0_w = xx_loadl_64(pre + n);
    const __m128i v_m0_d = xx_load_128(mask + n);
    const __m128i v_w0_d = xx_load_128(wsrc + n);

    const __m128i v_p0_d = _mm_cvtepu16_epi32(v_p0_w);
    const __m128i v_p1_d = _mm_cvtepu16_epi32(v_p1_w);

    // Values in both pre and mask fit in 15 bits, and are packed at 32 bit
    // boundaries. We use pmaddwd, as it has lower latency on Haswell
    // than pmulld but produces the same result with these inputs.
    const __m128i v_pm0_d = _mm_madd_epi16(v_p0_d, v_m0_d);
    const __m128i v_pm1_d = _mm_madd_epi16(v_p1_d, v_m1_d);

    const __m128i v_diff0_d = _mm_sub_epi32(v_w0_d, v_pm0_d);
    const __m128i v_diff1_d = _mm_sub_epi32(v_w1_d, v_pm1_d);

    const __m128i v_rdiff0_d = xx_roundn_epi32(v_diff0_d, 12);
    const __m128i v_rdiff1_d = xx_roundn_epi32(v_diff1_d, 12);
    const __m128i v_rdiff01_w = _mm_packs_epi32(v_rdiff0_d, v_rdiff1_d);
    const __m128i v_sqrdiff_d = _mm_madd_epi16(v_rdiff01_w, v_rdiff01_w);

    v_sum_d = _mm_add_epi32(v_sum_d, v_rdiff0_d);
    v_sum_d = _mm_add_epi32(v_sum_d, v_rdiff1_d);
    v_sse_d = _mm_add_epi32(v_sse_d, v_sqrdiff_d);

    n += 8;

    if (n % w == 0) pre += pre_step;
  } while (n < w * h);

  *sum += xx_hsum_epi32_si64(v_sum_d);
  *sse += xx_hsum_epi32_si64(v_sse_d);
}

static INLINE void highbd_obmc_variance(const uint8_t *pre8, int pre_stride,
                                        const int32_t *wsrc,
                                        const int32_t *mask, int w, int h,
                                        unsigned int *sse, int *sum) {
  int64_t sum64 = 0;
  uint64_t sse64 = 0;
  if (w == 4) {
    hbd_obmc_variance_w4(pre8, pre_stride, wsrc, mask, &sse64, &sum64, h);
  } else {
    hbd_obmc_variance_w8n(pre8, pre_stride, wsrc, mask, &sse64, &sum64, w, h);
  }
  *sum = (int)sum64;
  *sse = (unsigned int)sse64;
}

static INLINE void highbd_10_obmc_variance(const uint8_t *pre8, int pre_stride,
                                           const int32_t *wsrc,
                                           const int32_t *mask, int w, int h,
                                           unsigned int *sse, int *sum) {
  int64_t sum64 = 0;
  uint64_t sse64 = 0;
  if (w == 4) {
    hbd_obmc_variance_w4(pre8, pre_stride, wsrc, mask, &sse64, &sum64, h);
  } else {
    hbd_obmc_variance_w8n(pre8, pre_stride, wsrc, mask, &sse64, &sum64, w, h);
  }
  *sum = (int)ROUND_POWER_OF_TWO(sum64, 2);
  *sse = (unsigned int)ROUND_POWER_OF_TWO(sse64, 4);
}

static INLINE void highbd_12_obmc_variance(const uint8_t *pre8, int pre_stride,
                                           const int32_t *wsrc,
                                           const int32_t *mask, int w, int h,
                                           unsigned int *sse, int *sum) {
  int64_t sum64 = 0;
  uint64_t sse64 = 0;
  if (w == 128) {
    do {
      hbd_obmc_variance_w8n(pre8, pre_stride, wsrc, mask, &sse64, &sum64, 128,
                            32);
      pre8 += 32 * pre_stride;
      wsrc += 32 * 128;
      mask += 32 * 128;
      h -= 32;
    } while (h > 0);
  } else if (w == 64 && h >= 128) {
    do {
      hbd_obmc_variance_w8n(pre8, pre_stride, wsrc, mask, &sse64, &sum64, 64,
                            64);
      pre8 += 64 * pre_stride;
      wsrc += 64 * 64;
      mask += 64 * 64;
      h -= 64;
    } while (h > 0);
  } else if (w == 4) {
    hbd_obmc_variance_w4(pre8, pre_stride, wsrc, mask, &sse64, &sum64, h);
  } else {
    hbd_obmc_variance_w8n(pre8, pre_stride, wsrc, mask, &sse64, &sum64, w, h);
  }
  *sum = (int)ROUND_POWER_OF_TWO(sum64, 4);
  *sse = (unsigned int)ROUND_POWER_OF_TWO(sse64, 8);
}

#define HBD_OBMCVARWXH(W, H)                                               \
  unsigned int aom_highbd_obmc_variance##W##x##H##_sse4_1(                 \
      const uint8_t *pre, int pre_stride, const int32_t *wsrc,             \
      const int32_t *mask, unsigned int *sse) {                            \
    int sum;                                                               \
    highbd_obmc_variance(pre, pre_stride, wsrc, mask, W, H, sse, &sum);    \
    return *sse - (unsigned int)(((int64_t)sum * sum) / (W * H));          \
  }                                                                        \
                                                                           \
  unsigned int aom_highbd_10_obmc_variance##W##x##H##_sse4_1(              \
      const uint8_t *pre, int pre_stride, const int32_t *wsrc,             \
      const int32_t *mask, unsigned int *sse) {                            \
    int sum;                                                               \
    int64_t var;                                                           \
    highbd_10_obmc_variance(pre, pre_stride, wsrc, mask, W, H, sse, &sum); \
    var = (int64_t)(*sse) - (((int64_t)sum * sum) / (W * H));              \
    return (var >= 0) ? (uint32_t)var : 0;                                 \
  }                                                                        \
                                                                           \
  unsigned int aom_highbd_12_obmc_variance##W##x##H##_sse4_1(              \
      const uint8_t *pre, int pre_stride, const int32_t *wsrc,             \
      const int32_t *mask, unsigned int *sse) {                            \
    int sum;                                                               \
    int64_t var;                                                           \
    highbd_12_obmc_variance(pre, pre_stride, wsrc, mask, W, H, sse, &sum); \
    var = (int64_t)(*sse) - (((int64_t)sum * sum) / (W * H));              \
    return (var >= 0) ? (uint32_t)var : 0;                                 \
  }

#if CONFIG_EXT_PARTITION
HBD_OBMCVARWXH(128, 128)
HBD_OBMCVARWXH(128, 64)
HBD_OBMCVARWXH(64, 128)
#endif  // CONFIG_EXT_PARTITION
HBD_OBMCVARWXH(64, 64)
HBD_OBMCVARWXH(64, 32)
HBD_OBMCVARWXH(32, 64)
HBD_OBMCVARWXH(32, 32)
HBD_OBMCVARWXH(32, 16)
HBD_OBMCVARWXH(16, 32)
HBD_OBMCVARWXH(16, 16)
HBD_OBMCVARWXH(16, 8)
HBD_OBMCVARWXH(8, 16)
HBD_OBMCVARWXH(8, 8)
HBD_OBMCVARWXH(8, 4)
HBD_OBMCVARWXH(4, 8)
HBD_OBMCVARWXH(4, 4)
#endif  // CONFIG_HIGHBITDEPTH
