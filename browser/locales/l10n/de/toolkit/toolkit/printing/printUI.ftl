# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Drucken
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Speichern unter

# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } Blatt Papier
       *[other] { $sheetCount } Blatt Papier
    }

printui-page-range-all = Alle
printui-page-range-custom = Benutzerdefiniert
printui-page-range-label = Seiten
printui-page-range-picker =
    .aria-label = Seitenbereich auswählen
printui-page-custom-range-input =
    .aria-label = Benutzerdefinierten Seitenbereich eingeben
    .placeholder = z.B. 2-6, 9, 12-16

# Section title for the number of copies to print
printui-copies-label = Kopien

printui-orientation = Ausrichtung
printui-landscape = Querformat
printui-portrait = Hochformat

# Section title for the printer or destination device to target
printui-destination-label = Ziel
printui-destination-pdf-label = Als PDF speichern

printui-more-settings = Mehr Einstellungen
printui-less-settings = Weniger Einstellungen

printui-paper-size-label = Papiergröße

# Section title (noun) for the print scaling options
printui-scale = Skalierung
printui-scale-fit-to-page-width = An Seitenbreite anpassen
# Label for input control where user can set the scale percentage
printui-scale-pcent = Skalierung

# Section title (noun) for the two-sided print options
printui-two-sided-printing = Beidseitiger Druck
printui-two-sided-printing-off = Aus
# Flip the sheet as if it were bound along its long edge.
printui-two-sided-printing-long-edge = An langer Kante spiegeln
# Flip the sheet as if it were bound along its short edge.
printui-two-sided-printing-short-edge = An kurzer Kante spiegeln

# Section title for miscellaneous print options
printui-options = Einstellungen
printui-headers-footers-checkbox = Kopf- und Fußzeilen drucken
printui-backgrounds-checkbox = Hintergrund drucken

## The "Format" section, select a version of the website to print. Radio
## options to select between the original page, selected text only, or a version
## where the page is processed with "Reader View".

# The section title.
printui-source-label = Format
# Option for printing the original page.
printui-source-radio = Original
# Option for printing just the content a user selected prior to printing.
printui-selection-radio = Auswahl
# Option for "simplifying" the page by printing the Reader View version.
printui-simplify-page-radio = Vereinfacht

##

printui-color-mode-label = Farbmodus
printui-color-mode-color = Farbe
printui-color-mode-bw = Schwarz-weiß

printui-margins = Ränder
printui-margins-default = Standard
printui-margins-min = Minimal
printui-margins-none = Keine
printui-margins-custom-inches = Benutzerdefiniert (Zoll)
printui-margins-custom-mm = Benutzerdefiniert (mm)
printui-margins-custom-top = Oben
printui-margins-custom-top-inches = Oben (Zoll)
printui-margins-custom-top-mm = Oben (mm)
printui-margins-custom-bottom = Unten
printui-margins-custom-bottom-inches = Unten (Zoll)
printui-margins-custom-bottom-mm = Unten (mm)
printui-margins-custom-left = Links
printui-margins-custom-left-inches = Links (Zoll)
printui-margins-custom-left-mm = Links (mm)
printui-margins-custom-right = Rechts
printui-margins-custom-right-inches = Rechts (Zoll)
printui-margins-custom-right-mm = Rechts (mm)

printui-system-dialog-link = Mit Systemdialog drucken…

printui-primary-button = Drucken
printui-primary-button-save = Speichern
printui-cancel-button = Abbrechen
printui-close-button = Schließen

printui-loading = Vorschau wird vorbereitet

# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Druckvorschau

printui-pages-per-sheet = Seiten pro Blatt

# This is shown next to the Print button with an indefinite loading spinner
# when the user prints a page and it is being sent to the printer.
printui-print-progress-indicator = Drucken…
printui-print-progress-indicator-saving = Wird gespeichert…

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
printui-paper-letter = Letter
printui-paper-legal = Legal
printui-paper-tabloid = Tabloid

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = Die Skalierung muss eine Zahl zwischen 10 und 200 sein.
printui-error-invalid-margin = Bitte geben Sie einen gültigen Rand für die gewählte Papiergröße ein.
printui-error-invalid-copies = Kopien muss eine Zahl zwischen 1 und 10000 sein.

# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Der Bereich muss eine Zahl zwischen 1 und { $numPages } sein.
printui-error-invalid-start-overflow = Die "von"-Seitenzahl muss kleiner sein als die "bis"-Seitenzahl.
