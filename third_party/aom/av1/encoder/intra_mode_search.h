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

#ifndef AOM_AV1_ENCODER_INTRA_MODE_SEARCH_H_
#define AOM_AV1_ENCODER_INTRA_MODE_SEARCH_H_

#include "av1/encoder/encoder.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct IntraModeSearchState {
  int skip_intra_modes;
  PREDICTION_MODE best_intra_mode;
  int angle_stats_ready;
  uint8_t directional_mode_skip_mask[INTRA_MODES];
  int rate_uv_intra;
  int rate_uv_tokenonly;
  int64_t dist_uvs;
  int skip_uvs;
  UV_PREDICTION_MODE mode_uv;
  PALETTE_MODE_INFO pmi_uv;
  int8_t uv_angle_delta;
  int64_t best_pred_rd[REFERENCE_MODES];
} IntraModeSearchState;

void av1_restore_uv_color_map(const AV1_COMP *const cpi, MACROBLOCK *x);
int av1_search_palette_mode(const AV1_COMP *cpi, MACROBLOCK *x,
                            RD_STATS *this_rd_cost, PICK_MODE_CONTEXT *ctx,
                            BLOCK_SIZE bsize, MB_MODE_INFO *const mbmi,
                            PALETTE_MODE_INFO *const pmi,
                            unsigned int *ref_costs_single,
                            IntraModeSearchState *intra_search_state,
                            int64_t best_rd);

int64_t av1_rd_pick_intra_sbuv_mode(const AV1_COMP *const cpi, MACROBLOCK *x,
                                    int *rate, int *rate_tokenonly,
                                    int64_t *distortion, int *skippable,
                                    BLOCK_SIZE bsize, TX_SIZE max_tx_size);

int64_t av1_handle_intra_mode(IntraModeSearchState *intra_search_state,
                              const AV1_COMP *cpi, MACROBLOCK *x,
                              BLOCK_SIZE bsize, int ref_frame_cost,
                              const PICK_MODE_CONTEXT *ctx, int disable_skip,
                              RD_STATS *rd_stats, RD_STATS *rd_stats_y,
                              RD_STATS *rd_stats_uv, int64_t best_rd,
                              int64_t *best_intra_rd, int8_t best_mbmode_skip);

int64_t av1_rd_pick_intra_sby_mode(const AV1_COMP *const cpi, MACROBLOCK *x,
                                   int *rate, int *rate_tokenonly,
                                   int64_t *distortion, int *skippable,
                                   BLOCK_SIZE bsize, int64_t best_rd,
                                   PICK_MODE_CONTEXT *ctx);
#endif  // AOM_AV1_ENCODER_INTRA_MODE_SEARCH_H_
