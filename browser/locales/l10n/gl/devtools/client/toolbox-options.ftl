# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Ferramentas de desenvolvemento predeterminadas
# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Non é compatíbel co elemento actual da caixa de ferramentas
# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Ferramentas de desenvolvemento instaladas por complementos
# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Botóns da caixa de ferramentas
# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Temas

## Inspector section

# The heading
options-context-inspector = Inspector
# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Amosar os estilos do navegador
options-show-user-agent-styles-tooltip =
    .title = Activar esta opción amosará os estilos predeterminados cargados polo navegador.
# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Truncar os atributos DOM
options-collapse-attrs-tooltip =
    .title = Truncar os atributos largos no inspector

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Unidade de cor predeterminada
options-default-color-unit-authored = Como o orixinal
options-default-color-unit-hex = Hexadecimal
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Nomes de cores

## Style Editor section

# The heading
options-styleeditor-label = Editor de estilos
# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Completado automático CSS
options-stylesheet-autocompletion-tooltip =
    .title = Completado automático mentres se escribe no editor de estilos para as propiedades, valores e selectores CSS

## Screenshot section

# The heading
options-screenshot-label = Comportamento das capturas de pantalla
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Gardar no portapapeis
options-screenshot-clipboard-tooltip =
    .title = Garda a captura de pantalla directamente no portapapeis
# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Reproducir son do obturador dunha cámara
options-screenshot-audio-tooltip =
    .title = Activa o son do obturador dunha cámara ao tomar unha captura de pantalla

## Editor section

# The heading
options-sourceeditor-label = Preferencia do editor
options-sourceeditor-detectindentation-tooltip =
    .title = Deducir sangrado baseándose no contido do código fonte
options-sourceeditor-detectindentation-label = Detectar sangrado
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Insire automaticamente os parénteses de peche
options-sourceeditor-autoclosebrackets-label = Pechar parénteses automaticamente
options-sourceeditor-expandtab-tooltip =
    .title = Usar espazos no lugar do carácter de tabulación
options-sourceeditor-expandtab-label = Usar espazos para o sangrado
options-sourceeditor-tabsize-label = Tamaño da lapela
options-sourceeditor-keybinding-label = Combinacións de teclas
options-sourceeditor-keybinding-default-label = Predeterminado

## Advanced section

# The heading
options-context-advanced-settings = Configuración avanzada
# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Desactivar a caché HTTP (cando a caixa de ferramentas está aberta)
options-disable-http-cache-tooltip =
    .title = Activar esta opción desactivará a caché HTTP en todas as lapelas que teñan a caixa de ferramentas aberta. Esta opción non afecta aos service workers.
# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Desactivar JavaScript *
options-disable-javascript-tooltip =
    .title = Activar esta opción desactivará JavaScript na lapela actual. Se a lapela ou a caixa de ferramentas se pecha esquecerase esta configuración.
# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Activar a depuración chrome do navegador e dos complementos
options-enable-chrome-tooltip =
    .title = Activar esta opción permitíralle usar varias ferramentas de desenvolvemento no contexto do navegador (a través de Ferramentas > Web Developer  > Caixa de ferramentas do navegador) e depurar complementos dende o Xestor de complementos
# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Activar a depuración remota
options-enable-remote-tooltip2 =
    .title = Se activa esta opción permitirá depurar de forma remota esta instancia do navegador
# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Activar Service workers baixo HTTP (cando a caixa de ferramentas está aberta)
options-enable-service-workers-http-tooltip =
    .title = Activar esta opción activará o Service worker baixo HTTP en todas as lapelas que teñan a caixa de ferramentas aberta.
# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Activar ligazóns a fontes
options-source-maps-tooltip =
    .title = Se activa esta opción, as fontes ligaranse nas ferramentas.
# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Para a sesión actual, recargue a páxina
# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Amosar os datos da plataforma Gecko
options-show-platform-data-tooltip =
    .title = Se activa esta opción, os informes do analizador JavaScript incluirán os símbolos da plataforma Gecko
