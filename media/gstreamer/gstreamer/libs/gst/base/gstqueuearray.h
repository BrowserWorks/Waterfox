/* GStreamer
 * Copyright (C) 2009-2010 Edward Hervey <bilboed@bilboed.com>
 *
 * gstqueuearray.h:
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

#ifndef __GST_QUEUE_ARRAY_H__
#define __GST_QUEUE_ARRAY_H__

/**
 * GstQueueArray: (skip)
 */
typedef struct _GstQueueArray GstQueueArray;

GstQueueArray * gst_queue_array_new       (guint initial_size);

void            gst_queue_array_free      (GstQueueArray * array);

gpointer        gst_queue_array_pop_head  (GstQueueArray * array);
gpointer        gst_queue_array_peek_head (GstQueueArray * array);

void            gst_queue_array_push_tail (GstQueueArray * array,
                                           gpointer        data);

gboolean        gst_queue_array_is_empty  (GstQueueArray * array);

gpointer        gst_queue_array_drop_element (GstQueueArray * array,
                                              guint           idx);

guint           gst_queue_array_find (GstQueueArray * array,
                                      GCompareFunc    func,
                                      gpointer        data);

guint           gst_queue_array_get_length (GstQueueArray * array);

#endif
