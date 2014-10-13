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
 * SECTION:element-multisocketsink
 * @see_also: tcpserversink
 *
 * This plugin writes incoming data to a set of file descriptors. The
 * file descriptors can be added to multisocketsink by emitting the #GstMultiSocketSink::add signal. 
 * For each descriptor added, the #GstMultiSocketSink::client-added signal will be called.
 *
 * A client can also be added with the #GstMultiSocketSink::add-full signal
 * that allows for more control over what and how much data a client 
 * initially receives.
 *
 * Clients can be removed from multisocketsink by emitting the #GstMultiSocketSink::remove signal. For
 * each descriptor removed, the #GstMultiSocketSink::client-removed signal will be called. The
 * #GstMultiSocketSink::client-removed signal can also be fired when multisocketsink decides that a
 * client is not active anymore or, depending on the value of the
 * #GstMultiSocketSink:recover-policy property, if the client is reading too slowly.
 * In all cases, multisocketsink will never close a file descriptor itself.
 * The user of multisocketsink is responsible for closing all file descriptors.
 * This can for example be done in response to the #GstMultiSocketSink::client-fd-removed signal.
 * Note that multisocketsink still has a reference to the file descriptor when the
 * #GstMultiSocketSink::client-removed signal is emitted, so that "get-stats" can be performed on
 * the descriptor; it is therefore not safe to close the file descriptor in
 * the #GstMultiSocketSink::client-removed signal handler, and you should use the 
 * #GstMultiSocketSink::client-fd-removed signal to safely close the fd.
 *
 * Multisocketsink internally keeps a queue of the incoming buffers and uses a
 * separate thread to send the buffers to the clients. This ensures that no
 * client write can block the pipeline and that clients can read with different
 * speeds.
 *
 * When adding a client to multisocketsink, the #GstMultiSocketSink:sync-method property will define
 * which buffer in the queued buffers will be sent first to the client. Clients 
 * can be sent the most recent buffer (which might not be decodable by the 
 * client if it is not a keyframe), the next keyframe received in 
 * multisocketsink (which can take some time depending on the keyframe rate), or the
 * last received keyframe (which will cause a simple burst-on-connect). 
 * Multisocketsink will always keep at least one keyframe in its internal buffers
 * when the sync-mode is set to latest-keyframe.
 *
 * There are additional values for the #GstMultiSocketSink:sync-method
 * property to allow finer control over burst-on-connect behaviour. By selecting
 * the 'burst' method a minimum burst size can be chosen, 'burst-keyframe'
 * additionally requires that the burst begin with a keyframe, and 
 * 'burst-with-keyframe' attempts to burst beginning with a keyframe, but will
 * prefer a minimum burst size even if it requires not starting with a keyframe.
 *
 * Multisocketsink can be instructed to keep at least a minimum amount of data
 * expressed in time or byte units in its internal queues with the 
 * #GstMultiSocketSink:time-min and #GstMultiSocketSink:bytes-min properties respectively.
 * These properties are useful if the application adds clients with the 
 * #GstMultiSocketSink::add-full signal to make sure that a burst connect can
 * actually be honored. 
 *
 * When streaming data, clients are allowed to read at a different rate than
 * the rate at which multisocketsink receives data. If the client is reading too
 * fast, no data will be send to the client until multisocketsink receives more
 * data. If the client, however, reads too slowly, data for that client will be 
 * queued up in multisocketsink. Two properties control the amount of data 
 * (buffers) that is queued in multisocketsink: #GstMultiSocketSink:buffers-max and 
 * #GstMultiSocketSink:buffers-soft-max. A client that falls behind by
 * #GstMultiSocketSink:buffers-max is removed from multisocketsink forcibly.
 *
 * A client with a lag of at least #GstMultiSocketSink:buffers-soft-max enters the recovery
 * procedure which is controlled with the #GstMultiSocketSink:recover-policy property.
 * A recover policy of NONE will do nothing, RESYNC_LATEST will send the most recently
 * received buffer as the next buffer for the client, RESYNC_SOFT_LIMIT
 * positions the client to the soft limit in the buffer queue and
 * RESYNC_KEYFRAME positions the client at the most recent keyframe in the
 * buffer queue.
 *
 * multisocketsink will by default synchronize on the clock before serving the 
 * buffers to the clients. This behaviour can be disabled by setting the sync 
 * property to FALSE. Multisocketsink will by default not do QoS and will never
 * drop late buffers.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/gst-i18n-plugin.h>

#include <string.h>

#include "gstmultisocketsink.h"

#ifndef G_OS_WIN32
#include <netinet/in.h>
#endif

#define NOT_IMPLEMENTED 0

GST_DEBUG_CATEGORY_STATIC (multisocketsink_debug);
#define GST_CAT_DEFAULT (multisocketsink_debug)

/* MultiSocketSink signals and args */
enum
{
  /* methods */
  SIGNAL_ADD,
  SIGNAL_ADD_BURST,
  SIGNAL_REMOVE,
  SIGNAL_REMOVE_FLUSH,
  SIGNAL_GET_STATS,

  /* signals */
  SIGNAL_CLIENT_ADDED,
  SIGNAL_CLIENT_REMOVED,
  SIGNAL_CLIENT_SOCKET_REMOVED,

  LAST_SIGNAL
};

enum
{
  PROP_0,

  PROP_LAST
};

static void gst_multi_socket_sink_finalize (GObject * object);

static void gst_multi_socket_sink_add (GstMultiSocketSink * sink,
    GSocket * socket);
static void gst_multi_socket_sink_add_full (GstMultiSocketSink * sink,
    GSocket * socket, GstSyncMethod sync, GstFormat min_format,
    guint64 min_value, GstFormat max_format, guint64 max_value);
static void gst_multi_socket_sink_remove (GstMultiSocketSink * sink,
    GSocket * socket);
static void gst_multi_socket_sink_remove_flush (GstMultiSocketSink * sink,
    GSocket * socket);
static GstStructure *gst_multi_socket_sink_get_stats (GstMultiSocketSink * sink,
    GSocket * socket);

static void gst_multi_socket_sink_emit_client_added (GstMultiHandleSink * mhs,
    GstMultiSinkHandle handle);
static void gst_multi_socket_sink_emit_client_removed (GstMultiHandleSink * mhs,
    GstMultiSinkHandle handle, GstClientStatus status);

static void gst_multi_socket_sink_stop_pre (GstMultiHandleSink * mhsink);
static void gst_multi_socket_sink_stop_post (GstMultiHandleSink * mhsink);
static gboolean gst_multi_socket_sink_start_pre (GstMultiHandleSink * mhsink);
static gpointer gst_multi_socket_sink_thread (GstMultiHandleSink * mhsink);
static GstMultiHandleClient
    * gst_multi_socket_sink_new_client (GstMultiHandleSink * mhsink,
    GstMultiSinkHandle handle, GstSyncMethod sync_method);
static int gst_multi_socket_sink_client_get_fd (GstMultiHandleClient * client);
static void gst_multi_socket_sink_client_free (GstMultiHandleSink * mhsink,
    GstMultiHandleClient * client);
static void gst_multi_socket_sink_handle_debug (GstMultiSinkHandle handle,
    gchar debug[30]);

static gpointer gst_multi_socket_sink_handle_hash_key (GstMultiSinkHandle
    handle);
static void gst_multi_socket_sink_hash_adding (GstMultiHandleSink * mhsink,
    GstMultiHandleClient * mhclient);
static void gst_multi_socket_sink_hash_removing (GstMultiHandleSink * mhsink,
    GstMultiHandleClient * mhclient);

static gboolean gst_multi_socket_sink_socket_condition (GstMultiSinkHandle
    handle, GIOCondition condition, GstMultiSocketSink * sink);

static gboolean gst_multi_socket_sink_unlock (GstBaseSink * bsink);
static gboolean gst_multi_socket_sink_unlock_stop (GstBaseSink * bsink);

static void gst_multi_socket_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_multi_socket_sink_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

#define gst_multi_socket_sink_parent_class parent_class
G_DEFINE_TYPE (GstMultiSocketSink, gst_multi_socket_sink,
    GST_TYPE_MULTI_HANDLE_SINK);

static guint gst_multi_socket_sink_signals[LAST_SIGNAL] = { 0 };

static void
gst_multi_socket_sink_class_init (GstMultiSocketSinkClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstBaseSinkClass *gstbasesink_class;
  GstMultiHandleSinkClass *gstmultihandlesink_class;

  gobject_class = (GObjectClass *) klass;
  gstelement_class = (GstElementClass *) klass;
  gstbasesink_class = (GstBaseSinkClass *) klass;
  gstmultihandlesink_class = (GstMultiHandleSinkClass *) klass;

  gobject_class->set_property = gst_multi_socket_sink_set_property;
  gobject_class->get_property = gst_multi_socket_sink_get_property;
  gobject_class->finalize = gst_multi_socket_sink_finalize;

  /**
   * GstMultiSocketSink::add:
   * @gstmultisocketsink: the multisocketsink element to emit this signal on
   * @socket:             the socket to add to multisocketsink
   *
   * Hand the given open socket to multisocketsink to write to.
   */
  gst_multi_socket_sink_signals[SIGNAL_ADD] =
      g_signal_new ("add", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
      G_STRUCT_OFFSET (GstMultiSocketSinkClass, add), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 1, G_TYPE_SOCKET);
  /**
   * GstMultiSocketSink::add-full:
   * @gstmultisocketsink: the multisocketsink element to emit this signal on
   * @socket:         the socket to add to multisocketsink
   * @sync:           the sync method to use
   * @format_min:     the format of @value_min
   * @value_min:      the minimum amount of data to burst expressed in
   *                  @format_min units.
   * @format_max:     the format of @value_max
   * @value_max:      the maximum amount of data to burst expressed in
   *                  @format_max units.
   *
   * Hand the given open socket to multisocketsink to write to and
   * specify the burst parameters for the new connection.
   */
  gst_multi_socket_sink_signals[SIGNAL_ADD_BURST] =
      g_signal_new ("add-full", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
      G_STRUCT_OFFSET (GstMultiSocketSinkClass, add_full), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 6,
      G_TYPE_SOCKET, GST_TYPE_SYNC_METHOD, GST_TYPE_FORMAT, G_TYPE_UINT64,
      GST_TYPE_FORMAT, G_TYPE_UINT64);
  /**
   * GstMultiSocketSink::remove:
   * @gstmultisocketsink: the multisocketsink element to emit this signal on
   * @socket:             the socket to remove from multisocketsink
   *
   * Remove the given open socket from multisocketsink.
   */
  gst_multi_socket_sink_signals[SIGNAL_REMOVE] =
      g_signal_new ("remove", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
      G_STRUCT_OFFSET (GstMultiSocketSinkClass, remove), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 1, G_TYPE_SOCKET);
  /**
   * GstMultiSocketSink::remove-flush:
   * @gstmultisocketsink: the multisocketsink element to emit this signal on
   * @socket:             the socket to remove from multisocketsink
   *
   * Remove the given open socket from multisocketsink after flushing all
   * the pending data to the socket.
   */
  gst_multi_socket_sink_signals[SIGNAL_REMOVE_FLUSH] =
      g_signal_new ("remove-flush", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
      G_STRUCT_OFFSET (GstMultiSocketSinkClass, remove_flush), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 1, G_TYPE_SOCKET);

  /**
   * GstMultiSocketSink::get-stats:
   * @gstmultisocketsink: the multisocketsink element to emit this signal on
   * @socket:             the socket to get stats of from multisocketsink
   *
   * Get statistics about @socket. This function returns a GstStructure.
   *
   * Returns: a GstStructure with the statistics. The structure contains
   *     values that represent: total number of bytes sent, time
   *     when the client was added, time when the client was
   *     disconnected/removed, time the client is/was active, last activity
   *     time (in epoch seconds), number of buffers dropped.
   *     All times are expressed in nanoseconds (GstClockTime).
   */
  gst_multi_socket_sink_signals[SIGNAL_GET_STATS] =
      g_signal_new ("get-stats", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
      G_STRUCT_OFFSET (GstMultiSocketSinkClass, get_stats), NULL, NULL,
      g_cclosure_marshal_generic, GST_TYPE_STRUCTURE, 1, G_TYPE_SOCKET);

  /**
   * GstMultiSocketSink::client-added:
   * @gstmultisocketsink: the multisocketsink element that emitted this signal
   * @socket:             the socket that was added to multisocketsink
   *
   * The given socket was added to multisocketsink. This signal will
   * be emitted from the streaming thread so application should be prepared
   * for that.
   */
  gst_multi_socket_sink_signals[SIGNAL_CLIENT_ADDED] =
      g_signal_new ("client-added", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, 0, NULL, NULL, g_cclosure_marshal_generic,
      G_TYPE_NONE, 1, G_TYPE_OBJECT);
  /**
   * GstMultiSocketSink::client-removed:
   * @gstmultisocketsink: the multisocketsink element that emitted this signal
   * @socket:             the socket that is to be removed from multisocketsink
   * @status:             the reason why the client was removed
   *
   * The given socket is about to be removed from multisocketsink. This
   * signal will be emitted from the streaming thread so applications should
   * be prepared for that.
   *
   * @gstmultisocketsink still holds a handle to @socket so it is possible to call
   * the get-stats signal from this callback. For the same reason it is
   * not safe to close() and reuse @socket in this callback.
   */
  gst_multi_socket_sink_signals[SIGNAL_CLIENT_REMOVED] =
      g_signal_new ("client-removed", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, 0, NULL, NULL, g_cclosure_marshal_generic,
      G_TYPE_NONE, 2, G_TYPE_INT, GST_TYPE_CLIENT_STATUS);
  /**
   * GstMultiSocketSink::client-socket-removed:
   * @gstmultisocketsink: the multisocketsink element that emitted this signal
   * @socket:             the socket that was removed from multisocketsink
   *
   * The given socket was removed from multisocketsink. This signal will
   * be emitted from the streaming thread so applications should be prepared
   * for that.
   *
   * In this callback, @gstmultisocketsink has removed all the information
   * associated with @socket and it is therefore not possible to call get-stats
   * with @socket. It is however safe to close() and reuse @fd in the callback.
   */
  gst_multi_socket_sink_signals[SIGNAL_CLIENT_SOCKET_REMOVED] =
      g_signal_new ("client-socket-removed", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, 0, NULL, NULL, g_cclosure_marshal_generic,
      G_TYPE_NONE, 1, G_TYPE_SOCKET);

  gst_element_class_set_static_metadata (gstelement_class,
      "Multi socket sink", "Sink/Network",
      "Send data to multiple sockets",
      "Thomas Vander Stichele <thomas at apestaart dot org>, "
      "Wim Taymans <wim@fluendo.com>, "
      "Sebastian Dröge <sebastian.droege@collabora.co.uk>");

  gstbasesink_class->unlock = GST_DEBUG_FUNCPTR (gst_multi_socket_sink_unlock);
  gstbasesink_class->unlock_stop =
      GST_DEBUG_FUNCPTR (gst_multi_socket_sink_unlock_stop);

  klass->add = GST_DEBUG_FUNCPTR (gst_multi_socket_sink_add);
  klass->add_full = GST_DEBUG_FUNCPTR (gst_multi_socket_sink_add_full);
  klass->remove = GST_DEBUG_FUNCPTR (gst_multi_socket_sink_remove);
  klass->remove_flush = GST_DEBUG_FUNCPTR (gst_multi_socket_sink_remove_flush);
  klass->get_stats = GST_DEBUG_FUNCPTR (gst_multi_socket_sink_get_stats);

  gstmultihandlesink_class->emit_client_added =
      gst_multi_socket_sink_emit_client_added;
  gstmultihandlesink_class->emit_client_removed =
      gst_multi_socket_sink_emit_client_removed;

  gstmultihandlesink_class->stop_pre =
      GST_DEBUG_FUNCPTR (gst_multi_socket_sink_stop_pre);
  gstmultihandlesink_class->stop_post =
      GST_DEBUG_FUNCPTR (gst_multi_socket_sink_stop_post);
  gstmultihandlesink_class->start_pre =
      GST_DEBUG_FUNCPTR (gst_multi_socket_sink_start_pre);
  gstmultihandlesink_class->thread =
      GST_DEBUG_FUNCPTR (gst_multi_socket_sink_thread);
  gstmultihandlesink_class->new_client =
      GST_DEBUG_FUNCPTR (gst_multi_socket_sink_new_client);
  gstmultihandlesink_class->client_get_fd =
      GST_DEBUG_FUNCPTR (gst_multi_socket_sink_client_get_fd);
  gstmultihandlesink_class->client_free =
      GST_DEBUG_FUNCPTR (gst_multi_socket_sink_client_free);
  gstmultihandlesink_class->handle_debug =
      GST_DEBUG_FUNCPTR (gst_multi_socket_sink_handle_debug);
  gstmultihandlesink_class->handle_hash_key =
      GST_DEBUG_FUNCPTR (gst_multi_socket_sink_handle_hash_key);
  gstmultihandlesink_class->hash_adding =
      GST_DEBUG_FUNCPTR (gst_multi_socket_sink_hash_adding);
  gstmultihandlesink_class->hash_removing =
      GST_DEBUG_FUNCPTR (gst_multi_socket_sink_hash_removing);

  GST_DEBUG_CATEGORY_INIT (multisocketsink_debug, "multisocketsink", 0,
      "Multi socket sink");
}

static void
gst_multi_socket_sink_init (GstMultiSocketSink * this)
{
  GstMultiHandleSink *mhsink = GST_MULTI_HANDLE_SINK (this);

  mhsink->handle_hash = g_hash_table_new (g_direct_hash, g_int_equal);

  this->cancellable = g_cancellable_new ();
}

static void
gst_multi_socket_sink_finalize (GObject * object)
{
  GstMultiSocketSink *this = GST_MULTI_SOCKET_SINK (object);

  if (this->cancellable) {
    g_object_unref (this->cancellable);
    this->cancellable = NULL;
  }

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

/* methods to emit signals */

static void
gst_multi_socket_sink_emit_client_added (GstMultiHandleSink * mhsink,
    GstMultiSinkHandle handle)
{
  g_signal_emit (mhsink, gst_multi_socket_sink_signals[SIGNAL_CLIENT_ADDED], 0,
      handle.socket);
}

static void
gst_multi_socket_sink_emit_client_removed (GstMultiHandleSink * mhsink,
    GstMultiSinkHandle handle, GstClientStatus status)
{
  g_signal_emit (mhsink, gst_multi_socket_sink_signals[SIGNAL_CLIENT_REMOVED],
      0, handle.socket, status);
}

/* action signals */

static void
gst_multi_socket_sink_add (GstMultiSocketSink * sink, GSocket * socket)
{
  GstMultiSinkHandle handle;

  handle.socket = socket;
  gst_multi_handle_sink_add (GST_MULTI_HANDLE_SINK_CAST (sink), handle);
}

static void
gst_multi_socket_sink_add_full (GstMultiSocketSink * sink, GSocket * socket,
    GstSyncMethod sync, GstFormat min_format, guint64 min_value,
    GstFormat max_format, guint64 max_value)
{
  GstMultiSinkHandle handle;

  handle.socket = socket;
  gst_multi_handle_sink_add_full (GST_MULTI_HANDLE_SINK_CAST (sink), handle,
      sync, min_format, min_value, max_format, max_value);
}

static void
gst_multi_socket_sink_remove (GstMultiSocketSink * sink, GSocket * socket)
{
  GstMultiSinkHandle handle;

  handle.socket = socket;
  gst_multi_handle_sink_remove (GST_MULTI_HANDLE_SINK_CAST (sink), handle);
}

static void
gst_multi_socket_sink_remove_flush (GstMultiSocketSink * sink, GSocket * socket)
{
  GstMultiSinkHandle handle;

  handle.socket = socket;
  gst_multi_handle_sink_remove_flush (GST_MULTI_HANDLE_SINK_CAST (sink),
      handle);
}

static GstStructure *
gst_multi_socket_sink_get_stats (GstMultiSocketSink * sink, GSocket * socket)
{
  GstMultiSinkHandle handle;

  handle.socket = socket;
  return gst_multi_handle_sink_get_stats (GST_MULTI_HANDLE_SINK_CAST (sink),
      handle);
}

static GstMultiHandleClient *
gst_multi_socket_sink_new_client (GstMultiHandleSink * mhsink,
    GstMultiSinkHandle handle, GstSyncMethod sync_method)
{
  GstSocketClient *client;
  GstMultiHandleClient *mhclient;
  GstMultiHandleSinkClass *mhsinkclass =
      GST_MULTI_HANDLE_SINK_GET_CLASS (mhsink);

  /* create client datastructure */
  g_assert (G_IS_SOCKET (handle.socket));
  client = g_new0 (GstSocketClient, 1);
  mhclient = (GstMultiHandleClient *) client;

  mhclient->handle.socket = G_SOCKET (g_object_ref (handle.socket));

  gst_multi_handle_sink_client_init (mhclient, sync_method);
  mhsinkclass->handle_debug (handle, mhclient->debug);

  /* set the socket to non blocking */
  g_socket_set_blocking (handle.socket, FALSE);

  /* we always read from a client */
  mhsinkclass->hash_adding (mhsink, mhclient);

  gst_multi_handle_sink_setup_dscp_client (mhsink, mhclient);

  return mhclient;
}

static int
gst_multi_socket_sink_client_get_fd (GstMultiHandleClient * client)
{
  return g_socket_get_fd (client->handle.socket);
}

static void
gst_multi_socket_sink_client_free (GstMultiHandleSink * mhsink,
    GstMultiHandleClient * client)
{
  g_assert (G_IS_SOCKET (client->handle.socket));

  g_signal_emit (mhsink,
      gst_multi_socket_sink_signals[SIGNAL_CLIENT_SOCKET_REMOVED], 0,
      client->handle.socket);

  g_object_unref (client->handle.socket);
}

static void
gst_multi_socket_sink_handle_debug (GstMultiSinkHandle handle, gchar debug[30])
{
  g_snprintf (debug, 30, "[socket %p]", handle.socket);
}

static gpointer
gst_multi_socket_sink_handle_hash_key (GstMultiSinkHandle handle)
{
  return handle.socket;
}

/* handle a read on a client socket,
 * which either indicates a close or should be ignored
 * returns FALSE if some error occured or the client closed. */
static gboolean
gst_multi_socket_sink_handle_client_read (GstMultiSocketSink * sink,
    GstSocketClient * client)
{
  gboolean ret;
  gchar dummy[256];
  gssize nread;
  GError *err = NULL;
  gboolean first = TRUE;
  GstMultiHandleClient *mhclient = (GstMultiHandleClient *) client;

  GST_DEBUG_OBJECT (sink, "%s select reports client read", mhclient->debug);

  ret = TRUE;

  /* just Read 'n' Drop, could also just drop the client as it's not supposed
   * to write to us except for closing the socket, I guess it's because we
   * like to listen to our customers. */
  do {
    gssize navail;

    GST_DEBUG_OBJECT (sink, "%s client wants us to read", mhclient->debug);

    navail = g_socket_get_available_bytes (mhclient->handle.socket);
    if (navail < 0)
      break;

    nread =
        g_socket_receive (mhclient->handle.socket, dummy, MIN (navail,
            sizeof (dummy)), sink->cancellable, &err);
    if (first && nread == 0) {
      /* client sent close, so remove it */
      GST_DEBUG_OBJECT (sink, "%s client asked for close, removing",
          mhclient->debug);
      mhclient->status = GST_CLIENT_STATUS_CLOSED;
      ret = FALSE;
    } else if (nread < 0) {
      GST_WARNING_OBJECT (sink, "%s could not read: %s",
          mhclient->debug, err->message);
      mhclient->status = GST_CLIENT_STATUS_ERROR;
      ret = FALSE;
      break;
    }
    first = FALSE;
  } while (nread > 0);
  g_clear_error (&err);

  return ret;
}

/* Handle a write on a client,
 * which indicates a read request from a client.
 *
 * For each client we maintain a queue of GstBuffers that contain the raw bytes
 * we need to send to the client.
 *
 * We first check to see if we need to send streamheaders. If so, we queue them.
 *
 * Then we run into the main loop that tries to send as many buffers as
 * possible. It will first exhaust the mhclient->sending queue and if the queue
 * is empty, it will pick a buffer from the global queue.
 *
 * Sending the buffers from the mhclient->sending queue is basically writing
 * the bytes to the socket and maintaining a count of the bytes that were
 * sent. When the buffer is completely sent, it is removed from the
 * mhclient->sending queue and we try to pick a new buffer for sending.
 *
 * When the sending returns a partial buffer we stop sending more data as
 * the next send operation could block.
 *
 * This functions returns FALSE if some error occured.
 */
static gboolean
gst_multi_socket_sink_handle_client_write (GstMultiSocketSink * sink,
    GstSocketClient * client)
{
  gboolean more;
  gboolean flushing;
  GstClockTime now;
  GTimeVal nowtv;
  GError *err = NULL;
  GstMultiHandleSink *mhsink = GST_MULTI_HANDLE_SINK (sink);
  GstMultiHandleClient *mhclient = (GstMultiHandleClient *) client;
  GstMultiHandleSinkClass *mhsinkclass =
      GST_MULTI_HANDLE_SINK_GET_CLASS (mhsink);


  g_get_current_time (&nowtv);
  now = GST_TIMEVAL_TO_TIME (nowtv);

  flushing = mhclient->status == GST_CLIENT_STATUS_FLUSHING;

  more = TRUE;
  do {
    gint maxsize;

    if (!mhclient->sending) {
      /* client is not working on a buffer */
      if (mhclient->bufpos == -1) {
        /* client is too fast, remove from write queue until new buffer is
         * available */
        /* FIXME: specific */
        if (client->source) {
          g_source_destroy (client->source);
          g_source_unref (client->source);
          client->source = NULL;
        }

        /* if we flushed out all of the client buffers, we can stop */
        if (mhclient->flushcount == 0)
          goto flushed;

        return TRUE;
      } else {
        /* client can pick a buffer from the global queue */
        GstBuffer *buf;
        GstClockTime timestamp;

        /* for new connections, we need to find a good spot in the
         * bufqueue to start streaming from */
        if (mhclient->new_connection && !flushing) {
          gint position =
              gst_multi_handle_sink_new_client_position (mhsink, mhclient);

          if (position >= 0) {
            /* we got a valid spot in the queue */
            mhclient->new_connection = FALSE;
            mhclient->bufpos = position;
          } else {
            /* cannot send data to this client yet */
            /* FIXME: specific */
            if (client->source) {
              g_source_destroy (client->source);
              g_source_unref (client->source);
              client->source = NULL;
            }

            return TRUE;
          }
        }

        /* we flushed all remaining buffers, no need to get a new one */
        if (mhclient->flushcount == 0)
          goto flushed;

        /* grab buffer */
        buf = g_array_index (mhsink->bufqueue, GstBuffer *, mhclient->bufpos);
        mhclient->bufpos--;

        /* update stats */
        timestamp = GST_BUFFER_TIMESTAMP (buf);
        if (mhclient->first_buffer_ts == GST_CLOCK_TIME_NONE)
          mhclient->first_buffer_ts = timestamp;
        if (timestamp != -1)
          mhclient->last_buffer_ts = timestamp;

        /* decrease flushcount */
        if (mhclient->flushcount != -1)
          mhclient->flushcount--;

        GST_LOG_OBJECT (sink, "%s client %p at position %d",
            mhclient->debug, client, mhclient->bufpos);

        /* queueing a buffer will ref it */
        mhsinkclass->client_queue_buffer (mhsink, mhclient, buf);

        /* need to start from the first byte for this new buffer */
        mhclient->bufoffset = 0;
      }
    }

    /* see if we need to send something */
    if (mhclient->sending) {
      gssize wrote;
      GstBuffer *head;
      GstMapInfo map;

      /* pick first buffer from list */
      head = GST_BUFFER (mhclient->sending->data);

      gst_buffer_map (head, &map, GST_MAP_READ);
      maxsize = map.size - mhclient->bufoffset;

      /* FIXME: specific */
      /* try to write the complete buffer */

      wrote =
          g_socket_send (mhclient->handle.socket,
          (gchar *) map.data + mhclient->bufoffset, maxsize, sink->cancellable,
          &err);
      gst_buffer_unmap (head, &map);

      if (wrote < 0) {
        /* hmm error.. */
        if (g_error_matches (err, G_IO_ERROR, G_IO_ERROR_CLOSED)) {
          goto connection_reset;
        } else if (g_error_matches (err, G_IO_ERROR, G_IO_ERROR_WOULD_BLOCK)) {
          /* write would block, try again later */
          GST_LOG_OBJECT (sink, "write would block %p",
              mhclient->handle.socket);
          more = FALSE;
        } else {
          goto write_error;
        }
      } else {
        if (wrote < maxsize) {
          /* partial write, try again now */
          GST_LOG_OBJECT (sink,
              "partial write on %p of %" G_GSSIZE_FORMAT " bytes",
              mhclient->handle.socket, wrote);
          mhclient->bufoffset += wrote;
        } else {
          /* complete buffer was written, we can proceed to the next one */
          mhclient->sending = g_slist_remove (mhclient->sending, head);
          gst_buffer_unref (head);
          /* make sure we start from byte 0 for the next buffer */
          mhclient->bufoffset = 0;
        }
        /* update stats */
        mhclient->bytes_sent += wrote;
        mhclient->last_activity_time = now;
        mhsink->bytes_served += wrote;
      }
    }
  } while (more);

  return TRUE;

  /* ERRORS */
flushed:
  {
    GST_DEBUG_OBJECT (sink, "%s flushed, removing", mhclient->debug);
    mhclient->status = GST_CLIENT_STATUS_REMOVED;
    return FALSE;
  }
connection_reset:
  {
    GST_DEBUG_OBJECT (sink, "%s connection reset by peer, removing",
        mhclient->debug);
    mhclient->status = GST_CLIENT_STATUS_CLOSED;
    g_clear_error (&err);
    return FALSE;
  }
write_error:
  {
    GST_WARNING_OBJECT (sink,
        "%s could not write, removing client: %s", mhclient->debug,
        err->message);
    g_clear_error (&err);
    mhclient->status = GST_CLIENT_STATUS_ERROR;
    return FALSE;
  }
}

static void
gst_multi_socket_sink_hash_adding (GstMultiHandleSink * mhsink,
    GstMultiHandleClient * mhclient)
{
  GstMultiSocketSink *sink = GST_MULTI_SOCKET_SINK (mhsink);
  GstSocketClient *client = (GstSocketClient *) (mhclient);

  if (!sink->main_context)
    return;

  if (!client->source) {
    client->source =
        g_socket_create_source (mhclient->handle.socket,
        G_IO_IN | G_IO_OUT | G_IO_PRI | G_IO_ERR | G_IO_HUP, sink->cancellable);
    g_source_set_callback (client->source,
        (GSourceFunc) gst_multi_socket_sink_socket_condition,
        gst_object_ref (sink), (GDestroyNotify) gst_object_unref);
    g_source_attach (client->source, sink->main_context);
  }
}

static void
gst_multi_socket_sink_hash_removing (GstMultiHandleSink * mhsink,
    GstMultiHandleClient * mhclient)
{
  GstSocketClient *client = (GstSocketClient *) (mhclient);

  if (client->source) {
    g_source_destroy (client->source);
    g_source_unref (client->source);
    client->source = NULL;
  }
}

/* Handle the clients. This is called when a socket becomes ready
 * to read or writable. Badly behaving clients are put on a
 * garbage list and removed.
 */
static gboolean
gst_multi_socket_sink_socket_condition (GstMultiSinkHandle handle,
    GIOCondition condition, GstMultiSocketSink * sink)
{
  GList *clink;
  GstSocketClient *client;
  gboolean ret = TRUE;
  GstMultiHandleClient *mhclient;
  GstMultiHandleSink *mhsink = GST_MULTI_HANDLE_SINK (sink);
  GstMultiHandleSinkClass *mhsinkclass =
      GST_MULTI_HANDLE_SINK_GET_CLASS (mhsink);

  CLIENTS_LOCK (mhsink);
  clink = g_hash_table_lookup (mhsink->handle_hash,
      mhsinkclass->handle_hash_key (handle));
  if (clink == NULL) {
    ret = FALSE;
    goto done;
  }

  client = clink->data;
  mhclient = (GstMultiHandleClient *) client;

  if (mhclient->status != GST_CLIENT_STATUS_FLUSHING
      && mhclient->status != GST_CLIENT_STATUS_OK) {
    gst_multi_handle_sink_remove_client_link (mhsink, clink);
    ret = FALSE;
    goto done;
  }

  if ((condition & G_IO_ERR)) {
    GST_WARNING_OBJECT (sink, "%s has error", mhclient->debug);
    mhclient->status = GST_CLIENT_STATUS_ERROR;
    gst_multi_handle_sink_remove_client_link (mhsink, clink);
    ret = FALSE;
    goto done;
  } else if ((condition & G_IO_HUP)) {
    mhclient->status = GST_CLIENT_STATUS_CLOSED;
    gst_multi_handle_sink_remove_client_link (mhsink, clink);
    ret = FALSE;
    goto done;
  } else if ((condition & G_IO_IN) || (condition & G_IO_PRI)) {
    /* handle client read */
    if (!gst_multi_socket_sink_handle_client_read (sink, client)) {
      gst_multi_handle_sink_remove_client_link (mhsink, clink);
      ret = FALSE;
      goto done;
    }
  } else if ((condition & G_IO_OUT)) {
    /* handle client write */
    if (!gst_multi_socket_sink_handle_client_write (sink, client)) {
      gst_multi_handle_sink_remove_client_link (mhsink, clink);
      ret = FALSE;
      goto done;
    }
  }

done:
  CLIENTS_UNLOCK (mhsink);

  return ret;
}

static gboolean
gst_multi_socket_sink_timeout (GstMultiSocketSink * sink)
{
  GstClockTime now;
  GTimeVal nowtv;
  GList *clients;
  GstMultiHandleSink *mhsink = GST_MULTI_HANDLE_SINK (sink);

  g_get_current_time (&nowtv);
  now = GST_TIMEVAL_TO_TIME (nowtv);

  CLIENTS_LOCK (mhsink);
  for (clients = mhsink->clients; clients; clients = clients->next) {
    GstSocketClient *client;
    GstMultiHandleClient *mhclient;

    client = clients->data;
    mhclient = (GstMultiHandleClient *) client;
    if (mhsink->timeout > 0
        && now - mhclient->last_activity_time > mhsink->timeout) {
      mhclient->status = GST_CLIENT_STATUS_SLOW;
      gst_multi_handle_sink_remove_client_link (mhsink, clients);
    }
  }
  CLIENTS_UNLOCK (mhsink);

  return FALSE;
}

/* we handle the client communication in another thread so that we do not block
 * the gstreamer thread while we select() on the client fds */
static gpointer
gst_multi_socket_sink_thread (GstMultiHandleSink * mhsink)
{
  GstMultiSocketSink *sink = GST_MULTI_SOCKET_SINK (mhsink);
  GSource *timeout = NULL;

  while (mhsink->running) {
    if (mhsink->timeout > 0) {
      timeout = g_timeout_source_new (mhsink->timeout / GST_MSECOND);

      g_source_set_callback (timeout,
          (GSourceFunc) gst_multi_socket_sink_timeout, gst_object_ref (sink),
          (GDestroyNotify) gst_object_unref);
      g_source_attach (timeout, sink->main_context);
    }

    /* Returns after handling all pending events or when
     * _wakeup() was called. In any case we have to add
     * a new timeout because something happened.
     */
    g_main_context_iteration (sink->main_context, TRUE);

    if (timeout) {
      g_source_destroy (timeout);
      g_source_unref (timeout);
    }
  }

  return NULL;
}

static void
gst_multi_socket_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  switch (prop_id) {

    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_multi_socket_sink_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  switch (prop_id) {
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static gboolean
gst_multi_socket_sink_start_pre (GstMultiHandleSink * mhsink)
{
  GstMultiSocketSink *mssink = GST_MULTI_SOCKET_SINK (mhsink);
  GstMultiHandleSinkClass *mhsinkclass =
      GST_MULTI_HANDLE_SINK_GET_CLASS (mhsink);
  GList *clients;

  GST_INFO_OBJECT (mssink, "starting");

  mssink->main_context = g_main_context_new ();

  CLIENTS_LOCK (mhsink);
  for (clients = mhsink->clients; clients; clients = clients->next) {
    GstSocketClient *client = clients->data;
    GstMultiHandleClient *mhclient = (GstMultiHandleClient *) client;

    if (client->source)
      continue;
    mhsinkclass->hash_adding (mhsink, mhclient);
  }
  CLIENTS_UNLOCK (mhsink);

  return TRUE;
}

static gboolean
multisocketsink_hash_remove (gpointer key, gpointer value, gpointer data)
{
  return TRUE;
}

static void
gst_multi_socket_sink_stop_pre (GstMultiHandleSink * mhsink)
{
  GstMultiSocketSink *mssink = GST_MULTI_SOCKET_SINK (mhsink);

  if (mssink->main_context)
    g_main_context_wakeup (mssink->main_context);
}

static void
gst_multi_socket_sink_stop_post (GstMultiHandleSink * mhsink)
{
  GstMultiSocketSink *mssink = GST_MULTI_SOCKET_SINK (mhsink);

  if (mssink->main_context) {
    g_main_context_unref (mssink->main_context);
    mssink->main_context = NULL;
  }

  g_hash_table_foreach_remove (mhsink->handle_hash, multisocketsink_hash_remove,
      mssink);
}

static gboolean
gst_multi_socket_sink_unlock (GstBaseSink * bsink)
{
  GstMultiSocketSink *sink;

  sink = GST_MULTI_SOCKET_SINK (bsink);

  GST_DEBUG_OBJECT (sink, "set to flushing");
  g_cancellable_cancel (sink->cancellable);
  if (sink->main_context)
    g_main_context_wakeup (sink->main_context);

  return TRUE;
}

/* will be called only between calls to start() and stop() */
static gboolean
gst_multi_socket_sink_unlock_stop (GstBaseSink * bsink)
{
  GstMultiSocketSink *sink;

  sink = GST_MULTI_SOCKET_SINK (bsink);

  GST_DEBUG_OBJECT (sink, "unset flushing");
  g_cancellable_reset (sink->cancellable);

  return TRUE;
}
