/*
 *  Copyright (c) 2013 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include <memory>
#include <utility>

#include "webrtc/modules/desktop_capture/desktop_capturer.h"
#include "webrtc/modules/desktop_capture/desktop_capture_options.h"
#include "webrtc/modules/desktop_capture/win/screen_capturer_win_directx.h"
#include "webrtc/modules/desktop_capture/win/screen_capturer_win_gdi.h"
#include "webrtc/modules/desktop_capture/win/screen_capturer_win_magnifier.h"

namespace webrtc {

// static
std::unique_ptr<DesktopCapturer> DesktopCapturer::CreateRawScreenCapturer(
    const DesktopCaptureOptions& options) {
  std::unique_ptr<DesktopCapturer> capturer;
#ifdef CAPTURE_ALLOW_DIRECTX
  if (options.allow_directx_capturer() &&
      ScreenCapturerWinDirectx::IsSupported()) {
    capturer.reset(new ScreenCapturerWinDirectx(options));
  } else {
#else
  {
#endif
    capturer.reset(new ScreenCapturerWinGdi(options));
  }

  if (options.allow_use_magnification_api()) {
    capturer.reset(new ScreenCapturerWinMagnifier(std::move(capturer)));
  }

  return capturer;
}

}  // namespace webrtc
