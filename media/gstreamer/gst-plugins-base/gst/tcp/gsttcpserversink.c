/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
 * Copyright (C) <2004> Thomas Vander Stichele <thomas at apestaart dot org>
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
 * SECTION:element-tcpserversink
 * @see_also: #multifdsink
 *
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * # server:
 * gst-launch fdsrc fd=1 ! tcpserversink port=3000
 * # client:
 * gst-launch tcpclientsrc port=3000 ! fdsink fd=2
 * ]| 
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif
#include <gst/gst-i18n-plugin.h>
#include <string.h>             /* memset */

#include "gsttcp.h"
#include "gsttcpserversink.h"

#define TCP_BACKLOG             5

GST_DEBUG_CATEGORY_STATIC (tcpserversink_debug);
#define GST_CAT_DEFAULT (tcpserversink_debug)

enum
{
  PROP_0,
  PROP_HOST,
  PROP_PORT,
  PROP_CURRENT_PORT
};

static void gst_tcp_server_sink_finalize (GObject * gobject);

static gboolean gst_tcp_server_sink_init_send (GstMultiHandleSink * this);
static gboolean gst_tcp_server_sink_close (GstMultiHandleSink * this);
static void gst_tcp_server_sink_removed (GstMultiHandleSink * sink,
    GstMultiSinkHandle handle);

static void gst_tcp_server_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_tcp_server_sink_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

#define gst_tcp_server_sink_parent_class parent_class
G_DEFINE_TYPE (GstTCPServerSink, gst_tcp_server_sink,
    GST_TYPE_MULTI_SOCKET_SINK);

static void
gst_tcp_server_sink_class_init (GstTCPServerSinkClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstMultiHandleSinkClass *gstmultihandlesink_class;

  gobject_class = (GObjectClass *) klass;
  gstelement_class = (GstElementClass *) klass;
  gstmultihandlesink_class = (GstMultiHandleSinkClass *) klass;

  gobject_class->set_property = gst_tcp_server_sink_set_property;
  gobject_class->get_property = gst_tcp_server_sink_get_property;
  gobject_class->finalize = gst_tcp_server_sink_finalize;

  /* FIXME 2.0: Rename this to bind-address, host does not make much
   * sense here */
  g_object_class_install_property (gobject_class, PROP_HOST,
      g_param_spec_string ("host", "host", "The host/IP to listen on",
          TCP_DEFAULT_HOST, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_PORT,
      g_param_spec_int ("port", "port",
          "The port to listen to (0=random available port)",
          0, TCP_HIGHEST_PORT, TCP_DEFAULT_PORT,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstTCPServerSink:current-port:
   *
   * The port number the socket is currently bound to. Applications can use
   * this property to retrieve the port number actually bound to in case
   * the port requested was 0 (=allocate a random available port).
   *
   * Since: 1.0.2
   **/
  g_object_class_install_property (gobject_class, PROP_CURRENT_PORT,
      g_param_spec_int ("current-port", "current-port",
          "The port number the socket is currently bound to", 0,
          TCP_HIGHEST_PORT, 0, G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));

  gst_element_class_set_static_metadata (gstelement_class,
      "TCP server sink", "Sink/Network",
      "Send data as a server over the network via TCP",
      "Thomas Vander Stichele <thomas at apestaart dot org>");

  gstmultihandlesink_class->init = gst_tcp_server_sink_init_send;
  gstmultihandlesink_class->close = gst_tcp_server_sink_close;
  gstmultihandlesink_class->removed = gst_tcp_server_sink_removed;

  GST_DEBUG_CATEGORY_INIT (tcpserversink_debug, "tcpserversink", 0, "TCP sink");
}

static void
gst_tcp_server_sink_init (GstTCPServerSink * this)
{
  this->server_port = TCP_DEFAULT_PORT;
  /* should support as minimum 576 for IPV4 and 1500 for IPV6 */
  /* this->mtu = 1500; */
  this->host = g_strdup (TCP_DEFAULT_HOST);

  this->server_socket = NULL;
}

static void
gst_tcp_server_sink_finalize (GObject * gobject)
{
  GstTCPServerSink *this = GST_TCP_SERVER_SINK (gobject);

  if (this->server_socket)
    g_object_unref (this->server_socket);
  this->server_socket = NULL;
  g_free (this->host);
  this->host = NULL;

  G_OBJECT_CLASS (parent_class)->finalize (gobject);
}

/* handle a read request on the server,
 * which indicates a new client connection */
static gboolean
gst_tcp_server_sink_handle_server_read (GstTCPServerSink * sink)
{
  GstMultiSinkHandle handle;
  GSocket *client_socket;
  GError *err = NULL;

  /* wait on server socket for connections */
  client_socket =
      g_socket_accept (sink->server_socket, sink->element.cancellable, &err);
  if (!client_socket)
    goto accept_failed;

  handle.socket = client_socket;
  gst_multi_handle_sink_add (GST_MULTI_HANDLE_SINK (sink), handle);

#ifndef GST_DISABLE_GST_DEBUG
  {
    GInetSocketAddress *addr =
        G_INET_SOCKET_ADDRESS (g_socket_get_remote_address (client_socket,
            NULL));
    gchar *ip =
        g_inet_address_to_string (g_inet_socket_address_get_address (addr));

    GST_DEBUG_OBJECT (sink, "added new client ip %s:%u with socket %p",
        ip, g_inet_socket_address_get_port (addr), client_socket);

    g_free (ip);
  }
#endif

  return TRUE;

  /* ERRORS */
accept_failed:
  {
    GST_ELEMENT_ERROR (sink, RESOURCE, OPEN_WRITE, (NULL),
        ("Could not accept client on server socket %p: %s",
            sink->server_socket, err->message));
    g_clear_error (&err);
    return FALSE;
  }
}

static void
gst_tcp_server_sink_removed (GstMultiHandleSink * sink,
    GstMultiSinkHandle handle)
{
  GError *err = NULL;

  GST_DEBUG_OBJECT (sink, "closing socket");

  if (!g_socket_close (handle.socket, &err)) {
    GST_ERROR_OBJECT (sink, "Failed to close socket: %s", err->message);
    g_clear_error (&err);
  }
}

static gboolean
gst_tcp_server_sink_socket_condition (GSocket * socket, GIOCondition condition,
    GstTCPServerSink * sink)
{
  if ((condition & G_IO_ERR)) {
    goto error;
  } else if ((condition & G_IO_IN) || (condition & G_IO_PRI)) {
    if (!gst_tcp_server_sink_handle_server_read (sink))
      return FALSE;
  }

  return TRUE;

error:
  GST_ELEMENT_ERROR (sink, RESOURCE, READ, (NULL),
      ("client connection failed"));

  return FALSE;
}

static void
gst_tcp_server_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstTCPServerSink *sink;

  sink = GST_TCP_SERVER_SINK (object);

  switch (prop_id) {
    case PROP_HOST:
      if (!g_value_get_string (value)) {
        g_warning ("host property cannot be NULL");
        break;
      }
      g_free (sink->host);
      sink->host = g_strdup (g_value_get_string (value));
      break;
    case PROP_PORT:
      sink->server_port = g_value_get_int (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_tcp_server_sink_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstTCPServerSink *sink;

  sink = GST_TCP_SERVER_SINK (object);

  switch (prop_id) {
    case PROP_HOST:
      g_value_set_string (value, sink->host);
      break;
    case PROP_PORT:
      g_value_set_int (value, sink->server_port);
      break;
    case PROP_CURRENT_PORT:
      g_value_set_int (value, g_atomic_int_get (&sink->current_port));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}


/* create a socket for sending to remote machine */
static gboolean
gst_tcp_server_sink_init_send (GstMultiHandleSink * parent)
{
  GstTCPServerSink *this = GST_TCP_SERVER_SINK (parent);
  GError *err = NULL;
  GInetAddress *addr;
  GSocketAddress *saddr;
  GResolver *resolver;
  gint bound_port;

  /* look up name if we need to */
  addr = g_inet_address_new_from_string (this->host);
  if (!addr) {
    GList *results;

    resolver = g_resolver_get_default ();

    results =
        g_resolver_lookup_by_name (resolver, this->host,
        this->element.cancellable, &err);
    if (!results)
      goto name_resolve;
    addr = G_INET_ADDRESS (g_object_ref (results->data));

    g_resolver_free_addresses (results);
    g_object_unref (resolver);
  }
#ifndef GST_DISABLE_GST_DEBUG
  {
    gchar *ip = g_inet_address_to_string (addr);

    GST_DEBUG_OBJECT (this, "IP address for host %s is %s", this->host, ip);
    g_free (ip);
  }
#endif
  saddr = g_inet_socket_address_new (addr, this->server_port);
  g_object_unref (addr);

  /* create the server listener socket */
  this->server_socket =
      g_socket_new (g_socket_address_get_family (saddr), G_SOCKET_TYPE_STREAM,
      G_SOCKET_PROTOCOL_TCP, &err);
  if (!this->server_socket)
    goto no_socket;

  GST_DEBUG_OBJECT (this, "opened sending server socket with socket %p",
      this->server_socket);

  g_socket_set_blocking (this->server_socket, FALSE);

  /* bind it */
  GST_DEBUG_OBJECT (this, "binding server socket to address");
  if (!g_socket_bind (this->server_socket, saddr, TRUE, &err))
    goto bind_failed;

  g_object_unref (saddr);

  GST_DEBUG_OBJECT (this, "listening on server socket");
  g_socket_set_listen_backlog (this->server_socket, TCP_BACKLOG);

  if (!g_socket_listen (this->server_socket, &err))
    goto listen_failed;

  GST_DEBUG_OBJECT (this, "listened on server socket %p", this->server_socket);

  if (this->server_port == 0) {
    saddr = g_socket_get_local_address (this->server_socket, NULL);
    bound_port = g_inet_socket_address_get_port ((GInetSocketAddress *) saddr);
    g_object_unref (saddr);
  } else {
    bound_port = this->server_port;
  }

  GST_DEBUG_OBJECT (this, "listening on port %d", bound_port);

  g_atomic_int_set (&this->current_port, bound_port);

  g_object_notify (G_OBJECT (this), "current-port");

  this->server_source =
      g_socket_create_source (this->server_socket,
      G_IO_IN | G_IO_OUT | G_IO_PRI | G_IO_ERR | G_IO_HUP,
      this->element.cancellable);
  g_source_set_callback (this->server_source,
      (GSourceFunc) gst_tcp_server_sink_socket_condition, gst_object_ref (this),
      (GDestroyNotify) gst_object_unref);
  g_source_attach (this->server_source, this->element.main_context);

  return TRUE;

  /* ERRORS */
no_socket:
  {
    GST_ELEMENT_ERROR (this, RESOURCE, OPEN_READ, (NULL),
        ("Failed to create socket: %s", err->message));
    g_clear_error (&err);
    g_object_unref (saddr);
    return FALSE;
  }
name_resolve:
  {
    if (g_error_matches (err, G_IO_ERROR, G_IO_ERROR_CANCELLED)) {
      GST_DEBUG_OBJECT (this, "Cancelled name resolval");
    } else {
      GST_ELEMENT_ERROR (this, RESOURCE, OPEN_READ, (NULL),
          ("Failed to resolve host '%s': %s", this->host, err->message));
    }
    g_clear_error (&err);
    g_object_unref (resolver);
    return FALSE;
  }
bind_failed:
  {
    if (g_error_matches (err, G_IO_ERROR, G_IO_ERROR_CANCELLED)) {
      GST_DEBUG_OBJECT (this, "Cancelled binding");
    } else {
      GST_ELEMENT_ERROR (this, RESOURCE, OPEN_READ, (NULL),
          ("Failed to bind on host '%s:%d': %s", this->host, this->server_port,
              err->message));
    }
    g_clear_error (&err);
    g_object_unref (saddr);
    gst_tcp_server_sink_close (GST_MULTI_HANDLE_SINK (&this->element));
    return FALSE;
  }
listen_failed:
  {
    if (g_error_matches (err, G_IO_ERROR, G_IO_ERROR_CANCELLED)) {
      GST_DEBUG_OBJECT (this, "Cancelled listening");
    } else {
      GST_ELEMENT_ERROR (this, RESOURCE, OPEN_READ, (NULL),
          ("Failed to listen on host '%s:%d': %s", this->host,
              this->server_port, err->message));
    }
    g_clear_error (&err);
    gst_tcp_server_sink_close (GST_MULTI_HANDLE_SINK (&this->element));
    return FALSE;
  }
}

static gboolean
gst_tcp_server_sink_close (GstMultiHandleSink * parent)
{
  GstTCPServerSink *this = GST_TCP_SERVER_SINK (parent);

  if (this->server_source) {
    g_source_destroy (this->server_source);
    g_source_unref (this->server_source);
    this->server_source = NULL;
  }

  if (this->server_socket) {
    GError *err = NULL;

    GST_DEBUG_OBJECT (this, "closing socket");

    if (!g_socket_close (this->server_socket, &err)) {
      GST_ERROR_OBJECT (this, "Failed to close socket: %s", err->message);
      g_clear_error (&err);
    }
    g_object_unref (this->server_socket);
    this->server_socket = NULL;

    g_atomic_int_set (&this->current_port, 0);
    g_object_notify (G_OBJECT (this), "current-port");
  }

  return TRUE;
}
