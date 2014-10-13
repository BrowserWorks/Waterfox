/* GStreamer byte reader dummy header for gtk-doc
 * Copyright (C) 2009 Tim-Philipp Müller <tim centricular net>
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

/* This header is not installed, it just contains stuff for gtk-doc to parse,
 * in particular docs and some dummy function declarations for the static
 * inline functions we generate via macros in gstbytereader.h.
 */

#error "This header should never be included in code, it is only for gtk-doc"

/**
 * gst_byte_reader_skip_unchecked:
 * @reader: a #GstByteReader instance
 * @nbytes: the number of bytes to skip
 *
 * Skips @nbytes bytes of the #GstByteReader instance without checking if
 * there are enough bytes available in the byte reader.
 */
void gst_byte_reader_skip_unchecked (GstByteReader * reader, guint nbytes);

/**
 * gst_byte_reader_get_uint8_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an unsigned 8 bit integer without checking if there are enough bytes
 * available in the byte reader and update the current position.
 *
 * Returns: unsigned 8 bit integer.
 */
/**
 * gst_byte_reader_peek_uint8_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an unsigned 8 bit integer without checking if there are enough bytes
 * available in the byte reader, but do not advance the current read position.
 *
 * Returns: unsigned 8 bit integer.
 */
/**
 * gst_byte_reader_get_int8_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an signed 8 bit integer without checking if there are enough bytes
 * available in the byte reader and update the current position.
 *
 * Returns: signed 8 bit integer.
 */
/**
 * gst_byte_reader_peek_int8_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an signed 8 bit integer without checking if there are enough bytes
 * available in the byte reader, but do not advance the current read position.
 *
 * Returns: signed 8 bit integer.
 */
guint8  gst_byte_reader_get_uint8_unchecked     (GstByteReader * reader);
guint8  gst_byte_reader_peek_uint8_unchecked    (GstByteReader * reader);
gint8   gst_byte_reader_get_int8_unchecked      (GstByteReader * reader);
gint8   gst_byte_reader_peek_int8_unchecked     (GstByteReader * reader);

/**
 * gst_byte_reader_get_uint16_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an unsigned 16 bit integer in little endian format without checking
 * if there are enough bytes available in the byte reader and update the
 * current position.
 *
 * Returns: unsigned 16 bit integer.
 */
/**
 * gst_byte_reader_peek_uint16_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an unsigned 16 bit integer in little endian format without checking
 * if there are enough bytes available in the byte reader, but do not advance
 * the current position.
 *
 * Returns: unsigned 16 bit integer.
 */
/**
 * gst_byte_reader_get_uint16_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an unsigned 16 bit integer in big endian format without checking
 * if there are enough bytes available in the byte reader and update the
 * current position.
 *
 * Returns: unsigned 16 bit integer.
 */
/**
 * gst_byte_reader_peek_uint16_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an unsigned 16 bit integer in big endian format without checking
 * if there are enough bytes available in the byte reader, but do not advance
 * the current position.
 *
 * Returns: unsigned 16 bit integer.
 */
/**
 * gst_byte_reader_get_int16_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a signed 16 bit integer in little endian format without checking
 * if there are enough bytes available in the byte reader and update the
 * current position.
 *
 * Returns: signed 16 bit integer.
 */
/**
 * gst_byte_reader_peek_int16_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a signed 16 bit integer in little endian format without checking
 * if there are enough bytes available in the byte reader, but do not advance
 * the current position.
 *
 * Returns: signed 16 bit integer.
 */
/**
 * gst_byte_reader_get_int16_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a signed 16 bit integer in big endian format without checking
 * if there are enough bytes available in the byte reader and update the
 * current position.
 *
 * Returns: signed 16 bit integer.
 */
/**
 * gst_byte_reader_peek_int16_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a signed 16 bit integer in big endian format without checking
 * if there are enough bytes available in the byte reader, but do not advance
 * the current position.
 *
 * Returns: signed 16 bit integer.
 */
guint16 gst_byte_reader_get_uint16_le_unchecked  (GstByteReader * reader);
guint16 gst_byte_reader_get_uint16_be_unchecked  (GstByteReader * reader);
guint16 gst_byte_reader_peek_uint16_le_unchecked (GstByteReader * reader);
guint16 gst_byte_reader_peek_uint16_be_unchecked (GstByteReader * reader);
gint16  gst_byte_reader_get_int16_le_unchecked   (GstByteReader * reader);
gint16  gst_byte_reader_get_int16_be_unchecked   (GstByteReader * reader);
gint16  gst_byte_reader_peek_int16_le_unchecked  (GstByteReader * reader);
gint16  gst_byte_reader_peek_int16_be_unchecked  (GstByteReader * reader);

/**
 * gst_byte_reader_get_uint24_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an unsigned 24 bit integer in little endian format without checking
 * if there are enough bytes available in the byte reader and update the
 * current position.
 *
 * Returns: unsigned 24 bit integer (as guint32)
 */
/**
 * gst_byte_reader_peek_uint24_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an unsigned 24 bit integer in little endian format without checking
 * if there are enough bytes available in the byte reader, but do not advance
 * the current position.
 *
 * Returns: unsigned 24 bit integer (as guint32)
 */
/**
 * gst_byte_reader_get_uint24_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an unsigned 24 bit integer in big endian format without checking
 * if there are enough bytes available in the byte reader and update the
 * current position.
 *
 * Returns: unsigned 24 bit integer (as guint32)
 */
/**
 * gst_byte_reader_peek_uint24_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an unsigned 24 bit integer in big endian format without checking
 * if there are enough bytes available in the byte reader, but do not advance
 * the current position.
 *
 * Returns: unsigned 24 bit integer (as guint32)
 */
/**
 * gst_byte_reader_get_int24_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a signed 24 bit integer in little endian format without checking
 * if there are enough bytes available in the byte reader and update the
 * current position.
 *
 * Returns: signed 24 bit integer (as gint32)
 */
/**
 * gst_byte_reader_peek_int24_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a signed 24 bit integer in little endian format without checking
 * if there are enough bytes available in the byte reader, but do not advance
 * the current position.
 *
 * Returns: signed 24 bit integer (as gint32)
 */
/**
 * gst_byte_reader_get_int24_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a signed 24 bit integer in big endian format without checking
 * if there are enough bytes available in the byte reader and update the
 * current position.
 *
 * Returns: signed 24 bit integer (as gint32)
 */
/**
 * gst_byte_reader_peek_int24_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a signed 24 bit integer in big endian format without checking
 * if there are enough bytes available in the byte reader, but do not advance
 * the current position.
 *
 * Returns: signed 24 bit integer (as gint32)
 */
guint32 gst_byte_reader_get_uint24_le_unchecked  (GstByteReader * reader);
guint32 gst_byte_reader_get_uint24_be_unchecked  (GstByteReader * reader);
guint32 gst_byte_reader_peek_uint24_le_unchecked (GstByteReader * reader);
guint32 gst_byte_reader_peek_uint24_be_unchecked (GstByteReader * reader);
gint32  gst_byte_reader_get_int24_le_unchecked   (GstByteReader * reader);
gint32  gst_byte_reader_get_int24_be_unchecked   (GstByteReader * reader);
gint32  gst_byte_reader_peek_int24_le_unchecked  (GstByteReader * reader);
gint32  gst_byte_reader_peek_int24_be_unchecked  (GstByteReader * reader);

/**
 * gst_byte_reader_get_uint32_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an unsigned 32 bit integer in little endian format without checking
 * if there are enough bytes available in the byte reader and update the
 * current position.
 *
 * Returns: unsigned 32 bit integer.
 */
/**
 * gst_byte_reader_peek_uint32_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an unsigned 32 bit integer in little endian format without checking
 * if there are enough bytes available in the byte reader, but do not advance
 * the current position.
 *
 * Returns: unsigned 32 bit integer.
 */
/**
 * gst_byte_reader_get_uint32_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an unsigned 32 bit integer in big endian format without checking
 * if there are enough bytes available in the byte reader and update the
 * current position.
 *
 * Returns: unsigned 32 bit integer.
 */
/**
 * gst_byte_reader_peek_uint32_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an unsigned 32 bit integer in big endian format without checking
 * if there are enough bytes available in the byte reader, but do not advance
 * the current position.
 *
 * Returns: unsigned 32 bit integer.
 */
/**
 * gst_byte_reader_get_int32_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a signed 32 bit integer in little endian format without checking
 * if there are enough bytes available in the byte reader and update the
 * current position.
 *
 * Returns: signed 32 bit integer.
 */
/**
 * gst_byte_reader_peek_int32_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a signed 32 bit integer in little endian format without checking
 * if there are enough bytes available in the byte reader, but do not advance
 * the current position.
 *
 * Returns: signed 32 bit integer.
 */
/**
 * gst_byte_reader_get_int32_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a signed 32 bit integer in big endian format without checking
 * if there are enough bytes available in the byte reader and update the
 * current position.
 *
 * Returns: signed 32 bit integer.
 */
/**
 * gst_byte_reader_peek_int32_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a signed 32 bit integer in big endian format without checking
 * if there are enough bytes available in the byte reader, but do not advance
 * the current position.
 *
 * Returns: signed 32 bit integer.
 */
guint32 gst_byte_reader_get_uint32_le_unchecked  (GstByteReader * reader);
guint32 gst_byte_reader_get_uint32_be_unchecked  (GstByteReader * reader);
guint32 gst_byte_reader_peek_uint32_le_unchecked (GstByteReader * reader);
guint32 gst_byte_reader_peek_uint32_be_unchecked (GstByteReader * reader);
gint32  gst_byte_reader_get_int32_le_unchecked   (GstByteReader * reader);
gint32  gst_byte_reader_get_int32_be_unchecked   (GstByteReader * reader);
gint32  gst_byte_reader_peek_int32_le_unchecked  (GstByteReader * reader);
gint32  gst_byte_reader_peek_int32_be_unchecked  (GstByteReader * reader);

/**
 * gst_byte_reader_get_uint64_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an unsigned 64 bit integer in little endian format without checking
 * if there are enough bytes available in the byte reader and update the
 * current position.
 *
 * Returns: unsigned 64 bit integer.
 */
/**
 * gst_byte_reader_peek_uint64_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an unsigned 64 bit integer in little endian format without checking
 * if there are enough bytes available in the byte reader, but do not advance
 * the current position.
 *
 * Returns: unsigned 64 bit integer.
 */
/**
 * gst_byte_reader_get_uint64_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an unsigned 64 bit integer in big endian format without checking
 * if there are enough bytes available in the byte reader and update the
 * current position.
 *
 * Returns: unsigned 64 bit integer.
 */
/**
 * gst_byte_reader_peek_uint64_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read an unsigned 64 bit integer in big endian format without checking
 * if there are enough bytes available in the byte reader, but do not advance
 * the current position.
 *
 * Returns: unsigned 64 bit integer.
 */
/**
 * gst_byte_reader_get_int64_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a signed 64 bit integer in little endian format without checking
 * if there are enough bytes available in the byte reader and update the
 * current position.
 *
 * Returns: signed 64 bit integer.
 */
/**
 * gst_byte_reader_peek_int64_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a signed 64 bit integer in little endian format without checking
 * if there are enough bytes available in the byte reader, but do not advance
 * the current position.
 *
 * Returns: signed 64 bit integer.
 */
/**
 * gst_byte_reader_get_int64_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a signed 64 bit integer in big endian format without checking
 * if there are enough bytes available in the byte reader and update the
 * current position.
 *
 * Returns: signed 64 bit integer.
 */
/**
 * gst_byte_reader_peek_int64_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a signed 64 bit integer in big endian format without checking
 * if there are enough bytes available in the byte reader, but do not advance
 * the current position.
 *
 * Returns: signed 64 bit integer.
 */
guint64 gst_byte_reader_get_uint64_le_unchecked  (GstByteReader * reader);
guint64 gst_byte_reader_get_uint64_be_unchecked  (GstByteReader * reader);
guint64 gst_byte_reader_peek_uint64_le_unchecked (GstByteReader * reader);
guint64 gst_byte_reader_peek_uint64_be_unchecked (GstByteReader * reader);
gint64  gst_byte_reader_get_int64_le_unchecked   (GstByteReader * reader);
gint64  gst_byte_reader_get_int64_be_unchecked   (GstByteReader * reader);
gint64  gst_byte_reader_peek_int64_le_unchecked  (GstByteReader * reader);
gint64  gst_byte_reader_peek_int64_be_unchecked  (GstByteReader * reader);

/**
 * gst_byte_reader_get_float32_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a 32 bit little endian float without checking if there is enough
 * data available and update the current position.
 *
 * Returns: floating point value read
 */
/**
 * gst_byte_reader_peek_float32_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a 32 bit little endian float without checking if there is enough
 * data available, but keep the current position.
 *
 * Returns: floating point value read
 */
/**
 * gst_byte_reader_get_float32_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a 32 bit big endian float without checking if there is enough
 * data available and update the current position.
 *
 * Returns: floating point value read
 */
/**
 * gst_byte_reader_peek_float32_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a 32 bit big endian float without checking if there is enough
 * data available, but keep the current position.
 *
 * Returns: floating point value read
 */
/**
 * gst_byte_reader_get_float64_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a 64 bit little endian float without checking if there is enough
 * data available and update the current position.
 *
 * Returns: double precision floating point value read
 */
/**
 * gst_byte_reader_peek_float64_le_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a 64 bit little endian float without checking if there is enough
 * data available, but keep the current position.
 *
 * Returns: double precision floating point value read
 */
/**
 * gst_byte_reader_get_float64_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a 64 bit big endian float without checking if there is enough
 * data available and update the current position.
 *
 * Returns: double precision floating point value read
 */
/**
 * gst_byte_reader_peek_float64_be_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Read a 64 bit big endian float without checking if there is enough
 * data available, but keep the current position.
 *
 * Returns: double precision floating point value read
 */

gfloat  gst_byte_reader_get_float32_le_unchecked  (GstByteReader * reader);
gfloat  gst_byte_reader_get_float32_be_unchecked  (GstByteReader * reader);
gdouble gst_byte_reader_get_float64_le_unchecked  (GstByteReader * reader);
gdouble gst_byte_reader_get_float64_be_unchecked  (GstByteReader * reader);

gfloat  gst_byte_reader_peek_float32_le_unchecked (GstByteReader * reader);
gfloat  gst_byte_reader_peek_float32_be_unchecked (GstByteReader * reader);
gdouble gst_byte_reader_peek_float64_le_unchecked (GstByteReader * reader);
gdouble gst_byte_reader_peek_float64_be_unchecked (GstByteReader * reader);

/**
 * gst_byte_reader_peek_data_unchecked:
 * @reader: a #GstByteReader instance
 *
 * Returns: (transfer none): a constant pointer to the current data position
 */
const guint8 * gst_byte_reader_peek_data_unchecked (GstByteReader * reader);
/**
 * gst_byte_reader_get_data_unchecked:
 * @reader: a #GstByteReader instance
 * @size: Size in bytes
 *
 * Returns a constant pointer to the current data position without checking
 * if at least @size bytes are left. Advances the current read position by
 * @size bytes.
 *
 * Returns: (transfer none) (array length=size): a constant pointer to the
 *     current data position.
 */
const guint8 * gst_byte_reader_get_data_unchecked (GstByteReader * reader, guint size);
/**
 * gst_byte_reader_dup_data_unchecked:
 * @reader: a #GstByteReader instance
 * @size: Size in bytes
 *
 * Returns a newly-allocated copy of the data at the current data position
 * without checking if at least @size bytes are left. Advances the current read
 * position by @size bytes.
 *
 * Free-function: g_free
 *
 * Returns: (transfer full) (array length=size): a newly-allocated copy of the
 *     data @size bytes in size. Free with g_free() when no longer needed.
 */
guint8 * gst_byte_reader_dup_data_unchecked (GstByteReader * reader, guint size);

