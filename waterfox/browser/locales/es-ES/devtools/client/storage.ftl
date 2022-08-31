# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Storage Inspector.

# Key shortcut used to focus the filter box on top of the data view
storage-filter-key = CmdOrCtrl+F

# Hint shown when the selected storage host does not contain any data
storage-table-empty-text = No hay datos para el servidor seleccionado

# Hint shown when the cookies storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cookies
storage-table-type-cookies-hint = Vea y edite cookies seleccionando un servidor. <a data-l10n-name="learn-more-link">Saber más</a>

# Hint shown when the local storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-localstorage-hint = Vea y edite el almacenamiento local seleccionando un servidor. <a data-l10n-name="learn-more-link">Saber más</a>

# Hint shown when the session storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-sessionstorage-hint = Vea y edite el almacenamiento de sesión seleccionando un servidor. <a data-l10n-name="learn-more-link">Saber más</a>

# Hint shown when the IndexedDB storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/IndexedDB
storage-table-type-indexeddb-hint = Vea y elimine entradas de IndexedDB seleccionando una base de datos. <a data-l10n-name="learn-more-link">Saber más</a>

# Hint shown when the cache storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cache_Storage
storage-table-type-cache-hint = Vea y elimine las entradas de almacenamiento caché seleccionando un almacenamiento. <a data-l10n-name="learn-more-link">Saber más</a>

# Hint shown when the extension storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Extension_Storage
storage-table-type-extensionstorage-hint = Vea y edite el almacenamiento de extensión seleccionando un servidor. <a data-l10n-name="learn-more-link">Saber más</a>

# Placeholder for the searchbox that allows you to filter the table items
storage-search-box =
    .placeholder = Filtrar elementos

# Placeholder text in the sidebar search box
storage-variable-view-search-box =
    .placeholder = Filtrar valores

# Add Item button title
storage-add-button =
    .title = Añadir elemento

# Refresh button title
storage-refresh-button =
    .title = Actualizar elementos

# Context menu action to delete all storage items
storage-context-menu-delete-all =
    .label = Eliminar todo

# Context menu action to delete all session cookies
storage-context-menu-delete-all-session-cookies =
    .label = Eliminar todas las cookies de sesión

# Context menu action to copy a storage item
storage-context-menu-copy =
    .label = Copiar

# Context menu action to delete storage item
# Variables:
#   $itemName (String) - Name of the storage item that will be deleted
storage-context-menu-delete =
    .label = Eliminar “{ $itemName }“

# Context menu action to add an item
storage-context-menu-add-item =
    .label = Añadir elemento

# Context menu action to delete all storage items from a given host
# Variables:
#   $host (String) - Host for which we want to delete the items
storage-context-menu-delete-all-from =
    .label = Eliminar todo de “{ $host }”

## Header names of the columns in the Storage Table for each type of storage available
## through the Storage Tree to the side.

storage-table-headers-cookies-name = Nombre
storage-table-headers-cookies-value = Valor
storage-table-headers-cookies-expires = Expires / Max-Age
storage-table-headers-cookies-size = Tamaño
storage-table-headers-cookies-last-accessed = Último acceso
storage-table-headers-cookies-creation-time = Creado
storage-table-headers-cache-status = Estado
storage-table-headers-extension-storage-area = Área de almacenamiento

## Labels for Storage type groups present in the Storage Tree, like cookies, local storage etc.

storage-tree-labels-cookies = Cookies
storage-tree-labels-local-storage = Almacenamiento local
storage-tree-labels-session-storage = Almacenamiento de sesión
storage-tree-labels-indexed-db = Indexed DB
storage-tree-labels-cache = Almacenamiento en caché
storage-tree-labels-extension-storage = Almacenamiento de la extensión

##

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is closed.
storage-expand-pane =
    .title = Expandir panel

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is open.
storage-collapse-pane =
    .title = Colapsar panel

# String displayed in the expires column when the cookie is a Session Cookie
storage-expires-session = Sesión

# Heading displayed over the item value in the sidebar
storage-data = Datos

# Heading displayed over the item parsed value in the sidebar
storage-parsed-value = Valor interpretado

# Warning notification when IndexedDB database could not be deleted immediately.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-blocked = La base de datos “{ $dbName }” se eliminará tras cerrarse todas sus conexiones.

# Error notification when IndexedDB database could not be deleted.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-error = La base de datos “{ $dbName }” no se ha podido eliminar.
