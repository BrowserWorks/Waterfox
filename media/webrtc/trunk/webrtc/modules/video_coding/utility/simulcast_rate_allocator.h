/*
 *  Copyright (c) 2016 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_MODULES_VIDEO_CODING_UTILITY_SIMULCAST_RATE_ALLOCATOR_H_
#define WEBRTC_MODULES_VIDEO_CODING_UTILITY_SIMULCAST_RATE_ALLOCATOR_H_

#include <stdint.h>

#include <map>
#include <memory>

#include "webrtc/base/constructormagic.h"
#include "webrtc/common_video/include/video_bitrate_allocator.h"
#include "webrtc/modules/video_coding/codecs/vp8/temporal_layers.h"
#include "webrtc/video_encoder.h"

namespace webrtc {

class SimulcastRateAllocator : public VideoBitrateAllocator,
                               public TemporalLayersListener {
 public:
  explicit SimulcastRateAllocator(
      const VideoCodec& codec,
      std::unique_ptr<TemporalLayersFactory> tl_factory);

  void OnTemporalLayersCreated(int simulcast_id,
                               TemporalLayers* layers) override;

  BitrateAllocation GetAllocation(uint32_t total_bitrate_bps,
                                  uint32_t framerate) override;
  uint32_t GetPreferredBitrateBps(uint32_t framerate) override;
  const VideoCodec& GetCodec() const;

 private:
  const VideoCodec codec_;
  std::map<uint32_t, TemporalLayers*> temporal_layers_;
  std::unique_ptr<TemporalLayersFactory> tl_factory_;

  RTC_DISALLOW_COPY_AND_ASSIGN(SimulcastRateAllocator);
};

}  // namespace webrtc

#endif  // WEBRTC_MODULES_VIDEO_CODING_UTILITY_SIMULCAST_RATE_ALLOCATOR_H_
