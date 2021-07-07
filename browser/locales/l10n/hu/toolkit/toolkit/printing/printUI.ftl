# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Nyomtatás
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Mentés másként
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } lap
       *[other] { $sheetCount } lap
    }
printui-page-range-all = Mind
printui-page-range-custom = Egyéni
printui-page-range-label = Oldalak
printui-page-range-picker =
    .aria-label = Válassza ki az oldaltartományt
printui-page-custom-range-input =
    .aria-label = Egyéni oldaltartomány megadása
    .placeholder = például 2-6, 9, 12-16
# Section title for the number of copies to print
printui-copies-label = Példányszám
printui-orientation = Tájolás
printui-landscape = Fekvő
printui-portrait = Álló
# Section title for the printer or destination device to target
printui-destination-label = Cél
printui-destination-pdf-label = Mentés PDF-be
printui-more-settings = Több beállítás
printui-less-settings = Kevesebb beállítás
printui-paper-size-label = Papírméret
# Section title (noun) for the print scaling options
printui-scale = Méret
printui-scale-fit-to-page-width = Oldalszélesség
# Label for input control where user can set the scale percentage
printui-scale-pcent = Méret
# Section title (noun) for the two-sided print options
printui-two-sided-printing = Kétoldalas nyomtatás
printui-two-sided-printing-off = Ki
# Flip the sheet as if it were bound along its long edge.
printui-two-sided-printing-long-edge = Átfordítás a lap hosszabb szélén
# Flip the sheet as if it were bound along its short edge.
printui-two-sided-printing-short-edge = Átfordítás a lap rövidebb szélén
# Section title for miscellaneous print options
printui-options = Beállítások
printui-headers-footers-checkbox = Fejlécek és láblécek nyomtatása
printui-backgrounds-checkbox = Hátterek nyomtatása
printui-selection-checkbox = Csak a kijelölés nyomtatása
printui-color-mode-label = Színmód
printui-color-mode-color = Színes
printui-color-mode-bw = Fekete-fehér
printui-margins = Margók
printui-margins-default = Alapértelmezett
printui-margins-min = Minimális
printui-margins-none = Egyik sem
printui-margins-custom-inches = Egyéni (hüvelyk)
printui-margins-custom-mm = Egyéni (mm)
printui-margins-custom-top = Felső
printui-margins-custom-top-inches = Felső (hüvelyk)
printui-margins-custom-top-mm = Felül (mm)
printui-margins-custom-bottom = Alsó
printui-margins-custom-bottom-inches = Alsó (hüvelyk)
printui-margins-custom-bottom-mm = Alul (mm)
printui-margins-custom-left = Bal
printui-margins-custom-left-inches = Bal (hüvelyk)
printui-margins-custom-left-mm = Balra (mm)
printui-margins-custom-right = Jobb
printui-margins-custom-right-inches = Jobb (hüvelyk)
printui-margins-custom-right-mm = Jobbra (mm)
printui-system-dialog-link = Nyomtatás a rendszer párbeszédablakával…
printui-primary-button = Nyomtatás
printui-primary-button-save = Mentés
printui-cancel-button = Mégse
printui-close-button = Bezárás
printui-loading = Előnézet előkészítése
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Nyomtatási kép
printui-pages-per-sheet = Oldalak száma laponként
# This is shown next to the Print button with an indefinite loading spinner
# when the user prints a page and it is being sent to the printer.
printui-print-progress-indicator = Nyomtatás…
printui-print-progress-indicator-saving = Mentés…

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

printui-error-invalid-scale = A skálának 10 és 200 közötti számnak kell lennie.
printui-error-invalid-margin = Adjon meg érvényes margót a kiválasztott papírmérethez.
printui-error-invalid-copies = A másolatok számának 1 és 10000 közötti számnak kell lennie.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = A tartománynak 1 és { $numPages } közötti számnak kell lennie.
printui-error-invalid-start-overflow = Az „ettől” oldalszámnak kisebbnek kell lennie, mint az „eddig” oldalszám.
