# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Listas de bloqueio
    .style = width: 50em
blocklist-description = Escolha a lista que o { -brand-short-name } deve usar para bloquear rastreadores online. Listas fornecidas por <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w
blocklist-treehead-list =
    .label = Lista
blocklist-button-cancel =
    .label = Cancelar
    .accesskey = C
blocklist-button-ok =
    .label = Salvar alterações
    .accesskey = S
blocklist-dialog =
    .buttonlabelaccept = Salvar alterações
    .buttonaccesskeyaccept = S
# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }
blocklist-item-moz-std-listName = Nível 1 (recomendado).
blocklist-item-moz-std-description = Permite alguns rastreadores para que menos sites tenham o funcionamento afetado.
blocklist-item-moz-full-listName = Nível 2.
blocklist-item-moz-full-description = Bloqueia todos os rastreadores detectados. Alguns sites ou partes do conteúdo podem não ser carregados corretamente.
