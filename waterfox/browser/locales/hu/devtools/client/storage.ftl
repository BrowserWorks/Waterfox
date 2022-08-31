# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Storage Inspector.

# Key shortcut used to focus the filter box on top of the data view
storage-filter-key = CmdOrCtrl+F

# Hint shown when the selected storage host does not contain any data
storage-table-empty-text = Nincsenek adatok a kijelölt kiszolgálóhoz

# Hint shown when the cookies storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cookies
storage-table-type-cookies-hint = Egy kiszolgáló kiválasztásával tekintse meg és szerkessze a sütiket. <a data-l10n-name="learn-more-link">További információk</a>

# Hint shown when the local storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-localstorage-hint = Egy kiszolgáló kiválasztásával tekintse meg és szerkessze a helyi tárolót. <a data-l10n-name="learn-more-link">További információk</a>

# Hint shown when the session storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-sessionstorage-hint = Egy kiszolgáló kiválasztásával tekintse meg és szerkessze a munkamenet-tárolót. <a data-l10n-name="learn-more-link">További információk</a>

# Hint shown when the IndexedDB storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/IndexedDB
storage-table-type-indexeddb-hint = Egy adatbázis kiválasztásával tekintse meg és törölje az IndexedDB bejegyzéseit. <a data-l10n-name="learn-more-link">További információk</a>

# Hint shown when the cache storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cache_Storage
storage-table-type-cache-hint = Egy tároló kiválasztásával tekintse meg és törölje a gyorsítótár-tároló bejegyzéseit. <a data-l10n-name="learn-more-link">További információk</a>

# Hint shown when the extension storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Extension_Storage
storage-table-type-extensionstorage-hint = Egy kiszolgáló kiválasztásával tekintse meg és törölje a kiegészítőtárolót. <a data-l10n-name="learn-more-link">További információk</a>

# Placeholder for the searchbox that allows you to filter the table items
storage-search-box =
    .placeholder = Elemek szűrése

# Placeholder text in the sidebar search box
storage-variable-view-search-box =
    .placeholder = Értékek szűrése

# Add Item button title
storage-add-button =
    .title = Elem hozzáadása

# Refresh button title
storage-refresh-button =
    .title = Elemek frissítése

# Context menu action to delete all storage items
storage-context-menu-delete-all =
    .label = Összes törlése

# Context menu action to delete all session cookies
storage-context-menu-delete-all-session-cookies =
    .label = Összes munkamenet süti törlése

# Context menu action to copy a storage item
storage-context-menu-copy =
    .label = Másolás

# Context menu action to delete storage item
# Variables:
#   $itemName (String) - Name of the storage item that will be deleted
storage-context-menu-delete =
    .label = „{ $itemName }” törlése

# Context menu action to add an item
storage-context-menu-add-item =
    .label = Elem hozzáadása

# Context menu action to delete all storage items from a given host
# Variables:
#   $host (String) - Host for which we want to delete the items
storage-context-menu-delete-all-from =
    .label = Minden törlése innen: „{ $host }”

## Header names of the columns in the Storage Table for each type of storage available
## through the Storage Tree to the side.

storage-table-headers-cookies-name = Név
storage-table-headers-cookies-value = Érték
storage-table-headers-cookies-expires = Lejárat / Maximális élettartam
storage-table-headers-cookies-size = Méret
storage-table-headers-cookies-last-accessed = Utolsó hozzáférés
storage-table-headers-cookies-creation-time = Létrehozva
storage-table-headers-cache-status = Állapot
storage-table-headers-extension-storage-area = Tárterület

## Labels for Storage type groups present in the Storage Tree, like cookies, local storage etc.

storage-tree-labels-cookies = Sütik
storage-tree-labels-local-storage = Helyi tároló
storage-tree-labels-session-storage = Munkamenet-tároló
storage-tree-labels-indexed-db = Indexelt DB
storage-tree-labels-cache = Gyorsítótár-tároló
storage-tree-labels-extension-storage = Kiegészítőtároló

##

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is closed.
storage-expand-pane =
    .title = Ablaktábla kibontása

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is open.
storage-collapse-pane =
    .title = Ablaktábla összecsukása

# String displayed in the expires column when the cookie is a Session Cookie
storage-expires-session = Munkamenet

# Heading displayed over the item value in the sidebar
storage-data = Adatok

# Heading displayed over the item parsed value in the sidebar
storage-parsed-value = Feldolgozott érték

# Warning notification when IndexedDB database could not be deleted immediately.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-blocked = „{ $dbName }” adatbázis törlésre kerül az összes kapcsolat lezárása után.

# Error notification when IndexedDB database could not be deleted.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-error = „{ $dbName }” adatbázis nem törölhető.
