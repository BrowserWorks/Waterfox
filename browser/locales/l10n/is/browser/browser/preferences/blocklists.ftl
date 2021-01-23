# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Lokunarlistar
    .style = width: 55em

blocklist-description = Veldu listann sem { -brand-short-name } notar til að loka á rekja spor einhvers. Listar í boði <a data-l10n-name="disconnect-link" title="Discoonnect"> Aftengja </a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Listi

blocklist-button-cancel =
    .label = Hætta við
    .accesskey = H

blocklist-button-ok =
    .label = Vista breytingar
    .accesskey = s

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Fyrsta stigs lokun (mælt með).
blocklist-item-moz-std-description = Leyfir sumum að rekja spor svo fleiri vefsíður virki.
blocklist-item-moz-full-listName = Annars stigs lokun.
