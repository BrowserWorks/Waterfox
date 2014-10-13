/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
 * Copyright (C) <2004> Thomas Vander Stichele <thomas at apestaart dot org>
 * Copyright (C) 2006 Wim Taymans <wim at fluendo dot com>
 * Copyright (C) <2011> Collabora Ltd.
 *     Author: Sebastian Dröge <sebastian.droege@collabora.co.uk>
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
 * SECTION:element-multihandlesink
 * @see_also: tcpserversink
 *
 * This plugin writes incoming data to a set of file descriptors. The
 * file descriptors can be added to multihandlesink by emitting the #GstMultiHandleSink::add signal. 
 * For each descriptor added, the #GstMultiHandleSink::client-added signal will be called.
 *
 * A client can also be added with the #GstMultiHandleSink::add-full signal
 * that allows for more control over what and how much data a client 
 * initially receives.
 *
 * Clients can be removed from multihandlesink by emitting the #GstMultiHandleSink::remove signal. For
 * each descriptor removed, the #GstMultiHandleSink::client-removed signal will be called. The
 * #GstMultiHandleSink::client-removed signal can also be fired when multihandlesink decides that a
 * client is not active anymore or, depending on the value of the
 * #GstMultiHandleSink:recover-policy property, if the client is reading too slowly.
 * In all cases, multihandlesink will never close a file descriptor itself.
 * The user of multihandlesink is responsible for closing all file descriptors.
 * This can for example be done in response to the #GstMultiHandleSink::client-fd-removed signal.
 * Note that multihandlesink still has a reference to the file descriptor when the
 * #GstMultiHandleSink::client-removed signal is emitted, so that "get-stats" can be performed on
 * the descriptor; it is therefore not safe to close the file descriptor in
 * the #GstMultiHandleSink::client-removed signal handler, and you should use the 
 * #GstMultiHandleSink::client-fd-removed signal to safely close the fd.
 *
 * Multisocketsink internally keeps a queue of the incoming buffers and uses a
 * separate thread to send the buffers to the clients. This ensures that no
 * client write can block the pipeline and that clients can read with different
 * speeds.
 *
 * When adding a client to multihandlesink, the #GstMultiHandleSink:sync-method property will define
 * which buffer in the queued buffers will be sent first to the client. Clients 
 * can be sent the most recent buffer (which might not be decodable by the 
 * client if it is not a keyframe), the next keyframe received in 
 * multihandlesink (which can take some time depending on the keyframe rate), or the
 * last received keyframe (which will cause a simple burst-on-connect). 
 * Multisocketsink will always keep at least one keyframe in its internal buffers
 * when the sync-mode is set to latest-keyframe.
 *
 * There are additional values for the #GstMultiHandleSink:sync-method
 * property to allow finer control over burst-on-connect behaviour. By selecting
 * the 'burst' method a minimum burst size can be chosen, 'burst-keyframe'
 * additionally requires that the burst begin with a keyframe, and 
 * 'burst-with-keyframe' attempts to burst beginning with a keyframe, but will
 * prefer a minimum burst size even if it requires not starting with a keyframe.
 *
 * Multisocketsink can be instructed to keep at least a minimum amount of data
 * expressed in time or byte units in its internal queues with the 
 * #GstMultiHandleSink:time-min and #GstMultiHandleSink:bytes-min properties respectively.
 * These properties are useful if the application adds clients with the 
 * #GstMultiHandleSink::add-full signal to make sure that a burst connect can
 * actually be honored. 
 *
 * When streaming data, clients are allowed to read at a different rate than
 * the rate at which multihandlesink receives data. If the client is reading too
 * fast, no data will be send to the client until multihandlesink receives more
 * data. If the client, however, reads too slowly, data for that client will be 
 * queued up in multihandlesink. Two properties control the amount of data 
 * (buffers) that is queued in multihandlesink: #GstMultiHandleSink:buffers-max and 
 * #GstMultiHandleSink:buffers-soft-max. A client that falls behind by
 * #GstMultiHandleSink:buffers-max is removed from multihandlesink forcibly.
 *
 * A client with a lag of at least #GstMultiHandleSink:buffers-soft-max enters the recovery
 * procedure which is controlled with the #GstMultiHandleSink:recover-policy property.
 * A recover policy of NONE will do nothing, RESYNC_LATEST will send the most recently
 * received buffer as the next buffer for the client, RESYNC_SOFT_LIMIT
 * positions the client to the soft limit in the buffer queue and
 * RESYNC_KEYFRAME positions the client at the most recent keyframe in the
 * buffer queue.
 *
 * multihandlesink will by default synchronize on the clock before serving the 
 * buffers to the clients. This behaviour can be disabled by setting the sync 
 * property to FALSE. Multisocketsink will by default not do QoS and will never
 * drop late buffers.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/gst-i18n-plugin.h>

#include "gstmultihandlesink.h"

#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif

#ifndef G_OS_WIN32
#include <netinet/in.h>
#endif

#define NOT_IMPLEMENTED 0

static GstStaticPadTemplate sinktemplate = GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

GST_DEBUG_CATEGORY_STATIC (multihandlesink_debug);
#define GST_CAT_DEFAULT (multihandlesink_debug)

/* MultiHandleSink signals and args */
enum
{
  GST_MULTI_SINK_LAST_SIGNAL,

  /* methods */
  SIGNAL_ADD,
  SIGNAL_ADD_BURST,
  SIGNAL_CLEAR,

  /* signals */
  SIGNAL_CLIENT_ADDED,
  SIGNAL_CLIENT_REMOVED,
  SIGNAL_CLIENT_SOCKET_REMOVED,

  LAST_SIGNAL
};


/* this is really arbitrarily chosen */
#define DEFAULT_BUFFERS_MAX             -1
#define DEFAULT_BUFFERS_SOFT_MAX        -1
#define DEFAULT_TIME_MIN                -1
#define DEFAULT_BYTES_MIN               -1
#define DEFAULT_BUFFERS_MIN             -1
#define DEFAULT_UNIT_FORMAT               GST_FORMAT_BUFFERS
#define DEFAULT_UNITS_MAX               -1
#define DEFAULT_UNITS_SOFT_MAX          -1
#define DEFAULT_RECOVER_POLICY          GST_RECOVER_POLICY_NONE
#define DEFAULT_TIMEOUT                 0
#define DEFAULT_SYNC_METHOD             GST_SYNC_METHOD_LATEST

#define DEFAULT_BURST_FORMAT            GST_FORMAT_UNDEFINED
#define DEFAULT_BURST_VALUE             0

#define DEFAULT_QOS_DSCP                -1

#define DEFAULT_RESEND_STREAMHEADER      TRUE

enum
{
  PROP_0,
  PROP_BUFFERS_QUEUED,
  PROP_BYTES_QUEUED,
  PROP_TIME_QUEUED,

  PROP_UNIT_FORMAT,
  PROP_UNITS_MAX,
  PROP_UNITS_SOFT_MAX,

  PROP_BUFFERS_MAX,
  PROP_BUFFERS_SOFT_MAX,

  PROP_TIME_MIN,
  PROP_BYTES_MIN,
  PROP_BUFFERS_MIN,

  PROP_RECOVER_POLICY,
  PROP_TIMEOUT,
  PROP_SYNC_METHOD,
  PROP_BYTES_TO_SERVE,
  PROP_BYTES_SERVED,

  PROP_BURST_FORMAT,
  PROP_BURST_VALUE,

  PROP_QOS_DSCP,

  PROP_RESEND_STREAMHEADER,

  PROP_NUM_HANDLES,

  PROP_LAST
};

GType
gst_multi_handle_sink_recover_policy_get_type (void)
{
  static GType recover_policy_type = 0;
  static const GEnumValue recover_policy[] = {
    {GST_RECOVER_POLICY_NONE,
        "Do not try to recover", "none"},
    {GST_RECOVER_POLICY_RESYNC_LATEST,
        "Resync client to latest buffer", "latest"},
    {GST_RECOVER_POLICY_RESYNC_SOFT_LIMIT,
        "Resync client to soft limit", "soft-limit"},
    {GST_RECOVER_POLICY_RESYNC_KEYFRAME,
        "Resync client to most recent keyframe", "keyframe"},
    {0, NULL, NULL},
  };

  if (!recover_policy_type) {
    recover_policy_type =
        g_enum_register_static ("GstMultiHandleSinkRecoverPolicy",
        recover_policy);
  }
  return recover_policy_type;
}

GType
gst_multi_handle_sink_sync_method_get_type (void)
{
  static GType sync_method_type = 0;
  static const GEnumValue sync_method[] = {
    {GST_SYNC_METHOD_LATEST,
        "Serve starting from the latest buffer", "latest"},
    {GST_SYNC_METHOD_NEXT_KEYFRAME,
        "Serve starting from the next keyframe", "next-keyframe"},
    {GST_SYNC_METHOD_LATEST_KEYFRAME,
          "Serve everything since the latest keyframe (burst)",
        "latest-keyframe"},
    {GST_SYNC_METHOD_BURST, "Serve burst-value data to client", "burst"},
    {GST_SYNC_METHOD_BURST_KEYFRAME,
          "Serve burst-value data starting on a keyframe",
        "burst-keyframe"},
    {GST_SYNC_METHOD_BURST_WITH_KEYFRAME,
          "Serve burst-value data preferably starting on a keyframe",
        "burst-with-keyframe"},
    {0, NULL, NULL},
  };

  if (!sync_method_type) {
    sync_method_type =
        g_enum_register_static ("GstMultiHandleSinkSyncMethod", sync_method);
  }
  return sync_method_type;
}

GType
gst_multi_handle_sink_client_status_get_type (void)
{
  static GType client_status_type = 0;
  static const GEnumValue client_status[] = {
    {GST_CLIENT_STATUS_OK, "ok", "ok"},
    {GST_CLIENT_STATUS_CLOSED, "Closed", "closed"},
    {GST_CLIENT_STATUS_REMOVED, "Removed", "removed"},
    {GST_CLIENT_STATUS_SLOW, "Too slow", "slow"},
    {GST_CLIENT_STATUS_ERROR, "Error", "error"},
    {GST_CLIENT_STATUS_DUPLICATE, "Duplicate", "duplicate"},
    {GST_CLIENT_STATUS_FLUSHING, "Flushing", "flushing"},
    {0, NULL, NULL},
  };

  if (!client_status_type) {
    client_status_type =
        g_enum_register_static ("GstMultiHandleSinkClientStatus",
        client_status);
  }
  return client_status_type;
}

static void gst_multi_handle_sink_finalize (GObject * object);
static void gst_multi_handle_sink_clear (GstMultiHandleSink * mhsink);

static GstFlowReturn gst_multi_handle_sink_render (GstBaseSink * bsink,
    GstBuffer * buf);
static void gst_multi_handle_sink_queue_buffer (GstMultiHandleSink * mhsink,
    GstBuffer * buffer);
static gboolean gst_multi_handle_sink_client_queue_buffer (GstMultiHandleSink *
    mhsink, GstMultiHandleClient * mhclient, GstBuffer * buffer);
static GstStateChangeReturn gst_multi_handle_sink_change_state (GstElement *
    element, GstStateChange transition);

static void gst_multi_handle_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_multi_handle_sink_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

#define gst_multi_handle_sink_parent_class parent_class
G_DEFINE_TYPE (GstMultiHandleSink, gst_multi_handle_sink, GST_TYPE_BASE_SINK);

static guint gst_multi_handle_sink_signals[LAST_SIGNAL] = { 0 };

static gint
find_syncframe (GstMultiHandleSink * sink, gint idx, gint direction);
#define find_next_syncframe(s,i) 	find_syncframe(s,i,1)
#define find_prev_syncframe(s,i) 	find_syncframe(s,i,-1)
static gboolean is_sync_frame (GstMultiHandleSink * sink, GstBuffer * buffer);
static gboolean gst_multi_handle_sink_stop (GstBaseSink * bsink);
static gboolean gst_multi_handle_sink_start (GstBaseSink * bsink);
static gint get_buffers_max (GstMultiHandleSink * sink, gint64 max);
static gint
gst_multi_handle_sink_recover_client (GstMultiHandleSink * sink,
    GstMultiHandleClient * client);
static void gst_multi_handle_sink_setup_dscp (GstMultiHandleSink * mhsink);
static gboolean
find_limits (GstMultiHandleSink * sink,
    gint * min_idx, gint bytes_min, gint buffers_min, gint64 time_min,
    gint * max_idx, gint bytes_max, gint buffers_max, gint64 time_max);


static void
gst_multi_handle_sink_class_init (GstMultiHandleSinkClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstBaseSinkClass *gstbasesink_class;

  gobject_class = (GObjectClass *) klass;
  gstelement_class = (GstElementClass *) klass;
  gstbasesink_class = (GstBaseSinkClass *) klass;

  gobject_class->set_property = gst_multi_handle_sink_set_property;
  gobject_class->get_property = gst_multi_handle_sink_get_property;
  gobject_class->finalize = gst_multi_handle_sink_finalize;

  g_object_class_install_property (gobject_class, PROP_BUFFERS_MAX,
      g_param_spec_int ("buffers-max", "Buffers max",
          "max number of buffers to queue for a client (-1 = no limit)", -1,
          G_MAXINT, DEFAULT_BUFFERS_MAX,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_BUFFERS_SOFT_MAX,
      g_param_spec_int ("buffers-soft-max", "Buffers soft max",
          "Recover client when going over this limit (-1 = no limit)", -1,
          G_MAXINT, DEFAULT_BUFFERS_SOFT_MAX,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_BYTES_MIN,
      g_param_spec_int ("bytes-min", "Bytes min",
          "min number of bytes to queue (-1 = as little as possible)", -1,
          G_MAXINT, DEFAULT_BYTES_MIN,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_TIME_MIN,
      g_param_spec_int64 ("time-min", "Time min",
          "min number of time to queue (-1 = as little as possible)", -1,
          G_MAXINT64, DEFAULT_TIME_MIN,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_BUFFERS_MIN,
      g_param_spec_int ("buffers-min", "Buffers min",
          "min number of buffers to queue (-1 = as few as possible)", -1,
          G_MAXINT, DEFAULT_BUFFERS_MIN,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_UNIT_FORMAT,
      g_param_spec_enum ("unit-format", "Units format",
          "The unit to measure the max/soft-max/queued properties",
          GST_TYPE_FORMAT, DEFAULT_UNIT_FORMAT,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_UNITS_MAX,
      g_param_spec_int64 ("units-max", "Units max",
          "max number of units to queue (-1 = no limit)", -1, G_MAXINT64,
          DEFAULT_UNITS_MAX, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_UNITS_SOFT_MAX,
      g_param_spec_int64 ("units-soft-max", "Units soft max",
          "Recover client when going over this limit (-1 = no limit)", -1,
          G_MAXINT64, DEFAULT_UNITS_SOFT_MAX,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_BUFFERS_QUEUED,
      g_param_spec_uint ("buffers-queued", "Buffers queued",
          "Number of buffers currently queued", 0, G_MAXUINT, 0,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
#if NOT_IMPLEMENTED
  g_object_class_install_property (gobject_class, PROP_BYTES_QUEUED,
      g_param_spec_uint ("bytes-queued", "Bytes queued",
          "Number of bytes currently queued", 0, G_MAXUINT, 0,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_TIME_QUEUED,
      g_param_spec_uint64 ("time-queued", "Time queued",
          "Number of time currently queued", 0, G_MAXUINT64, 0,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
#endif

  g_object_class_install_property (gobject_class, PROP_RECOVER_POLICY,
      g_param_spec_enum ("recover-policy", "Recover Policy",
          "How to recover when client reaches the soft max",
          GST_TYPE_RECOVER_POLICY, DEFAULT_RECOVER_POLICY,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_TIMEOUT,
      g_param_spec_uint64 ("timeout", "Timeout",
          "Maximum inactivity timeout in nanoseconds for a client (0 = no limit)",
          0, G_MAXUINT64, DEFAULT_TIMEOUT,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_SYNC_METHOD,
      g_param_spec_enum ("sync-method", "Sync Method",
          "How to sync new clients to the stream", GST_TYPE_SYNC_METHOD,
          DEFAULT_SYNC_METHOD, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_BYTES_TO_SERVE,
      g_param_spec_uint64 ("bytes-to-serve", "Bytes to serve",
          "Number of bytes received to serve to clients", 0, G_MAXUINT64, 0,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_BYTES_SERVED,
      g_param_spec_uint64 ("bytes-served", "Bytes served",
          "Total number of bytes send to all clients", 0, G_MAXUINT64, 0,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_BURST_FORMAT,
      g_param_spec_enum ("burst-format", "Burst format",
          "The format of the burst units (when sync-method is burst[[-with]-keyframe])",
          GST_TYPE_FORMAT, DEFAULT_BURST_FORMAT,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_BURST_VALUE,
      g_param_spec_uint64 ("burst-value", "Burst value",
          "The amount of burst expressed in burst-format", 0, G_MAXUINT64,
          DEFAULT_BURST_VALUE, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_QOS_DSCP,
      g_param_spec_int ("qos-dscp", "QoS diff srv code point",
          "Quality of Service, differentiated services code point (-1 default)",
          -1, 63, DEFAULT_QOS_DSCP,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstMultiHandleSink::resend-streamheader
   *
   * Resend the streamheaders to existing clients when they change.
   */
  g_object_class_install_property (gobject_class, PROP_RESEND_STREAMHEADER,
      g_param_spec_boolean ("resend-streamheader", "Resend streamheader",
          "Resend the streamheader if it changes in the caps",
          DEFAULT_RESEND_STREAMHEADER,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_NUM_HANDLES,
      g_param_spec_uint ("num-handles", "Number of handles",
          "The current number of client handles",
          0, G_MAXUINT, 0, G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));

  /**
   * GstMultiHandleSink::clear:
   * @gstmultihandlesink: the multihandlesink element to emit this signal on
   *
   * Remove all sockets from multihandlesink.  Since multihandlesink did not
   * open sockets itself, it does not explicitly close the sockets. The application
   * should do so by connecting to the client-socket-removed callback.
   */
  gst_multi_handle_sink_signals[SIGNAL_CLEAR] =
      g_signal_new ("clear", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
      G_STRUCT_OFFSET (GstMultiHandleSinkClass, clear), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 0);

  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&sinktemplate));

  gst_element_class_set_static_metadata (gstelement_class,
      "Multi socket sink", "Sink/Network",
      "Send data to multiple sockets",
      "Thomas Vander Stichele <thomas at apestaart dot org>, "
      "Wim Taymans <wim@fluendo.com>, "
      "Sebastian Dröge <sebastian.droege@collabora.co.uk>");

  gstelement_class->change_state =
      GST_DEBUG_FUNCPTR (gst_multi_handle_sink_change_state);

  gstbasesink_class->render = GST_DEBUG_FUNCPTR (gst_multi_handle_sink_render);
  klass->client_queue_buffer =
      GST_DEBUG_FUNCPTR (gst_multi_handle_sink_client_queue_buffer);

#if 0
  klass->add = GST_DEBUG_FUNCPTR (gst_multi_handle_sink_add);
  klass->add_full = GST_DEBUG_FUNCPTR (gst_multi_handle_sink_add_full);
  klass->remove = GST_DEBUG_FUNCPTR (gst_multi_handle_sink_remove);
  klass->remove_flush = GST_DEBUG_FUNCPTR (gst_multi_handle_sink_remove_flush);
#endif

  klass->clear = GST_DEBUG_FUNCPTR (gst_multi_handle_sink_clear);

  GST_DEBUG_CATEGORY_INIT (multihandlesink_debug, "multihandlesink", 0,
      "Multi socket sink");
}

static void
gst_multi_handle_sink_init (GstMultiHandleSink * this)
{
  GST_OBJECT_FLAG_UNSET (this, GST_MULTI_HANDLE_SINK_OPEN);

  CLIENTS_LOCK_INIT (this);
  this->clients = NULL;

  this->bufqueue = g_array_new (FALSE, TRUE, sizeof (GstBuffer *));
  this->unit_format = DEFAULT_UNIT_FORMAT;
  this->units_max = DEFAULT_UNITS_MAX;
  this->units_soft_max = DEFAULT_UNITS_SOFT_MAX;
  this->time_min = DEFAULT_TIME_MIN;
  this->bytes_min = DEFAULT_BYTES_MIN;
  this->buffers_min = DEFAULT_BUFFERS_MIN;
  this->recover_policy = DEFAULT_RECOVER_POLICY;

  this->timeout = DEFAULT_TIMEOUT;
  this->def_sync_method = DEFAULT_SYNC_METHOD;

  this->def_burst_format = DEFAULT_BURST_FORMAT;
  this->def_burst_value = DEFAULT_BURST_VALUE;

  this->qos_dscp = DEFAULT_QOS_DSCP;

  this->resend_streamheader = DEFAULT_RESEND_STREAMHEADER;
}

static void
gst_multi_handle_sink_finalize (GObject * object)
{
  GstMultiHandleSink *this;

  this = GST_MULTI_HANDLE_SINK (object);

  CLIENTS_LOCK_CLEAR (this);
  g_array_free (this->bufqueue, TRUE);
  g_hash_table_destroy (this->handle_hash);

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

gint
gst_multi_handle_sink_setup_dscp_client (GstMultiHandleSink * sink,
    GstMultiHandleClient * client)
{
#if !defined(IP_TOS) || !defined(HAVE_SYS_SOCKET_H)
  return 0;
#else
  gint tos;
  gint ret;
  int fd;
  union gst_sockaddr
  {
    struct sockaddr sa;
    struct sockaddr_in6 sa_in6;
    struct sockaddr_storage sa_stor;
  } sa;
  socklen_t slen = sizeof (sa);
  gint af;
  GstMultiHandleSinkClass *mhsinkclass = GST_MULTI_HANDLE_SINK_GET_CLASS (sink);

  /* don't touch */
  if (sink->qos_dscp < 0)
    return 0;

  fd = mhsinkclass->client_get_fd (client);

  if ((ret = getsockname (fd, &sa.sa, &slen)) < 0) {
    GST_DEBUG_OBJECT (sink, "could not get sockname: %s", g_strerror (errno));
    return ret;
  }

  af = sa.sa.sa_family;

  /* if this is an IPv4-mapped address then do IPv4 QoS */
  if (af == AF_INET6) {

    GST_DEBUG_OBJECT (sink, "check IP6 socket");
    if (IN6_IS_ADDR_V4MAPPED (&(sa.sa_in6.sin6_addr))) {
      GST_DEBUG_OBJECT (sink, "mapped to IPV4");
      af = AF_INET;
    }
  }

  /* extract and shift 6 bits of the DSCP */
  tos = (sink->qos_dscp & 0x3f) << 2;

  switch (af) {
    case AF_INET:
      ret = setsockopt (fd, IPPROTO_IP, IP_TOS, &tos, sizeof (tos));
      break;
    case AF_INET6:
#ifdef IPV6_TCLASS
      ret = setsockopt (fd, IPPROTO_IPV6, IPV6_TCLASS, &tos, sizeof (tos));
      break;
#endif
    default:
      ret = 0;
      GST_ERROR_OBJECT (sink, "unsupported AF");
      break;
  }
  if (ret)
    GST_DEBUG_OBJECT (sink, "could not set DSCP: %s", g_strerror (errno));

  return ret;
#endif
}

void
gst_multi_handle_sink_client_init (GstMultiHandleClient * client,
    GstSyncMethod sync_method)
{
  GTimeVal now;

  client->status = GST_CLIENT_STATUS_OK;
  client->bufpos = -1;
  client->flushcount = -1;
  client->bufoffset = 0;
  client->sending = NULL;
  client->bytes_sent = 0;
  client->dropped_buffers = 0;
  client->avg_queue_size = 0;
  client->first_buffer_ts = GST_CLOCK_TIME_NONE;
  client->last_buffer_ts = GST_CLOCK_TIME_NONE;
  client->new_connection = TRUE;
  client->sync_method = sync_method;
  client->currently_removing = FALSE;

  /* update start time */
  g_get_current_time (&now);
  client->connect_time = GST_TIMEVAL_TO_TIME (now);
  client->disconnect_time = 0;
  /* set last activity time to connect time */
  client->last_activity_time = client->connect_time;
}

static void
gst_multi_handle_sink_setup_dscp (GstMultiHandleSink * mhsink)
{
  GList *clients;

  CLIENTS_LOCK (mhsink);
  for (clients = mhsink->clients; clients; clients = clients->next) {
    GstMultiHandleClient *client;

    client = clients->data;

    gst_multi_handle_sink_setup_dscp_client (mhsink, client);
  }
  CLIENTS_UNLOCK (mhsink);
}

void
gst_multi_handle_sink_add_full (GstMultiHandleSink * sink,
    GstMultiSinkHandle handle, GstSyncMethod sync_method, GstFormat min_format,
    guint64 min_value, GstFormat max_format, guint64 max_value)
{
  GstMultiHandleClient *mhclient;
  GList *clink;
  GstMultiHandleSink *mhsink = GST_MULTI_HANDLE_SINK (sink);
  gchar debug[30];
  GstMultiHandleSinkClass *mhsinkclass =
      GST_MULTI_HANDLE_SINK_GET_CLASS (mhsink);

  if (!sink->running) {
    g_warning ("Element %s must be set to READY, PAUSED or PLAYING state "
        "before clients can be added", GST_OBJECT_NAME (sink));
    return;
  }

  mhsinkclass->handle_debug (handle, debug);
  GST_DEBUG_OBJECT (sink, "%s adding client, sync_method %d, "
      "min_format %d, min_value %" G_GUINT64_FORMAT
      ", max_format %d, max_value %" G_GUINT64_FORMAT, debug,
      sync_method, min_format, min_value, max_format, max_value);

  /* do limits check if we can */
  if (min_format == max_format) {
    if (max_value != -1 && min_value != -1 && max_value < min_value)
      goto wrong_limits;
  }

  CLIENTS_LOCK (sink);

  /* check the hash to find a duplicate handle */
  clink = g_hash_table_lookup (mhsink->handle_hash,
      mhsinkclass->handle_hash_key (handle));
  if (clink != NULL)
    goto duplicate;

  mhclient = mhsinkclass->new_client (mhsink, handle, sync_method);

  /* we can add the handle now */
  clink = mhsink->clients = g_list_prepend (mhsink->clients, mhclient);
  g_hash_table_insert (mhsink->handle_hash,
      mhsinkclass->handle_hash_key (mhclient->handle), clink);
  mhsink->clients_cookie++;


  mhclient->burst_min_format = min_format;
  mhclient->burst_min_value = min_value;
  mhclient->burst_max_format = max_format;
  mhclient->burst_max_value = max_value;

  if (mhsinkclass->hash_changed)
    mhsinkclass->hash_changed (mhsink);

  CLIENTS_UNLOCK (sink);

  mhsinkclass->emit_client_added (mhsink, handle);

  return;

  /* errors */
wrong_limits:
  {
    GST_WARNING_OBJECT (sink,
        "%s wrong values min =%" G_GUINT64_FORMAT ", max=%"
        G_GUINT64_FORMAT ", unit %d specified when adding client",
        debug, min_value, max_value, min_format);
    return;
  }
duplicate:
  {
    CLIENTS_UNLOCK (sink);
    GST_WARNING_OBJECT (sink, "%s duplicate client found, refusing", debug);
    mhsinkclass->emit_client_removed (mhsink, handle,
        GST_CLIENT_STATUS_DUPLICATE);
    return;
  }
}

/* "add" signal implementation */
void
gst_multi_handle_sink_add (GstMultiHandleSink * sink, GstMultiSinkHandle handle)
{
  gst_multi_handle_sink_add_full (sink, handle, sink->def_sync_method,
      sink->def_burst_format, sink->def_burst_value, sink->def_burst_format,
      -1);
}

/* "remove" signal implementation */
void
gst_multi_handle_sink_remove (GstMultiHandleSink * sink,
    GstMultiSinkHandle handle)
{
  GList *clink;
  GstMultiHandleSink *mhsink = GST_MULTI_HANDLE_SINK (sink);
  GstMultiHandleSinkClass *mhsinkclass =
      GST_MULTI_HANDLE_SINK_GET_CLASS (mhsink);
  gchar debug[30];

  mhsinkclass->handle_debug (handle, debug);

  GST_DEBUG_OBJECT (sink, "%s removing client", debug);

  CLIENTS_LOCK (sink);
  clink = g_hash_table_lookup (mhsink->handle_hash,
      mhsinkclass->handle_hash_key (handle));
  if (clink != NULL) {
    GstMultiHandleClient *mhclient = (GstMultiHandleClient *) clink->data;

    if (mhclient->status != GST_CLIENT_STATUS_OK) {
      GST_INFO_OBJECT (sink,
          "%s Client already disconnecting with status %d",
          debug, mhclient->status);
      goto done;
    }

    mhclient->status = GST_CLIENT_STATUS_REMOVED;
    gst_multi_handle_sink_remove_client_link (GST_MULTI_HANDLE_SINK (sink),
        clink);
    if (mhsinkclass->hash_changed)
      mhsinkclass->hash_changed (mhsink);
  } else {
    GST_WARNING_OBJECT (sink, "%s no client with this handle found!", debug);
  }

done:
  CLIENTS_UNLOCK (sink);
}

/* "remove-flush" signal implementation */
void
gst_multi_handle_sink_remove_flush (GstMultiHandleSink * sink,
    GstMultiSinkHandle handle)
{
  GList *clink;
  GstMultiHandleSink *mhsink = GST_MULTI_HANDLE_SINK (sink);
  GstMultiHandleSinkClass *mhsinkclass =
      GST_MULTI_HANDLE_SINK_GET_CLASS (mhsink);
  gchar debug[30];

  mhsinkclass->handle_debug (handle, debug);

  GST_DEBUG_OBJECT (sink, "%s flushing client", debug);

  CLIENTS_LOCK (sink);
  clink = g_hash_table_lookup (mhsink->handle_hash,
      mhsinkclass->handle_hash_key (handle));
  if (clink != NULL) {
    GstMultiHandleClient *mhclient = (GstMultiHandleClient *) clink->data;

    if (mhclient->status != GST_CLIENT_STATUS_OK) {
      GST_INFO_OBJECT (sink,
          "%s Client already disconnecting with status %d",
          mhclient->debug, mhclient->status);
      goto done;
    }

    /* take the position of the client as the number of buffers left to flush.
     * If the client was at position -1, we flush 0 buffers, 0 == flush 1
     * buffer, etc... */
    mhclient->flushcount = mhclient->bufpos + 1;
    /* mark client as flushing. We can not remove the client right away because
     * it might have some buffers to flush in the ->sending queue. */
    mhclient->status = GST_CLIENT_STATUS_FLUSHING;
  } else {
    GST_WARNING_OBJECT (sink, "%s no client with this handle found!", debug);
  }
done:
  CLIENTS_UNLOCK (sink);
}

/* can be called both through the signal (i.e. from any thread) or when 
 * stopping, after the writing thread has shut down */
static void
gst_multi_handle_sink_clear (GstMultiHandleSink * mhsink)
{
  GList *clients, *next;
  guint32 cookie;
  GstMultiHandleSinkClass *mhsinkclass =
      GST_MULTI_HANDLE_SINK_GET_CLASS (mhsink);

  GST_DEBUG_OBJECT (mhsink, "clearing all clients");

  CLIENTS_LOCK (mhsink);
restart:
  cookie = mhsink->clients_cookie;
  for (clients = mhsink->clients; clients; clients = next) {
    GstMultiHandleClient *mhclient;

    if (cookie != mhsink->clients_cookie) {
      GST_DEBUG_OBJECT (mhsink, "cookie changed while removing all clients");
      goto restart;
    }

    mhclient = (GstMultiHandleClient *) clients->data;
    next = g_list_next (clients);

    mhclient->status = GST_CLIENT_STATUS_REMOVED;
    /* the next call changes the list, which is why we iterate
     * with a temporary next pointer */
    gst_multi_handle_sink_remove_client_link (mhsink, clients);
  }
  if (mhsinkclass->hash_changed)
    mhsinkclass->hash_changed (mhsink);

  CLIENTS_UNLOCK (mhsink);
}


/* "get-stats" signal implementation
 */
GstStructure *
gst_multi_handle_sink_get_stats (GstMultiHandleSink * sink,
    GstMultiSinkHandle handle)
{
  GstMultiHandleClient *client;
  GstStructure *result = NULL;
  GList *clink;
  GstMultiHandleSink *mhsink = GST_MULTI_HANDLE_SINK (sink);
  GstMultiHandleSinkClass *mhsinkclass =
      GST_MULTI_HANDLE_SINK_GET_CLASS (mhsink);
  gchar debug[30];

  mhsinkclass->handle_debug (handle, debug);

  CLIENTS_LOCK (sink);
  clink = g_hash_table_lookup (mhsink->handle_hash,
      mhsinkclass->handle_hash_key (handle));
  if (clink == NULL)
    goto noclient;

  client = clink->data;
  if (client != NULL) {
    GstMultiHandleClient *mhclient = (GstMultiHandleClient *) client;
    guint64 interval;

    result = gst_structure_new_empty ("multihandlesink-stats");

    if (mhclient->disconnect_time == 0) {
      GTimeVal nowtv;

      g_get_current_time (&nowtv);

      interval = GST_TIMEVAL_TO_TIME (nowtv) - mhclient->connect_time;
    } else {
      interval = mhclient->disconnect_time - mhclient->connect_time;
    }

    gst_structure_set (result,
        "bytes-sent", G_TYPE_UINT64, mhclient->bytes_sent,
        "connect-time", G_TYPE_UINT64, mhclient->connect_time,
        "disconnect-time", G_TYPE_UINT64, mhclient->disconnect_time,
        "connect-duration", G_TYPE_UINT64, interval,
        "last-activitity-time", G_TYPE_UINT64, mhclient->last_activity_time,
        "buffers-dropped", G_TYPE_UINT64, mhclient->dropped_buffers,
        "first-buffer-ts", G_TYPE_UINT64, mhclient->first_buffer_ts,
        "last-buffer-ts", G_TYPE_UINT64, mhclient->last_buffer_ts, NULL);
  }

noclient:
  CLIENTS_UNLOCK (sink);

  /* python doesn't like a NULL pointer yet */
  if (result == NULL) {
    GST_WARNING_OBJECT (sink, "%s no client with this found!", debug);
    result = gst_structure_new_empty ("multihandlesink-stats");
  }

  return result;
}

/* should be called with the clientslock held.
 * Note that we don't close the fd as we didn't open it in the first
 * place. An application should connect to the client-fd-removed signal and
 * close the fd itself.
 */
void
gst_multi_handle_sink_remove_client_link (GstMultiHandleSink * sink,
    GList * link)
{
  GTimeVal now;
  GstMultiHandleClient *mhclient = (GstMultiHandleClient *) link->data;
  GstMultiHandleSinkClass *mhsinkclass = GST_MULTI_HANDLE_SINK_GET_CLASS (sink);

  if (mhclient->currently_removing) {
    GST_WARNING_OBJECT (sink, "%s client is already being removed",
        mhclient->debug);
    return;
  } else {
    mhclient->currently_removing = TRUE;
  }

  /* FIXME: if we keep track of ip we can log it here and signal */
  switch (mhclient->status) {
    case GST_CLIENT_STATUS_OK:
      GST_WARNING_OBJECT (sink, "%s removing client %p for no reason",
          mhclient->debug, mhclient);
      break;
    case GST_CLIENT_STATUS_CLOSED:
      GST_DEBUG_OBJECT (sink, "%s removing client %p because of close",
          mhclient->debug, mhclient);
      break;
    case GST_CLIENT_STATUS_REMOVED:
      GST_DEBUG_OBJECT (sink,
          "%s removing client %p because the app removed it", mhclient->debug,
          mhclient);
      break;
    case GST_CLIENT_STATUS_SLOW:
      GST_INFO_OBJECT (sink,
          "%s removing client %p because it was too slow", mhclient->debug,
          mhclient);
      break;
    case GST_CLIENT_STATUS_ERROR:
      GST_WARNING_OBJECT (sink,
          "%s removing client %p because of error", mhclient->debug, mhclient);
      break;
    case GST_CLIENT_STATUS_FLUSHING:
    default:
      GST_WARNING_OBJECT (sink,
          "%s removing client %p with invalid reason %d", mhclient->debug,
          mhclient, mhclient->status);
      break;
  }

  mhsinkclass->hash_removing (sink, mhclient);

  g_get_current_time (&now);
  mhclient->disconnect_time = GST_TIMEVAL_TO_TIME (now);

  /* free client buffers */
  g_slist_foreach (mhclient->sending, (GFunc) gst_mini_object_unref, NULL);
  g_slist_free (mhclient->sending);
  mhclient->sending = NULL;

  if (mhclient->caps)
    gst_caps_unref (mhclient->caps);
  mhclient->caps = NULL;

  /* unlock the mutex before signaling because the signal handler
   * might query some properties */
  CLIENTS_UNLOCK (sink);

  mhsinkclass->emit_client_removed (sink, mhclient->handle, mhclient->status);

  /* lock again before we remove the client completely */
  CLIENTS_LOCK (sink);

  /* handle cannot be reused in the above signal callback so we can safely
   * remove it from the hashtable here */
  if (!g_hash_table_remove (sink->handle_hash,
          mhsinkclass->handle_hash_key (mhclient->handle))) {
    GST_WARNING_OBJECT (sink,
        "%s error removing client %p from hash", mhclient->debug, mhclient);
  }
  /* after releasing the lock above, the link could be invalid, more
   * precisely, the next and prev pointers could point to invalid list
   * links. One optimisation could be to add a cookie to the linked list
   * and take a shortcut when it did not change between unlocking and locking
   * our mutex. For now we just walk the list again. */
  sink->clients = g_list_remove (sink->clients, mhclient);
  sink->clients_cookie++;

  if (mhsinkclass->removed)
    mhsinkclass->removed (sink, mhclient->handle);

  CLIENTS_UNLOCK (sink);

  /* sub-class must implement this to emit the client-$handle-removed signal */
  g_assert (mhsinkclass->client_free != NULL);

  /* and the handle is really gone now */
  mhsinkclass->client_free (sink, mhclient);

  g_free (mhclient);

  CLIENTS_LOCK (sink);
}

static gboolean
gst_multi_handle_sink_client_queue_buffer (GstMultiHandleSink * mhsink,
    GstMultiHandleClient * mhclient, GstBuffer * buffer)
{
  GstMultiHandleSink *sink = GST_MULTI_HANDLE_SINK (mhsink);
  GstCaps *caps;

  /* TRUE: send them if the new caps have them */
  gboolean send_streamheader = FALSE;
  GstStructure *s;

  /* before we queue the buffer, we check if we need to queue streamheader
   * buffers (because it's a new client, or because they changed) */
  caps = gst_pad_get_current_caps (GST_BASE_SINK_PAD (sink));

  if (!mhclient->caps) {
    GST_DEBUG_OBJECT (sink,
        "%s no previous caps for this client, send streamheader",
        mhclient->debug);
    send_streamheader = TRUE;
    mhclient->caps = gst_caps_ref (caps);
  } else {
    /* there were previous caps recorded, so compare */
    if (!gst_caps_is_equal (caps, mhclient->caps)) {
      const GValue *sh1, *sh2;

      /* caps are not equal, but could still have the same streamheader */
      s = gst_caps_get_structure (caps, 0);
      if (!gst_structure_has_field (s, "streamheader")) {
        /* no new streamheader, so nothing new to send */
        GST_DEBUG_OBJECT (sink,
            "%s new caps do not have streamheader, not sending",
            mhclient->debug);
      } else {
        /* there is a new streamheader */
        s = gst_caps_get_structure (mhclient->caps, 0);
        if (!gst_structure_has_field (s, "streamheader")) {
          /* no previous streamheader, so send the new one */
          GST_DEBUG_OBJECT (sink,
              "%s previous caps did not have streamheader, sending",
              mhclient->debug);
          send_streamheader = TRUE;
        } else {
          /* both old and new caps have streamheader set */
          if (!mhsink->resend_streamheader) {
            GST_DEBUG_OBJECT (sink,
                "%s asked to not resend the streamheader, not sending",
                mhclient->debug);
            send_streamheader = FALSE;
          } else {
            sh1 = gst_structure_get_value (s, "streamheader");
            s = gst_caps_get_structure (caps, 0);
            sh2 = gst_structure_get_value (s, "streamheader");
            if (gst_value_compare (sh1, sh2) != GST_VALUE_EQUAL) {
              GST_DEBUG_OBJECT (sink,
                  "%s new streamheader different from old, sending",
                  mhclient->debug);
              send_streamheader = TRUE;
            }
          }
        }
      }
    }
    /* Replace the old caps */
    gst_caps_unref (mhclient->caps);
    mhclient->caps = gst_caps_ref (caps);
  }

  if (G_UNLIKELY (send_streamheader)) {
    const GValue *sh;
    GArray *buffers;
    int i;

    GST_LOG_OBJECT (sink,
        "%s sending streamheader from caps %" GST_PTR_FORMAT,
        mhclient->debug, caps);
    s = gst_caps_get_structure (caps, 0);
    if (!gst_structure_has_field (s, "streamheader")) {
      GST_DEBUG_OBJECT (sink,
          "%s no new streamheader, so nothing to send", mhclient->debug);
    } else {
      GST_LOG_OBJECT (sink,
          "%s sending streamheader from caps %" GST_PTR_FORMAT,
          mhclient->debug, caps);
      sh = gst_structure_get_value (s, "streamheader");
      g_assert (G_VALUE_TYPE (sh) == GST_TYPE_ARRAY);
      buffers = g_value_peek_pointer (sh);
      GST_DEBUG_OBJECT (sink, "%d streamheader buffers", buffers->len);
      for (i = 0; i < buffers->len; ++i) {
        GValue *bufval;
        GstBuffer *buffer;

        bufval = &g_array_index (buffers, GValue, i);
        g_assert (G_VALUE_TYPE (bufval) == GST_TYPE_BUFFER);
        buffer = g_value_peek_pointer (bufval);
        GST_DEBUG_OBJECT (sink,
            "%s queueing streamheader buffer of length %" G_GSIZE_FORMAT,
            mhclient->debug, gst_buffer_get_size (buffer));
        gst_buffer_ref (buffer);

        mhclient->sending = g_slist_append (mhclient->sending, buffer);
      }
    }
  }

  gst_caps_unref (caps);
  caps = NULL;

  GST_LOG_OBJECT (sink, "%s queueing buffer of length %" G_GSIZE_FORMAT,
      mhclient->debug, gst_buffer_get_size (buffer));

  gst_buffer_ref (buffer);
  mhclient->sending = g_slist_append (mhclient->sending, buffer);

  return TRUE;
}

static gboolean
is_sync_frame (GstMultiHandleSink * sink, GstBuffer * buffer)
{
  if (GST_BUFFER_FLAG_IS_SET (buffer, GST_BUFFER_FLAG_DELTA_UNIT)) {
    return FALSE;
  } else if (!GST_BUFFER_FLAG_IS_SET (buffer, GST_BUFFER_FLAG_HEADER)) {
    return TRUE;
  }

  return FALSE;
}

/* find the keyframe in the list of buffers starting the
 * search from @idx. @direction as -1 will search backwards, 
 * 1 will search forwards.
 * Returns: the index or -1 if there is no keyframe after idx.
 */
gint
find_syncframe (GstMultiHandleSink * sink, gint idx, gint direction)
{
  gint i, len, result;

  /* take length of queued buffers */
  len = sink->bufqueue->len;

  /* assume we don't find a keyframe */
  result = -1;

  /* then loop over all buffers to find the first keyframe */
  for (i = idx; i >= 0 && i < len; i += direction) {
    GstBuffer *buf;

    buf = g_array_index (sink->bufqueue, GstBuffer *, i);
    if (is_sync_frame (sink, buf)) {
      GST_LOG_OBJECT (sink, "found keyframe at %d from %d, direction %d",
          i, idx, direction);
      result = i;
      break;
    }
  }
  return result;
}

/* Get the number of buffers from the buffer queue needed to satisfy
 * the maximum max in the configured units.
 * If units are not BUFFERS, and there are insufficient buffers in the
 * queue to satify the limit, return len(queue) + 1 */
gint
get_buffers_max (GstMultiHandleSink * sink, gint64 max)
{
  switch (sink->unit_format) {
    case GST_FORMAT_BUFFERS:
      return max;
    case GST_FORMAT_TIME:
    {
      GstBuffer *buf;
      int i;
      int len;
      gint64 diff;
      GstClockTime first = GST_CLOCK_TIME_NONE;

      len = sink->bufqueue->len;

      for (i = 0; i < len; i++) {
        buf = g_array_index (sink->bufqueue, GstBuffer *, i);
        if (GST_BUFFER_TIMESTAMP_IS_VALID (buf)) {
          if (first == -1)
            first = GST_BUFFER_TIMESTAMP (buf);

          diff = first - GST_BUFFER_TIMESTAMP (buf);

          if (diff > max)
            return i + 1;
        }
      }
      return len + 1;
    }
    case GST_FORMAT_BYTES:
    {
      GstBuffer *buf;
      int i;
      int len;
      gint acc = 0;

      len = sink->bufqueue->len;

      for (i = 0; i < len; i++) {
        buf = g_array_index (sink->bufqueue, GstBuffer *, i);
        acc += gst_buffer_get_size (buf);

        if (acc > max)
          return i + 1;
      }
      return len + 1;
    }
    default:
      return max;
  }
}

/* find the positions in the buffer queue where *_min and *_max
 * is satisfied
 */
/* count the amount of data in the buffers and return the index
 * that satifies the given limits.
 *
 * Returns: index @idx in the buffer queue so that the given limits are
 * satisfied. TRUE if all the limits could be satisfied, FALSE if not
 * enough data was in the queue.
 *
 * FIXME, this code might now work if any of the units is in buffers...
 */
gboolean
find_limits (GstMultiHandleSink * sink,
    gint * min_idx, gint bytes_min, gint buffers_min, gint64 time_min,
    gint * max_idx, gint bytes_max, gint buffers_max, gint64 time_max)
{
  GstClockTime first, time;
  gint i, len, bytes;
  gboolean result, max_hit;

  /* take length of queue */
  len = sink->bufqueue->len;

  /* this must hold */
  g_assert (len > 0);

  GST_LOG_OBJECT (sink,
      "bytes_min %d, buffers_min %d, time_min %" GST_TIME_FORMAT
      ", bytes_max %d, buffers_max %d, time_max %" GST_TIME_FORMAT, bytes_min,
      buffers_min, GST_TIME_ARGS (time_min), bytes_max, buffers_max,
      GST_TIME_ARGS (time_max));

  /* do the trivial buffer limit test */
  if (buffers_min != -1 && len < buffers_min) {
    *min_idx = len - 1;
    *max_idx = len - 1;
    return FALSE;
  }

  result = FALSE;
  /* else count bytes and time */
  first = -1;
  bytes = 0;
  /* unset limits */
  *min_idx = -1;
  *max_idx = -1;
  max_hit = FALSE;

  i = 0;
  /* loop through the buffers, when a limit is ok, mark it 
   * as -1, we have at least one buffer in the queue. */
  do {
    GstBuffer *buf;

    /* if we checked all min limits, update result */
    if (bytes_min == -1 && time_min == -1 && *min_idx == -1) {
      /* don't go below 0 */
      *min_idx = MAX (i - 1, 0);
    }
    /* if we reached one max limit break out */
    if (max_hit) {
      /* i > 0 when we get here, we subtract one to get the position
       * of the previous buffer. */
      *max_idx = i - 1;
      /* we have valid complete result if we found a min_idx too */
      result = *min_idx != -1;
      break;
    }
    buf = g_array_index (sink->bufqueue, GstBuffer *, i);

    bytes += gst_buffer_get_size (buf);

    /* take timestamp and save for the base first timestamp */
    if ((time = GST_BUFFER_TIMESTAMP (buf)) != -1) {
      GST_LOG_OBJECT (sink, "Ts %" GST_TIME_FORMAT " on buffer",
          GST_TIME_ARGS (time));
      if (first == -1)
        first = time;

      /* increase max usage if we did not fill enough. Note that
       * buffers are sorted from new to old, so the first timestamp is
       * bigger than the next one. */
      if (time_min != -1 && first - time >= time_min)
        time_min = -1;
      if (time_max != -1 && first - time >= time_max)
        max_hit = TRUE;
    } else {
      GST_LOG_OBJECT (sink, "No timestamp on buffer");
    }
    /* time is OK or unknown, check and increase if not enough bytes */
    if (bytes_min != -1) {
      if (bytes >= bytes_min)
        bytes_min = -1;
    }
    if (bytes_max != -1) {
      if (bytes >= bytes_max) {
        max_hit = TRUE;
      }
    }
    i++;
  }
  while (i < len);

  /* if we did not hit the max or min limit, set to buffer size */
  if (*max_idx == -1)
    *max_idx = len - 1;
  /* make sure min does not exceed max */
  if (*min_idx == -1)
    *min_idx = *max_idx;

  return result;
}

/* parse the unit/value pair and assign it to the result value of the
 * right type, leave the other values untouched 
 *
 * Returns: FALSE if the unit is unknown or undefined. TRUE otherwise.
 */
static gboolean
assign_value (GstFormat format, guint64 value, gint * bytes, gint * buffers,
    GstClockTime * time)
{
  gboolean res = TRUE;

  /* set only the limit of the given format to the given value */
  switch (format) {
    case GST_FORMAT_BUFFERS:
      *buffers = (gint) value;
      break;
    case GST_FORMAT_TIME:
      *time = value;
      break;
    case GST_FORMAT_BYTES:
      *bytes = (gint) value;
      break;
    case GST_FORMAT_UNDEFINED:
    default:
      res = FALSE;
      break;
  }
  return res;
}

/* count the index in the buffer queue to satisfy the given unit
 * and value pair starting from buffer at index 0.
 *
 * Returns: TRUE if there was enough data in the queue to satisfy the
 * burst values. @idx contains the index in the buffer that contains enough
 * data to satisfy the limits or the last buffer in the queue when the
 * function returns FALSE.
 */
static gboolean
count_burst_unit (GstMultiHandleSink * sink, gint * min_idx,
    GstFormat min_format, guint64 min_value, gint * max_idx,
    GstFormat max_format, guint64 max_value)
{
  gint bytes_min = -1, buffers_min = -1;
  gint bytes_max = -1, buffers_max = -1;
  GstClockTime time_min = GST_CLOCK_TIME_NONE, time_max = GST_CLOCK_TIME_NONE;

  assign_value (min_format, min_value, &bytes_min, &buffers_min, &time_min);
  assign_value (max_format, max_value, &bytes_max, &buffers_max, &time_max);

  return find_limits (sink, min_idx, bytes_min, buffers_min, time_min,
      max_idx, bytes_max, buffers_max, time_max);
}

/* decide where in the current buffer queue this new client should start
 * receiving buffers from.
 * This function is called whenever a client is connected and has not yet
 * received a buffer.
 * If this returns -1, it means that we haven't found a good point to
 * start streaming from yet, and this function should be called again later
 * when more buffers have arrived.
 */
gint
gst_multi_handle_sink_new_client_position (GstMultiHandleSink * sink,
    GstMultiHandleClient * client)
{
  gint result;

  GST_DEBUG_OBJECT (sink,
      "%s new client, deciding where to start in queue", client->debug);
  GST_DEBUG_OBJECT (sink, "queue is currently %d buffers long",
      sink->bufqueue->len);
  switch (client->sync_method) {
    case GST_SYNC_METHOD_LATEST:
      /* no syncing, we are happy with whatever the client is going to get */
      result = client->bufpos;
      GST_DEBUG_OBJECT (sink,
          "%s SYNC_METHOD_LATEST, position %d", client->debug, result);
      break;
    case GST_SYNC_METHOD_NEXT_KEYFRAME:
    {
      /* if one of the new buffers (between client->bufpos and 0) in the queue
       * is a sync point, we can proceed, otherwise we need to keep waiting */
      GST_LOG_OBJECT (sink,
          "%s new client, bufpos %d, waiting for keyframe",
          client->debug, client->bufpos);

      result = find_prev_syncframe (sink, client->bufpos);
      if (result != -1) {
        GST_DEBUG_OBJECT (sink,
            "%s SYNC_METHOD_NEXT_KEYFRAME: result %d", client->debug, result);
        break;
      }

      /* client is not on a syncbuffer, need to skip these buffers and
       * wait some more */
      GST_LOG_OBJECT (sink,
          "%s new client, skipping buffer(s), no syncpoint found",
          client->debug);
      client->bufpos = -1;
      break;
    }
    case GST_SYNC_METHOD_LATEST_KEYFRAME:
    {
      GST_DEBUG_OBJECT (sink, "%s SYNC_METHOD_LATEST_KEYFRAME", client->debug);

      /* for new clients we initially scan the complete buffer queue for
       * a sync point when a buffer is added. If we don't find a keyframe,
       * we need to wait for the next keyframe and so we change the client's
       * sync method to GST_SYNC_METHOD_NEXT_KEYFRAME.
       */
      result = find_next_syncframe (sink, 0);
      if (result != -1) {
        GST_DEBUG_OBJECT (sink,
            "%s SYNC_METHOD_LATEST_KEYFRAME: result %d", client->debug, result);
        break;
      }

      GST_DEBUG_OBJECT (sink,
          "%s SYNC_METHOD_LATEST_KEYFRAME: no keyframe found, "
          "switching to SYNC_METHOD_NEXT_KEYFRAME", client->debug);
      /* throw client to the waiting state */
      client->bufpos = -1;
      /* and make client sync to next keyframe */
      client->sync_method = GST_SYNC_METHOD_NEXT_KEYFRAME;
      break;
    }
    case GST_SYNC_METHOD_BURST:
    {
      gboolean ok;
      gint max;

      /* move to the position where we satisfy the client's burst
       * parameters. If we could not satisfy the parameters because there
       * is not enough data, we just send what we have (which is in result).
       * We use the max value to limit the search
       */
      ok = count_burst_unit (sink, &result, client->burst_min_format,
          client->burst_min_value, &max, client->burst_max_format,
          client->burst_max_value);
      GST_DEBUG_OBJECT (sink,
          "%s SYNC_METHOD_BURST: burst_unit returned %d, result %d",
          client->debug, ok, result);

      GST_LOG_OBJECT (sink, "min %d, max %d", result, max);

      /* we hit the max and it is below the min, use that then */
      if (max != -1 && max <= result) {
        result = MAX (max - 1, 0);
        GST_DEBUG_OBJECT (sink,
            "%s SYNC_METHOD_BURST: result above max, taken down to %d",
            client->debug, result);
      }
      break;
    }
    case GST_SYNC_METHOD_BURST_KEYFRAME:
    {
      gint min_idx, max_idx;
      gint next_syncframe, prev_syncframe;

      /* BURST_KEYFRAME:
       *
       * _always_ start sending a keyframe to the client. We first search
       * a keyframe between min/max limits. If there is none, we send it the
       * last keyframe before min. If there is none, the behaviour is like
       * NEXT_KEYFRAME.
       */
      /* gather burst limits */
      count_burst_unit (sink, &min_idx, client->burst_min_format,
          client->burst_min_value, &max_idx, client->burst_max_format,
          client->burst_max_value);

      GST_LOG_OBJECT (sink, "min %d, max %d", min_idx, max_idx);

      /* first find a keyframe after min_idx */
      next_syncframe = find_next_syncframe (sink, min_idx);
      if (next_syncframe != -1 && next_syncframe < max_idx) {
        /* we have a valid keyframe and it's below the max */
        GST_LOG_OBJECT (sink, "found keyframe in min/max limits");
        result = next_syncframe;
        break;
      }

      /* no valid keyframe, try to find one below min */
      prev_syncframe = find_prev_syncframe (sink, min_idx);
      if (prev_syncframe != -1) {
        GST_WARNING_OBJECT (sink,
            "using keyframe below min in BURST_KEYFRAME sync mode");
        result = prev_syncframe;
        break;
      }

      /* no prev keyframe or not enough data  */
      GST_WARNING_OBJECT (sink,
          "no prev keyframe found in BURST_KEYFRAME sync mode, waiting for next");

      /* throw client to the waiting state */
      client->bufpos = -1;
      /* and make client sync to next keyframe */
      client->sync_method = GST_SYNC_METHOD_NEXT_KEYFRAME;
      result = -1;
      break;
    }
    case GST_SYNC_METHOD_BURST_WITH_KEYFRAME:
    {
      gint min_idx, max_idx;
      gint next_syncframe;

      /* BURST_WITH_KEYFRAME:
       *
       * try to start sending a keyframe to the client. We first search
       * a keyframe between min/max limits. If there is none, we send it the
       * amount of data up 'till min.
       */
      /* gather enough data to burst */
      count_burst_unit (sink, &min_idx, client->burst_min_format,
          client->burst_min_value, &max_idx, client->burst_max_format,
          client->burst_max_value);

      GST_LOG_OBJECT (sink, "min %d, max %d", min_idx, max_idx);

      /* first find a keyframe after min_idx */
      next_syncframe = find_next_syncframe (sink, min_idx);
      if (next_syncframe != -1 && next_syncframe < max_idx) {
        /* we have a valid keyframe and it's below the max */
        GST_LOG_OBJECT (sink, "found keyframe in min/max limits");
        result = next_syncframe;
        break;
      }

      /* no keyframe, send data from min_idx */
      GST_WARNING_OBJECT (sink, "using min in BURST_WITH_KEYFRAME sync mode");

      /* make sure we don't go over the max limit */
      if (max_idx != -1 && max_idx <= min_idx) {
        result = MAX (max_idx - 1, 0);
      } else {
        result = min_idx;
      }

      break;
    }
    default:
      g_warning ("unknown sync method %d", client->sync_method);
      result = client->bufpos;
      break;
  }
  return result;
}

/* calculate the new position for a client after recovery. This function
 * does not update the client position but merely returns the required
 * position.
 */
gint
gst_multi_handle_sink_recover_client (GstMultiHandleSink * sink,
    GstMultiHandleClient * client)
{
  gint newbufpos;

  GST_WARNING_OBJECT (sink,
      "%s client %p is lagging at %d, recover using policy %d",
      client->debug, client, client->bufpos, sink->recover_policy);

  switch (sink->recover_policy) {
    case GST_RECOVER_POLICY_NONE:
      /* do nothing, client will catch up or get kicked out when it reaches
       * the hard max */
      newbufpos = client->bufpos;
      break;
    case GST_RECOVER_POLICY_RESYNC_LATEST:
      /* move to beginning of queue */
      newbufpos = -1;
      break;
    case GST_RECOVER_POLICY_RESYNC_SOFT_LIMIT:
      /* move to beginning of soft max */
      newbufpos = get_buffers_max (sink, sink->units_soft_max);
      break;
    case GST_RECOVER_POLICY_RESYNC_KEYFRAME:
      /* find keyframe in buffers, we search backwards to find the
       * closest keyframe relative to what this client already received. */
      newbufpos = MIN (sink->bufqueue->len - 1,
          get_buffers_max (sink, sink->units_soft_max) - 1);

      while (newbufpos >= 0) {
        GstBuffer *buf;

        buf = g_array_index (sink->bufqueue, GstBuffer *, newbufpos);
        if (is_sync_frame (sink, buf)) {
          /* found a buffer that is not a delta unit */
          break;
        }
        newbufpos--;
      }
      break;
    default:
      /* unknown recovery procedure */
      newbufpos = get_buffers_max (sink, sink->units_soft_max);
      break;
  }
  return newbufpos;
}

/* Queue a buffer on the global queue.
 *
 * This function adds the buffer to the front of a GArray. It removes the
 * tail buffer if the max queue size is exceeded, unreffing the queued buffer.
 * Note that unreffing the buffer is not a problem as clients who
 * started writing out this buffer will still have a reference to it in the
 * mhclient->sending queue.
 *
 * After adding the buffer, we update all client positions in the queue. If
 * a client moves over the soft max, we start the recovery procedure for this
 * slow client. If it goes over the hard max, it is put into the slow list
 * and removed.
 *
 * Special care is taken of clients that were waiting for a new buffer (they
 * had a position of -1) because they can proceed after adding this new buffer.
 * This is done by adding the client back into the write fd_set and signaling
 * the select thread that the fd_set changed.
 */
static void
gst_multi_handle_sink_queue_buffer (GstMultiHandleSink * mhsink,
    GstBuffer * buffer)
{
  GList *clients, *next;
  gint queuelen;
  gboolean hash_changed = FALSE;
  gint max_buffer_usage;
  gint i;
  GTimeVal nowtv;
  GstClockTime now;
  gint max_buffers, soft_max_buffers;
  guint cookie;
  GstMultiHandleSink *sink = GST_MULTI_HANDLE_SINK (mhsink);
  GstMultiHandleSinkClass *mhsinkclass =
      GST_MULTI_HANDLE_SINK_GET_CLASS (mhsink);

  CLIENTS_LOCK (mhsink);
  /* add buffer to queue */
  g_array_prepend_val (mhsink->bufqueue, buffer);
  queuelen = mhsink->bufqueue->len;

  if (mhsink->units_max > 0)
    max_buffers = get_buffers_max (mhsink, mhsink->units_max);
  else
    max_buffers = -1;

  if (mhsink->units_soft_max > 0)
    soft_max_buffers = get_buffers_max (mhsink, mhsink->units_soft_max);
  else
    soft_max_buffers = -1;
  GST_LOG_OBJECT (sink, "Using max %d, softmax %d", max_buffers,
      soft_max_buffers);

  /* then loop over the clients and update the positions */
  max_buffer_usage = 0;

restart:
  cookie = mhsink->clients_cookie;
  for (clients = mhsink->clients; clients; clients = next) {
    GstMultiHandleClient *mhclient = clients->data;

    g_get_current_time (&nowtv);
    now = GST_TIMEVAL_TO_TIME (nowtv);

    if (cookie != mhsink->clients_cookie) {
      GST_DEBUG_OBJECT (sink, "Clients cookie outdated, restarting");
      goto restart;
    }

    next = g_list_next (clients);

    mhclient->bufpos++;
    GST_LOG_OBJECT (sink, "%s client %p at position %d",
        mhclient->debug, mhclient, mhclient->bufpos);
    /* check soft max if needed, recover client */
    if (soft_max_buffers > 0 && mhclient->bufpos >= soft_max_buffers) {
      gint newpos;

      newpos = gst_multi_handle_sink_recover_client (mhsink, mhclient);
      if (newpos != mhclient->bufpos) {
        mhclient->dropped_buffers += mhclient->bufpos - newpos;
        mhclient->bufpos = newpos;
        mhclient->discont = TRUE;
        GST_INFO_OBJECT (sink, "%s client %p position reset to %d",
            mhclient->debug, mhclient, mhclient->bufpos);
      } else {
        GST_INFO_OBJECT (sink,
            "%s client %p not recovering position", mhclient->debug, mhclient);
      }
    }
    /* check hard max and timeout, remove client */
    if ((max_buffers > 0 && mhclient->bufpos >= max_buffers) ||
        (mhsink->timeout > 0
            && now - mhclient->last_activity_time > mhsink->timeout)) {
      /* remove client */
      GST_WARNING_OBJECT (sink, "%s client %p is too slow, removing",
          mhclient->debug, mhclient);
      /* remove the client, the handle set will be cleared and the select thread
       * will be signaled */
      mhclient->status = GST_CLIENT_STATUS_SLOW;
      /* set client to invalid position while being removed */
      mhclient->bufpos = -1;
      gst_multi_handle_sink_remove_client_link (mhsink, clients);
      hash_changed = TRUE;
      continue;
    } else if (mhclient->bufpos == 0 || mhclient->new_connection) {
      /* can send data to this client now. need to signal the select thread that
       * the handle_set changed */
      mhsinkclass->hash_adding (mhsink, mhclient);
      hash_changed = TRUE;
    }
    /* keep track of maximum buffer usage */
    if (mhclient->bufpos > max_buffer_usage) {
      max_buffer_usage = mhclient->bufpos;
    }
  }

  /* make sure we respect bytes-min, buffers-min and time-min when they are set */
  {
    gint usage, max;

    GST_LOG_OBJECT (sink,
        "extending queue %d to respect time_min %" GST_TIME_FORMAT
        ", bytes_min %d, buffers_min %d", max_buffer_usage,
        GST_TIME_ARGS (mhsink->time_min), mhsink->bytes_min,
        mhsink->buffers_min);

    /* get index where the limits are ok, we don't really care if all limits
     * are ok, we just queue as much as we need. We also don't compare against
     * the max limits. */
    find_limits (mhsink, &usage, mhsink->bytes_min, mhsink->buffers_min,
        mhsink->time_min, &max, -1, -1, -1);

    max_buffer_usage = MAX (max_buffer_usage, usage + 1);
    GST_LOG_OBJECT (sink, "extended queue to %d", max_buffer_usage);
  }

  /* now look for sync points and make sure there is at least one
   * sync point in the queue. We only do this if the LATEST_KEYFRAME or 
   * BURST_KEYFRAME mode is selected */
  if (mhsink->def_sync_method == GST_SYNC_METHOD_LATEST_KEYFRAME ||
      mhsink->def_sync_method == GST_SYNC_METHOD_BURST_KEYFRAME) {
    /* no point in searching beyond the queue length */
    gint limit = queuelen;
    GstBuffer *buf;

    /* no point in searching beyond the soft-max if any. */
    if (soft_max_buffers > 0) {
      limit = MIN (limit, soft_max_buffers);
    }
    GST_LOG_OBJECT (sink,
        "extending queue to include sync point, now at %d, limit is %d",
        max_buffer_usage, limit);
    for (i = 0; i < limit; i++) {
      buf = g_array_index (mhsink->bufqueue, GstBuffer *, i);
      if (is_sync_frame (mhsink, buf)) {
        /* found a sync frame, now extend the buffer usage to
         * include at least this frame. */
        max_buffer_usage = MAX (max_buffer_usage, i);
        break;
      }
    }
    GST_LOG_OBJECT (sink, "max buffer usage is now %d", max_buffer_usage);
  }

  GST_LOG_OBJECT (sink, "len %d, usage %d", queuelen, max_buffer_usage);

  /* nobody is referencing units after max_buffer_usage so we can
   * remove them from the queue. We remove them in reverse order as
   * this is the most optimal for GArray. */
  for (i = queuelen - 1; i > max_buffer_usage; i--) {
    GstBuffer *old;

    /* queue exceeded max size */
    queuelen--;
    old = g_array_index (mhsink->bufqueue, GstBuffer *, i);
    mhsink->bufqueue = g_array_remove_index (mhsink->bufqueue, i);

    /* unref tail buffer */
    gst_buffer_unref (old);
  }
  /* save for stats */
  mhsink->buffers_queued = max_buffer_usage;
  CLIENTS_UNLOCK (sink);

  /* and send a signal to thread if handle_set changed */
  if (hash_changed && mhsinkclass->hash_changed) {
    mhsinkclass->hash_changed (mhsink);
  }
}

static GstFlowReturn
gst_multi_handle_sink_render (GstBaseSink * bsink, GstBuffer * buf)
{
  gboolean in_caps;
#if 0
  GstCaps *bufcaps, *padcaps;
#endif

  GstMultiHandleSink *sink = GST_MULTI_HANDLE_SINK (bsink);

  g_return_val_if_fail (GST_OBJECT_FLAG_IS_SET (sink,
          GST_MULTI_HANDLE_SINK_OPEN), GST_FLOW_FLUSHING);

#if 0
  /* since we check every buffer for streamheader caps, we need to make
   * sure every buffer has caps set */
  bufcaps = gst_buffer_get_caps (buf);
  padcaps = GST_PAD_CAPS (GST_BASE_SINK_PAD (bsink));

  /* make sure we have caps on the pad */
  if (!padcaps && !bufcaps)
    goto no_caps;
#endif

  /* get IN_CAPS first, code below might mess with the flags */
  in_caps = GST_BUFFER_FLAG_IS_SET (buf, GST_BUFFER_FLAG_HEADER);

#if 0
  /* stamp the buffer with previous caps if no caps set */
  if (!bufcaps) {
    if (!gst_buffer_is_writable (buf)) {
      /* metadata is not writable, copy will be made and original buffer
       * will be unreffed so we need to ref so that we don't lose the
       * buffer in the render method. */
      gst_buffer_ref (buf);
      /* the new buffer is ours only, we keep it out of the scope of this
       * function */
      buf = gst_buffer_make_writable (buf);
    } else {
      /* else the metadata is writable, we ref because we keep the buffer
       * out of the scope of this method */
      gst_buffer_ref (buf);
    }
    /* buffer metadata is writable now, set the caps */
    gst_buffer_set_caps (buf, padcaps);
  } else {
    gst_caps_unref (bufcaps);

    /* since we keep this buffer out of the scope of this method */
    gst_buffer_ref (buf);
  }
#endif
  gst_buffer_ref (buf);

  GST_LOG_OBJECT (sink, "received buffer %p, in_caps: %s, offset %"
      G_GINT64_FORMAT ", offset_end %" G_GINT64_FORMAT
      ", timestamp %" GST_TIME_FORMAT ", duration %" GST_TIME_FORMAT,
      buf, in_caps ? "yes" : "no", GST_BUFFER_OFFSET (buf),
      GST_BUFFER_OFFSET_END (buf),
      GST_TIME_ARGS (GST_BUFFER_TIMESTAMP (buf)),
      GST_TIME_ARGS (GST_BUFFER_DURATION (buf)));

  /* if we get IN_CAPS buffers, but the previous buffer was not IN_CAPS,
   * it means we're getting new streamheader buffers, and we should clear
   * the old ones */
  if (in_caps && sink->previous_buffer_in_caps == FALSE) {
    GST_DEBUG_OBJECT (sink,
        "receiving new HEADER buffers, clearing old streamheader");
    g_slist_foreach (sink->streamheader, (GFunc) gst_mini_object_unref, NULL);
    g_slist_free (sink->streamheader);
    sink->streamheader = NULL;
  }

  /* save the current in_caps */
  sink->previous_buffer_in_caps = in_caps;

  /* if the incoming buffer is marked as IN CAPS, then we assume for now
   * it's a streamheader that needs to be sent to each new client, so we
   * put it on our internal list of streamheader buffers.
   * FIXME: we could check if the buffer's contents are in fact part of the
   * current streamheader.
   *
   * We don't send the buffer to the client, since streamheaders are sent
   * separately when necessary. */
  if (in_caps) {
    GST_DEBUG_OBJECT (sink, "appending HEADER buffer with length %"
        G_GSIZE_FORMAT " to streamheader", gst_buffer_get_size (buf));
    sink->streamheader = g_slist_append (sink->streamheader, buf);
  } else {
    /* queue the buffer, this is a regular data buffer. */
    gst_multi_handle_sink_queue_buffer (sink, buf);

    sink->bytes_to_serve += gst_buffer_get_size (buf);
  }
  return GST_FLOW_OK;

  /* ERRORS */
#if 0
no_caps:
  {
    GST_ELEMENT_ERROR (sink, CORE, NEGOTIATION, (NULL),
        ("Received first buffer without caps set"));
    return GST_FLOW_NOT_NEGOTIATED;
  }
#endif
}

static void
gst_multi_handle_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstMultiHandleSink *multihandlesink;

  multihandlesink = GST_MULTI_HANDLE_SINK (object);

  switch (prop_id) {
    case PROP_BUFFERS_MAX:
      multihandlesink->units_max = g_value_get_int (value);
      break;
    case PROP_BUFFERS_SOFT_MAX:
      multihandlesink->units_soft_max = g_value_get_int (value);
      break;
    case PROP_TIME_MIN:
      multihandlesink->time_min = g_value_get_int64 (value);
      break;
    case PROP_BYTES_MIN:
      multihandlesink->bytes_min = g_value_get_int (value);
      break;
    case PROP_BUFFERS_MIN:
      multihandlesink->buffers_min = g_value_get_int (value);
      break;
    case PROP_UNIT_FORMAT:
      multihandlesink->unit_format = g_value_get_enum (value);
      break;
    case PROP_UNITS_MAX:
      multihandlesink->units_max = g_value_get_int64 (value);
      break;
    case PROP_UNITS_SOFT_MAX:
      multihandlesink->units_soft_max = g_value_get_int64 (value);
      break;
    case PROP_RECOVER_POLICY:
      multihandlesink->recover_policy = g_value_get_enum (value);
      break;
    case PROP_TIMEOUT:
      multihandlesink->timeout = g_value_get_uint64 (value);
      break;
    case PROP_SYNC_METHOD:
      multihandlesink->def_sync_method = g_value_get_enum (value);
      break;
    case PROP_BURST_FORMAT:
      multihandlesink->def_burst_format = g_value_get_enum (value);
      break;
    case PROP_BURST_VALUE:
      multihandlesink->def_burst_value = g_value_get_uint64 (value);
      break;
    case PROP_QOS_DSCP:
      multihandlesink->qos_dscp = g_value_get_int (value);
      gst_multi_handle_sink_setup_dscp (multihandlesink);
      break;

    case PROP_RESEND_STREAMHEADER:
      multihandlesink->resend_streamheader = g_value_get_boolean (value);
      break;

    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_multi_handle_sink_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstMultiHandleSink *multihandlesink;

  multihandlesink = GST_MULTI_HANDLE_SINK (object);

  switch (prop_id) {
    case PROP_BUFFERS_MAX:
      g_value_set_int (value, multihandlesink->units_max);
      break;
    case PROP_BUFFERS_SOFT_MAX:
      g_value_set_int (value, multihandlesink->units_soft_max);
      break;
    case PROP_TIME_MIN:
      g_value_set_int64 (value, multihandlesink->time_min);
      break;
    case PROP_BYTES_MIN:
      g_value_set_int (value, multihandlesink->bytes_min);
      break;
    case PROP_BUFFERS_MIN:
      g_value_set_int (value, multihandlesink->buffers_min);
      break;
    case PROP_BUFFERS_QUEUED:
      g_value_set_uint (value, multihandlesink->buffers_queued);
      break;
    case PROP_BYTES_QUEUED:
      g_value_set_uint (value, multihandlesink->bytes_queued);
      break;
    case PROP_TIME_QUEUED:
      g_value_set_uint64 (value, multihandlesink->time_queued);
      break;
    case PROP_UNIT_FORMAT:
      g_value_set_enum (value, multihandlesink->unit_format);
      break;
    case PROP_UNITS_MAX:
      g_value_set_int64 (value, multihandlesink->units_max);
      break;
    case PROP_UNITS_SOFT_MAX:
      g_value_set_int64 (value, multihandlesink->units_soft_max);
      break;
    case PROP_RECOVER_POLICY:
      g_value_set_enum (value, multihandlesink->recover_policy);
      break;
    case PROP_TIMEOUT:
      g_value_set_uint64 (value, multihandlesink->timeout);
      break;
    case PROP_SYNC_METHOD:
      g_value_set_enum (value, multihandlesink->def_sync_method);
      break;
    case PROP_BYTES_TO_SERVE:
      g_value_set_uint64 (value, multihandlesink->bytes_to_serve);
      break;
    case PROP_BYTES_SERVED:
      g_value_set_uint64 (value, multihandlesink->bytes_served);
      break;
    case PROP_BURST_FORMAT:
      g_value_set_enum (value, multihandlesink->def_burst_format);
      break;
    case PROP_BURST_VALUE:
      g_value_set_uint64 (value, multihandlesink->def_burst_value);
      break;
    case PROP_QOS_DSCP:
      g_value_set_int (value, multihandlesink->qos_dscp);
      break;
    case PROP_RESEND_STREAMHEADER:
      g_value_set_boolean (value, multihandlesink->resend_streamheader);
      break;
    case PROP_NUM_HANDLES:
      g_value_set_uint (value,
          g_hash_table_size (multihandlesink->handle_hash));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

/* create a socket for sending to remote machine */
static gboolean
gst_multi_handle_sink_start (GstBaseSink * bsink)
{
  GstMultiHandleSinkClass *mhsclass;
  GstMultiHandleSink *mhsink;

  if (GST_OBJECT_FLAG_IS_SET (bsink, GST_MULTI_HANDLE_SINK_OPEN))
    return TRUE;

  mhsink = GST_MULTI_HANDLE_SINK (bsink);
  mhsclass = GST_MULTI_HANDLE_SINK_GET_CLASS (mhsink);

  if (!mhsclass->start_pre (mhsink))
    return FALSE;

  mhsink->streamheader = NULL;
  mhsink->bytes_to_serve = 0;
  mhsink->bytes_served = 0;

  if (mhsclass->init) {
    mhsclass->init (mhsink);
  }

  mhsink->running = TRUE;

  mhsink->thread = g_thread_new ("multihandlesink",
      (GThreadFunc) mhsclass->thread, mhsink);

  GST_OBJECT_FLAG_SET (bsink, GST_MULTI_HANDLE_SINK_OPEN);

  return TRUE;
}

static gboolean
gst_multi_handle_sink_stop (GstBaseSink * bsink)
{
  GstMultiHandleSinkClass *mhclass;
  GstBuffer *buf;
  gint i;
  GstMultiHandleSink *mhsink = GST_MULTI_HANDLE_SINK (bsink);

  mhclass = GST_MULTI_HANDLE_SINK_GET_CLASS (mhsink);

  if (!GST_OBJECT_FLAG_IS_SET (bsink, GST_MULTI_HANDLE_SINK_OPEN))
    return TRUE;

  mhsink->running = FALSE;

  mhclass->stop_pre (mhsink);

  if (mhsink->thread) {
    GST_DEBUG_OBJECT (mhsink, "joining thread");
    g_thread_join (mhsink->thread);
    GST_DEBUG_OBJECT (mhsink, "joined thread");
    mhsink->thread = NULL;
  }

  /* free the clients */
  mhclass->clear (GST_MULTI_HANDLE_SINK (mhsink));

  if (mhsink->streamheader) {
    g_slist_foreach (mhsink->streamheader, (GFunc) gst_mini_object_unref, NULL);
    g_slist_free (mhsink->streamheader);
    mhsink->streamheader = NULL;
  }

  if (mhclass->close)
    mhclass->close (mhsink);

  mhclass->stop_post (mhsink);

  /* remove all queued buffers */
  if (mhsink->bufqueue) {
    GST_DEBUG_OBJECT (mhsink, "Emptying bufqueue with %d buffers",
        mhsink->bufqueue->len);
    for (i = mhsink->bufqueue->len - 1; i >= 0; --i) {
      buf = g_array_index (mhsink->bufqueue, GstBuffer *, i);
      GST_LOG_OBJECT (mhsink, "Removing buffer %p (%d) with refcount %d", buf,
          i, GST_MINI_OBJECT_REFCOUNT (buf));
      gst_buffer_unref (buf);
      mhsink->bufqueue = g_array_remove_index (mhsink->bufqueue, i);
    }
    /* freeing the array is done in _finalize */
  }
  GST_OBJECT_FLAG_UNSET (mhsink, GST_MULTI_HANDLE_SINK_OPEN);

  return TRUE;
}

static GstStateChangeReturn
gst_multi_handle_sink_change_state (GstElement * element,
    GstStateChange transition)
{
  GstMultiHandleSink *sink;
  GstStateChangeReturn ret;

  sink = GST_MULTI_HANDLE_SINK (element);

  /* we disallow changing the state from the streaming thread */
  if (g_thread_self () == sink->thread)
    return GST_STATE_CHANGE_FAILURE;


  switch (transition) {
    case GST_STATE_CHANGE_NULL_TO_READY:
      if (!gst_multi_handle_sink_start (GST_BASE_SINK (sink)))
        goto start_failed;
      break;
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      break;
    case GST_STATE_CHANGE_PAUSED_TO_PLAYING:
      break;
    default:
      break;
  }

  ret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);

  switch (transition) {
    case GST_STATE_CHANGE_PLAYING_TO_PAUSED:
      break;
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      break;
    case GST_STATE_CHANGE_READY_TO_NULL:
      gst_multi_handle_sink_stop (GST_BASE_SINK (sink));
      break;
    default:
      break;
  }
  return ret;

  /* ERRORS */
start_failed:
  {
    /* error message was posted */
    return GST_STATE_CHANGE_FAILURE;
  }
}
