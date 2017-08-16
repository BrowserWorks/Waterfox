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

#include <math.h>
#include <stdlib.h>
#include <string.h>

#include "third_party/googletest/src/googletest/include/gtest/gtest.h"

#include "./av1_rtcd.h"
#include "./aom_dsp_rtcd.h"
#include "test/acm_random.h"
#include "test/clear_system_state.h"
#include "test/register_state_check.h"
#include "test/transform_test_base.h"
#include "test/util.h"
#include "av1/common/entropy.h"
#include "aom/aom_codec.h"
#include "aom/aom_integer.h"
#include "aom_ports/mem.h"

using libaom_test::ACMRandom;

namespace {
typedef void (*FdctFunc)(const int16_t *in, tran_low_t *out, int stride);
typedef void (*IdctFunc)(const tran_low_t *in, uint8_t *out, int stride);
typedef void (*IhtFunc)(const tran_low_t *in, uint8_t *out, int stride,
                        int tx_type);
using libaom_test::FhtFunc;

typedef std::tr1::tuple<FdctFunc, IdctFunc, int, aom_bit_depth_t, int>
    Dct4x4Param;
typedef std::tr1::tuple<FhtFunc, IhtFunc, int, aom_bit_depth_t, int> Ht4x4Param;

void fdct4x4_ref(const int16_t *in, tran_low_t *out, int stride,
                 int /*tx_type*/) {
  aom_fdct4x4_c(in, out, stride);
}

void fht4x4_ref(const int16_t *in, tran_low_t *out, int stride, int tx_type) {
  av1_fht4x4_c(in, out, stride, tx_type);
}

void fwht4x4_ref(const int16_t *in, tran_low_t *out, int stride,
                 int /*tx_type*/) {
  av1_fwht4x4_c(in, out, stride);
}

#if CONFIG_HIGHBITDEPTH
void idct4x4_10(const tran_low_t *in, uint8_t *out, int stride) {
  aom_highbd_idct4x4_16_add_c(in, out, stride, 10);
}

void idct4x4_12(const tran_low_t *in, uint8_t *out, int stride) {
  aom_highbd_idct4x4_16_add_c(in, out, stride, 12);
}

void iht4x4_10(const tran_low_t *in, uint8_t *out, int stride, int tx_type) {
  av1_highbd_iht4x4_16_add_c(in, out, stride, tx_type, 10);
}

void iht4x4_12(const tran_low_t *in, uint8_t *out, int stride, int tx_type) {
  av1_highbd_iht4x4_16_add_c(in, out, stride, tx_type, 12);
}

void iwht4x4_10(const tran_low_t *in, uint8_t *out, int stride) {
  aom_highbd_iwht4x4_16_add_c(in, out, stride, 10);
}

void iwht4x4_12(const tran_low_t *in, uint8_t *out, int stride) {
  aom_highbd_iwht4x4_16_add_c(in, out, stride, 12);
}

#if HAVE_SSE2
void idct4x4_10_sse2(const tran_low_t *in, uint8_t *out, int stride) {
  aom_highbd_idct4x4_16_add_sse2(in, out, stride, 10);
}

void idct4x4_12_sse2(const tran_low_t *in, uint8_t *out, int stride) {
  aom_highbd_idct4x4_16_add_sse2(in, out, stride, 12);
}
#endif  // HAVE_SSE2
#endif  // CONFIG_HIGHBITDEPTH

class Trans4x4DCT : public libaom_test::TransformTestBase,
                    public ::testing::TestWithParam<Dct4x4Param> {
 public:
  virtual ~Trans4x4DCT() {}

  virtual void SetUp() {
    fwd_txfm_ = GET_PARAM(0);
    inv_txfm_ = GET_PARAM(1);
    tx_type_ = GET_PARAM(2);
    pitch_ = 4;
    height_ = 4;
    fwd_txfm_ref = fdct4x4_ref;
    bit_depth_ = GET_PARAM(3);
    mask_ = (1 << bit_depth_) - 1;
    num_coeffs_ = GET_PARAM(4);
  }
  virtual void TearDown() { libaom_test::ClearSystemState(); }

 protected:
  void RunFwdTxfm(const int16_t *in, tran_low_t *out, int stride) {
    fwd_txfm_(in, out, stride);
  }
  void RunInvTxfm(const tran_low_t *out, uint8_t *dst, int stride) {
    inv_txfm_(out, dst, stride);
  }

  FdctFunc fwd_txfm_;
  IdctFunc inv_txfm_;
};

TEST_P(Trans4x4DCT, AccuracyCheck) { RunAccuracyCheck(0, 0.00001); }

TEST_P(Trans4x4DCT, CoeffCheck) { RunCoeffCheck(); }

TEST_P(Trans4x4DCT, MemCheck) { RunMemCheck(); }

TEST_P(Trans4x4DCT, InvAccuracyCheck) { RunInvAccuracyCheck(1); }

class Trans4x4HT : public libaom_test::TransformTestBase,
                   public ::testing::TestWithParam<Ht4x4Param> {
 public:
  virtual ~Trans4x4HT() {}

  virtual void SetUp() {
    fwd_txfm_ = GET_PARAM(0);
    inv_txfm_ = GET_PARAM(1);
    tx_type_ = GET_PARAM(2);
    pitch_ = 4;
    height_ = 4;
    fwd_txfm_ref = fht4x4_ref;
    bit_depth_ = GET_PARAM(3);
    mask_ = (1 << bit_depth_) - 1;
    num_coeffs_ = GET_PARAM(4);
  }
  virtual void TearDown() { libaom_test::ClearSystemState(); }

 protected:
  void RunFwdTxfm(const int16_t *in, tran_low_t *out, int stride) {
    fwd_txfm_(in, out, stride, tx_type_);
  }

  void RunInvTxfm(const tran_low_t *out, uint8_t *dst, int stride) {
    inv_txfm_(out, dst, stride, tx_type_);
  }

  FhtFunc fwd_txfm_;
  IhtFunc inv_txfm_;
};

TEST_P(Trans4x4HT, AccuracyCheck) { RunAccuracyCheck(1, 0.005); }

TEST_P(Trans4x4HT, CoeffCheck) { RunCoeffCheck(); }

TEST_P(Trans4x4HT, MemCheck) { RunMemCheck(); }

TEST_P(Trans4x4HT, InvAccuracyCheck) { RunInvAccuracyCheck(1); }

class Trans4x4WHT : public libaom_test::TransformTestBase,
                    public ::testing::TestWithParam<Dct4x4Param> {
 public:
  virtual ~Trans4x4WHT() {}

  virtual void SetUp() {
    fwd_txfm_ = GET_PARAM(0);
    inv_txfm_ = GET_PARAM(1);
    tx_type_ = GET_PARAM(2);
    pitch_ = 4;
    height_ = 4;
    fwd_txfm_ref = fwht4x4_ref;
    bit_depth_ = GET_PARAM(3);
    mask_ = (1 << bit_depth_) - 1;
    num_coeffs_ = GET_PARAM(4);
  }
  virtual void TearDown() { libaom_test::ClearSystemState(); }

 protected:
  void RunFwdTxfm(const int16_t *in, tran_low_t *out, int stride) {
    fwd_txfm_(in, out, stride);
  }
  void RunInvTxfm(const tran_low_t *out, uint8_t *dst, int stride) {
    inv_txfm_(out, dst, stride);
  }

  FdctFunc fwd_txfm_;
  IdctFunc inv_txfm_;
};

TEST_P(Trans4x4WHT, AccuracyCheck) { RunAccuracyCheck(0, 0.00001); }

TEST_P(Trans4x4WHT, CoeffCheck) { RunCoeffCheck(); }

TEST_P(Trans4x4WHT, MemCheck) { RunMemCheck(); }

TEST_P(Trans4x4WHT, InvAccuracyCheck) { RunInvAccuracyCheck(0); }
using std::tr1::make_tuple;

#if CONFIG_HIGHBITDEPTH
INSTANTIATE_TEST_CASE_P(
    C, Trans4x4DCT,
    ::testing::Values(
        make_tuple(&aom_highbd_fdct4x4_c, &idct4x4_10, 0, AOM_BITS_10, 16),
        make_tuple(&aom_highbd_fdct4x4_c, &idct4x4_12, 0, AOM_BITS_12, 16),
        make_tuple(&aom_fdct4x4_c, &aom_idct4x4_16_add_c, 0, AOM_BITS_8, 16)));
#else
INSTANTIATE_TEST_CASE_P(C, Trans4x4DCT,
                        ::testing::Values(make_tuple(&aom_fdct4x4_c,
                                                     &aom_idct4x4_16_add_c, 0,
                                                     AOM_BITS_8, 16)));
#endif  // CONFIG_HIGHBITDEPTH

#if CONFIG_HIGHBITDEPTH
INSTANTIATE_TEST_CASE_P(
    C, Trans4x4HT,
    ::testing::Values(
        make_tuple(&av1_highbd_fht4x4_c, &iht4x4_10, 0, AOM_BITS_10, 16),
        make_tuple(&av1_highbd_fht4x4_c, &iht4x4_10, 1, AOM_BITS_10, 16),
        make_tuple(&av1_highbd_fht4x4_c, &iht4x4_10, 2, AOM_BITS_10, 16),
        make_tuple(&av1_highbd_fht4x4_c, &iht4x4_10, 3, AOM_BITS_10, 16),
        make_tuple(&av1_highbd_fht4x4_c, &iht4x4_12, 0, AOM_BITS_12, 16),
        make_tuple(&av1_highbd_fht4x4_c, &iht4x4_12, 1, AOM_BITS_12, 16),
        make_tuple(&av1_highbd_fht4x4_c, &iht4x4_12, 2, AOM_BITS_12, 16),
        make_tuple(&av1_highbd_fht4x4_c, &iht4x4_12, 3, AOM_BITS_12, 16),
        make_tuple(&av1_fht4x4_c, &av1_iht4x4_16_add_c, 0, AOM_BITS_8, 16),
        make_tuple(&av1_fht4x4_c, &av1_iht4x4_16_add_c, 1, AOM_BITS_8, 16),
        make_tuple(&av1_fht4x4_c, &av1_iht4x4_16_add_c, 2, AOM_BITS_8, 16),
        make_tuple(&av1_fht4x4_c, &av1_iht4x4_16_add_c, 3, AOM_BITS_8, 16)));
#else
INSTANTIATE_TEST_CASE_P(
    C, Trans4x4HT,
    ::testing::Values(
        make_tuple(&av1_fht4x4_c, &av1_iht4x4_16_add_c, 0, AOM_BITS_8, 16),
        make_tuple(&av1_fht4x4_c, &av1_iht4x4_16_add_c, 1, AOM_BITS_8, 16),
        make_tuple(&av1_fht4x4_c, &av1_iht4x4_16_add_c, 2, AOM_BITS_8, 16),
        make_tuple(&av1_fht4x4_c, &av1_iht4x4_16_add_c, 3, AOM_BITS_8, 16)));
#endif  // CONFIG_HIGHBITDEPTH

#if CONFIG_HIGHBITDEPTH
INSTANTIATE_TEST_CASE_P(
    C, Trans4x4WHT,
    ::testing::Values(
        make_tuple(&av1_highbd_fwht4x4_c, &iwht4x4_10, 0, AOM_BITS_10, 16),
        make_tuple(&av1_highbd_fwht4x4_c, &iwht4x4_12, 0, AOM_BITS_12, 16),
        make_tuple(&av1_fwht4x4_c, &aom_iwht4x4_16_add_c, 0, AOM_BITS_8, 16)));
#else
INSTANTIATE_TEST_CASE_P(C, Trans4x4WHT,
                        ::testing::Values(make_tuple(&av1_fwht4x4_c,
                                                     &aom_iwht4x4_16_add_c, 0,
                                                     AOM_BITS_8, 16)));
#endif  // CONFIG_HIGHBITDEPTH

#if HAVE_NEON_ASM && !CONFIG_HIGHBITDEPTH
INSTANTIATE_TEST_CASE_P(NEON, Trans4x4DCT,
                        ::testing::Values(make_tuple(&aom_fdct4x4_c,
                                                     &aom_idct4x4_16_add_neon,
                                                     0, AOM_BITS_8, 16)));
#endif  // HAVE_NEON_ASM && !CONFIG_HIGHBITDEPTH

#if HAVE_NEON && !CONFIG_HIGHBITDEPTH
INSTANTIATE_TEST_CASE_P(
    NEON, Trans4x4HT,
    ::testing::Values(
        make_tuple(&av1_fht4x4_c, &av1_iht4x4_16_add_neon, 0, AOM_BITS_8, 16),
        make_tuple(&av1_fht4x4_c, &av1_iht4x4_16_add_neon, 1, AOM_BITS_8, 16),
        make_tuple(&av1_fht4x4_c, &av1_iht4x4_16_add_neon, 2, AOM_BITS_8, 16),
        make_tuple(&av1_fht4x4_c, &av1_iht4x4_16_add_neon, 3, AOM_BITS_8, 16)));
#endif  // HAVE_NEON && !CONFIG_HIGHBITDEPTH

#if HAVE_SSE2
INSTANTIATE_TEST_CASE_P(
    SSE2, Trans4x4WHT,
    ::testing::Values(make_tuple(&av1_fwht4x4_c, &aom_iwht4x4_16_add_c, 0,
                                 AOM_BITS_8, 16),
                      make_tuple(&av1_fwht4x4_c, &aom_iwht4x4_16_add_sse2, 0,
                                 AOM_BITS_8, 16)));
#endif

#if HAVE_SSE2 && !CONFIG_HIGHBITDEPTH
INSTANTIATE_TEST_CASE_P(SSE2, Trans4x4DCT,
                        ::testing::Values(make_tuple(&aom_fdct4x4_sse2,
                                                     &aom_idct4x4_16_add_sse2,
                                                     0, AOM_BITS_8, 16)));
INSTANTIATE_TEST_CASE_P(
    SSE2, Trans4x4HT,
    ::testing::Values(make_tuple(&av1_fht4x4_sse2, &av1_iht4x4_16_add_sse2, 0,
                                 AOM_BITS_8, 16),
                      make_tuple(&av1_fht4x4_sse2, &av1_iht4x4_16_add_sse2, 1,
                                 AOM_BITS_8, 16),
                      make_tuple(&av1_fht4x4_sse2, &av1_iht4x4_16_add_sse2, 2,
                                 AOM_BITS_8, 16),
                      make_tuple(&av1_fht4x4_sse2, &av1_iht4x4_16_add_sse2, 3,
                                 AOM_BITS_8, 16)));
#endif  // HAVE_SSE2 && !CONFIG_HIGHBITDEPTH

#if HAVE_SSE2 && CONFIG_HIGHBITDEPTH
INSTANTIATE_TEST_CASE_P(
    SSE2, Trans4x4DCT,
    ::testing::Values(
        make_tuple(&aom_highbd_fdct4x4_c, &idct4x4_10_sse2, 0, AOM_BITS_10, 16),
        make_tuple(&aom_highbd_fdct4x4_sse2, &idct4x4_10_sse2, 0, AOM_BITS_10,
                   16),
        make_tuple(&aom_highbd_fdct4x4_c, &idct4x4_12_sse2, 0, AOM_BITS_12, 16),
        make_tuple(&aom_highbd_fdct4x4_sse2, &idct4x4_12_sse2, 0, AOM_BITS_12,
                   16),
        make_tuple(&aom_fdct4x4_sse2, &aom_idct4x4_16_add_c, 0, AOM_BITS_8,
                   16)));

INSTANTIATE_TEST_CASE_P(
    SSE2, Trans4x4HT,
    ::testing::Values(
        make_tuple(&av1_fht4x4_sse2, &av1_iht4x4_16_add_c, 0, AOM_BITS_8, 16),
        make_tuple(&av1_fht4x4_sse2, &av1_iht4x4_16_add_c, 1, AOM_BITS_8, 16),
        make_tuple(&av1_fht4x4_sse2, &av1_iht4x4_16_add_c, 2, AOM_BITS_8, 16),
        make_tuple(&av1_fht4x4_sse2, &av1_iht4x4_16_add_c, 3, AOM_BITS_8, 16)));
#endif  // HAVE_SSE2 && CONFIG_HIGHBITDEPTH

#if HAVE_MSA && !CONFIG_HIGHBITDEPTH
INSTANTIATE_TEST_CASE_P(MSA, Trans4x4DCT,
                        ::testing::Values(make_tuple(&aom_fdct4x4_msa,
                                                     &aom_idct4x4_16_add_msa, 0,
                                                     AOM_BITS_8, 16)));
#if !CONFIG_EXT_TX
INSTANTIATE_TEST_CASE_P(
    MSA, Trans4x4HT,
    ::testing::Values(
        make_tuple(&av1_fht4x4_msa, &av1_iht4x4_16_add_msa, 0, AOM_BITS_8, 16),
        make_tuple(&av1_fht4x4_msa, &av1_iht4x4_16_add_msa, 1, AOM_BITS_8, 16),
        make_tuple(&av1_fht4x4_msa, &av1_iht4x4_16_add_msa, 2, AOM_BITS_8, 16),
        make_tuple(&av1_fht4x4_msa, &av1_iht4x4_16_add_msa, 3, AOM_BITS_8,
                   16)));
#endif  // !CONFIG_EXT_TX
#endif  // HAVE_MSA && !CONFIG_HIGHBITDEPTH
}  // namespace
