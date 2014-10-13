/*
 * Copyright (C) 2009-2010 Ole André Vadla Ravnås <oleavr@soundrop.com>
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
# include <config.h>
#endif

#include <Foundation/Foundation.h>
#ifdef HAVE_IOS
#include "iosassetsrc.h"
#else
#include "qtkitvideosrc.h"
#endif
#ifdef HAVE_AVFOUNDATION
#include "avfvideosrc.h"
#include "avfassetsrc.h"
#endif
#ifdef HAVE_VIDEOTOOLBOX
#include "vtdec.h"
#endif
#ifndef HAVE_IOS
#define AV_RANK GST_RANK_SECONDARY
#include "vth264decbin.h"
#include "vth264encbin.h"
#else
#define AV_RANK GST_RANK_PRIMARY
#endif
#include "atdec.h"

#ifdef HAVE_VIDEOTOOLBOX
void gst_vtenc_register_elements (GstPlugin * plugin);
#endif

#ifndef HAVE_IOS

static void
enable_mt_mode (void)
{
  NSThread * th = [[NSThread alloc] init];
  [th start];
  [th release];
  g_assert ([NSThread isMultiThreaded]);
}
#endif

static gboolean
plugin_init (GstPlugin * plugin)
{
  gboolean res = TRUE;

#ifdef HAVE_IOS
  res &= gst_element_register (plugin, "iosassetsrc", GST_RANK_SECONDARY,
      GST_TYPE_IOS_ASSET_SRC);
#else
  enable_mt_mode ();

  res = gst_element_register (plugin, "qtkitvideosrc", GST_RANK_SECONDARY,
      GST_TYPE_QTKIT_VIDEO_SRC);
#endif

#ifdef HAVE_AVFOUNDATION
  res &= gst_element_register (plugin, "avfvideosrc", AV_RANK,
      GST_TYPE_AVF_VIDEO_SRC);
  res &= gst_element_register (plugin, "avfassetsrc", AV_RANK,
      GST_TYPE_AVF_ASSET_SRC);
#endif

#if 0
  res &= gst_element_register (plugin, "vth264decbin", GST_RANK_NONE,
      GST_TYPE_VT_H264_DEC_BIN);
  res &= gst_element_register (plugin, "vth264encbin", GST_RANK_NONE,
      GST_TYPE_VT_H264_ENC_BIN);
#endif
  res &= gst_element_register (plugin, "atdec", GST_RANK_MARGINAL, GST_TYPE_ATDEC);

#ifdef HAVE_VIDEOTOOLBOX
  res &= gst_element_register (plugin, "vtdec", GST_RANK_PRIMARY, GST_TYPE_VTDEC);
  gst_vtenc_register_elements (plugin);
#endif

  return res;
}

GST_PLUGIN_DEFINE (GST_VERSION_MAJOR,
    GST_VERSION_MINOR,
    applemedia,
    "Elements for capture and codec access on Apple OS X and iOS",
    plugin_init, VERSION, "LGPL", "GStreamer", "http://gstreamer.net/")
