# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# NOTE: For English locales, strings in this file should be in APA-style Title Case.
# See https://apastyle.apa.org/style-grammar-guidelines/capitalization/title-case
#
# NOTE: For Engineers, please don't re-use these strings outside of the menubar.


## Application Menu (macOS only)

menu-application-preferences =
    .label = Tùy chỉnh
menu-application-services =
    .label = Dịch vụ
menu-application-hide-this =
    .label = Ẩn { -brand-shorter-name }
menu-application-hide-other =
    .label = Ẩn các mục khác
menu-application-show-all =
    .label = Hiển thị tất cả
menu-application-touch-bar =
    .label = Tùy chỉnh Touch Bar…

##

# These menu-quit strings are only used on Windows and Linux.
menu-quit =
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
# This menu-quit-mac string is only used on macOS.
menu-quit-mac =
    .label = Thoát { -brand-shorter-name }
# This menu-quit-button string is only used on Linux.
menu-quit-button =
    .label = { menu-quit.label }
# This menu-quit-button-win string is only used on Windows.
menu-quit-button-win =
    .label = { menu-quit.label }
    .tooltip = Thoát { -brand-shorter-name }
menu-about =
    .label = Về { -brand-shorter-name }
    .accesskey = A

## File Menu

menu-file =
    .label = Tập tin
    .accesskey = F
menu-file-new-tab =
    .label = Thẻ mới
    .accesskey = T
menu-file-new-container-tab =
    .label = Ngăn chứa thẻ mới
    .accesskey = B
menu-file-new-window =
    .label = Cửa sổ mới
    .accesskey = N
menu-file-new-private-window =
    .label = Cửa sổ riêng tư mới
    .accesskey = W
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Mở địa chỉ…
menu-file-open-file =
    .label = Mở tập tin…
    .accesskey = O
menu-file-close =
    .label = Đóng
    .accesskey = C
menu-file-close-window =
    .label = Đóng cửa sổ
    .accesskey = d
menu-file-save-page =
    .label = Lưu trang dưới dạng…
    .accesskey = A
menu-file-email-link =
    .label = Gửi liên kết qua email…
    .accesskey = E
menu-file-print-setup =
    .label = Thiết lập trang…
    .accesskey = u
menu-file-print-preview =
    .label = Xem trước trang in
    .accesskey = v
menu-file-print =
    .label = In…
    .accesskey = P
menu-file-import-from-another-browser =
    .label = Nhập dữ liệu từ trình duyệt khác…
    .accesskey = I
menu-file-go-offline =
    .label = Làm việc ngoại tuyến
    .accesskey = k

## Edit Menu

menu-edit =
    .label = Chỉnh sửa
    .accesskey = E
menu-edit-find-on =
    .label = Tìm trong trang này…
    .accesskey = F
menu-edit-find-in-page =
    .label = Tìm trong trang…
    .accesskey = F
menu-edit-find-again =
    .label = Tìm lại
    .accesskey = g
menu-edit-bidi-switch-text-direction =
    .label = Chuyển hướng văn bản
    .accesskey = w

## View Menu

menu-view =
    .label = Hiển thị
    .accesskey = V
menu-view-toolbars-menu =
    .label = Thanh công cụ
    .accesskey = T
menu-view-customize-toolbar =
    .label = Tùy biến…
    .accesskey = C
menu-view-customize-toolbar2 =
    .label = Tùy biến thanh công cụ…
    .accesskey = C
menu-view-sidebar =
    .label = Thanh lề
    .accesskey = e
menu-view-bookmarks =
    .label = Dấu trang
menu-view-history-button =
    .label = Lịch sử
menu-view-synced-tabs-sidebar =
    .label = Các thẻ đã đồng bộ
menu-view-full-zoom =
    .label = Thu phóng
    .accesskey = Z
menu-view-full-zoom-enlarge =
    .label = Phóng to
    .accesskey = I
menu-view-full-zoom-reduce =
    .label = Thu nhỏ
    .accesskey = O
menu-view-full-zoom-actual-size =
    .label = Kích thước thực
    .accesskey = A
menu-view-full-zoom-toggle =
    .label = Chỉ phóng to văn bản
    .accesskey = T
menu-view-page-style-menu =
    .label = Kiểu của trang
    .accesskey = y
menu-view-page-style-no-style =
    .label = Không có kiểu
    .accesskey = n
menu-view-page-basic-style =
    .label = Kiểu trang cơ bản
    .accesskey = b
menu-view-charset =
    .label = Bảng mã văn bản
    .accesskey = c
menu-view-repair-text-encoding =
    .label = Sửa chữa mã hóa văn bản
    .accesskey = c

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Vào chế độ toàn màn hình
    .accesskey = F
menu-view-exit-full-screen =
    .label = Thoát chế độ toàn màn hình
    .accesskey = F
menu-view-full-screen =
    .label = Toàn màn hình
    .accesskey = F

##

menu-view-show-all-tabs =
    .label = Hiện tất cả các thẻ
    .accesskey = A
menu-view-bidi-switch-page-direction =
    .label = Chuyển hướng trang
    .accesskey = D

## History Menu

menu-history =
    .label = Lịch sử
    .accesskey = s
menu-history-show-all-history =
    .label = Xem toàn bộ lịch sử
menu-history-clear-recent-history =
    .label = Xóa lịch sử gần đây…
menu-history-synced-tabs =
    .label = Các thẻ đã đồng bộ
menu-history-restore-last-session =
    .label = Khôi phục phiên làm việc trước
menu-history-hidden-tabs =
    .label = Thẻ đã ẩn
menu-history-undo-menu =
    .label = Thẻ mới đóng gần đây
menu-history-undo-window-menu =
    .label = Các cửa sổ mới đóng
menu-history-reopen-all-tabs = Mở lại tất cả các thẻ
menu-history-reopen-all-windows = Mở lại tất cả các cửa sổ

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Dấu trang
    .accesskey = B
menu-bookmarks-show-all =
    .label = Xem tất cả dấu trang
menu-bookmark-this-page =
    .label = Đánh dấu trang này
menu-bookmarks-manage =
    .label = Quản lý dấu trang
menu-bookmark-current-tab =
    .label = Đánh dấu thẻ hiện tại
menu-bookmark-edit =
    .label = Chỉnh sửa dấu trang này
menu-bookmarks-all-tabs =
    .label = Đánh dấu tất cả các thẻ…
menu-bookmarks-toolbar =
    .label = Thanh dấu trang
menu-bookmarks-other =
    .label = Dấu trang khác
menu-bookmarks-mobile =
    .label = Dấu trang trên di động

## Tools Menu

menu-tools =
    .label = Công cụ
    .accesskey = T
menu-tools-downloads =
    .label = Tải xuống
    .accesskey = D
menu-tools-addons =
    .label = Tiện ích
    .accesskey = A
menu-tools-fxa-sign-in =
    .label = Đăng nhập vào { -brand-product-name }…
    .accesskey = g
menu-tools-turn-on-sync =
    .label = Bật { -sync-brand-short-name }…
    .accesskey = n
menu-tools-addons-and-themes =
    .label = Tiện ích mở rộng và chủ đề
    .accesskey = A
menu-tools-fxa-sign-in2 =
    .label = Đăng nhập
    .accesskey = g
menu-tools-turn-on-sync2 =
    .label = Bật đồng bộ hóa…
    .accesskey = n
menu-tools-sync-now =
    .label = Đồng bộ ngay
    .accesskey = S
menu-tools-fxa-re-auth =
    .label = Kết nối lại vào { -brand-product-name }…
    .accesskey = R
menu-tools-web-developer =
    .label = Nhà phát triển Web
    .accesskey = W
menu-tools-browser-tools =
    .label = Công cụ trình duyệt
    .accesskey = B
menu-tools-task-manager =
    .label = Trình quản lý tác vụ
    .accesskey = M
menu-tools-page-source =
    .label = Mở mã nguồn trang
    .accesskey = o
menu-tools-page-info =
    .label = Thông tin về trang này
    .accesskey = I
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Tùy chọn
           *[other] Tùy chỉnh
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] n
        }
menu-settings =
    .label = Cài đặt
    .accesskey =
        { PLATFORM() ->
            [windows] S
           *[other] n
        }
menu-tools-layout-debugger =
    .label = Trình gỡ lỗi bố cục
    .accesskey = L

## Window Menu

menu-window-menu =
    .label = Cửa sổ
menu-window-bring-all-to-front =
    .label = Đưa tất cả ra phía trước

## Help Menu


# NOTE: For Engineers, any additions or changes to Help menu strings should
# also be reflected in the related strings in appmenu.ftl. Those strings, by
# convention, will have the same ID as these, but prefixed with "app".
# Example: appmenu-get-help
#
# These strings are duplicated to allow for different casing depending on
# where the strings appear.

menu-help =
    .label = Trợ giúp
    .accesskey = H
menu-help-product =
    .label = Trợ giúp { -brand-shorter-name }
    .accesskey = H
menu-help-show-tour =
    .label = Các tính năng cơ bản của { -brand-shorter-name }
    .accesskey = o
menu-help-import-from-another-browser =
    .label = Nhập dữ liệu từ trình duyệt khác…
    .accesskey = I
menu-help-keyboard-shortcuts =
    .label = Các phím tắt bàn phím
    .accesskey = K
menu-help-troubleshooting-info =
    .label = Thông tin xử lý sự cố
    .accesskey = T
menu-get-help =
    .label = Nhận trợ giúp
    .accesskey = H
menu-help-more-troubleshooting-info =
    .label = Thông tin xử lý sự cố khác
    .accesskey = T
menu-help-report-site-issue =
    .label = Báo cáo vấn đề về trang…
menu-help-feedback-page =
    .label = Gửi phản hồi…
    .accesskey = S
menu-help-safe-mode-without-addons =
    .label = Khởi động lại và vô hiệu hóa các tiện ích…
    .accesskey = R
menu-help-safe-mode-with-addons =
    .label = Khởi động lại và kích hoạt các tiện ích
    .accesskey = R
menu-help-enter-troubleshoot-mode2 =
    .label = Chế độ xử lý sự cố…
    .accesskey = M
menu-help-exit-troubleshoot-mode =
    .label = Tắt chế độ xử lý sự cố
    .accesskey = M
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = Báo cáo trang lừa đảo…
    .accesskey = c
menu-help-not-deceptive =
    .label = Đây không phải là một trang lừa đảo…
    .accesskey = d
