# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Tetapan untuk Buang Sejarah
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Buang Sejarah Terkini
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Buang Semua Sejarah
    .style = width: 34em

clear-data-settings-label = Apabila ditutup, { -brand-short-name } buang semua secara automatik

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Julat masa untuk menghapuskan:{ " " }
    .accesskey = J

clear-time-duration-value-last-hour =
    .label = Satu Jam Lepas

clear-time-duration-value-last-2-hours =
    .label = Dua Jam Lepas

clear-time-duration-value-last-4-hours =
    .label = Empat Jam Lepas

clear-time-duration-value-today =
    .label = Hari ini

clear-time-duration-value-everything =
    .label = Semua

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Sejarah

item-history-and-downloads =
    .label = Sejarah Pelayaran & Muat Turun
    .accesskey = M

item-cookies =
    .label = Kuki
    .accesskey = K

item-active-logins =
    .label = Log masuk Aktif
    .accesskey = L

item-cache =
    .label = Cache
    .accesskey = A

item-form-search-history =
    .label = Borang & Sejarah Carian
    .accesskey = B

data-section-label = Data

item-site-preferences =
    .label = Keutamaan Laman
    .accesskey = K

item-offline-apps =
    .label = Data Laman web Luar talian
    .accesskey = D

sanitize-everything-undo-warning = Tindakan ini tidak boleh dibatalkan.

window-close =
    .key = w

sanitize-button-ok =
    .label = Buang Sekarang

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Membuang

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Semua sejarah akan dibuang.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Semua item terpilih akan dibuang.
