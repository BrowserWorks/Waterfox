/*
 * Copyright (C) 2002 Billy Biggs <vektor@dumbterm.net>.
 * Copyright (C) 2008,2010 Sebastian Dröge <slomo@collabora.co.uk>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
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

#include "gstdeinterlacemethod.h"
#include <string.h>
#ifdef HAVE_ORC
#include <orc/orc.h>
#endif
#include "tvtime.h"

#define GST_TYPE_DEINTERLACE_METHOD_LINEAR	(gst_deinterlace_method_linear_get_type ())
#define GST_IS_DEINTERLACE_METHOD_LINEAR(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_DEINTERLACE_METHOD_LINEAR))
#define GST_IS_DEINTERLACE_METHOD_LINEAR_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_DEINTERLACE_METHOD_LINEAR))
#define GST_DEINTERLACE_METHOD_LINEAR_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), GST_TYPE_DEINTERLACE_METHOD_LINEAR, GstDeinterlaceMethodLinearClass))
#define GST_DEINTERLACE_METHOD_LINEAR(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_DEINTERLACE_METHOD_LINEAR, GstDeinterlaceMethodLinear))
#define GST_DEINTERLACE_METHOD_LINEAR_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_DEINTERLACE_METHOD_LINEAR, GstDeinterlaceMethodLinearClass))
#define GST_DEINTERLACE_METHOD_LINEAR_CAST(obj)	((GstDeinterlaceMethodLinear*)(obj))

GType gst_deinterlace_method_linear_get_type (void);

typedef GstDeinterlaceSimpleMethod GstDeinterlaceMethodLinear;
typedef GstDeinterlaceSimpleMethodClass GstDeinterlaceMethodLinearClass;

static void
deinterlace_scanline_linear_c (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const guint8 * s1, const guint8 * s2, gint size)
{
  deinterlace_line_linear (out, s1, s2, size);
}

static void
deinterlace_scanline_linear_packed_c (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  deinterlace_scanline_linear_c (self, out, scanlines->t0, scanlines->b0, size);
}

static void
deinterlace_scanline_linear_planar_y_c (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  deinterlace_scanline_linear_c (self, out, scanlines->t0, scanlines->b0, size);
}

static void
deinterlace_scanline_linear_planar_u_c (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  deinterlace_scanline_linear_c (self, out, scanlines->t0, scanlines->b0, size);
}

static void
deinterlace_scanline_linear_planar_v_c (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  deinterlace_scanline_linear_c (self, out, scanlines->t0, scanlines->b0, size);
}

G_DEFINE_TYPE (GstDeinterlaceMethodLinear, gst_deinterlace_method_linear,
    GST_TYPE_DEINTERLACE_SIMPLE_METHOD);

static void
gst_deinterlace_method_linear_class_init (GstDeinterlaceMethodLinearClass *
    klass)
{
  GstDeinterlaceMethodClass *dim_class = (GstDeinterlaceMethodClass *) klass;
  GstDeinterlaceSimpleMethodClass *dism_class =
      (GstDeinterlaceSimpleMethodClass *) klass;

  dim_class->fields_required = 1;
  dim_class->name = "Television: Full resolution";
  dim_class->nick = "linear";
  dim_class->latency = 0;

  dism_class->interpolate_scanline_yuy2 = deinterlace_scanline_linear_packed_c;
  dism_class->interpolate_scanline_yvyu = deinterlace_scanline_linear_packed_c;
  dism_class->interpolate_scanline_uyvy = deinterlace_scanline_linear_packed_c;
  dism_class->interpolate_scanline_ayuv = deinterlace_scanline_linear_packed_c;
  dism_class->interpolate_scanline_argb = deinterlace_scanline_linear_packed_c;
  dism_class->interpolate_scanline_abgr = deinterlace_scanline_linear_packed_c;
  dism_class->interpolate_scanline_rgba = deinterlace_scanline_linear_packed_c;
  dism_class->interpolate_scanline_bgra = deinterlace_scanline_linear_packed_c;
  dism_class->interpolate_scanline_rgb = deinterlace_scanline_linear_packed_c;
  dism_class->interpolate_scanline_bgr = deinterlace_scanline_linear_packed_c;
  dism_class->interpolate_scanline_nv12 = deinterlace_scanline_linear_packed_c;
  dism_class->interpolate_scanline_nv21 = deinterlace_scanline_linear_packed_c;
  dism_class->interpolate_scanline_planar_y =
      deinterlace_scanline_linear_planar_y_c;
  dism_class->interpolate_scanline_planar_u =
      deinterlace_scanline_linear_planar_u_c;
  dism_class->interpolate_scanline_planar_v =
      deinterlace_scanline_linear_planar_v_c;

}

static void
gst_deinterlace_method_linear_init (GstDeinterlaceMethodLinear * self)
{
}
