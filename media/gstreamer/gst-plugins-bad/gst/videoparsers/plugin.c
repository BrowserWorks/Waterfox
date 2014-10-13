/* GStreamer video parsers
 * Copyright (C) 2011 Mark Nauwelaerts <mark.nauwelaerts@collabora.co.uk>
 * Copyright (C) 2009 Tim-Philipp Müller <tim centricular net>
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

#include "gsth263parse.h"
#include "gsth264parse.h"
#include "gstdiracparse.h"
#include "gstmpegvideoparse.h"
#include "gstmpeg4videoparse.h"
#include "gstpngparse.h"
#include "gstvc1parse.h"
#include "gsth265parse.h"

static gboolean
plugin_init (GstPlugin * plugin)
{
  gboolean ret = FALSE;

  ret |= gst_element_register (plugin, "h263parse",
      GST_RANK_PRIMARY + 1, GST_TYPE_H263_PARSE);
  ret |= gst_element_register (plugin, "h264parse",
      GST_RANK_PRIMARY + 1, GST_TYPE_H264_PARSE);
  ret |= gst_element_register (plugin, "diracparse",
      GST_RANK_NONE, GST_TYPE_DIRAC_PARSE);
  ret |= gst_element_register (plugin, "mpegvideoparse",
      GST_RANK_PRIMARY + 1, GST_TYPE_MPEGVIDEO_PARSE);
  ret |= gst_element_register (plugin, "mpeg4videoparse",
      GST_RANK_PRIMARY + 1, GST_TYPE_MPEG4VIDEO_PARSE);
  ret |= gst_element_register (plugin, "pngparse",
      GST_RANK_PRIMARY, GST_TYPE_PNG_PARSE);
  ret |= gst_element_register (plugin, "h265parse",
      GST_RANK_SECONDARY, GST_TYPE_H265_PARSE);
  ret |= gst_element_register (plugin, "vc1parse",
      GST_RANK_NONE, GST_TYPE_VC1_PARSE);

  return ret;
}


GST_PLUGIN_DEFINE (GST_VERSION_MAJOR,
    GST_VERSION_MINOR,
    videoparsersbad,
    "videoparsers",
    plugin_init, VERSION, "LGPL", GST_PACKAGE_NAME, GST_PACKAGE_ORIGIN);
