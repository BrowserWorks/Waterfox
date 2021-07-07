# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Gặp gỡ { -brand-short-name } hoàn toàn mới
upgrade-dialog-new-subtitle = Được thiết kế để đưa bạn đến nơi bạn muốn, nhanh hơn
upgrade-dialog-new-item-menu-title = Thanh công cụ và menu được sắp xếp hợp lý
upgrade-dialog-new-item-menu-description = Ưu tiên những việc quan trọng để bạn tìm thấy những gì bạn cần.
upgrade-dialog-new-item-tabs-title = Các thẻ hiện đại
upgrade-dialog-new-item-tabs-description = Chứa thông tin một cách gọn gàng, hỗ trợ tập trung và chuyển động linh hoạt.
upgrade-dialog-new-item-icons-title = Biểu tượng mới và thông báo rõ ràng hơn
upgrade-dialog-new-item-icons-description = Giúp bạn bắt đầu nhanh chóng và dễ dàng sử dụng.
upgrade-dialog-new-primary-default-button = Đặt { -brand-short-name } làm trình duyệt mặc định của tôi
upgrade-dialog-new-primary-theme-button = Chọn một chủ đề
upgrade-dialog-new-secondary-button = Không phải bây giờ
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = Ok, đã hiểu!

## Pin Waterfox screen
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
upgrade-dialog-default-title-2 = Đặt { -brand-short-name } làm trình duyệt mặc định của bạn
upgrade-dialog-default-subtitle-2 = Đặt tốc độ, an toàn và quyền riêng tư vào chế độ tự động.
upgrade-dialog-default-primary-button-2 = Đặt làm trình duyệt mặc định
upgrade-dialog-default-secondary-button = Không phải bây giờ

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Bắt đầu với một chủ đề mới
upgrade-dialog-theme-system = Chủ đề hệ thống
    .title = Áp dụng theo chủ đề hệ điều hành cho các nút, menu và cửa sổ

## Start screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-start-title = Cuộc sống đầy màu sắc
upgrade-dialog-start-subtitle = Màu sắc mới sống động. Có sẵn trong một thời gian giới hạn.
upgrade-dialog-start-primary-button = Khám phá các màu
upgrade-dialog-start-secondary-button = Không phải bây giờ

## Colorway screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-colorway-title = Chọn bảng màu của bạn
upgrade-dialog-colorway-home-checkbox = Chuyển sang Trang chủ Waterfox với nền theo chủ đề
upgrade-dialog-colorway-primary-button = Lưu màu
upgrade-dialog-colorway-secondary-button = Giữ chủ đề trước đó
upgrade-dialog-colorway-theme-tooltip =
    .title = Khám phá các chủ đề mặc định
# $colorwayName (String) - Name of colorway, e.g., Abstract, Cheers
upgrade-dialog-colorway-colorway-tooltip =
    .title = Khám phá các màu { $colorwayName }
upgrade-dialog-colorway-default-theme = Mặc định
# "Auto" is short for "Automatic"
upgrade-dialog-colorway-theme-auto = Tự động
    .title = Đặt theo chủ đề hệ điều hành cho các nút, menu và cửa sổ
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
upgrade-dialog-colorway-variation-soft = Mềm
    .title = Sử dụng đường màu này
upgrade-dialog-colorway-variation-balanced = Cân bằng
    .title = Sử dụng đường màu này
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
upgrade-dialog-colorway-variation-bold = Đậm
    .title = Sử dụng đường màu này

## Thank you screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-thankyou-title = Cảm ơn bạn đã chọn chúng tôi
upgrade-dialog-thankyou-subtitle = { -brand-short-name } là một trình duyệt độc lập được hỗ trợ bởi một tổ chức phi lợi nhuận. Cùng nhau, chúng ta đang làm cho web an toàn hơn, lành mạnh hơn và riêng tư hơn.
upgrade-dialog-thankyou-primary-button = Bắt đầu duyệt web
