/*
 * GStreamer
 * Copyright (C) 2008-2010 Sebastian Dröge <slomo@collabora.co.uk>
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

#ifndef __GST_DEINTERLACE_METHOD_H__
#define __GST_DEINTERLACE_METHOD_H__

#include <gst/gst.h>
#include <gst/video/video.h>

#if defined(HAVE_GCC_ASM) && defined(HAVE_ORC)
#if defined(HAVE_CPU_I386) || defined(HAVE_CPU_X86_64)
#define BUILD_X86_ASM
#endif
#endif

G_BEGIN_DECLS

#define GST_TYPE_DEINTERLACE_METHOD		(gst_deinterlace_method_get_type ())
#define GST_IS_DEINTERLACE_METHOD(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_DEINTERLACE_METHOD))
#define GST_IS_DEINTERLACE_METHOD_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_DEINTERLACE_METHOD))
#define GST_DEINTERLACE_METHOD_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), GST_TYPE_DEINTERLACE_METHOD, GstDeinterlaceMethodClass))
#define GST_DEINTERLACE_METHOD(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_DEINTERLACE_METHOD, GstDeinterlaceMethod))
#define GST_DEINTERLACE_METHOD_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_DEINTERLACE_METHOD, GstDeinterlaceMethodClass))
#define GST_DEINTERLACE_METHOD_CAST(obj)	((GstDeinterlaceMethod*)(obj))

typedef struct _GstDeinterlaceMethod GstDeinterlaceMethod;
typedef struct _GstDeinterlaceMethodClass GstDeinterlaceMethodClass;


#define PICTURE_PROGRESSIVE 0
#define PICTURE_INTERLACED_BOTTOM 1
#define PICTURE_INTERLACED_TOP 2
#define PICTURE_INTERLACED_MASK (PICTURE_INTERLACED_BOTTOM | PICTURE_INTERLACED_TOP)

typedef struct
{
  GstVideoFrame *frame;
  /* see PICTURE_ flags in *.c */
  guint flags;
} GstDeinterlaceField;

/*
 * This structure defines the deinterlacer plugin.
 */

typedef void (*GstDeinterlaceMethodDeinterlaceFunction) (
    GstDeinterlaceMethod *self, const GstDeinterlaceField *history,
    guint history_count, GstVideoFrame *outframe, int cur_field_idx);

struct _GstDeinterlaceMethod {
  GstObject parent;

  GstVideoInfo *vinfo;

  GstDeinterlaceMethodDeinterlaceFunction deinterlace_frame;
};

struct _GstDeinterlaceMethodClass {
  GstObjectClass parent_class;
  guint fields_required;
  guint latency;

  gboolean (*supported) (GstDeinterlaceMethodClass *klass, GstVideoFormat format, gint width, gint height);

  void (*setup) (GstDeinterlaceMethod *self, GstVideoInfo * vinfo);

  GstDeinterlaceMethodDeinterlaceFunction deinterlace_frame_yuy2;
  GstDeinterlaceMethodDeinterlaceFunction deinterlace_frame_yvyu;
  GstDeinterlaceMethodDeinterlaceFunction deinterlace_frame_uyvy;
  GstDeinterlaceMethodDeinterlaceFunction deinterlace_frame_i420;
  GstDeinterlaceMethodDeinterlaceFunction deinterlace_frame_yv12;
  GstDeinterlaceMethodDeinterlaceFunction deinterlace_frame_y444;
  GstDeinterlaceMethodDeinterlaceFunction deinterlace_frame_y42b;
  GstDeinterlaceMethodDeinterlaceFunction deinterlace_frame_y41b;
  GstDeinterlaceMethodDeinterlaceFunction deinterlace_frame_ayuv;
  GstDeinterlaceMethodDeinterlaceFunction deinterlace_frame_nv12;
  GstDeinterlaceMethodDeinterlaceFunction deinterlace_frame_nv21;
  GstDeinterlaceMethodDeinterlaceFunction deinterlace_frame_argb;
  GstDeinterlaceMethodDeinterlaceFunction deinterlace_frame_abgr;
  GstDeinterlaceMethodDeinterlaceFunction deinterlace_frame_rgba;
  GstDeinterlaceMethodDeinterlaceFunction deinterlace_frame_bgra;
  GstDeinterlaceMethodDeinterlaceFunction deinterlace_frame_rgb;
  GstDeinterlaceMethodDeinterlaceFunction deinterlace_frame_bgr;

  const gchar *name;
  const gchar *nick;
};

GType gst_deinterlace_method_get_type (void);

gboolean gst_deinterlace_method_supported (GType type, GstVideoFormat format, gint width, gint height);
void gst_deinterlace_method_setup (GstDeinterlaceMethod * self, GstVideoInfo * vinfo);
void gst_deinterlace_method_deinterlace_frame (GstDeinterlaceMethod * self, const GstDeinterlaceField * history, guint history_count, GstVideoFrame * outframe,
    int cur_field_idx);
gint gst_deinterlace_method_get_fields_required (GstDeinterlaceMethod * self);
gint gst_deinterlace_method_get_latency (GstDeinterlaceMethod * self);

#define GST_TYPE_DEINTERLACE_SIMPLE_METHOD		(gst_deinterlace_simple_method_get_type ())
#define GST_IS_DEINTERLACE_SIMPLE_METHOD(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_DEINTERLACE_SIMPLE_METHOD))
#define GST_IS_DEINTERLACE_SIMPLE_METHOD_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_DEINTERLACE_SIMPLE_METHOD))
#define GST_DEINTERLACE_SIMPLE_METHOD_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), GST_TYPE_DEINTERLACE_SIMPLE_METHOD, GstDeinterlaceSimpleMethodClass))
#define GST_DEINTERLACE_SIMPLE_METHOD(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_DEINTERLACE_SIMPLE_METHOD, GstDeinterlaceSimpleMethod))
#define GST_DEINTERLACE_SIMPLE_METHOD_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_DEINTERLACE_SIMPLE_METHOD, GstDeinterlaceSimpleMethodClass))
#define GST_DEINTERLACE_SIMPLE_METHOD_CAST(obj)	((GstDeinterlaceSimpleMethod*)(obj))

typedef struct _GstDeinterlaceSimpleMethod GstDeinterlaceSimpleMethod;
typedef struct _GstDeinterlaceSimpleMethodClass GstDeinterlaceSimpleMethodClass;
typedef struct _GstDeinterlaceScanlineData GstDeinterlaceScanlineData;

/*
 * This structure defines the simple deinterlacer plugin.
 */

struct _GstDeinterlaceScanlineData {
 const guint8 *ttp, *tp, *mp, *bp, *bbp;
 const guint8 *tt0, *t0, *m0, *b0, *bb0;
 const guint8 *tt1, *t1, *m1, *b1, *bb1;
 const guint8 *tt2, *t2, *m2, *b2, *bb2;
 gboolean bottom_field;
};

/*
 * For interpolate_scanline the input is:
 *
 * |   t-3       t-2       t-1       t        t+1
 * | Field 3 | Field 2 | Field 1 | Field 0 | Field -1
 * |  TT3    |         |   TT1   |         |   TTp
 * |         |   T2    |         |   T0    |
 * |   M3    |         |    M1   |         |    Mp
 * |         |   B2    |         |   B0    |
 * |  BB3    |         |   BB1   |         |   BBp
 *
 * For copy_scanline the input is:
 *
 * |   t-3       t-2       t-1       t         t+1
 * | Field 3 | Field 2 | Field 1 | Field 0 | Field -1
 * |         |   TT2   |         |  TT0    |
 * |   T3    |         |   T1    |         |   Tp
 * |         |    M2   |         |   M0    |
 * |   B3    |         |   B1    |         |   Bp
 * |         |   BB2   |         |  BB0    |
 *
 * All other values are NULL.
 */

typedef void (*GstDeinterlaceSimpleMethodFunction) (GstDeinterlaceSimpleMethod *self, guint8 *out, const GstDeinterlaceScanlineData *scanlines, guint size);

struct _GstDeinterlaceSimpleMethod {
  GstDeinterlaceMethod parent;

  GstDeinterlaceSimpleMethodFunction interpolate_scanline_packed;
  GstDeinterlaceSimpleMethodFunction copy_scanline_packed;

  GstDeinterlaceSimpleMethodFunction interpolate_scanline_planar[3];
  GstDeinterlaceSimpleMethodFunction copy_scanline_planar[3];
};

struct _GstDeinterlaceSimpleMethodClass {
  GstDeinterlaceMethodClass parent_class;

  /* Packed formats */
  GstDeinterlaceSimpleMethodFunction interpolate_scanline_yuy2;
  GstDeinterlaceSimpleMethodFunction copy_scanline_yuy2;
  GstDeinterlaceSimpleMethodFunction interpolate_scanline_yvyu;
  GstDeinterlaceSimpleMethodFunction copy_scanline_yvyu;
  GstDeinterlaceSimpleMethodFunction interpolate_scanline_uyvy;
  GstDeinterlaceSimpleMethodFunction copy_scanline_uyvy;
  GstDeinterlaceSimpleMethodFunction interpolate_scanline_ayuv;
  GstDeinterlaceSimpleMethodFunction copy_scanline_ayuv;
  GstDeinterlaceSimpleMethodFunction interpolate_scanline_argb;
  GstDeinterlaceSimpleMethodFunction copy_scanline_argb;
  GstDeinterlaceSimpleMethodFunction interpolate_scanline_abgr;
  GstDeinterlaceSimpleMethodFunction copy_scanline_abgr;
  GstDeinterlaceSimpleMethodFunction interpolate_scanline_rgba;
  GstDeinterlaceSimpleMethodFunction copy_scanline_rgba;
  GstDeinterlaceSimpleMethodFunction interpolate_scanline_bgra;
  GstDeinterlaceSimpleMethodFunction copy_scanline_bgra;
  GstDeinterlaceSimpleMethodFunction interpolate_scanline_rgb;
  GstDeinterlaceSimpleMethodFunction copy_scanline_rgb;
  GstDeinterlaceSimpleMethodFunction interpolate_scanline_bgr;
  GstDeinterlaceSimpleMethodFunction copy_scanline_bgr;

  /* Semi-planar formats */
  GstDeinterlaceSimpleMethodFunction interpolate_scanline_nv12;
  GstDeinterlaceSimpleMethodFunction copy_scanline_nv12;
  GstDeinterlaceSimpleMethodFunction interpolate_scanline_nv21;
  GstDeinterlaceSimpleMethodFunction copy_scanline_nv21;

  /* Planar formats */
  GstDeinterlaceSimpleMethodFunction copy_scanline_planar_y;
  GstDeinterlaceSimpleMethodFunction interpolate_scanline_planar_y;
  GstDeinterlaceSimpleMethodFunction copy_scanline_planar_u;
  GstDeinterlaceSimpleMethodFunction interpolate_scanline_planar_u;
  GstDeinterlaceSimpleMethodFunction copy_scanline_planar_v;
  GstDeinterlaceSimpleMethodFunction interpolate_scanline_planar_v;
};

GType gst_deinterlace_simple_method_get_type (void);

G_END_DECLS

#endif /* __GST_DEINTERLACE_METHOD_H__ */
