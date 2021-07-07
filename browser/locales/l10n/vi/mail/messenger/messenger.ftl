# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
    { $count ->
       *[other] { $count } tin nhắn chưa đọc
    }
about-rights-notification-text = { -brand-short-name } là phần mềm nguồn mở và miễn phí, được xây dựng bởi một cộng đồng gồm hàng ngàn người từ khắp nơi trên thế giới.

## Toolbar

addons-and-themes-button =
    .label = Tiện ích mở rộng và chủ đề
    .tooltip = Quản lý tiện ích mở rộng của bạn

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

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = Quản lí tiện ích
    .accesskey = E
toolbar-context-menu-remove-extension =
    .label = Xóa tiện ích mở rộng
    .accesskey = v

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Xóa { $name }?
addon-removal-confirmation-button = Xóa
addon-removal-confirmation-message = Xóa { $name } cũng như cài đặt và dữ liệu của nó khỏi { -brand-short-name }?
