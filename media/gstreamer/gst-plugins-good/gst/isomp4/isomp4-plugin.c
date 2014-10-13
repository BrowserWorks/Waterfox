/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
 * Copyright (C) <2003> David A. Schleef <ds@schleef.org>
 * Copyright (C) <2006> Wim Taymans <wim@fluendo.com>
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

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif
#include "gst/gst-i18n-plugin.h"

#include "qtdemux.h"
#include "gstrtpxqtdepay.h"
#include "gstqtmux.h"
#include "gstqtmoovrecover.h"

#include <gst/pbutils/pbutils.h>

static gboolean
plugin_init (GstPlugin * plugin)
{
#ifdef ENABLE_NLS
  bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
  bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
#endif /* ENABLE_NLS */

  gst_pb_utils_init ();

  /* ensure private tag is registered */
  gst_tag_register (GST_QT_DEMUX_PRIVATE_TAG, GST_TAG_FLAG_META,
      GST_TYPE_SAMPLE, "QT atom", "unparsed QT tag atom",
      gst_tag_merge_use_first);

  gst_tag_register (GST_QT_DEMUX_CLASSIFICATION_TAG, GST_TAG_FLAG_META,
      G_TYPE_STRING, GST_QT_DEMUX_CLASSIFICATION_TAG, "content classification",
      gst_tag_merge_use_first);

  if (!gst_element_register (plugin, "qtdemux",
          GST_RANK_PRIMARY, GST_TYPE_QTDEMUX))
    return FALSE;

  if (!gst_element_register (plugin, "rtpxqtdepay",
          GST_RANK_MARGINAL, GST_TYPE_RTP_XQT_DEPAY))
    return FALSE;

  if (!gst_qt_mux_register (plugin))
    return FALSE;
  if (!gst_qt_moov_recover_register (plugin))
    return FALSE;

  return TRUE;
}

GST_PLUGIN_DEFINE (GST_VERSION_MAJOR,
    GST_VERSION_MINOR,
    isomp4,
    "ISO base media file format support (mp4, 3gpp, qt, mj2)",
    plugin_init, VERSION, "LGPL", GST_PACKAGE_NAME, GST_PACKAGE_ORIGIN);
