/* GStreamer
 * Copyright (C) 2010, 2013 Ole André Vadla Ravnås <oleavr@soundrop.com>
 * Copyright (C) 2012, 2013 Alessandro Decina <alessandro.d@gmail.com>
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

#ifndef _GST_VTDEC_H_
#define _GST_VTDEC_H_

#include <gst/video/video.h>
#include <gst/video/gstvideodecoder.h>
#include <CoreMedia/CoreMedia.h>
#include <VideoToolbox/VideoToolbox.h>

G_BEGIN_DECLS

#define GST_TYPE_VTDEC   (gst_vtdec_get_type())
#define GST_VTDEC(obj)   (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_VTDEC,GstVtdec))
#define GST_VTDEC_CLASS(klass)   (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_VTDEC,GstVtdecClass))
#define GST_IS_VTDEC(obj)   (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_VTDEC))
#define GST_IS_VTDEC_CLASS(obj)   (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_VTDEC))

typedef struct _GstVtdec GstVtdec;
typedef struct _GstVtdecClass GstVtdecClass;

struct _GstVtdec
{
  GstVideoDecoder base_vtdec;
  GstVideoInfo video_info;
  CMFormatDescriptionRef format_description;
  VTDecompressionSessionRef session;
  GAsyncQueue *reorder_queue;
  gint reorder_queue_length;
};

struct _GstVtdecClass
{
  GstVideoDecoderClass base_vtdec_class;
};

GType gst_vtdec_get_type (void);

G_END_DECLS

#endif
