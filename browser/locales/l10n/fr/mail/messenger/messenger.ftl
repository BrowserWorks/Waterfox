# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
    { $count ->
        [one] 1 message non lu
       *[other] { $count } messages non lus
    }

about-rights-notification-text = { -brand-short-name } est un logiciel libre et open source, réalisé par une communauté internationale de milliers de personnes.

## Content tabs

content-tab-page-loading-icon =
    .alt = Chargement de la page
content-tab-security-high-icon =
    .alt = La connexion est sécurisée
content-tab-security-broken-icon =
    .alt = La connexion n’est pas sécurisée

## Toolbar

addons-and-themes-toolbarbutton =
    .label = Modules complémentaires et thèmes
    .tooltiptext = Gestion de vos modules complémentaires

quick-filter-toolbarbutton =
    .label = Filtre rapide
    .tooltiptext = Filtrer les messages

redirect-msg-button =
    .label = Rediriger
    .tooltiptext = Rediriger le message sélectionné

## Folder Pane

folder-pane-toolbar =
    .toolbarname = Barre d’outils du panneau des dossiers
    .accesskey = d

folder-pane-toolbar-options-button =
    .tooltiptext = Options du panneau des dossiers

folder-pane-header-label = Dossiers

## Folder Toolbar Header Popup

folder-toolbar-hide-toolbar-toolbarbutton =
    .label = Masquer la barre d’outils
    .accesskey = M

show-all-folders-label =
    .label = Tous les dossiers
    .accesskey = T

show-unread-folders-label =
    .label = Dossiers non lus
    .accesskey = n

show-favorite-folders-label =
    .label = Dossiers préférés
    .accesskey = f

show-smart-folders-label =
    .label = Dossiers unifiés
    .accesskey = u

show-recent-folders-label =
    .label = Dossiers récents
    .accesskey = r

folder-toolbar-toggle-folder-compact-view =
    .label = Affichage compact
    .accesskey = c

## Menu

redirect-msg-menuitem =
    .label = Rediriger
    .accesskey = d

## AppMenu

# Since v89 we dropped the platforms distinction between Options or Preferences
# and consolidated everything with Preferences.
appmenu-preferences =
    .label = Préférences

appmenu-addons-and-themes =
    .label = Modules complémentaires et thèmes

appmenu-help-enter-troubleshoot-mode =
    .label = Mode de dépannage…

appmenu-help-exit-troubleshoot-mode =
    .label = Désactiver le mode de dépannage

appmenu-help-more-troubleshooting-info =
    .label = Plus d’informations de dépannage

appmenu-redirect-msg =
    .label = Rediriger

## Context menu

context-menu-redirect-msg =
    .label = Rediriger

## Message header pane

other-action-redirect-msg =
    .label = Rediriger

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = Gérer l’extension
    .accesskey = e
toolbar-context-menu-remove-extension =
    .label = Supprimer l’extension
    .accesskey = m

## Message headers

message-header-address-in-address-book-icon =
    .alt = L’adresse est dans le carnet d’adresses

message-header-address-not-in-address-book-icon =
    .alt = L’adresse n’est pas dans le carnet d’adresses

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Supprimer { $name } ?
addon-removal-confirmation-button = Supprimer
addon-removal-confirmation-message = Supprimer { $name } ainsi que sa configuration et ses données de { -brand-short-name } ?

caret-browsing-prompt-title = Navigation au curseur
caret-browsing-prompt-text = L’appui sur F7 active ou désactive la navigation au curseur. Cette fonction place un curseur déplaçable dans certains contenus, permettant de sélectionner du texte au clavier. Désirez-vous activer la navigation au curseur ?
caret-browsing-prompt-check-text = Ne plus demander à l’avenir.

repair-text-encoding-button =
    .label = Réparer l’encodage du texte
    .tooltiptext = Détermine l’encodage correct du texte en fonction du contenu

## no-reply handling

no-reply-title = Répondre non pris en charge
no-reply-message = L’adresse de réponse ({ $email }) n’apparaît pas être une adresse surveillée. Les messages envoyés à cette adresse ne seront probablement pas lus.
no-reply-reply-anyway-button = Répondre quand même
