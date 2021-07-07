# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Công cụ nhà phát triển mặc định
# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Không được hỗ trợ cho hộp công cụ đích hiện tại
# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Công cụ phát triển được cài đặt bởi tiến ích
# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Các nút trên hộp công cụ có sẵn
# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Chủ đề

## Inspector section

# The heading
options-context-inspector = Trình kiểm tra
# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Hiển thị kiểu của trình duyệt
options-show-user-agent-styles-tooltip =
    .title = Bật tính năng này sẽ hiển thị các kiểu mặc định được tải bởi trình duyệt.
# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Cắt bớt các thuộc tính DOM
options-collapse-attrs-tooltip =
    .title = Cắt ngắn các thuộc tính dài trong trình kiểm tra

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Đơn vị màu mặc định
options-default-color-unit-authored = Theo bản gốc
options-default-color-unit-hex = Thập lục phân
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Tên màu

## Style Editor section

# The heading
options-styleeditor-label = Trình chỉnh sửa kiểu mẫu
# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = Tự động điền CSS
options-stylesheet-autocompletion-tooltip =
    .title = Tự động điền các thuộc tính, giá trị và bộ chọn CSS trong trình chỉnh sửa kiểu mẫu khi bạn nhập

## Screenshot section

# The heading
options-screenshot-label = Hành vi chụp màn hình
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Sao chép ảnh chụp màn hình vào bộ nhớ tạm
options-screenshot-clipboard-tooltip =
    .title = Lưu ảnh chụp màn hình trực tiếp vào bộ nhớ tạm
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-only-label = Chỉ chụp màn hình vào khay nhớ tạm
options-screenshot-clipboard-tooltip2 =
    .title = Lưu ảnh chụp màn hình trực tiếp vào khay nhớ tạm
# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Bật tiếng chụp ảnh
options-screenshot-audio-tooltip =
    .title = Bật âm thanh camera khi chụp ảnh màn hình

## Editor section

# The heading
options-sourceeditor-label = Tùy chỉnh trình soạn thảo
options-sourceeditor-detectindentation-tooltip =
    .title = Dự đoán cách thụt lề dựa trên nội dung của mã nguồn
options-sourceeditor-detectindentation-label = Phát hiện thụt lề
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Tự động chèn dấu đóng
options-sourceeditor-autoclosebrackets-label = Tự đóng dấu ngoặc
options-sourceeditor-expandtab-tooltip =
    .title = Sử dụng dấu cách thay cho ký tự tab
options-sourceeditor-expandtab-label = Căn lề bằng khoảng trắng
options-sourceeditor-tabsize-label = Kích cỡ phím tab
options-sourceeditor-keybinding-label = Tổ hợp phím
options-sourceeditor-keybinding-default-label = Mặc định

## Advanced section

# The heading (this item is also used in perftools.ftl)
options-context-advanced-settings = Cài đặt nâng cao
# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Vô hiệu hóa bộ đệm HTTP (khi hộp công cụ đang mở)
options-disable-http-cache-tooltip =
    .title = Bật tùy chọn này sẽ vô hiệu hóa bộ đệm HTTP cho tất cả các thẻ có hộp công cụ mở. Service Worker không bị ảnh hưởng bởi tùy chọn này.
# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Tắt JavaScript *
options-disable-javascript-tooltip =
    .title = Bật tùy chọn này sẽ vô hiệu hóa JavaScript cho thẻ hiện tại. Nếu thẻ hoặc hộp công cụ bị đóng thì sẽ tự động tắt tùy chọn này.
# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Kích hoạt trình duyệt chrome và các hộp công cụ gỡ lỗi tiện ích
options-enable-chrome-tooltip =
    .title = Bật tùy chọn này sẽ cho phép bạn sử dụng các công cụ dành cho nhà phát triển khác nhau trong ngữ cảnh trình duyệt (thông qua Công cụ > Nhà phát triển web > Hộp công cụ trình duyệt) và gỡ lỗi các tiện ích từ trình quản lý tiện ích
# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Cho phép gỡ lỗi từ xa
options-enable-remote-tooltip2 =
    .title = Bật tùy chọn này sẽ cho phép gỡ lỗi phiên bản trình duyệt này từ xa
# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Cho phép Service Worker qua HTTP (khi hộp công cụ mở)
options-enable-service-workers-http-tooltip =
    .title = Bật tùy chọn này sẽ cho phép service workers qua HTTP cho tất cả các thẻ đang mở hộp công cụ.
# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Bật bản đồ nguồn
options-source-maps-tooltip =
    .title = Nếu bạn bật tùy chọn này, các nguồn sẽ được ánh xạ trong các công cụ.
# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Chỉ phiên hiện tại, tải lại trang
# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Hiện dữ liệu nền tảng Gecko
options-show-platform-data-tooltip =
    .title =
        Nếu bạn bật tùy chọn này, báo cáo trình cấu hình JavaScript sẽ bao gồm
        kí hiệu nền tảng Gecko
