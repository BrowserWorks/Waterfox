/* GStreamer
 * Copyright (C) 2010 David Schleef <ds@schleef.org>
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
 * SECTION:element-gstdiracparse
 *
 * The gstdiracparse element does FIXME stuff.
 *
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * gst-launch -v fakesrc ! gstdiracparse ! FIXME ! fakesink
 * ]|
 * FIXME Describe what the pipeline does.
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/gst.h>
#include <gst/base/base.h>
#include <gst/pbutils/pbutils.h>
#include <string.h>
#include "gstdiracparse.h"
#include "dirac_parse.h"

/* prototypes */


static void gst_dirac_parse_set_property (GObject * object,
    guint property_id, const GValue * value, GParamSpec * pspec);
static void gst_dirac_parse_get_property (GObject * object,
    guint property_id, GValue * value, GParamSpec * pspec);
static void gst_dirac_parse_dispose (GObject * object);
static void gst_dirac_parse_finalize (GObject * object);

static gboolean gst_dirac_parse_start (GstBaseParse * parse);
static gboolean gst_dirac_parse_stop (GstBaseParse * parse);
static gboolean gst_dirac_parse_set_sink_caps (GstBaseParse * parse,
    GstCaps * caps);
static GstCaps *gst_dirac_parse_get_sink_caps (GstBaseParse * parse,
    GstCaps * filter);
static GstFlowReturn gst_dirac_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize);
static gboolean gst_dirac_parse_convert (GstBaseParse * parse,
    GstFormat src_format, gint64 src_value, GstFormat dest_format,
    gint64 * dest_value);
static GstFlowReturn gst_dirac_parse_pre_push_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame);

enum
{
  PROP_0
};

/* pad templates */

static GstStaticPadTemplate gst_dirac_parse_sink_template =
GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("video/x-dirac")
    );

static GstStaticPadTemplate gst_dirac_parse_src_template =
GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("video/x-dirac, parsed=(boolean)TRUE, "
        "width=(int)[1,MAX], height=(int)[1,MAX], "
        "framerate=(fraction)[0/1,MAX], "
        "pixel-aspect-ratio=(fraction)[0/1,MAX], "
        "interlace-mode=(string) { progressive, interleaved }, "
        "profile=(string){ vc2-low-delay, vc2-simple, vc2-main, main }, "
        "level=(string) { 0, 1, 128}")
    );

/* class initialization */

#define parent_class gst_dirac_parse_parent_class
G_DEFINE_TYPE (GstDiracParse, gst_dirac_parse, GST_TYPE_BASE_PARSE);

static void
gst_dirac_parse_class_init (GstDiracParseClass * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);
  GstElementClass *element_class = GST_ELEMENT_CLASS (klass);
  GstBaseParseClass *base_parse_class = GST_BASE_PARSE_CLASS (klass);

  gobject_class->set_property = gst_dirac_parse_set_property;
  gobject_class->get_property = gst_dirac_parse_get_property;
  gobject_class->dispose = gst_dirac_parse_dispose;
  gobject_class->finalize = gst_dirac_parse_finalize;

  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&gst_dirac_parse_src_template));
  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&gst_dirac_parse_sink_template));

  gst_element_class_set_static_metadata (element_class, "Dirac parser",
      "Codec/Parser/Video", "Parses Dirac streams",
      "David Schleef <ds@schleef.org>");

  base_parse_class->start = GST_DEBUG_FUNCPTR (gst_dirac_parse_start);
  base_parse_class->stop = GST_DEBUG_FUNCPTR (gst_dirac_parse_stop);
  base_parse_class->set_sink_caps =
      GST_DEBUG_FUNCPTR (gst_dirac_parse_set_sink_caps);
  base_parse_class->get_sink_caps =
      GST_DEBUG_FUNCPTR (gst_dirac_parse_get_sink_caps);
  base_parse_class->handle_frame =
      GST_DEBUG_FUNCPTR (gst_dirac_parse_handle_frame);
  base_parse_class->convert = GST_DEBUG_FUNCPTR (gst_dirac_parse_convert);
  base_parse_class->pre_push_frame =
      GST_DEBUG_FUNCPTR (gst_dirac_parse_pre_push_frame);

}

static void
gst_dirac_parse_init (GstDiracParse * diracparse)
{
  gst_base_parse_set_min_frame_size (GST_BASE_PARSE (diracparse), 13);
  gst_base_parse_set_pts_interpolation (GST_BASE_PARSE (diracparse), FALSE);
  GST_PAD_SET_ACCEPT_INTERSECT (GST_BASE_PARSE_SINK_PAD (diracparse));
}

void
gst_dirac_parse_set_property (GObject * object, guint property_id,
    const GValue * value, GParamSpec * pspec)
{
  g_return_if_fail (GST_IS_DIRAC_PARSE (object));

  switch (property_id) {
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, property_id, pspec);
      break;
  }
}

void
gst_dirac_parse_get_property (GObject * object, guint property_id,
    GValue * value, GParamSpec * pspec)
{
  g_return_if_fail (GST_IS_DIRAC_PARSE (object));

  switch (property_id) {
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, property_id, pspec);
      break;
  }
}

void
gst_dirac_parse_dispose (GObject * object)
{
  g_return_if_fail (GST_IS_DIRAC_PARSE (object));

  /* clean up as possible.  may be called multiple times */

  G_OBJECT_CLASS (parent_class)->dispose (object);
}

void
gst_dirac_parse_finalize (GObject * object)
{
  g_return_if_fail (GST_IS_DIRAC_PARSE (object));

  /* clean up object here */

  G_OBJECT_CLASS (parent_class)->finalize (object);
}


static gboolean
gst_dirac_parse_start (GstBaseParse * parse)
{
  GstDiracParse *diracparse = GST_DIRAC_PARSE (parse);

  gst_base_parse_set_min_frame_size (parse, 13);

  diracparse->sent_codec_tag = FALSE;

  return TRUE;
}

static gboolean
gst_dirac_parse_stop (GstBaseParse * parse)
{
  return TRUE;
}

static gboolean
gst_dirac_parse_set_sink_caps (GstBaseParse * parse, GstCaps * caps)
{
  /* Called when sink caps are set */
  return TRUE;
}

static const gchar *
get_profile_name (int profile)
{
  switch (profile) {
    case 0:
      return "vc2-low-delay";
    case 1:
      return "vc2-simple";
    case 2:
      return "vc2-main";
    case 8:
      return "main";
    default:
      break;
  }
  return "unknown";
}

static const gchar *
get_level_name (int level)
{
  switch (level) {
    case 0:
      return "0";
    case 1:
      return "1";
    case 128:
      return "128";
    default:
      break;
  }
  /* need to add it to template caps, so return 0 for now */
  GST_WARNING ("unhandled dirac level %u", level);
  return "0";
}

static GstFlowReturn
gst_dirac_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize)
{
  int off;
  guint32 next_header;
  GstMapInfo map;
  guint8 *data;
  gsize size;
  gboolean have_picture = FALSE;
  int offset;
  guint framesize = 0;

  gst_buffer_map (frame->buffer, &map, GST_MAP_READ);
  data = map.data;
  size = map.size;

  if (G_UNLIKELY (size < 13)) {
    *skipsize = 1;
    goto out;
  }

  GST_DEBUG ("%" G_GSIZE_FORMAT ": %02x %02x %02x %02x", size, data[0], data[1],
      data[2], data[3]);

  if (GST_READ_UINT32_BE (data) != 0x42424344) {
    GstByteReader reader;

    gst_byte_reader_init (&reader, data, size);
    off = gst_byte_reader_masked_scan_uint32 (&reader, 0xffffffff,
        0x42424344, 0, size);

    if (off < 0) {
      *skipsize = size - 3;
      goto out;
    }

    GST_LOG_OBJECT (parse, "possible sync at buffer offset %d", off);

    GST_DEBUG ("skipping %d", off);
    *skipsize = off;
    goto out;
  }

  /* have sync, parse chunks */

  offset = 0;
  while (!have_picture) {
    GST_DEBUG ("offset %d:", offset);

    if (offset + 13 >= size) {
      framesize = offset + 13;
      goto out;
    }

    GST_DEBUG ("chunk type %02x", data[offset + 4]);

    if (GST_READ_UINT32_BE (data + offset) != 0x42424344) {
      GST_DEBUG ("bad header");
      *skipsize = 3;
      goto out;
    }

    next_header = GST_READ_UINT32_BE (data + offset + 5);
    GST_DEBUG ("next_header %d", next_header);
    if (next_header == 0)
      next_header = 13;

    if (SCHRO_PARSE_CODE_IS_PICTURE (data[offset + 4])) {
      have_picture = TRUE;
    }

    offset += next_header;
    if (offset >= size) {
      framesize = offset;
      goto out;
    }
  }

  gst_buffer_unmap (frame->buffer, &map);

  framesize = offset;
  GST_DEBUG ("framesize %d", framesize);

  g_assert (framesize <= size);

  if (data[4] == SCHRO_PARSE_CODE_SEQUENCE_HEADER) {
    GstCaps *caps;
    GstDiracParse *diracparse = GST_DIRAC_PARSE (parse);
    DiracSequenceHeader sequence_header;
    int ret;

    ret = dirac_sequence_header_parse (&sequence_header, data + 13, size - 13);
    if (ret) {
      memcpy (&diracparse->sequence_header, &sequence_header,
          sizeof (sequence_header));
      caps = gst_caps_new_simple ("video/x-dirac",
          "width", G_TYPE_INT, sequence_header.width,
          "height", G_TYPE_INT, sequence_header.height,
          "framerate", GST_TYPE_FRACTION,
          sequence_header.frame_rate_numerator,
          sequence_header.frame_rate_denominator,
          "pixel-aspect-ratio", GST_TYPE_FRACTION,
          sequence_header.aspect_ratio_numerator,
          sequence_header.aspect_ratio_denominator,
          "interlace-mode", G_TYPE_STRING,
          sequence_header.interlaced ? "interleaved" : "progressive",
          "profile", G_TYPE_STRING, get_profile_name (sequence_header.profile),
          "level", G_TYPE_STRING, get_level_name (sequence_header.level), NULL);
      gst_pad_set_caps (GST_BASE_PARSE_SRC_PAD (parse), caps);
      gst_caps_unref (caps);

      gst_base_parse_set_frame_rate (parse,
          sequence_header.frame_rate_numerator,
          sequence_header.frame_rate_denominator, 0, 0);
    }
  }

  gst_base_parse_set_min_frame_size (parse, 13);

  return gst_base_parse_finish_frame (parse, frame, framesize);

out:
  gst_buffer_unmap (frame->buffer, &map);
  if (framesize)
    gst_base_parse_set_min_frame_size (parse, framesize);
  return GST_FLOW_OK;
}

static gboolean
gst_dirac_parse_convert (GstBaseParse * parse, GstFormat src_format,
    gint64 src_value, GstFormat dest_format, gint64 * dest_value)
{
  /* Convert between formats */

  return FALSE;
}

static GstFlowReturn
gst_dirac_parse_pre_push_frame (GstBaseParse * parse, GstBaseParseFrame * frame)
{
  GstDiracParse *diracparse = GST_DIRAC_PARSE (parse);

  if (!diracparse->sent_codec_tag) {
    GstTagList *taglist;
    GstCaps *caps;

    taglist = gst_tag_list_new_empty ();

    /* codec tag */
    caps = gst_pad_get_current_caps (GST_BASE_PARSE_SRC_PAD (parse));
    gst_pb_utils_add_codec_description_to_tag_list (taglist,
        GST_TAG_VIDEO_CODEC, caps);
    gst_caps_unref (caps);

    gst_pad_push_event (GST_BASE_PARSE_SRC_PAD (diracparse),
        gst_event_new_tag (taglist));

    /* also signals the end of first-frame processing */
    diracparse->sent_codec_tag = TRUE;
  }

  return GST_FLOW_OK;
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
gst_dirac_parse_get_sink_caps (GstBaseParse * parse, GstCaps * filter)
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
