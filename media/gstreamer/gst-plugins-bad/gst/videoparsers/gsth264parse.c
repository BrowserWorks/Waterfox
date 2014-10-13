/* GStreamer H.264 Parser
 * Copyright (C) <2010> Collabora ltd
 * Copyright (C) <2010> Nokia Corporation
 * Copyright (C) <2011> Intel Corporation
 *
 * Copyright (C) <2010> Mark Nauwelaerts <mark.nauwelaerts@collabora.co.uk>
 * Copyright (C) <2011> Thibault Saunier <thibault.saunier@collabora.com>
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
#  include "config.h"
#endif

#include <gst/base/base.h>
#include <gst/pbutils/pbutils.h>
#include <gst/video/video.h>
#include "gsth264parse.h"

#include <string.h>

GST_DEBUG_CATEGORY (h264_parse_debug);
#define GST_CAT_DEFAULT h264_parse_debug

#define DEFAULT_CONFIG_INTERVAL      (0)

enum
{
  PROP_0,
  PROP_CONFIG_INTERVAL,
  PROP_LAST
};

enum
{
  GST_H264_PARSE_FORMAT_NONE,
  GST_H264_PARSE_FORMAT_AVC,
  GST_H264_PARSE_FORMAT_BYTE,
  GST_H264_PARSE_FORMAT_AVC3
};

enum
{
  GST_H264_PARSE_ALIGN_NONE = 0,
  GST_H264_PARSE_ALIGN_NAL,
  GST_H264_PARSE_ALIGN_AU
};

enum
{
  GST_H264_PARSE_STATE_GOT_SPS = 1 << 0,
  GST_H264_PARSE_STATE_GOT_PPS = 1 << 1,
  GST_H264_PARSE_STATE_GOT_SLICE = 1 << 2,

  GST_H264_PARSE_STATE_VALID_PICTURE_HEADERS = (GST_H264_PARSE_STATE_GOT_SPS |
      GST_H264_PARSE_STATE_GOT_PPS),
  GST_H264_PARSE_STATE_VALID_PICTURE =
      (GST_H264_PARSE_STATE_VALID_PICTURE_HEADERS |
      GST_H264_PARSE_STATE_GOT_SLICE)
};

#define GST_H264_PARSE_STATE_VALID(parse, expected_state) \
  (((parse)->state & (expected_state)) == (expected_state))

static GstStaticPadTemplate sinktemplate = GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("video/x-h264"));

static GstStaticPadTemplate srctemplate = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("video/x-h264, parsed = (boolean) true, "
        "stream-format=(string) { avc, avc3, byte-stream }, "
        "alignment=(string) { au, nal }"));

#define parent_class gst_h264_parse_parent_class
G_DEFINE_TYPE (GstH264Parse, gst_h264_parse, GST_TYPE_BASE_PARSE);

static void gst_h264_parse_finalize (GObject * object);

static gboolean gst_h264_parse_start (GstBaseParse * parse);
static gboolean gst_h264_parse_stop (GstBaseParse * parse);
static GstFlowReturn gst_h264_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize);
static GstFlowReturn gst_h264_parse_parse_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame);
static GstFlowReturn gst_h264_parse_pre_push_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame);

static void gst_h264_parse_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_h264_parse_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

static gboolean gst_h264_parse_set_caps (GstBaseParse * parse, GstCaps * caps);
static GstCaps *gst_h264_parse_get_caps (GstBaseParse * parse,
    GstCaps * filter);
static gboolean gst_h264_parse_event (GstBaseParse * parse, GstEvent * event);
static gboolean gst_h264_parse_src_event (GstBaseParse * parse,
    GstEvent * event);

static void
gst_h264_parse_class_init (GstH264ParseClass * klass)
{
  GObjectClass *gobject_class = (GObjectClass *) klass;
  GstBaseParseClass *parse_class = GST_BASE_PARSE_CLASS (klass);
  GstElementClass *gstelement_class = GST_ELEMENT_CLASS (klass);

  GST_DEBUG_CATEGORY_INIT (h264_parse_debug, "h264parse", 0, "h264 parser");

  gobject_class->finalize = gst_h264_parse_finalize;
  gobject_class->set_property = gst_h264_parse_set_property;
  gobject_class->get_property = gst_h264_parse_get_property;

  g_object_class_install_property (gobject_class, PROP_CONFIG_INTERVAL,
      g_param_spec_uint ("config-interval",
          "SPS PPS Send Interval",
          "Send SPS and PPS Insertion Interval in seconds (sprop parameter sets "
          "will be multiplexed in the data stream when detected.) (0 = disabled)",
          0, 3600, DEFAULT_CONFIG_INTERVAL,
          G_PARAM_READWRITE | G_PARAM_CONSTRUCT | G_PARAM_STATIC_STRINGS));

  /* Override BaseParse vfuncs */
  parse_class->start = GST_DEBUG_FUNCPTR (gst_h264_parse_start);
  parse_class->stop = GST_DEBUG_FUNCPTR (gst_h264_parse_stop);
  parse_class->handle_frame = GST_DEBUG_FUNCPTR (gst_h264_parse_handle_frame);
  parse_class->pre_push_frame =
      GST_DEBUG_FUNCPTR (gst_h264_parse_pre_push_frame);
  parse_class->set_sink_caps = GST_DEBUG_FUNCPTR (gst_h264_parse_set_caps);
  parse_class->get_sink_caps = GST_DEBUG_FUNCPTR (gst_h264_parse_get_caps);
  parse_class->sink_event = GST_DEBUG_FUNCPTR (gst_h264_parse_event);
  parse_class->src_event = GST_DEBUG_FUNCPTR (gst_h264_parse_src_event);

  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&srctemplate));
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&sinktemplate));

  gst_element_class_set_static_metadata (gstelement_class, "H.264 parser",
      "Codec/Parser/Converter/Video",
      "Parses H.264 streams",
      "Mark Nauwelaerts <mark.nauwelaerts@collabora.co.uk>");
}

static void
gst_h264_parse_init (GstH264Parse * h264parse)
{
  h264parse->frame_out = gst_adapter_new ();
  gst_base_parse_set_pts_interpolation (GST_BASE_PARSE (h264parse), FALSE);
  GST_PAD_SET_ACCEPT_INTERSECT (GST_BASE_PARSE_SINK_PAD (h264parse));
}


static void
gst_h264_parse_finalize (GObject * object)
{
  GstH264Parse *h264parse = GST_H264_PARSE (object);

  g_object_unref (h264parse->frame_out);

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

static void
gst_h264_parse_reset_frame (GstH264Parse * h264parse)
{
  GST_DEBUG_OBJECT (h264parse, "reset frame");

  /* done parsing; reset state */
  h264parse->current_off = -1;

  h264parse->picture_start = FALSE;
  h264parse->update_caps = FALSE;
  h264parse->idr_pos = -1;
  h264parse->sei_pos = -1;
  h264parse->keyframe = FALSE;
  h264parse->frame_start = FALSE;
  gst_adapter_clear (h264parse->frame_out);
}

static void
gst_h264_parse_reset (GstH264Parse * h264parse)
{
  h264parse->width = 0;
  h264parse->height = 0;
  h264parse->fps_num = 0;
  h264parse->fps_den = 0;
  h264parse->upstream_par_n = -1;
  h264parse->upstream_par_d = -1;
  h264parse->parsed_par_n = 0;
  h264parse->parsed_par_d = 0;
  gst_buffer_replace (&h264parse->codec_data, NULL);
  gst_buffer_replace (&h264parse->codec_data_in, NULL);
  h264parse->nal_length_size = 4;
  h264parse->packetized = FALSE;
  h264parse->transform = FALSE;

  h264parse->align = GST_H264_PARSE_ALIGN_NONE;
  h264parse->format = GST_H264_PARSE_FORMAT_NONE;

  h264parse->last_report = GST_CLOCK_TIME_NONE;
  h264parse->push_codec = FALSE;
  h264parse->have_pps = FALSE;
  h264parse->have_sps = FALSE;

  h264parse->dts = GST_CLOCK_TIME_NONE;
  h264parse->ts_trn_nb = GST_CLOCK_TIME_NONE;
  h264parse->do_ts = TRUE;

  h264parse->sent_codec_tag = FALSE;

  h264parse->pending_key_unit_ts = GST_CLOCK_TIME_NONE;
  gst_event_replace (&h264parse->force_key_unit_event, NULL);

  h264parse->discont = FALSE;

  gst_h264_parse_reset_frame (h264parse);
}

static gboolean
gst_h264_parse_start (GstBaseParse * parse)
{
  GstH264Parse *h264parse = GST_H264_PARSE (parse);

  GST_DEBUG_OBJECT (parse, "start");
  gst_h264_parse_reset (h264parse);

  h264parse->nalparser = gst_h264_nal_parser_new ();

  h264parse->dts = GST_CLOCK_TIME_NONE;
  h264parse->ts_trn_nb = GST_CLOCK_TIME_NONE;
  h264parse->sei_pic_struct_pres_flag = FALSE;
  h264parse->sei_pic_struct = 0;
  h264parse->field_pic_flag = 0;

  gst_base_parse_set_min_frame_size (parse, 6);

  return TRUE;
}

static gboolean
gst_h264_parse_stop (GstBaseParse * parse)
{
  guint i;
  GstH264Parse *h264parse = GST_H264_PARSE (parse);

  GST_DEBUG_OBJECT (parse, "stop");
  gst_h264_parse_reset (h264parse);

  for (i = 0; i < GST_H264_MAX_SPS_COUNT; i++)
    gst_buffer_replace (&h264parse->sps_nals[i], NULL);
  for (i = 0; i < GST_H264_MAX_PPS_COUNT; i++)
    gst_buffer_replace (&h264parse->pps_nals[i], NULL);

  gst_h264_nal_parser_free (h264parse->nalparser);

  return TRUE;
}

static const gchar *
gst_h264_parse_get_string (GstH264Parse * parse, gboolean format, gint code)
{
  if (format) {
    switch (code) {
      case GST_H264_PARSE_FORMAT_AVC:
        return "avc";
      case GST_H264_PARSE_FORMAT_BYTE:
        return "byte-stream";
      case GST_H264_PARSE_FORMAT_AVC3:
        return "avc3";
      default:
        return "none";
    }
  } else {
    switch (code) {
      case GST_H264_PARSE_ALIGN_NAL:
        return "nal";
      case GST_H264_PARSE_ALIGN_AU:
        return "au";
      default:
        return "none";
    }
  }
}

static void
gst_h264_parse_format_from_caps (GstCaps * caps, guint * format, guint * align)
{
  if (format)
    *format = GST_H264_PARSE_FORMAT_NONE;

  if (align)
    *align = GST_H264_PARSE_ALIGN_NONE;

  g_return_if_fail (gst_caps_is_fixed (caps));

  GST_DEBUG ("parsing caps: %" GST_PTR_FORMAT, caps);

  if (caps && gst_caps_get_size (caps) > 0) {
    GstStructure *s = gst_caps_get_structure (caps, 0);
    const gchar *str = NULL;

    if (format) {
      if ((str = gst_structure_get_string (s, "stream-format"))) {
        if (strcmp (str, "avc") == 0)
          *format = GST_H264_PARSE_FORMAT_AVC;
        else if (strcmp (str, "byte-stream") == 0)
          *format = GST_H264_PARSE_FORMAT_BYTE;
        else if (strcmp (str, "avc3") == 0)
          *format = GST_H264_PARSE_FORMAT_AVC3;
      }
    }

    if (align) {
      if ((str = gst_structure_get_string (s, "alignment"))) {
        if (strcmp (str, "au") == 0)
          *align = GST_H264_PARSE_ALIGN_AU;
        else if (strcmp (str, "nal") == 0)
          *align = GST_H264_PARSE_ALIGN_NAL;
      }
    }
  }
}

/* check downstream caps to configure format and alignment */
static void
gst_h264_parse_negotiate (GstH264Parse * h264parse, gint in_format,
    GstCaps * in_caps)
{
  GstCaps *caps;
  guint format = GST_H264_PARSE_FORMAT_NONE;
  guint align = GST_H264_PARSE_ALIGN_NONE;

  g_return_if_fail ((in_caps == NULL) || gst_caps_is_fixed (in_caps));

  caps = gst_pad_get_allowed_caps (GST_BASE_PARSE_SRC_PAD (h264parse));
  GST_DEBUG_OBJECT (h264parse, "allowed caps: %" GST_PTR_FORMAT, caps);

  /* concentrate on leading structure, since decodebin2 parser
   * capsfilter always includes parser template caps */
  if (caps) {
    caps = gst_caps_truncate (caps);
    GST_DEBUG_OBJECT (h264parse, "negotiating with caps: %" GST_PTR_FORMAT,
        caps);
  }

  if (in_caps && caps) {
    if (gst_caps_can_intersect (in_caps, caps)) {
      GST_DEBUG_OBJECT (h264parse, "downstream accepts upstream caps");
      gst_h264_parse_format_from_caps (in_caps, &format, &align);
      gst_caps_unref (caps);
      caps = NULL;
    }
  }

  if (caps) {
    /* fixate to avoid ambiguity with lists when parsing */
    caps = gst_caps_fixate (caps);
    gst_h264_parse_format_from_caps (caps, &format, &align);
    gst_caps_unref (caps);
  }

  /* default */
  if (!format)
    format = GST_H264_PARSE_FORMAT_BYTE;
  if (!align)
    align = GST_H264_PARSE_ALIGN_AU;

  GST_DEBUG_OBJECT (h264parse, "selected format %s, alignment %s",
      gst_h264_parse_get_string (h264parse, TRUE, format),
      gst_h264_parse_get_string (h264parse, FALSE, align));

  h264parse->format = format;
  h264parse->align = align;

  h264parse->transform = in_format != h264parse->format ||
      align == GST_H264_PARSE_ALIGN_AU;
}

static GstBuffer *
gst_h264_parse_wrap_nal (GstH264Parse * h264parse, guint format, guint8 * data,
    guint size)
{
  GstBuffer *buf;
  guint nl = h264parse->nal_length_size;
  guint32 tmp;

  GST_DEBUG_OBJECT (h264parse, "nal length %d", size);

  buf = gst_buffer_new_allocate (NULL, 4 + size, NULL);
  if (format == GST_H264_PARSE_FORMAT_AVC
      || format == GST_H264_PARSE_FORMAT_AVC3) {
    tmp = GUINT32_TO_BE (size << (32 - 8 * nl));
  } else {
    /* HACK: nl should always be 4 here, otherwise this won't work. 
     * There are legit cases where nl in avc stream is 2, but byte-stream
     * SC is still always 4 bytes. */
    nl = 4;
    tmp = GUINT32_TO_BE (1);
  }

  gst_buffer_fill (buf, 0, &tmp, sizeof (guint32));
  gst_buffer_fill (buf, nl, data, size);
  gst_buffer_set_size (buf, size + nl);

  return buf;
}

static void
gst_h264_parser_store_nal (GstH264Parse * h264parse, guint id,
    GstH264NalUnitType naltype, GstH264NalUnit * nalu)
{
  GstBuffer *buf, **store;
  guint size = nalu->size, store_size;

  if (naltype == GST_H264_NAL_SPS) {
    store_size = GST_H264_MAX_SPS_COUNT;
    store = h264parse->sps_nals;
    GST_DEBUG_OBJECT (h264parse, "storing sps %u", id);
  } else if (naltype == GST_H264_NAL_PPS) {
    store_size = GST_H264_MAX_PPS_COUNT;
    store = h264parse->pps_nals;
    GST_DEBUG_OBJECT (h264parse, "storing pps %u", id);
  } else
    return;

  if (id >= store_size) {
    GST_DEBUG_OBJECT (h264parse, "unable to store nal, id out-of-range %d", id);
    return;
  }

  buf = gst_buffer_new_allocate (NULL, size, NULL);
  gst_buffer_fill (buf, 0, nalu->data + nalu->offset, size);

  if (store[id])
    gst_buffer_unref (store[id]);

  store[id] = buf;
}

#ifndef GST_DISABLE_GST_DEBUG
static const gchar *nal_names[] = {
  "Unknown",
  "Slice",
  "Slice DPA",
  "Slice DPB",
  "Slice DPC",
  "Slice IDR",
  "SEI",
  "SPS",
  "PPS",
  "AU delimiter",
  "Sequence End",
  "Stream End",
  "Filler Data"
};

static const gchar *
_nal_name (GstH264NalUnitType nal_type)
{
  if (nal_type <= GST_H264_NAL_FILLER_DATA)
    return nal_names[nal_type];
  return "Invalid";
}
#endif

static void
gst_h264_parse_process_sei (GstH264Parse * h264parse, GstH264NalUnit * nalu)
{
  GstH264SEIMessage sei;
  GstH264NalParser *nalparser = h264parse->nalparser;
  GstH264ParserResult pres;
  GArray *messages;
  guint i;

  pres = gst_h264_parser_parse_sei (nalparser, nalu, &messages);
  if (pres != GST_H264_PARSER_OK)
    GST_WARNING_OBJECT (h264parse, "failed to parse one ore more SEI message");

  /* Even if pres != GST_H264_PARSER_OK, some message could have been parsed and
   * stored in messages.
   */
  for (i = 0; i < messages->len; i++) {
    sei = g_array_index (messages, GstH264SEIMessage, i);
    switch (sei.payloadType) {
      case GST_H264_SEI_PIC_TIMING:
        h264parse->sei_pic_struct_pres_flag =
            sei.payload.pic_timing.pic_struct_present_flag;
        h264parse->sei_cpb_removal_delay =
            sei.payload.pic_timing.cpb_removal_delay;
        if (h264parse->sei_pic_struct_pres_flag)
          h264parse->sei_pic_struct = sei.payload.pic_timing.pic_struct;
        GST_LOG_OBJECT (h264parse, "pic timing updated");
        break;
      case GST_H264_SEI_BUF_PERIOD:
        if (h264parse->ts_trn_nb == GST_CLOCK_TIME_NONE ||
            h264parse->dts == GST_CLOCK_TIME_NONE)
          h264parse->ts_trn_nb = 0;
        else
          h264parse->ts_trn_nb = h264parse->dts;

        GST_LOG_OBJECT (h264parse,
            "new buffering period; ts_trn_nb updated: %" GST_TIME_FORMAT,
            GST_TIME_ARGS (h264parse->ts_trn_nb));
        break;

        /* Additional messages that are not innerly useful to the
         * element but for debugging purposes */
      case GST_H264_SEI_RECOVERY_POINT:
        GST_LOG_OBJECT (h264parse, "recovery point found: %u %u %u %u",
            sei.payload.recovery_point.recovery_frame_cnt,
            sei.payload.recovery_point.exact_match_flag,
            sei.payload.recovery_point.broken_link_flag,
            sei.payload.recovery_point.changing_slice_group_idc);
        break;
    }
  }
  g_array_free (messages, TRUE);
}

/* caller guarantees 2 bytes of nal payload */
static gboolean
gst_h264_parse_process_nal (GstH264Parse * h264parse, GstH264NalUnit * nalu)
{
  guint nal_type;
  GstH264PPS pps = { 0, };
  GstH264SPS sps = { 0, };
  GstH264NalParser *nalparser = h264parse->nalparser;
  GstH264ParserResult pres;

  /* nothing to do for broken input */
  if (G_UNLIKELY (nalu->size < 2)) {
    GST_DEBUG_OBJECT (h264parse, "not processing nal size %u", nalu->size);
    return TRUE;
  }

  /* we have a peek as well */
  nal_type = nalu->type;

  GST_DEBUG_OBJECT (h264parse, "processing nal of type %u %s, size %u",
      nal_type, _nal_name (nal_type), nalu->size);

  switch (nal_type) {
    case GST_H264_NAL_SPS:
      /* reset state, everything else is obsolete */
      h264parse->state = 0;

      pres = gst_h264_parser_parse_sps (nalparser, nalu, &sps, TRUE);
      /* arranged for a fallback sps.id, so use that one and only warn */
      if (pres != GST_H264_PARSER_OK) {
        GST_WARNING_OBJECT (h264parse, "failed to parse SPS:");
        return FALSE;
      }

      GST_DEBUG_OBJECT (h264parse, "triggering src caps check");
      h264parse->update_caps = TRUE;
      h264parse->have_sps = TRUE;
      if (h264parse->push_codec && h264parse->have_pps) {
        /* SPS and PPS found in stream before the first pre_push_frame, no need
         * to forcibly push at start */
        GST_INFO_OBJECT (h264parse, "have SPS/PPS in stream");
        h264parse->push_codec = FALSE;
        h264parse->have_sps = FALSE;
        h264parse->have_pps = FALSE;
      }

      gst_h264_parser_store_nal (h264parse, sps.id, nal_type, nalu);
      h264parse->state |= GST_H264_PARSE_STATE_GOT_SPS;
      break;
    case GST_H264_NAL_PPS:
      /* expected state: got-sps */
      h264parse->state &= GST_H264_PARSE_STATE_GOT_SPS;
      if (!GST_H264_PARSE_STATE_VALID (h264parse, GST_H264_PARSE_STATE_GOT_SPS))
        return FALSE;

      pres = gst_h264_parser_parse_pps (nalparser, nalu, &pps);
      /* arranged for a fallback pps.id, so use that one and only warn */
      if (pres != GST_H264_PARSER_OK) {
        GST_WARNING_OBJECT (h264parse, "failed to parse PPS:");
        if (pres != GST_H264_PARSER_BROKEN_LINK)
          return FALSE;
      }

      /* parameters might have changed, force caps check */
      if (!h264parse->have_pps) {
        GST_DEBUG_OBJECT (h264parse, "triggering src caps check");
        h264parse->update_caps = TRUE;
      }
      h264parse->have_pps = TRUE;
      if (h264parse->push_codec && h264parse->have_sps) {
        /* SPS and PPS found in stream before the first pre_push_frame, no need
         * to forcibly push at start */
        GST_INFO_OBJECT (h264parse, "have SPS/PPS in stream");
        h264parse->push_codec = FALSE;
        h264parse->have_sps = FALSE;
        h264parse->have_pps = FALSE;
      }

      gst_h264_parser_store_nal (h264parse, pps.id, nal_type, nalu);
      gst_h264_pps_clear (&pps);
      h264parse->state |= GST_H264_PARSE_STATE_GOT_PPS;
      break;
    case GST_H264_NAL_SEI:
      /* expected state: got-sps */
      if (!GST_H264_PARSE_STATE_VALID (h264parse, GST_H264_PARSE_STATE_GOT_SPS))
        return FALSE;

      gst_h264_parse_process_sei (h264parse, nalu);
      /* mark SEI pos */
      if (h264parse->sei_pos == -1) {
        if (h264parse->transform)
          h264parse->sei_pos = gst_adapter_available (h264parse->frame_out);
        else
          h264parse->sei_pos = nalu->sc_offset;
        GST_DEBUG_OBJECT (h264parse, "marking SEI in frame at offset %d",
            h264parse->sei_pos);
      }
      break;

    case GST_H264_NAL_SLICE:
    case GST_H264_NAL_SLICE_DPA:
    case GST_H264_NAL_SLICE_DPB:
    case GST_H264_NAL_SLICE_DPC:
    case GST_H264_NAL_SLICE_IDR:
      /* expected state: got-sps|got-pps (valid picture headers) */
      h264parse->state &= GST_H264_PARSE_STATE_VALID_PICTURE_HEADERS;
      if (!GST_H264_PARSE_STATE_VALID (h264parse,
              GST_H264_PARSE_STATE_VALID_PICTURE_HEADERS))
        return FALSE;

      /* don't need to parse the whole slice (header) here */
      if (*(nalu->data + nalu->offset + 1) & 0x80) {
        /* means first_mb_in_slice == 0 */
        /* real frame data */
        GST_DEBUG_OBJECT (h264parse, "first_mb_in_slice = 0");
        h264parse->frame_start = TRUE;
      }
      GST_DEBUG_OBJECT (h264parse, "frame start: %i", h264parse->frame_start);
      {
        GstH264SliceHdr slice;

        pres = gst_h264_parser_parse_slice_hdr (nalparser, nalu, &slice,
            FALSE, FALSE);
        GST_DEBUG_OBJECT (h264parse,
            "parse result %d, first MB: %u, slice type: %u",
            pres, slice.first_mb_in_slice, slice.type);
        if (pres == GST_H264_PARSER_OK) {
          if (GST_H264_IS_I_SLICE (&slice) || GST_H264_IS_SI_SLICE (&slice))
            h264parse->keyframe |= TRUE;

          h264parse->state |= GST_H264_PARSE_STATE_GOT_SLICE;
          h264parse->field_pic_flag = slice.field_pic_flag;
        }
      }
      if (G_LIKELY (nal_type != GST_H264_NAL_SLICE_IDR &&
              !h264parse->push_codec))
        break;
      /* if we need to sneak codec NALs into the stream,
       * this is a good place, so fake it as IDR
       * (which should be at start anyway) */
      /* mark where config needs to go if interval expired */
      /* mind replacement buffer if applicable */
      if (h264parse->idr_pos == -1) {
        if (h264parse->transform)
          h264parse->idr_pos = gst_adapter_available (h264parse->frame_out);
        else
          h264parse->idr_pos = nalu->sc_offset;
        GST_DEBUG_OBJECT (h264parse, "marking IDR in frame at offset %d",
            h264parse->idr_pos);
      }
      /* if SEI preceeds (faked) IDR, then we have to insert config there */
      if (h264parse->sei_pos >= 0 && h264parse->idr_pos > h264parse->sei_pos) {
        h264parse->idr_pos = h264parse->sei_pos;
        GST_DEBUG_OBJECT (h264parse, "moved IDR mark to SEI position %d",
            h264parse->idr_pos);
      }
      break;
    default:
      /* drop anything before the initial SPS */
      if (!GST_H264_PARSE_STATE_VALID (h264parse, GST_H264_PARSE_STATE_GOT_SPS))
        return FALSE;

      pres = gst_h264_parser_parse_nal (nalparser, nalu);
      if (pres != GST_H264_PARSER_OK)
        return FALSE;
      break;
  }

  /* if AVC output needed, collect properly prefixed nal in adapter,
   * and use that to replace outgoing buffer data later on */
  if (h264parse->transform) {
    GstBuffer *buf;

    GST_LOG_OBJECT (h264parse, "collecting NAL in AVC frame");
    buf = gst_h264_parse_wrap_nal (h264parse, h264parse->format,
        nalu->data + nalu->offset, nalu->size);
    gst_adapter_push (h264parse->frame_out, buf);
  }
  return TRUE;
}

/* caller guarantees at least 2 bytes of nal payload for each nal
 * returns TRUE if next_nal indicates that nal terminates an AU */
static inline gboolean
gst_h264_parse_collect_nal (GstH264Parse * h264parse, const guint8 * data,
    guint size, GstH264NalUnit * nalu)
{
  gboolean complete;
  GstH264ParserResult parse_res;
  GstH264NalUnitType nal_type = nalu->type;
  GstH264NalUnit nnalu;

  GST_DEBUG_OBJECT (h264parse, "parsing collected nal");
  parse_res = gst_h264_parser_identify_nalu_unchecked (h264parse->nalparser,
      data, nalu->offset + nalu->size, size, &nnalu);

  if (parse_res != GST_H264_PARSER_OK)
    return FALSE;

  /* determine if AU complete */
  GST_LOG_OBJECT (h264parse, "nal type: %d %s", nal_type, _nal_name (nal_type));
  /* coded slice NAL starts a picture,
   * i.e. other types become aggregated in front of it */
  h264parse->picture_start |= (nal_type == GST_H264_NAL_SLICE ||
      nal_type == GST_H264_NAL_SLICE_DPA || nal_type == GST_H264_NAL_SLICE_IDR);

  /* consider a coded slices (IDR or not) to start a picture,
   * (so ending the previous one) if first_mb_in_slice == 0
   * (non-0 is part of previous one) */
  /* NOTE this is not entirely according to Access Unit specs in 7.4.1.2.4,
   * but in practice it works in sane cases, needs not much parsing,
   * and also works with broken frame_num in NAL
   * (where spec-wise would fail) */
  nal_type = nnalu.type;
  complete = h264parse->picture_start && (nal_type >= GST_H264_NAL_SEI &&
      nal_type <= GST_H264_NAL_AU_DELIMITER);

  GST_LOG_OBJECT (h264parse, "next nal type: %d %s", nal_type,
      _nal_name (nal_type));
  complete |= h264parse->picture_start && (nal_type == GST_H264_NAL_SLICE
      || nal_type == GST_H264_NAL_SLICE_DPA
      || nal_type == GST_H264_NAL_SLICE_IDR) &&
      /* first_mb_in_slice == 0 considered start of frame */
      (nnalu.data[nnalu.offset + 1] & 0x80);

  GST_LOG_OBJECT (h264parse, "au complete: %d", complete);

  return complete;
}


static GstFlowReturn
gst_h264_parse_handle_frame_packetized (GstBaseParse * parse,
    GstBaseParseFrame * frame)
{
  GstH264Parse *h264parse = GST_H264_PARSE (parse);
  GstBuffer *buffer = frame->buffer;
  GstFlowReturn ret = GST_FLOW_OK;
  GstH264ParserResult parse_res;
  GstH264NalUnit nalu;
  const guint nl = h264parse->nal_length_size;
  GstMapInfo map;
  gint left;

  if (nl < 1 || nl > 4) {
    GST_DEBUG_OBJECT (h264parse, "insufficient data to split input");
    return GST_FLOW_NOT_NEGOTIATED;
  }

  /* need to save buffer from invalidation upon _finish_frame */
  if (h264parse->split_packetized)
    buffer = gst_buffer_copy (frame->buffer);

  gst_buffer_map (buffer, &map, GST_MAP_READ);

  left = map.size;

  GST_LOG_OBJECT (h264parse,
      "processing packet buffer of size %" G_GSIZE_FORMAT, map.size);

  parse_res = gst_h264_parser_identify_nalu_avc (h264parse->nalparser,
      map.data, 0, map.size, nl, &nalu);

  while (parse_res == GST_H264_PARSER_OK) {
    GST_DEBUG_OBJECT (h264parse, "AVC nal offset %d", nalu.offset + nalu.size);

    /* either way, have a look at it */
    gst_h264_parse_process_nal (h264parse, &nalu);

    /* dispatch per NALU if needed */
    if (h264parse->split_packetized) {
      GstBaseParseFrame tmp_frame;

      gst_base_parse_frame_init (&tmp_frame);
      tmp_frame.flags |= frame->flags;
      tmp_frame.offset = frame->offset;
      tmp_frame.overhead = frame->overhead;
      tmp_frame.buffer = gst_buffer_copy_region (buffer, GST_BUFFER_COPY_ALL,
          nalu.offset, nalu.size);

      /* note we don't need to come up with a sub-buffer, since
       * subsequent code only considers input buffer's metadata.
       * Real data is either taken from input by baseclass or
       * a replacement output buffer is provided anyway. */
      gst_h264_parse_parse_frame (parse, &tmp_frame);
      ret = gst_base_parse_finish_frame (parse, &tmp_frame, nl + nalu.size);
      left -= nl + nalu.size;
    }

    parse_res = gst_h264_parser_identify_nalu_avc (h264parse->nalparser,
        map.data, nalu.offset + nalu.size, map.size, nl, &nalu);
  }

  gst_buffer_unmap (buffer, &map);

  if (!h264parse->split_packetized) {
    gst_h264_parse_parse_frame (parse, frame);
    ret = gst_base_parse_finish_frame (parse, frame, map.size);
  } else {
    gst_buffer_unref (buffer);
    if (G_UNLIKELY (left)) {
      /* should not be happening for nice AVC */
      GST_WARNING_OBJECT (parse, "skipping leftover AVC data %d", left);
      frame->flags |= GST_BASE_PARSE_FRAME_FLAG_DROP;
      ret = gst_base_parse_finish_frame (parse, frame, map.size);
    }
  }

  if (parse_res == GST_H264_PARSER_NO_NAL_END ||
      parse_res == GST_H264_PARSER_BROKEN_DATA) {

    if (h264parse->split_packetized) {
      GST_ELEMENT_ERROR (h264parse, STREAM, FAILED, (NULL),
          ("invalid AVC input data"));
      gst_buffer_unref (buffer);

      return GST_FLOW_ERROR;
    } else {
      /* do not meddle to much in this case */
      GST_DEBUG_OBJECT (h264parse, "parsing packet failed");
    }
  }

  return ret;
}

static GstFlowReturn
gst_h264_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize)
{
  GstH264Parse *h264parse = GST_H264_PARSE (parse);
  GstBuffer *buffer = frame->buffer;
  GstMapInfo map;
  guint8 *data;
  gsize size;
  gint current_off = 0;
  gboolean drain, nonext;
  GstH264NalParser *nalparser = h264parse->nalparser;
  GstH264NalUnit nalu;
  GstH264ParserResult pres;
  gint framesize;

  if (G_UNLIKELY (GST_BUFFER_FLAG_IS_SET (frame->buffer,
              GST_BUFFER_FLAG_DISCONT))) {
    h264parse->discont = TRUE;
  }

  /* delegate in packetized case, no skipping should be needed */
  if (h264parse->packetized)
    return gst_h264_parse_handle_frame_packetized (parse, frame);

  gst_buffer_map (buffer, &map, GST_MAP_READ);
  data = map.data;
  size = map.size;

  /* expect at least 3 bytes startcode == sc, and 2 bytes NALU payload */
  if (G_UNLIKELY (size < 5)) {
    gst_buffer_unmap (buffer, &map);
    *skipsize = 1;
    return GST_FLOW_OK;
  }

  /* need to configure aggregation */
  if (G_UNLIKELY (h264parse->format == GST_H264_PARSE_FORMAT_NONE))
    gst_h264_parse_negotiate (h264parse, GST_H264_PARSE_FORMAT_BYTE, NULL);

  /* avoid stale cached parsing state */
  if (frame->flags & GST_BASE_PARSE_FRAME_FLAG_NEW_FRAME) {
    GST_LOG_OBJECT (h264parse, "parsing new frame");
    gst_h264_parse_reset_frame (h264parse);
  } else {
    GST_LOG_OBJECT (h264parse, "resuming frame parsing");
  }

  drain = GST_BASE_PARSE_DRAINING (parse);
  nonext = FALSE;

  current_off = h264parse->current_off;
  if (current_off < 0)
    current_off = 0;
  g_assert (current_off < size);
  GST_DEBUG_OBJECT (h264parse, "last parse position %d", current_off);

  /* check for initial skip */
  if (h264parse->current_off == -1) {
    pres =
        gst_h264_parser_identify_nalu_unchecked (nalparser, data, current_off,
        size, &nalu);
    switch (pres) {
      case GST_H264_PARSER_OK:
        if (nalu.sc_offset > 0) {
          *skipsize = nalu.sc_offset;
          goto skip;
        }
        break;
      case GST_H264_PARSER_NO_NAL:
        *skipsize = size - 3;
        goto skip;
        break;
      default:
        g_assert_not_reached ();
        break;
    }
  }

  while (TRUE) {
    pres =
        gst_h264_parser_identify_nalu (nalparser, data, current_off, size,
        &nalu);

    switch (pres) {
      case GST_H264_PARSER_OK:
        GST_DEBUG_OBJECT (h264parse, "complete nal (offset, size): (%u, %u) ",
            nalu.offset, nalu.size);
        break;
      case GST_H264_PARSER_NO_NAL_END:
        GST_DEBUG_OBJECT (h264parse, "not a complete nal found at offset %u",
            nalu.offset);
        /* if draining, accept it as complete nal */
        if (drain) {
          nonext = TRUE;
          nalu.size = size - nalu.offset;
          GST_DEBUG_OBJECT (h264parse, "draining, accepting with size %u",
              nalu.size);
          /* if it's not too short at least */
          if (nalu.size < 2)
            goto broken;
          break;
        }
        /* otherwise need more */
        goto more;
      case GST_H264_PARSER_BROKEN_LINK:
        GST_ELEMENT_ERROR (h264parse, STREAM, FORMAT,
            ("Error parsing H.264 stream"),
            ("The link to structure needed for the parsing couldn't be found"));
        goto invalid_stream;
      case GST_H264_PARSER_ERROR:
        /* should not really occur either */
        GST_ELEMENT_ERROR (h264parse, STREAM, FORMAT,
            ("Error parsing H.264 stream"), ("Invalid H.264 stream"));
        goto invalid_stream;
      case GST_H264_PARSER_NO_NAL:
        GST_ELEMENT_ERROR (h264parse, STREAM, FORMAT,
            ("Error parsing H.264 stream"), ("No H.264 NAL unit found"));
        goto invalid_stream;
      case GST_H264_PARSER_BROKEN_DATA:
        GST_WARNING_OBJECT (h264parse, "input stream is corrupt; "
            "it contains a NAL unit of length %u", nalu.size);
      broken:
        /* broken nal at start -> arrange to skip it,
         * otherwise have it terminate current au
         * (and so it will be skipped on next frame round) */
        if (current_off == 0) {
          GST_DEBUG_OBJECT (h264parse, "skipping broken nal");
          *skipsize = nalu.offset;
          goto skip;
        } else {
          GST_DEBUG_OBJECT (h264parse, "terminating au");
          nalu.size = 0;
          nalu.offset = nalu.sc_offset;
          goto end;
        }
        break;
      default:
        g_assert_not_reached ();
        break;
    }

    GST_DEBUG_OBJECT (h264parse, "%p complete nal found. Off: %u, Size: %u",
        data, nalu.offset, nalu.size);

    /* simulate no next nal if none needed */
    nonext = nonext || (h264parse->align == GST_H264_PARSE_ALIGN_NAL);

    if (!nonext) {
      if (nalu.offset + nalu.size + 4 + 2 > size) {
        GST_DEBUG_OBJECT (h264parse, "not enough data for next NALU");
        if (drain) {
          GST_DEBUG_OBJECT (h264parse, "but draining anyway");
          nonext = TRUE;
        } else {
          goto more;
        }
      }
    }

    if (!gst_h264_parse_process_nal (h264parse, &nalu)) {
      GST_WARNING_OBJECT (h264parse,
          "broken/invalid nal Type: %d %s, Size: %u will be dropped",
          nalu.type, _nal_name (nalu.type), nalu.size);
      *skipsize = nalu.size;
      goto skip;
    }

    if (nonext)
      break;

    /* if no next nal, we know it's complete here */
    if (gst_h264_parse_collect_nal (h264parse, data, size, &nalu))
      break;

    GST_DEBUG_OBJECT (h264parse, "Looking for more");
    current_off = nalu.offset + nalu.size;
  }

end:
  framesize = nalu.offset + nalu.size;

  gst_buffer_unmap (buffer, &map);

  gst_h264_parse_parse_frame (parse, frame);

  return gst_base_parse_finish_frame (parse, frame, framesize);

more:
  *skipsize = 0;

  /* Restart parsing from here next time */
  if (current_off > 0)
    h264parse->current_off = current_off;

  /* Fall-through. */
out:
  gst_buffer_unmap (buffer, &map);
  return GST_FLOW_OK;

skip:
  GST_DEBUG_OBJECT (h264parse, "skipping %d", *skipsize);
  /* If we are collecting access units, we need to preserve the initial
   * config headers (SPS, PPS et al.) and only reset the frame if another
   * slice NAL was received. This means that broken pictures are discarded */
  if (h264parse->align != GST_H264_PARSE_ALIGN_AU ||
      !(h264parse->state & GST_H264_PARSE_STATE_VALID_PICTURE_HEADERS) ||
      (h264parse->state & GST_H264_PARSE_STATE_GOT_SLICE))
    gst_h264_parse_reset_frame (h264parse);
  goto out;

invalid_stream:
  gst_buffer_unmap (buffer, &map);
  return GST_FLOW_ERROR;
}

/* byte together avc codec data based on collected pps and sps so far */
static GstBuffer *
gst_h264_parse_make_codec_data (GstH264Parse * h264parse)
{
  GstBuffer *buf, *nal;
  gint i, sps_size = 0, pps_size = 0, num_sps = 0, num_pps = 0;
  guint8 profile_idc = 0, profile_comp = 0, level_idc = 0;
  gboolean found = FALSE;
  GstMapInfo map;
  guint8 *data;
  gint nl;

  /* only nal payload in stored nals */

  for (i = 0; i < GST_H264_MAX_SPS_COUNT; i++) {
    if ((nal = h264parse->sps_nals[i])) {
      gsize size = gst_buffer_get_size (nal);
      num_sps++;
      /* size bytes also count */
      sps_size += size + 2;
      if (size >= 4) {
        guint8 tmp[3];
        found = TRUE;
        gst_buffer_extract (nal, 1, tmp, 3);
        profile_idc = tmp[0];
        profile_comp = tmp[1];
        level_idc = tmp[2];
      }
    }
  }
  for (i = 0; i < GST_H264_MAX_PPS_COUNT; i++) {
    if ((nal = h264parse->pps_nals[i])) {
      num_pps++;
      /* size bytes also count */
      pps_size += gst_buffer_get_size (nal) + 2;
    }
  }

  /* AVC3 has SPS/PPS inside the stream, not in the codec_data */
  if (h264parse->format == GST_H264_PARSE_FORMAT_AVC3) {
    num_sps = sps_size = 0;
    num_pps = pps_size = 0;
  }

  GST_DEBUG_OBJECT (h264parse,
      "constructing codec_data: num_sps=%d, num_pps=%d", num_sps, num_pps);

  if (!found || (0 == num_pps
          && GST_H264_PARSE_FORMAT_AVC3 != h264parse->format))
    return NULL;

  buf = gst_buffer_new_allocate (NULL, 5 + 1 + sps_size + 1 + pps_size, NULL);
  gst_buffer_map (buf, &map, GST_MAP_WRITE);
  data = map.data;
  nl = h264parse->nal_length_size;

  data[0] = 1;                  /* AVC Decoder Configuration Record ver. 1 */
  data[1] = profile_idc;        /* profile_idc                             */
  data[2] = profile_comp;       /* profile_compability                     */
  data[3] = level_idc;          /* level_idc                               */
  data[4] = 0xfc | (nl - 1);    /* nal_length_size_minus1                  */
  data[5] = 0xe0 | num_sps;     /* number of SPSs */

  data += 6;
  if (h264parse->format != GST_H264_PARSE_FORMAT_AVC3) {
    for (i = 0; i < GST_H264_MAX_SPS_COUNT; i++) {
      if ((nal = h264parse->sps_nals[i])) {
        gsize nal_size = gst_buffer_get_size (nal);
        GST_WRITE_UINT16_BE (data, nal_size);
        gst_buffer_extract (nal, 0, data + 2, nal_size);
        data += 2 + nal_size;
      }
    }
  }

  data[0] = num_pps;
  data++;
  if (h264parse->format != GST_H264_PARSE_FORMAT_AVC3) {
    for (i = 0; i < GST_H264_MAX_PPS_COUNT; i++) {
      if ((nal = h264parse->pps_nals[i])) {
        gsize nal_size = gst_buffer_get_size (nal);
        GST_WRITE_UINT16_BE (data, nal_size);
        gst_buffer_extract (nal, 0, data + 2, nal_size);
        data += 2 + nal_size;
      }
    }
  }

  gst_buffer_unmap (buf, &map);

  return buf;
}

static void
gst_h264_parse_get_par (GstH264Parse * h264parse, gint * num, gint * den)
{
  if (h264parse->upstream_par_n != -1 && h264parse->upstream_par_d != -1) {
    *num = h264parse->upstream_par_n;
    *den = h264parse->upstream_par_d;
  } else {
    *num = h264parse->parsed_par_n;
    *den = h264parse->parsed_par_d;
  }
}

static void
gst_h264_parse_update_src_caps (GstH264Parse * h264parse, GstCaps * caps)
{
  GstH264SPS *sps;
  GstCaps *sink_caps, *src_caps;
  gboolean modified = FALSE;
  GstBuffer *buf = NULL;
  GstStructure *s = NULL;

  if (G_UNLIKELY (!gst_pad_has_current_caps (GST_BASE_PARSE_SRC_PAD
              (h264parse))))
    modified = TRUE;
  else if (G_UNLIKELY (!h264parse->update_caps))
    return;

  /* if this is being called from the first _setcaps call, caps on the sinkpad
   * aren't set yet and so they need to be passed as an argument */
  if (caps)
    sink_caps = gst_caps_ref (caps);
  else
    sink_caps = gst_pad_get_current_caps (GST_BASE_PARSE_SINK_PAD (h264parse));

  /* carry over input caps as much as possible; override with our own stuff */
  if (!sink_caps)
    sink_caps = gst_caps_new_empty_simple ("video/x-h264");
  else
    s = gst_caps_get_structure (sink_caps, 0);

  sps = h264parse->nalparser->last_sps;
  GST_DEBUG_OBJECT (h264parse, "sps: %p", sps);

  /* only codec-data for nice-and-clean au aligned packetized avc format */
  if ((h264parse->format == GST_H264_PARSE_FORMAT_AVC
          || h264parse->format == GST_H264_PARSE_FORMAT_AVC3)
      && h264parse->align == GST_H264_PARSE_ALIGN_AU) {
    buf = gst_h264_parse_make_codec_data (h264parse);
    if (buf && h264parse->codec_data) {
      GstMapInfo map;

      gst_buffer_map (buf, &map, GST_MAP_READ);
      if (map.size != gst_buffer_get_size (h264parse->codec_data) ||
          gst_buffer_memcmp (h264parse->codec_data, 0, map.data, map.size))
        modified = TRUE;

      gst_buffer_unmap (buf, &map);
    } else {
      if (!buf && h264parse->codec_data_in)
        buf = gst_buffer_ref (h264parse->codec_data_in);
      modified = TRUE;
    }
  }

  caps = NULL;
  if (G_UNLIKELY (!sps)) {
    caps = gst_caps_copy (sink_caps);
  } else {
    gint crop_width, crop_height;
    gint fps_num, fps_den;

    if (sps->frame_cropping_flag) {
      crop_width = sps->crop_rect_width;
      crop_height = sps->crop_rect_height;
    } else {
      crop_width = sps->width;
      crop_height = sps->height;
    }

    if (G_UNLIKELY (h264parse->width != crop_width ||
            h264parse->height != crop_height)) {
      GST_INFO_OBJECT (h264parse, "resolution changed %dx%d",
          crop_width, crop_height);
      h264parse->width = crop_width;
      h264parse->height = crop_height;
      modified = TRUE;
    }

    /* 0/1 is set as the default in the codec parser, we will set
     * it in case we have no info */
    gst_h264_video_calculate_framerate (sps, h264parse->field_pic_flag,
        h264parse->sei_pic_struct, &fps_num, &fps_den);
    if (G_UNLIKELY (h264parse->fps_num != fps_num
            || h264parse->fps_den != fps_den)) {
      GST_DEBUG_OBJECT (h264parse, "framerate changed %d/%d", fps_num, fps_den);
      h264parse->fps_num = fps_num;
      h264parse->fps_den = fps_den;
      modified = TRUE;
    }

    if (sps->vui_parameters.aspect_ratio_info_present_flag) {
      if (G_UNLIKELY ((h264parse->parsed_par_n != sps->vui_parameters.par_n)
              || (h264parse->parsed_par_d != sps->vui_parameters.par_d))) {
        h264parse->parsed_par_n = sps->vui_parameters.par_n;
        h264parse->parsed_par_d = sps->vui_parameters.par_d;
        GST_INFO_OBJECT (h264parse, "pixel aspect ratio has been changed %d/%d",
            h264parse->parsed_par_n, h264parse->parsed_par_d);
      }
    }

    if (G_UNLIKELY (modified || h264parse->update_caps)) {
      gint width, height;
      GstClockTime latency;

      fps_num = h264parse->fps_num;
      fps_den = h264parse->fps_den;

      caps = gst_caps_copy (sink_caps);

      /* sps should give this but upstream overrides */
      if (s && gst_structure_has_field (s, "width"))
        gst_structure_get_int (s, "width", &width);
      else
        width = h264parse->width;

      if (s && gst_structure_has_field (s, "height"))
        gst_structure_get_int (s, "height", &height);
      else
        height = h264parse->height;

      gst_caps_set_simple (caps, "width", G_TYPE_INT, width,
          "height", G_TYPE_INT, height, NULL);

      /* upstream overrides */
      if (s && gst_structure_has_field (s, "framerate"))
        gst_structure_get_fraction (s, "framerate", &fps_num, &fps_den);

      /* but not necessarily or reliably this */
      if (fps_den > 0) {
        gst_caps_set_simple (caps, "framerate",
            GST_TYPE_FRACTION, fps_num, fps_den, NULL);
        gst_base_parse_set_frame_rate (GST_BASE_PARSE (h264parse),
            fps_num, fps_den, 0, 0);
        if (fps_num > 0) {
          latency = gst_util_uint64_scale (GST_SECOND, fps_den, fps_num);
          gst_base_parse_set_latency (GST_BASE_PARSE (h264parse), latency,
              latency);
        }
      }
    }
  }

  if (caps) {
    gint par_n, par_d;

    gst_caps_set_simple (caps, "parsed", G_TYPE_BOOLEAN, TRUE,
        "stream-format", G_TYPE_STRING,
        gst_h264_parse_get_string (h264parse, TRUE, h264parse->format),
        "alignment", G_TYPE_STRING,
        gst_h264_parse_get_string (h264parse, FALSE, h264parse->align), NULL);

    gst_h264_parse_get_par (h264parse, &par_n, &par_d);
    if (par_n != 0 && par_d != 0 &&
        (!s || !gst_structure_has_field (s, "pixel-aspect-ratio"))) {
      GST_INFO_OBJECT (h264parse, "PAR %d/%d", par_n, par_d);
      gst_caps_set_simple (caps, "pixel-aspect-ratio", GST_TYPE_FRACTION,
          par_n, par_d, NULL);
    }

    src_caps = gst_pad_get_current_caps (GST_BASE_PARSE_SRC_PAD (h264parse));

    if (src_caps
        && gst_structure_has_field (gst_caps_get_structure (src_caps, 0),
            "codec_data")) {
      /* use codec data from old caps for comparison; we don't want to resend caps
         if everything is same except codec data; */
      gst_caps_set_value (caps, "codec_data",
          gst_structure_get_value (gst_caps_get_structure (src_caps, 0),
              "codec_data"));
    }

    if (!(src_caps && gst_caps_is_strictly_equal (src_caps, caps))) {
      /* update codec data to new value */
      if (buf) {
        gst_caps_set_simple (caps, "codec_data", GST_TYPE_BUFFER, buf, NULL);
        gst_buffer_replace (&h264parse->codec_data, buf);
        gst_buffer_unref (buf);
        buf = NULL;
      } else {
        GstStructure *s;
        /* remove any left-over codec-data hanging around */
        s = gst_caps_get_structure (caps, 0);
        gst_structure_remove_field (s, "codec_data");
        gst_buffer_replace (&h264parse->codec_data, NULL);
      }

      gst_pad_set_caps (GST_BASE_PARSE_SRC_PAD (h264parse), caps);
    }

    if (src_caps)
      gst_caps_unref (src_caps);
    gst_caps_unref (caps);
  }

  gst_caps_unref (sink_caps);
  if (buf)
    gst_buffer_unref (buf);
}

static void
gst_h264_parse_get_timestamp (GstH264Parse * h264parse,
    GstClockTime * out_ts, GstClockTime * out_dur, gboolean frame)
{
  GstH264SPS *sps = h264parse->nalparser->last_sps;
  GstClockTime upstream;
  gint duration = 1;

  g_return_if_fail (out_dur != NULL);
  g_return_if_fail (out_ts != NULL);

  upstream = *out_ts;

  if (!frame) {
    GST_LOG_OBJECT (h264parse, "no frame data ->  0 duration");
    *out_dur = 0;
    goto exit;
  } else {
    *out_ts = upstream;
  }

  if (!sps) {
    GST_DEBUG_OBJECT (h264parse, "referred SPS invalid");
    goto exit;
  } else if (!sps->vui_parameters_present_flag) {
    GST_DEBUG_OBJECT (h264parse,
        "unable to compute timestamp: VUI not present");
    goto exit;
  } else if (!sps->vui_parameters.timing_info_present_flag) {
    GST_DEBUG_OBJECT (h264parse,
        "unable to compute timestamp: timing info not present");
    goto exit;
  } else if (sps->vui_parameters.time_scale == 0) {
    GST_DEBUG_OBJECT (h264parse,
        "unable to compute timestamp: time_scale = 0 "
        "(this is forbidden in spec; bitstream probably contains error)");
    goto exit;
  }

  if (h264parse->sei_pic_struct_pres_flag &&
      h264parse->sei_pic_struct != (guint8) - 1) {
    /* Note that when h264parse->sei_pic_struct == -1 (unspecified), there
     * are ways to infer its value. This is related to computing the
     * TopFieldOrderCnt and BottomFieldOrderCnt, which looks
     * complicated and thus not implemented for the time being. Yet
     * the value we have here is correct for many applications
     */
    switch (h264parse->sei_pic_struct) {
      case GST_H264_SEI_PIC_STRUCT_TOP_FIELD:
      case GST_H264_SEI_PIC_STRUCT_BOTTOM_FIELD:
        duration = 1;
        break;
      case GST_H264_SEI_PIC_STRUCT_FRAME:
      case GST_H264_SEI_PIC_STRUCT_TOP_BOTTOM:
      case GST_H264_SEI_PIC_STRUCT_BOTTOM_TOP:
        duration = 2;
        break;
      case GST_H264_SEI_PIC_STRUCT_TOP_BOTTOM_TOP:
      case GST_H264_SEI_PIC_STRUCT_BOTTOM_TOP_BOTTOM:
        duration = 3;
        break;
      case GST_H264_SEI_PIC_STRUCT_FRAME_DOUBLING:
        duration = 4;
        break;
      case GST_H264_SEI_PIC_STRUCT_FRAME_TRIPLING:
        duration = 6;
        break;
      default:
        GST_DEBUG_OBJECT (h264parse,
            "h264parse->sei_pic_struct of unknown value %d. Not parsed",
            h264parse->sei_pic_struct);
        break;
    }
  } else {
    duration = h264parse->field_pic_flag ? 1 : 2;
  }

  GST_LOG_OBJECT (h264parse, "frame tick duration %d", duration);

  /*
   * h264parse.264 C.1.2 Timing of coded picture removal (equivalent to DTS):
   * Tr,n(0) = initial_cpb_removal_delay[ SchedSelIdx ] / 90000
   * Tr,n(n) = Tr,n(nb) + Tc * cpb_removal_delay(n)
   * where
   * Tc = num_units_in_tick / time_scale
   */

  if (h264parse->ts_trn_nb != GST_CLOCK_TIME_NONE) {
    GST_LOG_OBJECT (h264parse, "buffering based ts");
    /* buffering period is present */
    if (upstream != GST_CLOCK_TIME_NONE) {
      /* If upstream timestamp is valid, we respect it and adjust current
       * reference point */
      h264parse->ts_trn_nb = upstream -
          (GstClockTime) gst_util_uint64_scale_int
          (h264parse->sei_cpb_removal_delay * GST_SECOND,
          sps->vui_parameters.num_units_in_tick,
          sps->vui_parameters.time_scale);
    } else {
      /* If no upstream timestamp is given, we write in new timestamp */
      upstream = h264parse->dts = h264parse->ts_trn_nb +
          (GstClockTime) gst_util_uint64_scale_int
          (h264parse->sei_cpb_removal_delay * GST_SECOND,
          sps->vui_parameters.num_units_in_tick,
          sps->vui_parameters.time_scale);
    }
  } else {
    GstClockTime dur;

    GST_LOG_OBJECT (h264parse, "duration based ts");
    /* naive method: no removal delay specified
     * track upstream timestamp and provide best guess frame duration */
    dur = gst_util_uint64_scale_int (duration * GST_SECOND,
        sps->vui_parameters.num_units_in_tick, sps->vui_parameters.time_scale);
    /* sanity check */
    if (dur < GST_MSECOND) {
      GST_DEBUG_OBJECT (h264parse, "discarding dur %" GST_TIME_FORMAT,
          GST_TIME_ARGS (dur));
    } else {
      *out_dur = dur;
    }
  }

exit:
  if (GST_CLOCK_TIME_IS_VALID (upstream))
    *out_ts = h264parse->dts = upstream;

  if (GST_CLOCK_TIME_IS_VALID (*out_dur) &&
      GST_CLOCK_TIME_IS_VALID (h264parse->dts))
    h264parse->dts += *out_dur;
}

static GstFlowReturn
gst_h264_parse_parse_frame (GstBaseParse * parse, GstBaseParseFrame * frame)
{
  GstH264Parse *h264parse;
  GstBuffer *buffer;
  guint av;

  h264parse = GST_H264_PARSE (parse);
  buffer = frame->buffer;

  gst_h264_parse_update_src_caps (h264parse, NULL);

  /* don't mess with timestamps if provided by upstream,
   * particularly since our ts not that good they handle seeking etc */
  if (h264parse->do_ts)
    gst_h264_parse_get_timestamp (h264parse,
        &GST_BUFFER_TIMESTAMP (buffer), &GST_BUFFER_DURATION (buffer),
        h264parse->frame_start);

  if (h264parse->keyframe)
    GST_BUFFER_FLAG_UNSET (buffer, GST_BUFFER_FLAG_DELTA_UNIT);
  else
    GST_BUFFER_FLAG_SET (buffer, GST_BUFFER_FLAG_DELTA_UNIT);

  if (h264parse->discont) {
    GST_BUFFER_FLAG_SET (buffer, GST_BUFFER_FLAG_DISCONT);
    h264parse->discont = FALSE;
  }

  /* replace with transformed AVC output if applicable */
  av = gst_adapter_available (h264parse->frame_out);
  if (av) {
    GstBuffer *buf;

    buf = gst_adapter_take_buffer (h264parse->frame_out, av);
    gst_buffer_copy_into (buf, buffer, GST_BUFFER_COPY_METADATA, 0, -1);
    gst_buffer_replace (&frame->out_buffer, buf);
    gst_buffer_unref (buf);
  }

  return GST_FLOW_OK;
}

/* sends a codec NAL downstream, decorating and transforming as needed.
 * No ownership is taken of @nal */
static GstFlowReturn
gst_h264_parse_push_codec_buffer (GstH264Parse * h264parse,
    GstBuffer * nal, GstClockTime ts)
{
  GstMapInfo map;

  gst_buffer_map (nal, &map, GST_MAP_READ);
  nal = gst_h264_parse_wrap_nal (h264parse, h264parse->format,
      map.data, map.size);
  gst_buffer_unmap (nal, &map);

  GST_BUFFER_TIMESTAMP (nal) = ts;
  GST_BUFFER_DURATION (nal) = 0;

  return gst_pad_push (GST_BASE_PARSE_SRC_PAD (h264parse), nal);
}

static GstEvent *
check_pending_key_unit_event (GstEvent * pending_event,
    GstSegment * segment, GstClockTime timestamp, guint flags,
    GstClockTime pending_key_unit_ts)
{
  GstClockTime running_time, stream_time;
  gboolean all_headers;
  guint count;
  GstEvent *event = NULL;

  g_return_val_if_fail (segment != NULL, NULL);

  if (pending_event == NULL)
    goto out;

  if (GST_CLOCK_TIME_IS_VALID (pending_key_unit_ts) &&
      timestamp == GST_CLOCK_TIME_NONE)
    goto out;

  running_time = gst_segment_to_running_time (segment,
      GST_FORMAT_TIME, timestamp);

  GST_INFO ("now %" GST_TIME_FORMAT " wanted %" GST_TIME_FORMAT,
      GST_TIME_ARGS (running_time), GST_TIME_ARGS (pending_key_unit_ts));
  if (GST_CLOCK_TIME_IS_VALID (pending_key_unit_ts) &&
      running_time < pending_key_unit_ts)
    goto out;

  if (flags & GST_BUFFER_FLAG_DELTA_UNIT) {
    GST_DEBUG ("pending force key unit, waiting for keyframe");
    goto out;
  }

  stream_time = gst_segment_to_stream_time (segment,
      GST_FORMAT_TIME, timestamp);

  gst_video_event_parse_upstream_force_key_unit (pending_event,
      NULL, &all_headers, &count);

  event =
      gst_video_event_new_downstream_force_key_unit (timestamp, stream_time,
      running_time, all_headers, count);
  gst_event_set_seqnum (event, gst_event_get_seqnum (pending_event));

out:
  return event;
}

static void
gst_h264_parse_prepare_key_unit (GstH264Parse * parse, GstEvent * event)
{
  GstClockTime running_time;
  guint count;
#ifndef GST_DISABLE_GST_DEBUG
  gboolean have_sps, have_pps;
  gint i;
#endif

  parse->pending_key_unit_ts = GST_CLOCK_TIME_NONE;
  gst_event_replace (&parse->force_key_unit_event, NULL);

  gst_video_event_parse_downstream_force_key_unit (event,
      NULL, NULL, &running_time, NULL, &count);

  GST_INFO_OBJECT (parse, "pushing downstream force-key-unit event %d "
      "%" GST_TIME_FORMAT " count %d", gst_event_get_seqnum (event),
      GST_TIME_ARGS (running_time), count);
  gst_pad_push_event (GST_BASE_PARSE_SRC_PAD (parse), event);

#ifndef GST_DISABLE_GST_DEBUG
  have_sps = have_pps = FALSE;
  for (i = 0; i < GST_H264_MAX_SPS_COUNT; i++) {
    if (parse->sps_nals[i] != NULL) {
      have_sps = TRUE;
      break;
    }
  }
  for (i = 0; i < GST_H264_MAX_PPS_COUNT; i++) {
    if (parse->pps_nals[i] != NULL) {
      have_pps = TRUE;
      break;
    }
  }

  GST_INFO_OBJECT (parse, "preparing key unit, have sps %d have pps %d",
      have_sps, have_pps);
#endif

  /* set push_codec to TRUE so that pre_push_frame sends SPS/PPS again */
  parse->push_codec = TRUE;
}

static GstFlowReturn
gst_h264_parse_pre_push_frame (GstBaseParse * parse, GstBaseParseFrame * frame)
{
  GstH264Parse *h264parse;
  GstBuffer *buffer;
  GstEvent *event;

  h264parse = GST_H264_PARSE (parse);

  if (!h264parse->sent_codec_tag) {
    GstTagList *taglist;
    GstCaps *caps;

    taglist = gst_tag_list_new_empty ();

    /* codec tag */
    caps = gst_pad_get_current_caps (GST_BASE_PARSE_SRC_PAD (parse));
    gst_pb_utils_add_codec_description_to_tag_list (taglist,
        GST_TAG_VIDEO_CODEC, caps);
    gst_caps_unref (caps);

    gst_pad_push_event (GST_BASE_PARSE_SRC_PAD (h264parse),
        gst_event_new_tag (taglist));

    /* also signals the end of first-frame processing */
    h264parse->sent_codec_tag = TRUE;
  }

  buffer = frame->buffer;

  if ((event = check_pending_key_unit_event (h264parse->force_key_unit_event,
              &parse->segment, GST_BUFFER_TIMESTAMP (buffer),
              GST_BUFFER_FLAGS (buffer), h264parse->pending_key_unit_ts))) {
    gst_h264_parse_prepare_key_unit (h264parse, event);
  }

  /* periodic SPS/PPS sending */
  if (h264parse->interval > 0 || h264parse->push_codec) {
    GstClockTime timestamp = GST_BUFFER_TIMESTAMP (buffer);
    guint64 diff;

    /* init */
    if (!GST_CLOCK_TIME_IS_VALID (h264parse->last_report)) {
      h264parse->last_report = timestamp;
    }

    if (h264parse->idr_pos >= 0) {
      GST_LOG_OBJECT (h264parse, "IDR nal at offset %d", h264parse->idr_pos);

      if (timestamp > h264parse->last_report)
        diff = timestamp - h264parse->last_report;
      else
        diff = 0;

      GST_LOG_OBJECT (h264parse,
          "now %" GST_TIME_FORMAT ", last SPS/PPS %" GST_TIME_FORMAT,
          GST_TIME_ARGS (timestamp), GST_TIME_ARGS (h264parse->last_report));

      GST_DEBUG_OBJECT (h264parse,
          "interval since last SPS/PPS %" GST_TIME_FORMAT,
          GST_TIME_ARGS (diff));

      if (GST_TIME_AS_SECONDS (diff) >= h264parse->interval ||
          h264parse->push_codec) {
        GstBuffer *codec_nal;
        gint i;
        GstClockTime new_ts;

        /* avoid overwriting a perfectly fine timestamp */
        new_ts = GST_CLOCK_TIME_IS_VALID (timestamp) ? timestamp :
            h264parse->last_report;

        if (h264parse->align == GST_H264_PARSE_ALIGN_NAL) {
          /* send separate config NAL buffers */
          GST_DEBUG_OBJECT (h264parse, "- sending SPS/PPS");
          for (i = 0; i < GST_H264_MAX_SPS_COUNT; i++) {
            if ((codec_nal = h264parse->sps_nals[i])) {
              GST_DEBUG_OBJECT (h264parse, "sending SPS nal");
              gst_h264_parse_push_codec_buffer (h264parse, codec_nal,
                  timestamp);
              h264parse->last_report = new_ts;
            }
          }
          for (i = 0; i < GST_H264_MAX_PPS_COUNT; i++) {
            if ((codec_nal = h264parse->pps_nals[i])) {
              GST_DEBUG_OBJECT (h264parse, "sending PPS nal");
              gst_h264_parse_push_codec_buffer (h264parse, codec_nal,
                  timestamp);
              h264parse->last_report = new_ts;
            }
          }
        } else {
          /* insert config NALs into AU */
          GstByteWriter bw;
          GstBuffer *new_buf;
          const gboolean bs = h264parse->format == GST_H264_PARSE_FORMAT_BYTE;
          const gint nls = 4 - h264parse->nal_length_size;
          gboolean ok;

          gst_byte_writer_init_with_size (&bw, gst_buffer_get_size (buffer),
              FALSE);
          ok = gst_byte_writer_put_buffer (&bw, buffer, 0, h264parse->idr_pos);
          GST_DEBUG_OBJECT (h264parse, "- inserting SPS/PPS");
          for (i = 0; i < GST_H264_MAX_SPS_COUNT; i++) {
            if ((codec_nal = h264parse->sps_nals[i])) {
              gsize nal_size = gst_buffer_get_size (codec_nal);
              GST_DEBUG_OBJECT (h264parse, "inserting SPS nal");
              if (bs) {
                ok &= gst_byte_writer_put_uint32_be (&bw, 1);
              } else {
                ok &= gst_byte_writer_put_uint32_be (&bw,
                    (nal_size << (nls * 8)));
                ok &= gst_byte_writer_set_pos (&bw,
                    gst_byte_writer_get_pos (&bw) - nls);
              }

              ok &= gst_byte_writer_put_buffer (&bw, codec_nal, 0, nal_size);
              h264parse->last_report = new_ts;
            }
          }
          for (i = 0; i < GST_H264_MAX_PPS_COUNT; i++) {
            if ((codec_nal = h264parse->pps_nals[i])) {
              gsize nal_size = gst_buffer_get_size (codec_nal);
              GST_DEBUG_OBJECT (h264parse, "inserting PPS nal");
              if (bs) {
                ok &= gst_byte_writer_put_uint32_be (&bw, 1);
              } else {
                ok &= gst_byte_writer_put_uint32_be (&bw,
                    (nal_size << (nls * 8)));
                ok &= gst_byte_writer_set_pos (&bw,
                    gst_byte_writer_get_pos (&bw) - nls);
              }
              ok &= gst_byte_writer_put_buffer (&bw, codec_nal, 0, nal_size);
              h264parse->last_report = new_ts;
            }
          }
          ok &=
              gst_byte_writer_put_buffer (&bw, buffer, h264parse->idr_pos, -1);
          /* collect result and push */
          new_buf = gst_byte_writer_reset_and_get_buffer (&bw);
          gst_buffer_copy_into (new_buf, buffer, GST_BUFFER_COPY_METADATA, 0,
              -1);
          /* should already be keyframe/IDR, but it may not have been,
           * so mark it as such to avoid being discarded by picky decoder */
          GST_BUFFER_FLAG_UNSET (new_buf, GST_BUFFER_FLAG_DELTA_UNIT);
          gst_buffer_replace (&frame->out_buffer, new_buf);
          gst_buffer_unref (new_buf);
          /* some result checking seems to make some compilers happy */
          if (G_UNLIKELY (!ok)) {
            GST_ERROR_OBJECT (h264parse, "failed to insert SPS/PPS");
          }
        }
      }
      /* we pushed whatever we had */
      h264parse->push_codec = FALSE;
      h264parse->have_sps = FALSE;
      h264parse->have_pps = FALSE;
      h264parse->state &= GST_H264_PARSE_STATE_VALID_PICTURE_HEADERS;
    }
  }

  gst_h264_parse_reset_frame (h264parse);

  return GST_FLOW_OK;
}

static gboolean
gst_h264_parse_set_caps (GstBaseParse * parse, GstCaps * caps)
{
  GstH264Parse *h264parse;
  GstStructure *str;
  const GValue *value;
  GstBuffer *codec_data = NULL;
  gsize size;
  guint format, align, off;
  GstH264NalUnit nalu;
  GstH264ParserResult parseres;

  h264parse = GST_H264_PARSE (parse);

  /* reset */
  h264parse->push_codec = FALSE;

  str = gst_caps_get_structure (caps, 0);

  /* accept upstream info if provided */
  gst_structure_get_int (str, "width", &h264parse->width);
  gst_structure_get_int (str, "height", &h264parse->height);
  gst_structure_get_fraction (str, "framerate", &h264parse->fps_num,
      &h264parse->fps_den);
  gst_structure_get_fraction (str, "pixel-aspect-ratio",
      &h264parse->upstream_par_n, &h264parse->upstream_par_d);

  /* get upstream format and align from caps */
  gst_h264_parse_format_from_caps (caps, &format, &align);

  /* packetized video has a codec_data */
  if (format != GST_H264_PARSE_FORMAT_BYTE &&
      (value = gst_structure_get_value (str, "codec_data"))) {
    GstMapInfo map;
    guint8 *data;
    guint num_sps, num_pps;
#ifndef GST_DISABLE_GST_DEBUG
    guint profile;
#endif
    gint i;

    GST_DEBUG_OBJECT (h264parse, "have packetized h264");
    /* make note for optional split processing */
    h264parse->packetized = TRUE;

    codec_data = gst_value_get_buffer (value);
    if (!codec_data)
      goto wrong_type;
    gst_buffer_map (codec_data, &map, GST_MAP_READ);
    data = map.data;
    size = map.size;

    /* parse the avcC data */
    if (size < 7) {             /* when numSPS==0 and numPPS==0, length is 7 bytes */
      gst_buffer_unmap (codec_data, &map);
      goto avcc_too_small;
    }
    /* parse the version, this must be 1 */
    if (data[0] != 1) {
      gst_buffer_unmap (codec_data, &map);
      goto wrong_version;
    }
#ifndef GST_DISABLE_GST_DEBUG
    /* AVCProfileIndication */
    /* profile_compat */
    /* AVCLevelIndication */
    profile = (data[1] << 16) | (data[2] << 8) | data[3];
    GST_DEBUG_OBJECT (h264parse, "profile %06x", profile);
#endif

    /* 6 bits reserved | 2 bits lengthSizeMinusOne */
    /* this is the number of bytes in front of the NAL units to mark their
     * length */
    h264parse->nal_length_size = (data[4] & 0x03) + 1;
    GST_DEBUG_OBJECT (h264parse, "nal length size %u",
        h264parse->nal_length_size);

    num_sps = data[5] & 0x1f;
    off = 6;
    for (i = 0; i < num_sps; i++) {
      parseres = gst_h264_parser_identify_nalu_avc (h264parse->nalparser,
          data, off, size, 2, &nalu);
      if (parseres != GST_H264_PARSER_OK) {
        gst_buffer_unmap (codec_data, &map);
        goto avcc_too_small;
      }

      gst_h264_parse_process_nal (h264parse, &nalu);
      off = nalu.offset + nalu.size;
    }

    num_pps = data[off];
    off++;

    for (i = 0; i < num_pps; i++) {
      parseres = gst_h264_parser_identify_nalu_avc (h264parse->nalparser,
          data, off, size, 2, &nalu);
      if (parseres != GST_H264_PARSER_OK) {
        gst_buffer_unmap (codec_data, &map);
        goto avcc_too_small;
      }

      gst_h264_parse_process_nal (h264parse, &nalu);
      off = nalu.offset + nalu.size;
    }

    gst_buffer_unmap (codec_data, &map);

    gst_buffer_replace (&h264parse->codec_data_in, codec_data);

    /* if upstream sets codec_data without setting stream-format and alignment, we
     * assume stream-format=avc,alignment=au */
    if (format == GST_H264_PARSE_FORMAT_NONE)
      format = GST_H264_PARSE_FORMAT_AVC;
    if (align == GST_H264_PARSE_ALIGN_NONE)
      align = GST_H264_PARSE_ALIGN_AU;
  } else {
    GST_DEBUG_OBJECT (h264parse, "have bytestream h264");
    /* nothing to pre-process */
    h264parse->packetized = FALSE;
    /* we have 4 sync bytes */
    h264parse->nal_length_size = 4;

    if (format == GST_H264_PARSE_FORMAT_NONE) {
      format = GST_H264_PARSE_FORMAT_BYTE;
      align = GST_H264_PARSE_ALIGN_AU;
    }
  }

  {
    GstCaps *in_caps;

    /* prefer input type determined above */
    in_caps = gst_caps_new_simple ("video/x-h264",
        "parsed", G_TYPE_BOOLEAN, TRUE,
        "stream-format", G_TYPE_STRING,
        gst_h264_parse_get_string (h264parse, TRUE, format),
        "alignment", G_TYPE_STRING,
        gst_h264_parse_get_string (h264parse, FALSE, align), NULL);
    /* negotiate with downstream, sets ->format and ->align */
    gst_h264_parse_negotiate (h264parse, format, in_caps);
    gst_caps_unref (in_caps);
  }

  if (format == h264parse->format && align == h264parse->align) {
    /* do not set CAPS and passthrough mode if SPS/PPS have not been parsed */
    if (h264parse->have_sps && h264parse->have_pps) {
      gst_base_parse_set_passthrough (parse, TRUE);

      /* we did parse codec-data and might supplement src caps */
      gst_h264_parse_update_src_caps (h264parse, caps);
    }
  } else if (format == GST_H264_PARSE_FORMAT_AVC
      || format == GST_H264_PARSE_FORMAT_AVC3) {
    /* if input != output, and input is avc, must split before anything else */
    /* arrange to insert codec-data in-stream if needed.
     * src caps are only arranged for later on */
    h264parse->push_codec = TRUE;
    h264parse->have_sps = FALSE;
    h264parse->have_pps = FALSE;
    if (h264parse->align == GST_H264_PARSE_ALIGN_NAL)
      h264parse->split_packetized = TRUE;
    h264parse->packetized = TRUE;
  }

  return TRUE;

  /* ERRORS */
avcc_too_small:
  {
    GST_DEBUG_OBJECT (h264parse, "avcC size %" G_GSIZE_FORMAT " < 8", size);
    goto refuse_caps;
  }
wrong_version:
  {
    GST_DEBUG_OBJECT (h264parse, "wrong avcC version");
    goto refuse_caps;
  }
wrong_type:
  {
    GST_DEBUG_OBJECT (h264parse, "wrong codec-data type");
    goto refuse_caps;
  }
refuse_caps:
  {
    GST_WARNING_OBJECT (h264parse, "refused caps %" GST_PTR_FORMAT, caps);
    return FALSE;
  }
}

static void
remove_fields (GstCaps * caps)
{
  guint i, n;

  n = gst_caps_get_size (caps);
  for (i = 0; i < n; i++) {
    GstStructure *s = gst_caps_get_structure (caps, i);

    gst_structure_remove_field (s, "alignment");
    gst_structure_remove_field (s, "stream-format");
    gst_structure_remove_field (s, "parsed");
  }
}

static GstCaps *
gst_h264_parse_get_caps (GstBaseParse * parse, GstCaps * filter)
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
    peercaps = gst_caps_make_writable (peercaps);
    remove_fields (peercaps);

    res = gst_caps_intersect_full (peercaps, templ, GST_CAPS_INTERSECT_FIRST);
    gst_caps_unref (peercaps);
    gst_caps_unref (templ);
  } else {
    res = templ;
  }

  if (filter) {
    GstCaps *tmp = gst_caps_intersect_full (res, filter,
        GST_CAPS_INTERSECT_FIRST);
    gst_caps_unref (res);
    res = tmp;
  }

  return res;
}

static gboolean
gst_h264_parse_event (GstBaseParse * parse, GstEvent * event)
{
  gboolean res;
  GstH264Parse *h264parse = GST_H264_PARSE (parse);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_CUSTOM_DOWNSTREAM:
    {
      GstClockTime timestamp, stream_time, running_time;
      gboolean all_headers;
      guint count;

      if (gst_video_event_is_force_key_unit (event)) {
        gst_video_event_parse_downstream_force_key_unit (event,
            &timestamp, &stream_time, &running_time, &all_headers, &count);

        GST_INFO_OBJECT (h264parse,
            "received downstream force key unit event, "
            "seqnum %d running_time %" GST_TIME_FORMAT
            " all_headers %d count %d", gst_event_get_seqnum (event),
            GST_TIME_ARGS (running_time), all_headers, count);
        if (h264parse->force_key_unit_event) {
          GST_INFO_OBJECT (h264parse, "ignoring force key unit event "
              "as one is already queued");
        } else {
          h264parse->pending_key_unit_ts = running_time;
          gst_event_replace (&h264parse->force_key_unit_event, event);
        }
        gst_event_unref (event);
        res = TRUE;
      } else {
        res = GST_BASE_PARSE_CLASS (parent_class)->sink_event (parse, event);
        break;
      }
      break;
    }
    case GST_EVENT_FLUSH_STOP:
      h264parse->dts = GST_CLOCK_TIME_NONE;
      h264parse->ts_trn_nb = GST_CLOCK_TIME_NONE;

      res = GST_BASE_PARSE_CLASS (parent_class)->sink_event (parse, event);
      break;
    case GST_EVENT_SEGMENT:
    {
      const GstSegment *segment;

      gst_event_parse_segment (event, &segment);
      /* don't try to mess with more subtle cases (e.g. seek) */
      if (segment->format == GST_FORMAT_TIME &&
          (segment->start != 0 || segment->rate != 1.0
              || segment->applied_rate != 1.0))
        h264parse->do_ts = FALSE;

      res = GST_BASE_PARSE_CLASS (parent_class)->sink_event (parse, event);
      break;
    }
    default:
      res = GST_BASE_PARSE_CLASS (parent_class)->sink_event (parse, event);
      break;
  }
  return res;
}

static gboolean
gst_h264_parse_src_event (GstBaseParse * parse, GstEvent * event)
{
  gboolean res;
  GstH264Parse *h264parse = GST_H264_PARSE (parse);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_CUSTOM_UPSTREAM:
    {
      GstClockTime running_time;
      gboolean all_headers;
      guint count;

      if (gst_video_event_is_force_key_unit (event)) {
        gst_video_event_parse_upstream_force_key_unit (event,
            &running_time, &all_headers, &count);

        GST_INFO_OBJECT (h264parse, "received upstream force-key-unit event, "
            "seqnum %d running_time %" GST_TIME_FORMAT
            " all_headers %d count %d", gst_event_get_seqnum (event),
            GST_TIME_ARGS (running_time), all_headers, count);

        if (all_headers) {
          h264parse->pending_key_unit_ts = running_time;
          gst_event_replace (&h264parse->force_key_unit_event, event);
        }
      }
      res = GST_BASE_PARSE_CLASS (parent_class)->src_event (parse, event);
      break;
    }
    default:
      res = GST_BASE_PARSE_CLASS (parent_class)->src_event (parse, event);
      break;
  }

  return res;
}

static void
gst_h264_parse_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstH264Parse *parse;

  parse = GST_H264_PARSE (object);

  switch (prop_id) {
    case PROP_CONFIG_INTERVAL:
      parse->interval = g_value_get_uint (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_h264_parse_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstH264Parse *parse;

  parse = GST_H264_PARSE (object);

  switch (prop_id) {
    case PROP_CONFIG_INTERVAL:
      g_value_set_uint (value, parse->interval);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}
