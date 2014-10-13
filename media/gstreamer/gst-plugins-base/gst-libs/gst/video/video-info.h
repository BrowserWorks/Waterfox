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

#ifndef __GST_VIDEO_INFO_H__
#define __GST_VIDEO_INFO_H__

#include <gst/gst.h>
#include <gst/video/video-format.h>
#include <gst/video/video-color.h>

G_BEGIN_DECLS

#include <gst/video/video-enumtypes.h>

typedef struct _GstVideoInfo GstVideoInfo;

/**
 * GstVideoInterlaceMode:
 * @GST_VIDEO_INTERLACE_MODE_PROGRESSIVE: all frames are progressive
 * @GST_VIDEO_INTERLACE_MODE_INTERLEAVED: 2 fields are interleaved in one video
 *     frame. Extra buffer flags describe the field order.
 * @GST_VIDEO_INTERLACE_MODE_MIXED: frames contains both interlaced and
 *     progressive video, the buffer flags describe the frame and fields.
 * @GST_VIDEO_INTERLACE_MODE_FIELDS: 2 fields are stored in one buffer, use the
 *     frame ID to get access to the required field. For multiview (the
 *     'views' property > 1) the fields of view N can be found at frame ID
 *     (N * 2) and (N * 2) + 1.
 *     Each field has only half the amount of lines as noted in the
 *     height property. This mode requires multiple GstVideoMeta metadata
 *     to describe the fields.
 *
 * The possible values of the #GstVideoInterlaceMode describing the interlace
 * mode of the stream.
 */
typedef enum {
  GST_VIDEO_INTERLACE_MODE_PROGRESSIVE = 0,
  GST_VIDEO_INTERLACE_MODE_INTERLEAVED,
  GST_VIDEO_INTERLACE_MODE_MIXED,
  GST_VIDEO_INTERLACE_MODE_FIELDS
} GstVideoInterlaceMode;

/**
 * GstVideoFlags:
 * @GST_VIDEO_FLAG_NONE: no flags
 * @GST_VIDEO_FLAG_VARIABLE_FPS: a variable fps is selected, fps_n and fps_d
 *     denote the maximum fps of the video
 * @GST_VIDEO_FLAG_PREMULTIPLIED_ALPHA: Each color has been scaled by the alpha
 *     value.
 *
 * Extra video flags
 */
typedef enum {
  GST_VIDEO_FLAG_NONE                = 0,
  GST_VIDEO_FLAG_VARIABLE_FPS        = (1 << 0),
  GST_VIDEO_FLAG_PREMULTIPLIED_ALPHA = (1 << 1)
} GstVideoFlags;

/**
 * GstVideoInfo:
 * @finfo: the format info of the video
 * @interlace_mode: the interlace mode
 * @flags: additional video flags
 * @width: the width of the video
 * @height: the height of the video
 * @views: the number of views for multiview video
 * @size: the default size of one frame
 * @chroma_site: a #GstVideoChromaSite.
 * @colorimetry: the colorimetry info
 * @par_n: the pixel-aspect-ratio numerator
 * @par_d: the pixel-aspect-ratio demnominator
 * @fps_n: the framerate numerator
 * @fps_d: the framerate demnominator
 * @offset: offsets of the planes
 * @stride: strides of the planes
 *
 * Information describing image properties. This information can be filled
 * in from GstCaps with gst_video_info_from_caps(). The information is also used
 * to store the specific video info when mapping a video frame with
 * gst_video_frame_map().
 *
 * Use the provided macros to access the info in this structure.
 */
struct _GstVideoInfo {
  const GstVideoFormatInfo *finfo;

  GstVideoInterlaceMode     interlace_mode;
  GstVideoFlags             flags;
  gint                      width;
  gint                      height;
  gsize                     size;
  gint                      views;

  GstVideoChromaSite        chroma_site;
  GstVideoColorimetry       colorimetry;

  gint                      par_n;
  gint                      par_d;
  gint                      fps_n;
  gint                      fps_d;

  gsize                     offset[GST_VIDEO_MAX_PLANES];
  gint                      stride[GST_VIDEO_MAX_PLANES];

  /*< private >*/
  gpointer _gst_reserved[GST_PADDING];
};

/* general info */
#define GST_VIDEO_INFO_FORMAT(i)         (GST_VIDEO_FORMAT_INFO_FORMAT((i)->finfo))
#define GST_VIDEO_INFO_NAME(i)           (GST_VIDEO_FORMAT_INFO_NAME((i)->finfo))
#define GST_VIDEO_INFO_IS_YUV(i)         (GST_VIDEO_FORMAT_INFO_IS_YUV((i)->finfo))
#define GST_VIDEO_INFO_IS_RGB(i)         (GST_VIDEO_FORMAT_INFO_IS_RGB((i)->finfo))
#define GST_VIDEO_INFO_IS_GRAY(i)        (GST_VIDEO_FORMAT_INFO_IS_GRAY((i)->finfo))
#define GST_VIDEO_INFO_HAS_ALPHA(i)      (GST_VIDEO_FORMAT_INFO_HAS_ALPHA((i)->finfo))

#define GST_VIDEO_INFO_INTERLACE_MODE(i) ((i)->interlace_mode)
#define GST_VIDEO_INFO_IS_INTERLACED(i)  ((i)->interlace_mode != GST_VIDEO_INTERLACE_MODE_PROGRESSIVE)
#define GST_VIDEO_INFO_FLAGS(i)          ((i)->flags)
#define GST_VIDEO_INFO_WIDTH(i)          ((i)->width)
#define GST_VIDEO_INFO_HEIGHT(i)         ((i)->height)
#define GST_VIDEO_INFO_SIZE(i)           ((i)->size)
#define GST_VIDEO_INFO_VIEWS(i)          ((i)->views)
#define GST_VIDEO_INFO_PAR_N(i)          ((i)->par_n)
#define GST_VIDEO_INFO_PAR_D(i)          ((i)->par_d)
#define GST_VIDEO_INFO_FPS_N(i)          ((i)->fps_n)
#define GST_VIDEO_INFO_FPS_D(i)          ((i)->fps_d)

/* dealing with GstVideoInfo flags */
#define GST_VIDEO_INFO_FLAG_IS_SET(i,flag) ((GST_VIDEO_INFO_FLAGS(i) & (flag)) == (flag))
#define GST_VIDEO_INFO_FLAG_SET(i,flag)    (GST_VIDEO_INFO_FLAGS(i) |= (flag))
#define GST_VIDEO_INFO_FLAG_UNSET(i,flag)  (GST_VIDEO_INFO_FLAGS(i) &= ~(flag))

/* dealing with planes */
#define GST_VIDEO_INFO_N_PLANES(i)       (GST_VIDEO_FORMAT_INFO_N_PLANES((i)->finfo))
#define GST_VIDEO_INFO_PLANE_OFFSET(i,p) ((i)->offset[p])
#define GST_VIDEO_INFO_PLANE_STRIDE(i,p) ((i)->stride[p])

/* dealing with components */
#define GST_VIDEO_INFO_N_COMPONENTS(i)   GST_VIDEO_FORMAT_INFO_N_COMPONENTS((i)->finfo)
#define GST_VIDEO_INFO_COMP_DEPTH(i,c)   GST_VIDEO_FORMAT_INFO_DEPTH((i)->finfo,(c))
#define GST_VIDEO_INFO_COMP_DATA(i,d,c)  GST_VIDEO_FORMAT_INFO_DATA((i)->finfo,d,(c))
#define GST_VIDEO_INFO_COMP_OFFSET(i,c)  GST_VIDEO_FORMAT_INFO_OFFSET((i)->finfo,(i)->offset,(c))
#define GST_VIDEO_INFO_COMP_STRIDE(i,c)  GST_VIDEO_FORMAT_INFO_STRIDE((i)->finfo,(i)->stride,(c))
#define GST_VIDEO_INFO_COMP_WIDTH(i,c)   GST_VIDEO_FORMAT_INFO_SCALE_WIDTH((i)->finfo,(c),(i)->width)
#define GST_VIDEO_INFO_COMP_HEIGHT(i,c)  GST_VIDEO_FORMAT_INFO_SCALE_HEIGHT((i)->finfo,(c),(i)->height)
#define GST_VIDEO_INFO_COMP_PLANE(i,c)   GST_VIDEO_FORMAT_INFO_PLANE((i)->finfo,(c))
#define GST_VIDEO_INFO_COMP_PSTRIDE(i,c) GST_VIDEO_FORMAT_INFO_PSTRIDE((i)->finfo,(c))
#define GST_VIDEO_INFO_COMP_POFFSET(i,c) GST_VIDEO_FORMAT_INFO_POFFSET((i)->finfo,(c))

void         gst_video_info_init        (GstVideoInfo *info);

void         gst_video_info_set_format  (GstVideoInfo *info, GstVideoFormat format,
                                         guint width, guint height);

gboolean     gst_video_info_from_caps   (GstVideoInfo *info, const GstCaps  * caps);

GstCaps *    gst_video_info_to_caps     (GstVideoInfo *info);

gboolean     gst_video_info_convert     (GstVideoInfo *info,
                                         GstFormat     src_format,
                                         gint64        src_value,
                                         GstFormat     dest_format,
                                         gint64       *dest_value);
gboolean     gst_video_info_is_equal    (const GstVideoInfo *info,
					 const GstVideoInfo *other);

#include <gst/video/video.h>

void         gst_video_info_align       (GstVideoInfo * info, GstVideoAlignment * align);


G_END_DECLS

#endif /* __GST_VIDEO_INFO_H__ */
