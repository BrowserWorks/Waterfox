/* GStreamer Adaptive Multi-Rate parser plugin
 * Copyright (C) 2006 Edgard Lima <edgard.lima@indt.org.br>
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

/**
 * SECTION:element-amrparse
 * @short_description: AMR parser
 * @see_also: #GstAmrnbDec, #GstAmrnbEnc
 *
 * This is an AMR parser capable of handling both narrow-band and wideband
 * formats.
 *
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * gst-launch-1.0 filesrc location=abc.amr ! amrparse ! amrdec ! audioresample ! audioconvert ! alsasink
 * ]|
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <string.h>

#include "gstamrparse.h"
#include <gst/pbutils/pbutils.h>

static GstStaticPadTemplate src_template = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("audio/AMR, " "rate = (int) 8000, " "channels = (int) 1;"
        "audio/AMR-WB, " "rate = (int) 16000, " "channels = (int) 1;")
    );

static GstStaticPadTemplate sink_template = GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("audio/x-amr-nb-sh; audio/x-amr-wb-sh"));

GST_DEBUG_CATEGORY_STATIC (amrparse_debug);
#define GST_CAT_DEFAULT amrparse_debug

static const gint block_size_nb[16] =
    { 12, 13, 15, 17, 19, 20, 26, 31, 5, 0, 0, 0, 0, 0, 0, 0 };

static const gint block_size_wb[16] =
    { 17, 23, 32, 36, 40, 46, 50, 58, 60, 5, -1, -1, -1, -1, 0, 0 };

/* AMR has a "hardcoded" framerate of 50fps */
#define AMR_FRAMES_PER_SECOND 50
#define AMR_FRAME_DURATION (GST_SECOND/AMR_FRAMES_PER_SECOND)
#define AMR_MIME_HEADER_SIZE 9

static gboolean gst_amr_parse_start (GstBaseParse * parse);
static gboolean gst_amr_parse_stop (GstBaseParse * parse);

static gboolean gst_amr_parse_sink_setcaps (GstBaseParse * parse,
    GstCaps * caps);
static GstCaps *gst_amr_parse_sink_getcaps (GstBaseParse * parse,
    GstCaps * filter);

static GstFlowReturn gst_amr_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize);
static GstFlowReturn gst_amr_parse_pre_push_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame);

G_DEFINE_TYPE (GstAmrParse, gst_amr_parse, GST_TYPE_BASE_PARSE);

/**
 * gst_amr_parse_class_init:
 * @klass: GstAmrParseClass.
 *
 */
static void
gst_amr_parse_class_init (GstAmrParseClass * klass)
{
  GstElementClass *element_class = GST_ELEMENT_CLASS (klass);
  GstBaseParseClass *parse_class = GST_BASE_PARSE_CLASS (klass);

  GST_DEBUG_CATEGORY_INIT (amrparse_debug, "amrparse", 0,
      "AMR-NB audio stream parser");

  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&sink_template));
  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&src_template));

  gst_element_class_set_static_metadata (element_class,
      "AMR audio stream parser", "Codec/Parser/Audio",
      "Adaptive Multi-Rate audio parser",
      "Ronald Bultje <rbultje@ronald.bitfreak.net>");

  parse_class->start = GST_DEBUG_FUNCPTR (gst_amr_parse_start);
  parse_class->stop = GST_DEBUG_FUNCPTR (gst_amr_parse_stop);
  parse_class->set_sink_caps = GST_DEBUG_FUNCPTR (gst_amr_parse_sink_setcaps);
  parse_class->get_sink_caps = GST_DEBUG_FUNCPTR (gst_amr_parse_sink_getcaps);
  parse_class->handle_frame = GST_DEBUG_FUNCPTR (gst_amr_parse_handle_frame);
  parse_class->pre_push_frame =
      GST_DEBUG_FUNCPTR (gst_amr_parse_pre_push_frame);
}


/**
 * gst_amr_parse_init:
 * @amrparse: #GstAmrParse
 * @klass: #GstAmrParseClass.
 *
 */
static void
gst_amr_parse_init (GstAmrParse * amrparse)
{
  /* init rest */
  gst_base_parse_set_min_frame_size (GST_BASE_PARSE (amrparse), 62);
  GST_DEBUG ("initialized");
  GST_PAD_SET_ACCEPT_INTERSECT (GST_BASE_PARSE_SINK_PAD (amrparse));
}


/**
 * gst_amr_parse_set_src_caps:
 * @amrparse: #GstAmrParse.
 *
 * Set source pad caps according to current knowledge about the
 * audio stream.
 *
 * Returns: TRUE if caps were successfully set.
 */
static gboolean
gst_amr_parse_set_src_caps (GstAmrParse * amrparse)
{
  GstCaps *src_caps = NULL;
  gboolean res = FALSE;

  if (amrparse->wide) {
    GST_DEBUG_OBJECT (amrparse, "setting srcpad caps to AMR-WB");
    src_caps = gst_caps_new_simple ("audio/AMR-WB",
        "channels", G_TYPE_INT, 1, "rate", G_TYPE_INT, 16000, NULL);
  } else {
    GST_DEBUG_OBJECT (amrparse, "setting srcpad caps to AMR-NB");
    /* Max. size of NB frame is 31 bytes, so we can set the min. frame
       size to 32 (+1 for next frame header) */
    gst_base_parse_set_min_frame_size (GST_BASE_PARSE (amrparse), 32);
    src_caps = gst_caps_new_simple ("audio/AMR",
        "channels", G_TYPE_INT, 1, "rate", G_TYPE_INT, 8000, NULL);
  }
  gst_pad_use_fixed_caps (GST_BASE_PARSE (amrparse)->srcpad);
  res = gst_pad_set_caps (GST_BASE_PARSE (amrparse)->srcpad, src_caps);
  gst_caps_unref (src_caps);
  return res;
}


/**
 * gst_amr_parse_sink_setcaps:
 * @sinkpad: GstPad
 * @caps: GstCaps
 *
 * Returns: TRUE on success.
 */
static gboolean
gst_amr_parse_sink_setcaps (GstBaseParse * parse, GstCaps * caps)
{
  GstAmrParse *amrparse;
  GstStructure *structure;
  const gchar *name;

  amrparse = GST_AMR_PARSE (parse);
  structure = gst_caps_get_structure (caps, 0);
  name = gst_structure_get_name (structure);

  GST_DEBUG_OBJECT (amrparse, "setcaps: %s", name);

  if (!strncmp (name, "audio/x-amr-wb-sh", 17)) {
    amrparse->block_size = block_size_wb;
    amrparse->wide = 1;
  } else if (!strncmp (name, "audio/x-amr-nb-sh", 17)) {
    amrparse->block_size = block_size_nb;
    amrparse->wide = 0;
  } else {
    GST_WARNING ("Unknown caps");
    return FALSE;
  }

  amrparse->need_header = FALSE;
  gst_base_parse_set_frame_rate (GST_BASE_PARSE (amrparse), 50, 1, 2, 2);
  gst_amr_parse_set_src_caps (amrparse);
  return TRUE;
}

/**
 * gst_amr_parse_parse_header:
 * @amrparse: #GstAmrParse
 * @data: Header data to be parsed.
 * @skipsize: Output argument where the frame size will be stored.
 *
 * Check if the given data contains an AMR mime header.
 *
 * Returns: TRUE on success.
 */
static gboolean
gst_amr_parse_parse_header (GstAmrParse * amrparse,
    const guint8 * data, gint * skipsize)
{
  GST_DEBUG_OBJECT (amrparse, "Parsing header data");

  if (!memcmp (data, "#!AMR-WB\n", 9)) {
    GST_DEBUG_OBJECT (amrparse, "AMR-WB detected");
    amrparse->block_size = block_size_wb;
    amrparse->wide = TRUE;
    *skipsize = amrparse->header = 9;
  } else if (!memcmp (data, "#!AMR\n", 6)) {
    GST_DEBUG_OBJECT (amrparse, "AMR-NB detected");
    amrparse->block_size = block_size_nb;
    amrparse->wide = FALSE;
    *skipsize = amrparse->header = 6;
  } else
    return FALSE;

  gst_amr_parse_set_src_caps (amrparse);
  return TRUE;
}


/**
 * gst_amr_parse_check_valid_frame:
 * @parse: #GstBaseParse.
 * @buffer: #GstBuffer.
 * @framesize: Output variable where the found frame size is put.
 * @skipsize: Output variable which tells how much data needs to be skipped
 *            until a frame header is found.
 *
 * Implementation of "check_valid_frame" vmethod in #GstBaseParse class.
 *
 * Returns: TRUE if the given data contains valid frame.
 */
static GstFlowReturn
gst_amr_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize)
{
  GstBuffer *buffer;
  GstMapInfo map;
  gint fsize = 0, mode, dsize;
  GstAmrParse *amrparse;
  GstFlowReturn ret = GST_FLOW_OK;
  gboolean found = FALSE;

  amrparse = GST_AMR_PARSE (parse);
  buffer = frame->buffer;

  gst_buffer_map (buffer, &map, GST_MAP_READ);
  dsize = map.size;

  GST_LOG ("buffer: %d bytes", dsize);

  if (amrparse->need_header) {
    if (dsize >= AMR_MIME_HEADER_SIZE &&
        gst_amr_parse_parse_header (amrparse, map.data, skipsize)) {
      amrparse->need_header = FALSE;
      gst_base_parse_set_frame_rate (GST_BASE_PARSE (amrparse), 50, 1, 2, 2);
    } else {
      GST_WARNING ("media doesn't look like a AMR format");
    }
    /* We return FALSE, so this frame won't get pushed forward. Instead,
       the "skip" value is set, so next time we will receive a valid frame. */
    goto done;
  }

  *skipsize = 1;
  /* Does this look like a possible frame header candidate? */
  if ((map.data[0] & 0x83) == 0) {
    /* Yep. Retrieve the frame size */
    mode = (map.data[0] >> 3) & 0x0F;
    fsize = amrparse->block_size[mode] + 1;     /* +1 for the header byte */

    /* We recognize this data as a valid frame when:
     *     - We are in sync. There is no need for extra checks then
     *     - We are in EOS. There might not be enough data to check next frame
     *     - Sync is lost, but the following data after this frame seem
     *       to contain a valid header as well (and there is enough data to
     *       perform this check)
     */
    if (fsize) {
      *skipsize = 0;
      /* in sync, no further check */
      if (!GST_BASE_PARSE_LOST_SYNC (parse)) {
        found = TRUE;
      } else if (dsize > fsize) {
        /* enough data, check for next sync */
        if ((map.data[fsize] & 0x83) == 0)
          found = TRUE;
      } else if (GST_BASE_PARSE_DRAINING (parse)) {
        /* not enough, but draining, so ok */
        found = TRUE;
      }
    }
  }

done:
  gst_buffer_unmap (buffer, &map);

  if (found && fsize <= map.size) {
    ret = gst_base_parse_finish_frame (parse, frame, fsize);
  }

  return ret;
}

/**
 * gst_amr_parse_start:
 * @parse: #GstBaseParse.
 *
 * Implementation of "start" vmethod in #GstBaseParse class.
 *
 * Returns: TRUE on success.
 */
static gboolean
gst_amr_parse_start (GstBaseParse * parse)
{
  GstAmrParse *amrparse;

  amrparse = GST_AMR_PARSE (parse);
  GST_DEBUG ("start");
  amrparse->need_header = TRUE;
  amrparse->header = 0;
  amrparse->sent_codec_tag = FALSE;
  return TRUE;
}


/**
 * gst_amr_parse_stop:
 * @parse: #GstBaseParse.
 *
 * Implementation of "stop" vmethod in #GstBaseParse class.
 *
 * Returns: TRUE on success.
 */
static gboolean
gst_amr_parse_stop (GstBaseParse * parse)
{
  GstAmrParse *amrparse;

  amrparse = GST_AMR_PARSE (parse);
  GST_DEBUG ("stop");
  amrparse->need_header = TRUE;
  amrparse->header = 0;
  return TRUE;
}

static GstCaps *
gst_amr_parse_sink_getcaps (GstBaseParse * parse, GstCaps * filter)
{
  GstCaps *peercaps, *templ;
  GstCaps *res;


  templ = gst_pad_get_pad_template_caps (GST_BASE_PARSE_SINK_PAD (parse));
  peercaps = gst_pad_peer_query_caps (GST_BASE_PARSE_SRC_PAD (parse), filter);

  if (peercaps) {
    guint i, n;

    /* Rename structure names */
    peercaps = gst_caps_make_writable (peercaps);
    n = gst_caps_get_size (peercaps);
    for (i = 0; i < n; i++) {
      GstStructure *s = gst_caps_get_structure (peercaps, i);

      if (gst_structure_has_name (s, "audio/AMR"))
        gst_structure_set_name (s, "audio/x-amr-nb-sh");
      else
        gst_structure_set_name (s, "audio/x-amr-wb-sh");
    }

    res = gst_caps_intersect_full (peercaps, templ, GST_CAPS_INTERSECT_FIRST);
    gst_caps_unref (peercaps);
    res = gst_caps_make_writable (res);
    /* Append the template caps because we still want to accept
     * caps without any fields in the case upstream does not
     * know anything.
     */
    gst_caps_append (res, templ);
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

static GstFlowReturn
gst_amr_parse_pre_push_frame (GstBaseParse * parse, GstBaseParseFrame * frame)
{
  GstAmrParse *amrparse = GST_AMR_PARSE (parse);

  if (!amrparse->sent_codec_tag) {
    GstTagList *taglist;
    GstCaps *caps;

    taglist = gst_tag_list_new_empty ();

    /* codec tag */
    caps = gst_pad_get_current_caps (GST_BASE_PARSE_SRC_PAD (parse));
    gst_pb_utils_add_codec_description_to_tag_list (taglist,
        GST_TAG_AUDIO_CODEC, caps);
    gst_caps_unref (caps);

    gst_pad_push_event (GST_BASE_PARSE_SRC_PAD (amrparse),
        gst_event_new_tag (taglist));

    /* also signals the end of first-frame processing */
    amrparse->sent_codec_tag = TRUE;
  }

  return GST_FLOW_OK;
}
