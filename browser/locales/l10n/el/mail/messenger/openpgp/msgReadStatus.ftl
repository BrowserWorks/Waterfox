# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Message Header Encryption Button

message-header-show-security-info-key = Ε
#   $type (String) - the shortcut key defined in the message-header-show-security-info-key
message-security-button =
    .title =
        { PLATFORM() ->
            [macos] Εμφάνιση ασφάλειας μηνύματος (⌘ ⌥ { message-header-show-security-info-key })
           *[other] Εμφάνιση ασφάλειας μηνύματος (Ctrl+Alt+{ message-header-show-security-info-key })
        }
openpgp-view-signer-key =
    .label = Προβολή κλειδιού υπογράφοντα
openpgp-view-your-encryption-key =
    .label = Προβολή του κλειδιού σας αποκρυπτογράφησης
openpgp-openpgp = OpenPGP
openpgp-no-sig = Χωρίς Ψηφιακή Υπογραφή
openpgp-uncertain-sig = Αβέβαιη Ψηφιακή Υπογραφή
openpgp-invalid-sig = Άκυρη Ψηφιακή Υπογραφή
openpgp-good-sig = Έγκυρη Ψηφιακή Υπογραφή
openpgp-sig-uncertain-no-key = Αυτό το μήνυμα περιέχει ψηφιακή υπογραφή, αλλά είναι αβέβαιο αν είναι σωστό. Για να επαληθεύσετε την υπογραφή, θα χρειαστεί να αποκτήσετε ένα αντίγραφο του δημόσιου κλειδιού του αποστολέα.
openpgp-sig-uncertain-uid-mismatch = Αυτό το μήνυμα περιέχει ψηφιακή υπογραφή, αλλά ανιχνεύτηκε αναντιστοιχία. Το μήνυμα απεστάλη από κάποια διεύθυνση email που δεν ταιριάζει με το δημόσιο κλειδί του υπογράφοντα.
openpgp-sig-uncertain-not-accepted = Αυτό το μήνυμα περιέχει ψηφιακή υπογραφή, αλλά δεν έχετε αποφασίσει ακόμα αν το κλειδί του υπογράφοντα είναι αποδεκτό από εσάς.
openpgp-sig-invalid-rejected = Αυτό το μήνυμα περιέχει ψηφιακή υπογραφή, αλλά έχετε ήδη αποφασίσει να απορρίψετε το κλειδί του υπογράφοντα.
openpgp-sig-invalid-technical-problem = Αυτό το μήνυμα περιέχει μια ψηφιακή υπογραφή, αλλά εντοπίστηκε ένα τεχνικό σφάλμα. Είτε το μήνυμα έχει καταστραφεί, είτε το μήνυμα έχει τροποποιηθεί από κάποιον άλλο.
openpgp-sig-valid-unverified = Αυτό το μήνυμα περιλαμβάνει μια έγκυρη, ψηφιακή υπογραφή από ένα κλειδί που έχετε ήδη αποδεχτεί. Ωστόσο, δεν έχετε επαληθεύσει ακόμη ότι το κλειδί ανήκει πράγματι στον αποστολέα.
openpgp-sig-valid-verified = Αυτό το μήνυμα περιλαμβάνει μια έγκυρη, ψηφιακή υπογραφή από ένα επαληθευμένο κλειδί.
openpgp-sig-valid-own-key = Αυτό το μήνυμα περιέχει έγκυρη ψηφιακή υπογραφή από το προσωπικό σας κλειδί.
openpgp-sig-key-id = Αναγνωριστικό κλειδιού υπογράφοντος: { $key }
openpgp-sig-key-id-with-subkey-id = ID κλειδιού υπογράφοντα: { $key } (ID υποκλειδιού: { $subkey })
openpgp-enc-key-id = Το ID κλειδιού αποκρυπτογράφησής σας: { $key }
openpgp-enc-key-with-subkey-id = ID κλειδιού αποκρυπτογράφησης: { $key } (ID υποκλειδιού: { $subkey })
openpgp-unknown-key-id = Άγνωστο κλειδί
openpgp-other-enc-additional-key-ids = Επιπλέον, το μήνυμα κρυπτογραφήθηκε στους κατόχους των ακόλουθων κλειδιών:
openpgp-other-enc-all-key-ids = Το μήνυμα κρυπτογραφήθηκε στους κατόχους των ακόλουθων κλειδιών:
openpgp-message-header-encrypted-ok-icon =
    .alt = Επιτυχής αποκρυπτογράφηση
openpgp-message-header-encrypted-notok-icon =
    .alt = Αποτυχία αποκρυπτογράφησης
openpgp-message-header-signed-ok-icon =
    .alt = Καλή υπογραφή
# Mismatch icon is used for notok state as well
openpgp-message-header-signed-mismatch-icon =
    .alt = Κακή υπογραφή
openpgp-message-header-signed-unknown-icon =
    .alt = Άγνωστη κατάσταση υπογραφής
openpgp-message-header-signed-verified-icon =
    .alt = Επαληθευμένη υπογραφή
openpgp-message-header-signed-unverified-icon =
    .alt = Μη επαληθευμένη υπογραφή
