/* GStreamer
 * Copyright (C) <2002> David A. Schleef <ds@schleef.org>
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

#ifndef __GST_SUBPARSE_H__
#define __GST_SUBPARSE_H__

#include <gst/gst.h>
#include <gst/base/gstadapter.h>

GST_DEBUG_CATEGORY_EXTERN (sub_parse_debug);
#define GST_CAT_DEFAULT sub_parse_debug

G_BEGIN_DECLS

#define GST_TYPE_SUBPARSE \
  (gst_sub_parse_get_type ())
#define GST_SUBPARSE(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_SUBPARSE, GstSubParse))
#define GST_SUBPARSE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_SUBPARSE, GstSubParseClass))
#define GST_IS_SUBPARSE(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_SUBPARSE))
#define GST_IS_SUBPARSE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_SUBPARSE))

typedef struct _GstSubParse GstSubParse;
typedef struct _GstSubParseClass GstSubParseClass;

/* format enum */
typedef enum
{
  GST_SUB_PARSE_FORMAT_UNKNOWN = 0,
  GST_SUB_PARSE_FORMAT_MDVDSUB = 1,
  GST_SUB_PARSE_FORMAT_SUBRIP = 2,
  GST_SUB_PARSE_FORMAT_MPSUB = 3,
  GST_SUB_PARSE_FORMAT_SAMI = 4,
  GST_SUB_PARSE_FORMAT_TMPLAYER = 5,
  GST_SUB_PARSE_FORMAT_MPL2 = 6,
  GST_SUB_PARSE_FORMAT_SUBVIEWER = 7,
  GST_SUB_PARSE_FORMAT_DKS = 8,
  GST_SUB_PARSE_FORMAT_QTTEXT = 9,
  GST_SUB_PARSE_FORMAT_LRC = 10
} GstSubParseFormat;

typedef struct {
  int      state;
  GString *buf;
  guint64  start_time;
  guint64  duration;
  guint64  max_duration; /* to clamp duration, 0 = no limit (used by tmplayer parser) */
  GstSegment *segment;
  gpointer user_data;
  gboolean have_internal_fps; /* If TRUE don't overwrite fps by property */
  gint fps_n, fps_d;     /* used by frame based parsers */
} ParserState;

typedef gchar* (*Parser) (ParserState *state, const gchar *line);

struct _GstSubParse {
  GstElement element;

  GstPad *sinkpad,*srcpad;

  /* contains the input in the input encoding */
  GstAdapter *adapter;
  /* contains the UTF-8 decoded input */
  GString *textbuf;

  GstSubParseFormat parser_type;
  gboolean parser_detected;
  const gchar *subtitle_codec;

  Parser parse_line;
  ParserState state;

  /* seek */
  guint64 offset;
  
  /* Segment */
  GstSegment    segment;
  gboolean      need_segment;
  
  gboolean flushing;
  gboolean valid_utf8;
  gchar   *detected_encoding;
  gchar   *encoding;

  gboolean first_buffer;

  /* used by frame based parsers */
  gint fps_n, fps_d;          
};

struct _GstSubParseClass {
  GstElementClass parent_class;
};

GType gst_sub_parse_get_type (void);

G_END_DECLS

#endif /* __GST_SUBPARSE_H__ */
