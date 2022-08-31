# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Storage Inspector.

# Key shortcut used to focus the filter box on top of the data view
storage-filter-key = CmdOrCtrl+F

# Hint shown when the selected storage host does not contain any data
storage-table-empty-text = Không có dữ liệu cho máy chủ được chọn

# Hint shown when the cookies storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cookies
storage-table-type-cookies-hint = Xem và chỉnh sửa cookie bằng cách chọn một máy chủ lưu trữ. <a data-l10n-name="learn-more-link">Tìm hiểu thêm</a>

# Hint shown when the local storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-localstorage-hint = Xem và chỉnh sửa bộ nhớ cục bộ bằng cách chọn một máy chủ lưu trữ. <a data-l10n-name="learn-more-link">Tìm hiểu thêm</a>

# Hint shown when the session storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage
storage-table-type-sessionstorage-hint = Xem và chỉnh sửa bộ nhớ phiên bằng cách chọn máy chủ lưu trữ. <a data-l10n-name="learn-more-link">Tìm hiểu thêm</a>

# Hint shown when the IndexedDB storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/IndexedDB
storage-table-type-indexeddb-hint = Xem và xóa các mục IndexedDBbằng cách chọn cơ sở dữ liệu. <a data-l10n-name="learn-more-link">Tìm hiểu thêm</a>

# Hint shown when the cache storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Cache_Storage
storage-table-type-cache-hint = Xem và xóa các mục lưu trữ bộ nhớ đệm bằng cách chọn một bộ lưu trữ. <a data-l10n-name="learn-more-link">Tìm hiểu thêm</a>

# Hint shown when the extension storage type is selected. Clicking the link will open
# https://developer.mozilla.org/docs/Tools/Storage_Inspector/Extension_Storage
storage-table-type-extensionstorage-hint = Xem và chỉnh sửa bộ nhớ tiện ích mở rộng bằng cách chọn máy chủ. <a data-l10n-name="learn-more-link">Tìm hiểu thêm</a>

# Placeholder for the searchbox that allows you to filter the table items
storage-search-box =
    .placeholder = Lọc các mục

# Placeholder text in the sidebar search box
storage-variable-view-search-box =
    .placeholder = Lọc giá trị

# Add Item button title
storage-add-button =
    .title = Thêm mục

# Refresh button title
storage-refresh-button =
    .title = Làm mới mục

# Context menu action to delete all storage items
storage-context-menu-delete-all =
    .label = Xoá tất cả

# Context menu action to delete all session cookies
storage-context-menu-delete-all-session-cookies =
    .label = Xóa tất cả cookie của phiên

# Context menu action to copy a storage item
storage-context-menu-copy =
    .label = Sao chép

# Context menu action to delete storage item
# Variables:
#   $itemName (String) - Name of the storage item that will be deleted
storage-context-menu-delete =
    .label = Xóa “{ $itemName }”

# Context menu action to add an item
storage-context-menu-add-item =
    .label = Thêm mục

# Context menu action to delete all storage items from a given host
# Variables:
#   $host (String) - Host for which we want to delete the items
storage-context-menu-delete-all-from =
    .label = Xóa tất cả khỏi “{ $host }”

## Header names of the columns in the Storage Table for each type of storage available
## through the Storage Tree to the side.

storage-table-headers-cookies-name = Tên
storage-table-headers-cookies-value = Giá trị
storage-table-headers-cookies-expires = Expires / Max-Age
storage-table-headers-cookies-size = Kích thước
storage-table-headers-cookies-last-accessed = Lần truy cập cuối
storage-table-headers-cookies-creation-time = Được tạo
storage-table-headers-cache-status = Trạng thái
storage-table-headers-extension-storage-area = Khu vực lưu trữ

## Labels for Storage type groups present in the Storage Tree, like cookies, local storage etc.

storage-tree-labels-cookies = Cookie
storage-tree-labels-local-storage = Lưu trữ cục bộ
storage-tree-labels-session-storage = Lưu trữ phiên
storage-tree-labels-indexed-db = Đã lập chỉ mục DB
storage-tree-labels-cache = Bộ nhớ đệm
storage-tree-labels-extension-storage = Lưu trữ tiện ích mở rộng

##

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is closed.
storage-expand-pane =
    .title = Mở rộng ngăn

# Tooltip for the button that collapses the right panel in the
# storage UI when the panel is open.
storage-collapse-pane =
    .title = Thu gọn ngăn

# String displayed in the expires column when the cookie is a Session Cookie
storage-expires-session = Phiên

# Heading displayed over the item value in the sidebar
storage-data = Dữ liệu

# Heading displayed over the item parsed value in the sidebar
storage-parsed-value = Giá trị phân tích

# Warning notification when IndexedDB database could not be deleted immediately.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-blocked = Cơ sở dữ liệu “{ $dbName }” sẽ bị xóa sau khi tất cả các kết nối được đóng lại.

# Error notification when IndexedDB database could not be deleted.
# Variables:
#   $dbName (String) - Name of the database
storage-idb-delete-error = Không thể xóa cơ sở dữ liệu “{ $dbName }”.
