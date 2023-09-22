# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear in Origin Controls for Extensions.  Currently,
## they are visible in the context menu for extension toolbar buttons,
## and are used to inform the user how the extension can access their
## data for the current website, and allow them to control it.

origin-controls-no-access =
    .label = Extensie kan geen gegevens lezen en wijzigen
origin-controls-quarantined =
    .label = Extensie mag geen gegevens lezen en wijzigen
origin-controls-quarantined-status =
    .label = Extensie niet toegestaan op beperkte websites
origin-controls-quarantined-allow =
    .label = Toestaan op beperkte websites
origin-controls-options =
    .label = Extensie kan gegevens lezen en wijzigen:
origin-controls-option-all-domains =
    .label = Op alle websites
origin-controls-option-when-clicked =
    .label = Alleen wanneer aangeklikt
# This string denotes an option that grants the extension access to
# the current site whenever they visit it.
# Variables:
#   $domain (String) - The domain for which the access is granted.
origin-controls-option-always-on =
    .label = Altijd toestaan op { $domain }

## These strings are used to map Origin Controls states to user-friendly
## messages. They currently appear in the unified extensions panel.

origin-controls-state-no-access = Kan gegevens op deze website niet lezen en wijzigen
origin-controls-state-quarantined = Niet toegestaan door { -vendor-short-name } op deze website
origin-controls-state-always-on = Kan altijd gegevens op deze website lezen en wijzigen
origin-controls-state-when-clicked = Toestemming nodig om gegevens te lezen en te wijzigen
origin-controls-state-hover-run-visit-only = Alleen voor dit bezoek uitvoeren
origin-controls-state-runnable-hover-open = Extensie openen
origin-controls-state-runnable-hover-run = Extensie uitvoeren
origin-controls-state-temporary-access = Kan gegevens tijdens dit bezoek lezen en wijzigen

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
        Machtiging benodigd
# Extension's toolbar button when quarantined.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-quarantined =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        Niet toegestaan door { -vendor-short-name } op deze website
