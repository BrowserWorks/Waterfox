# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = Informações internas do WebRTC
# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = guardar página about:webrtc como

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = Registo AEC
about-webrtc-aec-logging-off-state-label = Iniciar registo AEC
about-webrtc-aec-logging-on-state-label = Parar registo AEC
about-webrtc-aec-logging-on-state-msg = Registo AEC ativo (fale com o remetente da chamada durante alguns minutos e depois pare a captura)

##

# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = ID da ligação do par:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = SDP local
about-webrtc-local-sdp-heading-offer = SDP local (Oferta)
about-webrtc-local-sdp-heading-answer = SDP local (Resposta)
about-webrtc-remote-sdp-heading = SDP remoto
about-webrtc-remote-sdp-heading-offer = SDP remoto (Oferta)
about-webrtc-remote-sdp-heading-answer = SDP remoto (Resposta)
about-webrtc-sdp-history-heading = Histórico do SDP
about-webrtc-sdp-parsing-errors-heading = Erros de interpretação do SDP

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = Estatísticas RTP

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = Estado ICE
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = Estatísticas ICE
about-webrtc-ice-restart-count-label = Reinícios ICE:
about-webrtc-ice-rollback-count-label = Reversões ICE:
about-webrtc-ice-pair-bytes-sent = Bytes enviados:
about-webrtc-ice-pair-bytes-received = Bytes recebidos:
about-webrtc-ice-component-id = ID de componente

##


## "Avg." is an abbreviation for Average. These are used as data labels.

about-webrtc-avg-bitrate-label = Taxa de bits média:
about-webrtc-avg-framerate-label = Taxa de frames média:

##


## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = Local
about-webrtc-type-remote = Remoto

##

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = Nomeado
# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = Selecionado
about-webrtc-save-page-label = Guardar página
about-webrtc-debug-mode-msg-label = Modo de depuração
about-webrtc-debug-mode-off-state-label = Iniciar modo de depuração
about-webrtc-debug-mode-on-state-label = Parar modo de depuração
about-webrtc-stats-heading = Estatísticas da sessão
about-webrtc-stats-clear = Limpar histórico
about-webrtc-log-heading = Registo de ligação
about-webrtc-log-clear = Limpar registo
about-webrtc-log-show-msg = mostrar registo
    .title = clique para expandir esta secção
about-webrtc-log-hide-msg = ocultar registo
    .title = clique para colapsar esta secção

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (fechada) { $now }

##

about-webrtc-local-candidate = Candidato local
about-webrtc-remote-candidate = Candidato remoto
about-webrtc-raw-candidates-heading = Todos os candidatos em bruto
about-webrtc-raw-local-candidate = Candidato local em bruto
about-webrtc-raw-remote-candidate = Candidato remoto em bruto
about-webrtc-raw-cand-show-msg = mostrar candidatos em bruto
    .title = clique para expandir esta secção
about-webrtc-raw-cand-hide-msg = ocultar candidatos em bruto
    .title = clique para colapsar esta secção
about-webrtc-priority = Prioridade
about-webrtc-fold-show-msg = mostrar detalhes
    .title = clique para expandir esta secção
about-webrtc-fold-hide-msg = ocultar detalhes
    .title = clique para colapsar esta secção
about-webrtc-dropped-frames-label = Frames descartadas:
about-webrtc-discarded-packets-label = Pacotes descartados:
about-webrtc-decoder-label = Descodificador
about-webrtc-encoder-label = Codificado
about-webrtc-show-tab-label = Mostrar separador
about-webrtc-width-px = Largura (px)
about-webrtc-height-px = Altura (px)
about-webrtc-consecutive-frames = Frames consecutivos
about-webrtc-time-elapsed = Tempo decorrido
about-webrtc-estimated-framerate = Framerate estimado
about-webrtc-rotation-degrees = Rotação (graus)
about-webrtc-first-frame-timestamp = Data/hora da receção do primeiro frame
about-webrtc-last-frame-timestamp = Data/hora da receção do último frame

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = Local a receber SSRC
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = Envio remoto de SSRC

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = Fornecida
# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = Não fornecida
# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = Preferências do WebRTC definidas pelo utilizador
# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = Largura de banda estimada
# The ID of the MediaStreamTrack
about-webrtc-track-identifier = Identificador de faixa
# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = Largura de banda de envio (bytes/sec)
# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = Largura de banda de receção (bytes/sec)
# Maximum number of bytes per second that will be padding zeros at the ends of packets
about-webrtc-max-padding-bytes-sec = Preenchimento máximo (bytes/s)
# The amount of time inserted between packets to keep them spaced out
about-webrtc-pacer-delay-ms = Atraso em ms do regulador
# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = Tempo de ida e volta ms
# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = Estatísticas de frames de vídeo - ID do MediaStreamTrack: { $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = página guardada em: { $path }
about-webrtc-debug-mode-off-state-msg = o registo de execução pode ser encontrado em: { $path }
about-webrtc-debug-mode-on-state-msg = modo de depuração ativo, registo de rastreio em: { $path }
about-webrtc-aec-logging-off-state-msg = os ficheiros do registo da captura podem ser encontrados em: { $path }

##

# This is the total number of packets received on the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets received.
about-webrtc-received-label =
    { $packets ->
        [one] { $packets } pacote recebido
       *[other] { $packets } pacotes recebidos
    }
# This is the total number of packets lost by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets lost.
about-webrtc-lost-label =
    { $packets ->
        [one] { $packets } pacote perdido
       *[other] { $packets } pacotes perdidos
    }
# This is the total number of packets sent by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets sent.
about-webrtc-sent-label =
    { $packets ->
        [one] { $packets } pacote enviado
       *[other] { $packets } pacotes enviados
    }
# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = Jitter { $jitter }
# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = Candidatos trickled (a chegar depois da resposta) são destacados a azul

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = Definir SDP local na indicação { NUMBER($timestamp, useGrouping: "false") }
# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = Definir SDP remoto na indicação { NUMBER($timestamp, useGrouping: "false") }
# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = Marca de hora { NUMBER($timestamp, useGrouping: "false") } (+ { $relative-timestamp } ms)

##

