# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Storage Inspector.

# Key shortcut used to focus the filter box on top of the data view
storage-filter-key = CmdOrCtrl+F

# Hint shown when the selected storage host does not contain any data
storage-table-empty-text = Keine Daten für gewählten Host vorhanden

# Hint shown when the cookies storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cookies
storage-table-type-cookies-hint = Zum Anzeigen und Bearbeiten von Cookies einen Host auswählen. <a data-l10n-name="learn-more-link">Weitere Informationen</a>

# Hint shown when the local storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-localstorage-hint = Zum Anzeigen und Bearbeiten von Local Storage einen Host auswählen. <a data-l10n-name="learn-more-link">Weitere Informationen</a>

# Hint shown when the session storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-sessionstorage-hint = Zum Anzeigen und Bearbeiten von Session Storage einen Host auswählen. <a data-l10n-name="learn-more-link">Weitere Informationen</a>

# Hint shown when the IndexedDB storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/IndexedDB
storage-table-type-indexeddb-hint = Zum Anzeigen und Löschen von IndexedDB-Einträgen einen Host auswählen. <a data-l10n-name="learn-more-link">Weitere Informationen</a>

# Hint shown when the cache storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cache_Storage
storage-table-type-cache-hint = Zum Anzeigen und Löschen von Cache-Speicher-Einträgen einen Host auswählen. <a data-l10n-name="learn-more-link">Weitere Informationen</a>

# Hint shown when the extension storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Extension_Storage
storage-table-type-extensionstorage-hint = Zum Anzeigen und Bearbeiten von Erweiterungen-Speicher einen Host auswählen. <a data-l10n-name="learn-more-link">Weitere Informationen</a>

# Placeholder for the searchbox that allows you to filter the table items
storage-search-box =
    .placeholder = Einträge durchsuchen

# Placeholder text in the sidebar search box
storage-variable-view-search-box =
    .placeholder = Werte durchsuchen

# Add Item button title
storage-add-button =
    .title = Eintrag hinzufügen

# Refresh button title
storage-refresh-button =
    .title = Einträge neu laden

# Context menu action to delete all storage items
storage-context-menu-delete-all =
    .label = Alles löschen

# Context menu action to delete all session cookies
storage-context-menu-delete-all-session-cookies =
    .label = Alle Sitzungs-Cookies löschen

# Context menu action to copy a storage item
storage-context-menu-copy =
    .label = Kopieren

# Context menu action to delete storage item
# Variables:
#   $itemName (String) - Name of the storage item that will be deleted
storage-context-menu-delete =
    .label = "{ $itemName }" löschen

# Context menu action to add an item
storage-context-menu-add-item =
    .label = Eintrag hinzufügen

# Context menu action to delete all storage items from a given host
# Variables:
#   $host (String) - Host for which we want to delete the items
storage-context-menu-delete-all-from =
    .label = Alles von "{ $host }" löschen

## Header names of the columns in the Storage Table for each type of storage available
## through the Storage Tree to the side.

storage-table-headers-cookies-name = Name
storage-table-headers-cookies-value = Wert
storage-table-headers-cookies-expires = Läuft ab / Höchstalter
storage-table-headers-cookies-size = Größe
storage-table-headers-cookies-last-accessed = Zuletzt zugegriffen
storage-table-headers-cookies-creation-time = Erstellt
storage-table-headers-cache-status = Status
storage-table-headers-extension-storage-area = Speicherbereich

## Labels for Storage type groups present in the Storage Tree, like cookies, local storage etc.

storage-tree-labels-cookies = Cookies
storage-tree-labels-local-storage = Local Storage
storage-tree-labels-session-storage = Session Storage
storage-tree-labels-indexed-db = Indexed DB
storage-tree-labels-cache = Cache-Speicher
storage-tree-labels-extension-storage = Erweiterungen-Speicher

##

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is closed.
storage-expand-pane =
    .title = Ansicht ausklappen

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is open.
storage-collapse-pane =
    .title = Ansicht einklappen

# String displayed in the expires column when the cookie is a Session Cookie
storage-expires-session = Sitzungsende

# Heading displayed over the item value in the sidebar
storage-data = Daten

# Heading displayed over the item parsed value in the sidebar
storage-parsed-value = Gespeicherter Wert

# Warning notification when IndexedDB database could not be deleted immediately.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-blocked = Datenbank "{ $dbName }" wird nach dem Schließen aller Verbindungen gelöscht.

# Error notification when IndexedDB database could not be deleted.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-error = Datenbank "{ $dbName }" konnte nicht gelöscht werden.
