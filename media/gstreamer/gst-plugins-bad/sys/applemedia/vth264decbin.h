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

#ifndef __GST_VTH264DECBIN_H__
#define __GST_VTH264DECBIN_H__

#include <gst/gst.h>

G_BEGIN_DECLS

#define GST_TYPE_VT_H264_DEC_BIN (gst_vt_h264_dec_bin_get_type())
#define GST_VT_H264_DEC_BIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), GST_TYPE_VT_H264_DEC_BIN, \
  GstVTH264DecBin))
#define GST_VT_H264_DEC_BIN_CAST(obj) \
  ((GstVTH264DecBin *) (obj))
#define GST_VT_H264_DEC_BIN_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass), GST_TYPE_VT_H264_DEC_BIN, \
  GstVTH264DecBinClass))
#define GST_IS_VT_H264_DEC_BIN(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj), GST_TYPE_VT_H264_DEC_BIN))
#define GST_IS_VT_H264_DEC_BIN_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass), GST_TYPE_VT_H264_DEC_BIN))

typedef struct _GstVTH264DecBin        GstVTH264DecBin;
typedef struct _GstVTH264DecBinPrivate GstVTH264DecBinPrivate;
typedef struct _GstVTH264DecBinClass   GstVTH264DecBinClass;

struct _GstVTH264DecBin
{
  GstBin parent;

  GstVTH264DecBinPrivate * priv;
};

struct _GstVTH264DecBinClass
{
  GstBinClass parent_class;
};

GType gst_vt_h264_dec_bin_get_type (void);

G_END_DECLS

#endif /* __GST_VTH264DECBIN_H__ */
