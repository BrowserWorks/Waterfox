/*
 *  Copyright (c) 2019, Alliance for Open Media. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "config/aom_dsp_rtcd.h"
#include "config/aom_config.h"

#include "aom/aom_integer.h"
#include "aom_ports/mem.h"

static INLINE int horizontal_add_s16x8(const int16x8_t v_16x8) {
  const int32x4_t a = vpaddlq_s16(v_16x8);
  const int64x2_t b = vpaddlq_s32(a);
  const int32x2_t c = vadd_s32(vreinterpret_s32_s64(vget_low_s64(b)),
                               vreinterpret_s32_s64(vget_high_s64(b)));
  return vget_lane_s32(c, 0);
}

static INLINE int horizontal_add_s32x4(const int32x4_t v_32x4) {
  const int64x2_t b = vpaddlq_s32(v_32x4);
  const int32x2_t c = vadd_s32(vreinterpret_s32_s64(vget_low_s64(b)),
                               vreinterpret_s32_s64(vget_high_s64(b)));
  return vget_lane_s32(c, 0);
}

static INLINE uint32x2_t horizontal_add_u16x8(const uint16x8_t a) {
  const uint32x4_t b = vpaddlq_u16(a);
  const uint64x2_t c = vpaddlq_u32(b);
  return vadd_u32(vreinterpret_u32_u64(vget_low_u64(c)),
                  vreinterpret_u32_u64(vget_high_u64(c)));
}
