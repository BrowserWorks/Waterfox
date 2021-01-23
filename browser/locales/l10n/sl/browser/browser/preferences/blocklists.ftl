# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Seznami za zavračanje
    .style = width: 50em

blocklist-description = Izberite, kateri seznam naj { -brand-short-name } uporablja za zavračanje spletnih sledilcev. Sezname omogoča <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Seznam

blocklist-button-cancel =
    .label = Prekliči
    .accesskey = P

blocklist-button-ok =
    .label = Shrani spremembe
    .accesskey = S

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Seznam zavračanja ravni 1 (priporočeno).
blocklist-item-moz-std-description = Omogoča nekaj sledilcev, da se zmanjša nedelovanje spletnih mest.
blocklist-item-moz-full-listName = Seznam zavračanja ravni 2.
blocklist-item-moz-full-description = Zavrača vse zaznane sledilce. Nekatera spletna mesta ali vsebine morda ne bodo pravilno naložene.
