/* GStreamer QuickTime atom parser
 * Copyright (C) 2009 Tim-Philipp Müller <tim centricular net>
 * Copyright (C) <2009> STEricsson <benjamin.gaignard@stericsson.com>
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

#ifndef QT_ATOM_PARSER_H
#define QT_ATOM_PARSER_H

#include <gst/base/gstbytereader.h>

/* our inlined version of GstByteReader */

static inline gboolean
qt_atom_parser_has_remaining (GstByteReader * parser, guint64 bytes_needed)
{
  return G_LIKELY (parser->size >= bytes_needed) &&
      G_LIKELY ((parser->size - bytes_needed) >= parser->byte);
}

static inline gboolean
qt_atom_parser_has_chunks (GstByteReader * parser, guint32 n_chunks,
    guint32 chunk_size)
{
  /* assumption: n_chunks and chunk_size are 32-bit, we cast to 64-bit here
   * to avoid overflows, to handle e.g. (guint32)-1 * size correctly */
  return qt_atom_parser_has_remaining (parser, (guint64) n_chunks * chunk_size);
}

static inline gboolean
qt_atom_parser_peek_sub (GstByteReader * parser, guint offset, guint size,
    GstByteReader * sub)
{
  *sub = *parser;

  if (G_UNLIKELY (!gst_byte_reader_skip (sub, offset)))
    return FALSE;

  return (gst_byte_reader_get_remaining (sub) >= size);
}

static inline gboolean
qt_atom_parser_skipn_and_get_uint32 (GstByteReader * parser,
    guint bytes_to_skip, guint32 * val)
{
  if (G_UNLIKELY (gst_byte_reader_get_remaining (parser) < (bytes_to_skip + 4)))
    return FALSE;

  gst_byte_reader_skip_unchecked (parser, bytes_to_skip);
  *val = gst_byte_reader_get_uint32_be_unchecked (parser);
  return TRUE;
}

/* off_size must be either 4 or 8 */
static inline gboolean
qt_atom_parser_get_offset (GstByteReader * parser, guint off_size,
    guint64 * val)
{
  if (G_UNLIKELY (gst_byte_reader_get_remaining (parser) < off_size))
    return FALSE;

  if (off_size == sizeof (guint64)) {
    *val = gst_byte_reader_get_uint64_be_unchecked (parser);
  } else {
    *val = gst_byte_reader_get_uint32_be_unchecked (parser);
  }
  return TRUE;
}

/* off_size must be either 4 or 8 */
static inline guint64
qt_atom_parser_get_offset_unchecked (GstByteReader * parser, guint off_size)
{
  if (off_size == sizeof (guint64)) {
    return gst_byte_reader_get_uint64_be_unchecked (parser);
  } else {
    return gst_byte_reader_get_uint32_be_unchecked (parser);
  }
}

/* size must be from 1 to 4 */
static inline guint32
qt_atom_parser_get_uint_with_size_unchecked (GstByteReader * parser,
    guint size)
{
  switch (size) {
  case 1:
    return gst_byte_reader_get_uint8_unchecked (parser);
  case 2:
    return gst_byte_reader_get_uint16_be_unchecked (parser);
  case 3:
    return gst_byte_reader_get_uint24_be_unchecked (parser);
  case 4:
    return gst_byte_reader_get_uint32_be_unchecked (parser);
  default:
    g_assert_not_reached ();
    gst_byte_reader_skip_unchecked (parser, size);
    break;
  }
  return 0;
}

static inline gboolean
qt_atom_parser_get_fourcc (GstByteReader * parser, guint32 * fourcc)
{
  guint32 f_be;

  if (G_UNLIKELY (gst_byte_reader_get_remaining (parser) < 4))
    return FALSE;

  f_be = gst_byte_reader_get_uint32_be_unchecked (parser);
  *fourcc = GUINT32_SWAP_LE_BE (f_be);
  return TRUE;
}

static inline guint32
qt_atom_parser_get_fourcc_unchecked (GstByteReader * parser)
{
  guint32 fourcc;

  fourcc = gst_byte_reader_get_uint32_be_unchecked (parser);
  return GUINT32_SWAP_LE_BE (fourcc);
}

#endif /* QT_ATOM_PARSER_H */
