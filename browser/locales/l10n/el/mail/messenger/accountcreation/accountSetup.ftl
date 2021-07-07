# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-setup-tab-title = Ρύθμιση λογαριασμού

## Header

account-setup-title = Ρύθμιση υπάρχουσας διεύθυνσης email
account-setup-description = Για να χρησιμοποιήσετε την υπάρχουσα διεύθυνση email σας, συμπληρώστε τα διαπιστευτήριά σας.
account-setup-secondary-description = Το { -brand-product-name } θα αναζητήσει αυτόματα για τις λειτουργικές και προτεινόμενες ρυθμίσεις διακομιστή.
account-setup-success-title = Επιτυχής δημιουργία λογαριασμού
account-setup-success-description = Μπορείτε πλέον να χρησιμοποιήσετε αυτόν τον λογαριασμό με το { -brand-short-name }.
account-setup-success-secondary-description = Μπορείτε να βελτιώσετε την εμπειρία σας συνδέοντας σχετικές υπηρεσίες και διαμορφώνοντας τις σύνθετες ρυθμίσεις λογαριασμού.

## Form fields

account-setup-name-label = Το ονοματεπώνυμό σας
    .accesskey = ο
# Note: "John Doe" is a multiple-use name that is used when the true name of a person is unknown. We use this fake name as an input placeholder. Translators should update this to reflect the placeholder name of their language/country.
account-setup-name-input =
    .placeholder = Ονοματεπώνυμο
account-setup-name-info-icon =
    .title = Το όνομά σας, όπως θα εμφανίζεται σε τρίτους
account-setup-name-warning-icon =
    .title = Παρακαλώ εισαγάγετε το όνομά σας
account-setup-email-label = Διεύθυνση email
    .accesskey = Δ
account-setup-email-input =
    .placeholder = onomateponimo@example.com
account-setup-email-info-icon =
    .title = Η υπάρχουσα διεύθυνση email σας
account-setup-email-warning-icon =
    .title = Μη έγκυρη διεύθυνση email
account-setup-password-label = Κωδικός πρόσβασης
    .accesskey = Κ
    .title = Προαιρετικό, θα χρησιμοποιηθεί μόνο για την επαλήθευση του ονόματος χρήστη
account-provisioner-button = Απόκτηση νέας διεύθυνσης email
    .accesskey = Α
account-setup-password-toggle =
    .title = Εμφάνιση/απόκρυψη του κωδικού πρόσβασης
account-setup-password-toggle-show =
    .title = Εμφάνιση κωδικού πρόσβασης σε κείμενο
account-setup-password-toggle-hide =
    .title = Απόκρυψη κωδικού πρόσβασης
account-setup-remember-password = Απομνημόνευση κωδικού πρόσβασης
    .accesskey = Α
account-setup-exchange-label = Η σύνδεσή σας
    .accesskey = σ
#   YOURDOMAIN refers to the Windows domain in ActiveDirectory. yourusername refers to the user's account name in Windows.
account-setup-exchange-input =
    .placeholder = DOMAIN\όνομαχρήστη
#   Domain refers to the Windows domain in ActiveDirectory. We mean the user's login in Windows at the local corporate network.
account-setup-exchange-info-icon =
    .title = Σύνδεση σε τομέα

## Action buttons

account-setup-button-cancel = Ακύρωση
    .accesskey = Α
account-setup-button-manual-config = Χειροκίνητη ρύθμιση
    .accesskey = ρ
account-setup-button-stop = Διακοπή
    .accesskey = Δ
account-setup-button-retest = Δοκιμή ξανά
    .accesskey = ξ
account-setup-button-continue = Συνέχεια
    .accesskey = Σ
account-setup-button-done = Τέλος
    .accesskey = Τ

## Notifications

account-setup-looking-up-settings = Αναζήτηση ρυθμίσεων παραμέτρων…
account-setup-looking-up-settings-guess = Αναζήτηση ρυθμίσεων: Δοκιμή κοινών ονομάτων διακομιστών…
account-setup-looking-up-settings-half-manual = Αναζήτηση ρυθμίσεων: Έλεγχος διακομιστή…
account-setup-looking-up-disk = Αναζήτηση ρυθμίσεων: εγκατάσταση του { -brand-short-name }…
account-setup-looking-up-isp = Αναζήτηση ρυθμίσεων: Πάροχος ηλεκτρονικού ταχυδρομείου…
# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-looking-up-db = Αναζήτηση ρυθμίσεων: Βάση δεδομένων Waterfox ISP…
account-setup-looking-up-mx = Αναζήτηση ρυθμίσεων: Τομέας εισερχόμενης αλληλογραφίας…
account-setup-looking-up-exchange = Αναζήτηση ρυθμίσεων: Διακομιστής Exchange…
account-setup-checking-password = Έλεγχος κωδικού πρόσβασης…
account-setup-installing-addon = Λήψη και εγκατάσταση του προσθέτου…
account-setup-success-half-manual = Κατά τον έλεγχο του διακομιστή εντοπίστηκαν οι παρακάτω ρυθμίσεις:
account-setup-success-guess = Ρυθμίσεις που βρέθηκαν κατά τη δοκιμή των κοινών ονομάτων.
account-setup-success-guess-offline = Είστε εκτός σύνδεσης. Μαντέψαμε ορισμένες ρυθμίσεις αλλά θα χρειαστεί να εισαγάγετε τις σωστές.
account-setup-success-password = Ο κωδικός πρόσβασης είναι εντάξει
account-setup-success-addon = Το πρόσθετο εγκαταστάθηκε επιτυχώς
# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-success-settings-db = Βρέθηκε ρύθμιση στην βάση δεδομένων του Waterfox ISP.
account-setup-success-settings-disk = Βρέθηκε ρύθμιση στην εγκατάσταση του { -brand-short-name }.
account-setup-success-settings-isp = Βρέθηκε ρύθμιση στον πάροχο ηλεκτρονικού ταχυδρομείου.
# Note: Microsoft Exchange is a product name.
account-setup-success-settings-exchange = Βρέθηκε ρύθμιση για τον διακομιστή Microsoft Exchange.

## Illustrations

account-setup-step1-image =
    .title = Αρχική ρύθμιση
account-setup-step2-image =
    .title = Φόρτωση…
account-setup-step3-image =
    .title = Βρέθηκε ρύθμιση
account-setup-step4-image =
    .title = Σφάλμα σύνδεσης
account-setup-step5-image =
    .title = Ο λογαριασμός δημιουργήθηκε
account-setup-privacy-footnote2 = Τα διαπιστευτήριά σας θα αποθηκευτούν μόνο τοπικά, στον υπολογιστή σας.
account-setup-selection-help = Δεν ξέρετε τι να επιλέξετε;
account-setup-selection-error = Χρειάζεστε βοήθεια;
account-setup-success-help = Δεν γνωρίζετε σίγουρα τα επόμενα βήματα;
account-setup-documentation-help = Τεκμηρίωση ρύθμισης
account-setup-forum-help = Φόρουμ υποστήριξης
account-setup-privacy-help = Πολιτική απορρήτου
account-setup-getting-started = Ξεκινώντας

## Results area

# Variables:
#  $count (Number) - Number of available protocols.
account-setup-results-area-title =
    { $count ->
        [one] Διαθέσιμη ρύθμιση
       *[other] Διαθέσιμες ρυθμίσεις
    }
# Note: IMAP is the name of a protocol.
account-setup-result-imap = IMAP
account-setup-result-imap-description = Διατηρήστε συγχρονισμένους τους φακέλους και τα email σας με τον διακομιστή σας
# Note: POP3 is the name of a protocol.
account-setup-result-pop = POP3
account-setup-result-pop-description = Διατηρήστε τους φακέλους και τα email σας στον υπολογιστή σας
# Note: Exchange is the name of a product.
account-setup-result-exchange = Exchange
# Note: Exchange, Office365 are the name of products.
account-setup-result-exchange2-description = Χρησιμοποιήστε τον διακομιστή Microsoft Exchange ή τις υπηρεσίες cloud του Office365
account-setup-incoming-title = Εισερχόμενα
account-setup-outgoing-title = Εξερχόμενα
account-setup-username-title = Όνομα χρήστη
account-setup-exchange-title = Διακομιστής
account-setup-result-smtp = SMTP
account-setup-result-no-encryption = Χωρίς κρυπτογράφηση
account-setup-result-ssl = SSL/TLS
account-setup-result-starttls = STARTTLS
account-setup-result-outgoing-existing = Χρήση υπάρχοντος διακομιστή SMTP εξερχομένων
# Variables:
#  $incoming (String): The email/username used to log into the incoming server
#  $outgoing (String): The email/username used to log into the outgoing server
account-setup-result-username-different = Εισερχόμενα: { $incoming }, Εξερχόμενα: { $outgoing }

## Error messages

# Note: The reference to "janedoe" (Jane Doe) is the name of an example person. You will want to translate it to whatever example persons would be named in your language. In the example, AD is the name of the Windows domain, and this should usually not be translated.
account-setup-credentials-incomplete = Η αυθεντικοποίηση απέτυχε. Είτε τα διαπιστευτήρια που εισαγάγατε είναι λάθος είτε απαιτείται ξεχωριστό όνομα χρήστη για είσοδο. Το όνομα χρήστη συνήθως είναι το όνομα χρήστη για τον τομέα στα Windows, με ή χωρίς το όνομα τομέα (για παράδειγμα janedoe ή AD\\janedoe).
account-setup-credentials-wrong = Η αυθεντικοποίηση απέτυχε. Παρακαλούμε ελέγξτε το όνομα χρήστη και τον κωδικό πρόσβασης
account-setup-find-settings-failed = Το { -brand-short-name } απέτυχε να εντοπίσει τις ρυθμίσεις του λογαριασμού ηλεκτρονικής αλληλογραφίας σας
account-setup-exchange-config-unverifiable = Δεν ήταν δυνατή η επαλήθευση των ρυθμίσεων παραμέτρων. Αν το όνομα χρήστη και ο κωδικός πρόσβασής σας είναι σωστά, ο διαχειριστής του διακομιστή ενδέχεται να έχει απενεργοποιήσει τις επιλεγμένες ρυθμίσεις παραμέτρων για τον λογαριασμό σας. Δοκιμάστε να επιλέξετε άλλο πρωτόκολλο.

## Manual configuration area

account-setup-manual-config-title = Ρυθμίσεις διακομιστή
account-setup-incoming-server-legend = Διακομιστής εισερχομένων
account-setup-protocol-label = Πρωτόκολλο:
protocol-imap-option = { account-setup-result-imap }
protocol-pop-option = { account-setup-result-pop }
protocol-exchange-option = { account-setup-result-exchange }
account-setup-hostname-label = Όνομα υπολογιστή:
account-setup-port-label = Θύρα:
    .title = Ορίστε τον αριθμό θύρας σε 0 για αυτόματη ανίχνευση
account-setup-auto-description = Το { -brand-short-name } θα προσπαθήσει να εντοπίσει αυτόματα τα πεδία που παραμένουν κενά.
account-setup-ssl-label = Ασφάλεια σύνδεσης:
account-setup-outgoing-server-legend = Διακομιστής εξερχομένων

## Incoming/Outgoing SSL Authentication options

ssl-autodetect-option = Αυτόματος εντοπισμός
ssl-no-authentication-option = Χωρίς ταυτοποίηση
ssl-cleartext-password-option = Κανονικός κωδικός πρόσβασης
ssl-encrypted-password-option = Κρυπτογραφημένος κωδικός πρόσβασης

## Incoming/Outgoing SSL options

ssl-noencryption-option = Κανένα
account-setup-auth-label = Μέθοδος ταυτοποίησης:
account-setup-username-label = Όνομα χρήστη:
account-setup-advanced-setup-button = Σύνθετη διαμόρφωση
    .accesskey = Σ

## Warning insecure server dialog

account-setup-insecure-title = Προειδοποίηση!
account-setup-insecure-incoming-title = Ρυθμίσεις εισερχομένων:
account-setup-insecure-outgoing-title = Ρυθμίσεις εξερχομένων:
# Variables:
#  $server (String): The name of the hostname of the server the user was trying to connect to.
account-setup-warning-cleartext = Το <b>{ $server }</b> δεν χρησιμοποιεί κρυπτογράφηση.
account-setup-warning-cleartext-details = Οι επισφαλείς διακομιστές αλληλογραφίας δεν χρησιμοποιούν κρυπτογραφημένες συνδέσεις για την προστασία των κωδικών πρόσβασης και των προσωπικών σας πληροφοριών. Αν συνδεθείτε σε αυτό τον διακομιστή, οι κωδικοί πρόσβασης και οι προσωπικές σας πληροφορίες ενδέχεται να εκτεθούν.
account-setup-insecure-server-checkbox = Κατανοώ τους κινδύνους
    .accesskey = τ
account-setup-insecure-description = Το { -brand-short-name } σάς επιτρέπει να κάνετε λήψη των email σας με τις παρεχόμενες ρυθμίσεις. Ωστόσο, θα πρέπει να επικοινωνήσετε με τον διαχειριστή του συστήματος ή τον πάροχο ηλεκτρονικού ταχυδρομείου σας σχετικά με αυτές τις ασυνήθιστες συνδέσεις. Δείτε τις <a data-l10n-name="thunderbird-faq-link">συχνές ερωτήσεις του Thunderbird</a> για περισσότερες πληροφορίες.
insecure-dialog-cancel-button = Αλλαγή ρυθμίσεων
    .accesskey = ρ
insecure-dialog-confirm-button = Επιβεβαίωση
    .accesskey = Ε

## Warning Exchange confirmation dialog

# Variables:
#  $domain (String): The name of the server where the configuration was found, e.g. rackspace.com.
exchange-dialog-question = Το { -brand-short-name } βρήκε τις πληροφορίες ρύθμισης του λογαριασμού σας στο { $domain }. Θέλετε να συνεχίσετε και να υποβάλετε τα διαπιστευτήριά σας;
exchange-dialog-confirm-button = Σύνδεση
exchange-dialog-cancel-button = Ακύρωση

## Dismiss account creation dialog

exit-dialog-title = Δεν έχουν ρυθμιστεί λογαριασμοί email
exit-dialog-description = Θέλετε σίγουρα να ακυρώσετε τη διαδικασία ρύθμισης; Το { -brand-short-name } μπορεί να χρησιμοποιηθεί ακόμα και χωρίς λογαριασμό email, αλλά πολλές λειτουργίες δεν θα είναι διαθέσιμες.
account-setup-no-account-checkbox = Χρήση του { -brand-short-name } χωρίς λογαριασμό email
    .accesskey = Χ
exit-dialog-cancel-button = Συνέχεια ρύθμισης
    .accesskey = Σ
exit-dialog-confirm-button = Κλείσιμο ρύθμισης
    .accesskey = Κ

## Alert dialogs

account-setup-creation-error-title = Σφάλμα δημιουργίας λογαριασμού
account-setup-error-server-exists = Ο διακομιστής εισερχομένων υπάρχει ήδη.
account-setup-confirm-advanced-title = Επιβεβαίωση σύνθετων ρυθμίσεων
account-setup-confirm-advanced-description = Αυτό το παράθυρο διαλόγου θα κλείσει και θα δημιουργηθεί ένας λογαριασμός με τις τρέχουσες ρυθμίσεις, ακόμη και αν η ρύθμιση παραμέτρων είναι εσφαλμένη. Θέλετε να συνεχίσετε;

## Addon installation section

account-setup-addon-install-title = Εγκατάσταση
account-setup-addon-install-intro = Ένα πρόσθετο τρίτου μπορεί να σας επιτρέψει την πρόσβαση στον λογαριασμό email σας σε αυτό τον διακομιστή:
account-setup-addon-no-protocol = Αυτός ο διακομιστής email δυστυχώς δεν υποστηρίζει ανοικτά πρωτόκολλα. { account-setup-addon-install-intro }

## Success view

account-setup-settings-button = Ρυθμίσεις λογαριασμού
account-setup-encryption-button = Διατερματική κρυπτογράφηση
account-setup-signature-button = Προσθήκη υπογραφής
account-setup-dictionaries-button = Λήψη λεξικών
account-setup-address-book-carddav-button = Σύνδεση σε ευρετήριο CardDAV
account-setup-address-book-ldap-button = Σύνδεση σε ευρετήριο LDAP
account-setup-calendar-button = Σύνδεση σε απομακρυσμένο ημερολόγιο
account-setup-linked-services-title = Σύνδεση σχετικών υπηρεσιών
account-setup-linked-services-description = Το { -brand-short-name } ανίχνευσε άλλες συνδεδεμένες υπηρεσίες στον λογαριασμό email σας.
account-setup-no-linked-description = Ρυθμίστε άλλες υπηρεσίες για να αξιοποιήσετε στο έπακρο το { -brand-short-name } σας.
# Variables:
# $count (Number) - The number of address books found during autoconfig.
account-setup-found-address-books-description =
    { $count ->
        [one] Το { -brand-short-name } βρήκε ένα συνδεδεμένο ευρετήριο στον λογαριασμό email σας.
       *[other] Το { -brand-short-name } βρήκε { $count } συνδεδεμένα ευρετήρια στον λογαριασμό email σας.
    }
# Variables:
# $count (Number) - The number of calendars found during autoconfig.
account-setup-found-calendars-description =
    { $count ->
        [one] Το { -brand-short-name } βρήκε ένα συνδεδεμένο ημερολόγιο στον λογαριασμό email σας.
       *[other] Το { -brand-short-name } βρήκε { $count } συνδεδεμένα ημερολόγιο στον λογαριασμό email σας.
    }
account-setup-button-finish = Τέλος
    .accesskey = Τ
account-setup-looking-up-address-books = Αναζήτηση ευρετηρίων…
account-setup-looking-up-calendars = Αναζήτηση ημερολογίων…
account-setup-address-books-button = Ευρετήρια
account-setup-calendars-button = Ημερολόγια
account-setup-connect-link = Σύνδεση
account-setup-existing-address-book = Συνδεδεμένο
    .title = Το ευρετήριο έχει ήδη συνδεθεί
account-setup-existing-calendar = Συνδεδεμένο
    .title = Το ημερολόγιο έχει ήδη συνδεθεί
account-setup-connect-all-calendars = Σύνδεση όλων των ημερολογίων
account-setup-connect-all-address-books = Σύνδεση όλων των ευρετηρίων

## Calendar synchronization dialog

calendar-dialog-title = Σύνδεση ημερολογίου
calendar-dialog-cancel-button = Ακύρωση
    .accesskey = Α
calendar-dialog-confirm-button = Σύνδεση
    .accesskey = ν
account-setup-calendar-name-label = Όνομα
account-setup-calendar-name-input =
    .placeholder = Το ημερολόγιό μου
account-setup-calendar-color-label = Χρώμα
account-setup-calendar-refresh-label = Ανανέωση
account-setup-calendar-refresh-manual = Χειροκίνητα
account-setup-calendar-refresh-interval =
    { $count ->
        [one] Κάθε λεπτό
       *[other] Κάθε { $count } λεπτά
    }
account-setup-calendar-read-only = Μόνο για ανάγνωση
    .accesskey = Μ
account-setup-calendar-show-reminders = Εμφάνιση υπενθυμίσεων
    .accesskey = Ε
account-setup-calendar-offline-support = Υποστήριξη εκτός σύνδεσης
    .accesskey = Υ
