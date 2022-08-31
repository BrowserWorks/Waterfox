# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

## Pin Waterfox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

## Default browser screen

## Theme selection screen

## Start screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-start-title = Życie w kolorze
upgrade-dialog-start-subtitle = Energiczne nowe kolorystyki. Dostępne przez ograniczony czas.
upgrade-dialog-start-primary-button = Poznaj kolorystyki
upgrade-dialog-start-secondary-button = Nie teraz

## Colorway screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-colorway-title = Wybierz swoją paletę
# This is shown to users with a custom home page, so they can switch to default.
upgrade-dialog-colorway-home-checkbox = Przełącz na stronę startową Firefoksa z tłem motywu
upgrade-dialog-colorway-primary-button = Zachowaj kolorystykę
upgrade-dialog-colorway-secondary-button = Zostań przy poprzednim motywie
upgrade-dialog-colorway-theme-tooltip =
    .title = Poznaj domyślne motywy
# $colorwayName (String) - Name of colorway, e.g., Abstract, Cheers
upgrade-dialog-colorway-colorway-tooltip =
    .title = Poznaj kolorystykę { $colorwayName }
upgrade-dialog-colorway-default-theme = Domyślny
# "Auto" is short for "Automatic"
upgrade-dialog-colorway-theme-auto = Automatyczny
    .title = Używa motywu systemu operacyjnego do wyświetlania przycisków, menu i okien
upgrade-dialog-theme-light = Jasny
    .title = Używa jasnego motywu do wyświetlania przycisków, menu i okien
upgrade-dialog-theme-dark = Ciemny
    .title = Używa ciemnego motywu do wyświetlania przycisków, menu i okien
upgrade-dialog-colorway-variation-soft = Stonowana
    .title = Użyj tej kolorystyki
upgrade-dialog-colorway-variation-balanced = Wyważona
    .title = Użyj tej kolorystyki
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
upgrade-dialog-colorway-variation-bold = Odważna
    .title = Użyj tej kolorystyki

## Thank you screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-thankyou-title = Dziękujemy za wybranie nas
upgrade-dialog-thankyou-subtitle = { -brand-short-name } to niezależna przeglądarka wspierana przez organizację non-profit. Razem sprawiamy, że Internet jest bezpieczniejszy, zdrowszy i bardziej prywatny.
upgrade-dialog-thankyou-primary-button = Zacznij przeglądać Internet
