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
#include "third_party/googletest/src/googletest/include/gtest/gtest.h"

#include "./aom_dsp_rtcd.h"
#include "./av1_rtcd.h"

#include "aom_ports/mem.h"
#include "test/acm_random.h"
#include "test/clear_system_state.h"
#include "test/register_state_check.h"
#include "test/transform_test_base.h"
#include "test/util.h"

using libaom_test::ACMRandom;

namespace {
typedef void (*IhtFunc)(const tran_low_t *in, uint8_t *out, int stride,
                        int tx_type);
using std::tr1::tuple;
using libaom_test::FhtFunc;
typedef tuple<FhtFunc, IhtFunc, int, aom_bit_depth_t, int> Ht8x4Param;

void fht8x4_ref(const int16_t *in, tran_low_t *out, int stride, int tx_type) {
  av1_fht8x4_c(in, out, stride, tx_type);
}

void iht8x4_ref(const tran_low_t *in, uint8_t *out, int stride, int tx_type) {
  av1_iht8x4_32_add_c(in, out, stride, tx_type);
}

class AV1Trans8x4HT : public libaom_test::TransformTestBase,
                      public ::testing::TestWithParam<Ht8x4Param> {
 public:
  virtual ~AV1Trans8x4HT() {}

  virtual void SetUp() {
    fwd_txfm_ = GET_PARAM(0);
    inv_txfm_ = GET_PARAM(1);
    tx_type_ = GET_PARAM(2);
    pitch_ = 8;
    height_ = 4;
    fwd_txfm_ref = fht8x4_ref;
    inv_txfm_ref = iht8x4_ref;
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

TEST_P(AV1Trans8x4HT, AccuracyCheck) { RunAccuracyCheck(0, 0.00001); }
TEST_P(AV1Trans8x4HT, CoeffCheck) { RunCoeffCheck(); }
TEST_P(AV1Trans8x4HT, MemCheck) { RunMemCheck(); }
TEST_P(AV1Trans8x4HT, InvCoeffCheck) { RunInvCoeffCheck(); }
TEST_P(AV1Trans8x4HT, InvAccuracyCheck) { RunInvAccuracyCheck(0); }

using std::tr1::make_tuple;

const Ht8x4Param kArrayHt8x4Param_c[] = {
  make_tuple(&av1_fht8x4_c, &av1_iht8x4_32_add_c, 0, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_c, &av1_iht8x4_32_add_c, 1, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_c, &av1_iht8x4_32_add_c, 2, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_c, &av1_iht8x4_32_add_c, 3, AOM_BITS_8, 32),
#if CONFIG_EXT_TX
  make_tuple(&av1_fht8x4_c, &av1_iht8x4_32_add_c, 4, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_c, &av1_iht8x4_32_add_c, 5, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_c, &av1_iht8x4_32_add_c, 6, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_c, &av1_iht8x4_32_add_c, 7, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_c, &av1_iht8x4_32_add_c, 8, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_c, &av1_iht8x4_32_add_c, 9, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_c, &av1_iht8x4_32_add_c, 10, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_c, &av1_iht8x4_32_add_c, 11, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_c, &av1_iht8x4_32_add_c, 12, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_c, &av1_iht8x4_32_add_c, 13, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_c, &av1_iht8x4_32_add_c, 14, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_c, &av1_iht8x4_32_add_c, 15, AOM_BITS_8, 32)
#endif  // CONFIG_EXT_TX
};
INSTANTIATE_TEST_CASE_P(C, AV1Trans8x4HT,
                        ::testing::ValuesIn(kArrayHt8x4Param_c));

#if HAVE_SSE2
const Ht8x4Param kArrayHt8x4Param_sse2[] = {
  make_tuple(&av1_fht8x4_sse2, &av1_iht8x4_32_add_sse2, 0, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_sse2, &av1_iht8x4_32_add_sse2, 1, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_sse2, &av1_iht8x4_32_add_sse2, 2, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_sse2, &av1_iht8x4_32_add_sse2, 3, AOM_BITS_8, 32),
#if CONFIG_EXT_TX
  make_tuple(&av1_fht8x4_sse2, &av1_iht8x4_32_add_sse2, 4, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_sse2, &av1_iht8x4_32_add_sse2, 5, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_sse2, &av1_iht8x4_32_add_sse2, 6, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_sse2, &av1_iht8x4_32_add_sse2, 7, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_sse2, &av1_iht8x4_32_add_sse2, 8, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_sse2, &av1_iht8x4_32_add_sse2, 9, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_sse2, &av1_iht8x4_32_add_sse2, 10, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_sse2, &av1_iht8x4_32_add_sse2, 11, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_sse2, &av1_iht8x4_32_add_sse2, 12, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_sse2, &av1_iht8x4_32_add_sse2, 13, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_sse2, &av1_iht8x4_32_add_sse2, 14, AOM_BITS_8, 32),
  make_tuple(&av1_fht8x4_sse2, &av1_iht8x4_32_add_sse2, 15, AOM_BITS_8, 32)
#endif  // CONFIG_EXT_TX
};
INSTANTIATE_TEST_CASE_P(SSE2, AV1Trans8x4HT,
                        ::testing::ValuesIn(kArrayHt8x4Param_sse2));
#endif  // HAVE_SSE2

}  // namespace
