# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Προσθήκη προσωπικού κλειδιού OpenPGP για το «{ $identity }»

key-wizard-button =
    .buttonlabelaccept = Συνέχεια
    .buttonlabelhelp = Επιστροφή

key-wizard-warning = <b>Αν διαθέτετε ήδη ένα προσωπικό κλειδί</b> για αυτή τη διεύθυνση email, θα πρέπει να το εισαγάγετε. Διαφορετικά, δεν θα έχετε πρόσβαση στα αρχεία κρυπτογραφημένων email σας, ούτε θα μπορείτε να διαβάζετε εισερχόμενα κρυπτογραφημένα email από άτομα που χρησιμοποιούν το υπάρχον κλειδί σας.

key-wizard-learn-more = Μάθετε περισσότερα

radio-create-key =
    .label = Δημιουργία νέου κλειδιού OpenPGP
    .accesskey = Δ

radio-import-key =
    .label = Εισαγωγή υπάρχοντος κλειδιού OpenPGP
    .accesskey = Ε

radio-gnupg-key =
    .label = Χρήση του εξωτερικού σας κλειδιού μέσω του GnuPG (π.χ. από έξυπνη κάρτα)
    .accesskey = ρ

## Generate key section

openpgp-generate-key-title = Δημιουργία κλειδιού OpenPGP

openpgp-generate-key-info = <b>Η ολοκλήρωση της δημιουργίας κλειδιού ενδέχεται να χρειαστεί αρκετά λεπτά.</b> Μην κλείσετε την εφαρμογή όσο είναι σε εξέλιξη η δημιουργία του κλειδιού. Η ενεργή περιήγηση ή η εκτέλεση εκτενών διαδικασιών που απασχολούν τον δίσκο κατά τη διάρκεια της δημιουργίας του κλειδιού θα γεμίσουν τη «δεξαμενή τυχαιότητας», επιταχύνοντας τη διαδικασία. Θα ενημερωθείτε όταν ολοκληρωθεί η δημιουργία του κλειδιού.

openpgp-keygen-expiry-title = Λήξη κλειδιού

openpgp-keygen-expiry-description = Ορίστε τον χρόνο λήξης του νέου σας κλειδιού. Μπορείτε να αλλάξετε αργότερα την ημερομηνία για να την επεκτείνετε, εφόσον αυτό είναι αναγκαίο.

radio-keygen-expiry =
    .label = Το κλειδί λήγει σε
    .accesskey = ε

radio-keygen-no-expiry =
    .label = Το κλειδί δεν λήγει
    .accesskey = δ

openpgp-keygen-days-label =
    .label = ημέρες
openpgp-keygen-months-label =
    .label = μήνες
openpgp-keygen-years-label =
    .label = έτη

openpgp-keygen-advanced-title = Σύνθετες ρυθμίσεις

openpgp-keygen-advanced-description = Ελέγξτε τις σύνθετες ρυθμίσεις του κλειδιού OpenPGP σας.

openpgp-keygen-keytype =
    .value = Τύπος κλειδιού:
    .accesskey = δ

openpgp-keygen-keysize =
    .value = Μέγεθος κλειδιού:
    .accesskey = κ

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (Elliptic Curve)

openpgp-keygen-button = Δημιουργία κλειδιού

openpgp-keygen-progress-title = Δημιουργία νέου κλειδιού OpenPGP…

openpgp-keygen-import-progress-title = Εισαγωγή κλειδιών OpenPGP…

openpgp-import-success = Επιτυχής εισαγωγή κλειδιών OpenPGP!

openpgp-import-success-title = Ολοκλήρωση διαδικασίας εισαγωγής

openpgp-import-success-description = Για να ξεκινήσετε να χρησιμοποιείτε το εισηγμένο κλειδί OpenPGP για την κρυπτογράφηση email, κλείστε αυτό το παράθυρο διαλόγου και μεταβείτε στις ρυθμίσεις του λογαριασμού σας για να το επιλέξετε.

openpgp-keygen-confirm =
    .label = Επιβεβαίωση

openpgp-keygen-dismiss =
    .label = Ακύρωση

openpgp-keygen-cancel =
    .label = Ακύρωση διαδικασίας…

openpgp-keygen-import-complete =
    .label = Κλείσιμο
    .accesskey = Κ

openpgp-keygen-missing-username = Δεν έχει οριστεί όνομα για τον τρέχοντα λογαριασμό. Παρακαλώ εισαγάγετε μια τιμή στο πεδίο «Το όνομά σας» στις ρυθμίσεις του λογαριασμού.
openpgp-keygen-long-expiry = Δεν μπορείτε να δημιουργήσετε κλειδί που να λήγει σε περισσότερα από 100 χρόνια.
openpgp-keygen-short-expiry = Το κλειδί σας πρέπει να είναι έγκυρο για τουλάχιστον μία ημέρα.

openpgp-keygen-ongoing = Η δημιουργία κλειδιού είναι ήδη σε εξέλιξη!

openpgp-keygen-error-core = Δεν είναι δυνατή η αρχικοποίηση της κύριας υπηρεσίας OpenPGP

openpgp-keygen-error-failed = Η δημιουργία κλειδιού OpenPGP απέτυχε απροσδόκητα

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = Το κλειδί OpenPGP δημιουργήθηκε με επιτυχία, αλλά απέτυχε η ανάκληση του κλειδιού { $key }

openpgp-keygen-abort-title = Ακύρωση δημιουργίας κλειδιού;
openpgp-keygen-abort = Η δημιουργία κλειδιού OpenPGP είναι σε εξέλιξη, θέλετε σίγουρα να την ακυρώσετε;

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Δημιουργία δημόσιου και ιδιωτικού κλειδιού για το «{ $identity }»;

## Import Key section

openpgp-import-key-title = Εισαγωγή υπάρχοντος προσωπικού κλειδιού OpenPGP

openpgp-import-key-legend = Επιλέξτε ένα αντίγραφο ασφαλείας που έχετε δημιουργήσει στο παρελθόν.

openpgp-import-key-description = Μπορείτε να εισαγάγετε προσωπικά κλειδιά που δημιουργήθηκαν με άλλο λογισμικό OpenPGP.

openpgp-import-key-info = Άλλο λογισμικό ενδέχεται να περιγράφει ένα προσωπικό κλειδί χρησιμοποιώντας εναλλακτικούς όρους, όπως το δικό σας κλειδί, μυστικό κλειδί, ιδιωτικό κλειδί ή ζεύγος κλειδιών.

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Το Thunderbird βρήκε ένα κλειδί που μπορεί να εισαχθεί.
       *[other] Το Thunderbird βρήκε { $count } κλειδιά που μπορούν να εισαχθούν.
    }

openpgp-import-key-list-description = Επιβεβαιώστε ποια κλειδιά μπορούν να θεωρηθούν ως προσωπικά. Μόνο τα κλειδιά που δημιουργήσατε εσείς και που δείχνουν τη δική σας ταυτότητα θα πρέπει να χρησιμοποιούνται ως προσωπικά. Μπορείτε να αλλάξετε αυτήν την επιλογή αργότερα στο παράθυρο διαλόγου «Ιδιότητες κλειδιού».

openpgp-import-key-list-caption = Τα κλειδιά που έχουν επισημανθεί ως προσωπικά θα εμφανίζονται στην ενότητα «Διατερματική κρυπτογράφηση». Τα άλλα θα είναι διαθέσιμα στη Διαχείριση κλειδιών.

openpgp-passphrase-prompt-title = Απαιτείται φράση πρόσβασης

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Εισαγάγετε τον κωδικό πρόσβασης για να ξεκλειδώσετε το ακόλουθο κλειδί: { $key }

openpgp-import-key-button =
    .label = Επιλέξτε αρχείο για εισαγωγή…
    .accesskey = Ε

import-key-file = Εισαγωγή αρχείου κλειδιού OpenPGP

import-key-personal-checkbox =
    .label = Χειρισμός κλειδιού ως προσωπικού

gnupg-file = Αρχεία GnuPG

import-error-file-size = <b>Σφάλμα!</b> Δεν υποστηρίζονται αρχεία άνω των 5MB.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Σφάλμα!</b> Αποτυχία εισαγωγής αρχείου. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Σφάλμα!</b> Αποτυχία εισαγωγής κλειδιών. { $error }

openpgp-import-identity-label = Ταυτότητα

openpgp-import-fingerprint-label = Αποτύπωμα

openpgp-import-created-label = Δημιουργήθηκε

openpgp-import-bits-label = Bits

openpgp-import-key-props =
    .label = Ιδιότητες κλειδιού
    .accesskey = Ι

## External Key section

openpgp-external-key-title = Εξωτερικό κλειδί GnuPG

openpgp-external-key-description = Διαμόρφωση εξωτερικού κλειδιού GnuPG με εισαγωγή του ID κλειδιού

openpgp-external-key-info = Επιπλέον, πρέπει να χρησιμοποιήσετε τη Διαχείριση κλειδιών για την εισαγωγή και αποδοχή του αντίστοιχου δημόσιου κλειδιού.

openpgp-external-key-warning = <b>Μπορείτε να ρυθμίσετε μόνο ένα εξωτερικό κλειδί GnuPG.</b> Η προηγούμενή σας καταχώρηση θα αντικατασταθεί.

openpgp-save-external-button = Αποθήκευση ID κλειδιού

openpgp-external-key-label = ID μυστικού κλειδιού:

openpgp-external-key-input =
    .placeholder = 123456789341298340
