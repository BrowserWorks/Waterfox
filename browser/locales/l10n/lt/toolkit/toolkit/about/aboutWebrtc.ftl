# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = „WebRTC“ vidus

# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = Įrašyti „about:webrtc“ kaip

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = AEC įrašymas
about-webrtc-aec-logging-off-state-label = Pradėti AEC įrašinėjimą
about-webrtc-aec-logging-on-state-label = Baigti AEC įrašinėjimą
about-webrtc-aec-logging-on-state-msg = AEC įrašinėjimas aktyvus (pakalbėkite su pašnekovu keletą minučių, o tada sustabdykite įrašymą)

##

# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = „PeerConnection“ ID:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = Vietinis SDP
about-webrtc-local-sdp-heading-offer = Vietinis SDP (Pasiūlymas)
about-webrtc-local-sdp-heading-answer = Vietinis SDP (Atsakymas)
about-webrtc-remote-sdp-heading = Nutolęs SDP
about-webrtc-remote-sdp-heading-offer = Nutolęs SDP (Pasiūlymas)
about-webrtc-remote-sdp-heading-answer = Nutolęs SDP (Atsakymas)
about-webrtc-sdp-history-heading = SDP istorija
about-webrtc-sdp-parsing-errors-heading = SDP analizės klaidos

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = RTP statistika

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = ICE būsena
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = ICE statistika
about-webrtc-ice-restart-count-label = ICE kartojimai:
about-webrtc-ice-rollback-count-label = ICE atmetimai:
about-webrtc-ice-pair-bytes-sent = Išsiųsta baitų:
about-webrtc-ice-pair-bytes-received = Gauta baitų:
about-webrtc-ice-component-id = Komponento ID

## "Avg." is an abbreviation for Average. These are used as data labels.

about-webrtc-avg-bitrate-label = Vid. pralaidumas:
about-webrtc-avg-framerate-label = Vid. kadrų dažnis:

## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = Vietinis
about-webrtc-type-remote = Nuotolinis

##

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = Nominuota

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = Pasirinkta

about-webrtc-save-page-label = Įrašyti tinklalapį
about-webrtc-debug-mode-msg-label = Derinimo veiksena
about-webrtc-debug-mode-off-state-label = Įjungti derinimo veikseną
about-webrtc-debug-mode-on-state-label = Išjungti derinimo veikseną
about-webrtc-stats-heading = Seanso statistika
about-webrtc-stats-clear = Išvalyti istoriją
about-webrtc-log-heading = Ryšio žurnalas
about-webrtc-log-clear = Išvalyti žurnalą
about-webrtc-log-show-msg = rodyti žurnalą
    .title = spustelėkite, norėdami išskleisti šią sekciją
about-webrtc-log-hide-msg = slėpti žurnalą
    .title = spustelėkite, norėdami suskleisti šią sekciją

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (užverta) { $now }

##

about-webrtc-local-candidate = Vietinis kandidatas
about-webrtc-remote-candidate = Nuotolinis kandidatas
about-webrtc-raw-candidates-heading = Visi neapdoroti kandidatai
about-webrtc-raw-local-candidate = Neapdorotas vietinis kandidatas
about-webrtc-raw-remote-candidate = Neapdorotas nuotolinis kandidatas
about-webrtc-raw-cand-show-msg = rodyti neapdorotus kandidatus
    .title = spustelėkite, norėdami išskleisti šią sekciją
about-webrtc-raw-cand-hide-msg = slėpti neapdorotus kandidatus
    .title = spustelėkite, norėdami suskleisti šią sekciją
about-webrtc-priority = Prioritetas
about-webrtc-fold-show-msg = išsamiau
    .title = spustelėkite, norėdami išskleisti šią sekciją
about-webrtc-fold-hide-msg = mažiau
    .title = spustelėkite, norėdami suskleisti šią sekciją
about-webrtc-dropped-frames-label = Dingę kadrai:
about-webrtc-discarded-packets-label = Išmesti paketiniai duomenys:
about-webrtc-decoder-label = Iškoduotuvas
about-webrtc-encoder-label = Koduotuvas
about-webrtc-show-tab-label = Rodyti kortelę
about-webrtc-width-px = Plotis (px)
about-webrtc-height-px = Aukštis (px)
about-webrtc-consecutive-frames = Kadrai iš eilės
about-webrtc-time-elapsed = Trukmė (s)
about-webrtc-estimated-framerate = Numatomas kadrų dažnis
about-webrtc-rotation-degrees = Pasukimas (laipsniai)
about-webrtc-first-frame-timestamp = Pirmo kadro gavimo laiko žyma
about-webrtc-last-frame-timestamp = Paskutinio kadro gavimo laiko žyma

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = Vietinis gaunamas SSRC
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = Nuotolinis siunčiamas SSRC

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = Pateikta

# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = Nepateikta

# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = Naudotojo nustatytos „WebRTC“ parinktys

# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = Numatomas pralaidumas

# The ID of the MediaStreamTrack
about-webrtc-track-identifier = Takelio identifikatorius

# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = Siuntimo pralaidumas (baitai/sek)

# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = Gavimo pralaidumas (baitas/sek)

# Maximum number of bytes per second that will be padding zeros at the ends of packets
about-webrtc-max-padding-bytes-sec = Didžiausias užpildymas (baitai/sek)

# The amount of time inserted between packets to keep them spaced out
about-webrtc-pacer-delay-ms = Tempo delsa (ms)

# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = RTT (ms)

# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = Vaizdo kadrų statistika – „MediaStreamTrack“ ID: { $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = tinklalapis įrašytas į: { $path }
about-webrtc-debug-mode-off-state-msg = vykdymo sekimo žurnalas yra čia: { $path }
about-webrtc-debug-mode-on-state-msg = derinimo veiksena aktyvi, vykdymo sekimo žurnalas čia: { $path }
about-webrtc-aec-logging-off-state-msg = įrašyti žurnalo failai yra čia: { $path }

##

# This is the total number of packets received on the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets received.
about-webrtc-received-label =
    { $packets ->
        [one] Gautas { $packets } duomenų paketas
        [few] Gauti { $packets } duomenų paketai
       *[other] Gauta { $packets } duomenų paketų
    }

# This is the total number of packets lost by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets lost.
about-webrtc-lost-label =
    { $packets ->
        [one] Pradingęs { $packets } duomenų paketas
        [few] Pradingę { $packets } duomenų paketai
       *[other] Pradingę { $packets } duomenų paketų
    }

# This is the total number of packets sent by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets sent.
about-webrtc-sent-label =
    { $packets ->
        [one] Išsiųstas { $packets } duomenų paketas
        [few] Išsiųsti { $packets } duomenų paketai
       *[other] Išsiųsta { $packets } duomenų paketų
    }

# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = Virpėjimas { $jitter }

# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = Vėlesni („trickled“) kandidatai (atvykstantys po atsakymo) yra paryškinti mėlyna spalva

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = Nustatyti „Vietinis SDP“ ties laiko žyma { NUMBER($timestamp, useGrouping: "false") }

# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = Nustatyti „Nutolęs SDP“ ties laiko žyma { NUMBER($timestamp, useGrouping: "false") }

# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = Laiko žymė: { NUMBER($timestamp, useGrouping: "false") } (+ { $relative-timestamp } ms)

##

