# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = Szczegóły techniczne WebRTC
# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = Zapisz stronę about:webrtc jako

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = Dziennik redukcji szumów otoczenia
about-webrtc-aec-logging-off-state-label = Zapisuj informacje redukcji szumów otoczenia
about-webrtc-aec-logging-on-state-label = Zatrzymaj zapisywanie informacji redukcji szumów otoczenia
about-webrtc-aec-logging-on-state-msg = Zapisywanie informacji redukcji szumów otoczenia (rozmawiaj przez kilka minut, po czym zatrzymaj zapisywanie)

##

# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = Identyfikator PeerConnection:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = Lokalne SDP
about-webrtc-local-sdp-heading-offer = Lokalne SDP (Propozycja)
about-webrtc-local-sdp-heading-answer = Lokalne SDP (Odpowiedź)
about-webrtc-remote-sdp-heading = Zdalne SDP
about-webrtc-remote-sdp-heading-offer = Zdalne SDP (Propozycja)
about-webrtc-remote-sdp-heading-answer = Zdalne SDP (Odpowiedź)
about-webrtc-sdp-history-heading = Historia SDP
about-webrtc-sdp-parsing-errors-heading = Błędy przetwarzania SDP

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = Statystyki RTP

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = Stan ICE
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = Statystyki ICE
about-webrtc-ice-restart-count-label = Ponownych uruchomień ICE:
about-webrtc-ice-rollback-count-label = Wycofań ICE:
about-webrtc-ice-pair-bytes-sent = Bajty wysłane:
about-webrtc-ice-pair-bytes-received = Bajty odebrane:
about-webrtc-ice-component-id = Identyfikator komponentu

##


## "Avg." is an abbreviation for Average. These are used as data labels.

about-webrtc-avg-bitrate-label = Średnia gęstość bitowa:
about-webrtc-avg-framerate-label = Średnia liczba klatek na sekundę:

##


## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = Lokalne
about-webrtc-type-remote = Zdalne

##

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = Nominowane
# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = Wybrane
about-webrtc-save-page-label = Zapisz stronę
about-webrtc-debug-mode-msg-label = Debugowanie
about-webrtc-debug-mode-off-state-label = Rozpocznij debugowanie
about-webrtc-debug-mode-on-state-label = Zatrzymaj debugowanie
about-webrtc-stats-heading = Statystyki sesji
about-webrtc-stats-clear = Wyczyść historię
about-webrtc-log-heading = Dziennik połączenia
about-webrtc-log-clear = Wyczyść dziennik
about-webrtc-log-show-msg = Dziennik
    .title = Kliknij, aby rozwinąć sekcję
about-webrtc-log-hide-msg = Ukryj dziennik
    .title = Kliknij, aby zwinąć sekcję

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (Zakończone) { $now }

##

about-webrtc-local-candidate = Kandydat lokalny
about-webrtc-remote-candidate = Zdalny kandydat
about-webrtc-raw-candidates-heading = Wszyscy nieprzetworzeni kandydaci
about-webrtc-raw-local-candidate = Nieprzetworzony lokalny kandydat
about-webrtc-raw-remote-candidate = Nieprzetworzony zdalny kandydat
about-webrtc-raw-cand-show-msg = Pokaż nieprzetworzonych kandydatów
    .title = Kliknij, aby rozwinąć sekcję
about-webrtc-raw-cand-hide-msg = Ukryj nieprzetworzonych kandydatów
    .title = Kliknij, aby zwinąć sekcję
about-webrtc-priority = Priorytet
about-webrtc-fold-show-msg = Szczegóły
    .title = Kliknij, aby rozwinąć sekcję
about-webrtc-fold-hide-msg = Ukryj szczegóły
    .title = Kliknij, aby zwinąć sekcję
about-webrtc-dropped-frames-label = Pominięte klatki:
about-webrtc-discarded-packets-label = Odrzucone pakiety:
about-webrtc-decoder-label = Dekoder
about-webrtc-encoder-label = Koder
about-webrtc-show-tab-label = Pokaż kartę
about-webrtc-width-px = Szerokość (w pikselach)
about-webrtc-height-px = Wysokość (w pikselach)
about-webrtc-consecutive-frames = Kolejne klatki
about-webrtc-time-elapsed = Upłynęło (w sekundach)
about-webrtc-estimated-framerate = Szacowana liczba klatek na sekundę
about-webrtc-rotation-degrees = Obrót (w stopniach)
about-webrtc-first-frame-timestamp = Czas odbioru pierwszej klatki
about-webrtc-last-frame-timestamp = Czas odbioru ostatniej klatki

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = Lokalny odbierający SSRC
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = Zdalny wysyłający SSRC

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = Podano
# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = Nie podano
# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = Preferencje WebRTC ustawione przez użytkownika
# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = Szacowana przepustowość
# The ID of the MediaStreamTrack
about-webrtc-track-identifier = Identyfikator ścieżki
# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = Przepustowość wysyłania (bajty na sekundę)
# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = Przepustowość odbierania (bajty na sekundę)
# Maximum number of bytes per second that will be padding zeros at the ends of packets
about-webrtc-max-padding-bytes-sec = Maksymalne wypełnienie (bajty na sekundę)
# The amount of time inserted between packets to keep them spaced out
about-webrtc-pacer-delay-ms = Opóźnienie między pakietami w milisekundach
# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = RTT w milisekundach
# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = Statystyki klatek wideo – identyfikator MediaStreamTrack: { $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = Strona zapisana jako { $path }
about-webrtc-debug-mode-off-state-msg = Dziennik debugowania jest zapisywany w pliku { $path }
about-webrtc-debug-mode-on-state-msg = Debugowanie aktywne, dziennik w { $path }
about-webrtc-aec-logging-off-state-msg = Pliki dziennika znajdują się w katalogu { $path }

##

# This is the total number of packets received on the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets received.
about-webrtc-received-label =
    { $packets ->
        [one] Odebrano { $packets } pakiet
        [few] Odebrano { $packets } pakiety
       *[many] Odebrano { $packets } pakietów
    }
# This is the total number of packets lost by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets lost.
about-webrtc-lost-label =
    { $packets ->
        [one] Utracono { $packets } pakiet
        [few] Utracono { $packets } pakiety
       *[many] Utracono { $packets } pakietów
    }
# This is the total number of packets sent by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets sent.
about-webrtc-sent-label =
    { $packets ->
        [one] Wysłano { $packets } pakiet
        [few] Wysłano { $packets } pakiety
       *[many] Wysłano { $packets } pakietów
    }
# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = Jitter { $jitter }
# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = Kandydaci odebrani po odpowiedzi są wyróżniani na niebiesko

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = Ustawiono „Lokalne SDP” o { NUMBER($timestamp, useGrouping: "false") }
# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = Ustawiono „Zdalne SDP” o { NUMBER($timestamp, useGrouping: "false") }
# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = O { NUMBER($timestamp, useGrouping: "false") } (+{ $relative-timestamp } ms)

##

