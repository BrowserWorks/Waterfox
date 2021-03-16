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

#ifndef AOM_AV1_ENCODER_CONTEXT_TREE_H_
#define AOM_AV1_ENCODER_CONTEXT_TREE_H_

#include "config/aom_config.h"

#include "av1/common/blockd.h"
#include "av1/encoder/block.h"

#ifdef __cplusplus
extern "C" {
#endif

struct AV1_COMP;
struct AV1Common;
struct ThreadData;

// Structure to hold snapshot of coding context during the mode picking process
typedef struct {
  MB_MODE_INFO mic;
  MB_MODE_INFO_EXT_FRAME mbmi_ext_best;
  uint8_t *color_index_map[2];
  uint8_t *blk_skip;

  tran_low_t *coeff[MAX_MB_PLANE];
  tran_low_t *qcoeff[MAX_MB_PLANE];
  tran_low_t *dqcoeff[MAX_MB_PLANE];
  uint16_t *eobs[MAX_MB_PLANE];
  uint8_t *txb_entropy_ctx[MAX_MB_PLANE];
  uint8_t *tx_type_map;

  int num_4x4_blk;
  // For current partition, only if all Y, U, and V transform blocks'
  // coefficients are quantized to 0, skippable is set to 1.
  int skippable;
#if CONFIG_INTERNAL_STATS
  THR_MODES best_mode_index;
#endif  // CONFIG_INTERNAL_STATS
  int hybrid_pred_diff;
  int comp_pred_diff;
  int single_pred_diff;

  RD_STATS rd_stats;

  int rd_mode_is_ready;  // Flag to indicate whether rd pick mode decision has
                         // been made.

  // motion vector cache for adaptive motion search control in partition
  // search loop
  MV pred_mv[REF_FRAMES];
  PARTITION_TYPE partition;
} PICK_MODE_CONTEXT;

typedef struct PC_TREE {
  PARTITION_TYPE partitioning;
  BLOCK_SIZE block_size;
  PICK_MODE_CONTEXT none;
  PICK_MODE_CONTEXT horizontal[2];
  PICK_MODE_CONTEXT vertical[2];
  PICK_MODE_CONTEXT horizontala[3];
  PICK_MODE_CONTEXT horizontalb[3];
  PICK_MODE_CONTEXT verticala[3];
  PICK_MODE_CONTEXT verticalb[3];
  PICK_MODE_CONTEXT horizontal4[4];
  PICK_MODE_CONTEXT vertical4[4];
  struct PC_TREE *split[4];
  int index;

  // Simple motion search_features
  FULLPEL_MV start_mvs[REF_FRAMES];
  unsigned int sms_none_feat[2];
  unsigned int sms_rect_feat[8];
  int sms_none_valid;
  int sms_rect_valid;
} PC_TREE;

void av1_setup_pc_tree(struct AV1_COMP *const cpi, struct ThreadData *td);
void av1_free_pc_tree(const struct AV1_COMP *const cpi, struct ThreadData *td,
                      const int num_planes, BLOCK_SIZE sb_size);
void av1_copy_tree_context(PICK_MODE_CONTEXT *dst_ctx,
                           PICK_MODE_CONTEXT *src_ctx);

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // AOM_AV1_ENCODER_CONTEXT_TREE_H_
