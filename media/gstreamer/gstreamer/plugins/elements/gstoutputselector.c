/* GStreamer output selector
 * Copyright (C) 2008 Nokia Corporation. (contact <stefan.kost@nokia.com>)
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
 * SECTION:element-output-selector
 * @see_also: #GstOutputSelector, #GstInputSelector
 *
 * Direct input stream to one out of N output pads.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <string.h>

#include "gstoutputselector.h"

GST_DEBUG_CATEGORY_STATIC (output_selector_debug);
#define GST_CAT_DEFAULT output_selector_debug

static GstStaticPadTemplate gst_output_selector_sink_factory =
GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

static GstStaticPadTemplate gst_output_selector_src_factory =
GST_STATIC_PAD_TEMPLATE ("src_%u",
    GST_PAD_SRC,
    GST_PAD_REQUEST,
    GST_STATIC_CAPS_ANY);

#define GST_TYPE_OUTPUT_SELECTOR_PAD_NEGOTIATION_MODE (gst_output_selector_pad_negotiation_mode_get_type())
static GType
gst_output_selector_pad_negotiation_mode_get_type (void)
{
  static GType pad_negotiation_mode_type = 0;
  static GEnumValue pad_negotiation_modes[] = {
    {GST_OUTPUT_SELECTOR_PAD_NEGOTIATION_MODE_NONE, "None", "none"},
    {GST_OUTPUT_SELECTOR_PAD_NEGOTIATION_MODE_ALL, "All", "all"},
    {GST_OUTPUT_SELECTOR_PAD_NEGOTIATION_MODE_ACTIVE, "Active", "active"},
    {0, NULL, NULL}
  };

  if (!pad_negotiation_mode_type) {
    pad_negotiation_mode_type =
        g_enum_register_static ("GstOutputSelectorPadNegotiationMode",
        pad_negotiation_modes);
  }
  return pad_negotiation_mode_type;
}


enum
{
  PROP_0,
  PROP_ACTIVE_PAD,
  PROP_RESEND_LATEST,
  PROP_PAD_NEGOTIATION_MODE
};

#define DEFAULT_PAD_NEGOTIATION_MODE GST_OUTPUT_SELECTOR_PAD_NEGOTIATION_MODE_ALL

#define _do_init \
GST_DEBUG_CATEGORY_INIT (output_selector_debug, \
        "output-selector", 0, "Output stream selector");
#define gst_output_selector_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstOutputSelector, gst_output_selector,
    GST_TYPE_ELEMENT, _do_init);

static void gst_output_selector_dispose (GObject * object);
static void gst_output_selector_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec);
static void gst_output_selector_get_property (GObject * object,
    guint prop_id, GValue * value, GParamSpec * pspec);
static GstPad *gst_output_selector_request_new_pad (GstElement * element,
    GstPadTemplate * templ, const gchar * unused, const GstCaps * caps);
static void gst_output_selector_release_pad (GstElement * element,
    GstPad * pad);
static GstFlowReturn gst_output_selector_chain (GstPad * pad,
    GstObject * parent, GstBuffer * buf);
static GstStateChangeReturn gst_output_selector_change_state (GstElement *
    element, GstStateChange transition);
static gboolean gst_output_selector_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static gboolean gst_output_selector_query (GstPad * pad, GstObject * parent,
    GstQuery * query);
static void gst_output_selector_switch_pad_negotiation_mode (GstOutputSelector *
    sel, gint mode);

static void
gst_output_selector_class_init (GstOutputSelectorClass * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);
  GstElementClass *gstelement_class = GST_ELEMENT_CLASS (klass);

  gobject_class->dispose = gst_output_selector_dispose;

  gobject_class->set_property = gst_output_selector_set_property;
  gobject_class->get_property = gst_output_selector_get_property;

  g_object_class_install_property (gobject_class, PROP_ACTIVE_PAD,
      g_param_spec_object ("active-pad", "Active pad",
          "Currently active src pad", GST_TYPE_PAD,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_RESEND_LATEST,
      g_param_spec_boolean ("resend-latest", "Resend latest buffer",
          "Resend latest buffer after a switch to a new pad", FALSE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_PAD_NEGOTIATION_MODE,
      g_param_spec_enum ("pad-negotiation-mode", "Pad negotiation mode",
          "The mode to be used for pad negotiation",
          GST_TYPE_OUTPUT_SELECTOR_PAD_NEGOTIATION_MODE,
          DEFAULT_PAD_NEGOTIATION_MODE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gst_element_class_set_static_metadata (gstelement_class, "Output selector",
      "Generic", "1-to-N output stream selector",
      "Stefan Kost <stefan.kost@nokia.com>");
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&gst_output_selector_sink_factory));
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&gst_output_selector_src_factory));

  gstelement_class->request_new_pad =
      GST_DEBUG_FUNCPTR (gst_output_selector_request_new_pad);
  gstelement_class->release_pad =
      GST_DEBUG_FUNCPTR (gst_output_selector_release_pad);

  gstelement_class->change_state = gst_output_selector_change_state;
}

static void
gst_output_selector_init (GstOutputSelector * sel)
{
  sel->sinkpad =
      gst_pad_new_from_static_template (&gst_output_selector_sink_factory,
      "sink");
  gst_pad_set_chain_function (sel->sinkpad,
      GST_DEBUG_FUNCPTR (gst_output_selector_chain));
  gst_pad_set_event_function (sel->sinkpad,
      GST_DEBUG_FUNCPTR (gst_output_selector_event));
  gst_pad_set_query_function (sel->sinkpad,
      GST_DEBUG_FUNCPTR (gst_output_selector_query));

  gst_element_add_pad (GST_ELEMENT (sel), sel->sinkpad);

  /* srcpad management */
  sel->active_srcpad = NULL;
  sel->nb_srcpads = 0;
  gst_segment_init (&sel->segment, GST_FORMAT_UNDEFINED);
  sel->pending_srcpad = NULL;

  sel->resend_latest = FALSE;
  sel->latest_buffer = NULL;
  gst_output_selector_switch_pad_negotiation_mode (sel,
      DEFAULT_PAD_NEGOTIATION_MODE);
}

static void
gst_output_selector_reset (GstOutputSelector * osel)
{
  if (osel->pending_srcpad != NULL) {
    gst_object_unref (osel->pending_srcpad);
    osel->pending_srcpad = NULL;
  }
  if (osel->latest_buffer != NULL) {
    gst_buffer_unref (osel->latest_buffer);
    osel->latest_buffer = NULL;
  }
  gst_segment_init (&osel->segment, GST_FORMAT_UNDEFINED);
}

static void
gst_output_selector_dispose (GObject * object)
{
  GstOutputSelector *osel = GST_OUTPUT_SELECTOR (object);

  gst_output_selector_reset (osel);

  G_OBJECT_CLASS (parent_class)->dispose (object);
}

static void
gst_output_selector_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstOutputSelector *sel = GST_OUTPUT_SELECTOR (object);

  switch (prop_id) {
    case PROP_ACTIVE_PAD:
    {
      GstPad *next_pad;

      next_pad = g_value_get_object (value);

      GST_INFO_OBJECT (sel, "Activating pad %s:%s",
          GST_DEBUG_PAD_NAME (next_pad));

      GST_OBJECT_LOCK (object);
      if (next_pad != sel->active_srcpad) {
        /* switch to new srcpad in next chain run */
        if (sel->pending_srcpad != NULL) {
          GST_INFO ("replacing pending switch");
          gst_object_unref (sel->pending_srcpad);
        }
        if (next_pad)
          gst_object_ref (next_pad);
        sel->pending_srcpad = next_pad;
      } else {
        GST_INFO ("pad already active");
        if (sel->pending_srcpad != NULL) {
          gst_object_unref (sel->pending_srcpad);
          sel->pending_srcpad = NULL;
        }
      }
      GST_OBJECT_UNLOCK (object);
      break;
    }
    case PROP_RESEND_LATEST:{
      sel->resend_latest = g_value_get_boolean (value);
      break;
    }
    case PROP_PAD_NEGOTIATION_MODE:{
      gst_output_selector_switch_pad_negotiation_mode (sel,
          g_value_get_enum (value));
      break;
    }
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_output_selector_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstOutputSelector *sel = GST_OUTPUT_SELECTOR (object);

  switch (prop_id) {
    case PROP_ACTIVE_PAD:
      GST_OBJECT_LOCK (object);
      g_value_set_object (value,
          sel->pending_srcpad ? sel->pending_srcpad : sel->active_srcpad);
      GST_OBJECT_UNLOCK (object);
      break;
    case PROP_RESEND_LATEST:{
      GST_OBJECT_LOCK (object);
      g_value_set_boolean (value, sel->resend_latest);
      GST_OBJECT_UNLOCK (object);
      break;
    }
    case PROP_PAD_NEGOTIATION_MODE:
      g_value_set_enum (value, sel->pad_negotiation_mode);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static GstPad *
gst_output_selector_get_active (GstOutputSelector * sel)
{
  GstPad *active = NULL;

  GST_OBJECT_LOCK (sel);
  if (sel->pending_srcpad)
    active = gst_object_ref (sel->pending_srcpad);
  else if (sel->active_srcpad)
    active = gst_object_ref (sel->active_srcpad);
  GST_OBJECT_UNLOCK (sel);

  return active;
}

static void
gst_output_selector_switch_pad_negotiation_mode (GstOutputSelector * sel,
    gint mode)
{
  sel->pad_negotiation_mode = mode;
}

static gboolean
forward_sticky_events (GstPad * pad, GstEvent ** event, gpointer user_data)
{
  GstPad *srcpad = GST_PAD_CAST (user_data);

  gst_pad_push_event (srcpad, gst_event_ref (*event));

  return TRUE;
}

static GstPad *
gst_output_selector_request_new_pad (GstElement * element,
    GstPadTemplate * templ, const gchar * name, const GstCaps * caps)
{
  gchar *padname;
  GstPad *srcpad;
  GstOutputSelector *osel;

  osel = GST_OUTPUT_SELECTOR (element);

  GST_DEBUG_OBJECT (osel, "requesting pad");

  GST_OBJECT_LOCK (osel);
  padname = g_strdup_printf ("src_%u", osel->nb_srcpads++);
  srcpad = gst_pad_new_from_template (templ, padname);
  GST_OBJECT_UNLOCK (osel);

  gst_pad_set_active (srcpad, TRUE);

  /* Forward sticky events to the new srcpad */
  gst_pad_sticky_events_foreach (osel->sinkpad, forward_sticky_events, srcpad);

  gst_element_add_pad (GST_ELEMENT (osel), srcpad);

  /* Set the first requested src pad as active by default */
  if (osel->active_srcpad == NULL) {
    osel->active_srcpad = srcpad;
  }
  g_free (padname);

  return srcpad;
}

static void
gst_output_selector_release_pad (GstElement * element, GstPad * pad)
{
  GstOutputSelector *osel;

  osel = GST_OUTPUT_SELECTOR (element);

  GST_DEBUG_OBJECT (osel, "releasing pad");

  gst_pad_set_active (pad, FALSE);

  gst_element_remove_pad (GST_ELEMENT_CAST (osel), pad);
}

static gboolean
gst_output_selector_switch (GstOutputSelector * osel)
{
  gboolean res = FALSE;
  GstEvent *ev = NULL;
  GstSegment *seg = NULL;

  /* Switch */
  GST_OBJECT_LOCK (GST_OBJECT (osel));
  GST_INFO_OBJECT (osel, "switching to pad %" GST_PTR_FORMAT,
      osel->pending_srcpad);
  if (gst_pad_is_linked (osel->pending_srcpad)) {
    osel->active_srcpad = osel->pending_srcpad;
    res = TRUE;
  }
  gst_object_unref (osel->pending_srcpad);
  osel->pending_srcpad = NULL;
  GST_OBJECT_UNLOCK (GST_OBJECT (osel));

  /* Send SEGMENT event and latest buffer if switching succeeded
   * and we already have a valid segment configured */
  if (res) {
    gst_pad_sticky_events_foreach (osel->sinkpad, forward_sticky_events,
        osel->active_srcpad);

    /* update segment if required */
    if (osel->segment.format != GST_FORMAT_UNDEFINED) {
      /* Send SEGMENT to the pad we are going to switch to */
      seg = &osel->segment;
      /* If resending then mark segment start and position accordingly */
      if (osel->resend_latest && osel->latest_buffer &&
          GST_BUFFER_TIMESTAMP_IS_VALID (osel->latest_buffer)) {
        seg->position = GST_BUFFER_TIMESTAMP (osel->latest_buffer);
      }

      ev = gst_event_new_segment (seg);

      if (!gst_pad_push_event (osel->active_srcpad, ev)) {
        GST_WARNING_OBJECT (osel,
            "newsegment handling failed in %" GST_PTR_FORMAT,
            osel->active_srcpad);
      }
    }

    /* Resend latest buffer to newly switched pad */
    if (osel->resend_latest && osel->latest_buffer) {
      GST_INFO ("resending latest buffer");
      gst_pad_push (osel->active_srcpad, gst_buffer_ref (osel->latest_buffer));
    }
  } else {
    GST_WARNING_OBJECT (osel, "switch failed, pad not linked");
  }

  return res;
}

static GstFlowReturn
gst_output_selector_chain (GstPad * pad, GstObject * parent, GstBuffer * buf)
{
  GstFlowReturn res;
  GstOutputSelector *osel;
  GstClockTime position, duration;

  osel = GST_OUTPUT_SELECTOR (parent);

  /*
   * The _switch function might push a buffer if 'resend-latest' is true.
   *
   * Elements/Applications (e.g. camerabin) might use pad probes to
   * switch output-selector's active pad. If we simply switch and don't
   * recheck any pending pad switch the following codepath could end
   * up pushing a buffer on a non-active pad. This is bad.
   *
   * So we always should check the pending_srcpad before going further down
   * the chain and pushing the new buffer
   */
  while (osel->pending_srcpad) {
    /* Do the switch */
    gst_output_selector_switch (osel);
  }

  if (osel->latest_buffer) {
    gst_buffer_unref (osel->latest_buffer);
    osel->latest_buffer = NULL;
  }

  if (osel->resend_latest) {
    /* Keep reference to latest buffer to resend it after switch */
    osel->latest_buffer = gst_buffer_ref (buf);
  }

  /* Keep track of last stop and use it in SEGMENT start after
     switching to a new src pad */
  position = GST_BUFFER_TIMESTAMP (buf);
  if (GST_CLOCK_TIME_IS_VALID (position)) {
    duration = GST_BUFFER_DURATION (buf);
    if (GST_CLOCK_TIME_IS_VALID (duration)) {
      position += duration;
    }
    GST_LOG_OBJECT (osel, "setting last stop %" GST_TIME_FORMAT,
        GST_TIME_ARGS (position));
    osel->segment.position = position;
  }

  GST_LOG_OBJECT (osel, "pushing buffer to %" GST_PTR_FORMAT,
      osel->active_srcpad);
  res = gst_pad_push (osel->active_srcpad, buf);

  return res;
}

static GstStateChangeReturn
gst_output_selector_change_state (GstElement * element,
    GstStateChange transition)
{
  GstOutputSelector *sel;
  GstStateChangeReturn result;

  sel = GST_OUTPUT_SELECTOR (element);

  switch (transition) {
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      break;
    default:
      break;
  }

  result = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);

  switch (transition) {
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      gst_output_selector_reset (sel);
      break;
    default:
      break;
  }

  return result;
}

static gboolean
gst_output_selector_forward_event (GstOutputSelector * sel, GstEvent * event)
{
  gboolean res = TRUE;
  GstPad *active;

  switch (sel->pad_negotiation_mode) {
    case GST_OUTPUT_SELECTOR_PAD_NEGOTIATION_MODE_ALL:
      /* Send to all src pads */
      res = gst_pad_event_default (sel->sinkpad, GST_OBJECT_CAST (sel), event);
      break;
    case GST_OUTPUT_SELECTOR_PAD_NEGOTIATION_MODE_NONE:
      gst_event_unref (event);
      break;
    default:
      active = gst_output_selector_get_active (sel);
      if (active) {
        res = gst_pad_push_event (active, event);
        gst_object_unref (active);
      } else {
        gst_event_unref (event);
      }
      break;
  }

  return res;
}

static gboolean
gst_output_selector_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  gboolean res = TRUE;
  GstOutputSelector *sel;
  GstPad *active = NULL;

  sel = GST_OUTPUT_SELECTOR (parent);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_SEGMENT:
    {
      gst_event_copy_segment (event, &sel->segment);

      GST_DEBUG_OBJECT (sel, "configured SEGMENT %" GST_SEGMENT_FORMAT,
          &sel->segment);

      res = gst_output_selector_forward_event (sel, event);
      break;
    }
    default:
    {
      if (GST_EVENT_IS_STICKY (event)) {
        res = gst_output_selector_forward_event (sel, event);
      } else {
        /* Send other events to pending or active src pad */
        active = gst_output_selector_get_active (sel);
        if (active) {
          res = gst_pad_push_event (active, event);
          gst_object_unref (active);
        } else {
          gst_event_unref (event);
        }
      }
      break;
    }
  }

  return res;
}

static gboolean
gst_output_selector_query (GstPad * pad, GstObject * parent, GstQuery * query)
{
  gboolean res = TRUE;
  GstOutputSelector *sel;
  GstPad *active = NULL;

  sel = GST_OUTPUT_SELECTOR (parent);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_CAPS:
    {
      switch (sel->pad_negotiation_mode) {
        case GST_OUTPUT_SELECTOR_PAD_NEGOTIATION_MODE_ALL:
          /* Send caps to all src pads */
          res = gst_pad_proxy_query_caps (pad, query);
          break;
        case GST_OUTPUT_SELECTOR_PAD_NEGOTIATION_MODE_NONE:
          res = FALSE;
          break;
        default:
          active = gst_output_selector_get_active (sel);
          if (active) {
            res = gst_pad_peer_query (active, query);
            gst_object_unref (active);
          } else {
            res = FALSE;
          }
          break;
      }
      break;
    }
    default:
      res = gst_pad_query_default (pad, parent, query);
      break;
  }
  return res;
}
