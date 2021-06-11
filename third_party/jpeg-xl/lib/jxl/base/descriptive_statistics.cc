// Copyright (c) the JPEG XL Project Authors. All rights reserved.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include "lib/jxl/base/descriptive_statistics.h"

#include <stdio.h>

#include "lib/jxl/base/status.h"

namespace jxl {

void Stats::Assimilate(const Stats& other) {
  const int64_t total_n = n_ + other.n_;
  if (total_n == 0) return;  // Nothing to do; prevents div by zero.

  min_ = std::min(min_, other.min_);
  max_ = std::max(max_, other.max_);

  product_ *= other.product_;

  const double product_n = n_ * other.n_;
  const double n2 = n_ * n_;
  const double other_n2 = other.n_ * other.n_;
  // Warning: multiplying int64 can overflow here.
  const double total_n2 = static_cast<double>(total_n) * total_n;
  const double total_n3 = static_cast<double>(total_n2) * total_n;
  // Precompute reciprocal for speed - used at least twice.
  const double inv_total_n = 1.0 / total_n;
  const double inv_total_n2 = 1.0 / total_n2;

  const double delta = other.m1_ - m1_;
  const double delta2 = delta * delta;
  const double delta3 = delta * delta2;
  const double delta4 = delta2 * delta2;

  m1_ = (n_ * m1_ + other.n_ * other.m1_) * inv_total_n;

  const double new_m2 = m2_ + other.m2_ + delta2 * product_n * inv_total_n;

  const double new_m3 =
      m3_ + other.m3_ + delta3 * product_n * (n_ - other.n_) * inv_total_n2 +
      3.0 * delta * (n_ * other.m2_ - other.n_ * m2_) * inv_total_n;

  m4_ += other.m4_ +
         delta4 * product_n * (n2 - product_n + other_n2) / total_n3 +
         6.0 * delta2 * (n2 * other.m2_ + other_n2 * m2_) * inv_total_n2 +
         4.0 * delta * (n_ * other.m3_ - other.n_ * m3_) * inv_total_n;

  m2_ = new_m2;
  m3_ = new_m3;
  n_ = total_n;
}

std::string Stats::ToString(int exclude) const {
  if (Count() == 0) return std::string("(none)");

  char buf[300];
  size_t pos = 0;
  int ret;  // snprintf - bytes written or negative for error.

  if ((exclude & kNoCount) == 0) {
    ret = snprintf(buf + pos, sizeof(buf) - pos, "Count=%6zu ",
                   static_cast<size_t>(Count()));
    JXL_ASSERT(ret > 0);
    pos += ret;
  }

  if ((exclude & kNoMeanSD) == 0) {
    ret = snprintf(buf + pos, sizeof(buf) - pos, "Mean=%9.6f SD=%8.5f ", Mean(),
                   StandardDeviation());
    JXL_ASSERT(ret > 0);
    pos += ret;
  }

  if ((exclude & kNoMinMax) == 0) {
    ret = snprintf(buf + pos, sizeof(buf) - pos, "Min=%8.5f Max=%8.5f ", Min(),
                   Max());
    JXL_ASSERT(ret > 0);
    pos += ret;
  }

  if ((exclude & kNoSkewKurt) == 0) {
    ret = snprintf(buf + pos, sizeof(buf) - pos, "Skew=%5.2f Kurt=%7.2f ",
                   Skewness(), Kurtosis());
    JXL_ASSERT(ret > 0);
    pos += ret;
  }

  if ((exclude & kNoGeomean) == 0) {
    ret = snprintf(buf + pos, sizeof(buf) - pos, "GeoMean=%9.6f ",
                   GeometricMean());
    JXL_ASSERT(ret > 0);
    pos += ret;
  }

  JXL_ASSERT(pos < sizeof(buf));
  return buf;
}

}  // namespace jxl
