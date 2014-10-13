/*
 * Double lines
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

#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

#include "gstdeinterlacemethod.h"
#include <string.h>

#define GST_TYPE_DEINTERLACE_METHOD_SCALER_BOB	(gst_deinterlace_method_scaler_bob_get_type ())
#define GST_IS_DEINTERLACE_METHOD_SCALER_BOB(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_DEINTERLACE_METHOD_SCALER_BOB))
#define GST_IS_DEINTERLACE_METHOD_SCALER_BOB_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_DEINTERLACE_METHOD_SCALER_BOB))
#define GST_DEINTERLACE_METHOD_SCALER_BOB_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), GST_TYPE_DEINTERLACE_METHOD_SCALER_BOB, GstDeinterlaceMethodScalerBobClass))
#define GST_DEINTERLACE_METHOD_SCALER_BOB(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_DEINTERLACE_METHOD_SCALER_BOB, GstDeinterlaceMethodScalerBob))
#define GST_DEINTERLACE_METHOD_SCALER_BOB_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_DEINTERLACE_METHOD_SCALER_BOB, GstDeinterlaceMethodScalerBobClass))
#define GST_DEINTERLACE_METHOD_SCALER_BOB_CAST(obj)	((GstDeinterlaceMethodScalerBob*)(obj))

GType gst_deinterlace_method_scaler_bob_get_type (void);

typedef GstDeinterlaceSimpleMethod GstDeinterlaceMethodScalerBob;
typedef GstDeinterlaceSimpleMethodClass GstDeinterlaceMethodScalerBobClass;

static void
deinterlace_scanline_scaler_bob_packed (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  memcpy (out, scanlines->t0, size);
}

static void
deinterlace_scanline_scaler_bob_planar_y (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  memcpy (out, scanlines->t0, size);
}

static void
deinterlace_scanline_scaler_bob_planar_u (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  memcpy (out, scanlines->t0, size);
}

static void
deinterlace_scanline_scaler_bob_planar_v (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  memcpy (out, scanlines->t0, size);
}

G_DEFINE_TYPE (GstDeinterlaceMethodScalerBob, gst_deinterlace_method_scaler_bob,
    GST_TYPE_DEINTERLACE_SIMPLE_METHOD);

static void
gst_deinterlace_method_scaler_bob_class_init (GstDeinterlaceMethodScalerBobClass
    * klass)
{
  GstDeinterlaceMethodClass *dim_class = (GstDeinterlaceMethodClass *) klass;
  GstDeinterlaceSimpleMethodClass *dism_class =
      (GstDeinterlaceSimpleMethodClass *) klass;

  dim_class->fields_required = 2;
  dim_class->name = "Double lines";
  dim_class->nick = "scalerbob";
  dim_class->latency = 1;

  dism_class->interpolate_scanline_ayuv =
      deinterlace_scanline_scaler_bob_packed;
  dism_class->interpolate_scanline_yuy2 =
      deinterlace_scanline_scaler_bob_packed;
  dism_class->interpolate_scanline_yvyu =
      deinterlace_scanline_scaler_bob_packed;
  dism_class->interpolate_scanline_uyvy =
      deinterlace_scanline_scaler_bob_packed;
  dism_class->interpolate_scanline_nv12 =
      deinterlace_scanline_scaler_bob_packed;
  dism_class->interpolate_scanline_nv21 =
      deinterlace_scanline_scaler_bob_packed;
  dism_class->interpolate_scanline_argb =
      deinterlace_scanline_scaler_bob_packed;
  dism_class->interpolate_scanline_abgr =
      deinterlace_scanline_scaler_bob_packed;
  dism_class->interpolate_scanline_rgba =
      deinterlace_scanline_scaler_bob_packed;
  dism_class->interpolate_scanline_bgra =
      deinterlace_scanline_scaler_bob_packed;
  dism_class->interpolate_scanline_rgb = deinterlace_scanline_scaler_bob_packed;
  dism_class->interpolate_scanline_bgr = deinterlace_scanline_scaler_bob_packed;
  dism_class->interpolate_scanline_planar_y =
      deinterlace_scanline_scaler_bob_planar_y;
  dism_class->interpolate_scanline_planar_u =
      deinterlace_scanline_scaler_bob_planar_u;
  dism_class->interpolate_scanline_planar_v =
      deinterlace_scanline_scaler_bob_planar_v;
}

static void
gst_deinterlace_method_scaler_bob_init (GstDeinterlaceMethodScalerBob * self)
{
}
