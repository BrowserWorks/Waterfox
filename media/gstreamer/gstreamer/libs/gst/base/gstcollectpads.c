/* GStreamer
 * Copyright (C) 2005 Wim Taymans <wim@fluendo.com>
 * Copyright (C) 2008 Mark Nauwelaerts <mnauw@users.sourceforge.net>
 * Copyright (C) 2010 Sebastian Dröge <sebastian.droege@collabora.co.uk>
 *
 * gstcollectpads.c:
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
 * SECTION:gstcollectpads
 * @short_description: manages a set of pads that operate in collect mode
 * @see_also:
 *
 * Manages a set of pads that operate in collect mode. This means that control
 * is given to the manager of this object when all pads have data.
 * <itemizedlist>
 *   <listitem><para>
 *     Collectpads are created with gst_collect_pads_new(). A callback should then
 *     be installed with gst_collect_pads_set_function ().
 *   </para></listitem>
 *   <listitem><para>
 *     Pads are added to the collection with gst_collect_pads_add_pad()/
 *     gst_collect_pads_remove_pad(). The pad
 *     has to be a sinkpad. The chain and event functions of the pad are
 *     overridden. The element_private of the pad is used to store
 *     private information for the collectpads.
 *   </para></listitem>
 *   <listitem><para>
 *     For each pad, data is queued in the _chain function or by
 *     performing a pull_range.
 *   </para></listitem>
 *   <listitem><para>
 *     When data is queued on all pads in waiting mode, the callback function is called.
 *   </para></listitem>
 *   <listitem><para>
 *     Data can be dequeued from the pad with the gst_collect_pads_pop() method.
 *     One can peek at the data with the gst_collect_pads_peek() function.
 *     These functions will return %NULL if the pad received an EOS event. When all
 *     pads return %NULL from a gst_collect_pads_peek(), the element can emit an EOS
 *     event itself.
 *   </para></listitem>
 *   <listitem><para>
 *     Data can also be dequeued in byte units using the gst_collect_pads_available(),
 *     gst_collect_pads_read_buffer() and gst_collect_pads_flush() calls.
 *   </para></listitem>
 *   <listitem><para>
 *     Elements should call gst_collect_pads_start() and gst_collect_pads_stop() in
 *     their state change functions to start and stop the processing of the collectpads.
 *     The gst_collect_pads_stop() call should be called before calling the parent
 *     element state change function in the PAUSED_TO_READY state change to ensure
 *     no pad is blocked and the element can finish streaming.
 *   </para></listitem>
 *   <listitem><para>
 *     gst_collect_pads_set_waiting() sets a pad to waiting or non-waiting mode.
 *     CollectPads element is not waiting for data to be collected on non-waiting pads.
 *     Thus these pads may but need not have data when the callback is called.
 *     All pads are in waiting mode by default.
 *   </para></listitem>
 * </itemizedlist>
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <gst/gst_private.h>

#include "gstcollectpads.h"

#include "../../../gst/glib-compat-private.h"

GST_DEBUG_CATEGORY_STATIC (collect_pads_debug);
#define GST_CAT_DEFAULT collect_pads_debug

#define parent_class gst_collect_pads_parent_class
G_DEFINE_TYPE (GstCollectPads, gst_collect_pads, GST_TYPE_OBJECT);

struct _GstCollectDataPrivate
{
  /* refcounting for struct, and destroy callback */
  GstCollectDataDestroyNotify destroy_notify;
  gint refcount;
};

struct _GstCollectPadsPrivate
{
  /* with LOCK and/or STREAM_LOCK */
  gboolean started;

  /* with STREAM_LOCK */
  guint32 cookie;               /* @data list cookie */
  guint numpads;                /* number of pads in @data */
  guint queuedpads;             /* number of pads with a buffer */
  guint eospads;                /* number of pads that are EOS */
  GstClockTime earliest_time;   /* Current earliest time */
  GstCollectData *earliest_data;        /* Pad data for current earliest time */

  /* with LOCK */
  GSList *pad_list;             /* updated pad list */
  guint32 pad_cookie;           /* updated cookie */

  GstCollectPadsFunction func;  /* function and user_data for callback */
  gpointer user_data;
  GstCollectPadsBufferFunction buffer_func;     /* function and user_data for buffer callback */
  gpointer buffer_user_data;
  GstCollectPadsCompareFunction compare_func;
  gpointer compare_user_data;
  GstCollectPadsEventFunction event_func;       /* function and data for event callback */
  gpointer event_user_data;
  GstCollectPadsQueryFunction query_func;
  gpointer query_user_data;
  GstCollectPadsClipFunction clip_func;
  gpointer clip_user_data;
  GstCollectPadsFlushFunction flush_func;
  gpointer flush_user_data;

  /* no other lock needed */
  GMutex evt_lock;              /* these make up sort of poor man's event signaling */
  GCond evt_cond;
  guint32 evt_cookie;

  gboolean seeking;
  gboolean pending_flush_start;
  gboolean pending_flush_stop;
};

static void gst_collect_pads_clear (GstCollectPads * pads,
    GstCollectData * data);
static GstFlowReturn gst_collect_pads_chain (GstPad * pad, GstObject * parent,
    GstBuffer * buffer);
static gboolean gst_collect_pads_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static gboolean gst_collect_pads_query (GstPad * pad, GstObject * parent,
    GstQuery * query);
static void gst_collect_pads_finalize (GObject * object);
static GstFlowReturn gst_collect_pads_default_collected (GstCollectPads *
    pads, gpointer user_data);
static gint gst_collect_pads_default_compare_func (GstCollectPads * pads,
    GstCollectData * data1, GstClockTime timestamp1, GstCollectData * data2,
    GstClockTime timestamp2, gpointer user_data);
static gboolean gst_collect_pads_recalculate_full (GstCollectPads * pads);
static void ref_data (GstCollectData * data);
static void unref_data (GstCollectData * data);

static gboolean gst_collect_pads_event_default_internal (GstCollectPads *
    pads, GstCollectData * data, GstEvent * event, gpointer user_data);
static gboolean gst_collect_pads_query_default_internal (GstCollectPads *
    pads, GstCollectData * data, GstQuery * query, gpointer user_data);


/* Some properties are protected by LOCK, others by STREAM_LOCK
 * However, manipulating either of these partitions may require
 * to signal/wake a _WAIT, so use a separate (sort of) event to prevent races
 * Alternative implementations are possible, e.g. some low-level re-implementing
 * of the 2 above locks to drop both of them atomically when going into _WAIT.
 */
#define GST_COLLECT_PADS_GET_EVT_COND(pads) (&((GstCollectPads *)pads)->priv->evt_cond)
#define GST_COLLECT_PADS_GET_EVT_LOCK(pads) (&((GstCollectPads *)pads)->priv->evt_lock)
#define GST_COLLECT_PADS_EVT_WAIT(pads, cookie) G_STMT_START {    \
  g_mutex_lock (GST_COLLECT_PADS_GET_EVT_LOCK (pads));            \
  /* should work unless a lot of event'ing and thread starvation */\
  while (cookie == ((GstCollectPads *) pads)->priv->evt_cookie)         \
    g_cond_wait (GST_COLLECT_PADS_GET_EVT_COND (pads),            \
        GST_COLLECT_PADS_GET_EVT_LOCK (pads));                    \
  cookie = ((GstCollectPads *) pads)->priv->evt_cookie;                 \
  g_mutex_unlock (GST_COLLECT_PADS_GET_EVT_LOCK (pads));          \
} G_STMT_END
#define GST_COLLECT_PADS_EVT_WAIT_TIMED(pads, cookie, timeout) G_STMT_START { \
  GTimeVal __tv; \
  \
  g_get_current_time (&tv); \
  g_time_val_add (&tv, timeout); \
  \
  g_mutex_lock (GST_COLLECT_PADS_GET_EVT_LOCK (pads));            \
  /* should work unless a lot of event'ing and thread starvation */\
  while (cookie == ((GstCollectPads *) pads)->priv->evt_cookie)         \
    g_cond_timed_wait (GST_COLLECT_PADS_GET_EVT_COND (pads),            \
        GST_COLLECT_PADS_GET_EVT_LOCK (pads), &tv);                    \
  cookie = ((GstCollectPads *) pads)->priv->evt_cookie;                 \
  g_mutex_unlock (GST_COLLECT_PADS_GET_EVT_LOCK (pads));          \
} G_STMT_END
#define GST_COLLECT_PADS_EVT_BROADCAST(pads) G_STMT_START {       \
  g_mutex_lock (GST_COLLECT_PADS_GET_EVT_LOCK (pads));            \
  /* never mind wrap-around */                                     \
  ++(((GstCollectPads *) pads)->priv->evt_cookie);                      \
  g_cond_broadcast (GST_COLLECT_PADS_GET_EVT_COND (pads));        \
  g_mutex_unlock (GST_COLLECT_PADS_GET_EVT_LOCK (pads));          \
} G_STMT_END
#define GST_COLLECT_PADS_EVT_INIT(cookie) G_STMT_START {          \
  g_mutex_lock (GST_COLLECT_PADS_GET_EVT_LOCK (pads));            \
  cookie = ((GstCollectPads *) pads)->priv->evt_cookie;                 \
  g_mutex_unlock (GST_COLLECT_PADS_GET_EVT_LOCK (pads));          \
} G_STMT_END

static void
gst_collect_pads_class_init (GstCollectPadsClass * klass)
{
  GObjectClass *gobject_class = (GObjectClass *) klass;

  g_type_class_add_private (klass, sizeof (GstCollectPadsPrivate));

  GST_DEBUG_CATEGORY_INIT (collect_pads_debug, "collectpads", 0,
      "GstCollectPads");

  gobject_class->finalize = GST_DEBUG_FUNCPTR (gst_collect_pads_finalize);
}

static void
gst_collect_pads_init (GstCollectPads * pads)
{
  pads->priv =
      G_TYPE_INSTANCE_GET_PRIVATE (pads, GST_TYPE_COLLECT_PADS,
      GstCollectPadsPrivate);

  pads->data = NULL;
  pads->priv->cookie = 0;
  pads->priv->numpads = 0;
  pads->priv->queuedpads = 0;
  pads->priv->eospads = 0;
  pads->priv->started = FALSE;

  g_rec_mutex_init (&pads->stream_lock);

  pads->priv->func = gst_collect_pads_default_collected;
  pads->priv->user_data = NULL;
  pads->priv->event_func = NULL;
  pads->priv->event_user_data = NULL;

  /* members for default muxing */
  pads->priv->buffer_func = NULL;
  pads->priv->buffer_user_data = NULL;
  pads->priv->compare_func = gst_collect_pads_default_compare_func;
  pads->priv->compare_user_data = NULL;
  pads->priv->earliest_data = NULL;
  pads->priv->earliest_time = GST_CLOCK_TIME_NONE;

  pads->priv->event_func = gst_collect_pads_event_default_internal;
  pads->priv->query_func = gst_collect_pads_query_default_internal;

  /* members to manage the pad list */
  pads->priv->pad_cookie = 0;
  pads->priv->pad_list = NULL;

  /* members for event */
  g_mutex_init (&pads->priv->evt_lock);
  g_cond_init (&pads->priv->evt_cond);
  pads->priv->evt_cookie = 0;

  pads->priv->seeking = FALSE;
  pads->priv->pending_flush_start = FALSE;
  pads->priv->pending_flush_stop = FALSE;

  /* clear floating flag */
  gst_object_ref_sink (pads);
}

static void
gst_collect_pads_finalize (GObject * object)
{
  GstCollectPads *pads = GST_COLLECT_PADS (object);

  GST_DEBUG_OBJECT (object, "finalize");

  g_rec_mutex_clear (&pads->stream_lock);

  g_cond_clear (&pads->priv->evt_cond);
  g_mutex_clear (&pads->priv->evt_lock);

  /* Remove pads and free pads list */
  g_slist_foreach (pads->priv->pad_list, (GFunc) unref_data, NULL);
  g_slist_foreach (pads->data, (GFunc) unref_data, NULL);
  g_slist_free (pads->data);
  g_slist_free (pads->priv->pad_list);

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

/**
 * gst_collect_pads_new:
 *
 * Create a new instance of #GstCollectPads.
 *
 * MT safe.
 *
 * Returns: (transfer full): a new #GstCollectPads, or %NULL in case of an error.
 */
GstCollectPads *
gst_collect_pads_new (void)
{
  GstCollectPads *newcoll;

  newcoll = g_object_new (GST_TYPE_COLLECT_PADS, NULL);

  return newcoll;
}

/* Must be called with GstObject lock! */
static void
gst_collect_pads_set_buffer_function_locked (GstCollectPads * pads,
    GstCollectPadsBufferFunction func, gpointer user_data)
{
  pads->priv->buffer_func = func;
  pads->priv->buffer_user_data = user_data;
}

/**
 * gst_collect_pads_set_buffer_function:
 * @pads: the collectpads to use
 * @func: the function to set
 * @user_data: (closure): user data passed to the function
 *
 * Set the callback function and user data that will be called with
 * the oldest buffer when all pads have been collected, or %NULL on EOS.
 * If a buffer is passed, the callback owns a reference and must unref
 * it.
 *
 * MT safe.
 */
void
gst_collect_pads_set_buffer_function (GstCollectPads * pads,
    GstCollectPadsBufferFunction func, gpointer user_data)
{
  g_return_if_fail (pads != NULL);
  g_return_if_fail (GST_IS_COLLECT_PADS (pads));

  GST_OBJECT_LOCK (pads);
  gst_collect_pads_set_buffer_function_locked (pads, func, user_data);
  GST_OBJECT_UNLOCK (pads);
}

/**
 * gst_collect_pads_set_compare_function:
 * @pads: the pads to use
 * @func: the function to set
 * @user_data: (closure): user data passed to the function
 *
 * Set the timestamp comparison function.
 *
 * MT safe.
 */
/* NOTE allowing to change comparison seems not advisable;
no known use-case, and collaboration with default algorithm is unpredictable.
If custom compairing/operation is needed, just use a collect function of
your own */
void
gst_collect_pads_set_compare_function (GstCollectPads * pads,
    GstCollectPadsCompareFunction func, gpointer user_data)
{
  g_return_if_fail (pads != NULL);
  g_return_if_fail (GST_IS_COLLECT_PADS (pads));

  GST_OBJECT_LOCK (pads);
  pads->priv->compare_func = func;
  pads->priv->compare_user_data = user_data;
  GST_OBJECT_UNLOCK (pads);
}

/**
 * gst_collect_pads_set_function:
 * @pads: the collectpads to use
 * @func: the function to set
 * @user_data: user data passed to the function
 *
 * CollectPads provides a default collection algorithm that will determine
 * the oldest buffer available on all of its pads, and then delegate
 * to a configured callback.
 * However, if circumstances are more complicated and/or more control
 * is desired, this sets a callback that will be invoked instead when
 * all the pads added to the collection have buffers queued.
 * Evidently, this callback is not compatible with
 * gst_collect_pads_set_buffer_function() callback.
 * If this callback is set, the former will be unset.
 *
 * MT safe.
 */
void
gst_collect_pads_set_function (GstCollectPads * pads,
    GstCollectPadsFunction func, gpointer user_data)
{
  g_return_if_fail (pads != NULL);
  g_return_if_fail (GST_IS_COLLECT_PADS (pads));

  GST_OBJECT_LOCK (pads);
  pads->priv->func = func;
  pads->priv->user_data = user_data;
  gst_collect_pads_set_buffer_function_locked (pads, NULL, NULL);
  GST_OBJECT_UNLOCK (pads);
}

static void
ref_data (GstCollectData * data)
{
  g_assert (data != NULL);

  g_atomic_int_inc (&(data->priv->refcount));
}

static void
unref_data (GstCollectData * data)
{
  g_assert (data != NULL);
  g_assert (data->priv->refcount > 0);

  if (!g_atomic_int_dec_and_test (&(data->priv->refcount)))
    return;

  if (data->priv->destroy_notify)
    data->priv->destroy_notify (data);

  g_object_unref (data->pad);
  if (data->buffer) {
    gst_buffer_unref (data->buffer);
  }
  g_free (data->priv);
  g_free (data);
}

/**
 * gst_collect_pads_set_event_function:
 * @pads: the collectpads to use
 * @func: the function to set
 * @user_data: user data passed to the function
 *
 * Set the event callback function and user data that will be called when
 * collectpads has received an event originating from one of the collected
 * pads.  If the event being processed is a serialized one, this callback is
 * called with @pads STREAM_LOCK held, otherwise not.  As this lock should be
 * held when calling a number of CollectPads functions, it should be acquired
 * if so (unusually) needed.
 *
 * MT safe.
 */
void
gst_collect_pads_set_event_function (GstCollectPads * pads,
    GstCollectPadsEventFunction func, gpointer user_data)
{
  g_return_if_fail (pads != NULL);
  g_return_if_fail (GST_IS_COLLECT_PADS (pads));

  GST_OBJECT_LOCK (pads);
  pads->priv->event_func = func;
  pads->priv->event_user_data = user_data;
  GST_OBJECT_UNLOCK (pads);
}

/**
 * gst_collect_pads_set_query_function:
 * @pads: the collectpads to use
 * @func: the function to set
 * @user_data: user data passed to the function
 *
 * Set the query callback function and user data that will be called after
 * collectpads has received a query originating from one of the collected
 * pads.  If the query being processed is a serialized one, this callback is
 * called with @pads STREAM_LOCK held, otherwise not.  As this lock should be
 * held when calling a number of CollectPads functions, it should be acquired
 * if so (unusually) needed.
 *
 * MT safe.
 */
void
gst_collect_pads_set_query_function (GstCollectPads * pads,
    GstCollectPadsQueryFunction func, gpointer user_data)
{
  g_return_if_fail (pads != NULL);
  g_return_if_fail (GST_IS_COLLECT_PADS (pads));

  GST_OBJECT_LOCK (pads);
  pads->priv->query_func = func;
  pads->priv->query_user_data = user_data;
  GST_OBJECT_UNLOCK (pads);
}

/**
* gst_collect_pads_clip_running_time:
* @pads: the collectpads to use
* @cdata: collect data of corresponding pad
* @buf: buffer being clipped
* @outbuf: (allow-none): output buffer with running time, or NULL if clipped
* @user_data: user data (unused)
*
* Convenience clipping function that converts incoming buffer's timestamp
* to running time, or clips the buffer if outside configured segment.
*/
GstFlowReturn
gst_collect_pads_clip_running_time (GstCollectPads * pads,
    GstCollectData * cdata, GstBuffer * buf, GstBuffer ** outbuf,
    gpointer user_data)
{
  GstClockTime time;

  *outbuf = buf;
  time = GST_BUFFER_PTS (buf);

  /* invalid left alone and passed */
  if (G_LIKELY (GST_CLOCK_TIME_IS_VALID (time))) {
    time = gst_segment_to_running_time (&cdata->segment, GST_FORMAT_TIME, time);
    if (G_UNLIKELY (!GST_CLOCK_TIME_IS_VALID (time))) {
      GST_DEBUG_OBJECT (cdata->pad, "clipping buffer on pad outside segment %"
          GST_TIME_FORMAT, GST_TIME_ARGS (GST_BUFFER_PTS (buf)));
      gst_buffer_unref (buf);
      *outbuf = NULL;
    } else {
      GST_LOG_OBJECT (cdata->pad, "buffer ts %" GST_TIME_FORMAT " -> %"
          GST_TIME_FORMAT " running time",
          GST_TIME_ARGS (GST_BUFFER_PTS (buf)), GST_TIME_ARGS (time));
      *outbuf = gst_buffer_make_writable (buf);
      GST_BUFFER_PTS (*outbuf) = time;
      GST_BUFFER_DTS (*outbuf) = gst_segment_to_running_time (&cdata->segment,
          GST_FORMAT_TIME, GST_BUFFER_DTS (*outbuf));
    }
  }

  return GST_FLOW_OK;
}

/**
 * gst_collect_pads_set_clip_function:
 * @pads: the collectpads to use
 * @clipfunc: clip function to install
 * @user_data: user data to pass to @clip_func
 *
 * Install a clipping function that is called right after a buffer is received
 * on a pad managed by @pads. See #GstCollectPadsClipFunction for more info.
 */
void
gst_collect_pads_set_clip_function (GstCollectPads * pads,
    GstCollectPadsClipFunction clipfunc, gpointer user_data)
{
  g_return_if_fail (pads != NULL);
  g_return_if_fail (GST_IS_COLLECT_PADS (pads));

  pads->priv->clip_func = clipfunc;
  pads->priv->clip_user_data = user_data;
}

/**
 * gst_collect_pads_set_flush_function:
 * @pads: the collectpads to use
 * @func: flush function to install
 * @user_data: user data to pass to @func
 *
 * Install a flush function that is called when the internal
 * state of all pads should be flushed as part of flushing seek
 * handling. See #GstCollectPadsFlushFunction for more info.
 *
 * Since: 1.4
 */
void
gst_collect_pads_set_flush_function (GstCollectPads * pads,
    GstCollectPadsFlushFunction func, gpointer user_data)
{
  g_return_if_fail (pads != NULL);
  g_return_if_fail (GST_IS_COLLECT_PADS (pads));

  pads->priv->flush_func = func;
  pads->priv->flush_user_data = user_data;
}

/**
 * gst_collect_pads_add_pad:
 * @pads: the collectpads to use
 * @pad: (transfer none): the pad to add
 * @size: the size of the returned #GstCollectData structure
 * @destroy_notify: (scope async): function to be called before the returned
 *   #GstCollectData structure is freed
 * @lock: whether to lock this pad in usual waiting state
 *
 * Add a pad to the collection of collect pads. The pad has to be
 * a sinkpad. The refcount of the pad is incremented. Use
 * gst_collect_pads_remove_pad() to remove the pad from the collection
 * again.
 *
 * You specify a size for the returned #GstCollectData structure
 * so that you can use it to store additional information.
 *
 * You can also specify a #GstCollectDataDestroyNotify that will be called
 * just before the #GstCollectData structure is freed. It is passed the
 * pointer to the structure and should free any custom memory and resources
 * allocated for it.
 *
 * Keeping a pad locked in waiting state is only relevant when using
 * the default collection algorithm (providing the oldest buffer).
 * It ensures a buffer must be available on this pad for a collection
 * to take place.  This is of typical use to a muxer element where
 * non-subtitle streams should always be in waiting state,
 * e.g. to assure that caps information is available on all these streams
 * when initial headers have to be written.
 *
 * The pad will be automatically activated in push mode when @pads is
 * started.
 *
 * MT safe.
 *
 * Returns: (nullable) (transfer none): a new #GstCollectData to identify the
 *   new pad. Or %NULL if wrong parameters are supplied.
 */
GstCollectData *
gst_collect_pads_add_pad (GstCollectPads * pads, GstPad * pad, guint size,
    GstCollectDataDestroyNotify destroy_notify, gboolean lock)
{
  GstCollectData *data;

  g_return_val_if_fail (pads != NULL, NULL);
  g_return_val_if_fail (GST_IS_COLLECT_PADS (pads), NULL);
  g_return_val_if_fail (pad != NULL, NULL);
  g_return_val_if_fail (GST_PAD_IS_SINK (pad), NULL);
  g_return_val_if_fail (size >= sizeof (GstCollectData), NULL);

  GST_DEBUG_OBJECT (pads, "adding pad %s:%s", GST_DEBUG_PAD_NAME (pad));

  data = g_malloc0 (size);
  data->priv = g_new0 (GstCollectDataPrivate, 1);
  data->collect = pads;
  data->pad = gst_object_ref (pad);
  data->buffer = NULL;
  data->pos = 0;
  gst_segment_init (&data->segment, GST_FORMAT_UNDEFINED);
  data->state = GST_COLLECT_PADS_STATE_WAITING;
  data->state |= lock ? GST_COLLECT_PADS_STATE_LOCKED : 0;
  data->priv->refcount = 1;
  data->priv->destroy_notify = destroy_notify;

  GST_OBJECT_LOCK (pads);
  GST_OBJECT_LOCK (pad);
  gst_pad_set_element_private (pad, data);
  GST_OBJECT_UNLOCK (pad);
  pads->priv->pad_list = g_slist_append (pads->priv->pad_list, data);
  gst_pad_set_chain_function (pad, GST_DEBUG_FUNCPTR (gst_collect_pads_chain));
  gst_pad_set_event_function (pad, GST_DEBUG_FUNCPTR (gst_collect_pads_event));
  gst_pad_set_query_function (pad, GST_DEBUG_FUNCPTR (gst_collect_pads_query));
  /* backward compat, also add to data if stopped, so that the element already
   * has this in the public data list before going PAUSED (typically)
   * this can only be done when we are stopped because we don't take the
   * STREAM_LOCK to protect the pads->data list. */
  if (!pads->priv->started) {
    pads->data = g_slist_append (pads->data, data);
    ref_data (data);
  }
  /* activate the pad when needed */
  if (pads->priv->started)
    gst_pad_set_active (pad, TRUE);
  pads->priv->pad_cookie++;
  GST_OBJECT_UNLOCK (pads);

  return data;
}

static gint
find_pad (GstCollectData * data, GstPad * pad)
{
  if (data->pad == pad)
    return 0;
  return 1;
}

/**
 * gst_collect_pads_remove_pad:
 * @pads: the collectpads to use
 * @pad: (transfer none): the pad to remove
 *
 * Remove a pad from the collection of collect pads. This function will also
 * free the #GstCollectData and all the resources that were allocated with
 * gst_collect_pads_add_pad().
 *
 * The pad will be deactivated automatically when @pads is stopped.
 *
 * MT safe.
 *
 * Returns: %TRUE if the pad could be removed.
 */
gboolean
gst_collect_pads_remove_pad (GstCollectPads * pads, GstPad * pad)
{
  GstCollectData *data;
  GSList *list;

  g_return_val_if_fail (pads != NULL, FALSE);
  g_return_val_if_fail (GST_IS_COLLECT_PADS (pads), FALSE);
  g_return_val_if_fail (pad != NULL, FALSE);
  g_return_val_if_fail (GST_IS_PAD (pad), FALSE);

  GST_DEBUG_OBJECT (pads, "removing pad %s:%s", GST_DEBUG_PAD_NAME (pad));

  GST_OBJECT_LOCK (pads);
  list =
      g_slist_find_custom (pads->priv->pad_list, pad, (GCompareFunc) find_pad);
  if (!list)
    goto unknown_pad;

  data = (GstCollectData *) list->data;

  GST_DEBUG_OBJECT (pads, "found pad %s:%s at %p", GST_DEBUG_PAD_NAME (pad),
      data);

  /* clear the stuff we configured */
  gst_pad_set_chain_function (pad, NULL);
  gst_pad_set_event_function (pad, NULL);
  GST_OBJECT_LOCK (pad);
  gst_pad_set_element_private (pad, NULL);
  GST_OBJECT_UNLOCK (pad);

  /* backward compat, also remove from data if stopped, note that this function
   * can only be called when we are stopped because we don't take the
   * STREAM_LOCK to protect the pads->data list. */
  if (!pads->priv->started) {
    GSList *dlist;

    dlist = g_slist_find_custom (pads->data, pad, (GCompareFunc) find_pad);
    if (dlist) {
      GstCollectData *pdata = dlist->data;

      pads->data = g_slist_delete_link (pads->data, dlist);
      unref_data (pdata);
    }
  }
  /* remove from the pad list */
  pads->priv->pad_list = g_slist_delete_link (pads->priv->pad_list, list);
  pads->priv->pad_cookie++;

  /* signal waiters because something changed */
  GST_COLLECT_PADS_EVT_BROADCAST (pads);

  /* deactivate the pad when needed */
  if (!pads->priv->started)
    gst_pad_set_active (pad, FALSE);

  /* clean and free the collect data */
  unref_data (data);

  GST_OBJECT_UNLOCK (pads);

  return TRUE;

unknown_pad:
  {
    GST_WARNING_OBJECT (pads, "cannot remove unknown pad %s:%s",
        GST_DEBUG_PAD_NAME (pad));
    GST_OBJECT_UNLOCK (pads);
    return FALSE;
  }
}

/*
 * Must be called with STREAM_LOCK and OBJECT_LOCK.
 */
static void
gst_collect_pads_set_flushing_unlocked (GstCollectPads * pads,
    gboolean flushing)
{
  GSList *walk = NULL;

  /* Update the pads flushing flag */
  for (walk = pads->priv->pad_list; walk; walk = g_slist_next (walk)) {
    GstCollectData *cdata = walk->data;

    if (GST_IS_PAD (cdata->pad)) {
      GST_OBJECT_LOCK (cdata->pad);
      if (flushing)
        GST_PAD_SET_FLUSHING (cdata->pad);
      else
        GST_PAD_UNSET_FLUSHING (cdata->pad);
      if (flushing)
        GST_COLLECT_PADS_STATE_SET (cdata, GST_COLLECT_PADS_STATE_FLUSHING);
      else
        GST_COLLECT_PADS_STATE_UNSET (cdata, GST_COLLECT_PADS_STATE_FLUSHING);
      gst_collect_pads_clear (pads, cdata);
      GST_OBJECT_UNLOCK (cdata->pad);
    }
  }

  /* inform _chain of changes */
  GST_COLLECT_PADS_EVT_BROADCAST (pads);
}

/**
 * gst_collect_pads_set_flushing:
 * @pads: the collectpads to use
 * @flushing: desired state of the pads
 *
 * Change the flushing state of all the pads in the collection. No pad
 * is able to accept anymore data when @flushing is %TRUE. Calling this
 * function with @flushing %FALSE makes @pads accept data again.
 * Caller must ensure that downstream streaming (thread) is not blocked,
 * e.g. by sending a FLUSH_START downstream.
 *
 * MT safe.
 */
void
gst_collect_pads_set_flushing (GstCollectPads * pads, gboolean flushing)
{
  g_return_if_fail (pads != NULL);
  g_return_if_fail (GST_IS_COLLECT_PADS (pads));

  /* NOTE since this eventually calls _pop, some (STREAM_)LOCK is needed here */
  GST_COLLECT_PADS_STREAM_LOCK (pads);
  GST_OBJECT_LOCK (pads);
  gst_collect_pads_set_flushing_unlocked (pads, flushing);
  GST_OBJECT_UNLOCK (pads);
  GST_COLLECT_PADS_STREAM_UNLOCK (pads);
}

/**
 * gst_collect_pads_start:
 * @pads: the collectpads to use
 *
 * Starts the processing of data in the collect_pads.
 *
 * MT safe.
 */
void
gst_collect_pads_start (GstCollectPads * pads)
{
  GSList *collected;

  g_return_if_fail (pads != NULL);
  g_return_if_fail (GST_IS_COLLECT_PADS (pads));

  GST_DEBUG_OBJECT (pads, "starting collect pads");

  /* make sure stop and collect cannot be called anymore */
  GST_COLLECT_PADS_STREAM_LOCK (pads);

  /* make pads streamable */
  GST_OBJECT_LOCK (pads);

  /* loop over the master pad list and reset the segment */
  collected = pads->priv->pad_list;
  for (; collected; collected = g_slist_next (collected)) {
    GstCollectData *data;

    data = collected->data;
    gst_segment_init (&data->segment, GST_FORMAT_UNDEFINED);
  }

  gst_collect_pads_set_flushing_unlocked (pads, FALSE);

  /* Start collect pads */
  pads->priv->started = TRUE;
  GST_OBJECT_UNLOCK (pads);
  GST_COLLECT_PADS_STREAM_UNLOCK (pads);
}

/**
 * gst_collect_pads_stop:
 * @pads: the collectpads to use
 *
 * Stops the processing of data in the collect_pads. this function
 * will also unblock any blocking operations.
 *
 * MT safe.
 */
void
gst_collect_pads_stop (GstCollectPads * pads)
{
  GSList *collected;

  g_return_if_fail (pads != NULL);
  g_return_if_fail (GST_IS_COLLECT_PADS (pads));

  GST_DEBUG_OBJECT (pads, "stopping collect pads");

  /* make sure collect and start cannot be called anymore */
  GST_COLLECT_PADS_STREAM_LOCK (pads);

  /* make pads not accept data anymore */
  GST_OBJECT_LOCK (pads);
  gst_collect_pads_set_flushing_unlocked (pads, TRUE);

  /* Stop collect pads */
  pads->priv->started = FALSE;
  pads->priv->eospads = 0;
  pads->priv->queuedpads = 0;

  /* loop over the master pad list and flush buffers */
  collected = pads->priv->pad_list;
  for (; collected; collected = g_slist_next (collected)) {
    GstCollectData *data;
    GstBuffer **buffer_p;

    data = collected->data;
    if (data->buffer) {
      buffer_p = &data->buffer;
      gst_buffer_replace (buffer_p, NULL);
      data->pos = 0;
    }
    GST_COLLECT_PADS_STATE_UNSET (data, GST_COLLECT_PADS_STATE_EOS);
  }

  if (pads->priv->earliest_data)
    unref_data (pads->priv->earliest_data);
  pads->priv->earliest_data = NULL;
  pads->priv->earliest_time = GST_CLOCK_TIME_NONE;

  GST_OBJECT_UNLOCK (pads);
  /* Wake them up so they can end the chain functions. */
  GST_COLLECT_PADS_EVT_BROADCAST (pads);

  GST_COLLECT_PADS_STREAM_UNLOCK (pads);
}

/**
 * gst_collect_pads_peek:
 * @pads: the collectpads to peek
 * @data: the data to use
 *
 * Peek at the buffer currently queued in @data. This function
 * should be called with the @pads STREAM_LOCK held, such as in the callback
 * handler.
 *
 * MT safe.
 *
 * Returns: The buffer in @data or %NULL if no buffer is queued.
 *  should unref the buffer after usage.
 */
GstBuffer *
gst_collect_pads_peek (GstCollectPads * pads, GstCollectData * data)
{
  GstBuffer *result;

  g_return_val_if_fail (pads != NULL, NULL);
  g_return_val_if_fail (GST_IS_COLLECT_PADS (pads), NULL);
  g_return_val_if_fail (data != NULL, NULL);

  if ((result = data->buffer))
    gst_buffer_ref (result);

  GST_DEBUG_OBJECT (pads, "Peeking at pad %s:%s: buffer=%p",
      GST_DEBUG_PAD_NAME (data->pad), result);

  return result;
}

/**
 * gst_collect_pads_pop:
 * @pads: the collectpads to pop
 * @data: the data to use
 *
 * Pop the buffer currently queued in @data. This function
 * should be called with the @pads STREAM_LOCK held, such as in the callback
 * handler.
 *
 * MT safe.
 *
 * Returns: (transfer full): The buffer in @data or %NULL if no buffer was
 *   queued. You should unref the buffer after usage.
 */
GstBuffer *
gst_collect_pads_pop (GstCollectPads * pads, GstCollectData * data)
{
  GstBuffer *result;

  g_return_val_if_fail (pads != NULL, NULL);
  g_return_val_if_fail (GST_IS_COLLECT_PADS (pads), NULL);
  g_return_val_if_fail (data != NULL, NULL);

  if ((result = data->buffer)) {
    data->buffer = NULL;
    data->pos = 0;
    /* one less pad with queued data now */
    if (GST_COLLECT_PADS_STATE_IS_SET (data, GST_COLLECT_PADS_STATE_WAITING))
      pads->priv->queuedpads--;
  }

  GST_COLLECT_PADS_EVT_BROADCAST (pads);

  GST_DEBUG_OBJECT (pads, "Pop buffer on pad %s:%s: buffer=%p",
      GST_DEBUG_PAD_NAME (data->pad), result);

  return result;
}

/* pop and unref the currently queued buffer, should be called with STREAM_LOCK
 * held */
static void
gst_collect_pads_clear (GstCollectPads * pads, GstCollectData * data)
{
  GstBuffer *buf;

  if ((buf = gst_collect_pads_pop (pads, data)))
    gst_buffer_unref (buf);
}

/**
 * gst_collect_pads_available:
 * @pads: the collectpads to query
 *
 * Query how much bytes can be read from each queued buffer. This means
 * that the result of this call is the maximum number of bytes that can
 * be read from each of the pads.
 *
 * This function should be called with @pads STREAM_LOCK held, such as
 * in the callback.
 *
 * MT safe.
 *
 * Returns: The maximum number of bytes queued on all pads. This function
 * returns 0 if a pad has no queued buffer.
 */
/* we might pre-calculate this in some struct field,
 * but would then have to maintain this in _chain and particularly _pop, etc,
 * even if element is never interested in this information */
guint
gst_collect_pads_available (GstCollectPads * pads)
{
  GSList *collected;
  guint result = G_MAXUINT;

  g_return_val_if_fail (pads != NULL, 0);
  g_return_val_if_fail (GST_IS_COLLECT_PADS (pads), 0);

  collected = pads->data;
  for (; collected; collected = g_slist_next (collected)) {
    GstCollectData *pdata;
    GstBuffer *buffer;
    gint size;

    pdata = (GstCollectData *) collected->data;

    /* ignore pad with EOS */
    if (G_UNLIKELY (GST_COLLECT_PADS_STATE_IS_SET (pdata,
                GST_COLLECT_PADS_STATE_EOS))) {
      GST_DEBUG_OBJECT (pads, "pad %p is EOS", pdata);
      continue;
    }

    /* an empty buffer without EOS is weird when we get here.. */
    if (G_UNLIKELY ((buffer = pdata->buffer) == NULL)) {
      GST_WARNING_OBJECT (pads, "pad %p has no buffer", pdata);
      goto not_filled;
    }

    /* this is the size left of the buffer */
    size = gst_buffer_get_size (buffer) - pdata->pos;
    GST_DEBUG_OBJECT (pads, "pad %p has %d bytes left", pdata, size);

    /* need to return the min of all available data */
    if (size < result)
      result = size;
  }
  /* nothing changed, all must be EOS then, return 0 */
  if (G_UNLIKELY (result == G_MAXUINT))
    result = 0;

  return result;

not_filled:
  {
    return 0;
  }
}

/**
 * gst_collect_pads_flush:
 * @pads: the collectpads to query
 * @data: the data to use
 * @size: the number of bytes to flush
 *
 * Flush @size bytes from the pad @data.
 *
 * This function should be called with @pads STREAM_LOCK held, such as
 * in the callback.
 *
 * MT safe.
 *
 * Returns: The number of bytes flushed This can be less than @size and
 * is 0 if the pad was end-of-stream.
 */
guint
gst_collect_pads_flush (GstCollectPads * pads, GstCollectData * data,
    guint size)
{
  guint flushsize;
  gsize bsize;
  GstBuffer *buffer;

  g_return_val_if_fail (pads != NULL, 0);
  g_return_val_if_fail (GST_IS_COLLECT_PADS (pads), 0);
  g_return_val_if_fail (data != NULL, 0);

  /* no buffer, must be EOS */
  if ((buffer = data->buffer) == NULL)
    return 0;

  bsize = gst_buffer_get_size (buffer);

  /* this is what we can flush at max */
  flushsize = MIN (size, bsize - data->pos);

  data->pos += size;

  if (data->pos >= bsize)
    /* _clear will also reset data->pos to 0 */
    gst_collect_pads_clear (pads, data);

  return flushsize;
}

/**
 * gst_collect_pads_read_buffer:
 * @pads: the collectpads to query
 * @data: the data to use
 * @size: the number of bytes to read
 *
 * Get a subbuffer of @size bytes from the given pad @data.
 *
 * This function should be called with @pads STREAM_LOCK held, such as in the
 * callback.
 *
 * MT safe.
 *
 * Returns: (transfer full): A sub buffer. The size of the buffer can be less that requested.
 * A return of %NULL signals that the pad is end-of-stream.
 * Unref the buffer after use.
 */
GstBuffer *
gst_collect_pads_read_buffer (GstCollectPads * pads, GstCollectData * data,
    guint size)
{
  guint readsize;
  GstBuffer *buffer;

  g_return_val_if_fail (pads != NULL, NULL);
  g_return_val_if_fail (GST_IS_COLLECT_PADS (pads), NULL);
  g_return_val_if_fail (data != NULL, NULL);

  /* no buffer, must be EOS */
  if ((buffer = data->buffer) == NULL)
    return NULL;

  readsize = MIN (size, gst_buffer_get_size (buffer) - data->pos);

  return gst_buffer_copy_region (buffer, GST_BUFFER_COPY_ALL, data->pos,
      readsize);
}

/**
 * gst_collect_pads_take_buffer:
 * @pads: the collectpads to query
 * @data: the data to use
 * @size: the number of bytes to read
 *
 * Get a subbuffer of @size bytes from the given pad @data. Flushes the amount
 * of read bytes.
 *
 * This function should be called with @pads STREAM_LOCK held, such as in the
 * callback.
 *
 * MT safe.
 *
 * Returns: A sub buffer. The size of the buffer can be less that requested.
 * A return of %NULL signals that the pad is end-of-stream.
 * Unref the buffer after use.
 */
GstBuffer *
gst_collect_pads_take_buffer (GstCollectPads * pads, GstCollectData * data,
    guint size)
{
  GstBuffer *buffer = gst_collect_pads_read_buffer (pads, data, size);

  if (buffer) {
    gst_collect_pads_flush (pads, data, gst_buffer_get_size (buffer));
  }
  return buffer;
}

/**
 * gst_collect_pads_set_waiting:
 * @pads: the collectpads
 * @data: the data to use
 * @waiting: boolean indicating whether this pad should operate
 *           in waiting or non-waiting mode
 *
 * Sets a pad to waiting or non-waiting mode, if at least this pad
 * has not been created with locked waiting state,
 * in which case nothing happens.
 *
 * This function should be called with @pads STREAM_LOCK held, such as
 * in the callback.
 *
 * MT safe.
 */
void
gst_collect_pads_set_waiting (GstCollectPads * pads, GstCollectData * data,
    gboolean waiting)
{
  g_return_if_fail (pads != NULL);
  g_return_if_fail (GST_IS_COLLECT_PADS (pads));
  g_return_if_fail (data != NULL);

  GST_DEBUG_OBJECT (pads, "Setting pad %s to waiting %d, locked %d",
      GST_PAD_NAME (data->pad), waiting,
      GST_COLLECT_PADS_STATE_IS_SET (data, GST_COLLECT_PADS_STATE_LOCKED));

  /* Do something only on a change and if not locked */
  if (!GST_COLLECT_PADS_STATE_IS_SET (data, GST_COLLECT_PADS_STATE_LOCKED) &&
      (GST_COLLECT_PADS_STATE_IS_SET (data, GST_COLLECT_PADS_STATE_WAITING) !=
          ! !waiting)) {
    /* Set waiting state for this pad */
    if (waiting)
      GST_COLLECT_PADS_STATE_SET (data, GST_COLLECT_PADS_STATE_WAITING);
    else
      GST_COLLECT_PADS_STATE_UNSET (data, GST_COLLECT_PADS_STATE_WAITING);
    /* Update number of queued pads if needed */
    if (!data->buffer &&
        !GST_COLLECT_PADS_STATE_IS_SET (data, GST_COLLECT_PADS_STATE_EOS)) {
      if (waiting)
        pads->priv->queuedpads--;
      else
        pads->priv->queuedpads++;
    }

    /* signal waiters because something changed */
    GST_COLLECT_PADS_EVT_BROADCAST (pads);
  }
}

/* see if pads were added or removed and update our stats. Any pad
 * added after releasing the LOCK will get collected in the next
 * round.
 *
 * We can do a quick check by checking the cookies, that get changed
 * whenever the pad list is updated.
 *
 * Must be called with STREAM_LOCK.
 */
static void
gst_collect_pads_check_pads (GstCollectPads * pads)
{
  /* the master list and cookie are protected with LOCK */
  GST_OBJECT_LOCK (pads);
  if (G_UNLIKELY (pads->priv->pad_cookie != pads->priv->cookie)) {
    GSList *collected;

    /* clear list and stats */
    g_slist_foreach (pads->data, (GFunc) unref_data, NULL);
    g_slist_free (pads->data);
    pads->data = NULL;
    pads->priv->numpads = 0;
    pads->priv->queuedpads = 0;
    pads->priv->eospads = 0;
    if (pads->priv->earliest_data)
      unref_data (pads->priv->earliest_data);
    pads->priv->earliest_data = NULL;
    pads->priv->earliest_time = GST_CLOCK_TIME_NONE;

    /* loop over the master pad list */
    collected = pads->priv->pad_list;
    for (; collected; collected = g_slist_next (collected)) {
      GstCollectData *data;

      /* update the stats */
      pads->priv->numpads++;
      data = collected->data;
      if (GST_COLLECT_PADS_STATE_IS_SET (data, GST_COLLECT_PADS_STATE_EOS))
        pads->priv->eospads++;
      else if (data->buffer || !GST_COLLECT_PADS_STATE_IS_SET (data,
              GST_COLLECT_PADS_STATE_WAITING))
        pads->priv->queuedpads++;

      /* add to the list of pads to collect */
      ref_data (data);
      /* preserve order of adding/requesting pads */
      pads->data = g_slist_append (pads->data, data);
    }
    /* and update the cookie */
    pads->priv->cookie = pads->priv->pad_cookie;
  }
  GST_OBJECT_UNLOCK (pads);
}

/* checks if all the pads are collected and call the collectfunction
 *
 * Should be called with STREAM_LOCK.
 *
 * Returns: The #GstFlowReturn of collection.
 */
static GstFlowReturn
gst_collect_pads_check_collected (GstCollectPads * pads)
{
  GstFlowReturn flow_ret = GST_FLOW_OK;
  GstCollectPadsFunction func;
  gpointer user_data;

  g_return_val_if_fail (GST_IS_COLLECT_PADS (pads), GST_FLOW_ERROR);

  GST_OBJECT_LOCK (pads);
  func = pads->priv->func;
  user_data = pads->priv->user_data;
  GST_OBJECT_UNLOCK (pads);

  g_return_val_if_fail (pads->priv->func != NULL, GST_FLOW_NOT_SUPPORTED);

  /* check for new pads, update stats etc.. */
  gst_collect_pads_check_pads (pads);

  if (G_UNLIKELY (pads->priv->eospads == pads->priv->numpads)) {
    /* If all our pads are EOS just collect once to let the element
     * do its final EOS handling. */
    GST_DEBUG_OBJECT (pads, "All active pads (%d) are EOS, calling %s",
        pads->priv->numpads, GST_DEBUG_FUNCPTR_NAME (func));

    if (G_UNLIKELY (g_atomic_int_compare_and_exchange (&pads->priv->seeking,
                TRUE, FALSE) == TRUE)) {
      GST_INFO_OBJECT (pads, "finished seeking");
    }
    do {
      flow_ret = func (pads, user_data);
    } while (flow_ret == GST_FLOW_OK);
  } else {
    gboolean collected = FALSE;

    /* We call the collected function as long as our condition matches. */
    while (((pads->priv->queuedpads + pads->priv->eospads) >=
            pads->priv->numpads)) {
      GST_DEBUG_OBJECT (pads,
          "All active pads (%d + %d >= %d) have data, " "calling %s",
          pads->priv->queuedpads, pads->priv->eospads, pads->priv->numpads,
          GST_DEBUG_FUNCPTR_NAME (func));

      if (G_UNLIKELY (g_atomic_int_compare_and_exchange (&pads->priv->seeking,
                  TRUE, FALSE) == TRUE)) {
        GST_INFO_OBJECT (pads, "finished seeking");
      }
      flow_ret = func (pads, user_data);
      collected = TRUE;

      /* break on error */
      if (flow_ret != GST_FLOW_OK)
        break;
      /* Don't keep looping after telling the element EOS or flushing */
      if (pads->priv->queuedpads == 0)
        break;
    }
    if (!collected)
      GST_DEBUG_OBJECT (pads, "Not all active pads (%d) have data, continuing",
          pads->priv->numpads);
  }
  return flow_ret;
}


/* General overview:
 * - only pad with a buffer can determine earliest_data (and earliest_time)
 * - only segment info determines (non-)waiting state
 * - ? perhaps use _stream_time for comparison
 *   (which muxers might have use as well ?)
 */

/*
 * Function to recalculate the waiting state of all pads.
 *
 * Must be called with STREAM_LOCK.
 *
 * Returns %TRUE if a pad was set to waiting
 * (from non-waiting state).
 */
static gboolean
gst_collect_pads_recalculate_waiting (GstCollectPads * pads)
{
  GSList *collected;
  gboolean result = FALSE;

  /* If earliest time is not known, there is nothing to do. */
  if (pads->priv->earliest_data == NULL)
    return FALSE;

  for (collected = pads->data; collected; collected = g_slist_next (collected)) {
    GstCollectData *data = (GstCollectData *) collected->data;
    int cmp_res;
    GstClockTime comp_time;

    /* check if pad has a segment */
    if (data->segment.format == GST_FORMAT_UNDEFINED) {
      GST_WARNING_OBJECT (pads,
          "GstCollectPads has no time segment, assuming 0 based.");
      gst_segment_init (&data->segment, GST_FORMAT_TIME);
      GST_COLLECT_PADS_STATE_SET (data, GST_COLLECT_PADS_STATE_NEW_SEGMENT);
    }

    /* check segment format */
    if (data->segment.format != GST_FORMAT_TIME) {
      GST_ERROR_OBJECT (pads, "GstCollectPads can handle only time segments.");
      continue;
    }

    /* check if the waiting state should be changed */
    comp_time = data->segment.position;
    cmp_res = pads->priv->compare_func (pads, data, comp_time,
        pads->priv->earliest_data, pads->priv->earliest_time,
        pads->priv->compare_user_data);
    if (cmp_res > 0)
      /* stop waiting */
      gst_collect_pads_set_waiting (pads, data, FALSE);
    else {
      if (!GST_COLLECT_PADS_STATE_IS_SET (data, GST_COLLECT_PADS_STATE_WAITING)) {
        /* start waiting */
        gst_collect_pads_set_waiting (pads, data, TRUE);
        result = TRUE;
      }
    }
  }

  return result;
}

/**
 * gst_collect_pads_find_best_pad:
 * @pads: the collectpads to use
 * @data: returns the collectdata for earliest data
 * @time: returns the earliest available buffertime
 *
 * Find the oldest/best pad, i.e. pad holding the oldest buffer and
 * and return the corresponding #GstCollectData and buffertime.
 *
 * This function should be called with STREAM_LOCK held,
 * such as in the callback.
 */
static void
gst_collect_pads_find_best_pad (GstCollectPads * pads,
    GstCollectData ** data, GstClockTime * time)
{
  GSList *collected;
  GstCollectData *best = NULL;
  GstClockTime best_time = GST_CLOCK_TIME_NONE;

  g_return_if_fail (data != NULL);
  g_return_if_fail (time != NULL);

  for (collected = pads->data; collected; collected = g_slist_next (collected)) {
    GstBuffer *buffer;
    GstCollectData *data = (GstCollectData *) collected->data;
    GstClockTime timestamp;

    buffer = gst_collect_pads_peek (pads, data);
    /* if we have a buffer check if it is better then the current best one */
    if (buffer != NULL) {
      timestamp = GST_BUFFER_DTS (buffer);
      if (!GST_CLOCK_TIME_IS_VALID (timestamp)) {
        timestamp = GST_BUFFER_PTS (buffer);
      }
      gst_buffer_unref (buffer);
      if (best == NULL || pads->priv->compare_func (pads, data, timestamp,
              best, best_time, pads->priv->compare_user_data) < 0) {
        best = data;
        best_time = timestamp;
      }
    }
  }

  /* set earliest time */
  *data = best;
  *time = best_time;

  GST_DEBUG_OBJECT (pads, "best pad %s, best time %" GST_TIME_FORMAT,
      best ? GST_PAD_NAME (((GstCollectData *) best)->pad) : "(nil)",
      GST_TIME_ARGS (best_time));
}

/*
 * Function to recalculate earliest_data and earliest_timestamp. This also calls
 * gst_collect_pads_recalculate_waiting
 *
 * Must be called with STREAM_LOCK.
 */
static gboolean
gst_collect_pads_recalculate_full (GstCollectPads * pads)
{
  if (pads->priv->earliest_data)
    unref_data (pads->priv->earliest_data);
  gst_collect_pads_find_best_pad (pads, &pads->priv->earliest_data,
      &pads->priv->earliest_time);
  if (pads->priv->earliest_data)
    ref_data (pads->priv->earliest_data);
  return gst_collect_pads_recalculate_waiting (pads);
}

/*
 * Default collect callback triggered when #GstCollectPads gathered all data.
 *
 * Called with STREAM_LOCK.
 */
static GstFlowReturn
gst_collect_pads_default_collected (GstCollectPads * pads, gpointer user_data)
{
  GstCollectData *best = NULL;
  GstBuffer *buffer;
  GstFlowReturn ret = GST_FLOW_OK;
  GstCollectPadsBufferFunction func;
  gpointer buffer_user_data;

  g_return_val_if_fail (GST_IS_COLLECT_PADS (pads), GST_FLOW_ERROR);

  GST_OBJECT_LOCK (pads);
  func = pads->priv->buffer_func;
  buffer_user_data = pads->priv->buffer_user_data;
  GST_OBJECT_UNLOCK (pads);

  g_return_val_if_fail (func != NULL, GST_FLOW_NOT_SUPPORTED);

  /* Find the oldest pad at all cost */
  if (gst_collect_pads_recalculate_full (pads)) {
    /* waiting was switched on,
     * so give another thread a chance to deliver a possibly
     * older buffer; don't charge on yet with the current oldest */
    ret = GST_FLOW_OK;
    goto done;
  }

  best = pads->priv->earliest_data;

  /* No data collected means EOS. */
  if (G_UNLIKELY (best == NULL)) {
    ret = func (pads, best, NULL, buffer_user_data);
    if (ret == GST_FLOW_OK)
      ret = GST_FLOW_EOS;
    goto done;
  }

  /* make sure that the pad we take a buffer from is waiting;
   * otherwise popping a buffer will seem not to have happened
   * and collectpads can get into a busy loop */
  gst_collect_pads_set_waiting (pads, best, TRUE);

  /* Send buffer */
  buffer = gst_collect_pads_pop (pads, best);
  ret = func (pads, best, buffer, buffer_user_data);

  /* maybe non-waiting was forced to waiting above due to
   * newsegment events coming too sparsely,
   * so re-check to restore state to avoid hanging/waiting */
  gst_collect_pads_recalculate_full (pads);

done:
  return ret;
}

/*
 * Default timestamp compare function.
 */
static gint
gst_collect_pads_default_compare_func (GstCollectPads * pads,
    GstCollectData * data1, GstClockTime timestamp1,
    GstCollectData * data2, GstClockTime timestamp2, gpointer user_data)
{

  GST_LOG_OBJECT (pads, "comparing %" GST_TIME_FORMAT
      " and %" GST_TIME_FORMAT, GST_TIME_ARGS (timestamp1),
      GST_TIME_ARGS (timestamp2));
  /* non-valid timestamps go first as they are probably headers or so */
  if (G_UNLIKELY (!GST_CLOCK_TIME_IS_VALID (timestamp1)))
    return GST_CLOCK_TIME_IS_VALID (timestamp2) ? -1 : 0;

  if (G_UNLIKELY (!GST_CLOCK_TIME_IS_VALID (timestamp2)))
    return 1;

  /* compare timestamp */
  if (timestamp1 < timestamp2)
    return -1;

  if (timestamp1 > timestamp2)
    return 1;

  return 0;
}

/* called with STREAM_LOCK */
static void
gst_collect_pads_handle_position_update (GstCollectPads * pads,
    GstCollectData * data, GstClockTime new_pos)
{
  gint cmp_res;

  /* If oldest time is not known, or current pad got newsegment;
   * recalculate the state */
  if (!pads->priv->earliest_data || pads->priv->earliest_data == data) {
    gst_collect_pads_recalculate_full (pads);
    goto exit;
  }

  /* Check if the waiting state of the pad should change. */
  cmp_res =
      pads->priv->compare_func (pads, data, new_pos,
      pads->priv->earliest_data, pads->priv->earliest_time,
      pads->priv->compare_user_data);

  if (cmp_res > 0)
    /* Stop waiting */
    gst_collect_pads_set_waiting (pads, data, FALSE);

exit:
  return;

}

static GstClockTime
gst_collect_pads_clip_time (GstCollectPads * pads, GstCollectData * data,
    GstClockTime time)
{
  GstClockTime otime = time;
  GstBuffer *in, *out = NULL;

  if (pads->priv->clip_func) {
    in = gst_buffer_new ();
    GST_BUFFER_PTS (in) = time;
    GST_BUFFER_DTS (in) = time;
    pads->priv->clip_func (pads, data, in, &out, pads->priv->clip_user_data);
    if (out) {
      otime = GST_BUFFER_PTS (out);
      gst_buffer_unref (out);
    } else {
      /* FIXME should distinguish between ahead or after segment,
       * let's assume after segment and use some large time ... */
      otime = G_MAXINT64 / 2;
    }
  }

  return otime;
}

/**
 * gst_collect_pads_event_default:
 * @pads: the collectpads to use
 * @data: collect data of corresponding pad
 * @event: event being processed
 * @discard: process but do not send event downstream
 *
 * Default #GstCollectPads event handling that elements should always
 * chain up to to ensure proper operation.  Element might however indicate
 * event should not be forwarded downstream.
 */
gboolean
gst_collect_pads_event_default (GstCollectPads * pads, GstCollectData * data,
    GstEvent * event, gboolean discard)
{
  gboolean res = TRUE;
  GstCollectPadsBufferFunction buffer_func;
  GstObject *parent;
  GstPad *pad;

  GST_OBJECT_LOCK (pads);
  buffer_func = pads->priv->buffer_func;
  GST_OBJECT_UNLOCK (pads);

  pad = data->pad;
  parent = GST_OBJECT_PARENT (pad);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_FLUSH_START:
    {
      if (g_atomic_int_get (&pads->priv->seeking)) {
        /* drop all but the first FLUSH_STARTs when seeking */
        if (g_atomic_int_compare_and_exchange (&pads->priv->pending_flush_start,
                TRUE, FALSE) == FALSE)
          goto eat;

        /* unblock collect pads */
        gst_pad_event_default (pad, parent, event);
        event = NULL;

        GST_COLLECT_PADS_STREAM_LOCK (pads);
        /* Start flushing. We never call gst_collect_pads_set_flushing (FALSE), we
         * instead wait until each pad gets its FLUSH_STOP and let that reset the pad to
         * non-flushing (which happens in gst_collect_pads_event_default).
         */
        gst_collect_pads_set_flushing (pads, TRUE);

        if (pads->priv->flush_func)
          pads->priv->flush_func (pads, pads->priv->flush_user_data);

        g_atomic_int_set (&pads->priv->pending_flush_stop, TRUE);
        GST_COLLECT_PADS_STREAM_UNLOCK (pads);

        goto eat;
      } else {
        /* forward event to unblock check_collected */
        GST_DEBUG_OBJECT (pad, "forwarding flush start");
        res = gst_pad_event_default (pad, parent, event);
        event = NULL;

        /* now unblock the chain function.
         * no cond per pad, so they all unblock,
         * non-flushing block again */
        GST_COLLECT_PADS_STREAM_LOCK (pads);
        GST_COLLECT_PADS_STATE_SET (data, GST_COLLECT_PADS_STATE_FLUSHING);
        gst_collect_pads_clear (pads, data);

        /* cater for possible default muxing functionality */
        if (buffer_func) {
          /* restore to initial state */
          gst_collect_pads_set_waiting (pads, data, TRUE);
          /* if the current pad is affected, reset state, recalculate later */
          if (pads->priv->earliest_data == data) {
            unref_data (data);
            pads->priv->earliest_data = NULL;
            pads->priv->earliest_time = GST_CLOCK_TIME_NONE;
          }
        }

        GST_COLLECT_PADS_STREAM_UNLOCK (pads);

        goto eat;
      }
    }
    case GST_EVENT_FLUSH_STOP:
    {
      /* flush the 1 buffer queue */
      GST_COLLECT_PADS_STREAM_LOCK (pads);
      GST_COLLECT_PADS_STATE_UNSET (data, GST_COLLECT_PADS_STATE_FLUSHING);
      gst_collect_pads_clear (pads, data);
      /* we need new segment info after the flush */
      gst_segment_init (&data->segment, GST_FORMAT_UNDEFINED);
      GST_COLLECT_PADS_STATE_UNSET (data, GST_COLLECT_PADS_STATE_NEW_SEGMENT);
      /* if the pad was EOS, remove the EOS flag and
       * decrement the number of eospads */
      if (G_UNLIKELY (GST_COLLECT_PADS_STATE_IS_SET (data,
                  GST_COLLECT_PADS_STATE_EOS))) {
        if (!GST_COLLECT_PADS_STATE_IS_SET (data,
                GST_COLLECT_PADS_STATE_WAITING))
          pads->priv->queuedpads++;
        if (!g_atomic_int_get (&pads->priv->seeking)) {
          pads->priv->eospads--;
        }
        GST_COLLECT_PADS_STATE_UNSET (data, GST_COLLECT_PADS_STATE_EOS);
      }
      GST_COLLECT_PADS_STREAM_UNLOCK (pads);

      if (g_atomic_int_get (&pads->priv->seeking)) {
        if (g_atomic_int_compare_and_exchange (&pads->priv->pending_flush_stop,
                TRUE, FALSE))
          goto forward;
        else
          goto eat;
      } else {
        goto forward;
      }
    }
    case GST_EVENT_EOS:
    {
      GST_COLLECT_PADS_STREAM_LOCK (pads);
      /* if the pad was not EOS, make it EOS and so we
       * have one more eospad */
      if (G_LIKELY (!GST_COLLECT_PADS_STATE_IS_SET (data,
                  GST_COLLECT_PADS_STATE_EOS))) {
        GST_COLLECT_PADS_STATE_SET (data, GST_COLLECT_PADS_STATE_EOS);
        if (!GST_COLLECT_PADS_STATE_IS_SET (data,
                GST_COLLECT_PADS_STATE_WAITING))
          pads->priv->queuedpads--;
        pads->priv->eospads++;
      }
      /* check if we need collecting anything, we ignore the result. */
      gst_collect_pads_check_collected (pads);
      GST_COLLECT_PADS_STREAM_UNLOCK (pads);

      goto eat;
    }
    case GST_EVENT_SEGMENT:
    {
      GstSegment seg;

      GST_COLLECT_PADS_STREAM_LOCK (pads);

      gst_event_copy_segment (event, &seg);

      GST_DEBUG_OBJECT (data->pad, "got segment %" GST_SEGMENT_FORMAT, &seg);

      /* default collection can not handle other segment formats than time */
      if (buffer_func && seg.format != GST_FORMAT_TIME) {
        GST_WARNING_OBJECT (pads, "GstCollectPads default collecting "
            "can only handle time segments. Non time segment ignored.");
        goto newsegment_done;
      }

      /* need to update segment first */
      data->segment = seg;
      GST_COLLECT_PADS_STATE_SET (data, GST_COLLECT_PADS_STATE_NEW_SEGMENT);

      /* now we can use for e.g. running time */
      seg.position =
          gst_collect_pads_clip_time (pads, data, seg.start + seg.offset);
      /* update again */
      data->segment = seg;

      /* default muxing functionality */
      if (!buffer_func)
        goto newsegment_done;

      gst_collect_pads_handle_position_update (pads, data, seg.position);

    newsegment_done:
      GST_COLLECT_PADS_STREAM_UNLOCK (pads);
      /* we must not forward this event since multiple segments will be
       * accumulated and this is certainly not what we want. */
      goto eat;
    }
    case GST_EVENT_GAP:
    {
      GstClockTime start, duration;

      GST_COLLECT_PADS_STREAM_LOCK (pads);

      gst_event_parse_gap (event, &start, &duration);
      /* FIXME, handle reverse playback case */
      if (GST_CLOCK_TIME_IS_VALID (duration))
        start += duration;
      /* we do not expect another buffer until after gap,
       * so that is our position now */
      data->segment.position = gst_collect_pads_clip_time (pads, data, start);

      gst_collect_pads_handle_position_update (pads, data,
          data->segment.position);

      GST_COLLECT_PADS_STREAM_UNLOCK (pads);
      goto eat;
    }
    case GST_EVENT_STREAM_START:
      /* drop stream start events, element must create its own start event,
       * we can't just forward the first random stream start event we get */
      goto eat;
    case GST_EVENT_CAPS:
      goto eat;
    default:
      /* forward other events */
      goto forward;
  }

eat:
  if (event)
    gst_event_unref (event);
  return res;

forward:
  if (discard)
    goto eat;
  else
    return gst_pad_event_default (pad, parent, event);
}

typedef struct
{
  GstEvent *event;
  gboolean result;
} EventData;

static gboolean
event_forward_func (GstPad * pad, EventData * data)
{
  gboolean ret = TRUE;
  GstPad *peer = gst_pad_get_peer (pad);

  if (peer) {
    ret = gst_pad_send_event (peer, gst_event_ref (data->event));
    gst_object_unref (peer);
  }

  data->result &= ret;
  /* Always send to all pads */
  return FALSE;
}

static gboolean
forward_event_to_all_sinkpads (GstPad * srcpad, GstEvent * event)
{
  EventData data;

  data.event = event;
  data.result = TRUE;

  gst_pad_forward (srcpad, (GstPadForwardFunction) event_forward_func, &data);

  gst_event_unref (event);

  return data.result;
}

/**
 * gst_collect_pads_src_event_default:
 * @pads: the #GstCollectPads to use
 * @pad: src #GstPad that received the event
 * @event: event being processed
 *
 * Default #GstCollectPads event handling for the src pad of elements.
 * Elements can chain up to this to let flushing seek event handling
 * be done by #GstCollectPads.
 *
 * Since: 1.4
 */
gboolean
gst_collect_pads_src_event_default (GstCollectPads * pads, GstPad * pad,
    GstEvent * event)
{
  GstObject *parent;
  gboolean res = TRUE;

  parent = GST_OBJECT_PARENT (pad);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_SEEK:{
      GstSeekFlags flags;

      pads->priv->eospads = 0;

      GST_INFO_OBJECT (pads, "starting seek");

      gst_event_parse_seek (event, NULL, NULL, &flags, NULL, NULL, NULL, NULL);
      if (flags & GST_SEEK_FLAG_FLUSH) {
        g_atomic_int_set (&pads->priv->seeking, TRUE);
        g_atomic_int_set (&pads->priv->pending_flush_start, TRUE);
        /* forward the seek upstream */
        res = forward_event_to_all_sinkpads (pad, event);
        event = NULL;
        if (!res) {
          g_atomic_int_set (&pads->priv->seeking, FALSE);
          g_atomic_int_set (&pads->priv->pending_flush_start, FALSE);
        }
      }

      GST_INFO_OBJECT (pads, "seek done, result: %d", res);

      break;
    }
    default:
      break;
  }

  if (event)
    res = gst_pad_event_default (pad, parent, event);

  return res;
}

static gboolean
gst_collect_pads_event_default_internal (GstCollectPads * pads,
    GstCollectData * data, GstEvent * event, gpointer user_data)
{
  return gst_collect_pads_event_default (pads, data, event, FALSE);
}

static gboolean
gst_collect_pads_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  gboolean res = FALSE, need_unlock = FALSE;
  GstCollectData *data;
  GstCollectPads *pads;
  GstCollectPadsEventFunction event_func;
  gpointer event_user_data;

  /* some magic to get the managing collect_pads */
  GST_OBJECT_LOCK (pad);
  data = (GstCollectData *) gst_pad_get_element_private (pad);
  if (G_UNLIKELY (data == NULL))
    goto pad_removed;
  ref_data (data);
  GST_OBJECT_UNLOCK (pad);

  res = FALSE;

  pads = data->collect;

  GST_DEBUG_OBJECT (data->pad, "Got %s event on sink pad",
      GST_EVENT_TYPE_NAME (event));

  GST_OBJECT_LOCK (pads);
  event_func = pads->priv->event_func;
  event_user_data = pads->priv->event_user_data;
  GST_OBJECT_UNLOCK (pads);

  if (GST_EVENT_IS_SERIALIZED (event)) {
    GST_COLLECT_PADS_STREAM_LOCK (pads);
    need_unlock = TRUE;
  }

  if (G_LIKELY (event_func)) {
    res = event_func (pads, data, event, event_user_data);
  }

  if (need_unlock)
    GST_COLLECT_PADS_STREAM_UNLOCK (pads);

  unref_data (data);
  return res;

  /* ERRORS */
pad_removed:
  {
    GST_DEBUG ("%s got removed from collectpads", GST_OBJECT_NAME (pad));
    GST_OBJECT_UNLOCK (pad);
    return FALSE;
  }
}

/**
 * gst_collect_pads_query_default:
 * @pads: the collectpads to use
 * @data: collect data of corresponding pad
 * @query: query being processed
 * @discard: process but do not send event downstream
 *
 * Default #GstCollectPads query handling that elements should always
 * chain up to to ensure proper operation.  Element might however indicate
 * query should not be forwarded downstream.
 */
gboolean
gst_collect_pads_query_default (GstCollectPads * pads, GstCollectData * data,
    GstQuery * query, gboolean discard)
{
  gboolean res = TRUE;
  GstObject *parent;
  GstPad *pad;

  pad = data->pad;
  parent = GST_OBJECT_PARENT (pad);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_SEEKING:
    {
      GstFormat format;

      /* don't pass it along as some (file)sink might claim it does
       * whereas with a collectpads in between that will not likely work */
      gst_query_parse_seeking (query, &format, NULL, NULL, NULL);
      gst_query_set_seeking (query, format, FALSE, 0, -1);
      res = TRUE;
      discard = TRUE;
      break;
    }
    default:
      break;
  }

  if (!discard)
    return gst_pad_query_default (pad, parent, query);
  else
    return res;
}

static gboolean
gst_collect_pads_query_default_internal (GstCollectPads * pads,
    GstCollectData * data, GstQuery * query, gpointer user_data)
{
  return gst_collect_pads_query_default (pads, data, query, FALSE);
}

static gboolean
gst_collect_pads_query (GstPad * pad, GstObject * parent, GstQuery * query)
{
  gboolean res = FALSE, need_unlock = FALSE;
  GstCollectData *data;
  GstCollectPads *pads;
  GstCollectPadsQueryFunction query_func;
  gpointer query_user_data;

  GST_DEBUG_OBJECT (pad, "Got %s query on sink pad",
      GST_QUERY_TYPE_NAME (query));

  /* some magic to get the managing collect_pads */
  GST_OBJECT_LOCK (pad);
  data = (GstCollectData *) gst_pad_get_element_private (pad);
  if (G_UNLIKELY (data == NULL))
    goto pad_removed;
  ref_data (data);
  GST_OBJECT_UNLOCK (pad);

  pads = data->collect;

  GST_OBJECT_LOCK (pads);
  query_func = pads->priv->query_func;
  query_user_data = pads->priv->query_user_data;
  GST_OBJECT_UNLOCK (pads);

  if (GST_QUERY_IS_SERIALIZED (query)) {
    GST_COLLECT_PADS_STREAM_LOCK (pads);
    need_unlock = TRUE;
  }

  if (G_LIKELY (query_func)) {
    res = query_func (pads, data, query, query_user_data);
  }

  if (need_unlock)
    GST_COLLECT_PADS_STREAM_UNLOCK (pads);

  unref_data (data);
  return res;

  /* ERRORS */
pad_removed:
  {
    GST_DEBUG ("%s got removed from collectpads", GST_OBJECT_NAME (pad));
    GST_OBJECT_UNLOCK (pad);
    return FALSE;
  }
}


/* For each buffer we receive we check if our collected condition is reached
 * and if so we call the collected function. When this is done we check if
 * data has been unqueued. If data is still queued we wait holding the stream
 * lock to make sure no EOS event can happen while we are ready to be
 * collected 
 */
static GstFlowReturn
gst_collect_pads_chain (GstPad * pad, GstObject * parent, GstBuffer * buffer)
{
  GstCollectData *data;
  GstCollectPads *pads;
  GstFlowReturn ret;
  GstBuffer **buffer_p;
  guint32 cookie;

  GST_DEBUG ("Got buffer for pad %s:%s", GST_DEBUG_PAD_NAME (pad));

  /* some magic to get the managing collect_pads */
  GST_OBJECT_LOCK (pad);
  data = (GstCollectData *) gst_pad_get_element_private (pad);
  if (G_UNLIKELY (data == NULL))
    goto no_data;
  ref_data (data);
  GST_OBJECT_UNLOCK (pad);

  pads = data->collect;

  GST_COLLECT_PADS_STREAM_LOCK (pads);
  /* if not started, bail out */
  if (G_UNLIKELY (!pads->priv->started))
    goto not_started;
  /* check if this pad is flushing */
  if (G_UNLIKELY (GST_COLLECT_PADS_STATE_IS_SET (data,
              GST_COLLECT_PADS_STATE_FLUSHING)))
    goto flushing;
  /* pad was EOS, we can refuse this data */
  if (G_UNLIKELY (GST_COLLECT_PADS_STATE_IS_SET (data,
              GST_COLLECT_PADS_STATE_EOS)))
    goto eos;

  /* see if we need to clip */
  if (pads->priv->clip_func) {
    GstBuffer *outbuf = NULL;
    ret =
        pads->priv->clip_func (pads, data, buffer, &outbuf,
        pads->priv->clip_user_data);
    buffer = outbuf;

    if (G_UNLIKELY (outbuf == NULL))
      goto clipped;

    if (G_UNLIKELY (ret == GST_FLOW_EOS))
      goto eos;
    else if (G_UNLIKELY (ret != GST_FLOW_OK))
      goto error;
  }

  GST_DEBUG_OBJECT (pads, "Queuing buffer %p for pad %s:%s", buffer,
      GST_DEBUG_PAD_NAME (pad));

  /* One more pad has data queued */
  if (GST_COLLECT_PADS_STATE_IS_SET (data, GST_COLLECT_PADS_STATE_WAITING))
    pads->priv->queuedpads++;
  buffer_p = &data->buffer;
  gst_buffer_replace (buffer_p, buffer);

  /* update segment last position if in TIME */
  if (G_LIKELY (data->segment.format == GST_FORMAT_TIME)) {
    GstClockTime timestamp;

    timestamp = GST_BUFFER_DTS (buffer);
    if (!GST_CLOCK_TIME_IS_VALID (timestamp))
      timestamp = GST_BUFFER_PTS (buffer);

    if (GST_CLOCK_TIME_IS_VALID (timestamp))
      data->segment.position = timestamp;
  }

  /* While we have data queued on this pad try to collect stuff */
  do {
    /* Check if our collected condition is matched and call the collected
     * function if it is */
    ret = gst_collect_pads_check_collected (pads);
    /* when an error occurs, we want to report this back to the caller ASAP
     * without having to block if the buffer was not popped */
    if (G_UNLIKELY (ret != GST_FLOW_OK))
      goto error;

    /* data was consumed, we can exit and accept new data */
    if (data->buffer == NULL)
      break;

    /* Having the _INIT here means we don't care about any broadcast up to here
     * (most of which occur with STREAM_LOCK held, so could not have happened
     * anyway).  We do care about e.g. a remove initiated broadcast as of this
     * point.  Putting it here also makes this thread ignores any evt it raised
     * itself (as is a usual WAIT semantic).
     */
    GST_COLLECT_PADS_EVT_INIT (cookie);

    /* pad could be removed and re-added */
    unref_data (data);
    GST_OBJECT_LOCK (pad);
    if (G_UNLIKELY ((data = gst_pad_get_element_private (pad)) == NULL))
      goto pad_removed;
    ref_data (data);
    GST_OBJECT_UNLOCK (pad);

    GST_DEBUG_OBJECT (pads, "Pad %s:%s has a buffer queued, waiting",
        GST_DEBUG_PAD_NAME (pad));

    /* wait to be collected, this must happen from another thread triggered
     * by the _chain function of another pad. We release the lock so we
     * can get stopped or flushed as well. We can however not get EOS
     * because we still hold the STREAM_LOCK.
     */
    GST_COLLECT_PADS_STREAM_UNLOCK (pads);
    GST_COLLECT_PADS_EVT_WAIT (pads, cookie);
    GST_COLLECT_PADS_STREAM_LOCK (pads);

    GST_DEBUG_OBJECT (pads, "Pad %s:%s resuming", GST_DEBUG_PAD_NAME (pad));

    /* after a signal, we could be stopped */
    if (G_UNLIKELY (!pads->priv->started))
      goto not_started;
    /* check if this pad is flushing */
    if (G_UNLIKELY (GST_COLLECT_PADS_STATE_IS_SET (data,
                GST_COLLECT_PADS_STATE_FLUSHING)))
      goto flushing;
  }
  while (data->buffer != NULL);

unlock_done:
  GST_COLLECT_PADS_STREAM_UNLOCK (pads);
  /* data is definitely NULL if pad_removed goto was run. */
  if (data)
    unref_data (data);
  if (buffer)
    gst_buffer_unref (buffer);
  return ret;

pad_removed:
  {
    GST_WARNING ("%s got removed from collectpads", GST_OBJECT_NAME (pad));
    GST_OBJECT_UNLOCK (pad);
    ret = GST_FLOW_NOT_LINKED;
    goto unlock_done;
  }
  /* ERRORS */
no_data:
  {
    GST_DEBUG ("%s got removed from collectpads", GST_OBJECT_NAME (pad));
    GST_OBJECT_UNLOCK (pad);
    gst_buffer_unref (buffer);
    return GST_FLOW_NOT_LINKED;
  }
not_started:
  {
    GST_DEBUG ("not started");
    gst_collect_pads_clear (pads, data);
    ret = GST_FLOW_FLUSHING;
    goto unlock_done;
  }
flushing:
  {
    GST_DEBUG ("pad %s:%s is flushing", GST_DEBUG_PAD_NAME (pad));
    gst_collect_pads_clear (pads, data);
    ret = GST_FLOW_FLUSHING;
    goto unlock_done;
  }
eos:
  {
    /* we should not post an error for this, just inform upstream that
     * we don't expect anything anymore */
    GST_DEBUG ("pad %s:%s is eos", GST_DEBUG_PAD_NAME (pad));
    ret = GST_FLOW_EOS;
    goto unlock_done;
  }
clipped:
  {
    GST_DEBUG ("clipped buffer on pad %s:%s", GST_DEBUG_PAD_NAME (pad));
    ret = GST_FLOW_OK;
    goto unlock_done;
  }
error:
  {
    /* we print the error, the element should post a reasonable error
     * message for fatal errors */
    GST_DEBUG ("collect failed, reason %d (%s)", ret, gst_flow_get_name (ret));
    gst_collect_pads_clear (pads, data);
    goto unlock_done;
  }
}
