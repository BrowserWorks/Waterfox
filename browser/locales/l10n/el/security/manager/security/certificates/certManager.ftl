# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Διαχείριση πιστοποιητικών

certmgr-tab-mine =
    .label = Τα πιστοποιητικά σας

certmgr-tab-remembered =
    .label = Αποφάσεις ταυτοποίησης

certmgr-tab-people =
    .label = Άτομα

certmgr-tab-servers =
    .label = Διακομιστές

certmgr-tab-ca =
    .label = Αρχές

certmgr-mine = Έχετε πιστοποιητικά από αυτούς τους οργανισμούς που σας ταυτοποιούν
certmgr-remembered = Αυτά τα πιστοποιητικά χρησιμοποιούνται για την αναγνώρισή σας σε ιστοτόπους
certmgr-people = Έχετε πιστοποιητικά στο αρχείο που ταυτοποιούν αυτά τα άτομα
certmgr-server = Αυτές οι καταχωρήσεις αναγνωρίζουν τις εξαιρέσεις σφαλμάτων του πιστοποιητικού διακομιστή
certmgr-ca = Έχετε πιστοποιητικά στο αρχείο που ταυτοποιούν αυτές τις αρχές πιστοποιητικών

certmgr-edit-ca-cert =
    .title = Επεξεργασία ρυθμίσεων αξιοπιστίας πιστοποιητικών CA
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Επεξεργασία ρυθμίσεων εμπιστοσύνης:

certmgr-edit-cert-trust-ssl =
    .label = Αυτό το πιστοποιητικό μπορεί να ταυτοποιήσει ιστοτόπους.

certmgr-edit-cert-trust-email =
    .label = Το παρόν πιστοποιεί χρήστες email.

certmgr-delete-cert =
    .title = Διαγραφή πιστοποιητικού
    .style = width: 48em; height: 24em;

certmgr-cert-host =
    .label = Υπολογιστής

certmgr-cert-name =
    .label = Όνομα πιστοποιητικού

certmgr-cert-server =
    .label = Διακομιστής

certmgr-override-lifetime =
    .label = Διάρκεια ζωής

certmgr-token-name =
    .label = Συσκευή ασφάλειας

certmgr-begins-label =
    .label = Αρχίζει στις

certmgr-expires-label =
    .label = Λήγει στις

certmgr-email =
    .label = Διεύθυνση email

certmgr-serial =
    .label = Σειριακός αριθμός

certmgr-view =
    .label = Προβολή…
    .accesskey = β

certmgr-edit =
    .label = Επεξεργασία εμπιστοσύνης…
    .accesskey = Ε

certmgr-export =
    .label = Εξαγωγή…
    .accesskey = ξ

certmgr-delete =
    .label = Διαγραφή…
    .accesskey = Δ

certmgr-delete-builtin =
    .label = Διαγραφή ή άρση εμπιστοσύνης…
    .accesskey = Δ

certmgr-backup =
    .label = Αντίγραφο ασφαλείας…
    .accesskey = φ

certmgr-backup-all =
    .label = Αντίγραφο όλων…
    .accesskey = ν

certmgr-restore =
    .label = Εισαγωγή…
    .accesskey = ι

certmgr-add-exception =
    .label = Προσθήκη εξαίρεσης…
    .accesskey = θ

exception-mgr =
    .title = Προσθήκη εξαίρεσης ασφαλείας

exception-mgr-extra-button =
    .label = Επιβεβαίωση εξαίρεσης ασφαλείας
    .accesskey = β

exception-mgr-supplemental-warning = Οι νόμιμες τράπεζες, τα καταστήματα και άλλες δημόσιες σελίδες δεν θα σας ζητήσουν να το κάνετε αυτό.

exception-mgr-cert-location-url =
    .value = Τοποθεσία:

exception-mgr-cert-location-download =
    .label = Λήψη πιστοποιητικού
    .accesskey = η

exception-mgr-cert-status-view-cert =
    .label = Προβολή…
    .accesskey = ο

exception-mgr-permanent =
    .label = Οριστική αποθήκευση εξαίρεσης
    .accesskey = ρ

pk11-bad-password = Ο κωδικός που εισάγατε ήταν εσφαλμένος.
pkcs12-decode-err = Αποτυχία αποκωδικοποίησης αρχείου. Είτε δεν είναι σε μορφή PKCS#12, είτε ο κωδικός που εισάγατε δεν είναι σωστός.
pkcs12-unknown-err-restore = Αποτυχία ανάκτησης του αρχείου  PKCS#12 για άγνωστους λόγους
pkcs12-unknown-err-backup = Αποτυχία δημιουργίας αντιγράφου ασφαλείας του αρχείου PKCS#12 για άγνωστους λόγους.
pkcs12-unknown-err = Η λειτουργία PKCS #12  απέτυχε για άγνωστους λόγους.
pkcs12-info-no-smartcard-backup = Δεν είναι δυνατή η αντιγραφή πιστοποιητικών από συσκευές ασφαλείας hardware όπως οι "έξυπνες κάρτες"
pkcs12-dup-data = Το πιστοποιητικό και το ιδιωτικό κλειδί υπάρχουν ήδη στη συσκευή ασφάλειας.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Όνομα αρχείου για αντίγραφο ασφάλειας
file-browse-pkcs12-spec = Αρχεία PKCS12
choose-p12-restore-file-dialog = Αρχείο πιστοποιητικού προς εισαγωγή

## Import certificate(s) file dialog

file-browse-certificate-spec = Αρχεία πιστοποιητικού
import-ca-certs-prompt = Επιλογή αρχείου που περιέχει πιστοποιητικό CA για εισαγωγή
import-email-cert-prompt = Επιλογή αρχείου που περιέχει πιστοποιητικό κάποιου για εισαγωγή

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Το πιστοποιητικό "{ $certName }" αντιπροσωπεύει μια Αρχή Πιστοποίησης.

## For Deleting Certificates

delete-user-cert-title =
    .title = Διαγραφή των πιστοποιητικών σας
delete-user-cert-confirm = Θέλετε σίγουρα να διαγράψετε αυτά τα πιστοποιητικά;
delete-user-cert-impact = Αν διαγράψετε τα δικά σας πιστοποιητικά δεν θα μπορείτε πλέον να τα χρησιμοποιήσετε για να πιστοποιήσετε τον εαυτό σας.


delete-ssl-override-title =
    .title = Διαγραφή εξαίρεσης πιστοποιητικού διακομιστή
delete-ssl-override-confirm = Θέλετε σίγουρα να διαγράψετε αυτή την εξαίρεση διακομιστή;
delete-ssl-override-impact = Αν διαγράψετε κάποια εξαίρεση διακομιστή, θα επαναφέρετε τους συνήθεις ελέγχους ασφαλείας για αυτό τον διακομιστή και την απαίτηση για έγκυρο πιστοποιητικό.

delete-ca-cert-title =
    .title = Διαγραφή ή άρση εμπιστοσύνης πιστοποητικών CA
delete-ca-cert-confirm = Ζητήσατε να διαγράψετε αυτά τα πιστοποιητικά CA. Για τα ενσωματωμένα πιστοποιητικά υπάρχει και η επιλογή της άρσης εμπιστοσύνης που έχει το ίδιο αποτέλεσμα. Θέλετε τα τα διαγράψετε ή να άρετε την εμπιστοσύνη σας;
delete-ca-cert-impact = Αν διαγράψετε ή άρετε την εμπιστοσύνη σας σε ένα πιστοποιητικό αρχής πιστοποίησης (CA), αυτή η εφαρμογή δεν θα εμπιστεύεται πια πιστοποιητικά από αυτή την CA.


delete-email-cert-title =
    .title = Διαγραφή πιστοποιητικών email
delete-email-cert-confirm = Θέλετε σίγουρα να διαγράψετε τα πιστοποιητικά email αυτών των ατόμων;
delete-email-cert-impact = Εάν διαγράψετε ένα πιστοποιητικό e-mail,  δεν θα μπορείτε πια να στέλνετε κρυπτογραφημένη αλληλογραφία σε αυτούς τους ανθρώπους.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Πιστοποιητικό με σειριακό αριθμό: { $serialNumber }

## Cert Viewer

# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = Χωρίς αποστολή πιστοποιητικού πελάτη

# Used when no cert is stored for an override
no-cert-stored-for-override = (Μη αποθηκευμένο)

# When a certificate is unavailable (for example, it has been deleted or the token it exists on has been removed).
certificate-not-available = (Μη διαθέσιμο)

## Used to show whether an override is temporary or permanent

permanent-override = Μόνιμο
temporary-override = Προσωρινό

## Add Security Exception dialog

add-exception-branded-warning = Πρόκειται να παρακάμψετε τον τρόπο με τον οποίο το { -brand-short-name } αναγνωρίζει τη σελίδα.
add-exception-invalid-header = Αυτή σελίδα προσπαθεί να πιστοποιήσει τον εαυτό της με μη έγκυρες πληροφορίες.
add-exception-domain-mismatch-short = Εσφαλμένος ιστότοπος
add-exception-domain-mismatch-long = Το πιστοποιητικό ανήκει σε διαφορετικό ιστότοπο, πράγμα το οποίο μπορεί να σημαίνει ότι κάποιος προσπαθεί να τον μιμηθεί.
add-exception-expired-short = Παρωχημένες πληροφορίες
add-exception-expired-long = Το πιστοποιητικό δεν είναι έγκυρο αυτή τη στιγμή. Ενδέχεται να έχει κλαπεί ή χαθεί και να χρησιμοποιείται από κάποιον για να μιμηθεί αυτό τον ιστότοπο.
add-exception-unverified-or-bad-signature-short = Άγνωστη ταυτότητα
add-exception-unverified-or-bad-signature-long = Το πιστοποιητικό δεν είναι έγκυρο, επειδή δεν έχει επικυρωθεί από μια αναγνωρισμένη αρχή με χρήση ασφαλούς υπογραφής.
add-exception-valid-short = Έγκυρο πιστοποιητικό
add-exception-valid-long = Αυτή η σελίδα παρέχει έγκυρη και επικυρωμένη πιστοποίηση.  Δεν υπάρχει λόγος να εξαιρεθεί.
add-exception-checking-short = Έλεγχος πληροφοριών
add-exception-checking-long = Γίνεται προσπάθεια πιστοποίησης της σελίδας…
add-exception-no-cert-short = Δεν υπάρχουν διαθέσιμες πληροφορίες
add-exception-no-cert-long = Αδυναμία λήψης κατάστασης ταυτότητας για αυτή τη σελίδα.

## Certificate export "Save as" and error dialogs

save-cert-as = Αποθήκευση πιστοποιητικού στο αρχείο
cert-format-base64 = Πιστοποιητικό X.509 (PEM)
cert-format-base64-chain = Πιστοποιητικό X.509 με chain (PKCS#7)
cert-format-der = Πιστοποιητικό X.509 (DER)
cert-format-pkcs7 = Πιστοποιητικό X.509 (PKCS#7)
cert-format-pkcs7-chain = Πιστοποιητικό X.509 με chain (PKCS#7)
write-file-failure = Σφάλμα αρχείου
