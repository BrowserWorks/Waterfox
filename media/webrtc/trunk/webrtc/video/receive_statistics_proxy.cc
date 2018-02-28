/*
 *  Copyright (c) 2013 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "webrtc/video/receive_statistics_proxy.h"

#include <cmath>

#include "webrtc/base/checks.h"
#include "webrtc/base/logging.h"
#include "webrtc/modules/video_coding/include/video_codec_interface.h"
#include "webrtc/system_wrappers/include/clock.h"
#include "webrtc/system_wrappers/include/field_trial.h"
#include "webrtc/system_wrappers/include/metrics.h"

namespace webrtc {
namespace {
// Periodic time interval for processing samples for |freq_offset_counter_|.
const int64_t kFreqOffsetProcessIntervalMs = 40000;

// Configuration for bad call detection.
const int kBadCallMinRequiredSamples = 10;
const int kMinSampleLengthMs = 990;
const int kNumMeasurements = 10;
const int kNumMeasurementsVariance = kNumMeasurements * 1.5;
const float kBadFraction = 0.8f;
// For fps:
// Low means low enough to be bad, high means high enough to be good
const int kLowFpsThreshold = 12;
const int kHighFpsThreshold = 14;
// For qp and fps variance:
// Low means low enough to be good, high means high enough to be bad
const int kLowQpThresholdVp8 = 60;
const int kHighQpThresholdVp8 = 70;
const int kLowVarianceThreshold = 1;
const int kHighVarianceThreshold = 2;
}  // namespace

ReceiveStatisticsProxy::ReceiveStatisticsProxy(
    const VideoReceiveStream::Config* config,
    Clock* clock)
    : clock_(clock),
      config_(*config),
      start_ms_(clock->TimeInMilliseconds()),
      last_sample_time_(clock->TimeInMilliseconds()),
      fps_threshold_(kLowFpsThreshold,
                     kHighFpsThreshold,
                     kBadFraction,
                     kNumMeasurements),
      qp_threshold_(kLowQpThresholdVp8,
                    kHighQpThresholdVp8,
                    kBadFraction,
                    kNumMeasurements),
      variance_threshold_(kLowVarianceThreshold,
                          kHighVarianceThreshold,
                          kBadFraction,
                          kNumMeasurementsVariance),
      num_bad_states_(0),
      num_certain_states_(0),
      // 1000ms window, scale 1000 for ms to s.
      decode_fps_estimator_(1000, 1000),
      renders_fps_estimator_(1000, 1000),
      render_fps_tracker_(100, 10u),
      render_pixel_tracker_(100u, 10u),
      freq_offset_counter_(clock, nullptr, kFreqOffsetProcessIntervalMs),
      first_report_block_time_ms_(-1),
      receive_state_(kReceiveStateInitial) {
  stats_.ssrc = config_.rtp.remote_ssrc;
  for (auto it : config_.rtp.rtx)
    rtx_stats_[it.second.ssrc] = StreamDataCounters();
}

ReceiveStatisticsProxy::~ReceiveStatisticsProxy() {
  UpdateHistograms();
}

void ReceiveStatisticsProxy::UpdateHistograms() {
  RTC_HISTOGRAM_COUNTS_100000(
      "WebRTC.Video.ReceiveStreamLifetimeInSeconds",
      (clock_->TimeInMilliseconds() - start_ms_) / 1000);

  if (first_report_block_time_ms_ != -1 &&
      ((clock_->TimeInMilliseconds() - first_report_block_time_ms_) / 1000) >=
          metrics::kMinRunTimeInSeconds) {
    int fraction_lost = report_block_stats_.FractionLostInPercent();
    if (fraction_lost != -1) {
      RTC_HISTOGRAM_PERCENTAGE("WebRTC.Video.ReceivedPacketsLostInPercent",
                               fraction_lost);
    }
  }

  const int kMinRequiredSamples = 200;
  int samples = static_cast<int>(render_fps_tracker_.TotalSampleCount());
  if (samples > kMinRequiredSamples) {
    RTC_HISTOGRAM_COUNTS_100("WebRTC.Video.RenderFramesPerSecond",
                             round(render_fps_tracker_.ComputeTotalRate()));
    RTC_HISTOGRAM_COUNTS_100000(
        "WebRTC.Video.RenderSqrtPixelsPerSecond",
        round(render_pixel_tracker_.ComputeTotalRate()));
  }
  int width = render_width_counter_.Avg(kMinRequiredSamples);
  int height = render_height_counter_.Avg(kMinRequiredSamples);
  if (width != -1) {
    RTC_HISTOGRAM_COUNTS_10000("WebRTC.Video.ReceivedWidthInPixels", width);
    RTC_HISTOGRAM_COUNTS_10000("WebRTC.Video.ReceivedHeightInPixels", height);
  }
  int sync_offset_ms = sync_offset_counter_.Avg(kMinRequiredSamples);
  if (sync_offset_ms != -1) {
    RTC_HISTOGRAM_COUNTS_10000("WebRTC.Video.AVSyncOffsetInMs", sync_offset_ms);
  }
  AggregatedStats freq_offset_stats = freq_offset_counter_.GetStats();
  if (freq_offset_stats.num_samples > 0) {
    RTC_HISTOGRAM_COUNTS_10000("WebRTC.Video.RtpToNtpFreqOffsetInKhz",
                               freq_offset_stats.average);
    LOG(LS_INFO) << "WebRTC.Video.RtpToNtpFreqOffsetInKhz, "
                 << freq_offset_stats.ToString();
  }

  int qp = qp_counters_.vp8.Avg(kMinRequiredSamples);
  if (qp != -1)
    RTC_HISTOGRAM_COUNTS_200("WebRTC.Video.Decoded.Vp8.Qp", qp);

  // TODO(asapersson): DecoderTiming() is call periodically (each 1000ms) and
  // not per frame. Change decode time to include every frame.
  const int kMinRequiredDecodeSamples = 5;
  int decode_ms = decode_time_counter_.Avg(kMinRequiredDecodeSamples);
  if (decode_ms != -1)
    RTC_HISTOGRAM_COUNTS_1000("WebRTC.Video.DecodeTimeInMs", decode_ms);

  if (field_trial::FindFullName("WebRTC-NewVideoJitterBuffer") !=
        "Enabled") {
    int jb_delay_ms =
        jitter_buffer_delay_counter_.Avg(kMinRequiredDecodeSamples);
    if (jb_delay_ms != -1) {
      RTC_HISTOGRAM_COUNTS_10000("WebRTC.Video.JitterBufferDelayInMs",
                                 jb_delay_ms);
    }
  }
  int target_delay_ms = target_delay_counter_.Avg(kMinRequiredDecodeSamples);
  if (target_delay_ms != -1) {
    RTC_HISTOGRAM_COUNTS_10000("WebRTC.Video.TargetDelayInMs", target_delay_ms);
  }
  int current_delay_ms = current_delay_counter_.Avg(kMinRequiredDecodeSamples);
  if (current_delay_ms != -1) {
    RTC_HISTOGRAM_COUNTS_10000("WebRTC.Video.CurrentDelayInMs",
                               current_delay_ms);
  }
  int delay_ms = delay_counter_.Avg(kMinRequiredDecodeSamples);
  if (delay_ms != -1)
    RTC_HISTOGRAM_COUNTS_10000("WebRTC.Video.OnewayDelayInMs", delay_ms);

  int e2e_delay_ms = e2e_delay_counter_.Avg(kMinRequiredSamples);
  if (e2e_delay_ms != -1)
    RTC_HISTOGRAM_COUNTS_10000("WebRTC.Video.EndToEndDelayInMs", e2e_delay_ms);

  StreamDataCounters rtp = stats_.rtp_stats;
  StreamDataCounters rtx;
  for (auto it : rtx_stats_)
    rtx.Add(it.second);
  StreamDataCounters rtp_rtx = rtp;
  rtp_rtx.Add(rtx);
  int64_t elapsed_sec =
      rtp_rtx.TimeSinceFirstPacketInMs(clock_->TimeInMilliseconds()) / 1000;
  if (elapsed_sec > metrics::kMinRunTimeInSeconds) {
    RTC_HISTOGRAM_COUNTS_10000(
        "WebRTC.Video.BitrateReceivedInKbps",
        static_cast<int>(rtp_rtx.transmitted.TotalBytes() * 8 / elapsed_sec /
                         1000));
    RTC_HISTOGRAM_COUNTS_10000(
        "WebRTC.Video.MediaBitrateReceivedInKbps",
        static_cast<int>(rtp.MediaPayloadBytes() * 8 / elapsed_sec / 1000));
    RTC_HISTOGRAM_COUNTS_10000(
        "WebRTC.Video.PaddingBitrateReceivedInKbps",
        static_cast<int>(rtp_rtx.transmitted.padding_bytes * 8 / elapsed_sec /
                         1000));
    RTC_HISTOGRAM_COUNTS_10000(
        "WebRTC.Video.RetransmittedBitrateReceivedInKbps",
        static_cast<int>(rtp_rtx.retransmitted.TotalBytes() * 8 / elapsed_sec /
                         1000));
    if (!rtx_stats_.empty()) {
      RTC_HISTOGRAM_COUNTS_10000("WebRTC.Video.RtxBitrateReceivedInKbps",
                                 static_cast<int>(rtx.transmitted.TotalBytes() *
                                                  8 / elapsed_sec / 1000));
    }
    if (config_.rtp.ulpfec.ulpfec_payload_type != -1) {
      RTC_HISTOGRAM_COUNTS_10000(
          "WebRTC.Video.FecBitrateReceivedInKbps",
          static_cast<int>(rtp_rtx.fec.TotalBytes() * 8 / elapsed_sec / 1000));
    }
    const RtcpPacketTypeCounter& counters = stats_.rtcp_packet_type_counts;
    RTC_HISTOGRAM_COUNTS_10000("WebRTC.Video.NackPacketsSentPerMinute",
                               counters.nack_packets * 60 / elapsed_sec);
    RTC_HISTOGRAM_COUNTS_10000("WebRTC.Video.FirPacketsSentPerMinute",
                               counters.fir_packets * 60 / elapsed_sec);
    RTC_HISTOGRAM_COUNTS_10000("WebRTC.Video.PliPacketsSentPerMinute",
                               counters.pli_packets * 60 / elapsed_sec);
    if (counters.nack_requests > 0) {
      RTC_HISTOGRAM_PERCENTAGE("WebRTC.Video.UniqueNackRequestsSentInPercent",
                               counters.UniqueNackRequestsInPercent());
    }
  }

  if (num_certain_states_ >= kBadCallMinRequiredSamples) {
    RTC_HISTOGRAM_PERCENTAGE("WebRTC.Video.BadCall.Any",
                             100 * num_bad_states_ / num_certain_states_);
  }
  rtc::Optional<double> fps_fraction =
      fps_threshold_.FractionHigh(kBadCallMinRequiredSamples);
  if (fps_fraction) {
    RTC_HISTOGRAM_PERCENTAGE("WebRTC.Video.BadCall.FrameRate",
                             static_cast<int>(100 * (1 - *fps_fraction)));
  }
  rtc::Optional<double> variance_fraction =
      variance_threshold_.FractionHigh(kBadCallMinRequiredSamples);
  if (variance_fraction) {
    RTC_HISTOGRAM_PERCENTAGE("WebRTC.Video.BadCall.FrameRateVariance",
                             static_cast<int>(100 * *variance_fraction));
  }
  rtc::Optional<double> qp_fraction =
      qp_threshold_.FractionHigh(kBadCallMinRequiredSamples);
  if (qp_fraction) {
    RTC_HISTOGRAM_PERCENTAGE("WebRTC.Video.BadCall.Qp",
                             static_cast<int>(100 * *qp_fraction));
  }
}

void ReceiveStatisticsProxy::QualitySample() {
  int64_t now = clock_->TimeInMilliseconds();
  if (last_sample_time_ + kMinSampleLengthMs > now)
    return;

  double fps =
      render_fps_tracker_.ComputeRateForInterval(now - last_sample_time_);
  int qp = qp_sample_.Avg(1);

  bool prev_fps_bad = !fps_threshold_.IsHigh().value_or(true);
  bool prev_qp_bad = qp_threshold_.IsHigh().value_or(false);
  bool prev_variance_bad = variance_threshold_.IsHigh().value_or(false);
  bool prev_any_bad = prev_fps_bad || prev_qp_bad || prev_variance_bad;

  fps_threshold_.AddMeasurement(static_cast<int>(fps));
  if (qp != -1)
    qp_threshold_.AddMeasurement(qp);
  rtc::Optional<double> fps_variance_opt = fps_threshold_.CalculateVariance();
  double fps_variance = fps_variance_opt.value_or(0);
  if (fps_variance_opt) {
    variance_threshold_.AddMeasurement(static_cast<int>(fps_variance));
  }

  bool fps_bad = !fps_threshold_.IsHigh().value_or(true);
  bool qp_bad = qp_threshold_.IsHigh().value_or(false);
  bool variance_bad = variance_threshold_.IsHigh().value_or(false);
  bool any_bad = fps_bad || qp_bad || variance_bad;

  if (!prev_any_bad && any_bad) {
    LOG(LS_INFO) << "Bad call (any) start: " << now;
  } else if (prev_any_bad && !any_bad) {
    LOG(LS_INFO) << "Bad call (any) end: " << now;
  }

  if (!prev_fps_bad && fps_bad) {
    LOG(LS_INFO) << "Bad call (fps) start: " << now;
  } else if (prev_fps_bad && !fps_bad) {
    LOG(LS_INFO) << "Bad call (fps) end: " << now;
  }

  if (!prev_qp_bad && qp_bad) {
    LOG(LS_INFO) << "Bad call (qp) start: " << now;
  } else if (prev_qp_bad && !qp_bad) {
    LOG(LS_INFO) << "Bad call (qp) end: " << now;
  }

  if (!prev_variance_bad && variance_bad) {
    LOG(LS_INFO) << "Bad call (variance) start: " << now;
  } else if (prev_variance_bad && !variance_bad) {
    LOG(LS_INFO) << "Bad call (variance) end: " << now;
  }

  LOG(LS_VERBOSE) << "SAMPLE: sample_length: " << (now - last_sample_time_)
                  << " fps: " << fps << " fps_bad: " << fps_bad << " qp: " << qp
                  << " qp_bad: " << qp_bad << " variance_bad: " << variance_bad
                  << " fps_variance: " << fps_variance;

  last_sample_time_ = now;
  qp_sample_.Reset();

  if (fps_threshold_.IsHigh() || variance_threshold_.IsHigh() ||
      qp_threshold_.IsHigh()) {
    if (any_bad)
      ++num_bad_states_;
    ++num_certain_states_;
  }
}

VideoReceiveStream::Stats ReceiveStatisticsProxy::GetStats() const {
  rtc::CritScope lock(&crit_);
  return stats_;
}

void ReceiveStatisticsProxy::OnIncomingPayloadType(int payload_type) {
  rtc::CritScope lock(&crit_);
  stats_.current_payload_type = payload_type;
}

void ReceiveStatisticsProxy::OnDecoderImplementationName(
    const char* implementation_name) {
  rtc::CritScope lock(&crit_);
  stats_.decoder_implementation_name = implementation_name;
}
void ReceiveStatisticsProxy::OnIncomingRate(unsigned int framerate,
                                            unsigned int bitrate_bps) {
  rtc::CritScope lock(&crit_);
  if (stats_.rtp_stats.first_packet_time_ms != -1)
    QualitySample();
  stats_.network_frame_rate = framerate;
  stats_.total_bitrate_bps = bitrate_bps;
}

void ReceiveStatisticsProxy::ReceiveStateChange(VideoReceiveState state) {
  rtc::CritScope lock(&crit_);
  receive_state_ = state;
}

void ReceiveStatisticsProxy::OnDecoderTiming(int decode_ms,
                                             int max_decode_ms,
                                             int current_delay_ms,
                                             int target_delay_ms,
                                             int jitter_buffer_ms,
                                             int min_playout_delay_ms,
                                             int render_delay_ms,
                                             int64_t rtt_ms) {
  rtc::CritScope lock(&crit_);
  stats_.decode_ms = decode_ms;
  stats_.max_decode_ms = max_decode_ms;
  stats_.current_delay_ms = current_delay_ms;
  stats_.target_delay_ms = target_delay_ms;
  stats_.jitter_buffer_ms = jitter_buffer_ms;
  stats_.min_playout_delay_ms = min_playout_delay_ms;
  stats_.render_delay_ms = render_delay_ms;
  decode_time_counter_.Add(decode_ms);
  jitter_buffer_delay_counter_.Add(jitter_buffer_ms);
  target_delay_counter_.Add(target_delay_ms);
  current_delay_counter_.Add(current_delay_ms);
  // Network delay (rtt/2) + target_delay_ms (jitter delay + decode time +
  // render delay).
  delay_counter_.Add(target_delay_ms + rtt_ms / 2);
}

void ReceiveStatisticsProxy::RtcpPacketTypesCounterUpdated(
    uint32_t ssrc,
    const RtcpPacketTypeCounter& packet_counter) {
  rtc::CritScope lock(&crit_);
  if (stats_.ssrc != ssrc)
    return;
  stats_.rtcp_packet_type_counts = packet_counter;
}

void ReceiveStatisticsProxy::StatisticsUpdated(
    const webrtc::RtcpStatistics& statistics,
    uint32_t ssrc) {
  rtc::CritScope lock(&crit_);
  // TODO(pbos): Handle both local and remote ssrcs here and RTC_DCHECK that we
  // receive stats from one of them.
  if (stats_.ssrc != ssrc)
    return;
  stats_.rtcp_stats = statistics;
  report_block_stats_.Store(statistics, ssrc, 0);

  if (first_report_block_time_ms_ == -1)
    first_report_block_time_ms_ = clock_->TimeInMilliseconds();
}

void ReceiveStatisticsProxy::CNameChanged(const char* cname, uint32_t ssrc) {
  rtc::CritScope lock(&crit_);
  // TODO(pbos): Handle both local and remote ssrcs here and RTC_DCHECK that we
  // receive stats from one of them.
  if (stats_.ssrc != ssrc)
    return;
  stats_.c_name = cname;
}

void ReceiveStatisticsProxy::DataCountersUpdated(
    const webrtc::StreamDataCounters& counters,
    uint32_t ssrc) {
  rtc::CritScope lock(&crit_);
  if (ssrc == stats_.ssrc) {
    stats_.rtp_stats = counters;
  } else {
    auto it = rtx_stats_.find(ssrc);
    if (it != rtx_stats_.end()) {
      it->second = counters;
    } else {
      RTC_NOTREACHED() << "Unexpected stream ssrc: " << ssrc;
    }
  }
}

void ReceiveStatisticsProxy::OnDecodedFrame() {
  uint64_t now = clock_->TimeInMilliseconds();

  rtc::CritScope lock(&crit_);
  ++stats_.frames_decoded;
  decode_fps_estimator_.Update(1, now);
  stats_.decode_frame_rate = decode_fps_estimator_.Rate(now).value_or(0);
}

void ReceiveStatisticsProxy::OnRenderedFrame(const VideoFrame& frame) {
  int width = frame.width();
  int height = frame.height();
  RTC_DCHECK_GT(width, 0);
  RTC_DCHECK_GT(height, 0);
  uint64_t now = clock_->TimeInMilliseconds();

  rtc::CritScope lock(&crit_);
  renders_fps_estimator_.Update(1, now);
  stats_.render_frame_rate = renders_fps_estimator_.Rate(now).value_or(0);
  stats_.width = width;
  stats_.height = height;
  render_width_counter_.Add(width);
  render_height_counter_.Add(height);
  render_fps_tracker_.AddSamples(1);
  render_pixel_tracker_.AddSamples(sqrt(width * height));

  if (frame.ntp_time_ms() > 0) {
    int64_t delay_ms = clock_->CurrentNtpInMilliseconds() - frame.ntp_time_ms();
    if (delay_ms >= 0)
      e2e_delay_counter_.Add(delay_ms);
  }
}

void ReceiveStatisticsProxy::OnSyncOffsetUpdated(int64_t sync_offset_ms,
                                                 double estimated_freq_khz) {
  rtc::CritScope lock(&crit_);
  sync_offset_counter_.Add(std::abs(sync_offset_ms));
  stats_.sync_offset_ms = sync_offset_ms;

  const double kMaxFreqKhz = 10000.0;
  int offset_khz = kMaxFreqKhz;
  // Should not be zero or negative. If so, report max.
  if (estimated_freq_khz < kMaxFreqKhz && estimated_freq_khz > 0.0)
    offset_khz = static_cast<int>(std::fabs(estimated_freq_khz - 90.0) + 0.5);

  freq_offset_counter_.Add(offset_khz);
}

void ReceiveStatisticsProxy::OnReceiveRatesUpdated(uint32_t bitRate,
                                                   uint32_t frameRate) {
}

void ReceiveStatisticsProxy::OnFrameCountsUpdated(
    const FrameCounts& frame_counts) {
  rtc::CritScope lock(&crit_);
  stats_.frame_counts = frame_counts;
}

void ReceiveStatisticsProxy::OnDiscardedPacketsUpdated(int discarded_packets) {
  rtc::CritScope lock(&crit_);
  stats_.discarded_packets = discarded_packets;
}

void ReceiveStatisticsProxy::OnPreDecode(
    const EncodedImage& encoded_image,
    const CodecSpecificInfo* codec_specific_info) {
  if (!codec_specific_info || encoded_image.qp_ == -1) {
    return;
  }
  if (codec_specific_info->codecType == kVideoCodecVP8) {
    qp_counters_.vp8.Add(encoded_image.qp_);
    rtc::CritScope lock(&crit_);
    qp_sample_.Add(encoded_image.qp_);
  }
}

void ReceiveStatisticsProxy::SampleCounter::Add(int sample) {
  sum += sample;
  ++num_samples;
}

int ReceiveStatisticsProxy::SampleCounter::Avg(
    int64_t min_required_samples) const {
  if (num_samples < min_required_samples || num_samples == 0)
    return -1;
  return static_cast<int>(sum / num_samples);
}

void ReceiveStatisticsProxy::SampleCounter::Reset() {
  num_samples = 0;
  sum = 0;
}

}  // namespace webrtc
