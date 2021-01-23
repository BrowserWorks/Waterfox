# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Ofdrukke
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Bewarje as
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } side
       *[other] { $sheetCount } siden
    }
printui-page-range-all = Alle
printui-page-range-custom = Oanpast
printui-page-range-label = Siden
printui-page-range-picker =
    .aria-label = Sideberik kieze
printui-page-custom-range =
    .aria-label = Oanpast sideberik ynfiere
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = Fan
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = oant
# Section title for the number of copies to print
printui-copies-label = Kopyen
printui-orientation = Oriïntaasje
printui-landscape = Lizzend
printui-portrait = Steand
# Section title for the printer or destination device to target
printui-destination-label = Bestimming
printui-destination-pdf-label = Bewarje as PDF
printui-more-settings = Mear ynstellingen
printui-less-settings = Minder ynstellingen
printui-paper-size-label = Papierôfmjitting
# Section title (noun) for the print scaling options
printui-scale = Skaal
printui-scale-fit-to-page = Ferlytsje oant papierformaat
printui-scale-fit-to-page-width = Oan sidebreedte oanpasse
# Label for input control where user can set the scale percentage
printui-scale-pcent = Skaal
# Section title for miscellaneous print options
printui-options = Opsjes
printui-headers-footers-checkbox = Kop- en foetteksten ôfdrukke
printui-backgrounds-checkbox = Eftergrûnen ôfdrukke
printui-color-mode-label = Kleurmodus
printui-color-mode-color = Kleur
printui-color-mode-bw = Swart-wyt
printui-margins = Marzjes
printui-margins-default = Standert
printui-margins-min = Minimum
printui-margins-none = Gjin
printui-system-dialog-link = Ofdrukke fia it systeemdialoochfienster…
printui-primary-button = Ofdrukke
printui-primary-button-save = Bewarje
printui-cancel-button = Annulearje
printui-loading = Foarbyld tariede
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Ofdrukfoarbyld

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
printui-paper-jis-b4 = JIS-B5
printui-paper-letter = Letter
printui-paper-legal = Legal
printui-paper-tabloid = Tabloid

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = De skaal moat in getal tusken 10 en 200 wêze.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = It berik moat in getal tusken 1 en { $numPages } wêze.
printui-error-invalid-start-overflow = It ‘fanôf’-sidenûmer moat lytser wêze as it ‘oant’-sidenûmer.
