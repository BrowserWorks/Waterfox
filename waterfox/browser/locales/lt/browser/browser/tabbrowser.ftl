# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = Nauja kortelė

tabbrowser-menuitem-close-tab =
    .label = Užverti kortelę
tabbrowser-menuitem-close =
    .label = Užverti

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
            [one] Užverti kortelę
            [few] Užverti { $tabCount } korteles
           *[other] Užverti { $tabCount } kortelių
        }

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Nutildyti kortelę ({ $shortcut })
            [few] Nutildyti { $tabCount } korteles ({ $shortcut })
           *[other] Nutildyti { $tabCount } kortelių ({ $shortcut })
        }
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Įjungti garsą kortelėje ({ $shortcut })
            [few] Įjungti garsą { $tabCount } kortelėse ({ $shortcut })
           *[other] Įjungti garsą { $tabCount } kortelių ({ $shortcut })
        }
tabbrowser-mute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Nutildyti kortelę
            [few] Nutildyti { $tabCount } korteles
           *[other] Nutildyti { $tabCount } kortelių
        }
tabbrowser-unmute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Įjungti garsą kortelėje
            [few] Įjungti garsą { $tabCount } kortelėse
           *[other] Įjungti garsą { $tabCount } kortelių
        }
tabbrowser-unblock-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Groti kortelę
            [few] Groti { $tabCount } korteles
           *[other] Groti { $tabCount } kortelių
        }

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title =
    { $tabCount ->
        [few] Užverti { $tabCount } kortelių?
       *[other] Užverti { $tabCount } korteles?
    }
tabbrowser-confirm-close-tabs-button = Užverti korteles
tabbrowser-confirm-close-tabs-checkbox = Patvirtinti prieš užveriant keletą kortelių

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title =
    { $windowCount ->
        [few] Užverti { $windowCount } langų?
       *[other] Užverti { $windowCount } langus?
    }
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] Užverti ir išeiti
       *[other] Užverti ir išeiti
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title = Užverti langą ir išeiti iš „{ -brand-short-name }“?
tabbrowser-confirm-close-tabs-with-key-button = Išeiti iš „{ -brand-short-name }“
# Variables:
#   $quitKey (String): the text of the keyboard shortcut for quitting.
tabbrowser-confirm-close-tabs-with-key-checkbox = Patvirtinti prieš baigiant darbą su „{ $quitKey }“

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = Atvėrimo patvirtinimas
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { $tabCount ->
       *[other] Ketinate atverti { $tabCount } korteles (-ių) vienu metu. Kol šie tinklalapiai įkeliami, gali sulėtėti „{ -brand-short-name }“ darbas. Ar tikrai norite atverti?
    }
tabbrowser-confirm-open-multiple-tabs-button = Atverti korteles
tabbrowser-confirm-open-multiple-tabs-checkbox = Įspėti prieš atveriant daug kortelių, kurios gali sulėtinti „{ -brand-short-name }“ darbą

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = Naršymas žymekliu
tabbrowser-confirm-caretbrowsing-message = Klavišas F7 įjungia arba išjungia žymeklį, kai peržiūrimas tinklalapis. Jį įjungus teksto fragmentus galima pažymėti klaviatūra. Ar įjungti žymeklį?
tabbrowser-confirm-caretbrowsing-checkbox = Šio dialogo daugiau neberodyti.

##

# Variables:
#   $domain (String): URL of the page that is trying to steal focus.
tabbrowser-allow-dialogs-to-get-focus =
    .label = Leisti tokiems pranešimams iš { $domain } perkelti jus į jų kortelę

tabbrowser-customizemode-tab-title = Tvarkyti „{ -brand-short-name }“

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = Nutildyti kortelę
    .accesskey = N
tabbrowser-context-unmute-tab =
    .label = Įjungti garsą
    .accesskey = j
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = Nutildyti korteles
    .accesskey = t
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = Įjungti garsą
    .accesskey = g

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label =
        { $tabCount ->
            [few] Parodyti visas { $tabCount } korteles
           *[other] Parodyti visas { $tabCount } kortelių
        }

## Tab manager menu buttons

