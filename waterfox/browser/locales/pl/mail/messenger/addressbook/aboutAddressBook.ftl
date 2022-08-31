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
about-addressbook-books-context-edit =
    .label = Edytuj
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
about-addressbook-sort-button2 =
    .title = Opcje wyświetlania listy
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
about-addressbook-horizontal-layout =
    .label = Przełącz na układ poziomy
about-addressbook-vertical-layout =
    .label = Przełącz na układ pionowy

## Card column headers
## Each string is listed here twice, and the values should match.

about-addressbook-column-header-generatedname = Imię i nazwisko
about-addressbook-column-label-generatedname =
    .label = { about-addressbook-column-header-generatedname }
about-addressbook-column-header-emailaddresses = Adresy e-mail
about-addressbook-column-label-emailaddresses =
    .label = { about-addressbook-column-header-emailaddresses }
about-addressbook-column-header-phonenumbers = Numery telefonu
about-addressbook-column-label-phonenumbers =
    .label = { about-addressbook-column-header-phonenumbers }
about-addressbook-column-header-addresses = Adresy
about-addressbook-column-label-addresses =
    .label = { about-addressbook-column-header-addresses }
about-addressbook-column-header-title = Tytuł
about-addressbook-column-label-title =
    .label = { about-addressbook-column-header-title }
about-addressbook-column-header-department = Dział
about-addressbook-column-label-department =
    .label = { about-addressbook-column-header-department }
about-addressbook-column-header-organization = Firma/Organizacja
about-addressbook-column-label-organization =
    .label = { about-addressbook-column-header-organization }
about-addressbook-column-header-addrbook = Książka adresowa
about-addressbook-column-label-addrbook =
    .label = { about-addressbook-column-header-addrbook }
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

## Card list placeholder
## Shown when there are no cards in the list

about-addressbook-placeholder-empty-book = Brak dostępnych kontaktów
about-addressbook-placeholder-new-contact = Nowy kontakt
about-addressbook-placeholder-search-only = Ta książka adresowa wyświetla kontakty wyłącznie po wyszukiwaniu
about-addressbook-placeholder-searching = Wyszukiwanie…
about-addressbook-placeholder-no-search-results = Nie odnaleziono kontaktów

## Details

about-addressbook-prefer-display-name = Używaj nazwy kontaktu z książki adresowej zamiast nazwy podanej w wiadomości
about-addressbook-write-action-button = Napisz
about-addressbook-event-action-button = Wydarzenie
about-addressbook-search-action-button = Szukaj
about-addressbook-begin-edit-contact-button = Edytuj
about-addressbook-delete-edit-contact-button = Usuń
about-addressbook-cancel-edit-contact-button = Anuluj
about-addressbook-save-edit-contact-button = Zapisz
about-addressbook-add-contact-to = Dodaj do:
about-addressbook-details-email-addresses-header = Adresy e-mail
about-addressbook-details-phone-numbers-header = Numery telefonu
about-addressbook-details-addresses-header = Adresy
about-addressbook-details-notes-header = Notatki
about-addressbook-details-other-info-header = Pozostałe informacje
about-addressbook-entry-type-work = Praca
about-addressbook-entry-type-home = Dom
about-addressbook-entry-type-fax = Faks
about-addressbook-entry-type-cell = Telefon komórkowy
about-addressbook-entry-type-pager = Pager
about-addressbook-entry-name-birthday = Urodziny
about-addressbook-entry-name-anniversary = Rocznica
about-addressbook-entry-name-title = Tytuł
about-addressbook-entry-name-role = Rola
about-addressbook-entry-name-organization = Firma/Organizacja
about-addressbook-entry-name-website = Strona WWW
about-addressbook-entry-name-time-zone = Strefa czasowa
about-addressbook-unsaved-changes-prompt-title = Niezapisane zmiany
about-addressbook-unsaved-changes-prompt = Czy zapisać zmiany przed wyjściem?

# Photo dialog

about-addressbook-photo-drop-target = Przeciągnij lub wklej zdjęcie tutaj albo kliknij, aby wybrać plik.
about-addressbook-photo-drop-loading = Wczytywanie zdjęcia…
about-addressbook-photo-drop-error = Wczytanie zdjęcia się nie powiodło.
about-addressbook-photo-filepicker-title = Wybierz plik obrazu
about-addressbook-photo-discard = Odrzuć istniejące zdjęcie
about-addressbook-photo-cancel = Anuluj
about-addressbook-photo-save = Zapisz
