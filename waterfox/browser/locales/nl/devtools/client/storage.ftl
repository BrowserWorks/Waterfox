# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Storage Inspector.

# Key shortcut used to focus the filter box on top of the data view
storage-filter-key = CmdOrCtrl+F

# Hint shown when the selected storage host does not contain any data
storage-table-empty-text = Geen gegevens aanwezig voor geselecteerde host

# Hint shown when the cookies storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cookies
storage-table-type-cookies-hint = Bekijk en bewerk cookies door een host te selecteren. <a data-l10n-name="learn-more-link">Meer info</a>

# Hint shown when the local storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-localstorage-hint = Bekijk en bewerk de lokale opslag door een host te selecteren. <a data-l10n-name="learn-more-link">Meer info</a>

# Hint shown when the session storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-sessionstorage-hint = Bekijk en bewerk de sessieopslag door een host te selecteren. <a data-l10n-name="learn-more-link">Meer info</a>

# Hint shown when the IndexedDB storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/IndexedDB
storage-table-type-indexeddb-hint = Bekijk en verwijder IndexedDB-items door een database te selecteren. <a data-l10n-name="learn-more-link">Meer info</a>

# Hint shown when the cache storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cache_Storage
storage-table-type-cache-hint = Bekijk en verwijder de bufferopslagitems door een opslag te selecteren. <a data-l10n-name="learn-more-link">Meer info</a>

# Hint shown when the extension storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Extension_Storage
storage-table-type-extensionstorage-hint = Bekijk en bewerk de extensieopslag door een host te selecteren. <a data-l10n-name="learn-more-link">Meer info</a>

# Placeholder for the searchbox that allows you to filter the table items
storage-search-box =
    .placeholder = Items filteren

# Placeholder text in the sidebar search box
storage-variable-view-search-box =
    .placeholder = Waarden filteren

# Add Item button title
storage-add-button =
    .title = Item toevoegen

# Refresh button title
storage-refresh-button =
    .title = Items vernieuwen

# Context menu action to delete all storage items
storage-context-menu-delete-all =
    .label = Alles verwijderen

# Context menu action to delete all session cookies
storage-context-menu-delete-all-session-cookies =
    .label = Alle sessiecookies verwijderen

# Context menu action to copy a storage item
storage-context-menu-copy =
    .label = Kopiëren

# Context menu action to delete storage item
# Variables:
#   $itemName (String) - Name of the storage item that will be deleted
storage-context-menu-delete =
    .label = ‘{ $itemName }’ verwijderen

# Context menu action to add an item
storage-context-menu-add-item =
    .label = Item toevoegen

# Context menu action to delete all storage items from a given host
# Variables:
#   $host (String) - Host for which we want to delete the items
storage-context-menu-delete-all-from =
    .label = Alles van ‘{ $host }’ verwijderen

## Header names of the columns in the Storage Table for each type of storage available
## through the Storage Tree to the side.

storage-table-headers-cookies-name = Naam
storage-table-headers-cookies-value = Waarde
storage-table-headers-cookies-expires = Verloopt / maximale leeftijd
storage-table-headers-cookies-size = Grootte
storage-table-headers-cookies-last-accessed = Laatst benaderd
storage-table-headers-cookies-creation-time = Aangemaakt
storage-table-headers-cache-status = Status
storage-table-headers-extension-storage-area = Opslagruimte

## Labels for Storage type groups present in the Storage Tree, like cookies, local storage etc.

storage-tree-labels-cookies = Cookies
storage-tree-labels-local-storage = Lokale opslag
storage-tree-labels-session-storage = Sessieopslag
storage-tree-labels-indexed-db = Indexed DB
storage-tree-labels-cache = Bufferopslag
storage-tree-labels-extension-storage = Uitbreidingsopslag

##

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is closed.
storage-expand-pane =
    .title = Paneel uitvouwen

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is open.
storage-collapse-pane =
    .title = Paneel samenvouwen

# String displayed in the expires column when the cookie is a Session Cookie
storage-expires-session = Sessie

# Heading displayed over the item value in the sidebar
storage-data = Gegevens

# Heading displayed over the item parsed value in the sidebar
storage-parsed-value = Geparsete waarde

# Warning notification when IndexedDB database could not be deleted immediately.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-blocked = Database ‘{ $dbName }’ zal worden verwijderd nadat alle verbindingen zijn gesloten.

# Error notification when IndexedDB database could not be deleted.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-error = Database ‘{ $dbName }’ kon niet worden verwijderd.
