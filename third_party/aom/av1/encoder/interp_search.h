/*
 * Copyright (c) 2020, Alliance for Open Media. All rights reserved
 *
 * This source code is subject to the terms of the BSD 2 Clause License and
 * the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
 * was not distributed with this source code in the LICENSE file, you can
 * obtain it at www.aomedia.org/license/software. If the Alliance for Open
 * Media Patent License 1.0 was not distributed with this source code in the
 * PATENTS file, you can obtain it at www.aomedia.org/license/patent.
 */

#ifndef AOM_AV1_ENCODER_INTERP_FILTER_SEARCH_H_
#define AOM_AV1_ENCODER_INTERP_FILTER_SEARCH_H_

#include "av1/encoder/block.h"
#include "av1/encoder/encoder.h"
#include "av1/encoder/rdopt_utils.h"

#ifdef __cplusplus
extern "C" {
#endif

#define MAX_INTERP_FILTER_STATS 128
#define DUAL_FILTER_SET_SIZE (SWITCHABLE_FILTERS * SWITCHABLE_FILTERS)

typedef struct {
  int_interpfilters filters;
  int_mv mv[2];
  int8_t ref_frames[2];
  COMPOUND_TYPE comp_type;
  int compound_idx;
  int64_t rd;
  unsigned int pred_sse;
} INTERPOLATION_FILTER_STATS;

typedef struct {
  // OBMC secondary prediction buffers and respective strides
  uint8_t *above_pred_buf[MAX_MB_PLANE];
  int above_pred_stride[MAX_MB_PLANE];
  uint8_t *left_pred_buf[MAX_MB_PLANE];
  int left_pred_stride[MAX_MB_PLANE];
  int_mv (*single_newmv)[REF_FRAMES];
  // Pointer to array of motion vectors to use for each ref and their rates
  // Should point to first of 2 arrays in 2D array
  int (*single_newmv_rate)[REF_FRAMES];
  int (*single_newmv_valid)[REF_FRAMES];
  // Pointer to array of predicted rate-distortion
  // Should point to first of 2 arrays in 2D array
  int64_t (*modelled_rd)[MAX_REF_MV_SEARCH][REF_FRAMES];
  int ref_frame_cost;
  int single_comp_cost;
  int64_t (*simple_rd)[MAX_REF_MV_SEARCH][REF_FRAMES];
  int skip_motion_mode;
  INTERINTRA_MODE *inter_intra_mode;
  int single_ref_first_pass;
  SimpleRDState *simple_rd_state;
  // [comp_idx][saved stat_idx]
  INTERPOLATION_FILTER_STATS interp_filter_stats[MAX_INTERP_FILTER_STATS];
  int interp_filter_stats_idx;
} HandleInterModeArgs;

static const int_interpfilters filter_sets[DUAL_FILTER_SET_SIZE] = {
  { 0x00000000 }, { 0x00010000 }, { 0x00020000 },  // y = 0
  { 0x00000001 }, { 0x00010001 }, { 0x00020001 },  // y = 1
  { 0x00000002 }, { 0x00010002 }, { 0x00020002 },  // y = 2
};

int av1_find_interp_filter_match(
    MB_MODE_INFO *const mbmi, const AV1_COMP *const cpi,
    const InterpFilter assign_filter, const int need_search,
    INTERPOLATION_FILTER_STATS *interp_filter_stats,
    int interp_filter_stats_idx);

int64_t av1_interpolation_filter_search(
    MACROBLOCK *const x, const AV1_COMP *const cpi,
    const TileDataEnc *tile_data, BLOCK_SIZE bsize,
    const BUFFER_SET *const tmp_dst, const BUFFER_SET *const orig_dst,
    int64_t *const rd, int *const switchable_rate, int *skip_build_pred,
    HandleInterModeArgs *args, int64_t ref_best_rd);

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // AOM_AV1_ENCODER_INTERP_FILTER_SEARCH_H_
