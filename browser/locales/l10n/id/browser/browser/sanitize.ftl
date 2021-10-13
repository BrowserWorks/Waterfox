# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Pengaturan untuk Menghapus Riwayat
    .style = width: 36em

sanitize-prefs-style =
    .style = width: 18em

dialog-title =
    .title = Bersihkan Riwayat Terakhir
    .style = width: 36em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Bersihkan Semua Riwayat
    .style = width: 36em

clear-data-settings-label = Saat ditutup, secara otomatis { -brand-short-name } akan membersihkan semua data

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Jangka waktu riwayat untuk dibersihkan:{ " " }
    .accesskey = J

clear-time-duration-value-last-hour =
    .label = 1 Jam Terakhir

clear-time-duration-value-last-2-hours =
    .label = 2 Jam Terakhir

clear-time-duration-value-last-4-hours =
    .label = 4 Jam Terakhir

clear-time-duration-value-today =
    .label = Hari Ini

clear-time-duration-value-everything =
    .label = Semuanya

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Riwayat

item-history-and-downloads =
    .label = Riwayat Penjelajahan dan Unduhan
    .accesskey = R

item-cookies =
    .label = Kuki
    .accesskey = K

item-active-logins =
    .label = Log-Masuk Aktif
    .accesskey = L

item-cache =
    .label = Tembolok
    .accesskey = T

item-form-search-history =
    .label = Riwayat Pencarian dan Isian Form
    .accesskey = F

data-section-label = Data

item-site-preferences =
    .label = Pengaturan Situs Tertentu
    .accesskey = S

item-offline-apps =
    .label = Data Situs Web Luring
    .accesskey = L

sanitize-everything-undo-warning = Melakukan aksi ini menyebabkan data riwayat yang telah dihapus tidak dapat dikembalikan.

window-close =
    .key = w

sanitize-button-ok =
    .label = Bersihkan Sekarang

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Membersihkan

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Semua riwayat akan dihapus.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Item yang dipilih akan dibersihkan.
