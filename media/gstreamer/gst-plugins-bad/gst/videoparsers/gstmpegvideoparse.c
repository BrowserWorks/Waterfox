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

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <string.h>
#include <gst/base/base.h>
#include <gst/pbutils/pbutils.h>
#include <gst/codecparsers/gstmpegvideometa.h>

#include "gstmpegvideoparse.h"

GST_DEBUG_CATEGORY (mpegv_parse_debug);
#define GST_CAT_DEFAULT mpegv_parse_debug

static GstStaticPadTemplate src_template =
GST_STATIC_PAD_TEMPLATE ("src", GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("video/mpeg, "
        "mpegversion = (int) [1, 2], "
        "parsed = (boolean) true, " "systemstream = (boolean) false")
    );

static GstStaticPadTemplate sink_template =
GST_STATIC_PAD_TEMPLATE ("sink", GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("video/mpeg, "
        "mpegversion = (int) [1, 2], " "systemstream = (boolean) false")
    );

/* Properties */
#define DEFAULT_PROP_DROP       TRUE
#define DEFAULT_PROP_GOP_SPLIT  FALSE

enum
{
  PROP_0,
  PROP_DROP,
  PROP_GOP_SPLIT,
  PROP_LAST
};

#define parent_class gst_mpegv_parse_parent_class
G_DEFINE_TYPE (GstMpegvParse, gst_mpegv_parse, GST_TYPE_BASE_PARSE);

static gboolean gst_mpegv_parse_start (GstBaseParse * parse);
static gboolean gst_mpegv_parse_stop (GstBaseParse * parse);
static GstFlowReturn gst_mpegv_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize);
static GstFlowReturn gst_mpegv_parse_parse_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame);
static gboolean gst_mpegv_parse_set_caps (GstBaseParse * parse, GstCaps * caps);
static GstCaps *gst_mpegv_parse_get_caps (GstBaseParse * parse,
    GstCaps * filter);
static GstFlowReturn gst_mpegv_parse_pre_push_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame);
static gboolean gst_mpegv_parse_sink_query (GstBaseParse * parse,
    GstQuery * query);

static void gst_mpegv_parse_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_mpegv_parse_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

static void
gst_mpegv_parse_set_property (GObject * object, guint property_id,
    const GValue * value, GParamSpec * pspec)
{
  GstMpegvParse *parse = GST_MPEGVIDEO_PARSE (object);

  switch (property_id) {
    case PROP_DROP:
      parse->drop = g_value_get_boolean (value);
      break;
    case PROP_GOP_SPLIT:
      parse->gop_split = g_value_get_boolean (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, property_id, pspec);
  }
}

static void
gst_mpegv_parse_get_property (GObject * object, guint property_id,
    GValue * value, GParamSpec * pspec)
{
  GstMpegvParse *parse = GST_MPEGVIDEO_PARSE (object);

  switch (property_id) {
    case PROP_DROP:
      g_value_set_boolean (value, parse->drop);
      break;
    case PROP_GOP_SPLIT:
      g_value_set_boolean (value, parse->gop_split);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, property_id, pspec);
  }
}

static void
gst_mpegv_parse_class_init (GstMpegvParseClass * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);
  GstElementClass *element_class = GST_ELEMENT_CLASS (klass);
  GstBaseParseClass *parse_class = GST_BASE_PARSE_CLASS (klass);

  GST_DEBUG_CATEGORY_INIT (mpegv_parse_debug, "mpegvideoparse", 0,
      "MPEG-1/2 video parser");

  parent_class = g_type_class_peek_parent (klass);

  gobject_class->set_property = gst_mpegv_parse_set_property;
  gobject_class->get_property = gst_mpegv_parse_get_property;

  g_object_class_install_property (gobject_class, PROP_DROP,
      g_param_spec_boolean ("drop", "drop",
          "Drop data untill valid configuration data is received either "
          "in the stream or through caps", DEFAULT_PROP_DROP,
          G_PARAM_CONSTRUCT | G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_GOP_SPLIT,
      g_param_spec_boolean ("gop-split", "gop-split",
          "Split frame when encountering GOP", DEFAULT_PROP_GOP_SPLIT,
          G_PARAM_CONSTRUCT | G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&src_template));
  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&sink_template));

  gst_element_class_set_static_metadata (element_class,
      "MPEG video elementary stream parser",
      "Codec/Parser/Video",
      "Parses and frames MPEG-1 and MPEG-2 elementary video streams",
      "Wim Taymans <wim.taymans@ccollabora.co.uk>, "
      "Jan Schmidt <thaytan@mad.scientist.com>, "
      "Mark Nauwelaerts <mark.nauwelaerts@collabora.co.uk>");

  /* Override BaseParse vfuncs */
  parse_class->start = GST_DEBUG_FUNCPTR (gst_mpegv_parse_start);
  parse_class->stop = GST_DEBUG_FUNCPTR (gst_mpegv_parse_stop);
  parse_class->handle_frame = GST_DEBUG_FUNCPTR (gst_mpegv_parse_handle_frame);
  parse_class->set_sink_caps = GST_DEBUG_FUNCPTR (gst_mpegv_parse_set_caps);
  parse_class->get_sink_caps = GST_DEBUG_FUNCPTR (gst_mpegv_parse_get_caps);
  parse_class->pre_push_frame =
      GST_DEBUG_FUNCPTR (gst_mpegv_parse_pre_push_frame);
  parse_class->sink_query = GST_DEBUG_FUNCPTR (gst_mpegv_parse_sink_query);
}

static void
gst_mpegv_parse_init (GstMpegvParse * parse)
{
  parse->config_flags = FLAG_NONE;

  gst_base_parse_set_pts_interpolation (GST_BASE_PARSE (parse), FALSE);
  GST_PAD_SET_ACCEPT_INTERSECT (GST_BASE_PARSE_SINK_PAD (parse));
}

static void
gst_mpegv_parse_reset_frame (GstMpegvParse * mpvparse)
{
  /* done parsing; reset state */
  mpvparse->last_sc = -1;
  mpvparse->seq_size = 0;
  mpvparse->seq_offset = -1;
  mpvparse->pic_offset = -1;
  mpvparse->frame_repeat_count = 0;
  memset (mpvparse->ext_offsets, 0, sizeof (mpvparse->ext_offsets));
  mpvparse->ext_count = 0;
  mpvparse->slice_count = 0;
  mpvparse->slice_offset = 0;
}

static void
gst_mpegv_parse_reset (GstMpegvParse * mpvparse)
{
  gst_mpegv_parse_reset_frame (mpvparse);
  mpvparse->profile = 0;
  mpvparse->update_caps = TRUE;
  mpvparse->send_codec_tag = TRUE;
  mpvparse->send_mpeg_meta = TRUE;

  gst_buffer_replace (&mpvparse->config, NULL);
  memset (&mpvparse->sequencehdr, 0, sizeof (mpvparse->sequencehdr));
  memset (&mpvparse->sequenceext, 0, sizeof (mpvparse->sequenceext));
  memset (&mpvparse->sequencedispext, 0, sizeof (mpvparse->sequencedispext));
  memset (&mpvparse->pichdr, 0, sizeof (mpvparse->pichdr));
  memset (&mpvparse->picext, 0, sizeof (mpvparse->picext));

  mpvparse->seqhdr_updated = FALSE;
  mpvparse->seqext_updated = FALSE;
  mpvparse->seqdispext_updated = FALSE;
  mpvparse->picext_updated = FALSE;
  mpvparse->quantmatrext_updated = FALSE;
}

static gboolean
gst_mpegv_parse_sink_query (GstBaseParse * parse, GstQuery * query)
{
  gboolean res;
  GstMpegvParse *mpvparse = GST_MPEGVIDEO_PARSE (parse);

  res = GST_BASE_PARSE_CLASS (parent_class)->sink_query (parse, query);

  if (res && GST_QUERY_TYPE (query) == GST_QUERY_ALLOCATION) {
    mpvparse->send_mpeg_meta =
        gst_query_find_allocation_meta (query, GST_MPEG_VIDEO_META_API_TYPE,
        NULL);

    GST_DEBUG_OBJECT (parse, "Downstream can handle GstMpegVideo GstMeta : %d",
        mpvparse->send_mpeg_meta);
  }

  return res;
}

static gboolean
gst_mpegv_parse_start (GstBaseParse * parse)
{
  GstMpegvParse *mpvparse = GST_MPEGVIDEO_PARSE (parse);

  GST_DEBUG_OBJECT (parse, "start");

  gst_mpegv_parse_reset (mpvparse);
  /* at least this much for a valid frame */
  gst_base_parse_set_min_frame_size (parse, 6);

  return TRUE;
}

static gboolean
gst_mpegv_parse_stop (GstBaseParse * parse)
{
  GstMpegvParse *mpvparse = GST_MPEGVIDEO_PARSE (parse);

  GST_DEBUG_OBJECT (parse, "stop");

  gst_mpegv_parse_reset (mpvparse);

  return TRUE;
}

static gboolean
gst_mpegv_parse_process_config (GstMpegvParse * mpvparse, GstMapInfo * info,
    guint size)
{
  GstMpegVideoPacket packet;
  guint8 *data_with_prefix;
  gint i;

  if (mpvparse->seq_offset < 4) {
    /* This shouldn't happen, but just in case... */
    GST_WARNING_OBJECT (mpvparse, "Sequence header start code missing.");
    return FALSE;
  }

  packet.data = info->data;
  packet.type = GST_MPEG_VIDEO_PACKET_SEQUENCE;
  packet.offset = mpvparse->seq_offset;
  packet.size = size - mpvparse->seq_offset;
  /* pointer to sequence header data including the start code prefix -
     used for codec private data */
  data_with_prefix = (guint8 *) packet.data + packet.offset - 4;

  /* only do stuff if something new; only compare first 8 bytes, changes in
     quantiser matrix or bitrate don't matter here. Also changing the
     matrices in codec_data seems to cause problem with decoders */
  if (mpvparse->config &&
      gst_buffer_memcmp (mpvparse->config, 0, data_with_prefix, MIN (size,
              8)) == 0) {
    return TRUE;
  }

  if (!gst_mpeg_video_packet_parse_sequence_header (&packet,
          &mpvparse->sequencehdr)) {
    GST_DEBUG_OBJECT (mpvparse,
        "failed to parse config data (size %d) at offset %d",
        size, mpvparse->seq_offset);
    return FALSE;
  }

  mpvparse->seqhdr_updated = TRUE;

  GST_LOG_OBJECT (mpvparse, "accepting parsed config size %d", size);

  /* Set mpeg version, and parse sequence extension */
  mpvparse->config_flags = FLAG_NONE;
  for (i = 0; i < mpvparse->ext_count; ++i) {
    packet.type = GST_MPEG_VIDEO_PACKET_EXTENSION;
    packet.offset = mpvparse->ext_offsets[i];
    packet.size = (gint) size - mpvparse->ext_offsets[i];
    mpvparse->config_flags |= FLAG_MPEG2;
    if (packet.size > 1) {
      switch (packet.data[packet.offset] >> 4) {
        case GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE:
          if (gst_mpeg_video_packet_parse_sequence_extension (&packet,
                  &mpvparse->sequenceext)) {
            GST_LOG_OBJECT (mpvparse, "Read Sequence Extension");
            mpvparse->config_flags |= FLAG_SEQUENCE_EXT;
            mpvparse->seqext_updated = TRUE;
          }
          break;
        case GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE_DISPLAY:
          if (gst_mpeg_video_packet_parse_sequence_display_extension (&packet,
                  &mpvparse->sequencedispext)) {
            GST_LOG_OBJECT (mpvparse, "Read Sequence Display Extension");
            mpvparse->config_flags |= FLAG_SEQUENCE_DISPLAY_EXT;
            mpvparse->seqdispext_updated = TRUE;
          }
          break;
        case GST_MPEG_VIDEO_PACKET_EXT_QUANT_MATRIX:
          if (gst_mpeg_video_packet_parse_quant_matrix_extension (&packet,
                  &mpvparse->quantmatrext)) {
            GST_LOG_OBJECT (mpvparse, "Read Quantization Matrix Extension");
            mpvparse->quantmatrext_updated = TRUE;
          }
          break;
      }
    }
  }
  if (mpvparse->config_flags & FLAG_MPEG2) {
    /* Update the sequence header based on extensions */
    GstMpegVideoSequenceExt *seqext = NULL;
    GstMpegVideoSequenceDisplayExt *seqdispext = NULL;

    if (mpvparse->config_flags & FLAG_SEQUENCE_EXT)
      seqext = &mpvparse->sequenceext;
    if (mpvparse->config_flags & FLAG_SEQUENCE_DISPLAY_EXT)
      seqdispext = &mpvparse->sequencedispext;

    gst_mpeg_video_finalise_mpeg2_sequence_header (&mpvparse->sequencehdr,
        seqext, seqdispext);
  }

  if (mpvparse->fps_num == 0 || mpvparse->fps_den == 0) {
    mpvparse->fps_num = mpvparse->sequencehdr.fps_n;
    mpvparse->fps_den = mpvparse->sequencehdr.fps_d;
  }

  /* parsing ok, so accept it as new config */
  if (mpvparse->config != NULL)
    gst_buffer_unref (mpvparse->config);

  mpvparse->config = gst_buffer_new_and_alloc (size);
  gst_buffer_fill (mpvparse->config, 0, data_with_prefix, size);

  /* trigger src caps update */
  mpvparse->update_caps = TRUE;

  return TRUE;
}

/* FIXME : Move these functions to libgstcodecparser for usage by
 * more elements/code */
#ifndef GST_DISABLE_GST_DEBUG
static const gchar *
picture_start_code_name (guint8 psc)
{
  guint i;
  const struct
  {
    guint8 psc;
    const gchar *name;
  } psc_names[] = {
    {
    0x00, "Picture Start"}, {
    0xb0, "Reserved"}, {
    0xb1, "Reserved"}, {
    0xb2, "User Data Start"}, {
    0xb3, "Sequence Header Start"}, {
    0xb4, "Sequence Error"}, {
    0xb5, "Extension Start"}, {
    0xb6, "Reserved"}, {
    0xb7, "Sequence End"}, {
    0xb8, "Group Start"}, {
    0xb9, "Program End"}
  };
  if (psc < 0xB0 && psc > 0)
    return "Slice Start";

  for (i = 0; i < G_N_ELEMENTS (psc_names); i++)
    if (psc_names[i].psc == psc)
      return psc_names[i].name;

  return "UNKNOWN";
};

static const gchar *
picture_type_name (guint8 pct)
{
  guint i;
  const struct
  {
    guint8 pct;
    const gchar *name;
  } pct_names[] = {
    {
    0, "Forbidden"}, {
    1, "I Frame"}, {
    2, "P Frame"}, {
    3, "B Frame"}, {
    4, "DC Intra Coded (Shall Not Be Used!)"}
  };

  for (i = 0; i < G_N_ELEMENTS (pct_names); i++)
    if (pct_names[i].pct == pct)
      return pct_names[i].name;

  return "Reserved/Unknown";
}
#endif /* GST_DISABLE_GST_DEBUG */

static void
parse_packet_extension (GstMpegvParse * mpvparse, GstMapInfo * info, guint off)
{
  GstMpegVideoPacket packet;

  packet.data = info->data;
  packet.type = GST_MPEG_VIDEO_PACKET_EXTENSION;
  packet.offset = off;
  packet.size = info->size - off;

  /* FIXME : WE ARE ASSUMING IT IS A *PICTURE* EXTENSION */
  if (gst_mpeg_video_packet_parse_picture_extension (&packet,
          &mpvparse->picext)) {
    mpvparse->frame_repeat_count = 1;

    if (mpvparse->picext.repeat_first_field) {
      if (mpvparse->sequenceext.progressive) {
        if (mpvparse->picext.top_field_first)
          mpvparse->frame_repeat_count = 5;
        else
          mpvparse->frame_repeat_count = 3;
      } else if (mpvparse->picext.progressive_frame) {
        mpvparse->frame_repeat_count = 2;
      }
    }
    mpvparse->picext_updated = TRUE;
  }
}

/* caller guarantees at least start code in @buf at @off ( - 4)*/
/* for off == 4 initial code; returns TRUE if code starts a frame
 * otherwise returns TRUE if code terminates preceding frame */
static gboolean
gst_mpegv_parse_process_sc (GstMpegvParse * mpvparse,
    GstMapInfo * info, gint off, GstMpegVideoPacket * packet,
    gboolean * need_more)
{
  gboolean ret = FALSE, checkconfig = TRUE;

  GST_LOG_OBJECT (mpvparse, "process startcode %x (%s) offset:%d", packet->type,
      picture_start_code_name (packet->type), off);

  *need_more = FALSE;

  switch (packet->type) {
    case GST_MPEG_VIDEO_PACKET_PICTURE:
      GST_LOG_OBJECT (mpvparse, "startcode is PICTURE");
      /* picture is aggregated with preceding sequence/gop, if any.
       * so, picture start code only ends if already a previous one */
      if (mpvparse->pic_offset < 0)
        mpvparse->pic_offset = off;
      else
        ret = (off != mpvparse->pic_offset);
      /* but it's a valid starting one */
      if (off == 4)
        ret = TRUE;
      break;
    case GST_MPEG_VIDEO_PACKET_SEQUENCE:
      GST_LOG_OBJECT (mpvparse, "startcode is SEQUENCE");
      if (mpvparse->seq_offset < 0)
        mpvparse->seq_offset = off;
      ret = TRUE;
      break;
    case GST_MPEG_VIDEO_PACKET_GOP:
      GST_LOG_OBJECT (mpvparse, "startcode is GOP");
      if (mpvparse->seq_offset >= 0)
        ret = mpvparse->gop_split;
      else
        ret = TRUE;
      break;
    case GST_MPEG_VIDEO_PACKET_EXTENSION:
      mpvparse->config_flags |= FLAG_MPEG2;
      GST_LOG_OBJECT (mpvparse, "startcode is VIDEO PACKET EXTENSION");
      if (mpvparse->pic_offset >= 0) {
        GST_LOG_OBJECT (mpvparse, "... considered PICTURE EXTENSION");
        parse_packet_extension (mpvparse, info, off);
      } else {
        GST_LOG_OBJECT (mpvparse, "... considered SEQUENCE EXTENSION");
        if (mpvparse->ext_count < G_N_ELEMENTS (mpvparse->ext_offsets))
          mpvparse->ext_offsets[mpvparse->ext_count++] = off;
      }
      checkconfig = FALSE;
      break;
    default:
      if (GST_MPEG_VIDEO_PACKET_IS_SLICE (packet->type)) {
        mpvparse->slice_count++;
        if (mpvparse->slice_offset == 0)
          mpvparse->slice_offset = off - 4;
      }
      checkconfig = FALSE;
      break;
  }

  /* set size to avoid processing config again */
  if (checkconfig && mpvparse->seq_offset >= 0 && off != mpvparse->seq_offset &&
      !mpvparse->seq_size) {
    /* should always be at start */
    g_assert (mpvparse->seq_offset <= 4);
    gst_mpegv_parse_process_config (mpvparse, info, off - mpvparse->seq_offset);
    mpvparse->seq_size = off - mpvparse->seq_offset;
  }

  /* extract some picture info if there is any in the frame being terminated */
  if (ret && mpvparse->pic_offset >= 0 && mpvparse->pic_offset < off) {
    GstMpegVideoPacket header;

    header.data = info->data;
    header.type = GST_MPEG_VIDEO_PACKET_PICTURE;
    header.offset = mpvparse->pic_offset;
    header.size = info->size - mpvparse->pic_offset;
    if (gst_mpeg_video_packet_parse_picture_header (&header, &mpvparse->pichdr))
      GST_LOG_OBJECT (mpvparse, "picture_coding_type %d (%s), ending"
          "frame of size %d", mpvparse->pichdr.pic_type,
          picture_type_name (mpvparse->pichdr.pic_type), off - 4);
    else
      GST_LOG_OBJECT (mpvparse, "Couldn't parse picture at offset %d",
          mpvparse->pic_offset);

    /* if terminating packet is a picture, we need to check if it has same TSN as the picture that is being
       terminated. If it does, we need to keep those together, as these packets are two fields of the same
       frame */
    if (packet->type == GST_MPEG_VIDEO_PACKET_PICTURE
        && (mpvparse->config_flags & FLAG_SEQUENCE_EXT)
        && !mpvparse->sequenceext.progressive) {
      if (info->size - off < 2) {       /* we need at least two bytes to read the TSN */
        *need_more = TRUE;
        ret = FALSE;
      } else {
        /* TSN is stored in first 10 bits */
        int tsn = info->data[off] << 2 | (info->data[off + 1] & 0xC0) >> 6;

        if (tsn == mpvparse->pichdr.tsn)        /* prevent termination if TSN is same */
          ret = FALSE;
      }
    }
  }

  return ret;
}

/* FIXME move into baseparse, or anything equivalent;
 * see https://bugzilla.gnome.org/show_bug.cgi?id=650093 */
#define GST_BASE_PARSE_FRAME_FLAG_PARSING   0x10000

static inline void
update_frame_parsing_status (GstMpegvParse * mpvparse,
    GstBaseParseFrame * frame)
{
  /* avoid stale cached parsing state */
  if (frame->flags & GST_BASE_PARSE_FRAME_FLAG_NEW_FRAME) {
    GST_LOG_OBJECT (mpvparse, "parsing new frame");
    gst_mpegv_parse_reset_frame (mpvparse);
  } else {
    GST_LOG_OBJECT (mpvparse, "resuming frame parsing");
  }
}

static GstFlowReturn
gst_mpegv_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize)
{
  GstFlowReturn flowret = GST_FLOW_OK;
  GstMpegvParse *mpvparse = GST_MPEGVIDEO_PARSE (parse);
  GstBuffer *buf = frame->buffer;
  gboolean ret = FALSE;
  gint off = 0;
  GstMpegVideoPacket packet;
  guint8 *data;
  gint size;
  gboolean need_more = FALSE;
  GstMapInfo map;

  update_frame_parsing_status (mpvparse, frame);

  gst_buffer_map (buf, &map, GST_MAP_READ);
  data = map.data;
  size = map.size;

retry:
  /* at least start code and subsequent byte */
  if (G_UNLIKELY (size < 5 + off))
    goto exit;

  /* if already found a previous start code, e.g. start of frame, go for next */
  if (mpvparse->last_sc >= 0) {
    off = packet.offset = mpvparse->last_sc;
    packet.size = 0;
    goto next;
  }

  if (!gst_mpeg_video_parse (&packet, data, size, off)) {
    /* didn't find anything that looks like a sync word, skip */
    GST_LOG_OBJECT (mpvparse, "no start code found");
    *skipsize = size - 3;
    goto exit;
  }

  off = packet.offset - 4;
  GST_LOG_OBJECT (mpvparse, "possible sync at buffer offset %d", off);

  /* possible frame header, but not at offset 0? skip bytes before sync */
  if (G_UNLIKELY (off > 0)) {
    *skipsize = off;
    goto exit;
  }

  /* note: initial start code is assumed at offset 0 by subsequent code */

  /* examine start code, see if it looks like an initial start code */
  if (gst_mpegv_parse_process_sc (mpvparse, &map, 4, &packet, &need_more)) {
    /* found sc */
    GST_LOG_OBJECT (mpvparse, "valid start code found");
    mpvparse->last_sc = 0;
  } else {
    off++;
    gst_mpegv_parse_reset_frame (mpvparse);
    GST_LOG_OBJECT (mpvparse, "invalid start code");
    goto retry;
  }

next:
  /* start is fine as of now */
  *skipsize = 0;
  /* terminating start code may have been found in prev scan already */
  if (((gint) packet.size) >= 0) {
    off = packet.offset + packet.size;
    /* so now we have start code at start of data; locate next start code */
    if (!gst_mpeg_video_parse (&packet, data, size, off)) {
      off = -1;
    } else {
      g_assert (packet.offset >= 4);
      off = packet.offset - 4;
    }
  } else {
    off = -1;
  }

  GST_LOG_OBJECT (mpvparse, "next start code at %d", off);
  if (off < 0) {
    off = size - 3;
    goto need_more;
  } else {
    /* decide whether this startcode ends a frame */
    ret = gst_mpegv_parse_process_sc (mpvparse, &map, off + 4, &packet,
        &need_more);
    /* in rare cases, might need to peek past start code */
    if (need_more) {
      GST_LOG_OBJECT (mpvparse, "need more data (past start code");
      ret = FALSE;
      goto need_more;
    }
  }

  if (!ret)
    goto next;

exit:
  gst_buffer_unmap (buf, &map);

  if (ret) {
    GstFlowReturn res;

    *skipsize = 0;
    g_assert (off <= map.size);
    res = gst_mpegv_parse_parse_frame (parse, frame);
    if (res == GST_BASE_PARSE_FLOW_DROPPED)
      frame->flags |= GST_BASE_PARSE_FRAME_FLAG_DROP;
    flowret = gst_base_parse_finish_frame (parse, frame, off);
    /* Reset local information */
    mpvparse->seqhdr_updated = FALSE;
    mpvparse->seqext_updated = FALSE;
    mpvparse->seqdispext_updated = FALSE;
    mpvparse->picext_updated = FALSE;
    mpvparse->quantmatrext_updated = FALSE;
  }

  return flowret;

need_more:
  /* if draining, take all */
  if (GST_BASE_PARSE_DRAINING (parse)) {
    GST_LOG_OBJECT (mpvparse, "draining, accepting all data");
    off = size;
    ret = TRUE;
  } else {
    GST_LOG_OBJECT (mpvparse, "need more data");
    /* resume scan where we left it */
    mpvparse->last_sc = off;
    /* request best next available */
    off = G_MAXUINT;
  }
  goto exit;
}

static void
gst_mpegv_parse_update_src_caps (GstMpegvParse * mpvparse)
{
  GstCaps *caps = NULL;
  GstStructure *s = NULL;

  /* only update if no src caps yet or explicitly triggered */
  if (G_LIKELY (gst_pad_has_current_caps (GST_BASE_PARSE_SRC_PAD (mpvparse)) &&
          !mpvparse->update_caps))
    return;

  /* carry over input caps as much as possible; override with our own stuff */
  caps = gst_pad_get_current_caps (GST_BASE_PARSE_SINK_PAD (mpvparse));
  if (caps) {
    caps = gst_caps_make_writable (caps);
    s = gst_caps_get_structure (caps, 0);
  } else {
    caps = gst_caps_new_empty_simple ("video/mpeg");
  }

  /* typically we don't output buffers until we have properly parsed some
   * config data, so we should at least know about version.
   * If not, it means it has been requested not to drop data, and
   * upstream and/or app must know what they are doing ... */
  gst_caps_set_simple (caps,
      "mpegversion", G_TYPE_INT, (mpvparse->config_flags & FLAG_MPEG2) ? 2 : 1,
      NULL);

  gst_caps_set_simple (caps, "systemstream", G_TYPE_BOOLEAN, FALSE,
      "parsed", G_TYPE_BOOLEAN, TRUE, NULL);

  if (mpvparse->sequencehdr.width > 0 && mpvparse->sequencehdr.height > 0) {
    GstMpegVideoSequenceDisplayExt *seqdispext;
    gint width, height;

    width = mpvparse->sequencehdr.width;
    height = mpvparse->sequencehdr.height;

    if (mpvparse->config_flags & FLAG_SEQUENCE_DISPLAY_EXT) {
      seqdispext = &mpvparse->sequencedispext;

      if (seqdispext->display_horizontal_size <= width
          && seqdispext->display_vertical_size <= height) {
        width = seqdispext->display_horizontal_size;
        height = seqdispext->display_vertical_size;
        GST_INFO_OBJECT (mpvparse,
            "stream has display extension: display_width=%d display_height=%d",
            width, height);
      }
    }
    gst_caps_set_simple (caps, "width", G_TYPE_INT, width,
        "height", G_TYPE_INT, height, NULL);
  }

  /* perhaps we have a framerate */
  {
    gint fps_num = mpvparse->fps_num;
    gint fps_den = mpvparse->fps_den;
    GstClockTime latency;

    /* upstream overrides */
    if (s && gst_structure_has_field (s, "framerate"))
      gst_structure_get_fraction (s, "framerate", &fps_num, &fps_den);

    if (fps_den > 0 && fps_num > 0) {
      gst_caps_set_simple (caps, "framerate",
          GST_TYPE_FRACTION, fps_num, fps_den, NULL);
      gst_base_parse_set_frame_rate (GST_BASE_PARSE (mpvparse),
          fps_num, fps_den, 0, 0);
      latency = gst_util_uint64_scale (GST_SECOND, fps_den, fps_num);
      gst_base_parse_set_latency (GST_BASE_PARSE (mpvparse), latency, latency);
    }
  }

  /* or pixel-aspect-ratio */
  if (mpvparse->sequencehdr.par_w && mpvparse->sequencehdr.par_h > 0 &&
      (!s || !gst_structure_has_field (s, "pixel-aspect-ratio"))) {
    gst_caps_set_simple (caps, "pixel-aspect-ratio", GST_TYPE_FRACTION,
        mpvparse->sequencehdr.par_w, mpvparse->sequencehdr.par_h, NULL);
  }

  if (mpvparse->config != NULL) {
    gst_caps_set_simple (caps, "codec_data",
        GST_TYPE_BUFFER, mpvparse->config, NULL);
  }

  if (mpvparse->config_flags & FLAG_SEQUENCE_EXT) {
    const guint profile_c = mpvparse->sequenceext.profile;
    const guint level_c = mpvparse->sequenceext.level;
    const gchar *profile = NULL, *level = NULL;
    /*
     * Profile indication - 1 => High, 2 => Spatially Scalable,
     *                      3 => SNR Scalable, 4 => Main, 5 => Simple
     * 4:2:2 and Multi-view have profile = 0, with the escape bit set to 1
     */
    const gchar *const profiles[] =
        { "high", "spatial", "snr", "main", "simple" };
    /*
     * Level indication - 4 => High, 6 => High-1440, 8 => Main, 10 => Low,
     *                    except in the case of profile = 0
     */
    const gchar *const levels[] = { "high", "high-1440", "main", "low" };

    if (profile_c > 0 && profile_c < 6)
      profile = profiles[profile_c - 1];

    if ((level_c > 3) && (level_c < 11) && (level_c % 2 == 0))
      level = levels[(level_c >> 1) - 2];

    if (profile_c == 8) {
      /* Non-hierarchical profile */
      switch (level_c) {
        case 2:
          level = levels[0];
        case 5:
          if (!level)
            level = levels[2];
          profile = "4:2:2";
          break;
        case 10:
          level = levels[0];
        case 11:
          if (!level)
            level = levels[1];
        case 13:
          if (!level)
            level = levels[2];
        case 14:
          if (!level)
            level = levels[3];
          profile = "multiview";
          break;
        default:
          break;
      }
    }

    /* FIXME does it make sense to expose profile/level in the caps ? */

    GST_DEBUG_OBJECT (mpvparse, "profile:'%s' level:'%s'", profile, level);

    if (profile)
      gst_caps_set_simple (caps, "profile", G_TYPE_STRING, profile, NULL);
    else
      GST_DEBUG_OBJECT (mpvparse, "Invalid profile - %u", profile_c);

    if (level)
      gst_caps_set_simple (caps, "level", G_TYPE_STRING, level, NULL);
    else
      GST_DEBUG_OBJECT (mpvparse, "Invalid level - %u", level_c);

    gst_caps_set_simple (caps, "interlace-mode",
        G_TYPE_STRING,
        (mpvparse->sequenceext.progressive ? "progressive" : "mixed"), NULL);
  }

  gst_pad_set_caps (GST_BASE_PARSE_SRC_PAD (mpvparse), caps);
  gst_caps_unref (caps);

  mpvparse->update_caps = FALSE;
}

static GstFlowReturn
gst_mpegv_parse_parse_frame (GstBaseParse * parse, GstBaseParseFrame * frame)
{
  GstMpegvParse *mpvparse = GST_MPEGVIDEO_PARSE (parse);
  GstBuffer *buffer = frame->buffer;

  if (G_UNLIKELY (mpvparse->pichdr.pic_type == GST_MPEG_VIDEO_PICTURE_TYPE_I))
    GST_BUFFER_FLAG_UNSET (buffer, GST_BUFFER_FLAG_DELTA_UNIT);
  else
    GST_BUFFER_FLAG_SET (buffer, GST_BUFFER_FLAG_DELTA_UNIT);

  /* maybe only sequence in this buffer, though not recommended,
   * so mark it as such and force 0 duration */
  if (G_UNLIKELY (mpvparse->pic_offset < 0)) {
    GST_DEBUG_OBJECT (mpvparse, "frame holds no picture data");
    frame->flags |= GST_BASE_PARSE_FRAME_FLAG_NO_FRAME;
    GST_BUFFER_DURATION (buffer) = 0;
  }

  if (mpvparse->pic_offset > 4) {
    gst_base_parse_set_ts_at_offset (parse, mpvparse->pic_offset - 4);
  }

  if (mpvparse->frame_repeat_count
      && GST_CLOCK_TIME_IS_VALID (GST_BUFFER_DURATION (buffer))) {
    GST_BUFFER_DURATION (buffer) =
        (1 + mpvparse->frame_repeat_count) * GST_BUFFER_DURATION (buffer) / 2;
  }

  if (G_UNLIKELY (mpvparse->drop && !mpvparse->config)) {
    GST_DEBUG_OBJECT (mpvparse, "dropping frame as no config yet");
    return GST_BASE_PARSE_FLOW_DROPPED;
  }

  gst_mpegv_parse_update_src_caps (mpvparse);
  return GST_FLOW_OK;
}

static GstFlowReturn
gst_mpegv_parse_pre_push_frame (GstBaseParse * parse, GstBaseParseFrame * frame)
{
  GstMpegvParse *mpvparse = GST_MPEGVIDEO_PARSE (parse);
  GstTagList *taglist;
  GstMpegVideoMeta *meta;
  GstMpegVideoSequenceHdr *seq_hdr = NULL;
  GstMpegVideoSequenceExt *seq_ext = NULL;
  GstMpegVideoSequenceDisplayExt *disp_ext = NULL;
  GstMpegVideoPictureHdr *pic_hdr = NULL;
  GstMpegVideoPictureExt *pic_ext = NULL;
  GstMpegVideoQuantMatrixExt *quant_ext = NULL;

  /* tag sending done late enough in hook to ensure pending events
   * have already been sent */

  if (G_UNLIKELY (mpvparse->send_codec_tag)) {
    GstCaps *caps;

    /* codec tag */
    taglist = gst_tag_list_new_empty ();
    caps = gst_pad_get_current_caps (GST_BASE_PARSE_SRC_PAD (parse));
    gst_pb_utils_add_codec_description_to_tag_list (taglist,
        GST_TAG_VIDEO_CODEC, caps);
    gst_caps_unref (caps);

    gst_pad_push_event (GST_BASE_PARSE_SRC_PAD (parse),
        gst_event_new_tag (taglist));

    mpvparse->send_codec_tag = FALSE;
  }

  /* usual clipping applies */
  frame->flags |= GST_BASE_PARSE_FRAME_FLAG_CLIP;

  if (mpvparse->send_mpeg_meta) {
    GstBuffer *buf;

    if (mpvparse->seqhdr_updated)
      seq_hdr = &mpvparse->sequencehdr;
    if (mpvparse->seqext_updated)
      seq_ext = &mpvparse->sequenceext;
    if (mpvparse->seqdispext_updated)
      disp_ext = &mpvparse->sequencedispext;
    if (mpvparse->picext_updated)
      pic_ext = &mpvparse->picext;
    if (mpvparse->quantmatrext_updated)
      quant_ext = &mpvparse->quantmatrext;
    pic_hdr = &mpvparse->pichdr;

    GST_DEBUG_OBJECT (mpvparse,
        "Adding GstMpegVideoMeta (slice_count:%d, slice_offset:%d)",
        mpvparse->slice_count, mpvparse->slice_offset);

    if (frame->out_buffer) {
      buf = frame->out_buffer = gst_buffer_make_writable (frame->out_buffer);
    } else {
      buf = frame->buffer = gst_buffer_make_writable (frame->buffer);
    }

    meta =
        gst_buffer_add_mpeg_video_meta (buf, seq_hdr, seq_ext, disp_ext,
        pic_hdr, pic_ext, quant_ext);
    meta->num_slices = mpvparse->slice_count;
    meta->slice_offset = mpvparse->slice_offset;
  }
  return GST_FLOW_OK;
}

static gboolean
gst_mpegv_parse_set_caps (GstBaseParse * parse, GstCaps * caps)
{
  GstMpegvParse *mpvparse = GST_MPEGVIDEO_PARSE (parse);
  GstStructure *s;
  const GValue *value;
  GstBuffer *buf;

  GST_DEBUG_OBJECT (parse, "setcaps called with %" GST_PTR_FORMAT, caps);

  s = gst_caps_get_structure (caps, 0);

  if ((value = gst_structure_get_value (s, "codec_data")) != NULL
      && (buf = gst_value_get_buffer (value))) {
    GstMapInfo map;
    gst_buffer_map (buf, &map, GST_MAP_READ);
    /* best possible parse attempt,
     * src caps are based on sink caps so it will end up in there
     * whether sucessful or not */
    mpvparse->seq_offset = 4;
    gst_mpegv_parse_process_config (mpvparse, &map, gst_buffer_get_size (buf));
    gst_buffer_unmap (buf, &map);
    gst_mpegv_parse_reset_frame (mpvparse);
  }

  /* let's not interfere and accept regardless of config parsing success */
  return TRUE;
}

static void
remove_fields (GstCaps * caps)
{
  guint i, n;

  n = gst_caps_get_size (caps);
  for (i = 0; i < n; i++) {
    GstStructure *s = gst_caps_get_structure (caps, i);

    gst_structure_remove_field (s, "parsed");
  }
}

static GstCaps *
gst_mpegv_parse_get_caps (GstBaseParse * parse, GstCaps * filter)
{
  GstCaps *peercaps, *templ;
  GstCaps *res;

  templ = gst_pad_get_pad_template_caps (GST_BASE_PARSE_SINK_PAD (parse));
  if (filter) {
    GstCaps *fcopy = gst_caps_copy (filter);
    /* Remove the fields we convert */
    remove_fields (fcopy);
    peercaps = gst_pad_peer_query_caps (GST_BASE_PARSE_SRC_PAD (parse), fcopy);
    gst_caps_unref (fcopy);
  } else
    peercaps = gst_pad_peer_query_caps (GST_BASE_PARSE_SRC_PAD (parse), NULL);

  if (peercaps) {
    /* Remove the parsed field */
    peercaps = gst_caps_make_writable (peercaps);
    remove_fields (peercaps);

    res = gst_caps_intersect_full (peercaps, templ, GST_CAPS_INTERSECT_FIRST);
    gst_caps_unref (peercaps);
    gst_caps_unref (templ);
  } else {
    res = templ;
  }

  if (filter) {
    GstCaps *intersection;

    intersection =
        gst_caps_intersect_full (filter, res, GST_CAPS_INTERSECT_FIRST);
    gst_caps_unref (res);
    res = intersection;
  }

  return res;
}
