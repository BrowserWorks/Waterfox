# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Storage Inspector.

# Key shortcut used to focus the filter box on top of the data view
storage-filter-key = CmdOrCtrl+F

# Hint shown when the selected storage host does not contain any data
storage-table-empty-text = لا بيانات متوافرة للمضيف المنتقى

# Hint shown when the cookies storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cookies
storage-table-type-cookies-hint = اعرض الكعكات وحرّرها باختيار مضيف. <a data-l10n-name="learn-more-link">اطّلع على المزيد</a>

# Hint shown when the local storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-localstorage-hint = اعرض التخزين المحلي وحرّره باختيار مضيف. <a data-l10n-name="learn-more-link">اطّلع على المزيد</a>

# Hint shown when the session storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-sessionstorage-hint = اعرض تخزين الجلسة وحرّره باختيار مضيف. <a data-l10n-name="learn-more-link">اطّلع على المزيد</a>

# Hint shown when the IndexedDB storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/IndexedDB
storage-table-type-indexeddb-hint = اعرض مدخلات IndexedDB واحذفها باختيار قاعدة بيانات. <a data-l10n-name="learn-more-link">اطّلع على المزيد</a>

# Hint shown when the cache storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cache_Storage
storage-table-type-cache-hint = اعرض مدخلات التخزين المخبّأ باختيار تخزين. <a data-l10n-name="learn-more-link">اطّلع على المزيد</a>

# Hint shown when the extension storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Extension_Storage
storage-table-type-extensionstorage-hint = اعرض تخزين الامتداد وحرّره باختيار مضيف. <a data-l10n-name="learn-more-link">اطّلع على المزيد</a>

# Placeholder for the searchbox that allows you to filter the table items
storage-search-box =
    .placeholder = رشّح العناصر

# Placeholder text in the sidebar search box
storage-variable-view-search-box =
    .placeholder = رشّح القيم

# Add Item button title
storage-add-button =
    .title = أضف عنصرا

# Refresh button title
storage-refresh-button =
    .title = أنعِش العناصر

# Context menu action to delete all storage items
storage-context-menu-delete-all =
    .label = احذف الكل

# Context menu action to delete all session cookies
storage-context-menu-delete-all-session-cookies =
    .label = احذف كل كعكات الجلسة

# Context menu action to delete storage item
# Variables:
#   $itemName (String) - Name of the storage item that will be deleted
storage-context-menu-delete =
    .label = احذف ”{ $itemName }“

# Context menu action to add an item
storage-context-menu-add-item =
    .label = أضف عنصرا

# Context menu action to delete all storage items from a given host
# Variables:
#   $host (String) - Host for which we want to delete the items
storage-context-menu-delete-all-from =
    .label = احذف الكل من ”‎{ $host }“

## Header names of the columns in the Storage Table for each type of storage available
## through the Storage Tree to the side.

storage-table-headers-cookies-name = الاسم
storage-table-headers-cookies-value = القيمة
storage-table-headers-cookies-size = الحجم
storage-table-headers-cookies-last-accessed = تاريخ آخر وصول
storage-table-headers-cookies-creation-time = تاريخ الإنشاء
storage-table-headers-cache-status = الحالة

## Labels for Storage type groups present in the Storage Tree, like cookies, local storage etc.

storage-tree-labels-cookies = الكعكات
storage-tree-labels-local-storage = المخزون المحلي
storage-tree-labels-session-storage = مخزون الجلسة
storage-tree-labels-cache = مخزون الخبيئة

##

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is closed.
storage-expand-pane =
    .title = وسّع اللوحة

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is open.
storage-collapse-pane =
    .title = اطوِ اللوحة

# String displayed in the expires column when the cookie is a Session Cookie
storage-expires-session = الجلسة

# Heading displayed over the item value in the sidebar
storage-data = البيانات

# Warning notification when IndexedDB database could not be deleted immediately.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-blocked = ستُحذف قاعدة البيانات ”{ $dbName }“ بعد إغلاق كل الاتصالات.

# Error notification when IndexedDB database could not be deleted.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-error = تعذر حذف قاعدة البيانات ”{ $dbName }“.
