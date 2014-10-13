/* GStreamer
 *
 * Copyright (C) 2008 Sebastian Dröge <sebastian.droege@collabora.co.uk>.
 * Copyright (C) 2009 Mark Nauwelaerts <mark.nauwelaerts@collabora.co.uk>
 * Copyright (C) 2009 Nokia Corporation. All rights reserved.
 *   Contact: Stefan Kost <stefan.kost@nokia.com>
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

#ifndef __GST_FLAC_PARSE_H__
#define __GST_FLAC_PARSE_H__

#include <gst/gst.h>
#include <gst/base/gstbaseparse.h>

G_BEGIN_DECLS

#define GST_TYPE_FLAC_PARSE		   (gst_flac_parse_get_type())
#define GST_FLAC_PARSE(obj)		   (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_FLAC_PARSE,GstFlacParse))
#define GST_FLAC_PARSE_CLASS(klass)    (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_FLAC_PARSE,GstFlacParseClass))
#define GST_FLAC_PARSE_GET_CLASS(obj)  (G_TYPE_INSTANCE_GET_CLASS((obj),GST_TYPE_FLAC_PARSE,GstFlacParseClass))
#define GST_IS_FLAC_PARSE(obj)	   (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_FLAC_PARSE))
#define GST_IS_FLAC_PARSE_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_FLAC_PARSE))
#define GST_FLAC_PARSE_CAST(obj)	((GstFlacParse *)(obj))

typedef struct _GstFlacParse GstFlacParse;
typedef struct _GstFlacParseClass GstFlacParseClass;

typedef enum {
  GST_FLAC_PARSE_STATE_INIT,
  GST_FLAC_PARSE_STATE_HEADERS,
  GST_FLAC_PARSE_STATE_GENERATE_HEADERS,
  GST_FLAC_PARSE_STATE_DATA
} GstFlacParseState;

typedef struct {
  guint8 type;
} GstFlacParseSubFrame;

struct _GstFlacParse {
  GstBaseParse parent;

  /* Properties */
  gboolean check_frame_checksums;

  GstFlacParseState state;

  gint64 upstream_length;

  /* STREAMINFO content */
  guint16 min_blocksize, max_blocksize;
  guint32 min_framesize, max_framesize;
  guint32 samplerate;
  guint8 channels;
  guint8 bps;
  guint64 total_samples;

  /* Current frame */
  guint64 offset;
  guint8 blocking_strategy;
  guint16 block_size;
  guint64 sample_number;
  gboolean strategy_checked;

  gboolean sent_codec_tag;

  GstTagList *tags;
  GstToc *toc;

  GList *headers;
  GstBuffer *seektable;

  gboolean force_variable_block_size;
};

struct _GstFlacParseClass {
  GstBaseParseClass parent_class;
};

GType gst_flac_parse_get_type (void);

G_END_DECLS

#endif /* __GST_FLAC_PARSE_H__ */
