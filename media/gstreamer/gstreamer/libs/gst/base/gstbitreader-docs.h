/* GStreamer bit reader dummy header for gtk-doc
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
 * gst_bit_reader_skip_unchecked:
 * @reader: a #GstBitReader instance
 * @nbits: the number of bits to skip
 *
 * Skips @nbits bits of the #GstBitReader instance without checking if there
 * are enough bits available in the bit reader.
 */
void gst_bit_reader_skip_unchecked (GstBitReader * reader, guint nbits);

/**
 * gst_bit_reader_skip_to_byte_unchecked:
 * @reader: a #GstBitReader instance
 *
 * Skips until the next byte without checking if there are enough bits
 * available in the bit reader.
 */
void gst_bit_reader_skip_to_byte_unchecked (GstBitReader * reader);

/**
 * gst_bit_reader_get_bits_uint8_unchecked:
 * @reader: a #GstBitReader instance
 * @nbits: number of bits to read
 *
 * Read @nbits bits into @val and update the current position without
 * checking if there are enough bits available in the bit reader.
 *
 * Returns: unsigned 8 bit integer with the bits.
 */
guint8 gst_bit_reader_get_bits_uint8_unchecked (GstBitReader *reader, guint nbits);

/**
 * gst_bit_reader_peek_bits_uint8_unchecked:
 * @reader: a #GstBitReader instance
 * @nbits: number of bits to read
 *
 * Read @nbits bits into @val but keep the current position without
 * checking if there are enough bits available in the bit reader
 *
 * Returns: unsigned 8 bit integer with the bits.
 */
guint8 gst_bit_reader_peek_bits_uint8_unchecked (const GstBitReader *reader, guint nbits);

/**
 * gst_bit_reader_get_bits_uint16_unchecked:
 * @reader: a #GstBitReader instance
 * @nbits: number of bits to read
 *
 * Read @nbits bits into @val and update the current position without
 * checking if there are enough bits available in the bit reader.
 *
 * Returns: unsigned 16 bit integer with the bits.
 */
guint16 gst_bit_reader_get_bits_uint16_unchecked (GstBitReader *reader, guint nbits);

/**
 * gst_bit_reader_peek_bits_uint16_unchecked:
 * @reader: a #GstBitReader instance
 * @nbits: number of bits to read
 *
 * Read @nbits bits into @val but keep the current position without
 * checking if there are enough bits available in the bit reader
 *
 * Returns: unsigned 16 bit integer with the bits.
 */
guint16 gst_bit_reader_peek_bits_uint16_unchecked (const GstBitReader *reader, guint nbits);

/**
 * gst_bit_reader_get_bits_uint32_unchecked:
 * @reader: a #GstBitReader instance
 * @nbits: number of bits to read
 *
 * Read @nbits bits into @val and update the current position without
 * checking if there are enough bits available in the bit reader.
 *
 * Returns: unsigned 32 bit integer with the bits.
 */
guint32 gst_bit_reader_get_bits_uint32_unchecked (GstBitReader *reader, guint nbits);

/**
 * gst_bit_reader_peek_bits_uint32_unchecked:
 * @reader: a #GstBitReader instance
 * @nbits: number of bits to read
 *
 * Read @nbits bits into @val but keep the current position without
 * checking if there are enough bits available in the bit reader
 *
 * Returns: unsigned 32 bit integer with the bits.
 */
guint32 gst_bit_reader_peek_bits_uint32_unchecked (const GstBitReader *reader, guint nbits);

/**
 * gst_bit_reader_get_bits_uint64_unchecked:
 * @reader: a #GstBitReader instance
 * @nbits: number of bits to read
 *
 * Read @nbits bits into @val and update the current position without
 * checking if there are enough bits available in the bit reader.
 *
 * Returns: unsigned 64 bit integer with the bits.
 */
guint64 gst_bit_reader_get_bits_uint64_unchecked (GstBitReader *reader, guint nbits);

/**
 * gst_bit_reader_peek_bits_uint64_unchecked:
 * @reader: a #GstBitReader instance
 * @nbits: number of bits to read
 *
 * Read @nbits bits into @val but keep the current position without
 * checking if there are enough bits available in the bit reader
 *
 * Returns: unsigned 64 bit integer with the bits.
 */
guint64 gst_bit_reader_peek_bits_uint64_unchecked (const GstBitReader *reader, guint nbits);

