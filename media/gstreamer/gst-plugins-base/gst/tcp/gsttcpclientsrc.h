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


#ifndef __GST_TCP_CLIENT_SRC_H__
#define __GST_TCP_CLIENT_SRC_H__

#include <gst/gst.h>
#include <gst/base/gstpushsrc.h>

#include <gio/gio.h>

G_BEGIN_DECLS

#define GST_TYPE_TCP_CLIENT_SRC \
  (gst_tcp_client_src_get_type())
#define GST_TCP_CLIENT_SRC(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_TCP_CLIENT_SRC,GstTCPClientSrc))
#define GST_TCP_CLIENT_SRC_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_TCP_CLIENT_SRC,GstTCPClientSrcClass))
#define GST_IS_TCP_CLIENT_SRC(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_TCP_CLIENT_SRC))
#define GST_IS_TCP_CLIENT_SRC_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_TCP_CLIENT_SRC))

typedef struct _GstTCPClientSrc GstTCPClientSrc;
typedef struct _GstTCPClientSrcClass GstTCPClientSrcClass;

typedef enum {
  GST_TCP_CLIENT_SRC_OPEN       = (GST_BASE_SRC_FLAG_LAST << 0),

  GST_TCP_CLIENT_SRC_FLAG_LAST  = (GST_BASE_SRC_FLAG_LAST << 2)
} GstTCPClientSrcFlags;

struct _GstTCPClientSrc {
  GstPushSrc element;

  /* server information */
  int port;
  gchar *host;

  /* socket */
  GSocket *socket;
  GCancellable *cancellable;
};

struct _GstTCPClientSrcClass {
  GstPushSrcClass parent_class;
};

GType gst_tcp_client_src_get_type (void);

G_END_DECLS

#endif /* __GST_TCP_CLIENT_SRC_H__ */
