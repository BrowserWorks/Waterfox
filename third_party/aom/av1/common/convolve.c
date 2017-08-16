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
#include <string.h>

#include "./aom_dsp_rtcd.h"
#include "./av1_rtcd.h"
#include "av1/common/convolve.h"
#include "av1/common/filter.h"
#include "av1/common/onyxc_int.h"
#include "aom_dsp/aom_dsp_common.h"
#include "aom_ports/mem.h"

#define MAX_BLOCK_WIDTH (MAX_SB_SIZE)
#define MAX_BLOCK_HEIGHT (MAX_SB_SIZE)
#define MAX_STEP (32)

void av1_convolve_horiz_c(const uint8_t *src, int src_stride, uint8_t *dst,
                          int dst_stride, int w, int h,
                          const InterpFilterParams filter_params,
                          const int subpel_x_q4, int x_step_q4,
                          ConvolveParams *conv_params) {
  int x, y;
  int filter_size = filter_params.taps;
  assert(conv_params->round == CONVOLVE_OPT_ROUND);
  src -= filter_size / 2 - 1;
  for (y = 0; y < h; ++y) {
    int x_q4 = subpel_x_q4;
    for (x = 0; x < w; ++x) {
      const uint8_t *const src_x = &src[x_q4 >> SUBPEL_BITS];
      const int16_t *x_filter = av1_get_interp_filter_subpel_kernel(
          filter_params, x_q4 & SUBPEL_MASK);
      int k, sum = 0;
      for (k = 0; k < filter_size; ++k) sum += src_x[k] * x_filter[k];

      sum = clip_pixel(ROUND_POWER_OF_TWO(sum, FILTER_BITS));
      if (conv_params->ref)
        dst[x] = ROUND_POWER_OF_TWO(dst[x] + sum, 1);
      else
        dst[x] = sum;

      x_q4 += x_step_q4;
    }
    src += src_stride;
    dst += dst_stride;
  }
}

void av1_convolve_vert_c(const uint8_t *src, int src_stride, uint8_t *dst,
                         int dst_stride, int w, int h,
                         const InterpFilterParams filter_params,
                         const int subpel_y_q4, int y_step_q4,
                         ConvolveParams *conv_params) {
  int x, y;
  int filter_size = filter_params.taps;
  assert(conv_params->round == CONVOLVE_OPT_ROUND);
  src -= src_stride * (filter_size / 2 - 1);
  for (x = 0; x < w; ++x) {
    int y_q4 = subpel_y_q4;
    for (y = 0; y < h; ++y) {
      const uint8_t *const src_y = &src[(y_q4 >> SUBPEL_BITS) * src_stride];
      const int16_t *y_filter = av1_get_interp_filter_subpel_kernel(
          filter_params, y_q4 & SUBPEL_MASK);
      int k, sum = 0;
      for (k = 0; k < filter_size; ++k)
        sum += src_y[k * src_stride] * y_filter[k];

      sum = clip_pixel(ROUND_POWER_OF_TWO(sum, FILTER_BITS));
      if (conv_params->ref)
        dst[y * dst_stride] = ROUND_POWER_OF_TWO(dst[y * dst_stride] + sum, 1);
      else
        dst[y * dst_stride] = sum;

      y_q4 += y_step_q4;
    }
    ++src;
    ++dst;
  }
}

static void convolve_copy(const uint8_t *src, int src_stride, uint8_t *dst,
                          int dst_stride, int w, int h,
                          ConvolveParams *conv_params) {
  assert(conv_params->round == CONVOLVE_OPT_ROUND);
  if (conv_params->ref == 0) {
    int r;
    for (r = 0; r < h; ++r) {
      memcpy(dst, src, w);
      src += src_stride;
      dst += dst_stride;
    }
  } else {
    int r, c;
    for (r = 0; r < h; ++r) {
      for (c = 0; c < w; ++c) {
        dst[c] = clip_pixel(ROUND_POWER_OF_TWO(dst[c] + src[c], 1));
      }
      src += src_stride;
      dst += dst_stride;
    }
  }
}

void av1_convolve_horiz_facade(const uint8_t *src, int src_stride, uint8_t *dst,
                               int dst_stride, int w, int h,
                               const InterpFilterParams filter_params,
                               const int subpel_x_q4, int x_step_q4,
                               ConvolveParams *conv_params) {
  assert(conv_params->round == CONVOLVE_OPT_ROUND);
  if (filter_params.taps == SUBPEL_TAPS) {
    const int16_t *filter_x =
        av1_get_interp_filter_subpel_kernel(filter_params, subpel_x_q4);
    if (conv_params->ref == 0)
      aom_convolve8_horiz(src, src_stride, dst, dst_stride, filter_x, x_step_q4,
                          NULL, -1, w, h);
    else
      aom_convolve8_avg_horiz(src, src_stride, dst, dst_stride, filter_x,
                              x_step_q4, NULL, -1, w, h);
  } else {
    av1_convolve_horiz(src, src_stride, dst, dst_stride, w, h, filter_params,
                       subpel_x_q4, x_step_q4, conv_params);
  }
}

void av1_convolve_horiz_facade_c(const uint8_t *src, int src_stride,
                                 uint8_t *dst, int dst_stride, int w, int h,
                                 const InterpFilterParams filter_params,
                                 const int subpel_x_q4, int x_step_q4,
                                 ConvolveParams *conv_params) {
  assert(conv_params->round == CONVOLVE_OPT_ROUND);
  if (filter_params.taps == SUBPEL_TAPS) {
    const int16_t *filter_x =
        av1_get_interp_filter_subpel_kernel(filter_params, subpel_x_q4);
    if (conv_params->ref == 0)
      aom_convolve8_horiz_c(src, src_stride, dst, dst_stride, filter_x,
                            x_step_q4, NULL, -1, w, h);
    else
      aom_convolve8_avg_horiz_c(src, src_stride, dst, dst_stride, filter_x,
                                x_step_q4, NULL, -1, w, h);
  } else {
    av1_convolve_horiz_c(src, src_stride, dst, dst_stride, w, h, filter_params,
                         subpel_x_q4, x_step_q4, conv_params);
  }
}

void av1_convolve_vert_facade(const uint8_t *src, int src_stride, uint8_t *dst,
                              int dst_stride, int w, int h,
                              const InterpFilterParams filter_params,
                              const int subpel_y_q4, int y_step_q4,
                              ConvolveParams *conv_params) {
  assert(conv_params->round == CONVOLVE_OPT_ROUND);
  if (filter_params.taps == SUBPEL_TAPS) {
    const int16_t *filter_y =
        av1_get_interp_filter_subpel_kernel(filter_params, subpel_y_q4);
    if (conv_params->ref == 0) {
      aom_convolve8_vert(src, src_stride, dst, dst_stride, NULL, -1, filter_y,
                         y_step_q4, w, h);
    } else {
      aom_convolve8_avg_vert(src, src_stride, dst, dst_stride, NULL, -1,
                             filter_y, y_step_q4, w, h);
    }
  } else {
    av1_convolve_vert(src, src_stride, dst, dst_stride, w, h, filter_params,
                      subpel_y_q4, y_step_q4, conv_params);
  }
}

void av1_convolve_vert_facade_c(const uint8_t *src, int src_stride,
                                uint8_t *dst, int dst_stride, int w, int h,
                                const InterpFilterParams filter_params,
                                const int subpel_y_q4, int y_step_q4,
                                ConvolveParams *conv_params) {
  assert(conv_params->round == CONVOLVE_OPT_ROUND);
  if (filter_params.taps == SUBPEL_TAPS) {
    const int16_t *filter_y =
        av1_get_interp_filter_subpel_kernel(filter_params, subpel_y_q4);
    if (conv_params->ref == 0) {
      aom_convolve8_vert_c(src, src_stride, dst, dst_stride, NULL, -1, filter_y,
                           y_step_q4, w, h);
    } else {
      aom_convolve8_avg_vert_c(src, src_stride, dst, dst_stride, NULL, -1,
                               filter_y, y_step_q4, w, h);
    }
  } else {
    av1_convolve_vert_c(src, src_stride, dst, dst_stride, w, h, filter_params,
                        subpel_y_q4, y_step_q4, conv_params);
  }
}

#if CONFIG_CONVOLVE_ROUND
void av1_convolve_rounding(const int32_t *src, int src_stride, uint8_t *dst,
                           int dst_stride, int w, int h, int bits) {
  int r, c;
  for (r = 0; r < h; ++r) {
    for (c = 0; c < w; ++c) {
      dst[r * dst_stride + c] =
          clip_pixel(ROUND_POWER_OF_TWO_SIGNED(src[r * src_stride + c], bits));
    }
  }
}

void av1_convolve_2d(const uint8_t *src, int src_stride, CONV_BUF_TYPE *dst,
                     int dst_stride, int w, int h,
                     InterpFilterParams *filter_params_x,
                     InterpFilterParams *filter_params_y, const int subpel_x_q4,
                     const int subpel_y_q4, ConvolveParams *conv_params) {
  int x, y, k;
  CONV_BUF_TYPE im_block[(MAX_SB_SIZE + MAX_FILTER_TAP - 1) * MAX_SB_SIZE];
  int im_h = h + filter_params_y->taps - 1;
  int im_stride = w;
  const int fo_vert = filter_params_y->taps / 2 - 1;
  const int fo_horiz = filter_params_x->taps / 2 - 1;
  (void)conv_params;
  // horizontal filter
  const uint8_t *src_horiz = src - fo_vert * src_stride;
  const int16_t *x_filter = av1_get_interp_filter_subpel_kernel(
      *filter_params_x, subpel_x_q4 & SUBPEL_MASK);
  for (y = 0; y < im_h; ++y) {
    for (x = 0; x < w; ++x) {
      CONV_BUF_TYPE sum = 0;
      for (k = 0; k < filter_params_x->taps; ++k) {
        sum += x_filter[k] * src_horiz[y * src_stride + x - fo_horiz + k];
      }
#if CONFIG_COMPOUND_ROUND
      im_block[y * im_stride + x] =
          clip_pixel(ROUND_POWER_OF_TWO_SIGNED(sum, conv_params->round_0));
#else
      im_block[y * im_stride + x] =
          ROUND_POWER_OF_TWO_SIGNED(sum, conv_params->round_0);
#endif
    }
  }

  // vertical filter
  CONV_BUF_TYPE *src_vert = im_block + fo_vert * im_stride;
  const int16_t *y_filter = av1_get_interp_filter_subpel_kernel(
      *filter_params_y, subpel_y_q4 & SUBPEL_MASK);
  for (y = 0; y < h; ++y) {
    for (x = 0; x < w; ++x) {
      CONV_BUF_TYPE sum = 0;
      for (k = 0; k < filter_params_y->taps; ++k) {
        sum += y_filter[k] * src_vert[(y - fo_vert + k) * im_stride + x];
      }
      dst[y * dst_stride + x] +=
          ROUND_POWER_OF_TWO_SIGNED(sum, conv_params->round_1);
    }
  }
}

static INLINE void transpose_uint8(uint8_t *dst, int dst_stride,
                                   const uint8_t *src, int src_stride, int w,
                                   int h) {
  int r, c;
  for (r = 0; r < h; ++r)
    for (c = 0; c < w; ++c)
      dst[c * (dst_stride) + r] = src[r * (src_stride) + c];
}

static INLINE void transpose_int32(int32_t *dst, int dst_stride,
                                   const int32_t *src, int src_stride, int w,
                                   int h) {
  int r, c;
  for (r = 0; r < h; ++r)
    for (c = 0; c < w; ++c)
      dst[c * (dst_stride) + r] = src[r * (src_stride) + c];
}

void av1_convolve_2d_facade(const uint8_t *src, int src_stride, uint8_t *dst,
                            int dst_stride, int w, int h,
                            const InterpFilter *interp_filter,
                            const int subpel_x_q4, int x_step_q4,
                            const int subpel_y_q4, int y_step_q4,
                            ConvolveParams *conv_params) {
  (void)x_step_q4;
  (void)y_step_q4;
  (void)dst;
  (void)dst_stride;
#if CONFIG_DUAL_FILTER
  InterpFilterParams filter_params_x =
      av1_get_interp_filter_params(interp_filter[1 + 2 * conv_params->ref]);
  InterpFilterParams filter_params_y =
      av1_get_interp_filter_params(interp_filter[0 + 2 * conv_params->ref]);

#if USE_EXTRA_FILTER
  if (filter_params_x.interp_filter == MULTITAP_SHARP &&
      filter_params_y.interp_filter == MULTITAP_SHARP) {
    // Avoid two directions both using 12-tap filter.
    // This will reduce hardware implementation cost.
    filter_params_y = av1_get_interp_filter_params(EIGHTTAP_SHARP);
  }
#endif  // USE_EXTRA_FILTER
#else
  InterpFilterParams filter_params_x =
      av1_get_interp_filter_params(*interp_filter);
  InterpFilterParams filter_params_y =
      av1_get_interp_filter_params(*interp_filter);
#endif

  if (filter_params_y.taps < filter_params_x.taps) {
    uint8_t tr_src[(MAX_SB_SIZE + MAX_FILTER_TAP - 1) *
                   (MAX_SB_SIZE + MAX_FILTER_TAP - 1)];
    int tr_src_stride = MAX_SB_SIZE + MAX_FILTER_TAP - 1;
    CONV_BUF_TYPE tr_dst[MAX_SB_SIZE * MAX_SB_SIZE];
    int tr_dst_stride = MAX_SB_SIZE;
    int fo_vert = filter_params_y.taps / 2 - 1;
    int fo_horiz = filter_params_x.taps / 2 - 1;

    transpose_uint8(tr_src, tr_src_stride,
                    src - fo_vert * src_stride - fo_horiz, src_stride,
                    w + filter_params_x.taps - 1, h + filter_params_y.taps - 1);
    transpose_int32(tr_dst, tr_dst_stride, conv_params->dst,
                    conv_params->dst_stride, w, h);

    // horizontal and vertical parameters are swapped because of the transpose
    av1_convolve_2d(tr_src + fo_horiz * tr_src_stride + fo_vert, tr_src_stride,
                    tr_dst, tr_dst_stride, h, w, &filter_params_y,
                    &filter_params_x, subpel_y_q4, subpel_x_q4, conv_params);
    transpose_int32(conv_params->dst, conv_params->dst_stride, tr_dst,
                    tr_dst_stride, h, w);
  } else {
    av1_convolve_2d(src, src_stride, conv_params->dst, conv_params->dst_stride,
                    w, h, &filter_params_x, &filter_params_y, subpel_x_q4,
                    subpel_y_q4, conv_params);
  }
}

#if CONFIG_HIGHBITDEPTH
static INLINE void transpose_uint16(uint16_t *dst, int dst_stride,
                                    const uint16_t *src, int src_stride, int w,
                                    int h) {
  int r, c;
  for (r = 0; r < h; ++r)
    for (c = 0; c < w; ++c) dst[c * dst_stride + r] = src[r * src_stride + c];
}

void av1_highbd_convolve_rounding(const int32_t *src, int src_stride,
                                  uint8_t *dst8, int dst_stride, int w, int h,
                                  int bits, int bd) {
  uint16_t *dst = CONVERT_TO_SHORTPTR(dst8);
  int r, c;
  for (r = 0; r < h; ++r) {
    for (c = 0; c < w; ++c) {
      dst[r * dst_stride + c] = clip_pixel_highbd(
          ROUND_POWER_OF_TWO_SIGNED(src[r * src_stride + c], bits), bd);
    }
  }
}

void av1_highbd_convolve_2d(const uint16_t *src, int src_stride,
                            CONV_BUF_TYPE *dst, int dst_stride, int w, int h,
                            InterpFilterParams *filter_params_x,
                            InterpFilterParams *filter_params_y,
                            const int subpel_x_q4, const int subpel_y_q4,
                            ConvolveParams *conv_params, int bd) {
  int x, y, k;
  CONV_BUF_TYPE im_block[(MAX_SB_SIZE + MAX_FILTER_TAP - 1) * MAX_SB_SIZE];
  int im_h = h + filter_params_y->taps - 1;
  int im_stride = w;
  const int fo_vert = filter_params_y->taps / 2 - 1;
  const int fo_horiz = filter_params_x->taps / 2 - 1;
  (void)conv_params;
  // horizontal filter
  const uint16_t *src_horiz = src - fo_vert * src_stride;
  const int16_t *x_filter = av1_get_interp_filter_subpel_kernel(
      *filter_params_x, subpel_x_q4 & SUBPEL_MASK);
  for (y = 0; y < im_h; ++y) {
    for (x = 0; x < w; ++x) {
      CONV_BUF_TYPE sum = 0;
      for (k = 0; k < filter_params_x->taps; ++k) {
        sum += x_filter[k] * src_horiz[y * src_stride + x - fo_horiz + k];
      }
#if CONFIG_COMPOUND_ROUND
      im_block[y * im_stride + x] = clip_pixel_highbd(
          ROUND_POWER_OF_TWO_SIGNED(sum, conv_params->round_0), bd);
#else
      (void)bd;
      im_block[y * im_stride + x] =
          ROUND_POWER_OF_TWO_SIGNED(sum, conv_params->round_0);
#endif
    }
  }

  // vertical filter
  CONV_BUF_TYPE *src_vert = im_block + fo_vert * im_stride;
  const int16_t *y_filter = av1_get_interp_filter_subpel_kernel(
      *filter_params_y, subpel_y_q4 & SUBPEL_MASK);
  for (y = 0; y < h; ++y) {
    for (x = 0; x < w; ++x) {
      CONV_BUF_TYPE sum = 0;
      for (k = 0; k < filter_params_y->taps; ++k) {
        sum += y_filter[k] * src_vert[(y - fo_vert + k) * im_stride + x];
      }
      dst[y * dst_stride + x] +=
          ROUND_POWER_OF_TWO_SIGNED(sum, conv_params->round_1);
    }
  }
}

void av1_highbd_convolve_2d_facade(const uint8_t *src8, int src_stride,
                                   uint8_t *dst, int dst_stride, int w, int h,
                                   const InterpFilter *interp_filter,
                                   const int subpel_x_q4, int x_step_q4,
                                   const int subpel_y_q4, int y_step_q4,
                                   ConvolveParams *conv_params, int bd) {
  (void)x_step_q4;
  (void)y_step_q4;
  (void)dst;
  (void)dst_stride;
#if CONFIG_DUAL_FILTER
  InterpFilterParams filter_params_x =
      av1_get_interp_filter_params(interp_filter[1 + 2 * conv_params->ref]);
  InterpFilterParams filter_params_y =
      av1_get_interp_filter_params(interp_filter[0 + 2 * conv_params->ref]);

#if USE_EXTRA_FILTER
  if (filter_params_x.interp_filter == MULTITAP_SHARP &&
      filter_params_y.interp_filter == MULTITAP_SHARP) {
    // Avoid two directions both using 12-tap filter.
    // This will reduce hardware implementation cost.
    filter_params_y = av1_get_interp_filter_params(EIGHTTAP_SHARP);
  }
#endif
#else
  InterpFilterParams filter_params_x =
      av1_get_interp_filter_params(*interp_filter);
  InterpFilterParams filter_params_y =
      av1_get_interp_filter_params(*interp_filter);
#endif
  const uint16_t *src = CONVERT_TO_SHORTPTR(src8);
  if (filter_params_y.taps < filter_params_x.taps) {
    uint16_t tr_src[(MAX_SB_SIZE + MAX_FILTER_TAP - 1) *
                    (MAX_SB_SIZE + MAX_FILTER_TAP - 1)];
    int tr_src_stride = MAX_SB_SIZE + MAX_FILTER_TAP - 1;
    CONV_BUF_TYPE tr_dst[MAX_SB_SIZE * MAX_SB_SIZE];
    int tr_dst_stride = MAX_SB_SIZE;
    int fo_vert = filter_params_y.taps / 2 - 1;
    int fo_horiz = filter_params_x.taps / 2 - 1;

    transpose_uint16(
        tr_src, tr_src_stride, src - fo_vert * src_stride - fo_horiz,
        src_stride, w + filter_params_x.taps - 1, h + filter_params_y.taps - 1);
    transpose_int32(tr_dst, tr_dst_stride, conv_params->dst,
                    conv_params->dst_stride, w, h);

    // horizontal and vertical parameters are swapped because of the transpose
    av1_highbd_convolve_2d(tr_src + fo_horiz * tr_src_stride + fo_vert,
                           tr_src_stride, tr_dst, tr_dst_stride, h, w,
                           &filter_params_y, &filter_params_x, subpel_y_q4,
                           subpel_x_q4, conv_params, bd);
    transpose_int32(conv_params->dst, conv_params->dst_stride, tr_dst,
                    tr_dst_stride, h, w);
  } else {
    av1_highbd_convolve_2d(src, src_stride, conv_params->dst,
                           conv_params->dst_stride, w, h, &filter_params_x,
                           &filter_params_y, subpel_x_q4, subpel_y_q4,
                           conv_params, bd);
  }
}
#endif  // CONFIG_HIGHBITDEPTH

#endif  // CONFIG_CONVOLVE_ROUND

typedef void (*ConvolveFunc)(const uint8_t *src, int src_stride, uint8_t *dst,
                             int dst_stride, int w, int h,
                             const InterpFilterParams filter_params,
                             const int subpel_q4, int step_q4,
                             ConvolveParams *conv_params);

static void convolve_helper(const uint8_t *src, int src_stride, uint8_t *dst,
                            int dst_stride, int w, int h,
#if CONFIG_DUAL_FILTER
                            const InterpFilter *interp_filter,
#else
                            const InterpFilter interp_filter,
#endif
                            const int subpel_x_q4, int x_step_q4,
                            const int subpel_y_q4, int y_step_q4,
                            ConvolveParams *conv_params,
                            ConvolveFunc convolve_horiz,
                            ConvolveFunc convolve_vert) {
  int ignore_horiz = x_step_q4 == 16 && subpel_x_q4 == 0;
  int ignore_vert = y_step_q4 == 16 && subpel_y_q4 == 0;
#if CONFIG_DUAL_FILTER
  InterpFilterParams filter_params_x =
      av1_get_interp_filter_params(interp_filter[1 + 2 * conv_params->ref]);
  InterpFilterParams filter_params_y =
      av1_get_interp_filter_params(interp_filter[0 + 2 * conv_params->ref]);
  InterpFilterParams filter_params;
#else
  InterpFilterParams filter_params =
      av1_get_interp_filter_params(interp_filter);
#endif
  assert(conv_params->round == CONVOLVE_OPT_ROUND);

  assert(w <= MAX_BLOCK_WIDTH);
  assert(h <= MAX_BLOCK_HEIGHT);
  assert(y_step_q4 <= MAX_STEP);
  assert(x_step_q4 <= MAX_STEP);

  if (ignore_horiz && ignore_vert) {
    convolve_copy(src, src_stride, dst, dst_stride, w, h, conv_params);
  } else if (ignore_vert) {
#if CONFIG_DUAL_FILTER
    filter_params = filter_params_x;
#endif
    assert(filter_params.taps <= MAX_FILTER_TAP);
    convolve_horiz(src, src_stride, dst, dst_stride, w, h, filter_params,
                   subpel_x_q4, x_step_q4, conv_params);
  } else if (ignore_horiz) {
#if CONFIG_DUAL_FILTER
    filter_params = filter_params_y;
#endif
    assert(filter_params.taps <= MAX_FILTER_TAP);
    convolve_vert(src, src_stride, dst, dst_stride, w, h, filter_params,
                  subpel_y_q4, y_step_q4, conv_params);
  } else {
    // temp's size is set to a 256 aligned value to facilitate SIMD
    // implementation. The value is greater than (maximum possible intermediate
    // height or width) * MAX_SB_SIZE
    DECLARE_ALIGNED(16, uint8_t,
                    temp[((MAX_SB_SIZE * 2 + 16) + 16) * MAX_SB_SIZE]);
    int max_intermediate_size = ((MAX_SB_SIZE * 2 + 16) + 16);
    int filter_size;
#if CONFIG_DUAL_FILTER && USE_EXTRA_FILTER
    if (interp_filter[0 + 2 * conv_params->ref] == MULTITAP_SHARP &&
        interp_filter[1 + 2 * conv_params->ref] == MULTITAP_SHARP) {
      // Avoid two directions both using 12-tap filter.
      // This will reduce hardware implementation cost.
      filter_params_y = av1_get_interp_filter_params(EIGHTTAP_SHARP);
    }

    // we do filter with fewer taps first to reduce hardware implementation
    // complexity
    if (filter_params_y.taps < filter_params_x.taps) {
      int intermediate_width;
      int temp_stride = max_intermediate_size;
      ConvolveParams temp_conv_params;
      temp_conv_params.ref = 0;
      temp_conv_params.round = CONVOLVE_OPT_ROUND;
      filter_params = filter_params_y;
      filter_size = filter_params_x.taps;
      intermediate_width =
          (((w - 1) * x_step_q4 + subpel_x_q4) >> SUBPEL_BITS) + filter_size;
      assert(intermediate_width <= max_intermediate_size);

      assert(filter_params.taps <= MAX_FILTER_TAP);

      convolve_vert(src - (filter_size / 2 - 1), src_stride, temp, temp_stride,
                    intermediate_width, h, filter_params, subpel_y_q4,
                    y_step_q4, &temp_conv_params);

      filter_params = filter_params_x;
      assert(filter_params.taps <= MAX_FILTER_TAP);
      convolve_horiz(temp + (filter_size / 2 - 1), temp_stride, dst, dst_stride,
                     w, h, filter_params, subpel_x_q4, x_step_q4, conv_params);
    } else
#endif  // CONFIG_DUAL_FILTER && USE_EXTRA_FILTER
    {
      int intermediate_height;
      int temp_stride = MAX_SB_SIZE;
      ConvolveParams temp_conv_params;
      temp_conv_params.ref = 0;
      temp_conv_params.round = CONVOLVE_OPT_ROUND;
#if CONFIG_DUAL_FILTER
      filter_params = filter_params_x;
      filter_size = filter_params_y.taps;
#else
      filter_size = filter_params.taps;
#endif
      intermediate_height =
          (((h - 1) * y_step_q4 + subpel_y_q4) >> SUBPEL_BITS) + filter_size;
      assert(intermediate_height <= max_intermediate_size);
      (void)max_intermediate_size;

      assert(filter_params.taps <= MAX_FILTER_TAP);

      convolve_horiz(src - src_stride * (filter_size / 2 - 1), src_stride, temp,
                     temp_stride, w, intermediate_height, filter_params,
                     subpel_x_q4, x_step_q4, &temp_conv_params);

#if CONFIG_DUAL_FILTER
      filter_params = filter_params_y;
#endif
      assert(filter_params.taps <= MAX_FILTER_TAP);

      convolve_vert(temp + temp_stride * (filter_size / 2 - 1), temp_stride,
                    dst, dst_stride, w, h, filter_params, subpel_y_q4,
                    y_step_q4, conv_params);
    }
  }
}

void av1_convolve(const uint8_t *src, int src_stride, uint8_t *dst,
                  int dst_stride, int w, int h,
#if CONFIG_DUAL_FILTER
                  const InterpFilter *interp_filter,
#else
                  const InterpFilter interp_filter,
#endif
                  const int subpel_x_q4, int x_step_q4, const int subpel_y_q4,
                  int y_step_q4, ConvolveParams *conv_params) {
  convolve_helper(src, src_stride, dst, dst_stride, w, h, interp_filter,
                  subpel_x_q4, x_step_q4, subpel_y_q4, y_step_q4, conv_params,
                  av1_convolve_horiz_facade, av1_convolve_vert_facade);
}

void av1_convolve_c(const uint8_t *src, int src_stride, uint8_t *dst,
                    int dst_stride, int w, int h,
#if CONFIG_DUAL_FILTER
                    const InterpFilter *interp_filter,
#else
                    const InterpFilter interp_filter,
#endif
                    const int subpel_x_q4, int x_step_q4, const int subpel_y_q4,
                    int y_step_q4, ConvolveParams *conv_params) {
  convolve_helper(src, src_stride, dst, dst_stride, w, h, interp_filter,
                  subpel_x_q4, x_step_q4, subpel_y_q4, y_step_q4, conv_params,
                  av1_convolve_horiz_facade_c, av1_convolve_vert_facade_c);
}

void av1_lowbd_convolve_init_c(void) {
  // A placeholder for SIMD initialization
  return;
}

void av1_highbd_convolve_init_c(void) {
  // A placeholder for SIMD initialization
  return;
}

void av1_convolve_init(AV1_COMMON *cm) {
#if CONFIG_HIGHBITDEPTH
  if (cm->use_highbitdepth)
    av1_highbd_convolve_init();
  else
    av1_lowbd_convolve_init();
#else
  (void)cm;
  av1_lowbd_convolve_init();
#endif
  return;
}

#if CONFIG_HIGHBITDEPTH
void av1_highbd_convolve_horiz_c(const uint16_t *src, int src_stride,
                                 uint16_t *dst, int dst_stride, int w, int h,
                                 const InterpFilterParams filter_params,
                                 const int subpel_x_q4, int x_step_q4, int avg,
                                 int bd) {
  int x, y;
  int filter_size = filter_params.taps;
  src -= filter_size / 2 - 1;
  for (y = 0; y < h; ++y) {
    int x_q4 = subpel_x_q4;
    for (x = 0; x < w; ++x) {
      const uint16_t *const src_x = &src[x_q4 >> SUBPEL_BITS];
      const int16_t *x_filter = av1_get_interp_filter_subpel_kernel(
          filter_params, x_q4 & SUBPEL_MASK);
      int k, sum = 0;
      for (k = 0; k < filter_size; ++k) sum += src_x[k] * x_filter[k];
      if (avg)
        dst[x] = ROUND_POWER_OF_TWO(
            dst[x] +
                clip_pixel_highbd(ROUND_POWER_OF_TWO(sum, FILTER_BITS), bd),
            1);
      else
        dst[x] = clip_pixel_highbd(ROUND_POWER_OF_TWO(sum, FILTER_BITS), bd);
      x_q4 += x_step_q4;
    }
    src += src_stride;
    dst += dst_stride;
  }
}

void av1_highbd_convolve_vert_c(const uint16_t *src, int src_stride,
                                uint16_t *dst, int dst_stride, int w, int h,
                                const InterpFilterParams filter_params,
                                const int subpel_y_q4, int y_step_q4, int avg,
                                int bd) {
  int x, y;
  int filter_size = filter_params.taps;
  src -= src_stride * (filter_size / 2 - 1);

  for (x = 0; x < w; ++x) {
    int y_q4 = subpel_y_q4;
    for (y = 0; y < h; ++y) {
      const uint16_t *const src_y = &src[(y_q4 >> SUBPEL_BITS) * src_stride];
      const int16_t *y_filter = av1_get_interp_filter_subpel_kernel(
          filter_params, y_q4 & SUBPEL_MASK);
      int k, sum = 0;
      for (k = 0; k < filter_size; ++k)
        sum += src_y[k * src_stride] * y_filter[k];
      if (avg) {
        dst[y * dst_stride] = ROUND_POWER_OF_TWO(
            dst[y * dst_stride] +
                clip_pixel_highbd(ROUND_POWER_OF_TWO(sum, FILTER_BITS), bd),
            1);
      } else {
        dst[y * dst_stride] =
            clip_pixel_highbd(ROUND_POWER_OF_TWO(sum, FILTER_BITS), bd);
      }
      y_q4 += y_step_q4;
    }
    ++src;
    ++dst;
  }
}

static void highbd_convolve_copy(const uint16_t *src, int src_stride,
                                 uint16_t *dst, int dst_stride, int w, int h,
                                 int avg, int bd) {
  if (avg == 0) {
    int r;
    for (r = 0; r < h; ++r) {
      memcpy(dst, src, w * sizeof(*src));
      src += src_stride;
      dst += dst_stride;
    }
  } else {
    int r, c;
    for (r = 0; r < h; ++r) {
      for (c = 0; c < w; ++c) {
        dst[c] = clip_pixel_highbd(ROUND_POWER_OF_TWO(dst[c] + src[c], 1), bd);
      }
      src += src_stride;
      dst += dst_stride;
    }
  }
}

void av1_highbd_convolve_horiz_facade(const uint8_t *src8, int src_stride,
                                      uint8_t *dst8, int dst_stride, int w,
                                      int h,
                                      const InterpFilterParams filter_params,
                                      const int subpel_x_q4, int x_step_q4,
                                      int avg, int bd) {
  uint16_t *src = CONVERT_TO_SHORTPTR(src8);
  uint16_t *dst = CONVERT_TO_SHORTPTR(dst8);
  if (filter_params.taps == SUBPEL_TAPS) {
    const int16_t *filter_x =
        av1_get_interp_filter_subpel_kernel(filter_params, subpel_x_q4);
    if (avg == 0)
      aom_highbd_convolve8_horiz(src8, src_stride, dst8, dst_stride, filter_x,
                                 x_step_q4, NULL, -1, w, h, bd);
    else
      aom_highbd_convolve8_avg_horiz(src8, src_stride, dst8, dst_stride,
                                     filter_x, x_step_q4, NULL, -1, w, h, bd);
  } else {
    av1_highbd_convolve_horiz(src, src_stride, dst, dst_stride, w, h,
                              filter_params, subpel_x_q4, x_step_q4, avg, bd);
  }
}

void av1_highbd_convolve_vert_facade(const uint8_t *src8, int src_stride,
                                     uint8_t *dst8, int dst_stride, int w,
                                     int h,
                                     const InterpFilterParams filter_params,
                                     const int subpel_y_q4, int y_step_q4,
                                     int avg, int bd) {
  uint16_t *src = CONVERT_TO_SHORTPTR(src8);
  uint16_t *dst = CONVERT_TO_SHORTPTR(dst8);

  if (filter_params.taps == SUBPEL_TAPS) {
    const int16_t *filter_y =
        av1_get_interp_filter_subpel_kernel(filter_params, subpel_y_q4);
    if (avg == 0) {
      aom_highbd_convolve8_vert(src8, src_stride, dst8, dst_stride, NULL, -1,
                                filter_y, y_step_q4, w, h, bd);
    } else {
      aom_highbd_convolve8_avg_vert(src8, src_stride, dst8, dst_stride, NULL,
                                    -1, filter_y, y_step_q4, w, h, bd);
    }
  } else {
    av1_highbd_convolve_vert(src, src_stride, dst, dst_stride, w, h,
                             filter_params, subpel_y_q4, y_step_q4, avg, bd);
  }
}

void av1_highbd_convolve(const uint8_t *src8, int src_stride, uint8_t *dst8,
                         int dst_stride, int w, int h,
#if CONFIG_DUAL_FILTER
                         const InterpFilter *interp_filter,
#else
                         const InterpFilter interp_filter,
#endif
                         const int subpel_x_q4, int x_step_q4,
                         const int subpel_y_q4, int y_step_q4, int ref_idx,
                         int bd) {
  uint16_t *src = CONVERT_TO_SHORTPTR(src8);
  uint16_t *dst = CONVERT_TO_SHORTPTR(dst8);
  int ignore_horiz = x_step_q4 == 16 && subpel_x_q4 == 0;
  int ignore_vert = y_step_q4 == 16 && subpel_y_q4 == 0;

  assert(w <= MAX_BLOCK_WIDTH);
  assert(h <= MAX_BLOCK_HEIGHT);
  assert(y_step_q4 <= MAX_STEP);
  assert(x_step_q4 <= MAX_STEP);

  if (ignore_horiz && ignore_vert) {
    highbd_convolve_copy(src, src_stride, dst, dst_stride, w, h, ref_idx, bd);
  } else if (ignore_vert) {
#if CONFIG_DUAL_FILTER
    InterpFilterParams filter_params =
        av1_get_interp_filter_params(interp_filter[1 + 2 * ref_idx]);
#else
    InterpFilterParams filter_params =
        av1_get_interp_filter_params(interp_filter);
#endif
    av1_highbd_convolve_horiz_facade(src8, src_stride, dst8, dst_stride, w, h,
                                     filter_params, subpel_x_q4, x_step_q4,
                                     ref_idx, bd);
  } else if (ignore_horiz) {
#if CONFIG_DUAL_FILTER
    InterpFilterParams filter_params =
        av1_get_interp_filter_params(interp_filter[0 + 2 * ref_idx]);
#else
    InterpFilterParams filter_params =
        av1_get_interp_filter_params(interp_filter);
#endif
    av1_highbd_convolve_vert_facade(src8, src_stride, dst8, dst_stride, w, h,
                                    filter_params, subpel_y_q4, y_step_q4,
                                    ref_idx, bd);
  } else {
    // temp's size is set to a 256 aligned value to facilitate SIMD
    // implementation. The value is greater than (maximum possible intermediate
    // height or width) * MAX_SB_SIZE
    DECLARE_ALIGNED(16, uint16_t,
                    temp[((MAX_SB_SIZE * 2 + 16) + 16) * MAX_SB_SIZE]);
    uint8_t *temp8 = CONVERT_TO_BYTEPTR(temp);
    int max_intermediate_size = ((MAX_SB_SIZE * 2 + 16) + 16);
    int filter_size;
    InterpFilterParams filter_params;
#if CONFIG_DUAL_FILTER
    InterpFilterParams filter_params_x =
        av1_get_interp_filter_params(interp_filter[1 + 2 * ref_idx]);
    InterpFilterParams filter_params_y =
        av1_get_interp_filter_params(interp_filter[0 + 2 * ref_idx]);
#endif

#if CONFIG_DUAL_FILTER && USE_EXTRA_FILTER
    if (interp_filter[0 + 2 * ref_idx] == MULTITAP_SHARP &&
        interp_filter[1 + 2 * ref_idx] == MULTITAP_SHARP) {
      // Avoid two directions both using 12-tap filter.
      // This will reduce hardware implementation cost.
      filter_params_y = av1_get_interp_filter_params(EIGHTTAP_SHARP);
    }
    if (filter_params_y.taps < filter_params_x.taps) {
      int intermediate_width;
      int temp_stride = max_intermediate_size;
      filter_params = filter_params_y;
      filter_size = filter_params_x.taps;
      intermediate_width =
          (((w - 1) * x_step_q4 + subpel_x_q4) >> SUBPEL_BITS) + filter_size;
      assert(intermediate_width <= max_intermediate_size);

      assert(filter_params.taps <= MAX_FILTER_TAP);

      av1_highbd_convolve_vert_facade(
          src8 - (filter_size / 2 - 1), src_stride, temp8, temp_stride,
          intermediate_width, h, filter_params, subpel_y_q4, y_step_q4, 0, bd);

      filter_params = filter_params_x;
      assert(filter_params.taps <= MAX_FILTER_TAP);

      av1_highbd_convolve_horiz_facade(
          temp8 + (filter_size / 2 - 1), temp_stride, dst8, dst_stride, w, h,
          filter_params, subpel_x_q4, x_step_q4, ref_idx, bd);
    } else
#endif  // CONFIG_DUAL_FILTER && USE_EXTRA_FILTER
    {
      int intermediate_height;
      int temp_stride = MAX_SB_SIZE;
#if CONFIG_DUAL_FILTER
      filter_params = filter_params_x;
      filter_size = filter_params_y.taps;
#else
      filter_params = av1_get_interp_filter_params(interp_filter);
      filter_size = filter_params.taps;
#endif
      intermediate_height =
          (((h - 1) * y_step_q4 + subpel_y_q4) >> SUBPEL_BITS) + filter_size;
      assert(intermediate_height <= max_intermediate_size);
      (void)max_intermediate_size;

      av1_highbd_convolve_horiz_facade(
          src8 - src_stride * (filter_size / 2 - 1), src_stride, temp8,
          temp_stride, w, intermediate_height, filter_params, subpel_x_q4,
          x_step_q4, 0, bd);

#if CONFIG_DUAL_FILTER
      filter_params = filter_params_y;
#endif
      filter_size = filter_params.taps;
      assert(filter_params.taps <= MAX_FILTER_TAP);

      av1_highbd_convolve_vert_facade(
          temp8 + temp_stride * (filter_size / 2 - 1), temp_stride, dst8,
          dst_stride, w, h, filter_params, subpel_y_q4, y_step_q4, ref_idx, bd);
    }
  }
}
#endif  // CONFIG_HIGHBITDEPTH
