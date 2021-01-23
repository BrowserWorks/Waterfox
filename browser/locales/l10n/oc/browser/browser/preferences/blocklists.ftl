# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Lista del blocatge
    .style = width: 55em

blocklist-description = Causissètz quina lista { -brand-short-name } utiliza per blocar los traçadors en linha. Las listas venon de <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Lista

blocklist-button-cancel =
    .label = Anullar
    .accesskey = N

blocklist-button-ok =
    .label = Enregistrar las modificacions
    .accesskey = E

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Lista de blocatge de nivèl 1 (recomandada).
blocklist-item-moz-std-description = Autoriza certans traçadors per que mens de sites quiten de foncionar.
blocklist-item-moz-full-listName = Lista de blocatge de nivèl 2.
blocklist-item-moz-full-description = Bloca los traçadors detectats. Es possible qu’unes sites web o contenguts se carguen pas corrèctament.
