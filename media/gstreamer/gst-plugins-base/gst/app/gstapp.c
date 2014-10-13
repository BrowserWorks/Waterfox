/* GStreamer
 * Copyright (C) 2007 David Schleef <ds@schleef.org>
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
 * SECTION:element-appsrc
 *
 * The appsrc element can be used by applications to insert data into a
 * GStreamer pipeline. Unlike most GStreamer elements, Appsrc provides
 * external API functions.
 *
 * For the documentation of the API, please see the
 * <link linkend="gst-plugins-base-libs-appsrc">libgstapp</link> section in the
 * GStreamer Plugins Base Libraries documentation.
 */
/**
 * SECTION:element-appsink
 *
 * Appsink is a sink plugin that supports many different methods for making
 * the application get a handle on the GStreamer data in a pipeline. Unlike
 * most GStreamer elements, Appsink provides external API functions.
 *
 * For the documentation of the API, please see the
 * <link linkend="gst-plugins-base-libs-appsink">libgstapp</link> section in
 * the GStreamer Plugins Base Libraries documentation.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/gst.h>

#include <gst/app/gstappsrc.h>
#include <gst/app/gstappsink.h>

static gboolean
plugin_init (GstPlugin * plugin)
{
  gst_element_register (plugin, "appsrc", GST_RANK_NONE, GST_TYPE_APP_SRC);
  gst_element_register (plugin, "appsink", GST_RANK_NONE, GST_TYPE_APP_SINK);

  return TRUE;
}

GST_PLUGIN_DEFINE (GST_VERSION_MAJOR,
    GST_VERSION_MINOR,
    app,
    "Elements used to communicate with applications",
    plugin_init, VERSION, GST_LICENSE, GST_PACKAGE_NAME, GST_PACKAGE_ORIGIN)
