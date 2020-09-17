# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = தடை பட்டியல்
    .style = width: 55em

blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = பட்டியல்

blocklist-button-cancel =
    .label = இரத்து
    .accesskey = C

blocklist-button-ok =
    .label = மாற்றங்களைச் சேமிக்கவும்
    .accesskey = S

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

