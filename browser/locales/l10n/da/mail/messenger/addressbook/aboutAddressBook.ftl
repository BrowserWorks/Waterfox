# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Adressebog

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = Ny adressebog
about-addressbook-toolbar-add-carddav-address-book =
    .label = Tilføj CardDAV-adressebog
about-addressbook-toolbar-add-ldap-address-book =
    .label = Tilføj LDAP-adressebog
about-addressbook-toolbar-new-contact =
    .label = Ny kontakt
about-addressbook-toolbar-new-list =
    .label = Ny mailingliste

## Books

all-address-books = Alle adressebøger

about-addressbook-books-context-properties =
    .label = Egenskaber
about-addressbook-books-context-synchronize =
    .label = Synkroniser
about-addressbook-books-context-print =
    .label = Udskriv…
about-addressbook-books-context-delete =
    .label = Slet
about-addressbook-books-context-remove =
    .label = Fjern

about-addressbook-confirm-delete-book-title = Slet adressebog
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = Er du sikker på, at du vil slette{ $name } og alle dens kontakter?
about-addressbook-confirm-remove-remote-book-title = Fjern adressebog
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = Er du sikker på, at du vil fjerne { $name }?

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = Søg i { $name }
about-addressbook-search-all =
    .placeholder = Søg i alle adressebøger

about-addressbook-sort-button =
    .title = Skift listens rækkefølge

about-addressbook-name-format-display =
    .label = Vist navn
about-addressbook-name-format-firstlast =
    .label = Fornavn Efternavn
about-addressbook-name-format-lastfirst =
    .label = Efternavn, fornavn

about-addressbook-sort-name-ascending =
    .label = Sorter efter navn (A > Å)
about-addressbook-sort-name-descending =
    .label = Sorter efter navn (Å > A)
about-addressbook-sort-email-ascending =
    .label = Sorter efter mailadresse (A > Å)
about-addressbook-sort-email-descending =
    .label = Sorter efter mailadresse (Å > A)

about-addressbook-confirm-delete-mixed-title = Slet kontakter og lister
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed = Er du sikker på, at du vil slette disse { $count } kontakter og lister?
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
    { $count ->
        [one] Slet liste
       *[other] Slet lister
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
    { $count ->
        [one] Er du sikker på, at du vil slette listen { $name }?
       *[other] Er du sikker på, at du vil slette disse { $count } lister?
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
    { $count ->
        [one] Fjern kontakt
       *[other] Fjern kontakter
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
# $name (String) - The name of the contact to be removed, if $count is 1.
# $list (String) - The name of the list that contacts will be removed from.
about-addressbook-confirm-remove-contacts =
    { $count ->
        [one] Er du sikker på, at du vil fjerne { $name } fra { $list }?
       *[other] Er du sikker på, at du vil fjerne disse { $count } kontakter fra { $list }?
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
about-addressbook-confirm-delete-contacts-title =
    { $count ->
        [one] Slet kontakt
       *[other] Slet kontakter
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
# $name (String) - The name of the contact to be deleted, if $count is 1.
about-addressbook-confirm-delete-contacts =
    { $count ->
        [one] Er du sikker på, at du vil slette kontakten { $name }?
       *[other] Er du sikker på, at du vil slette disse { $count } kontakter?
    }

## Details

about-addressbook-begin-edit-contact-button = Rediger
about-addressbook-cancel-edit-contact-button = Annuller
about-addressbook-save-edit-contact-button = Gem

about-addressbook-details-email-addresses-header = Mailadresser
about-addressbook-details-phone-numbers-header = Telefonnumre
about-addressbook-details-home-address-header = Hjemmeadresse
about-addressbook-details-work-address-header = Arbejdsadresse
about-addressbook-details-other-info-header = Anden information
