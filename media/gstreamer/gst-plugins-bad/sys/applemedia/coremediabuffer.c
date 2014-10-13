/*
 * Copyright (C) 2009 Ole André Vadla Ravnås <oleavr@soundrop.com>
 * Copyright (C) 2014 Collabora Ltd.
 *   Authors:    Matthieu Bouron <matthieu.bouron@collabora.com>
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

#include "coremediabuffer.h"

static void
gst_core_media_meta_free (GstCoreMediaMeta * meta, GstBuffer * buf)
{
  if (meta->image_buf != NULL) {
    CVPixelBufferUnlockBaseAddress (meta->image_buf,
        kCVPixelBufferLock_ReadOnly);
    CVBufferRelease (meta->image_buf);
  }
  if (meta->block_buf != NULL) {
    CFRelease (meta->block_buf);
  }

  CFRelease (meta->sample_buf);
}

GType
gst_core_media_meta_api_get_type (void)
{
  static volatile GType type;
  static const gchar *tags[] = { "memory", NULL };

  if (g_once_init_enter (&type)) {
    GType _type = gst_meta_api_type_register ("GstCoreMediaMetaAPI", tags);
    g_once_init_leave (&type, _type);
  }
  return type;
}

static const GstMetaInfo *
gst_core_media_meta_get_info (void)
{
  static const GstMetaInfo *core_media_meta_info = NULL;

  if (g_once_init_enter (&core_media_meta_info)) {
    const GstMetaInfo *meta = gst_meta_register (GST_CORE_MEDIA_META_API_TYPE,
        "GstCoreMediaMeta", sizeof (GstCoreMediaMeta),
        (GstMetaInitFunction) NULL,
        (GstMetaFreeFunction) gst_core_media_meta_free,
        (GstMetaTransformFunction) NULL);
    g_once_init_leave (&core_media_meta_info, meta);
  }
  return core_media_meta_info;
}

static GstVideoFormat
gst_core_media_buffer_get_video_format (OSType format)
{
  switch (format) {
    case kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange:
      return GST_VIDEO_FORMAT_NV12;
    case kCVPixelFormatType_422YpCbCr8_yuvs:
      return GST_VIDEO_FORMAT_YUY2;
    case kCVPixelFormatType_422YpCbCr8:
      return GST_VIDEO_FORMAT_UYVY;
    case kCVPixelFormatType_32BGRA:
      return GST_VIDEO_FORMAT_BGRA;
    default:
      GST_WARNING ("Unknown OSType format: %d", (gint) format);
      return GST_VIDEO_FORMAT_UNKNOWN;
  }
}

static gboolean
gst_core_media_buffer_wrap_pixel_buffer (GstBuffer * buf, GstVideoInfo * info,
    CVPixelBufferRef pixel_buf, gboolean * has_padding)
{
  guint n_planes;
  gsize offset[GST_VIDEO_MAX_PLANES] = { 0 };
  gint stride[GST_VIDEO_MAX_PLANES] = { 0 };
  GstVideoMeta *video_meta;
  UInt32 size;

  if (CVPixelBufferLockBaseAddress (pixel_buf,
          kCVPixelBufferLock_ReadOnly) != kCVReturnSuccess) {
    GST_ERROR ("Could not lock pixel buffer base address");
    return FALSE;
  }

  *has_padding = FALSE;

  if (CVPixelBufferIsPlanar (pixel_buf)) {
    gint i, size = 0, plane_offset = 0;

    n_planes = CVPixelBufferGetPlaneCount (pixel_buf);
    for (i = 0; i < n_planes; i++) {
      stride[i] = CVPixelBufferGetBytesPerRowOfPlane (pixel_buf, i);

      if (stride[i] != GST_VIDEO_INFO_PLANE_STRIDE (info, i)) {
        *has_padding = TRUE;
      }

      size = stride[i] * CVPixelBufferGetHeightOfPlane (pixel_buf, i);
      offset[i] = plane_offset;
      plane_offset += size;

      gst_buffer_append_memory (buf,
          gst_memory_new_wrapped (GST_MEMORY_FLAG_NO_SHARE,
              CVPixelBufferGetBaseAddressOfPlane (pixel_buf, i), size, 0, size,
              NULL, NULL));
    }
  } else {

    n_planes = 1;
    stride[0] = CVPixelBufferGetBytesPerRow (pixel_buf);
    offset[0] = 0;
    size = stride[0] * CVPixelBufferGetHeight (pixel_buf);

    gst_buffer_append_memory (buf,
        gst_memory_new_wrapped (GST_MEMORY_FLAG_NO_SHARE,
            CVPixelBufferGetBaseAddress (pixel_buf), size, 0, size, NULL,
            NULL));
  }

  video_meta =
      gst_buffer_add_video_meta_full (buf, GST_VIDEO_FRAME_FLAG_NONE,
      GST_VIDEO_INFO_FORMAT (info), info->width, info->height, n_planes, offset,
      stride);

  return TRUE;
}

static gboolean
gst_core_media_buffer_wrap_block_buffer (GstBuffer * buf,
    CMBlockBufferRef block_buf)
{
  OSStatus status;
  gchar *data = NULL;
  UInt32 size;

  status = CMBlockBufferGetDataPointer (block_buf, 0, 0, 0, &data);
  if (status != noErr) {
    return FALSE;
  }

  size = CMBlockBufferGetDataLength (block_buf);

  gst_buffer_append_memory (buf,
      gst_memory_new_wrapped (GST_MEMORY_FLAG_NO_SHARE, data,
          size, 0, size, NULL, NULL));

  return TRUE;
}

static GstBuffer *
gst_core_media_buffer_new_from_buffer (GstBuffer * buf, GstVideoInfo * info)
{
  gboolean ret;
  GstBuffer *copy_buf;
  GstVideoFrame dest, src;
  GstAllocator *allocator;

  allocator = gst_allocator_find (GST_ALLOCATOR_SYSMEM);
  if (!allocator) {
    GST_ERROR ("Could not find SYSMEM allocator");
    return NULL;
  }

  copy_buf = gst_buffer_new_allocate (allocator, info->size, NULL);

  gst_object_unref (allocator);

  if (!gst_video_frame_map (&dest, info, copy_buf, GST_MAP_WRITE)) {
    GST_ERROR ("Could not map destination frame");
    goto error;
  }

  if (!gst_video_frame_map (&src, info, buf, GST_MAP_READ)) {
    GST_ERROR ("Could not map source frame");
    gst_video_frame_unmap (&dest);
    goto error;
  }

  ret = gst_video_frame_copy (&dest, &src);

  gst_video_frame_unmap (&dest);
  gst_video_frame_unmap (&src);

  if (!ret) {
    GST_ERROR ("Could not copy frame");
    goto error;
  }

  return copy_buf;

error:
  if (copy_buf) {
    gst_buffer_unref (copy_buf);
  }
  return NULL;
}

static gboolean
gst_video_info_init_from_pixel_buffer (GstVideoInfo * info,
    CVPixelBufferRef pixel_buf)
{
  size_t width, height;
  OSType format_type;
  GstVideoFormat video_format;

  width = CVPixelBufferGetWidth (pixel_buf);
  height = CVPixelBufferGetHeight (pixel_buf);
  format_type = CVPixelBufferGetPixelFormatType (pixel_buf);
  video_format = gst_core_media_buffer_get_video_format (format_type);

  if (video_format == GST_VIDEO_FORMAT_UNKNOWN) {
    return FALSE;
  }

  gst_video_info_init (info);
  gst_video_info_set_format (info, video_format, width, height);

  return TRUE;
}

GstBuffer *
gst_core_media_buffer_new (CMSampleBufferRef sample_buf,
    gboolean use_video_meta)
{
  CVImageBufferRef image_buf;
  CVPixelBufferRef pixel_buf;
  CMBlockBufferRef block_buf;
  GstCoreMediaMeta *meta;
  GstBuffer *buf;

  image_buf = CMSampleBufferGetImageBuffer (sample_buf);
  pixel_buf = NULL;
  block_buf = CMSampleBufferGetDataBuffer (sample_buf);

  buf = gst_buffer_new ();

  meta = (GstCoreMediaMeta *) gst_buffer_add_meta (buf,
      gst_core_media_meta_get_info (), NULL);
  CFRetain (sample_buf);
  if (image_buf)
    CVBufferRetain (image_buf);
  if (block_buf)
    CFRetain (block_buf);
  meta->sample_buf = sample_buf;
  meta->image_buf = image_buf;
  meta->pixel_buf = pixel_buf;
  meta->block_buf = block_buf;

  if (image_buf != NULL && CFGetTypeID (image_buf) == CVPixelBufferGetTypeID ()) {
    GstVideoInfo info;
    gboolean has_padding = FALSE;

    pixel_buf = (CVPixelBufferRef) image_buf;
    if (!gst_video_info_init_from_pixel_buffer (&info, pixel_buf)) {
      goto error;
    }

    if (!gst_core_media_buffer_wrap_pixel_buffer (buf, &info, pixel_buf,
            &has_padding)) {
      goto error;
    }

    /* If the video meta API is not supported, remove padding by
     * copying the core media buffer to a system memory buffer */
    if (has_padding && !use_video_meta) {
      GstBuffer *copy_buf;
      copy_buf = gst_core_media_buffer_new_from_buffer (buf, &info);
      if (!copy_buf) {
        goto error;
      }

      gst_buffer_unref (buf);
      buf = copy_buf;
    }

  } else if (block_buf != NULL) {

    if (!gst_core_media_buffer_wrap_block_buffer (buf, block_buf)) {
      goto error;
    }

  } else {
    goto error;
  }

  return buf;

error:
  if (buf) {
    gst_buffer_unref (buf);
  }
  return NULL;
}

CVPixelBufferRef
gst_core_media_buffer_get_pixel_buffer (GstBuffer * buf)
{
  GstCoreMediaMeta *meta = (GstCoreMediaMeta *) gst_buffer_get_meta (buf,
      GST_CORE_MEDIA_META_API_TYPE);
  g_return_val_if_fail (meta != NULL, NULL);

  return CVPixelBufferRetain (meta->pixel_buf);
}
