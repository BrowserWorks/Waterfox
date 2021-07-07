# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printpreview-simplify-page-checkbox =
    .label = Simplificar página
    .accesskey = i
    .tooltiptext = Esta página não pode ser simplificada automaticamente
printpreview-simplify-page-checkbox-enabled =
    .label = { printpreview-simplify-page-checkbox.label }
    .accesskey = { printpreview-simplify-page-checkbox.accesskey }
    .tooltiptext = Alterar esquema para uma leitura mais fácil
printpreview-close =
    .label = Fechar
    .accesskey = F
printpreview-portrait =
    .label = Vertical
    .accesskey = V
printpreview-landscape =
    .label = Horizontal
    .accesskey = H
printpreview-scale =
    .value = Escala:
    .accesskey = E
printpreview-shrink-to-fit =
    .label = Redimensionar para caber
printpreview-custom =
    .label = Personalizar…
printpreview-print =
    .label = Imprimir…
    .accesskey = I
printpreview-of =
    .value = de
printpreview-custom-scale-prompt-title = Escala personalizada
printpreview-page-setup =
    .label = Configurar página…
    .accesskey = C
printpreview-page =
    .value = Página:
    .accesskey = P

# Variables
# $sheetNum (integer) - The current sheet number
# $sheetCount (integer) - The total number of sheets to print
printpreview-sheet-of-sheets = { $sheetNum } de { $sheetCount }

## Variables
## $percent (integer) - menuitem percent label
## $arrow (String) - UTF-8 arrow character for navigation buttons

printpreview-percentage-value =
    .label = { $percent }%
printpreview-homearrow =
    .label = { $arrow }
    .tooltiptext = Primeira página
printpreview-previousarrow =
    .label = { $arrow }
    .tooltiptext = Página anterior
printpreview-nextarrow =
    .label = { $arrow }
    .tooltiptext = Página seguinte
printpreview-endarrow =
    .label = { $arrow }
    .tooltiptext = Última página

printpreview-homearrow-button =
    .title = Primeira página
printpreview-previousarrow-button =
    .title = Página anterior
printpreview-nextarrow-button =
    .title = Página seguinte
printpreview-endarrow-button =
    .title = Última página
