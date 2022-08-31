# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = Свойства WebRTC

# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = сохранить about:webrtc как

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = Запись AEC
about-webrtc-aec-logging-off-state-label = Начать запись AEC
about-webrtc-aec-logging-on-state-label = Остановить запись AEC
about-webrtc-aec-logging-on-state-msg = Запись AEC ведётся (поговорите с абонентом несколько минут, а затем остановите захват)

# The autorefresh checkbox causes the page to autorefresh its content when checked
about-webrtc-auto-refresh-label = Автообновление

##

# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = PeerConnection ID:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = Локальный SDP
about-webrtc-local-sdp-heading-offer = Локальный SDP (Попытка)
about-webrtc-local-sdp-heading-answer = Локальный SDP (Ответ)
about-webrtc-remote-sdp-heading = Удалённый SDP
about-webrtc-remote-sdp-heading-offer = Удалённый SDP (Попытка)
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
about-webrtc-ice-component-id = ID компонента

## "Avg." is an abbreviation for Average. These are used as data labels.

## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = Локальный
about-webrtc-type-remote = Удалённый

##

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = Предложено

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
about-webrtc-log-heading = Журнал соединения
about-webrtc-log-clear = Удалить журнал
about-webrtc-log-show-msg = показать журнал
    .title = нажмите, чтобы развернуть этот раздел
about-webrtc-log-hide-msg = скрыть журнал
    .title = нажмите, чтобы свернуть этот раздел

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (закрыт) { $now }

##

about-webrtc-local-candidate = Локальный кандидат
about-webrtc-remote-candidate = Удалённый кандидат
about-webrtc-raw-candidates-heading = Все необработанные кандидаты
about-webrtc-raw-local-candidate = Необработанный локальный кандидат
about-webrtc-raw-remote-candidate = Необработанный удалённый кандидат
about-webrtc-raw-cand-show-msg = показать необработанных кандидатов
    .title = нажмите, чтобы развернуть этот раздел
about-webrtc-raw-cand-hide-msg = скрыть необработанных кандидатов
    .title = нажмите, чтобы свернуть этот раздел
about-webrtc-priority = Очерёдность
about-webrtc-fold-show-msg = показать подробности
    .title = нажмите, чтобы развернуть этот раздел
about-webrtc-fold-hide-msg = скрыть подробности
    .title = нажмите, чтобы свернуть этот раздел
about-webrtc-dropped-frames-label = Пропущенные кадры:
about-webrtc-discarded-packets-label = Отброшенные пакеты:
about-webrtc-decoder-label = Декодер
about-webrtc-encoder-label = Кодировщик
about-webrtc-show-tab-label = Показать вкладку
about-webrtc-current-framerate-label = Частота кадров
about-webrtc-width-px = Ширина (px)
about-webrtc-height-px = Высота (px)
about-webrtc-consecutive-frames = Последовательные кадры
about-webrtc-time-elapsed = Затраченное время (с)
about-webrtc-estimated-framerate = Расчётная частота кадров
about-webrtc-rotation-degrees = Вращение (градусы)
about-webrtc-first-frame-timestamp = Метка времени приёма первого кадра
about-webrtc-last-frame-timestamp = Метка времени приёма последнего кадра

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = SSRC локального приёма
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = SSRC удалённой отправки

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = Установлено

# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = Не установлено

# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = Пользовательские настройки WebRTC

# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = Расчётная пропускная способность

# The ID of the MediaStreamTrack
about-webrtc-track-identifier = Идентификатор отслеживания

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
about-webrtc-debug-mode-off-state-msg = журнал отслеживания можно найти в: { $path }
about-webrtc-debug-mode-on-state-msg = режим отладки активен, журнал отслеживания в: { $path }
about-webrtc-aec-logging-off-state-msg = файлы журнала захвата можно найти в: { $path }

##

# This is the total number of frames encoded or decoded over an RTP stream.
# Variables:
#  $frames (Number) - The number of frames encoded or decoded.
about-webrtc-frames =
    { $frames ->
        [one] { $frames } кадр
        [few] { $frames } кадра
       *[many] { $frames } кадров
    }

# This is the number of audio channels encoded or decoded over an RTP stream.
# Variables:
#  $channels (Number) - The number of channels encoded or decoded.
about-webrtc-channels =
    { $channels ->
        [one] { $channels } канал
        [few] { $channels } канала
       *[many] { $channels } каналов
    }

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
about-webrtc-trickle-caption-msg = Поток кандидатов (после ответа) подсвечен синим

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = Установить для локального SDP метку времени { NUMBER($timestamp, useGrouping: "false") }

# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = Установить для удалённого SDP метку времени { NUMBER($timestamp, useGrouping: "false") }

# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = Метка времени { NUMBER($timestamp, useGrouping: "false") } (+ { $relative-timestamp } мс)

##

