# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Διαχείριση συσκευών
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Μονάδες και συσκευές ασφαλείας

devmgr-header-details =
    .label = Λεπτομέρειες

devmgr-header-value =
    .label = Τιμή

devmgr-button-login =
    .label = Σύνδεση
    .accesskey = Σ

devmgr-button-logout =
    .label = Αποσύνδεση
    .accesskey = π

devmgr-button-changepw =
    .label = Αλλαγή κωδικού πρόσβασης
    .accesskey = κ

devmgr-button-load =
    .label = Φόρτωση
    .accesskey = Φ

devmgr-button-unload =
    .label = Εκφόρτωση
    .accesskey = κ

devmgr-button-enable-fips =
    .label = Ενεργοποίηση FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = Απενεργοποίηση FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Φόρτωση προγράμματος οδήγησης συσκευής PKCS#11

load-device-info = Εισαγάγετε τις πληροφορίες για τη μονάδα που θέλετε να προσθέσετε.

load-device-modname =
    .value = Όνομα μονάδας
    .accesskey = Μ

load-device-modname-default =
    .value = Νέα μονάδα  PKCS#11

load-device-filename =
    .value = Όνομα αρχείου μονάδας
    .accesskey = α

load-device-browse =
    .label = Περιήγηση…
    .accesskey = Π

## Token Manager

devinfo-status =
    .label = Κατάσταση

devinfo-status-disabled =
    .label = Ανενεργό

devinfo-status-not-present =
    .label = Δεν υπάρχει

devinfo-status-uninitialized =
    .label = Δεν έχει αρχικοποιηθεί

devinfo-status-not-logged-in =
    .label = Χωρίς σύνδεση

devinfo-status-logged-in =
    .label = Έγινε σύνδεση

devinfo-status-ready =
    .label = Έτοιμο

devinfo-desc =
    .label = Περιγραφή

devinfo-man-id =
    .label = Κατασκευαστής

devinfo-hwversion =
    .label = Έκδοση HW
devinfo-fwversion =
    .label = Έκδοση FW

devinfo-modname =
    .label = Μονάδα

devinfo-modpath =
    .label = Διαδρομή

login-failed = Αποτυχία σύνδεσης

devinfo-label =
    .label = Ετικέτα

devinfo-serialnum =
    .label = Σειριακός αριθμός

fips-nonempty-primary-password-required = Η λειτουργία FIPS απαιτεί έναν κύριο κωδικό πρόσβασης για κάθε συσκευή ασφαλείας. Παρακαλώ ορίστε τον κωδικό πρόσβασης πριν από την ενεργοποίηση της λειτουργίας FIPS.
unable-to-toggle-fips = Δεν ήταν δυνατή η αλλαγή κατάστασης λειτουργίας FIPS για την συσκευή ασφαλείας. Προτείνεται να κάνετε έξοδο και επανεκκίνηση της εφαρμογής.
load-pk11-module-file-picker-title = Επιλέξτε ένα πρόγραμμα οδήγησης συσκευής PKCS#11 για φόρτωση

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Το όνομα αρθρώματος δεν μπορεί να είναι κενό.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = Το ‘Πιστοποιητικά Ρίζας‘ είναι δεσμευμένο και δεν μπορεί να χρησιμοποιηθεί ως όνομα αρθρώματος.

add-module-failure = Δεν ήταν δυνατή η προσθήκη μονάδας
del-module-warning = Θέλετε σίγουρα να διαγράψετε αυτή τη μονάδα ασφάλειας;
del-module-error = Δεν ήταν δυνατή η διαγραφή μονάδας
