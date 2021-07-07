# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for about:webrtc, a troubleshooting and diagnostic page
### for WebRTC calls. See https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API.

# The text "WebRTC" is a proper noun and should not be translated.
about-webrtc-document-title = Internal WebRTC

# "about:webrtc" is a internal browser URL and should not be
# translated. This string is used as a title for a file save dialog box.
about-webrtc-save-page-dialog-title = simpan about:webrtc dengan nama

## AEC is an abbreviation for Acoustic Echo Cancellation.

about-webrtc-aec-logging-msg-label = Log AEC
about-webrtc-aec-logging-off-state-label = Mulai Pencatatan AEC
about-webrtc-aec-logging-on-state-label = Hentikan Pencatatan AEC
about-webrtc-aec-logging-on-state-msg = Pencatatan AEC aktif (bicara dengan pemanggil selama beberapa menit lalu hentikan penangkapan)

##

# "PeerConnection" is a proper noun associated with the WebRTC module. "ID" is
# an abbreviation for Identifier. This string should not normally be translated
# and is used as a data label.
about-webrtc-peerconnection-id-label = ID PeerConnection:

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

about-webrtc-sdp-heading = SDP
about-webrtc-local-sdp-heading = SDP Lokal
about-webrtc-local-sdp-heading-offer = SDP Lokal (Penawaran)
about-webrtc-local-sdp-heading-answer = SDP Lokal (Jawab)
about-webrtc-remote-sdp-heading = SDP Jarak Jauh
about-webrtc-remote-sdp-heading-offer = SDP Jarak Jauh (Penawaran)
about-webrtc-remote-sdp-heading-answer = SDP Jarak Jauh (Jawab)
about-webrtc-sdp-history-heading = Riwayat SDP
about-webrtc-sdp-parsing-errors-heading = Kesalahan Parsing SDP

##

# "RTP" is an abbreviation for the Real-time Transport Protocol, an IETF
# specification, and should not normally be translated. "Stats" is an
# abbreviation for Statistics.
about-webrtc-rtp-stats-heading = Statistik RTP

## "ICE" is an abbreviation for Interactive Connectivity Establishment, which
## is an IETF protocol, and should not normally be translated.

about-webrtc-ice-state = Status ICE
# "Stats" is an abbreviation for Statistics.
about-webrtc-ice-stats-heading = Statistik ICE
about-webrtc-ice-restart-count-label = ICE dimuat ulang:
about-webrtc-ice-rollback-count-label = ICE diputar kembali:
about-webrtc-ice-pair-bytes-sent = Bita terkirim:
about-webrtc-ice-pair-bytes-received = Bita diterima:
about-webrtc-ice-component-id = ID komponen

## "Avg." is an abbreviation for Average. These are used as data labels.

about-webrtc-avg-bitrate-label = Bitrate rata-rata:
about-webrtc-avg-framerate-label = Framerate rata-rata:

## These adjectives are used to label a line of statistics collected for a peer
## connection. The data represents either the local or remote end of the
## connection.

about-webrtc-type-local = Lokal
about-webrtc-type-remote = Jarak Jauh

##


# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
about-webrtc-nominated = Dinominasikan

# This adjective is used to label a table column. Cells in this column contain
# the localized javascript string representation of "true" or are left blank.
# This represents an attribute of an ICE candidate.
about-webrtc-selected = Dipilih

about-webrtc-save-page-label = Simpan Laman
about-webrtc-debug-mode-msg-label = Mode Debug
about-webrtc-debug-mode-off-state-label = Mulai Mode Debug
about-webrtc-debug-mode-on-state-label = Hentikan Mode Debug
about-webrtc-stats-heading = Statistik Sesi
about-webrtc-stats-clear = Bersihkan Riwayat
about-webrtc-log-heading = Log Sambungan
about-webrtc-log-clear = Bersihkan Log
about-webrtc-log-show-msg = tampilkan log
    .title = klik untuk membentangkan bagian ini
about-webrtc-log-hide-msg = sembunyikan log
    .title = klik untuk menciutkan bagian ini

## These are used to display a header for a PeerConnection.
## Variables:
##  $browser-id (Number) - A numeric id identifying the browser tab for the PeerConnection.
##  $id (String) - A globally unique identifier for the PeerConnection.
##  $url (String) - The url of the site which opened the PeerConnection.
##  $now (Date) - The JavaScript timestamp at the time the report was generated.

about-webrtc-connection-open = [ { $browser-id } | { $id } ] { $url } { $now }
about-webrtc-connection-closed = [ { $browser-id } | { $id } ] { $url } (ditutup) { $now }

##


about-webrtc-local-candidate = Kandidat Lokal
about-webrtc-remote-candidate = Kandidat Jarak Jauh
about-webrtc-raw-candidates-heading = Semua Kandidat Mentah
about-webrtc-raw-local-candidate = Kandidat Lokal Mentah
about-webrtc-raw-remote-candidate = Kandidat Jarak Jauh Mentah
about-webrtc-raw-cand-show-msg = tampilkan kandidat mentah
    .title = klik untuk membentangkan bagian ini
about-webrtc-raw-cand-hide-msg = sembunyikan kandidat mentah
    .title = klik untuk menciutkan bagian ini
about-webrtc-priority = Prioritas
about-webrtc-fold-show-msg = tampilkan detail
    .title = klik untuk membentangkan bagian ini
about-webrtc-fold-hide-msg = sembunyikan detail
    .title = klik untuk menciutkan bagian ini
about-webrtc-dropped-frames-label = Frame yang dihilangkan:
about-webrtc-discarded-packets-label = Paket yang dibuang:
about-webrtc-decoder-label = Dekoder
about-webrtc-encoder-label = Enkoder
about-webrtc-show-tab-label = Tampilkan tab
about-webrtc-width-px = Lebar (px)
about-webrtc-height-px = Tinggi (px)
about-webrtc-consecutive-frames = Bingkai Berturutan
about-webrtc-time-elapsed = Waktu Berlalu (dtk)
about-webrtc-estimated-framerate = Perkiraan Framerate
about-webrtc-rotation-degrees = Rotasi (derajat)
about-webrtc-first-frame-timestamp = Stempel Waktu Penerimaan Frame Pertama
about-webrtc-last-frame-timestamp = Stempel Waktu Penerimaan Frame Terakhir

## SSRCs are identifiers that represent endpoints in an RTP stream

# This is an SSRC on the local side of the connection that is receiving RTP
about-webrtc-local-receive-ssrc = Penerimaan SSRC Lokal
# This is an SSRC on the remote side of the connection that is sending RTP
about-webrtc-remote-send-ssrc = Pengiriman SSRC Jarak Jauh

##

# An option whose value will not be displayed but instead noted as having been
# provided
about-webrtc-configuration-element-provided = Disediakan

# An option whose value will not be displayed but instead noted as having not
# been provided
about-webrtc-configuration-element-not-provided = Tidak Disediakan

# The options set by the user in about:config that could impact a WebRTC call
about-webrtc-custom-webrtc-configuration-heading = Preferensi WebRTC Diatur Pengguna

# Section header for estimated bandwidths of WebRTC media flows
about-webrtc-bandwidth-stats-heading = Perkiraan Bandwidth

# The ID of the MediaStreamTrack
about-webrtc-track-identifier = Pengenal Jalur

# The estimated bandwidth available for sending WebRTC media in bytes per second
about-webrtc-send-bandwidth-bytes-sec = Bandwidth Pengiriman (byte/detik)

# The estimated bandwidth available for receiving WebRTC media in bytes per second
about-webrtc-receive-bandwidth-bytes-sec = Bandwidth Penerimaan (byte/detik)

# Maximum number of bytes per second that will be padding zeros at the ends of packets
about-webrtc-max-padding-bytes-sec = Padding Maksimum (byte/detik)

# The amount of time inserted between packets to keep them spaced out
about-webrtc-pacer-delay-ms = Penundaan Pacer md

# The amount of time it takes for a packet to travel from the local machine to the remote machine,
# and then have a packet return
about-webrtc-round-trip-time-ms = RTT md

# This is a section heading for video frame statistics for a MediaStreamTrack.
# see https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamTrack.
# Variables:
#   $track-identifier (String) - The unique identifier for the MediaStreamTrack.
about-webrtc-frame-stats-heading = Statistik Frame Video - ID MediaStreamTrack: { $track-identifier }

## These are paths used for saving the about:webrtc page or log files so
## they can be attached to bug reports.
## Variables:
##  $path (String) - The path to which the file is saved.

about-webrtc-save-page-msg = halaman disimpan ke: { $path }
about-webrtc-debug-mode-off-state-msg = log pelacakan dapat ditemukan di: { $path }
about-webrtc-debug-mode-on-state-msg = mode debug aktif, log pelacakan di: { $path }
about-webrtc-aec-logging-off-state-msg = berkas log tangkapan dapat ditemukan di: { $path }

##

# This is the total number of packets received on the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets received.
about-webrtc-received-label =
    { $packets ->
       *[other] { $packets } paket diterima
    }

# This is the total number of packets lost by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets lost.
about-webrtc-lost-label =
    { $packets ->
       *[other] { $packets } paket hilang
    }

# This is the total number of packets sent by the PeerConnection.
# Variables:
#  $packets (Number) - The number of packets sent.
about-webrtc-sent-label =
    { $packets ->
       *[other] { $packets } paket dikirim
    }

# Jitter is the variance in the arrival time of packets.
# See: https://w3c.github.io/webrtc-stats/#dom-rtcreceivedrtpstreamstats-jitter
# Variables:
#   $jitter (Number) - The jitter.
about-webrtc-jitter-label = Jitter { $jitter }

# ICE candidates arriving after the remote answer arrives are considered trickled
# (an attribute of an ICE candidate). These are highlighted in the ICE stats
# table with light blue background.
about-webrtc-trickle-caption-msg = Hamburan kandidat (datang setelah jawaban) disorot warna biru

## "SDP" is an abbreviation for Session Description Protocol, an IETF standard.
## See http://wikipedia.org/wiki/Session_Description_Protocol

# This is used as a header for local SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-local = Setel SDP Lokal pada stempel waktu { NUMBER($timestamp, useGrouping: "false") }

# This is used as a header for remote SDP.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
about-webrtc-sdp-set-at-timestamp-remote = Setel SDP Jarak Jauh pada stempel waktu { NUMBER($timestamp, useGrouping: "false") }

# This is used as a header for an SDP section contained in two columns allowing for side-by-side comparisons.
# Variables:
#  $timestamp (Number) - The Unix Epoch time at which the SDP was set.
#  $relative-timestamp (Number) - The timestamp relative to the timestamp of the earliest received SDP.
about-webrtc-sdp-set-timestamp = Stempel waktu { NUMBER($timestamp, useGrouping: "false") } (+ { $relative-timestamp } md)

##

##

##

