# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Blokkearlisten
    .style = width: 55em

blocklist-description = Kies de list dy't { -brand-short-name } brûkt om online trackers te blokkearjen. Listen wurde oanbean troch <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = List

blocklist-button-cancel =
    .label = Annulearje
    .accesskey = A

blocklist-button-ok =
    .label = Wizigingen bewarje
    .accesskey = W

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Nivo 1-blokkearlist (Oanrekommandearre).
blocklist-item-moz-std-description = Stiet bepaalde trackers ta, sadat minder websites net goed wurkje.
blocklist-item-moz-full-listName = Nivo 2-blokkearlist.
blocklist-item-moz-full-description = Blokkearret alle detektearre trackers. Guon websites of ynhâld wurdt mooglik net goed laden.
