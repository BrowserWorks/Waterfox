# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Elemento seleccionado
compatibility-all-elements-header = Todos los problemas

## Message used as labels for the type of issue

compatibility-issue-deprecated = (obsoleto)
compatibility-issue-experimental = (experimental)
compatibility-issue-prefixneeded = (se necesita prefijo)
compatibility-issue-deprecated-experimental = (obsoleto, experimental)
compatibility-issue-deprecated-prefixneeded = (obsoleto, se necesita prefijo)
compatibility-issue-experimental-prefixneeded = (experimental, se necesita prefijo)
compatibility-issue-deprecated-experimental-prefixneeded = (obsoleto, experimental, se necesita prefijo)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Ajustes
compatibility-settings-button-title =
    .title = Ajustes
compatibility-feedback-button-label = Comentarios
compatibility-feedback-button-title =
    .title = Comentarios

## Messages used as headers in settings pane

compatibility-settings-header = Ajustes
compatibility-target-browsers-header = Navegadores de destino

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } ocurrencia
       *[other] { $number } ocurrencias
    }
compatibility-no-issues-found = No se encontraron problemas de compatibilidad.
compatibility-close-settings-button =
    .title = Cerrar ajustes
