/*
 *  Copyright (c) 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_AUDIO_MOCK_VOICE_ENGINE_H_
#define WEBRTC_AUDIO_MOCK_VOICE_ENGINE_H_

#include <memory>

#include "webrtc/modules/audio_device/include/mock_audio_device.h"
#include "webrtc/modules/audio_device/include/mock_audio_transport.h"
#include "webrtc/modules/audio_processing/include/mock_audio_processing.h"
#include "webrtc/test/gmock.h"
#include "webrtc/test/mock_voe_channel_proxy.h"
#include "webrtc/voice_engine/voice_engine_impl.h"

namespace webrtc {
namespace test {

// NOTE: This class inherits from VoiceEngineImpl so that its clients will be
// able to get the various interfaces as usual, via T::GetInterface().
class MockVoiceEngine : public VoiceEngineImpl {
 public:
  // TODO(nisse): Valid overrides commented out, because the gmock
  // methods don't use any override declarations, and we want to avoid
  // warnings from -Winconsistent-missing-override. See
  // http://crbug.com/428099.
  MockVoiceEngine(
      rtc::scoped_refptr<AudioDecoderFactory> decoder_factory = nullptr)
      : decoder_factory_(decoder_factory) {
    // Increase ref count so this object isn't automatically deleted whenever
    // interfaces are Release():d.
    ++_ref_count;
    // We add this default behavior to make the mock easier to use in tests. It
    // will create a NiceMock of a voe::ChannelProxy.
    // TODO(ossu): As long as AudioReceiveStream is implemented as a wrapper
    // around Channel, we need to make sure ChannelProxy returns the same
    // decoder factory as the one passed in when creating an AudioReceiveStream.
    ON_CALL(*this, ChannelProxyFactory(testing::_))
        .WillByDefault(testing::Invoke([this](int channel_id) {
          auto* proxy =
              new testing::NiceMock<webrtc::test::MockVoEChannelProxy>();
          EXPECT_CALL(*proxy, GetAudioDecoderFactory())
              .WillRepeatedly(testing::ReturnRef(decoder_factory_));
          return proxy;
        }));

    ON_CALL(*this, audio_device_module())
        .WillByDefault(testing::Return(&mock_audio_device_));
    ON_CALL(*this, audio_processing())
        .WillByDefault(testing::Return(&mock_audio_processing_));
    ON_CALL(*this, audio_transport())
        .WillByDefault(testing::Return(&mock_audio_transport_));
  }
  virtual ~MockVoiceEngine() /* override */ {
    // Decrease ref count before base class d-tor is called; otherwise it will
    // trigger an assertion.
    --_ref_count;
  }

  int Release() {
    return 0;
  }

  // Allows injecting a ChannelProxy factory.
  MOCK_METHOD1(ChannelProxyFactory, voe::ChannelProxy*(int channel_id));

  // VoiceEngineImpl
  virtual std::unique_ptr<voe::ChannelProxy> GetChannelProxy(
      int channel_id) /* override */ {
    return std::unique_ptr<voe::ChannelProxy>(ChannelProxyFactory(channel_id));
  }

  // VoEAudioProcessing
  MOCK_METHOD2(SetNsStatus, int(bool enable, NsModes mode));
  MOCK_METHOD2(GetNsStatus, int(bool& enabled, NsModes& mode));
  MOCK_METHOD2(SetAgcStatus, int(bool enable, AgcModes mode));
  MOCK_METHOD2(GetAgcStatus, int(bool& enabled, AgcModes& mode));
  MOCK_METHOD1(SetAgcConfig, int(AgcConfig config));
  MOCK_METHOD1(GetAgcConfig, int(AgcConfig& config));
  MOCK_METHOD2(SetEcStatus, int(bool enable, EcModes mode));
  MOCK_METHOD2(GetEcStatus, int(bool& enabled, EcModes& mode));
  MOCK_METHOD1(EnableDriftCompensation, int(bool enable));
  MOCK_METHOD0(DriftCompensationEnabled, bool());
  MOCK_METHOD1(SetDelayOffsetMs, void(int offset));
  MOCK_METHOD0(DelayOffsetMs, int());
  MOCK_METHOD2(SetAecmMode, int(AecmModes mode, bool enableCNG));
  MOCK_METHOD2(GetAecmMode, int(AecmModes& mode, bool& enabledCNG));
  MOCK_METHOD1(EnableHighPassFilter, int(bool enable));
  MOCK_METHOD0(IsHighPassFilterEnabled, bool());
  MOCK_METHOD1(VoiceActivityIndicator, int(int channel));
  MOCK_METHOD1(SetEcMetricsStatus, int(bool enable));
  MOCK_METHOD1(GetEcMetricsStatus, int(bool& enabled));
  MOCK_METHOD4(GetEchoMetrics, int(int& ERL, int& ERLE, int& RERL, int& A_NLP));
  MOCK_METHOD3(GetEcDelayMetrics,
               int(int& delay_median,
                   int& delay_std,
                   float& fraction_poor_delays));
  MOCK_METHOD1(StartDebugRecording, int(const char* fileNameUTF8));
  MOCK_METHOD1(StartDebugRecording, int(FILE* file_handle));
  MOCK_METHOD0(StopDebugRecording, int());
  MOCK_METHOD1(SetTypingDetectionStatus, int(bool enable));
  MOCK_METHOD1(GetTypingDetectionStatus, int(bool& enabled));
  MOCK_METHOD1(TimeSinceLastTyping, int(int& seconds));
  MOCK_METHOD5(SetTypingDetectionParameters,
               int(int timeWindow,
                   int costPerTyping,
                   int reportingThreshold,
                   int penaltyDecay,
                   int typeEventDelay));
  MOCK_METHOD1(EnableStereoChannelSwapping, void(bool enable));
  MOCK_METHOD0(IsStereoChannelSwappingEnabled, bool());

  // VoEBase
  MOCK_METHOD1(RegisterVoiceEngineObserver, int(VoiceEngineObserver& observer));
  MOCK_METHOD0(DeRegisterVoiceEngineObserver, int());
  MOCK_METHOD3(
      Init,
      int(AudioDeviceModule* external_adm,
          AudioProcessing* audioproc,
          const rtc::scoped_refptr<AudioDecoderFactory>& decoder_factory));
  MOCK_METHOD0(audio_processing, AudioProcessing*());
  MOCK_METHOD0(audio_device_module, AudioDeviceModule*());
  MOCK_METHOD0(Terminate, int());
  MOCK_METHOD0(CreateChannel, int());
  MOCK_METHOD1(CreateChannel, int(const ChannelConfig& config));
  MOCK_METHOD1(DeleteChannel, int(int channel));
  MOCK_METHOD1(StartReceive, int(int channel));
  MOCK_METHOD1(StopReceive, int(int channel));
  MOCK_METHOD1(StartPlayout, int(int channel));
  MOCK_METHOD1(StopPlayout, int(int channel));
  MOCK_METHOD1(StartSend, int(int channel));
  MOCK_METHOD1(StopSend, int(int channel));
  MOCK_METHOD1(GetVersion, int(char version[1024]));
  MOCK_METHOD0(LastError, int());
  MOCK_METHOD0(audio_transport, AudioTransport*());
  MOCK_METHOD2(AssociateSendChannel,
               int(int channel, int accociate_send_channel));

  // VoECodec
  MOCK_METHOD0(NumOfCodecs, int());
  MOCK_METHOD2(GetCodec, int(int index, CodecInst& codec));
  MOCK_METHOD2(SetSendCodec, int(int channel, const CodecInst& codec));
  MOCK_METHOD2(GetSendCodec, int(int channel, CodecInst& codec));
  MOCK_METHOD2(SetBitRate, int(int channel, int bitrate_bps));
  MOCK_METHOD2(GetRecCodec, int(int channel, CodecInst& codec));
  MOCK_METHOD2(SetRecPayloadType, int(int channel, const CodecInst& codec));
  MOCK_METHOD2(GetRecPayloadType, int(int channel, CodecInst& codec));
  MOCK_METHOD3(SetSendCNPayloadType,
               int(int channel, int type, PayloadFrequencies frequency));
  MOCK_METHOD2(SetFECStatus, int(int channel, bool enable));
  MOCK_METHOD2(GetFECStatus, int(int channel, bool& enabled));
  MOCK_METHOD4(SetVADStatus,
               int(int channel, bool enable, VadModes mode, bool disableDTX));
  MOCK_METHOD4(
      GetVADStatus,
      int(int channel, bool& enabled, VadModes& mode, bool& disabledDTX));
  MOCK_METHOD2(SetOpusMaxPlaybackRate, int(int channel, int frequency_hz));
  MOCK_METHOD2(SetOpusDtx, int(int channel, bool enable_dtx));

  // VoEExternalMedia
  MOCK_METHOD3(RegisterExternalMediaProcessing,
               int(int channel,
                   ProcessingTypes type,
                   VoEMediaProcess& processObject));
  MOCK_METHOD2(DeRegisterExternalMediaProcessing,
               int(int channel, ProcessingTypes type));
  MOCK_METHOD3(GetAudioFrame,
               int(int channel, int desired_sample_rate_hz, AudioFrame* frame));
  MOCK_METHOD2(SetExternalMixing, int(int channel, bool enable));

  // VoEFile
  MOCK_METHOD7(StartPlayingFileLocally,
               int(int channel,
                   const char fileNameUTF8[1024],
                   bool loop,
                   FileFormats format,
                   float volumeScaling,
                   int startPointMs,
                   int stopPointMs));
  MOCK_METHOD6(StartPlayingFileLocally,
               int(int channel,
                   InStream* stream,
                   FileFormats format,
                   float volumeScaling,
                   int startPointMs,
                   int stopPointMs));
  MOCK_METHOD1(StopPlayingFileLocally, int(int channel));
  MOCK_METHOD1(IsPlayingFileLocally, int(int channel));
  MOCK_METHOD6(StartPlayingFileAsMicrophone,
               int(int channel,
                   const char fileNameUTF8[1024],
                   bool loop,
                   bool mixWithMicrophone,
                   FileFormats format,
                   float volumeScaling));
  MOCK_METHOD5(StartPlayingFileAsMicrophone,
               int(int channel,
                   InStream* stream,
                   bool mixWithMicrophone,
                   FileFormats format,
                   float volumeScaling));
  MOCK_METHOD1(StopPlayingFileAsMicrophone, int(int channel));
  MOCK_METHOD1(IsPlayingFileAsMicrophone, int(int channel));
  MOCK_METHOD4(StartRecordingPlayout,
               int(int channel,
                   const char* fileNameUTF8,
                   CodecInst* compression,
                   int maxSizeBytes));
  MOCK_METHOD1(StopRecordingPlayout, int(int channel));
  MOCK_METHOD3(StartRecordingPlayout,
               int(int channel, OutStream* stream, CodecInst* compression));
  MOCK_METHOD3(StartRecordingMicrophone,
               int(const char* fileNameUTF8,
                   CodecInst* compression,
                   int maxSizeBytes));
  MOCK_METHOD2(StartRecordingMicrophone,
               int(OutStream* stream, CodecInst* compression));
  MOCK_METHOD0(StopRecordingMicrophone, int());

  // VoEHardware
  MOCK_METHOD1(GetNumOfRecordingDevices, int(int& devices));
  MOCK_METHOD1(GetNumOfPlayoutDevices, int(int& devices));
  MOCK_METHOD3(GetRecordingDeviceName,
               int(int index, char strNameUTF8[128], char strGuidUTF8[128]));
  MOCK_METHOD3(GetPlayoutDeviceName,
               int(int index, char strNameUTF8[128], char strGuidUTF8[128]));
  MOCK_METHOD2(SetRecordingDevice,
               int(int index, StereoChannel recordingChannel));
  MOCK_METHOD1(SetPlayoutDevice, int(int index));
  MOCK_METHOD1(SetAudioDeviceLayer, int(AudioLayers audioLayer));
  MOCK_METHOD1(GetAudioDeviceLayer, int(AudioLayers& audioLayer));
  MOCK_METHOD1(SetRecordingSampleRate, int(unsigned int samples_per_sec));
  MOCK_CONST_METHOD1(RecordingSampleRate, int(unsigned int* samples_per_sec));
  MOCK_METHOD1(SetPlayoutSampleRate, int(unsigned int samples_per_sec));
  MOCK_CONST_METHOD1(PlayoutSampleRate, int(unsigned int* samples_per_sec));
  MOCK_CONST_METHOD0(BuiltInAECIsAvailable, bool());
  MOCK_METHOD1(EnableBuiltInAEC, int(bool enable));
  MOCK_CONST_METHOD0(BuiltInAGCIsAvailable, bool());
  MOCK_METHOD1(EnableBuiltInAGC, int(bool enable));
  MOCK_CONST_METHOD0(BuiltInNSIsAvailable, bool());
  MOCK_METHOD1(EnableBuiltInNS, int(bool enable));

  // VoENetEqStats
  MOCK_METHOD2(GetNetworkStatistics,
               int(int channel, NetworkStatistics& stats));
  MOCK_CONST_METHOD2(GetDecodingCallStatistics,
                     int(int channel, AudioDecodingCallStats* stats));

  // VoENetwork
  MOCK_METHOD2(RegisterExternalTransport,
               int(int channel, Transport& transport));
  MOCK_METHOD1(DeRegisterExternalTransport, int(int channel));
  MOCK_METHOD3(ReceivedRTPPacket,
               int(int channel, const void* data, size_t length));
  MOCK_METHOD4(ReceivedRTPPacket,
               int(int channel,
                   const void* data,
                   size_t length,
                   const PacketTime& packet_time));
  MOCK_METHOD3(ReceivedRTCPPacket,
               int(int channel, const void* data, size_t length));

  // VoERTP_RTCP
  MOCK_METHOD2(SetLocalSSRC, int(int channel, unsigned int ssrc));
  MOCK_METHOD2(GetLocalSSRC, int(int channel, unsigned int& ssrc));
  MOCK_METHOD2(GetRemoteSSRC, int(int channel, unsigned int& ssrc));
  MOCK_METHOD3(SetSendAudioLevelIndicationStatus,
               int(int channel, bool enable, unsigned char id));
  MOCK_METHOD3(SetReceiveAudioLevelIndicationStatus,
               int(int channel, bool enable, unsigned char id));
  MOCK_METHOD3(SetSendAbsoluteSenderTimeStatus,
               int(int channel, bool enable, unsigned char id));
  MOCK_METHOD3(SetReceiveAbsoluteSenderTimeStatus,
               int(int channel, bool enable, unsigned char id));
  MOCK_METHOD2(SetRTCPStatus, int(int channel, bool enable));
  MOCK_METHOD2(GetRTCPStatus, int(int channel, bool& enabled));
  MOCK_METHOD2(SetRTCP_CNAME, int(int channel, const char cName[256]));
  MOCK_METHOD2(GetRTCP_CNAME, int(int channel, char cName[256]));
  MOCK_METHOD2(GetRemoteRTCP_CNAME, int(int channel, char cName[256]));
  MOCK_METHOD7(GetRemoteRTCPData,
               int(int channel,
                   unsigned int& NTPHigh,
                   unsigned int& NTPLow,
                   unsigned int& timestamp,
                   unsigned int& playoutTimestamp,
                   unsigned int* jitter,
                   unsigned short* fractionLost));
  MOCK_METHOD4(GetRTPStatistics,
               int(int channel,
                   unsigned int& averageJitterMs,
                   unsigned int& maxJitterMs,
                   unsigned int& discardedPackets));
  MOCK_METHOD2(GetRTCPStatistics, int(int channel, CallStatistics& stats));
  MOCK_METHOD2(GetRemoteRTCPReportBlocks,
               int(int channel, std::vector<ReportBlock>* receive_blocks));
  MOCK_METHOD3(SetREDStatus, int(int channel, bool enable, int redPayloadtype));
  MOCK_METHOD3(GetREDStatus,
               int(int channel, bool& enable, int& redPayloadtype));
  MOCK_METHOD3(SetNACKStatus, int(int channel, bool enable, int maxNoPackets));

  // VoEVideoSync
  MOCK_METHOD1(GetPlayoutBufferSize, int(int& buffer_ms));
  MOCK_METHOD2(SetMinimumPlayoutDelay, int(int channel, int delay_ms));
  MOCK_METHOD3(GetDelayEstimate,
               int(int channel,
                   int* jitter_buffer_delay_ms,
                   int* playout_buffer_delay_ms));
  MOCK_CONST_METHOD1(GetLeastRequiredDelayMs, int(int channel));
  MOCK_METHOD2(SetInitTimestamp, int(int channel, unsigned int timestamp));
  MOCK_METHOD2(SetInitSequenceNumber, int(int channel, short sequenceNumber));
  MOCK_METHOD2(GetPlayoutTimestamp, int(int channel, unsigned int& timestamp));
  MOCK_METHOD3(GetRtpRtcp,
               int(int channel,
                   RtpRtcp** rtpRtcpModule,
                   RtpReceiver** rtp_receiver));

  // VoEVolumeControl
  MOCK_METHOD1(SetSpeakerVolume, int(unsigned int volume));
  MOCK_METHOD1(GetSpeakerVolume, int(unsigned int& volume));
  MOCK_METHOD1(SetMicVolume, int(unsigned int volume));
  MOCK_METHOD1(GetMicVolume, int(unsigned int& volume));
  MOCK_METHOD2(SetInputMute, int(int channel, bool enable));
  MOCK_METHOD2(GetInputMute, int(int channel, bool& enabled));
  MOCK_METHOD1(GetSpeechInputLevel, int(unsigned int& level));
  MOCK_METHOD2(GetSpeechOutputLevel, int(int channel, unsigned int& level));
  MOCK_METHOD1(GetSpeechInputLevelFullRange, int(unsigned int& level));
  MOCK_METHOD2(GetSpeechOutputLevelFullRange,
               int(int channel, unsigned& level));
  MOCK_METHOD2(SetChannelOutputVolumeScaling, int(int channel, float scaling));
  MOCK_METHOD2(GetChannelOutputVolumeScaling, int(int channel, float& scaling));
  MOCK_METHOD3(SetOutputVolumePan, int(int channel, float left, float right));
  MOCK_METHOD3(GetOutputVolumePan, int(int channel, float& left, float& right));

 private:
  // TODO(ossu): I'm not particularly happy about keeping the decoder factory
  // here, but due to how gmock is implemented, I cannot just keep it in the
  // functor implementing the default version of ChannelProxyFactory, above.
  // GMock creates an unfortunate copy of the functor, which would cause us to
  // return a dangling reference. Fortunately, this should go away once
  // voe::Channel does.
  rtc::scoped_refptr<AudioDecoderFactory> decoder_factory_;

  MockAudioDeviceModule mock_audio_device_;
  MockAudioProcessing mock_audio_processing_;
  MockAudioTransport mock_audio_transport_;
};
}  // namespace test
}  // namespace webrtc

#endif  // WEBRTC_AUDIO_MOCK_VOICE_ENGINE_H_
