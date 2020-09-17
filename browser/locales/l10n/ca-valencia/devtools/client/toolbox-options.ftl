# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Eines per a desenvolupadors per defecte

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * No és compatible amb l'element actual de la caixa d'eines

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Eines per a desenvolupadors instal·lades per complements

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Botons de la caixa d'eines disponibles

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Temes

## Inspector section

# The heading
options-context-inspector = Inspector

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Mostra els estils del navegador
options-show-user-agent-styles-tooltip =
    .title = En activar esta opció es mostraran els estils per defecte que ha carregat el navegador.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Trunca els atributs DOM
options-collapse-attrs-tooltip =
    .title = Trunca els atributs llargs a l'inspector

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Unitat per defecte dels colors
options-default-color-unit-authored = Tal com s'ha creat
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Noms de colors

## Style Editor section

# The heading
options-styleeditor-label = Editor d'estils

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Autocompleta el CSS
options-stylesheet-autocompletion-tooltip =
    .title = Completa automàticament propietats CSS, valors i selectors en l'editor d'estils a mesura que s'escriu

## Screenshot section

# The heading
options-screenshot-label = Comportament de la captura de pantalla

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Captura de pantalla al porta-retalls
options-screenshot-clipboard-tooltip =
    .title = Guarda la captura de pantalla directament al porta-retalls

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Reprodueix un so d'obturador de càmera
options-screenshot-audio-tooltip =
    .title = Activa el so d'obturador de càmera fotogràfica en fer una captura de pantalla

## Editor section

# The heading
options-sourceeditor-label = Preferències de l'editor

options-sourceeditor-detectindentation-tooltip =
    .title = Determina el sagnat en funció del contingut del codi font
options-sourceeditor-detectindentation-label = Detecta el sagnat
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Insereix automàticament els parèntesis, claudàtors i claus de tancament
options-sourceeditor-autoclosebrackets-label = Tanca els parèntesis automàticament
options-sourceeditor-expandtab-tooltip =
    .title = Utilitza espais en lloc del caràcter de tabulació
options-sourceeditor-expandtab-label = Sagna mitjançant espais
options-sourceeditor-tabsize-label = Mida de la tabulació
options-sourceeditor-keybinding-label = Assignacions de tecles
options-sourceeditor-keybinding-default-label = Per defecte

## Advanced section

# The heading
options-context-advanced-settings = Paràmetres avançats

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Inhabilita la memòria cau HTTP (quan la caixa d'eines està oberta)
options-disable-http-cache-tooltip =
    .title = Activeu esta opció per inhabilitar la memòria cau HTTP per a totes les pestanyes que tinguen oberta la caixa d'eines. Esta opció no afecta els processos de treball de servei.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Inhabilita el JavaScript *
options-disable-javascript-tooltip =
    .title = Activeu esta opció per inhabilitar el JavaScript en la pestanya actual. Este paràmetre s'oblidarà quan tanqueu la pestanya o la caixa d'eines.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Habilita les caixes d'eines de depuració del chrome del navegador i complements
options-enable-chrome-tooltip =
    .title = Activeu esta opció per permetre l'ús de diverses eines per a desenvolupadors en el context del navegador (mitjançant Eines > Desenvolupador web > Caixa d'eines) i depurar complements des del Gestor de complements

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Habilita la depuració remota

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Habilita els processos de treball de servei a través de HTTP (quan la caixa d'eines és oberta)
options-enable-service-workers-http-tooltip =
    .title = Activeu esta opció per permetre els processos de treball de servei a través de HTTP en totes les pestanyes que tinguen la caixa d'eines oberta.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Habilita els mapes de fonts
options-source-maps-tooltip =
    .title = Si habiliteu esta opció, es maparan les fonts en les eines.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Només la sessió actual, recarrega la pàgina

##

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Mostra dades de la plataforma Gecko
options-show-platform-data-tooltip =
    .title = Si activeu esta opció, els informes de l'Analitzador de JavaScript inclouran els símbols de la plataforma Gecko
