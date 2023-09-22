# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = WebRTC 내부 정보
# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = about:webrtc를 다음으로 저장

## These labels are for a disclosure which contains the information for closed PeerConnection sections

about-webrtc-closed-peerconnection-disclosure-show-msg = 닫힌 PeerConnections 표시
about-webrtc-closed-peerconnection-disclosure-hide-msg = 닫힌 PeerConnections 숨기기

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = AEC 로깅
about-webrtc-aec-logging-off-state-label = AEC 로깅 시작
about-webrtc-aec-logging-on-state-label = AEC 로깅 중지
about-webrtc-aec-logging-on-state-msg = AEC 로깅 활성화(몇 분 간 대화를 하고 캡처를 중지하세요)
about-webrtc-aec-logging-toggled-on-state-msg = AEC 로깅 활성화(몇 분 간 대화를 하고 캡처를 중지하세요)
about-webrtc-aec-logging-unavailable-sandbox = AEC 로그를 내보내려면 환경 변수 MOZ_DISABLE_CONTENT_SANDBOX=1 이 필요합니다. 가능한 위험을 이해하는 경우에만 이 변수를 설정하세요.
# Variables:
#  $path (String) - The path to which the aec log file is saved.
about-webrtc-aec-logging-toggled-off-state-msg = 캡처된 로그파일 위치: { $path }

##

# The autorefresh checkbox causes a stats section to autorefresh its content when checked
about-webrtc-auto-refresh-label = 자동 새로 고침
# Determines the default state of the Auto Refresh check boxes
about-webrtc-auto-refresh-default-label = 기본으로 자동 새로 고침
# A button which forces a refresh of displayed statistics
about-webrtc-force-refresh-button = 새로 고침
# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = PeerConnection ID:
# The number of DataChannels that a PeerConnection has opened
about-webrtc-data-channels-opened-label = 열린 데이터 채널:
# The number of once open DataChannels that a PeerConnection has closed
about-webrtc-data-channels-closed-label = 닫힌 데이터 채널:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = 로컬 SDP
about-webrtc-local-sdp-heading-offer = 로컬 SDP (제공)
about-webrtc-local-sdp-heading-answer = 로컬 SDP (답변)
about-webrtc-remote-sdp-heading = 원격 SDP
about-webrtc-remote-sdp-heading-offer = 원격 SDP (제공)
about-webrtc-remote-sdp-heading-answer = 원격 SDP (답변)
about-webrtc-sdp-history-heading = SDP 기록
about-webrtc-sdp-parsing-errors-heading = SDP 구문 분석 오류

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = RTP 상태

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = ICE 상태
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = ICE 통계
about-webrtc-ice-restart-count-label = ICE 다시 시작:
about-webrtc-ice-rollback-count-label = ICE 롤백:
about-webrtc-ice-pair-bytes-sent = 보낸 바이트:
about-webrtc-ice-pair-bytes-received = 받은 바이트:
about-webrtc-ice-component-id = 컴포넌트 ID

## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = 로컬
about-webrtc-type-remote = 원격

##

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = 지정됨
# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = 선택됨
about-webrtc-save-page-label = 페이지 저장
about-webrtc-debug-mode-msg-label = 디버그 모드
about-webrtc-debug-mode-off-state-label = 디버그 모드 시작
about-webrtc-debug-mode-on-state-label = 디버그 모드 중지
about-webrtc-enable-logging-label = WebRTC 로그 프리셋 활성화
about-webrtc-stats-heading = 세션 통계
about-webrtc-stats-clear = 기록 지우기
about-webrtc-log-heading = 연결 로그
about-webrtc-log-clear = 로그 지우기
about-webrtc-log-show-msg = 로그 표시
    .title = 이 섹션을 펼치려면 누르세요
about-webrtc-log-hide-msg = 로그 숨기기
    .title = 이 섹션을 접으려면 누르세요
about-webrtc-log-section-show-msg = 로그 표시
    .title = 이 섹션을 펼치려면 누르세요
about-webrtc-log-section-hide-msg = 로그 숨기기
    .title = 이 섹션을 접으려면 누르세요
about-webrtc-copy-report-button = 보고서 복사
about-webrtc-copy-report-history-button = 보고서 기록 복사

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (닫기) { $now }

## These are used to indicate what direction media is flowing.
## Variables:
##  $codecs - a list of media codecs

about-webrtc-short-send-receive-direction = 보내기 / 받기: { $codecs }
about-webrtc-short-send-direction = 보내기: { $codecs }
about-webrtc-short-receive-direction = 받기: { $codecs }

##

about-webrtc-local-candidate = 로컬 후보자
about-webrtc-remote-candidate = 원격 후보자
about-webrtc-raw-candidates-heading = 모든 원시 후보자
about-webrtc-raw-local-candidate = 원시 지역 후보자
about-webrtc-raw-remote-candidate = 원시 원격 후보자
about-webrtc-raw-cand-show-msg = 원시 후보자 표시
    .title = 이 섹션을 펼치려면 누르세요
about-webrtc-raw-cand-hide-msg = 원시 후보자 숨기기
    .title = 이 섹션을 접으려면 누르세요
about-webrtc-raw-cand-section-show-msg = 원시 후보자 표시
    .title = 이 섹션을 펼치려면 누르세요
about-webrtc-raw-cand-section-hide-msg = 원시 후보자 숨기기
    .title = 이 섹션을 접으려면 누르세요
about-webrtc-priority = 우선 순위
about-webrtc-fold-show-msg = 상세 표시
    .title = 이 섹션을 펼치려면 누르세요
about-webrtc-fold-hide-msg = 상세 숨기기
    .title = 이 섹션을 접으려면 누르세요
about-webrtc-fold-default-show-msg = 상세 표시
    .title = 이 섹션을 펼치려면 누르세요
about-webrtc-fold-default-hide-msg = 상세 숨기기
    .title = 이 섹션을 접으려면 누르세요
about-webrtc-dropped-frames-label = 손실된 프레임:
about-webrtc-discarded-packets-label = 버려진 패킷:
about-webrtc-decoder-label = 디코더
about-webrtc-encoder-label = 인코더
about-webrtc-show-tab-label = 탭 표시
about-webrtc-current-framerate-label = 프레임레이트
about-webrtc-width-px = 너비 (px)
about-webrtc-height-px = 높이 (px)
about-webrtc-consecutive-frames = 연속 프레임
about-webrtc-time-elapsed = 경과 시간 (초)
about-webrtc-estimated-framerate = 예상 프레임레이트
about-webrtc-rotation-degrees = 회전 (도)
about-webrtc-first-frame-timestamp = 첫 번째 프레임 수신 타임스탬프
about-webrtc-last-frame-timestamp = 마지막 프레임 수신 타임스탬프

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = 로컬 수신 SSRC
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = 원격 전송 SSRC

## These are displayed on the button that shows or hides the
## PeerConnection configuration disclosure

about-webrtc-pc-configuration-show-msg = 구성 표시
about-webrtc-pc-configuration-hide-msg = 구성 숨기기

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = 제공됨
# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = 제공되지 않음
# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = 사용자 WebRTC 설정
# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = 예상 대역폭
# The ID of the MediaStreamTrack
about-webrtc-track-identifier = 트랙 식별자
# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = 전송 대역폭 (바이트/초)
# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = 수신 대역폭 (바이트/초)
# Maximum number of bytes per second that will be padding zeros at the ends of packets
about-webrtc-max-padding-bytes-sec = 최대 패딩 (바이트/초)
# The amount of time inserted between packets to keep them spaced out
about-webrtc-pacer-delay-ms = 페이서 지연 ms
# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = RTT ms
# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = 비디오 프레임 통계 - MediaStreamTrack ID: { $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = 페이지 저장됨: { $path }
about-webrtc-debug-mode-off-state-msg = 추적로그 위치: { $path }
about-webrtc-debug-mode-on-state-msg = 디버그 모드 활성화, 추적로그 위치: { $path }
about-webrtc-aec-logging-off-state-msg = 캡처된 로그파일 위치: { $path }
# This path is used for saving the about:webrtc page so it can be attached to
# bug reports.
# Variables:
#  $path (String) - The path to which the file is saved.
about-webrtc-save-page-complete-msg = 페이지 저장됨: { $path }
about-webrtc-debug-mode-toggled-off-state-msg = 추적로그 위치: { $path }
about-webrtc-debug-mode-toggled-on-state-msg = 디버그 모드 활성화, 추적로그 위치: { $path }
# This is the total number of frames encoded or decoded over an RTP stream.
# Variables:
#  $frames (Number) - The number of frames encoded or decoded.
about-webrtc-frames =
    { $frames ->
        [one] { $frames } 프레임
       *[other] { $frames } 프레임
    }
# This is the number of audio channels encoded or decoded over an RTP stream.
# Variables:
#  $channels (Number) - The number of channels encoded or decoded.
about-webrtc-channels =
    { $channels ->
        [one] { $channels } 채널
       *[other] { $channels } 채널
    }
# This is the total number of packets received on the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets received.
about-webrtc-received-label =
    { $packets ->
       *[other] 받은 { $packets } 패킷
    }
# This is the total number of packets lost by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets lost.
about-webrtc-lost-label =
    { $packets ->
       *[other] 손실된 { $packets } 패킷
    }
# This is the total number of packets sent by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets sent.
about-webrtc-sent-label =
    { $packets ->
       *[other] 보낸 { $packets } 패킷
    }
# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = 지터 { $jitter }
# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = 끊기는 후보자(답변 후 도착)는 파란색으로 표기됨

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = 타임스탬프 { NUMBER($timestamp, useGrouping: "false") }에 로컬 SDP 설정
# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = 타임스탬프 { NUMBER($timestamp, useGrouping: "false") }에 원격 SDP 설정
# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = 타임스탬프 { NUMBER($timestamp, useGrouping: "false") } (+ { $relative-timestamp } ms)

## These are displayed on the button that shows or hides the SDP information disclosure

about-webrtc-show-msg-sdp = SDP 표시
about-webrtc-hide-msg-sdp = SDP 숨기기

## These are displayed on the button that shows or hides the Media Context information disclosure.
## The Media Context is the set of preferences and detected capabilities that informs
## the negotiated CODEC settings.

about-webrtc-media-context-show-msg = 미디어 컨텍스트 표시
about-webrtc-media-context-hide-msg = 미디어 컨텍스트 숨기기
about-webrtc-media-context-heading = 미디어 컨텍스트

##


##

