/* GStreamer Quicktime/ISO demuxer language utility functions
 * Copyright (C) 2010 Tim-Philipp Müller <tim centricular net>
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

#ifndef __GST_QTDEMUX_LANG_H__
#define __GST_QTDEMUX_LANG_H__

G_BEGIN_DECLS

#include <glib.h>

void qtdemux_lang_map_qt_code_to_iso (gchar id[4], guint16 qt_lang_code);

G_END_DECLS

#endif /* __GST_QTDEMUX_LANG_H__ */
