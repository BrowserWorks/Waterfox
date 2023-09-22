# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = Ny flik
tabbrowser-empty-private-tab-title = Ny privat flik

tabbrowser-menuitem-close-tab =
    .label = Stäng flik
tabbrowser-menuitem-close =
    .label = Stäng

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
            [one] Stäng flik
           *[other] Stäng { $tabCount } flikar
        }

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Ljud av för flik ({ $shortcut })
           *[other] Ljud av för { $tabCount } flikar ({ $shortcut })
        }
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Ljud på för flik ({ $shortcut })
           *[other] Ljud på för { $tabCount } flikar ({ $shortcut })
        }
tabbrowser-mute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Ljud av för flik
           *[other] Ljud av för { $tabCount } flikar
        }
tabbrowser-unmute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Ljud på för flik
           *[other] Ljud på för { $tabCount } flikar
        }
tabbrowser-unblock-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Spela flik
           *[other] Spela { $tabCount } flikar
        }

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title = Stäng { $tabCount } flikar?
tabbrowser-confirm-close-tabs-button = Stäng flikar
tabbrowser-confirm-close-tabs-checkbox = Bekräfta innan du stänger flera flikar

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title = Stäng { $windowCount } fönster?
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] Stäng och avsluta
       *[other] Stäng och avsluta
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title = Stäng fönster och avsluta { -brand-short-name }?
tabbrowser-confirm-close-tabs-with-key-button = Avsluta { -brand-short-name }
# Variables:
#   $quitKey (String): the text of the keyboard shortcut for quitting.
tabbrowser-confirm-close-tabs-with-key-checkbox = Bekräfta innan du avslutar med { $quitKey }

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = Bekräfta öppning
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { $tabCount ->
       *[other] Du är på väg att öppna { $tabCount } flikar. Detta kan göra { -brand-short-name } långsamt under tiden sidorna laddas. Är du säker på att du vill fortsätta?
    }
tabbrowser-confirm-open-multiple-tabs-button = Öppna flikar
tabbrowser-confirm-open-multiple-tabs-checkbox = Varna när öppnande av många flikar kan göra { -brand-short-name } långsam

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = Textmarkörläge
tabbrowser-confirm-caretbrowsing-message = Genom att trycka på F7 aktiveras textmarkörläge eller stängs av. Denna funktion placerar en rörlig markör på webbsidor, så att du kan välja text med tangentbordet. Vill du aktivera textmarkörläge?
tabbrowser-confirm-caretbrowsing-checkbox = Visa inte denna dialogruta igen.

##

# Variables:
#   $domain (String): URL of the page that is trying to steal focus.
tabbrowser-allow-dialogs-to-get-focus =
    .label = Tillåt liknande meddelanden från { $domain } leder dig till deras flik

tabbrowser-customizemode-tab-title = Anpassa { -brand-short-name }

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = Ljud av för flik
    .accesskey = L
tabbrowser-context-unmute-tab =
    .label = Ljud på för flik
    .accesskey = j
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = Ljud av för flikar
    .accesskey = u
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = Ljud på för flikar
    .accesskey = d

# This string is used as an additional tooltip and accessibility description for tabs playing audio
tabbrowser-tab-audio-playing-description = Spelar upp ljud

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label = Lista alla { $tabCount } flikar

## Tab manager menu buttons

tabbrowser-manager-mute-tab =
    .tooltiptext = Ljud av för flik
tabbrowser-manager-unmute-tab =
    .tooltiptext = Ljud på för flik
tabbrowser-manager-close-tab =
    .tooltiptext = Stäng flik
