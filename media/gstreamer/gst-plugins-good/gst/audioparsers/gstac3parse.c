/* GStreamer AC3 parser
 * Copyright (C) 2009 Tim-Philipp Müller <tim centricular net>
 * Copyright (C) 2009 Mark Nauwelaerts <mnauw users sf net>
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
 * SECTION:element-ac3parse
 * @short_description: AC3 parser
 * @see_also: #GstAmrParse, #GstAACParse
 *
 * This is an AC3 parser.
 *
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * gst-launch-1.0 filesrc location=abc.ac3 ! ac3parse ! a52dec ! audioresample ! audioconvert ! autoaudiosink
 * ]|
 * </refsect2>
 */

/* TODO:
 *  - audio/ac3 to audio/x-private1-ac3 is not implemented (done in the muxer)
 *  - should accept framed and unframed input (needs decodebin fixes first)
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <string.h>

#include "gstac3parse.h"
#include <gst/base/base.h>
#include <gst/pbutils/pbutils.h>

GST_DEBUG_CATEGORY_STATIC (ac3_parse_debug);
#define GST_CAT_DEFAULT ac3_parse_debug

static const struct
{
  const guint bit_rate;         /* nominal bit rate */
  const guint frame_size[3];    /* frame size for 32kHz, 44kHz, and 48kHz */
} frmsizcod_table[38] = {
  {
    32, {
  64, 69, 96}}, {
    32, {
  64, 70, 96}}, {
    40, {
  80, 87, 120}}, {
    40, {
  80, 88, 120}}, {
    48, {
  96, 104, 144}}, {
    48, {
  96, 105, 144}}, {
    56, {
  112, 121, 168}}, {
    56, {
  112, 122, 168}}, {
    64, {
  128, 139, 192}}, {
    64, {
  128, 140, 192}}, {
    80, {
  160, 174, 240}}, {
    80, {
  160, 175, 240}}, {
    96, {
  192, 208, 288}}, {
    96, {
  192, 209, 288}}, {
    112, {
  224, 243, 336}}, {
    112, {
  224, 244, 336}}, {
    128, {
  256, 278, 384}}, {
    128, {
  256, 279, 384}}, {
    160, {
  320, 348, 480}}, {
    160, {
  320, 349, 480}}, {
    192, {
  384, 417, 576}}, {
    192, {
  384, 418, 576}}, {
    224, {
  448, 487, 672}}, {
    224, {
  448, 488, 672}}, {
    256, {
  512, 557, 768}}, {
    256, {
  512, 558, 768}}, {
    320, {
  640, 696, 960}}, {
    320, {
  640, 697, 960}}, {
    384, {
  768, 835, 1152}}, {
    384, {
  768, 836, 1152}}, {
    448, {
  896, 975, 1344}}, {
    448, {
  896, 976, 1344}}, {
    512, {
  1024, 1114, 1536}}, {
    512, {
  1024, 1115, 1536}}, {
    576, {
  1152, 1253, 1728}}, {
    576, {
  1152, 1254, 1728}}, {
    640, {
  1280, 1393, 1920}}, {
    640, {
  1280, 1394, 1920}}
};

static const guint fscod_rates[4] = { 48000, 44100, 32000, 0 };
static const guint acmod_chans[8] = { 2, 1, 2, 3, 3, 4, 4, 5 };
static const guint numblks[4] = { 1, 2, 3, 6 };

static GstStaticPadTemplate src_template = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("audio/x-ac3, framed = (boolean) true, "
        " channels = (int) [ 1, 6 ], rate = (int) [ 8000, 48000 ], "
        " alignment = (string) { iec61937, frame}; "
        "audio/x-eac3, framed = (boolean) true, "
        " channels = (int) [ 1, 6 ], rate = (int) [ 8000, 48000 ], "
        " alignment = (string) { iec61937, frame}; "));

static GstStaticPadTemplate sink_template = GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("audio/x-ac3; " "audio/x-eac3; " "audio/ac3; "
        "audio/x-private1-ac3"));

static void gst_ac3_parse_finalize (GObject * object);

static gboolean gst_ac3_parse_start (GstBaseParse * parse);
static gboolean gst_ac3_parse_stop (GstBaseParse * parse);
static GstFlowReturn gst_ac3_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize);
static GstFlowReturn gst_ac3_parse_pre_push_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame);
static gboolean gst_ac3_parse_src_event (GstBaseParse * parse,
    GstEvent * event);
static GstCaps *gst_ac3_parse_get_sink_caps (GstBaseParse * parse,
    GstCaps * filter);
static gboolean gst_ac3_parse_set_sink_caps (GstBaseParse * parse,
    GstCaps * caps);

#define gst_ac3_parse_parent_class parent_class
G_DEFINE_TYPE (GstAc3Parse, gst_ac3_parse, GST_TYPE_BASE_PARSE);

static void
gst_ac3_parse_class_init (GstAc3ParseClass * klass)
{
  GObjectClass *object_class = G_OBJECT_CLASS (klass);
  GstElementClass *element_class = GST_ELEMENT_CLASS (klass);
  GstBaseParseClass *parse_class = GST_BASE_PARSE_CLASS (klass);

  GST_DEBUG_CATEGORY_INIT (ac3_parse_debug, "ac3parse", 0,
      "AC3 audio stream parser");

  object_class->finalize = gst_ac3_parse_finalize;

  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&sink_template));
  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&src_template));

  gst_element_class_set_static_metadata (element_class,
      "AC3 audio stream parser", "Codec/Parser/Converter/Audio",
      "AC3 parser", "Tim-Philipp Müller <tim centricular net>");

  parse_class->start = GST_DEBUG_FUNCPTR (gst_ac3_parse_start);
  parse_class->stop = GST_DEBUG_FUNCPTR (gst_ac3_parse_stop);
  parse_class->handle_frame = GST_DEBUG_FUNCPTR (gst_ac3_parse_handle_frame);
  parse_class->pre_push_frame =
      GST_DEBUG_FUNCPTR (gst_ac3_parse_pre_push_frame);
  parse_class->src_event = GST_DEBUG_FUNCPTR (gst_ac3_parse_src_event);
  parse_class->get_sink_caps = GST_DEBUG_FUNCPTR (gst_ac3_parse_get_sink_caps);
  parse_class->set_sink_caps = GST_DEBUG_FUNCPTR (gst_ac3_parse_set_sink_caps);
}

static void
gst_ac3_parse_reset (GstAc3Parse * ac3parse)
{
  ac3parse->channels = -1;
  ac3parse->sample_rate = -1;
  ac3parse->blocks = -1;
  ac3parse->eac = FALSE;
  ac3parse->sent_codec_tag = FALSE;
  g_atomic_int_set (&ac3parse->align, GST_AC3_PARSE_ALIGN_NONE);
}

static void
gst_ac3_parse_init (GstAc3Parse * ac3parse)
{
  gst_base_parse_set_min_frame_size (GST_BASE_PARSE (ac3parse), 6);
  gst_ac3_parse_reset (ac3parse);
  ac3parse->baseparse_chainfunc =
      GST_BASE_PARSE_SINK_PAD (GST_BASE_PARSE (ac3parse))->chainfunc;
  GST_PAD_SET_ACCEPT_INTERSECT (GST_BASE_PARSE_SINK_PAD (ac3parse));
}

static void
gst_ac3_parse_finalize (GObject * object)
{
  G_OBJECT_CLASS (parent_class)->finalize (object);
}

static gboolean
gst_ac3_parse_start (GstBaseParse * parse)
{
  GstAc3Parse *ac3parse = GST_AC3_PARSE (parse);

  GST_DEBUG_OBJECT (parse, "starting");

  gst_ac3_parse_reset (ac3parse);

  return TRUE;
}

static gboolean
gst_ac3_parse_stop (GstBaseParse * parse)
{
  GST_DEBUG_OBJECT (parse, "stopping");

  return TRUE;
}

static void
gst_ac3_parse_set_alignment (GstAc3Parse * ac3parse, gboolean eac)
{
  GstCaps *caps;
  GstStructure *st;
  const gchar *str = NULL;
  int i;

  if (G_LIKELY (!eac))
    goto done;

  caps = gst_pad_get_allowed_caps (GST_BASE_PARSE_SRC_PAD (ac3parse));

  if (!caps)
    goto done;

  for (i = 0; i < gst_caps_get_size (caps); i++) {
    st = gst_caps_get_structure (caps, i);

    if (!g_str_equal (gst_structure_get_name (st), "audio/x-eac3"))
      continue;

    if ((str = gst_structure_get_string (st, "alignment"))) {
      if (g_str_equal (str, "iec61937")) {
        g_atomic_int_set (&ac3parse->align, GST_AC3_PARSE_ALIGN_IEC61937);
        GST_DEBUG_OBJECT (ac3parse, "picked iec61937 alignment");
      } else if (g_str_equal (str, "frame") == 0) {
        g_atomic_int_set (&ac3parse->align, GST_AC3_PARSE_ALIGN_FRAME);
        GST_DEBUG_OBJECT (ac3parse, "picked frame alignment");
      } else {
        g_atomic_int_set (&ac3parse->align, GST_AC3_PARSE_ALIGN_FRAME);
        GST_WARNING_OBJECT (ac3parse, "unknown alignment: %s", str);
      }
      break;
    }
  }

  if (caps)
    gst_caps_unref (caps);

done:
  /* default */
  if (ac3parse->align == GST_AC3_PARSE_ALIGN_NONE) {
    g_atomic_int_set (&ac3parse->align, GST_AC3_PARSE_ALIGN_FRAME);
    GST_DEBUG_OBJECT (ac3parse, "picked syncframe alignment");
  }
}

static gboolean
gst_ac3_parse_frame_header_ac3 (GstAc3Parse * ac3parse, GstBuffer * buf,
    gint skip, guint * frame_size, guint * rate, guint * chans, guint * blks,
    guint * sid)
{
  GstBitReader bits;
  GstMapInfo map;
  guint8 fscod, frmsizcod, bsid, acmod, lfe_on, rate_scale;
  gboolean ret = FALSE;

  GST_LOG_OBJECT (ac3parse, "parsing ac3");

  gst_buffer_map (buf, &map, GST_MAP_READ);
  gst_bit_reader_init (&bits, map.data, map.size);
  gst_bit_reader_skip_unchecked (&bits, skip * 8);

  gst_bit_reader_skip_unchecked (&bits, 16 + 16);
  fscod = gst_bit_reader_get_bits_uint8_unchecked (&bits, 2);
  frmsizcod = gst_bit_reader_get_bits_uint8_unchecked (&bits, 6);

  if (G_UNLIKELY (fscod == 3 || frmsizcod >= G_N_ELEMENTS (frmsizcod_table))) {
    GST_DEBUG_OBJECT (ac3parse, "bad fscod=%d frmsizcod=%d", fscod, frmsizcod);
    goto cleanup;
  }

  bsid = gst_bit_reader_get_bits_uint8_unchecked (&bits, 5);
  gst_bit_reader_skip_unchecked (&bits, 3);     /* bsmod */
  acmod = gst_bit_reader_get_bits_uint8_unchecked (&bits, 3);

  /* spec not quite clear here: decoder should decode if less than 8,
   * but seemingly only defines 6 and 8 cases */
  /* Files with 9 and 10 happen, and seem to comply with the <= 8
     format, so let them through. The spec says nothing about 9 and 10 */
  if (bsid > 10) {
    GST_DEBUG_OBJECT (ac3parse, "unexpected bsid=%d", bsid);
    goto cleanup;
  } else if (bsid != 8 && bsid != 6) {
    GST_DEBUG_OBJECT (ac3parse, "undefined bsid=%d", bsid);
  }

  if ((acmod & 0x1) && (acmod != 0x1))  /* 3 front channels */
    gst_bit_reader_skip_unchecked (&bits, 2);
  if ((acmod & 0x4))            /* if a surround channel exists */
    gst_bit_reader_skip_unchecked (&bits, 2);
  if (acmod == 0x2)             /* if in 2/0 mode */
    gst_bit_reader_skip_unchecked (&bits, 2);

  lfe_on = gst_bit_reader_get_bits_uint8_unchecked (&bits, 1);

  /* 6/8->0, 9->1, 10->2,
     see http://matroska.org/technical/specs/codecid/index.html */
  rate_scale = (CLAMP (bsid, 8, 10) - 8);

  if (frame_size)
    *frame_size = frmsizcod_table[frmsizcod].frame_size[fscod] * 2;
  if (rate)
    *rate = fscod_rates[fscod] >> rate_scale;
  if (chans)
    *chans = acmod_chans[acmod] + lfe_on;
  if (blks)
    *blks = 6;
  if (sid)
    *sid = 0;

  ret = TRUE;

cleanup:
  gst_buffer_unmap (buf, &map);

  return ret;
}

static gboolean
gst_ac3_parse_frame_header_eac3 (GstAc3Parse * ac3parse, GstBuffer * buf,
    gint skip, guint * frame_size, guint * rate, guint * chans, guint * blks,
    guint * sid)
{
  GstBitReader bits;
  GstMapInfo map;
  guint16 frmsiz, sample_rate, blocks;
  guint8 strmtyp, fscod, fscod2, acmod, lfe_on, strmid, numblkscod;
  gboolean ret = FALSE;

  GST_LOG_OBJECT (ac3parse, "parsing e-ac3");

  gst_buffer_map (buf, &map, GST_MAP_READ);
  gst_bit_reader_init (&bits, map.data, map.size);
  gst_bit_reader_skip_unchecked (&bits, skip * 8);

  gst_bit_reader_skip_unchecked (&bits, 16);
  strmtyp = gst_bit_reader_get_bits_uint8_unchecked (&bits, 2); /* strmtyp     */
  if (G_UNLIKELY (strmtyp == 3)) {
    GST_DEBUG_OBJECT (ac3parse, "bad strmtyp %d", strmtyp);
    goto cleanup;
  }

  strmid = gst_bit_reader_get_bits_uint8_unchecked (&bits, 3);  /* substreamid */
  frmsiz = gst_bit_reader_get_bits_uint16_unchecked (&bits, 11);        /* frmsiz      */
  fscod = gst_bit_reader_get_bits_uint8_unchecked (&bits, 2);   /* fscod       */
  if (fscod == 3) {
    fscod2 = gst_bit_reader_get_bits_uint8_unchecked (&bits, 2);        /* fscod2      */
    if (G_UNLIKELY (fscod2 == 3)) {
      GST_DEBUG_OBJECT (ac3parse, "invalid fscod2");
      goto cleanup;
    }
    sample_rate = fscod_rates[fscod2] / 2;
    blocks = 6;
  } else {
    numblkscod = gst_bit_reader_get_bits_uint8_unchecked (&bits, 2);    /* numblkscod  */
    sample_rate = fscod_rates[fscod];
    blocks = numblks[numblkscod];
  }

  acmod = gst_bit_reader_get_bits_uint8_unchecked (&bits, 3);   /* acmod       */
  lfe_on = gst_bit_reader_get_bits_uint8_unchecked (&bits, 1);  /* lfeon       */

  gst_bit_reader_skip_unchecked (&bits, 5);     /* bsid        */

  if (frame_size)
    *frame_size = (frmsiz + 1) * 2;
  if (rate)
    *rate = sample_rate;
  if (chans)
    *chans = acmod_chans[acmod] + lfe_on;
  if (blks)
    *blks = blocks;
  if (sid)
    *sid = (strmtyp & 0x1) << 3 | strmid;

  ret = TRUE;

cleanup:
  gst_buffer_unmap (buf, &map);

  return ret;
}

static gboolean
gst_ac3_parse_frame_header (GstAc3Parse * parse, GstBuffer * buf, gint skip,
    guint * framesize, guint * rate, guint * chans, guint * blocks,
    guint * sid, gboolean * eac)
{
  GstBitReader bits;
  guint16 sync;
  guint8 bsid;
  GstMapInfo map;
  gboolean ret = FALSE;

  gst_buffer_map (buf, &map, GST_MAP_READ);
  gst_bit_reader_init (&bits, map.data, map.size);

  GST_MEMDUMP_OBJECT (parse, "AC3 frame sync", map.data, MIN (map.size, 16));

  gst_bit_reader_skip_unchecked (&bits, skip * 8);

  sync = gst_bit_reader_get_bits_uint16_unchecked (&bits, 16);
  gst_bit_reader_skip_unchecked (&bits, 16 + 8);
  bsid = gst_bit_reader_peek_bits_uint8_unchecked (&bits, 5);

  if (G_UNLIKELY (sync != 0x0b77))
    goto cleanup;

  GST_LOG_OBJECT (parse, "bsid = %d", bsid);

  if (bsid <= 10) {
    if (eac)
      *eac = FALSE;
    ret = gst_ac3_parse_frame_header_ac3 (parse, buf, skip, framesize, rate,
        chans, blocks, sid);
    goto cleanup;
  } else if (bsid <= 16) {
    if (eac)
      *eac = TRUE;
    ret = gst_ac3_parse_frame_header_eac3 (parse, buf, skip, framesize, rate,
        chans, blocks, sid);
    goto cleanup;
  } else {
    GST_DEBUG_OBJECT (parse, "unexpected bsid %d", bsid);
    return FALSE;
  }

  GST_DEBUG_OBJECT (parse, "unexpected bsid %d", bsid);

cleanup:
  gst_buffer_unmap (buf, &map);

  return ret;
}

static GstFlowReturn
gst_ac3_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize)
{
  GstAc3Parse *ac3parse = GST_AC3_PARSE (parse);
  GstBuffer *buf = frame->buffer;
  GstByteReader reader;
  gint off;
  gboolean lost_sync, draining, eac, more = FALSE;
  guint frmsiz, blocks, sid;
  guint rate, chans;
  gboolean update_rate = FALSE;
  gint framesize = 0;
  gint have_blocks = 0;
  GstMapInfo map;
  gboolean ret = FALSE;
  GstFlowReturn res = GST_FLOW_OK;

  gst_buffer_map (buf, &map, GST_MAP_READ);

  if (G_UNLIKELY (map.size < 6)) {
    *skipsize = 1;
    goto cleanup;
  }

  gst_byte_reader_init (&reader, map.data, map.size);
  off = gst_byte_reader_masked_scan_uint32 (&reader, 0xffff0000, 0x0b770000,
      0, map.size);

  GST_LOG_OBJECT (parse, "possible sync at buffer offset %d", off);

  /* didn't find anything that looks like a sync word, skip */
  if (off < 0) {
    *skipsize = map.size - 3;
    goto cleanup;
  }

  /* possible frame header, but not at offset 0? skip bytes before sync */
  if (off > 0) {
    *skipsize = off;
    goto cleanup;
  }

  /* make sure the values in the frame header look sane */
  if (!gst_ac3_parse_frame_header (ac3parse, buf, 0, &frmsiz, &rate, &chans,
          &blocks, &sid, &eac)) {
    *skipsize = off + 2;
    goto cleanup;
  }

  GST_LOG_OBJECT (parse, "size: %u, blocks: %u, rate: %u, chans: %u", frmsiz,
      blocks, rate, chans);

  framesize = frmsiz;

  if (G_UNLIKELY (g_atomic_int_get (&ac3parse->align) ==
          GST_AC3_PARSE_ALIGN_NONE))
    gst_ac3_parse_set_alignment (ac3parse, eac);

  GST_LOG_OBJECT (parse, "got frame");

  lost_sync = GST_BASE_PARSE_LOST_SYNC (parse);
  draining = GST_BASE_PARSE_DRAINING (parse);

  if (g_atomic_int_get (&ac3parse->align) == GST_AC3_PARSE_ALIGN_IEC61937) {
    /* We need 6 audio blocks from each substream, so we keep going forwards
     * till we have it */

    g_assert (blocks > 0);
    GST_LOG_OBJECT (ac3parse, "Need %d frames before pushing", 6 / blocks);

    if (sid != 0) {
      /* We need the first substream to be the one with id 0 */
      GST_LOG_OBJECT (ac3parse, "Skipping till we find sid 0");
      *skipsize = off + 2;
      goto cleanup;
    }

    framesize = 0;

    /* Loop till we have 6 blocks per substream */
    for (have_blocks = 0; !more && have_blocks < 6; have_blocks += blocks) {
      /* Loop till we get one frame from each substream */
      do {
        framesize += frmsiz;

        if (!gst_byte_reader_skip (&reader, frmsiz)
            || map.size < (framesize + 6)) {
          more = TRUE;
          break;
        }

        if (!gst_ac3_parse_frame_header (ac3parse, buf, framesize, &frmsiz,
                NULL, NULL, NULL, &sid, &eac)) {
          *skipsize = off + 2;
          goto cleanup;
        }
      } while (sid);
    }

    /* We're now at the next frame, so no need to skip if resyncing */
    frmsiz = 0;
  }

  if (lost_sync && !draining) {
    guint16 word = 0;

    GST_DEBUG_OBJECT (ac3parse, "resyncing; checking next frame syncword");

    if (more || !gst_byte_reader_skip (&reader, frmsiz) ||
        !gst_byte_reader_get_uint16_be (&reader, &word)) {
      GST_DEBUG_OBJECT (ac3parse, "... but not sufficient data");
      gst_base_parse_set_min_frame_size (parse, framesize + 6);
      *skipsize = 0;
      goto cleanup;
    } else {
      if (word != 0x0b77) {
        GST_DEBUG_OBJECT (ac3parse, "0x%x not OK", word);
        *skipsize = off + 2;
        goto cleanup;
      } else {
        /* ok, got sync now, let's assume constant frame size */
        gst_base_parse_set_min_frame_size (parse, framesize);
      }
    }
  }

  /* expect to have found a frame here */
  g_assert (framesize);
  ret = TRUE;

  /* arrange for metadata setup */
  if (G_UNLIKELY (sid)) {
    /* dependent frame, no need to (ac)count for or consider further */
    GST_LOG_OBJECT (parse, "sid: %d", sid);
    frame->flags |= GST_BASE_PARSE_FRAME_FLAG_NO_FRAME;
    /* TODO maybe also mark as DELTA_UNIT,
     * if that does not surprise baseparse elsewhere */
    /* occupies same time space as previous base frame */
    if (G_LIKELY (GST_BUFFER_TIMESTAMP (buf) >= GST_BUFFER_DURATION (buf)))
      GST_BUFFER_TIMESTAMP (buf) -= GST_BUFFER_DURATION (buf);
    /* only shortcut if we already arranged for caps */
    if (G_LIKELY (ac3parse->sample_rate > 0))
      goto cleanup;
  }

  if (G_UNLIKELY (ac3parse->sample_rate != rate || ac3parse->channels != chans
          || ac3parse->eac != eac)) {
    GstCaps *caps = gst_caps_new_simple (eac ? "audio/x-eac3" : "audio/x-ac3",
        "framed", G_TYPE_BOOLEAN, TRUE, "rate", G_TYPE_INT, rate,
        "channels", G_TYPE_INT, chans, NULL);
    gst_caps_set_simple (caps, "alignment", G_TYPE_STRING,
        g_atomic_int_get (&ac3parse->align) == GST_AC3_PARSE_ALIGN_IEC61937 ?
        "iec61937" : "frame", NULL);
    gst_pad_set_caps (GST_BASE_PARSE_SRC_PAD (parse), caps);
    gst_caps_unref (caps);

    ac3parse->sample_rate = rate;
    ac3parse->channels = chans;
    ac3parse->eac = eac;

    update_rate = TRUE;
  }

  if (G_UNLIKELY (ac3parse->blocks != blocks)) {
    ac3parse->blocks = blocks;

    update_rate = TRUE;
  }

  if (G_UNLIKELY (update_rate))
    gst_base_parse_set_frame_rate (parse, rate, 256 * blocks, 2, 2);

cleanup:
  gst_buffer_unmap (buf, &map);

  if (ret && framesize <= map.size) {
    res = gst_base_parse_finish_frame (parse, frame, framesize);
  }

  return res;
}


/*
 * MPEG-PS private1 streams add a 2 bytes "Audio Substream Headers" for each
 * buffer (not each frame) with the offset of the next frame's start.
 *
 * Buffer 1:
 * -------------------------------------------
 * |firstAccUnit|AC3SyncWord|xxxxxxxxxxxxxxxxx
 * -------------------------------------------
 * Buffer 2:
 * -------------------------------------------
 * |firstAccUnit|xxxxxx|AC3SyncWord|xxxxxxxxxx
 * -------------------------------------------
 *
 * These 2 bytes can be dropped safely as they do not include any timing
 * information, only the offset to the start of the next frame.
 *
 * From http://stnsoft.com/DVD/ass-hdr.html:
 * "FirstAccUnit offset to frame which corresponds to PTS value offset 0 is the
 * last byte of FirstAccUnit, ie add the offset of byte 2 to get the AU's offset
 * The value 0000 indicates there is no first access unit"
 * */

static GstFlowReturn
gst_ac3_parse_chain_priv (GstPad * pad, GstObject * parent, GstBuffer * buf)
{
  GstAc3Parse *ac3parse = GST_AC3_PARSE (parent);
  GstFlowReturn ret;
  gsize size;
  guint8 data[2];
  gint offset;
  gint len;
  GstBuffer *subbuf;
  gint first_access;

  size = gst_buffer_get_size (buf);
  if (size < 2)
    goto not_enough_data;

  gst_buffer_extract (buf, 0, data, 2);
  first_access = (data[0] << 8) | data[1];

  /* Skip the first_access header */
  offset = 2;

  if (first_access > 1) {
    /* Length of data before first_access */
    len = first_access - 1;

    if (len <= 0 || offset + len > size)
      goto bad_first_access_parameter;

    subbuf = gst_buffer_copy_region (buf, GST_BUFFER_COPY_ALL, offset, len);
    GST_BUFFER_DTS (subbuf) = GST_CLOCK_TIME_NONE;
    GST_BUFFER_PTS (subbuf) = GST_CLOCK_TIME_NONE;
    ret = ac3parse->baseparse_chainfunc (pad, parent, subbuf);
    if (ret != GST_FLOW_OK) {
      gst_buffer_unref (buf);
      goto done;
    }

    offset += len;
    len = size - offset;

    if (len > 0) {
      subbuf = gst_buffer_copy_region (buf, GST_BUFFER_COPY_ALL, offset, len);
      GST_BUFFER_PTS (subbuf) = GST_BUFFER_PTS (buf);
      GST_BUFFER_DTS (subbuf) = GST_BUFFER_DTS (buf);

      ret = ac3parse->baseparse_chainfunc (pad, parent, subbuf);
    }
    gst_buffer_unref (buf);
  } else {
    /* first_access = 0 or 1, so if there's a timestamp it applies to the first byte */
    subbuf =
        gst_buffer_copy_region (buf, GST_BUFFER_COPY_ALL, offset,
        size - offset);
    GST_BUFFER_PTS (subbuf) = GST_BUFFER_PTS (buf);
    GST_BUFFER_DTS (subbuf) = GST_BUFFER_DTS (buf);
    gst_buffer_unref (buf);
    ret = ac3parse->baseparse_chainfunc (pad, parent, subbuf);
  }

done:
  return ret;

/* ERRORS */
not_enough_data:
  {
    GST_ELEMENT_ERROR (GST_ELEMENT (ac3parse), STREAM, FORMAT, (NULL),
        ("Insufficient data in buffer. Can't determine first_acess"));
    gst_buffer_unref (buf);
    return GST_FLOW_ERROR;
  }
bad_first_access_parameter:
  {
    GST_ELEMENT_ERROR (GST_ELEMENT (ac3parse), STREAM, FORMAT, (NULL),
        ("Bad first_access parameter (%d) in buffer", first_access));
    gst_buffer_unref (buf);
    return GST_FLOW_ERROR;
  }
}

static GstFlowReturn
gst_ac3_parse_pre_push_frame (GstBaseParse * parse, GstBaseParseFrame * frame)
{
  GstAc3Parse *ac3parse = GST_AC3_PARSE (parse);

  if (!ac3parse->sent_codec_tag) {
    GstTagList *taglist;
    GstCaps *caps;

    taglist = gst_tag_list_new_empty ();

    /* codec tag */
    caps = gst_pad_get_current_caps (GST_BASE_PARSE_SRC_PAD (parse));
    gst_pb_utils_add_codec_description_to_tag_list (taglist,
        GST_TAG_AUDIO_CODEC, caps);
    gst_caps_unref (caps);

    gst_pad_push_event (GST_BASE_PARSE_SRC_PAD (ac3parse),
        gst_event_new_tag (taglist));

    /* also signals the end of first-frame processing */
    ac3parse->sent_codec_tag = TRUE;
  }

  return GST_FLOW_OK;
}

static gboolean
gst_ac3_parse_src_event (GstBaseParse * parse, GstEvent * event)
{
  GstAc3Parse *ac3parse = GST_AC3_PARSE (parse);

  if (G_UNLIKELY (GST_EVENT_TYPE (event) == GST_EVENT_CUSTOM_UPSTREAM) &&
      gst_event_has_name (event, "ac3parse-set-alignment")) {
    const GstStructure *st = gst_event_get_structure (event);
    const gchar *align = gst_structure_get_string (st, "alignment");

    if (g_str_equal (align, "iec61937")) {
      GST_DEBUG_OBJECT (ac3parse, "Switching to iec61937 alignment");
      g_atomic_int_set (&ac3parse->align, GST_AC3_PARSE_ALIGN_IEC61937);
    } else if (g_str_equal (align, "frame")) {
      GST_DEBUG_OBJECT (ac3parse, "Switching to frame alignment");
      g_atomic_int_set (&ac3parse->align, GST_AC3_PARSE_ALIGN_FRAME);
    } else {
      g_atomic_int_set (&ac3parse->align, GST_AC3_PARSE_ALIGN_FRAME);
      GST_WARNING_OBJECT (ac3parse, "Got unknown alignment request (%s) "
          "reverting to frame alignment.",
          gst_structure_get_string (st, "alignment"));
    }

    gst_event_unref (event);
    return TRUE;
  }

  return GST_BASE_PARSE_CLASS (parent_class)->src_event (parse, event);
}

static void
remove_fields (GstCaps * caps)
{
  guint i, n;

  n = gst_caps_get_size (caps);
  for (i = 0; i < n; i++) {
    GstStructure *s = gst_caps_get_structure (caps, i);

    gst_structure_remove_field (s, "framed");
    gst_structure_remove_field (s, "alignment");
  }
}

static GstCaps *
extend_caps (GstCaps * caps, gboolean add_private)
{
  guint i, n;
  GstCaps *ncaps = gst_caps_new_empty ();

  n = gst_caps_get_size (caps);
  for (i = 0; i < n; i++) {
    GstStructure *s = gst_caps_get_structure (caps, i);

    if (add_private && !gst_structure_has_name (s, "audio/x-private1-ac3")) {
      GstStructure *ns = gst_structure_copy (s);
      gst_structure_set_name (ns, "audio/x-private1-ac3");
      gst_caps_append_structure (ncaps, ns);
    } else if (!add_private &&
        gst_structure_has_name (s, "audio/x-private1-ac3")) {
      GstStructure *ns = gst_structure_copy (s);
      gst_structure_set_name (ns, "audio/x-ac3");
      gst_caps_append_structure (ncaps, ns);
      ns = gst_structure_copy (s);
      gst_structure_set_name (ns, "audio/x-eac3");
      gst_caps_append_structure (ncaps, ns);
    } else if (!add_private) {
      gst_caps_append_structure (ncaps, gst_structure_copy (s));
    }
  }

  if (add_private) {
    gst_caps_append (caps, ncaps);
  } else {
    gst_caps_unref (caps);
    caps = ncaps;
  }

  return caps;
}

static GstCaps *
gst_ac3_parse_get_sink_caps (GstBaseParse * parse, GstCaps * filter)
{
  GstCaps *peercaps, *templ;
  GstCaps *res;

  templ = gst_pad_get_pad_template_caps (GST_BASE_PARSE_SINK_PAD (parse));
  if (filter) {
    GstCaps *fcopy = gst_caps_copy (filter);
    /* Remove the fields we convert */
    remove_fields (fcopy);
    /* we do not ask downstream to handle x-private1-ac3 */
    fcopy = extend_caps (fcopy, FALSE);
    peercaps = gst_pad_peer_query_caps (GST_BASE_PARSE_SRC_PAD (parse), fcopy);
    gst_caps_unref (fcopy);
  } else
    peercaps = gst_pad_peer_query_caps (GST_BASE_PARSE_SRC_PAD (parse), NULL);

  if (peercaps) {
    /* Remove the framed and alignment field. We can convert
     * between different alignments. */
    peercaps = gst_caps_make_writable (peercaps);
    remove_fields (peercaps);
    /* also allow for x-private1-ac3 input */
    peercaps = extend_caps (peercaps, TRUE);

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
gst_ac3_parse_set_sink_caps (GstBaseParse * parse, GstCaps * caps)
{
  GstStructure *s;
  GstAc3Parse *ac3parse = GST_AC3_PARSE (parse);

  s = gst_caps_get_structure (caps, 0);
  if (gst_structure_has_name (s, "audio/x-private1-ac3")) {
    gst_pad_set_chain_function (parse->sinkpad, gst_ac3_parse_chain_priv);
  } else {
    gst_pad_set_chain_function (parse->sinkpad, ac3parse->baseparse_chainfunc);
  }
  return TRUE;
}
