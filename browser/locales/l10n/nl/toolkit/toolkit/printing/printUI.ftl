# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Afdrukken
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Opslaan als
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } pagina
       *[other] { $sheetCount } pagina’s
    }
printui-page-range-all = Alle
printui-page-range-custom = Aangepast
printui-page-range-label = Pagina’s
printui-page-range-picker =
    .aria-label = Paginabereik kiezen
printui-page-custom-range =
    .aria-label = Aangepast paginabereik invoeren
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = Van
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = tot
# Section title for the number of copies to print
printui-copies-label = Kopieën
printui-orientation = Oriëntatie
printui-landscape = Liggend
printui-portrait = Staand
# Section title for the printer or destination device to target
printui-destination-label = Uitvoerapparaat
printui-destination-pdf-label = Opslaan als PDF
printui-more-settings = Meer instellingen
printui-less-settings = Minder instellingen
printui-paper-size-label = Papierafmeting
# Section title (noun) for the print scaling options
printui-scale = Schaal
printui-scale-fit-to-page = Verkleinen tot papierformaat
printui-scale-fit-to-page-width = Aan paginabreedte aanpassen
# Label for input control where user can set the scale percentage
printui-scale-pcent = Schaal
# Section title for miscellaneous print options
printui-options = Opties
printui-headers-footers-checkbox = Kop- en voetteksten afdrukken
printui-backgrounds-checkbox = Achtergronden afdrukken
printui-color-mode-label = Kleurmodus
printui-color-mode-color = Kleur
printui-color-mode-bw = Zwart-wit
printui-margins = Marges
printui-margins-default = Standaard
printui-margins-min = Minimum
printui-margins-none = Geen
printui-system-dialog-link = Afdrukken via het systeemdialoogvenster…
printui-primary-button = Afdrukken
printui-primary-button-save = Opslaan
printui-cancel-button = Annuleren
printui-loading = Voorbeeld voorbereiden
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Afdrukvoorbeeld

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

printui-error-invalid-scale = De schaal moet een getal tussen 10 en 200 zijn.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Het bereik moet een getal tussen 1 en { $numPages } zijn.
printui-error-invalid-start-overflow = Het ‘vanaf’-paginanummer moet kleiner zijn dan het ‘tot’-paginanummer.
