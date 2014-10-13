/* GStreamer
 * Copyright (C) 2006 Edward Hervey <edward@fluendo.com>
 *
 * gstmultiqueue.h:
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


#ifndef __GST_MULTI_QUEUE_H__
#define __GST_MULTI_QUEUE_H__

#include <gst/gst.h>
#include <gst/base/gstdataqueue.h>

G_BEGIN_DECLS

#define GST_TYPE_MULTI_QUEUE \
  (gst_multi_queue_get_type())
#define GST_MULTI_QUEUE(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_MULTI_QUEUE,GstMultiQueue))
#define GST_MULTI_QUEUE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_MULTI_QUEUE,GstMultiQueueClass))
#define GST_IS_MULTI_QUEUE(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_MULTI_QUEUE))
#define GST_IS_MULTI_QUEUE_CLASS(obj) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_MULTI_QUEUE))

typedef struct _GstMultiQueue GstMultiQueue;
typedef struct _GstMultiQueueClass GstMultiQueueClass;

/**
 * GstMultiQueue:
 *
 * Opaque #GstMultiQueue structure.
 */
struct _GstMultiQueue {
  GstElement element;

  gboolean sync_by_running_time;

  /* number of queues */
  guint	nbqueues;

  /* The list of individual queues */
  GList *queues;
  guint32 queues_cookie;

  GstDataQueueSize  max_size, extra_size;
  gboolean use_buffering;
  gint low_percent, high_percent;
  gboolean buffering;
  gint percent;

  guint    counter;	/* incoming object counter, use atomic accesses */
  guint32  highid;	/* contains highest id of last outputted object */
  GstClockTime high_time; /* highest start running time */

  GMutex   qlock;	/* Global queue lock (vs object lock or individual */
			/* queues lock). Protects nbqueues, queues, global */
			/* GstMultiQueueSize, counter and highid */

  gint numwaiting;	/* number of not-linked pads waiting */
};

struct _GstMultiQueueClass {
  GstElementClass parent_class;

  /* signals emitted when ALL queues are either full or empty */
  void (*underrun)	(GstMultiQueue *queue);
  void (*overrun)	(GstMultiQueue *queue);
};

G_GNUC_INTERNAL GType gst_multi_queue_get_type (void);

G_END_DECLS


#endif /* __GST_MULTI_QUEUE_H__ */
