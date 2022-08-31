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
about-addressbook-toolbar-import =
    .label = Importer

## Books

all-address-books = Alle adressebøger
about-addressbook-books-context-properties =
    .label = Egenskaber
about-addressbook-books-context-synchronize =
    .label = Synkroniser
about-addressbook-books-context-edit =
    .label = Rediger
about-addressbook-books-context-print =
    .label = Udskriv…
about-addressbook-books-context-export =
    .label = Eksporter…
about-addressbook-books-context-delete =
    .label = Slet
about-addressbook-books-context-remove =
    .label = Fjern
about-addressbook-books-context-startup-default =
    .label = Standardmappe ved start
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
about-addressbook-sort-button2 =
    .title = Listevisningsmuligheder
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
about-addressbook-horizontal-layout =
    .label = Skift til vandret layout
about-addressbook-vertical-layout =
    .label = Skift til lodret layout

## Card column headers
## Each string is listed here twice, and the values should match.

about-addressbook-column-header-generatedname = Navn
about-addressbook-column-label-generatedname =
    .label = { about-addressbook-column-header-generatedname }
about-addressbook-column-header-emailaddresses = Mailadresser
about-addressbook-column-label-emailaddresses =
    .label = { about-addressbook-column-header-emailaddresses }
about-addressbook-column-header-phonenumbers = Telefonnumre
about-addressbook-column-label-phonenumbers =
    .label = { about-addressbook-column-header-phonenumbers }
about-addressbook-column-header-addresses = Adresser
about-addressbook-column-label-addresses =
    .label = { about-addressbook-column-header-addresses }
about-addressbook-column-header-title = Titel
about-addressbook-column-label-title =
    .label = { about-addressbook-column-header-title }
about-addressbook-column-header-department = Afdeling
about-addressbook-column-label-department =
    .label = { about-addressbook-column-header-department }
about-addressbook-column-header-organization = Organisation
about-addressbook-column-label-organization =
    .label = { about-addressbook-column-header-organization }
about-addressbook-column-header-addrbook = Adressebog
about-addressbook-column-label-addrbook =
    .label = { about-addressbook-column-header-addrbook }
about-addressbook-cards-context-write =
    .label = Skriv
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

## Card list placeholder
## Shown when there are no cards in the list

about-addressbook-placeholder-empty-book = Ingen tilgængelige kontakter
about-addressbook-placeholder-new-contact = Ny kontakt
about-addressbook-placeholder-search-only = Denne adressebog viser kun kontakter efter en søgning
about-addressbook-placeholder-searching = Søger…
about-addressbook-placeholder-no-search-results = Ingen kontakter fundet

## Details

about-addressbook-prefer-display-name = Foretræk visningsnavn frem for navnet i meddelelses-headeren
about-addressbook-write-action-button = Skriv
about-addressbook-event-action-button = Begivenhed
about-addressbook-search-action-button = Søg
about-addressbook-begin-edit-contact-button = Rediger
about-addressbook-delete-edit-contact-button = Slet
about-addressbook-cancel-edit-contact-button = Annuller
about-addressbook-save-edit-contact-button = Gem
about-addressbook-add-contact-to = Føj til:
about-addressbook-details-email-addresses-header = Mailadresser
about-addressbook-details-phone-numbers-header = Telefonnumre
about-addressbook-details-addresses-header = Adresser
about-addressbook-details-notes-header = Noter
about-addressbook-details-other-info-header = Anden information
about-addressbook-entry-type-work = Arbejde
about-addressbook-entry-type-home = Hjem
about-addressbook-entry-type-fax = Fax
about-addressbook-entry-type-cell = Mobil
about-addressbook-entry-type-pager = Personsøger
about-addressbook-entry-name-birthday = Fødselsdag
about-addressbook-entry-name-anniversary = Jubilæum
about-addressbook-entry-name-title = Titel
about-addressbook-entry-name-role = Rolle
about-addressbook-entry-name-organization = Organisation
about-addressbook-entry-name-website = Websted
about-addressbook-entry-name-time-zone = Tidszone
about-addressbook-unsaved-changes-prompt-title = Ugemte ændringer
about-addressbook-unsaved-changes-prompt = Vil du gemme dine ændringer, inden du forlader redigeringsvisningen?

# Photo dialog

about-addressbook-photo-drop-target = Slip eller indsæt et billede her, eller klik for at vælge en fil.
about-addressbook-photo-drop-loading = Indlæser billede...
about-addressbook-photo-drop-error = Billedet kunne ikke indlæses.
about-addressbook-photo-filepicker-title = Vælg en billedfil
about-addressbook-photo-discard = Kassér eksisterende billede
about-addressbook-photo-cancel = Fortryd
about-addressbook-photo-save = Gem
