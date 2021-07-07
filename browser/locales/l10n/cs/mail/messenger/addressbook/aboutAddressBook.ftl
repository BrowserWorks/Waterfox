# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Kontakty

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = Nový adresář
about-addressbook-toolbar-new-carddav-address-book =
    .label = Nová složka kontaktů CardDAV
about-addressbook-toolbar-new-ldap-address-book =
    .label = Nová složka kontaktů LDAP
about-addressbook-toolbar-add-carddav-address-book =
    .label = Přidat složku kontaktů CardDAV
about-addressbook-toolbar-add-ldap-address-book =
    .label = Přidat složku kontaktů LDAP
about-addressbook-toolbar-new-contact =
    .label = Nový kontakt
about-addressbook-toolbar-new-list =
    .label = Nová skupina

## Books

all-address-books = Všechny složky kontaktů
about-addressbook-books-context-properties =
    .label = Vlastnosti
about-addressbook-books-context-synchronize =
    .label = Synchronizovat
about-addressbook-books-context-print =
    .label = Tisk…
about-addressbook-books-context-delete =
    .label = Smazat
about-addressbook-books-context-remove =
    .label = Odebrat
about-addressbook-confirm-delete-book-title = Smazat složku kontaktů
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = Opravdu chcete smazat složku { $name } a všechny v ní obsažené kontakty?
about-addressbook-confirm-remove-remote-book-title = Odebrat složku kontaktů
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = Opravdu chcete odebrat složku kontaktů { $name }?

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = Najít { $name }
about-addressbook-search-all =
    .placeholder = Prohledat všechny adresáře
about-addressbook-sort-button =
    .title = Změnit pořadí seznamu
about-addressbook-name-format-display =
    .label = Zobrazované jméno
about-addressbook-name-format-firstlast =
    .label = Jméno Příjmení
about-addressbook-name-format-lastfirst =
    .label = Příjmení, Jméno
about-addressbook-sort-name-ascending =
    .label = Seřadit podle jména
about-addressbook-sort-name-descending =
    .label = Seřadit podle jména (pozpátku)
about-addressbook-sort-email-ascending =
    .label = Seřadit podle e-mailové adresy
about-addressbook-sort-email-descending =
    .label = Seřadit podle e-mailové adresy (pozpátku)
about-addressbook-confirm-delete-mixed-title = Smazat kontakty a skupiny
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed =
    { $count ->
        [one] Opravdu chcete smazat tento kontakt nebo seznam kontaktů?
        [few] Opravdu chcete smazat tyto { $count } kontakty a seznamy kontaktů?
       *[other] Opravdu chcete smazat těchto { $count } kontaktů a seznamů kontaktů?
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
    { $count ->
        [one] Smazat seznam
        [few] Smazat seznamy
       *[other] Smazat seznamy
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
    { $count ->
        [one] Opravdu chcete smazat seznam kontaktů { $name }?
        [few] Opravdu chcete smazat tyto { $count } seznamy kontaktů?
       *[other] Opravdu chcete smazat těchto { $count } seznamů kontaktů?
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
    { $count ->
        [one] Odebrat kontakt
        [few] Odebrat kontakty
       *[other] Odebrat kontakty
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
# $name (String) - The name of the contact to be removed, if $count is 1.
# $list (String) - The name of the list that contacts will be removed from.
about-addressbook-confirm-remove-contacts =
    { $count ->
        [one] Opravdu chcete odebrat tento kontakt ze seznam { $list }?
        [few] Opravdu chcete odebrat tyto { $count } kontakty ze seznamu { $list }?
       *[other] Opravdu chcete odebrat těchto { $count } kontaktů ze seznamu { $list }?
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
about-addressbook-confirm-delete-contacts-title =
    { $count ->
        [one] Smazat kontakt
        [few] Smazat kontakty
       *[other] Smazat kontakty
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
# $name (String) - The name of the contact to be deleted, if $count is 1.
about-addressbook-confirm-delete-contacts =
    { $count ->
        [one] Opravdu chcete smazat kontakt { $name }?
        [few] Opravdu chcete smazat tyto { $count } kontakty?
       *[other] Opravdu chcete smazat těchto { $count } kontaktů?
    }

## Details

about-addressbook-begin-edit-contact-button = Upravit
about-addressbook-cancel-edit-contact-button = Zrušit
about-addressbook-save-edit-contact-button = Uložit
about-addressbook-details-email-addresses-header = E-mailové adresy
about-addressbook-details-phone-numbers-header = Telefonní čísla
about-addressbook-details-home-address-header = Adresy domů
about-addressbook-details-work-address-header = Adresy do zaměstnání
about-addressbook-details-other-info-header = Další údaje
