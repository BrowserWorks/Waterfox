/*
 * gstvp8rangedecoder.c - VP8 range decoder interface
 *
 * Use of this source code is governed by a BSD-style license
 * that can be found in the LICENSE file in the root of the source
 * tree. An additional intellectual property rights grant can be found
 * in the file PATENTS.  All contributing project authors may
 * be found in the AUTHORS file in the root of the source tree.
 */

#include "gstvp8rangedecoder.h"
#include "dboolhuff.h"

#define BOOL_DECODER_CAST(rd) \
  ((BOOL_DECODER *)(&(rd)->_gst_reserved[0]))

gboolean
gst_vp8_range_decoder_init (GstVp8RangeDecoder * rd, const guchar * buf,
    guint buf_size)
{
  BOOL_DECODER *const bd = BOOL_DECODER_CAST (rd);

  g_return_val_if_fail (sizeof (rd->_gst_reserved) >= sizeof (*bd), FALSE);

  rd->buf = buf;
  rd->buf_size = buf_size;
  return vp8dx_start_decode (bd, buf, buf_size, NULL, NULL) == 0;
}

gint
gst_vp8_range_decoder_read (GstVp8RangeDecoder * rd, guint8 prob)
{
  return vp8dx_decode_bool (BOOL_DECODER_CAST (rd), prob);
}

gint
gst_vp8_range_decoder_read_literal (GstVp8RangeDecoder * rd, gint bits)
{
  return vp8_decode_value (BOOL_DECODER_CAST (rd), bits);
}

guint
gst_vp8_range_decoder_get_pos (GstVp8RangeDecoder * rd)
{
  BOOL_DECODER *const bd = BOOL_DECODER_CAST (rd);

  return (bd->user_buffer - rd->buf) * 8 - (8 + bd->count);
}

void
gst_vp8_range_decoder_get_state (GstVp8RangeDecoder * rd,
    GstVp8RangeDecoderState * state)
{
  BOOL_DECODER *const bd = BOOL_DECODER_CAST (rd);

  if (bd->count < 0)
    vp8dx_bool_decoder_fill (bd);

  state->range = bd->range;
  state->value = (guint8) ((bd->value) >> (VP8_BD_VALUE_SIZE - 8));
  state->count = (8 + bd->count) % 8;
}
