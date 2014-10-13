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

#ifndef __VS_IMAGE_H__
#define __VS_IMAGE_H__

#include <glib.h>
#include <_stdint.h>

typedef struct _VSImage VSImage;

struct _VSImage {
  uint8_t *real_pixels;
  int real_width;
  int real_height;
  int border_left, border_right;
  int border_top, border_bottom;
  uint8_t *pixels;
  int width;
  int height;
  gsize stride;
};

G_GNUC_INTERNAL void vs_image_scale_nearest_RGBA   (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);
G_GNUC_INTERNAL void vs_image_scale_linear_RGBA    (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);


G_GNUC_INTERNAL void vs_image_scale_lanczos_AYUV   (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf,
                                                    double          sharpness,
                                                    gboolean        dither,
                                                    int             submethod,
                                                    double          a,
                                                    double          sharpen);

G_GNUC_INTERNAL void vs_image_scale_lanczos_AYUV64 (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf,
                                                    double          sharpness,
                                                    gboolean        dither,
                                                    int             submethod,
                                                    double          a,
                                                    double          sharpen);


G_GNUC_INTERNAL void vs_image_scale_nearest_RGB    (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);

G_GNUC_INTERNAL void vs_image_scale_linear_RGB     (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);


G_GNUC_INTERNAL void vs_image_scale_nearest_YUYV   (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);

G_GNUC_INTERNAL void vs_image_scale_linear_YUYV    (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);


G_GNUC_INTERNAL void vs_image_scale_nearest_UYVY   (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);

G_GNUC_INTERNAL void vs_image_scale_linear_UYVY    (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);


G_GNUC_INTERNAL void vs_image_scale_nearest_NV12   (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);

G_GNUC_INTERNAL void vs_image_scale_linear_NV12    (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);


G_GNUC_INTERNAL void vs_image_scale_nearest_Y      (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);

G_GNUC_INTERNAL void vs_image_scale_linear_Y       (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);

G_GNUC_INTERNAL void vs_image_scale_lanczos_Y      (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf,
                                                    double          sharpness,
                                                    gboolean        dither,
                                                    int             submethod,
                                                    double          a,
                                                    double          sharpen);


G_GNUC_INTERNAL void vs_image_scale_nearest_RGB565 (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);

G_GNUC_INTERNAL void vs_image_scale_linear_RGB565  (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);


G_GNUC_INTERNAL void vs_image_scale_nearest_RGB555 (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);

G_GNUC_INTERNAL void vs_image_scale_linear_RGB555  (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);


G_GNUC_INTERNAL void vs_image_scale_nearest_Y16    (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);

G_GNUC_INTERNAL void vs_image_scale_linear_Y16     (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);


G_GNUC_INTERNAL void vs_image_scale_nearest_AYUV16 (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);

G_GNUC_INTERNAL void vs_image_scale_linear_AYUV16  (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf);


G_GNUC_INTERNAL void vs_image_scale_nearest_AYUV64 (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf8);

G_GNUC_INTERNAL void vs_image_scale_linear_AYUV64  (const VSImage * dest,
                                                    const VSImage * src,
                                                    uint8_t       * tmpbuf8);

#endif

