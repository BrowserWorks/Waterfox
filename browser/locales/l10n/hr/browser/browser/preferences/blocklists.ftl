# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Popisi blokiranja
    .style = width: 55em

blocklist-description = Odaberi popis koji će { -brand-short-name } koristiti za blokiranje programa za praćenje. Popise pruža <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Popis

blocklist-button-cancel =
    .label = Otkaži
    .accesskey = t

blocklist-button-ok =
    .label = Spremi promjene
    .accesskey = S

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Razina 1 popisa za blokiranje (preporučeno).
blocklist-item-moz-std-description = Dozvoljava neke programe za praćenje, kako bi se smanjio broj pogrešno prikazanih web stranica.
blocklist-item-moz-full-listName = Razina 2 popisa za blokiranje.
blocklist-item-moz-full-description = Blokira sve pratitelje. Neke web stranice ili sadržaji se možda neće ispravno učitati.
