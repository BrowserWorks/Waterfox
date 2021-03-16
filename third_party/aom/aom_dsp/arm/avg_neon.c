/*
 *  Copyright (c) 2019, Alliance for Open Media. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include <arm_neon.h>

#include "config/aom_dsp_rtcd.h"
#include "aom/aom_integer.h"
#include "aom_dsp/arm/sum_neon.h"
#include "av1/common/arm/mem_neon.h"
#include "av1/common/arm/transpose_neon.h"

unsigned int aom_avg_4x4_neon(const uint8_t *a, int a_stride) {
  const uint8x16_t b = load_unaligned_u8q(a, a_stride);
  const uint16x8_t c = vaddl_u8(vget_low_u8(b), vget_high_u8(b));
#if defined(__aarch64__)
  const uint32_t d = vaddlvq_u16(c);
  return (d + 8) >> 4;
#else
  const uint32x2_t d = horizontal_add_u16x8(c);
  return vget_lane_u32(vrshr_n_u32(d, 4), 0);
#endif
}

unsigned int aom_avg_8x8_neon(const uint8_t *a, int a_stride) {
  uint16x8_t sum;
  uint32x2_t d;
  uint8x8_t b = vld1_u8(a);
  a += a_stride;
  uint8x8_t c = vld1_u8(a);
  a += a_stride;
  sum = vaddl_u8(b, c);

  for (int i = 0; i < 6; ++i) {
    const uint8x8_t e = vld1_u8(a);
    a += a_stride;
    sum = vaddw_u8(sum, e);
  }

  d = horizontal_add_u16x8(sum);

  return vget_lane_u32(vrshr_n_u32(d, 6), 0);
}

int aom_satd_lp_neon(const int16_t *coeff, int length) {
  const int16x4_t zero = vdup_n_s16(0);
  int32x4_t accum = vdupq_n_s32(0);

  do {
    const int16x8_t src0 = vld1q_s16(coeff);
    const int16x8_t src8 = vld1q_s16(coeff + 8);
    accum = vabal_s16(accum, vget_low_s16(src0), zero);
    accum = vabal_s16(accum, vget_high_s16(src0), zero);
    accum = vabal_s16(accum, vget_low_s16(src8), zero);
    accum = vabal_s16(accum, vget_high_s16(src8), zero);
    length -= 16;
    coeff += 16;
  } while (length != 0);

  {
    // satd: 26 bits, dynamic range [-32640 * 1024, 32640 * 1024]
    const int64x2_t s0 = vpaddlq_s32(accum);  // cascading summation of 'accum'.
    const int32x2_t s1 = vadd_s32(vreinterpret_s32_s64(vget_low_s64(s0)),
                                  vreinterpret_s32_s64(vget_high_s64(s0)));
    const int satd = vget_lane_s32(s1, 0);
    return satd;
  }
}
