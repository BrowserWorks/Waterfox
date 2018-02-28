/*
 *  Copyright (c) 2012 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "webrtc/modules/rtp_rtcp/source/ulpfec_receiver_impl.h"

#include <memory>
#include <utility>

#include "webrtc/base/checks.h"
#include "webrtc/base/logging.h"
#include "webrtc/modules/rtp_rtcp/source/byte_io.h"
#include "webrtc/modules/rtp_rtcp/source/rtp_receiver_video.h"
#include "webrtc/system_wrappers/include/clock.h"

namespace webrtc {

UlpfecReceiver* UlpfecReceiver::Create(RtpData* callback) {
  return new UlpfecReceiverImpl(callback);
}

UlpfecReceiverImpl::UlpfecReceiverImpl(RtpData* callback)
    : recovered_packet_callback_(callback),
      fec_(ForwardErrorCorrection::CreateUlpfec()) {}

UlpfecReceiverImpl::~UlpfecReceiverImpl() {
  received_packets_.clear();
  fec_->ResetState(&recovered_packets_);
}

FecPacketCounter UlpfecReceiverImpl::GetPacketCounter() const {
  rtc::CritScope cs(&crit_sect_);
  return packet_counter_;
}

//     0                   1                    2                   3
//     0 1 2 3 4 5 6 7 8 9 0 1 2 3  4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
//    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//    |F|   block PT  |  timestamp offset         |   block length    |
//    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//
//
// RFC 2198          RTP Payload for Redundant Audio Data    September 1997
//
//    The bits in the header are specified as follows:
//
//    F: 1 bit First bit in header indicates whether another header block
//        follows.  If 1 further header blocks follow, if 0 this is the
//        last header block.
//        If 0 there is only 1 byte RED header
//
//    block PT: 7 bits RTP payload type for this block.
//
//    timestamp offset:  14 bits Unsigned offset of timestamp of this block
//        relative to timestamp given in RTP header.  The use of an unsigned
//        offset implies that redundant data must be sent after the primary
//        data, and is hence a time to be subtracted from the current
//        timestamp to determine the timestamp of the data for which this
//        block is the redundancy.
//
//    block length:  10 bits Length in bytes of the corresponding data
//        block excluding header.

int32_t UlpfecReceiverImpl::AddReceivedRedPacket(
    const RTPHeader& header,
    const uint8_t* incoming_rtp_packet,
    size_t packet_length,
    uint8_t ulpfec_payload_type) {
  rtc::CritScope cs(&crit_sect_);

  uint8_t red_header_length = 1;
  size_t payload_data_length = packet_length - header.headerLength;

  if (payload_data_length == 0) {
    LOG(LS_WARNING) << "Corrupt/truncated FEC packet.";
    return -1;
  }

  // Remove RED header of incoming packet and store as a virtual RTP packet.
  std::unique_ptr<ForwardErrorCorrection::ReceivedPacket> received_packet(
      new ForwardErrorCorrection::ReceivedPacket());
  received_packet->pkt = new ForwardErrorCorrection::Packet();

  // Get payload type from RED header and sequence number from RTP header.
  uint8_t payload_type = incoming_rtp_packet[header.headerLength] & 0x7f;
  received_packet->is_fec = payload_type == ulpfec_payload_type;
  received_packet->seq_num = header.sequenceNumber;

  uint16_t block_length = 0;
  if (incoming_rtp_packet[header.headerLength] & 0x80) {
    // f bit set in RED header, i.e. there are more than one RED header blocks.
    red_header_length = 4;
    if (payload_data_length < red_header_length + 1u) {
      LOG(LS_WARNING) << "Corrupt/truncated FEC packet.";
      return -1;
    }

    uint16_t timestamp_offset = incoming_rtp_packet[header.headerLength + 1]
                                << 8;
    timestamp_offset += incoming_rtp_packet[header.headerLength + 2];
    timestamp_offset = timestamp_offset >> 2;
    if (timestamp_offset != 0) {
      LOG(LS_WARNING) << "Corrupt payload found.";
      return -1;
    }

    block_length = (0x3 & incoming_rtp_packet[header.headerLength + 2]) << 8;
    block_length += incoming_rtp_packet[header.headerLength + 3];

    // Check next RED header block.
    if (incoming_rtp_packet[header.headerLength + 4] & 0x80) {
      LOG(LS_WARNING) << "More than 2 blocks in packet not supported.";
      return -1;
    }
    // Check that the packet is long enough to contain data in the following
    // block.
    if (block_length > payload_data_length - (red_header_length + 1)) {
      LOG(LS_WARNING) << "Block length longer than packet.";
      return -1;
    }
  }
  ++packet_counter_.num_packets;
  if (packet_counter_.first_packet_time_ms == -1) {
    packet_counter_.first_packet_time_ms =
        Clock::GetRealTimeClock()->TimeInMilliseconds();
  }

  std::unique_ptr<ForwardErrorCorrection::ReceivedPacket>
      second_received_packet;
  if (block_length > 0) {
    // Handle block length, split into two packets.
    red_header_length = 5;

    // Copy RTP header.
    memcpy(received_packet->pkt->data, incoming_rtp_packet,
           header.headerLength);

    // Set payload type.
    received_packet->pkt->data[1] &= 0x80;          // Reset RED payload type.
    received_packet->pkt->data[1] += payload_type;  // Set media payload type.

    // Copy payload data.
    memcpy(received_packet->pkt->data + header.headerLength,
           incoming_rtp_packet + header.headerLength + red_header_length,
           block_length);
    received_packet->pkt->length = block_length;

    second_received_packet.reset(new ForwardErrorCorrection::ReceivedPacket);
    second_received_packet->pkt = new ForwardErrorCorrection::Packet;

    second_received_packet->is_fec = true;
    second_received_packet->seq_num = header.sequenceNumber;
    ++packet_counter_.num_fec_packets;

    // Copy FEC payload data.
    memcpy(second_received_packet->pkt->data,
           incoming_rtp_packet + header.headerLength + red_header_length +
               block_length,
           payload_data_length - red_header_length - block_length);

    second_received_packet->pkt->length =
        payload_data_length - red_header_length - block_length;

  } else if (received_packet->is_fec) {
    ++packet_counter_.num_fec_packets;
    // everything behind the RED header
    memcpy(received_packet->pkt->data,
           incoming_rtp_packet + header.headerLength + red_header_length,
           payload_data_length - red_header_length);
    received_packet->pkt->length = payload_data_length - red_header_length;
    received_packet->ssrc =
        ByteReader<uint32_t>::ReadBigEndian(&incoming_rtp_packet[8]);

  } else {
    // Copy RTP header.
    memcpy(received_packet->pkt->data, incoming_rtp_packet,
           header.headerLength);

    // Set payload type.
    received_packet->pkt->data[1] &= 0x80;          // Reset RED payload type.
    received_packet->pkt->data[1] += payload_type;  // Set media payload type.

    // Copy payload data.
    memcpy(received_packet->pkt->data + header.headerLength,
           incoming_rtp_packet + header.headerLength + red_header_length,
           payload_data_length - red_header_length);
    received_packet->pkt->length =
        header.headerLength + payload_data_length - red_header_length;
  }

  if (received_packet->pkt->length == 0) {
    return 0;
  }

  received_packets_.push_back(std::move(received_packet));
  if (second_received_packet) {
    received_packets_.push_back(std::move(second_received_packet));
  }
  return 0;
}

int32_t UlpfecReceiverImpl::ProcessReceivedFec() {
  crit_sect_.Enter();
  if (!received_packets_.empty()) {
    // Send received media packet to VCM.
    if (!received_packets_.front()->is_fec) {
      ForwardErrorCorrection::Packet* packet = received_packets_.front()->pkt;
      crit_sect_.Leave();
      if (!recovered_packet_callback_->OnRecoveredPacket(packet->data,
                                                         packet->length)) {
        return -1;
      }
      crit_sect_.Enter();
    }
    if (fec_->DecodeFec(&received_packets_, &recovered_packets_) != 0) {
      crit_sect_.Leave();
      return -1;
    }
    RTC_DCHECK(received_packets_.empty());
  }
  // Send any recovered media packets to VCM.
  for (const auto& recovered_packet : recovered_packets_) {
    if (recovered_packet->returned) {
      // Already sent to the VCM and the jitter buffer.
      continue;
    }
    ForwardErrorCorrection::Packet* packet = recovered_packet->pkt;
    ++packet_counter_.num_recovered_packets;
    crit_sect_.Leave();
    if (!recovered_packet_callback_->OnRecoveredPacket(packet->data,
                                                       packet->length)) {
      return -1;
    }
    crit_sect_.Enter();
    recovered_packet->returned = true;
  }
  crit_sect_.Leave();
  return 0;
}

}  // namespace webrtc
