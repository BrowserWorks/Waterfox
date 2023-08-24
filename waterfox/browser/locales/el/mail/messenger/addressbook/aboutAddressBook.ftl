# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Ευρετήριο

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = Νέο ευρετήριο
about-addressbook-toolbar-add-carddav-address-book =
    .label = Προσθήκη ευρετηρίου CardDAV
about-addressbook-toolbar-add-ldap-address-book =
    .label = Προσθήκη ευρετηρίου LDAP
about-addressbook-toolbar-new-contact =
    .label = Νέα επαφή
about-addressbook-toolbar-new-list =
    .label = Νέα λίστα
about-addressbook-toolbar-import =
    .label = Εισαγωγή

## Books

all-address-books = Όλα τα ευρετήρια
about-addressbook-books-context-properties =
    .label = Ιδιότητες
about-addressbook-books-context-synchronize =
    .label = Συγχρονισμός
about-addressbook-books-context-edit =
    .label = Επεξεργασία
about-addressbook-books-context-print =
    .label = Εκτύπωση…
about-addressbook-books-context-export =
    .label = Εξαγωγή…
about-addressbook-books-context-delete =
    .label = Διαγραφή
about-addressbook-books-context-remove =
    .label = Αφαίρεση
about-addressbook-books-context-startup-default =
    .label = Προεπιλεγμένος κατάλογος εκκίνησης
about-addressbook-confirm-delete-book-title = Διαγραφή ευρετηρίου
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = Θέλετε σίγουρα να διαγράψετε το «{ $name }» και όλες τις επαφές του;
about-addressbook-confirm-remove-remote-book-title = Αφαίρεση ευρετηρίου
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = Θέλετε σίγουρα να αφαιρέσετε το { $name };

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = Αναζήτηση σε { $name }
about-addressbook-search-all =
    .placeholder = Αναζήτηση σε όλα τα ευρετήρια
about-addressbook-sort-button2 =
    .title = Επιλογές εμφάνισης λίστας
about-addressbook-name-format-display =
    .label = Εμφανιζόμενο όνομα
about-addressbook-name-format-firstlast =
    .label = Όνομα Επώνυμο
about-addressbook-name-format-lastfirst =
    .label = Επώνυμο, Όνομα
about-addressbook-sort-name-ascending =
    .label = Ταξινόμηση κατά όνομα (Α > Ω)
about-addressbook-sort-name-descending =
    .label = Ταξινόμηση κατά όνομα (Ω > Α)
about-addressbook-sort-email-ascending =
    .label = Ταξινόμηση κατά διεύθυνση email (A > Z)
about-addressbook-sort-email-descending =
    .label = Ταξινόμηση κατά διεύθυνση email (Z > A)
about-addressbook-horizontal-layout =
    .label = Εναλλαγή σε οριζόντια διάταξη
about-addressbook-vertical-layout =
    .label = Εναλλαγή σε κάθετη διάταξη

## Card column headers
## Each string is listed here twice, and the values should match.

about-addressbook-column-header-generatedname = Όνομα
about-addressbook-column-label-generatedname =
    .label = { about-addressbook-column-header-generatedname }
about-addressbook-column-header-emailaddresses = Διευθύνσεις email
about-addressbook-column-label-emailaddresses =
    .label = { about-addressbook-column-header-emailaddresses }
about-addressbook-column-header-phonenumbers = Αριθμοί τηλεφώνου
about-addressbook-column-label-phonenumbers =
    .label = { about-addressbook-column-header-phonenumbers }
about-addressbook-column-header-addresses = Διευθύνσεις
about-addressbook-column-label-addresses =
    .label = { about-addressbook-column-header-addresses }
about-addressbook-column-header-title = Τίτλος
about-addressbook-column-label-title =
    .label = { about-addressbook-column-header-title }
about-addressbook-column-header-department = Τμήμα
about-addressbook-column-label-department =
    .label = { about-addressbook-column-header-department }
about-addressbook-column-header-organization = Οργανισμός
about-addressbook-column-label-organization =
    .label = { about-addressbook-column-header-organization }
about-addressbook-column-header-addrbook = Ευρετήριο
about-addressbook-column-label-addrbook =
    .label = { about-addressbook-column-header-addrbook }
about-addressbook-cards-context-write =
    .label = Σύνταξη
about-addressbook-confirm-delete-mixed-title = Διαγραφή επαφών και λιστών
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed = Θέλετε σίγουρα να διαγράψετε αυτές τις { $count } επαφές και λίστες;
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
    { $count ->
        [one] Διαγραφή λίστας
       *[other] Διαγραφή λιστών
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
    { $count ->
        [one] Θέλετε σίγουρα να διαγράψετε τη λίστα { $name };
       *[other] Θέλετε σίγουρα να διαγράψετε αυτές τις { $count } λίστες;
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
    { $count ->
        [one] Αφαίρεση επαφής
       *[other] Αφαίρεση επαφών
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
# $name (String) - The name of the contact to be removed, if $count is 1.
# $list (String) - The name of the list that contacts will be removed from.
about-addressbook-confirm-remove-contacts =
    { $count ->
        [one] Θέλετε σίγουρα να αφαιρέσετε την επαφή { $name } από τη λίστα { $list };
       *[other] Θέλετε σίγουρα να αφαιρέσετε αυτές τις { $count } επαφές από τη λίστα { $list };
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
about-addressbook-confirm-delete-contacts-title =
    { $count ->
        [one] Διαγραφή επαφής
       *[other] Διαγραφή επαφών
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
# $name (String) - The name of the contact to be deleted, if $count is 1.
about-addressbook-confirm-delete-contacts =
    { $count ->
        [one] Θέλετε σίγουρα να διαγράψετε την επαφή { $name };
       *[other] Θέλετε σίγουρα να διαγράψετε αυτές τις { $count } επαφές;
    }

## Card list placeholder
## Shown when there are no cards in the list

about-addressbook-placeholder-empty-book = Καμία διαθέσιμη επαφή
about-addressbook-placeholder-new-contact = Νέα επαφή
about-addressbook-placeholder-search-only = Αυτό το ευρετήριο εμφανίζει επαφές μόνο μετά από αναζήτηση
about-addressbook-placeholder-searching = Αναζήτηση…
about-addressbook-placeholder-no-search-results = Δεν βρέθηκαν επαφές

## Details

about-addressbook-prefer-display-name = Να προτιμηθεί η εμφάνιση ονόματος στην κεφαλίδα του μηνύματος
about-addressbook-write-action-button = Σύνταξη
about-addressbook-event-action-button = Εκδήλωση
about-addressbook-search-action-button = Αναζήτηση
about-addressbook-begin-edit-contact-button = Επεξεργασία
about-addressbook-delete-edit-contact-button = Διαγραφή
about-addressbook-cancel-edit-contact-button = Ακύρωση
about-addressbook-save-edit-contact-button = Αποθήκευση
about-addressbook-add-contact-to = Προσθήκη σε:
about-addressbook-details-email-addresses-header = Διευθύνσεις email
about-addressbook-details-phone-numbers-header = Αριθμοί τηλεφώνου
about-addressbook-details-addresses-header = Διευθύνσεις
about-addressbook-details-notes-header = Σημειώσεις
about-addressbook-details-other-info-header = Άλλες πληροφορίες
about-addressbook-entry-type-work = Εργασία
about-addressbook-entry-type-home = Οικία
about-addressbook-entry-type-fax = Φαξ
# Or "Mobile"
about-addressbook-entry-type-cell = Κινητό
about-addressbook-entry-type-pager = Βομβητής
about-addressbook-entry-name-birthday = Γενέθλια
about-addressbook-entry-name-anniversary = Επέτειος
about-addressbook-entry-name-title = Τίτλος
about-addressbook-entry-name-role = Ρόλος
about-addressbook-entry-name-organization = Οργανισμός
about-addressbook-entry-name-website = Ιστότοπος
about-addressbook-entry-name-time-zone = Ζώνη ώρας
about-addressbook-unsaved-changes-prompt-title = Μη αποθηκευμένες αλλαγές
about-addressbook-unsaved-changes-prompt = Θέλετε να αποθηκεύσετε τις αλλαγές σας πριν αποχωρήσετε από την προβολή επεξεργασίας;

# Photo dialog

about-addressbook-photo-drop-target = Εναποθέστε ή επικολλήστε μια φωτογραφία εδώ ή κάντε κλικ για να επιλέξετε ένα αρχείο.
about-addressbook-photo-drop-loading = Φόρτωση φωτογραφίας…
about-addressbook-photo-drop-error = Αποτυχία φόρτωσης φωτογραφίας.
about-addressbook-photo-filepicker-title = Επιλογή αρχείου εικόνας
about-addressbook-photo-discard = Απόρριψη υπάρχουσας φωτογραφίας
about-addressbook-photo-cancel = Ακύρωση
about-addressbook-photo-save = Αποθήκευση
