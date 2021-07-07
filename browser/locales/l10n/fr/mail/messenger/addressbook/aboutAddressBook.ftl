# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Carnet d’adresses

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = Nouveau carnet d’adresses
about-addressbook-toolbar-new-carddav-address-book =
    .label = Nouveau carnet d’adresses CardDAV
about-addressbook-toolbar-new-ldap-address-book =
    .label = Nouveau carnet d’adresses LDAP
about-addressbook-toolbar-add-carddav-address-book =
    .label = Ajouter un carnet d’adresses CardDAV
about-addressbook-toolbar-add-ldap-address-book =
    .label = Ajouter un carnet d’adresses LDAP
about-addressbook-toolbar-new-contact =
    .label = Nouveau contact
about-addressbook-toolbar-new-list =
    .label = Nouvelle liste

## Books

all-address-books = Tous les carnets d’adresses
about-addressbook-books-context-properties =
    .label = Propriétés
about-addressbook-books-context-synchronize =
    .label = Synchroniser
about-addressbook-books-context-print =
    .label = Imprimer…
about-addressbook-books-context-delete =
    .label = Supprimer
about-addressbook-books-context-remove =
    .label = Supprimer
about-addressbook-confirm-delete-book-title = Supprimer le carnet d’adresses
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = Voulez-vous vraiment supprimer { $name } et tous ses contacts ?
about-addressbook-confirm-remove-remote-book-title = Supprimer le carnet d’adresses
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = Voulez-vous vraiment supprimer{ $name } ?

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = Rechercher { $name }
about-addressbook-search-all =
    .placeholder = Rechercher dans tous les carnets d’adresses
about-addressbook-sort-button =
    .title = Modifier l’ordre de la liste
about-addressbook-name-format-display =
    .label = Nom à afficher
about-addressbook-name-format-firstlast =
    .label = Prénom Nom
about-addressbook-name-format-lastfirst =
    .label = Nom, Prénom
about-addressbook-sort-name-ascending =
    .label = Trier par nom (A > Z)
about-addressbook-sort-name-descending =
    .label = Trier par nom (Z > A)
about-addressbook-sort-email-ascending =
    .label = Trier par adresse électronique (A > Z)
about-addressbook-sort-email-descending =
    .label = Trier par adresse électronique (Z > A)
about-addressbook-confirm-delete-mixed-title = Supprimer des contacts et des listes
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed = Voulez-vous vraiment supprimer ces { $count } contacts et listes ?
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
    { $count ->
        [one] Supprimer la liste
       *[other] Supprimer les listes
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
    { $count ->
        [one] Voulez-vous vraiment supprimer la liste { $name } ?
       *[other] Voulez-vous vraiment supprimer ces { $count } listes ?
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
    { $count ->
        [one] Supprimer le contact
       *[other] Supprimer les contacts
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
# $name (String) - The name of the contact to be removed, if $count is 1.
# $list (String) - The name of the list that contacts will be removed from.
about-addressbook-confirm-remove-contacts =
    { $count ->
        [one] Voulez-vous vraiment supprimer { $name } de { $list } ?
       *[other] Voulez-vous vraiment supprimer ces { $count } contacts de { $list } ?
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
about-addressbook-confirm-delete-contacts-title =
    { $count ->
        [one] Supprimer le contact
       *[other] Supprimer les contacts
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
# $name (String) - The name of the contact to be deleted, if $count is 1.
about-addressbook-confirm-delete-contacts =
    { $count ->
        [one] Voulez-vous vraiment supprimer le contact { $name } ?
       *[other] Voulez-vous vraiment supprimer ces { $count } contacts ?
    }

## Details

about-addressbook-begin-edit-contact-button = Modifier
about-addressbook-cancel-edit-contact-button = Annuler
about-addressbook-save-edit-contact-button = Enregistrer
about-addressbook-details-email-addresses-header = Adresses électroniques
about-addressbook-details-phone-numbers-header = Numéros de téléphone
about-addressbook-details-home-address-header = Adresse personnelle
about-addressbook-details-work-address-header = Adresse professionnelle
about-addressbook-details-other-info-header = Autres informations
