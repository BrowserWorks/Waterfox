/* GStreamer
 * Copyright (C) 2004 Benjamin Otte <otte@gnome.org>
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

#include <gst/gst.h>

#ifndef __GST_ADAPTER_H__
#define __GST_ADAPTER_H__

G_BEGIN_DECLS


#define GST_TYPE_ADAPTER \
  (gst_adapter_get_type())
#define GST_ADAPTER(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), GST_TYPE_ADAPTER, GstAdapter))
#define GST_ADAPTER_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass), GST_TYPE_ADAPTER, GstAdapterClass))
#define GST_ADAPTER_GET_CLASS(obj) \
  (G_TYPE_INSTANCE_GET_CLASS ((obj), GST_TYPE_ADAPTER, GstAdapterClass))
#define GST_IS_ADAPTER(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj), GST_TYPE_ADAPTER))
#define GST_IS_ADAPTER_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass), GST_TYPE_ADAPTER))

/**
 * GstAdapter:
 *
 * The opaque #GstAdapter data structure.
 */
typedef struct _GstAdapter GstAdapter;
typedef struct _GstAdapterClass GstAdapterClass;

GType                   gst_adapter_get_type            (void);

GstAdapter *            gst_adapter_new                 (void) G_GNUC_MALLOC;

void                    gst_adapter_clear               (GstAdapter *adapter);
void                    gst_adapter_push                (GstAdapter *adapter, GstBuffer* buf);
gconstpointer           gst_adapter_map                 (GstAdapter *adapter, gsize size);
void                    gst_adapter_unmap               (GstAdapter *adapter);
void                    gst_adapter_copy                (GstAdapter *adapter, gpointer dest,
                                                         gsize offset, gsize size);
GBytes *                gst_adapter_copy_bytes          (GstAdapter *adapter,
                                                         gsize offset, gsize size);
void                    gst_adapter_flush               (GstAdapter *adapter, gsize flush);
gpointer                gst_adapter_take                (GstAdapter *adapter, gsize nbytes);
GstBuffer*              gst_adapter_take_buffer         (GstAdapter *adapter, gsize nbytes);
GList*                  gst_adapter_take_list           (GstAdapter *adapter, gsize nbytes);
GstBuffer *             gst_adapter_take_buffer_fast    (GstAdapter *adapter, gsize nbytes);
gsize                   gst_adapter_available           (GstAdapter *adapter);
gsize                   gst_adapter_available_fast      (GstAdapter *adapter);

GstClockTime            gst_adapter_prev_pts            (GstAdapter *adapter, guint64 *distance);
GstClockTime            gst_adapter_prev_dts            (GstAdapter *adapter, guint64 *distance);
GstClockTime            gst_adapter_prev_pts_at_offset  (GstAdapter * adapter, gsize offset, guint64 * distance);
GstClockTime            gst_adapter_prev_dts_at_offset  (GstAdapter * adapter, gsize offset, guint64 * distance);

gssize                  gst_adapter_masked_scan_uint32  (GstAdapter * adapter, guint32 mask,
                                                         guint32 pattern, gsize offset, gsize size);

gssize                  gst_adapter_masked_scan_uint32_peek  (GstAdapter * adapter, guint32 mask,
                                                         guint32 pattern, gsize offset, gsize size, guint32 * value);

G_END_DECLS

#endif /* __GST_ADAPTER_H__ */
