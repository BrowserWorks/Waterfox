/* GStreamer Wavpack parser
 * Copyright (C) 2012 Mark Nauwelaerts <mark.nauwelaerts@collabora.co.uk>
 * Copyright (C) 2012 Nokia Corporation. All rights reserved.
 *   Contact: Stefan Kost <stefan.kost@nokia.com>
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

#ifndef __GST_WAVPACK_PARSE_H__
#define __GST_WAVPACK_PARSE_H__

#include <gst/gst.h>
#include <gst/base/gstbaseparse.h>

G_BEGIN_DECLS

#define GST_TYPE_WAVPACK_PARSE \
  (gst_wavpack_parse_get_type())
#define GST_WAVPACK_PARSE(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), GST_TYPE_WAVPACK_PARSE, GstWavpackParse))
#define GST_WAVPACK_PARSE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass), GST_TYPE_WAVPACK_PARSE, GstWavpackParseClass))
#define GST_IS_WAVPACK_PARSE(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj), GST_TYPE_WAVPACK_PARSE))
#define GST_IS_WAVPACK_PARSE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass), GST_TYPE_WAVPACK_PARSE))


#define ID_UNIQUE               0x3f
#define ID_OPTIONAL_DATA        0x20
#define ID_ODD_SIZE             0x40
#define ID_LARGE                0x80

#define ID_DUMMY                0x0
#define ID_ENCODER_INFO         0x1
#define ID_DECORR_TERMS         0x2
#define ID_DECORR_WEIGHTS       0x3
#define ID_DECORR_SAMPLES       0x4
#define ID_ENTROPY_VARS         0x5
#define ID_HYBRID_PROFILE       0x6
#define ID_SHAPING_WEIGHTS      0x7
#define ID_FLOAT_INFO           0x8
#define ID_INT32_INFO           0x9
#define ID_WV_BITSTREAM         0xa
#define ID_WVC_BITSTREAM        0xb
#define ID_WVX_BITSTREAM        0xc
#define ID_CHANNEL_INFO         0xd

#define ID_RIFF_HEADER          (ID_OPTIONAL_DATA | 0x1)
#define ID_RIFF_TRAILER         (ID_OPTIONAL_DATA | 0x2)
#define ID_REPLAY_GAIN          (ID_OPTIONAL_DATA | 0x3)
#define ID_CUESHEET             (ID_OPTIONAL_DATA | 0x4)
#define ID_CONFIG_BLOCK         (ID_OPTIONAL_DATA | 0x5)
#define ID_MD5_CHECKSUM         (ID_OPTIONAL_DATA | 0x6)
#define ID_SAMPLE_RATE          (ID_OPTIONAL_DATA | 0x7)

#define FLAG_FINAL_BLOCK        (1 << 12)

typedef struct {
  char ckID [4];             /* "wvpk" */
  guint32 ckSize;            /* size of entire block (minus 8, of course) */
  guint16 version;           /* 0x402 to 0x410 are currently valid for decode */
  guchar track_no;           /* track number (0 if not used, like now) */
  guchar index_no;           /* track sub-index (0 if not used, like now) */
  guint32 total_samples;     /* total samples for entire file, but this is
                              * only valid if block_index == 0 and a value of
                              * -1 indicates unknown length */
  guint32 block_index;       /* index of first sample in block relative to
                              * beginning of file (normally this would start
                              * at 0 for the first block) */
  guint32 block_samples;     /* number of samples in this block (0 = no audio) */
  guint32 flags;             /* various flags for id and decoding */
  guint32 crc;               /* crc for actual decoded data */
} WavpackHeader;

typedef struct {
  gboolean correction;
  guint rate;
  guint width;
  guint channels;
  guint channel_mask;
} WavpackInfo;

typedef struct _GstWavpackParse GstWavpackParse;
typedef struct _GstWavpackParseClass GstWavpackParseClass;

/**
 * GstWavpackParse:
 *
 * The opaque GstWavpackParse object
 */
struct _GstWavpackParse {
  GstBaseParse baseparse;

  /*< private >*/
  gint          sample_rate;
  gint          channels;
  gint          width;
  gint          channel_mask;

  guint         total_samples;

  gboolean      sent_codec_tag;
};

/**
 * GstWavpackParseClass:
 * @parent_class: Element parent class.
 *
 * The opaque GstWavpackParseClass data structure.
 */
struct _GstWavpackParseClass {
  GstBaseParseClass baseparse_class;
};

GType gst_wavpack_parse_get_type (void);

G_END_DECLS

#endif /* __GST_WAVPACK_PARSE_H__ */
