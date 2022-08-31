# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Lista de bloqueos
    .style = width: 50em

blocklist-description = Elige la lista que { -brand-short-name } utiliza para bloquear los rastreadores en línea. Listas proporcionadas por <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Lista

blocklist-dialog =
    .buttonlabelaccept = Guardar cambios
    .buttonaccesskeyaccept = G


# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Lista de bloqueo de nivel 1 (recomendado).
blocklist-item-moz-std-description = Permite algunos rastreadores para que menos sitios dejen de funcionar.
blocklist-item-moz-full-listName = Lista de bloqueo de nivel 2.
blocklist-item-moz-full-description = Bloquea todos los rastreadores detectados. Algunos sitios web o contenidos podrían no cargar correctamente.
