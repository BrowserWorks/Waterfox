# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Tiskanje
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Shrani kot
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } list papirja
        [two] { $sheetCount } lista papirja
        [few] { $sheetCount } listi papirja
       *[other] { $sheetCount } listov papirja
    }
printui-page-range-all = Vse
printui-page-range-custom = Po meri
printui-page-range-label = Strani
printui-page-range-picker =
    .aria-label = Izberite obseg strani
printui-page-custom-range =
    .aria-label = Vnesite obseg strani po meri
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = Od
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = do
# Section title for the number of copies to print
printui-copies-label = Kopije
printui-orientation = Usmerjenost
printui-landscape = Ležeče
printui-portrait = Pokončno
# Section title for the printer or destination device to target
printui-destination-label = Cilj
printui-destination-pdf-label = Shrani v PDF
printui-more-settings = Več nastavitev
printui-less-settings = Manj nastavitev
printui-paper-size-label = Velikost papirja
# Section title (noun) for the print scaling options
printui-scale = Merilo
printui-scale-fit-to-page = Prilagodi strani
printui-scale-fit-to-page-width = Prilagodi širini strani
# Label for input control where user can set the scale percentage
printui-scale-pcent = Merilo
# Section title for miscellaneous print options
printui-options = Možnosti
printui-headers-footers-checkbox = Natisni glave in noge
printui-backgrounds-checkbox = Natisni ozadja
printui-color-mode-label = Barvni način
printui-color-mode-color = Barva
printui-color-mode-bw = Črno-belo
printui-margins = Robovi
printui-margins-default = Privzeto
printui-margins-min = Najmanj
printui-margins-none = Brez
printui-system-dialog-link = Natisni s pomočjo pogovornega okna sistema …
printui-primary-button = Natisni
printui-primary-button-save = Shrani
printui-cancel-button = Prekliči
printui-loading = Priprava predogleda
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Predogled tiskanja

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
printui-paper-letter = Letter
printui-paper-legal = Legal
printui-paper-tabloid = Tabloid

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = Merilo mora biti število med 10 in 200.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Obseg mora biti število med 1 in { $numPages }.
printui-error-invalid-start-overflow = Številka strani "od" mora biti manjša od številke strani "do".
