/* GStreamer base utils library
 * Copyright (C) 2006 Tim-Philipp Müller <tim centricular net>
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
 * SECTION:gstpbutils
 * @short_description: General Application and Plugin Utility Library
 *
 * <refsect2>
 * <para>
 * libgstpbutils is a general utility library for plugins and applications.
 * It currently provides the
 * following:
 * </para>
 * <itemizedlist>
 * <listitem>
 * <para>
 * human-readable description strings of codecs, elements, sources, decoders,
 * encoders, or sinks from decoder/encoder caps, element names, or protocol
 * names.
 * </para>
 * </listitem>
 * <listitem>
 * <para>
 * support for applications to initiate installation of missing plugins (if
 * this is supported by the distribution or operating system used)
 * </para>
 * </listitem>
 * <listitem>
 * <para>
 * API for GStreamer elements to create missing-plugin messages in order to
 * communicate to the application that a certain type of plugin is missing
 * (decoder, encoder, URI protocol source, URI protocol sink, named element)
 * </para>
 * </listitem>
 * <listitem>
 * <para>
 * API for applications to recognise and handle missing-plugin messages
 * </para>
 * </listitem>
 * </itemizedlist>
 * <title>Linking to this library</title>
 * <para>
 * You should obtain the required CFLAGS and LIBS using pkg-config on the
 * gstreamer-plugins-base-0.10 module. You will then also need to add
 * '-lgstpbutils-0.10' manually to your LIBS line.
 * </para>
 * <title>Library initialisation</title>
 * <para>
 * Before using any of its functions, applications and plugins must call
 * gst_pb_utils_init() to initialise the library.
 * </para>
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

#include "pbutils.h"

#include "gst/gst-i18n-plugin.h"

/**
 * gst_pb_utils_init:
 *
 * Initialises the base utils support library. This function is not
 * thread-safe. Applications should call it after calling gst_init(),
 * plugins should call it from their plugin_init function.
 *
 * This function may be called multiple times. It will do nothing if the
 * library has already been initialised.
 */
void
gst_pb_utils_init (void)
{
  static gboolean inited;       /* FALSE */

  if (inited) {
    GST_LOG ("already initialised");
    return;
  }
#ifdef ENABLE_NLS
  GST_DEBUG ("binding text domain %s to locale dir %s", GETTEXT_PACKAGE,
      LOCALEDIR);
  bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
  bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
#endif

  inited = TRUE;
}
