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

#ifndef AV1_INV_TXFM2D_CFG_H_
#define AV1_INV_TXFM2D_CFG_H_
#include "av1/common/av1_inv_txfm1d.h"
// Identity will always use max bitdepth regardless of size
static const int8_t inv_stage_range_identity[1] = { 12 };

//  ---------------- 4x4 1D config -----------------------
// shift
static const int8_t inv_shift_4[2] = { 0, -4 };

// stage range
static const int8_t inv_stage_range_col_dct_4[4] = { 18, 18, 17, 17 };
static const int8_t inv_stage_range_row_dct_4[4] = { 18, 18, 18, 18 };
static const int8_t inv_stage_range_col_adst_4[6] = { 18, 18, 18, 18, 17, 17 };
static const int8_t inv_stage_range_row_adst_4[6] = { 18, 18, 18, 18, 18, 18 };
// cos bit
static const int8_t inv_cos_bit_col_dct_4[4] = { 13, 13, 13, 13 };
static const int8_t inv_cos_bit_row_dct_4[4] = { 13, 13, 13, 13 };
static const int8_t inv_cos_bit_col_adst_4[6] = { 13, 13, 13, 13, 13, 13 };
static const int8_t inv_cos_bit_row_adst_4[6] = { 13, 13, 13, 13, 13, 13 };

//  ---------------- 8x8 1D constants -----------------------
// shift
static const int8_t inv_shift_8[2] = { 0, -5 };

// stage range
static const int8_t inv_stage_range_col_dct_8[6] = { 19, 19, 19, 19, 18, 18 };
static const int8_t inv_stage_range_row_dct_8[6] = { 19, 19, 19, 19, 19, 19 };
static const int8_t inv_stage_range_col_adst_8[8] = { 19, 19, 19, 19,
                                                      19, 19, 18, 18 };
static const int8_t inv_stage_range_row_adst_8[8] = { 19, 19, 19, 19,
                                                      19, 19, 19, 19 };
// cos bit
static const int8_t inv_cos_bit_col_dct_8[6] = { 13, 13, 13, 13, 13, 13 };
static const int8_t inv_cos_bit_row_dct_8[6] = { 13, 13, 13, 13, 13, 13 };
static const int8_t inv_cos_bit_col_adst_8[8] = {
  13, 13, 13, 13, 13, 13, 13, 13
};
static const int8_t inv_cos_bit_row_adst_8[8] = {
  13, 13, 13, 13, 13, 13, 13, 13
};

//  ---------------- 16x16 1D constants -----------------------
// shift
static const int8_t inv_shift_16[2] = { -1, -5 };

// stage range
static const int8_t inv_stage_range_col_dct_16[8] = { 19, 19, 19, 19,
                                                      19, 19, 18, 18 };
static const int8_t inv_stage_range_row_dct_16[8] = { 20, 20, 20, 20,
                                                      20, 20, 20, 20 };
static const int8_t inv_stage_range_col_adst_16[10] = { 19, 19, 19, 19, 19,
                                                        19, 19, 19, 18, 18 };
static const int8_t inv_stage_range_row_adst_16[10] = { 20, 20, 20, 20, 20,
                                                        20, 20, 20, 20, 20 };

// cos bit
static const int8_t inv_cos_bit_col_dct_16[8] = {
  13, 13, 13, 13, 13, 13, 13, 13
};
static const int8_t inv_cos_bit_row_dct_16[8] = {
  12, 12, 12, 12, 12, 12, 12, 12
};
static const int8_t inv_cos_bit_col_adst_16[10] = { 13, 13, 13, 13, 13,
                                                    13, 13, 13, 13, 13 };
static const int8_t inv_cos_bit_row_adst_16[10] = { 12, 12, 12, 12, 12,
                                                    12, 12, 12, 12, 12 };

//  ---------------- 32x32 1D constants -----------------------
// shift
static const int8_t inv_shift_32[2] = { -1, -5 };

// stage range
static const int8_t inv_stage_range_col_dct_32[10] = { 19, 19, 19, 19, 19,
                                                       19, 19, 19, 18, 18 };
static const int8_t inv_stage_range_row_dct_32[10] = { 20, 20, 20, 20, 20,
                                                       20, 20, 20, 20, 20 };
static const int8_t inv_stage_range_col_adst_32[12] = {
  19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 18, 18
};
static const int8_t inv_stage_range_row_adst_32[12] = {
  20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
};

// cos bit
static const int8_t inv_cos_bit_col_dct_32[10] = { 13, 13, 13, 13, 13,
                                                   13, 13, 13, 13, 13 };
static const int8_t inv_cos_bit_row_dct_32[10] = { 12, 12, 12, 12, 12,
                                                   12, 12, 12, 12, 12 };
static const int8_t inv_cos_bit_col_adst_32[12] = { 13, 13, 13, 13, 13, 13,
                                                    13, 13, 13, 13, 13, 13 };
static const int8_t inv_cos_bit_row_adst_32[12] = { 12, 12, 12, 12, 12, 12,
                                                    12, 12, 12, 12, 12, 12 };

//  ---------------- 64x64 1D constants -----------------------
// shift
static const int8_t inv_shift_64[2] = { -1, -7 };

// stage range
static const int8_t inv_stage_range_col_dct_64[12] = { 19, 19, 19, 19, 19, 19,
                                                       19, 19, 19, 19, 18, 18 };
static const int8_t inv_stage_range_row_dct_64[12] = { 20, 20, 20, 20, 20, 20,
                                                       20, 20, 20, 20, 20, 20 };

// cos bit
static const int8_t inv_cos_bit_col_dct_64[12] = { 13, 13, 13, 13, 13, 13,
                                                   13, 13, 13, 13, 13, 13 };
static const int8_t inv_cos_bit_row_dct_64[12] = { 12, 12, 12, 12, 12, 12,
                                                   12, 12, 12, 12, 12, 12 };

//  ---------------- row config inv_dct_4 ----------------
static const TXFM_1D_CFG inv_txfm_1d_row_cfg_dct_4 = {
  4,  // .txfm_size
  4,  // .stage_num
  // 0,  // .log_scale
  inv_shift_4,                // .shift
  inv_stage_range_row_dct_4,  // .stage_range
  inv_cos_bit_row_dct_4,      // .cos_bit
  TXFM_TYPE_DCT4              // .txfm_type
};

//  ---------------- row config inv_dct_8 ----------------
static const TXFM_1D_CFG inv_txfm_1d_row_cfg_dct_8 = {
  8,  // .txfm_size
  6,  // .stage_num
  // 0,  // .log_scale
  inv_shift_8,                // .shift
  inv_stage_range_row_dct_8,  // .stage_range
  inv_cos_bit_row_dct_8,      // .cos_bit_
  TXFM_TYPE_DCT8              // .txfm_type
};
//  ---------------- row config inv_dct_16 ----------------
static const TXFM_1D_CFG inv_txfm_1d_row_cfg_dct_16 = {
  16,  // .txfm_size
  8,   // .stage_num
  // 0,  // .log_scale
  inv_shift_16,                // .shift
  inv_stage_range_row_dct_16,  // .stage_range
  inv_cos_bit_row_dct_16,      // .cos_bit
  TXFM_TYPE_DCT16              // .txfm_type
};

//  ---------------- row config inv_dct_32 ----------------
static const TXFM_1D_CFG inv_txfm_1d_row_cfg_dct_32 = {
  32,  // .txfm_size
  10,  // .stage_num
  // 1,  // .log_scale
  inv_shift_32,                // .shift
  inv_stage_range_row_dct_32,  // .stage_range
  inv_cos_bit_row_dct_32,      // .cos_bit_row
  TXFM_TYPE_DCT32              // .txfm_type
};

//  ---------------- row config inv_dct_64 ----------------
static const TXFM_1D_CFG inv_txfm_1d_row_cfg_dct_64 = {
  64,                          // .txfm_size
  12,                          // .stage_num
  inv_shift_64,                // .shift
  inv_stage_range_row_dct_64,  // .stage_range
  inv_cos_bit_row_dct_64,      // .cos_bit
  TXFM_TYPE_DCT64,             // .txfm_type_col
};

//  ---------------- row config inv_adst_4 ----------------
static const TXFM_1D_CFG inv_txfm_1d_row_cfg_adst_4 = {
  4,  // .txfm_size
  6,  // .stage_num
  // 0,  // .log_scale
  inv_shift_4,                 // .shift
  inv_stage_range_row_adst_4,  // .stage_range
  inv_cos_bit_row_adst_4,      // .cos_bit
  TXFM_TYPE_ADST4,             // .txfm_type
};

//  ---------------- row config inv_adst_8 ----------------
static const TXFM_1D_CFG inv_txfm_1d_row_cfg_adst_8 = {
  8,  // .txfm_size
  8,  // .stage_num
  // 0,  // .log_scale
  inv_shift_8,                 // .shift
  inv_stage_range_row_adst_8,  // .stage_range
  inv_cos_bit_row_adst_8,      // .cos_bit
  TXFM_TYPE_ADST8,             // .txfm_type_col
};

//  ---------------- row config inv_adst_16 ----------------
static const TXFM_1D_CFG inv_txfm_1d_row_cfg_adst_16 = {
  16,  // .txfm_size
  10,  // .stage_num
  // 0,  // .log_scale
  inv_shift_16,                 // .shift
  inv_stage_range_row_adst_16,  // .stage_range
  inv_cos_bit_row_adst_16,      // .cos_bit
  TXFM_TYPE_ADST16,             // .txfm_type
};

//  ---------------- row config inv_adst_32 ----------------
static const TXFM_1D_CFG inv_txfm_1d_row_cfg_adst_32 = {
  32,  // .txfm_size
  12,  // .stage_num
  // 1,  // .log_scale
  inv_shift_32,                 // .shift
  inv_stage_range_row_adst_32,  // .stage_range
  inv_cos_bit_row_adst_32,      // .cos_bit
  TXFM_TYPE_ADST32,             // .txfm_type
};

//  ---------------- col config inv_dct_4 ----------------
static const TXFM_1D_CFG inv_txfm_1d_col_cfg_dct_4 = {
  4,  // .txfm_size
  4,  // .stage_num
  // 0,  // .log_scale
  inv_shift_4,                // .shift
  inv_stage_range_col_dct_4,  // .stage_range
  inv_cos_bit_col_dct_4,      // .cos_bit
  TXFM_TYPE_DCT4              // .txfm_type
};

//  ---------------- col config inv_dct_8 ----------------
static const TXFM_1D_CFG inv_txfm_1d_col_cfg_dct_8 = {
  8,  // .txfm_size
  6,  // .stage_num
  // 0,  // .log_scale
  inv_shift_8,                // .shift
  inv_stage_range_col_dct_8,  // .stage_range
  inv_cos_bit_col_dct_8,      // .cos_bit_
  TXFM_TYPE_DCT8              // .txfm_type
};
//  ---------------- col config inv_dct_16 ----------------
static const TXFM_1D_CFG inv_txfm_1d_col_cfg_dct_16 = {
  16,  // .txfm_size
  8,   // .stage_num
  // 0,  // .log_scale
  inv_shift_16,                // .shift
  inv_stage_range_col_dct_16,  // .stage_range
  inv_cos_bit_col_dct_16,      // .cos_bit
  TXFM_TYPE_DCT16              // .txfm_type
};

//  ---------------- col config inv_dct_32 ----------------
static const TXFM_1D_CFG inv_txfm_1d_col_cfg_dct_32 = {
  32,  // .txfm_size
  10,  // .stage_num
  // 1,  // .log_scale
  inv_shift_32,                // .shift
  inv_stage_range_col_dct_32,  // .stage_range
  inv_cos_bit_col_dct_32,      // .cos_bit_col
  TXFM_TYPE_DCT32              // .txfm_type
};

//  ---------------- col config inv_dct_64 ----------------
static const TXFM_1D_CFG inv_txfm_1d_col_cfg_dct_64 = {
  64,                          // .txfm_size
  12,                          // .stage_num
  inv_shift_64,                // .shift
  inv_stage_range_col_dct_64,  // .stage_range
  inv_cos_bit_col_dct_64,      // .cos_bit
  TXFM_TYPE_DCT64,             // .txfm_type_col
};

//  ---------------- col config inv_adst_4 ----------------
static const TXFM_1D_CFG inv_txfm_1d_col_cfg_adst_4 = {
  4,  // .txfm_size
  6,  // .stage_num
  // 0,  // .log_scale
  inv_shift_4,                 // .shift
  inv_stage_range_col_adst_4,  // .stage_range
  inv_cos_bit_col_adst_4,      // .cos_bit
  TXFM_TYPE_ADST4,             // .txfm_type
};

//  ---------------- col config inv_adst_8 ----------------
static const TXFM_1D_CFG inv_txfm_1d_col_cfg_adst_8 = {
  8,  // .txfm_size
  8,  // .stage_num
  // 0,  // .log_scale
  inv_shift_8,                 // .shift
  inv_stage_range_col_adst_8,  // .stage_range
  inv_cos_bit_col_adst_8,      // .cos_bit
  TXFM_TYPE_ADST8,             // .txfm_type_col
};

//  ---------------- col config inv_adst_16 ----------------
static const TXFM_1D_CFG inv_txfm_1d_col_cfg_adst_16 = {
  16,  // .txfm_size
  10,  // .stage_num
  // 0,  // .log_scale
  inv_shift_16,                 // .shift
  inv_stage_range_col_adst_16,  // .stage_range
  inv_cos_bit_col_adst_16,      // .cos_bit
  TXFM_TYPE_ADST16,             // .txfm_type
};

//  ---------------- col config inv_adst_32 ----------------
static const TXFM_1D_CFG inv_txfm_1d_col_cfg_adst_32 = {
  32,  // .txfm_size
  12,  // .stage_num
  // 1,  // .log_scale
  inv_shift_32,                 // .shift
  inv_stage_range_col_adst_32,  // .stage_range
  inv_cos_bit_col_adst_32,      // .cos_bit
  TXFM_TYPE_ADST32,             // .txfm_type
};

#if CONFIG_EXT_TX
// identity does not need to differentiate between row and col
//  ---------------- row/col config inv_identity_4 ----------
static const TXFM_1D_CFG inv_txfm_1d_cfg_identity_4 = {
  4,  // .txfm_size
  1,  // .stage_num
  // 0,  // .log_scale
  inv_shift_4,               // .shift
  inv_stage_range_identity,  // .stage_range
  NULL,                      // .cos_bit
  TXFM_TYPE_IDENTITY4,       // .txfm_type
};

//  ---------------- row/col config inv_identity_8 ----------------
static const TXFM_1D_CFG inv_txfm_1d_cfg_identity_8 = {
  8,  // .txfm_size
  1,  // .stage_num
  // 0,  // .log_scale
  inv_shift_8,               // .shift
  inv_stage_range_identity,  // .stage_range
  NULL,                      // .cos_bit
  TXFM_TYPE_IDENTITY8,       // .txfm_type
};

//  ---------------- row/col config inv_identity_16 ----------------
static const TXFM_1D_CFG inv_txfm_1d_cfg_identity_16 = {
  16,  // .txfm_size
  1,   // .stage_num
  // 0,  // .log_scale
  inv_shift_16,              // .shift
  inv_stage_range_identity,  // .stage_range
  NULL,                      // .cos_bit
  TXFM_TYPE_IDENTITY16,      // .txfm_type
};

//  ---------------- row/col config inv_identity_32 ----------------
static const TXFM_1D_CFG inv_txfm_1d_cfg_identity_32 = {
  32,  // .txfm_size
  1,   // .stage_num
  // 1,  // .log_scale
  inv_shift_32,              // .shift
  inv_stage_range_identity,  // .stage_range
  NULL,                      // .cos_bit
  TXFM_TYPE_IDENTITY32,      // .txfm_type
};
#endif  // CONFIG_EXT_TX
#endif  // AV1_INV_TXFM2D_CFG_H_
