/* GStreamer
 * Copyright (C) <2011> Wim Taymans <wim.taymans@gmail.com>
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

#include "gstvideometa.h"

#include <string.h>

static gboolean
gst_video_meta_transform (GstBuffer * dest, GstMeta * meta,
    GstBuffer * buffer, GQuark type, gpointer data)
{
  GstVideoMeta *dmeta, *smeta;
  guint i;

  smeta = (GstVideoMeta *) meta;

  if (GST_META_TRANSFORM_IS_COPY (type)) {
    GstMetaTransformCopy *copy = data;

    if (!copy->region) {
      /* only copy if the complete data is copied as well */
      dmeta =
          (GstVideoMeta *) gst_buffer_add_meta (dest, GST_VIDEO_META_INFO,
          NULL);

      if (!dmeta)
        return FALSE;

      dmeta->buffer = dest;

      GST_DEBUG ("copy video metadata");
      dmeta->flags = smeta->flags;
      dmeta->format = smeta->format;
      dmeta->id = smeta->id;
      dmeta->width = smeta->width;
      dmeta->height = smeta->height;

      dmeta->n_planes = smeta->n_planes;
      for (i = 0; i < dmeta->n_planes; i++) {
        dmeta->offset[i] = smeta->offset[i];
        dmeta->stride[i] = smeta->stride[i];
      }
      dmeta->map = smeta->map;
      dmeta->unmap = smeta->unmap;
    }
  }
  return TRUE;
}

GType
gst_video_meta_api_get_type (void)
{
  static volatile GType type = 0;
  static const gchar *tags[] =
      { GST_META_TAG_VIDEO_STR, GST_META_TAG_MEMORY_STR,
    GST_META_TAG_VIDEO_COLORSPACE_STR,
    GST_META_TAG_VIDEO_SIZE_STR, NULL
  };

  if (g_once_init_enter (&type)) {
    GType _type = gst_meta_api_type_register ("GstVideoMetaAPI", tags);
    g_once_init_leave (&type, _type);
  }
  return type;
}

/* video metadata */
const GstMetaInfo *
gst_video_meta_get_info (void)
{
  static const GstMetaInfo *video_meta_info = NULL;

  if (g_once_init_enter (&video_meta_info)) {
    const GstMetaInfo *meta =
        gst_meta_register (GST_VIDEO_META_API_TYPE, "GstVideoMeta",
        sizeof (GstVideoMeta), (GstMetaInitFunction) NULL,
        (GstMetaFreeFunction) NULL, gst_video_meta_transform);
    g_once_init_leave (&video_meta_info, meta);
  }
  return video_meta_info;
}

/**
 * gst_buffer_get_video_meta_id:
 * @buffer: a #GstBuffer
 * @id: a metadata id
 *
 * Find the #GstVideoMeta on @buffer with the given @id.
 *
 * Buffers can contain multiple #GstVideoMeta metadata items when dealing with
 * multiview buffers.
 *
 * Returns: the #GstVideoMeta with @id or %NULL when there is no such metadata
 * on @buffer.
 */
GstVideoMeta *
gst_buffer_get_video_meta_id (GstBuffer * buffer, gint id)
{
  gpointer state = NULL;
  GstMeta *meta;
  const GstMetaInfo *info = GST_VIDEO_META_INFO;

  while ((meta = gst_buffer_iterate_meta (buffer, &state))) {
    if (meta->info->api == info->api) {
      GstVideoMeta *vmeta = (GstVideoMeta *) meta;
      if (vmeta->id == id)
        return vmeta;
    }
  }
  return NULL;
}

static gboolean
default_map (GstVideoMeta * meta, guint plane, GstMapInfo * info,
    gpointer * data, gint * stride, GstMapFlags flags)
{
  guint idx, length;
  gsize offset, skip;
  GstBuffer *buffer = meta->buffer;

  offset = meta->offset[plane];

  /* find the memory block for this plane, this is the memory block containing
   * the plane offset. FIXME use plane size */
  if (!gst_buffer_find_memory (buffer, offset, 1, &idx, &length, &skip))
    goto no_memory;

  if (!gst_buffer_map_range (buffer, idx, length, info, flags))
    goto cannot_map;

  *stride = meta->stride[plane];
  *data = (guint8 *) info->data + skip;

  return TRUE;

  /* ERRORS */
no_memory:
  {
    GST_DEBUG ("plane %u, no memory at offset %" G_GSIZE_FORMAT, plane, offset);
    return FALSE;
  }
cannot_map:
  {
    GST_DEBUG ("cannot map memory range %u-%u", idx, length);
    return FALSE;
  }
}

static gboolean
default_unmap (GstVideoMeta * meta, guint plane, GstMapInfo * info)
{
  GstBuffer *buffer = meta->buffer;

  gst_buffer_unmap (buffer, info);

  return TRUE;
}

/**
 * gst_buffer_add_video_meta:
 * @buffer: a #GstBuffer
 * @flags: #GstVideoFrameFlags
 * @format: a #GstVideoFormat
 * @width: the width
 * @height: the height
 *
 * Attaches GstVideoMeta metadata to @buffer with the given parameters and the
 * default offsets and strides for @format and @width x @height.
 *
 * This function calculates the default offsets and strides and then calls
 * gst_buffer_add_video_meta_full() with them.
 *
 * Returns: the #GstVideoMeta on @buffer.
 */
GstVideoMeta *
gst_buffer_add_video_meta (GstBuffer * buffer,
    GstVideoFrameFlags flags, GstVideoFormat format, guint width, guint height)
{
  GstVideoMeta *meta;
  GstVideoInfo info;

  gst_video_info_set_format (&info, format, width, height);

  meta =
      gst_buffer_add_video_meta_full (buffer, flags, format, width,
      height, info.finfo->n_planes, info.offset, info.stride);

  return meta;
}

/**
 * gst_buffer_add_video_meta_full:
 * @buffer: a #GstBuffer
 * @flags: #GstVideoFrameFlags
 * @format: a #GstVideoFormat
 * @width: the width
 * @height: the height
 * @n_planes: number of planes
 * @offset: offset of each plane
 * @stride: stride of each plane
 *
 * Attaches GstVideoMeta metadata to @buffer with the given parameters.
 *
 * Returns: the #GstVideoMeta on @buffer.
 */
GstVideoMeta *
gst_buffer_add_video_meta_full (GstBuffer * buffer,
    GstVideoFrameFlags flags, GstVideoFormat format, guint width,
    guint height, guint n_planes, gsize offset[GST_VIDEO_MAX_PLANES],
    gint stride[GST_VIDEO_MAX_PLANES])
{
  GstVideoMeta *meta;
  guint i;

  meta =
      (GstVideoMeta *) gst_buffer_add_meta (buffer, GST_VIDEO_META_INFO, NULL);

  if (!meta)
    return NULL;

  meta->flags = flags;
  meta->format = format;
  meta->id = 0;
  meta->width = width;
  meta->height = height;
  meta->buffer = buffer;

  meta->n_planes = n_planes;
  for (i = 0; i < n_planes; i++) {
    meta->offset[i] = offset[i];
    meta->stride[i] = stride[i];
    GST_LOG ("plane %d, offset %" G_GSIZE_FORMAT ", stride %d", i, offset[i],
        stride[i]);
  }
  meta->map = default_map;
  meta->unmap = default_unmap;

  return meta;
}

/**
 * gst_video_meta_map:
 * @meta: a #GstVideoMeta
 * @plane: a plane
 * @info: a #GstMapInfo
 * @data: the data of @plane
 * @stride: the stride of @plane
 * @flags: @GstMapFlags
 *
 * Map the video plane with index @plane in @meta and return a pointer to the
 * first byte of the plane and the stride of the plane.
 *
 * Returns: TRUE if the map operation was successful.
 */
gboolean
gst_video_meta_map (GstVideoMeta * meta, guint plane, GstMapInfo * info,
    gpointer * data, gint * stride, GstMapFlags flags)
{
  g_return_val_if_fail (meta != NULL, FALSE);
  g_return_val_if_fail (meta->map != NULL, FALSE);
  g_return_val_if_fail (plane < meta->n_planes, FALSE);
  g_return_val_if_fail (info != NULL, FALSE);
  g_return_val_if_fail (data != NULL, FALSE);
  g_return_val_if_fail (stride != NULL, FALSE);
  g_return_val_if_fail (meta->buffer != NULL, FALSE);
  g_return_val_if_fail (!(flags & GST_MAP_WRITE)
      || gst_buffer_is_writable (meta->buffer), FALSE);

  return meta->map (meta, plane, info, data, stride, flags);
}

/**
 * gst_video_meta_unmap:
 * @meta: a #GstVideoMeta
 * @plane: a plane
 * @info: a #GstMapInfo
 *
 * Unmap a previously mapped plane with gst_video_meta_map().
 *
 * Returns: TRUE if the memory was successfully unmapped.
 */
gboolean
gst_video_meta_unmap (GstVideoMeta * meta, guint plane, GstMapInfo * info)
{
  g_return_val_if_fail (meta != NULL, FALSE);
  g_return_val_if_fail (meta->unmap != NULL, FALSE);
  g_return_val_if_fail (plane < meta->n_planes, FALSE);
  g_return_val_if_fail (info != NULL, FALSE);

  return meta->unmap (meta, plane, info);
}

static gboolean
gst_video_crop_meta_transform (GstBuffer * dest, GstMeta * meta,
    GstBuffer * buffer, GQuark type, gpointer data)
{
  GstVideoCropMeta *dmeta, *smeta;

  if (GST_META_TRANSFORM_IS_COPY (type)) {
    smeta = (GstVideoCropMeta *) meta;
    dmeta = gst_buffer_add_video_crop_meta (dest);

    GST_DEBUG ("copy crop metadata");
    dmeta->x = smeta->x;
    dmeta->y = smeta->y;
    dmeta->width = smeta->width;
    dmeta->height = smeta->height;
  } else if (GST_VIDEO_META_TRANSFORM_IS_SCALE (type)) {
    GstVideoMetaTransform *trans = data;
    gint ow, oh, nw, nh;

    smeta = (GstVideoCropMeta *) meta;
    dmeta = gst_buffer_add_video_crop_meta (dest);

    ow = GST_VIDEO_INFO_WIDTH (trans->in_info);
    nw = GST_VIDEO_INFO_WIDTH (trans->out_info);
    oh = GST_VIDEO_INFO_HEIGHT (trans->in_info);
    nh = GST_VIDEO_INFO_HEIGHT (trans->out_info);

    GST_DEBUG ("scaling crop metadata %dx%d -> %dx%d", ow, oh, nw, nh);
    dmeta->x = (smeta->x * nw) / ow;
    dmeta->y = (smeta->y * nh) / oh;
    dmeta->width = (smeta->width * nw) / ow;
    dmeta->height = (smeta->height * nh) / oh;
    GST_DEBUG ("crop offset %dx%d -> %dx%d", smeta->x, smeta->y, dmeta->x,
        dmeta->y);
    GST_DEBUG ("crop size   %dx%d -> %dx%d", smeta->width, smeta->height,
        dmeta->width, dmeta->height);
  }
  return TRUE;
}

GType
gst_video_crop_meta_api_get_type (void)
{
  static volatile GType type = 0;
  static const gchar *tags[] =
      { GST_META_TAG_VIDEO_STR, GST_META_TAG_VIDEO_SIZE_STR,
    GST_META_TAG_VIDEO_ORIENTATION_STR, NULL
  };

  if (g_once_init_enter (&type)) {
    GType _type = gst_meta_api_type_register ("GstVideoCropMetaAPI", tags);
    g_once_init_leave (&type, _type);
  }
  return type;
}

const GstMetaInfo *
gst_video_crop_meta_get_info (void)
{
  static const GstMetaInfo *video_crop_meta_info = NULL;

  if (g_once_init_enter (&video_crop_meta_info)) {
    const GstMetaInfo *meta =
        gst_meta_register (GST_VIDEO_CROP_META_API_TYPE, "GstVideoCropMeta",
        sizeof (GstVideoCropMeta), (GstMetaInitFunction) NULL,
        (GstMetaFreeFunction) NULL, gst_video_crop_meta_transform);
    g_once_init_leave (&video_crop_meta_info, meta);
  }
  return video_crop_meta_info;
}

/**
 * gst_video_meta_transform_scale_get_quark:
 *
 * Get the #GQuark for the "gst-video-scale" metadata transform operation.
 *
 * Returns: a #GQuark
 */
GQuark
gst_video_meta_transform_scale_get_quark (void)
{
  static GQuark _value = 0;

  if (_value == 0) {
    _value = g_quark_from_static_string ("gst-video-scale");
  }
  return _value;
}


GType
gst_video_gl_texture_upload_meta_api_get_type (void)
{
  static volatile GType type = 0;
  static const gchar *tags[] =
      { GST_META_TAG_VIDEO_STR, GST_META_TAG_MEMORY_STR, NULL };

  if (g_once_init_enter (&type)) {
    GType _type =
        gst_meta_api_type_register ("GstVideoGLTextureUploadMetaAPI", tags);
    g_once_init_leave (&type, _type);
  }
  return type;
}

static void
gst_video_gl_texture_upload_meta_free (GstMeta * meta, GstBuffer * buffer)
{
  GstVideoGLTextureUploadMeta *vmeta = (GstVideoGLTextureUploadMeta *) meta;

  if (vmeta->user_data_free)
    vmeta->user_data_free (vmeta->user_data);
}

static gboolean
gst_video_gl_texture_upload_meta_transform (GstBuffer * dest, GstMeta * meta,
    GstBuffer * buffer, GQuark type, gpointer data)
{
  GstVideoGLTextureUploadMeta *dmeta, *smeta;

  smeta = (GstVideoGLTextureUploadMeta *) meta;

  if (GST_META_TRANSFORM_IS_COPY (type)) {
    GstMetaTransformCopy *copy = data;

    if (!copy->region) {
      /* only copy if the complete data is copied as well */
      dmeta =
          (GstVideoGLTextureUploadMeta *) gst_buffer_add_meta (dest,
          GST_VIDEO_GL_TEXTURE_UPLOAD_META_INFO, NULL);

      if (!dmeta)
        return FALSE;

      dmeta->texture_orientation = smeta->texture_orientation;
      dmeta->n_textures = smeta->n_textures;
      memcpy (dmeta->texture_type, smeta->texture_type,
          sizeof (smeta->texture_type[0]) * 4);
      dmeta->buffer = dest;
      dmeta->upload = smeta->upload;
      dmeta->user_data = smeta->user_data;
      dmeta->user_data_copy = smeta->user_data_copy;
      dmeta->user_data_free = smeta->user_data_free;
      if (dmeta->user_data_copy)
        dmeta->user_data = dmeta->user_data_copy (dmeta->user_data);
    }
  }
  return TRUE;
}

const GstMetaInfo *
gst_video_gl_texture_upload_meta_get_info (void)
{
  static const GstMetaInfo *info = NULL;

  if (g_once_init_enter (&info)) {
    const GstMetaInfo *meta =
        gst_meta_register (GST_VIDEO_GL_TEXTURE_UPLOAD_META_API_TYPE,
        "GstVideoGLTextureUploadMeta",
        sizeof (GstVideoGLTextureUploadMeta),
        NULL,
        gst_video_gl_texture_upload_meta_free,
        gst_video_gl_texture_upload_meta_transform);
    g_once_init_leave (&info, meta);
  }
  return info;
}

/**
 * gst_buffer_add_video_gl_texture_upload_meta:
 * @buffer: a #GstBuffer
 * @upload: the function to upload the buffer to a specific texture ID
 * @user_data: user data for the implementor of @upload
 * @user_data_copy: function to copy @user_data
 * @user_data_free: function to free @user_data
 *
 * Attaches GstVideoGLTextureUploadMeta metadata to @buffer with the given
 * parameters.
 *
 * Returns: the #GstVideoGLTextureUploadMeta on @buffer.
 */
GstVideoGLTextureUploadMeta *
gst_buffer_add_video_gl_texture_upload_meta (GstBuffer * buffer,
    GstVideoGLTextureOrientation texture_orientation, guint n_textures,
    GstVideoGLTextureType texture_type[4], GstVideoGLTextureUpload upload,
    gpointer user_data, GBoxedCopyFunc user_data_copy,
    GBoxedFreeFunc user_data_free)
{
  GstVideoGLTextureUploadMeta *meta;

  g_return_val_if_fail (buffer != NULL, NULL);
  g_return_val_if_fail (upload != NULL, NULL);
  g_return_val_if_fail (n_textures > 0 && n_textures < 5, NULL);

  meta =
      (GstVideoGLTextureUploadMeta *) gst_buffer_add_meta (buffer,
      GST_VIDEO_GL_TEXTURE_UPLOAD_META_INFO, NULL);

  if (!meta)
    return NULL;

  meta->texture_orientation = texture_orientation;
  meta->n_textures = n_textures;
  memcpy (meta->texture_type, texture_type, sizeof (texture_type[0]) * 4);
  meta->buffer = buffer;
  meta->upload = upload;
  meta->user_data = user_data;
  meta->user_data_copy = user_data_copy;
  meta->user_data_free = user_data_free;

  return meta;
}

/**
 * gst_video_gl_texture_upload_meta_upload:
 * @meta: a #GstVideoGLTextureUploadMeta
 * @texture_id: the texture IDs to upload to
 *
 * Uploads the buffer which owns the meta to a specific texture ID.
 *
 * Returns: %TRUE if uploading succeeded, %FALSE otherwise.
 */
gboolean
gst_video_gl_texture_upload_meta_upload (GstVideoGLTextureUploadMeta * meta,
    guint texture_id[4])
{
  g_return_val_if_fail (meta != NULL, FALSE);

  return meta->upload (meta, texture_id);
}

/* Region of Interest Meta implementation *******************************************/

GType
gst_video_region_of_interest_meta_api_get_type (void)
{
  static volatile GType type;
  static const gchar *tags[] =
      { GST_META_TAG_VIDEO_STR, GST_META_TAG_VIDEO_ORIENTATION_STR,
    GST_META_TAG_VIDEO_SIZE_STR, NULL
  };

  if (g_once_init_enter (&type)) {
    GType _type =
        gst_meta_api_type_register ("GstVideoRegionOfInterestMetaAPI", tags);
    GST_INFO ("registering");
    g_once_init_leave (&type, _type);
  }
  return type;
}


static gboolean
gst_video_region_of_interest_meta_transform (GstBuffer * dest, GstMeta * meta,
    GstBuffer * buffer, GQuark type, gpointer data)
{
  GstVideoRegionOfInterestMeta *dmeta, *smeta;

  if (GST_META_TRANSFORM_IS_COPY (type)) {
    smeta = (GstVideoRegionOfInterestMeta *) meta;

    GST_DEBUG ("copy region of interest metadata");
    dmeta =
        gst_buffer_add_video_region_of_interest_meta_id (dest,
        smeta->roi_type, smeta->x, smeta->y, smeta->w, smeta->h);
    dmeta->id = smeta->id;
    dmeta->parent_id = smeta->parent_id;
  } else if (GST_VIDEO_META_TRANSFORM_IS_SCALE (type)) {
    GstVideoMetaTransform *trans = data;
    gint ow, oh, nw, nh;
    ow = GST_VIDEO_INFO_WIDTH (trans->in_info);
    nw = GST_VIDEO_INFO_WIDTH (trans->out_info);
    oh = GST_VIDEO_INFO_HEIGHT (trans->in_info);
    nh = GST_VIDEO_INFO_HEIGHT (trans->out_info);
    GST_DEBUG ("scaling region of interest metadata %dx%d -> %dx%d", ow, oh, nw,
        nh);

    smeta = (GstVideoRegionOfInterestMeta *) meta;
    dmeta =
        gst_buffer_add_video_region_of_interest_meta_id (dest,
        smeta->roi_type, (smeta->x * nw) / ow, (smeta->y * nh) / oh,
        (smeta->w * nw) / ow, (smeta->h * nh) / oh);
    dmeta->id = smeta->id;
    dmeta->parent_id = smeta->parent_id;

    GST_DEBUG ("region of interest (id:%d, parent id:%d) offset %dx%d -> %dx%d",
        smeta->id, smeta->parent_id, smeta->x, smeta->y, dmeta->x, dmeta->y);
    GST_DEBUG ("region of interest size   %dx%d -> %dx%d", smeta->w, smeta->h,
        dmeta->w, dmeta->h);
  }
  return TRUE;
}

static gboolean
gst_video_region_of_interest_meta_init (GstMeta * meta, gpointer params,
    GstBuffer * buffer)
{
  GstVideoRegionOfInterestMeta *emeta = (GstVideoRegionOfInterestMeta *) meta;
  emeta->id = 0;
  emeta->parent_id = 0;
  emeta->x = emeta->y = emeta->w = emeta->h = 0;

  return TRUE;
}

static void
gst_video_region_of_interest_meta_free (GstMeta * meta, GstBuffer * buffer)
{
  // nothing to do
}

const GstMetaInfo *
gst_video_region_of_interest_meta_get_info (void)
{
  static const GstMetaInfo *meta_info = NULL;

  if (g_once_init_enter (&meta_info)) {
    const GstMetaInfo *mi =
        gst_meta_register (GST_VIDEO_REGION_OF_INTEREST_META_API_TYPE,
        "GstVideoRegionOfInterestMeta",
        sizeof (GstVideoRegionOfInterestMeta),
        gst_video_region_of_interest_meta_init,
        gst_video_region_of_interest_meta_free,
        gst_video_region_of_interest_meta_transform);
    g_once_init_leave (&meta_info, mi);
  }
  return meta_info;
}

/**
 * gst_buffer_get_video_region_of_interest_meta_id:
 * @buffer: a #GstBuffer
 * @id: a metadata id
 *
 * Find the #GstVideoRegionOfInterestMeta on @buffer with the given @id.
 *
 * Buffers can contain multiple #GstVideoRegionOfInterestMeta metadata items if
 * multiple regions of interests are marked on a frame.
 *
 * Returns: the #GstVideoeRegionOfInterestMeta with @id or %NULL when there is
 * no such metadata on @buffer.
 */
GstVideoRegionOfInterestMeta *
gst_buffer_get_video_region_of_interest_meta_id (GstBuffer * buffer, gint id)
{
  gpointer state = NULL;
  GstMeta *meta;
  const GstMetaInfo *info = GST_VIDEO_REGION_OF_INTEREST_META_INFO;

  while ((meta = gst_buffer_iterate_meta (buffer, &state))) {
    if (meta->info->api == info->api) {
      GstVideoRegionOfInterestMeta *vmeta =
          (GstVideoRegionOfInterestMeta *) meta;
      if (vmeta->id == id)
        return vmeta;
    }
  }
  return NULL;
}

/**
 * gst_buffer_add_video_region_of_interest_meta:
 * @buffer: a #GstBuffer
 * @roi_type: Type of the region of interest (e.g. "face")
 * @x: X position
 * @y: Y position
 * @w: width
 * @h: height
 *
 * Attaches #GstVideoRegionOfInterestMeta metadata to @buffer with the given
 * parameters.
 *
 * Returns: the #GstVideoRegionOfInterestMeta on @buffer.
 */
GstVideoRegionOfInterestMeta *
gst_buffer_add_video_region_of_interest_meta (GstBuffer * buffer,
    const gchar * roi_type, guint x, guint y, guint w, guint h)
{
  return gst_buffer_add_video_region_of_interest_meta_id (buffer,
      g_quark_from_string (roi_type), x, y, w, h);
}

/**
 * gst_buffer_add_video_region_of_interest_meta_id:
 * @buffer: a #GstBuffer
 * @roi_type: Type of the region of interest (e.g. "face")
 * @x: X position
 * @y: Y position
 * @w: width
 * @h: height
 *
 * Attaches #GstVideoRegionOfInterestMeta metadata to @buffer with the given
 * parameters.
 *
 * Returns: the #GstVideoRegionOfInterestMeta on @buffer.
 */
GstVideoRegionOfInterestMeta *
gst_buffer_add_video_region_of_interest_meta_id (GstBuffer * buffer,
    GQuark roi_type, guint x, guint y, guint w, guint h)
{
  GstVideoRegionOfInterestMeta *meta;

  g_return_val_if_fail (GST_IS_BUFFER (buffer), NULL);

  meta = (GstVideoRegionOfInterestMeta *) gst_buffer_add_meta (buffer,
      GST_VIDEO_REGION_OF_INTEREST_META_INFO, NULL);
  meta->roi_type = roi_type;
  meta->x = x;
  meta->y = y;
  meta->w = w;
  meta->h = h;

  return meta;
}
