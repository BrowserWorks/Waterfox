# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Waterfox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Νέα καρτέλα
newtab-settings-button =
    .title = Προσαρμογή της σελίδας Νέας Καρτέλας
newtab-personalize-icon-label =
    .title = Εξατομίκευση νέας καρτέλας
    .aria-label = Εξατομίκευση νέας καρτέλας
newtab-personalize-dialog-label =
    .aria-label = Εξατομίκευση

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Αναζήτηση
    .aria-label = Αναζήτηση
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-text = Αναζήτηση με { $engine } ή εισαγωγή διεύθυνσης
newtab-search-box-handoff-text-no-engine = Αναζήτηση ή εισαγωγή διεύθυνσης
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-input =
    .placeholder = Αναζήτηση με { $engine } ή εισαγωγή διεύθυνσης
    .title = Αναζήτηση με { $engine } ή εισαγωγή διεύθυνσης
    .aria-label = Αναζήτηση με { $engine } ή εισαγωγή διεύθυνσης
newtab-search-box-handoff-input-no-engine =
    .placeholder = Αναζήτηση ή εισαγωγή διεύθυνσης
    .title = Αναζήτηση ή εισαγωγή διεύθυνσης
    .aria-label = Αναζήτηση ή εισαγωγή διεύθυνσης
newtab-search-box-search-the-web-input =
    .placeholder = Αναζήτηση στο διαδίκτυο
    .title = Αναζήτηση στο διαδίκτυο
    .aria-label = Αναζήτηση στο διαδίκτυο
newtab-search-box-text = Αναζήτηση στο διαδίκτυο
newtab-search-box-input =
    .placeholder = Αναζήτηση στο διαδίκτυο
    .aria-label = Αναζήτηση στο διαδίκτυο

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Προσθήκη μηχανής αναζήτησης
newtab-topsites-add-topsites-header = Νέος κορυφαίος ιστότοπος
newtab-topsites-add-shortcut-header = Νέα συντόμευση
newtab-topsites-edit-topsites-header = Επεξεργασία κορυφαίου ιστοτόπου
newtab-topsites-edit-shortcut-header = Επεξεργασία συντόμευσης
newtab-topsites-title-label = Τίτλος
newtab-topsites-title-input =
    .placeholder = Εισαγωγή τίτλου
newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Εισαγωγή ή επικόλληση URL
newtab-topsites-url-validation = Απαιτείται έγκυρο URL
newtab-topsites-image-url-label = URL προσαρμοσμένης εικόνας
newtab-topsites-use-image-link = Χρήση προσαρμοσμένης εικόνας…
newtab-topsites-image-validation = Αποτυχία φόρτωσης εικόνας. Δοκιμάστε ένα διαφορετικό URL.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Ακύρωση
newtab-topsites-delete-history-button = Διαγραφή
newtab-topsites-save-button = Αποθήκευση
newtab-topsites-preview-button = Προεπισκόπηση
newtab-topsites-add-button = Προσθήκη

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Θέλετε σίγουρα να διαγράψετε κάθε παρουσία της σελίδας από το ιστορικό σας;
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Δεν είναι δυνατή η αναίρεση αυτής της ενέργειας.

## Top Sites - Sponsored label

newtab-topsite-sponsored = Χορηγία

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Άνοιγμα μενού
    .aria-label = Άνοιγμα μενού
# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Αφαίρεση
    .aria-label = Αφαίρεση
# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Άνοιγμα μενού
    .aria-label = Άνοιγμα μενού επιλογών για το { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Επεξεργασία ιστοτόπου
    .aria-label = Επεξεργασία ιστοτόπου

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Επεξεργασία
newtab-menu-open-new-window = Άνοιγμα σε νέο παράθυρο
newtab-menu-open-new-private-window = Άνοιγμα σε νέο ιδιωτικό παράθυρο
newtab-menu-dismiss = Απόρριψη
newtab-menu-pin = Καρφίτσωμα
newtab-menu-unpin = Ξεκαρφίτσωμα
newtab-menu-delete-history = Διαγραφή από ιστορικό
newtab-menu-save-to-pocket = Αποθήκευση στο { -pocket-brand-name }
newtab-menu-delete-pocket = Διαγραφή από το { -pocket-brand-name }
newtab-menu-archive-pocket = Αρχειοθέτηση στο { -pocket-brand-name }
newtab-menu-show-privacy-info = Οι χορηγοί μας & το απόρρητό σας

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Τέλος
newtab-privacy-modal-button-manage = Διαχείριση ρυθμίσεων χορηγούμενου περιεχομένου
newtab-privacy-modal-header = Το απόρρητό σας έχει σημασία.
newtab-privacy-modal-paragraph-2 =
    Εκτός από την παράδοση μαγευτικών ιστοριών, σας εμφανίζουμε σχετικό,
    υψηλής ποιότητας περιεχόμενο από επιλεγμένους χορηγούς. Μην ανησυχείτε, <strong>τα δεδομένα
    περιήγησής σας δεν φεύγουν ποτέ από το προσωπικό σας αντίγραφο του { -brand-product-name }</strong> — δεν τα βλέπουμε ούτε εμείς, ούτε
    οι χορηγοί μας.
newtab-privacy-modal-link = Μάθετε πώς λειτουργεί το απόρρητο στη νέα καρτέλα

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Αφαίρεση σελιδοδείκτη
# Bookmark is a verb here.
newtab-menu-bookmark = Προσθήκη σελιδοδείκτη

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Αντιγραφή συνδέσμου λήψης
newtab-menu-go-to-download-page = Μετάβαση στη σελίδα λήψης
newtab-menu-remove-download = Αφαίρεση από το ιστορικό

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Εμφάνιση στο Finder
       *[other] Άνοιγμα φακέλου λήψης
    }
newtab-menu-open-file = Άνοιγμα αρχείου

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Από ιστορικό
newtab-label-bookmarked = Από σελιδοδείκτες
newtab-label-removed-bookmark = Ο σελιδοδείκτης αφαιρέθηκε
newtab-label-recommended = Τάσεις
newtab-label-saved = Αποθηκεύτηκε στο { -pocket-brand-name }
newtab-label-download = Λήψεις
# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Χορηγία
# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Χορηγία από { $sponsor }
# This string is used under the image of story cards to indicate source and time to read
# Variables:
#  $source (String): This is the name of a company or their domain
#  $timeToRead (Number): This is the estimated number of minutes to read this story
newtab-label-source-read-time = { $source } · { $timeToRead } λεπ.

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Αφαίρεση ενότητας
newtab-section-menu-collapse-section = Σύμπτυξη ενότητας
newtab-section-menu-expand-section = Επέκταση ενότητας
newtab-section-menu-manage-section = Διαχείριση ενότητας
newtab-section-menu-manage-webext = Διαχείριση επέκτασης
newtab-section-menu-add-topsite = Προσθήκη κορυφαίου ιστοτόπου
newtab-section-menu-add-search-engine = Προσθήκη μηχανής αναζήτησης
newtab-section-menu-move-up = Μετακίνηση πάνω
newtab-section-menu-move-down = Μετακίνηση κάτω
newtab-section-menu-privacy-notice = Σημείωση απορρήτου

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Σύμπτυξη ενότητας
newtab-section-expand-section-label =
    .aria-label = Επέκταση ενότητας

## Section Headers.

newtab-section-header-topsites = Κορυφαίοι ιστότοποι
newtab-section-header-highlights = Κορυφαίες στιγμές
newtab-section-header-recent-activity = Πρόσφατη δραστηριότητα
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Προτάσεις του { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Ξεκινήστε την περιήγηση και θα σας δείξουμε μερικά υπέροχα άρθρα, βίντεο και άλλες σελίδες που έχετε επισκεφθεί πρόσφατα ή έχετε προσθέσει στους σελιδοδείκτες σας.
# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Δεν υπάρχει κάτι νεότερο. Ελέγξτε αργότερα για περισσότερες ιστορίες από τον πάροχο { $provider }. Δεν μπορείτε να περιμένετε; Διαλέξτε κάποιο από τα δημοφιλή θέματα και ανακαλύψτε ενδιαφέρουσες ιστορίες από όλο τον Ιστό.

## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Τελειώσατε!
newtab-discovery-empty-section-topstories-content = Ελέγξτε ξανά αργότερα για περισσότερες ιστορίες.
newtab-discovery-empty-section-topstories-try-again-button = Δοκιμή ξανά
newtab-discovery-empty-section-topstories-loading = Φόρτωση…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Ωχ! Αυτή η ενότητα σχεδόν φορτώθηκε, αλλά όχι πλήρως.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Δημοφιλή θέματα:
newtab-pocket-new-topics-title = Θέλετε περισσότερα άρθρα; Δείτε αυτά τα δημοφιλή θέματα από το { -pocket-brand-name }
newtab-pocket-more-recommendations = Περισσότερες προτάσεις
newtab-pocket-learn-more = Μάθετε περισσότερα
newtab-pocket-cta-button = Αποκτήστε το { -pocket-brand-name }
newtab-pocket-cta-text = Αποθηκεύστε τις ιστορίες που αγαπάτε στο { -pocket-brand-name } και τροφοδοτήστε το μυαλό σας με εκπληκτικά κείμενα.
newtab-pocket-pocket-firefox-family = Το { -pocket-brand-name } ανήκει στην οικογένεια του { -brand-product-name }
# A save to Pocket button that shows over the card thumbnail on hover.
newtab-pocket-save-to-pocket = Αποθήκευση στο { -pocket-brand-name }
newtab-pocket-saved-to-pocket = Αποθηκεύτηκε στο { -pocket-brand-name }
# This is a button shown at the bottom of the Pocket section that loads more stories when clicked.
newtab-pocket-load-more-stories-button = Φόρτωση περισσότερων άρθρων

## Pocket Final Card Section.
## This is for the final card in the Pocket grid.

newtab-pocket-last-card-title = Τελειώσατε!
newtab-pocket-last-card-desc = Ελέγξτε ξανά αργότερα για περισσότερα.
newtab-pocket-last-card-image =
    .alt = Τελειώσατε!

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Ωχ, κάτι πήγε στραβά κατά τη φόρτωση του περιεχομένου.
newtab-error-fallback-refresh-link = Ανανεώστε τη σελίδα για να δοκιμάσετε ξανά.

## Customization Menu

newtab-custom-shortcuts-title = Συντομεύσεις
newtab-custom-shortcuts-subtitle = Ιστότοποι από σελιδοδείκτες ή ιστορικό
newtab-custom-row-selector =
    { $num ->
        [one] { $num } σειρά
       *[other] { $num } σειρές
    }
newtab-custom-sponsored-sites = Χορηγούμενες συντομεύσεις
newtab-custom-pocket-title = Προτείνεται από το { -pocket-brand-name }
newtab-custom-pocket-subtitle = Εξαιρετικό περιεχόμενο από το { -pocket-brand-name }, μέρος της οικογένειας του { -brand-product-name }
newtab-custom-pocket-sponsored = Χορηγούμενα άρθρα
newtab-custom-recent-title = Πρόσφατη δραστηριότητα
newtab-custom-recent-subtitle = Συλλογή πρόσφατων ιστοτόπων και περιεχομένου
newtab-custom-close-button = Κλείσιμο
newtab-custom-settings = Διαχείριση περισσότερων ρυθμίσεων
