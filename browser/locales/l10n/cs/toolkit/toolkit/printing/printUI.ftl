# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Tisk
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Uložit jako
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } list papíru
        [few] { $sheetCount } listy papíru
       *[other] { $sheetCount } listů papíru
    }
printui-page-range-all = Vše
printui-page-range-custom = Vlastní
printui-page-range-label = Stránky
printui-page-range-picker =
    .aria-label = Vyberte rozsah stránek
printui-page-custom-range =
    .aria-label = Zadejte vlastní rozsah stránek
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = Od
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = do
# Section title for the number of copies to print
printui-copies-label = Počet kopií
printui-orientation = Orientace
printui-landscape = Na šířku
printui-portrait = Na výšku
# Section title for the printer or destination device to target
printui-destination-label = Zařízení pro tisk
printui-destination-pdf-label = Uložit jako PDF
printui-more-settings = Další nastavení
printui-less-settings = Skrýt další nastavení
printui-paper-size-label = Velikost papíru
# Section title (noun) for the print scaling options
printui-scale = Měřítko
printui-scale-fit-to-page = Přizpůsobit na stránku
printui-scale-fit-to-page-width = Přizpůsobit šířce stránky
# Label for input control where user can set the scale percentage
printui-scale-pcent = Měřítko
# Section title for miscellaneous print options
printui-options = Možnosti
printui-headers-footers-checkbox = Vytisknout záhlaví a zápatí
printui-backgrounds-checkbox = Vytisknout pozadí
printui-color-mode-label = Barevný režim
printui-color-mode-color = Barevně
printui-color-mode-bw = Černobíle
printui-margins = Okraje
printui-margins-default = Výchozí
printui-margins-min = Minimální
printui-margins-none = Žádné
printui-system-dialog-link = Vytisknout pomocí systémového dialogu…
printui-primary-button = Tisk
printui-primary-button-save = Uložit
printui-cancel-button = Zrušit
printui-loading = Příprava náhledu
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Náhled tisku

## Paper sizes that may be supported by the Save to PDF destination:

printui-paper-a5 = A5
printui-paper-a4 = A4
printui-paper-a3 = A3
printui-paper-a2 = A2
printui-paper-a1 = A1
printui-paper-a0 = A0
printui-paper-b5 = B5
printui-paper-b4 = B4
printui-paper-jis-b5 = JIS B5
printui-paper-jis-b4 = JIS B4
printui-paper-letter = US Letter
printui-paper-legal = US Legal
printui-paper-tabloid = Tabloid

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = Měřítko musí být číslo mezi 10 a 200.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Rozsah stránek musí být číslo mezi 1 a { $numPages }.
printui-error-invalid-start-overflow = Číslo stránky „od“ musí být menší než číslo stránky „do“.
