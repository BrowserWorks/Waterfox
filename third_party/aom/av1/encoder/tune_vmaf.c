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

#include "av1/encoder/tune_vmaf.h"

#include "aom_dsp/psnr.h"
#include "aom_dsp/vmaf.h"
#include "aom_ports/system_state.h"
#include "av1/encoder/extend.h"
#include "av1/encoder/rdopt.h"

static const double kBaselineVmaf = 97.42773;

// TODO(sdeng): Add the SIMD implementation.
static AOM_INLINE void highbd_unsharp_rect(const uint16_t *source,
                                           int source_stride,
                                           const uint16_t *blurred,
                                           int blurred_stride, uint16_t *dst,
                                           int dst_stride, int w, int h,
                                           double amount, int bit_depth) {
  const int max_value = (1 << bit_depth) - 1;
  for (int i = 0; i < h; ++i) {
    for (int j = 0; j < w; ++j) {
      const double val =
          (double)source[j] + amount * ((double)source[j] - (double)blurred[j]);
      dst[j] = (uint16_t)clamp((int)(val + 0.5), 0, max_value);
    }
    source += source_stride;
    blurred += blurred_stride;
    dst += dst_stride;
  }
}

static AOM_INLINE void unsharp_rect(const uint8_t *source, int source_stride,
                                    const uint8_t *blurred, int blurred_stride,
                                    uint8_t *dst, int dst_stride, int w, int h,
                                    double amount) {
  for (int i = 0; i < h; ++i) {
    for (int j = 0; j < w; ++j) {
      const double val =
          (double)source[j] + amount * ((double)source[j] - (double)blurred[j]);
      dst[j] = (uint8_t)clamp((int)(val + 0.5), 0, 255);
    }
    source += source_stride;
    blurred += blurred_stride;
    dst += dst_stride;
  }
}

static AOM_INLINE void unsharp(const AV1_COMP *const cpi,
                               const YV12_BUFFER_CONFIG *source,
                               const YV12_BUFFER_CONFIG *blurred,
                               const YV12_BUFFER_CONFIG *dst, double amount) {
  const int bit_depth = cpi->td.mb.e_mbd.bd;
  if (bit_depth > 8) {
    highbd_unsharp_rect(CONVERT_TO_SHORTPTR(source->y_buffer), source->y_stride,
                        CONVERT_TO_SHORTPTR(blurred->y_buffer),
                        blurred->y_stride, CONVERT_TO_SHORTPTR(dst->y_buffer),
                        dst->y_stride, source->y_width, source->y_height,
                        amount, bit_depth);
  } else {
    unsharp_rect(source->y_buffer, source->y_stride, blurred->y_buffer,
                 blurred->y_stride, dst->y_buffer, dst->y_stride,
                 source->y_width, source->y_height, amount);
  }
}

// 8-tap Gaussian convolution filter with sigma = 1.0, sums to 128,
// all co-efficients must be even.
DECLARE_ALIGNED(16, static const int16_t, gauss_filter[8]) = { 0,  8, 30, 52,
                                                               30, 8, 0,  0 };
static AOM_INLINE void gaussian_blur(const int bit_depth,
                                     const YV12_BUFFER_CONFIG *source,
                                     const YV12_BUFFER_CONFIG *dst) {
  const int block_size = BLOCK_128X128;
  const int block_w = mi_size_wide[block_size] * 4;
  const int block_h = mi_size_high[block_size] * 4;
  const int num_cols = (source->y_width + block_w - 1) / block_w;
  const int num_rows = (source->y_height + block_h - 1) / block_h;
  int row, col;

  ConvolveParams conv_params = get_conv_params(0, 0, bit_depth);
  InterpFilterParams filter = { .filter_ptr = gauss_filter,
                                .taps = 8,
                                .subpel_shifts = 0,
                                .interp_filter = EIGHTTAP_REGULAR };

  for (row = 0; row < num_rows; ++row) {
    for (col = 0; col < num_cols; ++col) {
      const int row_offset_y = row * block_h;
      const int col_offset_y = col * block_w;

      uint8_t *src_buf =
          source->y_buffer + row_offset_y * source->y_stride + col_offset_y;
      uint8_t *dst_buf =
          dst->y_buffer + row_offset_y * dst->y_stride + col_offset_y;

      if (bit_depth > 8) {
        av1_highbd_convolve_2d_sr(
            CONVERT_TO_SHORTPTR(src_buf), source->y_stride,
            CONVERT_TO_SHORTPTR(dst_buf), dst->y_stride, block_w, block_h,
            &filter, &filter, 0, 0, &conv_params, bit_depth);
      } else {
        av1_convolve_2d_sr(src_buf, source->y_stride, dst_buf, dst->y_stride,
                           block_w, block_h, &filter, &filter, 0, 0,
                           &conv_params);
      }
    }
  }
}

static double frame_average_variance(const AV1_COMP *const cpi,
                                     const YV12_BUFFER_CONFIG *const frame) {
  const uint8_t *const y_buffer = frame->y_buffer;
  const int y_stride = frame->y_stride;
  const BLOCK_SIZE block_size = BLOCK_64X64;

  const int block_w = mi_size_wide[block_size] * 4;
  const int block_h = mi_size_high[block_size] * 4;
  int row, col;
  const int bit_depth = cpi->td.mb.e_mbd.bd;
  double var = 0.0, var_count = 0.0;

  // Loop through each block.
  for (row = 0; row < frame->y_height / block_h; ++row) {
    for (col = 0; col < frame->y_width / block_w; ++col) {
      struct buf_2d buf;
      const int row_offset_y = row * block_h;
      const int col_offset_y = col * block_w;

      buf.buf = (uint8_t *)y_buffer + row_offset_y * y_stride + col_offset_y;
      buf.stride = y_stride;

      if (bit_depth > 8) {
        var += av1_high_get_sby_perpixel_variance(cpi, &buf, block_size,
                                                  bit_depth);
      } else {
        var += av1_get_sby_perpixel_variance(cpi, &buf, block_size);
      }
      var_count += 1.0;
    }
  }
  var /= var_count;
  return var;
}

static double cal_approx_vmaf(const AV1_COMP *const cpi, double source_variance,
                              YV12_BUFFER_CONFIG *const source,
                              YV12_BUFFER_CONFIG *const sharpened) {
  const int bit_depth = cpi->td.mb.e_mbd.bd;
  double new_vmaf;
  aom_calc_vmaf(cpi->oxcf.vmaf_model_path, source, sharpened, bit_depth,
                &new_vmaf);
  const double sharpened_var = frame_average_variance(cpi, sharpened);
  return source_variance / sharpened_var * (new_vmaf - kBaselineVmaf);
}

static double find_best_frame_unsharp_amount_loop(
    const AV1_COMP *const cpi, YV12_BUFFER_CONFIG *const source,
    YV12_BUFFER_CONFIG *const blurred, YV12_BUFFER_CONFIG *const sharpened,
    double best_vmaf, const double baseline_variance,
    const double unsharp_amount_start, const double step_size,
    const int max_loop_count, const double max_amount) {
  const double min_amount = 0.0;
  int loop_count = 0;
  double approx_vmaf = best_vmaf;
  double unsharp_amount = unsharp_amount_start;
  do {
    best_vmaf = approx_vmaf;
    unsharp_amount += step_size;
    if (unsharp_amount > max_amount || unsharp_amount < min_amount) break;
    unsharp(cpi, source, blurred, sharpened, unsharp_amount);
    approx_vmaf = cal_approx_vmaf(cpi, baseline_variance, source, sharpened);

    loop_count++;
  } while (approx_vmaf > best_vmaf && loop_count < max_loop_count);
  unsharp_amount =
      approx_vmaf > best_vmaf ? unsharp_amount : unsharp_amount - step_size;
  return AOMMIN(max_amount, AOMMAX(unsharp_amount, min_amount));
}

static double find_best_frame_unsharp_amount(const AV1_COMP *const cpi,
                                             YV12_BUFFER_CONFIG *const source,
                                             YV12_BUFFER_CONFIG *const blurred,
                                             const double unsharp_amount_start,
                                             const double step_size,
                                             const int max_loop_count,
                                             const double max_filter_amount) {
  const AV1_COMMON *const cm = &cpi->common;
  const int width = source->y_width;
  const int height = source->y_height;

  YV12_BUFFER_CONFIG sharpened;
  memset(&sharpened, 0, sizeof(sharpened));
  aom_alloc_frame_buffer(
      &sharpened, width, height, 1, 1, cm->seq_params.use_highbitdepth,
      cpi->oxcf.border_in_pixels, cm->features.byte_alignment);

  const double baseline_variance = frame_average_variance(cpi, source);
  double unsharp_amount;
  if (unsharp_amount_start <= step_size) {
    unsharp_amount = find_best_frame_unsharp_amount_loop(
        cpi, source, blurred, &sharpened, 0.0, baseline_variance, 0.0,
        step_size, max_loop_count, max_filter_amount);
  } else {
    double a0 = unsharp_amount_start - step_size, a1 = unsharp_amount_start;
    double v0, v1;
    unsharp(cpi, source, blurred, &sharpened, a0);
    v0 = cal_approx_vmaf(cpi, baseline_variance, source, &sharpened);
    unsharp(cpi, source, blurred, &sharpened, a1);
    v1 = cal_approx_vmaf(cpi, baseline_variance, source, &sharpened);
    if (fabs(v0 - v1) < 0.01) {
      unsharp_amount = a0;
    } else if (v0 > v1) {
      unsharp_amount = find_best_frame_unsharp_amount_loop(
          cpi, source, blurred, &sharpened, v0, baseline_variance, a0,
          -step_size, max_loop_count, max_filter_amount);
    } else {
      unsharp_amount = find_best_frame_unsharp_amount_loop(
          cpi, source, blurred, &sharpened, v1, baseline_variance, a1,
          step_size, max_loop_count, max_filter_amount);
    }
  }

  aom_free_frame_buffer(&sharpened);
  return unsharp_amount;
}

void av1_vmaf_frame_preprocessing(AV1_COMP *const cpi,
                                  YV12_BUFFER_CONFIG *const source) {
  aom_clear_system_state();
  const AV1_COMMON *const cm = &cpi->common;
  const int bit_depth = cpi->td.mb.e_mbd.bd;
  const int width = source->y_width;
  const int height = source->y_height;

  YV12_BUFFER_CONFIG source_extended, blurred;
  memset(&source_extended, 0, sizeof(source_extended));
  memset(&blurred, 0, sizeof(blurred));
  aom_alloc_frame_buffer(
      &source_extended, width, height, 1, 1, cm->seq_params.use_highbitdepth,
      cpi->oxcf.border_in_pixels, cm->features.byte_alignment);
  aom_alloc_frame_buffer(
      &blurred, width, height, 1, 1, cm->seq_params.use_highbitdepth,
      cpi->oxcf.border_in_pixels, cm->features.byte_alignment);

  av1_copy_and_extend_frame(source, &source_extended);
  gaussian_blur(bit_depth, &source_extended, &blurred);
  aom_free_frame_buffer(&source_extended);

  const double best_frame_unsharp_amount = find_best_frame_unsharp_amount(
      cpi, source, &blurred, cpi->last_frame_unsharp_amount, 0.05, 20, 1.01);
  cpi->last_frame_unsharp_amount = best_frame_unsharp_amount;

  unsharp(cpi, source, &blurred, source, best_frame_unsharp_amount);
  aom_free_frame_buffer(&blurred);
  aom_clear_system_state();
}

void av1_vmaf_blk_preprocessing(AV1_COMP *const cpi,
                                YV12_BUFFER_CONFIG *const source) {
  aom_clear_system_state();
  const AV1_COMMON *const cm = &cpi->common;
  const int width = source->y_width;
  const int height = source->y_height;
  const int bit_depth = cpi->td.mb.e_mbd.bd;

  YV12_BUFFER_CONFIG source_extended, blurred;
  memset(&blurred, 0, sizeof(blurred));
  memset(&source_extended, 0, sizeof(source_extended));
  aom_alloc_frame_buffer(
      &blurred, width, height, 1, 1, cm->seq_params.use_highbitdepth,
      cpi->oxcf.border_in_pixels, cm->features.byte_alignment);
  aom_alloc_frame_buffer(
      &source_extended, width, height, 1, 1, cm->seq_params.use_highbitdepth,
      cpi->oxcf.border_in_pixels, cm->features.byte_alignment);

  av1_copy_and_extend_frame(source, &source_extended);
  gaussian_blur(bit_depth, &source_extended, &blurred);
  aom_free_frame_buffer(&source_extended);

  const double best_frame_unsharp_amount = find_best_frame_unsharp_amount(
      cpi, source, &blurred, cpi->last_frame_unsharp_amount, 0.05, 20, 1.01);
  cpi->last_frame_unsharp_amount = best_frame_unsharp_amount;

  const int block_size = BLOCK_64X64;
  const int block_w = mi_size_wide[block_size] * 4;
  const int block_h = mi_size_high[block_size] * 4;
  const int num_cols = (source->y_width + block_w - 1) / block_w;
  const int num_rows = (source->y_height + block_h - 1) / block_h;
  double *best_unsharp_amounts =
      aom_malloc(sizeof(*best_unsharp_amounts) * num_cols * num_rows);
  memset(best_unsharp_amounts, 0,
         sizeof(*best_unsharp_amounts) * num_cols * num_rows);

  YV12_BUFFER_CONFIG source_block, blurred_block;
  memset(&source_block, 0, sizeof(source_block));
  memset(&blurred_block, 0, sizeof(blurred_block));
  aom_alloc_frame_buffer(
      &source_block, block_w, block_h, 1, 1, cm->seq_params.use_highbitdepth,
      cpi->oxcf.border_in_pixels, cm->features.byte_alignment);
  aom_alloc_frame_buffer(
      &blurred_block, block_w, block_h, 1, 1, cm->seq_params.use_highbitdepth,
      cpi->oxcf.border_in_pixels, cm->features.byte_alignment);

  for (int row = 0; row < num_rows; ++row) {
    for (int col = 0; col < num_cols; ++col) {
      const int row_offset_y = row * block_h;
      const int col_offset_y = col * block_w;
      const int block_width = AOMMIN(width - col_offset_y, block_w);
      const int block_height = AOMMIN(height - row_offset_y, block_h);
      const int index = col + row * num_cols;

      if (bit_depth > 8) {
        uint16_t *frame_src_buf = CONVERT_TO_SHORTPTR(source->y_buffer) +
                                  row_offset_y * source->y_stride +
                                  col_offset_y;
        uint16_t *frame_blurred_buf = CONVERT_TO_SHORTPTR(blurred.y_buffer) +
                                      row_offset_y * blurred.y_stride +
                                      col_offset_y;
        uint16_t *blurred_dst = CONVERT_TO_SHORTPTR(blurred_block.y_buffer);
        uint16_t *src_dst = CONVERT_TO_SHORTPTR(source_block.y_buffer);

        // Copy block from source frame.
        for (int i = 0; i < block_h; ++i) {
          for (int j = 0; j < block_w; ++j) {
            if (i >= block_height || j >= block_width) {
              src_dst[j] = 0;
              blurred_dst[j] = 0;
            } else {
              src_dst[j] = frame_src_buf[j];
              blurred_dst[j] = frame_blurred_buf[j];
            }
          }
          frame_src_buf += source->y_stride;
          frame_blurred_buf += blurred.y_stride;
          src_dst += source_block.y_stride;
          blurred_dst += blurred_block.y_stride;
        }
      } else {
        uint8_t *frame_src_buf =
            source->y_buffer + row_offset_y * source->y_stride + col_offset_y;
        uint8_t *frame_blurred_buf =
            blurred.y_buffer + row_offset_y * blurred.y_stride + col_offset_y;
        uint8_t *blurred_dst = blurred_block.y_buffer;
        uint8_t *src_dst = source_block.y_buffer;

        // Copy block from source frame.
        for (int i = 0; i < block_h; ++i) {
          for (int j = 0; j < block_w; ++j) {
            if (i >= block_height || j >= block_width) {
              src_dst[j] = 0;
              blurred_dst[j] = 0;
            } else {
              src_dst[j] = frame_src_buf[j];
              blurred_dst[j] = frame_blurred_buf[j];
            }
          }
          frame_src_buf += source->y_stride;
          frame_blurred_buf += blurred.y_stride;
          src_dst += source_block.y_stride;
          blurred_dst += blurred_block.y_stride;
        }
      }

      best_unsharp_amounts[index] = find_best_frame_unsharp_amount(
          cpi, &source_block, &blurred_block, best_frame_unsharp_amount, 0.1, 3,
          1.5);
    }
  }

  // Apply best blur amounts
  for (int row = 0; row < num_rows; ++row) {
    for (int col = 0; col < num_cols; ++col) {
      const int row_offset_y = row * block_h;
      const int col_offset_y = col * block_w;
      const int block_width = AOMMIN(source->y_width - col_offset_y, block_w);
      const int block_height = AOMMIN(source->y_height - row_offset_y, block_h);
      const int index = col + row * num_cols;

      if (bit_depth > 8) {
        uint16_t *src_buf = CONVERT_TO_SHORTPTR(source->y_buffer) +
                            row_offset_y * source->y_stride + col_offset_y;
        uint16_t *blurred_buf = CONVERT_TO_SHORTPTR(blurred.y_buffer) +
                                row_offset_y * blurred.y_stride + col_offset_y;
        highbd_unsharp_rect(src_buf, source->y_stride, blurred_buf,
                            blurred.y_stride, src_buf, source->y_stride,
                            block_width, block_height,
                            best_unsharp_amounts[index], bit_depth);
      } else {
        uint8_t *src_buf =
            source->y_buffer + row_offset_y * source->y_stride + col_offset_y;
        uint8_t *blurred_buf =
            blurred.y_buffer + row_offset_y * blurred.y_stride + col_offset_y;
        unsharp_rect(src_buf, source->y_stride, blurred_buf, blurred.y_stride,
                     src_buf, source->y_stride, block_width, block_height,
                     best_unsharp_amounts[index]);
      }
    }
  }

  aom_free_frame_buffer(&source_block);
  aom_free_frame_buffer(&blurred_block);
  aom_free_frame_buffer(&blurred);
  aom_free(best_unsharp_amounts);
  aom_clear_system_state();
}

typedef struct FrameData {
  const YV12_BUFFER_CONFIG *source, *blurred;
  int block_w, block_h, num_rows, num_cols, row, col, bit_depth;
} FrameData;

// A callback function used to pass data to VMAF.
// Returns 0 after reading a frame.
// Returns 2 when there is no more frame to read.
static int update_frame(float *ref_data, float *main_data, float *temp_data,
                        int stride, void *user_data) {
  FrameData *frames = (FrameData *)user_data;
  const int width = frames->source->y_width;
  const int height = frames->source->y_height;
  const int row = frames->row;
  const int col = frames->col;
  const int num_rows = frames->num_rows;
  const int num_cols = frames->num_cols;
  const int block_w = frames->block_w;
  const int block_h = frames->block_h;
  const YV12_BUFFER_CONFIG *source = frames->source;
  const YV12_BUFFER_CONFIG *blurred = frames->blurred;
  const int bit_depth = frames->bit_depth;
  const float scale_factor = 1.0f / (float)(1 << (bit_depth - 8));
  (void)temp_data;
  stride /= (int)sizeof(*ref_data);

  for (int i = 0; i < height; ++i) {
    float *ref, *main;
    ref = ref_data + i * stride;
    main = main_data + i * stride;
    if (bit_depth == 8) {
      uint8_t *src;
      src = source->y_buffer + i * source->y_stride;
      for (int j = 0; j < width; ++j) {
        ref[j] = main[j] = (float)src[j];
      }
    } else {
      uint16_t *src;
      src = CONVERT_TO_SHORTPTR(source->y_buffer) + i * source->y_stride;
      for (int j = 0; j < width; ++j) {
        ref[j] = main[j] = scale_factor * (float)src[j];
      }
    }
  }
  if (row < num_rows && col < num_cols) {
    // Set current block
    const int row_offset = row * block_h;
    const int col_offset = col * block_w;
    const int block_width = AOMMIN(width - col_offset, block_w);
    const int block_height = AOMMIN(height - row_offset, block_h);

    float *main_buf = main_data + col_offset + row_offset * stride;
    if (bit_depth == 8) {
      uint8_t *blurred_buf =
          blurred->y_buffer + row_offset * blurred->y_stride + col_offset;
      for (int i = 0; i < block_height; ++i) {
        for (int j = 0; j < block_width; ++j) {
          main_buf[j] = (float)blurred_buf[j];
        }
        main_buf += stride;
        blurred_buf += blurred->y_stride;
      }
    } else {
      uint16_t *blurred_buf = CONVERT_TO_SHORTPTR(blurred->y_buffer) +
                              row_offset * blurred->y_stride + col_offset;
      for (int i = 0; i < block_height; ++i) {
        for (int j = 0; j < block_width; ++j) {
          main_buf[j] = scale_factor * (float)blurred_buf[j];
        }
        main_buf += stride;
        blurred_buf += blurred->y_stride;
      }
    }

    frames->col++;
    if (frames->col >= num_cols) {
      frames->col = 0;
      frames->row++;
    }
    return 0;
  } else {
    return 2;
  }
}

void av1_set_mb_vmaf_rdmult_scaling(AV1_COMP *cpi) {
  AV1_COMMON *cm = &cpi->common;
  const int y_width = cpi->source->y_width;
  const int y_height = cpi->source->y_height;
  const int resized_block_size = BLOCK_32X32;
  const int resize_factor = 2;
  const int bit_depth = cpi->td.mb.e_mbd.bd;

  aom_clear_system_state();
  YV12_BUFFER_CONFIG resized_source;
  memset(&resized_source, 0, sizeof(resized_source));
  aom_alloc_frame_buffer(
      &resized_source, y_width / resize_factor, y_height / resize_factor, 1, 1,
      cm->seq_params.use_highbitdepth, cpi->oxcf.border_in_pixels,
      cm->features.byte_alignment);
  av1_resize_and_extend_frame(cpi->source, &resized_source, bit_depth,
                              av1_num_planes(cm));

  const int resized_y_width = resized_source.y_width;
  const int resized_y_height = resized_source.y_height;
  const int resized_block_w = mi_size_wide[resized_block_size] * 4;
  const int resized_block_h = mi_size_high[resized_block_size] * 4;
  const int num_cols =
      (resized_y_width + resized_block_w - 1) / resized_block_w;
  const int num_rows =
      (resized_y_height + resized_block_h - 1) / resized_block_h;

  YV12_BUFFER_CONFIG blurred;
  memset(&blurred, 0, sizeof(blurred));
  aom_alloc_frame_buffer(&blurred, resized_y_width, resized_y_height, 1, 1,
                         cm->seq_params.use_highbitdepth,
                         cpi->oxcf.border_in_pixels,
                         cm->features.byte_alignment);
  gaussian_blur(bit_depth, &resized_source, &blurred);

  double *scores = aom_malloc(sizeof(*scores) * (num_rows * num_cols));
  memset(scores, 0, sizeof(*scores) * (num_rows * num_cols));
  FrameData frame_data;
  frame_data.source = &resized_source;
  frame_data.blurred = &blurred;
  frame_data.block_w = resized_block_w;
  frame_data.block_h = resized_block_h;
  frame_data.num_rows = num_rows;
  frame_data.num_cols = num_cols;
  frame_data.row = 0;
  frame_data.col = 0;
  frame_data.bit_depth = bit_depth;
  aom_calc_vmaf_multi_frame(&frame_data, cpi->oxcf.vmaf_model_path,
                            update_frame, resized_y_width, resized_y_height,
                            bit_depth, scores);

  // Loop through each 'block_size' block.
  for (int row = 0; row < num_rows; ++row) {
    for (int col = 0; col < num_cols; ++col) {
      const int index = row * num_cols + col;
      const int row_offset_y = row * resized_block_h;
      const int col_offset_y = col * resized_block_w;

      uint8_t *const orig_buf = resized_source.y_buffer +
                                row_offset_y * resized_source.y_stride +
                                col_offset_y;
      uint8_t *const blurred_buf =
          blurred.y_buffer + row_offset_y * blurred.y_stride + col_offset_y;

      const double vmaf = scores[index];
      const double dvmaf = kBaselineVmaf - vmaf;
      unsigned int sse;
      cpi->fn_ptr[resized_block_size].vf(orig_buf, resized_source.y_stride,
                                         blurred_buf, blurred.y_stride, &sse);

      const double mse =
          (double)sse / (double)(resized_y_width * resized_y_height);
      double weight;
      const double eps = 0.01 / (num_rows * num_cols);
      if (dvmaf < eps || mse < eps) {
        weight = 1.0;
      } else {
        weight = mse / dvmaf;
      }

      // Normalize it with a data fitted model.
      weight = 6.0 * (1.0 - exp(-0.05 * weight)) + 0.8;
      cpi->vmaf_rdmult_scaling_factors[index] = weight;
    }
  }

  aom_free_frame_buffer(&resized_source);
  aom_free_frame_buffer(&blurred);
  aom_free(scores);
  aom_clear_system_state();
}

void av1_set_vmaf_rdmult(const AV1_COMP *const cpi, MACROBLOCK *const x,
                         const BLOCK_SIZE bsize, const int mi_row,
                         const int mi_col, int *const rdmult) {
  const AV1_COMMON *const cm = &cpi->common;

  const int bsize_base = BLOCK_64X64;
  const int num_mi_w = mi_size_wide[bsize_base];
  const int num_mi_h = mi_size_high[bsize_base];
  const int num_cols = (cm->mi_params.mi_cols + num_mi_w - 1) / num_mi_w;
  const int num_rows = (cm->mi_params.mi_rows + num_mi_h - 1) / num_mi_h;
  const int num_bcols = (mi_size_wide[bsize] + num_mi_w - 1) / num_mi_w;
  const int num_brows = (mi_size_high[bsize] + num_mi_h - 1) / num_mi_h;
  int row, col;
  double num_of_mi = 0.0;
  double geom_mean_of_scale = 0.0;

  aom_clear_system_state();
  for (row = mi_row / num_mi_w;
       row < num_rows && row < mi_row / num_mi_w + num_brows; ++row) {
    for (col = mi_col / num_mi_h;
         col < num_cols && col < mi_col / num_mi_h + num_bcols; ++col) {
      const int index = row * num_cols + col;
      geom_mean_of_scale += log(cpi->vmaf_rdmult_scaling_factors[index]);
      num_of_mi += 1.0;
    }
  }
  geom_mean_of_scale = exp(geom_mean_of_scale / num_of_mi);

  *rdmult = (int)((double)(*rdmult) * geom_mean_of_scale + 0.5);
  *rdmult = AOMMAX(*rdmult, 0);
  set_error_per_bit(x, *rdmult);
  aom_clear_system_state();
}

// TODO(sdeng): replace them with the SIMD versions.
static AOM_INLINE double highbd_image_sad_c(const uint16_t *src, int src_stride,
                                            const uint16_t *ref, int ref_stride,
                                            int w, int h) {
  double accum = 0.0;
  int i, j;

  for (i = 0; i < h; ++i) {
    for (j = 0; j < w; ++j) {
      double img1px = src[i * src_stride + j];
      double img2px = ref[i * ref_stride + j];

      accum += fabs(img1px - img2px);
    }
  }

  return accum / (double)(h * w);
}

static AOM_INLINE double image_sad_c(const uint8_t *src, int src_stride,
                                     const uint8_t *ref, int ref_stride, int w,
                                     int h) {
  double accum = 0.0;
  int i, j;

  for (i = 0; i < h; ++i) {
    for (j = 0; j < w; ++j) {
      double img1px = src[i * src_stride + j];
      double img2px = ref[i * ref_stride + j];

      accum += fabs(img1px - img2px);
    }
  }

  return accum / (double)(h * w);
}

static AOM_INLINE double calc_vmaf_motion_score(
    const AV1_COMP *const cpi, const AV1_COMMON *const cm,
    const YV12_BUFFER_CONFIG *const cur, const YV12_BUFFER_CONFIG *const last,
    const YV12_BUFFER_CONFIG *const next) {
  const int y_width = cur->y_width;
  const int y_height = cur->y_height;
  YV12_BUFFER_CONFIG blurred_cur, blurred_last, blurred_next;
  const int bit_depth = cpi->td.mb.e_mbd.bd;

  memset(&blurred_cur, 0, sizeof(blurred_cur));
  memset(&blurred_last, 0, sizeof(blurred_last));
  memset(&blurred_next, 0, sizeof(blurred_next));

  aom_alloc_frame_buffer(
      &blurred_cur, y_width, y_height, 1, 1, cm->seq_params.use_highbitdepth,
      cpi->oxcf.border_in_pixels, cm->features.byte_alignment);
  aom_alloc_frame_buffer(
      &blurred_last, y_width, y_height, 1, 1, cm->seq_params.use_highbitdepth,
      cpi->oxcf.border_in_pixels, cm->features.byte_alignment);
  aom_alloc_frame_buffer(
      &blurred_next, y_width, y_height, 1, 1, cm->seq_params.use_highbitdepth,
      cpi->oxcf.border_in_pixels, cm->features.byte_alignment);

  gaussian_blur(bit_depth, cur, &blurred_cur);
  gaussian_blur(bit_depth, last, &blurred_last);
  if (next) gaussian_blur(bit_depth, next, &blurred_next);

  double motion1, motion2 = 65536.0;
  if (bit_depth > 8) {
    const float scale_factor = 1.0f / (float)(1 << (bit_depth - 8));
    motion1 = highbd_image_sad_c(CONVERT_TO_SHORTPTR(blurred_cur.y_buffer),
                                 blurred_cur.y_stride,
                                 CONVERT_TO_SHORTPTR(blurred_last.y_buffer),
                                 blurred_last.y_stride, y_width, y_height) *
              scale_factor;
    if (next) {
      motion2 = highbd_image_sad_c(CONVERT_TO_SHORTPTR(blurred_cur.y_buffer),
                                   blurred_cur.y_stride,
                                   CONVERT_TO_SHORTPTR(blurred_next.y_buffer),
                                   blurred_next.y_stride, y_width, y_height) *
                scale_factor;
    }
  } else {
    motion1 = image_sad_c(blurred_cur.y_buffer, blurred_cur.y_stride,
                          blurred_last.y_buffer, blurred_last.y_stride, y_width,
                          y_height);
    if (next) {
      motion2 = image_sad_c(blurred_cur.y_buffer, blurred_cur.y_stride,
                            blurred_next.y_buffer, blurred_next.y_stride,
                            y_width, y_height);
    }
  }

  aom_free_frame_buffer(&blurred_cur);
  aom_free_frame_buffer(&blurred_last);
  aom_free_frame_buffer(&blurred_next);

  return AOMMIN(motion1, motion2);
}

// Calculates the new qindex from the VMAF motion score. This is based on the
// observation: when the motion score becomes higher, the VMAF score of the
// same source and distorted frames would become higher.
int av1_get_vmaf_base_qindex(const AV1_COMP *const cpi, int current_qindex) {
  const AV1_COMMON *const cm = &cpi->common;
  if (cm->current_frame.frame_number == 0 || cpi->oxcf.pass == 1) {
    return current_qindex;
  }
  const int bit_depth = cpi->td.mb.e_mbd.bd;
  const double approx_sse =
      cpi->last_frame_ysse /
      (double)((1 << (bit_depth - 8)) * (1 << (bit_depth - 8)));
  const double approx_dvmaf = kBaselineVmaf - cpi->last_frame_vmaf;
  const double sse_threshold =
      0.01 * cpi->source->y_width * cpi->source->y_height;
  const double vmaf_threshold = 0.01;
  if (approx_sse < sse_threshold || approx_dvmaf < vmaf_threshold) {
    return current_qindex;
  }
  aom_clear_system_state();
  const GF_GROUP *gf_group = &cpi->gf_group;
  YV12_BUFFER_CONFIG *cur_buf = cpi->source;
  int src_index = 0;
  if (cm->show_frame == 0) {
    src_index = gf_group->arf_src_offset[gf_group->index];
    struct lookahead_entry *cur_entry =
        av1_lookahead_peek(cpi->lookahead, src_index, cpi->compressor_stage);
    cur_buf = &cur_entry->img;
  }
  assert(cur_buf);

  const struct lookahead_entry *last_entry =
      av1_lookahead_peek(cpi->lookahead, src_index - 1, cpi->compressor_stage);
  const struct lookahead_entry *next_entry =
      av1_lookahead_peek(cpi->lookahead, src_index + 1, cpi->compressor_stage);
  const YV12_BUFFER_CONFIG *next_buf = &next_entry->img;
  const YV12_BUFFER_CONFIG *last_buf =
      cm->show_frame ? cpi->last_source : &last_entry->img;

  assert(last_buf);

  const double motion =
      calc_vmaf_motion_score(cpi, cm, cur_buf, last_buf, next_buf);

  // Get dVMAF through a data fitted model.
  const double dvmaf = 26.11 * (1.0 - exp(-0.06 * motion));
  const double dsse = dvmaf * approx_sse / approx_dvmaf;

  const double beta = approx_sse / (dsse + approx_sse);
  const int offset = av1_get_deltaq_offset(cpi, current_qindex, beta);
  int qindex = current_qindex + offset;

  qindex = AOMMIN(qindex, MAXQ);
  qindex = AOMMAX(qindex, MINQ);

  aom_clear_system_state();
  return qindex;
}

void av1_update_vmaf_curve(AV1_COMP *cpi, YV12_BUFFER_CONFIG *source,
                           YV12_BUFFER_CONFIG *recon) {
  const int bit_depth = cpi->td.mb.e_mbd.bd;
  aom_calc_vmaf(cpi->oxcf.vmaf_model_path, source, recon, bit_depth,
                &cpi->last_frame_vmaf);
  if (bit_depth > 8) {
    cpi->last_frame_ysse = (double)aom_highbd_get_y_sse(source, recon);
  } else {
    cpi->last_frame_ysse = (double)aom_get_y_sse(source, recon);
  }
}
