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

#ifndef AV1_TXFM_TEST_H_
#define AV1_TXFM_TEST_H_

#include <stdio.h>
#include <stdlib.h>
#ifdef _MSC_VER
#define _USE_MATH_DEFINES
#endif
#include <math.h>

#include "third_party/googletest/src/googletest/include/gtest/gtest.h"

#include "test/acm_random.h"
#include "av1/common/enums.h"
#include "av1/common/av1_txfm.h"
#include "./av1_rtcd.h"

namespace libaom_test {
typedef enum {
  TYPE_DCT = 0,
  TYPE_ADST,
  TYPE_IDCT,
  TYPE_IADST,
  TYPE_LAST
} TYPE_TXFM;

int get_txfm1d_size(TX_SIZE tx_size);

void get_txfm1d_type(TX_TYPE txfm2d_type, TYPE_TXFM *type0, TYPE_TXFM *type1);

void reference_dct_1d(const double *in, double *out, int size);

void reference_adst_1d(const double *in, double *out, int size);

void reference_hybrid_1d(double *in, double *out, int size, int type);

void reference_hybrid_2d(double *in, double *out, int size, int type0,
                         int type1);
template <typename Type1, typename Type2>
static double compute_avg_abs_error(const Type1 *a, const Type2 *b,
                                    const int size) {
  double error = 0;
  for (int i = 0; i < size; i++) {
    error += fabs(static_cast<double>(a[i]) - static_cast<double>(b[i]));
  }
  error = error / size;
  return error;
}

template <typename Type>
void fliplr(Type *dest, int stride, int length);

template <typename Type>
void flipud(Type *dest, int stride, int length);

template <typename Type>
void fliplrud(Type *dest, int stride, int length);

typedef void (*TxfmFunc)(const int32_t *in, int32_t *out, const int8_t *cos_bit,
                         const int8_t *range_bit);

typedef void (*Fwd_Txfm2d_Func)(const int16_t *, int32_t *, int, int, int);
typedef void (*Inv_Txfm2d_Func)(const int32_t *, uint16_t *, int, int, int);

static const int bd = 10;
static const int input_base = (1 << bd);

#if CONFIG_HIGHBITDEPTH
#if CONFIG_AV1_ENCODER
static const Fwd_Txfm2d_Func fwd_txfm_func_ls[TX_SIZES] = {
#if CONFIG_CHROMA_2X2
  NULL,
#endif
  av1_fwd_txfm2d_4x4_c, av1_fwd_txfm2d_8x8_c, av1_fwd_txfm2d_16x16_c,
  av1_fwd_txfm2d_32x32_c
};
#endif

static const Inv_Txfm2d_Func inv_txfm_func_ls[TX_SIZES] = {
#if CONFIG_CHROMA_2X2
  NULL,
#endif
  av1_inv_txfm2d_add_4x4_c, av1_inv_txfm2d_add_8x8_c,
  av1_inv_txfm2d_add_16x16_c, av1_inv_txfm2d_add_32x32_c
};
#endif  // CONFIG_HIGHBITDEPTH

}  // namespace libaom_test
#endif  // AV1_TXFM_TEST_H_
