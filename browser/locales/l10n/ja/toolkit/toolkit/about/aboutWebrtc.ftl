# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = WebRTC 内部情報
# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = about:webrtc を名前を付けて保存

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = AEC ログ記録
about-webrtc-aec-logging-off-state-label = AEC ログ記録を開始
about-webrtc-aec-logging-on-state-label = AEC ログ記録を停止
about-webrtc-aec-logging-on-state-msg = AEC ログ記録が有効です (数分間、通話相手と会話してから停止してください)

##

# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = PeerConnection ID:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = ローカル SDP
about-webrtc-local-sdp-heading-offer = ローカル SDP (オファー)
about-webrtc-local-sdp-heading-answer = ローカル SDP (アンサー)
about-webrtc-remote-sdp-heading = リモート SDP
about-webrtc-remote-sdp-heading-offer = リモート SDP (オファー)
about-webrtc-remote-sdp-heading-answer = リモート SDP (アンサー)
about-webrtc-sdp-history-heading = SDP 履歴
about-webrtc-sdp-parsing-errors-heading = SDP パースエラー

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = RTP 統計

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = ICE 統計
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = ICE 統計
about-webrtc-ice-restart-count-label = ICE 再起動:
about-webrtc-ice-rollback-count-label = ICE ロールバック:
about-webrtc-ice-pair-bytes-sent = 送信バイト数:
about-webrtc-ice-pair-bytes-received = 受信バイト数:
about-webrtc-ice-component-id = コンポーネント ID

## "Avg." is an abbreviation for Average. These are used as data labels.

about-webrtc-avg-bitrate-label = 平均ビットレート:
about-webrtc-avg-framerate-label = 平均フレームレート:

## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = ローカル
about-webrtc-type-remote = リモート

##

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = ノミネート
# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = 選択
about-webrtc-save-page-label = ページを保存
about-webrtc-debug-mode-msg-label = デバッグモード
about-webrtc-debug-mode-off-state-label = デバッグモードを開始
about-webrtc-debug-mode-on-state-label = デバッグモードを停止
about-webrtc-stats-heading = セッション統計
about-webrtc-stats-clear = 履歴を消去
about-webrtc-log-heading = 接続ログ
about-webrtc-log-clear = ログを消去
about-webrtc-log-show-msg = ログを表示
    .title = クリックしてセクションを展開します
about-webrtc-log-hide-msg = ログを隠す
    .title = クリックしてセクションを折りたたみます

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (切断) { $now }

##

about-webrtc-local-candidate = ローカル通信情報
about-webrtc-remote-candidate = リモート通信情報
about-webrtc-raw-candidates-heading = すべての生通信情報
about-webrtc-raw-local-candidate = ローカルの生通信情報
about-webrtc-raw-remote-candidate = リモートの生通信情報
about-webrtc-raw-cand-show-msg = 生通信情報を表示
    .title = クリックしてセクションを展開します
about-webrtc-raw-cand-hide-msg = 生通信情報を隠す
    .title = クリックしてセクションを折りたたみます
about-webrtc-priority = 優先度
about-webrtc-fold-show-msg = 詳細を表示
    .title = クリックしてセクションを展開します
about-webrtc-fold-hide-msg = 詳細を隠す
    .title = クリックしてセクションを折りたたみます
about-webrtc-dropped-frames-label = ドロップフレーム:
about-webrtc-discarded-packets-label = 破棄パケット:
about-webrtc-decoder-label = デコーダー
about-webrtc-encoder-label = エンコーダー
about-webrtc-show-tab-label = タブを表示
about-webrtc-width-px = 幅 (px)
about-webrtc-height-px = 高さ (px)
about-webrtc-consecutive-frames = 連続フレーム数
about-webrtc-time-elapsed = 経過時間 (秒)
about-webrtc-estimated-framerate = 予測フレームレート
about-webrtc-rotation-degrees = 回転 (度)
about-webrtc-first-frame-timestamp = 先頭フレームの受信時刻
about-webrtc-last-frame-timestamp = 末尾フレームの受信時刻

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = ローカル受信 SSRC
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = リモート送信 SSRC

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = 提供済み
# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = 未提供
# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = ユーザー設定の WebRTC オプション
# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = 推定帯域幅
# The ID of the MediaStreamTrack
about-webrtc-track-identifier = トラック識別子
# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = 送信帯域幅 (バイト/秒)
# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = 受信帯域幅 (バイト/秒)
# Maximum number of bytes per second that will be padding zeros at the ends of packets
about-webrtc-max-padding-bytes-sec = ゼロ埋め最大 (バイト/秒)
# The amount of time inserted between packets to keep them spaced out
about-webrtc-pacer-delay-ms = 遅延挿入 (ms)
# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = RTT (ms)
# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = 動画フレーム統計 - MediaStreamTrack ID: { $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = ページを保存しました: { $path }
about-webrtc-debug-mode-off-state-msg = トレースログの保存場所: { $path }
about-webrtc-debug-mode-on-state-msg = デバッグモードが有効です。トレースログの保存場所: { $path }
about-webrtc-aec-logging-off-state-msg = 記録したログファイルの保存場所: { $path }

##

# This is the total number of packets received on the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets received.
about-webrtc-received-label =
  { $packets ->
      [one] { $packets } パケット受信
     *[other] { $packets } パケット受信
  }
# This is the total number of packets lost by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets lost.
about-webrtc-lost-label =
  { $packets ->
      [one] { $packets } パケット損失
     *[other] { $packets } パケット損失
  }
# This is the total number of packets sent by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets sent.
about-webrtc-sent-label =
  { $packets ->
      [one] { $packets } パケット送信
     *[other] { $packets } パケット送信
  }
# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = ジッター { $jitter }
# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = Trickled 通信情報 (アンサー後の着信) は青色で強調されます

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = 時刻 { NUMBER($timestamp, useGrouping: "false") } に ローカル SDP を設定
# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = 時刻 { NUMBER($timestamp, useGrouping: "false") } に リモート SDP を設定
# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = タイムスタンプ { NUMBER($timestamp, useGrouping: "false") } (+ { $relative-timestamp } ms)

##
