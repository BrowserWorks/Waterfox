/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
 * Library       <2002> Ronald Bultje <rbultje@ronald.bitfreak.net>
 * Copyright (C) 2007 David A. Schleef <ds@schleef.org>
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

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <string.h>
#include <stdio.h>

#include <gst/video/video.h>
#include "video-frame.h"
#include "video-tile.h"
#include "gstvideometa.h"

GST_DEBUG_CATEGORY_EXTERN (GST_CAT_PERFORMANCE);

/**
 * gst_video_frame_map_id:
 * @frame: pointer to #GstVideoFrame
 * @info: a #GstVideoInfo
 * @buffer: the buffer to map
 * @id: the frame id to map
 * @flags: #GstMapFlags
 *
 * Use @info and @buffer to fill in the values of @frame with the video frame
 * information of frame @id.
 *
 * When @id is -1, the default frame is mapped. When @id != -1, this function
 * will return %FALSE when there is no GstVideoMeta with that id.
 *
 * All video planes of @buffer will be mapped and the pointers will be set in
 * @frame->data.
 *
 * Returns: %TRUE on success.
 */
gboolean
gst_video_frame_map_id (GstVideoFrame * frame, GstVideoInfo * info,
    GstBuffer * buffer, gint id, GstMapFlags flags)
{
  GstVideoMeta *meta;
  gint i;

  g_return_val_if_fail (frame != NULL, FALSE);
  g_return_val_if_fail (info != NULL, FALSE);
  g_return_val_if_fail (GST_IS_BUFFER (buffer), FALSE);

  if (id == -1)
    meta = gst_buffer_get_video_meta (buffer);
  else
    meta = gst_buffer_get_video_meta_id (buffer, id);

  /* copy the info */
  frame->info = *info;

  if (meta) {
    frame->info.finfo = gst_video_format_get_info (meta->format);
    frame->info.width = meta->width;
    frame->info.height = meta->height;
    frame->id = meta->id;
    frame->flags = meta->flags;

    for (i = 0; i < info->finfo->n_planes; i++) {
      frame->info.offset[i] = meta->offset[i];
      if (!gst_video_meta_map (meta, i, &frame->map[i], &frame->data[i],
              &frame->info.stride[i], flags))
        goto frame_map_failed;
    }
  } else {
    /* no metadata, we really need to have the metadata when the id is
     * specified. */
    if (id != -1)
      goto no_metadata;

    frame->id = id;
    frame->flags = 0;

    if (!gst_buffer_map (buffer, &frame->map[0], flags))
      goto map_failed;

    /* do some sanity checks */
    if (frame->map[0].size < info->size)
      goto invalid_size;

    /* set up pointers */
    for (i = 0; i < info->finfo->n_planes; i++) {
      frame->data[i] = frame->map[0].data + info->offset[i];
    }
  }
  frame->buffer = gst_buffer_ref (buffer);
  frame->meta = meta;

  /* buffer flags enhance the frame flags */
  if (GST_VIDEO_INFO_IS_INTERLACED (info)) {
    if (GST_VIDEO_INFO_INTERLACE_MODE (info) == GST_VIDEO_INTERLACE_MODE_MIXED) {
      if (GST_BUFFER_FLAG_IS_SET (buffer, GST_VIDEO_BUFFER_FLAG_INTERLACED)) {
        frame->flags |= GST_VIDEO_FRAME_FLAG_INTERLACED;
      }
    } else
      frame->flags |= GST_VIDEO_FRAME_FLAG_INTERLACED;

    if (GST_BUFFER_FLAG_IS_SET (buffer, GST_VIDEO_BUFFER_FLAG_TFF))
      frame->flags |= GST_VIDEO_FRAME_FLAG_TFF;
    if (GST_BUFFER_FLAG_IS_SET (buffer, GST_VIDEO_BUFFER_FLAG_RFF))
      frame->flags |= GST_VIDEO_FRAME_FLAG_RFF;
    if (GST_BUFFER_FLAG_IS_SET (buffer, GST_VIDEO_BUFFER_FLAG_ONEFIELD))
      frame->flags |= GST_VIDEO_FRAME_FLAG_ONEFIELD;
  }
  return TRUE;

  /* ERRORS */
no_metadata:
  {
    GST_ERROR ("no GstVideoMeta for id %d", id);
    memset (frame, 0, sizeof (GstVideoFrame));
    return FALSE;
  }
frame_map_failed:
  {
    GST_ERROR ("failed to map video frame plane %d", i);
    while (--i >= 0)
      gst_video_meta_unmap (meta, i, &frame->map[i]);
    memset (frame, 0, sizeof (GstVideoFrame));
    return FALSE;
  }
map_failed:
  {
    GST_ERROR ("failed to map buffer");
    return FALSE;
  }
invalid_size:
  {
    GST_ERROR ("invalid buffer size %" G_GSIZE_FORMAT " < %" G_GSIZE_FORMAT,
        frame->map[0].size, info->size);
    gst_buffer_unmap (buffer, &frame->map[0]);
    memset (frame, 0, sizeof (GstVideoFrame));
    return FALSE;
  }
}

/**
 * gst_video_frame_map:
 * @frame: pointer to #GstVideoFrame
 * @info: a #GstVideoInfo
 * @buffer: the buffer to map
 * @flags: #GstMapFlags
 *
 * Use @info and @buffer to fill in the values of @frame.
 *
 * All video planes of @buffer will be mapped and the pointers will be set in
 * @frame->data.
 *
 * Returns: %TRUE on success.
 */
gboolean
gst_video_frame_map (GstVideoFrame * frame, GstVideoInfo * info,
    GstBuffer * buffer, GstMapFlags flags)
{
  return gst_video_frame_map_id (frame, info, buffer, -1, flags);
}

/**
 * gst_video_frame_unmap:
 * @frame: a #GstVideoFrame
 *
 * Unmap the memory previously mapped with gst_video_frame_map.
 */
void
gst_video_frame_unmap (GstVideoFrame * frame)
{
  GstBuffer *buffer;
  GstVideoMeta *meta;
  gint i;

  g_return_if_fail (frame != NULL);

  buffer = frame->buffer;
  meta = frame->meta;

  if (meta) {
    for (i = 0; i < frame->info.finfo->n_planes; i++) {
      gst_video_meta_unmap (meta, i, &frame->map[i]);
    }
  } else {
    gst_buffer_unmap (buffer, &frame->map[0]);
  }
  gst_buffer_unref (buffer);
}

/**
 * gst_video_frame_copy_plane:
 * @dest: a #GstVideoFrame
 * @src: a #GstVideoFrame
 * @plane: a plane
 *
 * Copy the plane with index @plane from @src to @dest.
 *
 * Returns: TRUE if the contents could be copied.
 */
gboolean
gst_video_frame_copy_plane (GstVideoFrame * dest, const GstVideoFrame * src,
    guint plane)
{
  const GstVideoInfo *sinfo;
  GstVideoInfo *dinfo;
  const GstVideoFormatInfo *finfo;
  guint8 *sp, *dp;
  guint w, h;
  gint ss, ds;

  g_return_val_if_fail (dest != NULL, FALSE);
  g_return_val_if_fail (src != NULL, FALSE);

  sinfo = &src->info;
  dinfo = &dest->info;

  g_return_val_if_fail (dinfo->finfo->format == sinfo->finfo->format, FALSE);

  finfo = dinfo->finfo;

  g_return_val_if_fail (dinfo->width == sinfo->width
      && dinfo->height == sinfo->height, FALSE);
  g_return_val_if_fail (finfo->n_planes > plane, FALSE);

  sp = src->data[plane];
  dp = dest->data[plane];

  if (GST_VIDEO_FORMAT_INFO_HAS_PALETTE (finfo) && plane == 1) {
    /* copy the palette and we're done */
    memcpy (dp, sp, 256 * 4);
    return TRUE;
  }

  /* FIXME. assumes subsampling of component N is the same as plane N, which is
   * currently true for all formats we have but it might not be in the future. */
  w = GST_VIDEO_FRAME_COMP_WIDTH (dest,
      plane) * GST_VIDEO_FRAME_COMP_PSTRIDE (dest, plane);
  h = GST_VIDEO_FRAME_COMP_HEIGHT (dest, plane);

  ss = GST_VIDEO_INFO_PLANE_STRIDE (sinfo, plane);
  ds = GST_VIDEO_INFO_PLANE_STRIDE (dinfo, plane);

  if (GST_VIDEO_FORMAT_INFO_IS_TILED (finfo)) {
    gint tile_size;
    gint sx_tiles, sy_tiles, dx_tiles, dy_tiles;
    guint i, j, ws, hs, ts;
    GstVideoTileMode mode;

    ws = GST_VIDEO_FORMAT_INFO_TILE_WS (finfo);
    hs = GST_VIDEO_FORMAT_INFO_TILE_HS (finfo);
    ts = ws + hs;

    tile_size = 1 << ts;

    mode = GST_VIDEO_FORMAT_INFO_TILE_MODE (finfo);

    sx_tiles = GST_VIDEO_TILE_X_TILES (ss);
    sy_tiles = GST_VIDEO_TILE_Y_TILES (ss);

    dx_tiles = GST_VIDEO_TILE_X_TILES (ds);
    dy_tiles = GST_VIDEO_TILE_Y_TILES (ds);

    /* this is the amount of tiles to copy */
    w = ((w - 1) >> ws) + 1;
    h = ((h - 1) >> hs) + 1;

    /* FIXME can possibly do better when no retiling is needed, it depends on
     * the stride and the tile_size */
    for (j = 0; j < h; j++) {
      for (i = 0; i < w; i++) {
        guint si, di;

        si = gst_video_tile_get_index (mode, i, j, sx_tiles, sy_tiles);
        di = gst_video_tile_get_index (mode, i, j, dx_tiles, dy_tiles);

        memcpy (dp + (di << ts), sp + (si << ts), tile_size);
      }
    }
  } else {
    guint j;

    GST_CAT_DEBUG (GST_CAT_PERFORMANCE, "copy plane %d, w:%d h:%d ", plane, w,
        h);

    for (j = 0; j < h; j++) {
      memcpy (dp, sp, w);
      dp += ds;
      sp += ss;
    }
  }

  return TRUE;
}

/**
 * gst_video_frame_copy:
 * @dest: a #GstVideoFrame
 * @src: a #GstVideoFrame
 *
 * Copy the contents from @src to @dest.
 *
 * Returns: TRUE if the contents could be copied.
 */
gboolean
gst_video_frame_copy (GstVideoFrame * dest, const GstVideoFrame * src)
{
  guint i, n_planes;
  const GstVideoInfo *sinfo;
  GstVideoInfo *dinfo;

  g_return_val_if_fail (dest != NULL, FALSE);
  g_return_val_if_fail (src != NULL, FALSE);

  sinfo = &src->info;
  dinfo = &dest->info;

  g_return_val_if_fail (dinfo->finfo->format == sinfo->finfo->format, FALSE);
  g_return_val_if_fail (dinfo->width == sinfo->width
      && dinfo->height == sinfo->height, FALSE);

  n_planes = dinfo->finfo->n_planes;

  for (i = 0; i < n_planes; i++)
    gst_video_frame_copy_plane (dest, src, i);

  return TRUE;
}
