/* Quicktime muxer plugin for GStreamer
 * Copyright (C) 2008 Thiago Sousa Santos <thiagoss@embedded.ufcg.edu.br>
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
/*
 * Unless otherwise indicated, Source Code is licensed under MIT license.
 * See further explanation attached in License Statement (distributed in the file
 * LICENSE).
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include "properties.h"

/* if needed, re-allocate buffer to ensure size bytes can be written into it
 * at offset */
void
prop_copy_ensure_buffer (guint8 ** buffer, guint64 * bsize, guint64 * offset,
    guint64 size)
{
  if (buffer && *bsize - *offset < size) {
    *bsize += size + 10 * 1024;
    *buffer = g_realloc (*buffer, *bsize);
  }
}

static guint64
copy_func (void *prop, guint size, guint8 ** buffer, guint64 * bsize,
    guint64 * offset)
{
  if (buffer) {
    prop_copy_ensure_buffer (buffer, bsize, offset, size);
    memcpy (*buffer + *offset, prop, size);
  }
  *offset += size;
  return size;
}

#define INT_ARRAY_COPY_FUNC_FAST(name, datatype) 			\
guint64 prop_copy_ ## name ## _array (datatype *prop, guint size,	\
    guint8 ** buffer, guint64 * bsize, guint64 * offset) { 		\
  return copy_func (prop, sizeof (datatype) * size, buffer, bsize, offset);\
}

#define INT_ARRAY_COPY_FUNC(name, datatype) 				\
guint64 prop_copy_ ## name ## _array (datatype *prop, guint size,	\
    guint8 ** buffer, guint64 * bsize, guint64 * offset) { 		\
  guint i;								\
									\
  for (i = 0; i < size; i++) {						\
    prop_copy_ ## name (prop[i], buffer, bsize, offset);		\
  }									\
  return sizeof (datatype) * size;					\
}

/* INTEGERS */
guint64
prop_copy_uint8 (guint8 prop, guint8 ** buffer, guint64 * size,
    guint64 * offset)
{
  return copy_func (&prop, sizeof (guint8), buffer, size, offset);
}

guint64
prop_copy_uint16 (guint16 prop, guint8 ** buffer, guint64 * size,
    guint64 * offset)
{
  prop = GUINT16_TO_BE (prop);
  return copy_func (&prop, sizeof (guint16), buffer, size, offset);
}

guint64
prop_copy_uint32 (guint32 prop, guint8 ** buffer, guint64 * size,
    guint64 * offset)
{
  prop = GUINT32_TO_BE (prop);
  return copy_func (&prop, sizeof (guint32), buffer, size, offset);
}

guint64
prop_copy_uint64 (guint64 prop, guint8 ** buffer, guint64 * size,
    guint64 * offset)
{
  prop = GUINT64_TO_BE (prop);
  return copy_func (&prop, sizeof (guint64), buffer, size, offset);
}

guint64
prop_copy_int32 (gint32 prop, guint8 ** buffer, guint64 * size,
    guint64 * offset)
{
  prop = GINT32_TO_BE (prop);
  return copy_func (&prop, sizeof (guint32), buffer, size, offset);
}

/* uint8 can use direct copy in any case, and may be used for large quantity */
INT_ARRAY_COPY_FUNC_FAST (uint8, guint8);
/* not used in large quantity anyway */
INT_ARRAY_COPY_FUNC (uint16, guint16);
INT_ARRAY_COPY_FUNC (uint32, guint32);
INT_ARRAY_COPY_FUNC (uint64, guint64);

/* FOURCC */
guint64
prop_copy_fourcc (guint32 prop, guint8 ** buffer, guint64 * size,
    guint64 * offset)
{
  prop = GINT32_TO_LE (prop);
  return copy_func (&prop, sizeof (guint32), buffer, size, offset);
}

INT_ARRAY_COPY_FUNC (fourcc, guint32);

/**
 * prop_copy_fixed_size_string:
 * @string: the string to be copied
 * @str_size: size of the string
 * @buffer: the array to copy the string to
 * @offset: the position in the buffer array.
 * This value is updated to the point right after the copied string.
 *
 * Copies a string of bytes without placing its size at the beginning.
 *
 * Returns: the number of bytes copied
 */
guint64
prop_copy_fixed_size_string (guint8 * string, guint str_size, guint8 ** buffer,
    guint64 * size, guint64 * offset)
{
  return copy_func (string, str_size * sizeof (guint8), buffer, size, offset);
}

/**
 * prop_copy_size_string:
 *
 * @string: the string to be copied
 * @str_size: size of the string
 * @buffer: the array to copy the string to
 * @offset: the position in the buffer array.
 * This value is updated to the point right after the copied string.
 *
 * Copies a string and its size to an array. Example:
 * string = 'abc\0'
 * result in the array: [3][a][b][c]  (each [x] represents a position)
 *
 * Returns: the number of bytes copied
 */
guint64
prop_copy_size_string (guint8 * string, guint str_size, guint8 ** buffer,
    guint64 * size, guint64 * offset)
{
  guint64 original_offset = *offset;

  prop_copy_uint8 (str_size, buffer, size, offset);
  prop_copy_fixed_size_string (string, str_size, buffer, size, offset);
  return *offset - original_offset;
}

/**
 * prop_copy_null_terminated_string:
 * @string: the string to be copied
 * @buffer: the array to copy the string to
 * @offset: the position in the buffer array.
 * This value is updated to the point right after the copied string.
 *
 * Copies a string including its null terminating char to an array.
 *
 * Returns: the number of bytes copied
 */
guint64
prop_copy_null_terminated_string (gchar * string, guint8 ** buffer,
    guint64 * size, guint64 * offset)
{
  guint64 original_offset = *offset;
  guint len = strlen (string);

  prop_copy_fixed_size_string ((guint8 *) string, len, buffer, size, offset);
  prop_copy_uint8 ('\0', buffer, size, offset);
  return *offset - original_offset;
}
