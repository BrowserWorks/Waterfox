# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Carnet d’adresses

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = Nouveau carnet d’adresses
about-addressbook-toolbar-add-carddav-address-book =
    .label = Ajouter un carnet d’adresses CardDAV
about-addressbook-toolbar-add-ldap-address-book =
    .label = Ajouter un carnet d’adresses LDAP
about-addressbook-toolbar-new-contact =
    .label = Nouveau contact
about-addressbook-toolbar-new-list =
    .label = Nouvelle liste
about-addressbook-toolbar-import =
    .label = Importer

## Books

all-address-books = Tous les carnets d’adresses
about-addressbook-books-context-properties =
    .label = Propriétés
about-addressbook-books-context-synchronize =
    .label = Synchroniser
about-addressbook-books-context-edit =
    .label = Modifier
about-addressbook-books-context-print =
    .label = Imprimer…
about-addressbook-books-context-export =
    .label = Exporter…
about-addressbook-books-context-delete =
    .label = Supprimer
about-addressbook-books-context-remove =
    .label = Supprimer
about-addressbook-books-context-startup-default =
    .label = Annuaire par défaut
about-addressbook-confirm-delete-book-title = Supprimer le carnet d’adresses
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = Voulez-vous vraiment supprimer { $name } et tous ses contacts ?
about-addressbook-confirm-remove-remote-book-title = Supprimer le carnet d’adresses
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = Voulez-vous vraiment supprimer { $name } ?

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = Rechercher dans { $name }
about-addressbook-search-all =
    .placeholder = Rechercher dans tous les carnets d’adresses
about-addressbook-sort-button2 =
    .title = Options d’affichage de la liste
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
about-addressbook-horizontal-layout =
    .label = Passer à la disposition horizontale
about-addressbook-vertical-layout =
    .label = Passer à la disposition verticale

## Card column headers
## Each string is listed here twice, and the values should match.

about-addressbook-column-header-generatedname = Nom
about-addressbook-column-label-generatedname =
    .label = { about-addressbook-column-header-generatedname }
about-addressbook-column-header-emailaddresses = Adresses électroniques
about-addressbook-column-label-emailaddresses =
    .label = { about-addressbook-column-header-emailaddresses }
about-addressbook-column-header-phonenumbers = Numéros de téléphone
about-addressbook-column-label-phonenumbers =
    .label = { about-addressbook-column-header-phonenumbers }
about-addressbook-column-header-addresses = Adresses
about-addressbook-column-label-addresses =
    .label = { about-addressbook-column-header-addresses }
about-addressbook-column-header-title = Fonction
about-addressbook-column-label-title =
    .label = { about-addressbook-column-header-title }
about-addressbook-column-header-department = Service
about-addressbook-column-label-department =
    .label = { about-addressbook-column-header-department }
about-addressbook-column-header-organization = Société
about-addressbook-column-label-organization =
    .label = { about-addressbook-column-header-organization }
about-addressbook-column-header-addrbook = Carnet d’adresses
about-addressbook-column-label-addrbook =
    .label = { about-addressbook-column-header-addrbook }
about-addressbook-cards-context-write =
    .label = Écrire
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

## Card list placeholder
## Shown when there are no cards in the list

about-addressbook-placeholder-empty-book = Aucun contact disponible
about-addressbook-placeholder-new-contact = Nouveau contact
about-addressbook-placeholder-search-only = Ce carnet d’adresses affiche uniquement les contacts lorsque vous effectuez une recherche
about-addressbook-placeholder-searching = Recherche…
about-addressbook-placeholder-no-search-results = Aucun contact trouvé

## Details

about-addressbook-prefer-display-name = Préférer le nom à afficher plutôt que l’en-tête de message
about-addressbook-write-action-button = Écrire
about-addressbook-event-action-button = Évènement
about-addressbook-search-action-button = Rechercher
about-addressbook-begin-edit-contact-button = Modifier
about-addressbook-delete-edit-contact-button = Supprimer
about-addressbook-cancel-edit-contact-button = Annuler
about-addressbook-save-edit-contact-button = Enregistrer
about-addressbook-add-contact-to = Ajouter à :
about-addressbook-details-email-addresses-header = Adresses électroniques
about-addressbook-details-phone-numbers-header = Numéros de téléphone
about-addressbook-details-addresses-header = Adresses
about-addressbook-details-notes-header = Notes
about-addressbook-details-other-info-header = Autres informations
about-addressbook-entry-type-work = Professionnel
about-addressbook-entry-type-home = Domicile
about-addressbook-entry-type-fax = Fax
about-addressbook-entry-type-cell = Téléphone portable
about-addressbook-entry-type-pager = Pager
about-addressbook-entry-name-birthday = Anniversaire
about-addressbook-entry-name-anniversary = Date d’anniversaire
about-addressbook-entry-name-title = Fonction
about-addressbook-entry-name-role = Rôle
about-addressbook-entry-name-organization = Société
about-addressbook-entry-name-website = Site web
about-addressbook-entry-name-time-zone = Fuseau horaire
about-addressbook-unsaved-changes-prompt-title = Modifications non enregistrées
about-addressbook-unsaved-changes-prompt = Voulez-vous enregistrer vos modifications avant de quitter la vue d’édition ?

# Photo dialog

about-addressbook-photo-drop-target = Déposez ou collez une photo ici, ou cliquez pour sélectionner un fichier.
about-addressbook-photo-drop-loading = Chargement de la photo…
about-addressbook-photo-drop-error = Échec du chargement de la photo.
about-addressbook-photo-filepicker-title = Sélectionner un fichier d’image
about-addressbook-photo-discard = Supprimer la photo existante
about-addressbook-photo-cancel = Annuler
about-addressbook-photo-save = Enregistrer
