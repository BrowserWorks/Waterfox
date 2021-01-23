# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Shtype
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Ruajeni Si
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } fletë letre
       *[other] { $sheetCount } fletë letre
    }
printui-page-range-all = Krejt
printui-page-range-custom = Vetjake
printui-page-range-label = Faqe
printui-page-range-picker =
    .aria-label = Zgjidhni interval faqesh
printui-page-custom-range =
    .aria-label = Jepni interval vetjak faqesh
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = Nga
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = në
# Section title for the number of copies to print
printui-copies-label = Kopje
printui-orientation = Orientim
printui-landscape = Së gjeri
printui-portrait = Portret
# Section title for the printer or destination device to target
printui-destination-label = Vendmbërritje
printui-destination-pdf-label = Ruaje si PDF
printui-more-settings = Më tepër rregullime
printui-less-settings = Më pak rregullime
printui-paper-size-label = Madhësi letre
# Section title (noun) for the print scaling options
printui-scale = Shkallë
printui-scale-fit-to-page = Sa ta nxërë faqja
printui-scale-fit-to-page-width = Sa e nxë gjerësia e faqes
# Label for input control where user can set the scale percentage
printui-scale-pcent = Shkallë
# Section title for miscellaneous print options
printui-options = Mundësi
printui-headers-footers-checkbox = Shtyp kryefaqe dhe fundfaqe
printui-backgrounds-checkbox = Shtyp sfonde
printui-color-mode-label = Mënyrë ngjyrash
printui-color-mode-color = Ngjyrë
printui-color-mode-bw = Bardhezi
printui-margins = Mënjana
printui-margins-default = Parazgjedhje
printui-margins-min = Minimum
printui-margins-none = Asnjë
printui-system-dialog-link = Shtyp duke përdorur dialogun e sistemit…
printui-primary-button = Shtype
printui-primary-button-save = Ruaje
printui-cancel-button = Anuloje
printui-loading = Po Përgatitet Paraparje
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Paraparje e Shtypjes

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

printui-error-invalid-scale = Shkalla duhet të jetë një numër mes 10-ës dhe 200-ës.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Intervali duhet të jetë një numër mes 1-shit dhe { $numPages }.
printui-error-invalid-start-overflow = Numri i faqes “nga” duhet të jetë më i vogël se numri i faqes “deri në”.
