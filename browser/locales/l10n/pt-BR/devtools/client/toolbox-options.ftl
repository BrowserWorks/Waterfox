# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Ferramentas padrão de desenvolvimento
# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Não suportado pelo alvo atual das ferramentas
# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Ferramentas de desenvolvimento instaladas por extensões
# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Botões na barra de ferramentas
# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Temas

## Inspector section

# The heading
options-context-inspector = Inspetor
# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Exibir estilos do navegador
options-show-user-agent-styles-tooltip =
    .title = Mostrar estilos padrão carregados pelo navegador.
# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Truncar atributos DOM
options-collapse-attrs-tooltip =
    .title = Truncar atributos longos no inspetor

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Unidade de cor padrão
options-default-color-unit-authored = Conforme o autor
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Nomes de cor

## Style Editor section

# The heading
options-styleeditor-label = Editor de estilos
# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Preencher CSS automaticamente
options-stylesheet-autocompletion-tooltip =
    .title = Preencher automaticamente propriedades, valores e seletores CSS no editor de estilos à medida que você digita

## Screenshot section

# The heading
options-screenshot-label = Comportamento da captura de tela
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-only-label = Capturar tela apenas para área de transferência
options-screenshot-clipboard-tooltip2 =
    .title = Salva a captura de tela diretamente na área de transferência
# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Tocar som de obturador da câmera
options-screenshot-audio-tooltip =
    .title = Ativar o som da câmera ao capturar tela

## Editor section

# The heading
options-sourceeditor-label = Preferências do editor
options-sourceeditor-detectindentation-tooltip =
    .title = Adivinhar a indentação com base no conteúdo do código
options-sourceeditor-detectindentation-label = Detectar indentação
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Inserir automaticamente o fechamento de parênteses, chaves e colchetes
options-sourceeditor-autoclosebrackets-label = Fechar parênteses, chaves e colchetes automaticamente
options-sourceeditor-expandtab-tooltip =
    .title = Usar espaços em vez do caractere de tabulação
options-sourceeditor-expandtab-label = Indentar usando espaços
options-sourceeditor-tabsize-label = Tamanho da tabulação
options-sourceeditor-keybinding-label = Associação de teclas
options-sourceeditor-keybinding-default-label = Normal

## Advanced section

# The heading (this item is also used in perftools.ftl)
options-context-advanced-settings = Configurações avançadas
# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Desativar cache HTTP (quando as ferramentas estão abertas)
options-disable-http-cache-tooltip =
    .title = Desativar cache HTTP de todas as abas que estão com as ferramentas de desenvolvimento abertas. Service workers não são afetados por esta opção.
# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Desativar JavaScript *
options-disable-javascript-tooltip =
    .title = Desativar JavaScript na aba atual. Esta configuração é esquecida se fechar a aba ou as ferramentas.
# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Ativar ferramentas de debug do chrome do navegador e de extensões
options-enable-chrome-tooltip =
    .title = Permitir usar várias ferramentas de desenvolvimento no contexto do navegador (via Ferramentas > Desenvolvimento web > Ferramentas do navegador) e debugar extensões a partir do gerenciador de extensões
# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Ativar depuração remota
options-enable-remote-tooltip2 =
    .title = Permitir debugar remotamente esta instância do navegador
# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Ativar Service Workers sobre HTTP (quando as ferramentas estão abertas)
options-enable-service-workers-http-tooltip =
    .title = Permitir service workers sobre HTTP em todas as abas que estejam com as ferramentas abertas.
# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Ativar mapas de fontes
options-source-maps-tooltip =
    .title = Mapear fontes nas ferramentas.
# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * somente na sessão atual, a página é recarregada
# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Exibir dados da plataforma Gecko
options-show-platform-data-tooltip =
    .title = Incluir símbolos da plataforma Gecko em relatórios do profiler JavaScript
