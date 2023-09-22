# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = Nouvel onglet
tabbrowser-empty-private-tab-title = Nouvel onglet privé

tabbrowser-menuitem-close-tab =
    .label = Fermer l’onglet
tabbrowser-menuitem-close =
    .label = Fermer

# Displayed as a tooltip on container tabs
# Variables:
#   $title (String): the title of the current tab.
#   $containerName (String): the name of the current container.
tabbrowser-container-tab-title = { $title } - { $containerName }

# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-close-tabs-tooltip =
    .label =
        { $tabCount ->
            [one] Fermer l’onglet
           *[other] Fermer { $tabCount } onglets
        }

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Couper le son de l’onglet ({ $shortcut })
           *[other] Couper le son de { $tabCount } onglets ({ $shortcut })
        }
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Réactiver le son de l’onglet ({ $shortcut })
           *[other] Réactiver le son de { $tabCount } onglets ({ $shortcut })
        }
tabbrowser-mute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Couper le son de l’onglet
           *[other] Couper le son de { $tabCount } onglets
        }
tabbrowser-unmute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Réactiver le son de l’onglet
           *[other] Réactiver le son de { $tabCount } onglets
        }
tabbrowser-unblock-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Jouer le son de l’onglet
           *[other] Jouer le son de { $tabCount } onglets
        }

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title = Fermer { $tabCount } onglets ?
tabbrowser-confirm-close-tabs-button = Fermer les onglets
tabbrowser-confirm-close-tabs-checkbox = Confirmer avant la fermeture de plusieurs onglets

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title = Fermer { $windowCount } fenêtres ?
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] Fermer et quitter
       *[other] Fermer et quitter
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title = Fermer la fenêtre et quitter { -brand-short-name } ?
tabbrowser-confirm-close-tabs-with-key-button = Quitter { -brand-short-name }
# Variables:
#   $quitKey (String): the text of the keyboard shortcut for quitting.
tabbrowser-confirm-close-tabs-with-key-checkbox = Confirmer avant de quitter avec { $quitKey }

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = Confirmation de l’ouverture
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { $tabCount ->
       *[other] Vous avez demandé l’ouverture de { $tabCount } onglets. Ceci pourrait ralentir { -brand-short-name } lors du chargement des pages. Voulez-vous vraiment continuer ?
    }
tabbrowser-confirm-open-multiple-tabs-button = Ouvrir les onglets
tabbrowser-confirm-open-multiple-tabs-checkbox = Prévenir lors de l’ouverture de multiples onglets d’un ralentissement possible de { -brand-short-name }

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = Navigation au curseur
tabbrowser-confirm-caretbrowsing-message = L’appui sur F7 active ou désactive la navigation au curseur. Cette fonction place un curseur déplaçable dans les pages web, permettant de sélectionner du texte au clavier. Désirez-vous activer la navigation au curseur ?
tabbrowser-confirm-caretbrowsing-checkbox = Ne plus afficher ce dialogue à l’avenir

##

# Variables:
#   $domain (String): URL of the page that is trying to steal focus.
tabbrowser-allow-dialogs-to-get-focus =
    .label = Autoriser les notifications de ce type depuis { $domain } à basculer vers leur onglet

tabbrowser-customizemode-tab-title = Personnaliser { -brand-short-name }

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = Couper le son de l’onglet
    .accesskey = R
tabbrowser-context-unmute-tab =
    .label = Réactiver le son de l’onglet
    .accesskey = R
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = Couper le son des onglets
    .accesskey = R
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = Réactiver le son des onglets
    .accesskey = R

# This string is used as an additional tooltip and accessibility description for tabs playing audio
tabbrowser-tab-audio-playing-description = Lecture audio

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label = Lister les { $tabCount } onglets

## Tab manager menu buttons

tabbrowser-manager-mute-tab =
    .tooltiptext = Rendre l’onglet muet
tabbrowser-manager-unmute-tab =
    .tooltiptext = Réactiver le son de l’onglet
tabbrowser-manager-close-tab =
    .tooltiptext = Fermer l’onglet
