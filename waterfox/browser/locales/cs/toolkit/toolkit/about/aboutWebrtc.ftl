# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = Interní WebRTC
# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = uložit about:webrtc jako

## These labels are for a disclosure which contains the information for closed PeerConnection sections

about-webrtc-closed-peerconnection-disclosure-show-msg = Zobrazit uzavřená PeerConnections
about-webrtc-closed-peerconnection-disclosure-hide-msg = Skrýt uzavřená PeerConnections

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = Protokol AEC
about-webrtc-aec-logging-off-state-label = Spustit protokol AEC
about-webrtc-aec-logging-on-state-label = Zastavit protokol AEC
about-webrtc-aec-logging-on-state-msg = Protokol AEC je aktivní (hovořte s volajícím pár minut, a pak zastavte sběr)
about-webrtc-aec-logging-toggled-on-state-msg = Protokol AEC je aktivní (hovořte s volajícím pár minut, a pak zastavte sběr)
about-webrtc-aec-logging-unavailable-sandbox = Proměnná prostředí MOZ_DISABLE_CONTENT_SANDBOX=1 je pro export protokolů AEC vyžadována. Tuto proměnnou nastavte pouze v případě, že si uvědomujete možná rizika.
# Variables:
#  $path (String) - The path to which the aec log file is saved.
about-webrtc-aec-logging-toggled-off-state-msg = Soubory sběru protokolu můžete nalézt v: { $path }

##

# The autorefresh checkbox causes a stats section to autorefresh its content when checked
about-webrtc-auto-refresh-label = Automatické opětovné načtení
# Determines the default state of the Auto Refresh check boxes
about-webrtc-auto-refresh-default-label = Automaticky obnovovat
# A button which forces a refresh of displayed statistics
about-webrtc-force-refresh-button = Obnovit
# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = PeerConnection ID:
# The number of DataChannels that a PeerConnection has opened
about-webrtc-data-channels-opened-label = Otevřené datové kanály:
# The number of once open DataChannels that a PeerConnection has closed
about-webrtc-data-channels-closed-label = Zavřené datové kanály:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = Místní SDP
about-webrtc-local-sdp-heading-offer = Místní SDP (Offer)
about-webrtc-local-sdp-heading-answer = Místní SDP (Answer)
about-webrtc-remote-sdp-heading = Vzdálené SDP
about-webrtc-remote-sdp-heading-offer = Vzdálené SDP (Offer)
about-webrtc-remote-sdp-heading-answer = Vzdálené SDP (Answer)
about-webrtc-sdp-history-heading = Historie SDP
about-webrtc-sdp-parsing-errors-heading = Chyby parsování SDP

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = Statistika RTP

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = Stav ICE
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = Statistika ICE
about-webrtc-ice-restart-count-label = Restarty ICE:
about-webrtc-ice-rollback-count-label = Rollbacky ICE:
about-webrtc-ice-pair-bytes-sent = Odesláno bajtů:
about-webrtc-ice-pair-bytes-received = Staženo bajtů:
about-webrtc-ice-component-id = ID komponenty

## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = místní
about-webrtc-type-remote = vzdálené

##

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = Nominováno
# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = Vybráno
about-webrtc-save-page-label = Uložit stránku
about-webrtc-debug-mode-msg-label = Režim ladění
about-webrtc-debug-mode-off-state-label = Spustit režim ladění
about-webrtc-debug-mode-on-state-label = Zastavit režim ladění
about-webrtc-enable-logging-label = Povolit protokolování WebRTC
about-webrtc-stats-heading = Statistiky relace
about-webrtc-stats-clear = Vymazat historii
about-webrtc-log-heading = Protokol připojení
about-webrtc-log-clear = Vymazat protokol
about-webrtc-log-show-msg = zobrazit protokol
    .title = klepněte pro rozbalení této sekce
about-webrtc-log-hide-msg = skrýt protokol
    .title = klepněte pro zabalení této sekce
about-webrtc-log-section-show-msg = Zobrazit protokol
    .title = Klepněte pro rozbalení této sekce
about-webrtc-log-section-hide-msg = Skrýt protokol
    .title = Klepněte pro zabalení této sekce
about-webrtc-copy-report-button = Kopírovat hlášení
about-webrtc-copy-report-history-button = Kopírovat historii hlášení

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (uzavřeno) { $now }

## These are used to indicate what direction media is flowing.
## Variables:
##  $codecs - a list of media codecs

about-webrtc-short-send-receive-direction = Odesílání/přijímání: { $codecs }
about-webrtc-short-send-direction = Odesílání: { $codecs }
about-webrtc-short-receive-direction = Přijímání: { $codecs }

##

about-webrtc-local-candidate = Místní kandidát
about-webrtc-remote-candidate = Vzdálený kandidát
about-webrtc-raw-candidates-heading = All Raw Candidates
about-webrtc-raw-local-candidate = Raw Local Candidate
about-webrtc-raw-remote-candidate = Raw Remote Candidate
about-webrtc-raw-cand-show-msg = zobrazit raw candidates
    .title = klepněte pro rozbalení této sekce
about-webrtc-raw-cand-hide-msg = skrýt raw candidates
    .title = klepněte pro zabalení této sekce
about-webrtc-raw-cand-section-show-msg = Zobrazit raw candidates
    .title = Klepněte pro rozbalení této sekce
about-webrtc-raw-cand-section-hide-msg = Skrýt raw candidates
    .title = Klepněte pro zabalení této sekce
about-webrtc-priority = Priorita
about-webrtc-fold-show-msg = zobrazit detaily
    .title = klepněte pro rozbalení této sekce
about-webrtc-fold-hide-msg = skrýt detaily
    .title = klepněte pro zabalení této sekce
about-webrtc-fold-default-show-msg = Zobrazit detaily
    .title = Klepněte pro rozbalení této sekce
about-webrtc-fold-default-hide-msg = Skrýt detaily
    .title = Klepněte pro zabalení této sekce
about-webrtc-dropped-frames-label = Vynecháno snímků:
about-webrtc-discarded-packets-label = Zahozeno paketů:
about-webrtc-decoder-label = Dekodér
about-webrtc-encoder-label = Kodér
about-webrtc-show-tab-label = Zobrazit panel
about-webrtc-current-framerate-label = Frekvence snímků
about-webrtc-width-px = Šířka (px)
about-webrtc-height-px = Výška (px)
about-webrtc-consecutive-frames = Po sobě jdoucí snímky
about-webrtc-time-elapsed = Uplynulý čas (s)
about-webrtc-estimated-framerate = Odhadovaná frekvence snímků
about-webrtc-rotation-degrees = Otočení (stupně)
about-webrtc-first-frame-timestamp = Časová značka prvního zaznamenaného snímku
about-webrtc-last-frame-timestamp = Časová značka posledního zaznamenaného snímku

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = Místní příchozí SSRC
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = Vzdálené odchozí SSRC

## These are displayed on the button that shows or hides the
## PeerConnection configuration disclosure

about-webrtc-pc-configuration-show-msg = Zobrazit konfiguraci
about-webrtc-pc-configuration-hide-msg = Skrýt konfiguraci

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = Poskytnuto
# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = Neposkytnuto
# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = Uživatelská nastavení WebRTC
# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = Odhadovaná šířka pásma
# The ID of the MediaStreamTrack
about-webrtc-track-identifier = Identifikátor stopy
# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = Šířka pásma pro odesílání (bajty/s)
# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = Šířka pásma pro příjem (bajty/s)
# Maximum number of bytes per second that will be padding zeros at the ends of packets
about-webrtc-max-padding-bytes-sec = Maximální výplň (bajty/s)
# The amount of time inserted between packets to keep them spaced out
about-webrtc-pacer-delay-ms = Zpoždění mezi pakety (ms)
# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = RTT ms
# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = Statistiky video snímků - MediaStreamTrack ID: { $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = stránka uložena do: { $path }
about-webrtc-debug-mode-off-state-msg = trasu protokolu lze nalézt na adrese: { $path }
about-webrtc-debug-mode-on-state-msg = režim ladění aktivní, protokol v: { $path }
about-webrtc-aec-logging-off-state-msg = soubory sběru protokolu můžete nalézt v: { $path }
# This path is used for saving the about:webrtc page so it can be attached to
# bug reports.
# Variables:
#  $path (String) - The path to which the file is saved.
about-webrtc-save-page-complete-msg = Stránka uložena do: { $path }
about-webrtc-debug-mode-toggled-off-state-msg = Trasu protokolu lze nalézt na adrese: { $path }
about-webrtc-debug-mode-toggled-on-state-msg = Režim ladění aktivní, protokol v: { $path }
# This is the total number of frames encoded or decoded over an RTP stream.
# Variables:
#  $frames (Number) - The number of frames encoded or decoded.
about-webrtc-frames =
    { $frames ->
        [one] { $frames } snímek
        [few] { $frames } snímky
       *[other] { $frames } snímků
    }
# This is the number of audio channels encoded or decoded over an RTP stream.
# Variables:
#  $channels (Number) - The number of channels encoded or decoded.
about-webrtc-channels =
    { $channels ->
        [one] { $channels } kanál
        [few] { $channels } kanály
       *[other] { $channels } kanálů
    }
# This is the total number of packets received on the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets received.
about-webrtc-received-label =
    { $packets ->
        [one] Přijatý { $packets } paket
        [few] Přijaty { $packets } pakety
       *[other] Přijato { $packets } paketů
    }
# This is the total number of packets lost by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets lost.
about-webrtc-lost-label =
    { $packets ->
        [one] Ztracen { $packets } paket
        [few] Ztraceny { $packets } pakety
       *[other] Ztraceno { $packets } paketů
    }
# This is the total number of packets sent by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets sent.
about-webrtc-sent-label =
    { $packets ->
        [one] Odeslán { $packets } paket
        [few] Odeslány { $packets } pakety
       *[other] Odesláno { $packets } paketů
    }
# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = Jitter { $jitter }
# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = Trickled candidates (doručené po odpovědi) jsou zvýrazněni modře

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = Nastavit Local SDP v časové značce { NUMBER($timestamp, useGrouping: "false") }
# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = Nastavit Remote SDP v časové značce { NUMBER($timestamp, useGrouping: "false") }
# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = Časová značka { NUMBER($timestamp, useGrouping: "false") } (+ { $relative-timestamp } ms)

## These are displayed on the button that shows or hides the SDP information disclosure

about-webrtc-show-msg-sdp = Zobrazit SDP
about-webrtc-hide-msg-sdp = Skrýt SDP

## These are displayed on the button that shows or hides the Media Context information disclosure.
## The Media Context is the set of preferences and detected capabilities that informs
## the negotiated CODEC settings.

about-webrtc-media-context-show-msg = Zobrazit kontext médií
about-webrtc-media-context-hide-msg = Skrýt kontext médií
about-webrtc-media-context-heading = Informace o kontextu médií

##


##

