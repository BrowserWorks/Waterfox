# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = WebRTC-internt

# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = spara about:webrtc som

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = AEC-loggning
about-webrtc-aec-logging-off-state-label = Starta AEC-loggning
about-webrtc-aec-logging-on-state-label = Stoppa AEC-loggning
about-webrtc-aec-logging-on-state-msg = AEC-loggning aktiv (tala med den som ringer i några minuter och stoppa sedan fångst)

##

# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = PeerConnection-ID:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = Lokal SDP
about-webrtc-local-sdp-heading-offer = Lokal SDP (Offer)
about-webrtc-local-sdp-heading-answer = Lokal SDP (Answer)
about-webrtc-remote-sdp-heading = Fjärr SDP
about-webrtc-remote-sdp-heading-offer = Fjärr SDP (Offer)
about-webrtc-remote-sdp-heading-answer = Fjärr SDP (Answer)
about-webrtc-sdp-history-heading = SDP-historik
about-webrtc-sdp-parsing-errors-heading = SDP-parsningsfel

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = RTP statistik

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = ICE status
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = ICE statistik
about-webrtc-ice-restart-count-label = ICE omstarter:
about-webrtc-ice-rollback-count-label = ICE återställningar:
about-webrtc-ice-pair-bytes-sent = Skickade byte:
about-webrtc-ice-pair-bytes-received = Mottagna byte:
about-webrtc-ice-component-id = Komponent-ID

## "Avg." is an abbreviation for Average. These are used as data labels.

about-webrtc-avg-bitrate-label = Genomsnittlig bithastighet:
about-webrtc-avg-framerate-label = Genomsnittlig bildfrekvens:

## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = Lokal
about-webrtc-type-remote = Fjärr

##


# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = Nominerad

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = Markerad

about-webrtc-save-page-label = Spara sida
about-webrtc-debug-mode-msg-label = Felsökningsläge
about-webrtc-debug-mode-off-state-label = Starta felsökningsläge
about-webrtc-debug-mode-on-state-label = Stoppa felsökningsläge
about-webrtc-stats-heading = Sessionsstatistik
about-webrtc-stats-clear = Rensa historik
about-webrtc-log-heading = Anslutningslogg
about-webrtc-log-clear = Rensa logg
about-webrtc-log-show-msg = visa logg
    .title = klicka för att expandera denna sektion
about-webrtc-log-hide-msg = dölj logg
    .title = klicka för att minimera denna sektion

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (stängd) { $now }

##


about-webrtc-local-candidate = Lokal kandidat
about-webrtc-remote-candidate = Fjärrkandidat
about-webrtc-raw-candidates-heading = Alla råa kandidater
about-webrtc-raw-local-candidate = Rå lokal kandidat
about-webrtc-raw-remote-candidate = Rå fjärrkandidat
about-webrtc-raw-cand-show-msg = visa råa kandidater
    .title = klicka för att expandera denna sektion
about-webrtc-raw-cand-hide-msg = dölj råa kandidater
    .title = klicka för att minimera denna sektion
about-webrtc-priority = Prioritet
about-webrtc-fold-show-msg = visa detaljer
    .title = klicka för att expandera denna sektion
about-webrtc-fold-hide-msg = dölj detaljer
    .title = klicka för att minimera denna sektion
about-webrtc-dropped-frames-label = Utelämnade bildrutor:
about-webrtc-discarded-packets-label = Ignorerade paket:
about-webrtc-decoder-label = Avkodare
about-webrtc-encoder-label = Kodare
about-webrtc-show-tab-label = Visa flik
about-webrtc-width-px = Bredd (px)
about-webrtc-height-px = Höjd (px)
about-webrtc-consecutive-frames = Efterföljande ramar
about-webrtc-time-elapsed = Förfluten tid (s)
about-webrtc-estimated-framerate = Beräknad bildfrekvens
about-webrtc-rotation-degrees = Rotation (grader)
about-webrtc-first-frame-timestamp = Tidsstämpel för första bildmottagning
about-webrtc-last-frame-timestamp = Tidsstämpel för sista bildmottagning

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = Lokal mottagande SSRC
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = Fjärrsändning SSRC

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = Har angetts

# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = Har inte angetts

# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = Användarinställda WebRTC-inställningar

# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = Uppskattad bandbredd

# The ID of the MediaStreamTrack
about-webrtc-track-identifier = Spåridentifierare

# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = Bandbredd skicka (byte/sek)

# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = Bandbredd motta (byte/sek)

# Maximum number of bytes per second that will be padding zeros at the ends of packets
about-webrtc-max-padding-bytes-sec = Maximal utfyllnad (byte/sek)

# The amount of time inserted between packets to keep them spaced out
about-webrtc-pacer-delay-ms = Pacerfördröjning ms

# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = RTT ms

# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = Statistik för videoram - MediaStreamTrack ID: { $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = sida sparad till: { $path }
about-webrtc-debug-mode-off-state-msg = spårlogg kan hittas på: { $path }
about-webrtc-debug-mode-on-state-msg = felsökningsläge aktivt, spårlogg kan hittas på: { $path }
about-webrtc-aec-logging-off-state-msg = fångade loggfiler kan hittas i: { $path }

##

# This is the total number of packets received on the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets received.
about-webrtc-received-label =
    { $packets ->
        [one] Mottog { $packets } paket
       *[other] Mottog { $packets } paket
    }

# This is the total number of packets lost by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets lost.
about-webrtc-lost-label =
    { $packets ->
        [one] Förlorade { $packets } paket
       *[other] Förlorade { $packets } paket
    }

# This is the total number of packets sent by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets sent.
about-webrtc-sent-label =
    { $packets ->
        [one] Skickade { $packets } paket
       *[other] Skickade { $packets } paket
    }

# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = Jitter { $jitter }

# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = Trickled kandidater (som anländer efter svar) är markerade i blått

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = Ange Lokal SDP vid tidsstämpel { NUMBER($timestamp, useGrouping: "false") }

# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = Ange Fjärr SDP vid tidsstämpel { NUMBER($timestamp, useGrouping: "false") }

# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = Tidsstämpel { NUMBER($timestamp, useGrouping: "false") } (+ { $relative-timestamp } ms)

##

##

##

