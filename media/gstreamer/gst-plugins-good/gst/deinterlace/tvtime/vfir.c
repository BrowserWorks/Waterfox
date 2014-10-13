/*
 *
 * GStreamer
 * Copyright (C) 2004 Billy Biggs <vektor@dumbterm.net>
 * Copyright (c) 2001, 2002, 2003 Fabrice Bellard.
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
 * This file contains code from ffmpeg, see http://ffmpeg.org/ (LGPL)
 * and modifications by Billy Biggs.
 *
 * Relicensed for GStreamer from GPL to LGPL with permit from Billy Biggs.
 * See: http://bugzilla.gnome.org/show_bug.cgi?id=163578
 */

#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

#include "gstdeinterlacemethod.h"
#include <string.h>
#ifdef HAVE_ORC
#include <orc/orc.h>
#endif
#include "tvtime.h"

#define GST_TYPE_DEINTERLACE_METHOD_VFIR	(gst_deinterlace_method_vfir_get_type ())
#define GST_IS_DEINTERLACE_METHOD_VFIR(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_DEINTERLACE_METHOD_VFIR))
#define GST_IS_DEINTERLACE_METHOD_VFIR_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_DEINTERLACE_METHOD_VFIR))
#define GST_DEINTERLACE_METHOD_VFIR_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), GST_TYPE_DEINTERLACE_METHOD_VFIR, GstDeinterlaceMethodVFIRClass))
#define GST_DEINTERLACE_METHOD_VFIR(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_DEINTERLACE_METHOD_VFIR, GstDeinterlaceMethodVFIR))
#define GST_DEINTERLACE_METHOD_VFIR_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_DEINTERLACE_METHOD_VFIR, GstDeinterlaceMethodVFIRClass))
#define GST_DEINTERLACE_METHOD_VFIR_CAST(obj)	((GstDeinterlaceMethodVFIR*)(obj))

GType gst_deinterlace_method_vfir_get_type (void);

typedef GstDeinterlaceSimpleMethod GstDeinterlaceMethodVFIR;

typedef GstDeinterlaceSimpleMethodClass GstDeinterlaceMethodVFIRClass;

/*
 * The MPEG2 spec uses a slightly harsher filter, they specify
 * [-1 8 2 8 -1].  ffmpeg uses a similar filter but with more of
 * a tendancy to blur than to use the local information.  The
 * filter taps here are: [-1 4 2 4 -1].
 */

 /*
  * C implementation.
  */
static inline void
deinterlace_c (guint8 * dst, const guint8 * lum_m4, const guint8 * lum_m3,
    const guint8 * lum_m2, const guint8 * lum_m1, const guint8 * lum, gint size)
{
  if (lum_m2 == NULL) {
    deinterlace_line_linear (dst, lum_m1, lum_m3, size);
  } else {
    deinterlace_line_vfir (dst, lum_m4, lum_m3, lum_m2, lum_m1, lum, size);
  }
}

static void
deinterlace_line_packed_c (GstDeinterlaceSimpleMethod * self, guint8 * dst,
    const GstDeinterlaceScanlineData * scanlines, guint size)
{
  const guint8 *lum_m4 = scanlines->tt1;
  const guint8 *lum_m3 = scanlines->t0;
  const guint8 *lum_m2 = scanlines->m1;
  const guint8 *lum_m1 = scanlines->b0;
  const guint8 *lum = scanlines->bb1;

  deinterlace_c (dst, lum_m4, lum_m3, lum_m2, lum_m1, lum, size);
}

static void
deinterlace_line_planar_y_c (GstDeinterlaceSimpleMethod * self, guint8 * dst,
    const GstDeinterlaceScanlineData * scanlines, guint size)
{
  const guint8 *lum_m4 = scanlines->tt1;
  const guint8 *lum_m3 = scanlines->t0;
  const guint8 *lum_m2 = scanlines->m1;
  const guint8 *lum_m1 = scanlines->b0;
  const guint8 *lum = scanlines->bb1;

  deinterlace_c (dst, lum_m4, lum_m3, lum_m2, lum_m1, lum, size);
}

static void
deinterlace_line_planar_u_c (GstDeinterlaceSimpleMethod * self, guint8 * dst,
    const GstDeinterlaceScanlineData * scanlines, guint size)
{
  const guint8 *lum_m4 = scanlines->tt1;
  const guint8 *lum_m3 = scanlines->t0;
  const guint8 *lum_m2 = scanlines->m1;
  const guint8 *lum_m1 = scanlines->b0;
  const guint8 *lum = scanlines->bb1;

  deinterlace_c (dst, lum_m4, lum_m3, lum_m2, lum_m1, lum, size);
}

static void
deinterlace_line_planar_v_c (GstDeinterlaceSimpleMethod * self, guint8 * dst,
    const GstDeinterlaceScanlineData * scanlines, guint size)
{
  const guint8 *lum_m4 = scanlines->tt1;
  const guint8 *lum_m3 = scanlines->t0;
  const guint8 *lum_m2 = scanlines->m1;
  const guint8 *lum_m1 = scanlines->b0;
  const guint8 *lum = scanlines->bb1;

  deinterlace_c (dst, lum_m4, lum_m3, lum_m2, lum_m1, lum, size);
}

#undef BUILD_X86_ASM

#ifdef BUILD_X86_ASM
#include "mmx.h"
static void
deinterlace_mmx (guint8 * dst, const guint8 * lum_m4, const guint8 * lum_m3,
    const guint8 * lum_m2, const guint8 * lum_m1, const guint8 * lum, gint size)
{
  mmx_t rounder;

  rounder.uw[0] = 4;
  rounder.uw[1] = 4;
  rounder.uw[2] = 4;
  rounder.uw[3] = 4;
  pxor_r2r (mm7, mm7);
  movq_m2r (rounder, mm6);

  for (; size > 3; size -= 4) {
    movd_m2r (*lum_m4, mm0);
    movd_m2r (*lum_m3, mm1);
    movd_m2r (*lum_m2, mm2);
    movd_m2r (*lum_m1, mm3);
    movd_m2r (*lum, mm4);
    punpcklbw_r2r (mm7, mm0);
    punpcklbw_r2r (mm7, mm1);
    punpcklbw_r2r (mm7, mm2);
    punpcklbw_r2r (mm7, mm3);
    punpcklbw_r2r (mm7, mm4);
    paddw_r2r (mm3, mm1);
    psllw_i2r (1, mm2);
    paddw_r2r (mm4, mm0);
    psllw_i2r (2, mm1);         // 2
    paddw_r2r (mm6, mm2);
    paddw_r2r (mm2, mm1);
    psubusw_r2r (mm0, mm1);
    psrlw_i2r (3, mm1);         // 3
    packuswb_r2r (mm7, mm1);
    movd_r2m (mm1, *dst);
    lum_m4 += 4;
    lum_m3 += 4;
    lum_m2 += 4;
    lum_m1 += 4;
    lum += 4;
    dst += 4;
  }
  emms ();

  /* Handle odd widths */
  if (size > 0)
    deinterlace_c (dst, lum_m4, lum_m3, lum_m2, lum_m1, lum, size);
}

static void
deinterlace_line_packed_mmx (GstDeinterlaceSimpleMethod * self, guint8 * dst,
    const GstDeinterlaceScanlineData * scanlines)
{
  const guint8 *lum_m4 = scanlines->tt1;
  const guint8 *lum_m3 = scanlines->t0;
  const guint8 *lum_m2 = scanlines->m1;
  const guint8 *lum_m1 = scanlines->b0;
  const guint8 *lum = scanlines->bb1;
  gint size = self->parent.row_stride[0];

  deinterlace_mmx (dst, lum_m4, lum_m3, lum_m2, lum_m1, lum, size);
}

static void
deinterlace_line_planar_y_mmx (GstDeinterlaceSimpleMethod * self, guint8 * dst,
    const GstDeinterlaceScanlineData * scanlines)
{
  const guint8 *lum_m4 = scanlines->tt1;
  const guint8 *lum_m3 = scanlines->t0;
  const guint8 *lum_m2 = scanlines->m1;
  const guint8 *lum_m1 = scanlines->b0;
  const guint8 *lum = scanlines->bb1;
  gint size = self->parent.row_stride[0];

  deinterlace_mmx (dst, lum_m4, lum_m3, lum_m2, lum_m1, lum, size);
}

static void
deinterlace_line_planar_u_mmx (GstDeinterlaceSimpleMethod * self, guint8 * dst,
    const GstDeinterlaceScanlineData * scanlines)
{
  const guint8 *lum_m4 = scanlines->tt1;
  const guint8 *lum_m3 = scanlines->t0;
  const guint8 *lum_m2 = scanlines->m1;
  const guint8 *lum_m1 = scanlines->b0;
  const guint8 *lum = scanlines->bb1;
  gint size = self->parent.row_stride[1];

  deinterlace_mmx (dst, lum_m4, lum_m3, lum_m2, lum_m1, lum, size);
}

static void
deinterlace_line_planar_v_mmx (GstDeinterlaceSimpleMethod * self, guint8 * dst,
    const GstDeinterlaceScanlineData * scanlines)
{
  const guint8 *lum_m4 = scanlines->tt1;
  const guint8 *lum_m3 = scanlines->t0;
  const guint8 *lum_m2 = scanlines->m1;
  const guint8 *lum_m1 = scanlines->b0;
  const guint8 *lum = scanlines->bb1;
  gint size = self->parent.row_stride[2];

  deinterlace_mmx (dst, lum_m4, lum_m3, lum_m2, lum_m1, lum, size);
}
#endif

G_DEFINE_TYPE (GstDeinterlaceMethodVFIR, gst_deinterlace_method_vfir,
    GST_TYPE_DEINTERLACE_SIMPLE_METHOD);

static void
gst_deinterlace_method_vfir_class_init (GstDeinterlaceMethodVFIRClass * klass)
{
  GstDeinterlaceMethodClass *dim_class = (GstDeinterlaceMethodClass *) klass;
  GstDeinterlaceSimpleMethodClass *dism_class =
      (GstDeinterlaceSimpleMethodClass *) klass;
#ifdef BUILD_X86_ASM
  guint cpu_flags =
      orc_target_get_default_flags (orc_target_get_by_name ("mmx"));
#endif

  dim_class->fields_required = 2;
  dim_class->name = "Blur Vertical";
  dim_class->nick = "vfir";
  dim_class->latency = 1;

#ifdef BUILD_X86_ASM
  if (cpu_flags & ORC_TARGET_MMX_MMX) {
    dism_class->interpolate_scanline_ayuv = deinterlace_line_packed_mmx;
    dism_class->interpolate_scanline_yuy2 = deinterlace_line_packed_mmx;
    dism_class->interpolate_scanline_yvyu = deinterlace_line_packed_mmx;
    dism_class->interpolate_scanline_uyvy = deinterlace_line_packed_mmx;
    dism_class->interpolate_scanline_nv12 = deinterlace_line_packed_mmx;
    dism_class->interpolate_scanline_nv21 = deinterlace_line_packed_mmx;
    dism_class->interpolate_scanline_argb = deinterlace_line_packed_mmx;
    dism_class->interpolate_scanline_abgr = deinterlace_line_packed_mmx;
    dism_class->interpolate_scanline_rgba = deinterlace_line_packed_mmx;
    dism_class->interpolate_scanline_bgra = deinterlace_line_packed_mmx;
    dism_class->interpolate_scanline_rgb = deinterlace_line_packed_mmx;
    dism_class->interpolate_scanline_bgr = deinterlace_line_packed_mmx;
    dism_class->interpolate_scanline_planar_y = deinterlace_line_planar_y_mmx;
    dism_class->interpolate_scanline_planar_u = deinterlace_line_planar_u_mmx;
    dism_class->interpolate_scanline_planar_v = deinterlace_line_planar_v_mmx;
  } else {
    dism_class->interpolate_scanline_yuy2 = deinterlace_line_packed_c;
    dism_class->interpolate_scanline_yvyu = deinterlace_line_packed_c;
    dism_class->interpolate_scanline_uyvy = deinterlace_line_packed_c;
    dism_class->interpolate_scanline_ayuv = deinterlace_line_packed_c;
    dism_class->interpolate_scanline_nv12 = deinterlace_line_packed_c;
    dism_class->interpolate_scanline_nv21 = deinterlace_line_packed_c;
    dism_class->interpolate_scanline_argb = deinterlace_line_packed_c;
    dism_class->interpolate_scanline_abgr = deinterlace_line_packed_c;
    dism_class->interpolate_scanline_rgba = deinterlace_line_packed_c;
    dism_class->interpolate_scanline_bgra = deinterlace_line_packed_c;
    dism_class->interpolate_scanline_rgb = deinterlace_line_packed_c;
    dism_class->interpolate_scanline_bgr = deinterlace_line_packed_c;
    dism_class->interpolate_scanline_planar_y = deinterlace_line_planar_y_c;
    dism_class->interpolate_scanline_planar_u = deinterlace_line_planar_u_c;
    dism_class->interpolate_scanline_planar_v = deinterlace_line_planar_v_c;
  }
#else
  dism_class->interpolate_scanline_ayuv = deinterlace_line_packed_c;
  dism_class->interpolate_scanline_yuy2 = deinterlace_line_packed_c;
  dism_class->interpolate_scanline_yvyu = deinterlace_line_packed_c;
  dism_class->interpolate_scanline_uyvy = deinterlace_line_packed_c;
  dism_class->interpolate_scanline_nv12 = deinterlace_line_packed_c;
  dism_class->interpolate_scanline_nv21 = deinterlace_line_packed_c;
  dism_class->interpolate_scanline_argb = deinterlace_line_packed_c;
  dism_class->interpolate_scanline_abgr = deinterlace_line_packed_c;
  dism_class->interpolate_scanline_rgba = deinterlace_line_packed_c;
  dism_class->interpolate_scanline_bgra = deinterlace_line_packed_c;
  dism_class->interpolate_scanline_rgb = deinterlace_line_packed_c;
  dism_class->interpolate_scanline_bgr = deinterlace_line_packed_c;
  dism_class->interpolate_scanline_planar_y = deinterlace_line_planar_y_c;
  dism_class->interpolate_scanline_planar_u = deinterlace_line_planar_u_c;
  dism_class->interpolate_scanline_planar_v = deinterlace_line_planar_v_c;
#endif
}

static void
gst_deinterlace_method_vfir_init (GstDeinterlaceMethodVFIR * self)
{
}
