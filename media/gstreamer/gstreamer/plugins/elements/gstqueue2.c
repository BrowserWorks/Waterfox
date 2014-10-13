/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2003 Colin Walters <cwalters@gnome.org>
 *                    2000,2005,2007 Wim Taymans <wim.taymans@gmail.com>
 *                    2007 Thiago Sousa Santos <thiagoss@lcc.ufcg.edu.br>
 *                 SA 2010 ST-Ericsson <benjamin.gaignard@stericsson.com>
 *
 * gstqueue2.c:
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
 * SECTION:element-queue2
 *
 * Data is queued until one of the limits specified by the
 * #GstQueue2:max-size-buffers, #GstQueue2:max-size-bytes and/or
 * #GstQueue2:max-size-time properties has been reached. Any attempt to push
 * more buffers into the queue will block the pushing thread until more space
 * becomes available.
 *
 * The queue will create a new thread on the source pad to decouple the
 * processing on sink and source pad.
 *
 * You can query how many buffers are queued by reading the
 * #GstQueue2:current-level-buffers property.
 *
 * The default queue size limits are 100 buffers, 2MB of data, or
 * two seconds worth of data, whichever is reached first.
 *
 * If you set temp-template to a value such as /tmp/gstreamer-XXXXXX, the element
 * will allocate a random free filename and buffer data in the file.
 * By using this, it will buffer the entire stream data on the file independently
 * of the queue size limits, they will only be used for buffering statistics.
 *
 * The temp-location property will be used to notify the application of the
 * allocated filename.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gstqueue2.h"

#include <glib/gstdio.h>

#include "gst/gst-i18n-lib.h"
#include "gst/glib-compat-private.h"

#include <string.h>

#ifdef G_OS_WIN32
#include <io.h>                 /* lseek, open, close, read */
#undef lseek
#define lseek _lseeki64
#undef off_t
#define off_t guint64
#else
#include <unistd.h>
#endif

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

enum
{
  LAST_SIGNAL
};

/* other defines */
#define DEFAULT_BUFFER_SIZE 4096
#define QUEUE_IS_USING_TEMP_FILE(queue) ((queue)->temp_template != NULL)
#define QUEUE_IS_USING_RING_BUFFER(queue) ((queue)->ring_buffer_max_size != 0)  /* for consistency with the above macro */
#define QUEUE_IS_USING_QUEUE(queue) (!QUEUE_IS_USING_TEMP_FILE(queue) && !QUEUE_IS_USING_RING_BUFFER (queue))

#define QUEUE_MAX_BYTES(queue) MIN((queue)->max_level.bytes, (queue)->ring_buffer_max_size)

/* default property values */
#define DEFAULT_MAX_SIZE_BUFFERS   100  /* 100 buffers */
#define DEFAULT_MAX_SIZE_BYTES     (2 * 1024 * 1024)    /* 2 MB */
#define DEFAULT_MAX_SIZE_TIME      2 * GST_SECOND       /* 2 seconds */
#define DEFAULT_USE_BUFFERING      FALSE
#define DEFAULT_USE_RATE_ESTIMATE  TRUE
#define DEFAULT_LOW_PERCENT        10
#define DEFAULT_HIGH_PERCENT       99
#define DEFAULT_TEMP_REMOVE        TRUE
#define DEFAULT_RING_BUFFER_MAX_SIZE 0

enum
{
  PROP_0,
  PROP_CUR_LEVEL_BUFFERS,
  PROP_CUR_LEVEL_BYTES,
  PROP_CUR_LEVEL_TIME,
  PROP_MAX_SIZE_BUFFERS,
  PROP_MAX_SIZE_BYTES,
  PROP_MAX_SIZE_TIME,
  PROP_USE_BUFFERING,
  PROP_USE_RATE_ESTIMATE,
  PROP_LOW_PERCENT,
  PROP_HIGH_PERCENT,
  PROP_TEMP_TEMPLATE,
  PROP_TEMP_LOCATION,
  PROP_TEMP_REMOVE,
  PROP_RING_BUFFER_MAX_SIZE,
  PROP_LAST
};

#define GST_QUEUE2_CLEAR_LEVEL(l) G_STMT_START {         \
  l.buffers = 0;                                        \
  l.bytes = 0;                                          \
  l.time = 0;                                           \
  l.rate_time = 0;                                      \
} G_STMT_END

#define STATUS(queue, pad, msg) \
  GST_CAT_LOG_OBJECT (queue_dataflow, queue, \
                      "(%s:%s) " msg ": %u of %u buffers, %u of %u " \
                      "bytes, %" G_GUINT64_FORMAT " of %" G_GUINT64_FORMAT \
                      " ns, %"G_GUINT64_FORMAT" items", \
                      GST_DEBUG_PAD_NAME (pad), \
                      queue->cur_level.buffers, \
                      queue->max_level.buffers, \
                      queue->cur_level.bytes, \
                      queue->max_level.bytes, \
                      queue->cur_level.time, \
                      queue->max_level.time, \
                      (guint64) (!QUEUE_IS_USING_QUEUE(queue) ? \
                        queue->current->writing_pos - queue->current->max_reading_pos : \
                        queue->queue.length))

#define GST_QUEUE2_MUTEX_LOCK(q) G_STMT_START {                          \
  g_mutex_lock (&q->qlock);                                              \
} G_STMT_END

#define GST_QUEUE2_MUTEX_LOCK_CHECK(q,res,label) G_STMT_START {         \
  GST_QUEUE2_MUTEX_LOCK (q);                                            \
  if (res != GST_FLOW_OK)                                               \
    goto label;                                                         \
} G_STMT_END

#define GST_QUEUE2_MUTEX_UNLOCK(q) G_STMT_START {                        \
  g_mutex_unlock (&q->qlock);                                            \
} G_STMT_END

#define GST_QUEUE2_WAIT_DEL_CHECK(q, res, label) G_STMT_START {         \
  STATUS (queue, q->sinkpad, "wait for DEL");                           \
  q->waiting_del = TRUE;                                                \
  g_cond_wait (&q->item_del, &queue->qlock);                              \
  q->waiting_del = FALSE;                                               \
  if (res != GST_FLOW_OK) {                                             \
    STATUS (queue, q->srcpad, "received DEL wakeup");                   \
    goto label;                                                         \
  }                                                                     \
  STATUS (queue, q->sinkpad, "received DEL");                           \
} G_STMT_END

#define GST_QUEUE2_WAIT_ADD_CHECK(q, res, label) G_STMT_START {         \
  STATUS (queue, q->srcpad, "wait for ADD");                            \
  q->waiting_add = TRUE;                                                \
  g_cond_wait (&q->item_add, &q->qlock);                                  \
  q->waiting_add = FALSE;                                               \
  if (res != GST_FLOW_OK) {                                             \
    STATUS (queue, q->srcpad, "received ADD wakeup");                   \
    goto label;                                                         \
  }                                                                     \
  STATUS (queue, q->srcpad, "received ADD");                            \
} G_STMT_END

#define GST_QUEUE2_SIGNAL_DEL(q) G_STMT_START {                          \
  if (q->waiting_del) {                                                 \
    STATUS (q, q->srcpad, "signal DEL");                                \
    g_cond_signal (&q->item_del);                                        \
  }                                                                     \
} G_STMT_END

#define GST_QUEUE2_SIGNAL_ADD(q) G_STMT_START {                          \
  if (q->waiting_add) {                                                 \
    STATUS (q, q->sinkpad, "signal ADD");                               \
    g_cond_signal (&q->item_add);                                        \
  }                                                                     \
} G_STMT_END

#define _do_init \
    GST_DEBUG_CATEGORY_INIT (queue_debug, "queue2", 0, "queue element"); \
    GST_DEBUG_CATEGORY_INIT (queue_dataflow, "queue2_dataflow", 0, \
        "dataflow inside the queue element");
#define gst_queue2_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstQueue2, gst_queue2, GST_TYPE_ELEMENT, _do_init);

static void gst_queue2_finalize (GObject * object);

static void gst_queue2_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec);
static void gst_queue2_get_property (GObject * object,
    guint prop_id, GValue * value, GParamSpec * pspec);

static GstFlowReturn gst_queue2_chain (GstPad * pad, GstObject * parent,
    GstBuffer * buffer);
static GstFlowReturn gst_queue2_chain_list (GstPad * pad, GstObject * parent,
    GstBufferList * buffer_list);
static GstFlowReturn gst_queue2_push_one (GstQueue2 * queue);
static void gst_queue2_loop (GstPad * pad);

static gboolean gst_queue2_handle_sink_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static gboolean gst_queue2_handle_sink_query (GstPad * pad, GstObject * parent,
    GstQuery * query);

static gboolean gst_queue2_handle_src_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static gboolean gst_queue2_handle_src_query (GstPad * pad, GstObject * parent,
    GstQuery * query);
static gboolean gst_queue2_handle_query (GstElement * element,
    GstQuery * query);

static GstFlowReturn gst_queue2_get_range (GstPad * pad, GstObject * parent,
    guint64 offset, guint length, GstBuffer ** buffer);

static gboolean gst_queue2_src_activate_mode (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active);
static gboolean gst_queue2_sink_activate_mode (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active);
static GstStateChangeReturn gst_queue2_change_state (GstElement * element,
    GstStateChange transition);

static gboolean gst_queue2_is_empty (GstQueue2 * queue);
static gboolean gst_queue2_is_filled (GstQueue2 * queue);

static void update_cur_level (GstQueue2 * queue, GstQueue2Range * range);
static void update_in_rates (GstQueue2 * queue);

typedef enum
{
  GST_QUEUE2_ITEM_TYPE_UNKNOWN = 0,
  GST_QUEUE2_ITEM_TYPE_BUFFER,
  GST_QUEUE2_ITEM_TYPE_BUFFER_LIST,
  GST_QUEUE2_ITEM_TYPE_EVENT,
  GST_QUEUE2_ITEM_TYPE_QUERY
} GstQueue2ItemType;

typedef struct
{
  GstQueue2ItemType type;
  GstMiniObject *item;
} GstQueue2Item;

/* static guint gst_queue2_signals[LAST_SIGNAL] = { 0 }; */

static void
gst_queue2_class_init (GstQueue2Class * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);
  GstElementClass *gstelement_class = GST_ELEMENT_CLASS (klass);

  gobject_class->set_property = gst_queue2_set_property;
  gobject_class->get_property = gst_queue2_get_property;

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

  g_object_class_install_property (gobject_class, PROP_USE_BUFFERING,
      g_param_spec_boolean ("use-buffering", "Use buffering",
          "Emit GST_MESSAGE_BUFFERING based on low-/high-percent thresholds",
          DEFAULT_USE_BUFFERING, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_USE_RATE_ESTIMATE,
      g_param_spec_boolean ("use-rate-estimate", "Use Rate Estimate",
          "Estimate the bitrate of the stream to calculate time level",
          DEFAULT_USE_RATE_ESTIMATE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_LOW_PERCENT,
      g_param_spec_int ("low-percent", "Low percent",
          "Low threshold for buffering to start. Only used if use-buffering is True",
          0, 100, DEFAULT_LOW_PERCENT,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_HIGH_PERCENT,
      g_param_spec_int ("high-percent", "High percent",
          "High threshold for buffering to finish. Only used if use-buffering is True",
          0, 100, DEFAULT_HIGH_PERCENT,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_TEMP_TEMPLATE,
      g_param_spec_string ("temp-template", "Temporary File Template",
          "File template to store temporary files in, should contain directory "
          "and XXXXXX. (NULL == disabled)",
          NULL, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_TEMP_LOCATION,
      g_param_spec_string ("temp-location", "Temporary File Location",
          "Location to store temporary files in (Only read this property, "
          "use temp-template to configure the name template)",
          NULL, G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));

  /**
   * GstQueue2:temp-remove
   *
   * When temp-template is set, remove the temporary file when going to READY.
   */
  g_object_class_install_property (gobject_class, PROP_TEMP_REMOVE,
      g_param_spec_boolean ("temp-remove", "Remove the Temporary File",
          "Remove the temp-location after use",
          DEFAULT_TEMP_REMOVE, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstQueue2:ring-buffer-max-size
   *
   * The maximum size of the ring buffer in bytes. If set to 0, the ring
   * buffer is disabled. Default 0.
   */
  g_object_class_install_property (gobject_class, PROP_RING_BUFFER_MAX_SIZE,
      g_param_spec_uint64 ("ring-buffer-max-size",
          "Max. ring buffer size (bytes)",
          "Max. amount of data in the ring buffer (bytes, 0 = disabled)",
          0, G_MAXUINT64, DEFAULT_RING_BUFFER_MAX_SIZE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /* set several parent class virtual functions */
  gobject_class->finalize = gst_queue2_finalize;

  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&srctemplate));
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&sinktemplate));

  gst_element_class_set_static_metadata (gstelement_class, "Queue 2",
      "Generic",
      "Simple data queue",
      "Erik Walthinsen <omega@cse.ogi.edu>, "
      "Wim Taymans <wim.taymans@gmail.com>");

  gstelement_class->change_state = GST_DEBUG_FUNCPTR (gst_queue2_change_state);
  gstelement_class->query = GST_DEBUG_FUNCPTR (gst_queue2_handle_query);
}

static void
gst_queue2_init (GstQueue2 * queue)
{
  queue->sinkpad = gst_pad_new_from_static_template (&sinktemplate, "sink");

  gst_pad_set_chain_function (queue->sinkpad,
      GST_DEBUG_FUNCPTR (gst_queue2_chain));
  gst_pad_set_chain_list_function (queue->sinkpad,
      GST_DEBUG_FUNCPTR (gst_queue2_chain_list));
  gst_pad_set_activatemode_function (queue->sinkpad,
      GST_DEBUG_FUNCPTR (gst_queue2_sink_activate_mode));
  gst_pad_set_event_function (queue->sinkpad,
      GST_DEBUG_FUNCPTR (gst_queue2_handle_sink_event));
  gst_pad_set_query_function (queue->sinkpad,
      GST_DEBUG_FUNCPTR (gst_queue2_handle_sink_query));
  GST_PAD_SET_PROXY_CAPS (queue->sinkpad);
  gst_element_add_pad (GST_ELEMENT (queue), queue->sinkpad);

  queue->srcpad = gst_pad_new_from_static_template (&srctemplate, "src");

  gst_pad_set_activatemode_function (queue->srcpad,
      GST_DEBUG_FUNCPTR (gst_queue2_src_activate_mode));
  gst_pad_set_getrange_function (queue->srcpad,
      GST_DEBUG_FUNCPTR (gst_queue2_get_range));
  gst_pad_set_event_function (queue->srcpad,
      GST_DEBUG_FUNCPTR (gst_queue2_handle_src_event));
  gst_pad_set_query_function (queue->srcpad,
      GST_DEBUG_FUNCPTR (gst_queue2_handle_src_query));
  GST_PAD_SET_PROXY_CAPS (queue->srcpad);
  gst_element_add_pad (GST_ELEMENT (queue), queue->srcpad);

  /* levels */
  GST_QUEUE2_CLEAR_LEVEL (queue->cur_level);
  queue->max_level.buffers = DEFAULT_MAX_SIZE_BUFFERS;
  queue->max_level.bytes = DEFAULT_MAX_SIZE_BYTES;
  queue->max_level.time = DEFAULT_MAX_SIZE_TIME;
  queue->max_level.rate_time = DEFAULT_MAX_SIZE_TIME;
  queue->use_buffering = DEFAULT_USE_BUFFERING;
  queue->use_rate_estimate = DEFAULT_USE_RATE_ESTIMATE;
  queue->low_percent = DEFAULT_LOW_PERCENT;
  queue->high_percent = DEFAULT_HIGH_PERCENT;

  gst_segment_init (&queue->sink_segment, GST_FORMAT_TIME);
  gst_segment_init (&queue->src_segment, GST_FORMAT_TIME);

  queue->sinktime = GST_CLOCK_TIME_NONE;
  queue->srctime = GST_CLOCK_TIME_NONE;
  queue->sink_tainted = TRUE;
  queue->src_tainted = TRUE;

  queue->srcresult = GST_FLOW_FLUSHING;
  queue->sinkresult = GST_FLOW_FLUSHING;
  queue->is_eos = FALSE;
  queue->in_timer = g_timer_new ();
  queue->out_timer = g_timer_new ();

  g_mutex_init (&queue->qlock);
  queue->waiting_add = FALSE;
  g_cond_init (&queue->item_add);
  queue->waiting_del = FALSE;
  g_cond_init (&queue->item_del);
  g_queue_init (&queue->queue);

  g_cond_init (&queue->query_handled);
  queue->last_query = FALSE;

  queue->buffering_percent = 100;

  /* tempfile related */
  queue->temp_template = NULL;
  queue->temp_location = NULL;
  queue->temp_remove = DEFAULT_TEMP_REMOVE;

  queue->ring_buffer = NULL;
  queue->ring_buffer_max_size = DEFAULT_RING_BUFFER_MAX_SIZE;

  GST_DEBUG_OBJECT (queue,
      "initialized queue's not_empty & not_full conditions");
}

/* called only once, as opposed to dispose */
static void
gst_queue2_finalize (GObject * object)
{
  GstQueue2 *queue = GST_QUEUE2 (object);

  GST_DEBUG_OBJECT (queue, "finalizing queue");

  while (!g_queue_is_empty (&queue->queue)) {
    GstQueue2Item *qitem = g_queue_pop_head (&queue->queue);

    if (qitem->type != GST_QUEUE2_ITEM_TYPE_QUERY)
      gst_mini_object_unref (qitem->item);
    g_slice_free (GstQueue2Item, qitem);
  }

  queue->last_query = FALSE;
  g_queue_clear (&queue->queue);
  g_mutex_clear (&queue->qlock);
  g_cond_clear (&queue->item_add);
  g_cond_clear (&queue->item_del);
  g_cond_clear (&queue->query_handled);
  g_timer_destroy (queue->in_timer);
  g_timer_destroy (queue->out_timer);

  /* temp_file path cleanup  */
  g_free (queue->temp_template);
  g_free (queue->temp_location);

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

static void
debug_ranges (GstQueue2 * queue)
{
  GstQueue2Range *walk;

  for (walk = queue->ranges; walk; walk = walk->next) {
    GST_DEBUG_OBJECT (queue,
        "range [%" G_GUINT64_FORMAT "-%" G_GUINT64_FORMAT "] (rb [%"
        G_GUINT64_FORMAT "-%" G_GUINT64_FORMAT "]), reading %" G_GUINT64_FORMAT
        " current range? %s", walk->offset, walk->writing_pos, walk->rb_offset,
        walk->rb_writing_pos, walk->reading_pos,
        walk == queue->current ? "**y**" : "  n  ");
  }
}

/* clear all the downloaded ranges */
static void
clean_ranges (GstQueue2 * queue)
{
  GST_DEBUG_OBJECT (queue, "clean queue ranges");

  g_slice_free_chain (GstQueue2Range, queue->ranges, next);
  queue->ranges = NULL;
  queue->current = NULL;
}

/* find a range that contains @offset or NULL when nothing does */
static GstQueue2Range *
find_range (GstQueue2 * queue, guint64 offset)
{
  GstQueue2Range *range = NULL;
  GstQueue2Range *walk;

  /* first do a quick check for the current range */
  for (walk = queue->ranges; walk; walk = walk->next) {
    if (offset >= walk->offset && offset <= walk->writing_pos) {
      /* we can reuse an existing range */
      range = walk;
      break;
    }
  }
  if (range) {
    GST_DEBUG_OBJECT (queue,
        "found range for %" G_GUINT64_FORMAT ": [%" G_GUINT64_FORMAT "-%"
        G_GUINT64_FORMAT "]", offset, range->offset, range->writing_pos);
  } else {
    GST_DEBUG_OBJECT (queue, "no range for %" G_GUINT64_FORMAT, offset);
  }
  return range;
}

static void
update_cur_level (GstQueue2 * queue, GstQueue2Range * range)
{
  guint64 max_reading_pos, writing_pos;

  writing_pos = range->writing_pos;
  max_reading_pos = range->max_reading_pos;

  if (writing_pos > max_reading_pos)
    queue->cur_level.bytes = writing_pos - max_reading_pos;
  else
    queue->cur_level.bytes = 0;
}

/* make a new range for @offset or reuse an existing range */
static GstQueue2Range *
add_range (GstQueue2 * queue, guint64 offset, gboolean update_existing)
{
  GstQueue2Range *range, *prev, *next;

  GST_DEBUG_OBJECT (queue, "find range for %" G_GUINT64_FORMAT, offset);

  if ((range = find_range (queue, offset))) {
    GST_DEBUG_OBJECT (queue,
        "reusing range %" G_GUINT64_FORMAT "-%" G_GUINT64_FORMAT, range->offset,
        range->writing_pos);
    if (update_existing && range->writing_pos != offset) {
      GST_DEBUG_OBJECT (queue, "updating range writing position to "
          "%" G_GUINT64_FORMAT, offset);
      range->writing_pos = offset;
    }
  } else {
    GST_DEBUG_OBJECT (queue,
        "new range %" G_GUINT64_FORMAT "-%" G_GUINT64_FORMAT, offset, offset);

    range = g_slice_new0 (GstQueue2Range);
    range->offset = offset;
    /* we want to write to the next location in the ring buffer */
    range->rb_offset = queue->current ? queue->current->rb_writing_pos : 0;
    range->writing_pos = offset;
    range->rb_writing_pos = range->rb_offset;
    range->reading_pos = offset;
    range->max_reading_pos = offset;

    /* insert sorted */
    prev = NULL;
    next = queue->ranges;
    while (next) {
      if (next->offset > offset) {
        /* insert before next */
        GST_DEBUG_OBJECT (queue,
            "insert before range %p, offset %" G_GUINT64_FORMAT, next,
            next->offset);
        break;
      }
      /* try next */
      prev = next;
      next = next->next;
    }
    range->next = next;
    if (prev)
      prev->next = range;
    else
      queue->ranges = range;
  }
  debug_ranges (queue);

  /* update the stats for this range */
  update_cur_level (queue, range);

  return range;
}


/* clear and init the download ranges for offset 0 */
static void
init_ranges (GstQueue2 * queue)
{
  GST_DEBUG_OBJECT (queue, "init queue ranges");

  /* get rid of all the current ranges */
  clean_ranges (queue);
  /* make a range for offset 0 */
  queue->current = add_range (queue, 0, TRUE);
}

/* calculate the diff between running time on the sink and src of the queue.
 * This is the total amount of time in the queue. */
static void
update_time_level (GstQueue2 * queue)
{
  if (queue->sink_tainted) {
    queue->sinktime =
        gst_segment_to_running_time (&queue->sink_segment, GST_FORMAT_TIME,
        queue->sink_segment.position);
    queue->sink_tainted = FALSE;
  }

  if (queue->src_tainted) {
    queue->srctime =
        gst_segment_to_running_time (&queue->src_segment, GST_FORMAT_TIME,
        queue->src_segment.position);
    queue->src_tainted = FALSE;
  }

  GST_DEBUG_OBJECT (queue, "sink %" GST_TIME_FORMAT ", src %" GST_TIME_FORMAT,
      GST_TIME_ARGS (queue->sinktime), GST_TIME_ARGS (queue->srctime));

  if (queue->sinktime != GST_CLOCK_TIME_NONE
      && queue->srctime != GST_CLOCK_TIME_NONE
      && queue->sinktime >= queue->srctime)
    queue->cur_level.time = queue->sinktime - queue->srctime;
  else
    queue->cur_level.time = 0;
}

/* take a SEGMENT event and apply the values to segment, updating the time
 * level of queue. */
static void
apply_segment (GstQueue2 * queue, GstEvent * event, GstSegment * segment,
    gboolean is_sink)
{
  gst_event_copy_segment (event, segment);

  if (segment->format == GST_FORMAT_BYTES) {
    if (!QUEUE_IS_USING_QUEUE (queue) && is_sink) {
      /* start is where we'll be getting from and as such writing next */
      queue->current = add_range (queue, segment->start, TRUE);
    }
  }

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

  GST_DEBUG_OBJECT (queue, "configured SEGMENT %" GST_SEGMENT_FORMAT, segment);

  if (is_sink)
    queue->sink_tainted = TRUE;
  else
    queue->src_tainted = TRUE;

  /* segment can update the time level of the queue */
  update_time_level (queue);
}

/* take a buffer and update segment, updating the time level of the queue. */
static void
apply_buffer (GstQueue2 * queue, GstBuffer * buffer, GstSegment * segment,
    gboolean is_sink)
{
  GstClockTime duration, timestamp;

  timestamp = GST_BUFFER_TIMESTAMP (buffer);
  duration = GST_BUFFER_DURATION (buffer);

  /* if no timestamp is set, assume it's continuous with the previous
   * time */
  if (timestamp == GST_CLOCK_TIME_NONE)
    timestamp = segment->position;

  /* add duration */
  if (duration != GST_CLOCK_TIME_NONE)
    timestamp += duration;

  GST_DEBUG_OBJECT (queue, "position updated to %" GST_TIME_FORMAT,
      GST_TIME_ARGS (timestamp));

  segment->position = timestamp;

  if (is_sink)
    queue->sink_tainted = TRUE;
  else
    queue->src_tainted = TRUE;

  /* calc diff with other end */
  update_time_level (queue);
}

static gboolean
buffer_list_apply_time (GstBuffer ** buf, guint idx, gpointer data)
{
  GstClockTime *timestamp = data;

  GST_TRACE ("buffer %u has ts %" GST_TIME_FORMAT
      " duration %" GST_TIME_FORMAT, idx,
      GST_TIME_ARGS (GST_BUFFER_TIMESTAMP (*buf)),
      GST_TIME_ARGS (GST_BUFFER_DURATION (*buf)));

  if (GST_BUFFER_TIMESTAMP_IS_VALID (*buf))
    *timestamp = GST_BUFFER_TIMESTAMP (*buf);

  if (GST_BUFFER_DURATION_IS_VALID (*buf))
    *timestamp += GST_BUFFER_DURATION (*buf);

  GST_TRACE ("ts now %" GST_TIME_FORMAT, GST_TIME_ARGS (*timestamp));
  return TRUE;
}

/* take a buffer list and update segment, updating the time level of the queue */
static void
apply_buffer_list (GstQueue2 * queue, GstBufferList * buffer_list,
    GstSegment * segment, gboolean is_sink)
{
  GstClockTime timestamp;

  /* if no timestamp is set, assume it's continuous with the previous time */
  timestamp = segment->position;

  gst_buffer_list_foreach (buffer_list, buffer_list_apply_time, &timestamp);

  GST_DEBUG_OBJECT (queue, "last_stop updated to %" GST_TIME_FORMAT,
      GST_TIME_ARGS (timestamp));

  segment->position = timestamp;

  if (is_sink)
    queue->sink_tainted = TRUE;
  else
    queue->src_tainted = TRUE;

  /* calc diff with other end */
  update_time_level (queue);
}

static gboolean
get_buffering_percent (GstQueue2 * queue, gboolean * is_buffering,
    gint * percent)
{
  gint perc;

  if (queue->high_percent <= 0) {
    if (percent)
      *percent = 100;
    if (is_buffering)
      *is_buffering = FALSE;
    return FALSE;
  }
#define GET_PERCENT(format,alt_max) ((queue->max_level.format) > 0 ? (queue->cur_level.format) * 100 / ((alt_max) > 0 ? MIN ((alt_max), (queue->max_level.format)) : (queue->max_level.format)) : 0)

  if (queue->is_eos) {
    /* on EOS we are always 100% full, we set the var here so that it we can
     * reuse the logic below to stop buffering */
    perc = 100;
    GST_LOG_OBJECT (queue, "we are EOS");
  } else {
    /* figure out the percent we are filled, we take the max of all formats. */
    if (!QUEUE_IS_USING_RING_BUFFER (queue)) {
      perc = GET_PERCENT (bytes, 0);
    } else {
      guint64 rb_size = queue->ring_buffer_max_size;
      perc = GET_PERCENT (bytes, rb_size);
    }
    perc = MAX (perc, GET_PERCENT (time, 0));
    perc = MAX (perc, GET_PERCENT (buffers, 0));

    /* also apply the rate estimate when we need to */
    if (queue->use_rate_estimate)
      perc = MAX (perc, GET_PERCENT (rate_time, 0));
  }
#undef GET_PERCENT

  if (is_buffering)
    *is_buffering = queue->is_buffering;

  /* scale to high percent so that it becomes the 100% mark */
  perc = perc * 100 / queue->high_percent;
  /* clip */
  if (perc > 100)
    perc = 100;

  if (percent)
    *percent = perc;

  GST_DEBUG_OBJECT (queue, "buffering %d, percent %d", queue->is_buffering,
      perc);

  return TRUE;
}

static void
get_buffering_stats (GstQueue2 * queue, gint percent, GstBufferingMode * mode,
    gint * avg_in, gint * avg_out, gint64 * buffering_left)
{
  if (mode) {
    if (!QUEUE_IS_USING_QUEUE (queue)) {
      if (QUEUE_IS_USING_RING_BUFFER (queue))
        *mode = GST_BUFFERING_TIMESHIFT;
      else
        *mode = GST_BUFFERING_DOWNLOAD;
    } else {
      *mode = GST_BUFFERING_STREAM;
    }
  }

  if (avg_in)
    *avg_in = queue->byte_in_rate;
  if (avg_out)
    *avg_out = queue->byte_out_rate;

  if (buffering_left) {
    *buffering_left = (percent == 100 ? 0 : -1);

    if (queue->use_rate_estimate) {
      guint64 max, cur;

      max = queue->max_level.rate_time;
      cur = queue->cur_level.rate_time;

      if (percent != 100 && max > cur)
        *buffering_left = (max - cur) / 1000000;
    }
  }
}

static void
update_buffering (GstQueue2 * queue)
{
  gint percent;
  gboolean post = FALSE;

  /* Ensure the variables used to calculate buffering state are up-to-date. */
  if (queue->current)
    update_cur_level (queue, queue->current);
  update_in_rates (queue);

  if (!get_buffering_percent (queue, NULL, &percent))
    return;

  if (queue->is_buffering) {
    post = TRUE;
    /* if we were buffering see if we reached the high watermark */
    if (percent >= queue->high_percent)
      queue->is_buffering = FALSE;
  } else {
    /* we were not buffering, check if we need to start buffering if we drop
     * below the low threshold */
    if (percent < queue->low_percent) {
      queue->is_buffering = TRUE;
      post = TRUE;
    }
  }

  if (post) {
    if (percent == queue->buffering_percent)
      post = FALSE;
    else
      queue->buffering_percent = percent;
  }

  if (post) {
    GstMessage *message;
    GstBufferingMode mode;
    gint avg_in, avg_out;
    gint64 buffering_left;

    get_buffering_stats (queue, percent, &mode, &avg_in, &avg_out,
        &buffering_left);

    message = gst_message_new_buffering (GST_OBJECT_CAST (queue),
        (gint) percent);
    gst_message_set_buffering_stats (message, mode,
        avg_in, avg_out, buffering_left);

    gst_element_post_message (GST_ELEMENT_CAST (queue), message);
  }
}

static void
reset_rate_timer (GstQueue2 * queue)
{
  queue->bytes_in = 0;
  queue->bytes_out = 0;
  queue->byte_in_rate = 0.0;
  queue->byte_in_period = 0;
  queue->byte_out_rate = 0.0;
  queue->last_in_elapsed = 0.0;
  queue->last_out_elapsed = 0.0;
  queue->in_timer_started = FALSE;
  queue->out_timer_started = FALSE;
}

/* the interval in seconds to recalculate the rate */
#define RATE_INTERVAL    0.2
/* Tuning for rate estimation. We use a large window for the input rate because
 * it should be stable when connected to a network. The output rate is less
 * stable (the elements preroll, queues behind a demuxer fill, ...) and should
 * therefore adapt more quickly.
 * However, initial input rate may be subject to a burst, and should therefore
 * initially also adapt more quickly to changes, and only later on give higher
 * weight to previous values. */
#define AVG_IN(avg,val,w1,w2)  ((avg) * (w1) + (val) * (w2)) / ((w1) + (w2))
#define AVG_OUT(avg,val) ((avg) * 3.0 + (val)) / 4.0

static void
update_in_rates (GstQueue2 * queue)
{
  gdouble elapsed, period;
  gdouble byte_in_rate;

  if (!queue->in_timer_started) {
    queue->in_timer_started = TRUE;
    g_timer_start (queue->in_timer);
    return;
  }

  elapsed = g_timer_elapsed (queue->in_timer, NULL);

  /* recalc after each interval. */
  if (queue->last_in_elapsed + RATE_INTERVAL < elapsed) {
    period = elapsed - queue->last_in_elapsed;

    GST_DEBUG_OBJECT (queue,
        "rates: period %f, in %" G_GUINT64_FORMAT ", global period %f",
        period, queue->bytes_in, queue->byte_in_period);

    byte_in_rate = queue->bytes_in / period;

    if (queue->byte_in_rate == 0.0)
      queue->byte_in_rate = byte_in_rate;
    else
      queue->byte_in_rate = AVG_IN (queue->byte_in_rate, byte_in_rate,
          (double) queue->byte_in_period, period);

    /* another data point, cap at 16 for long time running average */
    if (queue->byte_in_period < 16 * RATE_INTERVAL)
      queue->byte_in_period += period;

    /* reset the values to calculate rate over the next interval */
    queue->last_in_elapsed = elapsed;
    queue->bytes_in = 0;
  }

  if (queue->byte_in_rate > 0.0) {
    queue->cur_level.rate_time =
        queue->cur_level.bytes / queue->byte_in_rate * GST_SECOND;
  }
  GST_DEBUG_OBJECT (queue, "rates: in %f, time %" GST_TIME_FORMAT,
      queue->byte_in_rate, GST_TIME_ARGS (queue->cur_level.rate_time));
}

static void
update_out_rates (GstQueue2 * queue)
{
  gdouble elapsed, period;
  gdouble byte_out_rate;

  if (!queue->out_timer_started) {
    queue->out_timer_started = TRUE;
    g_timer_start (queue->out_timer);
    return;
  }

  elapsed = g_timer_elapsed (queue->out_timer, NULL);

  /* recalc after each interval. */
  if (queue->last_out_elapsed + RATE_INTERVAL < elapsed) {
    period = elapsed - queue->last_out_elapsed;

    GST_DEBUG_OBJECT (queue,
        "rates: period %f, out %" G_GUINT64_FORMAT, period, queue->bytes_out);

    byte_out_rate = queue->bytes_out / period;

    if (queue->byte_out_rate == 0.0)
      queue->byte_out_rate = byte_out_rate;
    else
      queue->byte_out_rate = AVG_OUT (queue->byte_out_rate, byte_out_rate);

    /* reset the values to calculate rate over the next interval */
    queue->last_out_elapsed = elapsed;
    queue->bytes_out = 0;
  }
  if (queue->byte_in_rate > 0.0) {
    queue->cur_level.rate_time =
        queue->cur_level.bytes / queue->byte_in_rate * GST_SECOND;
  }
  GST_DEBUG_OBJECT (queue, "rates: out %f, time %" GST_TIME_FORMAT,
      queue->byte_out_rate, GST_TIME_ARGS (queue->cur_level.rate_time));
}

static void
update_cur_pos (GstQueue2 * queue, GstQueue2Range * range, guint64 pos)
{
  guint64 reading_pos, max_reading_pos;

  reading_pos = pos;
  max_reading_pos = range->max_reading_pos;

  max_reading_pos = MAX (max_reading_pos, reading_pos);

  GST_DEBUG_OBJECT (queue,
      "updating max_reading_pos from %" G_GUINT64_FORMAT " to %"
      G_GUINT64_FORMAT, range->max_reading_pos, max_reading_pos);
  range->max_reading_pos = max_reading_pos;

  update_cur_level (queue, range);
}

static gboolean
perform_seek_to_offset (GstQueue2 * queue, guint64 offset)
{
  GstEvent *event;
  gboolean res;

  /* until we receive the FLUSH_STOP from this seek, we skip data */
  queue->seeking = TRUE;
  GST_QUEUE2_MUTEX_UNLOCK (queue);

  debug_ranges (queue);

  GST_DEBUG_OBJECT (queue, "Seeking to %" G_GUINT64_FORMAT, offset);

  event =
      gst_event_new_seek (1.0, GST_FORMAT_BYTES,
      GST_SEEK_FLAG_FLUSH | GST_SEEK_FLAG_ACCURATE, GST_SEEK_TYPE_SET, offset,
      GST_SEEK_TYPE_NONE, -1);

  res = gst_pad_push_event (queue->sinkpad, event);
  GST_QUEUE2_MUTEX_LOCK (queue);

  if (res) {
    /* Between us sending the seek event and re-acquiring the lock, the source
     * thread might already have pushed data and moved along the range's
     * writing_pos beyond the seek offset. In that case we don't want to set
     * the writing position back to the requested seek position, as it would
     * cause data to be written to the wrong offset in the file or ring buffer.
     * We still do the add_range call to switch the current range to the
     * requested range, or create one if one doesn't exist yet. */
    queue->current = add_range (queue, offset, FALSE);
  }

  return res;
}

/* get the threshold for when we decide to seek rather than wait */
static guint64
get_seek_threshold (GstQueue2 * queue)
{
  guint64 threshold;

  /* FIXME, find a good threshold based on the incoming rate. */
  threshold = 1024 * 512;

  if (QUEUE_IS_USING_RING_BUFFER (queue)) {
    threshold = MIN (threshold,
        QUEUE_MAX_BYTES (queue) - queue->cur_level.bytes);
  }
  return threshold;
}

/* see if there is enough data in the file to read a full buffer */
static gboolean
gst_queue2_have_data (GstQueue2 * queue, guint64 offset, guint length)
{
  GstQueue2Range *range;

  GST_DEBUG_OBJECT (queue, "looking for offset %" G_GUINT64_FORMAT ", len %u",
      offset, length);

  if ((range = find_range (queue, offset))) {
    if (queue->current != range) {
      GST_DEBUG_OBJECT (queue, "switching ranges, do seek to range position");
      perform_seek_to_offset (queue, range->writing_pos);
    }

    GST_INFO_OBJECT (queue, "cur_level.bytes %u (max %" G_GUINT64_FORMAT ")",
        queue->cur_level.bytes, QUEUE_MAX_BYTES (queue));

    /* we have a range for offset */
    GST_DEBUG_OBJECT (queue,
        "we have a range %p, offset %" G_GUINT64_FORMAT ", writing_pos %"
        G_GUINT64_FORMAT, range, range->offset, range->writing_pos);

    if (!QUEUE_IS_USING_RING_BUFFER (queue) && queue->is_eos)
      return TRUE;

    if (offset + length <= range->writing_pos)
      return TRUE;
    else
      GST_DEBUG_OBJECT (queue,
          "Need more data (%" G_GUINT64_FORMAT " bytes more)",
          (offset + length) - range->writing_pos);

  } else {
    GST_INFO_OBJECT (queue, "not found in any range off %" G_GUINT64_FORMAT
        " len %u", offset, length);
    /* we don't have the range, see how far away we are */
    if (!queue->is_eos && queue->current) {
      guint64 threshold = get_seek_threshold (queue);

      if (offset >= queue->current->offset && offset <=
          queue->current->writing_pos + threshold) {
        GST_INFO_OBJECT (queue,
            "requested data is within range, wait for data");
        return FALSE;
      }
    }

    /* too far away, do a seek */
    perform_seek_to_offset (queue, offset);
  }

  return FALSE;
}

#ifdef HAVE_FSEEKO
#define FSEEK_FILE(file,offset)  (fseeko (file, (off_t) offset, SEEK_SET) != 0)
#elif defined (G_OS_UNIX) || defined (G_OS_WIN32)
#define FSEEK_FILE(file,offset)  (lseek (fileno (file), (off_t) offset, SEEK_SET) == (off_t) -1)
#else
#define FSEEK_FILE(file,offset)  (fseek (file, offset, SEEK_SET) != 0)
#endif

static GstFlowReturn
gst_queue2_read_data_at_offset (GstQueue2 * queue, guint64 offset, guint length,
    guint8 * dst, gint64 * read_return)
{
  guint8 *ring_buffer;
  size_t res;

  ring_buffer = queue->ring_buffer;

  if (QUEUE_IS_USING_TEMP_FILE (queue) && FSEEK_FILE (queue->temp_file, offset))
    goto seek_failed;

  /* this should not block */
  GST_LOG_OBJECT (queue, "Reading %d bytes from offset %" G_GUINT64_FORMAT,
      length, offset);
  if (QUEUE_IS_USING_TEMP_FILE (queue)) {
    res = fread (dst, 1, length, queue->temp_file);
  } else {
    memcpy (dst, ring_buffer + offset, length);
    res = length;
  }

  GST_LOG_OBJECT (queue, "read %" G_GSIZE_FORMAT " bytes", res);

  if (G_UNLIKELY (res < length)) {
    if (!QUEUE_IS_USING_TEMP_FILE (queue))
      goto could_not_read;
    /* check for errors or EOF */
    if (ferror (queue->temp_file))
      goto could_not_read;
    if (feof (queue->temp_file) && length > 0)
      goto eos;
  }

  *read_return = res;

  return GST_FLOW_OK;

seek_failed:
  {
    GST_ELEMENT_ERROR (queue, RESOURCE, SEEK, (NULL), GST_ERROR_SYSTEM);
    return GST_FLOW_ERROR;
  }
could_not_read:
  {
    GST_ELEMENT_ERROR (queue, RESOURCE, READ, (NULL), GST_ERROR_SYSTEM);
    return GST_FLOW_ERROR;
  }
eos:
  {
    GST_DEBUG ("non-regular file hits EOS");
    return GST_FLOW_EOS;
  }
}

static GstFlowReturn
gst_queue2_create_read (GstQueue2 * queue, guint64 offset, guint length,
    GstBuffer ** buffer)
{
  GstBuffer *buf;
  GstMapInfo info;
  guint8 *data;
  guint64 file_offset;
  guint block_length, remaining, read_length;
  guint64 rb_size;
  guint64 max_size;
  guint64 rpos;
  GstFlowReturn ret = GST_FLOW_OK;

  /* allocate the output buffer of the requested size */
  if (*buffer == NULL)
    buf = gst_buffer_new_allocate (NULL, length, NULL);
  else
    buf = *buffer;

  gst_buffer_map (buf, &info, GST_MAP_WRITE);
  data = info.data;

  GST_DEBUG_OBJECT (queue, "Reading %u bytes from %" G_GUINT64_FORMAT, length,
      offset);

  rpos = offset;
  rb_size = queue->ring_buffer_max_size;
  max_size = QUEUE_MAX_BYTES (queue);

  remaining = length;
  while (remaining > 0) {
    /* configure how much/whether to read */
    if (!gst_queue2_have_data (queue, rpos, remaining)) {
      read_length = 0;

      if (QUEUE_IS_USING_RING_BUFFER (queue)) {
        guint64 level;

        /* calculate how far away the offset is */
        if (queue->current->writing_pos > rpos)
          level = queue->current->writing_pos - rpos;
        else
          level = 0;

        GST_DEBUG_OBJECT (queue,
            "reading %" G_GUINT64_FORMAT ", writing %" G_GUINT64_FORMAT
            ", level %" G_GUINT64_FORMAT ", max %" G_GUINT64_FORMAT,
            rpos, queue->current->writing_pos, level, max_size);

        if (level >= max_size) {
          /* we don't have the data but if we have a ring buffer that is full, we
           * need to read */
          GST_DEBUG_OBJECT (queue,
              "ring buffer full, reading QUEUE_MAX_BYTES %"
              G_GUINT64_FORMAT " bytes", max_size);
          read_length = max_size;
        } else if (queue->is_eos) {
          /* won't get any more data so read any data we have */
          if (level) {
            GST_DEBUG_OBJECT (queue,
                "EOS hit but read %" G_GUINT64_FORMAT " bytes that we have",
                level);
            read_length = level;
            remaining = level;
            length = level;
          } else
            goto hit_eos;
        }
      }

      if (read_length == 0) {
        if (QUEUE_IS_USING_RING_BUFFER (queue)) {
          GST_DEBUG_OBJECT (queue,
              "update current position [%" G_GUINT64_FORMAT "-%"
              G_GUINT64_FORMAT "]", rpos, queue->current->max_reading_pos);
          update_cur_pos (queue, queue->current, rpos);
          GST_QUEUE2_SIGNAL_DEL (queue);
        }

        if (queue->use_buffering)
          update_buffering (queue);

        GST_DEBUG_OBJECT (queue, "waiting for add");
        GST_QUEUE2_WAIT_ADD_CHECK (queue, queue->srcresult, out_flushing);
        continue;
      }
    } else {
      /* we have the requested data so read it */
      read_length = remaining;
    }

    /* set range reading_pos to actual reading position for this read */
    queue->current->reading_pos = rpos;

    /* configure how much and from where to read */
    if (QUEUE_IS_USING_RING_BUFFER (queue)) {
      file_offset =
          (queue->current->rb_offset + (rpos -
              queue->current->offset)) % rb_size;
      if (file_offset + read_length > rb_size) {
        block_length = rb_size - file_offset;
      } else {
        block_length = read_length;
      }
    } else {
      file_offset = rpos;
      block_length = read_length;
    }

    /* while we still have data to read, we loop */
    while (read_length > 0) {
      gint64 read_return;

      ret =
          gst_queue2_read_data_at_offset (queue, file_offset, block_length,
          data, &read_return);
      if (ret != GST_FLOW_OK)
        goto read_error;

      file_offset += read_return;
      if (QUEUE_IS_USING_RING_BUFFER (queue))
        file_offset %= rb_size;

      data += read_return;
      read_length -= read_return;
      block_length = read_length;
      remaining -= read_return;

      rpos = (queue->current->reading_pos += read_return);
      update_cur_pos (queue, queue->current, queue->current->reading_pos);
    }
    GST_QUEUE2_SIGNAL_DEL (queue);
    GST_DEBUG_OBJECT (queue, "%u bytes left to read", remaining);
  }

  gst_buffer_unmap (buf, &info);
  gst_buffer_resize (buf, 0, length);

  GST_BUFFER_OFFSET (buf) = offset;
  GST_BUFFER_OFFSET_END (buf) = offset + length;

  *buffer = buf;

  return ret;

  /* ERRORS */
hit_eos:
  {
    GST_DEBUG_OBJECT (queue, "EOS hit and we don't have any requested data");
    gst_buffer_unmap (buf, &info);
    if (*buffer == NULL)
      gst_buffer_unref (buf);
    return GST_FLOW_EOS;
  }
out_flushing:
  {
    GST_DEBUG_OBJECT (queue, "we are flushing");
    gst_buffer_unmap (buf, &info);
    if (*buffer == NULL)
      gst_buffer_unref (buf);
    return GST_FLOW_FLUSHING;
  }
read_error:
  {
    GST_DEBUG_OBJECT (queue, "we have a read error");
    gst_buffer_unmap (buf, &info);
    if (*buffer == NULL)
      gst_buffer_unref (buf);
    return ret;
  }
}

/* should be called with QUEUE_LOCK */
static GstMiniObject *
gst_queue2_read_item_from_file (GstQueue2 * queue)
{
  GstMiniObject *item;

  if (queue->stream_start_event != NULL) {
    item = GST_MINI_OBJECT_CAST (queue->stream_start_event);
    queue->stream_start_event = NULL;
  } else if (queue->starting_segment != NULL) {
    item = GST_MINI_OBJECT_CAST (queue->starting_segment);
    queue->starting_segment = NULL;
  } else {
    GstFlowReturn ret;
    GstBuffer *buffer = NULL;
    guint64 reading_pos;

    reading_pos = queue->current->reading_pos;

    ret =
        gst_queue2_create_read (queue, reading_pos, DEFAULT_BUFFER_SIZE,
        &buffer);

    switch (ret) {
      case GST_FLOW_OK:
        item = GST_MINI_OBJECT_CAST (buffer);
        break;
      case GST_FLOW_EOS:
        item = GST_MINI_OBJECT_CAST (gst_event_new_eos ());
        break;
      default:
        item = NULL;
        break;
    }
  }
  return item;
}

/* must be called with MUTEX_LOCK. Will briefly release the lock when notifying
 * the temp filename. */
static gboolean
gst_queue2_open_temp_location_file (GstQueue2 * queue)
{
  gint fd = -1;
  gchar *name = NULL;

  if (queue->temp_file)
    goto already_opened;

  GST_DEBUG_OBJECT (queue, "opening temp file %s", queue->temp_template);

  /* If temp_template was set, allocate a filename and open that filen */

  /* nothing to do */
  if (queue->temp_template == NULL)
    goto no_directory;

  /* make copy of the template, we don't want to change this */
  name = g_strdup (queue->temp_template);
  fd = g_mkstemp (name);
  if (fd == -1)
    goto mkstemp_failed;

  /* open the file for update/writing */
  queue->temp_file = fdopen (fd, "wb+");
  /* error creating file */
  if (queue->temp_file == NULL)
    goto open_failed;

  g_free (queue->temp_location);
  queue->temp_location = name;

  GST_QUEUE2_MUTEX_UNLOCK (queue);

  /* we can't emit the notify with the lock */
  g_object_notify (G_OBJECT (queue), "temp-location");

  GST_QUEUE2_MUTEX_LOCK (queue);

  GST_DEBUG_OBJECT (queue, "opened temp file %s", queue->temp_template);

  return TRUE;

  /* ERRORS */
already_opened:
  {
    GST_DEBUG_OBJECT (queue, "temp file was already open");
    return TRUE;
  }
no_directory:
  {
    GST_ELEMENT_ERROR (queue, RESOURCE, NOT_FOUND,
        (_("No Temp directory specified.")), (NULL));
    return FALSE;
  }
mkstemp_failed:
  {
    GST_ELEMENT_ERROR (queue, RESOURCE, OPEN_READ,
        (_("Could not create temp file \"%s\"."), queue->temp_template),
        GST_ERROR_SYSTEM);
    g_free (name);
    return FALSE;
  }
open_failed:
  {
    GST_ELEMENT_ERROR (queue, RESOURCE, OPEN_READ,
        (_("Could not open file \"%s\" for reading."), name), GST_ERROR_SYSTEM);
    g_free (name);
    if (fd != -1)
      close (fd);
    return FALSE;
  }
}

static void
gst_queue2_close_temp_location_file (GstQueue2 * queue)
{
  /* nothing to do */
  if (queue->temp_file == NULL)
    return;

  GST_DEBUG_OBJECT (queue, "closing temp file");

  fflush (queue->temp_file);
  fclose (queue->temp_file);

  if (queue->temp_remove) {
    if (remove (queue->temp_location) < 0) {
      GST_WARNING_OBJECT (queue, "Failed to remove temporary file %s: %s",
          queue->temp_location, g_strerror (errno));
    }
  }

  queue->temp_file = NULL;
  clean_ranges (queue);
}

static void
gst_queue2_flush_temp_file (GstQueue2 * queue)
{
  if (queue->temp_file == NULL)
    return;

  GST_DEBUG_OBJECT (queue, "flushing temp file");

  queue->temp_file = g_freopen (queue->temp_location, "wb+", queue->temp_file);
}

static void
gst_queue2_locked_flush (GstQueue2 * queue, gboolean full, gboolean clear_temp)
{
  if (!QUEUE_IS_USING_QUEUE (queue)) {
    if (QUEUE_IS_USING_TEMP_FILE (queue) && clear_temp)
      gst_queue2_flush_temp_file (queue);
    init_ranges (queue);
  } else {
    while (!g_queue_is_empty (&queue->queue)) {
      GstQueue2Item *qitem = g_queue_pop_head (&queue->queue);

      if (!full && qitem->type == GST_QUEUE2_ITEM_TYPE_EVENT
          && GST_EVENT_IS_STICKY (qitem->item)
          && GST_EVENT_TYPE (qitem->item) != GST_EVENT_SEGMENT
          && GST_EVENT_TYPE (qitem->item) != GST_EVENT_EOS) {
        gst_pad_store_sticky_event (queue->srcpad,
            GST_EVENT_CAST (qitem->item));
      }

      /* Then lose another reference because we are supposed to destroy that
         data when flushing */
      if (qitem->type != GST_QUEUE2_ITEM_TYPE_QUERY)
        gst_mini_object_unref (qitem->item);
      g_slice_free (GstQueue2Item, qitem);
    }
  }
  queue->last_query = FALSE;
  g_cond_signal (&queue->query_handled);
  GST_QUEUE2_CLEAR_LEVEL (queue->cur_level);
  gst_segment_init (&queue->sink_segment, GST_FORMAT_TIME);
  gst_segment_init (&queue->src_segment, GST_FORMAT_TIME);
  queue->sinktime = queue->srctime = GST_CLOCK_TIME_NONE;
  queue->sink_tainted = queue->src_tainted = TRUE;
  if (queue->starting_segment != NULL)
    gst_event_unref (queue->starting_segment);
  queue->starting_segment = NULL;
  queue->segment_event_received = FALSE;
  gst_event_replace (&queue->stream_start_event, NULL);

  /* we deleted a lot of something */
  GST_QUEUE2_SIGNAL_DEL (queue);
}

static gboolean
gst_queue2_wait_free_space (GstQueue2 * queue)
{
  /* We make space available if we're "full" according to whatever
   * the user defined as "full". */
  if (gst_queue2_is_filled (queue)) {
    gboolean started;

    /* pause the timer while we wait. The fact that we are waiting does not mean
     * the byterate on the input pad is lower */
    if ((started = queue->in_timer_started))
      g_timer_stop (queue->in_timer);

    GST_CAT_DEBUG_OBJECT (queue_dataflow, queue,
        "queue is full, waiting for free space");
    do {
      /* Wait for space to be available, we could be unlocked because of a flush. */
      GST_QUEUE2_WAIT_DEL_CHECK (queue, queue->sinkresult, out_flushing);
    }
    while (gst_queue2_is_filled (queue));

    /* and continue if we were running before */
    if (started)
      g_timer_continue (queue->in_timer);
  }
  return TRUE;

  /* ERRORS */
out_flushing:
  {
    GST_CAT_DEBUG_OBJECT (queue_dataflow, queue, "queue is flushing");
    return FALSE;
  }
}

static gboolean
gst_queue2_create_write (GstQueue2 * queue, GstBuffer * buffer)
{
  GstMapInfo info;
  guint8 *data, *ring_buffer;
  guint size, rb_size;
  guint64 writing_pos, new_writing_pos;
  GstQueue2Range *range, *prev, *next;
  gboolean do_seek = FALSE;

  if (QUEUE_IS_USING_RING_BUFFER (queue))
    writing_pos = queue->current->rb_writing_pos;
  else
    writing_pos = queue->current->writing_pos;
  ring_buffer = queue->ring_buffer;
  rb_size = queue->ring_buffer_max_size;

  gst_buffer_map (buffer, &info, GST_MAP_READ);

  size = info.size;
  data = info.data;

  GST_DEBUG_OBJECT (queue, "Writing %u bytes to %" G_GUINT64_FORMAT, size,
      writing_pos);

  /* sanity check */
  if (GST_BUFFER_OFFSET_IS_VALID (buffer) &&
      GST_BUFFER_OFFSET (buffer) != queue->current->writing_pos) {
    GST_WARNING_OBJECT (queue, "buffer offset does not match current writing "
        "position! %" G_GINT64_FORMAT " != %" G_GINT64_FORMAT,
        GST_BUFFER_OFFSET (buffer), queue->current->writing_pos);
  }

  while (size > 0) {
    guint to_write;

    if (QUEUE_IS_USING_RING_BUFFER (queue)) {
      gint64 space;

      /* calculate the space in the ring buffer not used by data from
       * the current range */
      while (QUEUE_MAX_BYTES (queue) <= queue->cur_level.bytes) {
        /* wait until there is some free space */
        GST_QUEUE2_WAIT_DEL_CHECK (queue, queue->sinkresult, out_flushing);
      }
      /* get the amount of space we have */
      space = QUEUE_MAX_BYTES (queue) - queue->cur_level.bytes;

      /* calculate if we need to split or if we can write the entire
       * buffer now */
      to_write = MIN (size, space);

      /* the writing position in the ring buffer after writing (part
       * or all of) the buffer */
      new_writing_pos = (writing_pos + to_write) % rb_size;

      prev = NULL;
      range = queue->ranges;

      /* if we need to overwrite data in the ring buffer, we need to
       * update the ranges
       *
       * warning: this code is complicated and includes some
       * simplifications - pen, paper and diagrams for the cases
       * recommended! */
      while (range) {
        guint64 range_data_start, range_data_end;
        GstQueue2Range *range_to_destroy = NULL;

        range_data_start = range->rb_offset;
        range_data_end = range->rb_writing_pos;

        /* handle the special case where the range has no data in it */
        if (range->writing_pos == range->offset) {
          if (range != queue->current) {
            GST_DEBUG_OBJECT (queue,
                "Removing range: offset %" G_GUINT64_FORMAT ", wpos %"
                G_GUINT64_FORMAT, range->offset, range->writing_pos);
            /* remove range */
            range_to_destroy = range;
            if (prev)
              prev->next = range->next;
          }
          goto next_range;
        }

        if (range_data_end > range_data_start) {
          if (writing_pos >= range_data_end && new_writing_pos >= writing_pos)
            goto next_range;

          if (new_writing_pos > range_data_start) {
            if (new_writing_pos >= range_data_end) {
              GST_DEBUG_OBJECT (queue,
                  "Removing range: offset %" G_GUINT64_FORMAT ", wpos %"
                  G_GUINT64_FORMAT, range->offset, range->writing_pos);
              /* remove range */
              range_to_destroy = range;
              if (prev)
                prev->next = range->next;
            } else {
              GST_DEBUG_OBJECT (queue,
                  "advancing offsets from %" G_GUINT64_FORMAT " (%"
                  G_GUINT64_FORMAT ") to %" G_GUINT64_FORMAT " (%"
                  G_GUINT64_FORMAT ")", range->offset, range->rb_offset,
                  range->offset + new_writing_pos - range_data_start,
                  new_writing_pos);
              range->offset += (new_writing_pos - range_data_start);
              range->rb_offset = new_writing_pos;
            }
          }
        } else {
          guint64 new_wpos_virt = writing_pos + to_write;

          if (new_wpos_virt <= range_data_start)
            goto next_range;

          if (new_wpos_virt > rb_size && new_writing_pos >= range_data_end) {
            GST_DEBUG_OBJECT (queue,
                "Removing range: offset %" G_GUINT64_FORMAT ", wpos %"
                G_GUINT64_FORMAT, range->offset, range->writing_pos);
            /* remove range */
            range_to_destroy = range;
            if (prev)
              prev->next = range->next;
          } else {
            GST_DEBUG_OBJECT (queue,
                "advancing offsets from %" G_GUINT64_FORMAT " (%"
                G_GUINT64_FORMAT ") to %" G_GUINT64_FORMAT " (%"
                G_GUINT64_FORMAT ")", range->offset, range->rb_offset,
                range->offset + new_writing_pos - range_data_start,
                new_writing_pos);
            range->offset += (new_wpos_virt - range_data_start);
            range->rb_offset = new_writing_pos;
          }
        }

      next_range:
        if (!range_to_destroy)
          prev = range;

        range = range->next;
        if (range_to_destroy) {
          if (range_to_destroy == queue->ranges)
            queue->ranges = range;
          g_slice_free (GstQueue2Range, range_to_destroy);
          range_to_destroy = NULL;
        }
      }
    } else {
      to_write = size;
      new_writing_pos = writing_pos + to_write;
    }

    if (QUEUE_IS_USING_TEMP_FILE (queue)
        && FSEEK_FILE (queue->temp_file, writing_pos))
      goto seek_failed;

    if (new_writing_pos > writing_pos) {
      GST_INFO_OBJECT (queue,
          "writing %u bytes to range [%" G_GUINT64_FORMAT "-%" G_GUINT64_FORMAT
          "] (rb wpos %" G_GUINT64_FORMAT ")", to_write, queue->current->offset,
          queue->current->writing_pos, queue->current->rb_writing_pos);
      /* either not using ring buffer or no wrapping, just write */
      if (QUEUE_IS_USING_TEMP_FILE (queue)) {
        if (fwrite (data, to_write, 1, queue->temp_file) != 1)
          goto handle_error;
      } else {
        memcpy (ring_buffer + writing_pos, data, to_write);
      }

      if (!QUEUE_IS_USING_RING_BUFFER (queue)) {
        /* try to merge with next range */
        while ((next = queue->current->next)) {
          GST_INFO_OBJECT (queue,
              "checking merge with next range %" G_GUINT64_FORMAT " < %"
              G_GUINT64_FORMAT, new_writing_pos, next->offset);
          if (new_writing_pos < next->offset)
            break;

          GST_DEBUG_OBJECT (queue, "merging ranges %" G_GUINT64_FORMAT,
              next->writing_pos);

          /* remove the group */
          queue->current->next = next->next;

          /* We use the threshold to decide if we want to do a seek or simply
           * read the data again. If there is not so much data in the range we
           * prefer to avoid to seek and read it again. */
          if (next->writing_pos > new_writing_pos + get_seek_threshold (queue)) {
            /* the new range had more data than the threshold, it's worth keeping
             * it and doing a seek. */
            new_writing_pos = next->writing_pos;
            do_seek = TRUE;
          }
          g_slice_free (GstQueue2Range, next);
        }
        goto update_and_signal;
      }
    } else {
      /* wrapping */
      guint block_one, block_two;

      block_one = rb_size - writing_pos;
      block_two = to_write - block_one;

      if (block_one > 0) {
        GST_INFO_OBJECT (queue, "writing %u bytes", block_one);
        /* write data to end of ring buffer */
        if (QUEUE_IS_USING_TEMP_FILE (queue)) {
          if (fwrite (data, block_one, 1, queue->temp_file) != 1)
            goto handle_error;
        } else {
          memcpy (ring_buffer + writing_pos, data, block_one);
        }
      }

      if (QUEUE_IS_USING_TEMP_FILE (queue) && FSEEK_FILE (queue->temp_file, 0))
        goto seek_failed;

      if (block_two > 0) {
        GST_INFO_OBJECT (queue, "writing %u bytes", block_two);
        if (QUEUE_IS_USING_TEMP_FILE (queue)) {
          if (fwrite (data + block_one, block_two, 1, queue->temp_file) != 1)
            goto handle_error;
        } else {
          memcpy (ring_buffer, data + block_one, block_two);
        }
      }
    }

  update_and_signal:
    /* update the writing positions */
    size -= to_write;
    GST_INFO_OBJECT (queue,
        "wrote %u bytes to %" G_GUINT64_FORMAT " (%u bytes remaining to write)",
        to_write, writing_pos, size);

    if (QUEUE_IS_USING_RING_BUFFER (queue)) {
      data += to_write;
      queue->current->writing_pos += to_write;
      queue->current->rb_writing_pos = writing_pos = new_writing_pos;
    } else {
      queue->current->writing_pos = writing_pos = new_writing_pos;
    }
    if (do_seek)
      perform_seek_to_offset (queue, new_writing_pos);

    update_cur_level (queue, queue->current);

    /* update the buffering status */
    if (queue->use_buffering)
      update_buffering (queue);

    GST_INFO_OBJECT (queue, "cur_level.bytes %u (max %" G_GUINT64_FORMAT ")",
        queue->cur_level.bytes, QUEUE_MAX_BYTES (queue));

    GST_QUEUE2_SIGNAL_ADD (queue);
  }

  gst_buffer_unmap (buffer, &info);

  return TRUE;

  /* ERRORS */
out_flushing:
  {
    GST_DEBUG_OBJECT (queue, "we are flushing");
    gst_buffer_unmap (buffer, &info);
    /* FIXME - GST_FLOW_EOS ? */
    return FALSE;
  }
seek_failed:
  {
    GST_ELEMENT_ERROR (queue, RESOURCE, SEEK, (NULL), GST_ERROR_SYSTEM);
    gst_buffer_unmap (buffer, &info);
    return FALSE;
  }
handle_error:
  {
    switch (errno) {
      case ENOSPC:{
        GST_ELEMENT_ERROR (queue, RESOURCE, NO_SPACE_LEFT, (NULL), (NULL));
        break;
      }
      default:{
        GST_ELEMENT_ERROR (queue, RESOURCE, WRITE,
            (_("Error while writing to download file.")),
            ("%s", g_strerror (errno)));
      }
    }
    gst_buffer_unmap (buffer, &info);
    return FALSE;
  }
}

static gboolean
buffer_list_create_write (GstBuffer ** buf, guint idx, gpointer q)
{
  GstQueue2 *queue = q;

  GST_TRACE_OBJECT (queue,
      "writing buffer %u of size %" G_GSIZE_FORMAT " bytes", idx,
      gst_buffer_get_size (*buf));

  if (!gst_queue2_create_write (queue, *buf)) {
    GST_INFO_OBJECT (queue, "create_write() returned FALSE, bailing out");
    return FALSE;
  }
  return TRUE;
}

static gboolean
buffer_list_calc_size (GstBuffer ** buf, guint idx, gpointer data)
{
  guint *p_size = data;
  gsize buf_size;

  buf_size = gst_buffer_get_size (*buf);
  GST_TRACE ("buffer %u in has size %" G_GSIZE_FORMAT, idx, buf_size);
  *p_size += buf_size;
  return TRUE;
}

/* enqueue an item an update the level stats */
static void
gst_queue2_locked_enqueue (GstQueue2 * queue, gpointer item,
    GstQueue2ItemType item_type)
{
  if (item_type == GST_QUEUE2_ITEM_TYPE_BUFFER) {
    GstBuffer *buffer;
    guint size;

    buffer = GST_BUFFER_CAST (item);
    size = gst_buffer_get_size (buffer);

    /* add buffer to the statistics */
    if (QUEUE_IS_USING_QUEUE (queue)) {
      queue->cur_level.buffers++;
      queue->cur_level.bytes += size;
    }
    queue->bytes_in += size;

    /* apply new buffer to segment stats */
    apply_buffer (queue, buffer, &queue->sink_segment, TRUE);
    /* update the byterate stats */
    update_in_rates (queue);

    if (!QUEUE_IS_USING_QUEUE (queue)) {
      /* FIXME - check return value? */
      gst_queue2_create_write (queue, buffer);
    }
  } else if (item_type == GST_QUEUE2_ITEM_TYPE_BUFFER_LIST) {
    GstBufferList *buffer_list;
    guint size = 0;

    buffer_list = GST_BUFFER_LIST_CAST (item);

    gst_buffer_list_foreach (buffer_list, buffer_list_calc_size, &size);
    GST_LOG_OBJECT (queue, "total size of buffer list: %u bytes", size);

    /* add buffer to the statistics */
    if (QUEUE_IS_USING_QUEUE (queue)) {
      queue->cur_level.buffers++;
      queue->cur_level.bytes += size;
    }
    queue->bytes_in += size;

    /* apply new buffer to segment stats */
    apply_buffer_list (queue, buffer_list, &queue->sink_segment, TRUE);

    /* update the byterate stats */
    update_in_rates (queue);

    if (!QUEUE_IS_USING_QUEUE (queue)) {
      gst_buffer_list_foreach (buffer_list, buffer_list_create_write, queue);
    }
  } else if (item_type == GST_QUEUE2_ITEM_TYPE_EVENT) {
    GstEvent *event;

    event = GST_EVENT_CAST (item);

    switch (GST_EVENT_TYPE (event)) {
      case GST_EVENT_EOS:
        /* Zero the thresholds, this makes sure the queue is completely
         * filled and we can read all data from the queue. */
        GST_DEBUG_OBJECT (queue, "we have EOS");
        queue->is_eos = TRUE;
        break;
      case GST_EVENT_SEGMENT:
        apply_segment (queue, event, &queue->sink_segment, TRUE);
        /* This is our first new segment, we hold it
         * as we can't save it on the temp file */
        if (!QUEUE_IS_USING_QUEUE (queue)) {
          if (queue->segment_event_received)
            goto unexpected_event;

          queue->segment_event_received = TRUE;
          if (queue->starting_segment != NULL)
            gst_event_unref (queue->starting_segment);
          queue->starting_segment = event;
          item = NULL;
        }
        /* a new segment allows us to accept more buffers if we got EOS
         * from downstream */
        queue->unexpected = FALSE;
        break;
      case GST_EVENT_STREAM_START:
        if (!QUEUE_IS_USING_QUEUE (queue)) {
          gst_event_replace (&queue->stream_start_event, event);
          gst_event_unref (event);
          item = NULL;
        }
        break;
      case GST_EVENT_CAPS:{
        GstCaps *caps;

        gst_event_parse_caps (event, &caps);
        GST_INFO ("got caps: %" GST_PTR_FORMAT, caps);

        if (!QUEUE_IS_USING_QUEUE (queue)) {
          GST_LOG ("Dropping caps event, not using queue");
          gst_event_unref (event);
          item = NULL;
        }
        break;
      }
      default:
        if (!QUEUE_IS_USING_QUEUE (queue))
          goto unexpected_event;
        break;
    }
  } else if (GST_IS_QUERY (item)) {
    /* Can't happen as we check that in the caller */
    if (!QUEUE_IS_USING_QUEUE (queue))
      g_assert_not_reached ();
  } else {
    g_warning ("Unexpected item %p added in queue %s (refcounting problem?)",
        item, GST_OBJECT_NAME (queue));
    /* we can't really unref since we don't know what it is */
    item = NULL;
  }

  if (item) {
    /* update the buffering status */
    if (queue->use_buffering)
      update_buffering (queue);

    if (QUEUE_IS_USING_QUEUE (queue)) {
      GstQueue2Item *qitem = g_slice_new (GstQueue2Item);
      qitem->type = item_type;
      qitem->item = item;
      g_queue_push_tail (&queue->queue, qitem);
    } else {
      gst_mini_object_unref (GST_MINI_OBJECT_CAST (item));
    }

    GST_QUEUE2_SIGNAL_ADD (queue);
  }

  return;

  /* ERRORS */
unexpected_event:
  {
    g_warning
        ("Unexpected event of kind %s can't be added in temp file of queue %s ",
        gst_event_type_get_name (GST_EVENT_TYPE (item)),
        GST_OBJECT_NAME (queue));
    gst_event_unref (GST_EVENT_CAST (item));
    return;
  }
}

/* dequeue an item from the queue and update level stats */
static GstMiniObject *
gst_queue2_locked_dequeue (GstQueue2 * queue, GstQueue2ItemType * item_type)
{
  GstMiniObject *item;

  if (!QUEUE_IS_USING_QUEUE (queue)) {
    item = gst_queue2_read_item_from_file (queue);
  } else {
    GstQueue2Item *qitem = g_queue_pop_head (&queue->queue);

    if (qitem == NULL)
      goto no_item;

    item = qitem->item;
    g_slice_free (GstQueue2Item, qitem);
  }

  if (item == NULL)
    goto no_item;

  if (GST_IS_BUFFER (item)) {
    GstBuffer *buffer;
    guint size;

    buffer = GST_BUFFER_CAST (item);
    size = gst_buffer_get_size (buffer);
    *item_type = GST_QUEUE2_ITEM_TYPE_BUFFER;

    GST_CAT_LOG_OBJECT (queue_dataflow, queue,
        "retrieved buffer %p from queue", buffer);

    if (QUEUE_IS_USING_QUEUE (queue)) {
      queue->cur_level.buffers--;
      queue->cur_level.bytes -= size;
    }
    queue->bytes_out += size;

    apply_buffer (queue, buffer, &queue->src_segment, FALSE);
    /* update the byterate stats */
    update_out_rates (queue);
    /* update the buffering */
    if (queue->use_buffering)
      update_buffering (queue);

  } else if (GST_IS_EVENT (item)) {
    GstEvent *event = GST_EVENT_CAST (item);

    *item_type = GST_QUEUE2_ITEM_TYPE_EVENT;

    GST_CAT_LOG_OBJECT (queue_dataflow, queue,
        "retrieved event %p from queue", event);

    switch (GST_EVENT_TYPE (event)) {
      case GST_EVENT_EOS:
        /* queue is empty now that we dequeued the EOS */
        GST_QUEUE2_CLEAR_LEVEL (queue->cur_level);
        break;
      case GST_EVENT_SEGMENT:
        apply_segment (queue, event, &queue->src_segment, FALSE);
        break;
      default:
        break;
    }
  } else if (GST_IS_BUFFER_LIST (item)) {
    GstBufferList *buffer_list;
    guint size = 0;

    buffer_list = GST_BUFFER_LIST_CAST (item);
    gst_buffer_list_foreach (buffer_list, buffer_list_calc_size, &size);
    *item_type = GST_QUEUE2_ITEM_TYPE_BUFFER_LIST;

    GST_CAT_LOG_OBJECT (queue_dataflow, queue,
        "retrieved buffer list %p from queue", buffer_list);

    if (QUEUE_IS_USING_QUEUE (queue)) {
      queue->cur_level.buffers--;
      queue->cur_level.bytes -= size;
    }
    queue->bytes_out += size;

    apply_buffer_list (queue, buffer_list, &queue->src_segment, FALSE);
    /* update the byterate stats */
    update_out_rates (queue);
    /* update the buffering */
    if (queue->use_buffering)
      update_buffering (queue);
  } else if (GST_IS_QUERY (item)) {
    GST_CAT_LOG_OBJECT (queue_dataflow, queue,
        "retrieved query %p from queue", item);
    *item_type = GST_QUEUE2_ITEM_TYPE_QUERY;
  } else {
    g_warning
        ("Unexpected item %p dequeued from queue %s (refcounting problem?)",
        item, GST_OBJECT_NAME (queue));
    item = NULL;
    *item_type = GST_QUEUE2_ITEM_TYPE_UNKNOWN;
  }
  GST_QUEUE2_SIGNAL_DEL (queue);

  return item;

  /* ERRORS */
no_item:
  {
    GST_CAT_LOG_OBJECT (queue_dataflow, queue, "the queue is empty");
    return NULL;
  }
}

static gboolean
gst_queue2_handle_sink_event (GstPad * pad, GstObject * parent,
    GstEvent * event)
{
  gboolean ret = TRUE;
  GstQueue2 *queue;

  queue = GST_QUEUE2 (parent);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_FLUSH_START:
    {
      GST_CAT_LOG_OBJECT (queue_dataflow, queue, "received flush start event");
      if (GST_PAD_MODE (queue->srcpad) == GST_PAD_MODE_PUSH) {
        /* forward event */
        ret = gst_pad_push_event (queue->srcpad, event);

        /* now unblock the chain function */
        GST_QUEUE2_MUTEX_LOCK (queue);
        queue->srcresult = GST_FLOW_FLUSHING;
        queue->sinkresult = GST_FLOW_FLUSHING;
        /* unblock the loop and chain functions */
        GST_QUEUE2_SIGNAL_ADD (queue);
        GST_QUEUE2_SIGNAL_DEL (queue);
        queue->last_query = FALSE;
        g_cond_signal (&queue->query_handled);
        GST_QUEUE2_MUTEX_UNLOCK (queue);

        /* make sure it pauses, this should happen since we sent
         * flush_start downstream. */
        gst_pad_pause_task (queue->srcpad);
        GST_CAT_LOG_OBJECT (queue_dataflow, queue, "loop stopped");
      } else {
        GST_QUEUE2_MUTEX_LOCK (queue);
        /* flush the sink pad */
        queue->sinkresult = GST_FLOW_FLUSHING;
        GST_QUEUE2_SIGNAL_DEL (queue);
        queue->last_query = FALSE;
        g_cond_signal (&queue->query_handled);
        GST_QUEUE2_MUTEX_UNLOCK (queue);

        gst_event_unref (event);
      }
      break;
    }
    case GST_EVENT_FLUSH_STOP:
    {
      GST_CAT_LOG_OBJECT (queue_dataflow, queue, "received flush stop event");

      if (GST_PAD_MODE (queue->srcpad) == GST_PAD_MODE_PUSH) {
        /* forward event */
        ret = gst_pad_push_event (queue->srcpad, event);

        GST_QUEUE2_MUTEX_LOCK (queue);
        gst_queue2_locked_flush (queue, FALSE, TRUE);
        queue->srcresult = GST_FLOW_OK;
        queue->sinkresult = GST_FLOW_OK;
        queue->is_eos = FALSE;
        queue->unexpected = FALSE;
        queue->seeking = FALSE;
        /* reset rate counters */
        reset_rate_timer (queue);
        gst_pad_start_task (queue->srcpad, (GstTaskFunction) gst_queue2_loop,
            queue->srcpad, NULL);
        GST_QUEUE2_MUTEX_UNLOCK (queue);
      } else {
        GST_QUEUE2_MUTEX_LOCK (queue);
        queue->segment_event_received = FALSE;
        queue->is_eos = FALSE;
        queue->unexpected = FALSE;
        queue->sinkresult = GST_FLOW_OK;
        queue->seeking = FALSE;
        GST_QUEUE2_MUTEX_UNLOCK (queue);

        gst_event_unref (event);
      }
      break;
    }
    default:
      if (GST_EVENT_IS_SERIALIZED (event)) {
        /* serialized events go in the queue */
        GST_QUEUE2_MUTEX_LOCK_CHECK (queue, queue->sinkresult, out_flushing);
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
        if (queue->is_eos)
          goto out_eos;
        gst_queue2_locked_enqueue (queue, event, GST_QUEUE2_ITEM_TYPE_EVENT);
        GST_QUEUE2_MUTEX_UNLOCK (queue);
      } else {
        /* non-serialized events are passed upstream. */
        ret = gst_pad_push_event (queue->srcpad, event);
      }
      break;
  }
  return ret;

  /* ERRORS */
out_flushing:
  {
    GST_DEBUG_OBJECT (queue, "refusing event, we are flushing");
    GST_QUEUE2_MUTEX_UNLOCK (queue);
    gst_event_unref (event);
    return FALSE;
  }
out_eos:
  {
    GST_DEBUG_OBJECT (queue, "refusing event, we are EOS");
    GST_QUEUE2_MUTEX_UNLOCK (queue);
    gst_event_unref (event);
    return FALSE;
  }
out_flow_error:
  {
    GST_LOG_OBJECT (queue,
        "refusing event, we have a downstream flow error: %s",
        gst_flow_get_name (queue->srcresult));
    GST_QUEUE2_MUTEX_UNLOCK (queue);
    gst_event_unref (event);
    return FALSE;
  }
}

static gboolean
gst_queue2_handle_sink_query (GstPad * pad, GstObject * parent,
    GstQuery * query)
{
  GstQueue2 *queue;
  gboolean res;

  queue = GST_QUEUE2 (parent);

  switch (GST_QUERY_TYPE (query)) {
    default:
      if (GST_QUERY_IS_SERIALIZED (query)) {
        GST_CAT_LOG_OBJECT (queue_dataflow, queue, "received query %p", query);
        /* serialized events go in the queue. We need to be certain that we
         * don't cause deadlocks waiting for the query return value. We check if
         * the queue is empty (nothing is blocking downstream and the query can
         * be pushed for sure) or we are not buffering. If we are buffering,
         * the pipeline waits to unblock downstream until our queue fills up
         * completely, which can not happen if we block on the query..
         * Therefore we only potentially block when we are not buffering. */
        GST_QUEUE2_MUTEX_LOCK_CHECK (queue, queue->sinkresult, out_flushing);
        if (QUEUE_IS_USING_QUEUE (queue) && (gst_queue2_is_empty (queue)
                || !queue->use_buffering)) {
          if (!g_atomic_int_get (&queue->downstream_may_block)) {
            gst_queue2_locked_enqueue (queue, query,
                GST_QUEUE2_ITEM_TYPE_QUERY);

            STATUS (queue, queue->sinkpad, "wait for QUERY");
            g_cond_wait (&queue->query_handled, &queue->qlock);
            if (queue->sinkresult != GST_FLOW_OK)
              goto out_flushing;
            res = queue->last_query;
          } else {
            GST_DEBUG_OBJECT (queue, "refusing query, downstream might block");
            res = FALSE;
          }
        } else {
          GST_DEBUG_OBJECT (queue,
              "refusing query, we are not using the queue");
          res = FALSE;
        }
        GST_QUEUE2_MUTEX_UNLOCK (queue);
      } else {
        res = gst_pad_query_default (pad, parent, query);
      }
      break;
  }
  return res;

  /* ERRORS */
out_flushing:
  {
    GST_DEBUG_OBJECT (queue, "refusing query, we are flushing");
    GST_QUEUE2_MUTEX_UNLOCK (queue);
    return FALSE;
  }
}

static gboolean
gst_queue2_is_empty (GstQueue2 * queue)
{
  /* never empty on EOS */
  if (queue->is_eos)
    return FALSE;

  if (!QUEUE_IS_USING_QUEUE (queue) && queue->current) {
    return queue->current->writing_pos <= queue->current->max_reading_pos;
  } else {
    if (queue->queue.length == 0)
      return TRUE;
  }

  return FALSE;
}

static gboolean
gst_queue2_is_filled (GstQueue2 * queue)
{
  gboolean res;

  /* always filled on EOS */
  if (queue->is_eos)
    return TRUE;

#define CHECK_FILLED(format,alt_max) ((queue->max_level.format) > 0 && \
    (queue->cur_level.format) >= ((alt_max) ? \
      MIN ((queue->max_level.format), (alt_max)) : (queue->max_level.format)))

  /* if using a ring buffer we're filled if all ring buffer space is used
   * _by the current range_ */
  if (QUEUE_IS_USING_RING_BUFFER (queue)) {
    guint64 rb_size = queue->ring_buffer_max_size;
    GST_DEBUG_OBJECT (queue,
        "max bytes %u, rb size %" G_GUINT64_FORMAT ", cur bytes %u",
        queue->max_level.bytes, rb_size, queue->cur_level.bytes);
    return CHECK_FILLED (bytes, rb_size);
  }

  /* if using file, we're never filled if we don't have EOS */
  if (QUEUE_IS_USING_TEMP_FILE (queue))
    return FALSE;

  /* we are never filled when we have no buffers at all */
  if (queue->cur_level.buffers == 0)
    return FALSE;

  /* we are filled if one of the current levels exceeds the max */
  res = CHECK_FILLED (buffers, 0) || CHECK_FILLED (bytes, 0)
      || CHECK_FILLED (time, 0);

  /* if we need to, use the rate estimate to check against the max time we are
   * allowed to queue */
  if (queue->use_rate_estimate)
    res |= CHECK_FILLED (rate_time, 0);

#undef CHECK_FILLED
  return res;
}

static GstFlowReturn
gst_queue2_chain_buffer_or_buffer_list (GstQueue2 * queue,
    GstMiniObject * item, GstQueue2ItemType item_type)
{
  /* we have to lock the queue since we span threads */
  GST_QUEUE2_MUTEX_LOCK_CHECK (queue, queue->sinkresult, out_flushing);
  /* when we received EOS, we refuse more data */
  if (queue->is_eos)
    goto out_eos;
  /* when we received unexpected from downstream, refuse more buffers */
  if (queue->unexpected)
    goto out_unexpected;

  /* while we didn't receive the newsegment, we're seeking and we skip data */
  if (queue->seeking)
    goto out_seeking;

  if (!gst_queue2_wait_free_space (queue))
    goto out_flushing;

  /* put buffer in queue now */
  gst_queue2_locked_enqueue (queue, item, item_type);
  GST_QUEUE2_MUTEX_UNLOCK (queue);

  return GST_FLOW_OK;

  /* special conditions */
out_flushing:
  {
    GstFlowReturn ret = queue->sinkresult;

    GST_CAT_LOG_OBJECT (queue_dataflow, queue,
        "exit because task paused, reason: %s", gst_flow_get_name (ret));
    GST_QUEUE2_MUTEX_UNLOCK (queue);
    gst_mini_object_unref (item);

    return ret;
  }
out_eos:
  {
    GST_CAT_LOG_OBJECT (queue_dataflow, queue, "exit because we received EOS");
    GST_QUEUE2_MUTEX_UNLOCK (queue);
    gst_mini_object_unref (item);

    return GST_FLOW_EOS;
  }
out_seeking:
  {
    GST_CAT_LOG_OBJECT (queue_dataflow, queue, "exit because we are seeking");
    GST_QUEUE2_MUTEX_UNLOCK (queue);
    gst_mini_object_unref (item);

    return GST_FLOW_OK;
  }
out_unexpected:
  {
    GST_CAT_LOG_OBJECT (queue_dataflow, queue, "exit because we received EOS");
    GST_QUEUE2_MUTEX_UNLOCK (queue);
    gst_mini_object_unref (item);

    return GST_FLOW_EOS;
  }
}

static GstFlowReturn
gst_queue2_chain (GstPad * pad, GstObject * parent, GstBuffer * buffer)
{
  GstQueue2 *queue;

  queue = GST_QUEUE2 (parent);

  GST_CAT_LOG_OBJECT (queue_dataflow, queue, "received buffer %p of "
      "size %" G_GSIZE_FORMAT ", time %" GST_TIME_FORMAT ", duration %"
      GST_TIME_FORMAT, buffer, gst_buffer_get_size (buffer),
      GST_TIME_ARGS (GST_BUFFER_TIMESTAMP (buffer)),
      GST_TIME_ARGS (GST_BUFFER_DURATION (buffer)));

  return gst_queue2_chain_buffer_or_buffer_list (queue,
      GST_MINI_OBJECT_CAST (buffer), GST_QUEUE2_ITEM_TYPE_BUFFER);
}

static GstFlowReturn
gst_queue2_chain_list (GstPad * pad, GstObject * parent,
    GstBufferList * buffer_list)
{
  GstQueue2 *queue;

  queue = GST_QUEUE2 (parent);

  GST_CAT_LOG_OBJECT (queue_dataflow, queue,
      "received buffer list %p", buffer_list);

  return gst_queue2_chain_buffer_or_buffer_list (queue,
      GST_MINI_OBJECT_CAST (buffer_list), GST_QUEUE2_ITEM_TYPE_BUFFER_LIST);
}

static GstMiniObject *
gst_queue2_dequeue_on_eos (GstQueue2 * queue, GstQueue2ItemType * item_type)
{
  GstMiniObject *data;

  GST_CAT_LOG_OBJECT (queue_dataflow, queue, "got EOS from downstream");

  /* stop pushing buffers, we dequeue all items until we see an item that we
   * can push again, which is EOS or SEGMENT. If there is nothing in the
   * queue we can push, we set a flag to make the sinkpad refuse more
   * buffers with an EOS return value until we receive something
   * pushable again or we get flushed. */
  while ((data = gst_queue2_locked_dequeue (queue, item_type))) {
    if (*item_type == GST_QUEUE2_ITEM_TYPE_BUFFER) {
      GST_CAT_LOG_OBJECT (queue_dataflow, queue,
          "dropping EOS buffer %p", data);
      gst_buffer_unref (GST_BUFFER_CAST (data));
    } else if (*item_type == GST_QUEUE2_ITEM_TYPE_EVENT) {
      GstEvent *event = GST_EVENT_CAST (data);
      GstEventType type = GST_EVENT_TYPE (event);

      if (type == GST_EVENT_EOS || type == GST_EVENT_SEGMENT) {
        /* we found a pushable item in the queue, push it out */
        GST_CAT_LOG_OBJECT (queue_dataflow, queue,
            "pushing pushable event %s after EOS", GST_EVENT_TYPE_NAME (event));
        return data;
      }
      GST_CAT_LOG_OBJECT (queue_dataflow, queue,
          "dropping EOS event %p", event);
      gst_event_unref (event);
    } else if (*item_type == GST_QUEUE2_ITEM_TYPE_BUFFER_LIST) {
      GST_CAT_LOG_OBJECT (queue_dataflow, queue,
          "dropping EOS buffer list %p", data);
      gst_buffer_list_unref (GST_BUFFER_LIST_CAST (data));
    } else if (*item_type == GST_QUEUE2_ITEM_TYPE_QUERY) {
      queue->last_query = FALSE;
      g_cond_signal (&queue->query_handled);
      GST_CAT_LOG_OBJECT (queue_dataflow, queue, "dropping EOS query %p", data);
    }
  }
  /* no more items in the queue. Set the unexpected flag so that upstream
   * make us refuse any more buffers on the sinkpad. Since we will still
   * accept EOS and SEGMENT we return _FLOW_OK to the caller so that the
   * task function does not shut down. */
  queue->unexpected = TRUE;
  return NULL;
}

/* dequeue an item from the queue an push it downstream. This functions returns
 * the result of the push. */
static GstFlowReturn
gst_queue2_push_one (GstQueue2 * queue)
{
  GstFlowReturn result = queue->srcresult;
  GstMiniObject *data;
  GstQueue2ItemType item_type;

  data = gst_queue2_locked_dequeue (queue, &item_type);
  if (data == NULL)
    goto no_item;

next:
  STATUS (queue, queue->srcpad, "We have something dequeud");
  g_atomic_int_set (&queue->downstream_may_block,
      item_type == GST_QUEUE2_ITEM_TYPE_BUFFER ||
      item_type == GST_QUEUE2_ITEM_TYPE_BUFFER_LIST);
  GST_QUEUE2_MUTEX_UNLOCK (queue);

  if (item_type == GST_QUEUE2_ITEM_TYPE_BUFFER) {
    GstBuffer *buffer;

    buffer = GST_BUFFER_CAST (data);

    result = gst_pad_push (queue->srcpad, buffer);
    g_atomic_int_set (&queue->downstream_may_block, 0);

    /* need to check for srcresult here as well */
    GST_QUEUE2_MUTEX_LOCK_CHECK (queue, queue->srcresult, out_flushing);
    if (result == GST_FLOW_EOS) {
      data = gst_queue2_dequeue_on_eos (queue, &item_type);
      if (data != NULL)
        goto next;
      /* Since we will still accept EOS and SEGMENT we return _FLOW_OK
       * to the caller so that the task function does not shut down */
      result = GST_FLOW_OK;
    }
  } else if (item_type == GST_QUEUE2_ITEM_TYPE_EVENT) {
    GstEvent *event = GST_EVENT_CAST (data);
    GstEventType type = GST_EVENT_TYPE (event);

    gst_pad_push_event (queue->srcpad, event);

    /* if we're EOS, return EOS so that the task pauses. */
    if (type == GST_EVENT_EOS) {
      GST_CAT_LOG_OBJECT (queue_dataflow, queue,
          "pushed EOS event %p, return EOS", event);
      result = GST_FLOW_EOS;
    }

    GST_QUEUE2_MUTEX_LOCK_CHECK (queue, queue->srcresult, out_flushing);
  } else if (item_type == GST_QUEUE2_ITEM_TYPE_BUFFER_LIST) {
    GstBufferList *buffer_list;

    buffer_list = GST_BUFFER_LIST_CAST (data);

    result = gst_pad_push_list (queue->srcpad, buffer_list);
    g_atomic_int_set (&queue->downstream_may_block, 0);

    /* need to check for srcresult here as well */
    GST_QUEUE2_MUTEX_LOCK_CHECK (queue, queue->srcresult, out_flushing);
    if (result == GST_FLOW_EOS) {
      data = gst_queue2_dequeue_on_eos (queue, &item_type);
      if (data != NULL)
        goto next;
      /* Since we will still accept EOS and SEGMENT we return _FLOW_OK
       * to the caller so that the task function does not shut down */
      result = GST_FLOW_OK;
    }
  } else if (item_type == GST_QUEUE2_ITEM_TYPE_QUERY) {
    GstQuery *query = GST_QUERY_CAST (data);

    GST_LOG_OBJECT (queue->srcpad, "Peering query %p", query);
    queue->last_query = gst_pad_peer_query (queue->srcpad, query);
    GST_LOG_OBJECT (queue->srcpad, "Peered query");
    GST_CAT_LOG_OBJECT (queue_dataflow, queue,
        "did query %p, return %d", query, queue->last_query);
    g_cond_signal (&queue->query_handled);
    GST_QUEUE2_MUTEX_LOCK_CHECK (queue, queue->srcresult, out_flushing);
    result = GST_FLOW_OK;
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
}

/* called repeatedly with @pad as the source pad. This function should push out
 * data to the peer element. */
static void
gst_queue2_loop (GstPad * pad)
{
  GstQueue2 *queue;
  GstFlowReturn ret;

  queue = GST_QUEUE2 (GST_PAD_PARENT (pad));

  /* have to lock for thread-safety */
  GST_QUEUE2_MUTEX_LOCK_CHECK (queue, queue->srcresult, out_flushing);

  if (gst_queue2_is_empty (queue)) {
    gboolean started;

    /* pause the timer while we wait. The fact that we are waiting does not mean
     * the byterate on the output pad is lower */
    if ((started = queue->out_timer_started))
      g_timer_stop (queue->out_timer);

    GST_CAT_DEBUG_OBJECT (queue_dataflow, queue,
        "queue is empty, waiting for new data");
    do {
      /* Wait for data to be available, we could be unlocked because of a flush. */
      GST_QUEUE2_WAIT_ADD_CHECK (queue, queue->srcresult, out_flushing);
    }
    while (gst_queue2_is_empty (queue));

    /* and continue if we were running before */
    if (started)
      g_timer_continue (queue->out_timer);
  }
  ret = gst_queue2_push_one (queue);
  queue->srcresult = ret;
  queue->sinkresult = ret;
  if (ret != GST_FLOW_OK)
    goto out_flushing;

  GST_QUEUE2_MUTEX_UNLOCK (queue);

  return;

  /* ERRORS */
out_flushing:
  {
    gboolean eos = queue->is_eos;
    GstFlowReturn ret = queue->srcresult;

    gst_pad_pause_task (queue->srcpad);
    GST_QUEUE2_MUTEX_UNLOCK (queue);
    GST_CAT_LOG_OBJECT (queue_dataflow, queue,
        "pause task, reason:  %s", gst_flow_get_name (queue->srcresult));
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
gst_queue2_handle_src_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  gboolean res = TRUE;
  GstQueue2 *queue = GST_QUEUE2 (parent);

#ifndef GST_DISABLE_GST_DEBUG
  GST_CAT_DEBUG_OBJECT (queue_dataflow, queue, "got event %p (%s)",
      event, GST_EVENT_TYPE_NAME (event));
#endif

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_FLUSH_START:
      if (QUEUE_IS_USING_QUEUE (queue)) {
        /* just forward upstream */
        res = gst_pad_push_event (queue->sinkpad, event);
      } else {
        /* now unblock the getrange function */
        GST_QUEUE2_MUTEX_LOCK (queue);
        GST_DEBUG_OBJECT (queue, "flushing");
        queue->srcresult = GST_FLOW_FLUSHING;
        GST_QUEUE2_SIGNAL_ADD (queue);
        GST_QUEUE2_MUTEX_UNLOCK (queue);

        /* when using a temp file, we eat the event */
        res = TRUE;
        gst_event_unref (event);
      }
      break;
    case GST_EVENT_FLUSH_STOP:
      if (QUEUE_IS_USING_QUEUE (queue)) {
        /* just forward upstream */
        res = gst_pad_push_event (queue->sinkpad, event);
      } else {
        /* now unblock the getrange function */
        GST_QUEUE2_MUTEX_LOCK (queue);
        queue->srcresult = GST_FLOW_OK;
        GST_QUEUE2_MUTEX_UNLOCK (queue);

        /* when using a temp file, we eat the event */
        res = TRUE;
        gst_event_unref (event);
      }
      break;
    case GST_EVENT_RECONFIGURE:
      GST_QUEUE2_MUTEX_LOCK (queue);
      /* assume downstream is linked now and try to push again */
      if (queue->srcresult == GST_FLOW_NOT_LINKED) {
        queue->srcresult = GST_FLOW_OK;
        queue->sinkresult = GST_FLOW_OK;
        if (GST_PAD_MODE (pad) == GST_PAD_MODE_PUSH) {
          gst_pad_start_task (pad, (GstTaskFunction) gst_queue2_loop, pad,
              NULL);
        }
      }
      GST_QUEUE2_MUTEX_UNLOCK (queue);

      res = gst_pad_push_event (queue->sinkpad, event);
      break;
    default:
      res = gst_pad_push_event (queue->sinkpad, event);
      break;
  }

  return res;
}

static gboolean
gst_queue2_handle_src_query (GstPad * pad, GstObject * parent, GstQuery * query)
{
  GstQueue2 *queue;

  queue = GST_QUEUE2 (parent);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_POSITION:
    {
      gint64 peer_pos;
      GstFormat format;

      if (!gst_pad_peer_query (queue->sinkpad, query))
        goto peer_failed;

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
          GST_WARNING_OBJECT (queue, "dropping query in %s format, don't "
              "know how to adjust value", gst_format_get_name (format));
          return FALSE;
      }
      /* set updated position */
      gst_query_set_position (query, format, peer_pos);
      break;
    }
    case GST_QUERY_DURATION:
    {
      GST_DEBUG_OBJECT (queue, "doing peer query");

      if (!gst_pad_peer_query (queue->sinkpad, query))
        goto peer_failed;

      GST_DEBUG_OBJECT (queue, "peer query success");
      break;
    }
    case GST_QUERY_BUFFERING:
    {
      gint percent;
      gboolean is_buffering;
      GstBufferingMode mode;
      gint avg_in, avg_out;
      gint64 buffering_left;

      GST_DEBUG_OBJECT (queue, "query buffering");

      get_buffering_percent (queue, &is_buffering, &percent);
      gst_query_set_buffering_percent (query, is_buffering, percent);

      get_buffering_stats (queue, percent, &mode, &avg_in, &avg_out,
          &buffering_left);
      gst_query_set_buffering_stats (query, mode, avg_in, avg_out,
          buffering_left);

      if (!QUEUE_IS_USING_QUEUE (queue)) {
        /* add ranges for download and ringbuffer buffering */
        GstFormat format;
        gint64 start, stop, range_start, range_stop;
        guint64 writing_pos;
        gint64 estimated_total;
        gint64 duration;
        gboolean peer_res, is_eos;
        GstQueue2Range *queued_ranges;

        /* we need a current download region */
        if (queue->current == NULL)
          return FALSE;

        writing_pos = queue->current->writing_pos;
        is_eos = queue->is_eos;

        if (is_eos) {
          /* we're EOS, we know the duration in bytes now */
          peer_res = TRUE;
          duration = writing_pos;
        } else {
          /* get duration of upstream in bytes */
          peer_res = gst_pad_peer_query_duration (queue->sinkpad,
              GST_FORMAT_BYTES, &duration);
        }

        GST_DEBUG_OBJECT (queue, "percent %d, duration %" G_GINT64_FORMAT
            ", writing %" G_GINT64_FORMAT, percent, duration, writing_pos);

        /* calculate remaining and total download time */
        if (peer_res && avg_in > 0.0)
          estimated_total = ((duration - writing_pos) * 1000) / avg_in;
        else
          estimated_total = -1;

        GST_DEBUG_OBJECT (queue, "estimated-total %" G_GINT64_FORMAT,
            estimated_total);

        gst_query_parse_buffering_range (query, &format, NULL, NULL, NULL);

        switch (format) {
          case GST_FORMAT_PERCENT:
            /* we need duration */
            if (!peer_res)
              goto peer_failed;

            start = 0;
            /* get our available data relative to the duration */
            if (duration != -1)
              stop =
                  gst_util_uint64_scale (GST_FORMAT_PERCENT_MAX, writing_pos,
                  duration);
            else
              stop = -1;
            break;
          case GST_FORMAT_BYTES:
            start = 0;
            stop = writing_pos;
            break;
          default:
            start = -1;
            stop = -1;
            break;
        }

        /* fill out the buffered ranges */
        for (queued_ranges = queue->ranges; queued_ranges;
            queued_ranges = queued_ranges->next) {
          switch (format) {
            case GST_FORMAT_PERCENT:
              if (duration == -1) {
                range_start = 0;
                range_stop = 0;
                break;
              }
              range_start =
                  gst_util_uint64_scale (GST_FORMAT_PERCENT_MAX,
                  queued_ranges->offset, duration);
              range_stop =
                  gst_util_uint64_scale (GST_FORMAT_PERCENT_MAX,
                  queued_ranges->writing_pos, duration);
              break;
            case GST_FORMAT_BYTES:
              range_start = queued_ranges->offset;
              range_stop = queued_ranges->writing_pos;
              break;
            default:
              range_start = -1;
              range_stop = -1;
              break;
          }
          if (range_start == range_stop)
            continue;
          GST_DEBUG_OBJECT (queue,
              "range starting at %" G_GINT64_FORMAT " and finishing at %"
              G_GINT64_FORMAT, range_start, range_stop);
          gst_query_add_buffering_range (query, range_start, range_stop);
        }

        gst_query_set_buffering_range (query, format, start, stop,
            estimated_total);
      }
      break;
    }
    case GST_QUERY_SCHEDULING:
    {
      gboolean pull_mode;
      GstSchedulingFlags flags = 0;

      if (!gst_pad_peer_query (queue->sinkpad, query))
        goto peer_failed;

      gst_query_parse_scheduling (query, &flags, NULL, NULL, NULL);

      /* we can operate in pull mode when we are using a tempfile */
      pull_mode = !QUEUE_IS_USING_QUEUE (queue);

      if (pull_mode)
        flags |= GST_SCHEDULING_FLAG_SEEKABLE;
      gst_query_set_scheduling (query, flags, 0, -1, 0);
      if (pull_mode)
        gst_query_add_scheduling_mode (query, GST_PAD_MODE_PULL);
      gst_query_add_scheduling_mode (query, GST_PAD_MODE_PUSH);
      break;
    }
    default:
      /* peer handled other queries */
      if (!gst_pad_query_default (pad, parent, query))
        goto peer_failed;
      break;
  }

  return TRUE;

  /* ERRORS */
peer_failed:
  {
    GST_DEBUG_OBJECT (queue, "failed peer query");
    return FALSE;
  }
}

static gboolean
gst_queue2_handle_query (GstElement * element, GstQuery * query)
{
  GstQueue2 *queue = GST_QUEUE2 (element);

  /* simply forward to the srcpad query function */
  return gst_queue2_handle_src_query (queue->srcpad, GST_OBJECT_CAST (element),
      query);
}

static void
gst_queue2_update_upstream_size (GstQueue2 * queue)
{
  gint64 upstream_size = -1;

  if (gst_pad_peer_query_duration (queue->sinkpad, GST_FORMAT_BYTES,
          &upstream_size)) {
    GST_INFO_OBJECT (queue, "upstream size: %" G_GINT64_FORMAT, upstream_size);
    queue->upstream_size = upstream_size;
  }
}

static GstFlowReturn
gst_queue2_get_range (GstPad * pad, GstObject * parent, guint64 offset,
    guint length, GstBuffer ** buffer)
{
  GstQueue2 *queue;
  GstFlowReturn ret;

  queue = GST_QUEUE2_CAST (parent);

  length = (length == -1) ? DEFAULT_BUFFER_SIZE : length;
  GST_QUEUE2_MUTEX_LOCK_CHECK (queue, queue->srcresult, out_flushing);
  offset = (offset == -1) ? queue->current->reading_pos : offset;

  GST_DEBUG_OBJECT (queue,
      "Getting range: offset %" G_GUINT64_FORMAT ", length %u", offset, length);

  /* catch any reads beyond the size of the file here to make sure queue2
   * doesn't send seek events beyond the size of the file upstream, since
   * that would confuse elements such as souphttpsrc and/or http servers.
   * Demuxers often just loop until EOS at the end of the file to figure out
   * when they've read all the end-headers or index chunks. */
  if (G_UNLIKELY (offset >= queue->upstream_size)) {
    gst_queue2_update_upstream_size (queue);
    if (queue->upstream_size > 0 && offset >= queue->upstream_size)
      goto out_unexpected;
  }

  if (G_UNLIKELY (offset + length > queue->upstream_size)) {
    gst_queue2_update_upstream_size (queue);
    if (queue->upstream_size > 0 && offset + length >= queue->upstream_size) {
      length = queue->upstream_size - offset;
      GST_DEBUG_OBJECT (queue, "adjusting length downto %d", length);
    }
  }

  /* FIXME - function will block when the range is not yet available */
  ret = gst_queue2_create_read (queue, offset, length, buffer);
  GST_QUEUE2_MUTEX_UNLOCK (queue);

  return ret;

  /* ERRORS */
out_flushing:
  {
    ret = queue->srcresult;

    GST_DEBUG_OBJECT (queue, "we are flushing");
    GST_QUEUE2_MUTEX_UNLOCK (queue);
    return ret;
  }
out_unexpected:
  {
    GST_DEBUG_OBJECT (queue, "read beyond end of file");
    GST_QUEUE2_MUTEX_UNLOCK (queue);
    return GST_FLOW_EOS;
  }
}

/* sink currently only operates in push mode */
static gboolean
gst_queue2_sink_activate_mode (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active)
{
  gboolean result;
  GstQueue2 *queue;

  queue = GST_QUEUE2 (parent);

  switch (mode) {
    case GST_PAD_MODE_PUSH:
      if (active) {
        GST_QUEUE2_MUTEX_LOCK (queue);
        GST_DEBUG_OBJECT (queue, "activating push mode");
        queue->srcresult = GST_FLOW_OK;
        queue->sinkresult = GST_FLOW_OK;
        queue->is_eos = FALSE;
        queue->unexpected = FALSE;
        reset_rate_timer (queue);
        GST_QUEUE2_MUTEX_UNLOCK (queue);
      } else {
        /* unblock chain function */
        GST_QUEUE2_MUTEX_LOCK (queue);
        GST_DEBUG_OBJECT (queue, "deactivating push mode");
        queue->srcresult = GST_FLOW_FLUSHING;
        queue->sinkresult = GST_FLOW_FLUSHING;
        GST_QUEUE2_SIGNAL_DEL (queue);
        /* Unblock query handler */
        queue->last_query = FALSE;
        g_cond_signal (&queue->query_handled);
        GST_QUEUE2_MUTEX_UNLOCK (queue);

        /* wait until it is unblocked and clean up */
        GST_PAD_STREAM_LOCK (pad);
        GST_QUEUE2_MUTEX_LOCK (queue);
        gst_queue2_locked_flush (queue, TRUE, FALSE);
        GST_QUEUE2_MUTEX_UNLOCK (queue);
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

/* src operating in push mode, we start a task on the source pad that pushes out
 * buffers from the queue */
static gboolean
gst_queue2_src_activate_push (GstPad * pad, GstObject * parent, gboolean active)
{
  gboolean result = FALSE;
  GstQueue2 *queue;

  queue = GST_QUEUE2 (parent);

  if (active) {
    GST_QUEUE2_MUTEX_LOCK (queue);
    GST_DEBUG_OBJECT (queue, "activating push mode");
    queue->srcresult = GST_FLOW_OK;
    queue->sinkresult = GST_FLOW_OK;
    queue->is_eos = FALSE;
    queue->unexpected = FALSE;
    result =
        gst_pad_start_task (pad, (GstTaskFunction) gst_queue2_loop, pad, NULL);
    GST_QUEUE2_MUTEX_UNLOCK (queue);
  } else {
    /* unblock loop function */
    GST_QUEUE2_MUTEX_LOCK (queue);
    GST_DEBUG_OBJECT (queue, "deactivating push mode");
    queue->srcresult = GST_FLOW_FLUSHING;
    queue->sinkresult = GST_FLOW_FLUSHING;
    /* the item add signal will unblock */
    GST_QUEUE2_SIGNAL_ADD (queue);
    GST_QUEUE2_MUTEX_UNLOCK (queue);

    /* step 2, make sure streaming finishes */
    result = gst_pad_stop_task (pad);
  }

  return result;
}

/* pull mode, downstream will call our getrange function */
static gboolean
gst_queue2_src_activate_pull (GstPad * pad, GstObject * parent, gboolean active)
{
  gboolean result;
  GstQueue2 *queue;

  queue = GST_QUEUE2 (parent);

  if (active) {
    GST_QUEUE2_MUTEX_LOCK (queue);
    if (!QUEUE_IS_USING_QUEUE (queue)) {
      if (QUEUE_IS_USING_TEMP_FILE (queue)) {
        /* open the temp file now */
        result = gst_queue2_open_temp_location_file (queue);
      } else if (!queue->ring_buffer) {
        queue->ring_buffer = g_malloc (queue->ring_buffer_max_size);
        result = ! !queue->ring_buffer;
      } else {
        result = TRUE;
      }

      GST_DEBUG_OBJECT (queue, "activating pull mode");
      init_ranges (queue);
      queue->srcresult = GST_FLOW_OK;
      queue->sinkresult = GST_FLOW_OK;
      queue->is_eos = FALSE;
      queue->unexpected = FALSE;
      queue->upstream_size = 0;
    } else {
      GST_DEBUG_OBJECT (queue, "no temp file, cannot activate pull mode");
      /* this is not allowed, we cannot operate in pull mode without a temp
       * file. */
      queue->srcresult = GST_FLOW_FLUSHING;
      queue->sinkresult = GST_FLOW_FLUSHING;
      result = FALSE;
    }
    GST_QUEUE2_MUTEX_UNLOCK (queue);
  } else {
    GST_QUEUE2_MUTEX_LOCK (queue);
    GST_DEBUG_OBJECT (queue, "deactivating pull mode");
    queue->srcresult = GST_FLOW_FLUSHING;
    queue->sinkresult = GST_FLOW_FLUSHING;
    /* this will unlock getrange */
    GST_QUEUE2_SIGNAL_ADD (queue);
    result = TRUE;
    GST_QUEUE2_MUTEX_UNLOCK (queue);
  }

  return result;
}

static gboolean
gst_queue2_src_activate_mode (GstPad * pad, GstObject * parent, GstPadMode mode,
    gboolean active)
{
  gboolean res;

  switch (mode) {
    case GST_PAD_MODE_PULL:
      res = gst_queue2_src_activate_pull (pad, parent, active);
      break;
    case GST_PAD_MODE_PUSH:
      res = gst_queue2_src_activate_push (pad, parent, active);
      break;
    default:
      GST_LOG_OBJECT (pad, "unknown activation mode %d", mode);
      res = FALSE;
      break;
  }
  return res;
}

static GstStateChangeReturn
gst_queue2_change_state (GstElement * element, GstStateChange transition)
{
  GstQueue2 *queue;
  GstStateChangeReturn ret = GST_STATE_CHANGE_SUCCESS;

  queue = GST_QUEUE2 (element);

  switch (transition) {
    case GST_STATE_CHANGE_NULL_TO_READY:
      break;
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      GST_QUEUE2_MUTEX_LOCK (queue);
      if (!QUEUE_IS_USING_QUEUE (queue)) {
        if (QUEUE_IS_USING_TEMP_FILE (queue)) {
          if (!gst_queue2_open_temp_location_file (queue))
            ret = GST_STATE_CHANGE_FAILURE;
        } else {
          if (queue->ring_buffer) {
            g_free (queue->ring_buffer);
            queue->ring_buffer = NULL;
          }
          if (!(queue->ring_buffer = g_malloc (queue->ring_buffer_max_size)))
            ret = GST_STATE_CHANGE_FAILURE;
        }
        init_ranges (queue);
      }
      queue->segment_event_received = FALSE;
      queue->starting_segment = NULL;
      gst_event_replace (&queue->stream_start_event, NULL);
      GST_QUEUE2_MUTEX_UNLOCK (queue);
      break;
    case GST_STATE_CHANGE_PAUSED_TO_PLAYING:
      break;
    default:
      break;
  }

  if (ret == GST_STATE_CHANGE_FAILURE)
    return ret;

  ret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);

  if (ret == GST_STATE_CHANGE_FAILURE)
    return ret;

  switch (transition) {
    case GST_STATE_CHANGE_PLAYING_TO_PAUSED:
      break;
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      GST_QUEUE2_MUTEX_LOCK (queue);
      if (!QUEUE_IS_USING_QUEUE (queue)) {
        if (QUEUE_IS_USING_TEMP_FILE (queue)) {
          gst_queue2_close_temp_location_file (queue);
        } else if (queue->ring_buffer) {
          g_free (queue->ring_buffer);
          queue->ring_buffer = NULL;
        }
        clean_ranges (queue);
      }
      if (queue->starting_segment != NULL) {
        gst_event_unref (queue->starting_segment);
        queue->starting_segment = NULL;
      }
      gst_event_replace (&queue->stream_start_event, NULL);
      GST_QUEUE2_MUTEX_UNLOCK (queue);
      break;
    case GST_STATE_CHANGE_READY_TO_NULL:
      break;
    default:
      break;
  }

  return ret;
}

/* changing the capacity of the queue must wake up
 * the _chain function, it might have more room now
 * to store the buffer/event in the queue */
#define QUEUE_CAPACITY_CHANGE(q) \
  GST_QUEUE2_SIGNAL_DEL (queue); \
  if (queue->use_buffering)      \
    update_buffering (queue);

/* Changing the minimum required fill level must
 * wake up the _loop function as it might now
 * be able to preceed.
 */
#define QUEUE_THRESHOLD_CHANGE(q)\
  GST_QUEUE2_SIGNAL_ADD (queue);

static void
gst_queue2_set_temp_template (GstQueue2 * queue, const gchar * template)
{
  GstState state;

  /* the element must be stopped in order to do this */
  GST_OBJECT_LOCK (queue);
  state = GST_STATE (queue);
  if (state != GST_STATE_READY && state != GST_STATE_NULL)
    goto wrong_state;
  GST_OBJECT_UNLOCK (queue);

  /* set new location */
  g_free (queue->temp_template);
  queue->temp_template = g_strdup (template);

  return;

/* ERROR */
wrong_state:
  {
    GST_WARNING_OBJECT (queue, "setting temp-template property in wrong state");
    GST_OBJECT_UNLOCK (queue);
  }
}

static void
gst_queue2_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec)
{
  GstQueue2 *queue = GST_QUEUE2 (object);

  /* someone could change levels here, and since this
   * affects the get/put funcs, we need to lock for safety. */
  GST_QUEUE2_MUTEX_LOCK (queue);

  switch (prop_id) {
    case PROP_MAX_SIZE_BYTES:
      queue->max_level.bytes = g_value_get_uint (value);
      QUEUE_CAPACITY_CHANGE (queue);
      break;
    case PROP_MAX_SIZE_BUFFERS:
      queue->max_level.buffers = g_value_get_uint (value);
      QUEUE_CAPACITY_CHANGE (queue);
      break;
    case PROP_MAX_SIZE_TIME:
      queue->max_level.time = g_value_get_uint64 (value);
      /* set rate_time to the same value. We use an extra field in the level
       * structure so that we can easily access and compare it */
      queue->max_level.rate_time = queue->max_level.time;
      QUEUE_CAPACITY_CHANGE (queue);
      break;
    case PROP_USE_BUFFERING:
      queue->use_buffering = g_value_get_boolean (value);
      if (!queue->use_buffering && queue->is_buffering) {
        GstMessage *msg = gst_message_new_buffering (GST_OBJECT_CAST (queue),
            100);

        GST_DEBUG_OBJECT (queue, "Disabled buffering while buffering, "
            "posting 100%% message");
        queue->is_buffering = FALSE;
        gst_element_post_message (GST_ELEMENT_CAST (queue), msg);
      }

      if (queue->use_buffering) {
        queue->is_buffering = TRUE;
        update_buffering (queue);
      }
      break;
    case PROP_USE_RATE_ESTIMATE:
      queue->use_rate_estimate = g_value_get_boolean (value);
      break;
    case PROP_LOW_PERCENT:
      queue->low_percent = g_value_get_int (value);
      break;
    case PROP_HIGH_PERCENT:
      queue->high_percent = g_value_get_int (value);
      break;
    case PROP_TEMP_TEMPLATE:
      gst_queue2_set_temp_template (queue, g_value_get_string (value));
      break;
    case PROP_TEMP_REMOVE:
      queue->temp_remove = g_value_get_boolean (value);
      break;
    case PROP_RING_BUFFER_MAX_SIZE:
      queue->ring_buffer_max_size = g_value_get_uint64 (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }

  GST_QUEUE2_MUTEX_UNLOCK (queue);
}

static void
gst_queue2_get_property (GObject * object,
    guint prop_id, GValue * value, GParamSpec * pspec)
{
  GstQueue2 *queue = GST_QUEUE2 (object);

  GST_QUEUE2_MUTEX_LOCK (queue);

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
      g_value_set_uint (value, queue->max_level.bytes);
      break;
    case PROP_MAX_SIZE_BUFFERS:
      g_value_set_uint (value, queue->max_level.buffers);
      break;
    case PROP_MAX_SIZE_TIME:
      g_value_set_uint64 (value, queue->max_level.time);
      break;
    case PROP_USE_BUFFERING:
      g_value_set_boolean (value, queue->use_buffering);
      break;
    case PROP_USE_RATE_ESTIMATE:
      g_value_set_boolean (value, queue->use_rate_estimate);
      break;
    case PROP_LOW_PERCENT:
      g_value_set_int (value, queue->low_percent);
      break;
    case PROP_HIGH_PERCENT:
      g_value_set_int (value, queue->high_percent);
      break;
    case PROP_TEMP_TEMPLATE:
      g_value_set_string (value, queue->temp_template);
      break;
    case PROP_TEMP_LOCATION:
      g_value_set_string (value, queue->temp_location);
      break;
    case PROP_TEMP_REMOVE:
      g_value_set_boolean (value, queue->temp_remove);
      break;
    case PROP_RING_BUFFER_MAX_SIZE:
      g_value_set_uint64 (value, queue->ring_buffer_max_size);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }

  GST_QUEUE2_MUTEX_UNLOCK (queue);
}
