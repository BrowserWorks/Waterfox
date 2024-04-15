# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = WebRTC belső adatok
# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = az about:webrtc mentése másként

## These labels are for a disclosure which contains the information for closed PeerConnection sections

about-webrtc-closed-peerconnection-disclosure-show-msg = Lezárt PeerConnection kapcsolatok megjelenítése
about-webrtc-closed-peerconnection-disclosure-hide-msg = Lezárt PeerConnection kapcsolatok elrejtése

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = AEC naplózás
about-webrtc-aec-logging-off-state-label = AEC naplózás indítása
about-webrtc-aec-logging-on-state-label = AEC naplózás leállítása
about-webrtc-aec-logging-on-state-msg = Az AEC naplózás aktív (beszéljen a hívóval pár percig, majd állítsa le a felvételt)
about-webrtc-aec-logging-toggled-on-state-msg = Az AEC naplózás aktív (beszéljen a hívóval pár percig, majd állítsa le a felvételt)
about-webrtc-aec-logging-unavailable-sandbox = A MOZ_DISABLE_CONTENT_SANDBOX=1 környezeti változó szükséges az AEC naplók exportálásához. Csak akkor állítsa be ezt a változót, ha ismeri a lehetséges kockázatokat.
# Variables:
#  $path (String) - The path to which the aec log file is saved.
about-webrtc-aec-logging-toggled-off-state-msg = A rögzített naplófájlok megtalálhatók itt: { $path }

##

# The autorefresh checkbox causes a stats section to autorefresh its content when checked
about-webrtc-auto-refresh-label = Automatikus frissítés
# Determines the default state of the Auto Refresh check boxes
about-webrtc-auto-refresh-default-label = Automatikus frissítés alapértelmezés szerint
# A button which forces a refresh of displayed statistics
about-webrtc-force-refresh-button = Frissítés
# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = PeerConnection ID:
# The number of DataChannels that a PeerConnection has opened
about-webrtc-data-channels-opened-label = Nyitott adatcsatornák:
# The number of once open DataChannels that a PeerConnection has closed
about-webrtc-data-channels-closed-label = Lezárt adatcsatornák:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = Helyi SDP
about-webrtc-local-sdp-heading-offer = Helyi SDP (Ajánlat)
about-webrtc-local-sdp-heading-answer = Helyi SDP (Válasz)
about-webrtc-remote-sdp-heading = Távoli SDP
about-webrtc-remote-sdp-heading-offer = Távoli SDP (Ajánlat)
about-webrtc-remote-sdp-heading-answer = Távoli SDP (Válasz)
about-webrtc-sdp-history-heading = SDP-előzmények
about-webrtc-sdp-parsing-errors-heading = SDP értelmezési hibák

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = RTP statisztika

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = ICE állapot
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = ICE statisztika
about-webrtc-ice-restart-count-label = ICE újraindulások:
about-webrtc-ice-rollback-count-label = ICE visszagörgetések:
about-webrtc-ice-pair-bytes-sent = Elküldött bájtok:
about-webrtc-ice-pair-bytes-received = Kapott bájtok:
about-webrtc-ice-component-id = Komponensazonosító

## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = Helyi
about-webrtc-type-remote = Távoli

##

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = Jelölt
# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = Kijelölt
about-webrtc-save-page-label = Oldal mentése
about-webrtc-debug-mode-msg-label = Hibakeresési mód
about-webrtc-debug-mode-off-state-label = Hibakeresési mód indítása
about-webrtc-debug-mode-on-state-label = Hibakeresési mód leállítása
about-webrtc-enable-logging-label = WebRTC napló-előbeállítás engedélyezése
about-webrtc-stats-heading = Munkamenet-statisztika
about-webrtc-stats-clear = Előzmények törlése
about-webrtc-log-heading = Kapcsolatnapló
about-webrtc-log-clear = Napló törlése
about-webrtc-log-show-msg = napló megjelenítése
    .title = kattintson a szakasz kibontásához
about-webrtc-log-hide-msg = napló elrejtése
    .title = kattintson a szakasz összecsukásához
about-webrtc-log-section-show-msg = Napló megjelenítése
    .title = Kattintson a szakasz kibontásához
about-webrtc-log-section-hide-msg = Napló elrejtése
    .title = Kattintson a szakasz összecsukásához
about-webrtc-copy-report-button = Jelentés másolása
about-webrtc-copy-report-history-button = Jelentéselőzmények másolása

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (bezárva) { $now }

## These are used to indicate what direction media is flowing.
## Variables:
##  $codecs - a list of media codecs

about-webrtc-short-send-receive-direction = Küldés / fogadás: { $codecs }
about-webrtc-short-send-direction = Küldés: { $codecs }
about-webrtc-short-receive-direction = Fogadás: { $codecs }

##

about-webrtc-local-candidate = Helyi jelölt
about-webrtc-remote-candidate = Távoli jelölt
about-webrtc-raw-candidates-heading = Minden nyers jelölt
about-webrtc-raw-local-candidate = Nyers helyi jelölt
about-webrtc-raw-remote-candidate = Nyers távoli jelölt
about-webrtc-raw-cand-show-msg = nyers jelöltek megjelenítése
    .title = kattintson a szakasz kibontásához
about-webrtc-raw-cand-hide-msg = nyers jelöltek elrejtése
    .title = kattintson a szakasz összecsukásához
about-webrtc-raw-cand-section-show-msg = Nyers jelöltek megjelenítése
    .title = Kattintson a szakasz kibontásához
about-webrtc-raw-cand-section-hide-msg = Nyers jelöltek elrejtése
    .title = Kattintson a szakasz összecsukásához
about-webrtc-priority = Prioritás
about-webrtc-fold-show-msg = részletek megjelenítése
    .title = kattintson a szakasz kibontásához
about-webrtc-fold-hide-msg = részletek elrejtése
    .title = kattintson a szakasz összecsukásához
about-webrtc-fold-default-show-msg = Részletek megjelenítése
    .title = Kattintson a szakasz kibontásához
about-webrtc-fold-default-hide-msg = Részletek elrejtése
    .title = Kattintson a szakasz összecsukásához
about-webrtc-dropped-frames-label = Eldobott képkockák:
about-webrtc-discarded-packets-label = Eldobott csomagok:
about-webrtc-decoder-label = Dekódoló
about-webrtc-encoder-label = Kódoló
about-webrtc-show-tab-label = Lap megjelenítése
about-webrtc-current-framerate-label = Képkockasebesség
about-webrtc-width-px = Szélesség (px)
about-webrtc-height-px = Magasság (px)
about-webrtc-consecutive-frames = Egymást követő keretek
about-webrtc-time-elapsed = Eltelt idő (s)
about-webrtc-estimated-framerate = Becsült képkockasebesség
about-webrtc-rotation-degrees = Forgatás (fok)
about-webrtc-first-frame-timestamp = Első képkocka fogadási időbélyege
about-webrtc-last-frame-timestamp = Utolsó képkocka fogadási időbélyege

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = Helyi fogadó SSRC
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = Távoli küldő SSRC

## These are displayed on the button that shows or hides the
## PeerConnection configuration disclosure

about-webrtc-pc-configuration-show-msg = Konfiguráció megjelenítése
about-webrtc-pc-configuration-hide-msg = Konfiguráció elrejtése

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = Biztosított
# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = Nem biztosított
# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = Felhasználó által megadott WebRTC-beállítások
# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = Becsült sávszélesség
# The ID of the MediaStreamTrack
about-webrtc-track-identifier = Sávazonosító
# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = Küldési sávszélesség (bájt/mp)
# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = Fogadási sávszélesség (bájt/mp)
# Maximum number of bytes per second that will be padding zeros at the ends of packets
about-webrtc-max-padding-bytes-sec = Maximális kitöltés (bájt/mp)
# The amount of time inserted between packets to keep them spaced out
about-webrtc-pacer-delay-ms = Ütemező késleltetése (ms)
# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = RTT (ms)
# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = Videókeret statisztikák – MediaStreamTrack azonosító: { $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = oldal mentve ide: { $path }
about-webrtc-debug-mode-off-state-msg = nyomkövetési napló helye: { $path }
about-webrtc-debug-mode-on-state-msg = hibakeresési mód aktív, nyomkövetési napló helye: { $path }
about-webrtc-aec-logging-off-state-msg = a rögzített naplófájlok megtalálhatók itt: { $path }
# This path is used for saving the about:webrtc page so it can be attached to
# bug reports.
# Variables:
#  $path (String) - The path to which the file is saved.
about-webrtc-save-page-complete-msg = Oldal mentve ide: { $path }
about-webrtc-debug-mode-toggled-off-state-msg = Nyomkövetési napló helye: { $path }
about-webrtc-debug-mode-toggled-on-state-msg = Hibakeresési mód aktív, nyomkövetési napló helye: { $path }
# This is the total number of frames encoded or decoded over an RTP stream.
# Variables:
#  $frames (Number) - The number of frames encoded or decoded.
about-webrtc-frames =
    { $frames ->
        [one] { $frames } képkocka
       *[other] { $frames } képkocka
    }
# This is the number of audio channels encoded or decoded over an RTP stream.
# Variables:
#  $channels (Number) - The number of channels encoded or decoded.
about-webrtc-channels =
    { $channels ->
        [one] { $channels } csatorna
       *[other] { $channels } csatorna
    }
# This is the total number of packets received on the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets received.
about-webrtc-received-label =
    { $packets ->
        [one] { $packets } csomag fogadva
       *[other] { $packets } csomag fogadva
    }
# This is the total number of packets lost by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets lost.
about-webrtc-lost-label =
    { $packets ->
        [one] { $packets } csomag elveszett
       *[other] { $packets } csomag elveszett
    }
# This is the total number of packets sent by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets sent.
about-webrtc-sent-label =
    { $packets ->
        [one] { $packets } csomag elküldve
       *[other] { $packets } csomag elküldve
    }
# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = Csúszás { $jitter }
# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = A lecsorgó (válasz után érkező) jelöltek kék színnel vannak kiemelve

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = A Helyi SDP beállítva a következő időbélyegkor: { NUMBER($timestamp, useGrouping: "false") }
# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = A Távoli SDP beállítva a következő időbélyegkor: { NUMBER($timestamp, useGrouping: "false") }
# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = Időbélyeg: { NUMBER($timestamp, useGrouping: "false") } (+ { $relative-timestamp } ms)

## These are displayed on the button that shows or hides the SDP information disclosure

about-webrtc-show-msg-sdp = SDP megjelenítése
about-webrtc-hide-msg-sdp = SDP elrejtése

## These are displayed on the button that shows or hides the Media Context information disclosure.
## The Media Context is the set of preferences and detected capabilities that informs
## the negotiated CODEC settings.

about-webrtc-media-context-show-msg = Médiakörnyezet megjelenítése
about-webrtc-media-context-hide-msg = Médiakörnyezet elrejtése
about-webrtc-media-context-heading = Médiakörnyezet

##


##

