# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Headers used in the webextension permissions dialog,
## See https://bug1308309.bmoattachments.org/attachment.cgi?id=8814612
## for an example of the full dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension.

webext-perms-header = Thêm { $extension }?
webext-perms-header-with-perms = Thêm { $extension }? Tiện ích mở rộng này sẽ có quyền:
webext-perms-header-unsigned = Thêm { $extension }? Tiện ích mở rộng này chưa được xác minh. Các tiện ích mở rộng độc hại có thể lấy cắp thông tin cá nhân của bạn hoặc xâm phạm máy tính của bạn. Chỉ thêm nó nếu bạn tin tưởng.
webext-perms-header-unsigned-with-perms = Thêm { $extension }? Tiện ích mở rộng này chưa được xác minh. Các tiện ích mở rộng độc hại có thể lấy cắp thông tin cá nhân của bạn hoặc xâm phạm máy tính của bạn. Chỉ thêm nó nếu bạn tin tưởng. Tiện ích mở rộng này sẽ có quyền:
webext-perms-sideload-header = { $extension } được thêm vào
webext-perms-optional-perms-header = { $extension } yêu cầu thêm các quyền.

##

webext-perms-add =
    .label = Thêm
    .accesskey = A
webext-perms-cancel =
    .label = Hủy bỏ
    .accesskey = C

webext-perms-sideload-text = Một chương trình khác trong máy tính của bạn đã cài đặt một tiện ích mà có thể gây ảnh hưởng đến trình duyệt của bạn. Vui lòng xem lại những quyền hạn mà tiện ích này yêu cầu và chọn kích hoạt hoặc hủy bỏ (để nó bị vô hiệu hóa).
webext-perms-sideload-text-no-perms = Một chương trình khác trong máy tính của bạn đã cài đặt một tiện ích mà có thể gây ảnh hưởng đến trình duyệt của bạn. Vui lòng chọn kích hoạt hoặc hủy bỏ (để nó bị vô hiệu hóa).
webext-perms-sideload-enable =
    .label = Kích hoạt
    .accesskey = E
webext-perms-sideload-cancel =
    .label = Hủy bỏ
    .accesskey = C

# Variables:
#   $extension (String): replaced with the localized name of the extension.
webext-perms-update-text = { $extension } đã được cập nhật. Bạn phải phê duyệt các quyền mới trước khi phiên bản cập nhật sẽ cài đặt. Chọn “Hủy bỏ” sẽ duy trì phiên bản tiện ích mở rộng hiện tại của bạn. Tiện ích mở rộng này sẽ có quyền:
webext-perms-update-accept =
    .label = Cập nhật
    .accesskey = U

webext-perms-optional-perms-list-intro = Tiện ích này muốn:
webext-perms-optional-perms-allow =
    .label = Cho phép
    .accesskey = A
webext-perms-optional-perms-deny =
    .label = Từ chối
    .accesskey = D

webext-perms-host-description-all-urls = Truy cập dữ liệu của bạn trên mọi trang web

# Variables:
#   $domain (String): will be replaced by the DNS domain for which a webextension is requesting access (e.g., mozilla.org)
webext-perms-host-description-wildcard = Truy cập dữ liệu của bạn trên trang { $domain }

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-wildcards = Truy cập dữ liệu của bạn trong { $domainCount } tên miền khác
# Variables:
#   $domain (String): will be replaced by the DNS host name for which a webextension is requesting access (e.g., www.mozilla.org)
webext-perms-host-description-one-site = Truy cập dữ liệu của bạn từ { $domain }

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-sites = Truy cập dữ liệu của bạn trên { $domainCount } trang khác

## Headers used in the webextension permissions dialog for synthetic add-ons.
## The part of the string describing what privileges the extension gives should be consistent
## with the value of webext-site-perms-description-gated-perms-{sitePermission}.
## Note, this string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $hostname (String): the hostname of the site the add-on is being installed from.

webext-site-perms-header-with-gated-perms-midi = Tiện ích mở rộng này cung cấp { $hostname } quyền truy cập vào các thiết bị MIDI của bạn.
webext-site-perms-header-with-gated-perms-midi-sysex = Tiện ích mở rộng này cung cấp { $hostname } quyền truy cập vào các thiết bị MIDI của bạn (với hỗ trợ SysEx).

##

# This string is used as description in the webextension permissions dialog for synthetic add-ons.
# Note, the empty line is used to create a line break between the two sections.
# Note, this string will be used as raw markup. Avoid characters like <, >, &
webext-site-perms-description-gated-perms-midi =
    Đây thường là các thiết bị bổ trợ như bộ tổng hợp âm thanh, nhưng cũng có thể được tích hợp vào máy tính của bạn.
    
    Các trang web thường không được phép truy cập vào thiết bị MIDI. Việc sử dụng không đúng cách có thể gây hư hỏng hoặc ảnh hưởng đến bảo mật.

## Headers used in the webextension permissions dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension being installed.
##   $hostname (String): will be replaced by the DNS host name for which a webextension enables permissions.

webext-site-perms-header-with-perms = Thêm { $extension }? Tiện ích mở rộng này cấp các khả năng sau cho { $hostname }:
webext-site-perms-header-unsigned-with-perms = Thêm { $extension }? Tiện ích mở rộng này chưa được xác minh. Tiện ích mở rộng độc hại có thể lấy cắp thông tin cá nhân của bạn hoặc xâm phạm máy tính của bạn. Chỉ thêm nó nếu bạn tin tưởng. Tiện ích mở rộng này cấp các khả năng sau cho { $hostname }:

## These should remain in sync with permissions.NAME.label in sitePermissions.properties

webext-site-perms-midi = Truy cập thiết bị MIDI
webext-site-perms-midi-sysex = Truy cập thiết bị MIDI với hỗ trợ SysEx
