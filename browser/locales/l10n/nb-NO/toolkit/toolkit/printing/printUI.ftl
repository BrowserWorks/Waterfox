# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Skriv ut
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Lagre som
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } ark
       *[other] { $sheetCount } ark
    }
printui-page-range-all = Alle
printui-page-range-custom = Tilpasset
printui-page-range-label = Sider
printui-page-range-picker =
    .aria-label = Velg sideområde
printui-page-custom-range =
    .aria-label = Angi tilpassset sideområde
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = Fra
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = til
# Section title for the number of copies to print
printui-copies-label = Eksemplarer
printui-orientation = Papirretning
printui-landscape = Liggende
printui-portrait = Stående
# Section title for the printer or destination device to target
printui-destination-label = Mål
printui-destination-pdf-label = Lagre til PDF
printui-more-settings = Flere innstillinger
printui-less-settings = Færre innstillinger
printui-paper-size-label = Papirstørrelse:
# Section title (noun) for the print scaling options
printui-scale = Skalering
printui-scale-fit-to-page = Tilpass til side
printui-scale-fit-to-page-width = Tilpass til sidebredden
# Label for input control where user can set the scale percentage
printui-scale-pcent = Skalering
# Section title for miscellaneous print options
printui-options = Innstillinger
printui-headers-footers-checkbox = Skriv ut topptekst og bunntekst
printui-backgrounds-checkbox = Skriv ut bakgrunner
printui-color-mode-label = Fargemodus
printui-color-mode-color = Farge
printui-color-mode-bw = Svart-hvit
printui-margins = Marger
printui-margins-default = Standard
printui-margins-min = Minimum
printui-margins-none = Ingen
printui-system-dialog-link = Skriv ut ved hjelp av systemdialogvinduet…
printui-primary-button = Skriv ut
printui-primary-button-save = Lagre
printui-cancel-button = Avbryt
printui-loading = Forbereder forhåndsvisning
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Forhåndsvisning

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

printui-error-invalid-scale = Skaleringen må være et tall mellom 10 og 200.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Området må være et tall mellom 1 og { $numPages }.
printui-error-invalid-start-overflow = «Fra»-sidetallet må være mindre enn «til»-sidetallet
