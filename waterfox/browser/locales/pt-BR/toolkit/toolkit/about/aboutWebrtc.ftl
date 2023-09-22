# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = Informações internas do WebRTC
# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = salvar página about:webrtc como

## These labels are for a disclosure which contains the information for closed PeerConnection sections

about-webrtc-closed-peerconnection-disclosure-show-msg = Exibir PeerConnections fechadas
about-webrtc-closed-peerconnection-disclosure-hide-msg = Ocultar PeerConnections fechadas

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = Registro AEC
about-webrtc-aec-logging-off-state-label = Iniciar registro AEC
about-webrtc-aec-logging-on-state-label = Parar registro AEC
about-webrtc-aec-logging-on-state-msg = Registro AEC ativo (fale com o remetente da chamada durante alguns minutos e depois pare a captura)
about-webrtc-aec-logging-toggled-on-state-msg = Registro AEC ativo (fale com o remetente da chamada durante alguns minutos e depois pare a captura)
about-webrtc-aec-logging-unavailable-sandbox = A variável de ambiente MOZ_DISABLE_CONTENT_SANDBOX=1 é necessária para exportar logs de AEC (cancelamento de eco acústico). Só defina esta variável se você entender os possíveis riscos.
# Variables:
#  $path (String) - The path to which the aec log file is saved.
about-webrtc-aec-logging-toggled-off-state-msg = Arquivos de log capturados podem ser encontradas em: { $path }

##

# The autorefresh checkbox causes a stats section to autorefresh its content when checked
about-webrtc-auto-refresh-label = Atualizar automaticamente
# Determines the default state of the Auto Refresh check boxes
about-webrtc-auto-refresh-default-label = Atualização automática por padrão
# A button which forces a refresh of displayed statistics
about-webrtc-force-refresh-button = Atualizar
# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = ID PeerConnection:
# The number of DataChannels that a PeerConnection has opened
about-webrtc-data-channels-opened-label = Canais de dados abertos:
# The number of once open DataChannels that a PeerConnection has closed
about-webrtc-data-channels-closed-label = Canais de dados fechados:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = SDP local
about-webrtc-local-sdp-heading-offer = SDP local (oferta)
about-webrtc-local-sdp-heading-answer = SDP local (resposta)
about-webrtc-remote-sdp-heading = SDP remoto
about-webrtc-remote-sdp-heading-offer = SDP remoto (oferta)
about-webrtc-remote-sdp-heading-answer = SDP remoto (resposta)
about-webrtc-sdp-history-heading = Histórico SDP
about-webrtc-sdp-parsing-errors-heading = Erros de parsing de SDP

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = Estatística RTP

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = Estado ICE
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = Estatísticas ICE
about-webrtc-ice-restart-count-label = Reinícios ICE:
about-webrtc-ice-rollback-count-label = Reversões ICE:
about-webrtc-ice-pair-bytes-sent = Bytes enviados:
about-webrtc-ice-pair-bytes-received = Bytes recebidos:
about-webrtc-ice-component-id = ID do componente

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
about-webrtc-save-page-label = Salvar página
about-webrtc-debug-mode-msg-label = Modo de depuração
about-webrtc-debug-mode-off-state-label = Iniciar modo de depuração
about-webrtc-debug-mode-on-state-label = Parar modo de depuração
about-webrtc-enable-logging-label = Ativar predefinição de log de WebRTC
about-webrtc-stats-heading = Estatísticas da sessão
about-webrtc-stats-clear = Limpar histórico
about-webrtc-log-heading = Registro de conexão
about-webrtc-log-clear = Limpar registro
about-webrtc-log-show-msg = mostrar registro
    .title = clique para expandir esta seção
about-webrtc-log-hide-msg = ocultar registro
    .title = clique para recolher esta seção
about-webrtc-log-section-show-msg = Mostrar registro
    .title = Clique para expandir esta seção
about-webrtc-log-section-hide-msg = Ocultar registro
    .title = Clique para recolher esta seção
about-webrtc-copy-report-button = Copiar relatório
about-webrtc-copy-report-history-button = Copiar histórico de relatórios

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (fechado) { $now }

## These are used to indicate what direction media is flowing.
## Variables:
##  $codecs - a list of media codecs

about-webrtc-short-send-receive-direction = Envio/recebimento: { $codecs }
about-webrtc-short-send-direction = Envio: { $codecs }
about-webrtc-short-receive-direction = Recebimento: { $codecs }

##

about-webrtc-local-candidate = Candidato local
about-webrtc-remote-candidate = Candidato remoto
about-webrtc-raw-candidates-heading = Todos os candidatos brutos
about-webrtc-raw-local-candidate = Candidato local bruto
about-webrtc-raw-remote-candidate = Candidato remoto bruto
about-webrtc-raw-cand-show-msg = mostrar candidatos brutos
    .title = clique para expandir esta seção
about-webrtc-raw-cand-hide-msg = ocultar candidatos brutos
    .title = clique para recolher esta seção
about-webrtc-raw-cand-section-show-msg = Mostrar candidatos brutos
    .title = Clique para expandir esta seção
about-webrtc-raw-cand-section-hide-msg = Ocultar candidatos brutos
    .title = Clique para recolher esta seção
about-webrtc-priority = Prioridade
about-webrtc-fold-show-msg = mostrar detalhes
    .title = clique para expandir esta seção
about-webrtc-fold-hide-msg = ocultar detalhes
    .title = clique para recolher esta seção
about-webrtc-fold-default-show-msg = Mostrar detalhes
    .title = Clique para expandir esta seção
about-webrtc-fold-default-hide-msg = Ocultar detalhes
    .title = Clique para recolher esta seção
about-webrtc-dropped-frames-label = Quadros perdidos:
about-webrtc-discarded-packets-label = Pacotes descartados:
about-webrtc-decoder-label = Decodificador
about-webrtc-encoder-label = Codificador
about-webrtc-show-tab-label = Exibir aba
about-webrtc-current-framerate-label = Taxa de quadros
about-webrtc-width-px = Largura (px)
about-webrtc-height-px = Altura (px)
about-webrtc-consecutive-frames = Quadros consecutivos
about-webrtc-time-elapsed = Tempo decorrido (s)
about-webrtc-estimated-framerate = Taxa de quadros estimada
about-webrtc-rotation-degrees = Rotação (graus)
about-webrtc-first-frame-timestamp = Estampa de tempo da recepção do primeiro quadro
about-webrtc-last-frame-timestamp = Estampa de tempo da recepção do último quadro

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = SSRC de recebimento local
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = SSRC de envio remoto

## These are displayed on the button that shows or hides the
## PeerConnection configuration disclosure

about-webrtc-pc-configuration-show-msg = Mostrar configuração
about-webrtc-pc-configuration-hide-msg = Ocultar configuração

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = Fornecido
# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = Não fornecido
# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = Preferências de WebRTC definidas pelo usuário
# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = Largura de banda estimada
# The ID of the MediaStreamTrack
about-webrtc-track-identifier = Identificador de faixa
# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = Largura de banda de envio (bytes/seg)
# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = Largura de banda de recebimento (bytes/seg)
# Maximum number of bytes per second that will be padding zeros at the ends of packets
about-webrtc-max-padding-bytes-sec = Máximo preenchimento de pacotes (bytes/seg)
# The amount of time inserted between packets to keep them spaced out
about-webrtc-pacer-delay-ms = Intervalo entre pacotes (ms)
# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = Tempo de ida e volta (RTT) (ms)
# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = Estatísticas de quadros de vídeo - ID de MediaStreamTrack: { $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = página salva em: { $path }
about-webrtc-debug-mode-off-state-msg = o registro de acompanhamento pode ser encontrado em: { $path }
about-webrtc-debug-mode-on-state-msg = modo de depuração ativo, registro de execução em: { $path }
about-webrtc-aec-logging-off-state-msg = arquivos de log capturados podem ser encontradas em: { $path }
# This path is used for saving the about:webrtc page so it can be attached to
# bug reports.
# Variables:
#  $path (String) - The path to which the file is saved.
about-webrtc-save-page-complete-msg = Página salva em: { $path }
about-webrtc-debug-mode-toggled-off-state-msg = O registro de acompanhamento pode ser encontrado em: { $path }
about-webrtc-debug-mode-toggled-on-state-msg = Modo de depuração ativo, registro de execução em: { $path }
# This is the total number of frames encoded or decoded over an RTP stream.
# Variables:
#  $frames (Number) - The number of frames encoded or decoded.
about-webrtc-frames =
    { $frames ->
        [one] { $frames } frame
       *[other] { $frames } frames
    }
# This is the number of audio channels encoded or decoded over an RTP stream.
# Variables:
#  $channels (Number) - The number of channels encoded or decoded.
about-webrtc-channels =
    { $channels ->
        [one] { $channels } canal
       *[other] { $channels } canais
    }
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
about-webrtc-trickle-caption-msg = Candidatos trickled (a chegar depois da resposta) são destacados em azul

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = Definir SDP local na estampa de tempo { NUMBER($timestamp, useGrouping: "false") }
# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = Definir SDP remoto na estampa de tempo { NUMBER($timestamp, useGrouping: "false") }
# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = Timestamp { NUMBER($timestamp, useGrouping: "false") } (+ { $relative-timestamp } ms)

## These are displayed on the button that shows or hides the SDP information disclosure

about-webrtc-show-msg-sdp = Mostrar SDP
about-webrtc-hide-msg-sdp = Ocultar SDP

## These are displayed on the button that shows or hides the Media Context information disclosure.
## The Media Context is the set of preferences and detected capabilities that informs
## the negotiated CODEC settings.

about-webrtc-media-context-show-msg = Exibir contexto de mídia
about-webrtc-media-context-hide-msg = Ocultar contexto de mídia
about-webrtc-media-context-heading = Contexto de mídia

##


##

