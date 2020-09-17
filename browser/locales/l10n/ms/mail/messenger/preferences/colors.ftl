# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Warna
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = Teks dan Latar Belakang

text-color-label =
    .value = Teks:
    .accesskey = T

background-color-label =
    .value = Latar belakang:
    .accesskey = L

use-system-colors =
    .label = Guna warna sistem
    .accesskey = s

colors-link-legend = Warna Pautan

link-color-label =
    .value = Pautan Belum Dilawati:
    .accesskey = P

visited-link-color-label =
    .value = Pautan Dilawati:
    .accesskey = D

underline-link-checkbox =
    .label = Garis bawah pautan
    .accesskey = G

override-color-label =
    .value = Gantikan warna yang telah ditetapkan oleh kandungan dengan pilihan saya di atas:
    .accesskey = G

override-color-always =
    .label = Sentiasa

override-color-auto =
    .label = Hanya dengan tema Kontras Tinggi

override-color-never =
    .label = Jangan sesekali
