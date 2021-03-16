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

#include <assert.h>
#include <smmintrin.h>

#include "config/av1_rtcd.h"
#include "aom/aom_integer.h"
#include "av1/encoder/encoder.h"
#include "av1/encoder/temporal_filter.h"
#include "av1/encoder/x86/temporal_filter_constants.h"

//////////////////////////
// Low bit-depth Begins //
//////////////////////////

// Read in 8 pixels from a and b as 8-bit unsigned integers, compute the
// difference squared, and store as unsigned 16-bit integer to dst.
static INLINE void store_dist_8(const uint8_t *a, const uint8_t *b,
                                uint16_t *dst) {
  const __m128i a_reg = _mm_loadl_epi64((const __m128i *)a);
  const __m128i b_reg = _mm_loadl_epi64((const __m128i *)b);

  const __m128i a_first = _mm_cvtepu8_epi16(a_reg);
  const __m128i b_first = _mm_cvtepu8_epi16(b_reg);

  __m128i dist_first;

  dist_first = _mm_sub_epi16(a_first, b_first);
  dist_first = _mm_mullo_epi16(dist_first, dist_first);

  _mm_storeu_si128((__m128i *)dst, dist_first);
}

static INLINE void store_dist_16(const uint8_t *a, const uint8_t *b,
                                 uint16_t *dst) {
  const __m128i zero = _mm_setzero_si128();
  const __m128i a_reg = _mm_loadu_si128((const __m128i *)a);
  const __m128i b_reg = _mm_loadu_si128((const __m128i *)b);

  const __m128i a_first = _mm_cvtepu8_epi16(a_reg);
  const __m128i a_second = _mm_unpackhi_epi8(a_reg, zero);
  const __m128i b_first = _mm_cvtepu8_epi16(b_reg);
  const __m128i b_second = _mm_unpackhi_epi8(b_reg, zero);

  __m128i dist_first, dist_second;

  dist_first = _mm_sub_epi16(a_first, b_first);
  dist_second = _mm_sub_epi16(a_second, b_second);
  dist_first = _mm_mullo_epi16(dist_first, dist_first);
  dist_second = _mm_mullo_epi16(dist_second, dist_second);

  _mm_storeu_si128((__m128i *)dst, dist_first);
  _mm_storeu_si128((__m128i *)(dst + 8), dist_second);
}

static INLINE void read_dist_8(const uint16_t *dist, __m128i *dist_reg) {
  *dist_reg = _mm_loadu_si128((const __m128i *)dist);
}

static INLINE void read_dist_16(const uint16_t *dist, __m128i *reg_first,
                                __m128i *reg_second) {
  read_dist_8(dist, reg_first);
  read_dist_8(dist + 8, reg_second);
}

// Average the value based on the number of values summed (9 for pixels away
// from the border, 4 for pixels in corners, and 6 for other edge values).
//
// Add in the rounding factor and shift, clamp to 16, invert and shift. Multiply
// by weight.
static __m128i average_8(__m128i sum, const __m128i *mul_constants,
                         const int strength, const int rounding,
                         const int weight) {
  // _mm_srl_epi16 uses the lower 64 bit value for the shift.
  const __m128i strength_u128 = _mm_set_epi32(0, 0, 0, strength);
  const __m128i rounding_u16 = _mm_set1_epi16(rounding);
  const __m128i weight_u16 = _mm_set1_epi16(weight);
  const __m128i sixteen = _mm_set1_epi16(16);

  // modifier * 3 / index;
  sum = _mm_mulhi_epu16(sum, *mul_constants);

  sum = _mm_adds_epu16(sum, rounding_u16);
  sum = _mm_srl_epi16(sum, strength_u128);

  // The maximum input to this comparison is UINT16_MAX * NEIGHBOR_CONSTANT_4
  // >> 16 (also NEIGHBOR_CONSTANT_4 -1) which is 49151 / 0xbfff / -16385
  // So this needs to use the epu16 version which did not come until SSE4.
  sum = _mm_min_epu16(sum, sixteen);

  sum = _mm_sub_epi16(sixteen, sum);

  return _mm_mullo_epi16(sum, weight_u16);
}

static __m128i average_4_4(__m128i sum, const __m128i *mul_constants,
                           const int strength, const int rounding,
                           const int weight_0, const int weight_1) {
  // _mm_srl_epi16 uses the lower 64 bit value for the shift.
  const __m128i strength_u128 = _mm_set_epi32(0, 0, 0, strength);
  const __m128i rounding_u16 = _mm_set1_epi16(rounding);
  const __m128i weight_u16 =
      _mm_setr_epi16(weight_0, weight_0, weight_0, weight_0, weight_1, weight_1,
                     weight_1, weight_1);
  const __m128i sixteen = _mm_set1_epi16(16);

  // modifier * 3 / index;
  sum = _mm_mulhi_epu16(sum, *mul_constants);

  sum = _mm_adds_epu16(sum, rounding_u16);
  sum = _mm_srl_epi16(sum, strength_u128);

  // The maximum input to this comparison is UINT16_MAX * NEIGHBOR_CONSTANT_4
  // >> 16 (also NEIGHBOR_CONSTANT_4 -1) which is 49151 / 0xbfff / -16385
  // So this needs to use the epu16 version which did not come until SSE4.
  sum = _mm_min_epu16(sum, sixteen);

  sum = _mm_sub_epi16(sixteen, sum);

  return _mm_mullo_epi16(sum, weight_u16);
}

static INLINE void average_16(__m128i *sum_0_u16, __m128i *sum_1_u16,
                              const __m128i *mul_constants_0,
                              const __m128i *mul_constants_1,
                              const int strength, const int rounding,
                              const int weight) {
  const __m128i strength_u128 = _mm_set_epi32(0, 0, 0, strength);
  const __m128i rounding_u16 = _mm_set1_epi16(rounding);
  const __m128i weight_u16 = _mm_set1_epi16(weight);
  const __m128i sixteen = _mm_set1_epi16(16);
  __m128i input_0, input_1;

  input_0 = _mm_mulhi_epu16(*sum_0_u16, *mul_constants_0);
  input_0 = _mm_adds_epu16(input_0, rounding_u16);

  input_1 = _mm_mulhi_epu16(*sum_1_u16, *mul_constants_1);
  input_1 = _mm_adds_epu16(input_1, rounding_u16);

  input_0 = _mm_srl_epi16(input_0, strength_u128);
  input_1 = _mm_srl_epi16(input_1, strength_u128);

  input_0 = _mm_min_epu16(input_0, sixteen);
  input_1 = _mm_min_epu16(input_1, sixteen);
  input_0 = _mm_sub_epi16(sixteen, input_0);
  input_1 = _mm_sub_epi16(sixteen, input_1);

  *sum_0_u16 = _mm_mullo_epi16(input_0, weight_u16);
  *sum_1_u16 = _mm_mullo_epi16(input_1, weight_u16);
}

// Add 'sum_u16' to 'count'. Multiply by 'pred' and add to 'accumulator.'
static void accumulate_and_store_8(const __m128i sum_u16, const uint8_t *pred,
                                   uint16_t *count, uint32_t *accumulator) {
  const __m128i pred_u8 = _mm_loadl_epi64((const __m128i *)pred);
  const __m128i zero = _mm_setzero_si128();
  __m128i count_u16 = _mm_loadu_si128((const __m128i *)count);
  __m128i pred_u16 = _mm_cvtepu8_epi16(pred_u8);
  __m128i pred_0_u32, pred_1_u32;
  __m128i accum_0_u32, accum_1_u32;

  count_u16 = _mm_adds_epu16(count_u16, sum_u16);
  _mm_storeu_si128((__m128i *)count, count_u16);

  pred_u16 = _mm_mullo_epi16(sum_u16, pred_u16);

  pred_0_u32 = _mm_cvtepu16_epi32(pred_u16);
  pred_1_u32 = _mm_unpackhi_epi16(pred_u16, zero);

  accum_0_u32 = _mm_loadu_si128((const __m128i *)accumulator);
  accum_1_u32 = _mm_loadu_si128((const __m128i *)(accumulator + 4));

  accum_0_u32 = _mm_add_epi32(pred_0_u32, accum_0_u32);
  accum_1_u32 = _mm_add_epi32(pred_1_u32, accum_1_u32);

  _mm_storeu_si128((__m128i *)accumulator, accum_0_u32);
  _mm_storeu_si128((__m128i *)(accumulator + 4), accum_1_u32);
}

static INLINE void accumulate_and_store_16(const __m128i sum_0_u16,
                                           const __m128i sum_1_u16,
                                           const uint8_t *pred, uint16_t *count,
                                           uint32_t *accumulator) {
  const __m128i pred_u8 = _mm_loadu_si128((const __m128i *)pred);
  const __m128i zero = _mm_setzero_si128();
  __m128i count_0_u16 = _mm_loadu_si128((const __m128i *)count),
          count_1_u16 = _mm_loadu_si128((const __m128i *)(count + 8));
  __m128i pred_0_u16 = _mm_cvtepu8_epi16(pred_u8),
          pred_1_u16 = _mm_unpackhi_epi8(pred_u8, zero);
  __m128i pred_0_u32, pred_1_u32, pred_2_u32, pred_3_u32;
  __m128i accum_0_u32, accum_1_u32, accum_2_u32, accum_3_u32;

  count_0_u16 = _mm_adds_epu16(count_0_u16, sum_0_u16);
  _mm_storeu_si128((__m128i *)count, count_0_u16);

  count_1_u16 = _mm_adds_epu16(count_1_u16, sum_1_u16);
  _mm_storeu_si128((__m128i *)(count + 8), count_1_u16);

  pred_0_u16 = _mm_mullo_epi16(sum_0_u16, pred_0_u16);
  pred_1_u16 = _mm_mullo_epi16(sum_1_u16, pred_1_u16);

  pred_0_u32 = _mm_cvtepu16_epi32(pred_0_u16);
  pred_1_u32 = _mm_unpackhi_epi16(pred_0_u16, zero);
  pred_2_u32 = _mm_cvtepu16_epi32(pred_1_u16);
  pred_3_u32 = _mm_unpackhi_epi16(pred_1_u16, zero);

  accum_0_u32 = _mm_loadu_si128((const __m128i *)accumulator);
  accum_1_u32 = _mm_loadu_si128((const __m128i *)(accumulator + 4));
  accum_2_u32 = _mm_loadu_si128((const __m128i *)(accumulator + 8));
  accum_3_u32 = _mm_loadu_si128((const __m128i *)(accumulator + 12));

  accum_0_u32 = _mm_add_epi32(pred_0_u32, accum_0_u32);
  accum_1_u32 = _mm_add_epi32(pred_1_u32, accum_1_u32);
  accum_2_u32 = _mm_add_epi32(pred_2_u32, accum_2_u32);
  accum_3_u32 = _mm_add_epi32(pred_3_u32, accum_3_u32);

  _mm_storeu_si128((__m128i *)accumulator, accum_0_u32);
  _mm_storeu_si128((__m128i *)(accumulator + 4), accum_1_u32);
  _mm_storeu_si128((__m128i *)(accumulator + 8), accum_2_u32);
  _mm_storeu_si128((__m128i *)(accumulator + 12), accum_3_u32);
}

// Read in 8 pixels from y_dist. For each index i, compute y_dist[i-1] +
// y_dist[i] + y_dist[i+1] and store in sum as 16-bit unsigned int.
static INLINE void get_sum_8(const uint16_t *y_dist, __m128i *sum) {
  __m128i dist_reg, dist_left, dist_right;

  dist_reg = _mm_loadu_si128((const __m128i *)y_dist);
  dist_left = _mm_loadu_si128((const __m128i *)(y_dist - 1));
  dist_right = _mm_loadu_si128((const __m128i *)(y_dist + 1));

  *sum = _mm_adds_epu16(dist_reg, dist_left);
  *sum = _mm_adds_epu16(*sum, dist_right);
}

// Read in 16 pixels from y_dist. For each index i, compute y_dist[i-1] +
// y_dist[i] + y_dist[i+1]. Store the result for first 8 pixels in sum_first and
// the rest in sum_second.
static INLINE void get_sum_16(const uint16_t *y_dist, __m128i *sum_first,
                              __m128i *sum_second) {
  get_sum_8(y_dist, sum_first);
  get_sum_8(y_dist + 8, sum_second);
}

// Read in a row of chroma values corresponds to a row of 16 luma values.
static INLINE void read_chroma_dist_row_16(int ss_x, const uint16_t *u_dist,
                                           const uint16_t *v_dist,
                                           __m128i *u_first, __m128i *u_second,
                                           __m128i *v_first,
                                           __m128i *v_second) {
  if (!ss_x) {
    // If there is no chroma subsampling in the horizontal direction, then we
    // need to load 16 entries from chroma.
    read_dist_16(u_dist, u_first, u_second);
    read_dist_16(v_dist, v_first, v_second);
  } else {  // ss_x == 1
    // Otherwise, we only need to load 8 entries
    __m128i u_reg, v_reg;

    read_dist_8(u_dist, &u_reg);

    *u_first = _mm_unpacklo_epi16(u_reg, u_reg);
    *u_second = _mm_unpackhi_epi16(u_reg, u_reg);

    read_dist_8(v_dist, &v_reg);

    *v_first = _mm_unpacklo_epi16(v_reg, v_reg);
    *v_second = _mm_unpackhi_epi16(v_reg, v_reg);
  }
}

// Horizontal add unsigned 16-bit ints in src and store them as signed 32-bit
// int in dst.
static INLINE void hadd_epu16(__m128i *src, __m128i *dst) {
  const __m128i zero = _mm_setzero_si128();
  const __m128i shift_right = _mm_srli_si128(*src, 2);

  const __m128i odd = _mm_blend_epi16(shift_right, zero, 170);
  const __m128i even = _mm_blend_epi16(*src, zero, 170);

  *dst = _mm_add_epi32(even, odd);
}

// Add a row of luma distortion to 8 corresponding chroma mods.
static INLINE void add_luma_dist_to_8_chroma_mod(const uint16_t *y_dist,
                                                 int ss_x, int ss_y,
                                                 __m128i *u_mod,
                                                 __m128i *v_mod) {
  __m128i y_reg;
  if (!ss_x) {
    read_dist_8(y_dist, &y_reg);
    if (ss_y == 1) {
      __m128i y_tmp;
      read_dist_8(y_dist + DIST_STRIDE, &y_tmp);

      y_reg = _mm_adds_epu16(y_reg, y_tmp);
    }
  } else {
    __m128i y_first, y_second;
    read_dist_16(y_dist, &y_first, &y_second);
    if (ss_y == 1) {
      __m128i y_tmp_0, y_tmp_1;
      read_dist_16(y_dist + DIST_STRIDE, &y_tmp_0, &y_tmp_1);

      y_first = _mm_adds_epu16(y_first, y_tmp_0);
      y_second = _mm_adds_epu16(y_second, y_tmp_1);
    }

    hadd_epu16(&y_first, &y_first);
    hadd_epu16(&y_second, &y_second);

    y_reg = _mm_packus_epi32(y_first, y_second);
  }

  *u_mod = _mm_adds_epu16(*u_mod, y_reg);
  *v_mod = _mm_adds_epu16(*v_mod, y_reg);
}

// Apply temporal filter to the luma components. This performs temporal
// filtering on a luma block of 16 X block_height. Use blk_fw as an array of
// size 4 for the weights for each of the 4 subblocks if blk_fw is not NULL,
// else use top_weight for top half, and bottom weight for bottom half.
static void apply_temporal_filter_luma_16(
    const uint8_t *y_src, int y_src_stride, const uint8_t *y_pre,
    int y_pre_stride, const uint8_t *u_src, const uint8_t *v_src,
    int uv_src_stride, const uint8_t *u_pre, const uint8_t *v_pre,
    int uv_pre_stride, unsigned int block_width, unsigned int block_height,
    int ss_x, int ss_y, int strength, int use_whole_blk, uint32_t *y_accum,
    uint16_t *y_count, const uint16_t *y_dist, const uint16_t *u_dist,
    const uint16_t *v_dist, const int16_t *const *neighbors_first,
    const int16_t *const *neighbors_second, int top_weight, int bottom_weight,
    const int *blk_fw) {
  const int rounding = (1 << strength) >> 1;
  int weight = top_weight;

  __m128i mul_first, mul_second;

  __m128i sum_row_1_first, sum_row_1_second;
  __m128i sum_row_2_first, sum_row_2_second;
  __m128i sum_row_3_first, sum_row_3_second;

  __m128i u_first, u_second;
  __m128i v_first, v_second;

  __m128i sum_row_first;
  __m128i sum_row_second;

  // Loop variables
  unsigned int h;

  assert(strength >= 0);
  assert(strength <= 6);

  assert(block_width == 16);

  (void)block_width;

  // First row
  mul_first = _mm_loadu_si128((const __m128i *)neighbors_first[0]);
  mul_second = _mm_loadu_si128((const __m128i *)neighbors_second[0]);

  // Add luma values
  get_sum_16(y_dist, &sum_row_2_first, &sum_row_2_second);
  get_sum_16(y_dist + DIST_STRIDE, &sum_row_3_first, &sum_row_3_second);

  sum_row_first = _mm_adds_epu16(sum_row_2_first, sum_row_3_first);
  sum_row_second = _mm_adds_epu16(sum_row_2_second, sum_row_3_second);

  // Add chroma values
  read_chroma_dist_row_16(ss_x, u_dist, v_dist, &u_first, &u_second, &v_first,
                          &v_second);

  sum_row_first = _mm_adds_epu16(sum_row_first, u_first);
  sum_row_second = _mm_adds_epu16(sum_row_second, u_second);

  sum_row_first = _mm_adds_epu16(sum_row_first, v_first);
  sum_row_second = _mm_adds_epu16(sum_row_second, v_second);

  // Get modifier and store result
  if (blk_fw) {
    sum_row_first =
        average_8(sum_row_first, &mul_first, strength, rounding, blk_fw[0]);
    sum_row_second =
        average_8(sum_row_second, &mul_second, strength, rounding, blk_fw[1]);
  } else {
    average_16(&sum_row_first, &sum_row_second, &mul_first, &mul_second,
               strength, rounding, weight);
  }
  accumulate_and_store_16(sum_row_first, sum_row_second, y_pre, y_count,
                          y_accum);

  y_src += y_src_stride;
  y_pre += y_pre_stride;
  y_count += y_pre_stride;
  y_accum += y_pre_stride;
  y_dist += DIST_STRIDE;

  u_src += uv_src_stride;
  u_pre += uv_pre_stride;
  u_dist += DIST_STRIDE;
  v_src += uv_src_stride;
  v_pre += uv_pre_stride;
  v_dist += DIST_STRIDE;

  // Then all the rows except the last one
  mul_first = _mm_loadu_si128((const __m128i *)neighbors_first[1]);
  mul_second = _mm_loadu_si128((const __m128i *)neighbors_second[1]);

  for (h = 1; h < block_height - 1; ++h) {
    // Move the weight to bottom half
    if (!use_whole_blk && h == block_height / 2) {
      if (blk_fw) {
        blk_fw += 2;
      } else {
        weight = bottom_weight;
      }
    }
    // Shift the rows up
    sum_row_1_first = sum_row_2_first;
    sum_row_1_second = sum_row_2_second;
    sum_row_2_first = sum_row_3_first;
    sum_row_2_second = sum_row_3_second;

    // Add luma values to the modifier
    sum_row_first = _mm_adds_epu16(sum_row_1_first, sum_row_2_first);
    sum_row_second = _mm_adds_epu16(sum_row_1_second, sum_row_2_second);

    get_sum_16(y_dist + DIST_STRIDE, &sum_row_3_first, &sum_row_3_second);

    sum_row_first = _mm_adds_epu16(sum_row_first, sum_row_3_first);
    sum_row_second = _mm_adds_epu16(sum_row_second, sum_row_3_second);

    // Add chroma values to the modifier
    if (ss_y == 0 || h % 2 == 0) {
      // Only calculate the new chroma distortion if we are at a pixel that
      // corresponds to a new chroma row
      read_chroma_dist_row_16(ss_x, u_dist, v_dist, &u_first, &u_second,
                              &v_first, &v_second);

      u_src += uv_src_stride;
      u_pre += uv_pre_stride;
      u_dist += DIST_STRIDE;
      v_src += uv_src_stride;
      v_pre += uv_pre_stride;
      v_dist += DIST_STRIDE;
    }

    sum_row_first = _mm_adds_epu16(sum_row_first, u_first);
    sum_row_second = _mm_adds_epu16(sum_row_second, u_second);
    sum_row_first = _mm_adds_epu16(sum_row_first, v_first);
    sum_row_second = _mm_adds_epu16(sum_row_second, v_second);

    // Get modifier and store result
    if (blk_fw) {
      sum_row_first =
          average_8(sum_row_first, &mul_first, strength, rounding, blk_fw[0]);
      sum_row_second =
          average_8(sum_row_second, &mul_second, strength, rounding, blk_fw[1]);
    } else {
      average_16(&sum_row_first, &sum_row_second, &mul_first, &mul_second,
                 strength, rounding, weight);
    }
    accumulate_and_store_16(sum_row_first, sum_row_second, y_pre, y_count,
                            y_accum);

    y_src += y_src_stride;
    y_pre += y_pre_stride;
    y_count += y_pre_stride;
    y_accum += y_pre_stride;
    y_dist += DIST_STRIDE;
  }

  // The last row
  mul_first = _mm_loadu_si128((const __m128i *)neighbors_first[0]);
  mul_second = _mm_loadu_si128((const __m128i *)neighbors_second[0]);

  // Shift the rows up
  sum_row_1_first = sum_row_2_first;
  sum_row_1_second = sum_row_2_second;
  sum_row_2_first = sum_row_3_first;
  sum_row_2_second = sum_row_3_second;

  // Add luma values to the modifier
  sum_row_first = _mm_adds_epu16(sum_row_1_first, sum_row_2_first);
  sum_row_second = _mm_adds_epu16(sum_row_1_second, sum_row_2_second);

  // Add chroma values to the modifier
  if (ss_y == 0) {
    // Only calculate the new chroma distortion if we are at a pixel that
    // corresponds to a new chroma row
    read_chroma_dist_row_16(ss_x, u_dist, v_dist, &u_first, &u_second, &v_first,
                            &v_second);
  }

  sum_row_first = _mm_adds_epu16(sum_row_first, u_first);
  sum_row_second = _mm_adds_epu16(sum_row_second, u_second);
  sum_row_first = _mm_adds_epu16(sum_row_first, v_first);
  sum_row_second = _mm_adds_epu16(sum_row_second, v_second);

  // Get modifier and store result
  if (blk_fw) {
    sum_row_first =
        average_8(sum_row_first, &mul_first, strength, rounding, blk_fw[0]);
    sum_row_second =
        average_8(sum_row_second, &mul_second, strength, rounding, blk_fw[1]);
  } else {
    average_16(&sum_row_first, &sum_row_second, &mul_first, &mul_second,
               strength, rounding, weight);
  }
  accumulate_and_store_16(sum_row_first, sum_row_second, y_pre, y_count,
                          y_accum);
}

// Perform temporal filter for the luma component.
static void apply_temporal_filter_luma(
    const uint8_t *y_src, int y_src_stride, const uint8_t *y_pre,
    int y_pre_stride, const uint8_t *u_src, const uint8_t *v_src,
    int uv_src_stride, const uint8_t *u_pre, const uint8_t *v_pre,
    int uv_pre_stride, unsigned int block_width, unsigned int block_height,
    int ss_x, int ss_y, int strength, const int *blk_fw, int use_whole_blk,
    uint32_t *y_accum, uint16_t *y_count, const uint16_t *y_dist,
    const uint16_t *u_dist, const uint16_t *v_dist) {
  unsigned int blk_col = 0, uv_blk_col = 0;
  const unsigned int blk_col_step = 16, uv_blk_col_step = 16 >> ss_x;
  const unsigned int mid_width = block_width >> 1,
                     last_width = block_width - blk_col_step;
  int top_weight = blk_fw[0],
      bottom_weight = use_whole_blk ? blk_fw[0] : blk_fw[2];
  const int16_t *const *neighbors_first;
  const int16_t *const *neighbors_second;

  if (block_width == 16) {
    // Special Case: The blockwidth is 16 and we are operating on a row of 16
    // chroma pixels. In this case, we can't use the usualy left-midle-right
    // pattern. We also don't support splitting now.
    neighbors_first = LUMA_LEFT_COLUMN_NEIGHBORS;
    neighbors_second = LUMA_RIGHT_COLUMN_NEIGHBORS;
    if (use_whole_blk) {
      apply_temporal_filter_luma_16(
          y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
          u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride,
          u_pre + uv_blk_col, v_pre + uv_blk_col, uv_pre_stride, 16,
          block_height, ss_x, ss_y, strength, use_whole_blk, y_accum + blk_col,
          y_count + blk_col, y_dist + blk_col, u_dist + uv_blk_col,
          v_dist + uv_blk_col, neighbors_first, neighbors_second, top_weight,
          bottom_weight, NULL);
    } else {
      apply_temporal_filter_luma_16(
          y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
          u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride,
          u_pre + uv_blk_col, v_pre + uv_blk_col, uv_pre_stride, 16,
          block_height, ss_x, ss_y, strength, use_whole_blk, y_accum + blk_col,
          y_count + blk_col, y_dist + blk_col, u_dist + uv_blk_col,
          v_dist + uv_blk_col, neighbors_first, neighbors_second, 0, 0, blk_fw);
    }

    return;
  }

  // Left
  neighbors_first = LUMA_LEFT_COLUMN_NEIGHBORS;
  neighbors_second = LUMA_MIDDLE_COLUMN_NEIGHBORS;
  apply_temporal_filter_luma_16(
      y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
      u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride, u_pre + uv_blk_col,
      v_pre + uv_blk_col, uv_pre_stride, 16, block_height, ss_x, ss_y, strength,
      use_whole_blk, y_accum + blk_col, y_count + blk_col, y_dist + blk_col,
      u_dist + uv_blk_col, v_dist + uv_blk_col, neighbors_first,
      neighbors_second, top_weight, bottom_weight, NULL);

  blk_col += blk_col_step;
  uv_blk_col += uv_blk_col_step;

  // Middle First
  neighbors_first = LUMA_MIDDLE_COLUMN_NEIGHBORS;
  for (; blk_col < mid_width;
       blk_col += blk_col_step, uv_blk_col += uv_blk_col_step) {
    apply_temporal_filter_luma_16(
        y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
        u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride,
        u_pre + uv_blk_col, v_pre + uv_blk_col, uv_pre_stride, 16, block_height,
        ss_x, ss_y, strength, use_whole_blk, y_accum + blk_col,
        y_count + blk_col, y_dist + blk_col, u_dist + uv_blk_col,
        v_dist + uv_blk_col, neighbors_first, neighbors_second, top_weight,
        bottom_weight, NULL);
  }

  if (!use_whole_blk) {
    top_weight = blk_fw[1];
    bottom_weight = blk_fw[3];
  }

  // Middle Second
  for (; blk_col < last_width;
       blk_col += blk_col_step, uv_blk_col += uv_blk_col_step) {
    apply_temporal_filter_luma_16(
        y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
        u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride,
        u_pre + uv_blk_col, v_pre + uv_blk_col, uv_pre_stride, 16, block_height,
        ss_x, ss_y, strength, use_whole_blk, y_accum + blk_col,
        y_count + blk_col, y_dist + blk_col, u_dist + uv_blk_col,
        v_dist + uv_blk_col, neighbors_first, neighbors_second, top_weight,
        bottom_weight, NULL);
  }

  // Right
  neighbors_second = LUMA_RIGHT_COLUMN_NEIGHBORS;
  apply_temporal_filter_luma_16(
      y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
      u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride, u_pre + uv_blk_col,
      v_pre + uv_blk_col, uv_pre_stride, 16, block_height, ss_x, ss_y, strength,
      use_whole_blk, y_accum + blk_col, y_count + blk_col, y_dist + blk_col,
      u_dist + uv_blk_col, v_dist + uv_blk_col, neighbors_first,
      neighbors_second, top_weight, bottom_weight, NULL);
}

// Apply temporal filter to the chroma components. This performs temporal
// filtering on a chroma block of 8 X uv_height. If blk_fw is not NULL, use
// blk_fw as an array of size 4 for the weights for each of the 4 subblocks,
// else use top_weight for top half, and bottom weight for bottom half.
static void apply_temporal_filter_chroma_8(
    const uint8_t *y_src, int y_src_stride, const uint8_t *y_pre,
    int y_pre_stride, const uint8_t *u_src, const uint8_t *v_src,
    int uv_src_stride, const uint8_t *u_pre, const uint8_t *v_pre,
    int uv_pre_stride, unsigned int uv_block_width,
    unsigned int uv_block_height, int ss_x, int ss_y, int strength,
    uint32_t *u_accum, uint16_t *u_count, uint32_t *v_accum, uint16_t *v_count,
    const uint16_t *y_dist, const uint16_t *u_dist, const uint16_t *v_dist,
    const int16_t *const *neighbors, int top_weight, int bottom_weight,
    const int *blk_fw) {
  const int rounding = (1 << strength) >> 1;
  int weight = top_weight;

  __m128i mul;

  __m128i u_sum_row_1, u_sum_row_2, u_sum_row_3;
  __m128i v_sum_row_1, v_sum_row_2, v_sum_row_3;

  __m128i u_sum_row, v_sum_row;

  // Loop variable
  unsigned int h;

  (void)uv_block_width;

  // First row
  mul = _mm_loadu_si128((const __m128i *)neighbors[0]);

  // Add chroma values
  get_sum_8(u_dist, &u_sum_row_2);
  get_sum_8(u_dist + DIST_STRIDE, &u_sum_row_3);

  u_sum_row = _mm_adds_epu16(u_sum_row_2, u_sum_row_3);

  get_sum_8(v_dist, &v_sum_row_2);
  get_sum_8(v_dist + DIST_STRIDE, &v_sum_row_3);

  v_sum_row = _mm_adds_epu16(v_sum_row_2, v_sum_row_3);

  // Add luma values
  add_luma_dist_to_8_chroma_mod(y_dist, ss_x, ss_y, &u_sum_row, &v_sum_row);

  // Get modifier and store result
  if (blk_fw) {
    u_sum_row =
        average_4_4(u_sum_row, &mul, strength, rounding, blk_fw[0], blk_fw[1]);
    v_sum_row =
        average_4_4(v_sum_row, &mul, strength, rounding, blk_fw[0], blk_fw[1]);
  } else {
    u_sum_row = average_8(u_sum_row, &mul, strength, rounding, weight);
    v_sum_row = average_8(v_sum_row, &mul, strength, rounding, weight);
  }
  accumulate_and_store_8(u_sum_row, u_pre, u_count, u_accum);
  accumulate_and_store_8(v_sum_row, v_pre, v_count, v_accum);

  u_src += uv_src_stride;
  u_pre += uv_pre_stride;
  u_dist += DIST_STRIDE;
  v_src += uv_src_stride;
  v_pre += uv_pre_stride;
  v_dist += DIST_STRIDE;
  u_count += uv_pre_stride;
  u_accum += uv_pre_stride;
  v_count += uv_pre_stride;
  v_accum += uv_pre_stride;

  y_src += y_src_stride * (1 + ss_y);
  y_pre += y_pre_stride * (1 + ss_y);
  y_dist += DIST_STRIDE * (1 + ss_y);

  // Then all the rows except the last one
  mul = _mm_loadu_si128((const __m128i *)neighbors[1]);

  for (h = 1; h < uv_block_height - 1; ++h) {
    // Move the weight pointer to the bottom half of the blocks
    if (h == uv_block_height / 2) {
      if (blk_fw) {
        blk_fw += 2;
      } else {
        weight = bottom_weight;
      }
    }

    // Shift the rows up
    u_sum_row_1 = u_sum_row_2;
    u_sum_row_2 = u_sum_row_3;

    v_sum_row_1 = v_sum_row_2;
    v_sum_row_2 = v_sum_row_3;

    // Add chroma values
    u_sum_row = _mm_adds_epu16(u_sum_row_1, u_sum_row_2);
    get_sum_8(u_dist + DIST_STRIDE, &u_sum_row_3);
    u_sum_row = _mm_adds_epu16(u_sum_row, u_sum_row_3);

    v_sum_row = _mm_adds_epu16(v_sum_row_1, v_sum_row_2);
    get_sum_8(v_dist + DIST_STRIDE, &v_sum_row_3);
    v_sum_row = _mm_adds_epu16(v_sum_row, v_sum_row_3);

    // Add luma values
    add_luma_dist_to_8_chroma_mod(y_dist, ss_x, ss_y, &u_sum_row, &v_sum_row);

    // Get modifier and store result
    if (blk_fw) {
      u_sum_row = average_4_4(u_sum_row, &mul, strength, rounding, blk_fw[0],
                              blk_fw[1]);
      v_sum_row = average_4_4(v_sum_row, &mul, strength, rounding, blk_fw[0],
                              blk_fw[1]);
    } else {
      u_sum_row = average_8(u_sum_row, &mul, strength, rounding, weight);
      v_sum_row = average_8(v_sum_row, &mul, strength, rounding, weight);
    }

    accumulate_and_store_8(u_sum_row, u_pre, u_count, u_accum);
    accumulate_and_store_8(v_sum_row, v_pre, v_count, v_accum);

    u_src += uv_src_stride;
    u_pre += uv_pre_stride;
    u_dist += DIST_STRIDE;
    v_src += uv_src_stride;
    v_pre += uv_pre_stride;
    v_dist += DIST_STRIDE;
    u_count += uv_pre_stride;
    u_accum += uv_pre_stride;
    v_count += uv_pre_stride;
    v_accum += uv_pre_stride;

    y_src += y_src_stride * (1 + ss_y);
    y_pre += y_pre_stride * (1 + ss_y);
    y_dist += DIST_STRIDE * (1 + ss_y);
  }

  // The last row
  mul = _mm_loadu_si128((const __m128i *)neighbors[0]);

  // Shift the rows up
  u_sum_row_1 = u_sum_row_2;
  u_sum_row_2 = u_sum_row_3;

  v_sum_row_1 = v_sum_row_2;
  v_sum_row_2 = v_sum_row_3;

  // Add chroma values
  u_sum_row = _mm_adds_epu16(u_sum_row_1, u_sum_row_2);
  v_sum_row = _mm_adds_epu16(v_sum_row_1, v_sum_row_2);

  // Add luma values
  add_luma_dist_to_8_chroma_mod(y_dist, ss_x, ss_y, &u_sum_row, &v_sum_row);

  // Get modifier and store result
  if (blk_fw) {
    u_sum_row =
        average_4_4(u_sum_row, &mul, strength, rounding, blk_fw[0], blk_fw[1]);
    v_sum_row =
        average_4_4(v_sum_row, &mul, strength, rounding, blk_fw[0], blk_fw[1]);
  } else {
    u_sum_row = average_8(u_sum_row, &mul, strength, rounding, weight);
    v_sum_row = average_8(v_sum_row, &mul, strength, rounding, weight);
  }

  accumulate_and_store_8(u_sum_row, u_pre, u_count, u_accum);
  accumulate_and_store_8(v_sum_row, v_pre, v_count, v_accum);
}

// Perform temporal filter for the chroma components.
static void apply_temporal_filter_chroma(
    const uint8_t *y_src, int y_src_stride, const uint8_t *y_pre,
    int y_pre_stride, const uint8_t *u_src, const uint8_t *v_src,
    int uv_src_stride, const uint8_t *u_pre, const uint8_t *v_pre,
    int uv_pre_stride, unsigned int block_width, unsigned int block_height,
    int ss_x, int ss_y, int strength, const int *blk_fw, int use_whole_blk,
    uint32_t *u_accum, uint16_t *u_count, uint32_t *v_accum, uint16_t *v_count,
    const uint16_t *y_dist, const uint16_t *u_dist, const uint16_t *v_dist) {
  const unsigned int uv_width = block_width >> ss_x,
                     uv_height = block_height >> ss_y;

  unsigned int blk_col = 0, uv_blk_col = 0;
  const unsigned int uv_blk_col_step = 8, blk_col_step = 8 << ss_x;
  const unsigned int uv_mid_width = uv_width >> 1,
                     uv_last_width = uv_width - uv_blk_col_step;
  int top_weight = blk_fw[0],
      bottom_weight = use_whole_blk ? blk_fw[0] : blk_fw[2];
  const int16_t *const *neighbors;

  if (uv_width == 8) {
    // Special Case: We are subsampling in x direction on a 16x16 block. Since
    // we are operating on a row of 8 chroma pixels, we can't use the usual
    // left-middle-right pattern.
    assert(ss_x);

    if (ss_y) {
      neighbors = CHROMA_DOUBLE_SS_SINGLE_COLUMN_NEIGHBORS;
    } else {
      neighbors = CHROMA_SINGLE_SS_SINGLE_COLUMN_NEIGHBORS;
    }

    if (use_whole_blk) {
      apply_temporal_filter_chroma_8(
          y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
          u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride,
          u_pre + uv_blk_col, v_pre + uv_blk_col, uv_pre_stride, uv_width,
          uv_height, ss_x, ss_y, strength, u_accum + uv_blk_col,
          u_count + uv_blk_col, v_accum + uv_blk_col, v_count + uv_blk_col,
          y_dist + blk_col, u_dist + uv_blk_col, v_dist + uv_blk_col, neighbors,
          top_weight, bottom_weight, NULL);
    } else {
      apply_temporal_filter_chroma_8(
          y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
          u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride,
          u_pre + uv_blk_col, v_pre + uv_blk_col, uv_pre_stride, uv_width,
          uv_height, ss_x, ss_y, strength, u_accum + uv_blk_col,
          u_count + uv_blk_col, v_accum + uv_blk_col, v_count + uv_blk_col,
          y_dist + blk_col, u_dist + uv_blk_col, v_dist + uv_blk_col, neighbors,
          0, 0, blk_fw);
    }

    return;
  }

  // Left
  if (ss_x && ss_y) {
    neighbors = CHROMA_DOUBLE_SS_LEFT_COLUMN_NEIGHBORS;
  } else if (ss_x || ss_y) {
    neighbors = CHROMA_SINGLE_SS_LEFT_COLUMN_NEIGHBORS;
  } else {
    neighbors = CHROMA_NO_SS_LEFT_COLUMN_NEIGHBORS;
  }

  apply_temporal_filter_chroma_8(
      y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
      u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride, u_pre + uv_blk_col,
      v_pre + uv_blk_col, uv_pre_stride, uv_width, uv_height, ss_x, ss_y,
      strength, u_accum + uv_blk_col, u_count + uv_blk_col,
      v_accum + uv_blk_col, v_count + uv_blk_col, y_dist + blk_col,
      u_dist + uv_blk_col, v_dist + uv_blk_col, neighbors, top_weight,
      bottom_weight, NULL);

  blk_col += blk_col_step;
  uv_blk_col += uv_blk_col_step;

  // Middle First
  if (ss_x && ss_y) {
    neighbors = CHROMA_DOUBLE_SS_MIDDLE_COLUMN_NEIGHBORS;
  } else if (ss_x || ss_y) {
    neighbors = CHROMA_SINGLE_SS_MIDDLE_COLUMN_NEIGHBORS;
  } else {
    neighbors = CHROMA_NO_SS_MIDDLE_COLUMN_NEIGHBORS;
  }

  for (; uv_blk_col < uv_mid_width;
       blk_col += blk_col_step, uv_blk_col += uv_blk_col_step) {
    apply_temporal_filter_chroma_8(
        y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
        u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride,
        u_pre + uv_blk_col, v_pre + uv_blk_col, uv_pre_stride, uv_width,
        uv_height, ss_x, ss_y, strength, u_accum + uv_blk_col,
        u_count + uv_blk_col, v_accum + uv_blk_col, v_count + uv_blk_col,
        y_dist + blk_col, u_dist + uv_blk_col, v_dist + uv_blk_col, neighbors,
        top_weight, bottom_weight, NULL);
  }

  if (!use_whole_blk) {
    top_weight = blk_fw[1];
    bottom_weight = blk_fw[3];
  }

  // Middle Second
  for (; uv_blk_col < uv_last_width;
       blk_col += blk_col_step, uv_blk_col += uv_blk_col_step) {
    apply_temporal_filter_chroma_8(
        y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
        u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride,
        u_pre + uv_blk_col, v_pre + uv_blk_col, uv_pre_stride, uv_width,
        uv_height, ss_x, ss_y, strength, u_accum + uv_blk_col,
        u_count + uv_blk_col, v_accum + uv_blk_col, v_count + uv_blk_col,
        y_dist + blk_col, u_dist + uv_blk_col, v_dist + uv_blk_col, neighbors,
        top_weight, bottom_weight, NULL);
  }

  // Right
  if (ss_x && ss_y) {
    neighbors = CHROMA_DOUBLE_SS_RIGHT_COLUMN_NEIGHBORS;
  } else if (ss_x || ss_y) {
    neighbors = CHROMA_SINGLE_SS_RIGHT_COLUMN_NEIGHBORS;
  } else {
    neighbors = CHROMA_NO_SS_RIGHT_COLUMN_NEIGHBORS;
  }

  apply_temporal_filter_chroma_8(
      y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
      u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride, u_pre + uv_blk_col,
      v_pre + uv_blk_col, uv_pre_stride, uv_width, uv_height, ss_x, ss_y,
      strength, u_accum + uv_blk_col, u_count + uv_blk_col,
      v_accum + uv_blk_col, v_count + uv_blk_col, y_dist + blk_col,
      u_dist + uv_blk_col, v_dist + uv_blk_col, neighbors, top_weight,
      bottom_weight, NULL);
}

static void apply_temporal_filter_yuv(
    const YV12_BUFFER_CONFIG *ref_frame, const MACROBLOCKD *mbd,
    const BLOCK_SIZE block_size, const int mb_row, const int mb_col,
    const int strength, const int use_subblock,
    const int *subblock_filter_weights, const uint8_t *pred, uint32_t *accum,
    uint16_t *count) {
  const int use_whole_blk = !use_subblock;
  const int *blk_fw = subblock_filter_weights;

  // Block information (Y-plane).
  const unsigned int block_height = block_size_high[block_size];
  const unsigned int block_width = block_size_wide[block_size];
  const int mb_pels = block_height * block_width;
  const int y_src_stride = ref_frame->y_stride;
  const int y_pre_stride = block_width;
  const int mb_y_src_offset =
      mb_row * block_height * ref_frame->y_stride + mb_col * block_width;

  // Block information (UV-plane).
  const int ss_y = mbd->plane[1].subsampling_y;
  const int ss_x = mbd->plane[1].subsampling_x;
  const unsigned int uv_height = block_height >> ss_y;
  const unsigned int uv_width = block_width >> ss_x;
  const int uv_src_stride = ref_frame->uv_stride;
  const int uv_pre_stride = block_width >> ss_x;
  const int mb_uv_src_offset =
      mb_row * uv_height * ref_frame->uv_stride + mb_col * uv_width;

  const uint8_t *y_src = ref_frame->y_buffer + mb_y_src_offset;
  const uint8_t *u_src = ref_frame->u_buffer + mb_uv_src_offset;
  const uint8_t *v_src = ref_frame->v_buffer + mb_uv_src_offset;
  const uint8_t *y_pre = pred;
  const uint8_t *u_pre = pred + mb_pels;
  const uint8_t *v_pre = pred + mb_pels * 2;
  uint32_t *y_accum = accum;
  uint32_t *u_accum = accum + mb_pels;
  uint32_t *v_accum = accum + mb_pels * 2;
  uint16_t *y_count = count;
  uint16_t *u_count = count + mb_pels;
  uint16_t *v_count = count + mb_pels * 2;

  const unsigned int chroma_height = block_height >> ss_y,
                     chroma_width = block_width >> ss_x;

  DECLARE_ALIGNED(16, uint16_t, y_dist[BH * DIST_STRIDE]) = { 0 };
  DECLARE_ALIGNED(16, uint16_t, u_dist[BH * DIST_STRIDE]) = { 0 };
  DECLARE_ALIGNED(16, uint16_t, v_dist[BH * DIST_STRIDE]) = { 0 };
  const int *blk_fw_ptr = blk_fw;

  uint16_t *y_dist_ptr = y_dist + 1, *u_dist_ptr = u_dist + 1,
           *v_dist_ptr = v_dist + 1;
  const uint8_t *y_src_ptr = y_src, *u_src_ptr = u_src, *v_src_ptr = v_src;
  const uint8_t *y_pre_ptr = y_pre, *u_pre_ptr = u_pre, *v_pre_ptr = v_pre;

  // Loop variables
  unsigned int row, blk_col;

  assert(block_width <= BW && "block width too large");
  assert(block_height <= BH && "block height too large");
  assert(block_width % 16 == 0 && "block width must be multiple of 16");
  assert(block_height % 2 == 0 && "block height must be even");
  assert((ss_x == 0 || ss_x == 1) && (ss_y == 0 || ss_y == 1) &&
         "invalid chroma subsampling");
  assert(strength >= 0 && strength <= 6 && "invalid temporal filter strength");
  assert(blk_fw[0] >= 0 && "filter weight must be positive");
  assert(
      (use_whole_blk || (blk_fw[1] >= 0 && blk_fw[2] >= 0 && blk_fw[3] >= 0)) &&
      "subblock filter weight must be positive");
  assert(blk_fw[0] <= 2 && "sublock filter weight must be less than 2");
  assert(
      (use_whole_blk || (blk_fw[1] <= 2 && blk_fw[2] <= 2 && blk_fw[3] <= 2)) &&
      "subblock filter weight must be less than 2");

  // Precompute the difference sqaured
  for (row = 0; row < block_height; row++) {
    for (blk_col = 0; blk_col < block_width; blk_col += 16) {
      store_dist_16(y_src_ptr + blk_col, y_pre_ptr + blk_col,
                    y_dist_ptr + blk_col);
    }
    y_src_ptr += y_src_stride;
    y_pre_ptr += y_pre_stride;
    y_dist_ptr += DIST_STRIDE;
  }

  for (row = 0; row < chroma_height; row++) {
    for (blk_col = 0; blk_col < chroma_width; blk_col += 8) {
      store_dist_8(u_src_ptr + blk_col, u_pre_ptr + blk_col,
                   u_dist_ptr + blk_col);
      store_dist_8(v_src_ptr + blk_col, v_pre_ptr + blk_col,
                   v_dist_ptr + blk_col);
    }

    u_src_ptr += uv_src_stride;
    u_pre_ptr += uv_pre_stride;
    u_dist_ptr += DIST_STRIDE;
    v_src_ptr += uv_src_stride;
    v_pre_ptr += uv_pre_stride;
    v_dist_ptr += DIST_STRIDE;
  }

  y_dist_ptr = y_dist + 1;
  u_dist_ptr = u_dist + 1;
  v_dist_ptr = v_dist + 1;

  apply_temporal_filter_luma(y_src, y_src_stride, y_pre, y_pre_stride, u_src,
                             v_src, uv_src_stride, u_pre, v_pre, uv_pre_stride,
                             block_width, block_height, ss_x, ss_y, strength,
                             blk_fw_ptr, use_whole_blk, y_accum, y_count,
                             y_dist_ptr, u_dist_ptr, v_dist_ptr);

  apply_temporal_filter_chroma(
      y_src, y_src_stride, y_pre, y_pre_stride, u_src, v_src, uv_src_stride,
      u_pre, v_pre, uv_pre_stride, block_width, block_height, ss_x, ss_y,
      strength, blk_fw_ptr, use_whole_blk, u_accum, u_count, v_accum, v_count,
      y_dist_ptr, u_dist_ptr, v_dist_ptr);
}

////////////////////////
// Low bit-depth Ends //
////////////////////////

///////////////////////////
// High bit-depth Begins //
///////////////////////////

// Compute (a-b)**2 for 8 pixels with size 16-bit
static INLINE void highbd_store_dist_8(const uint16_t *a, const uint16_t *b,
                                       uint32_t *dst) {
  const __m128i zero = _mm_setzero_si128();
  const __m128i a_reg = _mm_loadu_si128((const __m128i *)a);
  const __m128i b_reg = _mm_loadu_si128((const __m128i *)b);

  const __m128i a_first = _mm_cvtepu16_epi32(a_reg);
  const __m128i a_second = _mm_unpackhi_epi16(a_reg, zero);
  const __m128i b_first = _mm_cvtepu16_epi32(b_reg);
  const __m128i b_second = _mm_unpackhi_epi16(b_reg, zero);

  __m128i dist_first, dist_second;

  dist_first = _mm_sub_epi32(a_first, b_first);
  dist_second = _mm_sub_epi32(a_second, b_second);
  dist_first = _mm_mullo_epi32(dist_first, dist_first);
  dist_second = _mm_mullo_epi32(dist_second, dist_second);

  _mm_storeu_si128((__m128i *)dst, dist_first);
  _mm_storeu_si128((__m128i *)(dst + 4), dist_second);
}

// Sum up three neighboring distortions for the pixels
static INLINE void highbd_get_sum_4(const uint32_t *dist, __m128i *sum) {
  __m128i dist_reg, dist_left, dist_right;

  dist_reg = _mm_loadu_si128((const __m128i *)dist);
  dist_left = _mm_loadu_si128((const __m128i *)(dist - 1));
  dist_right = _mm_loadu_si128((const __m128i *)(dist + 1));

  *sum = _mm_add_epi32(dist_reg, dist_left);
  *sum = _mm_add_epi32(*sum, dist_right);
}

static INLINE void highbd_get_sum_8(const uint32_t *dist, __m128i *sum_first,
                                    __m128i *sum_second) {
  highbd_get_sum_4(dist, sum_first);
  highbd_get_sum_4(dist + 4, sum_second);
}

// Average the value based on the number of values summed (9 for pixels away
// from the border, 4 for pixels in corners, and 6 for other edge values, plus
// however many values from y/uv plane are).
//
// Add in the rounding factor and shift, clamp to 16, invert and shift. Multiply
// by weight.
static INLINE void highbd_average_4(__m128i *output, const __m128i *sum,
                                    const __m128i *mul_constants,
                                    const int strength, const int rounding,
                                    const int weight) {
  // _mm_srl_epi16 uses the lower 64 bit value for the shift.
  const __m128i strength_u128 = _mm_set_epi32(0, 0, 0, strength);
  const __m128i rounding_u32 = _mm_set1_epi32(rounding);
  const __m128i weight_u32 = _mm_set1_epi32(weight);
  const __m128i sixteen = _mm_set1_epi32(16);
  const __m128i zero = _mm_setzero_si128();

  // modifier * 3 / index;
  const __m128i sum_lo = _mm_unpacklo_epi32(*sum, zero);
  const __m128i sum_hi = _mm_unpackhi_epi32(*sum, zero);
  const __m128i const_lo = _mm_unpacklo_epi32(*mul_constants, zero);
  const __m128i const_hi = _mm_unpackhi_epi32(*mul_constants, zero);

  const __m128i mul_lo = _mm_mul_epu32(sum_lo, const_lo);
  const __m128i mul_lo_div = _mm_srli_epi64(mul_lo, 32);
  const __m128i mul_hi = _mm_mul_epu32(sum_hi, const_hi);
  const __m128i mul_hi_div = _mm_srli_epi64(mul_hi, 32);

  // Now we have
  //   mul_lo: 00 a1 00 a0
  //   mul_hi: 00 a3 00 a2
  // Unpack as 64 bit words to get even and odd elements
  //   unpack_lo: 00 a2 00 a0
  //   unpack_hi: 00 a3 00 a1
  // Then we can shift and OR the results to get everything in 32-bits
  const __m128i mul_even = _mm_unpacklo_epi64(mul_lo_div, mul_hi_div);
  const __m128i mul_odd = _mm_unpackhi_epi64(mul_lo_div, mul_hi_div);
  const __m128i mul_odd_shift = _mm_slli_si128(mul_odd, 4);
  const __m128i mul = _mm_or_si128(mul_even, mul_odd_shift);

  // Round
  *output = _mm_add_epi32(mul, rounding_u32);
  *output = _mm_srl_epi32(*output, strength_u128);

  // Multiply with the weight
  *output = _mm_min_epu32(*output, sixteen);
  *output = _mm_sub_epi32(sixteen, *output);
  *output = _mm_mullo_epi32(*output, weight_u32);
}

static INLINE void highbd_average_8(__m128i *output_0, __m128i *output_1,
                                    const __m128i *sum_0_u32,
                                    const __m128i *sum_1_u32,
                                    const __m128i *mul_constants_0,
                                    const __m128i *mul_constants_1,
                                    const int strength, const int rounding,
                                    const int weight) {
  highbd_average_4(output_0, sum_0_u32, mul_constants_0, strength, rounding,
                   weight);
  highbd_average_4(output_1, sum_1_u32, mul_constants_1, strength, rounding,
                   weight);
}

// Add 'sum_u32' to 'count'. Multiply by 'pred' and add to 'accumulator.'
static INLINE void highbd_accumulate_and_store_8(const __m128i sum_first_u32,
                                                 const __m128i sum_second_u32,
                                                 const uint16_t *pred,
                                                 uint16_t *count,
                                                 uint32_t *accumulator) {
  // Cast down to 16-bit ints
  const __m128i sum_u16 = _mm_packus_epi32(sum_first_u32, sum_second_u32);
  const __m128i zero = _mm_setzero_si128();

  __m128i pred_u16 = _mm_loadu_si128((const __m128i *)pred);
  __m128i count_u16 = _mm_loadu_si128((const __m128i *)count);

  __m128i pred_0_u32, pred_1_u32;
  __m128i accum_0_u32, accum_1_u32;

  count_u16 = _mm_adds_epu16(count_u16, sum_u16);
  _mm_storeu_si128((__m128i *)count, count_u16);

  pred_u16 = _mm_mullo_epi16(sum_u16, pred_u16);

  pred_0_u32 = _mm_cvtepu16_epi32(pred_u16);
  pred_1_u32 = _mm_unpackhi_epi16(pred_u16, zero);

  accum_0_u32 = _mm_loadu_si128((const __m128i *)accumulator);
  accum_1_u32 = _mm_loadu_si128((const __m128i *)(accumulator + 4));

  accum_0_u32 = _mm_add_epi32(pred_0_u32, accum_0_u32);
  accum_1_u32 = _mm_add_epi32(pred_1_u32, accum_1_u32);

  _mm_storeu_si128((__m128i *)accumulator, accum_0_u32);
  _mm_storeu_si128((__m128i *)(accumulator + 4), accum_1_u32);
}

static INLINE void highbd_read_dist_4(const uint32_t *dist, __m128i *dist_reg) {
  *dist_reg = _mm_loadu_si128((const __m128i *)dist);
}

static INLINE void highbd_read_dist_8(const uint32_t *dist, __m128i *reg_first,
                                      __m128i *reg_second) {
  highbd_read_dist_4(dist, reg_first);
  highbd_read_dist_4(dist + 4, reg_second);
}

static INLINE void highbd_read_chroma_dist_row_8(
    int ss_x, const uint32_t *u_dist, const uint32_t *v_dist, __m128i *u_first,
    __m128i *u_second, __m128i *v_first, __m128i *v_second) {
  if (!ss_x) {
    // If there is no chroma subsampling in the horizontal direction, then we
    // need to load 8 entries from chroma.
    highbd_read_dist_8(u_dist, u_first, u_second);
    highbd_read_dist_8(v_dist, v_first, v_second);
  } else {  // ss_x == 1
    // Otherwise, we only need to load 8 entries
    __m128i u_reg, v_reg;

    highbd_read_dist_4(u_dist, &u_reg);

    *u_first = _mm_unpacklo_epi32(u_reg, u_reg);
    *u_second = _mm_unpackhi_epi32(u_reg, u_reg);

    highbd_read_dist_4(v_dist, &v_reg);

    *v_first = _mm_unpacklo_epi32(v_reg, v_reg);
    *v_second = _mm_unpackhi_epi32(v_reg, v_reg);
  }
}

static void highbd_apply_temporal_filter_luma_8(
    const uint16_t *y_src, int y_src_stride, const uint16_t *y_pre,
    int y_pre_stride, const uint16_t *u_src, const uint16_t *v_src,
    int uv_src_stride, const uint16_t *u_pre, const uint16_t *v_pre,
    int uv_pre_stride, unsigned int block_width, unsigned int block_height,
    int ss_x, int ss_y, int strength, int use_whole_blk, uint32_t *y_accum,
    uint16_t *y_count, const uint32_t *y_dist, const uint32_t *u_dist,
    const uint32_t *v_dist, const uint32_t *const *neighbors_first,
    const uint32_t *const *neighbors_second, int top_weight,
    int bottom_weight) {
  const int rounding = (1 << strength) >> 1;
  int weight = top_weight;

  __m128i mul_first, mul_second;

  __m128i sum_row_1_first, sum_row_1_second;
  __m128i sum_row_2_first, sum_row_2_second;
  __m128i sum_row_3_first, sum_row_3_second;

  __m128i u_first, u_second;
  __m128i v_first, v_second;

  __m128i sum_row_first;
  __m128i sum_row_second;

  // Loop variables
  unsigned int h;

  assert(strength >= 0 && strength <= 14 &&
         "invalid adjusted temporal filter strength");
  assert(block_width == 8);

  (void)block_width;

  // First row
  mul_first = _mm_loadu_si128((const __m128i *)neighbors_first[0]);
  mul_second = _mm_loadu_si128((const __m128i *)neighbors_second[0]);

  // Add luma values
  highbd_get_sum_8(y_dist, &sum_row_2_first, &sum_row_2_second);
  highbd_get_sum_8(y_dist + DIST_STRIDE, &sum_row_3_first, &sum_row_3_second);

  // We don't need to saturate here because the maximum value is UINT12_MAX ** 2
  // * 9 ~= 2**24 * 9 < 2 ** 28 < INT32_MAX
  sum_row_first = _mm_add_epi32(sum_row_2_first, sum_row_3_first);
  sum_row_second = _mm_add_epi32(sum_row_2_second, sum_row_3_second);

  // Add chroma values
  highbd_read_chroma_dist_row_8(ss_x, u_dist, v_dist, &u_first, &u_second,
                                &v_first, &v_second);

  // Max value here is 2 ** 24 * (9 + 2), so no saturation is needed
  sum_row_first = _mm_add_epi32(sum_row_first, u_first);
  sum_row_second = _mm_add_epi32(sum_row_second, u_second);

  sum_row_first = _mm_add_epi32(sum_row_first, v_first);
  sum_row_second = _mm_add_epi32(sum_row_second, v_second);

  // Get modifier and store result
  highbd_average_8(&sum_row_first, &sum_row_second, &sum_row_first,
                   &sum_row_second, &mul_first, &mul_second, strength, rounding,
                   weight);

  highbd_accumulate_and_store_8(sum_row_first, sum_row_second, y_pre, y_count,
                                y_accum);

  y_src += y_src_stride;
  y_pre += y_pre_stride;
  y_count += y_pre_stride;
  y_accum += y_pre_stride;
  y_dist += DIST_STRIDE;

  u_src += uv_src_stride;
  u_pre += uv_pre_stride;
  u_dist += DIST_STRIDE;
  v_src += uv_src_stride;
  v_pre += uv_pre_stride;
  v_dist += DIST_STRIDE;

  // Then all the rows except the last one
  mul_first = _mm_loadu_si128((const __m128i *)neighbors_first[1]);
  mul_second = _mm_loadu_si128((const __m128i *)neighbors_second[1]);

  for (h = 1; h < block_height - 1; ++h) {
    // Move the weight to bottom half
    if (!use_whole_blk && h == block_height / 2) {
      weight = bottom_weight;
    }
    // Shift the rows up
    sum_row_1_first = sum_row_2_first;
    sum_row_1_second = sum_row_2_second;
    sum_row_2_first = sum_row_3_first;
    sum_row_2_second = sum_row_3_second;

    // Add luma values to the modifier
    sum_row_first = _mm_add_epi32(sum_row_1_first, sum_row_2_first);
    sum_row_second = _mm_add_epi32(sum_row_1_second, sum_row_2_second);

    highbd_get_sum_8(y_dist + DIST_STRIDE, &sum_row_3_first, &sum_row_3_second);

    sum_row_first = _mm_add_epi32(sum_row_first, sum_row_3_first);
    sum_row_second = _mm_add_epi32(sum_row_second, sum_row_3_second);

    // Add chroma values to the modifier
    if (ss_y == 0 || h % 2 == 0) {
      // Only calculate the new chroma distortion if we are at a pixel that
      // corresponds to a new chroma row
      highbd_read_chroma_dist_row_8(ss_x, u_dist, v_dist, &u_first, &u_second,
                                    &v_first, &v_second);

      u_src += uv_src_stride;
      u_pre += uv_pre_stride;
      u_dist += DIST_STRIDE;
      v_src += uv_src_stride;
      v_pre += uv_pre_stride;
      v_dist += DIST_STRIDE;
    }

    sum_row_first = _mm_add_epi32(sum_row_first, u_first);
    sum_row_second = _mm_add_epi32(sum_row_second, u_second);
    sum_row_first = _mm_add_epi32(sum_row_first, v_first);
    sum_row_second = _mm_add_epi32(sum_row_second, v_second);

    // Get modifier and store result
    highbd_average_8(&sum_row_first, &sum_row_second, &sum_row_first,
                     &sum_row_second, &mul_first, &mul_second, strength,
                     rounding, weight);
    highbd_accumulate_and_store_8(sum_row_first, sum_row_second, y_pre, y_count,
                                  y_accum);

    y_src += y_src_stride;
    y_pre += y_pre_stride;
    y_count += y_pre_stride;
    y_accum += y_pre_stride;
    y_dist += DIST_STRIDE;
  }

  // The last row
  mul_first = _mm_loadu_si128((const __m128i *)neighbors_first[0]);
  mul_second = _mm_loadu_si128((const __m128i *)neighbors_second[0]);

  // Shift the rows up
  sum_row_1_first = sum_row_2_first;
  sum_row_1_second = sum_row_2_second;
  sum_row_2_first = sum_row_3_first;
  sum_row_2_second = sum_row_3_second;

  // Add luma values to the modifier
  sum_row_first = _mm_add_epi32(sum_row_1_first, sum_row_2_first);
  sum_row_second = _mm_add_epi32(sum_row_1_second, sum_row_2_second);

  // Add chroma values to the modifier
  if (ss_y == 0) {
    // Only calculate the new chroma distortion if we are at a pixel that
    // corresponds to a new chroma row
    highbd_read_chroma_dist_row_8(ss_x, u_dist, v_dist, &u_first, &u_second,
                                  &v_first, &v_second);
  }

  sum_row_first = _mm_add_epi32(sum_row_first, u_first);
  sum_row_second = _mm_add_epi32(sum_row_second, u_second);
  sum_row_first = _mm_add_epi32(sum_row_first, v_first);
  sum_row_second = _mm_add_epi32(sum_row_second, v_second);

  // Get modifier and store result
  highbd_average_8(&sum_row_first, &sum_row_second, &sum_row_first,
                   &sum_row_second, &mul_first, &mul_second, strength, rounding,
                   weight);
  highbd_accumulate_and_store_8(sum_row_first, sum_row_second, y_pre, y_count,
                                y_accum);
}

// Perform temporal filter for the luma component.
static void highbd_apply_temporal_filter_luma(
    const uint16_t *y_src, int y_src_stride, const uint16_t *y_pre,
    int y_pre_stride, const uint16_t *u_src, const uint16_t *v_src,
    int uv_src_stride, const uint16_t *u_pre, const uint16_t *v_pre,
    int uv_pre_stride, unsigned int block_width, unsigned int block_height,
    int ss_x, int ss_y, int strength, const int *blk_fw, int use_whole_blk,
    uint32_t *y_accum, uint16_t *y_count, const uint32_t *y_dist,
    const uint32_t *u_dist, const uint32_t *v_dist) {
  unsigned int blk_col = 0, uv_blk_col = 0;
  const unsigned int blk_col_step = 8, uv_blk_col_step = 8 >> ss_x;
  const unsigned int mid_width = block_width >> 1,
                     last_width = block_width - blk_col_step;
  int top_weight = blk_fw[0],
      bottom_weight = use_whole_blk ? blk_fw[0] : blk_fw[2];
  const uint32_t *const *neighbors_first;
  const uint32_t *const *neighbors_second;

  // Left
  neighbors_first = HIGHBD_LUMA_LEFT_COLUMN_NEIGHBORS;
  neighbors_second = HIGHBD_LUMA_MIDDLE_COLUMN_NEIGHBORS;
  highbd_apply_temporal_filter_luma_8(
      y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
      u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride, u_pre + uv_blk_col,
      v_pre + uv_blk_col, uv_pre_stride, blk_col_step, block_height, ss_x, ss_y,
      strength, use_whole_blk, y_accum + blk_col, y_count + blk_col,
      y_dist + blk_col, u_dist + uv_blk_col, v_dist + uv_blk_col,
      neighbors_first, neighbors_second, top_weight, bottom_weight);

  blk_col += blk_col_step;
  uv_blk_col += uv_blk_col_step;

  // Middle First
  neighbors_first = HIGHBD_LUMA_MIDDLE_COLUMN_NEIGHBORS;
  for (; blk_col < mid_width;
       blk_col += blk_col_step, uv_blk_col += uv_blk_col_step) {
    highbd_apply_temporal_filter_luma_8(
        y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
        u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride,
        u_pre + uv_blk_col, v_pre + uv_blk_col, uv_pre_stride, blk_col_step,
        block_height, ss_x, ss_y, strength, use_whole_blk, y_accum + blk_col,
        y_count + blk_col, y_dist + blk_col, u_dist + uv_blk_col,
        v_dist + uv_blk_col, neighbors_first, neighbors_second, top_weight,
        bottom_weight);
  }

  if (!use_whole_blk) {
    top_weight = blk_fw[1];
    bottom_weight = blk_fw[3];
  }

  // Middle Second
  for (; blk_col < last_width;
       blk_col += blk_col_step, uv_blk_col += uv_blk_col_step) {
    highbd_apply_temporal_filter_luma_8(
        y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
        u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride,
        u_pre + uv_blk_col, v_pre + uv_blk_col, uv_pre_stride, blk_col_step,
        block_height, ss_x, ss_y, strength, use_whole_blk, y_accum + blk_col,
        y_count + blk_col, y_dist + blk_col, u_dist + uv_blk_col,
        v_dist + uv_blk_col, neighbors_first, neighbors_second, top_weight,
        bottom_weight);
  }

  // Right
  neighbors_second = HIGHBD_LUMA_RIGHT_COLUMN_NEIGHBORS;
  highbd_apply_temporal_filter_luma_8(
      y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
      u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride, u_pre + uv_blk_col,
      v_pre + uv_blk_col, uv_pre_stride, blk_col_step, block_height, ss_x, ss_y,
      strength, use_whole_blk, y_accum + blk_col, y_count + blk_col,
      y_dist + blk_col, u_dist + uv_blk_col, v_dist + uv_blk_col,
      neighbors_first, neighbors_second, top_weight, bottom_weight);
}

// Add a row of luma distortion that corresponds to 8 chroma mods. If we are
// subsampling in x direction, then we have 16 lumas, else we have 8.
static INLINE void highbd_add_luma_dist_to_8_chroma_mod(
    const uint32_t *y_dist, int ss_x, int ss_y, __m128i *u_mod_fst,
    __m128i *u_mod_snd, __m128i *v_mod_fst, __m128i *v_mod_snd) {
  __m128i y_reg_fst, y_reg_snd;
  if (!ss_x) {
    highbd_read_dist_8(y_dist, &y_reg_fst, &y_reg_snd);
    if (ss_y == 1) {
      __m128i y_tmp_fst, y_tmp_snd;
      highbd_read_dist_8(y_dist + DIST_STRIDE, &y_tmp_fst, &y_tmp_snd);
      y_reg_fst = _mm_add_epi32(y_reg_fst, y_tmp_fst);
      y_reg_snd = _mm_add_epi32(y_reg_snd, y_tmp_snd);
    }
  } else {
    // Temporary
    __m128i y_fst, y_snd;

    // First 8
    highbd_read_dist_8(y_dist, &y_fst, &y_snd);
    if (ss_y == 1) {
      __m128i y_tmp_fst, y_tmp_snd;
      highbd_read_dist_8(y_dist + DIST_STRIDE, &y_tmp_fst, &y_tmp_snd);

      y_fst = _mm_add_epi32(y_fst, y_tmp_fst);
      y_snd = _mm_add_epi32(y_snd, y_tmp_snd);
    }

    y_reg_fst = _mm_hadd_epi32(y_fst, y_snd);

    // Second 8
    highbd_read_dist_8(y_dist + 8, &y_fst, &y_snd);
    if (ss_y == 1) {
      __m128i y_tmp_fst, y_tmp_snd;
      highbd_read_dist_8(y_dist + 8 + DIST_STRIDE, &y_tmp_fst, &y_tmp_snd);

      y_fst = _mm_add_epi32(y_fst, y_tmp_fst);
      y_snd = _mm_add_epi32(y_snd, y_tmp_snd);
    }

    y_reg_snd = _mm_hadd_epi32(y_fst, y_snd);
  }

  *u_mod_fst = _mm_add_epi32(*u_mod_fst, y_reg_fst);
  *u_mod_snd = _mm_add_epi32(*u_mod_snd, y_reg_snd);
  *v_mod_fst = _mm_add_epi32(*v_mod_fst, y_reg_fst);
  *v_mod_snd = _mm_add_epi32(*v_mod_snd, y_reg_snd);
}

// Apply temporal filter to the chroma components. This performs temporal
// filtering on a chroma block of 8 X uv_height. If blk_fw is not NULL, use
// blk_fw as an array of size 4 for the weights for each of the 4 subblocks,
// else use top_weight for top half, and bottom weight for bottom half.
static void highbd_apply_temporal_filter_chroma_8(
    const uint16_t *y_src, int y_src_stride, const uint16_t *y_pre,
    int y_pre_stride, const uint16_t *u_src, const uint16_t *v_src,
    int uv_src_stride, const uint16_t *u_pre, const uint16_t *v_pre,
    int uv_pre_stride, unsigned int uv_block_width,
    unsigned int uv_block_height, int ss_x, int ss_y, int strength,
    uint32_t *u_accum, uint16_t *u_count, uint32_t *v_accum, uint16_t *v_count,
    const uint32_t *y_dist, const uint32_t *u_dist, const uint32_t *v_dist,
    const uint32_t *const *neighbors_fst, const uint32_t *const *neighbors_snd,
    int top_weight, int bottom_weight, const int *blk_fw) {
  const int rounding = (1 << strength) >> 1;
  int weight = top_weight;

  __m128i mul_fst, mul_snd;

  __m128i u_sum_row_1_fst, u_sum_row_2_fst, u_sum_row_3_fst;
  __m128i v_sum_row_1_fst, v_sum_row_2_fst, v_sum_row_3_fst;
  __m128i u_sum_row_1_snd, u_sum_row_2_snd, u_sum_row_3_snd;
  __m128i v_sum_row_1_snd, v_sum_row_2_snd, v_sum_row_3_snd;

  __m128i u_sum_row_fst, v_sum_row_fst;
  __m128i u_sum_row_snd, v_sum_row_snd;

  // Loop variable
  unsigned int h;

  (void)uv_block_width;

  // First row
  mul_fst = _mm_loadu_si128((const __m128i *)neighbors_fst[0]);
  mul_snd = _mm_loadu_si128((const __m128i *)neighbors_snd[0]);

  // Add chroma values
  highbd_get_sum_8(u_dist, &u_sum_row_2_fst, &u_sum_row_2_snd);
  highbd_get_sum_8(u_dist + DIST_STRIDE, &u_sum_row_3_fst, &u_sum_row_3_snd);

  u_sum_row_fst = _mm_add_epi32(u_sum_row_2_fst, u_sum_row_3_fst);
  u_sum_row_snd = _mm_add_epi32(u_sum_row_2_snd, u_sum_row_3_snd);

  highbd_get_sum_8(v_dist, &v_sum_row_2_fst, &v_sum_row_2_snd);
  highbd_get_sum_8(v_dist + DIST_STRIDE, &v_sum_row_3_fst, &v_sum_row_3_snd);

  v_sum_row_fst = _mm_add_epi32(v_sum_row_2_fst, v_sum_row_3_fst);
  v_sum_row_snd = _mm_add_epi32(v_sum_row_2_snd, v_sum_row_3_snd);

  // Add luma values
  highbd_add_luma_dist_to_8_chroma_mod(y_dist, ss_x, ss_y, &u_sum_row_fst,
                                       &u_sum_row_snd, &v_sum_row_fst,
                                       &v_sum_row_snd);

  // Get modifier and store result
  if (blk_fw) {
    highbd_average_4(&u_sum_row_fst, &u_sum_row_fst, &mul_fst, strength,
                     rounding, blk_fw[0]);
    highbd_average_4(&u_sum_row_snd, &u_sum_row_snd, &mul_snd, strength,
                     rounding, blk_fw[1]);

    highbd_average_4(&v_sum_row_fst, &v_sum_row_fst, &mul_fst, strength,
                     rounding, blk_fw[0]);
    highbd_average_4(&v_sum_row_snd, &v_sum_row_snd, &mul_snd, strength,
                     rounding, blk_fw[1]);

  } else {
    highbd_average_8(&u_sum_row_fst, &u_sum_row_snd, &u_sum_row_fst,
                     &u_sum_row_snd, &mul_fst, &mul_snd, strength, rounding,
                     weight);
    highbd_average_8(&v_sum_row_fst, &v_sum_row_snd, &v_sum_row_fst,
                     &v_sum_row_snd, &mul_fst, &mul_snd, strength, rounding,
                     weight);
  }
  highbd_accumulate_and_store_8(u_sum_row_fst, u_sum_row_snd, u_pre, u_count,
                                u_accum);
  highbd_accumulate_and_store_8(v_sum_row_fst, v_sum_row_snd, v_pre, v_count,
                                v_accum);

  u_src += uv_src_stride;
  u_pre += uv_pre_stride;
  u_dist += DIST_STRIDE;
  v_src += uv_src_stride;
  v_pre += uv_pre_stride;
  v_dist += DIST_STRIDE;
  u_count += uv_pre_stride;
  u_accum += uv_pre_stride;
  v_count += uv_pre_stride;
  v_accum += uv_pre_stride;

  y_src += y_src_stride * (1 + ss_y);
  y_pre += y_pre_stride * (1 + ss_y);
  y_dist += DIST_STRIDE * (1 + ss_y);

  // Then all the rows except the last one
  mul_fst = _mm_loadu_si128((const __m128i *)neighbors_fst[1]);
  mul_snd = _mm_loadu_si128((const __m128i *)neighbors_snd[1]);

  for (h = 1; h < uv_block_height - 1; ++h) {
    // Move the weight pointer to the bottom half of the blocks
    if (h == uv_block_height / 2) {
      if (blk_fw) {
        blk_fw += 2;
      } else {
        weight = bottom_weight;
      }
    }

    // Shift the rows up
    u_sum_row_1_fst = u_sum_row_2_fst;
    u_sum_row_2_fst = u_sum_row_3_fst;
    u_sum_row_1_snd = u_sum_row_2_snd;
    u_sum_row_2_snd = u_sum_row_3_snd;

    v_sum_row_1_fst = v_sum_row_2_fst;
    v_sum_row_2_fst = v_sum_row_3_fst;
    v_sum_row_1_snd = v_sum_row_2_snd;
    v_sum_row_2_snd = v_sum_row_3_snd;

    // Add chroma values
    u_sum_row_fst = _mm_add_epi32(u_sum_row_1_fst, u_sum_row_2_fst);
    u_sum_row_snd = _mm_add_epi32(u_sum_row_1_snd, u_sum_row_2_snd);
    highbd_get_sum_8(u_dist + DIST_STRIDE, &u_sum_row_3_fst, &u_sum_row_3_snd);
    u_sum_row_fst = _mm_add_epi32(u_sum_row_fst, u_sum_row_3_fst);
    u_sum_row_snd = _mm_add_epi32(u_sum_row_snd, u_sum_row_3_snd);

    v_sum_row_fst = _mm_add_epi32(v_sum_row_1_fst, v_sum_row_2_fst);
    v_sum_row_snd = _mm_add_epi32(v_sum_row_1_snd, v_sum_row_2_snd);
    highbd_get_sum_8(v_dist + DIST_STRIDE, &v_sum_row_3_fst, &v_sum_row_3_snd);
    v_sum_row_fst = _mm_add_epi32(v_sum_row_fst, v_sum_row_3_fst);
    v_sum_row_snd = _mm_add_epi32(v_sum_row_snd, v_sum_row_3_snd);

    // Add luma values
    highbd_add_luma_dist_to_8_chroma_mod(y_dist, ss_x, ss_y, &u_sum_row_fst,
                                         &u_sum_row_snd, &v_sum_row_fst,
                                         &v_sum_row_snd);

    // Get modifier and store result
    if (blk_fw) {
      highbd_average_4(&u_sum_row_fst, &u_sum_row_fst, &mul_fst, strength,
                       rounding, blk_fw[0]);
      highbd_average_4(&u_sum_row_snd, &u_sum_row_snd, &mul_snd, strength,
                       rounding, blk_fw[1]);

      highbd_average_4(&v_sum_row_fst, &v_sum_row_fst, &mul_fst, strength,
                       rounding, blk_fw[0]);
      highbd_average_4(&v_sum_row_snd, &v_sum_row_snd, &mul_snd, strength,
                       rounding, blk_fw[1]);

    } else {
      highbd_average_8(&u_sum_row_fst, &u_sum_row_snd, &u_sum_row_fst,
                       &u_sum_row_snd, &mul_fst, &mul_snd, strength, rounding,
                       weight);
      highbd_average_8(&v_sum_row_fst, &v_sum_row_snd, &v_sum_row_fst,
                       &v_sum_row_snd, &mul_fst, &mul_snd, strength, rounding,
                       weight);
    }

    highbd_accumulate_and_store_8(u_sum_row_fst, u_sum_row_snd, u_pre, u_count,
                                  u_accum);
    highbd_accumulate_and_store_8(v_sum_row_fst, v_sum_row_snd, v_pre, v_count,
                                  v_accum);

    u_src += uv_src_stride;
    u_pre += uv_pre_stride;
    u_dist += DIST_STRIDE;
    v_src += uv_src_stride;
    v_pre += uv_pre_stride;
    v_dist += DIST_STRIDE;
    u_count += uv_pre_stride;
    u_accum += uv_pre_stride;
    v_count += uv_pre_stride;
    v_accum += uv_pre_stride;

    y_src += y_src_stride * (1 + ss_y);
    y_pre += y_pre_stride * (1 + ss_y);
    y_dist += DIST_STRIDE * (1 + ss_y);
  }

  // The last row
  mul_fst = _mm_loadu_si128((const __m128i *)neighbors_fst[0]);
  mul_snd = _mm_loadu_si128((const __m128i *)neighbors_snd[0]);

  // Shift the rows up
  u_sum_row_1_fst = u_sum_row_2_fst;
  u_sum_row_2_fst = u_sum_row_3_fst;
  u_sum_row_1_snd = u_sum_row_2_snd;
  u_sum_row_2_snd = u_sum_row_3_snd;

  v_sum_row_1_fst = v_sum_row_2_fst;
  v_sum_row_2_fst = v_sum_row_3_fst;
  v_sum_row_1_snd = v_sum_row_2_snd;
  v_sum_row_2_snd = v_sum_row_3_snd;

  // Add chroma values
  u_sum_row_fst = _mm_add_epi32(u_sum_row_1_fst, u_sum_row_2_fst);
  v_sum_row_fst = _mm_add_epi32(v_sum_row_1_fst, v_sum_row_2_fst);
  u_sum_row_snd = _mm_add_epi32(u_sum_row_1_snd, u_sum_row_2_snd);
  v_sum_row_snd = _mm_add_epi32(v_sum_row_1_snd, v_sum_row_2_snd);

  // Add luma values
  highbd_add_luma_dist_to_8_chroma_mod(y_dist, ss_x, ss_y, &u_sum_row_fst,
                                       &u_sum_row_snd, &v_sum_row_fst,
                                       &v_sum_row_snd);

  // Get modifier and store result
  if (blk_fw) {
    highbd_average_4(&u_sum_row_fst, &u_sum_row_fst, &mul_fst, strength,
                     rounding, blk_fw[0]);
    highbd_average_4(&u_sum_row_snd, &u_sum_row_snd, &mul_snd, strength,
                     rounding, blk_fw[1]);

    highbd_average_4(&v_sum_row_fst, &v_sum_row_fst, &mul_fst, strength,
                     rounding, blk_fw[0]);
    highbd_average_4(&v_sum_row_snd, &v_sum_row_snd, &mul_snd, strength,
                     rounding, blk_fw[1]);

  } else {
    highbd_average_8(&u_sum_row_fst, &u_sum_row_snd, &u_sum_row_fst,
                     &u_sum_row_snd, &mul_fst, &mul_snd, strength, rounding,
                     weight);
    highbd_average_8(&v_sum_row_fst, &v_sum_row_snd, &v_sum_row_fst,
                     &v_sum_row_snd, &mul_fst, &mul_snd, strength, rounding,
                     weight);
  }

  highbd_accumulate_and_store_8(u_sum_row_fst, u_sum_row_snd, u_pre, u_count,
                                u_accum);
  highbd_accumulate_and_store_8(v_sum_row_fst, v_sum_row_snd, v_pre, v_count,
                                v_accum);
}

// Perform temporal filter for the chroma components.
static void highbd_apply_temporal_filter_chroma(
    const uint16_t *y_src, int y_src_stride, const uint16_t *y_pre,
    int y_pre_stride, const uint16_t *u_src, const uint16_t *v_src,
    int uv_src_stride, const uint16_t *u_pre, const uint16_t *v_pre,
    int uv_pre_stride, unsigned int block_width, unsigned int block_height,
    int ss_x, int ss_y, int strength, const int *blk_fw, int use_whole_blk,
    uint32_t *u_accum, uint16_t *u_count, uint32_t *v_accum, uint16_t *v_count,
    const uint32_t *y_dist, const uint32_t *u_dist, const uint32_t *v_dist) {
  const unsigned int uv_width = block_width >> ss_x,
                     uv_height = block_height >> ss_y;

  unsigned int blk_col = 0, uv_blk_col = 0;
  const unsigned int uv_blk_col_step = 8, blk_col_step = 8 << ss_x;
  const unsigned int uv_mid_width = uv_width >> 1,
                     uv_last_width = uv_width - uv_blk_col_step;
  int top_weight = blk_fw[0],
      bottom_weight = use_whole_blk ? blk_fw[0] : blk_fw[2];
  const uint32_t *const *neighbors_fst;
  const uint32_t *const *neighbors_snd;

  if (uv_width == 8) {
    // Special Case: We are subsampling in x direction on a 16x16 block. Since
    // we are operating on a row of 8 chroma pixels, we can't use the usual
    // left-middle-right pattern.
    assert(ss_x);

    if (ss_y) {
      neighbors_fst = HIGHBD_CHROMA_DOUBLE_SS_LEFT_COLUMN_NEIGHBORS;
      neighbors_snd = HIGHBD_CHROMA_DOUBLE_SS_RIGHT_COLUMN_NEIGHBORS;
    } else {
      neighbors_fst = HIGHBD_CHROMA_SINGLE_SS_LEFT_COLUMN_NEIGHBORS;
      neighbors_snd = HIGHBD_CHROMA_SINGLE_SS_RIGHT_COLUMN_NEIGHBORS;
    }

    if (use_whole_blk) {
      highbd_apply_temporal_filter_chroma_8(
          y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
          u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride,
          u_pre + uv_blk_col, v_pre + uv_blk_col, uv_pre_stride, uv_width,
          uv_height, ss_x, ss_y, strength, u_accum + uv_blk_col,
          u_count + uv_blk_col, v_accum + uv_blk_col, v_count + uv_blk_col,
          y_dist + blk_col, u_dist + uv_blk_col, v_dist + uv_blk_col,
          neighbors_fst, neighbors_snd, top_weight, bottom_weight, NULL);
    } else {
      highbd_apply_temporal_filter_chroma_8(
          y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
          u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride,
          u_pre + uv_blk_col, v_pre + uv_blk_col, uv_pre_stride, uv_width,
          uv_height, ss_x, ss_y, strength, u_accum + uv_blk_col,
          u_count + uv_blk_col, v_accum + uv_blk_col, v_count + uv_blk_col,
          y_dist + blk_col, u_dist + uv_blk_col, v_dist + uv_blk_col,
          neighbors_fst, neighbors_snd, 0, 0, blk_fw);
    }

    return;
  }

  // Left
  if (ss_x && ss_y) {
    neighbors_fst = HIGHBD_CHROMA_DOUBLE_SS_LEFT_COLUMN_NEIGHBORS;
    neighbors_snd = HIGHBD_CHROMA_DOUBLE_SS_MIDDLE_COLUMN_NEIGHBORS;
  } else if (ss_x || ss_y) {
    neighbors_fst = HIGHBD_CHROMA_SINGLE_SS_LEFT_COLUMN_NEIGHBORS;
    neighbors_snd = HIGHBD_CHROMA_SINGLE_SS_MIDDLE_COLUMN_NEIGHBORS;
  } else {
    neighbors_fst = HIGHBD_CHROMA_NO_SS_LEFT_COLUMN_NEIGHBORS;
    neighbors_snd = HIGHBD_CHROMA_NO_SS_MIDDLE_COLUMN_NEIGHBORS;
  }

  highbd_apply_temporal_filter_chroma_8(
      y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
      u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride, u_pre + uv_blk_col,
      v_pre + uv_blk_col, uv_pre_stride, uv_width, uv_height, ss_x, ss_y,
      strength, u_accum + uv_blk_col, u_count + uv_blk_col,
      v_accum + uv_blk_col, v_count + uv_blk_col, y_dist + blk_col,
      u_dist + uv_blk_col, v_dist + uv_blk_col, neighbors_fst, neighbors_snd,
      top_weight, bottom_weight, NULL);

  blk_col += blk_col_step;
  uv_blk_col += uv_blk_col_step;

  // Middle First
  if (ss_x && ss_y) {
    neighbors_fst = HIGHBD_CHROMA_DOUBLE_SS_MIDDLE_COLUMN_NEIGHBORS;
  } else if (ss_x || ss_y) {
    neighbors_fst = HIGHBD_CHROMA_SINGLE_SS_MIDDLE_COLUMN_NEIGHBORS;
  } else {
    neighbors_fst = HIGHBD_CHROMA_NO_SS_MIDDLE_COLUMN_NEIGHBORS;
  }

  for (; uv_blk_col < uv_mid_width;
       blk_col += blk_col_step, uv_blk_col += uv_blk_col_step) {
    highbd_apply_temporal_filter_chroma_8(
        y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
        u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride,
        u_pre + uv_blk_col, v_pre + uv_blk_col, uv_pre_stride, uv_width,
        uv_height, ss_x, ss_y, strength, u_accum + uv_blk_col,
        u_count + uv_blk_col, v_accum + uv_blk_col, v_count + uv_blk_col,
        y_dist + blk_col, u_dist + uv_blk_col, v_dist + uv_blk_col,
        neighbors_fst, neighbors_snd, top_weight, bottom_weight, NULL);
  }

  if (!use_whole_blk) {
    top_weight = blk_fw[1];
    bottom_weight = blk_fw[3];
  }

  // Middle Second
  for (; uv_blk_col < uv_last_width;
       blk_col += blk_col_step, uv_blk_col += uv_blk_col_step) {
    highbd_apply_temporal_filter_chroma_8(
        y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
        u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride,
        u_pre + uv_blk_col, v_pre + uv_blk_col, uv_pre_stride, uv_width,
        uv_height, ss_x, ss_y, strength, u_accum + uv_blk_col,
        u_count + uv_blk_col, v_accum + uv_blk_col, v_count + uv_blk_col,
        y_dist + blk_col, u_dist + uv_blk_col, v_dist + uv_blk_col,
        neighbors_fst, neighbors_snd, top_weight, bottom_weight, NULL);
  }

  // Right
  if (ss_x && ss_y) {
    neighbors_snd = HIGHBD_CHROMA_DOUBLE_SS_RIGHT_COLUMN_NEIGHBORS;
  } else if (ss_x || ss_y) {
    neighbors_snd = HIGHBD_CHROMA_SINGLE_SS_RIGHT_COLUMN_NEIGHBORS;
  } else {
    neighbors_snd = HIGHBD_CHROMA_NO_SS_RIGHT_COLUMN_NEIGHBORS;
  }

  highbd_apply_temporal_filter_chroma_8(
      y_src + blk_col, y_src_stride, y_pre + blk_col, y_pre_stride,
      u_src + uv_blk_col, v_src + uv_blk_col, uv_src_stride, u_pre + uv_blk_col,
      v_pre + uv_blk_col, uv_pre_stride, uv_width, uv_height, ss_x, ss_y,
      strength, u_accum + uv_blk_col, u_count + uv_blk_col,
      v_accum + uv_blk_col, v_count + uv_blk_col, y_dist + blk_col,
      u_dist + uv_blk_col, v_dist + uv_blk_col, neighbors_fst, neighbors_snd,
      top_weight, bottom_weight, NULL);
}

static void highbd_apply_temporal_filter_yuv(
    const YV12_BUFFER_CONFIG *ref_frame, const MACROBLOCKD *mbd,
    const BLOCK_SIZE block_size, const int mb_row, const int mb_col,
    const int strength, const int use_subblock,
    const int *subblock_filter_weights, const uint8_t *pred, uint32_t *accum,
    uint16_t *count) {
  const int use_whole_blk = !use_subblock;
  const int *blk_fw = subblock_filter_weights;

  // Block information (Y-plane).
  const unsigned int block_height = block_size_high[block_size];
  const unsigned int block_width = block_size_wide[block_size];
  const int mb_pels = block_height * block_width;
  const int y_src_stride = ref_frame->y_stride;
  const int y_pre_stride = block_width;
  const int mb_y_src_offset =
      mb_row * block_height * ref_frame->y_stride + mb_col * block_width;

  // Block information (UV-plane).
  const int ss_y = mbd->plane[1].subsampling_y;
  const int ss_x = mbd->plane[1].subsampling_x;
  const unsigned int uv_height = block_height >> ss_y;
  const unsigned int uv_width = block_width >> ss_x;
  const int uv_src_stride = ref_frame->uv_stride;
  const int uv_pre_stride = block_width >> ss_x;
  const int mb_uv_src_offset =
      mb_row * uv_height * ref_frame->uv_stride + mb_col * uv_width;

  const uint8_t *y_src = ref_frame->y_buffer + mb_y_src_offset;
  const uint8_t *u_src = ref_frame->u_buffer + mb_uv_src_offset;
  const uint8_t *v_src = ref_frame->v_buffer + mb_uv_src_offset;
  const uint8_t *y_pre = pred;
  const uint8_t *u_pre = pred + mb_pels;
  const uint8_t *v_pre = pred + mb_pels * 2;
  uint32_t *y_accum = accum;
  uint32_t *u_accum = accum + mb_pels;
  uint32_t *v_accum = accum + mb_pels * 2;
  uint16_t *y_count = count;
  uint16_t *u_count = count + mb_pels;
  uint16_t *v_count = count + mb_pels * 2;

  const unsigned int chroma_height = block_height >> ss_y,
                     chroma_width = block_width >> ss_x;

  DECLARE_ALIGNED(16, uint32_t, y_dist[BH * DIST_STRIDE]) = { 0 };
  DECLARE_ALIGNED(16, uint32_t, u_dist[BH * DIST_STRIDE]) = { 0 };
  DECLARE_ALIGNED(16, uint32_t, v_dist[BH * DIST_STRIDE]) = { 0 };

  uint32_t *y_dist_ptr = y_dist + 1, *u_dist_ptr = u_dist + 1,
           *v_dist_ptr = v_dist + 1;
  const uint16_t *y_src_ptr = CONVERT_TO_SHORTPTR(y_src),
                 *u_src_ptr = CONVERT_TO_SHORTPTR(u_src),
                 *v_src_ptr = CONVERT_TO_SHORTPTR(v_src);
  const uint16_t *y_pre_ptr = CONVERT_TO_SHORTPTR(y_pre),
                 *u_pre_ptr = CONVERT_TO_SHORTPTR(u_pre),
                 *v_pre_ptr = CONVERT_TO_SHORTPTR(v_pre);

  // Loop variables
  unsigned int row, blk_col;

  assert(block_width <= BW && "block width too large");
  assert(block_height <= BH && "block height too large");
  assert(block_width % 16 == 0 && "block width must be multiple of 16");
  assert(block_height % 2 == 0 && "block height must be even");
  assert((ss_x == 0 || ss_x == 1) && (ss_y == 0 || ss_y == 1) &&
         "invalid chroma subsampling");
  assert(strength >= 0 && strength <= 14 &&
         "invalid adjusted temporal filter strength");
  assert(blk_fw[0] >= 0 && "filter weight must be positive");
  assert(
      (use_whole_blk || (blk_fw[1] >= 0 && blk_fw[2] >= 0 && blk_fw[3] >= 0)) &&
      "subblock filter weight must be positive");
  assert(blk_fw[0] <= 2 && "sublock filter weight must be less than 2");
  assert(
      (use_whole_blk || (blk_fw[1] <= 2 && blk_fw[2] <= 2 && blk_fw[3] <= 2)) &&
      "subblock filter weight must be less than 2");

  // Precompute the difference squared
  for (row = 0; row < block_height; row++) {
    for (blk_col = 0; blk_col < block_width; blk_col += 8) {
      highbd_store_dist_8(y_src_ptr + blk_col, y_pre_ptr + blk_col,
                          y_dist_ptr + blk_col);
    }
    y_src_ptr += y_src_stride;
    y_pre_ptr += y_pre_stride;
    y_dist_ptr += DIST_STRIDE;
  }

  for (row = 0; row < chroma_height; row++) {
    for (blk_col = 0; blk_col < chroma_width; blk_col += 8) {
      highbd_store_dist_8(u_src_ptr + blk_col, u_pre_ptr + blk_col,
                          u_dist_ptr + blk_col);
      highbd_store_dist_8(v_src_ptr + blk_col, v_pre_ptr + blk_col,
                          v_dist_ptr + blk_col);
    }

    u_src_ptr += uv_src_stride;
    u_pre_ptr += uv_pre_stride;
    u_dist_ptr += DIST_STRIDE;
    v_src_ptr += uv_src_stride;
    v_pre_ptr += uv_pre_stride;
    v_dist_ptr += DIST_STRIDE;
  }

  y_src_ptr = CONVERT_TO_SHORTPTR(y_src),
  u_src_ptr = CONVERT_TO_SHORTPTR(u_src),
  v_src_ptr = CONVERT_TO_SHORTPTR(v_src);
  y_pre_ptr = CONVERT_TO_SHORTPTR(y_pre),
  u_pre_ptr = CONVERT_TO_SHORTPTR(u_pre),
  v_pre_ptr = CONVERT_TO_SHORTPTR(v_pre);

  y_dist_ptr = y_dist + 1;
  u_dist_ptr = u_dist + 1;
  v_dist_ptr = v_dist + 1;

  highbd_apply_temporal_filter_luma(
      y_src_ptr, y_src_stride, y_pre_ptr, y_pre_stride, u_src_ptr, v_src_ptr,
      uv_src_stride, u_pre_ptr, v_pre_ptr, uv_pre_stride, block_width,
      block_height, ss_x, ss_y, strength, blk_fw, use_whole_blk, y_accum,
      y_count, y_dist_ptr, u_dist_ptr, v_dist_ptr);

  highbd_apply_temporal_filter_chroma(
      y_src_ptr, y_src_stride, y_pre_ptr, y_pre_stride, u_src_ptr, v_src_ptr,
      uv_src_stride, u_pre_ptr, v_pre_ptr, uv_pre_stride, block_width,
      block_height, ss_x, ss_y, strength, blk_fw, use_whole_blk, u_accum,
      u_count, v_accum, v_count, y_dist_ptr, u_dist_ptr, v_dist_ptr);
}

/////////////////////////
// High bit-depth Ends //
/////////////////////////

void av1_apply_temporal_filter_yuv_sse4_1(
    const YV12_BUFFER_CONFIG *ref_frame, const MACROBLOCKD *mbd,
    const BLOCK_SIZE block_size, const int mb_row, const int mb_col,
    const int num_planes, const int strength, const int use_subblock,
    const int *subblock_filter_weights, const uint8_t *pred, uint32_t *accum,
    uint16_t *count) {
  const int is_high_bitdepth = ref_frame->flags & YV12_FLAG_HIGHBITDEPTH;
  // TODO(any): Need to support when `num_planes != 3`, like C implementation.
  assert(num_planes == 3);
  (void)num_planes;
  if (is_high_bitdepth) {
    highbd_apply_temporal_filter_yuv(
        ref_frame, mbd, block_size, mb_row, mb_col, strength, use_subblock,
        subblock_filter_weights, pred, accum, count);
  } else {
    apply_temporal_filter_yuv(ref_frame, mbd, block_size, mb_row, mb_col,
                              strength, use_subblock, subblock_filter_weights,
                              pred, accum, count);
  }
}
