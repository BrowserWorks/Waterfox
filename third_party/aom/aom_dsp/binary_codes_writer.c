/*
 * Copyright (c) 2017, Alliance for Open Media. All rights reserved
 *
 * This source code is subject to the terms of the BSD 2 Clause License and
 * the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
 * was not distributed with this source code in the LICENSE file, you can
 * obtain it at www.aomedia.org/license/software. If the Alliance for Open
 * Media Patent License 1.0 was not distributed with this source code in the
 * PATENTS file, you can obtain it at www.aomedia.org/license/patent.
 */

#include "aom_dsp/bitwriter.h"

#include "av1/common/common.h"

// Recenters a non-negative literal v around a reference r
static uint16_t recenter_nonneg(uint16_t r, uint16_t v) {
  if (v > (r << 1))
    return v;
  else if (v >= r)
    return ((v - r) << 1);
  else
    return ((r - v) << 1) - 1;
}

// Recenters a non-negative literal v in [0, n-1] around a
// reference r also in [0, n-1]
static uint16_t recenter_finite_nonneg(uint16_t n, uint16_t r, uint16_t v) {
  if ((r << 1) <= n) {
    return recenter_nonneg(r, v);
  } else {
    return recenter_nonneg(n - 1 - r, n - 1 - v);
  }
}

// Codes a symbol v in [-2^mag_bits, 2^mag_bits].
// mag_bits is number of bits for magnitude. The alphabet is of size
// 2 * 2^mag_bits + 1, symmetric around 0, where one bit is used to
// indicate 0 or non-zero, mag_bits bits are used to indicate magnitide
// and 1 more bit for the sign if non-zero.
void aom_write_primitive_symmetric(aom_writer *w, int16_t v,
                                   unsigned int abs_bits) {
  if (v == 0) {
    aom_write_bit(w, 0);
  } else {
    const int x = abs(v);
    const int s = v < 0;
    aom_write_bit(w, 1);
    aom_write_bit(w, s);
    aom_write_literal(w, x - 1, abs_bits);
  }
}

int aom_count_primitive_symmetric(int16_t v, unsigned int abs_bits) {
  return (v == 0 ? 1 : abs_bits + 2);
}

// Encodes a value v in [0, n-1] quasi-uniformly
void aom_write_primitive_quniform(aom_writer *w, uint16_t n, uint16_t v) {
  if (n <= 1) return;
  const int l = get_msb(n - 1) + 1;
  const int m = (1 << l) - n;
  if (v < m) {
    aom_write_literal(w, v, l - 1);
  } else {
    aom_write_literal(w, m + ((v - m) >> 1), l - 1);
    aom_write_bit(w, (v - m) & 1);
  }
}

int aom_count_primitive_quniform(uint16_t n, uint16_t v) {
  if (n <= 1) return 0;
  const int l = get_msb(n - 1) + 1;
  const int m = (1 << l) - n;
  return v < m ? l - 1 : l;
}

// Encodes a value v in [0, n-1] based on a reference ref also in [0, n-1]
// The closest p values of v from ref are coded using a p-ary quasi-unoform
// short code while the remaining n-p values are coded with a longer code.
void aom_write_primitive_refbilevel(aom_writer *w, uint16_t n, uint16_t p,
                                    uint16_t ref, uint16_t v) {
  if (n <= 1) return;
  assert(p > 0 && p <= n);
  assert(ref < n);
  int lolimit = ref - p / 2;
  int hilimit = lolimit + p - 1;
  if (lolimit < 0) {
    lolimit = 0;
    hilimit = p - 1;
  } else if (hilimit >= n) {
    hilimit = n - 1;
    lolimit = n - p;
  }
  if (v >= lolimit && v <= hilimit) {
    aom_write_bit(w, 1);
    v = v - lolimit;
    aom_write_primitive_quniform(w, p, v);
  } else {
    aom_write_bit(w, 0);
    if (v > hilimit) v -= p;
    aom_write_primitive_quniform(w, n - p, v);
  }
}

int aom_count_primitive_refbilevel(uint16_t n, uint16_t p, uint16_t ref,
                                   uint16_t v) {
  if (n <= 1) return 0;
  assert(p > 0 && p <= n);
  assert(ref < n);
  int lolimit = ref - p / 2;
  int hilimit = lolimit + p - 1;
  if (lolimit < 0) {
    lolimit = 0;
    hilimit = p - 1;
  } else if (hilimit >= n) {
    hilimit = n - 1;
    lolimit = n - p;
  }
  int count = 0;
  if (v >= lolimit && v <= hilimit) {
    count++;
    v = v - lolimit;
    count += aom_count_primitive_quniform(p, v);
  } else {
    count++;
    if (v > hilimit) v -= p;
    count += aom_count_primitive_quniform(n - p, v);
  }
  return count;
}

// Finite subexponential code that codes a symbol v in [0, n-1] with parameter k
void aom_write_primitive_subexpfin(aom_writer *w, uint16_t n, uint16_t k,
                                   uint16_t v) {
  int i = 0;
  int mk = 0;
  while (1) {
    int b = (i ? k + i - 1 : k);
    int a = (1 << b);
    if (n <= mk + 3 * a) {
      aom_write_primitive_quniform(w, n - mk, v - mk);
      break;
    } else {
      int t = (v >= mk + a);
      aom_write_bit(w, t);
      if (t) {
        i = i + 1;
        mk += a;
      } else {
        aom_write_literal(w, v - mk, b);
        break;
      }
    }
  }
}

int aom_count_primitive_subexpfin(uint16_t n, uint16_t k, uint16_t v) {
  int count = 0;
  int i = 0;
  int mk = 0;
  while (1) {
    int b = (i ? k + i - 1 : k);
    int a = (1 << b);
    if (n <= mk + 3 * a) {
      count += aom_count_primitive_quniform(n - mk, v - mk);
      break;
    } else {
      int t = (v >= mk + a);
      count++;
      if (t) {
        i = i + 1;
        mk += a;
      } else {
        count += b;
        break;
      }
    }
  }
  return count;
}

// Finite subexponential code that codes a symbol v in [0, n-1] with parameter k
// based on a reference ref also in [0, n-1].
// Recenters symbol around r first and then uses a finite subexponential code.
void aom_write_primitive_refsubexpfin(aom_writer *w, uint16_t n, uint16_t k,
                                      int16_t ref, int16_t v) {
  aom_write_primitive_subexpfin(w, n, k, recenter_finite_nonneg(n, ref, v));
}

void aom_write_signed_primitive_refsubexpfin(aom_writer *w, uint16_t n,
                                             uint16_t k, uint16_t ref,
                                             uint16_t v) {
  ref += n - 1;
  v += n - 1;
  const uint16_t scaled_n = (n << 1) - 1;
  aom_write_primitive_refsubexpfin(w, scaled_n, k, ref, v);
}

int aom_count_primitive_refsubexpfin(uint16_t n, uint16_t k, uint16_t ref,
                                     uint16_t v) {
  return aom_count_primitive_subexpfin(n, k, recenter_finite_nonneg(n, ref, v));
}

int aom_count_signed_primitive_refsubexpfin(uint16_t n, uint16_t k, int16_t ref,
                                            int16_t v) {
  ref += n - 1;
  v += n - 1;
  const uint16_t scaled_n = (n << 1) - 1;
  return aom_count_primitive_refsubexpfin(scaled_n, k, ref, v);
}
