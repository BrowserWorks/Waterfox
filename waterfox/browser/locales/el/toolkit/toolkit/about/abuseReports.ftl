# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title.
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Αναφορά για { $addon-name }
abuse-report-title-extension = Αναφορά επέκτασης στη { -vendor-short-name }
abuse-report-title-sitepermission = Αναφορά επέκτασης αδειών ιστοτόπων στη { -vendor-short-name }
abuse-report-title-theme = Αναφορά θέματος στη { -vendor-short-name }
abuse-report-subtitle = Ποιο είναι το ζήτημα;
# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = από <a data-l10n-name="author-name">{ $author-name }</a>
abuse-report-learnmore =
    Δεν ξέρετε σίγουρα ποιο ζήτημα να επιλέξετε;
    <a data-l10n-name="learnmore-link">Μάθετε περισσότερα σχετικά με την αναφορά επεκτάσεων και θεμάτων</a>
abuse-report-learnmore-intro = Δεν ξέρετε σίγουρα ποιο ζήτημα να επιλέξετε;
abuse-report-learnmore-link = Μάθετε περισσότερα σχετικά με την αναφορά επεκτάσεων και θεμάτων
abuse-report-submit-description = Περιγραφή του προβλήματος (προαιρετικό)
abuse-report-textarea =
    .placeholder = Είναι πιο εύκολο να επιλύσουμε ένα πρόβλημα όταν έχουμε συγκεκριμένες λεπτομέρειες. Παρακαλούμε περιγράψτε το πρόβλημα που αντιμετωπίζετε. Ευχαριστούμε που μας βοηθάτε να διατηρήσουμε υγιές το διαδίκτυο.
abuse-report-submit-note =
    Σημείωση: Μη συμπεριλάβετε προσωπικές πληροφορίες (όπως όνομα, διεύθυνση email, αριθμό τηλεφώνου, πραγματική διεύθυνση).
    Η { -vendor-short-name } διατηρεί μόνιμα αυτές τις αναφορές.

## Panel buttons.

abuse-report-cancel-button = Ακύρωση
abuse-report-next-button = Επόμενο
abuse-report-goback-button = Επιστροφή
abuse-report-submit-button = Υποβολή

## Message bars descriptions.
##
## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Η αναφορά για το <span data-l10n-name="addon-name">{ $addon-name }</span> ακυρώθηκε.
abuse-report-messagebar-submitting = Αποστολή αναφοράς για το <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Ευχαριστούμε για την αναφορά σας. Θέλετε να αφαιρέσετε το <span data-l10n-name="addon-name">{ $addon-name }</span>;
abuse-report-messagebar-submitted-noremove = Ευχαριστούμε για την αναφορά σας.
abuse-report-messagebar-removed-extension = Ευχαριστούμε για την αναφορά σας. Έχετε αφαιρέσει την επέκταση <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-sitepermission = Ευχαριστούμε για την αναφορά σας. Έχετε αφαιρέσει το πρόσθετο αδειών ιστοτόπων <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Ευχαριστούμε για την αναφορά σας. Έχετε αφαιρέσει το θέμα <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Προέκυψε σφάλμα κατά την αποστολή της αναφοράς για το <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Η αναφορά για το <span data-l10n-name="addon-name">{ $addon-name }</span> δεν απεστάλη, επειδή μια άλλη αναφορά υπεβλήθη πρόσφατα.
abuse-report-messagebar-aborted2 =
    .message = Η αναφορά για το { $addon-name } ακυρώθηκε.
abuse-report-messagebar-submitting2 =
    .message = Αποστολή αναφοράς για το { $addon-name }.
abuse-report-messagebar-submitted2 =
    .message = Ευχαριστούμε για την αναφορά σας. Θέλετε να αφαιρέσετε το { $addon-name };
abuse-report-messagebar-submitted-noremove2 =
    .message = Ευχαριστούμε για την αναφορά σας.
abuse-report-messagebar-removed-extension2 =
    .message = Ευχαριστούμε για την αναφορά σας. Έχετε αφαιρέσει την επέκταση { $addon-name }.
abuse-report-messagebar-removed-sitepermission2 =
    .message = Ευχαριστούμε για την αναφορά σας. Έχετε αφαιρέσει το πρόσθετο αδειών ιστοτόπων { $addon-name }.
abuse-report-messagebar-removed-theme2 =
    .message = Ευχαριστούμε για την αναφορά σας. Έχετε αφαιρέσει το θέμα { $addon-name }.
abuse-report-messagebar-error2 =
    .message = Προέκυψε σφάλμα κατά την αποστολή της αναφοράς για το { $addon-name }.
abuse-report-messagebar-error-recent-submit2 =
    .message = Η αναφορά για το { $addon-name } δεν απεστάλη, επειδή μια άλλη αναφορά υπεβλήθη πρόσφατα.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Ναι, να αφαιρεθεί
abuse-report-messagebar-action-keep-extension = Όχι, να παραμείνει
abuse-report-messagebar-action-remove-sitepermission = Ναι, να αφαιρεθεί
abuse-report-messagebar-action-keep-sitepermission = Όχι, να παραμείνει
abuse-report-messagebar-action-remove-theme = Ναι, να αφαιρεθεί
abuse-report-messagebar-action-keep-theme = Όχι, να παραμείνει
abuse-report-messagebar-action-retry = Επανάληψη
abuse-report-messagebar-action-cancel = Ακύρωση

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Έβλαψε τον υπολογιστή ή τα δεδομένα μου
abuse-report-damage-example = Παράδειγμα: Εγκατέστησε κακόβουλο λογισμικό ή έκλεψε δεδομένα
abuse-report-spam-reason-v2 = Περιέχει ανεπιθύμητα μηνύματα ή διαφημίσεις
abuse-report-spam-example = Παράδειγμα: Εισάγει διαφημίσεις σε ιστοτόπους
abuse-report-settings-reason-v2 = Άλλαξε τη μηχανή αναζήτησης, την αρχική σελίδα ή τη νέα καρτέλα μου, χωρίς να με πληροφορήσει/ρωτήσει
abuse-report-settings-suggestions = Πριν αναφέρετε την επέκταση, μπορείτε να δοκιμάσετε να αλλάξετε τις ρυθμίσεις σας:
abuse-report-settings-suggestions-search = Αλλάξτε τις προεπιλεγμένες ρυθμίσεις αναζήτησης
abuse-report-settings-suggestions-homepage = Αλλάξτε την αρχική σελίδα και τη νέα καρτέλα
abuse-report-deceptive-reason-v2 = Προσποιείται ότι είναι κάτι που δεν είναι
abuse-report-deceptive-example = Παράδειγμα: Παραπλανητική περιγραφή ή απεικόνιση
abuse-report-broken-reason-extension-v2 = Δεν λειτουργεί, χαλάει ιστοτόπους, ή επιβραδύνει το { -brand-product-name }
abuse-report-broken-reason-sitepermission-v2 = Δεν λειτουργεί, χαλάει ιστοτόπους ή επιβραδύνει το { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Δεν λειτουργεί ή χαλάει την προβολή του προγράμματος περιήγησης
abuse-report-broken-example = Παράδειγμα: Οι λειτουργίες είναι αργές, δύσκολες στη χρήση ή δεν λειτουργούν· δεν φορτώνονται τμήματα ιστοτόπων ή εμφανίζονται διαφορετικά
abuse-report-broken-suggestions-extension =
    Φαίνεται ότι έχετε εντοπίσει ένα σφάλμα. Εκτός από την υποβολή της παρούσας αναφοράς, ο καλύτερος τρόπος
    να επιλυθεί ένα ζήτημα λειτουργικότητας είναι να επικοινωνήσετε με τον προγραμματιστή της επέκτασης.
    <a data-l10n-name="support-link">Επισκεφθείτε τον ιστότοπο της επέκτασης</a> για να βρείτε τα στοιχεία του προγραμματιστή.
abuse-report-broken-suggestions-sitepermission =
    Φαίνεται ότι έχετε εντοπίσει ένα σφάλμα. Εκτός από την υποβολή της παρούσας αναφοράς, ο καλύτερος τρόπος
    να επιλυθεί ένα ζήτημα λειτουργικότητας είναι να επικοινωνήσετε με τον προγραμματιστή του ιστοτόπου.
    <a data-l10n-name="support-link">Επισκεφθείτε τον ιστότοπο</a> για να λάβετε τις πληροφορίες του προγραμματιστή.
abuse-report-broken-suggestions-theme =
    Φαίνεται ότι έχετε εντοπίσει ένα σφάλμα. Εκτός από την υποβολή της παρούσας αναφοράς, ο καλύτερος τρόπος
    να επιλυθεί ένα ζήτημα λειτουργικότητας είναι να επικοινωνήσετε με τον προγραμματιστή του θέματος.
    <a data-l10n-name="support-link">Επισκεφθείτε τον ιστότοπο του θέματος</a> για να βρείτε τα στοιχεία του προγραμματιστή.
abuse-report-policy-reason-v2 = Περιέχει περιεχόμενο μίσους, βίας ή παρανομίας
abuse-report-policy-suggestions =
    Σημείωση: Τα ζητήματα πνευματικών δικαιωμάτων και εμπορικών σημάτων πρέπει να αναφέρονται μέσω ξεχωριστής διαδικασίας.
    <a data-l10n-name="report-infringement-link">Ακολουθήστε αυτές τις οδηγίες</a> για να
    αναφέρετε το πρόβλημα.
abuse-report-unwanted-reason-v2 = Δεν το ήθελα ποτέ και δεν ξέρω πώς να το αφαιρέσω
abuse-report-unwanted-example = Παράδειγμα: Μια εφαρμογή το εγκατέστησε χωρίς την άδειά μου
abuse-report-other-reason = Κάτι άλλο
