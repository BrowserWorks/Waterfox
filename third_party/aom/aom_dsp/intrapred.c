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
#include <math.h>

#include "./aom_config.h"
#include "./aom_dsp_rtcd.h"

#include "aom_dsp/aom_dsp_common.h"
#include "aom_mem/aom_mem.h"
#include "aom_ports/bitops.h"

#define DST(x, y) dst[(x) + (y)*stride]
#define AVG3(a, b, c) (((a) + 2 * (b) + (c) + 2) >> 2)
#define AVG2(a, b) (((a) + (b) + 1) >> 1)

static INLINE void d207e_predictor(uint8_t *dst, ptrdiff_t stride, int bs,
                                   const uint8_t *above, const uint8_t *left) {
  int r, c;
  (void)above;

  for (r = 0; r < bs; ++r) {
    for (c = 0; c < bs; ++c) {
      dst[c] = c & 1 ? AVG3(left[(c >> 1) + r], left[(c >> 1) + r + 1],
                            left[(c >> 1) + r + 2])
                     : AVG2(left[(c >> 1) + r], left[(c >> 1) + r + 1]);
    }
    dst += stride;
  }
}

static INLINE void d63e_predictor(uint8_t *dst, ptrdiff_t stride, int bs,
                                  const uint8_t *above, const uint8_t *left) {
  int r, c;
  (void)left;
  for (r = 0; r < bs; ++r) {
    for (c = 0; c < bs; ++c) {
      dst[c] = r & 1 ? AVG3(above[(r >> 1) + c], above[(r >> 1) + c + 1],
                            above[(r >> 1) + c + 2])
                     : AVG2(above[(r >> 1) + c], above[(r >> 1) + c + 1]);
    }
    dst += stride;
  }
}

static INLINE void d45e_predictor(uint8_t *dst, ptrdiff_t stride, int bs,
                                  const uint8_t *above, const uint8_t *left) {
  int r, c;
  (void)left;
  for (r = 0; r < bs; ++r) {
    for (c = 0; c < bs; ++c) {
      dst[c] = AVG3(above[r + c], above[r + c + 1],
                    above[r + c + 1 + (r + c + 2 < bs * 2)]);
    }
    dst += stride;
  }
}

static INLINE void d117_predictor(uint8_t *dst, ptrdiff_t stride, int bs,
                                  const uint8_t *above, const uint8_t *left) {
  int r, c;

  // first row
  for (c = 0; c < bs; c++) dst[c] = AVG2(above[c - 1], above[c]);
  dst += stride;

  // second row
  dst[0] = AVG3(left[0], above[-1], above[0]);
  for (c = 1; c < bs; c++) dst[c] = AVG3(above[c - 2], above[c - 1], above[c]);
  dst += stride;

  // the rest of first col
  dst[0] = AVG3(above[-1], left[0], left[1]);
  for (r = 3; r < bs; ++r)
    dst[(r - 2) * stride] = AVG3(left[r - 3], left[r - 2], left[r - 1]);

  // the rest of the block
  for (r = 2; r < bs; ++r) {
    for (c = 1; c < bs; c++) dst[c] = dst[-2 * stride + c - 1];
    dst += stride;
  }
}

static INLINE void d135_predictor(uint8_t *dst, ptrdiff_t stride, int bs,
                                  const uint8_t *above, const uint8_t *left) {
  int i;
#if CONFIG_TX64X64
#if defined(__GNUC__) && __GNUC__ == 4 && __GNUC_MINOR__ > 7
  // silence a spurious -Warray-bounds warning, possibly related to:
  // https://gcc.gnu.org/bugzilla/show_bug.cgi?id=56273
  uint8_t border[133];
#else
  uint8_t border[64 + 64 - 1];  // outer border from bottom-left to top-right
#endif
#else
#if defined(__GNUC__) && __GNUC__ == 4 && __GNUC_MINOR__ > 7
  // silence a spurious -Warray-bounds warning, possibly related to:
  // https://gcc.gnu.org/bugzilla/show_bug.cgi?id=56273
  uint8_t border[69];
#else
  uint8_t border[32 + 32 - 1];  // outer border from bottom-left to top-right
#endif
#endif  // CONFIG_TX64X64

  // dst(bs, bs - 2)[0], i.e., border starting at bottom-left
  for (i = 0; i < bs - 2; ++i) {
    border[i] = AVG3(left[bs - 3 - i], left[bs - 2 - i], left[bs - 1 - i]);
  }
  border[bs - 2] = AVG3(above[-1], left[0], left[1]);
  border[bs - 1] = AVG3(left[0], above[-1], above[0]);
  border[bs - 0] = AVG3(above[-1], above[0], above[1]);
  // dst[0][2, size), i.e., remaining top border ascending
  for (i = 0; i < bs - 2; ++i) {
    border[bs + 1 + i] = AVG3(above[i], above[i + 1], above[i + 2]);
  }

  for (i = 0; i < bs; ++i) {
    memcpy(dst + i * stride, border + bs - 1 - i, bs);
  }
}

static INLINE void d153_predictor(uint8_t *dst, ptrdiff_t stride, int bs,
                                  const uint8_t *above, const uint8_t *left) {
  int r, c;
  dst[0] = AVG2(above[-1], left[0]);
  for (r = 1; r < bs; r++) dst[r * stride] = AVG2(left[r - 1], left[r]);
  dst++;

  dst[0] = AVG3(left[0], above[-1], above[0]);
  dst[stride] = AVG3(above[-1], left[0], left[1]);
  for (r = 2; r < bs; r++)
    dst[r * stride] = AVG3(left[r - 2], left[r - 1], left[r]);
  dst++;

  for (c = 0; c < bs - 2; c++)
    dst[c] = AVG3(above[c - 1], above[c], above[c + 1]);
  dst += stride;

  for (r = 1; r < bs; ++r) {
    for (c = 0; c < bs - 2; c++) dst[c] = dst[-stride + c - 2];
    dst += stride;
  }
}

static INLINE void v_predictor(uint8_t *dst, ptrdiff_t stride, int bs,
                               const uint8_t *above, const uint8_t *left) {
  int r;
  (void)left;

  for (r = 0; r < bs; r++) {
    memcpy(dst, above, bs);
    dst += stride;
  }
}

static INLINE void h_predictor(uint8_t *dst, ptrdiff_t stride, int bs,
                               const uint8_t *above, const uint8_t *left) {
  int r;
  (void)above;

  for (r = 0; r < bs; r++) {
    memset(dst, left[r], bs);
    dst += stride;
  }
}

#if CONFIG_ALT_INTRA
static INLINE int abs_diff(int a, int b) { return (a > b) ? a - b : b - a; }

static INLINE uint16_t paeth_predictor_single(uint16_t left, uint16_t top,
                                              uint16_t top_left) {
  const int base = top + left - top_left;
  const int p_left = abs_diff(base, left);
  const int p_top = abs_diff(base, top);
  const int p_top_left = abs_diff(base, top_left);

  // Return nearest to base of left, top and top_left.
  return (p_left <= p_top && p_left <= p_top_left)
             ? left
             : (p_top <= p_top_left) ? top : top_left;
}

static INLINE void paeth_predictor(uint8_t *dst, ptrdiff_t stride, int bs,
                                   const uint8_t *above, const uint8_t *left) {
  int r, c;
  const uint8_t ytop_left = above[-1];

  for (r = 0; r < bs; r++) {
    for (c = 0; c < bs; c++)
      dst[c] = (uint8_t)paeth_predictor_single(left[r], above[c], ytop_left);
    dst += stride;
  }
}

// Weights are quadratic from '1' to '1 / block_size', scaled by
// 2^sm_weight_log2_scale.
static const int sm_weight_log2_scale = 8;

#if CONFIG_TX64X64
// max(block_size_wide[BLOCK_LARGEST], block_size_high[BLOCK_LARGEST])
#define MAX_BLOCK_DIM 64
#else
#define MAX_BLOCK_DIM 32
#endif  // CONFIG_TX64X64

static const uint8_t sm_weight_arrays[2 * MAX_BLOCK_DIM] = {
  // Unused, because we always offset by bs, which is at least 2.
  0, 0,
  // bs = 2
  255, 128,
  // bs = 4
  255, 149, 85, 64,
  // bs = 8
  255, 197, 146, 105, 73, 50, 37, 32,
  // bs = 16
  255, 225, 196, 170, 145, 123, 102, 84, 68, 54, 43, 33, 26, 20, 17, 16,
  // bs = 32
  255, 240, 225, 210, 196, 182, 169, 157, 145, 133, 122, 111, 101, 92, 83, 74,
  66, 59, 52, 45, 39, 34, 29, 25, 21, 17, 14, 12, 10, 9, 8, 8,
#if CONFIG_TX64X64
  // bs = 64
  255, 248, 240, 233, 225, 218, 210, 203, 196, 189, 182, 176, 169, 163, 156,
  150, 144, 138, 133, 127, 121, 116, 111, 106, 101, 96, 91, 86, 82, 77, 73, 69,
  65, 61, 57, 54, 50, 47, 44, 41, 38, 35, 32, 29, 27, 25, 22, 20, 18, 16, 15,
  13, 12, 10, 9, 8, 7, 6, 6, 5, 5, 4, 4, 4,
#endif  // CONFIG_TX64X64
};

// Some basic checks on weights for smooth predictor.
#define sm_weights_sanity_checks(weights, weights_scale, pred_scale) \
  assert(weights[0] < weights_scale);                                \
  assert(weights_scale - weights[bs - 1] < weights_scale);           \
  assert(pred_scale < 31)  // ensures no overflow when calculating predictor.

#define divide_round(value, bits) (((value) + (1 << ((bits)-1))) >> (bits))

static INLINE void smooth_predictor(uint8_t *dst, ptrdiff_t stride, int bs,
                                    const uint8_t *above, const uint8_t *left) {
  const uint8_t below_pred = left[bs - 1];   // estimated by bottom-left pixel
  const uint8_t right_pred = above[bs - 1];  // estimated by top-right pixel
  const uint8_t *const sm_weights = sm_weight_arrays + bs;
  // scale = 2 * 2^sm_weight_log2_scale
  const int log2_scale = 1 + sm_weight_log2_scale;
  const uint16_t scale = (1 << sm_weight_log2_scale);
  sm_weights_sanity_checks(sm_weights, scale, log2_scale + sizeof(*dst));
  int r;
  for (r = 0; r < bs; ++r) {
    int c;
    for (c = 0; c < bs; ++c) {
      const uint8_t pixels[] = { above[c], below_pred, left[r], right_pred };
      const uint8_t weights[] = { sm_weights[r], scale - sm_weights[r],
                                  sm_weights[c], scale - sm_weights[c] };
      uint32_t this_pred = 0;
      int i;
      assert(scale >= sm_weights[r] && scale >= sm_weights[c]);
      for (i = 0; i < 4; ++i) {
        this_pred += weights[i] * pixels[i];
      }
      dst[c] = clip_pixel(divide_round(this_pred, log2_scale));
    }
    dst += stride;
  }
}

#if CONFIG_SMOOTH_HV
static INLINE void smooth_v_predictor(uint8_t *dst, ptrdiff_t stride, int bs,
                                      const uint8_t *above,
                                      const uint8_t *left) {
  const uint8_t below_pred = left[bs - 1];  // estimated by bottom-left pixel
  const uint8_t *const sm_weights = sm_weight_arrays + bs;
  // scale = 2^sm_weight_log2_scale
  const int log2_scale = sm_weight_log2_scale;
  const uint16_t scale = (1 << sm_weight_log2_scale);
  sm_weights_sanity_checks(sm_weights, scale, log2_scale + sizeof(*dst));

  int r;
  for (r = 0; r < bs; r++) {
    int c;
    for (c = 0; c < bs; ++c) {
      const uint8_t pixels[] = { above[c], below_pred };
      const uint8_t weights[] = { sm_weights[r], scale - sm_weights[r] };
      uint32_t this_pred = 0;
      assert(scale >= sm_weights[r]);
      int i;
      for (i = 0; i < 2; ++i) {
        this_pred += weights[i] * pixels[i];
      }
      dst[c] = clip_pixel(divide_round(this_pred, log2_scale));
    }
    dst += stride;
  }
}

static INLINE void smooth_h_predictor(uint8_t *dst, ptrdiff_t stride, int bs,
                                      const uint8_t *above,
                                      const uint8_t *left) {
  const uint8_t right_pred = above[bs - 1];  // estimated by top-right pixel
  const uint8_t *const sm_weights = sm_weight_arrays + bs;
  // scale = 2^sm_weight_log2_scale
  const int log2_scale = sm_weight_log2_scale;
  const uint16_t scale = (1 << sm_weight_log2_scale);
  sm_weights_sanity_checks(sm_weights, scale, log2_scale + sizeof(*dst));

  int r;
  for (r = 0; r < bs; r++) {
    int c;
    for (c = 0; c < bs; ++c) {
      const uint8_t pixels[] = { left[r], right_pred };
      const uint8_t weights[] = { sm_weights[c], scale - sm_weights[c] };
      uint32_t this_pred = 0;
      assert(scale >= sm_weights[c]);
      int i;
      for (i = 0; i < 2; ++i) {
        this_pred += weights[i] * pixels[i];
      }
      dst[c] = clip_pixel(divide_round(this_pred, log2_scale));
    }
    dst += stride;
  }
}
#endif  // CONFIG_SMOOTH_HV

#else

static INLINE void tm_predictor(uint8_t *dst, ptrdiff_t stride, int bs,
                                const uint8_t *above, const uint8_t *left) {
  int r, c;
  int ytop_left = above[-1];

  for (r = 0; r < bs; r++) {
    for (c = 0; c < bs; c++)
      dst[c] = clip_pixel(left[r] + above[c] - ytop_left);
    dst += stride;
  }
}
#endif  // CONFIG_ALT_INTRA

static INLINE void dc_128_predictor(uint8_t *dst, ptrdiff_t stride, int bs,
                                    const uint8_t *above, const uint8_t *left) {
  int r;
  (void)above;
  (void)left;

  for (r = 0; r < bs; r++) {
    memset(dst, 128, bs);
    dst += stride;
  }
}

static INLINE void dc_left_predictor(uint8_t *dst, ptrdiff_t stride, int bs,
                                     const uint8_t *above,
                                     const uint8_t *left) {
  int i, r, expected_dc, sum = 0;
  (void)above;

  for (i = 0; i < bs; i++) sum += left[i];
  expected_dc = (sum + (bs >> 1)) / bs;

  for (r = 0; r < bs; r++) {
    memset(dst, expected_dc, bs);
    dst += stride;
  }
}

static INLINE void dc_top_predictor(uint8_t *dst, ptrdiff_t stride, int bs,
                                    const uint8_t *above, const uint8_t *left) {
  int i, r, expected_dc, sum = 0;
  (void)left;

  for (i = 0; i < bs; i++) sum += above[i];
  expected_dc = (sum + (bs >> 1)) / bs;

  for (r = 0; r < bs; r++) {
    memset(dst, expected_dc, bs);
    dst += stride;
  }
}

static INLINE void dc_predictor(uint8_t *dst, ptrdiff_t stride, int bs,
                                const uint8_t *above, const uint8_t *left) {
  int i, r, expected_dc, sum = 0;
  const int count = 2 * bs;

  for (i = 0; i < bs; i++) {
    sum += above[i];
    sum += left[i];
  }

  expected_dc = (sum + (count >> 1)) / count;

  for (r = 0; r < bs; r++) {
    memset(dst, expected_dc, bs);
    dst += stride;
  }
}

void aom_d45e_predictor_2x2_c(uint8_t *dst, ptrdiff_t stride,
                              const uint8_t *above, const uint8_t *left) {
  const int A = above[0];
  const int B = above[1];
  const int C = above[2];
  const int D = above[3];
  (void)stride;
  (void)left;

  DST(0, 0) = AVG3(A, B, C);
  DST(1, 0) = DST(0, 1) = AVG3(B, C, D);
  DST(1, 1) = AVG3(C, D, D);
}

void aom_d117_predictor_2x2_c(uint8_t *dst, ptrdiff_t stride,
                              const uint8_t *above, const uint8_t *left) {
  const int I = left[0];
  const int X = above[-1];
  const int A = above[0];
  const int B = above[1];
  DST(0, 0) = AVG2(X, A);
  DST(1, 0) = AVG2(A, B);
  DST(0, 1) = AVG3(I, X, A);
  DST(1, 1) = AVG3(X, A, B);
}

void aom_d135_predictor_2x2_c(uint8_t *dst, ptrdiff_t stride,
                              const uint8_t *above, const uint8_t *left) {
  const int I = left[0];
  const int J = left[1];
  const int X = above[-1];
  const int A = above[0];
  const int B = above[1];
  (void)stride;
  DST(0, 1) = AVG3(X, I, J);
  DST(1, 1) = DST(0, 0) = AVG3(A, X, I);
  DST(1, 0) = AVG3(B, A, X);
}

void aom_d153_predictor_2x2_c(uint8_t *dst, ptrdiff_t stride,
                              const uint8_t *above, const uint8_t *left) {
  const int I = left[0];
  const int J = left[1];
  const int X = above[-1];
  const int A = above[0];

  DST(0, 0) = AVG2(I, X);
  DST(0, 1) = AVG2(J, I);
  DST(1, 0) = AVG3(I, X, A);
  DST(1, 1) = AVG3(J, I, X);
}

void aom_d45e_predictor_4x4_c(uint8_t *dst, ptrdiff_t stride,
                              const uint8_t *above, const uint8_t *left) {
  const int A = above[0];
  const int B = above[1];
  const int C = above[2];
  const int D = above[3];
  const int E = above[4];
  const int F = above[5];
  const int G = above[6];
  const int H = above[7];
  (void)stride;
  (void)left;
  DST(0, 0) = AVG3(A, B, C);
  DST(1, 0) = DST(0, 1) = AVG3(B, C, D);
  DST(2, 0) = DST(1, 1) = DST(0, 2) = AVG3(C, D, E);
  DST(3, 0) = DST(2, 1) = DST(1, 2) = DST(0, 3) = AVG3(D, E, F);
  DST(3, 1) = DST(2, 2) = DST(1, 3) = AVG3(E, F, G);
  DST(3, 2) = DST(2, 3) = AVG3(F, G, H);
  DST(3, 3) = AVG3(G, H, H);
}

void aom_d117_predictor_4x4_c(uint8_t *dst, ptrdiff_t stride,
                              const uint8_t *above, const uint8_t *left) {
  const int I = left[0];
  const int J = left[1];
  const int K = left[2];
  const int X = above[-1];
  const int A = above[0];
  const int B = above[1];
  const int C = above[2];
  const int D = above[3];
  DST(0, 0) = DST(1, 2) = AVG2(X, A);
  DST(1, 0) = DST(2, 2) = AVG2(A, B);
  DST(2, 0) = DST(3, 2) = AVG2(B, C);
  DST(3, 0) = AVG2(C, D);

  DST(0, 3) = AVG3(K, J, I);
  DST(0, 2) = AVG3(J, I, X);
  DST(0, 1) = DST(1, 3) = AVG3(I, X, A);
  DST(1, 1) = DST(2, 3) = AVG3(X, A, B);
  DST(2, 1) = DST(3, 3) = AVG3(A, B, C);
  DST(3, 1) = AVG3(B, C, D);
}

void aom_d135_predictor_4x4_c(uint8_t *dst, ptrdiff_t stride,
                              const uint8_t *above, const uint8_t *left) {
  const int I = left[0];
  const int J = left[1];
  const int K = left[2];
  const int L = left[3];
  const int X = above[-1];
  const int A = above[0];
  const int B = above[1];
  const int C = above[2];
  const int D = above[3];
  (void)stride;
  DST(0, 3) = AVG3(J, K, L);
  DST(1, 3) = DST(0, 2) = AVG3(I, J, K);
  DST(2, 3) = DST(1, 2) = DST(0, 1) = AVG3(X, I, J);
  DST(3, 3) = DST(2, 2) = DST(1, 1) = DST(0, 0) = AVG3(A, X, I);
  DST(3, 2) = DST(2, 1) = DST(1, 0) = AVG3(B, A, X);
  DST(3, 1) = DST(2, 0) = AVG3(C, B, A);
  DST(3, 0) = AVG3(D, C, B);
}

void aom_d153_predictor_4x4_c(uint8_t *dst, ptrdiff_t stride,
                              const uint8_t *above, const uint8_t *left) {
  const int I = left[0];
  const int J = left[1];
  const int K = left[2];
  const int L = left[3];
  const int X = above[-1];
  const int A = above[0];
  const int B = above[1];
  const int C = above[2];

  DST(0, 0) = DST(2, 1) = AVG2(I, X);
  DST(0, 1) = DST(2, 2) = AVG2(J, I);
  DST(0, 2) = DST(2, 3) = AVG2(K, J);
  DST(0, 3) = AVG2(L, K);

  DST(3, 0) = AVG3(A, B, C);
  DST(2, 0) = AVG3(X, A, B);
  DST(1, 0) = DST(3, 1) = AVG3(I, X, A);
  DST(1, 1) = DST(3, 2) = AVG3(J, I, X);
  DST(1, 2) = DST(3, 3) = AVG3(K, J, I);
  DST(1, 3) = AVG3(L, K, J);
}

#if CONFIG_HIGHBITDEPTH
static INLINE void highbd_d207e_predictor(uint16_t *dst, ptrdiff_t stride,
                                          int bs, const uint16_t *above,
                                          const uint16_t *left, int bd) {
  int r, c;
  (void)above;
  (void)bd;

  for (r = 0; r < bs; ++r) {
    for (c = 0; c < bs; ++c) {
      dst[c] = c & 1 ? AVG3(left[(c >> 1) + r], left[(c >> 1) + r + 1],
                            left[(c >> 1) + r + 2])
                     : AVG2(left[(c >> 1) + r], left[(c >> 1) + r + 1]);
    }
    dst += stride;
  }
}

static INLINE void highbd_d63e_predictor(uint16_t *dst, ptrdiff_t stride,
                                         int bs, const uint16_t *above,
                                         const uint16_t *left, int bd) {
  int r, c;
  (void)left;
  (void)bd;
  for (r = 0; r < bs; ++r) {
    for (c = 0; c < bs; ++c) {
      dst[c] = r & 1 ? AVG3(above[(r >> 1) + c], above[(r >> 1) + c + 1],
                            above[(r >> 1) + c + 2])
                     : AVG2(above[(r >> 1) + c], above[(r >> 1) + c + 1]);
    }
    dst += stride;
  }
}

static INLINE void highbd_d45e_predictor(uint16_t *dst, ptrdiff_t stride,
                                         int bs, const uint16_t *above,
                                         const uint16_t *left, int bd) {
  int r, c;
  (void)left;
  (void)bd;
  for (r = 0; r < bs; ++r) {
    for (c = 0; c < bs; ++c) {
      dst[c] = AVG3(above[r + c], above[r + c + 1],
                    above[r + c + 1 + (r + c + 2 < bs * 2)]);
    }
    dst += stride;
  }
}

static INLINE void highbd_d117_predictor(uint16_t *dst, ptrdiff_t stride,
                                         int bs, const uint16_t *above,
                                         const uint16_t *left, int bd) {
  int r, c;
  (void)bd;

  // first row
  for (c = 0; c < bs; c++) dst[c] = AVG2(above[c - 1], above[c]);
  dst += stride;

  // second row
  dst[0] = AVG3(left[0], above[-1], above[0]);
  for (c = 1; c < bs; c++) dst[c] = AVG3(above[c - 2], above[c - 1], above[c]);
  dst += stride;

  // the rest of first col
  dst[0] = AVG3(above[-1], left[0], left[1]);
  for (r = 3; r < bs; ++r)
    dst[(r - 2) * stride] = AVG3(left[r - 3], left[r - 2], left[r - 1]);

  // the rest of the block
  for (r = 2; r < bs; ++r) {
    for (c = 1; c < bs; c++) dst[c] = dst[-2 * stride + c - 1];
    dst += stride;
  }
}

static INLINE void highbd_d135_predictor(uint16_t *dst, ptrdiff_t stride,
                                         int bs, const uint16_t *above,
                                         const uint16_t *left, int bd) {
  int r, c;
  (void)bd;
  dst[0] = AVG3(left[0], above[-1], above[0]);
  for (c = 1; c < bs; c++) dst[c] = AVG3(above[c - 2], above[c - 1], above[c]);

  dst[stride] = AVG3(above[-1], left[0], left[1]);
  for (r = 2; r < bs; ++r)
    dst[r * stride] = AVG3(left[r - 2], left[r - 1], left[r]);

  dst += stride;
  for (r = 1; r < bs; ++r) {
    for (c = 1; c < bs; c++) dst[c] = dst[-stride + c - 1];
    dst += stride;
  }
}

static INLINE void highbd_d153_predictor(uint16_t *dst, ptrdiff_t stride,
                                         int bs, const uint16_t *above,
                                         const uint16_t *left, int bd) {
  int r, c;
  (void)bd;
  dst[0] = AVG2(above[-1], left[0]);
  for (r = 1; r < bs; r++) dst[r * stride] = AVG2(left[r - 1], left[r]);
  dst++;

  dst[0] = AVG3(left[0], above[-1], above[0]);
  dst[stride] = AVG3(above[-1], left[0], left[1]);
  for (r = 2; r < bs; r++)
    dst[r * stride] = AVG3(left[r - 2], left[r - 1], left[r]);
  dst++;

  for (c = 0; c < bs - 2; c++)
    dst[c] = AVG3(above[c - 1], above[c], above[c + 1]);
  dst += stride;

  for (r = 1; r < bs; ++r) {
    for (c = 0; c < bs - 2; c++) dst[c] = dst[-stride + c - 2];
    dst += stride;
  }
}

static INLINE void highbd_v_predictor(uint16_t *dst, ptrdiff_t stride, int bs,
                                      const uint16_t *above,
                                      const uint16_t *left, int bd) {
  int r;
  (void)left;
  (void)bd;
  for (r = 0; r < bs; r++) {
    memcpy(dst, above, bs * sizeof(uint16_t));
    dst += stride;
  }
}

static INLINE void highbd_h_predictor(uint16_t *dst, ptrdiff_t stride, int bs,
                                      const uint16_t *above,
                                      const uint16_t *left, int bd) {
  int r;
  (void)above;
  (void)bd;
  for (r = 0; r < bs; r++) {
    aom_memset16(dst, left[r], bs);
    dst += stride;
  }
}

void aom_highbd_d207_predictor_2x2_c(uint16_t *dst, ptrdiff_t stride,
                                     const uint16_t *above,
                                     const uint16_t *left, int bd) {
  const int I = left[0];
  const int J = left[1];
  const int K = left[2];
  const int L = left[3];
  (void)above;
  (void)bd;
  DST(0, 0) = AVG2(I, J);
  DST(0, 1) = AVG2(J, K);
  DST(1, 0) = AVG3(I, J, K);
  DST(1, 1) = AVG3(J, K, L);
}

void aom_highbd_d63_predictor_2x2_c(uint16_t *dst, ptrdiff_t stride,
                                    const uint16_t *above, const uint16_t *left,
                                    int bd) {
  const int A = above[0];
  const int B = above[1];
  const int C = above[2];
  const int D = above[3];
  (void)left;
  (void)bd;
  DST(0, 0) = AVG2(A, B);
  DST(1, 0) = AVG2(B, C);
  DST(0, 1) = AVG3(A, B, C);
  DST(1, 1) = AVG3(B, C, D);
}

void aom_highbd_d45e_predictor_2x2_c(uint16_t *dst, ptrdiff_t stride,
                                     const uint16_t *above,
                                     const uint16_t *left, int bd) {
  const int A = above[0];
  const int B = above[1];
  const int C = above[2];
  const int D = above[3];
  (void)stride;
  (void)left;
  (void)bd;
  DST(0, 0) = AVG3(A, B, C);
  DST(1, 0) = DST(0, 1) = AVG3(B, C, D);
  DST(1, 1) = AVG3(C, D, D);
}

void aom_highbd_d117_predictor_2x2_c(uint16_t *dst, ptrdiff_t stride,
                                     const uint16_t *above,
                                     const uint16_t *left, int bd) {
  const int I = left[0];
  const int X = above[-1];
  const int A = above[0];
  const int B = above[1];
  (void)bd;
  DST(0, 0) = AVG2(X, A);
  DST(1, 0) = AVG2(A, B);
  DST(0, 1) = AVG3(I, X, A);
  DST(1, 1) = AVG3(X, A, B);
}

void aom_highbd_d135_predictor_2x2_c(uint16_t *dst, ptrdiff_t stride,
                                     const uint16_t *above,
                                     const uint16_t *left, int bd) {
  const int I = left[0];
  const int J = left[1];
  const int X = above[-1];
  const int A = above[0];
  const int B = above[1];
  (void)bd;
  DST(0, 1) = AVG3(X, I, J);
  DST(1, 1) = DST(0, 0) = AVG3(A, X, I);
  DST(1, 0) = AVG3(B, A, X);
}

void aom_highbd_d153_predictor_2x2_c(uint16_t *dst, ptrdiff_t stride,
                                     const uint16_t *above,
                                     const uint16_t *left, int bd) {
  const int I = left[0];
  const int J = left[1];
  const int X = above[-1];
  const int A = above[0];
  (void)bd;
  DST(0, 0) = AVG2(I, X);
  DST(0, 1) = AVG2(J, I);
  DST(1, 0) = AVG3(I, X, A);
  DST(1, 1) = AVG3(J, I, X);
}

#if CONFIG_ALT_INTRA
static INLINE void highbd_paeth_predictor(uint16_t *dst, ptrdiff_t stride,
                                          int bs, const uint16_t *above,
                                          const uint16_t *left, int bd) {
  int r, c;
  const uint16_t ytop_left = above[-1];
  (void)bd;

  for (r = 0; r < bs; r++) {
    for (c = 0; c < bs; c++)
      dst[c] = paeth_predictor_single(left[r], above[c], ytop_left);
    dst += stride;
  }
}

static INLINE void highbd_smooth_predictor(uint16_t *dst, ptrdiff_t stride,
                                           int bs, const uint16_t *above,
                                           const uint16_t *left, int bd) {
  const uint16_t below_pred = left[bs - 1];   // estimated by bottom-left pixel
  const uint16_t right_pred = above[bs - 1];  // estimated by top-right pixel
  const uint8_t *const sm_weights = sm_weight_arrays + bs;
  // scale = 2 * 2^sm_weight_log2_scale
  const int log2_scale = 1 + sm_weight_log2_scale;
  const uint16_t scale = (1 << sm_weight_log2_scale);
  sm_weights_sanity_checks(sm_weights, scale, log2_scale + sizeof(*dst));
  int r;
  for (r = 0; r < bs; ++r) {
    int c;
    for (c = 0; c < bs; ++c) {
      const uint16_t pixels[] = { above[c], below_pred, left[r], right_pred };
      const uint8_t weights[] = { sm_weights[r], scale - sm_weights[r],
                                  sm_weights[c], scale - sm_weights[c] };
      uint32_t this_pred = 0;
      int i;
      assert(scale >= sm_weights[r] && scale >= sm_weights[c]);
      for (i = 0; i < 4; ++i) {
        this_pred += weights[i] * pixels[i];
      }
      dst[c] = clip_pixel_highbd(divide_round(this_pred, log2_scale), bd);
    }
    dst += stride;
  }
}

#if CONFIG_SMOOTH_HV
static INLINE void highbd_smooth_v_predictor(uint16_t *dst, ptrdiff_t stride,
                                             int bs, const uint16_t *above,
                                             const uint16_t *left, int bd) {
  const uint16_t below_pred = left[bs - 1];  // estimated by bottom-left pixel
  const uint8_t *const sm_weights = sm_weight_arrays + bs;
  // scale = 2^sm_weight_log2_scale
  const int log2_scale = sm_weight_log2_scale;
  const uint16_t scale = (1 << sm_weight_log2_scale);
  sm_weights_sanity_checks(sm_weights, scale, log2_scale + sizeof(*dst));

  int r;
  for (r = 0; r < bs; r++) {
    int c;
    for (c = 0; c < bs; ++c) {
      const uint16_t pixels[] = { above[c], below_pred };
      const uint8_t weights[] = { sm_weights[r], scale - sm_weights[r] };
      uint32_t this_pred = 0;
      assert(scale >= sm_weights[r]);
      int i;
      for (i = 0; i < 2; ++i) {
        this_pred += weights[i] * pixels[i];
      }
      dst[c] = clip_pixel_highbd(divide_round(this_pred, log2_scale), bd);
    }
    dst += stride;
  }
}

static INLINE void highbd_smooth_h_predictor(uint16_t *dst, ptrdiff_t stride,
                                             int bs, const uint16_t *above,
                                             const uint16_t *left, int bd) {
  const uint16_t right_pred = above[bs - 1];  // estimated by top-right pixel
  const uint8_t *const sm_weights = sm_weight_arrays + bs;
  // scale = 2^sm_weight_log2_scale
  const int log2_scale = sm_weight_log2_scale;
  const uint16_t scale = (1 << sm_weight_log2_scale);
  sm_weights_sanity_checks(sm_weights, scale, log2_scale + sizeof(*dst));

  int r;
  for (r = 0; r < bs; r++) {
    int c;
    for (c = 0; c < bs; ++c) {
      const uint16_t pixels[] = { left[r], right_pred };
      const uint8_t weights[] = { sm_weights[c], scale - sm_weights[c] };
      uint32_t this_pred = 0;
      assert(scale >= sm_weights[c]);
      int i;
      for (i = 0; i < 2; ++i) {
        this_pred += weights[i] * pixels[i];
      }
      dst[c] = clip_pixel_highbd(divide_round(this_pred, log2_scale), bd);
    }
    dst += stride;
  }
}
#endif

#else
static INLINE void highbd_tm_predictor(uint16_t *dst, ptrdiff_t stride, int bs,
                                       const uint16_t *above,
                                       const uint16_t *left, int bd) {
  int r, c;
  int ytop_left = above[-1];
  (void)bd;

  for (r = 0; r < bs; r++) {
    for (c = 0; c < bs; c++)
      dst[c] = clip_pixel_highbd(left[r] + above[c] - ytop_left, bd);
    dst += stride;
  }
}
#endif  // CONFIG_ALT_INTRA

static INLINE void highbd_dc_128_predictor(uint16_t *dst, ptrdiff_t stride,
                                           int bs, const uint16_t *above,
                                           const uint16_t *left, int bd) {
  int r;
  (void)above;
  (void)left;

  for (r = 0; r < bs; r++) {
    aom_memset16(dst, 128 << (bd - 8), bs);
    dst += stride;
  }
}

static INLINE void highbd_dc_left_predictor(uint16_t *dst, ptrdiff_t stride,
                                            int bs, const uint16_t *above,
                                            const uint16_t *left, int bd) {
  int i, r, expected_dc, sum = 0;
  (void)above;
  (void)bd;

  for (i = 0; i < bs; i++) sum += left[i];
  expected_dc = (sum + (bs >> 1)) / bs;

  for (r = 0; r < bs; r++) {
    aom_memset16(dst, expected_dc, bs);
    dst += stride;
  }
}

static INLINE void highbd_dc_top_predictor(uint16_t *dst, ptrdiff_t stride,
                                           int bs, const uint16_t *above,
                                           const uint16_t *left, int bd) {
  int i, r, expected_dc, sum = 0;
  (void)left;
  (void)bd;

  for (i = 0; i < bs; i++) sum += above[i];
  expected_dc = (sum + (bs >> 1)) / bs;

  for (r = 0; r < bs; r++) {
    aom_memset16(dst, expected_dc, bs);
    dst += stride;
  }
}

static INLINE void highbd_dc_predictor(uint16_t *dst, ptrdiff_t stride, int bs,
                                       const uint16_t *above,
                                       const uint16_t *left, int bd) {
  int i, r, expected_dc, sum = 0;
  const int count = 2 * bs;
  (void)bd;

  for (i = 0; i < bs; i++) {
    sum += above[i];
    sum += left[i];
  }

  expected_dc = (sum + (count >> 1)) / count;

  for (r = 0; r < bs; r++) {
    aom_memset16(dst, expected_dc, bs);
    dst += stride;
  }
}
#endif  // CONFIG_HIGHBITDEPTH

// This serves as a wrapper function, so that all the prediction functions
// can be unified and accessed as a pointer array. Note that the boundary
// above and left are not necessarily used all the time.
#define intra_pred_sized(type, size)                        \
  void aom_##type##_predictor_##size##x##size##_c(          \
      uint8_t *dst, ptrdiff_t stride, const uint8_t *above, \
      const uint8_t *left) {                                \
    type##_predictor(dst, stride, size, above, left);       \
  }

#if CONFIG_HIGHBITDEPTH
#define intra_pred_highbd_sized(type, size)                        \
  void aom_highbd_##type##_predictor_##size##x##size##_c(          \
      uint16_t *dst, ptrdiff_t stride, const uint16_t *above,      \
      const uint16_t *left, int bd) {                              \
    highbd_##type##_predictor(dst, stride, size, above, left, bd); \
  }

/* clang-format off */
#if CONFIG_TX64X64
#define intra_pred_allsizes(type) \
  intra_pred_sized(type, 2) \
  intra_pred_sized(type, 4) \
  intra_pred_sized(type, 8) \
  intra_pred_sized(type, 16) \
  intra_pred_sized(type, 32) \
  intra_pred_sized(type, 64) \
  intra_pred_highbd_sized(type, 2) \
  intra_pred_highbd_sized(type, 4) \
  intra_pred_highbd_sized(type, 8) \
  intra_pred_highbd_sized(type, 16) \
  intra_pred_highbd_sized(type, 32) \
  intra_pred_highbd_sized(type, 64)

#define intra_pred_above_4x4(type) \
  intra_pred_sized(type, 8) \
  intra_pred_sized(type, 16) \
  intra_pred_sized(type, 32) \
  intra_pred_sized(type, 64) \
  intra_pred_highbd_sized(type, 4) \
  intra_pred_highbd_sized(type, 8) \
  intra_pred_highbd_sized(type, 16) \
  intra_pred_highbd_sized(type, 32) \
  intra_pred_highbd_sized(type, 64)
#else  // CONFIG_TX64X64
#define intra_pred_allsizes(type) \
  intra_pred_sized(type, 2) \
  intra_pred_sized(type, 4) \
  intra_pred_sized(type, 8) \
  intra_pred_sized(type, 16) \
  intra_pred_sized(type, 32) \
  intra_pred_highbd_sized(type, 2) \
  intra_pred_highbd_sized(type, 4) \
  intra_pred_highbd_sized(type, 8) \
  intra_pred_highbd_sized(type, 16) \
  intra_pred_highbd_sized(type, 32)

#define intra_pred_above_4x4(type) \
  intra_pred_sized(type, 8) \
  intra_pred_sized(type, 16) \
  intra_pred_sized(type, 32) \
  intra_pred_highbd_sized(type, 4) \
  intra_pred_highbd_sized(type, 8) \
  intra_pred_highbd_sized(type, 16) \
  intra_pred_highbd_sized(type, 32)
#endif  // CONFIG_TX64X64

#else

#if CONFIG_TX64X64
#define intra_pred_allsizes(type) \
  intra_pred_sized(type, 2) \
  intra_pred_sized(type, 4) \
  intra_pred_sized(type, 8) \
  intra_pred_sized(type, 16) \
  intra_pred_sized(type, 32) \
  intra_pred_sized(type, 64)

#define intra_pred_above_4x4(type) \
  intra_pred_sized(type, 8) \
  intra_pred_sized(type, 16) \
  intra_pred_sized(type, 32) \
  intra_pred_sized(type, 64)
#else  // CONFIG_TX64X64
#define intra_pred_allsizes(type) \
  intra_pred_sized(type, 2) \
  intra_pred_sized(type, 4) \
  intra_pred_sized(type, 8) \
  intra_pred_sized(type, 16) \
  intra_pred_sized(type, 32)

#define intra_pred_above_4x4(type) \
  intra_pred_sized(type, 8) \
  intra_pred_sized(type, 16) \
  intra_pred_sized(type, 32)
#endif  // CONFIG_TX64X64
#endif  // CONFIG_HIGHBITDEPTH

intra_pred_allsizes(d207e)
intra_pred_allsizes(d63e)
intra_pred_above_4x4(d45e)
intra_pred_above_4x4(d117)
intra_pred_above_4x4(d135)
intra_pred_above_4x4(d153)
intra_pred_allsizes(v)
intra_pred_allsizes(h)
#if CONFIG_ALT_INTRA
intra_pred_allsizes(smooth)
#if CONFIG_SMOOTH_HV
intra_pred_allsizes(smooth_v)
intra_pred_allsizes(smooth_h)
#endif  // CONFIG_SMOOTH_HV
intra_pred_allsizes(paeth)
#else
intra_pred_allsizes(tm)
#endif  // CONFIG_ALT_INTRA
intra_pred_allsizes(dc_128)
intra_pred_allsizes(dc_left)
intra_pred_allsizes(dc_top)
intra_pred_allsizes(dc)
/* clang-format on */
#undef intra_pred_allsizes
