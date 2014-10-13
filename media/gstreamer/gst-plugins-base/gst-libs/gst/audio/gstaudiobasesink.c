/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2005 Wim Taymans <wim@fluendo.com>
 *
 * gstaudiobasesink.c:
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
 * SECTION:gstaudiobasesink
 * @short_description: Base class for audio sinks
 * @see_also: #GstAudioSink, #GstAudioRingBuffer.
 *
 * This is the base class for audio sinks. Subclasses need to implement the
 * ::create_ringbuffer vmethod. This base class will then take care of
 * writing samples to the ringbuffer, synchronisation, clipping and flushing.
 */

#include <string.h>

#include <gst/audio/audio.h>
#include "gstaudiobasesink.h"

GST_DEBUG_CATEGORY_STATIC (gst_audio_base_sink_debug);
#define GST_CAT_DEFAULT gst_audio_base_sink_debug

#define GST_AUDIO_BASE_SINK_GET_PRIVATE(obj)  \
   (G_TYPE_INSTANCE_GET_PRIVATE ((obj), GST_TYPE_AUDIO_BASE_SINK, GstAudioBaseSinkPrivate))

struct _GstAudioBaseSinkPrivate
{
  /* upstream latency */
  GstClockTime us_latency;
  /* the clock slaving algorithm in use */
  GstAudioBaseSinkSlaveMethod slave_method;
  /* running average of clock skew */
  GstClockTimeDiff avg_skew;
  /* the number of samples we aligned last time */
  gint64 last_align;

  gboolean sync_latency;

  GstClockTime eos_time;

  /* number of microseconds we allow clock slaving to drift
   * before resyncing */
  guint64 drift_tolerance;

  /* number of nanoseconds we allow timestamps to drift
   * before resyncing */
  GstClockTime alignment_threshold;

  /* time of the previous detected discont candidate */
  GstClockTime discont_time;

  /* number of nanoseconds to wait until creating a discontinuity */
  GstClockTime discont_wait;
};

/* BaseAudioSink signals and args */
enum
{
  /* FILL ME */
  LAST_SIGNAL
};

/* FIXME: 2.0, store the buffer_time and latency_time in nanoseconds */
#define DEFAULT_BUFFER_TIME     ((200 * GST_MSECOND) / GST_USECOND)
#define DEFAULT_LATENCY_TIME    ((10 * GST_MSECOND) / GST_USECOND)
#define DEFAULT_PROVIDE_CLOCK   TRUE
#define DEFAULT_SLAVE_METHOD    GST_AUDIO_BASE_SINK_SLAVE_SKEW

/* FIXME, enable pull mode when clock slaving and trick modes are figured out */
#define DEFAULT_CAN_ACTIVATE_PULL FALSE

/* when timestamps drift for more than 40ms we resync. This should
 * be enough to compensate for timestamp rounding errors. */
#define DEFAULT_ALIGNMENT_THRESHOLD   (40 * GST_MSECOND)

/* when clock slaving drift for more than 40ms we resync. This is
 * a reasonable default */
#define DEFAULT_DRIFT_TOLERANCE   ((40 * GST_MSECOND) / GST_USECOND)

/* allow for one second before resyncing to see if the timestamps drift will
 * fix itself, or is a permanent offset */
#define DEFAULT_DISCONT_WAIT        (1 * GST_SECOND)

enum
{
  PROP_0,

  PROP_BUFFER_TIME,
  PROP_LATENCY_TIME,
  PROP_PROVIDE_CLOCK,
  PROP_SLAVE_METHOD,
  PROP_CAN_ACTIVATE_PULL,
  PROP_ALIGNMENT_THRESHOLD,
  PROP_DRIFT_TOLERANCE,
  PROP_DISCONT_WAIT,

  PROP_LAST
};

GType
gst_audio_base_sink_slave_method_get_type (void)
{
  static volatile gsize slave_method_type = 0;
  static const GEnumValue slave_method[] = {
    {GST_AUDIO_BASE_SINK_SLAVE_RESAMPLE, "GST_AUDIO_BASE_SINK_SLAVE_RESAMPLE",
        "resample"},
    {GST_AUDIO_BASE_SINK_SLAVE_SKEW, "GST_AUDIO_BASE_SINK_SLAVE_SKEW", "skew"},
    {GST_AUDIO_BASE_SINK_SLAVE_NONE, "GST_AUDIO_BASE_SINK_SLAVE_NONE", "none"},
    {0, NULL, NULL},
  };

  if (g_once_init_enter (&slave_method_type)) {
    GType tmp =
        g_enum_register_static ("GstAudioBaseSinkSlaveMethod", slave_method);
    g_once_init_leave (&slave_method_type, tmp);
  }

  return (GType) slave_method_type;
}


#define _do_init \
    GST_DEBUG_CATEGORY_INIT (gst_audio_base_sink_debug, "audiobasesink", 0, "audiobasesink element");
#define gst_audio_base_sink_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstAudioBaseSink, gst_audio_base_sink,
    GST_TYPE_BASE_SINK, _do_init);

static void gst_audio_base_sink_dispose (GObject * object);

static void gst_audio_base_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_audio_base_sink_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

static GstStateChangeReturn gst_audio_base_sink_change_state (GstElement *
    element, GstStateChange transition);
static gboolean gst_audio_base_sink_activate_pull (GstBaseSink * basesink,
    gboolean active);
static gboolean gst_audio_base_sink_query (GstElement * element, GstQuery *
    query);

static GstClock *gst_audio_base_sink_provide_clock (GstElement * elem);
static inline void gst_audio_base_sink_reset_sync (GstAudioBaseSink * sink);
static GstClockTime gst_audio_base_sink_get_time (GstClock * clock,
    GstAudioBaseSink * sink);
static void gst_audio_base_sink_callback (GstAudioRingBuffer * rbuf,
    guint8 * data, guint len, gpointer user_data);

static GstFlowReturn gst_audio_base_sink_preroll (GstBaseSink * bsink,
    GstBuffer * buffer);
static GstFlowReturn gst_audio_base_sink_render (GstBaseSink * bsink,
    GstBuffer * buffer);
static gboolean gst_audio_base_sink_event (GstBaseSink * bsink,
    GstEvent * event);
static GstFlowReturn gst_audio_base_sink_wait_event (GstBaseSink * bsink,
    GstEvent * event);
static void gst_audio_base_sink_get_times (GstBaseSink * bsink,
    GstBuffer * buffer, GstClockTime * start, GstClockTime * end);
static gboolean gst_audio_base_sink_setcaps (GstBaseSink * bsink,
    GstCaps * caps);
static GstCaps *gst_audio_base_sink_fixate (GstBaseSink * bsink,
    GstCaps * caps);

static gboolean gst_audio_base_sink_query_pad (GstBaseSink * bsink,
    GstQuery * query);


/* static guint gst_audio_base_sink_signals[LAST_SIGNAL] = { 0 }; */

static void
gst_audio_base_sink_class_init (GstAudioBaseSinkClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstBaseSinkClass *gstbasesink_class;

  gobject_class = (GObjectClass *) klass;
  gstelement_class = (GstElementClass *) klass;
  gstbasesink_class = (GstBaseSinkClass *) klass;

  g_type_class_add_private (klass, sizeof (GstAudioBaseSinkPrivate));

  gobject_class->set_property = gst_audio_base_sink_set_property;
  gobject_class->get_property = gst_audio_base_sink_get_property;
  gobject_class->dispose = gst_audio_base_sink_dispose;

  g_object_class_install_property (gobject_class, PROP_BUFFER_TIME,
      g_param_spec_int64 ("buffer-time", "Buffer Time",
          "Size of audio buffer in microseconds, this is the minimum "
          "latency that the sink reports", 1, G_MAXINT64, DEFAULT_BUFFER_TIME,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_LATENCY_TIME,
      g_param_spec_int64 ("latency-time", "Latency Time",
          "The minimum amount of data to write in each iteration "
          "in microseconds", 1, G_MAXINT64, DEFAULT_LATENCY_TIME,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_PROVIDE_CLOCK,
      g_param_spec_boolean ("provide-clock", "Provide Clock",
          "Provide a clock to be used as the global pipeline clock",
          DEFAULT_PROVIDE_CLOCK, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_SLAVE_METHOD,
      g_param_spec_enum ("slave-method", "Slave Method",
          "Algorithm used to match the rate of the masterclock",
          GST_TYPE_AUDIO_BASE_SINK_SLAVE_METHOD, DEFAULT_SLAVE_METHOD,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_CAN_ACTIVATE_PULL,
      g_param_spec_boolean ("can-activate-pull", "Allow Pull Scheduling",
          "Allow pull-based scheduling", DEFAULT_CAN_ACTIVATE_PULL,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstAudioBaseSink:drift-tolerance:
   *
   * Controls the amount of time in microseconds that clocks are allowed
   * to drift before resynchronisation happens.
   */
  g_object_class_install_property (gobject_class, PROP_DRIFT_TOLERANCE,
      g_param_spec_int64 ("drift-tolerance", "Drift Tolerance",
          "Tolerance for clock drift in microseconds", 1,
          G_MAXINT64, DEFAULT_DRIFT_TOLERANCE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstAudioBaseSink:alignment_threshold:
   *
   * Controls the amount of time in nanoseconds that timestamps are allowed
   * to drift from their ideal time before choosing not to align them.
   */
  g_object_class_install_property (gobject_class, PROP_ALIGNMENT_THRESHOLD,
      g_param_spec_uint64 ("alignment-threshold", "Alignment Threshold",
          "Timestamp alignment threshold in nanoseconds", 1,
          G_MAXUINT64 - 1, DEFAULT_ALIGNMENT_THRESHOLD,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstAudioBaseSink:discont-wait:
   *
   * A window of time in nanoseconds to wait before creating a discontinuity as
   * a result of breaching the drift-tolerance.
   */
  g_object_class_install_property (gobject_class, PROP_DISCONT_WAIT,
      g_param_spec_uint64 ("discont-wait", "Discont Wait",
          "Window of time in nanoseconds to wait before "
          "creating a discontinuity", 0,
          G_MAXUINT64 - 1, DEFAULT_DISCONT_WAIT,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gstelement_class->change_state =
      GST_DEBUG_FUNCPTR (gst_audio_base_sink_change_state);
  gstelement_class->provide_clock =
      GST_DEBUG_FUNCPTR (gst_audio_base_sink_provide_clock);
  gstelement_class->query = GST_DEBUG_FUNCPTR (gst_audio_base_sink_query);

  gstbasesink_class->fixate = GST_DEBUG_FUNCPTR (gst_audio_base_sink_fixate);
  gstbasesink_class->set_caps = GST_DEBUG_FUNCPTR (gst_audio_base_sink_setcaps);
  gstbasesink_class->event = GST_DEBUG_FUNCPTR (gst_audio_base_sink_event);
  gstbasesink_class->wait_event =
      GST_DEBUG_FUNCPTR (gst_audio_base_sink_wait_event);
  gstbasesink_class->get_times =
      GST_DEBUG_FUNCPTR (gst_audio_base_sink_get_times);
  gstbasesink_class->preroll = GST_DEBUG_FUNCPTR (gst_audio_base_sink_preroll);
  gstbasesink_class->render = GST_DEBUG_FUNCPTR (gst_audio_base_sink_render);
  gstbasesink_class->query = GST_DEBUG_FUNCPTR (gst_audio_base_sink_query_pad);
  gstbasesink_class->activate_pull =
      GST_DEBUG_FUNCPTR (gst_audio_base_sink_activate_pull);

  /* ref class from a thread-safe context to work around missing bit of
   * thread-safety in GObject */
  g_type_class_ref (GST_TYPE_AUDIO_CLOCK);
  g_type_class_ref (GST_TYPE_AUDIO_RING_BUFFER);

}

static void
gst_audio_base_sink_init (GstAudioBaseSink * audiobasesink)
{
  GstBaseSink *basesink;

  audiobasesink->priv = GST_AUDIO_BASE_SINK_GET_PRIVATE (audiobasesink);

  audiobasesink->buffer_time = DEFAULT_BUFFER_TIME;
  audiobasesink->latency_time = DEFAULT_LATENCY_TIME;
  audiobasesink->priv->slave_method = DEFAULT_SLAVE_METHOD;
  audiobasesink->priv->drift_tolerance = DEFAULT_DRIFT_TOLERANCE;
  audiobasesink->priv->alignment_threshold = DEFAULT_ALIGNMENT_THRESHOLD;
  audiobasesink->priv->discont_wait = DEFAULT_DISCONT_WAIT;

  audiobasesink->provided_clock = gst_audio_clock_new ("GstAudioSinkClock",
      (GstAudioClockGetTimeFunc) gst_audio_base_sink_get_time, audiobasesink,
      NULL);

  basesink = GST_BASE_SINK_CAST (audiobasesink);
  basesink->can_activate_push = TRUE;
  basesink->can_activate_pull = DEFAULT_CAN_ACTIVATE_PULL;

  gst_base_sink_set_last_sample_enabled (basesink, FALSE);
  if (DEFAULT_PROVIDE_CLOCK)
    GST_OBJECT_FLAG_SET (basesink, GST_ELEMENT_FLAG_PROVIDE_CLOCK);
  else
    GST_OBJECT_FLAG_UNSET (basesink, GST_ELEMENT_FLAG_PROVIDE_CLOCK);
}

static void
gst_audio_base_sink_dispose (GObject * object)
{
  GstAudioBaseSink *sink;

  sink = GST_AUDIO_BASE_SINK (object);

  if (sink->provided_clock) {
    gst_audio_clock_invalidate (sink->provided_clock);
    gst_object_unref (sink->provided_clock);
    sink->provided_clock = NULL;
  }

  if (sink->ringbuffer) {
    gst_object_unparent (GST_OBJECT_CAST (sink->ringbuffer));
    sink->ringbuffer = NULL;
  }

  G_OBJECT_CLASS (parent_class)->dispose (object);
}


static GstClock *
gst_audio_base_sink_provide_clock (GstElement * elem)
{
  GstAudioBaseSink *sink;
  GstClock *clock;

  sink = GST_AUDIO_BASE_SINK (elem);

  /* we have no ringbuffer (must be NULL state) */
  if (sink->ringbuffer == NULL)
    goto wrong_state;

  if (!gst_audio_ring_buffer_is_acquired (sink->ringbuffer))
    goto wrong_state;

  GST_OBJECT_LOCK (sink);
  if (!GST_OBJECT_FLAG_IS_SET (sink, GST_ELEMENT_FLAG_PROVIDE_CLOCK))
    goto clock_disabled;

  clock = GST_CLOCK_CAST (gst_object_ref (sink->provided_clock));
  GST_OBJECT_UNLOCK (sink);

  return clock;

  /* ERRORS */
wrong_state:
  {
    GST_DEBUG_OBJECT (sink, "ringbuffer not acquired");
    return NULL;
  }
clock_disabled:
  {
    GST_DEBUG_OBJECT (sink, "clock provide disabled");
    GST_OBJECT_UNLOCK (sink);
    return NULL;
  }
}

static gboolean
gst_audio_base_sink_query_pad (GstBaseSink * bsink, GstQuery * query)
{
  gboolean res = FALSE;
  GstAudioBaseSink *basesink;

  basesink = GST_AUDIO_BASE_SINK (bsink);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_CONVERT:
    {
      GstFormat src_fmt, dest_fmt;
      gint64 src_val, dest_val;

      GST_LOG_OBJECT (basesink, "query convert");

      if (basesink->ringbuffer) {
        gst_query_parse_convert (query, &src_fmt, &src_val, &dest_fmt, NULL);
        res =
            gst_audio_ring_buffer_convert (basesink->ringbuffer, src_fmt,
            src_val, dest_fmt, &dest_val);
        if (res) {
          gst_query_set_convert (query, src_fmt, src_val, dest_fmt, dest_val);
        }
      }
      break;
    }
    default:
      res = GST_BASE_SINK_CLASS (parent_class)->query (bsink, query);
      break;
  }
  return res;
}

static gboolean
gst_audio_base_sink_query (GstElement * element, GstQuery * query)
{
  gboolean res = FALSE;
  GstAudioBaseSink *basesink;

  basesink = GST_AUDIO_BASE_SINK (element);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_LATENCY:
    {
      gboolean live, us_live;
      GstClockTime min_l, max_l;

      GST_DEBUG_OBJECT (basesink, "latency query");

      /* ask parent first, it will do an upstream query for us. */
      if ((res =
              gst_base_sink_query_latency (GST_BASE_SINK_CAST (basesink), &live,
                  &us_live, &min_l, &max_l))) {
        GstClockTime base_latency, min_latency, max_latency;

        /* we and upstream are both live, adjust the min_latency */
        if (live && us_live) {
          GstAudioRingBufferSpec *spec;

          GST_OBJECT_LOCK (basesink);
          if (!basesink->ringbuffer || !basesink->ringbuffer->spec.info.rate) {
            GST_OBJECT_UNLOCK (basesink);

            GST_DEBUG_OBJECT (basesink,
                "we are not negotiated, can't report latency yet");
            res = FALSE;
            goto done;
          }
          spec = &basesink->ringbuffer->spec;

          basesink->priv->us_latency = min_l;

          base_latency =
              gst_util_uint64_scale_int (spec->seglatency * spec->segsize,
              GST_SECOND, spec->info.rate * spec->info.bpf);
          GST_OBJECT_UNLOCK (basesink);

          /* we cannot go lower than the buffer size and the min peer latency */
          min_latency = base_latency + min_l;
          /* the max latency is the max of the peer, we can delay an infinite
           * amount of time. */
          max_latency = (max_l == -1) ? -1 : (base_latency + max_l);


          GST_DEBUG_OBJECT (basesink,
              "peer min %" GST_TIME_FORMAT ", our min latency: %"
              GST_TIME_FORMAT, GST_TIME_ARGS (min_l),
              GST_TIME_ARGS (min_latency));
          GST_DEBUG_OBJECT (basesink,
              "peer max %" GST_TIME_FORMAT ", our max latency: %"
              GST_TIME_FORMAT, GST_TIME_ARGS (max_l),
              GST_TIME_ARGS (max_latency));
        } else {
          GST_DEBUG_OBJECT (basesink,
              "peer or we are not live, don't care about latency");
          min_latency = min_l;
          max_latency = max_l;
        }
        gst_query_set_latency (query, live, min_latency, max_latency);
      }
      break;
    }
    case GST_QUERY_CONVERT:
    {
      GstFormat src_fmt, dest_fmt;
      gint64 src_val, dest_val;

      GST_LOG_OBJECT (basesink, "query convert");

      if (basesink->ringbuffer) {
        gst_query_parse_convert (query, &src_fmt, &src_val, &dest_fmt, NULL);
        res =
            gst_audio_ring_buffer_convert (basesink->ringbuffer, src_fmt,
            src_val, dest_fmt, &dest_val);
        if (res) {
          gst_query_set_convert (query, src_fmt, src_val, dest_fmt, dest_val);
        }
      }
      break;
    }
    default:
      res = GST_ELEMENT_CLASS (parent_class)->query (element, query);
      break;
  }

done:
  return res;
}


/* we call this function without holding the lock on sink for performance
 * reasons. Try hard to not deal with and invalid ringbuffer and rate. */
static GstClockTime
gst_audio_base_sink_get_time (GstClock * clock, GstAudioBaseSink * sink)
{
  guint64 raw, samples;
  guint delay;
  GstClockTime result;
  GstAudioRingBuffer *ringbuffer;
  gint rate;

  if ((ringbuffer = sink->ringbuffer) == NULL)
    return GST_CLOCK_TIME_NONE;

  if ((rate = ringbuffer->spec.info.rate) == 0)
    return GST_CLOCK_TIME_NONE;

  /* our processed samples are always increasing */
  raw = samples = gst_audio_ring_buffer_samples_done (ringbuffer);

  /* the number of samples not yet processed, this is still queued in the
   * device (not played for playback). */
  delay = gst_audio_ring_buffer_delay (ringbuffer);

  if (G_LIKELY (samples >= delay))
    samples -= delay;
  else
    samples = 0;

  result = gst_util_uint64_scale_int (samples, GST_SECOND, rate);

  GST_DEBUG_OBJECT (sink,
      "processed samples: raw %" G_GUINT64_FORMAT ", delay %u, real %"
      G_GUINT64_FORMAT ", time %" GST_TIME_FORMAT,
      raw, delay, samples, GST_TIME_ARGS (result));

  return result;
}

/**
 * gst_audio_base_sink_set_provide_clock:
 * @sink: a #GstAudioBaseSink
 * @provide: new state
 *
 * Controls whether @sink will provide a clock or not. If @provide is %TRUE,
 * gst_element_provide_clock() will return a clock that reflects the datarate
 * of @sink. If @provide is %FALSE, gst_element_provide_clock() will return
 * NULL.
 */
void
gst_audio_base_sink_set_provide_clock (GstAudioBaseSink * sink,
    gboolean provide)
{
  g_return_if_fail (GST_IS_AUDIO_BASE_SINK (sink));

  GST_OBJECT_LOCK (sink);
  if (provide)
    GST_OBJECT_FLAG_SET (sink, GST_ELEMENT_FLAG_PROVIDE_CLOCK);
  else
    GST_OBJECT_FLAG_UNSET (sink, GST_ELEMENT_FLAG_PROVIDE_CLOCK);
  GST_OBJECT_UNLOCK (sink);
}

/**
 * gst_audio_base_sink_get_provide_clock:
 * @sink: a #GstAudioBaseSink
 *
 * Queries whether @sink will provide a clock or not. See also
 * gst_audio_base_sink_set_provide_clock.
 *
 * Returns: %TRUE if @sink will provide a clock.
 */
gboolean
gst_audio_base_sink_get_provide_clock (GstAudioBaseSink * sink)
{
  gboolean result;

  g_return_val_if_fail (GST_IS_AUDIO_BASE_SINK (sink), FALSE);

  GST_OBJECT_LOCK (sink);
  result = GST_OBJECT_FLAG_IS_SET (sink, GST_ELEMENT_FLAG_PROVIDE_CLOCK);
  GST_OBJECT_UNLOCK (sink);

  return result;
}

/**
 * gst_audio_base_sink_set_slave_method:
 * @sink: a #GstAudioBaseSink
 * @method: the new slave method
 *
 * Controls how clock slaving will be performed in @sink.
 */
void
gst_audio_base_sink_set_slave_method (GstAudioBaseSink * sink,
    GstAudioBaseSinkSlaveMethod method)
{
  g_return_if_fail (GST_IS_AUDIO_BASE_SINK (sink));

  GST_OBJECT_LOCK (sink);
  sink->priv->slave_method = method;
  GST_OBJECT_UNLOCK (sink);
}

/**
 * gst_audio_base_sink_get_slave_method:
 * @sink: a #GstAudioBaseSink
 *
 * Get the current slave method used by @sink.
 *
 * Returns: The current slave method used by @sink.
 */
GstAudioBaseSinkSlaveMethod
gst_audio_base_sink_get_slave_method (GstAudioBaseSink * sink)
{
  GstAudioBaseSinkSlaveMethod result;

  g_return_val_if_fail (GST_IS_AUDIO_BASE_SINK (sink), -1);

  GST_OBJECT_LOCK (sink);
  result = sink->priv->slave_method;
  GST_OBJECT_UNLOCK (sink);

  return result;
}


/**
 * gst_audio_base_sink_set_drift_tolerance:
 * @sink: a #GstAudioBaseSink
 * @drift_tolerance: the new drift tolerance in microseconds
 *
 * Controls the sink's drift tolerance.
 */
void
gst_audio_base_sink_set_drift_tolerance (GstAudioBaseSink * sink,
    gint64 drift_tolerance)
{
  g_return_if_fail (GST_IS_AUDIO_BASE_SINK (sink));

  GST_OBJECT_LOCK (sink);
  sink->priv->drift_tolerance = drift_tolerance;
  GST_OBJECT_UNLOCK (sink);
}

/**
 * gst_audio_base_sink_get_drift_tolerance:
 * @sink: a #GstAudioBaseSink
 *
 * Get the current drift tolerance, in microseconds, used by @sink.
 *
 * Returns: The current drift tolerance used by @sink.
 */
gint64
gst_audio_base_sink_get_drift_tolerance (GstAudioBaseSink * sink)
{
  gint64 result;

  g_return_val_if_fail (GST_IS_AUDIO_BASE_SINK (sink), -1);

  GST_OBJECT_LOCK (sink);
  result = sink->priv->drift_tolerance;
  GST_OBJECT_UNLOCK (sink);

  return result;
}

/**
 * gst_audio_base_sink_set_alignment_threshold:
 * @sink: a #GstAudioBaseSink
 * @alignment_threshold: the new alignment threshold in nanoseconds
 *
 * Controls the sink's alignment threshold.
 */
void
gst_audio_base_sink_set_alignment_threshold (GstAudioBaseSink * sink,
    GstClockTime alignment_threshold)
{
  g_return_if_fail (GST_IS_AUDIO_BASE_SINK (sink));

  GST_OBJECT_LOCK (sink);
  sink->priv->alignment_threshold = alignment_threshold;
  GST_OBJECT_UNLOCK (sink);
}

/**
 * gst_audio_base_sink_get_alignment_threshold:
 * @sink: a #GstAudioBaseSink
 *
 * Get the current alignment threshold, in nanoseconds, used by @sink.
 *
 * Returns: The current alignment threshold used by @sink.
 */
GstClockTime
gst_audio_base_sink_get_alignment_threshold (GstAudioBaseSink * sink)
{
  GstClockTime result;

  g_return_val_if_fail (GST_IS_AUDIO_BASE_SINK (sink), GST_CLOCK_TIME_NONE);

  GST_OBJECT_LOCK (sink);
  result = sink->priv->alignment_threshold;
  GST_OBJECT_UNLOCK (sink);

  return result;
}

/**
 * gst_audio_base_sink_set_discont_wait:
 * @sink: a #GstAudioBaseSink
 * @discont_wait: the new discont wait in nanoseconds
 *
 * Controls how long the sink will wait before creating a discontinuity.
 */
void
gst_audio_base_sink_set_discont_wait (GstAudioBaseSink * sink,
    GstClockTime discont_wait)
{
  g_return_if_fail (GST_IS_AUDIO_BASE_SINK (sink));

  GST_OBJECT_LOCK (sink);
  sink->priv->discont_wait = discont_wait;
  GST_OBJECT_UNLOCK (sink);
}

/**
 * gst_audio_base_sink_get_discont_wait:
 * @sink: a #GstAudioBaseSink
 *
 * Get the current discont wait, in nanoseconds, used by @sink.
 *
 * Returns: The current discont wait used by @sink.
 */
GstClockTime
gst_audio_base_sink_get_discont_wait (GstAudioBaseSink * sink)
{
  GstClockTime result;

  g_return_val_if_fail (GST_IS_AUDIO_BASE_SINK (sink), -1);

  GST_OBJECT_LOCK (sink);
  result = sink->priv->discont_wait;
  GST_OBJECT_UNLOCK (sink);

  return result;
}

static void
gst_audio_base_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstAudioBaseSink *sink;

  sink = GST_AUDIO_BASE_SINK (object);

  switch (prop_id) {
    case PROP_BUFFER_TIME:
      sink->buffer_time = g_value_get_int64 (value);
      break;
    case PROP_LATENCY_TIME:
      sink->latency_time = g_value_get_int64 (value);
      break;
    case PROP_PROVIDE_CLOCK:
      gst_audio_base_sink_set_provide_clock (sink, g_value_get_boolean (value));
      break;
    case PROP_SLAVE_METHOD:
      gst_audio_base_sink_set_slave_method (sink, g_value_get_enum (value));
      break;
    case PROP_CAN_ACTIVATE_PULL:
      GST_BASE_SINK (sink)->can_activate_pull = g_value_get_boolean (value);
      break;
    case PROP_DRIFT_TOLERANCE:
      gst_audio_base_sink_set_drift_tolerance (sink, g_value_get_int64 (value));
      break;
    case PROP_ALIGNMENT_THRESHOLD:
      gst_audio_base_sink_set_alignment_threshold (sink,
          g_value_get_uint64 (value));
      break;
    case PROP_DISCONT_WAIT:
      gst_audio_base_sink_set_discont_wait (sink, g_value_get_uint64 (value));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_audio_base_sink_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstAudioBaseSink *sink;

  sink = GST_AUDIO_BASE_SINK (object);

  switch (prop_id) {
    case PROP_BUFFER_TIME:
      g_value_set_int64 (value, sink->buffer_time);
      break;
    case PROP_LATENCY_TIME:
      g_value_set_int64 (value, sink->latency_time);
      break;
    case PROP_PROVIDE_CLOCK:
      g_value_set_boolean (value, gst_audio_base_sink_get_provide_clock (sink));
      break;
    case PROP_SLAVE_METHOD:
      g_value_set_enum (value, gst_audio_base_sink_get_slave_method (sink));
      break;
    case PROP_CAN_ACTIVATE_PULL:
      g_value_set_boolean (value, GST_BASE_SINK (sink)->can_activate_pull);
      break;
    case PROP_DRIFT_TOLERANCE:
      g_value_set_int64 (value, gst_audio_base_sink_get_drift_tolerance (sink));
      break;
    case PROP_ALIGNMENT_THRESHOLD:
      g_value_set_uint64 (value,
          gst_audio_base_sink_get_alignment_threshold (sink));
      break;
    case PROP_DISCONT_WAIT:
      g_value_set_uint64 (value, gst_audio_base_sink_get_discont_wait (sink));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static gboolean
gst_audio_base_sink_setcaps (GstBaseSink * bsink, GstCaps * caps)
{
  GstAudioBaseSink *sink = GST_AUDIO_BASE_SINK (bsink);
  GstAudioRingBufferSpec *spec;
  GstClockTime now;
  GstClockTime crate_num, crate_denom;

  if (!sink->ringbuffer)
    return FALSE;

  spec = &sink->ringbuffer->spec;

  if (G_UNLIKELY (spec->caps && gst_caps_is_equal (spec->caps, caps))) {
    GST_DEBUG_OBJECT (sink,
        "Ringbuffer caps haven't changed, skipping reconfiguration");
    return TRUE;
  }

  GST_DEBUG_OBJECT (sink, "release old ringbuffer");

  /* get current time, updates the last_time. When the subclass has a clock that
   * restarts from 0 when a new format is negotiated, it will call
   * gst_audio_clock_reset() which will use this last_time to create an offset
   * so that time from the clock keeps on increasing monotonically. */
  now = gst_clock_get_time (sink->provided_clock);

  GST_DEBUG_OBJECT (sink, "time was %" GST_TIME_FORMAT, GST_TIME_ARGS (now));

  /* release old ringbuffer */
  gst_audio_ring_buffer_pause (sink->ringbuffer);
  gst_audio_ring_buffer_activate (sink->ringbuffer, FALSE);
  gst_audio_ring_buffer_release (sink->ringbuffer);

  GST_DEBUG_OBJECT (sink, "parse caps");

  spec->buffer_time = sink->buffer_time;
  spec->latency_time = sink->latency_time;

  /* parse new caps */
  if (!gst_audio_ring_buffer_parse_caps (spec, caps))
    goto parse_error;

  gst_audio_ring_buffer_debug_spec_buff (spec);

  GST_DEBUG_OBJECT (sink, "acquire ringbuffer");
  if (!gst_audio_ring_buffer_acquire (sink->ringbuffer, spec))
    goto acquire_error;

  /* We need to resync since the ringbuffer restarted */
  gst_audio_base_sink_reset_sync (sink);

  if (bsink->pad_mode == GST_PAD_MODE_PUSH) {
    GST_DEBUG_OBJECT (sink, "activate ringbuffer");
    gst_audio_ring_buffer_activate (sink->ringbuffer, TRUE);
  }

  /* due to possible changes in the spec file we should recalibrate the clock */
  gst_clock_get_calibration (sink->provided_clock, NULL, NULL,
      &crate_num, &crate_denom);
  gst_clock_set_calibration (sink->provided_clock,
      gst_clock_get_internal_time (sink->provided_clock), now, crate_num,
      crate_denom);

  /* calculate actual latency and buffer times.
   * FIXME: In 2.0, store the latency_time internally in ns */
  spec->latency_time = gst_util_uint64_scale (spec->segsize,
      (GST_SECOND / GST_USECOND), spec->info.rate * spec->info.bpf);

  spec->buffer_time = spec->segtotal * spec->latency_time;

  gst_audio_ring_buffer_debug_spec_buff (spec);

  return TRUE;

  /* ERRORS */
parse_error:
  {
    GST_DEBUG_OBJECT (sink, "could not parse caps");
    GST_ELEMENT_ERROR (sink, STREAM, FORMAT,
        (NULL), ("cannot parse audio format."));
    return FALSE;
  }
acquire_error:
  {
    GST_DEBUG_OBJECT (sink, "could not acquire ringbuffer");
    return FALSE;
  }
}

static GstCaps *
gst_audio_base_sink_fixate (GstBaseSink * bsink, GstCaps * caps)
{
  GstStructure *s;
  gint width, depth;

  caps = gst_caps_make_writable (caps);

  s = gst_caps_get_structure (caps, 0);

  /* fields for all formats */
  gst_structure_fixate_field_nearest_int (s, "rate", 44100);
  gst_structure_fixate_field_nearest_int (s, "channels", 2);
  gst_structure_fixate_field_nearest_int (s, "width", 16);

  /* fields for int */
  if (gst_structure_has_field (s, "depth")) {
    gst_structure_get_int (s, "width", &width);
    /* round width to nearest multiple of 8 for the depth */
    depth = GST_ROUND_UP_8 (width);
    gst_structure_fixate_field_nearest_int (s, "depth", depth);
  }
  if (gst_structure_has_field (s, "signed"))
    gst_structure_fixate_field_boolean (s, "signed", TRUE);
  if (gst_structure_has_field (s, "endianness"))
    gst_structure_fixate_field_nearest_int (s, "endianness", G_BYTE_ORDER);

  caps = GST_BASE_SINK_CLASS (parent_class)->fixate (bsink, caps);

  return caps;
}

static inline void
gst_audio_base_sink_reset_sync (GstAudioBaseSink * sink)
{
  sink->next_sample = -1;
  sink->priv->eos_time = -1;
  sink->priv->discont_time = -1;
  sink->priv->avg_skew = -1;
  sink->priv->last_align = 0;
}

static void
gst_audio_base_sink_get_times (GstBaseSink * bsink, GstBuffer * buffer,
    GstClockTime * start, GstClockTime * end)
{
  /* our clock sync is a bit too much for the base class to handle so
   * we implement it ourselves. */
  *start = GST_CLOCK_TIME_NONE;
  *end = GST_CLOCK_TIME_NONE;
}

/* This waits for the drain to happen and can be canceled */
static gboolean
gst_audio_base_sink_drain (GstAudioBaseSink * sink)
{
  if (!sink->ringbuffer)
    return TRUE;
  if (!sink->ringbuffer->spec.info.rate)
    return TRUE;

  /* if PLAYING is interrupted,
   * arrange to have clock running when going to PLAYING again */
  g_atomic_int_set (&sink->eos_rendering, 1);

  /* need to start playback before we can drain, but only when
   * we have successfully negotiated a format and thus acquired the
   * ringbuffer. */
  if (gst_audio_ring_buffer_is_acquired (sink->ringbuffer))
    gst_audio_ring_buffer_start (sink->ringbuffer);

  if (sink->priv->eos_time != -1) {
    GST_DEBUG_OBJECT (sink,
        "last sample time %" GST_TIME_FORMAT,
        GST_TIME_ARGS (sink->priv->eos_time));

    /* wait for the EOS time to be reached, this is the time when the last
     * sample is played. */
    gst_base_sink_wait (GST_BASE_SINK (sink), sink->priv->eos_time, NULL);

    GST_DEBUG_OBJECT (sink, "drained audio");
  }
  g_atomic_int_set (&sink->eos_rendering, 0);
  return TRUE;
}

static GstFlowReturn
gst_audio_base_sink_wait_event (GstBaseSink * bsink, GstEvent * event)
{
  GstAudioBaseSink *sink = GST_AUDIO_BASE_SINK (bsink);
  GstFlowReturn ret;

  ret = GST_BASE_SINK_CLASS (parent_class)->wait_event (bsink, event);
  if (ret != GST_FLOW_OK)
    return ret;

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_GAP:{
      GstClockTime timestamp, duration;
      GstAudioRingBufferSpec *spec;
      GstBuffer *buffer;
      gint n_samples = 0;
      GstMapInfo minfo;

      spec = &sink->ringbuffer->spec;
      if (G_UNLIKELY (spec->info.rate == 0)) {
        GST_ELEMENT_ERROR (sink, STREAM, FORMAT, (NULL),
            ("Sink not negotiated before GAP event."));
        ret = GST_FLOW_ERROR;
        break;
      }

      gst_event_parse_gap (event, &timestamp, &duration);

      /* If the GAP event has a duration, handle it like a
       * silence buffer of that duration. Otherwise at least
       * start the ringbuffer to make sure the clock is running.
       */
      if (duration != GST_CLOCK_TIME_NONE) {
        n_samples =
            gst_util_uint64_scale_ceil (duration, spec->info.rate, GST_SECOND);
        buffer = gst_buffer_new_and_alloc (n_samples * spec->info.bpf);

        if (n_samples != 0) {
          gst_buffer_map (buffer, &minfo, GST_MAP_WRITE);
          gst_audio_format_fill_silence (spec->info.finfo, minfo.data,
              minfo.size);
          gst_buffer_unmap (buffer, &minfo);
        }
        GST_BUFFER_PTS (buffer) = timestamp;
        GST_BUFFER_DURATION (buffer) = duration;
        GST_BUFFER_FLAG_SET (buffer, GST_BUFFER_FLAG_GAP);

        ret = gst_audio_base_sink_render (bsink, buffer);
        gst_buffer_unref (buffer);
      } else {
        gst_audio_base_sink_drain (sink);
      }
      break;
    }
    case GST_EVENT_EOS:
      /* now wait till we played everything */
      gst_audio_base_sink_drain (sink);
      break;
    default:
      break;
  }
  return ret;
}

static gboolean
gst_audio_base_sink_event (GstBaseSink * bsink, GstEvent * event)
{
  GstAudioBaseSink *sink = GST_AUDIO_BASE_SINK (bsink);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_FLUSH_START:
      if (sink->ringbuffer)
        gst_audio_ring_buffer_set_flushing (sink->ringbuffer, TRUE);
      break;
    case GST_EVENT_FLUSH_STOP:
      /* always resync on sample after a flush */
      gst_audio_base_sink_reset_sync (sink);
      if (sink->ringbuffer)
        gst_audio_ring_buffer_set_flushing (sink->ringbuffer, FALSE);
      break;
    default:
      break;
  }
  return GST_BASE_SINK_CLASS (parent_class)->event (bsink, event);
}

static GstFlowReturn
gst_audio_base_sink_preroll (GstBaseSink * bsink, GstBuffer * buffer)
{
  GstAudioBaseSink *sink = GST_AUDIO_BASE_SINK (bsink);

  if (!gst_audio_ring_buffer_is_acquired (sink->ringbuffer))
    goto wrong_state;

  /* we don't really do anything when prerolling. We could make a
   * property to play this buffer to have some sort of scrubbing
   * support. */
  return GST_FLOW_OK;

wrong_state:
  {
    GST_DEBUG_OBJECT (sink, "ringbuffer in wrong state");
    GST_ELEMENT_ERROR (sink, STREAM, FORMAT, (NULL), ("sink not negotiated."));
    return GST_FLOW_NOT_NEGOTIATED;
  }
}

static guint64
gst_audio_base_sink_get_offset (GstAudioBaseSink * sink)
{
  guint64 sample, sps;
  gint writeseg, segdone;
  gint diff;

  /* assume we can append to the previous sample */
  sample = sink->next_sample;
  /* no previous sample, try to insert at position 0 */
  if (sample == -1)
    sample = 0;

  sps = sink->ringbuffer->samples_per_seg;

  /* figure out the segment and the offset inside the segment where
   * the sample should be written. */
  writeseg = sample / sps;

  /* get the currently processed segment */
  segdone = g_atomic_int_get (&sink->ringbuffer->segdone)
      - sink->ringbuffer->segbase;

  /* see how far away it is from the write segment */
  diff = writeseg - segdone;
  if (diff < 0) {
    /* sample would be dropped, position to next playable position */
    sample = (segdone + 1) * sps;
  }

  return sample;
}

static GstClockTime
clock_convert_external (GstClockTime external, GstClockTime cinternal,
    GstClockTime cexternal, GstClockTime crate_num, GstClockTime crate_denom)
{
  /* adjust for rate and speed */
  if (external >= cexternal) {
    external =
        gst_util_uint64_scale (external - cexternal, crate_denom, crate_num);
    external += cinternal;
  } else {
    external =
        gst_util_uint64_scale (cexternal - external, crate_denom, crate_num);
    if (cinternal > external)
      external = cinternal - external;
    else
      external = 0;
  }
  return external;
}

/* algorithm to calculate sample positions that will result in resampling to
 * match the clock rate of the master */
static void
gst_audio_base_sink_resample_slaving (GstAudioBaseSink * sink,
    GstClockTime render_start, GstClockTime render_stop,
    GstClockTime * srender_start, GstClockTime * srender_stop)
{
  GstClockTime cinternal, cexternal;
  GstClockTime crate_num, crate_denom;

  /* FIXME, we can sample and add observations here or use the timeouts on the
   * clock. No idea which one is better or more stable. The timeout seems more
   * arbitrary but this one seems more demanding and does not work when there is
   * no data comming in to the sink. */
#if 0
  GstClockTime etime, itime;
  gdouble r_squared;

  /* sample clocks and figure out clock skew */
  etime = gst_clock_get_time (GST_ELEMENT_CLOCK (sink));
  itime = gst_audio_clock_get_time (sink->provided_clock);

  /* add new observation */
  gst_clock_add_observation (sink->provided_clock, itime, etime, &r_squared);
#endif

  /* get calibration parameters to compensate for speed and offset differences
   * when we are slaved */
  gst_clock_get_calibration (sink->provided_clock, &cinternal, &cexternal,
      &crate_num, &crate_denom);

  GST_DEBUG_OBJECT (sink, "internal %" GST_TIME_FORMAT " external %"
      GST_TIME_FORMAT " %" G_GUINT64_FORMAT "/%" G_GUINT64_FORMAT " = %f",
      GST_TIME_ARGS (cinternal), GST_TIME_ARGS (cexternal), crate_num,
      crate_denom, gst_guint64_to_gdouble (crate_num) /
      gst_guint64_to_gdouble (crate_denom));

  if (crate_num == 0)
    crate_denom = crate_num = 1;

  /* bring external time to internal time */
  render_start = clock_convert_external (render_start, cinternal, cexternal,
      crate_num, crate_denom);
  render_stop = clock_convert_external (render_stop, cinternal, cexternal,
      crate_num, crate_denom);

  GST_DEBUG_OBJECT (sink,
      "after slaving: start %" GST_TIME_FORMAT " - stop %" GST_TIME_FORMAT,
      GST_TIME_ARGS (render_start), GST_TIME_ARGS (render_stop));

  *srender_start = render_start;
  *srender_stop = render_stop;
}

/* algorithm to calculate sample positions that will result in changing the
 * playout pointer to match the clock rate of the master */
static void
gst_audio_base_sink_skew_slaving (GstAudioBaseSink * sink,
    GstClockTime render_start, GstClockTime render_stop,
    GstClockTime * srender_start, GstClockTime * srender_stop)
{
  GstClockTime cinternal, cexternal, crate_num, crate_denom;
  GstClockTime etime, itime;
  GstClockTimeDiff skew, mdrift, mdrift2;
  gint driftsamples;
  gint64 last_align;

  /* get calibration parameters to compensate for offsets */
  gst_clock_get_calibration (sink->provided_clock, &cinternal, &cexternal,
      &crate_num, &crate_denom);

  /* sample clocks and figure out clock skew */
  etime = gst_clock_get_time (GST_ELEMENT_CLOCK (sink));
  itime = gst_audio_clock_get_time (sink->provided_clock);
  itime = gst_audio_clock_adjust (sink->provided_clock, itime);

  GST_DEBUG_OBJECT (sink,
      "internal %" GST_TIME_FORMAT " external %" GST_TIME_FORMAT
      " cinternal %" GST_TIME_FORMAT " cexternal %" GST_TIME_FORMAT,
      GST_TIME_ARGS (itime), GST_TIME_ARGS (etime),
      GST_TIME_ARGS (cinternal), GST_TIME_ARGS (cexternal));

  /* make sure we never go below 0 */
  etime = etime > cexternal ? etime - cexternal : 0;
  itime = itime > cinternal ? itime - cinternal : 0;

  /* do itime - etime.
   * positive value means external clock goes slower
   * negative value means external clock goes faster */
  skew = GST_CLOCK_DIFF (etime, itime);
  if (sink->priv->avg_skew == -1) {
    /* first observation */
    sink->priv->avg_skew = skew;
  } else {
    /* next observations use a moving average */
    sink->priv->avg_skew = (31 * sink->priv->avg_skew + skew) / 32;
  }

  GST_DEBUG_OBJECT (sink, "internal %" GST_TIME_FORMAT " external %"
      GST_TIME_FORMAT " skew %" G_GINT64_FORMAT " avg %" G_GINT64_FORMAT,
      GST_TIME_ARGS (itime), GST_TIME_ARGS (etime), skew, sink->priv->avg_skew);

  /* the max drift we allow */
  mdrift = sink->priv->drift_tolerance * 1000;
  mdrift2 = mdrift / 2;

  /* adjust playout pointer based on skew */
  if (sink->priv->avg_skew > mdrift2) {
    /* master is running slower, move internal time forward */
    GST_WARNING_OBJECT (sink,
        "correct clock skew %" G_GINT64_FORMAT " > %" G_GINT64_FORMAT,
        sink->priv->avg_skew, mdrift2);

    if (sink->priv->avg_skew > (2 * mdrift)) {
      cexternal -= sink->priv->avg_skew;
      sink->priv->avg_skew = 0;
    } else {
      cexternal = cexternal > mdrift ? cexternal - mdrift : 0;
      sink->priv->avg_skew -= mdrift;
    }

    driftsamples = (sink->ringbuffer->spec.info.rate * mdrift) / GST_SECOND;
    last_align = sink->priv->last_align;

    /* if we were aligning in the wrong direction or we aligned more than what
     * we will correct, resync */
    if (last_align < 0 || last_align > driftsamples)
      sink->next_sample = -1;

    GST_DEBUG_OBJECT (sink,
        "last_align %" G_GINT64_FORMAT " driftsamples %u, next %"
        G_GUINT64_FORMAT, last_align, driftsamples, sink->next_sample);

    gst_clock_set_calibration (sink->provided_clock, cinternal, cexternal,
        crate_num, crate_denom);
  } else if (sink->priv->avg_skew < -mdrift2) {
    /* master is running faster, move external time forwards */
    GST_WARNING_OBJECT (sink,
        "correct clock skew %" G_GINT64_FORMAT " < %" G_GINT64_FORMAT,
        sink->priv->avg_skew, -mdrift2);

    if (sink->priv->avg_skew < (2 * -mdrift)) {
      cexternal -= sink->priv->avg_skew;
      sink->priv->avg_skew = 0;
    } else {
      cexternal += mdrift;
      sink->priv->avg_skew += mdrift;
    }

    driftsamples = (sink->ringbuffer->spec.info.rate * mdrift) / GST_SECOND;
    last_align = sink->priv->last_align;

    /* if we were aligning in the wrong direction or we aligned more than what
     * we will correct, resync */
    if (last_align > 0 || -last_align > driftsamples)
      sink->next_sample = -1;

    GST_DEBUG_OBJECT (sink,
        "last_align %" G_GINT64_FORMAT " driftsamples %u, next %"
        G_GUINT64_FORMAT, last_align, driftsamples, sink->next_sample);

    gst_clock_set_calibration (sink->provided_clock, cinternal, cexternal,
        crate_num, crate_denom);
  }

  /* convert, ignoring speed */
  render_start = clock_convert_external (render_start, cinternal, cexternal,
      crate_num, crate_denom);
  render_stop = clock_convert_external (render_stop, cinternal, cexternal,
      crate_num, crate_denom);

  *srender_start = render_start;
  *srender_stop = render_stop;
}

/* apply the clock offset but do no slaving otherwise */
static void
gst_audio_base_sink_none_slaving (GstAudioBaseSink * sink,
    GstClockTime render_start, GstClockTime render_stop,
    GstClockTime * srender_start, GstClockTime * srender_stop)
{
  GstClockTime cinternal, cexternal, crate_num, crate_denom;

  /* get calibration parameters to compensate for offsets */
  gst_clock_get_calibration (sink->provided_clock, &cinternal, &cexternal,
      &crate_num, &crate_denom);

  /* convert, ignoring speed */
  render_start = clock_convert_external (render_start, cinternal, cexternal,
      crate_num, crate_denom);
  render_stop = clock_convert_external (render_stop, cinternal, cexternal,
      crate_num, crate_denom);

  *srender_start = render_start;
  *srender_stop = render_stop;
}

/* converts render_start and render_stop to their slaved values */
static void
gst_audio_base_sink_handle_slaving (GstAudioBaseSink * sink,
    GstClockTime render_start, GstClockTime render_stop,
    GstClockTime * srender_start, GstClockTime * srender_stop)
{
  switch (sink->priv->slave_method) {
    case GST_AUDIO_BASE_SINK_SLAVE_RESAMPLE:
      gst_audio_base_sink_resample_slaving (sink, render_start, render_stop,
          srender_start, srender_stop);
      break;
    case GST_AUDIO_BASE_SINK_SLAVE_SKEW:
      gst_audio_base_sink_skew_slaving (sink, render_start, render_stop,
          srender_start, srender_stop);
      break;
    case GST_AUDIO_BASE_SINK_SLAVE_NONE:
      gst_audio_base_sink_none_slaving (sink, render_start, render_stop,
          srender_start, srender_stop);
      break;
    default:
      g_warning ("unknown slaving method %d", sink->priv->slave_method);
      break;
  }
}

/* must be called with LOCK */
static GstFlowReturn
gst_audio_base_sink_sync_latency (GstBaseSink * bsink, GstMiniObject * obj)
{
  GstClock *clock;
  GstClockReturn status;
  GstClockTime time, render_delay;
  GstFlowReturn ret;
  GstAudioBaseSink *sink;
  GstClockTime itime, etime;
  GstClockTime rate_num, rate_denom;
  GstClockTimeDiff jitter;

  sink = GST_AUDIO_BASE_SINK (bsink);

  clock = GST_ELEMENT_CLOCK (sink);
  if (G_UNLIKELY (clock == NULL))
    goto no_clock;

  /* we provided the global clock, don't need to do anything special */
  if (clock == sink->provided_clock)
    goto no_slaving;

  GST_OBJECT_UNLOCK (sink);

  do {
    GST_DEBUG_OBJECT (sink, "checking preroll");

    ret = gst_base_sink_do_preroll (bsink, obj);
    if (ret != GST_FLOW_OK)
      goto flushing;

    GST_OBJECT_LOCK (sink);
    time = sink->priv->us_latency;
    GST_OBJECT_UNLOCK (sink);

    /* Renderdelay is added onto our own latency, and needs
     * to be subtracted as well */
    render_delay = gst_base_sink_get_render_delay (bsink);

    if (G_LIKELY (time > render_delay))
      time -= render_delay;
    else
      time = 0;

    /* preroll done, we can sync since we are in PLAYING now. */
    GST_DEBUG_OBJECT (sink, "possibly waiting for clock to reach %"
        GST_TIME_FORMAT, GST_TIME_ARGS (time));

    /* wait for the clock, this can be interrupted because we got shut down or
     * we PAUSED. */
    status = gst_base_sink_wait_clock (bsink, time, &jitter);

    GST_DEBUG_OBJECT (sink, "clock returned %d %" GST_TIME_FORMAT, status,
        GST_TIME_ARGS (jitter));

    /* invalid time, no clock or sync disabled, just continue then */
    if (status == GST_CLOCK_BADTIME)
      break;

    /* waiting could have been interrupted and we can be flushing now */
    if (G_UNLIKELY (bsink->flushing))
      goto flushing;

    /* retry if we got unscheduled, which means we did not reach the timeout
     * yet. if some other error occures, we continue. */
  } while (status == GST_CLOCK_UNSCHEDULED);

  GST_OBJECT_LOCK (sink);
  GST_DEBUG_OBJECT (sink, "latency synced");

  /* when we prerolled in time, we can accurately set the calibration,
   * our internal clock should exactly have been the latency (== the running
   * time of the external clock) */
  etime = GST_ELEMENT_CAST (sink)->base_time + time;
  itime = gst_audio_clock_get_time (sink->provided_clock);
  itime = gst_audio_clock_adjust (sink->provided_clock, itime);

  if (status == GST_CLOCK_EARLY) {
    /* when we prerolled late, we have to take into account the lateness */
    GST_DEBUG_OBJECT (sink, "late preroll, adding jitter");
    etime += jitter;
  }

  /* start ringbuffer so we can start slaving right away when we need to */
  gst_audio_ring_buffer_start (sink->ringbuffer);

  GST_DEBUG_OBJECT (sink,
      "internal time: %" GST_TIME_FORMAT " external time: %" GST_TIME_FORMAT,
      GST_TIME_ARGS (itime), GST_TIME_ARGS (etime));

  /* copy the original calibrated rate but update the internal and external
   * times. */
  gst_clock_get_calibration (sink->provided_clock, NULL, NULL, &rate_num,
      &rate_denom);
  gst_clock_set_calibration (sink->provided_clock, itime, etime,
      rate_num, rate_denom);

  switch (sink->priv->slave_method) {
    case GST_AUDIO_BASE_SINK_SLAVE_RESAMPLE:
      /* only set as master when we are resampling */
      GST_DEBUG_OBJECT (sink, "Setting clock as master");
      gst_clock_set_master (sink->provided_clock, clock);
      break;
    case GST_AUDIO_BASE_SINK_SLAVE_SKEW:
    case GST_AUDIO_BASE_SINK_SLAVE_NONE:
    default:
      break;
  }

  gst_audio_base_sink_reset_sync (sink);

  return GST_FLOW_OK;

  /* ERRORS */
no_clock:
  {
    GST_DEBUG_OBJECT (sink, "we have no clock");
    return GST_FLOW_OK;
  }
no_slaving:
  {
    GST_DEBUG_OBJECT (sink, "we are not slaved");
    return GST_FLOW_OK;
  }
flushing:
  {
    GST_DEBUG_OBJECT (sink, "we are flushing");
    GST_OBJECT_LOCK (sink);
    return GST_FLOW_FLUSHING;
  }
}

static gint64
gst_audio_base_sink_get_alignment (GstAudioBaseSink * sink,
    GstClockTime sample_offset)
{
  GstAudioRingBuffer *ringbuf = sink->ringbuffer;
  gint64 align;
  gint64 sample_diff;
  gint64 max_sample_diff;
  gint segdone = g_atomic_int_get (&ringbuf->segdone) - ringbuf->segbase;
  gint64 samples_done = segdone * (gint64) ringbuf->samples_per_seg;
  gint64 headroom = sample_offset - samples_done;
  gboolean allow_align = TRUE;
  gboolean discont = FALSE;
  gint rate;

  /* now try to align the sample to the previous one. */

  /* calc align with previous sample and determine how big the
   * difference is. */
  align = sink->next_sample - sample_offset;
  sample_diff = ABS (align);

  /* calculate the max allowed drift in units of samples. */
  rate = GST_AUDIO_INFO_RATE (&ringbuf->spec.info);
  max_sample_diff = gst_util_uint64_scale_int (sink->priv->alignment_threshold,
      rate, GST_SECOND);

  /* don't align if it means writing behind the read-segment */
  if (sample_diff > headroom && align < 0)
    allow_align = FALSE;

  if (G_UNLIKELY (sample_diff >= max_sample_diff)) {
    /* wait before deciding to make a discontinuity */
    if (sink->priv->discont_wait > 0) {
      GstClockTime time = gst_util_uint64_scale_int (sample_offset,
          GST_SECOND, rate);
      if (sink->priv->discont_time == -1) {
        /* discont candidate */
        sink->priv->discont_time = time;
      } else if (time - sink->priv->discont_time >= sink->priv->discont_wait) {
        /* discont_wait expired, discontinuity detected */
        discont = TRUE;
        sink->priv->discont_time = -1;
      }
    } else {
      discont = TRUE;
    }
  } else if (G_UNLIKELY (sink->priv->discont_time != -1)) {
    /* we have had a discont, but are now back on track! */
    sink->priv->discont_time = -1;
  }

  if (G_LIKELY (!discont && allow_align)) {
    GST_DEBUG_OBJECT (sink,
        "align with prev sample, ABS (%" G_GINT64_FORMAT ") < %"
        G_GINT64_FORMAT, align, max_sample_diff);
  } else {
    gint64 diff_s G_GNUC_UNUSED;

    /* calculate sample diff in seconds for error message */
    diff_s = gst_util_uint64_scale_int (sample_diff, GST_SECOND, rate);

    /* timestamps drifted apart from previous samples too much, we need to
     * resync. We log this as an element warning. */
    GST_WARNING_OBJECT (sink,
        "Unexpected discontinuity in audio timestamps of "
        "%s%" GST_TIME_FORMAT ", resyncing",
        sample_offset > sink->next_sample ? "+" : "-", GST_TIME_ARGS (diff_s));
    align = 0;
  }

  return align;
}

static GstFlowReturn
gst_audio_base_sink_render (GstBaseSink * bsink, GstBuffer * buf)
{
  guint64 in_offset;
  GstClockTime time, stop, render_start, render_stop, sample_offset;
  GstClockTimeDiff sync_offset, ts_offset;
  GstAudioBaseSinkClass *bclass;
  GstAudioBaseSink *sink;
  GstAudioRingBuffer *ringbuf;
  gint64 diff, align;
  guint64 ctime, cstop;
  gsize offset;
  GstMapInfo info;
  gsize size;
  guint samples, written;
  gint bpf, rate;
  gint accum;
  gint out_samples;
  GstClockTime base_time, render_delay, latency;
  GstClock *clock;
  gboolean sync, slaved, align_next;
  GstFlowReturn ret;
  GstSegment clip_seg;
  gint64 time_offset;
  GstBuffer *out = NULL;

  sink = GST_AUDIO_BASE_SINK (bsink);
  bclass = GST_AUDIO_BASE_SINK_GET_CLASS (sink);

  ringbuf = sink->ringbuffer;

  /* can't do anything when we don't have the device */
  if (G_UNLIKELY (!gst_audio_ring_buffer_is_acquired (ringbuf)))
    goto wrong_state;

  /* Wait for upstream latency before starting the ringbuffer, we do this so
   * that we can align the first sample of the ringbuffer to the base_time +
   * latency. */
  GST_OBJECT_LOCK (sink);
  base_time = GST_ELEMENT_CAST (sink)->base_time;
  if (G_UNLIKELY (sink->priv->sync_latency)) {
    ret = gst_audio_base_sink_sync_latency (bsink, GST_MINI_OBJECT_CAST (buf));
    GST_OBJECT_UNLOCK (sink);
    if (G_UNLIKELY (ret != GST_FLOW_OK))
      goto sync_latency_failed;
    /* only do this once until we are set back to PLAYING */
    sink->priv->sync_latency = FALSE;
  } else {
    GST_OBJECT_UNLOCK (sink);
  }

  /* Before we go on, let's see if we need to payload the data. If yes, we also
   * need to unref the output buffer before leaving. */
  if (bclass->payload) {
    out = bclass->payload (sink, buf);

    if (!out)
      goto payload_failed;

    buf = out;
  }

  bpf = GST_AUDIO_INFO_BPF (&ringbuf->spec.info);
  rate = GST_AUDIO_INFO_RATE (&ringbuf->spec.info);

  size = gst_buffer_get_size (buf);
  if (G_UNLIKELY (size % bpf) != 0)
    goto wrong_size;

  samples = size / bpf;
  out_samples = samples;

  in_offset = GST_BUFFER_OFFSET (buf);
  time = GST_BUFFER_TIMESTAMP (buf);

  GST_DEBUG_OBJECT (sink,
      "time %" GST_TIME_FORMAT ", offset %" G_GUINT64_FORMAT ", start %"
      GST_TIME_FORMAT ", samples %u", GST_TIME_ARGS (time), in_offset,
      GST_TIME_ARGS (bsink->segment.start), samples);

  offset = 0;

  /* if not valid timestamp or we can't clip or sync, try to play
   * sample ASAP */
  if (!GST_CLOCK_TIME_IS_VALID (time)) {
    render_start = gst_audio_base_sink_get_offset (sink);
    render_stop = render_start + samples;
    GST_DEBUG_OBJECT (sink, "Buffer of size %" G_GSIZE_FORMAT " has no time."
        " Using render_start=%" G_GUINT64_FORMAT, size, render_start);
    /* we don't have a start so we don't know stop either */
    stop = -1;
    goto no_align;
  }

  /* let's calc stop based on the number of samples in the buffer instead
   * of trusting the DURATION */
  stop = time + gst_util_uint64_scale_int (samples, GST_SECOND, rate);

  /* prepare the clipping segment. Since we will be subtracting ts-offset and
   * device-delay later we scale the start and stop with those values so that we
   * can correctly clip them */
  clip_seg.format = GST_FORMAT_TIME;
  clip_seg.start = bsink->segment.start;
  clip_seg.stop = bsink->segment.stop;
  clip_seg.duration = -1;

  /* the sync offset is the combination of ts-offset and device-delay */
  latency = gst_base_sink_get_latency (bsink);
  ts_offset = gst_base_sink_get_ts_offset (bsink);
  render_delay = gst_base_sink_get_render_delay (bsink);
  sync_offset = ts_offset - render_delay + latency;

  GST_DEBUG_OBJECT (sink,
      "sync-offset %" G_GINT64_FORMAT ", render-delay %" GST_TIME_FORMAT
      ", ts-offset %" G_GINT64_FORMAT, sync_offset,
      GST_TIME_ARGS (render_delay), ts_offset);

  /* compensate for ts-offset and device-delay when negative we need to
   * clip. */
  if (G_UNLIKELY (sync_offset < 0)) {
    clip_seg.start += -sync_offset;
    if (clip_seg.stop != -1)
      clip_seg.stop += -sync_offset;
  }

  /* samples should be rendered based on their timestamp. All samples
   * arriving before the segment.start or after segment.stop are to be
   * thrown away. All samples should also be clipped to the segment
   * boundaries */
  if (G_UNLIKELY (!gst_segment_clip (&clip_seg, GST_FORMAT_TIME, time, stop,
              &ctime, &cstop)))
    goto out_of_segment;

  /* see if some clipping happened */
  diff = ctime - time;
  if (G_UNLIKELY (diff > 0)) {
    /* bring clipped time to samples */
    diff = gst_util_uint64_scale_int (diff, rate, GST_SECOND);
    GST_DEBUG_OBJECT (sink, "clipping start to %" GST_TIME_FORMAT " %"
        G_GUINT64_FORMAT " samples", GST_TIME_ARGS (ctime), diff);
    samples -= diff;
    offset += diff * bpf;
    time = ctime;
  }
  diff = stop - cstop;
  if (G_UNLIKELY (diff > 0)) {
    /* bring clipped time to samples */
    diff = gst_util_uint64_scale_int (diff, rate, GST_SECOND);
    GST_DEBUG_OBJECT (sink, "clipping stop to %" GST_TIME_FORMAT " %"
        G_GUINT64_FORMAT " samples", GST_TIME_ARGS (cstop), diff);
    samples -= diff;
    stop = cstop;
  }

  /* figure out how to sync */
  if (G_LIKELY ((clock = GST_ELEMENT_CLOCK (bsink))))
    sync = bsink->sync;
  else
    sync = FALSE;

  if (G_UNLIKELY (!sync)) {
    /* no sync needed, play sample ASAP */
    render_start = gst_audio_base_sink_get_offset (sink);
    render_stop = render_start + samples;
    GST_DEBUG_OBJECT (sink,
        "no sync needed. Using render_start=%" G_GUINT64_FORMAT, render_start);
    goto no_align;
  }

  /* bring buffer start and stop times to running time */
  render_start =
      gst_segment_to_running_time (&bsink->segment, GST_FORMAT_TIME, time);
  render_stop =
      gst_segment_to_running_time (&bsink->segment, GST_FORMAT_TIME, stop);

  GST_DEBUG_OBJECT (sink,
      "running: start %" GST_TIME_FORMAT " - stop %" GST_TIME_FORMAT,
      GST_TIME_ARGS (render_start), GST_TIME_ARGS (render_stop));

  /* store the time of the last sample, we'll use this to perform sync on the
   * last sample when draining the buffer */
  if (G_LIKELY (bsink->segment.rate >= 0.0)) {
    sink->priv->eos_time = render_stop;
  } else {
    sink->priv->eos_time = render_start;
  }

  if (G_UNLIKELY (sync_offset != 0)) {
    /* compensate for ts-offset and delay. We know this will not underflow
     * because we clipped above. */
    GST_DEBUG_OBJECT (sink,
        "compensating for sync-offset %" GST_TIME_FORMAT,
        GST_TIME_ARGS (sync_offset));
    render_start += sync_offset;
    render_stop += sync_offset;
  }

  if (base_time != 0) {
    GST_DEBUG_OBJECT (sink, "adding base_time %" GST_TIME_FORMAT,
        GST_TIME_ARGS (base_time));

    /* add base time to sync against the clock */
    render_start += base_time;
    render_stop += base_time;
  }

  if (G_UNLIKELY ((slaved = (clock != sink->provided_clock)))) {
    /* handle clock slaving */
    gst_audio_base_sink_handle_slaving (sink, render_start, render_stop,
        &render_start, &render_stop);
  } else {
    /* no slaving needed but we need to adapt to the clock calibration
     * parameters */
    gst_audio_base_sink_none_slaving (sink, render_start, render_stop,
        &render_start, &render_stop);
  }

  GST_DEBUG_OBJECT (sink,
      "final timestamps: start %" GST_TIME_FORMAT " - stop %" GST_TIME_FORMAT,
      GST_TIME_ARGS (render_start), GST_TIME_ARGS (render_stop));

  /* bring to position in the ringbuffer */
  time_offset = GST_AUDIO_CLOCK_CAST (sink->provided_clock)->time_offset;

  if (G_UNLIKELY (time_offset != 0)) {
    GST_DEBUG_OBJECT (sink,
        "apply time offset %" GST_TIME_FORMAT, GST_TIME_ARGS (time_offset));

    if (render_start > time_offset)
      render_start -= time_offset;
    else
      render_start = 0;
    if (render_stop > time_offset)
      render_stop -= time_offset;
    else
      render_stop = 0;
  }

  /* in some clock slaving cases, all late samples end up at 0 first,
   * and subsequent ones align with that until threshold exceeded,
   * and then sync back to 0 and so on, so avoid that altogether */
  if (G_UNLIKELY (render_start == 0 && render_stop == 0))
    goto too_late;

  /* and bring the time to the rate corrected offset in the buffer */
  render_start = gst_util_uint64_scale_int (render_start, rate, GST_SECOND);
  render_stop = gst_util_uint64_scale_int (render_stop, rate, GST_SECOND);

  /* If the slaving got us an interval spanning 0, render_start will
     have been set to 0. So if render_start is 0, we check whether
     render_stop is set to contain all samples. If not, we need to
     drop samples to match. */
  if (render_start == 0) {
    guint nsamples = render_stop - render_start;
    if (nsamples < samples) {
      guint diff;

      diff = samples - nsamples;
      GST_DEBUG_OBJECT (bsink, "Clipped start: %u/%u samples", nsamples,
          samples);
      samples -= diff;
      offset += diff * bpf;
    }
  }

  /* positive playback rate, first sample is render_start, negative rate, first
   * sample is render_stop. When no rate conversion is active, render exactly
   * the amount of input samples to avoid aligning to rounding errors. */
  if (G_LIKELY (bsink->segment.rate >= 0.0)) {
    sample_offset = render_start;
    if (G_LIKELY (bsink->segment.rate == 1.0))
      render_stop = sample_offset + samples;
  } else {
    sample_offset = render_stop;
    if (bsink->segment.rate == -1.0)
      render_start = sample_offset + samples;
  }

  /* always resync after a discont */
  if (G_UNLIKELY (GST_BUFFER_FLAG_IS_SET (buf, GST_BUFFER_FLAG_DISCONT) ||
          GST_BUFFER_FLAG_IS_SET (buf, GST_BUFFER_FLAG_RESYNC))) {
    GST_DEBUG_OBJECT (sink, "resync after discont/resync");
    goto no_align;
  }

  /* resync when we don't know what to align the sample with */
  if (G_UNLIKELY (sink->next_sample == -1)) {
    GST_DEBUG_OBJECT (sink,
        "no align possible: no previous sample position known");
    goto no_align;
  }

  align = gst_audio_base_sink_get_alignment (sink, sample_offset);
  sink->priv->last_align = align;

  /* apply alignment */
  render_start += align;

  /* only align stop if we are not slaved to resample */
  if (G_UNLIKELY (slaved
          && sink->priv->slave_method == GST_AUDIO_BASE_SINK_SLAVE_RESAMPLE)) {
    GST_DEBUG_OBJECT (sink, "no stop time align needed: we are slaved");
    goto no_align;
  }
  render_stop += align;

no_align:
  /* number of target samples is difference between start and stop */
  out_samples = render_stop - render_start;

  /* we render the first or last sample first, depending on the rate */
  if (G_LIKELY (bsink->segment.rate >= 0.0))
    sample_offset = render_start;
  else
    sample_offset = render_stop;

  GST_DEBUG_OBJECT (sink, "rendering at %" G_GUINT64_FORMAT " %d/%d",
      sample_offset, samples, out_samples);

  /* we need to accumulate over different runs for when we get interrupted */
  accum = 0;
  align_next = TRUE;
  gst_buffer_map (buf, &info, GST_MAP_READ);
  do {
    written =
        gst_audio_ring_buffer_commit (ringbuf, &sample_offset,
        info.data + offset, samples, out_samples, &accum);

    GST_DEBUG_OBJECT (sink, "wrote %u of %u", written, samples);
    /* if we wrote all, we're done */
    if (G_LIKELY (written == samples))
      break;

    /* else something interrupted us and we wait for preroll. */
    if ((ret = gst_base_sink_wait_preroll (bsink)) != GST_FLOW_OK)
      goto stopping;

    /* if we got interrupted, we cannot assume that the next sample should
     * be aligned to this one */
    align_next = FALSE;

    /* update the output samples. FIXME, this will just skip them when pausing
     * during trick mode */
    if (out_samples > written) {
      out_samples -= written;
      accum = 0;
    } else
      break;

    samples -= written;
    offset += written * bpf;
  } while (TRUE);
  gst_buffer_unmap (buf, &info);

  if (G_LIKELY (align_next))
    sink->next_sample = sample_offset;
  else
    sink->next_sample = -1;

  GST_DEBUG_OBJECT (sink, "next sample expected at %" G_GUINT64_FORMAT,
      sink->next_sample);

  if (G_UNLIKELY (GST_CLOCK_TIME_IS_VALID (stop)
          && stop >= bsink->segment.stop)) {
    GST_DEBUG_OBJECT (sink,
        "start playback because we are at the end of segment");
    gst_audio_ring_buffer_start (ringbuf);
  }

  ret = GST_FLOW_OK;

done:
  if (out)
    gst_buffer_unref (out);

  return ret;

  /* SPECIAL cases */
out_of_segment:
  {
    GST_DEBUG_OBJECT (sink,
        "dropping sample out of segment time %" GST_TIME_FORMAT ", start %"
        GST_TIME_FORMAT, GST_TIME_ARGS (time),
        GST_TIME_ARGS (bsink->segment.start));
    ret = GST_FLOW_OK;
    goto done;
  }
too_late:
  {
    GST_DEBUG_OBJECT (sink, "dropping late sample");
    ret = GST_FLOW_OK;
    goto done;
  }
  /* ERRORS */
payload_failed:
  {
    GST_ELEMENT_ERROR (sink, STREAM, FORMAT, (NULL), ("failed to payload."));
    ret = GST_FLOW_ERROR;
    goto done;
  }
wrong_state:
  {
    GST_DEBUG_OBJECT (sink, "ringbuffer not negotiated");
    GST_ELEMENT_ERROR (sink, STREAM, FORMAT, (NULL), ("sink not negotiated."));
    ret = GST_FLOW_NOT_NEGOTIATED;
    goto done;
  }
wrong_size:
  {
    GST_DEBUG_OBJECT (sink, "wrong size");
    GST_ELEMENT_ERROR (sink, STREAM, WRONG_TYPE,
        (NULL), ("sink received buffer of wrong size."));
    ret = GST_FLOW_ERROR;
    goto done;
  }
stopping:
  {
    GST_DEBUG_OBJECT (sink, "preroll got interrupted: %d (%s)", ret,
        gst_flow_get_name (ret));
    gst_buffer_unmap (buf, &info);
    goto done;
  }
sync_latency_failed:
  {
    GST_DEBUG_OBJECT (sink, "failed waiting for latency");
    goto done;
  }
}

/**
 * gst_audio_base_sink_create_ringbuffer:
 * @sink: a #GstAudioBaseSink.
 *
 * Create and return the #GstAudioRingBuffer for @sink. This function will
 * call the ::create_ringbuffer vmethod and will set @sink as the parent of
 * the returned buffer (see gst_object_set_parent()).
 *
 * Returns: (transfer none): The new ringbuffer of @sink.
 */
GstAudioRingBuffer *
gst_audio_base_sink_create_ringbuffer (GstAudioBaseSink * sink)
{
  GstAudioBaseSinkClass *bclass;
  GstAudioRingBuffer *buffer = NULL;

  bclass = GST_AUDIO_BASE_SINK_GET_CLASS (sink);
  if (bclass->create_ringbuffer)
    buffer = bclass->create_ringbuffer (sink);

  if (buffer)
    gst_object_set_parent (GST_OBJECT (buffer), GST_OBJECT (sink));

  return buffer;
}

static void
gst_audio_base_sink_callback (GstAudioRingBuffer * rbuf, guint8 * data,
    guint len, gpointer user_data)
{
  GstBaseSink *basesink;
  GstAudioBaseSink *sink;
  GstBuffer *buf = NULL;
  GstFlowReturn ret;
  gsize size;

  basesink = GST_BASE_SINK (user_data);
  sink = GST_AUDIO_BASE_SINK (user_data);

  GST_PAD_STREAM_LOCK (basesink->sinkpad);

  /* would be nice to arrange for pad_alloc_buffer to return data -- as it is we
   * will copy twice, once into data, once into DMA */
  GST_LOG_OBJECT (basesink, "pulling %u bytes offset %" G_GUINT64_FORMAT
      " to fill audio buffer", len, basesink->offset);
  ret =
      gst_pad_pull_range (basesink->sinkpad, basesink->segment.position, len,
      &buf);

  if (ret != GST_FLOW_OK) {
    if (ret == GST_FLOW_EOS)
      goto eos;
    else
      goto error;
  }

  GST_BASE_SINK_PREROLL_LOCK (basesink);
  if (basesink->flushing)
    goto flushing;

  /* complete preroll and wait for PLAYING */
  ret = gst_base_sink_do_preroll (basesink, GST_MINI_OBJECT_CAST (buf));
  if (ret != GST_FLOW_OK)
    goto preroll_error;

  size = gst_buffer_get_size (buf);

  if (len != size) {
    GST_INFO_OBJECT (basesink,
        "got different size than requested from sink pad: %u"
        " != %" G_GSIZE_FORMAT, len, size);
    len = MIN (size, len);
  }

  basesink->segment.position += len;

  gst_buffer_extract (buf, 0, data, len);
  GST_BASE_SINK_PREROLL_UNLOCK (basesink);

  GST_PAD_STREAM_UNLOCK (basesink->sinkpad);

  return;

error:
  {
    GST_WARNING_OBJECT (basesink, "Got flow '%s' but can't return it: %d",
        gst_flow_get_name (ret), ret);
    gst_audio_ring_buffer_pause (rbuf);
    GST_PAD_STREAM_UNLOCK (basesink->sinkpad);
    return;
  }
eos:
  {
    /* FIXME: this is not quite correct; we'll be called endlessly until
     * the sink gets shut down; maybe we should set a flag somewhere, or
     * set segment.stop and segment.duration to the last sample or so */
    GST_DEBUG_OBJECT (sink, "EOS");
    gst_audio_base_sink_drain (sink);
    gst_audio_ring_buffer_pause (rbuf);
    gst_element_post_message (GST_ELEMENT_CAST (sink),
        gst_message_new_eos (GST_OBJECT_CAST (sink)));
    GST_PAD_STREAM_UNLOCK (basesink->sinkpad);
  }
flushing:
  {
    GST_DEBUG_OBJECT (sink, "we are flushing");
    gst_audio_ring_buffer_pause (rbuf);
    GST_BASE_SINK_PREROLL_UNLOCK (basesink);
    GST_PAD_STREAM_UNLOCK (basesink->sinkpad);
    return;
  }
preroll_error:
  {
    GST_DEBUG_OBJECT (sink, "error %s", gst_flow_get_name (ret));
    gst_audio_ring_buffer_pause (rbuf);
    GST_BASE_SINK_PREROLL_UNLOCK (basesink);
    GST_PAD_STREAM_UNLOCK (basesink->sinkpad);
    return;
  }
}

static gboolean
gst_audio_base_sink_activate_pull (GstBaseSink * basesink, gboolean active)
{
  gboolean ret;
  GstAudioBaseSink *sink = GST_AUDIO_BASE_SINK (basesink);

  if (active) {
    GST_DEBUG_OBJECT (basesink, "activating pull");

    gst_audio_ring_buffer_set_callback (sink->ringbuffer,
        gst_audio_base_sink_callback, sink);

    ret = gst_audio_ring_buffer_activate (sink->ringbuffer, TRUE);
  } else {
    GST_DEBUG_OBJECT (basesink, "deactivating pull");
    gst_audio_ring_buffer_set_callback (sink->ringbuffer, NULL, NULL);
    ret = gst_audio_ring_buffer_activate (sink->ringbuffer, FALSE);
  }

  return ret;
}

static GstStateChangeReturn
gst_audio_base_sink_change_state (GstElement * element,
    GstStateChange transition)
{
  GstStateChangeReturn ret = GST_STATE_CHANGE_SUCCESS;
  GstAudioBaseSink *sink = GST_AUDIO_BASE_SINK (element);

  switch (transition) {
    case GST_STATE_CHANGE_NULL_TO_READY:
      if (sink->ringbuffer == NULL) {
        gst_audio_clock_reset (GST_AUDIO_CLOCK (sink->provided_clock), 0);
        sink->ringbuffer = gst_audio_base_sink_create_ringbuffer (sink);
      }
      if (!gst_audio_ring_buffer_open_device (sink->ringbuffer))
        goto open_failed;
      break;
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      gst_audio_base_sink_reset_sync (sink);
      gst_audio_ring_buffer_set_flushing (sink->ringbuffer, FALSE);
      gst_audio_ring_buffer_may_start (sink->ringbuffer, FALSE);

      /* Only post clock-provide messages if this is the clock that
       * we've created. If the subclass has overriden it the subclass
       * should post this messages whenever necessary */
      if (sink->provided_clock && GST_IS_AUDIO_CLOCK (sink->provided_clock) &&
          GST_AUDIO_CLOCK_CAST (sink->provided_clock)->func ==
          (GstAudioClockGetTimeFunc) gst_audio_base_sink_get_time)
        gst_element_post_message (element,
            gst_message_new_clock_provide (GST_OBJECT_CAST (element),
                sink->provided_clock, TRUE));
      break;
    case GST_STATE_CHANGE_PAUSED_TO_PLAYING:
    {
      gboolean eos;

      GST_OBJECT_LOCK (sink);
      GST_DEBUG_OBJECT (sink, "ringbuffer may start now");
      sink->priv->sync_latency = TRUE;
      eos = GST_BASE_SINK (sink)->eos;
      GST_OBJECT_UNLOCK (sink);

      gst_audio_ring_buffer_may_start (sink->ringbuffer, TRUE);
      if (GST_BASE_SINK_CAST (sink)->pad_mode == GST_PAD_MODE_PULL ||
          g_atomic_int_get (&sink->eos_rendering) || eos) {
        /* we always start the ringbuffer in pull mode immediatly */
        /* sync rendering on eos needs running clock,
         * and others need running clock when finished rendering eos */
        gst_audio_ring_buffer_start (sink->ringbuffer);
      }
      break;
    }
    case GST_STATE_CHANGE_PLAYING_TO_PAUSED:
      /* ringbuffer cannot start anymore */
      gst_audio_ring_buffer_may_start (sink->ringbuffer, FALSE);
      gst_audio_ring_buffer_pause (sink->ringbuffer);

      GST_OBJECT_LOCK (sink);
      sink->priv->sync_latency = FALSE;
      GST_OBJECT_UNLOCK (sink);
      break;
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      /* Only post clock-lost messages if this is the clock that
       * we've created. If the subclass has overriden it the subclass
       * should post this messages whenever necessary */
      if (sink->provided_clock && GST_IS_AUDIO_CLOCK (sink->provided_clock) &&
          GST_AUDIO_CLOCK_CAST (sink->provided_clock)->func ==
          (GstAudioClockGetTimeFunc) gst_audio_base_sink_get_time)
        gst_element_post_message (element,
            gst_message_new_clock_lost (GST_OBJECT_CAST (element),
                sink->provided_clock));

      /* make sure we unblock before calling the parent state change
       * so it can grab the STREAM_LOCK */
      gst_audio_ring_buffer_set_flushing (sink->ringbuffer, TRUE);
      break;
    default:
      break;
  }

  ret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);

  switch (transition) {
    case GST_STATE_CHANGE_PLAYING_TO_PAUSED:
      /* stop slaving ourselves to the master, if any */
      gst_clock_set_master (sink->provided_clock, NULL);
      break;
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      gst_audio_ring_buffer_activate (sink->ringbuffer, FALSE);
      gst_audio_ring_buffer_release (sink->ringbuffer);
      break;
    case GST_STATE_CHANGE_READY_TO_NULL:
      /* we release again here because the acquire happens when setting the
       * caps, which happens before we commit the state to PAUSED and thus the
       * PAUSED->READY state change (see above, where we release the ringbuffer)
       * might not be called when we get here. */
      gst_audio_ring_buffer_activate (sink->ringbuffer, FALSE);
      gst_audio_ring_buffer_release (sink->ringbuffer);
      gst_audio_ring_buffer_close_device (sink->ringbuffer);
      GST_OBJECT_LOCK (sink);
      gst_object_unparent (GST_OBJECT_CAST (sink->ringbuffer));
      sink->ringbuffer = NULL;
      GST_OBJECT_UNLOCK (sink);
      break;
    default:
      break;
  }

  return ret;

  /* ERRORS */
open_failed:
  {
    /* subclass must post a meaningful error message */
    GST_DEBUG_OBJECT (sink, "open failed");
    return GST_STATE_CHANGE_FAILURE;
  }
}
