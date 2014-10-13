/*
 * Copyright (C) 2010 Ole André Vadla Ravnås <oleavr@soundrop.com>
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

#include "mtapi.h"

#include "dynapi-internal.h"

#define MT_FRAMEWORK_PATH "/System/Library/PrivateFrameworks/" \
    "MediaToolbox.framework/MediaToolbox"

G_DEFINE_TYPE (GstMTApi, gst_mt_api, GST_TYPE_DYN_API);

static void
gst_mt_api_init (GstMTApi * self)
{
}

static void
gst_mt_api_class_init (GstMTApiClass * klass)
{
}

#define SYM_SPEC(name) GST_DYN_SYM_SPEC (GstMTApi, name)

GstMTApi *
gst_mt_api_obtain (GError ** error)
{
  static const GstDynSymSpec symbols[] = {
    SYM_SPEC (FigCaptureDeviceGetFigBaseObject),
    SYM_SPEC (FigCaptureStreamGetFigBaseObject),

    SYM_SPEC (kFigCaptureDeviceProperty_Clock),
    SYM_SPEC (kFigCaptureDeviceProperty_StreamArray),
    SYM_SPEC (kFigCaptureStreamProperty_AudioLevelArray),
    SYM_SPEC (kFigCaptureStreamProperty_AudioLevelMeteringEnable),
    SYM_SPEC (kFigCaptureStreamProperty_AudioLevelUnits),
    SYM_SPEC (kFigCaptureStreamProperty_AutoAENow),
    SYM_SPEC (kFigCaptureStreamProperty_AutoFocusNow),
    SYM_SPEC (kFigCaptureStreamProperty_BufferAllocator),
    SYM_SPEC (kFigCaptureStreamProperty_BufferQueue),
    SYM_SPEC (kFigCaptureStreamProperty_FixedFrameRate),
    SYM_SPEC (kFigCaptureStreamProperty_FormatDescription),
    SYM_SPEC (kFigCaptureStreamProperty_FormatIndex),
    SYM_SPEC (kFigCaptureStreamProperty_FrameDuration),
    SYM_SPEC (kFigCaptureStreamProperty_MaximumFrameRate),
    SYM_SPEC (kFigCaptureStreamProperty_MinimumFrameRate),
    SYM_SPEC (kFigCaptureStreamProperty_NeedSampleBufferDurations),
    SYM_SPEC (kFigCaptureStreamProperty_StillImageBufferQueue),
    SYM_SPEC (kFigCaptureStreamProperty_StillImageCaptureNow),
    SYM_SPEC (kFigCaptureStreamProperty_SupportedFormatsArray),
    SYM_SPEC (kFigSupportedFormat_AudioMaxSampleRate),
    SYM_SPEC (kFigSupportedFormat_AudioMinSampleRate),
    SYM_SPEC (kFigSupportedFormat_FormatDescription),
    SYM_SPEC (kFigSupportedFormat_VideoIsBinned),
    SYM_SPEC (kFigSupportedFormat_VideoMaxFrameRate),
    SYM_SPEC (kFigSupportedFormat_VideoMinFrameRate),
    SYM_SPEC (kFigSupportedFormat_VideoScaleFactor),

    {NULL, 0},
  };

  return _gst_dyn_api_new (gst_mt_api_get_type (), MT_FRAMEWORK_PATH, symbols,
      error);
}
