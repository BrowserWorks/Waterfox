# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Adressbok

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = Ny adressbok
about-addressbook-toolbar-new-carddav-address-book =
    .label = Ny CardDAV-adressbok
about-addressbook-toolbar-new-ldap-address-book =
    .label = Ny LDAP-adressbok
about-addressbook-toolbar-add-carddav-address-book =
    .label = Lägg till CardDAV-adressbok
about-addressbook-toolbar-add-ldap-address-book =
    .label = Lägg till LDAP-adressbok
about-addressbook-toolbar-new-contact =
    .label = Ny kontakt
about-addressbook-toolbar-new-list =
    .label = Ny lista

## Books

all-address-books = Alla adressböcker
about-addressbook-books-context-properties =
    .label = Egenskaper
about-addressbook-books-context-synchronize =
    .label = Synkronisera
about-addressbook-books-context-print =
    .label = Skriv ut…
about-addressbook-books-context-delete =
    .label = Ta bort
about-addressbook-books-context-remove =
    .label = Ta bort
about-addressbook-confirm-delete-book-title = Ta bort adressbok
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = Är du säker på att du vill ta bort { $name } och alla dess kontakter?
about-addressbook-confirm-remove-remote-book-title = Ta bort adressbok
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = Är du säker på att du vill ta bort { $name }?

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = Sök i { $name }
about-addressbook-search-all =
    .placeholder = Sök i alla adressböcker
about-addressbook-sort-button =
    .title = Ändra listordningen
about-addressbook-name-format-display =
    .label = Visningsnamn
about-addressbook-name-format-firstlast =
    .label = Förnamn Efternamn
about-addressbook-name-format-lastfirst =
    .label = Efternamn, Förnamn
about-addressbook-sort-name-ascending =
    .label = Sortera efter namn (A > Ö)
about-addressbook-sort-name-descending =
    .label = Sortera efter namn (Ö > A)
about-addressbook-sort-email-ascending =
    .label = Sortera efter e-postadress (A > Ö)
about-addressbook-sort-email-descending =
    .label = Sortera efter e-postadress (Ö > A)
about-addressbook-confirm-delete-mixed-title = Ta bort kontakter och listor
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed = Är du säker på att du vill ta bort dessa { $count } kontakter och listor?
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
    { $count ->
        [one] Ta bort lista
       *[other] Ta bort listor
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
    { $count ->
        [one] Är du säker på att du vill ta bort listan { $name }?
       *[other] Är du säker på att du vill ta bort dessa { $count } listor?
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
    { $count ->
        [one] Ta bort kontakt
       *[other] Ta bort kontakter
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
# $name (String) - The name of the contact to be removed, if $count is 1.
# $list (String) - The name of the list that contacts will be removed from.
about-addressbook-confirm-remove-contacts =
    { $count ->
        [one] Är du säker på att du vill ta bort { $name } från { $list }?
       *[other] Är du säker att du vill ta bort dessa { $count } kontakter från { $list }?
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
about-addressbook-confirm-delete-contacts-title =
    { $count ->
        [one] Ta bort kontakt
       *[other] Ta bort kontakter
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
# $name (String) - The name of the contact to be deleted, if $count is 1.
about-addressbook-confirm-delete-contacts =
    { $count ->
        [one] Är du säker på att du vill ta bort kontakten { $name }?
       *[other] Är du säker på att du vill ta bort dessa { $count } kontakter?
    }

## Details

about-addressbook-begin-edit-contact-button = Redigera
about-addressbook-cancel-edit-contact-button = Avbryt
about-addressbook-save-edit-contact-button = Spara
about-addressbook-details-email-addresses-header = E-postadresser
about-addressbook-details-phone-numbers-header = Telefonnummer
about-addressbook-details-home-address-header = Hemadresser
about-addressbook-details-work-address-header = Arbetsadress
about-addressbook-details-other-info-header = Annan information
