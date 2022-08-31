# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Adressebok

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = Ny adressebok
about-addressbook-toolbar-add-carddav-address-book =
    .label = Legg til CardDAV-adressebok
about-addressbook-toolbar-add-ldap-address-book =
    .label = Legg til LDAP-adressebok
about-addressbook-toolbar-new-contact =
    .label = Ny kontakt
about-addressbook-toolbar-new-list =
    .label = Ny liste
about-addressbook-toolbar-import =
    .label = Importer

## Books

all-address-books = Alle adressebøkene
about-addressbook-books-context-properties =
    .label = Eigenskapar
about-addressbook-books-context-synchronize =
    .label = Synkroniser
about-addressbook-books-context-edit =
    .label = Rediger
about-addressbook-books-context-print =
    .label = Skriv ut …
about-addressbook-books-context-export =
    .label = Eksporter…
about-addressbook-books-context-delete =
    .label = Slett
about-addressbook-books-context-remove =
    .label = Fjern
about-addressbook-books-context-startup-default =
    .label = Standard startmappe
about-addressbook-confirm-delete-book-title = Slett adressebok
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = Er du sikker på at du vil slette { $name } med alle kontaktane?
about-addressbook-confirm-remove-remote-book-title = Fjern adressebok
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = Er du sikker på at du vil fjerne { $name }?

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = Søk i { $name }
about-addressbook-search-all =
    .placeholder = Søk i alle adressebøkene
about-addressbook-sort-button2 =
    .title = Vis liste over visingsvala
about-addressbook-name-format-display =
    .label = Visingsnamn
about-addressbook-name-format-firstlast =
    .label = Fornamn Etternamn
about-addressbook-name-format-lastfirst =
    .label = Etternamn, Fornamn
about-addressbook-sort-name-ascending =
    .label = Sorter etter namn (A > Å)
about-addressbook-sort-name-descending =
    .label = Sorter etter namn (Å > A)
about-addressbook-sort-email-ascending =
    .label = Sorter etter e-postadresse (A > Å)
about-addressbook-sort-email-descending =
    .label = Sorter etter e-postadresse (Å > A)
about-addressbook-horizontal-layout =
    .label = Byt til horisontal utsjånad
about-addressbook-vertical-layout =
    .label = Byt til vertikal utsjånad

## Card column headers
## Each string is listed here twice, and the values should match.

about-addressbook-column-header-generatedname = Namn
about-addressbook-column-label-generatedname =
    .label = { about-addressbook-column-header-generatedname }
about-addressbook-column-header-emailaddresses = E-postadresser
about-addressbook-column-label-emailaddresses =
    .label = { about-addressbook-column-header-emailaddresses }
about-addressbook-column-header-phonenumbers = Telefonnummer
about-addressbook-column-label-phonenumbers =
    .label = { about-addressbook-column-header-phonenumbers }
about-addressbook-column-header-addresses = Adresser
about-addressbook-column-label-addresses =
    .label = { about-addressbook-column-header-addresses }
about-addressbook-column-header-title = Tittel
about-addressbook-column-label-title =
    .label = { about-addressbook-column-header-title }
about-addressbook-column-header-department = Avdeling
about-addressbook-column-label-department =
    .label = { about-addressbook-column-header-department }
about-addressbook-column-header-organization = Organisasjon
about-addressbook-column-label-organization =
    .label = { about-addressbook-column-header-organization }
about-addressbook-column-header-addrbook = Adressebok
about-addressbook-column-label-addrbook =
    .label = { about-addressbook-column-header-addrbook }
about-addressbook-cards-context-write =
    .label = Skriv til
about-addressbook-confirm-delete-mixed-title = Slett kontaktar og lister
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed = Er du sikker på at du vil slette { $count } kontaktar og lister?
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
    { $count ->
        [one] Slett liste
       *[other] Slett lister
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
    { $count ->
        [one] Er du sikker på at du vil slette lista { $name }?
       *[other] Er du sikker på at du vil slette { $count } lister?
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
    { $count ->
        [one] Fjern kontakt
       *[other] Fjern kontaktar
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
# $name (String) - The name of the contact to be removed, if $count is 1.
# $list (String) - The name of the list that contacts will be removed from.
about-addressbook-confirm-remove-contacts =
    { $count ->
        [one] Er du sikker på at du vil fjerne { $name } frå { $list }?
       *[other] Er du sikker på at du vil fjerne { $count } kontaktar frå { $list }?
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
about-addressbook-confirm-delete-contacts-title =
    { $count ->
        [one] Slett kontakt
       *[other] Slett kontaktar
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
# $name (String) - The name of the contact to be deleted, if $count is 1.
about-addressbook-confirm-delete-contacts =
    { $count ->
        [one] Er du sikker på at du vil slette kontakten { $name }?
       *[other] Er du sikker på at du vil slette { $count } kontaktar?
    }

## Card list placeholder
## Shown when there are no cards in the list

about-addressbook-placeholder-empty-book = Ingen tilgjengelege kontaktar
about-addressbook-placeholder-new-contact = Ny kontakt
about-addressbook-placeholder-search-only = Denne adresseboka viser kontaktar berre etter at du har gjort eit søk
about-addressbook-placeholder-searching = Søkjer …
about-addressbook-placeholder-no-search-results = Ingen kontaktar funne

## Details

about-addressbook-prefer-display-name = Føretrekk visingsnamn i staden for namnet i meldingshovudet
about-addressbook-write-action-button = Skriv til
about-addressbook-event-action-button = Hending
about-addressbook-search-action-button = Søk
about-addressbook-begin-edit-contact-button = Rediger
about-addressbook-delete-edit-contact-button = Slett
about-addressbook-cancel-edit-contact-button = Avbryt
about-addressbook-save-edit-contact-button = Lagre
about-addressbook-add-contact-to = Legg til i:
about-addressbook-details-email-addresses-header = E-postadresser
about-addressbook-details-phone-numbers-header = Telefonnummer
about-addressbook-details-addresses-header = Adresser
about-addressbook-details-notes-header = Notat
about-addressbook-details-other-info-header = Annan informasjon
about-addressbook-entry-type-work = Arbeid
about-addressbook-entry-type-home = Heim
about-addressbook-entry-type-fax = Faks
# Or "Mobile"
about-addressbook-entry-type-cell = Mobil
about-addressbook-entry-type-pager = Personsøkjar
about-addressbook-entry-name-birthday = Fødselsdag
about-addressbook-entry-name-anniversary = Merkedag
about-addressbook-entry-name-title = Tittel
about-addressbook-entry-name-role = Rolle
about-addressbook-entry-name-organization = Organisasjon
about-addressbook-entry-name-website = Nettstad
about-addressbook-entry-name-time-zone = Tidssone
about-addressbook-unsaved-changes-prompt-title = Ulagra endringar
about-addressbook-unsaved-changes-prompt = Vil du lagre endringane før du forlét redigeringsvisinga?

# Photo dialog

about-addressbook-photo-drop-target = Slepp eller lim inn eit bilde her, eller trykk for å velje ei fil.
about-addressbook-photo-drop-loading = Lastar inn bilde …
about-addressbook-photo-drop-error = Klarte ikkje å laste inn foto.
about-addressbook-photo-filepicker-title = Vel ei bildefil
about-addressbook-photo-discard = Avvis eksisterande foto
about-addressbook-photo-cancel = Avbryt
about-addressbook-photo-save = Lagre
