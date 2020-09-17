# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Aisinas de desvolopament per defaut

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Pas gerit per la cibla actuala de la bóstia d'aisinas

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Aisinas installadas via moduls complementaris

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Botons de la bóstia d'aisinas disponibles

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Tèmas

## Inspector section

# The heading
options-context-inspector = Inspector

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Mostrar los estils navegador
options-show-user-agent-styles-tooltip =
    .title = Activar aquesta opcion aficharà los estils per defaut cargats pel navegador.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Troncar los atributs DOM
options-collapse-attrs-tooltip =
    .title = Troncar los atributs longs a l'inspector

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Unitat per defaut per las colors
options-default-color-unit-authored = coma d'origina
options-default-color-unit-hex = Exa
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RVB(A)
options-default-color-unit-name = Noms de colors

## Style Editor section

# The heading
options-styleeditor-label = Editor d'estils

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Completar automaticament lo CSS
options-stylesheet-autocompletion-tooltip =
    .title = Completar automaticament las proprietats, valors e selectors CSS dins l'editor d'estil al moment de la picada

## Screenshot section

# The heading
options-screenshot-label = Compòrtament per las capturas d’ecran

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Captura d'ecran cap al pòrtapapièr
options-screenshot-clipboard-tooltip =
    .title = Servar la captura d'ecran dirèctament al pòrtapapièr

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Emetre lo son d'un obturador optic
options-screenshot-audio-tooltip =
    .title = Activar lo son d’un obturador optic pendent la captura d’ecran

## Editor section

# The heading
options-sourceeditor-label = Preferéncias de l'editor

options-sourceeditor-detectindentation-tooltip =
    .title = Deduire l’indentacion en veire lo contengut font
options-sourceeditor-detectindentation-label = Detectar l’indentacion
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Inserir automaticament parentèsis e acoladas tampadas
options-sourceeditor-autoclosebrackets-label = Autotampar parentèsis e acoladas
options-sourceeditor-expandtab-tooltip =
    .title = Utilizar d'espacis puslèu que de caractèrs de tabulacion
options-sourceeditor-expandtab-label = Indentar mejans d’espacis
options-sourceeditor-tabsize-label = Talha de l'onglet
options-sourceeditor-keybinding-label = Combinasons de tòca
options-sourceeditor-keybinding-default-label = Per defaut

## Advanced section

# The heading
options-context-advanced-settings = Paramètres avançats

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Desactivar lo cache HTTP (quand la bóstia d'aisinas es dobèrta)
options-disable-http-cache-tooltip =
    .title = Activar aquesta opcion desactivarà lo cache HTTP per totes los onglets ont la bóstia d'aisina es dobèrta. Aquesta opcion a pas cap d'efièch sus los trabalhadors de servici.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Activar JavaScript *
options-disable-javascript-tooltip =
    .title = Activar aquesta opcion desactivarà JavaScript per l'onglet corrent. Aqueste paramètre serà doblidat a la tampadura de l'onglet o de la bóstia d'aisinas.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Activar lo desbogatge del chrome del navegador e dels moduls
options-enable-chrome-tooltip =
    .title = Activar aquesta opcion vos autorizarà a utilizar diferentas aisinas de desvelopament dins lo contèxte del navegador (via Aisinas > Desvelopament web > Bòstia d'aisinas del navegador) e de desbogar de moduls dempuèi lo gestionari de moduls complementaris

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Activar lo desbugatge distant
options-enable-remote-tooltip2 =
    .title = L’activacion d’aquesta opcion permetrà de desbogar aquesta instància del navegador a distància

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Activar los trabalhdors de servici via HTTP (quand la bóstia d'aisinas es dobèrta)
options-enable-service-workers-http-tooltip =
    .title = Activar aquesta opcion activarà los trabalhadors de servici via HTTP per totes los onglets ont la bóstia d'aisinas es dobèrta.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Activar las mapas de font
options-source-maps-tooltip =
    .title = S’activatz aquesta opcion, las fonts seràn ligadas dins las aisinas.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Per aquesta session, recarga la pagina

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Afichar las donadas de la plataforma Gecko
options-show-platform-data-tooltip =
    .title = S’activatz aquesta opcion, los rapòrts del perfilaire JavaScript incluràn los simbòls de la plataforma Gecko
