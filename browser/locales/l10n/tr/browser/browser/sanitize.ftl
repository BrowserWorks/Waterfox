# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Geçmiş temizleme ayarları
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Yakın geçmişi temizle
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Tüm geçmişi sil
    .style = width: 34em

clear-data-settings-label = { -brand-short-name } kapatıldığında tümünü kendiliğinden temizlemeli

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Temizlenecek zaman aralığı:{ " " }
    .accesskey = m

clear-time-duration-value-last-hour =
    .label = Son bir saat

clear-time-duration-value-last-2-hours =
    .label = Son iki saat

clear-time-duration-value-last-4-hours =
    .label = Son dört saat

clear-time-duration-value-today =
    .label = Bugün

clear-time-duration-value-everything =
    .label = Her şey

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Geçmiş

item-history-and-downloads =
    .label = Gezinti ve indirme geçmişi
    .accesskey = T

item-cookies =
    .label = Çerezler
    .accesskey = z

item-active-logins =
    .label = Etkin oturumlar
    .accesskey = o

item-cache =
    .label = Önbellek
    .accesskey = n

item-form-search-history =
    .label = Form ve arama geçmişi
    .accesskey = F

data-section-label = Veri

item-site-preferences =
    .label = Site tercihleri
    .accesskey = e

item-offline-apps =
    .label = Çevrimdışı site verileri
    .accesskey = s

sanitize-everything-undo-warning = Bu işlem geri alınamaz.

window-close =
    .key = w

sanitize-button-ok =
    .label = Şimdi temizle

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Temizleniyor

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Tüm geçmiş silinecek.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Tüm seçili nesneler temizlenecektir.
