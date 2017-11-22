/*
 *  Copyright (c) 2014 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_MEDIA_ENGINE_WEBRTCVIDEOENGINE2_H_
#define WEBRTC_MEDIA_ENGINE_WEBRTCVIDEOENGINE2_H_

#include <map>
#include <memory>
#include <set>
#include <string>
#include <vector>

#include "webrtc/api/call/transport.h"
#include "webrtc/api/video/video_frame.h"
#include "webrtc/base/asyncinvoker.h"
#include "webrtc/base/criticalsection.h"
#include "webrtc/base/networkroute.h"
#include "webrtc/base/thread_annotations.h"
#include "webrtc/base/thread_checker.h"
#include "webrtc/media/base/videosinkinterface.h"
#include "webrtc/media/base/videosourceinterface.h"
#include "webrtc/call/call.h"
#include "webrtc/call/flexfec_receive_stream.h"
#include "webrtc/media/base/mediaengine.h"
#include "webrtc/media/engine/webrtcvideodecoderfactory.h"
#include "webrtc/media/engine/webrtcvideoencoderfactory.h"
#include "webrtc/video_receive_stream.h"
#include "webrtc/video_send_stream.h"

namespace webrtc {
class VideoDecoder;
class VideoEncoder;
struct MediaConfig;
}

namespace rtc {
class Thread;
}  // namespace rtc

namespace cricket {

class VideoCapturer;
class VideoProcessor;
class VideoRenderer;
class VoiceMediaChannel;
class WebRtcDecoderObserver;
class WebRtcEncoderObserver;
class WebRtcLocalStreamInfo;
class WebRtcRenderAdapter;
class WebRtcVideoChannel2;
class WebRtcVideoChannelRecvInfo;
class WebRtcVideoChannelSendInfo;
class WebRtcVoiceEngine;
class WebRtcVoiceMediaChannel;

struct Device;

class UnsignalledSsrcHandler {
 public:
  enum Action {
    kDropPacket,
    kDeliverPacket,
  };
  virtual Action OnUnsignalledSsrc(WebRtcVideoChannel2* channel,
                                   uint32_t ssrc) = 0;
  virtual ~UnsignalledSsrcHandler() = default;
};

// TODO(pbos): Remove, use external handlers only.
class DefaultUnsignalledSsrcHandler : public UnsignalledSsrcHandler {
 public:
  DefaultUnsignalledSsrcHandler();
  Action OnUnsignalledSsrc(WebRtcVideoChannel2* channel,
                           uint32_t ssrc) override;

  rtc::VideoSinkInterface<webrtc::VideoFrame>* GetDefaultSink() const;
  void SetDefaultSink(VideoMediaChannel* channel,
                      rtc::VideoSinkInterface<webrtc::VideoFrame>* sink);
  virtual ~DefaultUnsignalledSsrcHandler() = default;

 private:
  uint32_t default_recv_ssrc_;
  rtc::VideoSinkInterface<webrtc::VideoFrame>* default_sink_;
};

// WebRtcVideoEngine2 is used for the new native WebRTC Video API (webrtc:1667).
class WebRtcVideoEngine2 {
 public:
  WebRtcVideoEngine2();
  virtual ~WebRtcVideoEngine2();

  // Basic video engine implementation.
  void Init();

  WebRtcVideoChannel2* CreateChannel(webrtc::Call* call,
                                     const MediaConfig& config,
                                     const VideoOptions& options);

  std::vector<VideoCodec> codecs() const;
  RtpCapabilities GetCapabilities() const;

  // Set a WebRtcVideoDecoderFactory for external decoding. Video engine does
  // not take the ownership of |decoder_factory|. The caller needs to make sure
  // that |decoder_factory| outlives the video engine.
  void SetExternalDecoderFactory(WebRtcVideoDecoderFactory* decoder_factory);
  // Set a WebRtcVideoEncoderFactory for external encoding. Video engine does
  // not take the ownership of |encoder_factory|. The caller needs to make sure
  // that |encoder_factory| outlives the video engine.
  virtual void SetExternalEncoderFactory(
      WebRtcVideoEncoderFactory* encoder_factory);

 private:
  bool initialized_;

  WebRtcVideoDecoderFactory* external_decoder_factory_;
  WebRtcVideoEncoderFactory* external_encoder_factory_;
  std::unique_ptr<WebRtcVideoEncoderFactory> simulcast_encoder_factory_;
};

class WebRtcVideoChannel2 : public VideoMediaChannel, public webrtc::Transport {
 public:
  WebRtcVideoChannel2(webrtc::Call* call,
                      const MediaConfig& config,
                      const VideoOptions& options,
                      WebRtcVideoEncoderFactory* external_encoder_factory,
                      WebRtcVideoDecoderFactory* external_decoder_factory);
  ~WebRtcVideoChannel2() override;

  // VideoMediaChannel implementation
  rtc::DiffServCodePoint PreferredDscp() const override;

  bool SetSendParameters(const VideoSendParameters& params) override;
  bool SetRecvParameters(const VideoRecvParameters& params) override;
  webrtc::RtpParameters GetRtpSendParameters(uint32_t ssrc) const override;
  bool SetRtpSendParameters(uint32_t ssrc,
                            const webrtc::RtpParameters& parameters) override;
  webrtc::RtpParameters GetRtpReceiveParameters(uint32_t ssrc) const override;
  bool SetRtpReceiveParameters(
      uint32_t ssrc,
      const webrtc::RtpParameters& parameters) override;
  bool GetSendCodec(VideoCodec* send_codec) override;
  bool SetSend(bool send) override;
  bool SetVideoSend(
      uint32_t ssrc,
      bool enable,
      const VideoOptions* options,
      rtc::VideoSourceInterface<webrtc::VideoFrame>* source) override;
  bool AddSendStream(const StreamParams& sp) override;
  bool RemoveSendStream(uint32_t ssrc) override;
  bool AddRecvStream(const StreamParams& sp) override;
  bool AddRecvStream(const StreamParams& sp, bool default_stream);
  bool RemoveRecvStream(uint32_t ssrc) override;
  bool SetSink(uint32_t ssrc,
               rtc::VideoSinkInterface<webrtc::VideoFrame>* sink) override;
  bool GetStats(VideoMediaInfo* info) override;

  void OnPacketReceived(rtc::CopyOnWriteBuffer* packet,
                        const rtc::PacketTime& packet_time) override;
  void OnRtcpReceived(rtc::CopyOnWriteBuffer* packet,
                      const rtc::PacketTime& packet_time) override;
  void OnReadyToSend(bool ready) override;
  void OnNetworkRouteChanged(const std::string& transport_name,
                             const rtc::NetworkRoute& network_route) override;
  void OnTransportOverheadChanged(int transport_overhead_per_packet) override;
  void SetInterface(NetworkInterface* iface) override;

  // Implemented for VideoMediaChannelTest.
  bool sending() const { return sending_; }

  // AdaptReason is used for expressing why a WebRtcVideoSendStream request
  // a lower input frame size than the currently configured camera input frame
  // size. There can be more than one reason OR:ed together.
  enum AdaptReason {
    ADAPTREASON_NONE = 0,
    ADAPTREASON_CPU = 1,
    ADAPTREASON_BANDWIDTH = 2,
  };

 private:
  class WebRtcVideoReceiveStream;
  struct VideoCodecSettings {
    VideoCodecSettings();

    bool operator==(const VideoCodecSettings& other) const;
    bool operator!=(const VideoCodecSettings& other) const;

    VideoCodec codec;
    webrtc::UlpfecConfig ulpfec;
    int flexfec_payload_type;
    int rtx_payload_type;
  };

  struct ChangedSendParameters {
    // These optionals are unset if not changed.
    rtc::Optional<VideoCodecSettings> codec;
    rtc::Optional<std::vector<webrtc::RtpExtension>> rtp_header_extensions;
    rtc::Optional<int> max_bandwidth_bps;
    rtc::Optional<bool> conference_mode;
    rtc::Optional<webrtc::RtcpMode> rtcp_mode;
  };

  struct ChangedRecvParameters {
    // These optionals are unset if not changed.
    rtc::Optional<std::vector<VideoCodecSettings>> codec_settings;
    rtc::Optional<std::vector<webrtc::RtpExtension>> rtp_header_extensions;
  };

  bool GetChangedSendParameters(const VideoSendParameters& params,
                                ChangedSendParameters* changed_params) const;
  bool GetChangedRecvParameters(const VideoRecvParameters& params,
                                ChangedRecvParameters* changed_params) const;

  void SetMaxSendBandwidth(int bps);

  void ConfigureReceiverRtp(
      webrtc::VideoReceiveStream::Config* config,
      webrtc::FlexfecReceiveStream::Config* flexfec_config,
      const StreamParams& sp) const;
  bool ValidateSendSsrcAvailability(const StreamParams& sp) const
      EXCLUSIVE_LOCKS_REQUIRED(stream_crit_);
  bool ValidateReceiveSsrcAvailability(const StreamParams& sp) const
      EXCLUSIVE_LOCKS_REQUIRED(stream_crit_);
  void DeleteReceiveStream(WebRtcVideoReceiveStream* stream)
      EXCLUSIVE_LOCKS_REQUIRED(stream_crit_);

  static std::string CodecSettingsVectorToString(
      const std::vector<VideoCodecSettings>& codecs);

  // Wrapper for the sender part.
  class WebRtcVideoSendStream
      : public rtc::VideoSourceInterface<webrtc::VideoFrame> {
   public:
    WebRtcVideoSendStream(
        webrtc::Call* call,
        const StreamParams& sp,
        webrtc::VideoSendStream::Config config,
        const VideoOptions& options,
        WebRtcVideoEncoderFactory* external_encoder_factory,
        bool enable_cpu_overuse_detection,
        int max_bitrate_bps,
        const rtc::Optional<VideoCodecSettings>& codec_settings,
        const rtc::Optional<std::vector<webrtc::RtpExtension>>& rtp_extensions,
        const VideoSendParameters& send_params);
    virtual ~WebRtcVideoSendStream();

    void SetSendParameters(const ChangedSendParameters& send_params);
    bool SetRtpParameters(const webrtc::RtpParameters& parameters);
    webrtc::RtpParameters GetRtpParameters() const;

    // Implements rtc::VideoSourceInterface<webrtc::VideoFrame>.
    // WebRtcVideoSendStream acts as a source to the webrtc::VideoSendStream
    // in |stream_|. This is done to proxy VideoSinkWants from the encoder to
    // the worker thread.
    void AddOrUpdateSink(rtc::VideoSinkInterface<webrtc::VideoFrame>* sink,
                         const rtc::VideoSinkWants& wants) override;
    void RemoveSink(rtc::VideoSinkInterface<webrtc::VideoFrame>* sink) override;

    bool SetVideoSend(bool mute,
                      const VideoOptions* options,
                      rtc::VideoSourceInterface<webrtc::VideoFrame>* source);

    void SetSend(bool send);

    const std::vector<uint32_t>& GetSsrcs() const;
    VideoSenderInfo GetVideoSenderInfo(bool log_stats);
    void FillBandwidthEstimationInfo(BandwidthEstimationInfo* bwe_info);

   private:
    // Parameters needed to reconstruct the underlying stream.
    // webrtc::VideoSendStream doesn't support setting a lot of options on the
    // fly, so when those need to be changed we tear down and reconstruct with
    // similar parameters depending on which options changed etc.
    struct VideoSendStreamParameters {
      VideoSendStreamParameters(
          webrtc::VideoSendStream::Config config,
          const VideoOptions& options,
          int max_bitrate_bps,
          const rtc::Optional<VideoCodecSettings>& codec_settings);
      webrtc::VideoSendStream::Config config;
      VideoOptions options;
      int max_bitrate_bps;
      bool conference_mode;
      rtc::Optional<VideoCodecSettings> codec_settings;
      // Sent resolutions + bitrates etc. by the underlying VideoSendStream,
      // typically changes when setting a new resolution or reconfiguring
      // bitrates.
      webrtc::VideoEncoderConfig encoder_config;
    };

    struct AllocatedEncoder {
      AllocatedEncoder(webrtc::VideoEncoder* encoder,
                       const cricket::VideoCodec& codec,
                       bool external);
      webrtc::VideoEncoder* encoder;
      webrtc::VideoEncoder* external_encoder;
      cricket::VideoCodec codec;
      bool external;
    };

    rtc::scoped_refptr<webrtc::VideoEncoderConfig::EncoderSpecificSettings>
    ConfigureVideoEncoderSettings(const VideoCodec& codec);
    AllocatedEncoder CreateVideoEncoder(const VideoCodec& codec);
    void DestroyVideoEncoder(AllocatedEncoder* encoder);
    void SetCodec(const VideoCodecSettings& codec);
    void RecreateWebRtcStream();
    webrtc::VideoEncoderConfig CreateVideoEncoderConfig(
        const VideoCodec& codec) const;
    void ReconfigureEncoder();
    bool ValidateRtpParameters(const webrtc::RtpParameters& parameters);

    // Calls Start or Stop according to whether or not |sending_| is true,
    // and whether or not the encoding in |rtp_parameters_| is active.
    void UpdateSendState();

    rtc::ThreadChecker thread_checker_;
    rtc::AsyncInvoker invoker_;
    rtc::Thread* worker_thread_;
    const std::vector<uint32_t> ssrcs_ ACCESS_ON(&thread_checker_);
    const std::vector<SsrcGroup> ssrc_groups_ ACCESS_ON(&thread_checker_);
    webrtc::Call* const call_;
    const bool enable_cpu_overuse_detection_;
    rtc::VideoSourceInterface<webrtc::VideoFrame>* source_
        ACCESS_ON(&thread_checker_);
    WebRtcVideoEncoderFactory* const external_encoder_factory_
        ACCESS_ON(&thread_checker_);
    const std::unique_ptr<WebRtcVideoEncoderFactory> internal_encoder_factory_
        ACCESS_ON(&thread_checker_);

    webrtc::VideoSendStream* stream_ ACCESS_ON(&thread_checker_);
    rtc::VideoSinkInterface<webrtc::VideoFrame>* encoder_sink_
        ACCESS_ON(&thread_checker_);
    // Contains settings that are the same for all streams in the MediaChannel,
    // such as codecs, header extensions, and the global bitrate limit for the
    // entire channel.
    VideoSendStreamParameters parameters_ ACCESS_ON(&thread_checker_);
    // Contains settings that are unique for each stream, such as max_bitrate.
    // Does *not* contain codecs, however.
    // TODO(skvlad): Move ssrcs_ and ssrc_groups_ into rtp_parameters_.
    // TODO(skvlad): Combine parameters_ and rtp_parameters_ once we have only
    // one stream per MediaChannel.
    webrtc::RtpParameters rtp_parameters_ ACCESS_ON(&thread_checker_);
    AllocatedEncoder allocated_encoder_ ACCESS_ON(&thread_checker_);

    bool sending_ ACCESS_ON(&thread_checker_);
  };

  // Wrapper for the receiver part, contains configs etc. that are needed to
  // reconstruct the underlying VideoReceiveStream.
  class WebRtcVideoReceiveStream
      : public rtc::VideoSinkInterface<webrtc::VideoFrame> {
   public:
    WebRtcVideoReceiveStream(
        webrtc::Call* call,
        const StreamParams& sp,
        webrtc::VideoReceiveStream::Config config,
        WebRtcVideoDecoderFactory* external_decoder_factory,
        bool default_stream,
        const std::vector<VideoCodecSettings>& recv_codecs,
        const webrtc::FlexfecReceiveStream::Config& flexfec_config);
    ~WebRtcVideoReceiveStream();

    const std::vector<uint32_t>& GetSsrcs() const;
    rtc::Optional<uint32_t> GetFirstPrimarySsrc() const;

    void SetLocalSsrc(uint32_t local_ssrc);
    // TODO(deadbeef): Move these feedback parameters into the recv parameters.
    void SetFeedbackParameters(bool nack_enabled,
                               bool remb_enabled,
                               bool transport_cc_enabled,
                               webrtc::RtcpMode rtcp_mode);
    void SetRecvParameters(const ChangedRecvParameters& recv_params);

    void OnFrame(const webrtc::VideoFrame& frame) override;
    bool IsDefaultStream() const;

    void SetSink(rtc::VideoSinkInterface<webrtc::VideoFrame>* sink);

    VideoReceiverInfo GetVideoReceiverInfo(bool log_stats);

   private:
    struct AllocatedDecoder {
      AllocatedDecoder(webrtc::VideoDecoder* decoder,
                       webrtc::VideoCodecType type,
                       bool external);
      webrtc::VideoDecoder* decoder;
      // Decoder wrapped into a fallback decoder to permit software fallback.
      webrtc::VideoDecoder* external_decoder;
      webrtc::VideoCodecType type;
      bool external;
    };

    void RecreateWebRtcStream();

    void ConfigureCodecs(const std::vector<VideoCodecSettings>& recv_codecs,
                         std::vector<AllocatedDecoder>* old_codecs);
    AllocatedDecoder CreateOrReuseVideoDecoder(
        std::vector<AllocatedDecoder>* old_decoder,
        const VideoCodec& codec);
    void ClearDecoders(std::vector<AllocatedDecoder>* allocated_decoders);

    std::string GetCodecNameFromPayloadType(int payload_type);

    webrtc::Call* const call_;
    StreamParams stream_params_;

    // Both |stream_| and |flexfec_stream_| are managed by |this|. They are
    // destroyed by calling call_->DestroyVideoReceiveStream and
    // call_->DestroyFlexfecReceiveStream, respectively.
    webrtc::VideoReceiveStream* stream_;
    const bool default_stream_;
    webrtc::VideoReceiveStream::Config config_;
    webrtc::FlexfecReceiveStream::Config flexfec_config_;
    webrtc::FlexfecReceiveStream* flexfec_stream_;

    WebRtcVideoDecoderFactory* const external_decoder_factory_;
    std::vector<AllocatedDecoder> allocated_decoders_;

    rtc::CriticalSection sink_lock_;
    rtc::VideoSinkInterface<webrtc::VideoFrame>* sink_ GUARDED_BY(sink_lock_);
    // Expands remote RTP timestamps to int64_t to be able to estimate how long
    // the stream has been running.
    rtc::TimestampWrapAroundHandler timestamp_wraparound_handler_
        GUARDED_BY(sink_lock_);
    int64_t first_frame_timestamp_ GUARDED_BY(sink_lock_);
    // Start NTP time is estimated as current remote NTP time (estimated from
    // RTCP) minus the elapsed time, as soon as remote NTP time is available.
    int64_t estimated_remote_start_ntp_time_ms_ GUARDED_BY(sink_lock_);
  };

  void Construct(webrtc::Call* call, WebRtcVideoEngine2* engine);

  bool SendRtp(const uint8_t* data,
               size_t len,
               const webrtc::PacketOptions& options) override;
  bool SendRtcp(const uint8_t* data, size_t len) override;

  static std::vector<VideoCodecSettings> MapCodecs(
      const std::vector<VideoCodec>& codecs);
  // Select what video codec will be used for sending, i.e. what codec is used
  // for local encoding, based on supported remote codecs. The first remote
  // codec that is supported locally will be selected.
  rtc::Optional<VideoCodecSettings> SelectSendVideoCodec(
      const std::vector<VideoCodecSettings>& remote_mapped_codecs) const;

  static bool ReceiveCodecsHaveChanged(std::vector<VideoCodecSettings> before,
                                       std::vector<VideoCodecSettings> after);

  void FillSenderStats(VideoMediaInfo* info, bool log_stats);
  void FillReceiverStats(VideoMediaInfo* info, bool log_stats);
  void FillBandwidthEstimationStats(const webrtc::Call::Stats& stats,
                                    VideoMediaInfo* info);
  void FillSendAndReceiveCodecStats(VideoMediaInfo* video_media_info);

  rtc::ThreadChecker thread_checker_;

  uint32_t rtcp_receiver_report_ssrc_;
  bool sending_;
  webrtc::Call* const call_;

  DefaultUnsignalledSsrcHandler default_unsignalled_ssrc_handler_;
  UnsignalledSsrcHandler* const unsignalled_ssrc_handler_;

  const MediaConfig::Video video_config_;

  rtc::CriticalSection stream_crit_;
  // Using primary-ssrc (first ssrc) as key.
  std::map<uint32_t, WebRtcVideoSendStream*> send_streams_
      GUARDED_BY(stream_crit_);
  std::map<uint32_t, WebRtcVideoReceiveStream*> receive_streams_
      GUARDED_BY(stream_crit_);
  std::set<uint32_t> send_ssrcs_ GUARDED_BY(stream_crit_);
  std::set<uint32_t> receive_ssrcs_ GUARDED_BY(stream_crit_);

  rtc::Optional<VideoCodecSettings> send_codec_;
  rtc::Optional<std::vector<webrtc::RtpExtension>> send_rtp_extensions_;

  WebRtcVideoEncoderFactory* const external_encoder_factory_;
  WebRtcVideoDecoderFactory* const external_decoder_factory_;
  std::vector<VideoCodecSettings> recv_codecs_;
  std::vector<webrtc::RtpExtension> recv_rtp_extensions_;
  webrtc::Call::Config::BitrateConfig bitrate_config_;
  // TODO(deadbeef): Don't duplicate information between
  // send_params/recv_params, rtp_extensions, options, etc.
  VideoSendParameters send_params_;
  VideoOptions default_send_options_;
  VideoRecvParameters recv_params_;
  int64_t last_stats_log_ms_;
};

}  // namespace cricket

#endif  // WEBRTC_MEDIA_ENGINE_WEBRTCVIDEOENGINE2_H_
