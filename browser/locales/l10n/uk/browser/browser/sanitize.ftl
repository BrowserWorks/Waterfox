# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Налаштування стирання історії
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Стерти недавню історію
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Стерти всю історію
    .style = width: 34em

clear-data-settings-label = При закритті { -brand-short-name } повинен автоматично стирати

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = За вказаний проміжок часу:{ " " }
    .accesskey = ч

clear-time-duration-value-last-hour =
    .label = останню годину

clear-time-duration-value-last-2-hours =
    .label = останні 2 години

clear-time-duration-value-last-4-hours =
    .label = останні 4 години

clear-time-duration-value-today =
    .label = за сьогодні

clear-time-duration-value-everything =
    .label = Усю

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Історія

item-history-and-downloads =
    .label = Історію переглядів та завантажень
    .accesskey = г

item-cookies =
    .label = Куки
    .accesskey = у

item-active-logins =
    .label = Активні сеанси
    .accesskey = с

item-cache =
    .label = Кеш
    .accesskey = к

item-form-search-history =
    .label = Форми та пошукові запити
    .accesskey = Ф

data-section-label = Дані

item-site-preferences =
    .label = Налаштування сайтів
    .accesskey = с

item-offline-apps =
    .label = Дані автономних вебсайтів
    .accesskey = а

sanitize-everything-undo-warning = Цю дію неможливо скасувати.

window-close =
    .key = w

sanitize-button-ok =
    .label = Стерти зараз

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Стирання

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Вся історія зітреться.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Всі вибрані елементи будуть стерті.
