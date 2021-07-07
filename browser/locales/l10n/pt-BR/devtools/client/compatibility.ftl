# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Elemento selecionado
compatibility-all-elements-header = Todos os problemas

## Message used as labels for the type of issue

compatibility-issue-deprecated = (obsoleto)
compatibility-issue-experimental = (experimental)
compatibility-issue-prefixneeded = (prefixo necessário)
compatibility-issue-deprecated-experimental = (obsoleto, experimental)
compatibility-issue-deprecated-prefixneeded = (obsoleto, prefixo necessário)
compatibility-issue-experimental-prefixneeded = (experimental, prefixo necessário)
compatibility-issue-deprecated-experimental-prefixneeded = (obsoleto, experimental, prefixo necessário)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Configurações
compatibility-settings-button-title =
    .title = Configurações
compatibility-feedback-button-label = Comentários
compatibility-feedback-button-title =
    .title = Comentários

## Messages used as headers in settings pane

compatibility-settings-header = Configurações
compatibility-target-browsers-header = Navegadores alvo

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } ocorrência
       *[other] { $number } ocorrências
    }
compatibility-no-issues-found = Nenhum problema de compatibilidade encontrado.
compatibility-close-settings-button =
    .title = Fechar configurações
