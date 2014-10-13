/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2005 Wim Taymans <wim@fluendo.com>
 *
 * gstfakesink.c:
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
 * SECTION:element-fakesink
 * @see_also: #GstFakeSrc
 *
 * Dummy sink that swallows everything.
 * 
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * gst-launch audiotestsrc num-buffers=1000 ! fakesink sync=false
 * ]| Render 1000 audio buffers (of default size) as fast as possible.
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include "gstelements_private.h"
#include "gstfakesink.h"
#include <string.h>

static GstStaticPadTemplate sinktemplate = GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

GST_DEBUG_CATEGORY_STATIC (gst_fake_sink_debug);
#define GST_CAT_DEFAULT gst_fake_sink_debug

/* FakeSink signals and args */
enum
{
  /* FILL ME */
  SIGNAL_HANDOFF,
  SIGNAL_PREROLL_HANDOFF,
  LAST_SIGNAL
};

#define DEFAULT_SYNC FALSE

#define DEFAULT_STATE_ERROR FAKE_SINK_STATE_ERROR_NONE
#define DEFAULT_SILENT TRUE
#define DEFAULT_DUMP FALSE
#define DEFAULT_SIGNAL_HANDOFFS FALSE
#define DEFAULT_LAST_MESSAGE NULL
#define DEFAULT_CAN_ACTIVATE_PUSH TRUE
#define DEFAULT_CAN_ACTIVATE_PULL FALSE
#define DEFAULT_NUM_BUFFERS -1

enum
{
  PROP_0,
  PROP_STATE_ERROR,
  PROP_SILENT,
  PROP_DUMP,
  PROP_SIGNAL_HANDOFFS,
  PROP_LAST_MESSAGE,
  PROP_CAN_ACTIVATE_PUSH,
  PROP_CAN_ACTIVATE_PULL,
  PROP_NUM_BUFFERS
};

#define GST_TYPE_FAKE_SINK_STATE_ERROR (gst_fake_sink_state_error_get_type())
static GType
gst_fake_sink_state_error_get_type (void)
{
  static GType fakesink_state_error_type = 0;
  static const GEnumValue fakesink_state_error[] = {
    {FAKE_SINK_STATE_ERROR_NONE, "No state change errors", "none"},
    {FAKE_SINK_STATE_ERROR_NULL_READY,
        "Fail state change from NULL to READY", "null-to-ready"},
    {FAKE_SINK_STATE_ERROR_READY_PAUSED,
        "Fail state change from READY to PAUSED", "ready-to-paused"},
    {FAKE_SINK_STATE_ERROR_PAUSED_PLAYING,
        "Fail state change from PAUSED to PLAYING", "paused-to-playing"},
    {FAKE_SINK_STATE_ERROR_PLAYING_PAUSED,
        "Fail state change from PLAYING to PAUSED", "playing-to-paused"},
    {FAKE_SINK_STATE_ERROR_PAUSED_READY,
        "Fail state change from PAUSED to READY", "paused-to-ready"},
    {FAKE_SINK_STATE_ERROR_READY_NULL,
        "Fail state change from READY to NULL", "ready-to-null"},
    {0, NULL, NULL},
  };

  if (!fakesink_state_error_type) {
    fakesink_state_error_type =
        g_enum_register_static ("GstFakeSinkStateError", fakesink_state_error);
  }
  return fakesink_state_error_type;
}

#define _do_init \
    GST_DEBUG_CATEGORY_INIT (gst_fake_sink_debug, "fakesink", 0, "fakesink element");
#define gst_fake_sink_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstFakeSink, gst_fake_sink, GST_TYPE_BASE_SINK,
    _do_init);

static void gst_fake_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_fake_sink_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);
static void gst_fake_sink_finalize (GObject * obj);

static GstStateChangeReturn gst_fake_sink_change_state (GstElement * element,
    GstStateChange transition);

static GstFlowReturn gst_fake_sink_preroll (GstBaseSink * bsink,
    GstBuffer * buffer);
static GstFlowReturn gst_fake_sink_render (GstBaseSink * bsink,
    GstBuffer * buffer);
static gboolean gst_fake_sink_event (GstBaseSink * bsink, GstEvent * event);
static gboolean gst_fake_sink_query (GstBaseSink * bsink, GstQuery * query);

static guint gst_fake_sink_signals[LAST_SIGNAL] = { 0 };

static GParamSpec *pspec_last_message = NULL;

static void
gst_fake_sink_class_init (GstFakeSinkClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstBaseSinkClass *gstbase_sink_class;

  gobject_class = G_OBJECT_CLASS (klass);
  gstelement_class = GST_ELEMENT_CLASS (klass);
  gstbase_sink_class = GST_BASE_SINK_CLASS (klass);

  gobject_class->set_property = gst_fake_sink_set_property;
  gobject_class->get_property = gst_fake_sink_get_property;
  gobject_class->finalize = gst_fake_sink_finalize;

  g_object_class_install_property (gobject_class, PROP_STATE_ERROR,
      g_param_spec_enum ("state-error", "State Error",
          "Generate a state change error", GST_TYPE_FAKE_SINK_STATE_ERROR,
          DEFAULT_STATE_ERROR, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  pspec_last_message = g_param_spec_string ("last-message", "Last Message",
      "The message describing current status", DEFAULT_LAST_MESSAGE,
      G_PARAM_READABLE | G_PARAM_STATIC_STRINGS);
  g_object_class_install_property (gobject_class, PROP_LAST_MESSAGE,
      pspec_last_message);
  g_object_class_install_property (gobject_class, PROP_SIGNAL_HANDOFFS,
      g_param_spec_boolean ("signal-handoffs", "Signal handoffs",
          "Send a signal before unreffing the buffer", DEFAULT_SIGNAL_HANDOFFS,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_SILENT,
      g_param_spec_boolean ("silent", "Silent",
          "Don't produce last_message events", DEFAULT_SILENT,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_DUMP,
      g_param_spec_boolean ("dump", "Dump", "Dump buffer contents to stdout",
          DEFAULT_DUMP, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class,
      PROP_CAN_ACTIVATE_PUSH,
      g_param_spec_boolean ("can-activate-push", "Can activate push",
          "Can activate in push mode", DEFAULT_CAN_ACTIVATE_PUSH,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class,
      PROP_CAN_ACTIVATE_PULL,
      g_param_spec_boolean ("can-activate-pull", "Can activate pull",
          "Can activate in pull mode", DEFAULT_CAN_ACTIVATE_PULL,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_NUM_BUFFERS,
      g_param_spec_int ("num-buffers", "num-buffers",
          "Number of buffers to accept going EOS", -1, G_MAXINT,
          DEFAULT_NUM_BUFFERS, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstFakeSink::handoff:
   * @fakesink: the fakesink instance
   * @buffer: the buffer that just has been received
   * @pad: the pad that received it
   *
   * This signal gets emitted before unreffing the buffer.
   */
  gst_fake_sink_signals[SIGNAL_HANDOFF] =
      g_signal_new ("handoff", G_TYPE_FROM_CLASS (klass), G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstFakeSinkClass, handoff), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 2,
      GST_TYPE_BUFFER | G_SIGNAL_TYPE_STATIC_SCOPE, GST_TYPE_PAD);

  /**
   * GstFakeSink::preroll-handoff:
   * @fakesink: the fakesink instance
   * @buffer: the buffer that just has been received
   * @pad: the pad that received it
   *
   * This signal gets emitted before unreffing the buffer.
   */
  gst_fake_sink_signals[SIGNAL_PREROLL_HANDOFF] =
      g_signal_new ("preroll-handoff", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, G_STRUCT_OFFSET (GstFakeSinkClass, preroll_handoff),
      NULL, NULL, g_cclosure_marshal_generic, G_TYPE_NONE, 2,
      GST_TYPE_BUFFER | G_SIGNAL_TYPE_STATIC_SCOPE, GST_TYPE_PAD);

  gst_element_class_set_static_metadata (gstelement_class,
      "Fake Sink",
      "Sink",
      "Black hole for data",
      "Erik Walthinsen <omega@cse.ogi.edu>, "
      "Wim Taymans <wim@fluendo.com>, "
      "Mr. 'frag-me-more' Vanderwingo <wingo@fluendo.com>");
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&sinktemplate));

  gstelement_class->change_state =
      GST_DEBUG_FUNCPTR (gst_fake_sink_change_state);

  gstbase_sink_class->event = GST_DEBUG_FUNCPTR (gst_fake_sink_event);
  gstbase_sink_class->preroll = GST_DEBUG_FUNCPTR (gst_fake_sink_preroll);
  gstbase_sink_class->render = GST_DEBUG_FUNCPTR (gst_fake_sink_render);
  gstbase_sink_class->query = GST_DEBUG_FUNCPTR (gst_fake_sink_query);
}

static void
gst_fake_sink_init (GstFakeSink * fakesink)
{
  fakesink->silent = DEFAULT_SILENT;
  fakesink->dump = DEFAULT_DUMP;
  fakesink->last_message = g_strdup (DEFAULT_LAST_MESSAGE);
  fakesink->state_error = DEFAULT_STATE_ERROR;
  fakesink->signal_handoffs = DEFAULT_SIGNAL_HANDOFFS;
  fakesink->num_buffers = DEFAULT_NUM_BUFFERS;

  gst_base_sink_set_sync (GST_BASE_SINK (fakesink), DEFAULT_SYNC);
}

static void
gst_fake_sink_finalize (GObject * obj)
{
  G_OBJECT_CLASS (parent_class)->finalize (obj);
}

static void
gst_fake_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstFakeSink *sink;

  sink = GST_FAKE_SINK (object);

  switch (prop_id) {
    case PROP_STATE_ERROR:
      sink->state_error = (GstFakeSinkStateError) g_value_get_enum (value);
      break;
    case PROP_SILENT:
      sink->silent = g_value_get_boolean (value);
      break;
    case PROP_DUMP:
      sink->dump = g_value_get_boolean (value);
      break;
    case PROP_SIGNAL_HANDOFFS:
      sink->signal_handoffs = g_value_get_boolean (value);
      break;
    case PROP_CAN_ACTIVATE_PUSH:
      GST_BASE_SINK (sink)->can_activate_push = g_value_get_boolean (value);
      break;
    case PROP_CAN_ACTIVATE_PULL:
      GST_BASE_SINK (sink)->can_activate_pull = g_value_get_boolean (value);
      break;
    case PROP_NUM_BUFFERS:
      sink->num_buffers = g_value_get_int (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_fake_sink_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstFakeSink *sink;

  sink = GST_FAKE_SINK (object);

  switch (prop_id) {
    case PROP_STATE_ERROR:
      g_value_set_enum (value, sink->state_error);
      break;
    case PROP_SILENT:
      g_value_set_boolean (value, sink->silent);
      break;
    case PROP_DUMP:
      g_value_set_boolean (value, sink->dump);
      break;
    case PROP_SIGNAL_HANDOFFS:
      g_value_set_boolean (value, sink->signal_handoffs);
      break;
    case PROP_LAST_MESSAGE:
      GST_OBJECT_LOCK (sink);
      g_value_set_string (value, sink->last_message);
      GST_OBJECT_UNLOCK (sink);
      break;
    case PROP_CAN_ACTIVATE_PUSH:
      g_value_set_boolean (value, GST_BASE_SINK (sink)->can_activate_push);
      break;
    case PROP_CAN_ACTIVATE_PULL:
      g_value_set_boolean (value, GST_BASE_SINK (sink)->can_activate_pull);
      break;
    case PROP_NUM_BUFFERS:
      g_value_set_int (value, sink->num_buffers);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_fake_sink_notify_last_message (GstFakeSink * sink)
{
  g_object_notify_by_pspec ((GObject *) sink, pspec_last_message);
}

static gboolean
gst_fake_sink_event (GstBaseSink * bsink, GstEvent * event)
{
  GstFakeSink *sink = GST_FAKE_SINK (bsink);

  if (!sink->silent) {
    const GstStructure *s;
    const gchar *tstr;
    gchar *sstr;

    GST_OBJECT_LOCK (sink);
    g_free (sink->last_message);

    if (GST_EVENT_TYPE (event) == GST_EVENT_SINK_MESSAGE) {
      GstMessage *msg;
      const GstStructure *structure;

      gst_event_parse_sink_message (event, &msg);
      structure = gst_message_get_structure (msg);
      sstr = gst_structure_to_string (structure);
      sink->last_message =
          g_strdup_printf ("message ******* (%s:%s) M (type: %d, %s) %p",
          GST_DEBUG_PAD_NAME (GST_BASE_SINK_CAST (sink)->sinkpad),
          GST_MESSAGE_TYPE (msg), sstr, msg);
      gst_message_unref (msg);
    } else {
      tstr = gst_event_type_get_name (GST_EVENT_TYPE (event));

      if ((s = gst_event_get_structure (event))) {
        sstr = gst_structure_to_string (s);
      } else {
        sstr = g_strdup ("");
      }

      sink->last_message =
          g_strdup_printf ("event   ******* (%s:%s) E (type: %s (%d), %s) %p",
          GST_DEBUG_PAD_NAME (GST_BASE_SINK_CAST (sink)->sinkpad),
          tstr, GST_EVENT_TYPE (event), sstr, event);
    }
    g_free (sstr);
    GST_OBJECT_UNLOCK (sink);

    gst_fake_sink_notify_last_message (sink);
  }

  return GST_BASE_SINK_CLASS (parent_class)->event (bsink, event);
}

static GstFlowReturn
gst_fake_sink_preroll (GstBaseSink * bsink, GstBuffer * buffer)
{
  GstFakeSink *sink = GST_FAKE_SINK (bsink);

  if (sink->num_buffers_left == 0)
    goto eos;

  if (!sink->silent) {
    GST_OBJECT_LOCK (sink);
    g_free (sink->last_message);

    sink->last_message = g_strdup_printf ("preroll   ******* ");
    GST_OBJECT_UNLOCK (sink);

    gst_fake_sink_notify_last_message (sink);
  }
  if (sink->signal_handoffs) {
    g_signal_emit (sink,
        gst_fake_sink_signals[SIGNAL_PREROLL_HANDOFF], 0, buffer,
        bsink->sinkpad);
  }
  return GST_FLOW_OK;

  /* ERRORS */
eos:
  {
    GST_DEBUG_OBJECT (sink, "we are EOS");
    return GST_FLOW_EOS;
  }
}

static GstFlowReturn
gst_fake_sink_render (GstBaseSink * bsink, GstBuffer * buf)
{
  GstFakeSink *sink = GST_FAKE_SINK_CAST (bsink);

  if (sink->num_buffers_left == 0)
    goto eos;

  if (sink->num_buffers_left != -1)
    sink->num_buffers_left--;

  if (!sink->silent) {
    gchar dts_str[64], pts_str[64], dur_str[64];
    gchar *flag_str;

    GST_OBJECT_LOCK (sink);
    g_free (sink->last_message);

    if (GST_BUFFER_DTS (buf) != GST_CLOCK_TIME_NONE) {
      g_snprintf (dts_str, sizeof (dts_str), "%" GST_TIME_FORMAT,
          GST_TIME_ARGS (GST_BUFFER_DTS (buf)));
    } else {
      g_strlcpy (dts_str, "none", sizeof (dts_str));
    }

    if (GST_BUFFER_PTS (buf) != GST_CLOCK_TIME_NONE) {
      g_snprintf (pts_str, sizeof (pts_str), "%" GST_TIME_FORMAT,
          GST_TIME_ARGS (GST_BUFFER_PTS (buf)));
    } else {
      g_strlcpy (pts_str, "none", sizeof (pts_str));
    }

    if (GST_BUFFER_DURATION (buf) != GST_CLOCK_TIME_NONE) {
      g_snprintf (dur_str, sizeof (dur_str), "%" GST_TIME_FORMAT,
          GST_TIME_ARGS (GST_BUFFER_DURATION (buf)));
    } else {
      g_strlcpy (dur_str, "none", sizeof (dur_str));
    }

    flag_str = gst_buffer_get_flags_string (buf);

    sink->last_message =
        g_strdup_printf ("chain   ******* (%s:%s) (%u bytes, dts: %s, pts: %s"
        ", duration: %s, offset: %" G_GINT64_FORMAT ", offset_end: %"
        G_GINT64_FORMAT ", flags: %08x %s) %p",
        GST_DEBUG_PAD_NAME (GST_BASE_SINK_CAST (sink)->sinkpad),
        (guint) gst_buffer_get_size (buf), dts_str, pts_str,
        dur_str, GST_BUFFER_OFFSET (buf), GST_BUFFER_OFFSET_END (buf),
        GST_MINI_OBJECT_CAST (buf)->flags, flag_str, buf);
    g_free (flag_str);
    GST_OBJECT_UNLOCK (sink);

    gst_fake_sink_notify_last_message (sink);
  }
  if (sink->signal_handoffs)
    g_signal_emit (sink, gst_fake_sink_signals[SIGNAL_HANDOFF], 0, buf,
        bsink->sinkpad);

  if (sink->dump) {
    GstMapInfo info;

    gst_buffer_map (buf, &info, GST_MAP_READ);
    gst_util_dump_mem (info.data, info.size);
    gst_buffer_unmap (buf, &info);
  }
  if (sink->num_buffers_left == 0)
    goto eos;

  return GST_FLOW_OK;

  /* ERRORS */
eos:
  {
    GST_DEBUG_OBJECT (sink, "we are EOS");
    return GST_FLOW_EOS;
  }
}

static gboolean
gst_fake_sink_query (GstBaseSink * bsink, GstQuery * query)
{
  gboolean ret;

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_SEEKING:{
      GstFormat fmt;

      /* we don't supporting seeking */
      gst_query_parse_seeking (query, &fmt, NULL, NULL, NULL);
      gst_query_set_seeking (query, fmt, FALSE, 0, -1);
      ret = TRUE;
      break;
    }
    default:
      ret = GST_BASE_SINK_CLASS (parent_class)->query (bsink, query);
      break;
  }

  return ret;
}

static GstStateChangeReturn
gst_fake_sink_change_state (GstElement * element, GstStateChange transition)
{
  GstStateChangeReturn ret = GST_STATE_CHANGE_SUCCESS;
  GstFakeSink *fakesink = GST_FAKE_SINK (element);

  switch (transition) {
    case GST_STATE_CHANGE_NULL_TO_READY:
      if (fakesink->state_error == FAKE_SINK_STATE_ERROR_NULL_READY)
        goto error;
      break;
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      if (fakesink->state_error == FAKE_SINK_STATE_ERROR_READY_PAUSED)
        goto error;
      fakesink->num_buffers_left = fakesink->num_buffers;
      break;
    case GST_STATE_CHANGE_PAUSED_TO_PLAYING:
      if (fakesink->state_error == FAKE_SINK_STATE_ERROR_PAUSED_PLAYING)
        goto error;
      break;
    default:
      break;
  }

  ret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);

  switch (transition) {
    case GST_STATE_CHANGE_PLAYING_TO_PAUSED:
      if (fakesink->state_error == FAKE_SINK_STATE_ERROR_PLAYING_PAUSED)
        goto error;
      break;
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      if (fakesink->state_error == FAKE_SINK_STATE_ERROR_PAUSED_READY)
        goto error;
      break;
    case GST_STATE_CHANGE_READY_TO_NULL:
      if (fakesink->state_error == FAKE_SINK_STATE_ERROR_READY_NULL)
        goto error;
      GST_OBJECT_LOCK (fakesink);
      g_free (fakesink->last_message);
      fakesink->last_message = NULL;
      GST_OBJECT_UNLOCK (fakesink);
      break;
    default:
      break;
  }

  return ret;

  /* ERROR */
error:
  GST_ELEMENT_ERROR (element, CORE, STATE_CHANGE, (NULL),
      ("Erroring out on state change as requested"));
  return GST_STATE_CHANGE_FAILURE;
}
