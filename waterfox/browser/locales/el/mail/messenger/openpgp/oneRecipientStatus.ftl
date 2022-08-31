# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-one-recipient-status-title =
    .title = Ασφάλεια μηνύματος OpenPGP
openpgp-one-recipient-status-status =
    .label = Κατάσταση
openpgp-one-recipient-status-key-id =
    .label = ID κλειδιού
openpgp-one-recipient-status-created-date =
    .label = Δημιουργήθηκε
openpgp-one-recipient-status-expires-date =
    .label = Λήξη
openpgp-one-recipient-status-open-details =
    .label = Άνοιγμα λεπτομερειών και επεξεργασία αποδοχής…
openpgp-one-recipient-status-discover =
    .label = Ανακαλύψτε νέα ή ενημερωμένα κλειδιά
openpgp-one-recipient-status-instruction1 = Για να στείλετε ένα διατερματικά κρυπτογραφημένο μήνυμα σε έναν παραλήπτη, πρέπει να αποκτήσετε το δημόσιο κλειδί OpenPGP του και να το επισημάνετε ως αποδεκτό.
openpgp-one-recipient-status-instruction2 = Για να αποκτήσετε το δημόσιο κλειδί του, εισαγάγετέ το από ένα email που σας έχει στείλει, το οποίο θα πρέπει να περιέχει το κλειδί. Εναλλακτικά, μπορείτε να ψάξετε το δημόσιο κλειδί του σε έναν κατάλογο.
openpgp-key-own = Αποδεκτό (προσωπικό κλειδί)
openpgp-key-secret-not-personal = Μη χρησιμοποιήσιμο
openpgp-key-verified = Αποδεκτό (επαληθευμένο)
openpgp-key-unverified = Αποδεκτό (μη επαληθευμένο)
openpgp-key-undecided = Μη αποδεκτό (χωρίς απόφαση)
openpgp-key-rejected = Μη αποδεκτό (απορριπτέο)
openpgp-key-expired = Έληξε
openpgp-intro = Διαθέσιμα δημόσια κλειδιά για { $key }
openpgp-pubkey-import-id = ID: { $kid }
openpgp-pubkey-import-fpr = Αποτύπωμα: { $fpr }
openpgp-pubkey-import-intro =
    { $num ->
        [one] Το αρχείο περιέχει ένα δημόσιο κλειδί, όπως φαίνεται παρακάτω:
       *[other] Το αρχείο περιέχει { $num } δημόσια κλειδιά, όπως φαίνεται παρακάτω:
    }
openpgp-pubkey-import-accept =
    { $num ->
        [one] Αποδέχεστε αυτό το κλειδί για την επαλήθευση ψηφιακών υπογραφών και για την κρυπτογράφηση μηνυμάτων, για όλες τις εμφανιζόμενες διευθύνσεις email;
       *[other] Αποδέχεστε αυτά τα κλειδιά για την επαλήθευση ψηφιακών υπογραφών και για την κρυπτογράφηση μηνυμάτων, για όλες τις εμφανιζόμενες διευθύνσεις email;
    }
pubkey-import-button =
    .buttonlabelaccept = Εισαγωγή
    .buttonaccesskeyaccept = Ε
