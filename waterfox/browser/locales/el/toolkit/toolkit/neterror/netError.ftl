# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = Πρόβλημα φόρτωσης σελίδας
certerror-page-title = Προειδοποίηση: Πιθανός κίνδυνος ασφαλείας
certerror-sts-page-title = Δεν έγινε σύνδεση: Πιθανό ζήτημα ασφαλείας
neterror-blocked-by-policy-page-title = Αποκλεισμένη σελίδα
neterror-captive-portal-page-title = Σύνδεση στο δίκτυο
neterror-dns-not-found-title = Ο διακομιστής δεν βρέθηκε
neterror-malformed-uri-page-title = Μη έγκυρο URL

## Error page actions

neterror-advanced-button = Σύνθετα…
neterror-copy-to-clipboard-button = Αντιγραφή κειμένου στο πρόχειρο
neterror-learn-more-link = Μάθετε περισσότερα…
neterror-open-portal-login-page-button = Άνοιγμα σελίδας σύνδεσης δικτύου
neterror-override-exception-button = Αποδοχή κινδύνου και συνέχεια
neterror-pref-reset-button = Επαναφορά προεπιλεγμένων ρυθμίσεων
neterror-return-to-previous-page-button = Επιστροφή
neterror-return-to-previous-page-recommended-button = Επιστροφή (Προτείνεται)
neterror-try-again-button = Δοκιμή ξανά
neterror-add-exception-button = Πάντα συνέχεια για αυτόν τον ιστότοπο
neterror-settings-button = Αλλαγή ρυθμίσεων DNS
neterror-view-certificate-link = Προβολή πιστοποιητικού
neterror-trr-continue-this-time = Συνέχεια αυτήν τη φορά
neterror-disable-native-feedback-warning = Πάντα συνέχεια

##

neterror-pref-reset = Μοιάζει να προκαλείται από τις ρυθμίσεις ασφαλείας του δικτύου σας. Θέλετε να αποκατασταθούν οι προεπιλεγμένες ρυθμίσεις;
neterror-error-reporting-automatic = Αναφορά παρόμοιων σφαλμάτων για να βοηθήσετε τη { -vendor-short-name } στον εντοπισμό και αποκλεισμό κακόβουλων ιστοτόπων

## Specific error messages

neterror-generic-error = Το { -brand-short-name } δεν μπορεί να φορτώσει αυτήν τη σελίδα για κάποιο λόγο.
neterror-load-error-try-again = Ο ιστότοπος ενδέχεται να είναι προσωρινά μη διαθέσιμος ή πολύ απασχολημένος. Δοκιμάστε ξανά σε λίγο.
neterror-load-error-connection = Αν δεν μπορείτε να φορτώσετε καμία σελίδα, ελέγξτε τη σύνδεση δικτύου του υπολογιστή σας.
neterror-load-error-firewall = Αν ο υπολογιστής ή το δίκτυό σας προστατεύονται από τείχος προστασίας ή διακομιστή μεσολάβησης, βεβαιωθείτε ότι επιτρέπεται στο { -brand-short-name } η πρόσβαση στο διαδίκτυο.
neterror-captive-portal = Πρέπει να συνδεθείτε σε αυτό το δίκτυο πριν μπορέσετε να αποκτήσετε πρόσβαση στο διαδίκτυο.
# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = Θέλατε μήπως να μεταβείτε στο <a data-l10n-name="website">{ $hostAndPath }</a>;
neterror-dns-not-found-hint-header = <strong>Εάν πληκτρολογήσατε τη σωστή διεύθυνση, μπορείτε να:</strong>
neterror-dns-not-found-hint-try-again = Δοκιμάσετε ξανά αργότερα
neterror-dns-not-found-hint-check-network = Ελέγξετε τη σύνδεσή σας στο δίκτυο
neterror-dns-not-found-hint-firewall = Ελέγξετε εάν το { -brand-short-name } έχει άδεια πρόσβασης στο διαδίκτυο (ενδέχεται να έχετε συνδεθεί, αλλά μέσω τείχους προστασίας)

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = Το { -brand-short-name } δεν μπορεί να προστατεύσει το αίτημά σας για τη διεύθυνση αυτού του ιστότοπου μέσω του αξιόπιστου προγράμματος ανάλυσης DNS. Αυτό συμβαίνει επειδή:
neterror-dns-not-found-trr-third-party-warning2 = Μπορείτε να συνεχίσετε με το προεπιλεγμένο σας πρόγραμμα ανάλυσης DNS. Ωστόσο, κάποιος τρίτος ενδέχεται να μπορεί να δει ποιους ιστοτόπους επισκέπτεστε.
neterror-dns-not-found-trr-only-could-not-connect = Το { -brand-short-name } δεν μπόρεσε να συνδεθεί στο { $trrDomain }.
neterror-dns-not-found-trr-only-timeout = Η σύνδεση με το { $trrDomain } διήρκεσε περισσότερο από το αναμενόμενο.
neterror-dns-not-found-trr-offline = Δεν έχετε συνδεθεί στο διαδίκτυο.
neterror-dns-not-found-trr-unknown-host2 = Αυτός ο ιστότοπος δεν βρέθηκε από το { $trrDomain }.
neterror-dns-not-found-trr-server-problem = Προέκυψε πρόβλημα με το { $trrDomain }.
neterror-dns-not-found-bad-trr-url = Μη έγκυρο URL.
neterror-dns-not-found-trr-unknown-problem = Απροσδόκητο πρόβλημα.

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = Το { -brand-short-name } δεν μπορεί να προστατεύσει το αίτημά σας για τη διεύθυνση αυτού του ιστότοπου μέσω του αξιόπιστου προγράμματος ανάλυσης DNS. Αυτό συμβαίνει επειδή:
neterror-dns-not-found-native-fallback-heuristic = Το DNS over HTTPS έχει απενεργοποιηθεί στο δίκτυό σας.
neterror-dns-not-found-native-fallback-not-confirmed2 = Το { -brand-short-name } δεν μπόρεσε να συνδεθεί στο { $trrDomain }.

##

neterror-file-not-found-filename = Ελέγξτε το όνομα του αρχείου για εσφαλμένα κεφαλαία ή άλλα ορθογραφικά λάθη.
neterror-file-not-found-moved = Ελέγξτε αν το αρχείο έχει μετακινηθεί, μετονομαστεί ή διαγραφτεί.
neterror-access-denied = Ενδέχεται να έχει διαγραφεί, μετακινηθεί, ή να μην επιτρέπεται η πρόσβαση λόγω των δικαιωμάτων του αρχείου.
neterror-unknown-protocol = Ίσως χρειαστεί να εγκαταστήσετε κάποιο άλλο λογισμικό για να ανοίξετε αυτήν τη διεύθυνση.
neterror-redirect-loop = Αυτό το πρόβλημα μπορεί να οφείλεται στην απενεργοποίηση ή την άρνηση αποδοχής των cookies.
neterror-unknown-socket-type-psm-installed = Βεβαιωθείτε ότι το σύστημά σας διαθέτει τη διαχείριση προσωπικής ασφάλειας.
neterror-unknown-socket-type-server-config = Αυτό μπορεί να οφείλεται σε κάποια μη τυπική ρύθμιση του διακομιστή.
neterror-not-cached-intro = Το ζητούμενο έγγραφο δεν είναι διαθέσιμο στην κρυφή μνήμη του { -brand-short-name }.
neterror-not-cached-sensitive = Ως μέτρο ασφαλείας, το { -brand-short-name } δεν ζητά εκ νέου τα ευαίσθητα έγγραφα.
neterror-not-cached-try-again = Κάντε κλικ στο "Δοκιμή ξανά" για να εκ νέου αίτηση του εγγράφου από την ιστοσελίδα.
neterror-net-offline = Κάντε κλικ στο «Δοκιμή ξανά» για να μεταβείτε σε λειτουργία εντός σύνδεσης και να επαναφορτώσετε τη σελίδα.
neterror-proxy-resolve-failure-settings = Ελέγξτε τις ρυθμίσεις διακομιστή μεσολάβησης για να επιβεβαιώσετε ότι είναι σωστές.
neterror-proxy-resolve-failure-connection = Ελέγξτε αν ο υπολογιστής σας διαθέτει λειτουργική σύνδεση δικτύου.
neterror-proxy-resolve-failure-firewall = Αν ο υπολογιστής ή το δίκτυό σας προστατεύονται από τείχος προστασίας ή διακομιστή μεσολάβησης, βεβαιωθείτε ότι επιτρέπεται στο { -brand-short-name } η πρόσβαση στο διαδίκτυο.
neterror-proxy-connect-failure-settings = Ελέγξτε τις ρυθμίσεις διακομιστή μεσολάβησης για να επιβεβαιώσετε ότι είναι σωστές.
neterror-proxy-connect-failure-contact-admin = Επικοινωνήστε με τον διαχειριστή του δικτύου σας για να βεβαιωθείτε ότι ο διακομιστής μεσολάβησης λειτουργεί.
neterror-content-encoding-error = Παρακαλώ επικοινωνήστε με τους ιδιοκτήτες του ιστοτόπου για να τους ενημερώσετε σχετικά με αυτό το πρόβλημα.
neterror-unsafe-content-type = Παρακαλώ επικοινωνήστε με τους ιδιοκτήτες του ιστοτόπου για να τους ενημερώσετε σχετικά με αυτό το πρόβλημα.
neterror-nss-failure-not-verified = Η σελίδα που προσπαθείτε να δείτε δεν μπορεί να εμφανιστεί επειδή δεν ήταν δυνατή η επαλήθευση των ληφθέντων δεδομένων.
neterror-nss-failure-contact-website = Παρακαλώ επικοινωνήστε με τους ιδιοκτήτες του ιστοτόπου για να τους ενημερώσετε σχετικά με αυτό το πρόβλημα.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = Το { -brand-short-name } ανίχνευσε μια πιθανή απειλή ασφαλείας και δεν συνέχισε στο <b>{ $hostname }</b>. Αν επισκεφθείτε αυτόν τον ιστότοπο, οι εισβολείς ενδέχεται να προσπαθήσουν να υποκλέψουν πληροφορίες, όπως τους κωδικούς πρόσβασης, τα email ή τα στοιχεία των πιστωτικών καρτών σας.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = Το { -brand-short-name } ανίχνευσε μια πιθανή απειλή ασφαλείας και δεν συνέχισε στο <b>{ $hostname }</b> επειδή αυτός ο ιστότοπος απαιτεί ασφαλή σύνδεση.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = Το { -brand-short-name } ανίχνευσε ένα ζήτημα και δεν συνέχισε στο <b>{ $hostname }</b>. Είτε η ιστοσελίδα έχει ρυθμιστεί με λάθος τρόπο είτε το ρολόι του υπολογιστή σας έχει οριστεί σε λάθος ώρα.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = Το <b>{ $hostname }</b> είναι πιθανότατα ένας ασφαλής ιστότοπος, αλλά δεν ήταν δυνατή η δημιουργία ασφαλούς σύνδεσης. Αυτό το ζήτημα προκαλείται από το <b>{ $mitm }</b>, που είναι λογισμικό είτε στον υπολογιστή σας είτε στο δίκτυό σας.
neterror-corrupted-content-intro = Η σελίδα που προσπαθείτε να δείτε δεν μπορεί να εμφανιστεί επειδή ανιχνεύθηκε σφάλμα κατά τη μετάδοση δεδομένων.
neterror-corrupted-content-contact-website = Παρακαλώ ενημερώστε τους ιδιοκτήτες του ιστοτόπου για να τους ενημερώσετε σχετικά με αυτό το πρόβλημα.
# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = Σύνθετες πληροφορίες: SSL_ERROR_UNSUPPORTED_VERSION
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = Το <b>{ $hostname }</b> χρησιμοποιεί παρωχημένη τεχνολογία ασφαλείας, ευάλωτη σε επιθέσεις. Ένας εισβολέας θα μπορούσε εύκολα να αποκαλύψει πληροφορίες που θεωρείτε ασφαλείς. Ο διαχειριστής του ιστοτόπου θα πρέπει να διορθώσει τον διακομιστή προτού μπορέσετε να επισκεφθείτε τον ιστότοπο.
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = Κωδικός σφάλματος: NS_ERROR_NET_INADEQUATE_SECURITY
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = Ο υπολογιστής σας νομίζει ότι είναι { DATETIME($now, dateStyle: "medium") }, εμποδίζοντας την ασφαλή σύνδεση του { -brand-short-name }. Για να επισκεφθείτε το <b>{ $hostname }</b>, ενημερώστε το ρολόι του υπολογιστή στην τρέχουσα ημερομηνία, ώρα και ζώνη ώρας από τις ρυθμίσεις συστήματος και, έπειτα, κάντε ανανέωση του <b>{ $hostname }</b>.
neterror-network-protocol-error-intro = Δεν είναι δυνατή η εμφάνιση αυτής της σελίδας επειδή προέκυψε σφάλμα στο πρωτόκολλο του δικτύου.
neterror-network-protocol-error-contact-website = Παρακαλώ επικοινωνήστε με τους ιδιοκτήτες του ιστοτόπου για να τους ενημερώσετε σχετικά με αυτό το πρόβλημα.
certerror-expired-cert-second-para = Το πιστοποιητικό του ιστοτόπου έχει πιθανότατα λήξει, εμποδίζοντας την ασφαλή σύνδεση με το { -brand-short-name }. Αν επισκεφθείτε αυτόν τον ιστότοπο, οι εισβολείς ενδέχεται να αποπειραθούν να υποκλέψουν πληροφορίες, όπως τους κωδικούς πρόσβασης, τα email ή τα στοιχεία των πιστωτικών καρτών σας.
certerror-expired-cert-sts-second-para = Το πιστοποιητικό του ιστοτόπου έχει πιθανότατα λήξει, εμποδίζοντας την ασφαλή σύνδεση με το { -brand-short-name }.
certerror-what-can-you-do-about-it-title = Τι μπορείτε να κάνετε γι' αυτό;
certerror-unknown-issuer-what-can-you-do-about-it-website = Το ζήτημα οφείλεται κατά πάσα πιθανότητα στην ιστοσελίδα και δεν μπορείτε να κάνετε τίποτα για να το διορθώσετε.
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = Αν είστε σε εταιρικό δίκτυο ή χρησιμοποιείτε λογισμικό anti-virus, μπορείτε να απευθυνθείτε στις ομάδες υποστήριξης για βοήθεια. Μπορείτε επίσης να ειδοποιήσετε το διαχειριστή της ιστοσελίδας για το πρόβλημα.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = Το ρολόι του υπολογιστή σας έχει οριστεί σε { DATETIME($now, dateStyle: "medium") }. Βεβαιωθείτε ότι ο υπολογιστής σας έχει ρυθμιστεί στη σωστή ώρα, ημερομηνία και ζώνη ώρας στις ρυθμίσεις συστήματος και, έπειτα, κάντε ανανέωση του <b>{ $hostname }</b>.
certerror-expired-cert-what-can-you-do-about-it-contact-website = Αν το ρολόι έχει ήδη οριστεί στη σωστή ώρα, η ιστοσελίδα έχει πιθανότατα ρυθμιστεί εσφαλμένα και δεν μπορείτε να κάνετε τίποτα για να επιλύσετε το ζήτημα. Μπορείτε να ειδοποιήσετε το διαχειριστή της ιστοσελίδας σχετικά με το πρόβλημα.
certerror-bad-cert-domain-what-can-you-do-about-it = Το ζήτημα οφείλεται κατά πάσα πιθανότητα στον ιστότοπο και δεν μπορείτε να κάνετε τίποτα για να το διορθώσετε. Μπορείτε να ειδοποιήσετε τον διαχειριστή του ιστοτόπου σχετικά με το πρόβλημα.
certerror-mitm-what-can-you-do-about-it-antivirus = Αν το λογισμικό προστασίας σας από ιούς περιλαμβάνει κάποια λειτουργία σάρωσης κρυπτογραφημένων συνδέσεων (συχνά ονομάζεται «σάρωση web» ή «σάρωση https»), μπορείτε να την απενεργοποιήσετε. Αν δεν βοηθήσει αυτό, μπορείτε να καταργήσετε και να εγκαταστήσετε εκ νέου το λογισμικό προστασίας από ιούς.
certerror-mitm-what-can-you-do-about-it-corporate = Αν είστε σε ένα εταιρικό δίκτυο, μπορείτε να επικοινωνήσετε με το τμήμα πληροφορικής σας.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = Αν δεν γνωρίζετε το <b>{ $mitm }</b>, τότε ίσως πρόκειται για επίθεση και δεν θα πρέπει να συνεχίσετε στον ιστότοπο.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = Αν δεν γνωρίζετε το <b>{ $mitm }</b>, τότε ίσως πρόκειται για επίθεση και δεν μπορείτε να κάνετε τίποτα για να προσπελάσετε τον ιστότοπο.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = Το <b>{ $hostname }</b> έχει μια πολιτική ασφαλείας, που ονομάζεται HTTP Strict Transport Security (HSTS) και σημαίνει ότι το { -brand-short-name } μπορεί να συνδεθεί μόνο με ασφαλή τρόπο. Δεν μπορείτε να προσθέσετε μια εξαίρεση για να επισκεφθείτε αυτό τον ιστότοπο.
