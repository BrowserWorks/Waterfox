# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Block Lists
    .style = width: 55em

blocklist-description = Choose the list { -brand-short-name } uses to block online trackers. Lists provided by <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = List

blocklist-dialog =
    .buttonlabelaccept = Save Changes
    .buttonaccesskeyaccept = S


# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Level 1 block list (Recommended).
blocklist-item-moz-std-description = Allows some trackers so fewer web sites break.
blocklist-item-moz-full-listName = Level 2 block list.
blocklist-item-moz-full-description = Blocks all detected trackers. Some web sites or content may not load properly.
