# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = Внутренности WebRTC
# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = Сохранить about:webrtc как

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = Лог AEC
about-webrtc-aec-logging-off-state-label = Начать вести лог AEC
about-webrtc-aec-logging-on-state-label = Прекратить вести лог AEC
about-webrtc-aec-logging-on-state-msg = Ведение лога AEC включено (поговорите с абонентом в течение нескольких минут, а затем остановите захват)

##

# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = Идентификатор PeerConnection:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = Локальный SDP
about-webrtc-local-sdp-heading-offer = Локальный SDP (Предложение)
about-webrtc-local-sdp-heading-answer = Локальный SDP (Ответ)
about-webrtc-remote-sdp-heading = Удалённый SDP
about-webrtc-remote-sdp-heading-offer = Удалённый SDP (Предложение)
about-webrtc-remote-sdp-heading-answer = Удалённый SDP (Ответ)
about-webrtc-sdp-history-heading = История SDP
about-webrtc-sdp-parsing-errors-heading = Ошибки разбора SDP

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = Статистика RTP

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = Состояние ICE
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = Статистика ICE
about-webrtc-ice-restart-count-label = Перезапуски ICE:
about-webrtc-ice-rollback-count-label = Откаты ICE:
about-webrtc-ice-pair-bytes-sent = Байтов отправлено:
about-webrtc-ice-pair-bytes-received = Байтов получено:
about-webrtc-ice-component-id = Идентификатор компонента

##


## "Avg." is an abbreviation for Average. These are used as data labels.

about-webrtc-avg-bitrate-label = Средний битрейт:
about-webrtc-avg-framerate-label = Средняя частота кадров:

##


## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = Локальный
about-webrtc-type-remote = Удалённый

##

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = Номинировано
# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = Выбрано
about-webrtc-save-page-label = Сохранить страницу
about-webrtc-debug-mode-msg-label = Режим отладки
about-webrtc-debug-mode-off-state-label = Войти в режим отладки
about-webrtc-debug-mode-on-state-label = Выйти из режима отладки
about-webrtc-stats-heading = Статистика сессии
about-webrtc-stats-clear = Удалить историю
about-webrtc-log-heading = Лог соединения
about-webrtc-log-clear = Удалить лог
about-webrtc-log-show-msg = показать лог
    .title = щёлкните, чтобы развернуть этот раздел
about-webrtc-log-hide-msg = скрыть лог
    .title = щёлкните, чтобы свернуть этот раздел

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (закрыто) { $now }

##

about-webrtc-local-candidate = Локальный кандидат
about-webrtc-remote-candidate = Удалённый кандидат
about-webrtc-raw-candidates-heading = Все необработанные кандидаты
about-webrtc-raw-local-candidate = Необработанный локальный кандидат
about-webrtc-raw-remote-candidate = Необработанный удалённый кандидат
about-webrtc-raw-cand-show-msg = показать необработанных кандидатов
    .title = щёлкните, чтобы развернуть этот раздел
about-webrtc-raw-cand-hide-msg = скрыть необработанных кандидатов
    .title = щёлкните, чтобы свернуть этот раздел
about-webrtc-priority = Приоритет
about-webrtc-fold-show-msg = показать подробности
    .title = щёлкните, чтобы развернуть этот раздел
about-webrtc-fold-hide-msg = скрыть подробности
    .title = щёлкните, чтобы свернуть этот раздел
about-webrtc-dropped-frames-label = Пропущенные кадры:
about-webrtc-discarded-packets-label = Отброшенные пакеты:
about-webrtc-decoder-label = Декодер
about-webrtc-encoder-label = Кодировщик
about-webrtc-show-tab-label = Показать вкладку
about-webrtc-width-px = Ширина (px)
about-webrtc-height-px = Высота (px)
about-webrtc-consecutive-frames = Последовательные кадры
about-webrtc-time-elapsed = Затраченное время (с)
about-webrtc-estimated-framerate = Расчетная частота кадров
about-webrtc-rotation-degrees = Вращение (градусы)
about-webrtc-first-frame-timestamp = Метка времени приема первого кадра
about-webrtc-last-frame-timestamp = Метка времени приема последнего кадра

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = Локально принимающий SSRC
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = Удалённо отправляющий SSRC

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = Предоставлено
# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = Не предоставлено
# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = Пользовательские настройки WebRTC
# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = Расчетная пропускная способность
# The ID of the MediaStreamTrack
about-webrtc-track-identifier = Идентификатор трека
# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = Пропускная способность отправки (байт/сек)
# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = Пропускная способность приёма (байт/сек)
# Maximum number of bytes per second that will be padding zeros at the ends of packets
about-webrtc-max-padding-bytes-sec = Максимальное заполнение (байт/сек)
# The amount of time inserted between packets to keep them spaced out
about-webrtc-pacer-delay-ms = Задержка между пакетами (мс)
# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = RTT (мс)
# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = Статистика видеокадров - MediaStreamTrack ID: { $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = страница сохранена в: { $path }
about-webrtc-debug-mode-off-state-msg = лог трассировки можно найти в: { $path }
about-webrtc-debug-mode-on-state-msg = режим отладки активен, лог трассировки в: { $path }
about-webrtc-aec-logging-off-state-msg = файлы логов захвата можно найти в: { $path }

##

# This is the total number of packets received on the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets received.
about-webrtc-received-label =
    { $packets ->
        [one] Получен { $packets } пакет
        [few] Получено { $packets } пакета
       *[many] Получено { $packets } пакетов
    }
# This is the total number of packets lost by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets lost.
about-webrtc-lost-label =
    { $packets ->
        [one] Потерян { $packets } пакет
        [few] Потеряно { $packets } пакета
       *[many] Потеряно { $packets } пакетов
    }
# This is the total number of packets sent by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets sent.
about-webrtc-sent-label =
    { $packets ->
        [one] Отправлен { $packets } пакет
        [few] Отправлено { $packets } пакета
       *[many] Отправлено { $packets } пакетов
    }
# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = Джиттер { $jitter }
# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = Просочившиеся кандидаты (прибывшие после ответа) подсвечены синим

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = Установить Локальный SDP на метку времени { NUMBER($timestamp, useGrouping: "false") }
# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = Установить Удалённый SDP на метку времени { NUMBER($timestamp, useGrouping: "false") }
# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = Метка времени { NUMBER($timestamp, useGrouping: "false") } (+ { $relative-timestamp } мс)

##

