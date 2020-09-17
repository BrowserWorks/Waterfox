# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Blokkimise nimekirjad
    .style = width: 50em

blocklist-description = Vali nimekiri, mille alusel { -brand-short-name } blokib jälitajaid. Nimekirjad on koostanud <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Nimekiri

blocklist-button-cancel =
    .label = Loobu
    .accesskey = L

blocklist-button-ok =
    .label = Salvesta muudatused
    .accesskey = S

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = 1. taseme blokkimise nimekiri (soovitatav).
blocklist-item-moz-std-description = Mõned jälitajad on lubatud, et vähem saite katki läheks.
blocklist-item-moz-full-listName = 2. taseme blokkimise nimekiri.
blocklist-item-moz-full-description = Kõik tuvastatud jälitajad blokitakse. Mõned saidid või nende sisu ei pruugi korralikult toimida.
