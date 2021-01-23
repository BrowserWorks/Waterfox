# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Glistas da bloccar
    .style = width: 50em

blocklist-description = Tscherna la glista che { -brand-short-name } utilisescha per bloccar fastizaders online. Las glistas vegnan messas a disposiziun da <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Glista

blocklist-button-cancel =
    .label = Interrumper
    .accesskey = I

blocklist-button-ok =
    .label = Memorisar las midadas
    .accesskey = S

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Glista da bloccada livel 1 (recumandà).
blocklist-item-moz-std-description = Permetta tscherts fastizaders per limitar il dumber da websites che na funcziunan betg.
blocklist-item-moz-full-listName = Glista da bloccada livel 2.
blocklist-item-moz-full-description = Blochescha tut ils fastizaders chattads. Eventualmain datti problems cun chargiar tschertas websites u cuntegn specific.
