/*
 * gstvp8rangedecoder.h - VP8 range decoder interface
 *
 * Copyright (C) 2014 Intel Corporation
 *   Author: Gwenole Beauchesne <gwenole.beauchesne@intel.com>
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

#ifndef GST_VP8_RANGE_DECODER_H
#define GST_VP8_RANGE_DECODER_H

#include <glib.h>
#include <gst/gstconfig.h>

typedef struct _GstVp8RangeDecoder      GstVp8RangeDecoder;
typedef struct _GstVp8RangeDecoderState GstVp8RangeDecoderState;

/**
* GstVp8RangeDecoder:
* @buf: the original bitstream buffer start
* @buf_size: the original bitstream buffer size
*
* Range decoder.
*/
struct _GstVp8RangeDecoder {
  const guchar *buf;
  guint buf_size;

  /*< private >*/
  gpointer _gst_reserved[GST_PADDING_LARGE];
};

/**
* GstVp8RangeDecoderState:
* @range: current "Range" value
* @value: current "Value" value
* @count: number of bits left in "Value" for decoding
*
* Range decoder state.
*/
struct _GstVp8RangeDecoderState {
  guint8 range;
  guint8 value;
  guint8 count;
};

gboolean
gst_vp8_range_decoder_init (GstVp8RangeDecoder * rd, const guchar * buf,
   guint buf_size);

gint
gst_vp8_range_decoder_read (GstVp8RangeDecoder * rd, guint8 prob);

gint
gst_vp8_range_decoder_read_literal (GstVp8RangeDecoder * rd, gint bits);

guint
gst_vp8_range_decoder_get_pos (GstVp8RangeDecoder * rd);

void
gst_vp8_range_decoder_get_state (GstVp8RangeDecoder * rd,
   GstVp8RangeDecoderState * state);

#endif /* GST_VP8_RANGE_DECODER_H */
