# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Адресная книга

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = Новая адресная книга
about-addressbook-toolbar-new-carddav-address-book =
    .label = Новая адресная книга CardDAV
about-addressbook-toolbar-new-ldap-address-book =
    .label = Новая адресная книга LDAP
about-addressbook-toolbar-add-carddav-address-book =
    .label = Добавить адресную книгу CardDAV
about-addressbook-toolbar-add-ldap-address-book =
    .label = Добавить адресную книгу LDAP
about-addressbook-toolbar-new-contact =
    .label = Новый контакт
about-addressbook-toolbar-new-list =
    .label = Новый список

## Books

all-address-books = Все адресные книги
about-addressbook-books-context-properties =
    .label = Свойства
about-addressbook-books-context-synchronize =
    .label = Синхронизовать
about-addressbook-books-context-print =
    .label = Печать…
about-addressbook-books-context-delete =
    .label = Удалить
about-addressbook-books-context-remove =
    .label = Удалить
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
about-addressbook-sort-button =
    .title = Изменение порядка в списке
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

## Details

about-addressbook-begin-edit-contact-button = Изменить
about-addressbook-cancel-edit-contact-button = Отмена
about-addressbook-save-edit-contact-button = Сохранить
about-addressbook-details-email-addresses-header = Адреса электронной почты
about-addressbook-details-phone-numbers-header = Телефонные номера
about-addressbook-details-home-address-header = Домашний адрес
about-addressbook-details-work-address-header = Рабочий адрес
about-addressbook-details-other-info-header = Дополнительная информация
