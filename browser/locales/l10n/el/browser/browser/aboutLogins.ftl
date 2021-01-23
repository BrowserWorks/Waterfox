# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Συνδέσεις & κωδικοί πρόσβασης

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Πάρτε τους κωδικούς πρόσβασής σας παντού
login-app-promo-subtitle = Αποκτήστε δωρεάν την εφαρμογή { -lockwise-brand-name }
login-app-promo-android =
    .alt = Λήψη στο Google Play
login-app-promo-apple =
    .alt = Λήψη στο App Store
login-filter =
    .placeholder = Αναζήτηση συνδέσεων
create-login-button = Δημιουργία νέας σύνδεσης
fxaccounts-sign-in-text = Αποκτήστε πρόσβαση στους κωδικούς πρόσβασής σας από άλλες συσκευές
fxaccounts-sign-in-button = Σύνδεση στο { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = Διαχείριση λογαριασμού

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Άνοιγμα μενού
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Εισαγωγή από άλλο πρόγρ. περιήγησης…
about-logins-menu-menuitem-import-from-a-file = Εισαγωγή από αρχείο…
about-logins-menu-menuitem-export-logins = Εξαγωγή συνδέσεων…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Επιλογές
       *[other] Προτιμήσεις
    }
about-logins-menu-menuitem-help = Βοήθεια
menu-menuitem-android-app = { -lockwise-brand-short-name } για Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } για iPhone και iPad

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
about-logins-login-list-alerts-option = Ειδοποιήσεις
login-list-last-changed-option = Τελευταία αλλαγή
login-list-last-used-option = Τελευταία χρήση
login-list-intro-title = Δεν βρέθηκαν συνδέσεις
login-list-intro-description = Όταν αποθηκεύετε έναν κωδικό στο { -brand-product-name }, θα εμφανίζεται εδώ.
about-logins-login-list-empty-search-title = Δεν βρέθηκαν συνδέσεις
about-logins-login-list-empty-search-description = Δεν βρέθηκαν αποτελέσματα για την αναζήτησή σας.
login-list-item-title-new-login = Νέα σύνδεση
login-list-item-subtitle-new-login = Εισαγάγετε τα διαπιστευτήριά σας
login-list-item-subtitle-missing-username = (χωρίς όνομα χρήστη)
about-logins-list-item-breach-icon =
    .title = Παραβιασμένη ιστοσελίδα
about-logins-list-item-vulnerable-password-icon =
    .title = Ευάλωτος κωδικός πρόσβασης

## Introduction screen

login-intro-heading = Ψάχνετε τις αποθηκευμένες συνδέσεις σας; Ρυθμίστε το { -sync-brand-short-name }.
about-logins-login-intro-heading-logged-out = Ψάχνετε τις αποθηκευμένες συνδέσεις σας; Ρυθμίστε το { -sync-brand-short-name } ή εισάγετέ τις.
about-logins-login-intro-heading-logged-in = Δεν βρέθηκαν συγχρονισμένες συνδέσεις.
login-intro-description = Αν αποθηκεύσατε τις συνδέσεις σας στο { -brand-product-name } σε άλλη συσκευή, ορίστε πώς μπορείτε να τις μεταφέρετε εδώ:
login-intro-instruction-fxa = Στη συσκευή όπου έχουν αποθηκευτεί οι συνδέσεις σας, δημιουργήστε λογαριασμό ή συνδεθείτε στο { -fxaccount-brand-name }
login-intro-instruction-fxa-settings = Στις Ρυθμίσεις του { -sync-brand-short-name }, φροντίστε να επιλέξετε το κουτάκι Συνδέσεις.
about-logins-intro-instruction-help = Αν χρειάζεστε περισσότερη βοήθεια, επισκεφτείτε την ενότητα <a data-l10n-name="help-link">Υποστήριξη { -lockwise-brand-short-name }</a>
about-logins-intro-import = Αν οι συνδέσεις σας είναι αποθηκευμένες σε άλλο πρόγραμμα περιήγησης, μπορείτε να <a data-l10n-name="import-link">τις εισάγετε στο { -lockwise-brand-short-name }</a>
about-logins-intro-import2 = Εάν οι συνδέσεις σας αποθηκεύονται εκτός του { -brand-product-name }, μπορείτε να τις <a data-l10n-name="import-browser-link">εισαγάγετε από άλλο πρόγραμμα περιήγησης</a> ή <a data-l10n-name="import-file-link">από κάποιο αρχείο</a>

## Login

login-item-new-login-title = Δημιουργία νέας σύνδεσης
login-item-edit-button = Επεξεργασία
about-logins-login-item-remove-button = Αφαίρεση
login-item-origin-label = Διεύθυνση ιστοσελίδας
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

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Για να επεξεργαστείτε τη σύνδεσή σας, εισάγετε τα διαπιστευτήρια σύνδεσης των Windows. Αυτό συμβάλλει στην προστασία των λογαριασμών σας.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = επεξεργαστεί την αποθηκευμένη σύνδεση
# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Για να δείτε τον κωδικό πρόσβασής σας, εισάγετε τα διαπιστευτήρια σύνδεσης των Windows. Αυτό συμβάλλει στην προστασία των λογαριασμών σας.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = αποκαλύψει τον αποθηκευμένο κωδικό πρόσβασης
# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Για να αντιγράψετε τον κωδικό πρόσβασής σας, εισάγετε τα διαπιστευτήρια σύνδεσης των Windows. Αυτό συμβάλλει στην προστασία των λογαριασμών σας.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = αντιγράψει τον αποθηκευμένο κωδικό πρόσβασης

## Master Password notification

master-password-notification-message = Παρακαλούμε εισάγετε τον κύριο κωδικό πρόσβασής σας για να δείτε τις αποθηκευμένες συνδέσεις.
# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Για να εξαγάγετε τις συνδέσεις σας, εισάγετε τα διαπιστευτήρια σύνδεσης των Windows. Αυτό συμβάλλει στην προστασία των λογαριασμών σας.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = εξαγάγει αποθηκευμένες συνδέσεις και κωδικούς πρόσβασης

## Primary Password notification

about-logins-primary-password-notification-message = Παρακαλούμε εισάγετε τον κύριο κωδικό πρόσβασής σας για να δείτε τις αποθηκευμένες συνδέσεις & κωδικούς πρόσβασης.
master-password-reload-button =
    .label = Σύνδεση
    .accesskey = Σ

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Θέλετε να βρίσκετε τις συνδέσεις σας όπου κι αν χρησιμοποιείτε το { -brand-product-name }; Αν ναι, πηγαίνετε στις Επιλογές του { -sync-brand-short-name } και επιλέξτε το κουτάκι "Συνδέσεις".
       *[other] Θέλετε να βρίσκετε τις συνδέσεις σας όπου κι αν χρησιμοποιείτε το { -brand-product-name }; Αν ναι, πηγαίνετε στις Προτιμήσεις του { -sync-brand-short-name } και επιλέξτε το κουτάκι "Συνδέσεις".
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Άνοιγμα επιλογών { -sync-brand-short-name }
           *[other] Άνοιγμα προτιμήσεων { -sync-brand-short-name }
        }
    .accesskey = Ά
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Να μην γίνει ξανά ερώτηση
    .accesskey = Ν

## Dialogs

confirmation-dialog-cancel-button = Ακύρωση
confirmation-dialog-dismiss-button =
    .title = Ακύρωση
about-logins-confirm-remove-dialog-title = Αφαίρεση αυτής της σύνδεσης;
confirm-delete-dialog-message = Δεν είναι δυνατή η αναίρεση αυτής της ενέργειας.
about-logins-confirm-remove-dialog-confirm-button = Αφαίρεση
about-logins-confirm-export-dialog-title = Εξαγωγή συνδέσεων και κωδικών πρόσβασης
about-logins-confirm-export-dialog-message = Οι κωδικοί πρόσβασής σας θα αποθηκευτούν ως αναγνώσιμο κείμενο (π.χ. BadP@ssw0rd), επομένως όποιος ανοίξει το αρχείο θα μπορέσει να τους δει.
about-logins-confirm-export-dialog-confirm-button = Εξαγωγή…
confirm-discard-changes-dialog-title = Απόρριψη μη αποθηκευμένων αλλαγών;
confirm-discard-changes-dialog-message = Όλες οι μη αποθηκευμένες αλλαγές θα χαθούν.
confirm-discard-changes-dialog-confirm-button = Απόρριψη

## Breach Alert notification

about-logins-breach-alert-title = Παραβίαση ιστοσελίδας
breach-alert-text = Από την τελευταία φορά που αλλάξατε τα στοιχεία σύνδεσής σας σε αυτόν τον ιστότοπο, έχουν υπάρξει περιπτώσεις διαρροής ή κλοπής κωδικών. Για να προστατεύσετε το λογαριασμό σας, αλλάξτε τον κωδικό σας.
about-logins-breach-alert-date = Η παραβίαση συνέβη στις { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Μετάβαση στο { $hostname }
about-logins-breach-alert-learn-more-link = Μάθετε περισσότερα

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Ευάλωτος κωδικός πρόσβασης
about-logins-vulnerable-alert-text2 = Αυτός ο κωδικός πρόσβασης έχει χρησιμοποιηθεί σε άλλο λογαριασμό με πιθανή παραβίαση δεδομένων. Η επαναχρησιμοποίηση διαπιστευτηρίων θέτει σε κίνδυνο όλους τους λογαριασμούς σας. Αλλάξτε αυτό τον κωδικό πρόσβασης.
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
