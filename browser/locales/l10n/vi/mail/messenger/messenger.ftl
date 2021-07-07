# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
    { $count ->
       *[other] { $count } tin nhắn chưa đọc
    }
about-rights-notification-text = { -brand-short-name } là phần mềm nguồn mở và miễn phí, được xây dựng bởi một cộng đồng gồm hàng ngàn người từ khắp nơi trên thế giới.

## Content tabs

content-tab-page-loading-icon =
    .alt = Đang tải trang
content-tab-security-high-icon =
    .alt = Kết nối an toàn
content-tab-security-broken-icon =
    .alt = Kết nối không an toàn

## Toolbar

addons-and-themes-toolbarbutton =
    .label = Tiện ích mở rộng và chủ đề
    .tooltiptext = Quản lý tiện ích của bạn
quick-filter-toolbarbutton =
    .label = Bộ lọc nhanh
    .tooltiptext = Lọc thư
redirect-msg-button =
    .label = Chuyển hướng
    .tooltiptext = Chuyển hướng tin nhắn đã chọn

## Folder Pane

folder-pane-toolbar =
    .toolbarname = Thanh công cụ ngăn thư mục
    .accesskey = F
folder-pane-toolbar-options-button =
    .tooltiptext = Tùy chọn ngăn thư mục
folder-pane-header-label = Thư mục

## Folder Toolbar Header Popup

folder-toolbar-hide-toolbar-toolbarbutton =
    .label = Ẩn thanh công cụ
    .accesskey = H
show-all-folders-label =
    .label = Tất cả thư mục
    .accesskey = A
show-unread-folders-label =
    .label = Thư mục chưa đọc
    .accesskey = n
show-favorite-folders-label =
    .label = Thư mục yêu thích
    .accesskey = F
show-smart-folders-label =
    .label = Thư mục hợp nhất
    .accesskey = U
show-recent-folders-label =
    .label = Thư mục gần đây
    .accesskey = R
folder-toolbar-toggle-folder-compact-view =
    .label = Chế độ xem thu gọn
    .accesskey = C

## Menu

redirect-msg-menuitem =
    .label = Chuyển hướng
    .accesskey = D

## AppMenu

# Since v89 we dropped the platforms distinction between Options or Preferences
# and consolidated everything with Preferences.
appmenu-preferences =
    .label = Tùy chỉnh
appmenu-addons-and-themes =
    .label = Tiện ích mở rộng và chủ đề
appmenu-help-enter-troubleshoot-mode =
    .label = Chế độ xử lý sự cố…
appmenu-help-exit-troubleshoot-mode =
    .label = Tắt chế độ xử lý sự cố
appmenu-help-more-troubleshooting-info =
    .label = Thông tin xử lý sự cố khác
appmenu-redirect-msg =
    .label = Chuyển hướng

## Context menu

context-menu-redirect-msg =
    .label = Chuyển hướng

## Message header pane

other-action-redirect-msg =
    .label = Chuyển hướng

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = Quản lí tiện ích
    .accesskey = E
toolbar-context-menu-remove-extension =
    .label = Xóa tiện ích mở rộng
    .accesskey = v

## Message headers

message-header-address-in-address-book-icon =
    .alt = Địa chỉ có trong sổ địa chỉ
message-header-address-not-in-address-book-icon =
    .alt = Địa chỉ không có trong sổ địa chỉ

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Xóa { $name }?
addon-removal-confirmation-button = Xóa
addon-removal-confirmation-message = Xóa { $name } cũng như cài đặt và dữ liệu của nó khỏi { -brand-short-name }?
caret-browsing-prompt-title = Duyệt với con trỏ
caret-browsing-prompt-text = Nhấn F7 sẽ bật hoặc tắt duyệt với con trỏ (Caret). Tính năng này đặt một con trỏ có thể di chuyển trong một số nội dung, cho phép bạn chọn văn bản bằng bàn phím. Bạn có muốn bật duyệt với con trỏ không?
caret-browsing-prompt-check-text = Đừng hỏi lại.
repair-text-encoding-button =
    .label = Sửa chữa mã hóa văn bản
    .tooltiptext = Đoán mã hóa văn bản chính xác từ nội dung tin nhắn

## no-reply handling

no-reply-title = Không hỗ trợ trả lời
no-reply-message = Địa chỉ trả lời ({ $email }) dường như không phải là địa chỉ được giám sát. Thư đến địa chỉ này có thể sẽ không được đọc bởi bất kỳ ai.
no-reply-reply-anyway-button = Vẫn trả lời
