# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Rubrica

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = Nuova rubrica
about-addressbook-toolbar-add-carddav-address-book =
    .label = Aggiungi rubrica CardDAV
about-addressbook-toolbar-add-ldap-address-book =
    .label = Aggiungi rubrica LDAP
about-addressbook-toolbar-new-contact =
    .label = Nuovo contatto
about-addressbook-toolbar-new-list =
    .label = Nuova lista
about-addressbook-toolbar-import =
    .label = Importa

## Books

all-address-books = Tutte le rubriche
about-addressbook-books-context-properties =
    .label = Proprietà
about-addressbook-books-context-synchronize =
    .label = Sincronizza
about-addressbook-books-context-print =
    .label = Stampa…
about-addressbook-books-context-export =
    .label = Esporta…
about-addressbook-books-context-delete =
    .label = Elimina
about-addressbook-books-context-remove =
    .label = Elimina
about-addressbook-books-context-startup-default =
    .label = Directory di avvio predefinita
about-addressbook-confirm-delete-book-title = Elimina rubrica
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = Eliminare { $name } e tutti i contatti che contiene?
about-addressbook-confirm-remove-remote-book-title = Elimina rubrica
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = Eliminare { $name }?

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = Cerca in { $name }
about-addressbook-search-all =
    .placeholder = Cerca in tutte le rubriche
about-addressbook-sort-button =
    .title = Cambia ordine dell’elenco
about-addressbook-name-format-display =
    .label = Nome visualizzato
about-addressbook-name-format-firstlast =
    .label = Nome Cognome
about-addressbook-name-format-lastfirst =
    .label = Cognome, Nome
about-addressbook-sort-name-ascending =
    .label = Ordina per nome (A > Z)
about-addressbook-sort-name-descending =
    .label = Ordina per nome (Z > A)
about-addressbook-sort-email-ascending =
    .label = Ordina per indirizzo email (A > Z)
about-addressbook-sort-email-descending =
    .label = Ordina per indirizzo email (Z > A)
about-addressbook-cards-context-write =
    .label = Scrivi
about-addressbook-confirm-delete-mixed-title = Elimina contatti e liste
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed = Eliminare questi { $count } contatti e liste?
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
    { $count ->
        [one] Eliminazione lista
       *[other] Eliminazione liste
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
    { $count ->
        [one] Eliminare la lista { $name }?
       *[other] Eliminare queste { $count } liste?
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
    { $count ->
        [one] Eliminazione contatto
       *[other] Eliminazione contatti
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
# $name (String) - The name of the contact to be removed, if $count is 1.
# $list (String) - The name of the list that contacts will be removed from.
about-addressbook-confirm-remove-contacts =
    { $count ->
        [one] Eliminare { $name } dalla lista { $list }?
       *[other] Eliminare questi { $count } contatti dalla lista { $list }?
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
about-addressbook-confirm-delete-contacts-title =
    { $count ->
        [one] Eliminazione contatto
       *[other] Eliminazione contatti
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
# $name (String) - The name of the contact to be deleted, if $count is 1.
about-addressbook-confirm-delete-contacts =
    { $count ->
        [one] Eliminare il contatto { $name }?
       *[other] Eliminare questi { $count } contatti?
    }

## Details

about-addressbook-begin-edit-contact-button = Modifica
about-addressbook-cancel-edit-contact-button = Annulla
about-addressbook-save-edit-contact-button = Salva
about-addressbook-details-email-addresses-header = Indirizzi email
about-addressbook-details-phone-numbers-header = Numeri di telefono
about-addressbook-details-home-address-header = Indirizzo di casa
about-addressbook-details-work-address-header = Indirizzo di lavoro
about-addressbook-details-other-info-header = Altre informazioni
