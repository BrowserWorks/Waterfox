# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Настройки удаления истории
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Удаление недавней истории
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Удаление всей истории
    .style = width: 34em

clear-data-settings-label = При закрытии { -brand-short-name } должен автоматически удалять

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Удалить:
    .accesskey = т

clear-time-duration-value-last-hour =
    .label = За последний час

clear-time-duration-value-last-2-hours =
    .label = За последние два часа

clear-time-duration-value-last-4-hours =
    .label = За последние четыре часа

clear-time-duration-value-today =
    .label = За сегодня

clear-time-duration-value-everything =
    .label = Всё

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Историю

item-history-and-downloads =
    .label = Журнал посещений и загрузок
    .accesskey = п

item-cookies =
    .label = Куки
    .accesskey = у

item-active-logins =
    .label = Активные сеансы
    .accesskey = с

item-cache =
    .label = Кэш
    .accesskey = э

item-form-search-history =
    .label = Журнал форм и поиска
    .accesskey = ф

data-section-label = Данные

item-site-preferences =
    .label = Настройки сайтов
    .accesskey = о

item-site-settings =
    .label = Настройки сайтов
    .accesskey = о

item-offline-apps =
    .label = Данные автономных веб-сайтов
    .accesskey = н

sanitize-everything-undo-warning = Это действие нельзя отменить.

window-close =
    .key = w

sanitize-button-ok =
    .label = Удалить сейчас

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Удаление

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Вся история будет удалена.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Данные всех выделенных пунктов будут удалены.
