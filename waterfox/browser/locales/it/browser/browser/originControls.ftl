# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear in Origin Controls for Extensions.  Currently,
## they are visible in the context menu for extension toolbar buttons,
## and are used to inform the user how the extension can access their
## data for the current website, and allow them to control it.

origin-controls-no-access =
    .label = L’estensione non può leggere né modificare dati

origin-controls-quarantined =
    .label = L’estensione non ha il permesso di leggere e modificare dati

origin-controls-quarantined-status =
    .label = Estensione non consentita in siti con restrizioni

origin-controls-quarantined-allow =
    .label = Consenti in siti con restrizioni

origin-controls-options =
    .label = L’estensione può leggere e modificare dati:

origin-controls-option-all-domains =
    .label = In qualsiasi sito

origin-controls-option-when-clicked =
    .label = Solo quando si fa clic

# This string denotes an option that grants the extension access to
# the current site whenever they visit it.
# Variables:
#   $domain (String) - The domain for which the access is granted.
origin-controls-option-always-on =
    .label = Sempre attiva in { $domain }

## These strings are used to map Origin Controls states to user-friendly
## messages. They currently appear in the unified extensions panel.

origin-controls-state-no-access = Non può leggere né modificare dati in questo sito

origin-controls-state-quarantined = Non consentita da { -vendor-short-name } in questo sito

origin-controls-state-always-on = Può sempre leggere e modificare dati in questo sito

origin-controls-state-when-clicked = Autorizzazione necessaria per leggere e modificare dati

origin-controls-state-hover-run-visit-only = Esegui solo per questa visita

origin-controls-state-runnable-hover-open = Apri estensione

origin-controls-state-runnable-hover-run = Esegui estensione

origin-controls-state-temporary-access = Può leggere e modificare dati per questa visita

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
        Permessi richiesti

# Extension's toolbar button when quarantined.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-quarantined =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        Non consentita da { -vendor-short-name } in questo sito


