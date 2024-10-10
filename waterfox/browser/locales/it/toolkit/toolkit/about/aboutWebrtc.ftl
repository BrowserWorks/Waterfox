# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = WebRTC - Elementi interni

# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = Salva about:webrtc come

## These labels are for a disclosure which contains the information for closed PeerConnection sections

about-webrtc-closed-peerconnection-disclosure-show-msg = Mostra PeerConnection chiuse
about-webrtc-closed-peerconnection-disclosure-hide-msg = Nascondi PeerConnection chiuse

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = Registrazione AEC
about-webrtc-aec-logging-off-state-label = Avvia registrazione AEC
about-webrtc-aec-logging-on-state-label = Interrompi registrazione AEC
about-webrtc-aec-logging-on-state-msg = Registrazione AEC attiva (parlare per qualche minuto con un interlocutore e interrompere la registrazione)

about-webrtc-aec-logging-toggled-on-state-msg = Registrazione AEC attiva (parlare per qualche minuto con un interlocutore e interrompere la registrazione)
about-webrtc-aec-logging-unavailable-sandbox = È obbligatorio utilizzare la variabile d’ambiente MOZ_DISABLE_CONTENT_SANDBOX=1 per esportare i registri AEC. Impostare questa variabile solo se si comprendono i potenziali rischi associati.
# Variables:
#  $path (String) - The path to which the aec log file is saved.
about-webrtc-aec-logging-toggled-off-state-msg = I file di registro creati sono disponibili in: { $path }

##

# The autorefresh checkbox causes the page to autorefresh its content when checked
about-webrtc-auto-refresh-label = Aggiorna automaticamente

about-webrtc-auto-refresh-default-label = Aggiorna automaticamente per impostazione predefinita

about-webrtc-force-refresh-button = Aggiorna


# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = ID PeerConnection:

# The number of DataChannels that a PeerConnection has opened
about-webrtc-data-channels-opened-label = Canali di dati aperti:

# The number of once open DataChannels that a PeerConnection has closed
about-webrtc-data-channels-closed-label = Canali di dati chiusi:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = SDP locale
about-webrtc-local-sdp-heading-offer = SDP locale (Proposta)
about-webrtc-local-sdp-heading-answer = SDP locale (Risposta)
about-webrtc-remote-sdp-heading = SDP remoto
about-webrtc-remote-sdp-heading-offer = SDP remoto (Proposta)
about-webrtc-remote-sdp-heading-answer = SDP remoto (Risposta)
about-webrtc-sdp-history-heading = Cronologia SDP
about-webrtc-sdp-parsing-errors-heading = Errori elaborazione SDP

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = RTPStats

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = Stato ICE
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = Statistiche ICE
about-webrtc-ice-restart-count-label = Riavvii ICE:
about-webrtc-ice-rollback-count-label = Rollback ICE:
about-webrtc-ice-pair-bytes-sent = Byte inviati:
about-webrtc-ice-pair-bytes-received = Byte ricevuti:
about-webrtc-ice-component-id = ID componente

## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = Locale
about-webrtc-type-remote = Remoto

##

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = Nominato

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = Selezionato

about-webrtc-save-page-label = Salva pagina
about-webrtc-debug-mode-msg-label = Modalità di debug
about-webrtc-debug-mode-off-state-label = Avvia modalità di debug
about-webrtc-debug-mode-on-state-label = Interrompi modalità di debug
about-webrtc-enable-logging-label = Attiva preset di registrazione per WebRTC
about-webrtc-stats-heading = Statistiche di sessione
about-webrtc-stats-clear = Cancella cronologia
about-webrtc-log-heading = Registro di connessione
about-webrtc-log-clear = Cancella registro
about-webrtc-log-show-msg = Visualizza registro
    .title = fare clic per espandere questa sezione
about-webrtc-log-hide-msg = Nascondi registro
    .title = fare clic per comprimere questa sezione

about-webrtc-log-section-show-msg = Visualizza registro
    .title = Fare clic per espandere questa sezione
about-webrtc-log-section-hide-msg = Nascondi registro
    .title = Fare clic per comprimere questa sezione
about-webrtc-copy-report-button = Copia rapporto
about-webrtc-copy-report-history-button = Copia cronologia rapporti

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (chiusa) { $now }

## These are used to indicate what direction media is flowing.
## Variables:
##  $codecs - a list of media codecs

about-webrtc-short-send-receive-direction = Invio/ricezione: { $codecs }
about-webrtc-short-send-direction = Invio: { $codecs }
about-webrtc-short-receive-direction = Ricezione: { $codecs }

##

about-webrtc-local-candidate = Candidato locale
about-webrtc-remote-candidate = Candidato remoto
about-webrtc-raw-candidates-heading = Tutti i candidati non elaborati
about-webrtc-raw-local-candidate = Candidati locali non elaborati
about-webrtc-raw-remote-candidate = Candidati remoti non elaborati
about-webrtc-raw-cand-show-msg = mostra candidati non elaborati
    .title = fare clic per espandere questa sezione
about-webrtc-raw-cand-hide-msg = nascondi candidati non elaborati
    .title = fare clic per comprimere questa sezione
about-webrtc-raw-cand-section-show-msg = Mostra candidati non elaborati
    .title = Fare clic per espandere questa sezione
about-webrtc-raw-cand-section-hide-msg = Nascondi candidati non elaborati
    .title = Fare clic per comprimere questa sezione
about-webrtc-priority = Priorità
about-webrtc-fold-show-msg = visualizza dettagli
    .title = fare clic per espandere questa sezione
about-webrtc-fold-hide-msg = nascondi dettagli
    .title = fare clic per comprimere questa sezione
about-webrtc-fold-default-show-msg = Visualizza dettagli
    .title = Fare clic per espandere questa sezione
about-webrtc-fold-default-hide-msg = Nascondi dettagli
    .title = Fare clic per comprimere questa sezione
about-webrtc-dropped-frames-label = Frame persi:
about-webrtc-discarded-packets-label = Pacchetti scartati:
about-webrtc-decoder-label = Decodificatore
about-webrtc-encoder-label = Codificatore
about-webrtc-show-tab-label = Mostra scheda
about-webrtc-current-framerate-label = Frequenza frame
about-webrtc-width-px = Larghezza (px)
about-webrtc-height-px = Altezza (px)
about-webrtc-consecutive-frames = Frame consecutivi
about-webrtc-time-elapsed = Tempo trascorso (s)
about-webrtc-estimated-framerate = Frequenza frame stimata
about-webrtc-rotation-degrees = Rotazione (gradi)
about-webrtc-first-frame-timestamp = Timestamp ricezione primo frame
about-webrtc-last-frame-timestamp = Timestamp ricezione ultimo frame

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = Ricezione SSRC locale
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = Ricezione SSRC remota

## These are displayed on the button that shows or hides the
## PeerConnection configuration disclosure

about-webrtc-pc-configuration-show-msg = Mostra configurazione
about-webrtc-pc-configuration-hide-msg = Nascondi configurazione

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = Fornito

# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = Non fornito

# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = Impostazioni WebRTC modificate dall’utente

# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = Larghezza di banda stimata

# The ID of the MediaStreamTrack
about-webrtc-track-identifier = Identificatore traccia

# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = Larghezza di banda in invio (byte/s)

# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = Larghezza di banda in ricezione (byte/s)

# Maximum number of bytes per second that will be padding zeros at the ends of packets
about-webrtc-max-padding-bytes-sec = Padding massimo (byte/s)

# The amount of time inserted between packets to keep them spaced out
about-webrtc-pacer-delay-ms = Ritardo pacer ms

# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = RTT ms

# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = Statistiche frame video - MediaStreamTrack ID: { $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = Pagina salvata in: { $path }
about-webrtc-debug-mode-off-state-msg = I registri di traccia sono disponibili in: { $path }
about-webrtc-debug-mode-on-state-msg = Modalità di debug attiva, scrittura registri di traccia in: { $path }
about-webrtc-aec-logging-off-state-msg = I file di registro creati sono disponibili in: { $path }

about-webrtc-save-page-complete-msg = Pagina salvata in: { $path }

##

# This is the total number of frames encoded or decoded over an RTP stream.
# Variables:
#  $frames (Number) - The number of frames encoded or decoded.
about-webrtc-frames = { $frames } frame

# This is the number of audio channels encoded or decoded over an RTP stream.
# Variables:
#  $channels (Number) - The number of channels encoded or decoded.
about-webrtc-channels =
    { $channels ->
        [one] { $channels } canale
       *[other] { $channels } canali
    }

# This is the total number of packets received on the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets received.
about-webrtc-received-label =
    { $packets ->
        [one] { $packets } pacchetto ricevuto
       *[other] { $packets } pacchetti ricevuti
    }

# This is the total number of packets lost by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets lost.
about-webrtc-lost-label =
    { $packets ->
        [one] { $packets } pacchetto perso
       *[other] { $packets } pacchetti persi
    }

# This is the total number of packets sent by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets sent.
about-webrtc-sent-label =
    { $packets ->
        [one] { $packets } pacchetto inviato
       *[other] { $packets } pacchetti inviati
    }

# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = Jitter { $jitter }

# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = I candidati “trickled” (ricevuti dopo la risposta) sono evidenziati in blu

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = Impostato SDP locale con timestamp { NUMBER($timestamp, useGrouping: "false") }

# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = Impostato SDP remoto con timestamp { NUMBER($timestamp, useGrouping: "false") }

# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = Timestamp { NUMBER($timestamp, useGrouping: "false") } (+ { $relative-timestamp } ms)

## These are displayed on the button that shows or hides the SDP information disclosure

about-webrtc-show-msg-sdp = Mostra SDP
about-webrtc-hide-msg-sdp = Nascondi SDP

## These are displayed on the button that shows or hides the Media Context information disclosure.
## The Media Context is the set of preferences and detected capabilities that informs
## the negotiated CODEC settings.

about-webrtc-media-context-show-msg = Mostra contesto multimediale
about-webrtc-media-context-hide-msg = Nascondi contesto multimediale
about-webrtc-media-context-heading = Contesto multimediale

##




