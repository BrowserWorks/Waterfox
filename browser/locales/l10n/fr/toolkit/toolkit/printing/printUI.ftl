# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Imprimer
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Enregistrer sous
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } feuille de papier
       *[other] { $sheetCount } feuilles de papier
    }
printui-page-range-all = Toutes
printui-page-range-custom = Personnalisé
printui-page-range-label = Pages
printui-page-range-picker =
    .aria-label = Choisir un intervalle de pages
printui-page-custom-range =
    .aria-label = Saisir un intervalle de pages personnalisé
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = De
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = à
# Section title for the number of copies to print
printui-copies-label = Copies
printui-orientation = Orientation
printui-landscape = Paysage
printui-portrait = Portrait
# Section title for the printer or destination device to target
printui-destination-label = Destination
printui-destination-pdf-label = Enregistrer au format PDF
printui-more-settings = Plus de paramètres
printui-less-settings = Moins de paramètres
printui-paper-size-label = Taille du papier
# Section title (noun) for the print scaling options
printui-scale = Échelle
printui-scale-fit-to-page = Ajuster à la page
printui-scale-fit-to-page-width = Ajuster à la largeur de la page
# Label for input control where user can set the scale percentage
printui-scale-pcent = Échelle
# Section title for miscellaneous print options
printui-options = Options
printui-headers-footers-checkbox = Imprimer les en-têtes et pieds de page
printui-backgrounds-checkbox = Imprimer les arrière-plans
printui-color-mode-label = Mode de couleur
printui-color-mode-color = Couleur
printui-color-mode-bw = Noir et blanc
printui-margins = Marges
printui-margins-default = Par défaut
printui-margins-min = Minimum
printui-margins-none = Aucune
printui-system-dialog-link = Imprimer en utilisant la boîte de dialogue système…
printui-primary-button = Imprimer
printui-primary-button-save = Enregistrer
printui-cancel-button = Annuler
printui-loading = Préparation de l’aperçu
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Aperçu avant impression

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
printui-paper-letter = Lettre US
printui-paper-legal = US Legal
printui-paper-tabloid = Tabloïd

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = L’échelle doit être un nombre compris entre 10 et 200.
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = La plage doit être un nombre compris entre 1 et { $numPages }.
printui-error-invalid-start-overflow = Le numéro de page « de » doit être inférieur au numéro de page « à ».
