# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = Gestion des cookies et des données de sites
site-data-settings-description = Les sites suivants stockent des cookies et des données de sites sur votre ordinateur. { -brand-short-name } conserve les données des sites avec stockage persistant jusqu’à ce que vous les supprimiez, et supprime les données des sites sans stockage persistant lorsque de l’espace supplémentaire est nécessaire.
site-data-search-textbox =
    .placeholder = Rechercher des sites web
    .accesskey = R
site-data-column-host =
    .label = Site
site-data-column-cookies =
    .label = Cookies
site-data-column-storage =
    .label = Stockage
site-data-column-last-used =
    .label = Dernière utilisation
# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = (fichier local)
site-data-remove-selected =
    .label = Supprimer les sites sélectionnés
    .accesskey = S
site-data-button-cancel =
    .label = Annuler
    .accesskey = A
site-data-button-save =
    .label = Enregistrer les changements
    .accesskey = E
site-data-settings-dialog =
    .buttonlabelaccept = Enregistrer les changements
    .buttonaccesskeyaccept = E
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value } (persistant)
site-data-remove-all =
    .label = Tout supprimer
    .accesskey = u
site-data-remove-shown =
    .label = Supprimer les sites affichés
    .accesskey = u

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = Supprimer
site-data-removing-header = Suppression des cookies et des données de sites
site-data-removing-desc = Supprimer les cookies et les données de sites peut vous déconnecter de ces sites web. Voulez-vous vraiment effectuer ces modifications ?
site-data-removing-table = Les cookies et les données associés aux sites suivants seront supprimés
