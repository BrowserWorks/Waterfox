/*
 *  Copyright (c) 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "webrtc/modules/remote_bitrate_estimator/include/send_time_history.h"

#include "webrtc/base/checks.h"
#include "webrtc/modules/rtp_rtcp/include/rtp_rtcp_defines.h"
#include "webrtc/system_wrappers/include/clock.h"

namespace webrtc {

SendTimeHistory::SendTimeHistory(Clock* clock, int64_t packet_age_limit_ms)
    : clock_(clock), packet_age_limit_ms_(packet_age_limit_ms) {}

SendTimeHistory::~SendTimeHistory() {}

void SendTimeHistory::Clear() {
  history_.clear();
}

void SendTimeHistory::AddAndRemoveOld(uint16_t sequence_number,
                                      size_t payload_size,
                                      int probe_cluster_id) {
  int64_t now_ms = clock_->TimeInMilliseconds();
  // Remove old.
  while (!history_.empty() &&
         now_ms - history_.begin()->second.creation_time_ms >
             packet_age_limit_ms_) {
    // TODO(sprang): Warn if erasing (too many) old items?
    history_.erase(history_.begin());
  }

  // Add new.
  int64_t unwrapped_seq_num = seq_num_unwrapper_.Unwrap(sequence_number);
  int64_t creation_time_ms = now_ms;
  constexpr int64_t kNoArrivalTimeMs = -1;  // Arrival time is ignored.
  constexpr int64_t kNoSendTimeMs = -1;     // Send time is set by OnSentPacket.
  history_.insert(std::make_pair(
      unwrapped_seq_num,
      PacketInfo(creation_time_ms, kNoArrivalTimeMs, kNoSendTimeMs,
                 sequence_number, payload_size, probe_cluster_id)));
}

bool SendTimeHistory::OnSentPacket(uint16_t sequence_number,
                                   int64_t send_time_ms) {
  int64_t unwrapped_seq_num = seq_num_unwrapper_.Unwrap(sequence_number);
  auto it = history_.find(unwrapped_seq_num);
  if (it == history_.end())
    return false;
  it->second.send_time_ms = send_time_ms;
  return true;
}

bool SendTimeHistory::GetInfo(PacketInfo* packet_info, bool remove) {
  RTC_DCHECK(packet_info);
  int64_t unwrapped_seq_num =
      seq_num_unwrapper_.Unwrap(packet_info->sequence_number);
  auto it = history_.find(unwrapped_seq_num);
  if (it == history_.end())
    return false;

  // Save arrival_time not to overwrite it.
  int64_t arrival_time_ms = packet_info->arrival_time_ms;
  *packet_info = it->second;
  packet_info->arrival_time_ms = arrival_time_ms;

  if (remove)
    history_.erase(it);
  return true;
}

}  // namespace webrtc
