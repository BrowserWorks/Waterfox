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

#ifndef __GST_VIDEO_FRAME_H__
#define __GST_VIDEO_FRAME_H__

#include <gst/video/video-enumtypes.h>

G_BEGIN_DECLS

typedef struct _GstVideoFrame GstVideoFrame;

/**
 * GstVideoFrameFlags:
 * @GST_VIDEO_FRAME_FLAG_NONE: no flags
 * @GST_VIDEO_FRAME_FLAG_INTERLACED: The video frame is interlaced. In mixed
 *           interlace-mode, this flags specifies if the frame is interlace or
 *           progressive.
 * @GST_VIDEO_FRAME_FLAG_TFF: The video frame has the top field first
 * @GST_VIDEO_FRAME_FLAG_RFF: The video frame has the repeat flag
 * @GST_VIDEO_FRAME_FLAG_ONEFIELD: The video frame has one field
 *
 * Extra video frame flags
 */
typedef enum {
  GST_VIDEO_FRAME_FLAG_NONE         = 0,
  GST_VIDEO_FRAME_FLAG_INTERLACED   = (1 << 0),
  GST_VIDEO_FRAME_FLAG_TFF          = (1 << 1),
  GST_VIDEO_FRAME_FLAG_RFF          = (1 << 2),
  GST_VIDEO_FRAME_FLAG_ONEFIELD     = (1 << 3)
} GstVideoFrameFlags;

/* circular dependency, need to include this after defining the enums */
#include <gst/video/video-format.h>
#include <gst/video/video-info.h>

/**
 * GstVideoFrame:
 * @info: the #GstVideoInfo
 * @buffer: the mapped buffer
 * @meta: pointer to metadata if any
 * @id: id of the mapped frame. the id can for example be used to
 *   indentify the frame in case of multiview video.
 * @data: pointers to the plane data
 * @map: mappings of the planes
 *
 * A video frame obtained from gst_video_frame_map()
 */
struct _GstVideoFrame {
  GstVideoInfo info;
  GstVideoFrameFlags flags;

  GstBuffer *buffer;
  gpointer   meta;
  gint       id;

  gpointer   data[GST_VIDEO_MAX_PLANES];
  GstMapInfo map[GST_VIDEO_MAX_PLANES];

  /*< private >*/
  gpointer _gst_reserved[GST_PADDING];
};

gboolean    gst_video_frame_map           (GstVideoFrame *frame, GstVideoInfo *info,
                                           GstBuffer *buffer, GstMapFlags flags);
gboolean    gst_video_frame_map_id        (GstVideoFrame *frame, GstVideoInfo *info,
                                           GstBuffer *buffer, gint id, GstMapFlags flags);
void        gst_video_frame_unmap         (GstVideoFrame *frame);

gboolean    gst_video_frame_copy          (GstVideoFrame *dest, const GstVideoFrame *src);
gboolean    gst_video_frame_copy_plane    (GstVideoFrame *dest, const GstVideoFrame *src,
                                           guint plane);

/* general info */
#define GST_VIDEO_FRAME_FORMAT(f)         (GST_VIDEO_INFO_FORMAT(&(f)->info))
#define GST_VIDEO_FRAME_WIDTH(f)          (GST_VIDEO_INFO_WIDTH(&(f)->info))
#define GST_VIDEO_FRAME_HEIGHT(f)         (GST_VIDEO_INFO_HEIGHT(&(f)->info))
#define GST_VIDEO_FRAME_SIZE(f)           (GST_VIDEO_INFO_SIZE(&(f)->info))

/* flags */
#define GST_VIDEO_FRAME_FLAGS(f)          ((f)->flags)
#define GST_VIDEO_FRAME_FLAG_IS_SET(f,fl) ((GST_VIDEO_FRAME_FLAGS(f) & (fl)) == (fl))
#define GST_VIDEO_FRAME_IS_INTERLACED(f)  (GST_VIDEO_FRAME_FLAG_IS_SET(f, GST_VIDEO_FRAME_FLAG_INTERLACED))
#define GST_VIDEO_FRAME_IS_TFF(f)         (GST_VIDEO_FRAME_FLAG_IS_SET(f, GST_VIDEO_FRAME_FLAG_TFF))
#define GST_VIDEO_FRAME_IS_RFF(f)         (GST_VIDEO_FRAME_FLAG_IS_SET(f, GST_VIDEO_FRAME_FLAG_RFF))
#define GST_VIDEO_FRAME_IS_ONEFIELD(f)    (GST_VIDEO_FRAME_FLAG_IS_SET(f, GST_VIDEO_FRAME_FLAG_ONEFIELD))

/* dealing with planes */
#define GST_VIDEO_FRAME_N_PLANES(f)       (GST_VIDEO_INFO_N_PLANES(&(f)->info))
#define GST_VIDEO_FRAME_PLANE_DATA(f,p)   ((f)->data[p])
#define GST_VIDEO_FRAME_PLANE_OFFSET(f,p) (GST_VIDEO_INFO_PLANE_OFFSET(&(f)->info,(p)))
#define GST_VIDEO_FRAME_PLANE_STRIDE(f,p) (GST_VIDEO_INFO_PLANE_STRIDE(&(f)->info,(p)))

/* dealing with components */
#define GST_VIDEO_FRAME_N_COMPONENTS(f)   GST_VIDEO_INFO_N_COMPONENTS(&(f)->info)
#define GST_VIDEO_FRAME_COMP_DEPTH(f,c)   GST_VIDEO_INFO_COMP_DEPTH(&(f)->info,(c))
#define GST_VIDEO_FRAME_COMP_DATA(f,c)    GST_VIDEO_INFO_COMP_DATA(&(f)->info,(f)->data,(c))
#define GST_VIDEO_FRAME_COMP_STRIDE(f,c)  GST_VIDEO_INFO_COMP_STRIDE(&(f)->info,(c))
#define GST_VIDEO_FRAME_COMP_OFFSET(f,c)  GST_VIDEO_INFO_COMP_OFFSET(&(f)->info,(c))
#define GST_VIDEO_FRAME_COMP_WIDTH(f,c)   GST_VIDEO_INFO_COMP_WIDTH(&(f)->info,(c))
#define GST_VIDEO_FRAME_COMP_HEIGHT(f,c)  GST_VIDEO_INFO_COMP_HEIGHT(&(f)->info,(c))
#define GST_VIDEO_FRAME_COMP_PLANE(f,c)   GST_VIDEO_INFO_COMP_PLANE(&(f)->info,(c))
#define GST_VIDEO_FRAME_COMP_PSTRIDE(f,c) GST_VIDEO_INFO_COMP_PSTRIDE(&(f)->info,(c))
#define GST_VIDEO_FRAME_COMP_POFFSET(f,c) GST_VIDEO_INFO_COMP_POFFSET(&(f)->info,(c))

/* buffer flags */

/**
 * GstVideoBufferFlags:
 * @GST_VIDEO_BUFFER_FLAG_INTERLACED:  If the #GstBuffer is interlaced. In mixed
 *                                     interlace-mode, this flags specifies if the frame is
 *                                     interlaced or progressive.
 * @GST_VIDEO_BUFFER_FLAG_TFF:         If the #GstBuffer is interlaced, then the first field
 *                                     in the video frame is the top field.  If unset, the
 *                                     bottom field is first.
 * @GST_VIDEO_BUFFER_FLAG_RFF:         If the #GstBuffer is interlaced, then the first field
 *                                     (as defined by the %GST_VIDEO_BUFFER_TFF flag setting)
 *                                     is repeated.
 * @GST_VIDEO_BUFFER_FLAG_ONEFIELD:    If the #GstBuffer is interlaced, then only the
 *                                     first field (as defined by the %GST_VIDEO_BUFFER_TFF
 *                                     flag setting) is to be displayed.
 *
 * Additional video buffer flags.
 */
typedef enum {
  GST_VIDEO_BUFFER_FLAG_INTERLACED  = (GST_BUFFER_FLAG_LAST << 0),
  GST_VIDEO_BUFFER_FLAG_TFF         = (GST_BUFFER_FLAG_LAST << 1),
  GST_VIDEO_BUFFER_FLAG_RFF         = (GST_BUFFER_FLAG_LAST << 2),
  GST_VIDEO_BUFFER_FLAG_ONEFIELD    = (GST_BUFFER_FLAG_LAST << 3),

  GST_VIDEO_BUFFER_FLAG_LAST        = (GST_BUFFER_FLAG_LAST << 8)
} GstVideoBufferFlags;

G_END_DECLS

#endif /* __GST_VIDEO_FRAME_H__ */
