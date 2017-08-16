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

#include <math.h>
#include <limits.h>

#include "./aom_config.h"
#include "av1/common/alloccommon.h"
#include "av1/common/onyxc_int.h"
#include "av1/common/quant_common.h"
#include "av1/common/reconinter.h"
#include "av1/common/odintrin.h"
#include "av1/encoder/av1_quantize.h"
#include "av1/encoder/extend.h"
#include "av1/encoder/firstpass.h"
#include "av1/encoder/mcomp.h"
#include "av1/encoder/encoder.h"
#include "av1/encoder/ratectrl.h"
#include "av1/encoder/segmentation.h"
#include "av1/encoder/temporal_filter.h"
#include "aom_dsp/aom_dsp_common.h"
#include "aom_mem/aom_mem.h"
#include "aom_ports/mem.h"
#include "aom_ports/aom_timer.h"
#include "aom_scale/aom_scale.h"

static void temporal_filter_predictors_mb_c(
    MACROBLOCKD *xd, uint8_t *y_mb_ptr, uint8_t *u_mb_ptr, uint8_t *v_mb_ptr,
    int stride, int uv_block_width, int uv_block_height, int mv_row, int mv_col,
    uint8_t *pred, struct scale_factors *scale, int x, int y) {
  const int which_mv = 0;
  const MV mv = { mv_row, mv_col };
  enum mv_precision mv_precision_uv;
  int uv_stride;
  // TODO(angiebird): change plane setting accordingly
  ConvolveParams conv_params = get_conv_params(which_mv, 0);

#if USE_TEMPORALFILTER_12TAP
#if CONFIG_DUAL_FILTER
  const InterpFilter interp_filter[4] = { TEMPORALFILTER_12TAP,
                                          TEMPORALFILTER_12TAP,
                                          TEMPORALFILTER_12TAP,
                                          TEMPORALFILTER_12TAP };
#else
  const InterpFilter interp_filter = TEMPORALFILTER_12TAP;
#endif
  (void)xd;
#else
  const InterpFilter interp_filter = xd->mi[0]->mbmi.interp_filter;
#endif  // USE_TEMPORALFILTER_12TAP
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
  WarpTypesAllowed warp_types;
  memset(&warp_types, 0, sizeof(WarpTypesAllowed));
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION

  if (uv_block_width == 8) {
    uv_stride = (stride + 1) >> 1;
    mv_precision_uv = MV_PRECISION_Q4;
  } else {
    uv_stride = stride;
    mv_precision_uv = MV_PRECISION_Q3;
  }

#if CONFIG_HIGHBITDEPTH
  if (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH) {
    av1_highbd_build_inter_predictor(y_mb_ptr, stride, &pred[0], 16, &mv, scale,
                                     16, 16, which_mv, interp_filter,
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                                     &warp_types, x, y,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                                     0, MV_PRECISION_Q3, x, y, xd);

    av1_highbd_build_inter_predictor(u_mb_ptr, uv_stride, &pred[256],
                                     uv_block_width, &mv, scale, uv_block_width,
                                     uv_block_height, which_mv, interp_filter,
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                                     &warp_types, x, y,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                                     1, mv_precision_uv, x, y, xd);

    av1_highbd_build_inter_predictor(v_mb_ptr, uv_stride, &pred[512],
                                     uv_block_width, &mv, scale, uv_block_width,
                                     uv_block_height, which_mv, interp_filter,
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                                     &warp_types, x, y,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                                     2, mv_precision_uv, x, y, xd);
    return;
  }
#endif  // CONFIG_HIGHBITDEPTH
  av1_build_inter_predictor(y_mb_ptr, stride, &pred[0], 16, &mv, scale, 16, 16,
                            &conv_params, interp_filter,
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                            &warp_types, x, y, 0, 0,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                            MV_PRECISION_Q3, x, y, xd);

  av1_build_inter_predictor(u_mb_ptr, uv_stride, &pred[256], uv_block_width,
                            &mv, scale, uv_block_width, uv_block_height,
                            &conv_params, interp_filter,
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                            &warp_types, x, y, 1, 0,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                            mv_precision_uv, x, y, xd);

  av1_build_inter_predictor(v_mb_ptr, uv_stride, &pred[512], uv_block_width,
                            &mv, scale, uv_block_width, uv_block_height,
                            &conv_params, interp_filter,
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                            &warp_types, x, y, 2, 0,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                            mv_precision_uv, x, y, xd);
}

void av1_temporal_filter_apply_c(uint8_t *frame1, unsigned int stride,
                                 uint8_t *frame2, unsigned int block_width,
                                 unsigned int block_height, int strength,
                                 int filter_weight, unsigned int *accumulator,
                                 uint16_t *count) {
  unsigned int i, j, k;
  int modifier;
  int byte = 0;
  const int rounding = strength > 0 ? 1 << (strength - 1) : 0;

  for (i = 0, k = 0; i < block_height; i++) {
    for (j = 0; j < block_width; j++, k++) {
      int pixel_value = *frame2;

      // non-local mean approach
      int diff_sse[9] = { 0 };
      int idx, idy, index = 0;

      for (idy = -1; idy <= 1; ++idy) {
        for (idx = -1; idx <= 1; ++idx) {
          int row = (int)i + idy;
          int col = (int)j + idx;

          if (row >= 0 && row < (int)block_height && col >= 0 &&
              col < (int)block_width) {
            int diff = frame1[byte + idy * (int)stride + idx] -
                       frame2[idy * (int)block_width + idx];
            diff_sse[index] = diff * diff;
            ++index;
          }
        }
      }

      assert(index > 0);

      modifier = 0;
      for (idx = 0; idx < 9; ++idx) modifier += diff_sse[idx];

      modifier *= 3;
      modifier /= index;

      ++frame2;

      modifier += rounding;
      modifier >>= strength;

      if (modifier > 16) modifier = 16;

      modifier = 16 - modifier;
      modifier *= filter_weight;

      count[k] += modifier;
      accumulator[k] += modifier * pixel_value;

      byte++;
    }

    byte += stride - block_width;
  }
}

#if CONFIG_HIGHBITDEPTH
void av1_highbd_temporal_filter_apply_c(
    uint8_t *frame1_8, unsigned int stride, uint8_t *frame2_8,
    unsigned int block_width, unsigned int block_height, int strength,
    int filter_weight, unsigned int *accumulator, uint16_t *count) {
  uint16_t *frame1 = CONVERT_TO_SHORTPTR(frame1_8);
  uint16_t *frame2 = CONVERT_TO_SHORTPTR(frame2_8);
  unsigned int i, j, k;
  int modifier;
  int byte = 0;
  const int rounding = strength > 0 ? 1 << (strength - 1) : 0;

  for (i = 0, k = 0; i < block_height; i++) {
    for (j = 0; j < block_width; j++, k++) {
      int pixel_value = *frame2;

      // non-local mean approach
      int diff_sse[9] = { 0 };
      int idx, idy, index = 0;

      for (idy = -1; idy <= 1; ++idy) {
        for (idx = -1; idx <= 1; ++idx) {
          int row = (int)i + idy;
          int col = (int)j + idx;

          if (row >= 0 && row < (int)block_height && col >= 0 &&
              col < (int)block_width) {
            int diff = frame1[byte + idy * (int)stride + idx] -
                       frame2[idy * (int)block_width + idx];
            diff_sse[index] = diff * diff;
            ++index;
          }
        }
      }

      assert(index > 0);

      modifier = 0;
      for (idx = 0; idx < 9; ++idx) modifier += diff_sse[idx];

      modifier *= 3;
      modifier /= index;

      ++frame2;

      modifier += rounding;
      modifier >>= strength;

      if (modifier > 16) modifier = 16;

      modifier = 16 - modifier;
      modifier *= filter_weight;

      count[k] += modifier;
      accumulator[k] += modifier * pixel_value;

      byte++;
    }

    byte += stride - block_width;
  }
}
#endif  // CONFIG_HIGHBITDEPTH

static int temporal_filter_find_matching_mb_c(AV1_COMP *cpi,
                                              uint8_t *arf_frame_buf,
                                              uint8_t *frame_ptr_buf,
                                              int stride) {
  MACROBLOCK *const x = &cpi->td.mb;
  MACROBLOCKD *const xd = &x->e_mbd;
  const MV_SPEED_FEATURES *const mv_sf = &cpi->sf.mv;
  int step_param;
  int sadpb = x->sadperbit16;
  int bestsme = INT_MAX;
  int distortion;
  unsigned int sse;
  int cost_list[5];
  MvLimits tmp_mv_limits = x->mv_limits;

  MV best_ref_mv1 = { 0, 0 };
  MV best_ref_mv1_full; /* full-pixel value of best_ref_mv1 */

  // Save input state
  struct buf_2d src = x->plane[0].src;
  struct buf_2d pre = xd->plane[0].pre[0];

  best_ref_mv1_full.col = best_ref_mv1.col >> 3;
  best_ref_mv1_full.row = best_ref_mv1.row >> 3;

  // Setup frame pointers
  x->plane[0].src.buf = arf_frame_buf;
  x->plane[0].src.stride = stride;
  xd->plane[0].pre[0].buf = frame_ptr_buf;
  xd->plane[0].pre[0].stride = stride;

  step_param = mv_sf->reduce_first_step_size;
  step_param = AOMMIN(step_param, MAX_MVSEARCH_STEPS - 2);

  av1_set_mv_search_range(&x->mv_limits, &best_ref_mv1);

  x->mvcost = x->mv_cost_stack[0];
  x->nmvjointcost = x->nmv_vec_cost[0];

  // Use mv costing from x->mvcost directly
  av1_hex_search(x, &best_ref_mv1_full, step_param, sadpb, 1,
                 cond_cost_list(cpi, cost_list), &cpi->fn_ptr[BLOCK_16X16], 0,
                 &best_ref_mv1);

  x->mv_limits = tmp_mv_limits;

  // Ignore mv costing by sending NULL pointer instead of cost array
  bestsme = cpi->find_fractional_mv_step(
      x, &best_ref_mv1, cpi->common.allow_high_precision_mv, x->errorperbit,
      &cpi->fn_ptr[BLOCK_16X16], 0, mv_sf->subpel_iters_per_step,
      cond_cost_list(cpi, cost_list), NULL, NULL, &distortion, &sse, NULL,
#if CONFIG_EXT_INTER
      NULL, 0, 0,
#endif
      0, 0, 0);

  x->e_mbd.mi[0]->bmi[0].as_mv[0] = x->best_mv;

  // Restore input state
  x->plane[0].src = src;
  xd->plane[0].pre[0] = pre;

  return bestsme;
}

static void temporal_filter_iterate_c(AV1_COMP *cpi,
                                      YV12_BUFFER_CONFIG **frames,
                                      int frame_count, int alt_ref_index,
                                      int strength,
                                      struct scale_factors *scale) {
  int byte;
  int frame;
  int mb_col, mb_row;
  unsigned int filter_weight;
  int mb_cols = (frames[alt_ref_index]->y_crop_width + 15) >> 4;
  int mb_rows = (frames[alt_ref_index]->y_crop_height + 15) >> 4;
  int mb_y_offset = 0;
  int mb_uv_offset = 0;
  DECLARE_ALIGNED(16, unsigned int, accumulator[16 * 16 * 3]);
  DECLARE_ALIGNED(16, uint16_t, count[16 * 16 * 3]);
  MACROBLOCKD *mbd = &cpi->td.mb.e_mbd;
  YV12_BUFFER_CONFIG *f = frames[alt_ref_index];
  uint8_t *dst1, *dst2;
#if CONFIG_HIGHBITDEPTH
  DECLARE_ALIGNED(16, uint16_t, predictor16[16 * 16 * 3]);
  DECLARE_ALIGNED(16, uint8_t, predictor8[16 * 16 * 3]);
  uint8_t *predictor;
#else
  DECLARE_ALIGNED(16, uint8_t, predictor[16 * 16 * 3]);
#endif
  const int mb_uv_height = 16 >> mbd->plane[1].subsampling_y;
  const int mb_uv_width = 16 >> mbd->plane[1].subsampling_x;

  // Save input state
  uint8_t *input_buffer[MAX_MB_PLANE];
  int i;
#if CONFIG_HIGHBITDEPTH
  if (mbd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH) {
    predictor = CONVERT_TO_BYTEPTR(predictor16);
  } else {
    predictor = predictor8;
  }
#endif

  for (i = 0; i < MAX_MB_PLANE; i++) input_buffer[i] = mbd->plane[i].pre[0].buf;

  for (mb_row = 0; mb_row < mb_rows; mb_row++) {
    // Source frames are extended to 16 pixels. This is different than
    //  L/A/G reference frames that have a border of 32 (AV1ENCBORDERINPIXELS)
    // A 6/8 tap filter is used for motion search.  This requires 2 pixels
    //  before and 3 pixels after.  So the largest Y mv on a border would
    //  then be 16 - AOM_INTERP_EXTEND. The UV blocks are half the size of the
    //  Y and therefore only extended by 8.  The largest mv that a UV block
    //  can support is 8 - AOM_INTERP_EXTEND.  A UV mv is half of a Y mv.
    //  (16 - AOM_INTERP_EXTEND) >> 1 which is greater than
    //  8 - AOM_INTERP_EXTEND.
    // To keep the mv in play for both Y and UV planes the max that it
    //  can be on a border is therefore 16 - (2*AOM_INTERP_EXTEND+1).
    cpi->td.mb.mv_limits.row_min =
        -((mb_row * 16) + (17 - 2 * AOM_INTERP_EXTEND));
    cpi->td.mb.mv_limits.row_max =
        ((mb_rows - 1 - mb_row) * 16) + (17 - 2 * AOM_INTERP_EXTEND);

    for (mb_col = 0; mb_col < mb_cols; mb_col++) {
      int j, k;
      int stride;

      memset(accumulator, 0, 16 * 16 * 3 * sizeof(accumulator[0]));
      memset(count, 0, 16 * 16 * 3 * sizeof(count[0]));

      cpi->td.mb.mv_limits.col_min =
          -((mb_col * 16) + (17 - 2 * AOM_INTERP_EXTEND));
      cpi->td.mb.mv_limits.col_max =
          ((mb_cols - 1 - mb_col) * 16) + (17 - 2 * AOM_INTERP_EXTEND);

      for (frame = 0; frame < frame_count; frame++) {
        const int thresh_low = 10000;
        const int thresh_high = 20000;

        if (frames[frame] == NULL) continue;

        mbd->mi[0]->bmi[0].as_mv[0].as_mv.row = 0;
        mbd->mi[0]->bmi[0].as_mv[0].as_mv.col = 0;

        if (frame == alt_ref_index) {
          filter_weight = 2;
        } else {
          // Find best match in this frame by MC
          int err = temporal_filter_find_matching_mb_c(
              cpi, frames[alt_ref_index]->y_buffer + mb_y_offset,
              frames[frame]->y_buffer + mb_y_offset, frames[frame]->y_stride);

          // Assign higher weight to matching MB if it's error
          // score is lower. If not applying MC default behavior
          // is to weight all MBs equal.
          filter_weight = err < thresh_low ? 2 : err < thresh_high ? 1 : 0;
        }

        if (filter_weight != 0) {
          // Construct the predictors
          temporal_filter_predictors_mb_c(
              mbd, frames[frame]->y_buffer + mb_y_offset,
              frames[frame]->u_buffer + mb_uv_offset,
              frames[frame]->v_buffer + mb_uv_offset, frames[frame]->y_stride,
              mb_uv_width, mb_uv_height, mbd->mi[0]->bmi[0].as_mv[0].as_mv.row,
              mbd->mi[0]->bmi[0].as_mv[0].as_mv.col, predictor, scale,
              mb_col * 16, mb_row * 16);

#if CONFIG_HIGHBITDEPTH
          if (mbd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH) {
            int adj_strength = strength + 2 * (mbd->bd - 8);
            // Apply the filter (YUV)
            av1_highbd_temporal_filter_apply(
                f->y_buffer + mb_y_offset, f->y_stride, predictor, 16, 16,
                adj_strength, filter_weight, accumulator, count);
            av1_highbd_temporal_filter_apply(
                f->u_buffer + mb_uv_offset, f->uv_stride, predictor + 256,
                mb_uv_width, mb_uv_height, adj_strength, filter_weight,
                accumulator + 256, count + 256);
            av1_highbd_temporal_filter_apply(
                f->v_buffer + mb_uv_offset, f->uv_stride, predictor + 512,
                mb_uv_width, mb_uv_height, adj_strength, filter_weight,
                accumulator + 512, count + 512);
          } else {
            // Apply the filter (YUV)
            av1_temporal_filter_apply_c(f->y_buffer + mb_y_offset, f->y_stride,
                                        predictor, 16, 16, strength,
                                        filter_weight, accumulator, count);
            av1_temporal_filter_apply_c(
                f->u_buffer + mb_uv_offset, f->uv_stride, predictor + 256,
                mb_uv_width, mb_uv_height, strength, filter_weight,
                accumulator + 256, count + 256);
            av1_temporal_filter_apply_c(
                f->v_buffer + mb_uv_offset, f->uv_stride, predictor + 512,
                mb_uv_width, mb_uv_height, strength, filter_weight,
                accumulator + 512, count + 512);
          }
#else
          // Apply the filter (YUV)
          av1_temporal_filter_apply_c(f->y_buffer + mb_y_offset, f->y_stride,
                                      predictor, 16, 16, strength,
                                      filter_weight, accumulator, count);
          av1_temporal_filter_apply_c(f->u_buffer + mb_uv_offset, f->uv_stride,
                                      predictor + 256, mb_uv_width,
                                      mb_uv_height, strength, filter_weight,
                                      accumulator + 256, count + 256);
          av1_temporal_filter_apply_c(f->v_buffer + mb_uv_offset, f->uv_stride,
                                      predictor + 512, mb_uv_width,
                                      mb_uv_height, strength, filter_weight,
                                      accumulator + 512, count + 512);
#endif  // CONFIG_HIGHBITDEPTH
        }
      }

#if CONFIG_HIGHBITDEPTH
      if (mbd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH) {
        uint16_t *dst1_16;
        uint16_t *dst2_16;
        // Normalize filter output to produce AltRef frame
        dst1 = cpi->alt_ref_buffer.y_buffer;
        dst1_16 = CONVERT_TO_SHORTPTR(dst1);
        stride = cpi->alt_ref_buffer.y_stride;
        byte = mb_y_offset;
        for (i = 0, k = 0; i < 16; i++) {
          for (j = 0; j < 16; j++, k++) {
            dst1_16[byte] =
                (uint16_t)OD_DIVU(accumulator[k] + (count[k] >> 1), count[k]);

            // move to next pixel
            byte++;
          }

          byte += stride - 16;
        }

        dst1 = cpi->alt_ref_buffer.u_buffer;
        dst2 = cpi->alt_ref_buffer.v_buffer;
        dst1_16 = CONVERT_TO_SHORTPTR(dst1);
        dst2_16 = CONVERT_TO_SHORTPTR(dst2);
        stride = cpi->alt_ref_buffer.uv_stride;
        byte = mb_uv_offset;
        for (i = 0, k = 256; i < mb_uv_height; i++) {
          for (j = 0; j < mb_uv_width; j++, k++) {
            int m = k + 256;

            // U
            dst1_16[byte] =
                (uint16_t)OD_DIVU(accumulator[k] + (count[k] >> 1), count[k]);

            // V
            dst2_16[byte] =
                (uint16_t)OD_DIVU(accumulator[m] + (count[m] >> 1), count[m]);

            // move to next pixel
            byte++;
          }

          byte += stride - mb_uv_width;
        }
      } else {
        // Normalize filter output to produce AltRef frame
        dst1 = cpi->alt_ref_buffer.y_buffer;
        stride = cpi->alt_ref_buffer.y_stride;
        byte = mb_y_offset;
        for (i = 0, k = 0; i < 16; i++) {
          for (j = 0; j < 16; j++, k++) {
            dst1[byte] =
                (uint8_t)OD_DIVU(accumulator[k] + (count[k] >> 1), count[k]);

            // move to next pixel
            byte++;
          }
          byte += stride - 16;
        }

        dst1 = cpi->alt_ref_buffer.u_buffer;
        dst2 = cpi->alt_ref_buffer.v_buffer;
        stride = cpi->alt_ref_buffer.uv_stride;
        byte = mb_uv_offset;
        for (i = 0, k = 256; i < mb_uv_height; i++) {
          for (j = 0; j < mb_uv_width; j++, k++) {
            int m = k + 256;

            // U
            dst1[byte] =
                (uint8_t)OD_DIVU(accumulator[k] + (count[k] >> 1), count[k]);

            // V
            dst2[byte] =
                (uint8_t)OD_DIVU(accumulator[m] + (count[m] >> 1), count[m]);

            // move to next pixel
            byte++;
          }
          byte += stride - mb_uv_width;
        }
      }
#else
      // Normalize filter output to produce AltRef frame
      dst1 = cpi->alt_ref_buffer.y_buffer;
      stride = cpi->alt_ref_buffer.y_stride;
      byte = mb_y_offset;
      for (i = 0, k = 0; i < 16; i++) {
        for (j = 0; j < 16; j++, k++) {
          dst1[byte] =
              (uint8_t)OD_DIVU(accumulator[k] + (count[k] >> 1), count[k]);

          // move to next pixel
          byte++;
        }
        byte += stride - 16;
      }

      dst1 = cpi->alt_ref_buffer.u_buffer;
      dst2 = cpi->alt_ref_buffer.v_buffer;
      stride = cpi->alt_ref_buffer.uv_stride;
      byte = mb_uv_offset;
      for (i = 0, k = 256; i < mb_uv_height; i++) {
        for (j = 0; j < mb_uv_width; j++, k++) {
          int m = k + 256;

          // U
          dst1[byte] =
              (uint8_t)OD_DIVU(accumulator[k] + (count[k] >> 1), count[k]);

          // V
          dst2[byte] =
              (uint8_t)OD_DIVU(accumulator[m] + (count[m] >> 1), count[m]);

          // move to next pixel
          byte++;
        }
        byte += stride - mb_uv_width;
      }
#endif  // CONFIG_HIGHBITDEPTH
      mb_y_offset += 16;
      mb_uv_offset += mb_uv_width;
    }
    mb_y_offset += 16 * (f->y_stride - mb_cols);
    mb_uv_offset += mb_uv_height * f->uv_stride - mb_uv_width * mb_cols;
  }

  // Restore input state
  for (i = 0; i < MAX_MB_PLANE; i++) mbd->plane[i].pre[0].buf = input_buffer[i];
}

// Apply buffer limits and context specific adjustments to arnr filter.
static void adjust_arnr_filter(AV1_COMP *cpi, int distance, int group_boost,
                               int *arnr_frames, int *arnr_strength) {
  const AV1EncoderConfig *const oxcf = &cpi->oxcf;
  const int frames_after_arf =
      av1_lookahead_depth(cpi->lookahead) - distance - 1;
  int frames_fwd = (cpi->oxcf.arnr_max_frames - 1) >> 1;
  int frames_bwd;
  int q, frames, strength;

  // Define the forward and backwards filter limits for this arnr group.
  if (frames_fwd > frames_after_arf) frames_fwd = frames_after_arf;
  if (frames_fwd > distance) frames_fwd = distance;

  frames_bwd = frames_fwd;

  // For even length filter there is one more frame backward
  // than forward: e.g. len=6 ==> bbbAff, len=7 ==> bbbAfff.
  if (frames_bwd < distance) frames_bwd += (oxcf->arnr_max_frames + 1) & 0x1;

  // Set the baseline active filter size.
  frames = frames_bwd + 1 + frames_fwd;

  // Adjust the strength based on active max q.
  if (cpi->common.current_video_frame > 1)
    q = ((int)av1_convert_qindex_to_q(cpi->rc.avg_frame_qindex[INTER_FRAME],
                                      cpi->common.bit_depth));
  else
    q = ((int)av1_convert_qindex_to_q(cpi->rc.avg_frame_qindex[KEY_FRAME],
                                      cpi->common.bit_depth));
  if (q > 16) {
    strength = oxcf->arnr_strength;
  } else {
    strength = oxcf->arnr_strength - ((16 - q) / 2);
    if (strength < 0) strength = 0;
  }

  // Adjust number of frames in filter and strength based on gf boost level.
  if (frames > group_boost / 150) {
    frames = group_boost / 150;
    frames += !(frames & 1);
  }

  if (strength > group_boost / 300) {
    strength = group_boost / 300;
  }

  // Adjustments for second level arf in multi arf case.
  if (cpi->oxcf.pass == 2 && cpi->multi_arf_allowed) {
    const GF_GROUP *const gf_group = &cpi->twopass.gf_group;
    if (gf_group->rf_level[gf_group->index] != GF_ARF_STD) {
      strength >>= 1;
    }
  }

  *arnr_frames = frames;
  *arnr_strength = strength;
}

void av1_temporal_filter(AV1_COMP *cpi, int distance) {
  RATE_CONTROL *const rc = &cpi->rc;
  int frame;
  int frames_to_blur;
  int start_frame;
  int strength;
  int frames_to_blur_backward;
  int frames_to_blur_forward;
  struct scale_factors sf;
  YV12_BUFFER_CONFIG *frames[MAX_LAG_BUFFERS] = { NULL };
#if CONFIG_EXT_REFS
  const GF_GROUP *const gf_group = &cpi->twopass.gf_group;
#endif

  // Apply context specific adjustments to the arnr filter parameters.
  adjust_arnr_filter(cpi, distance, rc->gfu_boost, &frames_to_blur, &strength);
// TODO(weitinglin): Currently, we enforce the filtering strength on
//                   extra ARFs' to be zeros. We should investigate in which
//                   case it is more beneficial to use non-zero strength
//                   filtering.
#if CONFIG_EXT_REFS
  if (gf_group->rf_level[gf_group->index] == GF_ARF_LOW) {
    strength = 0;
    frames_to_blur = 1;
  }
#endif

#if CONFIG_EXT_REFS
  if (strength == 0 && frames_to_blur == 1) {
    cpi->is_arf_filter_off[gf_group->arf_update_idx[gf_group->index]] = 1;
  } else {
    cpi->is_arf_filter_off[gf_group->arf_update_idx[gf_group->index]] = 0;
  }
#endif

  frames_to_blur_backward = (frames_to_blur / 2);
  frames_to_blur_forward = ((frames_to_blur - 1) / 2);
  start_frame = distance + frames_to_blur_forward;

  // Setup frame pointers, NULL indicates frame not included in filter.
  for (frame = 0; frame < frames_to_blur; ++frame) {
    const int which_buffer = start_frame - frame;
    struct lookahead_entry *buf =
        av1_lookahead_peek(cpi->lookahead, which_buffer);
    frames[frames_to_blur - 1 - frame] = &buf->img;
  }

  if (frames_to_blur > 0) {
// Setup scaling factors. Scaling on each of the arnr frames is not
// supported.
// ARF is produced at the native frame size and resized when coded.
#if CONFIG_HIGHBITDEPTH
    av1_setup_scale_factors_for_frame(
        &sf, frames[0]->y_crop_width, frames[0]->y_crop_height,
        frames[0]->y_crop_width, frames[0]->y_crop_height,
        cpi->common.use_highbitdepth);
#else
    av1_setup_scale_factors_for_frame(
        &sf, frames[0]->y_crop_width, frames[0]->y_crop_height,
        frames[0]->y_crop_width, frames[0]->y_crop_height);
#endif  // CONFIG_HIGHBITDEPTH
  }

  temporal_filter_iterate_c(cpi, frames, frames_to_blur,
                            frames_to_blur_backward, strength, &sf);
}
