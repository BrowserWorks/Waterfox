# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Blokeo-zerrendak
    .style = width: 55em

blocklist-description = Aukeratu { -brand-short-name }(e)k jarraipen-elementuak blokeatzeko erabiliko duen zerrenda. Zerrenda <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>-ek hornitzen du.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Zerrenda

blocklist-button-cancel =
    .label = Utzi
    .accesskey = U

blocklist-button-ok =
    .label = Gorde aldaketak
    .accesskey = G

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Lehen mailako blokeo-zerrenda (gomendatua).
blocklist-item-moz-std-description = Zenbait jarraipen-elementu onartzen ditu beraz webgune gutxiago hautsiko dira.
blocklist-item-moz-full-listName = Bigarren mailako blokeo-zerrenda.
blocklist-item-moz-full-description = Antzemandako jarraipen-elementu guztiak blokeatzen ditu. Baliteke zenbait webgune edo eduki ondo ez kargatzea.
