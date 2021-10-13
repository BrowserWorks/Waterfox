# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Paramètres d’effacement de l’historique
    .style = width: 36em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Effacer l’historique récent
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Supprimer tout l’historique
    .style = width: 34em

clear-data-settings-label = À la fermeture de { -brand-short-name }, supprimer automatiquement les éléments suivants

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Intervalle à effacer :{ " " }
    .accesskey = I

clear-time-duration-value-last-hour =
    .label = la dernière heure

clear-time-duration-value-last-2-hours =
    .label = les deux dernières heures

clear-time-duration-value-last-4-hours =
    .label = les quatre dernières heures

clear-time-duration-value-today =
    .label = aujourd’hui

clear-time-duration-value-everything =
    .label = tout

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Historique

item-history-and-downloads =
    .label = Historique de navigation et des téléchargements
    .accesskey = H

item-cookies =
    .label = Cookies
    .accesskey = C

item-active-logins =
    .label = Connexions actives
    .accesskey = x

item-cache =
    .label = Cache
    .accesskey = a

item-form-search-history =
    .label = Historique des formulaires et des recherches
    .accesskey = F

data-section-label = Données

item-site-preferences =
    .label = Préférences de site
    .accesskey = P

item-site-settings =
    .label = Paramètres de site
    .accesskey = P

item-offline-apps =
    .label = Données de sites web hors connexion
    .accesskey = W

sanitize-everything-undo-warning = Cette action est irréversible.

window-close =
    .key = w

sanitize-button-ok =
    .label = Effacer maintenant

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Effacement

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Tout l’historique sera effacé.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Tous les éléments sélectionnés seront effacés.
