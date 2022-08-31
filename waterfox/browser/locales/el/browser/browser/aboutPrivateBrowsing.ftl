# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Άνοιγμα ιδιωτικού παραθύρου
    .accesskey = ι
about-private-browsing-search-placeholder = Αναζήτηση στο διαδίκτυο
about-private-browsing-info-title = Βρίσκεστε σε ιδιωτικό παράθυρο
about-private-browsing-search-btn =
    .title = Αναζήτηση στο διαδίκτυο
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = Αναζήτηση με { $engine } ή εισαγωγή διεύθυνσης
about-private-browsing-handoff-no-engine =
    .title = Αναζήτηση ή εισαγωγή διεύθυνσης
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = Αναζήτηση με { $engine } ή εισαγωγή διεύθυνσης
about-private-browsing-handoff-text-no-engine = Αναζήτηση ή εισαγωγή διεύθυνσης
about-private-browsing-not-private = Αυτήν τη στιγμή, δεν βρίσκεστε σε ιδιωτικό παράθυρο.
about-private-browsing-info-description-private-window = Ιδιωτικό παράθυρο: Το { -brand-short-name } διαγράφει το ιστορικό αναζητήσεων και περιήγησης όταν κλείνετε όλα τα ιδιωτικά παράθυρα. Αυτό δεν παρέχει ανωνυμία.
about-private-browsing-info-description-simplified = Το { -brand-short-name } διαγράφει το ιστορικό αναζητήσεων και περιήγησής σας όταν κλείνετε όλα τα ιδιωτικά παράθυρα, αλλά δεν σας καθιστά ανώνυμους.
about-private-browsing-learn-more-link = Μάθετε περισσότερα
about-private-browsing-hide-activity = Αποκρύψτε τη δραστηριότητα και την τοποθεσία σας, όπου κι αν περιηγείστε
about-private-browsing-get-privacy = Προστασία απορρήτου σε κάθε επίσκεψή σας
about-private-browsing-hide-activity-1 = Αποκρύψτε τη δραστηριότητα και την τοποθεσία σας με το { -mozilla-vpn-brand-name }. Με ένα κλικ έχετε ασφαλή σύνδεση, ακόμα και σε δημόσιο Wi-Fi.
about-private-browsing-prominent-cta = Προστατέψτε το απόρρητό σας με το { -mozilla-vpn-brand-name }
about-private-browsing-focus-promo-cta = Λήψη του { -focus-brand-name }
about-private-browsing-focus-promo-header = { -focus-brand-name }: Ιδιωτική περιήγηση εν κινήσει
about-private-browsing-focus-promo-text = Η εφαρμογή ιδιωτικής περιήγησής μας για κινητές συσκευές διαγράφει το ιστορικό και τα cookies σας κάθε φορά.

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = Πάρτε την ιδιωτική περιήγηση στο τηλέφωνό σας
about-private-browsing-focus-promo-text-b = Χρησιμοποιήστε το { -focus-brand-name } για τις ιδιωτικές αναζητήσεις που δεν θέλετε να βλέπει το κύριο πρόγραμμα περιήγησής σας.
about-private-browsing-focus-promo-header-c = Απόρρητο ανώτερου επιπέδου στο κινητό
about-private-browsing-focus-promo-text-c = Το { -focus-brand-name } διαγράφει το ιστορικό σας κάθε φορά, ενώ αποκλείει διαφημίσεις και ιχνηλάτες.
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = Το { $engineName } είναι η προεπιλεγμένη μηχανή αναζήτησης για ιδιωτικά παράθυρα
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] Για να επιλέξετε διαφορετική μηχανή αναζήτησης, μεταβείτε στις <a data-l10n-name="link-options">Επιλογές</a>
       *[other] Για να επιλέξετε διαφορετική μηχανή αναζήτησης, μεταβείτε στις <a data-l10n-name="link-options">Προτιμήσεις</a>
    }
about-private-browsing-search-banner-close-button =
    .aria-label = Κλείσιμο
about-private-browsing-promo-close-button =
    .title = Κλείσιμο

## Strings used in a “pin promotion” message, which prompts users to pin a private window

about-private-browsing-pin-promo-header = Ελευθερία ιδιωτικής περιήγησης με ένα κλικ
about-private-browsing-pin-promo-link-text =
    { PLATFORM() ->
        [macos] Διατήρηση στο Dock
       *[other] Καρφίτσωμα στη γραμμή εργασιών
    }
about-private-browsing-pin-promo-title = Χωρίς αποθήκευση cookies ή ιστορικού, απευθείας από την επιφάνεια εργασίας σας. Περιηγηθείτε σαν να μην σας παρακολουθεί κανείς.
