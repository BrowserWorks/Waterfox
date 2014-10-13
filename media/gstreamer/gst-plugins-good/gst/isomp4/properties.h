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

#ifndef __PROPERTIES_H__
#define __PROPERTIES_H__

#include <glib.h>
#include <string.h>

/**
 * Functions for copying atoms properties.
 *
 * All of them receive, as the input, the property to be copied, the destination
 * buffer, and a pointer to an offset in the destination buffer to copy to the right place.
 * This offset will be updated to the new value (offset + copied_size)
 * The functions return the size of the property that has been copied or 0
 * if it couldn't copy.
 */

void    prop_copy_ensure_buffer          (guint8 ** buffer, guint64 * bsize, guint64 * offset, guint64 size);

guint64 prop_copy_uint8                  (guint8 prop, guint8 **buffer, guint64 *size, guint64 *offset);
guint64 prop_copy_uint16                 (guint16 prop, guint8 **buffer, guint64 *size, guint64 *offset);
guint64 prop_copy_uint32                 (guint32 prop, guint8 **buffer, guint64 *size, guint64 *offset);
guint64 prop_copy_uint64                 (guint64 prop, guint8 **buffer, guint64 *size, guint64 *offset);

guint64 prop_copy_int32                  (gint32 prop, guint8 **buffer, guint64 *size, guint64 *offset);

guint64 prop_copy_uint8_array            (guint8 *prop, guint size,
                                          guint8 **buffer, guint64 *bsize, guint64 *offset);
guint64 prop_copy_uint16_array           (guint16 *prop, guint size,
                                          guint8 **buffer, guint64 *bsize, guint64 *offset);
guint64 prop_copy_uint32_array           (guint32 *prop, guint size,
                                          guint8 **buffer, guint64 *bsize, guint64 *offset);
guint64 prop_copy_uint64_array           (guint64 *prop, guint size,
                                          guint8 **buffer, guint64 *bsize, guint64 *offset);

guint64 prop_copy_fourcc                 (guint32 prop, guint8 **buffer, guint64 *size, guint64 *offset);
guint64 prop_copy_fourcc_array           (guint32 *prop, guint size,
                                          guint8 **buffer, guint64 *bsize, guint64 *offset);
guint64 prop_copy_fixed_size_string      (guint8 *string, guint str_size,
                                          guint8 **buffer, guint64 *size, guint64 *offset);
guint64 prop_copy_size_string            (guint8 *string, guint str_size,
                                          guint8 **buffer, guint64 *size, guint64 *offset);
guint64 prop_copy_null_terminated_string (gchar *string,
                                          guint8 **buffer, guint64 *size, guint64 *offset);

#endif /* __PROPERTIES_H__ */
