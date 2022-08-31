# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Window controls

messenger-window-minimize-button =
    .tooltiptext = Réduire
messenger-window-maximize-button =
    .tooltiptext = Agrandir
messenger-window-restore-down-button =
    .tooltiptext = Restaurer
messenger-window-close-button =
    .tooltiptext = Fermer
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
menu-file-save-as-file =
    .label = Fichier…
    .accesskey = F

## AppMenu

appmenu-save-as-file =
    .label = Fichier…
appmenu-settings =
    .label = Paramètres
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
mail-context-delete-messages =
    .label =
        { $count ->
            [one] Supprimer le message
           *[other] Supprimer les messages sélectionnés
        }
context-menu-decrypt-to-folder =
    .label = Copier comme déchiffré vers
    .accesskey = C

## Message header pane

other-action-redirect-msg =
    .label = Rediriger
message-header-msg-flagged =
    .title = Suivi
    .aria-label = Suivi
message-header-msg-not-flagged =
    .title = Message non suivi
# Variables:
# $address (String) - The email address of the recipient this picture belongs to.
message-header-recipient-avatar =
    .alt = Photo de profil de { $address }.

## Message header cutomize panel

message-header-customize-panel-title = Paramètres d’en-tête des messages
message-header-customize-button-style =
    .value = Style du bouton
    .accesskey = B
message-header-button-style-default =
    .label = Icônes et texte
message-header-button-style-text =
    .label = Texte
message-header-button-style-icons =
    .label = Icônes
message-header-show-sender-full-address =
    .label = Toujours afficher l’adresse complète de l’expéditeur
    .accesskey = c
message-header-show-sender-full-address-description = L’adresse électronique sera affichée sous le nom d’affichage.
message-header-show-recipient-avatar =
    .label = Afficher la photo du profil de l’expéditeur
    .accesskey = p
message-header-hide-label-column =
    .label = Masquer la colonne des étiquettes
    .accesskey = M
message-header-large-subject =
    .label = Grand sujet
    .accesskey = s

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = Gérer l’extension
    .accesskey = e
toolbar-context-menu-remove-extension =
    .label = Supprimer l’extension
    .accesskey = m

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

## error messages

decrypt-and-copy-failures = { $failures } des { $total } messages n’ont pas pu être déchiffrés et n’ont pas été copiés.

## Spaces toolbar

spaces-toolbar-element =
    .toolbarname = Barre d’espaces
    .aria-label = Barre d’espaces
    .aria-description = Barre d’outils verticale pour passer d’un espace à un autre. Utilisez les flèches pour naviguer entre les boutons disponibles.
spaces-toolbar-button-mail2 =
    .title = Courrier
spaces-toolbar-button-address-book2 =
    .title = Carnet d’adresses
spaces-toolbar-button-calendar2 =
    .title = Agenda
spaces-toolbar-button-tasks2 =
    .title = Tâches
spaces-toolbar-button-chat2 =
    .title = Messagerie instantanée
spaces-toolbar-button-overflow =
    .title = Plus d’espaces…
spaces-toolbar-button-settings2 =
    .title = Paramètres
spaces-toolbar-button-hide =
    .title = Masquer la barre d’espaces
spaces-toolbar-button-show =
    .title = Afficher la barre d’espaces
spaces-context-new-tab-item =
    .label = Ouvrir dans un nouvel onglet
spaces-context-new-window-item =
    .label = Ouvrir dans une nouvelle fenêtre
# Variables:
# $tabName (String) - The name of the tab this item will switch to.
spaces-context-switch-tab-item =
    .label = Aller à { $tabName }
settings-context-open-settings-item2 =
    .label = Paramètres
settings-context-open-account-settings-item2 =
    .label = Paramètres des comptes
settings-context-open-addons-item2 =
    .label = Modules complémentaires et thèmes

## Spaces toolbar pinned tab menupopup

spaces-toolbar-pinned-tab-button =
    .tooltiptext = Ouvrir le menu des espaces
spaces-pinned-button-menuitem-mail =
    .label = { spaces-toolbar-button-mail.title }
spaces-pinned-button-menuitem-address-book =
    .label = { spaces-toolbar-button-address-book.title }
spaces-pinned-button-menuitem-calendar =
    .label = { spaces-toolbar-button-calendar.title }
spaces-pinned-button-menuitem-tasks =
    .label = { spaces-toolbar-button-tasks.title }
spaces-pinned-button-menuitem-chat =
    .label = { spaces-toolbar-button-chat.title }
spaces-pinned-button-menuitem-settings =
    .label = { spaces-toolbar-button-settings2.title }
spaces-pinned-button-menuitem-mail2 =
    .label = { spaces-toolbar-button-mail2.title }
spaces-pinned-button-menuitem-address-book2 =
    .label = { spaces-toolbar-button-address-book2.title }
spaces-pinned-button-menuitem-calendar2 =
    .label = { spaces-toolbar-button-calendar2.title }
spaces-pinned-button-menuitem-tasks2 =
    .label = { spaces-toolbar-button-tasks2.title }
spaces-pinned-button-menuitem-chat2 =
    .label = { spaces-toolbar-button-chat2.title }
spaces-pinned-button-menuitem-settings2 =
    .label = { spaces-toolbar-button-settings2.title }
spaces-pinned-button-menuitem-show =
    .label = { spaces-toolbar-button-show.title }
# Variables:
# $count (Number) - Number of unread messages.
chat-button-unread-messages = { $count }
    .title =
        { $count ->
            [one] Un message non lu
           *[other] { $count } messages non lus
        }

## Spaces toolbar customize panel

menuitem-customize-label =
    .label = Personnaliser…
spaces-customize-panel-title = Paramètres de la barre d’espaces
spaces-customize-background-color = Couleur du fond
spaces-customize-icon-color = Couleur des boutons
# The background color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-background-color = Couleur de fond du bouton sélectionné
# The icon color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-text-color = Couleur du bouton sélectionné
spaces-customize-button-restore = Configuration par défaut
    .accesskey = C
customize-panel-button-save = Terminé
    .accesskey = T
