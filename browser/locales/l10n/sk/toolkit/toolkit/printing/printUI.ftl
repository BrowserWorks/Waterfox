# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Tlačiť
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Uložiť ako
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } list papiera
        [few] { $sheetCount } listy papiera
       *[other] { $sheetCount } listov papiera
    }
printui-page-range-all = Všetky
printui-page-range-custom = Vlastné
printui-page-range-label = Strany
printui-page-range-picker =
    .aria-label = Vyberte rozsah strán
printui-page-custom-range =
    .aria-label = Zadajte vlastný rozsah strán
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = Od
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = do
# Section title for the number of copies to print
printui-copies-label = Kópie
printui-orientation = Orientácia
printui-landscape = Na šírku
printui-portrait = Na výšku
printui-destination-pdf-label = Uložiť ako PDF
printui-more-settings = Ďalšie nastavenia
printui-less-settings = Menej nastavení
printui-paper-size-label = Veľkosť papiera
# Label for input control where user can set the scale percentage
printui-scale-pcent = Mierka
# Section title for miscellaneous print options
printui-options = Možnosti
printui-headers-footers-checkbox = Vytlačiť hlavičku a pätu
printui-backgrounds-checkbox = Vytlačiť pozadie
printui-color-mode-label = Nastavenia farby
printui-color-mode-color = Farebne
printui-color-mode-bw = Čiernobielo
printui-margins = Okraje
printui-margins-default = Predvolené
printui-margins-min = Minimálne
printui-margins-none = Žiadne
printui-system-dialog-link = Vytlačiť pomocou systémového dialógu…
printui-primary-button = Tlačiť
printui-primary-button-save = Uložiť
printui-cancel-button = Zrušiť
printui-loading = Pripravuje sa ukážka pred tlačou

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

## Error messages shown when a user has an invalid input

