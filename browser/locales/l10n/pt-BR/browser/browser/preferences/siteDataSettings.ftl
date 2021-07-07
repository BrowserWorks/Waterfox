# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = Gerenciar cookies e dados de sites
site-data-settings-description = Os seguintes sites armazenam cookies e dados no seu computador. O { -brand-short-name } mantém dados de sites com armazenamento persistente até você excluir e apaga dados de sites com armazenamento não persistente à medida que necessita de espaço.
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
    .label = Último uso
# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = (arquivo local)
site-data-remove-selected =
    .label = Remover selecionados
    .accesskey = r
site-data-settings-dialog =
    .buttonlabelaccept = Salvar alterações
    .buttonaccesskeyaccept = a
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value } (persistente)
site-data-remove-all =
    .label = Remover tudo
    .accesskey = e
site-data-remove-shown =
    .label = Remover todos os mostrados
    .accesskey = e

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = Remover
site-data-removing-header = Remoção de cookies e dados de sites
site-data-removing-desc = Remover cookies e dados de sites pode desconectar você de contas de sites. Tem certeza que quer fazer as alterações?
# Variables:
#   $baseDomain (String) - The single domain for which data is being removed
site-data-removing-single-desc = Remover cookies e dados de sites pode encerrar sessões de acesso. Tem certeza que quer remover cookies e dados de sites do domínio <strong>{ $baseDomain }</strong>?
site-data-removing-table = Os cookies e dados dos seguintes sites serão removidos
