# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

xpinstall-prompt = Trang này muốn cài đặt phần mềm lên máy tính của bạn và đã bị { -brand-short-name } chặn lại.

## Variables:
##   $host (String): The hostname of the site the add-on is being installed from.

xpinstall-prompt-header = Cho phép { $host } cài đặt tiện ích mở rộng?
xpinstall-prompt-message = Bạn đang cố gắng cài đặt tiện ích mở rộng từ { $host }. Hãy chắc chắn rằng bạn tin tưởng trang web này trước khi tiếp tục.

##

xpinstall-prompt-header-unknown = Cho phép một trang không xác định cài đặt một tiện ích?
xpinstall-prompt-message-unknown = Bạn đang cố gắng cài đặt tiện ích từ một trang không xác định. Hãy chắc chắn rằng bạn tin tưởng trang này trước khi tiếp tục.

xpinstall-prompt-dont-allow =
    .label = Không cho phép
    .accesskey = D
xpinstall-prompt-never-allow =
    .label = Không bao giờ cho phép
    .accesskey = N
# Long text in this context make the dropdown menu extend awkwardly to the left,
# avoid a localization that's significantly longer than the English version.
xpinstall-prompt-never-allow-and-report =
    .label = Báo cáo trang web đáng ngờ
    .accesskey = R
# Accessibility Note:
# Be sure you do not choose an accesskey that is used elsewhere in the active context (e.g. main menu bar, submenu of the warning popup button)
# See https://website-archive.mozilla.org/www.mozilla.org/access/access/keyboard/ for details
xpinstall-prompt-install =
    .label = Tiếp tục cài đặt
    .accesskey = C

# These messages are shown when a website invokes navigator.requestMIDIAccess.

site-permission-install-first-prompt-midi-header = Trang web này đang yêu cầu quyền truy cập vào các thiết bị MIDI (Giao diện kỹ thuật số dành cho nhạc cụ) của bạn. Có thể bật quyền truy cập thiết bị bằng cách cài đặt tiện ích mở rộng.
site-permission-install-first-prompt-midi-message = Lần truy cập này không được đảm bảo an toàn. Chỉ tiếp tục nếu bạn tin tưởng trang web này.

##

xpinstall-disabled-locked = Quản trị hệ thống của bạn đã vô hiệu hóa cài đặt phần mềm.
xpinstall-disabled = Hiện tại việc cài đặt phần mềm đã bị vô hiệu hóa. Hãy nhấn Bật rồi thử lại.
xpinstall-disabled-button =
    .label = Kích hoạt
    .accesskey = n

# This message is shown when the installation of an add-on is blocked by enterprise policy.
# Variables:
#   $addonName (String): the name of the add-on.
#   $addonId (String): the ID of add-on.
addon-install-blocked-by-policy = { $addonName } ({ $addonId }) bị chặn bởi quản trị viên hệ thống của bạn.
# This message is shown when the installation of add-ons from a domain is blocked by enterprise policy.
addon-domain-blocked-by-policy = Quản trị viên hệ thống của bạn đã ngăn trang web này yêu cầu bạn cài đặt phần mềm trên máy tính của bạn.
addon-install-full-screen-blocked = Cài đặt tiện ích không được phép trong khi ở hoặc trước khi vào chế độ toàn màn hình.

# Variables:
#   $addonName (String): the localized name of the sideloaded add-on.
webext-perms-sideload-menu-item = { $addonName } đã thêm vào { -brand-short-name }
# Variables:
#   $addonName (String): the localized name of the extension which has been updated.
webext-perms-update-menu-item = { $addonName } yêu cầu quyền mới

# This message is shown when one or more extensions have been imported from a
# different browser into Waterfox, and the user needs to complete the import to
# start these extensions. This message is shown in the appmenu.
webext-imported-addons = Hoàn tất cài đặt tiện ích mở rộng được nhập vào { -brand-short-name }

## Add-on removal warning

# Variables:
#  $name (String): The name of the add-on that will be removed.
addon-removal-title = Xóa { $name }?
# Variables:
#   $name (String): the name of the extension which is about to be removed.
addon-removal-message = Gỡ bỏ { $name } từ { -brand-shorter-name }?
addon-removal-button = Xóa
addon-removal-abuse-report-checkbox = Báo cáo tiện ích mở rộng này cho { -vendor-short-name }

# Variables:
#   $addonCount (Number): the number of add-ons being downloaded
addon-downloading-and-verifying = Đang tải và xác thực { $addonCount } tiện ích…
addon-download-verifying = Đang xác thực

addon-install-cancel-button =
    .label = Hủy bỏ
    .accesskey = C
addon-install-accept-button =
    .label = Thêm
    .accesskey = A

## Variables:
##   $addonCount (Number): the number of add-ons being installed

addon-confirm-install-message = Trang này muốn cài đặt { $addonCount } tiện ích vào { -brand-short-name }:
addon-confirm-install-unsigned-message = Chú ý: Trang này muốn cài đặt { $addonCount } tiện ích chưa được kiểm định vào { -brand-short-name }. Chúng tôi không chịu trách nhiệm về những vấn đề có thể xảy ra.
# Variables:
#   $addonCount (Number): the number of add-ons being installed (at least 2)
addon-confirm-install-some-unsigned-message = Chú ý: Trang này muốn cài đặt { $addonCount } tiện ích vào { -brand-short-name }, một số trong đó chưa được kiểm định. Chúng tôi không chịu trách nhiệm về những vấn đề có thể xảy ra.

## Add-on install errors
## Variables:
##   $addonName (String): the add-on name.

addon-install-error-network-failure = Không thể tải tiện ích do bị lỗi kết nối.
addon-install-error-incorrect-hash = Không thể cài đặt tiện ích này vì nó không khớp với tiện ích { -brand-short-name } được trông đợi.
addon-install-error-corrupt-file = Không thể cài đặt tiện ích được tải từ trang này do có vẻ nó bị hỏng trên đường truyền.
addon-install-error-file-access = { $addonName } không thể cài đặt vì { -brand-short-name } không thể sửa đổi tập tin cần thiết.
addon-install-error-not-signed = { -brand-short-name } không cho phép trang này cài đặt một tiện ích chưa được kiểm định.
addon-install-error-invalid-domain = Không thể cài đặt tiện ích { $addonName } từ địa chỉ này.
addon-local-install-error-network-failure = Không thể cài đặt tiện ích này vì có lỗi hệ thống tập tin.
addon-local-install-error-incorrect-hash = Không thể cài đặt tiện ích này vì nó không khớp với tiện ích { -brand-short-name } được trông đợi.
addon-local-install-error-corrupt-file = Không thể cài đặt tiện ích này vì có vẻ như nó đã bị hỏng trên đường truyền.
addon-local-install-error-file-access = { $addonName } không thể cài đặt vì { -brand-short-name } không thể sửa đổi tập tin cần thiết.
addon-local-install-error-not-signed = Không thể cài đặt tiện ích này vì nó chưa được kiểm định.
# Variables:
#   $appVersion (String): the application version.
addon-install-error-incompatible = { $addonName } không thể cài đặt được vì nó không tương thích với { -brand-short-name } { $appVersion }.
addon-install-error-blocklisted = { $addonName } không thể cài đặt được vì nó có khả năng gây ra các vấn đề về bảo mật và tính ổn định.
