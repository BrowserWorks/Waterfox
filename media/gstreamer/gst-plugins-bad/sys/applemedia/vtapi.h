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

#ifndef __GST_VT_API_H__
#define __GST_VT_API_H__

#include "dynapi.h"
#include "CoreMedia/CoreMedia.h"

G_BEGIN_DECLS

typedef struct _GstVTApi GstVTApi;
typedef struct _GstVTApiClass GstVTApiClass;

typedef enum _VTStatus VTStatus;
typedef enum _VTDecodeFrameFlags VTDecodeFrameFlags;
typedef enum _VTDecodeInfoFlags VTDecodeInfoFlags;

typedef guint32 VTFormatId;

typedef CFTypeRef VTCompressionSessionRef;
typedef CFTypeRef VTDecompressionSessionRef;
typedef struct _VTCompressionOutputCallback VTCompressionOutputCallback;
typedef struct _VTDecompressionOutputCallback VTDecompressionOutputCallback;

typedef VTStatus (* VTCompressionOutputCallbackFunc) (void * data, int a2,
    int a3, int a4, CMSampleBufferRef sbuf, int a6, int a7);
typedef void (* VTDecompressionOutputCallbackFunc) (void *data1, void *data2,
    VTStatus result, VTDecodeInfoFlags info, CVBufferRef cvbuf,
    CMTime pts, CMTime dts);

enum _VTStatus
{
  kVTSuccess = 0
};

enum _VTFormat
{
  kVTFormatH264 = 'avc1',
  kVTFormatMPEG2 = 'mp2v',
  kVTFormatJPEG = 'jpeg'
};

enum _VTDecodeFrameFlags
{
  kVTDecodeFrame_EnableAsynchronousDecompression = 1<<0,
  kVTDecodeFrame_DoNotOutputFrame = 1<<1,
  /* low-power mode that can not decode faster than 1x realtime. */
  kVTDecodeFrame_1xRealTimePlayback = 1<<2,
  /* Output frame in PTS order.
   * Needs to call VTDecompressionSessionFinishDelayedFrames to dequeue */
  kVTDecodeFrame_EnableTemporalProcessing = 1<<3,
};

enum _VTDecodeInfoFlags
{
  kVTDecodeInfo_Asynchronous = 1UL << 0,
  kVTDecodeInfo_FrameDropped = 1UL << 1,
};

struct _VTCompressionOutputCallback
{
  VTCompressionOutputCallbackFunc func;
  void * data;
};

struct _VTDecompressionOutputCallback
{
  VTDecompressionOutputCallbackFunc func;
  void * data;
};

struct _GstVTApi
{
  GstDynApi parent;

  VTStatus (* VTCompressionSessionCompleteFrames)
      (VTCompressionSessionRef session, CMTime completeUntilDisplayTimestamp);
  VTStatus (* VTCompressionSessionCopyProperty)
      (VTCompressionSessionRef session, CFTypeRef key, void* unk,
      CFTypeRef * value);
  VTStatus (* VTCompressionSessionCopySupportedPropertyDictionary)
      (VTCompressionSessionRef session, CFDictionaryRef * dict);
  VTStatus (* VTCompressionSessionCreate)
      (CFAllocatorRef allocator, gint width, gint height, VTFormatId formatId,
      gsize unk1, CFDictionaryRef sourcePixelBufferAttributes, gsize unk2,
      VTCompressionOutputCallback outputCallback,
      VTCompressionSessionRef * session);
  VTStatus (* VTCompressionSessionEncodeFrame)
      (VTCompressionSessionRef session, CVPixelBufferRef pixelBuffer,
      CMTime displayTimestamp, CMTime displayDuration,
      CFDictionaryRef frameOptions, void * sourceTrackingCallback,
      void * sourceFrameRefCon);
  void (* VTCompressionSessionInvalidate)
      (VTCompressionSessionRef session);
  VTStatus (* VTCompressionSessionSetProperty)
      (VTCompressionSessionRef session, CFStringRef propName,
      CFTypeRef propValue);

  VTStatus (* VTDecompressionSessionCreate)
      (CFAllocatorRef allocator,
      CMFormatDescriptionRef videoFormatDescription,
      CFTypeRef sessionOptions,
      CFDictionaryRef destinationPixelBufferAttributes,
      VTDecompressionOutputCallback * outputCallback,
      VTDecompressionSessionRef * session);
  VTStatus (* VTDecompressionSessionDecodeFrame)
      (VTDecompressionSessionRef session, CMSampleBufferRef sbuf,
       VTDecodeFrameFlags decode_flags, void *src_buf,
       VTDecodeInfoFlags *info_flags);
  void (* VTDecompressionSessionInvalidate)
      (VTDecompressionSessionRef session);
  VTStatus (* VTDecompressionSessionWaitForAsynchronousFrames)
      (VTDecompressionSessionRef session);
  VTStatus (* VTDecompressionSessionFinishDelayedFrames)
      (VTDecompressionSessionRef session);

  CFStringRef * kVTCompressionPropertyKey_AllowTemporalCompression;
  CFStringRef * kVTCompressionPropertyKey_AverageDataRate;
  CFStringRef * kVTCompressionPropertyKey_ExpectedFrameRate;
  CFStringRef * kVTCompressionPropertyKey_ExpectedDuration;
  CFStringRef * kVTCompressionPropertyKey_MaxKeyFrameInterval;
  CFStringRef * kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration;
  CFStringRef * kVTCompressionPropertyKey_ProfileLevel;
  CFStringRef * kVTCompressionPropertyKey_Usage;
  CFStringRef * kVTEncodeFrameOptionKey_ForceKeyFrame;
  CFStringRef * kVTProfileLevel_H264_Baseline_1_3;
  CFStringRef * kVTProfileLevel_H264_Baseline_3_0;
  CFStringRef * kVTProfileLevel_H264_Extended_5_0;
  CFStringRef * kVTProfileLevel_H264_High_5_0;
  CFStringRef * kVTProfileLevel_H264_Main_3_0;
  CFStringRef * kVTProfileLevel_H264_Main_3_1;
  CFStringRef * kVTProfileLevel_H264_Main_4_0;
  CFStringRef * kVTProfileLevel_H264_Main_4_1;
  CFStringRef * kVTProfileLevel_H264_Main_5_0;
};

struct _GstVTApiClass
{
  GstDynApiClass parent_class;
};

GType gst_vt_api_get_type (void);

GstVTApi * gst_vt_api_obtain (GError ** error);

G_END_DECLS

#endif
