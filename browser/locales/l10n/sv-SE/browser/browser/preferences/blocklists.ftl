# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Blockeringslistor
    .style = width: 55em
blocklist-description = Välj den lista som { -brand-short-name } använder för att blockera spårare på nätet. Listor som tillhandahålls av <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w
blocklist-treehead-list =
    .label = Lista
blocklist-button-cancel =
    .label = Avbryt
    .accesskey = A
blocklist-button-ok =
    .label = Spara ändringar
    .accesskey = S
blocklist-dialog =
    .buttonlabelaccept = Spara ändringar
    .buttonaccesskeyaccept = S
# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }
blocklist-item-moz-std-listName = Blockeringslista nivå 1 (rekommenderas).
blocklist-item-moz-std-description = Tillåter vissa spårare så färre fel orsakas på webbplatser.
blocklist-item-moz-full-listName = Blockeringslista nivå 2.
blocklist-item-moz-full-description = Blockerar alla upptäckta spårare. Vissa webbplatser eller innehåll kanske inte laddas korrekt.
