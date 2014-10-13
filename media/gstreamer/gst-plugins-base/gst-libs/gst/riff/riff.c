/* GStreamer RIFF I/O
 * Copyright (C) 2003 Ronald Bultje <rbultje@ronald.bitfreak.net>
 *
 * riff.c: library initialisation
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
/**
 * SECTION:gstriff
 * @short_description: Riff fileformat utillity functions.
 *
 * A collection of functions to handle riff base files, such as avi, wav and
 * asf.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/gst.h>

#include "riff-read.h"

GST_DEBUG_CATEGORY (riff_debug);

/**
 * gst_riff_init:
 *
 * Initialize riff library.
 */
void
gst_riff_init (void)
{
  GST_DEBUG_CATEGORY_INIT (riff_debug, "riff", 0, "RIFF I/O");
}
