# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = Εκτύπωση
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Αποθήκευση ως

# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } φύλλο χαρτιού
       *[other] { $sheetCount } φύλλα χαρτιού
    }

printui-page-range-all = Όλες
printui-page-range-custom = Προσαρμογή
printui-page-range-label = Σελίδες
printui-page-range-picker =
    .aria-label = Επιλογή εύρους σελίδων
printui-page-custom-range-input =
    .aria-label = Εισάγετε προσαρμοσμένο εύρος σελίδων
    .placeholder = π.χ. 2-6, 9, 12-16

# Section title for the number of copies to print
printui-copies-label = Αντίγραφα

printui-orientation = Προσανατολισμός
printui-landscape = Οριζόντιος
printui-portrait = Κατακόρυφος

# Section title for the printer or destination device to target
printui-destination-label = Προορισμός
printui-destination-pdf-label = Αποθήκευση σε PDF

printui-more-settings = Περισσότερες ρυθμίσεις
printui-less-settings = Λιγότερες ρυθμίσεις

printui-paper-size-label = Μέγεθος χαρτιού

# Section title (noun) for the print scaling options
printui-scale = Κλίμακα
printui-scale-fit-to-page-width = Προσαρμογή στο πλάτος σελίδας
# Label for input control where user can set the scale percentage
printui-scale-pcent = Κλίμακα

# Section title (noun) for the two-sided print options
printui-two-sided-printing = Εκτύπωση δύο όψεων
printui-two-sided-printing-off = Ανενεργό
# Flip the sheet as if it were bound along its long edge.
printui-two-sided-printing-long-edge = Αναστροφή στο μακρύ άκρο
# Flip the sheet as if it were bound along its short edge.
printui-two-sided-printing-short-edge = Αναστροφή στο κοντό άκρο

# Section title for miscellaneous print options
printui-options = Επιλογές
printui-headers-footers-checkbox = Εκτύπωση κεφαλίδων και υποσέλιδων
printui-backgrounds-checkbox = Εκτύπωση παρασκηνίου

## The "Format" section, select a version of the website to print. Radio
## options to select between the original page, selected text only, or a version
## where the page is processed with "Reader View".

# The section title.
printui-source-label = Μορφή
# Option for printing the original page.
printui-source-radio = Αρχική
# Option for printing just the content a user selected prior to printing.
printui-selection-radio = Επιλογή
# Option for "simplifying" the page by printing the Reader View version.
printui-simplify-page-radio = Απλοποιημένη

##

printui-color-mode-label = Λειτουργία χρώματος
printui-color-mode-color = Έγχρωμο
printui-color-mode-bw = Ασπρόμαυρο

printui-margins = Περιθώρια
printui-margins-default = Προεπιλογή
printui-margins-min = Ελάχιστα
printui-margins-none = Χωρίς
printui-margins-custom-inches = Προσαρμογή (ίντσες)
printui-margins-custom-mm = Προσαρμογή (mm)
printui-margins-custom-top = Πάνω
printui-margins-custom-top-inches = Πάνω (ίντσες)
printui-margins-custom-top-mm = Πάνω (mm)
printui-margins-custom-bottom = Κάτω
printui-margins-custom-bottom-inches = Κάτω (ίντσες)
printui-margins-custom-bottom-mm = Κάτω (mm)
printui-margins-custom-left = Αριστερά
printui-margins-custom-left-inches = Αριστερά (ίντσες)
printui-margins-custom-left-mm = Αριστερά (mm)
printui-margins-custom-right = Δεξιά
printui-margins-custom-right-inches = Δεξιά (ίντσες)
printui-margins-custom-right-mm = Δεξιά (mm)

printui-system-dialog-link = Εκτύπωση μέσω διαλόγου συστήματος…

printui-primary-button = Εκτύπωση
printui-primary-button-save = Αποθήκευση
printui-cancel-button = Ακύρωση
printui-close-button = Κλείσιμο

printui-loading = Προετοιμασία προεπισκόπησης

# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Προεπισκόπηση εκτύπωσης

printui-pages-per-sheet = Σελίδες ανά φύλλο

# This is shown next to the Print button with an indefinite loading spinner
# when the user prints a page and it is being sent to the printer.
printui-print-progress-indicator = Εκτύπωση…
printui-print-progress-indicator-saving = Αποθήκευση…

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

printui-error-invalid-scale = Η κλίμακα πρέπει να είναι μεταξύ 10 και 200.
printui-error-invalid-margin = Εισάγετε ένα έγκυρο περιθώριο για το επιλεγμένο μέγεθος χαρτιού.
printui-error-invalid-copies = Τα αντίγραφα πρέπει να είναι ένας αριθμός μεταξύ 1 και 10000.

# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Το εύρος πρέπει να είναι αριθμός μεταξύ 1 και { $numPages }.
printui-error-invalid-start-overflow = Ο αριθμός σελίδας “από” πρέπει να είναι μικρότερος από τον αριθμό σελίδας “έως”.
