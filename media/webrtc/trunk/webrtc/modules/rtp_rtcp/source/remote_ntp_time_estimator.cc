/*
 *  Copyright (c) 2014 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "webrtc/modules/rtp_rtcp/include/remote_ntp_time_estimator.h"

#include "webrtc/base/logging.h"
#include "webrtc/system_wrappers/include/clock.h"
#include "webrtc/system_wrappers/include/timestamp_extrapolator.h"

namespace webrtc {

static const int kTimingLogIntervalMs = 10000;

// TODO(wu): Refactor this class so that it can be shared with
// vie_sync_module.cc.
RemoteNtpTimeEstimator::RemoteNtpTimeEstimator(Clock* clock)
    : clock_(clock),
      ts_extrapolator_(new TimestampExtrapolator(clock_->TimeInMilliseconds())),
      last_timing_log_ms_(-1) {
}

RemoteNtpTimeEstimator::~RemoteNtpTimeEstimator() {}

bool RemoteNtpTimeEstimator::UpdateRtcpTimestamp(int64_t rtt,
                                                 uint32_t ntp_secs,
                                                 uint32_t ntp_frac,
                                                 uint32_t rtcp_timestamp) {
  bool new_rtcp_sr = false;
  if (!rtp_to_ntp_.UpdateMeasurements(ntp_secs, ntp_frac, rtcp_timestamp,
                                      &new_rtcp_sr)) {
    return false;
  }
  if (!new_rtcp_sr) {
    // No new RTCP SR since last time this function was called.
    return true;
  }
  // Update extrapolator with the new arrival time.
  // The extrapolator assumes the TimeInMilliseconds time.
  int64_t receiver_arrival_time_ms = clock_->TimeInMilliseconds();
  int64_t sender_send_time_ms = Clock::NtpToMs(ntp_secs, ntp_frac);
  int64_t sender_arrival_time_90k = (sender_send_time_ms + rtt / 2) * 90;
  ts_extrapolator_->Update(receiver_arrival_time_ms, sender_arrival_time_90k);
  return true;
}

int64_t RemoteNtpTimeEstimator::Estimate(uint32_t rtp_timestamp) {
  int64_t sender_capture_ntp_ms = 0;
  if (!rtp_to_ntp_.Estimate(rtp_timestamp, &sender_capture_ntp_ms)) {
    return -1;
  }
  uint32_t timestamp = sender_capture_ntp_ms * 90;
  int64_t receiver_capture_ms =
      ts_extrapolator_->ExtrapolateLocalTime(timestamp);
  int64_t ntp_offset =
      clock_->CurrentNtpInMilliseconds() - clock_->TimeInMilliseconds();
  int64_t receiver_capture_ntp_ms = receiver_capture_ms + ntp_offset;
  int64_t now_ms = clock_->TimeInMilliseconds();
  if (now_ms - last_timing_log_ms_ > kTimingLogIntervalMs) {
    LOG(LS_INFO) << "RTP timestamp: " << rtp_timestamp
                 << " in NTP clock: " << sender_capture_ntp_ms
                 << " estimated time in receiver clock: " << receiver_capture_ms
                 << " converted to NTP clock: " << receiver_capture_ntp_ms;
    last_timing_log_ms_ = now_ms;
  }
  return receiver_capture_ntp_ms;
}

}  // namespace webrtc
