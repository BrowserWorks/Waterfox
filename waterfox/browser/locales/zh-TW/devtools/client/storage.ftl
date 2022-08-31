# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Storage Inspector.

# Key shortcut used to focus the filter box on top of the data view
storage-filter-key = CmdOrCtrl+F

# Hint shown when the selected storage host does not contain any data
storage-table-empty-text = 選擇的主機中沒有任何資料存在

# Hint shown when the cookies storage type is selected. Clicking the link will open
# https://firefox-source-docs.mozilla.org/devtools-user/storage_inspector/cookies/
storage-table-type-cookies-hint = 選擇主機來檢視或編輯 Cookie。<a data-l10n-name="learn-more-link">了解更多</a>

# Hint shown when the local storage type is selected. Clicking the link will open
# https://firefox-source-docs.mozilla.org/devtools-user/storage_inspector/local_storage_session_storage/
storage-table-type-localstorage-hint = 選擇主機來檢視或編輯本機儲存空間。<a data-l10n-name="learn-more-link">了解更多</a>

# Hint shown when the session storage type is selected. Clicking the link will open
# https://firefox-source-docs.mozilla.org/devtools-user/storage_inspector/local_storage_session_storage/
storage-table-type-sessionstorage-hint = 選擇主機來檢視或編輯瀏覽階段儲存空間。<a data-l10n-name="learn-more-link">了解更多</a>

# Hint shown when the IndexedDB storage type is selected. Clicking the link will open
# https://firefox-source-docs.mozilla.org/devtools-user/storage_inspector/indexeddb/
storage-table-type-indexeddb-hint = 選擇資料庫來檢視或刪除 IndexedDB 項目。<a data-l10n-name="learn-more-link">了解更多</a>

# Hint shown when the cache storage type is selected. Clicking the link will open
# https://firefox-source-docs.mozilla.org/devtools-user/storage_inspector/cache_storage/
storage-table-type-cache-hint = 選擇儲存空間來檢視或刪除快取項目。<a data-l10n-name="learn-more-link">了解更多</a>

# Hint shown when the extension storage type is selected. Clicking the link will open
# https://firefox-source-docs.mozilla.org/devtools-user/storage_inspector/extension_storage/
storage-table-type-extensionstorage-hint = 選擇主機來檢視或編輯擴充套件。<a data-l10n-name="learn-more-link">了解更多</a>

# Placeholder for the searchbox that allows you to filter the table items
storage-search-box =
    .placeholder = 過濾項目

# Placeholder text in the sidebar search box
storage-variable-view-search-box =
    .placeholder = 過濾值

# Add Item button title
storage-add-button =
    .title = 新增項目

# Refresh button title
storage-refresh-button =
    .title = 重新整理項目

# Context menu action to delete all storage items
storage-context-menu-delete-all =
    .label = 全部刪除

# Context menu action to delete all session cookies
storage-context-menu-delete-all-session-cookies =
    .label = 清除所有瀏覽階段 Cookie

# Context menu action to copy a storage item
storage-context-menu-copy =
    .label = 複製

# Context menu action to delete storage item
# Variables:
#   $itemName (String) - Name of the storage item that will be deleted
storage-context-menu-delete =
    .label = 刪除「{ $itemName }」

# Context menu action to add an item
storage-context-menu-add-item =
    .label = 新增項目

# Context menu action to delete all storage items from a given host
# Variables:
#   $host (String) - Host for which we want to delete the items
storage-context-menu-delete-all-from =
    .label = 刪除所有「{ $host }」的項目

## Header names of the columns in the Storage Table for each type of storage available
## through the Storage Tree to the side.

storage-table-headers-cookies-name = 名稱
storage-table-headers-cookies-value = 值
storage-table-headers-cookies-expires = Expires / Max-Age
storage-table-headers-cookies-size = 大小
storage-table-headers-cookies-last-accessed = 最後存取於
storage-table-headers-cookies-creation-time = 建立於
storage-table-headers-cache-status = 狀態
storage-table-headers-extension-storage-area = 儲存區域

## Labels for Storage type groups present in the Storage Tree, like cookies, local storage etc.

storage-tree-labels-cookies = Cookie
storage-tree-labels-local-storage = 本機儲存空間
storage-tree-labels-session-storage = 瀏覽階段儲存空間
storage-tree-labels-indexed-db = Indexed DB
storage-tree-labels-cache = 快取儲存空間
storage-tree-labels-extension-storage = 擴充套件儲存空間

##

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is closed.
storage-expand-pane =
    .title = 展開窗格

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is open.
storage-collapse-pane =
    .title = 摺疊窗格

# String displayed in the expires column when the cookie is a Session Cookie
storage-expires-session = 瀏覽階段

# Heading displayed over the item value in the sidebar
storage-data = 資料

# Heading displayed over the item parsed value in the sidebar
storage-parsed-value = 剖析值

# Warning notification when IndexedDB database could not be deleted immediately.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-blocked = 資料庫「{ $dbName }」將在所有連線關閉後刪除。

# Error notification when IndexedDB database could not be deleted.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-error = 無法刪除資料庫「{ $dbName }」。
