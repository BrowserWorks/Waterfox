# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Skriv ut
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Spara som

# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } ark papper
       *[other] { $sheetCount } ark papper
    }

printui-page-range-all = Alla
printui-page-range-custom = Anpassad
printui-page-range-label = Sidor
printui-page-range-picker =
    .aria-label = Välj sidintervall
printui-page-custom-range-input =
    .aria-label = Ange anpassat sidintervall
    .placeholder = t.ex. 2-6, 9, 12-16

# Section title for the number of copies to print
printui-copies-label = Kopior

printui-orientation = Orientering
printui-landscape = Liggande
printui-portrait = Stående

# Section title for the printer or destination device to target
printui-destination-label = Mål
printui-destination-pdf-label = Spara till PDF

printui-more-settings = Mer inställningar
printui-less-settings = Färre inställningar

printui-paper-size-label = Pappersstorlek

# Section title (noun) for the print scaling options
printui-scale = Skala
printui-scale-fit-to-page-width = Anpassa till sidbredden
# Label for input control where user can set the scale percentage
printui-scale-pcent = Skala

# Section title (noun) for the two-sided print options
printui-two-sided-printing = Dubbelsidig utskrift
printui-two-sided-printing-off = Av
# Flip the sheet as if it were bound along its long edge.
printui-two-sided-printing-long-edge = Vänd på långsidan
# Flip the sheet as if it were bound along its short edge.
printui-two-sided-printing-short-edge = Vänd på kortsidan

# Section title for miscellaneous print options
printui-options = Alternativ
printui-headers-footers-checkbox = Skriv ut sidhuvud och sidfot
printui-backgrounds-checkbox = Skriv ut bakgrunder

## The "Format" section, select a version of the website to print. Radio
## options to select between the original page, selected text only, or a version
## where the page is processed with "Reader View".

# The section title.
printui-source-label = Format
# Option for printing the original page.
printui-source-radio = Original
# Option for printing just the content a user selected prior to printing.
printui-selection-radio = Markering
# Option for "simplifying" the page by printing the Reader View version.
printui-simplify-page-radio = Förenklad

##

printui-color-mode-label = Färgläge
printui-color-mode-color = Färg
printui-color-mode-bw = Svartvit

printui-margins = Marginaler
printui-margins-default = Standard
printui-margins-min = Minimum
printui-margins-none = Ingen
printui-margins-custom-inches = Anpassad (tum)
printui-margins-custom-mm = Anpassad (mm)
printui-margins-custom-top = Toppen
printui-margins-custom-top-inches = Toppen (tum)
printui-margins-custom-top-mm = Överkant (mm)
printui-margins-custom-bottom = Botten
printui-margins-custom-bottom-inches = Botten (tum)
printui-margins-custom-bottom-mm = Underkant (mm)
printui-margins-custom-left = Vänster
printui-margins-custom-left-inches = Vänster (tum)
printui-margins-custom-left-mm = Vänster (mm)
printui-margins-custom-right = Höger
printui-margins-custom-right-inches = Höger (tum)
printui-margins-custom-right-mm = Höger (mm)

printui-system-dialog-link = Skriv ut via systemets dialogruta…

printui-primary-button = Skriv ut
printui-primary-button-save = Spara
printui-cancel-button = Avbryt
printui-close-button = Stäng

printui-loading = Förbereder förhandsvisning

# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Förhandsgranska

printui-pages-per-sheet = Sidor per blad

# This is shown next to the Print button with an indefinite loading spinner
# when the user prints a page and it is being sent to the printer.
printui-print-progress-indicator = Skriver ut…
printui-print-progress-indicator-saving = Sparar…

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

printui-error-invalid-scale = Skalan måste vara ett nummer mellan 10 och 200.
printui-error-invalid-margin = Ange en giltig marginal för den valda pappersstorleken.
printui-error-invalid-copies = Kopiorna måste vara mellan 1 och 10000.

# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Området måste vara ett nummer mellan 1 och { $numPages }.
printui-error-invalid-start-overflow = Sidnumret "från" måste vara mindre än sidnumret "till".
