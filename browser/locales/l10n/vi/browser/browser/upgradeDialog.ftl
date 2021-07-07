# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Gặp gỡ { -brand-short-name } hoàn toàn mới
upgrade-dialog-new-subtitle = Được thiết kế để đưa bạn đến nơi bạn muốn, nhanh hơn
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline
# style to be automatically added to the text inside it. { -brand-short-name }
# should stay inside the span.
upgrade-dialog-new-alt-subtitle = Bắt đầu sử dụng <span data-l10n-name="zap">{ -brand-short-name }</span> sau vài cú nhấp chuột
upgrade-dialog-new-item-menu-title = Thanh công cụ và menu được sắp xếp hợp lý
upgrade-dialog-new-item-menu-description = Ưu tiên những việc quan trọng để bạn tìm thấy những gì bạn cần.
upgrade-dialog-new-item-tabs-title = Các thẻ hiện đại
upgrade-dialog-new-item-tabs-description = Chứa thông tin một cách gọn gàng, hỗ trợ tập trung và chuyển động linh hoạt.
upgrade-dialog-new-item-icons-title = Biểu tượng mới và thông báo rõ ràng hơn
upgrade-dialog-new-item-icons-description = Giúp bạn bắt đầu nhanh chóng và dễ dàng sử dụng.
upgrade-dialog-new-primary-primary-button = Đặt { -brand-short-name } làm trình duyệt mặc định của tôi
    .title = Đặt { -brand-short-name } làm trình duyệt mặc định và ghim vào thanh tác vụ
upgrade-dialog-new-primary-default-button = Đặt { -brand-short-name } làm trình duyệt mặc định của tôi
upgrade-dialog-new-primary-pin-button = Ghim { -brand-short-name } vào thanh tác vụ của tôi
upgrade-dialog-new-primary-pin-alt-button = Ghim vào thanh tác vụ
upgrade-dialog-new-primary-theme-button = Chọn một chủ đề
upgrade-dialog-new-secondary-button = Không phải bây giờ
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = Ok, đã hiểu!

## Pin Firefox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-pin-title =
    { PLATFORM() ->
        [macos] Giữ { -brand-short-name } trong Dock của bạn
       *[other] Ghim { -brand-short-name } vào thanh tác vụ của bạn
    }
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle =
    { PLATFORM() ->
        [macos] Dễ dàng truy cập vào { -brand-short-name } mới nhất.
       *[other] Giữ { -brand-short-name } mới nhất trong tầm tay.
    }
upgrade-dialog-pin-primary-button =
    { PLATFORM() ->
        [macos] Thêm vào thanh Dock
       *[other] Ghim vào thanh tác vụ
    }
upgrade-dialog-pin-secondary-button = Không phải bây giờ

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title = Đặt { -brand-short-name } làm trình duyệt mặc định của bạn?
upgrade-dialog-default-subtitle = Tốc độ, an toàn và quyền riêng tư mỗi khi bạn duyệt.
upgrade-dialog-default-primary-button = Đặt làm trình duyệt mặc định
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = Đặt { -brand-short-name } làm trình duyệt mặc định của bạn
upgrade-dialog-default-subtitle-2 = Đặt tốc độ, an toàn và quyền riêng tư vào chế độ tự động.
upgrade-dialog-default-primary-button-2 = Đặt làm trình duyệt mặc định
upgrade-dialog-default-secondary-button = Không phải bây giờ

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title =
    Khởi đầu dễ dàng
    với một chủ đề mới
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Bắt đầu với một chủ đề mới
upgrade-dialog-theme-system = Chủ đề hệ thống
    .title = Áp dụng theo chủ đề hệ điều hành cho các nút, menu và cửa sổ
upgrade-dialog-theme-light = Sáng
    .title = Sử dụng chủ đề sáng cho các nút, menu và cửa sổ
upgrade-dialog-theme-dark = Tối
    .title = Sử dụng chủ đề tối cho các nút, menu và cửa sổ
upgrade-dialog-theme-alpenglow = Alpenglow
    .title = Sử dụng chủ đề động, đầy màu sắc cho các nút, menu và cửa sổ
upgrade-dialog-theme-keep = Giữ trước
    .title = Sử dụng chủ đề bạn đã cài đặt trước khi cập nhật { -brand-short-name }
upgrade-dialog-theme-primary-button = Lưu chủ đề
upgrade-dialog-theme-secondary-button = Không phải bây giờ
