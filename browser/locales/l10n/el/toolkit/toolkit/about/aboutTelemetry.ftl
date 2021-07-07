# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Πηγή δεδομένων ping:
about-telemetry-show-current-data = Τρέχοντα δεδομένα
about-telemetry-show-archived-ping-data = Αρχειοθετημένα δεδομένα ping
about-telemetry-show-subsession-data = Εμφάνιση δεδομένων υποσυνεδρίας
about-telemetry-choose-ping = Επιλογή ping:
about-telemetry-archive-ping-type = Τύπος ping
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Σήμερα
about-telemetry-option-group-yesterday = Χθες
about-telemetry-option-group-older = Παλαιότερα
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Δεδομένα τηλεμετρίας
about-telemetry-current-store = Τρέχον αποθετήριο:
about-telemetry-more-information = Ψάχνετε περισσότερες πληροφορίες;
about-telemetry-firefox-data-doc = Η <a data-l10n-name="data-doc-link">τεκμηρίωση δεδομένων του Waterfox</a> περιέχει οδηγίες σχετικά με το πώς να εργαστείτε με τα εργαλεία δεδομένων μας.
about-telemetry-telemetry-client-doc = Η <a data-l10n-name="client-doc-link">τεκμηρίωση πελάτη τηλεμετρίας του Waterfox</a> περιλαμβάνει ορισμούς για ιδέες, τεκμηρίωση API και αναφορές δεδομένων.
about-telemetry-telemetry-dashboard = Οι <a data-l10n-name="dashboard-link">πίνακες τηλεμετρίας</a> σάς επιτρέπουν να βλέπετε τα δεδομένα που λαμβάνει η Waterfox μέσω της τηλεμετρίας.
about-telemetry-telemetry-probe-dictionary = Το <a data-l10n-name="probe-dictionary-link">λεξικό ερευνών</a> παρέχει λεπτομέρειες και περιγραφές για τις έρευνες που συλλέχθηκαν από την Τηλεμετρία.
about-telemetry-show-in-Waterfox-json-viewer = Άνοιγμα στην προβολή JSON
about-telemetry-home-section = Αρχική
about-telemetry-general-data-section = Γενικά δεδομένα
about-telemetry-environment-data-section = Δεδομένα περιβάλλοντος
about-telemetry-session-info-section = Πληροφορίες συνεδρίας
about-telemetry-scalar-section = Μονόμετρα μεγέθη
about-telemetry-keyed-scalar-section = Μονόμετρα μεγέθη με κλειδί
about-telemetry-histograms-section = Ιστογράμματα
about-telemetry-keyed-histogram-section = Ιστογράμματα με κλειδί
about-telemetry-events-section = Συμβάντα
about-telemetry-simple-measurements-section = Απλές μετρήσεις
about-telemetry-slow-sql-section = Αργές εντολές SQL
about-telemetry-addon-details-section = Λεπτομέρειες προσθέτου
about-telemetry-captured-stacks-section = Κατειλημμένες Στοίβες
about-telemetry-late-writes-section = Καθυστερημένες εγγραφές
about-telemetry-raw-payload-section = Ακατέργαστο ωφέλιμο φορτίο
about-telemetry-raw = Ακατέργαστη JSON
about-telemetry-full-sql-warning = ΣΗΜΕΙΩΣΗ: Ο αργός έλεγχος σφαλμάτων SQL είναι ενεργός. Τα πλήρη αλφαριθμητικά SQL ενδέχεται να εμφανίζονται παρακάτω, αλλά δεν θα υποβάλλονται στην Τηλεμετρία.
about-telemetry-fetch-stack-symbols = Λήψη ονομάτων συναρτήσεων για στοίβες
about-telemetry-hide-stack-symbols = Εμφάνιση ακατέργαστων δεδομένων στοίβας
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] δεδομένα έκδοσης
       *[prerelease] δεδομένα προ-έκδοσης
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] ενεργή
       *[disabled] ανενεργή
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } δείγμα, μέσος όρος = { $prettyAverage }, σύνολο = { $sum }
       *[other] { $sampleCount } δείγματα, μέσος όρος = { $prettyAverage }, σύνολο = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Waterfox"
about-telemetry-page-subtitle = Αυτή η σελίδα εμφανίζει τα δεδομένα συμπεριφοράς και χρήσης των λειτουργιών που συλλέγονται από την Τηλεμετρία. Αυτές οι πληροφορίες υποβάλλονται ανώνυμα στο { $telemetryServerOwner } και μας βοηθούν να βελτιώσουμε τον { -brand-full-name }.
about-telemetry-settings-explanation = Η τηλεμετρία συλλέγει { about-telemetry-data-type } και η μεταφόρτωση είναι <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Κάθε κομμάτι πληροφορίας αποστέλλεται πακεταρισμένο σε “<a data-l10n-name="ping-link">pings</a>”. Βλέπετε το ping { $name }, { $timestamp }.
about-telemetry-data-details-current = Κάθε κομμάτι πληροφορίας αποστέλλεται πακεταρισμένο σε “<a data-l10n-name="ping-link">pings</a>”. Βλέπετε τα τρέχοντα δεδομένα.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Εύρεση στο { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Εύρεση σε όλες τις ενότητες
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Αποτελέσματα για “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Συγγνώμη! Δεν υπάρχουν αποτελέσματα στην ενότητα “{ $sectionName }” για “{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Λυπούμαστε! Δεν υπάρχουν αποτελέσματα σε κανένα τμήμα για “{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Λυπούμαστε! Δεν υπάρχουν διαθέσιμα δεδομένα στο “{ $sectionName }”
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = τρέχοντα δεδομένα
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = όλα
# button label to copy the histogram
about-telemetry-histogram-copy = Αντιγραφή
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Εντολές αργής SQL στο κύριο νήμα
about-telemetry-slow-sql-other = Εντολές αργής SQL στα νήματα βοήθειας
about-telemetry-slow-sql-hits = Συμβάντα
about-telemetry-slow-sql-average = Μέσος χρόνος (ms)
about-telemetry-slow-sql-statement = Εντολή
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID προσθέτου
about-telemetry-addon-table-details = Λεπτομέρειες
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Πάροχος { $addonProvider }
about-telemetry-keys-header = Ιδιότητα
about-telemetry-names-header = Όνομα
about-telemetry-values-header = Τιμή
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (μέτρηση καταλήψεων: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Καθυστερημένη εγγραφή #{ $lateWriteCount }
about-telemetry-stack-title = Στοίβα:
about-telemetry-memory-map-title = Χάρτης μνήμης:
about-telemetry-error-fetching-symbols = Προέκυψε σφάλμα κατά την λήψη συμβόλων. Βεβαιωθείτε ότι είστε συνδεδεμένοι στο διαδίκτυο και προσπαθήστε ξανά.
about-telemetry-time-stamp-header = χρονική σήμανση
about-telemetry-category-header = κατηγορία
about-telemetry-method-header = μέθοδος
about-telemetry-object-header = αντικείμενο
about-telemetry-extra-header = επιπλέον
about-telemetry-origin-section = Origin Telemetry
about-telemetry-origin-origin = προέλευση
about-telemetry-origin-count = μέτρηση
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Waterfox"
about-telemetry-origins-explanation = Το <a data-l10n-name="origin-doc-link">Waterfox Origin Telemetry</a> κωδικοποιεί τα δεδομένα πριν αποσταλούν έτσι, ώστε η { $telemetryServerOwner } να μπορέσει να μετρήσει πράγματα, αλλά δεν θα γνωρίζει αν συνεισέφερε το παρόν { -brand-product-name } σε αυτή τη μέτρηση. (<a data-l10n-name="prio-blog-link">Μάθετε περισσότερα</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = Διεργασία { $process }
