/* GStreamer
 * Copyright (C) 2009-2010 Edward Hervey <bilboed@bilboed.com>
 *           (C) 2011 Wim Taymans <wim.taymans@gmail.com>
 *
 * gstatomicqueue.h:
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

#include <glib.h>

#ifndef __GST_ATOMIC_QUEUE_H__
#define __GST_ATOMIC_QUEUE_H__

G_BEGIN_DECLS

#define GST_TYPE_ATOMIC_QUEUE (gst_atomic_queue_get_type())

/**
 * GstAtomicQueue:
 *
 * Opaque atomic data queue.
 *
 * Use the accessor functions to get the stored values.
 */
typedef struct _GstAtomicQueue GstAtomicQueue;


GType              gst_atomic_queue_get_type    (void);

GstAtomicQueue *   gst_atomic_queue_new         (guint initial_size) G_GNUC_MALLOC;

void               gst_atomic_queue_ref         (GstAtomicQueue * queue);
void               gst_atomic_queue_unref       (GstAtomicQueue * queue);

void               gst_atomic_queue_push        (GstAtomicQueue* queue, gpointer data);
gpointer           gst_atomic_queue_pop         (GstAtomicQueue* queue);
gpointer           gst_atomic_queue_peek        (GstAtomicQueue* queue);

guint              gst_atomic_queue_length      (GstAtomicQueue * queue);

G_END_DECLS

#endif /* __GST_ATOMIC_QUEUE_H__ */
