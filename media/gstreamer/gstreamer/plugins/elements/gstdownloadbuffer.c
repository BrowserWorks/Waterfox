/* GStreamer
 * Copyright (C) 2014 Wim Taymans <wim.taymans@gmail.com>
 *
 * gstdownloadbuffer.c:
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
 * SECTION:element-downloadbuffer
 *
 * The downloadbuffer element provides on-disk buffering and caching of, typically,
 * a network file. temp-template should be set to a value such as
 * /tmp/gstreamer-XXXXXX and the element will allocate a random free filename and
 * buffer the data in the file.
 *
 * With max-size-bytes and max-size-time you can configure the buffering limits.
 * The downloadbuffer element will try to read-ahead these amounts of data. When
 * the amount of read-ahead data drops below low-percent of the configured max,
 * the element will start emiting BUFFERING messages until high-percent of max is
 * reached again.
 *
 * The downloadbuffer provides push and pull based scheduling on its source pad
 * and will efficiently seek in the upstream element when needed.
 *
 * The temp-location property will be used to notify the application of the
 * allocated filename.
 *
 * When the downloadbuffer has completely downloaded the media, it will
 * post an application message named  <classname>&quot;GstCacheDownloadComplete&quot;</classname>
 * with the following information:
 * <itemizedlist>
 * <listitem>
 *   <para>
 *   G_TYPE_STRING
 *   <classname>&quot;location&quot;</classname>:
 *   the location of the completely downloaded file.
 *   </para>
 * </listitem>
 * </itemizedlist>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gstdownloadbuffer.h"

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

GST_DEBUG_CATEGORY_STATIC (downloadbuffer_debug);
#define GST_CAT_DEFAULT (downloadbuffer_debug)

enum
{
  LAST_SIGNAL
};

/* other defines */
#define DEFAULT_BUFFER_SIZE 4096

/* default property values */
#define DEFAULT_MAX_SIZE_BYTES     (2 * 1024 * 1024)    /* 2 MB */
#define DEFAULT_MAX_SIZE_TIME      2 * GST_SECOND       /* 2 seconds */
#define DEFAULT_LOW_PERCENT        10
#define DEFAULT_HIGH_PERCENT       99
#define DEFAULT_TEMP_REMOVE        TRUE

enum
{
  PROP_0,
  PROP_MAX_SIZE_BYTES,
  PROP_MAX_SIZE_TIME,
  PROP_LOW_PERCENT,
  PROP_HIGH_PERCENT,
  PROP_TEMP_TEMPLATE,
  PROP_TEMP_LOCATION,
  PROP_TEMP_REMOVE,
  PROP_LAST
};

#define GST_DOWNLOAD_BUFFER_CLEAR_LEVEL(l) G_STMT_START {         \
  l.bytes = 0;                                          \
  l.time = 0;                                           \
} G_STMT_END

#define STATUS(elem, pad, msg) \
  GST_LOG_OBJECT (elem, "(%s:%s) " msg ": %u of %u " \
                      "bytes, %" G_GUINT64_FORMAT " of %" G_GUINT64_FORMAT \
                      " ns", \
                      GST_DEBUG_PAD_NAME (pad), \
                      elem->cur_level.bytes, \
                      elem->max_level.bytes, \
                      elem->cur_level.time, \
                      elem->max_level.time)

#define GST_DOWNLOAD_BUFFER_MUTEX_LOCK(q) G_STMT_START {                          \
  g_mutex_lock (&q->qlock);                                              \
} G_STMT_END

#define GST_DOWNLOAD_BUFFER_MUTEX_LOCK_CHECK(q,res,label) G_STMT_START {         \
  GST_DOWNLOAD_BUFFER_MUTEX_LOCK (q);                                            \
  if (res != GST_FLOW_OK)                                               \
    goto label;                                                         \
} G_STMT_END

#define GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK(q) G_STMT_START {                        \
  g_mutex_unlock (&q->qlock);                                            \
} G_STMT_END

#define GST_DOWNLOAD_BUFFER_WAIT_ADD_CHECK(q, res, o, label) G_STMT_START {       \
  STATUS (q, q->srcpad, "wait for ADD");                            \
  q->waiting_add = TRUE;                                                \
  q->waiting_offset = o;                                                \
  g_cond_wait (&q->item_add, &q->qlock);                                \
  q->waiting_add = FALSE;                                               \
  if (res != GST_FLOW_OK) {                                             \
    STATUS (q, q->srcpad, "received ADD wakeup");                   \
    goto label;                                                         \
  }                                                                     \
  STATUS (q, q->srcpad, "received ADD");                            \
} G_STMT_END

#define GST_DOWNLOAD_BUFFER_SIGNAL_ADD(q, o) G_STMT_START {                       \
  if (q->waiting_add && q->waiting_offset <= o) {                       \
    STATUS (q, q->sinkpad, "signal ADD");                               \
    g_cond_signal (&q->item_add);                                       \
  }                                                                     \
} G_STMT_END

#define _do_init \
    GST_DEBUG_CATEGORY_INIT (downloadbuffer_debug, "downloadbuffer", 0, \
        "downloadbuffer element");

#define gst_download_buffer_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstDownloadBuffer, gst_download_buffer,
    GST_TYPE_ELEMENT, _do_init);

static void update_buffering (GstDownloadBuffer * dlbuf);

static void gst_download_buffer_finalize (GObject * object);

static void gst_download_buffer_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec);
static void gst_download_buffer_get_property (GObject * object,
    guint prop_id, GValue * value, GParamSpec * pspec);

static GstFlowReturn gst_download_buffer_chain (GstPad * pad,
    GstObject * parent, GstBuffer * buffer);
static void gst_download_buffer_loop (GstPad * pad);

static gboolean gst_download_buffer_handle_sink_event (GstPad * pad,
    GstObject * parent, GstEvent * event);
static gboolean gst_download_buffer_handle_sink_query (GstPad * pad,
    GstObject * parent, GstQuery * query);

static gboolean gst_download_buffer_handle_src_event (GstPad * pad,
    GstObject * parent, GstEvent * event);
static gboolean gst_download_buffer_handle_src_query (GstPad * pad,
    GstObject * parent, GstQuery * query);
static gboolean gst_download_buffer_handle_query (GstElement * element,
    GstQuery * query);

static GstFlowReturn gst_download_buffer_get_range (GstPad * pad,
    GstObject * parent, guint64 offset, guint length, GstBuffer ** buffer);

static gboolean gst_download_buffer_src_activate_mode (GstPad * pad,
    GstObject * parent, GstPadMode mode, gboolean active);
static gboolean gst_download_buffer_sink_activate_mode (GstPad * pad,
    GstObject * parent, GstPadMode mode, gboolean active);
static GstStateChangeReturn gst_download_buffer_change_state (GstElement *
    element, GstStateChange transition);

/* static guint gst_download_buffer_signals[LAST_SIGNAL] = { 0 }; */

static void
gst_download_buffer_class_init (GstDownloadBufferClass * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);
  GstElementClass *gstelement_class = GST_ELEMENT_CLASS (klass);

  gobject_class->set_property = gst_download_buffer_set_property;
  gobject_class->get_property = gst_download_buffer_get_property;

  /* properties */
  g_object_class_install_property (gobject_class, PROP_MAX_SIZE_BYTES,
      g_param_spec_uint ("max-size-bytes", "Max. size (kB)",
          "Max. amount of data to buffer (bytes, 0=disable)",
          0, G_MAXUINT, DEFAULT_MAX_SIZE_BYTES,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_MAX_SIZE_TIME,
      g_param_spec_uint64 ("max-size-time", "Max. size (ns)",
          "Max. amount of data to buffer (in ns, 0=disable)", 0, G_MAXUINT64,
          DEFAULT_MAX_SIZE_TIME, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

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
   * GstDownloadBuffer:temp-remove
   *
   * When temp-template is set, remove the temporary file when going to READY.
   */
  g_object_class_install_property (gobject_class, PROP_TEMP_REMOVE,
      g_param_spec_boolean ("temp-remove", "Remove the Temporary File",
          "Remove the temp-location after use",
          DEFAULT_TEMP_REMOVE, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /* set several parent class virtual functions */
  gobject_class->finalize = gst_download_buffer_finalize;

  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&srctemplate));
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&sinktemplate));

  gst_element_class_set_static_metadata (gstelement_class, "DownloadBuffer",
      "Generic", "Download Buffer element",
      "Wim Taymans <wim.taymans@gmail.com>");

  gstelement_class->change_state =
      GST_DEBUG_FUNCPTR (gst_download_buffer_change_state);
  gstelement_class->query =
      GST_DEBUG_FUNCPTR (gst_download_buffer_handle_query);
}

static void
gst_download_buffer_init (GstDownloadBuffer * dlbuf)
{
  dlbuf->sinkpad = gst_pad_new_from_static_template (&sinktemplate, "sink");

  gst_pad_set_chain_function (dlbuf->sinkpad,
      GST_DEBUG_FUNCPTR (gst_download_buffer_chain));
  gst_pad_set_activatemode_function (dlbuf->sinkpad,
      GST_DEBUG_FUNCPTR (gst_download_buffer_sink_activate_mode));
  gst_pad_set_event_function (dlbuf->sinkpad,
      GST_DEBUG_FUNCPTR (gst_download_buffer_handle_sink_event));
  gst_pad_set_query_function (dlbuf->sinkpad,
      GST_DEBUG_FUNCPTR (gst_download_buffer_handle_sink_query));
  GST_PAD_SET_PROXY_CAPS (dlbuf->sinkpad);
  gst_element_add_pad (GST_ELEMENT (dlbuf), dlbuf->sinkpad);

  dlbuf->srcpad = gst_pad_new_from_static_template (&srctemplate, "src");

  gst_pad_set_activatemode_function (dlbuf->srcpad,
      GST_DEBUG_FUNCPTR (gst_download_buffer_src_activate_mode));
  gst_pad_set_getrange_function (dlbuf->srcpad,
      GST_DEBUG_FUNCPTR (gst_download_buffer_get_range));
  gst_pad_set_event_function (dlbuf->srcpad,
      GST_DEBUG_FUNCPTR (gst_download_buffer_handle_src_event));
  gst_pad_set_query_function (dlbuf->srcpad,
      GST_DEBUG_FUNCPTR (gst_download_buffer_handle_src_query));
  GST_PAD_SET_PROXY_CAPS (dlbuf->srcpad);
  gst_element_add_pad (GST_ELEMENT (dlbuf), dlbuf->srcpad);

  /* levels */
  GST_DOWNLOAD_BUFFER_CLEAR_LEVEL (dlbuf->cur_level);
  dlbuf->max_level.bytes = DEFAULT_MAX_SIZE_BYTES;
  dlbuf->max_level.time = DEFAULT_MAX_SIZE_TIME;
  dlbuf->low_percent = DEFAULT_LOW_PERCENT;
  dlbuf->high_percent = DEFAULT_HIGH_PERCENT;

  dlbuf->srcresult = GST_FLOW_FLUSHING;
  dlbuf->sinkresult = GST_FLOW_FLUSHING;
  dlbuf->in_timer = g_timer_new ();
  dlbuf->out_timer = g_timer_new ();

  g_mutex_init (&dlbuf->qlock);
  dlbuf->waiting_add = FALSE;
  g_cond_init (&dlbuf->item_add);

  /* tempfile related */
  dlbuf->temp_template = NULL;
  dlbuf->temp_location = NULL;
  dlbuf->temp_remove = DEFAULT_TEMP_REMOVE;
}

/* called only once, as opposed to dispose */
static void
gst_download_buffer_finalize (GObject * object)
{
  GstDownloadBuffer *dlbuf = GST_DOWNLOAD_BUFFER (object);

  g_mutex_clear (&dlbuf->qlock);
  g_cond_clear (&dlbuf->item_add);
  g_timer_destroy (dlbuf->in_timer);
  g_timer_destroy (dlbuf->out_timer);

  /* temp_file path cleanup  */
  g_free (dlbuf->temp_template);
  g_free (dlbuf->temp_location);

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

static void
reset_positions (GstDownloadBuffer * dlbuf)
{
  dlbuf->write_pos = 0;
  dlbuf->read_pos = 0;
  dlbuf->filling = TRUE;
  dlbuf->buffering_percent = 0;
  dlbuf->is_buffering = TRUE;
  dlbuf->seeking = FALSE;
  GST_DOWNLOAD_BUFFER_CLEAR_LEVEL (dlbuf->cur_level);
}

static void
reset_rate_timer (GstDownloadBuffer * dlbuf)
{
  dlbuf->bytes_in = 0;
  dlbuf->bytes_out = 0;
  dlbuf->byte_in_rate = 0.0;
  dlbuf->byte_in_period = 0;
  dlbuf->byte_out_rate = 0.0;
  dlbuf->last_in_elapsed = 0.0;
  dlbuf->last_out_elapsed = 0.0;
  dlbuf->in_timer_started = FALSE;
  dlbuf->out_timer_started = FALSE;
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
update_time_level (GstDownloadBuffer * dlbuf)
{
  if (dlbuf->byte_in_rate > 0.0) {
    dlbuf->cur_level.time =
        dlbuf->cur_level.bytes / dlbuf->byte_in_rate * GST_SECOND;
  }
  GST_DEBUG ("levels: bytes %u/%u, time %" GST_TIME_FORMAT "/%" GST_TIME_FORMAT,
      dlbuf->cur_level.bytes, dlbuf->max_level.bytes,
      GST_TIME_ARGS (dlbuf->cur_level.time),
      GST_TIME_ARGS (dlbuf->max_level.time));
  /* update the buffering */
  update_buffering (dlbuf);
}

static void
update_levels (GstDownloadBuffer * dlbuf, guint bytes)
{
  dlbuf->cur_level.bytes = bytes;
  update_time_level (dlbuf);
}

static void
update_in_rates (GstDownloadBuffer * dlbuf)
{
  gdouble elapsed, period;
  gdouble byte_in_rate;

  if (!dlbuf->in_timer_started) {
    dlbuf->in_timer_started = TRUE;
    g_timer_start (dlbuf->in_timer);
    return;
  }

  elapsed = g_timer_elapsed (dlbuf->in_timer, NULL);

  /* recalc after each interval. */
  if (dlbuf->last_in_elapsed + RATE_INTERVAL < elapsed) {
    period = elapsed - dlbuf->last_in_elapsed;

    GST_DEBUG_OBJECT (dlbuf,
        "rates: period %f, in %" G_GUINT64_FORMAT ", global period %f",
        period, dlbuf->bytes_in, dlbuf->byte_in_period);

    byte_in_rate = dlbuf->bytes_in / period;

    if (dlbuf->byte_in_rate == 0.0)
      dlbuf->byte_in_rate = byte_in_rate;
    else
      dlbuf->byte_in_rate = AVG_IN (dlbuf->byte_in_rate, byte_in_rate,
          (double) dlbuf->byte_in_period, period);

    /* another data point, cap at 16 for long time running average */
    if (dlbuf->byte_in_period < 16 * RATE_INTERVAL)
      dlbuf->byte_in_period += period;

    /* reset the values to calculate rate over the next interval */
    dlbuf->last_in_elapsed = elapsed;
    dlbuf->bytes_in = 0;
    GST_DEBUG_OBJECT (dlbuf, "rates: in %f", dlbuf->byte_in_rate);
  }
}

static void
update_out_rates (GstDownloadBuffer * dlbuf)
{
  gdouble elapsed, period;
  gdouble byte_out_rate;

  if (!dlbuf->out_timer_started) {
    dlbuf->out_timer_started = TRUE;
    g_timer_start (dlbuf->out_timer);
    return;
  }

  elapsed = g_timer_elapsed (dlbuf->out_timer, NULL);

  /* recalc after each interval. */
  if (dlbuf->last_out_elapsed + RATE_INTERVAL < elapsed) {
    period = elapsed - dlbuf->last_out_elapsed;

    GST_DEBUG_OBJECT (dlbuf,
        "rates: period %f, out %" G_GUINT64_FORMAT, period, dlbuf->bytes_out);

    byte_out_rate = dlbuf->bytes_out / period;

    if (dlbuf->byte_out_rate == 0.0)
      dlbuf->byte_out_rate = byte_out_rate;
    else
      dlbuf->byte_out_rate = AVG_OUT (dlbuf->byte_out_rate, byte_out_rate);

    /* reset the values to calculate rate over the next interval */
    dlbuf->last_out_elapsed = elapsed;
    dlbuf->bytes_out = 0;
    GST_DEBUG_OBJECT (dlbuf, "rates: out %f", dlbuf->byte_out_rate);
  }
}

static gboolean
get_buffering_percent (GstDownloadBuffer * dlbuf, gboolean * is_buffering,
    gint * percent)
{
  gint perc;

  if (dlbuf->high_percent <= 0) {
    if (percent)
      *percent = 100;
    if (is_buffering)
      *is_buffering = FALSE;
    return FALSE;
  }

  /* Ensure the variables used to calculate buffering state are up-to-date. */
  update_in_rates (dlbuf);
  update_out_rates (dlbuf);

  /* figure out the percent we are filled, we take the max of all formats. */
  if (dlbuf->max_level.bytes > 0) {
    if (dlbuf->cur_level.bytes >= dlbuf->max_level.bytes)
      perc = 100;
    else
      perc = dlbuf->cur_level.bytes * 100 / dlbuf->max_level.bytes;
  } else
    perc = 0;

  if (dlbuf->max_level.time > 0) {
    if (dlbuf->cur_level.time >= dlbuf->max_level.time)
      perc = 100;
    else
      perc = MAX (perc, dlbuf->cur_level.time * 100 / dlbuf->max_level.time);
  } else
    perc = MAX (0, perc);

  if (is_buffering)
    *is_buffering = dlbuf->is_buffering;

  /* scale to high percent so that it becomes the 100% mark */
  perc = perc * 100 / dlbuf->high_percent;
  /* clip */
  if (perc > 100)
    perc = 100;

  if (percent)
    *percent = perc;

  GST_DEBUG_OBJECT (dlbuf, "buffering %d, percent %d", dlbuf->is_buffering,
      perc);

  return TRUE;
}

static void
get_buffering_stats (GstDownloadBuffer * dlbuf, gint percent,
    GstBufferingMode * mode, gint * avg_in, gint * avg_out,
    gint64 * buffering_left)
{
  if (mode)
    *mode = GST_BUFFERING_DOWNLOAD;

  if (avg_in)
    *avg_in = dlbuf->byte_in_rate;
  if (avg_out)
    *avg_out = dlbuf->byte_out_rate;

  if (buffering_left) {
    guint64 max, cur;

    *buffering_left = (percent == 100 ? 0 : -1);

    max = dlbuf->max_level.time;
    cur = dlbuf->cur_level.time;

    if (percent != 100 && max > cur)
      *buffering_left = (max - cur) / 1000000;
  }
}

static void
update_buffering (GstDownloadBuffer * dlbuf)
{
  gint percent;
  gboolean post = FALSE;

  if (!get_buffering_percent (dlbuf, NULL, &percent))
    return;

  if (dlbuf->is_buffering) {
    post = TRUE;
    /* if we were buffering see if we reached the high watermark */
    if (percent >= dlbuf->high_percent)
      dlbuf->is_buffering = FALSE;
  } else {
    /* we were not buffering, check if we need to start buffering if we drop
     * below the low threshold */
    if (percent < dlbuf->low_percent) {
      dlbuf->is_buffering = TRUE;
      post = TRUE;
    }
  }

  if (post) {
    if (percent == dlbuf->buffering_percent)
      post = FALSE;
    else
      dlbuf->buffering_percent = percent;
  }

  if (post) {
    GstMessage *message;
    GstBufferingMode mode;
    gint avg_in, avg_out;
    gint64 buffering_left;

    get_buffering_stats (dlbuf, percent, &mode, &avg_in, &avg_out,
        &buffering_left);

    message = gst_message_new_buffering (GST_OBJECT_CAST (dlbuf),
        (gint) percent);
    gst_message_set_buffering_stats (message, mode,
        avg_in, avg_out, buffering_left);

    gst_element_post_message (GST_ELEMENT_CAST (dlbuf), message);
  }
}

static gboolean
perform_seek_to_offset (GstDownloadBuffer * dlbuf, guint64 offset)
{
  GstEvent *event;
  gboolean res;

  if (dlbuf->seeking)
    return TRUE;

  /* until we receive the FLUSH_STOP from this seek, we skip data */
  dlbuf->seeking = TRUE;
  dlbuf->write_pos = offset;
  dlbuf->filling = FALSE;
  GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);

  GST_DEBUG_OBJECT (dlbuf, "Seeking to %" G_GUINT64_FORMAT, offset);

  event =
      gst_event_new_seek (1.0, GST_FORMAT_BYTES,
      GST_SEEK_FLAG_FLUSH | GST_SEEK_FLAG_ACCURATE, GST_SEEK_TYPE_SET, offset,
      GST_SEEK_TYPE_NONE, -1);

  res = gst_pad_push_event (dlbuf->sinkpad, event);
  GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);

  return res;
}

/* get the threshold for when we decide to seek rather than wait */
static guint64
get_seek_threshold (GstDownloadBuffer * dlbuf)
{
  guint64 threshold;

  /* FIXME, find a good threshold based on the incoming rate. */
  threshold = 1024 * 512;

  return threshold;
}

/* called with DOWNLOAD_BUFFER_MUTEX */
static void
gst_download_buffer_update_upstream_size (GstDownloadBuffer * dlbuf)
{
  gint64 upstream_size = 0;

  if (gst_pad_peer_query_duration (dlbuf->sinkpad, GST_FORMAT_BYTES,
          &upstream_size)) {
    GST_INFO_OBJECT (dlbuf, "upstream size: %" G_GINT64_FORMAT, upstream_size);
    dlbuf->upstream_size = upstream_size;
  }
}

/* called with DOWNLOAD_BUFFER_MUTEX */
static GstFlowReturn
gst_download_buffer_wait_for_data (GstDownloadBuffer * dlbuf, guint64 offset,
    guint length)
{
  gsize start, stop;
  guint64 wanted;
  gboolean started;

  GST_DEBUG_OBJECT (dlbuf, "wait for %" G_GUINT64_FORMAT ", length %u",
      offset, length);

  wanted = offset + length;

  /* pause the timer while we wait. The fact that we are waiting does not mean
   * the byterate on the output pad is lower */
  if ((started = dlbuf->out_timer_started))
    g_timer_stop (dlbuf->out_timer);

  /* check range before us */
  if (gst_sparse_file_get_range_before (dlbuf->file, offset, &start, &stop)) {
    GST_DEBUG_OBJECT (dlbuf,
        "range before %" G_GSIZE_FORMAT " - %" G_GSIZE_FORMAT, start, stop);
    if (start <= offset && offset < stop) {
      GST_DEBUG_OBJECT (dlbuf, "we have the offset");
      /* we have the range, continue it */
      offset = stop;
    } else {
      guint64 threshold, dist;

      /* there is a range before us, check how far away it is */
      threshold = get_seek_threshold (dlbuf);
      dist = offset - stop;

      if (dist <= threshold) {
        GST_DEBUG_OBJECT (dlbuf, "not too far");
        /* not far away, continue it */
        offset = stop;
      }
    }
  }

  if (dlbuf->write_pos != offset)
    perform_seek_to_offset (dlbuf, offset);

  dlbuf->filling = TRUE;
  if (dlbuf->write_pos > dlbuf->read_pos)
    update_levels (dlbuf, dlbuf->write_pos - dlbuf->read_pos);
  else
    update_levels (dlbuf, 0);

  /* now wait for more data */
  GST_DEBUG_OBJECT (dlbuf, "waiting for more data");
  GST_DOWNLOAD_BUFFER_WAIT_ADD_CHECK (dlbuf, dlbuf->srcresult, wanted,
      out_flushing);
  GST_DEBUG_OBJECT (dlbuf, "got more data");

  /* and continue if we were running before */
  if (started)
    g_timer_continue (dlbuf->out_timer);

  return GST_FLOW_OK;

out_flushing:
  {
    GST_DEBUG_OBJECT (dlbuf, "we are flushing");
    return GST_FLOW_FLUSHING;
  }
}

/* called with DOWNLOAD_BUFFER_MUTEX */
static gboolean
check_upstream_size (GstDownloadBuffer * dlbuf, gsize offset, guint * length)
{
  gsize stop = offset + *length;
  /* catch any reads beyond the size of the file here to make sure cache
   * doesn't send seek events beyond the size of the file upstream, since
   * that would confuse elements such as souphttpsrc and/or http servers.
   * Demuxers often just loop until EOS at the end of the file to figure out
   * when they've read all the end-headers or index chunks. */
  if (G_UNLIKELY (dlbuf->upstream_size == -1 || stop >= dlbuf->upstream_size)) {
    gst_download_buffer_update_upstream_size (dlbuf);
  }

  if (dlbuf->upstream_size != -1) {
    if (offset >= dlbuf->upstream_size)
      return FALSE;

    if (G_UNLIKELY (stop > dlbuf->upstream_size)) {
      *length = dlbuf->upstream_size - offset;
      GST_DEBUG_OBJECT (dlbuf, "adjusting length downto %u", *length);
    }
  }
  return TRUE;
}

/* called with DOWNLOAD_BUFFER_MUTEX */
static GstFlowReturn
gst_download_buffer_read_buffer (GstDownloadBuffer * dlbuf, guint64 offset,
    guint length, GstBuffer ** buffer)
{
  GstBuffer *buf;
  GstMapInfo info;
  GstFlowReturn ret = GST_FLOW_OK;
  gsize res, remaining;
  GError *error = NULL;

  length = (length == -1) ? DEFAULT_BUFFER_SIZE : length;
  offset = (offset == -1) ? dlbuf->read_pos : offset;

  if (!check_upstream_size (dlbuf, offset, &length))
    goto hit_eos;

  /* allocate the output buffer of the requested size */
  if (*buffer == NULL)
    buf = gst_buffer_new_allocate (NULL, length, NULL);
  else
    buf = *buffer;

  gst_buffer_map (buf, &info, GST_MAP_WRITE);

  GST_DEBUG_OBJECT (dlbuf, "Reading %u bytes from %" G_GUINT64_FORMAT, length,
      offset);

  dlbuf->read_pos = offset;

  do {
    res =
        gst_sparse_file_read (dlbuf->file, offset, info.data, length,
        &remaining, &error);
    if (G_UNLIKELY (res == 0)) {
      switch (error->code) {
        case GST_SPARSE_FILE_IO_ERROR_WOULD_BLOCK:
          /* we don't have the requested data in the file, decide what to
           * do next. */
          ret = gst_download_buffer_wait_for_data (dlbuf, offset, length);
          if (ret != GST_FLOW_OK)
            goto out_flushing;
          break;
        default:
          goto read_error;
      }
      g_clear_error (&error);
    }
  } while (res == 0);

  gst_buffer_unmap (buf, &info);
  gst_buffer_resize (buf, 0, res);

  dlbuf->bytes_out += res;
  dlbuf->read_pos += res;

  GST_DEBUG_OBJECT (dlbuf,
      "Read %" G_GSIZE_FORMAT " bytes, remaining %" G_GSIZE_FORMAT, res,
      remaining);

  if (dlbuf->read_pos + remaining == dlbuf->upstream_size)
    update_levels (dlbuf, dlbuf->max_level.bytes);
  else
    update_levels (dlbuf, remaining);

  GST_BUFFER_OFFSET (buf) = offset;
  GST_BUFFER_OFFSET_END (buf) = offset + res;

  *buffer = buf;

  return ret;

  /* ERRORS */
hit_eos:
  {
    GST_DEBUG_OBJECT (dlbuf, "EOS hit");
    return GST_FLOW_EOS;
  }
out_flushing:
  {
    GST_DEBUG_OBJECT (dlbuf, "we are flushing");
    gst_buffer_unmap (buf, &info);
    if (*buffer == NULL)
      gst_buffer_unref (buf);
    return GST_FLOW_FLUSHING;
  }
read_error:
  {
    GST_DEBUG_OBJECT (dlbuf, "we have a read error: %s", error->message);
    g_clear_error (&error);
    gst_buffer_unmap (buf, &info);
    if (*buffer == NULL)
      gst_buffer_unref (buf);
    return ret;
  }
}

/* must be called with MUTEX_LOCK. Will briefly release the lock when notifying
 * the temp filename. */
static gboolean
gst_download_buffer_open_temp_location_file (GstDownloadBuffer * dlbuf)
{
  gint fd = -1;
  gchar *name = NULL;

  if (dlbuf->file)
    goto already_opened;

  GST_DEBUG_OBJECT (dlbuf, "opening temp file %s", dlbuf->temp_template);

  /* If temp_template was set, allocate a filename and open that filen */

  /* nothing to do */
  if (dlbuf->temp_template == NULL)
    goto no_directory;

  /* make copy of the template, we don't want to change this */
  name = g_strdup (dlbuf->temp_template);
  fd = g_mkstemp (name);
  if (fd == -1)
    goto mkstemp_failed;

  /* open the file for update/writing */
  dlbuf->file = gst_sparse_file_new ();
  /* error creating file */
  if (!gst_sparse_file_set_fd (dlbuf->file, fd))
    goto open_failed;

  g_free (dlbuf->temp_location);
  dlbuf->temp_location = name;
  dlbuf->temp_fd = fd;
  reset_positions (dlbuf);

  GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);

  /* we can't emit the notify with the lock */
  g_object_notify (G_OBJECT (dlbuf), "temp-location");

  GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);

  GST_DEBUG_OBJECT (dlbuf, "opened temp file %s", dlbuf->temp_template);

  return TRUE;

  /* ERRORS */
already_opened:
  {
    GST_DEBUG_OBJECT (dlbuf, "temp file was already open");
    return TRUE;
  }
no_directory:
  {
    GST_ELEMENT_ERROR (dlbuf, RESOURCE, NOT_FOUND,
        (_("No Temp directory specified.")), (NULL));
    return FALSE;
  }
mkstemp_failed:
  {
    GST_ELEMENT_ERROR (dlbuf, RESOURCE, OPEN_READ,
        (_("Could not create temp file \"%s\"."), dlbuf->temp_template),
        GST_ERROR_SYSTEM);
    g_free (name);
    return FALSE;
  }
open_failed:
  {
    GST_ELEMENT_ERROR (dlbuf, RESOURCE, OPEN_READ,
        (_("Could not open file \"%s\" for reading."), name), GST_ERROR_SYSTEM);
    g_free (name);
    if (fd != -1)
      close (fd);
    return FALSE;
  }
}

static void
gst_download_buffer_close_temp_location_file (GstDownloadBuffer * dlbuf)
{
  /* nothing to do */
  if (dlbuf->file == NULL)
    return;

  GST_DEBUG_OBJECT (dlbuf, "closing sparse file");

  if (dlbuf->temp_remove) {
    if (remove (dlbuf->temp_location) < 0) {
      GST_WARNING_OBJECT (dlbuf, "Failed to remove temporary file %s: %s",
          dlbuf->temp_location, g_strerror (errno));
    }
  }
  gst_sparse_file_free (dlbuf->file);
  close (dlbuf->temp_fd);
  dlbuf->file = NULL;
}

static void
gst_download_buffer_flush_temp_file (GstDownloadBuffer * dlbuf)
{
  if (dlbuf->file == NULL)
    return;

  GST_DEBUG_OBJECT (dlbuf, "flushing temp file");

  gst_sparse_file_clear (dlbuf->file);
}

static void
gst_download_buffer_locked_flush (GstDownloadBuffer * dlbuf, gboolean full,
    gboolean clear_temp)
{
  if (clear_temp)
    gst_download_buffer_flush_temp_file (dlbuf);
  reset_positions (dlbuf);
  gst_event_replace (&dlbuf->stream_start_event, NULL);
  gst_event_replace (&dlbuf->segment_event, NULL);
}

static gboolean
gst_download_buffer_handle_sink_event (GstPad * pad, GstObject * parent,
    GstEvent * event)
{
  gboolean ret = TRUE;
  GstDownloadBuffer *dlbuf;

  dlbuf = GST_DOWNLOAD_BUFFER (parent);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_FLUSH_START:
    {
      GST_LOG_OBJECT (dlbuf, "received flush start event");
      if (GST_PAD_MODE (dlbuf->srcpad) == GST_PAD_MODE_PUSH) {
        /* forward event */
        ret = gst_pad_push_event (dlbuf->srcpad, event);

        /* now unblock the chain function */
        GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);
        dlbuf->srcresult = GST_FLOW_FLUSHING;
        dlbuf->sinkresult = GST_FLOW_FLUSHING;
        /* unblock the loop and chain functions */
        GST_DOWNLOAD_BUFFER_SIGNAL_ADD (dlbuf, -1);
        GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);

        /* make sure it pauses, this should happen since we sent
         * flush_start downstream. */
        gst_pad_pause_task (dlbuf->srcpad);
        GST_LOG_OBJECT (dlbuf, "loop stopped");
      } else {
        GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);
        /* flush the sink pad */
        dlbuf->sinkresult = GST_FLOW_FLUSHING;
        GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);

        gst_event_unref (event);
      }
      break;
    }
    case GST_EVENT_FLUSH_STOP:
    {
      GST_LOG_OBJECT (dlbuf, "received flush stop event");

      if (GST_PAD_MODE (dlbuf->srcpad) == GST_PAD_MODE_PUSH) {
        /* forward event */
        ret = gst_pad_push_event (dlbuf->srcpad, event);

        GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);
        gst_download_buffer_locked_flush (dlbuf, FALSE, TRUE);
        dlbuf->srcresult = GST_FLOW_OK;
        dlbuf->sinkresult = GST_FLOW_OK;
        dlbuf->unexpected = FALSE;
        dlbuf->seeking = FALSE;
        /* reset rate counters */
        reset_rate_timer (dlbuf);
        gst_pad_start_task (dlbuf->srcpad,
            (GstTaskFunction) gst_download_buffer_loop, dlbuf->srcpad, NULL);
        GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);
      } else {
        GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);
        dlbuf->unexpected = FALSE;
        dlbuf->sinkresult = GST_FLOW_OK;
        dlbuf->seeking = FALSE;
        GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);

        gst_event_unref (event);
      }
      break;
    }
    default:
      if (GST_EVENT_IS_SERIALIZED (event)) {
        /* serialized events go in the buffer */
        GST_DOWNLOAD_BUFFER_MUTEX_LOCK_CHECK (dlbuf, dlbuf->sinkresult,
            out_flushing);
        switch (GST_EVENT_TYPE (event)) {
          case GST_EVENT_EOS:
            GST_DEBUG_OBJECT (dlbuf, "we have EOS");
            /* Zero the thresholds, this makes sure the dlbuf is completely
             * filled and we can read all data from the dlbuf. */
            /* update the buffering status */
            update_levels (dlbuf, dlbuf->max_level.bytes);
            /* wakeup the waiter and let it recheck */
            GST_DOWNLOAD_BUFFER_SIGNAL_ADD (dlbuf, -1);
            break;
          case GST_EVENT_SEGMENT:
            gst_event_replace (&dlbuf->segment_event, event);
            /* a new segment allows us to accept more buffers if we got EOS
             * from downstream */
            dlbuf->unexpected = FALSE;
            break;
          case GST_EVENT_STREAM_START:
            gst_event_replace (&dlbuf->stream_start_event, event);
            break;
          default:
            break;
        }
        gst_event_unref (event);
        GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);
      } else {
        /* non-serialized events are passed upstream. */
        ret = gst_pad_push_event (dlbuf->srcpad, event);
      }
      break;
  }
  return ret;

  /* ERRORS */
out_flushing:
  {
    GST_DEBUG_OBJECT (dlbuf, "refusing event, we are flushing");
    GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);
    gst_event_unref (event);
    return FALSE;
  }
}

static gboolean
gst_download_buffer_handle_sink_query (GstPad * pad, GstObject * parent,
    GstQuery * query)
{
  GstDownloadBuffer *dlbuf;
  gboolean res;

  dlbuf = GST_DOWNLOAD_BUFFER (parent);

  switch (GST_QUERY_TYPE (query)) {
    default:
      if (GST_QUERY_IS_SERIALIZED (query)) {
        GST_LOG_OBJECT (dlbuf, "received query %p", query);
        GST_DEBUG_OBJECT (dlbuf, "refusing query, we are not using the dlbuf");
        res = FALSE;
      } else {
        res = gst_pad_query_default (pad, parent, query);
      }
      break;
  }
  return res;
}

static GstFlowReturn
gst_download_buffer_chain (GstPad * pad, GstObject * parent, GstBuffer * buffer)
{
  GstDownloadBuffer *dlbuf;
  GstMapInfo info;
  guint64 offset;
  gsize res, available;
  GError *error = NULL;

  dlbuf = GST_DOWNLOAD_BUFFER (parent);

  GST_LOG_OBJECT (dlbuf, "received buffer %p of "
      "size %" G_GSIZE_FORMAT ", time %" GST_TIME_FORMAT ", duration %"
      GST_TIME_FORMAT, buffer, gst_buffer_get_size (buffer),
      GST_TIME_ARGS (GST_BUFFER_TIMESTAMP (buffer)),
      GST_TIME_ARGS (GST_BUFFER_DURATION (buffer)));

  /* we have to lock the dlbuf since we span threads */
  GST_DOWNLOAD_BUFFER_MUTEX_LOCK_CHECK (dlbuf, dlbuf->sinkresult, out_flushing);
  /* when we received unexpected from downstream, refuse more buffers */
  if (dlbuf->unexpected)
    goto out_eos;

  /* while we didn't receive the newsegment, we're seeking and we skip data */
  if (dlbuf->seeking)
    goto out_seeking;

  /* put buffer in dlbuf now */
  offset = dlbuf->write_pos;

  /* sanity check */
  if (GST_BUFFER_OFFSET_IS_VALID (buffer) &&
      GST_BUFFER_OFFSET (buffer) != offset) {
    GST_WARNING_OBJECT (dlbuf, "buffer offset does not match current writing "
        "position! %" G_GINT64_FORMAT " != %" G_GINT64_FORMAT,
        GST_BUFFER_OFFSET (buffer), offset);
  }

  gst_buffer_map (buffer, &info, GST_MAP_READ);

  GST_DEBUG_OBJECT (dlbuf, "Writing %" G_GSIZE_FORMAT " bytes to %"
      G_GUINT64_FORMAT, info.size, offset);

  res =
      gst_sparse_file_write (dlbuf->file, offset, info.data, info.size,
      &available, &error);
  if (res == 0)
    goto write_error;

  gst_buffer_unmap (buffer, &info);
  gst_buffer_unref (buffer);

  dlbuf->write_pos = offset + info.size;
  dlbuf->bytes_in += info.size;

  GST_DOWNLOAD_BUFFER_SIGNAL_ADD (dlbuf, dlbuf->write_pos + available);

  /* we hit the end, see what to do */
  if (dlbuf->write_pos + available == dlbuf->upstream_size) {
    gsize start, stop;

    /* we have everything up to the end, find a region to fill */
    if (gst_sparse_file_get_range_after (dlbuf->file, 0, &start, &stop)) {
      if (stop < dlbuf->upstream_size) {
        /* a hole to fill, seek to its end */
        perform_seek_to_offset (dlbuf, stop);
      } else {
        /* we filled all the holes, we are done */
        goto completed;
      }
    }
  } else {
    /* see if we need to skip this region or just read it again. The idea
     * is that when the region is not big, we want to avoid a seek and just
     * let it reread */
    guint64 threshold = get_seek_threshold (dlbuf);

    if (available > threshold) {
      /* further than threshold, it's better to skip than to reread */
      perform_seek_to_offset (dlbuf, dlbuf->write_pos + available);
    }
  }
  if (dlbuf->filling) {
    if (dlbuf->write_pos > dlbuf->read_pos)
      update_levels (dlbuf, dlbuf->write_pos - dlbuf->read_pos);
    else
      update_levels (dlbuf, 0);
  }

  GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);

  return GST_FLOW_OK;

  /* ERRORS */
out_flushing:
  {
    GstFlowReturn ret = dlbuf->sinkresult;
    GST_LOG_OBJECT (dlbuf,
        "exit because task paused, reason: %s", gst_flow_get_name (ret));
    GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);
    gst_buffer_unref (buffer);
    return ret;
  }
out_eos:
  {
    GST_LOG_OBJECT (dlbuf, "exit because we received EOS");
    GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);
    gst_buffer_unref (buffer);
    return GST_FLOW_EOS;
  }
out_seeking:
  {
    GST_LOG_OBJECT (dlbuf, "exit because we are seeking");
    GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);
    gst_buffer_unref (buffer);
    return GST_FLOW_OK;
  }
write_error:
  {
    gst_buffer_unmap (buffer, &info);
    gst_buffer_unref (buffer);
    GST_ELEMENT_ERROR (dlbuf, RESOURCE, WRITE,
        (_("Error while writing to download file.")), ("%s", error->message));
    g_clear_error (&error);
    return GST_FLOW_ERROR;
  }
completed:
  {
    GST_LOG_OBJECT (dlbuf, "we completed the download");
    dlbuf->write_pos = dlbuf->upstream_size;
    dlbuf->filling = FALSE;
    update_levels (dlbuf, dlbuf->max_level.bytes);
    gst_element_post_message (GST_ELEMENT_CAST (dlbuf),
        gst_message_new_element (GST_OBJECT_CAST (dlbuf),
            gst_structure_new ("GstCacheDownloadComplete",
                "location", G_TYPE_STRING, dlbuf->temp_location, NULL)));
    GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);

    return GST_FLOW_EOS;
  }
}

/* called repeatedly with @pad as the source pad. This function should push out
 * data to the peer element. */
static void
gst_download_buffer_loop (GstPad * pad)
{
  GstDownloadBuffer *dlbuf;
  GstFlowReturn ret;
  GstBuffer *buffer = NULL;

  dlbuf = GST_DOWNLOAD_BUFFER (GST_PAD_PARENT (pad));

  /* have to lock for thread-safety */
  GST_DOWNLOAD_BUFFER_MUTEX_LOCK_CHECK (dlbuf, dlbuf->srcresult, out_flushing);

  if (dlbuf->stream_start_event != NULL) {
    gst_pad_push_event (dlbuf->srcpad, dlbuf->stream_start_event);
    dlbuf->stream_start_event = NULL;
  }
  if (dlbuf->segment_event != NULL) {
    gst_pad_push_event (dlbuf->srcpad, dlbuf->segment_event);
    dlbuf->segment_event = NULL;
  }

  ret = gst_download_buffer_read_buffer (dlbuf, -1, -1, &buffer);
  if (ret != GST_FLOW_OK)
    goto out_flushing;

  g_atomic_int_set (&dlbuf->downstream_may_block, 1);
  GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);

  ret = gst_pad_push (dlbuf->srcpad, buffer);
  g_atomic_int_set (&dlbuf->downstream_may_block, 0);

  /* need to check for srcresult here as well */
  GST_DOWNLOAD_BUFFER_MUTEX_LOCK_CHECK (dlbuf, dlbuf->srcresult, out_flushing);
  dlbuf->srcresult = ret;
  dlbuf->sinkresult = ret;
  if (ret != GST_FLOW_OK)
    goto out_flushing;
  GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);

  return;

  /* ERRORS */
out_flushing:
  {
    GstFlowReturn ret = dlbuf->srcresult;

    gst_pad_pause_task (dlbuf->srcpad);
    GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);
    GST_LOG_OBJECT (dlbuf, "pause task, reason:  %s", gst_flow_get_name (ret));
    /* let app know about us giving up if upstream is not expected to do so */
    if (ret == GST_FLOW_EOS) {
      /* FIXME perform EOS logic, this is really a basesrc operating on a
       * file. */
      gst_pad_push_event (dlbuf->srcpad, gst_event_new_eos ());
    } else if ((ret == GST_FLOW_NOT_LINKED || ret < GST_FLOW_EOS)) {
      GST_ELEMENT_ERROR (dlbuf, STREAM, FAILED,
          (_("Internal data flow error.")),
          ("streaming task paused, reason %s (%d)",
              gst_flow_get_name (ret), ret));
      gst_pad_push_event (dlbuf->srcpad, gst_event_new_eos ());
    }
    return;
  }
}

static gboolean
gst_download_buffer_handle_src_event (GstPad * pad, GstObject * parent,
    GstEvent * event)
{
  gboolean res = TRUE;
  GstDownloadBuffer *dlbuf = GST_DOWNLOAD_BUFFER (parent);

#ifndef GST_DISABLE_GST_DEBUG
  GST_DEBUG_OBJECT (dlbuf, "got event %p (%s)",
      event, GST_EVENT_TYPE_NAME (event));
#endif

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_FLUSH_START:
      /* now unblock the getrange function */
      GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);
      GST_DEBUG_OBJECT (dlbuf, "flushing");
      dlbuf->srcresult = GST_FLOW_FLUSHING;
      GST_DOWNLOAD_BUFFER_SIGNAL_ADD (dlbuf, -1);
      GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);

      /* when using a temp file, we eat the event */
      res = TRUE;
      gst_event_unref (event);
      break;
    case GST_EVENT_FLUSH_STOP:
      /* now unblock the getrange function */
      GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);
      dlbuf->srcresult = GST_FLOW_OK;
      GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);

      /* when using a temp file, we eat the event */
      res = TRUE;
      gst_event_unref (event);
      break;
    case GST_EVENT_RECONFIGURE:
      GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);
      /* assume downstream is linked now and try to push again */
      if (dlbuf->srcresult == GST_FLOW_NOT_LINKED) {
        dlbuf->srcresult = GST_FLOW_OK;
        dlbuf->sinkresult = GST_FLOW_OK;
        if (GST_PAD_MODE (pad) == GST_PAD_MODE_PUSH) {
          gst_pad_start_task (pad, (GstTaskFunction) gst_download_buffer_loop,
              pad, NULL);
        }
      }
      GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);

      res = gst_pad_push_event (dlbuf->sinkpad, event);
      break;
    default:
      res = gst_pad_push_event (dlbuf->sinkpad, event);
      break;
  }

  return res;
}

static gboolean
gst_download_buffer_handle_src_query (GstPad * pad, GstObject * parent,
    GstQuery * query)
{
  GstDownloadBuffer *dlbuf;

  dlbuf = GST_DOWNLOAD_BUFFER (parent);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_POSITION:
    {
      gint64 peer_pos;
      GstFormat format;

      if (!gst_pad_peer_query (dlbuf->sinkpad, query))
        goto peer_failed;

      /* get peer position */
      gst_query_parse_position (query, &format, &peer_pos);

      /* FIXME: this code assumes that there's no discont in the dlbuf */
      switch (format) {
        case GST_FORMAT_BYTES:
          peer_pos -= dlbuf->cur_level.bytes;
          break;
        case GST_FORMAT_TIME:
          peer_pos -= dlbuf->cur_level.time;
          break;
        default:
          GST_WARNING_OBJECT (dlbuf, "dropping query in %s format, don't "
              "know how to adjust value", gst_format_get_name (format));
          return FALSE;
      }
      /* set updated position */
      gst_query_set_position (query, format, peer_pos);
      break;
    }
    case GST_QUERY_DURATION:
    {
      GST_DEBUG_OBJECT (dlbuf, "doing peer query");

      if (!gst_pad_peer_query (dlbuf->sinkpad, query))
        goto peer_failed;

      GST_DEBUG_OBJECT (dlbuf, "peer query success");
      break;
    }
    case GST_QUERY_BUFFERING:
    {
      gint percent;
      gboolean is_buffering;
      GstBufferingMode mode;
      gint avg_in, avg_out;
      gint64 buffering_left;

      GST_DEBUG_OBJECT (dlbuf, "query buffering");

      get_buffering_percent (dlbuf, &is_buffering, &percent);
      gst_query_set_buffering_percent (query, is_buffering, percent);

      get_buffering_stats (dlbuf, percent, &mode, &avg_in, &avg_out,
          &buffering_left);
      gst_query_set_buffering_stats (query, mode, avg_in, avg_out,
          buffering_left);

      {
        /* add ranges for download and ringbuffer buffering */
        GstFormat format;
        gint64 start, stop;
        guint64 write_pos;
        gint64 estimated_total;
        gint64 duration;
        gsize offset, range_start, range_stop;

        GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);
        write_pos = dlbuf->write_pos;

        /* get duration of upstream in bytes */
        gst_download_buffer_update_upstream_size (dlbuf);
        duration = dlbuf->upstream_size;

        GST_DEBUG_OBJECT (dlbuf, "percent %d, duration %" G_GINT64_FORMAT
            ", writing %" G_GINT64_FORMAT, percent, duration, write_pos);

        gst_query_parse_buffering_range (query, &format, NULL, NULL, NULL);

        /* fill out the buffered ranges */
        start = offset = 0;
        stop = -1;
        estimated_total = -1;
        while (gst_sparse_file_get_range_after (dlbuf->file, offset,
                &range_start, &range_stop)) {
          gboolean current_range;

          GST_DEBUG_OBJECT (dlbuf,
              "range starting at %" G_GSIZE_FORMAT " and finishing at %"
              G_GSIZE_FORMAT, range_start, range_stop);

          offset = range_stop;

          /* find the range we are currently downloading, we'll remember it
           * after we convert to the target format */
          if (range_start <= write_pos && range_stop >= write_pos) {
            current_range = TRUE;
            /* calculate remaining and total download time */
            if (duration >= range_stop && avg_in > 0.0)
              estimated_total = ((duration - range_stop) * 1000) / avg_in;
          } else
            current_range = FALSE;

          switch (format) {
            case GST_FORMAT_PERCENT:
              /* get our available data relative to the duration */
              if (duration == -1) {
                range_start = 0;
                range_stop = 0;
              } else {
                range_start = gst_util_uint64_scale (GST_FORMAT_PERCENT_MAX,
                    range_start, duration);
                range_stop = gst_util_uint64_scale (GST_FORMAT_PERCENT_MAX,
                    range_stop, duration);
              }
              break;
            case GST_FORMAT_BYTES:
              break;
            default:
              range_start = -1;
              range_stop = -1;
              break;
          }

          if (current_range) {
            /* we are currently downloading this range */
            start = range_start;
            stop = range_stop;
          }
          GST_DEBUG_OBJECT (dlbuf,
              "range to format: %" G_GSIZE_FORMAT " - %" G_GSIZE_FORMAT,
              range_start, range_stop);
          if (range_start == range_stop)
            continue;
          gst_query_add_buffering_range (query, range_start, range_stop);
        }

        GST_DEBUG_OBJECT (dlbuf, "estimated-total %" G_GINT64_FORMAT,
            estimated_total);

        gst_query_set_buffering_range (query, format, start, stop,
            estimated_total);

        GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);
      }
      break;
    }
    case GST_QUERY_SCHEDULING:
    {
      GstSchedulingFlags flags = 0;

      if (!gst_pad_peer_query (dlbuf->sinkpad, query))
        goto peer_failed;

      gst_query_parse_scheduling (query, &flags, NULL, NULL, NULL);

      /* we can operate in pull mode when we are using a tempfile */
      flags |= GST_SCHEDULING_FLAG_SEEKABLE;
      gst_query_set_scheduling (query, flags, 0, -1, 0);
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
    GST_DEBUG_OBJECT (dlbuf, "failed peer query");
    return FALSE;
  }
}

static gboolean
gst_download_buffer_handle_query (GstElement * element, GstQuery * query)
{
  GstDownloadBuffer *dlbuf = GST_DOWNLOAD_BUFFER (element);

  /* simply forward to the srcpad query function */
  return gst_download_buffer_handle_src_query (dlbuf->srcpad,
      GST_OBJECT_CAST (element), query);
}

static GstFlowReturn
gst_download_buffer_get_range (GstPad * pad, GstObject * parent, guint64 offset,
    guint length, GstBuffer ** buffer)
{
  GstDownloadBuffer *dlbuf;
  GstFlowReturn ret;

  dlbuf = GST_DOWNLOAD_BUFFER_CAST (parent);

  GST_DOWNLOAD_BUFFER_MUTEX_LOCK_CHECK (dlbuf, dlbuf->srcresult, out_flushing);
  /* FIXME - function will block when the range is not yet available */
  ret = gst_download_buffer_read_buffer (dlbuf, offset, length, buffer);
  GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);

  return ret;

  /* ERRORS */
out_flushing:
  {
    ret = dlbuf->srcresult;

    GST_DEBUG_OBJECT (dlbuf, "we are flushing");
    GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);
    return ret;
  }
}

/* sink currently only operates in push mode */
static gboolean
gst_download_buffer_sink_activate_mode (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active)
{
  gboolean result;
  GstDownloadBuffer *dlbuf;

  dlbuf = GST_DOWNLOAD_BUFFER (parent);

  switch (mode) {
    case GST_PAD_MODE_PUSH:
      if (active) {
        GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);
        GST_DEBUG_OBJECT (dlbuf, "activating push mode");
        dlbuf->srcresult = GST_FLOW_OK;
        dlbuf->sinkresult = GST_FLOW_OK;
        dlbuf->unexpected = FALSE;
        reset_rate_timer (dlbuf);
        GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);
      } else {
        /* unblock chain function */
        GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);
        GST_DEBUG_OBJECT (dlbuf, "deactivating push mode");
        dlbuf->srcresult = GST_FLOW_FLUSHING;
        dlbuf->sinkresult = GST_FLOW_FLUSHING;
        GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);

        /* wait until it is unblocked and clean up */
        GST_PAD_STREAM_LOCK (pad);
        GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);
        gst_download_buffer_locked_flush (dlbuf, TRUE, FALSE);
        GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);
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
 * buffers from the dlbuf */
static gboolean
gst_download_buffer_src_activate_push (GstPad * pad, GstObject * parent,
    gboolean active)
{
  gboolean result = FALSE;
  GstDownloadBuffer *dlbuf;

  dlbuf = GST_DOWNLOAD_BUFFER (parent);

  if (active) {
    GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);
    GST_DEBUG_OBJECT (dlbuf, "activating push mode");
    dlbuf->srcresult = GST_FLOW_OK;
    dlbuf->sinkresult = GST_FLOW_OK;
    dlbuf->unexpected = FALSE;
    result =
        gst_pad_start_task (pad, (GstTaskFunction) gst_download_buffer_loop,
        pad, NULL);
    GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);
  } else {
    /* unblock loop function */
    GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);
    GST_DEBUG_OBJECT (dlbuf, "deactivating push mode");
    dlbuf->srcresult = GST_FLOW_FLUSHING;
    dlbuf->sinkresult = GST_FLOW_FLUSHING;
    /* the item add signal will unblock */
    GST_DOWNLOAD_BUFFER_SIGNAL_ADD (dlbuf, -1);
    GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);

    /* step 2, make sure streaming finishes */
    result = gst_pad_stop_task (pad);
  }

  return result;
}

/* pull mode, downstream will call our getrange function */
static gboolean
gst_download_buffer_src_activate_pull (GstPad * pad, GstObject * parent,
    gboolean active)
{
  gboolean result;
  GstDownloadBuffer *dlbuf;

  dlbuf = GST_DOWNLOAD_BUFFER (parent);

  if (active) {
    GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);
    /* open the temp file now */
    result = gst_download_buffer_open_temp_location_file (dlbuf);
    GST_DEBUG_OBJECT (dlbuf, "activating pull mode");
    dlbuf->srcresult = GST_FLOW_OK;
    dlbuf->sinkresult = GST_FLOW_OK;
    dlbuf->unexpected = FALSE;
    dlbuf->upstream_size = 0;
    GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);
  } else {
    GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);
    GST_DEBUG_OBJECT (dlbuf, "deactivating pull mode");
    dlbuf->srcresult = GST_FLOW_FLUSHING;
    dlbuf->sinkresult = GST_FLOW_FLUSHING;
    /* this will unlock getrange */
    GST_DOWNLOAD_BUFFER_SIGNAL_ADD (dlbuf, -1);
    result = TRUE;
    GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);
  }

  return result;
}

static gboolean
gst_download_buffer_src_activate_mode (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active)
{
  gboolean res;

  switch (mode) {
    case GST_PAD_MODE_PULL:
      res = gst_download_buffer_src_activate_pull (pad, parent, active);
      break;
    case GST_PAD_MODE_PUSH:
      res = gst_download_buffer_src_activate_push (pad, parent, active);
      break;
    default:
      GST_LOG_OBJECT (pad, "unknown activation mode %d", mode);
      res = FALSE;
      break;
  }
  return res;
}

static GstStateChangeReturn
gst_download_buffer_change_state (GstElement * element,
    GstStateChange transition)
{
  GstDownloadBuffer *dlbuf;
  GstStateChangeReturn ret = GST_STATE_CHANGE_SUCCESS;

  dlbuf = GST_DOWNLOAD_BUFFER (element);

  switch (transition) {
    case GST_STATE_CHANGE_NULL_TO_READY:
      break;
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);
      if (!gst_download_buffer_open_temp_location_file (dlbuf))
        ret = GST_STATE_CHANGE_FAILURE;
      gst_event_replace (&dlbuf->stream_start_event, NULL);
      gst_event_replace (&dlbuf->segment_event, NULL);
      GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);
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
      GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);
      gst_download_buffer_close_temp_location_file (dlbuf);
      gst_event_replace (&dlbuf->stream_start_event, NULL);
      gst_event_replace (&dlbuf->segment_event, NULL);
      GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);
      break;
    case GST_STATE_CHANGE_READY_TO_NULL:
      break;
    default:
      break;
  }

  return ret;
}

#define CAPACITY_CHANGE(elem) \
  update_buffering (elem);

static void
gst_download_buffer_set_temp_template (GstDownloadBuffer * dlbuf,
    const gchar * template)
{
  GstState state;

  /* the element must be stopped in order to do this */
  GST_OBJECT_LOCK (dlbuf);
  state = GST_STATE (dlbuf);
  if (state != GST_STATE_READY && state != GST_STATE_NULL)
    goto wrong_state;
  GST_OBJECT_UNLOCK (dlbuf);

  /* set new location */
  g_free (dlbuf->temp_template);
  dlbuf->temp_template = g_strdup (template);

  return;

/* ERROR */
wrong_state:
  {
    GST_WARNING_OBJECT (dlbuf, "setting temp-template property in wrong state");
    GST_OBJECT_UNLOCK (dlbuf);
  }
}

static void
gst_download_buffer_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec)
{
  GstDownloadBuffer *dlbuf = GST_DOWNLOAD_BUFFER (object);

  /* someone could change levels here, and since this
   * affects the get/put funcs, we need to lock for safety. */
  GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);

  switch (prop_id) {
    case PROP_MAX_SIZE_BYTES:
      dlbuf->max_level.bytes = g_value_get_uint (value);
      CAPACITY_CHANGE (dlbuf);
      break;
    case PROP_MAX_SIZE_TIME:
      dlbuf->max_level.time = g_value_get_uint64 (value);
      CAPACITY_CHANGE (dlbuf);
      break;
    case PROP_LOW_PERCENT:
      dlbuf->low_percent = g_value_get_int (value);
      break;
    case PROP_HIGH_PERCENT:
      dlbuf->high_percent = g_value_get_int (value);
      break;
    case PROP_TEMP_TEMPLATE:
      gst_download_buffer_set_temp_template (dlbuf, g_value_get_string (value));
      break;
    case PROP_TEMP_REMOVE:
      dlbuf->temp_remove = g_value_get_boolean (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }

  GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);
}

static void
gst_download_buffer_get_property (GObject * object,
    guint prop_id, GValue * value, GParamSpec * pspec)
{
  GstDownloadBuffer *dlbuf = GST_DOWNLOAD_BUFFER (object);

  GST_DOWNLOAD_BUFFER_MUTEX_LOCK (dlbuf);

  switch (prop_id) {
    case PROP_MAX_SIZE_BYTES:
      g_value_set_uint (value, dlbuf->max_level.bytes);
      break;
    case PROP_MAX_SIZE_TIME:
      g_value_set_uint64 (value, dlbuf->max_level.time);
      break;
    case PROP_LOW_PERCENT:
      g_value_set_int (value, dlbuf->low_percent);
      break;
    case PROP_HIGH_PERCENT:
      g_value_set_int (value, dlbuf->high_percent);
      break;
    case PROP_TEMP_TEMPLATE:
      g_value_set_string (value, dlbuf->temp_template);
      break;
    case PROP_TEMP_LOCATION:
      g_value_set_string (value, dlbuf->temp_location);
      break;
    case PROP_TEMP_REMOVE:
      g_value_set_boolean (value, dlbuf->temp_remove);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }

  GST_DOWNLOAD_BUFFER_MUTEX_UNLOCK (dlbuf);
}
