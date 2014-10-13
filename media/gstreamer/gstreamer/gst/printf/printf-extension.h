/* GStreamer printf extension hooks
 * Copyright (C) 2013 Tim-Philipp Müller <tim centricular net>
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

#ifndef __GST_PRINTF_EXTENSION_H_INCLUDED__
#define __GST_PRINTF_EXTENSION_H_INCLUDED__

typedef char * (*PrintfPointerExtensionFunc) (const char * format, void * ptr);

/* we only need one global function, since it's only GstInfo registering extensions */
void   __gst_printf_pointer_extension_set_func  (PrintfPointerExtensionFunc func);

/* functions for internal printf implementation to handle the extensions */
char * __gst_printf_pointer_extension_serialize (const char * format, void * ptr);

#endif /* __GST_PRINTF_EXTENSION_H_INCLUDED__ */
