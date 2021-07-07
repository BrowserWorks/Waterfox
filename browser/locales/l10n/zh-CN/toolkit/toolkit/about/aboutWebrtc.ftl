# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = WebRTC 内部

# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = 另存 about:webrtc 为

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = AEC 正在记录
about-webrtc-aec-logging-off-state-label = 开始 AEC 日志记录
about-webrtc-aec-logging-on-state-label = 停止 AEC 日志记录
about-webrtc-aec-logging-on-state-msg = AEC 日志正在记录（与呼叫者说几分钟话，然后停止捕捉）

##

# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = PeerConnection ID:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = 本地 SDP
about-webrtc-local-sdp-heading-offer = 本地 SDP (提供)
about-webrtc-local-sdp-heading-answer = 本地 SDP (回答)
about-webrtc-remote-sdp-heading = 远程 SDP
about-webrtc-remote-sdp-heading-offer = 远程 SDP (提供)
about-webrtc-remote-sdp-heading-answer = 远程 SDP (回答)
about-webrtc-sdp-history-heading = SDP 历史
about-webrtc-sdp-parsing-errors-heading = SDP 解析错误

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = RTP 状态

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = ICE 统计
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = ICE 状态
about-webrtc-ice-restart-count-label = ICE 重启:
about-webrtc-ice-rollback-count-label = ICE 回滚:
about-webrtc-ice-pair-bytes-sent = 已发送字节:
about-webrtc-ice-pair-bytes-received = 已接收字节:
about-webrtc-ice-component-id = 组件 ID

## "Avg." is an abbreviation for Average. These are used as data labels.

about-webrtc-avg-bitrate-label = 平均比特率：
about-webrtc-avg-framerate-label = 平均帧率：

## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = 本地
about-webrtc-type-remote = 远程

##


# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = 已提名

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = 已选定

about-webrtc-save-page-label = 保存页面
about-webrtc-debug-mode-msg-label = 调试模式
about-webrtc-debug-mode-off-state-label = 开始调试模式
about-webrtc-debug-mode-on-state-label = 停止调试模式
about-webrtc-stats-heading = 会话统计
about-webrtc-stats-clear = 清除历史记录
about-webrtc-log-heading = 连接日志
about-webrtc-log-clear = 清除日志
about-webrtc-log-show-msg = 显示日志
    .title = 点击展开此段
about-webrtc-log-hide-msg = 隐藏日志
    .title = 点击折叠此段

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (已关闭) { $now }

##


about-webrtc-local-candidate = 本地候选
about-webrtc-remote-candidate = 远程候选
about-webrtc-raw-candidates-heading = 所有原始候选者
about-webrtc-raw-local-candidate = 原始本地候选者
about-webrtc-raw-remote-candidate = 原始远程候选者
about-webrtc-raw-cand-show-msg = 显示原始候选者
    .title = 点击展开此段
about-webrtc-raw-cand-hide-msg = 隐藏原始候选者
    .title = 点击折叠此段
about-webrtc-priority = 优先级
about-webrtc-fold-show-msg = 显示详细信息
    .title = 点击展开此段
about-webrtc-fold-hide-msg = 隐藏详细信息
    .title = 点击折叠此段
about-webrtc-dropped-frames-label = 丢帧数：
about-webrtc-discarded-packets-label = 丢包数：
about-webrtc-decoder-label = 解码器
about-webrtc-encoder-label = 编码器
about-webrtc-show-tab-label = 显示标签页
about-webrtc-width-px = 宽度（像素）
about-webrtc-height-px = 高度（像素）
about-webrtc-consecutive-frames = 连续帧
about-webrtc-time-elapsed = 已用时间（秒）
about-webrtc-estimated-framerate = 估计帧率
about-webrtc-rotation-degrees = 旋转（度）
about-webrtc-first-frame-timestamp = 第一帧接收时间戳
about-webrtc-last-frame-timestamp = 最后一帧接收时间戳

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = 本地接收 SSRC
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = 远程发送 SSRC

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = 提供

# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = 不提供

# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = WebRTC 用户设置项

# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = 估计带宽

# The ID of the MediaStreamTrack
about-webrtc-track-identifier = 轨道标识符

# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = 发送带宽（字节 / 秒）

# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = 接收带宽（字节 / 秒）

# Maximum number of bytes per second that will be padding zeros at the ends of packets
about-webrtc-max-padding-bytes-sec = 最大填补数据（字节 / 秒）

# The amount of time inserted between packets to keep them spaced out
about-webrtc-pacer-delay-ms = 间隔时间（ms）

# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = 往返时延（RTT | ms）

# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = 视频帧统计信息 - MediaStreamTrack ID：{ $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = 页面已保存到: { $path }
about-webrtc-debug-mode-off-state-msg = 跟踪日志可以在这里找到: { $path }
about-webrtc-debug-mode-on-state-msg = 调试模式已激活，跟踪日志在: { $path }
about-webrtc-aec-logging-off-state-msg = 捕捉到的日志文件在这里: { $path }

##

# This is the total number of packets received on the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets received.
about-webrtc-received-label =
    { $packets ->
       *[other] 已收到 { $packets } 个包
    }

# This is the total number of packets lost by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets lost.
about-webrtc-lost-label =
    { $packets ->
       *[other] 已丢弃 { $packets } 个包
    }

# This is the total number of packets sent by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets sent.
about-webrtc-sent-label =
    { $packets ->
       *[other] 已发送 { $packets } 个包
    }

# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = 抖动 { $jitter }

# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = Trickled 候选者（回答后到达）已用 蓝色 高亮

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = 已将 本地 SDP 时间戳设为 { NUMBER($timestamp, useGrouping: "false") }

# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = 已将 远程 SDP 时间戳设为 { NUMBER($timestamp, useGrouping: "false") }

# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = 时间戳 { NUMBER($timestamp, useGrouping: "false") }（+ { $relative-timestamp } 毫秒）

##

##

##

