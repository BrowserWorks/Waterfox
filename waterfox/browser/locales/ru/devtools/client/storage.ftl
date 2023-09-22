# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Storage Inspector.

# Key shortcut used to focus the filter box on top of the data view
storage-filter-key = CmdOrCtrl+F

# Hint shown when the selected storage host does not contain any data
storage-table-empty-text = Для выделенного хоста нет данных

# Hint shown when the cookies storage type is selected. Clicking the link will open
# https://firefox-source-docs.mozilla.org/devtools-user/storage_inspector/cookies/
storage-table-type-cookies-hint = Просматривайте и редактируйте куки, выбрав хост. <a data-l10n-name="learn-more-link">Подробнее</a>

# Hint shown when the local storage type is selected. Clicking the link will open
# https://firefox-source-docs.mozilla.org/devtools-user/storage_inspector/local_storage_session_storage/
storage-table-type-localstorage-hint = Просматривайте и правьте локальное хранилище, выбрав хост. <a data-l10n-name="learn-more-link">Подробнее</a>

# Hint shown when the session storage type is selected. Clicking the link will open
# https://firefox-source-docs.mozilla.org/devtools-user/storage_inspector/local_storage_session_storage/
storage-table-type-sessionstorage-hint = Просматривайте и правьте cессионное хранилище, выбрав хост. <a data-l10n-name="learn-more-link">Подробнее</a>

# Hint shown when the IndexedDB storage type is selected. Clicking the link will open
# https://firefox-source-docs.mozilla.org/devtools-user/storage_inspector/indexeddb/
storage-table-type-indexeddb-hint = Просматривайте и удаляйте записи IndexedDB, выбрав базу данных. <a data-l10n-name="learn-more-link">Подробнее</a>

# Hint shown when the cache storage type is selected. Clicking the link will open
# https://firefox-source-docs.mozilla.org/devtools-user/storage_inspector/cache_storage/
storage-table-type-cache-hint = Просматривайте и удаляйте записи кеша, выбрав хранилище. <a data-l10n-name="learn-more-link">Подробнее</a>

# Hint shown when the extension storage type is selected. Clicking the link will open
# https://firefox-source-docs.mozilla.org/devtools-user/storage_inspector/extension_storage/
storage-table-type-extensionstorage-hint = Просматривайте и правьте хранилище расширений, выбрав хост. <a data-l10n-name="learn-more-link">Подробнее</a>

# Placeholder for the searchbox that allows you to filter the table items
storage-search-box =
    .placeholder = Поиск элементов

# Placeholder text in the sidebar search box
storage-variable-view-search-box =
    .placeholder = Значения фильтра

# Add Item button title
storage-add-button =
    .title = Добавить элемент

# Refresh button title
storage-refresh-button =
    .title = Обновить элементы

# Context menu action to delete all storage items
storage-context-menu-delete-all =
    .label = Удалить все

# Context menu action to delete all session cookies
storage-context-menu-delete-all-session-cookies =
    .label = Удалить все сессионные куки

# Context menu action to copy a storage item
storage-context-menu-copy =
    .label = Скопировать

# Context menu action to delete storage item
# Variables:
#   $itemName (String) - Name of the storage item that will be deleted
storage-context-menu-delete =
    .label = Удалить «{ $itemName }»

# Context menu action to add an item
storage-context-menu-add-item =
    .label = Добавить элемент

# Context menu action to delete all storage items from a given host
# Variables:
#   $host (String) - Host for which we want to delete the items
storage-context-menu-delete-all-from =
    .label = Удалить все из «{ $host }»

## Header names of the columns in the Storage Table for each type of storage available
## through the Storage Tree to the side.

storage-table-headers-cookies-name = Имя
storage-table-headers-cookies-value = Значение
storage-table-headers-cookies-expires = Срок действия / Макс. возраст
storage-table-headers-cookies-size = Размер
storage-table-headers-cookies-last-accessed = Последний доступ
storage-table-headers-cookies-creation-time = Создан
storage-table-headers-cache-status = Состояние
storage-table-headers-extension-storage-area = Место хранения

## Labels for Storage type groups present in the Storage Tree, like cookies, local storage etc.

storage-tree-labels-cookies = Куки
storage-tree-labels-local-storage = Локальное хранилище
storage-tree-labels-session-storage = Сессионное хранилище
storage-tree-labels-indexed-db = Indexed DB
storage-tree-labels-cache = Хранилище кеша
storage-tree-labels-extension-storage = Хранилище расширений

##

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is closed.
storage-expand-pane =
    .title = Развернуть панель

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is open.
storage-collapse-pane =
    .title = Свернуть панель

# String displayed in the expires column when the cookie is a Session Cookie
storage-expires-session = Сессионная

# Heading displayed over the item value in the sidebar
storage-data = Данные

# Heading displayed over the item parsed value in the sidebar
storage-parsed-value = Разобранное значение

# Warning notification when IndexedDB database could not be deleted immediately.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-blocked = База данных «{ $dbName }» будет удалена после того, как все соединения будут закрыты.

# Error notification when IndexedDB database could not be deleted.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-error = База данных «{ $dbName }» не может быть удалена.
