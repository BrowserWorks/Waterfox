# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Listas de bloqueio
    .style = width: 55em
blocklist-description = Escolha a lista que o { -brand-short-name } utiliza para bloquear os rastreadores na Internet. As listas são fornecidas por <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w
blocklist-treehead-list =
    .label = Lista
blocklist-button-cancel =
    .label = Cancelar
    .accesskey = C
blocklist-button-ok =
    .label = Guardar alterações
    .accesskey = s
blocklist-dialog =
    .buttonlabelaccept = Guardar alterações
    .buttonaccesskeyaccept = s
# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }
blocklist-item-moz-std-listName = Lista de bloqueios de nível 1 (recomendado).
blocklist-item-moz-std-description = Permite alguns rastreadores para que menos sites falhem.
blocklist-item-moz-full-listName = Lista de bloqueios de nível 2.
blocklist-item-moz-full-description = Bloqueia todos os rastreadores detetados. Alguns sites ou conteúdos podem não carregar corretamente.
