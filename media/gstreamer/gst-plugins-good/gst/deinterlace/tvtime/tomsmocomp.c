/*
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
 * Relicensed for GStreamer from GPL to LGPL with permit from Tom Barry.
 * See: http://bugzilla.gnome.org/show_bug.cgi?id=163578
 */

#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

#include <stdlib.h>
#include <string.h>

#include <gst/gst.h>
#ifdef HAVE_ORC
#include <orc/orc.h>
#endif
#include "gstdeinterlacemethod.h"
#include "plugins.h"

#define GST_TYPE_DEINTERLACE_METHOD_TOMSMOCOMP	(gst_deinterlace_method_tomsmocomp_get_type ())
#define GST_IS_DEINTERLACE_METHOD_TOMSMOCOMP(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_DEINTERLACE_METHOD_TOMSMOCOMP))
#define GST_IS_DEINTERLACE_METHOD_TOMSMOCOMP_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_DEINTERLACE_METHOD_TOMSMOCOMP))
#define GST_DEINTERLACE_METHOD_TOMSMOCOMP_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), GST_TYPE_DEINTERLACE_METHOD_TOMSMOCOMP, GstDeinterlaceMethodTomsMoCompClass))
#define GST_DEINTERLACE_METHOD_TOMSMOCOMP(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_DEINTERLACE_METHOD_TOMSMOCOMP, GstDeinterlaceMethodTomsMoComp))
#define GST_DEINTERLACE_METHOD_TOMSMOCOMP_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_DEINTERLACE_METHOD_TOMSMOCOMP, GstDeinterlaceMethodTomsMoCompClass))
#define GST_DEINTERLACE_METHOD_TOMSMOCOMP_CAST(obj)	((GstDeinterlaceMethodTomsMoComp*)(obj))

typedef struct
{
  GstDeinterlaceMethod parent;

  guint search_effort;
  gboolean strange_bob;
} GstDeinterlaceMethodTomsMoComp;

typedef GstDeinterlaceMethodClass GstDeinterlaceMethodTomsMoCompClass;

static void
Fieldcopy (guint8 * dest, const guint8 * src, gint count,
    gint rows, gint dst_pitch, gint src_pitch)
{
  gint i;

  for (i = 0; i < rows; i++) {
    memcpy (dest, src, count);
    src += src_pitch;
    dest += dst_pitch;
  }
}

#define USE_FOR_DSCALER

#define IS_C
#define SIMD_TYPE C
#define FUNCT_NAME tomsmocompDScaler_C
#include "tomsmocomp/TomsMoCompAll.inc"
#undef  IS_C
#undef  SIMD_TYPE
#undef  FUNCT_NAME

#ifdef BUILD_X86_ASM

#include "tomsmocomp/tomsmocompmacros.h"
#include "x86-64_macros.inc"

#define IS_MMX
#define SIMD_TYPE MMX
#define FUNCT_NAME tomsmocompDScaler_MMX
#include "tomsmocomp/TomsMoCompAll.inc"
#undef  IS_MMX
#undef  SIMD_TYPE
#undef  FUNCT_NAME

#define IS_3DNOW
#define SIMD_TYPE 3DNOW
#define FUNCT_NAME tomsmocompDScaler_3DNOW
#include "tomsmocomp/TomsMoCompAll.inc"
#undef  IS_3DNOW
#undef  SIMD_TYPE
#undef  FUNCT_NAME

#define IS_MMXEXT
#define SIMD_TYPE MMXEXT
#define FUNCT_NAME tomsmocompDScaler_MMXEXT
#include "tomsmocomp/TomsMoCompAll.inc"
#undef  IS_MMXEXT
#undef  SIMD_TYPE
#undef  FUNCT_NAME

#endif

G_DEFINE_TYPE (GstDeinterlaceMethodTomsMoComp,
    gst_deinterlace_method_tomsmocomp, GST_TYPE_DEINTERLACE_METHOD);

enum
{
  PROP_0,
  PROP_SEARCH_EFFORT,
  PROP_STRANGE_BOB
};

static void
gst_deinterlace_method_tomsmocomp_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstDeinterlaceMethodTomsMoComp *self =
      GST_DEINTERLACE_METHOD_TOMSMOCOMP (object);

  switch (prop_id) {
    case PROP_SEARCH_EFFORT:
      self->search_effort = g_value_get_uint (value);
      break;
    case PROP_STRANGE_BOB:
      self->strange_bob = g_value_get_boolean (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
  }
}

static void
gst_deinterlace_method_tomsmocomp_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstDeinterlaceMethodTomsMoComp *self =
      GST_DEINTERLACE_METHOD_TOMSMOCOMP (object);

  switch (prop_id) {
    case PROP_SEARCH_EFFORT:
      g_value_set_uint (value, self->search_effort);
      break;
    case PROP_STRANGE_BOB:
      g_value_set_boolean (value, self->strange_bob);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
  }
}

static void
    gst_deinterlace_method_tomsmocomp_class_init
    (GstDeinterlaceMethodTomsMoCompClass * klass)
{
  GstDeinterlaceMethodClass *dim_class = (GstDeinterlaceMethodClass *) klass;
  GObjectClass *gobject_class = (GObjectClass *) klass;
#ifdef BUILD_X86_ASM
  guint cpu_flags =
      orc_target_get_default_flags (orc_target_get_by_name ("mmx"));
#endif

  gobject_class->set_property = gst_deinterlace_method_tomsmocomp_set_property;
  gobject_class->get_property = gst_deinterlace_method_tomsmocomp_get_property;

  g_object_class_install_property (gobject_class, PROP_SEARCH_EFFORT,
      g_param_spec_uint ("search-effort",
          "Search Effort",
          "Search Effort", 0, 27, 5, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS)
      );

  g_object_class_install_property (gobject_class, PROP_STRANGE_BOB,
      g_param_spec_boolean ("strange-bob",
          "Strange Bob",
          "Use strange bob", FALSE, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS)
      );

  dim_class->fields_required = 4;
  dim_class->name = "Motion Adaptive: Motion Search";
  dim_class->nick = "tomsmocomp";
  dim_class->latency = 1;

#ifdef BUILD_X86_ASM
  if (cpu_flags & ORC_TARGET_MMX_MMXEXT) {
    dim_class->deinterlace_frame_yuy2 = tomsmocompDScaler_MMXEXT;
    dim_class->deinterlace_frame_yvyu = tomsmocompDScaler_MMXEXT;
  } else if (cpu_flags & ORC_TARGET_MMX_3DNOW) {
    dim_class->deinterlace_frame_yuy2 = tomsmocompDScaler_3DNOW;
    dim_class->deinterlace_frame_yvyu = tomsmocompDScaler_3DNOW;
  } else if (cpu_flags & ORC_TARGET_MMX_MMX) {
    dim_class->deinterlace_frame_yuy2 = tomsmocompDScaler_MMX;
    dim_class->deinterlace_frame_yvyu = tomsmocompDScaler_MMX;
  } else {
    dim_class->deinterlace_frame_yuy2 = tomsmocompDScaler_C;
    dim_class->deinterlace_frame_yvyu = tomsmocompDScaler_C;
  }
#else
  dim_class->deinterlace_frame_yuy2 = tomsmocompDScaler_C;
  dim_class->deinterlace_frame_yvyu = tomsmocompDScaler_C;
#endif
}

static void
gst_deinterlace_method_tomsmocomp_init (GstDeinterlaceMethodTomsMoComp * self)
{
  self->search_effort = 5;
  self->strange_bob = FALSE;
}
