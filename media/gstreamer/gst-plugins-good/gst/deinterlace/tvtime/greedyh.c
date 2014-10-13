/*
 *
 * GStreamer
 * Copyright (C) 2004 Billy Biggs <vektor@dumbterm.net>
 * Copyright (C) 2008,2010 Sebastian Dröge <slomo@collabora.co.uk>
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

/*
 * Relicensed for GStreamer from GPL to LGPL with permit from Billy Biggs.
 * See: http://bugzilla.gnome.org/show_bug.cgi?id=163578
 */

#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

#include "greedyhmacros.h"

#include <stdlib.h>
#include <string.h>

#include <gst/gst.h>
#include "plugins.h"
#include "gstdeinterlacemethod.h"
#ifdef HAVE_ORC
#include <orc/orc.h>
#endif

#define GST_TYPE_DEINTERLACE_METHOD_GREEDY_H	(gst_deinterlace_method_greedy_h_get_type ())
#define GST_IS_DEINTERLACE_METHOD_GREEDY_H(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_DEINTERLACE_METHOD_GREEDY_H))
#define GST_IS_DEINTERLACE_METHOD_GREEDY_H_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_DEINTERLACE_METHOD_GREEDY_H))
#define GST_DEINTERLACE_METHOD_GREEDY_H_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), GST_TYPE_DEINTERLACE_METHOD_GREEDY_H, GstDeinterlaceMethodGreedyHClass))
#define GST_DEINTERLACE_METHOD_GREEDY_H(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_DEINTERLACE_METHOD_GREEDY_H, GstDeinterlaceMethodGreedyH))
#define GST_DEINTERLACE_METHOD_GREEDY_H_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_DEINTERLACE_METHOD_GREEDY_H, GstDeinterlaceMethodGreedyHClass))
#define GST_DEINTERLACE_METHOD_GREEDY_H_CAST(obj)	((GstDeinterlaceMethodGreedyH*)(obj))

typedef struct
{
  GstDeinterlaceMethod parent;

  guint max_comb, motion_threshold, motion_sense;
} GstDeinterlaceMethodGreedyH;

typedef void (*ScanlineFunction) (GstDeinterlaceMethodGreedyH * self,
    const guint8 * L2, const guint8 * L1, const guint8 * L3, const guint8 * L2P,
    guint8 * Dest, gint width);

typedef struct
{
  GstDeinterlaceMethodClass parent_class;
  ScanlineFunction scanline_yuy2;       /* This is for YVYU too */
  ScanlineFunction scanline_uyvy;
  ScanlineFunction scanline_ayuv;
  ScanlineFunction scanline_planar_y;
  ScanlineFunction scanline_planar_uv;
} GstDeinterlaceMethodGreedyHClass;

static void
greedyh_scanline_C_ayuv (GstDeinterlaceMethodGreedyH * self, const guint8 * L1,
    const guint8 * L2, const guint8 * L3, const guint8 * L2P, guint8 * Dest,
    gint width)
{
  gint Pos, Comp;
  guint8 l1, l1_1, l3, l3_1;
  guint8 avg, avg_1;
  guint8 avg__1[4] = { 0, };
  guint8 avg_s;
  guint8 avg_sc;
  guint8 best;
  guint16 mov;
  guint8 out;
  guint8 l2, lp2;
  guint8 l2_diff, lp2_diff;
  guint8 min, max;
  guint max_comb = self->max_comb;
  guint motion_sense = self->motion_sense;
  guint motion_threshold = self->motion_threshold;

  width /= 4;
  for (Pos = 0; Pos < width; Pos++) {
    for (Comp = 0; Comp < 4; Comp++) {
      l1 = L1[0];
      l3 = L3[0];

      if (Pos == width - 1) {
        l1_1 = l1;
        l3_1 = l3;
      } else {
        l1_1 = L1[4];
        l3_1 = L3[4];
      }

      /* Average of L1 and L3 */
      avg = (l1 + l3) / 2;

      if (Pos == 0) {
        avg__1[Comp] = avg;
      }

      /* Average of next L1 and next L3 */
      avg_1 = (l1_1 + l3_1) / 2;

      /* Calculate average of one pixel forward and previous */
      avg_s = (avg__1[Comp] + avg_1) / 2;

      /* Calculate average of center and surrounding pixels */
      avg_sc = (avg + avg_s) / 2;

      /* move forward */
      avg__1[Comp] = avg;

      /* Get best L2/L2P, i.e. least diff from above average */
      l2 = L2[0];
      lp2 = L2P[0];

      l2_diff = ABS (l2 - avg_sc);

      lp2_diff = ABS (lp2 - avg_sc);

      if (l2_diff > lp2_diff)
        best = lp2;
      else
        best = l2;

      /* Clip this best L2/L2P by L1/L3 and allow to differ by GreedyMaxComb */
      max = MAX (l1, l3);
      min = MIN (l1, l3);

      if (max < 256 - max_comb)
        max += max_comb;
      else
        max = 255;

      if (min > max_comb)
        min -= max_comb;
      else
        min = 0;

      out = CLAMP (best, min, max);

      if (Comp < 2) {
        /* Do motion compensation for luma, i.e. how much
         * the weave pixel differs */
        mov = ABS (l2 - lp2);
        if (mov > motion_threshold)
          mov -= motion_threshold;
        else
          mov = 0;

        mov = mov * motion_sense;
        if (mov > 256)
          mov = 256;

        /* Weighted sum on clipped weave pixel and average */
        out = (out * (256 - mov) + avg_sc * mov) / 256;
      }

      Dest[0] = out;

      Dest += 1;
      L1 += 1;
      L2 += 1;
      L3 += 1;
      L2P += 1;
    }
  }
}

static void
greedyh_scanline_C_yuy2 (GstDeinterlaceMethodGreedyH * self, const guint8 * L1,
    const guint8 * L2, const guint8 * L3, const guint8 * L2P, guint8 * Dest,
    gint width)
{
  gint Pos;
  guint8 l1_l, l1_1_l, l3_l, l3_1_l;
  guint8 l1_c, l1_1_c, l3_c, l3_1_c;
  guint8 avg_l, avg_c, avg_l_1, avg_c_1;
  guint8 avg_l__1 = 0, avg_c__1 = 0;
  guint8 avg_s_l, avg_s_c;
  guint8 avg_sc_l, avg_sc_c;
  guint8 best_l, best_c;
  guint16 mov_l;
  guint8 out_l, out_c;
  guint8 l2_l, l2_c, lp2_l, lp2_c;
  guint8 l2_l_diff, l2_c_diff, lp2_l_diff, lp2_c_diff;
  guint8 min_l, min_c, max_l, max_c;
  guint max_comb = self->max_comb;
  guint motion_sense = self->motion_sense;
  guint motion_threshold = self->motion_threshold;

  width /= 2;
  for (Pos = 0; Pos < width; Pos++) {
    l1_l = L1[0];
    l1_c = L1[1];
    l3_l = L3[0];
    l3_c = L3[1];

    if (Pos == width - 1) {
      l1_1_l = l1_l;
      l1_1_c = l1_c;
      l3_1_l = l3_l;
      l3_1_c = l3_c;
    } else {
      l1_1_l = L1[2];
      l1_1_c = L1[3];
      l3_1_l = L3[2];
      l3_1_c = L3[3];
    }

    /* Average of L1 and L3 */
    avg_l = (l1_l + l3_l) / 2;
    avg_c = (l1_c + l3_c) / 2;

    if (Pos == 0) {
      avg_l__1 = avg_l;
      avg_c__1 = avg_c;
    }

    /* Average of next L1 and next L3 */
    avg_l_1 = (l1_1_l + l3_1_l) / 2;
    avg_c_1 = (l1_1_c + l3_1_c) / 2;

    /* Calculate average of one pixel forward and previous */
    avg_s_l = (avg_l__1 + avg_l_1) / 2;
    avg_s_c = (avg_c__1 + avg_c_1) / 2;

    /* Calculate average of center and surrounding pixels */
    avg_sc_l = (avg_l + avg_s_l) / 2;
    avg_sc_c = (avg_c + avg_s_c) / 2;

    /* move forward */
    avg_l__1 = avg_l;
    avg_c__1 = avg_c;

    /* Get best L2/L2P, i.e. least diff from above average */
    l2_l = L2[0];
    l2_c = L2[1];
    lp2_l = L2P[0];
    lp2_c = L2P[1];

    l2_l_diff = ABS (l2_l - avg_sc_l);
    l2_c_diff = ABS (l2_c - avg_sc_c);

    lp2_l_diff = ABS (lp2_l - avg_sc_l);
    lp2_c_diff = ABS (lp2_c - avg_sc_c);

    if (l2_l_diff > lp2_l_diff)
      best_l = lp2_l;
    else
      best_l = l2_l;

    if (l2_c_diff > lp2_c_diff)
      best_c = lp2_c;
    else
      best_c = l2_c;

    /* Clip this best L2/L2P by L1/L3 and allow to differ by GreedyMaxComb */
    max_l = MAX (l1_l, l3_l);
    min_l = MIN (l1_l, l3_l);

    if (max_l < 256 - max_comb)
      max_l += max_comb;
    else
      max_l = 255;

    if (min_l > max_comb)
      min_l -= max_comb;
    else
      min_l = 0;

    max_c = MAX (l1_c, l3_c);
    min_c = MIN (l1_c, l3_c);

    if (max_c < 256 - max_comb)
      max_c += max_comb;
    else
      max_c = 255;

    if (min_c > max_comb)
      min_c -= max_comb;
    else
      min_c = 0;

    out_l = CLAMP (best_l, min_l, max_l);
    out_c = CLAMP (best_c, min_c, max_c);

    /* Do motion compensation for luma, i.e. how much
     * the weave pixel differs */
    mov_l = ABS (l2_l - lp2_l);
    if (mov_l > motion_threshold)
      mov_l -= motion_threshold;
    else
      mov_l = 0;

    mov_l = mov_l * motion_sense;
    if (mov_l > 256)
      mov_l = 256;

    /* Weighted sum on clipped weave pixel and average */
    out_l = (out_l * (256 - mov_l) + avg_sc_l * mov_l) / 256;

    Dest[0] = out_l;
    Dest[1] = out_c;

    Dest += 2;
    L1 += 2;
    L2 += 2;
    L3 += 2;
    L2P += 2;
  }
}

static void
greedyh_scanline_C_uyvy (GstDeinterlaceMethodGreedyH * self, const guint8 * L1,
    const guint8 * L2, const guint8 * L3, const guint8 * L2P, guint8 * Dest,
    gint width)
{
  gint Pos;
  guint8 l1_l, l1_1_l, l3_l, l3_1_l;
  guint8 l1_c, l1_1_c, l3_c, l3_1_c;
  guint8 avg_l, avg_c, avg_l_1, avg_c_1;
  guint8 avg_l__1 = 0, avg_c__1 = 0;
  guint8 avg_s_l, avg_s_c;
  guint8 avg_sc_l, avg_sc_c;
  guint8 best_l, best_c;
  guint16 mov_l;
  guint8 out_l, out_c;
  guint8 l2_l, l2_c, lp2_l, lp2_c;
  guint8 l2_l_diff, l2_c_diff, lp2_l_diff, lp2_c_diff;
  guint8 min_l, min_c, max_l, max_c;
  guint max_comb = self->max_comb;
  guint motion_sense = self->motion_sense;
  guint motion_threshold = self->motion_threshold;

  width /= 2;
  for (Pos = 0; Pos < width; Pos++) {
    l1_l = L1[1];
    l1_c = L1[0];
    l3_l = L3[1];
    l3_c = L3[0];

    if (Pos == width - 1) {
      l1_1_l = l1_l;
      l1_1_c = l1_c;
      l3_1_l = l3_l;
      l3_1_c = l3_c;
    } else {
      l1_1_l = L1[3];
      l1_1_c = L1[2];
      l3_1_l = L3[3];
      l3_1_c = L3[2];
    }

    /* Average of L1 and L3 */
    avg_l = (l1_l + l3_l) / 2;
    avg_c = (l1_c + l3_c) / 2;

    if (Pos == 0) {
      avg_l__1 = avg_l;
      avg_c__1 = avg_c;
    }

    /* Average of next L1 and next L3 */
    avg_l_1 = (l1_1_l + l3_1_l) / 2;
    avg_c_1 = (l1_1_c + l3_1_c) / 2;

    /* Calculate average of one pixel forward and previous */
    avg_s_l = (avg_l__1 + avg_l_1) / 2;
    avg_s_c = (avg_c__1 + avg_c_1) / 2;

    /* Calculate average of center and surrounding pixels */
    avg_sc_l = (avg_l + avg_s_l) / 2;
    avg_sc_c = (avg_c + avg_s_c) / 2;

    /* move forward */
    avg_l__1 = avg_l;
    avg_c__1 = avg_c;

    /* Get best L2/L2P, i.e. least diff from above average */
    l2_l = L2[1];
    l2_c = L2[0];
    lp2_l = L2P[1];
    lp2_c = L2P[0];

    l2_l_diff = ABS (l2_l - avg_sc_l);
    l2_c_diff = ABS (l2_c - avg_sc_c);

    lp2_l_diff = ABS (lp2_l - avg_sc_l);
    lp2_c_diff = ABS (lp2_c - avg_sc_c);

    if (l2_l_diff > lp2_l_diff)
      best_l = lp2_l;
    else
      best_l = l2_l;

    if (l2_c_diff > lp2_c_diff)
      best_c = lp2_c;
    else
      best_c = l2_c;

    /* Clip this best L2/L2P by L1/L3 and allow to differ by GreedyMaxComb */
    max_l = MAX (l1_l, l3_l);
    min_l = MIN (l1_l, l3_l);

    if (max_l < 256 - max_comb)
      max_l += max_comb;
    else
      max_l = 255;

    if (min_l > max_comb)
      min_l -= max_comb;
    else
      min_l = 0;

    max_c = MAX (l1_c, l3_c);
    min_c = MIN (l1_c, l3_c);

    if (max_c < 256 - max_comb)
      max_c += max_comb;
    else
      max_c = 255;

    if (min_c > max_comb)
      min_c -= max_comb;
    else
      min_c = 0;

    out_l = CLAMP (best_l, min_l, max_l);
    out_c = CLAMP (best_c, min_c, max_c);

    /* Do motion compensation for luma, i.e. how much
     * the weave pixel differs */
    mov_l = ABS (l2_l - lp2_l);
    if (mov_l > motion_threshold)
      mov_l -= motion_threshold;
    else
      mov_l = 0;

    mov_l = mov_l * motion_sense;
    if (mov_l > 256)
      mov_l = 256;

    /* Weighted sum on clipped weave pixel and average */
    out_l = (out_l * (256 - mov_l) + avg_sc_l * mov_l) / 256;

    Dest[1] = out_l;
    Dest[0] = out_c;

    Dest += 2;
    L1 += 2;
    L2 += 2;
    L3 += 2;
    L2P += 2;
  }
}

static void
greedyh_scanline_C_planar_y (GstDeinterlaceMethodGreedyH * self,
    const guint8 * L1, const guint8 * L2, const guint8 * L3, const guint8 * L2P,
    guint8 * Dest, gint width)
{
  gint Pos;
  guint8 l1, l1_1, l3, l3_1;
  guint8 avg, avg_1;
  guint8 avg__1 = 0;
  guint8 avg_s;
  guint8 avg_sc;
  guint8 best;
  guint16 mov;
  guint8 out;
  guint8 l2, lp2;
  guint8 l2_diff, lp2_diff;
  guint8 min, max;
  guint max_comb = self->max_comb;
  guint motion_sense = self->motion_sense;
  guint motion_threshold = self->motion_threshold;

  for (Pos = 0; Pos < width; Pos++) {
    l1 = L1[0];
    l3 = L3[0];

    if (Pos == width - 1) {
      l1_1 = l1;
      l3_1 = l3;
    } else {
      l1_1 = L1[1];
      l3_1 = L3[1];
    }

    /* Average of L1 and L3 */
    avg = (l1 + l3) / 2;

    if (Pos == 0) {
      avg__1 = avg;
    }

    /* Average of next L1 and next L3 */
    avg_1 = (l1_1 + l3_1) / 2;

    /* Calculate average of one pixel forward and previous */
    avg_s = (avg__1 + avg_1) / 2;

    /* Calculate average of center and surrounding pixels */
    avg_sc = (avg + avg_s) / 2;

    /* move forward */
    avg__1 = avg;

    /* Get best L2/L2P, i.e. least diff from above average */
    l2 = L2[0];
    lp2 = L2P[0];

    l2_diff = ABS (l2 - avg_sc);

    lp2_diff = ABS (lp2 - avg_sc);

    if (l2_diff > lp2_diff)
      best = lp2;
    else
      best = l2;

    /* Clip this best L2/L2P by L1/L3 and allow to differ by GreedyMaxComb */
    max = MAX (l1, l3);
    min = MIN (l1, l3);

    if (max < 256 - max_comb)
      max += max_comb;
    else
      max = 255;

    if (min > max_comb)
      min -= max_comb;
    else
      min = 0;

    out = CLAMP (best, min, max);

    /* Do motion compensation for luma, i.e. how much
     * the weave pixel differs */
    mov = ABS (l2 - lp2);
    if (mov > motion_threshold)
      mov -= motion_threshold;
    else
      mov = 0;

    mov = mov * motion_sense;
    if (mov > 256)
      mov = 256;

    /* Weighted sum on clipped weave pixel and average */
    out = (out * (256 - mov) + avg_sc * mov) / 256;

    Dest[0] = out;

    Dest += 1;
    L1 += 1;
    L2 += 1;
    L3 += 1;
    L2P += 1;
  }
}

static void
greedyh_scanline_C_planar_uv (GstDeinterlaceMethodGreedyH * self,
    const guint8 * L1, const guint8 * L2, const guint8 * L3, const guint8 * L2P,
    guint8 * Dest, gint width)
{
  gint Pos;
  guint8 l1, l1_1, l3, l3_1;
  guint8 avg, avg_1;
  guint8 avg__1 = 0;
  guint8 avg_s;
  guint8 avg_sc;
  guint8 best;
  guint8 out;
  guint8 l2, lp2;
  guint8 l2_diff, lp2_diff;
  guint8 min, max;
  guint max_comb = self->max_comb;

  for (Pos = 0; Pos < width; Pos++) {
    l1 = L1[0];
    l3 = L3[0];

    if (Pos == width - 1) {
      l1_1 = l1;
      l3_1 = l3;
    } else {
      l1_1 = L1[1];
      l3_1 = L3[1];
    }

    /* Average of L1 and L3 */
    avg = (l1 + l3) / 2;

    if (Pos == 0) {
      avg__1 = avg;
    }

    /* Average of next L1 and next L3 */
    avg_1 = (l1_1 + l3_1) / 2;

    /* Calculate average of one pixel forward and previous */
    avg_s = (avg__1 + avg_1) / 2;

    /* Calculate average of center and surrounding pixels */
    avg_sc = (avg + avg_s) / 2;

    /* move forward */
    avg__1 = avg;

    /* Get best L2/L2P, i.e. least diff from above average */
    l2 = L2[0];
    lp2 = L2P[0];

    l2_diff = ABS (l2 - avg_sc);

    lp2_diff = ABS (lp2 - avg_sc);

    if (l2_diff > lp2_diff)
      best = lp2;
    else
      best = l2;

    /* Clip this best L2/L2P by L1/L3 and allow to differ by GreedyMaxComb */
    max = MAX (l1, l3);
    min = MIN (l1, l3);

    if (max < 256 - max_comb)
      max += max_comb;
    else
      max = 255;

    if (min > max_comb)
      min -= max_comb;
    else
      min = 0;

    out = CLAMP (best, min, max);

    Dest[0] = out;

    Dest += 1;
    L1 += 1;
    L2 += 1;
    L3 += 1;
    L2P += 1;
  }
}

#ifdef BUILD_X86_ASM

#define IS_MMXEXT
#define SIMD_TYPE MMXEXT
#define C_FUNCT_YUY2 greedyh_scanline_C_yuy2
#define C_FUNCT_UYVY greedyh_scanline_C_uyvy
#define C_FUNCT_PLANAR_Y greedyh_scanline_C_planar_y
#define C_FUNCT_PLANAR_UV greedyh_scanline_C_planar_uv
#define FUNCT_NAME_YUY2 greedyh_scanline_MMXEXT_yuy2
#define FUNCT_NAME_UYVY greedyh_scanline_MMXEXT_uyvy
#define FUNCT_NAME_PLANAR_Y greedyh_scanline_MMXEXT_planar_y
#define FUNCT_NAME_PLANAR_UV greedyh_scanline_MMXEXT_planar_uv
#include "greedyh.asm"
#undef SIMD_TYPE
#undef IS_MMXEXT
#undef FUNCT_NAME_YUY2
#undef FUNCT_NAME_UYVY
#undef FUNCT_NAME_PLANAR_Y
#undef FUNCT_NAME_PLANAR_UV

#define IS_3DNOW
#define SIMD_TYPE 3DNOW
#define FUNCT_NAME_YUY2 greedyh_scanline_3DNOW_yuy2
#define FUNCT_NAME_UYVY greedyh_scanline_3DNOW_uyvy
#define FUNCT_NAME_PLANAR_Y greedyh_scanline_3DNOW_planar_y
#define FUNCT_NAME_PLANAR_UV greedyh_scanline_3DNOW_planar_uv
#include "greedyh.asm"
#undef SIMD_TYPE
#undef IS_3DNOW
#undef FUNCT_NAME_YUY2
#undef FUNCT_NAME_UYVY
#undef FUNCT_NAME_PLANAR_Y
#undef FUNCT_NAME_PLANAR_UV

#define IS_MMX
#define SIMD_TYPE MMX
#define FUNCT_NAME_YUY2 greedyh_scanline_MMX_yuy2
#define FUNCT_NAME_UYVY greedyh_scanline_MMX_uyvy
#define FUNCT_NAME_PLANAR_Y greedyh_scanline_MMX_planar_y
#define FUNCT_NAME_PLANAR_UV greedyh_scanline_MMX_planar_uv
#include "greedyh.asm"
#undef SIMD_TYPE
#undef IS_MMX
#undef FUNCT_NAME_YUY2
#undef FUNCT_NAME_UYVY
#undef FUNCT_NAME_PLANAR_Y
#undef FUNCT_NAME_PLANAR_UV
#undef C_FUNCT_YUY2
#undef C_FUNCT_PLANAR_Y
#undef C_FUNCT_PLANAR_UV

#endif

static void
deinterlace_frame_di_greedyh_packed (GstDeinterlaceMethod * method,
    const GstDeinterlaceField * history, guint history_count,
    GstVideoFrame * outframe, int cur_field_idx)
{
  GstDeinterlaceMethodGreedyH *self = GST_DEINTERLACE_METHOD_GREEDY_H (method);
  GstDeinterlaceMethodGreedyHClass *klass =
      GST_DEINTERLACE_METHOD_GREEDY_H_GET_CLASS (self);
  gint InfoIsOdd = 0;
  gint Line;
  gint RowStride = GST_VIDEO_FRAME_COMP_STRIDE (outframe, 0);
  gint FieldHeight = GST_VIDEO_FRAME_HEIGHT (outframe) / 2;
  gint Pitch = RowStride * 2;
  const guint8 *L1;             // ptr to Line1, of 3
  const guint8 *L2;             // ptr to Line2, the weave line
  const guint8 *L3;             // ptr to Line3
  const guint8 *L2P;            // ptr to prev Line2
  guint8 *Dest = GST_VIDEO_FRAME_COMP_DATA (outframe, 0);
  ScanlineFunction scanline;

  if (cur_field_idx + 2 > history_count || cur_field_idx < 1) {
    GstDeinterlaceMethod *backup_method;

    backup_method = g_object_new (gst_deinterlace_method_linear_get_type (),
        NULL);

    gst_deinterlace_method_setup (backup_method, method->vinfo);
    gst_deinterlace_method_deinterlace_frame (backup_method,
        history, history_count, outframe, cur_field_idx);

    g_object_unref (backup_method);
    return;
  }

  cur_field_idx += 2;

  switch (GST_VIDEO_INFO_FORMAT (method->vinfo)) {
    case GST_VIDEO_FORMAT_YUY2:
    case GST_VIDEO_FORMAT_YVYU:
      scanline = klass->scanline_yuy2;
      break;
    case GST_VIDEO_FORMAT_UYVY:
      scanline = klass->scanline_uyvy;
      break;
    case GST_VIDEO_FORMAT_AYUV:
      scanline = klass->scanline_ayuv;
      break;
    default:
      g_assert_not_reached ();
      return;
  }

  // copy first even line no matter what, and the first odd line if we're
  // processing an EVEN field. (note diff from other deint rtns.)

  if (history[cur_field_idx - 1].flags == PICTURE_INTERLACED_BOTTOM) {
    InfoIsOdd = 1;

    L1 = GST_VIDEO_FRAME_COMP_DATA (history[cur_field_idx - 2].frame, 0);
    if (history[cur_field_idx - 2].flags & PICTURE_INTERLACED_BOTTOM)
      L1 += RowStride;

    L2 = GST_VIDEO_FRAME_COMP_DATA (history[cur_field_idx - 1].frame, 0);
    if (history[cur_field_idx - 1].flags & PICTURE_INTERLACED_BOTTOM)
      L2 += RowStride;

    L3 = L1 + Pitch;
    L2P = GST_VIDEO_FRAME_COMP_DATA (history[cur_field_idx - 3].frame, 0);
    if (history[cur_field_idx - 3].flags & PICTURE_INTERLACED_BOTTOM)
      L2P += RowStride;

    // copy first even line
    memcpy (Dest, L1, RowStride);
    Dest += RowStride;
  } else {
    InfoIsOdd = 0;
    L1 = GST_VIDEO_FRAME_COMP_DATA (history[cur_field_idx - 2].frame, 0);
    if (history[cur_field_idx - 2].flags & PICTURE_INTERLACED_BOTTOM)
      L1 += RowStride;

    L2 = (guint8 *) GST_VIDEO_FRAME_COMP_DATA (history[cur_field_idx -
            1].frame, 0) + Pitch;
    if (history[cur_field_idx - 1].flags & PICTURE_INTERLACED_BOTTOM)
      L2 += RowStride;

    L3 = L1 + Pitch;
    L2P =
        (guint8 *) GST_VIDEO_FRAME_COMP_DATA (history[cur_field_idx - 3].frame,
        0) + Pitch;
    if (history[cur_field_idx - 3].flags & PICTURE_INTERLACED_BOTTOM)
      L2P += RowStride;

    // copy first even line
    memcpy (Dest, L1, RowStride);
    Dest += RowStride;
    // then first odd line
    memcpy (Dest, L1, RowStride);
    Dest += RowStride;
  }

  for (Line = 0; Line < (FieldHeight - 1); ++Line) {
    scanline (self, L1, L2, L3, L2P, Dest, RowStride);
    Dest += RowStride;
    memcpy (Dest, L3, RowStride);
    Dest += RowStride;

    L1 += Pitch;
    L2 += Pitch;
    L3 += Pitch;
    L2P += Pitch;
  }

  if (InfoIsOdd) {
    memcpy (Dest, L2, RowStride);
  }
}

static void
deinterlace_frame_di_greedyh_planar_plane (GstDeinterlaceMethodGreedyH * self,
    const guint8 * L1, const guint8 * L2, const guint8 * L3, const guint8 * L2P,
    guint8 * Dest, gint RowStride, gint FieldHeight, gint Pitch, gint InfoIsOdd,
    ScanlineFunction scanline)
{
  gint Line;

  // copy first even line no matter what, and the first odd line if we're
  // processing an EVEN field. (note diff from other deint rtns.)

  if (InfoIsOdd) {
    // copy first even line
    memcpy (Dest, L1, RowStride);
    Dest += RowStride;
  } else {
    // copy first even line
    memcpy (Dest, L1, RowStride);
    Dest += RowStride;
    // then first odd line
    memcpy (Dest, L1, RowStride);
    Dest += RowStride;
  }

  for (Line = 0; Line < (FieldHeight - 1); ++Line) {
    scanline (self, L1, L2, L3, L2P, Dest, RowStride);
    Dest += RowStride;
    memcpy (Dest, L3, RowStride);
    Dest += RowStride;

    L1 += Pitch;
    L2 += Pitch;
    L3 += Pitch;
    L2P += Pitch;
  }

  if (InfoIsOdd) {
    memcpy (Dest, L2, RowStride);
  }
}

static void
deinterlace_frame_di_greedyh_planar (GstDeinterlaceMethod * method,
    const GstDeinterlaceField * history, guint history_count,
    GstVideoFrame * outframe, int cur_field_idx)
{
  GstDeinterlaceMethodGreedyH *self = GST_DEINTERLACE_METHOD_GREEDY_H (method);
  GstDeinterlaceMethodGreedyHClass *klass =
      GST_DEINTERLACE_METHOD_GREEDY_H_GET_CLASS (self);
  gint InfoIsOdd;
  gint RowStride;
  gint FieldHeight;
  gint Pitch;
  const guint8 *L1;             // ptr to Line1, of 3
  const guint8 *L2;             // ptr to Line2, the weave line
  const guint8 *L3;             // ptr to Line3
  const guint8 *L2P;            // ptr to prev Line2
  guint8 *Dest;
  gint i;
  ScanlineFunction scanline;

  if (cur_field_idx + 2 > history_count || cur_field_idx < 1) {
    GstDeinterlaceMethod *backup_method;

    backup_method = g_object_new (gst_deinterlace_method_linear_get_type (),
        NULL);

    gst_deinterlace_method_setup (backup_method, method->vinfo);
    gst_deinterlace_method_deinterlace_frame (backup_method,
        history, history_count, outframe, cur_field_idx);

    g_object_unref (backup_method);
    return;
  }

  cur_field_idx += 2;

  for (i = 0; i < 3; i++) {
    InfoIsOdd = (history[cur_field_idx - 1].flags == PICTURE_INTERLACED_BOTTOM);
    RowStride = GST_VIDEO_FRAME_COMP_STRIDE (outframe, i);
    FieldHeight = GST_VIDEO_FRAME_COMP_HEIGHT (outframe, i) / 2;
    Pitch = RowStride * 2;

    if (i == 0)
      scanline = klass->scanline_planar_y;
    else
      scanline = klass->scanline_planar_uv;

    Dest = GST_VIDEO_FRAME_COMP_DATA (outframe, i);

    L1 = GST_VIDEO_FRAME_COMP_DATA (history[cur_field_idx - 2].frame, i);
    if (history[cur_field_idx - 2].flags & PICTURE_INTERLACED_BOTTOM)
      L1 += RowStride;

    L2 = GST_VIDEO_FRAME_COMP_DATA (history[cur_field_idx - 1].frame, i);
    if (history[cur_field_idx - 1].flags & PICTURE_INTERLACED_BOTTOM)
      L2 += RowStride;

    L3 = L1 + Pitch;
    L2P = GST_VIDEO_FRAME_COMP_DATA (history[cur_field_idx - 3].frame, i);
    if (history[cur_field_idx - 3].flags & PICTURE_INTERLACED_BOTTOM)
      L2P += RowStride;

    deinterlace_frame_di_greedyh_planar_plane (self, L1, L2, L3, L2P, Dest,
        RowStride, FieldHeight, Pitch, InfoIsOdd, scanline);
  }
}

G_DEFINE_TYPE (GstDeinterlaceMethodGreedyH, gst_deinterlace_method_greedy_h,
    GST_TYPE_DEINTERLACE_METHOD);

enum
{
  PROP_0,
  PROP_MAX_COMB,
  PROP_MOTION_THRESHOLD,
  PROP_MOTION_SENSE
};

static void
gst_deinterlace_method_greedy_h_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstDeinterlaceMethodGreedyH *self = GST_DEINTERLACE_METHOD_GREEDY_H (object);

  switch (prop_id) {
    case PROP_MAX_COMB:
      self->max_comb = g_value_get_uint (value);
      break;
    case PROP_MOTION_THRESHOLD:
      self->motion_threshold = g_value_get_uint (value);
      break;
    case PROP_MOTION_SENSE:
      self->motion_sense = g_value_get_uint (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
  }
}

static void
gst_deinterlace_method_greedy_h_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstDeinterlaceMethodGreedyH *self = GST_DEINTERLACE_METHOD_GREEDY_H (object);

  switch (prop_id) {
    case PROP_MAX_COMB:
      g_value_set_uint (value, self->max_comb);
      break;
    case PROP_MOTION_THRESHOLD:
      g_value_set_uint (value, self->motion_threshold);
      break;
    case PROP_MOTION_SENSE:
      g_value_set_uint (value, self->motion_sense);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
  }
}

static void
gst_deinterlace_method_greedy_h_class_init (GstDeinterlaceMethodGreedyHClass *
    klass)
{
  GstDeinterlaceMethodClass *dim_class = (GstDeinterlaceMethodClass *) klass;
  GObjectClass *gobject_class = (GObjectClass *) klass;
#ifdef BUILD_X86_ASM
  guint cpu_flags =
      orc_target_get_default_flags (orc_target_get_by_name ("mmx"));
#endif

  gobject_class->set_property = gst_deinterlace_method_greedy_h_set_property;
  gobject_class->get_property = gst_deinterlace_method_greedy_h_get_property;

  g_object_class_install_property (gobject_class, PROP_MAX_COMB,
      g_param_spec_uint ("max-comb",
          "Max comb",
          "Max Comb", 0, 255, 5, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS)
      );

  g_object_class_install_property (gobject_class, PROP_MOTION_THRESHOLD,
      g_param_spec_uint ("motion-threshold",
          "Motion Threshold",
          "Motion Threshold",
          0, 255, 25, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS)
      );

  g_object_class_install_property (gobject_class, PROP_MOTION_SENSE,
      g_param_spec_uint ("motion-sense",
          "Motion Sense",
          "Motion Sense",
          0, 255, 30, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS)
      );

  dim_class->fields_required = 4;
  dim_class->name = "Motion Adaptive: Advanced Detection";
  dim_class->nick = "greedyh";
  dim_class->latency = 1;

  dim_class->deinterlace_frame_yuy2 = deinterlace_frame_di_greedyh_packed;
  dim_class->deinterlace_frame_yvyu = deinterlace_frame_di_greedyh_packed;
  dim_class->deinterlace_frame_uyvy = deinterlace_frame_di_greedyh_packed;
  dim_class->deinterlace_frame_ayuv = deinterlace_frame_di_greedyh_packed;
  dim_class->deinterlace_frame_y444 = deinterlace_frame_di_greedyh_planar;
  dim_class->deinterlace_frame_i420 = deinterlace_frame_di_greedyh_planar;
  dim_class->deinterlace_frame_yv12 = deinterlace_frame_di_greedyh_planar;
  dim_class->deinterlace_frame_y42b = deinterlace_frame_di_greedyh_planar;
  dim_class->deinterlace_frame_y41b = deinterlace_frame_di_greedyh_planar;

#ifdef BUILD_X86_ASM
  if (cpu_flags & ORC_TARGET_MMX_MMXEXT) {
    klass->scanline_yuy2 = greedyh_scanline_MMXEXT_yuy2;
    klass->scanline_uyvy = greedyh_scanline_MMXEXT_uyvy;
  } else if (cpu_flags & ORC_TARGET_MMX_3DNOW) {
    klass->scanline_yuy2 = greedyh_scanline_3DNOW_yuy2;
    klass->scanline_uyvy = greedyh_scanline_3DNOW_uyvy;
  } else if (cpu_flags & ORC_TARGET_MMX_MMX) {
    klass->scanline_yuy2 = greedyh_scanline_MMX_yuy2;
    klass->scanline_uyvy = greedyh_scanline_MMX_uyvy;
  } else {
    klass->scanline_yuy2 = greedyh_scanline_C_yuy2;
    klass->scanline_uyvy = greedyh_scanline_C_uyvy;
  }
#else
  klass->scanline_yuy2 = greedyh_scanline_C_yuy2;
  klass->scanline_uyvy = greedyh_scanline_C_uyvy;
#endif
  /* TODO: MMX implementation of these two */
  klass->scanline_ayuv = greedyh_scanline_C_ayuv;
  klass->scanline_planar_y = greedyh_scanline_C_planar_y;
  klass->scanline_planar_uv = greedyh_scanline_C_planar_uv;
}

static void
gst_deinterlace_method_greedy_h_init (GstDeinterlaceMethodGreedyH * self)
{
  self->max_comb = 5;
  self->motion_threshold = 25;
  self->motion_sense = 30;
}
