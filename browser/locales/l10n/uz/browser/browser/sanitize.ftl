# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Tarixni tozalash uchun sozlamalar
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = So‘nggi tarixni tozalash
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Barcha tarixni tozalash
    .style = width: 34em

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Tozalash uchun vaqt oralig‘i{ " " }
    .accesskey = t

clear-time-duration-value-last-hour =
    .label = O‘tgan soatda

clear-time-duration-value-last-2-hours =
    .label = So‘nggi ikki soatda

clear-time-duration-value-last-4-hours =
    .label = So‘nggi to‘rt soatda

clear-time-duration-value-today =
    .label = Bugun

clear-time-duration-value-everything =
    .label = Hammasi

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Tarix

item-history-and-downloads =
    .label = Ko‘rish va yuklab olish tarixi
    .accesskey = K

item-cookies =
    .label = Kukilar
    .accesskey = K

item-active-logins =
    .label = Faol loginlar
    .accesskey = l

item-cache =
    .label = Kesh
    .accesskey = e

item-form-search-history =
    .label = Shakl va izlash tarixi
    .accesskey = S

data-section-label = Ma’lumot

item-site-preferences =
    .label = Saytni moslash
    .accesskey = S

item-offline-apps =
    .label = Oflayn vebsahifa ma’lumotlari
    .accesskey = O

sanitize-everything-undo-warning = Ushbu amalni orqaga qaytarib bo‘lmaydi.

window-close =
    .key = w

sanitize-button-ok =
    .label = Hozir tozalash

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Tozalanmoqda

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Barcha tarix o‘chiriladi.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Barcha belgilangan bandlar tozalanadi.
