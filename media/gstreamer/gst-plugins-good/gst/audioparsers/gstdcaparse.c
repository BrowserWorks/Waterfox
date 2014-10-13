/* GStreamer DCA parser
 * Copyright (C) 2010 Tim-Philipp Müller <tim centricular net>
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

/**
 * SECTION:element-dcaparse
 * @short_description: DCA (DTS Coherent Acoustics) parser
 * @see_also: #GstAmrParse, #GstAACParse, #GstAc3Parse
 *
 * This is a DCA (DTS Coherent Acoustics) parser.
 *
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * gst-launch-1.0 filesrc location=abc.dts ! dcaparse ! dtsdec ! audioresample ! audioconvert ! autoaudiosink
 * ]|
 * </refsect2>
 */

/* TODO:
 *  - should accept framed and unframed input (needs decodebin fixes first)
 *  - seeking in raw .dts files doesn't seem to work, but duration estimate ok
 *
 *  - if frames have 'odd' durations, the frame durations (plus timestamps)
 *    aren't adjusted up occasionally to make up for rounding error gaps.
 *    (e.g. if 512 samples per frame @ 48kHz = 10.666666667 ms/frame)
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <string.h>

#include "gstdcaparse.h"
#include <gst/base/base.h>
#include <gst/pbutils/pbutils.h>

GST_DEBUG_CATEGORY_STATIC (dca_parse_debug);
#define GST_CAT_DEFAULT dca_parse_debug

static GstStaticPadTemplate src_template = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("audio/x-dts,"
        " framed = (boolean) true,"
        " channels = (int) [ 1, 8 ],"
        " rate = (int) [ 8000, 192000 ],"
        " depth = (int) { 14, 16 },"
        " endianness = (int) { LITTLE_ENDIAN, BIG_ENDIAN }, "
        " block-size = (int) [ 1, MAX], " " frame-size = (int) [ 1, MAX]"));

static GstStaticPadTemplate sink_template = GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("audio/x-dts; " "audio/x-private1-dts"));

static void gst_dca_parse_finalize (GObject * object);

static gboolean gst_dca_parse_start (GstBaseParse * parse);
static gboolean gst_dca_parse_stop (GstBaseParse * parse);
static GstFlowReturn gst_dca_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize);
static GstFlowReturn gst_dca_parse_pre_push_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame);
static GstCaps *gst_dca_parse_get_sink_caps (GstBaseParse * parse,
    GstCaps * filter);
static gboolean gst_dca_parse_set_sink_caps (GstBaseParse * parse,
    GstCaps * caps);

#define gst_dca_parse_parent_class parent_class
G_DEFINE_TYPE (GstDcaParse, gst_dca_parse, GST_TYPE_BASE_PARSE);

static void
gst_dca_parse_class_init (GstDcaParseClass * klass)
{
  GstBaseParseClass *parse_class = GST_BASE_PARSE_CLASS (klass);
  GstElementClass *element_class = GST_ELEMENT_CLASS (klass);
  GObjectClass *object_class = G_OBJECT_CLASS (klass);

  GST_DEBUG_CATEGORY_INIT (dca_parse_debug, "dcaparse", 0,
      "DCA audio stream parser");

  object_class->finalize = gst_dca_parse_finalize;

  parse_class->start = GST_DEBUG_FUNCPTR (gst_dca_parse_start);
  parse_class->stop = GST_DEBUG_FUNCPTR (gst_dca_parse_stop);
  parse_class->handle_frame = GST_DEBUG_FUNCPTR (gst_dca_parse_handle_frame);
  parse_class->pre_push_frame =
      GST_DEBUG_FUNCPTR (gst_dca_parse_pre_push_frame);
  parse_class->get_sink_caps = GST_DEBUG_FUNCPTR (gst_dca_parse_get_sink_caps);
  parse_class->set_sink_caps = GST_DEBUG_FUNCPTR (gst_dca_parse_set_sink_caps);

  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&sink_template));
  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&src_template));

  gst_element_class_set_static_metadata (element_class,
      "DTS Coherent Acoustics audio stream parser", "Codec/Parser/Audio",
      "DCA parser", "Tim-Philipp Müller <tim centricular net>");
}

static void
gst_dca_parse_reset (GstDcaParse * dcaparse)
{
  dcaparse->channels = -1;
  dcaparse->rate = -1;
  dcaparse->depth = -1;
  dcaparse->endianness = -1;
  dcaparse->block_size = -1;
  dcaparse->frame_size = -1;
  dcaparse->last_sync = 0;
  dcaparse->sent_codec_tag = FALSE;
}

static void
gst_dca_parse_init (GstDcaParse * dcaparse)
{
  gst_base_parse_set_min_frame_size (GST_BASE_PARSE (dcaparse),
      DCA_MIN_FRAMESIZE);
  gst_dca_parse_reset (dcaparse);
  dcaparse->baseparse_chainfunc =
      GST_BASE_PARSE_SINK_PAD (GST_BASE_PARSE (dcaparse))->chainfunc;

  GST_PAD_SET_ACCEPT_INTERSECT (GST_BASE_PARSE_SINK_PAD (dcaparse));
}

static void
gst_dca_parse_finalize (GObject * object)
{
  G_OBJECT_CLASS (parent_class)->finalize (object);
}

static gboolean
gst_dca_parse_start (GstBaseParse * parse)
{
  GstDcaParse *dcaparse = GST_DCA_PARSE (parse);

  GST_DEBUG_OBJECT (parse, "starting");

  gst_dca_parse_reset (dcaparse);

  return TRUE;
}

static gboolean
gst_dca_parse_stop (GstBaseParse * parse)
{
  GST_DEBUG_OBJECT (parse, "stopping");

  return TRUE;
}

static gboolean
gst_dca_parse_parse_header (GstDcaParse * dcaparse,
    const GstByteReader * reader, guint * frame_size,
    guint * sample_rate, guint * channels, guint * depth,
    gint * endianness, guint * num_blocks, guint * samples_per_block,
    gboolean * terminator)
{
  static const int sample_rates[16] = { 0, 8000, 16000, 32000, 0, 0, 11025,
    22050, 44100, 0, 0, 12000, 24000, 48000, 96000, 192000
  };
  static const guint8 channels_table[16] = { 1, 2, 2, 2, 2, 3, 3, 4, 4, 5,
    6, 6, 6, 7, 8, 8
  };
  GstByteReader r = *reader;
  guint16 hdr[8];
  guint32 marker;
  guint chans, lfe, i;

  if (gst_byte_reader_get_remaining (&r) < (4 + sizeof (hdr)))
    return FALSE;

  marker = gst_byte_reader_peek_uint32_be_unchecked (&r);

  /* raw big endian or 14-bit big endian */
  if (marker == 0x7FFE8001 || marker == 0x1FFFE800) {
    for (i = 0; i < G_N_ELEMENTS (hdr); ++i)
      hdr[i] = gst_byte_reader_get_uint16_be_unchecked (&r);
  } else
    /* raw little endian or 14-bit little endian */
  if (marker == 0xFE7F0180 || marker == 0xFF1F00E8) {
    for (i = 0; i < G_N_ELEMENTS (hdr); ++i)
      hdr[i] = gst_byte_reader_get_uint16_le_unchecked (&r);
  } else {
    return FALSE;
  }

  GST_LOG_OBJECT (dcaparse, "dts sync marker 0x%08x at offset %u", marker,
      gst_byte_reader_get_pos (reader));

  /* 14-bit mode */
  if (marker == 0x1FFFE800 || marker == 0xFF1F00E8) {
    if ((hdr[2] & 0xFFF0) != 0x07F0)
      return FALSE;
    /* discard top 2 bits (2 void), shift in 2 */
    hdr[0] = (hdr[0] << 2) | ((hdr[1] >> 12) & 0x0003);
    /* discard top 4 bits (2 void, 2 shifted into hdr[0]), shift in 4 etc. */
    hdr[1] = (hdr[1] << 4) | ((hdr[2] >> 10) & 0x000F);
    hdr[2] = (hdr[2] << 6) | ((hdr[3] >> 8) & 0x003F);
    hdr[3] = (hdr[3] << 8) | ((hdr[4] >> 6) & 0x00FF);
    hdr[4] = (hdr[4] << 10) | ((hdr[5] >> 4) & 0x03FF);
    hdr[5] = (hdr[5] << 12) | ((hdr[6] >> 2) & 0x0FFF);
    hdr[6] = (hdr[6] << 14) | ((hdr[7] >> 0) & 0x3FFF);
    g_assert (hdr[0] == 0x7FFE && hdr[1] == 0x8001);
  }

  GST_LOG_OBJECT (dcaparse, "frame header: %04x%04x%04x%04x",
      hdr[2], hdr[3], hdr[4], hdr[5]);

  *terminator = (hdr[2] & 0x80) ? FALSE : TRUE;
  *samples_per_block = ((hdr[2] >> 10) & 0x1f) + 1;
  *num_blocks = ((hdr[2] >> 2) & 0x7F) + 1;
  *frame_size = (((hdr[2] & 0x03) << 12) | (hdr[3] >> 4)) + 1;
  chans = ((hdr[3] & 0x0F) << 2) | (hdr[4] >> 14);
  *sample_rate = sample_rates[(hdr[4] >> 10) & 0x0F];
  lfe = (hdr[5] >> 9) & 0x03;

  GST_TRACE_OBJECT (dcaparse, "frame size %u, num_blocks %u, rate %u, "
      "samples per block %u", *frame_size, *num_blocks, *sample_rate,
      *samples_per_block);

  if (*num_blocks < 6 || *frame_size < 96 || *sample_rate == 0)
    return FALSE;

  if (marker == 0x1FFFE800 || marker == 0xFF1F00E8)
    *frame_size = (*frame_size * 16) / 14;      /* FIXME: round up? */

  if (chans < G_N_ELEMENTS (channels_table))
    *channels = channels_table[chans] + ((lfe) ? 1 : 0);
  else
    *channels = 0;

  if (depth)
    *depth = (marker == 0x1FFFE800 || marker == 0xFF1F00E8) ? 14 : 16;
  if (endianness)
    *endianness = (marker == 0xFE7F0180 || marker == 0xFF1F00E8) ?
        G_LITTLE_ENDIAN : G_BIG_ENDIAN;

  GST_TRACE_OBJECT (dcaparse, "frame size %u, channels %u, rate %u, "
      "num_blocks %u, samples_per_block %u", *frame_size, *channels,
      *sample_rate, *num_blocks, *samples_per_block);

  return TRUE;
}

static gint
gst_dca_parse_find_sync (GstDcaParse * dcaparse, GstByteReader * reader,
    gsize bufsize, guint32 * sync)
{
  guint32 best_sync = 0;
  guint best_offset = G_MAXUINT;
  gint off;

  /* FIXME: verify syncs via _parse_header() here already */

  /* Raw little endian */
  off = gst_byte_reader_masked_scan_uint32 (reader, 0xffffffff, 0xfe7f0180,
      0, bufsize);
  if (off >= 0 && off < best_offset) {
    best_offset = off;
    best_sync = 0xfe7f0180;
  }

  /* Raw big endian */
  off = gst_byte_reader_masked_scan_uint32 (reader, 0xffffffff, 0x7ffe8001,
      0, bufsize);
  if (off >= 0 && off < best_offset) {
    best_offset = off;
    best_sync = 0x7ffe8001;
  }

  /* FIXME: check next 2 bytes as well for 14-bit formats (but then don't
   * forget to adjust the *skipsize= in _check_valid_frame() */

  /* 14-bit little endian  */
  off = gst_byte_reader_masked_scan_uint32 (reader, 0xffffffff, 0xff1f00e8,
      0, bufsize);
  if (off >= 0 && off < best_offset) {
    best_offset = off;
    best_sync = 0xff1f00e8;
  }

  /* 14-bit big endian  */
  off = gst_byte_reader_masked_scan_uint32 (reader, 0xffffffff, 0x1fffe800,
      0, bufsize);
  if (off >= 0 && off < best_offset) {
    best_offset = off;
    best_sync = 0x1fffe800;
  }

  if (best_offset == G_MAXUINT)
    return -1;

  *sync = best_sync;
  return best_offset;
}

static GstFlowReturn
gst_dca_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize)
{
  GstDcaParse *dcaparse = GST_DCA_PARSE (parse);
  GstBuffer *buf = frame->buffer;
  GstByteReader r;
  gboolean parser_draining;
  gboolean parser_in_sync;
  gboolean terminator;
  guint32 sync = 0;
  guint size, rate, chans, num_blocks, samples_per_block, depth;
  gint block_size;
  gint endianness;
  gint off = -1;
  GstMapInfo map;
  GstFlowReturn ret = GST_FLOW_EOS;

  gst_buffer_map (buf, &map, GST_MAP_READ);

  if (G_UNLIKELY (map.size < 16)) {
    *skipsize = 1;
    goto cleanup;
  }

  parser_in_sync = !GST_BASE_PARSE_LOST_SYNC (parse);

  gst_byte_reader_init (&r, map.data, map.size);

  if (G_LIKELY (parser_in_sync && dcaparse->last_sync != 0)) {
    off = gst_byte_reader_masked_scan_uint32 (&r, 0xffffffff,
        dcaparse->last_sync, 0, map.size);
  }

  if (G_UNLIKELY (off < 0)) {
    off = gst_dca_parse_find_sync (dcaparse, &r, map.size, &sync);
  }

  /* didn't find anything that looks like a sync word, skip */
  if (off < 0) {
    *skipsize = map.size - 3;
    GST_DEBUG_OBJECT (dcaparse, "no sync, skipping %d bytes", *skipsize);
    goto cleanup;
  }

  GST_LOG_OBJECT (parse, "possible sync %08x at buffer offset %d", sync, off);

  /* possible frame header, but not at offset 0? skip bytes before sync */
  if (off > 0) {
    *skipsize = off;
    goto cleanup;
  }

  /* make sure the values in the frame header look sane */
  if (!gst_dca_parse_parse_header (dcaparse, &r, &size, &rate, &chans, &depth,
          &endianness, &num_blocks, &samples_per_block, &terminator)) {
    *skipsize = 4;
    goto cleanup;
  }

  GST_LOG_OBJECT (parse, "got frame, sync %08x, size %u, rate %d, channels %d",
      sync, size, rate, chans);

  dcaparse->last_sync = sync;

  parser_draining = GST_BASE_PARSE_DRAINING (parse);

  if (!parser_in_sync && !parser_draining) {
    /* check for second frame to be sure */
    GST_DEBUG_OBJECT (dcaparse, "resyncing; checking next frame syncword");
    if (map.size >= (size + 16)) {
      guint s2, r2, c2, n2, s3;
      gboolean t;

      GST_MEMDUMP ("buf", map.data, size + 16);
      gst_byte_reader_init (&r, map.data, map.size);
      gst_byte_reader_skip_unchecked (&r, size);

      if (!gst_dca_parse_parse_header (dcaparse, &r, &s2, &r2, &c2, NULL, NULL,
              &n2, &s3, &t)) {
        GST_DEBUG_OBJECT (dcaparse, "didn't find second syncword");
        *skipsize = 4;
        goto cleanup;
      }

      /* ok, got sync now, let's assume constant frame size */
      gst_base_parse_set_min_frame_size (parse, size);
    } else {
      /* wait for some more data */
      GST_LOG_OBJECT (dcaparse,
          "next sync out of reach (%" G_GSIZE_FORMAT " < %u)", map.size,
          size + 16);
      goto cleanup;
    }
  }

  /* found frame */
  ret = GST_FLOW_OK;

  /* metadata handling */
  block_size = num_blocks * samples_per_block;

  if (G_UNLIKELY (dcaparse->rate != rate || dcaparse->channels != chans
          || dcaparse->depth != depth || dcaparse->endianness != endianness
          || (!terminator && dcaparse->block_size != block_size)
          || (size != dcaparse->frame_size))) {
    GstCaps *caps;

    caps = gst_caps_new_simple ("audio/x-dts",
        "framed", G_TYPE_BOOLEAN, TRUE,
        "rate", G_TYPE_INT, rate, "channels", G_TYPE_INT, chans,
        "endianness", G_TYPE_INT, endianness, "depth", G_TYPE_INT, depth,
        "block-size", G_TYPE_INT, block_size, "frame-size", G_TYPE_INT, size,
        NULL);
    gst_pad_set_caps (GST_BASE_PARSE_SRC_PAD (parse), caps);
    gst_caps_unref (caps);

    dcaparse->rate = rate;
    dcaparse->channels = chans;
    dcaparse->depth = depth;
    dcaparse->endianness = endianness;
    dcaparse->block_size = block_size;
    dcaparse->frame_size = size;

    gst_base_parse_set_frame_rate (parse, rate, block_size, 0, 0);
  }

cleanup:
  gst_buffer_unmap (buf, &map);

  if (ret == GST_FLOW_OK && size <= map.size) {
    ret = gst_base_parse_finish_frame (parse, frame, size);
  } else {
    ret = GST_FLOW_OK;
  }

  return ret;
}

/*
 * MPEG-PS private1 streams add a 2 bytes "Audio Substream Headers" for each
 * buffer (not each frame) with the offset of the next frame's start.
 * These 2 bytes can be dropped safely as they do not include any timing
 * information, only the offset to the start of the next frame.
 * See gstac3parse.c for a more detailed description.
 * */

static GstFlowReturn
gst_dca_parse_chain_priv (GstPad * pad, GstObject * parent, GstBuffer * buffer)
{
  GstDcaParse *dcaparse = GST_DCA_PARSE (parent);
  GstFlowReturn ret;
  GstBuffer *newbuf;
  gsize size;

  size = gst_buffer_get_size (buffer);
  if (size >= 2) {
    newbuf = gst_buffer_copy_region (buffer, GST_BUFFER_COPY_ALL, 2, size - 2);
    gst_buffer_unref (buffer);
    ret = dcaparse->baseparse_chainfunc (pad, parent, newbuf);
  } else {
    gst_buffer_unref (buffer);
    ret = GST_FLOW_OK;
  }

  return ret;
}

static void
remove_fields (GstCaps * caps)
{
  guint i, n;

  n = gst_caps_get_size (caps);
  for (i = 0; i < n; i++) {
    GstStructure *s = gst_caps_get_structure (caps, i);

    gst_structure_remove_field (s, "framed");
  }
}

static GstCaps *
gst_dca_parse_get_sink_caps (GstBaseParse * parse, GstCaps * filter)
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
    /* Remove the framed field */
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

static gboolean
gst_dca_parse_set_sink_caps (GstBaseParse * parse, GstCaps * caps)
{
  GstStructure *s;
  GstDcaParse *dcaparse = GST_DCA_PARSE (parse);

  s = gst_caps_get_structure (caps, 0);
  if (gst_structure_has_name (s, "audio/x-private1-dts")) {
    gst_pad_set_chain_function (parse->sinkpad, gst_dca_parse_chain_priv);
  } else {
    gst_pad_set_chain_function (parse->sinkpad, dcaparse->baseparse_chainfunc);
  }
  return TRUE;
}

static GstFlowReturn
gst_dca_parse_pre_push_frame (GstBaseParse * parse, GstBaseParseFrame * frame)
{
  GstDcaParse *dcaparse = GST_DCA_PARSE (parse);

  if (!dcaparse->sent_codec_tag) {
    GstTagList *taglist;
    GstCaps *caps;

    taglist = gst_tag_list_new_empty ();

    /* codec tag */
    caps = gst_pad_get_current_caps (GST_BASE_PARSE_SRC_PAD (parse));
    gst_pb_utils_add_codec_description_to_tag_list (taglist,
        GST_TAG_AUDIO_CODEC, caps);
    gst_caps_unref (caps);

    gst_pad_push_event (GST_BASE_PARSE_SRC_PAD (dcaparse),
        gst_event_new_tag (taglist));

    /* also signals the end of first-frame processing */
    dcaparse->sent_codec_tag = TRUE;
  }

  return GST_FLOW_OK;
}
