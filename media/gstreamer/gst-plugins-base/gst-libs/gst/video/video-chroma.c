/* GStreamer
 * Copyright (C) 2013 Wim Taymans <wim.taymans@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <string.h>
#include <stdio.h>

#include "video-format.h"

typedef struct
{
  const gchar *name;
  GstVideoChromaSite site;
} ChromaSiteInfo;

static const ChromaSiteInfo chromasite[] = {
  {"jpeg", GST_VIDEO_CHROMA_SITE_JPEG},
  {"mpeg2", GST_VIDEO_CHROMA_SITE_MPEG2},
  {"dv", GST_VIDEO_CHROMA_SITE_DV}
};

/**
 * gst_video_chroma_from_string:
 * @s: a chromasite string
 *
 * Convert @s to a #GstVideoChromaSite
 *
 * Returns: a #GstVideoChromaSite or %GST_VIDEO_CHROMA_SITE_UNKNOWN when @s does
 * not contain a valid chroma description.
 */
GstVideoChromaSite
gst_video_chroma_from_string (const gchar * s)
{
  gint i;
  for (i = 0; i < G_N_ELEMENTS (chromasite); i++) {
    if (g_str_equal (chromasite[i].name, s))
      return chromasite[i].site;
  }
  return GST_VIDEO_CHROMA_SITE_UNKNOWN;
}

/**
 * gst_video_chroma_to_string:
 * @site: a #GstVideoChromaSite
 *
 * Converts @site to its string representation.
 *
 * Returns: a string describing @site.
 */
const gchar *
gst_video_chroma_to_string (GstVideoChromaSite site)
{
  gint i;
  for (i = 0; i < G_N_ELEMENTS (chromasite); i++) {
    if (chromasite[i].site == site)
      return chromasite[i].name;
  }
  return NULL;
}

struct _GstVideoChromaResample
{
  GstVideoChromaMethod method;
  GstVideoChromaSite site;
  GstVideoChromaFlags flags;
  GstVideoFormat format;
  gint h_factor, v_factor;
  guint n_lines;
  gint offset;
  void (*h_resample) (GstVideoChromaResample * resample, gpointer pixels,
      gint width);
  void (*v_resample) (GstVideoChromaResample * resample, gpointer lines[],
      gint width);
};

#define PR(i)          (p[2 + 4 * (i)])
#define PB(i)          (p[3 + 4 * (i)])

#define PR0(i)         (l0[2 + 4 * (i)])
#define PR1(i)         (l1[2 + 4 * (i)])
#define PR2(i)         (l2[2 + 4 * (i)])
#define PR3(i)         (l3[2 + 4 * (i)])
#define PB0(i)         (l0[3 + 4 * (i)])
#define PB1(i)         (l1[3 + 4 * (i)])
#define PB2(i)         (l2[3 + 4 * (i)])
#define PB3(i)         (l3[3 + 4 * (i)])

#define FILT_1_1(a,b)          ((a) + (b) + 1) >> 1
#define FILT_1_1_1_1(a,b,c,d)  ((a) + (b) + (c) + (d) + 2) >> 2

#define FILT_3_1(a,b)          (3*(a) + (b) + 2) >> 2
#define FILT_1_3(a,b)          ((a) + 3*(b) + 2) >> 2
#define FILT_1_2_1(a,b,c)      ((a) + 2*(b) + (c) + 2) >> 2

#define FILT_7_1(a,b)          (7*(a) + 1*(b) + 4) >> 3
#define FILT_1_7(a,b)          (1*(a) + 7*(b) + 4) >> 3

#define FILT_5_3(a,b)          (5*(a) + 3*(b) + 4) >> 3
#define FILT_3_5(a,b)          (3*(a) + 5*(b) + 4) >> 3

#define FILT_10_3_2_1(a,b,c,d)      (10*(a) + 3*(b) + 2*(c) + (d) + 8) >> 16
#define FILT_1_2_3_10(a,b,c,d)      ((a) + 2*(b) + 3*(c) + 10*(d) + 8) >> 16
#define FILT_1_2_3_4_3_2_1(a,b,c,d,e,f,g) ((a) + 2*(b) + 3*(c) + 4*(d) + 3*(e) + 2*(f) + (g) + 8) >> 16

/* 2x horizontal upsampling without cositing
 *
 * +----------    a
 * | +------ (3*a +   b + 2) >> 2
 * | | +---- (  a + 3*b + 2) >> 2
 * v v v
 * O-O-O-O-
 *  x   x
 *  a   b
 */
#define MAKE_UPSAMPLE_H2(type)                                          \
static void                                                             \
video_chroma_up_h2_##type (GstVideoChromaResample *resample,            \
    gpointer pixels, gint width)                                        \
{                                                                       \
  type *p = pixels;                                                     \
  gint i;                                                               \
  type tr0, tr1;                                                        \
  type tb0, tb1;                                                        \
                                                                        \
  tr1 = PR(0);                                                          \
  tb1 = PB(0);                                                          \
  for (i = 1; i < width - 1; i += 2) {                                  \
    tr0 = tr1, tr1 = PR(i+1);                                           \
    tb0 = tb1, tb1 = PB(i+1);                                           \
                                                                        \
    PR(i) = FILT_3_1 (tr0, tr1);                                        \
    PB(i) = FILT_3_1 (tb0, tb1);                                        \
    PR(i+1) = FILT_1_3 (tr0, tr1);                                      \
    PB(i+1) = FILT_1_3 (tb0, tb1);                                      \
  }                                                                     \
}

/* 2x vertical upsampling without cositing
 *
 *   O--O--O-  <---- a
 * a x  x  x
 *   O--O--O-  <---- (3*a +   b + 2) >> 2
 *   O--O--O-  <-----(  a + 3*b + 2) >> 2
 * b x  x  x
 *   O--O--O-  <---- b
 */
#define MAKE_UPSAMPLE_V2(type)                                          \
static void                                                             \
video_chroma_up_v2_##type (GstVideoChromaResample *resample,            \
    gpointer lines[], gint width)                                       \
{                                                                       \
  gint i;                                                               \
  type *l0 = lines[0];                                                  \
  type *l1 = lines[1];                                                  \
  type tr0, tr1;                                                        \
  type tb0, tb1;                                                        \
                                                                        \
  if (resample->h_resample) {                                           \
    resample->h_resample (resample, l0, width);                         \
    if (l0 != l1)                                                       \
      resample->h_resample (resample, l1, width);                       \
  }                                                                     \
  if (l0 != l1) {                                                       \
    for (i = 0; i < width; i++) {                                       \
      tr0 = PR0(i), tr1 = PR1(i);                                       \
      tb0 = PB0(i), tb1 = PB1(i);                                       \
                                                                        \
      PR0(i) = FILT_3_1 (tr0, tr1);                                     \
      PB0(i) = FILT_3_1 (tb0, tb1);                                     \
      PR1(i) = FILT_1_3 (tr0, tr1);                                     \
      PB1(i) = FILT_1_3 (tb0, tb1);                                     \
    }                                                                   \
  }                                                                     \
}
/* 2x vertical upsampling interlaced without cositing
 *
 *   even           odd
 *
 *   O--O--O--------------- <---  a
 * a x  x  x
 *   --------------O--O--O- <---  c
 *   O--O--O--------------- <--- (5*a + 3*b + 4) >> 3
 * c               x  x  x
 *   --------------O--O--O- <--- (7*c +   d + 4) >> 3
 *   O--O--O--------------- <--- (  a + 7*b + 4) >> 3
 * b x  x  x
 *   --------------O--O--O- <--- (3*c + 5*d + 4) >> 3
 *   O--O--O---------------
 * d               x  x  x
 *   --------------O--O--O-
 */
#define MAKE_UPSAMPLE_VI2(type)                                         \
static void                                                             \
video_chroma_up_vi2_##type (GstVideoChromaResample *resample,           \
    gpointer lines[], gint width)                                       \
{                                                                       \
  gint i;                                                               \
  type *l0 = lines[0];                                                  \
  type *l1 = lines[1];                                                  \
  type *l2 = lines[2];                                                  \
  type *l3 = lines[3];                                                  \
  type tr0, tr1, tr2, tr3;                                              \
  type tb0, tb1, tb2, tb3;                                              \
                                                                        \
  if (resample->h_resample) {                                           \
    if (l0 != l1) {                                                     \
      resample->h_resample (resample, l0, width);                       \
      resample->h_resample (resample, l1, width);                       \
    }                                                                   \
    if (l2 != l3) {                                                     \
      resample->h_resample (resample, l2, width);                       \
      resample->h_resample (resample, l3, width);                       \
    }                                                                   \
  }                                                                     \
  if (l0 != l1 && l2 != l3) {                                           \
    for (i = 0; i < width; i++) {                                       \
      tr0 = PR0(i), tr2 = PR2(i);                                       \
      tb0 = PB0(i), tb2 = PB2(i);                                       \
      tr1 = PR1(i), tr3 = PR3(i);                                       \
      tb1 = PB1(i), tb3 = PB3(i);                                       \
                                                                        \
      PR0(i) = FILT_5_3 (tr0, tr2);                                     \
      PB0(i) = FILT_5_3 (tb0, tb2);                                     \
      PR1(i) = FILT_7_1 (tr1, tr3);                                     \
      PB1(i) = FILT_7_1 (tb1, tb3);                                     \
      PR2(i) = FILT_1_7 (tr0, tr2);                                     \
      PB2(i) = FILT_1_7 (tb0, tb2);                                     \
      PR3(i) = FILT_3_5 (tr1, tr3);                                     \
      PB3(i) = FILT_3_5 (tb1, tb3);                                     \
    }                                                                   \
  }                                                                     \
}

/* 2x horizontal downsampling without cositing
 *
 *  +------ (a + b+ 1) >> 1
 *  |
 *  v
 * -O---O--
 * x x x x
 * a b c d
 */
#define MAKE_DOWNSAMPLE_H2(type)                                        \
static void                                                             \
video_chroma_down_h2_##type (GstVideoChromaResample *resample,         \
    gpointer pixels, gint width)                        \
{                                                                       \
  type *p = pixels;                                                     \
  gint i;                                                               \
                                                                        \
  for (i = 0; i < width - 1; i += 2) {                                  \
    type tr0 = PR(i), tr1 = PR(i+1);                                    \
    type tb0 = PB(i), tb1 = PB(i+1);                                    \
                                                                        \
    PR(i) = FILT_1_1 (tr0, tr1);                                        \
    PB(i) = FILT_1_1 (tb0, tb1);                                        \
  }                                                                     \
}
/* 2x vertical downsampling without cositing
 *
 * a x--x--x-
 *   O  O  O <---- (a + b + 1) >> 1
 * b x--x--x-
 * c x--x--x-
 *   O  O  O
 * d x--x--x-
 */
#define MAKE_DOWNSAMPLE_V2(type)                                        \
static void                                                             \
video_chroma_down_v2_##type (GstVideoChromaResample *resample,          \
    gpointer lines[], gint width)                                       \
{                                                                       \
  gint i;                                                               \
  type *l0 = lines[0];                                                  \
  type *l1 = lines[1];                                                  \
                                                                        \
  if (resample->h_resample) {                                           \
    resample->h_resample (resample, l0, width);                         \
    if (l0 != l1)                                                       \
      resample->h_resample (resample, l1, width);                       \
  }                                                                     \
  if (l0 != l1) {                                                       \
    for (i = 0; i < width; i++) {                                       \
      type tr0 = PR0(i), tr1 = PR1(i);                                  \
      type tb0 = PB0(i), tb1 = PB1(i);                                  \
                                                                        \
      PR0(i) = FILT_1_1 (tr0, tr1);                                     \
      PB0(i) = FILT_1_1 (tb0, tb1);                                     \
    }                                                                   \
  }                                                                     \
}
/* 2x vertical downsampling interlaced without cositing
 *
 *   even           odd
 *
 * a x--x--x---------------
 *   O  O  O                <---
 * b --------------x--x--x-
 * c x--x--x---------------
 *                 O  O  O  <---
 * d --------------x--x--x-
 */
#define MAKE_DOWNSAMPLE_VI2(type)                                       \
static void                                                             \
video_chroma_down_vi2_##type (GstVideoChromaResample *resample,         \
    gpointer lines[], gint width)                                       \
{                                                                       \
  /* FIXME */                                                           \
  if (resample->h_resample)                                             \
    resample->h_resample (resample, lines[0], width);                   \
}

MAKE_UPSAMPLE_H2 (guint16);
MAKE_UPSAMPLE_H2 (guint8);
MAKE_UPSAMPLE_V2 (guint16);
MAKE_UPSAMPLE_V2 (guint8);
MAKE_UPSAMPLE_VI2 (guint16);
MAKE_UPSAMPLE_VI2 (guint8);
MAKE_DOWNSAMPLE_H2 (guint16);
MAKE_DOWNSAMPLE_H2 (guint8);
MAKE_DOWNSAMPLE_V2 (guint16);
MAKE_DOWNSAMPLE_V2 (guint8);
MAKE_DOWNSAMPLE_VI2 (guint16);
MAKE_DOWNSAMPLE_VI2 (guint8);

/* 4x horizontal upsampling without cositing
 *
 *     +---------- (7*a +   b + 4) >> 3
 *     | +-------- (5*a + 3*b + 4) >> 3
 * a a | | +------ (3*a + 5*b + 4) >> 3
 * | | | | | +---- (  a + 7*b + 4) >> 3
 * v v v v v v
 * O-O-O-O-O-O-O-O-
 *    x       x
 *    a       b
 */
#define MAKE_UPSAMPLE_H4(type)                                          \
static void                                                             \
video_chroma_up_h4_##type (GstVideoChromaResample *resample,           \
    gpointer pixels, gint width)                        \
{                                                                       \
  type *p = pixels;                                                     \
  gint i;                                                               \
  type tr0, tr1;                                                        \
  type tb0, tb1;                                                        \
                                                                        \
  tr1 = PR(0);                                                          \
  tb1 = PB(0);                                                          \
  for (i = 2; i < width - 3; i += 4) {                                  \
    tr0 = tr1, tr1 = PR(i+2);                                           \
    tb0 = tb1, tb1 = PB(i+2);                                           \
                                                                        \
    PR(i) = FILT_7_1 (tr0, tr1);                                        \
    PB(i) = FILT_7_1 (tb0, tb1);                                        \
    PR(i+1) = FILT_5_3 (tr0, tr1);                                      \
    PB(i+1) = FILT_5_3 (tb0, tb1);                                      \
    PR(i+2) = FILT_3_5 (tr0, tr1);                                      \
    PB(i+2) = FILT_3_5 (tb0, tb1);                                      \
    PR(i+3) = FILT_1_7 (tr0, tr1);                                      \
    PB(i+3) = FILT_1_7 (tb0, tb1);                                      \
  }                                                                     \
}

/* 4x vertical upsampling without cositing
 *
 *   O--O--O-  <---- a
 *   O--O--O-  <---- a
 * a x  x  x
 *   O--O--O-  <---- (7*a +   b + 4) >> 3
 *   O--O--O-  <---- (5*a + 3*b + 4) >> 3
 *   O--O--O-  <---- (3*a + 5*b + 4) >> 3
 *   O--O--O-  <-----(  a + 7*b + 4) >> 3
 * b x  x  x
 *   O--O--O-
 *   O--O--O-
 */
#define MAKE_UPSAMPLE_V4(type)                                          \
static void                                                             \
video_chroma_up_v4_##type (GstVideoChromaResample *resample,            \
    gpointer lines[], gint width)                                       \
{                                                                       \
  gint i;                                                               \
  type *l0 = lines[0];                                                  \
  type *l1 = lines[1];                                                  \
  type *l2 = lines[2];                                                  \
  type *l3 = lines[3];                                                  \
  type tr0, tr1;                                                        \
  type tb0, tb1;                                                        \
                                                                        \
  if (resample->h_resample) {                                           \
    if (l0 != l1) {                                                     \
      resample->h_resample (resample, l0, width);                       \
      resample->h_resample (resample, l1, width);                       \
    }                                                                   \
    if (l2 != l3) {                                                     \
      resample->h_resample (resample, l2, width);                       \
      resample->h_resample (resample, l3, width);                       \
    }                                                                   \
  }                                                                     \
  if (l0 != l1 && l2 != l3) {                                           \
    for (i = 0; i < width; i++) {                                       \
      tr0 = PR0(i), tr1 = PR2(i);                                       \
      tb0 = PB0(i), tb1 = PB2(i);                                       \
                                                                        \
      PR0(i) = FILT_7_1 (tr0, tr1);                                     \
      PB0(i) = FILT_7_1 (tb0, tb1);                                     \
      PR1(i) = FILT_5_3 (tr0, tr1);                                     \
      PB1(i) = FILT_5_3 (tb0, tb1);                                     \
      PR2(i) = FILT_3_5 (tr0, tr1);                                     \
      PB2(i) = FILT_3_5 (tb0, tb1);                                     \
      PR3(i) = FILT_1_7 (tr0, tr1);                                     \
      PB3(i) = FILT_1_7 (tb0, tb1);                                     \
    }                                                                   \
  }                                                                     \
}
/* 4x vertical upsampling interlaced without cositing
 *
 */
#define MAKE_UPSAMPLE_VI4(type)                                         \
static void                                                             \
video_chroma_up_vi4_##type (GstVideoChromaResample *resample,           \
    gpointer lines[], gint width)                                       \
{                                                                       \
  /* FIXME */                                                           \
  if (resample->h_resample) {                                           \
    resample->h_resample (resample, lines[0], width);                   \
  }                                                                     \
}

/* 4x horizontal downsampling without cositing
 *
 *    +------ (a + b + c + d + 2) >> 2
 *    |
 *    v
 * ---O-------O---
 * x x x x x x x x
 * a b c d e f g h
 */
#define MAKE_DOWNSAMPLE_H4(type)                                        \
static void                                                             \
video_chroma_down_h4_##type (GstVideoChromaResample *resample,         \
    gpointer pixels, gint width)                        \
{                                                                       \
  type *p = pixels;                                                     \
  gint i;                                                               \
                                                                        \
  for (i = 0; i < width - 4; i += 4) {                                  \
    type tr0 = PR(i), tr1 = PR(i+1), tr2 = PR(i+2), tr3 = PR(i+3);      \
    type tb0 = PB(i), tb1 = PB(i+1), tb2 = PB(i+2), tb3 = PB(i+3);      \
                                                                        \
    PR(i) = FILT_1_1_1_1 (tr0, tr1, tr2, tr3);                          \
    PB(i) = FILT_1_1_1_1 (tb0, tb1, tb2, tb3);                          \
  }                                                                     \
}

/* 4x vertical downsampling without cositing
 *
 * a x--x--x-
 * b x--x--x-
 *   O  O  O   <---- (a + b + c + d + 2) >> 2
 * c x--x--x-
 * d x--x--x-
 * e x--x--x-
 * f x--x--x-
 *   O  O  O
 * g x--x--x-
 * h x--x--x-
 */
#define MAKE_DOWNSAMPLE_V4(type)                                        \
static void                                                             \
video_chroma_down_v4_##type (GstVideoChromaResample *resample,          \
    gpointer lines[], gint width)                                       \
{                                                                       \
  gint i;                                                               \
  type *l0 = lines[0];                                                  \
  type *l1 = lines[1];                                                  \
  type *l2 = lines[2];                                                  \
  type *l3 = lines[3];                                                  \
                                                                        \
  if (resample->h_resample) {                                           \
    resample->h_resample (resample, l0, width);                         \
    if (l0 != l1)                                                       \
      resample->h_resample (resample, l1, width);                       \
    if (l1 != l2)                                                       \
      resample->h_resample (resample, l2, width);                       \
    if (l2 != l3)                                                       \
      resample->h_resample (resample, l3, width);                       \
  }                                                                     \
  for (i = 0; i < width; i++) {                                         \
    type tr0 = PR0(i), tr1 = PR1(i);                                    \
    type tr2 = PR2(i), tr3 = PR3(i);                                    \
    type tb0 = PB0(i), tb1 = PB1(i);                                    \
    type tb2 = PB2(i), tb3 = PB3(i);                                    \
                                                                        \
    PR0(i) = FILT_1_1_1_1 (tr0, tr1, tr2, tr3);                         \
    PB0(i) = FILT_1_1_1_1 (tb0, tb1, tb2, tb3);                         \
  }                                                                     \
}
/* 4x vertical downsampling interlaced without cositing
 *
 */
#define MAKE_DOWNSAMPLE_VI4(type)                                       \
static void                                                             \
video_chroma_down_vi4_##type (GstVideoChromaResample *resample,         \
    gpointer lines[], gint width)                                       \
{                                                                       \
  /* FIXME */                                                           \
  if (resample->h_resample) {                                           \
    resample->h_resample (resample, lines[0], width);                   \
  }                                                                     \
}

MAKE_UPSAMPLE_H4 (guint16);
MAKE_UPSAMPLE_H4 (guint8);
MAKE_UPSAMPLE_V4 (guint16);
MAKE_UPSAMPLE_V4 (guint8);
MAKE_UPSAMPLE_VI4 (guint16);
MAKE_UPSAMPLE_VI4 (guint8);
MAKE_DOWNSAMPLE_H4 (guint16);
MAKE_DOWNSAMPLE_H4 (guint8);
MAKE_DOWNSAMPLE_V4 (guint16);
MAKE_DOWNSAMPLE_V4 (guint8);
MAKE_DOWNSAMPLE_VI4 (guint16);
MAKE_DOWNSAMPLE_VI4 (guint8);

/* 2x horizontal upsampling with cositing
 *
 * a +------ (a + b + 1) >> 1
 * | |
 * v v
 * O-O-O-O
 * x   x
 * a   b
 */
#define MAKE_UPSAMPLE_H2_CS(type)                                       \
static void                                                             \
video_chroma_up_h2_cs_##type (GstVideoChromaResample *resample,         \
    gpointer pixels, gint width)                                        \
{                                                                       \
  type *p = pixels;                                                     \
  gint i;                                                               \
                                                                        \
  for (i = 1; i < width - 1; i += 2) {                                  \
    PR(i) = FILT_1_1 (PR(i-1), PR(i+1));                                \
    PB(i) = FILT_1_1 (PB(i-1), PB(i+1));                                \
  }                                                                     \
}
/* 2x vertical upsampling with cositing
 *
 * a x O--O--O-  <---- a
 *     O--O--O-  <---- (a +  b + 1) >> 1
 * b x O--O--O-
 *     O--O--O-
 */
#define MAKE_UPSAMPLE_V2_CS(type)                                       \
static void                                                             \
video_chroma_up_v2_cs_##type (GstVideoChromaResample *resample,         \
    gpointer lines[], gint width)                                       \
{                                                                       \
  /* FIXME */                                                           \
  if (resample->h_resample) {                                           \
    resample->h_resample (resample, lines[0], width);                   \
  }                                                                     \
}
/* 2x vertical upsampling interlaced with cositing
 *
 */
#define MAKE_UPSAMPLE_VI2_CS(type)                                      \
static void                                                             \
video_chroma_up_vi2_cs_##type (GstVideoChromaResample *resample,        \
    gpointer lines[], gint width)                                       \
{                                                                       \
  /* FIXME */                                                           \
  if (resample->h_resample) {                                           \
    resample->h_resample (resample, lines[0], width);                   \
  }                                                                     \
}

/* 2x horizontal downsampling with cositing
 *
 * a
 * |   +------ (b + 2*c + d + 2) >> 2
 * v   v
 * O---O---O---
 * x x x x x x
 * a b c d e f
 */
#define MAKE_DOWNSAMPLE_H2_CS(type)                                     \
static void                                                             \
video_chroma_down_h2_cs_##type (GstVideoChromaResample *resample,       \
    gpointer pixels, gint width)                                        \
{                                                                       \
  type *p = pixels;                                                     \
  gint i;                                                               \
                                                                        \
  if (width < 2)                                                        \
    return;                                                             \
                                                                        \
  PR(0) = FILT_3_1 (PR(0), PR(1));                                      \
  PB(0) = FILT_3_1 (PB(0), PB(1));                                      \
                                                                        \
  for (i = 2; i < width - 2; i += 2) {                                  \
    PR(i) = FILT_1_2_1 (PR(i-1), PR(i), PR(i+1));                       \
    PB(i) = FILT_1_2_1 (PB(i-1), PB(i), PB(i+1));                       \
  }                                                                     \
  if (i < width) {                                                      \
    PR(i) = FILT_1_3 (PR(i-1), PR(i));                                  \
    PB(i) = FILT_1_3 (PB(i-1), PB(i));                                  \
  }                                                                     \
}
/* 2x vertical downsampling with cositing
 *
 * a x O--O--O-  <---- a
 * b x --------
 * c x O--O--O-  <---- (b + 2*c + d + 2) >> 2
 * d x --------
 * e x O--O--O-
 * f x --------
 */
#define MAKE_DOWNSAMPLE_V2_CS(type)                                     \
static void                                                             \
video_chroma_down_v2_cs_##type (GstVideoChromaResample *resample,       \
    gpointer lines[], gint width)                                       \
{                                                                       \
  /* FIXME */                                                           \
  if (resample->h_resample) {                                           \
    resample->h_resample (resample, lines[0], width);                   \
  }                                                                     \
}
/* 2x vertical downsampling interlaced with cositing
 *
 */
#define MAKE_DOWNSAMPLE_VI2_CS(type)                                    \
static void                                                             \
video_chroma_down_vi2_cs_##type (GstVideoChromaResample *resample,      \
    gpointer lines[], gint width)                                       \
{                                                                       \
  /* FIXME */                                                           \
  if (resample->h_resample) {                                           \
    resample->h_resample (resample, lines[0], width);                   \
  }                                                                     \
}

MAKE_UPSAMPLE_H2_CS (guint16);
MAKE_UPSAMPLE_H2_CS (guint8);
MAKE_UPSAMPLE_V2_CS (guint16);
MAKE_UPSAMPLE_V2_CS (guint8);
MAKE_UPSAMPLE_VI2_CS (guint16);
MAKE_UPSAMPLE_VI2_CS (guint8);
MAKE_DOWNSAMPLE_H2_CS (guint16);
MAKE_DOWNSAMPLE_H2_CS (guint8);
MAKE_DOWNSAMPLE_V2_CS (guint16);
MAKE_DOWNSAMPLE_V2_CS (guint8);
MAKE_DOWNSAMPLE_VI2_CS (guint16);
MAKE_DOWNSAMPLE_VI2_CS (guint8);

/* 4x horizontal upsampling with cositing
 *
 *   +---------- (3*a +   b + 2) >> 2
 * a | +-------- (  a +   b + 1) >> 1
 * | | | +------ (  a + 3*b + 2) >> 2
 * v v v v
 * O-O-O-O-O-O-O-O
 * x       x
 * a       b
 */
#define MAKE_UPSAMPLE_H4_CS(type)                                       \
static void                                                             \
video_chroma_up_h4_cs_##type (GstVideoChromaResample *resample,        \
    gpointer pixels, gint width)                        \
{                                                                       \
  type *p = pixels;                                                        \
  gint i;                                                               \
                                                                        \
  for (i = 0; i < width - 4; i += 4) {                                  \
    type tr0 = PR(i), tr1 = PR(i+4);                                    \
    type tb0 = PB(i), tb1 = PB(i+4);                                    \
                                                                        \
    PR(i+1) = FILT_3_1 (tr0, tr1);                                      \
    PB(i+1) = FILT_3_1 (tb0, tb1);                                      \
    PR(i+2) = FILT_1_1 (tr0, tr1);                                      \
    PB(i+2) = FILT_1_1 (tb0, tb1);                                      \
    PR(i+3) = FILT_1_3 (tr0, tr1);                                      \
    PB(i+3) = FILT_1_3 (tb0, tb1);                                      \
  }                                                                     \
}
/* 4x vertical upsampling with cositing
 *
 * a x O--O--O-  <---- a
 *     O--O--O-  <---- (3*a +   b + 2) >> 2
 *     O--O--O-  <---- (  a +   b + 1) >> 1
 *     O--O--O-  <---- (  a + 3*b + 2) >> 2
 * b x O--O--O-
 *     O--O--O-
 */
#define MAKE_UPSAMPLE_V4_CS(type)                                       \
static void                                                             \
video_chroma_up_v4_cs_##type (GstVideoChromaResample *resample,         \
    gpointer lines[], gint width)                                       \
{                                                                       \
  /* FIXME */                                                           \
  if (resample->h_resample) {                                           \
    resample->h_resample (resample, lines[0], width);                   \
  }                                                                     \
}
/* 4x vertical upsampling interlaced with cositing
 *
 */
#define MAKE_UPSAMPLE_VI4_CS(type)                                      \
static void                                                             \
video_chroma_up_vi4_cs_##type (GstVideoChromaResample *resample,        \
    gpointer lines[], gint width)                                       \
{                                                                       \
  /* FIXME */                                                           \
  if (resample->h_resample) {                                           \
    resample->h_resample (resample, lines[0], width);                   \
  }                                                                     \
}
/* 4x horizontal downsampling with cositing
 *
 * a
 * |       +------ (b + 2*c + 3*d + 4*e + 3*f + 2*g + h + 8) >> 16
 * v       v
 * O-------O-------
 * x x x x x x x x
 * a b c d e f g h
 */
#define MAKE_DOWNSAMPLE_H4_CS(type)                                     \
static void                                                             \
video_chroma_down_h4_cs_##type (GstVideoChromaResample *resample,      \
    gpointer pixels, gint width)                        \
{                                                                       \
  type *p = pixels;                                                     \
  gint i;                                                               \
                                                                        \
  if (width < 4)                                                        \
    return;                                                             \
                                                                        \
  PR(0) = FILT_10_3_2_1 (PR(0), PR(1), PR(2), PR(3));                   \
  PB(0) = FILT_10_3_2_1 (PB(0), PB(1), PB(2), PB(3));                   \
                                                                        \
  for (i = 4; i < width - 4; i += 4) {                                  \
    PR(i) = FILT_1_2_3_4_3_2_1 (PR(i-3), PR(i-2), PR(i-1), PR(i), PR(i+1), PR(i+2), PR(i+3));   \
    PB(i) = FILT_1_2_3_4_3_2_1 (PB(i-3), PB(i-2), PB(i-1), PB(i), PB(i+1), PB(i+2), PB(i+3));   \
  }                                                                     \
  if (i < width) {                                                      \
    PR(i) = FILT_1_2_3_10 (PR(i-3), PR(i-2), PR(i-1), PR(i));           \
    PB(i) = FILT_1_2_3_10 (PB(i-3), PB(i-2), PB(i-1), PB(i));           \
  }                                                                     \
}
/* 4x vertical downsampling with cositing
 *
 * a x O--O--O-  <---- a
 * b x --------
 * c x --------
 * d x --------
 * e x O--O--O-  <---- (b + 2*c + 3*d + 4*e + 3*f + 2*g + h + 8) >> 16
 * f x --------
 * g x --------
 * h x --------
 * i x O--O--O-
 * j x --------
 */
#define MAKE_DOWNSAMPLE_V4_CS(type)                                     \
static void                                                             \
video_chroma_down_v4_cs_##type (GstVideoChromaResample *resample,       \
    gpointer lines[], gint width)                                       \
{                                                                       \
  /* FIXME */                                                           \
  if (resample->h_resample) {                                           \
    resample->h_resample (resample, lines[0], width);                   \
  }                                                                     \
}
/* 4x vertical downsampling interlaced with cositing
 *
 */
#define MAKE_DOWNSAMPLE_VI4_CS(type)                                    \
static void                                                             \
video_chroma_down_vi4_cs_##type (GstVideoChromaResample *resample,      \
    gpointer lines[], gint width)                                       \
{                                                                       \
  /* FIXME */                                                           \
  if (resample->h_resample) {                                           \
    resample->h_resample (resample, lines[0], width);                   \
  }                                                                     \
}

MAKE_UPSAMPLE_H4_CS (guint16);
MAKE_UPSAMPLE_H4_CS (guint8);
MAKE_UPSAMPLE_V4_CS (guint16);
MAKE_UPSAMPLE_V4_CS (guint8);
MAKE_UPSAMPLE_VI4_CS (guint16);
MAKE_UPSAMPLE_VI4_CS (guint8);
MAKE_DOWNSAMPLE_H4_CS (guint16);
MAKE_DOWNSAMPLE_H4_CS (guint8);
MAKE_DOWNSAMPLE_V4_CS (guint16);
MAKE_DOWNSAMPLE_V4_CS (guint8);
MAKE_DOWNSAMPLE_VI4_CS (guint16);
MAKE_DOWNSAMPLE_VI4_CS (guint8);

typedef struct
{
  void (*resample) (GstVideoChromaResample * resample, gpointer pixels,
      gint width);
} HorizResampler;

static const HorizResampler h_resamplers[] = {
  {NULL},
  {video_chroma_up_h2_guint8},
  {video_chroma_down_h2_guint8},
  {video_chroma_up_h2_guint16},
  {video_chroma_down_h2_guint16},
  {video_chroma_up_h2_cs_guint8},
  {video_chroma_down_h2_cs_guint8},
  {video_chroma_up_h2_cs_guint16},
  {video_chroma_down_h2_cs_guint16},
  {video_chroma_up_h4_guint8},
  {video_chroma_down_h4_guint8},
  {video_chroma_up_h4_guint16},
  {video_chroma_down_h4_guint16},
  {video_chroma_up_h4_cs_guint8},
  {video_chroma_down_h4_cs_guint8},
  {video_chroma_up_h4_cs_guint16},
  {video_chroma_down_h4_cs_guint16}
};

typedef struct
{
  void (*resample) (GstVideoChromaResample * resample, gpointer lines[],
      gint width);
  guint n_lines;
  gint offset;
} VertResampler;

static void
video_chroma_none (GstVideoChromaResample * resample,
    gpointer lines[], gint width)
{
  if (resample->h_resample)
    resample->h_resample (resample, lines[0], width);
}

static const VertResampler v_resamplers[] = {
  {video_chroma_none, 1, 0},
  {video_chroma_up_v2_guint8, 2, -1},
  {video_chroma_down_v2_guint8, 2, 0},
  /* 16 bits */
  {video_chroma_up_v2_guint16, 2, -1},
  {video_chroma_down_v2_guint16, 2, 0},
  /* cosited */
  {video_chroma_up_v2_cs_guint8, 1, 0}, /* IMPLEMENT ME */
  {video_chroma_down_v2_cs_guint8, 1, 0},       /* IMPLEMENT ME */
  {video_chroma_up_v2_cs_guint16, 1, 0},        /* IMPLEMENT ME */
  {video_chroma_down_v2_cs_guint16, 1, 0},      /* IMPLEMENT ME */
  /* 4x */
  {video_chroma_up_v4_guint8, 4, -2},
  {video_chroma_down_v4_guint8, 4, 0},
  {video_chroma_up_v4_guint16, 4, -2},
  {video_chroma_down_v4_guint16, 4, 0},
  {video_chroma_up_v4_cs_guint8, 1, 0}, /* IMPLEMENT ME */
  {video_chroma_down_v4_cs_guint8, 1, 0},       /* IMPLEMENT ME */
  {video_chroma_up_v4_cs_guint16, 1, 0},        /* IMPLEMENT ME */
  {video_chroma_down_v4_cs_guint16, 1, 0},      /* IMPLEMENT ME */
  /* interlaced */
  {video_chroma_up_vi2_guint8, 4, -2},
  {video_chroma_down_vi2_guint8, 1, 0}, /* IMPLEMENT ME */
  {video_chroma_up_vi2_guint16, 4, -2},
  {video_chroma_down_vi2_guint16, 1, 0},        /* IMPLEMENT ME */
  {video_chroma_up_vi2_cs_guint8, 1, 0},        /* IMPLEMENT ME */
  {video_chroma_down_vi2_cs_guint8, 1, 0},      /* IMPLEMENT ME */
  {video_chroma_up_vi2_cs_guint16, 1, 0},       /* IMPLEMENT ME */
  {video_chroma_down_vi2_cs_guint16, 1, 0},     /* IMPLEMENT ME */
  {video_chroma_up_vi4_guint8, 1, 0},   /* IMPLEMENT ME */
  {video_chroma_down_vi4_guint8, 1, 0}, /* IMPLEMENT ME */
  {video_chroma_up_vi4_guint16, 1, 0},  /* IMPLEMENT ME */
  {video_chroma_down_vi4_guint16, 1, 0},        /* IMPLEMENT ME */
  {video_chroma_up_vi4_cs_guint8, 1, 0},        /* IMPLEMENT ME */
  {video_chroma_down_vi4_cs_guint8, 1, 0},      /* IMPLEMENT ME */
  {video_chroma_up_vi4_cs_guint16, 1, 0},       /* IMPLEMENT ME */
  {video_chroma_down_vi4_cs_guint16, 1, 0},     /* IMPLEMENT ME */
};

/**
 * gst_video_chroma_resample_new:
 * @method: a #GstVideoChromaMethod
 * @site: a #GstVideoChromaSite
 * @flags: #GstVideoChromaFlags
 * @format: the #GstVideoFormat
 * @h_factor: horizontal resampling factor
 * @v_factor: vertical resampling factor
 *
 * Create a new resampler object for the given parameters. When @h_factor or
 * @v_factoris > 0, upsampling will be used, otherwise subsampling is
 * performed.
 *
 * Returns: a new #GstVideoChromaResample that should be freed with
 *     gst_video_chroma_resample_free() after usage.
 */
GstVideoChromaResample *
gst_video_chroma_resample_new (GstVideoChromaMethod method,
    GstVideoChromaSite site, GstVideoChromaFlags flags,
    GstVideoFormat format, gint h_factor, gint v_factor)
{
  GstVideoChromaResample *result;
  guint cosite, h_index, v_index, bits;

  /* no resampling */
  if (h_factor == 0 && v_factor == 0)
    return NULL;

  if (format == GST_VIDEO_FORMAT_AYUV)
    bits = 8;
  else if (format == GST_VIDEO_FORMAT_AYUV64)
    bits = 16;
  else
    return NULL;

  cosite = (site & GST_VIDEO_CHROMA_SITE_H_COSITED ? 1 : 0);
  if (h_factor == 0)
    h_index = 0;
  else
    h_index =
        ((ABS (h_factor) - 1) * 8) + (cosite ? 4 : 0) + (bits ==
        16 ? 2 : 0) + (h_factor < 0 ? 1 : 0) + 1;
  cosite = (site & GST_VIDEO_CHROMA_SITE_V_COSITED ? 1 : 0);
  if (v_factor == 0)
    v_index = 0;
  else
    v_index =
        ((ABS (v_factor) - 1) * 8) + (cosite ? 4 : 0) + (bits ==
        16 ? 2 : 0) + (v_factor < 0 ? 1 : 0) + 1;

  result = g_slice_new (GstVideoChromaResample);
  result->method = method;
  result->site = site;
  result->flags = flags;
  result->format = format;
  result->h_factor = h_factor;
  result->v_factor = v_factor;
  result->h_resample = h_resamplers[h_index].resample;
  result->v_resample = v_resamplers[v_index].resample;
  result->n_lines = v_resamplers[v_index].n_lines;
  result->offset = v_resamplers[v_index].offset;

  GST_DEBUG ("select resample %p %d, factor %d, "
      "cosite %d, bits %d", result, h_index, h_factor, cosite, bits);

  return result;
}

/**
 * gst_video_chroma_resample_get_info:
 * @resample: a #GstVideoChromaResample
 * @n_lines: the number of input lines
 * @offset: the first line
 *
 * The resampler must be fed @n_lines at a time. The first line should be
 * at @offset.
 */
void
gst_video_chroma_resample_get_info (GstVideoChromaResample * resample,
    guint * n_lines, gint * offset)
{
  g_return_if_fail (resample != NULL);

  if (n_lines)
    *n_lines = resample->n_lines;
  if (offset)
    *offset = resample->offset;
}

/**
 * gst_video_chroma_resample_free:
 * @resample: a #GstVideoChromaResample
 *
 * Free @resample
 */
void
gst_video_chroma_resample_free (GstVideoChromaResample * resample)
{
  g_return_if_fail (resample != NULL);

  g_slice_free (GstVideoChromaResample, resample);
}

/**
 * gst_video_chroma_resample:
 * @resample: a #GstVideoChromaResample
 * @lines: pixel lines
 * @width: the number of pixels on one line
 *
 * Perform resampling of @width chroma pixels in @lines.
 */
void
gst_video_chroma_resample (GstVideoChromaResample * resample,
    gpointer lines[], gint width)
{
  g_return_if_fail (resample != NULL);

  resample->v_resample (resample, lines, width);
}
