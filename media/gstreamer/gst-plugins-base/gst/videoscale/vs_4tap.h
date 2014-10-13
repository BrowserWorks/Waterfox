/*
 * Image Scaling Functions (4 tap)
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

#ifndef _VS_4TAP_H_
#define _VS_4TAP_H_

#include "vs_image.h"

G_GNUC_INTERNAL void vs_4tap_init (void);

G_GNUC_INTERNAL void vs_image_scale_4tap_Y      (const VSImage * dest,
                                                 const VSImage * src,
                                                 uint8_t       * tmpbuf);

G_GNUC_INTERNAL void vs_image_scale_4tap_RGBA   (const VSImage * dest,
                                                 const VSImage * src,
                                                 uint8_t       * tmpbuf);

G_GNUC_INTERNAL void vs_image_scale_4tap_RGB    (const VSImage * dest,
                                                 const VSImage * src,
                                                 uint8_t       * tmpbuf);

G_GNUC_INTERNAL void vs_image_scale_4tap_YUYV   (const VSImage * dest,
                                                 const VSImage * src,
                                                 uint8_t       * tmpbuf);

G_GNUC_INTERNAL void vs_image_scale_4tap_UYVY   (const VSImage * dest,
                                                 const VSImage * src,
                                                 uint8_t       * tmpbuf);

G_GNUC_INTERNAL void vs_image_scale_4tap_RGB565 (const VSImage * dest,
                                                 const VSImage * src,
                                                 uint8_t       * tmpbuf);

G_GNUC_INTERNAL void vs_image_scale_4tap_RGB555 (const VSImage * dest,
                                                 const VSImage * src,
                                                 uint8_t       * tmpbuf);

G_GNUC_INTERNAL void vs_image_scale_4tap_Y16    (const VSImage * dest,
                                                 const VSImage * src,
                                                 uint8_t       * tmpbuf);

G_GNUC_INTERNAL void vs_image_scale_4tap_AYUV64 (const VSImage * dest,
                                                 const VSImage * src,
                                                 uint8_t       * tmpbuf);

#endif

