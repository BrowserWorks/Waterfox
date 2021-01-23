# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Поставке за брисање историјата
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Обриши историјат
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Обриши сав историјат
    .style = width: 34em

clear-data-settings-label = Када се затвори, { -brand-short-name } би требало аутоматски да обрише све

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Временски период за чишћење:{ " " }
    .accesskey = В

clear-time-duration-value-last-hour =
    .label = Последњи сат

clear-time-duration-value-last-2-hours =
    .label = Последња два сата

clear-time-duration-value-last-4-hours =
    .label = Последња четири сата

clear-time-duration-value-today =
    .label = Данас

clear-time-duration-value-everything =
    .label = Све

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Историјат

item-history-and-downloads =
    .label = Историјат читања и преузимања
    .accesskey = И

item-cookies =
    .label = Колачићи
    .accesskey = К

item-active-logins =
    .label = Активне пријаве
    .accesskey = А

item-cache =
    .label = Кеш
    .accesskey = ш

item-form-search-history =
    .label = Историјат формулара и претрага
    .accesskey = ф

data-section-label = Подаци

item-site-preferences =
    .label = Поставке за веб сајт
    .accesskey = П

item-offline-apps =
    .label = Примљене податке са сајтова
    .accesskey = П

sanitize-everything-undo-warning = Ова радња се не може опозвати.

window-close =
    .key = w

sanitize-button-ok =
    .label = Обриши сада

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Бришем

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Цео историјат ће бити обрисан.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Све изабране ставке ће бити уклоњене.
