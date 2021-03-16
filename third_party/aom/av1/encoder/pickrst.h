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
#ifndef AOM_AV1_ENCODER_PICKRST_H_
#define AOM_AV1_ENCODER_PICKRST_H_

#ifdef __cplusplus
extern "C" {
#endif

#include "av1/encoder/encoder.h"
#include "aom_ports/system_state.h"

struct yv12_buffer_config;
struct AV1_COMP;

static const uint8_t g_shuffle_stats_data[16] = {
  0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8,
};

static const uint8_t g_shuffle_stats_highbd_data[32] = {
  0, 1, 2, 3, 2, 3, 4, 5, 4, 5, 6, 7, 6, 7, 8, 9,
  0, 1, 2, 3, 2, 3, 4, 5, 4, 5, 6, 7, 6, 7, 8, 9,
};

static INLINE uint8_t find_average(const uint8_t *src, int h_start, int h_end,
                                   int v_start, int v_end, int stride) {
  uint64_t sum = 0;
  for (int i = v_start; i < v_end; i++) {
    for (int j = h_start; j < h_end; j++) {
      sum += src[i * stride + j];
    }
  }
  uint64_t avg = sum / ((v_end - v_start) * (h_end - h_start));
  return (uint8_t)avg;
}

#if CONFIG_AV1_HIGHBITDEPTH
static INLINE uint16_t find_average_highbd(const uint16_t *src, int h_start,
                                           int h_end, int v_start, int v_end,
                                           int stride) {
  uint64_t sum = 0;
  for (int i = v_start; i < v_end; i++) {
    for (int j = h_start; j < h_end; j++) {
      sum += src[i * stride + j];
    }
  }
  uint64_t avg = sum / ((v_end - v_start) * (h_end - h_start));
  return (uint16_t)avg;
}
#endif

void av1_pick_filter_restoration(const YV12_BUFFER_CONFIG *sd, AV1_COMP *cpi);

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // AOM_AV1_ENCODER_PICKRST_H_
