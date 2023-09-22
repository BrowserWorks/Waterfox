# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

styleeditor-new-button =
    .tooltiptext = Δημιουργία και σύνδεση ενός νέου φύλλου στυλ στο έγγραφο
    .accesskey = Ν
styleeditor-import-button =
    .tooltiptext = Εισαγωγή και επισύναψη ενός υπάρχοντος φύλλου στυλ στο έγγραφο
    .accesskey = Ε
styleeditor-filter-input =
    .placeholder = Φιλτράρισμα φύλλων στυλ
styleeditor-visibility-toggle =
    .tooltiptext = (Απ)ενεργοποίηση ορατότητας φύλλου στυλ
    .accesskey = Α
styleeditor-visibility-toggle-system =
    .tooltiptext = Τα φύλλα στυλ συστήματος δεν μπορούν να απενεργοποιηθούν
styleeditor-save-button = Αποθήκευση
    .tooltiptext = Αποθήκευση φύλλου στυλ σε αρχείο
    .accesskey = Α
styleeditor-options-button =
    .tooltiptext = Επιλογές επεξεργασίας στυλ
styleeditor-at-rules = Κανόνες «At»
styleeditor-editor-textbox =
    .data-placeholder = Πληκτρολογήστε CSS εδώ.
styleeditor-no-stylesheet = Αυτή η σελίδα δεν έχει φύλλο στυλ.
styleeditor-no-stylesheet-tip = Μήπως θέλετε να <a data-l10n-name="append-new-stylesheet">προσθέσετε ένα νέο φύλλο στυλ</a>;
styleeditor-open-link-new-tab =
    .label = Άνοιγμα συνδέσμου σε νέα καρτέλα
styleeditor-copy-url =
    .label = Αντιγραφή URL
styleeditor-find =
    .label = Εύρεση
    .accesskey = ρ
styleeditor-find-again =
    .label = Εύρεση ξανά
    .accesskey = ξ
styleeditor-go-to-line =
    .label = Μετάβαση στη γραμμή…
    .accesskey = Μ
# Label displayed when searching a term that is not found in any stylesheet path
styleeditor-stylesheet-all-filtered = Δεν βρέθηκε αντίστοιχο φύλλο στυλ.

# This string is shown in the style sheets list
# Variables:
#   $ruleCount (Integer) - The number of rules in the stylesheet.
styleeditor-stylesheet-rule-count =
    { $ruleCount ->
        [one] { $ruleCount } κανόνας.
       *[other] { $ruleCount } κανόνες.
    }
