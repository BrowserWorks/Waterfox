# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = WebRTC - Interne Daten
# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = about:webrtc speichern unter

## These labels are for a disclosure which contains the information for closed PeerConnection sections

about-webrtc-closed-peerconnection-disclosure-show-msg = Geschlossene PeerConnections anzeigen
about-webrtc-closed-peerconnection-disclosure-hide-msg = Geschlossene PeerConnections ausblenden

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = AEC-Protokollierung
about-webrtc-aec-logging-off-state-label = AEC-Protokollierung starten
about-webrtc-aec-logging-on-state-label = AEC-Protokollierung beenden
about-webrtc-aec-logging-on-state-msg = AEC-Protokollierung aktiv (sprechen Sie einige Minuten mit dem Anrufer und stoppen Sie dann die Aufnahme)
about-webrtc-aec-logging-toggled-on-state-msg = AEC-Protokollierung aktiv (sprechen Sie einige Minuten mit dem Anrufer und stoppen Sie dann die Aufnahme)
about-webrtc-aec-logging-unavailable-sandbox = Die Umgebungsvariable MOZ_DISABLE_CONTENT_SANDBOX=1 ist für den Export von AEC-Protokollen erforderlich. Setzen Sie diese Variable nur, wenn Sie die möglichen Risiken verstehen.
# Variables:
#  $path (String) - The path to which the aec log file is saved.
about-webrtc-aec-logging-toggled-off-state-msg = Gespeicherte protokolldateien befinden sich in: { $path }

##

# The autorefresh checkbox causes a stats section to autorefresh its content when checked
about-webrtc-auto-refresh-label = Automatisch aktualisieren
# Determines the default state of the Auto Refresh check boxes
about-webrtc-auto-refresh-default-label = Standardmäßig automatisch aktualisieren
# A button which forces a refresh of displayed statistics
about-webrtc-force-refresh-button = Aktualisieren
# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = PeerConnection-ID:
# The number of DataChannels that a PeerConnection has opened
about-webrtc-data-channels-opened-label = Geöffnete Datenkanäle:
# The number of once open DataChannels that a PeerConnection has closed
about-webrtc-data-channels-closed-label = Geschlossene Datenkanäle:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = Lokales SDP
about-webrtc-local-sdp-heading-offer = Lokales SDP (Offerte)
about-webrtc-local-sdp-heading-answer = Lokales SDP (Antwort)
about-webrtc-remote-sdp-heading = Externes SDP
about-webrtc-remote-sdp-heading-offer = Externes SDP (Offerte)
about-webrtc-remote-sdp-heading-answer = Externes SDP (Antwort)
about-webrtc-sdp-history-heading = SDP-Verlauf
about-webrtc-sdp-parsing-errors-heading = SDP-Parsing-Fehler

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = RTP-Statistiken

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = ICE-Status
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = ICE-Statistiken
about-webrtc-ice-restart-count-label = ICE-Neustarts:
about-webrtc-ice-rollback-count-label = ICE-Zurücknahmen (Rollbacks):
about-webrtc-ice-pair-bytes-sent = Bytes gesendet:
about-webrtc-ice-pair-bytes-received = Bytes empfangen:
about-webrtc-ice-component-id = Komponenten-ID

## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = Lokal
about-webrtc-type-remote = Extern

##

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = Nominiert
# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = Ausgewählt
about-webrtc-save-page-label = Seite speichern
about-webrtc-debug-mode-msg-label = Debug-Modus
about-webrtc-debug-mode-off-state-label = Debug-Modus starten
about-webrtc-debug-mode-on-state-label = Debug-Modus beenden
about-webrtc-enable-logging-label = WebRTC-Protokollvoreinstellung aktivieren
about-webrtc-stats-heading = Sitzungsstatistiken
about-webrtc-stats-clear = Chronik löschen
about-webrtc-log-heading = Verbindungsprotokoll
about-webrtc-log-clear = Protokoll löschen
about-webrtc-log-show-msg = Protokoll anzeigen
    .title = Zum Erweitern des Abschnitts anklicken
about-webrtc-log-hide-msg = Protokoll ausblenden
    .title = Zum Minimieren des Abschnitts anklicken
about-webrtc-log-section-show-msg = Protokoll anzeigen
    .title = Zum erweitern des abschnitts anklicken
about-webrtc-log-section-hide-msg = Protokoll ausblenden
    .title = Zum minimieren des abschnitts anklicken
about-webrtc-copy-report-button = Bericht kopieren
about-webrtc-copy-report-history-button = Berichts-Chronik kopieren

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (schließen) { $now }

## These are used to indicate what direction media is flowing.
## Variables:
##  $codecs - a list of media codecs

about-webrtc-short-send-receive-direction = Senden/Empfangen: { $codecs }
about-webrtc-short-send-direction = Senden: { $codecs }
about-webrtc-short-receive-direction = Empfangen: { $codecs }

##

about-webrtc-local-candidate = Lokaler Kandidat
about-webrtc-remote-candidate = Externer Kandidat
about-webrtc-raw-candidates-heading = Alle unformatierten Kandidaten
about-webrtc-raw-local-candidate = Unformatierte Lokale Kandidaten
about-webrtc-raw-remote-candidate = Unformatierte Externe Kandidaten
about-webrtc-raw-cand-show-msg = Unformatierte Kandidaten anzeigen
    .title = Zum Erweitern des Abschnitts anklicken
about-webrtc-raw-cand-hide-msg = Unformatierte Kandidaten ausblenden
    .title = Zum Minimieren des Abschnitts anklicken
about-webrtc-raw-cand-section-show-msg = Unformatierte kandidaten anzeigen
    .title = Zum erweitern des abschnitts anklicken
about-webrtc-raw-cand-section-hide-msg = Unformatierte kandidaten ausblenden
    .title = Zum minimieren des abschnitts anklicken
about-webrtc-priority = Priorität
about-webrtc-fold-show-msg = Details anzeigen
    .title = Zum Erweitern des Abschnitts anklicken
about-webrtc-fold-hide-msg = Details ausblenden
    .title = Zum Minimieren des Abschnitts anklicken
about-webrtc-fold-default-show-msg = Details anzeigen
    .title = Zum erweitern des abschnitts anklicken
about-webrtc-fold-default-hide-msg = Details ausblenden
    .title = Zum minimieren des abschnitts anklicken
about-webrtc-dropped-frames-label = Übersprungene Bilder:
about-webrtc-discarded-packets-label = Verworfene Pakete:
about-webrtc-decoder-label = Decoder
about-webrtc-encoder-label = Encoder
about-webrtc-show-tab-label = Tab anzeigen
about-webrtc-current-framerate-label = Bildfrequenz
about-webrtc-width-px = Breite (px)
about-webrtc-height-px = Höhe (px)
about-webrtc-consecutive-frames = Aufeinanderfolgende Bilder
about-webrtc-time-elapsed = Verstrichene Zeit (s)
about-webrtc-estimated-framerate = Geschätzte Bildfrequenz
about-webrtc-rotation-degrees = Rotation (Grad)
about-webrtc-first-frame-timestamp = Zeitstempel für den Empfang des ersten Bilds
about-webrtc-last-frame-timestamp = Zeitstempel für den Empfang des letzten Bilds

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = Lokale empfangende SSRC
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = Entfernte sendende SSRC

## These are displayed on the button that shows or hides the
## PeerConnection configuration disclosure

about-webrtc-pc-configuration-show-msg = Konfiguration anzeigen
about-webrtc-pc-configuration-hide-msg = Konfiguration ausblenden

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = Angegeben
# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = Nicht angegeben
# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = Vom Benutzer festgelegte WebRTC-Einstellungen
# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = Geschätzte Bandbreite
# The ID of the MediaStreamTrack
about-webrtc-track-identifier = Track-Identifikator
# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = Sende-Bandbreite [Bytes/s]
# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = Empfangs-Bandbreite [Bytes/s]
# Maximum number of bytes per second that will be padding zeros at the ends of packets
about-webrtc-max-padding-bytes-sec = Maximales Padding [Bytes/s]
# The amount of time inserted between packets to keep them spaced out
about-webrtc-pacer-delay-ms = Pacer-Verzögerung [ms]
# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = Paketumlaufzeit (RTT) [ms]
# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = Videoframe-Statistiken - MediaStreamTrack-ID: { $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = Seite gespeichert als: { $path }
about-webrtc-debug-mode-off-state-msg = Das Ablaufprotokoll befindet sich in: { $path }
about-webrtc-debug-mode-on-state-msg = Debug-Modus aktiv, Ablaufprotokoll in: { $path }
about-webrtc-aec-logging-off-state-msg = Gespeicherte Protokolldateien befinden sich in: { $path }
# This path is used for saving the about:webrtc page so it can be attached to
# bug reports.
# Variables:
#  $path (String) - The path to which the file is saved.
about-webrtc-save-page-complete-msg = Seite gespeichert als: { $path }
about-webrtc-debug-mode-toggled-off-state-msg = Das ablaufprotokoll befindet sich in: { $path }
about-webrtc-debug-mode-toggled-on-state-msg = Debug-modus aktiv, ablaufprotokoll in: { $path }
# This is the total number of frames encoded or decoded over an RTP stream.
# Variables:
#  $frames (Number) - The number of frames encoded or decoded.
about-webrtc-frames =
    { $frames ->
        [one] { $frames } Bild
       *[other] { $frames } Bilder
    }
# This is the number of audio channels encoded or decoded over an RTP stream.
# Variables:
#  $channels (Number) - The number of channels encoded or decoded.
about-webrtc-channels =
    { $channels ->
        [one] { $channels } Kanal
       *[other] { $channels } Kanäle
    }
# This is the total number of packets received on the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets received.
about-webrtc-received-label =
    { $packets ->
        [one] { $packets } Paket empfangen
       *[other] { $packets } Pakete empfangen
    }
# This is the total number of packets lost by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets lost.
about-webrtc-lost-label =
    { $packets ->
        [one] { $packets } Paket verloren
       *[other] { $packets } Pakete verloren
    }
# This is the total number of packets sent by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets sent.
about-webrtc-sent-label =
    { $packets ->
        [one] { $packets } Paket gesendet
       *[other] { $packets } Pakete gesendet
    }
# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = Jitter { $jitter }
# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = Eintrudelnde Kandidaten ("Trickled" - kamen nach der Antwort an) sind in blau hervorgehoben

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = Lokales SDP wurde zum Zeitstempel { NUMBER($timestamp, useGrouping: "false") } gesetzt
# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = Externes SDP wurde zum Zeitstempel { NUMBER($timestamp, useGrouping: "false") } gesetzt
# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = Zeitstempel { NUMBER($timestamp, useGrouping: "false") } (+ { $relative-timestamp } ms)

## These are displayed on the button that shows or hides the SDP information disclosure

about-webrtc-show-msg-sdp = SDP anzeigen
about-webrtc-hide-msg-sdp = SDP ausblenden

## These are displayed on the button that shows or hides the Media Context information disclosure.
## The Media Context is the set of preferences and detected capabilities that informs
## the negotiated CODEC settings.

about-webrtc-media-context-show-msg = Medienkontext anzeigen
about-webrtc-media-context-hide-msg = Medienkontext verbergen
about-webrtc-media-context-heading = Medienkontext

##


##

