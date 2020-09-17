# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Listahan ng mga na-block
    .style = width: 55em

blocklist-description = Piliin ang listahan ng { -brand-short-name } na ginagamit sa pagharang ng mga online tracker. Ang mga listahan ay hatid ng <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Listahan

blocklist-button-cancel =
    .label = Kanselahin
    .accesskey = C

blocklist-button-ok =
    .label = I-save ang mga Pagbabago
    .accesskey = S

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Level 1 na block list (Inirerekomenda)
blocklist-item-moz-std-description = Payagan ang ilang mga tracker upang kakaunting websites lang ang masisira.
blocklist-item-moz-full-listName = Level 2 na block list.
blocklist-item-moz-full-description = Harangin lahat ng matuklasang tracker. Maaaring may mga website o nilalaman nito na hindi maipapakita nang maayos.
