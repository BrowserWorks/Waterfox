# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = داخليات WebRTC
# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = احفظ about:webrtc باسم

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = سجلات إلغاء صدى الصوت
about-webrtc-aec-logging-off-state-label = ابدأ تسجيل إلغاء صدى الصوت
about-webrtc-aec-logging-on-state-label = أوقف تسجيل إلغاء صدى الصوت
about-webrtc-aec-logging-on-state-msg = تسجيل إلغاء صدى الصوت نشط (تحدّث مع المتّصل لعدة دقائق ثم أوقف الالتقاط)

##

# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = PeerConnection ID:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = ‏SDP المحلي
about-webrtc-local-sdp-heading-offer = ‏SDP المحلي (عرض)
about-webrtc-local-sdp-heading-answer = ‏SDP المحلي (رد)
about-webrtc-remote-sdp-heading = ‏SDP البعيد
about-webrtc-remote-sdp-heading-offer = ‏SDP البعيد (عرض)
about-webrtc-remote-sdp-heading-answer = ‏SDP البعيد (رد)

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = إحصاءات RTP

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = حالة ICE
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = إحصاءات ICE
about-webrtc-ice-restart-count-label = مرات إعادة تشغيل ICE:
about-webrtc-ice-rollback-count-label = مرات استرجاع حالة ICE:
about-webrtc-ice-pair-bytes-sent = البايتات المرسلة:
about-webrtc-ice-pair-bytes-received = البايتات المستقبَلة:
about-webrtc-ice-component-id = معرف المكون

##


## "Avg." is an abbreviation for Average. These are used as data labels.


##


## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = محلي
about-webrtc-type-remote = بعيد

##

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = مرشَّح
# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = محدد
about-webrtc-save-page-label = احفظ الصفحة
about-webrtc-debug-mode-msg-label = طور تمحيص الأخطاء
about-webrtc-debug-mode-off-state-label = ابدأ وضع التنقيح
about-webrtc-debug-mode-on-state-label = أوقف وضع التنقيح
about-webrtc-stats-heading = إحصاءات الجلسة
about-webrtc-stats-clear = امسح التأريخ
about-webrtc-log-heading = سجل الاتصال
about-webrtc-log-clear = امسح السجل
about-webrtc-log-show-msg = اعرض السجل
    .title = انقر لتوسيع هذا القسم
about-webrtc-log-hide-msg = أخفِ السجل
    .title = انقر لطي هذا القسم

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (أُغلِقَ) { $now }

##

about-webrtc-local-candidate = مرشح محلي
about-webrtc-remote-candidate = مرشح بعيد
about-webrtc-raw-candidates-heading = كل المرشحين الخام
about-webrtc-raw-local-candidate = مرشح خام محلي
about-webrtc-raw-remote-candidate = مرشح خام بعيد
about-webrtc-raw-cand-show-msg = اعرض المرشحين الخام
    .title = انقر لتوسيع هذا القسم
about-webrtc-raw-cand-hide-msg = أخفِ المرشحين الخام
    .title = انقر لطي هذا القسم
about-webrtc-priority = الأولويّة
about-webrtc-fold-show-msg = اعرض التفاصيل
    .title = انقر لتوسيع هذا القسم
about-webrtc-fold-hide-msg = أخفِ التفاصيل
    .title = انقر لطي هذا القسم
about-webrtc-decoder-label = فاكك الترميز
about-webrtc-encoder-label = المُرمِّز

## SSRCs are identifiers that represent endpoints in an RTP stream


##


## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = حُفظت الصفحة إلى: { $path }
about-webrtc-debug-mode-off-state-msg = يمكن إيجاد سجل التتبع في: { $path }
about-webrtc-debug-mode-on-state-msg = وضع التنقيح مفعّل، التتبع يُسجّل في: { $path }
about-webrtc-aec-logging-off-state-msg = ملف السجل المأخوذ موجود في: { $path }

##

# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = التقلقل { $jitter }
# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = سيظهر المرشحون المتقاطرون (الواصلين بعد الإجابة) باللون الأزرق

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol


##

