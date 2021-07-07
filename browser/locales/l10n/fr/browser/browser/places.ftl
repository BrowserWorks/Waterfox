# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

places-open =
    .label = Ouvrir
    .accesskey = O
places-open-in-tab =
    .label = Ouvrir dans un nouvel onglet
    .accesskey = v
places-open-all-bookmarks =
    .label = Ouvrir tous les marque-pages
    .accesskey = O
places-open-all-in-tabs =
    .label = Tout ouvrir dans des onglets
    .accesskey = v
places-open-in-window =
    .label = Ouvrir dans une nouvelle fenêtre
    .accesskey = n
places-open-in-private-window =
    .label = Ouvrir dans une nouvelle fenêtre privée
    .accesskey = p
places-add-bookmark =
    .label = Ajouter un marque-page…
    .accesskey = o
places-add-folder-contextmenu =
    .label = Ajouter un dossier…
    .accesskey = d
places-add-folder =
    .label = Ajouter un dossier…
    .accesskey = o
places-add-separator =
    .label = Ajouter un séparateur
    .accesskey = s
places-view =
    .label = Trier
    .accesskey = T
places-by-date =
    .label = par date
    .accesskey = D
places-by-site =
    .label = par site
    .accesskey = S
places-by-most-visited =
    .label = par nombre de visites
    .accesskey = V
places-by-last-visited =
    .label = par date de dernière visite
    .accesskey = r
places-by-day-and-site =
    .label = par date et par site
    .accesskey = t
places-history-search =
    .placeholder = Rechercher dans l’historique
places-history =
    .aria-label = Historique
places-bookmarks-search =
    .placeholder = Rechercher dans les marque-pages
places-delete-domain-data =
    .label = Oublier ce site
    .accesskey = b
places-sortby-name =
    .label = Trier par nom
    .accesskey = m
# places-edit-bookmark and places-edit-generic will show one or the other and can have the same access key.
places-edit-bookmark =
    .label = Modifier le marque-page…
    .accesskey = i
places-edit-generic =
    .label = Modifier…
    .accesskey = i
places-edit-folder =
    .label = Renommer le dossier…
    .accesskey = r
places-remove-folder =
    .label =
        { $count ->
            [1] Supprimer le dossier
            [one] Supprimer le dossier
           *[other] Supprimer les dossiers
        }
    .accesskey = m
places-edit-folder2 =
    .label = Modifier le dossier…
    .accesskey = i
places-delete-folder =
    .label =
        { $count ->
            [one] Supprimer le dossier
           *[other] Supprimer les dossiers
        }
    .accesskey = S
# Managed bookmarks are created by an administrator and cannot be changed by the user.
managed-bookmarks =
    .label = Marque-pages gérés
# This label is used when a managed bookmarks folder doesn't have a name.
managed-bookmarks-subfolder =
    .label = Sous-dossier
# This label is used for the "Other Bookmarks" folder that appears in the bookmarks toolbar.
other-bookmarks-folder =
    .label = Autres marque-pages
# Variables:
# $count (number) - The number of elements being selected for removal.
places-remove-bookmark =
    .label =
        { $count ->
            [1] Supprimer le marque-page
            [one] Supprimer le marque-page
           *[other] Supprimer les marque-pages
        }
    .accesskey = e
# Variables:
# $count (number) - The number of elements being selected for removal.
places-delete-bookmark =
    .label =
        { $count ->
            [one] Supprimer le marque page
           *[other] Supprimer les marques pages
        }
    .accesskey = S
places-manage-bookmarks =
    .label = Organiser les marque-pages
    .accesskey = m
places-forget-about-this-site-confirmation-title = Oublier ce site
# Variables:
# $hostOrBaseDomain (string) - The base domain (or host in case there is no base domain) for which data is being removed
places-forget-about-this-site-confirmation-message = Cette action supprime toutes les données relatives à { $hostOrBaseDomain }, y compris l’historique, les mots de passe, les cookies, le cache et les préférences de contenu. Voulez-vous vraiment poursuivre ?
places-forget-about-this-site-forget = Oublier
places-library =
    .title = Bibliothèque
    .style = width:730px; height:500px;
places-organize-button =
    .label = Organiser
    .tooltiptext = Organiser les marque-pages
    .accesskey = O
places-organize-button-mac =
    .label = Organiser
    .tooltiptext = Organiser les marque-pages
places-file-close =
    .label = Fermer
    .accesskey = F
places-cmd-close =
    .key = w
places-view-button =
    .label = Affichage
    .tooltiptext = Modifier l’affichage
    .accesskey = A
places-view-button-mac =
    .label = Affichage
    .tooltiptext = Modifier l’affichage
places-view-menu-columns =
    .label = Afficher les colonnes
    .accesskey = c
places-view-menu-sort =
    .label = Trier par
    .accesskey = T
places-view-sort-unsorted =
    .label = (aucun tri)
    .accesskey = r
places-view-sort-ascending =
    .label = Ordre croissant (A > Z)
    .accesskey = A
places-view-sort-descending =
    .label = Ordre décroissant (Z > A)
    .accesskey = Z
places-maintenance-button =
    .label = Importation et sauvegarde
    .tooltiptext = Importer et sauvegarder les marque-pages
    .accesskey = I
places-maintenance-button-mac =
    .label = Importation et sauvegarde
    .tooltiptext = Importer et sauvegarder les marque-pages
places-cmd-backup =
    .label = Sauvegarder…
    .accesskey = v
places-cmd-restore =
    .label = Restaurer
    .accesskey = R
places-cmd-restore-from-file =
    .label = Choisir un fichier…
    .accesskey = C
places-import-bookmarks-from-html =
    .label = Importer des marque-pages au format HTML…
    .accesskey = I
places-export-bookmarks-to-html =
    .label = Exporter des marque-pages au format HTML…
    .accesskey = E
places-import-other-browser =
    .label = Importer des données d’un autre navigateur…
    .accesskey = m
places-view-sort-col-name =
    .label = Nom
places-view-sort-col-tags =
    .label = Étiquettes
places-view-sort-col-url =
    .label = Adresse
places-view-sort-col-most-recent-visit =
    .label = Dernière visite
places-view-sort-col-visit-count =
    .label = Nombre de visites
places-view-sort-col-date-added =
    .label = Date d’ajout
places-view-sort-col-last-modified =
    .label = Date de modification
places-cmd-find-key =
    .key = F
places-back-button =
    .tooltiptext = Retour en arrière
places-forward-button =
    .tooltiptext = Avancer
places-details-pane-select-an-item-description = Sélectionner un élément pour afficher et modifier ses propriétés
