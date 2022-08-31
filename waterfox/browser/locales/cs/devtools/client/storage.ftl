# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Storage Inspector.

# Key shortcut used to focus the filter box on top of the data view
storage-filter-key = CmdOrCtrl+F

# Hint shown when the selected storage host does not contain any data
storage-table-empty-text = Pro vybraného hostitele nejsou k dispozici žádné údaje

# Hint shown when the cookies storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cookies
storage-table-type-cookies-hint = Pro zobrazení a úpravu cookies vyberte hostitele. <a data-l10n-name="learn-more-link">Zjistit více</a>

# Hint shown when the local storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-localstorage-hint = Pro zobrazení a úpravu místního úložiště vyberte hostitele. <a data-l10n-name="learn-more-link">Zjistit více</a>

# Hint shown when the session storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-sessionstorage-hint = Pro zobrazení a úpravu úložiště relace vyberte hostitele. <a data-l10n-name="learn-more-link">Zjistit více</a>

# Hint shown when the IndexedDB storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/IndexedDB
storage-table-type-indexeddb-hint = Pro zobrazení a úpravu položek v IndexedDB vyberte databázi. <a data-l10n-name="learn-more-link">Zjistit více</a>

# Hint shown when the cache storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cache_Storage
storage-table-type-cache-hint = Pro zobrazení a úpravu položek úložiště mezipaměti vyberte úložiště. <a data-l10n-name="learn-more-link">Zjistit více</a>

# Hint shown when the extension storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Extension_Storage
storage-table-type-extensionstorage-hint = Pro zobrazení a úpravu úložiště rozšíření vyberte hostitele. <a data-l10n-name="learn-more-link">Zjistit více</a>

# Placeholder for the searchbox that allows you to filter the table items
storage-search-box =
    .placeholder = Filtr položek

# Placeholder text in the sidebar search box
storage-variable-view-search-box =
    .placeholder = Filtr hodnot

# Add Item button title
storage-add-button =
    .title = Přidat položku

# Refresh button title
storage-refresh-button =
    .title = Obnovit položky

# Context menu action to delete all storage items
storage-context-menu-delete-all =
    .label = Smazat vše

# Context menu action to delete all session cookies
storage-context-menu-delete-all-session-cookies =
    .label = Smazat všechny cookies z relace

# Context menu action to copy a storage item
storage-context-menu-copy =
    .label = Kopírovat

# Context menu action to delete storage item
# Variables:
#   $itemName (String) - Name of the storage item that will be deleted
storage-context-menu-delete =
    .label = Smazat “{ $itemName }”

# Context menu action to add an item
storage-context-menu-add-item =
    .label = Přidat položku

# Context menu action to delete all storage items from a given host
# Variables:
#   $host (String) - Host for which we want to delete the items
storage-context-menu-delete-all-from =
    .label = Smazat vše z “{ $host }”

## Header names of the columns in the Storage Table for each type of storage available
## through the Storage Tree to the side.

storage-table-headers-cookies-name = Název
storage-table-headers-cookies-value = Hodnota
storage-table-headers-cookies-expires = Doba platnosti
storage-table-headers-cookies-size = Velikost
storage-table-headers-cookies-last-accessed = Poslední přístup
storage-table-headers-cookies-creation-time = Vytvořeno
storage-table-headers-cache-status = Stav
storage-table-headers-extension-storage-area = Úložiště

## Labels for Storage type groups present in the Storage Tree, like cookies, local storage etc.

storage-tree-labels-cookies = Cookies
storage-tree-labels-local-storage = Místní úložiště
storage-tree-labels-session-storage = Session Storage
storage-tree-labels-indexed-db = Indexovaná databáze
storage-tree-labels-cache = Úložiště mezipaměti
storage-tree-labels-extension-storage = Úložiště pro data rozšíření

##

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is closed.
storage-expand-pane =
    .title = Rozbalit panel

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is open.
storage-collapse-pane =
    .title = Sbalit panel

# String displayed in the expires column when the cookie is a Session Cookie
storage-expires-session = Relace

# Heading displayed over the item value in the sidebar
storage-data = Data

# Heading displayed over the item parsed value in the sidebar
storage-parsed-value = Parsovaná hodnota

# Warning notification when IndexedDB database could not be deleted immediately.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-blocked = Databáze “{ $dbName }” bude smazána poté, co jsou všechna připojení uzavřena.

# Error notification when IndexedDB database could not be deleted.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-error = Databáze „{ $dbName }“ nemohla být smazána.
