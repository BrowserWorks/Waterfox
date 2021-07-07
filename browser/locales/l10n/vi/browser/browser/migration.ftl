# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Trình nhập dữ liệu

import-from =
    { PLATFORM() ->
        [windows] Nhập các tùy chọn, dấu trang, lịch sử, mật khẩu và các dữ liệu khác từ:
       *[other] Nhập các tùy chỉnh, dấu trang, lịch sử, mật khẩu và các dữ liệu khác từ:
    }

import-from-bookmarks = Nhập các dấu trang từ:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = I
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge cũ
    .accesskey = L
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = Không nhập gì cả
    .accesskey = h
import-from-safari =
    .label = Safari
    .accesskey = S
import-from-canary =
    .label = Chrome Canary
    .accesskey = n
import-from-chrome =
    .label = Chrome
    .accesskey = C
import-from-chrome-beta =
    .label = Chrome Beta
    .accesskey = B
import-from-chrome-dev =
    .label = Chrome Dev
    .accesskey = D
import-from-chromium =
    .label = Chromium
    .accesskey = u
import-from-firefox =
    .label = Waterfox
    .accesskey = x
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3

no-migration-sources = Không tìm thấy chương trình nào chứa dấu trang, lịch sử, hoặc dữ liệu mật khẩu.

import-source-page-title = Nhập cài đặt và dữ liệu
import-items-page-title = Các mục cần nhập

import-items-description = Chọn các mục để nhập:

import-permissions-page-title = Vui lòng cấp quyền cho { -brand-short-name }

# Do not translate "Bookmarks.plist"; the file name is the same everywhere.
import-permissions-description = macOS yêu cầu bạn cho phép { -brand-short-name } truy cập vào các trang đánh dấu của Safari. Nhấp vào “Tiếp tục” và chọn tệp “Bookmarks.plist” trong bảng Mở tệp.

import-migrating-page-title = Đang nhập…

import-migrating-description = Các mục sau đang được nhập…

import-select-profile-page-title = Chọn hồ sơ

import-select-profile-description = Các hồ sơ có thể nhập được từ:

import-done-page-title = Nhập Xong

import-done-description = Các mục sau đã được nhập thành công:

import-close-source-browser = Vui lòng chắc chắn trình duyệt được chọn đã đóng truớc khi tiếp tục.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Từ { $source }

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-edge-beta = Microsoft Edge Beta
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chrome-beta = Google Chrome Beta
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Waterfox
source-name-360se = 360 Secure Browser

imported-safari-reading-list = Đang đọc danh sách (Từ Safari)
imported-edge-reading-list = Đang đọc danh sách (từ Edge)

## Browser data types
## All of these strings get a $browser variable passed in.
## You can use the browser variable to differentiate the name of items,
## which may have different labels in different browsers.
## The supported values for the $browser variable are:
## 360se
## chrome
## edge
## firefox
## ie
## safari
## The various beta and development versions of edge and chrome all get
## normalized to just "edge" and "chrome" for these strings.

browser-data-cookies-checkbox =
    .label = Cookie
browser-data-cookies-label =
    .value = Cookie

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Lịch sử duyệt web và trang đánh dấu
           *[other] Lịch sử duyệt web
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Lịch sử duyệt web và trang đánh dấu
           *[other] Lịch sử duyệt web
        }

browser-data-formdata-checkbox =
    .label = Lịch sử biểu mẫu đã lưu
browser-data-formdata-label =
    .value = Lịch sử biểu mẫu đã lưu

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Thông tin đăng nhập và mật khẩu đã lưu
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Thông tin đăng nhập và mật khẩu đã lưu

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Yêu thích
            [edge] Yêu thích
           *[other] Dấu trang
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Yêu thích
            [edge] Yêu thích
           *[other] Dấu trang
        }

browser-data-otherdata-checkbox =
    .label = Dữ liệu khác
browser-data-otherdata-label =
    .label = Dữ liệu khác

browser-data-session-checkbox =
    .label = Cửa Sổ và Thẻ
browser-data-session-label =
    .value = Cửa Sổ và Thẻ
