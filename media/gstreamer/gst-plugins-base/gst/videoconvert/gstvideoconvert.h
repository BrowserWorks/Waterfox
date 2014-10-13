/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
 * This file:
 * Copyright (C) 2003 Ronald Bultje <rbultje@ronald.bitfreak.net>
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

#ifndef __GST_VIDEOCONVERT_H__
#define __GST_VIDEOCONVERT_H__

#include <gst/gst.h>
#include <gst/video/video.h>
#include <gst/video/gstvideofilter.h>
#include "videoconvert.h"

G_BEGIN_DECLS

#define GST_TYPE_VIDEO_CONVERT	          (gst_video_convert_get_type())
#define GST_VIDEO_CONVERT(obj)            (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_VIDEO_CONVERT,GstVideoConvert))
#define GST_VIDEO_CONVERT_CLASS(klass)    (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_VIDEO_CONVERT,GstVideoConvertClass))
#define GST_IS_VIDEO_CONVERT(obj)         (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_VIDEO_CONVERT))
#define GST_IS_VIDEO_CONVERT_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_VIDEO_CONVERT))
#define GST_VIDEO_CONVERT_CAST(obj)       ((GstVideoConvert *)(obj))

typedef struct _GstVideoConvert GstVideoConvert;
typedef struct _GstVideoConvertClass GstVideoConvertClass;

/**
 * GstVideoConvert:
 *
 * Opaque object data structure.
 */
struct _GstVideoConvert {
  GstVideoFilter element;

  VideoConvert *convert;
  gboolean dither;
};

struct _GstVideoConvertClass
{
  GstVideoFilterClass parent_class;
};

G_END_DECLS

#endif /* __GST_VIDEOCONVERT_H__ */
