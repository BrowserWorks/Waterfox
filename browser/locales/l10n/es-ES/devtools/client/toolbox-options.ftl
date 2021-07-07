# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Herramientas de desarrollo predeterminadas
# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * No compatible con el elemento actual de la caja de herramientas
# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Herr. desarr. instaladas por complementos
# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Botones en la caja de herramientas
# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Temas

## Inspector section

# The heading
options-context-inspector = Inspector
# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Mostrar estilos del navegador
options-show-user-agent-styles-tooltip =
    .title = Activar esto mostrará los estilos predeterminados que se cargan por el navegador.
# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Truncar atributos DOM
options-collapse-attrs-tooltip =
    .title = Truncar atributos largos en el inspector

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Unidad de color predeterminada
options-default-color-unit-authored = como indicó el autor
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
    .title = Autocompletar propiedades, valores y selectores CSS en el editor de estilos a medida que escribe

## Screenshot section

# The heading
options-screenshot-label = Comportamiento de pantalla
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Captura de pantalla al portapapeles
options-screenshot-clipboard-tooltip =
    .title = Guardar la captura de pantalla directamente en el portapapeles
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-only-label = Captura de pantalla solo al portapapeles
options-screenshot-clipboard-tooltip2 =
    .title = Guarda la captura de pantalla directamente en el portapapeles
# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Reproducir sonido del obturador de la cámara
options-screenshot-audio-tooltip =
    .title = Activa el sonido de la cámara al tomar una captura

## Editor section

# The heading
options-sourceeditor-label = Preferencias del editor
options-sourceeditor-detectindentation-tooltip =
    .title = Deducir sangrado basándose en el contenido del código fuente
options-sourceeditor-detectindentation-label = Detectar sangrado
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Insertar llaves de cerrado automáticamente
options-sourceeditor-autoclosebrackets-label = Cerrar llaves automáticamente
options-sourceeditor-expandtab-tooltip =
    .title = Usar espacios en lugar del carácter de tabulación
options-sourceeditor-expandtab-label = Sangrar usando espacios
options-sourceeditor-tabsize-label = Tamaño de la pestaña
options-sourceeditor-keybinding-label = Combinaciones de teclas
options-sourceeditor-keybinding-default-label = Predeterminado

## Advanced section

# The heading (this item is also used in perftools.ftl)
options-context-advanced-settings = Ajustes avanzados
# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Desactivar caché HTTP (cuando la caja de herramientas está abierta)
options-disable-http-cache-tooltip =
    .title = Activar esta opción desactivará el caché HTTP en todas las pestañas que tengan abierta la caja de herramientas. Los Service Workers no se ven afectados por esta opción.
# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Desactivar JavaScript *
options-disable-javascript-tooltip =
    .title = Activar esta opción desactivará JavaScript en la pestaña actual. Si la pestaña o la caja de herramientas se cierra entonces este ajuste será descartado.
# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Activar cajas herr. depur. chrome del navegador y de complementos
options-enable-chrome-tooltip =
    .title = Activar esta opción le permitirá usar varias herramientas de desarrollador en el contexto del navegador (a través de Herramientas > Desarrollador web > Caja de herramientas del navegador) y depurar complementos desde el administrador de complementos
# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Activar depuración remota
options-enable-remote-tooltip2 =
    .title = Activar esta opción permitirá depurar esta instancia del navegador de forma remota
# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Activar service workers bajo HTTP (si la caja de herramientas está abierta)
options-enable-service-workers-http-tooltip =
    .title = Activar esta opción permitirá funcionar a los service workers bajo HTTP en todas las pestañas que tengan abierta la caja de herramientas.
# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Activar mapas de código fuente
options-source-maps-tooltip =
    .title = Si activa esta opción, los códigos fuentes serán mapeados en las herramientas.
# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Sólo sesión actual, recarga la página
# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Mostrar datos de la plataforma Gecko
options-show-platform-data-tooltip =
    .title = Si activa esta opción los informes del analizador JavaScript incluirán los símbolos de la plataforma Gecko
