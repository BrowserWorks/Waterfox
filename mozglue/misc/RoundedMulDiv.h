/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_RoundedMulDiv_h
#define mozilla_RoundedMulDiv_h

#include "mozilla/Assertions.h"
#include "mozilla/CheckedArithmetic.h"
#include "mozilla/MathAlgorithms.h"

#include <stdint.h>

namespace mozilla {

// Returns aValue * aMultiplier / aDivisor rounded to the nearest integer,
// computed entirely in 64-bit integer arithmetic to avoid floating-point
// representation error. Saturates to INT64_MAX / INT64_MIN (by sign) if the
// rounded result would not fit int64_t.
inline int64_t RoundedMulDiv(int64_t aValue, uint64_t aMultiplier,
                             uint64_t aDivisor) {
  MOZ_ASSERT(aDivisor != 0, "Division by zero");
  const bool negative = aValue < 0;
  uint64_t magnitude = negative ? ~static_cast<uint64_t>(aValue) + 1u
                                : static_cast<uint64_t>(aValue);

  // Reduce the exact rational value first. This preserves the rounded result
  // and gives the arithmetic below the smallest products to work with.
  uint64_t g = GCD(magnitude, aDivisor);
  magnitude /= g;
  aDivisor /= g;

  g = GCD(aMultiplier, aDivisor);
  aMultiplier /= g;
  aDivisor /= g;

  // Let magnitude = q * aDivisor + r, with 0 <= r < aDivisor. Then, for
  // nonnegative inputs:
  //   round(magnitude * aMultiplier / aDivisor)
  //     = q * aMultiplier + (r * aMultiplier + aDivisor / 2) / aDivisor [1]
  //
  // [1] Since q is already an integer, rounding only affects the fractional
  // part:
  //   round(magnitude * aMultiplier / aDivisor)
  //     = q * aMultiplier + round(r * aMultiplier / aDivisor)
  //
  // For any integer N >= 0, round(N / D) equals ⌊(N + D/2) / D⌋:
  // writing N = k * D + s with 0 <= s < D gives
  // ⌊(N + D/2) / D⌋ = k + ⌊(s + D/2) / D⌋, and
  //   if 0 <= s < D/2, then 1/2 <= (s + D/2) / D < 1, so ⌊(s + D/2) / D⌋ = 0;
  //   if D/2 <= s < D, then 1 <= (s + D/2) / D < 3/2, so ⌊(s + D/2) / D⌋ = 1.
  // Applying this with N = r * aMultiplier and D = aDivisor:
  //   round(magnitude * aMultiplier / aDivisor)
  //     = q * aMultiplier + ⌊(r * aMultiplier + aDivisor / 2) / aDivisor⌋.
  const uint64_t q = magnitude / aDivisor;
  const uint64_t r = magnitude % aDivisor;

  // Limitation: r * aMultiplier is formed before the division by aDivisor, so
  // this intermediate can overflow uint64_t even when the final result fits
  // int64_t. Its contribution to the result,
  //   ⌊(r * aMultiplier + aDivisor / 2) / aDivisor⌋,
  // is at most aMultiplier, but the un-divided r * aMultiplier is up to
  // aMultiplier * (aDivisor - 1), since r <= aDivisor - 1. So a large
  // aMultiplier and aDivisor can overflow the product even while the result
  // stays small. On the other hand, q * aMultiplier cannot overflow this way,
  // because q = magnitude / aDivisor already carries the division,
  // q * aMultiplier is at most the final result, so it overflows only when that
  // result itself would exceed uint64_t.
  uint64_t whole;
  uint64_t fractional;
  if (!SafeMul(q, aMultiplier, &whole) ||
      !SafeMul(r, aMultiplier, &fractional) ||
      !SafeAdd(fractional, aDivisor / 2, &fractional)) {
    return negative ? INT64_MIN : INT64_MAX;
  }

  uint64_t quotient;
  if (!SafeAdd(whole, fractional / aDivisor, &quotient)) {
    return negative ? INT64_MIN : INT64_MAX;
  }

  if (quotient > static_cast<uint64_t>(INT64_MAX)) {
    return negative ? INT64_MIN : INT64_MAX;
  }
  return negative ? -static_cast<int64_t>(quotient)
                  : static_cast<int64_t>(quotient);
}

}  // namespace mozilla

#endif /* mozilla_RoundedMulDiv_h */
