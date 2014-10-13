/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *
 * gstfilesink.h:
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


#ifndef __GST_FILE_SINK_H__
#define __GST_FILE_SINK_H__

#include <stdio.h>

#include <gst/gst.h>
#include <gst/base/gstbasesink.h>

G_BEGIN_DECLS

#define GST_TYPE_FILE_SINK \
  (gst_file_sink_get_type())
#define GST_FILE_SINK(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_FILE_SINK,GstFileSink))
#define GST_FILE_SINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_FILE_SINK,GstFileSinkClass))
#define GST_IS_FILE_SINK(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_FILE_SINK))
#define GST_IS_FILE_SINK_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_FILE_SINK))

typedef struct _GstFileSink GstFileSink;
typedef struct _GstFileSinkClass GstFileSinkClass;

/**
 * GstFileSink:
 *
 * Opaque #GstFileSink structure.
 */
struct _GstFileSink {
  GstBaseSink parent;

  /*< private >*/
  gchar *filename;
  gchar *uri;
  FILE *file;

  gboolean seekable;
  guint64 current_pos;

  gint    buffer_mode;
  guint   buffer_size;
  gchar  *buffer;
  
  gboolean append;
};

struct _GstFileSinkClass {
  GstBaseSinkClass parent_class;
};

G_GNUC_INTERNAL GType gst_file_sink_get_type (void);

G_END_DECLS

#endif /* __GST_FILE_SINK_H__ */
