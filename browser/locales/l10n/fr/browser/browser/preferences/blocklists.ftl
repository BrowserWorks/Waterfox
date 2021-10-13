# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Listes de blocage
    .style = width: 66em

blocklist-description = Choisissez quelle liste { -brand-short-name } utilise pour bloquer les traqueurs en ligne. Les listes proviennent de <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Liste

blocklist-dialog =
    .buttonlabelaccept = Enregistrer les modifications
    .buttonaccesskeyaccept = E


# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Liste de blocage de niveau 1 (recommandé).
blocklist-item-moz-std-description = Autorise certains traqueurs pour que moins de sites dysfonctionnent.
blocklist-item-moz-full-listName = Liste de blocage de niveau 2.
blocklist-item-moz-full-description = Bloque tous les traqueurs détectés. Certains sites web ou contenus peuvent ne pas se charger correctement.
