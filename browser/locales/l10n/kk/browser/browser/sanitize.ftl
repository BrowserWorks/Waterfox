# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Тарихты тазартуды баптау
    .style = width: 40em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Жуырдағы тарихты өшіру
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Бүкіл тарихты тазарту
    .style = width: 34em

clear-data-settings-label = { -brand-short-name } жабылған кезде, келесілерді автоөшіруі тиіс

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Жойылатын деректер мерзімі:{ " " }
    .accesskey = Ж

clear-time-duration-value-last-hour =
    .label = Соңғы сағат

clear-time-duration-value-last-2-hours =
    .label = Соңғы 2 сағат

clear-time-duration-value-last-4-hours =
    .label = Соңғы 4 сағат

clear-time-duration-value-today =
    .label = бүгінгі тарихымды

clear-time-duration-value-everything =
    .label = Барлығы

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Тарихы

item-history-and-downloads =
    .label = Қарап шығу және жүктемелер тарихы
    .accesskey = ш

item-cookies =
    .label = Cookies файлдары
    .accesskey = ф

item-active-logins =
    .label = Белсенді сеанстар
    .accesskey = Б

item-cache =
    .label = Кэш
    .accesskey = К

item-form-search-history =
    .label = Формалар және іздеу тарихы
    .accesskey = Ф

data-section-label = Мәліметтер

item-site-preferences =
    .label = Сайттар баптаулары
    .accesskey = С

item-offline-apps =
    .label = Дербес веб-сайттар деректері
    .accesskey = Д

sanitize-everything-undo-warning = Бұл әрекетті болдырмау мүмкін емес болады.

window-close =
    .key = w

sanitize-button-ok =
    .label = Қазір тазарту

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Тазарту

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Барлық тарих өшіріледі.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Барлық таңдалған нәрселер өшіріледі.
