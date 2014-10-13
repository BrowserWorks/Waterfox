/*
 * Copyright (C) 2011, Hewlett-Packard Development Company, L.P.
 *   Author: Sebastian Dröge <sebastian.droege@collabora.co.uk>, Collabora Ltd.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation
 * version 2.1 of the License.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301 USA
 *
 */

#ifndef __GST_VC1_PARSE_H__
#define __GST_VC1_PARSE_H__

#include <gst/gst.h>
#include <gst/base/gstbaseparse.h>
#include <gst/codecparsers/gstvc1parser.h>

G_BEGIN_DECLS

#define GST_TYPE_VC1_PARSE \
  (gst_vc1_parse_get_type())
#define GST_VC1_PARSE(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_VC1_PARSE,GstVC1Parse))
#define GST_VC1_PARSE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_VC1_PARSE,GstVC1ParseClass))
#define GST_IS_VC1_PARSE(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_VC1_PARSE))
#define GST_IS_VC1_PARSE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_VC1_PARSE))

typedef enum {
  VC1_HEADER_FORMAT_NONE = 0,
  VC1_HEADER_FORMAT_ASF,
  VC1_HEADER_FORMAT_SEQUENCE_LAYER
} VC1HeaderFormat;

typedef enum {
  VC1_STREAM_FORMAT_BDU = 0,
  VC1_STREAM_FORMAT_BDU_FRAME,
  VC1_STREAM_FORMAT_SEQUENCE_LAYER_BDU,
  VC1_STREAM_FORMAT_SEQUENCE_LAYER_BDU_FRAME,
  VC1_STREAM_FORMAT_SEQUENCE_LAYER_RAW_FRAME,
  VC1_STREAM_FORMAT_SEQUENCE_LAYER_FRAME_LAYER,
  VC1_STREAM_FORMAT_ASF,
  VC1_STREAM_FORMAT_FRAME_LAYER
} VC1StreamFormat;

typedef enum {
  GST_VC1_PARSE_FORMAT_WMV3,
  GST_VC1_PARSE_FORMAT_WVC1
} GstVC1ParseFormat;

/* FIXME move into baseparse, or anything equivalent;
 * see https://bugzilla.gnome.org/show_bug.cgi?id=650093 */
#define GST_BASE_PARSE_FRAME_FLAG_PARSING   0x10000

typedef struct _GstVC1Parse GstVC1Parse;
typedef struct _GstVC1ParseClass GstVC1ParseClass;

struct _GstVC1Parse
{
  GstBaseParse baseparse;

  /* Caps */
  GstVC1Profile profile;
  GstVC1Level level;
  GstVC1ParseFormat format;
  gint width, height;

  gint fps_n, fps_d;
  gboolean fps_from_caps;
  GstClockTime frame_duration;
  gint par_n, par_d;
  gboolean par_from_caps;

  /* TRUE if we should negotiate with downstream */
  gboolean renegotiate;
  /* TRUE if the srcpads should be updated */
  gboolean update_caps;

  gboolean sent_codec_tag;

  VC1HeaderFormat input_header_format;
  VC1HeaderFormat output_header_format;
  VC1StreamFormat input_stream_format;
  VC1StreamFormat output_stream_format;
  gboolean detecting_stream_format;

  GstVC1SeqHdr seq_hdr;
  GstBuffer *seq_hdr_buffer;
  GstBuffer *entrypoint_buffer;

  GstVC1SeqLayer seq_layer;
  GstBuffer *seq_layer_buffer;

  /* Metadata about the currently parsed frame, only
   * valid if the GstBaseParseFrame has the
   * GST_BASE_PARSE_FRAME_FLAG_PARSING flag */
  GstVC1StartCode startcode;
};

struct _GstVC1ParseClass
{
  GstBaseParseClass parent_class;
};

G_END_DECLS

GType gst_vc1_parse_get_type (void);

#endif /* __GST_VC1_PARSE_H__ */
