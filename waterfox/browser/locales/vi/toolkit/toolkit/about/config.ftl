# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Tiến hành thận trọng
about-config-intro-warning-text = Thay đổi tùy chọn cấu hình nâng cao có thể ảnh hưởng đến hiệu suất hoặc bảo mật { -brand-short-name }.
about-config-intro-warning-checkbox = Cảnh báo khi tôi cố gắng truy cập các tùy chọn này
about-config-intro-warning-button = Chấp nhận rủi ro và tiếp tục

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Thay đổi các tùy chọn này có thể ảnh hưởng đến hiệu suất hoặc bảo mật { -brand-short-name }.

about-config-page-title = Tùy chọn nâng cao

about-config-search-input1 =
    .placeholder = Tìm kiếm tên tùy chỉnh
about-config-show-all = Hiển thị tất cả

about-config-show-only-modified = Chỉ hiển thị các tùy chọn đã sửa đổi

about-config-pref-add-button =
    .title = Thêm
about-config-pref-toggle-button =
    .title = Bật/Tắt
about-config-pref-edit-button =
    .title = Chỉnh sửa
about-config-pref-save-button =
    .title = Lưu
about-config-pref-reset-button =
    .title = Đặt lại
about-config-pref-delete-button =
    .title = Xóa

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Logic
about-config-pref-add-type-number = Số
about-config-pref-add-type-string = Chuỗi

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (mặc định)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (tùy chỉnh)
