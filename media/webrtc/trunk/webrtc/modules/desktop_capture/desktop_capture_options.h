/*
 *  Copyright (c) 2013 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */
#ifndef WEBRTC_MODULES_DESKTOP_CAPTURE_DESKTOP_CAPTURE_OPTIONS_H_
#define WEBRTC_MODULES_DESKTOP_CAPTURE_DESKTOP_CAPTURE_OPTIONS_H_

#include "webrtc/base/constructormagic.h"
#include "webrtc/base/scoped_ref_ptr.h"

#if defined(USE_X11)
#include "webrtc/modules/desktop_capture/x11/shared_x_display.h"
#endif

#if defined(WEBRTC_MAC) && !defined(WEBRTC_IOS)
#include "webrtc/modules/desktop_capture/mac/desktop_configuration_monitor.h"
#include "webrtc/modules/desktop_capture/mac/full_screen_chrome_window_detector.h"
#endif

namespace webrtc {

// An object that stores initialization parameters for screen and window
// capturers.
class DesktopCaptureOptions {
 public:
  // Returns instance of DesktopCaptureOptions with default parameters. On Linux
  // also initializes X window connection. x_display() will be set to null if
  // X11 connection failed (e.g. DISPLAY isn't set).
  static DesktopCaptureOptions CreateDefault();

  DesktopCaptureOptions();
  DesktopCaptureOptions(const DesktopCaptureOptions& options);
  DesktopCaptureOptions(DesktopCaptureOptions&& options);
  ~DesktopCaptureOptions();

  DesktopCaptureOptions& operator=(const DesktopCaptureOptions& options);
  DesktopCaptureOptions& operator=(DesktopCaptureOptions&& options);

#if defined(USE_X11)
  SharedXDisplay* x_display() const { return x_display_; }
  void set_x_display(rtc::scoped_refptr<SharedXDisplay> x_display) {
    x_display_ = x_display;
  }
#endif

#if defined(WEBRTC_MAC) && !defined(WEBRTC_IOS)
  DesktopConfigurationMonitor* configuration_monitor() const {
    return configuration_monitor_;
  }
  void set_configuration_monitor(
      rtc::scoped_refptr<DesktopConfigurationMonitor> m) {
    configuration_monitor_ = m;
  }

  FullScreenChromeWindowDetector* full_screen_chrome_window_detector() const {
    return full_screen_window_detector_;
  }
  void set_full_screen_chrome_window_detector(
      rtc::scoped_refptr<FullScreenChromeWindowDetector> detector) {
    full_screen_window_detector_ = detector;
  }
#endif

  // Flag indicating that the capturer should use screen change notifications.
  // Enables/disables use of XDAMAGE in the X11 capturer.
  bool use_update_notifications() const { return use_update_notifications_; }
  void set_use_update_notifications(bool use_update_notifications) {
    use_update_notifications_ = use_update_notifications;
  }

  // Flag indicating if desktop effects (e.g. Aero) should be disabled when the
  // capturer is active. Currently used only on Windows.
  bool disable_effects() const { return disable_effects_; }
  void set_disable_effects(bool disable_effects) {
    disable_effects_ = disable_effects;
  }

  // Flag that should be set if the consumer uses updated_region() and the
  // capturer should try to provide correct updated_region() for the frames it
  // generates (e.g. by comparing each frame with the previous one).
  // TODO(zijiehe): WindowCapturer ignores this opinion until we merge
  // ScreenCapturer and WindowCapturer interfaces.
  bool detect_updated_region() const { return detect_updated_region_; }
  void set_detect_updated_region(bool detect_updated_region) {
    detect_updated_region_ = detect_updated_region;
  }

#if defined(WEBRTC_WIN)
  bool allow_use_magnification_api() const {
    return allow_use_magnification_api_;
  }
  void set_allow_use_magnification_api(bool allow) {
    allow_use_magnification_api_ = allow;
  }
  // Allowing directx based capturer or not, this capturer works on windows 7
  // with platform update / windows 8 or upper.
  bool allow_directx_capturer() const {
    return allow_directx_capturer_;
  }
  void set_allow_directx_capturer(bool enabled) {
    allow_directx_capturer_ = enabled;
  }
#endif

 private:
#if defined(USE_X11)
  rtc::scoped_refptr<SharedXDisplay> x_display_;
#endif

#if defined(WEBRTC_MAC) && !defined(WEBRTC_IOS)
  rtc::scoped_refptr<DesktopConfigurationMonitor> configuration_monitor_;
  rtc::scoped_refptr<FullScreenChromeWindowDetector>
      full_screen_window_detector_;
#endif

#if defined(WEBRTC_WIN)
  bool allow_use_magnification_api_ = false;
  bool allow_directx_capturer_ = false;
#endif
#if defined(USE_X11)
  bool use_update_notifications_ = false;
#else
  bool use_update_notifications_ = true;
#endif
  bool disable_effects_ = true;
  bool detect_updated_region_ = false;
};

}  // namespace webrtc

#endif  // WEBRTC_MODULES_DESKTOP_CAPTURE_DESKTOP_CAPTURE_OPTIONS_H_
