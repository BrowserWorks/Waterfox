# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
    { $count ->
        [one] 1 μη αναγνωσμένο μήνυμα
       *[other] { $count } μη αναγνωσμένα μηνύματα
    }
about-rights-notification-text = Το { -brand-short-name } είναι δωρεάν λογισμικό ανοικτού κώδικα, που δημιουργήθηκε από μια κοινότητα χιλιάδων ατόμων από όλο τον κόσμο.

## Content tabs

content-tab-page-loading-icon =
    .alt = Η σελίδα φορτώνεται
content-tab-security-high-icon =
    .alt = Η σύνδεση είναι ασφαλής
content-tab-security-broken-icon =
    .alt = Η σύνδεση δεν είναι ασφαλής

## Toolbar

addons-and-themes-button =
    .label = Πρόσθετα και θέματα
    .tooltip = Διαχειριστείτε τα πρόσθετά σας
addons-and-themes-toolbarbutton =
    .label = Πρόσθετα και θέματα
    .tooltiptext = Διαχείριση των προσθέτων σας
quick-filter-toolbarbutton =
    .label = Γρήγορο φιλτράρισμα
    .tooltiptext = Φιλτράρισμα μηνυμάτων
redirect-msg-button =
    .label = Ανακατεύθυνση
    .tooltiptext = Ανακατεύθυνση επιλεγμένου μηνύματος

## Folder Pane

folder-pane-toolbar =
    .toolbarname = Γραμμή περιοχής φακέλων
    .accesskey = Γ
folder-pane-toolbar-options-button =
    .tooltiptext = Επιλογές προβολής φακέλων
folder-pane-header-label = Φάκελοι

## Folder Toolbar Header Popup

folder-toolbar-hide-toolbar-toolbarbutton =
    .label = Απόκρυψη γραμμής εργαλείων
    .accesskey = Α
show-all-folders-label =
    .label = Όλοι οι φάκελοι
    .accesskey = Ό
show-unread-folders-label =
    .label = Μη αναγνωσμένοι φάκελοι
    .accesskey = Μ
show-favorite-folders-label =
    .label = Αγαπημένοι φάκελοι
    .accesskey = π
show-smart-folders-label =
    .label = Ενοποιημένοι φάκελοι
    .accesskey = Ε
show-recent-folders-label =
    .label = Πρόσφατοι φάκελοι
    .accesskey = Π
folder-toolbar-toggle-folder-compact-view =
    .label = Συμπτυγμένη προβολή
    .accesskey = Σ

## Menu

redirect-msg-menuitem =
    .label = Ανακατεύθυνση
    .accesskey = κ

## AppMenu

# Since v89 we dropped the platforms distinction between Options or Preferences
# and consolidated everything with Preferences.
appmenu-preferences =
    .label = Προτιμήσεις
appmenu-addons-and-themes =
    .label = Πρόσθετα και θέματα
appmenu-help-enter-troubleshoot-mode =
    .label = Λειτουργία επίλυσης προβλημάτων…
appmenu-help-exit-troubleshoot-mode =
    .label = Απενεργοποίηση λειτουργίας επίλυσης προβλημάτων
appmenu-help-more-troubleshooting-info =
    .label = Πληροφορίες επίλυσης προβλημάτων
appmenu-redirect-msg =
    .label = Ανακατεύθυνση

## Context menu

context-menu-redirect-msg =
    .label = Ανακατεύθυνση

## Message header pane

other-action-redirect-msg =
    .label = Ανακατεύθυνση

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = Διαχείριση επέκτασης
    .accesskey = ε
toolbar-context-menu-remove-extension =
    .label = Αφαίρεση επέκτασης
    .accesskey = φ

## Message headers

message-header-address-in-address-book-icon =
    .alt = Η διεύθυνση βρίσκεται στο ευρετήριο
message-header-address-not-in-address-book-icon =
    .alt = Η διεύθυνση δεν βρίσκεται στο ευρετήριο

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Αφαίρεση του { $name };
addon-removal-confirmation-button = Αφαίρεση
addon-removal-confirmation-message = Αφαίρεση του { $name }, των ρυθμίσεων και των δεδομένων του από το { -brand-short-name };
caret-browsing-prompt-title = Περιήγηση με κέρσορα
caret-browsing-prompt-text = Πατώντας το F7 (απ)ενεργοποιείται η περιήγηση με κέρσορα. Αυτή η λειτουργία τοποθετεί έναν κινούμενο κέρσορα σε ορισμένο περιεχόμενο και σας επιτρέπει να επιλέγετε κείμενο με το πληκτρολόγιο. Θέλετε να ενεργοποιήσετε τη λειτουργία;
caret-browsing-prompt-check-text = Να μην γίνει ξανά ερώτηση.
repair-text-encoding-button =
    .label = Επιδιόρθωση κωδικοποίησης κειμένου
    .tooltiptext = Υπόθεση σωστής κωδικοποίησης κειμένου από το περιεχόμενο του μηνύματος
