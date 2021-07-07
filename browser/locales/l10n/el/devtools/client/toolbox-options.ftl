# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Προεπιλεγμένα εργαλεία ανάπτυξης
# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Δεν υποστηρίζεται για τον τρέχοντα στόχο εργαλειοθήκης
# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Τα εργαλεία για προγραμματιστές εγκαταστάθηκαν από τα πρόσθετα
# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Διαθέσιμα κουμπιά εργαλειοθήκης
# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Θέματα

## Inspector section

# The heading
options-context-inspector = Επιθεώρηση
# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Εμφάνιση στυλ προγράμματος περιήγησης
options-show-user-agent-styles-tooltip =
    .title = Η ενεργοποίηση αυτού θα εμφανίσει τα προεπιλεγμένα στυλ που φορτώνονται από το πρόγραμμα περιήγησης.
# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Κόψιμο ιδιοτήτων DOM
options-collapse-attrs-tooltip =
    .title = Κόψιμο μεγάλων ιδιοτήτων στην επιθεώρηση

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Προεπιλεγμένη μονάδα χρώματος
options-default-color-unit-authored = Πρωτότυπη
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Ονόματα χρωμάτων

## Style Editor section

# The heading
options-styleeditor-label = Επεξεργασία στυλ
# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Αυτόματη συμπλήρωση CSS
options-stylesheet-autocompletion-tooltip =
    .title = Αυτόματη συμπλήρωση ιδιοτήτων CSS, τιμών και επιλογέων στην Επεξεργασία Στυλ καθώς πληκτρολογείτε

## Screenshot section

# The heading
options-screenshot-label = Συμπεριφορά στιγμιότυπου
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Στιγμιότυπο στο πρόχειρο
options-screenshot-clipboard-tooltip =
    .title = Αποθηκεύει το στιγμιότυπο απευθείας στο πρόχειρο
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-only-label = Στιγμιότυπο μόνο στο πρόχειρο
options-screenshot-clipboard-tooltip2 =
    .title = Αποθηκεύει το στιγμιότυπο απευθείας στο πρόχειρο
# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Αναπαραγωγή ήχου κλείστρου κάμερας
options-screenshot-audio-tooltip =
    .title = Ενεργοποιεί τον ήχο κάμερας κατά τη λήψη στιγμιότυπου

## Editor section

# The heading
options-sourceeditor-label = Προτιμήσεις επεξεργασίας
options-sourceeditor-detectindentation-tooltip =
    .title = Υπολογισμός εσοχής με βάση το περιεχόμενο της πηγής
options-sourceeditor-detectindentation-label = Εντοπισμός εσοχής
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Αυτόματη εισαγωγή παρενθέσεων κλεισίματος
options-sourceeditor-autoclosebrackets-label = Αυτόματο κλείσιμο παρενθέσεων
options-sourceeditor-expandtab-tooltip =
    .title = Χρήση διαστημάτων αντί για το χαρακτήρα καρτέλας
options-sourceeditor-expandtab-label = Εσοχή με διαστήματα
options-sourceeditor-tabsize-label = Μέγεθος καρτέλας
options-sourceeditor-keybinding-label = Συντομεύσεις πλήκτρων
options-sourceeditor-keybinding-default-label = Προεπιλογή

## Advanced section

# The heading (this item is also used in perftools.ftl)
options-context-advanced-settings = Σύνθετες ρυθμίσεις
# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Απενεργοποίηση κρυφής μνήμης HTTP (όταν είναι ανοικτή η εργαλειοθήκη)
options-disable-http-cache-tooltip =
    .title = Η ενεργοποίηση αυτής της επιλογής θα απενεργοποιήσει την κρυφή μνήμη HTTP για όλες τις καρτέλες που έχουν ανοικτή την εργαλειοθήκη. Τα service worker δεν επηρεάζονται από αυτή την επιλογή.
# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Απενεργοποίηση JavaScript *
options-disable-javascript-tooltip =
    .title = Η ενεργοποίηση αυτής της επιλογής θα απενεργοποιήσει το JavaScript για την τρέχουσα καρτέλα. Αν η καρτέλα ή η εργαλειοθήκη είναι κλειστή, τότε αυτή η ρύθμιση θα ξεχαστεί.
# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Ενεργοποίηση εργαλειοθηκών chrome και προσθέτων ελέγχου σφαλμάτων
options-enable-chrome-tooltip =
    .title = Η ενεργοποίηση αυτής της επιλογής θα σας επιτρέψει να χρησιμοποιήσετε διάφορα εργαλεία ανάπτυξης στο πλαίσιο του προγράμματος περιήγησης (μέσω του μενού Εργαλεία > Ανάπτυξη web > Εργαλειοθήκη προγράμματος περιήγησης) και να κάνετε έλεγχο σφαλμάτων στα πρόσθετα από τη Διαχείριση προσθέτων
# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Ενεργοποίηση απομακρυσμένου ελέγχου σφαλμάτων
options-enable-remote-tooltip2 =
    .title = Η ενεργοποίηση αυτής της επιλογής θα επιτρέψει τον απομακρυσμένο έλεγχο σφαλμάτων σε αυτό το παράθυρο του προγράμματος περιήγησης
# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Ενεργοποίηση Service Workers μέσω HTTP (όταν είναι ανοικτή η εργαλειοθήκη)
options-enable-service-workers-http-tooltip =
    .title = Η ενεργοποίηση αυτής της επιλογής θα ενεργοποιήσει τα service workers του HTTP για όλες τις καρτέλες που έχουν ανοικτή την εργαλειοθήκη.
# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Ενεργοποίηση χαρτών πηγής
options-source-maps-tooltip =
    .title = Αν ενεργοποιήσετε αυτή την επιλογή, οι πηγές θα αντιστοιχιστούν στα εργαλεία.
# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Τρέχουσα συνεδρία μόνο, επαναφορτώνει τη σελίδα
# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Εμφάνιση δεδομένων πλατφόρμας Gecko
options-show-platform-data-tooltip =
    .title =
        Αν ενεργοποιήσετε αυτή την επιλογή, οι αναφορές του προγράμματος προφίλ JavaScript θα περιλαμβάνουν
        σύμβολα της πλατφόρμας Gecko
