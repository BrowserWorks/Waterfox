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

#include <emmintrin.h>

#include "aom_dsp/x86/synonyms.h"

#include "./aom_dsp_rtcd.h"
#include "aom_ports/mem.h"

void aom_minmax_8x8_sse2(const uint8_t *s, int p, const uint8_t *d, int dp,
                         int *min, int *max) {
  __m128i u0, s0, d0, diff, maxabsdiff, minabsdiff, negdiff, absdiff0, absdiff;
  u0 = _mm_setzero_si128();
  // Row 0
  s0 = _mm_unpacklo_epi8(_mm_loadl_epi64((const __m128i *)(s)), u0);
  d0 = _mm_unpacklo_epi8(_mm_loadl_epi64((const __m128i *)(d)), u0);
  diff = _mm_subs_epi16(s0, d0);
  negdiff = _mm_subs_epi16(u0, diff);
  absdiff0 = _mm_max_epi16(diff, negdiff);
  // Row 1
  s0 = _mm_unpacklo_epi8(_mm_loadl_epi64((const __m128i *)(s + p)), u0);
  d0 = _mm_unpacklo_epi8(_mm_loadl_epi64((const __m128i *)(d + dp)), u0);
  diff = _mm_subs_epi16(s0, d0);
  negdiff = _mm_subs_epi16(u0, diff);
  absdiff = _mm_max_epi16(diff, negdiff);
  maxabsdiff = _mm_max_epi16(absdiff0, absdiff);
  minabsdiff = _mm_min_epi16(absdiff0, absdiff);
  // Row 2
  s0 = _mm_unpacklo_epi8(_mm_loadl_epi64((const __m128i *)(s + 2 * p)), u0);
  d0 = _mm_unpacklo_epi8(_mm_loadl_epi64((const __m128i *)(d + 2 * dp)), u0);
  diff = _mm_subs_epi16(s0, d0);
  negdiff = _mm_subs_epi16(u0, diff);
  absdiff = _mm_max_epi16(diff, negdiff);
  maxabsdiff = _mm_max_epi16(maxabsdiff, absdiff);
  minabsdiff = _mm_min_epi16(minabsdiff, absdiff);
  // Row 3
  s0 = _mm_unpacklo_epi8(_mm_loadl_epi64((const __m128i *)(s + 3 * p)), u0);
  d0 = _mm_unpacklo_epi8(_mm_loadl_epi64((const __m128i *)(d + 3 * dp)), u0);
  diff = _mm_subs_epi16(s0, d0);
  negdiff = _mm_subs_epi16(u0, diff);
  absdiff = _mm_max_epi16(diff, negdiff);
  maxabsdiff = _mm_max_epi16(maxabsdiff, absdiff);
  minabsdiff = _mm_min_epi16(minabsdiff, absdiff);
  // Row 4
  s0 = _mm_unpacklo_epi8(_mm_loadl_epi64((const __m128i *)(s + 4 * p)), u0);
  d0 = _mm_unpacklo_epi8(_mm_loadl_epi64((const __m128i *)(d + 4 * dp)), u0);
  diff = _mm_subs_epi16(s0, d0);
  negdiff = _mm_subs_epi16(u0, diff);
  absdiff = _mm_max_epi16(diff, negdiff);
  maxabsdiff = _mm_max_epi16(maxabsdiff, absdiff);
  minabsdiff = _mm_min_epi16(minabsdiff, absdiff);
  // Row 5
  s0 = _mm_unpacklo_epi8(_mm_loadl_epi64((const __m128i *)(s + 5 * p)), u0);
  d0 = _mm_unpacklo_epi8(_mm_loadl_epi64((const __m128i *)(d + 5 * dp)), u0);
  diff = _mm_subs_epi16(s0, d0);
  negdiff = _mm_subs_epi16(u0, diff);
  absdiff = _mm_max_epi16(diff, negdiff);
  maxabsdiff = _mm_max_epi16(maxabsdiff, absdiff);
  minabsdiff = _mm_min_epi16(minabsdiff, absdiff);
  // Row 6
  s0 = _mm_unpacklo_epi8(_mm_loadl_epi64((const __m128i *)(s + 6 * p)), u0);
  d0 = _mm_unpacklo_epi8(_mm_loadl_epi64((const __m128i *)(d + 6 * dp)), u0);
  diff = _mm_subs_epi16(s0, d0);
  negdiff = _mm_subs_epi16(u0, diff);
  absdiff = _mm_max_epi16(diff, negdiff);
  maxabsdiff = _mm_max_epi16(maxabsdiff, absdiff);
  minabsdiff = _mm_min_epi16(minabsdiff, absdiff);
  // Row 7
  s0 = _mm_unpacklo_epi8(_mm_loadl_epi64((const __m128i *)(s + 7 * p)), u0);
  d0 = _mm_unpacklo_epi8(_mm_loadl_epi64((const __m128i *)(d + 7 * dp)), u0);
  diff = _mm_subs_epi16(s0, d0);
  negdiff = _mm_subs_epi16(u0, diff);
  absdiff = _mm_max_epi16(diff, negdiff);
  maxabsdiff = _mm_max_epi16(maxabsdiff, absdiff);
  minabsdiff = _mm_min_epi16(minabsdiff, absdiff);

  maxabsdiff = _mm_max_epi16(maxabsdiff, _mm_srli_si128(maxabsdiff, 8));
  maxabsdiff = _mm_max_epi16(maxabsdiff, _mm_srli_epi64(maxabsdiff, 32));
  maxabsdiff = _mm_max_epi16(maxabsdiff, _mm_srli_epi64(maxabsdiff, 16));
  *max = _mm_extract_epi16(maxabsdiff, 0);

  minabsdiff = _mm_min_epi16(minabsdiff, _mm_srli_si128(minabsdiff, 8));
  minabsdiff = _mm_min_epi16(minabsdiff, _mm_srli_epi64(minabsdiff, 32));
  minabsdiff = _mm_min_epi16(minabsdiff, _mm_srli_epi64(minabsdiff, 16));
  *min = _mm_extract_epi16(minabsdiff, 0);
}

static void hadamard_col8_sse2(__m128i *in, int iter) {
  __m128i a0 = in[0];
  __m128i a1 = in[1];
  __m128i a2 = in[2];
  __m128i a3 = in[3];
  __m128i a4 = in[4];
  __m128i a5 = in[5];
  __m128i a6 = in[6];
  __m128i a7 = in[7];

  __m128i b0 = _mm_add_epi16(a0, a1);
  __m128i b1 = _mm_sub_epi16(a0, a1);
  __m128i b2 = _mm_add_epi16(a2, a3);
  __m128i b3 = _mm_sub_epi16(a2, a3);
  __m128i b4 = _mm_add_epi16(a4, a5);
  __m128i b5 = _mm_sub_epi16(a4, a5);
  __m128i b6 = _mm_add_epi16(a6, a7);
  __m128i b7 = _mm_sub_epi16(a6, a7);

  a0 = _mm_add_epi16(b0, b2);
  a1 = _mm_add_epi16(b1, b3);
  a2 = _mm_sub_epi16(b0, b2);
  a3 = _mm_sub_epi16(b1, b3);
  a4 = _mm_add_epi16(b4, b6);
  a5 = _mm_add_epi16(b5, b7);
  a6 = _mm_sub_epi16(b4, b6);
  a7 = _mm_sub_epi16(b5, b7);

  if (iter == 0) {
    b0 = _mm_add_epi16(a0, a4);
    b7 = _mm_add_epi16(a1, a5);
    b3 = _mm_add_epi16(a2, a6);
    b4 = _mm_add_epi16(a3, a7);
    b2 = _mm_sub_epi16(a0, a4);
    b6 = _mm_sub_epi16(a1, a5);
    b1 = _mm_sub_epi16(a2, a6);
    b5 = _mm_sub_epi16(a3, a7);

    a0 = _mm_unpacklo_epi16(b0, b1);
    a1 = _mm_unpacklo_epi16(b2, b3);
    a2 = _mm_unpackhi_epi16(b0, b1);
    a3 = _mm_unpackhi_epi16(b2, b3);
    a4 = _mm_unpacklo_epi16(b4, b5);
    a5 = _mm_unpacklo_epi16(b6, b7);
    a6 = _mm_unpackhi_epi16(b4, b5);
    a7 = _mm_unpackhi_epi16(b6, b7);

    b0 = _mm_unpacklo_epi32(a0, a1);
    b1 = _mm_unpacklo_epi32(a4, a5);
    b2 = _mm_unpackhi_epi32(a0, a1);
    b3 = _mm_unpackhi_epi32(a4, a5);
    b4 = _mm_unpacklo_epi32(a2, a3);
    b5 = _mm_unpacklo_epi32(a6, a7);
    b6 = _mm_unpackhi_epi32(a2, a3);
    b7 = _mm_unpackhi_epi32(a6, a7);

    in[0] = _mm_unpacklo_epi64(b0, b1);
    in[1] = _mm_unpackhi_epi64(b0, b1);
    in[2] = _mm_unpacklo_epi64(b2, b3);
    in[3] = _mm_unpackhi_epi64(b2, b3);
    in[4] = _mm_unpacklo_epi64(b4, b5);
    in[5] = _mm_unpackhi_epi64(b4, b5);
    in[6] = _mm_unpacklo_epi64(b6, b7);
    in[7] = _mm_unpackhi_epi64(b6, b7);
  } else {
    in[0] = _mm_add_epi16(a0, a4);
    in[7] = _mm_add_epi16(a1, a5);
    in[3] = _mm_add_epi16(a2, a6);
    in[4] = _mm_add_epi16(a3, a7);
    in[2] = _mm_sub_epi16(a0, a4);
    in[6] = _mm_sub_epi16(a1, a5);
    in[1] = _mm_sub_epi16(a2, a6);
    in[5] = _mm_sub_epi16(a3, a7);
  }
}

void aom_hadamard_8x8_sse2(int16_t const *src_diff, int src_stride,
                           int16_t *coeff) {
  __m128i src[8];
  src[0] = _mm_load_si128((const __m128i *)src_diff);
  src[1] = _mm_load_si128((const __m128i *)(src_diff += src_stride));
  src[2] = _mm_load_si128((const __m128i *)(src_diff += src_stride));
  src[3] = _mm_load_si128((const __m128i *)(src_diff += src_stride));
  src[4] = _mm_load_si128((const __m128i *)(src_diff += src_stride));
  src[5] = _mm_load_si128((const __m128i *)(src_diff += src_stride));
  src[6] = _mm_load_si128((const __m128i *)(src_diff += src_stride));
  src[7] = _mm_load_si128((const __m128i *)(src_diff += src_stride));

  hadamard_col8_sse2(src, 0);
  hadamard_col8_sse2(src, 1);

  _mm_store_si128((__m128i *)coeff, src[0]);
  coeff += 8;
  _mm_store_si128((__m128i *)coeff, src[1]);
  coeff += 8;
  _mm_store_si128((__m128i *)coeff, src[2]);
  coeff += 8;
  _mm_store_si128((__m128i *)coeff, src[3]);
  coeff += 8;
  _mm_store_si128((__m128i *)coeff, src[4]);
  coeff += 8;
  _mm_store_si128((__m128i *)coeff, src[5]);
  coeff += 8;
  _mm_store_si128((__m128i *)coeff, src[6]);
  coeff += 8;
  _mm_store_si128((__m128i *)coeff, src[7]);
}

void aom_hadamard_16x16_sse2(int16_t const *src_diff, int src_stride,
                             int16_t *coeff) {
  int idx;
  for (idx = 0; idx < 4; ++idx) {
    int16_t const *src_ptr =
        src_diff + (idx >> 1) * 8 * src_stride + (idx & 0x01) * 8;
    aom_hadamard_8x8_sse2(src_ptr, src_stride, coeff + idx * 64);
  }

  for (idx = 0; idx < 64; idx += 8) {
    __m128i coeff0 = _mm_load_si128((const __m128i *)coeff);
    __m128i coeff1 = _mm_load_si128((const __m128i *)(coeff + 64));
    __m128i coeff2 = _mm_load_si128((const __m128i *)(coeff + 128));
    __m128i coeff3 = _mm_load_si128((const __m128i *)(coeff + 192));

    __m128i b0 = _mm_add_epi16(coeff0, coeff1);
    __m128i b1 = _mm_sub_epi16(coeff0, coeff1);
    __m128i b2 = _mm_add_epi16(coeff2, coeff3);
    __m128i b3 = _mm_sub_epi16(coeff2, coeff3);

    b0 = _mm_srai_epi16(b0, 1);
    b1 = _mm_srai_epi16(b1, 1);
    b2 = _mm_srai_epi16(b2, 1);
    b3 = _mm_srai_epi16(b3, 1);

    coeff0 = _mm_add_epi16(b0, b2);
    coeff1 = _mm_add_epi16(b1, b3);
    _mm_store_si128((__m128i *)coeff, coeff0);
    _mm_store_si128((__m128i *)(coeff + 64), coeff1);

    coeff2 = _mm_sub_epi16(b0, b2);
    coeff3 = _mm_sub_epi16(b1, b3);
    _mm_store_si128((__m128i *)(coeff + 128), coeff2);
    _mm_store_si128((__m128i *)(coeff + 192), coeff3);

    coeff += 8;
  }
}

int aom_satd_sse2(const int16_t *coeff, int length) {
  int i;
  const __m128i zero = _mm_setzero_si128();
  __m128i accum = zero;

  for (i = 0; i < length; i += 8) {
    const __m128i src_line = _mm_load_si128((const __m128i *)coeff);
    const __m128i inv = _mm_sub_epi16(zero, src_line);
    const __m128i abs = _mm_max_epi16(src_line, inv);  // abs(src_line)
    const __m128i abs_lo = _mm_unpacklo_epi16(abs, zero);
    const __m128i abs_hi = _mm_unpackhi_epi16(abs, zero);
    const __m128i sum = _mm_add_epi32(abs_lo, abs_hi);
    accum = _mm_add_epi32(accum, sum);
    coeff += 8;
  }

  {  // cascading summation of accum
    __m128i hi = _mm_srli_si128(accum, 8);
    accum = _mm_add_epi32(accum, hi);
    hi = _mm_srli_epi64(accum, 32);
    accum = _mm_add_epi32(accum, hi);
  }

  return _mm_cvtsi128_si32(accum);
}

void aom_int_pro_row_sse2(int16_t *hbuf, uint8_t const *ref, int ref_stride,
                          int height) {
  int idx;
  __m128i zero = _mm_setzero_si128();
  __m128i src_line = _mm_loadu_si128((const __m128i *)ref);
  __m128i s0 = _mm_unpacklo_epi8(src_line, zero);
  __m128i s1 = _mm_unpackhi_epi8(src_line, zero);
  __m128i t0, t1;
  int height_1 = height - 1;
  ref += ref_stride;

  for (idx = 1; idx < height_1; idx += 2) {
    src_line = _mm_loadu_si128((const __m128i *)ref);
    t0 = _mm_unpacklo_epi8(src_line, zero);
    t1 = _mm_unpackhi_epi8(src_line, zero);
    s0 = _mm_adds_epu16(s0, t0);
    s1 = _mm_adds_epu16(s1, t1);
    ref += ref_stride;

    src_line = _mm_loadu_si128((const __m128i *)ref);
    t0 = _mm_unpacklo_epi8(src_line, zero);
    t1 = _mm_unpackhi_epi8(src_line, zero);
    s0 = _mm_adds_epu16(s0, t0);
    s1 = _mm_adds_epu16(s1, t1);
    ref += ref_stride;
  }

  src_line = _mm_loadu_si128((const __m128i *)ref);
  t0 = _mm_unpacklo_epi8(src_line, zero);
  t1 = _mm_unpackhi_epi8(src_line, zero);
  s0 = _mm_adds_epu16(s0, t0);
  s1 = _mm_adds_epu16(s1, t1);

  if (height == 64) {
    s0 = _mm_srai_epi16(s0, 5);
    s1 = _mm_srai_epi16(s1, 5);
  } else if (height == 32) {
    s0 = _mm_srai_epi16(s0, 4);
    s1 = _mm_srai_epi16(s1, 4);
  } else {
    s0 = _mm_srai_epi16(s0, 3);
    s1 = _mm_srai_epi16(s1, 3);
  }

  _mm_storeu_si128((__m128i *)hbuf, s0);
  hbuf += 8;
  _mm_storeu_si128((__m128i *)hbuf, s1);
}

int16_t aom_int_pro_col_sse2(uint8_t const *ref, int width) {
  __m128i zero = _mm_setzero_si128();
  __m128i src_line = _mm_load_si128((const __m128i *)ref);
  __m128i s0 = _mm_sad_epu8(src_line, zero);
  __m128i s1;
  int i;

  for (i = 16; i < width; i += 16) {
    ref += 16;
    src_line = _mm_load_si128((const __m128i *)ref);
    s1 = _mm_sad_epu8(src_line, zero);
    s0 = _mm_adds_epu16(s0, s1);
  }

  s1 = _mm_srli_si128(s0, 8);
  s0 = _mm_adds_epu16(s0, s1);

  return _mm_extract_epi16(s0, 0);
}

int aom_vector_var_sse2(int16_t const *ref, int16_t const *src, int bwl) {
  int idx;
  int width = 4 << bwl;
  int16_t mean;
  __m128i v0 = _mm_loadu_si128((const __m128i *)ref);
  __m128i v1 = _mm_load_si128((const __m128i *)src);
  __m128i diff = _mm_subs_epi16(v0, v1);
  __m128i sum = diff;
  __m128i sse = _mm_madd_epi16(diff, diff);

  ref += 8;
  src += 8;

  for (idx = 8; idx < width; idx += 8) {
    v0 = _mm_loadu_si128((const __m128i *)ref);
    v1 = _mm_load_si128((const __m128i *)src);
    diff = _mm_subs_epi16(v0, v1);

    sum = _mm_add_epi16(sum, diff);
    v0 = _mm_madd_epi16(diff, diff);
    sse = _mm_add_epi32(sse, v0);

    ref += 8;
    src += 8;
  }

  v0 = _mm_srli_si128(sum, 8);
  sum = _mm_add_epi16(sum, v0);
  v0 = _mm_srli_epi64(sum, 32);
  sum = _mm_add_epi16(sum, v0);
  v0 = _mm_srli_epi32(sum, 16);
  sum = _mm_add_epi16(sum, v0);

  v1 = _mm_srli_si128(sse, 8);
  sse = _mm_add_epi32(sse, v1);
  v1 = _mm_srli_epi64(sse, 32);
  sse = _mm_add_epi32(sse, v1);

  mean = _mm_extract_epi16(sum, 0);

  return _mm_cvtsi128_si32(sse) - ((mean * mean) >> (bwl + 2));
}
