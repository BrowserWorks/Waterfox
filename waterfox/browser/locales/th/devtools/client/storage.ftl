# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Storage Inspector.

# Key shortcut used to focus the filter box on top of the data view
storage-filter-key = CmdOrCtrl+F

# Hint shown when the selected storage host does not contain any data
storage-table-empty-text = ไม่มีข้อมูลปรากฏสำหรับโฮสต์ที่เลือก

# Hint shown when the cookies storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cookies
storage-table-type-cookies-hint = ดูและแก้ไขคุกกี้โดยเลือกโฮสต์ <a data-l10n-name="learn-more-link">เรียนรู้เพิ่มเติม</a>

# Hint shown when the local storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-localstorage-hint = ดูและแก้ไขที่เก็บภายในเครื่องโดยเลือกโฮสต์ <a data-l10n-name="learn-more-link">เรียนรู้เพิ่มเติม</a>

# Hint shown when the session storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-sessionstorage-hint = ดูและแก้ไขที่เก็บวาระโดยเลือกโฮสต์ <a data-l10n-name="learn-more-link">เรียนรู้เพิ่มเติม</a>

# Hint shown when the IndexedDB storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/IndexedDB
storage-table-type-indexeddb-hint = ดูและลบรายการ IndexedDB โดยเลือกฐานข้อมูล <a data-l10n-name="learn-more-link">เรียนรู้เพิ่มเติม</a>

# Hint shown when the cache storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cache_Storage
storage-table-type-cache-hint = ดูและลบรายการที่เก็บแคชโดยเลือกที่เก็บ <a data-l10n-name="learn-more-link">เรียนรู้เพิ่มเติม</a>

# Hint shown when the extension storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Extension_Storage
storage-table-type-extensionstorage-hint = ดูและแก้ไขที่เก็บส่วนขยายโดยเลือกโฮสต์ <a data-l10n-name="learn-more-link">เรียนรู้เพิ่มเติม</a>

# Placeholder for the searchbox that allows you to filter the table items
storage-search-box =
    .placeholder = กรองรายการ

# Placeholder text in the sidebar search box
storage-variable-view-search-box =
    .placeholder = กรองค่า

# Add Item button title
storage-add-button =
    .title = เพิ่มรายการ

# Refresh button title
storage-refresh-button =
    .title = เรียกรายการใหม่

# Context menu action to delete all storage items
storage-context-menu-delete-all =
    .label = ลบทั้งหมด

# Context menu action to delete all session cookies
storage-context-menu-delete-all-session-cookies =
    .label = ลบคุกกี้ในวาระทั้งหมด

# Context menu action to copy a storage item
storage-context-menu-copy =
    .label = คัดลอก

# Context menu action to delete storage item
# Variables:
#   $itemName (String) - Name of the storage item that will be deleted
storage-context-menu-delete =
    .label = ลบ “{ $itemName }”

# Context menu action to add an item
storage-context-menu-add-item =
    .label = เพิ่มรายการ

# Context menu action to delete all storage items from a given host
# Variables:
#   $host (String) - Host for which we want to delete the items
storage-context-menu-delete-all-from =
    .label = ลบทั้งหมดจาก “{ $host }”

## Header names of the columns in the Storage Table for each type of storage available
## through the Storage Tree to the side.

storage-table-headers-cookies-name = ชื่อ
storage-table-headers-cookies-value = ค่า
storage-table-headers-cookies-expires = Expires / Max-Age
storage-table-headers-cookies-size = ขนาด
storage-table-headers-cookies-last-accessed = เข้าถึงล่าสุด
storage-table-headers-cookies-creation-time = สร้างเมื่อ
storage-table-headers-cache-status = สถานะ
storage-table-headers-extension-storage-area = พื้นที่เก็บข้อมูล

## Labels for Storage type groups present in the Storage Tree, like cookies, local storage etc.

storage-tree-labels-cookies = คุกกี้
storage-tree-labels-local-storage = ที่เก็บข้อมูลในเครื่อง
storage-tree-labels-session-storage = ที่เก็บข้อมูลวาระ
storage-tree-labels-indexed-db = Indexed DB
storage-tree-labels-cache = ที่เก็บข้อมูลแคช
storage-tree-labels-extension-storage = ที่เก็บข้อมูลส่วนขยาย

##

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is closed.
storage-expand-pane =
    .title = ขยายบานหน้าต่าง

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is open.
storage-collapse-pane =
    .title = ยุบบานหน้าต่าง

# String displayed in the expires column when the cookie is a Session Cookie
storage-expires-session = วาระ

# Heading displayed over the item value in the sidebar
storage-data = ข้อมูล

# Heading displayed over the item parsed value in the sidebar
storage-parsed-value = ค่าที่แยกวิเคราะห์

# Warning notification when IndexedDB database could not be deleted immediately.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-blocked = ฐานข้อมูล “{ $dbName }” จะถูกลบหลังจากการเชื่อมต่อทั้งหมดถูกปิด

# Error notification when IndexedDB database could not be deleted.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-error = ไม่สามารถลบฐานข้อมูล “{ $dbName }”
