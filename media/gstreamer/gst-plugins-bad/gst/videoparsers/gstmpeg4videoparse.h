/* GStreamer
 * Copyright (C) <2007> Julien Moutte <julien@fluendo.com>
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

#ifndef __MPEG4VIDEO_PARSE_H__
#define __MPEG4VIDEO_PARSE_H__

#include <gst/gst.h>
#include <gst/base/gstbaseparse.h>

#include <gst/codecparsers/gstmpeg4parser.h>

G_BEGIN_DECLS

#define GST_TYPE_MPEG4VIDEO_PARSE            (gst_mpeg4vparse_get_type())
#define GST_MPEG4VIDEO_PARSE(obj)            (G_TYPE_CHECK_INSTANCE_CAST((obj),\
                                GST_TYPE_MPEG4VIDEO_PARSE, GstMpeg4VParse))
#define GST_MPEG4VIDEO_PARSE_CLASS(klass)    (G_TYPE_CHECK_CLASS_CAST((klass),\
                                GST_TYPE_MPEG4VIDEO_PARSE, GstMpeg4VParseClass))
#define GST_MPEG4VIDEO_PARSE_GET_CLASS(obj)  (G_TYPE_INSTANCE_GET_CLASS ((obj),\
                                GST_TYPE_MPEG4VIDEO_PARSE, GstMpeg4VParseClass))
#define GST_IS_MPEG4VIDEO_PARSE(obj)         (G_TYPE_CHECK_INSTANCE_TYPE((obj),\
                                GST_TYPE_MPEG4VIDEO_PARSE))
#define GST_IS_MPEG4VIDEO_PARSE_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE((klass),\
                                GST_TYPE_MPEG4VIDEO_PARSE))

typedef struct _GstMpeg4VParse GstMpeg4VParse;
typedef struct _GstMpeg4VParseClass GstMpeg4VParseClass;

struct _GstMpeg4VParse {
  GstBaseParse element;

  GstClockTime last_report;

  /* parse state */
  gint last_sc;
  gint vop_offset;
  gboolean vo_found;
  gboolean config_found;
  gboolean intra_frame;
  gboolean update_caps;
  gboolean sent_codec_tag;

  GstMpeg4VisualObject vo;
  gint vo_offset;

  gboolean discont;

  GstBuffer *config;
  GstMpeg4VideoObjectLayer vol;
  gboolean vol_offset;
  const gchar *profile;
  const gchar *level;

  /* properties */
  gboolean drop;
  guint interval;
  GstClockTime pending_key_unit_ts;
  GstEvent *force_key_unit_event;
};

struct _GstMpeg4VParseClass {
  GstBaseParseClass parent_class;
};

GType gst_mpeg4vparse_get_type (void);

G_END_DECLS

#endif /* __MPEG4VIDEO_PARSE_H__ */
