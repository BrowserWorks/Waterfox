# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Адресная книга

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = Новая адресная книга
about-addressbook-toolbar-add-carddav-address-book =
    .label = Добавить адресную книгу CardDAV
about-addressbook-toolbar-add-ldap-address-book =
    .label = Добавить адресную книгу LDAP
about-addressbook-toolbar-new-contact =
    .label = Новый контакт
about-addressbook-toolbar-new-list =
    .label = Новый список
about-addressbook-toolbar-import =
    .label = Импорт

## Books

all-address-books = Все адресные книги
about-addressbook-books-context-properties =
    .label = Свойства
about-addressbook-books-context-synchronize =
    .label = Синхронизовать
about-addressbook-books-context-edit =
    .label = Изменить
about-addressbook-books-context-print =
    .label = Печать…
about-addressbook-books-context-export =
    .label = Экспорт…
about-addressbook-books-context-delete =
    .label = Удалить
about-addressbook-books-context-remove =
    .label = Удалить
about-addressbook-books-context-startup-default =
    .label = Каталог по умолчанию при открытии
about-addressbook-confirm-delete-book-title = Удаление адресной книги
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = Вы действительно хотите удалить { $name } и все контакты в ней?
about-addressbook-confirm-remove-remote-book-title = Удаление адресной книги
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = Вы уверены, что хотите удалить { $name }?

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = Поиск в { $name }
about-addressbook-search-all =
    .placeholder = Поиск во всех адресных книгах
about-addressbook-sort-button2 =
    .title = Варианты отображения списка
about-addressbook-name-format-display =
    .label = Отображаемое имя
about-addressbook-name-format-firstlast =
    .label = Первый Последний
about-addressbook-name-format-lastfirst =
    .label = Последний, Первый
about-addressbook-sort-name-ascending =
    .label = Сортировать по имени (от А до Я)
about-addressbook-sort-name-descending =
    .label = Сортировать по имени (от Я до А)
about-addressbook-sort-email-ascending =
    .label = Сортировать по адресу эл. почты (от A до Z)
about-addressbook-sort-email-descending =
    .label = Сортировать по адресу эл. почты (от Z до A)
about-addressbook-horizontal-layout =
    .label = Переключиться на горизонтальную раскладку
about-addressbook-vertical-layout =
    .label = Переключиться на вертикальную компоновку

## Card column headers
## Each string is listed here twice, and the values should match.

about-addressbook-column-header-generatedname = Имя
about-addressbook-column-label-generatedname =
    .label = { about-addressbook-column-header-generatedname }
about-addressbook-column-header-emailaddresses = Адреса электронной почты
about-addressbook-column-label-emailaddresses =
    .label = { about-addressbook-column-header-emailaddresses }
about-addressbook-column-header-phonenumbers = Номера телефонов
about-addressbook-column-label-phonenumbers =
    .label = { about-addressbook-column-header-phonenumbers }
about-addressbook-column-header-addresses = Адреса
about-addressbook-column-label-addresses =
    .label = { about-addressbook-column-header-addresses }
about-addressbook-column-header-title = Заголовок
about-addressbook-column-label-title =
    .label = { about-addressbook-column-header-title }
about-addressbook-column-header-department = Департамент
about-addressbook-column-label-department =
    .label = { about-addressbook-column-header-department }
about-addressbook-column-header-organization = Организация
about-addressbook-column-label-organization =
    .label = { about-addressbook-column-header-organization }
about-addressbook-column-header-addrbook = Адресная книга
about-addressbook-column-label-addrbook =
    .label = { about-addressbook-column-header-addrbook }
about-addressbook-cards-context-write =
    .label = Записать
about-addressbook-confirm-delete-mixed-title = Удаление контактов и списков
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed = Вы действительно хотите удалить эти { $count } контакта(ов) и списка(ов)?
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
    { $count ->
        [one] Удаление списка
        [few] Удаление списков
       *[many] Удаление списков
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
    { $count ->
        [one] Вы действительно хотите удалить список { $name }?
        [few] Вы действительно хотите удалить эти { $count } списка?
       *[many] Вы действительно хотите удалить эти { $count } списков?
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
    { $count ->
        [one] Удаление контакта
        [few] Удаление контактов
       *[many] Удаление контактов
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
# $name (String) - The name of the contact to be removed, if $count is 1.
# $list (String) - The name of the list that contacts will be removed from.
about-addressbook-confirm-remove-contacts =
    { $count ->
        [one] Вы действительно хотите удалить { $name } из { $list }?
        [few] Вы действительно хотите удалить эти { $count } контакта из { $list }?
       *[many] Вы действительно хотите удалить эти { $count } контактов из { $list }?
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
about-addressbook-confirm-delete-contacts-title =
    { $count ->
        [one] Удаление контакта
        [few] Удаление контактов
       *[many] Удаление контактов
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
# $name (String) - The name of the contact to be deleted, if $count is 1.
about-addressbook-confirm-delete-contacts =
    { $count ->
        [one] Вы действительно хотите удалить контакт { $name }?
        [few] Вы действительно хотите удалить эти { $count } контакта?
       *[many] Вы действительно хотите удалить эти { $count } контактов?
    }

## Card list placeholder
## Shown when there are no cards in the list

about-addressbook-placeholder-empty-book = Нет доступных контактов
about-addressbook-placeholder-new-contact = Создать контакт
about-addressbook-placeholder-search-only = Это адресная книга покажет контакты только после поиска
about-addressbook-placeholder-searching = Поиск…
about-addressbook-placeholder-no-search-results = Контакты не найдены

## Details

about-addressbook-prefer-display-name = Использовать отображаемое имя вместо имени из заголовка сообщения
about-addressbook-write-action-button = Записать
about-addressbook-event-action-button = Событие
about-addressbook-search-action-button = Поиск
about-addressbook-begin-edit-contact-button = Изменить
about-addressbook-delete-edit-contact-button = Удалить
about-addressbook-cancel-edit-contact-button = Отмена
about-addressbook-save-edit-contact-button = Сохранить
about-addressbook-add-contact-to = Добавить в:
about-addressbook-details-email-addresses-header = Адреса электронной почты
about-addressbook-details-phone-numbers-header = Номера телефонов
about-addressbook-details-addresses-header = Адреса
about-addressbook-details-notes-header = Заметки
about-addressbook-details-other-info-header = Дополнительная информация
about-addressbook-entry-type-work = Рабочий
about-addressbook-entry-type-home = Домашний
about-addressbook-entry-type-fax = Факс
about-addressbook-entry-type-cell = Мобильный телефон
about-addressbook-entry-type-pager = Пейджер
about-addressbook-entry-name-birthday = День рождения
about-addressbook-entry-name-anniversary = Годовщина
about-addressbook-entry-name-title = Должность
about-addressbook-entry-name-role = Роль
about-addressbook-entry-name-organization = Организация
about-addressbook-entry-name-website = Веб-сайт
about-addressbook-entry-name-time-zone = Часовой пояс
about-addressbook-unsaved-changes-prompt-title = Несохранённые изменения
about-addressbook-unsaved-changes-prompt = Вы хотите сохранить изменения перед выходом из режима редактирования?

# Photo dialog

about-addressbook-photo-drop-target = Перетащите или вставьте сюда фотографию, или щёлкните, чтобы выбрать файл.
about-addressbook-photo-drop-loading = Загрузка фото…
about-addressbook-photo-drop-error = Не удалось загрузить фото.
about-addressbook-photo-filepicker-title = Выберите файл изображения
about-addressbook-photo-discard = Удалить существующее фото
about-addressbook-photo-cancel = Отмена
about-addressbook-photo-save = Сохранить
