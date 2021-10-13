# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Συνδέσεις & κωδικοί πρόσβασης

# "Google Play" and "App Store" are both branding and should not be translated

login-filter =
    .placeholder = Αναζήτηση συνδέσεων

create-login-button = Δημιουργία νέας σύνδεσης

fxaccounts-sign-in-text = Αποκτήστε πρόσβαση στους κωδικούς πρόσβασής σας από άλλες συσκευές
fxaccounts-sign-in-sync-button = Σύνδεση για συγχρονισμό
fxaccounts-avatar-button =
    .title = Διαχείριση λογαριασμού

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Άνοιγμα μενού
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Εισαγωγή από άλλο φυλλομετρητή…
about-logins-menu-menuitem-import-from-a-file = Εισαγωγή από αρχείο…
about-logins-menu-menuitem-export-logins = Εξαγωγή συνδέσεων…
about-logins-menu-menuitem-remove-all-logins = Αφαίρεση όλων των συνδέσεων…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Επιλογές
       *[other] Προτιμήσεις
    }
about-logins-menu-menuitem-help = Βοήθεια

## Login List

login-list =
    .aria-label = Αντιστοιχίες συνδέσεων στην αναζήτηση
login-list-count =
    { $count ->
        [one] { $count } σύνδεση
       *[other] { $count } συνδέσεις
    }
login-list-sort-label-text = Ταξινόμηση:
login-list-name-option = Όνομα (Α-Ω)
login-list-name-reverse-option = Όνομα (Ω-Α)
login-list-username-option = Όνομα χρήστη (Α-Ω)
login-list-username-reverse-option = Όνομα χρήστη (Ω-Α)
about-logins-login-list-alerts-option = Ειδοποιήσεις
login-list-last-changed-option = Τελευταία αλλαγή
login-list-last-used-option = Τελευταία χρήση
login-list-intro-title = Δεν βρέθηκαν συνδέσεις
login-list-intro-description = Οι κωδικοί πρόσβασης που αποθηκεύετε στο { -brand-product-name } θα εμφανίζονται εδώ.
about-logins-login-list-empty-search-title = Δεν βρέθηκαν συνδέσεις
about-logins-login-list-empty-search-description = Δεν βρέθηκαν αποτελέσματα για την αναζήτησή σας.
login-list-item-title-new-login = Νέα σύνδεση
login-list-item-subtitle-new-login = Εισαγάγετε τα διαπιστευτήριά σας
login-list-item-subtitle-missing-username = (χωρίς όνομα χρήστη)
about-logins-list-item-breach-icon =
    .title = Παραβιασμένος ιστότοπος
about-logins-list-item-vulnerable-password-icon =
    .title = Ευάλωτος κωδικός πρόσβασης

about-logins-list-section-breach = Παραβιασμένοι ιστότοποι
about-logins-list-section-vulnerable = Ευάλωτοι κωδικοί πρόσβασης
about-logins-list-section-nothing = Καμία ειδοποίηση
about-logins-list-section-today = Σήμερα
about-logins-list-section-yesterday = Χθες
about-logins-list-section-week = Τελευταίες 7 ημέρες

## Introduction screen

about-logins-login-intro-heading-logged-out2 = Ψάχνετε τις αποθηκευμένες συνδέσεις σας; Ενεργοποιήστε τον συγχρονισμό ή εισάγετέ τες.
about-logins-login-intro-heading-logged-in = Δεν βρέθηκαν συγχρονισμένες συνδέσεις.
login-intro-description = Αν αποθηκεύσατε τις συνδέσεις σας στο { -brand-product-name } άλλης συσκευής, μπορείτε να τις μεταφέρετε εδώ ως εξής:
login-intro-instructions-fxa = Στη συσκευή όπου έχουν αποθηκευτεί οι συνδέσεις σας, δημιουργήστε ή συνδεθείτε στον { -fxaccount-brand-name(case: "acc", capitalization: "lower") } σας.
login-intro-instructions-fxa-settings = Μεταβείτε στις Ρυθμίσεις > Συγχρονισμός > Ενεργοποίηση συγχρονισμού… Επιλέξτε «Συνδέσεις και κωδικοί πρόσβασης».
login-intro-instructions-fxa-help = Επισκεφθείτε την <a data-l10n-name="help-link">Υποστήριξη { -lockwise-brand-short-name }</a> για περισσότερη βοήθεια.
about-logins-intro-import = Αν οι συνδέσεις σας είναι αποθηκευμένες σε άλλο πρόγραμμα περιήγησης, μπορείτε να <a data-l10n-name="import-link">τις εισαγάγετε στο { -lockwise-brand-short-name }</a>
about-logins-intro-import2 = Εάν οι συνδέσεις σας αποθηκεύονται εκτός του { -brand-product-name }, μπορείτε να τις <a data-l10n-name="import-browser-link">εισαγάγετε από άλλο πρόγραμμα περιήγησης</a> ή <a data-l10n-name="import-file-link">από κάποιο αρχείο</a>

## Login

login-item-new-login-title = Δημιουργία νέας σύνδεσης
login-item-edit-button = Επεξεργασία
about-logins-login-item-remove-button = Αφαίρεση
login-item-origin-label = Διεύθυνση ιστοτόπου
login-item-tooltip-message = Βεβαιωθείτε ότι ταιριάζει ακριβώς με τη διεύθυνση του ιστότοπου όπου συνδέεστε.
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Όνομα χρήστη
about-logins-login-item-username =
    .placeholder = (χωρίς όνομα χρήστη)
login-item-copy-username-button-text = Αντιγραφή
login-item-copied-username-button-text = Αντιγράφηκε!
login-item-password-label = Κωδικός πρόσβασης
login-item-password-reveal-checkbox =
    .aria-label = Εμφάνιση κωδικού πρόσβασης
login-item-copy-password-button-text = Αντιγραφή
login-item-copied-password-button-text = Αντιγράφηκε!
login-item-save-changes-button = Αποθήκευση αλλαγών
login-item-save-new-button = Αποθήκευση
login-item-cancel-button = Ακύρωση
login-item-time-changed = Τελευταία αλλαγή: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Δημιουργία: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Τελευταία χρήση: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Waterfox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Για να επεξεργαστείτε τη σύνδεσή σας, εισαγάγετε τα διαπιστευτήρια σύνδεσης των Windows. Αυτό συμβάλλει στην προστασία των λογαριασμών σας.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = επεξεργαστεί την αποθηκευμένη σύνδεση

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Για να δείτε τον κωδικό πρόσβασής σας, εισαγάγετε τα διαπιστευτήρια σύνδεσης των Windows. Αυτό συμβάλλει στην προστασία των λογαριασμών σας.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = αποκαλύψει τον αποθηκευμένο κωδικό πρόσβασης

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Για να αντιγράψετε τον κωδικό πρόσβασής σας, εισαγάγετε τα διαπιστευτήρια σύνδεσης των Windows. Αυτό συμβάλλει στην προστασία των λογαριασμών σας.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = αντιγράψει τον αποθηκευμένο κωδικό πρόσβασης

## Master Password notification

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Για να εξαγάγετε τις συνδέσεις σας, εισαγάγετε τα διαπιστευτήρια σύνδεσης των Windows. Αυτό συμβάλλει στην προστασία των λογαριασμών σας.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = εξαγάγει αποθηκευμένες συνδέσεις και κωδικούς πρόσβασης

## Primary Password notification

about-logins-primary-password-notification-message = Παρακαλώ εισαγάγετε τον κύριο κωδικό πρόσβασής σας για να δείτε τις αποθηκευμένες συνδέσεις & κωδικούς πρόσβασης
master-password-reload-button =
    .label = Σύνδεση
    .accesskey = Σ

## Password Sync notification

## Dialogs

confirmation-dialog-cancel-button = Ακύρωση
confirmation-dialog-dismiss-button =
    .title = Ακύρωση

about-logins-confirm-remove-dialog-title = Αφαίρεση σύνδεσης;
confirm-delete-dialog-message = Δεν είναι δυνατή η αναίρεση αυτής της ενέργειας.
about-logins-confirm-remove-dialog-confirm-button = Αφαίρεση

about-logins-confirm-remove-all-dialog-confirm-button-label =
    { $count ->
        [1] Αφαίρεση
       *[other] Αφαίρεση όλων
    }

about-logins-confirm-remove-all-dialog-checkbox-label =
    { $count ->
        [1] Ναι, αφαίρεση σύνδεσης
       *[other] Ναι, αφαίρεση συνδέσεων
    }

about-logins-confirm-remove-all-dialog-title =
    { $count ->
        [one] Αφαίρεση { $count } σύνδεσης;
       *[other] Αφαίρεση και των { $count } συνδέσεων;
    }
about-logins-confirm-remove-all-dialog-message =
    { $count ->
        [1] Θα γίνει διαγραφή της σύνδεσης που έχετε αποθηκεύσει στο { -brand-short-name }, καθώς και όλων των ειδοποιήσεων παραβίασης που εμφανίζονται εδώ. Δεν είναι δυνατή η αναίρεση αυτής της ενέργειας.
       *[other] Θα γίνει διαγραφή των συνδέσεων που έχετε αποθηκεύσει στο { -brand-short-name }, καθώς και όλων των ειδοποιήσεων παραβίασης που εμφανίζονται εδώ. Δεν είναι δυνατή η αναίρεση αυτής της ενέργειας.
    }

about-logins-confirm-remove-all-sync-dialog-title =
    { $count ->
        [one] Αφαίρεση { $count } σύνδεσης από όλες τις συσκευές;
       *[other] Αφαίρεση και των { $count } συνδέσεων από όλες τις συσκευές;
    }
about-logins-confirm-remove-all-sync-dialog-message =
    { $count ->
        [1] Θα γίνει διαγραφή της σύνδεσης που έχετε αποθηκεύσει στο { -brand-short-name } σε όλες τις συγχρονισμένες συσκευές του { -fxaccount-brand-name(case: "gen", capitalization: "lower") } σας. Θα αφαιρεθούν επίσης και όλες οι ειδοποιήσεις παραβίασης που εμφανίζονται εδώ. Δεν είναι δυνατή η αναίρεση αυτής της ενέργειας.
       *[other] Θα γίνει διαγραφή των συνδέσεων που έχετε αποθηκεύσει στο { -brand-short-name } σε όλες τις συγχρονισμένες συσκευές του { -fxaccount-brand-name(case: "gen", capitalization: "lower") } σας. Θα αφαιρεθούν επίσης και όλες οι ειδοποιήσεις παραβίασης που εμφανίζονται εδώ. Δεν είναι δυνατή η αναίρεση αυτής της ενέργειας.
    }

about-logins-confirm-export-dialog-title = Εξαγωγή συνδέσεων και κωδικών πρόσβασης
about-logins-confirm-export-dialog-message = Οι κωδικοί πρόσβασής σας θα αποθηκευτούν ως αναγνώσιμο κείμενο (π.χ. BadP@ssw0rd), επομένως όποιος ανοίξει το αρχείο θα μπορέσει να τους δει.
about-logins-confirm-export-dialog-confirm-button = Εξαγωγή…

about-logins-alert-import-title = Η εισαγωγή ολοκληρώθηκε
about-logins-alert-import-message = Προβολή λεπτομερούς περίληψης εισαγωγής

confirm-discard-changes-dialog-title = Απόρριψη μη αποθηκευμένων αλλαγών;
confirm-discard-changes-dialog-message = Όλες οι μη αποθηκευμένες αλλαγές θα χαθούν.
confirm-discard-changes-dialog-confirm-button = Απόρριψη

## Breach Alert notification

about-logins-breach-alert-title = Παραβίαση ιστοτόπου
breach-alert-text = Από την τελευταία φορά που αλλάξατε τα στοιχεία σύνδεσής σας σε αυτόν τον ιστότοπο, έχουν υπάρξει περιπτώσεις διαρροής ή κλοπής κωδικών. Για να προστατεύσετε το λογαριασμό σας, αλλάξτε τον κωδικό σας.
about-logins-breach-alert-date = Η παραβίαση συνέβη στις { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Μετάβαση στο { $hostname }
about-logins-breach-alert-learn-more-link = Μάθετε περισσότερα

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Ευάλωτος κωδικός πρόσβασης
about-logins-vulnerable-alert-text2 = Αυτός ο κωδικός πρόσβασης έχει χρησιμοποιηθεί σε άλλο λογαριασμό με πιθανή παραβίαση δεδομένων. Η επαναχρησιμοποίηση διαπιστευτηρίων θέτει σε κίνδυνο όλους τους λογαριασμούς σας. Αλλάξτε αυτόν τον κωδικό πρόσβασης.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Μετάβαση στο { $hostname }
about-logins-vulnerable-alert-learn-more-link = Μάθετε περισσότερα

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Υπάρχει ήδη καταχώρηση για το { $loginTitle } με αυτό το όνομα χρήστη. <a data-l10n-name="duplicate-link">Μετάβαση στην υπάρχουσα καταχώρηση;</a>

# This is a generic error message.
about-logins-error-message-default = Προέκυψε σφάλμα κατά την αποθήκευση του κωδικού πρόσβασης.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Εξαγωγή αρχείου συνδέσεων
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Εξαγωγή
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Έγγραφο CSV
       *[other] Αρχείο CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Εισαγωγή αρχείου συνδέσεων
about-logins-import-file-picker-import-button = Εισαγωγή
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Έγγραφο CSV
       *[other] Αρχείο CSV
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
about-logins-import-file-picker-tsv-filter-title =
    { PLATFORM() ->
        [macos] Έγγραφο TSV
       *[other] Αρχείο TSV
    }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-dialog-title = Η εισαγωγή ολοκληρώθηκε
about-logins-import-dialog-items-added =
    { $count ->
       *[other] <span>Προστέθηκαν νέες συνδέσεις:</span> <span data-l10n-name="count">{ $count }</span>
    }

about-logins-import-dialog-items-modified =
    { $count ->
       *[other] <span>Ενημερώθηκαν υπάρχουσες συνδέσεις:</span> <span data-l10n-name="count">{ $count }</span>
    }

about-logins-import-dialog-items-no-change =
    { $count ->
       *[other] <span>Βρέθηκαν διπλές συνδέσεις:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(δεν έγινε εισαγωγή)</span>
    }
about-logins-import-dialog-items-error =
    { $count ->
       *[other] <span>Σφάλματα:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(δεν έγινε εισαγωγή)</span>
    }
about-logins-import-dialog-done = Τέλος

about-logins-import-dialog-error-title = Σφάλμα εισαγωγής
about-logins-import-dialog-error-conflicting-values-title = Πολλές τιμές σε διένεξη για μια σύνδεση
about-logins-import-dialog-error-conflicting-values-description = Για παράδειγμα: πολλαπλά ονόματα χρήστη, κωδικοί πρόσβασης, URL, κ.λπ. για μια σύνδεση.
about-logins-import-dialog-error-file-format-title = Πρόβλημα μορφής αρχείου
about-logins-import-dialog-error-file-format-description = Σφάλμα ή απουσία κεφαλίδων στήλης. Βεβαιωθείτε ότι το αρχείο περιλαμβάνει στήλες για όνομα χρήστη, κωδικό πρόσβασης και URL.
about-logins-import-dialog-error-file-permission-title = Αδυναμία ανάγνωσης αρχείου
about-logins-import-dialog-error-file-permission-description = Το { -brand-short-name } δεν έχει άδεια ανάγνωσης για το αρχείο. Δοκιμάστε να αλλάξετε τα δικαιώματα του αρχείου.
about-logins-import-dialog-error-unable-to-read-title = Αδυναμία ανάλυσης αρχείου
about-logins-import-dialog-error-unable-to-read-description = Βεβαιωθείτε ότι έχετε επιλέξει ένα αρχείο CSV ή TSV.
about-logins-import-dialog-error-no-logins-imported = Δεν έγινε εισαγωγή συνδέσεων
about-logins-import-dialog-error-learn-more = Μάθετε περισσότερα
about-logins-import-dialog-error-try-import-again = Εισαγωγή ξανά…
about-logins-import-dialog-error-cancel = Ακύρωση

about-logins-import-report-title = Περίληψη εισαγωγής
about-logins-import-report-description = Εισήχθησαν συνδέσεις και κωδικοί πρόσβασης στο { -brand-short-name }.

#
# Variables:
#  $number (number) - The number of the row
about-logins-import-report-row-index = Σειρά { $number }
about-logins-import-report-row-description-no-change = Διπλότυπο: ακριβής αντιστοίχιση υπαρχουσών συνδέσεων
about-logins-import-report-row-description-modified = Η υπάρχουσα σύνδεση ενημερώθηκε
about-logins-import-report-row-description-added = Προστέθηκε νέα σύνδεση
about-logins-import-report-row-description-error = Σφάλμα: Απουσία πεδίου

##
## Variables:
##  $field (String) - The name of the field from the CSV file for example url, username or password

about-logins-import-report-row-description-error-multiple-values = Σφάλμα: Πολλαπλές τιμές για το { $field }
about-logins-import-report-row-description-error-missing-field = Σφάλμα: Απουσία πεδίου "{ $field }"

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-report-added =
    { $count ->
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">νέες συνδέσεις προστέθηκαν</div>
    }
about-logins-import-report-modified =
    { $count ->
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">συνδέσεις ενημερώθηκαν</div>
    }
about-logins-import-report-no-change =
    { $count ->
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">διπλότυπες συνδέσεις</div> <div data-l10n-name="not-imported">(δεν έγινε εισαγωγή)</div>
    }
about-logins-import-report-error =
    { $count ->
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">σφάλματα</div> <div data-l10n-name="not-imported">(δεν έγινε εισαγωγή)</div>
    }

## Logins import report page

about-logins-import-report-page-title = Περιληπτική αναφορά εισαγωγής
