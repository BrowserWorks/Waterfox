/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
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

#ifndef __GST_VIDEO_SCALE_H__
#define __GST_VIDEO_SCALE_H__

#include <gst/gst.h>
#include <gst/video/video.h>
#include <gst/video/gstvideofilter.h>

#include "vs_image.h"

G_BEGIN_DECLS

GST_DEBUG_CATEGORY_EXTERN (video_scale_debug);
#define GST_CAT_DEFAULT video_scale_debug

#define GST_TYPE_VIDEO_SCALE \
  (gst_video_scale_get_type())
#define GST_VIDEO_SCALE(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_VIDEO_SCALE,GstVideoScale))
#define GST_VIDEO_SCALE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_VIDEO_SCALE,GstVideoScaleClass))
#define GST_IS_VIDEO_SCALE(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_VIDEO_SCALE))
#define GST_IS_VIDEO_SCALE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_VIDEO_SCALE))
#define GST_VIDEO_SCALE_CAST(obj)       ((GstVideoScale *)(obj))


/**
 * GstVideoScaleMethod:
 * @GST_VIDEO_SCALE_NEAREST: use nearest neighbour scaling (fast and ugly)
 * @GST_VIDEO_SCALE_BILINEAR: use bilinear scaling (slower but prettier).
 * @GST_VIDEO_SCALE_4TAP: use a 4-tap filter for scaling (slow).
 * @GST_VIDEO_SCALE_LANCZOS: use a multitap Lanczos filter for scaling (slow).
 *
 * The videoscale method to use.
 */
typedef enum {
  GST_VIDEO_SCALE_NEAREST,
  GST_VIDEO_SCALE_BILINEAR,
  GST_VIDEO_SCALE_4TAP,
  GST_VIDEO_SCALE_LANCZOS
} GstVideoScaleMethod;

typedef struct _GstVideoScale GstVideoScale;
typedef struct _GstVideoScaleClass GstVideoScaleClass;

/**
 * GstVideoScale:
 *
 * Opaque data structure
 */
struct _GstVideoScale {
  GstVideoFilter element;

  /* properties */
  GstVideoScaleMethod method;
  gboolean add_borders;
  double sharpness;
  double sharpen;
  gboolean dither;
  int submethod;
  double envelope;

  gint borders_h;
  gint borders_w;

  /*< private >*/
  guint8 *tmp_buf;
};

struct _GstVideoScaleClass {
  GstVideoFilterClass parent_class;
};

G_GNUC_INTERNAL GType gst_video_scale_get_type (void);

G_END_DECLS

#endif /* __GST_VIDEO_SCALE_H__ */
