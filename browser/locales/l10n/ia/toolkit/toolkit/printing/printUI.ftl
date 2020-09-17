# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Imprimer
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Salvar como
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } folio de papiro
       *[other] { $sheetCount } folios de papiro
    }
printui-page-range-all = Toto
printui-page-range-custom = Personalisate
printui-page-range-label = Paginas
printui-page-range-picker =
    .aria-label = Selige un intervallo de paginas
printui-page-custom-range =
    .aria-label = Insere un intervallo de paginas personalisate
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = De
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = a
# Section title for the number of copies to print
printui-copies-label = Copias
printui-orientation = Orientation:
printui-landscape = Horizontal
printui-portrait = Vertical
# Section title for the printer or destination device to target
printui-destination-label = Destination
printui-destination-pdf-label = Salvar a PDF
printui-more-settings = Altere parametros
printui-less-settings = Minus parametros
printui-paper-size-label = Dimension del papiro
# Section title (noun) for the print scaling options
printui-scale = Scala
printui-scale-fit-to-page = Adaptar al pagina
printui-scale-fit-to-page-width = Adaptar al largor del pagina
# Label for input control where user can set the scale percentage
printui-scale-pcent = Scala
# Section title for miscellaneous print options
printui-options = Optiones
printui-headers-footers-checkbox = Imprimer capites e pedes de pagina
printui-backgrounds-checkbox = Imprimer le fundos
printui-color-mode-label = Modo color
printui-color-mode-color = Color
printui-color-mode-bw = Nigre e blanc
printui-margins = Margines
printui-margins-default = Predefinite
printui-margins-min = Minimo
printui-margins-none = Necun
printui-system-dialog-link = Stampa per le fenestra de dialogo del systema…
printui-primary-button = Imprimer
printui-primary-button-save = Salvar
printui-cancel-button = Cancellar
printui-loading = Preparation del vista preliminar
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Vista preliminar del impression

## Paper sizes that may be supported by the Save to PDF destination:

printui-paper-a5 = A5
printui-paper-a4 = A4
printui-paper-a3 = A3
printui-paper-a2 = A2
printui-paper-a1 = A1
printui-paper-a0 = A0
printui-paper-b5 = B5
printui-paper-b4 = B4
printui-paper-jis-b5 = JIS-B5
printui-paper-jis-b4 = JIS-B4
printui-paper-letter = Littera SUA
printui-paper-legal = Legal SUA
printui-paper-tabloid = Tabloid

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = Le scala debe esser un numero inter 10 e 200.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Le intervallo debe esser un numero inter 1 e { $numPages }.
printui-error-invalid-start-overflow = Le numero del pagina  “de” debe esser inferior a illo del pagina “a”.
