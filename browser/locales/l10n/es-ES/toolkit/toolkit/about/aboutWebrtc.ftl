# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = Datos internos de WebRTC
# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = guardar about:webrtc como

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = Registro AEC
about-webrtc-aec-logging-off-state-label = Iniciar registro AEC
about-webrtc-aec-logging-on-state-label = Detener registro AEC
about-webrtc-aec-logging-on-state-msg = Registro AEC activo (hable con el interlocutor durante unos minutos y luego detenga la captura)

##

# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = ID de PeerConnection:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = SDP local
about-webrtc-local-sdp-heading-offer = SDP local (Oferta)
about-webrtc-local-sdp-heading-answer = SDP local (Respuesta)
about-webrtc-remote-sdp-heading = SDP remoto
about-webrtc-remote-sdp-heading-offer = SDP remoto (Oferta)
about-webrtc-remote-sdp-heading-answer = SDP remoto (Respuesta)
about-webrtc-sdp-history-heading = Historial SDP
about-webrtc-sdp-parsing-errors-heading = Errores de análisis de SDP

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = Estadísticas RDP

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = Estado ICE
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = Estadísticas ICE
about-webrtc-ice-restart-count-label = Reinicios de ICE:
about-webrtc-ice-rollback-count-label = Vueltas atrás de ICE:
about-webrtc-ice-pair-bytes-sent = Bytes enviados:
about-webrtc-ice-pair-bytes-received = Bytes recibidos:
about-webrtc-ice-component-id = ID del componente

##


## "Avg." is an abbreviation for Average. These are used as data labels.

about-webrtc-avg-bitrate-label = Tasa de bits promedio:
about-webrtc-avg-framerate-label = Tasa de fotogramas promedio:

##


## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = Local
about-webrtc-type-remote = Remoto

##

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = Nominado
# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = Seleccionado
about-webrtc-save-page-label = Guardar página
about-webrtc-debug-mode-msg-label = Modo de depuración
about-webrtc-debug-mode-off-state-label = Iniciar modo de depuración
about-webrtc-debug-mode-on-state-label = Detener el modo de depuración
about-webrtc-stats-heading = Estadísticas de la sesión
about-webrtc-stats-clear = Limpiar historial
about-webrtc-log-heading = Registro de conexión
about-webrtc-log-clear = Limpiar registro
about-webrtc-log-show-msg = mostrar registro
    .title = pulse para expandir esta sección
about-webrtc-log-hide-msg = ocultar registro
    .title = pulse para contraer esta sección

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (cerrado) { $now }

##

about-webrtc-local-candidate = Candidato local
about-webrtc-remote-candidate = Candidato remoto
about-webrtc-raw-candidates-heading = Todos los candidatos no procesados
about-webrtc-raw-local-candidate = Candidato local no procesados
about-webrtc-raw-remote-candidate = Candidato remoto no procesados
about-webrtc-raw-cand-show-msg = mostrar candidatos no procesados
    .title = pulse para expandir esta sección
about-webrtc-raw-cand-hide-msg = ocultar candidatos no procesados
    .title = pulse para contraer esta sección
about-webrtc-priority = Prioridad
about-webrtc-fold-show-msg = mostrar detalles
    .title = pulse para expandir esta sección
about-webrtc-fold-hide-msg = ocultar detalles
    .title = pulse para contraer esta sección
about-webrtc-dropped-frames-label = Fotogramas descartados:
about-webrtc-discarded-packets-label = Paquetes descartados:
about-webrtc-decoder-label = Decodificador
about-webrtc-encoder-label = Codificador
about-webrtc-show-tab-label = Mostrar pestaña
about-webrtc-width-px = Ancho (px)
about-webrtc-height-px = Altura (px)
about-webrtc-consecutive-frames = Fotogramas consecutivos
about-webrtc-time-elapsed = Tiempo transcurrido (s)
about-webrtc-estimated-framerate = Velocidad de fotogramas estimada
about-webrtc-rotation-degrees = Rotación (grados)
about-webrtc-first-frame-timestamp = Marca de tiempo de recepción del primer fotograma
about-webrtc-last-frame-timestamp = Marca de tiempo de última recepción de fotograma

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = Receptor local SSRC
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = Envío remoto SSRC

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = Proporcionado
# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = No porporcionado
# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = Preferencias de WebRTC establecidas por el usuario
# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = Ancho de banda estimado
# The ID of the MediaStreamTrack
about-webrtc-track-identifier = Identificador de rastreo
# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = Ancho de banda de envío (bytes/seg)
# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = Ancho de banda de recepción (bytes/seg)
# Maximum number of bytes per second that will be padding zeros at the ends of packets
about-webrtc-max-padding-bytes-sec = Padding máximo (bytes/seg)
# The amount of time inserted between packets to keep them spaced out
about-webrtc-pacer-delay-ms = Intervalo entre paquetes (ms)
# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = Tiempo de ida y vuelta (RTT) (ms)
# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = Estadísticas de fotogramas de vídeo: ID de MediaStreamTrack: { $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = página guardada como: { $path }
about-webrtc-debug-mode-off-state-msg = el registro de traza se puede encontrar en: { $path }
about-webrtc-debug-mode-on-state-msg = modo de depuración activo, registro de traza en: { $path }
about-webrtc-aec-logging-off-state-msg = los archivos de registro se pueden encontrar en: { $path }

##

# This is the total number of packets received on the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets received.
about-webrtc-received-label =
    { $packets ->
        [one] { $packets } paquete recibido
       *[other] { $packets } paquetes recibidos
    }
# This is the total number of packets lost by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets lost.
about-webrtc-lost-label =
    { $packets ->
        [one] { $packets } paquete perdido
       *[other] { $packets } paquetes perdidos
    }
# This is the total number of packets sent by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets sent.
about-webrtc-sent-label =
    { $packets ->
        [one] { $packets } paquete enviado
       *[other] { $packets } paquetes enviados
    }
# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = Jitter { $jitter }
# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = Candidatos entrantes (llegando tras la respuesta) son destacados en azul

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = Establecer SDP local con timestamp { NUMBER($timestamp, useGrouping: "false") }
# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = Establecer SDP remoto con timestamp { NUMBER($timestamp, useGrouping: "false") }
# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = Marca de tiempo { NUMBER($timestamp, useGrouping: "false") } (+ { $relative-timestamp } ms)

##

