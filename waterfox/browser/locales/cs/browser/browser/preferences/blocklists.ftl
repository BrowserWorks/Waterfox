# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Úrovně blokování
    .style = width: 55em

blocklist-description = Vyberte seznam, který { -brand-short-name } použije pro blokování sledovacích prvků. Seznamy poskytuje <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Úroveň

blocklist-dialog =
    .buttonlabelaccept = Uložit změny
    .buttonaccesskeyaccept = U


# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Základní seznam (doporučený).
blocklist-item-moz-std-description = Povoluje některé sledovací prvky, aby stránky fungovaly správně.
blocklist-item-moz-full-listName = Rozšířený seznam.
blocklist-item-moz-full-description = Blokuje všechny nalezené sledovací prvky. Může omezit fungování některých stránek.
