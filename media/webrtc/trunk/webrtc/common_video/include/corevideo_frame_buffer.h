/*
 *  Copyright 2016 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_COMMON_VIDEO_INCLUDE_COREVIDEO_FRAME_BUFFER_H_
#define WEBRTC_COMMON_VIDEO_INCLUDE_COREVIDEO_FRAME_BUFFER_H_

#include <CoreVideo/CoreVideo.h>

#include <vector>

#include "webrtc/common_video/include/video_frame_buffer.h"

namespace webrtc {

class CoreVideoFrameBuffer : public NativeHandleBuffer {
 public:
  explicit CoreVideoFrameBuffer(CVPixelBufferRef pixel_buffer);
  CoreVideoFrameBuffer(CVPixelBufferRef pixel_buffer,
                       int adapted_width,
                       int adapted_height,
                       int crop_width,
                       int crop_height,
                       int crop_x,
                       int crop_y);
  ~CoreVideoFrameBuffer() override;

  rtc::scoped_refptr<VideoFrameBuffer> NativeToI420Buffer() override;
  // Returns true if the internal pixel buffer needs to be cropped.
  bool RequiresCropping() const;
  // Crop and scales the internal pixel buffer to the output pixel buffer. The
  // tmp buffer is used for intermediary splitting the UV channels. This
  // function returns true if successful.
  bool CropAndScaleTo(std::vector<uint8_t>* tmp_buffer,
                      CVPixelBufferRef output_pixel_buffer) const;

 private:
  CVPixelBufferRef pixel_buffer_;
  // buffer_width/height is the actual pixel buffer resolution. The width/height
  // in NativeHandleBuffer, i.e. width()/height(), is the resolution we will
  // scale to in NativeToI420Buffer(). Cropping happens before scaling, so:
  // buffer_width >= crop_width >= width().
  const int buffer_width_;
  const int buffer_height_;
  const int crop_width_;
  const int crop_height_;
  const int crop_x_;
  const int crop_y_;
};

}  // namespace webrtc

#endif  // WEBRTC_COMMON_VIDEO_INCLUDE_COREVIDEO_FRAME_BUFFER_H_
