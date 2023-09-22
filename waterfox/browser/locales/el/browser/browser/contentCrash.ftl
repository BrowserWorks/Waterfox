# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Subframe crash notification

crashed-subframe-message = <strong>Μέρος της σελίδας κατέρρευσε.</strong> Για να ενημερώσετε το { -brand-product-name } σχετικά με αυτό το ζήτημα, ώστε να διορθωθεί γρηγορότερα, παρακαλώ υποβάλετε μια αναφορά.

# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Μέρος της σελίδας κατέρρευσε. Για να ενημερώσετε το { -brand-product-name } σχετικά με αυτό το ζήτημα, ώστε να διορθωθεί γρηγορότερα, παρακαλώ υποβάλετε μια αναφορά.
crashed-subframe-learnmore-link =
    .value = Μάθετε περισσότερα
crashed-subframe-submit =
    .label = Υποβολή αναφοράς
    .accesskey = Υ

## Pending crash reports

# Variables:
#   $reportCount (Number): the number of pending crash reports
pending-crash-reports-message =
    { $reportCount ->
        [one] Έχετε μια μη απεσταλμένη αναφορά σφάλματος
       *[other] Έχετε { $reportCount } μη απεσταλμένες αναφορές σφαλμάτων
    }
pending-crash-reports-view-all =
    .label = Προβολή
pending-crash-reports-send =
    .label = Αποστολή
pending-crash-reports-always-send =
    .label = Πάντα αποστολή
