# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Zoznamy blokovania
    .style = width: 50em

blocklist-description = Vyberte zoznam, ktorý { -brand-short-name } použije na blokovanie sledovacích prvkov. Zoznamy poskytuje organizácia <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Zoznam

blocklist-button-cancel =
    .label = Zrušiť
    .accesskey = Z

blocklist-button-ok =
    .label = Uložiť zmeny
    .accesskey = U

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Základný zoznam (odporúča sa).
blocklist-item-moz-std-description = Povoľuje niektoré sledovacie prvky, aby stránky mohli fungovať správne.
blocklist-item-moz-full-listName = Rozšírený zoznam.
blocklist-item-moz-full-description = Blokuje všetky nájdené sledovacie prvky. Toto môže obmedziť fungovanie niektorých stránok.
