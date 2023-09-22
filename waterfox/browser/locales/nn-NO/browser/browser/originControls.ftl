# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear in Origin Controls for Extensions.  Currently,
## they are visible in the context menu for extension toolbar buttons,
## and are used to inform the user how the extension can access their
## data for the current website, and allow them to control it.

origin-controls-no-access =
    .label = Utvidinga kan ikkje lese og endre data
origin-controls-quarantined =
    .label = Utvidinga har ikkje løyve til å lese og endre data
origin-controls-quarantined-status =
    .label = Utvidinga ikkje tillaten på avgrensa nettstadar
origin-controls-quarantined-allow =
    .label = Tillat på avgrensa nettstadar
origin-controls-options =
    .label = Utvidinga kan lese og endre data
origin-controls-option-all-domains =
    .label = På alle nettstadar
origin-controls-option-when-clicked =
    .label = Berre når du klikkar
# This string denotes an option that grants the extension access to
# the current site whenever they visit it.
# Variables:
#   $domain (String) - The domain for which the access is granted.
origin-controls-option-always-on =
    .label = Tillat alltid på { $domain }

## These strings are used to map Origin Controls states to user-friendly
## messages. They currently appear in the unified extensions panel.

origin-controls-state-no-access = Kan ikkje lese og endre data på denne nettstaden
origin-controls-state-quarantined = Ikkje tillate av { -vendor-short-name } på denne nettstaden
origin-controls-state-always-on = Kan alltid lese og endre data på denne nettstaden
origin-controls-state-when-clicked = Løyve er påkravd for å lese og endre data
origin-controls-state-hover-run-visit-only = Køyr berre for dette besøket
origin-controls-state-runnable-hover-open = Opne utviding
origin-controls-state-runnable-hover-run = Køyr utviding
origin-controls-state-temporary-access = Kan lese og endre data for dette besøket

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
        Treng løyve
# Extension's toolbar button when quarantined.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-quarantined =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        Ikkje tillate { -vendor-short-name } på denne nettstaden
