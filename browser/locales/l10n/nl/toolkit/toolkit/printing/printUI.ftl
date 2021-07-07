# This Source Code Form is subject to the terms of the Waterfox Public
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
printui-page-custom-range-input =
    .aria-label = Aangepast paginabereik invoeren
    .placeholder = b.v. 2-6, 9, 12-16

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
printui-scale-fit-to-page-width = Aan paginabreedte aanpassen
# Label for input control where user can set the scale percentage
printui-scale-pcent = Schaal

# Section title (noun) for the two-sided print options
printui-two-sided-printing = Dubbelzijdig afdrukken
printui-two-sided-printing-off = Uit
# Flip the sheet as if it were bound along its long edge.
printui-two-sided-printing-long-edge = Draaien op lange zijde
# Flip the sheet as if it were bound along its short edge.
printui-two-sided-printing-short-edge = Draaien op korte zijde

# Section title for miscellaneous print options
printui-options = Opties
printui-headers-footers-checkbox = Kop- en voetteksten afdrukken
printui-backgrounds-checkbox = Achtergronden afdrukken

## The "Format" section, select a version of the website to print. Radio
## options to select between the original page, selected text only, or a version
## where the page is processed with "Reader View".

# The section title.
printui-source-label = Opmaak
# Option for printing the original page.
printui-source-radio = Oorspronkelijk
# Option for printing just the content a user selected prior to printing.
printui-selection-radio = Selectie
# Option for "simplifying" the page by printing the Reader View version.
printui-simplify-page-radio = Vereenvoudigd

##

printui-color-mode-label = Kleurmodus
printui-color-mode-color = Kleur
printui-color-mode-bw = Zwart-wit

printui-margins = Marges
printui-margins-default = Standaard
printui-margins-min = Minimum
printui-margins-none = Geen
printui-margins-custom-inches = Aangepast (inches)
printui-margins-custom-mm = Aangepast (mm)
printui-margins-custom-top = Boven
printui-margins-custom-top-inches = Bovenzijde (inches)
printui-margins-custom-top-mm = Bovenzijde (mm)
printui-margins-custom-bottom = Onder
printui-margins-custom-bottom-inches = Onderzijde (inches)
printui-margins-custom-bottom-mm = Onderzijde (mm)
printui-margins-custom-left = Links
printui-margins-custom-left-inches = Links (inches)
printui-margins-custom-left-mm = Links (mm)
printui-margins-custom-right = Rechts
printui-margins-custom-right-inches = Rechts (inches)
printui-margins-custom-right-mm = Rechts (mm)

printui-system-dialog-link = Afdrukken via het systeemdialoogvenster…

printui-primary-button = Afdrukken
printui-primary-button-save = Opslaan
printui-cancel-button = Annuleren
printui-close-button = Sluiten

printui-loading = Voorbeeld voorbereiden

# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Afdrukvoorbeeld

printui-pages-per-sheet = Pagina’s per vel

# This is shown next to the Print button with an indefinite loading spinner
# when the user prints a page and it is being sent to the printer.
printui-print-progress-indicator = Afdrukken…
printui-print-progress-indicator-saving = Opslaan…

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
printui-error-invalid-margin = Voer een geldige marge voor het geselecteerde papierformaat in.
printui-error-invalid-copies = Het aantal exemplaren moet een getal tussen 1 en 10000 zijn.

# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Het bereik moet een getal tussen 1 en { $numPages } zijn.
printui-error-invalid-start-overflow = Het ‘vanaf’-paginanummer moet kleiner zijn dan het ‘tot’-paginanummer.
