/* GStreamer MPEG audio parser
 * Copyright (C) 2006-2007 Jan Schmidt <thaytan@mad.scientist.com>
 * Copyright (C) 2010 Mark Nauwelaerts <mnauw users sf net>
 * Copyright (C) 2010 Nokia Corporation. All rights reserved.
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

#ifndef __GST_MPEG_AUDIO_PARSE_H__
#define __GST_MPEG_AUDIO_PARSE_H__

#include <gst/gst.h>
#include <gst/base/gstbaseparse.h>

G_BEGIN_DECLS

#define GST_TYPE_MPEG_AUDIO_PARSE \
  (gst_mpeg_audio_parse_get_type())
#define GST_MPEG_AUDIO_PARSE(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), GST_TYPE_MPEG_AUDIO_PARSE, GstMpegAudioParse))
#define GST_MPEG_AUDIO_PARSE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass), GST_TYPE_MPEG_AUDIO_PARSE, GstMpegAudioParseClass))
#define GST_IS_MPEG_AUDIO_PARSE(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj), GST_TYPE_MPEG_AUDIO_PARSE))
#define GST_IS_MPEG_AUDIO_PARSE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass), GST_TYPE_MPEG_AUDIO_PARSE))

typedef struct _GstMpegAudioParse GstMpegAudioParse;
typedef struct _GstMpegAudioParseClass GstMpegAudioParseClass;

/**
 * GstMpegAudioParse:
 *
 * The opaque GstMpegAudioParse object
 */
struct _GstMpegAudioParse {
  GstBaseParse baseparse;

  /*< private >*/
  gint         rate;
  gint         channels;
  gint         layer;
  gint         version;

  GstClockTime max_bitreservoir;
  /* samples per frame */
  gint        spf;

  gint         freerate;

  gboolean     sent_codec_tag;
  guint        last_posted_bitrate;
  gint         last_posted_crc, last_crc;
  guint        last_posted_channel_mode, last_mode;

  /* Bitrate from non-vbr headers */
  guint32      hdr_bitrate;

  /* Xing info */
  guint32      xing_flags;
  guint32      xing_frames;
  GstClockTime xing_total_time;
  guint32      xing_bytes;
  /* percent -> filepos mapping */
  guchar       xing_seek_table[100];
  /* filepos -> percent mapping */
  guint16      xing_seek_table_inverse[256];
  guint32      xing_vbr_scale;
  guint        xing_bitrate;

  /* VBRI info */
  guint32      vbri_frames;
  GstClockTime vbri_total_time;
  guint32      vbri_bytes;
  guint        vbri_bitrate;
  guint        vbri_seek_points;
  guint32     *vbri_seek_table;
  gboolean     vbri_valid;

  /* LAME info */
  guint32      encoder_delay;
  guint32      encoder_padding;
};

/**
 * GstMpegAudioParseClass:
 * @parent_class: Element parent class.
 *
 * The opaque GstMpegAudioParseClass data structure.
 */
struct _GstMpegAudioParseClass {
  GstBaseParseClass baseparse_class;
};

GType gst_mpeg_audio_parse_get_type (void);

G_END_DECLS

#endif /* __GST_MPEG_AUDIO_PARSE_H__ */
