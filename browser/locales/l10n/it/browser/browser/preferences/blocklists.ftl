# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Elenchi per blocco elementi traccianti
    .style = width: 55em

blocklist-description = Scegliere l’elenco da utilizzare in { -brand-short-name } per bloccare gli elementi traccianti online. Elenchi forniti da <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Elenco

blocklist-dialog =
    .buttonlabelaccept = Salva modifiche
    .buttonaccesskeyaccept = S


# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Elenco livello 1 (consigliato).
blocklist-item-moz-std-description = Consente alcuni elementi traccianti per limitare il numero di siti web malfunzionanti.
blocklist-item-moz-full-listName = Elenco livello 2.
blocklist-item-moz-full-description = Blocca tutti gli elementi traccianti rilevati. Alcuni siti web o contenuti potrebbero non essere caricati correttamente.
