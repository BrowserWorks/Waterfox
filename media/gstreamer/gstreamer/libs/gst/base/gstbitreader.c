/* GStreamer
 *
 * Copyright (C) 2008 Sebastian Dröge <sebastian.droege@collabora.co.uk>.
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

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#define GST_BIT_READER_DISABLE_INLINES
#include "gstbitreader.h"

#include <string.h>

/**
 * SECTION:gstbitreader
 * @short_description: Reads any number of bits from a memory buffer
 *
 * #GstBitReader provides a bit reader that can read any number of bits
 * from a memory buffer. It provides functions for reading any number of bits
 * into 8, 16, 32 and 64 bit variables.
 */

/**
 * gst_bit_reader_new:
 * @data: (array length=size): Data from which the #GstBitReader
 *   should read
 * @size: Size of @data in bytes
 *
 * Create a new #GstBitReader instance, which will read from @data.
 *
 * Free-function: gst_bit_reader_free
 *
 * Returns: (transfer full): a new #GstBitReader instance
 */
GstBitReader *
gst_bit_reader_new (const guint8 * data, guint size)
{
  GstBitReader *ret = g_slice_new0 (GstBitReader);

  ret->data = data;
  ret->size = size;

  return ret;
}

/**
 * gst_bit_reader_free:
 * @reader: (in) (transfer full): a #GstBitReader instance
 *
 * Frees a #GstBitReader instance, which was previously allocated by
 * gst_bit_reader_new().
 */
void
gst_bit_reader_free (GstBitReader * reader)
{
  g_return_if_fail (reader != NULL);

  g_slice_free (GstBitReader, reader);
}

/**
 * gst_bit_reader_init:
 * @reader: a #GstBitReader instance
 * @data: (in) (array length=size): data from which the bit reader should read
 * @size: Size of @data in bytes
 *
 * Initializes a #GstBitReader instance to read from @data. This function
 * can be called on already initialized instances.
 */
void
gst_bit_reader_init (GstBitReader * reader, const guint8 * data, guint size)
{
  g_return_if_fail (reader != NULL);

  reader->data = data;
  reader->size = size;
  reader->byte = reader->bit = 0;
}

/**
 * gst_bit_reader_set_pos:
 * @reader: a #GstBitReader instance
 * @pos: The new position in bits
 *
 * Sets the new position of a #GstBitReader instance to @pos in bits.
 *
 * Returns: %TRUE if the position could be set successfully, %FALSE
 * otherwise.
 */
gboolean
gst_bit_reader_set_pos (GstBitReader * reader, guint pos)
{
  g_return_val_if_fail (reader != NULL, FALSE);

  if (pos > reader->size * 8)
    return FALSE;

  reader->byte = pos / 8;
  reader->bit = pos % 8;

  return TRUE;
}

/**
 * gst_bit_reader_get_pos:
 * @reader: a #GstBitReader instance
 *
 * Returns the current position of a #GstBitReader instance in bits.
 *
 * Returns: The current position of @reader in bits.
 */
guint
gst_bit_reader_get_pos (const GstBitReader * reader)
{
  return _gst_bit_reader_get_pos_inline (reader);
}

/**
 * gst_bit_reader_get_remaining:
 * @reader: a #GstBitReader instance
 *
 * Returns the remaining number of bits of a #GstBitReader instance.
 *
 * Returns: The remaining number of bits of @reader instance.
 */
guint
gst_bit_reader_get_remaining (const GstBitReader * reader)
{
  return _gst_bit_reader_get_remaining_inline (reader);
}

/**
 * gst_bit_reader_get_size:
 * @reader: a #GstBitReader instance
 *
 * Returns the total number of bits of a #GstBitReader instance.
 *
 * Returns: The total number of bits of @reader instance.
 */
guint
gst_bit_reader_get_size (const GstBitReader * reader)
{
  return _gst_bit_reader_get_size_inline (reader);
}

/**
 * gst_bit_reader_skip:
 * @reader: a #GstBitReader instance
 * @nbits: the number of bits to skip
 *
 * Skips @nbits bits of the #GstBitReader instance.
 *
 * Returns: %TRUE if @nbits bits could be skipped, %FALSE otherwise.
 */
gboolean
gst_bit_reader_skip (GstBitReader * reader, guint nbits)
{
  return _gst_bit_reader_skip_inline (reader, nbits);
}

/**
 * gst_bit_reader_skip_to_byte:
 * @reader: a #GstBitReader instance
 *
 * Skips until the next byte.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */
gboolean
gst_bit_reader_skip_to_byte (GstBitReader * reader)
{
  return _gst_bit_reader_skip_to_byte_inline (reader);
}

/**
 * gst_bit_reader_get_bits_uint8:
 * @reader: a #GstBitReader instance
 * @val: (out): Pointer to a #guint8 to store the result
 * @nbits: number of bits to read
 *
 * Read @nbits bits into @val and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_bit_reader_get_bits_uint16:
 * @reader: a #GstBitReader instance
 * @val: (out): Pointer to a #guint16 to store the result
 * @nbits: number of bits to read
 *
 * Read @nbits bits into @val and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_bit_reader_get_bits_uint32:
 * @reader: a #GstBitReader instance
 * @val: (out): Pointer to a #guint32 to store the result
 * @nbits: number of bits to read
 *
 * Read @nbits bits into @val and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_bit_reader_get_bits_uint64:
 * @reader: a #GstBitReader instance
 * @val: (out): Pointer to a #guint64 to store the result
 * @nbits: number of bits to read
 *
 * Read @nbits bits into @val and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_bit_reader_peek_bits_uint8:
 * @reader: a #GstBitReader instance
 * @val: (out): Pointer to a #guint8 to store the result
 * @nbits: number of bits to read
 *
 * Read @nbits bits into @val but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_bit_reader_peek_bits_uint16:
 * @reader: a #GstBitReader instance
 * @val: (out): Pointer to a #guint16 to store the result
 * @nbits: number of bits to read
 *
 * Read @nbits bits into @val but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_bit_reader_peek_bits_uint32:
 * @reader: a #GstBitReader instance
 * @val: (out): Pointer to a #guint32 to store the result
 * @nbits: number of bits to read
 *
 * Read @nbits bits into @val but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_bit_reader_peek_bits_uint64:
 * @reader: a #GstBitReader instance
 * @val: (out): Pointer to a #guint64 to store the result
 * @nbits: number of bits to read
 *
 * Read @nbits bits into @val but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

#define GST_BIT_READER_READ_BITS(bits) \
gboolean \
gst_bit_reader_peek_bits_uint##bits (const GstBitReader *reader, guint##bits *val, guint nbits) \
{ \
  return _gst_bit_reader_peek_bits_uint##bits##_inline (reader, val, nbits); \
} \
\
gboolean \
gst_bit_reader_get_bits_uint##bits (GstBitReader *reader, guint##bits *val, guint nbits) \
{ \
  return _gst_bit_reader_get_bits_uint##bits##_inline (reader, val, nbits); \
}

GST_BIT_READER_READ_BITS (8);
GST_BIT_READER_READ_BITS (16);
GST_BIT_READER_READ_BITS (32);
GST_BIT_READER_READ_BITS (64);
