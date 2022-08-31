# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-key-assistant-title = Βοηθός κλειδιών OpenPGP
openpgp-key-assistant-rogue-warning = Να αποφεύγετε την αποδοχή πλαστού κλειδιού. Για να βεβαιωθείτε ότι λάβατε το σωστό κλειδί, θα πρέπει να το επαληθεύσετε. <a data-l10n-name="openpgp-link">Μάθετε περισσότερα…</a>

## Encryption status

openpgp-key-assistant-recipients-issue-header = Δεν είναι δυνατή η κρυπτογράφηση
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-issue-description =
    { $count ->
        [one] Για την κρυπτογράφηση, πρέπει να λάβετε και αποδεχτείτε ένα κλειδί για ένα αποδέκτη. <a data-l10n-name="openpgp-link">Μάθετε περισσότερα…</a>
       *[other] Για την κρυπτογράφηση, πρέπει να λάβετε και αποδεχτείτε ένα κλειδί για { $count } αποδέκτες. <a data-l10n-name="openpgp-link">Μάθετε περισσότερα…</a>
    }
openpgp-key-assistant-info-alias = Το { -brand-short-name } κανονικά απαιτεί το δημόσιο κλειδί του παραλήπτη, το οποίο περιέχει ένα ID χρήστη με την ίδια διεύθυνση email. Αυτό μπορεί να παρακαμφθεί με τη χρήση κανόνων ψευδωνύμων παραληπτών του OpenPGP. <a data-l10n-name="openpgp-link">Μάθετε περισσότερα…</a>
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-description =
    { $count ->
        [one] Έχετε ήδη αποδεχθεί ένα χρησιμοποιήσιμο κλειδί για ένα αποδέκτη.
       *[other] Έχετε ήδη αποδεχθεί χρησιμοποιήσιμα κλειδιά για { $count } αποδέκτες.
    }
openpgp-key-assistant-recipients-description-no-issues = Το μήνυμα μπορεί να κρυπτογραφηθεί. Έχετε αποδεχθεί χρησιμοποιήσιμα κλειδιά για όλους τους αποδέκτες.

## Resolve section

# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
# $numKeys (Number) - The number of keys.
openpgp-key-assistant-resolve-title =
    { $numKeys ->
        [one] Το { -brand-short-name } βρήκε το παρακάτω κλειδί για τον { $recipient }.
       *[other] Το { -brand-short-name } βρήκε τα παρακάτω κλειδιά για τον { $recipient }.
    }
openpgp-key-assistant-valid-description = Επιλέξτε το κλειδί που θέλετε να αποδεχτείτε
# Variables:
# $numKeys (Number) - The number of available keys.
openpgp-key-assistant-invalid-title =
    { $numKeys ->
        [one] Το παρακάτω κλειδί δεν μπορεί να χρησιμοποιηθεί, εκτός αν λάβετε ενημέρωση.
       *[other] Τα παρακάτω κλειδιά δεν μπορούν να χρησιμοποιηθούν, εκτός αν λάβετε ενημέρωση.
    }
openpgp-key-assistant-no-key-available = Κανένα διαθέσιμο κλειδί.
openpgp-key-assistant-multiple-keys = Διατίθενται πολλαπλά κλειδιά.
# Variables:
# $count (Number) - The number of unaccepted keys.
openpgp-key-assistant-key-unaccepted =
    { $count ->
        [one] Ένα κλειδί είναι διαθέσιμο, αλλά δεν έχει γίνει αποδοχή του ακόμη.
       *[other] Πολλαπλά κλειδιά είναι διαθέσιμα, αλλά για κανένα δεν έχει γίνει αποδοχή ακόμη.
    }
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-accepted-expired = Ένα αποδεκτό κλειδί έληξε στις { $date }.
openpgp-key-assistant-keys-accepted-expired = Έχουν λήξει πολλαπλά αποδεκτά κλειδιά.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-this-key-accepted-expired = Έχει γίνει αποδοχή του κλειδιού παλιότερα, αλλά έληξε στις { $date }.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-unaccepted-expired-one = Το κλειδί έληξε στις { $date }.
openpgp-key-assistant-key-unaccepted-expired-many = Έχουν λήξει πολλαπλά κλειδιά.
openpgp-key-assistant-key-fingerprint = Αποτύπωμα
openpgp-key-assistant-key-source =
    { $count ->
        [one] Πηγή
       *[other] Πηγές
    }
openpgp-key-assistant-key-collected-attachment = συνημμένο email
# Autocrypt is the name of a standard.
openpgp-key-assistant-key-collected-autocrypt = Κεφαλίδα Autocrypt
openpgp-key-assistant-key-collected-keyserver = διακομιστής κλειδιού
# Web Key Directory (WKD) is a concept.
openpgp-key-assistant-key-collected-wkd = Κατάλογος Κλειδιών στον Ιστό
openpgp-key-assistant-keys-has-collected =
    { $count ->
        [one] Βρέθηκε ένα κλειδί, αλλά δεν έχει γίνει αποδοχή του ακόμη.
       *[other] Βρέθηκαν πολλαπλά κλειδιά, αλλά για κανένα δεν έχει γίνει αποδοχή ακόμη.
    }
openpgp-key-assistant-key-rejected = Το κλειδί απορρίφθηκε παλιότερα.
openpgp-key-assistant-key-accepted-other = Το κλειδί έγινε αποδεκτό παλιότερα, αλλά για διαφορετική διεύθυνση email.
# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
openpgp-key-assistant-resolve-discover-info = Βρείτε πρόσθετα ή ενημερωμένα κλειδιά για τον { $recipient } στο διαδίκτυο, ή εισαγάγετέ τα από ένα αρχείο.

## Discovery section

openpgp-key-assistant-discover-title = Διαδικτυακή ανακάλυψη σε εξέλιξη.
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-discover-keys = Ανακάλυψη κλειδιών για { $recipient }…
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-expired-key-update =
    Βρέθηκε ενημέρωση για ένα από τα προηγούμενα αποδεχθέντα κλειδιά για τον { $recipient }.
    Μπορεί τώρα να χρησιμοποιηθεί καθώς δεν έχει λήξει.

## Dialog buttons

openpgp-key-assistant-discover-online-button = Εύρεση Δημοσίων Κλειδιών στο Διαδίκτυο…
openpgp-key-assistant-import-keys-button = Εισαγωγή Δημοσίων Κλειδιών από Αρχείο…
openpgp-key-assistant-issue-resolve-button = Επίλυση…
openpgp-key-assistant-view-key-button = Προβολή κλειδιού…
openpgp-key-assistant-recipients-show-button = Εμφάνιση
openpgp-key-assistant-recipients-hide-button = Απόκρυψη
openpgp-key-assistant-cancel-button = Ακύρωση
openpgp-key-assistant-back-button = Πίσω
openpgp-key-assistant-accept-button = Αποδοχή
openpgp-key-assistant-close-button = Κλείσιμο
openpgp-key-assistant-disable-button = Απενεργοποίηση κρυπτογράφησης
openpgp-key-assistant-confirm-button = Αποστολή κρυπτογραφημένου
# Variables:
# $date (String) - The key creation date.
openpgp-key-assistant-key-created = δημιουργήθηκε στις { $date }
