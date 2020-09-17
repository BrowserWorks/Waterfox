# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Tipărește
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Salvează ca
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } coală de hârtie
        [few] { $sheetCount } coli de hârtie
       *[other] { $sheetCount } de coli de hârtie
    }
printui-page-range-all = Tot
printui-page-range-custom = Personalizat
printui-page-range-label = Pagini
printui-page-range-picker =
    .aria-label = Alege intervalul de pagini
printui-page-custom-range =
    .aria-label = Introdu intervalul de pagini personalizat
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = De la
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = la
# Section title for the number of copies to print
printui-copies-label = Exemplare
printui-orientation = Orientare
printui-landscape = Orizontală
printui-portrait = Verticală
# Section title for the printer or destination device to target
printui-destination-label = Destinație
printui-destination-pdf-label = Salvează ca PDF
printui-more-settings = Mai multe setări
printui-less-settings = Mai puține setări
printui-paper-size-label = Mărime hârtie
# Section title (noun) for the print scaling options
printui-scale = Scară
printui-scale-fit-to-page = Încadrare în pagină
printui-scale-fit-to-page-width = Adaptează la lățimea paginii
# Label for input control where user can set the scale percentage
printui-scale-pcent = Scară
# Section title for miscellaneous print options
printui-options = Opțiuni
printui-headers-footers-checkbox = Tipărește antete și subsoluri
printui-backgrounds-checkbox = Tipărește fundaluri
printui-color-mode-label = Mod color
printui-color-mode-color = Culoare
printui-color-mode-bw = Alb-negru
printui-margins = Margini
printui-margins-default = Implicite
printui-margins-min = Minime
printui-margins-none = Niciuna
printui-system-dialog-link = Tipărește folosind fereastra de dialog a sistemului…
printui-primary-button = Tipărește
printui-primary-button-save = Salvează
printui-cancel-button = Renunță
printui-loading = Se pregătește previzualizarea

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = Scala trebuie să fie un număr între 10 și 200.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Intervalul trebuie să fie un număr între 1 și { $numPages }.
printui-error-invalid-start-overflow = Numărul paginii „de la” trebuie să fie mai mic decât numărul paginii „până la”.
