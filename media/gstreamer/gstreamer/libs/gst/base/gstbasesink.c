/* GStreamer
 * Copyright (C) 2005-2007 Wim Taymans <wim.taymans@gmail.com>
 *
 * gstbasesink.c: Base class for sink elements
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
 * SECTION:gstbasesink
 * @short_description: Base class for sink elements
 * @see_also: #GstBaseTransform, #GstBaseSrc
 *
 * #GstBaseSink is the base class for sink elements in GStreamer, such as
 * xvimagesink or filesink. It is a layer on top of #GstElement that provides a
 * simplified interface to plugin writers. #GstBaseSink handles many details
 * for you, for example: preroll, clock synchronization, state changes,
 * activation in push or pull mode, and queries.
 *
 * In most cases, when writing sink elements, there is no need to implement
 * class methods from #GstElement or to set functions on pads, because the
 * #GstBaseSink infrastructure should be sufficient.
 *
 * #GstBaseSink provides support for exactly one sink pad, which should be
 * named "sink". A sink implementation (subclass of #GstBaseSink) should
 * install a pad template in its class_init function, like so:
 * |[
 * static void
 * my_element_class_init (GstMyElementClass *klass)
 * {
 *   GstElementClass *gstelement_class = GST_ELEMENT_CLASS (klass);
 *
 *   // sinktemplate should be a #GstStaticPadTemplate with direction
 *   // %GST_PAD_SINK and name "sink"
 *   gst_element_class_add_pad_template (gstelement_class,
 *       gst_static_pad_template_get (&amp;sinktemplate));
 *
 *   gst_element_class_set_static_metadata (gstelement_class,
 *       "Sink name",
 *       "Sink",
 *       "My Sink element",
 *       "The author &lt;my.sink@my.email&gt;");
 * }
 * ]|
 *
 * #GstBaseSink will handle the prerolling correctly. This means that it will
 * return %GST_STATE_CHANGE_ASYNC from a state change to PAUSED until the first
 * buffer arrives in this element. The base class will call the
 * #GstBaseSinkClass.preroll() vmethod with this preroll buffer and will then
 * commit the state change to the next asynchronously pending state.
 *
 * When the element is set to PLAYING, #GstBaseSink will synchronise on the
 * clock using the times returned from #GstBaseSinkClass.get_times(). If this
 * function returns %GST_CLOCK_TIME_NONE for the start time, no synchronisation
 * will be done. Synchronisation can be disabled entirely by setting the object
 * #GstBaseSink:sync property to %FALSE.
 *
 * After synchronisation the virtual method #GstBaseSinkClass.render() will be
 * called. Subclasses should minimally implement this method.
 *
 * Subclasses that synchronise on the clock in the #GstBaseSinkClass.render()
 * method are supported as well. These classes typically receive a buffer in
 * the render method and can then potentially block on the clock while
 * rendering. A typical example is an audiosink.
 * These subclasses can use gst_base_sink_wait_preroll() to perform the
 * blocking wait.
 *
 * Upon receiving the EOS event in the PLAYING state, #GstBaseSink will wait
 * for the clock to reach the time indicated by the stop time of the last
 * #GstBaseSinkClass.get_times() call before posting an EOS message. When the
 * element receives EOS in PAUSED, preroll completes, the event is queued and an
 * EOS message is posted when going to PLAYING.
 *
 * #GstBaseSink will internally use the %GST_EVENT_SEGMENT events to schedule
 * synchronisation and clipping of buffers. Buffers that fall completely outside
 * of the current segment are dropped. Buffers that fall partially in the
 * segment are rendered (and prerolled). Subclasses should do any subbuffer
 * clipping themselves when needed.
 *
 * #GstBaseSink will by default report the current playback position in
 * %GST_FORMAT_TIME based on the current clock time and segment information.
 * If no clock has been set on the element, the query will be forwarded
 * upstream.
 *
 * The #GstBaseSinkClass.set_caps() function will be called when the subclass
 * should configure itself to process a specific media type.
 *
 * The #GstBaseSinkClass.start() and #GstBaseSinkClass.stop() virtual methods
 * will be called when resources should be allocated. Any 
 * #GstBaseSinkClass.preroll(), #GstBaseSinkClass.render() and
 * #GstBaseSinkClass.set_caps() function will be called between the
 * #GstBaseSinkClass.start() and #GstBaseSinkClass.stop() calls.
 *
 * The #GstBaseSinkClass.event() virtual method will be called when an event is
 * received by #GstBaseSink. Normally this method should only be overridden by
 * very specific elements (such as file sinks) which need to handle the
 * newsegment event specially.
 *
 * The #GstBaseSinkClass.unlock() method is called when the elements should
 * unblock any blocking operations they perform in the
 * #GstBaseSinkClass.render() method. This is mostly useful when the
 * #GstBaseSinkClass.render() method performs a blocking write on a file
 * descriptor, for example.
 *
 * The #GstBaseSink:max-lateness property affects how the sink deals with
 * buffers that arrive too late in the sink. A buffer arrives too late in the
 * sink when the presentation time (as a combination of the last segment, buffer
 * timestamp and element base_time) plus the duration is before the current
 * time of the clock.
 * If the frame is later than max-lateness, the sink will drop the buffer
 * without calling the render method.
 * This feature is disabled if sync is disabled, the
 * #GstBaseSinkClass.get_times() method does not return a valid start time or
 * max-lateness is set to -1 (the default).
 * Subclasses can use gst_base_sink_set_max_lateness() to configure the
 * max-lateness value.
 *
 * The #GstBaseSink:qos property will enable the quality-of-service features of
 * the basesink which gather statistics about the real-time performance of the
 * clock synchronisation. For each buffer received in the sink, statistics are
 * gathered and a QOS event is sent upstream with these numbers. This
 * information can then be used by upstream elements to reduce their processing
 * rate, for example.
 *
 * The #GstBaseSink:async property can be used to instruct the sink to never
 * perform an ASYNC state change. This feature is mostly usable when dealing
 * with non-synchronized streams or sparse streams.
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <gst/gst_private.h>

#include "gstbasesink.h"
#include <gst/gst-i18n-lib.h>

GST_DEBUG_CATEGORY_STATIC (gst_base_sink_debug);
#define GST_CAT_DEFAULT gst_base_sink_debug

#define GST_BASE_SINK_GET_PRIVATE(obj)  \
   (G_TYPE_INSTANCE_GET_PRIVATE ((obj), GST_TYPE_BASE_SINK, GstBaseSinkPrivate))

#define GST_FLOW_STEP GST_FLOW_CUSTOM_ERROR

typedef struct
{
  gboolean valid;               /* if this info is valid */
  guint32 seqnum;               /* the seqnum of the STEP event */
  GstFormat format;             /* the format of the amount */
  guint64 amount;               /* the total amount of data to skip */
  guint64 position;             /* the position in the stepped data */
  guint64 duration;             /* the duration in time of the skipped data */
  guint64 start;                /* running_time of the start */
  gdouble rate;                 /* rate of skipping */
  gdouble start_rate;           /* rate before skipping */
  guint64 start_start;          /* start position skipping */
  guint64 start_stop;           /* stop position skipping */
  gboolean flush;               /* if this was a flushing step */
  gboolean intermediate;        /* if this is an intermediate step */
  gboolean need_preroll;        /* if we need preroll after this step */
} GstStepInfo;

struct _GstBaseSinkPrivate
{
  gint qos_enabled;             /* ATOMIC */
  gboolean async_enabled;
  GstClockTimeDiff ts_offset;
  GstClockTime render_delay;

  /* start, stop of current buffer, stream time, used to report position */
  GstClockTime current_sstart;
  GstClockTime current_sstop;

  /* start, stop and jitter of current buffer, running time */
  GstClockTime current_rstart;
  GstClockTime current_rstop;
  GstClockTimeDiff current_jitter;
  /* the running time of the previous buffer */
  GstClockTime prev_rstart;

  /* EOS sync time in running time */
  GstClockTime eos_rtime;

  /* last buffer that arrived in time, running time */
  GstClockTime last_render_time;
  /* when the last buffer left the sink, running time */
  GstClockTime last_left;

  /* running averages go here these are done on running time */
  GstClockTime avg_pt;
  GstClockTime avg_duration;
  gdouble avg_rate;
  GstClockTime avg_in_diff;

  /* these are done on system time. avg_jitter and avg_render are
   * compared to eachother to see if the rendering time takes a
   * huge amount of the processing, If so we are flooded with
   * buffers. */
  GstClockTime last_left_systime;
  GstClockTime avg_jitter;
  GstClockTime start, stop;
  GstClockTime avg_render;

  /* number of rendered and dropped frames */
  guint64 rendered;
  guint64 dropped;

  /* latency stuff */
  GstClockTime latency;

  /* if we already commited the state */
  gboolean commited;
  /* state change to playing ongoing */
  gboolean to_playing;

  /* when we received EOS */
  gboolean received_eos;

  /* when we are prerolled and able to report latency */
  gboolean have_latency;

  /* the last buffer we prerolled or rendered. Useful for making snapshots */
  gint enable_last_sample;      /* atomic */
  GstBuffer *last_buffer;
  GstCaps *last_caps;

  /* negotiated caps */
  GstCaps *caps;

  /* blocksize for pulling */
  guint blocksize;

  gboolean discont;

  /* seqnum of the stream */
  guint32 seqnum;

  gboolean call_preroll;
  gboolean step_unlock;

  /* we have a pending and a current step operation */
  GstStepInfo current_step;
  GstStepInfo pending_step;

  /* Cached GstClockID */
  GstClockID cached_clock_id;

  /* for throttling and QoS */
  GstClockTime earliest_in_time;
  GstClockTime throttle_time;

  /* for rate control */
  guint64 max_bitrate;
  GstClockTime rc_time;
  GstClockTime rc_next;
  gsize rc_accumulated;
};

#define DO_RUNNING_AVG(avg,val,size) (((val) + ((size)-1) * (avg)) / (size))

/* generic running average, this has a neutral window size */
#define UPDATE_RUNNING_AVG(avg,val)   DO_RUNNING_AVG(avg,val,8)

/* the windows for these running averages are experimentally obtained.
 * positive values get averaged more while negative values use a small
 * window so we can react faster to badness. */
#define UPDATE_RUNNING_AVG_P(avg,val) DO_RUNNING_AVG(avg,val,16)
#define UPDATE_RUNNING_AVG_N(avg,val) DO_RUNNING_AVG(avg,val,4)

/* BaseSink properties */

#define DEFAULT_CAN_ACTIVATE_PULL FALSE /* fixme: enable me */
#define DEFAULT_CAN_ACTIVATE_PUSH TRUE

#define DEFAULT_SYNC                TRUE
#define DEFAULT_MAX_LATENESS        -1
#define DEFAULT_QOS                 FALSE
#define DEFAULT_ASYNC               TRUE
#define DEFAULT_TS_OFFSET           0
#define DEFAULT_BLOCKSIZE           4096
#define DEFAULT_RENDER_DELAY        0
#define DEFAULT_ENABLE_LAST_SAMPLE  TRUE
#define DEFAULT_THROTTLE_TIME       0
#define DEFAULT_MAX_BITRATE         0

enum
{
  PROP_0,
  PROP_SYNC,
  PROP_MAX_LATENESS,
  PROP_QOS,
  PROP_ASYNC,
  PROP_TS_OFFSET,
  PROP_ENABLE_LAST_SAMPLE,
  PROP_LAST_SAMPLE,
  PROP_BLOCKSIZE,
  PROP_RENDER_DELAY,
  PROP_THROTTLE_TIME,
  PROP_MAX_BITRATE,
  PROP_LAST
};

static GstElementClass *parent_class = NULL;

static void gst_base_sink_class_init (GstBaseSinkClass * klass);
static void gst_base_sink_init (GstBaseSink * trans, gpointer g_class);
static void gst_base_sink_finalize (GObject * object);

GType
gst_base_sink_get_type (void)
{
  static volatile gsize base_sink_type = 0;

  if (g_once_init_enter (&base_sink_type)) {
    GType _type;
    static const GTypeInfo base_sink_info = {
      sizeof (GstBaseSinkClass),
      NULL,
      NULL,
      (GClassInitFunc) gst_base_sink_class_init,
      NULL,
      NULL,
      sizeof (GstBaseSink),
      0,
      (GInstanceInitFunc) gst_base_sink_init,
    };

    _type = g_type_register_static (GST_TYPE_ELEMENT,
        "GstBaseSink", &base_sink_info, G_TYPE_FLAG_ABSTRACT);
    g_once_init_leave (&base_sink_type, _type);
  }
  return base_sink_type;
}

static void gst_base_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_base_sink_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

static gboolean gst_base_sink_send_event (GstElement * element,
    GstEvent * event);
static gboolean default_element_query (GstElement * element, GstQuery * query);

static GstCaps *gst_base_sink_default_get_caps (GstBaseSink * sink,
    GstCaps * caps);
static gboolean gst_base_sink_default_set_caps (GstBaseSink * sink,
    GstCaps * caps);
static void gst_base_sink_default_get_times (GstBaseSink * basesink,
    GstBuffer * buffer, GstClockTime * start, GstClockTime * end);
static gboolean gst_base_sink_set_flushing (GstBaseSink * basesink,
    GstPad * pad, gboolean flushing);
static gboolean gst_base_sink_default_activate_pull (GstBaseSink * basesink,
    gboolean active);
static gboolean gst_base_sink_default_do_seek (GstBaseSink * sink,
    GstSegment * segment);
static gboolean gst_base_sink_default_prepare_seek_segment (GstBaseSink * sink,
    GstEvent * event, GstSegment * segment);

static GstStateChangeReturn gst_base_sink_change_state (GstElement * element,
    GstStateChange transition);

static gboolean gst_base_sink_sink_query (GstPad * pad, GstObject * parent,
    GstQuery * query);
static GstFlowReturn gst_base_sink_chain (GstPad * pad, GstObject * parent,
    GstBuffer * buffer);
static GstFlowReturn gst_base_sink_chain_list (GstPad * pad, GstObject * parent,
    GstBufferList * list);

static void gst_base_sink_loop (GstPad * pad);
static gboolean gst_base_sink_pad_activate (GstPad * pad, GstObject * parent);
static gboolean gst_base_sink_pad_activate_mode (GstPad * pad,
    GstObject * parent, GstPadMode mode, gboolean active);
static gboolean gst_base_sink_default_event (GstBaseSink * basesink,
    GstEvent * event);
static GstFlowReturn gst_base_sink_default_wait_event (GstBaseSink * basesink,
    GstEvent * event);
static gboolean gst_base_sink_event (GstPad * pad, GstObject * parent,
    GstEvent * event);

static gboolean gst_base_sink_default_query (GstBaseSink * sink,
    GstQuery * query);

static gboolean gst_base_sink_negotiate_pull (GstBaseSink * basesink);
static GstCaps *gst_base_sink_default_fixate (GstBaseSink * bsink,
    GstCaps * caps);
static GstCaps *gst_base_sink_fixate (GstBaseSink * bsink, GstCaps * caps);

/* check if an object was too late */
static gboolean gst_base_sink_is_too_late (GstBaseSink * basesink,
    GstMiniObject * obj, GstClockTime rstart, GstClockTime rstop,
    GstClockReturn status, GstClockTimeDiff jitter, gboolean render);

static void
gst_base_sink_class_init (GstBaseSinkClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;

  gobject_class = G_OBJECT_CLASS (klass);
  gstelement_class = GST_ELEMENT_CLASS (klass);

  GST_DEBUG_CATEGORY_INIT (gst_base_sink_debug, "basesink", 0,
      "basesink element");

  g_type_class_add_private (klass, sizeof (GstBaseSinkPrivate));

  parent_class = g_type_class_peek_parent (klass);

  gobject_class->finalize = gst_base_sink_finalize;
  gobject_class->set_property = gst_base_sink_set_property;
  gobject_class->get_property = gst_base_sink_get_property;

  g_object_class_install_property (gobject_class, PROP_SYNC,
      g_param_spec_boolean ("sync", "Sync", "Sync on the clock", DEFAULT_SYNC,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_MAX_LATENESS,
      g_param_spec_int64 ("max-lateness", "Max Lateness",
          "Maximum number of nanoseconds that a buffer can be late before it "
          "is dropped (-1 unlimited)", -1, G_MAXINT64, DEFAULT_MAX_LATENESS,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_QOS,
      g_param_spec_boolean ("qos", "Qos",
          "Generate Quality-of-Service events upstream", DEFAULT_QOS,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstBaseSink:async:
   *
   * If set to %TRUE, the basesink will perform asynchronous state changes.
   * When set to %FALSE, the sink will not signal the parent when it prerolls.
   * Use this option when dealing with sparse streams or when synchronisation is
   * not required.
   */
  g_object_class_install_property (gobject_class, PROP_ASYNC,
      g_param_spec_boolean ("async", "Async",
          "Go asynchronously to PAUSED", DEFAULT_ASYNC,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstBaseSink:ts-offset:
   *
   * Controls the final synchronisation, a negative value will render the buffer
   * earlier while a positive value delays playback. This property can be
   * used to fix synchronisation in bad files.
   */
  g_object_class_install_property (gobject_class, PROP_TS_OFFSET,
      g_param_spec_int64 ("ts-offset", "TS Offset",
          "Timestamp offset in nanoseconds", G_MININT64, G_MAXINT64,
          DEFAULT_TS_OFFSET, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstBaseSink:enable-last-sample:
   *
   * Enable the last-sample property. If %FALSE, basesink doesn't keep a
   * reference to the last buffer arrived and the last-sample property is always
   * set to %NULL. This can be useful if you need buffers to be released as soon
   * as possible, eg. if you're using a buffer pool.
   */
  g_object_class_install_property (gobject_class, PROP_ENABLE_LAST_SAMPLE,
      g_param_spec_boolean ("enable-last-sample", "Enable Last Buffer",
          "Enable the last-sample property", DEFAULT_ENABLE_LAST_SAMPLE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstBaseSink:last-sample:
   *
   * The last buffer that arrived in the sink and was used for preroll or for
   * rendering. This property can be used to generate thumbnails. This property
   * can be %NULL when the sink has not yet received a buffer.
   */
  g_object_class_install_property (gobject_class, PROP_LAST_SAMPLE,
      g_param_spec_boxed ("last-sample", "Last Sample",
          "The last sample received in the sink", GST_TYPE_SAMPLE,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
  /**
   * GstBaseSink:blocksize:
   *
   * The amount of bytes to pull when operating in pull mode.
   */
  /* FIXME 0.11: blocksize property should be int, otherwise min>max.. */
  g_object_class_install_property (gobject_class, PROP_BLOCKSIZE,
      g_param_spec_uint ("blocksize", "Block size",
          "Size in bytes to pull per buffer (0 = default)", 0, G_MAXUINT,
          DEFAULT_BLOCKSIZE, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstBaseSink:render-delay:
   *
   * The additional delay between synchronisation and actual rendering of the
   * media. This property will add additional latency to the device in order to
   * make other sinks compensate for the delay.
   */
  g_object_class_install_property (gobject_class, PROP_RENDER_DELAY,
      g_param_spec_uint64 ("render-delay", "Render Delay",
          "Additional render delay of the sink in nanoseconds", 0, G_MAXUINT64,
          DEFAULT_RENDER_DELAY, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstBaseSink:throttle-time:
   *
   * The time to insert between buffers. This property can be used to control
   * the maximum amount of buffers per second to render. Setting this property
   * to a value bigger than 0 will make the sink create THROTTLE QoS events.
   */
  g_object_class_install_property (gobject_class, PROP_THROTTLE_TIME,
      g_param_spec_uint64 ("throttle-time", "Throttle time",
          "The time to keep between rendered buffers (0 = disabled)", 0,
          G_MAXUINT64, DEFAULT_THROTTLE_TIME,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstBaseSink:max-bitrate:
   *
   * Control the maximum amount of bits that will be rendered per second.
   * Setting this property to a value bigger than 0 will make the sink delay
   * rendering of the buffers when it would exceed to max-bitrate.
   *
   * Since: 1.2
   */
  g_object_class_install_property (gobject_class, PROP_MAX_BITRATE,
      g_param_spec_uint64 ("max-bitrate", "Max Bitrate",
          "The maximum bits per second to render (0 = disabled)", 0,
          G_MAXUINT64, DEFAULT_MAX_BITRATE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gstelement_class->change_state =
      GST_DEBUG_FUNCPTR (gst_base_sink_change_state);
  gstelement_class->send_event = GST_DEBUG_FUNCPTR (gst_base_sink_send_event);
  gstelement_class->query = GST_DEBUG_FUNCPTR (default_element_query);

  klass->get_caps = GST_DEBUG_FUNCPTR (gst_base_sink_default_get_caps);
  klass->set_caps = GST_DEBUG_FUNCPTR (gst_base_sink_default_set_caps);
  klass->fixate = GST_DEBUG_FUNCPTR (gst_base_sink_default_fixate);
  klass->activate_pull =
      GST_DEBUG_FUNCPTR (gst_base_sink_default_activate_pull);
  klass->get_times = GST_DEBUG_FUNCPTR (gst_base_sink_default_get_times);
  klass->query = GST_DEBUG_FUNCPTR (gst_base_sink_default_query);
  klass->event = GST_DEBUG_FUNCPTR (gst_base_sink_default_event);
  klass->wait_event = GST_DEBUG_FUNCPTR (gst_base_sink_default_wait_event);

  /* Registering debug symbols for function pointers */
  GST_DEBUG_REGISTER_FUNCPTR (gst_base_sink_fixate);
  GST_DEBUG_REGISTER_FUNCPTR (gst_base_sink_pad_activate);
  GST_DEBUG_REGISTER_FUNCPTR (gst_base_sink_pad_activate_mode);
  GST_DEBUG_REGISTER_FUNCPTR (gst_base_sink_event);
  GST_DEBUG_REGISTER_FUNCPTR (gst_base_sink_chain);
  GST_DEBUG_REGISTER_FUNCPTR (gst_base_sink_chain_list);
  GST_DEBUG_REGISTER_FUNCPTR (gst_base_sink_sink_query);
}

static GstCaps *
gst_base_sink_query_caps (GstBaseSink * bsink, GstPad * pad, GstCaps * filter)
{
  GstBaseSinkClass *bclass;
  GstCaps *caps = NULL;
  gboolean fixed;

  bclass = GST_BASE_SINK_GET_CLASS (bsink);
  fixed = GST_PAD_IS_FIXED_CAPS (pad);

  if (fixed || bsink->pad_mode == GST_PAD_MODE_PULL) {
    /* if we are operating in pull mode or fixed caps, we only accept the
     * currently negotiated caps */
    caps = gst_pad_get_current_caps (pad);
  }
  if (caps == NULL) {
    if (bclass->get_caps)
      caps = bclass->get_caps (bsink, filter);

    if (caps == NULL) {
      GstPadTemplate *pad_template;

      pad_template =
          gst_element_class_get_pad_template (GST_ELEMENT_CLASS (bclass),
          "sink");
      if (pad_template != NULL) {
        caps = gst_pad_template_get_caps (pad_template);

        if (filter) {
          GstCaps *intersection;

          intersection =
              gst_caps_intersect_full (filter, caps, GST_CAPS_INTERSECT_FIRST);
          gst_caps_unref (caps);
          caps = intersection;
        }
      }
    }
  }

  return caps;
}

static GstCaps *
gst_base_sink_default_fixate (GstBaseSink * bsink, GstCaps * caps)
{
  GST_DEBUG_OBJECT (bsink, "using default caps fixate function");
  return gst_caps_fixate (caps);
}

static GstCaps *
gst_base_sink_fixate (GstBaseSink * bsink, GstCaps * caps)
{
  GstBaseSinkClass *bclass;

  bclass = GST_BASE_SINK_GET_CLASS (bsink);

  if (bclass->fixate)
    caps = bclass->fixate (bsink, caps);

  return caps;
}

static void
gst_base_sink_init (GstBaseSink * basesink, gpointer g_class)
{
  GstPadTemplate *pad_template;
  GstBaseSinkPrivate *priv;

  basesink->priv = priv = GST_BASE_SINK_GET_PRIVATE (basesink);

  pad_template =
      gst_element_class_get_pad_template (GST_ELEMENT_CLASS (g_class), "sink");
  g_return_if_fail (pad_template != NULL);

  basesink->sinkpad = gst_pad_new_from_template (pad_template, "sink");

  gst_pad_set_activate_function (basesink->sinkpad, gst_base_sink_pad_activate);
  gst_pad_set_activatemode_function (basesink->sinkpad,
      gst_base_sink_pad_activate_mode);
  gst_pad_set_query_function (basesink->sinkpad, gst_base_sink_sink_query);
  gst_pad_set_event_function (basesink->sinkpad, gst_base_sink_event);
  gst_pad_set_chain_function (basesink->sinkpad, gst_base_sink_chain);
  gst_pad_set_chain_list_function (basesink->sinkpad, gst_base_sink_chain_list);
  gst_element_add_pad (GST_ELEMENT_CAST (basesink), basesink->sinkpad);

  basesink->pad_mode = GST_PAD_MODE_NONE;
  g_mutex_init (&basesink->preroll_lock);
  g_cond_init (&basesink->preroll_cond);
  priv->have_latency = FALSE;

  basesink->can_activate_push = DEFAULT_CAN_ACTIVATE_PUSH;
  basesink->can_activate_pull = DEFAULT_CAN_ACTIVATE_PULL;

  basesink->sync = DEFAULT_SYNC;
  basesink->max_lateness = DEFAULT_MAX_LATENESS;
  g_atomic_int_set (&priv->qos_enabled, DEFAULT_QOS);
  priv->async_enabled = DEFAULT_ASYNC;
  priv->ts_offset = DEFAULT_TS_OFFSET;
  priv->render_delay = DEFAULT_RENDER_DELAY;
  priv->blocksize = DEFAULT_BLOCKSIZE;
  priv->cached_clock_id = NULL;
  g_atomic_int_set (&priv->enable_last_sample, DEFAULT_ENABLE_LAST_SAMPLE);
  priv->throttle_time = DEFAULT_THROTTLE_TIME;
  priv->max_bitrate = DEFAULT_MAX_BITRATE;

  GST_OBJECT_FLAG_SET (basesink, GST_ELEMENT_FLAG_SINK);
}

static void
gst_base_sink_finalize (GObject * object)
{
  GstBaseSink *basesink;

  basesink = GST_BASE_SINK (object);

  g_mutex_clear (&basesink->preroll_lock);
  g_cond_clear (&basesink->preroll_cond);

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

/**
 * gst_base_sink_set_sync:
 * @sink: the sink
 * @sync: the new sync value.
 *
 * Configures @sink to synchronize on the clock or not. When
 * @sync is %FALSE, incoming samples will be played as fast as
 * possible. If @sync is %TRUE, the timestamps of the incoming
 * buffers will be used to schedule the exact render time of its
 * contents.
 */
void
gst_base_sink_set_sync (GstBaseSink * sink, gboolean sync)
{
  g_return_if_fail (GST_IS_BASE_SINK (sink));

  GST_OBJECT_LOCK (sink);
  sink->sync = sync;
  GST_OBJECT_UNLOCK (sink);
}

/**
 * gst_base_sink_get_sync:
 * @sink: the sink
 *
 * Checks if @sink is currently configured to synchronize against the
 * clock.
 *
 * Returns: %TRUE if the sink is configured to synchronize against the clock.
 */
gboolean
gst_base_sink_get_sync (GstBaseSink * sink)
{
  gboolean res;

  g_return_val_if_fail (GST_IS_BASE_SINK (sink), FALSE);

  GST_OBJECT_LOCK (sink);
  res = sink->sync;
  GST_OBJECT_UNLOCK (sink);

  return res;
}

/**
 * gst_base_sink_set_max_lateness:
 * @sink: the sink
 * @max_lateness: the new max lateness value.
 *
 * Sets the new max lateness value to @max_lateness. This value is
 * used to decide if a buffer should be dropped or not based on the
 * buffer timestamp and the current clock time. A value of -1 means
 * an unlimited time.
 */
void
gst_base_sink_set_max_lateness (GstBaseSink * sink, gint64 max_lateness)
{
  g_return_if_fail (GST_IS_BASE_SINK (sink));

  GST_OBJECT_LOCK (sink);
  sink->max_lateness = max_lateness;
  GST_OBJECT_UNLOCK (sink);
}

/**
 * gst_base_sink_get_max_lateness:
 * @sink: the sink
 *
 * Gets the max lateness value. See gst_base_sink_set_max_lateness for
 * more details.
 *
 * Returns: The maximum time in nanoseconds that a buffer can be late
 * before it is dropped and not rendered. A value of -1 means an
 * unlimited time.
 */
gint64
gst_base_sink_get_max_lateness (GstBaseSink * sink)
{
  gint64 res;

  g_return_val_if_fail (GST_IS_BASE_SINK (sink), -1);

  GST_OBJECT_LOCK (sink);
  res = sink->max_lateness;
  GST_OBJECT_UNLOCK (sink);

  return res;
}

/**
 * gst_base_sink_set_qos_enabled:
 * @sink: the sink
 * @enabled: the new qos value.
 *
 * Configures @sink to send Quality-of-Service events upstream.
 */
void
gst_base_sink_set_qos_enabled (GstBaseSink * sink, gboolean enabled)
{
  g_return_if_fail (GST_IS_BASE_SINK (sink));

  g_atomic_int_set (&sink->priv->qos_enabled, enabled);
}

/**
 * gst_base_sink_is_qos_enabled:
 * @sink: the sink
 *
 * Checks if @sink is currently configured to send Quality-of-Service events
 * upstream.
 *
 * Returns: %TRUE if the sink is configured to perform Quality-of-Service.
 */
gboolean
gst_base_sink_is_qos_enabled (GstBaseSink * sink)
{
  gboolean res;

  g_return_val_if_fail (GST_IS_BASE_SINK (sink), FALSE);

  res = g_atomic_int_get (&sink->priv->qos_enabled);

  return res;
}

/**
 * gst_base_sink_set_async_enabled:
 * @sink: the sink
 * @enabled: the new async value.
 *
 * Configures @sink to perform all state changes asynchronously. When async is
 * disabled, the sink will immediately go to PAUSED instead of waiting for a
 * preroll buffer. This feature is useful if the sink does not synchronize
 * against the clock or when it is dealing with sparse streams.
 */
void
gst_base_sink_set_async_enabled (GstBaseSink * sink, gboolean enabled)
{
  g_return_if_fail (GST_IS_BASE_SINK (sink));

  GST_BASE_SINK_PREROLL_LOCK (sink);
  g_atomic_int_set (&sink->priv->async_enabled, enabled);
  GST_LOG_OBJECT (sink, "set async enabled to %d", enabled);
  GST_BASE_SINK_PREROLL_UNLOCK (sink);
}

/**
 * gst_base_sink_is_async_enabled:
 * @sink: the sink
 *
 * Checks if @sink is currently configured to perform asynchronous state
 * changes to PAUSED.
 *
 * Returns: %TRUE if the sink is configured to perform asynchronous state
 * changes.
 */
gboolean
gst_base_sink_is_async_enabled (GstBaseSink * sink)
{
  gboolean res;

  g_return_val_if_fail (GST_IS_BASE_SINK (sink), FALSE);

  res = g_atomic_int_get (&sink->priv->async_enabled);

  return res;
}

/**
 * gst_base_sink_set_ts_offset:
 * @sink: the sink
 * @offset: the new offset
 *
 * Adjust the synchronisation of @sink with @offset. A negative value will
 * render buffers earlier than their timestamp. A positive value will delay
 * rendering. This function can be used to fix playback of badly timestamped
 * buffers.
 */
void
gst_base_sink_set_ts_offset (GstBaseSink * sink, GstClockTimeDiff offset)
{
  g_return_if_fail (GST_IS_BASE_SINK (sink));

  GST_OBJECT_LOCK (sink);
  sink->priv->ts_offset = offset;
  GST_LOG_OBJECT (sink, "set time offset to %" G_GINT64_FORMAT, offset);
  GST_OBJECT_UNLOCK (sink);
}

/**
 * gst_base_sink_get_ts_offset:
 * @sink: the sink
 *
 * Get the synchronisation offset of @sink.
 *
 * Returns: The synchronisation offset.
 */
GstClockTimeDiff
gst_base_sink_get_ts_offset (GstBaseSink * sink)
{
  GstClockTimeDiff res;

  g_return_val_if_fail (GST_IS_BASE_SINK (sink), 0);

  GST_OBJECT_LOCK (sink);
  res = sink->priv->ts_offset;
  GST_OBJECT_UNLOCK (sink);

  return res;
}

/**
 * gst_base_sink_get_last_sample:
 * @sink: the sink
 *
 * Get the last sample that arrived in the sink and was used for preroll or for
 * rendering. This property can be used to generate thumbnails.
 *
 * The #GstCaps on the sample can be used to determine the type of the buffer.
 *
 * Free-function: gst_sample_unref
 *
 * Returns: (transfer full) (nullable): a #GstSample. gst_sample_unref() after
 *     usage.  This function returns %NULL when no buffer has arrived in the
 *     sink yet or when the sink is not in PAUSED or PLAYING.
 */
GstSample *
gst_base_sink_get_last_sample (GstBaseSink * sink)
{
  GstSample *res = NULL;

  g_return_val_if_fail (GST_IS_BASE_SINK (sink), NULL);

  GST_OBJECT_LOCK (sink);
  if (sink->priv->last_buffer) {
    res = gst_sample_new (sink->priv->last_buffer,
        sink->priv->last_caps, &sink->segment, NULL);
  }
  GST_OBJECT_UNLOCK (sink);

  return res;
}

/* with OBJECT_LOCK */
static void
gst_base_sink_set_last_buffer_unlocked (GstBaseSink * sink, GstBuffer * buffer)
{
  GstBuffer *old;

  old = sink->priv->last_buffer;
  if (G_LIKELY (old != buffer)) {
    GST_DEBUG_OBJECT (sink, "setting last buffer to %p", buffer);
    if (G_LIKELY (buffer))
      gst_buffer_ref (buffer);
    sink->priv->last_buffer = buffer;
    if (buffer)
      /* copy over the caps */
      gst_caps_replace (&sink->priv->last_caps, sink->priv->caps);
    else
      gst_caps_replace (&sink->priv->last_caps, NULL);
  } else {
    old = NULL;
  }
  /* avoid unreffing with the lock because cleanup code might want to take the
   * lock too */
  if (G_LIKELY (old)) {
    GST_OBJECT_UNLOCK (sink);
    gst_buffer_unref (old);
    GST_OBJECT_LOCK (sink);
  }
}

static void
gst_base_sink_set_last_buffer (GstBaseSink * sink, GstBuffer * buffer)
{
  if (!g_atomic_int_get (&sink->priv->enable_last_sample))
    return;

  GST_OBJECT_LOCK (sink);
  gst_base_sink_set_last_buffer_unlocked (sink, buffer);
  GST_OBJECT_UNLOCK (sink);
}

/**
 * gst_base_sink_set_last_sample_enabled:
 * @sink: the sink
 * @enabled: the new enable-last-sample value.
 *
 * Configures @sink to store the last received sample in the last-sample
 * property.
 */
void
gst_base_sink_set_last_sample_enabled (GstBaseSink * sink, gboolean enabled)
{
  g_return_if_fail (GST_IS_BASE_SINK (sink));

  /* Only take lock if we change the value */
  if (g_atomic_int_compare_and_exchange (&sink->priv->enable_last_sample,
          !enabled, enabled) && !enabled) {
    GST_OBJECT_LOCK (sink);
    gst_base_sink_set_last_buffer_unlocked (sink, NULL);
    GST_OBJECT_UNLOCK (sink);
  }
}

/**
 * gst_base_sink_is_last_sample_enabled:
 * @sink: the sink
 *
 * Checks if @sink is currently configured to store the last received sample in
 * the last-sample property.
 *
 * Returns: %TRUE if the sink is configured to store the last received sample.
 */
gboolean
gst_base_sink_is_last_sample_enabled (GstBaseSink * sink)
{
  g_return_val_if_fail (GST_IS_BASE_SINK (sink), FALSE);

  return g_atomic_int_get (&sink->priv->enable_last_sample);
}

/**
 * gst_base_sink_get_latency:
 * @sink: the sink
 *
 * Get the currently configured latency.
 *
 * Returns: The configured latency.
 */
GstClockTime
gst_base_sink_get_latency (GstBaseSink * sink)
{
  GstClockTime res;

  GST_OBJECT_LOCK (sink);
  res = sink->priv->latency;
  GST_OBJECT_UNLOCK (sink);

  return res;
}

/**
 * gst_base_sink_query_latency:
 * @sink: the sink
 * @live: (out) (allow-none): if the sink is live
 * @upstream_live: (out) (allow-none): if an upstream element is live
 * @min_latency: (out) (allow-none): the min latency of the upstream elements
 * @max_latency: (out) (allow-none): the max latency of the upstream elements
 *
 * Query the sink for the latency parameters. The latency will be queried from
 * the upstream elements. @live will be %TRUE if @sink is configured to
 * synchronize against the clock. @upstream_live will be %TRUE if an upstream
 * element is live.
 *
 * If both @live and @upstream_live are %TRUE, the sink will want to compensate
 * for the latency introduced by the upstream elements by setting the
 * @min_latency to a strictly positive value.
 *
 * This function is mostly used by subclasses.
 *
 * Returns: %TRUE if the query succeeded.
 */
gboolean
gst_base_sink_query_latency (GstBaseSink * sink, gboolean * live,
    gboolean * upstream_live, GstClockTime * min_latency,
    GstClockTime * max_latency)
{
  gboolean l, us_live, res, have_latency;
  GstClockTime min, max, render_delay;
  GstQuery *query;
  GstClockTime us_min, us_max;

  /* we are live when we sync to the clock */
  GST_OBJECT_LOCK (sink);
  l = sink->sync;
  have_latency = sink->priv->have_latency;
  render_delay = sink->priv->render_delay;
  GST_OBJECT_UNLOCK (sink);

  /* assume no latency */
  min = 0;
  max = -1;
  us_live = FALSE;

  if (have_latency) {
    GST_DEBUG_OBJECT (sink, "we are ready for LATENCY query");
    /* we are ready for a latency query this is when we preroll or when we are
     * not async. */
    query = gst_query_new_latency ();

    /* ask the peer for the latency */
    if ((res = gst_pad_peer_query (sink->sinkpad, query))) {
      /* get upstream min and max latency */
      gst_query_parse_latency (query, &us_live, &us_min, &us_max);

      if (us_live) {
        /* upstream live, use its latency, subclasses should use these
         * values to create the complete latency. */
        min = us_min;
        max = us_max;
      }
      if (l) {
        /* we need to add the render delay if we are live */
        if (min != -1)
          min += render_delay;
        if (max != -1)
          max += render_delay;
      }
    }
    gst_query_unref (query);
  } else {
    GST_DEBUG_OBJECT (sink, "we are not yet ready for LATENCY query");
    res = FALSE;
  }

  /* not live, we tried to do the query, if it failed we return TRUE anyway */
  if (!res) {
    if (!l) {
      res = TRUE;
      GST_DEBUG_OBJECT (sink, "latency query failed but we are not live");
    } else {
      GST_DEBUG_OBJECT (sink, "latency query failed and we are live");
    }
  }

  if (res) {
    GST_DEBUG_OBJECT (sink, "latency query: live: %d, have_latency %d,"
        " upstream: %d, min %" GST_TIME_FORMAT ", max %" GST_TIME_FORMAT, l,
        have_latency, us_live, GST_TIME_ARGS (min), GST_TIME_ARGS (max));

    if (live)
      *live = l;
    if (upstream_live)
      *upstream_live = us_live;
    if (min_latency)
      *min_latency = min;
    if (max_latency)
      *max_latency = max;
  }
  return res;
}

/**
 * gst_base_sink_set_render_delay:
 * @sink: a #GstBaseSink
 * @delay: the new delay
 *
 * Set the render delay in @sink to @delay. The render delay is the time
 * between actual rendering of a buffer and its synchronisation time. Some
 * devices might delay media rendering which can be compensated for with this
 * function.
 *
 * After calling this function, this sink will report additional latency and
 * other sinks will adjust their latency to delay the rendering of their media.
 *
 * This function is usually called by subclasses.
 */
void
gst_base_sink_set_render_delay (GstBaseSink * sink, GstClockTime delay)
{
  GstClockTime old_render_delay;

  g_return_if_fail (GST_IS_BASE_SINK (sink));

  GST_OBJECT_LOCK (sink);
  old_render_delay = sink->priv->render_delay;
  sink->priv->render_delay = delay;
  GST_LOG_OBJECT (sink, "set render delay to %" GST_TIME_FORMAT,
      GST_TIME_ARGS (delay));
  GST_OBJECT_UNLOCK (sink);

  if (delay != old_render_delay) {
    GST_DEBUG_OBJECT (sink, "posting latency changed");
    gst_element_post_message (GST_ELEMENT_CAST (sink),
        gst_message_new_latency (GST_OBJECT_CAST (sink)));
  }
}

/**
 * gst_base_sink_get_render_delay:
 * @sink: a #GstBaseSink
 *
 * Get the render delay of @sink. see gst_base_sink_set_render_delay() for more
 * information about the render delay.
 *
 * Returns: the render delay of @sink.
 */
GstClockTime
gst_base_sink_get_render_delay (GstBaseSink * sink)
{
  GstClockTimeDiff res;

  g_return_val_if_fail (GST_IS_BASE_SINK (sink), 0);

  GST_OBJECT_LOCK (sink);
  res = sink->priv->render_delay;
  GST_OBJECT_UNLOCK (sink);

  return res;
}

/**
 * gst_base_sink_set_blocksize:
 * @sink: a #GstBaseSink
 * @blocksize: the blocksize in bytes
 *
 * Set the number of bytes that the sink will pull when it is operating in pull
 * mode.
 */
/* FIXME 0.11: blocksize property should be int, otherwise min>max.. */
void
gst_base_sink_set_blocksize (GstBaseSink * sink, guint blocksize)
{
  g_return_if_fail (GST_IS_BASE_SINK (sink));

  GST_OBJECT_LOCK (sink);
  sink->priv->blocksize = blocksize;
  GST_LOG_OBJECT (sink, "set blocksize to %u", blocksize);
  GST_OBJECT_UNLOCK (sink);
}

/**
 * gst_base_sink_get_blocksize:
 * @sink: a #GstBaseSink
 *
 * Get the number of bytes that the sink will pull when it is operating in pull
 * mode.
 *
 * Returns: the number of bytes @sink will pull in pull mode.
 */
/* FIXME 0.11: blocksize property should be int, otherwise min>max.. */
guint
gst_base_sink_get_blocksize (GstBaseSink * sink)
{
  guint res;

  g_return_val_if_fail (GST_IS_BASE_SINK (sink), 0);

  GST_OBJECT_LOCK (sink);
  res = sink->priv->blocksize;
  GST_OBJECT_UNLOCK (sink);

  return res;
}

/**
 * gst_base_sink_set_throttle_time:
 * @sink: a #GstBaseSink
 * @throttle: the throttle time in nanoseconds
 *
 * Set the time that will be inserted between rendered buffers. This
 * can be used to control the maximum buffers per second that the sink
 * will render. 
 */
void
gst_base_sink_set_throttle_time (GstBaseSink * sink, guint64 throttle)
{
  g_return_if_fail (GST_IS_BASE_SINK (sink));

  GST_OBJECT_LOCK (sink);
  sink->priv->throttle_time = throttle;
  GST_LOG_OBJECT (sink, "set throttle_time to %" G_GUINT64_FORMAT, throttle);
  GST_OBJECT_UNLOCK (sink);
}

/**
 * gst_base_sink_get_throttle_time:
 * @sink: a #GstBaseSink
 *
 * Get the time that will be inserted between frames to control the 
 * maximum buffers per second.
 *
 * Returns: the number of nanoseconds @sink will put between frames.
 */
guint64
gst_base_sink_get_throttle_time (GstBaseSink * sink)
{
  guint64 res;

  g_return_val_if_fail (GST_IS_BASE_SINK (sink), 0);

  GST_OBJECT_LOCK (sink);
  res = sink->priv->throttle_time;
  GST_OBJECT_UNLOCK (sink);

  return res;
}

/**
 * gst_base_sink_set_max_bitrate:
 * @sink: a #GstBaseSink
 * @max_bitrate: the max_bitrate in bits per second
 *
 * Set the maximum amount of bits per second that the sink will render.
 *
 * Since: 1.2
 */
void
gst_base_sink_set_max_bitrate (GstBaseSink * sink, guint64 max_bitrate)
{
  g_return_if_fail (GST_IS_BASE_SINK (sink));

  GST_OBJECT_LOCK (sink);
  sink->priv->max_bitrate = max_bitrate;
  GST_LOG_OBJECT (sink, "set max_bitrate to %" G_GUINT64_FORMAT, max_bitrate);
  GST_OBJECT_UNLOCK (sink);
}

/**
 * gst_base_sink_get_max_bitrate:
 * @sink: a #GstBaseSink
 *
 * Get the maximum amount of bits per second that the sink will render.
 *
 * Returns: the maximum number of bits per second @sink will render.
 *
 * Since: 1.2
 */
guint64
gst_base_sink_get_max_bitrate (GstBaseSink * sink)
{
  guint64 res;

  g_return_val_if_fail (GST_IS_BASE_SINK (sink), 0);

  GST_OBJECT_LOCK (sink);
  res = sink->priv->max_bitrate;
  GST_OBJECT_UNLOCK (sink);

  return res;
}

static void
gst_base_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstBaseSink *sink = GST_BASE_SINK (object);

  switch (prop_id) {
    case PROP_SYNC:
      gst_base_sink_set_sync (sink, g_value_get_boolean (value));
      break;
    case PROP_MAX_LATENESS:
      gst_base_sink_set_max_lateness (sink, g_value_get_int64 (value));
      break;
    case PROP_QOS:
      gst_base_sink_set_qos_enabled (sink, g_value_get_boolean (value));
      break;
    case PROP_ASYNC:
      gst_base_sink_set_async_enabled (sink, g_value_get_boolean (value));
      break;
    case PROP_TS_OFFSET:
      gst_base_sink_set_ts_offset (sink, g_value_get_int64 (value));
      break;
    case PROP_BLOCKSIZE:
      gst_base_sink_set_blocksize (sink, g_value_get_uint (value));
      break;
    case PROP_RENDER_DELAY:
      gst_base_sink_set_render_delay (sink, g_value_get_uint64 (value));
      break;
    case PROP_ENABLE_LAST_SAMPLE:
      gst_base_sink_set_last_sample_enabled (sink, g_value_get_boolean (value));
      break;
    case PROP_THROTTLE_TIME:
      gst_base_sink_set_throttle_time (sink, g_value_get_uint64 (value));
      break;
    case PROP_MAX_BITRATE:
      gst_base_sink_set_max_bitrate (sink, g_value_get_uint64 (value));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_base_sink_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstBaseSink *sink = GST_BASE_SINK (object);

  switch (prop_id) {
    case PROP_SYNC:
      g_value_set_boolean (value, gst_base_sink_get_sync (sink));
      break;
    case PROP_MAX_LATENESS:
      g_value_set_int64 (value, gst_base_sink_get_max_lateness (sink));
      break;
    case PROP_QOS:
      g_value_set_boolean (value, gst_base_sink_is_qos_enabled (sink));
      break;
    case PROP_ASYNC:
      g_value_set_boolean (value, gst_base_sink_is_async_enabled (sink));
      break;
    case PROP_TS_OFFSET:
      g_value_set_int64 (value, gst_base_sink_get_ts_offset (sink));
      break;
    case PROP_LAST_SAMPLE:
      gst_value_take_buffer (value, gst_base_sink_get_last_sample (sink));
      break;
    case PROP_ENABLE_LAST_SAMPLE:
      g_value_set_boolean (value, gst_base_sink_is_last_sample_enabled (sink));
      break;
    case PROP_BLOCKSIZE:
      g_value_set_uint (value, gst_base_sink_get_blocksize (sink));
      break;
    case PROP_RENDER_DELAY:
      g_value_set_uint64 (value, gst_base_sink_get_render_delay (sink));
      break;
    case PROP_THROTTLE_TIME:
      g_value_set_uint64 (value, gst_base_sink_get_throttle_time (sink));
      break;
    case PROP_MAX_BITRATE:
      g_value_set_uint64 (value, gst_base_sink_get_max_bitrate (sink));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}


static GstCaps *
gst_base_sink_default_get_caps (GstBaseSink * sink, GstCaps * filter)
{
  return NULL;
}

static gboolean
gst_base_sink_default_set_caps (GstBaseSink * sink, GstCaps * caps)
{
  return TRUE;
}

/* with PREROLL_LOCK, STREAM_LOCK */
static gboolean
gst_base_sink_commit_state (GstBaseSink * basesink)
{
  /* commit state and proceed to next pending state */
  GstState current, next, pending, post_pending;
  gboolean post_paused = FALSE;
  gboolean post_async_done = FALSE;
  gboolean post_playing = FALSE;

  /* we are certainly not playing async anymore now */
  basesink->playing_async = FALSE;

  GST_OBJECT_LOCK (basesink);
  current = GST_STATE (basesink);
  next = GST_STATE_NEXT (basesink);
  pending = GST_STATE_PENDING (basesink);
  post_pending = pending;

  switch (pending) {
    case GST_STATE_PLAYING:
    {
      GST_DEBUG_OBJECT (basesink, "commiting state to PLAYING");

      basesink->need_preroll = FALSE;
      post_async_done = TRUE;
      basesink->priv->commited = TRUE;
      post_playing = TRUE;
      /* post PAUSED too when we were READY */
      if (current == GST_STATE_READY) {
        post_paused = TRUE;
      }
      break;
    }
    case GST_STATE_PAUSED:
      GST_DEBUG_OBJECT (basesink, "commiting state to PAUSED");
      post_paused = TRUE;
      post_async_done = TRUE;
      basesink->priv->commited = TRUE;
      post_pending = GST_STATE_VOID_PENDING;
      break;
    case GST_STATE_READY:
    case GST_STATE_NULL:
      goto stopping;
    case GST_STATE_VOID_PENDING:
      goto nothing_pending;
    default:
      break;
  }

  /* we can report latency queries now */
  basesink->priv->have_latency = TRUE;

  GST_STATE (basesink) = pending;
  GST_STATE_NEXT (basesink) = GST_STATE_VOID_PENDING;
  GST_STATE_PENDING (basesink) = GST_STATE_VOID_PENDING;
  GST_STATE_RETURN (basesink) = GST_STATE_CHANGE_SUCCESS;
  GST_OBJECT_UNLOCK (basesink);

  if (post_paused) {
    GST_DEBUG_OBJECT (basesink, "posting PAUSED state change message");
    gst_element_post_message (GST_ELEMENT_CAST (basesink),
        gst_message_new_state_changed (GST_OBJECT_CAST (basesink),
            current, next, post_pending));
  }
  if (post_async_done) {
    GST_DEBUG_OBJECT (basesink, "posting async-done message");
    gst_element_post_message (GST_ELEMENT_CAST (basesink),
        gst_message_new_async_done (GST_OBJECT_CAST (basesink),
            GST_CLOCK_TIME_NONE));
  }
  if (post_playing) {
    if (post_paused) {
      GstElementClass *klass;

      klass = GST_ELEMENT_GET_CLASS (basesink);
      basesink->have_preroll = TRUE;
      /* after releasing this lock, the state change function
       * can execute concurrently with this thread. There is nothing we do to
       * prevent this for now. subclasses should be prepared to handle it. */
      GST_BASE_SINK_PREROLL_UNLOCK (basesink);

      if (klass->change_state)
        klass->change_state (GST_ELEMENT_CAST (basesink),
            GST_STATE_CHANGE_PAUSED_TO_PLAYING);

      GST_BASE_SINK_PREROLL_LOCK (basesink);
      /* state change function could have been executed and we could be
       * flushing now */
      if (G_UNLIKELY (basesink->flushing))
        goto stopping;
    }
    GST_DEBUG_OBJECT (basesink, "posting PLAYING state change message");
    /* FIXME, we released the PREROLL lock above, it's possible that this
     * message is not correct anymore when the element went back to PAUSED */
    gst_element_post_message (GST_ELEMENT_CAST (basesink),
        gst_message_new_state_changed (GST_OBJECT_CAST (basesink),
            next, pending, GST_STATE_VOID_PENDING));
  }

  GST_STATE_BROADCAST (basesink);

  return TRUE;

nothing_pending:
  {
    /* Depending on the state, set our vars. We get in this situation when the
     * state change function got a change to update the state vars before the
     * streaming thread did. This is fine but we need to make sure that we
     * update the need_preroll var since it was %TRUE when we got here and might
     * become %FALSE if we got to PLAYING. */
    GST_DEBUG_OBJECT (basesink, "nothing to commit, now in %s",
        gst_element_state_get_name (current));
    switch (current) {
      case GST_STATE_PLAYING:
        basesink->need_preroll = FALSE;
        break;
      case GST_STATE_PAUSED:
        basesink->need_preroll = TRUE;
        break;
      default:
        basesink->need_preroll = FALSE;
        basesink->flushing = TRUE;
        break;
    }
    /* we can report latency queries now */
    basesink->priv->have_latency = TRUE;
    GST_OBJECT_UNLOCK (basesink);
    return TRUE;
  }
stopping:
  {
    /* app is going to READY */
    GST_DEBUG_OBJECT (basesink, "stopping");
    basesink->need_preroll = FALSE;
    basesink->flushing = TRUE;
    GST_OBJECT_UNLOCK (basesink);
    return FALSE;
  }
}

static void
start_stepping (GstBaseSink * sink, GstSegment * segment,
    GstStepInfo * pending, GstStepInfo * current)
{
  gint64 end;
  GstMessage *message;

  GST_DEBUG_OBJECT (sink, "update pending step");

  GST_OBJECT_LOCK (sink);
  memcpy (current, pending, sizeof (GstStepInfo));
  pending->valid = FALSE;
  GST_OBJECT_UNLOCK (sink);

  /* post message first */
  message =
      gst_message_new_step_start (GST_OBJECT (sink), TRUE, current->format,
      current->amount, current->rate, current->flush, current->intermediate);
  gst_message_set_seqnum (message, current->seqnum);
  gst_element_post_message (GST_ELEMENT (sink), message);

  /* get the running time of where we paused and remember it */
  current->start = gst_element_get_start_time (GST_ELEMENT_CAST (sink));
  gst_segment_set_running_time (segment, GST_FORMAT_TIME, current->start);

  /* set the new rate for the remainder of the segment */
  current->start_rate = segment->rate;
  segment->rate *= current->rate;

  /* save values */
  if (segment->rate > 0.0)
    current->start_stop = segment->stop;
  else
    current->start_start = segment->start;

  if (current->format == GST_FORMAT_TIME) {
    /* calculate the running-time when the step operation should stop */
    if (current->amount != -1)
      end = current->start + current->amount;
    else
      end = -1;

    if (!current->flush) {
      gint64 position;

      /* update the segment clipping regions for non-flushing seeks */
      if (segment->rate > 0.0) {
        if (end != -1)
          position = gst_segment_to_position (segment, GST_FORMAT_TIME, end);
        else
          position = segment->stop;

        segment->stop = position;
        segment->position = position;
      } else {
        if (end != -1)
          position = gst_segment_to_position (segment, GST_FORMAT_TIME, end);
        else
          position = segment->start;

        segment->time = position;
        segment->start = position;
        segment->position = position;
      }
    }
  }

  GST_DEBUG_OBJECT (sink, "segment now %" GST_SEGMENT_FORMAT, segment);
  GST_DEBUG_OBJECT (sink, "step started at running_time %" GST_TIME_FORMAT,
      GST_TIME_ARGS (current->start));

  GST_DEBUG_OBJECT (sink, "step amount: %" G_GUINT64_FORMAT ", format: %s, "
      "rate: %f", current->amount, gst_format_get_name (current->format),
      current->rate);
}

static void
stop_stepping (GstBaseSink * sink, GstSegment * segment,
    GstStepInfo * current, gint64 rstart, gint64 rstop, gboolean eos)
{
  gint64 stop, position;
  GstMessage *message;

  GST_DEBUG_OBJECT (sink, "step complete");

  if (segment->rate > 0.0)
    stop = rstart;
  else
    stop = rstop;

  GST_DEBUG_OBJECT (sink,
      "step stop at running_time %" GST_TIME_FORMAT, GST_TIME_ARGS (stop));

  if (stop == -1)
    current->duration = current->position;
  else
    current->duration = stop - current->start;

  GST_DEBUG_OBJECT (sink, "step elapsed running_time %" GST_TIME_FORMAT,
      GST_TIME_ARGS (current->duration));

  position = current->start + current->duration;

  /* now move the segment to the new running time */
  gst_segment_set_running_time (segment, GST_FORMAT_TIME, position);

  if (current->flush) {
    /* and remove the time we flushed, start time did not change */
    segment->base = current->start;
  } else {
    /* start time is now the stepped position */
    gst_element_set_start_time (GST_ELEMENT_CAST (sink), position);
  }

  /* restore the previous rate */
  segment->rate = current->start_rate;

  if (segment->rate > 0.0)
    segment->stop = current->start_stop;
  else
    segment->start = current->start_start;

  /* post the step done when we know the stepped duration in TIME */
  message =
      gst_message_new_step_done (GST_OBJECT_CAST (sink), current->format,
      current->amount, current->rate, current->flush, current->intermediate,
      current->duration, eos);
  gst_message_set_seqnum (message, current->seqnum);
  gst_element_post_message (GST_ELEMENT_CAST (sink), message);

  if (!current->intermediate)
    sink->need_preroll = current->need_preroll;

  /* and the current step info finished and becomes invalid */
  current->valid = FALSE;
}

static gboolean
handle_stepping (GstBaseSink * sink, GstSegment * segment,
    GstStepInfo * current, guint64 * cstart, guint64 * cstop, guint64 * rstart,
    guint64 * rstop)
{
  gboolean step_end = FALSE;

  /* stepping never stops */
  if (current->amount == -1)
    return FALSE;

  /* see if we need to skip this buffer because of stepping */
  switch (current->format) {
    case GST_FORMAT_TIME:
    {
      guint64 end;
      guint64 first, last;
      gdouble abs_rate;

      if (segment->rate > 0.0) {
        if (segment->stop == *cstop)
          *rstop = *rstart + current->amount;

        first = *rstart;
        last = *rstop;
      } else {
        if (segment->start == *cstart)
          *rstart = *rstop + current->amount;

        first = *rstop;
        last = *rstart;
      }

      end = current->start + current->amount;
      current->position = first - current->start;

      abs_rate = ABS (segment->rate);
      if (G_UNLIKELY (abs_rate != 1.0))
        current->position /= abs_rate;

      GST_DEBUG_OBJECT (sink,
          "buffer: %" GST_TIME_FORMAT "-%" GST_TIME_FORMAT,
          GST_TIME_ARGS (first), GST_TIME_ARGS (last));
      GST_DEBUG_OBJECT (sink,
          "got time step %" GST_TIME_FORMAT "-%" GST_TIME_FORMAT "/%"
          GST_TIME_FORMAT, GST_TIME_ARGS (current->position),
          GST_TIME_ARGS (last - current->start),
          GST_TIME_ARGS (current->amount));

      if ((current->flush && current->position >= current->amount)
          || last >= end) {
        GST_DEBUG_OBJECT (sink, "step ended, we need clipping");
        step_end = TRUE;
        if (segment->rate > 0.0) {
          *rstart = end;
          *cstart = gst_segment_to_position (segment, GST_FORMAT_TIME, end);
        } else {
          *rstop = end;
          *cstop = gst_segment_to_position (segment, GST_FORMAT_TIME, end);
        }
      }
      GST_DEBUG_OBJECT (sink,
          "cstart %" GST_TIME_FORMAT ", rstart %" GST_TIME_FORMAT,
          GST_TIME_ARGS (*cstart), GST_TIME_ARGS (*rstart));
      GST_DEBUG_OBJECT (sink,
          "cstop %" GST_TIME_FORMAT ", rstop %" GST_TIME_FORMAT,
          GST_TIME_ARGS (*cstop), GST_TIME_ARGS (*rstop));
      break;
    }
    case GST_FORMAT_BUFFERS:
      GST_DEBUG_OBJECT (sink,
          "got default step %" G_GUINT64_FORMAT "/%" G_GUINT64_FORMAT,
          current->position, current->amount);

      if (current->position < current->amount) {
        current->position++;
      } else {
        step_end = TRUE;
      }
      break;
    case GST_FORMAT_DEFAULT:
    default:
      GST_DEBUG_OBJECT (sink,
          "got unknown step %" G_GUINT64_FORMAT "/%" G_GUINT64_FORMAT,
          current->position, current->amount);
      break;
  }
  return step_end;
}

/* with STREAM_LOCK, PREROLL_LOCK
 *
 * Returns %TRUE if the object needs synchronisation and takes therefore
 * part in prerolling.
 *
 * rsstart/rsstop contain the start/stop in stream time.
 * rrstart/rrstop contain the start/stop in running time.
 */
static gboolean
gst_base_sink_get_sync_times (GstBaseSink * basesink, GstMiniObject * obj,
    GstClockTime * rsstart, GstClockTime * rsstop,
    GstClockTime * rrstart, GstClockTime * rrstop, GstClockTime * rrnext,
    gboolean * do_sync, gboolean * stepped, GstStepInfo * step,
    gboolean * step_end)
{
  GstBaseSinkClass *bclass;
  GstClockTime start, stop;     /* raw start/stop timestamps */
  guint64 cstart, cstop;        /* clipped raw timestamps */
  guint64 rstart, rstop, rnext; /* clipped timestamps converted to running time */
  GstClockTime sstart, sstop;   /* clipped timestamps converted to stream time */
  GstFormat format;
  GstBaseSinkPrivate *priv;
  GstSegment *segment;
  gboolean eos;

  priv = basesink->priv;
  segment = &basesink->segment;

  bclass = GST_BASE_SINK_GET_CLASS (basesink);

again:
  /* start with nothing */
  start = stop = GST_CLOCK_TIME_NONE;
  eos = FALSE;

  if (G_UNLIKELY (GST_IS_EVENT (obj))) {
    GstEvent *event = GST_EVENT_CAST (obj);

    switch (GST_EVENT_TYPE (event)) {
        /* EOS event needs syncing */
      case GST_EVENT_EOS:
      {
        if (segment->rate >= 0.0) {
          sstart = sstop = priv->current_sstop;
          if (!GST_CLOCK_TIME_IS_VALID (sstart)) {
            /* we have not seen a buffer yet, use the segment values */
            sstart = sstop = gst_segment_to_stream_time (segment,
                segment->format, segment->stop);
          }
        } else {
          sstart = sstop = priv->current_sstart;
          if (!GST_CLOCK_TIME_IS_VALID (sstart)) {
            /* we have not seen a buffer yet, use the segment values */
            sstart = sstop = gst_segment_to_stream_time (segment,
                segment->format, segment->start);
          }
        }

        rstart = rstop = rnext = priv->eos_rtime;
        *do_sync = rstart != -1;
        GST_DEBUG_OBJECT (basesink, "sync times for EOS %" GST_TIME_FORMAT,
            GST_TIME_ARGS (rstart));
        /* if we are stepping, we end now */
        *step_end = step->valid;
        eos = TRUE;
        goto eos_done;
      }
      case GST_EVENT_GAP:
      {
        GstClockTime timestamp, duration;
        gst_event_parse_gap (event, &timestamp, &duration);

        GST_DEBUG_OBJECT (basesink, "Got Gap time %" GST_TIME_FORMAT
            " duration %" GST_TIME_FORMAT,
            GST_TIME_ARGS (timestamp), GST_TIME_ARGS (duration));

        if (GST_CLOCK_TIME_IS_VALID (timestamp)) {
          start = timestamp;
          if (GST_CLOCK_TIME_IS_VALID (duration))
            stop = start + duration;
        }
        *do_sync = TRUE;
        break;
      }
      default:
        /* other events do not need syncing */
        return FALSE;
    }
  } else {
    /* else do buffer sync code */
    GstBuffer *buffer = GST_BUFFER_CAST (obj);

    /* just get the times to see if we need syncing, if the start returns -1 we
     * don't sync. */
    if (bclass->get_times)
      bclass->get_times (basesink, buffer, &start, &stop);

    if (!GST_CLOCK_TIME_IS_VALID (start)) {
      /* we don't need to sync but we still want to get the timestamps for
       * tracking the position */
      gst_base_sink_default_get_times (basesink, buffer, &start, &stop);
      *do_sync = FALSE;
    } else {
      *do_sync = TRUE;
    }
  }

  GST_DEBUG_OBJECT (basesink, "got times start: %" GST_TIME_FORMAT
      ", stop: %" GST_TIME_FORMAT ", do_sync %d", GST_TIME_ARGS (start),
      GST_TIME_ARGS (stop), *do_sync);

  /* collect segment and format for code clarity */
  format = segment->format;

  /* clip */
  if (G_UNLIKELY (!gst_segment_clip (segment, format,
              start, stop, &cstart, &cstop))) {
    if (step->valid) {
      GST_DEBUG_OBJECT (basesink, "step out of segment");
      /* when we are stepping, pretend we're at the end of the segment */
      if (segment->rate > 0.0) {
        cstart = segment->stop;
        cstop = segment->stop;
      } else {
        cstart = segment->start;
        cstop = segment->start;
      }
      goto do_times;
    }
    goto out_of_segment;
  }

  if (G_UNLIKELY (start != cstart || stop != cstop)) {
    GST_DEBUG_OBJECT (basesink, "clipped to: start %" GST_TIME_FORMAT
        ", stop: %" GST_TIME_FORMAT, GST_TIME_ARGS (cstart),
        GST_TIME_ARGS (cstop));
  }

  /* set last stop position */
  if (G_LIKELY (stop != GST_CLOCK_TIME_NONE && cstop != GST_CLOCK_TIME_NONE))
    segment->position = cstop;
  else
    segment->position = cstart;

do_times:
  rstart = gst_segment_to_running_time (segment, format, cstart);
  rstop = gst_segment_to_running_time (segment, format, cstop);

  if (GST_CLOCK_TIME_IS_VALID (stop))
    rnext = rstop;
  else
    rnext = rstart;

  if (G_UNLIKELY (step->valid)) {
    if (!(*step_end = handle_stepping (basesink, segment, step, &cstart, &cstop,
                &rstart, &rstop))) {
      /* step is still busy, we discard data when we are flushing */
      *stepped = step->flush;
      GST_DEBUG_OBJECT (basesink, "stepping busy");
    }
  }
  /* this can produce wrong values if we accumulated non-TIME segments. If this happens,
   * upstream is behaving very badly */
  sstart = gst_segment_to_stream_time (segment, format, cstart);
  sstop = gst_segment_to_stream_time (segment, format, cstop);

eos_done:
  /* eos_done label only called when doing EOS, we also stop stepping then */
  if (*step_end && step->flush) {
    GST_DEBUG_OBJECT (basesink, "flushing step ended");
    stop_stepping (basesink, segment, step, rstart, rstop, eos);
    *step_end = FALSE;
    /* re-determine running start times for adjusted segment
     * (which has a flushed amount of running/accumulated time removed) */
    if (!GST_IS_EVENT (obj)) {
      GST_DEBUG_OBJECT (basesink, "refresh sync times");
      goto again;
    }
  }

  /* save times */
  *rsstart = sstart;
  *rsstop = sstop;
  *rrstart = rstart;
  *rrstop = rstop;
  *rrnext = rnext;

  /* buffers and EOS always need syncing and preroll */
  return TRUE;

  /* special cases */
out_of_segment:
  {
    /* we usually clip in the chain function already but stepping could cause
     * the segment to be updated later. we return %FALSE so that we don't try
     * to sync on it. */
    GST_LOG_OBJECT (basesink, "buffer skipped, not in segment");
    return FALSE;
  }
}

/* with STREAM_LOCK, PREROLL_LOCK, LOCK
 * adjust a timestamp with the latency and timestamp offset. This function does
 * not adjust for the render delay. */
static GstClockTime
gst_base_sink_adjust_time (GstBaseSink * basesink, GstClockTime time)
{
  GstClockTimeDiff ts_offset;

  /* don't do anything funny with invalid timestamps */
  if (G_UNLIKELY (!GST_CLOCK_TIME_IS_VALID (time)))
    return time;

  time += basesink->priv->latency;

  /* apply offset, be careful for underflows */
  ts_offset = basesink->priv->ts_offset;
  if (ts_offset < 0) {
    ts_offset = -ts_offset;
    if (ts_offset < time)
      time -= ts_offset;
    else
      time = 0;
  } else
    time += ts_offset;

  /* subtract the render delay again, which was included in the latency */
  if (time > basesink->priv->render_delay)
    time -= basesink->priv->render_delay;
  else
    time = 0;

  return time;
}

/**
 * gst_base_sink_wait_clock:
 * @sink: the sink
 * @time: the running_time to be reached
 * @jitter: (out) (allow-none): the jitter to be filled with time diff, or %NULL
 *
 * This function will block until @time is reached. It is usually called by
 * subclasses that use their own internal synchronisation.
 *
 * If @time is not valid, no synchronisation is done and %GST_CLOCK_BADTIME is
 * returned. Likewise, if synchronisation is disabled in the element or there
 * is no clock, no synchronisation is done and %GST_CLOCK_BADTIME is returned.
 *
 * This function should only be called with the PREROLL_LOCK held, like when
 * receiving an EOS event in the #GstBaseSinkClass.event() vmethod or when
 * receiving a buffer in
 * the #GstBaseSinkClass.render() vmethod.
 *
 * The @time argument should be the running_time of when this method should
 * return and is not adjusted with any latency or offset configured in the
 * sink.
 *
 * Returns: #GstClockReturn
 */
GstClockReturn
gst_base_sink_wait_clock (GstBaseSink * sink, GstClockTime time,
    GstClockTimeDiff * jitter)
{
  GstClockReturn ret;
  GstClock *clock;
  GstClockTime base_time;

  if (G_UNLIKELY (!GST_CLOCK_TIME_IS_VALID (time)))
    goto invalid_time;

  GST_OBJECT_LOCK (sink);
  if (G_UNLIKELY (!sink->sync))
    goto no_sync;

  if (G_UNLIKELY ((clock = GST_ELEMENT_CLOCK (sink)) == NULL))
    goto no_clock;

  base_time = GST_ELEMENT_CAST (sink)->base_time;
  GST_LOG_OBJECT (sink,
      "time %" GST_TIME_FORMAT ", base_time %" GST_TIME_FORMAT,
      GST_TIME_ARGS (time), GST_TIME_ARGS (base_time));

  /* add base_time to running_time to get the time against the clock */
  time += base_time;

  /* Re-use existing clockid if available */
  /* FIXME: Casting to GstClockEntry only works because the types
   * are the same */
  if (G_LIKELY (sink->priv->cached_clock_id != NULL
          && GST_CLOCK_ENTRY_CLOCK ((GstClockEntry *) sink->
              priv->cached_clock_id) == clock)) {
    if (!gst_clock_single_shot_id_reinit (clock, sink->priv->cached_clock_id,
            time)) {
      gst_clock_id_unref (sink->priv->cached_clock_id);
      sink->priv->cached_clock_id = gst_clock_new_single_shot_id (clock, time);
    }
  } else {
    if (sink->priv->cached_clock_id != NULL)
      gst_clock_id_unref (sink->priv->cached_clock_id);
    sink->priv->cached_clock_id = gst_clock_new_single_shot_id (clock, time);
  }
  GST_OBJECT_UNLOCK (sink);

  /* A blocking wait is performed on the clock. We save the ClockID
   * so we can unlock the entry at any time. While we are blocking, we
   * release the PREROLL_LOCK so that other threads can interrupt the
   * entry. */
  sink->clock_id = sink->priv->cached_clock_id;
  /* release the preroll lock while waiting */
  GST_BASE_SINK_PREROLL_UNLOCK (sink);

  ret = gst_clock_id_wait (sink->priv->cached_clock_id, jitter);

  GST_BASE_SINK_PREROLL_LOCK (sink);
  sink->clock_id = NULL;

  return ret;

  /* no syncing needed */
invalid_time:
  {
    GST_DEBUG_OBJECT (sink, "time not valid, no sync needed");
    return GST_CLOCK_BADTIME;
  }
no_sync:
  {
    GST_DEBUG_OBJECT (sink, "sync disabled");
    GST_OBJECT_UNLOCK (sink);
    return GST_CLOCK_BADTIME;
  }
no_clock:
  {
    GST_DEBUG_OBJECT (sink, "no clock, can't sync");
    GST_OBJECT_UNLOCK (sink);
    return GST_CLOCK_BADTIME;
  }
}

/**
 * gst_base_sink_wait_preroll:
 * @sink: the sink
 *
 * If the #GstBaseSinkClass.render() method performs its own synchronisation
 * against the clock it must unblock when going from PLAYING to the PAUSED state
 * and call this method before continuing to render the remaining data.
 *
 * This function will block until a state change to PLAYING happens (in which
 * case this function returns %GST_FLOW_OK) or the processing must be stopped due
 * to a state change to READY or a FLUSH event (in which case this function
 * returns %GST_FLOW_FLUSHING).
 *
 * This function should only be called with the PREROLL_LOCK held, like in the
 * render function.
 *
 * Returns: %GST_FLOW_OK if the preroll completed and processing can
 * continue. Any other return value should be returned from the render vmethod.
 */
GstFlowReturn
gst_base_sink_wait_preroll (GstBaseSink * sink)
{
  sink->have_preroll = TRUE;
  GST_DEBUG_OBJECT (sink, "waiting in preroll for flush or PLAYING");
  /* block until the state changes, or we get a flush, or something */
  GST_BASE_SINK_PREROLL_WAIT (sink);
  sink->have_preroll = FALSE;
  if (G_UNLIKELY (sink->flushing))
    goto stopping;
  if (G_UNLIKELY (sink->priv->step_unlock))
    goto step_unlocked;
  GST_DEBUG_OBJECT (sink, "continue after preroll");

  return GST_FLOW_OK;

  /* ERRORS */
stopping:
  {
    GST_DEBUG_OBJECT (sink, "preroll interrupted because of flush");
    return GST_FLOW_FLUSHING;
  }
step_unlocked:
  {
    sink->priv->step_unlock = FALSE;
    GST_DEBUG_OBJECT (sink, "preroll interrupted because of step");
    return GST_FLOW_STEP;
  }
}

/**
 * gst_base_sink_do_preroll:
 * @sink: the sink
 * @obj: (transfer none): the mini object that caused the preroll
 *
 * If the @sink spawns its own thread for pulling buffers from upstream it
 * should call this method after it has pulled a buffer. If the element needed
 * to preroll, this function will perform the preroll and will then block
 * until the element state is changed.
 *
 * This function should be called with the PREROLL_LOCK held.
 *
 * Returns: %GST_FLOW_OK if the preroll completed and processing can
 * continue. Any other return value should be returned from the render vmethod.
 */
GstFlowReturn
gst_base_sink_do_preroll (GstBaseSink * sink, GstMiniObject * obj)
{
  GstFlowReturn ret;

  while (G_UNLIKELY (sink->need_preroll)) {
    GST_DEBUG_OBJECT (sink, "prerolling object %p", obj);

    /* if it's a buffer, we need to call the preroll method */
    if (sink->priv->call_preroll) {
      GstBaseSinkClass *bclass;
      GstBuffer *buf;

      if (GST_IS_BUFFER_LIST (obj)) {
        buf = gst_buffer_list_get (GST_BUFFER_LIST_CAST (obj), 0);
        g_assert (NULL != buf);
      } else if (GST_IS_BUFFER (obj)) {
        buf = GST_BUFFER_CAST (obj);
        /* For buffer lists do not set last buffer for now */
        gst_base_sink_set_last_buffer (sink, buf);
      } else
        buf = NULL;

      if (buf) {
        GST_DEBUG_OBJECT (sink, "preroll buffer %" GST_TIME_FORMAT,
            GST_TIME_ARGS (GST_BUFFER_TIMESTAMP (buf)));

        bclass = GST_BASE_SINK_GET_CLASS (sink);

        if (bclass->prepare)
          if ((ret = bclass->prepare (sink, buf)) != GST_FLOW_OK)
            goto prepare_canceled;

        if (bclass->preroll)
          if ((ret = bclass->preroll (sink, buf)) != GST_FLOW_OK)
            goto preroll_canceled;

        sink->priv->call_preroll = FALSE;
      }
    }

    /* commit state */
    if (G_LIKELY (sink->playing_async)) {
      if (G_UNLIKELY (!gst_base_sink_commit_state (sink)))
        goto stopping;
    }

    /* need to recheck here because the commit state could have
     * made us not need the preroll anymore */
    if (G_LIKELY (sink->need_preroll)) {
      /* block until the state changes, or we get a flush, or something */
      ret = gst_base_sink_wait_preroll (sink);
      if ((ret != GST_FLOW_OK) && (ret != GST_FLOW_STEP))
        goto preroll_failed;
    }
  }
  return GST_FLOW_OK;

  /* ERRORS */
prepare_canceled:
  {
    GST_DEBUG_OBJECT (sink, "prepare failed, abort state");
    gst_element_abort_state (GST_ELEMENT_CAST (sink));
    return ret;
  }
preroll_canceled:
  {
    GST_DEBUG_OBJECT (sink, "preroll failed, abort state");
    gst_element_abort_state (GST_ELEMENT_CAST (sink));
    return ret;
  }
stopping:
  {
    GST_DEBUG_OBJECT (sink, "stopping while commiting state");
    return GST_FLOW_FLUSHING;
  }
preroll_failed:
  {
    GST_DEBUG_OBJECT (sink, "preroll failed: %s", gst_flow_get_name (ret));
    return ret;
  }
}

/**
 * gst_base_sink_wait:
 * @sink: the sink
 * @time: the running_time to be reached
 * @jitter: (out) (allow-none): the jitter to be filled with time diff, or %NULL
 *
 * This function will wait for preroll to complete and will then block until @time
 * is reached. It is usually called by subclasses that use their own internal
 * synchronisation but want to let some synchronization (like EOS) be handled
 * by the base class.
 *
 * This function should only be called with the PREROLL_LOCK held (like when
 * receiving an EOS event in the ::event vmethod or when handling buffers in
 * ::render).
 *
 * The @time argument should be the running_time of when the timeout should happen
 * and will be adjusted with any latency and offset configured in the sink.
 *
 * Returns: #GstFlowReturn
 */
GstFlowReturn
gst_base_sink_wait (GstBaseSink * sink, GstClockTime time,
    GstClockTimeDiff * jitter)
{
  GstClockReturn status;
  GstFlowReturn ret;

  do {
    GstClockTime stime;

    GST_DEBUG_OBJECT (sink, "checking preroll");

    /* first wait for the playing state before we can continue */
    while (G_UNLIKELY (sink->need_preroll)) {
      ret = gst_base_sink_wait_preroll (sink);
      if ((ret != GST_FLOW_OK) && (ret != GST_FLOW_STEP))
        goto flushing;
    }

    /* preroll done, we can sync since we are in PLAYING now. */
    GST_DEBUG_OBJECT (sink, "possibly waiting for clock to reach %"
        GST_TIME_FORMAT, GST_TIME_ARGS (time));

    /* compensate for latency, ts_offset and render delay */
    stime = gst_base_sink_adjust_time (sink, time);

    /* wait for the clock, this can be interrupted because we got shut down or
     * we PAUSED. */
    status = gst_base_sink_wait_clock (sink, stime, jitter);

    GST_DEBUG_OBJECT (sink, "clock returned %d", status);

    /* invalid time, no clock or sync disabled, just continue then */
    if (status == GST_CLOCK_BADTIME)
      break;

    /* waiting could have been interrupted and we can be flushing now */
    if (G_UNLIKELY (sink->flushing))
      goto flushing;

    /* retry if we got unscheduled, which means we did not reach the timeout
     * yet. if some other error occures, we continue. */
  } while (status == GST_CLOCK_UNSCHEDULED);

  GST_DEBUG_OBJECT (sink, "end of stream");

  return GST_FLOW_OK;

  /* ERRORS */
flushing:
  {
    GST_DEBUG_OBJECT (sink, "we are flushing");
    return GST_FLOW_FLUSHING;
  }
}

/* with STREAM_LOCK, PREROLL_LOCK
 *
 * Make sure we are in PLAYING and synchronize an object to the clock.
 *
 * If we need preroll, we are not in PLAYING. We try to commit the state
 * if needed and then block if we still are not PLAYING.
 *
 * We start waiting on the clock in PLAYING. If we got interrupted, we
 * immediately try to re-preroll.
 *
 * Some objects do not need synchronisation (most events) and so this function
 * immediately returns GST_FLOW_OK.
 *
 * for objects that arrive later than max-lateness to be synchronized to the
 * clock have the @late boolean set to %TRUE.
 *
 * This function keeps a running average of the jitter (the diff between the
 * clock time and the requested sync time). The jitter is negative for
 * objects that arrive in time and positive for late buffers.
 *
 * does not take ownership of obj.
 */
static GstFlowReturn
gst_base_sink_do_sync (GstBaseSink * basesink,
    GstMiniObject * obj, gboolean * late, gboolean * step_end)
{
  GstClockTimeDiff jitter = 0;
  gboolean syncable;
  GstClockReturn status = GST_CLOCK_OK;
  GstClockTime rstart, rstop, rnext, sstart, sstop, stime;
  gboolean do_sync;
  GstBaseSinkPrivate *priv;
  GstFlowReturn ret;
  GstStepInfo *current, *pending;
  gboolean stepped;

  priv = basesink->priv;

do_step:
  sstart = sstop = rstart = rstop = rnext = GST_CLOCK_TIME_NONE;
  do_sync = TRUE;
  stepped = FALSE;

  priv->current_rstart = GST_CLOCK_TIME_NONE;

  /* get stepping info */
  current = &priv->current_step;
  pending = &priv->pending_step;

  /* get timing information for this object against the render segment */
  syncable = gst_base_sink_get_sync_times (basesink, obj,
      &sstart, &sstop, &rstart, &rstop, &rnext, &do_sync, &stepped, current,
      step_end);

  if (G_UNLIKELY (stepped))
    goto step_skipped;

  /* a syncable object needs to participate in preroll and
   * clocking. All buffers and EOS are syncable. */
  if (G_UNLIKELY (!syncable))
    goto not_syncable;

  /* store timing info for current object */
  priv->current_rstart = rstart;
  priv->current_rstop = (GST_CLOCK_TIME_IS_VALID (rstop) ? rstop : rstart);

  /* save sync time for eos when the previous object needed sync */
  priv->eos_rtime = (do_sync ? rnext : GST_CLOCK_TIME_NONE);

  /* calculate inter frame spacing */
  if (G_UNLIKELY (priv->prev_rstart != -1 && priv->prev_rstart < rstart)) {
    GstClockTime in_diff;

    in_diff = rstart - priv->prev_rstart;

    if (priv->avg_in_diff == -1)
      priv->avg_in_diff = in_diff;
    else
      priv->avg_in_diff = UPDATE_RUNNING_AVG (priv->avg_in_diff, in_diff);

    GST_LOG_OBJECT (basesink, "avg frame diff %" GST_TIME_FORMAT,
        GST_TIME_ARGS (priv->avg_in_diff));

  }
  priv->prev_rstart = rstart;

  if (G_UNLIKELY (priv->earliest_in_time != -1
          && rstart < priv->earliest_in_time))
    goto qos_dropped;

again:
  /* first do preroll, this makes sure we commit our state
   * to PAUSED and can continue to PLAYING. We cannot perform
   * any clock sync in PAUSED because there is no clock. */
  ret = gst_base_sink_do_preroll (basesink, obj);
  if (G_UNLIKELY (ret != GST_FLOW_OK))
    goto preroll_failed;

  /* update the segment with a pending step if the current one is invalid and we
   * have a new pending one. We only accept new step updates after a preroll */
  if (G_UNLIKELY (pending->valid && !current->valid)) {
    start_stepping (basesink, &basesink->segment, pending, current);
    goto do_step;
  }

  /* After rendering we store the position of the last buffer so that we can use
   * it to report the position. We need to take the lock here. */
  GST_OBJECT_LOCK (basesink);
  priv->current_sstart = sstart;
  priv->current_sstop = (GST_CLOCK_TIME_IS_VALID (sstop) ? sstop : sstart);
  GST_OBJECT_UNLOCK (basesink);

  if (!do_sync)
    goto done;

  /* adjust for latency */
  stime = gst_base_sink_adjust_time (basesink, rstart);

  /* adjust for rate control */
  if (priv->rc_next == -1 || (stime != -1 && stime >= priv->rc_next)) {
    GST_DEBUG_OBJECT (basesink, "reset rc_time to time %" GST_TIME_FORMAT,
        GST_TIME_ARGS (stime));
    priv->rc_time = stime;
    priv->rc_accumulated = 0;
  } else {
    GST_DEBUG_OBJECT (basesink, "rate control next %" GST_TIME_FORMAT,
        GST_TIME_ARGS (priv->rc_next));
    stime = priv->rc_next;
  }

  /* preroll done, we can sync since we are in PLAYING now. */
  GST_DEBUG_OBJECT (basesink, "possibly waiting for clock to reach %"
      GST_TIME_FORMAT ", adjusted %" GST_TIME_FORMAT,
      GST_TIME_ARGS (rstart), GST_TIME_ARGS (stime));

  /* This function will return immediately if start == -1, no clock
   * or sync is disabled with GST_CLOCK_BADTIME. */
  status = gst_base_sink_wait_clock (basesink, stime, &jitter);

  GST_DEBUG_OBJECT (basesink, "clock returned %d, jitter %c%" GST_TIME_FORMAT,
      status, (jitter < 0 ? '-' : ' '), GST_TIME_ARGS (ABS (jitter)));

  /* invalid time, no clock or sync disabled, just render */
  if (status == GST_CLOCK_BADTIME)
    goto done;

  /* waiting could have been interrupted and we can be flushing now */
  if (G_UNLIKELY (basesink->flushing))
    goto flushing;

  /* check for unlocked by a state change, we are not flushing so
   * we can try to preroll on the current buffer. */
  if (G_UNLIKELY (status == GST_CLOCK_UNSCHEDULED)) {
    GST_DEBUG_OBJECT (basesink, "unscheduled, waiting some more");
    priv->call_preroll = TRUE;
    goto again;
  }

  /* successful syncing done, record observation */
  priv->current_jitter = jitter;

  /* check if the object should be dropped */
  *late = gst_base_sink_is_too_late (basesink, obj, rstart, rstop,
      status, jitter, TRUE);

done:
  return GST_FLOW_OK;

  /* ERRORS */
step_skipped:
  {
    GST_DEBUG_OBJECT (basesink, "skipped stepped object %p", obj);
    *late = TRUE;
    return GST_FLOW_OK;
  }
not_syncable:
  {
    GST_DEBUG_OBJECT (basesink, "non syncable object %p", obj);
    return GST_FLOW_OK;
  }
qos_dropped:
  {
    GST_DEBUG_OBJECT (basesink, "dropped because of QoS %p", obj);
    *late = TRUE;
    return GST_FLOW_OK;
  }
flushing:
  {
    GST_DEBUG_OBJECT (basesink, "we are flushing");
    return GST_FLOW_FLUSHING;
  }
preroll_failed:
  {
    GST_DEBUG_OBJECT (basesink, "preroll failed");
    *step_end = FALSE;
    return ret;
  }
}

static gboolean
gst_base_sink_send_qos (GstBaseSink * basesink, GstQOSType type,
    gdouble proportion, GstClockTime time, GstClockTimeDiff diff)
{
  GstEvent *event;
  gboolean res;

  /* generate Quality-of-Service event */
  GST_CAT_DEBUG_OBJECT (GST_CAT_QOS, basesink,
      "qos: type %d, proportion: %lf, diff %" G_GINT64_FORMAT ", timestamp %"
      GST_TIME_FORMAT, type, proportion, diff, GST_TIME_ARGS (time));

  event = gst_event_new_qos (type, proportion, diff, time);

  /* send upstream */
  res = gst_pad_push_event (basesink->sinkpad, event);

  return res;
}

static void
gst_base_sink_perform_qos (GstBaseSink * sink, gboolean dropped)
{
  GstBaseSinkPrivate *priv;
  GstClockTime start, stop;
  GstClockTimeDiff jitter;
  GstClockTime pt, entered, left;
  GstClockTime duration;
  gdouble rate;

  priv = sink->priv;

  start = priv->current_rstart;

  if (priv->current_step.valid)
    return;

  /* if Quality-of-Service disabled, do nothing */
  if (!g_atomic_int_get (&priv->qos_enabled) ||
      !GST_CLOCK_TIME_IS_VALID (start))
    return;

  stop = priv->current_rstop;
  jitter = priv->current_jitter;

  if (jitter < 0) {
    /* this is the time the buffer entered the sink */
    if (start < -jitter)
      entered = 0;
    else
      entered = start + jitter;
    left = start;
  } else {
    /* this is the time the buffer entered the sink */
    entered = start + jitter;
    /* this is the time the buffer left the sink */
    left = start + jitter;
  }

  /* calculate duration of the buffer */
  if (GST_CLOCK_TIME_IS_VALID (stop) && stop != start)
    duration = stop - start;
  else
    duration = priv->avg_in_diff;

  /* if we have the time when the last buffer left us, calculate
   * processing time */
  if (GST_CLOCK_TIME_IS_VALID (priv->last_left)) {
    if (entered > priv->last_left) {
      pt = entered - priv->last_left;
    } else {
      pt = 0;
    }
  } else {
    pt = priv->avg_pt;
  }

  GST_CAT_DEBUG_OBJECT (GST_CAT_QOS, sink, "start: %" GST_TIME_FORMAT
      ", stop %" GST_TIME_FORMAT ", entered %" GST_TIME_FORMAT ", left %"
      GST_TIME_FORMAT ", pt: %" GST_TIME_FORMAT ", duration %" GST_TIME_FORMAT
      ",jitter %" G_GINT64_FORMAT, GST_TIME_ARGS (start), GST_TIME_ARGS (stop),
      GST_TIME_ARGS (entered), GST_TIME_ARGS (left), GST_TIME_ARGS (pt),
      GST_TIME_ARGS (duration), jitter);

  GST_CAT_DEBUG_OBJECT (GST_CAT_QOS, sink, "avg_duration: %" GST_TIME_FORMAT
      ", avg_pt: %" GST_TIME_FORMAT ", avg_rate: %g",
      GST_TIME_ARGS (priv->avg_duration), GST_TIME_ARGS (priv->avg_pt),
      priv->avg_rate);

  /* collect running averages. for first observations, we copy the
   * values */
  if (!GST_CLOCK_TIME_IS_VALID (priv->avg_duration))
    priv->avg_duration = duration;
  else
    priv->avg_duration = UPDATE_RUNNING_AVG (priv->avg_duration, duration);

  if (!GST_CLOCK_TIME_IS_VALID (priv->avg_pt))
    priv->avg_pt = pt;
  else
    priv->avg_pt = UPDATE_RUNNING_AVG (priv->avg_pt, pt);

  if (priv->avg_duration != 0)
    rate =
        gst_guint64_to_gdouble (priv->avg_pt) /
        gst_guint64_to_gdouble (priv->avg_duration);
  else
    rate = 1.0;

  if (GST_CLOCK_TIME_IS_VALID (priv->last_left)) {
    if (dropped || priv->avg_rate < 0.0) {
      priv->avg_rate = rate;
    } else {
      if (rate > 1.0)
        priv->avg_rate = UPDATE_RUNNING_AVG_N (priv->avg_rate, rate);
      else
        priv->avg_rate = UPDATE_RUNNING_AVG_P (priv->avg_rate, rate);
    }
  }

  GST_CAT_DEBUG_OBJECT (GST_CAT_QOS, sink,
      "updated: avg_duration: %" GST_TIME_FORMAT ", avg_pt: %" GST_TIME_FORMAT
      ", avg_rate: %g", GST_TIME_ARGS (priv->avg_duration),
      GST_TIME_ARGS (priv->avg_pt), priv->avg_rate);


  if (priv->avg_rate >= 0.0) {
    GstQOSType type;
    GstClockTimeDiff diff;

    /* if we have a valid rate, start sending QoS messages */
    if (priv->current_jitter < 0) {
      /* make sure we never go below 0 when adding the jitter to the
       * timestamp. */
      if (priv->current_rstart < -priv->current_jitter)
        priv->current_jitter = -priv->current_rstart;
    }

    if (priv->throttle_time > 0) {
      diff = priv->throttle_time;
      type = GST_QOS_TYPE_THROTTLE;
    } else {
      diff = priv->current_jitter;
      if (diff <= 0)
        type = GST_QOS_TYPE_OVERFLOW;
      else
        type = GST_QOS_TYPE_UNDERFLOW;
    }

    gst_base_sink_send_qos (sink, type, priv->avg_rate, priv->current_rstart,
        diff);
  }

  /* record when this buffer will leave us */
  priv->last_left = left;
}

/* reset all qos measuring */
static void
gst_base_sink_reset_qos (GstBaseSink * sink)
{
  GstBaseSinkPrivate *priv;

  priv = sink->priv;

  priv->last_render_time = GST_CLOCK_TIME_NONE;
  priv->prev_rstart = GST_CLOCK_TIME_NONE;
  priv->earliest_in_time = GST_CLOCK_TIME_NONE;
  priv->last_left = GST_CLOCK_TIME_NONE;
  priv->avg_duration = GST_CLOCK_TIME_NONE;
  priv->avg_pt = GST_CLOCK_TIME_NONE;
  priv->avg_rate = -1.0;
  priv->avg_render = GST_CLOCK_TIME_NONE;
  priv->avg_in_diff = GST_CLOCK_TIME_NONE;
  priv->rendered = 0;
  priv->dropped = 0;

}

/* Checks if the object was scheduled too late.
 *
 * rstart/rstop contain the running_time start and stop values
 * of the object.
 *
 * status and jitter contain the return values from the clock wait.
 *
 * returns %TRUE if the buffer was too late.
 */
static gboolean
gst_base_sink_is_too_late (GstBaseSink * basesink, GstMiniObject * obj,
    GstClockTime rstart, GstClockTime rstop,
    GstClockReturn status, GstClockTimeDiff jitter, gboolean render)
{
  gboolean late;
  guint64 max_lateness;
  GstBaseSinkPrivate *priv;

  priv = basesink->priv;

  late = FALSE;

  /* only for objects that were too late */
  if (G_LIKELY (status != GST_CLOCK_EARLY))
    goto in_time;

  max_lateness = basesink->max_lateness;

  /* check if frame dropping is enabled */
  if (max_lateness == -1)
    goto no_drop;

  /* only check for buffers */
  if (G_UNLIKELY (!GST_IS_BUFFER (obj)))
    goto not_buffer;

  /* can't do check if we don't have a timestamp */
  if (G_UNLIKELY (!GST_CLOCK_TIME_IS_VALID (rstart)))
    goto no_timestamp;

  /* we can add a valid stop time */
  if (GST_CLOCK_TIME_IS_VALID (rstop))
    max_lateness += rstop;
  else {
    max_lateness += rstart;
    /* no stop time, use avg frame diff */
    if (priv->avg_in_diff != -1)
      max_lateness += priv->avg_in_diff;
  }

  /* if the jitter bigger than duration and lateness we are too late */
  if ((late = rstart + jitter > max_lateness)) {
    GST_CAT_DEBUG_OBJECT (GST_CAT_PERFORMANCE, basesink,
        "buffer is too late %" GST_TIME_FORMAT
        " > %" GST_TIME_FORMAT, GST_TIME_ARGS (rstart + jitter),
        GST_TIME_ARGS (max_lateness));
    /* !!emergency!!, if we did not receive anything valid for more than a
     * second, render it anyway so the user sees something */
    if (GST_CLOCK_TIME_IS_VALID (priv->last_render_time) &&
        rstart - priv->last_render_time > GST_SECOND) {
      late = FALSE;
      GST_ELEMENT_WARNING (basesink, CORE, CLOCK,
          (_("A lot of buffers are being dropped.")),
          ("There may be a timestamping problem, or this computer is too slow."));
      GST_CAT_DEBUG_OBJECT (GST_CAT_PERFORMANCE, basesink,
          "**emergency** last buffer at %" GST_TIME_FORMAT " > GST_SECOND",
          GST_TIME_ARGS (priv->last_render_time));
    }
  }

done:
  if (render && (!late || !GST_CLOCK_TIME_IS_VALID (priv->last_render_time))) {
    priv->last_render_time = rstart;
    /* the next allowed input timestamp */
    if (priv->throttle_time > 0)
      priv->earliest_in_time = rstart + priv->throttle_time;
  }
  return late;

  /* all is fine */
in_time:
  {
    GST_DEBUG_OBJECT (basesink, "object was scheduled in time");
    goto done;
  }
no_drop:
  {
    GST_DEBUG_OBJECT (basesink, "frame dropping disabled");
    goto done;
  }
not_buffer:
  {
    GST_DEBUG_OBJECT (basesink, "object is not a buffer");
    return FALSE;
  }
no_timestamp:
  {
    GST_DEBUG_OBJECT (basesink, "buffer has no timestamp");
    return FALSE;
  }
}

/* called before and after calling the render vmethod. It keeps track of how
 * much time was spent in the render method and is used to check if we are
 * flooded */
static void
gst_base_sink_do_render_stats (GstBaseSink * basesink, gboolean start)
{
  GstBaseSinkPrivate *priv;

  priv = basesink->priv;

  if (start) {
    priv->start = gst_util_get_timestamp ();
  } else {
    GstClockTime elapsed;

    priv->stop = gst_util_get_timestamp ();

    elapsed = GST_CLOCK_DIFF (priv->start, priv->stop);

    if (!GST_CLOCK_TIME_IS_VALID (priv->avg_render))
      priv->avg_render = elapsed;
    else
      priv->avg_render = UPDATE_RUNNING_AVG (priv->avg_render, elapsed);

    GST_CAT_DEBUG_OBJECT (GST_CAT_QOS, basesink,
        "avg_render: %" GST_TIME_FORMAT, GST_TIME_ARGS (priv->avg_render));
  }
}

static void
gst_base_sink_update_start_time (GstBaseSink * basesink)
{
  GstClock *clock;

  GST_OBJECT_LOCK (basesink);
  if ((clock = GST_ELEMENT_CLOCK (basesink))) {
    GstClockTime now;

    gst_object_ref (clock);
    GST_OBJECT_UNLOCK (basesink);

    /* calculate the time when we stopped */
    now = gst_clock_get_time (clock);
    gst_object_unref (clock);

    GST_OBJECT_LOCK (basesink);
    /* store the current running time */
    if (GST_ELEMENT_START_TIME (basesink) != GST_CLOCK_TIME_NONE) {
      if (now != GST_CLOCK_TIME_NONE)
        GST_ELEMENT_START_TIME (basesink) =
            now - GST_ELEMENT_CAST (basesink)->base_time;
      else
        GST_WARNING_OBJECT (basesink,
            "Clock %s returned invalid time, can't calculate "
            "running_time when going to the PAUSED state",
            GST_OBJECT_NAME (clock));
    }
    GST_DEBUG_OBJECT (basesink,
        "start_time=%" GST_TIME_FORMAT ", now=%" GST_TIME_FORMAT
        ", base_time %" GST_TIME_FORMAT,
        GST_TIME_ARGS (GST_ELEMENT_START_TIME (basesink)),
        GST_TIME_ARGS (now),
        GST_TIME_ARGS (GST_ELEMENT_CAST (basesink)->base_time));
  }
  GST_OBJECT_UNLOCK (basesink);
}

static void
gst_base_sink_flush_start (GstBaseSink * basesink, GstPad * pad)
{
  /* make sure we are not blocked on the clock also clear any pending
   * eos state. */
  gst_base_sink_set_flushing (basesink, pad, TRUE);

  /* we grab the stream lock but that is not needed since setting the
   * sink to flushing would make sure no state commit is being done
   * anymore */
  GST_PAD_STREAM_LOCK (pad);
  gst_base_sink_reset_qos (basesink);
  /* and we need to commit our state again on the next
   * prerolled buffer */
  basesink->playing_async = TRUE;
  if (basesink->priv->async_enabled) {
    gst_base_sink_update_start_time (basesink);
    gst_element_lost_state (GST_ELEMENT_CAST (basesink));
  } else {
    /* start time reset in above case as well;
     * arranges for a.o. proper position reporting when flushing in PAUSED */
    gst_element_set_start_time (GST_ELEMENT_CAST (basesink), 0);
    basesink->priv->have_latency = TRUE;
  }
  gst_base_sink_set_last_buffer (basesink, NULL);
  GST_PAD_STREAM_UNLOCK (pad);
}

static void
gst_base_sink_flush_stop (GstBaseSink * basesink, GstPad * pad,
    gboolean reset_time)
{
  /* unset flushing so we can accept new data, this also flushes out any EOS
   * event. */
  gst_base_sink_set_flushing (basesink, pad, FALSE);

  /* for position reporting */
  GST_OBJECT_LOCK (basesink);
  basesink->priv->current_sstart = GST_CLOCK_TIME_NONE;
  basesink->priv->current_sstop = GST_CLOCK_TIME_NONE;
  basesink->priv->eos_rtime = GST_CLOCK_TIME_NONE;
  basesink->priv->call_preroll = TRUE;
  basesink->priv->current_step.valid = FALSE;
  basesink->priv->pending_step.valid = FALSE;
  if (basesink->pad_mode == GST_PAD_MODE_PUSH) {
    /* we need new segment info after the flush. */
    basesink->have_newsegment = FALSE;
    if (reset_time) {
      gst_segment_init (&basesink->segment, GST_FORMAT_UNDEFINED);
      GST_ELEMENT_START_TIME (basesink) = 0;
    }
  }
  GST_OBJECT_UNLOCK (basesink);

  if (reset_time) {
    GST_DEBUG_OBJECT (basesink, "posting reset-time message");
    gst_element_post_message (GST_ELEMENT_CAST (basesink),
        gst_message_new_reset_time (GST_OBJECT_CAST (basesink), 0));
  }
}

static GstFlowReturn
gst_base_sink_default_wait_event (GstBaseSink * basesink, GstEvent * event)
{
  GstFlowReturn ret;
  gboolean late, step_end = FALSE;

  ret = gst_base_sink_do_sync (basesink, GST_MINI_OBJECT_CAST (event),
      &late, &step_end);

  return ret;
}

static GstFlowReturn
gst_base_sink_wait_event (GstBaseSink * basesink, GstEvent * event)
{
  GstFlowReturn ret;
  GstBaseSinkClass *bclass;

  bclass = GST_BASE_SINK_GET_CLASS (basesink);

  if (G_LIKELY (bclass->wait_event))
    ret = bclass->wait_event (basesink, event);
  else
    ret = GST_FLOW_NOT_SUPPORTED;

  return ret;
}

static gboolean
gst_base_sink_default_event (GstBaseSink * basesink, GstEvent * event)
{
  gboolean result = TRUE;
  GstBaseSinkClass *bclass;

  bclass = GST_BASE_SINK_GET_CLASS (basesink);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_FLUSH_START:
    {
      GST_DEBUG_OBJECT (basesink, "flush-start %p", event);
      gst_base_sink_flush_start (basesink, basesink->sinkpad);
      break;
    }
    case GST_EVENT_FLUSH_STOP:
    {
      gboolean reset_time;

      gst_event_parse_flush_stop (event, &reset_time);
      GST_DEBUG_OBJECT (basesink, "flush-stop %p, reset_time: %d", event,
          reset_time);
      gst_base_sink_flush_stop (basesink, basesink->sinkpad, reset_time);
      break;
    }
    case GST_EVENT_EOS:
    {
      GstMessage *message;
      guint32 seqnum;

      /* we set the received EOS flag here so that we can use it when testing if
       * we are prerolled and to refuse more buffers. */
      basesink->priv->received_eos = TRUE;

      /* wait for EOS */
      if (G_UNLIKELY (gst_base_sink_wait_event (basesink,
                  event) != GST_FLOW_OK)) {
        result = FALSE;
        goto done;
      }

      /* the EOS event is completely handled so we mark
       * ourselves as being in the EOS state. eos is also
       * protected by the object lock so we can read it when
       * answering the POSITION query. */
      GST_OBJECT_LOCK (basesink);
      basesink->eos = TRUE;
      GST_OBJECT_UNLOCK (basesink);

      /* ok, now we can post the message */
      GST_DEBUG_OBJECT (basesink, "Now posting EOS");

      seqnum = basesink->priv->seqnum = gst_event_get_seqnum (event);
      GST_DEBUG_OBJECT (basesink, "Got seqnum #%" G_GUINT32_FORMAT, seqnum);

      message = gst_message_new_eos (GST_OBJECT_CAST (basesink));
      gst_message_set_seqnum (message, seqnum);
      gst_element_post_message (GST_ELEMENT_CAST (basesink), message);
      break;
    }
    case GST_EVENT_STREAM_START:
    {
      GstMessage *message;
      guint32 seqnum;
      guint group_id;

      seqnum = gst_event_get_seqnum (event);
      GST_DEBUG_OBJECT (basesink, "Now posting STREAM_START (seqnum:%d)",
          seqnum);
      message = gst_message_new_stream_start (GST_OBJECT_CAST (basesink));
      if (gst_event_parse_group_id (event, &group_id)) {
        gst_message_set_group_id (message, group_id);
      } else {
        GST_FIXME_OBJECT (basesink, "stream-start event without group-id. "
            "Consider implementing group-id handling in the upstream "
            "elements");
      }
      gst_message_set_seqnum (message, seqnum);
      gst_element_post_message (GST_ELEMENT_CAST (basesink), message);
      break;
    }
    case GST_EVENT_CAPS:
    {
      GstCaps *caps;

      GST_DEBUG_OBJECT (basesink, "caps %p", event);

      gst_event_parse_caps (event, &caps);
      if (bclass->set_caps)
        result = bclass->set_caps (basesink, caps);

      if (result) {
        GST_OBJECT_LOCK (basesink);
        gst_caps_replace (&basesink->priv->caps, caps);
        GST_OBJECT_UNLOCK (basesink);
      }
      break;
    }
    case GST_EVENT_SEGMENT:
      /* configure the segment */
      /* The segment is protected with both the STREAM_LOCK and the OBJECT_LOCK.
       * We protect with the OBJECT_LOCK so that we can use the values to
       * safely answer a POSITION query. */
      GST_OBJECT_LOCK (basesink);
      /* the newsegment event is needed to bring the buffer timestamps to the
       * stream time and to drop samples outside of the playback segment. */
      gst_event_copy_segment (event, &basesink->segment);
      GST_DEBUG_OBJECT (basesink, "configured segment %" GST_SEGMENT_FORMAT,
          &basesink->segment);
      basesink->have_newsegment = TRUE;
      gst_base_sink_reset_qos (basesink);
      GST_OBJECT_UNLOCK (basesink);
      break;
    case GST_EVENT_GAP:
    {
      if (G_UNLIKELY (gst_base_sink_wait_event (basesink,
                  event) != GST_FLOW_OK))
        result = FALSE;
      break;
    }
    case GST_EVENT_TAG:
    {
      GstTagList *taglist;

      gst_event_parse_tag (event, &taglist);

      gst_element_post_message (GST_ELEMENT_CAST (basesink),
          gst_message_new_tag (GST_OBJECT_CAST (basesink),
              gst_tag_list_copy (taglist)));
      break;
    }
    case GST_EVENT_TOC:
    {
      GstToc *toc;
      gboolean updated;

      gst_event_parse_toc (event, &toc, &updated);

      gst_element_post_message (GST_ELEMENT_CAST (basesink),
          gst_message_new_toc (GST_OBJECT_CAST (basesink), toc, updated));

      gst_toc_unref (toc);
      break;
    }
    case GST_EVENT_SINK_MESSAGE:
    {
      GstMessage *msg = NULL;

      gst_event_parse_sink_message (event, &msg);
      if (msg)
        gst_element_post_message (GST_ELEMENT_CAST (basesink), msg);
      break;
    }
    default:
      break;
  }
done:
  gst_event_unref (event);

  return result;
}

static gboolean
gst_base_sink_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  GstBaseSink *basesink;
  gboolean result = TRUE;
  GstBaseSinkClass *bclass;

  basesink = GST_BASE_SINK_CAST (parent);
  bclass = GST_BASE_SINK_GET_CLASS (basesink);

  GST_DEBUG_OBJECT (basesink, "received event %p %" GST_PTR_FORMAT, event,
      event);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_FLUSH_STOP:
      /* special case for this serialized event because we don't want to grab
       * the PREROLL lock or check if we were flushing */
      if (bclass->event)
        result = bclass->event (basesink, event);
      break;
    default:
      if (GST_EVENT_IS_SERIALIZED (event)) {
        GST_BASE_SINK_PREROLL_LOCK (basesink);
        if (G_UNLIKELY (basesink->flushing))
          goto flushing;

        if (G_UNLIKELY (basesink->priv->received_eos))
          goto after_eos;

        if (bclass->event)
          result = bclass->event (basesink, event);

        GST_BASE_SINK_PREROLL_UNLOCK (basesink);
      } else {
        if (bclass->event)
          result = bclass->event (basesink, event);
      }
      break;
  }
done:
  return result;

  /* ERRORS */
flushing:
  {
    GST_DEBUG_OBJECT (basesink, "we are flushing");
    GST_BASE_SINK_PREROLL_UNLOCK (basesink);
    gst_event_unref (event);
    result = FALSE;
    goto done;
  }

after_eos:
  {
    GST_DEBUG_OBJECT (basesink, "Event received after EOS, dropping");
    GST_BASE_SINK_PREROLL_UNLOCK (basesink);
    gst_event_unref (event);
    result = FALSE;
    goto done;
  }
}

/* default implementation to calculate the start and end
 * timestamps on a buffer, subclasses can override
 */
static void
gst_base_sink_default_get_times (GstBaseSink * basesink, GstBuffer * buffer,
    GstClockTime * start, GstClockTime * end)
{
  GstClockTime timestamp, duration;

  /* first sync on DTS, else use PTS */
  timestamp = GST_BUFFER_DTS (buffer);
  if (!GST_CLOCK_TIME_IS_VALID (timestamp))
    timestamp = GST_BUFFER_PTS (buffer);

  if (GST_CLOCK_TIME_IS_VALID (timestamp)) {
    /* get duration to calculate end time */
    duration = GST_BUFFER_DURATION (buffer);
    if (GST_CLOCK_TIME_IS_VALID (duration)) {
      *end = timestamp + duration;
    }
    *start = timestamp;
  }
}

/* must be called with PREROLL_LOCK */
static gboolean
gst_base_sink_needs_preroll (GstBaseSink * basesink)
{
  gboolean is_prerolled, res;

  /* we have 2 cases where the PREROLL_LOCK is released:
   *  1) we are blocking in the PREROLL_LOCK and thus are prerolled.
   *  2) we are syncing on the clock
   */
  is_prerolled = basesink->have_preroll || basesink->priv->received_eos;
  res = !is_prerolled;

  GST_DEBUG_OBJECT (basesink, "have_preroll: %d, EOS: %d => needs preroll: %d",
      basesink->have_preroll, basesink->priv->received_eos, res);

  return res;
}

static gboolean
count_list_bytes (GstBuffer ** buffer, guint idx, GstBaseSinkPrivate * priv)
{
  priv->rc_accumulated += gst_buffer_get_size (*buffer);
  return TRUE;
}

/* with STREAM_LOCK, PREROLL_LOCK
 *
 * Takes a buffer and compare the timestamps with the last segment.
 * If the buffer falls outside of the segment boundaries, drop it.
 * Else send the buffer for preroll and rendering.
 *
 * This function takes ownership of the buffer.
 */
static GstFlowReturn
gst_base_sink_chain_unlocked (GstBaseSink * basesink, GstPad * pad,
    gpointer obj, gboolean is_list)
{
  GstBaseSinkClass *bclass;
  GstBaseSinkPrivate *priv = basesink->priv;
  GstFlowReturn ret = GST_FLOW_OK;
  GstClockTime start = GST_CLOCK_TIME_NONE, end = GST_CLOCK_TIME_NONE;
  GstSegment *segment;
  GstBuffer *sync_buf;
  gint do_qos;
  gboolean late, step_end, prepared = FALSE;

  if (G_UNLIKELY (basesink->flushing))
    goto flushing;

  if (G_UNLIKELY (priv->received_eos))
    goto was_eos;

  if (is_list) {
    sync_buf = gst_buffer_list_get (GST_BUFFER_LIST_CAST (obj), 0);
    g_assert (NULL != sync_buf);
  } else {
    sync_buf = GST_BUFFER_CAST (obj);
  }

  /* for code clarity */
  segment = &basesink->segment;

  if (G_UNLIKELY (!basesink->have_newsegment)) {
    gboolean sync;

    sync = gst_base_sink_get_sync (basesink);
    if (sync) {
      GST_ELEMENT_WARNING (basesink, STREAM, FAILED,
          (_("Internal data flow problem.")),
          ("Received buffer without a new-segment. Assuming timestamps start from 0."));
    }

    /* this means this sink will assume timestamps start from 0 */
    GST_OBJECT_LOCK (basesink);
    segment->start = 0;
    segment->stop = -1;
    basesink->segment.start = 0;
    basesink->segment.stop = -1;
    basesink->have_newsegment = TRUE;
    GST_OBJECT_UNLOCK (basesink);
  }

  bclass = GST_BASE_SINK_GET_CLASS (basesink);

  /* check if the buffer needs to be dropped, we first ask the subclass for the
   * start and end */
  if (bclass->get_times)
    bclass->get_times (basesink, sync_buf, &start, &end);

  if (!GST_CLOCK_TIME_IS_VALID (start)) {
    /* if the subclass does not want sync, we use our own values so that we at
     * least clip the buffer to the segment */
    gst_base_sink_default_get_times (basesink, sync_buf, &start, &end);
  }

  GST_DEBUG_OBJECT (basesink, "got times start: %" GST_TIME_FORMAT
      ", end: %" GST_TIME_FORMAT, GST_TIME_ARGS (start), GST_TIME_ARGS (end));

  /* a dropped buffer does not participate in anything */
  if (GST_CLOCK_TIME_IS_VALID (start) && (segment->format == GST_FORMAT_TIME)) {
    if (G_UNLIKELY (!gst_segment_clip (segment,
                GST_FORMAT_TIME, start, end, NULL, NULL)))
      goto out_of_segment;
  }

  if (bclass->prepare || bclass->prepare_list) {
    gboolean do_sync = TRUE, stepped = FALSE, syncable = TRUE;
    GstClockTime sstart, sstop, rstart, rstop, rnext;
    GstStepInfo *current;

    late = FALSE;
    step_end = FALSE;

    current = &priv->current_step;
    syncable =
        gst_base_sink_get_sync_times (basesink, obj, &sstart, &sstop, &rstart,
        &rstop, &rnext, &do_sync, &stepped, current, &step_end);

    if (G_UNLIKELY (stepped))
      goto dropped;

    if (syncable && do_sync)
      late =
          gst_base_sink_is_too_late (basesink, obj, rstart, rstop,
          GST_CLOCK_EARLY, 0, FALSE);

    if (G_UNLIKELY (late))
      goto dropped;

    if (!is_list) {
      if (bclass->prepare) {
        ret = bclass->prepare (basesink, GST_BUFFER_CAST (obj));
        if (G_UNLIKELY (ret != GST_FLOW_OK))
          goto prepare_failed;
      }
    } else {
      if (bclass->prepare_list) {
        ret = bclass->prepare_list (basesink, GST_BUFFER_LIST_CAST (obj));
        if (G_UNLIKELY (ret != GST_FLOW_OK))
          goto prepare_failed;
      }
    }

    prepared = TRUE;
  }

again:
  late = FALSE;
  step_end = FALSE;

  /* synchronize this object, non syncable objects return OK
   * immediately. */
  ret = gst_base_sink_do_sync (basesink, GST_MINI_OBJECT_CAST (sync_buf),
      &late, &step_end);
  if (G_UNLIKELY (ret != GST_FLOW_OK))
    goto sync_failed;

  /* Don't skip if prepare() was called on time */
  late = late && !prepared;

  /* drop late buffers unconditionally, let's hope it's unlikely */
  if (G_UNLIKELY (late))
    goto dropped;

  if (priv->max_bitrate) {
    if (is_list) {
      gst_buffer_list_foreach (GST_BUFFER_LIST_CAST (obj),
          (GstBufferListFunc) count_list_bytes, priv);
    } else {
      priv->rc_accumulated += gst_buffer_get_size (GST_BUFFER_CAST (obj));
    }
    priv->rc_next = priv->rc_time + gst_util_uint64_scale (priv->rc_accumulated,
        8 * GST_SECOND, priv->max_bitrate);
  }

  /* read once, to get same value before and after */
  do_qos = g_atomic_int_get (&priv->qos_enabled);

  GST_DEBUG_OBJECT (basesink, "rendering object %p", obj);

  /* record rendering time for QoS and stats */
  if (do_qos)
    gst_base_sink_do_render_stats (basesink, TRUE);

  if (!is_list) {
    /* For buffer lists do not set last buffer for now. */
    gst_base_sink_set_last_buffer (basesink, GST_BUFFER_CAST (obj));

    if (bclass->render)
      ret = bclass->render (basesink, GST_BUFFER_CAST (obj));
  } else {
    if (bclass->render_list)
      ret = bclass->render_list (basesink, GST_BUFFER_LIST_CAST (obj));
  }

  if (do_qos)
    gst_base_sink_do_render_stats (basesink, FALSE);

  if (ret == GST_FLOW_STEP)
    goto again;

  if (G_UNLIKELY (basesink->flushing))
    goto flushing;

  priv->rendered++;

done:
  if (step_end) {
    /* the step ended, check if we need to activate a new step */
    GST_DEBUG_OBJECT (basesink, "step ended");
    stop_stepping (basesink, &basesink->segment, &priv->current_step,
        priv->current_rstart, priv->current_rstop, basesink->eos);
    goto again;
  }

  gst_base_sink_perform_qos (basesink, late);

  GST_DEBUG_OBJECT (basesink, "object unref after render %p", obj);
  gst_mini_object_unref (GST_MINI_OBJECT_CAST (obj));

  return ret;

  /* ERRORS */
flushing:
  {
    GST_DEBUG_OBJECT (basesink, "sink is flushing");
    gst_mini_object_unref (GST_MINI_OBJECT_CAST (obj));
    return GST_FLOW_FLUSHING;
  }
was_eos:
  {
    GST_DEBUG_OBJECT (basesink, "we are EOS, dropping object, return EOS");
    gst_mini_object_unref (GST_MINI_OBJECT_CAST (obj));
    return GST_FLOW_EOS;
  }
out_of_segment:
  {
    GST_DEBUG_OBJECT (basesink, "dropping buffer, out of clipping segment");
    gst_mini_object_unref (GST_MINI_OBJECT_CAST (obj));
    return GST_FLOW_OK;
  }
prepare_failed:
  {
    GST_DEBUG_OBJECT (basesink, "prepare buffer failed %s",
        gst_flow_get_name (ret));
    gst_mini_object_unref (GST_MINI_OBJECT_CAST (obj));
    return ret;
  }
sync_failed:
  {
    GST_DEBUG_OBJECT (basesink, "do_sync returned %s", gst_flow_get_name (ret));
    goto done;
  }
dropped:
  {
    priv->dropped++;
    GST_DEBUG_OBJECT (basesink, "buffer late, dropping");

    if (g_atomic_int_get (&priv->qos_enabled)) {
      GstMessage *qos_msg;
      GstClockTime timestamp, duration;

      timestamp = GST_BUFFER_TIMESTAMP (GST_BUFFER_CAST (sync_buf));
      duration = GST_BUFFER_DURATION (GST_BUFFER_CAST (sync_buf));

      GST_CAT_DEBUG_OBJECT (GST_CAT_QOS, basesink,
          "qos: dropped buffer rt %" GST_TIME_FORMAT ", st %" GST_TIME_FORMAT
          ", ts %" GST_TIME_FORMAT ", dur %" GST_TIME_FORMAT,
          GST_TIME_ARGS (priv->current_rstart),
          GST_TIME_ARGS (priv->current_sstart), GST_TIME_ARGS (timestamp),
          GST_TIME_ARGS (duration));
      GST_CAT_DEBUG_OBJECT (GST_CAT_QOS, basesink,
          "qos: rendered %" G_GUINT64_FORMAT ", dropped %" G_GUINT64_FORMAT,
          priv->rendered, priv->dropped);

      qos_msg =
          gst_message_new_qos (GST_OBJECT_CAST (basesink), basesink->sync,
          priv->current_rstart, priv->current_sstart, timestamp, duration);
      gst_message_set_qos_values (qos_msg, priv->current_jitter, priv->avg_rate,
          1000000);
      gst_message_set_qos_stats (qos_msg, GST_FORMAT_BUFFERS, priv->rendered,
          priv->dropped);
      gst_element_post_message (GST_ELEMENT_CAST (basesink), qos_msg);
    }
    goto done;
  }
}

/* with STREAM_LOCK
 */
static GstFlowReturn
gst_base_sink_chain_main (GstBaseSink * basesink, GstPad * pad, gpointer obj,
    gboolean is_list)
{
  GstFlowReturn result;

  if (G_UNLIKELY (basesink->pad_mode != GST_PAD_MODE_PUSH))
    goto wrong_mode;

  GST_BASE_SINK_PREROLL_LOCK (basesink);
  result = gst_base_sink_chain_unlocked (basesink, pad, obj, is_list);
  GST_BASE_SINK_PREROLL_UNLOCK (basesink);

done:
  return result;

  /* ERRORS */
wrong_mode:
  {
    GST_OBJECT_LOCK (pad);
    GST_WARNING_OBJECT (basesink,
        "Push on pad %s:%s, but it was not activated in push mode",
        GST_DEBUG_PAD_NAME (pad));
    GST_OBJECT_UNLOCK (pad);
    gst_mini_object_unref (GST_MINI_OBJECT_CAST (obj));
    /* we don't post an error message this will signal to the peer
     * pushing that EOS is reached. */
    result = GST_FLOW_EOS;
    goto done;
  }
}

static GstFlowReturn
gst_base_sink_chain (GstPad * pad, GstObject * parent, GstBuffer * buf)
{
  GstBaseSink *basesink;

  basesink = GST_BASE_SINK (parent);

  return gst_base_sink_chain_main (basesink, pad, buf, FALSE);
}

static GstFlowReturn
gst_base_sink_chain_list (GstPad * pad, GstObject * parent,
    GstBufferList * list)
{
  GstBaseSink *basesink;
  GstBaseSinkClass *bclass;
  GstFlowReturn result;

  basesink = GST_BASE_SINK (parent);
  bclass = GST_BASE_SINK_GET_CLASS (basesink);

  if (G_LIKELY (bclass->render_list)) {
    result = gst_base_sink_chain_main (basesink, pad, list, TRUE);
  } else {
    guint i, len;
    GstBuffer *buffer;

    GST_LOG_OBJECT (pad, "chaining each buffer in list");

    len = gst_buffer_list_length (list);

    result = GST_FLOW_OK;
    for (i = 0; i < len; i++) {
      buffer = gst_buffer_list_get (list, i);
      result = gst_base_sink_chain_main (basesink, pad,
          gst_buffer_ref (buffer), FALSE);
      if (result != GST_FLOW_OK)
        break;
    }
    gst_buffer_list_unref (list);
  }
  return result;
}


static gboolean
gst_base_sink_default_do_seek (GstBaseSink * sink, GstSegment * segment)
{
  gboolean res = TRUE;

  /* update our offset if the start/stop position was updated */
  if (segment->format == GST_FORMAT_BYTES) {
    segment->time = segment->start;
  } else if (segment->start == 0) {
    /* seek to start, we can implement a default for this. */
    segment->time = 0;
  } else {
    res = FALSE;
    GST_INFO_OBJECT (sink, "Can't do a default seek");
  }

  return res;
}

#define SEEK_TYPE_IS_RELATIVE(t) (((t) != GST_SEEK_TYPE_NONE) && ((t) != GST_SEEK_TYPE_SET))

static gboolean
gst_base_sink_default_prepare_seek_segment (GstBaseSink * sink,
    GstEvent * event, GstSegment * segment)
{
  /* By default, we try one of 2 things:
   *   - For absolute seek positions, convert the requested position to our
   *     configured processing format and place it in the output segment \
   *   - For relative seek positions, convert our current (input) values to the
   *     seek format, adjust by the relative seek offset and then convert back to
   *     the processing format
   */
  GstSeekType start_type, stop_type;
  gint64 start, stop;
  GstSeekFlags flags;
  GstFormat seek_format;
  gdouble rate;
  gboolean update;
  gboolean res = TRUE;

  gst_event_parse_seek (event, &rate, &seek_format, &flags,
      &start_type, &start, &stop_type, &stop);

  if (seek_format == segment->format) {
    gst_segment_do_seek (segment, rate, seek_format, flags,
        start_type, start, stop_type, stop, &update);
    return TRUE;
  }

  if (start_type != GST_SEEK_TYPE_NONE) {
    /* FIXME: Handle seek_end by converting the input segment vals */
    res =
        gst_pad_query_convert (sink->sinkpad, seek_format, start,
        segment->format, &start);
    start_type = GST_SEEK_TYPE_SET;
  }

  if (res && stop_type != GST_SEEK_TYPE_NONE) {
    /* FIXME: Handle seek_end by converting the input segment vals */
    res =
        gst_pad_query_convert (sink->sinkpad, seek_format, stop,
        segment->format, &stop);
    stop_type = GST_SEEK_TYPE_SET;
  }

  /* And finally, configure our output segment in the desired format */
  gst_segment_do_seek (segment, rate, segment->format, flags, start_type, start,
      stop_type, stop, &update);

  if (!res)
    goto no_format;

  return res;

no_format:
  {
    GST_DEBUG_OBJECT (sink, "undefined format given, seek aborted.");
    return FALSE;
  }
}

/* perform a seek, only executed in pull mode */
static gboolean
gst_base_sink_perform_seek (GstBaseSink * sink, GstPad * pad, GstEvent * event)
{
  gboolean flush;
  gdouble rate;
  GstFormat seek_format, dest_format;
  GstSeekFlags flags;
  GstSeekType start_type, stop_type;
  gboolean seekseg_configured = FALSE;
  gint64 start, stop;
  gboolean update, res = TRUE;
  GstSegment seeksegment;

  dest_format = sink->segment.format;

  if (event) {
    GST_DEBUG_OBJECT (sink, "performing seek with event %p", event);
    gst_event_parse_seek (event, &rate, &seek_format, &flags,
        &start_type, &start, &stop_type, &stop);

    flush = flags & GST_SEEK_FLAG_FLUSH;
  } else {
    GST_DEBUG_OBJECT (sink, "performing seek without event");
    flush = FALSE;
  }

  if (flush) {
    GST_DEBUG_OBJECT (sink, "flushing upstream");
    gst_pad_push_event (pad, gst_event_new_flush_start ());
    gst_base_sink_flush_start (sink, pad);
  } else {
    GST_DEBUG_OBJECT (sink, "pausing pulling thread");
  }

  GST_PAD_STREAM_LOCK (pad);

  /* If we configured the seeksegment above, don't overwrite it now. Otherwise
   * copy the current segment info into the temp segment that we can actually
   * attempt the seek with. We only update the real segment if the seek succeeds. */
  if (!seekseg_configured) {
    memcpy (&seeksegment, &sink->segment, sizeof (GstSegment));

    /* now configure the final seek segment */
    if (event) {
      if (sink->segment.format != seek_format) {
        /* OK, here's where we give the subclass a chance to convert the relative
         * seek into an absolute one in the processing format. We set up any
         * absolute seek above, before taking the stream lock. */
        if (!gst_base_sink_default_prepare_seek_segment (sink, event,
                &seeksegment)) {
          GST_DEBUG_OBJECT (sink,
              "Preparing the seek failed after flushing. " "Aborting seek");
          res = FALSE;
        }
      } else {
        /* The seek format matches our processing format, no need to ask the
         * the subclass to configure the segment. */
        gst_segment_do_seek (&seeksegment, rate, seek_format, flags,
            start_type, start, stop_type, stop, &update);
      }
    }
    /* Else, no seek event passed, so we're just (re)starting the
       current segment. */
  }

  if (res) {
    GST_DEBUG_OBJECT (sink, "segment configured from %" G_GINT64_FORMAT
        " to %" G_GINT64_FORMAT ", position %" G_GINT64_FORMAT,
        seeksegment.start, seeksegment.stop, seeksegment.position);

    /* do the seek, segment.position contains the new position. */
    res = gst_base_sink_default_do_seek (sink, &seeksegment);
  }

  if (flush) {
    GST_DEBUG_OBJECT (sink, "stop flushing upstream");
    gst_pad_push_event (pad, gst_event_new_flush_stop (TRUE));
    gst_base_sink_flush_stop (sink, pad, TRUE);
  } else if (res && sink->running) {
    /* we are running the current segment and doing a non-flushing seek,
     * close the segment first based on the position. */
    GST_DEBUG_OBJECT (sink, "closing running segment %" G_GINT64_FORMAT
        " to %" G_GINT64_FORMAT, sink->segment.start, sink->segment.position);
  }

  /* The subclass must have converted the segment to the processing format
   * by now */
  if (res && seeksegment.format != dest_format) {
    GST_DEBUG_OBJECT (sink, "Subclass failed to prepare a seek segment "
        "in the correct format. Aborting seek.");
    res = FALSE;
  }

  GST_INFO_OBJECT (sink, "seeking done %d: %" GST_SEGMENT_FORMAT, res,
      &seeksegment);

  /* if successful seek, we update our real segment and push
   * out the new segment. */
  if (res) {
    gst_segment_copy_into (&seeksegment, &sink->segment);

    if (sink->segment.flags & GST_SEGMENT_FLAG_SEGMENT) {
      gst_element_post_message (GST_ELEMENT (sink),
          gst_message_new_segment_start (GST_OBJECT (sink),
              sink->segment.format, sink->segment.position));
    }
  }

  sink->priv->discont = TRUE;
  sink->running = TRUE;

  GST_PAD_STREAM_UNLOCK (pad);

  return res;
}

static void
set_step_info (GstBaseSink * sink, GstStepInfo * current, GstStepInfo * pending,
    guint seqnum, GstFormat format, guint64 amount, gdouble rate,
    gboolean flush, gboolean intermediate)
{
  GST_OBJECT_LOCK (sink);
  pending->seqnum = seqnum;
  pending->format = format;
  pending->amount = amount;
  pending->position = 0;
  pending->rate = rate;
  pending->flush = flush;
  pending->intermediate = intermediate;
  pending->valid = TRUE;
  /* flush invalidates the current stepping segment */
  if (flush)
    current->valid = FALSE;
  GST_OBJECT_UNLOCK (sink);
}

static gboolean
gst_base_sink_perform_step (GstBaseSink * sink, GstPad * pad, GstEvent * event)
{
  GstBaseSinkPrivate *priv;
  GstBaseSinkClass *bclass;
  gboolean flush, intermediate;
  gdouble rate;
  GstFormat format;
  guint64 amount;
  guint seqnum;
  GstStepInfo *pending, *current;
  GstMessage *message;

  bclass = GST_BASE_SINK_GET_CLASS (sink);
  priv = sink->priv;

  GST_DEBUG_OBJECT (sink, "performing step with event %p", event);

  gst_event_parse_step (event, &format, &amount, &rate, &flush, &intermediate);
  seqnum = gst_event_get_seqnum (event);

  pending = &priv->pending_step;
  current = &priv->current_step;

  /* post message first */
  message = gst_message_new_step_start (GST_OBJECT (sink), FALSE, format,
      amount, rate, flush, intermediate);
  gst_message_set_seqnum (message, seqnum);
  gst_element_post_message (GST_ELEMENT (sink), message);

  if (flush) {
    /* we need to call ::unlock before locking PREROLL_LOCK
     * since we lock it before going into ::render */
    if (bclass->unlock)
      bclass->unlock (sink);

    GST_BASE_SINK_PREROLL_LOCK (sink);
    /* now that we have the PREROLL lock, clear our unlock request */
    if (bclass->unlock_stop)
      bclass->unlock_stop (sink);

    /* update the stepinfo and make it valid */
    set_step_info (sink, current, pending, seqnum, format, amount, rate, flush,
        intermediate);

    if (sink->priv->async_enabled) {
      /* and we need to commit our state again on the next
       * prerolled buffer */
      sink->playing_async = TRUE;
      priv->pending_step.need_preroll = TRUE;
      sink->need_preroll = FALSE;
      gst_base_sink_update_start_time (sink);
      gst_element_lost_state (GST_ELEMENT_CAST (sink));
    } else {
      sink->priv->have_latency = TRUE;
      sink->need_preroll = FALSE;
    }
    priv->current_sstart = GST_CLOCK_TIME_NONE;
    priv->current_sstop = GST_CLOCK_TIME_NONE;
    priv->eos_rtime = GST_CLOCK_TIME_NONE;
    priv->call_preroll = TRUE;
    gst_base_sink_set_last_buffer (sink, NULL);
    gst_base_sink_reset_qos (sink);

    if (sink->clock_id) {
      gst_clock_id_unschedule (sink->clock_id);
    }

    if (sink->have_preroll) {
      GST_DEBUG_OBJECT (sink, "signal waiter");
      priv->step_unlock = TRUE;
      GST_BASE_SINK_PREROLL_SIGNAL (sink);
    }
    GST_BASE_SINK_PREROLL_UNLOCK (sink);
  } else {
    /* update the stepinfo and make it valid */
    set_step_info (sink, current, pending, seqnum, format, amount, rate, flush,
        intermediate);
  }

  return TRUE;
}

/* with STREAM_LOCK
 */
static void
gst_base_sink_loop (GstPad * pad)
{
  GstObject *parent;
  GstBaseSink *basesink;
  GstBuffer *buf = NULL;
  GstFlowReturn result;
  guint blocksize;
  guint64 offset;

  parent = GST_OBJECT_PARENT (pad);
  basesink = GST_BASE_SINK (parent);

  g_assert (basesink->pad_mode == GST_PAD_MODE_PULL);

  if ((blocksize = basesink->priv->blocksize) == 0)
    blocksize = -1;

  offset = basesink->segment.position;

  GST_DEBUG_OBJECT (basesink, "pulling %" G_GUINT64_FORMAT ", %u",
      offset, blocksize);

  result = gst_pad_pull_range (pad, offset, blocksize, &buf);
  if (G_UNLIKELY (result != GST_FLOW_OK))
    goto paused;

  if (G_UNLIKELY (buf == NULL))
    goto no_buffer;

  offset += gst_buffer_get_size (buf);

  basesink->segment.position = offset;

  GST_BASE_SINK_PREROLL_LOCK (basesink);
  result = gst_base_sink_chain_unlocked (basesink, pad, buf, FALSE);
  GST_BASE_SINK_PREROLL_UNLOCK (basesink);
  if (G_UNLIKELY (result != GST_FLOW_OK))
    goto paused;

  return;

  /* ERRORS */
paused:
  {
    GST_LOG_OBJECT (basesink, "pausing task, reason %s",
        gst_flow_get_name (result));
    gst_pad_pause_task (pad);
    if (result == GST_FLOW_EOS) {
      /* perform EOS logic */
      if (basesink->segment.flags & GST_SEGMENT_FLAG_SEGMENT) {
        gst_element_post_message (GST_ELEMENT_CAST (basesink),
            gst_message_new_segment_done (GST_OBJECT_CAST (basesink),
                basesink->segment.format, basesink->segment.position));
        gst_base_sink_event (pad, parent,
            gst_event_new_segment_done (basesink->segment.format,
                basesink->segment.position));
      } else {
        gst_base_sink_event (pad, parent, gst_event_new_eos ());
      }
    } else if (result == GST_FLOW_NOT_LINKED || result <= GST_FLOW_EOS) {
      /* for fatal errors we post an error message, post the error
       * first so the app knows about the error first. 
       * wrong-state is not a fatal error because it happens due to
       * flushing and posting an error message in that case is the
       * wrong thing to do, e.g. when basesrc is doing a flushing
       * seek. */
      GST_ELEMENT_ERROR (basesink, STREAM, FAILED,
          (_("Internal data stream error.")),
          ("stream stopped, reason %s", gst_flow_get_name (result)));
      gst_base_sink_event (pad, parent, gst_event_new_eos ());
    }
    return;
  }
no_buffer:
  {
    GST_LOG_OBJECT (basesink, "no buffer, pausing");
    GST_ELEMENT_ERROR (basesink, STREAM, FAILED,
        (_("Internal data flow error.")), ("element returned NULL buffer"));
    result = GST_FLOW_ERROR;
    goto paused;
  }
}

static gboolean
gst_base_sink_set_flushing (GstBaseSink * basesink, GstPad * pad,
    gboolean flushing)
{
  GstBaseSinkClass *bclass;

  bclass = GST_BASE_SINK_GET_CLASS (basesink);

  if (flushing) {
    /* unlock any subclasses, we need to do this before grabbing the
     * PREROLL_LOCK since we hold this lock before going into ::render. */
    if (bclass->unlock)
      bclass->unlock (basesink);
  }

  GST_BASE_SINK_PREROLL_LOCK (basesink);
  basesink->flushing = flushing;
  if (flushing) {
    /* step 1, now that we have the PREROLL lock, clear our unlock request */
    if (bclass->unlock_stop)
      bclass->unlock_stop (basesink);

    /* set need_preroll before we unblock the clock. If the clock is unblocked
     * before timing out, we can reuse the buffer for preroll. */
    basesink->need_preroll = TRUE;

    /* step 2, unblock clock sync (if any) or any other blocking thing */
    if (basesink->clock_id) {
      gst_clock_id_unschedule (basesink->clock_id);
    }

    /* flush out the data thread if it's locked in finish_preroll, this will
     * also flush out the EOS state */
    GST_DEBUG_OBJECT (basesink,
        "flushing out data thread, need preroll to TRUE");

    /* we can't have EOS anymore now */
    basesink->eos = FALSE;
    basesink->priv->received_eos = FALSE;
    basesink->have_preroll = FALSE;
    basesink->priv->step_unlock = FALSE;
    /* can't report latency anymore until we preroll again */
    if (basesink->priv->async_enabled) {
      GST_OBJECT_LOCK (basesink);
      basesink->priv->have_latency = FALSE;
      GST_OBJECT_UNLOCK (basesink);
    }
    /* and signal any waiters now */
    GST_BASE_SINK_PREROLL_SIGNAL (basesink);
  }
  GST_BASE_SINK_PREROLL_UNLOCK (basesink);

  return TRUE;
}

static gboolean
gst_base_sink_default_activate_pull (GstBaseSink * basesink, gboolean active)
{
  gboolean result;

  if (active) {
    /* start task */
    result = gst_pad_start_task (basesink->sinkpad,
        (GstTaskFunction) gst_base_sink_loop, basesink->sinkpad, NULL);
  } else {
    /* step 2, make sure streaming finishes */
    result = gst_pad_stop_task (basesink->sinkpad);
  }

  return result;
}

static gboolean
gst_base_sink_pad_activate (GstPad * pad, GstObject * parent)
{
  gboolean result = FALSE;
  GstBaseSink *basesink;
  GstQuery *query;
  gboolean pull_mode;

  basesink = GST_BASE_SINK (parent);

  GST_DEBUG_OBJECT (basesink, "Trying pull mode first");

  gst_base_sink_set_flushing (basesink, pad, FALSE);

  /* we need to have the pull mode enabled */
  if (!basesink->can_activate_pull) {
    GST_DEBUG_OBJECT (basesink, "pull mode disabled");
    goto fallback;
  }

  /* check if downstreams supports pull mode at all */
  query = gst_query_new_scheduling ();

  if (!gst_pad_peer_query (pad, query)) {
    gst_query_unref (query);
    GST_DEBUG_OBJECT (basesink, "peer query faild, no pull mode");
    goto fallback;
  }

  /* parse result of the query */
  pull_mode = gst_query_has_scheduling_mode (query, GST_PAD_MODE_PULL);
  gst_query_unref (query);

  if (!pull_mode) {
    GST_DEBUG_OBJECT (basesink, "pull mode not supported");
    goto fallback;
  }

  /* set the pad mode before starting the task so that it's in the
   * correct state for the new thread. also the sink set_caps and get_caps
   * function checks this */
  basesink->pad_mode = GST_PAD_MODE_PULL;

  /* we first try to negotiate a format so that when we try to activate
   * downstream, it knows about our format */
  if (!gst_base_sink_negotiate_pull (basesink)) {
    GST_DEBUG_OBJECT (basesink, "failed to negotiate in pull mode");
    goto fallback;
  }

  /* ok activate now */
  if (!gst_pad_activate_mode (pad, GST_PAD_MODE_PULL, TRUE)) {
    /* clear any pending caps */
    GST_OBJECT_LOCK (basesink);
    gst_caps_replace (&basesink->priv->caps, NULL);
    GST_OBJECT_UNLOCK (basesink);
    GST_DEBUG_OBJECT (basesink, "failed to activate in pull mode");
    goto fallback;
  }

  GST_DEBUG_OBJECT (basesink, "Success activating pull mode");
  result = TRUE;
  goto done;

  /* push mode fallback */
fallback:
  GST_DEBUG_OBJECT (basesink, "Falling back to push mode");
  if ((result = gst_pad_activate_mode (pad, GST_PAD_MODE_PUSH, TRUE))) {
    GST_DEBUG_OBJECT (basesink, "Success activating push mode");
  }

done:
  if (!result) {
    GST_WARNING_OBJECT (basesink, "Could not activate pad in either mode");
    gst_base_sink_set_flushing (basesink, pad, TRUE);
  }

  return result;
}

static gboolean
gst_base_sink_pad_activate_push (GstPad * pad, GstObject * parent,
    gboolean active)
{
  gboolean result;
  GstBaseSink *basesink;

  basesink = GST_BASE_SINK (parent);

  if (active) {
    if (!basesink->can_activate_push) {
      result = FALSE;
      basesink->pad_mode = GST_PAD_MODE_NONE;
    } else {
      result = TRUE;
      basesink->pad_mode = GST_PAD_MODE_PUSH;
    }
  } else {
    if (G_UNLIKELY (basesink->pad_mode != GST_PAD_MODE_PUSH)) {
      g_warning ("Internal GStreamer activation error!!!");
      result = FALSE;
    } else {
      gst_base_sink_set_flushing (basesink, pad, TRUE);
      result = TRUE;
      basesink->pad_mode = GST_PAD_MODE_NONE;
    }
  }

  return result;
}

static gboolean
gst_base_sink_negotiate_pull (GstBaseSink * basesink)
{
  GstCaps *caps;
  gboolean result;

  result = FALSE;

  /* this returns the intersection between our caps and the peer caps. If there
   * is no peer, it returns %NULL and we can't operate in pull mode so we can
   * fail the negotiation. */
  caps = gst_pad_get_allowed_caps (GST_BASE_SINK_PAD (basesink));
  if (caps == NULL || gst_caps_is_empty (caps))
    goto no_caps_possible;

  GST_DEBUG_OBJECT (basesink, "allowed caps: %" GST_PTR_FORMAT, caps);

  if (gst_caps_is_any (caps)) {
    GST_DEBUG_OBJECT (basesink, "caps were ANY after fixating, "
        "allowing pull()");
    /* neither side has template caps in this case, so they are prepared for
       pull() without setcaps() */
    result = TRUE;
  } else {
    /* try to fixate */
    caps = gst_base_sink_fixate (basesink, caps);
    GST_DEBUG_OBJECT (basesink, "fixated to: %" GST_PTR_FORMAT, caps);

    if (gst_caps_is_fixed (caps)) {
      if (!gst_pad_set_caps (GST_BASE_SINK_PAD (basesink), caps))
        goto could_not_set_caps;

      result = TRUE;
    }
  }

  gst_caps_unref (caps);

  return result;

no_caps_possible:
  {
    GST_INFO_OBJECT (basesink, "Pipeline could not agree on caps");
    GST_DEBUG_OBJECT (basesink, "get_allowed_caps() returned EMPTY");
    if (caps)
      gst_caps_unref (caps);
    return FALSE;
  }
could_not_set_caps:
  {
    GST_INFO_OBJECT (basesink, "Could not set caps: %" GST_PTR_FORMAT, caps);
    gst_caps_unref (caps);
    return FALSE;
  }
}

/* this won't get called until we implement an activate function */
static gboolean
gst_base_sink_pad_activate_pull (GstPad * pad, GstObject * parent,
    gboolean active)
{
  gboolean result = FALSE;
  GstBaseSink *basesink;
  GstBaseSinkClass *bclass;

  basesink = GST_BASE_SINK (parent);
  bclass = GST_BASE_SINK_GET_CLASS (basesink);

  if (active) {
    gint64 duration;

    /* we mark we have a newsegment here because pull based
     * mode works just fine without having a newsegment before the
     * first buffer */
    gst_segment_init (&basesink->segment, GST_FORMAT_BYTES);
    GST_OBJECT_LOCK (basesink);
    basesink->have_newsegment = TRUE;
    GST_OBJECT_UNLOCK (basesink);

    /* get the peer duration in bytes */
    result = gst_pad_peer_query_duration (pad, GST_FORMAT_BYTES, &duration);
    if (result) {
      GST_DEBUG_OBJECT (basesink,
          "setting duration in bytes to %" G_GINT64_FORMAT, duration);
      basesink->segment.duration = duration;
    } else {
      GST_DEBUG_OBJECT (basesink, "unknown duration");
    }

    if (bclass->activate_pull)
      result = bclass->activate_pull (basesink, TRUE);
    else
      result = FALSE;

    if (!result)
      goto activate_failed;

  } else {
    if (G_UNLIKELY (basesink->pad_mode != GST_PAD_MODE_PULL)) {
      g_warning ("Internal GStreamer activation error!!!");
      result = FALSE;
    } else {
      result = gst_base_sink_set_flushing (basesink, pad, TRUE);
      if (bclass->activate_pull)
        result &= bclass->activate_pull (basesink, FALSE);
      basesink->pad_mode = GST_PAD_MODE_NONE;
    }
  }

  return result;

  /* ERRORS */
activate_failed:
  {
    /* reset, as starting the thread failed */
    basesink->pad_mode = GST_PAD_MODE_NONE;

    GST_ERROR_OBJECT (basesink, "subclass failed to activate in pull mode");
    return FALSE;
  }
}

static gboolean
gst_base_sink_pad_activate_mode (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active)
{
  gboolean res;

  switch (mode) {
    case GST_PAD_MODE_PULL:
      res = gst_base_sink_pad_activate_pull (pad, parent, active);
      break;
    case GST_PAD_MODE_PUSH:
      res = gst_base_sink_pad_activate_push (pad, parent, active);
      break;
    default:
      GST_LOG_OBJECT (pad, "unknown activation mode %d", mode);
      res = FALSE;
      break;
  }
  return res;
}

/* send an event to our sinkpad peer. */
static gboolean
gst_base_sink_send_event (GstElement * element, GstEvent * event)
{
  GstPad *pad;
  GstBaseSink *basesink = GST_BASE_SINK (element);
  gboolean forward, result = TRUE;
  GstPadMode mode;

  GST_OBJECT_LOCK (element);
  /* get the pad and the scheduling mode */
  pad = gst_object_ref (basesink->sinkpad);
  mode = basesink->pad_mode;
  GST_OBJECT_UNLOCK (element);

  /* only push UPSTREAM events upstream */
  forward = GST_EVENT_IS_UPSTREAM (event);

  GST_DEBUG_OBJECT (basesink, "handling event %p %" GST_PTR_FORMAT, event,
      event);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_LATENCY:
    {
      GstClockTime latency;

      gst_event_parse_latency (event, &latency);

      /* store the latency. We use this to adjust the running_time before syncing
       * it to the clock. */
      GST_OBJECT_LOCK (element);
      basesink->priv->latency = latency;
      if (!basesink->priv->have_latency)
        forward = FALSE;
      GST_OBJECT_UNLOCK (element);
      GST_DEBUG_OBJECT (basesink, "latency set to %" GST_TIME_FORMAT,
          GST_TIME_ARGS (latency));

      /* We forward this event so that all elements know about the global pipeline
       * latency. This is interesting for an element when it wants to figure out
       * when a particular piece of data will be rendered. */
      break;
    }
    case GST_EVENT_SEEK:
      /* in pull mode we will execute the seek */
      if (mode == GST_PAD_MODE_PULL)
        result = gst_base_sink_perform_seek (basesink, pad, event);
      break;
    case GST_EVENT_STEP:
      result = gst_base_sink_perform_step (basesink, pad, event);
      forward = FALSE;
      break;
    default:
      break;
  }

  if (forward) {
    result = gst_pad_push_event (pad, event);
  } else {
    /* not forwarded, unref the event */
    gst_event_unref (event);
  }

  gst_object_unref (pad);

  GST_DEBUG_OBJECT (basesink, "handled event %p %" GST_PTR_FORMAT ": %d", event,
      event, result);

  return result;
}

static gboolean
gst_base_sink_get_position (GstBaseSink * basesink, GstFormat format,
    gint64 * cur, gboolean * upstream)
{
  GstClock *clock = NULL;
  gboolean res = FALSE;
  GstFormat oformat;
  GstSegment *segment;
  GstClockTime now, latency;
  GstClockTimeDiff base_time;
  gint64 time, base, duration;
  gdouble rate;
  gint64 last;
  gboolean last_seen, with_clock, in_paused;

  GST_OBJECT_LOCK (basesink);
  /* we can only get the segment when we are not NULL or READY */
  if (!basesink->have_newsegment)
    goto wrong_state;

  in_paused = FALSE;
  /* when not in PLAYING or when we're busy with a state change, we
   * cannot read from the clock so we report time based on the
   * last seen timestamp. */
  if (GST_STATE (basesink) != GST_STATE_PLAYING ||
      GST_STATE_PENDING (basesink) != GST_STATE_VOID_PENDING) {
    in_paused = TRUE;
  }

  segment = &basesink->segment;

  /* get the format in the segment */
  oformat = segment->format;

  /* report with last seen position when EOS */
  last_seen = basesink->eos;

  /* assume we will use the clock for getting the current position */
  with_clock = TRUE;
  if (basesink->sync == FALSE)
    with_clock = FALSE;

  /* and we need a clock */
  if (G_UNLIKELY ((clock = GST_ELEMENT_CLOCK (basesink)) == NULL))
    with_clock = FALSE;
  else
    gst_object_ref (clock);

  /* mainloop might be querying position when going to playing async,
   * while (audio) rendering might be quickly advancing stream position,
   * so use clock asap rather than last reported position */
  if (in_paused && with_clock && g_atomic_int_get (&basesink->priv->to_playing)) {
    GST_DEBUG_OBJECT (basesink, "going to PLAYING, so not PAUSED");
    in_paused = FALSE;
  }

  /* collect all data we need holding the lock */
  if (GST_CLOCK_TIME_IS_VALID (segment->time))
    time = segment->time;
  else
    time = 0;

  if (GST_CLOCK_TIME_IS_VALID (segment->stop))
    duration = segment->stop - segment->start;
  else
    duration = 0;

  base = segment->base;
  rate = segment->rate * segment->applied_rate;
  latency = basesink->priv->latency;

  if (in_paused) {
    /* in paused, use start_time */
    base_time = GST_ELEMENT_START_TIME (basesink);
    GST_DEBUG_OBJECT (basesink, "in paused, using start time %" GST_TIME_FORMAT,
        GST_TIME_ARGS (base_time));
  } else if (with_clock) {
    /* else use clock when needed */
    base_time = GST_ELEMENT_CAST (basesink)->base_time;
    GST_DEBUG_OBJECT (basesink, "using clock and base time %" GST_TIME_FORMAT,
        GST_TIME_ARGS (base_time));
  } else {
    /* else, no sync or clock -> no base time */
    GST_DEBUG_OBJECT (basesink, "no sync or no clock");
    base_time = -1;
  }

  /* no base_time, we can't calculate running_time, use last seem timestamp to report
   * time */
  if (base_time == -1)
    last_seen = TRUE;

  if (oformat == GST_FORMAT_TIME) {
    gint64 start, stop;

    start = basesink->priv->current_sstart;
    stop = basesink->priv->current_sstop;

    if (last_seen) {
      /* when we don't use the clock, we use the last position as a lower bound */
      if (stop == -1 || segment->rate > 0.0)
        last = start;
      else
        last = stop;

      GST_DEBUG_OBJECT (basesink, "in PAUSED using last %" GST_TIME_FORMAT,
          GST_TIME_ARGS (last));
    } else {
      /* in playing and paused, use last stop time as upper bound */
      if (start == -1 || segment->rate > 0.0)
        last = stop;
      else
        last = start;

      GST_DEBUG_OBJECT (basesink, "in PLAYING using last %" GST_TIME_FORMAT,
          GST_TIME_ARGS (last));
    }
  } else {
    /* convert position to stream time */
    last = gst_segment_to_stream_time (segment, oformat, segment->position);

    GST_DEBUG_OBJECT (basesink, "in using last %" G_GINT64_FORMAT, last);
  }

  /* need to release the object lock before we can get the time,
   * a clock might take the LOCK of the provider, which could be
   * a basesink subclass. */
  GST_OBJECT_UNLOCK (basesink);

  if (last_seen) {
    /* in EOS or when no valid stream_time, report the value of last seen
     * timestamp */
    if (last == -1) {
      /* no timestamp, we need to ask upstream */
      GST_DEBUG_OBJECT (basesink, "no last seen timestamp, asking upstream");
      res = FALSE;
      *upstream = TRUE;
      goto done;
    }
    GST_DEBUG_OBJECT (basesink, "using last seen timestamp %" GST_TIME_FORMAT,
        GST_TIME_ARGS (last));
    *cur = last;
  } else {
    if (oformat != GST_FORMAT_TIME) {
      /* convert base, time and duration to time */
      if (!gst_pad_query_convert (basesink->sinkpad, oformat, base,
              GST_FORMAT_TIME, &base))
        goto convert_failed;
      if (!gst_pad_query_convert (basesink->sinkpad, oformat, duration,
              GST_FORMAT_TIME, &duration))
        goto convert_failed;
      if (!gst_pad_query_convert (basesink->sinkpad, oformat, time,
              GST_FORMAT_TIME, &time))
        goto convert_failed;
      if (!gst_pad_query_convert (basesink->sinkpad, oformat, last,
              GST_FORMAT_TIME, &last))
        goto convert_failed;

      /* assume time format from now on */
      oformat = GST_FORMAT_TIME;
    }

    if (!in_paused && with_clock) {
      now = gst_clock_get_time (clock);
    } else {
      now = base_time;
      base_time = 0;
    }

    /* subtract base time and base time from the clock time.
     * Make sure we don't go negative. This is the current time in
     * the segment which we need to scale with the combined
     * rate and applied rate. */
    base_time += base;
    base_time += latency;
    if (GST_CLOCK_DIFF (base_time, now) < 0)
      base_time = now;

    /* for negative rates we need to count back from the segment
     * duration. */
    if (rate < 0.0)
      time += duration;

    *cur = time + gst_guint64_to_gdouble (now - base_time) * rate;

    /* never report more than last seen position */
    if (last != -1)
      *cur = MIN (last, *cur);

    GST_DEBUG_OBJECT (basesink,
        "now %" GST_TIME_FORMAT " - base_time %" GST_TIME_FORMAT " - base %"
        GST_TIME_FORMAT " + time %" GST_TIME_FORMAT "  last %" GST_TIME_FORMAT,
        GST_TIME_ARGS (now), GST_TIME_ARGS (base_time), GST_TIME_ARGS (base),
        GST_TIME_ARGS (time), GST_TIME_ARGS (last));
  }

  if (oformat != format) {
    /* convert to final format */
    if (!gst_pad_query_convert (basesink->sinkpad, oformat, *cur, format, cur))
      goto convert_failed;
  }

  res = TRUE;

done:
  GST_DEBUG_OBJECT (basesink, "res: %d, POSITION: %" GST_TIME_FORMAT,
      res, GST_TIME_ARGS (*cur));

  if (clock)
    gst_object_unref (clock);

  return res;

  /* special cases */
wrong_state:
  {
    /* in NULL or READY we always return FALSE and -1 */
    GST_DEBUG_OBJECT (basesink, "position in wrong state, return -1");
    res = FALSE;
    *cur = -1;
    GST_OBJECT_UNLOCK (basesink);
    goto done;
  }
convert_failed:
  {
    GST_DEBUG_OBJECT (basesink, "convert failed, try upstream");
    *upstream = TRUE;
    res = FALSE;
    goto done;
  }
}

static gboolean
gst_base_sink_get_duration (GstBaseSink * basesink, GstFormat format,
    gint64 * dur, gboolean * upstream)
{
  gboolean res = FALSE;

  if (basesink->pad_mode == GST_PAD_MODE_PULL) {
    gint64 uduration;

    /* get the duration in bytes, in pull mode that's all we are sure to
     * know. We have to explicitly get this value from upstream instead of
     * using our cached value because it might change. Duration caching
     * should be done at a higher level. */
    res =
        gst_pad_peer_query_duration (basesink->sinkpad, GST_FORMAT_BYTES,
        &uduration);
    if (res) {
      basesink->segment.duration = uduration;
      if (format != GST_FORMAT_BYTES) {
        /* convert to the requested format */
        res =
            gst_pad_query_convert (basesink->sinkpad, GST_FORMAT_BYTES,
            uduration, format, dur);
      } else {
        *dur = uduration;
      }
    }
    *upstream = FALSE;
  } else {
    *upstream = TRUE;
  }

  return res;
}

static gboolean
default_element_query (GstElement * element, GstQuery * query)
{
  gboolean res = FALSE;

  GstBaseSink *basesink = GST_BASE_SINK (element);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_POSITION:
    {
      gint64 cur = 0;
      GstFormat format;
      gboolean upstream = FALSE;

      gst_query_parse_position (query, &format, NULL);

      GST_DEBUG_OBJECT (basesink, "position query in format %s",
          gst_format_get_name (format));

      /* first try to get the position based on the clock */
      if ((res =
              gst_base_sink_get_position (basesink, format, &cur, &upstream))) {
        gst_query_set_position (query, format, cur);
      } else if (upstream) {
        /* fallback to peer query */
        res = gst_pad_peer_query (basesink->sinkpad, query);
      }
      if (!res) {
        /* we can handle a few things if upstream failed */
        if (format == GST_FORMAT_PERCENT) {
          gint64 dur = 0;

          res = gst_base_sink_get_position (basesink, GST_FORMAT_TIME, &cur,
              &upstream);
          if (!res && upstream) {
            res =
                gst_pad_peer_query_position (basesink->sinkpad, GST_FORMAT_TIME,
                &cur);
          }
          if (res) {
            res = gst_base_sink_get_duration (basesink, GST_FORMAT_TIME, &dur,
                &upstream);
            if (!res && upstream) {
              res =
                  gst_pad_peer_query_duration (basesink->sinkpad,
                  GST_FORMAT_TIME, &dur);
            }
          }
          if (res) {
            gint64 pos;

            pos = gst_util_uint64_scale (100 * GST_FORMAT_PERCENT_SCALE, cur,
                dur);
            gst_query_set_position (query, GST_FORMAT_PERCENT, pos);
          }
        }
      }
      break;
    }
    case GST_QUERY_DURATION:
    {
      gint64 dur = 0;
      GstFormat format;
      gboolean upstream = FALSE;

      gst_query_parse_duration (query, &format, NULL);

      GST_DEBUG_OBJECT (basesink, "duration query in format %s",
          gst_format_get_name (format));

      if ((res =
              gst_base_sink_get_duration (basesink, format, &dur, &upstream))) {
        gst_query_set_duration (query, format, dur);
      } else if (upstream) {
        /* fallback to peer query */
        res = gst_pad_peer_query (basesink->sinkpad, query);
      }
      if (!res) {
        /* we can handle a few things if upstream failed */
        if (format == GST_FORMAT_PERCENT) {
          gst_query_set_duration (query, GST_FORMAT_PERCENT,
              GST_FORMAT_PERCENT_MAX);
          res = TRUE;
        }
      }
      break;
    }
    case GST_QUERY_LATENCY:
    {
      gboolean live, us_live;
      GstClockTime min, max;

      if ((res = gst_base_sink_query_latency (basesink, &live, &us_live, &min,
                  &max))) {
        gst_query_set_latency (query, live, min, max);
      }
      break;
    }
    case GST_QUERY_JITTER:
      break;
    case GST_QUERY_RATE:
      /* gst_query_set_rate (query, basesink->segment_rate); */
      res = TRUE;
      break;
    case GST_QUERY_SEGMENT:
    {
      if (basesink->pad_mode == GST_PAD_MODE_PULL) {
        GstFormat format;
        gint64 start, stop;

        format = basesink->segment.format;

        start =
            gst_segment_to_stream_time (&basesink->segment, format,
            basesink->segment.start);
        if ((stop = basesink->segment.stop) == -1)
          stop = basesink->segment.duration;
        else
          stop = gst_segment_to_stream_time (&basesink->segment, format, stop);

        gst_query_set_segment (query, basesink->segment.rate, format, start,
            stop);
        res = TRUE;
      } else {
        res = gst_pad_peer_query (basesink->sinkpad, query);
      }
      break;
    }
    case GST_QUERY_SEEKING:
    case GST_QUERY_CONVERT:
    case GST_QUERY_FORMATS:
    default:
      res = gst_pad_peer_query (basesink->sinkpad, query);
      break;
  }
  GST_DEBUG_OBJECT (basesink, "query %s returns %d",
      GST_QUERY_TYPE_NAME (query), res);
  return res;
}


static gboolean
gst_base_sink_default_query (GstBaseSink * basesink, GstQuery * query)
{
  gboolean res;
  GstBaseSinkClass *bclass;

  bclass = GST_BASE_SINK_GET_CLASS (basesink);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_ALLOCATION:
    {
      if (bclass->propose_allocation)
        res = bclass->propose_allocation (basesink, query);
      else
        res = FALSE;
      break;
    }
    case GST_QUERY_CAPS:
    {
      GstCaps *caps, *filter;

      gst_query_parse_caps (query, &filter);
      caps = gst_base_sink_query_caps (basesink, basesink->sinkpad, filter);
      gst_query_set_caps_result (query, caps);
      gst_caps_unref (caps);
      res = TRUE;
      break;
    }
    case GST_QUERY_ACCEPT_CAPS:
    {
      GstCaps *caps, *allowed;
      gboolean subset;

      /* slightly faster than the default implementation */
      gst_query_parse_accept_caps (query, &caps);
      allowed = gst_base_sink_query_caps (basesink, basesink->sinkpad, NULL);
      subset = gst_caps_is_subset (caps, allowed);
      GST_DEBUG_OBJECT (basesink, "Checking if requested caps %" GST_PTR_FORMAT
          " are a subset of pad caps %" GST_PTR_FORMAT " result %d", caps,
          allowed, subset);
      gst_caps_unref (allowed);
      gst_query_set_accept_caps_result (query, subset);
      res = TRUE;
      break;
    }
    case GST_QUERY_DRAIN:
    {
      GstBuffer *old;

      GST_OBJECT_LOCK (basesink);
      if ((old = basesink->priv->last_buffer))
        basesink->priv->last_buffer = gst_buffer_copy (old);
      GST_OBJECT_UNLOCK (basesink);
      if (old)
        gst_buffer_unref (old);
      res = TRUE;
      break;
    }
    default:
      res =
          gst_pad_query_default (basesink->sinkpad, GST_OBJECT_CAST (basesink),
          query);
      break;
  }
  return res;
}

static gboolean
gst_base_sink_sink_query (GstPad * pad, GstObject * parent, GstQuery * query)
{
  GstBaseSink *basesink;
  GstBaseSinkClass *bclass;
  gboolean res;

  basesink = GST_BASE_SINK_CAST (parent);
  bclass = GST_BASE_SINK_GET_CLASS (basesink);

  if (bclass->query)
    res = bclass->query (basesink, query);
  else
    res = FALSE;

  return res;
}

static GstStateChangeReturn
gst_base_sink_change_state (GstElement * element, GstStateChange transition)
{
  GstStateChangeReturn ret = GST_STATE_CHANGE_SUCCESS;
  GstBaseSink *basesink = GST_BASE_SINK (element);
  GstBaseSinkClass *bclass;
  GstBaseSinkPrivate *priv;

  priv = basesink->priv;

  bclass = GST_BASE_SINK_GET_CLASS (basesink);

  switch (transition) {
    case GST_STATE_CHANGE_NULL_TO_READY:
      if (bclass->start)
        if (!bclass->start (basesink))
          goto start_failed;
      break;
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      /* need to complete preroll before this state change completes, there
       * is no data flow in READY so we can safely assume we need to preroll. */
      GST_BASE_SINK_PREROLL_LOCK (basesink);
      GST_DEBUG_OBJECT (basesink, "READY to PAUSED");
      basesink->have_newsegment = FALSE;
      gst_segment_init (&basesink->segment, GST_FORMAT_UNDEFINED);
      basesink->offset = 0;
      basesink->have_preroll = FALSE;
      priv->step_unlock = FALSE;
      basesink->need_preroll = TRUE;
      basesink->playing_async = TRUE;
      priv->current_sstart = GST_CLOCK_TIME_NONE;
      priv->current_sstop = GST_CLOCK_TIME_NONE;
      priv->eos_rtime = GST_CLOCK_TIME_NONE;
      priv->latency = 0;
      basesink->eos = FALSE;
      priv->received_eos = FALSE;
      gst_base_sink_reset_qos (basesink);
      priv->rc_next = -1;
      priv->commited = FALSE;
      priv->call_preroll = TRUE;
      priv->current_step.valid = FALSE;
      priv->pending_step.valid = FALSE;
      if (priv->async_enabled) {
        GST_DEBUG_OBJECT (basesink, "doing async state change");
        /* when async enabled, post async-start message and return ASYNC from
         * the state change function */
        ret = GST_STATE_CHANGE_ASYNC;
        gst_element_post_message (GST_ELEMENT_CAST (basesink),
            gst_message_new_async_start (GST_OBJECT_CAST (basesink)));
      } else {
        priv->have_latency = TRUE;
      }
      GST_BASE_SINK_PREROLL_UNLOCK (basesink);
      break;
    case GST_STATE_CHANGE_PAUSED_TO_PLAYING:
      GST_BASE_SINK_PREROLL_LOCK (basesink);
      g_atomic_int_set (&basesink->priv->to_playing, TRUE);
      if (!gst_base_sink_needs_preroll (basesink)) {
        GST_DEBUG_OBJECT (basesink, "PAUSED to PLAYING, don't need preroll");
        /* no preroll needed anymore now. */
        basesink->playing_async = FALSE;
        basesink->need_preroll = FALSE;
        if (basesink->eos) {
          GstMessage *message;

          /* need to post EOS message here */
          GST_DEBUG_OBJECT (basesink, "Now posting EOS");
          message = gst_message_new_eos (GST_OBJECT_CAST (basesink));
          gst_message_set_seqnum (message, basesink->priv->seqnum);
          gst_element_post_message (GST_ELEMENT_CAST (basesink), message);
        } else {
          GST_DEBUG_OBJECT (basesink, "signal preroll");
          GST_BASE_SINK_PREROLL_SIGNAL (basesink);
        }
      } else {
        GST_DEBUG_OBJECT (basesink, "PAUSED to PLAYING, we are not prerolled");
        basesink->need_preroll = TRUE;
        basesink->playing_async = TRUE;
        priv->call_preroll = TRUE;
        priv->commited = FALSE;
        if (priv->async_enabled) {
          GST_DEBUG_OBJECT (basesink, "doing async state change");
          ret = GST_STATE_CHANGE_ASYNC;
          gst_element_post_message (GST_ELEMENT_CAST (basesink),
              gst_message_new_async_start (GST_OBJECT_CAST (basesink)));
        }
      }
      GST_BASE_SINK_PREROLL_UNLOCK (basesink);
      break;
    default:
      break;
  }

  {
    GstStateChangeReturn bret;

    bret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);
    if (G_UNLIKELY (bret == GST_STATE_CHANGE_FAILURE))
      goto activate_failed;
  }

  switch (transition) {
    case GST_STATE_CHANGE_PAUSED_TO_PLAYING:
      /* completed transition, so need not be marked any longer
       * And it should be unmarked, since e.g. losing our position upon flush
       * does not really change state to PAUSED ... */
      g_atomic_int_set (&basesink->priv->to_playing, FALSE);
      break;
    case GST_STATE_CHANGE_PLAYING_TO_PAUSED:
      g_atomic_int_set (&basesink->priv->to_playing, FALSE);
      GST_DEBUG_OBJECT (basesink, "PLAYING to PAUSED");
      /* FIXME, make sure we cannot enter _render first */

      /* we need to call ::unlock before locking PREROLL_LOCK
       * since we lock it before going into ::render */
      if (bclass->unlock)
        bclass->unlock (basesink);

      GST_BASE_SINK_PREROLL_LOCK (basesink);
      GST_DEBUG_OBJECT (basesink, "got preroll lock");
      /* now that we have the PREROLL lock, clear our unlock request */
      if (bclass->unlock_stop)
        bclass->unlock_stop (basesink);

      /* we need preroll again and we set the flag before unlocking the clockid
       * because if the clockid is unlocked before a current buffer expired, we
       * can use that buffer to preroll with */
      basesink->need_preroll = TRUE;

      if (basesink->clock_id) {
        GST_DEBUG_OBJECT (basesink, "unschedule clock");
        gst_clock_id_unschedule (basesink->clock_id);
      }

      /* if we don't have a preroll buffer we need to wait for a preroll and
       * return ASYNC. */
      if (!gst_base_sink_needs_preroll (basesink)) {
        GST_DEBUG_OBJECT (basesink, "PLAYING to PAUSED, we are prerolled");
        basesink->playing_async = FALSE;
      } else {
        if (GST_STATE_TARGET (GST_ELEMENT (basesink)) <= GST_STATE_READY) {
          GST_DEBUG_OBJECT (basesink, "element is <= READY");
          ret = GST_STATE_CHANGE_SUCCESS;
        } else {
          GST_DEBUG_OBJECT (basesink,
              "PLAYING to PAUSED, we are not prerolled");
          basesink->playing_async = TRUE;
          priv->commited = FALSE;
          priv->call_preroll = TRUE;
          if (priv->async_enabled) {
            GST_DEBUG_OBJECT (basesink, "doing async state change");
            ret = GST_STATE_CHANGE_ASYNC;
            gst_element_post_message (GST_ELEMENT_CAST (basesink),
                gst_message_new_async_start (GST_OBJECT_CAST (basesink)));
          }
        }
      }
      GST_DEBUG_OBJECT (basesink, "rendered: %" G_GUINT64_FORMAT
          ", dropped: %" G_GUINT64_FORMAT, priv->rendered, priv->dropped);

      gst_base_sink_reset_qos (basesink);
      GST_BASE_SINK_PREROLL_UNLOCK (basesink);
      break;
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      GST_BASE_SINK_PREROLL_LOCK (basesink);
      /* start by resetting our position state with the object lock so that the
       * position query gets the right idea. We do this before we post the
       * messages so that the message handlers pick this up. */
      GST_OBJECT_LOCK (basesink);
      basesink->have_newsegment = FALSE;
      priv->current_sstart = GST_CLOCK_TIME_NONE;
      priv->current_sstop = GST_CLOCK_TIME_NONE;
      priv->have_latency = FALSE;
      if (priv->cached_clock_id) {
        gst_clock_id_unref (priv->cached_clock_id);
        priv->cached_clock_id = NULL;
      }
      gst_caps_replace (&basesink->priv->caps, NULL);
      GST_OBJECT_UNLOCK (basesink);

      gst_base_sink_set_last_buffer (basesink, NULL);
      priv->call_preroll = FALSE;

      if (!priv->commited) {
        if (priv->async_enabled) {
          GST_DEBUG_OBJECT (basesink, "PAUSED to READY, posting async-done");

          gst_element_post_message (GST_ELEMENT_CAST (basesink),
              gst_message_new_state_changed (GST_OBJECT_CAST (basesink),
                  GST_STATE_PLAYING, GST_STATE_PAUSED, GST_STATE_READY));

          gst_element_post_message (GST_ELEMENT_CAST (basesink),
              gst_message_new_async_done (GST_OBJECT_CAST (basesink),
                  GST_CLOCK_TIME_NONE));
        }
        priv->commited = TRUE;
      } else {
        GST_DEBUG_OBJECT (basesink, "PAUSED to READY, don't need_preroll");
      }
      GST_BASE_SINK_PREROLL_UNLOCK (basesink);
      break;
    case GST_STATE_CHANGE_READY_TO_NULL:
      if (bclass->stop) {
        if (!bclass->stop (basesink)) {
          GST_WARNING_OBJECT (basesink, "failed to stop");
        }
      }
      gst_base_sink_set_last_buffer (basesink, NULL);
      priv->call_preroll = FALSE;
      break;
    default:
      break;
  }

  return ret;

  /* ERRORS */
start_failed:
  {
    GST_DEBUG_OBJECT (basesink, "failed to start");
    return GST_STATE_CHANGE_FAILURE;
  }
activate_failed:
  {
    GST_DEBUG_OBJECT (basesink,
        "element failed to change states -- activation problem?");
    return GST_STATE_CHANGE_FAILURE;
  }
}
