/*
 *  Copyright 2013 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include <utility>

#include "webrtc/api/test/fakeperiodicvideocapturer.h"
#include "webrtc/api/test/fakertccertificategenerator.h"
#include "webrtc/api/test/mockpeerconnectionobservers.h"
#include "webrtc/api/test/peerconnectiontestwrapper.h"
#include "webrtc/base/gunit.h"
#include "webrtc/p2p/base/fakeportallocator.h"

static const char kStreamLabelBase[] = "stream_label";
static const char kVideoTrackLabelBase[] = "video_track";
static const char kAudioTrackLabelBase[] = "audio_track";
static const int kMaxWait = 10000;
static const int kTestAudioFrameCount = 3;
static const int kTestVideoFrameCount = 3;

using webrtc::FakeConstraints;
using webrtc::FakeVideoTrackRenderer;
using webrtc::IceCandidateInterface;
using webrtc::MediaConstraintsInterface;
using webrtc::MediaStreamInterface;
using webrtc::MockSetSessionDescriptionObserver;
using webrtc::PeerConnectionInterface;
using webrtc::SessionDescriptionInterface;
using webrtc::VideoTrackInterface;

void PeerConnectionTestWrapper::Connect(PeerConnectionTestWrapper* caller,
                                        PeerConnectionTestWrapper* callee) {
  caller->SignalOnIceCandidateReady.connect(
      callee, &PeerConnectionTestWrapper::AddIceCandidate);
  callee->SignalOnIceCandidateReady.connect(
      caller, &PeerConnectionTestWrapper::AddIceCandidate);

  caller->SignalOnSdpReady.connect(
      callee, &PeerConnectionTestWrapper::ReceiveOfferSdp);
  callee->SignalOnSdpReady.connect(
      caller, &PeerConnectionTestWrapper::ReceiveAnswerSdp);
}

PeerConnectionTestWrapper::PeerConnectionTestWrapper(
    const std::string& name,
    rtc::Thread* network_thread,
    rtc::Thread* worker_thread)
    : name_(name),
      network_thread_(network_thread),
      worker_thread_(worker_thread) {}

PeerConnectionTestWrapper::~PeerConnectionTestWrapper() {}

bool PeerConnectionTestWrapper::CreatePc(
    const MediaConstraintsInterface* constraints,
    const webrtc::PeerConnectionInterface::RTCConfiguration& config) {
  std::unique_ptr<cricket::PortAllocator> port_allocator(
      new cricket::FakePortAllocator(network_thread_, nullptr));

  fake_audio_capture_module_ = FakeAudioCaptureModule::Create();
  if (fake_audio_capture_module_ == NULL) {
    return false;
  }

  peer_connection_factory_ = webrtc::CreatePeerConnectionFactory(
      network_thread_, worker_thread_, rtc::Thread::Current(),
      fake_audio_capture_module_, NULL, NULL);
  if (!peer_connection_factory_) {
    return false;
  }

  std::unique_ptr<rtc::RTCCertificateGeneratorInterface> cert_generator(
      rtc::SSLStreamAdapter::HaveDtlsSrtp() ? new FakeRTCCertificateGenerator()
                                            : nullptr);
  peer_connection_ = peer_connection_factory_->CreatePeerConnection(
      config, constraints, std::move(port_allocator), std::move(cert_generator),
      this);

  return peer_connection_.get() != NULL;
}

rtc::scoped_refptr<webrtc::DataChannelInterface>
PeerConnectionTestWrapper::CreateDataChannel(
    const std::string& label,
    const webrtc::DataChannelInit& init) {
  return peer_connection_->CreateDataChannel(label, &init);
}

void PeerConnectionTestWrapper::OnAddStream(
    rtc::scoped_refptr<MediaStreamInterface> stream) {
  LOG(LS_INFO) << "PeerConnectionTestWrapper " << name_
               << ": OnAddStream";
  // TODO(ronghuawu): support multiple streams.
  if (stream->GetVideoTracks().size() > 0) {
    renderer_.reset(new FakeVideoTrackRenderer(stream->GetVideoTracks()[0]));
  }
}

void PeerConnectionTestWrapper::OnIceCandidate(
    const IceCandidateInterface* candidate) {
  std::string sdp;
  EXPECT_TRUE(candidate->ToString(&sdp));
  // Give the user a chance to modify sdp for testing.
  SignalOnIceCandidateCreated(&sdp);
  SignalOnIceCandidateReady(candidate->sdp_mid(), candidate->sdp_mline_index(),
                            sdp);
}

void PeerConnectionTestWrapper::OnDataChannel(
    rtc::scoped_refptr<webrtc::DataChannelInterface> data_channel) {
  SignalOnDataChannel(data_channel);
}

void PeerConnectionTestWrapper::OnSuccess(SessionDescriptionInterface* desc) {
  // This callback should take the ownership of |desc|.
  std::unique_ptr<SessionDescriptionInterface> owned_desc(desc);
  std::string sdp;
  EXPECT_TRUE(desc->ToString(&sdp));

  LOG(LS_INFO) << "PeerConnectionTestWrapper " << name_
               << ": " << desc->type() << " sdp created: " << sdp;

  // Give the user a chance to modify sdp for testing.
  SignalOnSdpCreated(&sdp);

  SetLocalDescription(desc->type(), sdp);

  SignalOnSdpReady(sdp);
}

void PeerConnectionTestWrapper::CreateOffer(
    const MediaConstraintsInterface* constraints) {
  LOG(LS_INFO) << "PeerConnectionTestWrapper " << name_
               << ": CreateOffer.";
  peer_connection_->CreateOffer(this, constraints);
}

void PeerConnectionTestWrapper::CreateAnswer(
    const MediaConstraintsInterface* constraints) {
  LOG(LS_INFO) << "PeerConnectionTestWrapper " << name_
               << ": CreateAnswer.";
  peer_connection_->CreateAnswer(this, constraints);
}

void PeerConnectionTestWrapper::ReceiveOfferSdp(const std::string& sdp) {
  SetRemoteDescription(SessionDescriptionInterface::kOffer, sdp);
  CreateAnswer(NULL);
}

void PeerConnectionTestWrapper::ReceiveAnswerSdp(const std::string& sdp) {
  SetRemoteDescription(SessionDescriptionInterface::kAnswer, sdp);
}

void PeerConnectionTestWrapper::SetLocalDescription(const std::string& type,
                                                    const std::string& sdp) {
  LOG(LS_INFO) << "PeerConnectionTestWrapper " << name_
               << ": SetLocalDescription " << type << " " << sdp;

  rtc::scoped_refptr<MockSetSessionDescriptionObserver>
      observer(new rtc::RefCountedObject<
                   MockSetSessionDescriptionObserver>());
  peer_connection_->SetLocalDescription(
      observer, webrtc::CreateSessionDescription(type, sdp, NULL));
}

void PeerConnectionTestWrapper::SetRemoteDescription(const std::string& type,
                                                     const std::string& sdp) {
  LOG(LS_INFO) << "PeerConnectionTestWrapper " << name_
               << ": SetRemoteDescription " << type << " " << sdp;

  rtc::scoped_refptr<MockSetSessionDescriptionObserver>
      observer(new rtc::RefCountedObject<
                   MockSetSessionDescriptionObserver>());
  peer_connection_->SetRemoteDescription(
      observer, webrtc::CreateSessionDescription(type, sdp, NULL));
}

void PeerConnectionTestWrapper::AddIceCandidate(const std::string& sdp_mid,
                                                int sdp_mline_index,
                                                const std::string& candidate) {
  std::unique_ptr<webrtc::IceCandidateInterface> owned_candidate(
      webrtc::CreateIceCandidate(sdp_mid, sdp_mline_index, candidate, NULL));
  EXPECT_TRUE(peer_connection_->AddIceCandidate(owned_candidate.get()));
}

void PeerConnectionTestWrapper::WaitForCallEstablished() {
  WaitForConnection();
  WaitForAudio();
  WaitForVideo();
}

void PeerConnectionTestWrapper::WaitForConnection() {
  EXPECT_TRUE_WAIT(CheckForConnection(), kMaxWait);
  LOG(LS_INFO) << "PeerConnectionTestWrapper " << name_
               << ": Connected.";
}

bool PeerConnectionTestWrapper::CheckForConnection() {
  return (peer_connection_->ice_connection_state() ==
          PeerConnectionInterface::kIceConnectionConnected) ||
         (peer_connection_->ice_connection_state() ==
          PeerConnectionInterface::kIceConnectionCompleted);
}

void PeerConnectionTestWrapper::WaitForAudio() {
  EXPECT_TRUE_WAIT(CheckForAudio(), kMaxWait);
  LOG(LS_INFO) << "PeerConnectionTestWrapper " << name_
               << ": Got enough audio frames.";
}

bool PeerConnectionTestWrapper::CheckForAudio() {
  return (fake_audio_capture_module_->frames_received() >=
          kTestAudioFrameCount);
}

void PeerConnectionTestWrapper::WaitForVideo() {
  EXPECT_TRUE_WAIT(CheckForVideo(), kMaxWait);
  LOG(LS_INFO) << "PeerConnectionTestWrapper " << name_
               << ": Got enough video frames.";
}

bool PeerConnectionTestWrapper::CheckForVideo() {
  if (!renderer_) {
    return false;
  }
  return (renderer_->num_rendered_frames() >= kTestVideoFrameCount);
}

void PeerConnectionTestWrapper::GetAndAddUserMedia(
    bool audio, const webrtc::FakeConstraints& audio_constraints,
    bool video, const webrtc::FakeConstraints& video_constraints) {
  rtc::scoped_refptr<webrtc::MediaStreamInterface> stream =
      GetUserMedia(audio, audio_constraints, video, video_constraints);
  EXPECT_TRUE(peer_connection_->AddStream(stream));
}

rtc::scoped_refptr<webrtc::MediaStreamInterface>
    PeerConnectionTestWrapper::GetUserMedia(
        bool audio, const webrtc::FakeConstraints& audio_constraints,
        bool video, const webrtc::FakeConstraints& video_constraints) {
  std::string label = kStreamLabelBase +
      rtc::ToString<int>(
          static_cast<int>(peer_connection_->local_streams()->count()));
  rtc::scoped_refptr<webrtc::MediaStreamInterface> stream =
      peer_connection_factory_->CreateLocalMediaStream(label);

  if (audio) {
    FakeConstraints constraints = audio_constraints;
    // Disable highpass filter so that we can get all the test audio frames.
    constraints.AddMandatory(
        MediaConstraintsInterface::kHighpassFilter, false);
    rtc::scoped_refptr<webrtc::AudioSourceInterface> source =
        peer_connection_factory_->CreateAudioSource(&constraints);
    rtc::scoped_refptr<webrtc::AudioTrackInterface> audio_track(
        peer_connection_factory_->CreateAudioTrack(kAudioTrackLabelBase,
                                                   source));
    stream->AddTrack(audio_track);
  }

  if (video) {
    // Set max frame rate to 10fps to reduce the risk of the tests to be flaky.
    FakeConstraints constraints = video_constraints;
    constraints.SetMandatoryMaxFrameRate(10);

    rtc::scoped_refptr<webrtc::VideoTrackSourceInterface> source =
        peer_connection_factory_->CreateVideoSource(
            new webrtc::FakePeriodicVideoCapturer(), &constraints);
    std::string videotrack_label = label + kVideoTrackLabelBase;
    rtc::scoped_refptr<webrtc::VideoTrackInterface> video_track(
        peer_connection_factory_->CreateVideoTrack(videotrack_label, source));

    stream->AddTrack(video_track);
  }
  return stream;
}
