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

#ifndef __GST_VTH264ENCBIN_H__
#define __GST_VTH264ENCBIN_H__

#include <gst/gst.h>

G_BEGIN_DECLS

#define GST_TYPE_VT_H264_ENC_BIN (gst_vt_h264_enc_bin_get_type())
#define GST_VT_H264_ENC_BIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), GST_TYPE_VT_H264_ENC_BIN, \
  GstVTH264EncBin))
#define GST_VT_H264_ENC_BIN_CAST(obj) \
  ((GstVTH264EncBin *) (obj))
#define GST_VT_H264_ENC_BIN_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass), GST_TYPE_VT_H264_ENC_BIN, \
  GstVTH264EncBinClass))
#define GST_IS_VT_H264_ENC_BIN(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj), GST_TYPE_VT_H264_ENC_BIN))
#define GST_IS_VT_H264_ENC_BIN_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass), GST_TYPE_VT_H264_ENC_BIN))

typedef struct _GstVTH264EncBin        GstVTH264EncBin;
typedef struct _GstVTH264EncBinPrivate GstVTH264EncBinPrivate;
typedef struct _GstVTH264EncBinClass   GstVTH264EncBinClass;

struct _GstVTH264EncBin
{
  GstBin parent;

  GstVTH264EncBinPrivate * priv;
};

struct _GstVTH264EncBinClass
{
  GstBinClass parent_class;
};

GType gst_vt_h264_enc_bin_get_type (void);

G_END_DECLS

#endif /* __GST_VTH264ENCBIN_H__ */
