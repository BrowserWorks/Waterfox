# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

styleeditor-new-button =
    .tooltiptext = Crear y adjuntar una nueva hoja de estilos al documento
    .accesskey = N
styleeditor-import-button =
    .tooltiptext = Importar y adjuntar una hoja de estilos existente al documento
    .accesskey = I
styleeditor-filter-input =
    .placeholder = Filtrar hojas de estilo
styleeditor-visibility-toggle =
    .tooltiptext = Cambiar la visibilidad de la hoja de estilos
    .accesskey = G
styleeditor-visibility-toggle-system =
    .tooltiptext = Las hojas de estilo del sistema no se pueden deshabilitar
styleeditor-save-button = Guardar
    .tooltiptext = Guardar esta hoja de estilos a un fichero
    .accesskey = G
styleeditor-options-button =
    .tooltiptext = Opciones del editor de estilos
styleeditor-at-rules = At-rules
styleeditor-editor-textbox =
    .data-placeholder = Escribe CSS aquí.
styleeditor-no-stylesheet = Esta página no tiene hoja de estilos.
styleeditor-no-stylesheet-tip = ¿Quizás te gustaría <a data-l10n-name="append-new-stylesheet">adjuntar una nueva hoja de estilos</a>?
styleeditor-open-link-new-tab =
    .label = Abrir enlace en una nueva pestaña
styleeditor-copy-url =
    .label = Copiar URL
styleeditor-find =
    .label = Buscar
    .accesskey = B
styleeditor-find-again =
    .label = Repetir la búsqueda
    .accesskey = R
styleeditor-go-to-line =
    .label = Saltar a la línea…
    .accesskey = l
# Label displayed when searching a term that is not found in any stylesheet path
styleeditor-stylesheet-all-filtered = No se encontró ninguna hoja de estilo.

# This string is shown in the style sheets list
# Variables:
#   $ruleCount (Integer) - The number of rules in the stylesheet.
styleeditor-stylesheet-rule-count =
    { $ruleCount ->
        [one] { $ruleCount } regla
       *[other] { $ruleCount } reglas.
    }
