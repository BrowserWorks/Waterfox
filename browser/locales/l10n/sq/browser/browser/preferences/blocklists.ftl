# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Lista Bllokimesh
    .style = width: 50em

blocklist-description = Zgjidhni listën që përdor { -brand-short-name } për të bllokuar gjurmues internetorë. Lista të furnizuara nga <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Listë

blocklist-button-cancel =
    .label = Anuloje
    .accesskey = A

blocklist-button-ok =
    .label = Ruaji Ndryshimet
    .accesskey = R

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Listë bllokimesh e Shkallës 1 (E këshilluar).
blocklist-item-moz-std-description = Lejon disa gjurmues, ndaj prish punë në më pak sajte.
blocklist-item-moz-full-listName = Listë bllokimesh e Shkallës 2.
blocklist-item-moz-full-description = Bllokon krejt gjurmues e pikasur. Disa sajte ose lëndë mund të mos ngarkohet si duhet.
