/*
 *  Copyright (c) 2013 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "webrtc/modules/desktop_capture/window_capturer.h"

#include <assert.h>

#include "webrtc/base/scoped_ptr.h"
#include "webrtc/base/win32.h"
#include "webrtc/modules/desktop_capture/desktop_frame_win.h"
#include "webrtc/modules/desktop_capture/win/window_capture_utils.h"
#include "webrtc/system_wrappers/interface/logging.h"
#include <VersionHelpers.h>

namespace webrtc {

namespace {

typedef HRESULT (WINAPI *DwmIsCompositionEnabledFunc)(BOOL* enabled);

BOOL CALLBACK WindowsEnumerationHandler(HWND hwnd, LPARAM param) {
  assert(IsGUIThread(false));
  WindowCapturer::WindowList* list =
      reinterpret_cast<WindowCapturer::WindowList*>(param);

  // Skip windows that are invisible, minimized, have no title, or are owned,
  // unless they have the app window style set.
  int len = GetWindowTextLength(hwnd);
  HWND owner = GetWindow(hwnd, GW_OWNER);
  LONG exstyle = GetWindowLong(hwnd, GWL_EXSTYLE);
  if (len == 0 || IsIconic(hwnd) || !IsWindowVisible(hwnd) ||
      (owner && !(exstyle & WS_EX_APPWINDOW))) {
    return TRUE;
  }

  // Skip the Program Manager window and the Start button.
  const size_t kClassLength = 256;
  WCHAR class_name[kClassLength];
  GetClassName(hwnd, class_name, kClassLength);
  // Skip Program Manager window and the Start button. This is the same logic
  // that's used in Win32WindowPicker in libjingle. Consider filtering other
  // windows as well (e.g. toolbars).
  if (wcscmp(class_name, L"Progman") == 0 || wcscmp(class_name, L"Button") == 0)
    return TRUE;

  // Win8 introduced "Modern Apps" whose associated window is
  // non-shareable. We want to filter them out.
  if (IsWindows8OrGreater() &&
      (wcscmp(class_name, L"ApplicationFrameWindow") == 0 ||
       wcscmp(class_name, L"Windows.UI.Core.CoreWindow") == 0)) {
    return TRUE;
  }

  WindowCapturer::Window window;
  window.id = reinterpret_cast<WindowCapturer::WindowId>(hwnd);

  DWORD pid;
  GetWindowThreadProcessId(hwnd, &pid);
  window.pid = (pid_t)pid;

  const size_t kTitleLength = 500;
  WCHAR window_title[kTitleLength];
  // Truncate the title if it's longer than kTitleLength.
  GetWindowText(hwnd, window_title, kTitleLength);
  window.title = rtc::ToUtf8(window_title);

  // Skip windows when we failed to convert the title or it is empty.
  if (window.title.empty())
    return TRUE;
  // Skip windows of zero visible area, except IconicWindows
  RECT bounds;
  if(GetClientRect(hwnd,&bounds) && !IsIconic(hwnd)
    && IsRectEmpty(&bounds)){
    return TRUE;
  }

  list->push_back(window);

  return TRUE;
}

class WindowCapturerWin : public WindowCapturer {
 public:
  WindowCapturerWin();
  virtual ~WindowCapturerWin();

  // WindowCapturer interface.
  bool GetWindowList(WindowList* windows) override;
  bool SelectWindow(WindowId id) override;
  bool BringSelectedWindowToFront() override;

  // DesktopCapturer interface.
  void Start(Callback* callback) override;
  void Stop() override;
  void Capture(const DesktopRegion& region) override;

 private:
  bool IsAeroEnabled();

  Callback* callback_;

  // HWND and HDC for the currently selected window or NULL if window is not
  // selected.
  HWND window_;

  // dwmapi.dll is used to determine if desktop compositing is enabled.
  HMODULE dwmapi_library_;
  DwmIsCompositionEnabledFunc is_composition_enabled_func_;

  DesktopSize previous_size_;

  DISALLOW_COPY_AND_ASSIGN(WindowCapturerWin);
};

WindowCapturerWin::WindowCapturerWin()
    : callback_(NULL),
      window_(NULL) {
  // Try to load dwmapi.dll dynamically since it is not available on XP.
  dwmapi_library_ = LoadLibrary(L"dwmapi.dll");
  if (dwmapi_library_) {
    is_composition_enabled_func_ =
        reinterpret_cast<DwmIsCompositionEnabledFunc>(
            GetProcAddress(dwmapi_library_, "DwmIsCompositionEnabled"));
    assert(is_composition_enabled_func_);
  } else {
    is_composition_enabled_func_ = NULL;
  }
}

WindowCapturerWin::~WindowCapturerWin() {
  if (dwmapi_library_)
    FreeLibrary(dwmapi_library_);
}

bool WindowCapturerWin::IsAeroEnabled() {
  BOOL result = FALSE;
  if (is_composition_enabled_func_)
    is_composition_enabled_func_(&result);
  return result != FALSE;
}

bool WindowCapturerWin::GetWindowList(WindowList* windows) {
  assert(IsGUIThread(false));
  WindowList result;
  LPARAM param = reinterpret_cast<LPARAM>(&result);
  if (!EnumWindows(&WindowsEnumerationHandler, param))
    return false;
  windows->swap(result);
  return true;
}

bool WindowCapturerWin::SelectWindow(WindowId id) {
  assert(IsGUIThread(false));
  HWND window = reinterpret_cast<HWND>(id);
  if (!IsWindow(window) || !IsWindowVisible(window) || IsIconic(window))
    return false;
  window_ = window;
  previous_size_.set(0, 0);
  return true;
}

bool WindowCapturerWin::BringSelectedWindowToFront() {
  assert(IsGUIThread(false));
  if (!window_)
    return false;

  if (!IsWindow(window_) || !IsWindowVisible(window_) || IsIconic(window_))
    return false;

  return SetForegroundWindow(window_) != 0;
}

void WindowCapturerWin::Start(Callback* callback) {
  assert(!callback_);
  assert(callback);

  callback_ = callback;
}

void WindowCapturerWin::Stop() {
  callback_ = NULL;
}

void WindowCapturerWin::Capture(const DesktopRegion& region) {
  assert(IsGUIThread(false));
  if (!window_) {
    LOG(LS_ERROR) << "Window hasn't been selected: " << GetLastError();
    callback_->OnCaptureCompleted(NULL);
    return;
  }

  // Stop capturing if the window has been closed or hidden.
  if (!IsWindow(window_) || !IsWindowVisible(window_)) {
    callback_->OnCaptureCompleted(NULL);
    return;
  }

  // Return a 1x1 black frame if the window is minimized, to match the behavior
  // on Mac.
  if (IsIconic(window_)) {
    BasicDesktopFrame* frame = new BasicDesktopFrame(DesktopSize(1, 1));
    memset(frame->data(), 0, frame->stride() * frame->size().height());

    previous_size_ = frame->size();
    callback_->OnCaptureCompleted(frame);
    return;
  }

  DesktopRect original_rect;
  DesktopRect cropped_rect;
  if (!GetCroppedWindowRect(window_, &cropped_rect, &original_rect)) {
    LOG(LS_WARNING) << "Failed to get window info: " << GetLastError();
    callback_->OnCaptureCompleted(NULL);
    return;
  }

  HDC window_dc = GetWindowDC(window_);
  if (!window_dc) {
    LOG(LS_WARNING) << "Failed to get window DC: " << GetLastError();
    callback_->OnCaptureCompleted(NULL);
    return;
  }

  rtc::scoped_ptr<DesktopFrameWin> frame(
      DesktopFrameWin::Create(cropped_rect.size(), NULL, window_dc));
  if (!frame.get()) {
    ReleaseDC(window_, window_dc);
    callback_->OnCaptureCompleted(NULL);
    return;
  }

  HDC mem_dc = CreateCompatibleDC(window_dc);
  HGDIOBJ previous_object = SelectObject(mem_dc, frame->bitmap());
  BOOL result = FALSE;

  // When desktop composition (Aero) is enabled each window is rendered to a
  // private buffer allowing BitBlt() to get the window content even if the
  // window is occluded. PrintWindow() is slower but lets rendering the window
  // contents to an off-screen device context when Aero is not available.
  // PrintWindow() is not supported by some applications.
  //
  // If Aero is enabled, we prefer BitBlt() because it's faster and avoids
  // window flickering. Otherwise, we prefer PrintWindow() because BitBlt() may
  // render occluding windows on top of the desired window.
  //
  // When composition is enabled the DC returned by GetWindowDC() doesn't always
  // have window frame rendered correctly. Windows renders it only once and then
  // caches the result between captures. We hack it around by calling
  // PrintWindow() whenever window size changes, including the first time of
  // capturing - it somehow affects what we get from BitBlt() on the subsequent
  // captures.

  if (!IsAeroEnabled() || !previous_size_.equals(frame->size())) {
    result = PrintWindow(window_, mem_dc, 0);
  }

  // Aero is enabled or PrintWindow() failed, use BitBlt.
  if (!result) {
    result = BitBlt(mem_dc, 0, 0, frame->size().width(), frame->size().height(),
                    window_dc,
                    cropped_rect.left() - original_rect.left(),
                    cropped_rect.top() - original_rect.top(),
                    SRCCOPY);
  }

  SelectObject(mem_dc, previous_object);
  DeleteDC(mem_dc);
  ReleaseDC(window_, window_dc);

  previous_size_ = frame->size();

  frame->mutable_updated_region()->SetRect(
      DesktopRect::MakeSize(frame->size()));

  if (!result) {
    LOG(LS_ERROR) << "Both PrintWindow() and BitBlt() failed.";
    frame.reset();
  }

  callback_->OnCaptureCompleted(frame.release());
}

}  // namespace

// static
WindowCapturer* WindowCapturer::Create(const DesktopCaptureOptions& options) {
  return new WindowCapturerWin();
}

}  // namespace webrtc
