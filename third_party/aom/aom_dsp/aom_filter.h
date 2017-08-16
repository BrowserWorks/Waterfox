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

#ifndef AOM_DSP_AOM_FILTER_H_
#define AOM_DSP_AOM_FILTER_H_

#include "aom/aom_integer.h"

#ifdef __cplusplus
extern "C" {
#endif

#define FILTER_BITS 7

#define SUBPEL_BITS 4
#define SUBPEL_MASK ((1 << SUBPEL_BITS) - 1)
#define SUBPEL_SHIFTS (1 << SUBPEL_BITS)
#define SUBPEL_TAPS 8

typedef int16_t InterpKernel[SUBPEL_TAPS];

#define BIL_SUBPEL_BITS 3
#define BIL_SUBPEL_SHIFTS (1 << BIL_SUBPEL_BITS)

// 2 tap bilinear filters
static const uint8_t bilinear_filters_2t[BIL_SUBPEL_SHIFTS][2] = {
  { 128, 0 }, { 112, 16 }, { 96, 32 }, { 80, 48 },
  { 64, 64 }, { 48, 80 },  { 32, 96 }, { 16, 112 },
};

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // AOM_DSP_AOM_FILTER_H_
