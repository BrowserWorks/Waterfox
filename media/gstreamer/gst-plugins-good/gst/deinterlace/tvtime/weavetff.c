/*
 * Weave frames, top-field-first.
 * Copyright (C) 2003 Billy Biggs <vektor@dumbterm.net>.
 * Copyright (C) 2008,2010 Sebastian Dröge <sebastian.droege@collabora.co.uk>
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

#define GST_TYPE_DEINTERLACE_METHOD_WEAVE_TFF	(gst_deinterlace_method_weave_tff_get_type ())
#define GST_IS_DEINTERLACE_METHOD_WEAVE_TFF(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_DEINTERLACE_METHOD_WEAVE_TFF))
#define GST_IS_DEINTERLACE_METHOD_WEAVE_TFF_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_DEINTERLACE_METHOD_WEAVE_TFF))
#define GST_DEINTERLACE_METHOD_WEAVE_TFF_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), GST_TYPE_DEINTERLACE_METHOD_WEAVE_TFF, GstDeinterlaceMethodWeaveTFFClass))
#define GST_DEINTERLACE_METHOD_WEAVE_TFF(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_DEINTERLACE_METHOD_WEAVE_TFF, GstDeinterlaceMethodWeaveTFF))
#define GST_DEINTERLACE_METHOD_WEAVE_TFF_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_DEINTERLACE_METHOD_WEAVE_TFF, GstDeinterlaceMethodWeaveTFFClass))
#define GST_DEINTERLACE_METHOD_WEAVE_TFF_CAST(obj)	((GstDeinterlaceMethodWeaveTFF*)(obj))

GType gst_deinterlace_method_weave_tff_get_type (void);

typedef GstDeinterlaceSimpleMethod GstDeinterlaceMethodWeaveTFF;
typedef GstDeinterlaceSimpleMethodClass GstDeinterlaceMethodWeaveTFFClass;

static void
deinterlace_scanline_weave_packed (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  if (scanlines->m1 == NULL) {
    memcpy (out, scanlines->t0, size);
  } else {
    memcpy (out, scanlines->m1, size);
  }
}

static void
deinterlace_scanline_weave_planar_y (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  if (scanlines->m1 == NULL) {
    memcpy (out, scanlines->t0, size);
  } else {
    memcpy (out, scanlines->m1, size);
  }
}

static void
deinterlace_scanline_weave_planar_u (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  if (scanlines->m1 == NULL) {
    memcpy (out, scanlines->t0, size);
  } else {
    memcpy (out, scanlines->m1, size);
  }
}

static void
deinterlace_scanline_weave_planar_v (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  if (scanlines->m1 == NULL) {
    memcpy (out, scanlines->t0, size);
  } else {
    memcpy (out, scanlines->m1, size);
  }
}

static void
copy_scanline_packed (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  memcpy (out, scanlines->m0, size);
}

static void
copy_scanline_planar_y (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  memcpy (out, scanlines->m0, size);
}

static void
copy_scanline_planar_u (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  memcpy (out, scanlines->m0, size);
}

static void
copy_scanline_planar_v (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  memcpy (out, scanlines->m0, size);
}

G_DEFINE_TYPE (GstDeinterlaceMethodWeaveTFF, gst_deinterlace_method_weave_tff,
    GST_TYPE_DEINTERLACE_SIMPLE_METHOD);

static void
gst_deinterlace_method_weave_tff_class_init (GstDeinterlaceMethodWeaveTFFClass *
    klass)
{
  GstDeinterlaceMethodClass *dim_class = (GstDeinterlaceMethodClass *) klass;
  GstDeinterlaceSimpleMethodClass *dism_class =
      (GstDeinterlaceSimpleMethodClass *) klass;

  dim_class->fields_required = 2;
  dim_class->name = "Progressive: Top Field First";
  dim_class->nick = "weavetff";
  dim_class->latency = 1;

  dism_class->interpolate_scanline_ayuv = deinterlace_scanline_weave_packed;
  dism_class->interpolate_scanline_yuy2 = deinterlace_scanline_weave_packed;
  dism_class->interpolate_scanline_yvyu = deinterlace_scanline_weave_packed;
  dism_class->interpolate_scanline_uyvy = deinterlace_scanline_weave_packed;
  dism_class->interpolate_scanline_nv12 = deinterlace_scanline_weave_packed;
  dism_class->interpolate_scanline_nv21 = deinterlace_scanline_weave_packed;
  dism_class->interpolate_scanline_argb = deinterlace_scanline_weave_packed;
  dism_class->interpolate_scanline_abgr = deinterlace_scanline_weave_packed;
  dism_class->interpolate_scanline_rgba = deinterlace_scanline_weave_packed;
  dism_class->interpolate_scanline_bgra = deinterlace_scanline_weave_packed;
  dism_class->interpolate_scanline_rgb = deinterlace_scanline_weave_packed;
  dism_class->interpolate_scanline_bgr = deinterlace_scanline_weave_packed;
  dism_class->interpolate_scanline_planar_y =
      deinterlace_scanline_weave_planar_y;
  dism_class->interpolate_scanline_planar_u =
      deinterlace_scanline_weave_planar_u;
  dism_class->interpolate_scanline_planar_v =
      deinterlace_scanline_weave_planar_v;

  dism_class->copy_scanline_ayuv = copy_scanline_packed;
  dism_class->copy_scanline_yuy2 = copy_scanline_packed;
  dism_class->copy_scanline_yvyu = copy_scanline_packed;
  dism_class->copy_scanline_uyvy = copy_scanline_packed;
  dism_class->copy_scanline_nv12 = copy_scanline_packed;
  dism_class->copy_scanline_nv21 = copy_scanline_packed;
  dism_class->copy_scanline_argb = copy_scanline_packed;
  dism_class->copy_scanline_abgr = copy_scanline_packed;
  dism_class->copy_scanline_rgba = copy_scanline_packed;
  dism_class->copy_scanline_bgra = copy_scanline_packed;
  dism_class->copy_scanline_rgb = copy_scanline_packed;
  dism_class->copy_scanline_bgr = copy_scanline_packed;
  dism_class->copy_scanline_planar_y = copy_scanline_planar_y;
  dism_class->copy_scanline_planar_u = copy_scanline_planar_u;
  dism_class->copy_scanline_planar_v = copy_scanline_planar_v;
}

static void
gst_deinterlace_method_weave_tff_init (GstDeinterlaceMethodWeaveTFF * self)
{
}
