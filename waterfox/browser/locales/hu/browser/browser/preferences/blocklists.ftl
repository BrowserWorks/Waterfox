# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Blokkolási listák
    .style = width: 55em

blocklist-description = Válassza ki a listát, amelyet a { -brand-short-name } az online nyomkövetők blokkolásához használjon. A listákat a <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a> biztosítja.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Listázás

blocklist-dialog =
    .buttonlabelaccept = Változtatások mentése
    .buttonaccesskeyaccept = V


# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = 1. szintű blokkolási lista (ajánlott).
blocklist-item-moz-std-description = Néhány követőt engedélyez, így kevesebb weboldal fog hibásan működni.
blocklist-item-moz-full-listName = 2. szintű blokkolási lista.
blocklist-item-moz-full-description = Blokkolja az összes észlelt nyomkövetőt. Egyes webhelyek vagy tartalmak lehet, hogy nem megfelelően fognak betöltődni.
