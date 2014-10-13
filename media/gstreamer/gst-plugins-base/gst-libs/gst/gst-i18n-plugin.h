/* GStreamer
 * Copyright (C) 2004 Thomas Vander Stichele <thomas@apestaart.org>
 *
 * gst-i18n-plugins.h: internationalization macros for the GStreamer plugins
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

#ifndef __GST_I18N_PLUGIN_H__
#define __GST_I18N_PLUGIN_H__

#include <locale.h>  /* some people need it and some people don't */
#include "gettext.h" /* included with gettext distribution and copied */

#ifndef GETTEXT_PACKAGE
#error You must define GETTEXT_PACKAGE before including this header.
#endif

/* we want to use shorthand _() for translating and N_() for marking */
#define _(String) dgettext (GETTEXT_PACKAGE, String)
#define N_(String) gettext_noop (String)
/* FIXME: if we need it, we can add Q_ as well, like in glib */

#endif /* __GST_I18N_PLUGIN_H__ */
