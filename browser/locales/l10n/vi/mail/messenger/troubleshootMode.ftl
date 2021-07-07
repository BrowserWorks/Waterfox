# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

troubleshoot-mode-window =
    .title = Chế độ xử lý sự cố của { -brand-short-name }
    .style = width: 37em;
troubleshoot-mode-description = Sử dụng chế độ xử lý sự cố { -brand-short-name } để chẩn đoán sự cố. Các tiện ích mở rộng và tùy chỉnh của bạn sẽ tạm thời bị vô hiệu hóa.
troubleshoot-mode-description2 = Bạn có thể chuyển một số hoặc tất cả các thiết lập sau đây thành những thay đổi vĩnh viễn:
troubleshoot-mode-disable-addons =
    .label = Vô hiệu hóa tất cả tiện ích
    .accesskey = D
troubleshoot-mode-reset-toolbars =
    .label = Đặt lại các thanh công cụ và điều khiển về mặc định
    .accesskey = R
troubleshoot-mode-change-and-restart =
    .label = Lưu thay đổi và khởi động lại
    .accesskey = M
troubleshoot-mode-continue =
    .label = Tiếp tục ở chế độ xử lý sự cố
    .accesskey = C
troubleshoot-mode-quit =
    .label =
        { PLATFORM() ->
            [windows] Thoát
           *[other] Thoát
        }
    .accesskey =
        { PLATFORM() ->
            [windows] x
           *[other] Q
        }
