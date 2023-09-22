# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear in Origin Controls for Extensions.  Currently,
## they are visible in the context menu for extension toolbar buttons,
## and are used to inform the user how the extension can access their
## data for the current website, and allow them to control it.

origin-controls-no-access =
    .label = Tillägget kan inte läsa och ändra data
origin-controls-quarantined =
    .label = Tillägget får inte läsa och ändra data
origin-controls-quarantined-status =
    .label = Tillägget är ej tillåtet på begränsade webbplatser
origin-controls-quarantined-allow =
    .label = Tillåt på begränsade webbplatser
origin-controls-options =
    .label = Tillägg kan läsa och ändra data:
origin-controls-option-all-domains =
    .label = På alla webbplatser
origin-controls-option-when-clicked =
    .label = Endast när du klickar
# This string denotes an option that grants the extension access to
# the current site whenever they visit it.
# Variables:
#   $domain (String) - The domain for which the access is granted.
origin-controls-option-always-on =
    .label = Tillåt alltid på { $domain }

## These strings are used to map Origin Controls states to user-friendly
## messages. They currently appear in the unified extensions panel.

origin-controls-state-no-access = Det går inte att läsa och ändra data på den här webbplatsen
origin-controls-state-quarantined = Inte tillåtet av { -vendor-short-name } på den här webbplatsen
origin-controls-state-always-on = Kan alltid läsa och ändra data på den här webbplatsen
origin-controls-state-when-clicked = Behörighet krävs för att läsa och ändra data
origin-controls-state-hover-run-visit-only = Kör endast för detta besök
origin-controls-state-runnable-hover-open = Öppna tillägg
origin-controls-state-runnable-hover-run = Kör tillägg
origin-controls-state-temporary-access = Kan läsa och ändra data för detta besök

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
        Behörigheter behövs
# Extension's toolbar button when quarantined.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-quarantined =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        Inte tillåtet av { -vendor-short-name } på den här webbplatsen
