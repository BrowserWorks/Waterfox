/* GStreamer SBC audio parser
 * Copyright (C) 2012 Collabora Ltd. <tim.muller@collabora.co.uk>
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

/**
 * SECTION:element-sbcparse
 * @see_also: sbcdec, sbcenc
 *
 * The sbcparse element will parse a bluetooth SBC audio stream into
 * frames and timestamp them properly.
 *
 * Since: 1.2.0
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gstsbcparse.h"

#include <string.h>
#include <gst/tag/tag.h>
#include <gst/audio/audio.h>
#include <gst/base/base.h>
#include <gst/pbutils/pbutils.h>

#define SBC_SYNCBYTE 0x9C

GST_DEBUG_CATEGORY_STATIC (sbcparse_debug);
#define GST_CAT_DEFAULT sbcparse_debug

static GstStaticPadTemplate src_factory = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("audio/x-sbc, parsed = (boolean) true, "
        "channels = (int) [ 1, 2 ], "
        "rate = (int) { 16000, 32000, 44100, 48000 }")
    );

static GstStaticPadTemplate sink_factory = GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("audio/x-sbc")
    );

static gboolean gst_sbc_parse_start (GstBaseParse * parse);
static gboolean gst_sbc_parse_stop (GstBaseParse * parse);
static GstFlowReturn gst_sbc_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize);
static GstFlowReturn gst_sbc_parse_pre_push_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame);
static GstCaps *gst_sbc_parse_get_sink_caps (GstBaseParse * parse,
    GstCaps * filter);

static guint8 gst_sbc_calculate_crc8 (const guint8 * data, gint bits_crc);
static gsize gst_sbc_calc_framelen (guint subbands, GstSbcChannelMode ch_mode,
    guint blocks, guint bitpool);
static gsize gst_sbc_parse_header (const guint8 * data, guint * rate,
    guint * n_blocks, GstSbcChannelMode * ch_mode,
    GstSbcAllocationMethod * alloc_method, guint * n_subbands, guint * bitpool);

#define parent_class gst_sbc_parse_parent_class
G_DEFINE_TYPE (GstSbcParse, gst_sbc_parse, GST_TYPE_BASE_PARSE);

static void
gst_sbc_parse_class_init (GstSbcParseClass * klass)
{
  GstBaseParseClass *baseparse_class = GST_BASE_PARSE_CLASS (klass);
  GstElementClass *element_class = GST_ELEMENT_CLASS (klass);

  GST_DEBUG_CATEGORY_INIT (sbcparse_debug, "sbcparse", 0, "SBC audio parser");

  baseparse_class->start = GST_DEBUG_FUNCPTR (gst_sbc_parse_start);
  baseparse_class->stop = GST_DEBUG_FUNCPTR (gst_sbc_parse_stop);
  baseparse_class->pre_push_frame =
      GST_DEBUG_FUNCPTR (gst_sbc_parse_pre_push_frame);
  baseparse_class->handle_frame =
      GST_DEBUG_FUNCPTR (gst_sbc_parse_handle_frame);
  baseparse_class->get_sink_caps =
      GST_DEBUG_FUNCPTR (gst_sbc_parse_get_sink_caps);

  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&src_factory));
  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&sink_factory));

  gst_element_class_set_static_metadata (element_class, "SBC audio parser",
      "Codec/Parser/Audio", "Parses an SBC bluetooth audio stream",
      "Tim-Philipp Müller <tim.muller@collabora.co.uk>");
}

static void
gst_sbc_parse_reset (GstSbcParse * sbcparse)
{
  sbcparse->alloc_method = GST_SBC_ALLOCATION_METHOD_INVALID;
  sbcparse->ch_mode = GST_SBC_CHANNEL_MODE_INVALID;
  sbcparse->rate = -1;
  sbcparse->n_blocks = -1;
  sbcparse->n_subbands = -1;
  sbcparse->bitpool = -1;
  sbcparse->sent_codec_tag = FALSE;
}

static void
gst_sbc_parse_init (GstSbcParse * sbcparse)
{
  gst_sbc_parse_reset (sbcparse);
  GST_PAD_SET_ACCEPT_INTERSECT (GST_BASE_PARSE_SINK_PAD (sbcparse));
}

static gboolean
gst_sbc_parse_start (GstBaseParse * parse)
{
  gst_base_parse_set_min_frame_size (parse,
      gst_sbc_calc_framelen (4, GST_SBC_CHANNEL_MODE_MONO, 4, 2));

  gst_base_parse_set_has_timing_info (parse, FALSE);

  gst_base_parse_set_syncable (parse, TRUE);

  return TRUE;
}

static gboolean
gst_sbc_parse_stop (GstBaseParse * parse)
{
  gst_sbc_parse_reset (GST_SBC_PARSE (parse));
  return TRUE;
}

static const gchar *
gst_sbc_channel_mode_get_name (GstSbcChannelMode ch_mode)
{
  switch (ch_mode) {
    case GST_SBC_CHANNEL_MODE_MONO:
      return "mono";
    case GST_SBC_CHANNEL_MODE_DUAL:
      return "dual";
    case GST_SBC_CHANNEL_MODE_STEREO:
      return "stereo";
    case GST_SBC_CHANNEL_MODE_JOINT_STEREO:
      return "joint";
    default:
      break;
  }
  return "invalid";
}

static const gchar *
gst_sbc_allocation_method_get_name (GstSbcAllocationMethod alloc_method)
{
  switch (alloc_method) {
    case GST_SBC_ALLOCATION_METHOD_SNR:
      return "snr";
    case GST_SBC_ALLOCATION_METHOD_LOUDNESS:
      return "loudness";
    default:
      break;
  }
  return "invalid";
}

static GstFlowReturn
gst_sbc_parse_handle_frame (GstBaseParse * parse, GstBaseParseFrame * frame,
    gint * skipsize)
{
  GstSbcParse *sbcparse = GST_SBC_PARSE (parse);
  GstSbcAllocationMethod alloc_method = GST_SBC_ALLOCATION_METHOD_INVALID;
  GstSbcChannelMode ch_mode = GST_SBC_CHANNEL_MODE_INVALID;
  GstMapInfo map;
  guint rate = 0, n_blocks = 0, n_subbands = 0, bitpool = 0;
  gsize frame_len, next_len;
  gint i, max_frames;

  gst_buffer_map (frame->buffer, &map, GST_MAP_READ);

  g_assert (map.size >= 6);

  frame_len = gst_sbc_parse_header (map.data, &rate, &n_blocks, &ch_mode,
      &alloc_method, &n_subbands, &bitpool);

  GST_LOG_OBJECT (parse, "frame_len: %u", (guint) frame_len);

  if (frame_len == 0)
    goto resync;

  if (sbcparse->alloc_method != alloc_method
      || sbcparse->ch_mode != ch_mode
      || sbcparse->rate != rate
      || sbcparse->n_blocks != n_blocks
      || sbcparse->n_subbands != n_subbands || sbcparse->bitpool != bitpool) {
    guint avg_bitrate;
    GstCaps *caps;

    /* FIXME: do all of these need to be in the caps? */
    caps = gst_caps_new_simple ("audio/x-sbc", "rate", G_TYPE_INT, rate,
        "channels", G_TYPE_INT, (ch_mode == GST_SBC_CHANNEL_MODE_MONO) ? 1 : 2,
        "channel-mode", G_TYPE_STRING, gst_sbc_channel_mode_get_name (ch_mode),
        "blocks", G_TYPE_INT, n_blocks, "subbands", G_TYPE_INT, n_subbands,
        "allocation-method", G_TYPE_STRING,
        gst_sbc_allocation_method_get_name (alloc_method),
        "bitpool", G_TYPE_INT, bitpool, "parsed", G_TYPE_BOOLEAN, TRUE, NULL);

    GST_INFO_OBJECT (sbcparse, "caps changed to %" GST_PTR_FORMAT, caps);

    gst_pad_push_event (GST_BASE_PARSE_SRC_PAD (sbcparse),
        gst_event_new_caps (caps));

    avg_bitrate = (8 * frame_len * rate) / (n_subbands * n_blocks);
    gst_base_parse_set_average_bitrate (parse, avg_bitrate);

    gst_base_parse_set_frame_rate (parse, rate, n_subbands * n_blocks, 0, 0);

    sbcparse->alloc_method = alloc_method;
    sbcparse->ch_mode = ch_mode;
    sbcparse->rate = rate;
    sbcparse->n_blocks = n_blocks;
    sbcparse->n_subbands = n_subbands;
    sbcparse->bitpool = bitpool;

    gst_caps_unref (caps);
  }

  if (frame_len > map.size)
    goto need_more_data;

  GST_BUFFER_OFFSET (frame->buffer) = GST_BUFFER_OFFSET_NONE;
  GST_BUFFER_OFFSET_END (frame->buffer) = GST_BUFFER_OFFSET_NONE;

  /* completely arbitrary limit, we only process data we already have,
   * so we aren't introducing latency here */
  max_frames = MIN (map.size / frame_len, n_blocks * n_subbands * 5);
  GST_LOG_OBJECT (sbcparse, "parsing up to %d frames", max_frames);

  for (i = 1; i < max_frames; ++i) {
    next_len = gst_sbc_parse_header (map.data + (i * frame_len), &rate,
        &n_blocks, &ch_mode, &alloc_method, &n_subbands, &bitpool);

    if (next_len != frame_len || sbcparse->alloc_method != alloc_method ||
        sbcparse->ch_mode != ch_mode || sbcparse->rate != rate ||
        sbcparse->n_blocks != n_blocks || sbcparse->n_subbands != n_subbands ||
        sbcparse->bitpool != bitpool) {
      break;
    }
  }
  GST_LOG_OBJECT (sbcparse, "packing %d SBC frames into next output buffer", i);

  /* Note: local n_subbands and n_blocks variables might be tainted if we
   * bailed out of the loop above because of a header configuration mismatch */
  gst_base_parse_set_frame_rate (parse, rate,
      sbcparse->n_subbands * sbcparse->n_blocks * i, 0, 0);

  gst_buffer_unmap (frame->buffer, &map);
  return gst_base_parse_finish_frame (parse, frame, i * frame_len);

resync:
  {
    const guint8 *possible_sync;

    GST_DEBUG_OBJECT (parse, "no sync, resyncing");

    possible_sync = memchr (map.data, SBC_SYNCBYTE, map.size);

    if (possible_sync != NULL)
      *skipsize = (gint) (possible_sync - map.data);
    else
      *skipsize = map.size;

    gst_buffer_unmap (frame->buffer, &map);

    /* we could optimise things here by looping over the data and checking
     * whether the sync is good or not instead of handing control back to
     * the base class just to be called again */
    return GST_FLOW_OK;
  }
need_more_data:
  {
    GST_LOG_OBJECT (parse,
        "need %" G_GSIZE_FORMAT " bytes, but only have %" G_GSIZE_FORMAT,
        frame_len, map.size);
    gst_base_parse_set_min_frame_size (parse, frame_len);
    gst_buffer_unmap (frame->buffer, &map);
    return GST_FLOW_OK;
  }
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
gst_sbc_parse_get_sink_caps (GstBaseParse * parse, GstCaps * filter)
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

static const guint8 crc_table[256] = {
  0x00, 0x1D, 0x3A, 0x27, 0x74, 0x69, 0x4E, 0x53,
  0xE8, 0xF5, 0xD2, 0xCF, 0x9C, 0x81, 0xA6, 0xBB,
  0xCD, 0xD0, 0xF7, 0xEA, 0xB9, 0xA4, 0x83, 0x9E,
  0x25, 0x38, 0x1F, 0x02, 0x51, 0x4C, 0x6B, 0x76,
  0x87, 0x9A, 0xBD, 0xA0, 0xF3, 0xEE, 0xC9, 0xD4,
  0x6F, 0x72, 0x55, 0x48, 0x1B, 0x06, 0x21, 0x3C,
  0x4A, 0x57, 0x70, 0x6D, 0x3E, 0x23, 0x04, 0x19,
  0xA2, 0xBF, 0x98, 0x85, 0xD6, 0xCB, 0xEC, 0xF1,
  0x13, 0x0E, 0x29, 0x34, 0x67, 0x7A, 0x5D, 0x40,
  0xFB, 0xE6, 0xC1, 0xDC, 0x8F, 0x92, 0xB5, 0xA8,
  0xDE, 0xC3, 0xE4, 0xF9, 0xAA, 0xB7, 0x90, 0x8D,
  0x36, 0x2B, 0x0C, 0x11, 0x42, 0x5F, 0x78, 0x65,
  0x94, 0x89, 0xAE, 0xB3, 0xE0, 0xFD, 0xDA, 0xC7,
  0x7C, 0x61, 0x46, 0x5B, 0x08, 0x15, 0x32, 0x2F,
  0x59, 0x44, 0x63, 0x7E, 0x2D, 0x30, 0x17, 0x0A,
  0xB1, 0xAC, 0x8B, 0x96, 0xC5, 0xD8, 0xFF, 0xE2,
  0x26, 0x3B, 0x1C, 0x01, 0x52, 0x4F, 0x68, 0x75,
  0xCE, 0xD3, 0xF4, 0xE9, 0xBA, 0xA7, 0x80, 0x9D,
  0xEB, 0xF6, 0xD1, 0xCC, 0x9F, 0x82, 0xA5, 0xB8,
  0x03, 0x1E, 0x39, 0x24, 0x77, 0x6A, 0x4D, 0x50,
  0xA1, 0xBC, 0x9B, 0x86, 0xD5, 0xC8, 0xEF, 0xF2,
  0x49, 0x54, 0x73, 0x6E, 0x3D, 0x20, 0x07, 0x1A,
  0x6C, 0x71, 0x56, 0x4B, 0x18, 0x05, 0x22, 0x3F,
  0x84, 0x99, 0xBE, 0xA3, 0xF0, 0xED, 0xCA, 0xD7,
  0x35, 0x28, 0x0F, 0x12, 0x41, 0x5C, 0x7B, 0x66,
  0xDD, 0xC0, 0xE7, 0xFA, 0xA9, 0xB4, 0x93, 0x8E,
  0xF8, 0xE5, 0xC2, 0xDF, 0x8C, 0x91, 0xB6, 0xAB,
  0x10, 0x0D, 0x2A, 0x37, 0x64, 0x79, 0x5E, 0x43,
  0xB2, 0xAF, 0x88, 0x95, 0xC6, 0xDB, 0xFC, 0xE1,
  0x5A, 0x47, 0x60, 0x7D, 0x2E, 0x33, 0x14, 0x09,
  0x7F, 0x62, 0x45, 0x58, 0x0B, 0x16, 0x31, 0x2C,
  0x97, 0x8A, 0xAD, 0xB0, 0xE3, 0xFE, 0xD9, 0xC4
};

static guint8
gst_sbc_calculate_crc8 (const guint8 * data, gint crc_bits)
{
  guint8 crc = 0x0f;
  guint8 octet;

  while (crc_bits >= 8) {
    crc = crc_table[crc ^ *data];
    crc_bits -= 8;
    ++data;
  }

  octet = *data;
  while (crc_bits > 0) {
    gchar bit = ((octet ^ crc) & 0x80) >> 7;

    crc = ((crc & 0x7f) << 1) ^ (bit ? 0x1d : 0);

    octet = octet << 1;
    --crc_bits;
  }

  return crc;
}

static gsize
gst_sbc_calc_framelen (guint subbands, GstSbcChannelMode ch_mode,
    guint blocks, guint bitpool)
{
  switch (ch_mode) {
    case GST_SBC_CHANNEL_MODE_MONO:
      return 4 + (subbands * 1) / 2 + (blocks * 1 * bitpool) / 8;
    case GST_SBC_CHANNEL_MODE_DUAL:
      return 4 + (subbands * 2) / 2 + (blocks * 2 * bitpool) / 8;
    case GST_SBC_CHANNEL_MODE_STEREO:
      return 4 + (subbands * 2) / 2 + (blocks * bitpool) / 8;
    case GST_SBC_CHANNEL_MODE_JOINT_STEREO:
      return 4 + (subbands * 2) / 2 + (subbands + blocks * bitpool) / 8;
    default:
      break;
  }

  g_return_val_if_reached (0);
}

static gsize
gst_sbc_parse_header (const guint8 * data, guint * rate, guint * n_blocks,
    GstSbcChannelMode * ch_mode, GstSbcAllocationMethod * alloc_method,
    guint * n_subbands, guint * bitpool)
{
  static const guint16 sbc_rates[4] = { 16000, 32000, 44100, 48000 };
  static const guint8 sbc_blocks[4] = { 4, 8, 12, 16 };
  guint8 crc_data[2 + 1 + 8], crc_bits, i;

  GST_MEMDUMP ("header", data, 8);

  if (data[0] != SBC_SYNCBYTE)
    return 0;

  *rate = sbc_rates[(data[1] >> 6) & 0x03];
  *n_blocks = sbc_blocks[(data[1] >> 4) & 0x03];
  *ch_mode = (GstSbcChannelMode) ((data[1] >> 2) & 0x03);
  *alloc_method = (data[1] >> 1) & 0x01;
  *n_subbands = (data[1] & 0x01) ? 8 : 4;
  *bitpool = data[2];

  GST_TRACE ("rate=%u, n_blocks=%u, ch_mode=%u, alloc_method=%u, "
      "n_subbands=%u, bitpool=%u", *rate, *n_blocks, *ch_mode, *alloc_method,
      *n_subbands, *bitpool);

  if (*bitpool < 2)
    return 0;

  /* check CRC */
  crc_data[0] = data[1];
  crc_data[1] = data[2];
  crc_bits = 16;

  /* joint flags and RFA */
  if (*ch_mode == GST_SBC_CHANNEL_MODE_JOINT_STEREO)
    crc_bits += *n_subbands;

  /* scale factors */
  if (*ch_mode == GST_SBC_CHANNEL_MODE_MONO)
    crc_bits += *n_subbands * 1 * 4;
  else
    crc_bits += *n_subbands * 2 * 4;

  for (i = 16; i < crc_bits; i += 8) {
    crc_data[i / 8] = data[1 + (i / 8) + 1];
  }

  if (i > crc_bits) {
    crc_data[(i / 8) - 1] &= 0xF0;
  }

  GST_MEMDUMP ("crc bytes", crc_data, GST_ROUND_UP_8 (crc_bits) / 8);
  if (gst_sbc_calculate_crc8 (crc_data, crc_bits) != data[3]) {
    GST_LOG ("header CRC check failed, bits=%u, got 0x%02x, expected 0x%02x",
        crc_bits, gst_sbc_calculate_crc8 (crc_data, crc_bits), data[3]);
    return 0;
  }

  return gst_sbc_calc_framelen (*n_subbands, *ch_mode, *n_blocks, *bitpool);
}

static GstFlowReturn
gst_sbc_parse_pre_push_frame (GstBaseParse * parse, GstBaseParseFrame * frame)
{
  GstSbcParse *sbcparse = GST_SBC_PARSE (parse);

  if (!sbcparse->sent_codec_tag) {
    GstTagList *taglist;
    GstCaps *caps;

    taglist = gst_tag_list_new_empty ();

    /* codec tag */
    caps = gst_pad_get_current_caps (GST_BASE_PARSE_SRC_PAD (parse));
    gst_pb_utils_add_codec_description_to_tag_list (taglist,
        GST_TAG_AUDIO_CODEC, caps);
    gst_caps_unref (caps);

    gst_pad_push_event (GST_BASE_PARSE_SRC_PAD (sbcparse),
        gst_event_new_tag (taglist));

    /* also signals the end of first-frame processing */
    sbcparse->sent_codec_tag = TRUE;
  }

  return GST_FLOW_OK;
}
