/* GStreamer valve element
 *  Copyright 2007-2009 Collabora Ltd
 *   @author: Olivier Crete <olivier.crete@collabora.co.uk>
 *  Copyright 2007-2009 Nokia Corporation
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
 *
 */

/**
 * SECTION:element-valve
 *
 * The valve is a simple element that drops buffers when the #GstValve:drop
 * property is set to %TRUE and lets then through otherwise.
 *
 * Any downstream error received while the #GstValve:drop property is %FALSE
 * is ignored. So downstream element can be set to  %GST_STATE_NULL and removed,
 * without using pad blocking.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gstvalve.h"

#include <string.h>

GST_DEBUG_CATEGORY_STATIC (valve_debug);
#define GST_CAT_DEFAULT (valve_debug)

static GstStaticPadTemplate sinktemplate = GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

static GstStaticPadTemplate srctemplate = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

enum
{
  PROP_0,
  PROP_DROP
};

#define DEFAULT_DROP FALSE

static void gst_valve_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec);
static void gst_valve_get_property (GObject * object,
    guint prop_id, GValue * value, GParamSpec * pspec);

static GstFlowReturn gst_valve_chain (GstPad * pad, GstObject * parent,
    GstBuffer * buffer);
static gboolean gst_valve_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static gboolean gst_valve_query (GstPad * pad, GstObject * parent,
    GstQuery * query);

#define _do_init \
  GST_DEBUG_CATEGORY_INIT (valve_debug, "valve", 0, "Valve");
#define gst_valve_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstValve, gst_valve, GST_TYPE_ELEMENT, _do_init);

static void
gst_valve_class_init (GstValveClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;

  gobject_class = (GObjectClass *) klass;
  gstelement_class = (GstElementClass *) (klass);

  gobject_class->set_property = gst_valve_set_property;
  gobject_class->get_property = gst_valve_get_property;

  g_object_class_install_property (gobject_class, PROP_DROP,
      g_param_spec_boolean ("drop", "Drop buffers and events",
          "Whether to drop buffers and events or let them through",
          DEFAULT_DROP, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&srctemplate));
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&sinktemplate));

  gst_element_class_set_static_metadata (gstelement_class, "Valve element",
      "Filter", "Drops buffers and events or lets them through",
      "Olivier Crete <olivier.crete@collabora.co.uk>");
}

static void
gst_valve_init (GstValve * valve)
{
  valve->drop = FALSE;
  valve->discont = FALSE;

  valve->srcpad = gst_pad_new_from_static_template (&srctemplate, "src");
  gst_pad_set_event_function (valve->srcpad,
      GST_DEBUG_FUNCPTR (gst_valve_event));
  gst_pad_set_query_function (valve->srcpad,
      GST_DEBUG_FUNCPTR (gst_valve_query));
  GST_PAD_SET_PROXY_CAPS (valve->srcpad);
  gst_element_add_pad (GST_ELEMENT (valve), valve->srcpad);

  valve->sinkpad = gst_pad_new_from_static_template (&sinktemplate, "sink");
  gst_pad_set_chain_function (valve->sinkpad,
      GST_DEBUG_FUNCPTR (gst_valve_chain));
  gst_pad_set_event_function (valve->sinkpad,
      GST_DEBUG_FUNCPTR (gst_valve_event));
  gst_pad_set_query_function (valve->sinkpad,
      GST_DEBUG_FUNCPTR (gst_valve_query));
  GST_PAD_SET_PROXY_CAPS (valve->sinkpad);
  GST_PAD_SET_PROXY_ALLOCATION (valve->sinkpad);
  gst_element_add_pad (GST_ELEMENT (valve), valve->sinkpad);
}


static void
gst_valve_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec)
{
  GstValve *valve = GST_VALVE (object);

  switch (prop_id) {
    case PROP_DROP:
      g_atomic_int_set (&valve->drop, g_value_get_boolean (value));
      gst_pad_push_event (valve->sinkpad, gst_event_new_reconfigure ());
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_valve_get_property (GObject * object,
    guint prop_id, GValue * value, GParamSpec * pspec)
{
  GstValve *valve = GST_VALVE (object);

  switch (prop_id) {
    case PROP_DROP:
      g_value_set_boolean (value, g_atomic_int_get (&valve->drop));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}


static gboolean
forward_sticky_events (GstPad * pad, GstEvent ** event, gpointer user_data)
{
  GstValve *valve = user_data;

  if (!gst_pad_push_event (valve->srcpad, gst_event_ref (*event)))
    valve->need_repush_sticky = TRUE;

  return TRUE;
}

static void
gst_valve_repush_sticky (GstValve * valve)
{
  valve->need_repush_sticky = FALSE;
  gst_pad_sticky_events_foreach (valve->sinkpad, forward_sticky_events, valve);
}

static GstFlowReturn
gst_valve_chain (GstPad * pad, GstObject * parent, GstBuffer * buffer)
{
  GstValve *valve = GST_VALVE (parent);
  GstFlowReturn ret = GST_FLOW_OK;

  if (g_atomic_int_get (&valve->drop)) {
    gst_buffer_unref (buffer);
    valve->discont = TRUE;
  } else {
    if (valve->discont) {
      buffer = gst_buffer_make_writable (buffer);
      GST_BUFFER_FLAG_SET (buffer, GST_BUFFER_FLAG_DISCONT);
      valve->discont = FALSE;
    }

    if (valve->need_repush_sticky)
      gst_valve_repush_sticky (valve);

    ret = gst_pad_push (valve->srcpad, buffer);
  }


  /* Ignore errors if "drop" was changed while the thread was blocked
   * downwards
   */
  if (g_atomic_int_get (&valve->drop))
    ret = GST_FLOW_OK;

  return ret;
}


static gboolean
gst_valve_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  GstValve *valve;
  gboolean is_sticky = GST_EVENT_IS_STICKY (event);
  gboolean ret = TRUE;

  valve = GST_VALVE (parent);

  if (g_atomic_int_get (&valve->drop)) {
    valve->need_repush_sticky |= is_sticky;
    gst_event_unref (event);
  } else {
    if (valve->need_repush_sticky)
      gst_valve_repush_sticky (valve);
    ret = gst_pad_event_default (pad, parent, event);
  }

  /* Ignore errors if "drop" was changed while the thread was blocked
   * downwards.
   */
  if (g_atomic_int_get (&valve->drop)) {
    valve->need_repush_sticky |= is_sticky;
    ret = TRUE;
  }

  return ret;
}



static gboolean
gst_valve_query (GstPad * pad, GstObject * parent, GstQuery * query)
{
  GstValve *valve = GST_VALVE (parent);

  if (g_atomic_int_get (&valve->drop))
    return FALSE;

  return gst_pad_query_default (pad, parent, query);
}
