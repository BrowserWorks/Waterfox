/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
 * Copyright (C) <2004> Thomas Vander Stichele <thomas at apestaart dot org>
 * Copyright (C) 2006 Wim Taymans <wim at fluendo dot com>
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
 * SECTION:element-multifdsink
 * @see_also: tcpserversink
 *
 * This plugin writes incoming data to a set of file descriptors. The
 * file descriptors can be added to multifdsink by emitting the #GstMultiFdSink::add signal. 
 * For each descriptor added, the #GstMultiFdSink::client-added signal will be called.
 *
 * The multifdsink element needs to be set into READY, PAUSED or PLAYING state
 * before operations such as adding clients are possible.
 *
 * A client can also be added with the #GstMultiFdSink::add-full signal
 * that allows for more control over what and how much data a client 
 * initially receives.
 *
 * Clients can be removed from multifdsink by emitting the #GstMultiFdSink::remove signal. For
 * each descriptor removed, the #GstMultiFdSink::client-removed signal will be called. The
 * #GstMultiFdSink::client-removed signal can also be fired when multifdsink decides that a
 * client is not active anymore or, depending on the value of the
 * #GstMultiFdSink:recover-policy property, if the client is reading too slowly.
 * In all cases, multifdsink will never close a file descriptor itself.
 * The user of multifdsink is responsible for closing all file descriptors.
 * This can for example be done in response to the #GstMultiFdSink::client-fd-removed signal.
 * Note that multifdsink still has a reference to the file descriptor when the
 * #GstMultiFdSink::client-removed signal is emitted, so that "get-stats" can be performed on
 * the descriptor; it is therefore not safe to close the file descriptor in
 * the #GstMultiFdSink::client-removed signal handler, and you should use the 
 * #GstMultiFdSink::client-fd-removed signal to safely close the fd.
 *
 * Multifdsink internally keeps a queue of the incoming buffers and uses a
 * separate thread to send the buffers to the clients. This ensures that no
 * client write can block the pipeline and that clients can read with different
 * speeds.
 *
 * When adding a client to multifdsink, the #GstMultiFdSink:sync-method property will define
 * which buffer in the queued buffers will be sent first to the client. Clients 
 * can be sent the most recent buffer (which might not be decodable by the 
 * client if it is not a keyframe), the next keyframe received in 
 * multifdsink (which can take some time depending on the keyframe rate), or the
 * last received keyframe (which will cause a simple burst-on-connect). 
 * Multifdsink will always keep at least one keyframe in its internal buffers
 * when the sync-mode is set to latest-keyframe.
 *
 * There are additional values for the #GstMultiFdSink:sync-method
 * property to allow finer control over burst-on-connect behaviour. By selecting
 * the 'burst' method a minimum burst size can be chosen, 'burst-keyframe'
 * additionally requires that the burst begin with a keyframe, and 
 * 'burst-with-keyframe' attempts to burst beginning with a keyframe, but will
 * prefer a minimum burst size even if it requires not starting with a keyframe.
 *
 * Multifdsink can be instructed to keep at least a minimum amount of data
 * expressed in time or byte units in its internal queues with the 
 * #GstMultiFdSink:time-min and #GstMultiFdSink:bytes-min properties respectively.
 * These properties are useful if the application adds clients with the 
 * #GstMultiFdSink::add-full signal to make sure that a burst connect can
 * actually be honored. 
 *
 * When streaming data, clients are allowed to read at a different rate than
 * the rate at which multifdsink receives data. If the client is reading too
 * fast, no data will be send to the client until multifdsink receives more
 * data. If the client, however, reads too slowly, data for that client will be 
 * queued up in multifdsink. Two properties control the amount of data 
 * (buffers) that is queued in multifdsink: #GstMultiFdSink:buffers-max and 
 * #GstMultiFdSink:buffers-soft-max. A client that falls behind by
 * #GstMultiFdSink:buffers-max is removed from multifdsink forcibly.
 *
 * A client with a lag of at least #GstMultiFdSink:buffers-soft-max enters the recovery
 * procedure which is controlled with the #GstMultiFdSink:recover-policy property.
 * A recover policy of NONE will do nothing, RESYNC_LATEST will send the most recently
 * received buffer as the next buffer for the client, RESYNC_SOFT_LIMIT
 * positions the client to the soft limit in the buffer queue and
 * RESYNC_KEYFRAME positions the client at the most recent keyframe in the
 * buffer queue.
 *
 * multifdsink will by default synchronize on the clock before serving the 
 * buffers to the clients. This behaviour can be disabled by setting the sync 
 * property to FALSE. Multifdsink will by default not do QoS and will never
 * drop late buffers.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/gst-i18n-plugin.h>

#include <sys/ioctl.h>

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#include <string.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <netinet/in.h>

#ifdef HAVE_FIONREAD_IN_SYS_FILIO
#include <sys/filio.h>
#endif

#include "gstmultifdsink.h"

#define NOT_IMPLEMENTED 0

GST_DEBUG_CATEGORY_STATIC (multifdsink_debug);
#define GST_CAT_DEFAULT (multifdsink_debug)

/* MultiFdSink signals and args */
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
  SIGNAL_CLIENT_FD_REMOVED,

  LAST_SIGNAL
};

/* this is really arbitrarily chosen */
#define DEFAULT_HANDLE_READ             TRUE

enum
{
  PROP_0,
  PROP_HANDLE_READ,
  PROP_LAST
};

static void gst_multi_fd_sink_stop_pre (GstMultiHandleSink * mhsink);
static void gst_multi_fd_sink_stop_post (GstMultiHandleSink * mhsink);
static gboolean gst_multi_fd_sink_start_pre (GstMultiHandleSink * mhsink);
static gpointer gst_multi_fd_sink_thread (GstMultiHandleSink * mhsink);

static void gst_multi_fd_sink_add (GstMultiFdSink * sink, int fd);
static void gst_multi_fd_sink_add_full (GstMultiFdSink * sink, int fd,
    GstSyncMethod sync, GstFormat min_format, guint64 min_value,
    GstFormat max_format, guint64 max_value);
static void gst_multi_fd_sink_remove (GstMultiFdSink * sink, int fd);
static void gst_multi_fd_sink_remove_flush (GstMultiFdSink * sink, int fd);
static GstStructure *gst_multi_fd_sink_get_stats (GstMultiFdSink * sink,
    int fd);

static void gst_multi_fd_sink_emit_client_added (GstMultiHandleSink * mhsink,
    GstMultiSinkHandle handle);
static void gst_multi_fd_sink_emit_client_removed (GstMultiHandleSink * mhsink,
    GstMultiSinkHandle handle, GstClientStatus status);

static GstMultiHandleClient *gst_multi_fd_sink_new_client (GstMultiHandleSink *
    mhsink, GstMultiSinkHandle handle, GstSyncMethod sync_method);
static void gst_multi_fd_sink_client_free (GstMultiHandleSink * m,
    GstMultiHandleClient * client);
static int gst_multi_fd_sink_client_get_fd (GstMultiHandleClient * client);
static void gst_multi_fd_sink_handle_debug (GstMultiSinkHandle handle,
    gchar debug[30]);
static gpointer gst_multi_fd_sink_handle_hash_key (GstMultiSinkHandle handle);
static void gst_multi_fd_sink_hash_adding (GstMultiHandleSink * mhsink,
    GstMultiHandleClient * mhclient);
static void gst_multi_fd_sink_hash_removing (GstMultiHandleSink * mhsink,
    GstMultiHandleClient * mhclient);

static void gst_multi_fd_sink_hash_changed (GstMultiHandleSink * mhsink);

static void gst_multi_fd_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_multi_fd_sink_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

#define gst_multi_fd_sink_parent_class parent_class
G_DEFINE_TYPE (GstMultiFdSink, gst_multi_fd_sink, GST_TYPE_MULTI_HANDLE_SINK);

static guint gst_multi_fd_sink_signals[LAST_SIGNAL] = { 0 };

static void
gst_multi_fd_sink_class_init (GstMultiFdSinkClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstMultiHandleSinkClass *gstmultihandlesink_class;

  gobject_class = (GObjectClass *) klass;
  gstelement_class = (GstElementClass *) klass;
  gstmultihandlesink_class = (GstMultiHandleSinkClass *) klass;

  gobject_class->set_property = gst_multi_fd_sink_set_property;
  gobject_class->get_property = gst_multi_fd_sink_get_property;

  /**
   * GstMultiFdSink::handle-read
   *
   * Handle read requests from clients and discard the data.
   */
  g_object_class_install_property (gobject_class, PROP_HANDLE_READ,
      g_param_spec_boolean ("handle-read", "Handle Read",
          "Handle client reads and discard the data",
          DEFAULT_HANDLE_READ, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstMultiFdSink::add:
   * @gstmultifdsink: the multifdsink element to emit this signal on
   * @fd:             the file descriptor to add to multifdsink
   *
   * Hand the given open file descriptor to multifdsink to write to.
   */
  gst_multi_fd_sink_signals[SIGNAL_ADD] =
      g_signal_new ("add", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
      G_STRUCT_OFFSET (GstMultiFdSinkClass, add), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 1, G_TYPE_INT);
  /**
   * GstMultiFdSink::add-full:
   * @gstmultifdsink:  the multifdsink element to emit this signal on
   * @fd:              the file descriptor to add to multifdsink
   * @sync:            the sync method to use
   * @format_min:      the format of @value_min
   * @value_min:       the minimum amount of data to burst expressed in
   *                   @format_min units.
   * @format_max:      the format of @value_max
   * @value_max:       the maximum amount of data to burst expressed in
   *                   @format_max units.
   *
   * Hand the given open file descriptor to multifdsink to write to and
   * specify the burst parameters for the new connection.
   */
  gst_multi_fd_sink_signals[SIGNAL_ADD_BURST] =
      g_signal_new ("add-full", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
      G_STRUCT_OFFSET (GstMultiFdSinkClass, add_full), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 6,
      G_TYPE_INT, GST_TYPE_SYNC_METHOD, GST_TYPE_FORMAT, G_TYPE_UINT64,
      GST_TYPE_FORMAT, G_TYPE_UINT64);
  /**
   * GstMultiFdSink::remove:
   * @gstmultifdsink: the multifdsink element to emit this signal on
   * @fd:             the file descriptor to remove from multifdsink
   *
   * Remove the given open file descriptor from multifdsink.
   */
  gst_multi_fd_sink_signals[SIGNAL_REMOVE] =
      g_signal_new ("remove", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
      G_STRUCT_OFFSET (GstMultiFdSinkClass, remove), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 1, G_TYPE_INT);
  /**
   * GstMultiFdSink::remove-flush:
   * @gstmultifdsink: the multifdsink element to emit this signal on
   * @fd:             the file descriptor to remove from multifdsink
   *
   * Remove the given open file descriptor from multifdsink after flushing all
   * the pending data to the fd.
   */
  gst_multi_fd_sink_signals[SIGNAL_REMOVE_FLUSH] =
      g_signal_new ("remove-flush", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
      G_STRUCT_OFFSET (GstMultiFdSinkClass, remove_flush), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 1, G_TYPE_INT);

  /**
   * GstMultiFdSink::get-stats:
   * @gstmultifdsink: the multifdsink element to emit this signal on
   * @fd:             the file descriptor to get stats of from multifdsink
   *
   * Get statistics about @fd. This function returns a GValueArray to ease
   * automatic wrapping for bindings.
   *
   * Returns: a GValueArray with the statistics. The array contains guint64
   *     values that represent respectively: total number of bytes sent, time
   *     when the client was added, time when the client was
   *     disconnected/removed, time the client is/was active, last activity
   *     time (in epoch seconds), number of buffers dropped.
   *     All times are expressed in nanoseconds (GstClockTime).
   *     The array can be 0-length if the client was not found.
   */
  gst_multi_fd_sink_signals[SIGNAL_GET_STATS] =
      g_signal_new ("get-stats", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
      G_STRUCT_OFFSET (GstMultiFdSinkClass, get_stats), NULL, NULL,
      g_cclosure_marshal_generic, GST_TYPE_STRUCTURE, 1, G_TYPE_INT);

  /**
   * GstMultiFdSink::client-added:
   * @gstmultifdsink: the multifdsink element that emitted this signal
   * @fd:             the file descriptor that was added to multifdsink
   *
   * The given file descriptor was added to multifdsink. This signal will
   * be emitted from the streaming thread so application should be prepared
   * for that.
   */
  gst_multi_fd_sink_signals[SIGNAL_CLIENT_ADDED] =
      g_signal_new ("client-added", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, 0, NULL, NULL, g_cclosure_marshal_generic, G_TYPE_NONE,
      1, G_TYPE_INT);
  /**
   * GstMultiFdSink::client-removed:
   * @gstmultifdsink: the multifdsink element that emitted this signal
   * @fd:             the file descriptor that is to be removed from multifdsink
   * @status:         the reason why the client was removed
   *
   * The given file descriptor is about to be removed from multifdsink. This
   * signal will be emitted from the streaming thread so applications should
   * be prepared for that.
   *
   * @gstmultifdsink still holds a handle to @fd so it is possible to call
   * the get-stats signal from this callback. For the same reason it is
   * not safe to close() and reuse @fd in this callback.
   */
  gst_multi_fd_sink_signals[SIGNAL_CLIENT_REMOVED] =
      g_signal_new ("client-removed", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, 0, NULL, NULL, g_cclosure_marshal_generic,
      G_TYPE_NONE, 2, G_TYPE_INT, GST_TYPE_CLIENT_STATUS);
  /**
   * GstMultiFdSink::client-fd-removed:
   * @gstmultifdsink: the multifdsink element that emitted this signal
   * @fd:             the file descriptor that was removed from multifdsink
   *
   * The given file descriptor was removed from multifdsink. This signal will
   * be emitted from the streaming thread so applications should be prepared
   * for that.
   *
   * In this callback, @gstmultifdsink has removed all the information
   * associated with @fd and it is therefore not possible to call get-stats
   * with @fd. It is however safe to close() and reuse @fd in the callback.
   */
  gst_multi_fd_sink_signals[SIGNAL_CLIENT_FD_REMOVED] =
      g_signal_new ("client-fd-removed", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, 0, NULL, NULL, g_cclosure_marshal_generic,
      G_TYPE_NONE, 1, G_TYPE_INT);

  gst_element_class_set_static_metadata (gstelement_class,
      "Multi filedescriptor sink", "Sink/Network",
      "Send data to multiple filedescriptors",
      "Thomas Vander Stichele <thomas at apestaart dot org>, "
      "Wim Taymans <wim@fluendo.com>");

  klass->add = GST_DEBUG_FUNCPTR (gst_multi_fd_sink_add);
  klass->add_full = GST_DEBUG_FUNCPTR (gst_multi_fd_sink_add_full);
  klass->remove = GST_DEBUG_FUNCPTR (gst_multi_fd_sink_remove);
  klass->remove_flush = GST_DEBUG_FUNCPTR (gst_multi_fd_sink_remove_flush);
  klass->get_stats = GST_DEBUG_FUNCPTR (gst_multi_fd_sink_get_stats);

  gstmultihandlesink_class->emit_client_added =
      gst_multi_fd_sink_emit_client_added;
  gstmultihandlesink_class->emit_client_removed =
      gst_multi_fd_sink_emit_client_removed;

  gstmultihandlesink_class->stop_pre =
      GST_DEBUG_FUNCPTR (gst_multi_fd_sink_stop_pre);
  gstmultihandlesink_class->stop_post =
      GST_DEBUG_FUNCPTR (gst_multi_fd_sink_stop_post);
  gstmultihandlesink_class->start_pre =
      GST_DEBUG_FUNCPTR (gst_multi_fd_sink_start_pre);
  gstmultihandlesink_class->thread =
      GST_DEBUG_FUNCPTR (gst_multi_fd_sink_thread);
  gstmultihandlesink_class->new_client =
      GST_DEBUG_FUNCPTR (gst_multi_fd_sink_new_client);
  gstmultihandlesink_class->client_free = gst_multi_fd_sink_client_free;
  gstmultihandlesink_class->client_get_fd =
      GST_DEBUG_FUNCPTR (gst_multi_fd_sink_client_get_fd);
  gstmultihandlesink_class->handle_debug =
      GST_DEBUG_FUNCPTR (gst_multi_fd_sink_handle_debug);
  gstmultihandlesink_class->handle_hash_key =
      GST_DEBUG_FUNCPTR (gst_multi_fd_sink_handle_hash_key);
  gstmultihandlesink_class->hash_changed =
      GST_DEBUG_FUNCPTR (gst_multi_fd_sink_hash_changed);
  gstmultihandlesink_class->hash_adding =
      GST_DEBUG_FUNCPTR (gst_multi_fd_sink_hash_adding);
  gstmultihandlesink_class->hash_removing =
      GST_DEBUG_FUNCPTR (gst_multi_fd_sink_hash_removing);

  GST_DEBUG_CATEGORY_INIT (multifdsink_debug, "multifdsink", 0, "FD sink");
}

static void
gst_multi_fd_sink_init (GstMultiFdSink * this)
{
  GstMultiHandleSink *mhsink = GST_MULTI_HANDLE_SINK (this);

  mhsink->handle_hash = g_hash_table_new (g_direct_hash, g_direct_equal);

  this->handle_read = DEFAULT_HANDLE_READ;
}

/* methods to emit signals */

static void
gst_multi_fd_sink_emit_client_added (GstMultiHandleSink * mhsink,
    GstMultiSinkHandle handle)
{
  g_signal_emit (mhsink, gst_multi_fd_sink_signals[SIGNAL_CLIENT_ADDED], 0,
      handle.fd);
}

static void
gst_multi_fd_sink_emit_client_removed (GstMultiHandleSink * mhsink,
    GstMultiSinkHandle handle, GstClientStatus status)
{
  g_signal_emit (mhsink, gst_multi_fd_sink_signals[SIGNAL_CLIENT_REMOVED], 0,
      handle.fd, status);
}

static void
gst_multi_fd_sink_client_free (GstMultiHandleSink * mhsink,
    GstMultiHandleClient * client)
{
  g_signal_emit (mhsink, gst_multi_fd_sink_signals[SIGNAL_CLIENT_FD_REMOVED],
      0, client->handle.fd);
}

/* action signals */

static void
gst_multi_fd_sink_add (GstMultiFdSink * sink, int fd)
{
  GstMultiSinkHandle handle;

  handle.fd = fd;
  gst_multi_handle_sink_add (GST_MULTI_HANDLE_SINK_CAST (sink), handle);
}

static void
gst_multi_fd_sink_add_full (GstMultiFdSink * sink, int fd,
    GstSyncMethod sync, GstFormat min_format, guint64 min_value,
    GstFormat max_format, guint64 max_value)
{
  GstMultiSinkHandle handle;

  handle.fd = fd;
  gst_multi_handle_sink_add_full (GST_MULTI_HANDLE_SINK_CAST (sink), handle,
      sync, min_format, min_value, max_format, max_value);
}

static void
gst_multi_fd_sink_remove (GstMultiFdSink * sink, int fd)
{
  GstMultiSinkHandle handle;

  handle.fd = fd;
  gst_multi_handle_sink_remove (GST_MULTI_HANDLE_SINK_CAST (sink), handle);
}

static void
gst_multi_fd_sink_remove_flush (GstMultiFdSink * sink, int fd)
{
  GstMultiSinkHandle handle;

  handle.fd = fd;
  gst_multi_handle_sink_remove_flush (GST_MULTI_HANDLE_SINK_CAST (sink),
      handle);
}

static GstStructure *
gst_multi_fd_sink_get_stats (GstMultiFdSink * sink, int fd)
{
  GstMultiSinkHandle handle;

  handle.fd = fd;
  return gst_multi_handle_sink_get_stats (GST_MULTI_HANDLE_SINK_CAST (sink),
      handle);
}

/* vfuncs */

static GstMultiHandleClient *
gst_multi_fd_sink_new_client (GstMultiHandleSink * mhsink,
    GstMultiSinkHandle handle, GstSyncMethod sync_method)
{
  struct stat statbuf;
  GstTCPClient *client;
  GstMultiHandleClient *mhclient;
  GstMultiFdSink *sink = GST_MULTI_FD_SINK (mhsink);
  GstMultiHandleSinkClass *mhsinkclass =
      GST_MULTI_HANDLE_SINK_GET_CLASS (mhsink);

  /* create client datastructure */
  client = g_new0 (GstTCPClient, 1);
  mhclient = (GstMultiHandleClient *) client;

  mhclient->handle = handle;

  gst_poll_fd_init (&client->gfd);
  client->gfd.fd = mhclient->handle.fd;

  gst_multi_handle_sink_client_init (mhclient, sync_method);
  mhsinkclass->handle_debug (handle, mhclient->debug);

  /* set the socket to non blocking */
  if (fcntl (handle.fd, F_SETFL, O_NONBLOCK) < 0) {
    GST_ERROR_OBJECT (mhsink, "failed to make socket %s non-blocking: %s",
        mhclient->debug, g_strerror (errno));
  }

  /* we always read from a client */
  gst_poll_add_fd (sink->fdset, &client->gfd);

  /* we don't try to read from write only fds */
  if (sink->handle_read) {
    gint flags;

    flags = fcntl (handle.fd, F_GETFL, 0);
    if ((flags & O_ACCMODE) != O_WRONLY) {
      gst_poll_fd_ctl_read (sink->fdset, &client->gfd, TRUE);
    }
  }
  /* figure out the mode, can't use send() for non sockets */
  if (fstat (handle.fd, &statbuf) == 0 && S_ISSOCK (statbuf.st_mode)) {
    client->is_socket = TRUE;
    gst_multi_handle_sink_setup_dscp_client (mhsink, mhclient);
  }

  return mhclient;
}

static int
gst_multi_fd_sink_client_get_fd (GstMultiHandleClient * client)
{
  GstTCPClient *tclient = (GstTCPClient *) client;

  return tclient->gfd.fd;
}

static void
gst_multi_fd_sink_handle_debug (GstMultiSinkHandle handle, gchar debug[30])
{
  g_snprintf (debug, 30, "[fd %5d]", handle.fd);
}

static gpointer
gst_multi_fd_sink_handle_hash_key (GstMultiSinkHandle handle)
{
  return GINT_TO_POINTER (handle.fd);
}

static void
gst_multi_fd_sink_hash_changed (GstMultiHandleSink * mhsink)
{
  GstMultiFdSink *sink = GST_MULTI_FD_SINK (mhsink);

  gst_poll_restart (sink->fdset);
}

/* handle a read on a client fd,
 * which either indicates a close or should be ignored
 * returns FALSE if some error occured or the client closed. */
static gboolean
gst_multi_fd_sink_handle_client_read (GstMultiFdSink * sink,
    GstTCPClient * client)
{
  int avail, fd;
  gboolean ret;
  GstMultiHandleClient *mhclient = (GstMultiHandleClient *) client;

  fd = client->gfd.fd;

  if (ioctl (fd, FIONREAD, &avail) < 0)
    goto ioctl_failed;

  GST_DEBUG_OBJECT (sink, "%s select reports client read of %d bytes",
      mhclient->debug, avail);

  ret = TRUE;

  if (avail == 0) {
    /* client sent close, so remove it */
    GST_DEBUG_OBJECT (sink, "%s client asked for close, removing",
        mhclient->debug);
    mhclient->status = GST_CLIENT_STATUS_CLOSED;
    ret = FALSE;
  } else if (avail < 0) {
    GST_WARNING_OBJECT (sink, "%s avail < 0, removing", mhclient->debug);
    mhclient->status = GST_CLIENT_STATUS_ERROR;
    ret = FALSE;
  } else {
    guint8 dummy[512];
    gint nread;

    /* just Read 'n' Drop, could also just drop the client as it's not supposed
     * to write to us except for closing the socket, I guess it's because we
     * like to listen to our customers. */
    do {
      /* this is the maximum we can read */
      gint to_read = MIN (avail, 512);

      GST_DEBUG_OBJECT (sink, "%s client wants us to read %d bytes",
          mhclient->debug, to_read);

      nread = read (fd, dummy, to_read);
      if (nread < -1) {
        GST_WARNING_OBJECT (sink, "%s could not read %d bytes: %s (%d)",
            mhclient->debug, to_read, g_strerror (errno), errno);
        mhclient->status = GST_CLIENT_STATUS_ERROR;
        ret = FALSE;
        break;
      } else if (nread == 0) {
        GST_WARNING_OBJECT (sink, "%s 0 bytes in read, removing",
            mhclient->debug);
        mhclient->status = GST_CLIENT_STATUS_ERROR;
        ret = FALSE;
        break;
      }
      avail -= nread;
    }
    while (avail > 0);
  }
  return ret;

  /* ERRORS */
ioctl_failed:
  {
    GST_WARNING_OBJECT (sink, "%s ioctl failed: %s (%d)",
        mhclient->debug, g_strerror (errno), errno);
    mhclient->status = GST_CLIENT_STATUS_ERROR;
    return FALSE;
  }
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
gst_multi_fd_sink_handle_client_write (GstMultiFdSink * sink,
    GstTCPClient * client)
{
  gboolean more;
  gboolean flushing;
  GstClockTime now;
  GTimeVal nowtv;
  GstMultiHandleSink *mhsink = GST_MULTI_HANDLE_SINK (sink);
  GstMultiHandleSinkClass *mhsinkclass =
      GST_MULTI_HANDLE_SINK_GET_CLASS (mhsink);
  GstMultiHandleClient *mhclient = (GstMultiHandleClient *) client;
  int fd = mhclient->handle.fd;

  flushing = mhclient->status == GST_CLIENT_STATUS_FLUSHING;

  more = TRUE;
  do {
    gint maxsize;

    g_get_current_time (&nowtv);
    now = GST_TIMEVAL_TO_TIME (nowtv);

    if (!mhclient->sending) {
      /* client is not working on a buffer */
      if (mhclient->bufpos == -1) {
        /* client is too fast, remove from write queue until new buffer is
         * available */
        /* FIXME: specific */
        gst_poll_fd_ctl_write (sink->fdset, &client->gfd, FALSE);

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
            gst_poll_fd_ctl_write (sink->fdset, &client->gfd, FALSE);
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
      ssize_t wrote;
      GstBuffer *head;
      GstMapInfo info;
      guint8 *data;

      /* pick first buffer from list */
      head = GST_BUFFER (mhclient->sending->data);

      if (!gst_buffer_map (head, &info, GST_MAP_READ))
        g_return_val_if_reached (FALSE);

      data = info.data;
      maxsize = info.size - mhclient->bufoffset;

      /* FIXME: specific */
      /* try to write the complete buffer */
#ifdef MSG_NOSIGNAL
#define FLAGS MSG_NOSIGNAL
#else
#define FLAGS 0
#endif
      if (client->is_socket) {
        wrote = send (fd, data + mhclient->bufoffset, maxsize, FLAGS);
      } else {
        wrote = write (fd, data + mhclient->bufoffset, maxsize);
      }
      gst_buffer_unmap (head, &info);

      if (wrote < 0) {
        /* hmm error.. */
        if (errno == EAGAIN) {
          /* nothing serious, resource was unavailable, try again later */
          more = FALSE;
        } else if (errno == ECONNRESET) {
          goto connection_reset;
        } else {
          goto write_error;
        }
      } else {
        if (wrote < maxsize) {
          /* partial write means that the client cannot read more and we should
           * stop sending more */
          GST_LOG_OBJECT (sink,
              "partial write on %s of %" G_GSSIZE_FORMAT " bytes",
              mhclient->debug, wrote);
          mhclient->bufoffset += wrote;
          more = FALSE;
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
    return FALSE;
  }
write_error:
  {
    GST_WARNING_OBJECT (sink,
        "%s could not write, removing client: %s (%d)", mhclient->debug,
        g_strerror (errno), errno);
    mhclient->status = GST_CLIENT_STATUS_ERROR;
    return FALSE;
  }
}

static void
gst_multi_fd_sink_hash_adding (GstMultiHandleSink * mhsink,
    GstMultiHandleClient * mhclient)
{
  GstMultiFdSink *sink = GST_MULTI_FD_SINK (mhsink);
  GstTCPClient *client = (GstTCPClient *) mhclient;

  gst_poll_fd_ctl_write (sink->fdset, &client->gfd, TRUE);
}

static void
gst_multi_fd_sink_hash_removing (GstMultiHandleSink * mhsink,
    GstMultiHandleClient * mhclient)
{
  GstMultiFdSink *sink = GST_MULTI_FD_SINK (mhsink);
  GstTCPClient *client = (GstTCPClient *) mhclient;

  gst_poll_remove_fd (sink->fdset, &client->gfd);
}


/* Handle the clients. Basically does a blocking select for one
 * of the client fds to become read or writable. We also have a
 * filedescriptor to receive commands on that we need to check.
 *
 * After going out of the select call, we read and write to all
 * clients that can do so. Badly behaving clients are put on a
 * garbage list and removed.
 */
static void
gst_multi_fd_sink_handle_clients (GstMultiFdSink * sink)
{
  int result;
  GList *clients, *next;
  gboolean try_again;
  GstMultiFdSinkClass *fclass;
  guint cookie;
  GstMultiHandleSink *mhsink = GST_MULTI_HANDLE_SINK (sink);
  int fd;


  fclass = GST_MULTI_FD_SINK_GET_CLASS (sink);

  do {
    try_again = FALSE;

    /* check for:
     * - server socket input (ie, new client connections)
     * - client socket input (ie, clients saying goodbye)
     * - client socket output (ie, client reads)          */
    GST_LOG_OBJECT (sink, "waiting on action on fdset");

    result =
        gst_poll_wait (sink->fdset,
        mhsink->timeout != 0 ? mhsink->timeout : GST_CLOCK_TIME_NONE);

    /* Handle the special case in which the sink is not receiving more buffers
     * and will not disconnect inactive client in the streaming thread. */
    if (G_UNLIKELY (result == 0)) {
      GstClockTime now;
      GTimeVal nowtv;

      g_get_current_time (&nowtv);
      now = GST_TIMEVAL_TO_TIME (nowtv);

      CLIENTS_LOCK (mhsink);
      for (clients = mhsink->clients; clients; clients = next) {
        GstTCPClient *client;
        GstMultiHandleClient *mhclient;

        client = (GstTCPClient *) clients->data;
        mhclient = (GstMultiHandleClient *) client;
        next = g_list_next (clients);
        if (mhsink->timeout > 0
            && now - mhclient->last_activity_time > mhsink->timeout) {
          mhclient->status = GST_CLIENT_STATUS_SLOW;
          gst_multi_handle_sink_remove_client_link (mhsink, clients);
        }
      }
      CLIENTS_UNLOCK (mhsink);
      return;
    } else if (result < 0) {
      GST_WARNING_OBJECT (sink, "wait failed: %s (%d)", g_strerror (errno),
          errno);
      if (errno == EBADF) {
        /* ok, so one or more of the fds is invalid. We loop over them to find
         * the ones that give an error to the F_GETFL fcntl. */
        CLIENTS_LOCK (mhsink);
      restart:
        cookie = mhsink->clients_cookie;
        for (clients = mhsink->clients; clients; clients = next) {
          GstTCPClient *client;
          GstMultiHandleClient *mhclient;
          long flags;
          int res;

          if (cookie != mhsink->clients_cookie) {
            GST_DEBUG_OBJECT (sink, "Cookie changed finding bad fd");
            goto restart;
          }

          client = (GstTCPClient *) clients->data;
          mhclient = (GstMultiHandleClient *) client;
          next = g_list_next (clients);

          fd = client->gfd.fd;

          res = fcntl (fd, F_GETFL, &flags);
          if (res == -1) {
            GST_WARNING_OBJECT (sink, "fnctl failed for %d, removing: %s (%d)",
                fd, g_strerror (errno), errno);
            if (errno == EBADF) {
              mhclient->status = GST_CLIENT_STATUS_ERROR;
              /* releases the CLIENTS lock */
              gst_multi_handle_sink_remove_client_link (mhsink, clients);
            }
          }
        }
        CLIENTS_UNLOCK (mhsink);
        /* after this, go back in the select loop as the read/writefds
         * are not valid */
        try_again = TRUE;
      } else if (errno == EINTR) {
        /* interrupted system call, just redo the wait */
        try_again = TRUE;
      } else if (errno == EBUSY) {
        /* the call to gst_poll_wait() was flushed */
        return;
      } else {
        /* this is quite bad... */
        GST_ELEMENT_ERROR (sink, RESOURCE, READ, (NULL),
            ("select failed: %s (%d)", g_strerror (errno), errno));
        return;
      }
    } else {
      GST_LOG_OBJECT (sink, "wait done: %d sockets with events", result);
    }
  } while (try_again);

  /* subclasses can check fdset with this virtual function */
  if (fclass->wait)
    fclass->wait (sink, sink->fdset);

  /* Check the clients */
  CLIENTS_LOCK (mhsink);

restart2:
  cookie = mhsink->clients_cookie;
  for (clients = mhsink->clients; clients; clients = next) {
    GstTCPClient *client;
    GstMultiHandleClient *mhclient;

    if (mhsink->clients_cookie != cookie) {
      GST_DEBUG_OBJECT (sink, "Restarting loop, cookie out of date");
      goto restart2;
    }

    client = (GstTCPClient *) clients->data;
    mhclient = (GstMultiHandleClient *) client;
    next = g_list_next (clients);

    if (mhclient->status != GST_CLIENT_STATUS_FLUSHING
        && mhclient->status != GST_CLIENT_STATUS_OK) {
      gst_multi_handle_sink_remove_client_link (mhsink, clients);
      continue;
    }

    if (gst_poll_fd_has_closed (sink->fdset, &client->gfd)) {
      mhclient->status = GST_CLIENT_STATUS_CLOSED;
      gst_multi_handle_sink_remove_client_link (mhsink, clients);
      continue;
    }
    if (gst_poll_fd_has_error (sink->fdset, &client->gfd)) {
      GST_WARNING_OBJECT (sink, "gst_poll_fd_has_error for %d", client->gfd.fd);
      mhclient->status = GST_CLIENT_STATUS_ERROR;
      gst_multi_handle_sink_remove_client_link (mhsink, clients);
      continue;
    }
    if (gst_poll_fd_can_read (sink->fdset, &client->gfd)) {
      /* handle client read */
      if (!gst_multi_fd_sink_handle_client_read (sink, client)) {
        gst_multi_handle_sink_remove_client_link (mhsink, clients);
        continue;
      }
    }
    if (gst_poll_fd_can_write (sink->fdset, &client->gfd)) {
      /* handle client write */
      if (!gst_multi_fd_sink_handle_client_write (sink, client)) {
        gst_multi_handle_sink_remove_client_link (mhsink, clients);
        continue;
      }
    }
  }
  CLIENTS_UNLOCK (mhsink);
}

/* we handle the client communication in another thread so that we do not block
 * the gstreamer thread while we select() on the client fds */
static gpointer
gst_multi_fd_sink_thread (GstMultiHandleSink * mhsink)
{
  GstMultiFdSink *sink = GST_MULTI_FD_SINK (mhsink);

  while (mhsink->running) {
    gst_multi_fd_sink_handle_clients (sink);
  }
  return NULL;
}

static void
gst_multi_fd_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstMultiFdSink *multifdsink;

  multifdsink = GST_MULTI_FD_SINK (object);

  switch (prop_id) {
    case PROP_HANDLE_READ:
      multifdsink->handle_read = g_value_get_boolean (value);
      break;

    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_multi_fd_sink_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstMultiFdSink *multifdsink;

  multifdsink = GST_MULTI_FD_SINK (object);

  switch (prop_id) {
    case PROP_HANDLE_READ:
      g_value_set_boolean (value, multifdsink->handle_read);
      break;

    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static gboolean
gst_multi_fd_sink_start_pre (GstMultiHandleSink * mhsink)
{
  GstMultiFdSink *mfsink = GST_MULTI_FD_SINK (mhsink);

  GST_INFO_OBJECT (mfsink, "starting");
  if ((mfsink->fdset = gst_poll_new (TRUE)) == NULL)
    goto socket_pair;

  return TRUE;

  /* ERRORS */
socket_pair:
  {
    GST_ELEMENT_ERROR (mfsink, RESOURCE, OPEN_READ_WRITE, (NULL),
        GST_ERROR_SYSTEM);
    return FALSE;
  }
}

static gboolean
multifdsink_hash_remove (gpointer key, gpointer value, gpointer data)
{
  return TRUE;
}

static void
gst_multi_fd_sink_stop_pre (GstMultiHandleSink * mhsink)
{
  GstMultiFdSink *mfsink = GST_MULTI_FD_SINK (mhsink);

  gst_poll_set_flushing (mfsink->fdset, TRUE);
}

static void
gst_multi_fd_sink_stop_post (GstMultiHandleSink * mhsink)
{
  GstMultiFdSink *mfsink = GST_MULTI_FD_SINK (mhsink);

  if (mfsink->fdset) {
    gst_poll_free (mfsink->fdset);
    mfsink->fdset = NULL;
  }
  g_hash_table_foreach_remove (mhsink->handle_hash, multifdsink_hash_remove,
      mfsink);
}
