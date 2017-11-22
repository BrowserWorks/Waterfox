/*
 *  Copyright (c) 2013 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "webrtc/modules/desktop_capture/mouse_cursor_monitor.h"

#include <assert.h>

#include <memory>

#include <ApplicationServices/ApplicationServices.h>
#include <Cocoa/Cocoa.h>
#include <CoreFoundation/CoreFoundation.h>

#include "webrtc/base/macutils.h"
#include "webrtc/base/scoped_ref_ptr.h"
#include "webrtc/modules/desktop_capture/desktop_capture_options.h"
#include "webrtc/modules/desktop_capture/desktop_frame.h"
#include "webrtc/modules/desktop_capture/mac/desktop_configuration.h"
#include "webrtc/modules/desktop_capture/mac/desktop_configuration_monitor.h"
#include "webrtc/modules/desktop_capture/mac/full_screen_chrome_window_detector.h"
#include "webrtc/modules/desktop_capture/mouse_cursor.h"
#include "webrtc/system_wrappers/include/logging.h"

namespace webrtc {

namespace {
// Paint the image, so that we can get a bitmap representation compatible with
// current context. For example, in the retina display, we are going to get an
// image with same visual size but underlying pixel size conforms to the retina
// setting.
NSImage* PaintInCurrentContext(NSImage* source) {
  NSSize size = [source size];
  NSImage* new_image = [[[NSImage alloc] initWithSize:size] autorelease];
  [new_image lockFocus];
  NSRect frame = NSMakeRect(0, 0, size.width, size.height);
  [source drawInRect:frame
            fromRect:frame
           operation:NSCompositeCopy
            fraction:1.0];
  [new_image unlockFocus];
  return new_image;
}
}  // namespace

class MouseCursorMonitorMac : public MouseCursorMonitor {
 public:
  MouseCursorMonitorMac(const DesktopCaptureOptions& options,
                        CGWindowID window_id,
                        ScreenId screen_id);
  ~MouseCursorMonitorMac() override;

  void Start(Callback* callback, Mode mode) override;
  void Stop() override;
  void Capture() override;

 private:
  static void DisplaysReconfiguredCallback(CGDirectDisplayID display,
                                           CGDisplayChangeSummaryFlags flags,
                                           void *user_parameter);
  void DisplaysReconfigured(CGDirectDisplayID display,
                            CGDisplayChangeSummaryFlags flags);

  void CaptureImage(float scale);

  rtc::scoped_refptr<DesktopConfigurationMonitor> configuration_monitor_;
  CGWindowID window_id_;
  ScreenId screen_id_;
  Callback* callback_;
  Mode mode_;
  std::unique_ptr<MouseCursor> last_cursor_;
  rtc::scoped_refptr<FullScreenChromeWindowDetector>
      full_screen_chrome_window_detector_;
};

MouseCursorMonitorMac::MouseCursorMonitorMac(
    const DesktopCaptureOptions& options,
    CGWindowID window_id,
    ScreenId screen_id)
    : configuration_monitor_(options.configuration_monitor()),
      window_id_(window_id),
      screen_id_(screen_id),
      callback_(NULL),
      mode_(SHAPE_AND_POSITION),
      full_screen_chrome_window_detector_(
          options.full_screen_chrome_window_detector()) {
  assert(window_id == kCGNullWindowID || screen_id == kInvalidScreenId);
  if (screen_id != kInvalidScreenId &&
      rtc::GetOSVersionName() < rtc::kMacOSLion) {
    // Single screen capture is not supported on pre OS X 10.7.
    screen_id_ = kFullDesktopScreenId;
  }
}

MouseCursorMonitorMac::~MouseCursorMonitorMac() {}

void MouseCursorMonitorMac::Start(Callback* callback, Mode mode) {
  assert(!callback_);
  assert(callback);

  callback_ = callback;
  mode_ = mode;
}

void MouseCursorMonitorMac::Stop() {
  callback_ = NULL;
}

void MouseCursorMonitorMac::Capture() {
  assert(callback_);

  CursorState state = INSIDE;

  CGEventRef event = CGEventCreate(NULL);
  CGPoint gc_position = CGEventGetLocation(event);
  CFRelease(event);

  DesktopVector position(gc_position.x, gc_position.y);

  configuration_monitor_->Lock();
  MacDesktopConfiguration configuration =
      configuration_monitor_->desktop_configuration();
  configuration_monitor_->Unlock();
  float scale = 1.0f;

  // Find the dpi to physical pixel scale for the screen where the mouse cursor
  // is.
  for (MacDisplayConfigurations::iterator it = configuration.displays.begin();
       it != configuration.displays.end(); ++it) {
    if (it->bounds.Contains(position)) {
      scale = it->dip_to_pixel_scale;
      break;
    }
  }

  CaptureImage(scale);

  if (mode_ != SHAPE_AND_POSITION)
    return;

  // If we are capturing cursor for a specific window then we need to figure out
  // if the current mouse position is covered by another window and also adjust
  // |position| to make it relative to the window origin.
  if (window_id_ != kCGNullWindowID) {
    CGWindowID on_screen_window = window_id_;
    if (full_screen_chrome_window_detector_) {
      CGWindowID full_screen_window =
          full_screen_chrome_window_detector_->FindFullScreenWindow(window_id_);

      if (full_screen_window != kCGNullWindowID)
        on_screen_window = full_screen_window;
    }

    // Get list of windows that may be covering parts of |on_screen_window|.
    // CGWindowListCopyWindowInfo() returns windows in order from front to back,
    // so |on_screen_window| is expected to be the last in the list.
    CFArrayRef window_array =
        CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly |
                                       kCGWindowListOptionOnScreenAboveWindow |
                                       kCGWindowListOptionIncludingWindow,
                                   on_screen_window);
    bool found_window = false;
    if (window_array) {
      CFIndex count = CFArrayGetCount(window_array);
      for (CFIndex i = 0; i < count; ++i) {
        CFDictionaryRef window = reinterpret_cast<CFDictionaryRef>(
            CFArrayGetValueAtIndex(window_array, i));

        // Skip the Dock window. Dock window covers the whole screen, but it is
        // transparent.
        CFStringRef window_name = reinterpret_cast<CFStringRef>(
            CFDictionaryGetValue(window, kCGWindowName));
        if (window_name && CFStringCompare(window_name, CFSTR("Dock"), 0) == 0)
          continue;

        CFDictionaryRef window_bounds = reinterpret_cast<CFDictionaryRef>(
            CFDictionaryGetValue(window, kCGWindowBounds));
        CFNumberRef window_number = reinterpret_cast<CFNumberRef>(
            CFDictionaryGetValue(window, kCGWindowNumber));

        if (window_bounds && window_number) {
          CGRect gc_window_rect;
          if (!CGRectMakeWithDictionaryRepresentation(window_bounds,
                                                      &gc_window_rect)) {
            continue;
          }
          DesktopRect window_rect =
              DesktopRect::MakeXYWH(gc_window_rect.origin.x,
                                    gc_window_rect.origin.y,
                                    gc_window_rect.size.width,
                                    gc_window_rect.size.height);

          CGWindowID window_id;
          if (!CFNumberGetValue(window_number, kCFNumberIntType, &window_id))
            continue;

          if (window_id == on_screen_window) {
            found_window = true;
            if (!window_rect.Contains(position))
              state = OUTSIDE;
            position = position.subtract(window_rect.top_left());

            assert(i == count - 1);
            break;
          } else if (window_rect.Contains(position)) {
            state = OUTSIDE;
            position.set(-1, -1);
            break;
          }
        }
      }
      CFRelease(window_array);
    }
    if (!found_window) {
      // If we failed to get list of windows or the window wasn't in the list
      // pretend that the cursor is outside the window. This can happen, e.g. if
      // the window was closed.
      state = OUTSIDE;
      position.set(-1, -1);
    }
  } else {
    assert(screen_id_ >= kFullDesktopScreenId);
    if (screen_id_ != kFullDesktopScreenId) {
      // For single screen capturing, convert the position to relative to the
      // target screen.
      const MacDisplayConfiguration* config =
          configuration.FindDisplayConfigurationById(
              static_cast<CGDirectDisplayID>(screen_id_));
      if (config) {
        if (!config->pixel_bounds.Contains(position))
          state = OUTSIDE;
        position = position.subtract(config->bounds.top_left());
      } else {
        // The target screen is no longer valid.
        state = OUTSIDE;
        position.set(-1, -1);
      }
    } else {
      position.subtract(configuration.bounds.top_left());
    }
  }
  if (state == INSIDE) {
    // Convert Density Independent Pixel to physical pixel.
    position = DesktopVector(round(position.x() * scale),
                             round(position.y() * scale));
  }
  callback_->OnMouseCursorPosition(state, position);
}

void MouseCursorMonitorMac::CaptureImage(float scale) {
  NSCursor* nscursor = [NSCursor currentSystemCursor];

  NSImage* nsimage = [nscursor image];
  NSSize nssize = [nsimage size];  // DIP size

  // For retina screen, we need to paint the cursor in current graphic context
  // to get retina representation.
  if (scale != 1.0)
    nsimage = PaintInCurrentContext(nsimage);

  DesktopSize size(round(nssize.width * scale),
                   round(nssize.height * scale));  // Pixel size
  NSPoint nshotspot = [nscursor hotSpot];
  DesktopVector hotspot(
      std::max(0,
               std::min(size.width(), static_cast<int>(nshotspot.x * scale))),
      std::max(0,
               std::min(size.height(), static_cast<int>(nshotspot.y * scale))));
  CGImageRef cg_image =
      [nsimage CGImageForProposedRect:NULL context:nil hints:nil];
  if (!cg_image)
    return;

  if (CGImageGetBitsPerPixel(cg_image) != DesktopFrame::kBytesPerPixel * 8 ||
      CGImageGetWidth(cg_image) != static_cast<size_t>(size.width()) ||
      CGImageGetBitsPerComponent(cg_image) != 8) {
    return;
  }

  CGDataProviderRef provider = CGImageGetDataProvider(cg_image);
  CFDataRef image_data_ref = CGDataProviderCopyData(provider);
  if (image_data_ref == NULL)
    return;

  const uint8_t* src_data =
      reinterpret_cast<const uint8_t*>(CFDataGetBytePtr(image_data_ref));

  // Compare the cursor with the previous one.
  if (last_cursor_.get() &&
      last_cursor_->image()->size().equals(size) &&
      last_cursor_->hotspot().equals(hotspot) &&
      memcmp(last_cursor_->image()->data(), src_data,
             last_cursor_->image()->stride() * size.height()) == 0) {
    CFRelease(image_data_ref);
    return;
  }

  // Create a MouseCursor that describes the cursor and pass it to
  // the client.
  std::unique_ptr<DesktopFrame> image(
      new BasicDesktopFrame(DesktopSize(size.width(), size.height())));

  int src_stride = CGImageGetBytesPerRow(cg_image);
  image->CopyPixelsFrom(src_data, src_stride, DesktopRect::MakeSize(size));

  CFRelease(image_data_ref);

  std::unique_ptr<MouseCursor> cursor(
      new MouseCursor(image.release(), hotspot));
  last_cursor_.reset(MouseCursor::CopyOf(*cursor));

  callback_->OnMouseCursor(cursor.release());
}

MouseCursorMonitor* MouseCursorMonitor::CreateForWindow(
    const DesktopCaptureOptions& options, WindowId window) {
  return new MouseCursorMonitorMac(options, window, kInvalidScreenId);
}

MouseCursorMonitor* MouseCursorMonitor::CreateForScreen(
    const DesktopCaptureOptions& options,
    ScreenId screen) {
  return new MouseCursorMonitorMac(options, kCGNullWindowID, screen);
}

}  // namespace webrtc
