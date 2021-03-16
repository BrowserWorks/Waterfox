/*
 * Copyright (c) 2019, Alliance for Open Media. All rights reserved
 *
 * This source code is subject to the terms of the BSD 2 Clause License and
 * the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
 * was not distributed with this source code in the LICENSE file, you can
 * obtain it at www.aomedia.org/license/software. If the Alliance for Open
 * Media Patent License 1.0 was not distributed with this source code in the
 * PATENTS file, you can obtain it at www.aomedia.org/license/patent.
 */

#ifndef AOM_AV1_ENCODER_MV_PREC_H_
#define AOM_AV1_ENCODER_MV_PREC_H_

#include "av1/encoder/encoder.h"
#include "av1/encoder/speed_features.h"

// Q threshold for high precision mv.
#define HIGH_PRECISION_MV_QTHRESH 128
#if !CONFIG_REALTIME_ONLY
void av1_collect_mv_stats(AV1_COMP *cpi, int current_q);

static AOM_INLINE int av1_frame_allows_smart_mv(const AV1_COMP *cpi) {
  const int gf_group_index = cpi->gf_group.index;
  const int gf_update_type = cpi->gf_group.update_type[gf_group_index];
  return !frame_is_intra_only(&cpi->common) &&
         !(gf_update_type == INTNL_OVERLAY_UPDATE ||
           gf_update_type == OVERLAY_UPDATE);
}
#endif  // !CONFIG_REALTIME_ONLY

static AOM_INLINE void av1_set_high_precision_mv(
    AV1_COMP *cpi, int allow_high_precision_mv,
    int cur_frame_force_integer_mv) {
  MACROBLOCK *const x = &cpi->td.mb;
  const int copy_hp = cpi->common.features.allow_high_precision_mv =
      allow_high_precision_mv && !cur_frame_force_integer_mv;
  x->nmvcost[0] = &x->nmv_costs[0][MV_MAX];
  x->nmvcost[1] = &x->nmv_costs[1][MV_MAX];
  x->nmvcost_hp[0] = &x->nmv_costs_hp[0][MV_MAX];
  x->nmvcost_hp[1] = &x->nmv_costs_hp[1][MV_MAX];
  int *(*src)[2] = copy_hp ? &x->nmvcost_hp : &x->nmvcost;
  x->mv_cost_stack = *src;
}

void av1_pick_and_set_high_precision_mv(AV1_COMP *cpi, int qindex);

#endif  // AOM_AV1_ENCODER_MV_PREC_H_
