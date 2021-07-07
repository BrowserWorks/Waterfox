# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] Το { -brand-short-name } απέκλεισε { $count } ιχνηλάτη την προηγούμενη εβδομάδα
       *[other] Το { -brand-short-name } απέκλεισε { $count } ιχνηλάτες την προηγούμενη εβδομάδα
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] Αποκλείστηκε <b>{ $count }</b> ιχνηλάτης από τις { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] Αποκλείστηκαν <b>{ $count }</b> ιχνηλάτες από τις { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = Το { -brand-short-name } συνεχίζει να αποκλείει τους ιχνηλάτες στα ιδιωτικά παράθυρα, αλλά δεν διατηρείται αρχείο καταγραφής των αποκλεισμένων στοιχείων.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Αποκλεισμένοι ιχνηλάτες στο { -brand-short-name } αυτήν την εβδομάδα

protection-report-webpage-title = Πίνακας προστασίας
protection-report-page-content-title = Πίνακας προστασίας
# This message shows when all privacy protections are turned off, which is why we use the word "can", Waterfox is able to protect your privacy, but it is currently not.
protection-report-page-summary = Το { -brand-short-name } μπορεί να προστατεύει το απόρρητό σας στο παρασκήνιο, ενώ περιηγείστε. Ορίστε μια εξατομικευμένη περίληψη αυτών των μεθόδων προστασίας, καθώς και τα εργαλεία για να αποκτήσετε τον έλεγχο της διαδικτυακής σας ασφάλειας.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Waterfox is actively protecting you.
protection-report-page-summary-default = Το { -brand-short-name } προστατεύει το απόρρητό σας στο παρασκήνιο, ενώ περιηγείστε. Ορίστε μια εξατομικευμένη περίληψη αυτών των μεθόδων προστασίας, καθώς και τα εργαλεία για να αποκτήσετε τον έλεγχο της διαδικτυακής σας ασφάλειας.

protection-report-settings-link = Διαχείριση ρυθμίσεων απορρήτου και ασφαλείας

etp-card-title-always = Ενισχυμένη προστασία από καταγραφή: Πάντα ενεργή
etp-card-title-custom-not-blocking = Ενισχυμένη προστασία από καταγραφή: Ανενεργή
etp-card-content-description = Το { -brand-short-name } σταματά αυτόματα τις εταιρείες που σας παρακολουθούν κρυφά στο διαδίκτυο.
protection-report-etp-card-content-custom-not-blocking = Όλες οι μέθοδοι προστασίας είναι ανενεργές. Επιλέξτε ποιοι ιχνηλάτες θα αποκλείονται από τις ρυθμίσεις προστασίας του { -brand-short-name }.
protection-report-manage-protections = Διαχείριση ρυθμίσεων

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Σήμερα

# This string is used to describe the graph for screenreader users.
graph-legend-description = Ένα γράφημα με το συνολικό αριθμό κάθε τύπου ιχνηλάτη που έχει αποκλειστεί αυτή την εβδομάδα.

social-tab-title = Ιχνηλάτες κοινωνικών δικτύων
social-tab-contant = Τα κοινωνικά δίκτυα τοποθετούν ιχνηλάτες σε άλλες ιστοσελίδες για να παρακολουθούν ό,τι κάνετε και βλέπετε στο διαδίκτυο. Αυτό επιτρέπει στις εταιρείες κοινωνικών μέσων να μάθουν περισσότερα για εσάς πέρα από αυτά που κοινοποιείτε στα προφίλ κοινωνικών μέσων σας. <a data-l10n-name="learn-more-link">Μάθετε περισσότερα</a>

cookie-tab-title = Cookies καταγραφής μεταξύ ιστοτόπων
cookie-tab-content = Αυτά τα cookies σάς ακολουθούν από ιστότοπο σε ιστότοπο για να συλλέξουν δεδομένα για ό,τι κάνετε στο διαδίκτυο. Δημιουργούνται από τρίτους, όπως διαφημιστές και εταιρείες ανάλυσης. Η φραγή των cookies καταγραφής μεταξύ ιστοτόπων μειώνει τον αριθμό των διαφημίσεων που σας καταγράφουν. <a data-l10n-name="learn-more-link">Μάθετε περισσότερα</a>

tracker-tab-title = Περιεχόμενο καταγραφής
tracker-tab-description = Οι ιστότοποι ενδέχεται να φορτώσουν εξωτερικές διαφημίσεις, βίντεο και άλλο περιεχόμενο με κώδικα καταγραφής. Η φραγή περιεχομένου καταγραφής μπορεί να συμβάλει στην ταχύτερη φόρτωση ιστοτόπων, αλλά ορισμένα κουμπιά, φόρμες και πεδία σύνδεσης ενδέχεται να μην λειτουργούν. <a data-l10n-name="learn-more-link">Μάθετε περισσότερα</a>

fingerprinter-tab-title = Fingerprinters
fingerprinter-tab-content = Τα fingerprinter συλλέγουν ρυθμίσεις από το πρόγραμμα περιήγησης και τον υπολογιστή σας για να δημιουργήσουν ένα προφίλ για εσάς. Με τη χρήση αυτού του ψηφιακού αποτυπώματος, μπορούν να σας καταγράφουν σε διάφορους ιστοτόπους. <a data-l10n-name="learn-more-link">Μάθετε περισσότερα</a>

cryptominer-tab-title = Cryptominers
cryptominer-tab-content = Τα cryptominers χρησιμοποιούν την υπολογιστική ισχύ του συστήματός σας για να κάνουν εξόρυξη κρυπτονομισμάτων. Τα σενάρια εξόρυξης κρυπτονομισμάτων καταναλώνουν μπαταρία, επιβραδύνουν τον υπολογιστή σας, ενώ ενδέχεται να δείτε αυξημένες χρεώσεις στο λογαριασμό τους ρεύματός σας. <a data-l10n-name="learn-more-link">Μάθετε περισσότερα</a>

protections-close-button2 =
    .aria-label = Κλείσιμο
    .title = Κλείσιμο

mobile-app-title = Φραγή ιχνηλατών διαφημίσεων σε περισσότερες συσκευές
mobile-app-card-content = Χρησιμοποιήστε το πρόγραμμα περιήγησης για κινητές συσκευές με ενσωματωμένη προστασία από την καταγραφή διαφημίσεων.
mobile-app-links = Πρόγραμμα περιήγησης { -brand-product-name } για <a data-l10n-name="android-mobile-inline-link">Android</a> και <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Φύλαξη κωδικών πρόσβασης
lockwise-title-logged-in2 = Διαχείριση κωδικών πρόσβασης
lockwise-header-content = Το { -lockwise-brand-name } αποθηκεύει με ασφάλεια τους κωδικούς πρόσβασης στον φυλλομετρητή σας.
lockwise-header-content-logged-in = Αποθηκεύστε και συγχρονίστε με ασφάλεια τους κωδικούς πρόσβασής σας σε όλες τις συσκευές σας.
protection-report-save-passwords-button = Αποθήκευση κωδικών πρόσβασης
    .title = Αποθήκευση κωδικών πρόσβασης στο { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Διαχείριση κωδικών πρόσβασης
    .title = Διαχείριση κωδικών πρόσβασης στο { -lockwise-brand-short-name }
lockwise-mobile-app-title = Πάρτε τους κωδικούς πρόσβασής σας παντού
lockwise-no-logins-card-content = Χρησιμοποιήστε τους αποθηκευμένους κωδικούς πρόσβασης του { -brand-short-name } σε όλες τις συσκευές.
lockwise-app-links = { -lockwise-brand-name } για <a data-l10n-name="lockwise-android-inline-link">Android</a> και <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 κωδικός πρόσβασης ενδέχεται να έχει εκτεθεί σε παραβίαση δεδομένων.
       *[other] { $count } κωδικοί πρόσβασης ενδέχεται να έχουν εκτεθεί σε παραβίαση δεδομένων.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 κωδικός πρόσβασης αποθηκεύτηκε με ασφάλεια.
       *[other] Οι κωδικοί πρόσβασής σας αποθηκεύτηκαν με ασφάλεια.
    }
lockwise-how-it-works-link = Πώς λειτουργεί

monitor-title = Εποπτεία παραβιάσεων δεδομένων
monitor-link = Πώς λειτουργεί
monitor-header-content-no-account = Ελέγξτε το { -monitor-brand-name } για να δείτε αν έχετε επηρεαστεί από γνωστή παραβίαση δεδομένων και λάβετε ειδοποιήσεις σχετικά με νέες παραβιάσεις.
monitor-header-content-signed-in = Το { -monitor-brand-name } σας προειδοποιεί αν οι πληροφορίες σας έχουν εμφανιστεί σε παραβίαση δεδομένων.
monitor-sign-up-link = Ειδοποίηση για παραβιάσεις
    .title = Εγγραφή για ειδοποιήσεις παραβιάσεων στο { -monitor-brand-name }
auto-scan = Έγινε αυτόματη σάρωση σήμερα

monitor-emails-tooltip =
    .title = Προβολή διευθύνσεων email υπό εποπτεία στο { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Προβολή γνωστών παραβιάσεων δεδομένων στο { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Προβολή εκτεθειμένων κωδικών πρόσβασης στο { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] διεύθυνση email υπό εποπτεία
       *[other] διευθύνσεις email υπό εποπτεία
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] γνωστή παραβίαση δεδομένων έχει εκθέσει τις πληροφορίες σας
       *[other] γνωστές παραβιάσεις δεδομένων έχουν εκθέσει τις πληροφορίες σας
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Γνωστή παραβίαση δεδομένων επισημάνθηκε ως επιλυμένη
       *[other] Γνωστές παραβιάσεις δεδομένων επισημάνθηκαν ως επιλυμένες
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] κωδικός πρόσβασης έχει εκτεθεί σε όλες τις παραβιάσεις
       *[other] κωδικοί πρόσβασης έχουν εκτεθεί σε όλες τις παραβιάσεις
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Εκτεθειμένος κωδικός πρόσβασης σε μη επιλυμένες παραβιάσεις
       *[other] Εκτεθειμένοι κωδικοί πρόσβασης σε μη επιλυμένες παραβιάσεις
    }

monitor-no-breaches-title = Καλά νέα!
monitor-no-breaches-description = Δεν έχετε γνωστές παραβιάσεις. Αν αλλάξει αυτό, θα σας ενημερώσουμε.
monitor-view-report-link = Προβολή αναφοράς
    .title = Επίλυση παραβιάσεων στο { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Επίλυση παραβιάσεων
monitor-breaches-unresolved-description = Αφού ελέγξετε τις λεπτομέρειες παραβίασης και λάβετε μέτρα για την προστασία των πληροφοριών σας, μπορείτε να επισημάνετε τις παραβιάσεις ως επιλυμένες.
monitor-manage-breaches-link = Διαχείριση παραβιάσεων
    .title = Διαχείριση παραβιάσεων στο { -monitor-brand-short-name }
monitor-breaches-resolved-title = Ωραία! Επιλύσατε όλες τις γνωστές παραβιάσεις.
monitor-breaches-resolved-description = Αν το email σας εμφανιστεί σε νέες παραβιάσεις, θα σας ενημερώσουμε.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreachesResolved } από { $numBreaches } παραβίαση επισημάνθηκε ως επιλυμένη
       *[other] { $numBreachesResolved }από { $numBreaches } παραβιάσεις επισημάνθηκαν ως επιλυμένες
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% ολοκλήρωση

monitor-partial-breaches-motivation-title-start = Τέλεια αρχή!
monitor-partial-breaches-motivation-title-middle = Συνεχίστε!
monitor-partial-breaches-motivation-title-end = Σχεδόν τελειώσατε! Συνεχίστε.
monitor-partial-breaches-motivation-description = Επιλύστε τις υπόλοιπες παραβιάσεις σας στο { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Επίλυση παραβιάσεων
    .title = Επίλυση παραβιάσεων στο { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Ιχνηλάτες κοινωνικών δικτύων
    .aria-label =
        { $count ->
            [one] { $count } ιχνηλάτης κοινωνικών δικτύων ({ $percentage }%)
           *[other] { $count } ιχνηλάτες κοινωνικών δικτύων { $percentage }%)
        }
bar-tooltip-cookie =
    .title = Cookies καταγραφής μεταξύ ιστοτόπων
    .aria-label =
        { $count ->
            [one] { $count } cookie καταγραφής μεταξύ ιστοτόπων ({ $percentage }%)
           *[other] { $count } cookies καταγραφής μεταξύ ιστοτόπων ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Περιεχόμενο καταγραφής
    .aria-label =
        { $count ->
            [one] { $count } περιεχόμενο καταγραφής ({ $percentage }%)
           *[other] { $count } περιεχόμενα καταγραφής ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Fingerprinters
    .aria-label =
        { $count ->
            [one] { $count } fingerprinter ({ $percentage }%)
           *[other] { $count } fingerprinters ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Cryptominers
    .aria-label =
        { $count ->
            [one] { $count } cryptominer ({ $percentage }%)
           *[other] { $count } cryptominers ({ $percentage }%)
        }
