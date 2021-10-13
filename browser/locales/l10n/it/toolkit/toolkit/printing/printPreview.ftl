# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printpreview-simplify-page-checkbox =
    .label = Semplifica pagina
    .accesskey = e
    .tooltiptext = Non è possibile semplificare automaticamente questa pagina
printpreview-simplify-page-checkbox-enabled =
    .label = { printpreview-simplify-page-checkbox.label }
    .accesskey = { printpreview-simplify-page-checkbox.accesskey }
    .tooltiptext = Modifica il layout della pagina per semplificarne la lettura
printpreview-close =
    .label = Chiudi
    .accesskey = C
printpreview-portrait =
    .label = Verticale
    .accesskey = V
printpreview-landscape =
    .label = Orizzontale
    .accesskey = O
printpreview-scale =
    .value = Scala:
    .accesskey = a
printpreview-shrink-to-fit =
    .label = Adatta alla pagina
printpreview-custom =
    .label = Personalizza…
printpreview-print =
    .label = Stampa…
    .accesskey = S
printpreview-of =
    .value = di
printpreview-custom-scale-prompt-title = Scala personalizzata
printpreview-page-setup =
    .label = Imposta pagina…
    .accesskey = m
printpreview-page =
    .value = Pagina:
    .accesskey = P

# Variables
# $sheetNum (integer) - The current sheet number
# $sheetCount (integer) - The total number of sheets to print
printpreview-sheet-of-sheets = { $sheetNum } di { $sheetCount }

## Variables
## $percent (integer) - menuitem percent label
## $arrow (String) - UTF-8 arrow character for navigation buttons

printpreview-percentage-value =
    .label = { $percent }%
printpreview-homearrow =
    .label = { $arrow }
    .tooltiptext = Prima pagina
printpreview-previousarrow =
    .label = { $arrow }
    .tooltiptext = Pagina precedente
printpreview-nextarrow =
    .label = { $arrow }
    .tooltiptext = Pagina successiva
printpreview-endarrow =
    .label = { $arrow }
    .tooltiptext = Ultima pagina

printpreview-homearrow-button =
    .title = Prima pagina
printpreview-previousarrow-button =
    .title = Pagina precedente
printpreview-nextarrow-button =
    .title = Pagina successiva
printpreview-endarrow-button =
    .title = Ultima pagina
