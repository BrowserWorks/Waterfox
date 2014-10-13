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

/**
 * SECTION:element-flacparse
 * @see_also: flacdec, oggdemux, vorbisparse
 *
 * The flacparse element will parse the header packets of the FLAC
 * stream and put them as the streamheader in the caps. This is used in the
 * multifdsink case where you want to stream live FLAC streams to multiple
 * clients, each client has to receive the streamheaders first before they can
 * consume the FLAC packets.
 *
 * This element also makes sure that the buffers that it pushes out are properly
 * timestamped and that their offset and offset_end are set. The buffers that
 * flacparse outputs have all of the metadata that oggmux expects to receive,
 * which allows you to (for example) remux an ogg/flac or convert a native FLAC
 * format file to an ogg bitstream.
 *
 * <refsect2>
 * <title>Example pipelines</title>
 * |[
 * gst-launch-1.0 -v filesrc location=sine.flac ! flacparse ! identity \
 *            ! oggmux ! filesink location=sine-remuxed.ogg
 * ]| This pipeline converts a native FLAC format file to an ogg bitstream.
 * It also illustrates that the streamheader is set in the caps, and that each
 * buffer has the timestamp, duration, offset, and offset_end set.
 * </refsect2>
 *
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gstflacparse.h"

#include <string.h>
#include <gst/tag/tag.h>
#include <gst/audio/audio.h>
#include <gst/base/base.h>
#include <gst/pbutils/pbutils.h>

GST_DEBUG_CATEGORY_STATIC (flacparse_debug);
#define GST_CAT_DEFAULT flacparse_debug

/* CRC-8, poly = x^8 + x^2 + x^1 + x^0, init = 0 */
static const guint8 crc8_table[256] = {
  0x00, 0x07, 0x0E, 0x09, 0x1C, 0x1B, 0x12, 0x15,
  0x38, 0x3F, 0x36, 0x31, 0x24, 0x23, 0x2A, 0x2D,
  0x70, 0x77, 0x7E, 0x79, 0x6C, 0x6B, 0x62, 0x65,
  0x48, 0x4F, 0x46, 0x41, 0x54, 0x53, 0x5A, 0x5D,
  0xE0, 0xE7, 0xEE, 0xE9, 0xFC, 0xFB, 0xF2, 0xF5,
  0xD8, 0xDF, 0xD6, 0xD1, 0xC4, 0xC3, 0xCA, 0xCD,
  0x90, 0x97, 0x9E, 0x99, 0x8C, 0x8B, 0x82, 0x85,
  0xA8, 0xAF, 0xA6, 0xA1, 0xB4, 0xB3, 0xBA, 0xBD,
  0xC7, 0xC0, 0xC9, 0xCE, 0xDB, 0xDC, 0xD5, 0xD2,
  0xFF, 0xF8, 0xF1, 0xF6, 0xE3, 0xE4, 0xED, 0xEA,
  0xB7, 0xB0, 0xB9, 0xBE, 0xAB, 0xAC, 0xA5, 0xA2,
  0x8F, 0x88, 0x81, 0x86, 0x93, 0x94, 0x9D, 0x9A,
  0x27, 0x20, 0x29, 0x2E, 0x3B, 0x3C, 0x35, 0x32,
  0x1F, 0x18, 0x11, 0x16, 0x03, 0x04, 0x0D, 0x0A,
  0x57, 0x50, 0x59, 0x5E, 0x4B, 0x4C, 0x45, 0x42,
  0x6F, 0x68, 0x61, 0x66, 0x73, 0x74, 0x7D, 0x7A,
  0x89, 0x8E, 0x87, 0x80, 0x95, 0x92, 0x9B, 0x9C,
  0xB1, 0xB6, 0xBF, 0xB8, 0xAD, 0xAA, 0xA3, 0xA4,
  0xF9, 0xFE, 0xF7, 0xF0, 0xE5, 0xE2, 0xEB, 0xEC,
  0xC1, 0xC6, 0xCF, 0xC8, 0xDD, 0xDA, 0xD3, 0xD4,
  0x69, 0x6E, 0x67, 0x60, 0x75, 0x72, 0x7B, 0x7C,
  0x51, 0x56, 0x5F, 0x58, 0x4D, 0x4A, 0x43, 0x44,
  0x19, 0x1E, 0x17, 0x10, 0x05, 0x02, 0x0B, 0x0C,
  0x21, 0x26, 0x2F, 0x28, 0x3D, 0x3A, 0x33, 0x34,
  0x4E, 0x49, 0x40, 0x47, 0x52, 0x55, 0x5C, 0x5B,
  0x76, 0x71, 0x78, 0x7F, 0x6A, 0x6D, 0x64, 0x63,
  0x3E, 0x39, 0x30, 0x37, 0x22, 0x25, 0x2C, 0x2B,
  0x06, 0x01, 0x08, 0x0F, 0x1A, 0x1D, 0x14, 0x13,
  0xAE, 0xA9, 0xA0, 0xA7, 0xB2, 0xB5, 0xBC, 0xBB,
  0x96, 0x91, 0x98, 0x9F, 0x8A, 0x8D, 0x84, 0x83,
  0xDE, 0xD9, 0xD0, 0xD7, 0xC2, 0xC5, 0xCC, 0xCB,
  0xE6, 0xE1, 0xE8, 0xEF, 0xFA, 0xFD, 0xF4, 0xF3
};

static guint8
gst_flac_calculate_crc8 (const guint8 * data, guint length)
{
  guint8 crc = 0;

  while (length--) {
    crc = crc8_table[crc ^ *data];
    ++data;
  }

  return crc;
}

/* CRC-16, poly = x^16 + x^15 + x^2 + x^0, init = 0 */
static const guint16 crc16_table[256] = {
  0x0000, 0x8005, 0x800f, 0x000a, 0x801b, 0x001e, 0x0014, 0x8011,
  0x8033, 0x0036, 0x003c, 0x8039, 0x0028, 0x802d, 0x8027, 0x0022,
  0x8063, 0x0066, 0x006c, 0x8069, 0x0078, 0x807d, 0x8077, 0x0072,
  0x0050, 0x8055, 0x805f, 0x005a, 0x804b, 0x004e, 0x0044, 0x8041,
  0x80c3, 0x00c6, 0x00cc, 0x80c9, 0x00d8, 0x80dd, 0x80d7, 0x00d2,
  0x00f0, 0x80f5, 0x80ff, 0x00fa, 0x80eb, 0x00ee, 0x00e4, 0x80e1,
  0x00a0, 0x80a5, 0x80af, 0x00aa, 0x80bb, 0x00be, 0x00b4, 0x80b1,
  0x8093, 0x0096, 0x009c, 0x8099, 0x0088, 0x808d, 0x8087, 0x0082,
  0x8183, 0x0186, 0x018c, 0x8189, 0x0198, 0x819d, 0x8197, 0x0192,
  0x01b0, 0x81b5, 0x81bf, 0x01ba, 0x81ab, 0x01ae, 0x01a4, 0x81a1,
  0x01e0, 0x81e5, 0x81ef, 0x01ea, 0x81fb, 0x01fe, 0x01f4, 0x81f1,
  0x81d3, 0x01d6, 0x01dc, 0x81d9, 0x01c8, 0x81cd, 0x81c7, 0x01c2,
  0x0140, 0x8145, 0x814f, 0x014a, 0x815b, 0x015e, 0x0154, 0x8151,
  0x8173, 0x0176, 0x017c, 0x8179, 0x0168, 0x816d, 0x8167, 0x0162,
  0x8123, 0x0126, 0x012c, 0x8129, 0x0138, 0x813d, 0x8137, 0x0132,
  0x0110, 0x8115, 0x811f, 0x011a, 0x810b, 0x010e, 0x0104, 0x8101,
  0x8303, 0x0306, 0x030c, 0x8309, 0x0318, 0x831d, 0x8317, 0x0312,
  0x0330, 0x8335, 0x833f, 0x033a, 0x832b, 0x032e, 0x0324, 0x8321,
  0x0360, 0x8365, 0x836f, 0x036a, 0x837b, 0x037e, 0x0374, 0x8371,
  0x8353, 0x0356, 0x035c, 0x8359, 0x0348, 0x834d, 0x8347, 0x0342,
  0x03c0, 0x83c5, 0x83cf, 0x03ca, 0x83db, 0x03de, 0x03d4, 0x83d1,
  0x83f3, 0x03f6, 0x03fc, 0x83f9, 0x03e8, 0x83ed, 0x83e7, 0x03e2,
  0x83a3, 0x03a6, 0x03ac, 0x83a9, 0x03b8, 0x83bd, 0x83b7, 0x03b2,
  0x0390, 0x8395, 0x839f, 0x039a, 0x838b, 0x038e, 0x0384, 0x8381,
  0x0280, 0x8285, 0x828f, 0x028a, 0x829b, 0x029e, 0x0294, 0x8291,
  0x82b3, 0x02b6, 0x02bc, 0x82b9, 0x02a8, 0x82ad, 0x82a7, 0x02a2,
  0x82e3, 0x02e6, 0x02ec, 0x82e9, 0x02f8, 0x82fd, 0x82f7, 0x02f2,
  0x02d0, 0x82d5, 0x82df, 0x02da, 0x82cb, 0x02ce, 0x02c4, 0x82c1,
  0x8243, 0x0246, 0x024c, 0x8249, 0x0258, 0x825d, 0x8257, 0x0252,
  0x0270, 0x8275, 0x827f, 0x027a, 0x826b, 0x026e, 0x0264, 0x8261,
  0x0220, 0x8225, 0x822f, 0x022a, 0x823b, 0x023e, 0x0234, 0x8231,
  0x8213, 0x0216, 0x021c, 0x8219, 0x0208, 0x820d, 0x8207, 0x0202
};

static guint16
gst_flac_calculate_crc16 (const guint8 * data, guint length)
{
  guint16 crc = 0;

  while (length--) {
    crc = ((crc << 8) ^ crc16_table[(crc >> 8) ^ *data]) & 0xffff;
    data++;
  }

  return crc;
}

enum
{
  PROP_0,
  PROP_CHECK_FRAME_CHECKSUMS
};

#define DEFAULT_CHECK_FRAME_CHECKSUMS FALSE

static GstStaticPadTemplate src_factory = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("audio/x-flac, framed = (boolean) true, "
        "channels = (int) [ 1, 8 ], " "rate = (int) [ 1, 655350 ]")
    );

static GstStaticPadTemplate sink_factory = GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("audio/x-flac")
    );

static GstBuffer *gst_flac_parse_generate_vorbiscomment (GstFlacParse *
    flacparse);

static void gst_flac_parse_finalize (GObject * object);
static void gst_flac_parse_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_flac_parse_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

static gboolean gst_flac_parse_start (GstBaseParse * parse);
static gboolean gst_flac_parse_stop (GstBaseParse * parse);
static GstFlowReturn gst_flac_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize);
static GstFlowReturn gst_flac_parse_parse_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint size);
static GstFlowReturn gst_flac_parse_pre_push_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame);
static gboolean gst_flac_parse_convert (GstBaseParse * parse,
    GstFormat src_format, gint64 src_value, GstFormat dest_format,
    gint64 * dest_value);
static gboolean gst_flac_parse_src_event (GstBaseParse * parse,
    GstEvent * event);
static GstCaps *gst_flac_parse_get_sink_caps (GstBaseParse * parse,
    GstCaps * filter);

#define gst_flac_parse_parent_class parent_class
G_DEFINE_TYPE (GstFlacParse, gst_flac_parse, GST_TYPE_BASE_PARSE);

static void
gst_flac_parse_class_init (GstFlacParseClass * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);
  GstElementClass *element_class = GST_ELEMENT_CLASS (klass);
  GstBaseParseClass *baseparse_class = GST_BASE_PARSE_CLASS (klass);

  GST_DEBUG_CATEGORY_INIT (flacparse_debug, "flacparse", 0,
      "Flac parser element");

  gobject_class->finalize = gst_flac_parse_finalize;
  gobject_class->set_property = gst_flac_parse_set_property;
  gobject_class->get_property = gst_flac_parse_get_property;

  g_object_class_install_property (gobject_class, PROP_CHECK_FRAME_CHECKSUMS,
      g_param_spec_boolean ("check-frame-checksums", "Check Frame Checksums",
          "Check the overall checksums of every frame",
          DEFAULT_CHECK_FRAME_CHECKSUMS,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  baseparse_class->start = GST_DEBUG_FUNCPTR (gst_flac_parse_start);
  baseparse_class->stop = GST_DEBUG_FUNCPTR (gst_flac_parse_stop);
  baseparse_class->handle_frame =
      GST_DEBUG_FUNCPTR (gst_flac_parse_handle_frame);
  baseparse_class->pre_push_frame =
      GST_DEBUG_FUNCPTR (gst_flac_parse_pre_push_frame);
  baseparse_class->convert = GST_DEBUG_FUNCPTR (gst_flac_parse_convert);
  baseparse_class->src_event = GST_DEBUG_FUNCPTR (gst_flac_parse_src_event);
  baseparse_class->get_sink_caps =
      GST_DEBUG_FUNCPTR (gst_flac_parse_get_sink_caps);

  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&src_factory));
  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&sink_factory));

  gst_element_class_set_static_metadata (element_class, "FLAC audio parser",
      "Codec/Parser/Audio",
      "Parses audio with the FLAC lossless audio codec",
      "Sebastian Dröge <sebastian.droege@collabora.co.uk>");
}

static void
gst_flac_parse_init (GstFlacParse * flacparse)
{
  flacparse->check_frame_checksums = DEFAULT_CHECK_FRAME_CHECKSUMS;
  GST_PAD_SET_ACCEPT_INTERSECT (GST_BASE_PARSE_SINK_PAD (flacparse));
}

static void
gst_flac_parse_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstFlacParse *flacparse = GST_FLAC_PARSE (object);

  switch (prop_id) {
    case PROP_CHECK_FRAME_CHECKSUMS:
      flacparse->check_frame_checksums = g_value_get_boolean (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_flac_parse_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstFlacParse *flacparse = GST_FLAC_PARSE (object);

  switch (prop_id) {
    case PROP_CHECK_FRAME_CHECKSUMS:
      g_value_set_boolean (value, flacparse->check_frame_checksums);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_flac_parse_finalize (GObject * object)
{
  GstFlacParse *flacparse = GST_FLAC_PARSE (object);

  if (flacparse->tags) {
    gst_tag_list_unref (flacparse->tags);
    flacparse->tags = NULL;
  }
  if (flacparse->toc) {
    gst_toc_unref (flacparse->toc);
    flacparse->toc = NULL;
  }

  g_list_foreach (flacparse->headers, (GFunc) gst_mini_object_unref, NULL);
  g_list_free (flacparse->headers);
  flacparse->headers = NULL;

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

static gboolean
gst_flac_parse_start (GstBaseParse * parse)
{
  GstFlacParse *flacparse = GST_FLAC_PARSE (parse);

  flacparse->state = GST_FLAC_PARSE_STATE_INIT;
  flacparse->min_blocksize = 0;
  flacparse->max_blocksize = 0;
  flacparse->min_framesize = 0;
  flacparse->max_framesize = 0;

  flacparse->upstream_length = -1;

  flacparse->samplerate = 0;
  flacparse->channels = 0;
  flacparse->bps = 0;
  flacparse->total_samples = 0;

  flacparse->offset = GST_CLOCK_TIME_NONE;
  flacparse->blocking_strategy = 0;
  flacparse->block_size = 0;
  flacparse->sample_number = 0;
  flacparse->strategy_checked = FALSE;

  flacparse->sent_codec_tag = FALSE;

  /* "fLaC" marker */
  gst_base_parse_set_min_frame_size (GST_BASE_PARSE (flacparse), 4);

  /* inform baseclass we can come up with ts, based on counters in packets */
  gst_base_parse_set_has_timing_info (GST_BASE_PARSE_CAST (flacparse), TRUE);
  gst_base_parse_set_syncable (GST_BASE_PARSE_CAST (flacparse), TRUE);

  return TRUE;
}

static gboolean
gst_flac_parse_stop (GstBaseParse * parse)
{
  GstFlacParse *flacparse = GST_FLAC_PARSE (parse);

  if (flacparse->tags) {
    gst_tag_list_unref (flacparse->tags);
    flacparse->tags = NULL;
  }
  if (flacparse->toc) {
    gst_toc_unref (flacparse->toc);
    flacparse->toc = NULL;
  }

  g_list_foreach (flacparse->headers, (GFunc) gst_mini_object_unref, NULL);
  g_list_free (flacparse->headers);
  flacparse->headers = NULL;

  return TRUE;
}

static const guint8 sample_size_table[] = { 0, 8, 12, 0, 16, 20, 24, 0 };

static const guint16 blocksize_table[16] = {
  0, 192, 576 << 0, 576 << 1, 576 << 2, 576 << 3, 0, 0,
  256 << 0, 256 << 1, 256 << 2, 256 << 3, 256 << 4, 256 << 5, 256 << 6,
  256 << 7,
};

static const guint32 sample_rate_table[16] = {
  0,
  88200, 176400, 192000,
  8000, 16000, 22050, 24000, 32000, 44100, 48000, 96000,
  0, 0, 0, 0,
};

typedef enum
{
  FRAME_HEADER_VALID,
  FRAME_HEADER_INVALID,
  FRAME_HEADER_MORE_DATA
} FrameHeaderCheckReturn;

static FrameHeaderCheckReturn
gst_flac_parse_frame_header_is_valid (GstFlacParse * flacparse,
    const guint8 * data, guint size, gboolean set, guint16 * block_size_ret,
    gboolean * suspect)
{
  GstBitReader reader = GST_BIT_READER_INIT (data, size);
  guint8 blocking_strategy;
  guint16 block_size;
  guint32 samplerate = 0;
  guint64 sample_number;
  guint8 channels, bps;
  guint8 tmp = 0;
  guint8 actual_crc, expected_crc = 0;

  /* Skip 14 bit sync code */
  gst_bit_reader_skip_unchecked (&reader, 14);

  /* Must be 0 */
  if (gst_bit_reader_get_bits_uint8_unchecked (&reader, 1) != 0)
    goto error;

  /* 0 == fixed block size, 1 == variable block size */
  blocking_strategy = gst_bit_reader_get_bits_uint8_unchecked (&reader, 1);
  if (flacparse->force_variable_block_size)
    blocking_strategy = 1;

  /* block size index, calculation of the real blocksize below */
  block_size = gst_bit_reader_get_bits_uint16_unchecked (&reader, 4);
  if (block_size == 0)
    goto error;

  /* sample rate index, calculation of the real samplerate below */
  samplerate = gst_bit_reader_get_bits_uint16_unchecked (&reader, 4);
  if (samplerate == 0x0f)
    goto error;

  /* channel assignment */
  channels = gst_bit_reader_get_bits_uint8_unchecked (&reader, 4);
  if (channels < 8) {
    channels++;
  } else if (channels <= 10) {
    channels = 2;
  } else if (channels > 10) {
    goto error;
  }
  if (flacparse->channels && flacparse->channels != channels)
    goto error;

  /* bits per sample */
  bps = gst_bit_reader_get_bits_uint8_unchecked (&reader, 3);
  if (bps == 0x03 || bps == 0x07) {
    goto error;
  } else if (bps == 0 && flacparse->bps == 0) {
    goto need_streaminfo;
  }
  bps = sample_size_table[bps];
  if (flacparse->bps && bps != flacparse->bps)
    goto error;

  /* reserved, must be 0 */
  if (gst_bit_reader_get_bits_uint8_unchecked (&reader, 1) != 0)
    goto error;

  /* read "utf8" encoded sample/frame number */
  {
    gint len = 0;

    len = gst_bit_reader_get_bits_uint8_unchecked (&reader, 8);

    /* This is slightly faster than a loop */
    if (!(len & 0x80)) {
      sample_number = len;
      len = 0;
    } else if ((len & 0xc0) && !(len & 0x20)) {
      sample_number = len & 0x1f;
      len = 1;
    } else if ((len & 0xe0) && !(len & 0x10)) {
      sample_number = len & 0x0f;
      len = 2;
    } else if ((len & 0xf0) && !(len & 0x08)) {
      sample_number = len & 0x07;
      len = 3;
    } else if ((len & 0xf8) && !(len & 0x04)) {
      sample_number = len & 0x03;
      len = 4;
    } else if ((len & 0xfc) && !(len & 0x02)) {
      sample_number = len & 0x01;
      len = 5;
    } else if ((len & 0xfe) && !(len & 0x01)) {
      sample_number = len & 0x0;
      len = 6;
    } else {
      goto error;
    }

    if ((blocking_strategy == 0 && len > 5) ||
        (blocking_strategy == 1 && len > 6))
      goto error;

    while (len > 0) {
      if (!gst_bit_reader_get_bits_uint8 (&reader, &tmp, 8))
        goto need_more_data;

      if ((tmp & 0xc0) != 0x80)
        goto error;

      sample_number <<= 6;
      sample_number |= (tmp & 0x3f);
      len--;
    }
  }

  /* calculate real blocksize from the blocksize index */
  if (block_size == 6) {
    if (!gst_bit_reader_get_bits_uint16 (&reader, &block_size, 8))
      goto need_more_data;
    block_size++;
  } else if (block_size == 7) {
    if (!gst_bit_reader_get_bits_uint16 (&reader, &block_size, 16))
      goto need_more_data;
    block_size++;
  } else {
    block_size = blocksize_table[block_size];
  }

  /* calculate the real samplerate from the samplerate index */
  if (samplerate == 0 && flacparse->samplerate == 0) {
    goto need_streaminfo;
  } else if (samplerate < 12) {
    samplerate = sample_rate_table[samplerate];
  } else if (samplerate == 12) {
    if (!gst_bit_reader_get_bits_uint32 (&reader, &samplerate, 8))
      goto need_more_data;
    samplerate *= 1000;
  } else if (samplerate == 13) {
    if (!gst_bit_reader_get_bits_uint32 (&reader, &samplerate, 16))
      goto need_more_data;
  } else if (samplerate == 14) {
    if (!gst_bit_reader_get_bits_uint32 (&reader, &samplerate, 16))
      goto need_more_data;
    samplerate *= 10;
  }

  if (flacparse->samplerate && flacparse->samplerate != samplerate)
    goto error;

  /* check crc-8 for the header */
  if (!gst_bit_reader_get_bits_uint8 (&reader, &expected_crc, 8))
    goto need_more_data;

  actual_crc =
      gst_flac_calculate_crc8 (data,
      (gst_bit_reader_get_pos (&reader) / 8) - 1);
  if (actual_crc != expected_crc)
    goto error;

  /* Sanity check sample number against blocking strategy, as it seems
     some files claim fixed block size but supply sample numbers,
     rather than block numbers. */
  if (blocking_strategy == 0 && flacparse->block_size != 0) {
    if (!flacparse->strategy_checked) {
      if (block_size == sample_number) {
        GST_WARNING_OBJECT (flacparse, "This file claims fixed block size, "
            "but seems to be lying: assuming variable block size");
        flacparse->force_variable_block_size = TRUE;
        blocking_strategy = 1;
      }
      flacparse->strategy_checked = TRUE;
    }
  }

  /* documentation says:
   * The "blocking strategy" bit must be the same throughout the entire stream. */
  if (flacparse->blocking_strategy != blocking_strategy) {
    if (flacparse->block_size != 0) {
      GST_WARNING_OBJECT (flacparse, "blocking strategy is not constant");
      if (suspect)
        *suspect = TRUE;
    }
  }

  /* 
     The FLAC format documentation says:
     The "blocking strategy" bit determines how to calculate the sample number
     of the first sample in the frame. If the bit is 0 (fixed-blocksize), the
     frame header encodes the frame number as above, and the frame's starting
     sample number will be the frame number times the blocksize. If it is 1
     (variable-blocksize), the frame header encodes the frame's starting
     sample number itself. (In the case of a fixed-blocksize stream, only the
     last block may be shorter than the stream blocksize; its starting sample
     number will be calculated as the frame number times the previous frame's
     blocksize, or zero if it is the first frame). 

     Therefore, when in fixed block size mode, we only update the block size
     the first time, then reuse that block size for subsequent calls.
     This will also fix a timestamp problem with the last block's timestamp
     being miscalculated by scaling the block number by a "wrong" block size.
   */
  if (blocking_strategy == 0) {
    if (flacparse->block_size != 0) {
      /* after first block */
      if (flacparse->block_size != block_size) {
        /* TODO: can we know we're on the last frame, to avoid warning ? */
        GST_WARNING_OBJECT (flacparse, "Block size is not constant");
        block_size = flacparse->block_size;
        if (suspect)
          *suspect = TRUE;
      }
    }
  }

  if (set) {
    flacparse->block_size = block_size;
    if (!flacparse->samplerate)
      flacparse->samplerate = samplerate;
    if (!flacparse->bps)
      flacparse->bps = bps;
    if (!flacparse->blocking_strategy)
      flacparse->blocking_strategy = blocking_strategy;
    if (!flacparse->channels)
      flacparse->channels = channels;
    if (!flacparse->sample_number)
      flacparse->sample_number = sample_number;

    GST_DEBUG_OBJECT (flacparse,
        "Parsed frame at offset %" G_GUINT64_FORMAT ":\n" "Block size: %u\n"
        "Sample/Frame number: %" G_GUINT64_FORMAT, flacparse->offset,
        flacparse->block_size, flacparse->sample_number);
  }

  if (block_size_ret)
    *block_size_ret = block_size;

  return FRAME_HEADER_VALID;

need_streaminfo:
  GST_ERROR_OBJECT (flacparse, "Need STREAMINFO");
  return FRAME_HEADER_INVALID;
error:
  return FRAME_HEADER_INVALID;

need_more_data:
  return FRAME_HEADER_MORE_DATA;
}

static gboolean
gst_flac_parse_frame_is_valid (GstFlacParse * flacparse,
    GstBaseParseFrame * frame, guint * ret)
{
  GstBuffer *buffer;
  GstMapInfo map;
  guint max, remaining;
  guint i, search_start, search_end;
  FrameHeaderCheckReturn header_ret;
  guint16 block_size;
  gboolean suspect_start = FALSE, suspect_end = FALSE;
  gboolean result = FALSE;

  buffer = frame->buffer;
  gst_buffer_map (buffer, &map, GST_MAP_READ);

  if (map.size < flacparse->min_framesize)
    goto need_more;

  header_ret =
      gst_flac_parse_frame_header_is_valid (flacparse, map.data, map.size, TRUE,
      &block_size, &suspect_start);
  if (header_ret == FRAME_HEADER_INVALID) {
    *ret = 0;
    goto cleanup;
  }
  if (header_ret == FRAME_HEADER_MORE_DATA)
    goto need_more;

  /* mind unknown framesize */
  search_start = MAX (2, flacparse->min_framesize);
  if (flacparse->max_framesize)
    search_end = MIN (map.size, flacparse->max_framesize + 9 + 2);
  else
    search_end = map.size;
  search_end -= 2;

  remaining = map.size;

  for (i = search_start; i < search_end; i++, remaining--) {
    if ((GST_READ_UINT16_BE (map.data + i) & 0xfffe) == 0xfff8) {
      GST_LOG_OBJECT (flacparse, "possible frame end at offset %d", i);
      suspect_end = FALSE;
      header_ret =
          gst_flac_parse_frame_header_is_valid (flacparse, map.data + i,
          remaining, FALSE, NULL, &suspect_end);
      if (header_ret == FRAME_HEADER_VALID) {
        if (flacparse->check_frame_checksums || suspect_start || suspect_end) {
          guint16 actual_crc = gst_flac_calculate_crc16 (map.data, i - 2);
          guint16 expected_crc = GST_READ_UINT16_BE (map.data + i - 2);

          GST_LOG_OBJECT (flacparse,
              "checking checksum, frame suspect (%d, %d)",
              suspect_start, suspect_end);
          if (actual_crc != expected_crc) {
            GST_DEBUG_OBJECT (flacparse, "checksum did not match");
            continue;
          }
        }
        *ret = i;
        flacparse->block_size = block_size;
        result = TRUE;
        goto cleanup;
      } else if (header_ret == FRAME_HEADER_MORE_DATA) {
        goto need_more;
      }
    }
  }

  /* For the last frame output everything to the end */
  if (G_UNLIKELY (GST_BASE_PARSE_DRAINING (flacparse))) {
    if (flacparse->check_frame_checksums) {
      guint16 actual_crc = gst_flac_calculate_crc16 (map.data, map.size - 2);
      guint16 expected_crc = GST_READ_UINT16_BE (map.data + map.size - 2);

      if (actual_crc == expected_crc) {
        *ret = map.size;
        flacparse->block_size = block_size;
        result = TRUE;
        goto cleanup;
      }
    } else {
      *ret = map.size;
      flacparse->block_size = block_size;
      result = TRUE;
      goto cleanup;
    }
  }

  /* so we searched to expected end and found nothing,
   * give up on this frame (start) */
  if (flacparse->max_framesize && i > 2 * flacparse->max_framesize) {
    GST_LOG_OBJECT (flacparse,
        "could not determine valid frame end, discarding frame (start)");
    *ret = 1;
    return FALSE;
  }

need_more:
  max = flacparse->max_framesize + 16;
  if (max == 16)
    max = 1 << 24;
  *ret = MIN (map.size + 4096, max);
  result = TRUE;

cleanup:
  gst_buffer_unmap (buffer, &map);
  return result;
}

static GstFlowReturn
gst_flac_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize)
{
  GstFlacParse *flacparse = GST_FLAC_PARSE (parse);
  GstBuffer *buffer = frame->buffer;
  GstMapInfo map;
  gboolean result = TRUE;
  GstFlowReturn ret = GST_FLOW_OK;
  guint framesize = 0;

  gst_buffer_map (buffer, &map, GST_MAP_READ);

  *skipsize = 1;

  if (G_UNLIKELY (map.size < 4)) {
    result = FALSE;
    goto cleanup;
  }

  if (flacparse->state == GST_FLAC_PARSE_STATE_INIT) {
    if (memcmp (map.data, "fLaC", 4) == 0) {
      GST_DEBUG_OBJECT (flacparse, "fLaC marker found");
      framesize = 4;
      goto cleanup;
    }
    if (map.data[0] == 0xff && (map.data[1] >> 2) == 0x3e) {
      GST_DEBUG_OBJECT (flacparse, "Found headerless FLAC");
      /* Minimal size of a frame header */
      gst_base_parse_set_min_frame_size (GST_BASE_PARSE (flacparse), 9);
      flacparse->state = GST_FLAC_PARSE_STATE_GENERATE_HEADERS;
      *skipsize = 0;
      result = FALSE;
      goto cleanup;
    }
    GST_DEBUG_OBJECT (flacparse, "fLaC marker not found");
    result = FALSE;
    goto cleanup;
  }

  if (flacparse->state == GST_FLAC_PARSE_STATE_HEADERS) {
    guint size = 4 + ((map.data[1] << 16) | (map.data[2] << 8) | (map.data[3]));

    GST_DEBUG_OBJECT (flacparse, "Found metadata block of size %u", size);
    framesize = size;
    goto cleanup;
  }

  if ((GST_READ_UINT16_BE (map.data) & 0xfffe) == 0xfff8) {
    gboolean ret;
    guint next;

    flacparse->offset = GST_BUFFER_OFFSET (buffer);
    flacparse->blocking_strategy = 0;
    flacparse->sample_number = 0;

    GST_DEBUG_OBJECT (flacparse, "Found sync code");
    ret = gst_flac_parse_frame_is_valid (flacparse, frame, &next);
    if (ret) {
      framesize = next;
      goto cleanup;
    } else {
      /* If we're at EOS and the frame was not valid, drop it! */
      if (G_UNLIKELY (GST_BASE_PARSE_DRAINING (flacparse))) {
        GST_WARNING_OBJECT (flacparse, "EOS");
        result = FALSE;
        goto cleanup;
      }

      if (next == 0) {
      } else if (next > map.size) {
        GST_DEBUG_OBJECT (flacparse, "Requesting %u bytes", next);
        *skipsize = 0;
        gst_base_parse_set_min_frame_size (parse, next);
        result = FALSE;
        goto cleanup;
      } else {
        GST_ERROR_OBJECT (flacparse,
            "Giving up on invalid frame (%" G_GSIZE_FORMAT " bytes)", map.size);
        result = FALSE;
        goto cleanup;
      }
    }
  } else {
    GstByteReader reader;
    gint off;

    gst_byte_reader_init (&reader, map.data, map.size);
    off =
        gst_byte_reader_masked_scan_uint32 (&reader, 0xfffc0000, 0xfff80000,
        0, map.size);

    if (off > 0) {
      GST_DEBUG_OBJECT (parse, "Possible sync at buffer offset %d", off);
      *skipsize = off;
      result = FALSE;
      goto cleanup;
    } else {
      GST_DEBUG_OBJECT (flacparse, "Sync code not found");
      *skipsize = map.size - 3;
      result = FALSE;
      goto cleanup;
    }
  }

  result = FALSE;

cleanup:
  gst_buffer_unmap (buffer, &map);

  if (result)
    *skipsize = 0;

  if (result && framesize <= map.size) {
    ret = gst_flac_parse_parse_frame (parse, frame, framesize);
    if (ret == GST_BASE_PARSE_FLOW_DROPPED) {
      frame->flags |= GST_BASE_PARSE_FRAME_FLAG_DROP;
      ret = GST_FLOW_OK;
    }
    if (ret == GST_FLOW_OK)
      ret = gst_base_parse_finish_frame (parse, frame, framesize);
  }

  return ret;
}

static gboolean
gst_flac_parse_handle_streaminfo (GstFlacParse * flacparse, GstBuffer * buffer)
{
  GstBitReader reader;
  GstMapInfo map;

  gst_buffer_map (buffer, &map, GST_MAP_READ);
  gst_bit_reader_init (&reader, map.data, map.size);

  if (map.size != 4 + 34) {
    GST_ERROR_OBJECT (flacparse,
        "Invalid metablock size for STREAMINFO: %" G_GSIZE_FORMAT "", map.size);
    goto failure;
  }

  /* Skip metadata block header */
  if (!gst_bit_reader_skip (&reader, 32))
    goto error;

  if (!gst_bit_reader_get_bits_uint16 (&reader, &flacparse->min_blocksize, 16))
    goto error;
  if (flacparse->min_blocksize < 16) {
    GST_WARNING_OBJECT (flacparse, "Invalid minimum block size: %u",
        flacparse->min_blocksize);
  }

  if (!gst_bit_reader_get_bits_uint16 (&reader, &flacparse->max_blocksize, 16))
    goto error;
  if (flacparse->max_blocksize < 16) {
    GST_WARNING_OBJECT (flacparse, "Invalid maximum block size: %u",
        flacparse->max_blocksize);
  }

  if (!gst_bit_reader_get_bits_uint32 (&reader, &flacparse->min_framesize, 24))
    goto error;
  if (!gst_bit_reader_get_bits_uint32 (&reader, &flacparse->max_framesize, 24))
    goto error;

  if (!gst_bit_reader_get_bits_uint32 (&reader, &flacparse->samplerate, 20))
    goto error;
  if (flacparse->samplerate == 0) {
    GST_ERROR_OBJECT (flacparse, "Invalid sample rate 0");
    goto failure;
  }

  if (!gst_bit_reader_get_bits_uint8 (&reader, &flacparse->channels, 3))
    goto error;
  flacparse->channels++;
  if (flacparse->channels > 8) {
    GST_ERROR_OBJECT (flacparse, "Invalid number of channels %u",
        flacparse->channels);
    goto failure;
  }

  if (!gst_bit_reader_get_bits_uint8 (&reader, &flacparse->bps, 5))
    goto error;
  flacparse->bps++;

  if (!gst_bit_reader_get_bits_uint64 (&reader, &flacparse->total_samples, 36))
    goto error;
  if (flacparse->total_samples) {
    gst_base_parse_set_duration (GST_BASE_PARSE (flacparse),
        GST_FORMAT_DEFAULT, flacparse->total_samples, 0);
  }

  gst_buffer_unmap (buffer, &map);

  GST_DEBUG_OBJECT (flacparse, "STREAMINFO:\n"
      "\tmin/max blocksize: %u/%u,\n"
      "\tmin/max framesize: %u/%u,\n"
      "\tsamplerate: %u,\n"
      "\tchannels: %u,\n"
      "\tbits per sample: %u,\n"
      "\ttotal samples: %" G_GUINT64_FORMAT,
      flacparse->min_blocksize, flacparse->max_blocksize,
      flacparse->min_framesize, flacparse->max_framesize,
      flacparse->samplerate,
      flacparse->channels, flacparse->bps, flacparse->total_samples);

  return TRUE;

error:
  GST_ERROR_OBJECT (flacparse, "Failed to read data");
failure:
  gst_buffer_unmap (buffer, &map);
  return FALSE;
}

static gboolean
gst_flac_parse_handle_vorbiscomment (GstFlacParse * flacparse,
    GstBuffer * buffer)
{
  GstTagList *tags;
  GstMapInfo map;

  gst_buffer_map (buffer, &map, GST_MAP_READ);

  tags =
      gst_tag_list_from_vorbiscomment (map.data, map.size, map.data, 4, NULL);
  gst_buffer_unmap (buffer, &map);

  if (tags == NULL) {
    GST_ERROR_OBJECT (flacparse, "Invalid vorbiscomment block");
  } else if (gst_tag_list_is_empty (tags)) {
    gst_tag_list_unref (tags);
  } else if (flacparse->tags == NULL) {
    flacparse->tags = tags;
  } else {
    gst_tag_list_insert (flacparse->tags, tags, GST_TAG_MERGE_APPEND);
    gst_tag_list_unref (tags);
  }

  return TRUE;
}

static gboolean
gst_flac_parse_handle_cuesheet (GstFlacParse * flacparse, GstBuffer * buffer)
{
  GstByteReader reader;
  GstMapInfo map;
  guint i, j;
  guint8 n_tracks, track_num, index;
  guint64 offset;
  gint64 start, stop;
  gchar *id;
  gchar isrc[13];
  GstTagList *tags;
  GstToc *toc;
  GstTocEntry *cur_entry = NULL, *prev_entry = NULL;

  gst_buffer_map (buffer, &map, GST_MAP_READ);
  gst_byte_reader_init (&reader, map.data, map.size);

  toc = gst_toc_new (GST_TOC_SCOPE_GLOBAL);

  /* skip 4 bytes METADATA_BLOCK_HEADER */
  /* http://flac.sourceforge.net/format.html#metadata_block_header */
  if (!gst_byte_reader_skip (&reader, 4))
    goto error;

  /* skip 395 bytes from METADATA_BLOCK_CUESHEET */
  /* http://flac.sourceforge.net/format.html#metadata_block_cuesheet */
  if (!gst_byte_reader_skip (&reader, 395))
    goto error;

  if (!gst_byte_reader_get_uint8 (&reader, &n_tracks))
    goto error;

  /* CUESHEET_TRACK */
  /* http://flac.sourceforge.net/format.html#cuesheet_track */
  for (i = 0; i < n_tracks; i++) {
    if (!gst_byte_reader_get_uint64_be (&reader, &offset))
      goto error;
    if (!gst_byte_reader_get_uint8 (&reader, &track_num))
      goto error;

    if (gst_byte_reader_get_remaining (&reader) < 12)
      goto error;
    memcpy (isrc, map.data + gst_byte_reader_get_pos (&reader), 12);
    /* \0-terminate the string */
    isrc[12] = '\0';
    if (!gst_byte_reader_skip (&reader, 12))
      goto error;

    /* skip 14 bytes from CUESHEET_TRACK */
    if (!gst_byte_reader_skip (&reader, 14))
      goto error;
    if (!gst_byte_reader_get_uint8 (&reader, &index))
      goto error;
    /* add tracks in TOC */
    /* lead-out tack has number 170 or 255 */
    if (track_num != 170 && track_num != 255) {
      prev_entry = cur_entry;
      /* previous track stop time = current track start time */
      if (prev_entry != NULL) {
        gst_toc_entry_get_start_stop_times (prev_entry, &start, NULL);
        stop =
            gst_util_uint64_scale_round (offset, GST_SECOND,
            flacparse->samplerate);
        gst_toc_entry_set_start_stop_times (prev_entry, start, stop);
      }
      id = g_strdup_printf ("%08x", track_num);
      cur_entry = gst_toc_entry_new (GST_TOC_ENTRY_TYPE_TRACK, id);
      g_free (id);
      start =
          gst_util_uint64_scale_round (offset, GST_SECOND,
          flacparse->samplerate);
      gst_toc_entry_set_start_stop_times (cur_entry, start, -1);
      /* add ISRC as tag in track */
      if (strlen (isrc) != 0) {
        tags = gst_tag_list_new_empty ();
        gst_tag_list_add (tags, GST_TAG_MERGE_APPEND, GST_TAG_ISRC, isrc, NULL);
        gst_toc_entry_set_tags (cur_entry, tags);
      }
      gst_toc_append_entry (toc, cur_entry);
      /* CUESHEET_TRACK_INDEX */
      /* http://flac.sourceforge.net/format.html#cuesheet_track_index */
      for (j = 0; j < index; j++) {
        if (!gst_byte_reader_skip (&reader, 12))
          goto error;
      }
    } else {
      /* set stop time in last track */
      stop =
          gst_util_uint64_scale_round (offset, GST_SECOND,
          flacparse->samplerate);
      gst_toc_entry_set_start_stop_times (cur_entry, start, stop);
    }
  }

  /* send data as TOC */
  if (!flacparse->toc)
    flacparse->toc = toc;

  gst_buffer_unmap (buffer, &map);
  return TRUE;

error:
  GST_ERROR_OBJECT (flacparse, "Error reading data");
  gst_buffer_unmap (buffer, &map);
  return FALSE;
}

static gboolean
gst_flac_parse_handle_picture (GstFlacParse * flacparse, GstBuffer * buffer)
{
  GstByteReader reader;
  GstMapInfo map;
  guint32 img_len = 0, img_type = 0;
  guint32 img_mimetype_len = 0, img_description_len = 0;

  gst_buffer_map (buffer, &map, GST_MAP_READ);
  gst_byte_reader_init (&reader, map.data, map.size);

  if (!gst_byte_reader_skip (&reader, 4))
    goto error;

  if (!gst_byte_reader_get_uint32_be (&reader, &img_type))
    goto error;

  if (!gst_byte_reader_get_uint32_be (&reader, &img_mimetype_len))
    goto error;
  if (!gst_byte_reader_skip (&reader, img_mimetype_len))
    goto error;

  if (!gst_byte_reader_get_uint32_be (&reader, &img_description_len))
    goto error;
  if (!gst_byte_reader_skip (&reader, img_description_len))
    goto error;

  if (!gst_byte_reader_skip (&reader, 4 * 4))
    goto error;

  if (!gst_byte_reader_get_uint32_be (&reader, &img_len))
    goto error;

  if (gst_byte_reader_get_pos (&reader) + img_len > map.size)
    goto error;

  if (!flacparse->tags)
    flacparse->tags = gst_tag_list_new_empty ();

  GST_INFO_OBJECT (flacparse, "Got image of %d bytes", img_len);

  if (img_len > 0) {
    gst_tag_list_add_id3_image (flacparse->tags,
        map.data + gst_byte_reader_get_pos (&reader), img_len, img_type);
  }

  if (gst_tag_list_is_empty (flacparse->tags)) {
    gst_tag_list_unref (flacparse->tags);
    flacparse->tags = NULL;
  }

  gst_buffer_unmap (buffer, &map);
  return TRUE;

error:
  GST_ERROR_OBJECT (flacparse, "Error reading data");
  gst_buffer_unmap (buffer, &map);
  return FALSE;
}

static gboolean
gst_flac_parse_handle_seektable (GstFlacParse * flacparse, GstBuffer * buffer)
{

  GST_DEBUG_OBJECT (flacparse, "storing seektable");
  /* only store for now;
   * offset of the first frame is needed to get real info */
  flacparse->seektable = gst_buffer_ref (buffer);

  return TRUE;
}

static void
gst_flac_parse_process_seektable (GstFlacParse * flacparse, gint64 boffset)
{
  GstByteReader br;
  gint64 offset = 0, samples = 0;
  GstMapInfo map;

  GST_DEBUG_OBJECT (flacparse,
      "parsing seektable; base offset %" G_GINT64_FORMAT, boffset);

  if (boffset <= 0)
    goto exit;

  gst_buffer_map (flacparse->seektable, &map, GST_MAP_READ);
  gst_byte_reader_init (&br, map.data, map.size);

  /* skip header */
  if (!gst_byte_reader_skip (&br, 4))
    goto done;

  /* seekpoints */
  while (gst_byte_reader_get_remaining (&br)) {
    if (!gst_byte_reader_get_int64_be (&br, &samples))
      break;
    if (!gst_byte_reader_get_int64_be (&br, &offset))
      break;
    if (!gst_byte_reader_skip (&br, 2))
      break;

    GST_LOG_OBJECT (flacparse, "samples %" G_GINT64_FORMAT " -> offset %"
        G_GINT64_FORMAT, samples, offset);

    /* sanity check */
    if (G_LIKELY (offset > 0 && samples > 0)) {
      gst_base_parse_add_index_entry (GST_BASE_PARSE (flacparse),
          boffset + offset, gst_util_uint64_scale (samples, GST_SECOND,
              flacparse->samplerate), TRUE, FALSE);
    }
  }

done:
  gst_buffer_unmap (flacparse->seektable, &map);
exit:
  gst_buffer_unref (flacparse->seektable);
  flacparse->seektable = NULL;
}

static void
_value_array_append_buffer (GValue * array_val, GstBuffer * buf)
{
  GValue value = { 0, };

  g_value_init (&value, GST_TYPE_BUFFER);
  /* copy buffer to avoid problems with circular refcounts */
  buf = gst_buffer_copy (buf);
  /* again, for good measure */
  GST_BUFFER_FLAG_SET (buf, GST_BUFFER_FLAG_HEADER);
  gst_value_set_buffer (&value, buf);
  gst_buffer_unref (buf);
  gst_value_array_append_value (array_val, &value);
  g_value_unset (&value);
}

static GstFlowReturn
gst_flac_parse_handle_headers (GstFlacParse * flacparse)
{
  GstBuffer *vorbiscomment = NULL;
  GstBuffer *streaminfo = NULL;
  GstBuffer *marker = NULL;
  GValue array = { 0, };
  GstCaps *caps;
  GList *l;
  GstFlowReturn res = GST_FLOW_OK;

  caps = gst_caps_new_simple ("audio/x-flac",
      "channels", G_TYPE_INT, flacparse->channels,
      "framed", G_TYPE_BOOLEAN, TRUE,
      "rate", G_TYPE_INT, flacparse->samplerate, NULL);

  if (!flacparse->headers)
    goto push_headers;

  for (l = flacparse->headers; l; l = l->next) {
    GstBuffer *header = l->data;
    GstMapInfo map;

    gst_buffer_map (header, &map, GST_MAP_READ);

    GST_BUFFER_FLAG_SET (header, GST_BUFFER_FLAG_HEADER);

    if (map.size == 4 && memcmp (map.data, "fLaC", 4) == 0) {
      marker = header;
    } else if (map.size > 1 && (map.data[0] & 0x7f) == 0) {
      streaminfo = header;
    } else if (map.size > 1 && (map.data[0] & 0x7f) == 4) {
      vorbiscomment = header;
    }

    gst_buffer_unmap (header, &map);
  }

  /* at least this one we can generate easily
   * to provide full headers downstream */
  if (vorbiscomment == NULL && streaminfo != NULL) {
    GST_DEBUG_OBJECT (flacparse,
        "missing vorbiscomment header; generating dummy");
    vorbiscomment = gst_flac_parse_generate_vorbiscomment (flacparse);
    flacparse->headers = g_list_insert (flacparse->headers, vorbiscomment,
        g_list_index (flacparse->headers, streaminfo) + 1);
  }

  if (marker == NULL || streaminfo == NULL || vorbiscomment == NULL) {
    GST_WARNING_OBJECT (flacparse,
        "missing header %p %p %p, muxing into container "
        "formats may be broken", marker, streaminfo, vorbiscomment);
    goto push_headers;
  }

  g_value_init (&array, GST_TYPE_ARRAY);

  /* add marker including STREAMINFO header */
  {
    GstBuffer *buf;
    guint16 num;
    GstMapInfo sinfomap, writemap;

    gst_buffer_map (streaminfo, &sinfomap, GST_MAP_READ);

    /* minus one for the marker that is merged with streaminfo here */
    num = g_list_length (flacparse->headers) - 1;

    buf = gst_buffer_new_and_alloc (13 + sinfomap.size);
    gst_buffer_map (buf, &writemap, GST_MAP_WRITE);

    writemap.data[0] = 0x7f;
    memcpy (writemap.data + 1, "FLAC", 4);
    writemap.data[5] = 0x01;    /* mapping version major */
    writemap.data[6] = 0x00;    /* mapping version minor */
    writemap.data[7] = (num & 0xFF00) >> 8;
    writemap.data[8] = (num & 0x00FF) >> 0;
    memcpy (writemap.data + 9, "fLaC", 4);
    memcpy (writemap.data + 13, sinfomap.data, sinfomap.size);
    _value_array_append_buffer (&array, buf);

    gst_buffer_unmap (streaminfo, &sinfomap);
    gst_buffer_unmap (buf, &writemap);
    gst_buffer_unref (buf);
  }

  /* add VORBISCOMMENT header */
  _value_array_append_buffer (&array, vorbiscomment);

  /* add other headers, if there are any */
  for (l = flacparse->headers; l; l = l->next) {
    if (GST_BUFFER_CAST (l->data) != marker &&
        GST_BUFFER_CAST (l->data) != streaminfo &&
        GST_BUFFER_CAST (l->data) != vorbiscomment) {
      _value_array_append_buffer (&array, GST_BUFFER_CAST (l->data));
    }
  }

  gst_structure_set_value (gst_caps_get_structure (caps, 0),
      "streamheader", &array);
  g_value_unset (&array);

push_headers:

  gst_pad_set_caps (GST_BASE_PARSE_SRC_PAD (GST_BASE_PARSE (flacparse)), caps);
  gst_caps_unref (caps);

  /* push header buffers; update caps, so when we push the first buffer the
   * negotiated caps will change to caps that include the streamheader field */
  while (flacparse->headers) {
    GstBuffer *buf = GST_BUFFER (flacparse->headers->data);
    GstBaseParseFrame frame;

    flacparse->headers =
        g_list_delete_link (flacparse->headers, flacparse->headers);
    buf = gst_buffer_make_writable (buf);

    /* init, set and give away frame */
    gst_base_parse_frame_init (&frame);
    frame.buffer = buf;
    frame.overhead = -1;
    res = gst_base_parse_push_frame (GST_BASE_PARSE (flacparse), &frame);
    gst_base_parse_frame_free (&frame);
    if (res != GST_FLOW_OK)
      break;
  }
  g_list_foreach (flacparse->headers, (GFunc) gst_mini_object_unref, NULL);
  g_list_free (flacparse->headers);
  flacparse->headers = NULL;

  return res;
}

/* empty vorbiscomment */
static GstBuffer *
gst_flac_parse_generate_vorbiscomment (GstFlacParse * flacparse)
{
  GstTagList *taglist = gst_tag_list_new_empty ();
  guchar header[4];
  guint size;
  GstBuffer *vorbiscomment;
  GstMapInfo map;

  header[0] = 0x84;             /* is_last = 1; type = 4; */

  vorbiscomment =
      gst_tag_list_to_vorbiscomment_buffer (taglist, header,
      sizeof (header), NULL);
  gst_tag_list_unref (taglist);

  gst_buffer_map (vorbiscomment, &map, GST_MAP_WRITE);

  /* Get rid of framing bit */
  if (map.data[map.size - 1] == 1) {
    GstBuffer *sub;

    sub =
        gst_buffer_copy_region (vorbiscomment, GST_BUFFER_COPY_ALL, 0,
        map.size - 1);
    gst_buffer_unmap (vorbiscomment, &map);
    gst_buffer_unref (vorbiscomment);
    vorbiscomment = sub;
    gst_buffer_map (vorbiscomment, &map, GST_MAP_WRITE);
  }

  size = map.size - 4;
  map.data[1] = ((size & 0xFF0000) >> 16);
  map.data[2] = ((size & 0x00FF00) >> 8);
  map.data[3] = (size & 0x0000FF);
  gst_buffer_unmap (vorbiscomment, &map);

  GST_BUFFER_TIMESTAMP (vorbiscomment) = GST_CLOCK_TIME_NONE;
  GST_BUFFER_DURATION (vorbiscomment) = GST_CLOCK_TIME_NONE;
  GST_BUFFER_OFFSET (vorbiscomment) = 0;
  GST_BUFFER_OFFSET_END (vorbiscomment) = 0;

  return vorbiscomment;
}

static gboolean
gst_flac_parse_generate_headers (GstFlacParse * flacparse)
{
  GstBuffer *marker, *streaminfo;
  GstMapInfo map;

  marker = gst_buffer_new_and_alloc (4);
  gst_buffer_map (marker, &map, GST_MAP_WRITE);
  memcpy (map.data, "fLaC", 4);
  gst_buffer_unmap (marker, &map);
  GST_BUFFER_TIMESTAMP (marker) = GST_CLOCK_TIME_NONE;
  GST_BUFFER_DURATION (marker) = GST_CLOCK_TIME_NONE;
  GST_BUFFER_OFFSET (marker) = 0;
  GST_BUFFER_OFFSET_END (marker) = 0;
  flacparse->headers = g_list_append (flacparse->headers, marker);

  streaminfo = gst_buffer_new_and_alloc (4 + 34);
  gst_buffer_map (streaminfo, &map, GST_MAP_WRITE);
  memset (map.data, 0, 4 + 34);

  /* metadata block header */
  map.data[0] = 0x00;           /* is_last = 0; type = 0; */
  map.data[1] = 0x00;           /* length = 34; */
  map.data[2] = 0x00;
  map.data[3] = 0x22;

  /* streaminfo */

  map.data[4] = (flacparse->block_size >> 8) & 0xff;    /* min blocksize = blocksize; */
  map.data[5] = (flacparse->block_size) & 0xff;
  map.data[6] = (flacparse->block_size >> 8) & 0xff;    /* max blocksize = blocksize; */
  map.data[7] = (flacparse->block_size) & 0xff;

  map.data[8] = 0x00;           /* min framesize = 0; */
  map.data[9] = 0x00;
  map.data[10] = 0x00;
  map.data[11] = 0x00;          /* max framesize = 0; */
  map.data[12] = 0x00;
  map.data[13] = 0x00;

  map.data[14] = (flacparse->samplerate >> 12) & 0xff;
  map.data[15] = (flacparse->samplerate >> 4) & 0xff;
  map.data[16] = (flacparse->samplerate >> 0) & 0xf0;

  map.data[16] |= (flacparse->channels - 1) << 1;

  map.data[16] |= ((flacparse->bps - 1) >> 4) & 0x01;
  map.data[17] = (((flacparse->bps - 1)) & 0x0f) << 4;

  {
    gint64 duration;

    if (gst_pad_peer_query_duration (GST_BASE_PARSE_SINK_PAD (flacparse),
            GST_FORMAT_TIME, &duration)) {
      duration = GST_CLOCK_TIME_TO_FRAMES (duration, flacparse->samplerate);

      map.data[17] |= (duration >> 32) & 0xff;
      map.data[18] |= (duration >> 24) & 0xff;
      map.data[19] |= (duration >> 16) & 0xff;
      map.data[20] |= (duration >> 8) & 0xff;
      map.data[21] |= (duration >> 0) & 0xff;
    }
  }
  /* MD5 = 0; */

  gst_buffer_unmap (streaminfo, &map);
  GST_BUFFER_TIMESTAMP (streaminfo) = GST_CLOCK_TIME_NONE;
  GST_BUFFER_DURATION (streaminfo) = GST_CLOCK_TIME_NONE;
  GST_BUFFER_OFFSET (streaminfo) = 0;
  GST_BUFFER_OFFSET_END (streaminfo) = 0;
  flacparse->headers = g_list_append (flacparse->headers, streaminfo);

  flacparse->headers = g_list_append (flacparse->headers,
      gst_flac_parse_generate_vorbiscomment (flacparse));

  return TRUE;
}

static GstFlowReturn
gst_flac_parse_parse_frame (GstBaseParse * parse, GstBaseParseFrame * frame,
    gint size)
{
  GstFlacParse *flacparse = GST_FLAC_PARSE (parse);
  GstBuffer *buffer = frame->buffer, *sbuffer;
  GstMapInfo map;
  GstFlowReturn res = GST_FLOW_ERROR;

  gst_buffer_map (buffer, &map, GST_MAP_READ);

  if (flacparse->state == GST_FLAC_PARSE_STATE_INIT) {
    sbuffer = gst_buffer_copy_region (buffer, GST_BUFFER_COPY_ALL, 0, size);
    GST_BUFFER_TIMESTAMP (sbuffer) = GST_CLOCK_TIME_NONE;
    GST_BUFFER_DURATION (sbuffer) = GST_CLOCK_TIME_NONE;
    GST_BUFFER_OFFSET (sbuffer) = 0;
    GST_BUFFER_OFFSET_END (sbuffer) = 0;

    /* 32 bits metadata block */
    gst_base_parse_set_min_frame_size (GST_BASE_PARSE (flacparse), 4);
    flacparse->state = GST_FLAC_PARSE_STATE_HEADERS;

    flacparse->headers = g_list_append (flacparse->headers, sbuffer);

    res = GST_BASE_PARSE_FLOW_DROPPED;
  } else if (flacparse->state == GST_FLAC_PARSE_STATE_HEADERS) {
    gboolean is_last = ((map.data[0] & 0x80) == 0x80);
    guint type = (map.data[0] & 0x7F);
    gboolean hdr_ok = TRUE;

    if (type == 127) {
      GST_WARNING_OBJECT (flacparse, "Invalid metadata block type");
      res = GST_BASE_PARSE_FLOW_DROPPED;
      goto cleanup;
    }

    GST_DEBUG_OBJECT (flacparse, "Handling metadata block of type %u", type);

    sbuffer = gst_buffer_copy_region (buffer, GST_BUFFER_COPY_ALL, 0, size);

    switch (type) {
      case 0:                  /* STREAMINFO */
        GST_INFO_OBJECT (flacparse, "STREAMINFO header");
        hdr_ok = gst_flac_parse_handle_streaminfo (flacparse, sbuffer);
        break;
      case 3:                  /* SEEKTABLE */
        GST_INFO_OBJECT (flacparse, "SEEKTABLE header");
        hdr_ok = gst_flac_parse_handle_seektable (flacparse, sbuffer);
        break;
      case 4:                  /* VORBIS_COMMENT */
        GST_INFO_OBJECT (flacparse, "VORBISCOMMENT header");
        hdr_ok = gst_flac_parse_handle_vorbiscomment (flacparse, sbuffer);
        break;
      case 5:                  /* CUESHEET */
        GST_INFO_OBJECT (flacparse, "CUESHEET header");
        hdr_ok = gst_flac_parse_handle_cuesheet (flacparse, sbuffer);
        break;
      case 6:                  /* PICTURE */
        GST_INFO_OBJECT (flacparse, "PICTURE header");
        hdr_ok = gst_flac_parse_handle_picture (flacparse, sbuffer);
        break;
      case 1:                  /* PADDING */
        GST_INFO_OBJECT (flacparse, "PADDING header");
        break;
      case 2:                  /* APPLICATION */
        GST_INFO_OBJECT (flacparse, "APPLICATION header");
        break;
      default:                 /* RESERVED */
        GST_INFO_OBJECT (flacparse, "unhandled header of type %u", type);
        break;
    }

    if (hdr_ok) {
      GST_BUFFER_TIMESTAMP (sbuffer) = GST_CLOCK_TIME_NONE;
      GST_BUFFER_DURATION (sbuffer) = GST_CLOCK_TIME_NONE;
      GST_BUFFER_OFFSET (sbuffer) = 0;
      GST_BUFFER_OFFSET_END (sbuffer) = 0;

      flacparse->headers = g_list_append (flacparse->headers, sbuffer);
    } else {
      GST_WARNING_OBJECT (parse, "failed to parse header of type %u", type);
      GST_MEMDUMP_OBJECT (parse, "bad header data", map.data, size);

      gst_buffer_unref (sbuffer);

      /* error out unless we have a STREAMINFO header */
      if (flacparse->samplerate == 0 || flacparse->bps == 0)
        goto header_parsing_error;

      /* .. in which case just stop header parsing and try to find audio */
      is_last = TRUE;
    }

    if (is_last) {
      res = gst_flac_parse_handle_headers (flacparse);

      /* Minimal size of a frame header */
      gst_base_parse_set_min_frame_size (GST_BASE_PARSE (flacparse), MAX (9,
              flacparse->min_framesize));
      flacparse->state = GST_FLAC_PARSE_STATE_DATA;

      if (res != GST_FLOW_OK)
        goto cleanup;
    }

    /* DROPPED because we pushed already or will push all headers manually */
    res = GST_BASE_PARSE_FLOW_DROPPED;
  } else {
    if (flacparse->offset != GST_BUFFER_OFFSET (buffer)) {
      FrameHeaderCheckReturn ret;

      flacparse->offset = GST_BUFFER_OFFSET (buffer);
      ret =
          gst_flac_parse_frame_header_is_valid (flacparse,
          map.data, map.size, TRUE, NULL, NULL);
      if (ret != FRAME_HEADER_VALID) {
        GST_ERROR_OBJECT (flacparse,
            "Baseclass didn't provide a complete frame");
        goto cleanup;
      }
    }

    if (flacparse->block_size == 0) {
      GST_ERROR_OBJECT (flacparse, "Unparsed frame");
      goto cleanup;
    }

    if (flacparse->seektable)
      gst_flac_parse_process_seektable (flacparse, GST_BUFFER_OFFSET (buffer));

    if (flacparse->state == GST_FLAC_PARSE_STATE_GENERATE_HEADERS) {
      if (flacparse->blocking_strategy == 1) {
        GST_WARNING_OBJECT (flacparse,
            "Generating headers for variable blocksize streams not supported");

        res = gst_flac_parse_handle_headers (flacparse);
      } else {
        GST_DEBUG_OBJECT (flacparse, "Generating headers");

        if (!gst_flac_parse_generate_headers (flacparse))
          goto cleanup;

        res = gst_flac_parse_handle_headers (flacparse);
      }
      flacparse->state = GST_FLAC_PARSE_STATE_DATA;
      if (res != GST_FLOW_OK)
        goto cleanup;
    }

    /* also cater for oggmux metadata */
    if (flacparse->blocking_strategy == 0) {
      GST_BUFFER_TIMESTAMP (buffer) =
          gst_util_uint64_scale (flacparse->sample_number,
          flacparse->block_size * GST_SECOND, flacparse->samplerate);
      GST_BUFFER_OFFSET_END (buffer) =
          flacparse->sample_number * flacparse->block_size +
          flacparse->block_size;
    } else {
      GST_BUFFER_TIMESTAMP (buffer) =
          gst_util_uint64_scale (flacparse->sample_number, GST_SECOND,
          flacparse->samplerate);
      GST_BUFFER_OFFSET_END (buffer) =
          flacparse->sample_number + flacparse->block_size;
    }
    GST_BUFFER_OFFSET (buffer) =
        gst_util_uint64_scale (GST_BUFFER_OFFSET_END (buffer), GST_SECOND,
        flacparse->samplerate);
    GST_BUFFER_DURATION (buffer) =
        GST_BUFFER_OFFSET (buffer) - GST_BUFFER_TIMESTAMP (buffer);

    /* To simplify, we just assume that it's a fixed size header and ignore
     * subframe headers. The first could lead us to being off by 88 bits and
     * the second even less, so the total inaccuracy is negligible. */
    frame->overhead = 7;

    /* Minimal size of a frame header */
    gst_base_parse_set_min_frame_size (GST_BASE_PARSE (flacparse), MAX (9,
            flacparse->min_framesize));

    flacparse->offset = -1;
    flacparse->blocking_strategy = 0;
    flacparse->sample_number = 0;
    res = GST_FLOW_OK;
  }

cleanup:
  gst_buffer_unmap (buffer, &map);

  return res;

/* ERRORS */
header_parsing_error:
  {
    GST_ELEMENT_ERROR (flacparse, STREAM, DECODE, (NULL),
        ("Failed to parse headers"));
    goto cleanup;
  }
}

static GstFlowReturn
gst_flac_parse_pre_push_frame (GstBaseParse * parse, GstBaseParseFrame * frame)
{
  GstFlacParse *flacparse = GST_FLAC_PARSE (parse);

  if (!flacparse->sent_codec_tag) {
    GstTagList *taglist;
    GstCaps *caps;

    taglist = gst_tag_list_new_empty ();

    /* codec tag */
    caps = gst_pad_get_current_caps (GST_BASE_PARSE_SRC_PAD (parse));
    gst_pb_utils_add_codec_description_to_tag_list (taglist,
        GST_TAG_AUDIO_CODEC, caps);
    gst_caps_unref (caps);

    gst_pad_push_event (GST_BASE_PARSE_SRC_PAD (flacparse),
        gst_event_new_tag (taglist));

    /* also signals the end of first-frame processing */
    flacparse->sent_codec_tag = TRUE;
  }

  /* Push tags */
  if (flacparse->tags) {
    gst_pad_push_event (GST_BASE_PARSE_SRC_PAD (flacparse),
        gst_event_new_tag (flacparse->tags));
    flacparse->tags = NULL;
  }
  /* Push toc */
  if (flacparse->toc) {
    gst_pad_push_event (GST_BASE_PARSE_SRC_PAD (flacparse),
        gst_event_new_toc (flacparse->toc, FALSE));
  }

  frame->flags |= GST_BASE_PARSE_FRAME_FLAG_CLIP;

  return GST_FLOW_OK;
}

static gboolean
gst_flac_parse_convert (GstBaseParse * parse,
    GstFormat src_format, gint64 src_value, GstFormat dest_format,
    gint64 * dest_value)
{
  GstFlacParse *flacparse = GST_FLAC_PARSE (parse);

  if (flacparse->samplerate > 0) {
    if (src_format == GST_FORMAT_DEFAULT && dest_format == GST_FORMAT_TIME) {
      if (src_value != -1)
        *dest_value =
            gst_util_uint64_scale (src_value, GST_SECOND,
            flacparse->samplerate);
      else
        *dest_value = -1;
      return TRUE;
    } else if (src_format == GST_FORMAT_TIME &&
        dest_format == GST_FORMAT_DEFAULT) {
      if (src_value != -1)
        *dest_value =
            gst_util_uint64_scale (src_value, flacparse->samplerate,
            GST_SECOND);
      else
        *dest_value = -1;
      return TRUE;
    }
  }

  return GST_BASE_PARSE_CLASS (parent_class)->convert (parse, src_format,
      src_value, dest_format, dest_value);
}

static gboolean
gst_flac_parse_src_event (GstBaseParse * parse, GstEvent * event)
{
  GstFlacParse *flacparse = GST_FLAC_PARSE (parse);
  gboolean res = FALSE;

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_TOC_SELECT:
    {
      GstTocEntry *entry = NULL;
      GstEvent *seek_event;
      GstToc *toc = NULL;
      gint64 start_pos;
      gchar *uid = NULL;

      /* FIXME: some locking would be good */
      if (flacparse->toc)
        toc = gst_toc_ref (flacparse->toc);

      if (toc != NULL) {
        gst_event_parse_toc_select (event, &uid);
        if (uid != NULL) {
          entry = gst_toc_find_entry (toc, uid);
          if (entry != NULL) {
            gst_toc_entry_get_start_stop_times (entry, &start_pos, NULL);

            /* FIXME: use segment rate here instead? */
            seek_event = gst_event_new_seek (1.0,
                GST_FORMAT_TIME,
                GST_SEEK_FLAG_FLUSH,
                GST_SEEK_TYPE_SET, start_pos, GST_SEEK_TYPE_NONE, -1);

            res =
                GST_BASE_PARSE_CLASS (parent_class)->src_event (parse,
                seek_event);

            g_free (uid);
          } else {
            GST_WARNING_OBJECT (parse, "no TOC entry with given UID: %s", uid);
          }
        }
        gst_toc_unref (toc);
      } else {
        GST_DEBUG_OBJECT (flacparse, "no TOC to select");
      }
      gst_event_unref (event);
      break;
    }
    default:
      res = GST_BASE_PARSE_CLASS (parent_class)->src_event (parse, event);
      break;
  }
  return res;
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
gst_flac_parse_get_sink_caps (GstBaseParse * parse, GstCaps * filter)
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
