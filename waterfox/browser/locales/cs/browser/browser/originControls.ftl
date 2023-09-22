# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear in Origin Controls for Extensions.  Currently,
## they are visible in the context menu for extension toolbar buttons,
## and are used to inform the user how the extension can access their
## data for the current website, and allow them to control it.

origin-controls-no-access =
    .label = Rozšíření nemůže číst ani měnit data
origin-controls-quarantined =
    .label = Rozšíření nemůže číst ani měnit data
origin-controls-quarantined-status =
    .label = Rozšíření nepovolit na serverech s omezením
origin-controls-quarantined-allow =
    .label = Povolit na serverech s omezením
origin-controls-options =
    .label = Rozšíření může číst a měnit data
origin-controls-option-all-domains =
    .label = Na všech stránkách
origin-controls-option-when-clicked =
    .label = Pouze při klepnutí
# This string denotes an option that grants the extension access to
# the current site whenever they visit it.
# Variables:
#   $domain (String) - The domain for which the access is granted.
origin-controls-option-always-on =
    .label = Vždy povolit pro { $domain }

## These strings are used to map Origin Controls states to user-friendly
## messages. They currently appear in the unified extensions panel.

origin-controls-state-no-access = Nemůže číst ani měnit data na tomto webu
origin-controls-state-quarantined =
    { -vendor-short-name.case-status ->
        [with-cases] Není povolené { -vendor-short-name(case: "ins") } na této stránce
       *[no-cases] Není povolené organizací { -vendor-short-name } na této stránce
    }
origin-controls-state-always-on = Může vždy číst a měnit data na tomto webu
origin-controls-state-when-clicked = Pro čtení nebo změnu dat na tomto webu je nutné oprávnění
origin-controls-state-hover-run-visit-only = Spustit pouze pro tuto návštěvu
origin-controls-state-runnable-hover-open = Otevřít rozšíření
origin-controls-state-runnable-hover-run = Spustit rozšíření
origin-controls-state-temporary-access = Může číst a měnit data během této návštěvy

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
        Vyžadováno oprávnění
# Extension's toolbar button when quarantined.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-quarantined =
    .label = { $extensionTitle }
    .tooltiptext =
        { -vendor-short-name.case-status ->
            [with-cases]
                { $extensionTitle }
                Na tomto serveru není { -vendor-short-name(case: "ins") } povoleno
           *[no-cases]
                { $extensionTitle }
                Na tomto serveru není organizací { -vendor-short-name } povoleno
        }
