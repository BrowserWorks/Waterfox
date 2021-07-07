# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Λίστες αποκλεισμού
    .style = width: 55em
blocklist-description = Επιλέξτε τη λίστα που χρησιμοποιεί το { -brand-short-name } για να αποκλείσει διαδικτυακούς ιχνηλάτες. Οι λίστες παρέχονται από το <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w
blocklist-treehead-list =
    .label = Λίστα
blocklist-button-cancel =
    .label = Ακύρωση
    .accesskey = Α
blocklist-button-ok =
    .label = Αποθήκευση αλλαγών
    .accesskey = θ
blocklist-dialog =
    .buttonlabelaccept = Αποθήκευση αλλαγών
    .buttonaccesskeyaccept = θ
# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }
blocklist-item-moz-std-listName = Λίστα αποκλεισμού επιπέδου 1 (Προτείνεται).
blocklist-item-moz-std-description = Επιτρέπει μερικούς ιχνηλάτες για να λειτουργούν περισσότερες ιστοσελίδες.
blocklist-item-moz-full-listName = Λίστα αποκλεισμού επιπέδου 2
blocklist-item-moz-full-description = Αποκλείει κάθε ιχνηλάτη που ανιχνεύεται. Μερικές ιστοσελίδες ή περιεχόμενο ενδέχεται να μην φορτώνονται κανονικά.
