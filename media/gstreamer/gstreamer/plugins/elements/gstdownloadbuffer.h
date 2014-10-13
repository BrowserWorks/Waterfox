/* GStreamer
 * Copyright (C) 2014 Wim Taymans <wim.taymans@gmail.com>
 *
 * gstdownloadbuffer.h:
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
#ifndef __GST_DOWNLOAD_BUFFER_H__
#define __GST_DOWNLOAD_BUFFER_H__

#include <gst/gst.h>
#include <stdio.h>

#include "gstsparsefile.h"

G_BEGIN_DECLS

#define GST_TYPE_DOWNLOAD_BUFFER \
  (gst_download_buffer_get_type())
#define GST_DOWNLOAD_BUFFER(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_DOWNLOAD_BUFFER,GstDownloadBuffer))
#define GST_DOWNLOAD_BUFFER_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_DOWNLOAD_BUFFER,GstDownloadBufferClass))
#define GST_IS_DOWNLOAD_BUFFER(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_DOWNLOAD_BUFFER))
#define GST_IS_DOWNLOAD_BUFFER_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_DOWNLOAD_BUFFER))
#define GST_DOWNLOAD_BUFFER_CAST(obj) \
  ((GstDownloadBuffer *)(obj))

typedef struct _GstDownloadBuffer GstDownloadBuffer;
typedef struct _GstDownloadBufferClass GstDownloadBufferClass;
typedef struct _GstDownloadBufferSize GstDownloadBufferSize;

/* used to keep track of sizes (current and max) */
struct _GstDownloadBufferSize
{
  guint bytes;
  guint64 time;
};

struct _GstDownloadBuffer
{
  GstElement element;

  /*< private > */
  GstPad *sinkpad;
  GstPad *srcpad;

  /* upstream size in bytes (if downstream is operating in pull mode) */
  guint64 upstream_size;

  /* flowreturn when srcpad is paused */
  GstFlowReturn srcresult;
  GstFlowReturn sinkresult;
  gboolean unexpected;

  /* the queue of data we're keeping our hands on */
  GstSparseFile *file;
  guint64 write_pos;
  guint64 read_pos;
  gboolean filling;

  GstDownloadBufferSize cur_level;
  GstDownloadBufferSize max_level;
  gint low_percent;             /* low/high watermarks for buffering */
  gint high_percent;

  /* current buffering state */
  gboolean is_buffering;
  gint buffering_percent;

  /* for measuring input/output rates */
  GTimer *in_timer;
  gboolean in_timer_started;
  gdouble last_in_elapsed;
  guint64 bytes_in;
  gdouble byte_in_rate;
  gdouble byte_in_period;

  GTimer *out_timer;
  gboolean out_timer_started;
  gdouble last_out_elapsed;
  guint64 bytes_out;
  gdouble byte_out_rate;

  GMutex qlock;                /* lock for queue (vs object lock) */
  gboolean waiting_add;
  GCond item_add;              /* signals buffers now available for reading */
  guint64 waiting_offset;

  /* temp location stuff */
  gchar *temp_template;
  gboolean temp_location_set;
  gchar *temp_location;
  gboolean temp_remove;
  gint temp_fd;
  gboolean seeking;

  GstEvent *stream_start_event;
  GstEvent *segment_event;

  volatile gint downstream_may_block;
};

struct _GstDownloadBufferClass
{
  GstElementClass parent_class;
};

G_GNUC_INTERNAL GType gst_download_buffer_get_type (void);

G_END_DECLS

#endif /* __GST_DOWNLOAD_BUFFER_H__ */
