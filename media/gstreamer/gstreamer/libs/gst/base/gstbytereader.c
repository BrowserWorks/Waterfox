/* GStreamer byte reader
 *
 * Copyright (C) 2008 Sebastian Dröge <sebastian.droege@collabora.co.uk>.
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

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#define GST_BYTE_READER_DISABLE_INLINES
#include "gstbytereader.h"

#include <string.h>

/**
 * SECTION:gstbytereader
 * @short_description: Reads different integer, string and floating point
 *     types from a memory buffer
 *
 * #GstByteReader provides a byte reader that can read different integer and
 * floating point types from a memory buffer. It provides functions for reading
 * signed/unsigned, little/big endian integers of 8, 16, 24, 32 and 64 bits
 * and functions for reading little/big endian floating points numbers of
 * 32 and 64 bits. It also provides functions to read NUL-terminated strings
 * in various character encodings.
 */

/**
 * gst_byte_reader_new:
 * @data: (in) (transfer none) (array length=size): data from which the
 *     #GstByteReader should read
 * @size: Size of @data in bytes
 *
 * Create a new #GstByteReader instance, which will read from @data.
 *
 * Free-function: gst_byte_reader_free
 *
 * Returns: (transfer full): a new #GstByteReader instance
 */
GstByteReader *
gst_byte_reader_new (const guint8 * data, guint size)
{
  GstByteReader *ret = g_slice_new0 (GstByteReader);

  ret->data = data;
  ret->size = size;

  return ret;
}

/**
 * gst_byte_reader_free:
 * @reader: (in) (transfer full): a #GstByteReader instance
 *
 * Frees a #GstByteReader instance, which was previously allocated by
 * gst_byte_reader_new().
 */
void
gst_byte_reader_free (GstByteReader * reader)
{
  g_return_if_fail (reader != NULL);

  g_slice_free (GstByteReader, reader);
}

/**
 * gst_byte_reader_init:
 * @reader: a #GstByteReader instance
 * @data: (in) (transfer none) (array length=size): data from which
 *     the #GstByteReader should read
 * @size: Size of @data in bytes
 *
 * Initializes a #GstByteReader instance to read from @data. This function
 * can be called on already initialized instances.
 */
void
gst_byte_reader_init (GstByteReader * reader, const guint8 * data, guint size)
{
  g_return_if_fail (reader != NULL);

  reader->data = data;
  reader->size = size;
  reader->byte = 0;
}

/**
 * gst_byte_reader_set_pos:
 * @reader: a #GstByteReader instance
 * @pos: The new position in bytes
 *
 * Sets the new position of a #GstByteReader instance to @pos in bytes.
 *
 * Returns: %TRUE if the position could be set successfully, %FALSE
 * otherwise.
 */
gboolean
gst_byte_reader_set_pos (GstByteReader * reader, guint pos)
{
  g_return_val_if_fail (reader != NULL, FALSE);

  if (pos > reader->size)
    return FALSE;

  reader->byte = pos;

  return TRUE;
}

/**
 * gst_byte_reader_get_pos:
 * @reader: a #GstByteReader instance
 *
 * Returns the current position of a #GstByteReader instance in bytes.
 *
 * Returns: The current position of @reader in bytes.
 */
guint
gst_byte_reader_get_pos (const GstByteReader * reader)
{
  return _gst_byte_reader_get_pos_inline (reader);
}

/**
 * gst_byte_reader_get_remaining:
 * @reader: a #GstByteReader instance
 *
 * Returns the remaining number of bytes of a #GstByteReader instance.
 *
 * Returns: The remaining number of bytes of @reader instance.
 */
guint
gst_byte_reader_get_remaining (const GstByteReader * reader)
{
  return _gst_byte_reader_get_remaining_inline (reader);
}

/**
 * gst_byte_reader_get_size:
 * @reader: a #GstByteReader instance
 *
 * Returns the total number of bytes of a #GstByteReader instance.
 *
 * Returns: The total number of bytes of @reader instance.
 */
guint
gst_byte_reader_get_size (const GstByteReader * reader)
{
  return _gst_byte_reader_get_size_inline (reader);
}

#define gst_byte_reader_get_remaining _gst_byte_reader_get_remaining_inline
#define gst_byte_reader_get_size _gst_byte_reader_get_size_inline

/**
 * gst_byte_reader_skip:
 * @reader: a #GstByteReader instance
 * @nbytes: the number of bytes to skip
 *
 * Skips @nbytes bytes of the #GstByteReader instance.
 *
 * Returns: %TRUE if @nbytes bytes could be skipped, %FALSE otherwise.
 */
gboolean
gst_byte_reader_skip (GstByteReader * reader, guint nbytes)
{
  return _gst_byte_reader_skip_inline (reader, nbytes);
}

/**
 * gst_byte_reader_get_uint8:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #guint8 to store the result
 *
 * Read an unsigned 8 bit integer into @val and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_get_int8:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gint8 to store the result
 *
 * Read a signed 8 bit integer into @val and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_uint8:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #guint8 to store the result
 *
 * Read an unsigned 8 bit integer into @val but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_int8:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gint8 to store the result
 *
 * Read a signed 8 bit integer into @val but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_get_uint16_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #guint16 to store the result
 *
 * Read an unsigned 16 bit little endian integer into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_get_int16_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gint16 to store the result
 *
 * Read a signed 16 bit little endian integer into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_uint16_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #guint16 to store the result
 *
 * Read an unsigned 16 bit little endian integer into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_int16_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gint16 to store the result
 *
 * Read a signed 16 bit little endian integer into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_get_uint16_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #guint16 to store the result
 *
 * Read an unsigned 16 bit big endian integer into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_get_int16_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gint16 to store the result
 *
 * Read a signed 16 bit big endian integer into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_uint16_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #guint16 to store the result
 *
 * Read an unsigned 16 bit big endian integer into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_int16_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gint16 to store the result
 *
 * Read a signed 16 bit big endian integer into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_get_uint24_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #guint32 to store the result
 *
 * Read an unsigned 24 bit little endian integer into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_get_int24_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gint32 to store the result
 *
 * Read a signed 24 bit little endian integer into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_uint24_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #guint32 to store the result
 *
 * Read an unsigned 24 bit little endian integer into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_int24_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gint32 to store the result
 *
 * Read a signed 24 bit little endian integer into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_get_uint24_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #guint32 to store the result
 *
 * Read an unsigned 24 bit big endian integer into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_get_int24_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gint32 to store the result
 *
 * Read a signed 24 bit big endian integer into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_uint24_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #guint32 to store the result
 *
 * Read an unsigned 24 bit big endian integer into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_int24_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gint32 to store the result
 *
 * Read a signed 24 bit big endian integer into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */


/**
 * gst_byte_reader_get_uint32_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #guint32 to store the result
 *
 * Read an unsigned 32 bit little endian integer into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_get_int32_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gint32 to store the result
 *
 * Read a signed 32 bit little endian integer into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_uint32_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #guint32 to store the result
 *
 * Read an unsigned 32 bit little endian integer into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_int32_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gint32 to store the result
 *
 * Read a signed 32 bit little endian integer into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_get_uint32_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #guint32 to store the result
 *
 * Read an unsigned 32 bit big endian integer into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_get_int32_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gint32 to store the result
 *
 * Read a signed 32 bit big endian integer into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_uint32_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #guint32 to store the result
 *
 * Read an unsigned 32 bit big endian integer into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_int32_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gint32 to store the result
 *
 * Read a signed 32 bit big endian integer into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_get_uint64_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #guint64 to store the result
 *
 * Read an unsigned 64 bit little endian integer into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_get_int64_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gint64 to store the result
 *
 * Read a signed 64 bit little endian integer into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_uint64_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #guint64 to store the result
 *
 * Read an unsigned 64 bit little endian integer into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_int64_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gint64 to store the result
 *
 * Read a signed 64 bit little endian integer into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_get_uint64_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #guint64 to store the result
 *
 * Read an unsigned 64 bit big endian integer into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_get_int64_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gint64 to store the result
 *
 * Read a signed 64 bit big endian integer into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_uint64_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #guint64 to store the result
 *
 * Read an unsigned 64 bit big endian integer into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_int64_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gint64 to store the result
 *
 * Read a signed 64 bit big endian integer into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

#define GST_BYTE_READER_PEEK_GET(bits,type,name) \
gboolean \
gst_byte_reader_get_##name (GstByteReader * reader, type * val) \
{ \
  return _gst_byte_reader_get_##name##_inline (reader, val); \
} \
\
gboolean \
gst_byte_reader_peek_##name (const GstByteReader * reader, type * val) \
{ \
  return _gst_byte_reader_peek_##name##_inline (reader, val); \
}

/* *INDENT-OFF* */

GST_BYTE_READER_PEEK_GET(8,guint8,uint8)
GST_BYTE_READER_PEEK_GET(8,gint8,int8)

GST_BYTE_READER_PEEK_GET(16,guint16,uint16_le)
GST_BYTE_READER_PEEK_GET(16,guint16,uint16_be)
GST_BYTE_READER_PEEK_GET(16,gint16,int16_le)
GST_BYTE_READER_PEEK_GET(16,gint16,int16_be)

GST_BYTE_READER_PEEK_GET(24,guint32,uint24_le)
GST_BYTE_READER_PEEK_GET(24,guint32,uint24_be)
GST_BYTE_READER_PEEK_GET(24,gint32,int24_le)
GST_BYTE_READER_PEEK_GET(24,gint32,int24_be)

GST_BYTE_READER_PEEK_GET(32,guint32,uint32_le)
GST_BYTE_READER_PEEK_GET(32,guint32,uint32_be)
GST_BYTE_READER_PEEK_GET(32,gint32,int32_le)
GST_BYTE_READER_PEEK_GET(32,gint32,int32_be)

GST_BYTE_READER_PEEK_GET(64,guint64,uint64_le)
GST_BYTE_READER_PEEK_GET(64,guint64,uint64_be)
GST_BYTE_READER_PEEK_GET(64,gint64,int64_le)
GST_BYTE_READER_PEEK_GET(64,gint64,int64_be)

/**
 * gst_byte_reader_get_float32_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gfloat to store the result
 *
 * Read a 32 bit little endian floating point value into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_float32_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gfloat to store the result
 *
 * Read a 32 bit little endian floating point value into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_get_float32_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gfloat to store the result
 *
 * Read a 32 bit big endian floating point value into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_float32_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gfloat to store the result
 *
 * Read a 32 bit big endian floating point value into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_get_float64_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gdouble to store the result
 *
 * Read a 64 bit little endian floating point value into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_float64_le:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gdouble to store the result
 *
 * Read a 64 bit little endian floating point value into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_get_float64_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gdouble to store the result
 *
 * Read a 64 bit big endian floating point value into @val
 * and update the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

/**
 * gst_byte_reader_peek_float64_be:
 * @reader: a #GstByteReader instance
 * @val: (out): Pointer to a #gdouble to store the result
 *
 * Read a 64 bit big endian floating point value into @val
 * but keep the current position.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */

GST_BYTE_READER_PEEK_GET(32,gfloat,float32_le)
GST_BYTE_READER_PEEK_GET(32,gfloat,float32_be)
GST_BYTE_READER_PEEK_GET(64,gdouble,float64_le)
GST_BYTE_READER_PEEK_GET(64,gdouble,float64_be)

/* *INDENT-ON* */

/**
 * gst_byte_reader_get_data:
 * @reader: a #GstByteReader instance
 * @size: Size in bytes
 * @val: (out) (transfer none) (array length=size): address of a
 *     #guint8 pointer variable in which to store the result
 *
 * Returns a constant pointer to the current data
 * position if at least @size bytes are left and
 * updates the current position.
 *
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */
gboolean
gst_byte_reader_get_data (GstByteReader * reader, guint size,
    const guint8 ** val)
{
  return _gst_byte_reader_get_data_inline (reader, size, val);
}

/**
 * gst_byte_reader_peek_data:
 * @reader: a #GstByteReader instance
 * @size: Size in bytes
 * @val: (out) (transfer none) (array length=size): address of a
 *     #guint8 pointer variable in which to store the result
 *
 * Returns a constant pointer to the current data
 * position if at least @size bytes are left and
 * keeps the current position.
 *
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */
gboolean
gst_byte_reader_peek_data (const GstByteReader * reader, guint size,
    const guint8 ** val)
{
  return _gst_byte_reader_peek_data_inline (reader, size, val);
}

/**
 * gst_byte_reader_dup_data:
 * @reader: a #GstByteReader instance
 * @size: Size in bytes
 * @val: (out) (transfer full) (array length=size): address of a
 *     #guint8 pointer variable in which to store the result
 *
 * Free-function: g_free
 *
 * Returns a newly-allocated copy of the current data
 * position if at least @size bytes are left and
 * updates the current position. Free with g_free() when no longer needed.
 *
 * Returns: %TRUE if successful, %FALSE otherwise.
 */
gboolean
gst_byte_reader_dup_data (GstByteReader * reader, guint size, guint8 ** val)
{
  return _gst_byte_reader_dup_data_inline (reader, size, val);
}

/* Special optimized scan for mask 0xffffff00 and pattern 0x00000100 */
static inline gint
_scan_for_start_code (const guint8 * data, guint offset, guint size)
{
  guint8 *pdata = (guint8 *) data;
  guint8 *pend = (guint8 *) (data + size - 4);

  while (pdata <= pend) {
    if (pdata[2] > 1) {
      pdata += 3;
    } else if (pdata[1]) {
      pdata += 2;
    } else if (pdata[0] || pdata[2] != 1) {
      pdata++;
    } else {
      return (pdata - data + offset);
    }
  }

  /* nothing found */
  return -1;
}

/**
 * gst_byte_reader_masked_scan_uint32:
 * @reader: a #GstByteReader
 * @mask: mask to apply to data before matching against @pattern
 * @pattern: pattern to match (after mask is applied)
 * @offset: offset from which to start scanning, relative to the current
 *     position
 * @size: number of bytes to scan from offset
 *
 * Scan for pattern @pattern with applied mask @mask in the byte reader data,
 * starting from offset @offset relative to the current position.
 *
 * The bytes in @pattern and @mask are interpreted left-to-right, regardless
 * of endianness.  All four bytes of the pattern must be present in the
 * byte reader data for it to match, even if the first or last bytes are masked
 * out.
 *
 * It is an error to call this function without making sure that there is
 * enough data (offset+size bytes) in the byte reader.
 *
 * Returns: offset of the first match, or -1 if no match was found.
 *
 * Example:
 * <programlisting>
 * // Assume the reader contains 0x00 0x01 0x02 ... 0xfe 0xff
 *
 * gst_byte_reader_masked_scan_uint32 (reader, 0xffffffff, 0x00010203, 0, 256);
 * // -> returns 0
 * gst_byte_reader_masked_scan_uint32 (reader, 0xffffffff, 0x00010203, 1, 255);
 * // -> returns -1
 * gst_byte_reader_masked_scan_uint32 (reader, 0xffffffff, 0x01020304, 1, 255);
 * // -> returns 1
 * gst_byte_reader_masked_scan_uint32 (reader, 0xffff, 0x0001, 0, 256);
 * // -> returns -1
 * gst_byte_reader_masked_scan_uint32 (reader, 0xffff, 0x0203, 0, 256);
 * // -> returns 0
 * gst_byte_reader_masked_scan_uint32 (reader, 0xffff0000, 0x02030000, 0, 256);
 * // -> returns 2
 * gst_byte_reader_masked_scan_uint32 (reader, 0xffff0000, 0x02030000, 0, 4);
 * // -> returns -1
 * </programlisting>
 */
guint
gst_byte_reader_masked_scan_uint32 (const GstByteReader * reader, guint32 mask,
    guint32 pattern, guint offset, guint size)
{
  const guint8 *data;
  guint32 state;
  guint i;

  g_return_val_if_fail (size > 0, -1);
  g_return_val_if_fail ((guint64) offset + size <= reader->size - reader->byte,
      -1);

  /* we can't find the pattern with less than 4 bytes */
  if (G_UNLIKELY (size < 4))
    return -1;

  data = reader->data + reader->byte + offset;

  /* Handle special case found in MPEG and H264 */
  if ((pattern == 0x00000100) && (mask == 0xffffff00))
    return _scan_for_start_code (data, offset, size);

  /* set the state to something that does not match */
  state = ~pattern;

  /* now find data */
  for (i = 0; i < size; i++) {
    /* throw away one byte and move in the next byte */
    state = ((state << 8) | data[i]);
    if (G_UNLIKELY ((state & mask) == pattern)) {
      /* we have a match but we need to have skipped at
       * least 4 bytes to fill the state. */
      if (G_LIKELY (i >= 3))
        return offset + i - 3;
    }
  }

  /* nothing found */
  return -1;
}

#define GST_BYTE_READER_SCAN_STRING(bits) \
static guint \
gst_byte_reader_scan_string_utf##bits (const GstByteReader * reader) \
{ \
  guint len, off, max_len; \
  \
  max_len = (reader->size - reader->byte) / sizeof (guint##bits); \
  \
  /* need at least a single NUL terminator */ \
  if (max_len < 1) \
    return 0; \
  \
  len = 0; \
  off = reader->byte; \
  /* endianness does not matter if we are looking for a NUL terminator */ \
  while (GST_READ_UINT##bits##_LE (&reader->data[off]) != 0) { \
    ++len; \
    off += sizeof (guint##bits); \
    /* have we reached the end without finding a NUL terminator? */ \
    if (len == max_len) \
      return 0; \
  } \
  /* return size in bytes including the NUL terminator (hence the +1) */ \
  return (len + 1) * sizeof (guint##bits); \
}

#define GST_READ_UINT8_LE GST_READ_UINT8
GST_BYTE_READER_SCAN_STRING (8);
#undef GST_READ_UINT8_LE
GST_BYTE_READER_SCAN_STRING (16);
GST_BYTE_READER_SCAN_STRING (32);

#define GST_BYTE_READER_SKIP_STRING(bits) \
gboolean \
gst_byte_reader_skip_string_utf##bits (GstByteReader * reader) \
{ \
  guint size; /* size in bytes including the terminator */ \
  \
  g_return_val_if_fail (reader != NULL, FALSE); \
  \
  size = gst_byte_reader_scan_string_utf##bits (reader); \
  reader->byte += size; \
  return (size > 0); \
}

/**
 * gst_byte_reader_skip_string:
 * @reader: a #GstByteReader instance
 *
 * Skips a NUL-terminated string in the #GstByteReader instance, advancing
 * the current position to the byte after the string. This will work for
 * any NUL-terminated string with a character width of 8 bits, so ASCII,
 * UTF-8, ISO-8859-N etc.
 *
 * This function will fail if no NUL-terminator was found in in the data.
 *
 * Returns: %TRUE if a string could be skipped, %FALSE otherwise.
 */
/**
 * gst_byte_reader_skip_string_utf8:
 * @reader: a #GstByteReader instance
 *
 * Skips a NUL-terminated string in the #GstByteReader instance, advancing
 * the current position to the byte after the string. This will work for
 * any NUL-terminated string with a character width of 8 bits, so ASCII,
 * UTF-8, ISO-8859-N etc. No input checking for valid UTF-8 is done.
 *
 * This function will fail if no NUL-terminator was found in in the data.
 *
 * Returns: %TRUE if a string could be skipped, %FALSE otherwise.
 */
GST_BYTE_READER_SKIP_STRING (8);

/**
 * gst_byte_reader_skip_string_utf16:
 * @reader: a #GstByteReader instance
 *
 * Skips a NUL-terminated UTF-16 string in the #GstByteReader instance,
 * advancing the current position to the byte after the string.
 *
 * No input checking for valid UTF-16 is done.
 *
 * This function will fail if no NUL-terminator was found in in the data.
 *
 * Returns: %TRUE if a string could be skipped, %FALSE otherwise.
 */
GST_BYTE_READER_SKIP_STRING (16);

/**
 * gst_byte_reader_skip_string_utf32:
 * @reader: a #GstByteReader instance
 *
 * Skips a NUL-terminated UTF-32 string in the #GstByteReader instance,
 * advancing the current position to the byte after the string.
 *
 * No input checking for valid UTF-32 is done.
 *
 * This function will fail if no NUL-terminator was found in in the data.
 *
 * Returns: %TRUE if a string could be skipped, %FALSE otherwise.
 */
GST_BYTE_READER_SKIP_STRING (32);

/**
 * gst_byte_reader_peek_string:
 * @reader: a #GstByteReader instance
 * @str: (out) (transfer none) (array zero-terminated=1): address of a
 *     #gchar pointer variable in which to store the result
 *
 * Returns a constant pointer to the current data position if there is
 * a NUL-terminated string in the data (this could be just a NUL terminator).
 * The current position will be maintained. This will work for any
 * NUL-terminated string with a character width of 8 bits, so ASCII,
 * UTF-8, ISO-8859-N etc.
 *
 * This function will fail if no NUL-terminator was found in in the data.
 *
 * Returns: %TRUE if a string could be skipped, %FALSE otherwise.
 */
/**
 * gst_byte_reader_peek_string_utf8:
 * @reader: a #GstByteReader instance
 * @str: (out) (transfer none) (array zero-terminated=1): address of a
 *     #gchar pointer variable in which to store the result
 *
 * Returns a constant pointer to the current data position if there is
 * a NUL-terminated string in the data (this could be just a NUL terminator).
 * The current position will be maintained. This will work for any
 * NUL-terminated string with a character width of 8 bits, so ASCII,
 * UTF-8, ISO-8859-N etc.
 *
 * No input checking for valid UTF-8 is done.
 *
 * This function will fail if no NUL-terminator was found in in the data.
 *
 * Returns: %TRUE if a string could be skipped, %FALSE otherwise.
 */
gboolean
gst_byte_reader_peek_string_utf8 (const GstByteReader * reader,
    const gchar ** str)
{
  g_return_val_if_fail (reader != NULL, FALSE);
  g_return_val_if_fail (str != NULL, FALSE);

  if (gst_byte_reader_scan_string_utf8 (reader) > 0) {
    *str = (const gchar *) (reader->data + reader->byte);
  } else {
    *str = NULL;
  }
  return (*str != NULL);
}

/**
 * gst_byte_reader_get_string_utf8:
 * @reader: a #GstByteReader instance
 * @str: (out) (transfer none) (array zero-terminated=1): address of a
 *     #gchar pointer variable in which to store the result
 *
 * Returns a constant pointer to the current data position if there is
 * a NUL-terminated string in the data (this could be just a NUL terminator),
 * advancing the current position to the byte after the string. This will work
 * for any NUL-terminated string with a character width of 8 bits, so ASCII,
 * UTF-8, ISO-8859-N etc.
 *
 * No input checking for valid UTF-8 is done.
 *
 * This function will fail if no NUL-terminator was found in in the data.
 *
 * Returns: %TRUE if a string could be found, %FALSE otherwise.
 */
gboolean
gst_byte_reader_get_string_utf8 (GstByteReader * reader, const gchar ** str)
{
  guint size;                   /* size in bytes including the terminator */

  g_return_val_if_fail (reader != NULL, FALSE);
  g_return_val_if_fail (str != NULL, FALSE);

  size = gst_byte_reader_scan_string_utf8 (reader);
  if (size == 0) {
    *str = NULL;
    return FALSE;
  }

  *str = (const gchar *) (reader->data + reader->byte);
  reader->byte += size;
  return TRUE;
}

#define GST_BYTE_READER_DUP_STRING(bits,type) \
gboolean \
gst_byte_reader_dup_string_utf##bits (GstByteReader * reader, type ** str) \
{ \
  guint size; /* size in bytes including the terminator */ \
  \
  g_return_val_if_fail (reader != NULL, FALSE); \
  g_return_val_if_fail (str != NULL, FALSE); \
  \
  size = gst_byte_reader_scan_string_utf##bits (reader); \
  if (size == 0) { \
    *str = NULL; \
    return FALSE; \
  } \
  *str = g_memdup (reader->data + reader->byte, size); \
  reader->byte += size; \
  return TRUE; \
}

/**
 * gst_byte_reader_dup_string_utf8:
 * @reader: a #GstByteReader instance
 * @str: (out) (transfer full) (array zero-terminated=1): address of a
 *     #gchar pointer variable in which to store the result
 *
 * Free-function: g_free
 *
 * FIXME:Reads (copies) a NUL-terminated string in the #GstByteReader instance,
 * advancing the current position to the byte after the string. This will work
 * for any NUL-terminated string with a character width of 8 bits, so ASCII,
 * UTF-8, ISO-8859-N etc. No input checking for valid UTF-8 is done.
 *
 * This function will fail if no NUL-terminator was found in in the data.
 *
 * Returns: %TRUE if a string could be read into @str, %FALSE otherwise. The
 *     string put into @str must be freed with g_free() when no longer needed.
 */
GST_BYTE_READER_DUP_STRING (8, gchar);

/**
 * gst_byte_reader_dup_string_utf16:
 * @reader: a #GstByteReader instance
 * @str: (out) (transfer full) (array zero-terminated=1): address of a
 *     #guint16 pointer variable in which to store the result
 *
 * Free-function: g_free
 *
 * Returns a newly-allocated copy of the current data position if there is
 * a NUL-terminated UTF-16 string in the data (this could be an empty string
 * as well), and advances the current position.
 *
 * No input checking for valid UTF-16 is done. This function is endianness
 * agnostic - you should not assume the UTF-16 characters are in host
 * endianness.
 *
 * This function will fail if no NUL-terminator was found in in the data.
 *
 * Note: there is no peek or get variant of this function to ensure correct
 * byte alignment of the UTF-16 string.
 *
 * Returns: %TRUE if a string could be read, %FALSE otherwise. The
 *     string put into @str must be freed with g_free() when no longer needed.
 */
GST_BYTE_READER_DUP_STRING (16, guint16);

/**
 * gst_byte_reader_dup_string_utf32:
 * @reader: a #GstByteReader instance
 * @str: (out) (transfer full) (array zero-terminated=1): address of a
 *     #guint32 pointer variable in which to store the result
 *
 * Free-function: g_free
 *
 * Returns a newly-allocated copy of the current data position if there is
 * a NUL-terminated UTF-32 string in the data (this could be an empty string
 * as well), and advances the current position.
 *
 * No input checking for valid UTF-32 is done. This function is endianness
 * agnostic - you should not assume the UTF-32 characters are in host
 * endianness.
 *
 * This function will fail if no NUL-terminator was found in in the data.
 *
 * Note: there is no peek or get variant of this function to ensure correct
 * byte alignment of the UTF-32 string.
 *
 * Returns: %TRUE if a string could be read, %FALSE otherwise. The
 *     string put into @str must be freed with g_free() when no longer needed.
 */
GST_BYTE_READER_DUP_STRING (32, guint32);
