/* GStreamer
 * Copyright (C) <2007> Jan Schmidt <thaytan@mad.scientist.com>
 * Copyright (C) <2011> Mark Nauwelaerts <mark.nauwelaerts@collabora.co.uk>
 * Copyright (C) <2011> Thibault Saunier <thibault.saunier@collabora.com>
 * Copyright (C) <2011> Collabora ltd
 * Copyright (C) <2011> Nokia Corporation
 * Copyright (C) <2011> Intel Corporation
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

#ifndef __GST_MPEGVIDEO_PARSE_H__
#define __GST_MPEGVIDEO_PARSE_H__

#include <gst/gst.h>
#include <gst/base/gstbaseparse.h>

#include <gst/codecparsers/gstmpegvideoparser.h>

G_BEGIN_DECLS

#define GST_TYPE_MPEGVIDEO_PARSE            (gst_mpegv_parse_get_type())
#define GST_MPEGVIDEO_PARSE(obj)            (G_TYPE_CHECK_INSTANCE_CAST((obj),\
                                GST_TYPE_MPEGVIDEO_PARSE, GstMpegvParse))
#define GST_MPEGVIDEO_PARSE_CLASS(klass)    (G_TYPE_CHECK_CLASS_CAST((klass),\
                                GST_TYPE_MPEGVIDEO_PARSE, GstMpegvParseClass))
#define GST_MPEGVIDEO_PARSE_GET_CLASS(obj)  (G_TYPE_INSTANCE_GET_CLASS ((obj),\
                                GST_TYPE_MPEGVIDEO_PARSE, GstMpegvParseClass))
#define GST_IS_MPEGVIDEO_PARSE(obj)         (G_TYPE_CHECK_INSTANCE_TYPE((obj),\
                                GST_TYPE_MPEGVIDEO_PARSE))
#define GST_IS_MPEGVIDEO_PARSE_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE((klass),\
                                GST_TYPE_MPEGVIDEO_PARSE))

typedef struct _GstMpegvParse GstMpegvParse;
typedef struct _GstMpegvParseClass GstMpegvParseClass;

/* Config/sequence flags. Reset each time config is re-parsed */
enum {
  FLAG_NONE = 0,
  FLAG_MPEG2 = 1,
  FLAG_SEQUENCE_EXT = 2,
  FLAG_SEQUENCE_DISPLAY_EXT = 4
};

struct _GstMpegvParse {
  GstBaseParse element;

  /* parse state */
  gint ext_offsets[10];
  gint ext_count;
  gint last_sc;
  gint seq_offset;
  gint seq_size;
  gint pic_offset;
  guint slice_count;
  guint slice_offset;
  gboolean update_caps;
  gboolean send_codec_tag;
  gboolean send_mpeg_meta;

  GstBuffer *config;
  guint8 profile;
  guint config_flags;
  GstMpegVideoSequenceHdr sequencehdr;
  GstMpegVideoSequenceExt sequenceext;
  GstMpegVideoSequenceDisplayExt sequencedispext;
  GstMpegVideoPictureHdr pichdr;
  GstMpegVideoPictureExt picext;
  GstMpegVideoQuantMatrixExt quantmatrext;

  gboolean seqhdr_updated;
  gboolean seqext_updated;
  gboolean seqdispext_updated;
  gboolean picext_updated;
  gboolean quantmatrext_updated;

  /* properties */
  gboolean drop;
  gboolean gop_split;

  int fps_num;
  int fps_den;
  int frame_repeat_count;
};

struct _GstMpegvParseClass {
  GstBaseParseClass parent_class;
};

GType gst_mpegv_parse_get_type (void);

G_END_DECLS

#endif /* __GST_MPEGVIDEO_PARSE_H__ */
