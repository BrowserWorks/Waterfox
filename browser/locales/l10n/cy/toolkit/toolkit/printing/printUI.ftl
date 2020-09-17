# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Argraffu
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Cadw Fel
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [zero] { $sheetCount } dalen o bapur
        [one] { $sheetCount } dalen o bapur
        [two] { $sheetCount } ddalen o bapur
        [few] { $sheetCount } dalen o bapur
        [many] { $sheetCount } dalen o bapur
       *[other] { $sheetCount } dalen o bapur
    }
printui-page-range-all = Y Cyfan
printui-page-range-custom = Cyfaddas
printui-page-range-label = Tudalen
printui-page-range-picker =
    .aria-label = Dewis yr ystod tudalen
printui-page-custom-range =
    .aria-label = Rhowch ystod tudalen cyfaddas
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = O
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = at
# Section title for the number of copies to print
printui-copies-label = Copïau
printui-orientation = Cyfeiriad
printui-landscape = Tirlun
printui-portrait = Portread
# Section title for the printer or destination device to target
printui-destination-label = Cyrchfan
printui-destination-pdf-label = Cadw i PDF
printui-more-settings = Rhagor o osodiadau
printui-less-settings = Llai o osodiadau
printui-paper-size-label = Maint papur
# Section title (noun) for the print scaling options
printui-scale = Graddfa
printui-scale-fit-to-page = Yn ffitio'r dudalen
printui-scale-fit-to-page-width = Yn ffitio i led y dudalen
# Label for input control where user can set the scale percentage
printui-scale-pcent = Graddfa
# Section title for miscellaneous print options
printui-options = Dewisiadau
printui-headers-footers-checkbox = Argraffu penynnau a throedynnau
printui-backgrounds-checkbox = Argraffu cefndiroedd
printui-color-mode-label = Modd lliw
printui-color-mode-color = Lliw
printui-color-mode-bw = Du a gwyn
printui-margins = Ymylon
printui-margins-default = Rhagosodiad
printui-margins-min = Lleiafswm
printui-margins-none = Dim
printui-system-dialog-link = Argraffu gan ddefnyddio deialog y system ...
printui-primary-button = Argraffu
printui-primary-button-save = Cadw
printui-cancel-button = Diddymu
printui-loading = Paratoi Rhagolwg
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Rhagolwg Argraffu

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
printui-paper-letter = US Letter
printui-paper-legal = US Legal
printui-paper-tabloid = Tabloid

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = Rhaid i'r raddfa fod yn rhif rhwng 10 a 200.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Rhaid i'r raddfa fod yn rhif rhwng 10 a { $numPages }.
printui-error-invalid-start-overflow = Rhaid i rif y dudalen “o” fod yn llai na rhif y dudalen “i”.
