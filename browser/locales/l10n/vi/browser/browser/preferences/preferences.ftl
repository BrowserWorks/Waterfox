# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Gửi tín hiệu “Không theo dõi” tới trang web để cho biết bạn không muốn bị theo dõi
do-not-track-learn-more = Tìm hiểu thêm
do-not-track-option-default-content-blocking-known =
    .label = Chỉ khi { -brand-short-name } được đặt để chặn trình theo dõi đã biết
do-not-track-option-always =
    .label = Luôn luôn
pref-page-title =
    { PLATFORM() ->
        [windows] Tùy chọn
       *[other] Tùy chỉnh
    }
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] Tìm trong phần tùy chọn
           *[other] Tìm trong phần tùy chỉnh
        }
settings-page-title = Cài đặt
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box2 =
    .style = width: 15.4em
    .placeholder = Tìm kiếm trong Cài đặt
managed-notice = Trình duyệt của bạn đang được quản lý bởi tổ chức của bạn.
category-list =
    .aria-label = Thể loại
pane-general-title = Tổng quát
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Trang chủ
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Tìm kiếm
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Riêng tư & bảo mật
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-sync-title3 = Đồng bộ hóa
category-sync3 =
    .tooltiptext = { pane-sync-title3 }
pane-experimental-title = Thử nghiệm { -brand-short-name }
category-experimental =
    .tooltiptext = Thử nghiệm { -brand-short-name }
pane-experimental-subtitle = Tiến hành thận trọng
pane-experimental-search-results-header = Thử nghiệm { -brand-short-name }: Tiến hành thận trọng
pane-experimental-description2 = Thay đổi cài đặt cấu hình nâng cao có thể ảnh hưởng đến hiệu suất hoặc bảo mật của { -brand-short-name }.
pane-experimental-reset =
    .label = Khôi phục về mặc định
    .accesskey = R
help-button-label = Hỗ trợ { -brand-short-name }
addons-button-label = Tiện ích mở rộng & chủ đề
focus-search =
    .key = f
close-button =
    .aria-label = Đóng

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } phải khởi động lại để kích hoạt tính năng này.
feature-disable-requires-restart = { -brand-short-name } phải khởi động lại để vô hiệu hóa tính năng này.
should-restart-title = Khởi động lại { -brand-short-name }
should-restart-ok = Khởi động lại { -brand-short-name } ngay
cancel-no-restart-button = Hủy bỏ
restart-later = Khởi động lại sau

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that their home page
# is being controlled by an extension.
extension-controlled-homepage-override = Một tiện ích mở rông, <img data-l10n-name="icon"/> { $name }, đang kiểm soát trang chủ của bạn.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = Một tiện ích mở rông, <img data-l10n-name="icon"/> { $name }, đang kiểm soát phần thẻ mới của bạn.
# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = Một tiện ích mở rộng, <img data-l10n-name="icon"/> { $name }, đang kiểm soát cài đặt này.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Một tiện ích mở rộng, <img data-l10n-name="icon"/> { $name }, đang kiểm soát cài đặt này.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = Một tiện ích mở rộng, <img data-l10n-name="icon"/> { $name }, đã cài đặt công cụ tìm kiếm mặc định của bạn.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Một tiện ích mở rộng, <img data-l10n-name="icon"/> { $name }, yêu cầu ngăn chứa thẻ.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Một tiện ích mở rộng, <img data-l10n-name="icon"/> { $name }, đang kiểm soát cài đặt này.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Một tiện ích mở rộng, <img data-l10n-name="icon"/> { $name }, đang kiểm soát cách { -brand-short-name } kết nối internet.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Để kích hoạt tiện ích mở rộng hãy vào phần tiện ích <img data-l10n-name="addons-icon"/> trên bảng chọn <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Kết quả tìm kiếm
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Xin lỗi! Không có kết quả trong phần Tùy chọn cho “<span data-l10n-name="query"></span>”.
       *[other] Xin lỗi! Không có kết quả trong phần Tùy chỉnh cho “<span data-l10n-name="query"></span>”.
    }
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 = Xin lỗi! Không có kết quả nào trong Cài đặt cho “<span data-l10n-name="query">”.
search-results-help-link = Cần trợ giúp? Đi đến <a data-l10n-name="url">Hỗ trợ { -brand-short-name }</a>

## General Section

startup-header = Khởi động
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Cho phép { -brand-short-name } và Firefox cùng chạy song song
use-firefox-sync = Mẹo nhỏ: Việc này sử dụng các hồ sơ độc lập nhau. Bạn có thể dùng { -sync-brand-short-name } để đồng bộ giữa chúng.
get-started-not-logged-in = Đăng nhập vào { -sync-brand-short-name }…
get-started-configured = Mở tùy chỉnh của { -sync-brand-short-name }
always-check-default =
    .label = Luôn kiểm tra xem { -brand-short-name } có phải trình duyệt mặc định không
    .accesskey = y
is-default = { -brand-short-name } đang là trình duyệt mặc định
is-not-default = { -brand-short-name } không phải là trình duyệt mặc định
set-as-my-default-browser =
    .label = Đặt làm mặc định…
    .accesskey = D
startup-restore-previous-session =
    .label = Khôi phục phiên làm việc trước
    .accesskey = s
startup-restore-warn-on-quit =
    .label = Cảnh báo bạn khi thoát khỏi trình duyệt
disable-extension =
    .label = Vô hiệu hóa tiện ích mở rộng
tabs-group-header = Thẻ
ctrl-tab-recently-used-order =
    .label = Ctrl+Tab để chuyển qua các thẻ theo thứ tự sử dụng gần đây nhất
    .accesskey = T
open-new-link-as-tabs =
    .label = Mở đường dẫn ở thẻ thay vì ở cửa sổ mới
    .accesskey = w
warn-on-close-multiple-tabs =
    .label = Cảnh báo bạn khi đóng nhiều thẻ một lúc
    .accesskey = m
warn-on-open-many-tabs =
    .label = Cảnh báo bạn khi mở nhiều thẻ có thể làm chậm { -brand-short-name }
    .accesskey = d
switch-links-to-new-tabs =
    .label = Khi bạn mở một liên kết trong thẻ mới, chuyển sang thẻ đó ngay lập tức
    .accesskey = h
switch-to-new-tabs =
    .label = Khi bạn mở một liên kết, hình ảnh hoặc phương tiện trong một thẻ mới, chuyển sang nó ngay lập tức
    .accesskey = h
show-tabs-in-taskbar =
    .label = Hiển thị hình ảnh xem trước thẻ trong thanh tác vụ Windows
    .accesskey = k
browser-containers-enabled =
    .label = Kích hoạt ngăn chứa thẻ
    .accesskey = n
browser-containers-learn-more = Tìm hiểu thêm
browser-containers-settings =
    .label = Cài đặt…
    .accesskey = i
containers-disable-alert-title = Đóng tất cả các ngăn chứa thẻ?
containers-disable-alert-desc = Nếu bạn vô hiệu hóa ngăn chứa thẻ bây giờ, { $tabCount } thẻ trong ngăn chứa sẽ bị đóng. Bạn có chắc muốn vô hiệu hóa ngăn chứa thẻ?
containers-disable-alert-ok-button = Đóng { $tabCount } thẻ trong ngăn chứa
containers-disable-alert-cancel-button = Tiếp tục bật
containers-remove-alert-title = Xóa ngăn chứa này?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg = Nếu bạn xóa ngăn chứa này bây giờ, { $count } thẻ trong ngăn chứa sẽ bị đóng. Bạn có chắc muốn xóa ngăn chứa này?
containers-remove-ok-button = Xóa ngăn chứa này
containers-remove-cancel-button = Không xóa ngăn chứa này

## General Section - Language & Appearance

language-and-appearance-header = Ngôn ngữ và chủ đề
fonts-and-colors-header = Phông & Màu sắc
default-font = Phông mặc định
    .accesskey = D
default-font-size = Kích thước
    .accesskey = S
advanced-fonts =
    .label = Nâng cao…
    .accesskey = o
colors-settings =
    .label = Màu sắc…
    .accesskey = M
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Thu phóng
preferences-default-zoom = Thu phóng mặc định
    .accesskey = z
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = Chỉ thu phóng văn bản
    .accesskey = t
language-header = Ngôn ngữ
choose-language-description = Chọn ngôn ngữ ưu tiên bạn muốn để hiển thị trang
choose-button =
    .label = Chọn…
    .accesskey = C
choose-browser-language-description = Chọn ngôn ngữ được sử dụng để hiển thị bảng chọn, tin nhắn và thông báo từ { -brand-short-name }.
manage-browser-languages-button =
    .label = Đặt giải pháp thay thế…
    .accesskey = I
confirm-browser-language-change-description = Khởi động lại { -brand-short-name } để áp dụng các thay đổi này
confirm-browser-language-change-button = Áp dụng và Khởi động lại
translate-web-pages =
    .label = Dịch nội dung web
    .accesskey = D
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Dịch bởi <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Ngoại lệ...
    .accesskey = N
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Sử dụng các cài đặt hệ điều hành của bạn cho nhóm “{ $localeName }” để định dạng ngày, giờ, số và số đo.
check-user-spelling =
    .label = Kiểm tra chính tả khi bạn gõ
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = Tập tin và ứng dụng
download-header = Tải xuống
download-save-to =
    .label = Lưu các tập tin vào
    .accesskey = v
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Chọn…
           *[other] Duyệt…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] n
           *[other] y
        }
download-always-ask-where =
    .label = Luôn hỏi bạn nơi để lưu các tập tin
    .accesskey = A
applications-header = Ứng dụng
applications-description = Chọn cách { -brand-short-name } xử lý các tập tin bạn tải xuống từ web hoặc các ứng dụng bạn sử dụng khi duyệt web.
applications-filter =
    .placeholder = Tìm các loại tập tin hoặc ứng dụng
applications-type-column =
    .label = Kiểu dữ liệu
    .accesskey = K
applications-action-column =
    .label = Thao tác
    .accesskey = a
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = Tập tin { $extension }
applications-action-save =
    .label = Lưu tập tin
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Dùng { $app-name }
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Dùng { $app-name } (mặc định)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Sử dụng ứng dụng mặc định macOS
            [windows] Sử dụng ứng dụng mặc định Windows
           *[other] Sử dụng ứng dụng mặc định hệ thống
        }
applications-use-other =
    .label = Dùng chương trình khác…
applications-select-helper = Chọn ứng dụng trợ giúp
applications-manage-app =
    .label = Chi tiết ứng dụng…
applications-always-ask =
    .label = Luôn hỏi
applications-type-pdf = Định dạng tài liệu di động (PDF)
# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })
# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })
# Variables:
#   $extension (String) - file extension (e.g .TXT)
#   $type (String) - the MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })
# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = Dùng { $plugin-name } (trong { -brand-short-name })
applications-open-inapp =
    .label = Mở bằng { -brand-short-name }

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }
applications-action-save-label =
    .value = { applications-action-save.label }
applications-use-app-label =
    .value = { applications-use-app.label }
applications-open-inapp-label =
    .value = { applications-open-inapp.label }
applications-always-ask-label =
    .value = { applications-always-ask.label }
applications-use-app-default-label =
    .value = { applications-use-app-default.label }
applications-use-other-label =
    .value = { applications-use-other.label }
applications-use-os-default-label =
    .value = { applications-use-os-default.label }

##

drm-content-header = Nội dung quản lý bản quyền kỹ thuật số (DRM)
play-drm-content =
    .label = Phát nội dung DRM được kiểm soát
    .accesskey = P
play-drm-content-learn-more = Tìm hiểu thêm
update-application-title = Cập nhật { -brand-short-name }
update-application-description = Giữ { -brand-short-name } luôn cập nhật để đạt được hiệu năng, sự ổn định, và bảo mật tốt nhất.
update-application-version = Phiên bản { $version } <a data-l10n-name="learn-more">Có gì mới</a>
update-history =
    .label = Hiển thị lịch sử cập nhật…
    .accesskey = p
update-application-allow-description = Cho phép { -brand-short-name }
update-application-auto =
    .label = Tự động cài đặt các bản cập nhật (khuyến nghị)
    .accesskey = A
update-application-check-choose =
    .label = Kiểm tra các bản cập nhật nhưng bạn sẽ lựa chọn việc cài đặt chúng
    .accesskey = C
update-application-manual =
    .label = Không bao giờ kiểm tra các bản cập nhật (không khuyến nghị)
    .accesskey = N
update-application-background-enabled =
    .label = Khi { -brand-short-name } không chạy
    .accesskey = W
update-application-warning-cross-user-setting = Cài đặt này sẽ áp dụng cho tất cả các tài khoản Windows và hồ sơ { -brand-short-name } bằng cách sử dụng cài đặt { -brand-short-name } này.
update-application-use-service =
    .label = Sử dụng dịch vụ chạy nền để cài đặt các cập nhật
    .accesskey = n
update-setting-write-failure-title = Lỗi khi lưu tùy chọn cập nhật
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } đã gặp lỗi và đã không lưu thay đổi này. Lưu ý rằng thiết lập tùy chọn cập nhật này yêu cầu quyền ghi vào tập tin bên dưới. Bạn hoặc quản trị viên hệ thống có thể giải quyết lỗi bằng cách cấp cho nhóm Người dùng toàn quyền kiểm soát tệp này.
    
    Không thể ghi vào tệp: { $path }
update-setting-write-failure-title2 = Lỗi khi lưu cài đặt Cập nhật
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message2 =
    { -brand-short-name } đã gặp lỗi và đã không lưu thay đổi này. Lưu ý rằng cài đặt tùy chỉnh cập nhật này yêu cầu quyền ghi vào tập tin bên dưới. Bạn hoặc quản trị viên hệ thống có thể giải quyết lỗi bằng cách cấp cho nhóm Người dùng toàn quyền kiểm soát tập tin này.
    
    Không thể ghi vào tập tin: { $path }
update-in-progress-title = Đang cập nhật
update-in-progress-message = Bạn có muốn { -brand-short-name } tiếp tục với bản cập nhật này không?
update-in-progress-ok-button = &Hủy bỏ
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Tiếp tục

## General Section - Performance

performance-title = Hiệu suất
performance-use-recommended-settings-checkbox =
    .label = Sử dụng các cài đặt về hiệu suất được khuyến nghị
    .accesskey = U
performance-use-recommended-settings-desc = Các cài đặt này được thiết kế riêng cho phần cứng máy tính và hệ điều hành của bạn.
performance-settings-learn-more = Tìm hiểu thêm
performance-allow-hw-accel =
    .label = Sử dụng chế độ tăng tốc phần cứng khi khả dụng
    .accesskey = h
performance-limit-content-process-option = Giới hạn xử lý nội dung
    .accesskey = L
performance-limit-content-process-enabled-desc = Các tiến trình xử lý nội dung bổ sung có thể cải thiện hiệu suất khi sử dụng nhiều thẻ một lúc, nhưng cũng sẽ tiêu tốn nhiều bộ nhớ.
performance-limit-content-process-blocked-desc = Việc chỉnh sửa số tiến trình xử lý nội dung chỉ có thể thực hiện với { -brand-short-name } đa tiến trình. <a data-l10n-name="learn-more">Tìm hiểu làm cách nào để kiểm tra khi chế độ đa tiến trình được bật</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (mặc định)

## General Section - Browsing

browsing-title = Duyệt
browsing-use-autoscroll =
    .label = Tự động cuộn
    .accesskey = u
browsing-use-smooth-scrolling =
    .label = Cuộn uyển chuyển
    .accesskey = y
browsing-use-onscreen-keyboard =
    .label = Hiện bàn phím cảm ứng khi cần thiết
    .accesskey = b
browsing-use-cursor-navigation =
    .label = Cho phép dùng con trỏ để di chuyển bên trong trang
    .accesskey = c
browsing-search-on-start-typing =
    .label = Tìm kiếm văn bản khi bạn bắt đầu nhập
    .accesskey = x
browsing-picture-in-picture-toggle-enabled =
    .label = Bật điều khiển video hình trong hình
    .accesskey = E
browsing-picture-in-picture-learn-more = Tìm hiểu thêm
browsing-media-control =
    .label = Điều khiển phương tiện qua bàn phím, tai nghe hoặc giao diện ảo
    .accesskey = v
browsing-media-control-learn-more = Tìm hiểu thêm
browsing-cfr-recommendations =
    .label = Đề xuất tiện ích mở rộng khi duyệt
    .accesskey = R
browsing-cfr-features =
    .label = Đề xuất các tính năng khi bạn duyệt
    .accesskey = f
browsing-cfr-recommendations-learn-more = Tìm hiểu thêm

## General Section - Proxy

network-settings-title = Cài đặt mạng
network-proxy-connection-description = Cấu hình phương thức { -brand-short-name } kết nối internet.
network-proxy-connection-learn-more = Tìm hiểu thêm
network-proxy-connection-settings =
    .label = Cài đặt…
    .accesskey = e

## Home Section

home-new-windows-tabs-header = Cửa sổ và thẻ mới
home-new-windows-tabs-description2 = Chọn những gì bạn thấy khi bạn mở trang chủ, cửa sổ mới và các thẻ mới.

## Home Section - Home Page Customization

home-homepage-mode-label = Trang chủ và cửa sổ mới
home-newtabs-mode-label = Thẻ mới
home-restore-defaults =
    .label = Khôi phục về mặc định
    .accesskey = R
# "Waterfox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Trang chủ Firefox (Mặc định)
home-mode-choice-custom =
    .label = Tùy chỉnh URL...
home-mode-choice-blank =
    .label = Trang trắng
home-homepage-custom-url =
    .placeholder = Dán một URL...
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Dùng các trang hiện tại
           *[other] Dùng các trang hiện tại
        }
    .accesskey = C
choose-bookmark =
    .label = Sử dụng dấu trang…
    .accesskey = B

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Nội dung trang chủ của Firefox
home-prefs-content-description = Chọn nội dung mà bạn muốn thêm vào trang chủ của Firefox.
home-prefs-search-header =
    .label = Tìm kiếm web
home-prefs-topsites-header =
    .label = Các trang Web hàng đầu
home-prefs-topsites-description = Những trang bạn truy cập nhiều nhất
home-prefs-topsites-by-option-sponsored =
    .label = Các trang hàng đầu được tài trợ
home-prefs-shortcuts-header =
    .label = Lối tắt
home-prefs-shortcuts-description = Các trang web bạn lưu hoặc truy cập
home-prefs-shortcuts-by-option-sponsored =
    .label = Các lối tắt được tài trợ

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Được đề xuất bởi { $provider }
home-prefs-recommended-by-description-update = Nội dung đặc biệt trên web, được quản lý bởi { $provider }
home-prefs-recommended-by-description-new = Nội dung đặc biệt do { $provider }, một phần của { -brand-product-name }, quản lý

##

home-prefs-recommended-by-learn-more = Nó hoạt động như thế nào
home-prefs-recommended-by-option-sponsored-stories =
    .label = Bài viết quảng cáo
home-prefs-highlights-header =
    .label = Nổi bật
home-prefs-highlights-description = Một lựa chọn các trang web mà bạn đã lưu hoặc truy cập
home-prefs-highlights-option-visited-pages =
    .label = Trang đã truy cập
home-prefs-highlights-options-bookmarks =
    .label = Dấu trang
home-prefs-highlights-option-most-recent-download =
    .label = Tải xuống gần đây nhất
home-prefs-highlights-option-saved-to-pocket =
    .label = Trang đã được lưu vào { -pocket-brand-name }
home-prefs-recent-activity-header =
    .label = Hoạt động gần đây
home-prefs-recent-activity-description = Tuyển chọn các trang và nội dung gần đây
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Ghi chú nhỏ
home-prefs-snippets-description = Cập nhật từ { -vendor-short-name } và { -brand-product-name }
home-prefs-snippets-description-new = Mẹo và tin tức từ { -vendor-short-name } và { -brand-product-name }
home-prefs-sections-rows-option =
    .label = { $num } hàng

## Search Section

search-bar-header = Thanh tìm kiếm
search-bar-hidden =
    .label = Dùng thanh địa chỉ để tìm kiếm và điều hướng
search-bar-shown =
    .label = Thêm thanh tìm kiếm vào thanh công cụ
search-engine-default-header = Dịch vụ tìm kiếm mặc định
search-engine-default-desc-2 = Đây là công cụ tìm kiếm mặc định của bạn trong thanh địa chỉ và thanh tìm kiếm. Bạn có thể chuyển đổi bất cứ lúc nào.
search-engine-default-private-desc-2 = Chọn một công cụ tìm kiếm mặc định khác chỉ dành cho cửa sổ riêng tư
search-separate-default-engine =
    .label = Sử dụng công cụ tìm kiếm này trong cửa sổ riêng tư
    .accesskey = U
search-suggestions-header = Đề xuất tìm kiếm
search-suggestions-desc = Chọn cách đề xuất từ các công cụ tìm kiếm xuất hiện.
search-suggestions-option =
    .label = Tự động đề nghị từ khóa tìm kiếm
    .accesskey = n
search-show-suggestions-url-bar-option =
    .label = Hiển thị gợi ý tìm kiếm trong kết quả thanh địa chỉ
    .accesskey = l
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Hiện những gợi ý tìm kiếm phía trước lịch sử duyệt web trong kết quả thanh địa chỉ
search-show-suggestions-private-windows =
    .label = Hiển thị đề xuất tìm kiếm trong cửa sổ riêng tư
suggestions-addressbar-settings-generic = Thay đổi tùy chọn cho các đề xuất trên thanh địa chỉ khác
suggestions-addressbar-settings-generic2 = Thay đổi cài đặt cho các đề xuất khác trên thanh địa chỉ
search-suggestions-cant-show = Gợi ý tìm kiếm sẽ không được hiện ở thanh địa chỉ vì bạn đã thiết lập { -brand-short-name } không bao giờ ghi nhớ lịch sử.
search-one-click-header = Công cụ tìm kiếm với một lần nhấn
search-one-click-header2 = Lối tắt tìm kiếm
search-one-click-desc = Chọn các công cụ tìm kiếm thay thế xuất hiện bên dưới thanh địa chỉ và thanh tìm kiếm khi bạn bắt đầu nhập một từ khoá.
search-choose-engine-column =
    .label = Công cụ tìm kiếm
search-choose-keyword-column =
    .label = Từ khóa
search-restore-default =
    .label = Đặt lại công cụ tìm kiếm mặc định
    .accesskey = D
search-remove-engine =
    .label = Xóa
    .accesskey = X
search-add-engine =
    .label = Thêm
    .accesskey = A
search-find-more-link = Tìm các công cụ tìm kiếm khác
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Nhân bản Từ khóa
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Bạn đã chọn một từ khóa hiện đang được dùng bởi "{ $name }". Vui lòng chọn từ khác.
search-keyword-warning-bookmark = Bạn đã chọn một từ khóa hiện đang được dùng bởi một dấu trang. Vui lòng chọn từ khác.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] Quay lại Tùy chọn
           *[other] Quay lại Tùy chỉnh
        }
containers-back-button2 =
    .aria-label = Quay lại Cài đặt
containers-header = Ngăn chứa thẻ
containers-add-button =
    .label = Thêm ngăn chứa mới
    .accesskey = T
containers-new-tab-check =
    .label = Chọn một ngăn chứa cho mỗi thẻ mới
    .accesskey = S
containers-preferences-button =
    .label = Tùy chỉnh
containers-settings-button =
    .label = Cài đặt
containers-remove-button =
    .label = Loại bỏ

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Mang trang web theo bạn
sync-signedout-description = Đồng bộ dấu trang, lịch sử, thẻ, mật khẩu, tiện ích và tùy chỉnh tới tất cả các thiết bị của bạn.
sync-signedout-account-signin2 =
    .label = Đăng nhập vào { -sync-brand-short-name }…
    .accesskey = i
sync-signedout-description2 = Đồng bộ trang đánh dấu, lịch sử, thẻ, mật khẩu, tiện ích và cài đặt tới tất cả các thiết bị của bạn.
sync-signedout-account-signin3 =
    .label = Đăng nhập để đồng bộ hóa…
    .accesskey = i
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Tải Firefox cho <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> hoặc <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> để đồng bị với thiết bị di động của bạn.

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Đổi hình hồ sơ
sync-sign-out =
    .label = Đăng xuất…
    .accesskey = g
sync-manage-account = Quản lý tài khoản
    .accesskey = k
sync-signedin-unverified = { $email } chưa được kiểm tra.
sync-signedin-login-failure = Xin hãy đăng nhập để kết nối lại { $email }
sync-resend-verification =
    .label = Gửi lại xác nhận
    .accesskey = d
sync-remove-account =
    .label = Xóa tài khoản
    .accesskey = R
sync-sign-in =
    .label = Đăng nhập
    .accesskey = g

## Sync section - enabling or disabling sync.

prefs-syncing-on = Đồng bộ hóa: BẬT
prefs-syncing-off = Đồng bộ hóa: TẮT
prefs-sync-setup =
    .label = Thiết lập { -sync-brand-short-name }…
    .accesskey = S
prefs-sync-offer-setup-label = Đồng bộ dấu trang, lịch sử, thẻ, mật khẩu, tiện ích và tùy chỉnh tới tất cả các thiết bị của bạn.
prefs-sync-turn-on-syncing =
    .label = Bật đồng bộ hóa…
    .accesskey = s
prefs-sync-offer-setup-label2 = Đồng bộ trang đánh dấu, lịch sử, thẻ, mật khẩu, tiện ích và cài đặt tới tất cả các thiết bị của bạn.
prefs-sync-now =
    .labelnotsyncing = Đồng bộ hóa ngay
    .accesskeynotsyncing = N
    .labelsyncing = Đang đồng bộ hóa…

## The list of things currently syncing.

sync-currently-syncing-heading = Bạn hiện đang đồng bộ hóa các mục này:
sync-currently-syncing-bookmarks = Dấu trang
sync-currently-syncing-history = Lịch sử
sync-currently-syncing-tabs = Các thẻ đang mở
sync-currently-syncing-logins-passwords = Đăng nhập và mật khẩu
sync-currently-syncing-addresses = Địa chỉ
sync-currently-syncing-creditcards = Thẻ tín dụng
sync-currently-syncing-addons = Tiện ích
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] Tùy chọn
       *[other] Tùy chỉnh
    }
sync-currently-syncing-settings = Cài đặt
sync-change-options =
    .label = Thay đổi…
    .accesskey = C

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Chọn những gì để đồng bộ hóa
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Lưu thay đổi
    .buttonaccesskeyaccept = S
    .buttonlabelextra2 = Ngắt kết nối…
    .buttonaccesskeyextra2 = D
sync-engine-bookmarks =
    .label = Dấu trang
    .accesskey = m
sync-engine-history =
    .label = Lịch sử
    .accesskey = r
sync-engine-tabs =
    .label = Các thẻ đang mở
    .tooltiptext = Danh sách những trang web đang mở trên các thiết bị được đồng bộ
    .accesskey = t
sync-engine-logins-passwords =
    .label = Đăng nhập và mật khẩu
    .tooltiptext = Tên đăng nhập và mật khẩu bạn đã lưu
    .accesskey = L
sync-engine-addresses =
    .label = Địa chỉ
    .tooltiptext = Địa chỉ bưu chính bạn đã lưu (chỉ trên phiên bản máy tính)
    .accesskey = e
sync-engine-creditcards =
    .label = Thẻ tín dụng
    .tooltiptext = Tên, số và ngày hết hạn (chỉ trên phiên bản máy tính)
    .accesskey = C
sync-engine-addons =
    .label = Tiện ích
    .tooltiptext = Tiện ích mở rộng và chủ đề của Firefox dành cho máy tính
    .accesskey = A
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Tùy chọn
           *[other] Tùy chỉnh
        }
    .tooltiptext = Các cài đặt chung, cài đặt về sự riêng tư, và bảo mật mà bạn đã thay đổi
    .accesskey = s
sync-engine-settings =
    .label = Cài đặt
    .tooltiptext = Cài đặt tổng quát, riêng tư và bảo mật mà bạn đã thay đổi
    .accesskey = s

## The device name controls.

sync-device-name-header = Tên thiết bị
sync-device-name-change =
    .label = Thay đổi tên thiết bị…
    .accesskey = h
sync-device-name-cancel =
    .label = Hủy bỏ
    .accesskey = n
sync-device-name-save =
    .label = Lưu
    .accesskey = u
sync-connect-another-device = Kết nối thiết bị khác

## Privacy Section

privacy-header = Duyệt web riêng tư

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Đăng nhập & mật khẩu
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Hỏi để lưu lại thông tin đăng nhập và mật khẩu cho trang web
    .accesskey = r
forms-exceptions =
    .label = Ngoại trừ…
    .accesskey = x
forms-generate-passwords =
    .label = Đề xuất và tạo mật khẩu mạnh
    .accesskey = u
forms-breach-alerts =
    .label = Hiển thị cảnh báo về mật khẩu cho các trang web bị rò rỉ
    .accesskey = b
forms-breach-alerts-learn-more-link = Tìm hiểu thêm
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Tự động điền đăng nhập và mật khẩu
    .accesskey = i
forms-saved-logins =
    .label = Đăng nhập đã lưu…
    .accesskey = L
forms-master-pw-use =
    .label = Dùng mật khẩu chính
    .accesskey = U
forms-primary-pw-use =
    .label = Sử dụng mật khẩu chính
    .accesskey = U
forms-primary-pw-learn-more-link = Tìm hiểu thêm
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Thay đổi mật khẩu chính…
    .accesskey = M
forms-master-pw-fips-title = Bạn đang ở chế độ FIPS. FIPS yêu cầu mật khẩu chính không được để trống.
forms-primary-pw-change =
    .label = Thay đổi mật khẩu chính…
    .accesskey = P
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }
forms-primary-pw-fips-title = Bạn hiện đang ở chế độ FIPS. FIPS yêu cầu tính năng mật khẩu chính.
forms-master-pw-fips-desc = Thay đổi mật khẩu không thành công

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Để tạo mật khẩu chính, hãy nhập thông tin đăng nhập Windows của bạn. Điều này giúp bảo vệ tính bảo mật của tài khoản của bạn.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = tạo một mật khẩu chính
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Để tạo mật khẩu chính, hãy nhập thông tin đăng nhập Windows của bạn. Điều này giúp bảo vệ tính bảo mật của tài khoản của bạn.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = tạo một mật khẩu chính
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Lịch sử
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Waterfox", moving the verb into each option.
#     This will result in "Waterfox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name } sẽ
    .accesskey = w
history-remember-option-all =
    .label = Ghi nhớ lịch sử
history-remember-option-never =
    .label = Không bao giờ ghi nhớ lịch sử
history-remember-option-custom =
    .label = Sử dụng thiết lập tùy biến cho lịch sử
history-remember-description = { -brand-short-name } sẽ ghi nhớ lịch sử duyệt web, tải xuống, biểu mẫu và tìm kiếm của bạn.
history-dontremember-description = { -brand-short-name } sẽ dùng thiết lập giống như chế độ duyệt web riêng tư, và sẽ không ghi nhớ lịch sử khi bạn duyệt Web.
history-private-browsing-permanent =
    .label = Luôn dùng chế độ duyệt web riêng tư
    .accesskey = p
history-remember-browser-option =
    .label = Ghi nhớ lịch sử truy cập và tải xuống của tôi
    .accesskey = b
history-remember-search-option =
    .label = Ghi nhớ lịch sử biểu mẫu và tìm kiếm
    .accesskey = f
history-clear-on-close-option =
    .label = Xóa lịch sử khi { -brand-short-name } đóng
    .accesskey = r
history-clear-on-close-settings =
    .label = Cài đặt…
    .accesskey = t
history-clear-button =
    .label = Xóa lịch sử...
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = Cookie và dữ liệu trang
sitedata-total-size-calculating = Đang tính toán kích thước bộ nhớ đệm và dữ liệu trang…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Cookie, dữ liệu trang và bộ nhớ đệm của bạn hiện đang sử dụng { $value } { $unit } dung lượng đĩa.
sitedata-learn-more = Tìm hiểu thêm
sitedata-delete-on-close =
    .label = Xóa cookie và dữ liệu trang web khi đóng { -brand-short-name }
    .accesskey = c
sitedata-delete-on-close-private-browsing = Trong chế độ duyệt riêng tư, cookie và dữ liệu trang web sẽ luôn bị xóa khi { -brand-short-name } bị đóng.
sitedata-allow-cookies-option =
    .label = Cho phép cookie và dữ liệu trang
    .accesskey = A
sitedata-disallow-cookies-option =
    .label = Chặn cookie và dữ liệu trang
    .accesskey = B
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Loại bị chặn
    .accesskey = T
sitedata-option-block-cross-site-trackers =
    .label = Trình theo dõi trên nhiều trang web
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Trình theo dõi trên nhiều trang web và truyền thông xã hội
sitedata-option-block-cross-site-tracking-cookies-including-social-media =
    .label = Cookie theo dõi trên nhiều trang web — bao gồm cookie truyền thông xã hội
sitedata-option-block-cross-site-cookies-including-social-media =
    .label = Cookie trên nhiều trang web — bao gồm cookie trên mạng xã hội
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Trình theo dõi trên nhiều trang web và mạng xã hội, đồng thời cô lập các cookie còn lại
sitedata-option-block-unvisited =
    .label = Cookie từ các trang web không mong muốn
sitedata-option-block-all-third-party =
    .label = Tất cả cookie của bên thứ ba (có thể khiến các trang web bị hỏng)
sitedata-option-block-all =
    .label = Tất cả các cookie (có thể khiến các trang web bị hỏng)
sitedata-clear =
    .label = Xóa dữ liệu...
    .accesskey = l
sitedata-settings =
    .label = Quản lí dữ liệu...
    .accesskey = M
sitedata-cookies-permissions =
    .label = Quản lí các quyền...
    .accesskey = P
sitedata-cookies-exceptions =
    .label = Quản lý các ngoại lệ…
    .accesskey = x

## Privacy Section - Address Bar

addressbar-header = Thanh địa chỉ
addressbar-suggest = Khi dùng thanh địa chỉ, gợi ý
addressbar-locbar-history-option =
    .label = Lịch sử duyệt web
    .accesskey = h
addressbar-locbar-bookmarks-option =
    .label = Dấu trang
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = Các thẻ đang mở
    .accesskey = O
# Shortcuts refers to the shortcut tiles on the new tab page, previously known as top sites. Translation should be consistent.
addressbar-locbar-shortcuts-option =
    .label = Lối tắt
    .accesskey = S
addressbar-locbar-topsites-option =
    .label = Trang web hàng đầu
    .accesskey = T
addressbar-locbar-engines-option =
    .label = Công cụ tìm kiếm
    .accesskey = t
addressbar-suggestions-settings = Thay đổi tùy chỉnh phần gợi ý của công cụ tìm kiếm

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Trình chống theo dõi nâng cao
content-blocking-section-top-level-description = Trình theo dõi theo bạn trên mạng để thu thập thông tin về thói quen và sở thích duyệt web của bạn. { -brand-short-name } chặn nhiều trình theo dõi và các tập lệnh độc hại khác.
content-blocking-learn-more = Tìm hiểu thêm
content-blocking-fpi-incompatibility-warning = Bạn đang sử dụng First Party Isolation (FPI), tính năng này sẽ ghi đè một số cài đặt cookie của { -brand-short-name }.

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Tiêu chuẩn
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = Nghiêm ngặt
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = Tùy chỉnh
    .accesskey = C

##

content-blocking-etp-standard-desc = Cân bằng để bảo vệ và hiệu suất. Các trang sẽ tải bình thường.
content-blocking-etp-strict-desc = Bảo vệ mạnh mẽ hơn, nhưng có thể khiến một số trang web và nội dung bị phá vỡ.
content-blocking-etp-custom-desc = Chọn trình theo dõi và tập lệnh để chặn.
content-blocking-etp-blocking-desc = { -brand-short-name } chặn những điều sau:
content-blocking-private-windows = Trình theo dõi nội dung trong cửa sổ riêng tư
content-blocking-cross-site-cookies-in-all-windows = Cookie trên nhiều trang web trong tất cả các cửa sổ (bao gồm cookie theo dõi)
content-blocking-cross-site-tracking-cookies = Cookie theo dõi trên nhiều trang web
content-blocking-all-cross-site-cookies-private-windows = Cookie trên nhiều trang web trong cửa sổ riêng tư
content-blocking-cross-site-tracking-cookies-plus-isolate = Cookie theo dõi trên nhiều trang web và cô lập các cookie còn lại
content-blocking-social-media-trackers = Trình theo dõi truyền thông xã hội
content-blocking-all-cookies = Tất cả cookie
content-blocking-unvisited-cookies = Cookie từ các trang không mong muốn
content-blocking-all-windows-tracking-content = Trình theo dõi nội dung trong tất cả cửa sổ
content-blocking-all-third-party-cookies = Toàn bộ cookie từ bên thứ ba
content-blocking-cryptominers = Tiền điện tử
content-blocking-fingerprinters = Dấu vết (Fingerprintng)
content-blocking-warning-title = Hãy cân nhắc!
content-blocking-and-isolating-etp-warning-description = Chặn trình theo dõi và cô lập cookie có thể ảnh hưởng đến chức năng của một số trang web. Tải lại một trang với trình theo dõi để tải tất cả nội dung.
content-blocking-and-isolating-etp-warning-description-2 = Cài đặt này có thể khiến một số trang web không hiển thị nội dung hoặc hoạt động không chính xác. Nếu trang web có vẻ bị hỏng, bạn có thể muốn tắt trình chống theo dõi để trang web đó tải tất cả nội dung.
content-blocking-warning-learn-how = Tìm hiểu cách thức
content-blocking-reload-description = Bạn sẽ cần tải lại các thẻ của mình để áp dụng những thay đổi này.
content-blocking-reload-tabs-button =
    .label = Tải lại tất cả các thẻ
    .accesskey = R
content-blocking-tracking-content-label =
    .label = Trình theo dõi nội dung
    .accesskey = T
content-blocking-tracking-protection-option-all-windows =
    .label = Trong tất cả các cửa sổ
    .accesskey = A
content-blocking-option-private =
    .label = Chỉ trong cửa sổ riêng tư
    .accesskey = P
content-blocking-tracking-protection-change-block-list = Thay đổi danh sách chặn
content-blocking-cookies-label =
    .label = Cookie
    .accesskey = C
content-blocking-expand-section =
    .tooltiptext = Thông tin chi tiết
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Tiền điện tử
    .accesskey = y
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Dấu vết (Fingerprintng)
    .accesskey = F

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Quản lý các ngoại lệ…
    .accesskey = x

## Privacy Section - Permissions

permissions-header = Quyền hạn
permissions-location = Vị trí
permissions-location-settings =
    .label = Cài đặt…
    .accesskey = t
permissions-xr = Thực tế ảo
permissions-xr-settings =
    .label = Cài đặt…
    .accesskey = t
permissions-camera = Máy ảnh
permissions-camera-settings =
    .label = Cài đặt…
    .accesskey = t
permissions-microphone = Micrô
permissions-microphone-settings =
    .label = Cài đặt…
    .accesskey = t
permissions-notification = Thông báo
permissions-notification-settings =
    .label = Cài đặt…
    .accesskey = t
permissions-notification-link = Tìm hiểu thêm
permissions-notification-pause =
    .label = Tạm dừng thông báo cho đến khi { -brand-short-name } khởi động lại
    .accesskey = n
permissions-autoplay = Tự động phát
permissions-autoplay-settings =
    .label = Cài đặt…
    .accesskey = t
permissions-block-popups =
    .label = Chặn các cửa sổ bật lên
    .accesskey = B
permissions-block-popups-exceptions =
    .label = Ngoại trừ…
    .accesskey = E
permissions-addon-install-warning =
    .label = Cảnh báo khi trang web cố gắng cài đặt tiện ích
    .accesskey = W
permissions-addon-exceptions =
    .label = Ngoại trừ…
    .accesskey = E
permissions-a11y-privacy-checkbox =
    .label = Ngăn chặn khả năng tiếp cận dịch vụ truy cập vào trình duyệt của bạn
    .accesskey = a
permissions-a11y-privacy-link = Tìm hiểu thêm

## Privacy Section - Data Collection

collection-header = Thu thập và sử dụng dữ liệu { -brand-short-name }
collection-description = Chúng tôi cố gắng cung cấp cho bạn sự lựa chọn và chỉ thu thập những gì chúng tôi cần để cung cấp và cải thiện { -brand-short-name } cho tất cả mọi người. Chúng tôi luôn xin phép trước khi thu thập thông tin cá nhân.
collection-privacy-notice = Thông báo bảo mật
collection-health-report-telemetry-disabled = Bạn không còn cho phép { -vendor-short-name } thu thập dữ liệu kỹ thuật và tương tác. Tất cả dữ liệu trong quá khứ sẽ bị xóa trong vòng 30 ngày.
collection-health-report-telemetry-disabled-link = Tìm hiểu thêm
collection-health-report =
    .label = Cho phép { -brand-short-name } gửi dữ liệu kỹ thuật và tương tác tới { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Tìm hiểu thêm
collection-studies =
    .label = Cho phép { -brand-short-name } cài đặt và chạy các nghiên cứu
collection-studies-link = Xem nghiên cứu { -brand-short-name }
addon-recommendations =
    .label = Cho phép { -brand-short-name } để thực hiện các đề xuất tiện ích mở rộng được cá nhân hóa
addon-recommendations-link = Tìm hiểu thêm
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Dữ liệu báo cáo bị vô hiệu hóa với cấu hình này
collection-backlogged-crash-reports =
    .label = Cho phép { -brand-short-name } thay bạn gửi các báo cáo sự cố còn tồn đọng
    .accesskey = c
collection-backlogged-crash-reports-link = Tìm hiểu thêm
collection-backlogged-crash-reports-with-link = Cho phép { -brand-short-name } thay mặt bạn gửi báo cáo sự cố tồn đọng <a data-l10n-name="crash-reports-link">Tìm hiểu thêm</a>
    .accesskey = c

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Bảo mật
security-browsing-protection = Chống nội dung lừa đảo và phần mềm nguy hiểm
security-enable-safe-browsing =
    .label = Chặn nội dung lừa đảo và không an toàn
    .accesskey = B
security-enable-safe-browsing-link = Tìm hiểu thêm
security-block-downloads =
    .label = Chặn tải xuống không an toàn
    .accesskey = d
security-block-uncommon-software =
    .label = Cảnh báo bạn về phần mềm không mong muốn và không phổ biến
    .accesskey = c

## Privacy Section - Certificates

certs-header = Chứng nhận
certs-personal-label = Khi một máy chủ yêu cầu chứng thực cá nhân của bạn
certs-select-auto-option =
    .label = Tự động chọn một cái
    .accesskey = S
certs-select-ask-option =
    .label = Luôn hỏi bạn
    .accesskey = A
certs-enable-ocsp =
    .label = Truy vấn máy chủ đáp ứng giao thức OCSP để xác minh hiệu lực của các chứng chỉ
    .accesskey = Q
certs-view =
    .label = Xem chứng nhận…
    .accesskey = C
certs-devices =
    .label = Thiết bị bảo mật…
    .accesskey = D
space-alert-learn-more-button =
    .label = Tìm hiểu thêm
    .accesskey = L
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Mở tùy chọn
           *[other] Mở tùy chỉnh
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] O
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] Không đủ dung lượng đĩa cho { -brand-short-name }. Nội dung trang web có thể không hiển thị chính xác. Bạn có thể xóa dữ liệu được lưu trữ trong Tùy chọn > Riêng tư & Bảo mật > Cookie và Dữ liệu trang.
       *[other] Không đủ dung lượng đĩa cho { -brand-short-name }. Nội dung trang web có thể không hiển thị chính xác. Bạn có thể xóa dữ liệu được lưu trữ trong Tùy chọn > Riêng tư & Bảo mật > Cookie và Dữ liệu trang.
    }
space-alert-under-5gb-ok-button =
    .label = OK, đã hiểu
    .accesskey = K
space-alert-under-5gb-message = Không đủ dung lượng đĩa cho { -brand-short-name }. Nội dung trang web có thể không hiển thị chính xác. Truy cập “Tìm hiểu thêm” để tối ưu hóa việc sử dụng đĩa của bạn để có trải nghiệm duyệt web tốt hơn.
space-alert-over-5gb-settings-button =
    .label = Mở Cài đặt
    .accesskey = O
space-alert-over-5gb-message2 = <strong>{ -brand-short-name } sắp hết dung lượng đĩa.</strong> Nội dung trang web có thể không hiển thị chính xác. Bạn có thể xóa dữ liệu được lưu trữ trong Cài đặt > Riêng tư & Bảo mật > Cookie và dữ liệu trang.
space-alert-under-5gb-message2 = <strong>{ -brand-short-name } sắp hết dung lượng đĩa. </strong>Nội dung trang web có thể không hiển thị chính xác. Truy cập “Tìm hiểu thêm” để tối ưu hóa việc sử dụng đĩa của bạn để có trải nghiệm duyệt web tốt hơn.

## Privacy Section - HTTPS-Only

httpsonly-header = Chế độ chỉ HTTPS
httpsonly-description = HTTPS cung cấp kết nối được mã hóa an toàn giữa { -brand-short-name } và các trang web bạn truy cập. Hầu hết các trang web đều hỗ trợ HTTPS và nếu chế độ chỉ HTTPS được bật, thì { -brand-short-name } sẽ nâng cấp tất cả các kết nối lên HTTPS.
httpsonly-learn-more = Tìm hiểu thêm
httpsonly-radio-enabled =
    .label = Kích hoạt chế độ chỉ HTTPS trong tất cả các cửa sổ
httpsonly-radio-enabled-pbm =
    .label = Chỉ kích hoạt chế độ HTTPS trong các cửa sổ riêng tư
httpsonly-radio-disabled =
    .label = Không kích hoạt chế độ chỉ HTTPS

## The following strings are used in the Download section of settings

desktop-folder-name = Bàn làm việc
downloads-folder-name = Tải xuống
choose-download-folder-title = Chọn thư mục tải xuống:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Lưu tập tin vào { $service-name }
