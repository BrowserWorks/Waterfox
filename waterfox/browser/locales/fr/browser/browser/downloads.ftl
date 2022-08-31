# This Source Code Form is subject to the terms of the Waterfox Public
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
downloads-panel-items =
    .style = width: 40em

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

downloads-cmd-show-menuitem-2 =
    .label =
        { PLATFORM() ->
            [macos] Afficher dans le Finder
           *[other] Afficher dans le dossier
        }
    .accesskey = A

## Displayed in the downloads context menu for files that can be opened.
## Variables:
##   $handler (String) - The name of the mime type's default file handler.
##   Example: "Notepad", "Acrobat Reader DC", "7-Zip File Manager"

downloads-cmd-use-system-default =
    .label = Ouvrir avec la visionneuse du système
    .accesskey = v
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-use-system-default-named =
    .label = Ouvrir dans { $handler }
    .accesskey = O

# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-use-system-default =
    .label = Toujours ouvrir avec la visionneuse du système
    .accesskey = T
# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-always-use-system-default-named =
    .label = Toujours ouvrir dans { $handler }
    .accesskey = T

##

# We can use the same accesskey as downloads-cmd-always-use-system-default.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-open-similar-files =
    .label = Toujours ouvrir les fichiers similaires
    .accesskey = T

downloads-cmd-show-button-2 =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Afficher dans le Finder
           *[other] Afficher dans le dossier
        }

downloads-cmd-show-panel-2 =
    .aria-label =
        { PLATFORM() ->
            [macos] Afficher dans le Finder
           *[other] Afficher dans le dossier
        }
downloads-cmd-show-description-2 =
    .value =
        { PLATFORM() ->
            [macos] Afficher dans le Finder
           *[other] Afficher dans le dossier
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
downloads-cmd-delete-file =
    .label = Supprimer
    .accesskey = S

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

## Displayed when the user clicked on a download in process. Indicates that the
## downloading file will be opened after certain amount of time using an app
## available in the system.
## Variables:
##   $hours (number) - Amount of hours left till the file opens.
##   $seconds (number) - Amount of seconds left till the file opens.
##   $minutes (number) - Amount of minutes till the file opens.

downloading-file-opens-in-hours-and-minutes = Ouverture dans { $hours } h { $minutes } min…
downloading-file-opens-in-minutes = Ouverture dans { $minutes } min…
downloading-file-opens-in-minutes-and-seconds = Ouverture dans { $minutes } min { $seconds } s…
downloading-file-opens-in-seconds = Ouverture dans { $seconds } s…
downloading-file-opens-in-some-time = Ouverture lorsque le téléchargement sera terminé…
downloading-file-click-to-open =
    .value = Ouvrir lorsque le téléchargement sera terminé

##

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

## Displayed when a site attempts to automatically download many files.
## Variables:
##   $num (number) - Number of blocked downloads.
##   $url (string) - The url of the suspicious site, stripped of http, https and www prefix.

downloads-files-not-downloaded =
    { $num ->
        [one] Fichier non téléchargé.
       *[other] { $num } fichiers non téléchargés.
    }
downloads-blocked-from-url = Téléchargements bloqués depuis { $url }.
downloads-blocked-download-detailed-info = { $url } a essayé de télécharger automatiquement de nombreux fichiers. Le site peut être défectueux ou en train de tenter d’enregistrer des fichiers de spam sur votre appareil.

##

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

# This is displayed in an item at the bottom of the Downloads Panel when there
# are more downloads than can fit in the list in the panel.
#   $count (number) - number of files being downloaded that are not shown in the
#                     panel list.
downloads-more-downloading =
    { $count ->
        [one] { $count } téléchargement de fichier supplémentaire
       *[other] { $count } téléchargements de fichiers supplémentaires
    }
