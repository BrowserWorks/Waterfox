# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard-selection-header = Εισαγωγή δεδομένων προγράμματος περιήγησης
migration-wizard-selection-list = Επιλέξτε τα δεδομένα που θέλετε να εισαγάγετε.
# Shown in the new migration wizard's dropdown selector for choosing the browser
# to import from. This variant is shown when the selected browser doesn't support
# user profiles, and so we only show the browser name.
#
# Variables:
#  $sourceBrowser (String): the name of the browser to import from.
migration-wizard-selection-option-without-profile = { $sourceBrowser }
# Shown in the new migration wizard's dropdown selector for choosing the browser
# and user profile to import from. This variant is shown when the selected browser
# supports user profiles.
#
# Variables:
#  $sourceBrowser (String): the name of the browser to import from.
#  $profileName (String): the name of the user profile to import from.
migration-wizard-selection-option-with-profile = { $sourceBrowser } — { $profileName }

# Each migrator is expected to include a display name string, and that display
# name string should have a key with "migration-wizard-migrator-display-name-"
# as a prefix followed by the unique identification key for the migrator.

migration-wizard-migrator-display-name-brave = Brave
migration-wizard-migrator-display-name-canary = Chrome Canary
migration-wizard-migrator-display-name-chrome = Chrome
migration-wizard-migrator-display-name-chrome-beta = Chrome Beta
migration-wizard-migrator-display-name-chrome-dev = Chrome Dev
migration-wizard-migrator-display-name-chromium = Chromium
migration-wizard-migrator-display-name-chromium-360se = 360 Secure Browser
migration-wizard-migrator-display-name-chromium-edge = Microsoft Edge
migration-wizard-migrator-display-name-chromium-edge-beta = Microsoft Edge Beta
migration-wizard-migrator-display-name-edge-legacy = Microsoft Edge Legacy
migration-wizard-migrator-display-name-firefox = Waterfox
migration-wizard-migrator-display-name-file-password-csv = Κωδικοί πρόσβασης από αρχείο CSV
migration-wizard-migrator-display-name-file-bookmarks = Σελιδοδείκτες από αρχείο HTML
migration-wizard-migrator-display-name-ie = Microsoft Internet Explorer
migration-wizard-migrator-display-name-opera = Opera
migration-wizard-migrator-display-name-opera-gx = Opera GX
migration-wizard-migrator-display-name-safari = Safari
migration-wizard-migrator-display-name-vivaldi = Vivaldi

## These strings will be displayed based on how many resources are selected to import

migration-all-available-data-label = Εισαγωγή όλων των διαθέσιμων δεδομένων
migration-no-selected-data-label = Δεν έχουν επιλεχτεί δεδομένα προς εισαγωγή
migration-selected-data-label = Εισαγωγή επιλεγμένων δεδομένων

##

migration-select-all-option-label = Επιλογή όλων
migration-bookmarks-option-label = Σελιδοδείκτες
# Favorites is used for Bookmarks when importing from Internet Explorer or
# Edge, as this is the terminology for bookmarks on those browsers.
migration-favorites-option-label = Αγαπημένα
migration-logins-and-passwords-option-label = Αποθηκευμένες συνδέσεις και κωδικοί πρόσβασης
migration-history-option-label = Ιστορικό περιήγησης
migration-extensions-option-label = Επεκτάσεις
migration-form-autofill-option-label = Δεδομένα αυτόματης συμπλήρωσης φορμών
migration-payment-methods-option-label = Μέθοδοι πληρωμής
migration-cookies-option-label = Cookies
migration-session-option-label = Παράθυρα και καρτέλες
migration-otherdata-option-label = Άλλα δεδομένα
migration-passwords-from-file-progress-header = Εισαγωγή αρχείου κωδικών πρόσβασης
migration-passwords-from-file-success-header = Επιτυχής εισαγωγή κωδικών πρόσβασης
migration-passwords-from-file = Έλεγχος αρχείου για κωδικούς πρόσβασης
migration-passwords-new = Νέοι κωδικοί πρόσβασης
migration-passwords-updated = Υπάρχοντες κωδικοί πρόσβασης
migration-passwords-from-file-no-valid-data = Το αρχείο δεν περιλαμβάνει έγκυρα δεδομένα κωδικών πρόσβασης. Επιλέξτε άλλο αρχείο.
migration-passwords-from-file-picker-title = Εισαγωγή αρχείου κωδικών πρόσβασης
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
migration-passwords-from-file-csv-filter-title =
    { PLATFORM() ->
        [macos] Έγγραφο CSV
       *[other] Αρχείο CSV
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
migration-passwords-from-file-tsv-filter-title =
    { PLATFORM() ->
        [macos] Έγγραφο TSV
       *[other] Αρχείο TSV
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if new passwords were added.
#
# Variables:
#  $newEntries (Number): the number of new successfully imported passwords
migration-wizard-progress-success-new-passwords =
    { $newEntries ->
        [one] Προστέθηκε { $newEntries }
       *[other] Προστέθηκαν { $newEntries }
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if existing passwords were updated.
#
# Variables:
#  $updatedEntries (Number): the number of updated passwords
migration-wizard-progress-success-updated-passwords =
    { $updatedEntries ->
        [one] Ενημερώθηκε { $updatedEntries }
       *[other] Ενημερώθηκαν { $updatedEntries }
    }
migration-bookmarks-from-file-picker-title = Εισαγωγή αρχείου σελιδοδεικτών
migration-bookmarks-from-file-progress-header = Εισαγωγή σελιδοδεικτών
migration-bookmarks-from-file = Σελιδοδείκτες
migration-bookmarks-from-file-success-header = Επιτυχής εισαγωγή σελιδοδεικτών
migration-bookmarks-from-file-no-valid-data = Το αρχείο δεν περιλαμβάνει δεδομένα σελιδοδεικτών. Επιλέξτε άλλο αρχείο.
# A description for the .html file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-html-filter-title =
    { PLATFORM() ->
        [macos] Έγγραφο HTML
       *[other] Αρχείο HTML
    }
# A description for the .json file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-json-filter-title = Αρχείο JSON
# Shown in the migration wizard after importing bookmarks from a file
# has completed.
#
# Variables:
#  $newEntries (Number): the number of imported bookmarks.
migration-wizard-progress-success-new-bookmarks =
    { $newEntries ->
        [one] { $newEntries } σελιδοδείκτης
       *[other] { $newEntries } σελιδοδείκτες
    }
migration-import-button-label = Εισαγωγή
migration-choose-to-import-from-file-button-label = Εισαγωγή από αρχείο
migration-import-from-file-button-label = Επιλογή αρχείου
migration-cancel-button-label = Ακύρωση
migration-done-button-label = Τέλος
migration-continue-button-label = Συνέχεια
migration-wizard-import-browser-no-browsers = Το { -brand-short-name } δεν μπόρεσε να βρει προγράμματα που περιέχουν δεδομένα σελιδοδεικτών, ιστορικού ή κωδικών πρόσβασης.
migration-wizard-import-browser-no-resources = Προέκυψε σφάλμα. Το { -brand-short-name } δεν μπορεί να βρει δεδομένα προς εισαγωγή από αυτό το προφίλ προγράμματος περιήγησης.

## These strings will be used to create a dynamic list of items that can be
## imported. The list will be created using Intl.ListFormat(), so it will
## follow each locale's rules, and the first item will be capitalized by code.
## When applicable, the resources should be in their plural form.
## For example, a possible list could be "Bookmarks, passwords and autofill data".

migration-list-bookmark-label = σελιδοδείκτες
# “favorites” refers to bookmarks in Edge and Internet Explorer. Use the same terminology
# if the browser is available in your language.
migration-list-favorites-label = αγαπημένα
migration-list-password-label = κωδικοί πρόσβασης
migration-list-history-label = ιστορικό
migration-list-extensions-label = επεκτάσεις
migration-list-autofill-label = δεδομένα αυτόματης συμπλήρωσης
migration-list-payment-methods-label = μέθοδοι πληρωμής

##

migration-wizard-progress-header = Εισαγωγή δεδομένων
# This header appears in the final page of the migration wizard only if
# all resources were imported successfully.
migration-wizard-progress-done-header = Επιτυχής εισαγωγή δεδομένων
# This header appears in the final page of the migration wizard if only
# some of the resources were imported successfully. This is meant to be
# distinct from migration-wizard-progress-done-header, which is only shown
# if all resources were imported successfully.
migration-wizard-progress-done-with-warnings-header = Η εισαγωγή δεδομένων ολοκληρώθηκε
migration-wizard-progress-icon-in-progress =
    .aria-label = Εισαγωγή…
migration-wizard-progress-icon-completed =
    .aria-label = Ολοκληρώθηκε
migration-safari-password-import-header = Εισαγωγή κωδικών πρόσβασης από το Safari
migration-safari-password-import-steps-header = Για την εισαγωγή κωδικών πρόσβασης από το Safari:
migration-safari-password-import-step1 = Στο Safari, ανοίξτε το μενού «Safari» και μεταβείτε στις Προτιμήσεις > Συνθηματικά
migration-safari-password-import-step2 = Κάντε κλικ στο κουμπί <img data-l10n-name="safari-icon-3dots"/> και επιλέξτε «Εξαγωγή όλων των συνθηματικών»
migration-safari-password-import-step3 = Αποθηκεύστε το αρχείο κωδικών πρόσβασης
migration-safari-password-import-step4 = Χρησιμοποιήστε το «Επιλογή αρχείου» παρακάτω για να επιλέξετε το αρχείο κωδικών πρόσβασης που αποθηκεύσατε
migration-safari-password-import-skip-button = Παράλειψη
migration-safari-password-import-select-button = Επιλογή αρχείου
# Shown in the migration wizard after importing bookmarks from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-bookmarks =
    { $quantity ->
        [one] { $quantity } σελιδοδείκτης
       *[other] { $quantity } σελιδοδείκτες
    }
# Shown in the migration wizard after importing bookmarks from either
# Internet Explorer or Edge.
#
# Use the same terminology if the browser is available in your language.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-favorites =
    { $quantity ->
        [one] { $quantity } αγαπημένο
       *[other] { $quantity } αγαπημένα
    }

## The import process identifies extensions installed in other supported
## browsers and installs the corresponding (matching) extensions compatible
## with Waterfox, if available.

# Shown in the migration wizard after importing all matched extensions
# from supported browsers.
#
# Variables:
#   $quantity (Number): the number of successfully imported extensions
migration-wizard-progress-success-extensions =
    { $quantity ->
        [one] { $quantity } επέκταση
       *[other] { $quantity } επεκτάσεις
    }
# Shown in the migration wizard after importing a partial amount of
# matched extensions from supported browsers.
#
# Variables:
#   $matched (Number): the number of matched imported extensions
#   $quantity (Number): the number of total extensions found during import
migration-wizard-progress-partial-success-extensions = { $matched } από { $quantity } επεκτάσεις
migration-wizard-progress-extensions-support-link = Μάθετε πώς το { -brand-product-name } βρίσκει αντίστοιχες επεκτάσεις
# Shown in the migration wizard if there are no matched extensions
# on import from supported browsers.
migration-wizard-progress-no-matched-extensions = Δεν υπάρχουν αντίστοιχες επεκτάσεις
migration-wizard-progress-extensions-addons-link = Περιήγηση στις επεκτάσεις για το { -brand-short-name }

##

# Shown in the migration wizard after importing passwords from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported passwords
migration-wizard-progress-success-passwords =
    { $quantity ->
        [one] { $quantity } κωδικός πρόσβασης
       *[other] { $quantity } κωδικοί πρόσβασης
    }
# Shown in the migration wizard after importing history from another
# browser has completed.
#
# Variables:
#  $maxAgeInDays (Number): the maximum number of days of history that might be imported.
migration-wizard-progress-success-history =
    { $maxAgeInDays ->
        [one] Από την τελευταία ημέρα
       *[other] Από τις τελευταίες { $maxAgeInDays } ημέρες
    }
migration-wizard-progress-success-formdata = Ιστορικό φορμών
# Shown in the migration wizard after importing payment methods from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported payment methods
migration-wizard-progress-success-payment-methods =
    { $quantity ->
        [one] { $quantity } μέθοδος πληρωμής
       *[other] { $quantity } μέθοδοι πληρωμής
    }
migration-wizard-safari-permissions-sub-header = Για την εισαγωγή σελιδοδεικτών και ιστορικού περιήγησης από το Safari:
migration-wizard-safari-instructions-continue = Επιλέξτε «Συνέχεια»
migration-wizard-safari-instructions-folder = Επιλέξτε τον φάκελο του Safari από τη λίστα και κάντε κλικ στο «Άνοιγμα»
