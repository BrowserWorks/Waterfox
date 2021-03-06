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

#include <math.h>

#include "config/aom_config.h"
#include "config/aom_dsp_rtcd.h"

#include "aom_dsp/aom_dsp_common.h"
#include "aom_mem/aom_mem.h"
#include "aom_ports/mem.h"
#include "av1/common/av1_common_int.h"
#include "av1/common/av1_loopfilter.h"
#include "av1/common/reconinter.h"
#include "av1/common/seg_common.h"

// 256 bit masks (64x64 / 4x4) for left transform size for Y plane.
// We use 4 uint64_t to represent the 256 bit.
// Each 1 represents a position where we should apply a loop filter
// across the left border of an 4x4 block boundary.
//
// In the case of TX_8x8->  ( in low order byte first we end up with
// a mask that looks like this (-- and | are used for better view)
//
//    10101010|10101010
//    10101010|10101010
//    10101010|10101010
//    10101010|10101010
//    10101010|10101010
//    10101010|10101010
//    10101010|10101010
//    10101010|10101010
//    -----------------
//    10101010|10101010
//    10101010|10101010
//    10101010|10101010
//    10101010|10101010
//    10101010|10101010
//    10101010|10101010
//    10101010|10101010
//    10101010|10101010
//
// A loopfilter should be applied to every other 4x4 horizontally.

// 256 bit masks (64x64 / 4x4) for above transform size for Y plane.
// We use 4 uint64_t to represent the 256 bit.
// Each 1 represents a position where we should apply a loop filter
// across the top border of an 4x4 block boundary.
//
// In the case of TX_8x8->  ( in low order byte first we end up with
// a mask that looks like this
//
//    11111111|11111111
//    00000000|00000000
//    11111111|11111111
//    00000000|00000000
//    11111111|11111111
//    00000000|00000000
//    11111111|11111111
//    00000000|00000000
//    -----------------
//    11111111|11111111
//    00000000|00000000
//    11111111|11111111
//    00000000|00000000
//    11111111|11111111
//    00000000|00000000
//    11111111|11111111
//    00000000|00000000
//
// A loopfilter should be applied to every other 4x4 horizontally.
#if CONFIG_LPF_MASK
static const int mask_id_table_tx_4x4[BLOCK_SIZES_ALL] = {
  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, -1, -1, -1, 13, 14, 15, 16, 17, 18
};

static const int mask_id_table_tx_8x8[BLOCK_SIZES_ALL] = {
  -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, -1, -1, -1, -1, -1, 10, 11, 12, 13
};

static const int mask_id_table_tx_16x16[BLOCK_SIZES_ALL] = {
  -1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, -1, -1, -1, -1, -1, -1, -1, 7, 8
};

static const int mask_id_table_tx_32x32[BLOCK_SIZES_ALL] = {
  -1, -1, -1, -1, -1, -1, -1, -1, -1, 0,  1,
  2,  3,  -1, -1, -1, -1, -1, -1, -1, -1, -1
};
static const int mask_id_table_vert_border[BLOCK_SIZES_ALL] = {
  0,  47, 49, 19, 51, 53, 33, 55, 57, 42, 59,
  60, 46, -1, -1, -1, 61, 62, 63, 64, 65, 66
};

static const FilterMask left_mask_univariant_reordered[67] = {
  // TX_4X4
  { { 0x0000000000000001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 4X4, TX_4X4
  { { 0x0000000000010001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 4X8, TX_4X4
  { { 0x0000000000000003ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X4, TX_4X4
  { { 0x0000000000030003ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X8, TX_4X4
  { { 0x0003000300030003ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X16, TX_4X4
  { { 0x00000000000f000fULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X8, TX_4X4
  { { 0x000f000f000f000fULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X16, TX_4X4
  { { 0x000f000f000f000fULL, 0x000f000f000f000fULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X32, TX_4X4
  { { 0x00ff00ff00ff00ffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X16, TX_4X4
  { { 0x00ff00ff00ff00ffULL, 0x00ff00ff00ff00ffULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X32, TX_4X4
  { { 0x00ff00ff00ff00ffULL, 0x00ff00ff00ff00ffULL, 0x00ff00ff00ff00ffULL,
      0x00ff00ff00ff00ffULL } },  // block size 32X64, TX_4X4
  { { 0xffffffffffffffffULL, 0xffffffffffffffffULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X32, TX_4X4
  { { 0xffffffffffffffffULL, 0xffffffffffffffffULL, 0xffffffffffffffffULL,
      0xffffffffffffffffULL } },  // block size 64X64, TX_4X4
  { { 0x0001000100010001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 4X16, TX_4X4
  { { 0x000000000000000fULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X4, TX_4X4
  { { 0x0003000300030003ULL, 0x0003000300030003ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X32, TX_4X4
  { { 0x0000000000ff00ffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X8, TX_4X4
  { { 0x000f000f000f000fULL, 0x000f000f000f000fULL, 0x000f000f000f000fULL,
      0x000f000f000f000fULL } },  // block size 16X64, TX_4X4
  { { 0xffffffffffffffffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X16, TX_4X4
  // TX_8X8
  { { 0x0000000000010001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X8, TX_8X8
  { { 0x0001000100010001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X16, TX_8X8
  { { 0x0000000000050005ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X8, TX_8X8
  { { 0x0005000500050005ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X16, TX_8X8
  { { 0x0005000500050005ULL, 0x0005000500050005ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X32, TX_8X8
  { { 0x0055005500550055ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X16, TX_8X8
  { { 0x0055005500550055ULL, 0x0055005500550055ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X32, TX_8X8
  { { 0x0055005500550055ULL, 0x0055005500550055ULL, 0x0055005500550055ULL,
      0x0055005500550055ULL } },  // block size 32X64, TX_8X8
  { { 0x5555555555555555ULL, 0x5555555555555555ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X32, TX_8X8
  { { 0x5555555555555555ULL, 0x5555555555555555ULL, 0x5555555555555555ULL,
      0x5555555555555555ULL } },  // block size 64X64, TX_8X8
  { { 0x0001000100010001ULL, 0x0001000100010001ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X32, TX_8X8
  { { 0x0000000000550055ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X8, TX_8X8
  { { 0x0005000500050005ULL, 0x0005000500050005ULL, 0x0005000500050005ULL,
      0x0005000500050005ULL } },  // block size 16X64, TX_8X8
  { { 0x5555555555555555ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X16, TX_8X8
  // TX_16X16
  { { 0x0001000100010001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X16, TX_16X16
  { { 0x0001000100010001ULL, 0x0001000100010001ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X32, TX_16X16
  { { 0x0011001100110011ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X16, TX_16X16
  { { 0x0011001100110011ULL, 0x0011001100110011ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X32, TX_16X16
  { { 0x0011001100110011ULL, 0x0011001100110011ULL, 0x0011001100110011ULL,
      0x0011001100110011ULL } },  // block size 32X64, TX_16X16
  { { 0x1111111111111111ULL, 0x1111111111111111ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X32, TX_16X16
  { { 0x1111111111111111ULL, 0x1111111111111111ULL, 0x1111111111111111ULL,
      0x1111111111111111ULL } },  // block size 64X64, TX_16X16
  { { 0x0001000100010001ULL, 0x0001000100010001ULL, 0x0001000100010001ULL,
      0x0001000100010001ULL } },  // block size 16X64, TX_16X16
  { { 0x1111111111111111ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X16, TX_16X16
  // TX_32X32
  { { 0x0001000100010001ULL, 0x0001000100010001ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X32, TX_32X32
  { { 0x0101010101010101ULL, 0x0101010101010101ULL, 0x0101010101010101ULL,
      0x0101010101010101ULL } },  // block size 32X64, TX_32X32
  { { 0x0101010101010101ULL, 0x0101010101010101ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X32, TX_32X32
  { { 0x0101010101010101ULL, 0x0101010101010101ULL, 0x0101010101010101ULL,
      0x0101010101010101ULL } },  // block size 64X64, TX_32X32
  // TX_64X64
  { { 0x0001000100010001ULL, 0x0001000100010001ULL, 0x0001000100010001ULL,
      0x0001000100010001ULL } },  // block size 64X64, TX_64X64
  // 2:1, 1:2 transform sizes.
  { { 0x0000000000010001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 4X8, TX_4X8
  { { 0x0001000100010001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 4X16, TX_4X8
  { { 0x0000000000000001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X4, TX_8X4
  { { 0x0000000000000005ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X4, TX_8X4
  { { 0x0001000100010001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X16, TX_8X16
  { { 0x0001000100010001ULL, 0x0001000100010001ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X32, TX_8X16
  { { 0x0000000000010001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X8, TX_16X8
  { { 0x0000000000110011ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X8, TX_16X8
  { { 0x0001000100010001ULL, 0x0001000100010001ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X32, TX_16X32
  { { 0x0001000100010001ULL, 0x0001000100010001ULL, 0x0001000100010001ULL,
      0x0001000100010001ULL } },  // block size 16X64, TX_16X32
  { { 0x0001000100010001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X16, TX_32X16
  { { 0x0101010101010101ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X16, TX_32X16
  { { 0x0001000100010001ULL, 0x0001000100010001ULL, 0x0001000100010001ULL,
      0x0001000100010001ULL } },  // block size 32X64, TX_32X64
  { { 0x0001000100010001ULL, 0x0001000100010001ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X32, TX_64X32
  // 4:1, 1:4 transform sizes.
  { { 0x0001000100010001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 4X16, TX_4X16
  { { 0x0000000000000001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X4, TX_16X4
  { { 0x0001000100010001ULL, 0x0001000100010001ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X32, TX_8X32
  { { 0x0000000000010001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X8, TX_32X8
  { { 0x0001000100010001ULL, 0x0001000100010001ULL, 0x0001000100010001ULL,
      0x0001000100010001ULL } },  // block size 16X64, TX_16X64
  { { 0x0001000100010001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X16, TX_64X16
};

static const FilterMask above_mask_univariant_reordered[67] = {
  // TX_4X4
  { { 0x0000000000000001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 4X4, TX_4X4
  { { 0x0000000000010001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 4X8, TX_4X4
  { { 0x0000000000000003ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X4, TX_4X4
  { { 0x0000000000030003ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X8, TX_4X4
  { { 0x0003000300030003ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X16, TX_4X4
  { { 0x00000000000f000fULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X8, TX_4X4
  { { 0x000f000f000f000fULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X16, TX_4X4
  { { 0x000f000f000f000fULL, 0x000f000f000f000fULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X32, TX_4X4
  { { 0x00ff00ff00ff00ffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X16, TX_4X4
  { { 0x00ff00ff00ff00ffULL, 0x00ff00ff00ff00ffULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X32, TX_4X4
  { { 0x00ff00ff00ff00ffULL, 0x00ff00ff00ff00ffULL, 0x00ff00ff00ff00ffULL,
      0x00ff00ff00ff00ffULL } },  // block size 32X64, TX_4X4
  { { 0xffffffffffffffffULL, 0xffffffffffffffffULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X32, TX_4X4
  { { 0xffffffffffffffffULL, 0xffffffffffffffffULL, 0xffffffffffffffffULL,
      0xffffffffffffffffULL } },  // block size 64X64, TX_4x4
  { { 0x0001000100010001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 4X16, TX_4X4
  { { 0x000000000000000fULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X4, TX_4X4
  { { 0x0003000300030003ULL, 0x0003000300030003ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X32, TX_4X4
  { { 0x0000000000ff00ffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X8, TX_4X4
  { { 0x000f000f000f000fULL, 0x000f000f000f000fULL, 0x000f000f000f000fULL,
      0x000f000f000f000fULL } },  // block size 16X64, TX_4X4
  { { 0xffffffffffffffffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X16, TX_4X4
  // TX_8X8
  { { 0x0000000000000003ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X8, TX_8X8
  { { 0x0000000300000003ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X16, TX_8X8
  { { 0x000000000000000fULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X8, TX_8X8
  { { 0x0000000f0000000fULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X16, TX_8X8
  { { 0x0000000f0000000fULL, 0x0000000f0000000fULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X32, TX_8X8
  { { 0x000000ff000000ffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X16, TX_8X8
  { { 0x000000ff000000ffULL, 0x000000ff000000ffULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X32, TX_8X8
  { { 0x000000ff000000ffULL, 0x000000ff000000ffULL, 0x000000ff000000ffULL,
      0x000000ff000000ffULL } },  // block size 32X64, TX_8X8
  { { 0x0000ffff0000ffffULL, 0x0000ffff0000ffffULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X32, TX_8X8
  { { 0x0000ffff0000ffffULL, 0x0000ffff0000ffffULL, 0x0000ffff0000ffffULL,
      0x0000ffff0000ffffULL } },  // block size 64X64, TX_8X8
  { { 0x0000000300000003ULL, 0x0000000300000003ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X32, TX_8X8
  { { 0x00000000000000ffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X8, TX_8X8
  { { 0x0000000f0000000fULL, 0x0000000f0000000fULL, 0x0000000f0000000fULL,
      0x0000000f0000000fULL } },  // block size 16X64, TX_8X8
  { { 0x0000ffff0000ffffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X16, TX_8X8
  // TX_16X16
  { { 0x000000000000000fULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X16, TX_16X16
  { { 0x000000000000000fULL, 0x000000000000000fULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X32, TX_16X16
  { { 0x00000000000000ffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X16, TX_16X16
  { { 0x00000000000000ffULL, 0x00000000000000ffULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X32, TX_16X16
  { { 0x00000000000000ffULL, 0x00000000000000ffULL, 0x00000000000000ffULL,
      0x00000000000000ffULL } },  // block size 32X64, TX_16X16
  { { 0x000000000000ffffULL, 0x000000000000ffffULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X32, TX_16X16
  { { 0x000000000000ffffULL, 0x000000000000ffffULL, 0x000000000000ffffULL,
      0x000000000000ffffULL } },  // block size 64X64, TX_16X16
  { { 0x000000000000000fULL, 0x000000000000000fULL, 0x000000000000000fULL,
      0x000000000000000fULL } },  // block size 16X64, TX_16X16
  { { 0x000000000000ffffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X16, TX_16X16
  // TX_32X32
  { { 0x00000000000000ffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X32, TX_32X32
  { { 0x00000000000000ffULL, 0x0000000000000000ULL, 0x00000000000000ffULL,
      0x0000000000000000ULL } },  // block size 32X64, TX_32X32
  { { 0x000000000000ffffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X32, TX_32X32
  { { 0x000000000000ffffULL, 0x0000000000000000ULL, 0x000000000000ffffULL,
      0x0000000000000000ULL } },  // block size 64X64, TX_32X32
  // TX_64X64
  { { 0x000000000000ffffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X64, TX_64X64
  // 2:1, 1:2 transform sizes.
  { { 0x0000000000000001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 4X8, TX_4X8
  { { 0x0000000100000001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 4X16, TX_4X8
  { { 0x0000000000000003ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X4, TX_8X4
  { { 0x000000000000000fULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X4, TX_8X4
  { { 0x0000000000000003ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X16, TX_8X16
  { { 0x0000000000000003ULL, 0x0000000000000003ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X32, TX_8X16
  { { 0x000000000000000fULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X8, TX_16X8
  { { 0x00000000000000ffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X8, TX_16X8
  { { 0x000000000000000fULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X32, TX_16X32
  { { 0x000000000000000fULL, 0x0000000000000000ULL, 0x000000000000000fULL,
      0x0000000000000000ULL } },  // block size 16X64, TX_16X32
  { { 0x00000000000000ffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X16, TX_32X16
  { { 0x000000000000ffffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X16, TX_32X16
  { { 0x00000000000000ffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X64, TX_32X64
  { { 0x000000000000ffffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X32, TX_64X32
  // 4:1, 1:4 transform sizes.
  { { 0x0000000000000001ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 4X16, TX_4X16
  { { 0x000000000000000fULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X4, TX_16X4
  { { 0x0000000000000003ULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 8X32, TX_8X32
  { { 0x00000000000000ffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 32X8, TX_32X8
  { { 0x000000000000000fULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 16X64, TX_16X64
  { { 0x000000000000ffffULL, 0x0000000000000000ULL, 0x0000000000000000ULL,
      0x0000000000000000ULL } },  // block size 64X16, TX_64X16
};

static LoopFilterMask *get_loop_filter_mask(const AV1_COMMON *const cm,
                                            int mi_row, int mi_col) {
  assert(cm->lf.lfm != NULL);
  const int row = mi_row >> MIN_MIB_SIZE_LOG2;  // 64x64
  const int col = mi_col >> MIN_MIB_SIZE_LOG2;
  return &cm->lf.lfm[row * cm->lf.lfm_stride + col];
}

typedef void (*LpfFunc)(uint8_t *s, int p, const uint8_t *blimit,
                        const uint8_t *limit, const uint8_t *thresh);

typedef void (*LpfDualFunc)(uint8_t *s, int p, const uint8_t *blimit0,
                            const uint8_t *limit0, const uint8_t *thresh0,
                            const uint8_t *blimit1, const uint8_t *limit1,
                            const uint8_t *thresh1);

typedef void (*HbdLpfFunc)(uint16_t *s, int p, const uint8_t *blimit,
                           const uint8_t *limit, const uint8_t *thresh, int bd);

typedef void (*HbdLpfDualFunc)(uint16_t *s, int p, const uint8_t *blimit0,
                               const uint8_t *limit0, const uint8_t *thresh0,
                               const uint8_t *blimit1, const uint8_t *limit1,
                               const uint8_t *thresh1, int bd);
// A 64x64 tx block requires 256 bits to represent each 4x4 tx block.
// Every 4 rows is represented by one uint64_t mask. Hence,
// there are 4 uint64_t bitmask[4] to represent the 64x64 block.
//
// Given a location by (mi_col, mi_row), This function returns the index
// 0, 1, 2, 3 to select which bitmask[] to use, and the shift value.
//
// For example, mi_row is the offset of pixels in mi size (4),
// (mi_row / 4) returns which uint64_t.
// After locating which uint64_t, mi_row % 4 is the
// row offset, and each row has 16 = 1 << stride_log2 4x4 units.
// Therefore, shift = (row << stride_log2) + mi_col;
int get_index_shift(int mi_col, int mi_row, int *index) {
  // *index = mi_row >> 2;
  // rows = mi_row % 4;
  // stride_log2 = 4;
  // shift = (rows << stride_log2) + mi_col;
  *index = mi_row >> 2;
  return ((mi_row & 3) << 4) | mi_col;
}

static void filter_selectively_vert_row2(
    int subsampling_factor, uint8_t *s, int pitch, int plane,
    uint64_t mask_16x16_0, uint64_t mask_8x8_0, uint64_t mask_4x4_0,
    uint64_t mask_16x16_1, uint64_t mask_8x8_1, uint64_t mask_4x4_1,
    const loop_filter_info_n *lfi_n, uint8_t *lfl, uint8_t *lfl2) {
  uint64_t mask;
  const int step = 1 << subsampling_factor;

  for (mask = mask_16x16_0 | mask_8x8_0 | mask_4x4_0 | mask_16x16_1 |
              mask_8x8_1 | mask_4x4_1;
       mask; mask >>= step) {
    const loop_filter_thresh *lfi0 = lfi_n->lfthr + *lfl;
    const loop_filter_thresh *lfi1 = lfi_n->lfthr + *lfl2;

    if (mask & 1) {
      if ((mask_16x16_0 | mask_16x16_1) & 1) {
        // chroma plane filters less pixels introduced in deblock_13tap
        // experiment
        LpfFunc lpf_vertical = plane ? aom_lpf_vertical_6 : aom_lpf_vertical_14;

        if ((mask_16x16_0 & mask_16x16_1) & 1) {
          if (plane) {
            aom_lpf_vertical_6_dual(s, pitch, lfi0->mblim, lfi0->lim,
                                    lfi0->hev_thr, lfi1->mblim, lfi1->lim,
                                    lfi1->hev_thr);
          } else {
            aom_lpf_vertical_14_dual(s, pitch, lfi0->mblim, lfi0->lim,
                                     lfi0->hev_thr, lfi1->mblim, lfi1->lim,
                                     lfi1->hev_thr);
          }
        } else if (mask_16x16_0 & 1) {
          lpf_vertical(s, pitch, lfi0->mblim, lfi0->lim, lfi0->hev_thr);
        } else {
          lpf_vertical(s + 4 * pitch, pitch, lfi1->mblim, lfi1->lim,
                       lfi1->hev_thr);
        }
      }

      if ((mask_8x8_0 | mask_8x8_1) & 1) {
        // chroma plane filters less pixels introduced in deblock_13tap
        // experiment
        LpfFunc lpf_vertical = plane ? aom_lpf_vertical_6 : aom_lpf_vertical_8;

        if ((mask_8x8_0 & mask_8x8_1) & 1) {
          if (plane) {
            aom_lpf_vertical_6_dual(s, pitch, lfi0->mblim, lfi0->lim,
                                    lfi0->hev_thr, lfi1->mblim, lfi1->lim,
                                    lfi1->hev_thr);
          } else {
            aom_lpf_vertical_8_dual(s, pitch, lfi0->mblim, lfi0->lim,
                                    lfi0->hev_thr, lfi1->mblim, lfi1->lim,
                                    lfi1->hev_thr);
          }
        } else if (mask_8x8_0 & 1) {
          lpf_vertical(s, pitch, lfi0->mblim, lfi0->lim, lfi0->hev_thr);
        } else {
          lpf_vertical(s + 4 * pitch, pitch, lfi1->mblim, lfi1->lim,
                       lfi1->hev_thr);
        }
      }

      if ((mask_4x4_0 | mask_4x4_1) & 1) {
        if ((mask_4x4_0 & mask_4x4_1) & 1) {
          aom_lpf_vertical_4_dual(s, pitch, lfi0->mblim, lfi0->lim,
                                  lfi0->hev_thr, lfi1->mblim, lfi1->lim,
                                  lfi1->hev_thr);
        } else if (mask_4x4_0 & 1) {
          aom_lpf_vertical_4(s, pitch, lfi0->mblim, lfi0->lim, lfi0->hev_thr);
        } else {
          aom_lpf_vertical_4(s + 4 * pitch, pitch, lfi1->mblim, lfi1->lim,
                             lfi1->hev_thr);
        }
      }
    }

    s += 4;
    lfl += step;
    lfl2 += step;
    mask_16x16_0 >>= step;
    mask_8x8_0 >>= step;
    mask_4x4_0 >>= step;
    mask_16x16_1 >>= step;
    mask_8x8_1 >>= step;
    mask_4x4_1 >>= step;
  }
}

#if CONFIG_AV1_HIGHBITDEPTH
static void highbd_filter_selectively_vert_row2(
    int subsampling_factor, uint16_t *s, int pitch, int plane,
    uint64_t mask_16x16_0, uint64_t mask_8x8_0, uint64_t mask_4x4_0,
    uint64_t mask_16x16_1, uint64_t mask_8x8_1, uint64_t mask_4x4_1,
    const loop_filter_info_n *lfi_n, uint8_t *lfl, uint8_t *lfl2, int bd) {
  uint64_t mask;
  const int step = 1 << subsampling_factor;

  for (mask = mask_16x16_0 | mask_8x8_0 | mask_4x4_0 | mask_16x16_1 |
              mask_8x8_1 | mask_4x4_1;
       mask; mask >>= step) {
    const loop_filter_thresh *lfi0 = lfi_n->lfthr + *lfl;
    const loop_filter_thresh *lfi1 = lfi_n->lfthr + *lfl2;

    if (mask & 1) {
      if ((mask_16x16_0 | mask_16x16_1) & 1) {
        // chroma plane filters less pixels introduced in deblock_13tap
        // experiment
        HbdLpfFunc highbd_lpf_vertical =
            plane ? aom_highbd_lpf_vertical_6 : aom_highbd_lpf_vertical_14;

        if ((mask_16x16_0 & mask_16x16_1) & 1) {
          if (plane) {
            aom_highbd_lpf_vertical_6_dual(s, pitch, lfi0->mblim, lfi0->lim,
                                           lfi0->hev_thr, lfi1->mblim,
                                           lfi1->lim, lfi1->hev_thr, bd);
          } else {
            aom_highbd_lpf_vertical_14_dual(s, pitch, lfi0->mblim, lfi0->lim,
                                            lfi0->hev_thr, lfi1->mblim,
                                            lfi1->lim, lfi1->hev_thr, bd);
          }
        } else if (mask_16x16_0 & 1) {
          highbd_lpf_vertical(s, pitch, lfi0->mblim, lfi0->lim, lfi0->hev_thr,
                              bd);
        } else {
          highbd_lpf_vertical(s + 4 * pitch, pitch, lfi1->mblim, lfi1->lim,
                              lfi1->hev_thr, bd);
        }
      }

      if ((mask_8x8_0 | mask_8x8_1) & 1) {
        HbdLpfFunc highbd_lpf_vertical =
            plane ? aom_highbd_lpf_vertical_6 : aom_highbd_lpf_vertical_8;

        if ((mask_8x8_0 & mask_8x8_1) & 1) {
          if (plane) {
            aom_highbd_lpf_vertical_6_dual(s, pitch, lfi0->mblim, lfi0->lim,
                                           lfi0->hev_thr, lfi1->mblim,
                                           lfi1->lim, lfi1->hev_thr, bd);
          } else {
            aom_highbd_lpf_vertical_8_dual(s, pitch, lfi0->mblim, lfi0->lim,
                                           lfi0->hev_thr, lfi1->mblim,
                                           lfi1->lim, lfi1->hev_thr, bd);
          }
        } else if (mask_8x8_0 & 1) {
          highbd_lpf_vertical(s, pitch, lfi0->mblim, lfi0->lim, lfi0->hev_thr,
                              bd);
        } else {
          highbd_lpf_vertical(s + 4 * pitch, pitch, lfi1->mblim, lfi1->lim,
                              lfi1->hev_thr, bd);
        }
      }

      if ((mask_4x4_0 | mask_4x4_1) & 1) {
        if ((mask_4x4_0 & mask_4x4_1) & 1) {
          aom_highbd_lpf_vertical_4_dual(s, pitch, lfi0->mblim, lfi0->lim,
                                         lfi0->hev_thr, lfi1->mblim, lfi1->lim,
                                         lfi1->hev_thr, bd);
        } else if (mask_4x4_0 & 1) {
          aom_highbd_lpf_vertical_4(s, pitch, lfi0->mblim, lfi0->lim,
                                    lfi0->hev_thr, bd);
        } else {
          aom_highbd_lpf_vertical_4(s + 4 * pitch, pitch, lfi1->mblim,
                                    lfi1->lim, lfi1->hev_thr, bd);
        }
      }
    }

    s += 4;
    lfl += step;
    lfl2 += step;
    mask_16x16_0 >>= step;
    mask_8x8_0 >>= step;
    mask_4x4_0 >>= step;
    mask_16x16_1 >>= step;
    mask_8x8_1 >>= step;
    mask_4x4_1 >>= step;
  }
}
#endif  // CONFIG_AV1_HIGHBITDEPTH

static void filter_selectively_horiz(uint8_t *s, int pitch, int plane,
                                     int subsampling, uint64_t mask_16x16,
                                     uint64_t mask_8x8, uint64_t mask_4x4,
                                     const loop_filter_info_n *lfi_n,
                                     const uint8_t *lfl) {
  uint64_t mask;
  int count;
  const int step = 1 << subsampling;
  const unsigned int two_block_mask = subsampling ? 5 : 3;
  int offset = 0;

  for (mask = mask_16x16 | mask_8x8 | mask_4x4; mask; mask >>= step * count) {
    const loop_filter_thresh *lfi = lfi_n->lfthr + *lfl;
    // Next block's thresholds, when it is within current 64x64 block.
    // If it is out of bound, its mask is zero, and it points to current edge's
    // filter parameters, instead of next edge's.
    int next_edge = step;
    if (offset + next_edge >= MI_SIZE_64X64) next_edge = 0;
    const loop_filter_thresh *lfin = lfi_n->lfthr + *(lfl + next_edge);

    count = 1;
    if (mask & 1) {
      if (mask_16x16 & 1) {
        // chroma plane filters less pixels introduced in deblock_13tap
        // experiment
        LpfFunc lpf_horizontal =
            plane ? aom_lpf_horizontal_6 : aom_lpf_horizontal_14;

        if ((mask_16x16 & two_block_mask) == two_block_mask) {
          if (plane) {
            aom_lpf_horizontal_6_dual(s, pitch, lfi->mblim, lfi->lim,
                                      lfi->hev_thr, lfin->mblim, lfin->lim,
                                      lfin->hev_thr);
          } else {
            aom_lpf_horizontal_14_dual(s, pitch, lfi->mblim, lfi->lim,
                                       lfi->hev_thr, lfin->mblim, lfin->lim,
                                       lfin->hev_thr);
          }
          count = 2;
        } else {
          lpf_horizontal(s, pitch, lfi->mblim, lfi->lim, lfi->hev_thr);
        }
      } else if (mask_8x8 & 1) {
        // chroma plane filters less pixels introduced in deblock_13tap
        // experiment
        LpfFunc lpf_horizontal =
            plane ? aom_lpf_horizontal_6 : aom_lpf_horizontal_8;

        if ((mask_8x8 & two_block_mask) == two_block_mask) {
          if (plane) {
            aom_lpf_horizontal_6_dual(s, pitch, lfi->mblim, lfi->lim,
                                      lfi->hev_thr, lfin->mblim, lfin->lim,
                                      lfin->hev_thr);
          } else {
            aom_lpf_horizontal_8_dual(s, pitch, lfi->mblim, lfi->lim,
                                      lfi->hev_thr, lfin->mblim, lfin->lim,
                                      lfin->hev_thr);
          }
          count = 2;
        } else {
          lpf_horizontal(s, pitch, lfi->mblim, lfi->lim, lfi->hev_thr);
        }
      } else if (mask_4x4 & 1) {
        if ((mask_4x4 & two_block_mask) == two_block_mask) {
          aom_lpf_horizontal_4_dual(s, pitch, lfi->mblim, lfi->lim,
                                    lfi->hev_thr, lfin->mblim, lfin->lim,
                                    lfin->hev_thr);
          count = 2;
        } else {
          aom_lpf_horizontal_4(s, pitch, lfi->mblim, lfi->lim, lfi->hev_thr);
        }
      }
    }

    s += 4 * count;
    lfl += step * count;
    mask_16x16 >>= step * count;
    mask_8x8 >>= step * count;
    mask_4x4 >>= step * count;
    offset += step * count;
  }
}

#if CONFIG_AV1_HIGHBITDEPTH
static void highbd_filter_selectively_horiz(
    uint16_t *s, int pitch, int plane, int subsampling, uint64_t mask_16x16,
    uint64_t mask_8x8, uint64_t mask_4x4, const loop_filter_info_n *lfi_n,
    uint8_t *lfl, int bd) {
  uint64_t mask;
  int count;
  const int step = 1 << subsampling;
  const unsigned int two_block_mask = subsampling ? 5 : 3;
  int offset = 0;

  for (mask = mask_16x16 | mask_8x8 | mask_4x4; mask; mask >>= step * count) {
    const loop_filter_thresh *lfi = lfi_n->lfthr + *lfl;
    // Next block's thresholds, when it is within current 64x64 block.
    // If it is out of bound, its mask is zero, and it points to current edge's
    // filter parameters, instead of next edge's.
    int next_edge = step;
    if (offset + next_edge >= MI_SIZE_64X64) next_edge = 0;
    const loop_filter_thresh *lfin = lfi_n->lfthr + *(lfl + next_edge);

    count = 1;
    if (mask & 1) {
      if (mask_16x16 & 1) {
        HbdLpfFunc highbd_lpf_horizontal =
            plane ? aom_highbd_lpf_horizontal_6 : aom_highbd_lpf_horizontal_14;

        if ((mask_16x16 & two_block_mask) == two_block_mask) {
          if (plane) {
            aom_highbd_lpf_horizontal_6_dual_c(s, pitch, lfi->mblim, lfi->lim,
                                               lfi->hev_thr, lfin->mblim,
                                               lfin->lim, lfin->hev_thr, bd);
          } else {
            aom_highbd_lpf_horizontal_14_dual(s, pitch, lfi->mblim, lfi->lim,
                                              lfi->hev_thr, lfin->mblim,
                                              lfin->lim, lfin->hev_thr, bd);
          }
          count = 2;
        } else {
          highbd_lpf_horizontal(s, pitch, lfi->mblim, lfi->lim, lfi->hev_thr,
                                bd);
        }
      } else if (mask_8x8 & 1) {
        HbdLpfFunc highbd_lpf_horizontal =
            plane ? aom_highbd_lpf_horizontal_6 : aom_highbd_lpf_horizontal_8;

        if ((mask_8x8 & two_block_mask) == two_block_mask) {
          if (plane) {
            aom_highbd_lpf_horizontal_6_dual_c(s, pitch, lfi->mblim, lfi->lim,
                                               lfi->hev_thr, lfin->mblim,
                                               lfin->lim, lfin->hev_thr, bd);
          } else {
            aom_highbd_lpf_horizontal_8_dual_c(s, pitch, lfi->mblim, lfi->lim,
                                               lfi->hev_thr, lfin->mblim,
                                               lfin->lim, lfin->hev_thr, bd);
          }
          count = 2;
        } else {
          highbd_lpf_horizontal(s, pitch, lfi->mblim, lfi->lim, lfi->hev_thr,
                                bd);
        }
      } else if (mask_4x4 & 1) {
        if ((mask_4x4 & two_block_mask) == two_block_mask) {
          aom_highbd_lpf_horizontal_4_dual_c(s, pitch, lfi->mblim, lfi->lim,
                                             lfi->hev_thr, lfin->mblim,
                                             lfin->lim, lfin->hev_thr, bd);
          count = 2;
        } else {
          aom_highbd_lpf_horizontal_4(s, pitch, lfi->mblim, lfi->lim,
                                      lfi->hev_thr, bd);
        }
      }
    }

    s += 4 * count;
    lfl += step * count;
    mask_16x16 >>= step * count;
    mask_8x8 >>= step * count;
    mask_4x4 >>= step * count;
    offset += step * count;
  }
}
#endif  // CONFIG_AV1_HIGHBITDEPTH

void av1_build_bitmask_vert_info(
    AV1_COMMON *const cm, const struct macroblockd_plane *const plane_ptr,
    int plane) {
  const int subsampling_x = plane_ptr->subsampling_x;
  const int subsampling_y = plane_ptr->subsampling_y;
  const int is_uv = plane > 0;
  TX_SIZE tx_size = TX_16X16, prev_tx_size = TX_16X16;
  uint8_t level, prev_level = 1;
  uint64_t skip, prev_skip = 0;
  uint64_t is_coding_block_border;

  for (int r = 0; (r << MI_SIZE_LOG2) < plane_ptr->dst.height; r++) {
    const int mi_row = r << subsampling_y;
    const int row = mi_row % MI_SIZE_64X64;
    const int row_uv = row | subsampling_y;
    int index = 0;
    const int shift = get_index_shift(0, row, &index);

    for (int c = 0; (c << MI_SIZE_LOG2) < plane_ptr->dst.width;
         c += (tx_size_wide_unit[TX_64X64] >> subsampling_x)) {
      const int mi_col = c << subsampling_x;
      LoopFilterMask *lfm = get_loop_filter_mask(cm, mi_row, mi_col);

      for (int col_in_unit = 0;
           col_in_unit < (tx_size_wide_unit[TX_64X64] >> subsampling_x);) {
        const int x = (c + col_in_unit) << MI_SIZE_LOG2;
        if (x >= plane_ptr->dst.width) break;
        const int col = col_in_unit << subsampling_x;
        const int col_uv = col | subsampling_x;
        const uint64_t mask = ((uint64_t)1 << (shift | col));
        skip = lfm->skip.bits[index] & mask;
        is_coding_block_border = lfm->is_vert_border.bits[index] & mask;
        switch (plane) {
          case 0: level = lfm->lfl_y_ver[row_uv][col_uv]; break;
          case 1: level = lfm->lfl_u_ver[row_uv][col_uv]; break;
          case 2: level = lfm->lfl_v_ver[row_uv][col_uv]; break;
          default: assert(plane >= 0 && plane <= 2); return;
        }
        for (TX_SIZE ts = TX_4X4; ts <= TX_64X64; ++ts) {
          if (is_uv && ts == TX_64X64) continue;
          if (lfm->tx_size_ver[is_uv][ts].bits[index] & mask) {
            tx_size = ts;
            break;
          }
        }
        if ((c + col_in_unit > 0) && (level || prev_level) &&
            (!prev_skip || !skip || is_coding_block_border)) {
          const TX_SIZE min_tx_size =
              AOMMIN(TX_16X16, AOMMIN(tx_size, prev_tx_size));
          const int shift_1 = get_index_shift(col_uv, row_uv, &index);
          const uint64_t mask_1 = ((uint64_t)1 << shift_1);
          switch (plane) {
            case 0: lfm->left_y[min_tx_size].bits[index] |= mask_1; break;
            case 1: lfm->left_u[min_tx_size].bits[index] |= mask_1; break;
            case 2: lfm->left_v[min_tx_size].bits[index] |= mask_1; break;
            default: assert(plane >= 0 && plane <= 2); return;
          }
          if (level == 0 && prev_level != 0) {
            switch (plane) {
              case 0: lfm->lfl_y_ver[row_uv][col_uv] = prev_level; break;
              case 1: lfm->lfl_u_ver[row_uv][col_uv] = prev_level; break;
              case 2: lfm->lfl_v_ver[row_uv][col_uv] = prev_level; break;
              default: assert(plane >= 0 && plane <= 2); return;
            }
          }
        }

        // update prev info
        prev_level = level;
        prev_skip = skip;
        prev_tx_size = tx_size;
        // advance
        col_in_unit += tx_size_wide_unit[tx_size];
      }
    }
  }
}

void av1_build_bitmask_horz_info(
    AV1_COMMON *const cm, const struct macroblockd_plane *const plane_ptr,
    int plane) {
  const int subsampling_x = plane_ptr->subsampling_x;
  const int subsampling_y = plane_ptr->subsampling_y;
  const int is_uv = plane > 0;
  TX_SIZE tx_size = TX_16X16, prev_tx_size = TX_16X16;
  uint8_t level, prev_level = 1;
  uint64_t skip, prev_skip = 0;
  uint64_t is_coding_block_border;

  for (int c = 0; (c << MI_SIZE_LOG2) < plane_ptr->dst.width; c++) {
    const int mi_col = c << subsampling_x;
    const int col = mi_col % MI_SIZE_64X64;
    const int col_uv = col | subsampling_x;

    for (int r = 0; (r << MI_SIZE_LOG2) < plane_ptr->dst.height;
         r += (tx_size_high_unit[TX_64X64] >> subsampling_y)) {
      const int mi_row = r << subsampling_y;
      LoopFilterMask *lfm = get_loop_filter_mask(cm, mi_row, mi_col);

      for (int r_in_unit = 0;
           r_in_unit < (tx_size_high_unit[TX_64X64] >> subsampling_y);) {
        const int y = (r + r_in_unit) << MI_SIZE_LOG2;
        if (y >= plane_ptr->dst.height) break;
        const int row = r_in_unit << subsampling_y;
        const int row_uv = row | subsampling_y;
        int index = 0;
        const int shift = get_index_shift(col, row, &index);
        const uint64_t mask = ((uint64_t)1 << shift);
        skip = lfm->skip.bits[index] & mask;
        is_coding_block_border = lfm->is_horz_border.bits[index] & mask;
        switch (plane) {
          case 0: level = lfm->lfl_y_hor[row_uv][col_uv]; break;
          case 1: level = lfm->lfl_u_hor[row_uv][col_uv]; break;
          case 2: level = lfm->lfl_v_hor[row_uv][col_uv]; break;
          default: assert(plane >= 0 && plane <= 2); return;
        }
        for (TX_SIZE ts = TX_4X4; ts <= TX_64X64; ++ts) {
          if (is_uv && ts == TX_64X64) continue;
          if (lfm->tx_size_hor[is_uv][ts].bits[index] & mask) {
            tx_size = ts;
            break;
          }
        }
        if ((r + r_in_unit > 0) && (level || prev_level) &&
            (!prev_skip || !skip || is_coding_block_border)) {
          const TX_SIZE min_tx_size =
              AOMMIN(TX_16X16, AOMMIN(tx_size, prev_tx_size));
          const int shift_1 = get_index_shift(col_uv, row_uv, &index);
          const uint64_t mask_1 = ((uint64_t)1 << shift_1);

          switch (plane) {
            case 0: lfm->above_y[min_tx_size].bits[index] |= mask_1; break;
            case 1: lfm->above_u[min_tx_size].bits[index] |= mask_1; break;
            case 2: lfm->above_v[min_tx_size].bits[index] |= mask_1; break;
            default: assert(plane >= 0 && plane <= 2); return;
          }
          if (level == 0 && prev_level != 0) {
            switch (plane) {
              case 0: lfm->lfl_y_hor[row_uv][col_uv] = prev_level; break;
              case 1: lfm->lfl_u_hor[row_uv][col_uv] = prev_level; break;
              case 2: lfm->lfl_v_hor[row_uv][col_uv] = prev_level; break;
              default: assert(plane >= 0 && plane <= 2); return;
            }
          }
        }

        // update prev info
        prev_level = level;
        prev_skip = skip;
        prev_tx_size = tx_size;
        // advance
        r_in_unit += tx_size_high_unit[tx_size];
      }
    }
  }
}

void av1_filter_block_plane_bitmask_vert(
    AV1_COMMON *const cm, struct macroblockd_plane *const plane_ptr, int pl,
    int mi_row, int mi_col) {
  struct buf_2d *const dst = &plane_ptr->dst;
  uint8_t *const buf0 = dst->buf;
  const int ssx = plane_ptr->subsampling_x;
  const int ssy = plane_ptr->subsampling_y;
  const int mask_cutoff = 0xffff;
  const int row_step = 1 << ssy;
  const int two_row_step = 2 << ssy;
  const int row_stride = dst->stride << MI_SIZE_LOG2;
  const int two_row_stride = row_stride << 1;
  uint64_t mask_16x16 = 0;
  uint64_t mask_8x8 = 0;
  uint64_t mask_4x4 = 0;
  uint8_t *lfl;
  uint8_t *lfl2;
  LoopFilterMask *lfm = get_loop_filter_mask(cm, mi_row, mi_col);
  assert(lfm);

  // 1. vertical filtering. filter two rows at a time
  for (int r = 0;
       ((mi_row + r) << MI_SIZE_LOG2) < cm->height && r < MI_SIZE_64X64;
       r += two_row_step) {
    const int row = r | ssy;
    const int row_next = row + row_step;
    const int col = ssx;
    int index = 0;
    const int shift = get_index_shift(col, row, &index);
    int index_next = 0;
    const int shift_next = get_index_shift(col, row_next, &index_next);
    const int has_next_row = row_next < cm->mi_params.mi_rows;
    switch (pl) {
      case 0:
        mask_16x16 = lfm->left_y[TX_16X16].bits[index];
        mask_8x8 = lfm->left_y[TX_8X8].bits[index];
        mask_4x4 = lfm->left_y[TX_4X4].bits[index];
        lfl = &lfm->lfl_y_ver[row][col];
        lfl2 = &lfm->lfl_y_ver[row_next][col];
        break;
      case 1:
        mask_16x16 = lfm->left_u[TX_16X16].bits[index];
        mask_8x8 = lfm->left_u[TX_8X8].bits[index];
        mask_4x4 = lfm->left_u[TX_4X4].bits[index];
        lfl = &lfm->lfl_u_ver[row][col];
        lfl2 = &lfm->lfl_u_ver[row_next][col];
        break;
      case 2:
        mask_16x16 = lfm->left_v[TX_16X16].bits[index];
        mask_8x8 = lfm->left_v[TX_8X8].bits[index];
        mask_4x4 = lfm->left_v[TX_4X4].bits[index];
        lfl = &lfm->lfl_v_ver[row][col];
        lfl2 = &lfm->lfl_v_ver[row_next][col];
        break;
      default: assert(pl >= 0 && pl <= 2); return;
    }
    uint64_t mask_16x16_0 = (mask_16x16 >> shift) & mask_cutoff;
    uint64_t mask_8x8_0 = (mask_8x8 >> shift) & mask_cutoff;
    uint64_t mask_4x4_0 = (mask_4x4 >> shift) & mask_cutoff;
    uint64_t mask_16x16_1 = (mask_16x16 >> shift_next) & mask_cutoff;
    uint64_t mask_8x8_1 = (mask_8x8 >> shift_next) & mask_cutoff;
    uint64_t mask_4x4_1 = (mask_4x4 >> shift_next) & mask_cutoff;
    if (!has_next_row) {
      mask_16x16_1 = 0;
      mask_8x8_1 = 0;
      mask_4x4_1 = 0;
    }

#if CONFIG_AV1_HIGHBITDEPTH
    if (cm->seq_params.use_highbitdepth)
      highbd_filter_selectively_vert_row2(
          ssx, CONVERT_TO_SHORTPTR(dst->buf), dst->stride, pl, mask_16x16_0,
          mask_8x8_0, mask_4x4_0, mask_16x16_1, mask_8x8_1, mask_4x4_1,
          &cm->lf_info, lfl, lfl2, (int)cm->seq_params.bit_depth);
    else
      filter_selectively_vert_row2(
          ssx, dst->buf, dst->stride, pl, mask_16x16_0, mask_8x8_0, mask_4x4_0,
          mask_16x16_1, mask_8x8_1, mask_4x4_1, &cm->lf_info, lfl, lfl2);
#else
    filter_selectively_vert_row2(
        ssx, dst->buf, dst->stride, pl, mask_16x16_0, mask_8x8_0, mask_4x4_0,
        mask_16x16_1, mask_8x8_1, mask_4x4_1, &cm->lf_info, lfl, lfl2);
#endif
    dst->buf += two_row_stride;
  }
  // reset buf pointer for horizontal filtering
  dst->buf = buf0;
}

void av1_filter_block_plane_bitmask_horz(
    AV1_COMMON *const cm, struct macroblockd_plane *const plane_ptr, int pl,
    int mi_row, int mi_col) {
  struct buf_2d *const dst = &plane_ptr->dst;
  uint8_t *const buf0 = dst->buf;
  const int ssx = plane_ptr->subsampling_x;
  const int ssy = plane_ptr->subsampling_y;
  const int mask_cutoff = 0xffff;
  const int row_step = 1 << ssy;
  const int row_stride = dst->stride << MI_SIZE_LOG2;
  uint64_t mask_16x16 = 0;
  uint64_t mask_8x8 = 0;
  uint64_t mask_4x4 = 0;
  uint8_t *lfl;
  LoopFilterMask *lfm = get_loop_filter_mask(cm, mi_row, mi_col);
  assert(lfm);
  for (int r = 0;
       ((mi_row + r) << MI_SIZE_LOG2) < cm->height && r < MI_SIZE_64X64;
       r += row_step) {
    if (mi_row + r == 0) {
      dst->buf += row_stride;
      continue;
    }
    const int row = r | ssy;
    const int col = ssx;
    int index = 0;
    const int shift = get_index_shift(col, row, &index);
    switch (pl) {
      case 0:
        mask_16x16 = lfm->above_y[TX_16X16].bits[index];
        mask_8x8 = lfm->above_y[TX_8X8].bits[index];
        mask_4x4 = lfm->above_y[TX_4X4].bits[index];
        lfl = &lfm->lfl_y_hor[row][col];
        break;
      case 1:
        mask_16x16 = lfm->above_u[TX_16X16].bits[index];
        mask_8x8 = lfm->above_u[TX_8X8].bits[index];
        mask_4x4 = lfm->above_u[TX_4X4].bits[index];
        lfl = &lfm->lfl_u_hor[row][col];
        break;
      case 2:
        mask_16x16 = lfm->above_v[TX_16X16].bits[index];
        mask_8x8 = lfm->above_v[TX_8X8].bits[index];
        mask_4x4 = lfm->above_v[TX_4X4].bits[index];
        lfl = &lfm->lfl_v_hor[row][col];
        break;
      default: assert(pl >= 0 && pl <= 2); return;
    }
    mask_16x16 = (mask_16x16 >> shift) & mask_cutoff;
    mask_8x8 = (mask_8x8 >> shift) & mask_cutoff;
    mask_4x4 = (mask_4x4 >> shift) & mask_cutoff;

#if CONFIG_AV1_HIGHBITDEPTH
    if (cm->seq_params.use_highbitdepth)
      highbd_filter_selectively_horiz(
          CONVERT_TO_SHORTPTR(dst->buf), dst->stride, pl, ssx, mask_16x16,
          mask_8x8, mask_4x4, &cm->lf_info, lfl, (int)cm->seq_params.bit_depth);
    else
      filter_selectively_horiz(dst->buf, dst->stride, pl, ssx, mask_16x16,
                               mask_8x8, mask_4x4, &cm->lf_info, lfl);
#else
    filter_selectively_horiz(dst->buf, dst->stride, pl, ssx, mask_16x16,
                             mask_8x8, mask_4x4, &cm->lf_info, lfl);
#endif
    dst->buf += row_stride;
  }
  // reset buf pointer for next block
  dst->buf = buf0;
}

void av1_filter_block_plane_ver(AV1_COMMON *const cm,
                                struct macroblockd_plane *const plane_ptr,
                                int pl, int mi_row, int mi_col) {
  struct buf_2d *const dst = &plane_ptr->dst;
  int r, c;
  const int ssx = plane_ptr->subsampling_x;
  const int ssy = plane_ptr->subsampling_y;
  const int mask_cutoff = 0xffff;
  const int single_step = 1 << ssy;
  const int r_step = 2 << ssy;
  uint64_t mask_16x16 = 0;
  uint64_t mask_8x8 = 0;
  uint64_t mask_4x4 = 0;
  uint8_t *lfl;
  uint8_t *lfl2;

  // filter two rows at a time
  for (r = 0; r < cm->seq_params.mib_size &&
              ((mi_row + r) << MI_SIZE_LOG2 < cm->height);
       r += r_step) {
    for (c = 0; c < cm->seq_params.mib_size &&
                ((mi_col + c) << MI_SIZE_LOG2 < cm->width);
         c += MI_SIZE_64X64) {
      dst->buf += ((c << MI_SIZE_LOG2) >> ssx);
      LoopFilterMask *lfm = get_loop_filter_mask(cm, mi_row + r, mi_col + c);
      assert(lfm);
      const int row = ((mi_row + r) | ssy) % MI_SIZE_64X64;
      const int col = ((mi_col + c) | ssx) % MI_SIZE_64X64;
      int index = 0;
      const int shift = get_index_shift(col, row, &index);
      // current and next row should belong to the same mask_idx and index
      // next row's shift
      const int row_next = row + single_step;
      int index_next = 0;
      const int shift_next = get_index_shift(col, row_next, &index_next);
      switch (pl) {
        case 0:
          mask_16x16 = lfm->left_y[TX_16X16].bits[index];
          mask_8x8 = lfm->left_y[TX_8X8].bits[index];
          mask_4x4 = lfm->left_y[TX_4X4].bits[index];
          lfl = &lfm->lfl_y_ver[row][col];
          lfl2 = &lfm->lfl_y_ver[row_next][col];
          break;
        case 1:
          mask_16x16 = lfm->left_u[TX_16X16].bits[index];
          mask_8x8 = lfm->left_u[TX_8X8].bits[index];
          mask_4x4 = lfm->left_u[TX_4X4].bits[index];
          lfl = &lfm->lfl_u_ver[row][col];
          lfl2 = &lfm->lfl_u_ver[row_next][col];
          break;
        case 2:
          mask_16x16 = lfm->left_v[TX_16X16].bits[index];
          mask_8x8 = lfm->left_v[TX_8X8].bits[index];
          mask_4x4 = lfm->left_v[TX_4X4].bits[index];
          lfl = &lfm->lfl_v_ver[row][col];
          lfl2 = &lfm->lfl_v_ver[row_next][col];
          break;
        default: assert(pl >= 0 && pl <= 2); return;
      }
      uint64_t mask_16x16_0 = (mask_16x16 >> shift) & mask_cutoff;
      uint64_t mask_8x8_0 = (mask_8x8 >> shift) & mask_cutoff;
      uint64_t mask_4x4_0 = (mask_4x4 >> shift) & mask_cutoff;
      uint64_t mask_16x16_1 = (mask_16x16 >> shift_next) & mask_cutoff;
      uint64_t mask_8x8_1 = (mask_8x8 >> shift_next) & mask_cutoff;
      uint64_t mask_4x4_1 = (mask_4x4 >> shift_next) & mask_cutoff;

#if CONFIG_AV1_HIGHBITDEPTH
      if (cm->seq_params.use_highbitdepth)
        highbd_filter_selectively_vert_row2(
            ssx, CONVERT_TO_SHORTPTR(dst->buf), dst->stride, pl, mask_16x16_0,
            mask_8x8_0, mask_4x4_0, mask_16x16_1, mask_8x8_1, mask_4x4_1,
            &cm->lf_info, lfl, lfl2, (int)cm->seq_params.bit_depth);
      else
        filter_selectively_vert_row2(ssx, dst->buf, dst->stride, pl,
                                     mask_16x16_0, mask_8x8_0, mask_4x4_0,
                                     mask_16x16_1, mask_8x8_1, mask_4x4_1,
                                     &cm->lf_info, lfl, lfl2);
#else
      filter_selectively_vert_row2(
          ssx, dst->buf, dst->stride, pl, mask_16x16_0, mask_8x8_0, mask_4x4_0,
          mask_16x16_1, mask_8x8_1, mask_4x4_1, &cm->lf_info, lfl, lfl2);
#endif
      dst->buf -= ((c << MI_SIZE_LOG2) >> ssx);
    }
    dst->buf += 2 * MI_SIZE * dst->stride;
  }
}

void av1_filter_block_plane_hor(AV1_COMMON *const cm,
                                struct macroblockd_plane *const plane_ptr,
                                int pl, int mi_row, int mi_col) {
  struct buf_2d *const dst = &plane_ptr->dst;
  int r, c;
  const int ssx = plane_ptr->subsampling_x;
  const int ssy = plane_ptr->subsampling_y;
  const int mask_cutoff = 0xffff;
  const int r_step = 1 << ssy;
  uint64_t mask_16x16 = 0;
  uint64_t mask_8x8 = 0;
  uint64_t mask_4x4 = 0;
  uint8_t *lfl;

  for (r = 0; r < cm->seq_params.mib_size &&
              ((mi_row + r) << MI_SIZE_LOG2 < cm->height);
       r += r_step) {
    for (c = 0; c < cm->seq_params.mib_size &&
                ((mi_col + c) << MI_SIZE_LOG2 < cm->width);
         c += MI_SIZE_64X64) {
      if (mi_row + r == 0) continue;

      dst->buf += ((c << MI_SIZE_LOG2) >> ssx);
      LoopFilterMask *lfm = get_loop_filter_mask(cm, mi_row + r, mi_col + c);
      assert(lfm);
      const int row = ((mi_row + r) | ssy) % MI_SIZE_64X64;
      const int col = ((mi_col + c) | ssx) % MI_SIZE_64X64;
      int index = 0;
      const int shift = get_index_shift(col, row, &index);
      switch (pl) {
        case 0:
          mask_16x16 = lfm->above_y[TX_16X16].bits[index];
          mask_8x8 = lfm->above_y[TX_8X8].bits[index];
          mask_4x4 = lfm->above_y[TX_4X4].bits[index];
          lfl = &lfm->lfl_y_hor[row][col];
          break;
        case 1:
          mask_16x16 = lfm->above_u[TX_16X16].bits[index];
          mask_8x8 = lfm->above_u[TX_8X8].bits[index];
          mask_4x4 = lfm->above_u[TX_4X4].bits[index];
          lfl = &lfm->lfl_u_hor[row][col];
          break;
        case 2:
          mask_16x16 = lfm->above_v[TX_16X16].bits[index];
          mask_8x8 = lfm->above_v[TX_8X8].bits[index];
          mask_4x4 = lfm->above_v[TX_4X4].bits[index];
          lfl = &lfm->lfl_v_hor[row][col];
          break;
        default: assert(pl >= 0 && pl <= 2); return;
      }
      mask_16x16 = (mask_16x16 >> shift) & mask_cutoff;
      mask_8x8 = (mask_8x8 >> shift) & mask_cutoff;
      mask_4x4 = (mask_4x4 >> shift) & mask_cutoff;

#if CONFIG_AV1_HIGHBITDEPTH
      if (cm->seq_params.use_highbitdepth)
        highbd_filter_selectively_horiz(CONVERT_TO_SHORTPTR(dst->buf),
                                        dst->stride, pl, ssx, mask_16x16,
                                        mask_8x8, mask_4x4, &cm->lf_info, lfl,
                                        (int)cm->seq_params.bit_depth);
      else
        filter_selectively_horiz(dst->buf, dst->stride, pl, ssx, mask_16x16,
                                 mask_8x8, mask_4x4, &cm->lf_info, lfl);
#else
      filter_selectively_horiz(dst->buf, dst->stride, pl, ssx, mask_16x16,
                               mask_8x8, mask_4x4, &cm->lf_info, lfl);
#endif
      dst->buf -= ((c << MI_SIZE_LOG2) >> ssx);
    }
    dst->buf += MI_SIZE * dst->stride;
  }
}

void av1_store_bitmask_vartx(AV1_COMMON *cm, int mi_row, int mi_col,
                             BLOCK_SIZE bsize, TX_SIZE tx_size,
                             MB_MODE_INFO *mbmi) {
  LoopFilterMask *lfm = get_loop_filter_mask(cm, mi_row, mi_col);
  const TX_SIZE tx_size_y_vert = txsize_vert_map[tx_size];
  const TX_SIZE tx_size_y_horz = txsize_horz_map[tx_size];
  const TX_SIZE tx_size_uv_vert = txsize_vert_map[av1_get_max_uv_txsize(
      mbmi->sb_type, cm->seq_params.subsampling_x,
      cm->seq_params.subsampling_y)];
  const TX_SIZE tx_size_uv_horz = txsize_horz_map[av1_get_max_uv_txsize(
      mbmi->sb_type, cm->seq_params.subsampling_x,
      cm->seq_params.subsampling_y)];
  const int is_square_transform_size = tx_size <= TX_64X64;
  int mask_id = 0;
  int offset = 0;
  const int half_ratio_tx_size_max32 =
      (tx_size > TX_64X64) & (tx_size <= TX_32X16);
  if (is_square_transform_size) {
    switch (tx_size) {
      case TX_4X4: mask_id = mask_id_table_tx_4x4[bsize]; break;
      case TX_8X8:
        mask_id = mask_id_table_tx_8x8[bsize];
        offset = 19;
        break;
      case TX_16X16:
        mask_id = mask_id_table_tx_16x16[bsize];
        offset = 33;
        break;
      case TX_32X32:
        mask_id = mask_id_table_tx_32x32[bsize];
        offset = 42;
        break;
      case TX_64X64: mask_id = 46; break;
      default: assert(!is_square_transform_size); return;
    }
    mask_id += offset;
  } else if (half_ratio_tx_size_max32) {
    int tx_size_equal_block_size = bsize == txsize_to_bsize[tx_size];
    mask_id = 47 + 2 * (tx_size - TX_4X8) + (tx_size_equal_block_size ? 0 : 1);
  } else if (tx_size == TX_32X64) {
    mask_id = 59;
  } else if (tx_size == TX_64X32) {
    mask_id = 60;
  } else {  // quarter ratio tx size
    mask_id = 61 + (tx_size - TX_4X16);
  }
  int index = 0;
  const int row = mi_row % MI_SIZE_64X64;
  const int col = mi_col % MI_SIZE_64X64;
  const int shift = get_index_shift(col, row, &index);
  const int vert_shift = tx_size_y_vert <= TX_8X8 ? shift : col;
  for (int i = 0; i + index < 4; ++i) {
    // y vertical.
    lfm->tx_size_ver[0][tx_size_y_horz].bits[i + index] |=
        (left_mask_univariant_reordered[mask_id].bits[i] << vert_shift);
    // y horizontal.
    lfm->tx_size_hor[0][tx_size_y_vert].bits[i + index] |=
        (above_mask_univariant_reordered[mask_id].bits[i] << shift);
    // u/v vertical.
    lfm->tx_size_ver[1][tx_size_uv_horz].bits[i + index] |=
        (left_mask_univariant_reordered[mask_id].bits[i] << vert_shift);
    // u/v horizontal.
    lfm->tx_size_hor[1][tx_size_uv_vert].bits[i + index] |=
        (above_mask_univariant_reordered[mask_id].bits[i] << shift);
  }
}

void av1_store_bitmask_univariant_tx(AV1_COMMON *cm, int mi_row, int mi_col,
                                     BLOCK_SIZE bsize, MB_MODE_INFO *mbmi) {
  // Use a lookup table that provides one bitmask for a given block size and
  // a univariant transform size.
  int index;
  int shift;
  int row;
  int col;
  LoopFilterMask *lfm = get_loop_filter_mask(cm, mi_row, mi_col);
  const TX_SIZE tx_size_y_vert = txsize_vert_map[mbmi->tx_size];
  const TX_SIZE tx_size_y_horz = txsize_horz_map[mbmi->tx_size];
  const TX_SIZE tx_size_uv_vert = txsize_vert_map[av1_get_max_uv_txsize(
      mbmi->sb_type, cm->seq_params.subsampling_x,
      cm->seq_params.subsampling_y)];
  const TX_SIZE tx_size_uv_horz = txsize_horz_map[av1_get_max_uv_txsize(
      mbmi->sb_type, cm->seq_params.subsampling_x,
      cm->seq_params.subsampling_y)];
  const int is_square_transform_size = mbmi->tx_size <= TX_64X64;
  int mask_id = 0;
  int offset = 0;
  const int half_ratio_tx_size_max32 =
      (mbmi->tx_size > TX_64X64) & (mbmi->tx_size <= TX_32X16);
  if (is_square_transform_size) {
    switch (mbmi->tx_size) {
      case TX_4X4: mask_id = mask_id_table_tx_4x4[bsize]; break;
      case TX_8X8:
        mask_id = mask_id_table_tx_8x8[bsize];
        offset = 19;
        break;
      case TX_16X16:
        mask_id = mask_id_table_tx_16x16[bsize];
        offset = 33;
        break;
      case TX_32X32:
        mask_id = mask_id_table_tx_32x32[bsize];
        offset = 42;
        break;
      case TX_64X64: mask_id = 46; break;
      default: assert(!is_square_transform_size); return;
    }
    mask_id += offset;
  } else if (half_ratio_tx_size_max32) {
    int tx_size_equal_block_size = bsize == txsize_to_bsize[mbmi->tx_size];
    mask_id =
        47 + 2 * (mbmi->tx_size - TX_4X8) + (tx_size_equal_block_size ? 0 : 1);
  } else if (mbmi->tx_size == TX_32X64) {
    mask_id = 59;
  } else if (mbmi->tx_size == TX_64X32) {
    mask_id = 60;
  } else {  // quarter ratio tx size
    mask_id = 61 + (mbmi->tx_size - TX_4X16);
  }
  row = mi_row % MI_SIZE_64X64;
  col = mi_col % MI_SIZE_64X64;
  shift = get_index_shift(col, row, &index);
  const int vert_shift = tx_size_y_vert <= TX_8X8 ? shift : col;
  for (int i = 0; i + index < 4; ++i) {
    // y vertical.
    lfm->tx_size_ver[0][tx_size_y_horz].bits[i + index] |=
        (left_mask_univariant_reordered[mask_id].bits[i] << vert_shift);
    // y horizontal.
    lfm->tx_size_hor[0][tx_size_y_vert].bits[i + index] |=
        (above_mask_univariant_reordered[mask_id].bits[i] << shift);
    // u/v vertical.
    lfm->tx_size_ver[1][tx_size_uv_horz].bits[i + index] |=
        (left_mask_univariant_reordered[mask_id].bits[i] << vert_shift);
    // u/v horizontal.
    lfm->tx_size_hor[1][tx_size_uv_vert].bits[i + index] |=
        (above_mask_univariant_reordered[mask_id].bits[i] << shift);
  }
}

void av1_store_bitmask_other_info(AV1_COMMON *cm, int mi_row, int mi_col,
                                  BLOCK_SIZE bsize, MB_MODE_INFO *mbmi,
                                  int is_horz_coding_block_border,
                                  int is_vert_coding_block_border) {
  int index;
  int shift;
  int row;
  LoopFilterMask *lfm = get_loop_filter_mask(cm, mi_row, mi_col);
  const int row_start = mi_row % MI_SIZE_64X64;
  const int col_start = mi_col % MI_SIZE_64X64;
  shift = get_index_shift(col_start, row_start, &index);
  if (is_horz_coding_block_border) {
    const int block_shift = shift + mi_size_wide[bsize];
    assert(block_shift <= 64);
    const uint64_t right_edge_shift =
        (block_shift == 64) ? 0xffffffffffffffff : ((uint64_t)1 << block_shift);
    const uint64_t left_edge_shift = (block_shift == 64)
                                         ? (((uint64_t)1 << shift) - 1)
                                         : ((uint64_t)1 << shift);
    assert(right_edge_shift > left_edge_shift);
    const uint64_t top_edge_mask = right_edge_shift - left_edge_shift;
    lfm->is_horz_border.bits[index] |= top_edge_mask;
  }
  if (is_vert_coding_block_border) {
    const int is_vert_border = mask_id_table_vert_border[bsize];
    const int vert_shift = block_size_high[bsize] <= 8 ? shift : col_start;
    for (int i = 0; i + index < 4; ++i) {
      lfm->is_vert_border.bits[i + index] |=
          (left_mask_univariant_reordered[is_vert_border].bits[i]
           << vert_shift);
    }
  }
  const int is_skip = mbmi->skip && is_inter_block(mbmi);
  if (is_skip) {
    const int is_skip_mask = mask_id_table_tx_4x4[bsize];
    for (int i = 0; i + index < 4; ++i) {
      lfm->skip.bits[i + index] |=
          (above_mask_univariant_reordered[is_skip_mask].bits[i] << shift);
    }
  }
  const uint8_t level_vert_y =
      av1_get_filter_level(cm, &cm->lf_info, 0, 0, mbmi);
  const uint8_t level_horz_y =
      av1_get_filter_level(cm, &cm->lf_info, 1, 0, mbmi);
  const uint8_t level_u = av1_get_filter_level(cm, &cm->lf_info, 0, 1, mbmi);
  const uint8_t level_v = av1_get_filter_level(cm, &cm->lf_info, 0, 2, mbmi);
  for (int r = mi_row; r < mi_row + mi_size_high[bsize]; r++) {
    index = 0;
    row = r % MI_SIZE_64X64;
    memset(&lfm->lfl_y_ver[row][col_start], level_vert_y,
           sizeof(uint8_t) * mi_size_wide[bsize]);
    memset(&lfm->lfl_y_hor[row][col_start], level_horz_y,
           sizeof(uint8_t) * mi_size_wide[bsize]);
    memset(&lfm->lfl_u_ver[row][col_start], level_u,
           sizeof(uint8_t) * mi_size_wide[bsize]);
    memset(&lfm->lfl_u_hor[row][col_start], level_u,
           sizeof(uint8_t) * mi_size_wide[bsize]);
    memset(&lfm->lfl_v_ver[row][col_start], level_v,
           sizeof(uint8_t) * mi_size_wide[bsize]);
    memset(&lfm->lfl_v_hor[row][col_start], level_v,
           sizeof(uint8_t) * mi_size_wide[bsize]);
  }
}
#endif  // CONFIG_LPF_MASK
