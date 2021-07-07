# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Stampa

# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Salva con nome

# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } foglio
       *[other] { $sheetCount } fogli
    }

printui-page-range-all = Tutto
printui-page-range-custom = Personalizzato
printui-page-range-label = Pagine
printui-page-range-picker =
  .aria-label = Selezionare un intervallo di pagine
printui-page-custom-range-input =
  .aria-label = Inserire un intervallo di pagine personalizzato
  .placeholder = ad es. 2-6, 9, 12-16

# Section title for the number of copies to print
printui-copies-label = Copie

printui-orientation = Orientamento
printui-landscape = Orizzontale
printui-portrait = Verticale

# Section title for the printer or destination device to target
printui-destination-label = Destinazione

printui-destination-pdf-label = Salva come PDF

printui-more-settings = Altre impostazioni
printui-less-settings = Meno impostazioni

printui-paper-size-label = Formato carta

# Section title (noun) for the print scaling options
printui-scale = Ridimensionamento
printui-scale-fit-to-page-width = Adatta alla larghezza della pagina
# Label for input control where user can set the scale percentage
printui-scale-pcent = Ridimensiona

# Section title (noun) for the two-sided print options
printui-two-sided-printing = Stampa fronte/retro
printui-two-sided-printing-off = Disattivata
# Flip the sheet as if it were bound along its long edge.
printui-two-sided-printing-long-edge = Capovolgi pagine sul lato lungo
# Flip the sheet as if it were bound along its short edge.
printui-two-sided-printing-short-edge = Capovolgi pagine sul lato corto

# Section title for miscellaneous print options
printui-options = Opzioni
printui-headers-footers-checkbox = Stampa intestazioni e piè di pagina
printui-backgrounds-checkbox = Stampa sfondi
printui-selection-checkbox = Stampa solo la selezione

printui-color-mode-label = Modalità colore
printui-color-mode-color = Colori
printui-color-mode-bw = Bianco e nero

printui-margins = Margini
printui-margins-default = Predefiniti
printui-margins-min = Minimi
printui-margins-none = Nessuno
printui-margins-custom-inches = Personalizzati (pollici)
printui-margins-custom-mm = Personalizzati (mm)
printui-margins-custom-top = Superiore
printui-margins-custom-bottom = Inferiore
printui-margins-custom-left = Sinistra
printui-margins-custom-right = Destra
printui-margins-custom-top-inches = Superiore (pollici)
printui-margins-custom-bottom-inches = Inferiore (pollici)
printui-margins-custom-left-inches = Sinistra (pollici)
printui-margins-custom-right-inches = Destra (pollici)
printui-margins-custom-top-mm = Superiore (mm)
printui-margins-custom-bottom-mm = Inferiore (mm)
printui-margins-custom-left-mm = Sinistra (mm)
printui-margins-custom-right-mm = Destra (mm)

printui-system-dialog-link = Stampa utilizzando la finestra di dialogo del sistema…

printui-primary-button = Stampa
printui-primary-button-save = Salva
printui-cancel-button = Annulla
printui-close-button = Chiudi

printui-loading = Preparazione anteprima

# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Anteprima di stampa

printui-pages-per-sheet = Pagine per foglio

printui-print-progress-indicator = Stampa in corso…
printui-print-progress-indicator-saving = Salvataggio in corso…

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
printui-paper-letter = Lettera USA
printui-paper-legal = Legale USA
printui-paper-tabloid = Tabloid

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = Il ridimensionamento deve essere un numero compreso tra 10 e 200.
printui-error-invalid-margin = Inserire un valore del margine valido per il formato di carta selezionato.
printui-error-invalid-copies = Il numero di copie deve essere un valore compreso tra 1 e 10000.

# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = L’intervallo deve essere un numero compreso tra 1 e { $numPages }.
printui-error-invalid-start-overflow = Il numero della pagina “Da” deve essere inferiore al numero della pagina “a”.
