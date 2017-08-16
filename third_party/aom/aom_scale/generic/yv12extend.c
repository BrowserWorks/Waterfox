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
#include "./aom_config.h"
#include "./aom_scale_rtcd.h"
#include "aom/aom_integer.h"
#include "aom_mem/aom_mem.h"
#include "aom_ports/mem.h"
#include "aom_scale/yv12config.h"

static void extend_plane(uint8_t *const src, int src_stride, int width,
                         int height, int extend_top, int extend_left,
                         int extend_bottom, int extend_right) {
  int i;
  const int linesize = extend_left + extend_right + width;

  /* copy the left and right most columns out */
  uint8_t *src_ptr1 = src;
  uint8_t *src_ptr2 = src + width - 1;
  uint8_t *dst_ptr1 = src - extend_left;
  uint8_t *dst_ptr2 = src + width;

  for (i = 0; i < height; ++i) {
    memset(dst_ptr1, src_ptr1[0], extend_left);
    memset(dst_ptr2, src_ptr2[0], extend_right);
    src_ptr1 += src_stride;
    src_ptr2 += src_stride;
    dst_ptr1 += src_stride;
    dst_ptr2 += src_stride;
  }

  /* Now copy the top and bottom lines into each line of the respective
   * borders
   */
  src_ptr1 = src - extend_left;
  src_ptr2 = src + src_stride * (height - 1) - extend_left;
  dst_ptr1 = src + src_stride * -extend_top - extend_left;
  dst_ptr2 = src + src_stride * height - extend_left;

  for (i = 0; i < extend_top; ++i) {
    memcpy(dst_ptr1, src_ptr1, linesize);
    dst_ptr1 += src_stride;
  }

  for (i = 0; i < extend_bottom; ++i) {
    memcpy(dst_ptr2, src_ptr2, linesize);
    dst_ptr2 += src_stride;
  }
}

#if CONFIG_HIGHBITDEPTH
static void extend_plane_high(uint8_t *const src8, int src_stride, int width,
                              int height, int extend_top, int extend_left,
                              int extend_bottom, int extend_right) {
  int i;
  const int linesize = extend_left + extend_right + width;
  uint16_t *src = CONVERT_TO_SHORTPTR(src8);

  /* copy the left and right most columns out */
  uint16_t *src_ptr1 = src;
  uint16_t *src_ptr2 = src + width - 1;
  uint16_t *dst_ptr1 = src - extend_left;
  uint16_t *dst_ptr2 = src + width;

  for (i = 0; i < height; ++i) {
    aom_memset16(dst_ptr1, src_ptr1[0], extend_left);
    aom_memset16(dst_ptr2, src_ptr2[0], extend_right);
    src_ptr1 += src_stride;
    src_ptr2 += src_stride;
    dst_ptr1 += src_stride;
    dst_ptr2 += src_stride;
  }

  /* Now copy the top and bottom lines into each line of the respective
   * borders
   */
  src_ptr1 = src - extend_left;
  src_ptr2 = src + src_stride * (height - 1) - extend_left;
  dst_ptr1 = src + src_stride * -extend_top - extend_left;
  dst_ptr2 = src + src_stride * height - extend_left;

  for (i = 0; i < extend_top; ++i) {
    memcpy(dst_ptr1, src_ptr1, linesize * sizeof(uint16_t));
    dst_ptr1 += src_stride;
  }

  for (i = 0; i < extend_bottom; ++i) {
    memcpy(dst_ptr2, src_ptr2, linesize * sizeof(uint16_t));
    dst_ptr2 += src_stride;
  }
}
#endif

void aom_yv12_extend_frame_borders_c(YV12_BUFFER_CONFIG *ybf) {
  const int uv_border = ybf->border / 2;

  assert(ybf->border % 2 == 0);
  assert(ybf->y_height - ybf->y_crop_height < 16);
  assert(ybf->y_width - ybf->y_crop_width < 16);
  assert(ybf->y_height - ybf->y_crop_height >= 0);
  assert(ybf->y_width - ybf->y_crop_width >= 0);

#if CONFIG_HIGHBITDEPTH
  if (ybf->flags & YV12_FLAG_HIGHBITDEPTH) {
    extend_plane_high(ybf->y_buffer, ybf->y_stride, ybf->y_crop_width,
                      ybf->y_crop_height, ybf->border, ybf->border,
                      ybf->border + ybf->y_height - ybf->y_crop_height,
                      ybf->border + ybf->y_width - ybf->y_crop_width);

    extend_plane_high(ybf->u_buffer, ybf->uv_stride, ybf->uv_crop_width,
                      ybf->uv_crop_height, uv_border, uv_border,
                      uv_border + ybf->uv_height - ybf->uv_crop_height,
                      uv_border + ybf->uv_width - ybf->uv_crop_width);

    extend_plane_high(ybf->v_buffer, ybf->uv_stride, ybf->uv_crop_width,
                      ybf->uv_crop_height, uv_border, uv_border,
                      uv_border + ybf->uv_height - ybf->uv_crop_height,
                      uv_border + ybf->uv_width - ybf->uv_crop_width);
    return;
  }
#endif
  extend_plane(ybf->y_buffer, ybf->y_stride, ybf->y_crop_width,
               ybf->y_crop_height, ybf->border, ybf->border,
               ybf->border + ybf->y_height - ybf->y_crop_height,
               ybf->border + ybf->y_width - ybf->y_crop_width);

  extend_plane(ybf->u_buffer, ybf->uv_stride, ybf->uv_crop_width,
               ybf->uv_crop_height, uv_border, uv_border,
               uv_border + ybf->uv_height - ybf->uv_crop_height,
               uv_border + ybf->uv_width - ybf->uv_crop_width);

  extend_plane(ybf->v_buffer, ybf->uv_stride, ybf->uv_crop_width,
               ybf->uv_crop_height, uv_border, uv_border,
               uv_border + ybf->uv_height - ybf->uv_crop_height,
               uv_border + ybf->uv_width - ybf->uv_crop_width);
}

#if CONFIG_AV1
static void extend_frame(YV12_BUFFER_CONFIG *const ybf, int ext_size) {
  const int c_w = ybf->uv_crop_width;
  const int c_h = ybf->uv_crop_height;
  const int ss_x = ybf->uv_width < ybf->y_width;
  const int ss_y = ybf->uv_height < ybf->y_height;
  const int c_et = ext_size >> ss_y;
  const int c_el = ext_size >> ss_x;
  const int c_eb = c_et + ybf->uv_height - ybf->uv_crop_height;
  const int c_er = c_el + ybf->uv_width - ybf->uv_crop_width;

  assert(ybf->y_height - ybf->y_crop_height < 16);
  assert(ybf->y_width - ybf->y_crop_width < 16);
  assert(ybf->y_height - ybf->y_crop_height >= 0);
  assert(ybf->y_width - ybf->y_crop_width >= 0);

#if CONFIG_HIGHBITDEPTH
  if (ybf->flags & YV12_FLAG_HIGHBITDEPTH) {
    extend_plane_high(ybf->y_buffer, ybf->y_stride, ybf->y_crop_width,
                      ybf->y_crop_height, ext_size, ext_size,
                      ext_size + ybf->y_height - ybf->y_crop_height,
                      ext_size + ybf->y_width - ybf->y_crop_width);
    extend_plane_high(ybf->u_buffer, ybf->uv_stride, c_w, c_h, c_et, c_el, c_eb,
                      c_er);
    extend_plane_high(ybf->v_buffer, ybf->uv_stride, c_w, c_h, c_et, c_el, c_eb,
                      c_er);
    return;
  }
#endif
  extend_plane(ybf->y_buffer, ybf->y_stride, ybf->y_crop_width,
               ybf->y_crop_height, ext_size, ext_size,
               ext_size + ybf->y_height - ybf->y_crop_height,
               ext_size + ybf->y_width - ybf->y_crop_width);

  extend_plane(ybf->u_buffer, ybf->uv_stride, c_w, c_h, c_et, c_el, c_eb, c_er);

  extend_plane(ybf->v_buffer, ybf->uv_stride, c_w, c_h, c_et, c_el, c_eb, c_er);
}

void aom_extend_frame_borders_c(YV12_BUFFER_CONFIG *ybf) {
  extend_frame(ybf, ybf->border);
}

void aom_extend_frame_inner_borders_c(YV12_BUFFER_CONFIG *ybf) {
  const int inner_bw = (ybf->border > AOMINNERBORDERINPIXELS)
                           ? AOMINNERBORDERINPIXELS
                           : ybf->border;
  extend_frame(ybf, inner_bw);
}

void aom_extend_frame_borders_y_c(YV12_BUFFER_CONFIG *ybf) {
  int ext_size = ybf->border;
  assert(ybf->y_height - ybf->y_crop_height < 16);
  assert(ybf->y_width - ybf->y_crop_width < 16);
  assert(ybf->y_height - ybf->y_crop_height >= 0);
  assert(ybf->y_width - ybf->y_crop_width >= 0);

#if CONFIG_HIGHBITDEPTH
  if (ybf->flags & YV12_FLAG_HIGHBITDEPTH) {
    extend_plane_high(ybf->y_buffer, ybf->y_stride, ybf->y_crop_width,
                      ybf->y_crop_height, ext_size, ext_size,
                      ext_size + ybf->y_height - ybf->y_crop_height,
                      ext_size + ybf->y_width - ybf->y_crop_width);
    return;
  }
#endif
  extend_plane(ybf->y_buffer, ybf->y_stride, ybf->y_crop_width,
               ybf->y_crop_height, ext_size, ext_size,
               ext_size + ybf->y_height - ybf->y_crop_height,
               ext_size + ybf->y_width - ybf->y_crop_width);
}
#endif  // CONFIG_AV1

#if CONFIG_HIGHBITDEPTH
static void memcpy_short_addr(uint8_t *dst8, const uint8_t *src8, int num) {
  uint16_t *dst = CONVERT_TO_SHORTPTR(dst8);
  uint16_t *src = CONVERT_TO_SHORTPTR(src8);
  memcpy(dst, src, num * sizeof(uint16_t));
}
#endif  // CONFIG_HIGHBITDEPTH

// Copies the source image into the destination image and updates the
// destination's UMV borders.
// Note: The frames are assumed to be identical in size.
void aom_yv12_copy_frame_c(const YV12_BUFFER_CONFIG *src_bc,
                           YV12_BUFFER_CONFIG *dst_bc) {
  int row;
  const uint8_t *src = src_bc->y_buffer;
  uint8_t *dst = dst_bc->y_buffer;

#if 0
  /* These assertions are valid in the codec, but the libaom-tester uses
   * this code slightly differently.
   */
  assert(src_bc->y_width == dst_bc->y_width);
  assert(src_bc->y_height == dst_bc->y_height);
#endif

#if CONFIG_HIGHBITDEPTH
  if (src_bc->flags & YV12_FLAG_HIGHBITDEPTH) {
    assert(dst_bc->flags & YV12_FLAG_HIGHBITDEPTH);
    for (row = 0; row < src_bc->y_height; ++row) {
      memcpy_short_addr(dst, src, src_bc->y_width);
      src += src_bc->y_stride;
      dst += dst_bc->y_stride;
    }

    src = src_bc->u_buffer;
    dst = dst_bc->u_buffer;

    for (row = 0; row < src_bc->uv_height; ++row) {
      memcpy_short_addr(dst, src, src_bc->uv_width);
      src += src_bc->uv_stride;
      dst += dst_bc->uv_stride;
    }

    src = src_bc->v_buffer;
    dst = dst_bc->v_buffer;

    for (row = 0; row < src_bc->uv_height; ++row) {
      memcpy_short_addr(dst, src, src_bc->uv_width);
      src += src_bc->uv_stride;
      dst += dst_bc->uv_stride;
    }

    aom_yv12_extend_frame_borders_c(dst_bc);
    return;
  } else {
    assert(!(dst_bc->flags & YV12_FLAG_HIGHBITDEPTH));
  }
#endif

  for (row = 0; row < src_bc->y_height; ++row) {
    memcpy(dst, src, src_bc->y_width);
    src += src_bc->y_stride;
    dst += dst_bc->y_stride;
  }

  src = src_bc->u_buffer;
  dst = dst_bc->u_buffer;

  for (row = 0; row < src_bc->uv_height; ++row) {
    memcpy(dst, src, src_bc->uv_width);
    src += src_bc->uv_stride;
    dst += dst_bc->uv_stride;
  }

  src = src_bc->v_buffer;
  dst = dst_bc->v_buffer;

  for (row = 0; row < src_bc->uv_height; ++row) {
    memcpy(dst, src, src_bc->uv_width);
    src += src_bc->uv_stride;
    dst += dst_bc->uv_stride;
  }

  aom_yv12_extend_frame_borders_c(dst_bc);
}

void aom_yv12_copy_y_c(const YV12_BUFFER_CONFIG *src_ybc,
                       YV12_BUFFER_CONFIG *dst_ybc) {
  int row;
  const uint8_t *src = src_ybc->y_buffer;
  uint8_t *dst = dst_ybc->y_buffer;

#if CONFIG_HIGHBITDEPTH
  if (src_ybc->flags & YV12_FLAG_HIGHBITDEPTH) {
    const uint16_t *src16 = CONVERT_TO_SHORTPTR(src);
    uint16_t *dst16 = CONVERT_TO_SHORTPTR(dst);
    for (row = 0; row < src_ybc->y_height; ++row) {
      memcpy(dst16, src16, src_ybc->y_width * sizeof(uint16_t));
      src16 += src_ybc->y_stride;
      dst16 += dst_ybc->y_stride;
    }
    return;
  }
#endif  // CONFIG_HIGHBITDEPTH

  for (row = 0; row < src_ybc->y_height; ++row) {
    memcpy(dst, src, src_ybc->y_width);
    src += src_ybc->y_stride;
    dst += dst_ybc->y_stride;
  }
}

void aom_yv12_copy_u_c(const YV12_BUFFER_CONFIG *src_bc,
                       YV12_BUFFER_CONFIG *dst_bc) {
  int row;
  const uint8_t *src = src_bc->u_buffer;
  uint8_t *dst = dst_bc->u_buffer;

#if CONFIG_HIGHBITDEPTH
  if (src_bc->flags & YV12_FLAG_HIGHBITDEPTH) {
    const uint16_t *src16 = CONVERT_TO_SHORTPTR(src);
    uint16_t *dst16 = CONVERT_TO_SHORTPTR(dst);
    for (row = 0; row < src_bc->uv_height; ++row) {
      memcpy(dst16, src16, src_bc->uv_width * sizeof(uint16_t));
      src16 += src_bc->uv_stride;
      dst16 += dst_bc->uv_stride;
    }
    return;
  }
#endif  // CONFIG_HIGHBITDEPTH

  for (row = 0; row < src_bc->uv_height; ++row) {
    memcpy(dst, src, src_bc->uv_width);
    src += src_bc->uv_stride;
    dst += dst_bc->uv_stride;
  }
}

void aom_yv12_copy_v_c(const YV12_BUFFER_CONFIG *src_bc,
                       YV12_BUFFER_CONFIG *dst_bc) {
  int row;
  const uint8_t *src = src_bc->v_buffer;
  uint8_t *dst = dst_bc->v_buffer;

#if CONFIG_HIGHBITDEPTH
  if (src_bc->flags & YV12_FLAG_HIGHBITDEPTH) {
    const uint16_t *src16 = CONVERT_TO_SHORTPTR(src);
    uint16_t *dst16 = CONVERT_TO_SHORTPTR(dst);
    for (row = 0; row < src_bc->uv_height; ++row) {
      memcpy(dst16, src16, src_bc->uv_width * sizeof(uint16_t));
      src16 += src_bc->uv_stride;
      dst16 += dst_bc->uv_stride;
    }
    return;
  }
#endif  // CONFIG_HIGHBITDEPTH

  for (row = 0; row < src_bc->uv_height; ++row) {
    memcpy(dst, src, src_bc->uv_width);
    src += src_bc->uv_stride;
    dst += dst_bc->uv_stride;
  }
}
