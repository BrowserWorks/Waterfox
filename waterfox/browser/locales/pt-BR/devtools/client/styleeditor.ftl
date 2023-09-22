# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

styleeditor-new-button =
    .tooltiptext = Criar e anexar uma nova folha de estilo ao documento
    .accesskey = N
styleeditor-import-button =
    .tooltiptext = Importar e anexar uma folha de estilo existente ao documento
    .accesskey = I
styleeditor-filter-input =
    .placeholder = Filtrar folhas de estilo
styleeditor-visibility-toggle =
    .tooltiptext = Alternar visibilidade da folha de estilo
    .accesskey = S
styleeditor-visibility-toggle-system =
    .tooltiptext = Folhas de estilo do sistema não podem ser desativadas
styleeditor-save-button = Salvar
    .tooltiptext = Salvar esta folha de estilo em arquivo
    .accesskey = S
styleeditor-options-button =
    .tooltiptext = Opções do editor de estilos
styleeditor-at-rules = Regras com @
styleeditor-editor-textbox =
    .data-placeholder = Digite CSS aqui.
styleeditor-no-stylesheet = Esta página não tem folha de estilo.
styleeditor-no-stylesheet-tip = Quer <a data-l10n-name="append-new-stylesheet">anexar uma nova folha de estilo</a>?
styleeditor-open-link-new-tab =
    .label = Abrir link em nova aba
styleeditor-copy-url =
    .label = Copiar URL
styleeditor-find =
    .label = Procurar
    .accesskey = P
styleeditor-find-again =
    .label = Procurar próximo
    .accesskey = x
styleeditor-go-to-line =
    .label = Ir para linha…
    .accesskey = l
# Label displayed when searching a term that is not found in any stylesheet path
styleeditor-stylesheet-all-filtered = Não foi encontrada nenhuma folha de estilo correspondente.

# This string is shown in the style sheets list
# Variables:
#   $ruleCount (Integer) - The number of rules in the stylesheet.
styleeditor-stylesheet-rule-count =
    { $ruleCount ->
        [one] { $ruleCount } regra.
       *[other] { $ruleCount } regras.
    }
