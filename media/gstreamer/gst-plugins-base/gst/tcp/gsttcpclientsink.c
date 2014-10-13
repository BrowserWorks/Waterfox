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
 * SECTION:element-tcpclientsink
 * @see_also: #tcpclientsink
 *
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * # server:
 * nc -l -p 3000
 * # client:
 * gst-launch fdsink fd=1 ! tcpclientsink port=3000
 * ]| everything you type in the client is shown on the server
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif
#include <gst/gst-i18n-plugin.h>

#include "gsttcp.h"
#include "gsttcpclientsink.h"

/* TCPClientSink signals and args */
enum
{
  FRAME_ENCODED,
  /* FILL ME */
  LAST_SIGNAL
};

GST_DEBUG_CATEGORY_STATIC (tcpclientsink_debug);
#define GST_CAT_DEFAULT (tcpclientsink_debug)

enum
{
  PROP_0,
  PROP_HOST,
  PROP_PORT
};

static GstStaticPadTemplate sinktemplate = GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

static void gst_tcp_client_sink_finalize (GObject * gobject);

static gboolean gst_tcp_client_sink_setcaps (GstBaseSink * bsink,
    GstCaps * caps);
static GstFlowReturn gst_tcp_client_sink_render (GstBaseSink * bsink,
    GstBuffer * buf);
static gboolean gst_tcp_client_sink_start (GstBaseSink * bsink);
static gboolean gst_tcp_client_sink_stop (GstBaseSink * bsink);
static gboolean gst_tcp_client_sink_unlock (GstBaseSink * bsink);
static gboolean gst_tcp_client_sink_unlock_stop (GstBaseSink * bsink);

static void gst_tcp_client_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_tcp_client_sink_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);


/*static guint gst_tcp_client_sink_signals[LAST_SIGNAL] = { 0 }; */

#define gst_tcp_client_sink_parent_class parent_class
G_DEFINE_TYPE (GstTCPClientSink, gst_tcp_client_sink, GST_TYPE_BASE_SINK);

static void
gst_tcp_client_sink_class_init (GstTCPClientSinkClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstBaseSinkClass *gstbasesink_class;

  gobject_class = (GObjectClass *) klass;
  gstelement_class = (GstElementClass *) klass;
  gstbasesink_class = (GstBaseSinkClass *) klass;

  parent_class = g_type_class_peek_parent (klass);

  gobject_class->set_property = gst_tcp_client_sink_set_property;
  gobject_class->get_property = gst_tcp_client_sink_get_property;
  gobject_class->finalize = gst_tcp_client_sink_finalize;

  g_object_class_install_property (gobject_class, PROP_HOST,
      g_param_spec_string ("host", "Host", "The host/IP to send the packets to",
          TCP_DEFAULT_HOST, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_PORT,
      g_param_spec_int ("port", "Port", "The port to send the packets to",
          0, TCP_HIGHEST_PORT, TCP_DEFAULT_PORT,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&sinktemplate));

  gst_element_class_set_static_metadata (gstelement_class,
      "TCP client sink", "Sink/Network",
      "Send data as a client over the network via TCP",
      "Thomas Vander Stichele <thomas at apestaart dot org>");

  gstbasesink_class->start = gst_tcp_client_sink_start;
  gstbasesink_class->stop = gst_tcp_client_sink_stop;
  gstbasesink_class->set_caps = gst_tcp_client_sink_setcaps;
  gstbasesink_class->render = gst_tcp_client_sink_render;
  gstbasesink_class->unlock = gst_tcp_client_sink_unlock;
  gstbasesink_class->unlock_stop = gst_tcp_client_sink_unlock_stop;

  GST_DEBUG_CATEGORY_INIT (tcpclientsink_debug, "tcpclientsink", 0, "TCP sink");
}

static void
gst_tcp_client_sink_init (GstTCPClientSink * this)
{
  this->host = g_strdup (TCP_DEFAULT_HOST);
  this->port = TCP_DEFAULT_PORT;

  this->socket = NULL;
  this->cancellable = g_cancellable_new ();

  GST_OBJECT_FLAG_UNSET (this, GST_TCP_CLIENT_SINK_OPEN);
}

static void
gst_tcp_client_sink_finalize (GObject * gobject)
{
  GstTCPClientSink *this = GST_TCP_CLIENT_SINK (gobject);

  if (this->cancellable)
    g_object_unref (this->cancellable);
  this->cancellable = NULL;

  if (this->socket)
    g_object_unref (this->socket);
  this->socket = NULL;

  g_free (this->host);
  this->host = NULL;

  G_OBJECT_CLASS (parent_class)->finalize (gobject);
}

static gboolean
gst_tcp_client_sink_setcaps (GstBaseSink * bsink, GstCaps * caps)
{
  return TRUE;
}

static GstFlowReturn
gst_tcp_client_sink_render (GstBaseSink * bsink, GstBuffer * buf)
{
  GstTCPClientSink *sink;
  GstMapInfo map;
  gsize written = 0;
  gssize rret;
  GError *err = NULL;

  sink = GST_TCP_CLIENT_SINK (bsink);

  g_return_val_if_fail (GST_OBJECT_FLAG_IS_SET (sink, GST_TCP_CLIENT_SINK_OPEN),
      GST_FLOW_FLUSHING);

  gst_buffer_map (buf, &map, GST_MAP_READ);
  GST_LOG_OBJECT (sink, "writing %" G_GSIZE_FORMAT " bytes for buffer data",
      map.size);

  /* write buffer data */
  while (written < map.size) {
    rret =
        g_socket_send (sink->socket, (gchar *) map.data + written,
        map.size - written, sink->cancellable, &err);
    if (rret < 0)
      goto write_error;
    written += rret;
  }
  gst_buffer_unmap (buf, &map);

  sink->data_written += written;

  return GST_FLOW_OK;

  /* ERRORS */
write_error:
  {
    GstFlowReturn ret;

    if (g_error_matches (err, G_IO_ERROR, G_IO_ERROR_CANCELLED)) {
      ret = GST_FLOW_FLUSHING;
      GST_DEBUG_OBJECT (sink, "Cancelled reading from socket");
    } else {
      GST_ELEMENT_ERROR (sink, RESOURCE, WRITE,
          (_("Error while sending data to \"%s:%d\"."), sink->host, sink->port),
          ("Only %" G_GSIZE_FORMAT " of %" G_GSIZE_FORMAT " bytes written: %s",
              written, map.size, err->message));
      ret = GST_FLOW_ERROR;
    }
    gst_buffer_unmap (buf, &map);
    g_clear_error (&err);
    return ret;
  }
}

static void
gst_tcp_client_sink_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstTCPClientSink *tcpclientsink;

  g_return_if_fail (GST_IS_TCP_CLIENT_SINK (object));
  tcpclientsink = GST_TCP_CLIENT_SINK (object);

  switch (prop_id) {
    case PROP_HOST:
      if (!g_value_get_string (value)) {
        g_warning ("host property cannot be NULL");
        break;
      }
      g_free (tcpclientsink->host);
      tcpclientsink->host = g_strdup (g_value_get_string (value));
      break;
    case PROP_PORT:
      tcpclientsink->port = g_value_get_int (value);
      break;

    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_tcp_client_sink_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstTCPClientSink *tcpclientsink;

  g_return_if_fail (GST_IS_TCP_CLIENT_SINK (object));
  tcpclientsink = GST_TCP_CLIENT_SINK (object);

  switch (prop_id) {
    case PROP_HOST:
      g_value_set_string (value, tcpclientsink->host);
      break;
    case PROP_PORT:
      g_value_set_int (value, tcpclientsink->port);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}


/* create a socket for sending to remote machine */
static gboolean
gst_tcp_client_sink_start (GstBaseSink * bsink)
{
  GstTCPClientSink *this = GST_TCP_CLIENT_SINK (bsink);
  GError *err = NULL;
  GInetAddress *addr;
  GSocketAddress *saddr;
  GResolver *resolver;

  if (GST_OBJECT_FLAG_IS_SET (this, GST_TCP_CLIENT_SINK_OPEN))
    return TRUE;

  /* look up name if we need to */
  addr = g_inet_address_new_from_string (this->host);
  if (!addr) {
    GList *results;

    resolver = g_resolver_get_default ();

    results =
        g_resolver_lookup_by_name (resolver, this->host, this->cancellable,
        &err);
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
  saddr = g_inet_socket_address_new (addr, this->port);
  g_object_unref (addr);

  /* create sending client socket */
  GST_DEBUG_OBJECT (this, "opening sending client socket to %s:%d", this->host,
      this->port);
  this->socket =
      g_socket_new (g_socket_address_get_family (saddr), G_SOCKET_TYPE_STREAM,
      G_SOCKET_PROTOCOL_TCP, &err);
  if (!this->socket)
    goto no_socket;

  GST_DEBUG_OBJECT (this, "opened sending client socket");

  /* connect to server */
  if (!g_socket_connect (this->socket, saddr, this->cancellable, &err))
    goto connect_failed;

  g_object_unref (saddr);

  GST_OBJECT_FLAG_SET (this, GST_TCP_CLIENT_SINK_OPEN);

  this->data_written = 0;

  return TRUE;
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
connect_failed:
  {
    if (g_error_matches (err, G_IO_ERROR, G_IO_ERROR_CANCELLED)) {
      GST_DEBUG_OBJECT (this, "Cancelled connecting");
    } else {
      GST_ELEMENT_ERROR (this, RESOURCE, OPEN_READ, (NULL),
          ("Failed to connect to host '%s:%d': %s", this->host, this->port,
              err->message));
    }
    g_clear_error (&err);
    g_object_unref (saddr);
    /* pretend we opened ok for proper cleanup to happen */
    GST_OBJECT_FLAG_SET (this, GST_TCP_CLIENT_SINK_OPEN);
    gst_tcp_client_sink_stop (GST_BASE_SINK (this));
    return FALSE;
  }
}

static gboolean
gst_tcp_client_sink_stop (GstBaseSink * bsink)
{
  GstTCPClientSink *this = GST_TCP_CLIENT_SINK (bsink);
  GError *err = NULL;

  if (!GST_OBJECT_FLAG_IS_SET (this, GST_TCP_CLIENT_SINK_OPEN))
    return TRUE;

  if (this->socket) {
    GST_DEBUG_OBJECT (this, "closing socket");

    if (!g_socket_close (this->socket, &err)) {
      GST_ERROR_OBJECT (this, "Failed to close socket: %s", err->message);
      g_clear_error (&err);
    }
    g_object_unref (this->socket);
    this->socket = NULL;
  }

  GST_OBJECT_FLAG_UNSET (this, GST_TCP_CLIENT_SINK_OPEN);

  return TRUE;
}

/* will be called only between calls to start() and stop() */
static gboolean
gst_tcp_client_sink_unlock (GstBaseSink * bsink)
{
  GstTCPClientSink *sink = GST_TCP_CLIENT_SINK (bsink);

  GST_DEBUG_OBJECT (sink, "set to flushing");
  g_cancellable_cancel (sink->cancellable);

  return TRUE;
}

/* will be called only between calls to start() and stop() */
static gboolean
gst_tcp_client_sink_unlock_stop (GstBaseSink * bsink)
{
  GstTCPClientSink *sink = GST_TCP_CLIENT_SINK (bsink);

  GST_DEBUG_OBJECT (sink, "unset flushing");
  g_cancellable_reset (sink->cancellable);

  return TRUE;
}
