# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-banner-update-downloading =
    .label = Đang tải xuống bản cập nhật { -brand-shorter-name }
appmenuitem-banner-update-available =
    .label = Đã có bản cập nhật — tải xuống ngay
appmenuitem-banner-update-manual =
    .label = Đã có bản cập nhật — tải xuống ngay
appmenuitem-banner-update-unsupported =
    .label = Không thể cập nhật — hệ thống không tương thích
appmenuitem-banner-update-restart =
    .label = Đã có bản cập nhật — khởi động lại ngay
appmenuitem-new-tab =
    .label = Thẻ mới
appmenuitem-new-window =
    .label = Cửa sổ mới
appmenuitem-new-private-window =
    .label = Cửa sổ riêng tư mới
appmenuitem-history =
    .label = Lịch sử
appmenuitem-downloads =
    .label = Tải xuống
appmenuitem-passwords =
    .label = Mật khẩu
appmenuitem-addons-and-themes =
    .label = Tiện ích mở rộng và chủ đề
appmenuitem-print =
    .label = In…
appmenuitem-find-in-page =
    .label = Tìm trong trang…
appmenuitem-zoom =
    .value = Thu phóng
appmenuitem-more-tools =
    .label = Thêm công cụ
appmenuitem-help =
    .label = Trợ giúp
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

## Waterfox Account toolbar button and Sync panel in App menu.

appmenu-remote-tabs-sign-into-sync =
    .label = Đăng nhập để đồng bộ hóa…
appmenu-remote-tabs-turn-on-sync =
    .label = Bật đồng bộ hóa…
# This is shown after the tabs list if we can display more tabs by clicking on the button
appmenu-remote-tabs-showmore =
    .label = Hiển thị thêm các thẻ
    .tooltiptext = Hiển thị các thẻ từ thiết bị này
# This is shown beneath the name of a device when that device has no open tabs
appmenu-remote-tabs-notabs = Không có thẻ đang mở
# This is shown when Sync is configured but syncing tabs is disabled.
appmenu-remote-tabs-tabsnotsyncing = Bật đồng bộ thẻ để xem danh sách thẻ từ các thiết bị khác của bạn.
appmenu-remote-tabs-opensettings =
    .label = Cài đặt
# This is shown when Sync is configured but this appears to be the only device attached to
# the account. We also show links to download Waterfox for android/ios.
appmenu-remote-tabs-noclients = Muốn xem thẻ từ các thiết bị khác của bạn ở đây?
appmenu-remote-tabs-connectdevice =
    .label = Kết nối thiết bị khác
appmenu-remote-tabs-welcome = Xem danh sách các thẻ từ các thiết bị khác của bạn.
appmenu-remote-tabs-unverified = Tài khoản của bạn cần phải xác thực.
appmenuitem-fxa-toolbar-sync-now2 = Đồng bộ ngay
appmenuitem-fxa-sign-in = Đăng nhập vào { -brand-product-name }
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
appmenuitem-save-page =
    .label = Lưu trang dưới dạng…

## What's New panel in App menu.

whatsnew-panel-header = Có gì mới
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = Thông báo về các tính năng mới
    .accesskey = f

## The Waterfox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-button-idle =
    .label = Profiler
    .tooltiptext = Ghi lại hồ sơ hiệu suất
profiler-popup-button-recording =
    .label = Profiler
    .tooltiptext = Profiler đang ghi lại một hồ sơ
profiler-popup-button-capturing =
    .label = Profiler
    .tooltiptext = Profiler đang ghi một hồ sơ
profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = Hiển thị thêm thông tin
profiler-popup-description-title =
    .value = Ghi lại, phân tích, chia sẻ
profiler-popup-description = Cộng tác về các vấn đề hiệu suất bằng cách xuất bản hồ sơ để chia sẻ với nhóm của bạn.
profiler-popup-learn-more-button =
    .label = Tìm hiểu thêm
profiler-popup-settings =
    .value = Cài đặt
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings-button =
    .label = Chỉnh sửa cài đặt…
profiler-popup-recording-screen = Đang ghi…
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

## Profiler presets
## They are shown in the popup's select box.


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# Please take care that the same values are also defined in devtools' perftools.ftl.

profiler-popup-presets-web-developer-description = Cài đặt trước được đề xuất cho hầu hết gỡ lỗi ứng dụng web, với chi phí thấp.
profiler-popup-presets-web-developer-label =
    .label = Nhà phát triển Web
profiler-popup-presets-firefox-description = Giá trị đặt trước được đề xuất để kiểm tra hiệu suất { -brand-shorter-name }.
profiler-popup-presets-firefox-label =
    .label = { -brand-shorter-name }
profiler-popup-presets-graphics-description = Giá trị đặt trước để điều tra lỗi đồ họa trong { -brand-shorter-name }.
profiler-popup-presets-graphics-label =
    .label = Đồ họa
profiler-popup-presets-media-description2 = Giá trị đặt trước để điều tra lỗi âm thanh và video trong { -brand-shorter-name }.
profiler-popup-presets-media-label =
    .label = Media
profiler-popup-presets-networking-description = Giá trị đặt trước để điều tra lỗi mạng trong { -brand-shorter-name }.
profiler-popup-presets-networking-label =
    .label = Kết nối mạng
profiler-popup-presets-power-description = Giá trị đặt trước để điều tra lỗi sử dụng điện trong { -brand-shorter-name }, với chi phí thấp.
# "Power" is used in the sense of energy (electricity used by the computer).
profiler-popup-presets-power-label =
    .label = Nguồn điện
profiler-popup-presets-custom-label =
    .label = Tùy chỉnh

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
appmenu-help-share-ideas =
    .label = Chia sẻ ý tưởng và phản hồi…
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
appmenu-developer-tools-subheader = Công cụ của trình duyệt
appmenu-developer-tools-extensions =
    .label = Tiện ích mở rộng dành cho nhà phát triển
