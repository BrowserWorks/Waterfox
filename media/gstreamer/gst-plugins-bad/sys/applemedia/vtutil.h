/*
 * Copyright (C) 2010 Ole André Vadla Ravnås <oleavr@soundrop.com>
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

#ifndef __GST_VTUTIL_H__
#define __GST_VTUTIL_H__

#include <glib.h>
#include <CoreFoundation/CoreFoundation.h>

G_BEGIN_DECLS

gchar * gst_vtutil_object_to_string (CFTypeRef obj);
gchar * gst_vtutil_string_to_utf8 (CFStringRef s);
void gst_vtutil_dict_set_i32 (CFMutableDictionaryRef dict,
    CFStringRef key, gint32 value);
void gst_vtutil_dict_set_string (CFMutableDictionaryRef dict,
    CFStringRef key, const gchar * value);
void gst_vtutil_dict_set_boolean (CFMutableDictionaryRef dict,
    CFStringRef key, gboolean value);
void gst_vtutil_dict_set_data (CFMutableDictionaryRef dict,
    CFStringRef key, guint8 * value, guint64 length);
void gst_vtutil_dict_set_object (CFMutableDictionaryRef dict,
    CFStringRef key, CFTypeRef * value);

G_END_DECLS

#endif /* __GST_VTUTIL_H__ */
