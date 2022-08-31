# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Sổ địa chỉ

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = Sổ địa chỉ mới
about-addressbook-toolbar-add-carddav-address-book =
    .label = Thêm sổ địa chỉ CardDAV
about-addressbook-toolbar-add-ldap-address-book =
    .label = Thêm sổ địa chỉ LDAP
about-addressbook-toolbar-new-contact =
    .label = Liên hệ mới
about-addressbook-toolbar-new-list =
    .label = Danh sách mới
about-addressbook-toolbar-import =
    .label = Nhập

## Books

all-address-books = Tất cả các sổ địa chỉ
about-addressbook-books-context-properties =
    .label = Thuộc tính
about-addressbook-books-context-synchronize =
    .label = Đồng bộ hoá
about-addressbook-books-context-edit =
    .label = Chỉnh sửa
about-addressbook-books-context-print =
    .label = In…
about-addressbook-books-context-export =
    .label = Xuất…
about-addressbook-books-context-delete =
    .label = Xóa
about-addressbook-books-context-remove =
    .label = Xóa
about-addressbook-books-context-startup-default =
    .label = Thư mục khởi động mặc định
about-addressbook-confirm-delete-book-title = Xóa sổ địa chỉ
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = Bạn có chắc chắn muốn xóa { $name } và tất cả các địa chỉ liên hệ của nó không?
about-addressbook-confirm-remove-remote-book-title = Xóa sổ địa chỉ
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = Bạn có chắc chắn muốn xóa { $name } không?

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = Tìm kiếm { $name }
about-addressbook-search-all =
    .placeholder = Tìm kiếm tất cả các sổ địa chỉ
about-addressbook-sort-button2 =
    .title = Tùy chọn hiển thị liệt kê
about-addressbook-name-format-display =
    .label = Tên hiển thị
about-addressbook-name-format-firstlast =
    .label = Tên Họ
about-addressbook-name-format-lastfirst =
    .label = Họ, Tên
about-addressbook-sort-name-ascending =
    .label = Sắp xếp theo tên (A > Z)
about-addressbook-sort-name-descending =
    .label = Sắp xếp theo tên (Z > A)
about-addressbook-sort-email-ascending =
    .label = Sắp xếp theo địa chỉ e-mail (A > Z)
about-addressbook-sort-email-descending =
    .label = Sắp xếp theo địa chỉ e-mail (Z > A)
about-addressbook-horizontal-layout =
    .label = Chuyển sang bố cục ngang
about-addressbook-vertical-layout =
    .label = Chuyển sang bố cục dọc

## Card column headers
## Each string is listed here twice, and the values should match.

about-addressbook-column-header-generatedname = Tên
about-addressbook-column-label-generatedname =
    .label = { about-addressbook-column-header-generatedname }
about-addressbook-column-header-emailaddresses = Địa chỉ email
about-addressbook-column-label-emailaddresses =
    .label = { about-addressbook-column-header-emailaddresses }
about-addressbook-column-header-phonenumbers = Số điện thoại
about-addressbook-column-label-phonenumbers =
    .label = { about-addressbook-column-header-phonenumbers }
about-addressbook-column-header-addresses = Địa chỉ
about-addressbook-column-label-addresses =
    .label = { about-addressbook-column-header-addresses }
about-addressbook-column-header-title = Chức danh
about-addressbook-column-label-title =
    .label = { about-addressbook-column-header-title }
about-addressbook-column-header-department = Bộ phận
about-addressbook-column-label-department =
    .label = { about-addressbook-column-header-department }
about-addressbook-column-header-organization = Tổ chức
about-addressbook-column-label-organization =
    .label = { about-addressbook-column-header-organization }
about-addressbook-column-header-addrbook = Sổ địa chỉ
about-addressbook-column-label-addrbook =
    .label = { about-addressbook-column-header-addrbook }
about-addressbook-cards-context-write =
    .label = Viết
about-addressbook-confirm-delete-mixed-title = Xóa liên hệ và danh sách
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed = Bạn có chắc chắn muốn xóa { $count } liên hệ và danh sách này không?
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
    { $count ->
       *[other] Xóa các danh sách
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
    { $count ->
       *[other] Bạn có chắc chắn muốn xóa { $count } danh sách này không?
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
    { $count ->
       *[other] Xóa liên hệ
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
# $name (String) - The name of the contact to be removed, if $count is 1.
# $list (String) - The name of the list that contacts will be removed from.
about-addressbook-confirm-remove-contacts =
    { $count ->
       *[other] Bạn có chắc chắn muốn xóa { $count } địa chỉ liên hệ này khỏi { $list } không?
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
about-addressbook-confirm-delete-contacts-title =
    { $count ->
       *[other] Xóa liên hệ
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
# $name (String) - The name of the contact to be deleted, if $count is 1.
about-addressbook-confirm-delete-contacts =
    { $count ->
       *[other] Bạn có chắc chắn muốn xóa { $count } địa chỉ liên hệ này không?
    }

## Card list placeholder
## Shown when there are no cards in the list

about-addressbook-placeholder-empty-book = Không có liên hệ có sẵn
about-addressbook-placeholder-new-contact = Liên hệ mới
about-addressbook-placeholder-search-only = Sổ địa chỉ này chỉ hiển thị liên hệ sau khi tìm kiếm
about-addressbook-placeholder-searching = Đang tìm kiếm…
about-addressbook-placeholder-no-search-results = Không tìm thấy liên hệ

## Details

about-addressbook-prefer-display-name = Ưu tiên tên hiển thị hơn tiêu đề thư
about-addressbook-write-action-button = Viết thư
about-addressbook-event-action-button = Sự kiện
about-addressbook-search-action-button = Tìm kiếm
about-addressbook-begin-edit-contact-button = Chỉnh sửa
about-addressbook-delete-edit-contact-button = Xóa
about-addressbook-cancel-edit-contact-button = Hủy bỏ
about-addressbook-save-edit-contact-button = Lưu
about-addressbook-add-contact-to = Thêm vào:
about-addressbook-details-email-addresses-header = Địa chỉ e-mail
about-addressbook-details-phone-numbers-header = Số điện thoại
about-addressbook-details-addresses-header = Địa chỉ
about-addressbook-details-notes-header = Ghi chú
about-addressbook-details-other-info-header = Thông tin khác
about-addressbook-entry-type-work = Công việc
about-addressbook-entry-type-home = Nhà riêng
about-addressbook-entry-type-fax = Fax
about-addressbook-entry-type-cell = Di động
about-addressbook-entry-type-pager = Máy nhắn tin
about-addressbook-entry-name-birthday = Ngày sinh
about-addressbook-entry-name-anniversary = Ngày kỷ niệm
about-addressbook-entry-name-title = Chức danh
about-addressbook-entry-name-role = Vai trò
about-addressbook-entry-name-organization = Tổ chức
about-addressbook-entry-name-website = Trang web
about-addressbook-entry-name-time-zone = Múi giờ
about-addressbook-unsaved-changes-prompt-title = Các thay đổi chưa được lưu
about-addressbook-unsaved-changes-prompt = Bạn có muốn lưu các thay đổi của mình trước khi rời khỏi chế độ chỉnh sửa không?

# Photo dialog

about-addressbook-photo-drop-target = Thả hoặc dán ảnh vào đây hoặc nhấp để chọn tập tin.
about-addressbook-photo-drop-loading = Đang tải ảnh…
about-addressbook-photo-drop-error = Không tải được ảnh.
about-addressbook-photo-filepicker-title = Chọn một tập tin hình ảnh
about-addressbook-photo-discard = Hủy ảnh hiện có
about-addressbook-photo-cancel = Hủy bỏ
about-addressbook-photo-save = Lưu
