# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Udskriv
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Gem som
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } ark papir
       *[other] { $sheetCount } ark papir
    }
printui-page-range-all = Alle
printui-page-range-custom = Tilpasset
printui-page-range-label = Sider
printui-page-range-picker =
    .aria-label = Vælg sideinterval
printui-page-custom-range-input =
    .aria-label = Indtast tilpasset sideinterval
    .placeholder = Fx 2-6, 9, 12-16
# Section title for the number of copies to print
printui-copies-label = Kopier
printui-orientation = Orientering
printui-landscape = Landskab
printui-portrait = Portræt
# Section title for the printer or destination device to target
printui-destination-label = Destination
printui-destination-pdf-label = Gem som PDF
printui-more-settings = Flere indstillinger
printui-less-settings = Færre indstillinger
printui-paper-size-label = Papirstørrelse
# Section title (noun) for the print scaling options
printui-scale = Skalering
printui-scale-fit-to-page-width = Tilpas til sidens bredde
# Label for input control where user can set the scale percentage
printui-scale-pcent = Skalér
# Section title (noun) for the two-sided print options
printui-two-sided-printing = Dobbeltsidet udskrift
printui-two-sided-printing-off = Fra
# Flip the sheet as if it were bound along its long edge.
printui-two-sided-printing-long-edge = Vend efter lang kant
# Flip the sheet as if it were bound along its short edge.
printui-two-sided-printing-short-edge = Vend efter kort kant
# Section title for miscellaneous print options
printui-options = Indstillinger
printui-headers-footers-checkbox = Print sidehoveder og sidefødder
printui-backgrounds-checkbox = Udskriv baggrunde
printui-selection-checkbox = Udskriv kun det markerede
printui-color-mode-label = Farvetilstand
printui-color-mode-color = Farve
printui-color-mode-bw = Sort-hvid
printui-margins = Margener
printui-margins-default = Standard
printui-margins-min = Minimum
printui-margins-none = Ingen
printui-margins-custom-inches = Tilpasset (tommer)
printui-margins-custom-mm = Tilpasset (mm)
printui-margins-custom-top = Top
printui-margins-custom-top-inches = Top (tommer)
printui-margins-custom-top-mm = Top (mm)
printui-margins-custom-bottom = Bund
printui-margins-custom-bottom-inches = Bund (tommer)
printui-margins-custom-bottom-mm = Bund (mm)
printui-margins-custom-left = Venstre
printui-margins-custom-left-inches = Venstre (tommer)
printui-margins-custom-left-mm = Venstre (mm)
printui-margins-custom-right = Højre
printui-margins-custom-right-inches = Højre (tommer)
printui-margins-custom-right-mm = Højre (mm)
printui-system-dialog-link = Udskriv ved brug af system-dialogen…
printui-primary-button = Udskriv
printui-primary-button-save = Gem
printui-cancel-button = Annuller
printui-close-button = Luk
printui-loading = Forbereder forhåndsvisning
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Vis udskrift
printui-pages-per-sheet = Sider pr. ark
# This is shown next to the Print button with an indefinite loading spinner
# when the user prints a page and it is being sent to the printer.
printui-print-progress-indicator = Udskriver…
printui-print-progress-indicator-saving = Gemmer…

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

printui-error-invalid-scale = Skalering skal være et tal mellem 10 og 200.
printui-error-invalid-margin = Angiv en gyldig margin for den valgte papirstørrelse.
printui-error-invalid-copies = Kopier skal være et tal mellem 1 og 10000.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Området skal være et tal mellem 1 og { $numPages }.
printui-error-invalid-start-overflow = Sidetallet "fra" skal være mindre end sidetallet "til".
