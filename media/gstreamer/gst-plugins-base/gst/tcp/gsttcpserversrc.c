/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
 * Copyright (C) <2004> Thomas Vander Stichele <thomas at apestaart dot org>
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
 * SECTION:element-tcpserversrc
 * @see_also: #tcpserversink
 *
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * # server:
 * gst-launch tcpserversrc port=3000 ! fdsink fd=2
 * # client:
 * gst-launch fdsrc fd=1 ! tcpclientsink port=3000
 * ]| 
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/gst-i18n-plugin.h>
#include "gsttcp.h"
#include "gsttcpserversrc.h"

GST_DEBUG_CATEGORY_STATIC (tcpserversrc_debug);
#define GST_CAT_DEFAULT tcpserversrc_debug

#define TCP_DEFAULT_LISTEN_HOST         NULL    /* listen on all interfaces */
#define TCP_BACKLOG                     1       /* client connection queue */

#define MAX_READ_SIZE                   4 * 1024

static GstStaticPadTemplate srctemplate = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

enum
{
  PROP_0,
  PROP_HOST,
  PROP_PORT,
  PROP_CURRENT_PORT
};

#define gst_tcp_server_src_parent_class parent_class
G_DEFINE_TYPE (GstTCPServerSrc, gst_tcp_server_src, GST_TYPE_PUSH_SRC);

static void gst_tcp_server_src_finalize (GObject * gobject);

static gboolean gst_tcp_server_src_start (GstBaseSrc * bsrc);
static gboolean gst_tcp_server_src_stop (GstBaseSrc * bsrc);
static gboolean gst_tcp_server_src_unlock (GstBaseSrc * bsrc);
static gboolean gst_tcp_server_src_unlock_stop (GstBaseSrc * bsrc);
static GstFlowReturn gst_tcp_server_src_create (GstPushSrc * psrc,
    GstBuffer ** buf);

static void gst_tcp_server_src_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_tcp_server_src_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

static void
gst_tcp_server_src_class_init (GstTCPServerSrcClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstBaseSrcClass *gstbasesrc_class;
  GstPushSrcClass *gstpush_src_class;

  gobject_class = (GObjectClass *) klass;
  gstelement_class = (GstElementClass *) klass;
  gstbasesrc_class = (GstBaseSrcClass *) klass;
  gstpush_src_class = (GstPushSrcClass *) klass;

  gobject_class->set_property = gst_tcp_server_src_set_property;
  gobject_class->get_property = gst_tcp_server_src_get_property;
  gobject_class->finalize = gst_tcp_server_src_finalize;

  /* FIXME 2.0: Rename this to bind-address, host does not make much
   * sense here */
  g_object_class_install_property (gobject_class, PROP_HOST,
      g_param_spec_string ("host", "Host", "The hostname to listen as",
          TCP_DEFAULT_LISTEN_HOST, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_PORT,
      g_param_spec_int ("port", "Port",
          "The port to listen to (0=random available port)",
          0, TCP_HIGHEST_PORT, TCP_DEFAULT_PORT,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstTCPServerSrc:current-port:
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

  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&srctemplate));

  gst_element_class_set_static_metadata (gstelement_class,
      "TCP server source", "Source/Network",
      "Receive data as a server over the network via TCP",
      "Thomas Vander Stichele <thomas at apestaart dot org>");

  gstbasesrc_class->start = gst_tcp_server_src_start;
  gstbasesrc_class->stop = gst_tcp_server_src_stop;
  gstbasesrc_class->unlock = gst_tcp_server_src_unlock;
  gstbasesrc_class->unlock_stop = gst_tcp_server_src_unlock_stop;

  gstpush_src_class->create = gst_tcp_server_src_create;

  GST_DEBUG_CATEGORY_INIT (tcpserversrc_debug, "tcpserversrc", 0,
      "TCP Server Source");
}

static void
gst_tcp_server_src_init (GstTCPServerSrc * src)
{
  src->server_port = TCP_DEFAULT_PORT;
  src->host = g_strdup (TCP_DEFAULT_HOST);
  src->server_socket = NULL;
  src->client_socket = NULL;
  src->cancellable = g_cancellable_new ();

  GST_OBJECT_FLAG_UNSET (src, GST_TCP_SERVER_SRC_OPEN);
}

static void
gst_tcp_server_src_finalize (GObject * gobject)
{
  GstTCPServerSrc *src = GST_TCP_SERVER_SRC (gobject);

  if (src->cancellable)
    g_object_unref (src->cancellable);
  src->cancellable = NULL;
  if (src->server_socket)
    g_object_unref (src->server_socket);
  src->server_socket = NULL;
  if (src->client_socket)
    g_object_unref (src->client_socket);
  src->client_socket = NULL;

  g_free (src->host);
  src->host = NULL;

  G_OBJECT_CLASS (parent_class)->finalize (gobject);
}

static GstFlowReturn
gst_tcp_server_src_create (GstPushSrc * psrc, GstBuffer ** outbuf)
{
  GstTCPServerSrc *src;
  GstFlowReturn ret = GST_FLOW_OK;
  gssize rret, avail;
  gsize read;
  GError *err = NULL;
  GstMapInfo map;

  src = GST_TCP_SERVER_SRC (psrc);

  if (!GST_OBJECT_FLAG_IS_SET (src, GST_TCP_SERVER_SRC_OPEN))
    goto wrong_state;

  if (!src->client_socket) {
    /* wait on server socket for connections */
    src->client_socket =
        g_socket_accept (src->server_socket, src->cancellable, &err);
    if (!src->client_socket)
      goto accept_error;
    GST_DEBUG_OBJECT (src, "closing server socket");

    if (!g_socket_close (src->server_socket, &err)) {
      GST_ERROR_OBJECT (src, "Failed to close socket: %s", err->message);
      g_clear_error (&err);
    }
    /* now read from the socket. */
  }

  /* if we have a client, wait for read */
  GST_LOG_OBJECT (src, "asked for a buffer");

  /* read the buffer header */
  avail = g_socket_get_available_bytes (src->client_socket);
  if (avail < 0) {
    goto get_available_error;
  } else if (avail == 0) {
    GIOCondition condition;

    if (!g_socket_condition_wait (src->client_socket,
            G_IO_IN | G_IO_PRI | G_IO_ERR | G_IO_HUP, src->cancellable, &err))
      goto select_error;

    condition =
        g_socket_condition_check (src->client_socket,
        G_IO_IN | G_IO_PRI | G_IO_ERR | G_IO_HUP);

    if ((condition & G_IO_ERR)) {
      GST_ELEMENT_ERROR (src, RESOURCE, READ, (NULL),
          ("Socket in error state"));
      *outbuf = NULL;
      ret = GST_FLOW_ERROR;
      goto done;
    } else if ((condition & G_IO_HUP)) {
      GST_DEBUG_OBJECT (src, "Connection closed");
      *outbuf = NULL;
      ret = GST_FLOW_EOS;
      goto done;
    }
    avail = g_socket_get_available_bytes (src->client_socket);
    if (avail < 0)
      goto get_available_error;
  }

  if (avail > 0) {
    read = MIN (avail, MAX_READ_SIZE);
    *outbuf = gst_buffer_new_and_alloc (read);
    gst_buffer_map (*outbuf, &map, GST_MAP_READWRITE);
    rret =
        g_socket_receive (src->client_socket, (gchar *) map.data, read,
        src->cancellable, &err);
  } else {
    /* Connection closed */
    rret = 0;
    *outbuf = NULL;
    read = 0;
  }

  if (rret == 0) {
    GST_DEBUG_OBJECT (src, "Connection closed");
    ret = GST_FLOW_EOS;
    if (*outbuf) {
      gst_buffer_unmap (*outbuf, &map);
      gst_buffer_unref (*outbuf);
    }
    *outbuf = NULL;
  } else if (rret < 0) {
    if (g_error_matches (err, G_IO_ERROR, G_IO_ERROR_CANCELLED)) {
      ret = GST_FLOW_FLUSHING;
      GST_DEBUG_OBJECT (src, "Cancelled reading from socket");
    } else {
      ret = GST_FLOW_ERROR;
      GST_ELEMENT_ERROR (src, RESOURCE, READ, (NULL),
          ("Failed to read from socket: %s", err->message));
    }
    gst_buffer_unmap (*outbuf, &map);
    gst_buffer_unref (*outbuf);
    *outbuf = NULL;
  } else {
    ret = GST_FLOW_OK;
    gst_buffer_unmap (*outbuf, &map);
    gst_buffer_resize (*outbuf, 0, rret);

    GST_LOG_OBJECT (src,
        "Returning buffer from _get of size %" G_GSIZE_FORMAT ", ts %"
        GST_TIME_FORMAT ", dur %" GST_TIME_FORMAT
        ", offset %" G_GINT64_FORMAT ", offset_end %" G_GINT64_FORMAT,
        gst_buffer_get_size (*outbuf),
        GST_TIME_ARGS (GST_BUFFER_TIMESTAMP (*outbuf)),
        GST_TIME_ARGS (GST_BUFFER_DURATION (*outbuf)),
        GST_BUFFER_OFFSET (*outbuf), GST_BUFFER_OFFSET_END (*outbuf));
  }
  g_clear_error (&err);

done:
  return ret;

wrong_state:
  {
    GST_DEBUG_OBJECT (src, "connection to closed, cannot read data");
    return GST_FLOW_FLUSHING;
  }
accept_error:
  {
    if (g_error_matches (err, G_IO_ERROR, G_IO_ERROR_CANCELLED)) {
      GST_DEBUG_OBJECT (src, "Cancelled accepting of client");
      ret = GST_FLOW_FLUSHING;
    } else {
      GST_ELEMENT_ERROR (src, RESOURCE, OPEN_READ, (NULL),
          ("Failed to accept client: %s", err->message));
      ret = GST_FLOW_ERROR;
    }
    g_clear_error (&err);
    return ret;
  }
select_error:
  {
    if (g_error_matches (err, G_IO_ERROR, G_IO_ERROR_CANCELLED)) {
      GST_DEBUG_OBJECT (src, "Cancelled select");
      ret = GST_FLOW_FLUSHING;
    } else {
      GST_ELEMENT_ERROR (src, RESOURCE, OPEN_READ, (NULL),
          ("Select failed: %s", err->message));
      ret = GST_FLOW_ERROR;
    }
    g_clear_error (&err);
    return ret;
  }
get_available_error:
  {
    GST_ELEMENT_ERROR (src, RESOURCE, READ, (NULL),
        ("Failed to get available bytes from socket"));
    return GST_FLOW_ERROR;
  }
}

static void
gst_tcp_server_src_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstTCPServerSrc *tcpserversrc = GST_TCP_SERVER_SRC (object);

  switch (prop_id) {
    case PROP_HOST:
      if (!g_value_get_string (value)) {
        g_warning ("host property cannot be NULL");
        break;
      }
      g_free (tcpserversrc->host);
      tcpserversrc->host = g_strdup (g_value_get_string (value));
      break;
    case PROP_PORT:
      tcpserversrc->server_port = g_value_get_int (value);
      break;

    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_tcp_server_src_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstTCPServerSrc *tcpserversrc = GST_TCP_SERVER_SRC (object);

  switch (prop_id) {
    case PROP_HOST:
      g_value_set_string (value, tcpserversrc->host);
      break;
    case PROP_PORT:
      g_value_set_int (value, tcpserversrc->server_port);
      break;
    case PROP_CURRENT_PORT:
      g_value_set_int (value, g_atomic_int_get (&tcpserversrc->current_port));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

/* set up server */
static gboolean
gst_tcp_server_src_start (GstBaseSrc * bsrc)
{
  GstTCPServerSrc *src = GST_TCP_SERVER_SRC (bsrc);
  GError *err = NULL;
  GInetAddress *addr;
  GSocketAddress *saddr;
  GResolver *resolver;
  gint bound_port = 0;

  /* look up name if we need to */
  addr = g_inet_address_new_from_string (src->host);
  if (!addr) {
    GList *results;

    resolver = g_resolver_get_default ();

    results =
        g_resolver_lookup_by_name (resolver, src->host, src->cancellable, &err);
    if (!results)
      goto name_resolve;
    addr = G_INET_ADDRESS (g_object_ref (results->data));

    g_resolver_free_addresses (results);
    g_object_unref (resolver);
  }
#ifndef GST_DISABLE_GST_DEBUG
  {
    gchar *ip = g_inet_address_to_string (addr);

    GST_DEBUG_OBJECT (src, "IP address for host %s is %s", src->host, ip);
    g_free (ip);
  }
#endif

  saddr = g_inet_socket_address_new (addr, src->server_port);
  g_object_unref (addr);

  /* create the server listener socket */
  src->server_socket =
      g_socket_new (g_socket_address_get_family (saddr), G_SOCKET_TYPE_STREAM,
      G_SOCKET_PROTOCOL_TCP, &err);
  if (!src->server_socket)
    goto no_socket;

  GST_DEBUG_OBJECT (src, "opened receiving server socket");

  /* bind it */
  GST_DEBUG_OBJECT (src, "binding server socket to address");
  if (!g_socket_bind (src->server_socket, saddr, TRUE, &err))
    goto bind_failed;

  g_object_unref (saddr);

  GST_DEBUG_OBJECT (src, "listening on server socket");

  g_socket_set_listen_backlog (src->server_socket, TCP_BACKLOG);

  if (!g_socket_listen (src->server_socket, &err))
    goto listen_failed;

  GST_OBJECT_FLAG_SET (src, GST_TCP_SERVER_SRC_OPEN);

  if (src->server_port == 0) {
    saddr = g_socket_get_local_address (src->server_socket, NULL);
    bound_port = g_inet_socket_address_get_port ((GInetSocketAddress *) saddr);
    g_object_unref (saddr);
  } else {
    bound_port = src->server_port;
  }

  GST_DEBUG_OBJECT (src, "listening on port %d", bound_port);

  g_atomic_int_set (&src->current_port, bound_port);
  g_object_notify (G_OBJECT (src), "current-port");

  return TRUE;

  /* ERRORS */
no_socket:
  {
    GST_ELEMENT_ERROR (src, RESOURCE, OPEN_READ, (NULL),
        ("Failed to create socket: %s", err->message));
    g_clear_error (&err);
    g_object_unref (saddr);
    return FALSE;
  }
name_resolve:
  {
    if (g_error_matches (err, G_IO_ERROR, G_IO_ERROR_CANCELLED)) {
      GST_DEBUG_OBJECT (src, "Cancelled name resolval");
    } else {
      GST_ELEMENT_ERROR (src, RESOURCE, OPEN_READ, (NULL),
          ("Failed to resolve host '%s': %s", src->host, err->message));
    }
    g_clear_error (&err);
    g_object_unref (resolver);
    return FALSE;
  }
bind_failed:
  {
    if (g_error_matches (err, G_IO_ERROR, G_IO_ERROR_CANCELLED)) {
      GST_DEBUG_OBJECT (src, "Cancelled binding");
    } else {
      GST_ELEMENT_ERROR (src, RESOURCE, OPEN_READ, (NULL),
          ("Failed to bind on host '%s:%d': %s", src->host, src->server_port,
              err->message));
    }
    g_clear_error (&err);
    g_object_unref (saddr);
    gst_tcp_server_src_stop (GST_BASE_SRC (src));
    return FALSE;
  }
listen_failed:
  {
    if (g_error_matches (err, G_IO_ERROR, G_IO_ERROR_CANCELLED)) {
      GST_DEBUG_OBJECT (src, "Cancelled listening");
    } else {
      GST_ELEMENT_ERROR (src, RESOURCE, OPEN_READ, (NULL),
          ("Failed to listen on host '%s:%d': %s", src->host, src->server_port,
              err->message));
    }
    g_clear_error (&err);
    gst_tcp_server_src_stop (GST_BASE_SRC (src));
    return FALSE;
  }
}

static gboolean
gst_tcp_server_src_stop (GstBaseSrc * bsrc)
{
  GstTCPServerSrc *src = GST_TCP_SERVER_SRC (bsrc);
  GError *err = NULL;

  if (src->client_socket) {
    GST_DEBUG_OBJECT (src, "closing socket");

    if (!g_socket_close (src->client_socket, &err)) {
      GST_ERROR_OBJECT (src, "Failed to close socket: %s", err->message);
      g_clear_error (&err);
    }
    g_object_unref (src->client_socket);
    src->client_socket = NULL;
  }

  if (src->server_socket) {
    GST_DEBUG_OBJECT (src, "closing socket");

    if (!g_socket_close (src->server_socket, &err)) {
      GST_ERROR_OBJECT (src, "Failed to close socket: %s", err->message);
      g_clear_error (&err);
    }
    g_object_unref (src->server_socket);
    src->server_socket = NULL;

    g_atomic_int_set (&src->current_port, 0);
    g_object_notify (G_OBJECT (src), "current-port");
  }

  GST_OBJECT_FLAG_UNSET (src, GST_TCP_SERVER_SRC_OPEN);

  return TRUE;
}

/* will be called only between calls to start() and stop() */
static gboolean
gst_tcp_server_src_unlock (GstBaseSrc * bsrc)
{
  GstTCPServerSrc *src = GST_TCP_SERVER_SRC (bsrc);

  g_cancellable_cancel (src->cancellable);

  return TRUE;
}

static gboolean
gst_tcp_server_src_unlock_stop (GstBaseSrc * bsrc)
{
  GstTCPServerSrc *src = GST_TCP_SERVER_SRC (bsrc);

  g_cancellable_reset (src->cancellable);

  return TRUE;
}
