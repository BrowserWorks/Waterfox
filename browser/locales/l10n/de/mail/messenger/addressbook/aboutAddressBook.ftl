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

## Books

all-address-books = Alle Adressbücher

about-addressbook-books-context-properties =
  .label = Eigenschaften
about-addressbook-books-context-synchronize =
  .label = Synchronisieren
about-addressbook-books-context-print =
  .label = Drucken…
about-addressbook-books-context-delete =
  .label = Löschen

about-addressbook-books-context-remove =
  .label = Entfernen

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

## Details

about-addressbook-begin-edit-contact-button = Bearbeiten
about-addressbook-cancel-edit-contact-button = Abbrechen
about-addressbook-save-edit-contact-button = Speichern

about-addressbook-details-email-addresses-header = E-Mail-Adressen
about-addressbook-details-phone-numbers-header = Telefonnummern
about-addressbook-details-home-address-header = Privatadresse
about-addressbook-details-work-address-header = Dienstadresse
about-addressbook-details-other-info-header = Weitere Informationen
