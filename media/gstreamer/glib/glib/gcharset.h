/* gcharset.h - Charset functions
 *
 *  Copyright (C) 2011 Red Hat, Inc.
 *
 * The GLib Library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 *
 * The GLib Library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with the Gnome Library; see the file COPYING.LIB.  If not,
 * write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 *   Boston, MA 02111-1307, USA.
 */

#ifndef __G_CHARSET_H__
#define __G_CHARSET_H__

#if !defined (__GLIB_H_INSIDE__) && !defined (GLIB_COMPILATION)
#error "Only <glib.h> can be included directly."
#endif

#include <glib/gtypes.h>

G_BEGIN_DECLS

GLIB_AVAILABLE_IN_ALL
gboolean              g_get_charset         (const char **charset);
GLIB_AVAILABLE_IN_ALL
gchar *               g_get_codeset         (void);

GLIB_AVAILABLE_IN_ALL
const gchar * const * g_get_language_names  (void);
GLIB_AVAILABLE_IN_ALL
gchar **              g_get_locale_variants (const gchar *locale);

G_END_DECLS

#endif  /* __G_CHARSET_H__ */
