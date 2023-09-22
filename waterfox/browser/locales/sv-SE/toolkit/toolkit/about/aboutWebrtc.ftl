# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = WebRTC-internt
# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = spara about:webrtc som

## These labels are for a disclosure which contains the information for closed PeerConnection sections

about-webrtc-closed-peerconnection-disclosure-show-msg = Visa stängda PeerConnections
about-webrtc-closed-peerconnection-disclosure-hide-msg = Dölj stängda PeerConnections

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = AEC-loggning
about-webrtc-aec-logging-off-state-label = Starta AEC-loggning
about-webrtc-aec-logging-on-state-label = Stoppa AEC-loggning
about-webrtc-aec-logging-on-state-msg = AEC-loggning aktiv (tala med den som ringer i några minuter och stoppa sedan fångst)
about-webrtc-aec-logging-toggled-on-state-msg = AEC-loggning aktiv (tala med den som ringer i några minuter och stoppa sedan fångst)
about-webrtc-aec-logging-unavailable-sandbox = Miljövariabeln MOZ_DISABLE_CONTENT_SANDBOX=1 krävs för att exportera AEC-loggar. Ställ bara in denna variabel om du förstår de möjliga riskerna.
# Variables:
#  $path (String) - The path to which the aec log file is saved.
about-webrtc-aec-logging-toggled-off-state-msg = Fångade loggfiler kan hittas i: { $path }

##

# The autorefresh checkbox causes a stats section to autorefresh its content when checked
about-webrtc-auto-refresh-label = Automatisk omladdning
# Determines the default state of the Auto Refresh check boxes
about-webrtc-auto-refresh-default-label = Uppdatera automatiskt som standard
# A button which forces a refresh of displayed statistics
about-webrtc-force-refresh-button = Uppdatera
# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = PeerConnection-ID:
# The number of DataChannels that a PeerConnection has opened
about-webrtc-data-channels-opened-label = Öppnade datakanaler:
# The number of once open DataChannels that a PeerConnection has closed
about-webrtc-data-channels-closed-label = Stängda datakanaler:

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
about-webrtc-enable-logging-label = Aktivera WebRTC-loggförinställning
about-webrtc-stats-heading = Sessionsstatistik
about-webrtc-stats-clear = Rensa historik
about-webrtc-log-heading = Anslutningslogg
about-webrtc-log-clear = Rensa logg
about-webrtc-log-show-msg = visa logg
    .title = klicka för att expandera denna sektion
about-webrtc-log-hide-msg = dölj logg
    .title = klicka för att minimera denna sektion
about-webrtc-log-section-show-msg = Visa logg
    .title = Klicka för att expandera denna sektion
about-webrtc-log-section-hide-msg = Dölj logg
    .title = Klicka för att minimera denna sektion
about-webrtc-copy-report-button = Kopiera rapport
about-webrtc-copy-report-history-button = Kopiera rapporthistorik

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (stängd) { $now }

## These are used to indicate what direction media is flowing.
## Variables:
##  $codecs - a list of media codecs

about-webrtc-short-send-receive-direction = Skicka / ta emot: { $codecs }
about-webrtc-short-send-direction = Skicka: { $codecs }
about-webrtc-short-receive-direction = Ta emot: { $codecs }

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
about-webrtc-raw-cand-section-show-msg = Visa råa kandidater
    .title = Klicka för att expandera denna sektion
about-webrtc-raw-cand-section-hide-msg = Dölj råa kandidater
    .title = Klicka för att minimera denna sektion
about-webrtc-priority = Prioritet
about-webrtc-fold-show-msg = visa detaljer
    .title = klicka för att expandera denna sektion
about-webrtc-fold-hide-msg = dölj detaljer
    .title = klicka för att minimera denna sektion
about-webrtc-fold-default-show-msg = Visa detaljer
    .title = Klicka för att expandera denna sektion
about-webrtc-fold-default-hide-msg = Dölj detaljer
    .title = Klicka för att minimera denna sektion
about-webrtc-dropped-frames-label = Utelämnade bildrutor:
about-webrtc-discarded-packets-label = Ignorerade paket:
about-webrtc-decoder-label = Avkodare
about-webrtc-encoder-label = Kodare
about-webrtc-show-tab-label = Visa flik
about-webrtc-current-framerate-label = Bildhastighet
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

## These are displayed on the button that shows or hides the
## PeerConnection configuration disclosure

about-webrtc-pc-configuration-show-msg = Visa konfiguration
about-webrtc-pc-configuration-hide-msg = Dölj konfiguration

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
# This path is used for saving the about:webrtc page so it can be attached to
# bug reports.
# Variables:
#  $path (String) - The path to which the file is saved.
about-webrtc-save-page-complete-msg = Sida sparad till: { $path }
about-webrtc-debug-mode-toggled-off-state-msg = Spårlogg kan hittas på: { $path }
about-webrtc-debug-mode-toggled-on-state-msg = Felsökningsläge aktivt, spårlogg kan hittas på: { $path }
# This is the total number of frames encoded or decoded over an RTP stream.
# Variables:
#  $frames (Number) - The number of frames encoded or decoded.
about-webrtc-frames =
    { $frames ->
        [one] { $frames } ram
       *[other] { $frames } ramar
    }
# This is the number of audio channels encoded or decoded over an RTP stream.
# Variables:
#  $channels (Number) - The number of channels encoded or decoded.
about-webrtc-channels =
    { $channels ->
        [one] { $channels } kanal
       *[other] { $channels } kanaler
    }
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

## These are displayed on the button that shows or hides the SDP information disclosure

about-webrtc-show-msg-sdp = Visa SDP
about-webrtc-hide-msg-sdp = Dölj SDP

## These are displayed on the button that shows or hides the Media Context information disclosure.
## The Media Context is the set of preferences and detected capabilities that informs
## the negotiated CODEC settings.

about-webrtc-media-context-show-msg = Visa mediakontext
about-webrtc-media-context-hide-msg = Dölj mediakontext
about-webrtc-media-context-heading = Mediakontext

##


##

