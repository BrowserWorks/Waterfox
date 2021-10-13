# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

places-open =
    .label = Открыть
    .accesskey = О
places-open-in-tab =
    .label = Открыть в новой вкладке
    .accesskey = ы
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
    .label = Сортировать по имени
    .accesskey = р
# places-edit-bookmark and places-edit-generic will show one or the other and can have the same access key.
places-edit-bookmark =
    .label = Изменить закладку…
    .accesskey = н
places-edit-generic =
    .label = Изменить…
    .accesskey = н
places-edit-folder =
    .label = Переименовать папку…
    .accesskey = м
places-remove-folder =
    .label =
        { $count ->
            [1] Удалить папку
            [one] Удалить папку
            [few] Удалить папки
           *[many] Удалить папки
        }
    .accesskey = л
places-edit-folder2 =
    .label = Изменить папку…
    .accesskey = н
places-delete-folder =
    .label =
        { $count ->
            [1] Удалить папку
            [one] Удалить папку
            [few] Удалить папки
           *[many] Удалить папки
        }
    .accesskey = л
# Managed bookmarks are created by an administrator and cannot be changed by the user.
managed-bookmarks =
    .label = Управляемые закладки
# This label is used when a managed bookmarks folder doesn't have a name.
managed-bookmarks-subfolder =
    .label = Вложенная папка
# This label is used for the "Other Bookmarks" folder that appears in the bookmarks toolbar.
other-bookmarks-folder =
    .label = Другие закладки
# Variables:
# $count (number) - The number of elements being selected for removal.
places-remove-bookmark =
    .label =
        { $count ->
            [1] Удалить закладку
            [one] Удалить { $count } закладку
            [few] Удалить { $count } закладки
           *[many] Удалить { $count } закладок
        }
    .accesskey = л
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
places-manage-bookmarks =
    .label = Управление закладками
    .accesskey = в
places-forget-about-this-site-confirmation-title = Забыть об этом сайте
# Variables:
# $hostOrBaseDomain (string) - The base domain (or host in case there is no base domain) for which data is being removed
places-forget-about-this-site-confirmation-message = Это действие удалит все данные, связанные с { $hostOrBaseDomain }, в том числе историю, пароли, куки, кэш и настройки содержимого. Вы уверены, что хотите продолжить?
places-forget-about-this-site-forget = Забыть
places-library =
    .title = Библиотека
    .style = width:700px; height:500px;
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
    .label = Показать колонки
    .accesskey = к
places-view-menu-sort =
    .label = Сортировка
    .accesskey = р
places-view-sort-unsorted =
    .label = Без сортировки
    .accesskey = е
places-view-sort-ascending =
    .label = Сортировка по алфавиту
    .accesskey = С
places-view-sort-descending =
    .label = В обратном порядке
    .accesskey = о
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
places-cmd-find-key =
    .key = f
places-back-button =
    .tooltiptext = Перейти назад
places-forward-button =
    .tooltiptext = Перейти вперёд
places-details-pane-select-an-item-description = Выберите элемент для просмотра и редактирования его свойств
