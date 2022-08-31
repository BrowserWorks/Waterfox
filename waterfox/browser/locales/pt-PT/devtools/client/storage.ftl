# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Storage Inspector.

# Key shortcut used to focus the filter box on top of the data view
storage-filter-key = CmdOrCtrl+F

# Hint shown when the selected storage host does not contain any data
storage-table-empty-text = Sem dados existentes para o servidor selecionado

# Hint shown when the cookies storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cookies
storage-table-type-cookies-hint = Visualize e edite cookies selecionando um servidor. <a data-l10n-name="learn-more-link">Saber mais</a>

# Hint shown when the local storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-localstorage-hint = Visualize e edite o armazenamento local selecionando um servidor. <a data-l10n-name="learn-more-link">Saber mais</a>

# Hint shown when the session storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-sessionstorage-hint = Visualize e edite o armazenamento da sessão selecionando um servidor. <a data-l10n-name="learn-more-link">Saber mais</a>

# Hint shown when the IndexedDB storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/IndexedDB
storage-table-type-indexeddb-hint = Visualize e elimine entradas IndexedDB selecionando uma base de dados. <a data-l10n-name="learn-more-link">Saber mais</a>

# Hint shown when the cache storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cache_Storage
storage-table-type-cache-hint = Visualize e elimine entradas do armazenamento da cache selecionando um servidor. <a data-l10n-name="learn-more-link">Saber mais</a>

# Hint shown when the extension storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Extension_Storage
storage-table-type-extensionstorage-hint = Visualize e edite o armazenamento das extensões selecionando um servidor. <a data-l10n-name="learn-more-link">Saber mais</a>

# Placeholder for the searchbox that allows you to filter the table items
storage-search-box =
    .placeholder = Filtrar itens

# Placeholder text in the sidebar search box
storage-variable-view-search-box =
    .placeholder = Filtrar valores

# Add Item button title
storage-add-button =
    .title = Adicionar item

# Refresh button title
storage-refresh-button =
    .title = Atualizar itens

# Context menu action to delete all storage items
storage-context-menu-delete-all =
    .label = Apagar todos

# Context menu action to delete all session cookies
storage-context-menu-delete-all-session-cookies =
    .label = Apagar todos os cookies da sessão

# Context menu action to copy a storage item
storage-context-menu-copy =
    .label = Copiar

# Context menu action to delete storage item
# Variables:
#   $itemName (String) - Name of the storage item that will be deleted
storage-context-menu-delete =
    .label = Apagar “{ $itemName }”

# Context menu action to add an item
storage-context-menu-add-item =
    .label = Adicionar item

# Context menu action to delete all storage items from a given host
# Variables:
#   $host (String) - Host for which we want to delete the items
storage-context-menu-delete-all-from =
    .label = Apagar tudo de “{ $host }”

## Header names of the columns in the Storage Table for each type of storage available
## through the Storage Tree to the side.

storage-table-headers-cookies-name = Nome
storage-table-headers-cookies-value = Valor
storage-table-headers-cookies-expires = Expira / Idade máxima
storage-table-headers-cookies-size = Tamanho
storage-table-headers-cookies-last-accessed = Último acesso
storage-table-headers-cookies-creation-time = Criado
storage-table-headers-cache-status = Estado
storage-table-headers-extension-storage-area = Área de armazenamento

## Labels for Storage type groups present in the Storage Tree, like cookies, local storage etc.

storage-tree-labels-cookies = Cookies
storage-tree-labels-local-storage = Armazenamento local
storage-tree-labels-session-storage = Armazenamento da sessão
storage-tree-labels-indexed-db = BD indexada
storage-tree-labels-cache = Armazenamento de cache
storage-tree-labels-extension-storage = Armazenamento da extensão

##

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is closed.
storage-expand-pane =
    .title = Expandir painel

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is open.
storage-collapse-pane =
    .title = Colapsar painel

# String displayed in the expires column when the cookie is a Session Cookie
storage-expires-session = Sessão

# Heading displayed over the item value in the sidebar
storage-data = Dados

# Heading displayed over the item parsed value in the sidebar
storage-parsed-value = Valor analisado

# Warning notification when IndexedDB database could not be deleted immediately.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-blocked = A base de dados “{ $dbName }” será apagada depois de todas as ligações estarem fechadas.

# Error notification when IndexedDB database could not be deleted.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-error = A base de dados “{ $dbName }” não pode ser apagada.
