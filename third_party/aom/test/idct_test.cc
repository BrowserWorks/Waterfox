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

#include "./aom_config.h"
#include "./aom_rtcd.h"

#include "third_party/googletest/src/googletest/include/gtest/gtest.h"

#include "test/clear_system_state.h"
#include "test/register_state_check.h"
#include "aom/aom_integer.h"

typedef void (*IdctFunc)(int16_t *input, unsigned char *pred_ptr,
                         int pred_stride, unsigned char *dst_ptr,
                         int dst_stride);
namespace {
class IDCTTest : public ::testing::TestWithParam<IdctFunc> {
 protected:
  virtual void SetUp() {
    int i;

    UUT = GetParam();
    memset(input, 0, sizeof(input));
    /* Set up guard blocks */
    for (i = 0; i < 256; i++) output[i] = ((i & 0xF) < 4 && (i < 64)) ? 0 : -1;
  }

  virtual void TearDown() { libaom_test::ClearSystemState(); }

  IdctFunc UUT;
  int16_t input[16];
  unsigned char output[256];
  unsigned char predict[256];
};

TEST_P(IDCTTest, TestGuardBlocks) {
  int i;

  for (i = 0; i < 256; i++)
    if ((i & 0xF) < 4 && i < 64)
      EXPECT_EQ(0, output[i]) << i;
    else
      EXPECT_EQ(255, output[i]);
}

TEST_P(IDCTTest, TestAllZeros) {
  int i;

  ASM_REGISTER_STATE_CHECK(UUT(input, output, 16, output, 16));

  for (i = 0; i < 256; i++)
    if ((i & 0xF) < 4 && i < 64)
      EXPECT_EQ(0, output[i]) << "i==" << i;
    else
      EXPECT_EQ(255, output[i]) << "i==" << i;
}

TEST_P(IDCTTest, TestAllOnes) {
  int i;

  input[0] = 4;
  ASM_REGISTER_STATE_CHECK(UUT(input, output, 16, output, 16));

  for (i = 0; i < 256; i++)
    if ((i & 0xF) < 4 && i < 64)
      EXPECT_EQ(1, output[i]) << "i==" << i;
    else
      EXPECT_EQ(255, output[i]) << "i==" << i;
}

TEST_P(IDCTTest, TestAddOne) {
  int i;

  for (i = 0; i < 256; i++) predict[i] = i;
  input[0] = 4;
  ASM_REGISTER_STATE_CHECK(UUT(input, predict, 16, output, 16));

  for (i = 0; i < 256; i++)
    if ((i & 0xF) < 4 && i < 64)
      EXPECT_EQ(i + 1, output[i]) << "i==" << i;
    else
      EXPECT_EQ(255, output[i]) << "i==" << i;
}

TEST_P(IDCTTest, TestWithData) {
  int i;

  for (i = 0; i < 16; i++) input[i] = i;

  ASM_REGISTER_STATE_CHECK(UUT(input, output, 16, output, 16));

  for (i = 0; i < 256; i++)
    if ((i & 0xF) > 3 || i > 63)
      EXPECT_EQ(255, output[i]) << "i==" << i;
    else if (i == 0)
      EXPECT_EQ(11, output[i]) << "i==" << i;
    else if (i == 34)
      EXPECT_EQ(1, output[i]) << "i==" << i;
    else if (i == 2 || i == 17 || i == 32)
      EXPECT_EQ(3, output[i]) << "i==" << i;
    else
      EXPECT_EQ(0, output[i]) << "i==" << i;
}

INSTANTIATE_TEST_CASE_P(C, IDCTTest, ::testing::Values(aom_short_idct4x4llm_c));
#if HAVE_MMX
INSTANTIATE_TEST_CASE_P(MMX, IDCTTest,
                        ::testing::Values(aom_short_idct4x4llm_mmx));
#endif
#if HAVE_MSA
INSTANTIATE_TEST_CASE_P(MSA, IDCTTest,
                        ::testing::Values(aom_short_idct4x4llm_msa));
#endif
}
