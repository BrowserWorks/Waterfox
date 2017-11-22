/*
 *  Copyright (c) 2016 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "webrtc/modules/audio_coding/audio_network_adaptor/controller_manager.h"

#include <cmath>
#include <utility>

#include "webrtc/base/ignore_wundef.h"
#include "webrtc/modules/audio_coding/audio_network_adaptor/bitrate_controller.h"
#include "webrtc/modules/audio_coding/audio_network_adaptor/channel_controller.h"
#include "webrtc/modules/audio_coding/audio_network_adaptor/dtx_controller.h"
#include "webrtc/modules/audio_coding/audio_network_adaptor/fec_controller.h"
#include "webrtc/modules/audio_coding/audio_network_adaptor/frame_length_controller.h"
#include "webrtc/system_wrappers/include/clock.h"

#ifdef WEBRTC_AUDIO_NETWORK_ADAPTOR_DEBUG_DUMP
RTC_PUSH_IGNORING_WUNDEF()
#ifdef WEBRTC_ANDROID_PLATFORM_BUILD
#include "external/webrtc/webrtc/modules/audio_coding/audio_network_adaptor/config.pb.h"
#else
#include "webrtc/modules/audio_coding/audio_network_adaptor/config.pb.h"
#endif
RTC_POP_IGNORING_WUNDEF()
#endif

namespace webrtc {

namespace {

#ifdef WEBRTC_AUDIO_NETWORK_ADAPTOR_DEBUG_DUMP

std::unique_ptr<FecController> CreateFecController(
    const audio_network_adaptor::config::FecController& config,
    bool initial_fec_enabled,
    const Clock* clock) {
  RTC_CHECK(config.has_fec_enabling_threshold());
  RTC_CHECK(config.has_fec_disabling_threshold());
  RTC_CHECK(config.has_time_constant_ms());

  auto& fec_enabling_threshold = config.fec_enabling_threshold();
  RTC_CHECK(fec_enabling_threshold.has_low_bandwidth_bps());
  RTC_CHECK(fec_enabling_threshold.has_low_bandwidth_packet_loss());
  RTC_CHECK(fec_enabling_threshold.has_high_bandwidth_bps());
  RTC_CHECK(fec_enabling_threshold.has_high_bandwidth_packet_loss());

  auto& fec_disabling_threshold = config.fec_disabling_threshold();
  RTC_CHECK(fec_disabling_threshold.has_low_bandwidth_bps());
  RTC_CHECK(fec_disabling_threshold.has_low_bandwidth_packet_loss());
  RTC_CHECK(fec_disabling_threshold.has_high_bandwidth_bps());
  RTC_CHECK(fec_disabling_threshold.has_high_bandwidth_packet_loss());

  return std::unique_ptr<FecController>(new FecController(FecController::Config(
      initial_fec_enabled,
      FecController::Config::Threshold(
          fec_enabling_threshold.low_bandwidth_bps(),
          fec_enabling_threshold.low_bandwidth_packet_loss(),
          fec_enabling_threshold.high_bandwidth_bps(),
          fec_enabling_threshold.high_bandwidth_packet_loss()),
      FecController::Config::Threshold(
          fec_disabling_threshold.low_bandwidth_bps(),
          fec_disabling_threshold.low_bandwidth_packet_loss(),
          fec_disabling_threshold.high_bandwidth_bps(),
          fec_disabling_threshold.high_bandwidth_packet_loss()),
      config.time_constant_ms(), clock)));
}

std::unique_ptr<FrameLengthController> CreateFrameLengthController(
    const audio_network_adaptor::config::FrameLengthController& config,
    rtc::ArrayView<const int> encoder_frame_lengths_ms,
    int initial_frame_length_ms) {
  RTC_CHECK(config.has_fl_increasing_packet_loss_fraction());
  RTC_CHECK(config.has_fl_decreasing_packet_loss_fraction());
  RTC_CHECK(config.has_fl_20ms_to_60ms_bandwidth_bps());
  RTC_CHECK(config.has_fl_60ms_to_20ms_bandwidth_bps());

  FrameLengthController::Config ctor_config(
      std::vector<int>(), initial_frame_length_ms,
      config.fl_increasing_packet_loss_fraction(),
      config.fl_decreasing_packet_loss_fraction(),
      config.fl_20ms_to_60ms_bandwidth_bps(),
      config.fl_60ms_to_20ms_bandwidth_bps());

  for (auto frame_length : encoder_frame_lengths_ms)
    ctor_config.encoder_frame_lengths_ms.push_back(frame_length);

  return std::unique_ptr<FrameLengthController>(
      new FrameLengthController(ctor_config));
}

std::unique_ptr<ChannelController> CreateChannelController(
    const audio_network_adaptor::config::ChannelController& config,
    size_t num_encoder_channels,
    size_t intial_channels_to_encode) {
  RTC_CHECK(config.has_channel_1_to_2_bandwidth_bps());
  RTC_CHECK(config.has_channel_2_to_1_bandwidth_bps());

  return std::unique_ptr<ChannelController>(new ChannelController(
      ChannelController::Config(num_encoder_channels, intial_channels_to_encode,
                                config.channel_1_to_2_bandwidth_bps(),
                                config.channel_2_to_1_bandwidth_bps())));
}

std::unique_ptr<DtxController> CreateDtxController(
    const audio_network_adaptor::config::DtxController& dtx_config,
    bool initial_dtx_enabled) {
  RTC_CHECK(dtx_config.has_dtx_enabling_bandwidth_bps());
  RTC_CHECK(dtx_config.has_dtx_disabling_bandwidth_bps());

  return std::unique_ptr<DtxController>(new DtxController(DtxController::Config(
      initial_dtx_enabled, dtx_config.dtx_enabling_bandwidth_bps(),
      dtx_config.dtx_disabling_bandwidth_bps())));
}

using audio_network_adaptor::BitrateController;
std::unique_ptr<BitrateController> CreateBitrateController(
    int initial_bitrate_bps,
    int initial_frame_length_ms) {
  return std::unique_ptr<BitrateController>(new BitrateController(
      BitrateController::Config(initial_bitrate_bps, initial_frame_length_ms)));
}
#endif  // WEBRTC_AUDIO_NETWORK_ADAPTOR_DEBUG_DUMP

}  // namespace

ControllerManagerImpl::Config::Config(int min_reordering_time_ms,
                                      float min_reordering_squared_distance,
                                      const Clock* clock)
    : min_reordering_time_ms(min_reordering_time_ms),
      min_reordering_squared_distance(min_reordering_squared_distance),
      clock(clock) {}

ControllerManagerImpl::Config::~Config() = default;

std::unique_ptr<ControllerManager> ControllerManagerImpl::Create(
    const std::string& config_string,
    size_t num_encoder_channels,
    rtc::ArrayView<const int> encoder_frame_lengths_ms,
    size_t intial_channels_to_encode,
    int initial_frame_length_ms,
    int initial_bitrate_bps,
    bool initial_fec_enabled,
    bool initial_dtx_enabled,
    const Clock* clock) {
#ifdef WEBRTC_AUDIO_NETWORK_ADAPTOR_DEBUG_DUMP
  audio_network_adaptor::config::ControllerManager controller_manager_config;
  controller_manager_config.ParseFromString(config_string);

  std::vector<std::unique_ptr<Controller>> controllers;
  std::map<const Controller*, std::pair<int, float>> chracteristic_points;

  for (int i = 0; i < controller_manager_config.controllers_size(); ++i) {
    auto& controller_config = controller_manager_config.controllers(i);
    std::unique_ptr<Controller> controller;
    switch (controller_config.controller_case()) {
      case audio_network_adaptor::config::Controller::kFecController:
        controller = CreateFecController(controller_config.fec_controller(),
                                         initial_fec_enabled, clock);
        break;
      case audio_network_adaptor::config::Controller::kFrameLengthController:
        controller = CreateFrameLengthController(
            controller_config.frame_length_controller(),
            encoder_frame_lengths_ms, initial_frame_length_ms);
        break;
      case audio_network_adaptor::config::Controller::kChannelController:
        controller = CreateChannelController(
            controller_config.channel_controller(), num_encoder_channels,
            intial_channels_to_encode);
        break;
      case audio_network_adaptor::config::Controller::kDtxController:
        controller = CreateDtxController(controller_config.dtx_controller(),
                                         initial_dtx_enabled);
        break;
      case audio_network_adaptor::config::Controller::kBitrateController:
        controller = CreateBitrateController(initial_bitrate_bps,
                                             initial_frame_length_ms);
        break;
      default:
        RTC_NOTREACHED();
    }
    if (controller_config.has_scoring_point()) {
      auto& characteristic_point = controller_config.scoring_point();
      RTC_CHECK(characteristic_point.has_uplink_bandwidth_bps());
      RTC_CHECK(characteristic_point.has_uplink_packet_loss_fraction());
      chracteristic_points[controller.get()] = std::make_pair<int, float>(
          characteristic_point.uplink_bandwidth_bps(),
          characteristic_point.uplink_packet_loss_fraction());
    }
    controllers.push_back(std::move(controller));
  }

  RTC_CHECK(controller_manager_config.has_min_reordering_time_ms());
  RTC_CHECK(controller_manager_config.has_min_reordering_squared_distance());
  return std::unique_ptr<ControllerManagerImpl>(new ControllerManagerImpl(
      ControllerManagerImpl::Config(
          controller_manager_config.min_reordering_time_ms(),
          controller_manager_config.min_reordering_squared_distance(), clock),
      std::move(controllers), chracteristic_points));
#else
  RTC_NOTREACHED();
  return nullptr;
#endif  // WEBRTC_AUDIO_NETWORK_ADAPTOR_DEBUG_DUMP
}

ControllerManagerImpl::ControllerManagerImpl(const Config& config)
    : ControllerManagerImpl(
          config,
          std::vector<std::unique_ptr<Controller>>(),
          std::map<const Controller*, std::pair<int, float>>()) {}

ControllerManagerImpl::ControllerManagerImpl(
    const Config& config,
    std::vector<std::unique_ptr<Controller>>&& controllers,
    const std::map<const Controller*, std::pair<int, float>>&
        chracteristic_points)
    : config_(config),
      controllers_(std::move(controllers)),
      last_reordering_time_ms_(rtc::Optional<int64_t>()),
      last_scoring_point_(0, 0.0) {
  for (auto& controller : controllers_)
    default_sorted_controllers_.push_back(controller.get());
  sorted_controllers_ = default_sorted_controllers_;
  for (auto& controller_point : chracteristic_points) {
    controller_scoring_points_.insert(std::make_pair(
        controller_point.first, ScoringPoint(controller_point.second.first,
                                             controller_point.second.second)));
  }
}

ControllerManagerImpl::~ControllerManagerImpl() = default;

std::vector<Controller*> ControllerManagerImpl::GetSortedControllers(
    const Controller::NetworkMetrics& metrics) {
  int64_t now_ms = config_.clock->TimeInMilliseconds();

  if (!metrics.uplink_bandwidth_bps || !metrics.uplink_packet_loss_fraction)
    return sorted_controllers_;

  if (last_reordering_time_ms_ &&
      now_ms - *last_reordering_time_ms_ < config_.min_reordering_time_ms)
    return sorted_controllers_;

  ScoringPoint scoring_point(*metrics.uplink_bandwidth_bps,
                             *metrics.uplink_packet_loss_fraction);

  if (last_reordering_time_ms_ &&
      last_scoring_point_.SquaredDistanceTo(scoring_point) <
          config_.min_reordering_squared_distance)
    return sorted_controllers_;

  // Sort controllers according to the distances of |scoring_point| to the
  // characteristic scoring points of controllers.
  //
  // A controller that does not associate with any scoring point
  // are treated as if
  // 1) they are less important than any controller that has a scoring point,
  // 2) they are equally important to any controller that has no scoring point,
  //    and their relative order will follow |default_sorted_controllers_|.
  std::vector<Controller*> sorted_controllers(default_sorted_controllers_);
  std::stable_sort(
      sorted_controllers.begin(), sorted_controllers.end(),
      [this, &scoring_point](const Controller* lhs, const Controller* rhs) {
        auto lhs_scoring_point = controller_scoring_points_.find(lhs);
        auto rhs_scoring_point = controller_scoring_points_.find(rhs);

        if (lhs_scoring_point == controller_scoring_points_.end())
          return false;

        if (rhs_scoring_point == controller_scoring_points_.end())
          return true;

        return lhs_scoring_point->second.SquaredDistanceTo(scoring_point) <
               rhs_scoring_point->second.SquaredDistanceTo(scoring_point);
      });

  if (sorted_controllers_ != sorted_controllers) {
    sorted_controllers_ = sorted_controllers;
    last_reordering_time_ms_ = rtc::Optional<int64_t>(now_ms);
    last_scoring_point_ = scoring_point;
  }
  return sorted_controllers_;
}

std::vector<Controller*> ControllerManagerImpl::GetControllers() const {
  return default_sorted_controllers_;
}

ControllerManagerImpl::ScoringPoint::ScoringPoint(
    int uplink_bandwidth_bps,
    float uplink_packet_loss_fraction)
    : uplink_bandwidth_bps(uplink_bandwidth_bps),
      uplink_packet_loss_fraction(uplink_packet_loss_fraction) {}

namespace {

constexpr int kMinUplinkBandwidthBps = 0;
constexpr int kMaxUplinkBandwidthBps = 120000;

float NormalizeUplinkBandwidth(int uplink_bandwidth_bps) {
  uplink_bandwidth_bps =
      std::min(kMaxUplinkBandwidthBps,
               std::max(kMinUplinkBandwidthBps, uplink_bandwidth_bps));
  return static_cast<float>(uplink_bandwidth_bps - kMinUplinkBandwidthBps) /
         (kMaxUplinkBandwidthBps - kMinUplinkBandwidthBps);
}

float NormalizePacketLossFraction(float uplink_packet_loss_fraction) {
  // |uplink_packet_loss_fraction| is seldom larger than 0.3, so we scale it up
  // by 3.3333f.
  return std::min(uplink_packet_loss_fraction * 3.3333f, 1.0f);
}

}  // namespace

float ControllerManagerImpl::ScoringPoint::SquaredDistanceTo(
    const ScoringPoint& scoring_point) const {
  float diff_normalized_bitrate_bps =
      NormalizeUplinkBandwidth(scoring_point.uplink_bandwidth_bps) -
      NormalizeUplinkBandwidth(uplink_bandwidth_bps);
  float diff_normalized_packet_loss =
      NormalizePacketLossFraction(scoring_point.uplink_packet_loss_fraction) -
      NormalizePacketLossFraction(uplink_packet_loss_fraction);
  return std::pow(diff_normalized_bitrate_bps, 2) +
         std::pow(diff_normalized_packet_loss, 2);
}

}  // namespace webrtc
