/*
 * Copyright (C) 2009 Ole André Vadla Ravnås <oleavr@soundrop.com>
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

#ifndef __GST_CORE_MEDIA_BUFFER_H__
#define __GST_CORE_MEDIA_BUFFER_H__

#include <gst/gst.h>
#include <gst/video/gstvideometa.h>

#include "CoreMedia/CoreMedia.h"

G_BEGIN_DECLS

#define GST_CORE_MEDIA_META_API_TYPE (gst_core_media_meta_api_get_type())
#define gst_buffer_get_core_media_meta(b) \
  ((GstCoreMediaMeta*)gst_buffer_get_meta((b),GST_CORE_MEDIA_META_API_TYPE))

typedef struct _GstCoreMediaMeta
{
  GstMeta meta;

  CMSampleBufferRef sample_buf;
  CVImageBufferRef image_buf;
  CVPixelBufferRef pixel_buf;
  CMBlockBufferRef block_buf;
} GstCoreMediaMeta;


GstBuffer * gst_core_media_buffer_new      (CMSampleBufferRef sample_buf,
                                            gboolean use_video_meta);
CVPixelBufferRef gst_core_media_buffer_get_pixel_buffer
                                           (GstBuffer * buf);
GType gst_core_media_meta_api_get_type (void);

G_END_DECLS

#endif /* __GST_CORE_MEDIA_BUFFER_H__ */
