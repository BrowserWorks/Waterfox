/* Gstreamer
 * Copyright (C) <2012> Edward Hervey <edward@collabora.com>
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
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#ifndef __GST_MPEG_VIDEO_META_H__
#define __GST_MPEG_VIDEO_META_H__

#ifndef GST_USE_UNSTABLE_API
#warning "The Mpeg video parsing library is unstable API and may change in future."
#warning "You can define GST_USE_UNSTABLE_API to avoid this warning."
#endif

#include <gst/gst.h>
#include <gst/codecparsers/gstmpegvideoparser.h>

G_BEGIN_DECLS

typedef struct _GstMpegVideoMeta GstMpegVideoMeta;

GType gst_mpeg_video_meta_api_get_type (void);
#define GST_MPEG_VIDEO_META_API_TYPE  (gst_mpeg_video_meta_api_get_type())
#define GST_MPEG_VIDEO_META_INFO  (gst_mpeg_video_meta_get_info())
const GstMetaInfo * gst_mpeg_video_meta_get_info (void);

/**
 * GstMpegVideoMeta:
 * @meta: parent #GstMeta
 * @sequencehdr: the #GstMpegVideoSequenceHdr if present in the buffer
 * @sequenceext: the #GstMpegVideoSequenceExt if present in the buffer
 * @sequencedispext: the #GstMpegVideoSequenceDisplayExt if present in the
 * buffer.
 * @pichdr: the #GstMpegVideoPictureHdr if present in the buffer.
 * @picext: the #GstMpegVideoPictureExt if present in the buffer.
 * @quantext: the #GstMpegVideoQuantMatrixExt if present in the buffer
 *
 * Extra buffer metadata describing the contents of a MPEG1/2 Video frame
 *
 * Can be used by elements (mainly decoders) to avoid having to parse
 * Mpeg video 1/2 packets if it can be done upstream.
 *
 * The various fields are only valid during the lifetime of the #GstMpegVideoMeta.
 * If elements wish to use those for longer, they are required to make a copy.
 *
 * Since: 1.2
 */
struct _GstMpegVideoMeta {
  GstMeta            meta;

  GstMpegVideoSequenceHdr        *sequencehdr;
  GstMpegVideoSequenceExt        *sequenceext;
  GstMpegVideoSequenceDisplayExt *sequencedispext;
  GstMpegVideoPictureHdr         *pichdr;
  GstMpegVideoPictureExt         *picext;
  GstMpegVideoQuantMatrixExt     *quantext;

  guint num_slices;
  gsize slice_offset;
};


#define gst_buffer_get_mpeg_video_meta(b) ((GstMpegVideoMeta*)gst_buffer_get_meta((b),GST_MPEG_VIDEO_META_API_TYPE))

GstMpegVideoMeta *
gst_buffer_add_mpeg_video_meta (GstBuffer * buffer, 
                                const GstMpegVideoSequenceHdr *seq_hdr,
                                const GstMpegVideoSequenceExt *seq_ext,
                                const GstMpegVideoSequenceDisplayExt *disp_ext,
                                const GstMpegVideoPictureHdr *pic_hdr,
                                const GstMpegVideoPictureExt *pic_ext,
                                const GstMpegVideoQuantMatrixExt *quant_ext);

G_END_DECLS

#endif
