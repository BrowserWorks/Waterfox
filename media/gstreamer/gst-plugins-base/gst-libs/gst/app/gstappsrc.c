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
 * SECTION:gstappsrc
 * @short_description: Easy way for applications to inject buffers into a
 *     pipeline
 * @see_also: #GstBaseSrc, appsink
 *
 * The appsrc element can be used by applications to insert data into a
 * GStreamer pipeline. Unlike most GStreamer elements, Appsrc provides
 * external API functions.
 *
 * appsrc can be used by linking with the libgstapp library to access the
 * methods directly or by using the appsrc action signals.
 *
 * Before operating appsrc, the caps property must be set to a fixed caps
 * describing the format of the data that will be pushed with appsrc. An
 * exception to this is when pushing buffers with unknown caps, in which case no
 * caps should be set. This is typically true of file-like sources that push raw
 * byte buffers.
 *
 * The main way of handing data to the appsrc element is by calling the
 * gst_app_src_push_buffer() method or by emitting the push-buffer action signal.
 * This will put the buffer onto a queue from which appsrc will read from in its
 * streaming thread. It is important to note that data transport will not happen
 * from the thread that performed the push-buffer call.
 *
 * The "max-bytes" property controls how much data can be queued in appsrc
 * before appsrc considers the queue full. A filled internal queue will always
 * signal the "enough-data" signal, which signals the application that it should
 * stop pushing data into appsrc. The "block" property will cause appsrc to
 * block the push-buffer method until free data becomes available again.
 *
 * When the internal queue is running out of data, the "need-data" signal is
 * emitted, which signals the application that it should start pushing more data
 * into appsrc.
 *
 * In addition to the "need-data" and "enough-data" signals, appsrc can emit the
 * "seek-data" signal when the "stream-mode" property is set to "seekable" or
 * "random-access". The signal argument will contain the new desired position in
 * the stream expressed in the unit set with the "format" property. After
 * receiving the seek-data signal, the application should push-buffers from the
 * new position.
 *
 * These signals allow the application to operate the appsrc in two different
 * ways:
 *
 * The push model, in which the application repeatedly calls the push-buffer method
 * with a new buffer. Optionally, the queue size in the appsrc can be controlled
 * with the enough-data and need-data signals by respectively stopping/starting
 * the push-buffer calls. This is a typical mode of operation for the
 * stream-type "stream" and "seekable". Use this model when implementing various
 * network protocols or hardware devices.
 *
 * The pull model where the need-data signal triggers the next push-buffer call.
 * This mode is typically used in the "random-access" stream-type. Use this
 * model for file access or other randomly accessable sources. In this mode, a
 * buffer of exactly the amount of bytes given by the need-data signal should be
 * pushed into appsrc.
 *
 * In all modes, the size property on appsrc should contain the total stream
 * size in bytes. Setting this property is mandatory in the random-access mode.
 * For the stream and seekable modes, setting this property is optional but
 * recommended.
 *
 * When the application is finished pushing data into appsrc, it should call
 * gst_app_src_end_of_stream() or emit the end-of-stream action signal. After
 * this call, no more buffers can be pushed into appsrc until a flushing seek
 * happened or the state of the appsrc has gone through READY.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/gst.h>
#include <gst/base/gstbasesrc.h>

#include <string.h>

#include "gstapp-marshal.h"
#include "gstappsrc.h"

struct _GstAppSrcPrivate
{
  GCond cond;
  GMutex mutex;
  GQueue *queue;

  GstCaps *caps;
  gint64 size;
  GstAppStreamType stream_type;
  guint64 max_bytes;
  GstFormat format;
  gboolean block;
  gchar *uri;
  gboolean new_caps;

  gboolean flushing;
  gboolean started;
  gboolean is_eos;
  guint64 queued_bytes;
  guint64 offset;
  GstAppStreamType current_type;

  guint64 min_latency;
  guint64 max_latency;
  gboolean emit_signals;
  guint min_percent;

  GstAppSrcCallbacks callbacks;
  gpointer user_data;
  GDestroyNotify notify;
};

GST_DEBUG_CATEGORY_STATIC (app_src_debug);
#define GST_CAT_DEFAULT app_src_debug

enum
{
  /* signals */
  SIGNAL_NEED_DATA,
  SIGNAL_ENOUGH_DATA,
  SIGNAL_SEEK_DATA,

  /* actions */
  SIGNAL_PUSH_BUFFER,
  SIGNAL_END_OF_STREAM,

  LAST_SIGNAL
};

#define DEFAULT_PROP_SIZE          -1
#define DEFAULT_PROP_STREAM_TYPE   GST_APP_STREAM_TYPE_STREAM
#define DEFAULT_PROP_MAX_BYTES     200000
#define DEFAULT_PROP_FORMAT        GST_FORMAT_BYTES
#define DEFAULT_PROP_BLOCK         FALSE
#define DEFAULT_PROP_IS_LIVE       FALSE
#define DEFAULT_PROP_MIN_LATENCY   -1
#define DEFAULT_PROP_MAX_LATENCY   -1
#define DEFAULT_PROP_EMIT_SIGNALS  TRUE
#define DEFAULT_PROP_MIN_PERCENT   0
#define DEFAULT_PROP_CURRENT_LEVEL_BYTES   0

enum
{
  PROP_0,
  PROP_CAPS,
  PROP_SIZE,
  PROP_STREAM_TYPE,
  PROP_MAX_BYTES,
  PROP_FORMAT,
  PROP_BLOCK,
  PROP_IS_LIVE,
  PROP_MIN_LATENCY,
  PROP_MAX_LATENCY,
  PROP_EMIT_SIGNALS,
  PROP_MIN_PERCENT,
  PROP_CURRENT_LEVEL_BYTES,
  PROP_LAST
};

static GstStaticPadTemplate gst_app_src_template =
GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

GType
gst_app_stream_type_get_type (void)
{
  static volatile gsize stream_type_type = 0;
  static const GEnumValue stream_type[] = {
    {GST_APP_STREAM_TYPE_STREAM, "GST_APP_STREAM_TYPE_STREAM", "stream"},
    {GST_APP_STREAM_TYPE_SEEKABLE, "GST_APP_STREAM_TYPE_SEEKABLE", "seekable"},
    {GST_APP_STREAM_TYPE_RANDOM_ACCESS, "GST_APP_STREAM_TYPE_RANDOM_ACCESS",
        "random-access"},
    {0, NULL, NULL}
  };

  if (g_once_init_enter (&stream_type_type)) {
    GType tmp = g_enum_register_static ("GstAppStreamType", stream_type);
    g_once_init_leave (&stream_type_type, tmp);
  }

  return (GType) stream_type_type;
}

static void gst_app_src_uri_handler_init (gpointer g_iface,
    gpointer iface_data);

static void gst_app_src_dispose (GObject * object);
static void gst_app_src_finalize (GObject * object);

static void gst_app_src_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_app_src_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

static gboolean gst_app_src_send_event (GstElement * element, GstEvent * event);

static void gst_app_src_set_latencies (GstAppSrc * appsrc,
    gboolean do_min, guint64 min, gboolean do_max, guint64 max);

static gboolean gst_app_src_negotiate (GstBaseSrc * basesrc);
static GstCaps *gst_app_src_internal_get_caps (GstBaseSrc * bsrc,
    GstCaps * filter);
static GstFlowReturn gst_app_src_create (GstBaseSrc * bsrc, guint64 offset,
    guint size, GstBuffer ** buf);
static gboolean gst_app_src_start (GstBaseSrc * bsrc);
static gboolean gst_app_src_stop (GstBaseSrc * bsrc);
static gboolean gst_app_src_unlock (GstBaseSrc * bsrc);
static gboolean gst_app_src_unlock_stop (GstBaseSrc * bsrc);
static gboolean gst_app_src_do_seek (GstBaseSrc * src, GstSegment * segment);
static gboolean gst_app_src_is_seekable (GstBaseSrc * src);
static gboolean gst_app_src_do_get_size (GstBaseSrc * src, guint64 * size);
static gboolean gst_app_src_query (GstBaseSrc * src, GstQuery * query);

static GstFlowReturn gst_app_src_push_buffer_action (GstAppSrc * appsrc,
    GstBuffer * buffer);

static guint gst_app_src_signals[LAST_SIGNAL] = { 0 };

#define gst_app_src_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstAppSrc, gst_app_src, GST_TYPE_BASE_SRC,
    G_IMPLEMENT_INTERFACE (GST_TYPE_URI_HANDLER, gst_app_src_uri_handler_init));

static void
gst_app_src_class_init (GstAppSrcClass * klass)
{
  GObjectClass *gobject_class = (GObjectClass *) klass;
  GstElementClass *element_class = (GstElementClass *) klass;
  GstBaseSrcClass *basesrc_class = (GstBaseSrcClass *) klass;

  GST_DEBUG_CATEGORY_INIT (app_src_debug, "appsrc", 0, "appsrc element");

  gobject_class->dispose = gst_app_src_dispose;
  gobject_class->finalize = gst_app_src_finalize;

  gobject_class->set_property = gst_app_src_set_property;
  gobject_class->get_property = gst_app_src_get_property;

  /**
   * GstAppSrc::caps:
   *
   * The GstCaps that will negotiated downstream and will be put
   * on outgoing buffers.
   */
  g_object_class_install_property (gobject_class, PROP_CAPS,
      g_param_spec_boxed ("caps", "Caps",
          "The allowed caps for the src pad", GST_TYPE_CAPS,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstAppSrc::format:
   *
   * The format to use for segment events. When the source is producing
   * timestamped buffers this property should be set to GST_FORMAT_TIME.
   */
  g_object_class_install_property (gobject_class, PROP_FORMAT,
      g_param_spec_enum ("format", "Format",
          "The format of the segment events and seek", GST_TYPE_FORMAT,
          DEFAULT_PROP_FORMAT, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstAppSrc::size:
   *
   * The total size in bytes of the data stream. If the total size is known, it
   * is recommended to configure it with this property.
   */
  g_object_class_install_property (gobject_class, PROP_SIZE,
      g_param_spec_int64 ("size", "Size",
          "The size of the data stream in bytes (-1 if unknown)",
          -1, G_MAXINT64, DEFAULT_PROP_SIZE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstAppSrc::stream-type:
   *
   * The type of stream that this source is producing.  For seekable streams the
   * application should connect to the seek-data signal.
   */
  g_object_class_install_property (gobject_class, PROP_STREAM_TYPE,
      g_param_spec_enum ("stream-type", "Stream Type",
          "the type of the stream", GST_TYPE_APP_STREAM_TYPE,
          DEFAULT_PROP_STREAM_TYPE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstAppSrc::max-bytes:
   *
   * The maximum amount of bytes that can be queued internally.
   * After the maximum amount of bytes are queued, appsrc will emit the
   * "enough-data" signal.
   */
  g_object_class_install_property (gobject_class, PROP_MAX_BYTES,
      g_param_spec_uint64 ("max-bytes", "Max bytes",
          "The maximum number of bytes to queue internally (0 = unlimited)",
          0, G_MAXUINT64, DEFAULT_PROP_MAX_BYTES,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstAppSrc::block:
   *
   * When max-bytes are queued and after the enough-data signal has been emitted,
   * block any further push-buffer calls until the amount of queued bytes drops
   * below the max-bytes limit.
   */
  g_object_class_install_property (gobject_class, PROP_BLOCK,
      g_param_spec_boolean ("block", "Block",
          "Block push-buffer when max-bytes are queued",
          DEFAULT_PROP_BLOCK, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstAppSrc::is-live:
   *
   * Instruct the source to behave like a live source. This includes that it
   * will only push out buffers in the PLAYING state.
   */
  g_object_class_install_property (gobject_class, PROP_IS_LIVE,
      g_param_spec_boolean ("is-live", "Is Live",
          "Whether to act as a live source",
          DEFAULT_PROP_IS_LIVE, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstAppSrc::min-latency:
   *
   * The minimum latency of the source. A value of -1 will use the default
   * latency calculations of #GstBaseSrc.
   */
  g_object_class_install_property (gobject_class, PROP_MIN_LATENCY,
      g_param_spec_int64 ("min-latency", "Min Latency",
          "The minimum latency (-1 = default)",
          -1, G_MAXINT64, DEFAULT_PROP_MIN_LATENCY,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstAppSrc::max-latency:
   *
   * The maximum latency of the source. A value of -1 means an unlimited amout
   * of latency.
   */
  g_object_class_install_property (gobject_class, PROP_MAX_LATENCY,
      g_param_spec_int64 ("max-latency", "Max Latency",
          "The maximum latency (-1 = unlimited)",
          -1, G_MAXINT64, DEFAULT_PROP_MAX_LATENCY,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstAppSrc::emit-signals:
   *
   * Make appsrc emit the "need-data", "enough-data" and "seek-data" signals.
   * This option is by default enabled for backwards compatibility reasons but
   * can disabled when needed because signal emission is expensive.
   */
  g_object_class_install_property (gobject_class, PROP_EMIT_SIGNALS,
      g_param_spec_boolean ("emit-signals", "Emit signals",
          "Emit need-data, enough-data and seek-data signals",
          DEFAULT_PROP_EMIT_SIGNALS,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstAppSrc::empty-percent:
   *
   * Make appsrc emit the "need-data" signal when the amount of bytes in the
   * queue drops below this percentage of max-bytes.
   */
  g_object_class_install_property (gobject_class, PROP_MIN_PERCENT,
      g_param_spec_uint ("min-percent", "Min Percent",
          "Emit need-data when queued bytes drops below this percent of max-bytes",
          0, 100, DEFAULT_PROP_MIN_PERCENT,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstAppSrc::current-level-bytes:
   *
   * The number of currently queued bytes inside appsrc.
   *
   * Since: 1.2
   */
  g_object_class_install_property (gobject_class, PROP_CURRENT_LEVEL_BYTES,
      g_param_spec_uint64 ("current-level-bytes", "Current Level Bytes",
          "The number of currently queued bytes",
          0, G_MAXUINT64, DEFAULT_PROP_CURRENT_LEVEL_BYTES,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));


  /**
   * GstAppSrc::need-data:
   * @appsrc: the appsrc element that emitted the signal
   * @length: the amount of bytes needed.
   *
   * Signal that the source needs more data. In the callback or from another
   * thread you should call push-buffer or end-of-stream.
   *
   * @length is just a hint and when it is set to -1, any number of bytes can be
   * pushed into @appsrc.
   *
   * You can call push-buffer multiple times until the enough-data signal is
   * fired.
   */
  gst_app_src_signals[SIGNAL_NEED_DATA] =
      g_signal_new ("need-data", G_TYPE_FROM_CLASS (klass), G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstAppSrcClass, need_data),
      NULL, NULL, __gst_app_marshal_VOID__UINT, G_TYPE_NONE, 1, G_TYPE_UINT);

  /**
   * GstAppSrc::enough-data:
   * @appsrc: the appsrc element that emitted the signal
   *
   * Signal that the source has enough data. It is recommended that the
   * application stops calling push-buffer until the need-data signal is
   * emitted again to avoid excessive buffer queueing.
   */
  gst_app_src_signals[SIGNAL_ENOUGH_DATA] =
      g_signal_new ("enough-data", G_TYPE_FROM_CLASS (klass), G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstAppSrcClass, enough_data),
      NULL, NULL, g_cclosure_marshal_VOID__VOID, G_TYPE_NONE, 0, G_TYPE_NONE);

  /**
   * GstAppSrc::seek-data:
   * @appsrc: the appsrc element that emitted the signal
   * @offset: the offset to seek to
   *
   * Seek to the given offset. The next push-buffer should produce buffers from
   * the new @offset.
   * This callback is only called for seekable stream types.
   *
   * Returns: %TRUE if the seek succeeded.
   */
  gst_app_src_signals[SIGNAL_SEEK_DATA] =
      g_signal_new ("seek-data", G_TYPE_FROM_CLASS (klass), G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstAppSrcClass, seek_data),
      NULL, NULL, __gst_app_marshal_BOOLEAN__UINT64, G_TYPE_BOOLEAN, 1,
      G_TYPE_UINT64);

   /**
    * GstAppSrc::push-buffer:
    * @appsrc: the appsrc
    * @buffer: a buffer to push
    *
    * Adds a buffer to the queue of buffers that the appsrc element will
    * push to its source pad. This function does not take ownership of the
    * buffer so the buffer needs to be unreffed after calling this function.
    *
    * When the block property is TRUE, this function can block until free space
    * becomes available in the queue.
    */
  gst_app_src_signals[SIGNAL_PUSH_BUFFER] =
      g_signal_new ("push-buffer", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION, G_STRUCT_OFFSET (GstAppSrcClass,
          push_buffer), NULL, NULL, __gst_app_marshal_ENUM__BOXED,
      GST_TYPE_FLOW_RETURN, 1, GST_TYPE_BUFFER);

   /**
    * GstAppSrc::end-of-stream:
    * @appsrc: the appsrc
    *
    * Notify @appsrc that no more buffer are available.
    */
  gst_app_src_signals[SIGNAL_END_OF_STREAM] =
      g_signal_new ("end-of-stream", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION, G_STRUCT_OFFSET (GstAppSrcClass,
          end_of_stream), NULL, NULL, __gst_app_marshal_ENUM__VOID,
      GST_TYPE_FLOW_RETURN, 0, G_TYPE_NONE);

  gst_element_class_set_static_metadata (element_class, "AppSrc",
      "Generic/Source", "Allow the application to feed buffers to a pipeline",
      "David Schleef <ds@schleef.org>, Wim Taymans <wim.taymans@gmail.com>");

  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&gst_app_src_template));

  element_class->send_event = gst_app_src_send_event;

  basesrc_class->negotiate = gst_app_src_negotiate;
  basesrc_class->get_caps = gst_app_src_internal_get_caps;
  basesrc_class->create = gst_app_src_create;
  basesrc_class->start = gst_app_src_start;
  basesrc_class->stop = gst_app_src_stop;
  basesrc_class->unlock = gst_app_src_unlock;
  basesrc_class->unlock_stop = gst_app_src_unlock_stop;
  basesrc_class->do_seek = gst_app_src_do_seek;
  basesrc_class->is_seekable = gst_app_src_is_seekable;
  basesrc_class->get_size = gst_app_src_do_get_size;
  basesrc_class->get_size = gst_app_src_do_get_size;
  basesrc_class->query = gst_app_src_query;

  klass->push_buffer = gst_app_src_push_buffer_action;
  klass->end_of_stream = gst_app_src_end_of_stream;

  g_type_class_add_private (klass, sizeof (GstAppSrcPrivate));
}

static void
gst_app_src_init (GstAppSrc * appsrc)
{
  GstAppSrcPrivate *priv;

  priv = appsrc->priv = G_TYPE_INSTANCE_GET_PRIVATE (appsrc, GST_TYPE_APP_SRC,
      GstAppSrcPrivate);

  g_mutex_init (&priv->mutex);
  g_cond_init (&priv->cond);
  priv->queue = g_queue_new ();

  priv->size = DEFAULT_PROP_SIZE;
  priv->stream_type = DEFAULT_PROP_STREAM_TYPE;
  priv->max_bytes = DEFAULT_PROP_MAX_BYTES;
  priv->format = DEFAULT_PROP_FORMAT;
  priv->block = DEFAULT_PROP_BLOCK;
  priv->min_latency = DEFAULT_PROP_MIN_LATENCY;
  priv->max_latency = DEFAULT_PROP_MAX_LATENCY;
  priv->emit_signals = DEFAULT_PROP_EMIT_SIGNALS;
  priv->min_percent = DEFAULT_PROP_MIN_PERCENT;

  gst_base_src_set_live (GST_BASE_SRC (appsrc), DEFAULT_PROP_IS_LIVE);
}

static void
gst_app_src_flush_queued (GstAppSrc * src)
{
  GstBuffer *buf;
  GstAppSrcPrivate *priv = src->priv;

  while ((buf = g_queue_pop_head (priv->queue)))
    gst_buffer_unref (buf);
  priv->queued_bytes = 0;
}

static void
gst_app_src_dispose (GObject * obj)
{
  GstAppSrc *appsrc = GST_APP_SRC_CAST (obj);
  GstAppSrcPrivate *priv = appsrc->priv;

  GST_OBJECT_LOCK (appsrc);
  if (priv->caps) {
    gst_caps_unref (priv->caps);
    priv->caps = NULL;
  }
  if (priv->notify) {
    priv->notify (priv->user_data);
  }
  priv->user_data = NULL;
  priv->notify = NULL;

  GST_OBJECT_UNLOCK (appsrc);
  gst_app_src_flush_queued (appsrc);

  G_OBJECT_CLASS (parent_class)->dispose (obj);
}

static void
gst_app_src_finalize (GObject * obj)
{
  GstAppSrc *appsrc = GST_APP_SRC_CAST (obj);
  GstAppSrcPrivate *priv = appsrc->priv;

  g_mutex_clear (&priv->mutex);
  g_cond_clear (&priv->cond);
  g_queue_free (priv->queue);

  g_free (priv->uri);

  G_OBJECT_CLASS (parent_class)->finalize (obj);
}

static GstCaps *
gst_app_src_internal_get_caps (GstBaseSrc * bsrc, GstCaps * filter)
{
  GstAppSrc *appsrc = GST_APP_SRC (bsrc);
  GstCaps *caps;

  GST_OBJECT_LOCK (appsrc);
  if ((caps = appsrc->priv->caps))
    gst_caps_ref (caps);
  GST_OBJECT_UNLOCK (appsrc);

  if (filter) {
    if (caps) {
      GstCaps *intersection =
          gst_caps_intersect_full (filter, caps, GST_CAPS_INTERSECT_FIRST);
      gst_caps_unref (caps);
      caps = intersection;
    } else {
      caps = gst_caps_ref (filter);
    }
  }

  GST_DEBUG_OBJECT (appsrc, "caps: %" GST_PTR_FORMAT, caps);
  return caps;
}

static void
gst_app_src_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstAppSrc *appsrc = GST_APP_SRC_CAST (object);
  GstAppSrcPrivate *priv = appsrc->priv;

  switch (prop_id) {
    case PROP_CAPS:
      gst_app_src_set_caps (appsrc, gst_value_get_caps (value));
      break;
    case PROP_SIZE:
      gst_app_src_set_size (appsrc, g_value_get_int64 (value));
      break;
    case PROP_STREAM_TYPE:
      gst_app_src_set_stream_type (appsrc, g_value_get_enum (value));
      break;
    case PROP_MAX_BYTES:
      gst_app_src_set_max_bytes (appsrc, g_value_get_uint64 (value));
      break;
    case PROP_FORMAT:
      priv->format = g_value_get_enum (value);
      break;
    case PROP_BLOCK:
      priv->block = g_value_get_boolean (value);
      break;
    case PROP_IS_LIVE:
      gst_base_src_set_live (GST_BASE_SRC (appsrc),
          g_value_get_boolean (value));
      break;
    case PROP_MIN_LATENCY:
      gst_app_src_set_latencies (appsrc, TRUE, g_value_get_int64 (value),
          FALSE, -1);
      break;
    case PROP_MAX_LATENCY:
      gst_app_src_set_latencies (appsrc, FALSE, -1, TRUE,
          g_value_get_int64 (value));
      break;
    case PROP_EMIT_SIGNALS:
      gst_app_src_set_emit_signals (appsrc, g_value_get_boolean (value));
      break;
    case PROP_MIN_PERCENT:
      priv->min_percent = g_value_get_uint (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_app_src_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstAppSrc *appsrc = GST_APP_SRC_CAST (object);
  GstAppSrcPrivate *priv = appsrc->priv;

  switch (prop_id) {
    case PROP_CAPS:
      g_value_take_boxed (value, gst_app_src_get_caps (appsrc));
      break;
    case PROP_SIZE:
      g_value_set_int64 (value, gst_app_src_get_size (appsrc));
      break;
    case PROP_STREAM_TYPE:
      g_value_set_enum (value, gst_app_src_get_stream_type (appsrc));
      break;
    case PROP_MAX_BYTES:
      g_value_set_uint64 (value, gst_app_src_get_max_bytes (appsrc));
      break;
    case PROP_FORMAT:
      g_value_set_enum (value, priv->format);
      break;
    case PROP_BLOCK:
      g_value_set_boolean (value, priv->block);
      break;
    case PROP_IS_LIVE:
      g_value_set_boolean (value, gst_base_src_is_live (GST_BASE_SRC (appsrc)));
      break;
    case PROP_MIN_LATENCY:
    {
      guint64 min;

      gst_app_src_get_latency (appsrc, &min, NULL);
      g_value_set_int64 (value, min);
      break;
    }
    case PROP_MAX_LATENCY:
    {
      guint64 max;

      gst_app_src_get_latency (appsrc, NULL, &max);
      g_value_set_int64 (value, max);
      break;
    }
    case PROP_EMIT_SIGNALS:
      g_value_set_boolean (value, gst_app_src_get_emit_signals (appsrc));
      break;
    case PROP_MIN_PERCENT:
      g_value_set_uint (value, priv->min_percent);
      break;
    case PROP_CURRENT_LEVEL_BYTES:
      g_value_set_uint64 (value, gst_app_src_get_current_level_bytes (appsrc));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static gboolean
gst_app_src_send_event (GstElement * element, GstEvent * event)
{
  GstAppSrc *appsrc = GST_APP_SRC_CAST (element);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_FLUSH_STOP:
      gst_app_src_flush_queued (appsrc);
      break;
    default:
      break;
  }

  return GST_CALL_PARENT_WITH_DEFAULT (GST_ELEMENT_CLASS, send_event, (element,
          event), FALSE);
}

static gboolean
gst_app_src_unlock (GstBaseSrc * bsrc)
{
  GstAppSrc *appsrc = GST_APP_SRC_CAST (bsrc);
  GstAppSrcPrivate *priv = appsrc->priv;

  g_mutex_lock (&priv->mutex);
  GST_DEBUG_OBJECT (appsrc, "unlock start");
  priv->flushing = TRUE;
  g_cond_broadcast (&priv->cond);
  g_mutex_unlock (&priv->mutex);

  return TRUE;
}

static gboolean
gst_app_src_unlock_stop (GstBaseSrc * bsrc)
{
  GstAppSrc *appsrc = GST_APP_SRC_CAST (bsrc);
  GstAppSrcPrivate *priv = appsrc->priv;

  g_mutex_lock (&priv->mutex);
  GST_DEBUG_OBJECT (appsrc, "unlock stop");
  priv->flushing = FALSE;
  g_cond_broadcast (&priv->cond);
  g_mutex_unlock (&priv->mutex);

  return TRUE;
}

static gboolean
gst_app_src_start (GstBaseSrc * bsrc)
{
  GstAppSrc *appsrc = GST_APP_SRC_CAST (bsrc);
  GstAppSrcPrivate *priv = appsrc->priv;

  g_mutex_lock (&priv->mutex);
  GST_DEBUG_OBJECT (appsrc, "starting");
  priv->new_caps = FALSE;
  priv->started = TRUE;
  /* set the offset to -1 so that we always do a first seek. This is only used
   * in random-access mode. */
  priv->offset = -1;
  priv->flushing = FALSE;
  g_mutex_unlock (&priv->mutex);

  gst_base_src_set_format (bsrc, priv->format);

  return TRUE;
}

static gboolean
gst_app_src_stop (GstBaseSrc * bsrc)
{
  GstAppSrc *appsrc = GST_APP_SRC_CAST (bsrc);
  GstAppSrcPrivate *priv = appsrc->priv;

  g_mutex_lock (&priv->mutex);
  GST_DEBUG_OBJECT (appsrc, "stopping");
  priv->is_eos = FALSE;
  priv->flushing = TRUE;
  priv->started = FALSE;
  gst_app_src_flush_queued (appsrc);
  g_cond_broadcast (&priv->cond);
  g_mutex_unlock (&priv->mutex);

  return TRUE;
}

static gboolean
gst_app_src_is_seekable (GstBaseSrc * src)
{
  GstAppSrc *appsrc = GST_APP_SRC_CAST (src);
  GstAppSrcPrivate *priv = appsrc->priv;
  gboolean res = FALSE;

  switch (priv->stream_type) {
    case GST_APP_STREAM_TYPE_STREAM:
      break;
    case GST_APP_STREAM_TYPE_SEEKABLE:
    case GST_APP_STREAM_TYPE_RANDOM_ACCESS:
      res = TRUE;
      break;
  }
  return res;
}

static gboolean
gst_app_src_do_get_size (GstBaseSrc * src, guint64 * size)
{
  GstAppSrc *appsrc = GST_APP_SRC_CAST (src);

  *size = gst_app_src_get_size (appsrc);

  return TRUE;
}

static gboolean
gst_app_src_query (GstBaseSrc * src, GstQuery * query)
{
  GstAppSrc *appsrc = GST_APP_SRC_CAST (src);
  GstAppSrcPrivate *priv = appsrc->priv;
  gboolean res;

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_LATENCY:
    {
      GstClockTime min, max;
      gboolean live;

      /* Query the parent class for the defaults */
      res = gst_base_src_query_latency (src, &live, &min, &max);

      /* overwrite with our values when we need to */
      g_mutex_lock (&priv->mutex);
      if (priv->min_latency != -1)
        min = priv->min_latency;
      if (priv->max_latency != -1)
        max = priv->max_latency;
      g_mutex_unlock (&priv->mutex);

      gst_query_set_latency (query, live, min, max);
      break;
    }
    case GST_QUERY_SCHEDULING:
    {
      gst_query_set_scheduling (query, GST_SCHEDULING_FLAG_SEEKABLE, 1, -1, 0);
      gst_query_add_scheduling_mode (query, GST_PAD_MODE_PUSH);

      switch (priv->stream_type) {
        case GST_APP_STREAM_TYPE_STREAM:
        case GST_APP_STREAM_TYPE_SEEKABLE:
          break;
        case GST_APP_STREAM_TYPE_RANDOM_ACCESS:
          gst_query_add_scheduling_mode (query, GST_PAD_MODE_PULL);
          break;
      }
      res = TRUE;
      break;
    }
    default:
      res = GST_BASE_SRC_CLASS (parent_class)->query (src, query);
      break;
  }

  return res;
}

/* will be called in push mode */
static gboolean
gst_app_src_do_seek (GstBaseSrc * src, GstSegment * segment)
{
  GstAppSrc *appsrc = GST_APP_SRC_CAST (src);
  GstAppSrcPrivate *priv = appsrc->priv;
  gint64 desired_position;
  gboolean res = FALSE;

  desired_position = segment->position;

  GST_DEBUG_OBJECT (appsrc, "seeking to %" G_GINT64_FORMAT ", format %s",
      desired_position, gst_format_get_name (segment->format));

  /* no need to try to seek in streaming mode */
  if (priv->stream_type == GST_APP_STREAM_TYPE_STREAM)
    return TRUE;

  if (priv->callbacks.seek_data)
    res = priv->callbacks.seek_data (appsrc, desired_position, priv->user_data);
  else {
    gboolean emit;

    g_mutex_lock (&priv->mutex);
    emit = priv->emit_signals;
    g_mutex_unlock (&priv->mutex);

    if (emit)
      g_signal_emit (appsrc, gst_app_src_signals[SIGNAL_SEEK_DATA], 0,
          desired_position, &res);
  }

  if (res) {
    GST_DEBUG_OBJECT (appsrc, "flushing queue");
    gst_app_src_flush_queued (appsrc);
    priv->is_eos = FALSE;
  } else {
    GST_WARNING_OBJECT (appsrc, "seek failed");
  }

  return res;
}

/* must be called with the appsrc mutex */
static gboolean
gst_app_src_emit_seek (GstAppSrc * appsrc, guint64 offset)
{
  gboolean res = FALSE;
  gboolean emit;
  GstAppSrcPrivate *priv = appsrc->priv;

  emit = priv->emit_signals;
  g_mutex_unlock (&priv->mutex);

  GST_DEBUG_OBJECT (appsrc,
      "we are at %" G_GINT64_FORMAT ", seek to %" G_GINT64_FORMAT,
      priv->offset, offset);

  if (priv->callbacks.seek_data)
    res = priv->callbacks.seek_data (appsrc, offset, priv->user_data);
  else if (emit)
    g_signal_emit (appsrc, gst_app_src_signals[SIGNAL_SEEK_DATA], 0,
        offset, &res);

  g_mutex_lock (&priv->mutex);

  return res;
}

/* must be called with the appsrc mutex. After this call things can be
 * flushing */
static void
gst_app_src_emit_need_data (GstAppSrc * appsrc, guint size)
{
  gboolean emit;
  GstAppSrcPrivate *priv = appsrc->priv;

  emit = priv->emit_signals;
  g_mutex_unlock (&priv->mutex);

  /* we have no data, we need some. We fire the signal with the size hint. */
  if (priv->callbacks.need_data)
    priv->callbacks.need_data (appsrc, size, priv->user_data);
  else if (emit)
    g_signal_emit (appsrc, gst_app_src_signals[SIGNAL_NEED_DATA], 0, size,
        NULL);

  g_mutex_lock (&priv->mutex);
  /* we can be flushing now because we released the lock */
}

/* must be called with the appsrc mutex */
static gboolean
gst_app_src_do_negotiate (GstBaseSrc * basesrc)
{
  GstAppSrc *appsrc = GST_APP_SRC_CAST (basesrc);
  GstAppSrcPrivate *priv = appsrc->priv;
  gboolean result;
  GstCaps *caps;

  GST_OBJECT_LOCK (basesrc);
  caps = priv->caps ? gst_caps_ref (priv->caps) : NULL;
  GST_OBJECT_UNLOCK (basesrc);

  /* Avoid deadlock by unlocking mutex
   * otherwise we get deadlock between this and stream lock */
  g_mutex_unlock (&priv->mutex);
  if (caps) {
    result = gst_base_src_set_caps (basesrc, caps);
    gst_caps_unref (caps);
  } else {
    result = GST_BASE_SRC_CLASS (parent_class)->negotiate (basesrc);
  }
  g_mutex_lock (&priv->mutex);

  return result;
}

static gboolean
gst_app_src_negotiate (GstBaseSrc * basesrc)
{
  GstAppSrc *appsrc = GST_APP_SRC_CAST (basesrc);
  GstAppSrcPrivate *priv = appsrc->priv;
  gboolean result;

  g_mutex_lock (&priv->mutex);
  priv->new_caps = FALSE;
  result = gst_app_src_do_negotiate (basesrc);
  g_mutex_unlock (&priv->mutex);
  return result;
}

static GstFlowReturn
gst_app_src_create (GstBaseSrc * bsrc, guint64 offset, guint size,
    GstBuffer ** buf)
{
  GstAppSrc *appsrc = GST_APP_SRC_CAST (bsrc);
  GstAppSrcPrivate *priv = appsrc->priv;
  GstFlowReturn ret;

  GST_OBJECT_LOCK (appsrc);
  if (G_UNLIKELY (priv->size != bsrc->segment.duration &&
          bsrc->segment.format == GST_FORMAT_BYTES)) {
    GST_DEBUG_OBJECT (appsrc,
        "Size changed from %" G_GINT64_FORMAT " to %" G_GINT64_FORMAT,
        bsrc->segment.duration, priv->size);
    bsrc->segment.duration = priv->size;
    GST_OBJECT_UNLOCK (appsrc);

    gst_element_post_message (GST_ELEMENT (appsrc),
        gst_message_new_duration_changed (GST_OBJECT (appsrc)));
  } else {
    GST_OBJECT_UNLOCK (appsrc);
  }

  g_mutex_lock (&priv->mutex);
  /* check flushing first */
  if (G_UNLIKELY (priv->flushing))
    goto flushing;

  if (priv->stream_type == GST_APP_STREAM_TYPE_RANDOM_ACCESS) {
    /* if we are dealing with a random-access stream, issue a seek if the offset
     * changed. */
    if (G_UNLIKELY (priv->offset != offset)) {
      gboolean res;

      /* do the seek */
      res = gst_app_src_emit_seek (appsrc, offset);

      if (G_UNLIKELY (!res))
        /* failing to seek is fatal */
        goto seek_error;

      priv->offset = offset;
      priv->is_eos = FALSE;
    }
  }

  while (TRUE) {
    /* return data as long as we have some */
    if (!g_queue_is_empty (priv->queue)) {
      guint buf_size;

      if (priv->new_caps) {
        priv->new_caps = FALSE;
        gst_app_src_do_negotiate (bsrc);

        /* Lock has released so now may need
         *- flushing
         *- new caps change
         *- check queue has data */
        if (G_UNLIKELY (priv->flushing))
          goto flushing;
        /* Contiue checks caps and queue */
        continue;
      }
      *buf = g_queue_pop_head (priv->queue);
      buf_size = gst_buffer_get_size (*buf);

      GST_DEBUG_OBJECT (appsrc, "we have buffer %p of size %u", *buf, buf_size);

      priv->queued_bytes -= buf_size;

      /* only update the offset when in random_access mode */
      if (priv->stream_type == GST_APP_STREAM_TYPE_RANDOM_ACCESS)
        priv->offset += buf_size;

      /* signal that we removed an item */
      g_cond_broadcast (&priv->cond);

      /* see if we go lower than the empty-percent */
      if (priv->min_percent && priv->max_bytes) {
        if (priv->queued_bytes * 100 / priv->max_bytes <= priv->min_percent)
          /* ignore flushing state, we got a buffer and we will return it now.
           * Errors will be handled in the next round */
          gst_app_src_emit_need_data (appsrc, size);
      }
      ret = GST_FLOW_OK;
      break;
    } else {
      gst_app_src_emit_need_data (appsrc, size);

      /* we can be flushing now because we released the lock above */
      if (G_UNLIKELY (priv->flushing))
        goto flushing;

      /* if we have a buffer now, continue the loop and try to return it. In
       * random-access mode (where a buffer is normally pushed in the above
       * signal) we can still be empty because the pushed buffer got flushed or
       * when the application pushes the requested buffer later, we support both
       * possibilities. */
      if (!g_queue_is_empty (priv->queue))
        continue;

      /* no buffer yet, maybe we are EOS, if not, block for more data. */
    }

    /* check EOS */
    if (G_UNLIKELY (priv->is_eos))
      goto eos;

    /* nothing to return, wait a while for new data or flushing. */
    g_cond_wait (&priv->cond, &priv->mutex);
  }
  g_mutex_unlock (&priv->mutex);
  return ret;

  /* ERRORS */
flushing:
  {
    GST_DEBUG_OBJECT (appsrc, "we are flushing");
    g_mutex_unlock (&priv->mutex);
    return GST_FLOW_FLUSHING;
  }
eos:
  {
    GST_DEBUG_OBJECT (appsrc, "we are EOS");
    g_mutex_unlock (&priv->mutex);
    return GST_FLOW_EOS;
  }
seek_error:
  {
    g_mutex_unlock (&priv->mutex);
    GST_ELEMENT_ERROR (appsrc, RESOURCE, READ, ("failed to seek"),
        GST_ERROR_SYSTEM);
    return GST_FLOW_ERROR;
  }
}

/* external API */

/**
 * gst_app_src_set_caps:
 * @appsrc: a #GstAppSrc
 * @caps: caps to set
 *
 * Set the capabilities on the appsrc element.  This function takes
 * a copy of the caps structure. After calling this method, the source will
 * only produce caps that match @caps. @caps must be fixed and the caps on the
 * buffers must match the caps or left NULL.
 */
void
gst_app_src_set_caps (GstAppSrc * appsrc, const GstCaps * caps)
{
  GstCaps *old;
  GstAppSrcPrivate *priv;

  g_return_if_fail (GST_IS_APP_SRC (appsrc));

  priv = appsrc->priv;

  g_mutex_lock (&priv->mutex);

  GST_OBJECT_LOCK (appsrc);
  GST_DEBUG_OBJECT (appsrc, "setting caps to %" GST_PTR_FORMAT, caps);
  if ((old = priv->caps) != caps) {
    if (caps)
      priv->caps = gst_caps_copy (caps);
    else
      priv->caps = NULL;
    if (old)
      gst_caps_unref (old);
    priv->new_caps = TRUE;
  }
  GST_OBJECT_UNLOCK (appsrc);

  g_mutex_unlock (&priv->mutex);
}

/**
 * gst_app_src_get_caps:
 * @appsrc: a #GstAppSrc
 *
 * Get the configured caps on @appsrc.
 *
 * Returns: the #GstCaps produced by the source. gst_caps_unref() after usage.
 */
GstCaps *
gst_app_src_get_caps (GstAppSrc * appsrc)
{
  g_return_val_if_fail (GST_IS_APP_SRC (appsrc), NULL);

  return gst_app_src_internal_get_caps (GST_BASE_SRC_CAST (appsrc), NULL);
}

/**
 * gst_app_src_set_size:
 * @appsrc: a #GstAppSrc
 * @size: the size to set
 *
 * Set the size of the stream in bytes. A value of -1 means that the size is
 * not known.
 */
void
gst_app_src_set_size (GstAppSrc * appsrc, gint64 size)
{
  GstAppSrcPrivate *priv;

  g_return_if_fail (GST_IS_APP_SRC (appsrc));

  priv = appsrc->priv;

  GST_OBJECT_LOCK (appsrc);
  GST_DEBUG_OBJECT (appsrc, "setting size of %" G_GINT64_FORMAT, size);
  priv->size = size;
  GST_OBJECT_UNLOCK (appsrc);
}

/**
 * gst_app_src_get_size:
 * @appsrc: a #GstAppSrc
 *
 * Get the size of the stream in bytes. A value of -1 means that the size is
 * not known.
 *
 * Returns: the size of the stream previously set with gst_app_src_set_size();
 */
gint64
gst_app_src_get_size (GstAppSrc * appsrc)
{
  gint64 size;
  GstAppSrcPrivate *priv;

  g_return_val_if_fail (GST_IS_APP_SRC (appsrc), -1);

  priv = appsrc->priv;

  GST_OBJECT_LOCK (appsrc);
  size = priv->size;
  GST_DEBUG_OBJECT (appsrc, "getting size of %" G_GINT64_FORMAT, size);
  GST_OBJECT_UNLOCK (appsrc);

  return size;
}

/**
 * gst_app_src_set_stream_type:
 * @appsrc: a #GstAppSrc
 * @type: the new state
 *
 * Set the stream type on @appsrc. For seekable streams, the "seek" signal must
 * be connected to.
 *
 * A stream_type stream
 */
void
gst_app_src_set_stream_type (GstAppSrc * appsrc, GstAppStreamType type)
{
  GstAppSrcPrivate *priv;

  g_return_if_fail (GST_IS_APP_SRC (appsrc));

  priv = appsrc->priv;

  GST_OBJECT_LOCK (appsrc);
  GST_DEBUG_OBJECT (appsrc, "setting stream_type of %d", type);
  priv->stream_type = type;
  GST_OBJECT_UNLOCK (appsrc);
}

/**
 * gst_app_src_get_stream_type:
 * @appsrc: a #GstAppSrc
 *
 * Get the stream type. Control the stream type of @appsrc
 * with gst_app_src_set_stream_type().
 *
 * Returns: the stream type.
 */
GstAppStreamType
gst_app_src_get_stream_type (GstAppSrc * appsrc)
{
  gboolean stream_type;
  GstAppSrcPrivate *priv;

  g_return_val_if_fail (GST_IS_APP_SRC (appsrc), FALSE);

  priv = appsrc->priv;

  GST_OBJECT_LOCK (appsrc);
  stream_type = priv->stream_type;
  GST_DEBUG_OBJECT (appsrc, "getting stream_type of %d", stream_type);
  GST_OBJECT_UNLOCK (appsrc);

  return stream_type;
}

/**
 * gst_app_src_set_max_bytes:
 * @appsrc: a #GstAppSrc
 * @max: the maximum number of bytes to queue
 *
 * Set the maximum amount of bytes that can be queued in @appsrc.
 * After the maximum amount of bytes are queued, @appsrc will emit the
 * "enough-data" signal.
 */
void
gst_app_src_set_max_bytes (GstAppSrc * appsrc, guint64 max)
{
  GstAppSrcPrivate *priv;

  g_return_if_fail (GST_IS_APP_SRC (appsrc));

  priv = appsrc->priv;

  g_mutex_lock (&priv->mutex);
  if (max != priv->max_bytes) {
    GST_DEBUG_OBJECT (appsrc, "setting max-bytes to %" G_GUINT64_FORMAT, max);
    priv->max_bytes = max;
    /* signal the change */
    g_cond_broadcast (&priv->cond);
  }
  g_mutex_unlock (&priv->mutex);
}

/**
 * gst_app_src_get_max_bytes:
 * @appsrc: a #GstAppSrc
 *
 * Get the maximum amount of bytes that can be queued in @appsrc.
 *
 * Returns: The maximum amount of bytes that can be queued.
 */
guint64
gst_app_src_get_max_bytes (GstAppSrc * appsrc)
{
  guint64 result;
  GstAppSrcPrivate *priv;

  g_return_val_if_fail (GST_IS_APP_SRC (appsrc), 0);

  priv = appsrc->priv;

  g_mutex_lock (&priv->mutex);
  result = priv->max_bytes;
  GST_DEBUG_OBJECT (appsrc, "getting max-bytes of %" G_GUINT64_FORMAT, result);
  g_mutex_unlock (&priv->mutex);

  return result;
}

/**
 * gst_app_src_get_current_level_bytes:
 * @appsrc: a #GstAppSrc
 *
 * Get the number of currently queued bytes inside @appsrc.
 *
 * Returns: The number of currently queued bytes.
 *
 * Since: 1.2
 */
guint64
gst_app_src_get_current_level_bytes (GstAppSrc * appsrc)
{
  gint64 queued;
  GstAppSrcPrivate *priv;

  g_return_val_if_fail (GST_IS_APP_SRC (appsrc), -1);

  priv = appsrc->priv;

  GST_OBJECT_LOCK (appsrc);
  queued = priv->queued_bytes;
  GST_DEBUG_OBJECT (appsrc, "current level bytes is %" G_GUINT64_FORMAT,
      queued);
  GST_OBJECT_UNLOCK (appsrc);

  return queued;
}

static void
gst_app_src_set_latencies (GstAppSrc * appsrc, gboolean do_min, guint64 min,
    gboolean do_max, guint64 max)
{
  GstAppSrcPrivate *priv = appsrc->priv;
  gboolean changed = FALSE;

  g_mutex_lock (&priv->mutex);
  if (do_min && priv->min_latency != min) {
    priv->min_latency = min;
    changed = TRUE;
  }
  if (do_max && priv->max_latency != max) {
    priv->max_latency = max;
    changed = TRUE;
  }
  g_mutex_unlock (&priv->mutex);

  if (changed) {
    GST_DEBUG_OBJECT (appsrc, "posting latency changed");
    gst_element_post_message (GST_ELEMENT_CAST (appsrc),
        gst_message_new_latency (GST_OBJECT_CAST (appsrc)));
  }
}

/**
 * gst_app_src_set_latency:
 * @appsrc: a #GstAppSrc
 * @min: the min latency
 * @max: the min latency
 *
 * Configure the @min and @max latency in @src. If @min is set to -1, the
 * default latency calculations for pseudo-live sources will be used.
 */
void
gst_app_src_set_latency (GstAppSrc * appsrc, guint64 min, guint64 max)
{
  gst_app_src_set_latencies (appsrc, TRUE, min, TRUE, max);
}

/**
 * gst_app_src_get_latency:
 * @appsrc: a #GstAppSrc
 * @min: the min latency
 * @max: the min latency
 *
 * Retrieve the min and max latencies in @min and @max respectively.
 */
void
gst_app_src_get_latency (GstAppSrc * appsrc, guint64 * min, guint64 * max)
{
  GstAppSrcPrivate *priv;

  g_return_if_fail (GST_IS_APP_SRC (appsrc));

  priv = appsrc->priv;

  g_mutex_lock (&priv->mutex);
  if (min)
    *min = priv->min_latency;
  if (max)
    *max = priv->max_latency;
  g_mutex_unlock (&priv->mutex);
}

/**
 * gst_app_src_set_emit_signals:
 * @appsrc: a #GstAppSrc
 * @emit: the new state
 *
 * Make appsrc emit the "new-preroll" and "new-buffer" signals. This option is
 * by default disabled because signal emission is expensive and unneeded when
 * the application prefers to operate in pull mode.
 */
void
gst_app_src_set_emit_signals (GstAppSrc * appsrc, gboolean emit)
{
  GstAppSrcPrivate *priv;

  g_return_if_fail (GST_IS_APP_SRC (appsrc));

  priv = appsrc->priv;

  g_mutex_lock (&priv->mutex);
  priv->emit_signals = emit;
  g_mutex_unlock (&priv->mutex);
}

/**
 * gst_app_src_get_emit_signals:
 * @appsrc: a #GstAppSrc
 *
 * Check if appsrc will emit the "new-preroll" and "new-buffer" signals.
 *
 * Returns: %TRUE if @appsrc is emitting the "new-preroll" and "new-buffer"
 * signals.
 */
gboolean
gst_app_src_get_emit_signals (GstAppSrc * appsrc)
{
  gboolean result;
  GstAppSrcPrivate *priv;

  g_return_val_if_fail (GST_IS_APP_SRC (appsrc), FALSE);

  priv = appsrc->priv;

  g_mutex_lock (&priv->mutex);
  result = priv->emit_signals;
  g_mutex_unlock (&priv->mutex);

  return result;
}

static GstFlowReturn
gst_app_src_push_buffer_full (GstAppSrc * appsrc, GstBuffer * buffer,
    gboolean steal_ref)
{
  gboolean first = TRUE;
  GstAppSrcPrivate *priv;

  g_return_val_if_fail (GST_IS_APP_SRC (appsrc), GST_FLOW_ERROR);
  g_return_val_if_fail (GST_IS_BUFFER (buffer), GST_FLOW_ERROR);

  priv = appsrc->priv;

  g_mutex_lock (&priv->mutex);

  while (TRUE) {
    /* can't accept buffers when we are flushing or EOS */
    if (priv->flushing)
      goto flushing;

    if (priv->is_eos)
      goto eos;

    if (priv->max_bytes && priv->queued_bytes >= priv->max_bytes) {
      GST_DEBUG_OBJECT (appsrc,
          "queue filled (%" G_GUINT64_FORMAT " >= %" G_GUINT64_FORMAT ")",
          priv->queued_bytes, priv->max_bytes);

      if (first) {
        gboolean emit;

        emit = priv->emit_signals;
        /* only signal on the first push */
        g_mutex_unlock (&priv->mutex);

        if (priv->callbacks.enough_data)
          priv->callbacks.enough_data (appsrc, priv->user_data);
        else if (emit)
          g_signal_emit (appsrc, gst_app_src_signals[SIGNAL_ENOUGH_DATA], 0,
              NULL);

        g_mutex_lock (&priv->mutex);
        /* continue to check for flushing/eos after releasing the lock */
        first = FALSE;
        continue;
      }
      if (priv->block) {
        GST_DEBUG_OBJECT (appsrc, "waiting for free space");
        /* we are filled, wait until a buffer gets popped or when we
         * flush. */
        g_cond_wait (&priv->cond, &priv->mutex);
      } else {
        /* no need to wait for free space, we just pump more data into the
         * queue hoping that the caller reacts to the enough-data signal and
         * stops pushing buffers. */
        break;
      }
    } else
      break;
  }

  GST_DEBUG_OBJECT (appsrc, "queueing buffer %p", buffer);
  if (!steal_ref)
    gst_buffer_ref (buffer);
  g_queue_push_tail (priv->queue, buffer);
  priv->queued_bytes += gst_buffer_get_size (buffer);
  g_cond_broadcast (&priv->cond);
  g_mutex_unlock (&priv->mutex);

  return GST_FLOW_OK;

  /* ERRORS */
flushing:
  {
    GST_DEBUG_OBJECT (appsrc, "refuse buffer %p, we are flushing", buffer);
    if (steal_ref)
      gst_buffer_unref (buffer);
    g_mutex_unlock (&priv->mutex);
    return GST_FLOW_FLUSHING;
  }
eos:
  {
    GST_DEBUG_OBJECT (appsrc, "refuse buffer %p, we are EOS", buffer);
    if (steal_ref)
      gst_buffer_unref (buffer);
    g_mutex_unlock (&priv->mutex);
    return GST_FLOW_EOS;
  }
}

/**
 * gst_app_src_push_buffer:
 * @appsrc: a #GstAppSrc
 * @buffer: (transfer full): a #GstBuffer to push
 *
 * Adds a buffer to the queue of buffers that the appsrc element will
 * push to its source pad.  This function takes ownership of the buffer.
 *
 * When the block property is TRUE, this function can block until free
 * space becomes available in the queue.
 *
 * Returns: #GST_FLOW_OK when the buffer was successfuly queued.
 * #GST_FLOW_FLUSHING when @appsrc is not PAUSED or PLAYING.
 * #GST_FLOW_EOS when EOS occured.
 */
GstFlowReturn
gst_app_src_push_buffer (GstAppSrc * appsrc, GstBuffer * buffer)
{
  return gst_app_src_push_buffer_full (appsrc, buffer, TRUE);
}

/* push a buffer without stealing the ref of the buffer. This is used for the
 * action signal. */
static GstFlowReturn
gst_app_src_push_buffer_action (GstAppSrc * appsrc, GstBuffer * buffer)
{
  return gst_app_src_push_buffer_full (appsrc, buffer, FALSE);
}

/**
 * gst_app_src_end_of_stream:
 * @appsrc: a #GstAppSrc
 *
 * Indicates to the appsrc element that the last buffer queued in the
 * element is the last buffer of the stream.
 *
 * Returns: #GST_FLOW_OK when the EOS was successfuly queued.
 * #GST_FLOW_FLUSHING when @appsrc is not PAUSED or PLAYING.
 */
GstFlowReturn
gst_app_src_end_of_stream (GstAppSrc * appsrc)
{
  GstAppSrcPrivate *priv;

  g_return_val_if_fail (GST_IS_APP_SRC (appsrc), GST_FLOW_ERROR);

  priv = appsrc->priv;

  g_mutex_lock (&priv->mutex);
  /* can't accept buffers when we are flushing. We can accept them when we are
   * EOS although it will not do anything. */
  if (priv->flushing)
    goto flushing;

  GST_DEBUG_OBJECT (appsrc, "sending EOS");
  priv->is_eos = TRUE;
  g_cond_broadcast (&priv->cond);
  g_mutex_unlock (&priv->mutex);

  return GST_FLOW_OK;

  /* ERRORS */
flushing:
  {
    g_mutex_unlock (&priv->mutex);
    GST_DEBUG_OBJECT (appsrc, "refuse EOS, we are flushing");
    return GST_FLOW_FLUSHING;
  }
}

/**
 * gst_app_src_set_callbacks: (skip)
 * @appsrc: a #GstAppSrc
 * @callbacks: the callbacks
 * @user_data: a user_data argument for the callbacks
 * @notify: a destroy notify function
 *
 * Set callbacks which will be executed when data is needed, enough data has
 * been collected or when a seek should be performed.
 * This is an alternative to using the signals, it has lower overhead and is thus
 * less expensive, but also less flexible.
 *
 * If callbacks are installed, no signals will be emitted for performance
 * reasons.
 */
void
gst_app_src_set_callbacks (GstAppSrc * appsrc,
    GstAppSrcCallbacks * callbacks, gpointer user_data, GDestroyNotify notify)
{
  GDestroyNotify old_notify;
  GstAppSrcPrivate *priv;

  g_return_if_fail (GST_IS_APP_SRC (appsrc));
  g_return_if_fail (callbacks != NULL);

  priv = appsrc->priv;

  GST_OBJECT_LOCK (appsrc);
  old_notify = priv->notify;

  if (old_notify) {
    gpointer old_data;

    old_data = priv->user_data;

    priv->user_data = NULL;
    priv->notify = NULL;
    GST_OBJECT_UNLOCK (appsrc);

    old_notify (old_data);

    GST_OBJECT_LOCK (appsrc);
  }
  priv->callbacks = *callbacks;
  priv->user_data = user_data;
  priv->notify = notify;
  GST_OBJECT_UNLOCK (appsrc);
}

/*** GSTURIHANDLER INTERFACE *************************************************/

static GstURIType
gst_app_src_uri_get_type (GType type)
{
  return GST_URI_SRC;
}

static const gchar *const *
gst_app_src_uri_get_protocols (GType type)
{
  static const gchar *protocols[] = { "appsrc", NULL };

  return protocols;
}

static gchar *
gst_app_src_uri_get_uri (GstURIHandler * handler)
{
  GstAppSrc *appsrc = GST_APP_SRC (handler);

  return appsrc->priv->uri ? g_strdup (appsrc->priv->uri) : NULL;
}

static gboolean
gst_app_src_uri_set_uri (GstURIHandler * handler, const gchar * uri,
    GError ** error)
{
  GstAppSrc *appsrc = GST_APP_SRC (handler);

  g_free (appsrc->priv->uri);
  appsrc->priv->uri = uri ? g_strdup (uri) : NULL;

  return TRUE;
}

static void
gst_app_src_uri_handler_init (gpointer g_iface, gpointer iface_data)
{
  GstURIHandlerInterface *iface = (GstURIHandlerInterface *) g_iface;

  iface->get_type = gst_app_src_uri_get_type;
  iface->get_protocols = gst_app_src_uri_get_protocols;
  iface->get_uri = gst_app_src_uri_get_uri;
  iface->set_uri = gst_app_src_uri_set_uri;
}
