# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title = Σχετικά με το { -brand-full-name }

releaseNotes-link = Τι νέο υπάρχει

update-checkForUpdatesButton =
    .label = Έλεγχος για ενημερώσεις
    .accesskey = Έ

update-updateButton =
    .label = Επανεκκίνηση για ενημέρωση του { -brand-shorter-name }
    .accesskey = Ε

update-checkingForUpdates = Έλεγχος για ενημερώσεις…

## Variables:
##   $transfer (string) - Transfer progress.

settings-update-downloading = <img data-l10n-name="icon"/>Λήψη ενημέρωσης — <label data-l10n-name="download-status">{ $transfer }</label>
aboutdialog-update-downloading = Λήψη ενημέρωσης — <label data-l10n-name="download-status">{ $transfer }</label>

##

update-applying = Εφαρμογή ενημέρωσης…

update-failed = Αποτυχία ενημέρωσης. <label data-l10n-name="failed-link">Λήψη της πιο πρόσφατης έκδοσης</label>
update-failed-main = Αποτυχία ενημέρωσης. <a data-l10n-name="failed-link-main">Λήψη της πιο πρόσφατης έκδοσης</a>

update-adminDisabled = Οι ενημερώσεις έχουν απενεργοποιηθεί από τον διαχειριστή του συστήματος σας
update-noUpdatesFound = Το { -brand-short-name } είναι ενημερωμένο
aboutdialog-update-checking-failed = Ο έλεγχος για ενημερώσεις απέτυχε.
update-otherInstanceHandlingUpdates = Το { -brand-short-name } ενημερώνεται από μια άλλη διεργασία

## Variables:
##   $displayUrl (String): URL to page with download instructions. Example: www.mozilla.org/firefox/nightly/

aboutdialog-update-manual-with-link = Διαθέσιμες ενημερώσεις στο <label data-l10n-name="manual-link">{ $displayUrl }</label>
settings-update-manual-with-link = Διαθέσιμες ενημερώσεις στο <a data-l10n-name="manual-link">{ $displayUrl }</a>

update-unsupported = Δεν μπορείτε να εκτελέσετε περαιτέρω ενημερώσεις σε αυτό το σύστημα. <label data-l10n-name="unsupported-link">Μάθετε περισσότερα</label>

update-restarting = Επανεκκίνηση…

update-internal-error2 = Δεν είναι δυνατός ο έλεγχος για ενημερώσεις λόγω εσωτερικού σφάλματος. Οι ενημερώσεις διατίθενται στο <label data-l10n-name="manual-link">{ $displayUrl }</label>

##

# Variables:
#   $channel (String): description of the update channel (e.g. "release", "beta", "nightly" etc.)
aboutdialog-channel-description = Αυτήν τη στιγμή, βρίσκεστε στο κανάλι ενημερώσεων της έκδοσης <label data-l10n-name="current-channel">{ $channel }</label>.

warningDesc-version = Το { -brand-short-name } είναι σε πειραματικό στάδιο και πιθανότατα ασταθές.

aboutdialog-help-user = Βοήθεια { -brand-product-name }
aboutdialog-submit-feedback = Υποβολή σχολίων

community-exp = Η <label data-l10n-name="community-exp-mozillaLink">{ -vendor-short-name }</label> είναι μια <label data-l10n-name="community-exp-creditsLink">παγκόσμια κοινότητα</label> που συνεργάζεται για να κάνει το διαδίκτυο ανοικτό, ελεύθερο και προσβάσιμο από όλους.

community-2 = Το { -brand-short-name } έχει σχεδιαστεί από τη <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label>, μια <label data-l10n-name="community-creditsLink">παγκόσμια κοινότητα</label> που συνεργάζεται για να κάνει το διαδίκτυο ανοικτό, ελεύθερο και προσβάσιμο από όλους χωρίς κανένα περιορισμό.

helpus = Θέλετε να βοηθήσετε; <label data-l10n-name="helpus-donateLink">Κάντε μια δωρεά</label> ή <label data-l10n-name="helpus-getInvolvedLink">συμμετέχετε εθελοντικά!</label>

bottomLinks-license = Πληροφορίες άδειας
bottomLinks-rights = Δικαιώματα χρήστη
bottomLinks-privacy = Πολιτική απορρήτου

# Example of resulting string: 66.0.1 (64-bit)
# Variables:
#   $version (String): version of Waterfox, e.g. 66.0.1
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version = { $version } ({ $bits }-bit)

# Example of resulting string: 66.0a1 (2019-01-16) (64-bit)
# Variables:
#   $version (String): version of Waterfox for Nightly builds, e.g. 66.0a1
#   $isodate (String): date in ISO format, e.g. 2019-01-16
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version-nightly = { $version } ({ $isodate }) ({ $bits }-bit)
