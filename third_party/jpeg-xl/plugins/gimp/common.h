// Copyright (c) the JPEG XL Project Authors. All rights reserved.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#ifndef PLUGINS_GIMP_COMMON_H_
#define PLUGINS_GIMP_COMMON_H_

#include <libgimp/gimp.h>

namespace jxl {

// FromFloat expects a value between 0 and 1, and ToFloat returns such values
// from GIMP values.
template <GimpPrecision>
struct BufferFormat;
template <>
struct BufferFormat<GIMP_PRECISION_U8_GAMMA> {
  using Sample = uint8_t;
  static Sample FromFloat(const float x) {
    return static_cast<Sample>(std::round(x * 255.f));
  }
  static float ToFloat(const Sample s) { return s; }
};
template <>
struct BufferFormat<GIMP_PRECISION_U16_GAMMA> {
  using Sample = uint16_t;
  static Sample FromFloat(const float x) {
    return static_cast<Sample>(std::round(x * 65535.f));
  }
  static float ToFloat(const Sample s) { return s * (1.f / 65535.f); }
};
template <>
struct BufferFormat<GIMP_PRECISION_U32_GAMMA> {
  using Sample = uint32_t;
  static Sample FromFloat(const float x) {
    return static_cast<Sample>(std::round(x * 4294967295.f));
  }
  static float ToFloat(const Sample s) { return s * (1.f / 4294967295.f); }
};
template <>
struct BufferFormat<GIMP_PRECISION_HALF_GAMMA> {
  using Sample = float;
  static Sample FromFloat(const float x) { return x; }
  static float ToFloat(const Sample s) { return s; }
};
template <>
struct BufferFormat<GIMP_PRECISION_FLOAT_GAMMA> {
  using Sample = float;
  static Sample FromFloat(const float x) { return x; }
  static float ToFloat(const Sample s) { return s; }
};

}  // namespace jxl

#endif  // PLUGINS_GIMP_COMMON_H_
