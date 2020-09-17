# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Tarixçə Təmizləmə Tənzimləmələri
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Yaxın Tarixçəni Təmizlə
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Bütün Tarixçəni Sil
    .style = width: 34em

clear-data-settings-label = Qapatıldığında { -brand-short-name } hər şeyi avtomatik silməlidir

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Təmizlənəcək zaman aralığı:{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = Son bir saat

clear-time-duration-value-last-2-hours =
    .label = Son iki saat

clear-time-duration-value-last-4-hours =
    .label = Son dörd saat

clear-time-duration-value-today =
    .label = Bugün

clear-time-duration-value-everything =
    .label = Hər şey

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Tarixçə

item-history-and-downloads =
    .label = Səyahət və Endirmə Tarixçəsi
    .accesskey = S

item-cookies =
    .label = Çərəzlər
    .accesskey = z

item-active-logins =
    .label = Aktiv girişlər
    .accesskey = l

item-cache =
    .label = Keş
    .accesskey = n

item-form-search-history =
    .label = Forma və Axtarış Tarixçəsi
    .accesskey = F

data-section-label = Verilən

item-site-preferences =
    .label = Sayt Nizamlamaları
    .accesskey = e

item-offline-apps =
    .label = Oflayn Websayt Məlumatları
    .accesskey = O

sanitize-everything-undo-warning = Bu əməliyyat geri qaytrıla bilməz.

window-close =
    .key = w

sanitize-button-ok =
    .label = İndi təmizlə

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Təmizlənir

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Bütün tarixçə silinəcək.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Bütün seçilən obyektlər təmizlənəcək.
