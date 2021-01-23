# This Source Code Form is subject to the terms of the Mozilla Public
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
printui-page-custom-range =
    .aria-label = Benutzerdefinierten Seitenbereich eingeben
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = Von
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = bis
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
printui-scale-fit-to-page = An Seite anpassen
printui-scale-fit-to-page-width = An Seitenbreite anpassen
# Label for input control where user can set the scale percentage
printui-scale-pcent = Skalierung
# Section title for miscellaneous print options
printui-options = Einstellungen
printui-headers-footers-checkbox = Kopf- und Fußzeilen drucken
printui-backgrounds-checkbox = Hintergrund drucken
printui-color-mode-label = Farbmodus
printui-color-mode-color = Farbe
printui-color-mode-bw = Schwarz-weiß
printui-margins = Ränder
printui-margins-default = Standard
printui-margins-min = Minimal
printui-margins-none = Keine
printui-system-dialog-link = Mit Systemdialog drucken…
printui-primary-button = Drucken
printui-primary-button-save = Speichern
printui-cancel-button = Abbrechen
printui-loading = Vorschau wird vorbereitet
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Druckvorschau

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
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Der Bereich muss eine Zahl zwischen 1 und { $numPages } sein.
printui-error-invalid-start-overflow = Die "von"-Seitenzahl muss kleiner sein als die "bis"-Seitenzahl.
