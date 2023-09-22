# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = Ny fane
tabbrowser-empty-private-tab-title = Ny Privat fane

tabbrowser-menuitem-close-tab =
    .label = Lat att fane
tabbrowser-menuitem-close =
    .label = Lat att

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
            [one] Lat att fane
           *[other] Lat at { $tabCount } faner
        }

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Slå av lyd i fane ({ $shortcut })
           *[other] Slå av lyd i { $tabCount } faner ({ $shortcut })
        }
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Slå på lyd i fane ({ $shortcut })
           *[other] Slå på lyd i { $tabCount } faner ({ $shortcut })
        }
tabbrowser-mute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Slå av lyd i fane
           *[other] Slå av lyd i { $tabCount } faner
        }
tabbrowser-unmute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Slå på lyd i fane
           *[other] Slå på lyd i { $tabCount } faner
        }
tabbrowser-unblock-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Spel av fane
           *[other] Spel av { $tabCount } faner
        }

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title = Late att { $tabCount } faner?
tabbrowser-confirm-close-tabs-button = Lat att faner
tabbrowser-confirm-close-tabs-checkbox = Stadfest før attlating av fleire faner

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title = Late att { $windowCount } vindauge?
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] Lat att og avslutt
       *[other] Lat att og avslutt
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title = Late att vindauge og avslutte { -brand-short-name }?
tabbrowser-confirm-close-tabs-with-key-button = Avslutt { -brand-short-name }
# Variables:
#   $quitKey (String): the text of the keyboard shortcut for quitting.
tabbrowser-confirm-close-tabs-with-key-checkbox = Stadfest før du avsluttar med { $quitKey }

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = Stadfest opning
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { $tabCount ->
       *[other] Du er på veg til å opne { $tabCount } faner. Dette kan gjere { -brand-short-name } treg når sidene vert lasta. Er du sikker på at du vil fortsetje?
    }
tabbrowser-confirm-open-multiple-tabs-button = Opne faner
tabbrowser-confirm-open-multiple-tabs-checkbox = Åtvar meg når opning av fleire faner kan gjere { -brand-short-name } treg

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = Nettlesing med tekstveljar
tabbrowser-confirm-caretbrowsing-message = Nettlesing med tekstveljar kan slåast på eller av med F7. Denne funksjonen gjer at du kan merke tekst med tastaturet ved hjelp av ein flyttbar markør. Vil du slå på nettlesing med tekstveljar?
tabbrowser-confirm-caretbrowsing-checkbox = Ikkje vis denne dialogen igjen.

##

# Variables:
#   $domain (String): URL of the page that is trying to steal focus.
tabbrowser-allow-dialogs-to-get-focus =
    .label = Tillat at liknande varsel som dette, frå { $domain }, tar deg til fana deira

tabbrowser-customizemode-tab-title = Tilpass { -brand-short-name }

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = Lyd av i fane
    .accesskey = L
tabbrowser-context-unmute-tab =
    .label = Lyd på i fane
    .accesskey = d
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = Lyd av i faner
    .accesskey = a
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = Lyd på i faner
    .accesskey = a

# This string is used as an additional tooltip and accessibility description for tabs playing audio
tabbrowser-tab-audio-playing-description = Spelar av lyd

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label = List opp alle { $tabCount } faner

## Tab manager menu buttons

tabbrowser-manager-mute-tab =
    .tooltiptext = Skru av fanelyd
tabbrowser-manager-unmute-tab =
    .tooltiptext = Skru på fanelyd
tabbrowser-manager-close-tab =
    .tooltiptext = Lat att fane
