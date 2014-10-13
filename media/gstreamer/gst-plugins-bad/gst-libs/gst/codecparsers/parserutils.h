/* Gstreamer
 * Copyright (C) <2011> Intel
 * Copyright (C) <2011> Collabora Ltd.
 * Copyright (C) <2011> Thibault Saunier <thibault.saunier@collabora.com>
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

#ifndef __PARSER_UTILS__
#define __PARSER_UTILS__

#include <gst/gst.h>
#include <gst/base/gstbitreader.h>

/* Parsing utils */
#define GET_BITS(b, num, bits) G_STMT_START {        \
  if (!gst_bit_reader_get_bits_uint32(b, bits, num)) \
    goto failed;                                     \
  GST_TRACE ("parsed %d bits: %d", num, *(bits));    \
} G_STMT_END

#define CHECK_ALLOWED(val, min, max) G_STMT_START { \
  if (val < min || val > max) { \
    GST_WARNING ("value not in allowed range. value: %d, range %d-%d", \
                     val, min, max); \
    goto failed; \
  } \
} G_STMT_END

#define READ_UINT8(reader, val, nbits) G_STMT_START { \
  if (!gst_bit_reader_get_bits_uint8 (reader, &val, nbits)) { \
    GST_WARNING ("failed to read uint8, nbits: %d", nbits); \
    goto failed; \
  } \
} G_STMT_END

#define READ_UINT16(reader, val, nbits) G_STMT_START { \
  if (!gst_bit_reader_get_bits_uint16 (reader, &val, nbits)) { \
    GST_WARNING ("failed to read uint16, nbits: %d", nbits); \
    goto failed; \
  } \
} G_STMT_END

#define READ_UINT32(reader, val, nbits) G_STMT_START { \
  if (!gst_bit_reader_get_bits_uint32 (reader, &val, nbits)) { \
    GST_WARNING ("failed to read uint32, nbits: %d", nbits); \
    goto failed; \
  } \
} G_STMT_END

#define READ_UINT64(reader, val, nbits) G_STMT_START { \
  if (!gst_bit_reader_get_bits_uint64 (reader, &val, nbits)) { \
    GST_WARNING ("failed to read uint64, nbits: %d", nbits); \
    goto failed; \
  } \
} G_STMT_END


#define U_READ_UINT8(reader, val, nbits) G_STMT_START { \
  val = gst_bit_reader_get_bits_uint8_unchecked (reader, nbits); \
} G_STMT_END

#define U_READ_UINT16(reader, val, nbits) G_STMT_START { \
  val = gst_bit_reader_get_bits_uint16_unchecked (reader, nbits); \
} G_STMT_END

#define U_READ_UINT32(reader, val, nbits) G_STMT_START { \
  val = gst_bit_reader_get_bits_uint32_unchecked (reader, nbits); \
} G_STMT_END

#define U_READ_UINT64(reader, val, nbits) G_STMT_START { \
  val = gst_bit_reader_get_bits_uint64_unchecked (reader, nbits); \
} G_STMT_END

#define SKIP(reader, nbits) G_STMT_START { \
  if (!gst_bit_reader_skip (reader, nbits)) { \
    GST_WARNING ("failed to skip nbits: %d", nbits); \
    goto failed; \
  } \
} G_STMT_END

typedef struct _VLCTable VLCTable;

struct _VLCTable
{
  guint value;
  guint cword;
  guint cbits;
};

gboolean
decode_vlc (GstBitReader * br, guint * res, const VLCTable * table,
    guint length);

#endif /* __PARSER_UTILS__ */
