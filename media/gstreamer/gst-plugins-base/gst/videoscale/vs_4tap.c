/*
 * Image Scaling Functions (4 tap)
 * Copyright (c) 2005 David A. Schleef <ds@schleef.org>
 * Copyright (c) 2009 Sebastian Dröge <sebastian.droege@collabora.co.uk>
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

#include "vs_image.h"
#include "vs_scanline.h"

#include "vs_4tap.h"

#include <gst/math-compat.h>

#define SHIFT 10

static int16_t vs_4tap_taps[256][4];


static void vs_scanline_resample_4tap_Y (uint8_t * dest, uint8_t * src,
    int n, int src_width, int *xacc, int increment);
static void vs_scanline_merge_4tap_Y (uint8_t * dest, uint8_t * src1,
    uint8_t * src2, uint8_t * src3, uint8_t * src4, int n, int acc);

static void vs_scanline_resample_4tap_RGBA (uint8_t * dest, uint8_t * src,
    int n, int src_width, int *xacc, int increment);
static void vs_scanline_merge_4tap_RGBA (uint8_t * dest, uint8_t * src1,
    uint8_t * src2, uint8_t * src3, uint8_t * src4, int n, int acc);

static void vs_scanline_resample_4tap_RGB (uint8_t * dest, uint8_t * src,
    int n, int src_width, int *xacc, int increment);
static void vs_scanline_merge_4tap_RGB (uint8_t * dest, uint8_t * src1,
    uint8_t * src2, uint8_t * src3, uint8_t * src4, int n, int acc);

static void vs_scanline_resample_4tap_YUYV (uint8_t * dest, uint8_t * src,
    int n, int src_width, int *xacc, int increment);
static void vs_scanline_merge_4tap_YUYV (uint8_t * dest, uint8_t * src1,
    uint8_t * src2, uint8_t * src3, uint8_t * src4, int n, int acc);

static void vs_scanline_resample_4tap_UYVY (uint8_t * dest, uint8_t * src,
    int n, int src_width, int *xacc, int increment);
static void vs_scanline_merge_4tap_UYVY (uint8_t * dest, uint8_t * src1,
    uint8_t * src2, uint8_t * src3, uint8_t * src4, int n, int acc);

static void vs_scanline_resample_4tap_RGB565 (uint8_t * dest, uint8_t * src,
    int n, int src_width, int *xacc, int increment);
static void vs_scanline_merge_4tap_RGB565 (uint8_t * dest, uint8_t * src1,
    uint8_t * src2, uint8_t * src3, uint8_t * src4, int n, int acc);

static void vs_scanline_resample_4tap_RGB555 (uint8_t * dest, uint8_t * src,
    int n, int src_width, int *xacc, int increment);
static void vs_scanline_merge_4tap_RGB555 (uint8_t * dest, uint8_t * src1,
    uint8_t * src2, uint8_t * src3, uint8_t * src4, int n, int acc);

static void vs_scanline_resample_4tap_Y16 (uint8_t * dest, uint8_t * src,
    int n, int src_width, int *xacc, int increment);
static void vs_scanline_merge_4tap_Y16 (uint8_t * dest, uint8_t * src1,
    uint8_t * src2, uint8_t * src3, uint8_t * src4, int n, int acc);

static void vs_scanline_resample_4tap_AYUV64 (uint16_t * dest, uint16_t * src,
    int n, int src_width, int *xacc, int increment);
static void vs_scanline_merge_4tap_AYUV64 (uint16_t * dest, uint16_t * src1,
    uint16_t * src2, uint16_t * src3, uint16_t * src4, int n, int acc);

static double
vs_4tap_func (double x)
{
#if 0
  if (x < -1)
    return 0;
  if (x > 1)
    return 0;
  if (x < 0)
    return 1 + x;
  return 1 - x;
#endif
#if 0
  if (x == 0)
    return 1;
  return sin (G_PI * x) / (G_PI * x) * (1 - 0.25 * x * x);
#endif
#if 1
  if (x == 0)
    return 1;
  return sin (G_PI * x) / (G_PI * x);
#endif
}

void
vs_4tap_init (void)
{
  int i;
  double a, b, c, d;
  double sum;

  for (i = 0; i < 256; i++) {
    a = vs_4tap_func (-1 - i / 256.0);
    b = vs_4tap_func (0 - i / 256.0);
    c = vs_4tap_func (1 - i / 256.0);
    d = vs_4tap_func (2 - i / 256.0);
    sum = a + b + c + d;

    vs_4tap_taps[i][0] = rint ((1 << SHIFT) * (a / sum));
    vs_4tap_taps[i][1] = rint ((1 << SHIFT) * (b / sum));
    vs_4tap_taps[i][2] = rint ((1 << SHIFT) * (c / sum));
    vs_4tap_taps[i][3] = rint ((1 << SHIFT) * (d / sum));
  }
}


void
vs_scanline_resample_4tap_Y (uint8_t * dest, uint8_t * src,
    int n, int src_width, int *xacc, int increment)
{
  int i;
  int j;
  int acc;
  int x;
  int y;

  acc = *xacc;
  for (i = 0; i < n; i++) {
    j = acc >> 16;
    x = (acc & 0xff00) >> 8;
    if (j - 1 >= 0 && j + 2 < src_width) {
      y = vs_4tap_taps[x][0] * src[j - 1];
      y += vs_4tap_taps[x][1] * src[j];
      y += vs_4tap_taps[x][2] * src[j + 1];
      y += vs_4tap_taps[x][3] * src[j + 2];
    } else {
      y = vs_4tap_taps[x][0] * src[CLAMP (j - 1, 0, src_width - 1)];
      y += vs_4tap_taps[x][1] * src[CLAMP (j, 0, src_width - 1)];
      y += vs_4tap_taps[x][2] * src[CLAMP (j + 1, 0, src_width - 1)];
      y += vs_4tap_taps[x][3] * src[CLAMP (j + 2, 0, src_width - 1)];
    }
    y += (1 << (SHIFT - 1));
    dest[i] = CLAMP (y >> SHIFT, 0, 255);
    acc += increment;
  }
  *xacc = acc;
}

void
vs_scanline_merge_4tap_Y (uint8_t * dest, uint8_t * src1, uint8_t * src2,
    uint8_t * src3, uint8_t * src4, int n, int acc)
{
  int i;
  int y;
  int a, b, c, d;

  acc = (acc >> 8) & 0xff;
  a = vs_4tap_taps[acc][0];
  b = vs_4tap_taps[acc][1];
  c = vs_4tap_taps[acc][2];
  d = vs_4tap_taps[acc][3];
  for (i = 0; i < n; i++) {
    y = a * src1[i];
    y += b * src2[i];
    y += c * src3[i];
    y += d * src4[i];
    y += (1 << (SHIFT - 1));
    dest[i] = CLAMP (y >> SHIFT, 0, 255);
  }
}


void
vs_image_scale_4tap_Y (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int yacc;
  int y_increment;
  int x_increment;
  int i;
  int j;
  int xacc;
  int k;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1);

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1);

  k = 0;
  for (i = 0; i < 4; i++) {
    xacc = 0;
    vs_scanline_resample_4tap_Y (tmpbuf + i * dest->width,
        src->pixels + CLAMP (i, 0, src->height - 1) * src->stride, dest->width,
        src->width, &xacc, x_increment);
  }

  yacc = 0;
  for (i = 0; i < dest->height; i++) {
    uint8_t *t0, *t1, *t2, *t3;

    j = yacc >> 16;

    while (j > k) {
      k++;
      if (k + 3 < src->height) {
        xacc = 0;
        vs_scanline_resample_4tap_Y (tmpbuf + ((k + 3) & 3) * dest->width,
            src->pixels + (k + 3) * src->stride,
            dest->width, src->width, &xacc, x_increment);
      }
    }

    t0 = tmpbuf + (CLAMP (j - 1, 0, src->height - 1) & 3) * dest->width;
    t1 = tmpbuf + (CLAMP (j, 0, src->height - 1) & 3) * dest->width;
    t2 = tmpbuf + (CLAMP (j + 1, 0, src->height - 1) & 3) * dest->width;
    t3 = tmpbuf + (CLAMP (j + 2, 0, src->height - 1) & 3) * dest->width;
    vs_scanline_merge_4tap_Y (dest->pixels + i * dest->stride,
        t0, t1, t2, t3, dest->width, yacc & 0xffff);

    yacc += y_increment;
  }
}

void
vs_scanline_resample_4tap_Y16 (uint8_t * dest, uint8_t * src,
    int n, int src_width, int *xacc, int increment)
{
  int i;
  int j;
  int acc;
  int x;
  int y;
  uint16_t *d = (uint16_t *) dest, *s = (uint16_t *) src;

  acc = *xacc;
  for (i = 0; i < n; i++) {
    j = acc >> 16;
    x = (acc & 0xff00) >> 8;
    if (j - 1 >= 0 && j + 2 < src_width) {
      y = vs_4tap_taps[x][0] * s[j - 1];
      y += vs_4tap_taps[x][1] * s[j];
      y += vs_4tap_taps[x][2] * s[j + 1];
      y += vs_4tap_taps[x][3] * s[j + 2];
    } else {
      y = vs_4tap_taps[x][0] * s[CLAMP (j - 1, 0, src_width - 1)];
      y += vs_4tap_taps[x][1] * s[CLAMP (j, 0, src_width - 1)];
      y += vs_4tap_taps[x][2] * s[CLAMP (j + 1, 0, src_width - 1)];
      y += vs_4tap_taps[x][3] * s[CLAMP (j + 2, 0, src_width - 1)];
    }
    y += (1 << (SHIFT - 1));
    d[i] = CLAMP (y >> SHIFT, 0, 65535);
    acc += increment;
  }
  *xacc = acc;
}

void
vs_scanline_merge_4tap_Y16 (uint8_t * dest, uint8_t * src1, uint8_t * src2,
    uint8_t * src3, uint8_t * src4, int n, int acc)
{
  int i;
  int y;
  int a, b, c, d;
  uint16_t *de = (uint16_t *) dest, *s1 = (uint16_t *) src1;
  uint16_t *s2 = (uint16_t *) src2, *s3 = (uint16_t *) src3;
  uint16_t *s4 = (uint16_t *) src4;

  acc = (acc >> 8) & 0xff;
  a = vs_4tap_taps[acc][0];
  b = vs_4tap_taps[acc][1];
  c = vs_4tap_taps[acc][2];
  d = vs_4tap_taps[acc][3];
  for (i = 0; i < n; i++) {
    y = a * s1[i];
    y += b * s2[i];
    y += c * s3[i];
    y += d * s4[i];
    y += (1 << (SHIFT - 1));
    de[i] = CLAMP (y >> SHIFT, 0, 65535);
  }
}


void
vs_image_scale_4tap_Y16 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int yacc;
  int y_increment;
  int x_increment;
  int i;
  int j;
  int xacc;
  int k;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1);

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1);

  k = 0;
  for (i = 0; i < 4; i++) {
    xacc = 0;
    vs_scanline_resample_4tap_Y16 (tmpbuf + i * dest->stride,
        src->pixels + CLAMP (i, 0, src->height - 1) * src->stride, dest->width,
        src->width, &xacc, x_increment);
  }

  yacc = 0;
  for (i = 0; i < dest->height; i++) {
    uint8_t *t0, *t1, *t2, *t3;

    j = yacc >> 16;

    while (j > k) {
      k++;
      if (k + 3 < src->height) {
        xacc = 0;
        vs_scanline_resample_4tap_Y16 (tmpbuf + ((k + 3) & 3) * dest->stride,
            src->pixels + (k + 3) * src->stride,
            dest->width, src->width, &xacc, x_increment);
      }
    }

    t0 = tmpbuf + (CLAMP (j - 1, 0, src->height - 1) & 3) * dest->stride;
    t1 = tmpbuf + (CLAMP (j, 0, src->height - 1) & 3) * dest->stride;
    t2 = tmpbuf + (CLAMP (j + 1, 0, src->height - 1) & 3) * dest->stride;
    t3 = tmpbuf + (CLAMP (j + 2, 0, src->height - 1) & 3) * dest->stride;
    vs_scanline_merge_4tap_Y16 (dest->pixels + i * dest->stride,
        t0, t1, t2, t3, dest->width, yacc & 0xffff);

    yacc += y_increment;
  }
}

void
vs_scanline_resample_4tap_RGBA (uint8_t * dest, uint8_t * src,
    int n, int src_width, int *xacc, int increment)
{
  int i;
  int j;
  int acc;
  int x;
  int y;
  int off;

  acc = *xacc;
  for (i = 0; i < n; i++) {
    j = acc >> 16;
    x = (acc & 0xffff) >> 8;

    for (off = 0; off < 4; off++) {
      if (j - 1 >= 0 && j + 2 < src_width) {
        y = vs_4tap_taps[x][0] * src[(j - 1) * 4 + off];
        y += vs_4tap_taps[x][1] * src[j * 4 + off];
        y += vs_4tap_taps[x][2] * src[(j + 1) * 4 + off];
        y += vs_4tap_taps[x][3] * src[(j + 2) * 4 + off];
      } else {
        y = vs_4tap_taps[x][0] *
            src[CLAMP ((j - 1), 0, src_width - 1) * 4 + off];
        y += vs_4tap_taps[x][1] *
            src[CLAMP ((j + 0), 0, src_width - 1) * 4 + off];
        y += vs_4tap_taps[x][2] *
            src[CLAMP ((j + 1), 0, src_width - 1) * 4 + off];
        y += vs_4tap_taps[x][3] *
            src[CLAMP ((j + 2), 0, src_width - 1) * 4 + off];
      }
      y += (1 << (SHIFT - 1));
      dest[i * 4 + off] = CLAMP (y >> SHIFT, 0, 255);
    }
    acc += increment;
  }
  *xacc = acc;
}

void
vs_scanline_merge_4tap_RGBA (uint8_t * dest, uint8_t * src1, uint8_t * src2,
    uint8_t * src3, uint8_t * src4, int n, int acc)
{
  int i;
  int y;
  int off;
  int a, b, c, d;

  acc = (acc >> 8) & 0xff;
  a = vs_4tap_taps[acc][0];
  b = vs_4tap_taps[acc][1];
  c = vs_4tap_taps[acc][2];
  d = vs_4tap_taps[acc][3];
  for (i = 0; i < n; i++) {
    for (off = 0; off < 4; off++) {
      y = a * src1[i * 4 + off];
      y += b * src2[i * 4 + off];
      y += c * src3[i * 4 + off];
      y += d * src4[i * 4 + off];
      y += (1 << (SHIFT - 1));
      dest[i * 4 + off] = CLAMP (y >> SHIFT, 0, 255);
    }
  }
}

void
vs_image_scale_4tap_RGBA (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int yacc;
  int y_increment;
  int x_increment;
  int i;
  int j;
  int xacc;
  int k;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1);

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1);

  k = 0;
  for (i = 0; i < 4; i++) {
    xacc = 0;
    vs_scanline_resample_4tap_RGBA (tmpbuf + i * dest->stride,
        src->pixels + CLAMP (i, 0, src->height) * src->stride,
        dest->width, src->width, &xacc, x_increment);
  }

  yacc = 0;
  for (i = 0; i < dest->height; i++) {
    uint8_t *t0, *t1, *t2, *t3;

    j = yacc >> 16;

    while (j > k) {
      k++;
      if (k + 3 < src->height) {
        xacc = 0;
        vs_scanline_resample_4tap_RGBA (tmpbuf + ((k + 3) & 3) * dest->stride,
            src->pixels + (k + 3) * src->stride,
            dest->width, src->width, &xacc, x_increment);
      }
    }

    t0 = tmpbuf + (CLAMP (j - 1, 0, src->height - 1) & 3) * dest->stride;
    t1 = tmpbuf + (CLAMP (j, 0, src->height - 1) & 3) * dest->stride;
    t2 = tmpbuf + (CLAMP (j + 1, 0, src->height - 1) & 3) * dest->stride;
    t3 = tmpbuf + (CLAMP (j + 2, 0, src->height - 1) & 3) * dest->stride;
    vs_scanline_merge_4tap_RGBA (dest->pixels + i * dest->stride,
        t0, t1, t2, t3, dest->width, yacc & 0xffff);

    yacc += y_increment;
  }
}

void
vs_scanline_resample_4tap_RGB (uint8_t * dest, uint8_t * src,
    int n, int src_width, int *xacc, int increment)
{
  int i;
  int j;
  int acc;
  int x;
  int y;
  int off;

  acc = *xacc;
  for (i = 0; i < n; i++) {
    j = acc >> 16;
    x = (acc & 0xffff) >> 8;

    for (off = 0; off < 3; off++) {
      if (j - 1 >= 0 && j + 2 < src_width) {
        y = vs_4tap_taps[x][0] * src[(j - 1) * 3 + off];
        y += vs_4tap_taps[x][1] * src[j * 3 + off];
        y += vs_4tap_taps[x][2] * src[(j + 1) * 3 + off];
        y += vs_4tap_taps[x][3] * src[(j + 2) * 3 + off];
      } else {
        y = vs_4tap_taps[x][0] * src[CLAMP ((j - 1) * 3 + off, 0,
                3 * (src_width - 1) + off)];
        y += vs_4tap_taps[x][1] * src[CLAMP (j * 3 + off, 0,
                3 * (src_width - 1) + off)];
        y += vs_4tap_taps[x][2] * src[CLAMP ((j + 1) * 3 + off, 0,
                3 * (src_width - 1) + off)];
        y += vs_4tap_taps[x][3] * src[CLAMP ((j + 2) * 3 + off, 0,
                3 * (src_width - 1) + off)];
      }
      y += (1 << (SHIFT - 1));
      dest[i * 3 + off] = CLAMP (y >> SHIFT, 0, 255);
    }
    acc += increment;
  }
  *xacc = acc;
}

void
vs_scanline_merge_4tap_RGB (uint8_t * dest, uint8_t * src1, uint8_t * src2,
    uint8_t * src3, uint8_t * src4, int n, int acc)
{
  int i;
  int y;
  int off;
  int a, b, c, d;

  acc = (acc >> 8) & 0xff;
  a = vs_4tap_taps[acc][0];
  b = vs_4tap_taps[acc][1];
  c = vs_4tap_taps[acc][2];
  d = vs_4tap_taps[acc][3];
  for (i = 0; i < n; i++) {
    for (off = 0; off < 3; off++) {
      y = a * src1[i * 3 + off];
      y += b * src2[i * 3 + off];
      y += c * src3[i * 3 + off];
      y += d * src4[i * 3 + off];
      y += (1 << (SHIFT - 1));
      dest[i * 3 + off] = CLAMP (y >> SHIFT, 0, 255);
    }
  }
}

void
vs_image_scale_4tap_RGB (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int yacc;
  int y_increment;
  int x_increment;
  int i;
  int j;
  int xacc;
  int k;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1);

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1);

  k = 0;
  for (i = 0; i < 4; i++) {
    xacc = 0;
    vs_scanline_resample_4tap_RGB (tmpbuf + i * dest->stride,
        src->pixels + CLAMP (i, 0, src->height - 1) * src->stride, dest->width,
        src->width, &xacc, x_increment);
  }

  yacc = 0;
  for (i = 0; i < dest->height; i++) {
    uint8_t *t0, *t1, *t2, *t3;

    j = yacc >> 16;

    while (j > k) {
      k++;
      if (k + 3 < src->height) {
        xacc = 0;
        vs_scanline_resample_4tap_RGB (tmpbuf + ((k + 3) & 3) * dest->stride,
            src->pixels + (k + 3) * src->stride,
            dest->width, src->width, &xacc, x_increment);
      }
    }

    t0 = tmpbuf + (CLAMP (j - 1, 0, src->height - 1) & 3) * dest->stride;
    t1 = tmpbuf + (CLAMP (j, 0, src->height - 1) & 3) * dest->stride;
    t2 = tmpbuf + (CLAMP (j + 1, 0, src->height - 1) & 3) * dest->stride;
    t3 = tmpbuf + (CLAMP (j + 2, 0, src->height - 1) & 3) * dest->stride;
    vs_scanline_merge_4tap_RGB (dest->pixels + i * dest->stride,
        t0, t1, t2, t3, dest->width, yacc & 0xffff);

    yacc += y_increment;
  }
}

void
vs_scanline_resample_4tap_YUYV (uint8_t * dest, uint8_t * src,
    int n, int src_width, int *xacc, int increment)
{
  int i;
  int j;
  int acc;
  int x;
  int y;
  int quads = (n + 1) / 2;
  int last_y = 2 * (src_width - 1);
  int last_u =
      MAX ((2 * (src_width - 1) % 4 ==
          0) ? 2 * (src_width - 1) + 1 : 2 * (src_width - 1) - 1, 1);
  int last_v =
      MAX ((2 * (src_width - 1) % 4 ==
          2) ? 2 * (src_width - 1) + 1 : 2 * (src_width - 1) - 1, 1);

  acc = *xacc;
  for (i = 0; i < quads; i++) {
    j = acc >> 16;
    x = (acc & 0xffff) >> 8;

    if (j - 1 >= 0 && j + 2 < src_width) {
      y = vs_4tap_taps[x][0] * src[j * 2 + 0 - 2];
      y += vs_4tap_taps[x][1] * src[j * 2 + 0];
      y += vs_4tap_taps[x][2] * src[j * 2 + 0 + 2];
      y += vs_4tap_taps[x][3] * src[j * 2 + 0 + 4];
    } else {
      y = vs_4tap_taps[x][0] * src[CLAMP (j * 2 + 0 - 2, 0, last_y)];
      y += vs_4tap_taps[x][1] * src[CLAMP (j * 2 + 0, 0, last_y)];
      y += vs_4tap_taps[x][2] * src[CLAMP (j * 2 + 0 + 2, 0, last_y)];
      y += vs_4tap_taps[x][3] * src[CLAMP (j * 2 + 0 + 4, 0, last_y)];
    }
    y += (1 << (SHIFT - 1));
    dest[i * 4 + 0] = CLAMP (y >> SHIFT, 0, 255);

    j = acc >> 17;
    x = (acc & 0x1ffff) >> 9;

    if (2 * j - 1 >= 0 && 2 * j + 4 < src_width) {
      y = vs_4tap_taps[x][0] * src[MAX (j * 4 + 1 - 4, 1)];
      y += vs_4tap_taps[x][1] * src[j * 4 + 1];
      y += vs_4tap_taps[x][2] * src[j * 4 + 1 + 4];
      y += vs_4tap_taps[x][3] * src[j * 4 + 1 + 8];
    } else {
      y = vs_4tap_taps[x][0] * src[CLAMP (j * 4 + 1 - 4, 1, last_u)];
      y += vs_4tap_taps[x][1] * src[CLAMP (j * 4 + 1, 1, last_u)];
      y += vs_4tap_taps[x][2] * src[CLAMP (j * 4 + 1 + 4, 1, last_u)];
      y += vs_4tap_taps[x][3] * src[CLAMP (j * 4 + 1 + 8, 1, last_u)];
    }
    y += (1 << (SHIFT - 1));
    dest[i * 4 + 1] = CLAMP (y >> SHIFT, 0, 255);

    if (2 * i + 1 < n) {
      if (2 * j - 1 >= 0 && 2 * j + 4 < src_width) {
        y = vs_4tap_taps[x][0] * src[MAX (j * 4 + 3 - 4, 3)];
        y += vs_4tap_taps[x][1] * src[j * 4 + 3];
        y += vs_4tap_taps[x][2] * src[j * 4 + 3 + 4];
        y += vs_4tap_taps[x][3] * src[j * 4 + 3 + 8];
      } else {
        y = vs_4tap_taps[x][0] * src[CLAMP (j * 4 + 3 - 4, 3, last_v)];
        y += vs_4tap_taps[x][1] * src[CLAMP (j * 4 + 3, 3, last_v)];
        y += vs_4tap_taps[x][2] * src[CLAMP (j * 4 + 3 + 4, 3, last_v)];
        y += vs_4tap_taps[x][3] * src[CLAMP (j * 4 + 3 + 8, 3, last_v)];
      }
      y += (1 << (SHIFT - 1));
      dest[i * 4 + 3] = CLAMP (y >> SHIFT, 0, 255);
    }

    acc += increment;
    j = acc >> 16;
    x = (acc & 0xffff) >> 8;

    if (2 * i + 1 < n) {
      if (j - 1 >= 0 && j + 2 < src_width) {
        y = vs_4tap_taps[x][0] * src[j * 2 + 0 - 2];
        y += vs_4tap_taps[x][1] * src[j * 2 + 0];
        y += vs_4tap_taps[x][2] * src[j * 2 + 0 + 2];
        y += vs_4tap_taps[x][3] * src[j * 2 + 0 + 4];
      } else {
        y = vs_4tap_taps[x][0] * src[CLAMP (j * 2 + 0 - 2, 0, last_y)];
        y += vs_4tap_taps[x][1] * src[CLAMP (j * 2 + 0, 0, last_y)];
        y += vs_4tap_taps[x][2] * src[CLAMP (j * 2 + 0 + 2, 0, last_y)];
        y += vs_4tap_taps[x][3] * src[CLAMP (j * 2 + 0 + 4, 0, last_y)];
      }
      y += (1 << (SHIFT - 1));
      dest[i * 4 + 2] = CLAMP (y >> SHIFT, 0, 255);
      acc += increment;
    }
  }
  *xacc = acc;
}

void
vs_scanline_merge_4tap_YUYV (uint8_t * dest, uint8_t * src1, uint8_t * src2,
    uint8_t * src3, uint8_t * src4, int n, int acc)
{
  int i;
  int y;
  int a, b, c, d;
  int quads = (n + 1) / 2;

  acc = (acc >> 8) & 0xff;
  a = vs_4tap_taps[acc][0];
  b = vs_4tap_taps[acc][1];
  c = vs_4tap_taps[acc][2];
  d = vs_4tap_taps[acc][3];
  for (i = 0; i < quads; i++) {
    y = a * src1[i * 4 + 0];
    y += b * src2[i * 4 + 0];
    y += c * src3[i * 4 + 0];
    y += d * src4[i * 4 + 0];
    y += (1 << (SHIFT - 1));
    dest[i * 4 + 0] = CLAMP (y >> SHIFT, 0, 255);

    y = a * src1[i * 4 + 1];
    y += b * src2[i * 4 + 1];
    y += c * src3[i * 4 + 1];
    y += d * src4[i * 4 + 1];
    y += (1 << (SHIFT - 1));
    dest[i * 4 + 1] = CLAMP (y >> SHIFT, 0, 255);

    if (2 * i + 1 < n) {
      y = a * src1[i * 4 + 2];
      y += b * src2[i * 4 + 2];
      y += c * src3[i * 4 + 2];
      y += d * src4[i * 4 + 2];
      y += (1 << (SHIFT - 1));
      dest[i * 4 + 2] = CLAMP (y >> SHIFT, 0, 255);

      y = a * src1[i * 4 + 3];
      y += b * src2[i * 4 + 3];
      y += c * src3[i * 4 + 3];
      y += d * src4[i * 4 + 3];
      y += (1 << (SHIFT - 1));
      dest[i * 4 + 3] = CLAMP (y >> SHIFT, 0, 255);
    }
  }
}

void
vs_image_scale_4tap_YUYV (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int yacc;
  int y_increment;
  int x_increment;
  int i;
  int j;
  int xacc;
  int k;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1);

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1);

  k = 0;
  for (i = 0; i < 4; i++) {
    xacc = 0;
    vs_scanline_resample_4tap_YUYV (tmpbuf + i * dest->stride,
        src->pixels + CLAMP (i, 0, src->height - 1) * src->stride, dest->width,
        src->width, &xacc, x_increment);
  }

  yacc = 0;
  for (i = 0; i < dest->height; i++) {
    uint8_t *t0, *t1, *t2, *t3;

    j = yacc >> 16;

    while (j > k) {
      k++;
      if (k + 3 < src->height) {
        xacc = 0;
        vs_scanline_resample_4tap_YUYV (tmpbuf + ((k + 3) & 3) * dest->stride,
            src->pixels + (k + 3) * src->stride,
            dest->width, src->width, &xacc, x_increment);
      }
    }

    t0 = tmpbuf + (CLAMP (j - 1, 0, src->height - 1) & 3) * dest->stride;
    t1 = tmpbuf + (CLAMP (j, 0, src->height - 1) & 3) * dest->stride;
    t2 = tmpbuf + (CLAMP (j + 1, 0, src->height - 1) & 3) * dest->stride;
    t3 = tmpbuf + (CLAMP (j + 2, 0, src->height - 1) & 3) * dest->stride;
    vs_scanline_merge_4tap_YUYV (dest->pixels + i * dest->stride,
        t0, t1, t2, t3, dest->width, yacc & 0xffff);

    yacc += y_increment;
  }
}

void
vs_scanline_resample_4tap_UYVY (uint8_t * dest, uint8_t * src,
    int n, int src_width, int *xacc, int increment)
{
  int i;
  int j;
  int acc;
  int x;
  int y;
  int quads = (n + 1) / 2;
  int last_y = 2 * (src_width - 1) + 1;
  int last_u =
      MAX ((2 * (src_width - 1) % 4 ==
          0) ? 2 * (src_width - 1) : 2 * (src_width - 1) - 2, 0);
  int last_v =
      MAX ((2 * (src_width - 1) % 4 ==
          2) ? 2 * (src_width - 1) : 2 * (src_width - 1) - 2, 0);

  acc = *xacc;
  for (i = 0; i < quads; i++) {
    j = acc >> 16;
    x = (acc & 0xffff) >> 8;

    if (j - 1 >= 0 && j + 2 < src_width) {
      y = vs_4tap_taps[x][0] * src[MAX (j * 2 + 1 - 2, 1)];
      y += vs_4tap_taps[x][1] * src[j * 2 + 1];
      y += vs_4tap_taps[x][2] * src[j * 2 + 1 + 2];
      y += vs_4tap_taps[x][3] * src[j * 2 + 1 + 4];
    } else {
      y = vs_4tap_taps[x][0] * src[CLAMP (j * 2 + 1 - 2, 1, last_y)];
      y += vs_4tap_taps[x][1] * src[CLAMP (j * 2 + 1, 1, last_y)];
      y += vs_4tap_taps[x][2] * src[CLAMP (j * 2 + 1 + 2, 1, last_y)];
      y += vs_4tap_taps[x][3] * src[CLAMP (j * 2 + 1 + 4, 1, last_y)];
    }
    y += (1 << (SHIFT - 1));
    dest[i * 4 + 1] = CLAMP (y >> SHIFT, 0, 255);

    j = acc >> 17;
    x = (acc & 0x1ffff) >> 9;

    if (2 * j - 2 >= 0 && 2 * j + 4 < src_width) {
      y = vs_4tap_taps[x][0] * src[MAX (j * 4 + 0 - 4, 0)];
      y += vs_4tap_taps[x][1] * src[j * 4 + 0];
      y += vs_4tap_taps[x][2] * src[j * 4 + 0 + 4];
      y += vs_4tap_taps[x][3] * src[j * 4 + 0 + 8];
    } else {
      y = vs_4tap_taps[x][0] * src[CLAMP (j * 4 + 0 - 4, 0, last_u)];
      y += vs_4tap_taps[x][1] * src[CLAMP (j * 4 + 0, 0, last_u)];
      y += vs_4tap_taps[x][2] * src[CLAMP (j * 4 + 0 + 4, 0, last_u)];
      y += vs_4tap_taps[x][3] * src[CLAMP (j * 4 + 0 + 8, 0, last_u)];
    }
    y += (1 << (SHIFT - 1));
    dest[i * 4 + 0] = CLAMP (y >> SHIFT, 0, 255);

    if (2 * i + 1 < n) {
      if (2 * j - 1 >= 0 && 2 * j + 4 < src_width) {
        y = vs_4tap_taps[x][0] * src[MAX (j * 4 + 2 - 4, 2)];
        y += vs_4tap_taps[x][1] * src[j * 4 + 2];
        y += vs_4tap_taps[x][2] * src[j * 4 + 2 + 4];
        y += vs_4tap_taps[x][3] * src[j * 4 + 2 + 8];
      } else {
        y = vs_4tap_taps[x][0] * src[CLAMP (j * 4 + 2 - 4, 2, last_v)];
        y += vs_4tap_taps[x][1] * src[CLAMP (j * 4 + 2, 2, last_v)];
        y += vs_4tap_taps[x][2] * src[CLAMP (j * 4 + 2 + 4, 2, last_v)];
        y += vs_4tap_taps[x][3] * src[CLAMP (j * 4 + 2 + 8, 2, last_v)];
      }
      y += (1 << (SHIFT - 1));
      dest[i * 4 + 2] = CLAMP (y >> SHIFT, 0, 255);
    }

    acc += increment;
    j = acc >> 16;
    x = (acc & 0xffff) >> 8;

    if (2 * i + 1 < n) {
      if (j - 1 >= 0 && j + 2 < src_width) {
        y = vs_4tap_taps[x][0] * src[MAX (j * 2 + 1 - 2, 0)];
        y += vs_4tap_taps[x][1] * src[j * 2 + 1];
        y += vs_4tap_taps[x][2] * src[j * 2 + 1 + 2];
        y += vs_4tap_taps[x][3] * src[j * 2 + 1 + 4];
      } else {
        y = vs_4tap_taps[x][0] * src[CLAMP (j * 2 + 1 - 2, 1, last_y)];
        y += vs_4tap_taps[x][1] * src[CLAMP (j * 2 + 1, 1, last_y)];
        y += vs_4tap_taps[x][2] * src[CLAMP (j * 2 + 1 + 2, 1, last_y)];
        y += vs_4tap_taps[x][3] * src[CLAMP (j * 2 + 1 + 4, 1, last_y)];
      }
      y += (1 << (SHIFT - 1));
      dest[i * 4 + 3] = CLAMP (y >> SHIFT, 0, 255);
      acc += increment;
    }
  }
  *xacc = acc;
}

void
vs_scanline_merge_4tap_UYVY (uint8_t * dest, uint8_t * src1, uint8_t * src2,
    uint8_t * src3, uint8_t * src4, int n, int acc)
{
  int i;
  int y;
  int a, b, c, d;
  int quads = (n + 1) / 2;

  acc = (acc >> 8) & 0xff;
  a = vs_4tap_taps[acc][0];
  b = vs_4tap_taps[acc][1];
  c = vs_4tap_taps[acc][2];
  d = vs_4tap_taps[acc][3];
  for (i = 0; i < quads; i++) {
    y = a * src1[i * 4 + 0];
    y += b * src2[i * 4 + 0];
    y += c * src3[i * 4 + 0];
    y += d * src4[i * 4 + 0];
    y += (1 << (SHIFT - 1));
    dest[i * 4 + 0] = CLAMP (y >> SHIFT, 0, 255);

    y = a * src1[i * 4 + 1];
    y += b * src2[i * 4 + 1];
    y += c * src3[i * 4 + 1];
    y += d * src4[i * 4 + 1];
    y += (1 << (SHIFT - 1));
    dest[i * 4 + 1] = CLAMP (y >> SHIFT, 0, 255);

    if (2 * i + 1 < n) {
      y = a * src1[i * 4 + 2];
      y += b * src2[i * 4 + 2];
      y += c * src3[i * 4 + 2];
      y += d * src4[i * 4 + 2];
      y += (1 << (SHIFT - 1));
      dest[i * 4 + 2] = CLAMP (y >> SHIFT, 0, 255);

      y = a * src1[i * 4 + 3];
      y += b * src2[i * 4 + 3];
      y += c * src3[i * 4 + 3];
      y += d * src4[i * 4 + 3];
      y += (1 << (SHIFT - 1));
      dest[i * 4 + 3] = CLAMP (y >> SHIFT, 0, 255);
    }
  }
}

void
vs_image_scale_4tap_UYVY (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int yacc;
  int y_increment;
  int x_increment;
  int i;
  int j;
  int xacc;
  int k;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1);

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1);

  k = 0;
  for (i = 0; i < 4; i++) {
    xacc = 0;
    vs_scanline_resample_4tap_UYVY (tmpbuf + i * dest->stride,
        src->pixels + CLAMP (i, 0, src->height - 1) * src->stride, dest->width,
        src->width, &xacc, x_increment);
  }

  yacc = 0;
  for (i = 0; i < dest->height; i++) {
    uint8_t *t0, *t1, *t2, *t3;

    j = yacc >> 16;

    while (j > k) {
      k++;
      if (k + 3 < src->height) {
        xacc = 0;
        vs_scanline_resample_4tap_UYVY (tmpbuf + ((k + 3) & 3) * dest->stride,
            src->pixels + (k + 3) * src->stride,
            dest->width, src->width, &xacc, x_increment);
      }
    }

    t0 = tmpbuf + (CLAMP (j - 1, 0, src->height - 1) & 3) * dest->stride;
    t1 = tmpbuf + (CLAMP (j, 0, src->height - 1) & 3) * dest->stride;
    t2 = tmpbuf + (CLAMP (j + 1, 0, src->height - 1) & 3) * dest->stride;
    t3 = tmpbuf + (CLAMP (j + 2, 0, src->height - 1) & 3) * dest->stride;
    vs_scanline_merge_4tap_UYVY (dest->pixels + i * dest->stride,
        t0, t1, t2, t3, dest->width, yacc & 0xffff);

    yacc += y_increment;
  }
}

/* note that src and dest are uint16_t, and thus endian dependent */

#define RGB565_R(x) (((x)&0xf800)>>8 | ((x)&0xf800)>>13)
#define RGB565_G(x) (((x)&0x07e0)>>3 | ((x)&0x07e0)>>9)
#define RGB565_B(x) (((x)&0x001f)<<3 | ((x)&0x001f)>>2)

#define RGB565(r,g,b) \
  ((((r)<<8)&0xf800) | (((g)<<3)&0x07e0) | (((b)>>3)&0x001f))

void
vs_scanline_resample_4tap_RGB565 (uint8_t * dest_u8, uint8_t * src_u8,
    int n, int src_width, int *xacc, int increment)
{
  int i;
  int j;
  int acc;
  int x;
  int y, y_r, y_b, y_g;
  uint16_t *dest = (uint16_t *) dest_u8;
  uint16_t *src = (uint16_t *) src_u8;

  acc = *xacc;
  for (i = 0; i < n; i++) {
    j = acc >> 16;
    x = (acc & 0xffff) >> 8;

    if (j - 1 >= 0 && j + 2 < src_width) {
      y = vs_4tap_taps[x][0] * RGB565_R (src[(j - 1)]);
      y += vs_4tap_taps[x][1] * RGB565_R (src[j]);
      y += vs_4tap_taps[x][2] * RGB565_R (src[(j + 1)]);
      y += vs_4tap_taps[x][3] * RGB565_R (src[(j + 2)]);
    } else {
      y = vs_4tap_taps[x][0] * RGB565_R (src[CLAMP ((j - 1), 0,
                  src_width - 1)]);
      y += vs_4tap_taps[x][1] * RGB565_R (src[CLAMP (j, 0, src_width - 1)]);
      y += vs_4tap_taps[x][2] * RGB565_R (src[CLAMP ((j + 1), 0,
                  src_width - 1)]);
      y += vs_4tap_taps[x][3] * RGB565_R (src[CLAMP ((j + 2), 0,
                  src_width - 1)]);
    }
    y += (1 << (SHIFT - 1));
    y_r = CLAMP (y >> SHIFT, 0, 255);

    if (j - 1 >= 0 && j + 2 < src_width) {
      y = vs_4tap_taps[x][0] * RGB565_G (src[(j - 1)]);
      y += vs_4tap_taps[x][1] * RGB565_G (src[j]);
      y += vs_4tap_taps[x][2] * RGB565_G (src[(j + 1)]);
      y += vs_4tap_taps[x][3] * RGB565_G (src[(j + 2)]);
    } else {
      y = vs_4tap_taps[x][0] * RGB565_G (src[CLAMP ((j - 1), 0,
                  src_width - 1)]);
      y += vs_4tap_taps[x][1] * RGB565_G (src[CLAMP (j, 0, src_width - 1)]);
      y += vs_4tap_taps[x][2] * RGB565_G (src[CLAMP ((j + 1), 0,
                  src_width - 1)]);
      y += vs_4tap_taps[x][3] * RGB565_G (src[CLAMP ((j + 2), 0,
                  src_width - 1)]);
    }
    y += (1 << (SHIFT - 1));
    y_g = CLAMP (y >> SHIFT, 0, 255);

    if (j - 1 >= 0 && j + 2 < src_width) {
      y = vs_4tap_taps[x][0] * RGB565_B (src[(j - 1)]);
      y += vs_4tap_taps[x][1] * RGB565_B (src[j]);
      y += vs_4tap_taps[x][2] * RGB565_B (src[(j + 1)]);
      y += vs_4tap_taps[x][3] * RGB565_B (src[(j + 2)]);
    } else {
      y = vs_4tap_taps[x][0] * RGB565_B (src[CLAMP ((j - 1), 0,
                  src_width - 1)]);
      y += vs_4tap_taps[x][1] * RGB565_B (src[CLAMP (j, 0, src_width - 1)]);
      y += vs_4tap_taps[x][2] * RGB565_B (src[CLAMP ((j + 1), 0,
                  src_width - 1)]);
      y += vs_4tap_taps[x][3] * RGB565_B (src[CLAMP ((j + 2), 0,
                  src_width - 1)]);
    }
    y += (1 << (SHIFT - 1));
    y_b = CLAMP (y >> SHIFT, 0, 255);

    dest[i] = RGB565 (y_r, y_g, y_b);
    acc += increment;
  }
  *xacc = acc;
}

void
vs_scanline_merge_4tap_RGB565 (uint8_t * dest_u8, uint8_t * src1_u8,
    uint8_t * src2_u8, uint8_t * src3_u8, uint8_t * src4_u8, int n, int acc)
{
  int i;
  int y, y_r, y_b, y_g;
  int a, b, c, d;
  uint16_t *dest = (uint16_t *) dest_u8;
  uint16_t *src1 = (uint16_t *) src1_u8;
  uint16_t *src2 = (uint16_t *) src2_u8;
  uint16_t *src3 = (uint16_t *) src3_u8;
  uint16_t *src4 = (uint16_t *) src4_u8;

  acc = (acc >> 8) & 0xff;
  a = vs_4tap_taps[acc][0];
  b = vs_4tap_taps[acc][1];
  c = vs_4tap_taps[acc][2];
  d = vs_4tap_taps[acc][3];

  for (i = 0; i < n; i++) {
    y = a * RGB565_R (src1[i]);
    y += b * RGB565_R (src2[i]);
    y += c * RGB565_R (src3[i]);
    y += d * RGB565_R (src4[i]);
    y += (1 << (SHIFT - 1));
    y_r = CLAMP (y >> SHIFT, 0, 255);

    y = a * RGB565_G (src1[i]);
    y += b * RGB565_G (src2[i]);
    y += c * RGB565_G (src3[i]);
    y += d * RGB565_G (src4[i]);
    y += (1 << (SHIFT - 1));
    y_g = CLAMP (y >> SHIFT, 0, 255);

    y = a * RGB565_B (src1[i]);
    y += b * RGB565_B (src2[i]);
    y += c * RGB565_B (src3[i]);
    y += d * RGB565_B (src4[i]);
    y += (1 << (SHIFT - 1));
    y_b = CLAMP (y >> SHIFT, 0, 255);

    dest[i] = RGB565 (y_r, y_g, y_b);
  }
}

void
vs_image_scale_4tap_RGB565 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int yacc;
  int y_increment;
  int x_increment;
  int i;
  int j;
  int xacc;
  int k;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1);

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1);

  k = 0;
  for (i = 0; i < 4; i++) {
    xacc = 0;
    vs_scanline_resample_4tap_RGB565 (tmpbuf + i * dest->stride,
        src->pixels + CLAMP (i, 0, src->height - 1) * src->stride, dest->width,
        src->width, &xacc, x_increment);
  }

  yacc = 0;
  for (i = 0; i < dest->height; i++) {
    uint8_t *t0, *t1, *t2, *t3;

    j = yacc >> 16;

    while (j > k) {
      k++;
      if (k + 3 < src->height) {
        xacc = 0;
        vs_scanline_resample_4tap_RGB565 (tmpbuf + ((k + 3) & 3) * dest->stride,
            src->pixels + (k + 3) * src->stride,
            dest->width, src->width, &xacc, x_increment);
      }
    }

    t0 = tmpbuf + (CLAMP (j - 1, 0, src->height - 1) & 3) * dest->stride;
    t1 = tmpbuf + (CLAMP (j, 0, src->height - 1) & 3) * dest->stride;
    t2 = tmpbuf + (CLAMP (j + 1, 0, src->height - 1) & 3) * dest->stride;
    t3 = tmpbuf + (CLAMP (j + 2, 0, src->height - 1) & 3) * dest->stride;
    vs_scanline_merge_4tap_RGB565 (dest->pixels + i * dest->stride,
        t0, t1, t2, t3, dest->width, yacc & 0xffff);

    yacc += y_increment;
  }
}

/* note that src and dest are uint16_t, and thus endian dependent */

#define RGB555_R(x) (((x)&0x7c00)>>7 | ((x)&0x7c00)>>12)
#define RGB555_G(x) (((x)&0x03e0)>>2 | ((x)&0x03e0)>>7)
#define RGB555_B(x) (((x)&0x001f)<<3 | ((x)&0x001f)>>2)

#define RGB555(r,g,b) \
  ((((r)<<7)&0x7c00) | (((g)<<2)&0x03e0) | (((b)>>3)&0x001f))

void
vs_scanline_resample_4tap_RGB555 (uint8_t * dest_u8, uint8_t * src_u8,
    int n, int src_width, int *xacc, int increment)
{
  int i;
  int j;
  int acc;
  int x;
  int y, y_r, y_b, y_g;
  uint16_t *dest = (uint16_t *) dest_u8;
  uint16_t *src = (uint16_t *) src_u8;

  acc = *xacc;
  for (i = 0; i < n; i++) {
    j = acc >> 16;
    x = (acc & 0xffff) >> 8;

    if (j - 1 >= 0 && j + 2 < src_width) {
      y = vs_4tap_taps[x][0] * RGB555_R (src[(j - 1)]);
      y += vs_4tap_taps[x][1] * RGB555_R (src[j]);
      y += vs_4tap_taps[x][2] * RGB555_R (src[(j + 1)]);
      y += vs_4tap_taps[x][3] * RGB555_R (src[(j + 2)]);
    } else {
      y = vs_4tap_taps[x][0] * RGB555_R (src[CLAMP ((j - 1), 0,
                  src_width - 1)]);
      y += vs_4tap_taps[x][1] * RGB555_R (src[CLAMP (j, 0, src_width - 1)]);
      y += vs_4tap_taps[x][2] * RGB555_R (src[CLAMP ((j + 1), 0,
                  src_width - 1)]);
      y += vs_4tap_taps[x][3] * RGB555_R (src[CLAMP ((j + 2), 0,
                  src_width - 1)]);
    }
    y += (1 << (SHIFT - 1));
    y_r = CLAMP (y >> SHIFT, 0, 255);

    if (j - 1 >= 0 && j + 2 < src_width) {
      y = vs_4tap_taps[x][0] * RGB555_G (src[(j - 1)]);
      y += vs_4tap_taps[x][1] * RGB555_G (src[j]);
      y += vs_4tap_taps[x][2] * RGB555_G (src[(j + 1)]);
      y += vs_4tap_taps[x][3] * RGB555_G (src[(j + 2)]);
    } else {
      y = vs_4tap_taps[x][0] * RGB555_G (src[CLAMP ((j - 1), 0,
                  src_width - 1)]);
      y += vs_4tap_taps[x][1] * RGB555_G (src[CLAMP (j, 0, src_width - 1)]);
      y += vs_4tap_taps[x][2] * RGB555_G (src[CLAMP ((j + 1), 0,
                  src_width - 1)]);
      y += vs_4tap_taps[x][3] * RGB555_G (src[CLAMP ((j + 2), 0,
                  src_width - 1)]);
    }
    y += (1 << (SHIFT - 1));
    y_g = CLAMP (y >> SHIFT, 0, 255);

    if (j - 1 >= 0 && j + 2 < src_width) {
      y = vs_4tap_taps[x][0] * RGB555_B (src[(j - 1)]);
      y += vs_4tap_taps[x][1] * RGB555_B (src[j]);
      y += vs_4tap_taps[x][2] * RGB555_B (src[(j + 1)]);
      y += vs_4tap_taps[x][3] * RGB555_B (src[(j + 2)]);
    } else {
      y = vs_4tap_taps[x][0] * RGB555_B (src[CLAMP ((j - 1), 0,
                  src_width - 1)]);
      y += vs_4tap_taps[x][1] * RGB555_B (src[CLAMP (j, 0, src_width - 1)]);
      y += vs_4tap_taps[x][2] * RGB555_B (src[CLAMP ((j + 1), 0,
                  src_width - 1)]);
      y += vs_4tap_taps[x][3] * RGB555_B (src[CLAMP ((j + 2), 0,
                  src_width - 1)]);
    }
    y += (1 << (SHIFT - 1));
    y_b = CLAMP (y >> SHIFT, 0, 255);

    dest[i] = RGB555 (y_r, y_g, y_b);
    acc += increment;
  }
  *xacc = acc;
}

void
vs_scanline_merge_4tap_RGB555 (uint8_t * dest_u8, uint8_t * src1_u8,
    uint8_t * src2_u8, uint8_t * src3_u8, uint8_t * src4_u8, int n, int acc)
{
  int i;
  int y, y_r, y_b, y_g;
  int a, b, c, d;
  uint16_t *dest = (uint16_t *) dest_u8;
  uint16_t *src1 = (uint16_t *) src1_u8;
  uint16_t *src2 = (uint16_t *) src2_u8;
  uint16_t *src3 = (uint16_t *) src3_u8;
  uint16_t *src4 = (uint16_t *) src4_u8;

  acc = (acc >> 8) & 0xff;
  a = vs_4tap_taps[acc][0];
  b = vs_4tap_taps[acc][1];
  c = vs_4tap_taps[acc][2];
  d = vs_4tap_taps[acc][3];

  for (i = 0; i < n; i++) {
    y = a * RGB555_R (src1[i]);
    y += b * RGB555_R (src2[i]);
    y += c * RGB555_R (src3[i]);
    y += d * RGB555_R (src4[i]);
    y += (1 << (SHIFT - 1));
    y_r = CLAMP (y >> SHIFT, 0, 255);

    y = a * RGB555_G (src1[i]);
    y += b * RGB555_G (src2[i]);
    y += c * RGB555_G (src3[i]);
    y += d * RGB555_G (src4[i]);
    y += (1 << (SHIFT - 1));
    y_g = CLAMP (y >> SHIFT, 0, 255);

    y = a * RGB555_B (src1[i]);
    y += b * RGB555_B (src2[i]);
    y += c * RGB555_B (src3[i]);
    y += d * RGB555_B (src4[i]);
    y += (1 << (SHIFT - 1));
    y_b = CLAMP (y >> SHIFT, 0, 255);

    dest[i] = RGB555 (y_r, y_g, y_b);
  }
}

void
vs_image_scale_4tap_RGB555 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf)
{
  int yacc;
  int y_increment;
  int x_increment;
  int i;
  int j;
  int xacc;
  int k;

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1);

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1);

  k = 0;
  for (i = 0; i < 4; i++) {
    xacc = 0;
    vs_scanline_resample_4tap_RGB555 (tmpbuf + i * dest->stride,
        src->pixels + CLAMP (i, 0, src->height - 1) * src->stride, dest->width,
        src->width, &xacc, x_increment);
  }

  yacc = 0;
  for (i = 0; i < dest->height; i++) {
    uint8_t *t0, *t1, *t2, *t3;

    j = yacc >> 16;

    while (j > k) {
      k++;
      if (k + 3 < src->height) {
        xacc = 0;
        vs_scanline_resample_4tap_RGB555 (tmpbuf + ((k + 3) & 3) * dest->stride,
            src->pixels + (k + 3) * src->stride,
            dest->width, src->width, &xacc, x_increment);
      }
    }

    t0 = tmpbuf + (CLAMP (j - 1, 0, src->height - 1) & 3) * dest->stride;
    t1 = tmpbuf + (CLAMP (j, 0, src->height - 1) & 3) * dest->stride;
    t2 = tmpbuf + (CLAMP (j + 1, 0, src->height - 1) & 3) * dest->stride;
    t3 = tmpbuf + (CLAMP (j + 2, 0, src->height - 1) & 3) * dest->stride;
    vs_scanline_merge_4tap_RGB555 (dest->pixels + i * dest->stride,
        t0, t1, t2, t3, dest->width, yacc & 0xffff);

    yacc += y_increment;
  }
}

void
vs_scanline_resample_4tap_AYUV64 (uint16_t * dest, uint16_t * src,
    int n, int src_width, int *xacc, int increment)
{
  int i;
  int j;
  int acc;
  int x;
  int y;
  int off;

  acc = *xacc;
  for (i = 0; i < n; i++) {
    j = acc >> 16;
    x = (acc & 0xffff) >> 8;

    for (off = 0; off < 4; off++) {
      if (j - 1 >= 0 && j + 2 < src_width) {
        y = vs_4tap_taps[x][0] * src[(j - 1) * 4 + off];
        y += vs_4tap_taps[x][1] * src[j * 4 + off];
        y += vs_4tap_taps[x][2] * src[(j + 1) * 4 + off];
        y += vs_4tap_taps[x][3] * src[(j + 2) * 4 + off];
      } else {
        y = vs_4tap_taps[x][0] * src[CLAMP ((j - 1) * 4 + off, 0,
                4 * (src_width - 1) + off)];
        y += vs_4tap_taps[x][1] * src[CLAMP (j * 4 + off, 0,
                4 * (src_width - 1) + off)];
        y += vs_4tap_taps[x][2] * src[CLAMP ((j + 1) * 4 + off, 0,
                4 * (src_width - 1) + off)];
        y += vs_4tap_taps[x][3] * src[CLAMP ((j + 2) * 4 + off, 0,
                4 * (src_width - 1) + off)];
      }
      y += (1 << (SHIFT - 1));
      dest[i * 4 + off] = CLAMP (y >> SHIFT, 0, 255);
    }
    acc += increment;
  }
  *xacc = acc;
}

void
vs_scanline_merge_4tap_AYUV64 (uint16_t * dest, uint16_t * src1,
    uint16_t * src2, uint16_t * src3, uint16_t * src4, int n, int acc)
{
  int i;
  int y;
  int off;
  int a, b, c, d;

  acc = (acc >> 8) & 0xff;
  a = vs_4tap_taps[acc][0];
  b = vs_4tap_taps[acc][1];
  c = vs_4tap_taps[acc][2];
  d = vs_4tap_taps[acc][3];
  for (i = 0; i < n; i++) {
    for (off = 0; off < 4; off++) {
      y = a * src1[i * 4 + off];
      y += b * src2[i * 4 + off];
      y += c * src3[i * 4 + off];
      y += d * src4[i * 4 + off];
      y += (1 << (SHIFT - 1));
      dest[i * 4 + off] = CLAMP (y >> SHIFT, 0, 65535);
    }
  }
}

void
vs_image_scale_4tap_AYUV64 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf8)
{
  int yacc;
  int y_increment;
  int x_increment;
  int i;
  int j;
  int xacc;
  int k;
  guint16 *tmpbuf = (guint16 *) tmpbuf8;
  /* destination stride in pixels for easier use with tmpbuf variable */
  int dest_pixstride = dest->stride / sizeof (guint16);

  if (dest->height == 1)
    y_increment = 0;
  else
    y_increment = ((src->height - 1) << 16) / (dest->height - 1);

  if (dest->width == 1)
    x_increment = 0;
  else
    x_increment = ((src->width - 1) << 16) / (dest->width - 1);

  k = 0;
  for (i = 0; i < 4; i++) {
    xacc = 0;
    vs_scanline_resample_4tap_AYUV64 (tmpbuf + i * dest_pixstride,
        (guint16 *) (src->pixels + CLAMP (i, 0, src->height - 1) * src->stride),
        dest->width, src->width, &xacc, x_increment);
  }

  yacc = 0;
  for (i = 0; i < dest->height; i++) {
    uint16_t *t0, *t1, *t2, *t3;

    j = yacc >> 16;

    while (j > k) {
      k++;
      if (k + 3 < src->height) {
        xacc = 0;
        vs_scanline_resample_4tap_AYUV64 (tmpbuf + ((k +
                    3) & 3) * dest_pixstride,
            (guint16 *) (src->pixels + (k + 3) * src->stride), dest->width,
            src->width, &xacc, x_increment);
      }
    }

    t0 = tmpbuf + (CLAMP (j - 1, 0, src->height - 1) & 3) * dest_pixstride;
    t1 = tmpbuf + (CLAMP (j, 0, src->height - 1) & 3) * dest_pixstride;
    t2 = tmpbuf + (CLAMP (j + 1, 0, src->height - 1) & 3) * dest_pixstride;
    t3 = tmpbuf + (CLAMP (j + 2, 0, src->height - 1) & 3) * dest_pixstride;
    vs_scanline_merge_4tap_AYUV64 ((guint16 *) (dest->pixels +
            i * dest->stride), t0, t1, t2, t3, dest->width, yacc & 0xffff);

    yacc += y_increment;
  }
}
