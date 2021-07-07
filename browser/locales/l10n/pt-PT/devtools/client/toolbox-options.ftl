# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Ferramentas de programador predefinidas
# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Não suportado para o destino atual da caixa de ferramentas
# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Ferramentas de programador instaladas por extras
# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Botões da caixa de ferramentas disponíveis
# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Temas

## Inspector section

# The heading
options-context-inspector = Inspetor
# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Mostrar estilos do navegador
options-show-user-agent-styles-tooltip =
    .title = Ative para que sejam mostrados os estilos predefinidos que são carregados pelo navegador.
# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Truncar atributos DOM
options-collapse-attrs-tooltip =
    .title = Truncar atributos longos no inspetor

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Unidade predefinida de cor
options-default-color-unit-authored = Como autorizada
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Nomes de cores

## Style Editor section

# The heading
options-styleeditor-label = Editor de estilos
# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Conclusão automática de CSS
options-stylesheet-autocompletion-tooltip =
    .title = Completa automaticamente as propriedades CSS, os valores e os seletores no editor de estilos assim que forme escritos

## Screenshot section

# The heading
options-screenshot-label = Comportamento da captura de ecrã
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Tirar uma captura de ecrã para a área de transferência
options-screenshot-clipboard-tooltip =
    .title = Guarda a captura de ecrã diretamente para a área de transferência
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-only-label = Capturar o ecrã para a área de transferência apenas
options-screenshot-clipboard-tooltip2 =
    .title = Guarda a captura de ecrã diretamente para a área de transferência
# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Reproduzir som de obturador de câmara
options-screenshot-audio-tooltip =
    .title = Ativa o som do áudio de câmara ao tirar uma captura de ecrã

## Editor section

# The heading
options-sourceeditor-label = Preferências do editor
options-sourceeditor-detectindentation-tooltip =
    .title = Inferir indentação com base na fonte do código
options-sourceeditor-detectindentation-label = Detetar indentação
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Inserir parêntesis retos de fecho automaticamente
options-sourceeditor-autoclosebrackets-label = Fechar parêntesis retos automaticamente
options-sourceeditor-expandtab-tooltip =
    .title = Utilizar espaços em vez do caractere de tabulação
options-sourceeditor-expandtab-label = Indentar usando espaços
options-sourceeditor-tabsize-label = Tamanho da tabulação
options-sourceeditor-keybinding-label = Combinações de teclas
options-sourceeditor-keybinding-default-label = Predefinição

## Advanced section

# The heading (this item is also used in perftools.ftl)
options-context-advanced-settings = Definições avançadas
# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Desativar cache HTTP (quando a caixa de ferramentas está aberta)
options-disable-http-cache-tooltip =
    .title = Ligar esta opção irá desativar o cache HTTP para todos os separadores que têm a caixa de ferramentas aberta. Os Service Workers não são afetados por esta opção.
# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Desativar JavaScript
options-disable-javascript-tooltip =
    .title = Se ativar esta opção desativa o JavaScript no separador atual. Se o separador ou a caixa de ferramentas for fechado, então esta definição será esquecida.
# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Ativar caixas de ferramentas de depuração do navegador e dos extras
options-enable-chrome-tooltip =
    .title = Ativar esta opção irá permitir que utilize várias ferramentas de programador no contexto do navegador (via Ferramentas > Ferramentas de programação > Caixa de ferramentas do navegador) e depurar extras a partir do Gestor de extras
# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Ativar depuração remota
options-enable-remote-tooltip2 =
    .title = Ao ativar esta opção irá permitir a depuração remota desta instância do navegador
# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Ativar Service Workers sobre HTTP (se a caixa de ferramentas estiver aberta)
options-enable-service-workers-http-tooltip =
    .title = Ligar esta opção irá ativar os service workers sob HTTP para todos os separadores que têm a caixa de ferramentas aberta.
# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Ativar mapas de fonte
options-source-maps-tooltip =
    .title = Se ativar esta opção as fontes serão mapeadas nas ferramentas.
# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Apenas sessão atual, recarrega a página
# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Mostrar dados da plataforma Gecko
options-show-platform-data-tooltip =
    .title = Ao ativar esta opção os relatórios JavaScript irão incluir os símbolos da plataforma Gecko
