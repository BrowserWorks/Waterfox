# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = Nuova scheda
tabbrowser-empty-private-tab-title = Nuova scheda anonima

tabbrowser-menuitem-close-tab =
    .label = Chiudi scheda
tabbrowser-menuitem-close =
    .label = Chiudi

# Displayed as a tooltip on container tabs
# Variables:
#   $title (String): the title of the current tab.
#   $containerName (String): the name of the current container.
tabbrowser-container-tab-title = { $title } – { $containerName }

# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-close-tabs-tooltip =
    .label =
        { $tabCount ->
            [one] Chiudi scheda
           *[other] Chiudi { $tabCount } schede
        }

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Disattiva audio in questa scheda ({ $shortcut })
           *[other] Disattiva audio in { $tabCount } schede ({ $shortcut })
        }
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Attiva audio in questa scheda ({ $shortcut })
           *[other] Attiva audio in { $tabCount } schede ({ $shortcut })
        }
tabbrowser-mute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Disattiva audio in questa scheda
           *[other] Disattiva audio in { $tabCount } schede
        }
tabbrowser-unmute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Attiva audio in questa scheda
           *[other] Attiva audio in { $tabCount } schede
        }
tabbrowser-unblock-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Avvia riproduzione in questa scheda
           *[other] Avvia riproduzione in { $tabCount } schede
        }

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title = Chiudere { $tabCount } schede?
tabbrowser-confirm-close-tabs-button = Chiudi schede
tabbrowser-confirm-close-tabs-checkbox = Avvisa quando si tenta di chiudere più schede

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title = Chiudere { $windowCount } finestre?
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] Chiudi ed esci
       *[other] Chiudi ed esci
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title = Chiudere la finestra e uscire da { -brand-short-name }?
tabbrowser-confirm-close-tabs-with-key-button = Chiudi { -brand-short-name }
# Variables:
#   $quitKey (String): the text of the keyboard shortcut for quitting.
tabbrowser-confirm-close-tabs-with-key-checkbox = Chiedi conferma prima di uscire con { $quitKey }

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = Conferma apertura
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { $tabCount ->
       *[other] Si stanno per aprire { $tabCount } schede. Questo potrebbe comportare un rallentamento di { -brand-short-name } durante il caricamento delle pagine. Procedere comunque?
    }
tabbrowser-confirm-open-multiple-tabs-button = Apri schede
tabbrowser-confirm-open-multiple-tabs-checkbox = Avvisa quando l’apertura contemporanea di più schede potrebbe rallentare { -brand-short-name }

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = Navigazione nel testo
tabbrowser-confirm-caretbrowsing-message = Premendo il tasto F7 è possibile attivare o disattivare la Navigazione nel testo. Questa funzione visualizza un cursore all’interno della pagina web e consente la selezione del testo attraverso la tastiera. Attivare la Navigazione nel testo?
tabbrowser-confirm-caretbrowsing-checkbox = Non visualizzare questo avviso in futuro.

##

# Variables:
#   $domain (String): URL of the page that is trying to steal focus.
tabbrowser-allow-dialogs-to-get-focus =
    .label = Consenti a notifiche da { $domain } come questa di portarti alla relativa scheda

tabbrowser-customizemode-tab-title = Personalizza { -brand-short-name }

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = Disattiva audio nella scheda
    .accesskey = i
tabbrowser-context-unmute-tab =
    .label = Attiva audio nella scheda
    .accesskey = i
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = Disattiva audio nelle schede
    .accesskey = v
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = Attiva audio nelle schede
    .accesskey = v

# This string is used as an additional tooltip and accessibility description for tabs playing audio
tabbrowser-tab-audio-playing-description = Riproduzione audio

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label = Elenca tutte le { $tabCount } schede

## Tab manager menu buttons

tabbrowser-manager-mute-tab =
  .tooltiptext = Disattiva audio nella scheda
tabbrowser-manager-unmute-tab =
  .tooltiptext = Attiva audio nella scheda
tabbrowser-manager-close-tab =
  .tooltiptext = Chiudi scheda
