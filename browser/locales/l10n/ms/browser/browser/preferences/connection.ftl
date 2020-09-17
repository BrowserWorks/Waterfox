# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Tetapan Sambungan
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Nyahdayakan Ekstensi

connection-proxy-configure = Tetapkan Akses Proksi ke Internet

connection-proxy-option-no =
    .label = Tiada proksi
    .accesskey = p
connection-proxy-option-system =
    .label = Guna tetapan proksi sistem
    .accesskey = u
connection-proxy-option-auto =
    .label = Auto-kesan tetapan proksi untuk rangkaian ini
    .accesskey = o
connection-proxy-option-manual =
    .label = Konfigurasi proksi manual
    .accesskey = m

connection-proxy-http = Proksi HTTP
    .accesskey = k
connection-proxy-http-port = Port
    .accesskey = P

connection-proxy-ssl-port = Port
    .accesskey = o

connection-proxy-ftp = Proksi FTP
    .accesskey = F
connection-proxy-ftp-port = Port
    .accesskey = r

connection-proxy-socks = Hos SOCKS
    .accesskey = C
connection-proxy-socks-port = Port
    .accesskey = t

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = Tiada proksi untuk
    .accesskey = n

connection-proxy-noproxy-desc = Contoh: .mozilla.org, .net.nz, 192.168.1.0/24

connection-proxy-autotype =
    .label = URL konfigurasi proksi automatik
    .accesskey = A

connection-proxy-reload =
    .label = Muat semula
    .accesskey = e

connection-proxy-autologin =
    .label = Jangan paparkan pengesahan jika kata laluan telah disimpan
    .accesskey = i
    .tooltip = Pilihan ini mengesahkan secara senyap apabila anda ada menyimpan kelayakan bagi pihak proksi. Tapi anda akan dimaklumkan jika pengesahan gagal.

connection-proxy-socks-remote-dns =
    .label = Proksi DNS apabila menggunakan SOCKS v5
    .accesskey = d

connection-dns-over-https =
    .label = Dayakan DNS mengatasi HTTPS
    .accesskey = D

connection-dns-over-https-url-custom =
    .label = Penyesuaian
    .accesskey = P
    .tooltiptext = Masukkan URL keutamaan untuk menyelesaikan DNS ke atas HTTPS

