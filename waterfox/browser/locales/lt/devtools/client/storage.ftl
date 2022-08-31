# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Storage Inspector.

# Key shortcut used to focus the filter box on top of the data view
storage-filter-key = CmdOrCtrl+F

# Hint shown when the selected storage host does not contain any data
storage-table-empty-text = Pasirinktam serveriui nėra rodytinų duomenų

# Hint shown when the cookies storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cookies
storage-table-type-cookies-hint = Peržiūrėkite ir keiskite slapukus pasirinkę serverį. <a data-l10n-name="learn-more-link">Sužinoti daugiau</a>

# Hint shown when the local storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-localstorage-hint = Peržiūrėkite ir keiskite vietinę saugyklą pasirinkę serverį. <a data-l10n-name="learn-more-link">Sužinoti daugiau</a>

# Hint shown when the session storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-sessionstorage-hint = Peržiūrėkite ir keiskite seanso duomenis pasirinkę serverį. <a data-l10n-name="learn-more-link">Sužinoti daugiau</a>

# Hint shown when the IndexedDB storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/IndexedDB
storage-table-type-indexeddb-hint = Peržiūrėkite ir šalinkite „IndexedDB“ įrašus pasirinkę duomenų bazę. <a data-l10n-name="learn-more-link">Sužinoti daugiau</a>

# Hint shown when the cache storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cache_Storage
storage-table-type-cache-hint = Peržiūrėkite ir šalinkite podėlio saugyklos įrašus pasirinkę saugyklą. <a data-l10n-name="learn-more-link">Sužinoti daugiau</a>

# Hint shown when the extension storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Extension_Storage
storage-table-type-extensionstorage-hint = Peržiūrėkite ir keiskite priedo saugyklą pasirinkę serverį. <a data-l10n-name="learn-more-link">Sužinoti daugiau</a>

# Placeholder for the searchbox that allows you to filter the table items
storage-search-box =
    .placeholder = Filtruoti elementus

# Placeholder text in the sidebar search box
storage-variable-view-search-box =
    .placeholder = Filtruoti reikšmes

# Add Item button title
storage-add-button =
    .title = Pridėti įrašą

# Refresh button title
storage-refresh-button =
    .title = Atnaujinti elementus

# Context menu action to delete all storage items
storage-context-menu-delete-all =
    .label = Ištrinti viską

# Context menu action to delete all session cookies
storage-context-menu-delete-all-session-cookies =
    .label = Pašalinti visus seanso slapukus

# Context menu action to copy a storage item
storage-context-menu-copy =
    .label = Kopijuoti

# Context menu action to delete storage item
# Variables:
#   $itemName (String) - Name of the storage item that will be deleted
storage-context-menu-delete =
    .label = Pašalinti „{ $itemName }“

# Context menu action to add an item
storage-context-menu-add-item =
    .label = Pridėti įrašą

# Context menu action to delete all storage items from a given host
# Variables:
#   $host (String) - Host for which we want to delete the items
storage-context-menu-delete-all-from =
    .label = Pašalinti viską iš „{ $host }“

## Header names of the columns in the Storage Table for each type of storage available
## through the Storage Tree to the side.

storage-table-headers-cookies-name = Pavadinimas
storage-table-headers-cookies-value = Reikšmė
storage-table-headers-cookies-expires = Pasibaigia / Maks. amžius
storage-table-headers-cookies-size = Dydis
storage-table-headers-cookies-last-accessed = Vėliausiai kreiptasi
storage-table-headers-cookies-creation-time = Sukurta
storage-table-headers-cache-status = Būsena
storage-table-headers-extension-storage-area = Saugyklos sritis

## Labels for Storage type groups present in the Storage Tree, like cookies, local storage etc.

storage-tree-labels-cookies = Slapukai
storage-tree-labels-local-storage = Vietinė saugykla
storage-tree-labels-session-storage = Seanso saugykla
storage-tree-labels-indexed-db = Indeksuotoji DB
storage-tree-labels-cache = Podėlio saugykla
storage-tree-labels-extension-storage = Priedų saugykla

##

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is closed.
storage-expand-pane =
    .title = Išskleisti polangį

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is open.
storage-collapse-pane =
    .title = Suskleisti polangį

# String displayed in the expires column when the cookie is a Session Cookie
storage-expires-session = Seansas

# Heading displayed over the item value in the sidebar
storage-data = Kita

# Heading displayed over the item parsed value in the sidebar
storage-parsed-value = Išanalizuota reikšmė

# Warning notification when IndexedDB database could not be deleted immediately.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-blocked = Duomenų bazė „{ $dbName }“ bus pašalinta kai visi prisijungimai bus uždaryti.

# Error notification when IndexedDB database could not be deleted.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-error = Duomenų bazės „{ $dbName }“ pašalinti nepavyko.
