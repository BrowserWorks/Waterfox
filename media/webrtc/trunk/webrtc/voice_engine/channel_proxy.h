/*
 *  Copyright (c) 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_VOICE_ENGINE_CHANNEL_PROXY_H_
#define WEBRTC_VOICE_ENGINE_CHANNEL_PROXY_H_

#include "webrtc/api/audio/audio_mixer.h"
#include "webrtc/base/constructormagic.h"
#include "webrtc/base/race_checker.h"
#include "webrtc/base/thread_checker.h"
#include "webrtc/voice_engine/channel_manager.h"
#include "webrtc/voice_engine/include/voe_rtp_rtcp.h"

#include <memory>
#include <string>
#include <vector>

namespace webrtc {

class AudioSinkInterface;
class PacketRouter;
class RtcEventLog;
class RtcpRttStats;
class RtpPacketSender;
class Transport;
class TransportFeedbackObserver;

namespace voe {

class Channel;

// This class provides the "view" of a voe::Channel that we need to implement
// webrtc::AudioSendStream and webrtc::AudioReceiveStream. It serves two
// purposes:
//  1. Allow mocking just the interfaces used, instead of the entire
//     voe::Channel class.
//  2. Provide a refined interface for the stream classes, including assumptions
//     on return values and input adaptation.
class ChannelProxy {
 public:
  ChannelProxy();
  explicit ChannelProxy(const ChannelOwner& channel_owner);
  virtual ~ChannelProxy();

  virtual void SetRTCPStatus(bool enable);
  virtual void SetLocalSSRC(uint32_t ssrc);
  virtual void SetRTCP_CNAME(const std::string& c_name);
  virtual void SetNACKStatus(bool enable, int max_packets);
  virtual void SetSendAudioLevelIndicationStatus(bool enable, int id);
  virtual void SetReceiveAudioLevelIndicationStatus(bool enable, int id);
  virtual void EnableSendTransportSequenceNumber(int id);
  virtual void EnableReceiveTransportSequenceNumber(int id);
  virtual void RegisterSenderCongestionControlObjects(
      RtpPacketSender* rtp_packet_sender,
      TransportFeedbackObserver* transport_feedback_observer,
      PacketRouter* packet_router);
  virtual void RegisterReceiverCongestionControlObjects(
      PacketRouter* packet_router);
  virtual void ResetCongestionControlObjects();
  virtual CallStatistics GetRTCPStatistics() const;
  virtual int GetRTPStatistics(unsigned int& averageJitterMs,
                               unsigned int& maxJitterMs,
                               unsigned int& discardedPackets,
                               unsigned int& cumulativeLost) const;
  virtual std::vector<ReportBlock> GetRemoteRTCPReportBlocks() const;
  virtual NetworkStatistics GetNetworkStatistics() const;
  virtual AudioDecodingCallStats GetDecodingCallStatistics() const;
  virtual int32_t GetSpeechOutputLevelFullRange() const;
  virtual uint32_t GetDelayEstimate() const;
  virtual bool SetSendTelephoneEventPayloadType(int payload_type,
                                                int payload_frequency);
  virtual bool SendTelephoneEventOutband(int event, int duration_ms);
  virtual void SetBitrate(int bitrate_bps, int64_t probing_interval_ms);
  virtual void SetSink(std::unique_ptr<AudioSinkInterface> sink);
  virtual void SetInputMute(bool muted);
  virtual void RegisterExternalTransport(Transport* transport);
  virtual void DeRegisterExternalTransport();
  virtual bool ReceivedRTPPacket(const uint8_t* packet,
                                 size_t length,
                                 const PacketTime& packet_time);
  virtual bool ReceivedRTCPPacket(const uint8_t* packet, size_t length);
  virtual const rtc::scoped_refptr<AudioDecoderFactory>&
      GetAudioDecoderFactory() const;
  virtual void SetChannelOutputVolumeScaling(float scaling);
  virtual void SetRtcEventLog(RtcEventLog* event_log);
  virtual void EnableAudioNetworkAdaptor(const std::string& config_string);
  virtual void DisableAudioNetworkAdaptor();
  virtual void SetReceiverFrameLengthRange(int min_frame_length_ms,
                                           int max_frame_length_ms);
  virtual AudioMixer::Source::AudioFrameInfo GetAudioFrameWithInfo(
      int sample_rate_hz,
      AudioFrame* audio_frame);
  virtual int NeededFrequency() const;
  virtual void SetTransportOverhead(int transport_overhead_per_packet);
  virtual void AssociateSendChannel(const ChannelProxy& send_channel_proxy);
  virtual void DisassociateSendChannel();

  virtual void SetRtcpRttStats(RtcpRttStats* rtcp_rtt_stats);

 private:
  Channel* channel() const;

  rtc::ThreadChecker thread_checker_;
  rtc::RaceChecker race_checker_;
  ChannelOwner channel_owner_;

  RTC_DISALLOW_COPY_AND_ASSIGN(ChannelProxy);
};
}  // namespace voe
}  // namespace webrtc

#endif  // WEBRTC_VOICE_ENGINE_CHANNEL_PROXY_H_
