# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Μέτρηση ποιότητας κωδικού πρόσβασης

## Change Password dialog

change-password-window =
    .title = Αλλαγή κύριου κωδικού πρόσβασης
change-device-password-window =
    .title = Αλλαγή κωδικού πρόσβασης
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Συσκευή ασφάλειας: { $tokenName }
change-password-old = Τρέχων κωδικός πρόσβασης:
change-password-new = Νέος κωδικός πρόσβασης:
change-password-reenter = Εισάγετε τον κωδικό ξανά

## Reset Password dialog

reset-password-window =
    .title = Επαναφορά κύριου κωδικού
    .style = width: 40em
pippki-failed-pw-change = Αδυναμία αλλαγής κωδικού πρόσβασης.
pippki-incorrect-pw = Δεν εισήγατε το σωστό κωδικό πρόσβασης. Παρακαλούμε δοκιμάστε ξανά.
pippki-pw-change-ok = Επιτυχής αλλαγή κωδικού πρόσβασης.
pippki-pw-empty-warning = Δεν θα προστατεύονται οι αποθηκευμένοι κωδικοί πρόσβασης και τα ιδιωτικά κλειδιά σας.
pippki-pw-erased-ok = Ο κωδικός πρόσβασής σας έχει διαγραφεί. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Προσοχή! Αποφασίσατε να μη χρησιμοποιήσετε κωδικό πρόσβασης. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = Βρίσκεστε σε λειτουργία FIPS . Το FIPS απαιτεί ένα μη κενό κωδικό πρόσβασης.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Επαναφορά κύριου κωδικού πρόσβασης
    .style = width: 40em
reset-password-button-label =
    .label = Επαναφορά
reset-password-text = Αν επαναφέρετε τον κύριο κωδικό σας, όλοι οι αποθηκευμένοι κωδικοί πρόσβασης από ιστοσελίδες και e-mail, τα δεδομένα φορμών, τα προσωπικά πιστοποιητικά και τα ιδιωτικά κλειδιά σας θα διαγραφούν. Θέλετε σίγουρα να επαναφέρετε τον κύριο κωδικό σας;
reset-primary-password-text = Εάν επαναφέρετε τον κύριο κωδικό πρόσβασής σας, θα διαγραφούν από την μνήμη όλοι οι αποθηκευμένοι κωδικοί πρόσβασης ιστοσελίδων και email, προσωπικών πιστοποιητικών και ιδιωτικών κλειδιών. Θέλετε σίγουρα να επαναφέρετε τον κύριο κωδικό πρόσβασης;
pippki-reset-password-confirmation-title = Επαναφορά κύριου κωδικού πρόσβασης
pippki-reset-password-confirmation-message = Έγινε επαναφορά του κύριου κωδικού πρόσβασής σας.

## Downloading cert dialog

download-cert-window =
    .title = Λήψη πιστοποιητικού
    .style = width: 46em
download-cert-message = Σας ζητήθηκε να εμπιστευθείτε μια νέα Αρχή Πιστοποίησης (CA).
download-cert-trust-ssl =
    .label = Να είναι έμπιστη αυτή η CA για την πιστοποίηση ιστοσελίδων.
download-cert-trust-email =
    .label = Να είναι έμπιστη αυτή η CA για την πιστοποίηση χρηστών email
download-cert-message-desc = Πριν να εμπιστευθείτε αυτήν την Αρχή Πιστοποίησης για οποιοδήποτε σκοπό, θα πρέπει να εξετάσετε το πιστοποιητικό και τις διαδικασίες και τις πολιτικές του (αν  είναι διαθέσιμες).
download-cert-view-cert =
    .label = Προβολή
download-cert-view-text = Εξέταση CA πιστοποιητικού

## Client Authorization Ask dialog

client-auth-window =
    .title = Ειδοποίηση Αναγνώρισης Χρήστη
client-auth-site-description = Η ιστοσελίδα ζήτησε να πιστοποιήσετε τον εαυτό σας με ένα πιστοποιητικό ασφάλειας:
client-auth-choose-cert = Επιλέξτε ένα πιστοποιητικό για να το παρουσιάσετε ως ταυτότητα:
client-auth-cert-details = Λεπτομέρειες επιλεγμένου πιστοποιητικού:

## Set password (p12) dialog

set-password-window =
    .title = Επιλογή κωδικού αντιγράφου ασφαλείας πιστοποιητικού
set-password-message = Ο κωδικός αντιγράφου ασφάλειας πιστοποιητικού προστατεύει το αντίγραφο που πρόκειται να δημιουργήσετε. Θα πρέπει να καθορίσετε αυτόν τον κωδικό ώστε να προχωρήσει η διαδικασία
set-password-backup-pw =
    .value = Κωδικός αντιγράφου ασφάλειας πιστοποιητικού:
set-password-repeat-backup-pw =
    .value = Κωδικός αντιγράφου ασφάλειας πιστοποιητικού (ξανά):
set-password-reminder = Προειδοποίηση: Αν ξεχάσετε τον κωδικό ασφάλειας, δεν θα μπορείτε να ανακτήσετε αυτό το αντίγραφο αργότερα. Φυλάξτε το σε ασφαλή τοποθεσία.

## Protected Auth dialog

protected-auth-window =
    .title = Προστατευμένη πιστοποίηση με διακριτικό
protected-auth-msg = Παρακαλώ πιστοποιήστε το διακριτικό. Η μέθοδος πιστοποίησης εξαρτάται από το είδος του διακριτικού.
protected-auth-token = Διακριτικό:
