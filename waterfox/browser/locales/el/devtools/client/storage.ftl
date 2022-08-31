# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Storage Inspector.

# Key shortcut used to focus the filter box on top of the data view
storage-filter-key = CmdOrCtrl+F

# Hint shown when the selected storage host does not contain any data
storage-table-empty-text = Δεν υπάρχουν δεδομένα για τον επιλεγμένο host

# Hint shown when the cookies storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cookies
storage-table-type-cookies-hint = Δείτε και επεξεργαστείτε cookies επιλέγοντας έναν κεντρικό υπολογιστή. <a data-l10n-name="learn-more-link">Μάθετε περισσότερα</a>

# Hint shown when the local storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-localstorage-hint = Δείτε και επεξεργαστείτε την τοπική αποθήκευση επιλέγοντας ένα host. <a data-l10n-name="learn-more-link">Μάθετε περισσότερα</a>

# Hint shown when the session storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-sessionstorage-hint = Δείτε και επεξεργαστείτε την αποθήκευση συνεδρίας επιλέγοντας ένα host. <a data-l10n-name="learn-more-link">Μάθετε περισσότερα</a>

# Hint shown when the IndexedDB storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/IndexedDB
storage-table-type-indexeddb-hint = Δείτε και διαγράψτε τις καταχωρήσεις IndexedDB επιλέγοντας μια βάση δεδομένων. <a data-l10n-name="learn-more-link">Μάθετε περισσότερα</a>

# Hint shown when the cache storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cache_Storage
storage-table-type-cache-hint = Δείτε και διαγράψτε τις καταχωρήσεις κρυφής μνήμης επιλέγοντας έναν αποθηκευτικό χώρο. <a data-l10n-name="learn-more-link">Μάθετε περισσότερα</a>

# Hint shown when the extension storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Extension_Storage
storage-table-type-extensionstorage-hint = Δείτε και επεξεργαστείτε την αποθήκευση επεκτάσεων επιλέγοντας ένα host. <a data-l10n-name="learn-more-link">Μάθετε περισσότερα</a>

# Placeholder for the searchbox that allows you to filter the table items
storage-search-box =
    .placeholder = Φιλτράρισμα στοιχείων

# Placeholder text in the sidebar search box
storage-variable-view-search-box =
    .placeholder = Φιλτράρισμα τιμών

# Add Item button title
storage-add-button =
    .title = Προσθήκη στοιχείου

# Refresh button title
storage-refresh-button =
    .title = Ανανέωση στοιχείων

# Context menu action to delete all storage items
storage-context-menu-delete-all =
    .label = Διαγραφή όλων

# Context menu action to delete all session cookies
storage-context-menu-delete-all-session-cookies =
    .label = Διαγραφή όλων των cookies συνεδρίας

# Context menu action to copy a storage item
storage-context-menu-copy =
    .label = Αντιγραφή

# Context menu action to delete storage item
# Variables:
#   $itemName (String) - Name of the storage item that will be deleted
storage-context-menu-delete =
    .label = Διαγραφή «{ $itemName }»

# Context menu action to add an item
storage-context-menu-add-item =
    .label = Προσθήκη στοιχείου

# Context menu action to delete all storage items from a given host
# Variables:
#   $host (String) - Host for which we want to delete the items
storage-context-menu-delete-all-from =
    .label = Διαγραφή όλων από «{ $host }»

## Header names of the columns in the Storage Table for each type of storage available
## through the Storage Tree to the side.

storage-table-headers-cookies-name = Όνομα
storage-table-headers-cookies-value = Τιμή
storage-table-headers-cookies-expires = Λήξη/Μέγιστος χρόνος
storage-table-headers-cookies-size = Μέγεθος
storage-table-headers-cookies-last-accessed = Τελευταία πρόσβαση
storage-table-headers-cookies-creation-time = Δημιουργήθηκε
storage-table-headers-cache-status = Κατάσταση
storage-table-headers-extension-storage-area = Περιοχή αποθήκευσης

## Labels for Storage type groups present in the Storage Tree, like cookies, local storage etc.

storage-tree-labels-cookies = Cookies
storage-tree-labels-local-storage = Τοπική αποθήκευση
storage-tree-labels-session-storage = Αποθήκευση συνεδρίας
storage-tree-labels-indexed-db = ΒΔ με ευρετήριο
storage-tree-labels-cache = Χώρος κρυφής μνήμης
storage-tree-labels-extension-storage = Αποθήκευση επέκτασης

##

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is closed.
storage-expand-pane =
    .title = Επέκταση προβολής

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is open.
storage-collapse-pane =
    .title = Σύμπτυξη προβολής

# String displayed in the expires column when the cookie is a Session Cookie
storage-expires-session = Συνεδρία

# Heading displayed over the item value in the sidebar
storage-data = Δεδομένα

# Heading displayed over the item parsed value in the sidebar
storage-parsed-value = Αναλυμένη τιμή

# Warning notification when IndexedDB database could not be deleted immediately.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-blocked = Η βάση δεδομένων “{ $dbName }” θα διαγραφεί αφού κλείσουν όλες οι συνδέσεις.

# Error notification when IndexedDB database could not be deleted.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-error = Δεν ήταν δυνατή η διαγραφή της βάσης δεδομένων “{ $dbName }”.
