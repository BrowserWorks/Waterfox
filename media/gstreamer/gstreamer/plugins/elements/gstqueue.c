/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *                    2003 Colin Walters <cwalters@gnome.org>
 *                    2005 Wim Taymans <wim@fluendo.com>
 *
 * gstqueue.c:
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
 * SECTION:element-queue
 *
 * Data is queued until one of the limits specified by the
 * #GstQueue:max-size-buffers, #GstQueue:max-size-bytes and/or
 * #GstQueue:max-size-time properties has been reached. Any attempt to push
 * more buffers into the queue will block the pushing thread until more space
 * becomes available.
 *
 * The queue will create a new thread on the source pad to decouple the
 * processing on sink and source pad.
 *
 * You can query how many buffers are queued by reading the
 * #GstQueue:current-level-buffers property. You can track changes
 * by connecting to the notify::current-level-buffers signal (which
 * like all signals will be emitted from the streaming thread). The same
 * applies to the #GstQueue:current-level-time and
 * #GstQueue:current-level-bytes properties.
 *
 * The default queue size limits are 200 buffers, 10MB of data, or
 * one second worth of data, whichever is reached first.
 *
 * As said earlier, the queue blocks by default when one of the specified
 * maximums (bytes, time, buffers) has been reached. You can set the
 * #GstQueue:leaky property to specify that instead of blocking it should
 * leak (drop) new or old buffers.
 *
 * The #GstQueue::underrun signal is emitted when the queue has less data than
 * the specified minimum thresholds require (by default: when the queue is
 * empty). The #GstQueue::overrun signal is emitted when the queue is filled
 * up. Both signals are emitted from the context of the streaming thread.
 */

#include "gst/gst_private.h"

#include <gst/gst.h>
#include "gstqueue.h"

#include "../../gst/gst-i18n-lib.h"
#include "../../gst/glib-compat-private.h"

static GstStaticPadTemplate sinktemplate = GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

static GstStaticPadTemplate srctemplate = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

GST_DEBUG_CATEGORY_STATIC (queue_debug);
#define GST_CAT_DEFAULT (queue_debug)
GST_DEBUG_CATEGORY_STATIC (queue_dataflow);

#define STATUS(queue, pad, msg) \
  GST_CAT_LOG_OBJECT (queue_dataflow, queue, \
                      "(%s:%s) " msg ": %u of %u-%u buffers, %u of %u-%u " \
                      "bytes, %" G_GUINT64_FORMAT " of %" G_GUINT64_FORMAT \
                      "-%" G_GUINT64_FORMAT " ns, %u items", \
                      GST_DEBUG_PAD_NAME (pad), \
                      queue->cur_level.buffers, \
                      queue->min_threshold.buffers, \
                      queue->max_size.buffers, \
                      queue->cur_level.bytes, \
                      queue->min_threshold.bytes, \
                      queue->max_size.bytes, \
                      queue->cur_level.time, \
                      queue->min_threshold.time, \
                      queue->max_size.time, \
                      gst_queue_array_get_length (queue->queue))

/* Queue signals and args */
enum
{
  SIGNAL_UNDERRUN,
  SIGNAL_RUNNING,
  SIGNAL_OVERRUN,
  SIGNAL_PUSHING,
  LAST_SIGNAL
};

enum
{
  PROP_0,
  /* FIXME: don't we have another way of doing this
   * "Gstreamer format" (frame/byte/time) queries? */
  PROP_CUR_LEVEL_BUFFERS,
  PROP_CUR_LEVEL_BYTES,
  PROP_CUR_LEVEL_TIME,
  PROP_MAX_SIZE_BUFFERS,
  PROP_MAX_SIZE_BYTES,
  PROP_MAX_SIZE_TIME,
  PROP_MIN_THRESHOLD_BUFFERS,
  PROP_MIN_THRESHOLD_BYTES,
  PROP_MIN_THRESHOLD_TIME,
  PROP_LEAKY,
  PROP_SILENT,
  PROP_FLUSH_ON_EOS
};

/* default property values */
#define DEFAULT_MAX_SIZE_BUFFERS  200   /* 200 buffers */
#define DEFAULT_MAX_SIZE_BYTES    (10 * 1024 * 1024)    /* 10 MB       */
#define DEFAULT_MAX_SIZE_TIME     GST_SECOND    /* 1 second    */

#define GST_QUEUE_MUTEX_LOCK(q) G_STMT_START {                          \
  g_mutex_lock (&q->qlock);                                              \
} G_STMT_END

#define GST_QUEUE_MUTEX_LOCK_CHECK(q,label) G_STMT_START {              \
  GST_QUEUE_MUTEX_LOCK (q);                                             \
  if (q->srcresult != GST_FLOW_OK)                                      \
    goto label;                                                         \
} G_STMT_END

#define GST_QUEUE_MUTEX_UNLOCK(q) G_STMT_START {                        \
  g_mutex_unlock (&q->qlock);                                            \
} G_STMT_END

#define GST_QUEUE_WAIT_DEL_CHECK(q, label) G_STMT_START {               \
  STATUS (q, q->sinkpad, "wait for DEL");                               \
  q->waiting_del = TRUE;                                                \
  g_cond_wait (&q->item_del, &q->qlock);                                  \
  q->waiting_del = FALSE;                                               \
  if (q->srcresult != GST_FLOW_OK) {                                    \
    STATUS (q, q->srcpad, "received DEL wakeup");                       \
    goto label;                                                         \
  }                                                                     \
  STATUS (q, q->sinkpad, "received DEL");                               \
} G_STMT_END

#define GST_QUEUE_WAIT_ADD_CHECK(q, label) G_STMT_START {               \
  STATUS (q, q->srcpad, "wait for ADD");                                \
  q->waiting_add = TRUE;                                                \
  g_cond_wait (&q->item_add, &q->qlock);                                  \
  q->waiting_add = FALSE;                                               \
  if (q->srcresult != GST_FLOW_OK) {                                    \
    STATUS (q, q->srcpad, "received ADD wakeup");                       \
    goto label;                                                         \
  }                                                                     \
  STATUS (q, q->srcpad, "received ADD");                                \
} G_STMT_END

#define GST_QUEUE_SIGNAL_DEL(q) G_STMT_START {                          \
  if (q->waiting_del) {                                                 \
    STATUS (q, q->srcpad, "signal DEL");                                \
    g_cond_signal (&q->item_del);                                        \
  }                                                                     \
} G_STMT_END

#define GST_QUEUE_SIGNAL_ADD(q) G_STMT_START {                          \
  if (q->waiting_add) {                                                 \
    STATUS (q, q->sinkpad, "signal ADD");                               \
    g_cond_signal (&q->item_add);                                        \
  }                                                                     \
} G_STMT_END

#define _do_init \
    GST_DEBUG_CATEGORY_INIT (queue_debug, "queue", 0, "queue element"); \
    GST_DEBUG_CATEGORY_INIT (queue_dataflow, "queue_dataflow", 0, \
        "dataflow inside the queue element");
#define gst_queue_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstQueue, gst_queue, GST_TYPE_ELEMENT, _do_init);

static void gst_queue_finalize (GObject * object);
static void gst_queue_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec);
static void gst_queue_get_property (GObject * object,
    guint prop_id, GValue * value, GParamSpec * pspec);

static GstFlowReturn gst_queue_chain (GstPad * pad, GstObject * parent,
    GstBuffer * buffer);
static GstFlowReturn gst_queue_push_one (GstQueue * queue);
static void gst_queue_loop (GstPad * pad);

static gboolean gst_queue_handle_sink_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static gboolean gst_queue_handle_sink_query (GstPad * pad, GstObject * parent,
    GstQuery * query);

static gboolean gst_queue_handle_src_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static gboolean gst_queue_handle_src_query (GstPad * pad, GstObject * parent,
    GstQuery * query);

static void gst_queue_locked_flush (GstQueue * queue, gboolean full);

static gboolean gst_queue_src_activate_mode (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active);
static gboolean gst_queue_sink_activate_mode (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active);

static gboolean gst_queue_is_empty (GstQueue * queue);
static gboolean gst_queue_is_filled (GstQueue * queue);


typedef struct
{
  gboolean is_query;
  GstMiniObject *item;
  gsize size;
} GstQueueItem;

#define GST_TYPE_QUEUE_LEAKY (queue_leaky_get_type ())

static GType
queue_leaky_get_type (void)
{
  static GType queue_leaky_type = 0;
  static const GEnumValue queue_leaky[] = {
    {GST_QUEUE_NO_LEAK, "Not Leaky", "no"},
    {GST_QUEUE_LEAK_UPSTREAM, "Leaky on upstream (new buffers)", "upstream"},
    {GST_QUEUE_LEAK_DOWNSTREAM, "Leaky on downstream (old buffers)",
        "downstream"},
    {0, NULL, NULL},
  };

  if (!queue_leaky_type) {
    queue_leaky_type = g_enum_register_static ("GstQueueLeaky", queue_leaky);
  }
  return queue_leaky_type;
}

static guint gst_queue_signals[LAST_SIGNAL] = { 0 };

static void
gst_queue_class_init (GstQueueClass * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);
  GstElementClass *gstelement_class = GST_ELEMENT_CLASS (klass);

  gobject_class->set_property = gst_queue_set_property;
  gobject_class->get_property = gst_queue_get_property;

  /* signals */
  /**
   * GstQueue::underrun:
   * @queue: the queue instance
   *
   * Reports that the buffer became empty (underrun).
   * A buffer is empty if the total amount of data inside it (num-buffers, time,
   * size) is lower than the boundary values which can be set through the
   * GObject properties.
   */
  gst_queue_signals[SIGNAL_UNDERRUN] =
      g_signal_new ("underrun", G_TYPE_FROM_CLASS (klass), G_SIGNAL_RUN_FIRST,
      G_STRUCT_OFFSET (GstQueueClass, underrun), NULL, NULL,
      g_cclosure_marshal_VOID__VOID, G_TYPE_NONE, 0);
  /**
   * GstQueue::running:
   * @queue: the queue instance
   *
   * Reports that enough (min-threshold) data is in the queue. Use this signal
   * together with the underrun signal to pause the pipeline on underrun and
   * wait for the queue to fill-up before resume playback.
   */
  gst_queue_signals[SIGNAL_RUNNING] =
      g_signal_new ("running", G_TYPE_FROM_CLASS (klass), G_SIGNAL_RUN_FIRST,
      G_STRUCT_OFFSET (GstQueueClass, running), NULL, NULL,
      g_cclosure_marshal_VOID__VOID, G_TYPE_NONE, 0);
  /**
   * GstQueue::overrun:
   * @queue: the queue instance
   *
   * Reports that the buffer became full (overrun).
   * A buffer is full if the total amount of data inside it (num-buffers, time,
   * size) is higher than the boundary values which can be set through the
   * GObject properties.
   */
  gst_queue_signals[SIGNAL_OVERRUN] =
      g_signal_new ("overrun", G_TYPE_FROM_CLASS (klass), G_SIGNAL_RUN_FIRST,
      G_STRUCT_OFFSET (GstQueueClass, overrun), NULL, NULL,
      g_cclosure_marshal_VOID__VOID, G_TYPE_NONE, 0);
  /**
   * GstQueue::pushing:
   * @queue: the queue instance
   *
   * Reports when the queue has enough data to start pushing data again on the
   * source pad.
   */
  gst_queue_signals[SIGNAL_PUSHING] =
      g_signal_new ("pushing", G_TYPE_FROM_CLASS (klass), G_SIGNAL_RUN_FIRST,
      G_STRUCT_OFFSET (GstQueueClass, pushing), NULL, NULL,
      g_cclosure_marshal_VOID__VOID, G_TYPE_NONE, 0);

  /* properties */
  g_object_class_install_property (gobject_class, PROP_CUR_LEVEL_BYTES,
      g_param_spec_uint ("current-level-bytes", "Current level (kB)",
          "Current amount of data in the queue (bytes)",
          0, G_MAXUINT, 0, G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_CUR_LEVEL_BUFFERS,
      g_param_spec_uint ("current-level-buffers", "Current level (buffers)",
          "Current number of buffers in the queue",
          0, G_MAXUINT, 0, G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_CUR_LEVEL_TIME,
      g_param_spec_uint64 ("current-level-time", "Current level (ns)",
          "Current amount of data in the queue (in ns)",
          0, G_MAXUINT64, 0, G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_MAX_SIZE_BYTES,
      g_param_spec_uint ("max-size-bytes", "Max. size (kB)",
          "Max. amount of data in the queue (bytes, 0=disable)",
          0, G_MAXUINT, DEFAULT_MAX_SIZE_BYTES,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_MAX_SIZE_BUFFERS,
      g_param_spec_uint ("max-size-buffers", "Max. size (buffers)",
          "Max. number of buffers in the queue (0=disable)", 0, G_MAXUINT,
          DEFAULT_MAX_SIZE_BUFFERS,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_MAX_SIZE_TIME,
      g_param_spec_uint64 ("max-size-time", "Max. size (ns)",
          "Max. amount of data in the queue (in ns, 0=disable)", 0, G_MAXUINT64,
          DEFAULT_MAX_SIZE_TIME, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_MIN_THRESHOLD_BYTES,
      g_param_spec_uint ("min-threshold-bytes", "Min. threshold (kB)",
          "Min. amount of data in the queue to allow reading (bytes, 0=disable)",
          0, G_MAXUINT, 0, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_MIN_THRESHOLD_BUFFERS,
      g_param_spec_uint ("min-threshold-buffers", "Min. threshold (buffers)",
          "Min. number of buffers in the queue to allow reading (0=disable)",
          0, G_MAXUINT, 0, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_MIN_THRESHOLD_TIME,
      g_param_spec_uint64 ("min-threshold-time", "Min. threshold (ns)",
          "Min. amount of data in the queue to allow reading (in ns, 0=disable)",
          0, G_MAXUINT64, 0, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_LEAKY,
      g_param_spec_enum ("leaky", "Leaky",
          "Where the queue leaks, if at all",
          GST_TYPE_QUEUE_LEAKY, GST_QUEUE_NO_LEAK,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstQueue:silent
   *
   * Don't emit queue signals. Makes queues more lightweight if no signals are
   * needed.
   */
  g_object_class_install_property (gobject_class, PROP_SILENT,
      g_param_spec_boolean ("silent", "Silent",
          "Don't emit queue signals", FALSE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstQueue:flush-on-eos
   *
   * Discard all data in the queue when an EOS event is received, and pass
   * on the EOS event as soon as possible (instead of waiting until all
   * buffers in the queue have been processed, which is the default behaviour).
   *
   * Flushing the queue on EOS might be useful when capturing and encoding
   * from a live source, to finish up the recording quickly in cases when
   * the encoder is slow. Note that this might mean some data from the end of
   * the recording data might be lost though (never more than the configured
   * max. sizes though).
   *
   * Since: 1.2
   */
  g_object_class_install_property (gobject_class, PROP_FLUSH_ON_EOS,
      g_param_spec_boolean ("flush-on-eos", "Flush on EOS",
          "Discard all data in the queue when an EOS event is received", FALSE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gobject_class->finalize = gst_queue_finalize;

  gst_element_class_set_static_metadata (gstelement_class,
      "Queue",
      "Generic", "Simple data queue", "Erik Walthinsen <omega@cse.ogi.edu>");
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&srctemplate));
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&sinktemplate));

  /* Registering debug symbols for function pointers */
  GST_DEBUG_REGISTER_FUNCPTR (gst_queue_src_activate_mode);
  GST_DEBUG_REGISTER_FUNCPTR (gst_queue_handle_sink_event);
  GST_DEBUG_REGISTER_FUNCPTR (gst_queue_handle_sink_query);
  GST_DEBUG_REGISTER_FUNCPTR (gst_queue_handle_src_event);
  GST_DEBUG_REGISTER_FUNCPTR (gst_queue_handle_src_query);
  GST_DEBUG_REGISTER_FUNCPTR (gst_queue_chain);
}

static void
gst_queue_init (GstQueue * queue)
{
  queue->sinkpad = gst_pad_new_from_static_template (&sinktemplate, "sink");

  gst_pad_set_chain_function (queue->sinkpad, gst_queue_chain);
  gst_pad_set_activatemode_function (queue->sinkpad,
      gst_queue_sink_activate_mode);
  gst_pad_set_event_function (queue->sinkpad, gst_queue_handle_sink_event);
  gst_pad_set_query_function (queue->sinkpad, gst_queue_handle_sink_query);
  GST_PAD_SET_PROXY_CAPS (queue->sinkpad);
  gst_element_add_pad (GST_ELEMENT (queue), queue->sinkpad);

  queue->srcpad = gst_pad_new_from_static_template (&srctemplate, "src");

  gst_pad_set_activatemode_function (queue->srcpad,
      gst_queue_src_activate_mode);
  gst_pad_set_event_function (queue->srcpad, gst_queue_handle_src_event);
  gst_pad_set_query_function (queue->srcpad, gst_queue_handle_src_query);
  GST_PAD_SET_PROXY_CAPS (queue->srcpad);
  gst_element_add_pad (GST_ELEMENT (queue), queue->srcpad);

  GST_QUEUE_CLEAR_LEVEL (queue->cur_level);
  queue->max_size.buffers = DEFAULT_MAX_SIZE_BUFFERS;
  queue->max_size.bytes = DEFAULT_MAX_SIZE_BYTES;
  queue->max_size.time = DEFAULT_MAX_SIZE_TIME;
  GST_QUEUE_CLEAR_LEVEL (queue->min_threshold);
  GST_QUEUE_CLEAR_LEVEL (queue->orig_min_threshold);
  gst_segment_init (&queue->sink_segment, GST_FORMAT_TIME);
  gst_segment_init (&queue->src_segment, GST_FORMAT_TIME);
  queue->head_needs_discont = queue->tail_needs_discont = FALSE;

  queue->leaky = GST_QUEUE_NO_LEAK;
  queue->srcresult = GST_FLOW_FLUSHING;

  g_mutex_init (&queue->qlock);
  g_cond_init (&queue->item_add);
  g_cond_init (&queue->item_del);
  g_cond_init (&queue->query_handled);

  queue->queue = gst_queue_array_new (DEFAULT_MAX_SIZE_BUFFERS * 3 / 2);

  queue->sinktime = GST_CLOCK_TIME_NONE;
  queue->srctime = GST_CLOCK_TIME_NONE;

  queue->sink_tainted = TRUE;
  queue->src_tainted = TRUE;

  queue->newseg_applied_to_src = FALSE;

  GST_DEBUG_OBJECT (queue,
      "initialized queue's not_empty & not_full conditions");
}

/* called only once, as opposed to dispose */
static void
gst_queue_finalize (GObject * object)
{
  GstQueue *queue = GST_QUEUE (object);

  GST_DEBUG_OBJECT (queue, "finalizing queue");

  while (!gst_queue_array_is_empty (queue->queue)) {
    GstQueueItem *qitem = gst_queue_array_pop_head (queue->queue);
    /* FIXME: if it's a query, shouldn't we unref that too? */
    if (!qitem->is_query)
      gst_mini_object_unref (qitem->item);
    g_slice_free (GstQueueItem, qitem);
  }
  gst_queue_array_free (queue->queue);

  g_mutex_clear (&queue->qlock);
  g_cond_clear (&queue->item_add);
  g_cond_clear (&queue->item_del);
  g_cond_clear (&queue->query_handled);

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

/* calculate the diff between running time on the sink and src of the queue.
 * This is the total amount of time in the queue. */
static void
update_time_level (GstQueue * queue)
{
  gint64 sink_time, src_time;

  if (queue->sink_tainted) {
    GST_LOG_OBJECT (queue, "update sink time");
    queue->sinktime =
        gst_segment_to_running_time (&queue->sink_segment, GST_FORMAT_TIME,
        queue->sink_segment.position);
    queue->sink_tainted = FALSE;
  }
  sink_time = queue->sinktime;

  if (queue->src_tainted) {
    GST_LOG_OBJECT (queue, "update src time");
    queue->srctime =
        gst_segment_to_running_time (&queue->src_segment, GST_FORMAT_TIME,
        queue->src_segment.position);
    queue->src_tainted = FALSE;
  }
  src_time = queue->srctime;

  GST_LOG_OBJECT (queue, "sink %" GST_TIME_FORMAT ", src %" GST_TIME_FORMAT,
      GST_TIME_ARGS (sink_time), GST_TIME_ARGS (src_time));

  if (sink_time >= src_time)
    queue->cur_level.time = sink_time - src_time;
  else
    queue->cur_level.time = 0;
}

/* take a SEGMENT event and apply the values to segment, updating the time
 * level of queue. */
static void
apply_segment (GstQueue * queue, GstEvent * event, GstSegment * segment,
    gboolean sink)
{
  gst_event_copy_segment (event, segment);

  /* now configure the values, we use these to track timestamps on the
   * sinkpad. */
  if (segment->format != GST_FORMAT_TIME) {
    /* non-time format, pretent the current time segment is closed with a
     * 0 start and unknown stop time. */
    segment->format = GST_FORMAT_TIME;
    segment->start = 0;
    segment->stop = -1;
    segment->time = 0;
  }
  if (sink)
    queue->sink_tainted = TRUE;
  else
    queue->src_tainted = TRUE;

  GST_DEBUG_OBJECT (queue, "configured SEGMENT %" GST_SEGMENT_FORMAT, segment);

  /* segment can update the time level of the queue */
  update_time_level (queue);
}

/* take a buffer and update segment, updating the time level of the queue. */
static void
apply_buffer (GstQueue * queue, GstBuffer * buffer, GstSegment * segment,
    gboolean with_duration, gboolean sink)
{
  GstClockTime duration, timestamp;

  timestamp = GST_BUFFER_TIMESTAMP (buffer);
  duration = GST_BUFFER_DURATION (buffer);

  /* if no timestamp is set, assume it's continuous with the previous
   * time */
  if (timestamp == GST_CLOCK_TIME_NONE)
    timestamp = segment->position;

  /* add duration */
  if (with_duration && duration != GST_CLOCK_TIME_NONE)
    timestamp += duration;

  GST_LOG_OBJECT (queue, "position updated to %" GST_TIME_FORMAT,
      GST_TIME_ARGS (timestamp));

  segment->position = timestamp;
  if (sink)
    queue->sink_tainted = TRUE;
  else
    queue->src_tainted = TRUE;


  /* calc diff with other end */
  update_time_level (queue);
}

static void
gst_queue_locked_flush (GstQueue * queue, gboolean full)
{
  while (!gst_queue_array_is_empty (queue->queue)) {
    GstQueueItem *qitem = gst_queue_array_pop_head (queue->queue);

    /* Then lose another reference because we are supposed to destroy that
       data when flushing */
    if (!full && !qitem->is_query && GST_IS_EVENT (qitem->item)
        && GST_EVENT_IS_STICKY (qitem->item)
        && GST_EVENT_TYPE (qitem->item) != GST_EVENT_SEGMENT
        && GST_EVENT_TYPE (qitem->item) != GST_EVENT_EOS) {
      gst_pad_store_sticky_event (queue->srcpad, GST_EVENT_CAST (qitem->item));
    }
    if (!qitem->is_query)
      gst_mini_object_unref (qitem->item);
    g_slice_free (GstQueueItem, qitem);
  }
  queue->last_query = FALSE;
  g_cond_signal (&queue->query_handled);
  GST_QUEUE_CLEAR_LEVEL (queue->cur_level);
  queue->min_threshold.buffers = queue->orig_min_threshold.buffers;
  queue->min_threshold.bytes = queue->orig_min_threshold.bytes;
  queue->min_threshold.time = queue->orig_min_threshold.time;
  gst_segment_init (&queue->sink_segment, GST_FORMAT_TIME);
  gst_segment_init (&queue->src_segment, GST_FORMAT_TIME);
  queue->head_needs_discont = queue->tail_needs_discont = FALSE;

  queue->sinktime = queue->srctime = GST_CLOCK_TIME_NONE;
  queue->sink_tainted = queue->src_tainted = TRUE;

  /* we deleted a lot of something */
  GST_QUEUE_SIGNAL_DEL (queue);
}

/* enqueue an item an update the level stats, with QUEUE_LOCK */
static inline void
gst_queue_locked_enqueue_buffer (GstQueue * queue, gpointer item)
{
  GstQueueItem *qitem;
  GstBuffer *buffer = GST_BUFFER_CAST (item);
  gsize bsize = gst_buffer_get_size (buffer);

  /* add buffer to the statistics */
  queue->cur_level.buffers++;
  queue->cur_level.bytes += bsize;
  apply_buffer (queue, buffer, &queue->sink_segment, TRUE, TRUE);

  qitem = g_slice_new (GstQueueItem);
  qitem->item = item;
  qitem->is_query = FALSE;
  qitem->size = bsize;
  gst_queue_array_push_tail (queue->queue, qitem);
  GST_QUEUE_SIGNAL_ADD (queue);
}

static inline void
gst_queue_locked_enqueue_event (GstQueue * queue, gpointer item)
{
  GstQueueItem *qitem;
  GstEvent *event = GST_EVENT_CAST (item);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_EOS:
      GST_CAT_LOG_OBJECT (queue_dataflow, queue, "got EOS from upstream");
      /* Zero the thresholds, this makes sure the queue is completely
       * filled and we can read all data from the queue. */
      if (queue->flush_on_eos)
        gst_queue_locked_flush (queue, FALSE);
      else
        GST_QUEUE_CLEAR_LEVEL (queue->min_threshold);
      /* mark the queue as EOS. This prevents us from accepting more data. */
      queue->eos = TRUE;
      break;
    case GST_EVENT_SEGMENT:
      apply_segment (queue, event, &queue->sink_segment, TRUE);
      /* if the queue is empty, apply sink segment on the source */
      if (gst_queue_array_is_empty (queue->queue)) {
        GST_CAT_LOG_OBJECT (queue_dataflow, queue, "Apply segment on srcpad");
        apply_segment (queue, event, &queue->src_segment, FALSE);
        queue->newseg_applied_to_src = TRUE;
      }
      /* a new segment allows us to accept more buffers if we got EOS
       * from downstream */
      queue->unexpected = FALSE;
      break;
    default:
      break;
  }

  qitem = g_slice_new (GstQueueItem);
  qitem->item = item;
  qitem->is_query = FALSE;
  gst_queue_array_push_tail (queue->queue, qitem);
  GST_QUEUE_SIGNAL_ADD (queue);
}

/* dequeue an item from the queue and update level stats, with QUEUE_LOCK */
static GstMiniObject *
gst_queue_locked_dequeue (GstQueue * queue)
{
  GstQueueItem *qitem;
  GstMiniObject *item;
  gsize bufsize;

  qitem = gst_queue_array_pop_head (queue->queue);
  if (qitem == NULL)
    goto no_item;

  item = qitem->item;
  bufsize = qitem->size;
  g_slice_free (GstQueueItem, qitem);

  if (GST_IS_BUFFER (item)) {
    GstBuffer *buffer = GST_BUFFER_CAST (item);

    GST_CAT_LOG_OBJECT (queue_dataflow, queue,
        "retrieved buffer %p from queue", buffer);

    queue->cur_level.buffers--;
    queue->cur_level.bytes -= bufsize;
    apply_buffer (queue, buffer, &queue->src_segment, TRUE, FALSE);

    /* if the queue is empty now, update the other side */
    if (queue->cur_level.buffers == 0)
      queue->cur_level.time = 0;

  } else if (GST_IS_EVENT (item)) {
    GstEvent *event = GST_EVENT_CAST (item);

    GST_CAT_LOG_OBJECT (queue_dataflow, queue,
        "retrieved event %p from queue", event);

    switch (GST_EVENT_TYPE (event)) {
      case GST_EVENT_EOS:
        /* queue is empty now that we dequeued the EOS */
        GST_QUEUE_CLEAR_LEVEL (queue->cur_level);
        break;
      case GST_EVENT_SEGMENT:
        /* apply newsegment if it has not already been applied */
        if (G_LIKELY (!queue->newseg_applied_to_src)) {
          apply_segment (queue, event, &queue->src_segment, FALSE);
        } else {
          queue->newseg_applied_to_src = FALSE;
        }
        break;
      default:
        break;
    }
  } else if (GST_IS_QUERY (item)) {
    GstQuery *query = GST_QUERY_CAST (item);

    GST_CAT_LOG_OBJECT (queue_dataflow, queue,
        "retrieved query %p from queue", query);
  } else {
    g_warning
        ("Unexpected item %p dequeued from queue %s (refcounting problem?)",
        item, GST_OBJECT_NAME (queue));
    item = NULL;
  }
  GST_QUEUE_SIGNAL_DEL (queue);

  return item;

  /* ERRORS */
no_item:
  {
    GST_CAT_DEBUG_OBJECT (queue_dataflow, queue, "the queue is empty");
    return NULL;
  }
}

static gboolean
gst_queue_handle_sink_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  gboolean ret = TRUE;
  GstQueue *queue;

  queue = GST_QUEUE (parent);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_FLUSH_START:
      STATUS (queue, pad, "received flush start event");
      /* forward event */
      ret = gst_pad_push_event (queue->srcpad, event);

      /* now unblock the chain function */
      GST_QUEUE_MUTEX_LOCK (queue);
      queue->srcresult = GST_FLOW_FLUSHING;
      /* unblock the loop and chain functions */
      GST_QUEUE_SIGNAL_ADD (queue);
      GST_QUEUE_SIGNAL_DEL (queue);
      queue->last_query = FALSE;
      g_cond_signal (&queue->query_handled);
      GST_QUEUE_MUTEX_UNLOCK (queue);

      /* make sure it pauses, this should happen since we sent
       * flush_start downstream. */
      gst_pad_pause_task (queue->srcpad);
      GST_CAT_LOG_OBJECT (queue_dataflow, queue, "loop stopped");
      break;
    case GST_EVENT_FLUSH_STOP:
      STATUS (queue, pad, "received flush stop event");
      /* forward event */
      ret = gst_pad_push_event (queue->srcpad, event);

      GST_QUEUE_MUTEX_LOCK (queue);
      gst_queue_locked_flush (queue, FALSE);
      queue->srcresult = GST_FLOW_OK;
      queue->eos = FALSE;
      queue->unexpected = FALSE;
      if (gst_pad_is_active (queue->srcpad)) {
        gst_pad_start_task (queue->srcpad, (GstTaskFunction) gst_queue_loop,
            queue->srcpad, NULL);
      } else {
        GST_INFO_OBJECT (queue->srcpad, "not re-starting task on srcpad, "
            "pad not active any longer");
      }
      GST_QUEUE_MUTEX_UNLOCK (queue);

      STATUS (queue, pad, "after flush");
      break;
    default:
      if (GST_EVENT_IS_SERIALIZED (event)) {
        /* serialized events go in the queue */
        GST_QUEUE_MUTEX_LOCK (queue);
        if (queue->srcresult != GST_FLOW_OK) {
          /* Errors in sticky event pushing are no problem and ignored here
           * as they will cause more meaningful errors during data flow.
           * For EOS events, that are not followed by data flow, we still
           * return FALSE here though and report an error.
           */
          if (!GST_EVENT_IS_STICKY (event)) {
            goto out_flow_error;
          } else if (GST_EVENT_TYPE (event) == GST_EVENT_EOS) {
            if (queue->srcresult == GST_FLOW_NOT_LINKED
                || queue->srcresult < GST_FLOW_EOS) {
              GST_ELEMENT_ERROR (queue, STREAM, FAILED,
                  (_("Internal data flow error.")),
                  ("streaming task paused, reason %s (%d)",
                      gst_flow_get_name (queue->srcresult), queue->srcresult));
            }
            goto out_flow_error;
          }
        }
        /* refuse more events on EOS */
        if (queue->eos)
          goto out_eos;
        gst_queue_locked_enqueue_event (queue, event);
        GST_QUEUE_MUTEX_UNLOCK (queue);
      } else {
        /* non-serialized events are forwarded downstream immediately */
        ret = gst_pad_push_event (queue->srcpad, event);
      }
      break;
  }
  return ret;

  /* ERRORS */
out_eos:
  {
    GST_CAT_LOG_OBJECT (queue_dataflow, queue, "refusing event, we are EOS");
    GST_QUEUE_MUTEX_UNLOCK (queue);
    gst_event_unref (event);
    return FALSE;
  }
out_flow_error:
  {
    GST_CAT_LOG_OBJECT (queue_dataflow, queue,
        "refusing event, we have a downstream flow error: %s",
        gst_flow_get_name (queue->srcresult));
    GST_QUEUE_MUTEX_UNLOCK (queue);
    gst_event_unref (event);
    return FALSE;
  }
}

static gboolean
gst_queue_handle_sink_query (GstPad * pad, GstObject * parent, GstQuery * query)
{
  GstQueue *queue = GST_QUEUE_CAST (parent);
  gboolean res;

  switch (GST_QUERY_TYPE (query)) {
    default:
      if (G_UNLIKELY (GST_QUERY_IS_SERIALIZED (query))) {
        GstQueueItem *qitem;

        GST_QUEUE_MUTEX_LOCK_CHECK (queue, out_flushing);
        GST_LOG_OBJECT (queue, "queuing query %p (%s)", query,
            GST_QUERY_TYPE_NAME (query));
        qitem = g_slice_new (GstQueueItem);
        qitem->item = GST_MINI_OBJECT_CAST (query);
        qitem->is_query = TRUE;
        gst_queue_array_push_tail (queue->queue, qitem);
        GST_QUEUE_SIGNAL_ADD (queue);
        g_cond_wait (&queue->query_handled, &queue->qlock);
        if (queue->srcresult != GST_FLOW_OK)
          goto out_flushing;
        res = queue->last_query;
        GST_QUEUE_MUTEX_UNLOCK (queue);
      } else {
        res = gst_pad_query_default (pad, parent, query);
      }
      break;
  }
  return res;

  /* ERRORS */
out_flushing:
  {
    GST_DEBUG_OBJECT (queue, "we are flushing");
    GST_QUEUE_MUTEX_UNLOCK (queue);
    return FALSE;
  }
}

static gboolean
gst_queue_is_empty (GstQueue * queue)
{
  GstQueueItem *head;

  if (gst_queue_array_is_empty (queue->queue))
    return TRUE;

  /* Only consider the queue empty if the minimum thresholds
   * are not reached and data is at the queue head. Otherwise
   * we would block forever on serialized queries.
   */
  head = gst_queue_array_peek_head (queue->queue);
  if (!GST_IS_BUFFER (head->item) && !GST_IS_BUFFER_LIST (head->item))
    return FALSE;

  /* It is possible that a max size is reached before all min thresholds are.
   * Therefore, only consider it empty if it is not filled. */
  return ((queue->min_threshold.buffers > 0 &&
          queue->cur_level.buffers < queue->min_threshold.buffers) ||
      (queue->min_threshold.bytes > 0 &&
          queue->cur_level.bytes < queue->min_threshold.bytes) ||
      (queue->min_threshold.time > 0 &&
          queue->cur_level.time < queue->min_threshold.time)) &&
      !gst_queue_is_filled (queue);
}

static gboolean
gst_queue_is_filled (GstQueue * queue)
{
  return (((queue->max_size.buffers > 0 &&
              queue->cur_level.buffers >= queue->max_size.buffers) ||
          (queue->max_size.bytes > 0 &&
              queue->cur_level.bytes >= queue->max_size.bytes) ||
          (queue->max_size.time > 0 &&
              queue->cur_level.time >= queue->max_size.time)));
}

static void
gst_queue_leak_downstream (GstQueue * queue)
{
  /* for as long as the queue is filled, dequeue an item and discard it */
  while (gst_queue_is_filled (queue)) {
    GstMiniObject *leak;

    leak = gst_queue_locked_dequeue (queue);
    /* there is nothing to dequeue and the queue is still filled.. This should
     * not happen */
    g_assert (leak != NULL);

    GST_CAT_DEBUG_OBJECT (queue_dataflow, queue,
        "queue is full, leaking item %p on downstream end", leak);
    if (GST_IS_EVENT (leak) && GST_EVENT_IS_STICKY (leak)) {
      GST_CAT_DEBUG_OBJECT (queue_dataflow, queue,
          "Storing sticky event %s on srcpad", GST_EVENT_TYPE_NAME (leak));
      gst_pad_store_sticky_event (queue->srcpad, GST_EVENT_CAST (leak));
    }

    if (!GST_IS_QUERY (leak))
      gst_mini_object_unref (leak);

    /* last buffer needs to get a DISCONT flag */
    queue->head_needs_discont = TRUE;
  }
}

static GstFlowReturn
gst_queue_chain (GstPad * pad, GstObject * parent, GstBuffer * buffer)
{
  GstQueue *queue;
  GstClockTime duration, timestamp;

  queue = GST_QUEUE_CAST (parent);

  /* we have to lock the queue since we span threads */
  GST_QUEUE_MUTEX_LOCK_CHECK (queue, out_flushing);
  /* when we received EOS, we refuse any more data */
  if (queue->eos)
    goto out_eos;
  if (queue->unexpected)
    goto out_unexpected;

  timestamp = GST_BUFFER_TIMESTAMP (buffer);
  duration = GST_BUFFER_DURATION (buffer);

  GST_CAT_LOG_OBJECT (queue_dataflow, queue, "received buffer %p of size %"
      G_GSIZE_FORMAT ", time %" GST_TIME_FORMAT ", duration %"
      GST_TIME_FORMAT, buffer, gst_buffer_get_size (buffer),
      GST_TIME_ARGS (timestamp), GST_TIME_ARGS (duration));

  /* We make space available if we're "full" according to whatever
   * the user defined as "full". Note that this only applies to buffers.
   * We always handle events and they don't count in our statistics. */
  while (gst_queue_is_filled (queue)) {
    if (!queue->silent) {
      GST_QUEUE_MUTEX_UNLOCK (queue);
      g_signal_emit (queue, gst_queue_signals[SIGNAL_OVERRUN], 0);
      GST_QUEUE_MUTEX_LOCK_CHECK (queue, out_flushing);
      /* we recheck, the signal could have changed the thresholds */
      if (!gst_queue_is_filled (queue))
        break;
    }

    /* how are we going to make space for this buffer? */
    switch (queue->leaky) {
      case GST_QUEUE_LEAK_UPSTREAM:
        /* next buffer needs to get a DISCONT flag */
        queue->tail_needs_discont = TRUE;
        /* leak current buffer */
        GST_CAT_DEBUG_OBJECT (queue_dataflow, queue,
            "queue is full, leaking buffer on upstream end");
        /* now we can clean up and exit right away */
        goto out_unref;
      case GST_QUEUE_LEAK_DOWNSTREAM:
        gst_queue_leak_downstream (queue);
        break;
      default:
        g_warning ("Unknown leaky type, using default");
        /* fall-through */
      case GST_QUEUE_NO_LEAK:
      {
        GST_CAT_DEBUG_OBJECT (queue_dataflow, queue,
            "queue is full, waiting for free space");

        /* don't leak. Instead, wait for space to be available */
        do {
          /* for as long as the queue is filled, wait till an item was deleted. */
          GST_QUEUE_WAIT_DEL_CHECK (queue, out_flushing);
        } while (gst_queue_is_filled (queue));

        GST_CAT_DEBUG_OBJECT (queue_dataflow, queue, "queue is not full");

        if (!queue->silent) {
          GST_QUEUE_MUTEX_UNLOCK (queue);
          g_signal_emit (queue, gst_queue_signals[SIGNAL_RUNNING], 0);
          GST_QUEUE_MUTEX_LOCK_CHECK (queue, out_flushing);
        }
        break;
      }
    }
  }

  if (queue->tail_needs_discont) {
    GstBuffer *subbuffer = gst_buffer_make_writable (buffer);

    if (subbuffer) {
      buffer = subbuffer;
      GST_BUFFER_FLAG_SET (buffer, GST_BUFFER_FLAG_DISCONT);
    } else {
      GST_DEBUG_OBJECT (queue, "Could not mark buffer as DISCONT");
    }
    queue->tail_needs_discont = FALSE;
  }

  /* put buffer in queue now */
  gst_queue_locked_enqueue_buffer (queue, buffer);
  GST_QUEUE_MUTEX_UNLOCK (queue);

  return GST_FLOW_OK;

  /* special conditions */
out_unref:
  {
    GST_QUEUE_MUTEX_UNLOCK (queue);

    gst_buffer_unref (buffer);

    return GST_FLOW_OK;
  }
out_flushing:
  {
    GstFlowReturn ret = queue->srcresult;

    GST_CAT_LOG_OBJECT (queue_dataflow, queue,
        "exit because task paused, reason: %s", gst_flow_get_name (ret));
    GST_QUEUE_MUTEX_UNLOCK (queue);
    gst_buffer_unref (buffer);

    return ret;
  }
out_eos:
  {
    GST_CAT_LOG_OBJECT (queue_dataflow, queue, "exit because we received EOS");
    GST_QUEUE_MUTEX_UNLOCK (queue);

    gst_buffer_unref (buffer);

    return GST_FLOW_EOS;
  }
out_unexpected:
  {
    GST_CAT_LOG_OBJECT (queue_dataflow, queue, "exit because we received EOS");
    GST_QUEUE_MUTEX_UNLOCK (queue);

    gst_buffer_unref (buffer);

    return GST_FLOW_EOS;
  }
}

/* dequeue an item from the queue an push it downstream. This functions returns
 * the result of the push. */
static GstFlowReturn
gst_queue_push_one (GstQueue * queue)
{
  GstFlowReturn result = queue->srcresult;
  GstMiniObject *data;

  data = gst_queue_locked_dequeue (queue);
  if (data == NULL)
    goto no_item;

next:
  if (GST_IS_BUFFER (data)) {
    GstBuffer *buffer;

    buffer = GST_BUFFER_CAST (data);

    if (queue->head_needs_discont) {
      GstBuffer *subbuffer = gst_buffer_make_writable (buffer);

      if (subbuffer) {
        buffer = subbuffer;
        GST_BUFFER_FLAG_SET (buffer, GST_BUFFER_FLAG_DISCONT);
      } else {
        GST_DEBUG_OBJECT (queue, "Could not mark buffer as DISCONT");
      }
      queue->head_needs_discont = FALSE;
    }

    GST_QUEUE_MUTEX_UNLOCK (queue);
    result = gst_pad_push (queue->srcpad, buffer);

    /* need to check for srcresult here as well */
    GST_QUEUE_MUTEX_LOCK_CHECK (queue, out_flushing);

    if (result == GST_FLOW_EOS) {
      GST_CAT_LOG_OBJECT (queue_dataflow, queue, "got EOS from downstream");
      /* stop pushing buffers, we dequeue all items until we see an item that we
       * can push again, which is EOS or SEGMENT. If there is nothing in the
       * queue we can push, we set a flag to make the sinkpad refuse more
       * buffers with an EOS return value. */
      while ((data = gst_queue_locked_dequeue (queue))) {
        if (GST_IS_BUFFER (data)) {
          GST_CAT_LOG_OBJECT (queue_dataflow, queue,
              "dropping EOS buffer %p", data);
          gst_buffer_unref (GST_BUFFER_CAST (data));
        } else if (GST_IS_EVENT (data)) {
          GstEvent *event = GST_EVENT_CAST (data);
          GstEventType type = GST_EVENT_TYPE (event);

          if (type == GST_EVENT_EOS || type == GST_EVENT_SEGMENT) {
            /* we found a pushable item in the queue, push it out */
            GST_CAT_LOG_OBJECT (queue_dataflow, queue,
                "pushing pushable event %s after EOS",
                GST_EVENT_TYPE_NAME (event));
            goto next;
          }
          GST_CAT_LOG_OBJECT (queue_dataflow, queue,
              "dropping EOS event %p", event);
          gst_event_unref (event);
        } else if (GST_IS_QUERY (data)) {
          GstQuery *query = GST_QUERY_CAST (data);

          GST_CAT_LOG_OBJECT (queue_dataflow, queue,
              "dropping query %p because of EOS", query);
          queue->last_query = FALSE;
          g_cond_signal (&queue->query_handled);
        }
      }
      /* no more items in the queue. Set the unexpected flag so that upstream
       * make us refuse any more buffers on the sinkpad. Since we will still
       * accept EOS and SEGMENT we return _FLOW_OK to the caller so that the
       * task function does not shut down. */
      queue->unexpected = TRUE;
      result = GST_FLOW_OK;
    }
  } else if (GST_IS_EVENT (data)) {
    GstEvent *event = GST_EVENT_CAST (data);
    GstEventType type = GST_EVENT_TYPE (event);

    GST_QUEUE_MUTEX_UNLOCK (queue);

    gst_pad_push_event (queue->srcpad, event);

    GST_QUEUE_MUTEX_LOCK_CHECK (queue, out_flushing);
    /* if we're EOS, return EOS so that the task pauses. */
    if (type == GST_EVENT_EOS) {
      GST_CAT_LOG_OBJECT (queue_dataflow, queue,
          "pushed EOS event %p, return EOS", event);
      result = GST_FLOW_EOS;
    }
  } else if (GST_IS_QUERY (data)) {
    GstQuery *query = GST_QUERY_CAST (data);
    gboolean ret;

    GST_QUEUE_MUTEX_UNLOCK (queue);
    ret = gst_pad_peer_query (queue->srcpad, query);
    GST_QUEUE_MUTEX_LOCK_CHECK (queue, out_flushing_query);
    queue->last_query = ret;
    g_cond_signal (&queue->query_handled);
    GST_CAT_LOG_OBJECT (queue_dataflow, queue,
        "did query %p, return %d", query, queue->last_query);
  }
  return result;

  /* ERRORS */
no_item:
  {
    GST_CAT_LOG_OBJECT (queue_dataflow, queue,
        "exit because we have no item in the queue");
    return GST_FLOW_ERROR;
  }
out_flushing:
  {
    GST_CAT_LOG_OBJECT (queue_dataflow, queue, "exit because we are flushing");
    return GST_FLOW_FLUSHING;
  }
out_flushing_query:
  {
    queue->last_query = FALSE;
    g_cond_signal (&queue->query_handled);
    GST_CAT_LOG_OBJECT (queue_dataflow, queue, "exit because we are flushing");
    return GST_FLOW_FLUSHING;
  }
}

static void
gst_queue_loop (GstPad * pad)
{
  GstQueue *queue;
  GstFlowReturn ret;

  queue = (GstQueue *) GST_PAD_PARENT (pad);

  /* have to lock for thread-safety */
  GST_QUEUE_MUTEX_LOCK_CHECK (queue, out_flushing);

  while (gst_queue_is_empty (queue)) {
    GST_CAT_DEBUG_OBJECT (queue_dataflow, queue, "queue is empty");
    if (!queue->silent) {
      GST_QUEUE_MUTEX_UNLOCK (queue);
      g_signal_emit (queue, gst_queue_signals[SIGNAL_UNDERRUN], 0);
      GST_QUEUE_MUTEX_LOCK_CHECK (queue, out_flushing);
    }

    /* we recheck, the signal could have changed the thresholds */
    while (gst_queue_is_empty (queue)) {
      GST_QUEUE_WAIT_ADD_CHECK (queue, out_flushing);
    }

    GST_CAT_DEBUG_OBJECT (queue_dataflow, queue, "queue is not empty");
    if (!queue->silent) {
      GST_QUEUE_MUTEX_UNLOCK (queue);
      g_signal_emit (queue, gst_queue_signals[SIGNAL_RUNNING], 0);
      g_signal_emit (queue, gst_queue_signals[SIGNAL_PUSHING], 0);
      GST_QUEUE_MUTEX_LOCK_CHECK (queue, out_flushing);
    }
  }

  ret = gst_queue_push_one (queue);
  queue->srcresult = ret;
  if (ret != GST_FLOW_OK)
    goto out_flushing;

  GST_QUEUE_MUTEX_UNLOCK (queue);

  return;

  /* ERRORS */
out_flushing:
  {
    gboolean eos = queue->eos;
    GstFlowReturn ret = queue->srcresult;

    gst_pad_pause_task (queue->srcpad);
    GST_CAT_LOG_OBJECT (queue_dataflow, queue,
        "pause task, reason:  %s", gst_flow_get_name (ret));
    if (ret == GST_FLOW_FLUSHING)
      gst_queue_locked_flush (queue, FALSE);
    else
      GST_QUEUE_SIGNAL_DEL (queue);
    GST_QUEUE_MUTEX_UNLOCK (queue);
    /* let app know about us giving up if upstream is not expected to do so */
    /* EOS is already taken care of elsewhere */
    if (eos && (ret == GST_FLOW_NOT_LINKED || ret < GST_FLOW_EOS)) {
      GST_ELEMENT_ERROR (queue, STREAM, FAILED,
          (_("Internal data flow error.")),
          ("streaming task paused, reason %s (%d)",
              gst_flow_get_name (ret), ret));
      gst_pad_push_event (queue->srcpad, gst_event_new_eos ());
    }
    return;
  }
}

static gboolean
gst_queue_handle_src_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  gboolean res = TRUE;
  GstQueue *queue = GST_QUEUE (parent);

#ifndef GST_DISABLE_GST_DEBUG
  GST_CAT_DEBUG_OBJECT (queue_dataflow, queue, "got event %p (%d)",
      event, GST_EVENT_TYPE (event));
#endif

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_RECONFIGURE:
      GST_QUEUE_MUTEX_LOCK (queue);
      if (queue->srcresult == GST_FLOW_NOT_LINKED) {
        /* when we got not linked, assume downstream is linked again now and we
         * can try to start pushing again */
        queue->srcresult = GST_FLOW_OK;
        gst_pad_start_task (pad, (GstTaskFunction) gst_queue_loop, pad, NULL);
      }
      GST_QUEUE_MUTEX_UNLOCK (queue);

      res = gst_pad_push_event (queue->sinkpad, event);
      break;
    default:
      res = gst_pad_event_default (pad, parent, event);
      break;
  }


  return res;
}

static gboolean
gst_queue_handle_src_query (GstPad * pad, GstObject * parent, GstQuery * query)
{
  GstQueue *queue = GST_QUEUE (parent);
  gboolean res;

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_SCHEDULING:{
      gst_query_add_scheduling_mode (query, GST_PAD_MODE_PUSH);
      res = TRUE;
      break;
    }
    default:
      res = gst_pad_query_default (pad, parent, query);
      break;
  }

  if (!res)
    return FALSE;

  /* Adjust peer response for data contained in queue */
  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_POSITION:
    {
      gint64 peer_pos;
      GstFormat format;

      /* get peer position */
      gst_query_parse_position (query, &format, &peer_pos);

      /* FIXME: this code assumes that there's no discont in the queue */
      switch (format) {
        case GST_FORMAT_BYTES:
          peer_pos -= queue->cur_level.bytes;
          break;
        case GST_FORMAT_TIME:
          peer_pos -= queue->cur_level.time;
          break;
        default:
          GST_DEBUG_OBJECT (queue, "Can't adjust query in %s format, don't "
              "know how to adjust value", gst_format_get_name (format));
          return TRUE;
      }
      /* set updated position */
      gst_query_set_position (query, format, peer_pos);
      break;
    }
    case GST_QUERY_LATENCY:
    {
      gboolean live;
      GstClockTime min, max;

      gst_query_parse_latency (query, &live, &min, &max);

      /* we can delay up to the limit of the queue in time. If we have no time
       * limit, the best thing we can do is to return an infinite delay. In
       * reality a better estimate would be the byte/buffer rate but that is not
       * possible right now. */
      if (queue->max_size.time > 0 && max != -1)
        max += queue->max_size.time;
      else
        max = -1;

      /* adjust for min-threshold */
      if (queue->min_threshold.time > 0 && min != -1)
        min += queue->min_threshold.time;

      gst_query_set_latency (query, live, min, max);
      break;
    }
    default:
      /* peer handled other queries */
      break;
  }

  return TRUE;
}

static gboolean
gst_queue_sink_activate_mode (GstPad * pad, GstObject * parent, GstPadMode mode,
    gboolean active)
{
  gboolean result;
  GstQueue *queue;

  queue = GST_QUEUE (parent);

  switch (mode) {
    case GST_PAD_MODE_PUSH:
      if (active) {
        GST_QUEUE_MUTEX_LOCK (queue);
        queue->srcresult = GST_FLOW_OK;
        queue->eos = FALSE;
        queue->unexpected = FALSE;
        GST_QUEUE_MUTEX_UNLOCK (queue);
      } else {
        /* step 1, unblock chain function */
        GST_QUEUE_MUTEX_LOCK (queue);
        queue->srcresult = GST_FLOW_FLUSHING;
        /* the item del signal will unblock */
        g_cond_signal (&queue->item_del);
        /* unblock query handler */
        queue->last_query = FALSE;
        g_cond_signal (&queue->query_handled);
        GST_QUEUE_MUTEX_UNLOCK (queue);

        /* step 2, wait until streaming thread stopped and flush queue */
        GST_PAD_STREAM_LOCK (pad);
        GST_QUEUE_MUTEX_LOCK (queue);
        gst_queue_locked_flush (queue, TRUE);
        GST_QUEUE_MUTEX_UNLOCK (queue);
        GST_PAD_STREAM_UNLOCK (pad);
      }
      result = TRUE;
      break;
    default:
      result = FALSE;
      break;
  }
  return result;
}

static gboolean
gst_queue_src_activate_mode (GstPad * pad, GstObject * parent, GstPadMode mode,
    gboolean active)
{
  gboolean result;
  GstQueue *queue;

  queue = GST_QUEUE (parent);

  switch (mode) {
    case GST_PAD_MODE_PUSH:
      if (active) {
        GST_QUEUE_MUTEX_LOCK (queue);
        queue->srcresult = GST_FLOW_OK;
        queue->eos = FALSE;
        queue->unexpected = FALSE;
        result =
            gst_pad_start_task (pad, (GstTaskFunction) gst_queue_loop, pad,
            NULL);
        GST_QUEUE_MUTEX_UNLOCK (queue);
      } else {
        /* step 1, unblock loop function */
        GST_QUEUE_MUTEX_LOCK (queue);
        queue->srcresult = GST_FLOW_FLUSHING;
        /* the item add signal will unblock */
        g_cond_signal (&queue->item_add);
        GST_QUEUE_MUTEX_UNLOCK (queue);

        /* step 2, make sure streaming finishes */
        result = gst_pad_stop_task (pad);
      }
      break;
    default:
      result = FALSE;
      break;
  }
  return result;
}

static void
queue_capacity_change (GstQueue * queue)
{
  if (queue->leaky == GST_QUEUE_LEAK_DOWNSTREAM) {
    gst_queue_leak_downstream (queue);
  }

  /* changing the capacity of the queue must wake up
   * the _chain function, it might have more room now
   * to store the buffer/event in the queue */
  GST_QUEUE_SIGNAL_DEL (queue);
}

/* Changing the minimum required fill level must
 * wake up the _loop function as it might now
 * be able to preceed.
 */
#define QUEUE_THRESHOLD_CHANGE(q)\
  GST_QUEUE_SIGNAL_ADD (q);

static void
gst_queue_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec)
{
  GstQueue *queue = GST_QUEUE (object);

  /* someone could change levels here, and since this
   * affects the get/put funcs, we need to lock for safety. */
  GST_QUEUE_MUTEX_LOCK (queue);

  switch (prop_id) {
    case PROP_MAX_SIZE_BYTES:
      queue->max_size.bytes = g_value_get_uint (value);
      queue_capacity_change (queue);
      break;
    case PROP_MAX_SIZE_BUFFERS:
      queue->max_size.buffers = g_value_get_uint (value);
      queue_capacity_change (queue);
      break;
    case PROP_MAX_SIZE_TIME:
      queue->max_size.time = g_value_get_uint64 (value);
      queue_capacity_change (queue);
      break;
    case PROP_MIN_THRESHOLD_BYTES:
      queue->min_threshold.bytes = g_value_get_uint (value);
      queue->orig_min_threshold.bytes = queue->min_threshold.bytes;
      QUEUE_THRESHOLD_CHANGE (queue);
      break;
    case PROP_MIN_THRESHOLD_BUFFERS:
      queue->min_threshold.buffers = g_value_get_uint (value);
      queue->orig_min_threshold.buffers = queue->min_threshold.buffers;
      QUEUE_THRESHOLD_CHANGE (queue);
      break;
    case PROP_MIN_THRESHOLD_TIME:
      queue->min_threshold.time = g_value_get_uint64 (value);
      queue->orig_min_threshold.time = queue->min_threshold.time;
      QUEUE_THRESHOLD_CHANGE (queue);
      break;
    case PROP_LEAKY:
      queue->leaky = g_value_get_enum (value);
      break;
    case PROP_SILENT:
      queue->silent = g_value_get_boolean (value);
      break;
    case PROP_FLUSH_ON_EOS:
      queue->flush_on_eos = g_value_get_boolean (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }

  GST_QUEUE_MUTEX_UNLOCK (queue);
}

static void
gst_queue_get_property (GObject * object,
    guint prop_id, GValue * value, GParamSpec * pspec)
{
  GstQueue *queue = GST_QUEUE (object);

  GST_QUEUE_MUTEX_LOCK (queue);

  switch (prop_id) {
    case PROP_CUR_LEVEL_BYTES:
      g_value_set_uint (value, queue->cur_level.bytes);
      break;
    case PROP_CUR_LEVEL_BUFFERS:
      g_value_set_uint (value, queue->cur_level.buffers);
      break;
    case PROP_CUR_LEVEL_TIME:
      g_value_set_uint64 (value, queue->cur_level.time);
      break;
    case PROP_MAX_SIZE_BYTES:
      g_value_set_uint (value, queue->max_size.bytes);
      break;
    case PROP_MAX_SIZE_BUFFERS:
      g_value_set_uint (value, queue->max_size.buffers);
      break;
    case PROP_MAX_SIZE_TIME:
      g_value_set_uint64 (value, queue->max_size.time);
      break;
    case PROP_MIN_THRESHOLD_BYTES:
      g_value_set_uint (value, queue->min_threshold.bytes);
      break;
    case PROP_MIN_THRESHOLD_BUFFERS:
      g_value_set_uint (value, queue->min_threshold.buffers);
      break;
    case PROP_MIN_THRESHOLD_TIME:
      g_value_set_uint64 (value, queue->min_threshold.time);
      break;
    case PROP_LEAKY:
      g_value_set_enum (value, queue->leaky);
      break;
    case PROP_SILENT:
      g_value_set_boolean (value, queue->silent);
      break;
    case PROP_FLUSH_ON_EOS:
      g_value_set_boolean (value, queue->flush_on_eos);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }

  GST_QUEUE_MUTEX_UNLOCK (queue);
}
