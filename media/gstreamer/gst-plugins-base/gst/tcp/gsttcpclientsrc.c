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
 * SECTION:element-tcpclientsrc
 * @see_also: #tcpclientsink
 *
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * # server:
 * nc -l -p 3000
 * # client:
 * gst-launch tcpclientsrc port=3000 ! fdsink fd=2
 * ]| everything you type in the server is shown on the client
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/gst-i18n-plugin.h>
#include "gsttcpclientsrc.h"
#include "gsttcp.h"

GST_DEBUG_CATEGORY_STATIC (tcpclientsrc_debug);
#define GST_CAT_DEFAULT tcpclientsrc_debug

#define MAX_READ_SIZE                   4 * 1024


static GstStaticPadTemplate srctemplate = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);


enum
{
  PROP_0,
  PROP_HOST,
  PROP_PORT
};

#define gst_tcp_client_src_parent_class parent_class
G_DEFINE_TYPE (GstTCPClientSrc, gst_tcp_client_src, GST_TYPE_PUSH_SRC);


static void gst_tcp_client_src_finalize (GObject * gobject);

static GstCaps *gst_tcp_client_src_getcaps (GstBaseSrc * psrc,
    GstCaps * filter);

static GstFlowReturn gst_tcp_client_src_create (GstPushSrc * psrc,
    GstBuffer ** outbuf);
static gboolean gst_tcp_client_src_stop (GstBaseSrc * bsrc);
static gboolean gst_tcp_client_src_start (GstBaseSrc * bsrc);
static gboolean gst_tcp_client_src_unlock (GstBaseSrc * bsrc);
static gboolean gst_tcp_client_src_unlock_stop (GstBaseSrc * bsrc);

static void gst_tcp_client_src_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_tcp_client_src_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

static void
gst_tcp_client_src_class_init (GstTCPClientSrcClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstBaseSrcClass *gstbasesrc_class;
  GstPushSrcClass *gstpush_src_class;

  gobject_class = (GObjectClass *) klass;
  gstelement_class = (GstElementClass *) klass;
  gstbasesrc_class = (GstBaseSrcClass *) klass;
  gstpush_src_class = (GstPushSrcClass *) klass;

  gobject_class->set_property = gst_tcp_client_src_set_property;
  gobject_class->get_property = gst_tcp_client_src_get_property;
  gobject_class->finalize = gst_tcp_client_src_finalize;

  g_object_class_install_property (gobject_class, PROP_HOST,
      g_param_spec_string ("host", "Host",
          "The host IP address to receive packets from", TCP_DEFAULT_HOST,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_PORT,
      g_param_spec_int ("port", "Port", "The port to receive packets from", 0,
          TCP_HIGHEST_PORT, TCP_DEFAULT_PORT,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&srctemplate));

  gst_element_class_set_static_metadata (gstelement_class,
      "TCP client source", "Source/Network",
      "Receive data as a client over the network via TCP",
      "Thomas Vander Stichele <thomas at apestaart dot org>");

  gstbasesrc_class->get_caps = gst_tcp_client_src_getcaps;
  gstbasesrc_class->start = gst_tcp_client_src_start;
  gstbasesrc_class->stop = gst_tcp_client_src_stop;
  gstbasesrc_class->unlock = gst_tcp_client_src_unlock;
  gstbasesrc_class->unlock_stop = gst_tcp_client_src_unlock_stop;

  gstpush_src_class->create = gst_tcp_client_src_create;

  GST_DEBUG_CATEGORY_INIT (tcpclientsrc_debug, "tcpclientsrc", 0,
      "TCP Client Source");
}

static void
gst_tcp_client_src_init (GstTCPClientSrc * this)
{
  this->port = TCP_DEFAULT_PORT;
  this->host = g_strdup (TCP_DEFAULT_HOST);
  this->socket = NULL;
  this->cancellable = g_cancellable_new ();

  GST_OBJECT_FLAG_UNSET (this, GST_TCP_CLIENT_SRC_OPEN);
}

static void
gst_tcp_client_src_finalize (GObject * gobject)
{
  GstTCPClientSrc *this = GST_TCP_CLIENT_SRC (gobject);

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

static GstCaps *
gst_tcp_client_src_getcaps (GstBaseSrc * bsrc, GstCaps * filter)
{
  GstTCPClientSrc *src;
  GstCaps *caps = NULL;

  src = GST_TCP_CLIENT_SRC (bsrc);

  caps = (filter ? gst_caps_ref (filter) : gst_caps_new_any ());

  GST_DEBUG_OBJECT (src, "returning caps %" GST_PTR_FORMAT, caps);
  g_assert (GST_IS_CAPS (caps));
  return caps;
}

static GstFlowReturn
gst_tcp_client_src_create (GstPushSrc * psrc, GstBuffer ** outbuf)
{
  GstTCPClientSrc *src;
  GstFlowReturn ret = GST_FLOW_OK;
  gssize rret;
  GError *err = NULL;
  GstMapInfo map;
  gssize avail, read;

  src = GST_TCP_CLIENT_SRC (psrc);

  if (!GST_OBJECT_FLAG_IS_SET (src, GST_TCP_CLIENT_SRC_OPEN))
    goto wrong_state;

  GST_LOG_OBJECT (src, "asked for a buffer");

  /* read the buffer header */
  avail = g_socket_get_available_bytes (src->socket);
  if (avail < 0) {
    goto get_available_error;
  } else if (avail == 0) {
    GIOCondition condition;

    if (!g_socket_condition_wait (src->socket,
            G_IO_IN | G_IO_PRI | G_IO_ERR | G_IO_HUP, src->cancellable, &err))
      goto select_error;

    condition =
        g_socket_condition_check (src->socket,
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
    avail = g_socket_get_available_bytes (src->socket);
    if (avail < 0)
      goto get_available_error;
  }

  if (avail > 0) {
    read = MIN (avail, MAX_READ_SIZE);
    *outbuf = gst_buffer_new_and_alloc (read);
    gst_buffer_map (*outbuf, &map, GST_MAP_READWRITE);
    rret =
        g_socket_receive (src->socket, (gchar *) map.data, read,
        src->cancellable, &err);
  } else {
    /* Connection closed */
    *outbuf = NULL;
    read = 0;
    rret = 0;
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

select_error:
  {
    if (g_error_matches (err, G_IO_ERROR, G_IO_ERROR_CANCELLED)) {
      GST_DEBUG_OBJECT (src, "Cancelled");
      ret = GST_FLOW_FLUSHING;
    } else {
      GST_ELEMENT_ERROR (src, RESOURCE, READ, (NULL),
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
wrong_state:
  {
    GST_DEBUG_OBJECT (src, "connection to closed, cannot read data");
    return GST_FLOW_FLUSHING;
  }
}

static void
gst_tcp_client_src_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstTCPClientSrc *tcpclientsrc = GST_TCP_CLIENT_SRC (object);

  switch (prop_id) {
    case PROP_HOST:
      if (!g_value_get_string (value)) {
        g_warning ("host property cannot be NULL");
        break;
      }
      g_free (tcpclientsrc->host);
      tcpclientsrc->host = g_strdup (g_value_get_string (value));
      break;
    case PROP_PORT:
      tcpclientsrc->port = g_value_get_int (value);
      break;

    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_tcp_client_src_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstTCPClientSrc *tcpclientsrc = GST_TCP_CLIENT_SRC (object);

  switch (prop_id) {
    case PROP_HOST:
      g_value_set_string (value, tcpclientsrc->host);
      break;
    case PROP_PORT:
      g_value_set_int (value, tcpclientsrc->port);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

/* create a socket for connecting to remote server */
static gboolean
gst_tcp_client_src_start (GstBaseSrc * bsrc)
{
  GstTCPClientSrc *src = GST_TCP_CLIENT_SRC (bsrc);
  GError *err = NULL;
  GInetAddress *addr;
  GSocketAddress *saddr;
  GResolver *resolver;

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

  saddr = g_inet_socket_address_new (addr, src->port);
  g_object_unref (addr);

  /* create receiving client socket */
  GST_DEBUG_OBJECT (src, "opening receiving client socket to %s:%d",
      src->host, src->port);

  src->socket =
      g_socket_new (g_socket_address_get_family (saddr), G_SOCKET_TYPE_STREAM,
      G_SOCKET_PROTOCOL_TCP, &err);
  if (!src->socket)
    goto no_socket;

  GST_DEBUG_OBJECT (src, "opened receiving client socket");
  GST_OBJECT_FLAG_SET (src, GST_TCP_CLIENT_SRC_OPEN);

  /* connect to server */
  if (!g_socket_connect (src->socket, saddr, src->cancellable, &err))
    goto connect_failed;

  g_object_unref (saddr);

  return TRUE;

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
connect_failed:
  {
    if (g_error_matches (err, G_IO_ERROR, G_IO_ERROR_CANCELLED)) {
      GST_DEBUG_OBJECT (src, "Cancelled connecting");
    } else {
      GST_ELEMENT_ERROR (src, RESOURCE, OPEN_READ, (NULL),
          ("Failed to connect to host '%s:%d': %s", src->host, src->port,
              err->message));
    }
    g_clear_error (&err);
    g_object_unref (saddr);
    gst_tcp_client_src_stop (GST_BASE_SRC (src));
    return FALSE;
  }
}

/* close the socket and associated resources
 * unset OPEN flag
 * used both to recover from errors and go to NULL state */
static gboolean
gst_tcp_client_src_stop (GstBaseSrc * bsrc)
{
  GstTCPClientSrc *src;
  GError *err = NULL;

  src = GST_TCP_CLIENT_SRC (bsrc);

  if (src->socket) {
    GST_DEBUG_OBJECT (src, "closing socket");

    if (!g_socket_close (src->socket, &err)) {
      GST_ERROR_OBJECT (src, "Failed to close socket: %s", err->message);
      g_clear_error (&err);
    }
    g_object_unref (src->socket);
    src->socket = NULL;
  }

  GST_OBJECT_FLAG_UNSET (src, GST_TCP_CLIENT_SRC_OPEN);

  return TRUE;
}

/* will be called only between calls to start() and stop() */
static gboolean
gst_tcp_client_src_unlock (GstBaseSrc * bsrc)
{
  GstTCPClientSrc *src = GST_TCP_CLIENT_SRC (bsrc);

  GST_DEBUG_OBJECT (src, "set to flushing");
  g_cancellable_cancel (src->cancellable);

  return TRUE;
}

/* will be called only between calls to start() and stop() */
static gboolean
gst_tcp_client_src_unlock_stop (GstBaseSrc * bsrc)
{
  GstTCPClientSrc *src = GST_TCP_CLIENT_SRC (bsrc);

  GST_DEBUG_OBJECT (src, "unset flushing");
  g_cancellable_reset (src->cancellable);

  return TRUE;
}
