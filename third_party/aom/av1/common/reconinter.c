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

#include <assert.h>

#include "./aom_scale_rtcd.h"
#include "./aom_dsp_rtcd.h"
#include "./aom_config.h"

#include "aom/aom_integer.h"
#include "aom_dsp/blend.h"

#include "av1/common/blockd.h"
#include "av1/common/reconinter.h"
#include "av1/common/reconintra.h"
#if CONFIG_MOTION_VAR
#include "av1/common/onyxc_int.h"
#endif  // CONFIG_MOTION_VAR

#if CONFIG_EXT_INTER

#define NSMOOTHERS 1

// [smoother][negative][direction]
DECLARE_ALIGNED(16, static uint8_t,
                wedge_mask_obl[NSMOOTHERS][2][WEDGE_DIRECTIONS]
                              [MASK_MASTER_SIZE * MASK_MASTER_SIZE]);

DECLARE_ALIGNED(16, static uint8_t,
                wedge_signflip_lookup[BLOCK_SIZES][MAX_WEDGE_TYPES]);

// 3 * MAX_WEDGE_SQUARE is an easy to compute and fairly tight upper bound
// on the sum of all mask sizes up to an including MAX_WEDGE_SQUARE.
DECLARE_ALIGNED(16, static uint8_t,
                wedge_mask_buf[2 * MAX_WEDGE_TYPES * 3 * MAX_WEDGE_SQUARE]);

static wedge_masks_type wedge_masks[BLOCK_SIZES][2];

// Some unused wedge codebooks left temporarily to facilitate experiments.
// To be removed when settled.
/*
static wedge_code_type wedge_codebook_8_hgtw[8] = {
  { WEDGE_OBLIQUE27, 4, 4 },  { WEDGE_OBLIQUE63, 4, 4 },
  { WEDGE_OBLIQUE117, 4, 4 }, { WEDGE_OBLIQUE153, 4, 4 },
  { WEDGE_OBLIQUE27, 4, 2 },  { WEDGE_OBLIQUE27, 4, 6 },
  { WEDGE_OBLIQUE153, 4, 2 }, { WEDGE_OBLIQUE153, 4, 6 },
};

static wedge_code_type wedge_codebook_8_hltw[8] = {
  { WEDGE_OBLIQUE27, 4, 4 },  { WEDGE_OBLIQUE63, 4, 4 },
  { WEDGE_OBLIQUE117, 4, 4 }, { WEDGE_OBLIQUE153, 4, 4 },
  { WEDGE_OBLIQUE63, 2, 4 },  { WEDGE_OBLIQUE63, 6, 4 },
  { WEDGE_OBLIQUE117, 2, 4 }, { WEDGE_OBLIQUE117, 6, 4 },
};

static wedge_code_type wedge_codebook_8_heqw[8] = {
  { WEDGE_OBLIQUE27, 4, 4 },  { WEDGE_OBLIQUE63, 4, 4 },
  { WEDGE_OBLIQUE117, 4, 4 }, { WEDGE_OBLIQUE153, 4, 4 },
  { WEDGE_HORIZONTAL, 4, 2 }, { WEDGE_HORIZONTAL, 4, 6 },
  { WEDGE_VERTICAL, 2, 4 },   { WEDGE_VERTICAL, 6, 4 },
};

static const wedge_code_type wedge_codebook_32_hgtw[32] = {
  { WEDGE_OBLIQUE27, 4, 4 },  { WEDGE_OBLIQUE63, 4, 4 },
  { WEDGE_OBLIQUE117, 4, 4 }, { WEDGE_OBLIQUE153, 4, 4 },
  { WEDGE_HORIZONTAL, 4, 2 }, { WEDGE_HORIZONTAL, 4, 4 },
  { WEDGE_HORIZONTAL, 4, 6 }, { WEDGE_VERTICAL, 4, 4 },
  { WEDGE_OBLIQUE27, 4, 1 },  { WEDGE_OBLIQUE27, 4, 2 },
  { WEDGE_OBLIQUE27, 4, 3 },  { WEDGE_OBLIQUE27, 4, 5 },
  { WEDGE_OBLIQUE27, 4, 6 },  { WEDGE_OBLIQUE27, 4, 7 },
  { WEDGE_OBLIQUE153, 4, 1 }, { WEDGE_OBLIQUE153, 4, 2 },
  { WEDGE_OBLIQUE153, 4, 3 }, { WEDGE_OBLIQUE153, 4, 5 },
  { WEDGE_OBLIQUE153, 4, 6 }, { WEDGE_OBLIQUE153, 4, 7 },
  { WEDGE_OBLIQUE63, 1, 4 },  { WEDGE_OBLIQUE63, 2, 4 },
  { WEDGE_OBLIQUE63, 3, 4 },  { WEDGE_OBLIQUE63, 5, 4 },
  { WEDGE_OBLIQUE63, 6, 4 },  { WEDGE_OBLIQUE63, 7, 4 },
  { WEDGE_OBLIQUE117, 1, 4 }, { WEDGE_OBLIQUE117, 2, 4 },
  { WEDGE_OBLIQUE117, 3, 4 }, { WEDGE_OBLIQUE117, 5, 4 },
  { WEDGE_OBLIQUE117, 6, 4 }, { WEDGE_OBLIQUE117, 7, 4 },
};

static const wedge_code_type wedge_codebook_32_hltw[32] = {
  { WEDGE_OBLIQUE27, 4, 4 },  { WEDGE_OBLIQUE63, 4, 4 },
  { WEDGE_OBLIQUE117, 4, 4 }, { WEDGE_OBLIQUE153, 4, 4 },
  { WEDGE_VERTICAL, 2, 4 },   { WEDGE_VERTICAL, 4, 4 },
  { WEDGE_VERTICAL, 6, 4 },   { WEDGE_HORIZONTAL, 4, 4 },
  { WEDGE_OBLIQUE27, 4, 1 },  { WEDGE_OBLIQUE27, 4, 2 },
  { WEDGE_OBLIQUE27, 4, 3 },  { WEDGE_OBLIQUE27, 4, 5 },
  { WEDGE_OBLIQUE27, 4, 6 },  { WEDGE_OBLIQUE27, 4, 7 },
  { WEDGE_OBLIQUE153, 4, 1 }, { WEDGE_OBLIQUE153, 4, 2 },
  { WEDGE_OBLIQUE153, 4, 3 }, { WEDGE_OBLIQUE153, 4, 5 },
  { WEDGE_OBLIQUE153, 4, 6 }, { WEDGE_OBLIQUE153, 4, 7 },
  { WEDGE_OBLIQUE63, 1, 4 },  { WEDGE_OBLIQUE63, 2, 4 },
  { WEDGE_OBLIQUE63, 3, 4 },  { WEDGE_OBLIQUE63, 5, 4 },
  { WEDGE_OBLIQUE63, 6, 4 },  { WEDGE_OBLIQUE63, 7, 4 },
  { WEDGE_OBLIQUE117, 1, 4 }, { WEDGE_OBLIQUE117, 2, 4 },
  { WEDGE_OBLIQUE117, 3, 4 }, { WEDGE_OBLIQUE117, 5, 4 },
  { WEDGE_OBLIQUE117, 6, 4 }, { WEDGE_OBLIQUE117, 7, 4 },
};

static const wedge_code_type wedge_codebook_32_heqw[32] = {
  { WEDGE_OBLIQUE27, 4, 4 },  { WEDGE_OBLIQUE63, 4, 4 },
  { WEDGE_OBLIQUE117, 4, 4 }, { WEDGE_OBLIQUE153, 4, 4 },
  { WEDGE_HORIZONTAL, 4, 2 }, { WEDGE_HORIZONTAL, 4, 6 },
  { WEDGE_VERTICAL, 2, 4 },   { WEDGE_VERTICAL, 6, 4 },
  { WEDGE_OBLIQUE27, 4, 1 },  { WEDGE_OBLIQUE27, 4, 2 },
  { WEDGE_OBLIQUE27, 4, 3 },  { WEDGE_OBLIQUE27, 4, 5 },
  { WEDGE_OBLIQUE27, 4, 6 },  { WEDGE_OBLIQUE27, 4, 7 },
  { WEDGE_OBLIQUE153, 4, 1 }, { WEDGE_OBLIQUE153, 4, 2 },
  { WEDGE_OBLIQUE153, 4, 3 }, { WEDGE_OBLIQUE153, 4, 5 },
  { WEDGE_OBLIQUE153, 4, 6 }, { WEDGE_OBLIQUE153, 4, 7 },
  { WEDGE_OBLIQUE63, 1, 4 },  { WEDGE_OBLIQUE63, 2, 4 },
  { WEDGE_OBLIQUE63, 3, 4 },  { WEDGE_OBLIQUE63, 5, 4 },
  { WEDGE_OBLIQUE63, 6, 4 },  { WEDGE_OBLIQUE63, 7, 4 },
  { WEDGE_OBLIQUE117, 1, 4 }, { WEDGE_OBLIQUE117, 2, 4 },
  { WEDGE_OBLIQUE117, 3, 4 }, { WEDGE_OBLIQUE117, 5, 4 },
  { WEDGE_OBLIQUE117, 6, 4 }, { WEDGE_OBLIQUE117, 7, 4 },
};
*/

static const wedge_code_type wedge_codebook_16_hgtw[16] = {
  { WEDGE_OBLIQUE27, 4, 4 },  { WEDGE_OBLIQUE63, 4, 4 },
  { WEDGE_OBLIQUE117, 4, 4 }, { WEDGE_OBLIQUE153, 4, 4 },
  { WEDGE_HORIZONTAL, 4, 2 }, { WEDGE_HORIZONTAL, 4, 4 },
  { WEDGE_HORIZONTAL, 4, 6 }, { WEDGE_VERTICAL, 4, 4 },
  { WEDGE_OBLIQUE27, 4, 2 },  { WEDGE_OBLIQUE27, 4, 6 },
  { WEDGE_OBLIQUE153, 4, 2 }, { WEDGE_OBLIQUE153, 4, 6 },
  { WEDGE_OBLIQUE63, 2, 4 },  { WEDGE_OBLIQUE63, 6, 4 },
  { WEDGE_OBLIQUE117, 2, 4 }, { WEDGE_OBLIQUE117, 6, 4 },
};

static const wedge_code_type wedge_codebook_16_hltw[16] = {
  { WEDGE_OBLIQUE27, 4, 4 },  { WEDGE_OBLIQUE63, 4, 4 },
  { WEDGE_OBLIQUE117, 4, 4 }, { WEDGE_OBLIQUE153, 4, 4 },
  { WEDGE_VERTICAL, 2, 4 },   { WEDGE_VERTICAL, 4, 4 },
  { WEDGE_VERTICAL, 6, 4 },   { WEDGE_HORIZONTAL, 4, 4 },
  { WEDGE_OBLIQUE27, 4, 2 },  { WEDGE_OBLIQUE27, 4, 6 },
  { WEDGE_OBLIQUE153, 4, 2 }, { WEDGE_OBLIQUE153, 4, 6 },
  { WEDGE_OBLIQUE63, 2, 4 },  { WEDGE_OBLIQUE63, 6, 4 },
  { WEDGE_OBLIQUE117, 2, 4 }, { WEDGE_OBLIQUE117, 6, 4 },
};

static const wedge_code_type wedge_codebook_16_heqw[16] = {
  { WEDGE_OBLIQUE27, 4, 4 },  { WEDGE_OBLIQUE63, 4, 4 },
  { WEDGE_OBLIQUE117, 4, 4 }, { WEDGE_OBLIQUE153, 4, 4 },
  { WEDGE_HORIZONTAL, 4, 2 }, { WEDGE_HORIZONTAL, 4, 6 },
  { WEDGE_VERTICAL, 2, 4 },   { WEDGE_VERTICAL, 6, 4 },
  { WEDGE_OBLIQUE27, 4, 2 },  { WEDGE_OBLIQUE27, 4, 6 },
  { WEDGE_OBLIQUE153, 4, 2 }, { WEDGE_OBLIQUE153, 4, 6 },
  { WEDGE_OBLIQUE63, 2, 4 },  { WEDGE_OBLIQUE63, 6, 4 },
  { WEDGE_OBLIQUE117, 2, 4 }, { WEDGE_OBLIQUE117, 6, 4 },
};

const wedge_params_type wedge_params_lookup[BLOCK_SIZES] = {
#if CONFIG_CB4X4
  { 0, NULL, NULL, 0, NULL },
  { 0, NULL, NULL, 0, NULL },
  { 0, NULL, NULL, 0, NULL },
#endif  // CONFIG_CB4X4
  { 0, NULL, NULL, 0, NULL },
  { 0, NULL, NULL, 0, NULL },
  { 0, NULL, NULL, 0, NULL },
#if CONFIG_WEDGE
  { 4, wedge_codebook_16_heqw, wedge_signflip_lookup[BLOCK_8X8], 0,
    wedge_masks[BLOCK_8X8] },
  { 4, wedge_codebook_16_hgtw, wedge_signflip_lookup[BLOCK_8X16], 0,
    wedge_masks[BLOCK_8X16] },
  { 4, wedge_codebook_16_hltw, wedge_signflip_lookup[BLOCK_16X8], 0,
    wedge_masks[BLOCK_16X8] },
  { 4, wedge_codebook_16_heqw, wedge_signflip_lookup[BLOCK_16X16], 0,
    wedge_masks[BLOCK_16X16] },
  { 4, wedge_codebook_16_hgtw, wedge_signflip_lookup[BLOCK_16X32], 0,
    wedge_masks[BLOCK_16X32] },
  { 4, wedge_codebook_16_hltw, wedge_signflip_lookup[BLOCK_32X16], 0,
    wedge_masks[BLOCK_32X16] },
  { 4, wedge_codebook_16_heqw, wedge_signflip_lookup[BLOCK_32X32], 0,
    wedge_masks[BLOCK_32X32] },
  { 0, wedge_codebook_16_hgtw, wedge_signflip_lookup[BLOCK_32X64], 0,
    wedge_masks[BLOCK_32X64] },
  { 0, wedge_codebook_16_hltw, wedge_signflip_lookup[BLOCK_64X32], 0,
    wedge_masks[BLOCK_64X32] },
  { 0, wedge_codebook_16_heqw, wedge_signflip_lookup[BLOCK_64X64], 0,
    wedge_masks[BLOCK_64X64] },
#else
  { 0, wedge_codebook_16_heqw, wedge_signflip_lookup[BLOCK_8X8], 0,
    wedge_masks[BLOCK_8X8] },
  { 0, wedge_codebook_16_hgtw, wedge_signflip_lookup[BLOCK_8X16], 0,
    wedge_masks[BLOCK_8X16] },
  { 0, wedge_codebook_16_hltw, wedge_signflip_lookup[BLOCK_16X8], 0,
    wedge_masks[BLOCK_16X8] },
  { 0, wedge_codebook_16_heqw, wedge_signflip_lookup[BLOCK_16X16], 0,
    wedge_masks[BLOCK_16X16] },
  { 0, wedge_codebook_16_hgtw, wedge_signflip_lookup[BLOCK_16X32], 0,
    wedge_masks[BLOCK_16X32] },
  { 0, wedge_codebook_16_hltw, wedge_signflip_lookup[BLOCK_32X16], 0,
    wedge_masks[BLOCK_32X16] },
  { 0, wedge_codebook_16_heqw, wedge_signflip_lookup[BLOCK_32X32], 0,
    wedge_masks[BLOCK_32X32] },
  { 0, wedge_codebook_16_hgtw, wedge_signflip_lookup[BLOCK_32X64], 0,
    wedge_masks[BLOCK_32X64] },
  { 0, wedge_codebook_16_hltw, wedge_signflip_lookup[BLOCK_64X32], 0,
    wedge_masks[BLOCK_64X32] },
  { 0, wedge_codebook_16_heqw, wedge_signflip_lookup[BLOCK_64X64], 0,
    wedge_masks[BLOCK_64X64] },
#endif  // CONFIG_WEDGE
#if CONFIG_EXT_PARTITION
  { 0, NULL, NULL, 0, NULL },
  { 0, NULL, NULL, 0, NULL },
  { 0, NULL, NULL, 0, NULL },
#endif  // CONFIG_EXT_PARTITION
};

static const uint8_t *get_wedge_mask_inplace(int wedge_index, int neg,
                                             BLOCK_SIZE sb_type) {
  const uint8_t *master;
  const int bh = block_size_high[sb_type];
  const int bw = block_size_wide[sb_type];
  const wedge_code_type *a =
      wedge_params_lookup[sb_type].codebook + wedge_index;
  const int smoother = wedge_params_lookup[sb_type].smoother;
  int woff, hoff;
  const uint8_t wsignflip = wedge_params_lookup[sb_type].signflip[wedge_index];

  assert(wedge_index >= 0 &&
         wedge_index < (1 << get_wedge_bits_lookup(sb_type)));
  woff = (a->x_offset * bw) >> 3;
  hoff = (a->y_offset * bh) >> 3;
  master = wedge_mask_obl[smoother][neg ^ wsignflip][a->direction] +
           MASK_MASTER_STRIDE * (MASK_MASTER_SIZE / 2 - hoff) +
           MASK_MASTER_SIZE / 2 - woff;
  return master;
}

const uint8_t *av1_get_soft_mask(int wedge_index, int wedge_sign,
                                 BLOCK_SIZE sb_type, int offset_x,
                                 int offset_y) {
  const uint8_t *mask =
      get_wedge_mask_inplace(wedge_index, wedge_sign, sb_type);
  if (mask) mask -= (offset_x + offset_y * MASK_MASTER_STRIDE);
  return mask;
}

#if CONFIG_COMPOUND_SEGMENT
static uint8_t *invert_mask(uint8_t *mask_inv_buffer, const uint8_t *const mask,
                            int h, int w, int stride) {
  int i, j;

  for (i = 0; i < h; ++i)
    for (j = 0; j < w; ++j) {
      mask_inv_buffer[i * stride + j] =
          AOM_BLEND_A64_MAX_ALPHA - mask[i * stride + j];
    }
  return mask_inv_buffer;
}
#endif  // CONFIG_COMPOUND_SEGMENT

const uint8_t *av1_get_compound_type_mask_inverse(
    const INTERINTER_COMPOUND_DATA *const comp_data,
#if CONFIG_COMPOUND_SEGMENT
    uint8_t *mask_buffer, int h, int w, int stride,
#endif
    BLOCK_SIZE sb_type) {
  assert(is_masked_compound_type(comp_data->interinter_compound_type));
  (void)sb_type;
  switch (comp_data->interinter_compound_type) {
#if CONFIG_WEDGE
    case COMPOUND_WEDGE:
      return av1_get_contiguous_soft_mask(comp_data->wedge_index,
                                          !comp_data->wedge_sign, sb_type);
#endif  // CONFIG_WEDGE
#if CONFIG_COMPOUND_SEGMENT
    case COMPOUND_SEG:
      return invert_mask(mask_buffer, comp_data->seg_mask, h, w, stride);
#endif  // CONFIG_COMPOUND_SEGMENT
    default: assert(0); return NULL;
  }
}

const uint8_t *av1_get_compound_type_mask(
    const INTERINTER_COMPOUND_DATA *const comp_data, BLOCK_SIZE sb_type) {
  assert(is_masked_compound_type(comp_data->interinter_compound_type));
  (void)sb_type;
  switch (comp_data->interinter_compound_type) {
#if CONFIG_WEDGE
    case COMPOUND_WEDGE:
      return av1_get_contiguous_soft_mask(comp_data->wedge_index,
                                          comp_data->wedge_sign, sb_type);
#endif  // CONFIG_WEDGE
#if CONFIG_COMPOUND_SEGMENT
    case COMPOUND_SEG: return comp_data->seg_mask;
#endif  // CONFIG_COMPOUND_SEGMENT
    default: assert(0); return NULL;
  }
}

#if CONFIG_COMPOUND_SEGMENT
#if COMPOUND_SEGMENT_TYPE == 0
static void uniform_mask(uint8_t *mask, int which_inverse, BLOCK_SIZE sb_type,
                         int h, int w, int mask_val) {
  int i, j;
  int block_stride = block_size_wide[sb_type];
  for (i = 0; i < h; ++i)
    for (j = 0; j < w; ++j) {
      mask[i * block_stride + j] =
          which_inverse ? AOM_BLEND_A64_MAX_ALPHA - mask_val : mask_val;
    }
}

void build_compound_seg_mask(uint8_t *mask, SEG_MASK_TYPE mask_type,
                             const uint8_t *src0, int src0_stride,
                             const uint8_t *src1, int src1_stride,
                             BLOCK_SIZE sb_type, int h, int w) {
  (void)src0;
  (void)src1;
  (void)src0_stride;
  (void)src1_stride;
  switch (mask_type) {
    case UNIFORM_45: uniform_mask(mask, 0, sb_type, h, w, 45); break;
    case UNIFORM_45_INV: uniform_mask(mask, 1, sb_type, h, w, 45); break;
    default: assert(0);
  }
}

#if CONFIG_HIGHBITDEPTH
void build_compound_seg_mask_highbd(uint8_t *mask, SEG_MASK_TYPE mask_type,
                                    const uint8_t *src0, int src0_stride,
                                    const uint8_t *src1, int src1_stride,
                                    BLOCK_SIZE sb_type, int h, int w, int bd) {
  (void)src0;
  (void)src1;
  (void)src0_stride;
  (void)src1_stride;
  (void)bd;
  switch (mask_type) {
    case UNIFORM_45: uniform_mask(mask, 0, sb_type, h, w, 45); break;
    case UNIFORM_45_INV: uniform_mask(mask, 1, sb_type, h, w, 45); break;
    default: assert(0);
  }
}
#endif  // CONFIG_HIGHBITDEPTH

#elif COMPOUND_SEGMENT_TYPE == 1
#define DIFF_FACTOR 16
static void diffwtd_mask(uint8_t *mask, int which_inverse, int mask_base,
                         const uint8_t *src0, int src0_stride,
                         const uint8_t *src1, int src1_stride,
                         BLOCK_SIZE sb_type, int h, int w) {
  int i, j, m, diff;
  int block_stride = block_size_wide[sb_type];
  for (i = 0; i < h; ++i) {
    for (j = 0; j < w; ++j) {
      diff =
          abs((int)src0[i * src0_stride + j] - (int)src1[i * src1_stride + j]);
      m = clamp(mask_base + (diff / DIFF_FACTOR), 0, AOM_BLEND_A64_MAX_ALPHA);
      mask[i * block_stride + j] =
          which_inverse ? AOM_BLEND_A64_MAX_ALPHA - m : m;
    }
  }
}

void build_compound_seg_mask(uint8_t *mask, SEG_MASK_TYPE mask_type,
                             const uint8_t *src0, int src0_stride,
                             const uint8_t *src1, int src1_stride,
                             BLOCK_SIZE sb_type, int h, int w) {
  switch (mask_type) {
    case DIFFWTD_38:
      diffwtd_mask(mask, 0, 38, src0, src0_stride, src1, src1_stride, sb_type,
                   h, w);
      break;
    case DIFFWTD_38_INV:
      diffwtd_mask(mask, 1, 38, src0, src0_stride, src1, src1_stride, sb_type,
                   h, w);
      break;
    default: assert(0);
  }
}

#if CONFIG_HIGHBITDEPTH
static void diffwtd_mask_highbd(uint8_t *mask, int which_inverse, int mask_base,
                                const uint16_t *src0, int src0_stride,
                                const uint16_t *src1, int src1_stride,
                                BLOCK_SIZE sb_type, int h, int w, int bd) {
  int i, j, m, diff;
  int block_stride = block_size_wide[sb_type];
  for (i = 0; i < h; ++i) {
    for (j = 0; j < w; ++j) {
      diff = abs((int)src0[i * src0_stride + j] -
                 (int)src1[i * src1_stride + j]) >>
             (bd - 8);
      m = clamp(mask_base + (diff / DIFF_FACTOR), 0, AOM_BLEND_A64_MAX_ALPHA);
      mask[i * block_stride + j] =
          which_inverse ? AOM_BLEND_A64_MAX_ALPHA - m : m;
    }
  }
}

void build_compound_seg_mask_highbd(uint8_t *mask, SEG_MASK_TYPE mask_type,
                                    const uint8_t *src0, int src0_stride,
                                    const uint8_t *src1, int src1_stride,
                                    BLOCK_SIZE sb_type, int h, int w, int bd) {
  switch (mask_type) {
    case DIFFWTD_38:
      diffwtd_mask_highbd(mask, 0, 42, CONVERT_TO_SHORTPTR(src0), src0_stride,
                          CONVERT_TO_SHORTPTR(src1), src1_stride, sb_type, h, w,
                          bd);
      break;
    case DIFFWTD_38_INV:
      diffwtd_mask_highbd(mask, 1, 42, CONVERT_TO_SHORTPTR(src0), src0_stride,
                          CONVERT_TO_SHORTPTR(src1), src1_stride, sb_type, h, w,
                          bd);
      break;
    default: assert(0);
  }
}
#endif  // CONFIG_HIGHBITDEPTH
#endif  // COMPOUND_SEGMENT_TYPE
#endif  // CONFIG_COMPOUND_SEGMENT

#if MASK_MASTER_SIZE == 64
static const uint8_t wedge_master_oblique_odd[NSMOOTHERS][MASK_MASTER_SIZE] = {
  {
      0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
      0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  2,  6,  18,
      37, 53, 60, 63, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
      64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
  }
};
static const uint8_t wedge_master_oblique_even[NSMOOTHERS][MASK_MASTER_SIZE] = {
  {
      0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
      0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  4,  11, 27,
      46, 58, 62, 63, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
      64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
  }
};
static const uint8_t wedge_master_vertical[NSMOOTHERS][MASK_MASTER_SIZE] = { {
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  2,  7,  21,
    43, 57, 62, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
} };

static void shift_copy(const uint8_t *src, uint8_t *dst, int shift, int width) {
  if (shift >= 0) {
    memcpy(dst + shift, src, width - shift);
    memset(dst, src[0], shift);
  } else {
    shift = -shift;
    memcpy(dst, src + shift, width - shift);
    memset(dst + width - shift, src[width - 1], shift);
  }
}
#else
static const double smoother_param[NSMOOTHERS] = { 3.0 };
#endif  // MASK_MASTER_SIZE == 64

static void init_wedge_master_masks() {
  int i, j, s;
  const int w = MASK_MASTER_SIZE;
  const int h = MASK_MASTER_SIZE;
  const int stride = MASK_MASTER_STRIDE;
  for (s = 0; s < NSMOOTHERS; s++) {
// Note: index [0] stores the masters, and [1] its complement.
#if MASK_MASTER_SIZE == 64
    // Generate prototype by shifting the masters
    int shift = h / 4;
    for (i = 0; i < h; i += 2) {
      shift_copy(wedge_master_oblique_even[s],
                 &wedge_mask_obl[s][0][WEDGE_OBLIQUE63][i * stride], shift,
                 MASK_MASTER_SIZE);
      shift--;
      shift_copy(wedge_master_oblique_odd[s],
                 &wedge_mask_obl[s][0][WEDGE_OBLIQUE63][(i + 1) * stride],
                 shift, MASK_MASTER_SIZE);
      memcpy(&wedge_mask_obl[s][0][WEDGE_VERTICAL][i * stride],
             wedge_master_vertical[s],
             MASK_MASTER_SIZE * sizeof(wedge_master_vertical[s][0]));
      memcpy(&wedge_mask_obl[s][0][WEDGE_VERTICAL][(i + 1) * stride],
             wedge_master_vertical[s],
             MASK_MASTER_SIZE * sizeof(wedge_master_vertical[s][0]));
    }
#else
    const int a[2] = { 2, 1 };
    const double asqrt = sqrt(a[0] * a[0] + a[1] * a[1]);
    for (i = 0; i < h; i++) {
      for (j = 0; j < w; ++j) {
        int x = (2 * j + 1 - w);
        int y = (2 * i + 1 - h);
        double d = (a[0] * x + a[1] * y) / asqrt;
        const int msk = (int)rint((1.0 + tanh(d / smoother_param[s])) * 32);
        wedge_mask_obl[s][0][WEDGE_OBLIQUE63][i * stride + j] = msk;
        const int mskx = (int)rint((1.0 + tanh(x / smoother_param[s])) * 32);
        wedge_mask_obl[s][0][WEDGE_VERTICAL][i * stride + j] = mskx;
      }
    }
#endif  // MASK_MASTER_SIZE == 64
    for (i = 0; i < h; ++i) {
      for (j = 0; j < w; ++j) {
        const int msk = wedge_mask_obl[s][0][WEDGE_OBLIQUE63][i * stride + j];
        wedge_mask_obl[s][0][WEDGE_OBLIQUE27][j * stride + i] = msk;
        wedge_mask_obl[s][0][WEDGE_OBLIQUE117][i * stride + w - 1 - j] =
            wedge_mask_obl[s][0][WEDGE_OBLIQUE153][(w - 1 - j) * stride + i] =
                (1 << WEDGE_WEIGHT_BITS) - msk;
        wedge_mask_obl[s][1][WEDGE_OBLIQUE63][i * stride + j] =
            wedge_mask_obl[s][1][WEDGE_OBLIQUE27][j * stride + i] =
                (1 << WEDGE_WEIGHT_BITS) - msk;
        wedge_mask_obl[s][1][WEDGE_OBLIQUE117][i * stride + w - 1 - j] =
            wedge_mask_obl[s][1][WEDGE_OBLIQUE153][(w - 1 - j) * stride + i] =
                msk;
        const int mskx = wedge_mask_obl[s][0][WEDGE_VERTICAL][i * stride + j];
        wedge_mask_obl[s][0][WEDGE_HORIZONTAL][j * stride + i] = mskx;
        wedge_mask_obl[s][1][WEDGE_VERTICAL][i * stride + j] =
            wedge_mask_obl[s][1][WEDGE_HORIZONTAL][j * stride + i] =
                (1 << WEDGE_WEIGHT_BITS) - mskx;
      }
    }
  }
}

// If the signs for the wedges for various blocksizes are
// inconsistent flip the sign flag. Do it only once for every
// wedge codebook.
static void init_wedge_signs() {
  BLOCK_SIZE sb_type;
  memset(wedge_signflip_lookup, 0, sizeof(wedge_signflip_lookup));
  for (sb_type = BLOCK_4X4; sb_type < BLOCK_SIZES; ++sb_type) {
    const int bw = block_size_wide[sb_type];
    const int bh = block_size_high[sb_type];
    const wedge_params_type wedge_params = wedge_params_lookup[sb_type];
    const int wbits = wedge_params.bits;
    const int wtypes = 1 << wbits;
    int i, w;
    if (wbits == 0) continue;
    for (w = 0; w < wtypes; ++w) {
      // Get the mask master, i.e. index [0]
      const uint8_t *mask = get_wedge_mask_inplace(w, 0, sb_type);
      int avg = 0;
      for (i = 0; i < bw; ++i) avg += mask[i];
      for (i = 1; i < bh; ++i) avg += mask[i * MASK_MASTER_STRIDE];
      avg = (avg + (bw + bh - 1) / 2) / (bw + bh - 1);
      // Default sign of this wedge is 1 if the average < 32, 0 otherwise.
      // If default sign is 1:
      //   If sign requested is 0, we need to flip the sign and return
      //   the complement i.e. index [1] instead. If sign requested is 1
      //   we need to flip the sign and return index [0] instead.
      // If default sign is 0:
      //   If sign requested is 0, we need to return index [0] the master
      //   if sign requested is 1, we need to return the complement index [1]
      //   instead.
      wedge_params.signflip[w] = (avg < 32);
      // printf("%d[%d] = %d\n", sb_type, w, wedge_params.signflip[w]);
    }
  }
}

static void init_wedge_masks() {
  uint8_t *dst = wedge_mask_buf;
  BLOCK_SIZE bsize;
  memset(wedge_masks, 0, sizeof(wedge_masks));
  for (bsize = BLOCK_4X4; bsize < BLOCK_SIZES; ++bsize) {
    const uint8_t *mask;
    const int bw = block_size_wide[bsize];
    const int bh = block_size_high[bsize];
    const wedge_params_type *wedge_params = &wedge_params_lookup[bsize];
    const int wbits = wedge_params->bits;
    const int wtypes = 1 << wbits;
    int w;
    if (wbits == 0) continue;
    for (w = 0; w < wtypes; ++w) {
      mask = get_wedge_mask_inplace(w, 0, bsize);
      aom_convolve_copy(mask, MASK_MASTER_STRIDE, dst, bw, NULL, 0, NULL, 0, bw,
                        bh);
      wedge_params->masks[0][w] = dst;
      dst += bw * bh;

      mask = get_wedge_mask_inplace(w, 1, bsize);
      aom_convolve_copy(mask, MASK_MASTER_STRIDE, dst, bw, NULL, 0, NULL, 0, bw,
                        bh);
      wedge_params->masks[1][w] = dst;
      dst += bw * bh;
    }
    assert(sizeof(wedge_mask_buf) >= (size_t)(dst - wedge_mask_buf));
  }
}

// Equation of line: f(x, y) = a[0]*(x - a[2]*w/8) + a[1]*(y - a[3]*h/8) = 0
void av1_init_wedge_masks() {
  init_wedge_master_masks();
  init_wedge_signs();
  init_wedge_masks();
}

#if CONFIG_SUPERTX
static void build_masked_compound_wedge_extend(
    uint8_t *dst, int dst_stride, const uint8_t *src0, int src0_stride,
    const uint8_t *src1, int src1_stride,
    const INTERINTER_COMPOUND_DATA *const comp_data, BLOCK_SIZE sb_type,
    int wedge_offset_x, int wedge_offset_y, int h, int w) {
  const int subh = (2 << b_height_log2_lookup[sb_type]) == h;
  const int subw = (2 << b_width_log2_lookup[sb_type]) == w;
  const uint8_t *mask;
  size_t mask_stride;
  switch (comp_data->interinter_compound_type) {
    case COMPOUND_WEDGE:
      mask = av1_get_soft_mask(comp_data->wedge_index, comp_data->wedge_sign,
                               sb_type, wedge_offset_x, wedge_offset_y);
      mask_stride = MASK_MASTER_STRIDE;
      break;
#if CONFIG_COMPOUND_SEGMENT
    case COMPOUND_SEG:
      mask = comp_data->seg_mask;
      mask_stride = block_size_wide[sb_type];
      break;
#endif
    default: assert(0); return;
  }
  aom_blend_a64_mask(dst, dst_stride, src0, src0_stride, src1, src1_stride,
                     mask, (int)mask_stride, h, w, subh, subw);
}

#if CONFIG_HIGHBITDEPTH
static void build_masked_compound_wedge_extend_highbd(
    uint8_t *dst_8, int dst_stride, const uint8_t *src0_8, int src0_stride,
    const uint8_t *src1_8, int src1_stride,
    const INTERINTER_COMPOUND_DATA *const comp_data, BLOCK_SIZE sb_type,
    int wedge_offset_x, int wedge_offset_y, int h, int w, int bd) {
  const int subh = (2 << b_height_log2_lookup[sb_type]) == h;
  const int subw = (2 << b_width_log2_lookup[sb_type]) == w;
  const uint8_t *mask;
  size_t mask_stride;
  switch (comp_data->interinter_compound_type) {
    case COMPOUND_WEDGE:
      mask = av1_get_soft_mask(comp_data->wedge_index, comp_data->wedge_sign,
                               sb_type, wedge_offset_x, wedge_offset_y);
      mask_stride = MASK_MASTER_STRIDE;
      break;
#if CONFIG_COMPOUND_SEGMENT
    case COMPOUND_SEG:
      mask = comp_data->seg_mask;
      mask_stride = block_size_wide[sb_type];
      break;
#endif
    default: assert(0); return;
  }
  aom_highbd_blend_a64_mask(dst_8, dst_stride, src0_8, src0_stride, src1_8,
                            src1_stride, mask, (int)mask_stride, h, w, subh,
                            subw, bd);
}
#endif  // CONFIG_HIGHBITDEPTH
#else
static void build_masked_compound(
    uint8_t *dst, int dst_stride, const uint8_t *src0, int src0_stride,
    const uint8_t *src1, int src1_stride,
    const INTERINTER_COMPOUND_DATA *const comp_data, BLOCK_SIZE sb_type, int h,
    int w) {
  // Derive subsampling from h and w passed in. May be refactored to
  // pass in subsampling factors directly.
  const int subh = (2 << b_height_log2_lookup[sb_type]) == h;
  const int subw = (2 << b_width_log2_lookup[sb_type]) == w;
  const uint8_t *mask = av1_get_compound_type_mask(comp_data, sb_type);
  aom_blend_a64_mask(dst, dst_stride, src0, src0_stride, src1, src1_stride,
                     mask, block_size_wide[sb_type], h, w, subh, subw);
}

#if CONFIG_HIGHBITDEPTH
static void build_masked_compound_highbd(
    uint8_t *dst_8, int dst_stride, const uint8_t *src0_8, int src0_stride,
    const uint8_t *src1_8, int src1_stride,
    const INTERINTER_COMPOUND_DATA *const comp_data, BLOCK_SIZE sb_type, int h,
    int w, int bd) {
  // Derive subsampling from h and w passed in. May be refactored to
  // pass in subsampling factors directly.
  const int subh = (2 << b_height_log2_lookup[sb_type]) == h;
  const int subw = (2 << b_width_log2_lookup[sb_type]) == w;
  const uint8_t *mask = av1_get_compound_type_mask(comp_data, sb_type);
  // const uint8_t *mask =
  //     av1_get_contiguous_soft_mask(wedge_index, wedge_sign, sb_type);
  aom_highbd_blend_a64_mask(dst_8, dst_stride, src0_8, src0_stride, src1_8,
                            src1_stride, mask, block_size_wide[sb_type], h, w,
                            subh, subw, bd);
}
#endif  // CONFIG_HIGHBITDEPTH
#endif  // CONFIG_SUPERTX

void av1_make_masked_inter_predictor(const uint8_t *pre, int pre_stride,
                                     uint8_t *dst, int dst_stride,
                                     const int subpel_x, const int subpel_y,
                                     const struct scale_factors *sf, int w,
                                     int h,
#if CONFIG_DUAL_FILTER
                                     const InterpFilter *interp_filter,
#else
                                     const InterpFilter interp_filter,
#endif
                                     int xs, int ys,
#if CONFIG_SUPERTX
                                     int wedge_offset_x, int wedge_offset_y,
#endif  // CONFIG_SUPERTX
                                     int plane,
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                                     const WarpTypesAllowed *warp_types,
                                     int p_col, int p_row, int ref,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                                     MACROBLOCKD *xd) {
  MODE_INFO *mi = xd->mi[0];
  const INTERINTER_COMPOUND_DATA comp_data = {
#if CONFIG_WEDGE
    mi->mbmi.wedge_index,
    mi->mbmi.wedge_sign,
#endif  // CONFIG_WEDGE
#if CONFIG_COMPOUND_SEGMENT
    mi->mbmi.mask_type,
    xd->seg_mask,
#endif  // CONFIG_COMPOUND_SEGMENT
    mi->mbmi.interinter_compound_type
  };
// The prediction filter types used here should be those for
// the second reference block.
#if CONFIG_DUAL_FILTER
  InterpFilter tmp_ipf[4] = {
    interp_filter[2], interp_filter[3], interp_filter[2], interp_filter[3],
  };
#else
  InterpFilter tmp_ipf = interp_filter;
#endif  // CONFIG_DUAL_FILTER
  ConvolveParams conv_params = get_conv_params(0, plane);

#if CONFIG_HIGHBITDEPTH
  DECLARE_ALIGNED(16, uint8_t, tmp_dst_[2 * MAX_SB_SQUARE]);
  uint8_t *tmp_dst = (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH)
                         ? CONVERT_TO_BYTEPTR(tmp_dst_)
                         : tmp_dst_;
  av1_make_inter_predictor(pre, pre_stride, tmp_dst, MAX_SB_SIZE, subpel_x,
                           subpel_y, sf, w, h, &conv_params, tmp_ipf,
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                           warp_types, p_col, p_row, plane, ref,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
#if CONFIG_MOTION_VAR
                           0, 0,
#endif
                           xs, ys, xd);
#if CONFIG_COMPOUND_SEGMENT
  if (!plane && comp_data.interinter_compound_type == COMPOUND_SEG) {
    if (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH)
      build_compound_seg_mask_highbd(comp_data.seg_mask, comp_data.mask_type,
                                     dst, dst_stride, tmp_dst, MAX_SB_SIZE,
                                     mi->mbmi.sb_type, h, w, xd->bd);
    else
      build_compound_seg_mask(comp_data.seg_mask, comp_data.mask_type, dst,
                              dst_stride, tmp_dst, MAX_SB_SIZE,
                              mi->mbmi.sb_type, h, w);
  }
#endif  // CONFIG_COMPOUND_SEGMENT

#if CONFIG_SUPERTX
  if (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH)
    build_masked_compound_wedge_extend_highbd(
        dst, dst_stride, dst, dst_stride, tmp_dst, MAX_SB_SIZE, &comp_data,
        mi->mbmi.sb_type, wedge_offset_x, wedge_offset_y, h, w, xd->bd);
  else
    build_masked_compound_wedge_extend(
        dst, dst_stride, dst, dst_stride, tmp_dst, MAX_SB_SIZE, &comp_data,
        mi->mbmi.sb_type, wedge_offset_x, wedge_offset_y, h, w);
#else
  if (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH)
    build_masked_compound_highbd(dst, dst_stride, dst, dst_stride, tmp_dst,
                                 MAX_SB_SIZE, &comp_data, mi->mbmi.sb_type, h,
                                 w, xd->bd);
  else
    build_masked_compound(dst, dst_stride, dst, dst_stride, tmp_dst,
                          MAX_SB_SIZE, &comp_data, mi->mbmi.sb_type, h, w);
#endif  // CONFIG_SUPERTX

#else  // CONFIG_HIGHBITDEPTH
  DECLARE_ALIGNED(16, uint8_t, tmp_dst[MAX_SB_SQUARE]);
  av1_make_inter_predictor(pre, pre_stride, tmp_dst, MAX_SB_SIZE, subpel_x,
                           subpel_y, sf, w, h, &conv_params, tmp_ipf,
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                           warp_types, p_col, p_row, plane, ref,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
#if CONFIG_MOTION_VAR
                           0, 0,
#endif
                           xs, ys, xd);
#if CONFIG_COMPOUND_SEGMENT
  if (!plane && comp_data.interinter_compound_type == COMPOUND_SEG)
    build_compound_seg_mask(comp_data.seg_mask, comp_data.mask_type, dst,
                            dst_stride, tmp_dst, MAX_SB_SIZE, mi->mbmi.sb_type,
                            h, w);
#endif  // CONFIG_COMPOUND_SEGMENT
#if CONFIG_SUPERTX
  build_masked_compound_wedge_extend(dst, dst_stride, dst, dst_stride, tmp_dst,
                                     MAX_SB_SIZE, &comp_data, mi->mbmi.sb_type,
                                     wedge_offset_x, wedge_offset_y, h, w);
#else
  build_masked_compound(dst, dst_stride, dst, dst_stride, tmp_dst, MAX_SB_SIZE,
                        &comp_data, mi->mbmi.sb_type, h, w);
#endif  // CONFIG_SUPERTX
#endif  // CONFIG_HIGHBITDEPTH
#if CONFIG_COMPOUND_SEGMENT
  (void)plane;
#endif  // CONFIG_COMPOUND_SEGMENT
}
#endif  // CONFIG_EXT_INTER

// TODO(sarahparker) av1_highbd_build_inter_predictor and
// av1_build_inter_predictor should be combined with
// av1_make_inter_predictor
#if CONFIG_HIGHBITDEPTH
void av1_highbd_build_inter_predictor(
    const uint8_t *src, int src_stride, uint8_t *dst, int dst_stride,
    const MV *src_mv, const struct scale_factors *sf, int w, int h, int ref,
#if CONFIG_DUAL_FILTER
    const InterpFilter *interp_filter,
#else
    const InterpFilter interp_filter,
#endif
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
    const WarpTypesAllowed *warp_types, int p_col, int p_row,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
    int plane, enum mv_precision precision, int x, int y,
    const MACROBLOCKD *xd) {
  const int is_q4 = precision == MV_PRECISION_Q4;
  const MV mv_q4 = { is_q4 ? src_mv->row : src_mv->row * 2,
                     is_q4 ? src_mv->col : src_mv->col * 2 };
  MV32 mv = av1_scale_mv(&mv_q4, x, y, sf);
  const int subpel_x = mv.col & SUBPEL_MASK;
  const int subpel_y = mv.row & SUBPEL_MASK;
  ConvolveParams conv_params = get_conv_params(ref, plane);

  src += (mv.row >> SUBPEL_BITS) * src_stride + (mv.col >> SUBPEL_BITS);

  av1_make_inter_predictor(src, src_stride, dst, dst_stride, subpel_x, subpel_y,
                           sf, w, h, &conv_params, interp_filter,
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                           warp_types, p_col, p_row, plane, ref,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
#if CONFIG_MOTION_VAR
                           0, 0,
#endif
                           sf->x_step_q4, sf->y_step_q4, xd);
}
#endif  // CONFIG_HIGHBITDEPTH

void av1_build_inter_predictor(const uint8_t *src, int src_stride, uint8_t *dst,
                               int dst_stride, const MV *src_mv,
                               const struct scale_factors *sf, int w, int h,
                               ConvolveParams *conv_params,
#if CONFIG_DUAL_FILTER
                               const InterpFilter *interp_filter,
#else
                               const InterpFilter interp_filter,
#endif
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                               const WarpTypesAllowed *warp_types, int p_col,
                               int p_row, int plane, int ref,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                               enum mv_precision precision, int x, int y,
                               const MACROBLOCKD *xd) {
  const int is_q4 = precision == MV_PRECISION_Q4;
  const MV mv_q4 = { is_q4 ? src_mv->row : src_mv->row * 2,
                     is_q4 ? src_mv->col : src_mv->col * 2 };
  MV32 mv = av1_scale_mv(&mv_q4, x, y, sf);
  const int subpel_x = mv.col & SUBPEL_MASK;
  const int subpel_y = mv.row & SUBPEL_MASK;

  src += (mv.row >> SUBPEL_BITS) * src_stride + (mv.col >> SUBPEL_BITS);

  av1_make_inter_predictor(src, src_stride, dst, dst_stride, subpel_x, subpel_y,
                           sf, w, h, conv_params, interp_filter,
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                           warp_types, p_col, p_row, plane, ref,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
#if CONFIG_MOTION_VAR
                           0, 0,
#endif
                           sf->x_step_q4, sf->y_step_q4, xd);
}

typedef struct SubpelParams {
  int xs;
  int ys;
  int subpel_x;
  int subpel_y;
} SubpelParams;

void build_inter_predictors(const AV1_COMMON *cm, MACROBLOCKD *xd, int plane,
#if CONFIG_MOTION_VAR
                            int mi_col_offset, int mi_row_offset,
#endif  // CONFIG_MOTION_VAR
                            int block, int bw, int bh, int x, int y, int w,
                            int h,
#if CONFIG_SUPERTX && CONFIG_EXT_INTER
                            int wedge_offset_x, int wedge_offset_y,
#endif  // CONFIG_SUPERTX && CONFIG_EXT_INTER
                            int mi_x, int mi_y) {
  struct macroblockd_plane *const pd = &xd->plane[plane];
#if CONFIG_MOTION_VAR
  const MODE_INFO *mi = xd->mi[mi_col_offset + xd->mi_stride * mi_row_offset];
#else
  const MODE_INFO *mi = xd->mi[0];
#endif  // CONFIG_MOTION_VAR
  int is_compound = has_second_ref(&mi->mbmi);
  int ref;
#if CONFIG_INTRABC
  const int is_intrabc = is_intrabc_block(&mi->mbmi);
  assert(IMPLIES(is_intrabc, !is_compound));
#endif  // CONFIG_INTRABC
#if CONFIG_GLOBAL_MOTION
  int is_global[2] = { 0, 0 };
  for (ref = 0; ref < 1 + is_compound; ++ref) {
    WarpedMotionParams *const wm = &xd->global_motion[mi->mbmi.ref_frame[ref]];
    is_global[ref] = is_global_mv_block(mi, block, wm->wmtype);
  }
#endif  // CONFIG_GLOBAL_MOTION

#if CONFIG_CB4X4
  (void)block;
  (void)cm;
#endif

#if CONFIG_MOTION_VAR && (CONFIG_CHROMA_SUB8X8 || !CONFIG_CB4X4)
  const int build_for_obmc = !(mi_col_offset == 0 && mi_row_offset == 0);
#endif  // CONFIG_MOTION_VAR && (CONFIG_CHROMA_SUB8X8 || !CONFIG_CB4X4)

#if CONFIG_CHROMA_SUB8X8
  const BLOCK_SIZE bsize = mi->mbmi.sb_type;
  const int ss_x = pd->subsampling_x;
  const int ss_y = pd->subsampling_y;
  int sub8x8_inter = bsize < BLOCK_8X8 && (ss_x || ss_y);
  const int row_start = (block_size_high[bsize] == 4) && ss_y ? -1 : 0;
  const int col_start = (block_size_wide[bsize] == 4) && ss_x ? -1 : 0;

#if CONFIG_MOTION_VAR
  if (!build_for_obmc && sub8x8_inter) {
#else
  if (sub8x8_inter) {
#endif  // CONFIG_MOTION_VAR
    for (int row = row_start; row <= 0 && sub8x8_inter; ++row)
      for (int col = col_start; col <= 0; ++col)
        if (!is_inter_block(&xd->mi[row * xd->mi_stride + col]->mbmi))
          sub8x8_inter = 0;
  }

#if CONFIG_MOTION_VAR
  if (!build_for_obmc && sub8x8_inter) {
#else
  if (sub8x8_inter) {
#endif  // CONFIG_MOTION_VAR
    // block size
    const int b4_w = block_size_wide[bsize] >> ss_x;
    const int b4_h = block_size_high[bsize] >> ss_y;
    const BLOCK_SIZE plane_bsize = scale_chroma_bsize(bsize, ss_x, ss_y);
    const int b8_w = block_size_wide[plane_bsize] >> ss_x;
    const int b8_h = block_size_high[plane_bsize] >> ss_y;
    int idx, idy;

    const int x_base = x;
    const int y_base = y;

    const struct buf_2d orig_pred_buf[2] = { pd->pre[0], pd->pre[1] };

    int row = row_start;
    for (idy = 0; idy < b8_h; idy += b4_h) {
      int col = col_start;
      for (idx = 0; idx < b8_w; idx += b4_w) {
        MB_MODE_INFO *this_mbmi = &xd->mi[row * xd->mi_stride + col]->mbmi;
        is_compound = has_second_ref(this_mbmi);

        for (ref = 0; ref < 1 + is_compound; ++ref) {
          struct buf_2d *const dst_buf = &pd->dst;

          const RefBuffer *ref_buf =
              &cm->frame_refs[this_mbmi->ref_frame[ref] - LAST_FRAME];

          const int c_offset = (mi_x + MI_SIZE * col_start) >> ss_x;
          const int r_offset = (mi_y + MI_SIZE * row_start) >> ss_y;
          pd->pre[ref].buf0 =
              (plane == 1) ? ref_buf->buf->u_buffer : ref_buf->buf->v_buffer;
          pd->pre[ref].buf =
              pd->pre[ref].buf0 + scaled_buffer_offset(c_offset, r_offset,
                                                       ref_buf->buf->uv_stride,
                                                       &ref_buf->sf);
          pd->pre[ref].width = ref_buf->buf->uv_crop_width;
          pd->pre[ref].height = ref_buf->buf->uv_crop_height;
          pd->pre[ref].stride = ref_buf->buf->uv_stride;

#if CONFIG_INTRABC
          const struct scale_factors *const sf =
              is_intrabc ? &xd->sf_identity : &xd->block_refs[ref]->sf;
          struct buf_2d *const pre_buf = is_intrabc ? dst_buf : &pd->pre[ref];
#else
          const struct scale_factors *const sf = &xd->block_refs[ref]->sf;
          struct buf_2d *const pre_buf = &pd->pre[ref];
#endif  // CONFIG_INTRABC
          uint8_t *dst = dst_buf->buf;

          const MV mv = this_mbmi->mv[ref].as_mv;

          const MV mv_q4 = clamp_mv_to_umv_border_sb(
              xd, &mv, bw, bh, pd->subsampling_x, pd->subsampling_y);
          uint8_t *pre;
          MV32 scaled_mv;
          int xs, ys, subpel_x, subpel_y;
          const int is_scaled = av1_is_scaled(sf);
          ConvolveParams conv_params = get_conv_params(ref, plane);
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
          WarpTypesAllowed warp_types;
#if CONFIG_GLOBAL_MOTION
          warp_types.global_warp_allowed = is_global[ref];
#endif  // CONFIG_GLOBAL_MOTION
#if CONFIG_WARPED_MOTION
          warp_types.local_warp_allowed =
              this_mbmi->motion_mode == WARPED_CAUSAL;
#endif  // CONFIG_WARPED_MOTION
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION

          x = x_base + idx;
          y = y_base + idy;

          dst += dst_buf->stride * y + x;

          if (is_scaled) {
            pre =
                pre_buf->buf + scaled_buffer_offset(x, y, pre_buf->stride, sf);
            scaled_mv = av1_scale_mv(&mv_q4, mi_x + x, mi_y + y, sf);
            xs = sf->x_step_q4;
            ys = sf->y_step_q4;
          } else {
            pre = pre_buf->buf + y * pre_buf->stride + x;
            scaled_mv.row = mv_q4.row;
            scaled_mv.col = mv_q4.col;
            xs = ys = 16;
          }

          subpel_x = scaled_mv.col & SUBPEL_MASK;
          subpel_y = scaled_mv.row & SUBPEL_MASK;
          pre += (scaled_mv.row >> SUBPEL_BITS) * pre_buf->stride +
                 (scaled_mv.col >> SUBPEL_BITS);

#if CONFIG_EXT_INTER
          if (ref && is_masked_compound_type(mi->mbmi.interinter_compound_type))
            av1_make_masked_inter_predictor(
                pre, pre_buf->stride, dst, dst_buf->stride, subpel_x, subpel_y,
                sf, w, h, mi->mbmi.interp_filter, xs, ys,
#if CONFIG_SUPERTX
                wedge_offset_x, wedge_offset_y,
#endif  // CONFIG_SUPERTX
                plane,
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                &warp_types, (mi_x >> pd->subsampling_x) + x,
                (mi_y >> pd->subsampling_y) + y, ref,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                xd);
          else
#endif  // CONFIG_EXT_INTER
            av1_make_inter_predictor(
                pre, pre_buf->stride, dst, dst_buf->stride, subpel_x, subpel_y,
                sf, b4_w, b4_h, &conv_params, this_mbmi->interp_filter,
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                &warp_types, (mi_x >> pd->subsampling_x) + x,
                (mi_y >> pd->subsampling_y) + y, plane, ref,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
#if CONFIG_MOTION_VAR
                mi_col_offset, mi_row_offset,
#endif
                xs, ys, xd);
        }
        ++col;
      }
      ++row;
    }

    for (ref = 0; ref < 2; ++ref) pd->pre[ref] = orig_pred_buf[ref];
    return;
  }
#else
  (void)cm;
#endif  // CONFIG_CHROMA_SUB8X8

  {
    struct buf_2d *const dst_buf = &pd->dst;
    uint8_t *const dst = dst_buf->buf + dst_buf->stride * y + x;
    uint8_t *pre[2];
    MV32 scaled_mv[2];
    SubpelParams subpel_params[2];
#if CONFIG_CONVOLVE_ROUND
    DECLARE_ALIGNED(16, int32_t, tmp_dst[MAX_SB_SIZE * MAX_SB_SIZE]);
    av1_zero(tmp_dst);
#endif  // CONFIG_CONVOLVE_ROUND

    for (ref = 0; ref < 1 + is_compound; ++ref) {
#if CONFIG_INTRABC
      const struct scale_factors *const sf =
          is_intrabc ? &xd->sf_identity : &xd->block_refs[ref]->sf;
      struct buf_2d *const pre_buf = is_intrabc ? dst_buf : &pd->pre[ref];
#else
      const struct scale_factors *const sf = &xd->block_refs[ref]->sf;
      struct buf_2d *const pre_buf = &pd->pre[ref];
#endif  // CONFIG_INTRABC
#if CONFIG_CB4X4
      const MV mv = mi->mbmi.mv[ref].as_mv;
#else
      const MV mv =
#if CONFIG_MOTION_VAR
          (mi->mbmi.sb_type < BLOCK_8X8 && !build_for_obmc)
              ?
#else
          mi->mbmi.sb_type < BLOCK_8X8 ?
#endif
              average_split_mvs(pd, mi, ref, block)
              : mi->mbmi.mv[ref].as_mv;
#endif

      // TODO(jkoleszar): This clamping is done in the incorrect place for the
      // scaling case. It needs to be done on the scaled MV, not the pre-scaling
      // MV. Note however that it performs the subsampling aware scaling so
      // that the result is always q4.
      // mv_precision precision is MV_PRECISION_Q4.
      const MV mv_q4 = clamp_mv_to_umv_border_sb(
          xd, &mv, bw, bh, pd->subsampling_x, pd->subsampling_y);

      const int is_scaled = av1_is_scaled(sf);
      if (is_scaled) {
        pre[ref] =
            pre_buf->buf + scaled_buffer_offset(x, y, pre_buf->stride, sf);
        scaled_mv[ref] = av1_scale_mv(&mv_q4, mi_x + x, mi_y + y, sf);
        subpel_params[ref].xs = sf->x_step_q4;
        subpel_params[ref].ys = sf->y_step_q4;
      } else {
        pre[ref] = pre_buf->buf + (y * pre_buf->stride + x);
        scaled_mv[ref].row = mv_q4.row;
        scaled_mv[ref].col = mv_q4.col;
        subpel_params[ref].xs = 16;
        subpel_params[ref].ys = 16;
      }

      subpel_params[ref].subpel_x = scaled_mv[ref].col & SUBPEL_MASK;
      subpel_params[ref].subpel_y = scaled_mv[ref].row & SUBPEL_MASK;
      pre[ref] += (scaled_mv[ref].row >> SUBPEL_BITS) * pre_buf->stride +
                  (scaled_mv[ref].col >> SUBPEL_BITS);
    }

#if CONFIG_CONVOLVE_ROUND
    ConvolveParams conv_params =
        get_conv_params_no_round(ref, plane, tmp_dst, MAX_SB_SIZE);
#else
    ConvolveParams conv_params = get_conv_params(ref, plane);
#endif  // CONFIG_CONVOLVE_ROUND
    for (ref = 0; ref < 1 + is_compound; ++ref) {
#if CONFIG_INTRABC
      const struct scale_factors *const sf =
          is_intrabc ? &xd->sf_identity : &xd->block_refs[ref]->sf;
      struct buf_2d *const pre_buf = is_intrabc ? dst_buf : &pd->pre[ref];
#else
      const struct scale_factors *const sf = &xd->block_refs[ref]->sf;
      struct buf_2d *const pre_buf = &pd->pre[ref];
#endif  // CONFIG_INTRABC
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
      WarpTypesAllowed warp_types;
#if CONFIG_GLOBAL_MOTION
      warp_types.global_warp_allowed = is_global[ref];
#endif  // CONFIG_GLOBAL_MOTION
#if CONFIG_WARPED_MOTION
      warp_types.local_warp_allowed = mi->mbmi.motion_mode == WARPED_CAUSAL;
#endif  // CONFIG_WARPED_MOTION
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
      conv_params.ref = ref;
#if CONFIG_EXT_INTER
      if (ref && is_masked_compound_type(mi->mbmi.interinter_compound_type))
        av1_make_masked_inter_predictor(
            pre[ref], pre_buf->stride, dst, dst_buf->stride,
            subpel_params[ref].subpel_x, subpel_params[ref].subpel_y, sf, w, h,
            mi->mbmi.interp_filter, subpel_params[ref].xs,
            subpel_params[ref].ys,
#if CONFIG_SUPERTX
            wedge_offset_x, wedge_offset_y,
#endif  // CONFIG_SUPERTX
            plane,
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
            &warp_types, (mi_x >> pd->subsampling_x) + x,
            (mi_y >> pd->subsampling_y) + y, ref,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
            xd);
      else
#endif  // CONFIG_EXT_INTER
        av1_make_inter_predictor(
            pre[ref], pre_buf->stride, dst, dst_buf->stride,
            subpel_params[ref].subpel_x, subpel_params[ref].subpel_y, sf, w, h,
            &conv_params, mi->mbmi.interp_filter,
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
            &warp_types, (mi_x >> pd->subsampling_x) + x,
            (mi_y >> pd->subsampling_y) + y, plane, ref,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
#if CONFIG_MOTION_VAR
            mi_col_offset, mi_row_offset,
#endif
            subpel_params[ref].xs, subpel_params[ref].ys, xd);
    }

#if CONFIG_CONVOLVE_ROUND
    // TODO(angiebird): This part needs optimization
    if (conv_params.do_post_rounding) {
#if CONFIG_HIGHBITDEPTH
      if (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH)
        av1_highbd_convolve_rounding(tmp_dst, MAX_SB_SIZE, dst, dst_buf->stride,
                                     w, h, FILTER_BITS * 2 + is_compound -
                                               conv_params.round_0 -
                                               conv_params.round_1,
                                     xd->bd);
      else
#endif  // CONFIG_HIGHBITDEPTH
        av1_convolve_rounding(tmp_dst, MAX_SB_SIZE, dst, dst_buf->stride, w, h,
                              FILTER_BITS * 2 + is_compound -
                                  conv_params.round_0 - conv_params.round_1);
    }
#endif  // CONFIG_CONVOLVE_ROUND
  }
}

void av1_build_inter_predictor_sub8x8(const AV1_COMMON *cm, MACROBLOCKD *xd,
                                      int plane, int i, int ir, int ic,
                                      int mi_row, int mi_col) {
  struct macroblockd_plane *const pd = &xd->plane[plane];
  MODE_INFO *const mi = xd->mi[0];
  const BLOCK_SIZE plane_bsize = get_plane_block_size(mi->mbmi.sb_type, pd);
  const int width = block_size_wide[plane_bsize];
  const int height = block_size_high[plane_bsize];
  uint8_t *const dst = &pd->dst.buf[(ir * pd->dst.stride + ic) << 2];
  int ref;
  const int is_compound = has_second_ref(&mi->mbmi);
  (void)cm;

#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
  WarpTypesAllowed warp_types;
  const int p_col = ((mi_col * MI_SIZE) >> pd->subsampling_x) + 4 * ic;
  const int p_row = ((mi_row * MI_SIZE) >> pd->subsampling_y) + 4 * ir;
#if CONFIG_GLOBAL_MOTION
  int is_global[2];
  for (ref = 0; ref < 1 + is_compound; ++ref) {
    WarpedMotionParams *const wm = &xd->global_motion[mi->mbmi.ref_frame[ref]];
    is_global[ref] = is_global_mv_block(mi, i, wm->wmtype);
  }
#endif  // CONFIG_GLOBAL_MOTION
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION

  for (ref = 0; ref < 1 + is_compound; ++ref) {
    ConvolveParams conv_params = get_conv_params(ref, plane);
    const uint8_t *pre =
        &pd->pre[ref].buf[(ir * pd->pre[ref].stride + ic) << 2];
#if CONFIG_GLOBAL_MOTION
    warp_types.global_warp_allowed = is_global[ref];
#endif  // CONFIG_GLOBAL_MOTION
#if CONFIG_WARPED_MOTION
    warp_types.local_warp_allowed = mi->mbmi.motion_mode == WARPED_CAUSAL;
#endif  // CONFIG_WARPED_MOTION

#if CONFIG_HIGHBITDEPTH
    if (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH)
      av1_highbd_build_inter_predictor(
          pre, pd->pre[ref].stride, dst, pd->dst.stride,
          &mi->bmi[i].as_mv[ref].as_mv, &xd->block_refs[ref]->sf, width, height,
          ref, mi->mbmi.interp_filter,
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
          &warp_types, p_col, p_row,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
          plane, MV_PRECISION_Q3, mi_col * MI_SIZE + 4 * ic,
          mi_row * MI_SIZE + 4 * ir, xd);
    else
#endif  // CONFIG_HIGHBITDEPTH
      av1_build_inter_predictor(pre, pd->pre[ref].stride, dst, pd->dst.stride,
                                &mi->bmi[i].as_mv[ref].as_mv,
                                &xd->block_refs[ref]->sf, width, height,
                                &conv_params, mi->mbmi.interp_filter,
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                                &warp_types, p_col, p_row, plane, ref,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                                MV_PRECISION_Q3, mi_col * MI_SIZE + 4 * ic,
                                mi_row * MI_SIZE + 4 * ir, xd);
  }
}

static void build_inter_predictors_for_planes(const AV1_COMMON *cm,
                                              MACROBLOCKD *xd, BLOCK_SIZE bsize,
                                              int mi_row, int mi_col,
                                              int plane_from, int plane_to) {
  int plane;
  const int mi_x = mi_col * MI_SIZE;
  const int mi_y = mi_row * MI_SIZE;
#if CONFIG_CB4X4
  const int unify_bsize = 1;
#else
  const int unify_bsize = 0;
#endif
  for (plane = plane_from; plane <= plane_to; ++plane) {
    const struct macroblockd_plane *pd = &xd->plane[plane];
    const int bw = pd->width;
    const int bh = pd->height;

#if CONFIG_CB4X4
    if (!is_chroma_reference(mi_row, mi_col, bsize, pd->subsampling_x,
                             pd->subsampling_y))
      continue;
#endif

    if (xd->mi[0]->mbmi.sb_type < BLOCK_8X8 && !unify_bsize) {
      const PARTITION_TYPE bp = bsize - xd->mi[0]->mbmi.sb_type;
      const int have_vsplit = bp != PARTITION_HORZ;
      const int have_hsplit = bp != PARTITION_VERT;
      const int num_4x4_w = 2 >> ((!have_vsplit) | pd->subsampling_x);
      const int num_4x4_h = 2 >> ((!have_hsplit) | pd->subsampling_y);
      const int pw = 8 >> (have_vsplit | pd->subsampling_x);
      const int ph = 8 >> (have_hsplit | pd->subsampling_y);
      int x, y;
      assert(bp != PARTITION_NONE && bp < PARTITION_TYPES);
      assert(bsize == BLOCK_8X8);
      assert(pw * num_4x4_w == bw && ph * num_4x4_h == bh);
      for (y = 0; y < num_4x4_h; ++y)
        for (x = 0; x < num_4x4_w; ++x)
          build_inter_predictors(cm, xd, plane,
#if CONFIG_MOTION_VAR
                                 0, 0,
#endif  // CONFIG_MOTION_VAR
                                 y * 2 + x, bw, bh, 4 * x, 4 * y, pw, ph,
#if CONFIG_SUPERTX && CONFIG_EXT_INTER
                                 0, 0,
#endif  // CONFIG_SUPERTX && CONFIG_EXT_INTER
                                 mi_x, mi_y);
    } else {
      build_inter_predictors(cm, xd, plane,
#if CONFIG_MOTION_VAR
                             0, 0,
#endif  // CONFIG_MOTION_VAR
                             0, bw, bh, 0, 0, bw, bh,
#if CONFIG_SUPERTX && CONFIG_EXT_INTER
                             0, 0,
#endif  // CONFIG_SUPERTX && CONFIG_EXT_INTER
                             mi_x, mi_y);
    }
  }
}

void av1_build_inter_predictors_sby(const AV1_COMMON *cm, MACROBLOCKD *xd,
                                    int mi_row, int mi_col, BUFFER_SET *ctx,
                                    BLOCK_SIZE bsize) {
  build_inter_predictors_for_planes(cm, xd, bsize, mi_row, mi_col, 0, 0);
#if CONFIG_EXT_INTER && CONFIG_INTERINTRA
  if (is_interintra_pred(&xd->mi[0]->mbmi)) {
    BUFFER_SET default_ctx = { { xd->plane[0].dst.buf, NULL, NULL },
                               { xd->plane[0].dst.stride, 0, 0 } };
    if (!ctx) ctx = &default_ctx;
    av1_build_interintra_predictors_sby(xd, xd->plane[0].dst.buf,
                                        xd->plane[0].dst.stride, ctx, bsize);
  }
#else
  (void)ctx;
#endif  // CONFIG_EXT_INTER && CONFIG_INTERINTRA
}

void av1_build_inter_predictors_sbuv(const AV1_COMMON *cm, MACROBLOCKD *xd,
                                     int mi_row, int mi_col, BUFFER_SET *ctx,
                                     BLOCK_SIZE bsize) {
  build_inter_predictors_for_planes(cm, xd, bsize, mi_row, mi_col, 1,
                                    MAX_MB_PLANE - 1);
#if CONFIG_EXT_INTER && CONFIG_INTERINTRA
  if (is_interintra_pred(&xd->mi[0]->mbmi)) {
    BUFFER_SET default_ctx = {
      { NULL, xd->plane[1].dst.buf, xd->plane[2].dst.buf },
      { 0, xd->plane[1].dst.stride, xd->plane[2].dst.stride }
    };
    if (!ctx) ctx = &default_ctx;
    av1_build_interintra_predictors_sbuv(
        xd, xd->plane[1].dst.buf, xd->plane[2].dst.buf, xd->plane[1].dst.stride,
        xd->plane[2].dst.stride, ctx, bsize);
  }
#else
  (void)ctx;
#endif  // CONFIG_EXT_INTER && CONFIG_INTERINTRA
}

// TODO(afergs): Check if ctx can be made constant
void av1_build_inter_predictors_sb(const AV1_COMMON *cm, MACROBLOCKD *xd,
                                   int mi_row, int mi_col, BUFFER_SET *ctx,
                                   BLOCK_SIZE bsize) {
  build_inter_predictors_for_planes(cm, xd, bsize, mi_row, mi_col, 0,
                                    MAX_MB_PLANE - 1);
#if CONFIG_EXT_INTER && CONFIG_INTERINTRA
  if (is_interintra_pred(&xd->mi[0]->mbmi)) {
    BUFFER_SET default_ctx = {
      { xd->plane[0].dst.buf, xd->plane[1].dst.buf, xd->plane[2].dst.buf },
      { xd->plane[0].dst.stride, xd->plane[1].dst.stride,
        xd->plane[2].dst.stride }
    };
    if (!ctx) ctx = &default_ctx;
    av1_build_interintra_predictors(
        xd, xd->plane[0].dst.buf, xd->plane[1].dst.buf, xd->plane[2].dst.buf,
        xd->plane[0].dst.stride, xd->plane[1].dst.stride,
        xd->plane[2].dst.stride, ctx, bsize);
  }
#else
  (void)ctx;
#endif  // CONFIG_EXT_INTER && CONFIG_INTERINTRA
}

void av1_setup_dst_planes(struct macroblockd_plane planes[MAX_MB_PLANE],
                          BLOCK_SIZE bsize, const YV12_BUFFER_CONFIG *src,
                          int mi_row, int mi_col) {
  uint8_t *const buffers[MAX_MB_PLANE] = { src->y_buffer, src->u_buffer,
                                           src->v_buffer };
  const int widths[MAX_MB_PLANE] = { src->y_crop_width, src->uv_crop_width,
                                     src->uv_crop_width };
  const int heights[MAX_MB_PLANE] = { src->y_crop_height, src->uv_crop_height,
                                      src->uv_crop_height };
  const int strides[MAX_MB_PLANE] = { src->y_stride, src->uv_stride,
                                      src->uv_stride };
  int i;

  for (i = 0; i < MAX_MB_PLANE; ++i) {
    struct macroblockd_plane *const pd = &planes[i];
    setup_pred_plane(&pd->dst, bsize, buffers[i], widths[i], heights[i],
                     strides[i], mi_row, mi_col, NULL, pd->subsampling_x,
                     pd->subsampling_y);
  }
}

void av1_setup_pre_planes(MACROBLOCKD *xd, int idx,
                          const YV12_BUFFER_CONFIG *src, int mi_row, int mi_col,
                          const struct scale_factors *sf) {
  if (src != NULL) {
    int i;
    uint8_t *const buffers[MAX_MB_PLANE] = { src->y_buffer, src->u_buffer,
                                             src->v_buffer };
    const int widths[MAX_MB_PLANE] = { src->y_crop_width, src->uv_crop_width,
                                       src->uv_crop_width };
    const int heights[MAX_MB_PLANE] = { src->y_crop_height, src->uv_crop_height,
                                        src->uv_crop_height };
    const int strides[MAX_MB_PLANE] = { src->y_stride, src->uv_stride,
                                        src->uv_stride };
    for (i = 0; i < MAX_MB_PLANE; ++i) {
      struct macroblockd_plane *const pd = &xd->plane[i];
      setup_pred_plane(&pd->pre[idx], xd->mi[0]->mbmi.sb_type, buffers[i],
                       widths[i], heights[i], strides[i], mi_row, mi_col, sf,
                       pd->subsampling_x, pd->subsampling_y);
    }
  }
}

#if CONFIG_SUPERTX
#if CONFIG_CB4X4
static const uint8_t mask_4[4] = { 64, 52, 12, 0 };
static const uint8_t mask_4_uv[4] = { 64, 52, 12, 0 };
#endif  // CONFIG_CB4X4
static const uint8_t mask_8[8] = { 64, 64, 62, 52, 12, 2, 0, 0 };

static const uint8_t mask_16[16] = { 63, 62, 60, 58, 55, 50, 43, 36,
                                     28, 21, 14, 9,  6,  4,  2,  1 };

static const uint8_t mask_32[32] = { 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 63,
                                     61, 57, 52, 45, 36, 28, 19, 12, 7,  3,  1,
                                     0,  0,  0,  0,  0,  0,  0,  0,  0,  0 };

static const uint8_t mask_8_uv[8] = { 64, 64, 62, 52, 12, 2, 0, 0 };

static const uint8_t mask_16_uv[16] = { 64, 64, 64, 64, 61, 53, 45, 36,
                                        28, 19, 11, 3,  0,  0,  0,  0 };

static const uint8_t mask_32_uv[32] = { 64, 64, 64, 64, 64, 64, 64, 64,
                                        64, 64, 64, 64, 60, 54, 46, 36,
                                        28, 18, 10, 4,  0,  0,  0,  0,
                                        0,  0,  0,  0,  0,  0,  0,  0 };

static const uint8_t *get_supertx_mask(int length, int plane) {
  switch (length) {
#if CONFIG_CB4X4
    case 4: return plane ? mask_4_uv : mask_4;
#endif  // CONFIG_CB4X4
    case 8: return plane ? mask_8_uv : mask_8;
    case 16: return plane ? mask_16_uv : mask_16;
    case 32: return plane ? mask_32_uv : mask_32;
    default: assert(0);
  }
  return NULL;
}

void av1_build_masked_inter_predictor_complex(
    MACROBLOCKD *xd, uint8_t *dst, int dst_stride, const uint8_t *pre,
    int pre_stride, int mi_row, int mi_col, int mi_row_ori, int mi_col_ori,
    BLOCK_SIZE bsize, BLOCK_SIZE top_bsize, PARTITION_TYPE partition,
    int plane) {
  const struct macroblockd_plane *pd = &xd->plane[plane];
  const int ssx = pd->subsampling_x;
  const int ssy = pd->subsampling_y;
  const int top_w = block_size_wide[top_bsize] >> ssx;
  const int top_h = block_size_high[top_bsize] >> ssy;
  const int w = block_size_wide[bsize] >> ssx;
  const int h = block_size_high[bsize] >> ssy;
  const int w_offset = ((mi_col - mi_col_ori) * MI_SIZE) >> ssx;
  const int h_offset = ((mi_row - mi_row_ori) * MI_SIZE) >> ssy;

  int w_remain, h_remain;

#if CONFIG_HIGHBITDEPTH
  const int is_hdb = (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH) ? 1 : 0;
#endif  // CONFIG_HIGHBITDEPTH

  assert(bsize <= BLOCK_32X32);
  assert(IMPLIES(plane == 0, ssx == 0));
  assert(IMPLIES(plane == 0, ssy == 0));

  switch (partition) {
    case PARTITION_HORZ: {
      const uint8_t *const mask = get_supertx_mask(h, ssy);

      w_remain = top_w;
      h_remain = top_h - h_offset - h;
      dst += h_offset * dst_stride;
      pre += h_offset * pre_stride;

#if CONFIG_HIGHBITDEPTH
      if (is_hdb)
        aom_highbd_blend_a64_vmask(dst, dst_stride, dst, dst_stride, pre,
                                   pre_stride, mask, h, top_w, xd->bd);
      else
#endif  // CONFIG_HIGHBITDEPTH
        aom_blend_a64_vmask(dst, dst_stride, dst, dst_stride, pre, pre_stride,
                            mask, h, top_w);

      dst += h * dst_stride;
      pre += h * pre_stride;
      break;
    }
    case PARTITION_VERT: {
      const uint8_t *const mask = get_supertx_mask(w, ssx);

      w_remain = top_w - w_offset - w;
      h_remain = top_h;
      dst += w_offset;
      pre += w_offset;

#if CONFIG_HIGHBITDEPTH
      if (is_hdb)
        aom_highbd_blend_a64_hmask(dst, dst_stride, dst, dst_stride, pre,
                                   pre_stride, mask, top_h, w, xd->bd);
      else
#endif  // CONFIG_HIGHBITDEPTH
        aom_blend_a64_hmask(dst, dst_stride, dst, dst_stride, pre, pre_stride,
                            mask, top_h, w);

      dst += w;
      pre += w;
      break;
    }
    default: {
      assert(0);
      return;
    }
  }

  if (w_remain == 0 || h_remain == 0) {
    return;
  }

#if CONFIG_HIGHBITDEPTH
  if (is_hdb) {
    dst = (uint8_t *)CONVERT_TO_SHORTPTR(dst);
    pre = (const uint8_t *)CONVERT_TO_SHORTPTR(pre);
    dst_stride *= 2;
    pre_stride *= 2;
    w_remain *= 2;
  }
#endif  // CONFIG_HIGHBITDEPTH

  do {
    memcpy(dst, pre, w_remain * sizeof(uint8_t));
    dst += dst_stride;
    pre += pre_stride;
  } while (--h_remain);
}

void av1_build_inter_predictors_sb_sub8x8_extend(const AV1_COMMON *cm,
                                                 MACROBLOCKD *xd,
#if CONFIG_EXT_INTER
                                                 int mi_row_ori, int mi_col_ori,
#endif  // CONFIG_EXT_INTER
                                                 int mi_row, int mi_col,
                                                 BLOCK_SIZE bsize, int block) {
  // Prediction function used in supertx:
  // Use the mv at current block (which is less than 8x8)
  // to get prediction of a block located at (mi_row, mi_col) at size of bsize
  // bsize can be larger than 8x8.
  // block (0-3): the sub8x8 location of current block
  int plane;
  const int mi_x = mi_col * MI_SIZE;
  const int mi_y = mi_row * MI_SIZE;
#if CONFIG_EXT_INTER
  const int wedge_offset_x = (mi_col_ori - mi_col) * MI_SIZE;
  const int wedge_offset_y = (mi_row_ori - mi_row) * MI_SIZE;
#endif  // CONFIG_EXT_INTER

  // For sub8x8 uv:
  // Skip uv prediction in supertx except the first block (block = 0)
  int max_plane = block ? 1 : MAX_MB_PLANE;

  for (plane = 0; plane < max_plane; plane++) {
    const BLOCK_SIZE plane_bsize =
        get_plane_block_size(bsize, &xd->plane[plane]);
    const int num_4x4_w = num_4x4_blocks_wide_lookup[plane_bsize];
    const int num_4x4_h = num_4x4_blocks_high_lookup[plane_bsize];
    const int bw = 4 * num_4x4_w;
    const int bh = 4 * num_4x4_h;

    build_inter_predictors(cm, xd, plane,
#if CONFIG_MOTION_VAR
                           0, 0,
#endif  // CONFIG_MOTION_VAR
                           block, bw, bh, 0, 0, bw, bh,
#if CONFIG_EXT_INTER
                           wedge_offset_x, wedge_offset_y,
#endif  // CONFIG_EXT_INTER
                           mi_x, mi_y);
  }
#if CONFIG_EXT_INTER
  if (is_interintra_pred(&xd->mi[0]->mbmi)) {
    BUFFER_SET ctx = { { xd->plane[0].dst.buf, xd->plane[1].dst.buf,
                         xd->plane[2].dst.buf },
                       { xd->plane[0].dst.stride, xd->plane[1].dst.stride,
                         xd->plane[2].dst.stride } };
    av1_build_interintra_predictors(
        xd, xd->plane[0].dst.buf, xd->plane[1].dst.buf, xd->plane[2].dst.buf,
        xd->plane[0].dst.stride, xd->plane[1].dst.stride,
        xd->plane[2].dst.stride, &ctx, bsize);
  }
#endif  // CONFIG_EXT_INTER
}

void av1_build_inter_predictors_sb_extend(const AV1_COMMON *cm, MACROBLOCKD *xd,
#if CONFIG_EXT_INTER
                                          int mi_row_ori, int mi_col_ori,
#endif  // CONFIG_EXT_INTER
                                          int mi_row, int mi_col,
                                          BLOCK_SIZE bsize) {
  int plane;
  const int mi_x = mi_col * MI_SIZE;
  const int mi_y = mi_row * MI_SIZE;
#if CONFIG_EXT_INTER
  const int wedge_offset_x = (mi_col_ori - mi_col) * MI_SIZE;
  const int wedge_offset_y = (mi_row_ori - mi_row) * MI_SIZE;
#endif  // CONFIG_EXT_INTER
  for (plane = 0; plane < MAX_MB_PLANE; ++plane) {
    const BLOCK_SIZE plane_bsize =
        get_plane_block_size(bsize, &xd->plane[plane]);
    const int bw = block_size_wide[plane_bsize];
    const int bh = block_size_high[plane_bsize];

    build_inter_predictors(cm, xd, plane,
#if CONFIG_MOTION_VAR
                           0, 0,
#endif  // CONFIG_MOTION_VAR
                           0, bw, bh, 0, 0, bw, bh,
#if CONFIG_EXT_INTER
                           wedge_offset_x, wedge_offset_y,
#endif  // CONFIG_EXT_INTER
                           mi_x, mi_y);
  }
}
#endif  // CONFIG_SUPERTX

#if CONFIG_MOTION_VAR
// obmc_mask_N[overlap_position]
static const uint8_t obmc_mask_1[1] = { 64 };

static const uint8_t obmc_mask_2[2] = { 45, 64 };

static const uint8_t obmc_mask_4[4] = { 39, 50, 59, 64 };

static const uint8_t obmc_mask_8[8] = { 36, 42, 48, 53, 57, 61, 64, 64 };

static const uint8_t obmc_mask_16[16] = { 34, 37, 40, 43, 46, 49, 52, 54,
                                          56, 58, 60, 61, 64, 64, 64, 64 };

static const uint8_t obmc_mask_32[32] = { 33, 35, 36, 38, 40, 41, 43, 44,
                                          45, 47, 48, 50, 51, 52, 53, 55,
                                          56, 57, 58, 59, 60, 60, 61, 62,
                                          64, 64, 64, 64, 64, 64, 64, 64 };

#if CONFIG_EXT_PARTITION
static const uint8_t obmc_mask_64[64] = {
  33, 34, 35, 35, 36, 37, 38, 39, 40, 40, 41, 42, 43, 44, 44, 44,
  45, 46, 47, 47, 48, 49, 50, 51, 51, 51, 52, 52, 53, 54, 55, 56,
  56, 56, 57, 57, 58, 58, 59, 60, 60, 60, 60, 60, 61, 62, 62, 62,
  62, 62, 63, 63, 63, 63, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
};
#endif  // CONFIG_EXT_PARTITION

const uint8_t *av1_get_obmc_mask(int length) {
  switch (length) {
    case 1: return obmc_mask_1;
    case 2: return obmc_mask_2;
    case 4: return obmc_mask_4;
    case 8: return obmc_mask_8;
    case 16: return obmc_mask_16;
    case 32: return obmc_mask_32;
#if CONFIG_EXT_PARTITION
    case 64: return obmc_mask_64;
#endif  // CONFIG_EXT_PARTITION
    default: assert(0); return NULL;
  }
}

#if CONFIG_NCOBMC
// obmc_mask_flipN[overlap_position]
static const uint8_t obmc_mask_flip1[1] = { 55 };

static const uint8_t obmc_mask_flip2[2] = { 62, 45 };

static const uint8_t obmc_mask_flip4[4] = { 64, 59, 50, 39 };

static const uint8_t obmc_mask_flip8[8] = { 64, 63, 61, 57, 53, 48, 42, 36 };

static const uint8_t obmc_mask_flip16[16] = { 64, 64, 64, 63, 61, 60, 58, 56,
                                              54, 52, 49, 46, 43, 40, 37, 34 };

static const uint8_t obmc_mask_flip32[32] = { 64, 64, 64, 64, 64, 63, 63, 62,
                                              62, 61, 60, 60, 59, 58, 57, 56,
                                              55, 53, 52, 51, 50, 48, 47, 45,
                                              44, 43, 41, 40, 38, 36, 35, 33 };

#if CONFIG_EXT_PARTITION
static const uint8_t obmc_mask_flip64[64] = {
  64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 63, 63, 63, 63, 62, 62,
  62, 62, 62, 61, 60, 60, 60, 60, 60, 59, 58, 58, 57, 57, 56, 56,
  56, 55, 54, 53, 52, 52, 51, 51, 51, 50, 49, 48, 47, 47, 46, 45,
  44, 44, 44, 43, 42, 41, 40, 40, 39, 38, 37, 36, 35, 35, 34, 33,
};
#endif  // CONFIG_EXT_PARTITION

const uint8_t *av1_get_obmc_mask_flipped(int length) {
  switch (length) {
    case 1: return obmc_mask_flip1;
    case 2: return obmc_mask_flip2;
    case 4: return obmc_mask_flip4;
    case 8: return obmc_mask_flip8;
    case 16: return obmc_mask_flip16;
    case 32: return obmc_mask_flip32;
#if CONFIG_EXT_PARTITION
    case 64: return obmc_mask_flip64;
#endif  // CONFIG_EXT_PARTITION
    default: assert(0); return NULL;
  }
}
#endif  // CONFIG_NCOBMC

void av1_count_overlappable_neighbors(const AV1_COMMON *cm, MACROBLOCKD *xd,
                                      int mi_row, int mi_col) {
  int i, mi_step;
  MB_MODE_INFO *mbmi = &xd->mi[0]->mbmi;

  xd->mi[0]->mbmi.overlappable_neighbors[0] = 0;
  xd->mi[0]->mbmi.overlappable_neighbors[1] = 0;

  if (!is_motion_variation_allowed_bsize(mbmi->sb_type)) return;

  if (xd->up_available) {
    const int ilimit = AOMMIN(xd->n8_w, cm->mi_cols - mi_col);
    for (i = 0; i < ilimit; i += mi_step) {
      int mi_row_offset = -1;
      int mi_col_offset = i;
      MODE_INFO *above_mi =
          xd->mi[mi_col_offset + mi_row_offset * xd->mi_stride];
      MB_MODE_INFO *above_mbmi = &above_mi->mbmi;
#if CONFIG_CHROMA_SUB8X8
      if (above_mbmi->sb_type < BLOCK_8X8) {
        ++mi_col_offset;
        above_mbmi =
            &xd->mi[mi_col_offset + mi_row_offset * xd->mi_stride]->mbmi;
      }
#endif
      BLOCK_SIZE above_bsize = AOMMAX(above_mbmi->sb_type, BLOCK_8X8);
      mi_step = AOMMIN(xd->n8_w, mi_size_wide[above_bsize]);

      if (is_neighbor_overlappable(above_mbmi))
        xd->mi[0]->mbmi.overlappable_neighbors[0]++;
    }
  }

  if (xd->left_available) {
    const int ilimit = AOMMIN(xd->n8_h, cm->mi_rows - mi_row);
    for (i = 0; i < ilimit; i += mi_step) {
      int mi_row_offset = i;
      int mi_col_offset = -1;
      MODE_INFO *left_mi =
          xd->mi[mi_col_offset + mi_row_offset * xd->mi_stride];
      MB_MODE_INFO *left_mbmi = &left_mi->mbmi;

#if CONFIG_CHROMA_SUB8X8
      if (left_mbmi->sb_type < BLOCK_8X8) {
        ++mi_row_offset;
        left_mbmi =
            &xd->mi[mi_col_offset + mi_row_offset * xd->mi_stride]->mbmi;
      }
#endif
      BLOCK_SIZE left_bsize = AOMMAX(left_mbmi->sb_type, BLOCK_8X8);
      mi_step = AOMMIN(xd->n8_h, mi_size_high[left_bsize]);

      if (is_neighbor_overlappable(left_mbmi))
        xd->mi[0]->mbmi.overlappable_neighbors[1]++;
    }
  }
}

// HW does not support < 4x4 prediction. To limit the bandwidth requirement, for
// small blocks, only blend with neighbors from one side. If block-size of
// current plane is 4x4 or 8x4, the above neighbor (dir = 0) will be skipped. If
// it is 4x8, the left neighbor (dir = 1) will be skipped.
#define DISABLE_CHROMA_U8X8_OBMC 0  // 0: one-sided obmc; 1: disable

int skip_u4x4_pred_in_obmc(BLOCK_SIZE bsize, const struct macroblockd_plane *pd,
                           int dir) {
  assert(is_motion_variation_allowed_bsize(bsize));

  BLOCK_SIZE bsize_plane =
      ss_size_lookup[bsize][pd->subsampling_x][pd->subsampling_y];
#if CONFIG_CB4X4
  if (bsize_plane < BLOCK_4X4) return 1;
#endif
  switch (bsize_plane) {
#if DISABLE_CHROMA_U8X8_OBMC
    case BLOCK_4X4:
    case BLOCK_8X4:
    case BLOCK_4X8: return 1; break;
#else
    case BLOCK_4X4:
    case BLOCK_8X4:
    case BLOCK_4X8: return dir == 0; break;
#endif
    default: return 0;
  }
}

// This function combines motion compensated predictions that is generated by
// top/left neighboring blocks' inter predictors with the regular inter
// prediction. We assume the original prediction (bmc) is stored in
// xd->plane[].dst.buf
void av1_build_obmc_inter_prediction(const AV1_COMMON *cm, MACROBLOCKD *xd,
                                     int mi_row, int mi_col,
                                     uint8_t *above[MAX_MB_PLANE],
                                     int above_stride[MAX_MB_PLANE],
                                     uint8_t *left[MAX_MB_PLANE],
                                     int left_stride[MAX_MB_PLANE]) {
  const BLOCK_SIZE bsize = xd->mi[0]->mbmi.sb_type;
  int plane, i;
#if CONFIG_HIGHBITDEPTH
  const int is_hbd = (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH) ? 1 : 0;
#endif  // CONFIG_HIGHBITDEPTH

  // handle above row
  if (xd->up_available) {
    const int overlap = num_4x4_blocks_high_lookup[bsize] * 2;
    const int miw = AOMMIN(xd->n8_w, cm->mi_cols - mi_col);
    const int mi_row_offset = -1;
    const int neighbor_limit = max_neighbor_obmc[b_width_log2_lookup[bsize]];
    int neighbor_count = 0;

    assert(miw > 0);

    i = 0;
    do {  // for each mi in the above row
      int mi_col_offset = i;
      MB_MODE_INFO *above_mbmi =
          &xd->mi[mi_col_offset + mi_row_offset * xd->mi_stride]->mbmi;
#if CONFIG_CHROMA_SUB8X8
      if (above_mbmi->sb_type < BLOCK_8X8) {
        ++mi_col_offset;
        above_mbmi =
            &xd->mi[mi_col_offset + mi_row_offset * xd->mi_stride]->mbmi;
      }
#endif

      const BLOCK_SIZE a_bsize = AOMMAX(BLOCK_8X8, above_mbmi->sb_type);
      const int mi_step = AOMMIN(xd->n8_w, mi_size_wide[a_bsize]);

      if (is_neighbor_overlappable(above_mbmi)) {
        neighbor_count++;
        if (neighbor_count > neighbor_limit) break;
        for (plane = 0; plane < MAX_MB_PLANE; ++plane) {
          const struct macroblockd_plane *pd = &xd->plane[plane];
          const int bw = (mi_step * MI_SIZE) >> pd->subsampling_x;
          const int bh = overlap >> pd->subsampling_y;

          if (skip_u4x4_pred_in_obmc(bsize, pd, 0)) continue;

          const int dst_stride = pd->dst.stride;
          uint8_t *const dst = &pd->dst.buf[(i * MI_SIZE) >> pd->subsampling_x];
          const int tmp_stride = above_stride[plane];
          const uint8_t *const tmp =
              &above[plane][(i * MI_SIZE) >> pd->subsampling_x];
          const uint8_t *const mask = av1_get_obmc_mask(bh);

#if CONFIG_HIGHBITDEPTH
          if (is_hbd)
            aom_highbd_blend_a64_vmask(dst, dst_stride, dst, dst_stride, tmp,
                                       tmp_stride, mask, bh, bw, xd->bd);
          else
#endif  // CONFIG_HIGHBITDEPTH
            aom_blend_a64_vmask(dst, dst_stride, dst, dst_stride, tmp,
                                tmp_stride, mask, bh, bw);
        }
      }
      i += mi_step;
    } while (i < miw);
  }

  // handle left column
  if (xd->left_available) {
    const int overlap = num_4x4_blocks_wide_lookup[bsize] * 2;
    const int mih = AOMMIN(xd->n8_h, cm->mi_rows - mi_row);
    const int mi_col_offset = -1;
    const int neighbor_limit = max_neighbor_obmc[b_height_log2_lookup[bsize]];
    int neighbor_count = 0;

    assert(mih > 0);

    i = 0;
    do {  // for each mi in the left column
      int mi_row_offset = i;
      MB_MODE_INFO *left_mbmi =
          &xd->mi[mi_col_offset + mi_row_offset * xd->mi_stride]->mbmi;
#if CONFIG_CHROMA_SUB8X8
      if (left_mbmi->sb_type < BLOCK_8X8) {
        ++mi_row_offset;
        left_mbmi =
            &xd->mi[mi_col_offset + mi_row_offset * xd->mi_stride]->mbmi;
      }
#endif

      const BLOCK_SIZE l_bsize = AOMMAX(BLOCK_8X8, left_mbmi->sb_type);
      const int mi_step = AOMMIN(xd->n8_h, mi_size_high[l_bsize]);

      if (is_neighbor_overlappable(left_mbmi)) {
        neighbor_count++;
        if (neighbor_count > neighbor_limit) break;
        for (plane = 0; plane < MAX_MB_PLANE; ++plane) {
          const struct macroblockd_plane *pd = &xd->plane[plane];
          const int bw = overlap >> pd->subsampling_x;
          const int bh = (mi_step * MI_SIZE) >> pd->subsampling_y;

          if (skip_u4x4_pred_in_obmc(bsize, pd, 1)) continue;

          const int dst_stride = pd->dst.stride;
          uint8_t *const dst =
              &pd->dst.buf[(i * MI_SIZE * dst_stride) >> pd->subsampling_y];
          const int tmp_stride = left_stride[plane];
          const uint8_t *const tmp =
              &left[plane][(i * MI_SIZE * tmp_stride) >> pd->subsampling_y];
          const uint8_t *const mask = av1_get_obmc_mask(bw);

#if CONFIG_HIGHBITDEPTH
          if (is_hbd)
            aom_highbd_blend_a64_hmask(dst, dst_stride, dst, dst_stride, tmp,
                                       tmp_stride, mask, bh, bw, xd->bd);
          else
#endif  // CONFIG_HIGHBITDEPTH
            aom_blend_a64_hmask(dst, dst_stride, dst, dst_stride, tmp,
                                tmp_stride, mask, bh, bw);
        }
      }
      i += mi_step;
    } while (i < mih);
  }
}

void modify_neighbor_predictor_for_obmc(MB_MODE_INFO *mbmi) {
#if CONFIG_EXT_INTER
  if (is_interintra_pred(mbmi)) {
    mbmi->ref_frame[1] = NONE_FRAME;
  } else if (has_second_ref(mbmi) &&
             is_masked_compound_type(mbmi->interinter_compound_type)) {
    mbmi->interinter_compound_type = COMPOUND_AVERAGE;
    mbmi->ref_frame[1] = NONE_FRAME;
  }
#endif  // CONFIG_EXT_INTER
  if (has_second_ref(mbmi)) mbmi->ref_frame[1] = NONE_FRAME;
  return;
}

void av1_build_prediction_by_above_preds(const AV1_COMMON *cm, MACROBLOCKD *xd,
                                         int mi_row, int mi_col,
                                         uint8_t *tmp_buf[MAX_MB_PLANE],
                                         int tmp_width[MAX_MB_PLANE],
                                         int tmp_height[MAX_MB_PLANE],
                                         int tmp_stride[MAX_MB_PLANE]) {
  const TileInfo *const tile = &xd->tile;
  BLOCK_SIZE bsize = xd->mi[0]->mbmi.sb_type;
  int i, j, mi_step, ref;
  const int ilimit = AOMMIN(xd->n8_w, cm->mi_cols - mi_col);
  int mb_to_right_edge_base = xd->mb_to_right_edge;
  const int neighbor_limit = max_neighbor_obmc[b_width_log2_lookup[bsize]];
  int neighbor_count = 0;

  if (mi_row <= tile->mi_row_start) return;

  xd->mb_to_bottom_edge += xd->n8_h * 32;
  for (i = 0; i < ilimit; i += mi_step) {
    int mi_row_offset = -1;
    int mi_col_offset = i;
    int mi_x, mi_y, bw, bh;
    MODE_INFO *above_mi = xd->mi[mi_col_offset + mi_row_offset * xd->mi_stride];
    MB_MODE_INFO *above_mbmi = &above_mi->mbmi;

#if CONFIG_CHROMA_SUB8X8
    if (above_mbmi->sb_type < BLOCK_8X8) {
      ++mi_col_offset;
      above_mbmi = &xd->mi[mi_col_offset + mi_row_offset * xd->mi_stride]->mbmi;
    }
#endif

    const BLOCK_SIZE a_bsize = AOMMAX(BLOCK_8X8, above_mbmi->sb_type);
    MB_MODE_INFO backup_mbmi;

    mi_step = AOMMIN(xd->n8_w, mi_size_wide[a_bsize]);

    if (!is_neighbor_overlappable(above_mbmi)) continue;

    neighbor_count++;
    if (neighbor_count > neighbor_limit) break;

    backup_mbmi = *above_mbmi;
    modify_neighbor_predictor_for_obmc(above_mbmi);

    for (j = 0; j < MAX_MB_PLANE; ++j) {
      struct macroblockd_plane *const pd = &xd->plane[j];
      setup_pred_plane(&pd->dst, a_bsize, tmp_buf[j], tmp_width[j],
                       tmp_height[j], tmp_stride[j], 0, i, NULL,
                       pd->subsampling_x, pd->subsampling_y);
    }
    for (ref = 0; ref < 1 + has_second_ref(above_mbmi); ++ref) {
      const MV_REFERENCE_FRAME frame = above_mbmi->ref_frame[ref];
      const RefBuffer *const ref_buf = &cm->frame_refs[frame - LAST_FRAME];

      xd->block_refs[ref] = ref_buf;
      if ((!av1_is_valid_scale(&ref_buf->sf)))
        aom_internal_error(xd->error_info, AOM_CODEC_UNSUP_BITSTREAM,
                           "Reference frame has invalid dimensions");
      av1_setup_pre_planes(xd, ref, ref_buf->buf, mi_row, mi_col + i,
                           &ref_buf->sf);
    }

    xd->mb_to_left_edge = -(((mi_col + i) * MI_SIZE) * 8);
    xd->mb_to_right_edge =
        mb_to_right_edge_base + (xd->n8_w - i - mi_step) * 64;
    mi_x = (mi_col + i) << MI_SIZE_LOG2;
    mi_y = mi_row << MI_SIZE_LOG2;

    for (j = 0; j < MAX_MB_PLANE; ++j) {
      const struct macroblockd_plane *pd = &xd->plane[j];
      bw = (mi_step * MI_SIZE) >> pd->subsampling_x;
      bh = AOMMAX((num_4x4_blocks_high_lookup[bsize] * 2) >> pd->subsampling_y,
                  4);

      if (skip_u4x4_pred_in_obmc(bsize, pd, 0)) continue;
      build_inter_predictors(cm, xd, j, mi_col_offset, mi_row_offset, 0, bw, bh,
                             0, 0, bw, bh,
#if CONFIG_SUPERTX && CONFIG_EXT_INTER
                             0, 0,
#endif  // CONFIG_SUPERTX && CONFIG_EXT_INTER
                             mi_x, mi_y);
    }
    *above_mbmi = backup_mbmi;
  }
  xd->mb_to_left_edge = -((mi_col * MI_SIZE) * 8);
  xd->mb_to_right_edge = mb_to_right_edge_base;
  xd->mb_to_bottom_edge -= xd->n8_h * 32;
}

void av1_build_prediction_by_left_preds(const AV1_COMMON *cm, MACROBLOCKD *xd,
                                        int mi_row, int mi_col,
                                        uint8_t *tmp_buf[MAX_MB_PLANE],
                                        int tmp_width[MAX_MB_PLANE],
                                        int tmp_height[MAX_MB_PLANE],
                                        int tmp_stride[MAX_MB_PLANE]) {
  const TileInfo *const tile = &xd->tile;
  BLOCK_SIZE bsize = xd->mi[0]->mbmi.sb_type;
  int i, j, mi_step, ref;
  const int ilimit = AOMMIN(xd->n8_h, cm->mi_rows - mi_row);
  int mb_to_bottom_edge_base = xd->mb_to_bottom_edge;
  const int neighbor_limit = max_neighbor_obmc[b_height_log2_lookup[bsize]];
  int neighbor_count = 0;

  if (mi_col == 0 || (mi_col - 1 < tile->mi_col_start)) return;

  xd->mb_to_right_edge += xd->n8_w * 32;
  for (i = 0; i < ilimit; i += mi_step) {
    int mi_row_offset = i;
    int mi_col_offset = -1;
    int mi_x, mi_y, bw, bh;
    MODE_INFO *left_mi = xd->mi[mi_col_offset + mi_row_offset * xd->mi_stride];
    MB_MODE_INFO *left_mbmi = &left_mi->mbmi;

#if CONFIG_CHROMA_SUB8X8
    if (left_mbmi->sb_type < BLOCK_8X8) {
      ++mi_row_offset;
      left_mbmi = &xd->mi[mi_col_offset + mi_row_offset * xd->mi_stride]->mbmi;
    }
#endif

    const BLOCK_SIZE l_bsize = AOMMAX(left_mbmi->sb_type, BLOCK_8X8);
    MB_MODE_INFO backup_mbmi;

    mi_step = AOMMIN(xd->n8_h, mi_size_high[l_bsize]);

    if (!is_neighbor_overlappable(left_mbmi)) continue;

    neighbor_count++;
    if (neighbor_count > neighbor_limit) break;

    backup_mbmi = *left_mbmi;
    modify_neighbor_predictor_for_obmc(left_mbmi);

    for (j = 0; j < MAX_MB_PLANE; ++j) {
      struct macroblockd_plane *const pd = &xd->plane[j];
      setup_pred_plane(&pd->dst, l_bsize, tmp_buf[j], tmp_width[j],
                       tmp_height[j], tmp_stride[j], i, 0, NULL,
                       pd->subsampling_x, pd->subsampling_y);
    }
    for (ref = 0; ref < 1 + has_second_ref(left_mbmi); ++ref) {
      const MV_REFERENCE_FRAME frame = left_mbmi->ref_frame[ref];
      const RefBuffer *const ref_buf = &cm->frame_refs[frame - LAST_FRAME];

      xd->block_refs[ref] = ref_buf;
      if ((!av1_is_valid_scale(&ref_buf->sf)))
        aom_internal_error(xd->error_info, AOM_CODEC_UNSUP_BITSTREAM,
                           "Reference frame has invalid dimensions");
      av1_setup_pre_planes(xd, ref, ref_buf->buf, mi_row + i, mi_col,
                           &ref_buf->sf);
    }

    xd->mb_to_top_edge = -(((mi_row + i) * MI_SIZE) * 8);
    xd->mb_to_bottom_edge =
        mb_to_bottom_edge_base + (xd->n8_h - i - mi_step) * 64;
    mi_x = mi_col << MI_SIZE_LOG2;
    mi_y = (mi_row + i) << MI_SIZE_LOG2;

    for (j = 0; j < MAX_MB_PLANE; ++j) {
      const struct macroblockd_plane *pd = &xd->plane[j];
      bw = AOMMAX((num_4x4_blocks_wide_lookup[bsize] * 2) >> pd->subsampling_x,
                  4);
      bh = (mi_step << MI_SIZE_LOG2) >> pd->subsampling_y;

      if (skip_u4x4_pred_in_obmc(bsize, pd, 1)) continue;
      build_inter_predictors(cm, xd, j, mi_col_offset, mi_row_offset, 0, bw, bh,
                             0, 0, bw, bh,
#if CONFIG_SUPERTX && CONFIG_EXT_INTER
                             0, 0,
#endif  // CONFIG_SUPERTX && CONFIG_EXT_INTER
                             mi_x, mi_y);
    }
    *left_mbmi = backup_mbmi;
  }
  xd->mb_to_top_edge = -((mi_row * MI_SIZE) * 8);
  xd->mb_to_bottom_edge = mb_to_bottom_edge_base;
  xd->mb_to_right_edge -= xd->n8_w * 32;
}

void av1_build_obmc_inter_predictors_sb(const AV1_COMMON *cm, MACROBLOCKD *xd,
                                        int mi_row, int mi_col) {
#if CONFIG_HIGHBITDEPTH
  DECLARE_ALIGNED(16, uint8_t, tmp_buf1[2 * MAX_MB_PLANE * MAX_SB_SQUARE]);
  DECLARE_ALIGNED(16, uint8_t, tmp_buf2[2 * MAX_MB_PLANE * MAX_SB_SQUARE]);
#else
  DECLARE_ALIGNED(16, uint8_t, tmp_buf1[MAX_MB_PLANE * MAX_SB_SQUARE]);
  DECLARE_ALIGNED(16, uint8_t, tmp_buf2[MAX_MB_PLANE * MAX_SB_SQUARE]);
#endif  // CONFIG_HIGHBITDEPTH
  uint8_t *dst_buf1[MAX_MB_PLANE], *dst_buf2[MAX_MB_PLANE];
  int dst_stride1[MAX_MB_PLANE] = { MAX_SB_SIZE, MAX_SB_SIZE, MAX_SB_SIZE };
  int dst_stride2[MAX_MB_PLANE] = { MAX_SB_SIZE, MAX_SB_SIZE, MAX_SB_SIZE };
  int dst_width1[MAX_MB_PLANE] = { MAX_SB_SIZE, MAX_SB_SIZE, MAX_SB_SIZE };
  int dst_width2[MAX_MB_PLANE] = { MAX_SB_SIZE, MAX_SB_SIZE, MAX_SB_SIZE };
  int dst_height1[MAX_MB_PLANE] = { MAX_SB_SIZE, MAX_SB_SIZE, MAX_SB_SIZE };
  int dst_height2[MAX_MB_PLANE] = { MAX_SB_SIZE, MAX_SB_SIZE, MAX_SB_SIZE };

#if CONFIG_HIGHBITDEPTH
  if (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH) {
    int len = sizeof(uint16_t);
    dst_buf1[0] = CONVERT_TO_BYTEPTR(tmp_buf1);
    dst_buf1[1] = CONVERT_TO_BYTEPTR(tmp_buf1 + MAX_SB_SQUARE * len);
    dst_buf1[2] = CONVERT_TO_BYTEPTR(tmp_buf1 + MAX_SB_SQUARE * 2 * len);
    dst_buf2[0] = CONVERT_TO_BYTEPTR(tmp_buf2);
    dst_buf2[1] = CONVERT_TO_BYTEPTR(tmp_buf2 + MAX_SB_SQUARE * len);
    dst_buf2[2] = CONVERT_TO_BYTEPTR(tmp_buf2 + MAX_SB_SQUARE * 2 * len);
  } else {
#endif  // CONFIG_HIGHBITDEPTH
    dst_buf1[0] = tmp_buf1;
    dst_buf1[1] = tmp_buf1 + MAX_SB_SQUARE;
    dst_buf1[2] = tmp_buf1 + MAX_SB_SQUARE * 2;
    dst_buf2[0] = tmp_buf2;
    dst_buf2[1] = tmp_buf2 + MAX_SB_SQUARE;
    dst_buf2[2] = tmp_buf2 + MAX_SB_SQUARE * 2;
#if CONFIG_HIGHBITDEPTH
  }
#endif  // CONFIG_HIGHBITDEPTH
  av1_build_prediction_by_above_preds(cm, xd, mi_row, mi_col, dst_buf1,
                                      dst_width1, dst_height1, dst_stride1);
  av1_build_prediction_by_left_preds(cm, xd, mi_row, mi_col, dst_buf2,
                                     dst_width2, dst_height2, dst_stride2);
  av1_setup_dst_planes(xd->plane, xd->mi[0]->mbmi.sb_type,
                       get_frame_new_buffer(cm), mi_row, mi_col);
  av1_build_obmc_inter_prediction(cm, xd, mi_row, mi_col, dst_buf1, dst_stride1,
                                  dst_buf2, dst_stride2);
}

#if CONFIG_NCOBMC
void av1_build_prediction_by_bottom_preds(const AV1_COMMON *cm, MACROBLOCKD *xd,
                                          int mi_row, int mi_col,
                                          uint8_t *tmp_buf[MAX_MB_PLANE],
                                          int tmp_width[MAX_MB_PLANE],
                                          int tmp_height[MAX_MB_PLANE],
                                          int tmp_stride[MAX_MB_PLANE]) {
  const TileInfo *const tile = &xd->tile;
  BLOCK_SIZE bsize = xd->mi[0]->mbmi.sb_type;
  int i, j, mi_step, ref;
  const int ilimit = AOMMIN(xd->n8_w, cm->mi_cols - mi_col);
  int mb_to_right_edge_base = xd->mb_to_right_edge;

  if (mi_row + xd->n8_h >= tile->mi_row_end ||
      (mi_row + xd->n8_h) % MI_SIZE == 0 || (mi_row + xd->n8_h) >= cm->mi_rows)
    return;
  assert(bsize >= BLOCK_8X8);

  xd->mb_to_top_edge -= xd->n8_h * 32;
  for (i = 0; i < ilimit; i += mi_step) {
    int mi_row_offset = xd->n8_h;
    int mi_col_offset = i;
    int mi_x, mi_y, bw, bh;
    MODE_INFO *mi = xd->mi[mi_col_offset + mi_row_offset * xd->mi_stride];
    MB_MODE_INFO *mbmi = &mi->mbmi;
#if CONFIG_EXT_INTER
    MB_MODE_INFO backup_mbmi;
#endif  // CONFIG_EXT_INTER

    mi_step = AOMMIN(xd->n8_w, mi_size_wide[mbmi->sb_type]);

    if (!is_neighbor_overlappable(mbmi)) continue;

#if CONFIG_EXT_INTER
    backup_mbmi = *mbmi;
    modify_neighbor_predictor_for_obmc(mbmi);
#endif  // CONFIG_EXT_INTER

    for (j = 0; j < MAX_MB_PLANE; ++j) {
      struct macroblockd_plane *const pd = &xd->plane[j];
      setup_pred_plane(&pd->dst, AOMMAX(mbmi->sb_type, BLOCK_8X8), tmp_buf[j],
                       tmp_width[j], tmp_height[j], tmp_stride[j],
                       (xd->n8_h >> 1), i, NULL, pd->subsampling_x,
                       pd->subsampling_y);
    }
    for (ref = 0; ref < 1 + has_second_ref(mbmi); ++ref) {
      const MV_REFERENCE_FRAME frame = mbmi->ref_frame[ref];
      const RefBuffer *const ref_buf = &cm->frame_refs[frame - LAST_FRAME];

      xd->block_refs[ref] = ref_buf;
      if ((!av1_is_valid_scale(&ref_buf->sf)))
        aom_internal_error(xd->error_info, AOM_CODEC_UNSUP_BITSTREAM,
                           "Reference frame has invalid dimensions");
      av1_setup_pre_planes(xd, ref, ref_buf->buf, mi_row + (xd->n8_h >> 1),
                           mi_col + i, &ref_buf->sf);
    }

    xd->mb_to_left_edge = -(((mi_col + i) * MI_SIZE) * 8);
    xd->mb_to_right_edge =
        mb_to_right_edge_base + (xd->n8_w - i - mi_step) * 64;
    mi_x = (mi_col + i) << MI_SIZE_LOG2;
    mi_y = (mi_row << MI_SIZE_LOG2) + xd->n8_h * 4;

    for (j = 0; j < MAX_MB_PLANE; ++j) {
      const struct macroblockd_plane *pd = &xd->plane[j];
      bw = (mi_step << MI_SIZE_LOG2) >> pd->subsampling_x;
      bh = (num_4x4_blocks_high_lookup[bsize] << 1) >> pd->subsampling_y;

      if (mbmi->sb_type < BLOCK_8X8 && !CONFIG_CB4X4) {
        const PARTITION_TYPE bp = BLOCK_8X8 - mbmi->sb_type;
        const int have_vsplit = bp != PARTITION_HORZ;
        const int have_hsplit = bp != PARTITION_VERT;
        const int num_4x4_w = 2 >> (!have_vsplit);
        const int num_4x4_h = 2 >> (!have_hsplit);
        const int pw = 8 >> (have_vsplit + pd->subsampling_x);
        int x, y;

        for (y = 0; y < num_4x4_h; ++y)
          for (x = 0; x < num_4x4_w; ++x) {
            if ((bp == PARTITION_HORZ || bp == PARTITION_SPLIT) && y != 0)
              continue;

            build_inter_predictors(
                cm, xd, j, mi_col_offset, mi_row_offset, y * 2 + x, bw, bh,
                (4 * x) >> pd->subsampling_x,
                xd->n8_h == 1 ? (4 >> pd->subsampling_y) : 0, pw, bh,
#if CONFIG_SUPERTX && CONFIG_EXT_INTER
                0, 0,
#endif  // CONFIG_SUPERTX && CONFIG_EXT_INTER
                mi_x, mi_y);
          }
      } else {
        build_inter_predictors(
            cm, xd, j, mi_col_offset, mi_row_offset, 0, bw, bh, 0,
            xd->n8_h == 1 ? (4 >> pd->subsampling_y) : 0, bw, bh,
#if CONFIG_SUPERTX && CONFIG_EXT_INTER
            0, 0,
#endif  // CONFIG_SUPERTX && CONFIG_EXT_INTER
            mi_x, mi_y);
      }
    }
#if CONFIG_EXT_INTER
    *mbmi = backup_mbmi;
#endif  // CONFIG_EXT_INTER
  }
  xd->mb_to_left_edge = -((mi_col * MI_SIZE) * 8);
  xd->mb_to_right_edge = mb_to_right_edge_base;
  xd->mb_to_top_edge += xd->n8_h * 32;
}

void av1_build_prediction_by_right_preds(const AV1_COMMON *cm, MACROBLOCKD *xd,
                                         int mi_row, int mi_col,
                                         uint8_t *tmp_buf[MAX_MB_PLANE],
                                         int tmp_width[MAX_MB_PLANE],
                                         int tmp_height[MAX_MB_PLANE],
                                         const int tmp_stride[MAX_MB_PLANE]) {
  const TileInfo *const tile = &xd->tile;
  BLOCK_SIZE bsize = xd->mi[0]->mbmi.sb_type;
  int i, j, mi_step, ref;
  const int ilimit = AOMMIN(xd->n8_h, cm->mi_rows - mi_row);
  int mb_to_bottom_edge_base = xd->mb_to_bottom_edge;

  if (mi_col + xd->n8_w >= tile->mi_col_end ||
      (mi_col + xd->n8_w) % MI_SIZE == 0 || (mi_col + xd->n8_w) >= cm->mi_cols)
    return;

  xd->mb_to_left_edge -= xd->n8_w * 32;
  for (i = 0; i < ilimit; i += mi_step) {
    int mi_row_offset = i;
    int mi_col_offset = xd->n8_w;
    int mi_x, mi_y, bw, bh;
    MODE_INFO *mi = xd->mi[mi_col_offset + mi_row_offset * xd->mi_stride];
    MB_MODE_INFO *mbmi = &mi->mbmi;
#if CONFIG_EXT_INTER
    MB_MODE_INFO backup_mbmi;
#endif  // CONFIG_EXT_INTER

    mi_step = AOMMIN(xd->n8_h, mi_size_high[mbmi->sb_type]);

    if (!is_neighbor_overlappable(mbmi)) continue;

#if CONFIG_EXT_INTER
    backup_mbmi = *mbmi;
    modify_neighbor_predictor_for_obmc(mbmi);
#endif  // CONFIG_EXT_INTER

    for (j = 0; j < MAX_MB_PLANE; ++j) {
      struct macroblockd_plane *const pd = &xd->plane[j];
      setup_pred_plane(&pd->dst, AOMMAX(mbmi->sb_type, BLOCK_8X8), tmp_buf[j],
                       tmp_width[j], tmp_height[j], tmp_stride[j], i,
                       xd->n8_w >> 1, NULL, pd->subsampling_x,
                       pd->subsampling_y);
    }
    for (ref = 0; ref < 1 + has_second_ref(mbmi); ++ref) {
      const MV_REFERENCE_FRAME frame = mbmi->ref_frame[ref];
      const RefBuffer *const ref_buf = &cm->frame_refs[frame - LAST_FRAME];

      xd->block_refs[ref] = ref_buf;
      if ((!av1_is_valid_scale(&ref_buf->sf)))
        aom_internal_error(xd->error_info, AOM_CODEC_UNSUP_BITSTREAM,
                           "Reference frame has invalid dimensions");
      av1_setup_pre_planes(xd, ref, ref_buf->buf, mi_row + i,
                           mi_col + (xd->n8_w >> 1), &ref_buf->sf);
    }

    xd->mb_to_top_edge = -(((mi_row + i) * MI_SIZE) * 8);
    xd->mb_to_bottom_edge =
        mb_to_bottom_edge_base + (xd->n8_h - i - mi_step) * 64;
    mi_x = (mi_col << MI_SIZE_LOG2) + xd->n8_w * 4;
    mi_y = (mi_row + i) << MI_SIZE_LOG2;

    for (j = 0; j < MAX_MB_PLANE; ++j) {
      const struct macroblockd_plane *pd = &xd->plane[j];
      bw = (num_4x4_blocks_wide_lookup[bsize] << 1) >> pd->subsampling_x;
      bh = (mi_step << MI_SIZE_LOG2) >> pd->subsampling_y;

      if (mbmi->sb_type < BLOCK_8X8 && !CONFIG_CB4X4) {
        const PARTITION_TYPE bp = BLOCK_8X8 - mbmi->sb_type;
        const int have_vsplit = bp != PARTITION_HORZ;
        const int have_hsplit = bp != PARTITION_VERT;
        const int num_4x4_w = 2 >> (!have_vsplit);
        const int num_4x4_h = 2 >> (!have_hsplit);
        const int ph = 8 >> (have_hsplit + pd->subsampling_y);
        int x, y;

        for (y = 0; y < num_4x4_h; ++y)
          for (x = 0; x < num_4x4_w; ++x) {
            if ((bp == PARTITION_VERT || bp == PARTITION_SPLIT) && x != 0)
              continue;

            build_inter_predictors(cm, xd, j, mi_col_offset, mi_row_offset,
                                   y * 2 + x, bw, bh,
                                   xd->n8_w == 1 ? 4 >> pd->subsampling_x : 0,
                                   (4 * y) >> pd->subsampling_y, bw, ph,
#if CONFIG_SUPERTX && CONFIG_EXT_INTER
                                   0, 0,
#endif  // CONFIG_SUPERTX && CONFIG_EXT_INTER
                                   mi_x, mi_y);
          }
      } else {
        build_inter_predictors(cm, xd, j, mi_col_offset, mi_row_offset, 0, bw,
                               bh, xd->n8_w == 1 ? 4 >> pd->subsampling_x : 0,
                               0, bw, bh,
#if CONFIG_SUPERTX && CONFIG_EXT_INTER
                               0, 0,
#endif  // CONFIG_SUPERTX && CONFIG_EXT_INTER
                               mi_x, mi_y);
      }
    }
#if CONFIG_EXT_INTER
    *mbmi = backup_mbmi;
#endif  // CONFIG_EXT_INTER
  }
  xd->mb_to_top_edge = -((mi_row * MI_SIZE) * 8);
  xd->mb_to_bottom_edge = mb_to_bottom_edge_base;
  xd->mb_to_left_edge += xd->n8_w * 32;
}

// This function combines motion compensated predictions that is generated by
// bottom/right neighboring blocks' inter predictors with prediction in dst
// buffer.
void av1_merge_dst_bottom_right_preds(const AV1_COMMON *cm, MACROBLOCKD *xd,
                                      int mi_row, int mi_col,
                                      uint8_t *bottom[MAX_MB_PLANE],
                                      const int bottom_stride[MAX_MB_PLANE],
                                      uint8_t *right[MAX_MB_PLANE],
                                      const int right_stride[MAX_MB_PLANE]) {
  const TileInfo *const tile = &xd->tile;
  BLOCK_SIZE bsize = xd->mi[0]->mbmi.sb_type;
  int plane, i, mi_step;
  const int bottom_available = mi_row + xd->n8_h < tile->mi_row_end &&
                               (mi_row + xd->n8_h) % MI_SIZE != 0 &&
                               (mi_row + xd->n8_h) < cm->mi_rows;
#if CONFIG_HIGHBITDEPTH
  int is_hbd = (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH) ? 1 : 0;
#endif  // CONFIG_HIGHBITDEPTH

  // handle bottom row
  for (i = 0; bottom_available && i < AOMMIN(xd->n8_w, cm->mi_cols - mi_col);
       i += mi_step) {
    int mi_row_offset = xd->n8_h;
    int mi_col_offset = i;
    MODE_INFO *mi = xd->mi[mi_col_offset + mi_row_offset * xd->mi_stride];
    MB_MODE_INFO *mbmi = &mi->mbmi;
    int overlap;

    mi_step = AOMMIN(xd->n8_w, mi_size_wide[mbmi->sb_type]);

    if (!is_neighbor_overlappable(mbmi)) continue;

    overlap = num_4x4_blocks_high_lookup[bsize] << 1;

    for (plane = 0; plane < MAX_MB_PLANE; ++plane) {
      const struct macroblockd_plane *pd = &xd->plane[plane];
      const int bw = (mi_step * MI_SIZE) >> pd->subsampling_x;
      const int bh = overlap >> pd->subsampling_y;
      const int dst_stride = pd->dst.stride;
      uint8_t *dst =
          &pd->dst.buf[((i * MI_SIZE) >> pd->subsampling_x) +
                       (((xd->n8_h * MI_SIZE - overlap) * dst_stride) >>
                        pd->subsampling_y)];
      const int tmp_stride = bottom_stride[plane];
      const uint8_t *const tmp =
          &bottom[plane][((i * MI_SIZE) >> pd->subsampling_x) +
                         (((xd->n8_h * MI_SIZE - overlap) * tmp_stride) >>
                          pd->subsampling_y)];
      const uint8_t *const mask = av1_get_obmc_mask_flipped(bh);

#if CONFIG_HIGHBITDEPTH
      if (is_hbd)
        aom_highbd_blend_a64_vmask(dst, dst_stride, dst, dst_stride, tmp,
                                   tmp_stride, mask, bh, bw, xd->bd);
      else
#endif  // CONFIG_HIGHBITDEPTH
        aom_blend_a64_vmask(dst, dst_stride, dst, dst_stride, tmp, tmp_stride,
                            mask, bh, bw);
    }
  }  // each mi in the bottom row

  // handle right column
  if (mi_col + xd->n8_w >= tile->mi_col_end ||
      (mi_col + xd->n8_w) % MI_SIZE == 0 || (mi_col + xd->n8_w) >= cm->mi_cols)
    return;

  for (i = 0; i < AOMMIN(xd->n8_h, cm->mi_rows - mi_row); i += mi_step) {
    int mi_row_offset = i;
    int mi_col_offset = xd->n8_w;
    int overlap;
    MODE_INFO *mi = xd->mi[mi_col_offset + mi_row_offset * xd->mi_stride];
    MB_MODE_INFO *mbmi = &mi->mbmi;

    mi_step = AOMMIN(xd->n8_h, mi_size_high[mbmi->sb_type]);

    if (!is_neighbor_overlappable(mbmi)) continue;

    overlap = num_4x4_blocks_wide_lookup[bsize] << 1;

    for (plane = 0; plane < MAX_MB_PLANE; ++plane) {
      const struct macroblockd_plane *pd = &xd->plane[plane];
      const int bw = overlap >> pd->subsampling_x;
      const int bh = (mi_step * MI_SIZE) >> pd->subsampling_y;
      const int dst_stride = pd->dst.stride;
      uint8_t *dst =
          &pd->dst.buf[((i * MI_SIZE * dst_stride) >> pd->subsampling_y) +
                       ((xd->n8_w * MI_SIZE - overlap) >> pd->subsampling_x)];
      const int tmp_stride = right_stride[plane];
      const uint8_t *const tmp =
          &right[plane][((i * MI_SIZE * tmp_stride) >> pd->subsampling_y) +
                        ((xd->n8_w * MI_SIZE - overlap) >> pd->subsampling_x)];
      const uint8_t *const mask = av1_get_obmc_mask_flipped(bw);

#if CONFIG_HIGHBITDEPTH
      if (is_hbd)
        aom_highbd_blend_a64_hmask(dst, dst_stride, dst, dst_stride, tmp,
                                   tmp_stride, mask, bh, bw, xd->bd);
      else
#endif  // CONFIG_HIGHBITDEPTH
        aom_blend_a64_hmask(dst, dst_stride, dst, dst_stride, tmp, tmp_stride,
                            mask, bh, bw);
    }
  }  // each mi in the right column
}

// This function generates 4 sided obmc. (1) Prediction blocks generated by
// bottom and right motion vectors are calculated. (2) Combine them with the
// original prediction block (which should be pre-stored in xd->plane[].dst.buf
// before calling this function). The results is updated in xd->plane[].dst.buf
// (3) Call causal obmc prediction function, which will generate left and above
// preds, and then merge them and xd->plane[].dst.buf.
void av1_build_ncobmc_inter_predictors_sb(const AV1_COMMON *cm, MACROBLOCKD *xd,
                                          int mi_row, int mi_col) {
#if CONFIG_HIGHBITDEPTH
  DECLARE_ALIGNED(16, uint8_t, tmp_buf1[2 * MAX_MB_PLANE * MAX_SB_SQUARE]);
  DECLARE_ALIGNED(16, uint8_t, tmp_buf2[2 * MAX_MB_PLANE * MAX_SB_SQUARE]);
#else
  DECLARE_ALIGNED(16, uint8_t, tmp_buf1[MAX_MB_PLANE * MAX_SB_SQUARE]);
  DECLARE_ALIGNED(16, uint8_t, tmp_buf2[MAX_MB_PLANE * MAX_SB_SQUARE]);
#endif  // CONFIG_HIGHBITDEPTH
  uint8_t *dst_buf1[MAX_MB_PLANE], *dst_buf2[MAX_MB_PLANE];
  int dst_stride1[MAX_MB_PLANE] = { MAX_SB_SIZE, MAX_SB_SIZE, MAX_SB_SIZE };
  int dst_stride2[MAX_MB_PLANE] = { MAX_SB_SIZE, MAX_SB_SIZE, MAX_SB_SIZE };
  int dst_width1[MAX_MB_PLANE] = { MAX_SB_SIZE, MAX_SB_SIZE, MAX_SB_SIZE };
  int dst_width2[MAX_MB_PLANE] = { MAX_SB_SIZE, MAX_SB_SIZE, MAX_SB_SIZE };
  int dst_height1[MAX_MB_PLANE] = { MAX_SB_SIZE, MAX_SB_SIZE, MAX_SB_SIZE };
  int dst_height2[MAX_MB_PLANE] = { MAX_SB_SIZE, MAX_SB_SIZE, MAX_SB_SIZE };

#if CONFIG_HIGHBITDEPTH
  if (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH) {
    int len = sizeof(uint16_t);
    dst_buf1[0] = CONVERT_TO_BYTEPTR(tmp_buf1);
    dst_buf1[1] = CONVERT_TO_BYTEPTR(tmp_buf1 + MAX_SB_SQUARE * len);
    dst_buf1[2] = CONVERT_TO_BYTEPTR(tmp_buf1 + MAX_SB_SQUARE * 2 * len);
    dst_buf2[0] = CONVERT_TO_BYTEPTR(tmp_buf2);
    dst_buf2[1] = CONVERT_TO_BYTEPTR(tmp_buf2 + MAX_SB_SQUARE * len);
    dst_buf2[2] = CONVERT_TO_BYTEPTR(tmp_buf2 + MAX_SB_SQUARE * 2 * len);
  } else {
#endif  // CONFIG_HIGHBITDEPTH
    dst_buf1[0] = tmp_buf1;
    dst_buf1[1] = tmp_buf1 + MAX_SB_SQUARE;
    dst_buf1[2] = tmp_buf1 + MAX_SB_SQUARE * 2;
    dst_buf2[0] = tmp_buf2;
    dst_buf2[1] = tmp_buf2 + MAX_SB_SQUARE;
    dst_buf2[2] = tmp_buf2 + MAX_SB_SQUARE * 2;
#if CONFIG_HIGHBITDEPTH
  }
#endif  // CONFIG_HIGHBITDEPTH

  const BLOCK_SIZE bsize = xd->mi[0]->mbmi.sb_type;
  av1_build_prediction_by_bottom_preds(cm, xd, mi_row, mi_col, dst_buf1,
                                       dst_width1, dst_height1, dst_stride1);
  av1_build_prediction_by_right_preds(cm, xd, mi_row, mi_col, dst_buf2,
                                      dst_width2, dst_height2, dst_stride2);
  av1_setup_dst_planes(xd->plane, bsize, get_frame_new_buffer(cm), mi_row,
                       mi_col);
  av1_merge_dst_bottom_right_preds(cm, xd, mi_row, mi_col, dst_buf1,
                                   dst_stride1, dst_buf2, dst_stride2);
  av1_setup_dst_planes(xd->plane, bsize, get_frame_new_buffer(cm), mi_row,
                       mi_col);
  av1_build_obmc_inter_predictors_sb(cm, xd, mi_row, mi_col);
  av1_setup_dst_planes(xd->plane, bsize, get_frame_new_buffer(cm), mi_row,
                       mi_col);
}
#endif  // CONFIG_NCOBMC
#endif  // CONFIG_MOTION_VAR

#if CONFIG_EXT_INTER
/* clang-format off */
#if CONFIG_INTERINTRA
#if CONFIG_EXT_PARTITION
static const int ii_weights1d[MAX_SB_SIZE] = {
  60, 58, 56, 54, 52, 50, 48, 47, 45, 44, 42, 41, 39, 38, 37, 35, 34, 33, 32,
  31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 22, 21, 20, 19, 19, 18, 18, 17, 16,
  16, 15, 15, 14, 14, 13, 13, 12, 12, 12, 11, 11, 10, 10, 10,  9,  9,  9,  8,
  8,  8,  8,  7,  7,  7,  7,  6,  6,  6,  6,  6,  5,  5,  5,  5,  5,  4,  4,
  4,  4,  4,  4,  4,  4,  3,  3,  3,  3,  3,  3,  3,  3,  3,  2,  2,  2,  2,
  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  1,  1,  1,  1,  1,  1,  1,  1,
  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1
};
static int ii_size_scales[BLOCK_SIZES] = {
#if CONFIG_CB4X4
    32, 32, 32,
#endif
    32, 16, 16, 16, 8, 8, 8, 4,
    4,  4,  2,  2,  2, 1, 1, 1,
};
#else
static const int ii_weights1d[MAX_SB_SIZE] = {
  60, 56, 52, 48, 45, 42, 39, 37, 34, 32, 30, 28, 26, 24, 22, 21,
  19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 10,  9,  8,  8,  7,  7,
  6,  6,  6,  5,  5,  4,  4,  4,  4,  3,  3,  3,  3,  3,  2,  2,
  2,  2,  2,  2,  2,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1
};
static int ii_size_scales[BLOCK_SIZES] = {
#if CONFIG_CB4X4
    16, 16, 16,
#endif
    16, 8, 8, 8, 4, 4, 4,
    2,  2, 2, 1, 1, 1,
};
/* clang-format on */
#endif  // CONFIG_EXT_PARTITION

static void combine_interintra(INTERINTRA_MODE mode, int use_wedge_interintra,
                               int wedge_index, int wedge_sign,
                               BLOCK_SIZE bsize, BLOCK_SIZE plane_bsize,
                               uint8_t *comppred, int compstride,
                               const uint8_t *interpred, int interstride,
                               const uint8_t *intrapred, int intrastride) {
  const int bw = block_size_wide[plane_bsize];
  const int bh = block_size_high[plane_bsize];
  const int size_scale = ii_size_scales[plane_bsize];
  int i, j;

  if (use_wedge_interintra) {
    if (is_interintra_wedge_used(bsize)) {
      const uint8_t *mask =
          av1_get_contiguous_soft_mask(wedge_index, wedge_sign, bsize);
      const int subw = 2 * num_4x4_blocks_wide_lookup[bsize] == bw;
      const int subh = 2 * num_4x4_blocks_high_lookup[bsize] == bh;
      aom_blend_a64_mask(comppred, compstride, intrapred, intrastride,
                         interpred, interstride, mask, block_size_wide[bsize],
                         bh, bw, subh, subw);
    }
    return;
  }

  switch (mode) {
    case II_V_PRED:
      for (i = 0; i < bh; ++i) {
        for (j = 0; j < bw; ++j) {
          int scale = ii_weights1d[i * size_scale];
          comppred[i * compstride + j] =
              AOM_BLEND_A64(scale, intrapred[i * intrastride + j],
                            interpred[i * interstride + j]);
        }
      }
      break;

    case II_H_PRED:
      for (i = 0; i < bh; ++i) {
        for (j = 0; j < bw; ++j) {
          int scale = ii_weights1d[j * size_scale];
          comppred[i * compstride + j] =
              AOM_BLEND_A64(scale, intrapred[i * intrastride + j],
                            interpred[i * interstride + j]);
        }
      }
      break;

#if CONFIG_ALT_INTRA
    case II_SMOOTH_PRED:
      for (i = 0; i < bh; ++i) {
        for (j = 0; j < bw; ++j) {
          int scale = ii_weights1d[(i < j ? i : j) * size_scale];
          comppred[i * compstride + j] =
              AOM_BLEND_A64(scale, intrapred[i * intrastride + j],
                            interpred[i * interstride + j]);
        }
      }
      break;
#endif

#if !CONFIG_ALT_INTRA
    case II_TM_PRED:
#endif
    case II_DC_PRED:
    default:
      for (i = 0; i < bh; ++i) {
        for (j = 0; j < bw; ++j) {
          comppred[i * compstride + j] = AOM_BLEND_AVG(
              intrapred[i * intrastride + j], interpred[i * interstride + j]);
        }
      }
      break;
  }
}

#if CONFIG_HIGHBITDEPTH
static void combine_interintra_highbd(
    INTERINTRA_MODE mode, int use_wedge_interintra, int wedge_index,
    int wedge_sign, BLOCK_SIZE bsize, BLOCK_SIZE plane_bsize,
    uint8_t *comppred8, int compstride, const uint8_t *interpred8,
    int interstride, const uint8_t *intrapred8, int intrastride, int bd) {
  const int bw = block_size_wide[plane_bsize];
  const int bh = block_size_high[plane_bsize];
  const int size_scale = ii_size_scales[plane_bsize];
  int i, j;

  uint16_t *comppred = CONVERT_TO_SHORTPTR(comppred8);
  const uint16_t *interpred = CONVERT_TO_SHORTPTR(interpred8);
  const uint16_t *intrapred = CONVERT_TO_SHORTPTR(intrapred8);

  if (use_wedge_interintra) {
    if (is_interintra_wedge_used(bsize)) {
      const uint8_t *mask =
          av1_get_contiguous_soft_mask(wedge_index, wedge_sign, bsize);
      const int subh = 2 * num_4x4_blocks_high_lookup[bsize] == bh;
      const int subw = 2 * num_4x4_blocks_wide_lookup[bsize] == bw;
      aom_highbd_blend_a64_mask(comppred8, compstride, intrapred8, intrastride,
                                interpred8, interstride, mask, bw, bh, bw, subh,
                                subw, bd);
    }
    return;
  }

  switch (mode) {
    case II_V_PRED:
      for (i = 0; i < bh; ++i) {
        for (j = 0; j < bw; ++j) {
          int scale = ii_weights1d[i * size_scale];
          comppred[i * compstride + j] =
              AOM_BLEND_A64(scale, intrapred[i * intrastride + j],
                            interpred[i * interstride + j]);
        }
      }
      break;

    case II_H_PRED:
      for (i = 0; i < bh; ++i) {
        for (j = 0; j < bw; ++j) {
          int scale = ii_weights1d[j * size_scale];
          comppred[i * compstride + j] =
              AOM_BLEND_A64(scale, intrapred[i * intrastride + j],
                            interpred[i * interstride + j]);
        }
      }
      break;

#if CONFIG_ALT_INTRA
    case II_SMOOTH_PRED:
      for (i = 0; i < bh; ++i) {
        for (j = 0; j < bw; ++j) {
          int scale = ii_weights1d[(i < j ? i : j) * size_scale];
          comppred[i * compstride + j] =
              AOM_BLEND_A64(scale, intrapred[i * intrastride + j],
                            interpred[i * interstride + j]);
        }
      }
      break;
#endif

#if !CONFIG_ALT_INTRA
    case II_TM_PRED:
#endif
    case II_DC_PRED:
    default:
      for (i = 0; i < bh; ++i) {
        for (j = 0; j < bw; ++j) {
          comppred[i * compstride + j] = AOM_BLEND_AVG(
              interpred[i * interstride + j], intrapred[i * intrastride + j]);
        }
      }
      break;
  }
}
#endif  // CONFIG_HIGHBITDEPTH

void av1_build_intra_predictors_for_interintra(MACROBLOCKD *xd,
                                               BLOCK_SIZE bsize, int plane,
                                               BUFFER_SET *ctx, uint8_t *dst,
                                               int dst_stride) {
  struct macroblockd_plane *const pd = &xd->plane[plane];
  BLOCK_SIZE plane_bsize = get_plane_block_size(bsize, &xd->plane[plane]);
  PREDICTION_MODE mode =
      interintra_to_intra_mode[xd->mi[0]->mbmi.interintra_mode];

  av1_predict_intra_block(xd, pd->width, pd->height, plane_bsize, mode,
                          ctx->plane[plane], ctx->stride[plane], dst,
                          dst_stride, 0, 0, plane);
}

void av1_combine_interintra(MACROBLOCKD *xd, BLOCK_SIZE bsize, int plane,
                            const uint8_t *inter_pred, int inter_stride,
                            const uint8_t *intra_pred, int intra_stride) {
  const BLOCK_SIZE plane_bsize = get_plane_block_size(bsize, &xd->plane[plane]);
#if CONFIG_HIGHBITDEPTH
  if (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH) {
    combine_interintra_highbd(
        xd->mi[0]->mbmi.interintra_mode, xd->mi[0]->mbmi.use_wedge_interintra,
        xd->mi[0]->mbmi.interintra_wedge_index,
        xd->mi[0]->mbmi.interintra_wedge_sign, bsize, plane_bsize,
        xd->plane[plane].dst.buf, xd->plane[plane].dst.stride, inter_pred,
        inter_stride, intra_pred, intra_stride, xd->bd);
    return;
  }
#endif  // CONFIG_HIGHBITDEPTH
  combine_interintra(xd->mi[0]->mbmi.interintra_mode,
                     xd->mi[0]->mbmi.use_wedge_interintra,
                     xd->mi[0]->mbmi.interintra_wedge_index,
                     xd->mi[0]->mbmi.interintra_wedge_sign, bsize, plane_bsize,
                     xd->plane[plane].dst.buf, xd->plane[plane].dst.stride,
                     inter_pred, inter_stride, intra_pred, intra_stride);
}

void av1_build_interintra_predictors_sby(MACROBLOCKD *xd, uint8_t *ypred,
                                         int ystride, BUFFER_SET *ctx,
                                         BLOCK_SIZE bsize) {
#if CONFIG_HIGHBITDEPTH
  if (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH) {
    DECLARE_ALIGNED(16, uint16_t, intrapredictor[MAX_SB_SQUARE]);
    av1_build_intra_predictors_for_interintra(
        xd, bsize, 0, ctx, CONVERT_TO_BYTEPTR(intrapredictor), MAX_SB_SIZE);
    av1_combine_interintra(xd, bsize, 0, ypred, ystride,
                           CONVERT_TO_BYTEPTR(intrapredictor), MAX_SB_SIZE);
    return;
  }
#endif  // CONFIG_HIGHBITDEPTH
  {
    DECLARE_ALIGNED(16, uint8_t, intrapredictor[MAX_SB_SQUARE]);
    av1_build_intra_predictors_for_interintra(xd, bsize, 0, ctx, intrapredictor,
                                              MAX_SB_SIZE);
    av1_combine_interintra(xd, bsize, 0, ypred, ystride, intrapredictor,
                           MAX_SB_SIZE);
  }
}

void av1_build_interintra_predictors_sbc(MACROBLOCKD *xd, uint8_t *upred,
                                         int ustride, BUFFER_SET *ctx,
                                         int plane, BLOCK_SIZE bsize) {
#if CONFIG_HIGHBITDEPTH
  if (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH) {
    DECLARE_ALIGNED(16, uint16_t, uintrapredictor[MAX_SB_SQUARE]);
    av1_build_intra_predictors_for_interintra(
        xd, bsize, plane, ctx, CONVERT_TO_BYTEPTR(uintrapredictor),
        MAX_SB_SIZE);
    av1_combine_interintra(xd, bsize, plane, upred, ustride,
                           CONVERT_TO_BYTEPTR(uintrapredictor), MAX_SB_SIZE);
    return;
  }
#endif  // CONFIG_HIGHBITDEPTH
  {
    DECLARE_ALIGNED(16, uint8_t, uintrapredictor[MAX_SB_SQUARE]);
    av1_build_intra_predictors_for_interintra(xd, bsize, plane, ctx,
                                              uintrapredictor, MAX_SB_SIZE);
    av1_combine_interintra(xd, bsize, plane, upred, ustride, uintrapredictor,
                           MAX_SB_SIZE);
  }
}

void av1_build_interintra_predictors_sbuv(MACROBLOCKD *xd, uint8_t *upred,
                                          uint8_t *vpred, int ustride,
                                          int vstride, BUFFER_SET *ctx,
                                          BLOCK_SIZE bsize) {
  av1_build_interintra_predictors_sbc(xd, upred, ustride, ctx, 1, bsize);
  av1_build_interintra_predictors_sbc(xd, vpred, vstride, ctx, 2, bsize);
}

void av1_build_interintra_predictors(MACROBLOCKD *xd, uint8_t *ypred,
                                     uint8_t *upred, uint8_t *vpred,
                                     int ystride, int ustride, int vstride,
                                     BUFFER_SET *ctx, BLOCK_SIZE bsize) {
  av1_build_interintra_predictors_sby(xd, ypred, ystride, ctx, bsize);
  av1_build_interintra_predictors_sbuv(xd, upred, vpred, ustride, vstride, ctx,
                                       bsize);
}
#endif  // CONFIG_INTERINTRA

// Builds the inter-predictor for the single ref case
// for use in the encoder to search the wedges efficiently.
static void build_inter_predictors_single_buf(MACROBLOCKD *xd, int plane,
                                              int block, int bw, int bh, int x,
                                              int y, int w, int h, int mi_x,
                                              int mi_y, int ref,
                                              uint8_t *const ext_dst,
                                              int ext_dst_stride) {
  struct macroblockd_plane *const pd = &xd->plane[plane];
  const MODE_INFO *mi = xd->mi[0];

  const struct scale_factors *const sf = &xd->block_refs[ref]->sf;
  struct buf_2d *const pre_buf = &pd->pre[ref];
#if CONFIG_HIGHBITDEPTH
  uint8_t *const dst =
      (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH ? CONVERT_TO_BYTEPTR(ext_dst)
                                                   : ext_dst) +
      ext_dst_stride * y + x;
#else
  uint8_t *const dst = ext_dst + ext_dst_stride * y + x;
#endif
  const MV mv = mi->mbmi.sb_type < BLOCK_8X8
                    ? average_split_mvs(pd, mi, ref, block)
                    : mi->mbmi.mv[ref].as_mv;

  // TODO(jkoleszar): This clamping is done in the incorrect place for the
  // scaling case. It needs to be done on the scaled MV, not the pre-scaling
  // MV. Note however that it performs the subsampling aware scaling so
  // that the result is always q4.
  // mv_precision precision is MV_PRECISION_Q4.
  const MV mv_q4 = clamp_mv_to_umv_border_sb(xd, &mv, bw, bh, pd->subsampling_x,
                                             pd->subsampling_y);

  uint8_t *pre;
  MV32 scaled_mv;
  int xs, ys, subpel_x, subpel_y;
  const int is_scaled = av1_is_scaled(sf);
  ConvolveParams conv_params = get_conv_params(0, plane);
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
  WarpTypesAllowed warp_types;
#if CONFIG_GLOBAL_MOTION
  WarpedMotionParams *const wm = &xd->global_motion[mi->mbmi.ref_frame[ref]];
  warp_types.global_warp_allowed = is_global_mv_block(mi, block, wm->wmtype);
#endif  // CONFIG_GLOBAL_MOTION
#if CONFIG_WARPED_MOTION
  warp_types.local_warp_allowed = mi->mbmi.motion_mode == WARPED_CAUSAL;
#endif  // CONFIG_WARPED_MOTION
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION

  if (is_scaled) {
    pre = pre_buf->buf + scaled_buffer_offset(x, y, pre_buf->stride, sf);
    scaled_mv = av1_scale_mv(&mv_q4, mi_x + x, mi_y + y, sf);
    xs = sf->x_step_q4;
    ys = sf->y_step_q4;
  } else {
    pre = pre_buf->buf + (y * pre_buf->stride + x);
    scaled_mv.row = mv_q4.row;
    scaled_mv.col = mv_q4.col;
    xs = ys = 16;
  }

  subpel_x = scaled_mv.col & SUBPEL_MASK;
  subpel_y = scaled_mv.row & SUBPEL_MASK;
  pre += (scaled_mv.row >> SUBPEL_BITS) * pre_buf->stride +
         (scaled_mv.col >> SUBPEL_BITS);

  av1_make_inter_predictor(pre, pre_buf->stride, dst, ext_dst_stride, subpel_x,
                           subpel_y, sf, w, h, &conv_params,
                           mi->mbmi.interp_filter,
#if CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
                           &warp_types, (mi_x >> pd->subsampling_x) + x,
                           (mi_y >> pd->subsampling_y) + y, plane, ref,
#endif  // CONFIG_GLOBAL_MOTION || CONFIG_WARPED_MOTION
#if CONFIG_MOTION_VAR
                           0, 0,
#endif
                           xs, ys, xd);
}

void av1_build_inter_predictors_for_planes_single_buf(
    MACROBLOCKD *xd, BLOCK_SIZE bsize, int plane_from, int plane_to, int mi_row,
    int mi_col, int ref, uint8_t *ext_dst[3], int ext_dst_stride[3]) {
  int plane;
  const int mi_x = mi_col * MI_SIZE;
  const int mi_y = mi_row * MI_SIZE;
  for (plane = plane_from; plane <= plane_to; ++plane) {
    const BLOCK_SIZE plane_bsize =
        get_plane_block_size(bsize, &xd->plane[plane]);
    const int bw = block_size_wide[plane_bsize];
    const int bh = block_size_high[plane_bsize];

    if (xd->mi[0]->mbmi.sb_type < BLOCK_8X8 && !CONFIG_CB4X4) {
      int x, y;
      const int num_4x4_w = num_4x4_blocks_wide_lookup[plane_bsize];
      const int num_4x4_h = num_4x4_blocks_high_lookup[plane_bsize];
      assert(bsize == BLOCK_8X8);
      for (y = 0; y < num_4x4_h; ++y)
        for (x = 0; x < num_4x4_w; ++x)
          build_inter_predictors_single_buf(
              xd, plane, y * 2 + x, bw, bh, 4 * x, 4 * y, 4, 4, mi_x, mi_y, ref,
              ext_dst[plane], ext_dst_stride[plane]);
    } else {
      build_inter_predictors_single_buf(xd, plane, 0, bw, bh, 0, 0, bw, bh,
                                        mi_x, mi_y, ref, ext_dst[plane],
                                        ext_dst_stride[plane]);
    }
  }
}

static void build_wedge_inter_predictor_from_buf(
    MACROBLOCKD *xd, int plane, int x, int y, int w, int h,
#if CONFIG_SUPERTX
    int wedge_offset_x, int wedge_offset_y,
#endif  // CONFIG_SUPERTX
    uint8_t *ext_dst0, int ext_dst_stride0, uint8_t *ext_dst1,
    int ext_dst_stride1) {
  MB_MODE_INFO *const mbmi = &xd->mi[0]->mbmi;
  const int is_compound = has_second_ref(mbmi);
  MACROBLOCKD_PLANE *const pd = &xd->plane[plane];
  struct buf_2d *const dst_buf = &pd->dst;
  uint8_t *const dst = dst_buf->buf + dst_buf->stride * y + x;
  const INTERINTER_COMPOUND_DATA comp_data = {
#if CONFIG_WEDGE
    mbmi->wedge_index,
    mbmi->wedge_sign,
#endif  // CONFIG_WEDGE
#if CONFIG_COMPOUND_SEGMENT
    mbmi->mask_type,
    xd->seg_mask,
#endif  // CONFIG_COMPOUND_SEGMENT
    mbmi->interinter_compound_type
  };

  if (is_compound && is_masked_compound_type(mbmi->interinter_compound_type)) {
#if CONFIG_COMPOUND_SEGMENT
    if (!plane && comp_data.interinter_compound_type == COMPOUND_SEG) {
#if CONFIG_HIGHBITDEPTH
      if (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH)
        build_compound_seg_mask_highbd(
            comp_data.seg_mask, comp_data.mask_type,
            CONVERT_TO_BYTEPTR(ext_dst0), ext_dst_stride0,
            CONVERT_TO_BYTEPTR(ext_dst1), ext_dst_stride1, mbmi->sb_type, h, w,
            xd->bd);
      else
#endif  // CONFIG_HIGHBITDEPTH
        build_compound_seg_mask(comp_data.seg_mask, comp_data.mask_type,
                                ext_dst0, ext_dst_stride0, ext_dst1,
                                ext_dst_stride1, mbmi->sb_type, h, w);
    }
#endif  // CONFIG_COMPOUND_SEGMENT

#if CONFIG_SUPERTX
#if CONFIG_HIGHBITDEPTH
    if (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH)
      build_masked_compound_wedge_extend_highbd(
          dst, dst_buf->stride, CONVERT_TO_BYTEPTR(ext_dst0), ext_dst_stride0,
          CONVERT_TO_BYTEPTR(ext_dst1), ext_dst_stride1, &comp_data,
          mbmi->sb_type, wedge_offset_x, wedge_offset_y, h, w, xd->bd);
    else
#endif  // CONFIG_HIGHBITDEPTH
      build_masked_compound_wedge_extend(
          dst, dst_buf->stride, ext_dst0, ext_dst_stride0, ext_dst1,
          ext_dst_stride1, &comp_data, mbmi->sb_type, wedge_offset_x,
          wedge_offset_y, h, w);
#else
#if CONFIG_HIGHBITDEPTH
    if (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH)
      build_masked_compound_highbd(
          dst, dst_buf->stride, CONVERT_TO_BYTEPTR(ext_dst0), ext_dst_stride0,
          CONVERT_TO_BYTEPTR(ext_dst1), ext_dst_stride1, &comp_data,
          mbmi->sb_type, h, w, xd->bd);
    else
#endif  // CONFIG_HIGHBITDEPTH
      build_masked_compound(dst, dst_buf->stride, ext_dst0, ext_dst_stride0,
                            ext_dst1, ext_dst_stride1, &comp_data,
                            mbmi->sb_type, h, w);
#endif  // CONFIG_SUPERTX
  } else {
#if CONFIG_HIGHBITDEPTH
    if (xd->cur_buf->flags & YV12_FLAG_HIGHBITDEPTH)
      aom_highbd_convolve_copy(CONVERT_TO_BYTEPTR(ext_dst0), ext_dst_stride0,
                               dst, dst_buf->stride, NULL, 0, NULL, 0, w, h,
                               xd->bd);
    else
#endif  // CONFIG_HIGHBITDEPTH
      aom_convolve_copy(ext_dst0, ext_dst_stride0, dst, dst_buf->stride, NULL,
                        0, NULL, 0, w, h);
  }
}

void av1_build_wedge_inter_predictor_from_buf(
    MACROBLOCKD *xd, BLOCK_SIZE bsize, int plane_from, int plane_to,
#if CONFIG_SUPERTX
    int wedge_offset_x, int wedge_offset_y,
#endif  // CONFIG_SUPERTX
    uint8_t *ext_dst0[3], int ext_dst_stride0[3], uint8_t *ext_dst1[3],
    int ext_dst_stride1[3]) {
  int plane;
  for (plane = plane_from; plane <= plane_to; ++plane) {
    const BLOCK_SIZE plane_bsize =
        get_plane_block_size(bsize, &xd->plane[plane]);

    if (xd->mi[0]->mbmi.sb_type < BLOCK_8X8 && !CONFIG_CB4X4) {
      int x, y;
      const int num_4x4_w = num_4x4_blocks_wide_lookup[plane_bsize];
      const int num_4x4_h = num_4x4_blocks_high_lookup[plane_bsize];
      assert(bsize == BLOCK_8X8);
      for (y = 0; y < num_4x4_h; ++y)
        for (x = 0; x < num_4x4_w; ++x)
          build_wedge_inter_predictor_from_buf(
              xd, plane, 4 * x, 4 * y, 4, 4,
#if CONFIG_SUPERTX
              wedge_offset_x, wedge_offset_y,
#endif  // CONFIG_SUPERTX
              ext_dst0[plane], ext_dst_stride0[plane], ext_dst1[plane],
              ext_dst_stride1[plane]);
    } else {
      const int bw = block_size_wide[plane_bsize];
      const int bh = block_size_high[plane_bsize];
      build_wedge_inter_predictor_from_buf(
          xd, plane, 0, 0, bw, bh,
#if CONFIG_SUPERTX
          wedge_offset_x, wedge_offset_y,
#endif  // CONFIG_SUPERTX
          ext_dst0[plane], ext_dst_stride0[plane], ext_dst1[plane],
          ext_dst_stride1[plane]);
    }
  }
}
#endif  // CONFIG_EXT_INTER
