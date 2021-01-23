# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Blokkeringslister
    .style = width: 55em

blocklist-description = Velg hvilken liste { -brand-short-name } bruker for å blokkere sporere på internett. Lister levert av <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Liste

blocklist-button-cancel =
    .label = Avbryt
    .accesskey = A

blocklist-button-ok =
    .label = Lagre endringer
    .accesskey = L

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Blokkeringsliste nivå 1 (anbefalt).
blocklist-item-moz-std-description = Tillater noen sporings-element, så de fleste nettsteder fungerer som de skal.
blocklist-item-moz-full-listName = Blokkeringsliste nivå 2
blocklist-item-moz-full-description = Blokkerer alle kjente sporingselement. Dette kan i noen tilfeller hindre innlesing av nettsteder eller innhold.
