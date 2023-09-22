# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

places-open =
    .label = Открыть
    .accesskey = О
places-open-in-tab =
    .label = Открыть в новой вкладке
    .accesskey = ы
places-open-in-container-tab =
    .label = Открыть в новой вкладке в контейнере
    .accesskey = н
places-open-all-bookmarks =
    .label = Открыть все закладки
    .accesskey = з
places-open-all-in-tabs =
    .label = Открыть всё во вкладках
    .accesskey = в
places-open-in-window =
    .label = Открыть в новом окне
    .accesskey = н
places-open-in-private-window =
    .label = Открыть в новом приватном окне
    .accesskey = и

places-empty-bookmarks-folder =
    .label = (Пусто)

places-add-bookmark =
    .label = Создать закладку…
    .accesskey = з
places-add-folder-contextmenu =
    .label = Создать папку…
    .accesskey = п
places-add-folder =
    .label = Создать папку…
    .accesskey = п
places-add-separator =
    .label = Добавить разделитель
    .accesskey = р

places-view =
    .label = Вид
    .accesskey = и
places-by-date =
    .label = По дате
    .accesskey = д
places-by-site =
    .label = По сайтам
    .accesskey = с
places-by-most-visited =
    .label = По числу посещений
    .accesskey = и
places-by-last-visited =
    .label = По времени последнего посещения
    .accesskey = о
places-by-day-and-site =
    .label = По дате и сайтам
    .accesskey = и

places-history-search =
    .placeholder = Поиск по журналу
places-history =
    .aria-label = Журнал
places-bookmarks-search =
    .placeholder = Поиск закладок

places-delete-domain-data =
    .label = Забыть об этом сайте
    .accesskey = б
places-sortby-name =
    .label = Упорядочивать по имени
    .accesskey = ч
# places-edit-bookmark and places-edit-generic will show one or the other and can have the same access key.
places-edit-bookmark =
    .label = Изменить закладку…
    .accesskey = н
places-edit-generic =
    .label = Изменить…
    .accesskey = н
places-edit-folder2 =
    .label = Изменить папку…
    .accesskey = н
# Variables
#   $count (number) - Number of folders to delete
places-delete-folder =
    .label =
        { $count ->
            [1] Удалить папку
            [one] Удалить папку
            [few] Удалить папки
           *[many] Удалить папки
        }
    .accesskey = л
# Variables:
#   $count (number) - The number of pages selected for removal.
places-delete-page =
    .label =
        { $count ->
            [1] Удалить страницу
           *[other] Удалить страницы
        }
    .accesskey = а

# Managed bookmarks are created by an administrator and cannot be changed by the user.
managed-bookmarks =
    .label = Управляемые закладки
# This label is used when a managed bookmarks folder doesn't have a name.
managed-bookmarks-subfolder =
    .label = Вложенная папка

# This label is used for the "Other Bookmarks" folder that appears in the bookmarks toolbar.
other-bookmarks-folder =
    .label = Другие закладки

places-show-in-folder =
    .label = Показать в папке
    .accesskey = з

# Variables:
# $count (number) - The number of elements being selected for removal.
places-delete-bookmark =
    .label =
        { $count ->
            [1] Удалить закладку
            [one] Удалить { $count } закладку
            [few] Удалить { $count } закладки
           *[many] Удалить { $count } закладок
        }
    .accesskey = л

# Variables:
#   $count (number) - The number of bookmarks being added.
places-create-bookmark =
    .label =
        { $count ->
            [1] Добавить страницу в закладки…
           *[other] Добавить страницы в закладки…
        }
    .accesskey = н

places-untag-bookmark =
    .label = Удалить метку
    .accesskey = и

places-manage-bookmarks =
    .label = Управление закладками
    .accesskey = в

places-forget-about-this-site-confirmation-title = Забыть об этом сайте

# Variables:
# $hostOrBaseDomain (string) - The base domain (or host in case there is no base domain) for which data is being removed
places-forget-about-this-site-confirmation-msg = Это действие удалит данные, связанные с { $hostOrBaseDomain }, включая историю, куки, кеш и настройки содержимого. Связанные закладки и пароли не будут удалены. Вы уверены, что хотите продолжить?

places-forget-about-this-site-forget = Забыть

places-library3 =
    .title = Библиотека

places-organize-button =
    .label = Управление
    .tooltiptext = Управление вашими закладками
    .accesskey = а

places-organize-button-mac =
    .label = Управление
    .tooltiptext = Управление вашими закладками

places-file-close =
    .label = Закрыть
    .accesskey = З

places-cmd-close =
    .key = w

places-view-button =
    .label = Вид
    .tooltiptext = Изменение внешнего вида
    .accesskey = и

places-view-button-mac =
    .label = Вид
    .tooltiptext = Изменение внешнего вида

places-view-menu-columns =
    .label = Показать столбцы
    .accesskey = к

places-view-menu-sort =
    .label = Упорядочивание
    .accesskey = п

places-view-sort-unsorted =
    .label = Без упорядочивания
    .accesskey = е

places-view-sort-ascending =
    .label = По алфавиту
    .accesskey = в

places-view-sort-descending =
    .label = Обратное
    .accesskey = б

places-maintenance-button =
    .label = Импорт и резервные копии
    .tooltiptext = Импорт и резервные копии ваших закладок
    .accesskey = о

places-maintenance-button-mac =
    .label = Импорт и резервные копии
    .tooltiptext = Импорт и резервные копии ваших закладок

places-cmd-backup =
    .label = Создать резервную копию…
    .accesskey = р

places-cmd-restore =
    .label = Восстановить резервную копию от
    .accesskey = с

places-cmd-restore-from-file =
    .label = Выбрать файл…
    .accesskey = б

places-import-bookmarks-from-html =
    .label = Импорт закладок из HTML-файла…
    .accesskey = И

places-export-bookmarks-to-html =
    .label = Экспорт закладок в HTML-файл…
    .accesskey = Э

places-import-other-browser =
    .label = Импорт данных из другого браузера…
    .accesskey = п

places-view-sort-col-name =
    .label = Имя

places-view-sort-col-tags =
    .label = Метки

places-view-sort-col-url =
    .label = Адрес

places-view-sort-col-most-recent-visit =
    .label = Последнее посещение

places-view-sort-col-visit-count =
    .label = Число посещений

places-view-sort-col-date-added =
    .label = Добавлена

places-view-sort-col-last-modified =
    .label = Посл. изменение

places-view-sortby-name =
    .label = По имени
    .accesskey = м
places-view-sortby-url =
    .label = По расположению
    .accesskey = р
places-view-sortby-date =
    .label = По дате последнего посещения
    .accesskey = а
places-view-sortby-visit-count =
    .label = По числу посещений
    .accesskey = л
places-view-sortby-date-added =
    .label = По дате добавления
    .accesskey = д
places-view-sortby-last-modified =
    .label = По дате последнего изменения
    .accesskey = з
places-view-sortby-tags =
    .label = По меткам
    .accesskey = т

places-cmd-find-key =
    .key = f

places-back-button =
    .tooltiptext = Перейти назад

places-forward-button =
    .tooltiptext = Перейти вперёд

places-details-pane-select-an-item-description = Выберите элемент для просмотра и правки его свойств

places-details-pane-no-items =
    .value = Нет элементов
# Variables:
#   $count (Number): number of items
places-details-pane-items-count =
    .value =
        { $count ->
            [one] { $count } элемент
            [few] { $count } элемента
           *[many] { $count } элементов
        }

## Strings used as a placeholder in the Library search field. For example,
## "Search History" stands for "Search through the browser's history".

places-search-bookmarks =
    .placeholder = Поиск в закладках
places-search-history =
    .placeholder = Поиск в журнале
places-search-downloads =
    .placeholder = Поиск в загрузках

##

places-locked-prompt = Работа с закладками и журналом невозможна, так как один из файлов { -brand-short-name } используется другим приложением. Данную проблему могут вызывать некоторые из защитных программ.
