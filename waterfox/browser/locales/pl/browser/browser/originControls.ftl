# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear in Origin Controls for Extensions.  Currently,
## they are visible in the context menu for extension toolbar buttons,
## and are used to inform the user how the extension can access their
## data for the current website, and allow them to control it.

origin-controls-no-access =
    .label = Rozszerzenie nie może odczytywać ani zmieniać danych
origin-controls-quarantined =
    .label = Odczytywanie i zmienianie danych przez to rozszerzenie jest niedozwolone
origin-controls-quarantined-status =
    .label = Rozszerzenie jest niedozwolone na witrynach z ograniczeniami
origin-controls-quarantined-allow =
    .label = Zezwól na witrynach z ograniczeniami
origin-controls-options =
    .label = Rozszerzenie może odczytywać i zmieniać dane:
origin-controls-option-all-domains =
    .label = Na wszystkich witrynach
origin-controls-option-when-clicked =
    .label = Tylko po kliknięciu
# This string denotes an option that grants the extension access to
# the current site whenever they visit it.
# Variables:
#   $domain (String) - The domain for which the access is granted.
origin-controls-option-always-on =
    .label = Na witrynie { $domain } bez pytania

## These strings are used to map Origin Controls states to user-friendly
## messages. They currently appear in the unified extensions panel.

origin-controls-state-no-access = Nie może odczytywać ani zmieniać danych na tej witrynie
origin-controls-state-quarantined = { -vendor-short-name } nie zezwala na tej witrynie
origin-controls-state-always-on = Zawsze może odczytywać i zmieniać dane na tej witrynie
origin-controls-state-when-clicked = Odczytywanie i zmienianie danych wymaga uprawnienia
origin-controls-state-hover-run-visit-only = Uruchom tylko na czas tej wizyty
origin-controls-state-runnable-hover-open = Otwórz rozszerzenie
origin-controls-state-runnable-hover-run = Uruchom rozszerzenie
origin-controls-state-temporary-access = Może odczytywać i zmieniać dane na czas tej wizyty

## Extension's toolbar button.
## Variables:
##   $extensionTitle (String) - Extension name or title message.

origin-controls-toolbar-button =
    .label = { $extensionTitle }
    .tooltiptext = { $extensionTitle }
# Extension's toolbar button when permission is needed.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-permission-needed =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        Wymagane uprawnienie
# Extension's toolbar button when quarantined.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-quarantined =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        { -vendor-short-name } nie zezwala na tej witrynie
