# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Téléchargements
downloads-panel =
    .aria-label = Téléchargements

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Pause
    .accesskey = P
downloads-cmd-resume =
    .label = Reprendre
    .accesskey = R
downloads-cmd-cancel =
    .tooltiptext = Annuler
downloads-cmd-cancel-panel =
    .aria-label = Annuler

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Ouvrir le dossier contenant le fichier
    .accesskey = r

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Afficher dans le Finder
    .accesskey = F

downloads-cmd-use-system-default =
    .label = Ouvrir avec la visionneuse du système
    .accesskey = v

downloads-cmd-always-use-system-default =
    .label = Toujours ouvrir avec la visionneuse du système
    .accesskey = T

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Afficher dans le Finder
           *[other] Ouvrir le dossier contenant le fichier
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Afficher dans le Finder
           *[other] Ouvrir le dossier contenant le fichier
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Afficher dans le Finder
           *[other] Ouvrir le dossier contenant le fichier
        }

downloads-cmd-show-downloads =
    .label = Afficher le dossier des téléchargements
downloads-cmd-retry =
    .tooltiptext = Réessayer
downloads-cmd-retry-panel =
    .aria-label = Réessayer
downloads-cmd-go-to-download-page =
    .label = Aller à la page de téléchargement
    .accesskey = h
downloads-cmd-copy-download-link =
    .label = Copier l’adresse d’origine du téléchargement
    .accesskey = d
downloads-cmd-remove-from-history =
    .label = Retirer de l’historique
    .accesskey = e
downloads-cmd-clear-list =
    .label = Vider le panneau d’aperçu
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = Vider la liste des téléchargements
    .accesskey = V

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Autoriser le téléchargement
    .accesskey = o

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Supprimer le fichier

downloads-cmd-remove-file-panel =
    .aria-label = Supprimer le fichier

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Supprimer le fichier ou autoriser le téléchargement

downloads-cmd-choose-unblock-panel =
    .aria-label = Supprimer le fichier ou autoriser le téléchargement

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Ouvrir ou supprimer le fichier

downloads-cmd-choose-open-panel =
    .aria-label = Ouvrir ou supprimer le fichier

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Afficher plus d’informations

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Ouvrir le fichier

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Réessayer de télécharger

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Annuler le téléchargement

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Afficher tous les téléchargements
    .accesskey = i

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Détails du téléchargement

downloads-clear-downloads-button =
    .label = Vider la liste des téléchargements
    .tooltiptext = Vider la liste des téléchargements terminés, annulés et qui ont échoué

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Il n’y a aucun téléchargement.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Aucun téléchargement pour cette session.
