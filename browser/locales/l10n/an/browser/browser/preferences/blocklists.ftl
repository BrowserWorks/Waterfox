# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Listas de bloqueyo
    .style = width: 55em

blocklist-description = Tría la lista que { -brand-short-name } fa servir pa blocar los elementos que tos fan seguimiento. Estas listas son proporcionadas per <a data-l10n-name="disconnect-link" title="Disconnectar">Desconnectar</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Lista

blocklist-button-cancel =
    .label = Cancelar
    .accesskey = C

blocklist-button-ok =
    .label = Alzar os cambios
    .accesskey = A

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Lista de bloqueyo de nivel 1 (recomendada).
blocklist-item-moz-std-description = Permite bell elemento de seguimiento, y asinas i hai menos webs que no funcionan.
blocklist-item-moz-full-listName = Lista de bloqueyo de nivel 2.
blocklist-item-moz-full-description = Bloqueya totz los elementos de seguimiento detectaus. Ye posible que bell puesto web u conteniu no se cargue correctament.
