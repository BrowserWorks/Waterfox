/*
 *  Copyright (c) 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "webrtc/modules/congestion_controller/transport_feedback_adapter.h"

#include <algorithm>
#include <limits>

#include "webrtc/base/checks.h"
#include "webrtc/base/logging.h"
#include "webrtc/modules/bitrate_controller/include/bitrate_controller.h"
#include "webrtc/modules/congestion_controller/delay_based_bwe.h"
#include "webrtc/modules/rtp_rtcp/source/rtcp_packet/transport_feedback.h"
#include "webrtc/modules/utility/include/process_thread.h"
#include "webrtc/system_wrappers/include/field_trial.h"

namespace webrtc {

const int64_t kNoTimestamp = -1;
const int64_t kSendTimeHistoryWindowMs = 10000;
const int64_t kBaseTimestampScaleFactor =
    rtcp::TransportFeedback::kDeltaScaleFactor * (1 << 8);
const int64_t kBaseTimestampRangeSizeUs = kBaseTimestampScaleFactor * (1 << 24);

class PacketInfoComparator {
 public:
  inline bool operator()(const PacketInfo& lhs, const PacketInfo& rhs) {
    if (lhs.arrival_time_ms != rhs.arrival_time_ms)
      return lhs.arrival_time_ms < rhs.arrival_time_ms;
    if (lhs.send_time_ms != rhs.send_time_ms)
      return lhs.send_time_ms < rhs.send_time_ms;
    return lhs.sequence_number < rhs.sequence_number;
  }
};

TransportFeedbackAdapter::TransportFeedbackAdapter(
    Clock* clock,
    BitrateController* bitrate_controller)
    : transport_overhead_bytes_per_packet_(0),
      send_time_history_(clock, kSendTimeHistoryWindowMs),
      clock_(clock),
      current_offset_ms_(kNoTimestamp),
      last_timestamp_us_(kNoTimestamp),
      bitrate_controller_(bitrate_controller) {}

TransportFeedbackAdapter::~TransportFeedbackAdapter() {}

void TransportFeedbackAdapter::InitBwe() {
  rtc::CritScope cs(&bwe_lock_);
  delay_based_bwe_.reset(new DelayBasedBwe(clock_));
}

void TransportFeedbackAdapter::AddPacket(uint16_t sequence_number,
                                         size_t length,
                                         int probe_cluster_id) {
  rtc::CritScope cs(&lock_);
  if (webrtc::field_trial::FindFullName("WebRTC-SendSideBwe-WithOverhead") ==
      "Enabled") {
    length += transport_overhead_bytes_per_packet_;
  }
  send_time_history_.AddAndRemoveOld(sequence_number, length, probe_cluster_id);
}

void TransportFeedbackAdapter::OnSentPacket(uint16_t sequence_number,
                                            int64_t send_time_ms) {
  rtc::CritScope cs(&lock_);
  send_time_history_.OnSentPacket(sequence_number, send_time_ms);
}

void TransportFeedbackAdapter::SetMinBitrate(int min_bitrate_bps) {
  rtc::CritScope cs(&bwe_lock_);
  delay_based_bwe_->SetMinBitrate(min_bitrate_bps);
}

void TransportFeedbackAdapter::SetTransportOverhead(
    int transport_overhead_bytes_per_packet) {
  rtc::CritScope cs(&lock_);
  transport_overhead_bytes_per_packet_ = transport_overhead_bytes_per_packet;
}

int64_t TransportFeedbackAdapter::GetProbingIntervalMs() const {
  rtc::CritScope cs(&bwe_lock_);
  return delay_based_bwe_->GetProbingIntervalMs();
}

std::vector<PacketInfo> TransportFeedbackAdapter::GetPacketFeedbackVector(
    const rtcp::TransportFeedback& feedback) {
  int64_t timestamp_us = feedback.GetBaseTimeUs();
  // Add timestamp deltas to a local time base selected on first packet arrival.
  // This won't be the true time base, but makes it easier to manually inspect
  // time stamps.
  if (last_timestamp_us_ == kNoTimestamp) {
    current_offset_ms_ = clock_->TimeInMilliseconds();
  } else {
    int64_t delta = timestamp_us - last_timestamp_us_;

    // Detect and compensate for wrap-arounds in base time.
    if (std::abs(delta - kBaseTimestampRangeSizeUs) < std::abs(delta)) {
      delta -= kBaseTimestampRangeSizeUs;  // Wrap backwards.
    } else if (std::abs(delta + kBaseTimestampRangeSizeUs) < std::abs(delta)) {
      delta += kBaseTimestampRangeSizeUs;  // Wrap forwards.
    }

    current_offset_ms_ += delta / 1000;
  }
  last_timestamp_us_ = timestamp_us;

  uint16_t sequence_number = feedback.GetBaseSequence();
  std::vector<int64_t> delta_vec = feedback.GetReceiveDeltasUs();
  auto delta_it = delta_vec.begin();
  std::vector<PacketInfo> packet_feedback_vector;
  packet_feedback_vector.reserve(delta_vec.size());

  {
    rtc::CritScope cs(&lock_);
    size_t failed_lookups = 0;
    int64_t offset_us = 0;
    for (auto symbol : feedback.GetStatusVector()) {
      if (symbol != rtcp::TransportFeedback::StatusSymbol::kNotReceived) {
        RTC_DCHECK(delta_it != delta_vec.end());
        offset_us += *(delta_it++);
        int64_t timestamp_ms = current_offset_ms_ + (offset_us / 1000);
        PacketInfo info(timestamp_ms, sequence_number);
        if (send_time_history_.GetInfo(&info, true) && info.send_time_ms >= 0) {
          packet_feedback_vector.push_back(info);
        } else {
          ++failed_lookups;
        }
      }
      ++sequence_number;
    }
    std::sort(packet_feedback_vector.begin(), packet_feedback_vector.end(),
              PacketInfoComparator());
    RTC_DCHECK(delta_it == delta_vec.end());
    if (failed_lookups > 0) {
      LOG(LS_WARNING) << "Failed to lookup send time for " << failed_lookups
                      << " packet" << (failed_lookups > 1 ? "s" : "")
                      << ". Send time history too small?";
    }
  }
  return packet_feedback_vector;
}

void TransportFeedbackAdapter::OnTransportFeedback(
    const rtcp::TransportFeedback& feedback) {
  last_packet_feedback_vector_ = GetPacketFeedbackVector(feedback);
  DelayBasedBwe::Result result;
  {
    rtc::CritScope cs(&bwe_lock_);
    result = delay_based_bwe_->IncomingPacketFeedbackVector(
        last_packet_feedback_vector_);
  }
  if (result.updated)
    bitrate_controller_->OnDelayBasedBweResult(result);
}

std::vector<PacketInfo> TransportFeedbackAdapter::GetTransportFeedbackVector()
    const {
  return last_packet_feedback_vector_;
}

void TransportFeedbackAdapter::OnRttUpdate(int64_t avg_rtt_ms,
                                           int64_t max_rtt_ms) {
  rtc::CritScope cs(&bwe_lock_);
  delay_based_bwe_->OnRttUpdate(avg_rtt_ms, max_rtt_ms);
}

}  // namespace webrtc
