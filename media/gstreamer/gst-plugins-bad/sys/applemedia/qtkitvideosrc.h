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

#ifndef __GST_QTKIT_VIDEO_SRC_H__
#define __GST_QTKIT_VIDEO_SRC_H__

#include <gst/base/gstpushsrc.h>

G_BEGIN_DECLS

#define GST_TYPE_QTKIT_VIDEO_SRC \
  (gst_qtkit_video_src_get_type ())
#define GST_QTKIT_VIDEO_SRC(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_QTKIT_VIDEO_SRC, GstQTKitVideoSrc))
#define GST_QTKIT_VIDEO_SRC_CAST(obj) \
  ((GstQTKitVideoSrc *) (obj))
#define GST_QTKIT_VIDEO_SRC_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_QTKIT_VIDEO_SRC, GstQTKitVideoSrcClass))
#define GST_QTKIT_VIDEO_SRC_IMPL(obj) \
  ((GstQTKitVideoSrcImpl *) GST_QTKIT_VIDEO_SRC_CAST (obj)->impl)
#define GST_IS_QTKIT_VIDEO_SRC(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_QTKIT_VIDEO_SRC))
#define GST_IS_QTKIT_VIDEO_SRC_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_QTKIT_VIDEO_SRC))

typedef struct _GstQTKitVideoSrc         GstQTKitVideoSrc;
typedef struct _GstQTKitVideoSrcClass    GstQTKitVideoSrcClass;

struct _GstQTKitVideoSrc
{
  GstPushSrc push_src;

  gpointer impl;
};

struct _GstQTKitVideoSrcClass
{
  GstPushSrcClass parent_class;
};

GType gst_qtkit_video_src_get_type (void);

G_END_DECLS

#endif /* __GST_QTKIT_VIDEO_SRC_H__ */
