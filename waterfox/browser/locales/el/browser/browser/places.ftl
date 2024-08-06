# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

places-open =
    .label = Άνοιγμα
    .accesskey = ν
places-open-in-tab =
    .label = Άνοιγμα σε νέα καρτέλα
    .accesskey = μ
places-open-in-container-tab =
    .label = Άνοιγμα σε νέα θεματική καρτέλα
    .accesskey = ι
places-open-all-bookmarks =
    .label = Άνοιγμα όλων των σελιδοδεικτών
    .accesskey = Ά
places-open-all-in-tabs =
    .label = Άνοιγμα όλων σε καρτέλες
    .accesskey = ν
places-open-in-window =
    .label = Άνοιγμα σε νέο παράθυρο
    .accesskey = ν
places-open-in-private-window =
    .label = Άνοιγμα σε νέο ιδιωτικό παράθυρο
    .accesskey = γ

places-empty-bookmarks-folder =
    .label = (Κενό)

places-add-bookmark =
    .label = Προσθήκη σελιδοδείκτη…
    .accesskey = σ
places-add-folder-contextmenu =
    .label = Προσθήκη φακέλου…
    .accesskey = φ
places-add-folder =
    .label = Προσθήκη φακέλου…
    .accesskey = θ
places-add-separator =
    .label = Προσθήκη διαχωριστικού
    .accesskey = δ

places-view =
    .label = Προβολή
    .accesskey = β
places-by-date =
    .label = Κατά ημερομηνία
    .accesskey = η
places-by-site =
    .label = Κατά ιστότοπο
    .accesskey = σ
places-by-most-visited =
    .label = Κατά συχνότητα
    .accesskey = χ
places-by-last-visited =
    .label = Κατά τελευταία επίσκεψη
    .accesskey = τ
places-by-day-and-site =
    .label = Κατά ημερομηνία και σελίδα
    .accesskey = μ

places-history-search =
    .placeholder = Αναζήτηση ιστορικού
places-history =
    .aria-label = Ιστορικό
places-bookmarks-search =
    .placeholder = Αναζήτηση σελιδοδεικτών

places-delete-domain-data =
    .label = Διαγραφή δεδομένων ιστοτόπου
    .accesskey = Δ
places-sortby-name =
    .label = Ταξινόμηση κατά όνομα
    .accesskey = ι
# places-edit-bookmark and places-edit-generic will show one or the other and can have the same access key.
places-edit-bookmark =
    .label = Επεξεργασία σελιδοδείκτη…
    .accesskey = ξ
places-edit-generic =
    .label = Επεξεργασία…
    .accesskey = ρ
places-edit-folder2 =
    .label = Επεξεργασία φακέλου…
    .accesskey = ί
places-delete-folder =
    .label =
        { $count ->
            [1] Διαγραφή φακέλου
           *[other] Διαγραφή φακέλων
        }
    .accesskey = Δ
# Variables:
#   $count (number) - The number of pages selected for removal.
places-delete-page =
    .label =
        { $count ->
            [1] Διαγραφή σελίδας
           *[other] Διαγραφή σελίδων
        }
    .accesskey = Δ

# Managed bookmarks are created by an administrator and cannot be changed by the user.
managed-bookmarks =
    .label = Διαχειριζόμενοι σελιδοδείκτες
# This label is used when a managed bookmarks folder doesn't have a name.
managed-bookmarks-subfolder =
    .label = Yποφάκελος

# This label is used for the "Other Bookmarks" folder that appears in the bookmarks toolbar.
other-bookmarks-folder =
    .label = Άλλοι σελιδοδείκτες

places-show-in-folder =
    .label = Εμφάνιση στον φάκελο
    .accesskey = φ

# Variables:
# $count (number) - The number of elements being selected for removal.
places-delete-bookmark =
    .label =
        { $count ->
            [1] Διαγραφή σελιδοδείκτη
           *[other] Διαγραφή σελιδοδεικτών
        }
    .accesskey = Δ

# Variables:
#   $count (number) - The number of bookmarks being added.
places-create-bookmark =
    .label =
        { $count ->
            [1] Προσθήκη σελιδοδείκτη…
           *[other] Προσθήκη σελιδοδεικτών…
        }
    .accesskey = Π

places-untag-bookmark =
    .label = Αφαίρεση ετικέτας
    .accesskey = Α

places-manage-bookmarks =
    .label = Διαχείριση σελιδοδεικτών
    .accesskey = Δ

places-forget-about-this-site-confirmation-title = Εξάλειψη αυτού του ιστοτόπου

# Variables:
# $hostOrBaseDomain (string) - The base domain (or host in case there is no base domain) for which data is being removed
places-forget-about-this-site-confirmation-msg = Αυτή η ενέργεια θα αφαιρέσει τα δεδομένα που σχετίζονται με το { $hostOrBaseDomain }, όπως το ιστορικό, τα cookies, την κρυφή μνήμη και τις προτιμήσεις περιεχομένου. Δεν θα διαγραφούν οι σχετικοί σελιδοδείκτες και κωδικοί πρόσβασης. Θέλετε σίγουρα να συνεχίσετε;

places-forget-about-this-site-forget = Εξάλειψη

places-library3 =
    .title = Βιβλιοθήκη

places-organize-button =
    .label = Οργάνωση
    .tooltiptext = Οργάνωση των σελιδοδεικτών σας
    .accesskey = Ο

places-organize-button-mac =
    .label = Οργάνωση
    .tooltiptext = Οργάνωση των σελιδοδεικτών σας

places-file-close =
    .label = Κλείσιμο
    .accesskey = Κ

places-cmd-close =
    .key = w

places-view-button =
    .label = Προβολές
    .tooltiptext = Αλλαγή προβολής
    .accesskey = β

places-view-button-mac =
    .label = Προβολές
    .tooltiptext = Αλλαγή προβολής

places-view-menu-columns =
    .label = Εμφάνιση στηλών
    .accesskey = φ

places-view-menu-sort =
    .label = Ταξινόμηση
    .accesskey = ξ

places-view-sort-unsorted =
    .label = Χωρίς ταξινόμηση
    .accesskey = Χ

places-view-sort-ascending =
    .label = Σειρά ταξινόμησης Α > Ω
    .accesskey = Α

places-view-sort-descending =
    .label = Σειρά ταξινόμησης Ω > Α
    .accesskey = Ω

places-maintenance-button =
    .label = Εισαγωγή και αντίγραφο
    .tooltiptext = Εισαγωγή και δημιουργία αντιγράφου ασφαλείας σελιδοδεικτών
    .accesskey = ι

places-maintenance-button-mac =
    .label = Εισαγωγή και αντίγραφο
    .tooltiptext = Εισαγωγή και δημιουργία αντιγράφου ασφαλείας σελιδοδεικτών

places-cmd-backup =
    .label = Αντίγραφο ασφαλείας…
    .accesskey = φ

places-cmd-restore =
    .label = Επαναφορά
    .accesskey = π

places-cmd-restore-from-file =
    .label = Επιλογή αρχείου…
    .accesskey = λ

places-import-bookmarks-from-html =
    .label = Εισαγωγή σελιδοδεικτών από HTML…
    .accesskey = ι

places-export-bookmarks-to-html =
    .label = Εξαγωγή σελιδοδεικτών σε HTML…
    .accesskey = ξ

places-import-other-browser =
    .label = Εισαγωγή δεδομένων από άλλο φυλλομετρητή…
    .accesskey = λ

places-view-sort-col-name =
    .label = Όνομα

places-view-sort-col-tags =
    .label = Ετικέτες

places-view-sort-col-url =
    .label = Διεύθυνση

places-view-sort-col-most-recent-visit =
    .label = Τελευταία επίσκεψη

places-view-sort-col-visit-count =
    .label = Αριθμός επισκέψεων

places-view-sort-col-date-added =
    .label = Προσθήκη

places-view-sort-col-last-modified =
    .label = Τελευταία τροποποίηση

places-view-sortby-name =
    .label = Ταξινόμηση κατά όνομα
    .accesskey = ν
places-view-sortby-url =
    .label = Ταξινόμηση κατά διεύθυνση
    .accesskey = θ
places-view-sortby-date =
    .label = Ταξινόμηση κατά ημερομηνία επίσκεψης
    .accesskey = ψ
places-view-sortby-visit-count =
    .label = Ταξινόμηση κατά αριθμό επισκέψεων
    .accesskey = θ
places-view-sortby-date-added =
    .label = Ταξινόμηση κατά σειρά προσθήκης
    .accesskey = η
places-view-sortby-last-modified =
    .label = Ταξινόμηση κατά τελευταία τροποποίηση
    .accesskey = λ
places-view-sortby-tags =
    .label = Ταξινόμηση κατά ετικέτες
    .accesskey = τ

places-cmd-find-key =
    .key = f

places-back-button =
    .tooltiptext = Επιστροφή

places-forward-button =
    .tooltiptext = Μετάβαση μπροστά

places-details-pane-select-an-item-description = Επιλέξτε ένα στοιχείο για να δείτε και να επεξεργαστείτε τις ιδιότητές του

places-details-pane-no-items =
    .value = Κανένα στοιχείο
# Variables:
#   $count (Number): number of items
places-details-pane-items-count =
    .value =
        { $count ->
            [one] Ένα στοιχείο
           *[other] { $count } στοιχεία
        }

## Strings used as a placeholder in the Library search field. For example,
## "Search History" stands for "Search through the browser's history".

places-search-bookmarks =
    .placeholder = Αναζήτηση σελιδοδεικτών
places-search-history =
    .placeholder = Αναζήτηση ιστορικού
places-search-downloads =
    .placeholder = Αναζήτηση λήψεων

##

places-locked-prompt = Το σύστημα σελιδοδεικτών και ιστορικού δεν θα λειτουργεί επειδή ένα από τα αρχεία του { -brand-short-name } χρησιμοποιείται από μια άλλη εφαρμογή. Αυτό το πρόβλημα μπορεί να οφείλεται σε κάποιο λογισμικό ασφάλειας.
