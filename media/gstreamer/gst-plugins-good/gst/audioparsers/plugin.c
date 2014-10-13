/* GStreamer audio parsers
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

#include "gstaacparse.h"
#include "gstamrparse.h"
#include "gstac3parse.h"
#include "gstdcaparse.h"
#include "gstflacparse.h"
#include "gstmpegaudioparse.h"
#include "gstsbcparse.h"
#include "gstwavpackparse.h"

static gboolean
plugin_init (GstPlugin * plugin)
{
  gboolean ret;

  ret = gst_element_register (plugin, "aacparse",
      GST_RANK_PRIMARY + 1, GST_TYPE_AAC_PARSE);
  ret &= gst_element_register (plugin, "amrparse",
      GST_RANK_PRIMARY + 1, GST_TYPE_AMR_PARSE);
  ret &= gst_element_register (plugin, "ac3parse",
      GST_RANK_PRIMARY + 1, GST_TYPE_AC3_PARSE);
  ret &= gst_element_register (plugin, "dcaparse",
      GST_RANK_PRIMARY + 1, GST_TYPE_DCA_PARSE);
  ret &= gst_element_register (plugin, "flacparse",
      GST_RANK_PRIMARY + 1, GST_TYPE_FLAC_PARSE);
  ret &= gst_element_register (plugin, "mpegaudioparse",
      GST_RANK_PRIMARY + 2, GST_TYPE_MPEG_AUDIO_PARSE);
  ret &= gst_element_register (plugin, "sbcparse",
      GST_RANK_PRIMARY + 1, GST_TYPE_SBC_PARSE);
  ret &= gst_element_register (plugin, "wavpackparse",
      GST_RANK_PRIMARY + 1, GST_TYPE_WAVPACK_PARSE);

  return ret;
}


GST_PLUGIN_DEFINE (GST_VERSION_MAJOR,
    GST_VERSION_MINOR,
    audioparsers,
    "Parsers for various audio formats",
    plugin_init, VERSION, "LGPL", GST_PACKAGE_NAME, GST_PACKAGE_ORIGIN);
