/* GStreamer SSA subtitle parser
 * Copyright (c) 2006 Tim-Philipp Müller <tim centricular net>
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

/* Super-primitive SSA parser - we just want the text and ignore
 * everything else like styles and timing codes etc. for now */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <stdlib.h>             /* atoi() */
#include <string.h>

#include "gstssaparse.h"

GST_DEBUG_CATEGORY_STATIC (ssa_parse_debug);
#define GST_CAT_DEFAULT ssa_parse_debug

static GstStaticPadTemplate sink_templ = GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("application/x-ssa; application/x-ass")
    );

static GstStaticPadTemplate src_templ = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("text/x-raw, format=pango-markup")
    );

#define gst_ssa_parse_parent_class parent_class
G_DEFINE_TYPE (GstSsaParse, gst_ssa_parse, GST_TYPE_ELEMENT);

static GstStateChangeReturn gst_ssa_parse_change_state (GstElement *
    element, GstStateChange transition);
static gboolean gst_ssa_parse_setcaps (GstPad * sinkpad, GstCaps * caps);
static gboolean gst_ssa_parse_src_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static gboolean gst_ssa_parse_sink_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static GstFlowReturn gst_ssa_parse_chain (GstPad * sinkpad, GstObject * parent,
    GstBuffer * buf);

static void
gst_ssa_parse_dispose (GObject * object)
{
  GstSsaParse *parse = GST_SSA_PARSE (object);

  g_free (parse->ini);
  parse->ini = NULL;

  GST_CALL_PARENT (G_OBJECT_CLASS, dispose, (object));
}

static void
gst_ssa_parse_init (GstSsaParse * parse)
{
  parse->sinkpad = gst_pad_new_from_static_template (&sink_templ, "sink");
  gst_pad_set_chain_function (parse->sinkpad,
      GST_DEBUG_FUNCPTR (gst_ssa_parse_chain));
  gst_pad_set_event_function (parse->sinkpad,
      GST_DEBUG_FUNCPTR (gst_ssa_parse_sink_event));
  gst_element_add_pad (GST_ELEMENT (parse), parse->sinkpad);

  parse->srcpad = gst_pad_new_from_static_template (&src_templ, "src");
  gst_pad_set_event_function (parse->srcpad,
      GST_DEBUG_FUNCPTR (gst_ssa_parse_src_event));
  gst_element_add_pad (GST_ELEMENT (parse), parse->srcpad);
  gst_pad_use_fixed_caps (parse->srcpad);

  parse->ini = NULL;
  parse->framed = FALSE;
  parse->send_tags = FALSE;
}

static void
gst_ssa_parse_class_init (GstSsaParseClass * klass)
{
  GObjectClass *object_class = G_OBJECT_CLASS (klass);
  GstElementClass *element_class = GST_ELEMENT_CLASS (klass);

  object_class->dispose = gst_ssa_parse_dispose;

  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&sink_templ));
  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&src_templ));
  gst_element_class_set_static_metadata (element_class,
      "SSA Subtitle Parser", "Codec/Parser/Subtitle",
      "Parses SSA subtitle streams",
      "Tim-Philipp Müller <tim centricular net>");

  GST_DEBUG_CATEGORY_INIT (ssa_parse_debug, "ssaparse", 0,
      "SSA subtitle parser");

  element_class->change_state = GST_DEBUG_FUNCPTR (gst_ssa_parse_change_state);
}

static gboolean
gst_ssa_parse_src_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  return gst_pad_event_default (pad, parent, event);
}

static gboolean
gst_ssa_parse_sink_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  gboolean res;

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_CAPS:
    {
      GstCaps *caps;

      gst_event_parse_caps (event, &caps);
      res = gst_ssa_parse_setcaps (pad, caps);
      gst_event_unref (event);
      break;
    }
    default:
      res = gst_pad_event_default (pad, parent, event);
      break;
  }
  return res;
}

static gboolean
gst_ssa_parse_setcaps (GstPad * sinkpad, GstCaps * caps)
{
  GstSsaParse *parse = GST_SSA_PARSE (GST_PAD_PARENT (sinkpad));
  GstCaps *outcaps;
  const GValue *val;
  GstStructure *s;
  const guchar bom_utf8[] = { 0xEF, 0xBB, 0xBF };
  const gchar *end;
  GstBuffer *priv;
  GstMapInfo map;
  gchar *ptr;
  gsize left, bad_offset;
  gboolean ret;

  s = gst_caps_get_structure (caps, 0);
  val = gst_structure_get_value (s, "codec_data");
  if (val == NULL) {
    parse->framed = FALSE;
    GST_ERROR ("Only SSA subtitles embedded in containers are supported");
    return FALSE;
  }

  parse->framed = TRUE;
  parse->send_tags = TRUE;

  priv = (GstBuffer *) g_value_get_boxed (val);
  g_return_val_if_fail (priv != NULL, FALSE);

  gst_buffer_ref (priv);

  if (!gst_buffer_map (priv, &map, GST_MAP_READ))
    return FALSE;

  GST_MEMDUMP_OBJECT (parse, "init section", map.data, map.size);

  ptr = (gchar *) map.data;
  left = map.size;

  /* skip UTF-8 BOM */
  if (left >= 3 && memcmp (ptr, bom_utf8, 3) == 0) {
    ptr += 3;
    left -= 3;
  }

  if (!strstr (ptr, "[Script Info]"))
    goto invalid_init;

  if (!g_utf8_validate (ptr, left, &end)) {
    bad_offset = (gsize) (end - ptr);
    GST_WARNING_OBJECT (parse, "Init section is not valid UTF-8. Problem at "
        "byte offset %" G_GSIZE_FORMAT, bad_offset);
    /* continue with valid UTF-8 data */
    left = bad_offset;
  }

  /* FIXME: parse initial section */
  parse->ini = g_strndup (ptr, left);
  GST_LOG_OBJECT (parse, "Init section:\n%s", parse->ini);

  gst_buffer_unmap (priv, &map);
  gst_buffer_unref (priv);

  outcaps = gst_caps_new_simple ("text/x-raw",
      "format", G_TYPE_STRING, "pango-markup", NULL);

  ret = gst_pad_set_caps (parse->srcpad, outcaps);
  gst_caps_unref (outcaps);

  return ret;

  /* ERRORS */
invalid_init:
  {
    GST_WARNING_OBJECT (parse, "Invalid Init section - no Script Info header");
    gst_buffer_unmap (priv, &map);
    gst_buffer_unref (priv);
    return FALSE;
  }
}

static gboolean
gst_ssa_parse_remove_override_codes (GstSsaParse * parse, gchar * txt)
{
  gchar *t, *end;
  gboolean removed_any = FALSE;

  while ((t = strchr (txt, '{'))) {
    end = strchr (txt, '}');
    if (end == NULL) {
      GST_WARNING_OBJECT (parse, "Missing { for style override code");
      return removed_any;
    }
    /* move terminating NUL character forward as well */
    memmove (t, end + 1, strlen (end + 1) + 1);
    removed_any = TRUE;
  }

  /* these may occur outside of curly brackets. We don't handle the different
   * wrapping modes yet, so just remove these markers from the text for now */
  while ((t = strstr (txt, "\\n"))) {
    t[0] = ' ';
    t[1] = '\n';
  }
  while ((t = strstr (txt, "\\N"))) {
    t[0] = ' ';
    t[1] = '\n';
  }
  while ((t = strstr (txt, "\\h"))) {
    t[0] = ' ';
    t[1] = ' ';
  }

  return removed_any;
}

/**
 * gst_ssa_parse_push_line:
 * @parse: caller element
 * @txt: text to push
 * @start: timestamp for the buffer
 * @duration: duration for the buffer
 *
 * Parse the text in a buffer with the given properties and
 * push it to the srcpad of the @parse element
 *
 * Returns: result of the push of the created buffer
 */
static GstFlowReturn
gst_ssa_parse_push_line (GstSsaParse * parse, gchar * txt,
    GstClockTime start, GstClockTime duration)
{
  GstFlowReturn ret;
  GstBuffer *buf;
  gchar *t, *escaped;
  gint num, i, len;

  num = atoi (txt);
  GST_LOG_OBJECT (parse, "Parsing line #%d at %" GST_TIME_FORMAT,
      num, GST_TIME_ARGS (start));

  /* skip all non-text fields before the actual text */
  t = txt;
  for (i = 0; i < 8; ++i) {
    t = strchr (t, ',');
    if (t == NULL)
      return GST_FLOW_ERROR;
    ++t;
  }

  GST_LOG_OBJECT (parse, "Text : %s", t);

  if (gst_ssa_parse_remove_override_codes (parse, t)) {
    GST_LOG_OBJECT (parse, "Clean: %s", t);
  }

  /* we claim to output pango markup, so we must escape the
   * text even if we don't actually use any pango markup yet */
  escaped = g_markup_printf_escaped ("%s", t);

  len = strlen (escaped);

  /* allocate enough for a terminating NUL, but don't include it in buf size */
  buf = gst_buffer_new_and_alloc (len + 1);
  gst_buffer_fill (buf, 0, escaped, len + 1);
  gst_buffer_set_size (buf, len);
  g_free (escaped);

  GST_BUFFER_TIMESTAMP (buf) = start;
  GST_BUFFER_DURATION (buf) = duration;

  GST_LOG_OBJECT (parse, "Pushing buffer with timestamp %" GST_TIME_FORMAT
      " and duration %" GST_TIME_FORMAT, GST_TIME_ARGS (start),
      GST_TIME_ARGS (duration));

  ret = gst_pad_push (parse->srcpad, buf);

  if (ret != GST_FLOW_OK) {
    GST_DEBUG_OBJECT (parse, "Push of text '%s' returned flow %s", txt,
        gst_flow_get_name (ret));
  }

  return ret;
}

static GstFlowReturn
gst_ssa_parse_chain (GstPad * sinkpad, GstObject * parent, GstBuffer * buf)
{
  GstFlowReturn ret;
  GstSsaParse *parse = GST_SSA_PARSE (parent);
  GstClockTime ts;
  gchar *txt;
  GstMapInfo map;

  if (G_UNLIKELY (!parse->framed))
    goto not_framed;

  if (G_UNLIKELY (parse->send_tags)) {
    GstTagList *tags;

    tags = gst_tag_list_new_empty ();
    gst_tag_list_add (tags, GST_TAG_MERGE_APPEND, GST_TAG_SUBTITLE_CODEC,
        "SubStation Alpha", NULL);
    gst_pad_push_event (parse->srcpad, gst_event_new_tag (tags));
    parse->send_tags = FALSE;
  }

  /* make double-sure it's 0-terminated and all */
  gst_buffer_map (buf, &map, GST_MAP_READ);
  txt = g_strndup ((gchar *) map.data, map.size);
  gst_buffer_unmap (buf, &map);

  if (txt == NULL)
    goto empty_text;

  ts = GST_BUFFER_TIMESTAMP (buf);
  ret = gst_ssa_parse_push_line (parse, txt, ts, GST_BUFFER_DURATION (buf));

  if (ret != GST_FLOW_OK && GST_CLOCK_TIME_IS_VALID (ts)) {
    GstSegment segment;

    /* just advance time without sending anything */
    gst_segment_init (&segment, GST_FORMAT_TIME);
    segment.start = ts;
    segment.time = ts;
    gst_pad_push_event (parse->srcpad, gst_event_new_segment (&segment));
    ret = GST_FLOW_OK;
  }

  gst_buffer_unref (buf);
  g_free (txt);

  return ret;

/* ERRORS */
not_framed:
  {
    GST_ELEMENT_ERROR (parse, STREAM, FORMAT, (NULL),
        ("Only SSA subtitles embedded in containers are supported"));
    gst_buffer_unref (buf);
    return GST_FLOW_NOT_NEGOTIATED;
  }
empty_text:
  {
    GST_ELEMENT_WARNING (parse, STREAM, FORMAT, (NULL),
        ("Received empty subtitle"));
    gst_buffer_unref (buf);
    return GST_FLOW_OK;
  }
}

static GstStateChangeReturn
gst_ssa_parse_change_state (GstElement * element, GstStateChange transition)
{
  GstStateChangeReturn ret = GST_STATE_CHANGE_SUCCESS;
  GstSsaParse *parse = GST_SSA_PARSE (element);

  switch (transition) {
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      break;
    default:
      break;
  }

  ret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);
  if (ret == GST_STATE_CHANGE_FAILURE)
    return ret;

  switch (transition) {
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      g_free (parse->ini);
      parse->ini = NULL;
      parse->framed = FALSE;
      break;
    default:
      break;
  }

  return ret;
}
