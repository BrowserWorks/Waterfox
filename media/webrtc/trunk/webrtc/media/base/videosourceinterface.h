/*
 *  Copyright (c) 2016 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_MEDIA_BASE_VIDEOSOURCEINTERFACE_H_
#define WEBRTC_MEDIA_BASE_VIDEOSOURCEINTERFACE_H_

#include "webrtc/media/base/videosinkinterface.h"
#include "webrtc/base/optional.h"

namespace rtc {

// VideoSinkWants is used for notifying the source of properties a video frame
// should have when it is delivered to a certain sink.
struct VideoSinkWants {
  // Tells the source whether the sink wants frames with rotation applied.
  // By default, any rotation must be applied by the sink.
  bool rotation_applied = false;

  // Tells the source that the sink only wants black frames.
  bool black_frames = false;

  // Tells the source the maximum number of pixels the sink wants.
  rtc::Optional<int> max_pixel_count;
  // Like |max_pixel_count| but relative to the given value. The source is
  // requested to produce frames with a resolution one "step up" from the given
  // value. In practice, this means that the sink can consume this amount of
  // pixels but wants more and the source should produce a resolution one
  // "step" higher than this but not higher.
  rtc::Optional<int> max_pixel_count_step_up;
};

template <typename VideoFrameT>
class VideoSourceInterface {
 public:
  virtual void AddOrUpdateSink(VideoSinkInterface<VideoFrameT>* sink,
                               const VideoSinkWants& wants) = 0;
  // RemoveSink must guarantee that at the time the method returns,
  // there is no current and no future calls to VideoSinkInterface::OnFrame.
  virtual void RemoveSink(VideoSinkInterface<VideoFrameT>* sink) = 0;

 protected:
  virtual ~VideoSourceInterface() {}
};

}  // namespace rtc
#endif  // WEBRTC_MEDIA_BASE_VIDEOSOURCEINTERFACE_H_
