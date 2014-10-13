/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
 * Copyright (C) <2006> Tim-Philipp Müller <tim centricular net>
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


#ifndef __GST_AU_PARSE_H__
#define __GST_AU_PARSE_H__


#include <gst/gst.h>
#include <gst/base/gstadapter.h>


G_BEGIN_DECLS

#define GST_TYPE_AU_PARSE \
  (gst_au_parse_get_type())
#define GST_AU_PARSE(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_AU_PARSE,GstAuParse))
#define GST_AU_PARSE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_AU_PARSE,GstAuParseClass))
#define GST_IS_AU_PARSE(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_AU_PARSE))
#define GST_IS_AU_PARSE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_AU_PARSE))

typedef struct _GstAuParse GstAuParse;
typedef struct _GstAuParseClass GstAuParseClass;

struct _GstAuParse {
  GstElement element;

  GstPad     *sinkpad;
  GstPad     *srcpad;

  GstCaps    *src_caps;

  GstAdapter *adapter;

  /* GstSegment  segment; */

  gint64      offset;        /* where sample data starts */
  gint64      buffer_offset;
  guint       sample_size;
  guint       encoding;
  guint       samplerate;
  guint       channels;
};

struct _GstAuParseClass {
  GstElementClass parent_class;
};

GType gst_au_parse_get_type (void);

G_END_DECLS

#endif /* __GST_AU_PARSE_H__ */
