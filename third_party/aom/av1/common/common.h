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

#ifndef AV1_COMMON_COMMON_H_
#define AV1_COMMON_COMMON_H_

/* Interface header for common constant data structures and lookup tables */

#include <assert.h>

#include "aom_dsp/aom_dsp_common.h"
#include "aom_mem/aom_mem.h"
#include "aom/aom_integer.h"
#include "aom_ports/bitops.h"

#ifdef __cplusplus
extern "C" {
#endif

#define PI 3.141592653589793238462643383279502884

// Only need this for fixed-size arrays, for structs just assign.
#define av1_copy(dest, src)              \
  {                                      \
    assert(sizeof(dest) == sizeof(src)); \
    memcpy(dest, src, sizeof(src));      \
  }

// Use this for variably-sized arrays.
#define av1_copy_array(dest, src, n)           \
  {                                            \
    assert(sizeof(*(dest)) == sizeof(*(src))); \
    memcpy(dest, src, n * sizeof(*(src)));     \
  }

#define av1_zero(dest) memset(&(dest), 0, sizeof(dest))
#define av1_zero_array(dest, n) memset(dest, 0, n * sizeof(*(dest)))

static INLINE int get_unsigned_bits(unsigned int num_values) {
  return num_values > 0 ? get_msb(num_values) + 1 : 0;
}

#define CHECK_MEM_ERROR(cm, lval, expr) \
  AOM_CHECK_MEM_ERROR(&cm->error, lval, expr)
// TODO(yaowu: validate the usage of these codes or develop new ones.)
#define AV1_SYNC_CODE_0 0x49
#define AV1_SYNC_CODE_1 0x83
#define AV1_SYNC_CODE_2 0x43

#define AOM_FRAME_MARKER 0x2

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // AV1_COMMON_COMMON_H_
