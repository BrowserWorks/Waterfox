/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *               2000,2005 Wim Taymans <wim@fluendo.com>
 *
 * gstbasesrc.c:
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
 * SECTION:gstbasesrc
 * @short_description: Base class for getrange based source elements
 * @see_also: #GstPushSrc, #GstBaseTransform, #GstBaseSink
 *
 * This is a generic base class for source elements. The following
 * types of sources are supported:
 * <itemizedlist>
 *   <listitem><para>random access sources like files</para></listitem>
 *   <listitem><para>seekable sources</para></listitem>
 *   <listitem><para>live sources</para></listitem>
 * </itemizedlist>
 *
 * The source can be configured to operate in any #GstFormat with the
 * gst_base_src_set_format() method. The currently set format determines
 * the format of the internal #GstSegment and any %GST_EVENT_SEGMENT
 * events. The default format for #GstBaseSrc is %GST_FORMAT_BYTES.
 *
 * #GstBaseSrc always supports push mode scheduling. If the following
 * conditions are met, it also supports pull mode scheduling:
 * <itemizedlist>
 *   <listitem><para>The format is set to %GST_FORMAT_BYTES (default).</para>
 *   </listitem>
 *   <listitem><para>#GstBaseSrcClass.is_seekable() returns %TRUE.</para>
 *   </listitem>
 * </itemizedlist>
 *
 * If all the conditions are met for operating in pull mode, #GstBaseSrc is
 * automatically seekable in push mode as well. The following conditions must
 * be met to make the element seekable in push mode when the format is not
 * %GST_FORMAT_BYTES:
 * <itemizedlist>
 *   <listitem><para>
 *     #GstBaseSrcClass.is_seekable() returns %TRUE.
 *   </para></listitem>
 *   <listitem><para>
 *     #GstBaseSrcClass.query() can convert all supported seek formats to the
 *     internal format as set with gst_base_src_set_format().
 *   </para></listitem>
 *   <listitem><para>
 *     #GstBaseSrcClass.do_seek() is implemented, performs the seek and returns
 *      %TRUE.
 *   </para></listitem>
 * </itemizedlist>
 *
 * When the element does not meet the requirements to operate in pull mode, the
 * offset and length in the #GstBaseSrcClass.create() method should be ignored.
 * It is recommended to subclass #GstPushSrc instead, in this situation. If the
 * element can operate in pull mode but only with specific offsets and
 * lengths, it is allowed to generate an error when the wrong values are passed
 * to the #GstBaseSrcClass.create() function.
 *
 * #GstBaseSrc has support for live sources. Live sources are sources that when
 * paused discard data, such as audio or video capture devices. A typical live
 * source also produces data at a fixed rate and thus provides a clock to publish
 * this rate.
 * Use gst_base_src_set_live() to activate the live source mode.
 *
 * A live source does not produce data in the PAUSED state. This means that the
 * #GstBaseSrcClass.create() method will not be called in PAUSED but only in
 * PLAYING. To signal the pipeline that the element will not produce data, the
 * return value from the READY to PAUSED state will be
 * %GST_STATE_CHANGE_NO_PREROLL.
 *
 * A typical live source will timestamp the buffers it creates with the
 * current running time of the pipeline. This is one reason why a live source
 * can only produce data in the PLAYING state, when the clock is actually
 * distributed and running.
 *
 * Live sources that synchronize and block on the clock (an audio source, for
 * example) can use gst_base_src_wait_playing() when the
 * #GstBaseSrcClass.create() function was interrupted by a state change to
 * PAUSED.
 *
 * The #GstBaseSrcClass.get_times() method can be used to implement pseudo-live
 * sources. It only makes sense to implement the #GstBaseSrcClass.get_times()
 * function if the source is a live source. The #GstBaseSrcClass.get_times()
 * function should return timestamps starting from 0, as if it were a non-live
 * source. The base class will make sure that the timestamps are transformed
 * into the current running_time. The base source will then wait for the
 * calculated running_time before pushing out the buffer.
 *
 * For live sources, the base class will by default report a latency of 0.
 * For pseudo live sources, the base class will by default measure the difference
 * between the first buffer timestamp and the start time of get_times and will
 * report this value as the latency.
 * Subclasses should override the query function when this behaviour is not
 * acceptable.
 *
 * There is only support in #GstBaseSrc for exactly one source pad, which
 * should be named "src". A source implementation (subclass of #GstBaseSrc)
 * should install a pad template in its class_init function, like so:
 * |[
 * static void
 * my_element_class_init (GstMyElementClass *klass)
 * {
 *   GstElementClass *gstelement_class = GST_ELEMENT_CLASS (klass);
 *   // srctemplate should be a #GstStaticPadTemplate with direction
 *   // %GST_PAD_SRC and name "src"
 *   gst_element_class_add_pad_template (gstelement_class,
 *       gst_static_pad_template_get (&amp;srctemplate));
 *
 *   gst_element_class_set_static_metadata (gstelement_class,
 *      "Source name",
 *      "Source",
 *      "My Source element",
 *      "The author &lt;my.sink@my.email&gt;");
 * }
 * ]|
 *
 * <refsect2>
 * <title>Controlled shutdown of live sources in applications</title>
 * <para>
 * Applications that record from a live source may want to stop recording
 * in a controlled way, so that the recording is stopped, but the data
 * already in the pipeline is processed to the end (remember that many live
 * sources would go on recording forever otherwise). For that to happen the
 * application needs to make the source stop recording and send an EOS
 * event down the pipeline. The application would then wait for an
 * EOS message posted on the pipeline's bus to know when all data has
 * been processed and the pipeline can safely be stopped.
 *
 * An application may send an EOS event to a source element to make it
 * perform the EOS logic (send EOS event downstream or post a
 * %GST_MESSAGE_SEGMENT_DONE on the bus). This can typically be done
 * with the gst_element_send_event() function on the element or its parent bin.
 *
 * After the EOS has been sent to the element, the application should wait for
 * an EOS message to be posted on the pipeline's bus. Once this EOS message is
 * received, it may safely shut down the entire pipeline.
 * </para>
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <stdlib.h>
#include <string.h>

#include <gst/gst_private.h>
#include <gst/glib-compat-private.h>

#include "gstbasesrc.h"
#include "gsttypefindhelper.h"
#include <gst/gst-i18n-lib.h>

GST_DEBUG_CATEGORY_STATIC (gst_base_src_debug);
#define GST_CAT_DEFAULT gst_base_src_debug

#define GST_LIVE_GET_LOCK(elem)               (&GST_BASE_SRC_CAST(elem)->live_lock)
#define GST_LIVE_LOCK(elem)                   g_mutex_lock(GST_LIVE_GET_LOCK(elem))
#define GST_LIVE_TRYLOCK(elem)                g_mutex_trylock(GST_LIVE_GET_LOCK(elem))
#define GST_LIVE_UNLOCK(elem)                 g_mutex_unlock(GST_LIVE_GET_LOCK(elem))
#define GST_LIVE_GET_COND(elem)               (&GST_BASE_SRC_CAST(elem)->live_cond)
#define GST_LIVE_WAIT(elem)                   g_cond_wait (GST_LIVE_GET_COND (elem), GST_LIVE_GET_LOCK (elem))
#define GST_LIVE_WAIT_UNTIL(elem, end_time)   g_cond_timed_wait (GST_LIVE_GET_COND (elem), GST_LIVE_GET_LOCK (elem), end_time)
#define GST_LIVE_SIGNAL(elem)                 g_cond_signal (GST_LIVE_GET_COND (elem));
#define GST_LIVE_BROADCAST(elem)              g_cond_broadcast (GST_LIVE_GET_COND (elem));


#define GST_ASYNC_GET_COND(elem)              (&GST_BASE_SRC_CAST(elem)->priv->async_cond)
#define GST_ASYNC_WAIT(elem)                  g_cond_wait (GST_ASYNC_GET_COND (elem), GST_OBJECT_GET_LOCK (elem))
#define GST_ASYNC_SIGNAL(elem)                g_cond_signal (GST_ASYNC_GET_COND (elem));

#define CLEAR_PENDING_EOS(bsrc) \
  G_STMT_START { \
    g_atomic_int_set (&bsrc->priv->has_pending_eos, FALSE); \
    gst_event_replace (&bsrc->priv->pending_eos, NULL); \
  } G_STMT_END


/* BaseSrc signals and args */
enum
{
  /* FILL ME */
  LAST_SIGNAL
};

#define DEFAULT_BLOCKSIZE       4096
#define DEFAULT_NUM_BUFFERS     -1
#define DEFAULT_TYPEFIND        FALSE
#define DEFAULT_DO_TIMESTAMP    FALSE

enum
{
  PROP_0,
  PROP_BLOCKSIZE,
  PROP_NUM_BUFFERS,
  PROP_TYPEFIND,
  PROP_DO_TIMESTAMP
};

#define GST_BASE_SRC_GET_PRIVATE(obj)  \
   (G_TYPE_INSTANCE_GET_PRIVATE ((obj), GST_TYPE_BASE_SRC, GstBaseSrcPrivate))

struct _GstBaseSrcPrivate
{
  gboolean discont;
  gboolean flushing;

  GstFlowReturn start_result;
  gboolean async;

  /* if a stream-start event should be sent */
  gboolean stream_start_pending;

  /* if segment should be sent and a
   * seqnum if it was originated by a seek */
  gboolean segment_pending;
  guint32 segment_seqnum;

  /* if EOS is pending (atomic) */
  GstEvent *pending_eos;
  gint has_pending_eos;

  /* if the eos was caused by a forced eos from the application */
  gboolean forced_eos;

  /* startup latency is the time it takes between going to PLAYING and producing
   * the first BUFFER with running_time 0. This value is included in the latency
   * reporting. */
  GstClockTime latency;
  /* timestamp offset, this is the offset add to the values of gst_times for
   * pseudo live sources */
  GstClockTimeDiff ts_offset;

  gboolean do_timestamp;
  volatile gint dynamic_size;
  volatile gint automatic_eos;

  /* stream sequence number */
  guint32 seqnum;

  /* pending events (TAG, CUSTOM_BOTH, CUSTOM_DOWNSTREAM) to be
   * pushed in the data stream */
  GList *pending_events;
  volatile gint have_events;

  /* QoS *//* with LOCK */
  gboolean qos_enabled;
  gdouble proportion;
  GstClockTime earliest_time;

  GstBufferPool *pool;
  GstAllocator *allocator;
  GstAllocationParams params;

  GCond async_cond;
};

static GstElementClass *parent_class = NULL;

static void gst_base_src_class_init (GstBaseSrcClass * klass);
static void gst_base_src_init (GstBaseSrc * src, gpointer g_class);
static void gst_base_src_finalize (GObject * object);


GType
gst_base_src_get_type (void)
{
  static volatile gsize base_src_type = 0;

  if (g_once_init_enter (&base_src_type)) {
    GType _type;
    static const GTypeInfo base_src_info = {
      sizeof (GstBaseSrcClass),
      NULL,
      NULL,
      (GClassInitFunc) gst_base_src_class_init,
      NULL,
      NULL,
      sizeof (GstBaseSrc),
      0,
      (GInstanceInitFunc) gst_base_src_init,
    };

    _type = g_type_register_static (GST_TYPE_ELEMENT,
        "GstBaseSrc", &base_src_info, G_TYPE_FLAG_ABSTRACT);
    g_once_init_leave (&base_src_type, _type);
  }
  return base_src_type;
}

static GstCaps *gst_base_src_default_get_caps (GstBaseSrc * bsrc,
    GstCaps * filter);
static GstCaps *gst_base_src_default_fixate (GstBaseSrc * src, GstCaps * caps);
static GstCaps *gst_base_src_fixate (GstBaseSrc * src, GstCaps * caps);

static gboolean gst_base_src_is_random_access (GstBaseSrc * src);
static gboolean gst_base_src_activate_mode (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active);
static void gst_base_src_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_base_src_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);
static gboolean gst_base_src_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static gboolean gst_base_src_send_event (GstElement * elem, GstEvent * event);
static gboolean gst_base_src_default_event (GstBaseSrc * src, GstEvent * event);

static gboolean gst_base_src_query (GstPad * pad, GstObject * parent,
    GstQuery * query);

static gboolean gst_base_src_activate_pool (GstBaseSrc * basesrc,
    gboolean active);
static gboolean gst_base_src_default_negotiate (GstBaseSrc * basesrc);
static gboolean gst_base_src_default_do_seek (GstBaseSrc * src,
    GstSegment * segment);
static gboolean gst_base_src_default_query (GstBaseSrc * src, GstQuery * query);
static gboolean gst_base_src_default_prepare_seek_segment (GstBaseSrc * src,
    GstEvent * event, GstSegment * segment);
static GstFlowReturn gst_base_src_default_create (GstBaseSrc * basesrc,
    guint64 offset, guint size, GstBuffer ** buf);
static GstFlowReturn gst_base_src_default_alloc (GstBaseSrc * basesrc,
    guint64 offset, guint size, GstBuffer ** buf);
static gboolean gst_base_src_decide_allocation_default (GstBaseSrc * basesrc,
    GstQuery * query);

static gboolean gst_base_src_set_flushing (GstBaseSrc * basesrc,
    gboolean flushing, gboolean live_play, gboolean * playing);

static gboolean gst_base_src_start (GstBaseSrc * basesrc);
static gboolean gst_base_src_stop (GstBaseSrc * basesrc);

static GstStateChangeReturn gst_base_src_change_state (GstElement * element,
    GstStateChange transition);

static void gst_base_src_loop (GstPad * pad);
static GstFlowReturn gst_base_src_getrange (GstPad * pad, GstObject * parent,
    guint64 offset, guint length, GstBuffer ** buf);
static GstFlowReturn gst_base_src_get_range (GstBaseSrc * src, guint64 offset,
    guint length, GstBuffer ** buf);
static gboolean gst_base_src_seekable (GstBaseSrc * src);
static gboolean gst_base_src_negotiate (GstBaseSrc * basesrc);
static gboolean gst_base_src_update_length (GstBaseSrc * src, guint64 offset,
    guint * length, gboolean force);

static void
gst_base_src_class_init (GstBaseSrcClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;

  gobject_class = G_OBJECT_CLASS (klass);
  gstelement_class = GST_ELEMENT_CLASS (klass);

  GST_DEBUG_CATEGORY_INIT (gst_base_src_debug, "basesrc", 0, "basesrc element");

  g_type_class_add_private (klass, sizeof (GstBaseSrcPrivate));

  parent_class = g_type_class_peek_parent (klass);

  gobject_class->finalize = gst_base_src_finalize;
  gobject_class->set_property = gst_base_src_set_property;
  gobject_class->get_property = gst_base_src_get_property;

  g_object_class_install_property (gobject_class, PROP_BLOCKSIZE,
      g_param_spec_uint ("blocksize", "Block size",
          "Size in bytes to read per buffer (-1 = default)", 0, G_MAXUINT,
          DEFAULT_BLOCKSIZE, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_NUM_BUFFERS,
      g_param_spec_int ("num-buffers", "num-buffers",
          "Number of buffers to output before sending EOS (-1 = unlimited)",
          -1, G_MAXINT, DEFAULT_NUM_BUFFERS, G_PARAM_READWRITE |
          G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_TYPEFIND,
      g_param_spec_boolean ("typefind", "Typefind",
          "Run typefind before negotiating", DEFAULT_TYPEFIND,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_DO_TIMESTAMP,
      g_param_spec_boolean ("do-timestamp", "Do timestamp",
          "Apply current stream time to buffers", DEFAULT_DO_TIMESTAMP,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gstelement_class->change_state =
      GST_DEBUG_FUNCPTR (gst_base_src_change_state);
  gstelement_class->send_event = GST_DEBUG_FUNCPTR (gst_base_src_send_event);

  klass->get_caps = GST_DEBUG_FUNCPTR (gst_base_src_default_get_caps);
  klass->negotiate = GST_DEBUG_FUNCPTR (gst_base_src_default_negotiate);
  klass->fixate = GST_DEBUG_FUNCPTR (gst_base_src_default_fixate);
  klass->prepare_seek_segment =
      GST_DEBUG_FUNCPTR (gst_base_src_default_prepare_seek_segment);
  klass->do_seek = GST_DEBUG_FUNCPTR (gst_base_src_default_do_seek);
  klass->query = GST_DEBUG_FUNCPTR (gst_base_src_default_query);
  klass->event = GST_DEBUG_FUNCPTR (gst_base_src_default_event);
  klass->create = GST_DEBUG_FUNCPTR (gst_base_src_default_create);
  klass->alloc = GST_DEBUG_FUNCPTR (gst_base_src_default_alloc);
  klass->decide_allocation =
      GST_DEBUG_FUNCPTR (gst_base_src_decide_allocation_default);

  /* Registering debug symbols for function pointers */
  GST_DEBUG_REGISTER_FUNCPTR (gst_base_src_activate_mode);
  GST_DEBUG_REGISTER_FUNCPTR (gst_base_src_event);
  GST_DEBUG_REGISTER_FUNCPTR (gst_base_src_query);
  GST_DEBUG_REGISTER_FUNCPTR (gst_base_src_getrange);
  GST_DEBUG_REGISTER_FUNCPTR (gst_base_src_fixate);
}

static void
gst_base_src_init (GstBaseSrc * basesrc, gpointer g_class)
{
  GstPad *pad;
  GstPadTemplate *pad_template;

  basesrc->priv = GST_BASE_SRC_GET_PRIVATE (basesrc);

  basesrc->is_live = FALSE;
  g_mutex_init (&basesrc->live_lock);
  g_cond_init (&basesrc->live_cond);
  basesrc->num_buffers = DEFAULT_NUM_BUFFERS;
  basesrc->num_buffers_left = -1;
  basesrc->priv->automatic_eos = TRUE;

  basesrc->can_activate_push = TRUE;

  pad_template =
      gst_element_class_get_pad_template (GST_ELEMENT_CLASS (g_class), "src");
  g_return_if_fail (pad_template != NULL);

  GST_DEBUG_OBJECT (basesrc, "creating src pad");
  pad = gst_pad_new_from_template (pad_template, "src");

  GST_DEBUG_OBJECT (basesrc, "setting functions on src pad");
  gst_pad_set_activatemode_function (pad, gst_base_src_activate_mode);
  gst_pad_set_event_function (pad, gst_base_src_event);
  gst_pad_set_query_function (pad, gst_base_src_query);
  gst_pad_set_getrange_function (pad, gst_base_src_getrange);

  /* hold pointer to pad */
  basesrc->srcpad = pad;
  GST_DEBUG_OBJECT (basesrc, "adding src pad");
  gst_element_add_pad (GST_ELEMENT (basesrc), pad);

  basesrc->blocksize = DEFAULT_BLOCKSIZE;
  basesrc->clock_id = NULL;
  /* we operate in BYTES by default */
  gst_base_src_set_format (basesrc, GST_FORMAT_BYTES);
  basesrc->typefind = DEFAULT_TYPEFIND;
  basesrc->priv->do_timestamp = DEFAULT_DO_TIMESTAMP;
  g_atomic_int_set (&basesrc->priv->have_events, FALSE);

  g_cond_init (&basesrc->priv->async_cond);
  basesrc->priv->start_result = GST_FLOW_FLUSHING;
  GST_OBJECT_FLAG_UNSET (basesrc, GST_BASE_SRC_FLAG_STARTED);
  GST_OBJECT_FLAG_UNSET (basesrc, GST_BASE_SRC_FLAG_STARTING);
  GST_OBJECT_FLAG_SET (basesrc, GST_ELEMENT_FLAG_SOURCE);

  GST_DEBUG_OBJECT (basesrc, "init done");
}

static void
gst_base_src_finalize (GObject * object)
{
  GstBaseSrc *basesrc;
  GstEvent **event_p;

  basesrc = GST_BASE_SRC (object);

  g_mutex_clear (&basesrc->live_lock);
  g_cond_clear (&basesrc->live_cond);
  g_cond_clear (&basesrc->priv->async_cond);

  event_p = &basesrc->pending_seek;
  gst_event_replace (event_p, NULL);

  if (basesrc->priv->pending_events) {
    g_list_foreach (basesrc->priv->pending_events, (GFunc) gst_event_unref,
        NULL);
    g_list_free (basesrc->priv->pending_events);
  }

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

/**
 * gst_base_src_wait_playing:
 * @src: the src
 *
 * If the #GstBaseSrcClass.create() method performs its own synchronisation
 * against the clock it must unblock when going from PLAYING to the PAUSED state
 * and call this method before continuing to produce the remaining data.
 *
 * This function will block until a state change to PLAYING happens (in which
 * case this function returns %GST_FLOW_OK) or the processing must be stopped due
 * to a state change to READY or a FLUSH event (in which case this function
 * returns %GST_FLOW_FLUSHING).
 *
 * Returns: %GST_FLOW_OK if @src is PLAYING and processing can
 * continue. Any other return value should be returned from the create vmethod.
 */
GstFlowReturn
gst_base_src_wait_playing (GstBaseSrc * src)
{
  g_return_val_if_fail (GST_IS_BASE_SRC (src), GST_FLOW_ERROR);

  do {
    /* block until the state changes, or we get a flush, or something */
    GST_DEBUG_OBJECT (src, "live source waiting for running state");
    GST_LIVE_WAIT (src);
    GST_DEBUG_OBJECT (src, "live source unlocked");
    if (src->priv->flushing)
      goto flushing;
  } while (G_UNLIKELY (!src->live_running));

  return GST_FLOW_OK;

  /* ERRORS */
flushing:
  {
    GST_DEBUG_OBJECT (src, "we are flushing");
    return GST_FLOW_FLUSHING;
  }
}

/**
 * gst_base_src_set_live:
 * @src: base source instance
 * @live: new live-mode
 *
 * If the element listens to a live source, @live should
 * be set to %TRUE.
 *
 * A live source will not produce data in the PAUSED state and
 * will therefore not be able to participate in the PREROLL phase
 * of a pipeline. To signal this fact to the application and the
 * pipeline, the state change return value of the live source will
 * be GST_STATE_CHANGE_NO_PREROLL.
 */
void
gst_base_src_set_live (GstBaseSrc * src, gboolean live)
{
  g_return_if_fail (GST_IS_BASE_SRC (src));

  GST_OBJECT_LOCK (src);
  src->is_live = live;
  GST_OBJECT_UNLOCK (src);
}

/**
 * gst_base_src_is_live:
 * @src: base source instance
 *
 * Check if an element is in live mode.
 *
 * Returns: %TRUE if element is in live mode.
 */
gboolean
gst_base_src_is_live (GstBaseSrc * src)
{
  gboolean result;

  g_return_val_if_fail (GST_IS_BASE_SRC (src), FALSE);

  GST_OBJECT_LOCK (src);
  result = src->is_live;
  GST_OBJECT_UNLOCK (src);

  return result;
}

/**
 * gst_base_src_set_format:
 * @src: base source instance
 * @format: the format to use
 *
 * Sets the default format of the source. This will be the format used
 * for sending SEGMENT events and for performing seeks.
 *
 * If a format of GST_FORMAT_BYTES is set, the element will be able to
 * operate in pull mode if the #GstBaseSrcClass.is_seekable() returns %TRUE.
 *
 * This function must only be called in states < %GST_STATE_PAUSED.
 */
void
gst_base_src_set_format (GstBaseSrc * src, GstFormat format)
{
  g_return_if_fail (GST_IS_BASE_SRC (src));
  g_return_if_fail (GST_STATE (src) <= GST_STATE_READY);

  GST_OBJECT_LOCK (src);
  gst_segment_init (&src->segment, format);
  GST_OBJECT_UNLOCK (src);
}

/**
 * gst_base_src_set_dynamic_size:
 * @src: base source instance
 * @dynamic: new dynamic size mode
 *
 * If not @dynamic, size is only updated when needed, such as when trying to
 * read past current tracked size.  Otherwise, size is checked for upon each
 * read.
 */
void
gst_base_src_set_dynamic_size (GstBaseSrc * src, gboolean dynamic)
{
  g_return_if_fail (GST_IS_BASE_SRC (src));

  g_atomic_int_set (&src->priv->dynamic_size, dynamic);
}

/**
 * gst_base_src_set_automatic_eos:
 * @src: base source instance
 * @automatic_eos: automatic eos
 *
 * If @automatic_eos is %TRUE, @src will automatically go EOS if a buffer
 * after the total size is returned. By default this is %TRUE but sources
 * that can't return an authoritative size and only know that they're EOS
 * when trying to read more should set this to %FALSE.
 *
 * Since: 1.4
 */
void
gst_base_src_set_automatic_eos (GstBaseSrc * src, gboolean automatic_eos)
{
  g_return_if_fail (GST_IS_BASE_SRC (src));

  g_atomic_int_set (&src->priv->automatic_eos, automatic_eos);
}

/**
 * gst_base_src_set_async:
 * @src: base source instance
 * @async: new async mode
 *
 * Configure async behaviour in @src, no state change will block. The open,
 * close, start, stop, play and pause virtual methods will be executed in a
 * different thread and are thus allowed to perform blocking operations. Any
 * blocking operation should be unblocked with the unlock vmethod.
 */
void
gst_base_src_set_async (GstBaseSrc * src, gboolean async)
{
  g_return_if_fail (GST_IS_BASE_SRC (src));

  GST_OBJECT_LOCK (src);
  src->priv->async = async;
  GST_OBJECT_UNLOCK (src);
}

/**
 * gst_base_src_is_async:
 * @src: base source instance
 *
 * Get the current async behaviour of @src. See also gst_base_src_set_async().
 *
 * Returns: %TRUE if @src is operating in async mode.
 */
gboolean
gst_base_src_is_async (GstBaseSrc * src)
{
  gboolean res;

  g_return_val_if_fail (GST_IS_BASE_SRC (src), FALSE);

  GST_OBJECT_LOCK (src);
  res = src->priv->async;
  GST_OBJECT_UNLOCK (src);

  return res;
}


/**
 * gst_base_src_query_latency:
 * @src: the source
 * @live: (out) (allow-none): if the source is live
 * @min_latency: (out) (allow-none): the min latency of the source
 * @max_latency: (out) (allow-none): the max latency of the source
 *
 * Query the source for the latency parameters. @live will be %TRUE when @src is
 * configured as a live source. @min_latency will be set to the difference
 * between the running time and the timestamp of the first buffer.
 * @max_latency is always the undefined value of -1.
 *
 * This function is mostly used by subclasses.
 *
 * Returns: %TRUE if the query succeeded.
 */
gboolean
gst_base_src_query_latency (GstBaseSrc * src, gboolean * live,
    GstClockTime * min_latency, GstClockTime * max_latency)
{
  GstClockTime min;

  g_return_val_if_fail (GST_IS_BASE_SRC (src), FALSE);

  GST_OBJECT_LOCK (src);
  if (live)
    *live = src->is_live;

  /* if we have a startup latency, report this one, else report 0. Subclasses
   * are supposed to override the query function if they want something
   * else. */
  if (src->priv->latency != -1)
    min = src->priv->latency;
  else
    min = 0;

  if (min_latency)
    *min_latency = min;
  if (max_latency)
    *max_latency = -1;

  GST_LOG_OBJECT (src, "latency: live %d, min %" GST_TIME_FORMAT
      ", max %" GST_TIME_FORMAT, src->is_live, GST_TIME_ARGS (min),
      GST_TIME_ARGS (-1));
  GST_OBJECT_UNLOCK (src);

  return TRUE;
}

/**
 * gst_base_src_set_blocksize:
 * @src: the source
 * @blocksize: the new blocksize in bytes
 *
 * Set the number of bytes that @src will push out with each buffer. When
 * @blocksize is set to -1, a default length will be used.
 */
void
gst_base_src_set_blocksize (GstBaseSrc * src, guint blocksize)
{
  g_return_if_fail (GST_IS_BASE_SRC (src));

  GST_OBJECT_LOCK (src);
  src->blocksize = blocksize;
  GST_OBJECT_UNLOCK (src);
}

/**
 * gst_base_src_get_blocksize:
 * @src: the source
 *
 * Get the number of bytes that @src will push out with each buffer.
 *
 * Returns: the number of bytes pushed with each buffer.
 */
guint
gst_base_src_get_blocksize (GstBaseSrc * src)
{
  gint res;

  g_return_val_if_fail (GST_IS_BASE_SRC (src), 0);

  GST_OBJECT_LOCK (src);
  res = src->blocksize;
  GST_OBJECT_UNLOCK (src);

  return res;
}


/**
 * gst_base_src_set_do_timestamp:
 * @src: the source
 * @timestamp: enable or disable timestamping
 *
 * Configure @src to automatically timestamp outgoing buffers based on the
 * current running_time of the pipeline. This property is mostly useful for live
 * sources.
 */
void
gst_base_src_set_do_timestamp (GstBaseSrc * src, gboolean timestamp)
{
  g_return_if_fail (GST_IS_BASE_SRC (src));

  GST_OBJECT_LOCK (src);
  src->priv->do_timestamp = timestamp;
  if (timestamp && src->segment.format != GST_FORMAT_TIME)
    gst_segment_init (&src->segment, GST_FORMAT_TIME);
  GST_OBJECT_UNLOCK (src);
}

/**
 * gst_base_src_get_do_timestamp:
 * @src: the source
 *
 * Query if @src timestamps outgoing buffers based on the current running_time.
 *
 * Returns: %TRUE if the base class will automatically timestamp outgoing buffers.
 */
gboolean
gst_base_src_get_do_timestamp (GstBaseSrc * src)
{
  gboolean res;

  g_return_val_if_fail (GST_IS_BASE_SRC (src), FALSE);

  GST_OBJECT_LOCK (src);
  res = src->priv->do_timestamp;
  GST_OBJECT_UNLOCK (src);

  return res;
}

/**
 * gst_base_src_new_seamless_segment:
 * @src: The source
 * @start: The new start value for the segment
 * @stop: Stop value for the new segment
 * @time: The new time value for the start of the new segment
 *
 * Prepare a new seamless segment for emission downstream. This function must
 * only be called by derived sub-classes, and only from the create() function,
 * as the stream-lock needs to be held.
 *
 * The format for the new segment will be the current format of the source, as
 * configured with gst_base_src_set_format()
 *
 * Returns: %TRUE if preparation of the seamless segment succeeded.
 */
gboolean
gst_base_src_new_seamless_segment (GstBaseSrc * src, gint64 start, gint64 stop,
    gint64 time)
{
  gboolean res = TRUE;

  GST_OBJECT_LOCK (src);

  src->segment.base = gst_segment_to_running_time (&src->segment,
      src->segment.format, src->segment.position);
  src->segment.position = src->segment.start = start;
  src->segment.stop = stop;
  src->segment.time = time;

  /* Mark pending segment. Will be sent before next data */
  src->priv->segment_pending = TRUE;
  src->priv->segment_seqnum = gst_util_seqnum_next ();

  GST_DEBUG_OBJECT (src,
      "Starting new seamless segment. Start %" GST_TIME_FORMAT " stop %"
      GST_TIME_FORMAT " time %" GST_TIME_FORMAT " base %" GST_TIME_FORMAT,
      GST_TIME_ARGS (start), GST_TIME_ARGS (stop), GST_TIME_ARGS (time),
      GST_TIME_ARGS (src->segment.base));

  GST_OBJECT_UNLOCK (src);

  src->priv->discont = TRUE;
  src->running = TRUE;

  return res;
}

static gboolean
gst_base_src_send_stream_start (GstBaseSrc * src)
{
  gboolean ret = TRUE;

  if (src->priv->stream_start_pending) {
    gchar *stream_id;
    GstEvent *event;

    stream_id =
        gst_pad_create_stream_id (src->srcpad, GST_ELEMENT_CAST (src), NULL);

    GST_DEBUG_OBJECT (src, "Pushing STREAM_START");
    event = gst_event_new_stream_start (stream_id);
    gst_event_set_group_id (event, gst_util_group_id_next ());

    ret = gst_pad_push_event (src->srcpad, event);
    src->priv->stream_start_pending = FALSE;
    g_free (stream_id);
  }

  return ret;
}

/**
 * gst_base_src_set_caps:
 * @src: a #GstBaseSrc
 * @caps: a #GstCaps
 *
 * Set new caps on the basesrc source pad.
 *
 * Returns: %TRUE if the caps could be set
 */
gboolean
gst_base_src_set_caps (GstBaseSrc * src, GstCaps * caps)
{
  GstBaseSrcClass *bclass;
  gboolean res = TRUE;

  bclass = GST_BASE_SRC_GET_CLASS (src);

  gst_base_src_send_stream_start (src);

  if (bclass->set_caps)
    res = bclass->set_caps (src, caps);

  if (res)
    res = gst_pad_push_event (src->srcpad, gst_event_new_caps (caps));

  return res;
}

static GstCaps *
gst_base_src_default_get_caps (GstBaseSrc * bsrc, GstCaps * filter)
{
  GstCaps *caps = NULL;
  GstPadTemplate *pad_template;
  GstBaseSrcClass *bclass;

  bclass = GST_BASE_SRC_GET_CLASS (bsrc);

  pad_template =
      gst_element_class_get_pad_template (GST_ELEMENT_CLASS (bclass), "src");

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
  return caps;
}

static GstCaps *
gst_base_src_default_fixate (GstBaseSrc * bsrc, GstCaps * caps)
{
  GST_DEBUG_OBJECT (bsrc, "using default caps fixate function");
  return gst_caps_fixate (caps);
}

static GstCaps *
gst_base_src_fixate (GstBaseSrc * bsrc, GstCaps * caps)
{
  GstBaseSrcClass *bclass;

  bclass = GST_BASE_SRC_GET_CLASS (bsrc);

  if (bclass->fixate)
    caps = bclass->fixate (bsrc, caps);

  return caps;
}

static gboolean
gst_base_src_default_query (GstBaseSrc * src, GstQuery * query)
{
  gboolean res;

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_POSITION:
    {
      GstFormat format;

      gst_query_parse_position (query, &format, NULL);

      GST_DEBUG_OBJECT (src, "position query in format %s",
          gst_format_get_name (format));

      switch (format) {
        case GST_FORMAT_PERCENT:
        {
          gint64 percent;
          gint64 position;
          gint64 duration;

          GST_OBJECT_LOCK (src);
          position = src->segment.position;
          duration = src->segment.duration;
          GST_OBJECT_UNLOCK (src);

          if (position != -1 && duration != -1) {
            if (position < duration)
              percent = gst_util_uint64_scale (GST_FORMAT_PERCENT_MAX, position,
                  duration);
            else
              percent = GST_FORMAT_PERCENT_MAX;
          } else
            percent = -1;

          gst_query_set_position (query, GST_FORMAT_PERCENT, percent);
          res = TRUE;
          break;
        }
        default:
        {
          gint64 position;
          GstFormat seg_format;

          GST_OBJECT_LOCK (src);
          position =
              gst_segment_to_stream_time (&src->segment, src->segment.format,
              src->segment.position);
          seg_format = src->segment.format;
          GST_OBJECT_UNLOCK (src);

          if (position != -1) {
            /* convert to requested format */
            res =
                gst_pad_query_convert (src->srcpad, seg_format,
                position, format, &position);
          } else
            res = TRUE;

          gst_query_set_position (query, format, position);
          break;
        }
      }
      break;
    }
    case GST_QUERY_DURATION:
    {
      GstFormat format;

      gst_query_parse_duration (query, &format, NULL);

      GST_DEBUG_OBJECT (src, "duration query in format %s",
          gst_format_get_name (format));

      switch (format) {
        case GST_FORMAT_PERCENT:
          gst_query_set_duration (query, GST_FORMAT_PERCENT,
              GST_FORMAT_PERCENT_MAX);
          res = TRUE;
          break;
        default:
        {
          gint64 duration;
          GstFormat seg_format;
          guint length = 0;

          /* may have to refresh duration */
          gst_base_src_update_length (src, 0, &length,
              g_atomic_int_get (&src->priv->dynamic_size));

          /* this is the duration as configured by the subclass. */
          GST_OBJECT_LOCK (src);
          duration = src->segment.duration;
          seg_format = src->segment.format;
          GST_OBJECT_UNLOCK (src);

          GST_LOG_OBJECT (src, "duration %" G_GINT64_FORMAT ", format %s",
              duration, gst_format_get_name (seg_format));

          if (duration != -1) {
            /* convert to requested format, if this fails, we have a duration
             * but we cannot answer the query, we must return FALSE. */
            res =
                gst_pad_query_convert (src->srcpad, seg_format,
                duration, format, &duration);
          } else {
            /* The subclass did not configure a duration, we assume that the
             * media has an unknown duration then and we return TRUE to report
             * this. Note that this is not the same as returning FALSE, which
             * means that we cannot report the duration at all. */
            res = TRUE;
          }
          gst_query_set_duration (query, format, duration);
          break;
        }
      }
      break;
    }

    case GST_QUERY_SEEKING:
    {
      GstFormat format, seg_format;
      gint64 duration;

      GST_OBJECT_LOCK (src);
      duration = src->segment.duration;
      seg_format = src->segment.format;
      GST_OBJECT_UNLOCK (src);

      gst_query_parse_seeking (query, &format, NULL, NULL, NULL);
      if (format == seg_format) {
        gst_query_set_seeking (query, seg_format,
            gst_base_src_seekable (src), 0, duration);
        res = TRUE;
      } else {
        /* FIXME 0.11: return TRUE + seekable=FALSE for SEEKING query here */
        /* Don't reply to the query to make up for demuxers which don't
         * handle the SEEKING query yet. Players like Totem will fall back
         * to the duration when the SEEKING query isn't answered. */
        res = FALSE;
      }
      break;
    }
    case GST_QUERY_SEGMENT:
    {
      GstFormat format;
      gint64 start, stop;

      GST_OBJECT_LOCK (src);

      format = src->segment.format;

      start =
          gst_segment_to_stream_time (&src->segment, format,
          src->segment.start);
      if ((stop = src->segment.stop) == -1)
        stop = src->segment.duration;
      else
        stop = gst_segment_to_stream_time (&src->segment, format, stop);

      gst_query_set_segment (query, src->segment.rate, format, start, stop);

      GST_OBJECT_UNLOCK (src);
      res = TRUE;
      break;
    }

    case GST_QUERY_FORMATS:
    {
      gst_query_set_formats (query, 3, GST_FORMAT_DEFAULT,
          GST_FORMAT_BYTES, GST_FORMAT_PERCENT);
      res = TRUE;
      break;
    }
    case GST_QUERY_CONVERT:
    {
      GstFormat src_fmt, dest_fmt;
      gint64 src_val, dest_val;

      gst_query_parse_convert (query, &src_fmt, &src_val, &dest_fmt, &dest_val);

      /* we can only convert between equal formats... */
      if (src_fmt == dest_fmt) {
        dest_val = src_val;
        res = TRUE;
      } else
        res = FALSE;

      gst_query_set_convert (query, src_fmt, src_val, dest_fmt, dest_val);
      break;
    }
    case GST_QUERY_LATENCY:
    {
      GstClockTime min, max;
      gboolean live;

      /* Subclasses should override and implement something useful */
      res = gst_base_src_query_latency (src, &live, &min, &max);

      GST_LOG_OBJECT (src, "report latency: live %d, min %" GST_TIME_FORMAT
          ", max %" GST_TIME_FORMAT, live, GST_TIME_ARGS (min),
          GST_TIME_ARGS (max));

      gst_query_set_latency (query, live, min, max);
      break;
    }
    case GST_QUERY_JITTER:
    case GST_QUERY_RATE:
      res = FALSE;
      break;
    case GST_QUERY_BUFFERING:
    {
      GstFormat format, seg_format;
      gint64 start, stop, estimated;

      gst_query_parse_buffering_range (query, &format, NULL, NULL, NULL);

      GST_DEBUG_OBJECT (src, "buffering query in format %s",
          gst_format_get_name (format));

      GST_OBJECT_LOCK (src);
      if (src->random_access) {
        estimated = 0;
        start = 0;
        if (format == GST_FORMAT_PERCENT)
          stop = GST_FORMAT_PERCENT_MAX;
        else
          stop = src->segment.duration;
      } else {
        estimated = -1;
        start = -1;
        stop = -1;
      }
      seg_format = src->segment.format;
      GST_OBJECT_UNLOCK (src);

      /* convert to required format. When the conversion fails, we can't answer
       * the query. When the value is unknown, we can don't perform conversion
       * but report TRUE. */
      if (format != GST_FORMAT_PERCENT && stop != -1) {
        res = gst_pad_query_convert (src->srcpad, seg_format,
            stop, format, &stop);
      } else {
        res = TRUE;
      }
      if (res && format != GST_FORMAT_PERCENT && start != -1)
        res = gst_pad_query_convert (src->srcpad, seg_format,
            start, format, &start);

      gst_query_set_buffering_range (query, format, start, stop, estimated);
      break;
    }
    case GST_QUERY_SCHEDULING:
    {
      gboolean random_access;

      random_access = gst_base_src_is_random_access (src);

      /* we can operate in getrange mode if the native format is bytes
       * and we are seekable, this condition is set in the random_access
       * flag and is set in the _start() method. */
      gst_query_set_scheduling (query, GST_SCHEDULING_FLAG_SEEKABLE, 1, -1, 0);
      if (random_access)
        gst_query_add_scheduling_mode (query, GST_PAD_MODE_PULL);
      gst_query_add_scheduling_mode (query, GST_PAD_MODE_PUSH);

      res = TRUE;
      break;
    }
    case GST_QUERY_CAPS:
    {
      GstBaseSrcClass *bclass;
      GstCaps *caps, *filter;

      bclass = GST_BASE_SRC_GET_CLASS (src);
      if (bclass->get_caps) {
        gst_query_parse_caps (query, &filter);
        if ((caps = bclass->get_caps (src, filter))) {
          gst_query_set_caps_result (query, caps);
          gst_caps_unref (caps);
          res = TRUE;
        } else {
          res = FALSE;
        }
      } else
        res = FALSE;
      break;
    }
    case GST_QUERY_URI:{
      if (GST_IS_URI_HANDLER (src)) {
        gchar *uri = gst_uri_handler_get_uri (GST_URI_HANDLER (src));

        if (uri != NULL) {
          gst_query_set_uri (query, uri);
          g_free (uri);
          res = TRUE;
        } else {
          res = FALSE;
        }
      } else {
        res = FALSE;
      }
      break;
    }
    default:
      res = FALSE;
      break;
  }
  GST_DEBUG_OBJECT (src, "query %s returns %d", GST_QUERY_TYPE_NAME (query),
      res);

  return res;
}

static gboolean
gst_base_src_query (GstPad * pad, GstObject * parent, GstQuery * query)
{
  GstBaseSrc *src;
  GstBaseSrcClass *bclass;
  gboolean result = FALSE;

  src = GST_BASE_SRC (parent);
  bclass = GST_BASE_SRC_GET_CLASS (src);

  if (bclass->query)
    result = bclass->query (src, query);

  return result;
}

static gboolean
gst_base_src_default_do_seek (GstBaseSrc * src, GstSegment * segment)
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
    GST_INFO_OBJECT (src, "Can't do a default seek");
  }

  return res;
}

static gboolean
gst_base_src_do_seek (GstBaseSrc * src, GstSegment * segment)
{
  GstBaseSrcClass *bclass;
  gboolean result = FALSE;

  bclass = GST_BASE_SRC_GET_CLASS (src);

  GST_INFO_OBJECT (src, "seeking: %" GST_SEGMENT_FORMAT, segment);

  if (bclass->do_seek)
    result = bclass->do_seek (src, segment);

  return result;
}

#define SEEK_TYPE_IS_RELATIVE(t) (((t) != GST_SEEK_TYPE_NONE) && ((t) != GST_SEEK_TYPE_SET))

static gboolean
gst_base_src_default_prepare_seek_segment (GstBaseSrc * src, GstEvent * event,
    GstSegment * segment)
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
  GstFormat seek_format, dest_format;
  gdouble rate;
  gboolean update;
  gboolean res = TRUE;

  gst_event_parse_seek (event, &rate, &seek_format, &flags,
      &start_type, &start, &stop_type, &stop);
  dest_format = segment->format;

  if (seek_format == dest_format) {
    gst_segment_do_seek (segment, rate, seek_format, flags,
        start_type, start, stop_type, stop, &update);
    return TRUE;
  }

  if (start_type != GST_SEEK_TYPE_NONE) {
    /* FIXME: Handle seek_end by converting the input segment vals */
    res =
        gst_pad_query_convert (src->srcpad, seek_format, start, dest_format,
        &start);
    start_type = GST_SEEK_TYPE_SET;
  }

  if (res && stop_type != GST_SEEK_TYPE_NONE) {
    /* FIXME: Handle seek_end by converting the input segment vals */
    res =
        gst_pad_query_convert (src->srcpad, seek_format, stop, dest_format,
        &stop);
    stop_type = GST_SEEK_TYPE_SET;
  }

  /* And finally, configure our output segment in the desired format */
  gst_segment_do_seek (segment, rate, dest_format, flags, start_type, start,
      stop_type, stop, &update);

  if (!res)
    goto no_format;

  return res;

no_format:
  {
    GST_DEBUG_OBJECT (src, "undefined format given, seek aborted.");
    return FALSE;
  }
}

static gboolean
gst_base_src_prepare_seek_segment (GstBaseSrc * src, GstEvent * event,
    GstSegment * seeksegment)
{
  GstBaseSrcClass *bclass;
  gboolean result = FALSE;

  bclass = GST_BASE_SRC_GET_CLASS (src);

  if (bclass->prepare_seek_segment)
    result = bclass->prepare_seek_segment (src, event, seeksegment);

  return result;
}

static GstFlowReturn
gst_base_src_default_alloc (GstBaseSrc * src, guint64 offset,
    guint size, GstBuffer ** buffer)
{
  GstFlowReturn ret;
  GstBaseSrcPrivate *priv = src->priv;

  if (priv->pool) {
    ret = gst_buffer_pool_acquire_buffer (priv->pool, buffer, NULL);
  } else if (size != -1) {
    *buffer = gst_buffer_new_allocate (priv->allocator, size, &priv->params);
    if (G_UNLIKELY (*buffer == NULL))
      goto alloc_failed;

    ret = GST_FLOW_OK;
  } else {
    GST_WARNING_OBJECT (src, "Not trying to alloc %u bytes. Blocksize not set?",
        size);
    goto alloc_failed;
  }
  return ret;

  /* ERRORS */
alloc_failed:
  {
    GST_ERROR_OBJECT (src, "Failed to allocate %u bytes", size);
    return GST_FLOW_ERROR;
  }
}

static GstFlowReturn
gst_base_src_default_create (GstBaseSrc * src, guint64 offset,
    guint size, GstBuffer ** buffer)
{
  GstBaseSrcClass *bclass;
  GstFlowReturn ret;
  GstBuffer *res_buf;

  bclass = GST_BASE_SRC_GET_CLASS (src);

  if (G_UNLIKELY (!bclass->alloc))
    goto no_function;
  if (G_UNLIKELY (!bclass->fill))
    goto no_function;

  if (*buffer == NULL) {
    /* downstream did not provide us with a buffer to fill, allocate one
     * ourselves */
    ret = bclass->alloc (src, offset, size, &res_buf);
    if (G_UNLIKELY (ret != GST_FLOW_OK))
      goto alloc_failed;
  } else {
    res_buf = *buffer;
  }

  if (G_LIKELY (size > 0)) {
    /* only call fill when there is a size */
    ret = bclass->fill (src, offset, size, res_buf);
    if (G_UNLIKELY (ret != GST_FLOW_OK))
      goto not_ok;
  }

  *buffer = res_buf;

  return GST_FLOW_OK;

  /* ERRORS */
no_function:
  {
    GST_DEBUG_OBJECT (src, "no fill or alloc function");
    return GST_FLOW_NOT_SUPPORTED;
  }
alloc_failed:
  {
    GST_DEBUG_OBJECT (src, "Failed to allocate buffer of %u bytes", size);
    return ret;
  }
not_ok:
  {
    GST_DEBUG_OBJECT (src, "fill returned %d (%s)", ret,
        gst_flow_get_name (ret));
    if (*buffer == NULL)
      gst_buffer_unref (res_buf);
    return ret;
  }
}

/* this code implements the seeking. It is a good example
 * handling all cases.
 *
 * A seek updates the currently configured segment.start
 * and segment.stop values based on the SEEK_TYPE. If the
 * segment.start value is updated, a seek to this new position
 * should be performed.
 *
 * The seek can only be executed when we are not currently
 * streaming any data, to make sure that this is the case, we
 * acquire the STREAM_LOCK which is taken when we are in the
 * _loop() function or when a getrange() is called. Normally
 * we will not receive a seek if we are operating in pull mode
 * though. When we operate as a live source we might block on the live
 * cond, which does not release the STREAM_LOCK. Therefore we will try
 * to grab the LIVE_LOCK instead of the STREAM_LOCK to make sure it is
 * safe to perform the seek.
 *
 * When we are in the loop() function, we might be in the middle
 * of pushing a buffer, which might block in a sink. To make sure
 * that the push gets unblocked we push out a FLUSH_START event.
 * Our loop function will get a FLUSHING return value from
 * the push and will pause, effectively releasing the STREAM_LOCK.
 *
 * For a non-flushing seek, we pause the task, which might eventually
 * release the STREAM_LOCK. We say eventually because when the sink
 * blocks on the sample we might wait a very long time until the sink
 * unblocks the sample. In any case we acquire the STREAM_LOCK and
 * can continue the seek. A non-flushing seek is normally done in a
 * running pipeline to perform seamless playback, this means that the sink is
 * PLAYING and will return from its chain function.
 * In the case of a non-flushing seek we need to make sure that the
 * data we output after the seek is continuous with the previous data,
 * this is because a non-flushing seek does not reset the running-time
 * to 0. We do this by closing the currently running segment, ie. sending
 * a new_segment event with the stop position set to the last processed
 * position.
 *
 * After updating the segment.start/stop values, we prepare for
 * streaming again. We push out a FLUSH_STOP to make the peer pad
 * accept data again and we start our task again.
 *
 * A segment seek posts a message on the bus saying that the playback
 * of the segment started. We store the segment flag internally because
 * when we reach the segment.stop we have to post a segment.done
 * instead of EOS when doing a segment seek.
 */
static gboolean
gst_base_src_perform_seek (GstBaseSrc * src, GstEvent * event, gboolean unlock)
{
  gboolean res = TRUE, tres;
  gdouble rate;
  GstFormat seek_format, dest_format;
  GstSeekFlags flags;
  GstSeekType start_type, stop_type;
  gint64 start, stop;
  gboolean flush, playing;
  gboolean update;
  gboolean relative_seek = FALSE;
  gboolean seekseg_configured = FALSE;
  GstSegment seeksegment;
  guint32 seqnum;
  GstEvent *tevent;

  GST_DEBUG_OBJECT (src, "doing seek: %" GST_PTR_FORMAT, event);

  GST_OBJECT_LOCK (src);
  dest_format = src->segment.format;
  GST_OBJECT_UNLOCK (src);

  if (event) {
    gst_event_parse_seek (event, &rate, &seek_format, &flags,
        &start_type, &start, &stop_type, &stop);

    relative_seek = SEEK_TYPE_IS_RELATIVE (start_type) ||
        SEEK_TYPE_IS_RELATIVE (stop_type);

    if (dest_format != seek_format && !relative_seek) {
      /* If we have an ABSOLUTE position (SEEK_SET only), we can convert it
       * here before taking the stream lock, otherwise we must convert it later,
       * once we have the stream lock and can read the last configures segment
       * start and stop positions */
      gst_segment_init (&seeksegment, dest_format);

      if (!gst_base_src_prepare_seek_segment (src, event, &seeksegment))
        goto prepare_failed;

      seekseg_configured = TRUE;
    }

    flush = flags & GST_SEEK_FLAG_FLUSH;
    seqnum = gst_event_get_seqnum (event);
  } else {
    flush = FALSE;
    /* get next seqnum */
    seqnum = gst_util_seqnum_next ();
  }

  /* send flush start */
  if (flush) {
    tevent = gst_event_new_flush_start ();
    gst_event_set_seqnum (tevent, seqnum);
    gst_pad_push_event (src->srcpad, tevent);
  } else
    gst_pad_pause_task (src->srcpad);

  /* unblock streaming thread. */
  if (unlock)
    gst_base_src_set_flushing (src, TRUE, FALSE, &playing);

  /* grab streaming lock, this should eventually be possible, either
   * because the task is paused, our streaming thread stopped
   * or because our peer is flushing. */
  GST_PAD_STREAM_LOCK (src->srcpad);
  if (G_UNLIKELY (src->priv->seqnum == seqnum)) {
    /* we have seen this event before, issue a warning for now */
    GST_WARNING_OBJECT (src, "duplicate event found %" G_GUINT32_FORMAT,
        seqnum);
  } else {
    src->priv->seqnum = seqnum;
    GST_DEBUG_OBJECT (src, "seek with seqnum %" G_GUINT32_FORMAT, seqnum);
  }

  if (unlock)
    gst_base_src_set_flushing (src, FALSE, playing, NULL);

  /* If we configured the seeksegment above, don't overwrite it now. Otherwise
   * copy the current segment info into the temp segment that we can actually
   * attempt the seek with. We only update the real segment if the seek succeeds. */
  if (!seekseg_configured) {
    memcpy (&seeksegment, &src->segment, sizeof (GstSegment));

    /* now configure the final seek segment */
    if (event) {
      if (seeksegment.format != seek_format) {
        /* OK, here's where we give the subclass a chance to convert the relative
         * seek into an absolute one in the processing format. We set up any
         * absolute seek above, before taking the stream lock. */
        if (!gst_base_src_prepare_seek_segment (src, event, &seeksegment)) {
          GST_DEBUG_OBJECT (src, "Preparing the seek failed after flushing. "
              "Aborting seek");
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
    GST_DEBUG_OBJECT (src, "segment configured from %" G_GINT64_FORMAT
        " to %" G_GINT64_FORMAT ", position %" G_GINT64_FORMAT,
        seeksegment.start, seeksegment.stop, seeksegment.position);

    /* do the seek, segment.position contains the new position. */
    res = gst_base_src_do_seek (src, &seeksegment);
  }

  /* and prepare to continue streaming */
  if (flush) {
    tevent = gst_event_new_flush_stop (TRUE);
    gst_event_set_seqnum (tevent, seqnum);
    /* send flush stop, peer will accept data and events again. We
     * are not yet providing data as we still have the STREAM_LOCK. */
    gst_pad_push_event (src->srcpad, tevent);
  }

  /* The subclass must have converted the segment to the processing format
   * by now */
  if (res && seeksegment.format != dest_format) {
    GST_DEBUG_OBJECT (src, "Subclass failed to prepare a seek segment "
        "in the correct format. Aborting seek.");
    res = FALSE;
  }

  /* if the seek was successful, we update our real segment and push
   * out the new segment. */
  if (res) {
    GST_OBJECT_LOCK (src);
    memcpy (&src->segment, &seeksegment, sizeof (GstSegment));
    GST_OBJECT_UNLOCK (src);

    if (seeksegment.flags & GST_SEGMENT_FLAG_SEGMENT) {
      GstMessage *message;

      message = gst_message_new_segment_start (GST_OBJECT (src),
          seeksegment.format, seeksegment.position);
      gst_message_set_seqnum (message, seqnum);

      gst_element_post_message (GST_ELEMENT (src), message);
    }

    /* for deriving a stop position for the playback segment from the seek
     * segment, we must take the duration when the stop is not set */
    /* FIXME: This is never used below */
    if ((stop = seeksegment.stop) == -1)
      stop = seeksegment.duration;

    src->priv->segment_pending = TRUE;
    src->priv->segment_seqnum = seqnum;
  }

  src->priv->discont = TRUE;
  src->running = TRUE;
  /* and restart the task in case it got paused explicitly or by
   * the FLUSH_START event we pushed out. */
  tres = gst_pad_start_task (src->srcpad, (GstTaskFunction) gst_base_src_loop,
      src->srcpad, NULL);
  if (res && !tres)
    res = FALSE;

  /* and release the lock again so we can continue streaming */
  GST_PAD_STREAM_UNLOCK (src->srcpad);

  return res;

  /* ERROR */
prepare_failed:
  GST_DEBUG_OBJECT (src, "Preparing the seek failed before flushing. "
      "Aborting seek");
  return FALSE;
}

/* all events send to this element directly. This is mainly done from the
 * application.
 */
static gboolean
gst_base_src_send_event (GstElement * element, GstEvent * event)
{
  GstBaseSrc *src;
  gboolean result = FALSE;
  GstBaseSrcClass *bclass;

  src = GST_BASE_SRC (element);
  bclass = GST_BASE_SRC_GET_CLASS (src);

  GST_DEBUG_OBJECT (src, "handling event %p %" GST_PTR_FORMAT, event, event);

  switch (GST_EVENT_TYPE (event)) {
      /* bidirectional events */
    case GST_EVENT_FLUSH_START:
      GST_DEBUG_OBJECT (src, "pushing flush-start event downstream");
      result = gst_pad_push_event (src->srcpad, event);
      /* also unblock the create function */
      gst_base_src_activate_pool (src, FALSE);
      /* unlock any subclasses, we need to do this before grabbing the
       * LIVE_LOCK since we hold this lock before going into ::create. We pass an
       * unlock to the params because of backwards compat (see seek handler)*/
      if (bclass->unlock)
        bclass->unlock (src);

      /* the live lock is released when we are blocked, waiting for playing or
       * when we sync to the clock. */
      GST_LIVE_LOCK (src);
      src->priv->flushing = TRUE;
      /* clear pending EOS if any */
      if (g_atomic_int_get (&src->priv->has_pending_eos)) {
        GST_OBJECT_LOCK (src);
        CLEAR_PENDING_EOS (src);
        src->priv->forced_eos = FALSE;
        GST_OBJECT_UNLOCK (src);
      }
      if (bclass->unlock_stop)
        bclass->unlock_stop (src);
      if (src->clock_id)
        gst_clock_id_unschedule (src->clock_id);
      GST_DEBUG_OBJECT (src, "signal");
      GST_LIVE_SIGNAL (src);
      GST_LIVE_UNLOCK (src);
      event = NULL;
      break;
    case GST_EVENT_FLUSH_STOP:
    {
      gboolean start;

      GST_LIVE_LOCK (src);
      src->priv->segment_pending = TRUE;
      src->priv->flushing = FALSE;
      GST_DEBUG_OBJECT (src, "pushing flush-stop event downstream");
      result = gst_pad_push_event (src->srcpad, event);

      gst_base_src_activate_pool (src, TRUE);

      GST_OBJECT_LOCK (src->srcpad);
      start = (GST_PAD_MODE (src->srcpad) == GST_PAD_MODE_PUSH);
      GST_OBJECT_UNLOCK (src->srcpad);
      if (start)
        gst_pad_start_task (src->srcpad, (GstTaskFunction) gst_base_src_loop,
            src->srcpad, NULL);
      GST_LIVE_UNLOCK (src);
      event = NULL;
      break;
    }

      /* downstream serialized events */
    case GST_EVENT_EOS:
    {
      /* queue EOS and make sure the task or pull function performs the EOS
       * actions.
       *
       * We have two possibilities:
       *
       *  - Before we are to enter the _create function, we check the has_pending_eos
       *    first and do EOS instead of entering it.
       *  - If we are in the _create function or we did not manage to set the
       *    flag fast enough and we are about to enter the _create function,
       *    we unlock it so that we exit with FLUSHING immediately. We then
       *    check the EOS flag and do the EOS logic.
       */
      GST_OBJECT_LOCK (src);
      g_atomic_int_set (&src->priv->has_pending_eos, TRUE);
      if (src->priv->pending_eos)
        gst_event_unref (src->priv->pending_eos);
      src->priv->pending_eos = event;
      event = NULL;
      GST_OBJECT_UNLOCK (src);

      GST_DEBUG_OBJECT (src, "EOS marked, calling unlock");

      /* unlock the _create function so that we can check the has_pending_eos flag
       * and we can do EOS. This will eventually release the LIVE_LOCK again so
       * that we can grab it and stop the unlock again. We don't take the stream
       * lock so that this operation is guaranteed to never block. */
      gst_base_src_activate_pool (src, FALSE);
      if (bclass->unlock)
        bclass->unlock (src);

      GST_DEBUG_OBJECT (src, "unlock called, waiting for LIVE_LOCK");

      GST_LIVE_LOCK (src);
      GST_DEBUG_OBJECT (src, "LIVE_LOCK acquired, calling unlock_stop");
      /* now stop the unlock of the streaming thread again. Grabbing the live
       * lock is enough because that protects the create function. */
      if (bclass->unlock_stop)
        bclass->unlock_stop (src);
      gst_base_src_activate_pool (src, TRUE);
      GST_LIVE_UNLOCK (src);

      result = TRUE;
      break;
    }
    case GST_EVENT_SEGMENT:
      /* sending random SEGMENT downstream can break sync. */
      break;
    case GST_EVENT_TAG:
    case GST_EVENT_CUSTOM_DOWNSTREAM:
    case GST_EVENT_CUSTOM_BOTH:
      /* Insert TAG, CUSTOM_DOWNSTREAM, CUSTOM_BOTH in the dataflow */
      GST_OBJECT_LOCK (src);
      src->priv->pending_events =
          g_list_append (src->priv->pending_events, event);
      g_atomic_int_set (&src->priv->have_events, TRUE);
      GST_OBJECT_UNLOCK (src);
      event = NULL;
      result = TRUE;
      break;
    case GST_EVENT_BUFFERSIZE:
      /* does not seem to make much sense currently */
      break;

      /* upstream events */
    case GST_EVENT_QOS:
      /* elements should override send_event and do something */
      break;
    case GST_EVENT_SEEK:
    {
      gboolean started;

      GST_OBJECT_LOCK (src->srcpad);
      if (GST_PAD_MODE (src->srcpad) == GST_PAD_MODE_PULL)
        goto wrong_mode;
      started = GST_PAD_MODE (src->srcpad) == GST_PAD_MODE_PUSH;
      GST_OBJECT_UNLOCK (src->srcpad);

      if (started) {
        GST_DEBUG_OBJECT (src, "performing seek");
        /* when we are running in push mode, we can execute the
         * seek right now. */
        result = gst_base_src_perform_seek (src, event, TRUE);
      } else {
        GstEvent **event_p;

        /* else we store the event and execute the seek when we
         * get activated */
        GST_OBJECT_LOCK (src);
        GST_DEBUG_OBJECT (src, "queueing seek");
        event_p = &src->pending_seek;
        gst_event_replace ((GstEvent **) event_p, event);
        GST_OBJECT_UNLOCK (src);
        /* assume the seek will work */
        result = TRUE;
      }
      break;
    }
    case GST_EVENT_NAVIGATION:
      /* could make sense for elements that do something with navigation events
       * but then they would need to override the send_event function */
      break;
    case GST_EVENT_LATENCY:
      /* does not seem to make sense currently */
      break;

      /* custom events */
    case GST_EVENT_CUSTOM_UPSTREAM:
      /* override send_event if you want this */
      break;
    case GST_EVENT_CUSTOM_DOWNSTREAM_OOB:
    case GST_EVENT_CUSTOM_BOTH_OOB:
      /* insert a random custom event into the pipeline */
      GST_DEBUG_OBJECT (src, "pushing custom OOB event downstream");
      result = gst_pad_push_event (src->srcpad, event);
      /* we gave away the ref to the event in the push */
      event = NULL;
      break;
    default:
      break;
  }
done:
  /* if we still have a ref to the event, unref it now */
  if (event)
    gst_event_unref (event);

  return result;

  /* ERRORS */
wrong_mode:
  {
    GST_DEBUG_OBJECT (src, "cannot perform seek when operating in pull mode");
    GST_OBJECT_UNLOCK (src->srcpad);
    result = FALSE;
    goto done;
  }
}

static gboolean
gst_base_src_seekable (GstBaseSrc * src)
{
  GstBaseSrcClass *bclass;
  bclass = GST_BASE_SRC_GET_CLASS (src);
  if (bclass->is_seekable)
    return bclass->is_seekable (src);
  else
    return FALSE;
}

static void
gst_base_src_update_qos (GstBaseSrc * src,
    gdouble proportion, GstClockTimeDiff diff, GstClockTime timestamp)
{
  GST_CAT_DEBUG_OBJECT (GST_CAT_QOS, src,
      "qos: proportion: %lf, diff %" G_GINT64_FORMAT ", timestamp %"
      GST_TIME_FORMAT, proportion, diff, GST_TIME_ARGS (timestamp));

  GST_OBJECT_LOCK (src);
  src->priv->proportion = proportion;
  src->priv->earliest_time = timestamp + diff;
  GST_OBJECT_UNLOCK (src);
}


static gboolean
gst_base_src_default_event (GstBaseSrc * src, GstEvent * event)
{
  gboolean result;

  GST_DEBUG_OBJECT (src, "handle event %" GST_PTR_FORMAT, event);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_SEEK:
      /* is normally called when in push mode */
      if (!gst_base_src_seekable (src))
        goto not_seekable;

      result = gst_base_src_perform_seek (src, event, TRUE);
      break;
    case GST_EVENT_FLUSH_START:
      /* cancel any blocking getrange, is normally called
       * when in pull mode. */
      result = gst_base_src_set_flushing (src, TRUE, FALSE, NULL);
      break;
    case GST_EVENT_FLUSH_STOP:
      result = gst_base_src_set_flushing (src, FALSE, TRUE, NULL);
      break;
    case GST_EVENT_QOS:
    {
      gdouble proportion;
      GstClockTimeDiff diff;
      GstClockTime timestamp;

      gst_event_parse_qos (event, NULL, &proportion, &diff, &timestamp);
      gst_base_src_update_qos (src, proportion, diff, timestamp);
      result = TRUE;
      break;
    }
    case GST_EVENT_RECONFIGURE:
      result = TRUE;
      break;
    case GST_EVENT_LATENCY:
      result = TRUE;
      break;
    default:
      result = FALSE;
      break;
  }
  return result;

  /* ERRORS */
not_seekable:
  {
    GST_DEBUG_OBJECT (src, "is not seekable");
    return FALSE;
  }
}

static gboolean
gst_base_src_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  GstBaseSrc *src;
  GstBaseSrcClass *bclass;
  gboolean result = FALSE;

  src = GST_BASE_SRC (parent);
  bclass = GST_BASE_SRC_GET_CLASS (src);

  if (bclass->event) {
    if (!(result = bclass->event (src, event)))
      goto subclass_failed;
  }

done:
  gst_event_unref (event);

  return result;

  /* ERRORS */
subclass_failed:
  {
    GST_DEBUG_OBJECT (src, "subclass refused event");
    goto done;
  }
}

static void
gst_base_src_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstBaseSrc *src;

  src = GST_BASE_SRC (object);

  switch (prop_id) {
    case PROP_BLOCKSIZE:
      gst_base_src_set_blocksize (src, g_value_get_uint (value));
      break;
    case PROP_NUM_BUFFERS:
      src->num_buffers = g_value_get_int (value);
      break;
    case PROP_TYPEFIND:
      src->typefind = g_value_get_boolean (value);
      break;
    case PROP_DO_TIMESTAMP:
      gst_base_src_set_do_timestamp (src, g_value_get_boolean (value));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_base_src_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstBaseSrc *src;

  src = GST_BASE_SRC (object);

  switch (prop_id) {
    case PROP_BLOCKSIZE:
      g_value_set_uint (value, gst_base_src_get_blocksize (src));
      break;
    case PROP_NUM_BUFFERS:
      g_value_set_int (value, src->num_buffers);
      break;
    case PROP_TYPEFIND:
      g_value_set_boolean (value, src->typefind);
      break;
    case PROP_DO_TIMESTAMP:
      g_value_set_boolean (value, gst_base_src_get_do_timestamp (src));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

/* with STREAM_LOCK and LOCK */
static GstClockReturn
gst_base_src_wait (GstBaseSrc * basesrc, GstClock * clock, GstClockTime time)
{
  GstClockReturn ret;
  GstClockID id;

  id = gst_clock_new_single_shot_id (clock, time);

  basesrc->clock_id = id;
  /* release the live lock while waiting */
  GST_LIVE_UNLOCK (basesrc);

  ret = gst_clock_id_wait (id, NULL);

  GST_LIVE_LOCK (basesrc);
  gst_clock_id_unref (id);
  basesrc->clock_id = NULL;

  return ret;
}

/* perform synchronisation on a buffer.
 * with STREAM_LOCK.
 */
static GstClockReturn
gst_base_src_do_sync (GstBaseSrc * basesrc, GstBuffer * buffer)
{
  GstClockReturn result;
  GstClockTime start, end;
  GstBaseSrcClass *bclass;
  GstClockTime base_time;
  GstClock *clock;
  GstClockTime now = GST_CLOCK_TIME_NONE, pts, dts, timestamp;
  gboolean do_timestamp, first, pseudo_live, is_live;

  bclass = GST_BASE_SRC_GET_CLASS (basesrc);

  start = end = -1;
  if (bclass->get_times)
    bclass->get_times (basesrc, buffer, &start, &end);

  /* get buffer timestamp */
  dts = GST_BUFFER_DTS (buffer);
  pts = GST_BUFFER_PTS (buffer);

  if (GST_CLOCK_TIME_IS_VALID (dts))
    timestamp = dts;
  else
    timestamp = pts;

  /* grab the lock to prepare for clocking and calculate the startup
   * latency. */
  GST_OBJECT_LOCK (basesrc);

  is_live = basesrc->is_live;
  /* if we are asked to sync against the clock we are a pseudo live element */
  pseudo_live = (start != -1 && is_live);
  /* check for the first buffer */
  first = (basesrc->priv->latency == -1);

  if (timestamp != -1 && pseudo_live) {
    GstClockTime latency;

    /* we have a timestamp and a sync time, latency is the diff */
    if (timestamp <= start)
      latency = start - timestamp;
    else
      latency = 0;

    if (first) {
      GST_DEBUG_OBJECT (basesrc, "pseudo_live with latency %" GST_TIME_FORMAT,
          GST_TIME_ARGS (latency));
      /* first time we calculate latency, just configure */
      basesrc->priv->latency = latency;
    } else {
      if (basesrc->priv->latency != latency) {
        /* we have a new latency, FIXME post latency message */
        basesrc->priv->latency = latency;
        GST_DEBUG_OBJECT (basesrc, "latency changed to %" GST_TIME_FORMAT,
            GST_TIME_ARGS (latency));
      }
    }
  } else if (first) {
    GST_DEBUG_OBJECT (basesrc, "no latency needed, live %d, sync %d",
        is_live, start != -1);
    basesrc->priv->latency = 0;
  }

  /* get clock, if no clock, we can't sync or do timestamps */
  if ((clock = GST_ELEMENT_CLOCK (basesrc)) == NULL)
    goto no_clock;
  else
    gst_object_ref (clock);

  base_time = GST_ELEMENT_CAST (basesrc)->base_time;

  do_timestamp = basesrc->priv->do_timestamp;
  GST_OBJECT_UNLOCK (basesrc);

  /* first buffer, calculate the timestamp offset */
  if (first) {
    GstClockTime running_time;

    now = gst_clock_get_time (clock);
    running_time = now - base_time;

    GST_LOG_OBJECT (basesrc,
        "startup PTS: %" GST_TIME_FORMAT ", DTS %" GST_TIME_FORMAT
        ", running_time %" GST_TIME_FORMAT, GST_TIME_ARGS (pts),
        GST_TIME_ARGS (dts), GST_TIME_ARGS (running_time));

    if (pseudo_live && timestamp != -1) {
      /* live source and we need to sync, add startup latency to all timestamps
       * to get the real running_time. Live sources should always timestamp
       * according to the current running time. */
      basesrc->priv->ts_offset = GST_CLOCK_DIFF (timestamp, running_time);

      GST_LOG_OBJECT (basesrc, "live with sync, ts_offset %" GST_TIME_FORMAT,
          GST_TIME_ARGS (basesrc->priv->ts_offset));
    } else {
      basesrc->priv->ts_offset = 0;
      GST_LOG_OBJECT (basesrc, "no timestamp offset needed");
    }

    if (!GST_CLOCK_TIME_IS_VALID (dts)) {
      if (do_timestamp) {
        dts = running_time;
      } else {
        if (GST_CLOCK_TIME_IS_VALID (basesrc->segment.start)) {
          dts = basesrc->segment.start;
        } else {
          dts = 0;
        }
      }
      GST_BUFFER_DTS (buffer) = dts;

      GST_LOG_OBJECT (basesrc, "created DTS %" GST_TIME_FORMAT,
          GST_TIME_ARGS (dts));
    }
  } else {
    /* not the first buffer, the timestamp is the diff between the clock and
     * base_time */
    if (do_timestamp && !GST_CLOCK_TIME_IS_VALID (dts)) {
      now = gst_clock_get_time (clock);

      dts = now - base_time;
      GST_BUFFER_DTS (buffer) = dts;

      GST_LOG_OBJECT (basesrc, "created DTS %" GST_TIME_FORMAT,
          GST_TIME_ARGS (dts));
    }
  }
  if (!GST_CLOCK_TIME_IS_VALID (pts)) {
    if (!GST_BUFFER_FLAG_IS_SET (buffer, GST_BUFFER_FLAG_DELTA_UNIT))
      pts = dts;

    GST_BUFFER_PTS (buffer) = dts;

    GST_LOG_OBJECT (basesrc, "created PTS %" GST_TIME_FORMAT,
        GST_TIME_ARGS (pts));
  }

  /* if we don't have a buffer timestamp, we don't sync */
  if (!GST_CLOCK_TIME_IS_VALID (start))
    goto no_sync;

  if (is_live) {
    /* for pseudo live sources, add our ts_offset to the timestamp */
    if (GST_CLOCK_TIME_IS_VALID (pts))
      GST_BUFFER_PTS (buffer) += basesrc->priv->ts_offset;
    if (GST_CLOCK_TIME_IS_VALID (dts))
      GST_BUFFER_DTS (buffer) += basesrc->priv->ts_offset;
    start += basesrc->priv->ts_offset;
  }

  GST_LOG_OBJECT (basesrc,
      "waiting for clock, base time %" GST_TIME_FORMAT
      ", stream_start %" GST_TIME_FORMAT,
      GST_TIME_ARGS (base_time), GST_TIME_ARGS (start));

  result = gst_base_src_wait (basesrc, clock, start + base_time);

  gst_object_unref (clock);

  GST_LOG_OBJECT (basesrc, "clock entry done: %d", result);

  return result;

  /* special cases */
no_clock:
  {
    GST_DEBUG_OBJECT (basesrc, "we have no clock");
    GST_OBJECT_UNLOCK (basesrc);
    return GST_CLOCK_OK;
  }
no_sync:
  {
    GST_DEBUG_OBJECT (basesrc, "no sync needed");
    gst_object_unref (clock);
    return GST_CLOCK_OK;
  }
}

/* Called with STREAM_LOCK and LIVE_LOCK */
static gboolean
gst_base_src_update_length (GstBaseSrc * src, guint64 offset, guint * length,
    gboolean force)
{
  guint64 size, maxsize;
  GstBaseSrcClass *bclass;
  GstFormat format;
  gint64 stop;

  bclass = GST_BASE_SRC_GET_CLASS (src);

  format = src->segment.format;
  stop = src->segment.stop;
  /* get total file size */
  size = src->segment.duration;

  /* only operate if we are working with bytes */
  if (format != GST_FORMAT_BYTES)
    return TRUE;

  /* when not doing automatic EOS, just use the stop position. We don't use
   * the size to check for EOS */
  if (!g_atomic_int_get (&src->priv->automatic_eos))
    maxsize = stop;
  /* Otherwise, the max amount of bytes to read is the total
   * size or up to the segment.stop if present. */
  else if (stop != -1)
    maxsize = size != -1 ? MIN (size, stop) : stop;
  else
    maxsize = size;

  GST_DEBUG_OBJECT (src,
      "reading offset %" G_GUINT64_FORMAT ", length %u, size %" G_GINT64_FORMAT
      ", segment.stop %" G_GINT64_FORMAT ", maxsize %" G_GINT64_FORMAT, offset,
      *length, size, stop, maxsize);

  /* check size if we have one */
  if (maxsize != -1) {
    /* if we run past the end, check if the file became bigger and
     * retry.  Mind wrap when checking. */
    if (G_UNLIKELY (offset >= maxsize || offset + *length >= maxsize || force)) {
      /* see if length of the file changed */
      if (bclass->get_size)
        if (!bclass->get_size (src, &size))
          size = -1;

      /* make sure we don't exceed the configured segment stop
       * if it was set */
      if (stop != -1)
        maxsize = MIN (size, stop);
      else
        maxsize = size;

      /* if we are at or past the end, EOS */
      if (G_UNLIKELY (offset >= maxsize))
        goto unexpected_length;

      /* else we can clip to the end */
      if (G_UNLIKELY (offset + *length >= maxsize))
        *length = maxsize - offset;

    }
  }

  /* keep track of current duration. segment is in bytes, we checked
   * that above. */
  GST_OBJECT_LOCK (src);
  src->segment.duration = size;
  GST_OBJECT_UNLOCK (src);

  return TRUE;

  /* ERRORS */
unexpected_length:
  {
    return FALSE;
  }
}

/* must be called with LIVE_LOCK */
static GstFlowReturn
gst_base_src_get_range (GstBaseSrc * src, guint64 offset, guint length,
    GstBuffer ** buf)
{
  GstFlowReturn ret;
  GstBaseSrcClass *bclass;
  GstClockReturn status;
  GstBuffer *res_buf;
  GstBuffer *in_buf;

  bclass = GST_BASE_SRC_GET_CLASS (src);

again:
  if (src->is_live) {
    if (G_UNLIKELY (!src->live_running)) {
      ret = gst_base_src_wait_playing (src);
      if (ret != GST_FLOW_OK)
        goto stopped;
    }
  }

  if (G_UNLIKELY (!GST_BASE_SRC_IS_STARTED (src)
          && !GST_BASE_SRC_IS_STARTING (src)))
    goto not_started;

  if (G_UNLIKELY (!bclass->create))
    goto no_function;

  if (G_UNLIKELY (!gst_base_src_update_length (src, offset, &length, FALSE)))
    goto unexpected_length;

  /* track position */
  GST_OBJECT_LOCK (src);
  if (src->segment.format == GST_FORMAT_BYTES)
    src->segment.position = offset;
  GST_OBJECT_UNLOCK (src);

  /* normally we don't count buffers */
  if (G_UNLIKELY (src->num_buffers_left >= 0)) {
    if (src->num_buffers_left == 0)
      goto reached_num_buffers;
    else
      src->num_buffers_left--;
  }

  /* don't enter the create function if a pending EOS event was set. For the
   * logic of the has_pending_eos, check the event function of this class. */
  if (G_UNLIKELY (g_atomic_int_get (&src->priv->has_pending_eos))) {
    src->priv->forced_eos = TRUE;
    goto eos;
  }

  GST_DEBUG_OBJECT (src,
      "calling create offset %" G_GUINT64_FORMAT " length %u, time %"
      G_GINT64_FORMAT, offset, length, src->segment.time);

  res_buf = in_buf = *buf;

  ret = bclass->create (src, offset, length, &res_buf);

  /* The create function could be unlocked because we have a pending EOS. It's
   * possible that we have a valid buffer from create that we need to
   * discard when the create function returned _OK. */
  if (G_UNLIKELY (g_atomic_int_get (&src->priv->has_pending_eos))) {
    if (ret == GST_FLOW_OK) {
      if (*buf == NULL)
        gst_buffer_unref (res_buf);
    }
    src->priv->forced_eos = TRUE;
    goto eos;
  }

  if (G_UNLIKELY (ret != GST_FLOW_OK))
    goto not_ok;

  /* fallback in case the create function didn't fill a provided buffer */
  if (in_buf != NULL && res_buf != in_buf) {
    GstMapInfo info;
    gsize copied_size;

    GST_CAT_DEBUG_OBJECT (GST_CAT_PERFORMANCE, src, "create function didn't "
        "fill the provided buffer, copying");

    if (!gst_buffer_map (in_buf, &info, GST_MAP_WRITE))
      goto map_failed;

    copied_size = gst_buffer_extract (res_buf, 0, info.data, info.size);
    gst_buffer_unmap (in_buf, &info);
    gst_buffer_set_size (in_buf, copied_size);

    gst_buffer_copy_into (in_buf, res_buf, GST_BUFFER_COPY_METADATA, 0, -1);

    gst_buffer_unref (res_buf);
    res_buf = in_buf;
  }

  /* no timestamp set and we are at offset 0, we can timestamp with 0 */
  if (offset == 0 && src->segment.time == 0
      && GST_BUFFER_DTS (res_buf) == -1 && !src->is_live) {
    GST_DEBUG_OBJECT (src, "setting first timestamp to 0");
    res_buf = gst_buffer_make_writable (res_buf);
    GST_BUFFER_DTS (res_buf) = 0;
  }

  /* now sync before pushing the buffer */
  status = gst_base_src_do_sync (src, res_buf);

  /* waiting for the clock could have made us flushing */
  if (G_UNLIKELY (src->priv->flushing))
    goto flushing;

  switch (status) {
    case GST_CLOCK_EARLY:
      /* the buffer is too late. We currently don't drop the buffer. */
      GST_DEBUG_OBJECT (src, "buffer too late!, returning anyway");
      break;
    case GST_CLOCK_OK:
      /* buffer synchronised properly */
      GST_DEBUG_OBJECT (src, "buffer ok");
      break;
    case GST_CLOCK_UNSCHEDULED:
      /* this case is triggered when we were waiting for the clock and
       * it got unlocked because we did a state change. In any case, get rid of
       * the buffer. */
      if (*buf == NULL)
        gst_buffer_unref (res_buf);

      if (!src->live_running) {
        /* We return FLUSHING when we are not running to stop the dataflow also
         * get rid of the produced buffer. */
        GST_DEBUG_OBJECT (src,
            "clock was unscheduled (%d), returning FLUSHING", status);
        ret = GST_FLOW_FLUSHING;
      } else {
        /* If we are running when this happens, we quickly switched between
         * pause and playing. We try to produce a new buffer */
        GST_DEBUG_OBJECT (src,
            "clock was unscheduled (%d), but we are running", status);
        goto again;
      }
      break;
    default:
      /* all other result values are unexpected and errors */
      GST_ELEMENT_ERROR (src, CORE, CLOCK,
          (_("Internal clock error.")),
          ("clock returned unexpected return value %d", status));
      if (*buf == NULL)
        gst_buffer_unref (res_buf);
      ret = GST_FLOW_ERROR;
      break;
  }
  if (G_LIKELY (ret == GST_FLOW_OK))
    *buf = res_buf;

  return ret;

  /* ERROR */
stopped:
  {
    GST_DEBUG_OBJECT (src, "wait_playing returned %d (%s)", ret,
        gst_flow_get_name (ret));
    return ret;
  }
not_ok:
  {
    GST_DEBUG_OBJECT (src, "create returned %d (%s)", ret,
        gst_flow_get_name (ret));
    return ret;
  }
map_failed:
  {
    GST_ELEMENT_ERROR (src, RESOURCE, BUSY,
        (_("Failed to map buffer.")),
        ("failed to map result buffer in WRITE mode"));
    if (*buf == NULL)
      gst_buffer_unref (res_buf);
    return GST_FLOW_ERROR;
  }
not_started:
  {
    GST_DEBUG_OBJECT (src, "getrange but not started");
    return GST_FLOW_FLUSHING;
  }
no_function:
  {
    GST_DEBUG_OBJECT (src, "no create function");
    return GST_FLOW_NOT_SUPPORTED;
  }
unexpected_length:
  {
    GST_DEBUG_OBJECT (src, "unexpected length %u (offset=%" G_GUINT64_FORMAT
        ", size=%" G_GINT64_FORMAT ")", length, offset, src->segment.duration);
    return GST_FLOW_EOS;
  }
reached_num_buffers:
  {
    GST_DEBUG_OBJECT (src, "sent all buffers");
    return GST_FLOW_EOS;
  }
flushing:
  {
    GST_DEBUG_OBJECT (src, "we are flushing");
    if (*buf == NULL)
      gst_buffer_unref (res_buf);
    return GST_FLOW_FLUSHING;
  }
eos:
  {
    GST_DEBUG_OBJECT (src, "we are EOS");
    return GST_FLOW_EOS;
  }
}

static GstFlowReturn
gst_base_src_getrange (GstPad * pad, GstObject * parent, guint64 offset,
    guint length, GstBuffer ** buf)
{
  GstBaseSrc *src;
  GstFlowReturn res;

  src = GST_BASE_SRC_CAST (parent);

  GST_LIVE_LOCK (src);
  if (G_UNLIKELY (src->priv->flushing))
    goto flushing;

  res = gst_base_src_get_range (src, offset, length, buf);

done:
  GST_LIVE_UNLOCK (src);

  return res;

  /* ERRORS */
flushing:
  {
    GST_DEBUG_OBJECT (src, "we are flushing");
    res = GST_FLOW_FLUSHING;
    goto done;
  }
}

static gboolean
gst_base_src_is_random_access (GstBaseSrc * src)
{
  /* we need to start the basesrc to check random access */
  if (!GST_BASE_SRC_IS_STARTED (src)) {
    GST_LOG_OBJECT (src, "doing start/stop to check get_range support");
    if (G_LIKELY (gst_base_src_start (src))) {
      if (gst_base_src_start_wait (src) != GST_FLOW_OK)
        goto start_failed;
      gst_base_src_stop (src);
    }
  }

  return src->random_access;

  /* ERRORS */
start_failed:
  {
    GST_DEBUG_OBJECT (src, "failed to start");
    return FALSE;
  }
}

static void
gst_base_src_loop (GstPad * pad)
{
  GstBaseSrc *src;
  GstBuffer *buf = NULL;
  GstFlowReturn ret;
  gint64 position;
  gboolean eos;
  guint blocksize;
  GList *pending_events = NULL, *tmp;

  eos = FALSE;

  src = GST_BASE_SRC (GST_OBJECT_PARENT (pad));

  /* Just leave immediately if we're flushing */
  GST_LIVE_LOCK (src);
  if (G_UNLIKELY (src->priv->flushing || GST_PAD_IS_FLUSHING (pad)))
    goto flushing;
  GST_LIVE_UNLOCK (src);

  gst_base_src_send_stream_start (src);

  /* The stream-start event could've caused something to flush us */
  GST_LIVE_LOCK (src);
  if (G_UNLIKELY (src->priv->flushing || GST_PAD_IS_FLUSHING (pad)))
    goto flushing;
  GST_LIVE_UNLOCK (src);

  /* check if we need to renegotiate */
  if (gst_pad_check_reconfigure (pad)) {
    if (!gst_base_src_negotiate (src)) {
      gst_pad_mark_reconfigure (pad);
      if (GST_PAD_IS_FLUSHING (pad)) {
        GST_LIVE_LOCK (src);
        goto flushing;
      } else {
        goto negotiate_failed;
      }
    }
  }

  GST_LIVE_LOCK (src);

  if (G_UNLIKELY (src->priv->flushing || GST_PAD_IS_FLUSHING (pad)))
    goto flushing;

  blocksize = src->blocksize;

  /* if we operate in bytes, we can calculate an offset */
  if (src->segment.format == GST_FORMAT_BYTES) {
    position = src->segment.position;
    /* for negative rates, start with subtracting the blocksize */
    if (src->segment.rate < 0.0) {
      /* we cannot go below segment.start */
      if (position > src->segment.start + blocksize)
        position -= blocksize;
      else {
        /* last block, remainder up to segment.start */
        blocksize = position - src->segment.start;
        position = src->segment.start;
      }
    }
  } else
    position = -1;

  GST_LOG_OBJECT (src, "next_ts %" GST_TIME_FORMAT " size %u",
      GST_TIME_ARGS (position), blocksize);

  ret = gst_base_src_get_range (src, position, blocksize, &buf);
  if (G_UNLIKELY (ret != GST_FLOW_OK)) {
    GST_INFO_OBJECT (src, "pausing after gst_base_src_get_range() = %s",
        gst_flow_get_name (ret));
    GST_LIVE_UNLOCK (src);
    goto pause;
  }
  /* this should not happen */
  if (G_UNLIKELY (buf == NULL))
    goto null_buffer;

  /* push events to close/start our segment before we push the buffer. */
  if (G_UNLIKELY (src->priv->segment_pending)) {
    GstEvent *seg_event = gst_event_new_segment (&src->segment);

    gst_event_set_seqnum (seg_event, src->priv->segment_seqnum);
    src->priv->segment_seqnum = gst_util_seqnum_next ();
    gst_pad_push_event (pad, seg_event);
    src->priv->segment_pending = FALSE;
  }

  if (g_atomic_int_get (&src->priv->have_events)) {
    GST_OBJECT_LOCK (src);
    /* take the events */
    pending_events = src->priv->pending_events;
    src->priv->pending_events = NULL;
    g_atomic_int_set (&src->priv->have_events, FALSE);
    GST_OBJECT_UNLOCK (src);
  }

  /* Push out pending events if any */
  if (G_UNLIKELY (pending_events != NULL)) {
    for (tmp = pending_events; tmp; tmp = g_list_next (tmp)) {
      GstEvent *ev = (GstEvent *) tmp->data;
      gst_pad_push_event (pad, ev);
    }
    g_list_free (pending_events);
  }

  /* figure out the new position */
  switch (src->segment.format) {
    case GST_FORMAT_BYTES:
    {
      guint bufsize = gst_buffer_get_size (buf);

      /* we subtracted above for negative rates */
      if (src->segment.rate >= 0.0)
        position += bufsize;
      break;
    }
    case GST_FORMAT_TIME:
    {
      GstClockTime start, duration;

      start = GST_BUFFER_TIMESTAMP (buf);
      duration = GST_BUFFER_DURATION (buf);

      if (GST_CLOCK_TIME_IS_VALID (start))
        position = start;
      else
        position = src->segment.position;

      if (GST_CLOCK_TIME_IS_VALID (duration)) {
        if (src->segment.rate >= 0.0)
          position += duration;
        else if (position > duration)
          position -= duration;
        else
          position = 0;
      }
      break;
    }
    case GST_FORMAT_DEFAULT:
      if (src->segment.rate >= 0.0)
        position = GST_BUFFER_OFFSET_END (buf);
      else
        position = GST_BUFFER_OFFSET (buf);
      break;
    default:
      position = -1;
      break;
  }
  if (position != -1) {
    if (src->segment.rate >= 0.0) {
      /* positive rate, check if we reached the stop */
      if (src->segment.stop != -1) {
        if (position >= src->segment.stop) {
          eos = TRUE;
          position = src->segment.stop;
        }
      }
    } else {
      /* negative rate, check if we reached the start. start is always set to
       * something different from -1 */
      if (position <= src->segment.start) {
        eos = TRUE;
        position = src->segment.start;
      }
      /* when going reverse, all buffers are DISCONT */
      src->priv->discont = TRUE;
    }
    GST_OBJECT_LOCK (src);
    src->segment.position = position;
    GST_OBJECT_UNLOCK (src);
  }

  if (G_UNLIKELY (src->priv->discont)) {
    GST_INFO_OBJECT (src, "marking pending DISCONT");
    buf = gst_buffer_make_writable (buf);
    GST_BUFFER_FLAG_SET (buf, GST_BUFFER_FLAG_DISCONT);
    src->priv->discont = FALSE;
  }
  GST_LIVE_UNLOCK (src);

  ret = gst_pad_push (pad, buf);
  if (G_UNLIKELY (ret != GST_FLOW_OK)) {
    if (ret == GST_FLOW_NOT_NEGOTIATED) {
      goto not_negotiated;
    }
    GST_INFO_OBJECT (src, "pausing after gst_pad_push() = %s",
        gst_flow_get_name (ret));
    goto pause;
  }

  /* Segment pending means that a new segment was configured
   * during this loop run */
  if (G_UNLIKELY (eos && !src->priv->segment_pending)) {
    GST_INFO_OBJECT (src, "pausing after end of segment");
    ret = GST_FLOW_EOS;
    goto pause;
  }

done:
  return;

  /* special cases */
not_negotiated:
  {
    if (gst_pad_needs_reconfigure (pad)) {
      GST_DEBUG_OBJECT (src, "Retrying to renegotiate");
      return;
    }
    /* fallthrough when push returns NOT_NEGOTIATED and we don't have
     * a pending negotiation request on our srcpad */
  }
negotiate_failed:
  {
    GST_DEBUG_OBJECT (src, "Not negotiated");
    ret = GST_FLOW_NOT_NEGOTIATED;
    goto pause;
  }
flushing:
  {
    GST_DEBUG_OBJECT (src, "we are flushing");
    GST_LIVE_UNLOCK (src);
    ret = GST_FLOW_FLUSHING;
    goto pause;
  }
pause:
  {
    const gchar *reason = gst_flow_get_name (ret);
    GstEvent *event;

    GST_DEBUG_OBJECT (src, "pausing task, reason %s", reason);
    src->running = FALSE;
    gst_pad_pause_task (pad);
    if (ret == GST_FLOW_EOS) {
      gboolean flag_segment;
      GstFormat format;
      gint64 position;

      flag_segment = (src->segment.flags & GST_SEGMENT_FLAG_SEGMENT) != 0;
      format = src->segment.format;
      position = src->segment.position;

      /* perform EOS logic */
      if (src->priv->forced_eos) {
        g_assert (g_atomic_int_get (&src->priv->has_pending_eos));
        GST_OBJECT_LOCK (src);
        event = src->priv->pending_eos;
        src->priv->pending_eos = NULL;
        GST_OBJECT_UNLOCK (src);

      } else if (flag_segment) {
        GstMessage *message;

        message = gst_message_new_segment_done (GST_OBJECT_CAST (src),
            format, position);
        gst_message_set_seqnum (message, src->priv->seqnum);
        gst_element_post_message (GST_ELEMENT_CAST (src), message);
        event = gst_event_new_segment_done (format, position);
        gst_event_set_seqnum (event, src->priv->seqnum);

      } else {
        event = gst_event_new_eos ();
        gst_event_set_seqnum (event, src->priv->seqnum);
      }

      gst_pad_push_event (pad, event);
      src->priv->forced_eos = FALSE;

    } else if (ret == GST_FLOW_NOT_LINKED || ret <= GST_FLOW_EOS) {
      event = gst_event_new_eos ();
      gst_event_set_seqnum (event, src->priv->seqnum);
      /* for fatal errors we post an error message, post the error
       * first so the app knows about the error first.
       * Also don't do this for FLUSHING because it happens
       * due to flushing and posting an error message because of
       * that is the wrong thing to do, e.g. when we're doing
       * a flushing seek. */
      GST_ELEMENT_ERROR (src, STREAM, FAILED,
          (_("Internal data flow error.")),
          ("streaming task paused, reason %s (%d)", reason, ret));
      gst_pad_push_event (pad, event);
    }
    goto done;
  }
null_buffer:
  {
    GST_ELEMENT_ERROR (src, STREAM, FAILED,
        (_("Internal data flow error.")), ("element returned NULL buffer"));
    GST_LIVE_UNLOCK (src);
    goto done;
  }
}

static gboolean
gst_base_src_set_allocation (GstBaseSrc * basesrc, GstBufferPool * pool,
    GstAllocator * allocator, GstAllocationParams * params)
{
  GstAllocator *oldalloc;
  GstBufferPool *oldpool;
  GstBaseSrcPrivate *priv = basesrc->priv;

  if (pool) {
    GST_DEBUG_OBJECT (basesrc, "activate pool");
    if (!gst_buffer_pool_set_active (pool, TRUE))
      goto activate_failed;
  }

  GST_OBJECT_LOCK (basesrc);
  oldpool = priv->pool;
  priv->pool = pool;

  oldalloc = priv->allocator;
  priv->allocator = allocator;

  if (params)
    priv->params = *params;
  else
    gst_allocation_params_init (&priv->params);
  GST_OBJECT_UNLOCK (basesrc);

  if (oldpool) {
    /* only deactivate if the pool is not the one we're using */
    if (oldpool != pool) {
      GST_DEBUG_OBJECT (basesrc, "deactivate old pool");
      gst_buffer_pool_set_active (oldpool, FALSE);
    }
    gst_object_unref (oldpool);
  }
  if (oldalloc) {
    gst_object_unref (oldalloc);
  }
  return TRUE;

  /* ERRORS */
activate_failed:
  {
    GST_ERROR_OBJECT (basesrc, "failed to activate bufferpool.");
    return FALSE;
  }
}

static gboolean
gst_base_src_activate_pool (GstBaseSrc * basesrc, gboolean active)
{
  GstBaseSrcPrivate *priv = basesrc->priv;
  GstBufferPool *pool;
  gboolean res = TRUE;

  GST_OBJECT_LOCK (basesrc);
  if ((pool = priv->pool))
    pool = gst_object_ref (pool);
  GST_OBJECT_UNLOCK (basesrc);

  if (pool) {
    res = gst_buffer_pool_set_active (pool, active);
    gst_object_unref (pool);
  }
  return res;
}


static gboolean
gst_base_src_decide_allocation_default (GstBaseSrc * basesrc, GstQuery * query)
{
  GstCaps *outcaps;
  GstBufferPool *pool;
  guint size, min, max;
  GstAllocator *allocator;
  GstAllocationParams params;
  GstStructure *config;
  gboolean update_allocator;

  gst_query_parse_allocation (query, &outcaps, NULL);

  /* we got configuration from our peer or the decide_allocation method,
   * parse them */
  if (gst_query_get_n_allocation_params (query) > 0) {
    /* try the allocator */
    gst_query_parse_nth_allocation_param (query, 0, &allocator, &params);
    update_allocator = TRUE;
  } else {
    allocator = NULL;
    gst_allocation_params_init (&params);
    update_allocator = FALSE;
  }

  if (gst_query_get_n_allocation_pools (query) > 0) {
    gst_query_parse_nth_allocation_pool (query, 0, &pool, &size, &min, &max);

    if (pool == NULL) {
      /* no pool, we can make our own */
      GST_DEBUG_OBJECT (basesrc, "no pool, making new pool");
      pool = gst_buffer_pool_new ();
    }
  } else {
    pool = NULL;
    size = min = max = 0;
  }

  /* now configure */
  if (pool) {
    config = gst_buffer_pool_get_config (pool);
    gst_buffer_pool_config_set_params (config, outcaps, size, min, max);
    gst_buffer_pool_config_set_allocator (config, allocator, &params);

    /* buffer pool may have to do some changes */
    if (!gst_buffer_pool_set_config (pool, config)) {
      config = gst_buffer_pool_get_config (pool);

      /* If change are not acceptable, fallback to generic pool */
      if (!gst_buffer_pool_config_validate_params (config, outcaps, size, min,
              max)) {
        GST_DEBUG_OBJECT (basesrc, "unsuported pool, making new pool");

        gst_object_unref (pool);
        pool = gst_buffer_pool_new ();
        gst_buffer_pool_config_set_params (config, outcaps, size, min, max);
        gst_buffer_pool_config_set_allocator (config, allocator, &params);
      }

      if (!gst_buffer_pool_set_config (pool, config))
        goto config_failed;
    }
  }

  if (update_allocator)
    gst_query_set_nth_allocation_param (query, 0, allocator, &params);
  else
    gst_query_add_allocation_param (query, allocator, &params);
  if (allocator)
    gst_object_unref (allocator);

  if (pool) {
    gst_query_set_nth_allocation_pool (query, 0, pool, size, min, max);
    gst_object_unref (pool);
  }

  return TRUE;

config_failed:
  GST_ELEMENT_ERROR (basesrc, RESOURCE, SETTINGS,
      ("Failed to configure the buffer pool"),
      ("Configuration is most likely invalid, please report this issue."));
  return FALSE;
}

static gboolean
gst_base_src_prepare_allocation (GstBaseSrc * basesrc, GstCaps * caps)
{
  GstBaseSrcClass *bclass;
  gboolean result = TRUE;
  GstQuery *query;
  GstBufferPool *pool = NULL;
  GstAllocator *allocator = NULL;
  GstAllocationParams params;

  bclass = GST_BASE_SRC_GET_CLASS (basesrc);

  /* make query and let peer pad answer, we don't really care if it worked or
   * not, if it failed, the allocation query would contain defaults and the
   * subclass would then set better values if needed */
  query = gst_query_new_allocation (caps, TRUE);
  if (!gst_pad_peer_query (basesrc->srcpad, query)) {
    /* not a problem, just debug a little */
    GST_DEBUG_OBJECT (basesrc, "peer ALLOCATION query failed");
  }

  g_assert (bclass->decide_allocation != NULL);
  result = bclass->decide_allocation (basesrc, query);

  GST_DEBUG_OBJECT (basesrc, "ALLOCATION (%d) params: %" GST_PTR_FORMAT, result,
      query);

  if (!result)
    goto no_decide_allocation;

  /* we got configuration from our peer or the decide_allocation method,
   * parse them */
  if (gst_query_get_n_allocation_params (query) > 0) {
    gst_query_parse_nth_allocation_param (query, 0, &allocator, &params);
  } else {
    allocator = NULL;
    gst_allocation_params_init (&params);
  }

  if (gst_query_get_n_allocation_pools (query) > 0)
    gst_query_parse_nth_allocation_pool (query, 0, &pool, NULL, NULL, NULL);

  result = gst_base_src_set_allocation (basesrc, pool, allocator, &params);

  gst_query_unref (query);

  return result;

  /* Errors */
no_decide_allocation:
  {
    GST_WARNING_OBJECT (basesrc, "Subclass failed to decide allocation");
    gst_query_unref (query);

    return result;
  }
}

/* default negotiation code.
 *
 * Take intersection between src and sink pads, take first
 * caps and fixate.
 */
static gboolean
gst_base_src_default_negotiate (GstBaseSrc * basesrc)
{
  GstCaps *thiscaps;
  GstCaps *caps = NULL;
  GstCaps *peercaps = NULL;
  gboolean result = FALSE;

  /* first see what is possible on our source pad */
  thiscaps = gst_pad_query_caps (GST_BASE_SRC_PAD (basesrc), NULL);
  GST_DEBUG_OBJECT (basesrc, "caps of src: %" GST_PTR_FORMAT, thiscaps);
  /* nothing or anything is allowed, we're done */
  if (thiscaps == NULL || gst_caps_is_any (thiscaps))
    goto no_nego_needed;

  if (G_UNLIKELY (gst_caps_is_empty (thiscaps)))
    goto no_caps;

  /* get the peer caps */
  peercaps = gst_pad_peer_query_caps (GST_BASE_SRC_PAD (basesrc), thiscaps);
  GST_DEBUG_OBJECT (basesrc, "caps of peer: %" GST_PTR_FORMAT, peercaps);
  if (peercaps) {
    /* The result is already a subset of our caps */
    caps = peercaps;
    gst_caps_unref (thiscaps);
  } else {
    /* no peer, work with our own caps then */
    caps = thiscaps;
  }
  if (caps && !gst_caps_is_empty (caps)) {
    /* now fixate */
    GST_DEBUG_OBJECT (basesrc, "have caps: %" GST_PTR_FORMAT, caps);
    if (gst_caps_is_any (caps)) {
      GST_DEBUG_OBJECT (basesrc, "any caps, we stop");
      /* hmm, still anything, so element can do anything and
       * nego is not needed */
      result = TRUE;
    } else {
      caps = gst_base_src_fixate (basesrc, caps);
      GST_DEBUG_OBJECT (basesrc, "fixated to: %" GST_PTR_FORMAT, caps);
      if (gst_caps_is_fixed (caps)) {
        /* yay, fixed caps, use those then, it's possible that the subclass does
         * not accept this caps after all and we have to fail. */
        result = gst_base_src_set_caps (basesrc, caps);
      }
    }
    gst_caps_unref (caps);
  } else {
    if (caps)
      gst_caps_unref (caps);
    GST_DEBUG_OBJECT (basesrc, "no common caps");
  }
  return result;

no_nego_needed:
  {
    GST_DEBUG_OBJECT (basesrc, "no negotiation needed");
    if (thiscaps)
      gst_caps_unref (thiscaps);
    return TRUE;
  }
no_caps:
  {
    GST_ELEMENT_ERROR (basesrc, STREAM, FORMAT,
        ("No supported formats found"),
        ("This element did not produce valid caps"));
    if (thiscaps)
      gst_caps_unref (thiscaps);
    return TRUE;
  }
}

static gboolean
gst_base_src_negotiate (GstBaseSrc * basesrc)
{
  GstBaseSrcClass *bclass;
  gboolean result;

  bclass = GST_BASE_SRC_GET_CLASS (basesrc);

  GST_DEBUG_OBJECT (basesrc, "starting negotiation");

  if (G_LIKELY (bclass->negotiate))
    result = bclass->negotiate (basesrc);
  else
    result = TRUE;

  if (G_LIKELY (result)) {
    GstCaps *caps;

    caps = gst_pad_get_current_caps (basesrc->srcpad);

    result = gst_base_src_prepare_allocation (basesrc, caps);

    if (caps)
      gst_caps_unref (caps);
  }
  return result;
}

static gboolean
gst_base_src_start (GstBaseSrc * basesrc)
{
  GstBaseSrcClass *bclass;
  gboolean result;

  GST_LIVE_LOCK (basesrc);

  GST_OBJECT_LOCK (basesrc);
  if (GST_BASE_SRC_IS_STARTING (basesrc))
    goto was_starting;
  if (GST_BASE_SRC_IS_STARTED (basesrc))
    goto was_started;

  basesrc->priv->start_result = GST_FLOW_FLUSHING;
  GST_OBJECT_FLAG_SET (basesrc, GST_BASE_SRC_FLAG_STARTING);
  gst_segment_init (&basesrc->segment, basesrc->segment.format);
  GST_OBJECT_UNLOCK (basesrc);

  basesrc->num_buffers_left = basesrc->num_buffers;
  basesrc->running = FALSE;
  basesrc->priv->segment_pending = FALSE;
  basesrc->priv->segment_seqnum = gst_util_seqnum_next ();
  basesrc->priv->forced_eos = FALSE;
  GST_LIVE_UNLOCK (basesrc);

  bclass = GST_BASE_SRC_GET_CLASS (basesrc);
  if (bclass->start)
    result = bclass->start (basesrc);
  else
    result = TRUE;

  if (!result)
    goto could_not_start;

  if (!gst_base_src_is_async (basesrc)) {
    gst_base_src_start_complete (basesrc, GST_FLOW_OK);
    /* not really waiting here, we call this to get the result
     * from the start_complete call */
    result = gst_base_src_start_wait (basesrc) == GST_FLOW_OK;
  }

  return result;

  /* ERROR */
was_starting:
  {
    GST_DEBUG_OBJECT (basesrc, "was starting");
    GST_OBJECT_UNLOCK (basesrc);
    GST_LIVE_UNLOCK (basesrc);
    return TRUE;
  }
was_started:
  {
    GST_DEBUG_OBJECT (basesrc, "was started");
    GST_OBJECT_UNLOCK (basesrc);
    GST_LIVE_UNLOCK (basesrc);
    return TRUE;
  }
could_not_start:
  {
    GST_DEBUG_OBJECT (basesrc, "could not start");
    /* subclass is supposed to post a message. We don't have to call _stop. */
    gst_base_src_start_complete (basesrc, GST_FLOW_ERROR);
    return FALSE;
  }
}

/**
 * gst_base_src_start_complete:
 * @basesrc: base source instance
 * @ret: a #GstFlowReturn
 *
 * Complete an asynchronous start operation. When the subclass overrides the
 * start method, it should call gst_base_src_start_complete() when the start
 * operation completes either from the same thread or from an asynchronous
 * helper thread.
 */
void
gst_base_src_start_complete (GstBaseSrc * basesrc, GstFlowReturn ret)
{
  gboolean have_size;
  guint64 size;
  gboolean seekable;
  GstFormat format;
  GstPadMode mode;
  GstEvent *event;

  if (ret != GST_FLOW_OK)
    goto error;

  GST_DEBUG_OBJECT (basesrc, "starting source");
  format = basesrc->segment.format;

  /* figure out the size */
  have_size = FALSE;
  size = -1;
  if (format == GST_FORMAT_BYTES) {
    GstBaseSrcClass *bclass = GST_BASE_SRC_GET_CLASS (basesrc);

    if (bclass->get_size) {
      if (!(have_size = bclass->get_size (basesrc, &size)))
        size = -1;
    }
    GST_DEBUG_OBJECT (basesrc, "setting size %" G_GUINT64_FORMAT, size);
    /* only update the size when operating in bytes, subclass is supposed
     * to set duration in the start method for other formats */
    GST_OBJECT_LOCK (basesrc);
    basesrc->segment.duration = size;
    GST_OBJECT_UNLOCK (basesrc);
  }

  GST_DEBUG_OBJECT (basesrc,
      "format: %s, have size: %d, size: %" G_GUINT64_FORMAT ", duration: %"
      G_GINT64_FORMAT, gst_format_get_name (format), have_size, size,
      basesrc->segment.duration);

  seekable = gst_base_src_seekable (basesrc);
  GST_DEBUG_OBJECT (basesrc, "is seekable: %d", seekable);

  /* update for random access flag */
  basesrc->random_access = seekable && format == GST_FORMAT_BYTES;

  GST_DEBUG_OBJECT (basesrc, "is random_access: %d", basesrc->random_access);

  /* stop flushing now but for live sources, still block in the LIVE lock when
   * we are not yet PLAYING */
  gst_base_src_set_flushing (basesrc, FALSE, FALSE, NULL);

  gst_pad_mark_reconfigure (GST_BASE_SRC_PAD (basesrc));

  GST_OBJECT_LOCK (basesrc->srcpad);
  mode = GST_PAD_MODE (basesrc->srcpad);
  GST_OBJECT_UNLOCK (basesrc->srcpad);

  /* take the stream lock here, we only want to let the task run when we have
   * set the STARTED flag */
  GST_PAD_STREAM_LOCK (basesrc->srcpad);
  switch (mode) {
    case GST_PAD_MODE_PUSH:
      /* do initial seek, which will start the task */
      GST_OBJECT_LOCK (basesrc);
      event = basesrc->pending_seek;
      basesrc->pending_seek = NULL;
      GST_OBJECT_UNLOCK (basesrc);

      /* The perform seek code will start the task when finished. We don't have to
       * unlock the streaming thread because it is not running yet */
      if (G_UNLIKELY (!gst_base_src_perform_seek (basesrc, event, FALSE)))
        goto seek_failed;

      if (event)
        gst_event_unref (event);
      break;
    case GST_PAD_MODE_PULL:
      /* if not random_access, we cannot operate in pull mode for now */
      if (G_UNLIKELY (!basesrc->random_access))
        goto no_get_range;
      break;
    default:
      goto not_activated_yet;
      break;
  }

  GST_OBJECT_LOCK (basesrc);
  GST_OBJECT_FLAG_SET (basesrc, GST_BASE_SRC_FLAG_STARTED);
  GST_OBJECT_FLAG_UNSET (basesrc, GST_BASE_SRC_FLAG_STARTING);
  basesrc->priv->start_result = ret;
  GST_ASYNC_SIGNAL (basesrc);
  GST_OBJECT_UNLOCK (basesrc);

  GST_PAD_STREAM_UNLOCK (basesrc->srcpad);

  return;

seek_failed:
  {
    GST_PAD_STREAM_UNLOCK (basesrc->srcpad);
    GST_ERROR_OBJECT (basesrc, "Failed to perform initial seek");
    gst_base_src_stop (basesrc);
    if (event)
      gst_event_unref (event);
    ret = GST_FLOW_ERROR;
    goto error;
  }
no_get_range:
  {
    GST_PAD_STREAM_UNLOCK (basesrc->srcpad);
    gst_base_src_stop (basesrc);
    GST_ERROR_OBJECT (basesrc, "Cannot operate in pull mode, stopping");
    ret = GST_FLOW_ERROR;
    goto error;
  }
not_activated_yet:
  {
    GST_PAD_STREAM_UNLOCK (basesrc->srcpad);
    gst_base_src_stop (basesrc);
    GST_WARNING_OBJECT (basesrc, "pad not activated yet");
    ret = GST_FLOW_ERROR;
    goto error;
  }
error:
  {
    GST_OBJECT_LOCK (basesrc);
    basesrc->priv->start_result = ret;
    GST_OBJECT_FLAG_UNSET (basesrc, GST_BASE_SRC_FLAG_STARTING);
    GST_ASYNC_SIGNAL (basesrc);
    GST_OBJECT_UNLOCK (basesrc);
    return;
  }
}

/**
 * gst_base_src_start_wait:
 * @basesrc: base source instance
 *
 * Wait until the start operation completes.
 *
 * Returns: a #GstFlowReturn.
 */
GstFlowReturn
gst_base_src_start_wait (GstBaseSrc * basesrc)
{
  GstFlowReturn result;

  GST_OBJECT_LOCK (basesrc);
  while (GST_BASE_SRC_IS_STARTING (basesrc)) {
    GST_ASYNC_WAIT (basesrc);
  }
  result = basesrc->priv->start_result;
  GST_OBJECT_UNLOCK (basesrc);

  GST_DEBUG_OBJECT (basesrc, "got %s", gst_flow_get_name (result));

  return result;
}

static gboolean
gst_base_src_stop (GstBaseSrc * basesrc)
{
  GstBaseSrcClass *bclass;
  gboolean result = TRUE;

  GST_DEBUG_OBJECT (basesrc, "stopping source");

  /* flush all */
  gst_base_src_set_flushing (basesrc, TRUE, FALSE, NULL);
  /* stop the task */
  gst_pad_stop_task (basesrc->srcpad);

  GST_OBJECT_LOCK (basesrc);
  if (!GST_BASE_SRC_IS_STARTED (basesrc) && !GST_BASE_SRC_IS_STARTING (basesrc))
    goto was_stopped;

  GST_OBJECT_FLAG_UNSET (basesrc, GST_BASE_SRC_FLAG_STARTING);
  GST_OBJECT_FLAG_UNSET (basesrc, GST_BASE_SRC_FLAG_STARTED);
  basesrc->priv->start_result = GST_FLOW_FLUSHING;
  GST_ASYNC_SIGNAL (basesrc);
  GST_OBJECT_UNLOCK (basesrc);

  bclass = GST_BASE_SRC_GET_CLASS (basesrc);
  if (bclass->stop)
    result = bclass->stop (basesrc);

  gst_base_src_set_allocation (basesrc, NULL, NULL, NULL);

  return result;

was_stopped:
  {
    GST_DEBUG_OBJECT (basesrc, "was stopped");
    GST_OBJECT_UNLOCK (basesrc);
    return TRUE;
  }
}

/* start or stop flushing dataprocessing
 */
static gboolean
gst_base_src_set_flushing (GstBaseSrc * basesrc,
    gboolean flushing, gboolean live_play, gboolean * playing)
{
  GstBaseSrcClass *bclass;

  bclass = GST_BASE_SRC_GET_CLASS (basesrc);

  GST_DEBUG_OBJECT (basesrc, "flushing %d, live_play %d", flushing, live_play);

  if (flushing) {
    gst_base_src_activate_pool (basesrc, FALSE);
    /* unlock any subclasses, we need to do this before grabbing the
     * LIVE_LOCK since we hold this lock before going into ::create. We pass an
     * unlock to the params because of backwards compat (see seek handler)*/
    if (bclass->unlock)
      bclass->unlock (basesrc);
  }

  /* the live lock is released when we are blocked, waiting for playing or
   * when we sync to the clock. */
  GST_LIVE_LOCK (basesrc);
  if (playing)
    *playing = basesrc->live_running;
  basesrc->priv->flushing = flushing;
  if (flushing) {
    /* if we are locked in the live lock, signal it to make it flush */
    basesrc->live_running = TRUE;

    /* clear pending EOS if any */
    if (g_atomic_int_get (&basesrc->priv->has_pending_eos)) {
      GST_OBJECT_LOCK (basesrc);
      CLEAR_PENDING_EOS (basesrc);
      basesrc->priv->forced_eos = FALSE;
      GST_OBJECT_UNLOCK (basesrc);
    }

    /* step 1, now that we have the LIVE lock, clear our unlock request */
    if (bclass->unlock_stop)
      bclass->unlock_stop (basesrc);

    /* step 2, unblock clock sync (if any) or any other blocking thing */
    if (basesrc->clock_id)
      gst_clock_id_unschedule (basesrc->clock_id);
  } else {
    /* signal the live source that it can start playing */
    basesrc->live_running = live_play;

    gst_base_src_activate_pool (basesrc, TRUE);

    /* Drop all delayed events */
    GST_OBJECT_LOCK (basesrc);
    if (basesrc->priv->pending_events) {
      g_list_foreach (basesrc->priv->pending_events, (GFunc) gst_event_unref,
          NULL);
      g_list_free (basesrc->priv->pending_events);
      basesrc->priv->pending_events = NULL;
      g_atomic_int_set (&basesrc->priv->have_events, FALSE);
    }
    GST_OBJECT_UNLOCK (basesrc);
  }
  GST_LIVE_SIGNAL (basesrc);
  GST_LIVE_UNLOCK (basesrc);

  return TRUE;
}

/* the purpose of this function is to make sure that a live source blocks in the
 * LIVE lock or leaves the LIVE lock and continues playing. */
static gboolean
gst_base_src_set_playing (GstBaseSrc * basesrc, gboolean live_play)
{
  GstBaseSrcClass *bclass;

  bclass = GST_BASE_SRC_GET_CLASS (basesrc);

  /* unlock subclasses locked in ::create, we only do this when we stop playing. */
  if (!live_play) {
    GST_DEBUG_OBJECT (basesrc, "unlock");
    if (bclass->unlock)
      bclass->unlock (basesrc);
  }

  /* we are now able to grab the LIVE lock, when we get it, we can be
   * waiting for PLAYING while blocked in the LIVE cond or we can be waiting
   * for the clock. */
  GST_LIVE_LOCK (basesrc);
  GST_DEBUG_OBJECT (basesrc, "unschedule clock");

  /* unblock clock sync (if any) */
  if (basesrc->clock_id)
    gst_clock_id_unschedule (basesrc->clock_id);

  /* configure what to do when we get to the LIVE lock. */
  GST_DEBUG_OBJECT (basesrc, "live running %d", live_play);
  basesrc->live_running = live_play;

  if (live_play) {
    gboolean start;

    /* clear our unlock request when going to PLAYING */
    GST_DEBUG_OBJECT (basesrc, "unlock stop");
    if (bclass->unlock_stop)
      bclass->unlock_stop (basesrc);

    /* for live sources we restart the timestamp correction */
    basesrc->priv->latency = -1;
    /* have to restart the task in case it stopped because of the unlock when
     * we went to PAUSED. Only do this if we operating in push mode. */
    GST_OBJECT_LOCK (basesrc->srcpad);
    start = (GST_PAD_MODE (basesrc->srcpad) == GST_PAD_MODE_PUSH);
    GST_OBJECT_UNLOCK (basesrc->srcpad);
    if (start)
      gst_pad_start_task (basesrc->srcpad, (GstTaskFunction) gst_base_src_loop,
          basesrc->srcpad, NULL);
    GST_DEBUG_OBJECT (basesrc, "signal");
    GST_LIVE_SIGNAL (basesrc);
  }
  GST_LIVE_UNLOCK (basesrc);

  return TRUE;
}

static gboolean
gst_base_src_activate_push (GstPad * pad, GstObject * parent, gboolean active)
{
  GstBaseSrc *basesrc;

  basesrc = GST_BASE_SRC (parent);

  /* prepare subclass first */
  if (active) {
    GST_DEBUG_OBJECT (basesrc, "Activating in push mode");

    if (G_UNLIKELY (!basesrc->can_activate_push))
      goto no_push_activation;

    if (G_UNLIKELY (!gst_base_src_start (basesrc)))
      goto error_start;
  } else {
    GST_DEBUG_OBJECT (basesrc, "Deactivating in push mode");
    /* now we can stop the source */
    if (G_UNLIKELY (!gst_base_src_stop (basesrc)))
      goto error_stop;
  }
  return TRUE;

  /* ERRORS */
no_push_activation:
  {
    GST_WARNING_OBJECT (basesrc, "Subclass disabled push-mode activation");
    return FALSE;
  }
error_start:
  {
    GST_WARNING_OBJECT (basesrc, "Failed to start in push mode");
    return FALSE;
  }
error_stop:
  {
    GST_DEBUG_OBJECT (basesrc, "Failed to stop in push mode");
    return FALSE;
  }
}

static gboolean
gst_base_src_activate_pull (GstPad * pad, GstObject * parent, gboolean active)
{
  GstBaseSrc *basesrc;

  basesrc = GST_BASE_SRC (parent);

  /* prepare subclass first */
  if (active) {
    GST_DEBUG_OBJECT (basesrc, "Activating in pull mode");
    if (G_UNLIKELY (!gst_base_src_start (basesrc)))
      goto error_start;
  } else {
    GST_DEBUG_OBJECT (basesrc, "Deactivating in pull mode");
    if (G_UNLIKELY (!gst_base_src_stop (basesrc)))
      goto error_stop;
  }
  return TRUE;

  /* ERRORS */
error_start:
  {
    GST_ERROR_OBJECT (basesrc, "Failed to start in pull mode");
    return FALSE;
  }
error_stop:
  {
    GST_ERROR_OBJECT (basesrc, "Failed to stop in pull mode");
    return FALSE;
  }
}

static gboolean
gst_base_src_activate_mode (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active)
{
  gboolean res;
  GstBaseSrc *src = GST_BASE_SRC (parent);

  src->priv->stream_start_pending = FALSE;

  GST_DEBUG_OBJECT (pad, "activating in mode %d", mode);

  switch (mode) {
    case GST_PAD_MODE_PULL:
      res = gst_base_src_activate_pull (pad, parent, active);
      break;
    case GST_PAD_MODE_PUSH:
      src->priv->stream_start_pending = active;
      res = gst_base_src_activate_push (pad, parent, active);
      break;
    default:
      GST_LOG_OBJECT (pad, "unknown activation mode %d", mode);
      res = FALSE;
      break;
  }
  return res;
}


static GstStateChangeReturn
gst_base_src_change_state (GstElement * element, GstStateChange transition)
{
  GstBaseSrc *basesrc;
  GstStateChangeReturn result;
  gboolean no_preroll = FALSE;

  basesrc = GST_BASE_SRC (element);

  switch (transition) {
    case GST_STATE_CHANGE_NULL_TO_READY:
      break;
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      no_preroll = gst_base_src_is_live (basesrc);
      break;
    case GST_STATE_CHANGE_PAUSED_TO_PLAYING:
      GST_DEBUG_OBJECT (basesrc, "PAUSED->PLAYING");
      if (gst_base_src_is_live (basesrc)) {
        /* now we can start playback */
        gst_base_src_set_playing (basesrc, TRUE);
      }
      break;
    default:
      break;
  }

  if ((result =
          GST_ELEMENT_CLASS (parent_class)->change_state (element,
              transition)) == GST_STATE_CHANGE_FAILURE)
    goto failure;

  switch (transition) {
    case GST_STATE_CHANGE_PLAYING_TO_PAUSED:
      GST_DEBUG_OBJECT (basesrc, "PLAYING->PAUSED");
      if (gst_base_src_is_live (basesrc)) {
        /* make sure we block in the live lock in PAUSED */
        gst_base_src_set_playing (basesrc, FALSE);
        no_preroll = TRUE;
      }
      break;
    case GST_STATE_CHANGE_PAUSED_TO_READY:
    {
      /* we don't need to unblock anything here, the pad deactivation code
       * already did this */
      if (g_atomic_int_get (&basesrc->priv->has_pending_eos)) {
        GST_OBJECT_LOCK (basesrc);
        CLEAR_PENDING_EOS (basesrc);
        GST_OBJECT_UNLOCK (basesrc);
      }
      gst_event_replace (&basesrc->pending_seek, NULL);
      break;
    }
    case GST_STATE_CHANGE_READY_TO_NULL:
      break;
    default:
      break;
  }

  if (no_preroll && result == GST_STATE_CHANGE_SUCCESS)
    result = GST_STATE_CHANGE_NO_PREROLL;

  return result;

  /* ERRORS */
failure:
  {
    GST_DEBUG_OBJECT (basesrc, "parent failed state change");
    return result;
  }
}

/**
 * gst_base_src_get_buffer_pool:
 * @src: a #GstBaseSrc
 *
 * Returns: (transfer full): the instance of the #GstBufferPool used
 * by the src; free it after use it
 */
GstBufferPool *
gst_base_src_get_buffer_pool (GstBaseSrc * src)
{
  g_return_val_if_fail (GST_IS_BASE_SRC (src), NULL);

  if (src->priv->pool)
    return gst_object_ref (src->priv->pool);

  return NULL;
}

/**
 * gst_base_src_get_allocator:
 * @src: a #GstBaseSrc
 * @allocator: (out) (allow-none) (transfer full): the #GstAllocator
 * used
 * @params: (out) (allow-none) (transfer full): the
 * #GstAllocationParams of @allocator
 *
 * Lets #GstBaseSrc sub-classes to know the memory @allocator
 * used by the base class and its @params.
 *
 * Unref the @allocator after use it.
 */
void
gst_base_src_get_allocator (GstBaseSrc * src,
    GstAllocator ** allocator, GstAllocationParams * params)
{
  g_return_if_fail (GST_IS_BASE_SRC (src));

  if (allocator)
    *allocator = src->priv->allocator ?
        gst_object_ref (src->priv->allocator) : NULL;

  if (params)
    *params = src->priv->params;
}
