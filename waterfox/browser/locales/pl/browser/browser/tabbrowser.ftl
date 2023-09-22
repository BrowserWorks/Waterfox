# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = Nowa karta
tabbrowser-empty-private-tab-title = Nowa karta prywatna

tabbrowser-menuitem-close-tab =
    .label = Zamknij kartę
tabbrowser-menuitem-close =
    .label = Zamknij

# Displayed as a tooltip on container tabs
# Variables:
#   $title (String): the title of the current tab.
#   $containerName (String): the name of the current container.
tabbrowser-container-tab-title = { $title } — { $containerName }

# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-close-tabs-tooltip =
    .label =
        { $tabCount ->
            [one] Zamknij kartę
            [few] Zamknij { $tabCount } karty
           *[many] Zamknij { $tabCount } kart
        }

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Wycisz kartę ({ $shortcut })
            [few] Wycisz { $tabCount } karty ({ $shortcut })
           *[many] Wycisz { $tabCount } kart ({ $shortcut })
        }
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Włącz dźwięk ({ $shortcut })
            [few] Włącz dźwięk w { $tabCount } kartach ({ $shortcut })
           *[many] Włącz dźwięk w { $tabCount } kartach ({ $shortcut })
        }
tabbrowser-mute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Wycisz kartę
            [few] Wycisz { $tabCount } karty
           *[many] Wycisz { $tabCount } kart
        }
tabbrowser-unmute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Włącz dźwięk
            [few] Włącz dźwięk w { $tabCount } kartach
           *[many] Włącz dźwięk w { $tabCount } kartach
        }
tabbrowser-unblock-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Odtwarzaj
            [few] Odtwarzaj w { $tabCount } kartach
           *[many] Odtwarzaj w { $tabCount } kartach
        }

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title =
    { $tabCount ->
        [one] Zamknąć { $tabCount } kartę?
        [few] Zamknąć { $tabCount } karty?
       *[many] Zamknąć { $tabCount } kart?
    }
tabbrowser-confirm-close-tabs-button = Zamknij karty
tabbrowser-confirm-close-tabs-checkbox = Pytaj o potwierdzenie przed zamknięciem wielu kart

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title =
    { $windowCount ->
        [one] Zamknąć { $windowCount } okno?
        [few] Zamknąć { $windowCount } okna?
       *[many] Zamknąć { $windowCount } okien?
    }
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] Zamknij i zakończ
       *[other] Zamknij i zakończ
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title = Zamknąć okno i zakończyć { -brand-short-name(case: "acc") }?
tabbrowser-confirm-close-tabs-with-key-button = Zakończ { -brand-short-name(case: "acc") }
# Variables:
#   $quitKey (String): the text of the keyboard shortcut for quitting.
tabbrowser-confirm-close-tabs-with-key-checkbox = Pytaj o potwierdzenie przed zamknięciem programu za pomocą { $quitKey }

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = Potwierdzenie otwarcia
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { $tabCount ->
       *[other] Nastąpi otwarcie { $tabCount } kart jednocześnie. Może to spowodować spowolnienie działania { -brand-short-name(case: "gen") } podczas wczytywania stron. Czy na pewno kontynuować?
    }
tabbrowser-confirm-open-multiple-tabs-button = Otwórz karty
tabbrowser-confirm-open-multiple-tabs-checkbox = Ostrzegaj, kiedy próba otwarcia zbyt wielu kart może spowolnić { -brand-short-name(case: "acc") }

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = Przeglądanie z użyciem kursora
tabbrowser-confirm-caretbrowsing-message = Naciśnięcie klawisza F7 włącza lub wyłącza tryb przeglądania z użyciem kursora. Opcja ta wyświetla ruchomy kursor na stronach WWW, pozwalając na zaznaczanie tekstu przy pomocy klawiatury. Czy włączyć opcję przeglądania z użyciem kursora?
tabbrowser-confirm-caretbrowsing-checkbox = Nie pytaj ponownie.

##

# Variables:
#   $domain (String): URL of the page that is trying to steal focus.
tabbrowser-allow-dialogs-to-get-focus =
    .label = Zezwalaj powiadomieniom tego typu z { $domain } przełączać na kartę, z której są otwierane

tabbrowser-customizemode-tab-title = Dostosowywanie { -brand-short-name(case: "gen") }

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = Wycisz kartę
    .accesskey = W
tabbrowser-context-unmute-tab =
    .label = Włącz dźwięk
    .accesskey = W
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = Wycisz karty
    .accesskey = W
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = Włącz dźwięki
    .accesskey = W

# This string is used as an additional tooltip and accessibility description for tabs playing audio
tabbrowser-tab-audio-playing-description = Odtwarza dźwięk

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label =
        { $tabCount ->
            [one] Wyświetl kartę na liście
            [few] Wyświetl listę ze wszystkimi { $tabCount } kartami
           *[many] Wyświetl wszystkie { $tabCount } kart na liście
        }

## Tab manager menu buttons

tabbrowser-manager-mute-tab =
    .tooltiptext = Wycisz kartę
tabbrowser-manager-unmute-tab =
    .tooltiptext = Włącz dźwięk
tabbrowser-manager-close-tab =
    .tooltiptext = Zamknij kartę
