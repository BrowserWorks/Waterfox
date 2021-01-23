# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Śišćaś
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Składowaś ako
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } łopjeno papjery
        [two] { $sheetCount } łopjenje papjery
        [few] { $sheetCount } łopjena papjery
       *[other] { $sheetCount } łopjenow papjery
    }
printui-page-range-all = Wšykne
printui-page-range-custom = Swójski
printui-page-range-label = Boki
printui-page-range-picker =
    .aria-label = Wobceŕk bokow wubraś
printui-page-custom-range =
    .aria-label = Swójski wobceŕk bokow zapódaś
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = Wót
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = do
# Section title for the number of copies to print
printui-copies-label = Kopije
printui-orientation = Wusměrjenje
printui-landscape = Prěcny format
printui-portrait = Wusoki format
# Section title for the printer or destination device to target
printui-destination-label = Cel
printui-destination-pdf-label = Ako PDF składowaś
printui-more-settings = Wěcej nastajenjow
printui-less-settings = Mjenjej nastajenjow
printui-paper-size-label = Wjelikosć papjery
# Section title (noun) for the print scaling options
printui-scale = Skalěrowanje
printui-scale-fit-to-page = Bokoju pśiměriś
printui-scale-fit-to-page-width = Šyrokosći boka pśiměriś
# Label for input control where user can set the scale percentage
printui-scale-pcent = Skalěrowaś
# Section title for miscellaneous print options
printui-options = Nastajenja
printui-headers-footers-checkbox = Głowy a nogi śišćaś
printui-backgrounds-checkbox = Slězyny śišćaś
printui-color-mode-label = Barwowy modus
printui-color-mode-color = Barwa
printui-color-mode-bw = Carny a běły
printui-margins = Kšomy
printui-margins-default = Standard
printui-margins-min = Minimum
printui-margins-none = Žedna
printui-system-dialog-link = Z pomocu systemowego dialoga śišćaś…
printui-primary-button = Śišćaś
printui-primary-button-save = Składowaś
printui-cancel-button = Pśetergnuś
printui-loading = Śišćarski pśeglěd pśigótowaś
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Śišćarski pśeglěd

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

printui-error-invalid-scale = Skalěrowanje musy licba mjazy 10 a 200 byś.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Wobceŕk musy licba mjazy 1 a { $numPages } byś.
printui-error-invalid-start-overflow = Licba boka „wót“ musy mjeńša ako licba boka „do“ byś.
