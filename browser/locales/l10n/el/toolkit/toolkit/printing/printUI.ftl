# This Source Code Form is subject to the terms of the Mozilla Public
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
printui-page-custom-range =
    .aria-label = Εισαγάγετε προσαρμοσμένο εύρος σελίδων
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = Από
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = έως
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
printui-scale-fit-to-page = Προσαρμογή στη σελίδα
printui-scale-fit-to-page-width = Προσαρμογή στο πλάτος σελίδας
# Label for input control where user can set the scale percentage
printui-scale-pcent = Κλίμακα
# Section title for miscellaneous print options
printui-options = Επιλογές
printui-headers-footers-checkbox = Εκτύπωση κεφαλίδων και υποσέλιδων
printui-backgrounds-checkbox = Εκτύπωση παρασκηνίου
printui-color-mode-label = Λειτουργία χρώματος
printui-color-mode-color = Έγχρωμο
printui-color-mode-bw = Ασπρόμαυρο
printui-margins = Περιθώρια
printui-margins-default = Προεπιλογή
printui-margins-min = Ελάχιστα
printui-margins-none = Χωρίς
printui-system-dialog-link = Εκτύπωση μέσω διαλόγου συστήματος…
printui-primary-button = Εκτύπωση
printui-primary-button-save = Αποθήκευση
printui-cancel-button = Ακύρωση
printui-loading = Προετοιμασία προεπισκόπησης
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Προεπισκόπηση εκτύπωσης

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
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Το εύρος πρέπει να είναι αριθμός μεταξύ 1 και { $numPages }.
printui-error-invalid-start-overflow = Ο αριθμός σελίδας “από” πρέπει να είναι μικρότερος από τον αριθμό σελίδας “έως”.
