# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Ferramientes de desendolcador predeterminaes

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Non compatible col elementu actual de la caxa de ferramientes

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Ferramientes de desendolcador instalaes por complementos

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Botones disponibles na caxa de ferramientes

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Temes

## Inspector section

# The heading
options-context-inspector = Inspeutor

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Amosar estilos del restolador
options-show-user-agent-styles-tooltip =
    .title = Activar esto, va amosar los estilos por defeutu que se carguen pol restolador.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Truncar atributos DOM
options-collapse-attrs-tooltip =
    .title = Truncar atributos llargos nel inspeutor

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Unidá de color predetermináu
options-default-color-unit-authored = Como Autoría
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB (A)
options-default-color-unit-name = Nomes de colores

## Style Editor section

# The heading
options-styleeditor-label = Editor d'estilos

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Autocompletar CSS
options-stylesheet-autocompletion-tooltip =
    .title = Autocompletar propiedaes, valores y seleutores CSS nel editor d'estilos a midida qu'escribes

## Screenshot section


## Editor section

# The heading
options-sourceeditor-label = Preferencies del editor

options-sourceeditor-detectindentation-tooltip =
    .title = Deducir sangráu basándose nel conteníu del códigu fonte
options-sourceeditor-detectindentation-label = Deteutar sangráu
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Inxertar llaves de zarru automáticamente
options-sourceeditor-autoclosebrackets-label = Zarrar llaves automáticamente
options-sourceeditor-expandtab-tooltip =
    .title = Usar espacios en cuenta del caráuter de tabulación
options-sourceeditor-expandtab-label = Sangrar usando espacios
options-sourceeditor-tabsize-label = Tamañu de la llingüeta
options-sourceeditor-keybinding-label = Combinaciones de tecles
options-sourceeditor-keybinding-default-label = Predetermináu

## Advanced section

# The heading
options-context-advanced-settings = Axustes avanzaos

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Desactivar caché HTTP (cuando la caxa de ferramientes tea abierta)
options-disable-http-cache-tooltip =
    .title = Habilitar esta opción va deshabilitar el caché HTTP pa toles llingüetes que tengan la caxa de ferramientes abierta. Los Service Workers nun tán afeutaos por esta opción.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Desactivar JavaScript *
options-disable-javascript-tooltip =
    .title = Activar esta opción va desactivar JavaScript na llingüeta actual. Si la llingüeta o la caxa de ferramientes se zarra, entós esti axuste va descartase.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Activar caxes de ferramientes de depuración de chrome del restolador y del complementu
options-enable-chrome-tooltip =
    .title = Activar esta opción va permitie usar delles ferramientes de desendolcador nel contestu del restolador (al traviés de Ferramientes > Desendolcador web > Caxa de ferramientes del restolador) y depurar complementos dende l'alministrador de complementos

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Activar depuración remota

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Activar service workers baxo HTTP (cuando la caxa de ferramientes tea abierta)
options-enable-service-workers-http-tooltip =
    .title = Activar esta opción va activar los service workers al traviés de HTTP pa toles llingüetes que tengan la caxa de ferramientes abierta.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Habilitar mapes de fontes

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Namái sesión actual, recarga la páxina

##

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Amosar datos de la plataforma Gecko
options-show-platform-data-tooltip =
    .title = Si actives esta opción, los informes del analizador JavaScript van incluyir los símbolos de la plataforma Gecko
