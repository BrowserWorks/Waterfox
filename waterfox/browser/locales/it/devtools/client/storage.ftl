# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Storage Inspector.

# Key shortcut used to focus the filter box on top of the data view
storage-filter-key = CmdOrCtrl+F

# Hint shown when the selected storage host does not contain any data
storage-table-empty-text = Nessun dato presente per l’host selezionato

# Hint shown when the cookies storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cookies
storage-table-type-cookies-hint = Seleziona un host per visualizzare e modificare i cookie. <a data-l10n-name="learn-more-link">Ulteriori informazioni</a>

# Hint shown when the local storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-localstorage-hint = Seleziona un host per visualizzare e modificare l’archiviazione locale. <a data-l10n-name="learn-more-link">Ulteriori informazioni</a>

# Hint shown when the session storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-sessionstorage-hint = Seleziona un host per visualizzare e modificare l’archiviazione di sessione. <a data-l10n-name="learn-more-link">Ulteriori informazioni</a>

# Hint shown when the IndexedDB storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/IndexedDB
storage-table-type-indexeddb-hint = Seleziona un database per visualizzare ed eliminare elementi IndexedDB. <a data-l10n-name="learn-more-link">Ulteriori informazioni</a>

# Hint shown when the cache storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cache_Storage
storage-table-type-cache-hint = Seleziona uno storage per visualizzare ed eliminare elementi nell’archiviazione cache. <a data-l10n-name="learn-more-link">Ulteriori informazioni</a>

# Hint shown when the extension storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Extension_Storage
storage-table-type-extensionstorage-hint = Seleziona un host per visualizzare e modificare l’archiviazione estensioni. <a data-l10n-name="learn-more-link">Ulteriori informazioni</a>

# Placeholder for the searchbox that allows you to filter the table items
storage-search-box =
    .placeholder = Filtra elementi

# Placeholder text in the sidebar search box
storage-variable-view-search-box =
    .placeholder = Filtra valori

# Add Item button title
storage-add-button =
    .title = Aggiungi elemento

# Refresh button title
storage-refresh-button =
    .title = Aggiorna elementi

# Context menu action to delete all storage items
storage-context-menu-delete-all =
    .label = Elimina tutto

# Context menu action to delete all session cookies
storage-context-menu-delete-all-session-cookies =
    .label = Elimina tutti i cookie di sessione

# Context menu action to copy a storage item
storage-context-menu-copy =
    .label = Copia

# Context menu action to delete storage item
# Variables:
#   $itemName (String) - Name of the storage item that will be deleted
storage-context-menu-delete =
    .label = Elimina “{ $itemName }”

# Context menu action to add an item
storage-context-menu-add-item =
    .label = Aggiungi elemento

# Context menu action to delete all storage items from a given host
# Variables:
#   $host (String) - Host for which we want to delete the items
storage-context-menu-delete-all-from =
    .label = Elimina tutto da “{ $host }”

## Header names of the columns in the Storage Table for each type of storage available
## through the Storage Tree to the side.

storage-table-headers-cookies-name = Nome
storage-table-headers-cookies-value = Valore
storage-table-headers-cookies-expires = Scadenza/Max-Age
storage-table-headers-cookies-size = Dimensione
storage-table-headers-cookies-last-accessed = Ultimo accesso
storage-table-headers-cookies-creation-time = Creazione
storage-table-headers-cache-status = Stato
storage-table-headers-extension-storage-area = Area archiviazione

## Labels for Storage type groups present in the Storage Tree, like cookies, local storage etc.

storage-tree-labels-cookies = Cookie
storage-tree-labels-local-storage = Archiviazione locale
storage-tree-labels-session-storage = Archiviazione sessioni
storage-tree-labels-indexed-db = Indexed DB
storage-tree-labels-cache = Archiviazione cache
storage-tree-labels-extension-storage = Archiviazione estensioni

##

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is closed.
storage-expand-pane =
    .title = Espandi pannello

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is open.
storage-collapse-pane =
    .title = Comprimi pannello

# String displayed in the expires column when the cookie is a Session Cookie
storage-expires-session = Sessione

# Heading displayed over the item value in the sidebar
storage-data = Dati

# Heading displayed over the item parsed value in the sidebar
storage-parsed-value = Valore analizzato

# Warning notification when IndexedDB database could not be deleted immediately.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-blocked = Il database “{ $dbName }” verrà eliminato dopo la chiusura di tutte le connessioni.

# Error notification when IndexedDB database could not be deleted.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-error = Impossibile eliminare il database “{ $dbName }”
