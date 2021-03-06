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
#include <libvmaf/libvmaf.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "aom_dsp/blend.h"
#include "aom_dsp/vmaf.h"
#include "aom_ports/system_state.h"

typedef struct FrameData {
  const YV12_BUFFER_CONFIG *source;
  const YV12_BUFFER_CONFIG *distorted;
  int frame_set;
  int bit_depth;
} FrameData;

static void vmaf_fatal_error(const char *message) {
  fprintf(stderr, "Fatal error: %s\n", message);
  exit(EXIT_FAILURE);
}

// A callback function used to pass data to VMAF.
// Returns 0 after reading a frame.
// Returns 2 when there is no more frame to read.
static int read_frame(float *ref_data, float *main_data, float *temp_data,
                      int stride, void *user_data) {
  FrameData *frames = (FrameData *)user_data;

  if (!frames->frame_set) {
    const int width = frames->source->y_width;
    const int height = frames->source->y_height;
    assert(width == frames->distorted->y_width);
    assert(height == frames->distorted->y_height);

    if (frames->bit_depth > 8) {
      const float scale_factor = 1.0f / (float)(1 << (frames->bit_depth - 8));
      uint16_t *ref_ptr = CONVERT_TO_SHORTPTR(frames->source->y_buffer);
      uint16_t *main_ptr = CONVERT_TO_SHORTPTR(frames->distorted->y_buffer);

      for (int row = 0; row < height; ++row) {
        for (int col = 0; col < width; ++col) {
          ref_data[col] = scale_factor * (float)ref_ptr[col];
        }
        ref_ptr += frames->source->y_stride;
        ref_data += stride / sizeof(*ref_data);
      }

      for (int row = 0; row < height; ++row) {
        for (int col = 0; col < width; ++col) {
          main_data[col] = scale_factor * (float)main_ptr[col];
        }
        main_ptr += frames->distorted->y_stride;
        main_data += stride / sizeof(*main_data);
      }
    } else {
      uint8_t *ref_ptr = frames->source->y_buffer;
      uint8_t *main_ptr = frames->distorted->y_buffer;

      for (int row = 0; row < height; ++row) {
        for (int col = 0; col < width; ++col) {
          ref_data[col] = (float)ref_ptr[col];
        }
        ref_ptr += frames->source->y_stride;
        ref_data += stride / sizeof(*ref_data);
      }

      for (int row = 0; row < height; ++row) {
        for (int col = 0; col < width; ++col) {
          main_data[col] = (float)main_ptr[col];
        }
        main_ptr += frames->distorted->y_stride;
        main_data += stride / sizeof(*main_data);
      }
    }
    frames->frame_set = 1;
    return 0;
  }

  (void)temp_data;
  return 2;
}

void aom_calc_vmaf(const char *model_path, const YV12_BUFFER_CONFIG *source,
                   const YV12_BUFFER_CONFIG *distorted, const int bit_depth,
                   double *const vmaf) {
  aom_clear_system_state();
  const int width = source->y_width;
  const int height = source->y_height;
  FrameData frames = { source, distorted, 0, bit_depth };
  char *fmt = bit_depth == 10 ? "yuv420p10le" : "yuv420p";
  double vmaf_score;
  const int ret =
      compute_vmaf(&vmaf_score, fmt, width, height, read_frame,
                   /*user_data=*/&frames, (char *)model_path,
                   /*log_path=*/NULL, /*log_fmt=*/NULL, /*disable_clip=*/1,
                   /*disable_avx=*/0, /*enable_transform=*/0,
                   /*phone_model=*/0, /*do_psnr=*/0, /*do_ssim=*/0,
                   /*do_ms_ssim=*/0, /*pool_method=*/NULL, /*n_thread=*/0,
                   /*n_subsample=*/1, /*enable_conf_interval=*/0);
  if (ret) vmaf_fatal_error("Failed to compute VMAF scores.");

  aom_clear_system_state();
  *vmaf = vmaf_score;
}

void aom_calc_vmaf_multi_frame(
    void *user_data, const char *model_path,
    int (*read_frame)(float *ref_data, float *main_data, float *temp_data,
                      int stride_byte, void *user_data),
    int frame_width, int frame_height, int bit_depth, double *vmaf) {
  aom_clear_system_state();

  char *fmt = bit_depth == 10 ? "yuv420p10le" : "yuv420p";
  double vmaf_score;
  const int ret = compute_vmaf(
      &vmaf_score, fmt, frame_width, frame_height, read_frame,
      /*user_data=*/user_data, (char *)model_path,
      /*log_path=*/"vmaf_scores.xml", /*log_fmt=*/NULL, /*disable_clip=*/0,
      /*disable_avx=*/0, /*enable_transform=*/0,
      /*phone_model=*/0, /*do_psnr=*/0, /*do_ssim=*/0,
      /*do_ms_ssim=*/0, /*pool_method=*/NULL, /*n_thread=*/0,
      /*n_subsample=*/1, /*enable_conf_interval=*/0);
  FILE *vmaf_log = fopen("vmaf_scores.xml", "r");
  if (vmaf_log == NULL || ret) {
    vmaf_fatal_error("Failed to compute VMAF scores.");
  }

  int frame_index = 0;
  char buf[512];
  while (fgets(buf, 511, vmaf_log) != NULL) {
    if (memcmp(buf, "\t\t<frame ", 9) == 0) {
      char *p = strstr(buf, "vmaf=");
      if (p != NULL && p[5] == '"') {
        char *p2 = strstr(&p[6], "\"");
        *p2 = '\0';
        const double score = atof(&p[6]);
        if (score < 0.0 || score > 100.0) {
          vmaf_fatal_error("Failed to compute VMAF scores.");
        }
        vmaf[frame_index++] = score;
      }
    }
  }
  fclose(vmaf_log);

  aom_clear_system_state();
}
