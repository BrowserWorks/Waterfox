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

#ifndef AOM_AV1_ENCODER_RDOPT_H_
#define AOM_AV1_ENCODER_RDOPT_H_

#include <stdbool.h>

#include "av1/common/blockd.h"
#include "av1/common/txb_common.h"

#include "av1/encoder/block.h"
#include "av1/encoder/context_tree.h"
#include "av1/encoder/encoder.h"
#include "av1/encoder/encodetxb.h"
#include "av1/encoder/rdopt_utils.h"

#ifdef __cplusplus
extern "C" {
#endif

#define COMP_TYPE_RD_THRESH_SCALE 11
#define COMP_TYPE_RD_THRESH_SHIFT 4
#define MAX_WINNER_MOTION_MODES 10

struct TileInfo;
struct macroblock;
struct RD_STATS;

// Returns the number of colors in 'src'.
int av1_count_colors(const uint8_t *src, int stride, int rows, int cols,
                     int *val_count);
// Same as av1_count_colors(), but for high-bitdepth mode.
int av1_count_colors_highbd(const uint8_t *src8, int stride, int rows, int cols,
                            int bit_depth, int *val_count);

static INLINE int av1_cost_skip_txb(MACROBLOCK *x, const TXB_CTX *const txb_ctx,
                                    int plane, TX_SIZE tx_size) {
  const TX_SIZE txs_ctx = get_txsize_entropy_ctx(tx_size);
  const PLANE_TYPE plane_type = get_plane_type(plane);
  const LV_MAP_COEFF_COST *const coeff_costs =
      &x->coeff_costs[txs_ctx][plane_type];
  return coeff_costs->txb_skip_cost[txb_ctx->txb_skip_ctx][1];
}

void av1_rd_pick_intra_mode_sb(const struct AV1_COMP *cpi, struct macroblock *x,
                               struct RD_STATS *rd_cost, BLOCK_SIZE bsize,
                               PICK_MODE_CONTEXT *ctx, int64_t best_rd);

unsigned int av1_get_sby_perpixel_variance(const struct AV1_COMP *cpi,
                                           const struct buf_2d *ref,
                                           BLOCK_SIZE bs);
unsigned int av1_high_get_sby_perpixel_variance(const struct AV1_COMP *cpi,
                                                const struct buf_2d *ref,
                                                BLOCK_SIZE bs, int bd);

void av1_rd_pick_inter_mode_sb(struct AV1_COMP *cpi,
                               struct TileDataEnc *tile_data,
                               struct macroblock *x, struct RD_STATS *rd_cost,
                               BLOCK_SIZE bsize, PICK_MODE_CONTEXT *ctx,
                               int64_t best_rd_so_far);

void av1_pick_intra_mode(AV1_COMP *cpi, MACROBLOCK *x, RD_STATS *rd_cost,
                         BLOCK_SIZE bsize, PICK_MODE_CONTEXT *ctx);

void av1_nonrd_pick_inter_mode_sb(struct AV1_COMP *cpi,
                                  struct TileDataEnc *tile_data,
                                  struct macroblock *x,
                                  struct RD_STATS *rd_cost, BLOCK_SIZE bsize,
                                  PICK_MODE_CONTEXT *ctx,
                                  int64_t best_rd_so_far);

void av1_rd_pick_inter_mode_sb_seg_skip(
    const struct AV1_COMP *cpi, struct TileDataEnc *tile_data,
    struct macroblock *x, int mi_row, int mi_col, struct RD_STATS *rd_cost,
    BLOCK_SIZE bsize, PICK_MODE_CONTEXT *ctx, int64_t best_rd_so_far);

// The best edge strength seen in the block, as well as the best x and y
// components of edge strength seen.
typedef struct {
  uint16_t magnitude;
  uint16_t x;
  uint16_t y;
} EdgeInfo;

/** Returns an integer indicating the strength of the edge.
 * 0 means no edge found, 556 is the strength of a solid black/white edge,
 * and the number may range higher if the signal is even stronger (e.g., on a
 * corner). high_bd is a bool indicating the source should be treated
 * as a 16-bit array. bd is the bit depth.
 */
EdgeInfo av1_edge_exists(const uint8_t *src, int src_stride, int w, int h,
                         bool high_bd, int bd);

/** Applies a Gaussian blur with sigma = 1.3. Used by av1_edge_exists and
 * tests.
 */
void av1_gaussian_blur(const uint8_t *src, int src_stride, int w, int h,
                       uint8_t *dst, bool high_bd, int bd);

/* Applies standard 3x3 Sobel matrix. */
typedef struct {
  int16_t x;
  int16_t y;
} sobel_xy;

sobel_xy av1_sobel(const uint8_t *input, int stride, int i, int j,
                   bool high_bd);

void av1_inter_mode_data_init(struct TileDataEnc *tile_data);
void av1_inter_mode_data_fit(TileDataEnc *tile_data, int rdmult);

#if !CONFIG_REALTIME_ONLY
static INLINE int coded_to_superres_mi(int mi_col, int denom) {
  return (mi_col * denom + SCALE_NUMERATOR / 2) / SCALE_NUMERATOR;
}
#endif

static INLINE int av1_encoder_get_relative_dist(const OrderHintInfo *oh, int a,
                                                int b) {
  if (!oh->enable_order_hint) return 0;

  assert(a >= 0 && b >= 0);
  return (a - b);
}

// This function will return number of mi's in a superblock.
static INLINE int av1_get_sb_mi_size(const AV1_COMMON *const cm) {
  const int mi_alloc_size_1d = mi_size_wide[cm->mi_params.mi_alloc_bsize];
  int sb_mi_rows =
      (mi_size_wide[cm->seq_params.sb_size] + mi_alloc_size_1d - 1) /
      mi_alloc_size_1d;
  assert(mi_size_wide[cm->seq_params.sb_size] ==
         mi_size_high[cm->seq_params.sb_size]);
  int sb_mi_size = sb_mi_rows * sb_mi_rows;

  return sb_mi_size;
}

// This function will copy usable ref_mv_stack[ref_frame][4] and
// weight[ref_frame][4] information from ref_mv_stack[ref_frame][8] and
// weight[ref_frame][8].
static INLINE void av1_copy_usable_ref_mv_stack_and_weight(
    const MACROBLOCKD *xd, MB_MODE_INFO_EXT *const mbmi_ext,
    MV_REFERENCE_FRAME ref_frame) {
  memcpy(mbmi_ext->weight[ref_frame], xd->weight[ref_frame],
         USABLE_REF_MV_STACK_SIZE * sizeof(xd->weight[0][0]));
  memcpy(mbmi_ext->ref_mv_stack[ref_frame], xd->ref_mv_stack[ref_frame],
         USABLE_REF_MV_STACK_SIZE * sizeof(xd->ref_mv_stack[0][0]));
}

// This function prunes the mode if either of the reference frame falls in the
// pruning list
static INLINE int prune_ref(const MV_REFERENCE_FRAME *const ref_frame,
                            const OrderHintInfo *const order_hint_info,
                            const unsigned int *const ref_display_order_hint,
                            const unsigned int frame_display_order_hint,
                            const int *ref_frame_list) {
  for (int i = 0; i < 2; i++) {
    if (ref_frame_list[i] == NONE_FRAME) continue;

    if (ref_frame[0] == ref_frame_list[i] ||
        ref_frame[1] == ref_frame_list[i]) {
      if (av1_encoder_get_relative_dist(
              order_hint_info,
              ref_display_order_hint[ref_frame_list[i] - LAST_FRAME],
              frame_display_order_hint) < 0)
        return 1;
    }
  }
  return 0;
}

static INLINE int prune_ref_by_selective_ref_frame(
    const AV1_COMP *const cpi, const MACROBLOCK *const x,
    const MV_REFERENCE_FRAME *const ref_frame,
    const unsigned int *const ref_display_order_hint) {
  const SPEED_FEATURES *const sf = &cpi->sf;
  if (!sf->inter_sf.selective_ref_frame) return 0;

  const AV1_COMMON *const cm = &cpi->common;
  const OrderHintInfo *const order_hint_info = &cm->seq_params.order_hint_info;
  const int comp_pred = ref_frame[1] > INTRA_FRAME;

  if (sf->inter_sf.selective_ref_frame >= 2 ||
      (sf->inter_sf.selective_ref_frame == 1 && comp_pred)) {
    int ref_frame_list[2] = { LAST3_FRAME, LAST2_FRAME };

    if (x != NULL) {
      if (x->search_ref_frame[LAST3_FRAME]) ref_frame_list[0] = NONE_FRAME;
      if (x->search_ref_frame[LAST2_FRAME]) ref_frame_list[1] = NONE_FRAME;
    }

    if (prune_ref(ref_frame, order_hint_info, ref_display_order_hint,
                  ref_display_order_hint[GOLDEN_FRAME - LAST_FRAME],
                  ref_frame_list))
      return 1;
  }

  if (sf->inter_sf.selective_ref_frame >= 3) {
    int ref_frame_list[2] = { ALTREF2_FRAME, BWDREF_FRAME };

    if (x != NULL) {
      if (x->search_ref_frame[ALTREF2_FRAME]) ref_frame_list[0] = NONE_FRAME;
      if (x->search_ref_frame[BWDREF_FRAME]) ref_frame_list[1] = NONE_FRAME;
    }

    if (prune_ref(ref_frame, order_hint_info, ref_display_order_hint,
                  ref_display_order_hint[LAST_FRAME - LAST_FRAME],
                  ref_frame_list))
      return 1;
  }

  return 0;
}

// This function will copy the best reference mode information from
// MB_MODE_INFO_EXT to MB_MODE_INFO_EXT_FRAME.
static INLINE void av1_copy_mbmi_ext_to_mbmi_ext_frame(
    MB_MODE_INFO_EXT_FRAME *mbmi_ext_best,
    const MB_MODE_INFO_EXT *const mbmi_ext, uint8_t ref_frame_type) {
  memcpy(mbmi_ext_best->ref_mv_stack, mbmi_ext->ref_mv_stack[ref_frame_type],
         sizeof(mbmi_ext->ref_mv_stack[USABLE_REF_MV_STACK_SIZE]));
  memcpy(mbmi_ext_best->weight, mbmi_ext->weight[ref_frame_type],
         sizeof(mbmi_ext->weight[USABLE_REF_MV_STACK_SIZE]));
  mbmi_ext_best->mode_context = mbmi_ext->mode_context[ref_frame_type];
  mbmi_ext_best->ref_mv_count = mbmi_ext->ref_mv_count[ref_frame_type];
  memcpy(mbmi_ext_best->global_mvs, mbmi_ext->global_mvs,
         sizeof(mbmi_ext->global_mvs));
}

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // AOM_AV1_ENCODER_RDOPT_H_
