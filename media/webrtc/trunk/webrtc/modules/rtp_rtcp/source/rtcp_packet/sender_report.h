/*
 *  Copyright (c) 2016 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_MODULES_RTP_RTCP_SOURCE_RTCP_PACKET_SENDER_REPORT_H_
#define WEBRTC_MODULES_RTP_RTCP_SOURCE_RTCP_PACKET_SENDER_REPORT_H_

#include <vector>

#include "webrtc/base/constructormagic.h"
#include "webrtc/modules/rtp_rtcp/source/rtcp_packet.h"
#include "webrtc/modules/rtp_rtcp/source/rtcp_packet/report_block.h"
#include "webrtc/system_wrappers/include/ntp_time.h"

namespace webrtc {
namespace rtcp {
class CommonHeader;

class SenderReport : public RtcpPacket {
 public:
  static constexpr uint8_t kPacketType = 200;

  SenderReport();
  ~SenderReport() override {}

  // Parse assumes header is already parsed and validated.
  bool Parse(const CommonHeader& packet);

  void SetSenderSsrc(uint32_t ssrc) { sender_ssrc_ = ssrc; }
  void SetNtp(NtpTime ntp) { ntp_ = ntp; }
  void SetRtpTimestamp(uint32_t rtp_timestamp) {
    rtp_timestamp_ = rtp_timestamp;
  }
  void SetPacketCount(uint32_t packet_count) {
    sender_packet_count_ = packet_count;
  }
  void SetOctetCount(uint32_t octet_count) {
    sender_octet_count_ = octet_count;
  }
  bool AddReportBlock(const ReportBlock& block);
  void ClearReportBlocks() { report_blocks_.clear(); }

  uint32_t sender_ssrc() const { return sender_ssrc_; }
  NtpTime ntp() const { return ntp_; }
  uint32_t rtp_timestamp() const { return rtp_timestamp_; }
  uint32_t sender_packet_count() const { return sender_packet_count_; }
  uint32_t sender_octet_count() const { return sender_octet_count_; }

  const std::vector<ReportBlock>& report_blocks() const {
    return report_blocks_;
  }

 protected:
  bool Create(uint8_t* packet,
              size_t* index,
              size_t max_length,
              RtcpPacket::PacketReadyCallback* callback) const override;

 private:
  static const size_t kMaxNumberOfReportBlocks = 0x1f;
  const size_t kSenderBaseLength = 24;

  size_t BlockLength() const override {
    return kHeaderLength + kSenderBaseLength +
           report_blocks_.size() * ReportBlock::kLength;
  }

  uint32_t sender_ssrc_;
  NtpTime ntp_;
  uint32_t rtp_timestamp_;
  uint32_t sender_packet_count_;
  uint32_t sender_octet_count_;
  std::vector<ReportBlock> report_blocks_;

  RTC_DISALLOW_COPY_AND_ASSIGN(SenderReport);
};

}  // namespace rtcp
}  // namespace webrtc
#endif  // WEBRTC_MODULES_RTP_RTCP_SOURCE_RTCP_PACKET_SENDER_REPORT_H_
