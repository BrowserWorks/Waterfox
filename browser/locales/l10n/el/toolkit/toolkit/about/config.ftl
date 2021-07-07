# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Συνεχίστε με προσοχή
about-config-intro-warning-text = Η αλλαγή παραμέτρων των σύνθετων προτιμήσεων μπορεί να επηρεάσει την απόδοση ή την ασφάλεια του { -brand-short-name }.
about-config-intro-warning-checkbox = Προειδοποίηση κατά την απόπειρα πρόσβασης σε αυτές τις προτιμήσεις
about-config-intro-warning-button = Αποδοχή κινδύνου και συνέχεια

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Η αλλαγή αυτών των προτιμήσεων μπορεί να επηρεάσει την απόδοση ή την ασφάλεια του { -brand-short-name }.
about-config-page-title = Σύνθετες προτιμήσεις
about-config-search-input1 =
    .placeholder = Αναζήτηση ονόματος προτίμησης
about-config-show-all = Εμφάνιση όλων
about-config-show-only-modified = Εμφάνιση μόνο τροποποιημένων προτιμήσεων
about-config-pref-add-button =
    .title = Προσθήκη
about-config-pref-toggle-button =
    .title = Εναλλαγή
about-config-pref-edit-button =
    .title = Επεξεργασία
about-config-pref-save-button =
    .title = Αποθήκευση
about-config-pref-reset-button =
    .title = Επαναφορά
about-config-pref-delete-button =
    .title = Διαγραφή

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Αληθείας
about-config-pref-add-type-number = Αριθμητική
about-config-pref-add-type-string = Αλφαριθμητική

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (προεπιλογή)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (προσαρμοσμένη)
