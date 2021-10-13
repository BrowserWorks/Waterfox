# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Witamy w nowej przeglądarce { -brand-short-name }
upgrade-dialog-new-subtitle = Zaprojektowana, aby szybciej dotrzeć tam, gdzie chcesz
upgrade-dialog-new-item-menu-title = Uproszczony pasek narzędzi i menu
upgrade-dialog-new-item-menu-description = Ważne rzeczy stawiają na pierwszym miejscu, aby zawsze znaleźć to, czego potrzebujesz.
upgrade-dialog-new-item-tabs-title = Nowoczesne karty
upgrade-dialog-new-item-tabs-description = Zawierają przydatne informacje, pomagając zachować koncentrację i elastycznie się poruszać.
upgrade-dialog-new-item-icons-title = Nowe ikony i jaśniejsze komunikaty
upgrade-dialog-new-item-icons-description = Delikatnie pomagają Ci się znaleźć.
upgrade-dialog-new-primary-default-button = Ustaw przeglądarkę { -brand-short-name } jako domyślną
upgrade-dialog-new-primary-theme-button = Wybierz motyw
upgrade-dialog-new-secondary-button = Nie teraz
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = OK

## Pin Waterfox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-pin-title =
    { PLATFORM() ->
        [macos] Zatrzymaj przeglądarkę { -brand-short-name } w Docku
       *[other] Przypnij przeglądarkę { -brand-short-name } do paska zadań
    }
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle =
    { PLATFORM() ->
        [macos] Miej łatwy dostęp do najświeższej przeglądarki { -brand-short-name }.
       *[other] Trzymaj najświeższą przeglądarkę { -brand-short-name } w zasięgu ręki.
    }
upgrade-dialog-pin-primary-button =
    { PLATFORM() ->
        [macos] Zatrzymaj w Docku
       *[other] Przypnij do paska zadań
    }
upgrade-dialog-pin-secondary-button = Nie teraz

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = Ustaw przeglądarkę { -brand-short-name } jako domyślną
upgrade-dialog-default-subtitle-2 = Korzystaj z szybkości, bezpieczeństwa i prywatności na autopilocie.
upgrade-dialog-default-primary-button-2 = Ustaw jako domyślną przeglądarkę
upgrade-dialog-default-secondary-button = Nie teraz

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Nowy początek z odświeżonym motywem
upgrade-dialog-theme-system = Motyw systemu
    .title = Używa motywu systemu operacyjnego do wyświetlania przycisków, menu i okien
upgrade-dialog-theme-light = Jasny
    .title = Używa jasnego motywu do wyświetlania przycisków, menu i okien
upgrade-dialog-theme-dark = Ciemny
    .title = Używa ciemnego motywu do wyświetlania przycisków, menu i okien
upgrade-dialog-theme-alpenglow = Alpenglow
    .title = Używa dynamicznego, kolorowego motywu do wyświetlania przycisków, menu i okien
upgrade-dialog-theme-keep = Nie zmieniaj motywu
    .title = Używa motywu zainstalowanego przed aktualizacją przeglądarki { -brand-short-name }
upgrade-dialog-theme-primary-button = Zachowaj motyw
upgrade-dialog-theme-secondary-button = Nie teraz
