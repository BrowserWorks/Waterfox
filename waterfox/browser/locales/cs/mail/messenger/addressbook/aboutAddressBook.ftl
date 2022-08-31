# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Kontakty

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = Nová složka
about-addressbook-toolbar-add-carddav-address-book =
    .label = Přidat složku kontaktů CardDAV
about-addressbook-toolbar-add-ldap-address-book =
    .label = Přidat složku kontaktů LDAP
about-addressbook-toolbar-new-contact =
    .label = Nový kontakt
about-addressbook-toolbar-new-list =
    .label = Nová skupina
about-addressbook-toolbar-import =
    .label = Importovat

## Books

all-address-books = Všechny složky kontaktů
about-addressbook-books-context-properties =
    .label = Vlastnosti
about-addressbook-books-context-synchronize =
    .label = Synchronizovat
about-addressbook-books-context-edit =
    .label = Upravit
about-addressbook-books-context-print =
    .label = Tisk…
about-addressbook-books-context-export =
    .label = Exportovat…
about-addressbook-books-context-delete =
    .label = Smazat
about-addressbook-books-context-remove =
    .label = Odebrat
about-addressbook-books-context-startup-default =
    .label = Výchozí počáteční složka
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
    .placeholder = Najít ve složce { $name }
about-addressbook-search-all =
    .placeholder = Prohledat všechny složky kontaktů
about-addressbook-sort-button2 =
    .title = Zobrazení seznamu
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
about-addressbook-horizontal-layout =
    .label = Přepnout na rozložení na šířku
about-addressbook-vertical-layout =
    .label = Přepnout na rozložení na výšku

## Card column headers
## Each string is listed here twice, and the values should match.

about-addressbook-column-header-generatedname = Jméno
about-addressbook-column-label-generatedname =
    .label = { about-addressbook-column-header-generatedname }
about-addressbook-column-header-emailaddresses = E-mailové adresy
about-addressbook-column-label-emailaddresses =
    .label = { about-addressbook-column-header-emailaddresses }
about-addressbook-column-header-phonenumbers = Telefonní čísla
about-addressbook-column-label-phonenumbers =
    .label = { about-addressbook-column-header-phonenumbers }
about-addressbook-column-header-addresses = Adresy
about-addressbook-column-label-addresses =
    .label = { about-addressbook-column-header-addresses }
about-addressbook-column-header-title = Název
about-addressbook-column-label-title =
    .label = { about-addressbook-column-header-title }
about-addressbook-column-header-department = Oddělení
about-addressbook-column-label-department =
    .label = { about-addressbook-column-header-department }
about-addressbook-column-header-organization = Společnost
about-addressbook-column-label-organization =
    .label = { about-addressbook-column-header-organization }
about-addressbook-column-header-addrbook = Kontakty
about-addressbook-column-label-addrbook =
    .label = { about-addressbook-column-header-addrbook }
about-addressbook-cards-context-write =
    .label = Napsat
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

## Card list placeholder
## Shown when there are no cards in the list

about-addressbook-placeholder-empty-book = Nejsou zde žádné kontakty
about-addressbook-placeholder-new-contact = Nový kontakt
about-addressbook-placeholder-search-only = Tato složka kontaktů zobrazuje kontakty pouze po vyhledání
about-addressbook-placeholder-searching = Hledání…
about-addressbook-placeholder-no-search-results = Nebyly nalezeny žádné kontakty

## Details

about-addressbook-prefer-display-name = Upřednostnit zobrazované jméno před hlavičkou zprávy
about-addressbook-write-action-button = Napsat zprávu
about-addressbook-event-action-button = Událost
about-addressbook-search-action-button = Hledat
about-addressbook-begin-edit-contact-button = Upravit
about-addressbook-delete-edit-contact-button = Smazat
about-addressbook-cancel-edit-contact-button = Zrušit
about-addressbook-save-edit-contact-button = Uložit
about-addressbook-add-contact-to = Přidat do:
about-addressbook-details-email-addresses-header = E-mailové adresy
about-addressbook-details-phone-numbers-header = Telefonní čísla
about-addressbook-details-addresses-header = Adresy
about-addressbook-details-notes-header = Poznámky
about-addressbook-details-other-info-header = Další údaje
about-addressbook-entry-type-work = Práce
about-addressbook-entry-type-home = Domů
about-addressbook-entry-type-fax = Fax
about-addressbook-entry-type-cell = Mobil
about-addressbook-entry-type-pager = Pager
about-addressbook-entry-name-birthday = Narozeniny
about-addressbook-entry-name-anniversary = Výročí
about-addressbook-entry-name-title = Titul
about-addressbook-entry-name-role = Pozice
about-addressbook-entry-name-organization = Společnost
about-addressbook-entry-name-website = Webové stránky
about-addressbook-entry-name-time-zone = Časové pásmo
about-addressbook-unsaved-changes-prompt-title = Neuložené změny
about-addressbook-unsaved-changes-prompt = Chcete před opuštěním režimu úprav uložit provedené změny?

# Photo dialog

about-addressbook-photo-drop-target = Sem přetáhněte nebo vložte fotografii, nebo klepněte a vyberte soubor.
about-addressbook-photo-drop-loading = Načítání fotografie…
about-addressbook-photo-drop-error = Fotografii se nepodařilo načíst.
about-addressbook-photo-filepicker-title = Vyberte soubor s obrázkem
about-addressbook-photo-discard = Zahodit existující fotografii
about-addressbook-photo-cancel = Zrušit
about-addressbook-photo-save = Uložit
