# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Προέκυψε σφάλμα κατά την αποστολή της αναφοράς. Παρακαλούμε δοκιμάστε ξανά αργότερα.
# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Διορθώθηκε η ιστοσελίδα; Αποστολή αναφοράς

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Αυστηρή
    .label = Αυστηρή
protections-popup-footer-protection-label-custom = Προσαρμοσμένη
    .label = Προσαρμοσμένη
protections-popup-footer-protection-label-standard = Τυπική
    .label = Τυπική

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Περισσότερες πληροφορίες σχετικά με την Ενισχυμένη προστασία από καταγραφή
protections-panel-etp-on-header = Η Ενισχυμένη προστασία από καταγραφή είναι ΕΝΕΡΓΗ για αυτή την ιστοσελίδα
protections-panel-etp-off-header = Η Ενισχυμένη προστασία από καταγραφή είναι ΑΝΕΝΕΡΓΗ για αυτή την ιστοσελίδα
# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Δεν λειτουργεί η ιστοσελίδα;
# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Δεν λειτουργεί η ιστοσελίδα;

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Γιατί;
protections-panel-not-blocking-why-etp-on-tooltip = Ο αποκλεισμός αυτών θα μπορούσε να καταστρέψει τα στοιχεία μερικών ιστοσελίδων. Χωρίς τους ιχνηλάτες, μερικά κουμπιά, φόρμες και πεδία σύνδεσης ενδέχεται να μην λειτουργούν.
protections-panel-not-blocking-why-etp-off-tooltip = Όλοι οι ιχνηλάτες σε αυτή την ιστοσελίδα έχουν φορτωθεί επειδή η προστασία είναι ανενεργή.

##

protections-panel-no-trackers-found = Δεν εντοπίστηκαν ιχνηλάτες γνωστοί στο { -brand-short-name } σε αυτή τη σελίδα.
protections-panel-content-blocking-tracking-protection = Περιεχόμενο καταγραφής
protections-panel-content-blocking-socialblock = Ιχνηλάτες κοινωνικών δικτύων
protections-panel-content-blocking-cryptominers-label = Cryptominers
protections-panel-content-blocking-fingerprinters-label = Fingerprinters

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Αποκλείονται
protections-panel-not-blocking-label = Επιτρέπονται
protections-panel-not-found-label = Δεν εντοπίστηκαν

##

protections-panel-settings-label = Ρυθμίσεις προστασίας
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Πίνακας προστασίας

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Απενεργοποιήστε τις προστασίες αν αντιμετωπίζετε προβλήματα με τα εξής:
# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Πεδία σύνδεσης
protections-panel-site-not-working-view-issue-list-forms = Φόρμες
protections-panel-site-not-working-view-issue-list-payments = Πληρωμές
protections-panel-site-not-working-view-issue-list-comments = Σχόλια
protections-panel-site-not-working-view-issue-list-videos = Βίντεο
protections-panel-site-not-working-view-send-report = Αποστολή αναφοράς

##

protections-panel-cross-site-tracking-cookies = Αυτά τα cookies σας ακολουθούν από ιστοσελίδα σε ιστοσελίδα για να συλλέξουν δεδομένα σχετικά με το τι κάνετε στο διαδίκτυο. Δημιουργούνται από τρίτους, όπως διαφημιστές και εταιρείες ανάλυσης.
protections-panel-cryptominers = Τα cryptominers χρησιμοποιούν την υπολογιστική ισχύ του συστήματός σας για να εξορύξουν κρυπτονομίσματα. Τα σενάρια εξόρυξης κρυπτονομισμάτων εξαντλούν την μπαταρία σας, επιβραδύνουν τον υπολογιστή σας, ενώ ενδέχεται να δείτε αυξημένες χρεώσεις στο λογαριασμό τους ρεύματος.
protections-panel-fingerprinters = Τα fingerprinters συλλέγουν ρυθμίσεις από το πρόγραμμα περιήγησης και τον υπολογιστή σας για να δημιουργήσει ένα προφίλ για εσάς. Με τη χρήση αυτού του ψηφιακού αποτυπώματος, μπορούν να σας παρακολουθούν σε διάφορες ιστοσελίδες.
protections-panel-tracking-content = Οι ιστοσελίδες ενδέχεται να φορτώνουν εξωτερικές διαφημίσεις, βίντεο και άλλο περιεχόμενο με κώδικα καταγραφής. Η φραγή περιεχομένου καταγραφής μπορεί να συμβάλλει στην ταχύτερη φόρτωση των ιστοσελίδων, αλλά ορισμένα κουμπιά, φόρμες και πεδία σύνδεσης ενδέχεται να μην λειτουργούν.
protections-panel-social-media-trackers = Τα κοινωνικά δίκτυα τοποθετούν ιχνηλάτες σε άλλες ιστοσελίδες για να παρακολουθούν ό,τι κάνετε και βλέπετε στο διαδίκτυο. Αυτό επιτρέπει στις εταιρείες κοινωνικών μέσων να μάθουν περισσότερα για εσάς πέρα από αυτά που κοινοποιείτε στα προφίλ κοινωνικών μέσων.
protections-panel-description-shim-allowed = Οι παρακάτω ιχνηλάτες της σελίδας επιτρέπονται μερικώς λόγω της αλληλεπίδρασής σας μαζί τους.
protections-panel-description-shim-allowed-learn-more = Μάθετε περισσότερα
protections-panel-shim-allowed-indicator =
    .tooltiptext = Μερική άρση φραγής ιχνηλατών
protections-panel-content-blocking-manage-settings =
    .label = Διαχείριση ρυθμίσεων προστασίας
    .accesskey = Δ
protections-panel-content-blocking-breakage-report-view =
    .title = Αναφορά κατεστραμμένης ιστοσελίδας
protections-panel-content-blocking-breakage-report-view-description = Ο αποκλεισμός ορισμένων ιχνηλατών μπορεί να προκαλέσει προβλήματα με ορισμένες ιστοσελίδες. Όταν αναφέρετε τέτοια προβλήματα, συμβάλλετε στη βελτίωση του { -brand-short-name } για όλους. Με την αποστολή της αναφοράς, θα αποσταλεί ένα URL, καθώς και πληροφορίες για τις ρυθμίσεις του προγράμματος περιήγησής σας στη Mozilla. <label data-l10n-name="learn-more">Μάθετε περισσότερα</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = Προαιρετικό: Περιγράψτε το πρόβλημα
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Προαιρετικό: Περιγράψτε το πρόβλημα
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Ακύρωση
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Αποστολή αναφοράς
