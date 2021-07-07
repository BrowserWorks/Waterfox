# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Blokeringslister
    .style = width: 55em
blocklist-description = Vælg hvilken liste, { -brand-short-name } skal bruge til at blokere sporings-teknologier på nettet. Listerne leveres af <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w
blocklist-treehead-list =
    .label = Liste
blocklist-button-cancel =
    .label = Fortryd
    .accesskey = F
blocklist-button-ok =
    .label = Gem ændringer
    .accesskey = G
blocklist-dialog =
    .buttonlabelaccept = Gem ændringer
    .buttonaccesskeyaccept = G
# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }
blocklist-item-moz-std-listName = Blokeringsliste niveau 1 (anbefalet).
blocklist-item-moz-std-description = Tillader nogle sporings-teknologier, så de fleste websteder fungerer som de skal.
blocklist-item-moz-full-listName = Blokeringsliste niveau 2.
blocklist-item-moz-full-description = Blokerer alle kendte sporings-teknologier. Dette kan i nogle tilfælde forhindre indlæsning af websteder eller indhold.
