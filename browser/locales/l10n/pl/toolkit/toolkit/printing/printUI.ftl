# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Drukowanie
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Zapisz jako
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } kartka papieru
        [few] { $sheetCount } kartki papieru
       *[many] { $sheetCount } kartek papieru
    }
printui-page-range-all = Wszystkie
printui-page-range-custom = Wybrane
printui-page-range-label = Strony
printui-page-range-picker =
    .aria-label = Wybierz zakres stron
printui-page-custom-range-input =
    .aria-label = Wprowadź inny zakres stron
    .placeholder = np. 2-6, 9, 12-16
# Section title for the number of copies to print
printui-copies-label = Kopie
printui-orientation = Orientacja
printui-landscape = Pozioma
printui-portrait = Pionowa
# Section title for the printer or destination device to target
printui-destination-label = Drukarka
printui-destination-pdf-label = Zapisz jako PDF
printui-more-settings = Więcej ustawień
printui-less-settings = Mniej ustawień
printui-paper-size-label = Rozmiar papieru
# Section title (noun) for the print scaling options
printui-scale = Skalowanie
printui-scale-fit-to-page-width = Dopasuj do szerokości strony
# Label for input control where user can set the scale percentage
printui-scale-pcent = Skala
# Section title (noun) for the two-sided print options
printui-two-sided-printing = Druk dwustronny
printui-two-sided-printing-off = Wyłączony
# Flip the sheet as if it were bound along its long edge.
printui-two-sided-printing-long-edge = Obróć wzdłuż długiej krawędzi
# Flip the sheet as if it were bound along its short edge.
printui-two-sided-printing-short-edge = Obróć wzdłuż krótkiej krawędzi
# Section title for miscellaneous print options
printui-options = Opcje
printui-headers-footers-checkbox = Drukuj nagłówki i stopki
printui-backgrounds-checkbox = Drukuj tła
printui-selection-checkbox = Drukuj tylko zaznaczenie
printui-color-mode-label = Tryb kolorów
printui-color-mode-color = Kolorowy
printui-color-mode-bw = Czarno-biały
printui-margins = Marginesy
printui-margins-default = Domyślne
printui-margins-min = Minimalne
printui-margins-none = Bez
printui-margins-custom-inches = Niestandardowe (w calach)
printui-margins-custom-mm = Niestandardowe (w milimetrach)
printui-margins-custom-top = Górny
printui-margins-custom-top-inches = Górny (w calach)
printui-margins-custom-top-mm = Górny (w milimetrach)
printui-margins-custom-bottom = Dolny
printui-margins-custom-bottom-inches = Dolny (w calach)
printui-margins-custom-bottom-mm = Dolny (w milimetrach)
printui-margins-custom-left = Lewy
printui-margins-custom-left-inches = Lewy (w calach)
printui-margins-custom-left-mm = Lewy (w milimetrach)
printui-margins-custom-right = Prawy
printui-margins-custom-right-inches = Prawy (w calach)
printui-margins-custom-right-mm = Prawy (w milimetrach)
printui-system-dialog-link = Drukuj za pomocą okna systemowego…
printui-primary-button = Drukuj
printui-primary-button-save = Zapisz
printui-cancel-button = Anuluj
printui-close-button = Zamknij
printui-loading = Przygotowywanie podglądu
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Podgląd wydruku
printui-pages-per-sheet = Strony na kartkę
# This is shown next to the Print button with an indefinite loading spinner
# when the user prints a page and it is being sent to the printer.
printui-print-progress-indicator = Drukowanie…
printui-print-progress-indicator-saving = Zapisywanie…

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

printui-error-invalid-scale = Skala musi być liczbą między 10 a 200.
printui-error-invalid-margin = Wprowadź prawidłowy margines dla wybranego rozmiaru papieru.
printui-error-invalid-copies = Liczba kopii musi wynosić między 1 a 10000.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Zakres musi być liczbą między 1 a { $numPages }.
printui-error-invalid-start-overflow = Numer strony „od” musi być mniejszy niż numer strony „do”.
