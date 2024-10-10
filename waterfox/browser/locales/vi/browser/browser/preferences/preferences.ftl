# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Gửi tín hiệu “Không theo dõi” tới trang web để cho biết bạn không muốn bị theo dõi
do-not-track-description2 =
    .label = Gửi yêu cầu “không theo dõi” đến trang web
    .accesskey = d
do-not-track-learn-more = Tìm hiểu thêm
do-not-track-option-default-content-blocking-known =
    .label = Chỉ khi { -brand-short-name } được đặt để chặn trình theo dõi đã biết
do-not-track-option-always =
    .label = Luôn luôn
global-privacy-control-description =
    .label = Yêu cầu trang web không bán hoặc chia sẻ dữ liệu của tôi
    .accesskey = s
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
##   $name (string) - Name of the extension

# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlling-password-saving = <img data-l10n-name="icon"/> <strong>{ $name }</strong> kiểm soát cài đặt này.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlling-web-notifications = <img data-l10n-name="icon"/> <strong>{ $name }</strong> kiểm soát cài đặt này.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlling-privacy-containers = <img data-l10n-name="icon"/> <strong>{ $name }</strong> yêu cầu ngăn chứa thẻ.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlling-websites-content-blocking-all-trackers = <img data-l10n-name="icon"/> <strong>{ $name }</strong> kiểm soát cài đặt này.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlling-proxy-config = <img data-l10n-name ="icon"/> <strong>{ $name }</strong> kiểm soát cách { -brand-short-name } kết nối với Internet.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Để kích hoạt tiện ích mở rộng hãy vào phần tiện ích <img data-l10n-name="addons-icon"/> trên bảng chọn <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Kết quả tìm kiếm
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 = Xin lỗi! Không có kết quả nào trong Cài đặt cho “<span data-l10n-name="query"></span>”.
search-results-help-link = Cần trợ giúp? Đi đến <a data-l10n-name="url">Hỗ trợ { -brand-short-name }</a>

## General Section

startup-header = Khởi động
always-check-default =
    .label = Luôn kiểm tra xem { -brand-short-name } có phải trình duyệt mặc định không
    .accesskey = y
is-default = { -brand-short-name } đang là trình duyệt mặc định của bạn
is-not-default = { -brand-short-name } không phải là trình duyệt mặc định
set-as-my-default-browser =
    .label = Đặt làm mặc định…
    .accesskey = D
startup-restore-windows-and-tabs =
    .label = Mở các cửa sổ và thẻ trước đó
    .accesskey = s
startup-restore-warn-on-quit =
    .label = Cảnh báo bạn khi thoát khỏi trình duyệt
disable-extension =
    .label = Vô hiệu hóa tiện ích mở rộng
preferences-data-migration-header = Nhập dữ liệu trình duyệt
preferences-data-migration-description = Nhập dấu trang, mật khẩu, lịch sử và dữ liệu tự động điền vào { -brand-short-name }.
preferences-data-migration-button =
    .label = Nhập dữ liệu
    .accesskey = m
tabs-group-header = Thẻ
ctrl-tab-recently-used-order =
    .label = Ctrl+Tab để chuyển qua các thẻ theo thứ tự sử dụng gần đây nhất
    .accesskey = T
open-new-link-as-tabs =
    .label = Mở đường dẫn ở thẻ thay vì ở cửa sổ mới
    .accesskey = w
confirm-on-close-multiple-tabs =
    .label = Xác nhận trước khi đóng nhiều thẻ
    .accesskey = m
# This string is used for the confirm before quitting preference.
# Variables:
#   $quitKey (string) - the quit keyboard shortcut, and formatted
#                       in the same manner as it would appear,
#                       for example, in the File menu.
confirm-on-quit-with-key =
    .label = Xác nhận trước khi thoát bằng { $quitKey }
    .accesskey = b
warn-on-open-many-tabs =
    .label = Cảnh báo bạn khi mở nhiều thẻ có thể làm chậm { -brand-short-name }
    .accesskey = d
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

## Variables:
##   $tabCount (number) - Number of tabs

containers-disable-alert-desc = Nếu bạn vô hiệu hóa ngăn chứa thẻ bây giờ, { $tabCount } thẻ trong ngăn chứa sẽ bị đóng. Bạn có chắc muốn vô hiệu hóa ngăn chứa thẻ?
containers-disable-alert-ok-button = Đóng { $tabCount } thẻ trong ngăn chứa

##

containers-disable-alert-cancel-button = Tiếp tục bật
containers-remove-alert-title = Xóa ngăn chứa này?
# Variables:
#   $count (number) - Number of tabs that will be closed.
containers-remove-alert-msg = Nếu bạn xóa ngăn chứa này bây giờ, { $count } thẻ trong ngăn chứa sẽ bị đóng. Bạn có chắc muốn xóa ngăn chứa này?
containers-remove-ok-button = Xóa ngăn chứa này
containers-remove-cancel-button = Không xóa ngăn chứa này

## General Section - Language & Appearance

language-and-appearance-header = Ngôn ngữ và chủ đề
preferences-web-appearance-header = Diện mạo trang web
preferences-web-appearance-description = Một số trang web điều chỉnh bảng màu của họ dựa trên tùy chỉnh của bạn. Chọn bảng màu mà bạn muốn sử dụng cho các trang web đó.
preferences-web-appearance-choice-auto = Tự động
preferences-web-appearance-choice-light = Sáng
preferences-web-appearance-choice-dark = Tối
preferences-web-appearance-choice-tooltip-auto =
    .title = Tự động thay đổi hình nền và nội dung trang web dựa trên cài đặt hệ thống và chủ đề { -brand-short-name } của bạn.
preferences-web-appearance-choice-tooltip-light =
    .title = Sử dụng giao diện sáng cho hình nền và nội dung trang web.
preferences-web-appearance-choice-tooltip-dark =
    .title = Sử dụng giao diện tối cho hình nền và nội dung trang web.
preferences-web-appearance-choice-input-auto =
    .aria-description = { preferences-web-appearance-choice-tooltip-auto.title }
preferences-web-appearance-choice-input-light =
    .aria-description = { preferences-web-appearance-choice-tooltip-light.title }
preferences-web-appearance-choice-input-dark =
    .aria-description = { preferences-web-appearance-choice-tooltip-dark.title }
# This can appear when using windows HCM or "Override colors: always" without
# system colors.
preferences-web-appearance-override-warning = Các lựa chọn màu sắc của bạn đang ghi đè diện mạo trang web. <a data-l10n-name="colors-link">Quản lý màu</a>
# This message contains one link. It can be moved within the sentence as needed
# to adapt to your language, but should not be changed.
preferences-web-appearance-footer = Quản lý chủ đề { -brand-short-name } trong <a data-l10n-name="themes-link">Tiện ích mở rộng & chủ đề</a>
preferences-colors-header = Màu
preferences-colors-description = Ghi đè màu mặc định của { -brand-short-name } cho văn bản, nền trang web và liên kết.
preferences-colors-manage-button =
    .label = Quản lý màu…
    .accesskey = C
preferences-fonts-header = Phông chữ
default-font = Phông mặc định
    .accesskey = D
default-font-size = Kích thước
    .accesskey = S
advanced-fonts =
    .label = Nâng cao…
    .accesskey = o
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Thu phóng
preferences-default-zoom = Thu phóng mặc định
    .accesskey = z
# Variables:
#   $percentage (number) - Zoom percentage value
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
    .label = Đặt ngôn ngữ thay thế…
    .accesskey = I
confirm-browser-language-change-description = Khởi động lại { -brand-short-name } để áp dụng các thay đổi này
confirm-browser-language-change-button = Áp dụng và Khởi động lại
translate-web-pages =
    .label = Dịch nội dung web
    .accesskey = D
fx-translate-web-pages = { -translations-brand-name }
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
download-save-where = Lưu tập tin vào
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
# Variables:
#   $type-description (string) - Description of the type (e.g "Portable Document Format")
#   $type (string) - The MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })
# Variables:
#   $extension (string) - File extension (e.g .TXT)
#   $type (string) - The MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })
# Variables:
#   $plugin-name (string) - Name of a plugin (e.g Adobe Flash)
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

applications-handle-new-file-types-description = { -brand-short-name } nên làm gì với các tập tin khác?
applications-save-for-new-types =
    .label = Lưu tập tin
    .accesskey = S
applications-ask-before-handling =
    .label = Hỏi xem có nên mở hay lưu tập tin hay không
    .accesskey = A
drm-content-header = Nội dung quản lý bản quyền kỹ thuật số (DRM)
play-drm-content =
    .label = Phát nội dung DRM được kiểm soát
    .accesskey = P
play-drm-content-learn-more = Tìm hiểu thêm
update-application-title = Cập nhật { -brand-short-name }
update-application-description = Giữ { -brand-short-name } luôn cập nhật để đạt được hiệu năng, sự ổn định, và bảo mật tốt nhất.
# Variables:
# $version (string) - Waterfox version
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
update-application-suppress-prompts =
    .label = Hiển thị ít lời nhắc thông báo cập nhật hơn
    .accesskey = n
update-setting-write-failure-title2 = Lỗi khi lưu cài đặt Cập nhật
# Variables:
#   $path (string) - Path to the configuration file
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
#   $num (number) - Default value of the `dom.ipc.processCount` pref.
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
browsing-gtk-use-non-overlay-scrollbars =
    .label = Luôn hiển thị thanh cuộn
    .accesskey = o
browsing-use-onscreen-keyboard =
    .label = Hiển thị bàn phím cảm ứng khi cần thiết
    .accesskey = b
browsing-use-cursor-navigation =
    .label = Cho phép dùng con trỏ để di chuyển bên trong trang
    .accesskey = c
browsing-use-full-keyboard-navigation =
    .label = Sử dụng phím tab để di chuyển phần được chọn giữa các trường biểu mẫu và liên kết
    .accesskey = t
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
home-mode-choice-default-fx =
    .label = { -firefox-home-brand-name } (Mặc định)
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

## Home Section - Waterfox Home Content Customization

home-prefs-content-header2 = Nội dung { -firefox-home-brand-name }
home-prefs-content-description2 = Chọn nội dung bạn muốn trên màn hình { -firefox-home-brand-name } của mình.
home-prefs-search-header =
    .label = Tìm kiếm web
home-prefs-shortcuts-header =
    .label = Lối tắt
home-prefs-shortcuts-description = Các trang web bạn lưu hoặc truy cập
home-prefs-shortcuts-by-option-sponsored =
    .label = Các lối tắt được tài trợ

## Variables:
##  $provider (string) - Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Được đề xuất bởi { $provider }
home-prefs-recommended-by-description-new = Nội dung đặc biệt do { $provider }, một phần của { -brand-product-name }, quản lý

##

home-prefs-recommended-by-learn-more = Nó hoạt động như thế nào
home-prefs-recommended-by-option-sponsored-stories =
    .label = Bài viết quảng cáo
home-prefs-recommended-by-option-recent-saves =
    .label = Hiển thị các mục đã lưu gần đây
home-prefs-highlights-option-visited-pages =
    .label = Trang đã truy cập
home-prefs-highlights-options-bookmarks =
    .label = Dấu trang
home-prefs-highlights-option-most-recent-download =
    .label = Tải xuống gần đây nhất
home-prefs-highlights-option-saved-to-pocket =
    .label = Đã lưu trang vào { -pocket-brand-name }
home-prefs-recent-activity-header =
    .label = Hoạt động gần đây
home-prefs-recent-activity-description = Tuyển chọn các trang và nội dung gần đây
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Ghi chú nhỏ
home-prefs-snippets-description-new = Mẹo và tin tức từ { -vendor-short-name } và { -brand-product-name }
# Variables:
#   $num (number) - Number of rows displayed
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
# With this option enabled, on the search results page
# the URL will be replaced by the search terms in the address bar
# when using the current default search engine.
search-show-search-term-option =
    .label = Hiển thị các cụm từ tìm kiếm thay vì URL trên trang kết quả của công cụ tìm kiếm mặc định
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Hiển thị những gợi ý tìm kiếm phía trước lịch sử duyệt web trong kết quả thanh địa chỉ
search-show-suggestions-private-windows =
    .label = Hiển thị đề xuất tìm kiếm trong cửa sổ riêng tư
suggestions-addressbar-settings-generic2 = Thay đổi cài đặt cho các đề xuất khác trên thanh địa chỉ
search-suggestions-cant-show = Gợi ý tìm kiếm sẽ không được hiển thị ở thanh địa chỉ vì bạn đã thiết lập { -brand-short-name } không bao giờ ghi nhớ lịch sử.
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
#   $name (string) - Name of a search engine.
search-keyword-warning-engine = Bạn đã chọn một từ khóa hiện đang được dùng bởi "{ $name }". Vui lòng chọn từ khác.
search-keyword-warning-bookmark = Bạn đã chọn một từ khóa hiện đang được dùng bởi một dấu trang. Vui lòng chọn từ khác.

## Containers Section

containers-back-button2 =
    .aria-label = Quay lại Cài đặt
containers-header = Ngăn chứa thẻ
containers-add-button =
    .label = Thêm ngăn chứa mới
    .accesskey = T
containers-new-tab-check =
    .label = Chọn một ngăn chứa cho mỗi thẻ mới
    .accesskey = S
containers-settings-button =
    .label = Cài đặt
containers-remove-button =
    .label = Loại bỏ

## Waterfox account - Signed out. Note that "Sync" and "Waterfox account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Mang trang web theo bạn
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
sync-mobile-promo = Tải Waterfox cho <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> hoặc <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> để đồng bị với thiết bị di động của bạn.

## Waterfox account - Signed in

sync-profile-picture =
    .tooltiptext = Đổi hình hồ sơ
sync-sign-out =
    .label = Đăng xuất…
    .accesskey = g
sync-manage-account = Quản lý tài khoản
    .accesskey = k

## Variables
## $email (string) - Email used for Waterfox account

sync-signedin-unverified = { $email } chưa được kiểm tra.
sync-signedin-login-failure = Xin hãy đăng nhập để kết nối lại { $email }

##

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
prefs-sync-turn-on-syncing =
    .label = Bật đồng bộ hóa…
    .accesskey = s
prefs-sync-offer-setup-label2 = Đồng bộ trang đánh dấu, lịch sử, thẻ, mật khẩu, tiện ích và cài đặt tới tất cả các thiết bị của bạn.
prefs-sync-now =
    .labelnotsyncing = Đồng bộ hóa ngay
    .accesskeynotsyncing = N
    .labelsyncing = Đang đồng bộ hóa…
prefs-sync-now-button =
    .label = Đồng bộ hóa ngay
    .accesskey = N
prefs-syncing-button =
    .label = Đang đồng bộ hóa…

## The list of things currently syncing.

sync-syncing-across-devices-heading = Bạn đang đồng bộ hóa các mục này trên tất cả các thiết bị được kết nối của mình:
sync-currently-syncing-bookmarks = Dấu trang
sync-currently-syncing-history = Lịch sử
sync-currently-syncing-tabs = Các thẻ đang mở
sync-currently-syncing-logins-passwords = Thông tin đăng nhập và mật khẩu
sync-currently-syncing-addresses = Địa chỉ
sync-currently-syncing-creditcards = Thẻ tín dụng
sync-currently-syncing-addons = Tiện ích
sync-currently-syncing-settings = Cài đặt
sync-change-options =
    .label = Thay đổi…
    .accesskey = C

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog3 =
    .title = Chọn những gì để đồng bộ hóa
    .style = min-width: 46em;
    .buttonlabelaccept = Lưu thay đổi
    .buttonaccesskeyaccept = S
    .buttonlabelextra2 = Ngắt kết nối…
    .buttonaccesskeyextra2 = D
sync-choose-dialog-subtitle = Các thay đổi đối với danh sách các mục cần đồng bộ hóa sẽ được phản ánh trên tất cả các thiết bị được kết nối của bạn.
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
    .label = Thông tin đăng nhập và mật khẩu
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
    .tooltiptext = Tiện ích mở rộng và chủ đề của Waterfox dành cho máy tính
    .accesskey = A
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

## These strings are shown in a desktop notification after the
## user requests we resend a verification email.

sync-verification-sent-title = Tin nhắn xác thực đã được gửi
# Variables:
#   $email (String): Email address of user's Waterfox account.
sync-verification-sent-body = Một liên kết xác thực đã được gửi tới { $email }
sync-verification-not-sent-title = Không thể gửi xác thực
sync-verification-not-sent-body = Chúng tôi không thể gửi thư xác thực vào thời điểm này, xin thử lại sau.

## Privacy Section

privacy-header = Duyệt web riêng tư

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Thông tin đăng nhập & mật khẩu
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
preferences-relay-integration-checkbox =
    .label = Đề xuất mặt nạ email { -relay-brand-name } để bảo vệ địa chỉ email của bạn
relay-integration-learn-more-link = Tìm hiểu thêm
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Tự động điền đăng nhập và mật khẩu
    .accesskey = i
forms-saved-logins =
    .label = Đăng nhập đã lưu…
    .accesskey = L
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
forms-primary-pw-change =
    .label = Thay đổi mật khẩu chính…
    .accesskey = P
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }
forms-primary-pw-fips-title = Bạn hiện đang ở chế độ FIPS. FIPS yêu cầu tính năng mật khẩu chính.
forms-master-pw-fips-desc = Thay đổi mật khẩu không thành công
forms-windows-sso =
    .label = Cho phép Windows đăng nhập một lần cho tài khoản Microsoft, cơ quan và trường học
forms-windows-sso-learn-more-link = Tìm hiểu thêm
forms-windows-sso-desc = Quản lý tài khoản trong cài đặt thiết bị của bạn

## OS Authentication dialog

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Để tạo mật khẩu chính, hãy nhập thông tin đăng nhập Windows của bạn. Điều này giúp bảo vệ tính bảo mật của tài khoản của bạn.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Waterfox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = tạo một mật khẩu chính
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Lịch sử
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Waterfox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Waterfox", moving the verb into each option.
#     This will result in "Waterfox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Waterfox history settings:".
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
    .label = Xóa lịch sử khi đóng { -brand-short-name }
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
#   $value (number) - Value of the unit (for example: 4.6, 500)
#   $unit (string) - Name of the unit (for example: "bytes", "KB")
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
sitedata-option-block-cross-site-tracking-cookies =
    .label = Cookie theo dõi trên nhiều trang web
sitedata-option-block-cross-site-cookies =
    .label = Cookie theo dõi trên nhiều trang web và cô lập các cookie trên nhiều trang khác
sitedata-option-block-unvisited =
    .label = Cookie từ các trang web không mong muốn
sitedata-option-block-all-cross-site-cookies =
    .label = Tất cả cookie trên nhiều trang web (có thể khiến trang web bị hỏng)
sitedata-option-block-all =
    .label = Tất cả các cookie (có thể khiến các trang web bị hỏng)
sitedata-clear =
    .label = Xóa dữ liệu...
    .accesskey = l
sitedata-settings =
    .label = Quản lý dữ liệu...
    .accesskey = M
sitedata-cookies-exceptions =
    .label = Quản lý ngoại lệ…
    .accesskey = x

## Privacy Section - Cookie Banner Handling

cookie-banner-handling-header = Giảm biểu ngữ cookie
cookie-banner-handling-description = { -brand-short-name } tự động cố gắng từ chối các yêu cầu cookie trên biểu ngữ cookie trên các trang web được hỗ trợ.
cookie-banner-learn-more = Tìm hiểu thêm
forms-handle-cookie-banners =
    .label = Giảm biểu ngữ cookie

## Privacy Section - Address Bar

addressbar-header = Thanh địa chỉ
addressbar-suggest = Khi dùng thanh địa chỉ, gợi ý
addressbar-locbar-history-option =
    .label = Lịch sử duyệt web
    .accesskey = h
addressbar-locbar-bookmarks-option =
    .label = Dấu trang
    .accesskey = k
addressbar-locbar-clipboard-option =
    .label = Khay nhớ tạm
    .accesskey = C
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
addressbar-locbar-quickactions-option =
    .label = Hành động nhanh
    .accesskey = Q
addressbar-suggestions-settings = Thay đổi tùy chỉnh phần gợi ý của công cụ tìm kiếm
addressbar-quickactions-learn-more = Tìm hiểu thêm

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Trình chống theo dõi nâng cao
content-blocking-section-top-level-description = Trình theo dõi theo bạn trên mạng để thu thập thông tin về thói quen và sở thích duyệt web của bạn. { -brand-short-name } chặn nhiều trình theo dõi và các tập lệnh độc hại khác.
content-blocking-learn-more = Tìm hiểu thêm
content-blocking-fpi-incompatibility-warning = Bạn đang sử dụng First Party Isolation (FPI), tính năng này sẽ ghi đè một số cài đặt cookie của { -brand-short-name }.
# There is no need to translate "Resist Fingerprinting (RFP)". This is a
# feature that can only be enabled via about:config, and it's not exposed to
# standard users (e.g. via Settings).
content-blocking-rfp-incompatibility-warning = Bạn đang sử dụng Resist Fingerprinting (RFP), nó sẽ thay thế một số cài đặt bảo vệ dấu vết của { -brand-short-name }. Điều này có thể khiến một số trang web bị hỏng.

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
content-blocking-cross-site-cookies-in-all-windows2 = Cookie trên nhiều trang web trong tất cả các cửa sổ
content-blocking-cross-site-tracking-cookies = Cookie theo dõi trên nhiều trang web
content-blocking-all-cross-site-cookies-private-windows = Cookie trên nhiều trang web trong cửa sổ riêng tư
content-blocking-cross-site-tracking-cookies-plus-isolate = Cookie theo dõi trên nhiều trang web và cô lập các cookie còn lại
content-blocking-social-media-trackers = Trình theo dõi truyền thông xã hội
content-blocking-all-cookies = Tất cả cookie
content-blocking-unvisited-cookies = Cookie từ các trang không mong muốn
content-blocking-all-windows-tracking-content = Trình theo dõi nội dung trong tất cả cửa sổ
content-blocking-all-cross-site-cookies = Tất cả cookie trên nhiều trang web
content-blocking-cryptominers = Tiền điện tử
content-blocking-fingerprinters = Dấu vết (Fingerprintng)
# The known fingerprinters are those that are known for collecting browser fingerprints from user devices. And
# the suspected fingerprinters are those that we are uncertain about browser fingerprinting activities. But they could
# possibly acquire browser fingerprints because of the behavior on accessing APIs that expose browser fingerprints.
content-blocking-known-and-suspected-fingerprinters = Dấu vết đã biết và đáng ngờ

# The tcp-rollout strings are no longer used for the rollout but for tcp-by-default in the standard section

# "Contains" here means "isolates", "limits".
content-blocking-etp-standard-tcp-rollout-description = Trình chống cookie chung chứa các cookie cho trang web bạn đang truy cập, vì vậy, trình theo dõi không thể sử dụng chúng để theo dõi bạn giữa các trang web.
content-blocking-etp-standard-tcp-rollout-learn-more = Tìm hiểu thêm
content-blocking-etp-standard-tcp-title = Bao gồm Trình chống cookie chung, tính năng bảo mật mạnh mẽ nhất từ trước đến nay của chúng tôi
content-blocking-warning-title = Hãy cân nhắc!
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
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
#
# The known fingerprinters are those that are known for collecting browser fingerprints from user devices.
content-blocking-known-fingerprinters-label =
    .label = Dấu vết đã biết
    .accesskey = K
# The suspected fingerprinters are those that we are uncertain about browser fingerprinting activities. But they could
# possibly acquire browser fingerprints because of the behavior on accessing APIs that expose browser fingerprints.
content-blocking-suspected-fingerprinters-label =
    .label = Dấu vết đáng ngờ
    .accesskey = S

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Quản lý ngoại lệ…
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
# Short form for "the act of choosing sound output devices and redirecting audio to the chosen devices".
permissions-speaker = Lựa chọn loa
permissions-speaker-settings =
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
# "popup" is a misspelling that is more popular than the correct spelling of
# "pop-up" so it's included as a search keyword, not displayed in the UI.
permissions-block-popups-exceptions-button =
    .label = Ngoại trừ…
    .accesskey = E
    .searchkeywords = cửa sổ bật lên
permissions-addon-install-warning =
    .label = Cảnh báo khi trang web cố gắng cài đặt tiện ích
    .accesskey = W
permissions-addon-exceptions =
    .label = Ngoại trừ…
    .accesskey = E

## Privacy Section - Data Collection

collection-header = Thu thập và sử dụng dữ liệu { -brand-short-name }
collection-header2 = Thu thập và sử dụng dữ liệu { -brand-short-name }
    .searchkeywords = thu thập
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
collection-backlogged-crash-reports-with-link = Cho phép { -brand-short-name } thay mặt bạn gửi báo cáo sự cố tồn đọng <a data-l10n-name="crash-reports-link">Tìm hiểu thêm</a>
    .accesskey = c
privacy-segmentation-section-header = Các tính năng mới nâng cao khả năng duyệt web của bạn
privacy-segmentation-section-description = Khi chúng tôi cung cấp các tính năng sử dụng dữ liệu của bạn để mang lại cho bạn trải nghiệm cá nhân hơn:
privacy-segmentation-radio-off =
    .label = Sử dụng các đề xuất của { -brand-product-name }
privacy-segmentation-radio-on =
    .label = Hiển thị thông tin chi tiết

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
certs-enable-ocsp =
    .label = Truy vấn máy chủ đáp ứng giao thức OCSP để xác minh hiệu lực của các chứng chỉ
    .accesskey = Q
certs-view =
    .label = Xem chứng nhận…
    .accesskey = C
certs-devices =
    .label = Thiết bị bảo mật…
    .accesskey = D
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

## DoH Section

preferences-doh-header = DNS qua HTTPS
preferences-doh-description = Hệ thống tên miền (DNS) qua HTTPS gửi yêu cầu tên miền của bạn thông qua kết nối được mã hóa, tạo một DNS an toàn và khiến người khác khó nhìn thấy trang web bạn sắp truy cập hơn.
# Variables:
#   $status (string) - The status of the DoH connection
preferences-doh-status = Trạng thái: { $status }
# Variables:
#   $name (string) - The name of the DNS over HTTPS resolver. If a custom resolver is used, the name will be the domain of the URL.
preferences-doh-resolver = Nhà cung cấp: { $name }
# This is displayed instead of $name in preferences-doh-resolver
# when the DoH URL is not a valid URL
preferences-doh-bad-url = URL không hợp lệ
preferences-doh-steering-status = Sử dụng nhà cung cấp cục bộ
preferences-doh-status-active = Đang hoạt động
preferences-doh-status-disabled = Đã tắt
# Variables:
#   $reason (string) - A string representation of the reason DoH is not active. For example NS_ERROR_UNKNOWN_HOST or TRR_RCODE_FAIL.
preferences-doh-status-not-active = Không hoạt động ({ $reason })
preferences-doh-group-message = Kích hoạt DNS an toàn sử dụng:
preferences-doh-expand-section =
    .tooltiptext = Thông tin chi tiết
preferences-doh-setting-default =
    .label = Bảo vệ mặc định
    .accesskey = D
preferences-doh-default-desc = { -brand-short-name } quyết định thời điểm sử dụng DNS an toàn để bảo vệ quyền riêng tư của bạn.
preferences-doh-default-detailed-desc-1 = Sử dụng DNS an toàn ở những khu vực có sẵn
preferences-doh-default-detailed-desc-2 = Sử dụng trình phân giải DNS mặc định của bạn nếu có sự cố với nhà cung cấp DNS an toàn
preferences-doh-default-detailed-desc-3 = Sử dụng một nhà cung cấp cục bộ, nếu có thể
preferences-doh-default-detailed-desc-4 = Tắt khi VPN, quyền kiểm soát của phụ huynh hoặc chính sách doanh nghiệp đang hoạt động
preferences-doh-default-detailed-desc-5 = Tắt khi mạng thông báo { -brand-short-name } không nên sử dụng DNS an toàn
preferences-doh-setting-enabled =
    .label = Bảo vệ gia tăng
    .accesskey = I
preferences-doh-enabled-desc = Bạn kiểm soát thời điểm sử dụng DNS bảo mật và chọn nhà cung cấp của mình.
preferences-doh-enabled-detailed-desc-1 = Sử dụng nhà cung cấp bạn chọn
preferences-doh-enabled-detailed-desc-2 = Chỉ sử dụng trình phân giải DNS mặc định của bạn nếu có sự cố với DNS bảo mật
preferences-doh-setting-strict =
    .label = Bảo vệ tối đa
    .accesskey = M
preferences-doh-strict-desc = { -brand-short-name } sẽ luôn sử dụng DNS an toàn. Bạn sẽ thấy cảnh báo rủi ro bảo mật trước khi chúng tôi sử dụng DNS hệ thống của bạn.
preferences-doh-strict-detailed-desc-1 = Chỉ sử dụng nhà cung cấp bạn chọn
preferences-doh-strict-detailed-desc-2 = Luôn cảnh báo nếu không có DNS an toàn
preferences-doh-strict-detailed-desc-3 = Nếu không có DNS an toàn, các trang web sẽ không tải hoặc hoạt động bình thường
preferences-doh-setting-off =
    .label = Tắt
    .accesskey = O
preferences-doh-off-desc = Sử dụng trình phân giải DNS mặc định của bạn
preferences-doh-checkbox-warn =
    .label = Cảnh báo nếu bên thứ ba chủ động ngăn chặn DNS an toàn
    .accesskey = W
preferences-doh-select-resolver = Chọn nhà cung cấp:
preferences-doh-exceptions-description = { -brand-short-name } sẽ không sử dụng DNS an toàn trên các trang web này
preferences-doh-manage-exceptions =
    .label = Quản lý ngoại trừ…
    .accesskey = x

## The following strings are used in the Download section of settings

desktop-folder-name = Bàn làm việc
downloads-folder-name = Tải xuống
choose-download-folder-title = Chọn thư mục tải xuống:
