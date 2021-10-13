# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = WebRTC nội bộ

# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = lưu about:webrtc thành

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = Ghi nhật ký AEC
about-webrtc-aec-logging-off-state-label = Bắt đầu ghi nhật ký AEC
about-webrtc-aec-logging-on-state-label = Dừng ghi nhật ký AEC
about-webrtc-aec-logging-on-state-msg = Bản ghi AEC đang hoạt động (nói chuyện với người gọi trong vài phút và sau đó dừng chụp)

##

# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = PeerConnection ID:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = SDP nội bộ
about-webrtc-local-sdp-heading-offer = SDP nội bộ (Cung cấp)
about-webrtc-local-sdp-heading-answer = SDP nội bộ (Trả lời)
about-webrtc-remote-sdp-heading = SDP từ xa
about-webrtc-remote-sdp-heading-offer = SDP từ xa (Cung cấp)
about-webrtc-remote-sdp-heading-answer = SDP từ xa (Trả lời)
about-webrtc-sdp-history-heading = Lịch sử SDP
about-webrtc-sdp-parsing-errors-heading = Lỗi phân tích SDP

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = Thống kê RTP

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = Trạng thái ICE
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = Thống kê ICE
about-webrtc-ice-pair-bytes-sent = Byte đã gửi:
about-webrtc-ice-pair-bytes-received = Byte đã nhận:
about-webrtc-ice-component-id = ID thành phần

## "Avg." is an abbreviation for Average. These are used as data labels.


## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = Cục bộ
about-webrtc-type-remote = Từ xa

##

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = Đề cử

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = Chọn

about-webrtc-save-page-label = Lưu trang
about-webrtc-debug-mode-msg-label = Chế độ gỡ lỗi
about-webrtc-debug-mode-off-state-label = Bắt đầu chế độ gỡ lỗi
about-webrtc-debug-mode-on-state-label = Dừng chế độ gỡ lỗi
about-webrtc-stats-heading = Thống kê phiên
about-webrtc-stats-clear = Xóa lịch sử
about-webrtc-log-heading = Nhật ký kết nối
about-webrtc-log-clear = Xóa nhật ký
about-webrtc-log-show-msg = hiển thị nhật ký
    .title = nhấn chuột để mở rộng mục này
about-webrtc-log-hide-msg = ẩn nhật ký
    .title = nhấn chuột để thu gọn mục này

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (đã đóng) { $now }

##

about-webrtc-priority = Ưu tiên
about-webrtc-fold-show-msg = hiện chi tiết
    .title = nhấn chuột để mở rộng mục này
about-webrtc-fold-hide-msg = ẩn chi tiết
    .title = nhấn chuột để thu gọn mục này
about-webrtc-decoder-label = Bộ giải mã
about-webrtc-encoder-label = Bộ mã hóa
about-webrtc-show-tab-label = Hiển thị thẻ
about-webrtc-width-px = Chiều rộng (px)
about-webrtc-height-px = Chiều cao (px)
about-webrtc-time-elapsed = Thời gian đã trôi qua (giây)
about-webrtc-rotation-degrees = Xoay (độ)

## SSRCs are identifiers that represent endpoints in an RTP stream


##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = Cung cấp

# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = Không cung cấp

# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = Người dùng thiết lập tùy chọn WebRTC

# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = Băng thông ước tính

# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = Băng thông gửi (byte/giây)

# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = Băng thông nhận (byte/giây)

# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = RTT ms

# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = Thống kê khung hình video - ID MediaStreamTrack: { $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = đã lưu trang vào: { $path }
about-webrtc-debug-mode-off-state-msg = nhật ký theo dõi có thể được tìm thấy tại: { $path }
about-webrtc-debug-mode-on-state-msg = chế độ gỡ lỗi hoạt động, theo dõi nhật ký tại: { $path }
about-webrtc-aec-logging-off-state-msg = các tập tin nhật ký đã chụp có thể được tìm thấy trong: { $path }

##

# This is the total number of packets received on the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets received.
about-webrtc-received-label =
    { $packets ->
       *[other] Đã nhận { $packets } gói
    }

# This is the total number of packets lost by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets lost.
about-webrtc-lost-label =
    { $packets ->
       *[other] Đã mất { $packets } gói
    }

# This is the total number of packets sent by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets sent.
about-webrtc-sent-label =
    { $packets ->
       *[other] Đã gửi { $packets } gói
    }

# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = Độ rung { $jitter }

# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = Các ứng cử viên bị mắc kẹt (đến sau khi trả lời) được tô sáng bằng màu xanh lam

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = Đặt SDP nội bộ tại timestamp { NUMBER($timestamp, useGrouping: "false") }

# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = Đặt SDP từ xa tại timestamp { NUMBER($timestamp, useGrouping: "false") }

# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = Timestamp { NUMBER($timestamp, useGrouping: "false") } (+ { $relative-timestamp } ms)

##

