/*
 * Copyright (C) 2010 Ole André Vadla Ravnås <oleavr@soundrop.com>
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

#ifndef __GST_VTENC_H__
#define __GST_VTENC_H__

#include <gst/gst.h>
#include <gst/video/video.h>

#include "coremediactx.h"

G_BEGIN_DECLS

#define GST_VTENC_CAST(obj) \
  ((GstVTEnc *) (obj))
#define GST_VTENC_CLASS_GET_CODEC_DETAILS(klass) \
  ((const GstVTEncoderDetails *) g_type_get_qdata (G_OBJECT_CLASS_TYPE (klass), \
      GST_VTENC_CODEC_DETAILS_QDATA))

typedef struct _GstVTEncoderDetails GstVTEncoderDetails;

typedef struct _GstVTEncClassParams GstVTEncClassParams;
typedef struct _GstVTEncClass GstVTEncClass;
typedef struct _GstVTEnc GstVTEnc;

struct _GstVTEncoderDetails
{
  const gchar * name;
  const gchar * element_name;
  const gchar * mimetype;
  VTFormatId format_id;
};

struct _GstVTEncClass
{
  GstElementClass parent_class;
};

struct _GstVTEnc
{
  GstElement parent;

  const GstVTEncoderDetails * details;

  GstPad * sinkpad;
  GstPad * srcpad;

  gint usage;
  guint bitrate;

  GstCoreMediaCtx * ctx;

  gboolean dump_properties;
  gboolean dump_attributes;

  gint negotiated_width, negotiated_height;
  gint negotiated_fps_n, negotiated_fps_d;
  gint caps_width, caps_height;
  gint caps_fps_n, caps_fps_d;
  GstVideoInfo video_info;
  VTCompressionSessionRef session;
  CFMutableDictionaryRef options;

  GstBuffer * cur_inbuf;
  GPtrArray * cur_outbufs;
  gboolean expect_keyframe;
};

void gst_vtenc_register_elements (GstPlugin * plugin);

G_END_DECLS

#endif /* __GST_VTENC_H__ */
