# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webext-perms-learn-more = Tìm hiểu thêm
# Variables:
#   $addonName (String): localized named of the extension that is asking to change the default search engine.
#   $currentEngine (String): name of the current search engine.
#   $newEngine (String): name of the new search engine.
webext-default-search-description = { $addonName } muốn thay đổi công cụ tìm kiếm mặc định của bạn từ { $currentEngine } đến { $newEngine }. Bạn đồng ý chứ?
webext-default-search-yes =
    .label = Có
    .accesskey = Y
webext-default-search-no =
    .label = Không
    .accesskey = N
# Variables:
#   $addonName (String): localized named of the extension that was just installed.
addon-post-install-message = Đã thêm { $addonName }.

## A modal confirmation dialog to allow an extension on quarantined domains.

# Variables:
#   $addonName (String): localized name of the extension.
webext-quarantine-confirmation-title = Chạy { $addonName } trên trang bị hạn chế?
webext-quarantine-confirmation-line-1 = Để bảo vệ dữ liệu của bạn, tiện ích mở rộng này không được phép trên trang web này.
webext-quarantine-confirmation-line-2 = Chỉ cho phép tiện ích mở rộng này nếu bạn tin tưởng nó sẽ đọc và thay đổi dữ liệu của bạn trên các trang web bị hạn chế bởi { -vendor-short-name }.
webext-quarantine-confirmation-allow =
    .label = Cho phép
    .accesskey = A
webext-quarantine-confirmation-deny =
    .label = Không cho phép
    .accesskey = D
