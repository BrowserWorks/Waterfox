# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Adresboek

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = Nieuw adresboek
about-addressbook-toolbar-add-carddav-address-book =
    .label = CardDAV-adresboek toevoegen
about-addressbook-toolbar-add-ldap-address-book =
    .label = LDAP-adresboek toevoegen
about-addressbook-toolbar-new-contact =
    .label = Nieuw contact
about-addressbook-toolbar-new-list =
    .label = Nieuwe lijst
about-addressbook-toolbar-import =
    .label = Importeren

## Books

all-address-books = Alle adresboeken
about-addressbook-books-context-properties =
    .label = Eigenschappen
about-addressbook-books-context-synchronize =
    .label = Synchroniseren
about-addressbook-books-context-print =
    .label = Afdrukken…
about-addressbook-books-context-export =
    .label = Exporteren…
about-addressbook-books-context-delete =
    .label = Verwijderen
about-addressbook-books-context-remove =
    .label = Verwijderen
about-addressbook-books-context-startup-default =
    .label = Standaard opstartmap
about-addressbook-confirm-delete-book-title = Adresboek verwijderen
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = Weet u zeker dat u { $name } en alle contacten erin wilt verwijderen?
about-addressbook-confirm-remove-remote-book-title = Adresboek verwijderen
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = Weet u zeker dat u { $name } wilt verwijderen?

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = { $name } doorzoeken
about-addressbook-search-all =
    .placeholder = Alle adresboeken doorzoeken
about-addressbook-sort-button =
    .title = Lijstvolgorde wijzigen
about-addressbook-name-format-display =
    .label = Weergavenaam
about-addressbook-name-format-firstlast =
    .label = Voornaam Achternaam
about-addressbook-name-format-lastfirst =
    .label = Achternaam, Voornaam
about-addressbook-sort-name-ascending =
    .label = Sorteren op naam (A > Z)
about-addressbook-sort-name-descending =
    .label = Sorteren op naam (Z > A)
about-addressbook-sort-email-ascending =
    .label = Sorteren op e-mailadres (A > Z)
about-addressbook-sort-email-descending =
    .label = Sorteren op e-mailadres (Z > A)
about-addressbook-cards-context-write =
    .label = Opstellen
about-addressbook-confirm-delete-mixed-title = Contacten en lijsten verwijderen
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed = Weet u zeker dat u deze { $count } contacten en lijsten wilt verwijderen?
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
    { $count ->
        [one] Lijst verwijderen
       *[other] Lijsten verwijderen
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
    { $count ->
        [one] Weet u zeker dat u { $name } wilt verwijderen?
       *[other] Weet u zeker dat u deze { $count } lijsten wilt verwijderen?
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
    { $count ->
        [one] Contact verwijderen
       *[other] Contacten verwijderen
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
# $name (String) - The name of the contact to be removed, if $count is 1.
# $list (String) - The name of the list that contacts will be removed from.
about-addressbook-confirm-remove-contacts =
    { $count ->
        [one] Weet u zeker dat u { $name } uit { $list } wilt verwijderen?
       *[other] Weet u zeker dat u deze { $count } contacten uit { $list } wilt verwijderen?
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
about-addressbook-confirm-delete-contacts-title =
    { $count ->
        [one] Contact verwijderen
       *[other] Contacten verwijderen
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
# $name (String) - The name of the contact to be deleted, if $count is 1.
about-addressbook-confirm-delete-contacts =
    { $count ->
        [one] Weet u zeker dat u het contact { $name } wilt verwijderen?
       *[other] Weet u zeker dat u deze { $count } contacten wilt verwijderen?
    }

## Details

about-addressbook-begin-edit-contact-button = Bewerken
about-addressbook-cancel-edit-contact-button = Annuleren
about-addressbook-save-edit-contact-button = Opslaan
about-addressbook-details-email-addresses-header = E-mailadressen
about-addressbook-details-phone-numbers-header = Telefoonnummers
about-addressbook-details-home-address-header = Adres
about-addressbook-details-work-address-header = Werkadres
about-addressbook-details-other-info-header = Andere informatie
about-addressbook-prompt-to-save-title = Wijzigingen opslaan?
about-addressbook-prompt-to-save = Wilt u uw wijzigingen opslaan?
