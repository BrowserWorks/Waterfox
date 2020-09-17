# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Листе блокираних елемената
    .style = width: 50em

blocklist-description = Изаберите списак који ће { -brand-short-name } користити за блокирање пратиоца на мрежи. Спискове пружа <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Листа

blocklist-button-cancel =
    .label = Откажи
    .accesskey = C

blocklist-button-ok =
    .label = Сачувај промене
    .accesskey = S

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Списак блокирања првог нивоа (препоручено).
blocklist-item-moz-std-description = Дозволи неке пратиоце зарад мање сломљених сајтова.
blocklist-item-moz-full-listName = Списак блокирања другог нивоа.
blocklist-item-moz-full-description = Блокирај све уочене пратиоце. Неки сајтови или садржаји се можда неће исправно учитати.
