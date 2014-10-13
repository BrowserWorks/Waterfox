/* GStreamer byte writer dummy header for gtk-doc
 * Copyright (C) 2010 Sebastian Dröge <sebastian.droege@collabora.co.uk>
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
 * inline functions we generate via macros in gstbitreader.h.
 */

#error "This header should never be included in code, it is only for gtk-doc"

/**
 * gst_byte_writer_put_uint8_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a unsigned 8 bit integer to @writer without checking if there
 * is enough free space available in the byte writer.
 */
void gst_byte_writer_put_uint8_unchecked (GstByteWriter *writer, guint8 val);

/**
 * gst_byte_writer_put_uint16_be_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a unsigned big endian 16 bit integer to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_uint16_be_unchecked (GstByteWriter *writer, guint16 val);

/**
 * gst_byte_writer_put_uint24_be_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a unsigned big endian 24 bit integer to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_uint24_be_unchecked (GstByteWriter *writer, guint32 val);

/**
 * gst_byte_writer_put_uint32_be_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a unsigned big endian 32 bit integer to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_uint32_be_unchecked (GstByteWriter *writer, guint32 val);

/**
 * gst_byte_writer_put_uint64_be_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a unsigned big endian 64 bit integer to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_uint64_be_unchecked (GstByteWriter *writer, guint64 val);

/**
 * gst_byte_writer_put_uint16_le_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a unsigned little endian 16 bit integer to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_uint16_le_unchecked (GstByteWriter *writer, guint16 val);

/**
 * gst_byte_writer_put_uint24_le_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a unsigned little endian 24 bit integer to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_uint24_le_unchecked (GstByteWriter *writer, guint32 val);

/**
 * gst_byte_writer_put_uint32_le_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a unsigned little endian 32 bit integer to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_uint32_le_unchecked (GstByteWriter *writer, guint32 val);

/**
 * gst_byte_writer_put_uint64_le_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a unsigned little endian 64 bit integer to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_uint64_le_unchecked (GstByteWriter *writer, guint64 val);

/**
 * gst_byte_writer_put_int8:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a signed 8 bit integer to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_int8_unchecked (GstByteWriter *writer, gint8 val);

/**
 * gst_byte_writer_put_int16_be_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a signed big endian 16 bit integer to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_int16_be_unchecked (GstByteWriter *writer, gint16 val);

/**
 * gst_byte_writer_put_int24_be_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a signed big endian 24 bit integer to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_int24_be_unchecked (GstByteWriter *writer, gint32 val);

/**
 * gst_byte_writer_put_int32_be_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a signed big endian 32 bit integer to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_int32_be_unchecked (GstByteWriter *writer, gint32 val);

/**
 * gst_byte_writer_put_int64_be_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a signed big endian 64 bit integer to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_int64_be_unchecked (GstByteWriter *writer, gint64 val);

/**
 * gst_byte_writer_put_int16_le_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a signed little endian 16 bit integer to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_int16_le_unchecked (GstByteWriter *writer, gint16 val);

/**
 * gst_byte_writer_put_int24_le_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a signed little endian 24 bit integer to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_int24_le_unchecked (GstByteWriter *writer, gint32 val);

/**
 * gst_byte_writer_put_int32_le_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a signed little endian 32 bit integer to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_int32_le_unchecked (GstByteWriter *writer, gint32 val);

/**
 * gst_byte_writer_put_int64_le_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a signed little endian 64 bit integer to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_int64_le_unchecked (GstByteWriter *writer, gint64 val);

/**
 * gst_byte_writer_put_float32_be_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a big endian 32 bit float to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_float32_be_unchecked (GstByteWriter *writer, gfloat val);

/**
 * gst_byte_writer_put_float64_be_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a big endian 64 bit float to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_float64_be_unchecked (GstByteWriter *writer, gdouble val);

/**
 * gst_byte_writer_put_float32_le_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a little endian 32 bit float to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_float32_le_unchecked (GstByteWriter *writer, gfloat val);

/**
 * gst_byte_writer_put_float64_le_unchecked:
 * @writer: #GstByteWriter instance
 * @val: Value to write
 *
 * Writes a little endian 64 bit float to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_float64_le_unchecked (GstByteWriter *writer, gdouble val);

/**
 * gst_byte_writer_put_data_unchecked:
 * @writer: #GstByteWriter instance
 * @data: (in) (transfer none) (array length=size): Data to write
 * @size: Size of @data in bytes
 *
 * Writes @size bytes of @data to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_put_data_unchecked (GstByteWriter *writer, const guint8 *data, guint size);

/**
 * gst_byte_writer_fill_unchecked:
 * @writer: #GstByteWriter instance
 * @value: Value to be written
 * @size: Number of bytes to be written

 *
 * Writes @size bytes containing @value to @writer without
 * checking if there is enough free space available in the byte writer.
 */
void gst_byte_writer_fill_unchecked (GstByteWriter *writer, guint8 value, guint size);

