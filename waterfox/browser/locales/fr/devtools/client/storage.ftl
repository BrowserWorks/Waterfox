# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Storage Inspector.

# Key shortcut used to focus the filter box on top of the data view
storage-filter-key = CmdOrCtrl+F

# Hint shown when the selected storage host does not contain any data
storage-table-empty-text = Aucune donnée pour l’hôte sélectionné

# Hint shown when the cookies storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cookies
storage-table-type-cookies-hint = Affichez et modifiez les cookies en sélectionnant un hôte. <a data-l10n-name="learn-more-link">En savoir plus</a>

# Hint shown when the local storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-localstorage-hint = Affichez et modifiez le stockage local en sélectionnant un hôte. <a data-l10n-name="learn-more-link">En savoir plus</a>

# Hint shown when the session storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-sessionstorage-hint = Affichez et modifiez le stockage de session en sélectionnant un hôte. <a data-l10n-name="learn-more-link">En savoir plus</a>

# Hint shown when the IndexedDB storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/IndexedDB
storage-table-type-indexeddb-hint = Affichez et supprimez les entrées IndexedDB en sélectionnant une base de données. <a data-l10n-name="learn-more-link">En savoir plus</a>

# Hint shown when the cache storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cache_Storage
storage-table-type-cache-hint = Affichez et supprimez les entrées de stockage du cache en sélectionnant un stockage. <a data-l10n-name="learn-more-link">En savoir plus</a>

# Hint shown when the extension storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Extension_Storage
storage-table-type-extensionstorage-hint = Affichez et modifiez le stockage des extensions en sélectionnant un hôte. <a data-l10n-name="learn-more-link">En savoir plus</a>

# Placeholder for the searchbox that allows you to filter the table items
storage-search-box =
    .placeholder = Filtrer les éléments

# Placeholder text in the sidebar search box
storage-variable-view-search-box =
    .placeholder = Filtrer les valeurs

# Add Item button title
storage-add-button =
    .title = Ajouter un élément

# Refresh button title
storage-refresh-button =
    .title = Actualiser la liste

# Context menu action to delete all storage items
storage-context-menu-delete-all =
    .label = Tout supprimer

# Context menu action to delete all session cookies
storage-context-menu-delete-all-session-cookies =
    .label = Supprimer tous les cookies de session

# Context menu action to copy a storage item
storage-context-menu-copy =
    .label = Copier

# Context menu action to delete storage item
# Variables:
#   $itemName (String) - Name of the storage item that will be deleted
storage-context-menu-delete =
    .label = Supprimer « { $itemName } »

# Context menu action to add an item
storage-context-menu-add-item =
    .label = Ajouter un élément

# Context menu action to delete all storage items from a given host
# Variables:
#   $host (String) - Host for which we want to delete the items
storage-context-menu-delete-all-from =
    .label = Supprimer tous les éléments de « { $host } »

## Header names of the columns in the Storage Table for each type of storage available
## through the Storage Tree to the side.

storage-table-headers-cookies-name = Nom
storage-table-headers-cookies-value = Valeur
storage-table-headers-cookies-expires = Expiration / Durée maximum
storage-table-headers-cookies-size = Taille
storage-table-headers-cookies-last-accessed = Dernier accès
storage-table-headers-cookies-creation-time = Date de création
storage-table-headers-cache-status = État
storage-table-headers-extension-storage-area = Zone de stockage

## Labels for Storage type groups present in the Storage Tree, like cookies, local storage etc.

storage-tree-labels-cookies = Cookies
storage-tree-labels-local-storage = Stockage local
storage-tree-labels-session-storage = Stockage de session
storage-tree-labels-indexed-db = Indexed DB
storage-tree-labels-cache = Stockage cache
storage-tree-labels-extension-storage = Stockage d’extension

##

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is closed.
storage-expand-pane =
    .title = Développer le panneau

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is open.
storage-collapse-pane =
    .title = Réduire le panneau

# String displayed in the expires column when the cookie is a Session Cookie
storage-expires-session = Session

# Heading displayed over the item value in the sidebar
storage-data = Données

# Heading displayed over the item parsed value in the sidebar
storage-parsed-value = Valeur analysée

# Warning notification when IndexedDB database could not be deleted immediately.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-blocked = La base de données « { $dbName } » sera supprimée une fois toutes les connexions fermées.

# Error notification when IndexedDB database could not be deleted.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-error = La base de données « { $dbName } » ne peut pas être supprimée.
