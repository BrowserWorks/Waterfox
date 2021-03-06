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

#include "config/aom_config.h"

#include "av1/common/alloccommon.h"
#include "av1/common/av1_common_int.h"
#include "av1/common/odintrin.h"
#include "av1/common/quant_common.h"
#include "av1/common/reconinter.h"
#include "av1/encoder/av1_quantize.h"
#include "av1/encoder/encoder.h"
#include "av1/encoder/extend.h"
#include "av1/encoder/firstpass.h"
#include "av1/encoder/mcomp.h"
#include "av1/encoder/ratectrl.h"
#include "av1/encoder/reconinter_enc.h"
#include "av1/encoder/segmentation.h"
#include "av1/encoder/temporal_filter.h"
#include "aom_dsp/aom_dsp_common.h"
#include "aom_mem/aom_mem.h"
#include "aom_ports/aom_timer.h"
#include "aom_ports/mem.h"
#include "aom_ports/system_state.h"
#include "aom_scale/aom_scale.h"

// NOTE: All `tf` in this file means `temporal filtering`.

// Does motion search for blocks in temporal filtering. This is the first step
// for temporal filtering. More specifically, given a frame to be filtered and
// another frame as reference, this function searches the reference frame to
// find out the most alike block as that from the frame to be filtered. This
// found block will be further used for weighted averaging.
// NOTE: Besides doing motion search for the entire block, this function will
// also do motion search for each 1/4 sub-block to get more precise prediction.
// Inputs:
//   cpi: Pointer to the composed information of input video.
//   frame_to_filter: Pointer to the frame to be filtered.
//   ref_frame: Pointer to the reference frame.
//   block_size: Block size used for motion search.
//   mb_row: Row index of the block in the entire frame.
//   mb_col: Column index of the block in the entire frame.
//   ref_mv: Reference motion vector, which is commonly inherited from the
//           motion search result of previous frame.
//   subblock_mvs: Pointer to the result motion vectors for 4 sub-blocks.
//   subblock_mses: Pointer to the search errors (MSE) for 4 sub-blocks.
// Returns:
//   Search error (MSE) of the entire block.
static int tf_motion_search(AV1_COMP *cpi,
                            const YV12_BUFFER_CONFIG *frame_to_filter,
                            const YV12_BUFFER_CONFIG *ref_frame,
                            const BLOCK_SIZE block_size, const int mb_row,
                            const int mb_col, MV *ref_mv, MV *subblock_mvs,
                            int *subblock_mses) {
  // Frame information
  const int min_frame_size = AOMMIN(cpi->common.width, cpi->common.height);

  // Block information (ONLY Y-plane is used for motion search).
  const int mb_height = block_size_high[block_size];
  const int mb_width = block_size_wide[block_size];
  const int mb_pels = mb_height * mb_width;
  const int y_stride = frame_to_filter->y_stride;
  assert(y_stride == ref_frame->y_stride);
  const int y_offset = mb_row * mb_height * y_stride + mb_col * mb_width;

  // Save input state.
  MACROBLOCK *const mb = &cpi->td.mb;
  MACROBLOCKD *const mbd = &mb->e_mbd;
  const struct buf_2d ori_src_buf = mb->plane[0].src;
  const struct buf_2d ori_pre_buf = mbd->plane[0].pre[0];
  const MV_COST_TYPE ori_mv_cost_type = mb->mv_cost_type;

  // Parameters used for motion search.
  FULLPEL_MOTION_SEARCH_PARAMS full_ms_params;
  SUBPEL_MOTION_SEARCH_PARAMS ms_params;

  const search_site_config ss_cfg =
      cpi->mv_search_params.ss_cfg[SS_CFG_LOOKAHEAD];
  const SEARCH_METHODS full_search_method = NSTEP;
  const int step_param = av1_init_search_range(
      AOMMAX(frame_to_filter->y_crop_width, frame_to_filter->y_crop_height));
  const SUBPEL_SEARCH_TYPE subpel_search_type = USE_8_TAPS;
  const int force_integer_mv = cpi->common.features.cur_frame_force_integer_mv;
  const MV_COST_TYPE mv_cost_type =
      min_frame_size >= 720
          ? MV_COST_L1_HDRES
          : (min_frame_size >= 480 ? MV_COST_L1_MIDRES : MV_COST_L1_LOWRES);

  // Starting position for motion search.
  FULLPEL_MV start_mv = get_fullmv_from_mv(ref_mv);
  // Baseline position for motion search (used for rate distortion comparison).
  const MV baseline_mv = kZeroMv;

  // Setup.
  mb->plane[0].src.buf = frame_to_filter->y_buffer + y_offset;
  mb->plane[0].src.stride = y_stride;
  mbd->plane[0].pre[0].buf = ref_frame->y_buffer + y_offset;
  mbd->plane[0].pre[0].stride = y_stride;
  // Unused intermediate results for motion search.
  unsigned int sse, error;
  int distortion;
  int cost_list[5];

  // Do motion search.
  // NOTE: In `av1_full_pixel_search()` and `find_fractional_mv_step()`, the
  // searched result will be stored in `mb->best_mv`.
  int_mv best_mv;
  int block_mse = INT_MAX;
  mb->mv_cost_type = mv_cost_type;

  av1_make_default_fullpel_ms_params(&full_ms_params, cpi, mb, block_size,
                                     &baseline_mv, &ss_cfg);
  full_ms_params.run_mesh_search = 1;
  full_ms_params.search_method = full_search_method;
  av1_full_pixel_search(start_mv, &full_ms_params, step_param,
                        cond_cost_list(cpi, cost_list), &best_mv.as_fullmv,
                        NULL);

  // Since we are merely refining the result from full pixel search, we don't
  // need regularization for subpel search
  mb->mv_cost_type = MV_COST_NONE;
  if (force_integer_mv == 1) {  // Only do full search on the entire block.
    const int mv_row = best_mv.as_mv.row;
    const int mv_col = best_mv.as_mv.col;
    best_mv.as_mv.row = GET_MV_SUBPEL(mv_row);
    best_mv.as_mv.col = GET_MV_SUBPEL(mv_col);
    const int mv_offset = mv_row * y_stride + mv_col;
    error = cpi->fn_ptr[block_size].vf(
        ref_frame->y_buffer + y_offset + mv_offset, y_stride,
        frame_to_filter->y_buffer + y_offset, y_stride, &sse);
    block_mse = DIVIDE_AND_ROUND(error, mb_pels);
    mb->e_mbd.mi[0]->mv[0] = best_mv;
  } else {  // Do fractional search on the entire block and all sub-blocks.
    av1_make_default_subpel_ms_params(&ms_params, cpi, mb, block_size,
                                      &baseline_mv, cost_list);
    ms_params.forced_stop = EIGHTH_PEL;
    ms_params.var_params.subpel_search_type = subpel_search_type;
    MV subpel_start_mv = get_mv_from_fullmv(&best_mv.as_fullmv);
    error = cpi->mv_search_params.find_fractional_mv_step(
        &mb->e_mbd, &cpi->common, &ms_params, subpel_start_mv, &best_mv.as_mv,
        &distortion, &sse, NULL);
    block_mse = DIVIDE_AND_ROUND(error, mb_pels);
    mb->e_mbd.mi[0]->mv[0] = best_mv;
    *ref_mv = best_mv.as_mv;
    // On 4 sub-blocks.
    const BLOCK_SIZE subblock_size = ss_size_lookup[block_size][1][1];
    const int subblock_height = block_size_high[subblock_size];
    const int subblock_width = block_size_wide[subblock_size];
    const int subblock_pels = subblock_height * subblock_width;
    start_mv = get_fullmv_from_mv(ref_mv);

    int subblock_idx = 0;
    for (int i = 0; i < mb_height; i += subblock_height) {
      for (int j = 0; j < mb_width; j += subblock_width) {
        const int offset = i * y_stride + j;
        mb->plane[0].src.buf = frame_to_filter->y_buffer + y_offset + offset;
        mbd->plane[0].pre[0].buf = ref_frame->y_buffer + y_offset + offset;
        mb->mv_cost_type = mv_cost_type;

        av1_make_default_fullpel_ms_params(
            &full_ms_params, cpi, mb, subblock_size, &baseline_mv, &ss_cfg);
        full_ms_params.run_mesh_search = 1;
        full_ms_params.search_method = full_search_method;
        av1_full_pixel_search(start_mv, &full_ms_params, step_param,
                              cond_cost_list(cpi, cost_list),
                              &best_mv.as_fullmv, NULL);

        // Since we are merely refining the result from full pixel search, we
        // don't need regularization for subpel search
        mb->mv_cost_type = MV_COST_NONE;
        av1_make_default_subpel_ms_params(&ms_params, cpi, mb, subblock_size,
                                          &baseline_mv, cost_list);
        ms_params.forced_stop = EIGHTH_PEL;
        ms_params.var_params.subpel_search_type = subpel_search_type;
        subpel_start_mv = get_mv_from_fullmv(&best_mv.as_fullmv);
        error = cpi->mv_search_params.find_fractional_mv_step(
            &mb->e_mbd, &cpi->common, &ms_params, subpel_start_mv,
            &best_mv.as_mv, &distortion, &sse, NULL);
        subblock_mses[subblock_idx] = DIVIDE_AND_ROUND(error, subblock_pels);
        subblock_mvs[subblock_idx] = best_mv.as_mv;
        ++subblock_idx;
      }
    }
  }

  // Restore input state.
  mb->plane[0].src = ori_src_buf;
  mbd->plane[0].pre[0] = ori_pre_buf;
  mb->mv_cost_type = ori_mv_cost_type;

  return block_mse;
}

// Helper function to get weight according to thresholds.
static INLINE int get_weight_by_thresh(const int value, const int low,
                                       const int high) {
  return value < low ? 2 : value < high ? 1 : 0;
}

// Gets filter weight for blocks in temporal filtering. The weights will be
// assigned based on the motion search errors.
// NOTE: Besides assigning filter weight for the block, this function will also
// determine whether to split the entire block into 4 sub-blocks for further
// filtering.
// TODO(any): Many magic numbers are used in this function. They may be tuned
// to improve the performance.
// Inputs:
//   block_mse: Motion search error (MSE) for the entire block.
//   subblock_mses: Pointer to the search errors (MSE) for 4 sub-blocks.
//   is_second_arf: Whether the to-filter frame is the second ARF. This field
//                  will affect the filter weight for the to-filter frame.
//   subblock_filter_weights: Pointer to the assigned filter weight for each
//                            sub-block. If not using sub-blocks, the first
//                            element will be used for the entire block.
// Returns: Whether to use 4 sub-blocks to replace the original block.
static int tf_get_filter_weight(const int block_mse, const int *subblock_mses,
                                const int is_second_arf,
                                int *subblock_filter_weights) {
  // `block_mse` is initialized as INT_MAX and will be overwritten after the
  // motion search with reference frame, therefore INT_MAX can ONLY be accessed
  // by to-filter frame.
  if (block_mse == INT_MAX) {
    const int weight = TF_ENABLE_PLANEWISE_STRATEGY
                           ? TF_PLANEWISE_FILTER_WEIGHT_SCALE
                           : is_second_arf ? 64 : 32;
    subblock_filter_weights[0] = subblock_filter_weights[1] =
        subblock_filter_weights[2] = subblock_filter_weights[3] = weight;
    return 0;
  }

  const int thresh_low = is_second_arf ? 20 : 40;
  const int thresh_high = is_second_arf ? 40 : 80;

  int min_subblock_mse = INT_MAX;
  int max_subblock_mse = INT_MIN;
  int sum_subblock_mse = 0;
  for (int i = 0; i < 4; ++i) {
    sum_subblock_mse += subblock_mses[i];
    min_subblock_mse = AOMMIN(min_subblock_mse, subblock_mses[i]);
    max_subblock_mse = AOMMAX(max_subblock_mse, subblock_mses[i]);
    subblock_filter_weights[i] =
        get_weight_by_thresh(subblock_mses[i], thresh_low, thresh_high);
  }

  if (((block_mse * 15 < sum_subblock_mse * 4) &&
       max_subblock_mse - min_subblock_mse < 48) ||
      ((block_mse * 14 < sum_subblock_mse * 4) &&
       max_subblock_mse - min_subblock_mse < 24)) {  // No split.
    const int weight = get_weight_by_thresh(block_mse, thresh_low, thresh_high);
    subblock_filter_weights[0] = subblock_filter_weights[1] =
        subblock_filter_weights[2] = subblock_filter_weights[3] = weight;
    return 0;
  } else {  // Do split.
    return 1;
  }
}

// Helper function to determine whether a frame is encoded with high bit-depth.
static INLINE int is_frame_high_bitdepth(const YV12_BUFFER_CONFIG *frame) {
  return (frame->flags & YV12_FLAG_HIGHBITDEPTH) ? 1 : 0;
}

// Builds predictor for blocks in temporal filtering. This is the second step
// for temporal filtering, which is to construct predictions from all reference
// frames INCLUDING the frame to be filtered itself. These predictors are built
// based on the motion search results (motion vector is set as 0 for the frame
// to be filtered), and will be futher used for weighted averaging.
// Inputs:
//   ref_frame: Pointer to the reference frame (or the frame to be filtered).
//   mbd: Pointer to the block for filtering. Besides containing the subsampling
//        information of all planes, this field also gives the searched motion
//        vector for the entire block, i.e., `mbd->mi[0]->mv[0]`. This vector
//        should be 0 if the `ref_frame` itself is the frame to be filtered.
//   block_size: Size of the block.
//   mb_row: Row index of the block in the entire frame.
//   mb_col: Column index of the block in the entire frame.
//   num_planes: Number of planes in the frame.
//   scale: Scaling factor.
//   use_subblock: Whether to use 4 sub-blocks to replace the original block.
//   subblock_mvs: The motion vectors for each sub-block (row-major order).
//   pred: Pointer to the predictor to build.
// Returns:
//   Nothing will be returned. But the content to which `pred` points will be
//   modified.
static void tf_build_predictor(const YV12_BUFFER_CONFIG *ref_frame,
                               const MACROBLOCKD *mbd,
                               const BLOCK_SIZE block_size, const int mb_row,
                               const int mb_col, const int num_planes,
                               const struct scale_factors *scale,
                               const int use_subblock, const MV *subblock_mvs,
                               uint8_t *pred) {
  assert(num_planes >= 1 && num_planes <= MAX_MB_PLANE);

  // Information of the entire block.
  const int mb_height = block_size_high[block_size];  // Height.
  const int mb_width = block_size_wide[block_size];   // Width.
  const int mb_pels = mb_height * mb_width;           // Number of pixels.
  const int mb_y = mb_height * mb_row;                // Y-coord (Top-left).
  const int mb_x = mb_width * mb_col;                 // X-coord (Top-left).
  const int bit_depth = mbd->bd;                      // Bit depth.
  const int is_intrabc = 0;                           // Is intra-copied?
  const int mb_mv_row = mbd->mi[0]->mv[0].as_mv.row;  // Motion vector (y).
  const int mb_mv_col = mbd->mi[0]->mv[0].as_mv.col;  // Motion vector (x).
  const MV mb_mv = { (int16_t)mb_mv_row, (int16_t)mb_mv_col };
  const int is_high_bitdepth = is_frame_high_bitdepth(ref_frame);

  // Information of each sub-block (actually in use).
  const int num_blocks = use_subblock ? 2 : 1;  // Num of blocks on each side.
  const int block_height = mb_height >> (num_blocks - 1);  // Height.
  const int block_width = mb_width >> (num_blocks - 1);    // Width.

  // Default interpolation filters.
  const int_interpfilters interp_filters =
      av1_broadcast_interp_filter(MULTITAP_SHARP);

  // Handle Y-plane, U-plane and V-plane (if needed) in sequence.
  int plane_offset = 0;
  for (int plane = 0; plane < num_planes; ++plane) {
    const int subsampling_y = mbd->plane[plane].subsampling_y;
    const int subsampling_x = mbd->plane[plane].subsampling_x;
    // Information of each sub-block in current plane.
    const int plane_h = mb_height >> subsampling_y;  // Plane height.
    const int plane_w = mb_width >> subsampling_x;   // Plane width.
    const int plane_y = mb_y >> subsampling_y;       // Y-coord (Top-left).
    const int plane_x = mb_x >> subsampling_x;       // X-coord (Top-left).
    const int h = block_height >> subsampling_y;     // Sub-block height.
    const int w = block_width >> subsampling_x;      // Sub-block width.
    const int is_y_plane = (plane == 0);             // Is Y-plane?

    const struct buf_2d ref_buf = { NULL, ref_frame->buffers[plane],
                                    ref_frame->widths[is_y_plane ? 0 : 1],
                                    ref_frame->heights[is_y_plane ? 0 : 1],
                                    ref_frame->strides[is_y_plane ? 0 : 1] };

    // Handle entire block or sub-blocks if needed.
    int subblock_idx = 0;
    for (int i = 0; i < plane_h; i += h) {
      for (int j = 0; j < plane_w; j += w) {
        // Choose proper motion vector.
        const MV mv = use_subblock ? subblock_mvs[subblock_idx] : mb_mv;
        assert(mv.row >= INT16_MIN && mv.row <= INT16_MAX &&
               mv.col >= INT16_MIN && mv.col <= INT16_MAX);

        const int y = plane_y + i;
        const int x = plane_x + j;

        // Build predictior for each sub-block on current plane.
        InterPredParams inter_pred_params;
        av1_init_inter_params(&inter_pred_params, w, h, y, x, subsampling_x,
                              subsampling_y, bit_depth, is_high_bitdepth,
                              is_intrabc, scale, &ref_buf, interp_filters);
        inter_pred_params.conv_params = get_conv_params(0, plane, bit_depth);
        av1_enc_build_one_inter_predictor(&pred[plane_offset + i * plane_w + j],
                                          plane_w, &mv, &inter_pred_params);

        ++subblock_idx;
      }
    }
    plane_offset += mb_pels;
  }
}

// Computes temporal filter weights and accumulators for the frame to be
// filtered. More concretely, the filter weights for all pixels are the same.
// Inputs:
//   mbd: Pointer to the block for filtering, which is ONLY used to get
//        subsampling information of all planes as well as the bit-depth.
//   block_size: Size of the block.
//   num_planes: Number of planes in the frame.
//   filter_weight: Weight used for filtering.
//   pred: Pointer to the well-built predictors.
//   accum: Pointer to the pixel-wise accumulator for filtering.
//   count: Pointer to the pixel-wise counter fot filtering.
// Returns:
//   Nothing will be returned. But the content to which `accum` and `pred`
//   point will be modified.
void av1_apply_temporal_filter_self(const MACROBLOCKD *mbd,
                                    const BLOCK_SIZE block_size,
                                    const int num_planes,
                                    const int filter_weight,
                                    const uint8_t *pred, uint32_t *accum,
                                    uint16_t *count) {
  assert(num_planes >= 1 && num_planes <= MAX_MB_PLANE);

  // Block information.
  const int mb_height = block_size_high[block_size];
  const int mb_width = block_size_wide[block_size];
  const int mb_pels = mb_height * mb_width;
  const int is_high_bitdepth = is_cur_buf_hbd(mbd);
  const uint16_t *pred16 = CONVERT_TO_SHORTPTR(pred);

  int plane_offset = 0;
  for (int plane = 0; plane < num_planes; ++plane) {
    const int subsampling_y = mbd->plane[plane].subsampling_y;
    const int subsampling_x = mbd->plane[plane].subsampling_x;
    const int h = mb_height >> subsampling_y;  // Plane height.
    const int w = mb_width >> subsampling_x;   // Plane width.

    int pred_idx = 0;
    for (int i = 0; i < h; ++i) {
      for (int j = 0; j < w; ++j) {
        const int idx = plane_offset + pred_idx;  // Index with plane shift.
        const int pred_value = is_high_bitdepth ? pred16[idx] : pred[idx];
        accum[idx] += filter_weight * pred_value;
        count[idx] += filter_weight;
        ++pred_idx;
      }
    }
    plane_offset += mb_pels;
  }
}

// Function to compute pixel-wise squared difference between two buffers.
// Inputs:
//   ref: Pointer to reference buffer.
//   ref_offset: Start position of reference buffer for computation.
//   ref_stride: Stride for reference buffer.
//   tgt: Pointer to target buffer.
//   tgt_offset: Start position of target buffer for computation.
//   tgt_stride: Stride for target buffer.
//   height: Height of block for computation.
//   width: Width of block for computation.
//   is_high_bitdepth: Whether the two buffers point to high bit-depth frames.
//   square_diff: Pointer to save the squared differces.
// Returns:
//   Nothing will be returned. But the content to which `square_diff` points
//   will be modified.
static INLINE void compute_square_diff(const uint8_t *ref, const int ref_offset,
                                       const int ref_stride, const uint8_t *tgt,
                                       const int tgt_offset,
                                       const int tgt_stride, const int height,
                                       const int width,
                                       const int is_high_bitdepth,
                                       uint32_t *square_diff) {
  const uint16_t *ref16 = CONVERT_TO_SHORTPTR(ref);
  const uint16_t *tgt16 = CONVERT_TO_SHORTPTR(tgt);

  int ref_idx = 0;
  int tgt_idx = 0;
  int idx = 0;
  for (int i = 0; i < height; ++i) {
    for (int j = 0; j < width; ++j) {
      const uint16_t ref_value = is_high_bitdepth ? ref16[ref_offset + ref_idx]
                                                  : ref[ref_offset + ref_idx];
      const uint16_t tgt_value = is_high_bitdepth ? tgt16[tgt_offset + tgt_idx]
                                                  : tgt[tgt_offset + tgt_idx];
      const uint32_t diff = (ref_value > tgt_value) ? (ref_value - tgt_value)
                                                    : (tgt_value - ref_value);
      square_diff[idx] = diff * diff;

      ++ref_idx;
      ++tgt_idx;
      ++idx;
    }
    ref_idx += (ref_stride - width);
    tgt_idx += (tgt_stride - width);
  }
}

// Function to adjust the filter weight when use YUV strategy.
// Inputs:
//   filter_weight: Original filter weight.
//   sum_square_diff: Sum of squared difference between input frame and
//                    prediction. This field is computed pixel by pixel, and
//                    is used as a reference for the filter weight adjustment.
//   num_ref_pixels: Number of pixels used to compute the `sum_square_diff`.
//                   This field should align with the above lookup tables
//                   `filter_weight_adjustment_lookup_table_yuv` and
//                   `highbd_filter_weight_adjustment_lookup_table_yuv`.
//   strength: Strength for filter weight adjustment.
// Returns:
//   Adjusted filter weight which will finally be used for filtering.
static INLINE int adjust_filter_weight_yuv(const int filter_weight,
                                           const uint64_t sum_square_diff,
                                           const int num_ref_pixels,
                                           const int strength) {
  int modifier =
      (int)(AOMMIN(sum_square_diff * TF_YUV_FILTER_WEIGHT_SCALE, INT32_MAX)) /
      num_ref_pixels;
  const int rounding = (1 << strength) >> 1;
  modifier = (modifier + rounding) >> strength;
  return (modifier >= 16) ? 0 : (16 - modifier) * filter_weight;
}

// Applies temporal filter with YUV strategy.
// Inputs:
//   frame_to_filter: Pointer to the frame to be filtered, which is used as
//                    reference to compute squared differece from the predictor.
//   mbd: Pointer to the block for filtering, which is ONLY used to get
//        subsampling information of all YUV planes.
//   block_size: Size of the block.
//   mb_row: Row index of the block in the entire frame.
//   mb_col: Column index of the block in the entire frame.
//   num_planes: Number of planes in the frame.
//   strength: Strength for filter weight adjustment.
//   use_subblock: Whether to use 4 sub-blocks to replace the original block.
//   subblock_filter_weights: The filter weights for each sub-block (row-major
//                            order). If `use_subblock` is set as 0, the first
//                            weight will be applied to the entire block.
//   pred: Pointer to the well-built predictors.
//   accum: Pointer to the pixel-wise accumulator for filtering.
//   count: Pointer to the pixel-wise counter fot filtering.
// Returns:
//   Nothing will be returned. But the content to which `accum` and `pred`
//   point will be modified.
void av1_apply_temporal_filter_yuv_c(
    const YV12_BUFFER_CONFIG *frame_to_filter, const MACROBLOCKD *mbd,
    const BLOCK_SIZE block_size, const int mb_row, const int mb_col,
    const int num_planes, const int strength, const int use_subblock,
    const int *subblock_filter_weights, const uint8_t *pred, uint32_t *accum,
    uint16_t *count) {
  assert(num_planes >= 1 && num_planes <= MAX_MB_PLANE);

  // Block information.
  const int mb_height = block_size_high[block_size];
  const int mb_width = block_size_wide[block_size];
  const int mb_pels = mb_height * mb_width;
  const int is_high_bitdepth = is_frame_high_bitdepth(frame_to_filter);
  const uint16_t *pred16 = CONVERT_TO_SHORTPTR(pred);

  // Allocate memory for pixel-wise squared differences for all planes. They,
  // regardless of the subsampling, are assigned with memory of size `mb_pels`.
  uint32_t *square_diff =
      aom_memalign(16, num_planes * mb_pels * sizeof(uint32_t));
  memset(square_diff, 0, num_planes * mb_pels * sizeof(square_diff[0]));

  int plane_offset = 0;
  for (int plane = 0; plane < num_planes; ++plane) {
    // Locate pixel on reference frame.
    const int plane_h = mb_height >> mbd->plane[plane].subsampling_y;
    const int plane_w = mb_width >> mbd->plane[plane].subsampling_x;
    const int frame_stride = frame_to_filter->strides[plane == 0 ? 0 : 1];
    const int frame_offset = mb_row * plane_h * frame_stride + mb_col * plane_w;
    const uint8_t *ref = frame_to_filter->buffers[plane];
    compute_square_diff(ref, frame_offset, frame_stride, pred, plane_offset,
                        plane_w, plane_h, plane_w, is_high_bitdepth,
                        square_diff + plane_offset);
    plane_offset += mb_pels;
  }

  // Get window size for pixel-wise filtering.
  assert(TF_YUV_FILTER_WINDOW_LENGTH % 2 == 1);
  const int half_window = TF_YUV_FILTER_WINDOW_LENGTH >> 1;

  // Handle planes in sequence.
  plane_offset = 0;
  for (int plane = 0; plane < num_planes; ++plane) {
    const int subsampling_y = mbd->plane[plane].subsampling_y;
    const int subsampling_x = mbd->plane[plane].subsampling_x;
    const int h = mb_height >> subsampling_y;  // Plane height.
    const int w = mb_width >> subsampling_x;   // Plane width.

    // Perform filtering.
    int pred_idx = 0;
    for (int i = 0; i < h; ++i) {
      for (int j = 0; j < w; ++j) {
        // non-local mean approach
        uint64_t sum_square_diff = 0;
        int num_ref_pixels = 0;

        for (int wi = -half_window; wi <= half_window; ++wi) {
          for (int wj = -half_window; wj <= half_window; ++wj) {
            const int y = i + wi;  // Y-coord on the current plane.
            const int x = j + wj;  // X-coord on the current plane.
            if (y >= 0 && y < h && x >= 0 && x < w) {
              sum_square_diff += square_diff[plane_offset + y * w + x];
              ++num_ref_pixels;
            }
          }
        }

        if (plane == 0) {  // Filter Y-plane using both U-plane and V-plane.
          for (int p = 1; p < num_planes; ++p) {
            const int ss_y_shift = mbd->plane[p].subsampling_y - subsampling_y;
            const int ss_x_shift = mbd->plane[p].subsampling_x - subsampling_x;
            const int yy = i >> ss_y_shift;  // Y-coord on UV-plane.
            const int xx = j >> ss_x_shift;  // X-coord on UV-plane.
            const int ww = w >> ss_x_shift;  // Width of UV-plane.
            sum_square_diff += square_diff[p * mb_pels + yy * ww + xx];
            ++num_ref_pixels;
          }
        } else {  // Filter U-plane and V-plane using Y-plane.
          const int ss_y_shift = subsampling_y - mbd->plane[0].subsampling_y;
          const int ss_x_shift = subsampling_x - mbd->plane[0].subsampling_x;
          for (int ii = 0; ii < (1 << ss_y_shift); ++ii) {
            for (int jj = 0; jj < (1 << ss_x_shift); ++jj) {
              const int yy = (i << ss_y_shift) + ii;  // Y-coord on Y-plane.
              const int xx = (j << ss_x_shift) + jj;  // X-coord on Y-plane.
              const int ww = w << ss_x_shift;         // Width of Y-plane.
              sum_square_diff += square_diff[yy * ww + xx];
              ++num_ref_pixels;
            }
          }
        }

        // Base filter weight estimated by motion search error.
        const int subblock_idx =
            use_subblock ? (i >= h / 2) * 2 + (j >= w / 2) : 0;
        const int filter_weight = subblock_filter_weights[subblock_idx];

        const int idx = plane_offset + pred_idx;  // Index with plane shift.
        const int pred_value = is_high_bitdepth ? pred16[idx] : pred[idx];
        const int adjusted_weight = adjust_filter_weight_yuv(
            filter_weight, sum_square_diff, num_ref_pixels, strength);
        accum[idx] += adjusted_weight * pred_value;
        count[idx] += adjusted_weight;

        ++pred_idx;
      }
    }
    plane_offset += mb_pels;
  }

  aom_free(square_diff);
}

// Applies temporal filter with plane-wise strategy.
// The strategy of filter weight adjustment is different from the function
// `av1_apply_temporal_filter_yuv_c()`.
// Inputs:
//   frame_to_filter: Pointer to the frame to be filtered, which is used as
//                    reference to compute squared differece from the predictor.
//   mbd: Pointer to the block for filtering, which is ONLY used to get
//        subsampling information of all planes.
//   block_size: Size of the block.
//   mb_row: Row index of the block in the entire frame.
//   mb_col: Column index of the block in the entire frame.
//   num_planes: Number of planes in the frame.
//   noise_levels: Pointer to the noise levels of the to-filter frame, estimated
//                 with each plane (in Y, U, V order).
//   use_subblock: Whether to use 4 sub-blocks to replace the original block.
//   block_mse: Motion search error (MSE) for the entire block.
//   subblock_mses: Pointer to the search errors (MSE) for 4 sub-blocks.
//   q_factor: Quantization factor. This is actually the `q` defined in libaom,
//             which is converted from `qindex`.
//   pred: Pointer to the well-built predictors.
//   accum: Pointer to the pixel-wise accumulator for filtering.
//   count: Pointer to the pixel-wise counter fot filtering.
// Returns:
//   Nothing will be returned. But the content to which `accum` and `pred`
//   point will be modified.
void av1_apply_temporal_filter_planewise_c(
    const YV12_BUFFER_CONFIG *frame_to_filter, const MACROBLOCKD *mbd,
    const BLOCK_SIZE block_size, const int mb_row, const int mb_col,
    const int num_planes, const double *noise_levels, const int use_subblock,
    const int block_mse, const int *subblock_mses, const int q_factor,
    const uint8_t *pred, uint32_t *accum, uint16_t *count) {
  assert(num_planes >= 1 && num_planes <= MAX_MB_PLANE);

  // Block information.
  const int mb_height = block_size_high[block_size];
  const int mb_width = block_size_wide[block_size];
  const int mb_pels = mb_height * mb_width;
  const int is_high_bitdepth = is_frame_high_bitdepth(frame_to_filter);
  const uint16_t *pred16 = CONVERT_TO_SHORTPTR(pred);

  // Allocate memory for pixel-wise squared differences for all planes. They,
  // regardless of the subsampling, are assigned with memory of size `mb_pels`.
  uint32_t *square_diff =
      aom_memalign(16, num_planes * mb_pels * sizeof(uint32_t));
  memset(square_diff, 0, num_planes * mb_pels * sizeof(square_diff[0]));

  int plane_offset = 0;
  for (int plane = 0; plane < num_planes; ++plane) {
    // Locate pixel on reference frame.
    const int plane_h = mb_height >> mbd->plane[plane].subsampling_y;
    const int plane_w = mb_width >> mbd->plane[plane].subsampling_x;
    const int frame_stride = frame_to_filter->strides[plane == 0 ? 0 : 1];
    const int frame_offset = mb_row * plane_h * frame_stride + mb_col * plane_w;
    const uint8_t *ref = frame_to_filter->buffers[plane];
    compute_square_diff(ref, frame_offset, frame_stride, pred, plane_offset,
                        plane_w, plane_h, plane_w, is_high_bitdepth,
                        square_diff + plane_offset);
    plane_offset += mb_pels;
  }

  // Get window size for pixel-wise filtering.
  assert(TF_PLANEWISE_FILTER_WINDOW_LENGTH % 2 == 1);
  const int half_window = TF_PLANEWISE_FILTER_WINDOW_LENGTH >> 1;

  // Hyper-parameter for filter weight adjustment.
  const int frame_height = frame_to_filter->heights[0]
                           << mbd->plane[0].subsampling_y;
  const int decay_control = frame_height >= 720 ? 4 : 3;

  // Handle planes in sequence.
  plane_offset = 0;
  for (int plane = 0; plane < num_planes; ++plane) {
    const int subsampling_y = mbd->plane[plane].subsampling_y;
    const int subsampling_x = mbd->plane[plane].subsampling_x;
    const int h = mb_height >> subsampling_y;  // Plane height.
    const int w = mb_width >> subsampling_x;   // Plane width.

    // Perform filtering.
    int pred_idx = 0;
    for (int i = 0; i < h; ++i) {
      for (int j = 0; j < w; ++j) {
        // non-local mean approach
        uint64_t sum_square_diff = 0;
        int num_ref_pixels = 0;

        for (int wi = -half_window; wi <= half_window; ++wi) {
          for (int wj = -half_window; wj <= half_window; ++wj) {
            const int y = CLIP(i + wi, 0, h - 1);  // Y-coord on current plane.
            const int x = CLIP(j + wj, 0, w - 1);  // X-coord on current plane.
            sum_square_diff += square_diff[plane_offset + y * w + x];
            ++num_ref_pixels;
          }
        }

        // Filter U-plane and V-plane using Y-plane. This is because motion
        // search is only done on Y-plane, so the information from Y-plane will
        // be more accurate.
        if (plane != 0) {
          const int ss_y_shift = subsampling_y - mbd->plane[0].subsampling_y;
          const int ss_x_shift = subsampling_x - mbd->plane[0].subsampling_x;
          for (int ii = 0; ii < (1 << ss_y_shift); ++ii) {
            for (int jj = 0; jj < (1 << ss_x_shift); ++jj) {
              const int yy = (i << ss_y_shift) + ii;  // Y-coord on Y-plane.
              const int xx = (j << ss_x_shift) + jj;  // X-coord on Y-plane.
              const int ww = w << ss_x_shift;         // Width of Y-plane.
              sum_square_diff += square_diff[yy * ww + xx];
              ++num_ref_pixels;
            }
          }
        }

        // Scale down the difference for high bit depth input.
        if (mbd->bd > 8) sum_square_diff >>= (mbd->bd - 8) * (mbd->bd - 8);
        const double window_error = (double)(sum_square_diff) / num_ref_pixels;
        const int subblock_idx = (i >= h / 2) * 2 + (j >= w / 2);
        const double block_error =
            (double)(use_subblock ? subblock_mses[subblock_idx] : block_mse);

        // Control factor for non-local mean approach.
        const double r =
            (double)decay_control * (0.7 + log(noise_levels[plane] + 1.0));
        const double q = AOMMIN((double)(q_factor * q_factor) / 256.0, 1);

        // Compute filter weight.
        const double scaled_diff =
            AOMMAX(-(window_error + block_error / 10) / (2 * r * r * q), -15.0);
        const int adjusted_weight =
            (int)(exp(scaled_diff) * TF_PLANEWISE_FILTER_WEIGHT_SCALE);

        const int idx = plane_offset + pred_idx;  // Index with plane shift.
        const int pred_value = is_high_bitdepth ? pred16[idx] : pred[idx];
        accum[idx] += adjusted_weight * pred_value;
        count[idx] += adjusted_weight;

        ++pred_idx;
      }
    }
    plane_offset += mb_pels;
  }

  aom_free(square_diff);
}

// Computes temporal filter weights and accumulators from all reference frames
// excluding the current frame to be filtered.
// Inputs:
//   frame_to_filter: Pointer to the frame to be filtered, which is used as
//                    reference to compute squared differece from the predictor.
//   mbd: Pointer to the block for filtering, which is ONLY used to get
//        subsampling information of all planes and the bit-depth.
//   block_size: Size of the block.
//   mb_row: Row index of the block in the entire frame.
//   mb_col: Column index of the block in the entire frame.
//   num_planes: Number of planes in the frame.
//   strength: Strength for filter weight adjustment. (Used in YUV strategy)
//   use_subblock: Whether to use 4 sub-blocks to replace the original block.
//                 (Used in YUV strategy)
//   subblock_filter_weights: The filter weights for each sub-block (row-major
//                            order). If `use_subblock` is set as 0, the first
//                            weight will be applied to the entire block. (Used
//                            in YUV strategy)
//   noise_levels: Pointer to the noise levels of the to-filter frame, estimated
//                 with each plane (in Y, U, V order). (Used in plane-wise
//                 strategy)
//   block_mse: Motion search error (MSE) for the entire block.
//   subblock_mses: Pointer to the search errors (MSE) for 4 sub-blocks.
//   q_factor: Quantization factor.
//   pred: Pointer to the well-built predictors.
//   accum: Pointer to the pixel-wise accumulator for filtering.
//   count: Pointer to the pixel-wise counter fot filtering.
// Returns:
//   Nothing will be returned. But the content to which `accum` and `pred`
//   point will be modified.
void av1_apply_temporal_filter_others(
    const YV12_BUFFER_CONFIG *frame_to_filter, const MACROBLOCKD *mbd,
    const BLOCK_SIZE block_size, const int mb_row, const int mb_col,
    const int num_planes, const int strength, const int use_subblock,
    const int *subblock_filter_weights, const double *noise_levels,
    const int block_mse, const int *subblock_mses, const int q_factor,
    const uint8_t *pred, uint32_t *accum, uint16_t *count) {
  assert(num_planes >= 1 && num_planes <= MAX_MB_PLANE);

  if (TF_ENABLE_PLANEWISE_STRATEGY) {
    // TODO(any): avx2 and sse2 version should be changed to align with C
    // function before using.
    if (is_frame_high_bitdepth(frame_to_filter) || block_size != BLOCK_32X32) {
      av1_apply_temporal_filter_planewise_c(
          frame_to_filter, mbd, block_size, mb_row, mb_col, num_planes,
          noise_levels, use_subblock, block_mse, subblock_mses, q_factor, pred,
          accum, count);
    } else {
      av1_apply_temporal_filter_planewise(
          frame_to_filter, mbd, block_size, mb_row, mb_col, num_planes,
          noise_levels, use_subblock, block_mse, subblock_mses, q_factor, pred,
          accum, count);
    }
  } else {  // Commonly used for low-resolution video.
    if (subblock_filter_weights[0] == 0 && subblock_filter_weights[1] == 0 &&
        subblock_filter_weights[2] == 0 && subblock_filter_weights[3] == 0) {
      return;
    }
    const int adj_strength = strength + 2 * (mbd->bd - 8);
    if (num_planes == 3 && TF_YUV_FILTER_WEIGHT_SCALE == 3 &&
        block_size != BLOCK_32X32) {
      av1_apply_temporal_filter_yuv(frame_to_filter, mbd, block_size, mb_row,
                                    mb_col, num_planes, adj_strength,
                                    use_subblock, subblock_filter_weights, pred,
                                    accum, count);
    } else {
      // TODO(any): sse4 version should be changed to align with C function
      // before using.
      av1_apply_temporal_filter_yuv_c(frame_to_filter, mbd, block_size, mb_row,
                                      mb_col, num_planes, adj_strength,
                                      use_subblock, subblock_filter_weights,
                                      pred, accum, count);
    }
  }
}

// Normalizes the accumulated filtering result to produce the filtered frame.
// Inputs:
//   mbd: Pointer to the block for filtering, which is ONLY used to get
//        subsampling information of all planes.
//   block_size: Size of the block.
//   mb_row: Row index of the block in the entire frame.
//   mb_col: Column index of the block in the entire frame.
//   num_planes: Number of planes in the frame.
//   accum: Pointer to the pre-computed accumulator.
//   count: Pointer to the pre-computed count.
//   result_buffer: Pointer to result buffer.
// Returns:
//   Nothing will be returned. But the content to which `result_buffer` point
//   will be modified.
static void tf_normalize_filtered_frame(
    const MACROBLOCKD *mbd, const BLOCK_SIZE block_size, const int mb_row,
    const int mb_col, const int num_planes, const uint32_t *accum,
    const uint16_t *count, YV12_BUFFER_CONFIG *result_buffer) {
  assert(num_planes >= 1 && num_planes <= MAX_MB_PLANE);

  // Block information.
  const int mb_height = block_size_high[block_size];
  const int mb_width = block_size_wide[block_size];
  const int mb_pels = mb_height * mb_width;
  const int is_high_bitdepth = is_frame_high_bitdepth(result_buffer);

  int plane_offset = 0;
  for (int plane = 0; plane < num_planes; ++plane) {
    const int plane_h = mb_height >> mbd->plane[plane].subsampling_y;
    const int plane_w = mb_width >> mbd->plane[plane].subsampling_x;
    const int frame_stride = result_buffer->strides[plane == 0 ? 0 : 1];
    const int frame_offset = mb_row * plane_h * frame_stride + mb_col * plane_w;
    uint8_t *const buf = result_buffer->buffers[plane];
    uint16_t *const buf16 = CONVERT_TO_SHORTPTR(buf);

    int plane_idx = 0;             // Pixel index on current plane (block-base).
    int frame_idx = frame_offset;  // Pixel index on the entire frame.
    for (int i = 0; i < plane_h; ++i) {
      for (int j = 0; j < plane_w; ++j) {
        const int idx = plane_idx + plane_offset;
        const uint16_t rounding = count[idx] >> 1;
        if (is_high_bitdepth) {
          buf16[frame_idx] =
              (uint16_t)OD_DIVU(accum[idx] + rounding, count[idx]);
        } else {
          buf[frame_idx] = (uint8_t)OD_DIVU(accum[idx] + rounding, count[idx]);
        }
        ++plane_idx;
        ++frame_idx;
      }
      frame_idx += (frame_stride - plane_w);
    }
    plane_offset += mb_pels;
  }
}

// Helper function to compute number of blocks on either side of the frame.
static INLINE int get_num_blocks(const int frame_length, const int mb_length) {
  return (frame_length + mb_length - 1) / mb_length;
}

typedef struct {
  int64_t sum;
  int64_t sse;
} FRAME_DIFF;

// Does temporal filter for a particular frame.
// Inputs:
//   cpi: Pointer to the composed information of input video.
//   frames: Frame buffers used for temporal filtering.
//   num_frames: Number of frames in the frame buffer.
//   filter_frame_idx: Index of the frame to be filtered.
//   is_key_frame: Whether the to-filter is a key frame.
//   is_second_arf: Whether the to-filter frame is the second ARF. This field
//                  is ONLY used for assigning filter weight.
//   block_size: Block size used for temporal filtering.
//   scale: Scaling factor.
//   strength: Pre-estimated strength for filter weight adjustment.
//   noise_levels: Pointer to the noise levels of the to-filter frame, estimated
//                 with each plane (in Y, U, V order).
// Returns:
//   Difference between filtered frame and the original frame.
static FRAME_DIFF tf_do_filtering(
    AV1_COMP *cpi, YV12_BUFFER_CONFIG **frames, const int num_frames,
    const int filter_frame_idx, const int is_key_frame, const int is_second_arf,
    const BLOCK_SIZE block_size, const struct scale_factors *scale,
    const int strength, const double *noise_levels) {
  // Basic information.
  const YV12_BUFFER_CONFIG *const frame_to_filter = frames[filter_frame_idx];
  const int frame_height = frame_to_filter->y_crop_height;
  const int frame_width = frame_to_filter->y_crop_width;
  const int mb_height = block_size_high[block_size];
  const int mb_width = block_size_wide[block_size];
  const int mb_pels = mb_height * mb_width;
  const int mb_rows = get_num_blocks(frame_height, mb_height);
  const int mb_cols = get_num_blocks(frame_width, mb_width);
  const int num_planes = av1_num_planes(&cpi->common);
  const int mi_h = mi_size_high_log2[block_size];
  const int mi_w = mi_size_wide_log2[block_size];
  assert(num_planes >= 1 && num_planes <= MAX_MB_PLANE);
  const int is_high_bitdepth = is_frame_high_bitdepth(frame_to_filter);

  // Save input state.
  MACROBLOCK *const mb = &cpi->td.mb;
  MACROBLOCKD *const mbd = &mb->e_mbd;
  uint8_t *input_buffer[MAX_MB_PLANE];
  for (int i = 0; i < num_planes; i++) {
    input_buffer[i] = mbd->plane[i].pre[0].buf;
  }
  MB_MODE_INFO **input_mb_mode_info = mbd->mi;

  // Setup.
  mbd->block_ref_scale_factors[0] = scale;
  mbd->block_ref_scale_factors[1] = scale;
  // A temporary block info used to store state in temporal filtering process.
  MB_MODE_INFO *tmp_mb_mode_info = (MB_MODE_INFO *)malloc(sizeof(MB_MODE_INFO));
  memset(tmp_mb_mode_info, 0, sizeof(MB_MODE_INFO));
  mbd->mi = &tmp_mb_mode_info;
  mbd->mi[0]->motion_mode = SIMPLE_TRANSLATION;
  // Allocate memory for predictor, accumulator and count.
  uint8_t *pred8 = aom_memalign(32, num_planes * mb_pels * sizeof(uint8_t));
  uint16_t *pred16 = aom_memalign(32, num_planes * mb_pels * sizeof(uint16_t));
  uint32_t *accum = aom_memalign(16, num_planes * mb_pels * sizeof(uint32_t));
  uint16_t *count = aom_memalign(16, num_planes * mb_pels * sizeof(uint16_t));
  memset(pred8, 0, num_planes * mb_pels * sizeof(pred8[0]));
  memset(pred16, 0, num_planes * mb_pels * sizeof(pred16[0]));
  uint8_t *const pred = is_high_bitdepth ? CONVERT_TO_BYTEPTR(pred16) : pred8;

  // Do filtering.
  FRAME_DIFF diff = { 0, 0 };
  // Perform temporal filtering block by block.
  for (int mb_row = 0; mb_row < mb_rows; mb_row++) {
    av1_set_mv_row_limits(&cpi->common.mi_params, &mb->mv_limits,
                          (mb_row << mi_h), (mb_height >> MI_SIZE_LOG2),
                          cpi->oxcf.border_in_pixels);
    for (int mb_col = 0; mb_col < mb_cols; mb_col++) {
      av1_set_mv_col_limits(&cpi->common.mi_params, &mb->mv_limits,
                            (mb_col << mi_w), (mb_width >> MI_SIZE_LOG2),
                            cpi->oxcf.border_in_pixels);
      memset(accum, 0, num_planes * mb_pels * sizeof(accum[0]));
      memset(count, 0, num_planes * mb_pels * sizeof(count[0]));
      MV ref_mv = kZeroMv;  // Reference motion vector passed down along frames.
      // Perform temporal filtering frame by frame.
      for (int frame = 0; frame < num_frames; frame++) {
        if (frames[frame] == NULL) continue;

        // Motion search.
        MV subblock_mvs[4] = { kZeroMv, kZeroMv, kZeroMv, kZeroMv };
        int subblock_filter_weights[4] = { 0, 0, 0, 0 };
        int block_mse = INT_MAX;
        int subblock_mses[4] = { INT_MAX, INT_MAX, INT_MAX, INT_MAX };

        if (frame == filter_frame_idx) {  // Frame to be filtered.
          // Set motion vector as 0 for the frame to be filtered.
          mbd->mi[0]->mv[0].as_mv = kZeroMv;
          // Change ref_mv sign for following frames.
          ref_mv.row *= -1;
          ref_mv.col *= -1;
        } else {  // Other reference frames.
          block_mse = tf_motion_search(cpi, frame_to_filter, frames[frame],
                                       block_size, mb_row, mb_col, &ref_mv,
                                       subblock_mvs, subblock_mses);
          // Do not pass down the reference motion vector if error is too large.
          const int thresh = AOMMIN(frame_height, frame_width) >= 720 ? 12 : 3;
          if (block_mse > (thresh << (mbd->bd - 8))) {
            ref_mv = kZeroMv;
          }
        }

        // Build predictor.
        int use_subblock = tf_get_filter_weight(
            block_mse, subblock_mses, is_second_arf, subblock_filter_weights);
        tf_build_predictor(frames[frame], mbd, block_size, mb_row, mb_col,
                           num_planes, scale, use_subblock, subblock_mvs, pred);

        // Perform weighted averaging.
        if (frame == filter_frame_idx) {  // Frame to be filtered.
          av1_apply_temporal_filter_self(mbd, block_size, num_planes,
                                         subblock_filter_weights[0], pred,
                                         accum, count);
        } else {  // Other reference frames.
          const FRAME_TYPE frame_type =
              (cpi->common.current_frame.frame_number > 1) ? INTER_FRAME
                                                           : KEY_FRAME;
          const int q_factor =
              (int)av1_convert_qindex_to_q(cpi->rc.avg_frame_qindex[frame_type],
                                           cpi->common.seq_params.bit_depth);
          av1_apply_temporal_filter_others(
              frame_to_filter, mbd, block_size, mb_row, mb_col, num_planes,
              strength, use_subblock, subblock_filter_weights, noise_levels,
              block_mse, subblock_mses, q_factor, pred, accum, count);
        }
      }

      tf_normalize_filtered_frame(mbd, block_size, mb_row, mb_col, num_planes,
                                  accum, count, &cpi->alt_ref_buffer);

      if (!is_key_frame && cpi->sf.hl_sf.adaptive_overlay_encoding) {
        const int y_height = mb_height >> mbd->plane[0].subsampling_y;
        const int y_width = mb_width >> mbd->plane[0].subsampling_x;
        const int source_y_stride = frame_to_filter->y_stride;
        const int filter_y_stride = cpi->alt_ref_buffer.y_stride;
        const int source_offset =
            mb_row * y_height * source_y_stride + mb_col * y_width;
        const int filter_offset =
            mb_row * y_height * filter_y_stride + mb_col * y_width;
        unsigned int sse = 0;
        cpi->fn_ptr[block_size].vf(frame_to_filter->y_buffer + source_offset,
                                   source_y_stride,
                                   cpi->alt_ref_buffer.y_buffer + filter_offset,
                                   filter_y_stride, &sse);
        diff.sum += sse;
        diff.sse += sse * sse;
      }
    }
  }

  // Restore input state
  for (int i = 0; i < num_planes; i++) {
    mbd->plane[i].pre[0].buf = input_buffer[i];
  }
  mbd->mi = input_mb_mode_info;

  free(tmp_mb_mode_info);
  aom_free(pred8);
  aom_free(pred16);
  aom_free(accum);
  aom_free(count);

  return diff;
}

// A constant number, sqrt(pi / 2),  used for noise estimation.
static const double SQRT_PI_BY_2 = 1.25331413732;

double av1_estimate_noise_from_single_plane(const YV12_BUFFER_CONFIG *frame,
                                            const int plane,
                                            const int bit_depth) {
  const int is_y_plane = (plane == 0);
  const int height = frame->crop_heights[is_y_plane ? 0 : 1];
  const int width = frame->crop_widths[is_y_plane ? 0 : 1];
  const int stride = frame->strides[is_y_plane ? 0 : 1];
  const uint8_t *src = frame->buffers[plane];
  const uint16_t *src16 = CONVERT_TO_SHORTPTR(src);
  const int is_high_bitdepth = is_frame_high_bitdepth(frame);

  int64_t accum = 0;
  int count = 0;
  for (int i = 1; i < height - 1; ++i) {
    for (int j = 1; j < width - 1; ++j) {
      // Setup a small 3x3 matrix.
      const int center_idx = i * stride + j;
      int mat[3][3];
      for (int ii = -1; ii <= 1; ++ii) {
        for (int jj = -1; jj <= 1; ++jj) {
          const int idx = center_idx + ii * stride + jj;
          mat[ii + 1][jj + 1] = is_high_bitdepth ? src16[idx] : src[idx];
        }
      }
      // Compute sobel gradients.
      const int Gx = (mat[0][0] - mat[0][2]) + (mat[2][0] - mat[2][2]) +
                     2 * (mat[1][0] - mat[1][2]);
      const int Gy = (mat[0][0] - mat[2][0]) + (mat[0][2] - mat[2][2]) +
                     2 * (mat[0][1] - mat[2][1]);
      const int Ga = ROUND_POWER_OF_TWO(abs(Gx) + abs(Gy), bit_depth - 8);
      // Accumulate Laplacian.
      if (Ga < NOISE_ESTIMATION_EDGE_THRESHOLD) {  // Only count smooth pixels.
        const int v = 4 * mat[1][1] -
                      2 * (mat[0][1] + mat[2][1] + mat[1][0] + mat[1][2]) +
                      (mat[0][0] + mat[0][2] + mat[2][0] + mat[2][2]);
        accum += ROUND_POWER_OF_TWO(abs(v), bit_depth - 8);
        ++count;
      }
    }
  }

  // Return -1.0 (unreliable estimation) if there are too few smooth pixels.
  return (count < 16) ? -1.0 : (double)accum / (6 * count) * SQRT_PI_BY_2;
}

// Estimates the strength for filter weight adjustment, which is used in YUV
// strategy. This estimation is based on the pre-estimated noise level of the
// to-filter frame.
// Inputs:
//   cpi: Pointer to the composed information of input video.
//   noise_level: Noise level of the to-filter frame, estimated with Y-plane.
//   group_boost: Boost level for the current group of frames.
// Returns:
//   Estimated strength which will be used for filter weight adjustment.
static int tf_estimate_strength(const AV1_COMP *cpi, const double noise_level,
                                const int group_boost) {
  int strength = cpi->oxcf.arnr_strength;

  // Adjust the strength based on the estimated noise level.
  if (noise_level > 0) {       // Adjust when the noise level is reliable.
    if (noise_level < 0.75) {  // Noise level lies in range (0, 0.75).
      strength = strength - 2;
    } else if (noise_level < 1.75) {  // Noise level lies in range [0.75, 1.75).
      strength = strength - 1;
    } else if (noise_level < 4.0) {  // Noise level lies in range [1.75, 4.0).
      strength = strength + 0;
    } else {  // Noise level lies in range [4.0, +inf).
      strength = strength + 1;
    }
  }

  // Adjust the strength based on active max q.
  const FRAME_TYPE frame_type =
      (cpi->common.current_frame.frame_number > 1) ? INTER_FRAME : KEY_FRAME;
  const int q = (int)av1_convert_qindex_to_q(
      cpi->rc.avg_frame_qindex[frame_type], cpi->common.seq_params.bit_depth);
  strength = strength - AOMMAX(0, (16 - q) / 2);

  return CLIP(strength, 0, group_boost / 300);
}

// Setups the frame buffer for temporal filtering. Basically, this fuction
// determines how many frames will be used for temporal filtering and then
// groups them into a buffer.
// Inputs:
//   cpi: Pointer to the composed information of input video.
//   filter_frame_lookahead_idx: The index of the to-filter frame in the
//                               lookahead buffer `cpi->lookahead`.
//   is_second_arf: Whether the to-filter frame is the second ARF. This field
//                  will affect the number of frames used for filtering.
//   frames: Pointer to the frame buffer to setup.
//   num_frames_for_filtering: Number of frames used for filtering.
//   filter_frame_idx: Index of the to-filter frame in the setup frame buffer.
// Returns:
//   Nothing will be returned. But the frame buffer `frames`, number of frames
//   in the buffer `num_frames_for_filtering`, and the index of the to-filter
//   frame in the buffer `filter_frame_idx` will be updated in this function.
static void tf_setup_filtering_buffer(const AV1_COMP *cpi,
                                      const int filter_frame_lookahead_idx,
                                      const int is_second_arf,
                                      YV12_BUFFER_CONFIG **frames,
                                      int *num_frames_for_filtering,
                                      int *filter_frame_idx) {
  int num_frames = 0;          // Number of frames used for filtering.
  int num_frames_before = -1;  // Number of frames before the to-filter frame.
  int filter_frame_offset;

  if (filter_frame_lookahead_idx == -1) {  // Key frame.
    num_frames = TF_NUM_FILTERING_FRAMES_FOR_KEY_FRAME;
    num_frames_before = 0;
    filter_frame_offset = filter_frame_lookahead_idx;
  } else if (filter_frame_lookahead_idx < -1) {  // Key frame in one-pass mode.
    num_frames = TF_NUM_FILTERING_FRAMES_FOR_KEY_FRAME;
    num_frames_before = num_frames - 1;
    filter_frame_offset = -filter_frame_lookahead_idx;
  } else {
    num_frames = cpi->oxcf.arnr_max_frames;
    if (is_second_arf) {  // Only use 2 neighbours for the second ARF.
      num_frames = AOMMIN(num_frames, 3);
    }
    if (num_frames > cpi->rc.gfu_boost / 150) {
      num_frames = cpi->rc.gfu_boost / 150;
      num_frames += !(num_frames & 1);
    }
    num_frames_before = AOMMIN(num_frames >> 1, filter_frame_lookahead_idx + 1);
    const int lookahead_depth =
        av1_lookahead_depth(cpi->lookahead, cpi->compressor_stage);
    const int num_frames_after =
        AOMMIN((num_frames - 1) >> 1,
               lookahead_depth - filter_frame_lookahead_idx - 1);
    num_frames = num_frames_before + 1 + num_frames_after;
    filter_frame_offset = filter_frame_lookahead_idx;
  }
  *num_frames_for_filtering = num_frames;
  *filter_frame_idx = num_frames_before;

  // Setup the frame buffer.
  for (int frame = 0; frame < num_frames; ++frame) {
    const int lookahead_idx = frame - num_frames_before + filter_frame_offset;
    struct lookahead_entry *buf = av1_lookahead_peek(
        cpi->lookahead, lookahead_idx, cpi->compressor_stage);
    frames[frame] = (buf == NULL) ? NULL : &buf->img;
  }
}

int av1_temporal_filter(AV1_COMP *cpi, const int filter_frame_lookahead_idx,
                        int *show_existing_arf) {
  // Basic informaton of the current frame.
  const GF_GROUP *const gf_group = &cpi->gf_group;
  const uint8_t group_idx = gf_group->index;
  const FRAME_UPDATE_TYPE update_type = gf_group->update_type[group_idx];
  // Filter one more ARF if the lookahead index is leq 7 (w.r.t. 9-th frame).
  // This frame is ALWAYS a show existing frame.
  const int is_second_arf = (update_type == INTNL_ARF_UPDATE) &&
                            (filter_frame_lookahead_idx >= 7) &&
                            cpi->sf.hl_sf.second_alt_ref_filtering;
  // TODO(anyone): Currently, we enforce the filtering strength on internal
  // ARFs except the second ARF to be zero. We should investigate in which case
  // it is more beneficial to use non-zero strength filtering.
  if (update_type == INTNL_ARF_UPDATE && !is_second_arf) {
    return 0;
  }

  // TODO(yunqing): For INTNL_ARF_UPDATE type, the following me initialization
  // is used somewhere unexpectedly. Should be resolved later.
  // Initialize errorperbit, sadperbit16 and sadperbit4.
  const int rdmult = av1_compute_rd_mult_based_on_qindex(cpi, TF_QINDEX);
  set_error_per_bit(&cpi->td.mb, rdmult);
  av1_initialize_me_consts(cpi, &cpi->td.mb, TF_QINDEX);
  av1_fill_mv_costs(cpi->common.fc,
                    cpi->common.features.cur_frame_force_integer_mv,
                    cpi->common.features.allow_high_precision_mv, &cpi->td.mb);

  // Setup frame buffer for filtering.
  YV12_BUFFER_CONFIG *frames[MAX_LAG_BUFFERS] = { NULL };
  int num_frames_for_filtering = 0;
  int filter_frame_idx = -1;
  tf_setup_filtering_buffer(cpi, filter_frame_lookahead_idx, is_second_arf,
                            frames, &num_frames_for_filtering,
                            &filter_frame_idx);

  // Estimate noise and strength.
  const int bit_depth = cpi->common.seq_params.bit_depth;
  const int num_planes = av1_num_planes(&cpi->common);
  double noise_levels[MAX_MB_PLANE] = { 0 };
  for (int plane = 0; plane < num_planes; ++plane) {
    noise_levels[plane] = av1_estimate_noise_from_single_plane(
        frames[filter_frame_idx], plane, bit_depth);
  }
  const int strength =
      tf_estimate_strength(cpi, noise_levels[0], cpi->rc.gfu_boost);
  if (filter_frame_lookahead_idx >= 0) {
    cpi->common.showable_frame =
        (strength == 0 && num_frames_for_filtering == 1) || is_second_arf ||
        (cpi->oxcf.enable_overlay == 0 || cpi->sf.hl_sf.disable_overlay_frames);
  }

  // Do filtering.
  const int is_key_frame = (filter_frame_lookahead_idx < 0);
  FRAME_DIFF diff = { 0, 0 };
  if (num_frames_for_filtering > 0 && frames[0] != NULL) {
    // Setup scaling factors. Scaling on each of the arnr frames is not
    // supported.
    // ARF is produced at the native frame size and resized when coded.
    struct scale_factors sf;
    av1_setup_scale_factors_for_frame(
        &sf, frames[0]->y_crop_width, frames[0]->y_crop_height,
        frames[0]->y_crop_width, frames[0]->y_crop_height);
    diff = tf_do_filtering(cpi, frames, num_frames_for_filtering,
                           filter_frame_idx, is_key_frame, is_second_arf,
                           TF_BLOCK_SIZE, &sf, strength, noise_levels);
  }

  if (is_key_frame) {  // Key frame should always be filtered.
    return 1;
  }

  if ((show_existing_arf != NULL && cpi->sf.hl_sf.adaptive_overlay_encoding) ||
      is_second_arf) {
    const int frame_height = frames[filter_frame_idx]->y_crop_height;
    const int frame_width = frames[filter_frame_idx]->y_crop_width;
    const int block_height = block_size_high[TF_BLOCK_SIZE];
    const int block_width = block_size_wide[TF_BLOCK_SIZE];
    const int mb_rows = get_num_blocks(frame_height, block_height);
    const int mb_cols = get_num_blocks(frame_width, block_width);
    const int num_mbs = AOMMAX(1, mb_rows * mb_cols);
    const float mean = (float)diff.sum / num_mbs;
    const float std = (float)sqrt((float)diff.sse / num_mbs - mean * mean);

    aom_clear_system_state();
    // TODO(yunqing): This can be combined with TPL q calculation later.
    cpi->rc.base_frame_target = gf_group->bit_allocation[group_idx];
    av1_set_target_rate(cpi, cpi->common.width, cpi->common.height);
    int top_index = 0;
    int bottom_index = 0;
    const int q = av1_rc_pick_q_and_bounds(cpi, &cpi->rc, cpi->oxcf.width,
                                           cpi->oxcf.height, group_idx,
                                           &bottom_index, &top_index);
    const int ac_q = av1_ac_quant_QTX(q, 0, bit_depth);
    const float threshold = 0.7f * ac_q * ac_q;

    if (!is_second_arf) {
      *show_existing_arf = 0;
      if (mean < threshold && std < mean * 1.2) {
        *show_existing_arf = 1;
      }
      cpi->common.showable_frame |= *show_existing_arf;
    } else {
      // Use source frame if the filtered frame becomes very different.
      if (!(mean < threshold && std < mean * 1.2)) {
        return 0;
      }
    }
  }

  return 1;
}
