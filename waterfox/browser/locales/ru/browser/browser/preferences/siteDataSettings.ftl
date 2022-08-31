# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = Управление куками и данными сайтов

site-data-settings-description = Следующие веб-сайты хранят куки и данные сайтов на вашем компьютере. { -brand-short-name } хранит данные с веб-сайтов с постоянным хранилищем до тех пор, пока вы их не удалите, и удаляет данные с веб-сайтов с непостоянным хранилищем, если ему понадобится место.

site-data-search-textbox =
    .placeholder = Поиск веб-сайтов
    .accesskey = и

site-data-column-host =
    .label = Сайт
site-data-column-cookies =
    .label = Куки
site-data-column-storage =
    .label = Хранилище
site-data-column-last-used =
    .label = Последнее использование

# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = (локальный файл)

site-data-remove-selected =
    .label = Удалить выбранное
    .accesskey = а

site-data-settings-dialog =
    .buttonlabelaccept = Сохранить изменения
    .buttonaccesskeyaccept = х

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value } (Постоянное)

site-data-remove-all =
    .label = Удалить все
    .accesskey = и

site-data-remove-shown =
    .label = Удалить все показанные
    .accesskey = и

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = Удалить

site-data-removing-header = Удаление кук и данных сайтов

site-data-removing-desc = Удаление кук и данных сайтов может привести к разрегистрации вас на веб-сайтах. Вы уверены, что хотите произвести изменения?

# Variables:
#   $baseDomain (String) - The single domain for which data is being removed
site-data-removing-single-desc = Удаление кук и данных сайтов может привести к разрегистрации вас на веб-сайтах. Вы уверены, что хотите удалить куки и данные сайтов для <strong>{ $baseDomain }</strong>?

site-data-removing-table = Куки и данные сайтов для следующих веб-сайтов будут удалены
