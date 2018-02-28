/*
 *  Copyright (c) 2014 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "webrtc/modules/remote_bitrate_estimator/aimd_rate_control.h"

#include <algorithm>
#include <cassert>
#include <cmath>

#include "webrtc/base/checks.h"

#include "webrtc/modules/remote_bitrate_estimator/overuse_detector.h"
#include "webrtc/modules/remote_bitrate_estimator/include/bwe_defines.h"
#include "webrtc/modules/remote_bitrate_estimator/include/remote_bitrate_estimator.h"
#include "webrtc/modules/remote_bitrate_estimator/test/bwe_test_logging.h"

namespace webrtc {

static const int64_t kDefaultRttMs = 200;
static const int64_t kMaxFeedbackIntervalMs = 1000;

AimdRateControl::AimdRateControl()
    : min_configured_bitrate_bps_(congestion_controller::GetMinBitrateBps()),
      max_configured_bitrate_bps_(30000000),
      current_bitrate_bps_(max_configured_bitrate_bps_),
      avg_max_bitrate_kbps_(-1.0f),
      var_max_bitrate_kbps_(0.4f),
      rate_control_state_(kRcHold),
      rate_control_region_(kRcMaxUnknown),
      time_last_bitrate_change_(-1),
      current_input_(kBwNormal, rtc::Optional<uint32_t>(), 1.0),
      updated_(false),
      time_first_incoming_estimate_(-1),
      bitrate_is_initialized_(false),
      beta_(0.85f),
      rtt_(kDefaultRttMs),
      in_experiment_(!AdaptiveThresholdExperimentIsDisabled()) {}

void AimdRateControl::SetMinBitrate(int min_bitrate_bps) {
  min_configured_bitrate_bps_ = min_bitrate_bps;
  current_bitrate_bps_ = std::max<int>(min_bitrate_bps, current_bitrate_bps_);
}

bool AimdRateControl::ValidEstimate() const {
  return bitrate_is_initialized_;
}

int64_t AimdRateControl::GetFeedbackInterval() const {
  // Estimate how often we can send RTCP if we allocate up to 5% of bandwidth
  // to feedback.
  static const int kRtcpSize = 80;
  int64_t interval = static_cast<int64_t>(
      kRtcpSize * 8.0 * 1000.0 / (0.05 * current_bitrate_bps_) + 0.5);
  const int64_t kMinFeedbackIntervalMs = 200;
  return std::min(std::max(interval, kMinFeedbackIntervalMs),
                  kMaxFeedbackIntervalMs);
}

bool AimdRateControl::TimeToReduceFurther(int64_t time_now,
                                          uint32_t incoming_bitrate_bps) const {
  const int64_t bitrate_reduction_interval =
      std::max<int64_t>(std::min<int64_t>(rtt_, 200), 10);
  if (time_now - time_last_bitrate_change_ >= bitrate_reduction_interval) {
    return true;
  }
  if (ValidEstimate()) {
    // TODO(terelius/holmer): Investigate consequences of increasing
    // the threshold to 0.95 * LatestEstimate().
    const uint32_t threshold = static_cast<uint32_t> (0.5 * LatestEstimate());
    return incoming_bitrate_bps < threshold;
  }
  return false;
}

uint32_t AimdRateControl::LatestEstimate() const {
  return current_bitrate_bps_;
}

uint32_t AimdRateControl::UpdateBandwidthEstimate(int64_t now_ms) {
  current_bitrate_bps_ = ChangeBitrate(
      current_bitrate_bps_,
      current_input_.incoming_bitrate.value_or(current_bitrate_bps_), now_ms);
  return current_bitrate_bps_;
}

void AimdRateControl::SetRtt(int64_t rtt) {
  rtt_ = rtt;
}

void AimdRateControl::Update(const RateControlInput* input, int64_t now_ms) {
  RTC_CHECK(input);

  // Set the initial bit rate value to what we're receiving the first half
  // second.
  if (!bitrate_is_initialized_) {
    const int64_t kInitializationTimeMs = 5000;
    RTC_DCHECK_LE(kBitrateWindowMs, kInitializationTimeMs);
    if (time_first_incoming_estimate_ < 0) {
      if (input->incoming_bitrate)
        time_first_incoming_estimate_ = now_ms;
    } else if (now_ms - time_first_incoming_estimate_ > kInitializationTimeMs &&
               input->incoming_bitrate) {
      current_bitrate_bps_ = *input->incoming_bitrate;
      bitrate_is_initialized_ = true;
    }
  }

  if (updated_ && current_input_.bw_state == kBwOverusing) {
    // Only update delay factor and incoming bit rate. We always want to react
    // on an over-use.
    current_input_.noise_var = input->noise_var;
    current_input_.incoming_bitrate = input->incoming_bitrate;
  } else {
    updated_ = true;
    current_input_ = *input;
  }
}

void AimdRateControl::SetEstimate(int bitrate_bps, int64_t now_ms) {
  updated_ = true;
  bitrate_is_initialized_ = true;
  current_bitrate_bps_ = ChangeBitrate(bitrate_bps, bitrate_bps, now_ms);
}

int AimdRateControl::GetNearMaxIncreaseRateBps() const {
  RTC_DCHECK_GT(current_bitrate_bps_, 0);
  double bits_per_frame = static_cast<double>(current_bitrate_bps_) / 30.0;
  double packets_per_frame = std::ceil(bits_per_frame / (8.0 * 1200.0));
  double avg_packet_size_bits = bits_per_frame / packets_per_frame;
  // Approximate the over-use estimator delay to 100 ms.
  const int64_t response_time = in_experiment_ ? (rtt_ + 100) * 2 : rtt_ + 100;

  constexpr double kMinIncreaseRateBps = 4000;
  return static_cast<int>(std::max(
      kMinIncreaseRateBps, (avg_packet_size_bits * 1000) / response_time));
}

rtc::Optional<int> AimdRateControl::GetLastBitrateDecreaseBps() const {
  return last_decrease_;
}

uint32_t AimdRateControl::ChangeBitrate(uint32_t current_bitrate_bps,
                                        uint32_t incoming_bitrate_bps,
                                        int64_t now_ms) {
  if (!updated_) {
    return current_bitrate_bps_;
  }
  // An over-use should always trigger us to reduce the bitrate, even though
  // we have not yet established our first estimate. By acting on the over-use,
  // we will end up with a valid estimate.
  if (!bitrate_is_initialized_ && current_input_.bw_state != kBwOverusing)
    return current_bitrate_bps_;
  updated_ = false;
  ChangeState(current_input_, now_ms);
  // Calculated here because it's used in multiple places.
  const float incoming_bitrate_kbps = incoming_bitrate_bps / 1000.0f;
  // Calculate the max bit rate std dev given the normalized
  // variance and the current incoming bit rate.
  const float std_max_bit_rate = sqrt(var_max_bitrate_kbps_ *
                                      avg_max_bitrate_kbps_);
  switch (rate_control_state_) {
    case kRcHold:
      break;

    case kRcIncrease:
      if (avg_max_bitrate_kbps_ >= 0 &&
          incoming_bitrate_kbps >
              avg_max_bitrate_kbps_ + 3 * std_max_bit_rate) {
        ChangeRegion(kRcMaxUnknown);
        avg_max_bitrate_kbps_ = -1.0;
      }
      if (rate_control_region_ == kRcNearMax) {
        uint32_t additive_increase_bps =
            AdditiveRateIncrease(now_ms, time_last_bitrate_change_);
        current_bitrate_bps += additive_increase_bps;
      } else {
        uint32_t multiplicative_increase_bps = MultiplicativeRateIncrease(
            now_ms, time_last_bitrate_change_, current_bitrate_bps);
        current_bitrate_bps += multiplicative_increase_bps;
      }

      time_last_bitrate_change_ = now_ms;
      break;

    case kRcDecrease:
      bitrate_is_initialized_ = true;
      if (incoming_bitrate_bps < min_configured_bitrate_bps_) {
        current_bitrate_bps = min_configured_bitrate_bps_;
      } else {
        // Set bit rate to something slightly lower than max
        // to get rid of any self-induced delay.
        current_bitrate_bps = static_cast<uint32_t>(beta_ *
                                                    incoming_bitrate_bps + 0.5);
        if (current_bitrate_bps > current_bitrate_bps_) {
          // Avoid increasing the rate when over-using.
          if (rate_control_region_ != kRcMaxUnknown) {
            current_bitrate_bps = static_cast<uint32_t>(
                beta_ * avg_max_bitrate_kbps_ * 1000 + 0.5f);
          }
          current_bitrate_bps = std::min(current_bitrate_bps,
                                         current_bitrate_bps_);
        }
        ChangeRegion(kRcNearMax);

        if (incoming_bitrate_bps < current_bitrate_bps_) {
          last_decrease_ =
              rtc::Optional<int>(current_bitrate_bps_ - current_bitrate_bps);
        }
        if (incoming_bitrate_kbps < avg_max_bitrate_kbps_ -
            3 * std_max_bit_rate) {
          avg_max_bitrate_kbps_ = -1.0f;
        }

        UpdateMaxBitRateEstimate(incoming_bitrate_kbps);
      }
      // Stay on hold until the pipes are cleared.
      ChangeState(kRcHold);
      time_last_bitrate_change_ = now_ms;
      break;

    default:
      assert(false);
  }
  // Don't change the bit rate if the send side is too far off.
  // We allow a bit more lag at very low rates to not too easily get stuck if
  // the encoder produces uneven outputs.
  const uint32_t max_bitrate_bps =
      static_cast<uint32_t>(1.5f * incoming_bitrate_bps) + 10000;
  if (current_bitrate_bps > current_bitrate_bps_ &&
      current_bitrate_bps > max_bitrate_bps) {
    current_bitrate_bps = std::max(current_bitrate_bps_, max_bitrate_bps);
    time_last_bitrate_change_ = now_ms;
  }
  return current_bitrate_bps;
}

uint32_t AimdRateControl::MultiplicativeRateIncrease(
    int64_t now_ms, int64_t last_ms, uint32_t current_bitrate_bps) const {
  double alpha = 1.08;
  if (last_ms > -1) {
    int time_since_last_update_ms = std::min(static_cast<int>(now_ms - last_ms),
                                             1000);
    alpha = pow(alpha,  time_since_last_update_ms / 1000.0);
  }
  uint32_t multiplicative_increase_bps = std::max(
      current_bitrate_bps * (alpha - 1.0), 1000.0);
  return multiplicative_increase_bps;
}

uint32_t AimdRateControl::AdditiveRateIncrease(int64_t now_ms,
                                               int64_t last_ms) const {
  return static_cast<uint32_t>((now_ms - last_ms) *
                               GetNearMaxIncreaseRateBps() / 1000);
}

void AimdRateControl::UpdateMaxBitRateEstimate(float incoming_bitrate_kbps) {
  const float alpha = 0.05f;
  if (avg_max_bitrate_kbps_ == -1.0f) {
    avg_max_bitrate_kbps_ = incoming_bitrate_kbps;
  } else {
    avg_max_bitrate_kbps_ = (1 - alpha) * avg_max_bitrate_kbps_ +
        alpha * incoming_bitrate_kbps;
  }
  // Estimate the max bit rate variance and normalize the variance
  // with the average max bit rate.
  const float norm = std::max(avg_max_bitrate_kbps_, 1.0f);
  var_max_bitrate_kbps_ = (1 - alpha) * var_max_bitrate_kbps_ +
      alpha * (avg_max_bitrate_kbps_ - incoming_bitrate_kbps) *
          (avg_max_bitrate_kbps_ - incoming_bitrate_kbps) / norm;
  // 0.4 ~= 14 kbit/s at 500 kbit/s
  if (var_max_bitrate_kbps_ < 0.4f) {
    var_max_bitrate_kbps_ = 0.4f;
  }
  // 2.5f ~= 35 kbit/s at 500 kbit/s
  if (var_max_bitrate_kbps_ > 2.5f) {
    var_max_bitrate_kbps_ = 2.5f;
  }
}

void AimdRateControl::ChangeState(const RateControlInput& input,
                                  int64_t now_ms) {
  switch (current_input_.bw_state) {
    case kBwNormal:
      if (rate_control_state_ == kRcHold) {
        time_last_bitrate_change_ = now_ms;
        ChangeState(kRcIncrease);
      }
      break;
    case kBwOverusing:
      if (rate_control_state_ != kRcDecrease) {
        ChangeState(kRcDecrease);
      }
      break;
    case kBwUnderusing:
      ChangeState(kRcHold);
      break;
    default:
      assert(false);
  }
}

void AimdRateControl::ChangeRegion(RateControlRegion region) {
  rate_control_region_ = region;
}

void AimdRateControl::ChangeState(RateControlState new_state) {
  rate_control_state_ = new_state;
}
}  // namespace webrtc
