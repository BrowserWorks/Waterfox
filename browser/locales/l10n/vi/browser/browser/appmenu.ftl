# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-update-banner3 =
    .label-update-downloading = Đang tải xuống bản cập nhật { -brand-shorter-name }
    .label-update-available = Đã có bản cập nhật — tải xuống ngay
    .label-update-manual = Đã có bản cập nhật — tải xuống ngay
    .label-update-unsupported = Không thể cập nhật — hệ thống không tương thích
    .label-update-restart = Đã có bản cập nhật — khởi động lại ngay
appmenuitem-protection-dashboard-title = Bảng điều khiển bảo vệ
appmenuitem-customize-mode =
    .label = Tùy biến…

## Zoom Controls

appmenuitem-new-tab =
    .label = Thẻ mới
appmenuitem-new-window =
    .label = Cửa sổ mới
appmenuitem-new-private-window =
    .label = Cửa sổ riêng tư mới
appmenuitem-passwords =
    .label = Mật khẩu
appmenuitem-addons-and-themes =
    .label = Tiện ích mở rộng và chủ đề
appmenuitem-find-in-page =
    .label = Tìm trong trang…
appmenuitem-more-tools =
    .label = Thêm công cụ
appmenuitem-exit2 =
    .label =
        { PLATFORM() ->
            [linux] Thoát
           *[other] Thoát
        }
appmenu-menu-button-closed2 =
    .tooltiptext = Mở menu ứng dụng
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = Đóng menu ứng dụng
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = Cài đặt

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = Phóng to
appmenuitem-zoom-reduce =
    .label = Thu nhỏ
appmenuitem-fullscreen =
    .label = Toàn màn hình

## Firefox Account toolbar button and Sync panel in App menu.

fxa-toolbar-sync-now =
    .label = Đồng bộ ngay
appmenu-remote-tabs-sign-into-sync =
    .label = Đăng nhập để đồng bộ hóa…
appmenu-remote-tabs-turn-on-sync =
    .label = Bật đồng bộ hóa…
appmenuitem-fxa-toolbar-sync-now2 = Đồng bộ ngay
appmenuitem-fxa-manage-account = Quản lý tài khoản
appmenu-fxa-header2 = { -fxaccount-brand-name }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = Đồng bộ hóa lần cuối { $time }
    .label = Đồng bộ hóa lần cuối { $time }
appmenu-fxa-sync-and-save-data2 = Đồng bộ hóa và lưu dữ liệu
appmenu-fxa-signed-in-label = Đăng nhập
appmenu-fxa-setup-sync =
    .label = Bật đồng bộ hóa…
appmenu-fxa-show-more-tabs = Hiển thị thêm các thẻ
appmenuitem-save-page =
    .label = Lưu trang dưới dạng…

## What's New panel in App menu.

whatsnew-panel-header = Có gì mới
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = Thông báo về các tính năng mới
    .accesskey = f

## The Firefox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = Hiện thêm thông tin
profiler-popup-description-title =
    .value = Ghi lại, phân tích, chia sẻ
profiler-popup-description = Cộng tác về các vấn đề hiệu suất bằng cách xuất bản hồ sơ để chia sẻ với nhóm của bạn.
profiler-popup-learn-more = Tìm hiểu thêm
profiler-popup-settings =
    .value = Cài đặt
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings = Chỉnh sửa cài đặt…
profiler-popup-disabled =
    Profiler hiện bị vô hiệu hóa, rất có thể do cửa sổ Duyệt web riêng tư
    đang mở.
profiler-popup-recording-screen = Đang ghi…
# The profiler presets list is generated elsewhere, but the custom preset is defined
# here only.
profiler-popup-presets-custom =
    .label = Tùy chỉnh
profiler-popup-start-recording-button =
    .label = Bắt đầu ghi
profiler-popup-discard-button =
    .label = Loại bỏ
profiler-popup-capture-button =
    .label = Ghi
profiler-popup-start-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧1
       *[other] Ctrl+Shift+1
    }
profiler-popup-capture-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧2
       *[other] Ctrl+Shift+2
    }

## History panel

appmenu-manage-history =
    .label = Quản lý lịch sử
appmenu-reopen-all-tabs = Mở lại tất cả các thẻ
appmenu-reopen-all-windows = Mở lại tất cả các cửa sổ
appmenu-restore-session =
    .label = Khôi phục phiên làm việc trước
appmenu-clear-history =
    .label = Xóa lịch sử gần đây…
appmenu-recent-history-subheader = Lịch sử gần đây
appmenu-recently-closed-tabs =
    .label = Thẻ mới đóng gần đây
appmenu-recently-closed-windows =
    .label = Các cửa sổ mới đóng

## Help panel

appmenu-help-header =
    .title = Trợ giúp { -brand-shorter-name }
appmenu-about =
    .label = Về { -brand-shorter-name }
    .accesskey = A
appmenu-get-help =
    .label = Nhận trợ giúp
    .accesskey = H
appmenu-help-more-troubleshooting-info =
    .label = Thông tin xử lý sự cố khác
    .accesskey = T
appmenu-help-report-site-issue =
    .label = Báo cáo vấn đề về trang…
appmenu-help-feedback-page =
    .label = Gửi phản hồi…
    .accesskey = S

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = Chế độ xử lý sự cố…
    .accesskey = M
appmenu-help-exit-troubleshoot-mode =
    .label = Tắt chế độ xử lý sự cố
    .accesskey = M

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = Báo cáo trang lừa đảo…
    .accesskey = c
appmenu-help-not-deceptive =
    .label = Đây không phải là một trang lừa đảo…
    .accesskey = d

## More Tools

appmenu-customizetoolbar =
    .label = Tùy biến thanh công cụ…
appmenu-taskmanager =
    .label = Quản lý tác vụ
appmenu-developer-tools-subheader = Công cụ của trình duyệt
appmenu-developer-tools-extensions =
    .label = Tiện ích mở rộng dành cho nhà phát triển
