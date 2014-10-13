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

#include "vtutil.h"

gchar *
gst_vtutil_object_to_string (CFTypeRef obj)
{
  gchar *result;
  CFStringRef s;

  if (obj == NULL)
    return g_strdup ("(null)");

  s = CFCopyDescription (obj);
  result = gst_vtutil_string_to_utf8 (s);
  CFRelease (s);

  return result;
}

gchar *
gst_vtutil_string_to_utf8 (CFStringRef s)
{
  gchar *result;
  CFIndex size;

  size = CFStringGetMaximumSizeForEncoding (CFStringGetLength (s),
      kCFStringEncodingUTF8);
  result = g_malloc (size + 1);
  CFStringGetCString (s, result, size + 1, kCFStringEncodingUTF8);

  return result;
}

void
gst_vtutil_dict_set_i32 (CFMutableDictionaryRef dict, CFStringRef key,
    gint32 value)
{
  CFNumberRef number;

  number = CFNumberCreate (NULL, kCFNumberSInt32Type, &value);
  CFDictionarySetValue (dict, key, number);
  CFRelease (number);
}

void
gst_vtutil_dict_set_string (CFMutableDictionaryRef dict, CFStringRef key,
    const gchar * value)
{
  CFStringRef string;

  string = CFStringCreateWithCString (NULL, value, kCFStringEncodingASCII);
  CFDictionarySetValue (dict, key, string);
  CFRelease (string);
}

void
gst_vtutil_dict_set_boolean (CFMutableDictionaryRef dict, CFStringRef key,
    gboolean value)
{
  CFDictionarySetValue (dict, key, value ? kCFBooleanTrue : kCFBooleanFalse);
}

void
gst_vtutil_dict_set_data (CFMutableDictionaryRef dict, CFStringRef key,
    guint8 * value, guint64 length)
{
  CFDataRef data;

  data = CFDataCreate (NULL, value, length);
  CFDictionarySetValue (dict, key, data);
  CFRelease (data);
}

void
gst_vtutil_dict_set_object (CFMutableDictionaryRef dict, CFStringRef key,
    CFTypeRef * value)
{
  CFDictionarySetValue (dict, key, value);
  CFRelease (value);
}
