# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Списки блокування
    .style = width: 58em

blocklist-description = Оберіть список, який { -brand-short-name } використовуватиме для блокування стеження. Списки надаються <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Список

blocklist-button-cancel =
    .label = Скасувати
    .accesskey = С

blocklist-button-ok =
    .label = Зберегти зміни
    .accesskey = З

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Список блокування 1-го рівня (Рекомендовано).
blocklist-item-moz-std-description = Дозволяє деякі елементи стеження для належної роботи вебсайтів.
blocklist-item-moz-full-listName = Список блокування 2-го рівня.
blocklist-item-moz-full-description = Блокує все виявлене стеження. Деякі вебсайти чи вміст можуть не завантажуватись належним чином.
