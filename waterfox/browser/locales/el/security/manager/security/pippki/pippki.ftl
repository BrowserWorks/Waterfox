# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Μέτρηση ποιότητας κωδικού πρόσβασης

## Change Password dialog

change-device-password-window =
    .title = Αλλαγή κωδικού πρόσβασης
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Συσκευή ασφάλειας: { $tokenName }
change-password-old = Τρέχων κωδικός πρόσβασης:
change-password-new = Νέος κωδικός πρόσβασης:
change-password-reenter = Εισάγετε τον κωδικό ξανά
pippki-failed-pw-change = Αδυναμία αλλαγής κωδικού πρόσβασης.
pippki-incorrect-pw = Δεν εισήγατε το σωστό κωδικό πρόσβασης. Παρακαλούμε δοκιμάστε ξανά.
pippki-pw-change-ok = Επιτυχής αλλαγή κωδικού πρόσβασης.
pippki-pw-empty-warning = Δεν θα προστατεύονται οι αποθηκευμένοι κωδικοί πρόσβασης και τα ιδιωτικά κλειδιά σας.
pippki-pw-erased-ok = Ο κωδικός πρόσβασής σας έχει διαγραφεί. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Προσοχή! Αποφασίσατε να μη χρησιμοποιήσετε κωδικό πρόσβασης. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = Βρίσκεστε σε λειτουργία FIPS . Το FIPS απαιτεί ένα μη κενό κωδικό πρόσβασης.

## Reset Primary Password dialog

reset-primary-password-window2 =
    .title = Επαναφορά κύριου κωδικού πρόσβασης
    .style = min-width: 40em
reset-password-button-label =
    .label = Επαναφορά
reset-primary-password-text = Εάν επαναφέρετε τον κύριο κωδικό πρόσβασής σας, θα διαγραφούν από την μνήμη όλοι οι αποθηκευμένοι κωδικοί πρόσβασης ιστοτόπων και email, προσωπικών πιστοποιητικών και ιδιωτικών κλειδιών. Θέλετε σίγουρα να επαναφέρετε τον κύριο κωδικό πρόσβασης;
pippki-reset-password-confirmation-title = Επαναφορά κύριου κωδικού πρόσβασης
pippki-reset-password-confirmation-message = Έγινε επαναφορά του κύριου κωδικού πρόσβασής σας.

## Downloading cert dialog

download-cert-window2 =
    .title = Λήψη πιστοποιητικού
    .style = min-width: 46em
download-cert-message = Σας ζητήθηκε να εμπιστευθείτε μια νέα Αρχή Πιστοποίησης (CA).
download-cert-trust-ssl =
    .label = Να θεωρείται αξιόπιστη αυτή η ΑΠ για την αναγνώριση ιστοτόπων.
download-cert-trust-email =
    .label = Να είναι έμπιστη αυτή η CA για την πιστοποίηση χρηστών email
download-cert-message-desc = Πριν εμπιστευθείτε αυτήν την Αρχή Πιστοποίησης για οποιονδήποτε σκοπό, θα πρέπει να εξετάσετε το πιστοποιητικό, καθώς και τις διαδικασίες και τις πολιτικές του (αν είναι διαθέσιμες).
download-cert-view-cert =
    .label = Προβολή
download-cert-view-text = Εξέταση CA πιστοποιητικού

## Client Authorization Ask dialog


## Client Authentication Ask dialog

client-auth-window =
    .title = Ειδοποίηση Αναγνώρισης Χρήστη
client-auth-site-description = Ο ιστότοπος ζήτησε να ταυτοποιήσετε τον εαυτό σας με ένα πιστοποιητικό:
client-auth-choose-cert = Επιλέξτε ένα πιστοποιητικό για να το παρουσιάσετε ως ταυτότητα:
client-auth-send-no-certificate =
    .label = Χωρίς αποστολή πιστοποιητικού
# Variables:
# $hostname (String) - The domain name of the site requesting the client authentication certificate
client-auth-site-identification = Το «{ $hostname }» ζήτησε να ταυτοποιηθείτε με ένα πιστοποιητικό:
client-auth-cert-details = Λεπτομέρειες επιλεγμένου πιστοποιητικού:
# Variables:
# $issuedTo (String) - The subject common name of the currently-selected client authentication certificate
client-auth-cert-details-issued-to = Έκδοση για: { $issuedTo }
# Variables:
# $serialNumber (String) - The serial number of the certificate (hexadecimal of the form "AA:BB:...")
client-auth-cert-details-serial-number = Σειριακός αριθμός: { $serialNumber }
# Variables:
# $notBefore (String) - The date before which the certificate is not valid (e.g. Apr 21, 2023, 1:47:53 PM UTC)
# $notAfter (String) - The date after which the certificate is not valid
client-auth-cert-details-validity-period = Έγκυρο από { $notBefore } έως { $notAfter }
# Variables:
# $keyUsages (String) - A list of already-localized key usages for which the certificate may be used
client-auth-cert-details-key-usages = Χρήσεις κλειδιού: { $keyUsages }
# Variables:
# $emailAddresses (String) - A list of email addresses present in the certificate
client-auth-cert-details-email-addresses = Διευθύνσεις email: { $emailAddresses }
# Variables:
# $issuedBy (String) - The issuer common name of the certificate
client-auth-cert-details-issued-by = Εκδόθηκε από: { $issuedBy }
# Variables:
# $storedOn (String) - The name of the token holding the certificate (for example, "OS Client Cert Token (Modern)")
client-auth-cert-details-stored-on = Αποθηκευμένο σε: { $storedOn }
client-auth-cert-remember-box =
    .label = Απομνημόνευση απόφασης

## Set password (p12) dialog

set-password-window =
    .title = Επιλογή κωδικού αντιγράφου ασφαλείας πιστοποιητικού
set-password-message = Ο κωδικός αντιγράφου ασφάλειας πιστοποιητικού προστατεύει το αντίγραφο που πρόκειται να δημιουργήσετε. Θα πρέπει να καθορίσετε αυτόν τον κωδικό ώστε να προχωρήσει η διαδικασία
set-password-backup-pw =
    .value = Κωδικός αντιγράφου ασφάλειας πιστοποιητικού:
set-password-repeat-backup-pw =
    .value = Κωδικός αντιγράφου ασφάλειας πιστοποιητικού (ξανά):
set-password-reminder = Προειδοποίηση: Αν ξεχάσετε τον κωδικό ασφάλειας, δεν θα μπορείτε να ανακτήσετε αυτό το αντίγραφο αργότερα. Φυλάξτε το σε ασφαλή τοποθεσία.

## Protected authentication alert

# Variables:
# $tokenName (String) - The name of the token to authenticate to (for example, "OS Client Cert Token (Modern)")
protected-auth-alert = Πραγματοποιήστε έλεγχο ταυτότητας στο διακριτικό «{ $tokenName }». Ο τρόπος ταυτοποίησης εξαρτάται από το διακριτικό (για παράδειγμα, με συσκευή ανάγνωσης δακτυλικών αποτυπωμάτων ή εισαγωγή κωδικού με πληκτρολόγιο).
