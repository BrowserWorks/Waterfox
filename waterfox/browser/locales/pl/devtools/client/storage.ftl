# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Storage Inspector.

# Key shortcut used to focus the filter box on top of the data view
storage-filter-key = CmdOrCtrl+F

# Hint shown when the selected storage host does not contain any data
storage-table-empty-text = Brak danych dla wybranego hosta

# Hint shown when the cookies storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cookies
storage-table-type-cookies-hint = Wyświetl i modyfikuj ciasteczka, wybierając hosta. <a data-l10n-name="learn-more-link">Więcej informacji</a>

# Hint shown when the local storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-localstorage-hint = Wyświetl i modyfikuj lokalną pamięć, wybierając hosta. <a data-l10n-name="learn-more-link">Więcej informacji</a>

# Hint shown when the session storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-sessionstorage-hint = Wyświetl i modyfikuj pamięć sesji, wybierając hosta. <a data-l10n-name="learn-more-link">Więcej informacji</a>

# Hint shown when the IndexedDB storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/IndexedDB
storage-table-type-indexeddb-hint = Wyświetl i usuwaj wpisy IndexedDB, wybierając bazę danych. <a data-l10n-name="learn-more-link">Więcej informacji</a>

# Hint shown when the cache storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cache_Storage
storage-table-type-cache-hint = Wyświetl i usuwaj wpisy pamięci podręcznej, wybierając pamięć. <a data-l10n-name="learn-more-link">Więcej informacji</a>

# Hint shown when the extension storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Extension_Storage
storage-table-type-extensionstorage-hint = Wyświetl i modyfikuj pamięć rozszerzeń, wybierając hosta. <a data-l10n-name="learn-more-link">Więcej informacji</a>

# Placeholder for the searchbox that allows you to filter the table items
storage-search-box =
    .placeholder = Filtruj elementy

# Placeholder text in the sidebar search box
storage-variable-view-search-box =
    .placeholder = Filtruj wartości

# Add Item button title
storage-add-button =
    .title = Dodaj obiekt

# Refresh button title
storage-refresh-button =
    .title = Odśwież obiekty

# Context menu action to delete all storage items
storage-context-menu-delete-all =
    .label = Usuń wszystko

# Context menu action to delete all session cookies
storage-context-menu-delete-all-session-cookies =
    .label = Usuń wszystkie ciasteczka sesji

# Context menu action to copy a storage item
storage-context-menu-copy =
    .label = Kopiuj

# Context menu action to delete storage item
# Variables:
#   $itemName (String) - Name of the storage item that will be deleted
storage-context-menu-delete =
    .label = Usuń „{ $itemName }”

# Context menu action to add an item
storage-context-menu-add-item =
    .label = Dodaj obiekt

# Context menu action to delete all storage items from a given host
# Variables:
#   $host (String) - Host for which we want to delete the items
storage-context-menu-delete-all-from =
    .label = Usuń wszystko z „{ $host }”

## Header names of the columns in the Storage Table for each type of storage available
## through the Storage Tree to the side.

storage-table-headers-cookies-name = Nazwa
storage-table-headers-cookies-value = Wartość
storage-table-headers-cookies-expires = Wygasa / Max-Age
storage-table-headers-cookies-size = Rozmiar
storage-table-headers-cookies-last-accessed = Ostatni dostęp
storage-table-headers-cookies-creation-time = Utworzono
storage-table-headers-cache-status = Stan
storage-table-headers-extension-storage-area = Obszar pamięci

## Labels for Storage type groups present in the Storage Tree, like cookies, local storage etc.

storage-tree-labels-cookies = Ciasteczka
storage-tree-labels-local-storage = Lokalna pamięć
storage-tree-labels-session-storage = Pamięć sesji
storage-tree-labels-indexed-db = IndexedDB
storage-tree-labels-cache = Pamięć podręczna
storage-tree-labels-extension-storage = Pamięć rozszerzenia

##

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is closed.
storage-expand-pane =
    .title = Pokaż panel

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is open.
storage-collapse-pane =
    .title = Ukryj panel

# String displayed in the expires column when the cookie is a Session Cookie
storage-expires-session = Sesja

# Heading displayed over the item value in the sidebar
storage-data = Dane

# Heading displayed over the item parsed value in the sidebar
storage-parsed-value = Przetworzona wartość

# Warning notification when IndexedDB database could not be deleted immediately.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-blocked = Baza danych „{ $dbName }” zostanie usunięta po zamknięciu wszystkich połączeń.

# Error notification when IndexedDB database could not be deleted.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-error = Nie udało się usunąć bazy danych „{ $dbName }”.
