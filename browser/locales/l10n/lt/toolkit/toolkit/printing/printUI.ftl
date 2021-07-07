# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Spausdinimas
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Įrašyti kaip

# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } popieriaus lapas
        [few] { $sheetCount } popieriaus lapai
       *[other] { $sheetCount } popieriaus lapų
    }

printui-page-range-all = Visi
printui-page-range-custom = Pasirinktinai
printui-page-range-label = Puslapiai
printui-page-range-picker =
    .aria-label = Pasirinkite puslapių intervalą
printui-page-custom-range-input =
    .aria-label = Įveskite norimą puslapių intervalą
    .placeholder = pvz., 2-6, 9, 12-16

# Section title for the number of copies to print
printui-copies-label = Kopijos

printui-orientation = Orientacija
printui-landscape = Gulsčias
printui-portrait = Stačias

# Section title for the printer or destination device to target
printui-destination-label = Paskirtis
printui-destination-pdf-label = Įrašyti į PDF

printui-more-settings = Daugiau nuostatų
printui-less-settings = Mažiau nuostatų

printui-paper-size-label = Popieriaus dydis

# Section title (noun) for the print scaling options
printui-scale = Mastelis
printui-scale-fit-to-page-width = Pritaikyti prie puslapio pločio
# Label for input control where user can set the scale percentage
printui-scale-pcent = Mastelis

# Section title (noun) for the two-sided print options
printui-two-sided-printing = Dvipusis spausdinimas
printui-two-sided-printing-off = Išjungta
# Flip the sheet as if it were bound along its long edge.
printui-two-sided-printing-long-edge = Paversti ant ilgojo krašto
# Flip the sheet as if it were bound along its short edge.
printui-two-sided-printing-short-edge = Paversti ant trumpojo krašto

# Section title for miscellaneous print options
printui-options = Nuostatos
printui-headers-footers-checkbox = Spausdinti antraštes ir poraštes
printui-backgrounds-checkbox = Spausdinti foną

## The "Format" section, select a version of the website to print. Radio
## options to select between the original page, selected text only, or a version
## where the page is processed with "Reader View".

# The section title.
printui-source-label = Formatas
# Option for printing the original page.
printui-source-radio = Originalus
# Option for printing just the content a user selected prior to printing.
printui-selection-radio = Pažymėta sritis
# Option for "simplifying" the page by printing the Reader View version.
printui-simplify-page-radio = Supaprastintas

##

printui-color-mode-label = Spalvotas spausdinimas
printui-color-mode-color = Spalvotai
printui-color-mode-bw = Juodai ir baltai

printui-margins = Paraštės
printui-margins-default = Numatytos
printui-margins-min = Mažiausios
printui-margins-none = Jokių
printui-margins-custom-inches = Pasirinktinės (coliai)
printui-margins-custom-mm = Pasirinktinės (mm)
printui-margins-custom-top = Viršutinė
printui-margins-custom-top-inches = Viršutinė (coliai)
printui-margins-custom-top-mm = Viršutinė (mm)
printui-margins-custom-bottom = Apatinė
printui-margins-custom-bottom-inches = Apatinė (coliai)
printui-margins-custom-bottom-mm = Apatinė (mm)
printui-margins-custom-left = Kairė
printui-margins-custom-left-inches = Kairė (coliai)
printui-margins-custom-left-mm = Kairė (mm)
printui-margins-custom-right = Dešinė
printui-margins-custom-right-inches = Dešinė (coliai)
printui-margins-custom-right-mm = Dešinė (mm)

printui-system-dialog-link = Spausdinti naudojant sistemos dialogą…

printui-primary-button = Spausdinti
printui-primary-button-save = Įrašyti
printui-cancel-button = Atsisakyti
printui-close-button = Užverti

printui-loading = Ruošiama peržiūra

# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Spaudinio peržiūra

printui-pages-per-sheet = Puslapiai per lapą

# This is shown next to the Print button with an indefinite loading spinner
# when the user prints a page and it is being sent to the printer.
printui-print-progress-indicator = Spausdinama…
printui-print-progress-indicator-saving = Įrašoma…

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
printui-paper-letter = JAV laiškas
printui-paper-legal = JAV teisinis
printui-paper-tabloid = Bulvarinis

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = Mastelis turi būti skaičius tarp 10 ir 200.
printui-error-invalid-margin = Įveskite tinkamą paraštę pasirinktam popieriaus dydžiui.
printui-error-invalid-copies = Kopijos turi būti skaičius tarp 1 ir 10000.

# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Intervalas turi būti skaičius tarp 1 ir { $numPages }.
printui-error-invalid-start-overflow = Puslapio skaičius „nuo“ turi būti mažesnis negu puslapio skaičius „iki“.
