/* GStreamer
 * Copyright (C) 2010 Sebastian Dröge <sebastian.droege@collabora.co.uk>
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

#ifndef __GST_STREAM_SYNCHRONIZER_H__
#define __GST_STREAM_SYNCHRONIZER_H__

#include <gst/gst.h>

G_BEGIN_DECLS

#define GST_TYPE_STREAM_SYNCHRONIZER \
  (gst_stream_synchronizer_get_type())
#define GST_STREAM_SYNCHRONIZER(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_STREAM_SYNCHRONIZER, GstStreamSynchronizer))
#define GST_STREAM_SYNCHRONIZER_CAST(obj) \
  ((GstStreamSynchronizer *) obj)
#define GST_STREAM_SYNCHRONIZER_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_STREAM_SYNCHRONIZER, GstStreamSynchronizerClass))
#define GST_IS_STREAM_SYNCHRONIZER(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_STREAM_SYNCHRONIZER))
#define GST_IS_STREAM_SYNCHRONIZER_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_STREAM_SYNCHRONIZER))

typedef struct _GstStreamSynchronizer GstStreamSynchronizer;
typedef struct _GstStreamSynchronizerClass GstStreamSynchronizerClass;

struct _GstStreamSynchronizer
{
  GstElement parent;

  /* < private > */
  GMutex lock;
  gboolean shutdown;

  GList *streams;
  guint current_stream_number;

  GstClockTime group_start_time;

  gboolean have_group_id;
  guint group_id;
};

struct _GstStreamSynchronizerClass
{
  GstElementClass parent;
};

GType gst_stream_synchronizer_get_type (void);

gboolean gst_stream_synchronizer_plugin_init (GstPlugin * plugin);

G_END_DECLS

#endif /* __GST_STREAM_SYNCHRONIZER_H__ */
