# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear in Origin Controls for Extensions.  Currently,
## they are visible in the context menu for extension toolbar buttons,
## and are used to inform the user how the extension can access their
## data for the current website, and allow them to control it.

origin-controls-no-access =
    .label = L’extension ne peut ni lire ni modifier de données
origin-controls-quarantined =
    .label = L’extension n’est pas autorisée à lire ni à modifier de données
origin-controls-quarantined-status =
    .label = Extension non autorisée sur les sites restreints
origin-controls-quarantined-allow =
    .label = Autoriser sur les sites restreints
origin-controls-options =
    .label = L’extension peut lire et modifier les données :
origin-controls-option-all-domains =
    .label = de tous les sites
origin-controls-option-when-clicked =
    .label = uniquement au clic
# This string denotes an option that grants the extension access to
# the current site whenever they visit it.
# Variables:
#   $domain (String) - The domain for which the access is granted.
origin-controls-option-always-on =
    .label = Toujours autoriser pour { $domain }

## These strings are used to map Origin Controls states to user-friendly
## messages. They currently appear in the unified extensions panel.

origin-controls-state-no-access = Ne peut ni lire ni modifier les données de ce site
origin-controls-state-quarantined = Non autorisée par { -vendor-short-name } sur ce site
origin-controls-state-always-on = Peut toujours lire et modifier les données de ce site
origin-controls-state-when-clicked = Permission requise pour lire et modifier des données
origin-controls-state-hover-run-visit-only = Autoriser pour cette fois seulement
origin-controls-state-runnable-hover-open = Ouvrir l’extension
origin-controls-state-runnable-hover-run = Lancer l’extension
origin-controls-state-temporary-access = Peut lire et modifier les données pour cette fois

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
        Permission requise
# Extension's toolbar button when quarantined.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-quarantined =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        Extension non autorisée par { -vendor-short-name } sur ce site
