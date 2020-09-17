# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Llistes de bloquejos
    .style = width: 55em

blocklist-description = Trieu la llista que el { -brand-short-name } utilitza per blocar els elements us fan el seguiment. Llistes proporcionades per <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Llista

blocklist-button-cancel =
    .label = Cancel·la
    .accesskey = C

blocklist-button-ok =
    .label = Desa els canvis
    .accesskey = s

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Llista de bloquejos de nivell 1 (recomanada).
blocklist-item-moz-std-description = Permet alguns elements de seguiment per tal que hi hagi menys llocs web que no funcionin.
blocklist-item-moz-full-listName = Llista de bloquejos de nivell 2.
blocklist-item-moz-full-description = Bloca tots els elements de seguiment detectats. És possible que alguns llocs web o contingut no es carreguin correctament.
