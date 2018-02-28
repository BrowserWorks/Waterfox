/*
 *  Copyright (c) 2013 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include <assert.h>
#include <ApplicationServices/ApplicationServices.h>
#include <Cocoa/Cocoa.h>
#include <Carbon/Carbon.h>
#include <CoreFoundation/CoreFoundation.h>
#include <AppKit/AppKit.h>

#include "webrtc/modules/desktop_capture/app_capturer.h"

#include "webrtc/modules/desktop_capture/desktop_frame.h"
#include "webrtc/system_wrappers/include/logging.h"
#include "webrtc/base/constructormagic.h"

namespace webrtc {

namespace {

class AppCapturerMac : public AppCapturer {
 public:
  AppCapturerMac();
  virtual ~AppCapturerMac();

  // AppCapturer interface.
  virtual bool GetAppList(AppList* apps) override;
  virtual bool SelectApp(ProcessId processId) override;
  virtual bool BringAppToFront() override;

  // DesktopCapturer interface.
  virtual void Start(Callback* callback) override;
  virtual void Stop() override;
  virtual void CaptureFrame() override;
  virtual bool SelectSource(SourceId id) override
  {
    return SelectApp(static_cast<ProcessId>(id));
  }

 private:
  Callback* callback_;
  ProcessId process_id_;

  RTC_DISALLOW_COPY_AND_ASSIGN(AppCapturerMac);
};

AppCapturerMac::AppCapturerMac()
  : callback_(NULL),
    process_id_(0) {
}

AppCapturerMac::~AppCapturerMac() {
}

// AppCapturer interface.
bool AppCapturerMac::GetAppList(AppList* apps) {
  // handled by DesktopDeviceInfo
  return true;
}

bool AppCapturerMac::SelectApp(ProcessId processId) {
  process_id_ = processId;

  return true;
}

bool AppCapturerMac::BringAppToFront() {
  return true;
}

// DesktopCapturer interface.
void AppCapturerMac::Start(Callback* callback) {
  assert(!callback_);
  assert(callback);

  callback_ = callback;
}

void AppCapturerMac::Stop() {
  callback_ = NULL;
}

void AppCapturerMac::CaptureFrame() {
  // Check that selected process exists
  NSRunningApplication *ra = [NSRunningApplication runningApplicationWithProcessIdentifier:process_id_];
  if (!ra) {
    callback_->OnCaptureResult(DesktopCapturer::Result::ERROR_TEMPORARY, nullptr);
    return;
  }

#if defined(__LP64__)
#define CaptureWindowID int64_t
#else
#define CaptureWindowID CGWindowID
#endif

  CFArrayRef windowInfos = CGWindowListCopyWindowInfo(
      kCGWindowListOptionOnScreenOnly | kCGWindowListExcludeDesktopElements,
      kCGNullWindowID);
  CFIndex windowInfosCount = CFArrayGetCount(windowInfos);
  CaptureWindowID *captureWindowList = new CaptureWindowID[windowInfosCount];
  CFIndex captureWindowListCount = 0;
  for (CFIndex idx = 0; idx < windowInfosCount; idx++) {
    CFDictionaryRef info = reinterpret_cast<CFDictionaryRef>(
        CFArrayGetValueAtIndex(windowInfos, idx));
    CFNumberRef winOwner = reinterpret_cast<CFNumberRef>(
        CFDictionaryGetValue(info, kCGWindowOwnerPID));
    CFNumberRef winId = reinterpret_cast<CFNumberRef>(
        CFDictionaryGetValue(info, kCGWindowNumber));

    pid_t owner;
    CFNumberGetValue(winOwner, kCFNumberIntType, &owner);
    if (owner != process_id_) {
      continue;
    }

    CGWindowID ident;
    CFNumberGetValue(winId, kCFNumberIntType, &ident);

    captureWindowList[captureWindowListCount++] = ident;
  }
  CFRelease(windowInfos);

  // Check that window list is not empty
  if (captureWindowListCount <= 0) {
    delete [] captureWindowList;
    callback_->OnCaptureResult(DesktopCapturer::Result::ERROR_TEMPORARY, nullptr);
    return;
  }

  // Does not support multi-display; See bug 1037997.
  CGRect rectCapturedDisplay = CGDisplayBounds(CGMainDisplayID());

  // Capture all windows of selected process, bounded by desktop.
  CFArrayRef windowIDsArray = CFArrayCreate(kCFAllocatorDefault,
                                            (const void**)captureWindowList,
                                            captureWindowListCount,
                                            NULL);
  CGImageRef app_image = CGWindowListCreateImageFromArray(rectCapturedDisplay,
                                                          windowIDsArray,
                                                          kCGWindowImageDefault);
  CFRelease (windowIDsArray);
  delete [] captureWindowList;

  // Wrap raw data into DesktopFrame
  if (!app_image) {
    CFRelease(app_image);
    callback_->OnCaptureResult(DesktopCapturer::Result::ERROR_TEMPORARY, nullptr);
    return;
  }

  int bits_per_pixel = CGImageGetBitsPerPixel(app_image);
  if (bits_per_pixel != 32) {
      LOG(LS_ERROR) << "Unsupported window image depth: " << bits_per_pixel;
      CFRelease(app_image);
      callback_->OnCaptureResult(DesktopCapturer::Result::ERROR_TEMPORARY, nullptr);
      return;
  }

  int width = CGImageGetWidth(app_image);
  int height = CGImageGetHeight(app_image);
  std::unique_ptr<DesktopFrame> frame(new BasicDesktopFrame(DesktopSize(width, height)));

  CGDataProviderRef provider = CGImageGetDataProvider(app_image);
  CFDataRef cf_data = CGDataProviderCopyData(provider);
  int src_stride = CGImageGetBytesPerRow(app_image);
  const uint8_t* src_data = CFDataGetBytePtr(cf_data);
  for (int y = 0; y < height; ++y) {
    memcpy(frame->data() + frame->stride() * y, src_data + src_stride * y,
            DesktopFrame::kBytesPerPixel * width);
  }

  CFRelease(cf_data);
  CFRelease(app_image);

  callback_->OnCaptureResult(DesktopCapturer::Result::SUCCESS, std::move(frame));
}

}  // namespace

// static
AppCapturer* AppCapturer::Create(const DesktopCaptureOptions& options) {
  return new AppCapturerMac();
}

// static
std::unique_ptr<DesktopCapturer> DesktopCapturer::CreateRawAppCapturer(
    const DesktopCaptureOptions& options) {

  std::unique_ptr<AppCapturerMac> capturer(new AppCapturerMac());

  return std::unique_ptr<DesktopCapturer>(capturer.release());
}

}  // namespace webrtc
