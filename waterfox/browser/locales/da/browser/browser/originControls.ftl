# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear in Origin Controls for Extensions.  Currently,
## they are visible in the context menu for extension toolbar buttons,
## and are used to inform the user how the extension can access their
## data for the current website, and allow them to control it.

origin-controls-no-access =
    .label = Udvidelsen kan ikke læse og ændre data
origin-controls-quarantined =
    .label = Udvidelse har ikke tilladelse til at læse og ændre data
origin-controls-quarantined-status =
    .label = Udvidelse ikke tilladt på websteder underlagt begrænsninger
origin-controls-quarantined-allow =
    .label = Tillad på websteder underlagt begrænsninger
origin-controls-options =
    .label = Udvidelsen kan læse og ændre data:
origin-controls-option-all-domains =
    .label = På alle websteder
origin-controls-option-when-clicked =
    .label = Kun, når du klikker
# This string denotes an option that grants the extension access to
# the current site whenever they visit it.
# Variables:
#   $domain (String) - The domain for which the access is granted.
origin-controls-option-always-on =
    .label = Tillad altid på { $domain }

## These strings are used to map Origin Controls states to user-friendly
## messages. They currently appear in the unified extensions panel.

origin-controls-state-no-access = Kan ikke læse eller ændre data på dette websted
origin-controls-state-quarantined = Ikke tilladt af { -vendor-short-name } på dette websted
origin-controls-state-always-on = Kan altid læse og ændre data på dette websted
origin-controls-state-when-clicked = Tilladelse behøves for at læse og ændre data
origin-controls-state-hover-run-visit-only = Udfør kun for dette besøg
origin-controls-state-runnable-hover-open = Åbn udvidelse
origin-controls-state-runnable-hover-run = Kør udvidelse
origin-controls-state-temporary-access = Kan læse og ændre data for dette besøg

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
        Tilladelser kræves
# Extension's toolbar button when quarantined.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-quarantined =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        Ikke tilladt af { -vendor-short-name } på dette websted
