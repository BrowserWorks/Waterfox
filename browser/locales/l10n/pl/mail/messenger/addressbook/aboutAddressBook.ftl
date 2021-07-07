# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Książka adresowa

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = Nowa książka adresowa
about-addressbook-toolbar-add-carddav-address-book =
    .label = Dodaj książkę adresową CardDAV
about-addressbook-toolbar-add-ldap-address-book =
    .label = Dodaj książkę adresową LDAP
about-addressbook-toolbar-new-contact =
    .label = Nowy kontakt
about-addressbook-toolbar-new-list =
    .label = Nowa lista
about-addressbook-toolbar-import =
    .label = Importuj

## Books

all-address-books = Wszystkie książki adresowe
about-addressbook-books-context-properties =
    .label = Właściwości
about-addressbook-books-context-synchronize =
    .label = Synchronizuj
about-addressbook-books-context-print =
    .label = Drukuj…
about-addressbook-books-context-export =
    .label = Eksportuj…
about-addressbook-books-context-delete =
    .label = Usuń
about-addressbook-books-context-remove =
    .label = Usuń
about-addressbook-books-context-startup-default =
    .label = Domyślnie uruchamiany katalog
about-addressbook-confirm-delete-book-title = Usuń książkę adresową
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = Czy na pewno usunąć książkę adresową { $name } i wszystkie jej kontakty?
about-addressbook-confirm-remove-remote-book-title = Usuń książkę adresową
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = Czy na pewno usunąć książkę adresową { $name }?

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = Szukaj w „{ $name }”
about-addressbook-search-all =
    .placeholder = Szukaj we wszystkich książkach adresowych
about-addressbook-sort-button =
    .title = Zmień kolejność na liście
about-addressbook-name-format-display =
    .label = Wyświetlana nazwa
about-addressbook-name-format-firstlast =
    .label = Imię Nazwisko
about-addressbook-name-format-lastfirst =
    .label = Nazwisko, imię
about-addressbook-sort-name-ascending =
    .label = Sortuj według nazw (A→Z)
about-addressbook-sort-name-descending =
    .label = Sortuj według nazw (Z→A)
about-addressbook-sort-email-ascending =
    .label = Sortuj według adresów e-mail (A→Z)
about-addressbook-sort-email-descending =
    .label = Sortuj według adresów e-mail (Z→A)
about-addressbook-cards-context-write =
    .label = Napisz
about-addressbook-confirm-delete-mixed-title = Usuń kontakty i listy
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed =
    { $count ->
        [one] Czy na pewno usunąć ten kontakt lub listę?
        [few] Czy na pewno usunąć te { $count } kontakty i listy?
       *[many] Czy na pewno usunąć te { $count } kontaktów i list?
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
    { $count ->
        [one] Usuń listę
       *[other] Usuń listy
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
    { $count ->
        [one] Czy na pewno usunąć listę „{ $name }”?
        [few] Czy na pewno usunąć te { $count } listy?
       *[many] Czy na pewno usunąć te { $count } list?
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
    { $count ->
        [one] Usuń kontakt
       *[other] Usuń kontakty
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
# $name (String) - The name of the contact to be removed, if $count is 1.
# $list (String) - The name of the list that contacts will be removed from.
about-addressbook-confirm-remove-contacts =
    { $count ->
        [one] Czy na pewno usunąć kontakt „{ $name }” z listy „{ $list }”?
        [few] Czy na pewno usunąć te { $count } kontakty z listy „{ $list }”?
       *[many] Czy na pewno usunąć te { $count } kontaktów z listy „{ $list }”?
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
about-addressbook-confirm-delete-contacts-title =
    { $count ->
        [one] Usuń kontakt
       *[other] Usuń kontakty
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
# $name (String) - The name of the contact to be deleted, if $count is 1.
about-addressbook-confirm-delete-contacts =
    { $count ->
        [one] Czy na pewno usunąć kontakt „{ $name }”?
        [few] Czy na pewno usunąć te { $count } kontakty?
       *[many] Czy na pewno usunąć te { $count } kontaktów?
    }

## Details

about-addressbook-begin-edit-contact-button = Edytuj
about-addressbook-cancel-edit-contact-button = Anuluj
about-addressbook-save-edit-contact-button = Zapisz
about-addressbook-details-email-addresses-header = Adresy e-mail
about-addressbook-details-phone-numbers-header = Numery telefonu
about-addressbook-details-home-address-header = Adres domowy
about-addressbook-details-work-address-header = Adres służbowy
about-addressbook-details-other-info-header = Pozostałe informacje
