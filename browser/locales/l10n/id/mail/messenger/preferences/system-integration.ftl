# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Integrasi dengan Sistem

system-integration-dialog =
    .buttonlabelaccept = Setel menjadi Baku
    .buttonlabelcancel = Lewatkan Integrasi
    .buttonlabelcancel2 = Batal

default-client-intro = Gunakan { -brand-short-name } sebagai program klien baku untuk:

unset-default-tooltip = Tidak mungkin membatalkan { -brand-short-name } sebagai klien tetap dalam { -brand-short-name }. Untuk menjadikan aplikasi lain baku, Anda harus menggunakan dialog 'Atur sebagai baku'.

checkbox-email-label =
    .label = Email
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Newsgroup
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Feed
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
    .label = Izinkan { system-search-engine-name } untuk mencari pesan
    .accesskey = I

check-on-startup-label =
    .label = Periksa selalu saat memulai { -brand-short-name }
    .accesskey = P
