/*
 *  Copyright (c) 2016 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "webrtc/modules/video_coding/frame_buffer2.h"

#include <algorithm>
#include <cstring>
#include <queue>

#include "webrtc/base/checks.h"
#include "webrtc/base/logging.h"
#include "webrtc/modules/video_coding/jitter_estimator.h"
#include "webrtc/modules/video_coding/timing.h"
#include "webrtc/system_wrappers/include/clock.h"
#include "webrtc/system_wrappers/include/metrics.h"

namespace webrtc {
namespace video_coding {

namespace {
// Max number of frames the buffer will hold.
constexpr int kMaxFramesBuffered = 600;

// Max number of decoded frame info that will be saved.
constexpr int kMaxFramesHistory = 50;
}  // namespace

FrameBuffer::FrameBuffer(Clock* clock,
                         VCMJitterEstimator* jitter_estimator,
                         VCMTiming* timing)
    : clock_(clock),
      new_countinuous_frame_event_(false, false),
      jitter_estimator_(jitter_estimator),
      timing_(timing),
      inter_frame_delay_(clock_->TimeInMilliseconds()),
      last_decoded_frame_it_(frames_.end()),
      last_continuous_frame_it_(frames_.end()),
      num_frames_history_(0),
      num_frames_buffered_(0),
      stopped_(false),
      protection_mode_(kProtectionNack) {}

FrameBuffer::~FrameBuffer() {
  UpdateHistograms();
}

FrameBuffer::ReturnReason FrameBuffer::NextFrame(
    int64_t max_wait_time_ms,
    std::unique_ptr<FrameObject>* frame_out) {
  int64_t latest_return_time = clock_->TimeInMilliseconds() + max_wait_time_ms;
  int64_t wait_ms = max_wait_time_ms;
  FrameMap::iterator next_frame_it;

  do {
    int64_t now_ms = clock_->TimeInMilliseconds();
    {
      rtc::CritScope lock(&crit_);
      new_countinuous_frame_event_.Reset();
      if (stopped_)
        return kStopped;

      wait_ms = max_wait_time_ms;

      // Need to hold |crit_| in order to use |frames_|, therefore we
      // set it here in the loop instead of outside the loop in order to not
      // acquire the lock unnecesserily.
      next_frame_it = frames_.end();

      // |frame_it| points to the first frame after the
      // |last_decoded_frame_it_|.
      auto frame_it = frames_.end();
      if (last_decoded_frame_it_ == frames_.end()) {
        frame_it = frames_.begin();
      } else {
        frame_it = last_decoded_frame_it_;
        ++frame_it;
      }

      // |continuous_end_it| points to the first frame after the
      // |last_continuous_frame_it_|.
      auto continuous_end_it = last_continuous_frame_it_;
      if (continuous_end_it != frames_.end())
        ++continuous_end_it;

      for (; frame_it != continuous_end_it && frame_it != frames_.end();
           ++frame_it) {
        if (!frame_it->second.continuous ||
            frame_it->second.num_missing_decodable > 0) {
          continue;
        }

        FrameObject* frame = frame_it->second.frame.get();
        next_frame_it = frame_it;
        if (frame->RenderTime() == -1)
          frame->SetRenderTime(timing_->RenderTimeMs(frame->timestamp, now_ms));
        wait_ms = timing_->MaxWaitingTime(frame->RenderTime(), now_ms);

        // This will cause the frame buffer to prefer high framerate rather
        // than high resolution in the case of the decoder not decoding fast
        // enough and the stream has multiple spatial and temporal layers.
        if (wait_ms == 0)
          continue;

        break;
      }
    }  // rtc::Critscope lock(&crit_);

    wait_ms = std::min<int64_t>(wait_ms, latest_return_time - now_ms);
    wait_ms = std::max<int64_t>(wait_ms, 0);
  } while (new_countinuous_frame_event_.Wait(wait_ms));

  rtc::CritScope lock(&crit_);
  if (next_frame_it != frames_.end()) {
    std::unique_ptr<FrameObject> frame = std::move(next_frame_it->second.frame);
    int64_t received_time = frame->ReceivedTime();
    uint32_t timestamp = frame->timestamp;

    int64_t frame_delay;
    if (inter_frame_delay_.CalculateDelay(timestamp, &frame_delay,
                                          received_time)) {
      jitter_estimator_->UpdateEstimate(frame_delay, frame->size());
    }
    float rtt_mult = protection_mode_ == kProtectionNackFEC ? 0.0 : 1.0;
    timing_->SetJitterDelay(jitter_estimator_->GetJitterEstimate(rtt_mult));
    timing_->UpdateCurrentDelay(frame->RenderTime(),
                                clock_->TimeInMilliseconds());

    UpdateJitterDelay();

    PropagateDecodability(next_frame_it->second);
    AdvanceLastDecodedFrame(next_frame_it);
    *frame_out = std::move(frame);
    return kFrameFound;
  } else {
    return kTimeout;
  }
}

void FrameBuffer::SetProtectionMode(VCMVideoProtection mode) {
  rtc::CritScope lock(&crit_);
  protection_mode_ = mode;
}

void FrameBuffer::Start() {
  rtc::CritScope lock(&crit_);
  stopped_ = false;
}

void FrameBuffer::Stop() {
  rtc::CritScope lock(&crit_);
  stopped_ = true;
  new_countinuous_frame_event_.Set();
}

int FrameBuffer::InsertFrame(std::unique_ptr<FrameObject> frame) {
  rtc::CritScope lock(&crit_);
  RTC_DCHECK(frame);

  ++num_total_frames_;
  if (frame->num_references == 0)
    ++num_key_frames_;

  FrameKey key(frame->picture_id, frame->spatial_layer);
  int last_continuous_picture_id =
      last_continuous_frame_it_ == frames_.end()
          ? -1
          : last_continuous_frame_it_->first.picture_id;

  if (num_frames_buffered_ >= kMaxFramesBuffered) {
    LOG(LS_WARNING) << "Frame with (picture_id:spatial_id) (" << key.picture_id
                    << ":" << static_cast<int>(key.spatial_layer)
                    << ") could not be inserted due to the frame "
                    << "buffer being full, dropping frame.";
    return last_continuous_picture_id;
  }

  if (frame->inter_layer_predicted && frame->spatial_layer == 0) {
    LOG(LS_WARNING) << "Frame with (picture_id:spatial_id) (" << key.picture_id
                    << ":" << static_cast<int>(key.spatial_layer)
                    << ") is marked as inter layer predicted, dropping frame.";
    return last_continuous_picture_id;
  }

  if (last_decoded_frame_it_ != frames_.end() &&
      key < last_decoded_frame_it_->first) {
    LOG(LS_WARNING) << "Frame with (picture_id:spatial_id) (" << key.picture_id
                    << ":" << static_cast<int>(key.spatial_layer)
                    << ") inserted after frame ("
                    << last_decoded_frame_it_->first.picture_id << ":"
                    << static_cast<int>(
                           last_decoded_frame_it_->first.spatial_layer)
                    << ") was handed off for decoding, dropping frame.";
    return last_continuous_picture_id;
  }

  // Test if inserting this frame would cause the order of the frames to become
  // ambiguous (covering more than half the interval of 2^16). This can happen
  // when the picture id make large jumps mid stream.
  if (!frames_.empty() &&
      key < frames_.begin()->first &&
      frames_.rbegin()->first < key) {
    LOG(LS_WARNING) << "A jump in picture id was detected, clearing buffer.";
    ClearFramesAndHistory();
    last_continuous_picture_id = -1;
  }

  auto info = frames_.insert(std::make_pair(key, FrameInfo())).first;

  if (info->second.frame) {
    LOG(LS_WARNING) << "Frame with (picture_id:spatial_id) (" << key.picture_id
                    << ":" << static_cast<int>(key.spatial_layer)
                    << ") already inserted, dropping frame.";
    return last_continuous_picture_id;
  }

  if (!UpdateFrameInfoWithIncomingFrame(*frame, info))
    return last_continuous_picture_id;

  info->second.frame = std::move(frame);
  ++num_frames_buffered_;

  if (info->second.num_missing_continuous == 0) {
    info->second.continuous = true;
    PropagateContinuity(info);
    last_continuous_picture_id = last_continuous_frame_it_->first.picture_id;

    // Since we now have new continuous frames there might be a better frame
    // to return from NextFrame. Signal that thread so that it again can choose
    // which frame to return.
    new_countinuous_frame_event_.Set();
  }

  return last_continuous_picture_id;
}

void FrameBuffer::PropagateContinuity(FrameMap::iterator start) {
  RTC_DCHECK(start->second.continuous);
  if (last_continuous_frame_it_ == frames_.end())
    last_continuous_frame_it_ = start;

  std::queue<FrameMap::iterator> continuous_frames;
  continuous_frames.push(start);

  // A simple BFS to traverse continuous frames.
  while (!continuous_frames.empty()) {
    auto frame = continuous_frames.front();
    continuous_frames.pop();

    if (last_continuous_frame_it_->first < frame->first)
      last_continuous_frame_it_ = frame;

    // Loop through all dependent frames, and if that frame no longer has
    // any unfulfilled dependencies then that frame is continuous as well.
    for (size_t d = 0; d < frame->second.num_dependent_frames; ++d) {
      auto frame_ref = frames_.find(frame->second.dependent_frames[d]);
      --frame_ref->second.num_missing_continuous;

      if (frame_ref->second.num_missing_continuous == 0) {
        frame_ref->second.continuous = true;
        continuous_frames.push(frame_ref);
      }
    }
  }
}

void FrameBuffer::PropagateDecodability(const FrameInfo& info) {
  for (size_t d = 0; d < info.num_dependent_frames; ++d) {
    auto ref_info = frames_.find(info.dependent_frames[d]);
    RTC_DCHECK(ref_info != frames_.end());
    RTC_DCHECK_GT(ref_info->second.num_missing_decodable, 0U);
    --ref_info->second.num_missing_decodable;
  }
}

void FrameBuffer::AdvanceLastDecodedFrame(FrameMap::iterator decoded) {
  if (last_decoded_frame_it_ == frames_.end()) {
    last_decoded_frame_it_ = frames_.begin();
  } else {
    RTC_DCHECK(last_decoded_frame_it_->first < decoded->first);
    ++last_decoded_frame_it_;
  }
  --num_frames_buffered_;
  ++num_frames_history_;

  // First, delete non-decoded frames from the history.
  while (last_decoded_frame_it_ != decoded) {
    if (last_decoded_frame_it_->second.frame)
      --num_frames_buffered_;
    last_decoded_frame_it_ = frames_.erase(last_decoded_frame_it_);
  }

  // Then remove old history if we have too much history saved.
  if (num_frames_history_ > kMaxFramesHistory) {
    frames_.erase(frames_.begin());
    --num_frames_history_;
  }
}

bool FrameBuffer::UpdateFrameInfoWithIncomingFrame(const FrameObject& frame,
                                                   FrameMap::iterator info) {
  FrameKey key(frame.picture_id, frame.spatial_layer);
  info->second.num_missing_continuous = frame.num_references;
  info->second.num_missing_decodable = frame.num_references;

  RTC_DCHECK(last_decoded_frame_it_ == frames_.end() ||
             last_decoded_frame_it_->first < info->first);

  // Check how many dependencies that have already been fulfilled.
  for (size_t i = 0; i < frame.num_references; ++i) {
    FrameKey ref_key(frame.references[i], frame.spatial_layer);
    auto ref_info = frames_.find(ref_key);

    // Does |frame| depend on a frame earlier than the last decoded frame?
    if (last_decoded_frame_it_ != frames_.end() &&
        ref_key <= last_decoded_frame_it_->first) {
      if (ref_info == frames_.end()) {
        LOG(LS_WARNING) << "Frame with (picture_id:spatial_id) ("
                        << key.picture_id << ":"
                        << static_cast<int>(key.spatial_layer)
                        << " depends on a non-decoded frame more previous than "
                        << "the last decoded frame, dropping frame.";
        return false;
      }

      --info->second.num_missing_continuous;
      --info->second.num_missing_decodable;
    } else {
      if (ref_info == frames_.end())
        ref_info = frames_.insert(std::make_pair(ref_key, FrameInfo())).first;

      if (ref_info->second.continuous)
        --info->second.num_missing_continuous;

      // Add backwards reference so |frame| can be updated when new
      // frames are inserted or decoded.
      ref_info->second.dependent_frames[ref_info->second.num_dependent_frames] =
          key;
      ++ref_info->second.num_dependent_frames;
    }
    RTC_DCHECK_LE(ref_info->second.num_missing_continuous,
                  ref_info->second.num_missing_decodable);
  }

  // Check if we have the lower spatial layer frame.
  if (frame.inter_layer_predicted) {
    ++info->second.num_missing_continuous;
    ++info->second.num_missing_decodable;

    FrameKey ref_key(frame.picture_id, frame.spatial_layer - 1);
    // Gets or create the FrameInfo for the referenced frame.
    auto ref_info = frames_.insert(std::make_pair(ref_key, FrameInfo())).first;
    if (ref_info->second.continuous)
      --info->second.num_missing_continuous;

    if (ref_info == last_decoded_frame_it_) {
      --info->second.num_missing_decodable;
    } else {
      ref_info->second.dependent_frames[ref_info->second.num_dependent_frames] =
          key;
      ++ref_info->second.num_dependent_frames;
    }
    RTC_DCHECK_LE(ref_info->second.num_missing_continuous,
                  ref_info->second.num_missing_decodable);
  }

  RTC_DCHECK_LE(info->second.num_missing_continuous,
                info->second.num_missing_decodable);

  return true;
}

void FrameBuffer::UpdateJitterDelay() {
  int unused;
  int delay;
  timing_->GetTimings(&unused, &unused, &unused, &unused, &delay, &unused,
                      &unused);

  accumulated_delay_ += delay;
  ++accumulated_delay_samples_;
}

void FrameBuffer::UpdateHistograms() const {
  rtc::CritScope lock(&crit_);
  if (num_total_frames_ > 0) {
    int key_frames_permille = (static_cast<float>(num_key_frames_) * 1000.0f /
                                   static_cast<float>(num_total_frames_) +
                               0.5f);
    RTC_HISTOGRAM_COUNTS_1000("WebRTC.Video.KeyFramesReceivedInPermille",
                              key_frames_permille);
  }

  if (accumulated_delay_samples_ > 0) {
    RTC_HISTOGRAM_COUNTS_10000("WebRTC.Video.JitterBufferDelayInMs",
                               accumulated_delay_ / accumulated_delay_samples_);
  }
}

void FrameBuffer::ClearFramesAndHistory() {
  frames_.clear();
  last_decoded_frame_it_ = frames_.end();
  last_continuous_frame_it_ = frames_.end();
  num_frames_history_ = 0;
  num_frames_buffered_ = 0;
}

}  // namespace video_coding
}  // namespace webrtc
