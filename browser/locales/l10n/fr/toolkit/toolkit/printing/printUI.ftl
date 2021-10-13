# This Source Code Form is subject to the terms of the Waterfox Public
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
printui-page-custom-range-input =
    .aria-label = Saisir un intervalle de pages personnalisé
    .placeholder = par ex. 2-6, 9, 12-16

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
printui-scale-fit-to-page-width = Ajuster à la largeur de la page
# Label for input control where user can set the scale percentage
printui-scale-pcent = Échelle

# Section title (noun) for the two-sided print options
printui-two-sided-printing = Impression recto verso
printui-two-sided-printing-off = Désactivée
# Flip the sheet as if it were bound along its long edge.
printui-two-sided-printing-long-edge = Retourner sur le bord long
# Flip the sheet as if it were bound along its short edge.
printui-two-sided-printing-short-edge = Retourner sur le bord court

# Section title for miscellaneous print options
printui-options = Options
printui-headers-footers-checkbox = Imprimer les en-têtes et pieds de page
printui-backgrounds-checkbox = Imprimer les arrière-plans

## The "Format" section, select a version of the website to print. Radio
## options to select between the original page, selected text only, or a version
## where the page is processed with "Reader View".

# The section title.
printui-source-label = Format
# Option for printing the original page.
printui-source-radio = Original
# Option for printing just the content a user selected prior to printing.
printui-selection-radio = Sélection
# Option for "simplifying" the page by printing the Reader View version.
printui-simplify-page-radio = Simplifié

##

printui-color-mode-label = Mode de couleur
printui-color-mode-color = Couleur
printui-color-mode-bw = Noir et blanc

printui-margins = Marges
printui-margins-default = Par défaut
printui-margins-min = Minimum
printui-margins-none = Aucune
printui-margins-custom-inches = Personnalisées (pouces)
printui-margins-custom-mm = Personnalisées (mm)
printui-margins-custom-top = Haut de page
printui-margins-custom-top-inches = Haut (pouces)
printui-margins-custom-top-mm = Haut (mm)
printui-margins-custom-bottom = Bas de page
printui-margins-custom-bottom-inches = Bas (pouces)
printui-margins-custom-bottom-mm = Bas (mm)
printui-margins-custom-left = Gauche
printui-margins-custom-left-inches = Gauche (pouces)
printui-margins-custom-left-mm = Gauche (mm)
printui-margins-custom-right = Droite
printui-margins-custom-right-inches = Droite (pouces)
printui-margins-custom-right-mm = Droite (mm)

printui-system-dialog-link = Imprimer en utilisant la boîte de dialogue système…

printui-primary-button = Imprimer
printui-primary-button-save = Enregistrer
printui-cancel-button = Annuler
printui-close-button = Fermer

printui-loading = Préparation de l’aperçu

# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Aperçu avant impression

printui-pages-per-sheet = Pages par feuille

# This is shown next to the Print button with an indefinite loading spinner
# when the user prints a page and it is being sent to the printer.
printui-print-progress-indicator = Impression…
printui-print-progress-indicator-saving = Enregistrement…

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
printui-error-invalid-margin = Veuillez saisir une marge valide pour le format de papier sélectionné.
printui-error-invalid-copies = Le nombre de copies doit être compris entre 1 et 10 000.

# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = La plage doit être un nombre compris entre 1 et { $numPages }.
printui-error-invalid-start-overflow = Le numéro de page « de » doit être inférieur au numéro de page « à ».
