/* GLIB - Library of useful routines for C programming
 * Copyright (C) 2003  Matthias Clasen
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */
#ifndef __G_GNULIB_H__

#include "config.h"
#include <stdlib.h>
#include <glib.h>

/* Private namespace for gnulib functions */
#define asnprintf        __gst_asnprintf
#define vasnprintf       __gst_vasnprintf
#define printf_parse     __gst_printf_parse
#define printf_fetchargs __gst_printf_fetchargs

/* Use GLib memory allocation */
#undef malloc
#undef realloc
#undef free
#define malloc  g_malloc
#define realloc g_realloc
#define free    g_free

/* Don't use snprintf(); we have to use sprintf instead and do our own
 * length calculations, because glibc doesn't allow passing %n in a format
 * string if the string is in writable memory (if glibc has been compiled
 * with _FORTIFY_SOURCE=2 which seems to be the case on some distros/systems) */
#undef HAVE_SNPRINTF

/* based on glib's config.h.win32.in */
#ifdef G_OS_WIN32

/* define to support printing 64-bit integers with format I64 */
#define HAVE_INT64_AND_I64 1

/* FIXME: do we need to do anything else here? or should we just typedef/define
 * intmax_t etc. to __int64? */
#if defined (_MSC_VER) && _MSC_VER >= 1600
#undef HAVE_INTMAX_T
#define HAVE_INTMAX_T 1
#endif

#endif /* G_OS_WIN32 */

#endif  /* __G_GNULIB_H__ */
