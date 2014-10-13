/*
 * Copyright (C) 2010 Ole André Vadla Ravnås <oleavr@soundrop.com>
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

#include "corevideobuffer.h"

static void
gst_core_video_meta_free (GstCoreVideoMeta * meta, GstBuffer * buf)
{
  if (meta->pixbuf != NULL) {
    CVPixelBufferUnlockBaseAddress (meta->pixbuf, kCVPixelBufferLock_ReadOnly);
  }

  CVBufferRelease (meta->cvbuf);
}

GType
gst_core_video_meta_api_get_type (void)
{
  static volatile GType type;
  static const gchar *tags[] = { "memory", NULL };

  if (g_once_init_enter (&type)) {
    GType _type = gst_meta_api_type_register ("GstCoreVideoMetaAPI", tags);
    g_once_init_leave (&type, _type);
  }
  return type;
}

static const GstMetaInfo *
gst_core_video_meta_get_info (void)
{
  static const GstMetaInfo *core_video_meta_info = NULL;

  if (g_once_init_enter (&core_video_meta_info)) {
    const GstMetaInfo *meta = gst_meta_register (GST_CORE_VIDEO_META_API_TYPE,
        "GstCoreVideoMeta", sizeof (GstCoreVideoMeta),
        (GstMetaInitFunction) NULL,
        (GstMetaFreeFunction) gst_core_video_meta_free,
        (GstMetaTransformFunction) NULL);
    g_once_init_leave (&core_video_meta_info, meta);
  }
  return core_video_meta_info;
}

GstBuffer *
gst_core_video_buffer_new (CVBufferRef cvbuf, GstVideoInfo * vinfo)
{
  CVPixelBufferRef pixbuf = NULL;
  GstBuffer *buf;
  GstCoreVideoMeta *meta;
  guint n_planes;
  gsize offset[GST_VIDEO_MAX_PLANES];
  gint stride[GST_VIDEO_MAX_PLANES];

  if (CFGetTypeID (cvbuf) != CVPixelBufferGetTypeID ())
    /* TODO: Do we need to handle other buffer types? */
    goto error;

  pixbuf = (CVPixelBufferRef) cvbuf;

  if (CVPixelBufferLockBaseAddress (pixbuf,
          kCVPixelBufferLock_ReadOnly) != kCVReturnSuccess) {
    goto error;
  }

  buf = gst_buffer_new ();

  /* add the corevideo meta to free the underlying corevideo buffer */
  meta = (GstCoreVideoMeta *) gst_buffer_add_meta (buf,
      gst_core_video_meta_get_info (), NULL);
  meta->cvbuf = CVBufferRetain (cvbuf);
  meta->pixbuf = pixbuf;

  /* set stride, offset and size */
  memset (&offset, 0, sizeof (offset));
  memset (&stride, 0, sizeof (stride));

  if (CVPixelBufferIsPlanar (pixbuf)) {
    int i, size, off;

    n_planes = CVPixelBufferGetPlaneCount (pixbuf);
    off = 0;
    for (i = 0; i < n_planes; ++i) {
      stride[i] = CVPixelBufferGetBytesPerRowOfPlane (pixbuf, i);
      size = stride[i] * CVPixelBufferGetHeightOfPlane (pixbuf, i);
      offset[i] = off;
      off += size;

      gst_buffer_append_memory (buf,
          gst_memory_new_wrapped (GST_MEMORY_FLAG_NO_SHARE,
              CVPixelBufferGetBaseAddressOfPlane (pixbuf, i), size, 0, size,
              NULL, NULL));
    }
  } else {
    int size;

    n_planes = 1;
    stride[0] = CVPixelBufferGetBytesPerRow (pixbuf);
    offset[0] = 0;
    size = stride[0] * CVPixelBufferGetHeight (pixbuf);

    gst_buffer_append_memory (buf,
        gst_memory_new_wrapped (GST_MEMORY_FLAG_NO_SHARE,
            CVPixelBufferGetBaseAddress (pixbuf), size, 0, size, NULL, NULL));
  }

  if (vinfo) {
    GstVideoMeta *video_meta;

    video_meta =
        gst_buffer_add_video_meta_full (buf, GST_VIDEO_FRAME_FLAG_NONE,
        vinfo->finfo->format, CVPixelBufferGetWidth (pixbuf),
        CVPixelBufferGetHeight (pixbuf), n_planes, offset, stride);
  }

  return buf;

error:
  return NULL;
}
