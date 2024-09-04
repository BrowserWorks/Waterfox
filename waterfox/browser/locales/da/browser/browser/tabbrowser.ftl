# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = Nyt faneblad
tabbrowser-empty-private-tab-title = Nyt privat faneblad

tabbrowser-menuitem-close-tab =
    .label = Luk faneblad
tabbrowser-menuitem-close =
    .label = Luk

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
            [one] Luk faneblad
           *[other] Luk { $tabCount } faneblade
        }

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Slå lyd fra i faneblad ({ $shortcut })
           *[other] Slå lyd fra i { $tabCount } faneblade ({ $shortcut })
        }
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Slå lyd til i faneblad ({ $shortcut })
           *[other] Slå lyd til i { $tabCount } faneblade ({ $shortcut })
        }
tabbrowser-mute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Slå lyd fra i faneblad
           *[other] Slå lyd fra i { $tabCount } faneblade
        }
tabbrowser-unmute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Slå lyd til i faneblad
           *[other] Slå lyd til i { $tabCount } faneblade
        }
tabbrowser-unblock-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Afspil lyd i faneblad
           *[other] Afspil lyd i { $tabCount } faneblade
        }

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title = Luk { $tabCount } faneblade?
tabbrowser-confirm-close-tabs-button = Luk faneblade
tabbrowser-confirm-close-tabs-checkbox = Bekræft, når jeg lukker flere faneblade

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title = Luk { $windowCount } vinduer?
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] Luk og afslut
       *[other] Luk og afslut
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title = Luk vindue og afslut { -brand-short-name }?
tabbrowser-confirm-close-tabs-with-key-button = Afslut { -brand-short-name }
# Variables:
#   $quitKey (String): the text of the keyboard shortcut for quitting.
tabbrowser-confirm-close-tabs-with-key-checkbox = Bekræft, inden jeg afslutter med { $quitKey }

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = Godkend at åbne
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { $tabCount ->
       *[other] Du er ved at åbne { $tabCount } faneblade. Dette kan gøre { -brand-short-name } langsommere, mens siderne indlæses. Er du sikker på, at du vil fortsætte?
    }
tabbrowser-confirm-open-multiple-tabs-button = Åbn faneblade
tabbrowser-confirm-open-multiple-tabs-checkbox = Advar mig når det kan gøre { -brand-short-name } langsommere at åbne mange faneblade

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = Caret Browsing
tabbrowser-confirm-caretbrowsing-message = Ved at trykke F7 kan du slå Caret Browsing til eller fra. Denne funktion placerer en bevægelig markør på websiden, hvilket giver dig mulighed for at markere tekst med tastaturet. Ønsker du at slå Caret Browsing til?
tabbrowser-confirm-caretbrowsing-checkbox = Vis ikke denne dialogboks igen

##

# Variables:
#   $domain (String): URL of the page that is trying to steal focus.
tabbrowser-allow-dialogs-to-get-focus =
    .label = Tillad at beskeder som denne fra { $domain } tager dig til deres faneblad

tabbrowser-customizemode-tab-title = Tilpas { -brand-short-name }

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = Slå lyden fra i faneblad
    .accesskey = S
tabbrowser-context-unmute-tab =
    .label = Slå lyden til i faneblad
    .accesskey = S
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = Slå lyden fra i fanebladene
    .accesskey = S
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = Slå lyden til i fanebladene
    .accesskey = S

# This string is used as an additional tooltip and accessibility description for tabs playing audio
tabbrowser-tab-audio-playing-description = Afspiller lyd

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label = Vis alle { $tabCount } faneblade

## Tab manager menu buttons

tabbrowser-manager-mute-tab =
    .tooltiptext = Slå lyden fra i faneblad
tabbrowser-manager-unmute-tab =
    .tooltiptext = Slå lyden til i faneblad
tabbrowser-manager-close-tab =
    .tooltiptext = Luk faneblad
