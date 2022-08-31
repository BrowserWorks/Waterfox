# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Adressbuch

## Toolbar

about-addressbook-toolbar-new-address-book =
  .label = Neues Adressbuch
about-addressbook-toolbar-add-carddav-address-book =
  .label = CardDAV-Adressbuch hinzufügen
about-addressbook-toolbar-add-ldap-address-book =
  .label = LDAP-Adressbuch hinzufügen
about-addressbook-toolbar-new-contact =
  .label = Neuer Kontakt
about-addressbook-toolbar-new-list =
  .label = Neue Verteilerliste
about-addressbook-toolbar-import =
  .label = Importieren

## Books

all-address-books = Alle Adressbücher

about-addressbook-books-context-properties =
  .label = Eigenschaften
about-addressbook-books-context-synchronize =
  .label = Synchronisieren
about-addressbook-books-context-edit =
  .label = Bearbeiten
about-addressbook-books-context-print =
  .label = Drucken…
about-addressbook-books-context-export =
  .label = Exportieren…
about-addressbook-books-context-delete =
  .label = Löschen
about-addressbook-books-context-remove =
  .label = Entfernen
about-addressbook-books-context-startup-default =
  .label = Standardadressbuch beim Start

about-addressbook-confirm-delete-book-title = Adressbuch löschen
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book =
  Soll { $name } einschließlich aller darin enthaltenen Kontakte gelöscht werden?
about-addressbook-confirm-remove-remote-book-title = Adressbuch entfernen
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book =
  Soll { $name } entfernt werden?

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
  .placeholder = In { $name } suchen
about-addressbook-search-all =
  .placeholder = In allen Adressbüchern suchen

about-addressbook-sort-button =
  .title = Sortierregel ändern

about-addressbook-sort-button2 =
  .title = Anzeigeoptionen öffnen

about-addressbook-name-format-display =
  .label = Anzeigename
about-addressbook-name-format-firstlast =
  .label = Vorname Nachname
about-addressbook-name-format-lastfirst =
  .label = Nachname, Vorname

about-addressbook-sort-name-ascending =
  .label = Nach Namen (A > Z) sortieren
about-addressbook-sort-name-descending =
  .label = Nach Namen (Z > A) sortieren
about-addressbook-sort-email-ascending =
  .label = Nach E-Mail-Adresse (A > Z) sortieren
about-addressbook-sort-email-descending =
  .label = Nach E-Mail-Adresse (Z > A) sortieren

about-addressbook-horizontal-layout =
  .label = Horizontale Darstellung verwenden
about-addressbook-vertical-layout =
  .label = Vertikale Darstellung verwenden

## Card column headers
## Each string is listed here twice, and the values should match.

about-addressbook-column-header-generatedname = Name
about-addressbook-column-label-generatedname =
  .label = { about-addressbook-column-header-generatedname }
about-addressbook-column-header-emailaddresses = E-Mail-Adressen
about-addressbook-column-label-emailaddresses =
  .label = { about-addressbook-column-header-emailaddresses }
about-addressbook-column-header-phonenumbers = Telefonnummern
about-addressbook-column-label-phonenumbers =
  .label = { about-addressbook-column-header-phonenumbers }
about-addressbook-column-header-addresses = Adressen
about-addressbook-column-label-addresses =
  .label = { about-addressbook-column-header-addresses }
about-addressbook-column-header-title = Titel
about-addressbook-column-label-title =
  .label = { about-addressbook-column-header-title }
about-addressbook-column-header-department = Abteilung
about-addressbook-column-label-department =
  .label = { about-addressbook-column-header-department }
about-addressbook-column-header-organization = Organisation
about-addressbook-column-label-organization =
  .label = { about-addressbook-column-header-organization }
about-addressbook-column-header-addrbook = Adressbuch
about-addressbook-column-label-addrbook =
  .label = { about-addressbook-column-header-addrbook }

about-addressbook-cards-context-write =
  .label = Nachricht verfassen

about-addressbook-confirm-delete-mixed-title = Kontakte und Verteilerlisten löschen
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed =
  Sollen diese { $count } Kontakte und Verteilerlisten gelöscht werden?
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
  { $count ->
     [one] Verteilerliste löschen
    *[other] Verteilerlisten löschen
  }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
  { $count ->
     [one] Soll die Verteilerliste { $name } gelöscht werden?
    *[other] Sollen diese { $count } Verteilerlisten gelöscht werden?
  }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
  { $count ->
     [one] Kontakt entfernen
    *[other] Kontakte entfernen
  }
# Variables:
# $count (Number) - The number of contacts to be removed.
# $name (String) - The name of the contact to be removed, if $count is 1.
# $list (String) - The name of the list that contacts will be removed from.
about-addressbook-confirm-remove-contacts =
  { $count ->
     [one] Soll { $name } aus { $list } entfernt werden?
    *[other] Sollen diese { $count } Kontakte aus { $list } entfernt werden?
  }
# Variables:
# $count (Number) - The number of contacts to be deleted.
about-addressbook-confirm-delete-contacts-title =
  { $count ->
     [one] Kontakt löschen
    *[other] Kontakte löschen
  }
# Variables:
# $count (Number) - The number of contacts to be deleted.
# $name (String) - The name of the contact to be deleted, if $count is 1.
about-addressbook-confirm-delete-contacts =
  { $count ->
     [one] Soll der Kontakt { $name } gelöscht werden?
    *[other] Sollen diese { $count } Kontakte gelöscht werden?
  }

## Card list placeholder
## Shown when there are no cards in the list

about-addressbook-placeholder-empty-book = Keine Kontakte gefunden
about-addressbook-placeholder-new-contact = Neuer Kontakt
about-addressbook-placeholder-search-only = Dieses Adressbuch zeigt Kontakte nur für eine Suche an.
about-addressbook-placeholder-searching = Suche wird durchgeführt…
about-addressbook-placeholder-no-search-results = Keine Kontakte gefunden

## Details

about-addressbook-prefer-display-name = Anzeigenamen statt Namen aus Kopfzeile der Nachricht verwenden

about-addressbook-write-action-button = Nachricht
about-addressbook-event-action-button = Termin
about-addressbook-search-action-button = Suchen

about-addressbook-begin-edit-contact-button = Bearbeiten
about-addressbook-delete-edit-contact-button = Löschen
about-addressbook-cancel-edit-contact-button = Abbrechen
about-addressbook-save-edit-contact-button = Speichern

about-addressbook-add-contact-to = Hinzufügen zu:

about-addressbook-details-email-addresses-header = E-Mail-Adressen
about-addressbook-details-phone-numbers-header = Telefonnummern
about-addressbook-details-home-address-header = Privatadresse
about-addressbook-details-work-address-header = Dienstadresse
about-addressbook-details-addresses-header = Adressen
about-addressbook-details-notes-header = Notizen
about-addressbook-details-other-info-header = Weitere Informationen

about-addressbook-entry-type-work = Dienstlich
about-addressbook-entry-type-home = Privat
about-addressbook-entry-type-fax = Fax
about-addressbook-entry-type-cell = Mobil
about-addressbook-entry-type-pager = Pager

about-addressbook-entry-name-birthday = Geburtstag
about-addressbook-entry-name-anniversary = Jubiläum
about-addressbook-entry-name-title = Titel
about-addressbook-entry-name-role = Position
about-addressbook-entry-name-department = Abteilung
about-addressbook-entry-name-organization = Organisation
about-addressbook-entry-name-website = Website
about-addressbook-entry-name-time-zone = Zeitzone

about-addressbook-unsaved-changes-prompt-title = Nicht gespeicherte Änderungen
about-addressbook-unsaved-changes-prompt = Sollen die Änderungen vor dem Schließen der Bearbeitung gespeichert werden?

# Photo dialog

about-addressbook-photo-drop-target = Foto hierher ziehen, einfügen oder anklicken, um Datei auszuwählen.
about-addressbook-photo-drop-loading = Foto wird geladen…
about-addressbook-photo-drop-error = Fehler beim Laden des Fotos
about-addressbook-photo-filepicker-title = Bilddatei auswählen

about-addressbook-photo-discard = Bestehendes Foto verwerfen
about-addressbook-photo-cancel = Abbrechen
about-addressbook-photo-save = Speichern
