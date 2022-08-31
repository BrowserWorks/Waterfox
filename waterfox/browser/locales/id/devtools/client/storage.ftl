# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Storage Inspector.

# Key shortcut used to focus the filter box on top of the data view
storage-filter-key = CmdOrCtrl+F

# Hint shown when the selected storage host does not contain any data
storage-table-empty-text = Tidak ada data untuk host terpilih

# Hint shown when the cookies storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cookies
storage-table-type-cookies-hint = Lihat dan edit kuki dengan memilih host. <a data-l10n-name="learn-more-link">Pelajari lebih lanjut</a>

# Hint shown when the local storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-localstorage-hint = Lihat dan edit penyimpanan lokal dengan memilih host. <a data-l10n-name="learn-more-link">Pelajari lebih lanjut</a>

# Hint shown when the session storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-sessionstorage-hint = Lihat dan edit penyimpanan sesi dengan memilih host. <a data-l10n-name="learn-more-link">Pelajari lebih lanjut</a>

# Hint shown when the IndexedDB storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/IndexedDB
storage-table-type-indexeddb-hint = Lihat dan hapus entri IndexedDB dengan memilih database. <a data-l10n-name="learn-more-link">Pelajari lebih lanjut</a>

# Hint shown when the cache storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cache_Storage
storage-table-type-cache-hint = Lihat dan hapus entri penyimpanan tembolok dengan memilih penyimpanan. <a data-l10n-name="learn-more-link">Pelajari lebih lanjut</a>

# Hint shown when the extension storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Extension_Storage
storage-table-type-extensionstorage-hint = Lihat dan edit penyimpanan ekstensi dengan memilih host. <a data-l10n-name="learn-more-link">Pelajari lebih lanjut</a>

# Placeholder for the searchbox that allows you to filter the table items
storage-search-box =
    .placeholder = Filter item

# Placeholder text in the sidebar search box
storage-variable-view-search-box =
    .placeholder = Filter nilai

# Add Item button title
storage-add-button =
    .title = Tambah Butir

# Refresh button title
storage-refresh-button =
    .title = Segarkan Item

# Context menu action to delete all storage items
storage-context-menu-delete-all =
    .label = Hapus Semua

# Context menu action to delete all session cookies
storage-context-menu-delete-all-session-cookies =
    .label = Hapus Kuki Semua Sesi

# Context menu action to copy a storage item
storage-context-menu-copy =
    .label = Salin

# Context menu action to delete storage item
# Variables:
#   $itemName (String) - Name of the storage item that will be deleted
storage-context-menu-delete =
    .label = Hapus “{ $itemName }”

# Context menu action to add an item
storage-context-menu-add-item =
    .label = Tambah Butir

# Context menu action to delete all storage items from a given host
# Variables:
#   $host (String) - Host for which we want to delete the items
storage-context-menu-delete-all-from =
    .label = Hapus Semua dari “{ $host }”

## Header names of the columns in the Storage Table for each type of storage available
## through the Storage Tree to the side.

storage-table-headers-cookies-name = Nama
storage-table-headers-cookies-value = Nilai
storage-table-headers-cookies-expires = Kedaluwarsa / Usia Maksimal
storage-table-headers-cookies-size = Ukuran
storage-table-headers-cookies-last-accessed = Diakses Terakhir
storage-table-headers-cookies-creation-time = Dibuat
storage-table-headers-cache-status = Status
storage-table-headers-extension-storage-area = Area Penyimpanan

## Labels for Storage type groups present in the Storage Tree, like cookies, local storage etc.

storage-tree-labels-cookies = Kuki
storage-tree-labels-local-storage = Penyimpanan Lokal
storage-tree-labels-session-storage = Penyimpanan Sesi
storage-tree-labels-indexed-db = Indexed DB
storage-tree-labels-cache = Penyimpanan Tembolok
storage-tree-labels-extension-storage = Penyimpanan Ekstensi

##

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is closed.
storage-expand-pane =
    .title = Bentangkan

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is open.
storage-collapse-pane =
    .title = Ciutkan

# String displayed in the expires column when the cookie is a Session Cookie
storage-expires-session = Sesi

# Heading displayed over the item value in the sidebar
storage-data = Data

# Heading displayed over the item parsed value in the sidebar
storage-parsed-value = Nilai yang Diuraikan

# Warning notification when IndexedDB database could not be deleted immediately.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-blocked = Basis data “{ $dbName }” akan dihapus setelah semua sambungan tertutup.

# Error notification when IndexedDB database could not be deleted.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-error = Basis data “{ $dbName }” tidak dapat dihapus.
