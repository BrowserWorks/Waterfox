# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Налады ачышчэння гісторыі
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Знішчэнне нядаўняй гісторыі
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Ачышчэнне ўсёй гісторыі
    .style = width: 34em

clear-data-settings-label = Пры закрыцці { -brand-short-name } павінен аўтаматычна ачышчаць усё

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Дыяпазон часу для ачышчэння:
    .accesskey = ч

clear-time-duration-value-last-hour =
    .label = Апошняя гадзіна

clear-time-duration-value-last-2-hours =
    .label = Апошнія дзве гадзіны

clear-time-duration-value-last-4-hours =
    .label = Апошнія чатыры гадзіны

clear-time-duration-value-today =
    .label = Сёння

clear-time-duration-value-everything =
    .label = Усё

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Гісторыю

item-history-and-downloads =
    .label = Гісторыя аглядання і сцягванняў
    .accesskey = а

item-cookies =
    .label = Кукі
    .accesskey = К

item-active-logins =
    .label = Дзейныя ўваходы
    .accesskey = ў

item-cache =
    .label = Кэш
    .accesskey = К

item-form-search-history =
    .label = Гісторыя пошуку і запаўнення формаў
    .accesskey = ф

data-section-label = Дадзеныя

item-site-preferences =
    .label = Налады сайтаў
    .accesskey = Н

item-offline-apps =
    .label = Пазасеткавыя дадзеныя вэб-сайтаў
    .accesskey = П

sanitize-everything-undo-warning = Гэтае дзеянне немагчыма скасаваць.

window-close =
    .key = w

sanitize-button-ok =
    .label = Ачысціць зараз

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Ачыстка

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Уся гісторыя будзе ачышчана.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Усе вылучаныя элементы будуць ачышчаныя.
