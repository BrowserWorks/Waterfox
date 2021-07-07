# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = Gerir cookies e dados de sites
site-data-settings-description = Os sites seguintes armazenam cookies e dados de sites no seu computador. O { -brand-short-name } mantém os dados de sites com armazenamento persistente até os remover e elimina os dados de sites com armazenamento não-persistente quando é necessário espaço.
site-data-search-textbox =
    .placeholder = Pesquisar sites
    .accesskey = P
site-data-column-host =
    .label = Site
site-data-column-cookies =
    .label = Cookies
site-data-column-storage =
    .label = Armazenamento
site-data-column-last-used =
    .label = Última utilização
# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = (ficheiro local)
site-data-remove-selected =
    .label = Remover selecionados
    .accesskey = R
site-data-button-cancel =
    .label = Cancelar
    .accesskey = C
site-data-button-save =
    .label = Guardar alterações
    .accesskey = a
site-data-settings-dialog =
    .buttonlabelaccept = Guardar alterações
    .buttonaccesskeyaccept = a
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value } (Persistente)
site-data-remove-all =
    .label = Remover todos
    .accesskey = e
site-data-remove-shown =
    .label = Remover todos os mostrados
    .accesskey = e

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = Remover
site-data-removing-header = Remover cookies e dados de sites
site-data-removing-desc = Remover cookies e dados de sites pode terminar a sessão nos sites. Tem a certeza que pretende fazer as alterações?
site-data-removing-table = Serão removidas as cookies e os dados dos seguintes sites
