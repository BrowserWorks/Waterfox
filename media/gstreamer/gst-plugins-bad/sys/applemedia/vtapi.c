/*
 * Copyright (C) 2010, 2013 Ole André Vadla Ravnås <oleavr@soundrop.com>
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

#include "vtapi.h"

#include "dynapi-internal.h"

#include <gmodule.h>

#define VT_FRAMEWORK_PATH "/System/Library/Frameworks/" \
    "VideoToolbox.framework/VideoToolbox"
#define VT_FRAMEWORK_PATH_OLD "/System/Library/PrivateFrameworks/" \
    "VideoToolbox.framework/VideoToolbox"

G_DEFINE_TYPE (GstVTApi, gst_vt_api, GST_TYPE_DYN_API);

static void
gst_vt_api_init (GstVTApi * self)
{
}

static void
gst_vt_api_class_init (GstVTApiClass * klass)
{
}

#define SYM_SPEC(name) GST_DYN_SYM_SPEC (GstVTApi, name)

GstVTApi *
gst_vt_api_obtain (GError ** error)
{
  static const GstDynSymSpec symbols[] = {
    SYM_SPEC (VTCompressionSessionCompleteFrames),
    SYM_SPEC (VTCompressionSessionCopyProperty),
    SYM_SPEC (VTCompressionSessionCopySupportedPropertyDictionary),
    SYM_SPEC (VTCompressionSessionCreate),
    SYM_SPEC (VTCompressionSessionEncodeFrame),
    SYM_SPEC (VTCompressionSessionInvalidate),
    SYM_SPEC (VTCompressionSessionSetProperty),

    SYM_SPEC (VTDecompressionSessionCreate),
    SYM_SPEC (VTDecompressionSessionDecodeFrame),
    SYM_SPEC (VTDecompressionSessionInvalidate),
    SYM_SPEC (VTDecompressionSessionWaitForAsynchronousFrames),
    SYM_SPEC (VTDecompressionSessionFinishDelayedFrames),

    SYM_SPEC (kVTCompressionPropertyKey_AllowTemporalCompression),
    SYM_SPEC (kVTCompressionPropertyKey_AverageDataRate),
    SYM_SPEC (kVTCompressionPropertyKey_ExpectedFrameRate),
    SYM_SPEC (kVTCompressionPropertyKey_ExpectedDuration),
    SYM_SPEC (kVTCompressionPropertyKey_MaxKeyFrameInterval),
    SYM_SPEC (kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration),
    SYM_SPEC (kVTCompressionPropertyKey_ProfileLevel),
    SYM_SPEC (kVTCompressionPropertyKey_Usage),

    SYM_SPEC (kVTEncodeFrameOptionKey_ForceKeyFrame),

    SYM_SPEC (kVTProfileLevel_H264_Baseline_1_3),
    SYM_SPEC (kVTProfileLevel_H264_Baseline_3_0),
    SYM_SPEC (kVTProfileLevel_H264_Extended_5_0),
    SYM_SPEC (kVTProfileLevel_H264_High_5_0),
    SYM_SPEC (kVTProfileLevel_H264_Main_3_0),
    SYM_SPEC (kVTProfileLevel_H264_Main_3_1),
    SYM_SPEC (kVTProfileLevel_H264_Main_4_0),
    SYM_SPEC (kVTProfileLevel_H264_Main_4_1),
    SYM_SPEC (kVTProfileLevel_H264_Main_5_0),

    {NULL, 0},
  };
  GstVTApi *result;
  GModule *module;

  module = g_module_open (VT_FRAMEWORK_PATH, 0);
  if (module != NULL) {
    result = _gst_dyn_api_new (gst_vt_api_get_type (), VT_FRAMEWORK_PATH,
        symbols, error);
    g_module_close (module);
  } else {
    result = _gst_dyn_api_new (gst_vt_api_get_type (), VT_FRAMEWORK_PATH_OLD,
        symbols, error);
  }

  return result;
}
