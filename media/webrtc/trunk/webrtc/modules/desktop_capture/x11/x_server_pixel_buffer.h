/*
 *  Copyright (c) 2013 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

// Don't include this file in any .h files because it pulls in some X headers.

#ifndef WEBRTC_MODULES_DESKTOP_CAPTURE_X11_X_SERVER_PIXEL_BUFFER_H_
#define WEBRTC_MODULES_DESKTOP_CAPTURE_X11_X_SERVER_PIXEL_BUFFER_H_

#include "webrtc/base/constructormagic.h"
#include "webrtc/modules/desktop_capture/desktop_geometry.h"

#include <X11/Xutil.h>
#include <X11/extensions/XShm.h>

namespace webrtc {

class DesktopFrame;

// A class to allow the X server's pixel buffer to be accessed as efficiently
// as possible.
class XServerPixelBuffer {
 public:
  XServerPixelBuffer();
  ~XServerPixelBuffer();

  void Release();

  // Allocate (or reallocate) the pixel buffer for |window|. Returns false in
  // case of an error (e.g. window doesn't exist).
  bool Init(Display* display, Window window);

  bool is_initialized() { return window_ != 0; }

  // Returns the size of the window the buffer was initialized for.
  const DesktopSize& window_size() { return window_size_; }

  // Returns true if the window can be found.
  bool IsWindowValid() const;

  // If shared memory is being used without pixmaps, synchronize this pixel
  // buffer with the root window contents (otherwise, this is a no-op).
  // This is to avoid doing a full-screen capture for each individual
  // rectangle in the capture list, when it only needs to be done once at the
  // beginning.
  void Synchronize();

  // Capture the specified rectangle and stores it in the |frame|. In the case
  // where the full-screen data is captured by Synchronize(), this simply
  // returns the pointer without doing any more work. The caller must ensure
  // that |rect| is not larger than window_size().
  bool CaptureRect(const DesktopRect& rect, DesktopFrame* frame);

 private:
  void InitShm(const XWindowAttributes& attributes);
  bool InitPixmaps(int depth);

  // We expose two forms of blitting to handle variations in the pixel format.
  // In FastBlit(), the operation is effectively a memcpy.
  void FastBlit(uint8_t* image,
                const DesktopRect& rect,
                DesktopFrame* frame);
  void SlowBlit(uint8_t* image,
                const DesktopRect& rect,
                DesktopFrame* frame);

  Display* display_ = nullptr;
  Window window_ = 0;
  DesktopSize window_size_;
  XImage* x_image_ = nullptr;
  XShmSegmentInfo* shm_segment_info_ = nullptr;
  Pixmap shm_pixmap_ = 0;
  GC shm_gc_ = nullptr;
  bool xshm_get_image_succeeded_ = false;

  RTC_DISALLOW_COPY_AND_ASSIGN(XServerPixelBuffer);
};

}  // namespace webrtc

#endif  // WEBRTC_MODULES_DESKTOP_CAPTURE_X11_X_SERVER_PIXEL_BUFFER_H_
