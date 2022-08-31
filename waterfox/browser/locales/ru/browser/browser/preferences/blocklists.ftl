# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Списки блокировки
    .style = width: 58em

blocklist-description = Выберите список, который { -brand-short-name } будет использовать для блокировки онлайн-трекеров. Списки предоставлены <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Список

blocklist-dialog =
    .buttonlabelaccept = Сохранить изменения
    .buttonaccesskeyaccept = х


# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Список блокировки 1-го уровня (Рекомендуется).
blocklist-item-moz-std-description = Разрешить некоторые трекеры, чтобы меньше веб-сайтов «сломались».
blocklist-item-moz-full-listName = Список блокировки 2-го уровня.
blocklist-item-moz-full-description = Блокировать все обнаруженные трекеры. Некоторые веб-сайты или содержимое могут не загружаться.
