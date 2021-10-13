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
about-addressbook-sort-button =
    .title = Thay đổi thứ tự danh sách
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

## Details

about-addressbook-begin-edit-contact-button = Chỉnh sửa
about-addressbook-cancel-edit-contact-button = Hủy bỏ
about-addressbook-save-edit-contact-button = Lưu
about-addressbook-details-email-addresses-header = Địa chỉ e-mail
about-addressbook-details-phone-numbers-header = Số điện thoại
about-addressbook-details-home-address-header = Địa chỉ nhà
about-addressbook-details-work-address-header = Địa chỉ cơ quan
about-addressbook-details-other-info-header = Thông tin khác
