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

#ifndef AOM_AV1_ENCODER_TRANSFORM_SEARCH_H_
#define AOM_AV1_ENCODER_TRANSFORM_SEARCH_H_

#include "av1/common/pred_common.h"
#include "av1/encoder/encoder.h"

#ifdef __cplusplus
extern "C" {
#endif

// Set this macro as 1 to collect data about tx size selection.
#define COLLECT_TX_SIZE_DATA 0

#if COLLECT_TX_SIZE_DATA
static const char av1_tx_size_data_output_file[] = "tx_size_data.txt";
#endif

enum {
  FTXS_NONE = 0,
  FTXS_DCT_AND_1D_DCT_ONLY = 1 << 0,
  FTXS_DISABLE_TRELLIS_OPT = 1 << 1,
  FTXS_USE_TRANSFORM_DOMAIN = 1 << 2
} UENUM1BYTE(FAST_TX_SEARCH_MODE);

static AOM_INLINE int tx_size_cost(const MACROBLOCK *const x, BLOCK_SIZE bsize,
                                   TX_SIZE tx_size) {
  assert(bsize == x->e_mbd.mi[0]->sb_type);
  if (x->tx_mode_search_type != TX_MODE_SELECT || !block_signals_txsize(bsize))
    return 0;

  const int32_t tx_size_cat = bsize_to_tx_size_cat(bsize);
  const int depth = tx_size_to_depth(tx_size, bsize);
  const MACROBLOCKD *const xd = &x->e_mbd;
  const int tx_size_ctx = get_tx_size_context(xd);
  return x->tx_size_cost[tx_size_cat][tx_size_ctx][depth];
}

int64_t av1_uniform_txfm_yrd(const AV1_COMP *const cpi, MACROBLOCK *x,
                             RD_STATS *rd_stats, int64_t ref_best_rd,
                             BLOCK_SIZE bs, TX_SIZE tx_size,
                             FAST_TX_SEARCH_MODE ftxs_mode, int skip_trellis);

void av1_pick_recursive_tx_size_type_yrd(const AV1_COMP *cpi, MACROBLOCK *x,
                                         RD_STATS *rd_stats, BLOCK_SIZE bsize,
                                         int64_t ref_best_rd);

void av1_pick_uniform_tx_size_type_yrd(const AV1_COMP *const cpi, MACROBLOCK *x,
                                       RD_STATS *rd_stats, BLOCK_SIZE bs,
                                       int64_t ref_best_rd);

int av1_txfm_uvrd(const AV1_COMP *const cpi, MACROBLOCK *x, RD_STATS *rd_stats,
                  BLOCK_SIZE bsize, int64_t ref_best_rd);

void av1_txfm_rd_in_plane(MACROBLOCK *x, const AV1_COMP *cpi,
                          RD_STATS *rd_stats, int64_t ref_best_rd,
                          int64_t this_rd, int plane, BLOCK_SIZE plane_bsize,
                          TX_SIZE tx_size, int use_fast_coef_costing,
                          FAST_TX_SEARCH_MODE ftxs_mode, int skip_trellis);

int av1_txfm_search(const AV1_COMP *cpi, MACROBLOCK *x, BLOCK_SIZE bsize,
                    RD_STATS *rd_stats, RD_STATS *rd_stats_y,
                    RD_STATS *rd_stats_uv, int mode_rate, int64_t ref_best_rd);

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // AOM_AV1_ENCODER_TRANSFORM_SEARCH_H_
