/* GStreamer H.263 Parser
 * Copyright (C) <2010> Arun Raghavan <arun.raghavan@collabora.co.uk>
 * Copyright (C) <2010> Edward Hervey <edward.hervey@collabora.co.uk>
 * Copyright (C) <2010> Collabora Multimedia
 * Copyright (C) <2010> Nokia Corporation
 *
 * Some bits C-c,C-v'ed and s/4/3 from h264parse:
 *           (C) 2005 Michal Benes <michal.benes@itonis.tv>
 *           (C) 2008 Wim Taymans <wim.taymans@gmail.com>
 *           (C) 2009 Mark Nauwelaerts <mnauw users sf net>
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
#include "gsth263parse.h"

#include <string.h>

GST_DEBUG_CATEGORY (h263_parse_debug);
#define GST_CAT_DEFAULT h263_parse_debug

static GstStaticPadTemplate srctemplate =
GST_STATIC_PAD_TEMPLATE ("src", GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("video/x-h263, variant = (string) itu, "
        "parsed = (boolean) true, framerate=(fraction)[0/1,MAX]")
    );

static GstStaticPadTemplate sinktemplate =
GST_STATIC_PAD_TEMPLATE ("sink", GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("video/x-h263, variant = (string) itu")
    );

#define parent_class gst_h263_parse_parent_class
G_DEFINE_TYPE (GstH263Parse, gst_h263_parse, GST_TYPE_BASE_PARSE);

static gboolean gst_h263_parse_start (GstBaseParse * parse);
static gboolean gst_h263_parse_stop (GstBaseParse * parse);
static gboolean gst_h263_parse_sink_event (GstBaseParse * parse,
    GstEvent * event);
static GstFlowReturn gst_h263_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize);
static GstFlowReturn gst_h263_parse_pre_push_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame);
static GstCaps *gst_h263_parse_get_sink_caps (GstBaseParse * parse,
    GstCaps * filter);

static void
gst_h263_parse_class_init (GstH263ParseClass * klass)
{
  GstElementClass *gstelement_class = GST_ELEMENT_CLASS (klass);
  GstBaseParseClass *parse_class = GST_BASE_PARSE_CLASS (klass);

  GST_DEBUG_CATEGORY_INIT (h263_parse_debug, "h263parse", 0, "h263 parser");

  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&srctemplate));
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&sinktemplate));
  gst_element_class_set_static_metadata (gstelement_class, "H.263 parser",
      "Codec/Parser/Video",
      "Parses H.263 streams",
      "Arun Raghavan <arun.raghavan@collabora.co.uk>,"
      "Edward Hervey <edward.hervey@collabora.co.uk>");

  /* Override BaseParse vfuncs */
  parse_class->start = GST_DEBUG_FUNCPTR (gst_h263_parse_start);
  parse_class->stop = GST_DEBUG_FUNCPTR (gst_h263_parse_stop);
  parse_class->sink_event = GST_DEBUG_FUNCPTR (gst_h263_parse_sink_event);
  parse_class->handle_frame = GST_DEBUG_FUNCPTR (gst_h263_parse_handle_frame);
  parse_class->pre_push_frame =
      GST_DEBUG_FUNCPTR (gst_h263_parse_pre_push_frame);
  parse_class->get_sink_caps = GST_DEBUG_FUNCPTR (gst_h263_parse_get_sink_caps);
}

static void
gst_h263_parse_init (GstH263Parse * h263parse)
{
  GST_PAD_SET_ACCEPT_INTERSECT (GST_BASE_PARSE_SINK_PAD (h263parse));
}

static gboolean
gst_h263_parse_start (GstBaseParse * parse)
{
  GstH263Parse *h263parse = GST_H263_PARSE (parse);

  GST_DEBUG_OBJECT (h263parse, "start");

  h263parse->bitrate = 0;
  h263parse->profile = -1;
  h263parse->level = -1;

  h263parse->state = PARSING;

  h263parse->sent_codec_tag = FALSE;

  gst_base_parse_set_min_frame_size (parse, 4);

  return TRUE;
}

static gboolean
gst_h263_parse_stop (GstBaseParse * parse)
{
  GST_DEBUG_OBJECT (parse, "stop");

  return TRUE;
}

static gboolean
gst_h263_parse_sink_event (GstBaseParse * parse, GstEvent * event)
{
  GstH263Parse *h263parse;

  h263parse = GST_H263_PARSE (parse);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_TAG:
    {
      GstTagList *taglist;

      gst_event_parse_tag (event, &taglist);

      if (gst_tag_list_get_uint (taglist, GST_TAG_BITRATE, &h263parse->bitrate))
        GST_DEBUG_OBJECT (h263parse, "got bitrate tag: %u", h263parse->bitrate);

      break;
    }
    default:
      break;
  }

  return GST_BASE_PARSE_CLASS (parent_class)->sink_event (parse, event);
}

static guint
find_psc (GstBuffer * buffer, guint skip)
{
  GstMapInfo map;
  GstByteReader br;
  guint psc_pos = -1, psc;

  gst_buffer_map (buffer, &map, GST_MAP_READ);
  gst_byte_reader_init (&br, map.data, map.size);

  if (!gst_byte_reader_set_pos (&br, skip))
    goto out;

  if (gst_byte_reader_peek_uint24_be (&br, &psc) == FALSE)
    goto out;

  /* Scan for the picture start code (22 bits - 0x0020) */
  while ((gst_byte_reader_get_remaining (&br) >= 3)) {
    if (gst_byte_reader_peek_uint24_be (&br, &psc) &&
        ((psc & 0xffffc0) == 0x000080)) {
      psc_pos = gst_byte_reader_get_pos (&br);
      break;
    } else if (gst_byte_reader_skip (&br, 1) == FALSE)
      break;
  }

out:
  gst_buffer_unmap (buffer, &map);
  return psc_pos;
}

static void
gst_h263_parse_set_src_caps (GstH263Parse * h263parse,
    const H263Params * params)
{
  GstStructure *st = NULL;
  GstCaps *caps, *sink_caps;
  gint fr_num, fr_denom, par_num, par_denom;

  g_assert (h263parse->state == PASSTHROUGH || h263parse->state == GOT_HEADER);

  caps = gst_pad_get_current_caps (GST_BASE_PARSE_SINK_PAD (h263parse));
  if (caps) {
    caps = gst_caps_make_writable (caps);
  } else {
    caps = gst_caps_new_simple ("video/x-h263",
        "variant", G_TYPE_STRING, "itu", NULL);
  }
  gst_caps_set_simple (caps, "parsed", G_TYPE_BOOLEAN, TRUE, NULL);

  sink_caps = gst_pad_get_current_caps (GST_BASE_PARSE_SINK_PAD (h263parse));
  if (sink_caps && (st = gst_caps_get_structure (sink_caps, 0)) &&
      gst_structure_get_fraction (st, "framerate", &fr_num, &fr_denom)) {
    /* Got it in caps - nothing more to do */
    GST_DEBUG_OBJECT (h263parse, "sink caps override framerate from headers");
  } else {
    /* Caps didn't have the framerate - get it from params */
    gst_h263_parse_get_framerate (params, &fr_num, &fr_denom);
  }
  gst_caps_set_simple (caps, "framerate", GST_TYPE_FRACTION, fr_num, fr_denom,
      NULL);

  if (params->width && params->height)
    gst_caps_set_simple (caps, "width", G_TYPE_INT, params->width,
        "height", G_TYPE_INT, params->height, NULL);

  if (st != NULL
      && gst_structure_get_fraction (st, "pixel-aspect-ratio", &par_num,
          &par_denom)) {
    /* Got it in caps - nothing more to do */
    GST_DEBUG_OBJECT (h263parse, "sink caps override PAR");
  } else {
    /* Caps didn't have the framerate - get it from params */
    gst_h263_parse_get_par (params, &par_num, &par_denom);
  }
  gst_caps_set_simple (caps, "pixel-aspect-ratio", GST_TYPE_FRACTION,
      par_num, par_denom, NULL);

  if (h263parse->state == GOT_HEADER) {
    gst_caps_set_simple (caps,
        "annex-d", G_TYPE_BOOLEAN, (params->features & H263_OPTION_UMV_MODE),
        "annex-e", G_TYPE_BOOLEAN, (params->features & H263_OPTION_SAC_MODE),
        "annex-f", G_TYPE_BOOLEAN, (params->features & H263_OPTION_AP_MODE),
        "annex-g", G_TYPE_BOOLEAN, (params->features & H263_OPTION_PB_MODE),
        "annex-i", G_TYPE_BOOLEAN, (params->features & H263_OPTION_AIC_MODE),
        "annex-j", G_TYPE_BOOLEAN, (params->features & H263_OPTION_DF_MODE),
        "annex-k", G_TYPE_BOOLEAN, (params->features & H263_OPTION_SS_MODE),
        "annex-m", G_TYPE_BOOLEAN, (params->type == PICTURE_IMPROVED_PB),
        "annex-n", G_TYPE_BOOLEAN, (params->features & H263_OPTION_RPS_MODE),
        "annex-q", G_TYPE_BOOLEAN, (params->features & H263_OPTION_RRU_MODE),
        "annex-r", G_TYPE_BOOLEAN, (params->features & H263_OPTION_ISD_MODE),
        "annex-s", G_TYPE_BOOLEAN, (params->features & H263_OPTION_AIV_MODE),
        "annex-t", G_TYPE_BOOLEAN, (params->features & H263_OPTION_MQ_MODE),
        "annex-u", G_TYPE_BOOLEAN, (params->features & H263_OPTION_ERPS_MODE),
        "annex-v", G_TYPE_BOOLEAN, (params->features & H263_OPTION_DPS_MODE),
        NULL);

    h263parse->profile = gst_h263_parse_get_profile (params);
    if (h263parse->profile != -1) {
      gchar *profile_str;

      profile_str = g_strdup_printf ("%u", h263parse->profile);
      gst_caps_set_simple (caps, "profile", G_TYPE_STRING, profile_str, NULL);
      g_free (profile_str);
    }

    h263parse->level = gst_h263_parse_get_level (params, h263parse->profile,
        h263parse->bitrate, fr_num, fr_denom);
    if (h263parse->level != -1) {
      gchar *level_str;

      level_str = g_strdup_printf ("%u", h263parse->level);
      gst_caps_set_simple (caps, "level", G_TYPE_STRING, level_str, NULL);
      g_free (level_str);
    }
  }

  gst_pad_set_caps (GST_BASE_PARSE_SRC_PAD (GST_BASE_PARSE (h263parse)), caps);
  gst_caps_unref (caps);
}

static GstFlowReturn
gst_h263_parse_handle_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame, gint * skipsize)
{
  GstH263Parse *h263parse;
  GstBuffer *buffer;
  guint psc_pos, next_psc_pos;
  gsize size;
  H263Params params = { 0, };
  GstFlowReturn res = GST_FLOW_OK;

  h263parse = GST_H263_PARSE (parse);
  buffer = frame->buffer;
  size = gst_buffer_get_size (buffer);

  if (size < 3) {
    *skipsize = 1;
    return GST_FLOW_OK;
  }

  psc_pos = find_psc (buffer, 0);

  if (psc_pos == -1) {
    /* PSC not found, need more data */
    if (size > 3)
      psc_pos = size - 3;
    else
      psc_pos = 0;
    goto more;
  }

  /* need to skip */
  if (psc_pos > 0)
    goto more;

  /* Found the start of the frame, now try to find the end */
  next_psc_pos = psc_pos + 3;
  next_psc_pos = find_psc (buffer, next_psc_pos);

  if (next_psc_pos == -1) {
    if (GST_BASE_PARSE_DRAINING (parse))
      /* FLUSH/EOS, it's okay if we can't find the next frame */
      next_psc_pos = size;
    else
      goto more;
  }

  /* We should now have a complete frame */

  /* If this is the first frame, parse and set srcpad caps */
  if (h263parse->state == PARSING) {
    res = gst_h263_parse_get_params (&params, buffer, FALSE, &h263parse->state);
    if (res != GST_FLOW_OK || h263parse->state != GOT_HEADER) {
      GST_WARNING ("Couldn't parse header - setting passthrough mode");
      gst_base_parse_set_passthrough (parse, TRUE);
    } else {
      /* Set srcpad caps since we now have sufficient information to do so */
      gst_h263_parse_set_src_caps (h263parse, &params);
      gst_base_parse_set_passthrough (parse, FALSE);
    }
    memset (&params, 0, sizeof (params));
  }

  /* XXX: After getting a keyframe, should we adjust min_frame_size to
   * something smaller so we don't end up collecting too many non-keyframes? */

  GST_DEBUG_OBJECT (h263parse, "found a frame of size %u at pos %u",
      next_psc_pos, psc_pos);

  res = gst_h263_parse_get_params (&params, buffer, TRUE, &h263parse->state);
  if (res != GST_FLOW_OK)
    goto more;

  if (h263parse->state == PASSTHROUGH || h263parse->state == PARSING) {
    /* There's a feature we don't support, or we didn't have enough data to
     * parse the header, which should not be possible. Either way, go into
     * passthrough mode and let downstream handle it if it can. */
    GST_WARNING ("Couldn't parse header - setting passthrough mode");
    gst_base_parse_set_passthrough (parse, TRUE);
    goto more;
  }

  if (gst_h263_parse_is_delta_unit (&params))
    GST_BUFFER_FLAG_UNSET (buffer, GST_BUFFER_FLAG_DELTA_UNIT);
  else
    GST_BUFFER_FLAG_SET (buffer, GST_BUFFER_FLAG_DELTA_UNIT);

  return gst_base_parse_finish_frame (parse, frame, next_psc_pos);

more:
  *skipsize = psc_pos;

  return res;
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
gst_h263_parse_get_sink_caps (GstBaseParse * parse, GstCaps * filter)
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
    /* Remove parsed field */
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

static GstFlowReturn
gst_h263_parse_pre_push_frame (GstBaseParse * parse, GstBaseParseFrame * frame)
{
  GstH263Parse *h263parse = GST_H263_PARSE (parse);

  if (!h263parse->sent_codec_tag) {
    GstTagList *taglist;
    GstCaps *caps;

    taglist = gst_tag_list_new_empty ();

    /* codec tag */
    caps = gst_pad_get_current_caps (GST_BASE_PARSE_SRC_PAD (parse));
    gst_pb_utils_add_codec_description_to_tag_list (taglist,
        GST_TAG_VIDEO_CODEC, caps);
    gst_caps_unref (caps);

    gst_pad_push_event (GST_BASE_PARSE_SRC_PAD (h263parse),
        gst_event_new_tag (taglist));

    /* also signals the end of first-frame processing */
    h263parse->sent_codec_tag = TRUE;
  }

  return GST_FLOW_OK;
}
