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

#ifndef AOM_AV1_ENCODER_VAR_BASED_PART_H_
#define AOM_AV1_ENCODER_VAR_BASED_PART_H_

#include <stdio.h>

#include "config/aom_config.h"
#include "config/aom_dsp_rtcd.h"
#include "config/av1_rtcd.h"

#include "av1/encoder/encoder.h"

#ifdef __cplusplus
extern "C" {
#endif

#define QINDEX_LOW_THR \
  200  // Use low qindex variance partition thresholds when qindex is below this
       // threshold
#define QINDEX_HIGH_THR \
  220  // Use high qindex variance partition thresholds when qindex is above
       // this threshold

void av1_set_variance_partition_thresholds(AV1_COMP *cpi, int q,
                                           int content_state);

int av1_choose_var_based_partitioning(AV1_COMP *cpi, const TileInfo *const tile,
                                      ThreadData *td, MACROBLOCK *x, int mi_row,
                                      int mi_col);

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // AOM_AV1_ENCODER_VAR_BASED_PART_H_
