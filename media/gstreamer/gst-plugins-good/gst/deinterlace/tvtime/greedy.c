/*
 *
 * GStreamer
 * Copyright (c) 2000 Tom Barry  All rights reserved.
 * mmx.h port copyright (c) 2002 Billy Biggs <vektor@dumbterm.net>.
 *
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
 * Relicensed for GStreamer from GPL to LGPL with permit from Tom Barry
 * and Billy Biggs.
 * See: http://bugzilla.gnome.org/show_bug.cgi?id=163578
 */

#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

#include "gstdeinterlacemethod.h"
#include <string.h>
#include "tvtime.h"


#define GST_TYPE_DEINTERLACE_METHOD_GREEDY_L	(gst_deinterlace_method_greedy_l_get_type ())
#define GST_IS_DEINTERLACE_METHOD_GREEDY_L(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_DEINTERLACE_METHOD_GREEDY_L))
#define GST_IS_DEINTERLACE_METHOD_GREEDY_L_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_DEINTERLACE_METHOD_GREEDY_L))
#define GST_DEINTERLACE_METHOD_GREEDY_L_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), GST_TYPE_DEINTERLACE_METHOD_GREEDY_L, GstDeinterlaceMethodGreedyLClass))
#define GST_DEINTERLACE_METHOD_GREEDY_L(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_DEINTERLACE_METHOD_GREEDY_L, GstDeinterlaceMethodGreedyL))
#define GST_DEINTERLACE_METHOD_GREEDY_L_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_DEINTERLACE_METHOD_GREEDY_L, GstDeinterlaceMethodGreedyLClass))
#define GST_DEINTERLACE_METHOD_GREEDY_L_CAST(obj)	((GstDeinterlaceMethodGreedyL*)(obj))

GType gst_deinterlace_method_greedy_l_get_type (void);

typedef struct
{
  GstDeinterlaceSimpleMethod parent;

  guint max_comb;
} GstDeinterlaceMethodGreedyL;

typedef GstDeinterlaceSimpleMethodClass GstDeinterlaceMethodGreedyLClass;

// This is a simple lightweight DeInterlace method that uses little CPU time
// but gives very good results for low or intermedite motion.
// It defers frames by one field, but that does not seem to produce noticeable
// lip sync problems.
//
// The method used is to take either the older or newer weave pixel depending
// upon which give the smaller comb factor, and then clip to avoid large damage
// when wrong.
//
// I'd intended this to be part of a larger more elaborate method added to 
// Blended Clip but this give too good results for the CPU to ignore here.

static inline void
deinterlace_greedy_interpolate_scanline_orc (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  guint max_comb = GST_DEINTERLACE_METHOD_GREEDY_L (self)->max_comb;

  if (scanlines->m1 == NULL || scanlines->mp == NULL) {
    deinterlace_line_linear (out, scanlines->t0, scanlines->b0, size);
  } else {
    deinterlace_line_greedy (out, scanlines->m1, scanlines->t0, scanlines->b0,
        scanlines->mp ? scanlines->mp : scanlines->m1, max_comb, size);
  }
}

static inline void
deinterlace_greedy_interpolate_scanline_orc_planar_u (GstDeinterlaceSimpleMethod
    * self, guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint
    size)
{
  guint max_comb = GST_DEINTERLACE_METHOD_GREEDY_L (self)->max_comb;

  if (scanlines->m1 == NULL || scanlines->mp == NULL) {
    deinterlace_line_linear (out, scanlines->t0, scanlines->b0, size);
  } else {
    deinterlace_line_greedy (out, scanlines->m1, scanlines->t0, scanlines->b0,
        scanlines->mp ? scanlines->mp : scanlines->m1, max_comb, size);
  }
}

static inline void
deinterlace_greedy_interpolate_scanline_orc_planar_v (GstDeinterlaceSimpleMethod
    * self, guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint
    size)
{
  guint max_comb = GST_DEINTERLACE_METHOD_GREEDY_L (self)->max_comb;

  if (scanlines->m1 == NULL || scanlines->mp == NULL) {
    deinterlace_line_linear (out, scanlines->t0, scanlines->b0, size);
  } else {
    deinterlace_line_greedy (out, scanlines->m1, scanlines->t0, scanlines->b0,
        scanlines->mp ? scanlines->mp : scanlines->m1, max_comb, size);
  }
}

static void
deinterlace_greedy_copy_scanline (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  memcpy (out, scanlines->m0, size);
}

static void
deinterlace_greedy_copy_scanline_planar_u (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  memcpy (out, scanlines->m0, size);
}

static void
deinterlace_greedy_copy_scanline_planar_v (GstDeinterlaceSimpleMethod * self,
    guint8 * out, const GstDeinterlaceScanlineData * scanlines, guint size)
{
  memcpy (out, scanlines->m0, size);
}

G_DEFINE_TYPE (GstDeinterlaceMethodGreedyL, gst_deinterlace_method_greedy_l,
    GST_TYPE_DEINTERLACE_SIMPLE_METHOD);

enum
{
  PROP_0,
  PROP_MAX_COMB
};

static void
gst_deinterlace_method_greedy_l_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstDeinterlaceMethodGreedyL *self = GST_DEINTERLACE_METHOD_GREEDY_L (object);

  switch (prop_id) {
    case PROP_MAX_COMB:
      self->max_comb = g_value_get_uint (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
  }
}

static void
gst_deinterlace_method_greedy_l_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstDeinterlaceMethodGreedyL *self = GST_DEINTERLACE_METHOD_GREEDY_L (object);

  switch (prop_id) {
    case PROP_MAX_COMB:
      g_value_set_uint (value, self->max_comb);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
  }
}

static void
gst_deinterlace_method_greedy_l_class_init (GstDeinterlaceMethodGreedyLClass *
    klass)
{
  GstDeinterlaceMethodClass *dim_class = (GstDeinterlaceMethodClass *) klass;
  GstDeinterlaceSimpleMethodClass *dism_class =
      (GstDeinterlaceSimpleMethodClass *) klass;
  GObjectClass *gobject_class = (GObjectClass *) klass;

  gobject_class->set_property = gst_deinterlace_method_greedy_l_set_property;
  gobject_class->get_property = gst_deinterlace_method_greedy_l_get_property;

  g_object_class_install_property (gobject_class, PROP_MAX_COMB,
      g_param_spec_uint ("max-comb",
          "Max comb",
          "Max Comb", 0, 255, 15, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS)
      );

  dim_class->fields_required = 2;
  dim_class->name = "Motion Adaptive: Simple Detection";
  dim_class->nick = "greedyl";
  dim_class->latency = 1;

  dism_class->interpolate_scanline_ayuv =
      deinterlace_greedy_interpolate_scanline_orc;
  dism_class->interpolate_scanline_yuy2 =
      deinterlace_greedy_interpolate_scanline_orc;
  dism_class->interpolate_scanline_yvyu =
      deinterlace_greedy_interpolate_scanline_orc;
  dism_class->interpolate_scanline_uyvy =
      deinterlace_greedy_interpolate_scanline_orc;
  dism_class->interpolate_scanline_argb =
      deinterlace_greedy_interpolate_scanline_orc;
  dism_class->interpolate_scanline_abgr =
      deinterlace_greedy_interpolate_scanline_orc;
  dism_class->interpolate_scanline_rgba =
      deinterlace_greedy_interpolate_scanline_orc;
  dism_class->interpolate_scanline_bgra =
      deinterlace_greedy_interpolate_scanline_orc;
  dism_class->interpolate_scanline_rgb =
      deinterlace_greedy_interpolate_scanline_orc;
  dism_class->interpolate_scanline_bgr =
      deinterlace_greedy_interpolate_scanline_orc;
  dism_class->interpolate_scanline_planar_y =
      deinterlace_greedy_interpolate_scanline_orc;
  dism_class->interpolate_scanline_planar_u =
      deinterlace_greedy_interpolate_scanline_orc_planar_u;
  dism_class->interpolate_scanline_planar_v =
      deinterlace_greedy_interpolate_scanline_orc_planar_v;

  dism_class->copy_scanline_ayuv = deinterlace_greedy_copy_scanline;
  dism_class->copy_scanline_yuy2 = deinterlace_greedy_copy_scanline;
  dism_class->copy_scanline_yvyu = deinterlace_greedy_copy_scanline;
  dism_class->copy_scanline_uyvy = deinterlace_greedy_copy_scanline;
  dism_class->copy_scanline_argb = deinterlace_greedy_copy_scanline;
  dism_class->copy_scanline_abgr = deinterlace_greedy_copy_scanline;
  dism_class->copy_scanline_rgba = deinterlace_greedy_copy_scanline;
  dism_class->copy_scanline_bgra = deinterlace_greedy_copy_scanline;
  dism_class->copy_scanline_rgb = deinterlace_greedy_copy_scanline;
  dism_class->copy_scanline_bgr = deinterlace_greedy_copy_scanline;
  dism_class->copy_scanline_planar_y = deinterlace_greedy_copy_scanline;
  dism_class->copy_scanline_planar_u =
      deinterlace_greedy_copy_scanline_planar_u;
  dism_class->copy_scanline_planar_v =
      deinterlace_greedy_copy_scanline_planar_v;
}

static void
gst_deinterlace_method_greedy_l_init (GstDeinterlaceMethodGreedyL * self)
{
  self->max_comb = 15;
}
