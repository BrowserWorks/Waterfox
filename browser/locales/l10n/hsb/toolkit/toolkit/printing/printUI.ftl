# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Ćišćeć
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Składować jako
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } łopjeno papjery
        [two] { $sheetCount } łopjenje papjery
        [few] { $sheetCount } łopjena papjery
       *[other] { $sheetCount } łopjenow papjery
    }
printui-page-range-all = Wšě
printui-page-range-custom = Swójski
printui-page-range-label = Strony
printui-page-range-picker =
    .aria-label = Wobwod stronow wubrać
printui-page-custom-range =
    .aria-label = Swójski wobwod stronow zapodać
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = Wot
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = do
# Section title for the number of copies to print
printui-copies-label = Kopije
printui-orientation = Wusměrjenje
printui-landscape = Šěroki format
printui-portrait = Wysoki format
# Section title for the printer or destination device to target
printui-destination-label = Cil
printui-destination-pdf-label = Jako PDF składować
printui-more-settings = Wjace nastajenjow
printui-less-settings = Mjenje nastajenjow
printui-paper-size-label = Wulkosć papjery
# Section title (noun) for the print scaling options
printui-scale = Skalowanje
printui-scale-fit-to-page = Stronje přiměrić
printui-scale-fit-to-page-width = Šěrokosći strony přiměrić
# Label for input control where user can set the scale percentage
printui-scale-pcent = Skalować
# Section title for miscellaneous print options
printui-options = Nastajenja
printui-headers-footers-checkbox = Hłowy a nohi ćišćeć
printui-backgrounds-checkbox = Pozadki ćišćeć
printui-color-mode-label = Barbny modus
printui-color-mode-color = Barba
printui-color-mode-bw = Čorny a běły
printui-margins = Kromy
printui-margins-default = Standard
printui-margins-min = Minimum
printui-margins-none = Žana
printui-system-dialog-link = Z pomocu systemoweho dialoga ćišćeć…
printui-primary-button = Ćišćeć
printui-primary-button-save = Składować
printui-cancel-button = Přetorhnyć
printui-loading = Ćišćerski přehlad přihotować
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Ćišćerski přehlad

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

printui-error-invalid-scale = Skalowanje dyrbi ličba mjez 10 a 200 być.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Wobłuk dyrbi ličba mjez 1 a { $numPages } być.
printui-error-invalid-start-overflow = Ličba strony „wot“ dyrbi mjeńša hač ličba strony „do“ być.
