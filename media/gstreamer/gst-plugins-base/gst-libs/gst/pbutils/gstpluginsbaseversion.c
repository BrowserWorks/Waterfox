/* GStreamer base plugins libraries version information
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

/**
 * SECTION:gstpluginsbaseversion
 * @short_description: GStreamer gst-plugins-base libraries version macros.
 *
 * Use the GST_PLUGINS_BASE_VERSION_* macros e.g. to check what version of
 * gst-plugins-base you are building against, and gst_plugins_base_version()
 * if you need to check at runtime what version of the gst-plugins-base
 * libraries are being used / you are currently linked against.
 *
 * The version macros get defined by including &lt;gst/pbutils/pbutils.h&gt;.
 */

#include "gstpluginsbaseversion.h"

/**
 * gst_plugins_base_version:
 * @major: (out): pointer to a guint to store the major version number, or %NULL
 * @minor: (out): pointer to a guint to store the minor version number, or %NULL
 * @micro: (out): pointer to a guint to store the micro version number, or %NULL
 * @nano:  (out): pointer to a guint to store the nano version number, or %NULL
 *
 * Gets the version number of the GStreamer Plugins Base libraries.
 */
void
gst_plugins_base_version (guint * major, guint * minor, guint * micro,
    guint * nano)
{
  if (major)
    *major = GST_PLUGINS_BASE_VERSION_MAJOR;
  if (minor)
    *minor = GST_PLUGINS_BASE_VERSION_MINOR;
  if (micro)
    *micro = GST_PLUGINS_BASE_VERSION_MICRO;
  if (nano)
    *nano = GST_PLUGINS_BASE_VERSION_NANO;
}

/**
 * gst_plugins_base_version_string:
 *
 * This function returns a string that is useful for describing this version
 * of GStreamer's gst-plugins-base libraries to the outside world: user agent
 * strings, logging, about dialogs ...
 *
 * Returns: a newly allocated string describing this version of gst-plugins-base
 */
gchar *
gst_plugins_base_version_string (void)
{
  return g_strdup_printf ("GStreamer Base Plugins %d.%d.%d%s",
      GST_PLUGINS_BASE_VERSION_MAJOR, GST_PLUGINS_BASE_VERSION_MINOR,
      GST_PLUGINS_BASE_VERSION_MICRO,
      ((GST_PLUGINS_BASE_VERSION_NANO == 0) ? "" :
          ((GST_PLUGINS_BASE_VERSION_NANO == 1) ? " (GIT)" : " (prerelease)")));
}
