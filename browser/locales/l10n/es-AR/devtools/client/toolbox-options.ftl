# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Herramientas de desarrollador predeterminadas

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * No soportado para el destino de caja de herramientas actual

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Herramientas de desarrollador instaladas por complementos

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Botones de la barra disponibles

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Temas

## Inspector section

# The heading
options-context-inspector = Inspector

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Mostrar estilos del navegador
options-show-user-agent-styles-tooltip =
    .title = Habilitar esta opción mostrará los estilos predeterminados que son cargados por el navegador.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Truncar atributos DOM
options-collapse-attrs-tooltip =
    .title = Truncar atributos largos en el inspector

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Unidad de color predeterminada
options-default-color-unit-authored = Como el autor
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Nombres de colores

## Style Editor section

# The heading
options-styleeditor-label = Editor de estilos

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Autocompletar CSS
options-stylesheet-autocompletion-tooltip =
    .title = Autocompletar propiedades, valores y selectores CSS en el editor de estilos mientras escribe

## Screenshot section

# The heading
options-screenshot-label = Comportamiento de la captura de pantalla

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Captura de pantalla al portapapeles
options-screenshot-clipboard-tooltip =
    .title = Guardar la captura de pantalla directamente en el portapapeles

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Reproducir sonido de obturador de cámara
options-screenshot-audio-tooltip =
    .title = Habilita el sonido de cámara al hacer una captura de pantalla

## Editor section

# The heading
options-sourceeditor-label = Preferencias del editor

options-sourceeditor-detectindentation-tooltip =
    .title = Adivinar indentado basado en el contenido fuente
options-sourceeditor-detectindentation-label = Detectar indentado
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Automatically insert closing brackets
options-sourceeditor-autoclosebrackets-label = Autoclose brackets
options-sourceeditor-expandtab-tooltip =
    .title = Usar espacios en lugar del caracter tab
options-sourceeditor-expandtab-label = Indentar usando espacios
options-sourceeditor-tabsize-label = Tamaño de tabulación
options-sourceeditor-keybinding-label = Keybindings
options-sourceeditor-keybinding-default-label = Predeterminados

## Advanced section

# The heading
options-context-advanced-settings = Opciones avanzadas

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Deshabilitar cache HTTP (cuando las herramientas están abiertas)
options-disable-http-cache-tooltip =
    .title = Habilitar esta opción deshabilitará el caché HTTP para todas las pestañas que tengan las herramientas abiertas. Service Workers no están afectados por esta opción.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Deshabilitar JavaScript *
options-disable-javascript-tooltip =
    .title = Activar esta opción deshabilitará JavaScript para la pestaña actual. Si la pestaña o la caja de herramientas se cierran, esta opción será olvidada.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Habilitar cajas de herramientas de depuración de chrome y complementos
options-enable-chrome-tooltip =
    .title = Encender esta opción permitirá usar varias herramientas de depuración en el contexto del navegador (via Herramientas > Desarrollador web > Barra de herramientas del navegador) y depurar complementos desde el administrador de complementos

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Habilitar depuración remota

options-enable-remote-tooltip2 =
    .title = Activar esta opción permitirá depurar esta instancia del navegador de forma remota

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Habilitar Service Workers sobre HTTP (cuando esté abierta la caja de herramientas)
options-enable-service-workers-http-tooltip =
    .title = Habilitar esta opción habilitará service workers sobre HTTP para todas las pestañas que tengan la caja de herramientas abierta.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Habilitar mapas de fuentes
options-source-maps-tooltip =
    .title = Si habilita esta opción, las fuentes serán mapeadas en las herramientas.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Solo sesión actual, recarga la página

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Mostrar datos de plataforma de Gecko
options-show-platform-data-tooltip =
    .title =
        Si habilita esta opción, los informes del perfilador de JavaScript Profiler incluirá
        símbolos de plataforma de Gecko
