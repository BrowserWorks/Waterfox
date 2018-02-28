/*
 *  Copyright (c) 2016 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include <utility>

#include "webrtc/base/ignore_wundef.h"
#include "webrtc/modules/audio_coding/audio_network_adaptor/controller_manager.h"
#include "webrtc/modules/audio_coding/audio_network_adaptor/mock/mock_controller.h"
#include "webrtc/system_wrappers/include/clock.h"
#include "webrtc/test/gtest.h"

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

using ::testing::NiceMock;

namespace {

constexpr size_t kNumControllers = 4;
constexpr int kChracteristicBandwithBps[2] = {15000, 0};
constexpr float kChracteristicPacketLossFraction[2] = {0.2f, 0.0f};
constexpr int kMinReorderingTimeMs = 200;
constexpr int kFactor = 100;
constexpr float kMinReorderingSquareDistance = 1.0f / kFactor / kFactor;

// |kMinUplinkBandwidthBps| and |kMaxUplinkBandwidthBps| are copied from
// controller_manager.cc
constexpr int kMinUplinkBandwidthBps = 0;
constexpr int kMaxUplinkBandwidthBps = 120000;
constexpr int kMinBandwithChangeBps =
    (kMaxUplinkBandwidthBps - kMinUplinkBandwidthBps) / kFactor;

constexpr int64_t kClockInitialTime = 123456789;

struct ControllerManagerStates {
  std::unique_ptr<ControllerManager> controller_manager;
  std::vector<MockController*> mock_controllers;
  std::unique_ptr<SimulatedClock> simulated_clock;
};

ControllerManagerStates CreateControllerManager() {
  ControllerManagerStates states;
  std::vector<std::unique_ptr<Controller>> controllers;
  std::map<const Controller*, std::pair<int, float>> chracteristic_points;
  for (size_t i = 0; i < kNumControllers; ++i) {
    auto controller =
        std::unique_ptr<MockController>(new NiceMock<MockController>());
    EXPECT_CALL(*controller, Die());
    states.mock_controllers.push_back(controller.get());
    controllers.push_back(std::move(controller));
  }

  // Assign characteristic points to the last two controllers.
  chracteristic_points[states.mock_controllers[kNumControllers - 2]] =
      std::make_pair(kChracteristicBandwithBps[0],
                     kChracteristicPacketLossFraction[0]);
  chracteristic_points[states.mock_controllers[kNumControllers - 1]] =
      std::make_pair(kChracteristicBandwithBps[1],
                     kChracteristicPacketLossFraction[1]);

  states.simulated_clock.reset(new SimulatedClock(kClockInitialTime));
  states.controller_manager.reset(new ControllerManagerImpl(
      ControllerManagerImpl::Config(kMinReorderingTimeMs,
                                    kMinReorderingSquareDistance,
                                    states.simulated_clock.get()),
      std::move(controllers), chracteristic_points));
  return states;
}

// |expected_order| contains the expected indices of all controllers in the
// vector of controllers returned by GetSortedControllers(). A negative index
// means that we do not care about its exact place, but we do check that it
// exists in the vector.
void CheckControllersOrder(
    ControllerManagerStates* states,
    const rtc::Optional<int>& uplink_bandwidth_bps,
    const rtc::Optional<float>& uplink_packet_loss_fraction,
    const std::vector<int>& expected_order) {
  RTC_DCHECK_EQ(kNumControllers, expected_order.size());
  Controller::NetworkMetrics metrics;
  metrics.uplink_bandwidth_bps = uplink_bandwidth_bps;
  metrics.uplink_packet_loss_fraction = uplink_packet_loss_fraction;
  auto check = states->controller_manager->GetSortedControllers(metrics);
  EXPECT_EQ(states->mock_controllers.size(), check.size());
  for (size_t i = 0; i < states->mock_controllers.size(); ++i) {
    if (expected_order[i] >= 0) {
      EXPECT_EQ(states->mock_controllers[i], check[expected_order[i]]);
    } else {
      EXPECT_NE(check.end(), std::find(check.begin(), check.end(),
                                       states->mock_controllers[i]));
    }
  }
}

}  // namespace

TEST(ControllerManagerTest, GetControllersReturnAllControllers) {
  auto states = CreateControllerManager();
  auto check = states.controller_manager->GetControllers();
  // Verify that controllers in |check| are one-to-one mapped to those in
  // |mock_controllers_|.
  EXPECT_EQ(states.mock_controllers.size(), check.size());
  for (auto& controller : check)
    EXPECT_NE(states.mock_controllers.end(),
              std::find(states.mock_controllers.begin(),
                        states.mock_controllers.end(), controller));
}

TEST(ControllerManagerTest, ControllersInDefaultOrderOnEmptyNetworkMetrics) {
  auto states = CreateControllerManager();
  // |network_metrics| are empty, and the controllers are supposed to follow the
  // default order.
  CheckControllersOrder(&states, rtc::Optional<int>(), rtc::Optional<float>(),
                        {0, 1, 2, 3});
}

TEST(ControllerManagerTest, ControllersWithoutCharPointAtEndAndInDefaultOrder) {
  auto states = CreateControllerManager();
  CheckControllersOrder(&states, rtc::Optional<int>(0),
                        rtc::Optional<float>(0.0),
                        {kNumControllers - 2, kNumControllers - 1, -1, -1});
}

TEST(ControllerManagerTest, ControllersWithCharPointDependOnNetworkMetrics) {
  auto states = CreateControllerManager();
  CheckControllersOrder(
      &states, rtc::Optional<int>(kChracteristicBandwithBps[1]),
      rtc::Optional<float>(kChracteristicPacketLossFraction[1]),
      {kNumControllers - 2, kNumControllers - 1, 1, 0});
}

TEST(ControllerManagerTest, DoNotReorderBeforeMinReordingTime) {
  auto states = CreateControllerManager();
  CheckControllersOrder(
      &states, rtc::Optional<int>(kChracteristicBandwithBps[0]),
      rtc::Optional<float>(kChracteristicPacketLossFraction[0]),
      {kNumControllers - 2, kNumControllers - 1, 0, 1});
  states.simulated_clock->AdvanceTimeMilliseconds(kMinReorderingTimeMs - 1);
  // Move uplink bandwidth and packet loss fraction to the other controller's
  // characteristic point, which would cause controller manager to reorder the
  // controllers if time had reached min reordering time.
  CheckControllersOrder(
      &states, rtc::Optional<int>(kChracteristicBandwithBps[1]),
      rtc::Optional<float>(kChracteristicPacketLossFraction[1]),
      {kNumControllers - 2, kNumControllers - 1, 0, 1});
}

TEST(ControllerManagerTest, ReorderBeyondMinReordingTimeAndMinDistance) {
  auto states = CreateControllerManager();
  constexpr int kBandwidthBps =
      (kChracteristicBandwithBps[0] + kChracteristicBandwithBps[1]) / 2;
  constexpr float kPacketLossFraction = (kChracteristicPacketLossFraction[0] +
                                         kChracteristicPacketLossFraction[1]) /
                                        2.0f;
  // Set network metrics to be in the middle between the characteristic points
  // of two controllers.
  CheckControllersOrder(&states, rtc::Optional<int>(kBandwidthBps),
                        rtc::Optional<float>(kPacketLossFraction),
                        {kNumControllers - 2, kNumControllers - 1, 0, 1});
  states.simulated_clock->AdvanceTimeMilliseconds(kMinReorderingTimeMs);
  // Then let network metrics move a little towards the other controller.
  CheckControllersOrder(
      &states, rtc::Optional<int>(kBandwidthBps - kMinBandwithChangeBps - 1),
      rtc::Optional<float>(kPacketLossFraction),
      {kNumControllers - 2, kNumControllers - 1, 1, 0});
}

TEST(ControllerManagerTest, DoNotReorderIfNetworkMetricsChangeTooSmall) {
  auto states = CreateControllerManager();
  constexpr int kBandwidthBps =
      (kChracteristicBandwithBps[0] + kChracteristicBandwithBps[1]) / 2;
  constexpr float kPacketLossFraction = (kChracteristicPacketLossFraction[0] +
                                         kChracteristicPacketLossFraction[1]) /
                                        2.0f;
  // Set network metrics to be in the middle between the characteristic points
  // of two controllers.
  CheckControllersOrder(&states, rtc::Optional<int>(kBandwidthBps),
                        rtc::Optional<float>(kPacketLossFraction),
                        {kNumControllers - 2, kNumControllers - 1, 0, 1});
  states.simulated_clock->AdvanceTimeMilliseconds(kMinReorderingTimeMs);
  // Then let network metrics move a little towards the other controller.
  CheckControllersOrder(
      &states, rtc::Optional<int>(kBandwidthBps - kMinBandwithChangeBps + 1),
      rtc::Optional<float>(kPacketLossFraction),
      {kNumControllers - 2, kNumControllers - 1, 0, 1});
}

#ifdef WEBRTC_AUDIO_NETWORK_ADAPTOR_DEBUG_DUMP

namespace {

void AddBitrateControllerConfig(
    audio_network_adaptor::config::ControllerManager* config) {
  config->add_controllers()->mutable_bitrate_controller();
}

void AddChannelControllerConfig(
    audio_network_adaptor::config::ControllerManager* config) {
  auto controller_config =
      config->add_controllers()->mutable_channel_controller();
  controller_config->set_channel_1_to_2_bandwidth_bps(31000);
  controller_config->set_channel_2_to_1_bandwidth_bps(29000);
}

void AddDtxControllerConfig(
    audio_network_adaptor::config::ControllerManager* config) {
  auto controller_config = config->add_controllers()->mutable_dtx_controller();
  controller_config->set_dtx_enabling_bandwidth_bps(55000);
  controller_config->set_dtx_disabling_bandwidth_bps(65000);
}

void AddFecControllerConfig(
    audio_network_adaptor::config::ControllerManager* config) {
  auto controller_config_ext = config->add_controllers();
  auto controller_config = controller_config_ext->mutable_fec_controller();
  auto fec_enabling_threshold =
      controller_config->mutable_fec_enabling_threshold();
  fec_enabling_threshold->set_low_bandwidth_bps(17000);
  fec_enabling_threshold->set_low_bandwidth_packet_loss(0.1f);
  fec_enabling_threshold->set_high_bandwidth_bps(64000);
  fec_enabling_threshold->set_high_bandwidth_packet_loss(0.05f);
  auto fec_disabling_threshold =
      controller_config->mutable_fec_disabling_threshold();
  fec_disabling_threshold->set_low_bandwidth_bps(15000);
  fec_disabling_threshold->set_low_bandwidth_packet_loss(0.08f);
  fec_disabling_threshold->set_high_bandwidth_bps(64000);
  fec_disabling_threshold->set_high_bandwidth_packet_loss(0.01f);
  controller_config->set_time_constant_ms(500);

  auto scoring_point = controller_config_ext->mutable_scoring_point();
  scoring_point->set_uplink_bandwidth_bps(kChracteristicBandwithBps[0]);
  scoring_point->set_uplink_packet_loss_fraction(
      kChracteristicPacketLossFraction[0]);
}

void AddFrameLengthControllerConfig(
    audio_network_adaptor::config::ControllerManager* config) {
  auto controller_config_ext = config->add_controllers();
  auto controller_config =
      controller_config_ext->mutable_frame_length_controller();
  controller_config->set_fl_decreasing_packet_loss_fraction(0.05f);
  controller_config->set_fl_increasing_packet_loss_fraction(0.04f);
  controller_config->set_fl_20ms_to_60ms_bandwidth_bps(72000);
  controller_config->set_fl_60ms_to_20ms_bandwidth_bps(88000);

  auto scoring_point = controller_config_ext->mutable_scoring_point();
  scoring_point->set_uplink_bandwidth_bps(kChracteristicBandwithBps[1]);
  scoring_point->set_uplink_packet_loss_fraction(
      kChracteristicPacketLossFraction[1]);
}

constexpr int kInitialBitrateBps = 24000;
constexpr size_t kIntialChannelsToEncode = 1;
constexpr bool kInitialDtxEnabled = true;
constexpr bool kInitialFecEnabled = true;
constexpr int kInitialFrameLengthMs = 60;

ControllerManagerStates CreateControllerManager(
    const std::string& config_string) {
  ControllerManagerStates states;
  states.simulated_clock.reset(new SimulatedClock(kClockInitialTime));
  constexpr size_t kNumEncoderChannels = 2;
  const std::vector<int> encoder_frame_lengths_ms = {20, 60};
  states.controller_manager = ControllerManagerImpl::Create(
      config_string, kNumEncoderChannels, encoder_frame_lengths_ms,
      kIntialChannelsToEncode, kInitialFrameLengthMs, kInitialBitrateBps,
      kInitialFecEnabled, kInitialDtxEnabled, states.simulated_clock.get());
  return states;
}

enum class ControllerType : int8_t {
  FEC,
  CHANNEL,
  DTX,
  FRAME_LENGTH,
  BIT_RATE
};

void CheckControllersOrder(const std::vector<Controller*>& controllers,
                           const std::vector<ControllerType>& expected_types) {
  ASSERT_EQ(expected_types.size(), controllers.size());

  // We also check that the controllers follow the initial settings.
  AudioNetworkAdaptor::EncoderRuntimeConfig encoder_config;

  // We do not check the internal logic of controllers. We only check that
  // when no network metrics are known, controllers provide the initial values.
  Controller::NetworkMetrics metrics;

  for (size_t i = 0; i < controllers.size(); ++i) {
    AudioNetworkAdaptor::EncoderRuntimeConfig encoder_config;
    // We check the order of |controllers| by judging their decisions.
    controllers[i]->MakeDecision(metrics, &encoder_config);
    switch (expected_types[i]) {
      case ControllerType::FEC:
        EXPECT_EQ(rtc::Optional<bool>(kInitialFecEnabled),
                  encoder_config.enable_fec);
        break;
      case ControllerType::CHANNEL:
        EXPECT_EQ(rtc::Optional<size_t>(kIntialChannelsToEncode),
                  encoder_config.num_channels);
        break;
      case ControllerType::DTX:
        EXPECT_EQ(rtc::Optional<bool>(kInitialDtxEnabled),
                  encoder_config.enable_dtx);
        break;
      case ControllerType::FRAME_LENGTH:
        EXPECT_EQ(rtc::Optional<int>(kInitialFrameLengthMs),
                  encoder_config.frame_length_ms);
        break;
      case ControllerType::BIT_RATE:
        EXPECT_EQ(rtc::Optional<int>(kInitialBitrateBps),
                  encoder_config.bitrate_bps);
    }
  }
}

}  // namespace

TEST(ControllerManagerTest, CreateFromConfigStringAndCheckDefaultOrder) {
  audio_network_adaptor::config::ControllerManager config;
  config.set_min_reordering_time_ms(kMinReorderingTimeMs);
  config.set_min_reordering_squared_distance(kMinReorderingSquareDistance);

  AddFecControllerConfig(&config);
  AddChannelControllerConfig(&config);
  AddDtxControllerConfig(&config);
  AddFrameLengthControllerConfig(&config);
  AddBitrateControllerConfig(&config);

  std::string config_string;
  config.SerializeToString(&config_string);

  auto states = CreateControllerManager(config_string);
  Controller::NetworkMetrics metrics;

  auto controllers = states.controller_manager->GetSortedControllers(metrics);
  CheckControllersOrder(
      controllers,
      std::vector<ControllerType>{
          ControllerType::FEC, ControllerType::CHANNEL, ControllerType::DTX,
          ControllerType::FRAME_LENGTH, ControllerType::BIT_RATE});
}

TEST(ControllerManagerTest, CreateFromConfigStringAndCheckReordering) {
  audio_network_adaptor::config::ControllerManager config;
  config.set_min_reordering_time_ms(kMinReorderingTimeMs);
  config.set_min_reordering_squared_distance(kMinReorderingSquareDistance);

  AddChannelControllerConfig(&config);

  // Internally associated with characteristic point 0.
  AddFecControllerConfig(&config);

  AddDtxControllerConfig(&config);

  // Internally associated with characteristic point 1.
  AddFrameLengthControllerConfig(&config);

  AddBitrateControllerConfig(&config);

  std::string config_string;
  config.SerializeToString(&config_string);

  auto states = CreateControllerManager(config_string);

  Controller::NetworkMetrics metrics;
  metrics.uplink_bandwidth_bps =
      rtc::Optional<int>(kChracteristicBandwithBps[0]);
  metrics.uplink_packet_loss_fraction =
      rtc::Optional<float>(kChracteristicPacketLossFraction[0]);

  auto controllers = states.controller_manager->GetSortedControllers(metrics);
  CheckControllersOrder(controllers,
                        std::vector<ControllerType>{
                            ControllerType::FEC, ControllerType::FRAME_LENGTH,
                            ControllerType::CHANNEL, ControllerType::DTX,
                            ControllerType::BIT_RATE});

  metrics.uplink_bandwidth_bps =
      rtc::Optional<int>(kChracteristicBandwithBps[1]);
  metrics.uplink_packet_loss_fraction =
      rtc::Optional<float>(kChracteristicPacketLossFraction[1]);
  states.simulated_clock->AdvanceTimeMilliseconds(kMinReorderingTimeMs - 1);
  controllers = states.controller_manager->GetSortedControllers(metrics);
  // Should not reorder since min reordering time is not met.
  CheckControllersOrder(controllers,
                        std::vector<ControllerType>{
                            ControllerType::FEC, ControllerType::FRAME_LENGTH,
                            ControllerType::CHANNEL, ControllerType::DTX,
                            ControllerType::BIT_RATE});

  states.simulated_clock->AdvanceTimeMilliseconds(1);
  controllers = states.controller_manager->GetSortedControllers(metrics);
  // Reorder now.
  CheckControllersOrder(controllers,
                        std::vector<ControllerType>{
                            ControllerType::FRAME_LENGTH, ControllerType::FEC,
                            ControllerType::CHANNEL, ControllerType::DTX,
                            ControllerType::BIT_RATE});
}
#endif  // WEBRTC_AUDIO_NETWORK_ADAPTOR_DEBUG_DUMP

}  // namespace webrtc
