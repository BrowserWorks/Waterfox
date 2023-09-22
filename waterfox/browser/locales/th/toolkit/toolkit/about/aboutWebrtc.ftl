# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = WebRTC Internals
# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = บันทึก about:webrtc เป็น

## These labels are for a disclosure which contains the information for closed PeerConnection sections

about-webrtc-closed-peerconnection-disclosure-show-msg = แสดง PeerConnections ที่ปิด
about-webrtc-closed-peerconnection-disclosure-hide-msg = ซ่อน PeerConnections ที่ปิด

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = การบันทึก AEC
about-webrtc-aec-logging-off-state-label = เริ่มการบันทึก AEC
about-webrtc-aec-logging-on-state-label = หยุดการบันทึก AEC
about-webrtc-aec-logging-on-state-msg = การบันทึก AEC ทำงานอยู่ (พูดกับผู้โทรไม่กี่นาทีแล้วหยุดการจับ)
about-webrtc-aec-logging-toggled-on-state-msg = การบันทึก AEC ทำงานอยู่ (พูดกับผู้โทรไม่กี่นาทีแล้วหยุดการจับ)
about-webrtc-aec-logging-unavailable-sandbox = ตัวแปรสภาพแวดล้อม MOZ_DISABLE_CONTENT_SANDBOX=1 จำเป็นสำหรับการส่งออกปูม AEC ให้ตั้งค่าตัวแปรนี้ก็ต่อเมื่อคุณเข้าใจความเสี่ยงที่อาจเกิดขึ้นเท่านั้น
# Variables:
#  $path (String) - The path to which the aec log file is saved.
about-webrtc-aec-logging-toggled-off-state-msg = ไฟล์บันทึกที่จับสามารถพบได้ใน: { $path }

##

# The autorefresh checkbox causes a stats section to autorefresh its content when checked
about-webrtc-auto-refresh-label = การรีเฟรชอัตโนมัติ
# Determines the default state of the Auto Refresh check boxes
about-webrtc-auto-refresh-default-label = เรียกใหม่อัตโนมัติตามค่าเริ่มต้น
# A button which forces a refresh of displayed statistics
about-webrtc-force-refresh-button = เรียกใหม่
# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = PeerConnection ID:
# The number of DataChannels that a PeerConnection has opened
about-webrtc-data-channels-opened-label = ช่องข้อมูลที่เปิด:
# The number of once open DataChannels that a PeerConnection has closed
about-webrtc-data-channels-closed-label = ช่องข้อมูลที่ปิด:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = SDP ในเครื่อง
about-webrtc-local-sdp-heading-offer = SDP ในเครื่อง (ข้อเสนอ)
about-webrtc-local-sdp-heading-answer = SDP ในเครื่อง (คำตอบ)
about-webrtc-remote-sdp-heading = SDP ระยะไกล
about-webrtc-remote-sdp-heading-offer = SDP ระยะไกล (ข้อเสนอ)
about-webrtc-remote-sdp-heading-answer = SDP ระยะไกล (คำตอบ)
about-webrtc-sdp-history-heading = ประวัติ SDP
about-webrtc-sdp-parsing-errors-heading = ข้อผิดพลาดในการแยกวิเคราะห์ SDP

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = สถิติ RTP

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = สถานะ ICE
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = สถิติ ICE
about-webrtc-ice-restart-count-label = การเริ่มการทำงานใหม่ของ ICE:
about-webrtc-ice-rollback-count-label = การย้อนกลับของ ICE:
about-webrtc-ice-pair-bytes-sent = จำนวนไบต์ที่ส่ง:
about-webrtc-ice-pair-bytes-received = จำนวนไบต์ที่รับ:
about-webrtc-ice-component-id = ID ส่วนประกอบ

## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = ในเครื่อง
about-webrtc-type-remote = ระยะไกล

##

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = ถูกกำหนด
# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = เลือกแล้ว
about-webrtc-save-page-label = บันทึกหน้า
about-webrtc-debug-mode-msg-label = โหมดดีบั๊ก
about-webrtc-debug-mode-off-state-label = เริ่มโหมดดีบั๊ก
about-webrtc-debug-mode-on-state-label = หยุดโหมดดีบั๊ก
about-webrtc-enable-logging-label = เปิดใช้งานพรีเซ็ตปูม WebRTC
about-webrtc-stats-heading = สถิติวาระ
about-webrtc-stats-clear = ล้างประวัติ
about-webrtc-log-heading = รายการบันทึกการเชื่อมต่อ
about-webrtc-log-clear = ล้างรายการบันทึก
about-webrtc-log-show-msg = แสดงรายการบันทึก
    .title = คลิกเพื่อขยายส่วนนี้
about-webrtc-log-hide-msg = ซ่อนรายการบันทึก
    .title = คลิกเพื่อยุบส่วนนี้
about-webrtc-log-section-show-msg = แสดงรายการบันทึก
    .title = คลิกเพื่อขยายส่วนนี้
about-webrtc-log-section-hide-msg = ซ่อนรายการบันทึก
    .title = คลิกเพื่อยุบส่วนนี้
about-webrtc-copy-report-button = คัดลอกรายงาน
about-webrtc-copy-report-history-button = คัดลอกประวัติรายงาน

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (ปิดแล้ว) { $now }

## These are used to indicate what direction media is flowing.
## Variables:
##  $codecs - a list of media codecs

about-webrtc-short-send-receive-direction = ส่ง / รับ: { $codecs }
about-webrtc-short-send-direction = ส่ง: { $codecs }
about-webrtc-short-receive-direction = รับ: { $codecs }

##

about-webrtc-local-candidate = แคนดิเดตภายใน
about-webrtc-remote-candidate = แคนดิเดตระยะไกล
about-webrtc-raw-candidates-heading = แคนดิเดตดิบทั้งหมด
about-webrtc-raw-local-candidate = แคนดิเดตภายในดิบ
about-webrtc-raw-remote-candidate = แคนดิเดตระยะไกลดิบ
about-webrtc-raw-cand-show-msg = แสดงแคนดิเดตดิบ
    .title = คลิกเพื่อขยายส่วนนี้
about-webrtc-raw-cand-hide-msg = ซ่อนแคนดิเดตดิบ
    .title = คลิกเพื่อยุบส่วนนี้
about-webrtc-raw-cand-section-show-msg = แสดงแคนดิเดตดิบ
    .title = คลิกเพื่อขยายส่วนนี้
about-webrtc-raw-cand-section-hide-msg = ซ่อนแคนดิเดตดิบ
    .title = คลิกเพื่อยุบส่วนนี้
about-webrtc-priority = ความสำคัญ
about-webrtc-fold-show-msg = แสดงรายละเอียด
    .title = คลิกเพื่อขยายส่วนนี้
about-webrtc-fold-hide-msg = ซ่อนรายละเอียด
    .title = คลิกเพื่อยุบส่วนนี้
about-webrtc-fold-default-show-msg = แสดงรายละเอียด
    .title = คลิกเพื่อขยายส่วนนี้
about-webrtc-fold-default-hide-msg = ซ่อนรายละเอียด
    .title = คลิกเพื่อยุบส่วนนี้
about-webrtc-dropped-frames-label = เฟรมที่ถูกดรอป:
about-webrtc-discarded-packets-label = แพ็คเก็ตที่ถูกละทิ้ง:
about-webrtc-decoder-label = ตัวถอดรหัส
about-webrtc-encoder-label = ตัวเข้ารหัส
about-webrtc-show-tab-label = แสดงแท็บ
about-webrtc-current-framerate-label = อัตราเฟรม
about-webrtc-width-px = ความกว้าง (px)
about-webrtc-height-px = ความสูง (px)
about-webrtc-consecutive-frames = เฟรมต่อเนื่อง
about-webrtc-time-elapsed = เวลาที่ผ่านไป (วินาที)
about-webrtc-estimated-framerate = อัตราเฟรมโดยประมาณ
about-webrtc-rotation-degrees = การหมุน (องศา)
about-webrtc-first-frame-timestamp = การประทับเวลาการรับข้อมูลเฟรมแรก
about-webrtc-last-frame-timestamp = การประทับเวลาการรับข้อมูลเฟรมสุดท้าย

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = SSRC การรับข้อมูลภายใน
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = SSRC การส่งข้อมูลระยะไกล

## These are displayed on the button that shows or hides the
## PeerConnection configuration disclosure

about-webrtc-pc-configuration-show-msg = แสดงการกำหนดค่า
about-webrtc-pc-configuration-hide-msg = ซ่อนการกำหนดค่า

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = จัดเตรียมไว้
# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = ไม่ได้จัดเตรียมไว้
# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = การกำหนดลักษณะ WebRTC ที่ตั้งโดยผู้ใช้
# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = แบนด์วิดท์โดยประมาณ
# The ID of the MediaStreamTrack
about-webrtc-track-identifier = ตัวระบุแทร็ก
# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = แบนด์วิดท์ที่ส่ง (ไบต์/วินาที)
# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = แบนด์วิดท์ที่ได้รับ (ไบต์/วินาที)
# Maximum number of bytes per second that will be padding zeros at the ends of packets
about-webrtc-max-padding-bytes-sec = ช่องว่างสูงสุด (ไบต์/วินาที)
# The amount of time inserted between packets to keep them spaced out
about-webrtc-pacer-delay-ms = หน่วงเวลาระยะห่าง ms
# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = RTT ms
# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = สถิติเฟรมวิดีโอ - รหัส MediaStreamTrack: { $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = ได้บันทึกหน้าลงใน: { $path }
about-webrtc-debug-mode-off-state-msg = บันทึกร่องรอยสามารถพบได้ที่: { $path }
about-webrtc-debug-mode-on-state-msg = โหมดดีบั๊กทำงานอยู่ บันทึกการติดตามอยู่ที่: { $path }
about-webrtc-aec-logging-off-state-msg = ไฟล์บันทึกที่จับสามารถพบได้ใน: { $path }
# This path is used for saving the about:webrtc page so it can be attached to
# bug reports.
# Variables:
#  $path (String) - The path to which the file is saved.
about-webrtc-save-page-complete-msg = ได้บันทึกหน้าลงใน: { $path }
# This is the total number of frames encoded or decoded over an RTP stream.
# Variables:
#  $frames (Number) - The number of frames encoded or decoded.
about-webrtc-frames =
    { $frames ->
       *[other] { $frames } เฟรม
    }
# This is the number of audio channels encoded or decoded over an RTP stream.
# Variables:
#  $channels (Number) - The number of channels encoded or decoded.
about-webrtc-channels =
    { $channels ->
       *[other] { $channels } ช่องสัญญาณ
    }
# This is the total number of packets received on the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets received.
about-webrtc-received-label =
    { $packets ->
       *[other] ได้รับ { $packets } แพ็กเก็ต
    }
# This is the total number of packets lost by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets lost.
about-webrtc-lost-label =
    { $packets ->
       *[other] สูญเสีย { $packets } แพ็กเก็ต
    }
# This is the total number of packets sent by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets sent.
about-webrtc-sent-label =
    { $packets ->
       *[other] ส่งแล้ว { $packets } แพ็กเก็ต
    }
# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = จิทเทอร์ { $jitter }
# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = แคนดิเดตแบบ Trickled (ที่มาถึงหลังจากคำตอบ) จะถูกเน้นเป็น น้ำเงิน

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = ตั้งค่า SDP ในเครื่อง ที่การประทับเวลา { NUMBER($timestamp, useGrouping: "false") }
# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = ตั้งค่า SDP ระยะไกล ที่การประทับเวลา { NUMBER($timestamp, useGrouping: "false") }
# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = ประทับเวลา { NUMBER($timestamp, useGrouping: "false") } (+ { $relative-timestamp } ms)

## These are displayed on the button that shows or hides the SDP information disclosure

about-webrtc-show-msg-sdp = แสดง SDP
about-webrtc-hide-msg-sdp = ซ่อน SDP

##


## These are displayed on the button that shows or hides the Media Context information disclosure.
## The Media Context is the set of preferences and detected capabilities that informs
## the negotiated CODEC settings.

about-webrtc-media-context-show-msg = แสดงบริบทสื่อ
about-webrtc-media-context-hide-msg = ซ่อนบริบทสื่อ
about-webrtc-media-context-heading = บริบทสื่อ

##

