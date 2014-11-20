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

#ifndef __GST_MT_API_H__
#define __GST_MT_API_H__

#include "cmapi.h"

G_BEGIN_DECLS

typedef struct _GstMTApi GstMTApi;
typedef struct _GstMTApiClass GstMTApiClass;

typedef struct _FigCaptureDevice * FigCaptureDeviceRef;
typedef struct _FigCaptureStream * FigCaptureStreamRef;
typedef struct _FigCaptureDeviceIface FigCaptureDeviceIface;
typedef struct _FigCaptureStreamIface FigCaptureStreamIface;

struct _FigCaptureDeviceIface
{
  gsize unk;
  OSStatus (* Func1) (FigCaptureDeviceRef stream);
};

struct _FigCaptureStreamIface
{
  gsize unk;
  OSStatus (* Start) (FigCaptureStreamRef stream);
  OSStatus (* Stop) (FigCaptureStreamRef stream);
};

struct _GstMTApi
{
  GstDynApi parent;

  FigBaseObjectRef (* FigCaptureDeviceGetFigBaseObject)
    (FigCaptureDeviceRef device);
  FigBaseObjectRef (* FigCaptureStreamGetFigBaseObject)
    (FigCaptureStreamRef stream);

  CFStringRef * kFigCaptureDeviceProperty_Clock;
  CFStringRef * kFigCaptureDeviceProperty_StreamArray;
  CFStringRef * kFigCaptureStreamProperty_AudioLevelArray;
  CFStringRef * kFigCaptureStreamProperty_AudioLevelMeteringEnable;
  CFStringRef * kFigCaptureStreamProperty_AudioLevelUnits;
  CFStringRef * kFigCaptureStreamProperty_AutoAENow;
  CFStringRef * kFigCaptureStreamProperty_AutoFocusNow;
  CFStringRef * kFigCaptureStreamProperty_BufferAllocator;
  CFStringRef * kFigCaptureStreamProperty_BufferQueue;
  CFStringRef * kFigCaptureStreamProperty_FixedFrameRate;
  CFStringRef * kFigCaptureStreamProperty_FormatDescription;
  CFStringRef * kFigCaptureStreamProperty_FormatIndex;
  CFStringRef * kFigCaptureStreamProperty_FrameDuration;
  CFStringRef * kFigCaptureStreamProperty_MaximumFrameRate;
  CFStringRef * kFigCaptureStreamProperty_MinimumFrameRate;
  CFStringRef * kFigCaptureStreamProperty_NeedSampleBufferDurations;
  CFStringRef * kFigCaptureStreamProperty_StillImageBufferQueue;
  CFStringRef * kFigCaptureStreamProperty_StillImageCaptureNow;
  CFStringRef * kFigCaptureStreamProperty_SupportedFormatsArray;
  CFStringRef * kFigSupportedFormat_AudioMaxSampleRate;
  CFStringRef * kFigSupportedFormat_AudioMinSampleRate;
  CFStringRef * kFigSupportedFormat_FormatDescription;
  CFStringRef * kFigSupportedFormat_VideoIsBinned;
  CFStringRef * kFigSupportedFormat_VideoMaxFrameRate;
  CFStringRef * kFigSupportedFormat_VideoMinFrameRate;
  CFStringRef * kFigSupportedFormat_VideoScaleFactor;
};

struct _GstMTApiClass
{
  GstDynApiClass parent_class;
};

GType gst_mt_api_get_type (void);

GstMTApi * gst_mt_api_obtain (GError ** error);

G_END_DECLS

#endif
