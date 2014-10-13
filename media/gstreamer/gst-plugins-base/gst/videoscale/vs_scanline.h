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

#ifndef __VS_SCANLINE_H__
#define __VS_SCANLINE_H__

#include <_stdint.h>
#include <glib.h>

G_GNUC_INTERNAL void vs_scanline_downsample_Y (uint8_t *dest, uint8_t *src, int n);
G_GNUC_INTERNAL void vs_scanline_resample_nearest_Y (uint8_t *dest, uint8_t *src, int n, int src_width, int *accumulator, int increment);
G_GNUC_INTERNAL void vs_scanline_resample_linear_Y (uint8_t *dest, uint8_t *src, int n, int src_width, int *accumulator, int increment);
G_GNUC_INTERNAL void vs_scanline_merge_linear_Y (uint8_t *dest, uint8_t *src1, uint8_t *src2, int n, int x);

G_GNUC_INTERNAL void vs_scanline_downsample_RGBA (uint8_t *dest, uint8_t *src, int n);
G_GNUC_INTERNAL void vs_scanline_resample_nearest_RGBA (uint8_t *dest, uint8_t *src, int src_width, int n, int *accumulator, int increment);
G_GNUC_INTERNAL void vs_scanline_resample_linear_RGBA (uint8_t *dest, uint8_t *src, int src_width, int n, int *accumulator, int increment);
G_GNUC_INTERNAL void vs_scanline_merge_linear_RGBA (uint8_t *dest, uint8_t *src1, uint8_t *src2, int n, int x);

G_GNUC_INTERNAL void vs_scanline_downsample_RGB (uint8_t *dest, uint8_t *src, int n);
G_GNUC_INTERNAL void vs_scanline_resample_nearest_RGB (uint8_t *dest, uint8_t *src, int src_width, int n, int *accumulator, int increment);
G_GNUC_INTERNAL void vs_scanline_resample_linear_RGB (uint8_t *dest, uint8_t *src, int src_width, int n, int *accumulator, int increment);
G_GNUC_INTERNAL void vs_scanline_merge_linear_RGB (uint8_t *dest, uint8_t *src1, uint8_t *src2, int n, int x);

G_GNUC_INTERNAL void vs_scanline_downsample_YUYV (uint8_t *dest, uint8_t *src, int n);
G_GNUC_INTERNAL void vs_scanline_resample_nearest_YUYV (uint8_t *dest, uint8_t *src, int src_width, int n, int *accumulator, int increment);
G_GNUC_INTERNAL void vs_scanline_resample_linear_YUYV (uint8_t *dest, uint8_t *src, int src_width, int n, int *accumulator, int increment);
G_GNUC_INTERNAL void vs_scanline_merge_linear_YUYV (uint8_t *dest, uint8_t *src1, uint8_t *src2, int n, int x);

G_GNUC_INTERNAL void vs_scanline_downsample_UYVY (uint8_t *dest, uint8_t *src, int n);
G_GNUC_INTERNAL void vs_scanline_resample_nearest_UYVY (uint8_t *dest, uint8_t *src, int src_width, int n, int *accumulator, int increment);
G_GNUC_INTERNAL void vs_scanline_resample_linear_UYVY (uint8_t *dest, uint8_t *src, int src_width, int n, int *accumulator, int increment);
G_GNUC_INTERNAL void vs_scanline_merge_linear_UYVY (uint8_t *dest, uint8_t *src1, uint8_t *src2, int n, int x);

G_GNUC_INTERNAL void vs_scanline_downsample_NV12 (uint8_t *dest, uint8_t *src, int n);
G_GNUC_INTERNAL void vs_scanline_resample_nearest_NV12 (uint8_t *dest, uint8_t *src, int src_width, int n, int *accumulator, int increment);
G_GNUC_INTERNAL void vs_scanline_resample_linear_NV12 (uint8_t *dest, uint8_t *src, int src_width, int n, int *accumulator, int increment);
G_GNUC_INTERNAL void vs_scanline_merge_linear_NV12 (uint8_t *dest, uint8_t *src1, uint8_t *src2, int n, int x);

G_GNUC_INTERNAL void vs_scanline_downsample_RGB565 (uint8_t *dest, uint8_t *src, int n);
G_GNUC_INTERNAL void vs_scanline_resample_nearest_RGB565 (uint8_t *dest, uint8_t *src, int src_width, int n, int *accumulator, int increment);
G_GNUC_INTERNAL void vs_scanline_resample_linear_RGB565 (uint8_t *dest, uint8_t *src, int src_width, int n, int *accumulator, int increment);
G_GNUC_INTERNAL void vs_scanline_merge_linear_RGB565 (uint8_t *dest, uint8_t *src1, uint8_t *src2, int n, int x);

G_GNUC_INTERNAL void vs_scanline_downsample_RGB555 (uint8_t *dest, uint8_t *src, int n);
G_GNUC_INTERNAL void vs_scanline_resample_nearest_RGB555 (uint8_t *dest, uint8_t *src, int src_width, int n, int *accumulator, int increment);
G_GNUC_INTERNAL void vs_scanline_resample_linear_RGB555 (uint8_t *dest, uint8_t *src, int src_width, int n, int *accumulator, int increment);
G_GNUC_INTERNAL void vs_scanline_merge_linear_RGB555 (uint8_t *dest, uint8_t *src1, uint8_t *src2, int n, int x);

G_GNUC_INTERNAL void vs_scanline_downsample_Y16 (uint8_t *dest, uint8_t *src, int n);
G_GNUC_INTERNAL void vs_scanline_resample_nearest_Y16 (uint8_t *dest, uint8_t *src, int n, int src_width, int *accumulator, int increment);
G_GNUC_INTERNAL void vs_scanline_resample_linear_Y16 (uint8_t *dest, uint8_t *src, int n, int src_width, int *accumulator, int increment);
G_GNUC_INTERNAL void vs_scanline_merge_linear_Y16 (uint8_t *dest, uint8_t *src1, uint8_t *src2, int n, int x);

G_GNUC_INTERNAL void vs_scanline_resample_nearest_AYUV64 (uint8_t * dest, uint8_t * src,
    int src_width, int n, int *accumulator, int increment);
G_GNUC_INTERNAL void vs_scanline_resample_linear_AYUV64 (uint8_t * dest, uint8_t * src,
    int src_width, int n, int *accumulator, int increment);

#endif

