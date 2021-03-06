/*
 *  Copyright (c) 2020, Alliance for Open Media. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include <arm_neon.h>
#include "config/aom_config.h"
#include "config/aom_dsp_rtcd.h"

#include "aom/aom_integer.h"

static INLINE uint32_t sse_W16x1_neon(uint8x16_t q2, uint8x16_t q3) {
  const uint16_t sse1 = 0;
  const uint16x8_t q1 = vld1q_dup_u16(&sse1);

  uint32_t sse;

  uint8x16_t q4 = vabdq_u8(q2, q3);  // diff = abs(a[x] - b[x])
  uint8x8_t d0 = vget_low_u8(q4);
  uint8x8_t d1 = vget_high_u8(q4);

  uint16x8_t q6 = vmlal_u8(q1, d0, d0);
  uint16x8_t q7 = vmlal_u8(q1, d1, d1);

  uint32x4_t q8 = vaddl_u16(vget_low_u16(q6), vget_high_u16(q6));
  uint32x4_t q9 = vaddl_u16(vget_low_u16(q7), vget_high_u16(q7));

  uint32x2_t d4 = vadd_u32(vget_low_u32(q8), vget_high_u32(q8));
  uint32x2_t d5 = vadd_u32(vget_low_u32(q9), vget_high_u32(q9));

  uint32x2_t d6 = vadd_u32(d4, d5);

  sse = vget_lane_u32(d6, 0);
  sse += vget_lane_u32(d6, 1);

  return sse;
}

int64_t aom_sse_neon(const uint8_t *a, int a_stride, const uint8_t *b,
                     int b_stride, int width, int height) {
  const uint8x16_t q0 = {
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
  };
  int addinc, x, y;
  uint8x8_t d0, d1, d2, d3;
  uint8_t dx;
  uint8x16_t q2, q3, q4, q5;
  uint32_t sse = 0;
  uint8x8x2_t tmp, tmp2;

  switch (width) {
    case 4:
      for (y = 0; y < height; y += 4) {
        d0 = vld1_u8(a);  // load 4 data
        a += a_stride;
        d1 = vld1_u8(a);
        a += a_stride;
        d2 = vld1_u8(a);
        a += a_stride;
        d3 = vld1_u8(a);
        a += a_stride;
        tmp = vzip_u8(d0, d1);
        tmp2 = vzip_u8(d2, d3);
        q2 = vcombine_u8(tmp.val[0], tmp2.val[0]);  // make a 16 data vector

        d0 = vld1_u8(b);
        b += b_stride;
        d1 = vld1_u8(b);
        b += b_stride;
        d2 = vld1_u8(b);
        b += b_stride;
        d3 = vld1_u8(b);
        b += b_stride;
        tmp = vzip_u8(d0, d1);
        tmp2 = vzip_u8(d2, d3);
        q3 = vcombine_u8(tmp.val[0], tmp2.val[0]);

        sse += sse_W16x1_neon(q2, q3);
      }
      break;
    case 8:
      for (y = 0; y < height; y += 2) {
        d0 = vld1_u8(a);  // load 8 data
        d1 = vld1_u8(a + a_stride);
        q2 = vcombine_u8(d0, d1);  // make a 16 data vector

        d0 = vld1_u8(b);
        d1 = vld1_u8(b + b_stride);
        q3 = vcombine_u8(d0, d1);

        sse += sse_W16x1_neon(q2, q3);

        a += 2 * a_stride;
        b += 2 * b_stride;
      }
      break;
    case 16:
      for (y = 0; y < height; y++) {
        q2 = vld1q_u8(a);
        q3 = vld1q_u8(b);

        sse += sse_W16x1_neon(q2, q3);

        a += a_stride;
        b += b_stride;
      }
      break;
    case 32:
      for (y = 0; y < height; y++) {
        q2 = vld1q_u8(a);
        q3 = vld1q_u8(b);

        sse += sse_W16x1_neon(q2, q3);

        q2 = vld1q_u8(a + 16);
        q3 = vld1q_u8(b + 16);

        sse += sse_W16x1_neon(q2, q3);

        a += a_stride;
        b += b_stride;
      }
      break;
    case 64:
      for (y = 0; y < height; y++) {
        q2 = vld1q_u8(a);
        q3 = vld1q_u8(b);

        sse += sse_W16x1_neon(q2, q3);

        q2 = vld1q_u8(a + 16);
        q3 = vld1q_u8(b + 16);

        sse += sse_W16x1_neon(q2, q3);

        q2 = vld1q_u8(a + 32);
        q3 = vld1q_u8(b + 32);

        sse += sse_W16x1_neon(q2, q3);

        q2 = vld1q_u8(a + 48);
        q3 = vld1q_u8(b + 48);

        sse += sse_W16x1_neon(q2, q3);

        a += a_stride;
        b += b_stride;
      }
      break;
    case 128:
      for (y = 0; y < height; y++) {
        q2 = vld1q_u8(a);
        q3 = vld1q_u8(b);

        sse += sse_W16x1_neon(q2, q3);

        q2 = vld1q_u8(a + 16);
        q3 = vld1q_u8(b + 16);

        sse += sse_W16x1_neon(q2, q3);

        q2 = vld1q_u8(a + 32);
        q3 = vld1q_u8(b + 32);

        sse += sse_W16x1_neon(q2, q3);

        q2 = vld1q_u8(a + 48);
        q3 = vld1q_u8(b + 48);

        sse += sse_W16x1_neon(q2, q3);

        q2 = vld1q_u8(a + 64);
        q3 = vld1q_u8(b + 64);

        sse += sse_W16x1_neon(q2, q3);

        q2 = vld1q_u8(a + 80);
        q3 = vld1q_u8(b + 80);

        sse += sse_W16x1_neon(q2, q3);

        q2 = vld1q_u8(a + 96);
        q3 = vld1q_u8(b + 96);

        sse += sse_W16x1_neon(q2, q3);

        q2 = vld1q_u8(a + 112);
        q3 = vld1q_u8(b + 112);

        sse += sse_W16x1_neon(q2, q3);

        a += a_stride;
        b += b_stride;
      }
      break;
    default:
      for (y = 0; y < height; y++) {
        x = width;
        while (x > 0) {
          addinc = width - x;
          q2 = vld1q_u8(a + addinc);
          q3 = vld1q_u8(b + addinc);
          if (x < 16) {
            dx = x;
            q4 = vld1q_dup_u8(&dx);
            q5 = vcltq_u8(q0, q4);
            q2 = vandq_u8(q2, q5);
            q3 = vandq_u8(q3, q5);
          }
          sse += sse_W16x1_neon(q2, q3);
          x -= 16;
        }
        a += a_stride;
        b += b_stride;
      }
  }
  return (int64_t)sse;
}

#if CONFIG_AV1_HIGHBITDEPTH
static INLINE uint32_t highbd_sse_W8x1_neon(uint16x8_t q2, uint16x8_t q3) {
  uint32_t sse;
  const uint32_t sse1 = 0;
  const uint32x4_t q1 = vld1q_dup_u32(&sse1);

  uint16x8_t q4 = vabdq_u16(q2, q3);  // diff = abs(a[x] - b[x])
  uint16x4_t d0 = vget_low_u16(q4);
  uint16x4_t d1 = vget_high_u16(q4);

  uint32x4_t q6 = vmlal_u16(q1, d0, d0);
  uint32x4_t q7 = vmlal_u16(q1, d1, d1);

  uint32x2_t d4 = vadd_u32(vget_low_u32(q6), vget_high_u32(q6));
  uint32x2_t d5 = vadd_u32(vget_low_u32(q7), vget_high_u32(q7));

  uint32x2_t d6 = vadd_u32(d4, d5);

  sse = vget_lane_u32(d6, 0);
  sse += vget_lane_u32(d6, 1);

  return sse;
}

int64_t aom_highbd_sse_neon(const uint8_t *a8, int a_stride, const uint8_t *b8,
                            int b_stride, int width, int height) {
  const uint16x8_t q0 = { 0, 1, 2, 3, 4, 5, 6, 7 };
  int64_t sse = 0;
  uint16_t *a = CONVERT_TO_SHORTPTR(a8);
  uint16_t *b = CONVERT_TO_SHORTPTR(b8);
  int x, y;
  int addinc;
  uint16x4_t d0, d1, d2, d3;
  uint16_t dx;
  uint16x8_t q2, q3, q4, q5;

  switch (width) {
    case 4:
      for (y = 0; y < height; y += 2) {
        d0 = vld1_u16(a);  // load 4 data
        a += a_stride;
        d1 = vld1_u16(a);
        a += a_stride;

        d2 = vld1_u16(b);
        b += b_stride;
        d3 = vld1_u16(b);
        b += b_stride;
        q2 = vcombine_u16(d0, d1);  // make a 8 data vector
        q3 = vcombine_u16(d2, d3);

        sse += highbd_sse_W8x1_neon(q2, q3);
      }
      break;
    case 8:
      for (y = 0; y < height; y++) {
        q2 = vld1q_u16(a);
        q3 = vld1q_u16(b);

        sse += highbd_sse_W8x1_neon(q2, q3);

        a += a_stride;
        b += b_stride;
      }
      break;
    case 16:
      for (y = 0; y < height; y++) {
        q2 = vld1q_u16(a);
        q3 = vld1q_u16(b);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 8);
        q3 = vld1q_u16(b + 8);

        sse += highbd_sse_W8x1_neon(q2, q3);

        a += a_stride;
        b += b_stride;
      }
      break;
    case 32:
      for (y = 0; y < height; y++) {
        q2 = vld1q_u16(a);
        q3 = vld1q_u16(b);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 8);
        q3 = vld1q_u16(b + 8);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 16);
        q3 = vld1q_u16(b + 16);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 24);
        q3 = vld1q_u16(b + 24);

        sse += highbd_sse_W8x1_neon(q2, q3);

        a += a_stride;
        b += b_stride;
      }
      break;
    case 64:
      for (y = 0; y < height; y++) {
        q2 = vld1q_u16(a);
        q3 = vld1q_u16(b);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 8);
        q3 = vld1q_u16(b + 8);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 16);
        q3 = vld1q_u16(b + 16);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 24);
        q3 = vld1q_u16(b + 24);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 32);
        q3 = vld1q_u16(b + 32);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 40);
        q3 = vld1q_u16(b + 40);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 48);
        q3 = vld1q_u16(b + 48);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 56);
        q3 = vld1q_u16(b + 56);

        sse += highbd_sse_W8x1_neon(q2, q3);

        a += a_stride;
        b += b_stride;
      }
      break;
    case 128:
      for (y = 0; y < height; y++) {
        q2 = vld1q_u16(a);
        q3 = vld1q_u16(b);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 8);
        q3 = vld1q_u16(b + 8);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 16);
        q3 = vld1q_u16(b + 16);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 24);
        q3 = vld1q_u16(b + 24);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 32);
        q3 = vld1q_u16(b + 32);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 40);
        q3 = vld1q_u16(b + 40);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 48);
        q3 = vld1q_u16(b + 48);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 56);
        q3 = vld1q_u16(b + 56);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 64);
        q3 = vld1q_u16(b + 64);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 72);
        q3 = vld1q_u16(b + 72);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 80);
        q3 = vld1q_u16(b + 80);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 88);
        q3 = vld1q_u16(b + 88);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 96);
        q3 = vld1q_u16(b + 96);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 104);
        q3 = vld1q_u16(b + 104);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 112);
        q3 = vld1q_u16(b + 112);

        sse += highbd_sse_W8x1_neon(q2, q3);

        q2 = vld1q_u16(a + 120);
        q3 = vld1q_u16(b + 120);

        sse += highbd_sse_W8x1_neon(q2, q3);
        a += a_stride;
        b += b_stride;
      }
      break;
    default:

      for (y = 0; y < height; y++) {
        x = width;
        while (x > 0) {
          addinc = width - x;
          q2 = vld1q_u16(a + addinc);
          q3 = vld1q_u16(b + addinc);
          if (x < 8) {
            dx = x;
            q4 = vld1q_dup_u16(&dx);
            q5 = vcltq_u16(q0, q4);
            q2 = vandq_u16(q2, q5);
            q3 = vandq_u16(q3, q5);
          }
          sse += highbd_sse_W8x1_neon(q2, q3);
          x -= 8;
        }
        a += a_stride;
        b += b_stride;
      }
  }
  return (int64_t)sse;
}
#endif
