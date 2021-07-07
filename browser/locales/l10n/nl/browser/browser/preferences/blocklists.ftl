# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Blokkeerlijsten
    .style = width: 55em
blocklist-description = Kies de lijst die { -brand-short-name } gebruikt om online trackers te blokkeren. Lijsten worden aangeboden door <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w
blocklist-treehead-list =
    .label = Lijst
blocklist-button-cancel =
    .label = Annuleren
    .accesskey = A
blocklist-button-ok =
    .label = Wijzigingen opslaan
    .accesskey = W
blocklist-dialog =
    .buttonlabelaccept = Wijzigingen opslaan
    .buttonaccesskeyaccept = W
# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }
blocklist-item-moz-std-listName = Niveau 1-blokkeerlijst (Aanbevolen).
blocklist-item-moz-std-description = Staat bepaalde trackers toe, zodat minder websites niet goed werken.
blocklist-item-moz-full-listName = Niveau 2-blokkeerlijst.
blocklist-item-moz-full-description = Blokkeert alle gedetecteerde trackers. Sommige websites of inhoud wordt mogelijk niet goed geladen.
