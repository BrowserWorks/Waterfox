/*
 *  Copyright (c) 2012 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "webrtc/modules/video_capture/video_capture_impl.h"

#include <stdlib.h>

#include "webrtc/api/video/i420_buffer.h"
#include "webrtc/base/refcount.h"
#include "webrtc/base/timeutils.h"
#include "webrtc/base/trace_event.h"
#include "webrtc/common_video/libyuv/include/webrtc_libyuv.h"
#include "webrtc/modules/include/module_common_types.h"
#include "webrtc/modules/video_capture/video_capture_config.h"
#include "webrtc/system_wrappers/include/clock.h"
#include "webrtc/system_wrappers/include/critical_section_wrapper.h"
#include "webrtc/system_wrappers/include/logging.h"

namespace webrtc {
namespace videocapturemodule {
rtc::scoped_refptr<VideoCaptureModule> VideoCaptureImpl::Create(
    VideoCaptureExternal*& externalCapture) {
  rtc::scoped_refptr<VideoCaptureImpl> implementation(
      new rtc::RefCountedObject<VideoCaptureImpl>());
  externalCapture = implementation.get();
  return implementation;
}

const char* VideoCaptureImpl::CurrentDeviceName() const
{
    return _deviceUniqueId;
}

// static
int32_t VideoCaptureImpl::RotationFromDegrees(int degrees,
                                              VideoRotation* rotation) {
  switch (degrees) {
    case 0:
      *rotation = kVideoRotation_0;
      return 0;
    case 90:
      *rotation = kVideoRotation_90;
      return 0;
    case 180:
      *rotation = kVideoRotation_180;
      return 0;
    case 270:
      *rotation = kVideoRotation_270;
      return 0;
    default:
      return -1;;
  }
}

// static
int32_t VideoCaptureImpl::RotationInDegrees(VideoRotation rotation,
                                            int* degrees) {
  switch (rotation) {
    case kVideoRotation_0:
      *degrees = 0;
      return 0;
    case kVideoRotation_90:
      *degrees = 90;
      return 0;
    case kVideoRotation_180:
      *degrees = 180;
      return 0;
    case kVideoRotation_270:
      *degrees = 270;
      return 0;
  }
  return -1;
}

VideoCaptureImpl::VideoCaptureImpl()
    : _deviceUniqueId(NULL),
      _apiCs(*CriticalSectionWrapper::CreateCriticalSection()),
      _captureDelay(0),
      _requestedCapability(),
      _lastProcessTimeNanos(rtc::TimeNanos()),
      _lastFrameRateCallbackTimeNanos(rtc::TimeNanos()),
      _dataCallBack(NULL),
      _lastProcessFrameTimeNanos(rtc::TimeNanos()),
      _rotateFrame(kVideoRotation_0),
      apply_rotation_(true) {
    _requestedCapability.width = kDefaultWidth;
    _requestedCapability.height = kDefaultHeight;
    _requestedCapability.maxFPS = 30;
    _requestedCapability.rawType = kVideoI420;
    _requestedCapability.codecType = kVideoCodecUnknown;
    memset(_incomingFrameTimesNanos, 0, sizeof(_incomingFrameTimesNanos));
}

VideoCaptureImpl::~VideoCaptureImpl()
{
    DeRegisterCaptureDataCallback();
    delete &_apiCs;

    if (_deviceUniqueId)
        delete[] _deviceUniqueId;
}

void VideoCaptureImpl::RegisterCaptureDataCallback(
    rtc::VideoSinkInterface<VideoFrame>* dataCallBack) {
    CriticalSectionScoped cs(&_apiCs);
    _dataCallBack = dataCallBack;
}

void VideoCaptureImpl::DeRegisterCaptureDataCallback() {
    CriticalSectionScoped cs(&_apiCs);
    _dataCallBack = NULL;
}
int32_t VideoCaptureImpl::DeliverCapturedFrame(VideoFrame& captureFrame) {
  UpdateFrameCount();  // frame count used for local frame rate callback.

  if (_dataCallBack) {
    _dataCallBack->OnFrame(captureFrame);
  }

  return 0;
}

int32_t VideoCaptureImpl::IncomingFrame(
    uint8_t* videoFrame,
    size_t videoFrameLength,
    const VideoCaptureCapability& frameInfo,
    int64_t captureTime/*=0*/)
{
    CriticalSectionScoped cs(&_apiCs);

    const int32_t width = frameInfo.width;
    const int32_t height = frameInfo.height;

    TRACE_EVENT1("webrtc", "VC::IncomingFrame", "capture_time", captureTime);

    if (frameInfo.codecType == kVideoCodecUnknown)
    {
        // Not encoded, convert to I420.
        const VideoType commonVideoType =
                  RawVideoTypeToCommonVideoVideoType(frameInfo.rawType);

        if (frameInfo.rawType != kVideoMJPEG &&
            CalcBufferSize(commonVideoType, width,
                           abs(height)) != videoFrameLength)
        {
            LOG(LS_ERROR) << "Wrong incoming frame length.";
            return -1;
        }

        // SetApplyRotation doesn't take any lock. Make a local copy here.
        bool apply_rotation = apply_rotation_;
        int target_width;
        int target_height;
        
        if (apply_rotation &&
            (_rotateFrame == kVideoRotation_90 ||
             _rotateFrame == kVideoRotation_270)) {
          target_width = abs(height);
          target_height = width;
        } else {
          target_width = width;
          target_height = height;
        }

        int stride_y = target_width;
        int stride_uv = (target_width + 1) / 2;

        // Setting absolute height (in case it was negative).
        // In Windows, the image starts bottom left, instead of top left.
        // Setting a negative source height, inverts the image (within LibYuv).

        // TODO(nisse): Use a pool?
        rtc::scoped_refptr<I420Buffer> buffer = I420Buffer::Create(
            target_width, abs(target_height), stride_y, stride_uv, stride_uv);
        const int conversionResult = ConvertToI420(
            commonVideoType, videoFrame, 0, 0,  // No cropping
            width, height, videoFrameLength,
            apply_rotation ? _rotateFrame : kVideoRotation_0, buffer.get());
        if (conversionResult != 0)
        {
          LOG(LS_ERROR) << "Failed to convert capture frame from type "
                        << frameInfo.rawType << "to I420.";
            return -1;
        }

        VideoFrame captureFrame(
            buffer, 0, rtc::TimeMillis(),
            !apply_rotation ? _rotateFrame : kVideoRotation_0);
        captureFrame.set_ntp_time_ms(captureTime);

        DeliverCapturedFrame(captureFrame);
    }
    else // Encoded format
    {
        assert(false);
        return -1;
    }

    return 0;
}

int32_t VideoCaptureImpl::SetCaptureRotation(VideoRotation rotation) {
  CriticalSectionScoped cs(&_apiCs);
  _rotateFrame = rotation;
  return 0;
}

bool VideoCaptureImpl::SetApplyRotation(bool enable) {
  // We can't take any lock here as it'll cause deadlock with IncomingFrame.

  // The effect of this is the last caller wins.
  apply_rotation_ = enable;
  return true;
}

void VideoCaptureImpl::UpdateFrameCount()
{
  if (_incomingFrameTimesNanos[0] / rtc::kNumNanosecsPerMicrosec == 0)
    {
        // first no shift
    }
    else
    {
        // shift
        for (int i = (kFrameRateCountHistorySize - 2); i >= 0; i--)
        {
            _incomingFrameTimesNanos[i + 1] = _incomingFrameTimesNanos[i];
        }
    }
    _incomingFrameTimesNanos[0] = rtc::TimeNanos();
}

uint32_t VideoCaptureImpl::CalculateFrameRate(int64_t now_ns)
{
    int32_t num = 0;
    int32_t nrOfFrames = 0;
    for (num = 1; num < (kFrameRateCountHistorySize - 1); num++)
    {
        if (_incomingFrameTimesNanos[num] <= 0 ||
            (now_ns - _incomingFrameTimesNanos[num]) /
            rtc::kNumNanosecsPerMillisec >
                kFrameRateHistoryWindowMs) // don't use data older than 2sec
        {
            break;
        }
        else
        {
            nrOfFrames++;
        }
    }
    if (num > 1)
    {
        int64_t diff = (now_ns - _incomingFrameTimesNanos[num - 1]) /
                       rtc::kNumNanosecsPerMillisec;
        if (diff > 0)
        {
            return uint32_t((nrOfFrames * 1000.0f / diff) + 0.5f);
        }
    }

    return nrOfFrames;
}
}  // namespace videocapturemodule
}  // namespace webrtc
