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


#ifndef __GST_TCP_SERVER_SINK_H__
#define __GST_TCP_SERVER_SINK_H__


#include <gst/gst.h>
#include <gio/gio.h>

G_BEGIN_DECLS

#include "gstmultisocketsink.h"

#define GST_TYPE_TCP_SERVER_SINK \
  (gst_tcp_server_sink_get_type())
#define GST_TCP_SERVER_SINK(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_TCP_SERVER_SINK,GstTCPServerSink))
#define GST_TCP_SERVER_SINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_TCP_SERVER_SINK,GstTCPServerSinkClass))
#define GST_IS_TCP_SERVER_SINK(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_TCP_SERVER_SINK))
#define GST_IS_TCP_SERVER_SINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_TCP_SERVER_SINK))

typedef struct _GstTCPServerSink GstTCPServerSink;
typedef struct _GstTCPServerSinkClass GstTCPServerSinkClass;

typedef enum {
  GST_TCP_SERVER_SINK_OPEN             = (GST_ELEMENT_FLAG_LAST << 0),

  GST_TCP_SERVER_SINK_FLAG_LAST        = (GST_ELEMENT_FLAG_LAST << 2)
} GstTCPServerSinkFlags;

/**
 * GstTCPServerSink:
 *
 * Opaque data structure.
 */
struct _GstTCPServerSink {
  GstMultiSocketSink element;

  /* server information */
  int current_port;        /* currently bound-to port, or 0 */ /* ATOMIC */
  int server_port;         /* port property */
  gchar *host;             /* host property */

  GSocket *server_socket;
  GSource *server_source;
};

struct _GstTCPServerSinkClass {
  GstMultiSocketSinkClass parent_class;
};

GType gst_tcp_server_sink_get_type (void);

G_END_DECLS

#endif /* __GST_TCP_SERVER_SINK_H__ */
