/* GStreamer Adaptive Multi-Rate parser
 * Copyright (C) 2004 Ronald Bultje <rbultje@ronald.bitfreak.net>
 * Copyright (C) 2008 Nokia Corporation. All rights reserved.
 *
 * Contact: Stefan Kost <stefan.kost@nokia.com>
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

#ifndef __GST_AMR_PARSE_H__
#define __GST_AMR_PARSE_H__

#include <gst/gst.h>
#include <gst/base/gstbaseparse.h>

G_BEGIN_DECLS

#define GST_TYPE_AMR_PARSE \
  (gst_amr_parse_get_type())
#define GST_AMR_PARSE(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), GST_TYPE_AMR_PARSE, GstAmrParse))
#define GST_AMR_PARSE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass), GST_TYPE_AMR_PARSE, GstAmrParseClass))
#define GST_IS_AMR_PARSE(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj), GST_TYPE_AMR_PARSE))
#define GST_IS_AMR_PARSE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass), GST_TYPE_AMR_PARSE))


typedef struct _GstAmrParse GstAmrParse;
typedef struct _GstAmrParseClass GstAmrParseClass;

/**
 * GstAmrParse:
 * @element: the parent element.
 * @block_size: Pointer to frame size lookup table.
 * @need_header: Tells whether the MIME header should be read in the beginning.
 * @wide: Wideband mode.
 * @eos: Indicates the EOS situation. Set when EOS event is received.
 * @sync: Tells whether the parser is in sync.
 * @framecount: Total amount of frames handled.
 * @bytecount: Total amount of bytes handled.
 * @ts: Timestamp of the current media.
 *
 * The opaque GstAacParse data structure.
 */
struct _GstAmrParse {
  GstBaseParse element;
  const gint *block_size;
  gboolean need_header;
  gboolean sent_codec_tag;
  gint header;
  gboolean wide;
};

/**
 * GstAmrParseClass:
 * @parent_class: Element parent class.
 *
 * The opaque GstAmrParseClass data structure.
 */
struct _GstAmrParseClass {
  GstBaseParseClass parent_class;
};

GType gst_amr_parse_get_type (void);

G_END_DECLS

#endif /* __GST_AMR_PARSE_H__ */
