# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Временски опсег за чистење:{ " " }
    .accesskey = В

clear-time-duration-value-last-hour =
    .label = последниот час

clear-time-duration-value-last-2-hours =
    .label = последните 2 часа

clear-time-duration-value-last-4-hours =
    .label = последните 4 часа

clear-time-duration-value-today =
    .label = денес

clear-time-duration-value-everything =
    .label = Сѐ

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Историја

item-history-and-downloads =
    .label = Историја на прелистување и преземања
    .accesskey = И

item-cookies =
    .label = Колачињата
    .accesskey = К

item-active-logins =
    .label = Активни пријави
    .accesskey = А

item-cache =
    .label = Кеш
    .accesskey = К

item-form-search-history =
    .label = Запамтените форми и пребарувања
    .accesskey = З

data-section-label = Податоци

item-site-preferences =
    .label = Поставки на местата
    .accesskey = с

item-offline-apps =
    .label = Локалните податоци за мрежни места
    .accesskey = о

sanitize-everything-undo-warning = Ова дејство не може да се одврати.

window-close =
    .key = w

sanitize-button-ok =
    .label = Исчисти веднаш

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Цела пребарувачка историја ќе биде избришана.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Сите селектирани предмети ќе се избришат.
