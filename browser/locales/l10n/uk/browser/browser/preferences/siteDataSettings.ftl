# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = Керувати куками й даними сайту

site-data-settings-description = Зазначені тут вебсайти зберігають куки і дані сайтів на вашому комп'ютері. { -brand-short-name } зберігає дані для вебсайтів з постійним сховищем, доки ви їх не видалите, і видаляє дані для вебсайтів з непостійним сховищем, коли потрібно звільнити місце.

site-data-search-textbox =
    .placeholder = Пошук вебсайтів
    .accesskey = П

site-data-column-host =
    .label = Сайт
site-data-column-cookies =
    .label = Куки
site-data-column-storage =
    .label = Сховище
site-data-column-last-used =
    .label = Востаннє використано

# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = (локальний файл)

site-data-remove-selected =
    .label = Видалити вибрані
    .accesskey = В

site-data-button-cancel =
    .label = Скасувати
    .accesskey = С

site-data-button-save =
    .label = Зберегти зміни
    .accesskey = З

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value } (Постійне)

site-data-remove-all =
    .label = Видалити все
    .accesskey = в

site-data-remove-shown =
    .label = Видалити всі перелічені
    .accesskey = в

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = Видалити

site-data-removing-header = Видалення кук і даних сайтів

site-data-removing-desc = Видалення кук і даних сайтів може призвести до виходу на ваших вебсайтах. Ви справді хочете зробити ці зміни?

site-data-removing-table = Куки та дані сайтів для наступних вебсайтів будуть видалені
