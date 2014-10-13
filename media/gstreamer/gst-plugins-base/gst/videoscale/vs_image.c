/*
 * Image Scaling Functions
 * Copyright (c) 2005-2012 David A. Schleef <ds@schleef.org>
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

#include <string.h>

#include "vs_scanline.h"
#include "vs_image.h"

#include "gstvideoscaleorc.h"
#include <gst/gst.h>

#define ROUND_UP_2(x)  (((x)+1)&~1)
#define ROUND_UP_4(x)  (((x)+3)&~3)
#define ROUND_UP_8(x)  (((x)+7)&~7)

void
vs_image_scale_nearest_RGBA (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int acc;
  int y_increment;
  int x_increment;
  int i;
  int j;
  int prev_j;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1);

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1);


  acc = 0;
  prev_j = -1;
  for (i = 0; i < dest->height; i++) {
    j = (acc + 0x8000) >> 16;

    if (j == prev_j) {
      memcpy (dest->pixels + i * dest->stride,
          dest->pixels + (i - 1) * dest->stride, dest->width * 4);
    } else {
      video_scale_orc_resample_nearest_u32 (dest->pixels + i * dest->stride,
          src->pixels + j * src->stride, 0, x_increment, dest->width);
    }

    prev_j = j;
    acc += y_increment;
  }
}

void
vs_image_scale_linear_RGBA (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int acc;
  int y_increment;
  int x_increment;
  int y1;
  int i;
  int j;
  int x;
  int dest_size;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1) - 1;

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1) - 1;

  dest_size = dest->width * 4;

#define LINE(x) ((tmpbuf) + (dest_size)*((x)&1))

  acc = 0;
  video_scale_orc_resample_bilinear_u32 (LINE (0), src->pixels,
      0, x_increment, dest->width);
  y1 = 0;
  for (i = 0; i < dest->height; i++) {
    j = acc >> 16;
    x = acc & 0xffff;

    if (x == 0) {
      memcpy (dest->pixels + i * dest->stride, LINE (j), dest_size);
    } else {
      if (j > y1) {
        video_scale_orc_resample_bilinear_u32 (LINE (j),
            src->pixels + j * src->stride, 0, x_increment, dest->width);
        y1++;
      }
      if (j >= y1) {
        video_scale_orc_resample_bilinear_u32 (LINE (j + 1),
            src->pixels + (j + 1) * src->stride, 0, x_increment, dest->width);
        y1++;
      }
      video_scale_orc_merge_linear_u8 (dest->pixels + i * dest->stride,
          LINE (j), LINE (j + 1), (x >> 8), dest->width * 4);
    }

    acc += y_increment;
  }
}


void
vs_image_scale_nearest_RGB (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int acc;
  int y_increment;
  int x_increment;
  int i;
  int j;
  int xacc;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1);

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1);

  acc = 0;
  for (i = 0; i < dest->height; i++) {
    j = (acc + 0x8000) >> 16;

    xacc = 0;
    vs_scanline_resample_nearest_RGB (dest->pixels + i * dest->stride,
        src->pixels + j * src->stride, src->width, dest->width, &xacc,
        x_increment);

    acc += y_increment;
  }
}

void
vs_image_scale_linear_RGB (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int acc;
  int y_increment;
  int x_increment;
  uint8_t *tmp1;
  uint8_t *tmp2;
  int y1;
  int y2;
  int i;
  int j;
  int x;
  int dest_size;
  int xacc;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1) - 1;

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1) - 1;

  dest_size = dest->width * 3;

  tmp1 = tmpbuf;
  tmp2 = tmpbuf + dest_size;

  acc = 0;
  xacc = 0;
  y2 = -1;
  vs_scanline_resample_linear_RGB (tmp1, src->pixels, src->width, dest->width,
      &xacc, x_increment);
  y1 = 0;
  for (i = 0; i < dest->height; i++) {
    j = acc >> 16;
    x = acc & 0xffff;

    if (x == 0) {
      if (j == y1) {
        memcpy (dest->pixels + i * dest->stride, tmp1, dest_size);
      } else if (j == y2) {
        memcpy (dest->pixels + i * dest->stride, tmp2, dest_size);
      } else {
        xacc = 0;
        vs_scanline_resample_linear_RGB (tmp1, src->pixels + j * src->stride,
            src->width, dest->width, &xacc, x_increment);
        y1 = j;
        memcpy (dest->pixels + i * dest->stride, tmp1, dest_size);
      }
    } else {
      if (j == y1) {
        if (j + 1 != y2) {
          xacc = 0;
          vs_scanline_resample_linear_RGB (tmp2,
              src->pixels + (j + 1) * src->stride, src->width, dest->width,
              &xacc, x_increment);
          y2 = j + 1;
        }
        vs_scanline_merge_linear_RGB (dest->pixels + i * dest->stride,
            tmp1, tmp2, dest->width, x);
      } else if (j == y2) {
        if (j + 1 != y1) {
          xacc = 0;
          vs_scanline_resample_linear_RGB (tmp1,
              src->pixels + (j + 1) * src->stride, src->width, dest->width,
              &xacc, x_increment);
          y1 = j + 1;
        }
        vs_scanline_merge_linear_RGB (dest->pixels + i * dest->stride,
            tmp2, tmp1, dest->width, x);
      } else {
        xacc = 0;
        vs_scanline_resample_linear_RGB (tmp1, src->pixels + j * src->stride,
            src->width, dest->width, &xacc, x_increment);
        y1 = j;
        xacc = 0;
        vs_scanline_resample_linear_RGB (tmp2,
            src->pixels + (j + 1) * src->stride, src->width, dest->width, &xacc,
            x_increment);
        y2 = (j + 1);
        vs_scanline_merge_linear_RGB (dest->pixels + i * dest->stride,
            tmp1, tmp2, dest->width, x);
      }
    }

    acc += y_increment;
  }
}

/* YUYV */

void
vs_image_scale_nearest_YUYV (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int acc;
  int y_increment;
  int x_increment;
  int i;
  int j;
  int xacc;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1);

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1);

  acc = 0;
  for (i = 0; i < dest->height; i++) {
    j = (acc + 0x8000) >> 16;

    xacc = 0;
    vs_scanline_resample_nearest_YUYV (dest->pixels + i * dest->stride,
        src->pixels + j * src->stride, src->width, dest->width, &xacc,
        x_increment);

    acc += y_increment;
  }
}

void
vs_image_scale_linear_YUYV (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int acc;
  int y_increment;
  int x_increment;
  uint8_t *tmp1;
  uint8_t *tmp2;
  int y1;
  int y2;
  int i;
  int j;
  int x;
  int dest_size;
  int xacc;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1) - 1;

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1) - 1;

  dest_size = ROUND_UP_4 (dest->width * 2);

  tmp1 = tmpbuf;
  tmp2 = tmpbuf + dest_size;

  acc = 0;
  xacc = 0;
  y2 = -1;
  vs_scanline_resample_linear_YUYV (tmp1, src->pixels, src->width, dest->width,
      &xacc, x_increment);
  y1 = 0;
  for (i = 0; i < dest->height; i++) {
    j = acc >> 16;
    x = acc & 0xffff;

    if (x == 0) {
      if (j == y1) {
        memcpy (dest->pixels + i * dest->stride, tmp1, dest_size);
      } else if (j == y2) {
        memcpy (dest->pixels + i * dest->stride, tmp2, dest_size);
      } else {
        xacc = 0;
        vs_scanline_resample_linear_YUYV (tmp1, src->pixels + j * src->stride,
            src->width, dest->width, &xacc, x_increment);
        y1 = j;
        memcpy (dest->pixels + i * dest->stride, tmp1, dest_size);
      }
    } else {
      if (j == y1) {
        if (j + 1 != y2) {
          xacc = 0;
          vs_scanline_resample_linear_YUYV (tmp2,
              src->pixels + (j + 1) * src->stride, src->width, dest->width,
              &xacc, x_increment);
          y2 = j + 1;
        }
        vs_scanline_merge_linear_YUYV (dest->pixels + i * dest->stride,
            tmp1, tmp2, dest->width, x);
      } else if (j == y2) {
        if (j + 1 != y1) {
          xacc = 0;
          vs_scanline_resample_linear_YUYV (tmp1,
              src->pixels + (j + 1) * src->stride, src->width, dest->width,
              &xacc, x_increment);
          y1 = j + 1;
        }
        vs_scanline_merge_linear_YUYV (dest->pixels + i * dest->stride,
            tmp2, tmp1, dest->width, x);
      } else {
        xacc = 0;
        vs_scanline_resample_linear_YUYV (tmp1, src->pixels + j * src->stride,
            src->width, dest->width, &xacc, x_increment);
        y1 = j;
        xacc = 0;
        vs_scanline_resample_linear_YUYV (tmp2,
            src->pixels + (j + 1) * src->stride, src->width, dest->width,
            &xacc, x_increment);
        y2 = (j + 1);
        vs_scanline_merge_linear_YUYV (dest->pixels + i * dest->stride,
            tmp1, tmp2, dest->width, x);
      }
    }

    acc += y_increment;
  }
}

/* UYVY */

void
vs_image_scale_nearest_UYVY (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int acc;
  int y_increment;
  int x_increment;
  int i;
  int j;
  int xacc;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1);

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1);

  acc = 0;
  for (i = 0; i < dest->height; i++) {
    j = (acc + 0x8000) >> 16;

    xacc = 0;
    vs_scanline_resample_nearest_UYVY (dest->pixels + i * dest->stride,
        src->pixels + j * src->stride, src->width, dest->width, &xacc,
        x_increment);

    acc += y_increment;
  }
}

void
vs_image_scale_linear_UYVY (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int acc;
  int y_increment;
  int x_increment;
  uint8_t *tmp1;
  uint8_t *tmp2;
  int y1;
  int y2;
  int i;
  int j;
  int x;
  int dest_size;
  int xacc;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1) - 1;

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1) - 1;

  dest_size = ROUND_UP_4 (dest->width * 2);

  tmp1 = tmpbuf;
  tmp2 = tmpbuf + dest_size;

  acc = 0;
  xacc = 0;
  y2 = -1;
  vs_scanline_resample_linear_UYVY (tmp1, src->pixels, src->width, dest->width,
      &xacc, x_increment);
  y1 = 0;
  for (i = 0; i < dest->height; i++) {
    j = acc >> 16;
    x = acc & 0xffff;

    if (x == 0) {
      if (j == y1) {
        memcpy (dest->pixels + i * dest->stride, tmp1, dest_size);
      } else if (j == y2) {
        memcpy (dest->pixels + i * dest->stride, tmp2, dest_size);
      } else {
        xacc = 0;
        vs_scanline_resample_linear_UYVY (tmp1, src->pixels + j * src->stride,
            src->width, dest->width, &xacc, x_increment);
        y1 = j;
        memcpy (dest->pixels + i * dest->stride, tmp1, dest_size);
      }
    } else {
      if (j == y1) {
        if (j + 1 != y2) {
          xacc = 0;
          vs_scanline_resample_linear_UYVY (tmp2,
              src->pixels + (j + 1) * src->stride, src->width, dest->width,
              &xacc, x_increment);
          y2 = j + 1;
        }
        vs_scanline_merge_linear_UYVY (dest->pixels + i * dest->stride,
            tmp1, tmp2, dest->width, x);
      } else if (j == y2) {
        if (j + 1 != y1) {
          xacc = 0;
          vs_scanline_resample_linear_UYVY (tmp1,
              src->pixels + (j + 1) * src->stride, src->width, dest->width,
              &xacc, x_increment);
          y1 = j + 1;
        }
        vs_scanline_merge_linear_UYVY (dest->pixels + i * dest->stride,
            tmp2, tmp1, dest->width, x);
      } else {
        xacc = 0;
        vs_scanline_resample_linear_UYVY (tmp1, src->pixels + j * src->stride,
            src->width, dest->width, &xacc, x_increment);
        y1 = j;
        xacc = 0;
        vs_scanline_resample_linear_UYVY (tmp2,
            src->pixels + (j + 1) * src->stride, src->width, dest->width,
            &xacc, x_increment);
        y2 = (j + 1);
        vs_scanline_merge_linear_UYVY (dest->pixels + i * dest->stride,
            tmp1, tmp2, dest->width, x);
      }
    }

    acc += y_increment;
  }
}

/* NV12 */

void
vs_image_scale_nearest_NV12 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int acc;
  int y_increment;
  int x_increment;
  int i;
  int j;
  int xacc;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1);

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1);

  acc = 0;
  for (i = 0; i < dest->height; i++) {
    j = (acc + 0x8000) >> 16;

    xacc = 0;
    vs_scanline_resample_nearest_NV12 (dest->pixels + i * dest->stride,
        src->pixels + j * src->stride, src->width, dest->width, &xacc,
        x_increment);

    acc += y_increment;
  }
}

void
vs_image_scale_linear_NV12 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int acc;
  int y_increment;
  int x_increment;
  uint8_t *tmp1;
  uint8_t *tmp2;
  int y1;
  int y2;
  int i;
  int j;
  int x;
  int dest_size;
  int xacc;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1) - 1;

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1) - 1;

  dest_size = ROUND_UP_4 (dest->width * 2);

  tmp1 = tmpbuf;
  tmp2 = tmpbuf + dest_size;

  acc = 0;
  xacc = 0;
  y2 = -1;
  vs_scanline_resample_linear_NV12 (tmp1, src->pixels, src->width, dest->width,
      &xacc, x_increment);
  y1 = 0;
  for (i = 0; i < dest->height; i++) {
    j = acc >> 16;
    x = acc & 0xffff;

    if (x == 0) {
      if (j == y1) {
        memcpy (dest->pixels + i * dest->stride, tmp1, dest_size);
      } else if (j == y2) {
        memcpy (dest->pixels + i * dest->stride, tmp2, dest_size);
      } else {
        xacc = 0;
        vs_scanline_resample_linear_NV12 (tmp1, src->pixels + j * src->stride,
            src->width, dest->width, &xacc, x_increment);
        y1 = j;
        memcpy (dest->pixels + i * dest->stride, tmp1, dest_size);
      }
    } else {
      if (j == y1) {
        if (j + 1 != y2) {
          xacc = 0;
          vs_scanline_resample_linear_NV12 (tmp2,
              src->pixels + (j + 1) * src->stride, src->width, dest->width,
              &xacc, x_increment);
          y2 = j + 1;
        }
        vs_scanline_merge_linear_NV12 (dest->pixels + i * dest->stride,
            tmp1, tmp2, dest->width, x);
      } else if (j == y2) {
        if (j + 1 != y1) {
          xacc = 0;
          vs_scanline_resample_linear_NV12 (tmp1,
              src->pixels + (j + 1) * src->stride, src->width, dest->width,
              &xacc, x_increment);
          y1 = j + 1;
        }
        vs_scanline_merge_linear_NV12 (dest->pixels + i * dest->stride,
            tmp2, tmp1, dest->width, x);
      } else {
        xacc = 0;
        vs_scanline_resample_linear_NV12 (tmp1, src->pixels + j * src->stride,
            src->width, dest->width, &xacc, x_increment);
        y1 = j;
        xacc = 0;
        vs_scanline_resample_linear_NV12 (tmp2,
            src->pixels + (j + 1) * src->stride, src->width, dest->width,
            &xacc, x_increment);
        y2 = (j + 1);
        vs_scanline_merge_linear_NV12 (dest->pixels + i * dest->stride,
            tmp1, tmp2, dest->width, x);
      }
    }

    acc += y_increment;
  }
}

/* greyscale */

void
vs_image_scale_nearest_Y (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int acc;
  int y_increment;
  int x_increment;
  int i;
  int j;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1);

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1);

  acc = 0;
  for (i = 0; i < dest->height; i++) {
    j = (acc + 0x8000) >> 16;

    video_scale_orc_resample_nearest_u8 (dest->pixels + i * dest->stride,
        src->pixels + j * src->stride, 0, x_increment, dest->width);
    acc += y_increment;
  }
}

void
vs_image_scale_linear_Y (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int acc;
  int y_increment;
  int x_increment;
  uint8_t *tmp1;
  uint8_t *tmp2;
  int y1;
  int y2;
  int i;
  int j;
  int x;
  int dest_size;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1) - 1;

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1) - 1;

  dest_size = dest->width;

  tmp1 = tmpbuf;
  tmp2 = tmpbuf + dest_size;

  acc = 0;
  y2 = -1;
  video_scale_orc_resample_bilinear_u8 (tmp1, src->pixels,
      0, x_increment, dest->width);
  y1 = 0;
  for (i = 0; i < dest->height; i++) {
    j = acc >> 16;
    x = acc & 0xffff;

    if (x == 0) {
      if (j == y1) {
        memcpy (dest->pixels + i * dest->stride, tmp1, dest_size);
      } else if (j == y2) {
        memcpy (dest->pixels + i * dest->stride, tmp2, dest_size);
      } else {
        video_scale_orc_resample_bilinear_u8 (tmp1,
            src->pixels + j * src->stride, 0, x_increment, dest->width);
        y1 = j;
        memcpy (dest->pixels + i * dest->stride, tmp1, dest_size);
      }
    } else {
      if (j == y1) {
        if (j + 1 != y2) {
          video_scale_orc_resample_bilinear_u8 (tmp2,
              src->pixels + (j + 1) * src->stride, 0, x_increment, dest->width);
          y2 = j + 1;
        }
        if ((x >> 8) == 0) {
          memcpy (dest->pixels + i * dest->stride, tmp1, dest->width);
        } else {
          video_scale_orc_merge_linear_u8 (dest->pixels + i * dest->stride,
              tmp1, tmp2, (x >> 8), dest->width);
        }
      } else if (j == y2) {
        if (j + 1 != y1) {
          video_scale_orc_resample_bilinear_u8 (tmp1,
              src->pixels + (j + 1) * src->stride, 0, x_increment, dest->width);
          y1 = j + 1;
        }
        if ((x >> 8) == 0) {
          memcpy (dest->pixels + i * dest->stride, tmp2, dest->width);
        } else {
          video_scale_orc_merge_linear_u8 (dest->pixels + i * dest->stride,
              tmp2, tmp1, (x >> 8), dest->width);
        }
      } else {
        video_scale_orc_resample_bilinear_u8 (tmp1,
            src->pixels + j * src->stride, 0, x_increment, dest->width);
        y1 = j;
        video_scale_orc_resample_bilinear_u8 (tmp2,
            src->pixels + (j + 1) * src->stride, 0, x_increment, dest->width);
        y2 = (j + 1);
        if ((x >> 8) == 0) {
          memcpy (dest->pixels + i * dest->stride, tmp1, dest->width);
        } else {
          video_scale_orc_merge_linear_u8 (dest->pixels + i * dest->stride,
              tmp1, tmp2, (x >> 8), dest->width);
        }
      }
    }

    acc += y_increment;
  }
}

void
vs_image_scale_nearest_Y16 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int acc;
  int y_increment;
  int x_increment;
  int i;
  int j;
  int xacc;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1);

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1);

  acc = 0;
  for (i = 0; i < dest->height; i++) {
    j = (acc + 0x8000) >> 16;

    xacc = 0;
    vs_scanline_resample_nearest_Y16 (dest->pixels + i * dest->stride,
        src->pixels + j * src->stride, src->width, dest->width, &xacc,
        x_increment);

    acc += y_increment;
  }
}

void
vs_image_scale_linear_Y16 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int acc;
  int y_increment;
  int x_increment;
  uint8_t *tmp1;
  uint8_t *tmp2;
  int y1;
  int y2;
  int i;
  int j;
  int x;
  int dest_size;
  int xacc;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1) - 1;

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1) - 1;

  dest_size = 2 * dest->width;

  tmp1 = tmpbuf;
  tmp2 = tmpbuf + dest_size;

  acc = 0;
  xacc = 0;
  y2 = -1;
  vs_scanline_resample_linear_Y16 (tmp1, src->pixels, src->width, dest->width,
      &xacc, x_increment);
  y1 = 0;
  for (i = 0; i < dest->height; i++) {
    j = acc >> 16;
    x = acc & 0xffff;

    if (x == 0) {
      if (j == y1) {
        memcpy (dest->pixels + i * dest->stride, tmp1, dest_size);
      } else if (j == y2) {
        memcpy (dest->pixels + i * dest->stride, tmp2, dest_size);
      } else {
        xacc = 0;
        vs_scanline_resample_linear_Y16 (tmp1, src->pixels + j * src->stride,
            src->width, dest->width, &xacc, x_increment);
        y1 = j;
        memcpy (dest->pixels + i * dest->stride, tmp1, dest_size);
      }
    } else {
      if (j == y1) {
        if (j + 1 != y2) {
          xacc = 0;
          vs_scanline_resample_linear_Y16 (tmp2,
              src->pixels + (j + 1) * src->stride, src->width, dest->width,
              &xacc, x_increment);
          y2 = j + 1;
        }
        vs_scanline_merge_linear_Y16 (dest->pixels + i * dest->stride,
            tmp1, tmp2, dest->width, x);
      } else if (j == y2) {
        if (j + 1 != y1) {
          xacc = 0;
          vs_scanline_resample_linear_Y16 (tmp1,
              src->pixels + (j + 1) * src->stride, src->width, dest->width,
              &xacc, x_increment);
          y1 = j + 1;
        }
        vs_scanline_merge_linear_Y16 (dest->pixels + i * dest->stride,
            tmp2, tmp1, dest->width, x);
      } else {
        xacc = 0;
        vs_scanline_resample_linear_Y16 (tmp1, src->pixels + j * src->stride,
            src->width, dest->width, &xacc, x_increment);
        y1 = j;
        xacc = 0;
        vs_scanline_resample_linear_Y16 (tmp2,
            src->pixels + (j + 1) * src->stride, src->width, dest->width, &xacc,
            x_increment);
        y2 = (j + 1);
        vs_scanline_merge_linear_Y16 (dest->pixels + i * dest->stride,
            tmp1, tmp2, dest->width, x);
      }
    }

    acc += y_increment;
  }
}

/* RGB565 */

void
vs_image_scale_nearest_RGB565 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int acc;
  int y_increment;
  int x_increment;
  int i;
  int j;
  int xacc;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1);

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1);

  acc = 0;
  for (i = 0; i < dest->height; i++) {
    j = (acc + 0x8000) >> 16;

    xacc = 0;
    vs_scanline_resample_nearest_RGB565 (dest->pixels + i * dest->stride,
        src->pixels + j * src->stride, src->width, dest->width, &xacc,
        x_increment);

    acc += y_increment;
  }
}

void
vs_image_scale_linear_RGB565 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int acc;
  int y_increment;
  int x_increment;
  uint8_t *tmp1;
  uint8_t *tmp2;
  int y1;
  int y2;
  int i;
  int j;
  int x;
  int dest_size;
  int xacc;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1) - 1;

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1) - 1;

  dest_size = dest->width * 2;

  tmp1 = tmpbuf;
  tmp2 = tmpbuf + dest_size;

  acc = 0;
  xacc = 0;
  y2 = -1;
  vs_scanline_resample_linear_RGB565 (tmp1, src->pixels, src->width,
      dest->width, &xacc, x_increment);
  y1 = 0;
  for (i = 0; i < dest->height; i++) {
    j = acc >> 16;
    x = acc & 0xffff;

    if (x == 0) {
      if (j == y1) {
        memcpy (dest->pixels + i * dest->stride, tmp1, dest_size);
      } else if (j == y2) {
        memcpy (dest->pixels + i * dest->stride, tmp2, dest_size);
      } else {
        xacc = 0;
        vs_scanline_resample_linear_RGB565 (tmp1, src->pixels + j * src->stride,
            src->width, dest->width, &xacc, x_increment);
        y1 = j;
        memcpy (dest->pixels + i * dest->stride, tmp1, dest_size);
      }
    } else {
      if (j == y1) {
        if (j + 1 != y2) {
          xacc = 0;
          vs_scanline_resample_linear_RGB565 (tmp2,
              src->pixels + (j + 1) * src->stride, src->width, dest->width,
              &xacc, x_increment);
          y2 = j + 1;
        }
        vs_scanline_merge_linear_RGB565 (dest->pixels + i * dest->stride,
            tmp1, tmp2, dest->width, x);
      } else if (j == y2) {
        if (j + 1 != y1) {
          xacc = 0;
          vs_scanline_resample_linear_RGB565 (tmp1,
              src->pixels + (j + 1) * src->stride, src->width, dest->width,
              &xacc, x_increment);
          y1 = j + 1;
        }
        vs_scanline_merge_linear_RGB565 (dest->pixels + i * dest->stride,
            tmp2, tmp1, dest->width, x);
      } else {
        xacc = 0;
        vs_scanline_resample_linear_RGB565 (tmp1, src->pixels + j * src->stride,
            src->width, dest->width, &xacc, x_increment);
        y1 = j;
        xacc = 0;
        vs_scanline_resample_linear_RGB565 (tmp2,
            src->pixels + (j + 1) * src->stride, src->width, dest->width, &xacc,
            x_increment);
        y2 = (j + 1);
        vs_scanline_merge_linear_RGB565 (dest->pixels + i * dest->stride,
            tmp1, tmp2, dest->width, x);
      }
    }

    acc += y_increment;
  }
}

/* RGB555 */

void
vs_image_scale_nearest_RGB555 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int acc;
  int y_increment;
  int x_increment;
  int i;
  int j;
  int xacc;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1);

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1);

  acc = 0;
  for (i = 0; i < dest->height; i++) {
    j = (acc + 0x8000) >> 16;

    xacc = 0;
    vs_scanline_resample_nearest_RGB555 (dest->pixels + i * dest->stride,
        src->pixels + j * src->stride, src->width, dest->width, &xacc,
        x_increment);

    acc += y_increment;
  }
}

void
vs_image_scale_linear_RGB555 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int acc;
  int y_increment;
  int x_increment;
  uint8_t *tmp1;
  uint8_t *tmp2;
  int y1;
  int y2;
  int i;
  int j;
  int x;
  int dest_size;
  int xacc;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1) - 1;

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1) - 1;

  dest_size = dest->width * 2;

  tmp1 = tmpbuf;
  tmp2 = tmpbuf + dest_size;

  acc = 0;
  xacc = 0;
  y2 = -1;
  vs_scanline_resample_linear_RGB555 (tmp1, src->pixels, src->width,
      dest->width, &xacc, x_increment);
  y1 = 0;
  for (i = 0; i < dest->height; i++) {
    j = acc >> 16;
    x = acc & 0xffff;

    if (x == 0) {
      if (j == y1) {
        memcpy (dest->pixels + i * dest->stride, tmp1, dest_size);
      } else if (j == y2) {
        memcpy (dest->pixels + i * dest->stride, tmp2, dest_size);
      } else {
        xacc = 0;
        vs_scanline_resample_linear_RGB555 (tmp1, src->pixels + j * src->stride,
            src->width, dest->width, &xacc, x_increment);
        y1 = j;
        memcpy (dest->pixels + i * dest->stride, tmp1, dest_size);
      }
    } else {
      if (j == y1) {
        if (j + 1 != y2) {
          xacc = 0;
          vs_scanline_resample_linear_RGB555 (tmp2,
              src->pixels + (j + 1) * src->stride, src->width, dest->width,
              &xacc, x_increment);
          y2 = j + 1;
        }
        vs_scanline_merge_linear_RGB555 (dest->pixels + i * dest->stride,
            tmp1, tmp2, dest->width, x);
      } else if (j == y2) {
        if (j + 1 != y1) {
          xacc = 0;
          vs_scanline_resample_linear_RGB555 (tmp1,
              src->pixels + (j + 1) * src->stride, src->width, dest->width,
              &xacc, x_increment);
          y1 = j + 1;
        }
        vs_scanline_merge_linear_RGB555 (dest->pixels + i * dest->stride,
            tmp2, tmp1, dest->width, x);
      } else {
        xacc = 0;
        vs_scanline_resample_linear_RGB555 (tmp1, src->pixels + j * src->stride,
            src->width, dest->width, &xacc, x_increment);
        y1 = j;
        xacc = 0;
        vs_scanline_resample_linear_RGB555 (tmp2,
            src->pixels + (j + 1) * src->stride, src->width, dest->width, &xacc,
            x_increment);
        y2 = (j + 1);
        vs_scanline_merge_linear_RGB555 (dest->pixels + i * dest->stride,
            tmp1, tmp2, dest->width, x);
      }
    }

    acc += y_increment;
  }
}

void
vs_image_scale_nearest_AYUV64 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf8)
{
  int acc;
  int y_increment;
  int x_increment;
  int i;
  int j;
  int prev_j;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1);

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1);


  acc = 0;
  prev_j = -1;
  for (i = 0; i < dest->height; i++) {
    j = (acc + 0x8000) >> 16;

    if (j == prev_j) {
      memcpy (dest->pixels + i * dest->stride,
          dest->pixels + (i - 1) * dest->stride, dest->width * 8);
    } else {
      int xacc = 0;
      vs_scanline_resample_nearest_AYUV64 (dest->pixels + i * dest->stride,
          src->pixels + j * src->stride, src->width, dest->width, &xacc,
          x_increment);
    }

    prev_j = j;
    acc += y_increment;
  }
}

void
vs_image_scale_linear_AYUV64 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int acc;
  int y_increment;
  int x_increment;
  int y1;
  int i;
  int j;
  int x;
  int dest_size;
  int xacc;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1) - 1;

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1) - 1;

  dest_size = dest->width * 8;

#undef LINE
#define LINE(x) ((guint16 *)((tmpbuf) + (dest_size)*((x)&1)))

  acc = 0;
  xacc = 0;
  vs_scanline_resample_linear_AYUV64 ((guint8 *) LINE (0),
      src->pixels, src->width, dest->width, &xacc, x_increment);
  y1 = 0;
  for (i = 0; i < dest->height; i++) {
    j = acc >> 16;
    x = acc & 0xffff;

    if (x == 0) {
      memcpy (dest->pixels + i * dest->stride, LINE (j), dest_size);
    } else {
      if (j > y1) {
        xacc = 0;
        vs_scanline_resample_linear_AYUV64 ((guint8 *) LINE (j),
            src->pixels + j * src->stride, src->width, dest->width, &xacc,
            x_increment);
        y1++;
      }
      if (j >= y1) {
        xacc = 0;
        vs_scanline_resample_linear_AYUV64 ((guint8 *) LINE (j + 1),
            src->pixels + (j + 1) * src->stride, src->width, dest->width, &xacc,
            x_increment);
        video_scale_orc_merge_linear_u16 ((guint16 *) (dest->pixels +
                i * dest->stride), LINE (j), LINE (j + 1), 65536 - x, x,
            dest->width * 4);
        y1++;
      } else {
        video_scale_orc_merge_linear_u16 ((guint16 *) (dest->pixels +
                i * dest->stride), LINE (j), LINE (j + 1), 65536 - x, x,
            dest->width * 4);
      }
    }

    acc += y_increment;
  }
}
