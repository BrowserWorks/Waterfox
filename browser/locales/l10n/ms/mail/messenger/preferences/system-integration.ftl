# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Integrasi Sistem

system-integration-dialog =
    .buttonlabelaccept = Tetapkan sebagai Piawai
    .buttonlabelcancel = Langkau Integrasi
    .buttonlabelcancel2 = Batal

default-client-intro = Guna { -brand-short-name } sebagai klien piawai untuk:

unset-default-tooltip = Tidak boleh membuang tetapan { -brand-short-name } sebagai klien piawai dari dalam { -brand-short-name }. Untuk menetapkan aplikasi lain sebagai piawai, anda perlu buat dari dalam dialog 'Tetapkan sebagai piawai'.

checkbox-email-label =
    .label = E-mel
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Kumpulan berita
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Suapan
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }

system-search-integration-label =
    .label = Izinkan { system-search-engine-name } mencari mesej
    .accesskey = I

check-on-startup-label =
    .label = Sentiasa semak apabila memulakan { -brand-short-name }
    .accesskey = S
