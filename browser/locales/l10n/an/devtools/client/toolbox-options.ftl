# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Ferramientas de desenvolvimiento por defecto
# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Incompatible con l'elemento actual d'a caixa de ferramientas
# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Ferramientas de desembolicador instaladas por complementos
# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Botons disposables en a caixa de ferramientas
# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Temas

## Inspector section

# The heading
options-context-inspector = Inspector
# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Amostrar os estilos d'o navegador
options-show-user-agent-styles-tooltip =
    .title = Activando ista opción amostrará os estilos por defecto cargaus por o navegador
# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Truncar atributos DOM
options-collapse-attrs-tooltip =
    .title = Truncar atributos largos en o inspector

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Unidat de color predeterminada
options-default-color-unit-authored = Como s'ha creyau
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Nombres de colors

## Style Editor section

# The heading
options-styleeditor-label = Editor de estilo
# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Completar automaticament as CSS
options-stylesheet-autocompletion-tooltip =
    .title = Completar automaticament as propiedatz, as valuras y os selectors CSS en l'editor de estilos mientres a escritura

## Screenshot section

# The heading
options-screenshot-label = Comportamiento de foto de pantalla
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Gravar foto de pantalla en o portafuellas
options-screenshot-clipboard-tooltip =
    .title = Alza la foto de pantalla directament en o portafuellas
# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Reproducir lo soniu d'obturador d'a camara
options-screenshot-audio-tooltip =
    .title = Activa lo soniu d'a camara quan se fa foto de pantalla

## Editor section

# The heading
options-sourceeditor-label = Preferencias d'o editor
options-sourceeditor-detectindentation-tooltip =
    .title = Deducir sangría a partir d'o conteniu d'o codigo fuent
options-sourceeditor-detectindentation-label = Detectar sangría
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Insertar gafetz de zarrau automaticament
options-sourceeditor-autoclosebrackets-label = Zarrar automaticament os gafetz
options-sourceeditor-expandtab-tooltip =
    .title = Faiga servir espacios en cuenta d'o caracter pestanya
options-sourceeditor-expandtab-label = Fer sangría con espacios
options-sourceeditor-tabsize-label = Mida d'a pestanya
options-sourceeditor-keybinding-label = Combinaciones de teclas
options-sourceeditor-keybinding-default-label = Predeterminau

## Advanced section

# The heading
options-context-advanced-settings = Achustes abanzaus
# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Desactivar la caché HTTP (quan a caixa de ferramientas ye ubierta)
options-disable-http-cache-tooltip =
    .title = Activar ista opción desactiva la caché HTTP en totas las pestanyas que tienen la caixa de ferramientas ubierta. Los Service Workers no son afectaus por ista opción.
# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Desactivar JavaScript *
options-disable-javascript-tooltip =
    .title = Activando ista opción se desactivará JavaScript en a pestanya actual. Si a pestanya u caixa de ferramientas de zarra alavez iste achuste se descartará.
# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Activa as caixas de ferramientas de depuración d'o crome d'o navegador y complementos
options-enable-chrome-tooltip =
    .title = En activar ista opción se premitirá l'uso de diversas ferramientas ta desembolicadors en o contexto d'o navegador (fendo Ferramientas > Desembolicador web > Caixa de Ferramientas) y depurar complementos dende o Chestor de complementos.
# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Activar a depuración remota
# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Activar os Service Workers sobre HTTP (quan a caixa de ferramientas siga ubierta)
options-enable-service-workers-http-tooltip =
    .title = En activar ista opción s'habilitarán os service workers sobre HTTP pa todas as pestanyas que tienen a caixa de ferramientas ubierta.
# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Habilitar los mapas fuent
options-source-maps-tooltip =
    .title = Si activas esta opción las fuents serán mapiadas en as ferramientas.
# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * esviella a pachina nomás ta ista sesión
# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Amostrar os datos d'a plataforma Gecko
options-show-platform-data-tooltip =
    .title = Si activa ista opción, os informes d'o perfilador JavaScript incluirán os simbolos d'a plataforma Gecko
