/*
 *  Copyright (c) 2014 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "webrtc/modules/desktop_capture/win/screen_capturer_win_gdi.h"

#include <utility>

#include "webrtc/base/checks.h"
#include "webrtc/base/logging.h"
#include "webrtc/base/timeutils.h"
#include "webrtc/modules/desktop_capture/desktop_capture_options.h"
#include "webrtc/modules/desktop_capture/desktop_frame.h"
#include "webrtc/modules/desktop_capture/desktop_frame_win.h"
#include "webrtc/modules/desktop_capture/desktop_region.h"
#include "webrtc/modules/desktop_capture/mouse_cursor.h"
#include "webrtc/modules/desktop_capture/win/cursor.h"
#include "webrtc/modules/desktop_capture/win/desktop.h"
#include "webrtc/modules/desktop_capture/win/screen_capture_utils.h"
#include "webrtc/system_wrappers/include/logging.h"

namespace webrtc {

namespace {

// Constants from dwmapi.h.
const UINT DWM_EC_DISABLECOMPOSITION = 0;
const UINT DWM_EC_ENABLECOMPOSITION = 1;

const wchar_t kDwmapiLibraryName[] = L"dwmapi.dll";

}  // namespace

ScreenCapturerWinGdi::ScreenCapturerWinGdi(
    const DesktopCaptureOptions& options) {
  // Load dwmapi.dll dynamically since it is not available on XP.
  if (!dwmapi_library_)
    dwmapi_library_ = LoadLibrary(kDwmapiLibraryName);

  if (dwmapi_library_) {
    composition_func_ = reinterpret_cast<DwmEnableCompositionFunc>(
      GetProcAddress(dwmapi_library_, "DwmEnableComposition"));
    composition_enabled_func_ = reinterpret_cast<DwmIsCompositionEnabledFunc>
      (GetProcAddress(dwmapi_library_, "DwmIsCompositionEnabled"));
  }

  disable_composition_ = options.disable_effects();
}

ScreenCapturerWinGdi::~ScreenCapturerWinGdi() {
  Stop();

  if (dwmapi_library_)
    FreeLibrary(dwmapi_library_);
}

void ScreenCapturerWinGdi::SetSharedMemoryFactory(
    std::unique_ptr<SharedMemoryFactory> shared_memory_factory) {
  shared_memory_factory_ = std::move(shared_memory_factory);
}

void ScreenCapturerWinGdi::CaptureFrame() {
  RTC_DCHECK(IsGUIThread(false));
  int64_t capture_start_time_nanos = rtc::TimeNanos();

  queue_.MoveToNextFrame();
  RTC_DCHECK(!queue_.current_frame() || !queue_.current_frame()->IsShared());

  // Make sure the GDI capture resources are up-to-date.
  PrepareCaptureResources();

  if (!CaptureImage()) {
    callback_->OnCaptureResult(Result::ERROR_TEMPORARY, nullptr);
    return;
  }

  // Emit the current frame.
  std::unique_ptr<DesktopFrame> frame = queue_.current_frame()->Share();
  frame->set_dpi(DesktopVector(
      GetDeviceCaps(desktop_dc_, LOGPIXELSX),
      GetDeviceCaps(desktop_dc_, LOGPIXELSY)));
  frame->mutable_updated_region()->SetRect(
      DesktopRect::MakeSize(frame->size()));
  frame->set_capture_time_ms(
      (rtc::TimeNanos() - capture_start_time_nanos) /
      rtc::kNumNanosecsPerMillisec);
  callback_->OnCaptureResult(Result::SUCCESS, std::move(frame));
}

bool ScreenCapturerWinGdi::GetSourceList(SourceList* sources) {
  RTC_DCHECK(IsGUIThread(false));
  return webrtc::GetScreenList(sources);
}

bool ScreenCapturerWinGdi::SelectSource(SourceId id) {
  RTC_DCHECK(IsGUIThread(false));
  bool valid = IsScreenValid(id, &current_device_key_);
  if (valid)
    current_screen_id_ = id;
  return valid;
}

void ScreenCapturerWinGdi::Start(Callback* callback) {
  RTC_DCHECK(!callback_);
  RTC_DCHECK(callback);

  callback_ = callback;

  if (disable_composition_) {
    // Vote to disable Aero composited desktop effects while capturing. Windows
    // will restore Aero automatically if the process exits. This has no effect
    // under Windows 8 or higher.  See crbug.com/124018.
    if (composition_func_)
      (*composition_func_)(DWM_EC_DISABLECOMPOSITION);
  }
}

void ScreenCapturerWinGdi::Stop() {
  if (desktop_dc_) {
    ReleaseDC(NULL, desktop_dc_);
    desktop_dc_ = NULL;
  }
  if (memory_dc_) {
    DeleteDC(memory_dc_);
    memory_dc_ = NULL;
  }

  if (disable_composition_) {
    // Restore Aero.
    if (composition_func_)
      (*composition_func_)(DWM_EC_ENABLECOMPOSITION);
  }
  callback_ = NULL;
}

void ScreenCapturerWinGdi::PrepareCaptureResources() {
  RTC_DCHECK(IsGUIThread(false));
  // Switch to the desktop receiving user input if different from the current
  // one.
  std::unique_ptr<Desktop> input_desktop(Desktop::GetInputDesktop());
  if (input_desktop && !desktop_.IsSame(*input_desktop)) {
    // Release GDI resources otherwise SetThreadDesktop will fail.
    if (desktop_dc_) {
      ReleaseDC(NULL, desktop_dc_);
      desktop_dc_ = nullptr;
    }

    if (memory_dc_) {
      DeleteDC(memory_dc_);
      memory_dc_ = nullptr;
    }

    // If SetThreadDesktop() fails, the thread is still assigned a desktop.
    // So we can continue capture screen bits, just from the wrong desktop.
    desktop_.SetThreadDesktop(input_desktop.release());

    if (disable_composition_) {
      // Re-assert our vote to disable Aero.
      // See crbug.com/124018 and crbug.com/129906.
      if (composition_func_ != NULL) {
        (*composition_func_)(DWM_EC_DISABLECOMPOSITION);
      }
    }
  }

  // If the display bounds have changed then recreate GDI resources.
  // TODO(wez): Also check for pixel format changes.
  DesktopRect screen_rect(DesktopRect::MakeXYWH(
      GetSystemMetrics(SM_XVIRTUALSCREEN),
      GetSystemMetrics(SM_YVIRTUALSCREEN),
      GetSystemMetrics(SM_CXVIRTUALSCREEN),
      GetSystemMetrics(SM_CYVIRTUALSCREEN)));
  if (!screen_rect.equals(desktop_dc_rect_)) {
    if (desktop_dc_) {
      ReleaseDC(NULL, desktop_dc_);
      desktop_dc_ = nullptr;
    }
    if (memory_dc_) {
      DeleteDC(memory_dc_);
      memory_dc_ = nullptr;
    }
    desktop_dc_rect_ = DesktopRect();
  }

  if (!desktop_dc_) {
    RTC_DCHECK(!memory_dc_);

    // Create GDI device contexts to capture from the desktop into memory.
    desktop_dc_ = GetDC(nullptr);
    RTC_CHECK(desktop_dc_);
    memory_dc_ = CreateCompatibleDC(desktop_dc_);
    RTC_CHECK(memory_dc_);

    desktop_dc_rect_ = screen_rect;

    // Make sure the frame buffers will be reallocated.
    queue_.Reset();
  }
}

bool ScreenCapturerWinGdi::CaptureImage() {
  RTC_DCHECK(IsGUIThread(false));
  DesktopRect screen_rect =
      GetScreenRect(current_screen_id_, current_device_key_);
  if (screen_rect.is_empty())
    return false;

  DesktopSize size = screen_rect.size();
  // If the current buffer is from an older generation then allocate a new one.
  // Note that we can't reallocate other buffers at this point, since the caller
  // may still be reading from them.
  if (!queue_.current_frame() ||
      !queue_.current_frame()->size().equals(screen_rect.size())) {
    RTC_DCHECK(desktop_dc_);
    RTC_DCHECK(memory_dc_);

    std::unique_ptr<DesktopFrame> buffer = DesktopFrameWin::Create(
        size, shared_memory_factory_.get(), desktop_dc_);
    if (!buffer)
      return false;
    queue_.ReplaceCurrentFrame(SharedDesktopFrame::Wrap(std::move(buffer)));
  }

  // Select the target bitmap into the memory dc and copy the rect from desktop
  // to memory.
  DesktopFrameWin* current = static_cast<DesktopFrameWin*>(
      queue_.current_frame()->GetUnderlyingFrame());
  HGDIOBJ previous_object = SelectObject(memory_dc_, current->bitmap());
  DWORD rop = SRCCOPY;
  if (composition_enabled_func_) {
    BOOL enabled;
    (*composition_enabled_func_)(&enabled);
    if (!enabled) {
      // Vista or Windows 7, Aero disabled
      rop |= CAPTUREBLT;
    }
  } else {
    // Windows XP, required to get layered windows
    rop |= CAPTUREBLT;
  }
  if (!previous_object || previous_object == HGDI_ERROR) {
    return false;
  }

  bool result = (BitBlt(memory_dc_, 0, 0, screen_rect.width(),
      screen_rect.height(), desktop_dc_, screen_rect.left(), screen_rect.top(),
      rop) != FALSE);
  if (!result) {
    LOG_GLE(LS_WARNING) << "BitBlt failed";
  }

  // Select back the previously selected object to that the device contect
  // could be destroyed independently of the bitmap if needed.
  SelectObject(memory_dc_, previous_object);

  return result;
}

}  // namespace webrtc
