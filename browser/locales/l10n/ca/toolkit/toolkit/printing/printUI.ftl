# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Imprimeix
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Anomena i desa
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } full de paper
       *[other] { $sheetCount } fulls de paper
    }
printui-page-range-all = Tot
printui-page-range-custom = Personalitzat
printui-page-range-label = Pàgines
printui-page-range-picker =
    .aria-label = Trieu l'interval de pàgines
printui-page-custom-range =
    .aria-label = Introduïu un interval de pàgines personalitzat
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = De
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = a
# Section title for the number of copies to print
printui-copies-label = Còpies
printui-orientation = Orientació
printui-landscape = Apaïsat
printui-portrait = Vertical
# Section title for the printer or destination device to target
printui-destination-label = Destinació
printui-destination-pdf-label = Desa com a PDF
printui-more-settings = Més paràmetres
printui-less-settings = Menys paràmetres
# Section title (noun) for the print scaling options
printui-scale = Escala
printui-scale-fit-to-page = Ajusta a la pàgina
printui-scale-fit-to-page-width = Ajusta a l'amplada de la pàgina
# Label for input control where user can set the scale percentage
printui-scale-pcent = Escala
# Section title for miscellaneous print options
printui-options = Opcions
printui-headers-footers-checkbox = Imprimeix capçaleres i peus de pàgina
printui-backgrounds-checkbox = Imprimeix els fons
printui-color-mode-label = Mode de color
printui-color-mode-color = Color
printui-color-mode-bw = Blanc i negre
printui-margins = Marges
printui-margins-default = Per defecte
printui-margins-min = Mínims
printui-margins-none = Cap
printui-system-dialog-link = Imprimeix mitjançant el diàleg del sistema…
printui-primary-button = Imprimeix
printui-primary-button-save = Desa
printui-cancel-button = Cancel·la
printui-loading = S'està preparant la previsualització

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = L'escala ha de ser un nombre entre 10 i 200.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = L'interval ha de ser un nombre entre 1 i { $numPages }.
