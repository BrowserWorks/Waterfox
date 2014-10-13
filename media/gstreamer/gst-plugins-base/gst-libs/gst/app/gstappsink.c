/* GStreamer
 * Copyright (C) 2007 David Schleef <ds@schleef.org>
 *           (C) 2008 Wim Taymans <wim.taymans@gmail.com>
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
 * SECTION:gstappsink
 * @short_description: Easy way for applications to extract samples from a
 *     pipeline
 * @see_also: #GstSample, #GstBaseSink, appsrc
 *
 * Appsink is a sink plugin that supports many different methods for making
 * the application get a handle on the GStreamer data in a pipeline. Unlike
 * most GStreamer elements, Appsink provides external API functions.
 *
 * appsink can be used by linking to the gstappsink.h header file to access the
 * methods or by using the appsink action signals and properties.
 *
 * The normal way of retrieving samples from appsink is by using the
 * gst_app_sink_pull_sample() and gst_app_sink_pull_preroll() methods.
 * These methods block until a sample becomes available in the sink or when the
 * sink is shut down or reaches EOS.
 *
 * Appsink will internally use a queue to collect buffers from the streaming
 * thread. If the application is not pulling samples fast enough, this queue
 * will consume a lot of memory over time. The "max-buffers" property can be
 * used to limit the queue size. The "drop" property controls whether the
 * streaming thread blocks or if older buffers are dropped when the maximum
 * queue size is reached. Note that blocking the streaming thread can negatively
 * affect real-time performance and should be avoided.
 *
 * If a blocking behaviour is not desirable, setting the "emit-signals" property
 * to %TRUE will make appsink emit the "new-sample" and "new-preroll" signals
 * when a sample can be pulled without blocking.
 *
 * The "caps" property on appsink can be used to control the formats that
 * appsink can receive. This property can contain non-fixed caps, the format of
 * the pulled samples can be obtained by getting the sample caps.
 *
 * If one of the pull-preroll or pull-sample methods return %NULL, the appsink
 * is stopped or in the EOS state. You can check for the EOS state with the
 * "eos" property or with the gst_app_sink_is_eos() method.
 *
 * The eos signal can also be used to be informed when the EOS state is reached
 * to avoid polling.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/gst.h>
#include <gst/base/gstbasesink.h>
#include <gst/gstbuffer.h>

#include <string.h>

#include "gstapp-marshal.h"
#include "gstappsink.h"

struct _GstAppSinkPrivate
{
  GstCaps *caps;
  gboolean emit_signals;
  guint num_buffers;
  guint max_buffers;
  gboolean drop;

  GCond cond;
  GMutex mutex;
  GQueue *queue;
  GstBuffer *preroll;
  GstCaps *preroll_caps;
  GstCaps *last_caps;
  GstSegment last_segment;
  gboolean flushing;
  gboolean unlock;
  gboolean started;
  gboolean is_eos;

  GstAppSinkCallbacks callbacks;
  gpointer user_data;
  GDestroyNotify notify;
};

GST_DEBUG_CATEGORY_STATIC (app_sink_debug);
#define GST_CAT_DEFAULT app_sink_debug

enum
{
  /* signals */
  SIGNAL_EOS,
  SIGNAL_NEW_PREROLL,
  SIGNAL_NEW_SAMPLE,

  /* actions */
  SIGNAL_PULL_PREROLL,
  SIGNAL_PULL_SAMPLE,

  LAST_SIGNAL
};

#define DEFAULT_PROP_EOS		TRUE
#define DEFAULT_PROP_EMIT_SIGNALS	FALSE
#define DEFAULT_PROP_MAX_BUFFERS	0
#define DEFAULT_PROP_DROP		FALSE

enum
{
  PROP_0,
  PROP_CAPS,
  PROP_EOS,
  PROP_EMIT_SIGNALS,
  PROP_MAX_BUFFERS,
  PROP_DROP,
  PROP_LAST
};

static GstStaticPadTemplate gst_app_sink_template =
GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

static void gst_app_sink_uri_handler_init (gpointer g_iface,
    gpointer iface_data);

static void gst_app_sink_dispose (GObject * object);
static void gst_app_sink_finalize (GObject * object);

static void gst_app_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_app_sink_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

static gboolean gst_app_sink_unlock_start (GstBaseSink * bsink);
static gboolean gst_app_sink_unlock_stop (GstBaseSink * bsink);
static gboolean gst_app_sink_start (GstBaseSink * psink);
static gboolean gst_app_sink_stop (GstBaseSink * psink);
static gboolean gst_app_sink_event (GstBaseSink * sink, GstEvent * event);
static gboolean gst_app_sink_query (GstBaseSink * bsink, GstQuery * query);
static GstFlowReturn gst_app_sink_preroll (GstBaseSink * psink,
    GstBuffer * buffer);
static GstFlowReturn gst_app_sink_render (GstBaseSink * psink,
    GstBuffer * buffer);
static gboolean gst_app_sink_setcaps (GstBaseSink * sink, GstCaps * caps);
static GstCaps *gst_app_sink_getcaps (GstBaseSink * psink, GstCaps * filter);

static guint gst_app_sink_signals[LAST_SIGNAL] = { 0 };

#define gst_app_sink_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstAppSink, gst_app_sink, GST_TYPE_BASE_SINK,
    G_IMPLEMENT_INTERFACE (GST_TYPE_URI_HANDLER,
        gst_app_sink_uri_handler_init));

static void
gst_app_sink_class_init (GstAppSinkClass * klass)
{
  GObjectClass *gobject_class = (GObjectClass *) klass;
  GstElementClass *element_class = (GstElementClass *) klass;
  GstBaseSinkClass *basesink_class = (GstBaseSinkClass *) klass;

  GST_DEBUG_CATEGORY_INIT (app_sink_debug, "appsink", 0, "appsink element");

  gobject_class->dispose = gst_app_sink_dispose;
  gobject_class->finalize = gst_app_sink_finalize;

  gobject_class->set_property = gst_app_sink_set_property;
  gobject_class->get_property = gst_app_sink_get_property;

  g_object_class_install_property (gobject_class, PROP_CAPS,
      g_param_spec_boxed ("caps", "Caps",
          "The allowed caps for the sink pad", GST_TYPE_CAPS,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_EOS,
      g_param_spec_boolean ("eos", "EOS",
          "Check if the sink is EOS or not started", DEFAULT_PROP_EOS,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_EMIT_SIGNALS,
      g_param_spec_boolean ("emit-signals", "Emit signals",
          "Emit new-preroll and new-sample signals",
          DEFAULT_PROP_EMIT_SIGNALS,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_MAX_BUFFERS,
      g_param_spec_uint ("max-buffers", "Max Buffers",
          "The maximum number of buffers to queue internally (0 = unlimited)",
          0, G_MAXUINT, DEFAULT_PROP_MAX_BUFFERS,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_DROP,
      g_param_spec_boolean ("drop", "Drop",
          "Drop old buffers when the buffer queue is filled", DEFAULT_PROP_DROP,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstAppSink::eos:
   * @appsink: the appsink element that emitted the signal
   *
   * Signal that the end-of-stream has been reached. This signal is emitted from
   * the steaming thread.
   */
  gst_app_sink_signals[SIGNAL_EOS] =
      g_signal_new ("eos", G_TYPE_FROM_CLASS (klass), G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstAppSinkClass, eos),
      NULL, NULL, g_cclosure_marshal_VOID__VOID, G_TYPE_NONE, 0, G_TYPE_NONE);
  /**
   * GstAppSink::new-preroll:
   * @appsink: the appsink element that emitted the signal
   *
   * Signal that a new preroll sample is available.
   *
   * This signal is emitted from the steaming thread and only when the
   * "emit-signals" property is %TRUE.
   *
   * The new preroll sample can be retrieved with the "pull-preroll" action
   * signal or gst_app_sink_pull_preroll() either from this signal callback
   * or from any other thread.
   *
   * Note that this signal is only emitted when the "emit-signals" property is
   * set to %TRUE, which it is not by default for performance reasons.
   */
  gst_app_sink_signals[SIGNAL_NEW_PREROLL] =
      g_signal_new ("new-preroll", G_TYPE_FROM_CLASS (klass), G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstAppSinkClass, new_preroll),
      NULL, NULL, __gst_app_marshal_ENUM__VOID, GST_TYPE_FLOW_RETURN, 0,
      G_TYPE_NONE);
  /**
   * GstAppSink::new-sample:
   * @appsink: the appsink element that emited the signal
   *
   * Signal that a new sample is available.
   *
   * This signal is emitted from the steaming thread and only when the
   * "emit-signals" property is %TRUE.
   *
   * The new sample can be retrieved with the "pull-sample" action
   * signal or gst_app_sink_pull_sample() either from this signal callback
   * or from any other thread.
   *
   * Note that this signal is only emitted when the "emit-signals" property is
   * set to %TRUE, which it is not by default for performance reasons.
   */
  gst_app_sink_signals[SIGNAL_NEW_SAMPLE] =
      g_signal_new ("new-sample", G_TYPE_FROM_CLASS (klass), G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstAppSinkClass, new_sample),
      NULL, NULL, __gst_app_marshal_ENUM__VOID, GST_TYPE_FLOW_RETURN, 0,
      G_TYPE_NONE);

  /**
   * GstAppSink::pull-preroll:
   * @appsink: the appsink element to emit this signal on
   *
   * Get the last preroll sample in @appsink. This was the sample that caused the
   * appsink to preroll in the PAUSED state. This sample can be pulled many times
   * and remains available to the application even after EOS.
   *
   * This function is typically used when dealing with a pipeline in the PAUSED
   * state. Calling this function after doing a seek will give the sample right
   * after the seek position.
   *
   * Note that the preroll sample will also be returned as the first sample
   * when calling gst_app_sink_pull_sample() or the "pull-sample" action signal.
   *
   * If an EOS event was received before any buffers, this function returns
   * %NULL. Use gst_app_sink_is_eos () to check for the EOS condition.
   *
   * This function blocks until a preroll sample or EOS is received or the appsink
   * element is set to the READY/NULL state.
   *
   * Returns: a #GstSample or NULL when the appsink is stopped or EOS.
   */
  gst_app_sink_signals[SIGNAL_PULL_PREROLL] =
      g_signal_new ("pull-preroll", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION, G_STRUCT_OFFSET (GstAppSinkClass,
          pull_preroll), NULL, NULL, __gst_app_marshal_BOXED__VOID,
      GST_TYPE_SAMPLE, 0, G_TYPE_NONE);
  /**
   * GstAppSink::pull-sample:
   * @appsink: the appsink element to emit this signal on
   *
   * This function blocks until a sample or EOS becomes available or the appsink
   * element is set to the READY/NULL state.
   *
   * This function will only return samples when the appsink is in the PLAYING
   * state. All rendered samples will be put in a queue so that the application
   * can pull samples at its own rate.
   *
   * Note that when the application does not pull samples fast enough, the
   * queued samples could consume a lot of memory, especially when dealing with
   * raw video frames. It's possible to control the behaviour of the queue with
   * the "drop" and "max-buffers" properties.
   *
   * If an EOS event was received before any buffers, this function returns
   * %NULL. Use gst_app_sink_is_eos () to check for the EOS condition.
   *
   * Returns: a #GstSample or NULL when the appsink is stopped or EOS.
   */
  gst_app_sink_signals[SIGNAL_PULL_SAMPLE] =
      g_signal_new ("pull-sample", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION, G_STRUCT_OFFSET (GstAppSinkClass,
          pull_sample), NULL, NULL, __gst_app_marshal_BOXED__VOID,
      GST_TYPE_SAMPLE, 0, G_TYPE_NONE);

  gst_element_class_set_static_metadata (element_class, "AppSink",
      "Generic/Sink", "Allow the application to get access to raw buffer",
      "David Schleef <ds@schleef.org>, Wim Taymans <wim.taymans@gmail.com>");

  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&gst_app_sink_template));

  basesink_class->unlock = gst_app_sink_unlock_start;
  basesink_class->unlock_stop = gst_app_sink_unlock_stop;
  basesink_class->start = gst_app_sink_start;
  basesink_class->stop = gst_app_sink_stop;
  basesink_class->event = gst_app_sink_event;
  basesink_class->preroll = gst_app_sink_preroll;
  basesink_class->render = gst_app_sink_render;
  basesink_class->get_caps = gst_app_sink_getcaps;
  basesink_class->set_caps = gst_app_sink_setcaps;
  basesink_class->query = gst_app_sink_query;

  klass->pull_preroll = gst_app_sink_pull_preroll;
  klass->pull_sample = gst_app_sink_pull_sample;

  g_type_class_add_private (klass, sizeof (GstAppSinkPrivate));
}

static void
gst_app_sink_init (GstAppSink * appsink)
{
  GstAppSinkPrivate *priv;

  priv = appsink->priv =
      G_TYPE_INSTANCE_GET_PRIVATE (appsink, GST_TYPE_APP_SINK,
      GstAppSinkPrivate);

  g_mutex_init (&priv->mutex);
  g_cond_init (&priv->cond);
  priv->queue = g_queue_new ();

  priv->emit_signals = DEFAULT_PROP_EMIT_SIGNALS;
  priv->max_buffers = DEFAULT_PROP_MAX_BUFFERS;
  priv->drop = DEFAULT_PROP_DROP;
}

static void
gst_app_sink_dispose (GObject * obj)
{
  GstAppSink *appsink = GST_APP_SINK_CAST (obj);
  GstAppSinkPrivate *priv = appsink->priv;
  GstMiniObject *queue_obj;

  GST_OBJECT_LOCK (appsink);
  if (priv->caps) {
    gst_caps_unref (priv->caps);
    priv->caps = NULL;
  }
  if (priv->notify) {
    priv->notify (priv->user_data);
  }
  priv->user_data = NULL;
  priv->notify = NULL;

  GST_OBJECT_UNLOCK (appsink);

  g_mutex_lock (&priv->mutex);
  while ((queue_obj = g_queue_pop_head (priv->queue)))
    gst_mini_object_unref (queue_obj);
  gst_buffer_replace (&priv->preroll, NULL);
  gst_caps_replace (&priv->preroll_caps, NULL);
  gst_caps_replace (&priv->last_caps, NULL);
  g_mutex_unlock (&priv->mutex);

  G_OBJECT_CLASS (parent_class)->dispose (obj);
}

static void
gst_app_sink_finalize (GObject * obj)
{
  GstAppSink *appsink = GST_APP_SINK_CAST (obj);
  GstAppSinkPrivate *priv = appsink->priv;

  g_mutex_clear (&priv->mutex);
  g_cond_clear (&priv->cond);
  g_queue_free (priv->queue);

  G_OBJECT_CLASS (parent_class)->finalize (obj);
}

static void
gst_app_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstAppSink *appsink = GST_APP_SINK_CAST (object);

  switch (prop_id) {
    case PROP_CAPS:
      gst_app_sink_set_caps (appsink, gst_value_get_caps (value));
      break;
    case PROP_EMIT_SIGNALS:
      gst_app_sink_set_emit_signals (appsink, g_value_get_boolean (value));
      break;
    case PROP_MAX_BUFFERS:
      gst_app_sink_set_max_buffers (appsink, g_value_get_uint (value));
      break;
    case PROP_DROP:
      gst_app_sink_set_drop (appsink, g_value_get_boolean (value));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_app_sink_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstAppSink *appsink = GST_APP_SINK_CAST (object);

  switch (prop_id) {
    case PROP_CAPS:
    {
      GstCaps *caps;

      caps = gst_app_sink_get_caps (appsink);
      gst_value_set_caps (value, caps);
      if (caps)
        gst_caps_unref (caps);
      break;
    }
    case PROP_EOS:
      g_value_set_boolean (value, gst_app_sink_is_eos (appsink));
      break;
    case PROP_EMIT_SIGNALS:
      g_value_set_boolean (value, gst_app_sink_get_emit_signals (appsink));
      break;
    case PROP_MAX_BUFFERS:
      g_value_set_uint (value, gst_app_sink_get_max_buffers (appsink));
      break;
    case PROP_DROP:
      g_value_set_boolean (value, gst_app_sink_get_drop (appsink));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static gboolean
gst_app_sink_unlock_start (GstBaseSink * bsink)
{
  GstAppSink *appsink = GST_APP_SINK_CAST (bsink);
  GstAppSinkPrivate *priv = appsink->priv;

  g_mutex_lock (&priv->mutex);
  GST_DEBUG_OBJECT (appsink, "unlock start");
  priv->unlock = TRUE;
  g_cond_signal (&priv->cond);
  g_mutex_unlock (&priv->mutex);

  return TRUE;
}

static gboolean
gst_app_sink_unlock_stop (GstBaseSink * bsink)
{
  GstAppSink *appsink = GST_APP_SINK_CAST (bsink);
  GstAppSinkPrivate *priv = appsink->priv;

  g_mutex_lock (&priv->mutex);
  GST_DEBUG_OBJECT (appsink, "unlock stop");
  priv->unlock = FALSE;
  g_cond_signal (&priv->cond);
  g_mutex_unlock (&priv->mutex);

  return TRUE;
}

static void
gst_app_sink_flush_unlocked (GstAppSink * appsink)
{
  GstMiniObject *obj;
  GstAppSinkPrivate *priv = appsink->priv;

  GST_DEBUG_OBJECT (appsink, "flush stop appsink");
  priv->is_eos = FALSE;
  gst_buffer_replace (&priv->preroll, NULL);
  while ((obj = g_queue_pop_head (priv->queue)))
    gst_mini_object_unref (obj);
  priv->num_buffers = 0;
  g_cond_signal (&priv->cond);
}

static gboolean
gst_app_sink_start (GstBaseSink * psink)
{
  GstAppSink *appsink = GST_APP_SINK_CAST (psink);
  GstAppSinkPrivate *priv = appsink->priv;

  g_mutex_lock (&priv->mutex);
  GST_DEBUG_OBJECT (appsink, "starting");
  priv->flushing = FALSE;
  priv->started = TRUE;
  gst_segment_init (&priv->last_segment, GST_FORMAT_TIME);
  g_mutex_unlock (&priv->mutex);

  return TRUE;
}

static gboolean
gst_app_sink_stop (GstBaseSink * psink)
{
  GstAppSink *appsink = GST_APP_SINK_CAST (psink);
  GstAppSinkPrivate *priv = appsink->priv;

  g_mutex_lock (&priv->mutex);
  GST_DEBUG_OBJECT (appsink, "stopping");
  priv->flushing = TRUE;
  priv->started = FALSE;
  gst_app_sink_flush_unlocked (appsink);
  gst_caps_replace (&priv->preroll_caps, NULL);
  gst_caps_replace (&priv->last_caps, NULL);
  g_mutex_unlock (&priv->mutex);

  return TRUE;
}

static gboolean
gst_app_sink_setcaps (GstBaseSink * sink, GstCaps * caps)
{
  GstAppSink *appsink = GST_APP_SINK_CAST (sink);
  GstAppSinkPrivate *priv = appsink->priv;

  g_mutex_lock (&priv->mutex);
  GST_DEBUG_OBJECT (appsink, "receiving CAPS");
  g_queue_push_tail (priv->queue, gst_event_new_caps (caps));
  gst_caps_replace (&priv->preroll_caps, caps);
  g_mutex_unlock (&priv->mutex);

  return TRUE;
}

static gboolean
gst_app_sink_event (GstBaseSink * sink, GstEvent * event)
{
  GstAppSink *appsink = GST_APP_SINK_CAST (sink);
  GstAppSinkPrivate *priv = appsink->priv;

  switch (event->type) {
    case GST_EVENT_SEGMENT:
      g_mutex_lock (&priv->mutex);
      GST_DEBUG_OBJECT (appsink, "receiving SEGMENT");
      g_queue_push_tail (priv->queue, gst_event_ref (event));
      g_mutex_unlock (&priv->mutex);
      break;
    case GST_EVENT_EOS:
      g_mutex_lock (&priv->mutex);
      GST_DEBUG_OBJECT (appsink, "receiving EOS");
      priv->is_eos = TRUE;
      g_cond_signal (&priv->cond);
      g_mutex_unlock (&priv->mutex);

      /* emit EOS now */
      if (priv->callbacks.eos)
        priv->callbacks.eos (appsink, priv->user_data);
      else
        g_signal_emit (appsink, gst_app_sink_signals[SIGNAL_EOS], 0);

      break;
    case GST_EVENT_FLUSH_START:
      /* we don't have to do anything here, the base class will call unlock
       * which will make sure we exit the _render method */
      GST_DEBUG_OBJECT (appsink, "received FLUSH_START");
      break;
    case GST_EVENT_FLUSH_STOP:
      g_mutex_lock (&priv->mutex);
      GST_DEBUG_OBJECT (appsink, "received FLUSH_STOP");
      gst_app_sink_flush_unlocked (appsink);
      g_mutex_unlock (&priv->mutex);
      break;
    default:
      break;
  }
  return GST_BASE_SINK_CLASS (parent_class)->event (sink, event);
}

static GstFlowReturn
gst_app_sink_preroll (GstBaseSink * psink, GstBuffer * buffer)
{
  GstFlowReturn res;
  GstAppSink *appsink = GST_APP_SINK_CAST (psink);
  GstAppSinkPrivate *priv = appsink->priv;
  gboolean emit;

  g_mutex_lock (&priv->mutex);
  if (priv->flushing)
    goto flushing;

  GST_DEBUG_OBJECT (appsink, "setting preroll buffer %p", buffer);
  gst_buffer_replace (&priv->preroll, buffer);

  g_cond_signal (&priv->cond);
  emit = priv->emit_signals;
  g_mutex_unlock (&priv->mutex);

  if (priv->callbacks.new_preroll) {
    res = priv->callbacks.new_preroll (appsink, priv->user_data);
  } else {
    res = GST_FLOW_OK;
    if (emit)
      g_signal_emit (appsink, gst_app_sink_signals[SIGNAL_NEW_PREROLL], 0,
          &res);
  }

  return res;

flushing:
  {
    GST_DEBUG_OBJECT (appsink, "we are flushing");
    g_mutex_unlock (&priv->mutex);
    return GST_FLOW_FLUSHING;
  }
}

static GstBuffer *
dequeue_buffer (GstAppSink * appsink)
{
  GstAppSinkPrivate *priv = appsink->priv;
  GstBuffer *buffer;

  do {
    GstMiniObject *obj;

    obj = g_queue_pop_head (priv->queue);

    if (GST_IS_BUFFER (obj)) {
      buffer = GST_BUFFER_CAST (obj);
      GST_DEBUG_OBJECT (appsink, "dequeued buffer %p", buffer);
      priv->num_buffers--;
      break;
    } else if (GST_IS_EVENT (obj)) {
      GstEvent *event = GST_EVENT_CAST (obj);

      switch (GST_EVENT_TYPE (obj)) {
        case GST_EVENT_CAPS:
        {
          GstCaps *caps;

          gst_event_parse_caps (event, &caps);
          GST_DEBUG_OBJECT (appsink, "activating caps %" GST_PTR_FORMAT, caps);
          gst_caps_replace (&priv->last_caps, caps);
          break;
        }
        case GST_EVENT_SEGMENT:
          gst_event_copy_segment (event, &priv->last_segment);
          GST_DEBUG_OBJECT (appsink, "activated segment %" GST_SEGMENT_FORMAT,
              &priv->last_segment);
          break;
        default:
          break;
      }
      gst_mini_object_unref (obj);
    }
  } while (TRUE);

  return buffer;
}

static GstFlowReturn
gst_app_sink_render (GstBaseSink * psink, GstBuffer * buffer)
{
  GstFlowReturn ret;
  GstAppSink *appsink = GST_APP_SINK_CAST (psink);
  GstAppSinkPrivate *priv = appsink->priv;
  gboolean emit;

restart:
  g_mutex_lock (&priv->mutex);
  if (priv->flushing)
    goto flushing;

  /* queue holding caps event might have been FLUSHed,
   * but caps state still present in pad caps */
  if (G_UNLIKELY (!priv->last_caps &&
          gst_pad_has_current_caps (GST_BASE_SINK_PAD (psink)))) {
    priv->last_caps = gst_pad_get_current_caps (GST_BASE_SINK_PAD (psink));
    GST_DEBUG_OBJECT (appsink, "activating pad caps %" GST_PTR_FORMAT,
        priv->last_caps);
  }

  GST_DEBUG_OBJECT (appsink, "pushing render buffer %p on queue (%d)",
      buffer, priv->num_buffers);

  while (priv->max_buffers > 0 && priv->num_buffers >= priv->max_buffers) {
    if (priv->drop) {
      GstBuffer *old;

      /* we need to drop the oldest buffer and try again */
      if ((old = dequeue_buffer (appsink))) {
        GST_DEBUG_OBJECT (appsink, "dropping old buffer %p", old);
        gst_buffer_unref (old);
      }
    } else {
      GST_DEBUG_OBJECT (appsink, "waiting for free space, length %d >= %d",
          priv->num_buffers, priv->max_buffers);

      if (priv->unlock) {
        /* we are asked to unlock, call the wait_preroll method */
        g_mutex_unlock (&priv->mutex);
        if ((ret = gst_base_sink_wait_preroll (psink)) != GST_FLOW_OK)
          goto stopping;

        /* we are allowed to continue now */
        goto restart;
      }

      /* wait for a buffer to be removed or flush */
      g_cond_wait (&priv->cond, &priv->mutex);
      if (priv->flushing)
        goto flushing;
    }
  }
  /* we need to ref the buffer when pushing it in the queue */
  g_queue_push_tail (priv->queue, gst_buffer_ref (buffer));
  priv->num_buffers++;
  g_cond_signal (&priv->cond);
  emit = priv->emit_signals;
  g_mutex_unlock (&priv->mutex);

  if (priv->callbacks.new_sample) {
    ret = priv->callbacks.new_sample (appsink, priv->user_data);
  } else {
    ret = GST_FLOW_OK;
    if (emit)
      g_signal_emit (appsink, gst_app_sink_signals[SIGNAL_NEW_SAMPLE], 0, &ret);
  }
  return ret;

flushing:
  {
    GST_DEBUG_OBJECT (appsink, "we are flushing");
    g_mutex_unlock (&priv->mutex);
    return GST_FLOW_FLUSHING;
  }
stopping:
  {
    GST_DEBUG_OBJECT (appsink, "we are stopping");
    return ret;
  }
}

static GstCaps *
gst_app_sink_getcaps (GstBaseSink * psink, GstCaps * filter)
{
  GstCaps *caps;
  GstAppSink *appsink = GST_APP_SINK_CAST (psink);
  GstAppSinkPrivate *priv = appsink->priv;

  GST_OBJECT_LOCK (appsink);
  if ((caps = priv->caps)) {
    if (filter)
      caps = gst_caps_intersect_full (filter, caps, GST_CAPS_INTERSECT_FIRST);
    else
      gst_caps_ref (caps);
  }
  GST_DEBUG_OBJECT (appsink, "got caps %" GST_PTR_FORMAT, caps);
  GST_OBJECT_UNLOCK (appsink);

  return caps;
}

static gboolean
gst_app_sink_query (GstBaseSink * bsink, GstQuery * query)
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

/* external API */

/**
 * gst_app_sink_set_caps:
 * @appsink: a #GstAppSink
 * @caps: caps to set
 *
 * Set the capabilities on the appsink element.  This function takes
 * a copy of the caps structure. After calling this method, the sink will only
 * accept caps that match @caps. If @caps is non-fixed, you must check the caps
 * on the buffers to get the actual used caps.
 */
void
gst_app_sink_set_caps (GstAppSink * appsink, const GstCaps * caps)
{
  GstCaps *old;
  GstAppSinkPrivate *priv;

  g_return_if_fail (GST_IS_APP_SINK (appsink));

  priv = appsink->priv;

  GST_OBJECT_LOCK (appsink);
  GST_DEBUG_OBJECT (appsink, "setting caps to %" GST_PTR_FORMAT, caps);
  if ((old = priv->caps) != caps) {
    if (caps)
      priv->caps = gst_caps_copy (caps);
    else
      priv->caps = NULL;
    if (old)
      gst_caps_unref (old);
  }
  GST_OBJECT_UNLOCK (appsink);
}

/**
 * gst_app_sink_get_caps:
 * @appsink: a #GstAppSink
 *
 * Get the configured caps on @appsink.
 *
 * Returns: the #GstCaps accepted by the sink. gst_caps_unref() after usage.
 */
GstCaps *
gst_app_sink_get_caps (GstAppSink * appsink)
{
  GstCaps *caps;
  GstAppSinkPrivate *priv;

  g_return_val_if_fail (GST_IS_APP_SINK (appsink), NULL);

  priv = appsink->priv;

  GST_OBJECT_LOCK (appsink);
  if ((caps = priv->caps))
    gst_caps_ref (caps);
  GST_DEBUG_OBJECT (appsink, "getting caps of %" GST_PTR_FORMAT, caps);
  GST_OBJECT_UNLOCK (appsink);

  return caps;
}

/**
 * gst_app_sink_is_eos:
 * @appsink: a #GstAppSink
 *
 * Check if @appsink is EOS, which is when no more samples can be pulled because
 * an EOS event was received.
 *
 * This function also returns %TRUE when the appsink is not in the PAUSED or
 * PLAYING state.
 *
 * Returns: %TRUE if no more samples can be pulled and the appsink is EOS.
 */
gboolean
gst_app_sink_is_eos (GstAppSink * appsink)
{
  gboolean ret;
  GstAppSinkPrivate *priv;

  g_return_val_if_fail (GST_IS_APP_SINK (appsink), FALSE);

  priv = appsink->priv;

  g_mutex_lock (&priv->mutex);
  if (!priv->started)
    goto not_started;

  if (priv->is_eos && priv->num_buffers == 0) {
    GST_DEBUG_OBJECT (appsink, "we are EOS and the queue is empty");
    ret = TRUE;
  } else {
    GST_DEBUG_OBJECT (appsink, "we are not yet EOS");
    ret = FALSE;
  }
  g_mutex_unlock (&priv->mutex);

  return ret;

not_started:
  {
    GST_DEBUG_OBJECT (appsink, "we are stopped, return TRUE");
    g_mutex_unlock (&priv->mutex);
    return TRUE;
  }
}

/**
 * gst_app_sink_set_emit_signals:
 * @appsink: a #GstAppSink
 * @emit: the new state
 *
 * Make appsink emit the "new-preroll" and "new-sample" signals. This option is
 * by default disabled because signal emission is expensive and unneeded when
 * the application prefers to operate in pull mode.
 */
void
gst_app_sink_set_emit_signals (GstAppSink * appsink, gboolean emit)
{
  GstAppSinkPrivate *priv;

  g_return_if_fail (GST_IS_APP_SINK (appsink));

  priv = appsink->priv;

  g_mutex_lock (&priv->mutex);
  priv->emit_signals = emit;
  g_mutex_unlock (&priv->mutex);
}

/**
 * gst_app_sink_get_emit_signals:
 * @appsink: a #GstAppSink
 *
 * Check if appsink will emit the "new-preroll" and "new-sample" signals.
 *
 * Returns: %TRUE if @appsink is emiting the "new-preroll" and "new-sample"
 * signals.
 */
gboolean
gst_app_sink_get_emit_signals (GstAppSink * appsink)
{
  gboolean result;
  GstAppSinkPrivate *priv;

  g_return_val_if_fail (GST_IS_APP_SINK (appsink), FALSE);

  priv = appsink->priv;

  g_mutex_lock (&priv->mutex);
  result = priv->emit_signals;
  g_mutex_unlock (&priv->mutex);

  return result;
}

/**
 * gst_app_sink_set_max_buffers:
 * @appsink: a #GstAppSink
 * @max: the maximum number of buffers to queue
 *
 * Set the maximum amount of buffers that can be queued in @appsink. After this
 * amount of buffers are queued in appsink, any more buffers will block upstream
 * elements until a sample is pulled from @appsink.
 */
void
gst_app_sink_set_max_buffers (GstAppSink * appsink, guint max)
{
  GstAppSinkPrivate *priv;

  g_return_if_fail (GST_IS_APP_SINK (appsink));

  priv = appsink->priv;

  g_mutex_lock (&priv->mutex);
  if (max != priv->max_buffers) {
    priv->max_buffers = max;
    /* signal the change */
    g_cond_signal (&priv->cond);
  }
  g_mutex_unlock (&priv->mutex);
}

/**
 * gst_app_sink_get_max_buffers:
 * @appsink: a #GstAppSink
 *
 * Get the maximum amount of buffers that can be queued in @appsink.
 *
 * Returns: The maximum amount of buffers that can be queued.
 */
guint
gst_app_sink_get_max_buffers (GstAppSink * appsink)
{
  guint result;
  GstAppSinkPrivate *priv;

  g_return_val_if_fail (GST_IS_APP_SINK (appsink), 0);

  priv = appsink->priv;

  g_mutex_lock (&priv->mutex);
  result = priv->max_buffers;
  g_mutex_unlock (&priv->mutex);

  return result;
}

/**
 * gst_app_sink_set_drop:
 * @appsink: a #GstAppSink
 * @drop: the new state
 *
 * Instruct @appsink to drop old buffers when the maximum amount of queued
 * buffers is reached.
 */
void
gst_app_sink_set_drop (GstAppSink * appsink, gboolean drop)
{
  GstAppSinkPrivate *priv;

  g_return_if_fail (GST_IS_APP_SINK (appsink));

  priv = appsink->priv;

  g_mutex_lock (&priv->mutex);
  if (priv->drop != drop) {
    priv->drop = drop;
    /* signal the change */
    g_cond_signal (&priv->cond);
  }
  g_mutex_unlock (&priv->mutex);
}

/**
 * gst_app_sink_get_drop:
 * @appsink: a #GstAppSink
 *
 * Check if @appsink will drop old buffers when the maximum amount of queued
 * buffers is reached.
 *
 * Returns: %TRUE if @appsink is dropping old buffers when the queue is
 * filled.
 */
gboolean
gst_app_sink_get_drop (GstAppSink * appsink)
{
  gboolean result;
  GstAppSinkPrivate *priv;

  g_return_val_if_fail (GST_IS_APP_SINK (appsink), FALSE);

  priv = appsink->priv;

  g_mutex_lock (&priv->mutex);
  result = priv->drop;
  g_mutex_unlock (&priv->mutex);

  return result;
}

/**
 * gst_app_sink_pull_preroll:
 * @appsink: a #GstAppSink
 *
 * Get the last preroll sample in @appsink. This was the sample that caused the
 * appsink to preroll in the PAUSED state. This sample can be pulled many times
 * and remains available to the application even after EOS.
 *
 * This function is typically used when dealing with a pipeline in the PAUSED
 * state. Calling this function after doing a seek will give the sample right
 * after the seek position.
 *
 * Note that the preroll sample will also be returned as the first sample
 * when calling gst_app_sink_pull_sample().
 *
 * If an EOS event was received before any buffers, this function returns
 * %NULL. Use gst_app_sink_is_eos () to check for the EOS condition.
 *
 * This function blocks until a preroll sample or EOS is received or the appsink
 * element is set to the READY/NULL state.
 *
 * Returns: a #GstBuffer or NULL when the appsink is stopped or EOS.
 */
GstSample *
gst_app_sink_pull_preroll (GstAppSink * appsink)
{
  GstSample *sample = NULL;
  GstAppSinkPrivate *priv;

  g_return_val_if_fail (GST_IS_APP_SINK (appsink), NULL);

  priv = appsink->priv;

  g_mutex_lock (&priv->mutex);

  while (TRUE) {
    GST_DEBUG_OBJECT (appsink, "trying to grab a buffer");
    if (!priv->started)
      goto not_started;

    if (priv->preroll != NULL)
      break;

    if (priv->is_eos)
      goto eos;

    /* nothing to return, wait */
    GST_DEBUG_OBJECT (appsink, "waiting for the preroll buffer");
    g_cond_wait (&priv->cond, &priv->mutex);
  }
  sample =
      gst_sample_new (priv->preroll, priv->preroll_caps, &priv->last_segment,
      NULL);
  GST_DEBUG_OBJECT (appsink, "we have the preroll sample %p", sample);
  g_mutex_unlock (&priv->mutex);

  return sample;

  /* special conditions */
eos:
  {
    GST_DEBUG_OBJECT (appsink, "we are EOS, return NULL");
    g_mutex_unlock (&priv->mutex);
    return NULL;
  }
not_started:
  {
    GST_DEBUG_OBJECT (appsink, "we are stopped, return NULL");
    g_mutex_unlock (&priv->mutex);
    return NULL;
  }
}

/**
 * gst_app_sink_pull_sample:
 * @appsink: a #GstAppSink
 *
 * This function blocks until a sample or EOS becomes available or the appsink
 * element is set to the READY/NULL state.
 *
 * This function will only return samples when the appsink is in the PLAYING
 * state. All rendered buffers will be put in a queue so that the application
 * can pull samples at its own rate. Note that when the application does not
 * pull samples fast enough, the queued buffers could consume a lot of memory,
 * especially when dealing with raw video frames.
 *
 * If an EOS event was received before any buffers, this function returns
 * %NULL. Use gst_app_sink_is_eos () to check for the EOS condition.
 *
 * Returns: a #GstBuffer or NULL when the appsink is stopped or EOS.
 */

GstSample *
gst_app_sink_pull_sample (GstAppSink * appsink)
{
  GstSample *sample = NULL;
  GstBuffer *buffer;
  GstAppSinkPrivate *priv;

  g_return_val_if_fail (GST_IS_APP_SINK (appsink), NULL);

  priv = appsink->priv;

  g_mutex_lock (&priv->mutex);

  while (TRUE) {
    GST_DEBUG_OBJECT (appsink, "trying to grab a buffer");
    if (!priv->started)
      goto not_started;

    if (priv->num_buffers > 0)
      break;

    if (priv->is_eos)
      goto eos;

    /* nothing to return, wait */
    GST_DEBUG_OBJECT (appsink, "waiting for a buffer");
    g_cond_wait (&priv->cond, &priv->mutex);
  }
  buffer = dequeue_buffer (appsink);
  GST_DEBUG_OBJECT (appsink, "we have a buffer %p", buffer);
  sample = gst_sample_new (buffer, priv->last_caps, &priv->last_segment, NULL);
  gst_buffer_unref (buffer);

  g_cond_signal (&priv->cond);
  g_mutex_unlock (&priv->mutex);

  return sample;

  /* special conditions */
eos:
  {
    GST_DEBUG_OBJECT (appsink, "we are EOS, return NULL");
    g_mutex_unlock (&priv->mutex);
    return NULL;
  }
not_started:
  {
    GST_DEBUG_OBJECT (appsink, "we are stopped, return NULL");
    g_mutex_unlock (&priv->mutex);
    return NULL;
  }
}

/**
 * gst_app_sink_set_callbacks: (skip)
 * @appsink: a #GstAppSink
 * @callbacks: the callbacks
 * @user_data: a user_data argument for the callbacks
 * @notify: a destroy notify function
 *
 * Set callbacks which will be executed for each new preroll, new sample and eos.
 * This is an alternative to using the signals, it has lower overhead and is thus
 * less expensive, but also less flexible.
 *
 * If callbacks are installed, no signals will be emitted for performance
 * reasons.
 */
void
gst_app_sink_set_callbacks (GstAppSink * appsink,
    GstAppSinkCallbacks * callbacks, gpointer user_data, GDestroyNotify notify)
{
  GDestroyNotify old_notify;
  GstAppSinkPrivate *priv;

  g_return_if_fail (GST_IS_APP_SINK (appsink));
  g_return_if_fail (callbacks != NULL);

  priv = appsink->priv;

  GST_OBJECT_LOCK (appsink);
  old_notify = priv->notify;

  if (old_notify) {
    gpointer old_data;

    old_data = priv->user_data;

    priv->user_data = NULL;
    priv->notify = NULL;
    GST_OBJECT_UNLOCK (appsink);

    old_notify (old_data);

    GST_OBJECT_LOCK (appsink);
  }
  priv->callbacks = *callbacks;
  priv->user_data = user_data;
  priv->notify = notify;
  GST_OBJECT_UNLOCK (appsink);
}

/*** GSTURIHANDLER INTERFACE *************************************************/

static GstURIType
gst_app_sink_uri_get_type (GType type)
{
  return GST_URI_SINK;
}

static const gchar *const *
gst_app_sink_uri_get_protocols (GType type)
{
  static const gchar *protocols[] = { "appsink", NULL };

  return protocols;
}

static gchar *
gst_app_sink_uri_get_uri (GstURIHandler * handler)
{
  return g_strdup ("appsink");
}

static gboolean
gst_app_sink_uri_set_uri (GstURIHandler * handler, const gchar * uri,
    GError ** error)
{
  /* GstURIHandler checks the protocol for us */
  return TRUE;
}

static void
gst_app_sink_uri_handler_init (gpointer g_iface, gpointer iface_data)
{
  GstURIHandlerInterface *iface = (GstURIHandlerInterface *) g_iface;

  iface->get_type = gst_app_sink_uri_get_type;
  iface->get_protocols = gst_app_sink_uri_get_protocols;
  iface->get_uri = gst_app_sink_uri_get_uri;
  iface->set_uri = gst_app_sink_uri_set_uri;

}
