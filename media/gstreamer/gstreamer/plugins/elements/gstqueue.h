/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *
 * gstqueue.h:
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


#ifndef __GST_QUEUE_H__
#define __GST_QUEUE_H__

#include <gst/gst.h>
#include <gst/base/gstqueuearray.h>

G_BEGIN_DECLS

#define GST_TYPE_QUEUE \
  (gst_queue_get_type())
#define GST_QUEUE(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_QUEUE,GstQueue))
#define GST_QUEUE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_QUEUE,GstQueueClass))
#define GST_IS_QUEUE(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_QUEUE))
#define GST_IS_QUEUE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_QUEUE))
#define GST_QUEUE_CAST(obj) \
  ((GstQueue *)(obj))

typedef struct _GstQueue GstQueue;
typedef struct _GstQueueSize GstQueueSize;
typedef enum _GstQueueLeaky GstQueueLeaky;
typedef struct _GstQueueClass GstQueueClass;

/**
 * GstQueueLeaky:
 * @GST_QUEUE_NO_LEAK: Not Leaky
 * @GST_QUEUE_LEAK_UPSTREAM: Leaky on upstream (new buffers)
 * @GST_QUEUE_LEAK_DOWNSTREAM: Leaky on downstream (old buffers)
 *
 * Buffer dropping scheme to avoid the queue to block when full.
 */
enum _GstQueueLeaky {
  GST_QUEUE_NO_LEAK             = 0,
  GST_QUEUE_LEAK_UPSTREAM       = 1,
  GST_QUEUE_LEAK_DOWNSTREAM     = 2
};

/*
 * GstQueueSize:
 * @buffers: number of buffers
 * @bytes: number of bytes
 * @time: amount of time
 *
 * Structure describing the size of a queue.
 */
struct _GstQueueSize {
    guint   buffers;
    guint   bytes;
    guint64 time;
};

#define GST_QUEUE_CLEAR_LEVEL(l) G_STMT_START {         \
  l.buffers = 0;                                        \
  l.bytes = 0;                                          \
  l.time = 0;                                           \
} G_STMT_END

/**
 * GstQueue:
 *
 * Opaque #GstQueue structure.
 */
struct _GstQueue {
  GstElement element;

  /*< private >*/
  GstPad *sinkpad;
  GstPad *srcpad;

  /* segments to keep track of timestamps */
  GstSegment sink_segment;
  GstSegment src_segment;

  /* position of src/sink */
  GstClockTime sinktime, srctime;
  /* TRUE if either position needs to be recalculated */
  gboolean sink_tainted, src_tainted;

  /* flowreturn when srcpad is paused */
  GstFlowReturn srcresult;
  gboolean      unexpected;
  gboolean      eos;

  /* the queue of data we're keeping our grubby hands on */
  GstQueueArray *queue;

  GstQueueSize
    cur_level,          /* currently in the queue */
    max_size,           /* max. amount of data allowed in the queue */
    min_threshold,      /* min. amount of data required to wake reader */
    orig_min_threshold; /* Original min.threshold, for reset in EOS */

  /* whether we leak data, and at which end */
  gint leaky;

  GMutex qlock;        /* lock for queue (vs object lock) */
  gboolean waiting_add;
  GCond item_add;      /* signals buffers now available for reading */
  gboolean waiting_del;
  GCond item_del;      /* signals space now available for writing */

  gboolean head_needs_discont, tail_needs_discont;
  gboolean push_newsegment;

  gboolean silent;      /* don't emit signals */

  /* whether the first new segment has been applied to src */
  gboolean newseg_applied_to_src;

  GCond query_handled;
  gboolean last_query;

  gboolean flush_on_eos; /* flush on EOS */
};

struct _GstQueueClass {
  GstElementClass parent_class;

  /* signals - 'running' is called from both sides
   * which might make it sort of non-useful... */
  void (*underrun)      (GstQueue *queue);
  void (*running)       (GstQueue *queue);
  void (*overrun)       (GstQueue *queue);

  void (*pushing)       (GstQueue *queue);
};

G_GNUC_INTERNAL GType gst_queue_get_type (void);

G_END_DECLS


#endif /* __GST_QUEUE_H__ */
