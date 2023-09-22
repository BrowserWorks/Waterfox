# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = Nový panel
tabbrowser-empty-private-tab-title = Nový anonymní panel

tabbrowser-menuitem-close-tab =
    .label = Zavřít panel
tabbrowser-menuitem-close =
    .label = Zavřít

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
            [one] Zavřít panel
            [few] Zavřít { $tabCount } panely
           *[other] Zavřít { $tabCount } panelů
        }

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Vypnout zvuk panelu ({ $shortcut })
            [few] Vypnout zvuk { $tabCount } panelů ({ $shortcut })
           *[other] Vypnout zvuk { $tabCount } panelů ({ $shortcut })
        }
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Zapnout zvuk panelu ({ $shortcut })
            [few] Zapnout zvuk { $tabCount } panelů ({ $shortcut })
           *[other] Zapnout zvuk { $tabCount } panelů ({ $shortcut })
        }
tabbrowser-mute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Vypnout zvuk panelu
            [few] Vypnout zvuk { $tabCount } panelů
           *[other] Vypnout zvuk { $tabCount } panelů
        }
tabbrowser-unmute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Zapnout zvuk panelu
            [few] Zapnout zvuk { $tabCount } panelů
           *[other] Zapnout zvuk { $tabCount } panelů
        }
tabbrowser-unblock-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Spustit v panelu přehrávání
            [few] Spustit ve { $tabCount } panelech přehrávání
           *[other] Spustit v { $tabCount } panelech přehrávání
        }

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title =
    { $tabCount ->
        [one] Zavřít panel?
        [few] Zavřít { $tabCount } panely?
       *[other] Zavřít { $tabCount } panelů?
    }
tabbrowser-confirm-close-tabs-button = Zavřít panely
tabbrowser-confirm-close-tabs-checkbox = Vždy se zeptat při zavírání více panelů

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title =
    { $windowCount ->
        [one] Zavřít okno?
        [few] Zavřít { $windowCount } okna?
       *[other] Zavřít { $windowCount } oken?
    }
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] Zavřít a ukončit
       *[other] Zavřít a ukončit
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title =
    { -brand-short-name.case-status ->
        [with-cases] Chcete zavřít okno a ukončit { -brand-short-name(case: "acc") }?
       *[no-cases] Chcete zavřít okno a ukončit aplikaci { -brand-short-name }?
    }
tabbrowser-confirm-close-tabs-with-key-button =
    { -brand-short-name.case-status ->
        [with-cases] Ukončit { -brand-short-name(case: "acc") }
       *[no-cases] Ukončit aplikaci { -brand-short-name }
    }
# Variables:
#   $quitKey (String): the text of the keyboard shortcut for quitting.
tabbrowser-confirm-close-tabs-with-key-checkbox = Vždy se zeptat při ukončování aplikace zkratkou { $quitKey }

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = Potvrdit otevření
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { -brand-short-name.case-status ->
        [with-cases] Chystáte se najednou otevřít více panelů ({ $tabCount }), a to může { -brand-short-name(case: "acc") } zpomalit. Opravdu chcete pokračovat?
       *[no-cases] Chystáte se najednou otevřít více panelů ({ $tabCount }), a to může aplikaci { -brand-short-name } zpomalit. Opravdu chcete pokračovat?
    }
tabbrowser-confirm-open-multiple-tabs-button = Otevřít panely
tabbrowser-confirm-open-multiple-tabs-checkbox =
    { -brand-short-name.case-status ->
        [with-cases] Varovat, pokud by mohlo otevírání více panelů { -brand-short-name(case: "acc") } zpomalit
       *[no-cases] Varovat, pokud by mohlo otevírání více panelů aplikaci { -brand-short-name } zpomalit
    }

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = Procházení stránky
tabbrowser-confirm-caretbrowsing-message = Stisknutím klávesy F7 zapnete či vypnete funkci Procházení stránky. Ta umístí do stránky pohyblivý textový kurzor, který vám umožní vybírat text pomocí klávesnice. Chcete zapnout funkci Procházení stránky?
tabbrowser-confirm-caretbrowsing-checkbox = Tento dialog příště nezobrazovat.

##

# Variables:
#   $domain (String): URL of the page that is trying to steal focus.
tabbrowser-allow-dialogs-to-get-focus =
    .label = Povolit podobným oznámením ze serveru { $domain } přepínat na svůj panel

tabbrowser-customizemode-tab-title =
    { -brand-short-name.case-status ->
        [with-cases] Přizpůsobit { -brand-short-name(case: "acc") }
       *[no-cases] Přizpůsobit aplikaci { -brand-short-name }
    }

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = Vypnout zvuk panelu
    .accesskey = u
tabbrowser-context-unmute-tab =
    .label = Zapnout zvuk panelu
    .accesskey = u
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = Vypnout zvuk panelů
    .accesskey = u
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = Zapnout zvuk panelů
    .accesskey = u

# This string is used as an additional tooltip and accessibility description for tabs playing audio
tabbrowser-tab-audio-playing-description = Přehrává zvuk

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label =
        { $tabCount ->
            [one] Zobrazit panel
            [few] Zobrazit všechny { $tabCount } panely
           *[other] Zobrazit všech { $tabCount } panelů
        }

## Tab manager menu buttons

tabbrowser-manager-mute-tab =
    .tooltiptext = Vypne zvuk panelu
tabbrowser-manager-unmute-tab =
    .tooltiptext = Zapne zvuk panelu
tabbrowser-manager-close-tab =
    .tooltiptext = Zavře panel
