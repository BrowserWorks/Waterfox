# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = WebRTC 內部資訊
# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = 將 about:webrtc 儲存至

## These labels are for a disclosure which contains the information for closed PeerConnection sections

about-webrtc-closed-peerconnection-disclosure-show-msg = 顯示關閉的 PeerConnections
about-webrtc-closed-peerconnection-disclosure-hide-msg = 隱藏關閉的 PeerConnections

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = AEC 記錄
about-webrtc-aec-logging-off-state-label = 開始 AEC 記錄
about-webrtc-aec-logging-on-state-label = 停止 AEC 記錄
about-webrtc-aec-logging-on-state-msg = AEC 紀錄中（請與來電者交談幾分鐘後再停止捕捉）
about-webrtc-aec-logging-toggled-on-state-msg = AEC 紀錄中（請與來電者交談幾分鐘後再停止捕捉）
about-webrtc-aec-logging-unavailable-sandbox = 需要設定環境變數 MOZ_DISABLE_CONTENT_SANDBOX=1 才可以匯出 AEC 紀錄。請務必先理解可能造成的風險，再設定此環境變數。
# Variables:
#  $path (String) - The path to which the aec log file is saved.
about-webrtc-aec-logging-toggled-off-state-msg = 捕捉到的記錄檔位於: { $path }

##

# The autorefresh checkbox causes a stats section to autorefresh its content when checked
about-webrtc-auto-refresh-label = 自動重新整理
# Determines the default state of the Auto Refresh check boxes
about-webrtc-auto-refresh-default-label = 預設自動重新整理
# A button which forces a refresh of displayed statistics
about-webrtc-force-refresh-button = 重新整理
# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = PeerConnection ID:
# The number of DataChannels that a PeerConnection has opened
about-webrtc-data-channels-opened-label = 資料頻道開啟數量：
# The number of once open DataChannels that a PeerConnection has closed
about-webrtc-data-channels-closed-label = 資料頻道關閉數量：

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = 本地 SDP
about-webrtc-local-sdp-heading-offer = 本地 SDP (提供)
about-webrtc-local-sdp-heading-answer = 本地 SDP (接聽)
about-webrtc-remote-sdp-heading = 遠端 SDP
about-webrtc-remote-sdp-heading-offer = 遠端 SDP (提供)
about-webrtc-remote-sdp-heading-answer = 遠端 SDP (接聽)
about-webrtc-sdp-history-heading = SDP 歷史
about-webrtc-sdp-parsing-errors-heading = SDP 剖析錯誤

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = RTP 統計

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = ICE 狀態
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = ICE 統計
about-webrtc-ice-restart-count-label = ICE 重新啟動:
about-webrtc-ice-rollback-count-label = ICE rollback:
about-webrtc-ice-pair-bytes-sent = 位元組已送出:
about-webrtc-ice-pair-bytes-received = 位元組已接收:
about-webrtc-ice-component-id = 元件 ID

## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = 本地
about-webrtc-type-remote = 遠端

##

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = 已指定
# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = 已選取
about-webrtc-save-page-label = 儲存本頁
about-webrtc-debug-mode-msg-label = 除錯模式
about-webrtc-debug-mode-off-state-label = 開始除錯模式
about-webrtc-debug-mode-on-state-label = 停止除錯模式
about-webrtc-enable-logging-label = 開啟 WebRTC 保留紀錄
about-webrtc-stats-heading = 使用階段統計
about-webrtc-stats-clear = 清除紀錄
about-webrtc-log-heading = 連線記錄
about-webrtc-log-clear = 清除紀錄
about-webrtc-log-show-msg = 顯示紀錄
    .title = 點擊展開此段落
about-webrtc-log-hide-msg = 隱藏紀錄
    .title = 點擊摺疊此段落
about-webrtc-log-section-show-msg = 顯示紀錄
    .title = 點擊展開此段落
about-webrtc-log-section-hide-msg = 隱藏紀錄
    .title = 點擊摺疊此段落
about-webrtc-copy-report-button = 複製報告
about-webrtc-copy-report-history-button = 複製報告紀錄

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (已關閉) { $now }

## These are used to indicate what direction media is flowing.
## Variables:
##  $codecs - a list of media codecs

about-webrtc-short-send-receive-direction = 傳送/接收：{ $codecs }
about-webrtc-short-send-direction = 傳送：{ $codecs }
about-webrtc-short-receive-direction = 接收：{ $codecs }

##

about-webrtc-local-candidate = 本地候選
about-webrtc-remote-candidate = 遠端候選
about-webrtc-raw-candidates-heading = 所有原始候選
about-webrtc-raw-local-candidate = 原始本地候選
about-webrtc-raw-remote-candidate = 原始遠端候選
about-webrtc-raw-cand-show-msg = 顯示原始候選
    .title = 點擊展開此段落
about-webrtc-raw-cand-hide-msg = 隱藏原始候選
    .title = 點擊摺疊此段落
about-webrtc-raw-cand-section-show-msg = 顯示原始候選
    .title = 點擊展開此段落
about-webrtc-raw-cand-section-hide-msg = 隱藏原始候選
    .title = 點擊摺疊此段落
about-webrtc-priority = 重要性
about-webrtc-fold-show-msg = 顯示詳細資訊
    .title = 點擊展開此段落
about-webrtc-fold-hide-msg = 隱藏詳細資訊
    .title = 點擊摺疊此段落
about-webrtc-fold-default-show-msg = 顯示詳細資訊
    .title = 點擊展開此段落
about-webrtc-fold-default-hide-msg = 隱藏詳細資訊
    .title = 點擊摺疊此段落
about-webrtc-dropped-frames-label = 捨棄的畫框數:
about-webrtc-discarded-packets-label = 捨棄的封包數:
about-webrtc-decoder-label = 解碼器
about-webrtc-encoder-label = 編碼器
about-webrtc-show-tab-label = 顯示分頁
about-webrtc-current-framerate-label = 畫框率
about-webrtc-width-px = 寬度（像素）
about-webrtc-height-px = 高度（像素）
about-webrtc-consecutive-frames = 連續畫框
about-webrtc-time-elapsed = 經過時間（秒）
about-webrtc-estimated-framerate = 估計畫框率
about-webrtc-rotation-degrees = 旋轉（度）
about-webrtc-first-frame-timestamp = 接收到第一個畫框的時間戳記
about-webrtc-last-frame-timestamp = 接收到最後一個畫框的時間戳記

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = 本地接收 SSRC
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = 遠端發送 SSRC

## These are displayed on the button that shows or hides the
## PeerConnection configuration disclosure

about-webrtc-pc-configuration-show-msg = 顯示設定
about-webrtc-pc-configuration-hide-msg = 隱藏設定

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = 提供
# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = 不提供
# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = 使用者設定的 WebRTC 偏好設定
# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = 估計頻寬
# The ID of the MediaStreamTrack
about-webrtc-track-identifier = 軌道識別符
# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = 傳送頻寬（位元組／秒）
# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = 接收頻寬（位元組／秒）
# Maximum number of bytes per second that will be padding zeros at the ends of packets
about-webrtc-max-padding-bytes-sec = 封包填充資料（位元組／秒）
# The amount of time inserted between packets to keep them spaced out
about-webrtc-pacer-delay-ms = 間隔時間（ms）
# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = RTT（ms）
# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = 畫框統計資訊 - MediaStreamTrack ID: { $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = 已將頁面儲存至: { $path }
about-webrtc-debug-mode-off-state-msg = 追蹤紀錄位於: { $path }
about-webrtc-debug-mode-on-state-msg = 已進入除錯模式，追蹤紀錄位於: { $path }
about-webrtc-aec-logging-off-state-msg = 捕捉到的記錄檔位於: { $path }
# This path is used for saving the about:webrtc page so it can be attached to
# bug reports.
# Variables:
#  $path (String) - The path to which the file is saved.
about-webrtc-save-page-complete-msg = 已將頁面儲存至: { $path }
about-webrtc-debug-mode-toggled-off-state-msg = 追蹤紀錄位於: { $path }
about-webrtc-debug-mode-toggled-on-state-msg = 已進入除錯模式，追蹤紀錄位於: { $path }
# This is the total number of frames encoded or decoded over an RTP stream.
# Variables:
#  $frames (Number) - The number of frames encoded or decoded.
about-webrtc-frames =
    { $frames ->
       *[other] { $frames } 畫框
    }
# This is the number of audio channels encoded or decoded over an RTP stream.
# Variables:
#  $channels (Number) - The number of channels encoded or decoded.
about-webrtc-channels =
    { $channels ->
       *[other] { $channels } 頻道
    }
# This is the total number of packets received on the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets received.
about-webrtc-received-label =
    { $packets ->
       *[other] 已收到 { $packets } 個封包
    }
# This is the total number of packets lost by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets lost.
about-webrtc-lost-label =
    { $packets ->
       *[other] 已捨棄 { $packets } 個封包
    }
# This is the total number of packets sent by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets sent.
about-webrtc-sent-label =
    { $packets ->
       *[other] 已送出 { $packets } 個封包
    }
# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = 抖動 { $jitter }
# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = 使用 藍色 強調太晚抵達的候選（接聽後才抵達）

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = 已將本地 SDP 時間戳記設為 { NUMBER($timestamp, useGrouping: "false") }
# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = 已將遠端 SDP 時間戳記設為 { NUMBER($timestamp, useGrouping: "false") }
# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = 時間戳記 { NUMBER($timestamp, useGrouping: "false") }（+ { $relative-timestamp } ms）

## These are displayed on the button that shows or hides the SDP information disclosure

about-webrtc-show-msg-sdp = 顯示 SDP
about-webrtc-hide-msg-sdp = 隱藏 SDP

## These are displayed on the button that shows or hides the Media Context information disclosure.
## The Media Context is the set of preferences and detected capabilities that informs
## the negotiated CODEC settings.

about-webrtc-media-context-show-msg = 顯示媒體內容環境
about-webrtc-media-context-hide-msg = 隱藏媒體內容環境
about-webrtc-media-context-heading = 媒體內容環境

##


##

