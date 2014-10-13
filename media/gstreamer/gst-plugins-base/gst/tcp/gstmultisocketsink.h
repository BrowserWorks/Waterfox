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


#ifndef __GST_MULTI_SOCKET_SINK_H__
#define __GST_MULTI_SOCKET_SINK_H__

#include <gio/gio.h>

#include <gst/gst.h>
#include <gst/base/gstbasesink.h>

#include "gstmultihandlesink.h"

G_BEGIN_DECLS

#define GST_TYPE_MULTI_SOCKET_SINK \
  (gst_multi_socket_sink_get_type())
#define GST_MULTI_SOCKET_SINK(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_MULTI_SOCKET_SINK,GstMultiSocketSink))
#define GST_MULTI_SOCKET_SINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_MULTI_SOCKET_SINK,GstMultiSocketSinkClass))
#define GST_IS_MULTI_SOCKET_SINK(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_MULTI_SOCKET_SINK))
#define GST_IS_MULTI_SOCKET_SINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_MULTI_SOCKET_SINK))
#define GST_MULTI_SOCKET_SINK_GET_CLASS(klass) \
  (G_TYPE_INSTANCE_GET_CLASS ((klass), GST_TYPE_MULTI_SOCKET_SINK, GstMultiSocketSinkClass))


typedef struct _GstMultiSocketSink GstMultiSocketSink;
typedef struct _GstMultiSocketSinkClass GstMultiSocketSinkClass;

/* structure for a client
 */
typedef struct {
  GstMultiHandleClient client;

  GSource *source;
} GstSocketClient;

/**
 * GstMultiSocketSink:
 *
 * The multisocketsink object structure.
 */
struct _GstMultiSocketSink {
  GstMultiHandleSink element;

  /*< private >*/
  GMainContext *main_context;
  GCancellable *cancellable;
};

struct _GstMultiSocketSinkClass {
  GstMultiHandleSinkClass parent_class;

  /* element methods */
  void          (*add)          (GstMultiSocketSink *sink, GSocket *socket);
  void          (*add_full)     (GstMultiSocketSink *sink, GSocket *socket,
                                 GstSyncMethod sync,
                                 GstFormat format, guint64 value,
                                 GstFormat max_format, guint64 max_value);
  void          (*remove)       (GstMultiSocketSink *sink, GSocket *socket);
  void          (*remove_flush) (GstMultiSocketSink *sink, GSocket *socket);
  GstStructure* (*get_stats)    (GstMultiSocketSink *sink, GSocket *socket);

  /* signals */
};

GType gst_multi_socket_sink_get_type (void);

G_END_DECLS

#endif /* __GST_MULTI_SOCKET_SINK_H__ */
