# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = Προσοχή! Μπορεί να ακυρώσετε την εγγύηση του προϊόντος! ;-)
config-about-warning-text = Η αλλαγή των προεπιλεγμένων τιμών πιθανόν να προκαλέσει  ανεπιθύμητες παρενέργειες στην σταθερότητα, ασφάλεια και συμπεριφορά αυτής της εφαρμογής. Θα πρέπει να συνεχίσετε με τις αλλαγές μόνο αν γνωρίζετε καλά τι κάνετε.
config-about-warning-button =
    .label = Δέχομαι το ρίσκο!
config-about-warning-checkbox =
    .label = Εμφάνιση της προειδοποίησης και την επόμενη φορά
config-search-prefs =
    .value = Αναζήτηση:
    .accesskey = ζ
config-focus-search =
    .key = r
config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Όνομα προτίμησης
config-lock-column =
    .label = Κατάσταση
config-type-column =
    .label = Τύπος
config-value-column =
    .label = Τιμή

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Κάντε κλικ για ταξινόμηση
config-column-chooser =
    .tooltip = Πατήστε να επιλέξετε τις προς εμφάνιση στήλες

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Αντιγραφή
    .accesskey = γ
config-copy-name =
    .label = Αντιγραφή ονόματος
    .accesskey = ν
config-copy-value =
    .label = Αντιγραφή τιμής
    .accesskey = τ
config-modify =
    .label = Τροποποίηση
    .accesskey = ρ
config-toggle =
    .label = (Απ)ενεργοποίηση
    .accesskey = Ε
config-reset =
    .label = Επαναφορά
    .accesskey = π
config-new =
    .label = Νέο
    .accesskey = Ν
config-string =
    .label = Αλφαριθμητικό
    .accesskey = λ
config-integer =
    .label = Ακέραιος
    .accesskey = ρ
config-boolean =
    .label = Δυαδικός
    .accesskey = κ
config-default = προεπιλογή
config-modified = τροποποιημένο
config-locked = κλειδωμένο
config-property-string = αλφαριθμητικό
config-property-int = ακέραιος
config-property-bool = δυαδικός
config-new-prompt = Εισαγωγή του ονόματος προτίμησης
config-nan-title = Μη έγκυρη τιμή
config-nan-text = Το κείμενο που εισάγατε δεν είναι αριθμός.
# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Νέα { $type } τιμή
# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Εισαγωγή { $type } τιμής
