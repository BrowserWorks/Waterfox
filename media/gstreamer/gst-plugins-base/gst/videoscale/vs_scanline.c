/*
 * Image Scaling Functions
 * Copyright (c) 2005 David A. Schleef <ds@schleef.org>
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

#include "vs_scanline.h"

#include "gstvideoscaleorc.h"
#include <gst/gst.h>

#include <string.h>

/* greyscale, i.e., single componenet */

#define BLEND(a,b,x) (((a) * (65536 - (x)) + (b) * (x)) >> 16)
#define BLEND15(a,b,x) (((a) * (32768 - (x)) + (b) * (x)) >> 15)

void
vs_scanline_downsample_Y (uint8_t * dest, uint8_t * src, int n)
{
  video_scale_orc_downsample_u8 (dest, src, n);
}

void
vs_scanline_resample_nearest_Y (uint8_t * dest, uint8_t * src, int src_width,
    int n, int *accumulator, int increment)
{
  video_scale_orc_resample_nearest_u8 (dest, src, *accumulator, increment, n);

  *accumulator += n * increment;
}

#include <glib.h>
void
vs_scanline_resample_linear_Y (uint8_t * dest, uint8_t * src, int src_width,
    int n, int *accumulator, int increment)
{
  video_scale_orc_resample_bilinear_u8 (dest, src, *accumulator, increment, n);

  *accumulator += n * increment;
}

void
vs_scanline_merge_linear_Y (uint8_t * dest, uint8_t * src1, uint8_t * src2,
    int n, int x)
{
  uint32_t value = x >> 8;

  if (value == 0) {
    memcpy (dest, src1, n);
  } else {
    video_scale_orc_merge_linear_u8 (dest, src1, src2, value, n);
  }
}

void
vs_scanline_downsample_Y16 (uint8_t * dest, uint8_t * src, int n)
{
  video_scale_orc_downsample_u16 ((uint16_t *) dest, (uint16_t *) src, n);
}

void
vs_scanline_resample_nearest_Y16 (uint8_t * dest, uint8_t * src, int src_width,
    int n, int *accumulator, int increment)
{
  int acc = *accumulator;
  int i, j;
  uint16_t *d = (uint16_t *) dest, *s = (uint16_t *) src;

  for (i = 0; i < n; i++) {
    j = (acc + 0x8000) >> 16;
    d[i] = s[j];

    acc += increment;
  }

  *accumulator = acc;
}

void
vs_scanline_resample_linear_Y16 (uint8_t * dest, uint8_t * src, int src_width,
    int n, int *accumulator, int increment)
{
  int acc = *accumulator;
  int i;
  int j;
  int x;
  uint16_t *d = (uint16_t *) dest, *s = (uint16_t *) src;

  for (i = 0; i < n; i++) {
    j = acc >> 16;

    if (j + 1 < src_width) {
      x = acc & 0xffff;
      d[i] = BLEND (s[j], s[j + 1], x);
    } else
      d[i] = s[j];

    acc += increment;
  }
  *accumulator = acc;
}

void
vs_scanline_merge_linear_Y16 (uint8_t * dest, uint8_t * src1, uint8_t * src2,
    int n, int x)
{
  uint16_t *d = (uint16_t *) dest;
  const uint16_t *s1 = (const uint16_t *) src1;
  const uint16_t *s2 = (const uint16_t *) src2;

  if (x == 0) {
    memcpy (d, s1, n * 2);
  } else {
    video_scale_orc_merge_linear_u16 (d, s1, s2, 65536 - x, x, n);
  }
}

/* RGBA */

void
vs_scanline_downsample_RGBA (uint8_t * dest, uint8_t * src, int n)
{
  video_scale_orc_downsample_u32 (dest, src, n);
}

void
vs_scanline_resample_nearest_RGBA (uint8_t * dest, uint8_t * src, int src_width,
    int n, int *accumulator, int increment)
{
  video_scale_orc_resample_nearest_u32 (dest, src, *accumulator, increment, n);

  *accumulator += n * increment;
}

void
vs_scanline_resample_linear_RGBA (uint8_t * dest, uint8_t * src, int src_width,
    int n, int *accumulator, int increment)
{
  video_scale_orc_resample_bilinear_u32 (dest, src, *accumulator, increment, n);

  *accumulator += n * increment;
}

void
vs_scanline_merge_linear_RGBA (uint8_t * dest, uint8_t * src1, uint8_t * src2,
    int n, int x)
{
  uint32_t value = x >> 8;

  if (value == 0) {
    memcpy (dest, src1, n * 4);
  } else {
    video_scale_orc_merge_linear_u8 (dest, src1, src2, value, n * 4);
  }
}


/* RGB */

void
vs_scanline_downsample_RGB (uint8_t * dest, uint8_t * src, int n)
{
  int i;

  for (i = 0; i < n; i++) {
    dest[i * 3 + 0] = (src[i * 6 + 0] + src[i * 6 + 3]) / 2;
    dest[i * 3 + 1] = (src[i * 6 + 1] + src[i * 6 + 4]) / 2;
    dest[i * 3 + 2] = (src[i * 6 + 2] + src[i * 6 + 5]) / 2;
  }
}

void
vs_scanline_resample_nearest_RGB (uint8_t * dest, uint8_t * src, int src_width,
    int n, int *accumulator, int increment)
{
  int acc = *accumulator;
  int i;
  int j;

  for (i = 0; i < n; i++) {
    j = (acc + 0x8000) >> 16;

    dest[i * 3 + 0] = src[j * 3 + 0];
    dest[i * 3 + 1] = src[j * 3 + 1];
    dest[i * 3 + 2] = src[j * 3 + 2];

    acc += increment;
  }

  *accumulator = acc;
}

void
vs_scanline_resample_linear_RGB (uint8_t * dest, uint8_t * src, int src_width,
    int n, int *accumulator, int increment)
{
  int acc = *accumulator;
  int i;
  int j;
  int x;

  for (i = 0; i < n; i++) {
    j = acc >> 16;

    if (j + 1 < src_width) {
      x = acc & 0xffff;
      dest[i * 3 + 0] = BLEND (src[j * 3 + 0], src[j * 3 + 3], x);
      dest[i * 3 + 1] = BLEND (src[j * 3 + 1], src[j * 3 + 4], x);
      dest[i * 3 + 2] = BLEND (src[j * 3 + 2], src[j * 3 + 5], x);
    } else {
      dest[i * 3 + 0] = src[j * 3 + 0];
      dest[i * 3 + 1] = src[j * 3 + 1];
      dest[i * 3 + 2] = src[j * 3 + 2];
    }
    acc += increment;
  }

  *accumulator = acc;
}

void
vs_scanline_merge_linear_RGB (uint8_t * dest, uint8_t * src1, uint8_t * src2,
    int n, int x)
{
  uint32_t value = x >> 8;

  if (value == 0) {
    memcpy (dest, src1, n * 3);
  } else {
    video_scale_orc_merge_linear_u8 (dest, src1, src2, value, n * 3);
  }
}


/* YUYV */

/* n is the number of pixels */
/* increment is per Y pixel */

void
vs_scanline_downsample_YUYV (uint8_t * dest, uint8_t * src, int n)
{
  video_scale_orc_downsample_yuyv (dest, src, n);
}

void
vs_scanline_resample_nearest_YUYV (uint8_t * dest, uint8_t * src, int src_width,
    int n, int *accumulator, int increment)
{
  int acc = *accumulator;
  int i, j;

  for (i = 0; i < n; i += 2) {
    j = (acc + 0x8000) >> 16;
    dest[i * 2 + 0] = src[j * 2 + 0];

    j >>= 1;
    dest[i * 2 + 1] = src[j * 4 + 1];
    dest[i * 2 + 3] = src[j * 4 + 3];

    acc += increment;

    if (i < n - 1) {
      j = (acc + 0x8000) >> 16;
      dest[i * 2 + 2] = src[j * 2 + 0];

      acc += increment;
    }
  }

  *accumulator = acc;
}

void
vs_scanline_resample_linear_YUYV (uint8_t * dest, uint8_t * src, int src_width,
    int n, int *accumulator, int increment)
{
  int acc = *accumulator;
  int i, j, x;

  for (i = 0; i < n; i += 2) {
    j = acc >> 16;
    x = acc & 0xffff;

    if (j + 1 < src_width)
      dest[i * 2 + 0] = BLEND (src[j * 2 + 0], src[j * 2 + 2], x);
    else
      dest[i * 2 + 0] = src[j * 2 + 0];

    j >>= 1;
    if (2 * (j + 1) < src_width) {
      dest[i * 2 + 1] = BLEND (src[j * 4 + 1], src[j * 4 + 5], x);
      dest[i * 2 + 3] = BLEND (src[j * 4 + 3], src[j * 4 + 7], x);
    } else {
      dest[i * 2 + 1] = src[j * 4 + 1];
      dest[i * 2 + 3] = src[j * 4 + 3];
    }

    acc += increment;

    if (i < n - 1) {
      j = acc >> 16;

      if (j + 1 < src_width) {
        x = acc & 0xffff;
        dest[i * 2 + 2] = BLEND (src[j * 2 + 0], src[j * 2 + 2], x);
      } else
        dest[i * 2 + 2] = src[j * 2 + 0];

      acc += increment;
    }
  }
  *accumulator = acc;
}

void
vs_scanline_merge_linear_YUYV (uint8_t * dest, uint8_t * src1, uint8_t * src2,
    int n, int x)
{
  int quads = (n + 1) / 2;
  uint32_t value = x >> 8;

  if (value == 0) {
    memcpy (dest, src1, quads * 4);
  } else {
    video_scale_orc_merge_linear_u8 (dest, src1, src2, value, quads * 4);
  }
}


/* UYVY */

/* n is the number of bi-pixels */
/* increment is per Y pixel */

void
vs_scanline_downsample_UYVY (uint8_t * dest, uint8_t * src, int n)
{
  int i;

  for (i = 0; i < n; i++) {
    dest[i * 4 + 0] = (src[i * 8 + 0] + src[i * 8 + 4]) / 2;
    dest[i * 4 + 1] = (src[i * 8 + 1] + src[i * 8 + 3]) / 2;
    dest[i * 4 + 2] = (src[i * 8 + 2] + src[i * 8 + 6]) / 2;
    dest[i * 4 + 3] = (src[i * 8 + 5] + src[i * 8 + 7]) / 2;
  }
}

void
vs_scanline_resample_nearest_UYVY (uint8_t * dest, uint8_t * src, int src_width,
    int n, int *accumulator, int increment)
{
  int acc = *accumulator;
  int i, j;

  for (i = 0; i < n; i += 2) {
    j = (acc + 0x8000) >> 16;
    dest[i * 2 + 1] = src[j * 2 + 1];

    j >>= 1;
    dest[i * 2 + 0] = src[j * 4 + 0];
    dest[i * 2 + 2] = src[j * 4 + 2];

    acc += increment;

    if (i < n - 1) {
      j = (acc + 0x8000) >> 16;
      dest[i * 2 + 3] = src[j * 2 + 1];

      acc += increment;
    }
  }

  *accumulator = acc;
}

void
vs_scanline_resample_linear_UYVY (uint8_t * dest, uint8_t * src, int src_width,
    int n, int *accumulator, int increment)
{
  int acc = *accumulator;
  int i, j, x;

  for (i = 0; i < n; i += 2) {
    j = acc >> 16;
    x = acc & 0xffff;

    if (j + 1 < src_width)
      dest[i * 2 + 1] = BLEND (src[j * 2 + 1], src[j * 2 + 3], x);
    else
      dest[i * 2 + 1] = src[j * 2 + 1];

    j >>= 1;
    if (2 * (j + 1) < src_width) {
      dest[i * 2 + 0] = BLEND (src[j * 4 + 0], src[j * 4 + 4], x);
      dest[i * 2 + 2] = BLEND (src[j * 4 + 2], src[j * 4 + 6], x);
    } else {
      dest[i * 2 + 0] = src[j * 4 + 0];
      dest[i * 2 + 2] = src[j * 4 + 2];
    }

    acc += increment;

    if (i < n - 1) {
      j = acc >> 16;

      if (j + 1 < src_width) {
        x = acc & 0xffff;
        dest[i * 2 + 3] = BLEND (src[j * 2 + 1], src[j * 2 + 3], x);
      } else
        dest[i * 2 + 3] = src[j * 2 + 1];

      acc += increment;
    }
  }
}

void
vs_scanline_merge_linear_UYVY (uint8_t * dest, uint8_t * src1,
    uint8_t * src2, int n, int x)
{
  int quads = (n + 1) / 2;
  uint32_t value = x >> 8;

  if (value == 0) {
    memcpy (dest, src1, quads * 4);
  } else {
    video_scale_orc_merge_linear_u8 (dest, src1, src2, value, quads * 4);
  }
}


/* NV12 */

/* n is the number of bi-pixels */

void
vs_scanline_downsample_NV12 (uint8_t * dest, uint8_t * src, int n)
{
  int i;

  for (i = 0; i < n; i++) {
    dest[i * 2 + 0] = (src[i * 4 + 0] + src[i * 4 + 2]) / 2;
    dest[i * 2 + 1] = (src[i * 4 + 1] + src[i * 4 + 3]) / 2;
  }
}

void
vs_scanline_resample_nearest_NV12 (uint8_t * dest, uint8_t * src, int src_width,
    int n, int *accumulator, int increment)
{
  int acc = *accumulator;
  int i, j;

  for (i = 0; i < n; i++) {
    j = (acc + 0x8000) >> 16;

    dest[i * 2 + 0] = src[j * 2 + 0];
    dest[i * 2 + 1] = src[j * 2 + 1];

    acc += increment;
  }

  *accumulator = acc;
}

void
vs_scanline_resample_linear_NV12 (uint8_t * dest, uint8_t * src, int src_width,
    int n, int *accumulator, int increment)
{
  int acc = *accumulator;
  int i;
  int j;
  int x;

  for (i = 0; i < n; i++) {
    j = acc >> 16;

    if (j + 1 < src_width) {
      x = acc & 0xffff;
      dest[i * 2 + 0] = BLEND (src[j * 2 + 0], src[j * 2 + 2], x);
      dest[i * 2 + 1] = BLEND (src[j * 2 + 1], src[j * 2 + 3], x);
    } else {
      dest[i * 2 + 0] = src[j * 2 + 0];
      dest[i * 2 + 1] = src[j * 2 + 1];
    }
    acc += increment;
  }
  *accumulator = acc;
}

void
vs_scanline_merge_linear_NV12 (uint8_t * dest, uint8_t * src1,
    uint8_t * src2, int n, int x)
{
  uint32_t value = x >> 8;

  if (value == 0) {
    memcpy (dest, src1, n * 2);
  } else {
    video_scale_orc_merge_linear_u8 (dest, src1, src2, value, n * 2);
  }
}


/* RGB565 */

/* note that src and dest are uint16_t, and thus endian dependent */

#define RGB565_R(x) (((x)&0xf800)>>8 | ((x)&0xf800)>>13)
#define RGB565_G(x) (((x)&0x07e0)>>3 | ((x)&0x07e0)>>9)
#define RGB565_B(x) (((x)&0x001f)<<3 | ((x)&0x001f)>>2)

#define RGB565(r,g,b) \
  ((((r)<<8)&0xf800) | (((g)<<3)&0x07e0) | (((b)>>3)&0x001f))


void
vs_scanline_downsample_RGB565 (uint8_t * dest_u8, uint8_t * src_u8, int n)
{
  uint16_t *dest = (uint16_t *) dest_u8;
  uint16_t *src = (uint16_t *) src_u8;
  int i;

  for (i = 0; i < n; i++) {
    dest[i] = RGB565 (
        (RGB565_R (src[i * 2]) + RGB565_R (src[i * 2 + 1])) / 2,
        (RGB565_G (src[i * 2]) + RGB565_G (src[i * 2 + 1])) / 2,
        (RGB565_B (src[i * 2]) + RGB565_B (src[i * 2 + 1])) / 2);
  }
}

void
vs_scanline_resample_nearest_RGB565 (uint8_t * dest_u8, uint8_t * src_u8,
    int src_width, int n, int *accumulator, int increment)
{
  uint16_t *dest = (uint16_t *) dest_u8;
  uint16_t *src = (uint16_t *) src_u8;
  int acc = *accumulator;
  int i, j;

  for (i = 0; i < n; i++) {
    j = (acc + 0x8000) >> 16;
    dest[i] = src[j];

    acc += increment;
  }

  *accumulator = acc;
}

void
vs_scanline_resample_linear_RGB565 (uint8_t * dest_u8, uint8_t * src_u8,
    int src_width, int n, int *accumulator, int increment)
{
  uint16_t *dest = (uint16_t *) dest_u8;
  uint16_t *src = (uint16_t *) src_u8;
  int acc = *accumulator;
  int i;
  int j;
  int x;

  for (i = 0; i < n; i++) {
    j = acc >> 16;

    if (j + 1 < src_width) {
      x = acc & 0xffff;
      dest[i] = RGB565 (BLEND (RGB565_R (src[j]), RGB565_R (src[j + 1]), x),
          BLEND (RGB565_G (src[j]), RGB565_G (src[j + 1]), x),
          BLEND (RGB565_B (src[j]), RGB565_B (src[j + 1]), x));
    } else {
      dest[i] = RGB565 (RGB565_R (src[j]),
          RGB565_G (src[j]), RGB565_B (src[j]));
    }

    acc += increment;
  }

  *accumulator = acc;
}

void
vs_scanline_merge_linear_RGB565 (uint8_t * dest_u8, uint8_t * src1_u8,
    uint8_t * src2_u8, int n, int x)
{
  uint16_t *dest = (uint16_t *) dest_u8;
  uint16_t *src1 = (uint16_t *) src1_u8;
  uint16_t *src2 = (uint16_t *) src2_u8;
  int i;

  if (x == 0) {
    memcpy (dest, src1, n * 2);
  } else {
    for (i = 0; i < n; i++) {
      dest[i] = RGB565 (BLEND (RGB565_R (src1[i]), RGB565_R (src2[i]), x),
          BLEND (RGB565_G (src1[i]), RGB565_G (src2[i]), x),
          BLEND (RGB565_B (src1[i]), RGB565_B (src2[i]), x));
    }
  }
}


/* RGB555 */

/* note that src and dest are uint16_t, and thus endian dependent */

#define RGB555_R(x) (((x)&0x7c00)>>7 | ((x)&0x7c00)>>12)
#define RGB555_G(x) (((x)&0x03e0)>>2 | ((x)&0x03e0)>>7)
#define RGB555_B(x) (((x)&0x001f)<<3 | ((x)&0x001f)>>2)

#define RGB555(r,g,b) \
  ((((r)<<7)&0x7c00) | (((g)<<2)&0x03e0) | (((b)>>3)&0x001f))

void
vs_scanline_downsample_RGB555 (uint8_t * dest_u8, uint8_t * src_u8, int n)
{
  uint16_t *dest = (uint16_t *) dest_u8;
  uint16_t *src = (uint16_t *) src_u8;
  int i;

  for (i = 0; i < n; i++) {
    dest[i] = RGB555 (
        (RGB555_R (src[i * 2]) + RGB555_R (src[i * 2 + 1])) / 2,
        (RGB555_G (src[i * 2]) + RGB555_G (src[i * 2 + 1])) / 2,
        (RGB555_B (src[i * 2]) + RGB555_B (src[i * 2 + 1])) / 2);
  }
}

void
vs_scanline_resample_nearest_RGB555 (uint8_t * dest_u8, uint8_t * src_u8,
    int src_width, int n, int *accumulator, int increment)
{
  uint16_t *dest = (uint16_t *) dest_u8;
  uint16_t *src = (uint16_t *) src_u8;
  int acc = *accumulator;
  int i, j;

  for (i = 0; i < n; i++) {
    j = (acc + 0x8000) >> 16;

    dest[i] = src[j];

    acc += increment;
  }

  *accumulator = acc;
}

void
vs_scanline_resample_linear_RGB555 (uint8_t * dest_u8, uint8_t * src_u8,
    int src_width, int n, int *accumulator, int increment)
{
  uint16_t *dest = (uint16_t *) dest_u8;
  uint16_t *src = (uint16_t *) src_u8;
  int acc = *accumulator;
  int i;
  int j;
  int x;

  for (i = 0; i < n; i++) {
    j = acc >> 16;

    if (j + 1 < src_width) {
      x = acc & 0xffff;
      dest[i] = RGB555 (BLEND (RGB555_R (src[j]), RGB555_R (src[j + 1]), x),
          BLEND (RGB555_G (src[j]), RGB555_G (src[j + 1]), x),
          BLEND (RGB555_B (src[j]), RGB555_B (src[j + 1]), x));
    } else {
      dest[i] = RGB555 (RGB555_R (src[j]),
          RGB555_G (src[j]), RGB555_B (src[j]));
    }

    acc += increment;
  }

  *accumulator = acc;
}

void
vs_scanline_merge_linear_RGB555 (uint8_t * dest_u8, uint8_t * src1_u8,
    uint8_t * src2_u8, int n, int x)
{
  uint16_t *dest = (uint16_t *) dest_u8;
  uint16_t *src1 = (uint16_t *) src1_u8;
  uint16_t *src2 = (uint16_t *) src2_u8;
  int i;

  if (x == 0) {
    memcpy (dest, src1, n * 2);
  } else {
    for (i = 0; i < n; i++) {
      dest[i] = RGB555 (BLEND (RGB555_R (src1[i]), RGB555_R (src2[i]), x),
          BLEND (RGB555_G (src1[i]), RGB555_G (src2[i]), x),
          BLEND (RGB555_B (src1[i]), RGB555_B (src2[i]), x));
    }
  }
}

void
vs_scanline_resample_nearest_AYUV64 (uint8_t * dest8, uint8_t * src8,
    int src_width, int n, int *accumulator, int increment)
{
  guint16 *dest = (guint16 *) dest8;
  guint16 *src = (guint16 *) src8;
  int acc = *accumulator;
  int i, j;

  for (i = 0; i < n; i++) {
    j = (acc + 0x8000) >> 16;

    dest[i * 4 + 0] = src[j * 4 + 0];
    dest[i * 4 + 1] = src[j * 4 + 1];
    dest[i * 4 + 2] = src[j * 4 + 2];
    dest[i * 4 + 3] = src[j * 4 + 3];

    acc += increment;
  }

  *accumulator = acc;
}

void
vs_scanline_resample_linear_AYUV64 (uint8_t * dest8, uint8_t * src8,
    int src_width, int n, int *accumulator, int increment)
{
  guint16 *dest = (guint16 *) dest8;
  guint16 *src = (guint16 *) src8;
  int acc = *accumulator;
  int i;
  int j;
  int x;

  for (i = 0; i < n; i++) {
    j = acc >> 16;
    x = (acc & 0xffff) >> 1;

    if (j + 1 < src_width) {
      dest[i * 4 + 0] = BLEND15 (src[j * 4 + 0], src[j * 4 + 4], x);
      dest[i * 4 + 1] = BLEND15 (src[j * 4 + 1], src[j * 4 + 5], x);
      dest[i * 4 + 2] = BLEND15 (src[j * 4 + 2], src[j * 4 + 6], x);
      dest[i * 4 + 3] = BLEND15 (src[j * 4 + 3], src[j * 4 + 7], x);
    } else {
      dest[i * 4 + 0] = src[j * 4 + 0];
      dest[i * 4 + 1] = src[j * 4 + 1];
      dest[i * 4 + 2] = src[j * 4 + 2];
      dest[i * 4 + 3] = src[j * 4 + 3];
    }
    acc += increment;
  }

  *accumulator = acc;
}
