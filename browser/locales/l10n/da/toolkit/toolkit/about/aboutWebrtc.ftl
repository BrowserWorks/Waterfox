# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = WebRTC-dele

# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = gem about:webrtc som

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = AEC-logning
about-webrtc-aec-logging-off-state-label = Start AEC-logning
about-webrtc-aec-logging-on-state-label = Stop AEC-logning
about-webrtc-aec-logging-on-state-msg = AEC-logning er aktiveret (tal med opringeren i nogle minutter og deaktivér så logningen)

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
about-webrtc-remote-sdp-heading = Fjern-SDP
about-webrtc-remote-sdp-heading-offer = Fjern-SDP (Offer)
about-webrtc-remote-sdp-heading-answer = Fjern-SDP (Answer)
about-webrtc-sdp-history-heading = SDP-historik
about-webrtc-sdp-parsing-errors-heading = SDP-fortolkningsfejl

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = RTP-statistikker

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = ICE-tilstand
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = ICE-statistikker
about-webrtc-ice-restart-count-label = ICE-genstarter:
about-webrtc-ice-rollback-count-label = ICE-tilbagerulninger:
about-webrtc-ice-pair-bytes-sent = Bytes sent:
about-webrtc-ice-pair-bytes-received = Bytes modtaget:
about-webrtc-ice-component-id = Komponent-ID

## "Avg." is an abbreviation for Average. These are used as data labels.

about-webrtc-avg-bitrate-label = Gns. bitrate:
about-webrtc-avg-framerate-label = Gns. framerate

## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = Lokal
about-webrtc-type-remote = Fjern

##


# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = Nomineret

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = Valgt

about-webrtc-save-page-label = Gem side
about-webrtc-debug-mode-msg-label = Debug-tilstand
about-webrtc-debug-mode-off-state-label = Start debug-tilstand
about-webrtc-debug-mode-on-state-label = Stop debug-tilstand
about-webrtc-stats-heading = Sessionsstatistik
about-webrtc-stats-clear = Ryd historik
about-webrtc-log-heading = Forbindelses-log
about-webrtc-log-clear = Ryd log
about-webrtc-log-show-msg = vis log
    .title = klik for at udvide denne sektion
about-webrtc-log-hide-msg = skjul log
    .title = klik for at sammenklappe denne sektion

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (lukket) { $now }

##


about-webrtc-local-candidate = Lokal kandidat
about-webrtc-remote-candidate = Fjern-kandidat
about-webrtc-raw-candidates-heading = Alle raw-kandidater
about-webrtc-raw-local-candidate = Raw lokale kandidater
about-webrtc-raw-remote-candidate = Raw fjern-kandikater
about-webrtc-raw-cand-show-msg = vis raw-kandidater
    .title = klik for at udvide denne sektion
about-webrtc-raw-cand-hide-msg = skjul raw-kandidater
    .title = klik for at sammenklappe denne sektion
about-webrtc-priority = Prioritet
about-webrtc-fold-show-msg = vis detaljer
    .title = klik for at udvide denne sektion
about-webrtc-fold-hide-msg = skjul detaljer
    .title = klik for at sammenklappe denne sektion
about-webrtc-dropped-frames-label = Dropped frames:
about-webrtc-discarded-packets-label = Kasserede pakker:
about-webrtc-decoder-label = Dekoder
about-webrtc-encoder-label = Koder
about-webrtc-show-tab-label = Vis faneblad
about-webrtc-width-px = Bredde (px)
about-webrtc-height-px = Højde (px)
about-webrtc-consecutive-frames = Sammenhængende rammer
about-webrtc-time-elapsed = Forløbet tid (s)
about-webrtc-estimated-framerate = Estimeret framerate
about-webrtc-rotation-degrees = Rotation (grader)
about-webrtc-first-frame-timestamp = Tidsstempel for modtagelse af første frame
about-webrtc-last-frame-timestamp = Tidsstempel for modtagelse af sidste frame

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = Lokalt modtagende SSRC
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = Fjernt sendende SSRC

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = Angivet

# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = Ikke angivet

# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = WebRTC-indstillinger sat af brugeren

# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = Anslået båndbredde

# The ID of the MediaStreamTrack
about-webrtc-track-identifier = Spor-identifikator

# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = Båndbredde for afsendelse (bytes/sek)

# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = Båndbredde for modtagelse (bytes/sek)

# Maximum number of bytes per second that will be padding zeros at the ends of packets
about-webrtc-max-padding-bytes-sec = Maksimal padding (bytes/sek)

# The amount of time inserted between packets to keep them spaced out
about-webrtc-pacer-delay-ms = Pacer-forsinkelse ms

# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = RTT ms

# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = Videoframe-statistik - MediaStreamTrack ID: { $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = Side gemt som: { $path }
about-webrtc-debug-mode-off-state-msg = trace-log kan findes her: { $path }
about-webrtc-debug-mode-on-state-msg = debug-tilstand er aktiveret, trace-log findes her: { $path }
about-webrtc-aec-logging-off-state-msg = log-filer kan findes her: { $path }

##

# This is the total number of packets received on the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets received.
about-webrtc-received-label =
    { $packets ->
        [one] Modtog { $packets } pakke
       *[other] Modtog { $packets } pakker
    }

# This is the total number of packets lost by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets lost.
about-webrtc-lost-label =
    { $packets ->
        [one] Mistede { $packets } pakke
       *[other] Mistede { $packets } pakker
    }

# This is the total number of packets sent by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets sent.
about-webrtc-sent-label =
    { $packets ->
        [one] Sendte { $packets } pakke
       *[other] Sendte { $packets } pakker
    }

# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = Jitter { $jitter }

# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = Trickled kandidater (ankommet efter answer) er fremhævet med blåt

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = Sæt Lokal SDP ved tidsstempel { NUMBER($timestamp, useGrouping: "false") }

# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = Sæt Fjern-SDP ved tidsstempel { NUMBER($timestamp, useGrouping: "false") }

# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = Tidsstempel { NUMBER($timestamp, useGrouping: "false") } (+ { $relative-timestamp } ms)

##

##

##

