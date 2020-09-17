# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dialog-window =
    .title = Tetapan Sambungan
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }

connection-proxy-legend = Tetapkan Proksi untuk Mengakses Internet

proxy-type-no =
    .label = Tiada proksi
    .accesskey = i

proxy-type-wpad =
    .label = Auto-kesan tetapan proksi untuk rangkaian ini
    .accesskey = r

proxy-type-system =
    .label = Guna tetapan proksi sistem
    .accesskey = s

proxy-type-manual =
    .label = Konfigurasi proksi manual:
    .accesskey = m

proxy-http-label =
    .value = Proksi HTTP:
    .accesskey = s

http-port-label =
    .value = Port:
    .accesskey = p

ssl-port-label =
    .value = Port:
    .accesskey = o

proxy-socks-label =
    .value = Hos SOCKS:
    .accesskey = o

socks-port-label =
    .value = Port:
    .accesskey = t

proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = k

proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v

proxy-type-auto =
    .label = URL konfigurasi proksi automatik:
    .accesskey = K

proxy-reload-label =
    .label = Muat semula
    .accesskey = l

no-proxy-label =
    .value = Tiada Proksi untuk:
    .accesskey = n

no-proxy-example = Contoh: .mozilla.org, .net.nz, 192.168.1.0/24

proxy-password-prompt =
    .label = Jangan paparkan pengesahan jika kata laluan telah disimpan
    .accesskey = i
    .tooltiptext = Pilihan ini mengesahkan secara senyap apabila anda ada menyimpan kelayakan bagi pihak proksi. Tapi anda akan dimaklumkan jika pengesahan gagal.

proxy-remote-dns =
    .label = Proksi DNS apabila menggunakan SOCKS v5
    .accesskey = a

proxy-enable-doh =
    .label = Dayakan DNS mengatasi HTTPS
    .accesskey = y
