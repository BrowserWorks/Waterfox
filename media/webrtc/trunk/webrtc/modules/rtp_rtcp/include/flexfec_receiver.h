/*
 *  Copyright (c) 2016 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_MODULES_RTP_RTCP_INCLUDE_FLEXFEC_RECEIVER_H_
#define WEBRTC_MODULES_RTP_RTCP_INCLUDE_FLEXFEC_RECEIVER_H_

#include <memory>

#include "webrtc/base/basictypes.h"
#include "webrtc/base/sequenced_task_checker.h"
#include "webrtc/call/call.h"
#include "webrtc/modules/rtp_rtcp/include/ulpfec_receiver.h"
#include "webrtc/modules/rtp_rtcp/source/forward_error_correction.h"
#include "webrtc/modules/rtp_rtcp/source/rtp_packet_received.h"
#include "webrtc/system_wrappers/include/clock.h"

namespace webrtc {

// Callback interface for packets recovered by FlexFEC. The implementation
// should be able to demultiplex the recovered RTP packets based on SSRC.
class RecoveredPacketReceiver {
 public:
  virtual bool OnRecoveredPacket(const uint8_t* packet, size_t length) = 0;

 protected:
  virtual ~RecoveredPacketReceiver() = default;
};

class FlexfecReceiver {
 public:
  FlexfecReceiver(uint32_t ssrc,
                  uint32_t protected_media_ssrc,
                  RecoveredPacketReceiver* recovered_packet_receiver);
  ~FlexfecReceiver();

  // Inserts a received packet (can be either media or FlexFEC) into the
  // internal buffer, and sends the received packets to the erasure code.
  // All newly recovered packets are sent back through the callback.
  bool AddAndProcessReceivedPacket(const RtpPacketReceived& packet);

  // Returns a counter describing the added and recovered packets.
  FecPacketCounter GetPacketCounter() const;

 private:
  bool AddReceivedPacket(const RtpPacketReceived& packet);
  bool ProcessReceivedPackets();

  // Config.
  const uint32_t ssrc_;
  const uint32_t protected_media_ssrc_;

  // Erasure code interfacing and callback.
  std::unique_ptr<ForwardErrorCorrection> erasure_code_
      GUARDED_BY(sequence_checker_);
  ForwardErrorCorrection::ReceivedPacketList received_packets_
      GUARDED_BY(sequence_checker_);
  ForwardErrorCorrection::RecoveredPacketList recovered_packets_
      GUARDED_BY(sequence_checker_);
  RecoveredPacketReceiver* const recovered_packet_receiver_;

  // Logging and stats.
  Clock* const clock_;
  int64_t last_recovered_packet_ms_ GUARDED_BY(sequence_checker_);
  FecPacketCounter packet_counter_ GUARDED_BY(sequence_checker_);

  rtc::SequencedTaskChecker sequence_checker_;
};

}  // namespace webrtc

#endif  // WEBRTC_MODULES_RTP_RTCP_INCLUDE_FLEXFEC_RECEIVER_H_
