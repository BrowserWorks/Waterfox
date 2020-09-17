# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Imprentar
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Alzar como
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } fuella de papel
       *[other] { $sheetCount } fuellas de papel
    }
printui-page-range-all = Totas
printui-page-range-custom = Personalizau
printui-page-range-label = Pachinas
printui-page-range-picker =
    .aria-label = Tría un intervalo de pachinas
printui-page-custom-range =
    .aria-label = Tría un intervalo personalizau de pachinas
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = Dende
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = ta
# Section title for the number of copies to print
printui-copies-label = Copias
printui-orientation = Orientación
printui-landscape = Horizontal
printui-portrait = Vertical
# Section title for the printer or destination device to target
printui-destination-label = Destín
printui-destination-pdf-label = Alzar como PDF
printui-more-settings = Mas preferencias
printui-less-settings = Menos preferencias
printui-paper-size-label = Tamanyo d'o papel
# Section title (noun) for the print scaling options
printui-scale = Escala
printui-scale-fit-to-page = Achustar a la pachina
printui-scale-fit-to-page-width = Achusta a l'amplaria d'a pachina
# Label for input control where user can set the scale percentage
printui-scale-pcent = Escala
# Section title for miscellaneous print options
printui-options = Opcions
printui-headers-footers-checkbox = Imprentar los capiters y los pietz de pachina
printui-backgrounds-checkbox = Imprentar los fondos
printui-color-mode-label = Modo de color
printui-color-mode-color = Color
printui-color-mode-bw = Blanco y negro
printui-margins = Marguins
printui-margins-default = Predeterminau
printui-margins-min = Minimo
printui-margins-none = Garra
printui-system-dialog-link = Imprentar usando lo dialogo d'o sistema
printui-primary-button = Imprentar
printui-primary-button-save = Alzar
printui-cancel-button = Cancelar
printui-loading = Preparando la previsualización
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Vista previa d'impresión

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
printui-paper-letter = Carta americana
printui-paper-legal = US Legal
printui-paper-tabloid = Tabloide

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = La escala puede estar un numero entre 10 y 200.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = L'intervalo puede estar un numero entre 1 y { $numPages }.
printui-error-invalid-start-overflow = El numero de pachina "dende" ha d'estar mas chicot que no llo numeroa d'a pachina "ta".
