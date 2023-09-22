# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear in Origin Controls for Extensions.  Currently,
## they are visible in the context menu for extension toolbar buttons,
## and are used to inform the user how the extension can access their
## data for the current website, and allow them to control it.

origin-controls-no-access =
    .label = Erweiterung kann keine Daten lesen und ändern
origin-controls-quarantined =
    .label = Erweiterung darf keine Daten lesen und ändern
origin-controls-quarantined-status =
    .label = Erweiterung auf eingeschränkten Websites nicht erlaubt
origin-controls-quarantined-allow =
    .label = Auf eingeschränkten Websites erlauben
origin-controls-options =
    .label = Erweiterung kann Daten lesen und ändern:
origin-controls-option-all-domains =
    .label = Auf allen Seiten
origin-controls-option-when-clicked =
    .label = Nur wenn angeklickt
# This string denotes an option that grants the extension access to
# the current site whenever they visit it.
# Variables:
#   $domain (String) - The domain for which the access is granted.
origin-controls-option-always-on =
    .label = Immer auf { $domain } erlauben

## These strings are used to map Origin Controls states to user-friendly
## messages. They currently appear in the unified extensions panel.

origin-controls-state-no-access = Kann keine Daten auf dieser Website lesen und ändern
origin-controls-state-quarantined = Von { -vendor-short-name } auf dieser Website nicht erlaubt
origin-controls-state-always-on = Kann immer Daten auf dieser Website lesen und ändern
origin-controls-state-when-clicked = Berechtigung zum Lesen und Ändern von Daten erforderlich
origin-controls-state-hover-run-visit-only = Nur für diesen Besuch ausführen
origin-controls-state-runnable-hover-open = Erweiterung öffnen
origin-controls-state-runnable-hover-run = Erweiterung ausführen
origin-controls-state-temporary-access = Kann Daten für diesen Besuch lesen und ändern

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
        Erlaubnis nötig
# Extension's toolbar button when quarantined.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-quarantined =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        Von { -vendor-short-name } auf dieser Website nicht erlaubt
