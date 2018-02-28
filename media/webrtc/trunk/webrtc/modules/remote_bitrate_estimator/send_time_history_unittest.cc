/*
 *  Copyright (c) 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include <algorithm>
#include <limits>
#include <vector>

#include "webrtc/modules/remote_bitrate_estimator/include/send_time_history.h"
#include "webrtc/modules/rtp_rtcp/include/rtp_rtcp_defines.h"
#include "webrtc/system_wrappers/include/clock.h"
#include "webrtc/test/gtest.h"

namespace webrtc {
namespace test {

static const int kDefaultHistoryLengthMs = 1000;

class SendTimeHistoryTest : public ::testing::Test {
 protected:
  SendTimeHistoryTest()
      : clock_(0), history_(&clock_, kDefaultHistoryLengthMs) {}
  ~SendTimeHistoryTest() {}

  virtual void SetUp() {}

  virtual void TearDown() {}

  void AddPacketWithSendTime(uint16_t sequence_number,
                             size_t length,
                             int64_t send_time_ms,
                             int probe_cluster_id) {
    history_.AddAndRemoveOld(sequence_number, length, probe_cluster_id);
    history_.OnSentPacket(sequence_number, send_time_ms);
  }

  webrtc::SimulatedClock clock_;
  SendTimeHistory history_;
};

// Help class extended so we can do EXPECT_EQ and collections.
class PacketInfo : public webrtc::PacketInfo {
 public:
  PacketInfo(int64_t arrival_time_ms, uint16_t sequence_number)
      : PacketInfo(arrival_time_ms,
                   0,
                   sequence_number,
                   0,
                   PacketInfo::kNotAProbe) {}
  PacketInfo(int64_t arrival_time_ms,
             int64_t send_time_ms,
             uint16_t sequence_number,
             size_t payload_size,
             int probe_cluster_id)
      : webrtc::PacketInfo(-1,
                           arrival_time_ms,
                           send_time_ms,
                           sequence_number,
                           payload_size,
                           probe_cluster_id) {}
  bool operator==(const PacketInfo& other) const {
    return arrival_time_ms == other.arrival_time_ms &&
           send_time_ms == other.send_time_ms &&
           sequence_number == other.sequence_number &&
           payload_size == other.payload_size &&
           probe_cluster_id == other.probe_cluster_id;
  }
};

TEST_F(SendTimeHistoryTest, AddRemoveOne) {
  const uint16_t kSeqNo = 10;
  const int kProbeClusterId = 0;
  const PacketInfo kSentPacket(0, 1, kSeqNo, 1, kProbeClusterId);
  AddPacketWithSendTime(kSeqNo, 1, 1, kProbeClusterId);

  PacketInfo received_packet(0, 0, kSeqNo, 0, kProbeClusterId);
  EXPECT_TRUE(history_.GetInfo(&received_packet, false));
  EXPECT_EQ(kSentPacket, received_packet);

  PacketInfo received_packet2(0, 0, kSeqNo, 0, kProbeClusterId);
  EXPECT_TRUE(history_.GetInfo(&received_packet2, true));
  EXPECT_EQ(kSentPacket, received_packet2);

  PacketInfo received_packet3(0, 0, kSeqNo, 0, kProbeClusterId);
  EXPECT_FALSE(history_.GetInfo(&received_packet3, true));
}

TEST_F(SendTimeHistoryTest, PopulatesExpectedFields) {
  const uint16_t kSeqNo = 10;
  const int64_t kSendTime = 1000;
  const int64_t kReceiveTime = 2000;
  const size_t kPayloadSize = 42;

  AddPacketWithSendTime(kSeqNo, kPayloadSize, kSendTime,
                        PacketInfo::kNotAProbe);

  PacketInfo info(kReceiveTime, kSeqNo);
  EXPECT_TRUE(history_.GetInfo(&info, true));
  EXPECT_EQ(kReceiveTime, info.arrival_time_ms);
  EXPECT_EQ(kSendTime, info.send_time_ms);
  EXPECT_EQ(kSeqNo, info.sequence_number);
  EXPECT_EQ(kPayloadSize, info.payload_size);
}

TEST_F(SendTimeHistoryTest, AddThenRemoveOutOfOrder) {
  std::vector<PacketInfo> sent_packets;
  std::vector<PacketInfo> received_packets;
  const size_t num_items = 100;
  const size_t kPacketSize = 400;
  const size_t kTransmissionTime = 1234;
  const int kProbeClusterId = 1;
  for (size_t i = 0; i < num_items; ++i) {
    sent_packets.push_back(PacketInfo(0, static_cast<int64_t>(i),
                                      static_cast<uint16_t>(i), kPacketSize,
                                      kProbeClusterId));
    received_packets.push_back(PacketInfo(
        static_cast<int64_t>(i) + kTransmissionTime, 0,
        static_cast<uint16_t>(i), kPacketSize, PacketInfo::kNotAProbe));
  }
  for (size_t i = 0; i < num_items; ++i) {
    history_.AddAndRemoveOld(sent_packets[i].sequence_number,
                             sent_packets[i].payload_size,
                             sent_packets[i].probe_cluster_id);
  }
  for (size_t i = 0; i < num_items; ++i)
    history_.OnSentPacket(sent_packets[i].sequence_number,
                          sent_packets[i].send_time_ms);
  std::random_shuffle(received_packets.begin(), received_packets.end());
  for (size_t i = 0; i < num_items; ++i) {
    PacketInfo packet = received_packets[i];
    EXPECT_TRUE(history_.GetInfo(&packet, false));
    PacketInfo sent_packet = sent_packets[packet.sequence_number];
    sent_packet.arrival_time_ms = packet.arrival_time_ms;
    EXPECT_EQ(sent_packet, packet);
    EXPECT_TRUE(history_.GetInfo(&packet, true));
  }
  for (PacketInfo packet : sent_packets)
    EXPECT_FALSE(history_.GetInfo(&packet, false));
}

TEST_F(SendTimeHistoryTest, HistorySize) {
  const int kItems = kDefaultHistoryLengthMs / 100;
  for (int i = 0; i < kItems; ++i) {
    clock_.AdvanceTimeMilliseconds(100);
    AddPacketWithSendTime(i, 0, i * 100, PacketInfo::kNotAProbe);
  }
  for (int i = 0; i < kItems; ++i) {
    PacketInfo info(0, 0, static_cast<uint16_t>(i), 0, PacketInfo::kNotAProbe);
    EXPECT_TRUE(history_.GetInfo(&info, false));
    EXPECT_EQ(i * 100, info.send_time_ms);
  }
  clock_.AdvanceTimeMilliseconds(101);
  AddPacketWithSendTime(kItems, 0, kItems * 101, PacketInfo::kNotAProbe);
  PacketInfo info(0, 0, 0, 0, PacketInfo::kNotAProbe);
  EXPECT_FALSE(history_.GetInfo(&info, false));
  for (int i = 1; i < (kItems + 1); ++i) {
    PacketInfo info2(0, 0, static_cast<uint16_t>(i), 0, PacketInfo::kNotAProbe);
    EXPECT_TRUE(history_.GetInfo(&info2, false));
    int64_t expected_time_ms = (i == kItems) ? i * 101 : i * 100;
    EXPECT_EQ(expected_time_ms, info2.send_time_ms);
  }
}

TEST_F(SendTimeHistoryTest, HistorySizeWithWraparound) {
  const uint16_t kMaxSeqNo = std::numeric_limits<uint16_t>::max();
  AddPacketWithSendTime(kMaxSeqNo - 2, 0, 0, PacketInfo::kNotAProbe);

  clock_.AdvanceTimeMilliseconds(100);
  AddPacketWithSendTime(kMaxSeqNo - 1, 1, 100, PacketInfo::kNotAProbe);

  clock_.AdvanceTimeMilliseconds(100);
  AddPacketWithSendTime(kMaxSeqNo, 0, 200, PacketInfo::kNotAProbe);

  clock_.AdvanceTimeMilliseconds(kDefaultHistoryLengthMs - 200 + 1);
  AddPacketWithSendTime(0, 0, kDefaultHistoryLengthMs, PacketInfo::kNotAProbe);

  PacketInfo info(0, static_cast<uint16_t>(kMaxSeqNo - 2));
  EXPECT_FALSE(history_.GetInfo(&info, false));
  PacketInfo info2(0, static_cast<uint16_t>(kMaxSeqNo - 1));
  EXPECT_TRUE(history_.GetInfo(&info2, false));
  PacketInfo info3(0, static_cast<uint16_t>(kMaxSeqNo));
  EXPECT_TRUE(history_.GetInfo(&info3, false));
  PacketInfo info4(0, 0);
  EXPECT_TRUE(history_.GetInfo(&info4, false));

  // Create a gap (kMaxSeqNo - 1) -> 0.
  PacketInfo info5(0, kMaxSeqNo);
  EXPECT_TRUE(history_.GetInfo(&info5, true));

  clock_.AdvanceTimeMilliseconds(100);
  AddPacketWithSendTime(1, 0, 1100, PacketInfo::kNotAProbe);

  PacketInfo info6(0, static_cast<uint16_t>(kMaxSeqNo - 2));
  EXPECT_FALSE(history_.GetInfo(&info6, false));
  PacketInfo info7(0, static_cast<uint16_t>(kMaxSeqNo - 1));
  EXPECT_FALSE(history_.GetInfo(&info7, false));
  PacketInfo info8(0, kMaxSeqNo);
  EXPECT_FALSE(history_.GetInfo(&info8, false));
  PacketInfo info9(0, 0);
  EXPECT_TRUE(history_.GetInfo(&info9, false));
  PacketInfo info10(0, 1);
  EXPECT_TRUE(history_.GetInfo(&info10, false));
}

TEST_F(SendTimeHistoryTest, InterlievedGetAndRemove) {
  const uint16_t kSeqNo = 1;
  const int64_t kTimestamp = 2;
  PacketInfo packets[3] = {{0, kTimestamp, kSeqNo, 0, 0},
                           {0, kTimestamp + 1, kSeqNo + 1, 0, 1},
                           {0, kTimestamp + 2, kSeqNo + 2, 0, 2}};

  AddPacketWithSendTime(packets[0].sequence_number, packets[0].payload_size,
                        packets[0].send_time_ms, 0);
  AddPacketWithSendTime(packets[1].sequence_number, packets[1].payload_size,
                        packets[1].send_time_ms, 1);
  PacketInfo info(0, 0, packets[0].sequence_number, 0, 0);
  EXPECT_TRUE(history_.GetInfo(&info, true));
  EXPECT_EQ(packets[0], info);

  AddPacketWithSendTime(packets[2].sequence_number, packets[2].payload_size,
                        packets[2].send_time_ms, 2);

  PacketInfo info2(0, 0, packets[1].sequence_number, 0, 1);
  EXPECT_TRUE(history_.GetInfo(&info2, true));
  EXPECT_EQ(packets[1], info2);

  PacketInfo info3(0, 0, packets[2].sequence_number, 0, 2);
  EXPECT_TRUE(history_.GetInfo(&info3, true));
  EXPECT_EQ(packets[2], info3);
}

}  // namespace test
}  // namespace webrtc
