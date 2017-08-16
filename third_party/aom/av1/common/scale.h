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

#ifndef AV1_COMMON_SCALE_H_
#define AV1_COMMON_SCALE_H_

#include "av1/common/mv.h"
#include "aom_dsp/aom_convolve.h"

#ifdef __cplusplus
extern "C" {
#endif

#define REF_SCALE_SHIFT 14
#define REF_NO_SCALE (1 << REF_SCALE_SHIFT)
#define REF_INVALID_SCALE -1

struct scale_factors {
  int x_scale_fp;  // horizontal fixed point scale factor
  int y_scale_fp;  // vertical fixed point scale factor
  int x_step_q4;
  int y_step_q4;

  int (*scale_value_x)(int val, const struct scale_factors *sf);
  int (*scale_value_y)(int val, const struct scale_factors *sf);

  convolve_fn_t predict[2][2][2];  // horiz, vert, avg
#if CONFIG_HIGHBITDEPTH
  highbd_convolve_fn_t highbd_predict[2][2][2];  // horiz, vert, avg
#endif                                           // CONFIG_HIGHBITDEPTH
};

MV32 av1_scale_mv(const MV *mv, int x, int y, const struct scale_factors *sf);

#if CONFIG_HIGHBITDEPTH
void av1_setup_scale_factors_for_frame(struct scale_factors *sf, int other_w,
                                       int other_h, int this_w, int this_h,
                                       int use_high);
#else
void av1_setup_scale_factors_for_frame(struct scale_factors *sf, int other_w,
                                       int other_h, int this_w, int this_h);
#endif  // CONFIG_HIGHBITDEPTH

static INLINE int av1_is_valid_scale(const struct scale_factors *sf) {
  return sf->x_scale_fp != REF_INVALID_SCALE &&
         sf->y_scale_fp != REF_INVALID_SCALE;
}

static INLINE int av1_is_scaled(const struct scale_factors *sf) {
  return av1_is_valid_scale(sf) &&
         (sf->x_scale_fp != REF_NO_SCALE || sf->y_scale_fp != REF_NO_SCALE);
}

static INLINE int valid_ref_frame_size(int ref_width, int ref_height,
                                       int this_width, int this_height) {
  return 2 * this_width >= ref_width && 2 * this_height >= ref_height &&
         this_width <= 16 * ref_width && this_height <= 16 * ref_height;
}

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // AV1_COMMON_SCALE_H_
