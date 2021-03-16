/*
 * Copyright (c) 2018, Alliance for Open Media. All rights reserved
 *
 * This source code is subject to the terms of the BSD 2 Clause License and
 * the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
 * was not distributed with this source code in the LICENSE file, you can
 * obtain it at www.aomedia.org/license/software. If the Alliance for Open
 * Media Patent License 1.0 was not distributed with this source code in the
 * PATENTS file, you can obtain it at www.aomedia.org/license/patent.
 */

#ifndef AV1_ENCODER_AV1_MULTI_THREAD_H
#define AV1_ENCODER_AV1_MULTI_THREAD_H

#include "av1/encoder/encoder.h"

void av1_row_mt_mem_alloc(AV1_COMP *cpi, int max_sb_rows);

void av1_row_mt_mem_dealloc(AV1_COMP *cpi);

#endif  // AV1_ENCODER_AV1_MULTI_THREAD_H
