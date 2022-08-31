# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Blockierlisten
    .style = width: 70em

blocklist-description = Liste auswählen, welche { -brand-short-name } zum Blockieren von Ihre Internetaktivitäten verfolgenden Web-Elementen verwenden soll. Die Listen werden von <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a> bereitgestellt.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Liste

blocklist-dialog =
    .buttonlabelaccept = Änderungen speichern
    .buttonaccesskeyaccept = s


# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Blockierliste Stufe 1 (empfohlen):
blocklist-item-moz-std-description = Einige Elemente zur Aktivitätenverfolgung werden zugelassen, damit es weniger Probleme mit dem Funktionieren von Websites gibt.
blocklist-item-moz-full-listName = Blockierliste Stufe 2:
blocklist-item-moz-full-description = Alle erkannten Elemente zur Aktivitätenverfolgung ("Tracker") werden blockiert. Einige Websites oder Inhalte laden eventuell nicht richtig.
