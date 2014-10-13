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

#include "printf-extension.h"
#include "gst-printf.h"
#include <stdio.h>
#include <string.h>

static PrintfPointerExtensionFunc ptr_ext_func; /* NULL */

void
__gst_printf_pointer_extension_set_func (PrintfPointerExtensionFunc func)
{
  /* since this is internal, we don't need to worry about thread-safety */
  ptr_ext_func = func;
}

char *
__gst_printf_pointer_extension_serialize (const char *format, void *ptr)
{
  char *buf;

  if (ptr_ext_func == NULL) {
    buf = malloc (32);
    memset (buf, 0, 32);
    sprintf (buf, "%p", ptr);
  } else {
    /* note: we map malloc/free to g_malloc/g_free in gst-printf.h, so the
     * fact that gstinfo gives us a glib-allocated string and the printf
     * routines free it with free() and not g_free() should not be a problem */
    buf = ptr_ext_func (format, ptr);
  }
  return buf;
}
