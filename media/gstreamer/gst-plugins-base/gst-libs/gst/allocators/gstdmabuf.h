/* GStreamer dmabuf allocator
 * Copyright (C) 2013 Linaro SA
 * Author: Benjamin Gaignard <benjamin.gaignard@linaro.org> for Linaro.
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
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#ifndef __GST_DMABUF_H__
#define __GST_DMABUF_H__

#include <gst/gst.h>

G_BEGIN_DECLS

#define GST_ALLOCATOR_DMABUF "dmabuf"

GstAllocator * gst_dmabuf_allocator_new (void);

GstMemory    * gst_dmabuf_allocator_alloc (GstAllocator * allocator, gint fd, gsize size);

gint           gst_dmabuf_memory_get_fd (GstMemory * mem);

gboolean       gst_is_dmabuf_memory (GstMemory * mem);

G_END_DECLS
#endif /* __GST_DMABUF_H__ */
