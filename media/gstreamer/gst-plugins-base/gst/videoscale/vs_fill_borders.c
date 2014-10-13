/*
 * Image Scaling Functions
 * Copyright (c) 2010 Sebastian Dröge <sebastian.droege@collabora.co.uk>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/gst.h>
#include <string.h>

#include "vs_fill_borders.h"
#include "gstvideoscaleorc.h"

#if G_BYTE_ORDER == G_LITTLE_ENDIAN
#define READ_UINT32(ptr) GST_READ_UINT32_LE(ptr)
#define READ_UINT16(ptr) GST_READ_UINT16_LE(ptr)
#else
#define READ_UINT32(ptr) GST_READ_UINT32_BE(ptr)
#define READ_UINT16(ptr) GST_READ_UINT16_BE(ptr)
#endif

void
vs_fill_borders_RGBA (const VSImage * dest, const uint8_t * val)
{
  int i;
  int top = dest->border_top, bottom = dest->border_bottom;
  int left = dest->border_left, right = dest->border_right;
  int width = dest->width;
  int height = dest->height;
  int real_width = dest->real_width;
  gsize stride = dest->stride;
  int tmp, tmp2;
  uint8_t *data;
  uint32_t v = READ_UINT32 (val);

  data = dest->real_pixels;
  for (i = 0; i < top; i++) {
    video_scale_orc_splat_u32 ((uint32_t *) data, v, real_width);
    data += stride;
  }

  if (left || right) {
    tmp = height;
    tmp2 = (left + width) * 4;
    for (i = 0; i < tmp; i++) {
      video_scale_orc_splat_u32 ((uint32_t *) data, v, left);
      video_scale_orc_splat_u32 ((uint32_t *) (data + tmp2), v, right);
      data += stride;
    }
  } else {
    data += stride * height;
  }

  for (i = 0; i < bottom; i++) {
    video_scale_orc_splat_u32 ((uint32_t *) data, v, real_width);
    data += stride;
  }
}

static void
_memset_u24 (uint8_t * data, uint8_t val1, uint8_t val2, uint8_t val3,
    unsigned int n)
{
  unsigned int i;

  for (i = 0; i < n; i++) {
    data[0] = val1;
    data[1] = val2;
    data[2] = val3;
    data += 3;
  }
}

void
vs_fill_borders_RGB (const VSImage * dest, const uint8_t * val)
{
  int i;
  int top = dest->border_top, bottom = dest->border_bottom;
  int left = dest->border_left, right = dest->border_right;
  int width = dest->width;
  int height = dest->height;
  int real_width = dest->real_width;
  gsize stride = dest->stride;
  int tmp, tmp2;
  uint8_t *data;

  data = dest->real_pixels;
  for (i = 0; i < top; i++) {
    _memset_u24 (data, val[0], val[1], val[2], real_width);
    data += stride;
  }

  if (left || right) {
    tmp = height;
    tmp2 = (left + width) * 3;
    for (i = 0; i < tmp; i++) {
      _memset_u24 (data, val[0], val[1], val[2], left);
      _memset_u24 (data + tmp2, val[0], val[1], val[2], right);
      data += stride;
    }
  } else {
    data += stride * height;
  }

  for (i = 0; i < bottom; i++) {
    _memset_u24 (data, val[0], val[1], val[2], real_width);
    data += stride;
  }
}

void
vs_fill_borders_YUYV (const VSImage * dest, const uint8_t * val)
{
  int i, j;
  int top = dest->border_top, bottom = dest->border_bottom;
  int left = dest->border_left, right = dest->border_right;
  int width = dest->width;
  int height = dest->height;
  int real_width = dest->real_width;
  gsize stride = dest->stride;
  int tmp, tmp2;
  uint8_t *data;

  data = dest->real_pixels;
  for (i = 0; i < top; i++) {
    for (j = 0; j < real_width; j++) {
      data[2 * j] = val[0];
      data[2 * j + 1] = (j % 2 == 0) ? val[1] : val[3];
    }
    data += stride;
  }

  if (left || right) {
    tmp = height;
    tmp2 = (left + width) * 2;
    for (i = 0; i < tmp; i++) {
      for (j = 0; j < left; j++) {
        data[2 * j] = val[0];
        data[2 * j + 1] = (j % 2 == 0) ? val[1] : val[3];
      }
      for (j = 0; j < right; j++) {
        data[tmp2 + 2 * j] = val[0];
        data[tmp2 + 2 * j + 1] = (j % 2 == 0) ? val[1] : val[3];
      }
      data += stride;
    }
  } else {
    data += stride * height;
  }

  for (i = 0; i < bottom; i++) {
    for (j = 0; j < real_width; j++) {
      data[2 * j] = val[0];
      data[2 * j + 1] = (j % 2 == 0) ? val[1] : val[3];
    }
    data += stride;
  }
}

void
vs_fill_borders_UYVY (const VSImage * dest, const uint8_t * val)
{
  int i, j;
  int top = dest->border_top, bottom = dest->border_bottom;
  int left = dest->border_left, right = dest->border_right;
  int width = dest->width;
  int height = dest->height;
  int real_width = dest->real_width;
  gsize stride = dest->stride;
  int tmp, tmp2;
  uint8_t *data;

  data = dest->real_pixels;
  for (i = 0; i < top; i++) {
    for (j = 0; j < real_width; j++) {
      data[2 * j] = (j % 2 == 0) ? val[0] : val[2];
      data[2 * j + 1] = val[1];
    }
    data += stride;
  }

  if (left || right) {
    tmp = height;
    tmp2 = (left + width) * 2;
    for (i = 0; i < tmp; i++) {
      for (j = 0; j < left; j++) {
        data[2 * j] = (j % 2 == 0) ? val[0] : val[2];
        data[2 * j + 1] = val[1];
      }
      for (j = 0; j < right; j++) {
        data[tmp2 + 2 * j] = (j % 2 == 0) ? val[0] : val[2];
        data[tmp2 + 2 * j + 1] = val[1];
      }
      data += stride;
    }
  } else {
    data += stride * height;
  }

  for (i = 0; i < bottom; i++) {
    for (j = 0; j < real_width; j++) {
      data[2 * j] = (j % 2 == 0) ? val[0] : val[2];
      data[2 * j + 1] = val[1];
    }
    data += stride;
  }
}

void
vs_fill_borders_Y (const VSImage * dest, const uint8_t * val)
{
  int i;
  int top = dest->border_top, bottom = dest->border_bottom;
  int left = dest->border_left, right = dest->border_right;
  int width = dest->width;
  int height = dest->height;
  int real_width = dest->real_width;
  gsize stride = dest->stride;
  int tmp, tmp2;
  uint8_t *data;

  data = dest->real_pixels;
  for (i = 0; i < top; i++) {
    memset (data, *val, real_width);
    data += stride;
  }

  if (left || right) {
    tmp = height;
    tmp2 = left + width;
    for (i = 0; i < tmp; i++) {
      memset (data, *val, left);
      memset (data + tmp2, *val, right);
      data += stride;
    }
  } else {
    data += stride * height;
  }

  for (i = 0; i < bottom; i++) {
    memset (data, *val, real_width);
    data += stride;
  }
}

void
vs_fill_borders_Y16 (const VSImage * dest, const uint16_t val)
{
  int i;
  int top = dest->border_top, bottom = dest->border_bottom;
  int left = dest->border_left, right = dest->border_right;
  int width = dest->width;
  int height = dest->height;
  int real_width = dest->real_width;
  gsize stride = dest->stride;
  int tmp, tmp2;
  uint8_t *data;

  data = dest->real_pixels;
  for (i = 0; i < top; i++) {
    video_scale_orc_splat_u16 ((uint16_t *) data, val, real_width);
    data += stride;
  }

  if (left || right) {
    tmp = height;
    tmp2 = (left + width) * 2;
    for (i = 0; i < tmp; i++) {
      video_scale_orc_splat_u16 ((uint16_t *) data, val, left);
      video_scale_orc_splat_u16 ((uint16_t *) (data + tmp2), val, right);
      data += stride;
    }
  } else {
    data += stride * height;
  }

  for (i = 0; i < bottom; i++) {
    video_scale_orc_splat_u16 ((uint16_t *) data, val, real_width);
    data += stride;
  }
}

void
vs_fill_borders_RGB565 (const VSImage * dest, const uint8_t * val)
{
  int i;
  int top = dest->border_top, bottom = dest->border_bottom;
  int left = dest->border_left, right = dest->border_right;
  int width = dest->width;
  int height = dest->height;
  int real_width = dest->real_width;
  gsize stride = dest->stride;
  int tmp, tmp2;
  uint8_t *data;
  uint16_t v = READ_UINT16 (val);

  data = dest->real_pixels;
  for (i = 0; i < top; i++) {
    video_scale_orc_splat_u16 ((uint16_t *) data, v, real_width);
    data += stride;
  }

  if (left || right) {
    tmp = height;
    tmp2 = (left + width) * 2;
    for (i = 0; i < tmp; i++) {
      video_scale_orc_splat_u16 ((uint16_t *) data, v, left);
      video_scale_orc_splat_u16 ((uint16_t *) (data + tmp2), v, right);
      data += stride;
    }
  } else {
    data += stride * height;
  }

  for (i = 0; i < bottom; i++) {
    video_scale_orc_splat_u16 ((uint16_t *) data, v, real_width);
    data += stride;
  }
}

void
vs_fill_borders_RGB555 (const VSImage * dest, const uint8_t * val)
{
  int i;
  int top = dest->border_top, bottom = dest->border_bottom;
  int left = dest->border_left, right = dest->border_right;
  int width = dest->width;
  int height = dest->height;
  int real_width = dest->real_width;
  gsize stride = dest->stride;
  int tmp, tmp2;
  uint8_t *data;
  uint16_t v = READ_UINT16 (val);

  data = dest->real_pixels;
  for (i = 0; i < top; i++) {
    video_scale_orc_splat_u16 ((uint16_t *) data, v, real_width);
    data += stride;
  }

  if (left || right) {
    tmp = height;
    tmp2 = (left + width) * 2;
    for (i = 0; i < tmp; i++) {
      video_scale_orc_splat_u16 ((uint16_t *) data, v, left);
      video_scale_orc_splat_u16 ((uint16_t *) (data + tmp2), v, right);
      data += stride;
    }
  } else {
    data += stride * height;
  }

  for (i = 0; i < bottom; i++) {
    video_scale_orc_splat_u16 ((uint16_t *) data, v, real_width);
    data += stride;
  }
}

void
vs_fill_borders_AYUV64 (const VSImage * dest, const uint8_t * val)
{
  int i;
  int top = dest->border_top, bottom = dest->border_bottom;
  int left = dest->border_left, right = dest->border_right;
  int width = dest->width;
  int height = dest->height;
  int real_width = dest->real_width;
  gsize stride = dest->stride;
  int tmp, tmp2;
  uint8_t *data;
  uint64_t v;

  v = (((guint32) val[0]) << 8) | (((guint32) val[1]) << 24) |
      (((guint64) val[2]) << 40) | (((guint64) val[3]) << 56);

  data = dest->real_pixels;
  for (i = 0; i < top; i++) {
    video_scale_orc_splat_u64 ((uint64_t *) data, v, real_width);
    data += stride;
  }

  if (left || right) {
    tmp = height;
    tmp2 = (left + width) * 8;
    for (i = 0; i < tmp; i++) {
      video_scale_orc_splat_u64 ((uint64_t *) data, v, left);
      video_scale_orc_splat_u64 ((uint64_t *) (data + tmp2), v, right);
      data += stride;
    }
  } else {
    data += stride * height;
  }

  for (i = 0; i < bottom; i++) {
    video_scale_orc_splat_u64 ((uint64_t *) data, v, real_width);
    data += stride;
  }
}
