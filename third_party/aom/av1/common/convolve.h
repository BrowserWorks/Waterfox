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

#ifndef AV1_COMMON_AV1_CONVOLVE_H_
#define AV1_COMMON_AV1_CONVOLVE_H_
#include "av1/common/filter.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef enum CONVOLVE_OPT {
  // indicate the results in dst buf is rounded by FILTER_BITS or not
  CONVOLVE_OPT_ROUND,
  CONVOLVE_OPT_NO_ROUND,
} CONVOLVE_OPT;

typedef int32_t CONV_BUF_TYPE;

typedef struct ConvolveParams {
  int ref;
  CONVOLVE_OPT round;
  CONV_BUF_TYPE *dst;
  int dst_stride;
  int round_0;
  int round_1;
  int plane;
  int do_post_rounding;
} ConvolveParams;

static INLINE ConvolveParams get_conv_params(int ref, int plane) {
  ConvolveParams conv_params;
  conv_params.ref = ref;
  conv_params.round = CONVOLVE_OPT_ROUND;
  conv_params.plane = plane;
  conv_params.do_post_rounding = 0;
  return conv_params;
}
struct AV1Common;
void av1_convolve_init(struct AV1Common *cm);
#if CONFIG_CONVOLVE_ROUND
void av1_convolve_2d(const uint8_t *src, int src_stride, CONV_BUF_TYPE *dst,
                     int dst_stride, int w, int h,
                     InterpFilterParams *filter_params_x,
                     InterpFilterParams *filter_params_y, const int subpel_x_q4,
                     const int subpel_y_q4, ConvolveParams *conv_params);

void av1_convolve_2d_facade(const uint8_t *src, int src_stride, uint8_t *dst,
                            int dst_stride, int w, int h,
                            const InterpFilter *interp_filter,
                            const int subpel_x_q4, int x_step_q4,
                            const int subpel_y_q4, int y_step_q4,
                            ConvolveParams *conv_params);

static INLINE ConvolveParams get_conv_params_no_round(int ref, int plane,
                                                      int32_t *dst,
                                                      int dst_stride) {
  ConvolveParams conv_params;
  conv_params.ref = ref;
  conv_params.round = CONVOLVE_OPT_NO_ROUND;
#if CONFIG_COMPOUND_ROUND
  conv_params.round_0 = FILTER_BITS;
#else
  conv_params.round_0 = 5;
#endif
  conv_params.round_1 = 0;
  conv_params.dst = dst;
  conv_params.dst_stride = dst_stride;
  conv_params.plane = plane;
  conv_params.do_post_rounding = 0;
  return conv_params;
}

void av1_convolve_rounding(const int32_t *src, int src_stride, uint8_t *dst,
                           int dst_stride, int w, int h, int bits);

#if CONFIG_HIGHBITDEPTH
void av1_highbd_convolve_rounding(const int32_t *src, int src_stride,
                                  uint8_t *dst8, int dst_stride, int w, int h,
                                  int bits, int bd);

void av1_highbd_convolve_2d(const uint16_t *src, int src_stride,
                            CONV_BUF_TYPE *dst, int dst_stride, int w, int h,
                            InterpFilterParams *filter_params_x,
                            InterpFilterParams *filter_params_y,
                            const int subpel_x_q4, const int subpel_y_q4,
                            ConvolveParams *conv_params, int bd);

void av1_highbd_convolve_2d_facade(const uint8_t *src8, int src_stride,
                                   uint8_t *dst, int dst_stride, int w, int h,
                                   const InterpFilter *interp_filter,
                                   const int subpel_x_q4, int x_step_q4,
                                   const int subpel_y_q4, int y_step_q4,
                                   ConvolveParams *conv_params, int bd);
#endif
#endif  // CONFIG_CONVOLVE_ROUND

void av1_convolve(const uint8_t *src, int src_stride, uint8_t *dst,
                  int dst_stride, int w, int h,
#if CONFIG_DUAL_FILTER
                  const InterpFilter *interp_filter,
#else
                  const InterpFilter interp_filter,
#endif
                  const int subpel_x, int xstep, const int subpel_y, int ystep,
                  ConvolveParams *conv_params);

void av1_convolve_c(const uint8_t *src, int src_stride, uint8_t *dst,
                    int dst_stride, int w, int h,
#if CONFIG_DUAL_FILTER
                    const InterpFilter *interp_filter,
#else
                    const InterpFilter interp_filter,
#endif
                    const int subpel_x, int xstep, const int subpel_y,
                    int ystep, ConvolveParams *conv_params);

#if CONFIG_HIGHBITDEPTH
void av1_highbd_convolve(const uint8_t *src, int src_stride, uint8_t *dst,
                         int dst_stride, int w, int h,
#if CONFIG_DUAL_FILTER
                         const InterpFilter *interp_filter,
#else
                         const InterpFilter interp_filter,
#endif
                         const int subpel_x, int xstep, const int subpel_y,
                         int ystep, int avg, int bd);
#endif  // CONFIG_HIGHBITDEPTH

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // AV1_COMMON_AV1_CONVOLVE_H_
