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

#ifndef AOM_AV1_ENCODER_TUNE_VMAF_H_
#define AOM_AV1_ENCODER_TUNE_VMAF_H_

#include "aom_scale/yv12config.h"
#include "av1/encoder/encoder.h"

void av1_vmaf_blk_preprocessing(AV1_COMP *cpi, YV12_BUFFER_CONFIG *source);

void av1_vmaf_frame_preprocessing(AV1_COMP *cpi, YV12_BUFFER_CONFIG *source);

void av1_set_mb_vmaf_rdmult_scaling(AV1_COMP *cpi);

void av1_set_vmaf_rdmult(const AV1_COMP *cpi, MACROBLOCK *x, BLOCK_SIZE bsize,
                         int mi_row, int mi_col, int *rdmult);

int av1_get_vmaf_base_qindex(const AV1_COMP *cpi, int current_qindex);

void av1_update_vmaf_curve(AV1_COMP *cpi, YV12_BUFFER_CONFIG *source,
                           YV12_BUFFER_CONFIG *recon);

#endif  // AOM_AV1_ENCODER_TUNE_VMAF_H_
