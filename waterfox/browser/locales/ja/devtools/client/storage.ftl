# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Storage Inspector.

# Key shortcut used to focus the filter box on top of the data view
storage-filter-key = CmdOrCtrl+F
# Hint shown when the selected storage host does not contain any data
storage-table-empty-text = 選択されたホストには表示できるデータがありません
# Hint shown when the cookies storage type is selected. Clicking the link will open
# https://firefox-source-docs.mozilla.org/devtools-user/storage_inspector/cookies/
storage-table-type-cookies-hint = ホストを選択すると Cookie の表示と編集が可能です。<a data-l10n-name="learn-more-link">詳細</a>
# Hint shown when the local storage type is selected. Clicking the link will open
# https://firefox-source-docs.mozilla.org/devtools-user/storage_inspector/local_storage_session_storage/
storage-table-type-localstorage-hint = ホストを選択するとローカルストレージの表示と編集が可能です。<a data-l10n-name="learn-more-link">詳細</a>
# Hint shown when the session storage type is selected. Clicking the link will open
# https://firefox-source-docs.mozilla.org/devtools-user/storage_inspector/local_storage_session_storage/
storage-table-type-sessionstorage-hint = ホストを選択するとセッションストレージの表示と編集が可能です。<a data-l10n-name="learn-more-link">詳細</a>
# Hint shown when the IndexedDB storage type is selected. Clicking the link will open
# https://firefox-source-docs.mozilla.org/devtools-user/storage_inspector/indexeddb/
storage-table-type-indexeddb-hint = ホストを選択すると Indexed DB のエントリーの表示と削除が可能です。<a data-l10n-name="learn-more-link">詳細</a>
# Hint shown when the cache storage type is selected. Clicking the link will open
# https://firefox-source-docs.mozilla.org/devtools-user/storage_inspector/cache_storage/
storage-table-type-cache-hint = ホストを選択するとキャッシュストレージのエントリーの表示と削除が可能です。<a data-l10n-name="learn-more-link">詳細</a>
# Hint shown when the extension storage type is selected. Clicking the link will open
# https://firefox-source-docs.mozilla.org/devtools-user/storage_inspector/extension_storage/
storage-table-type-extensionstorage-hint = ホストを選択すると拡張機能ストレージの表示と編集が可能です。<a data-l10n-name="learn-more-link">詳細</a>
# Placeholder for the searchbox that allows you to filter the table items
storage-search-box =
    .placeholder = 項目を絞り込み
# Placeholder text in the sidebar search box
storage-variable-view-search-box =
    .placeholder = 値を絞り込み
# Add Item button title
storage-add-button =
    .title = アイテムを追加
# Refresh button title
storage-refresh-button =
    .title = アイテムを再読み込み
# Context menu action to delete all storage items
storage-context-menu-delete-all =
    .label = すべて削除
# Context menu action to delete all session cookies
storage-context-menu-delete-all-session-cookies =
    .label = すべてのセッション Cookie を削除
# Context menu action to copy a storage item
storage-context-menu-copy =
    .label = コピー
# Context menu action to delete storage item
# Variables:
#   $itemName (String) - Name of the storage item that will be deleted
storage-context-menu-delete =
    .label = "{ $itemName }" を削除
# Context menu action to add an item
storage-context-menu-add-item =
    .label = アイテムを追加
# Context menu action to delete all storage items from a given host
# Variables:
#   $host (String) - Host for which we want to delete the items
storage-context-menu-delete-all-from =
    .label = "{ $host }" のすべてのアイテムを削除

## Header names of the columns in the Storage Table for each type of storage available
## through the Storage Tree to the side.

storage-table-headers-cookies-name = 名前
storage-table-headers-cookies-value = 値
storage-table-headers-cookies-expires = 有効期限
storage-table-headers-cookies-size = サイズ
storage-table-headers-cookies-last-accessed = アクセス日時
storage-table-headers-cookies-creation-time = 作成日時
storage-table-headers-cache-status = 状態
storage-table-headers-extension-storage-area = ストレージ領域

## Labels for Storage type groups present in the Storage Tree, like cookies, local storage etc.

storage-tree-labels-cookies = Cookie
storage-tree-labels-local-storage = ローカルストレージ
storage-tree-labels-session-storage = セッションストレージ
storage-tree-labels-indexed-db = Indexed DB
storage-tree-labels-cache = キャッシュストレージ
storage-tree-labels-extension-storage = 拡張機能ストレージ

##

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is closed.
storage-expand-pane =
    .title = ペインを展開します
# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is open.
storage-collapse-pane =
    .title = ペインを折りたたみます
# String displayed in the expires column when the cookie is a Session Cookie
storage-expires-session = セッション
# Heading displayed over the item value in the sidebar
storage-data = データ
# Heading displayed over the item parsed value in the sidebar
storage-parsed-value = パース済みの値
# Warning notification when IndexedDB database could not be deleted immediately.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-blocked = データベース "{ $dbName }" はすべての接続が切断されてから削除されます。
# Error notification when IndexedDB database could not be deleted.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-error = データベース "{ $dbName }" を削除できませんでした。
