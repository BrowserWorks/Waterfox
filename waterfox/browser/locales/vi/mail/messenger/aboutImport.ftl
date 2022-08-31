# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

import-page-title = Nhập
export-page-title = Xuất

## Header

import-start = Công cụ nhập
import-start-title = Nhập cài đặt hoặc dữ liệu từ ứng dụng hoặc tập tin.
import-start-description = Chọn nguồn mà bạn muốn nhập. Sau đó, bạn sẽ được yêu cầu chọn dữ liệu nào cần được nhập.
import-from-app = Nhập từ ứng dụng
import-file = Nhập từ một tập tin
import-file-title = Chọn một tập tin để nhập nội dung của nó.
import-file-description = Chọn để nhập hồ sơ, sổ địa chỉ hoặc lịch đã sao lưu trước đó.
import-address-book-title = Nhập tập tin sổ địa chỉ
import-calendar-title = Nhập tập tin lịch
export-profile = Xuất

## Buttons

button-back = Quay lại
button-continue = Tiếp tục
button-export = Xuất
button-finish = Hoàn thành

## Import from app steps

app-name-thunderbird = Thunderbird
app-name-seamonkey = SeaMonkey
app-name-outlook = Outlook
app-name-becky = Becky! Internet Mail
app-name-apple-mail = Apple Mail
source-thunderbird = Nhập từ cài đặt khác của { app-name-thunderbird }
source-thunderbird-description = Nhập cài đặt, bộ lọc, thư và dữ liệu khác từ hồ sơ { app-name-thunderbird }.
source-seamonkey = Nhập từ cài đặt { app-name-seamonkey }
source-seamonkey-description = Nhập cài đặt, bộ lọc, thư và dữ liệu khác từ hồ sơ { app-name-seamonkey }.
source-outlook = Nhập từ { app-name-outlook }
source-outlook-description = Nhập tài khoản, sổ địa chỉ và thư từ { app-name-outlook }.
source-becky = Nhập từ { app-name-becky }
source-becky-description = Nhập sổ địa chỉ và thư từ { app-name-becky }.
source-apple-mail = Nhập từ { app-name-apple-mail }
source-apple-mail-description = Nhập thư từ { app-name-apple-mail }.
source-file2 = Nhập từ một tập tin
source-file-description = Chọn một tập tin để nhập sổ địa chỉ, lịch hoặc sao lưu hồ sơ (tập tin ZIP).

## Import from file selections

file-profile2 = Nhập hồ sơ sao lưu
file-profile-description = Chọn một hồ sơ Thunderbird đã sao lưu trước đó
file-calendar = Nhập lịch
file-calendar-description = Chọn tập tin chứa lịch hoặc sự kiện đã xuất (.ics)
file-addressbook = Nhập sổ địa chỉ
file-addressbook-description = Chọn một tập tin chứa các sổ địa chỉ và danh sách liên hệ đã xuất

## Import from app profile steps

from-app-thunderbird = Nhập từ hồ sơ { app-name-thunderbird }
from-app-seamonkey = Nhập từ hồ sơ { app-name-seamonkey }
from-app-outlook = Nhập từ { app-name-outlook }
from-app-becky = Nhập từ { app-name-becky }
from-app-apple-mail = Nhập từ { app-name-apple-mail }
profiles-pane-title-thunderbird = Nhập cài đặt và dữ liệu từ hồ sơ { app-name-thunderbird }.
profiles-pane-title-seamonkey = Nhập cài đặt và dữ liệu từ hồ sơ { app-name-seamonkey }.
profiles-pane-title-outlook = Nhập dữ liệu từ { app-name-outlook }.
profiles-pane-title-becky = Nhập dữ liệu từ { app-name-becky }.
profiles-pane-title-apple-mail = Nhập thư từ { app-name-apple-mail }.
profile-source = Nhập từ hồ sơ
# $profileName (string) - name of the profile
profile-source-named = Nhập từ hồ sơ <strong>"{ $profileName }"</strong>
profile-file-picker-directory = Chọn một thư mục hồ sơ
profile-file-picker-archive = Chọn một tập tin <strong>ZIP</strong>
profile-file-picker-archive-description = Tập tin ZIP phải nhỏ hơn 2GB.
profile-file-picker-archive-title = Chọn một tập tin ZIP (nhỏ hơn 2GB)
items-pane-title2 = Chọn những gì để nhập:
items-pane-directory = Thư mục:
items-pane-profile-name = Tên hồ sơ:
items-pane-checkbox-accounts = Tài khoản và cài đặt
items-pane-checkbox-address-books = Sổ địa chỉ
items-pane-checkbox-calendars = Lịch
items-pane-checkbox-mail-messages = Thư
items-pane-override = Mọi dữ liệu hiện có hoặc giống hệt nhau sẽ không bị ghi đè.

## Import from address book file steps

import-from-addr-book-file-description = Chọn định dạng tập tin chứa dữ liệu sổ địa chỉ của bạn.
addr-book-csv-file = Tệp được phân tách bằng dấu phẩy hoặc tab (.csv, .tsv)
addr-book-ldif-file = Tập tin LDIF (.ldif)
addr-book-vcard-file = Tập tin vCard (.vcf, .vcard)
addr-book-sqlite-file = Tập tin cơ sở dữ liệu SQLite (.sqlite)
addr-book-mab-file = Tập tin cơ sở dữ liệu Mork (.mab)
addr-book-file-picker = Chọn một tập tin sổ địa chỉ
addr-book-csv-field-map-title = Khớp tên trường
addr-book-csv-field-map-desc = Chọn các trường sổ địa chỉ tương ứng với các trường nguồn. Bỏ chọn các trường bạn không muốn nhập.
addr-book-directories-title = Chọn nơi để nhập dữ liệu đã chọn
addr-book-directories-pane-source = Tập tin nguồn:
# $addressBookName (string) - name of the new address book that would be created.
addr-book-import-into-new-directory2 = Tạo một thư mục mới có tên là <strong>"{ $addressBookName }"</strong>
# $addressBookName (string) - name of the address book to import into
addr-book-summary-title = Nhập dữ liệu đã chọn vào thư mục "{ $addressBookName }"
# $addressBookName (string) - name of the address book that will be created.
addr-book-summary-description = Sổ địa chỉ mới có tên "{ $addressBookName }" sẽ được tạo.

## Import from calendar file steps

import-from-calendar-file-desc = Chọn tập tin iCalendar (.ics) bạn muốn nhập.
calendar-items-title = Chọn các mục để nhập.
calendar-items-loading = Đang tải các mục…
calendar-items-filter-input =
    .placeholder = Lọc các mục…
calendar-select-all-items = Chọn tất cả
calendar-deselect-all-items = Bỏ chọn tất cả
calendar-target-title = Chọn nơi để nhập các mục đã chọn.
# $targetCalendar (string) - name of the new calendar that would be created
calendar-import-into-new-calendar2 = Tạo lịch mới có tên <strong>"{ $targetCalendar }"</strong>
# $itemCount (number) - count of selected items (tasks, events) that will be imported
# $targetCalendar (string) - name of the calendar the items will be imported into
calendar-summary-title =
    { $itemCount ->
       *[other] Nhập { $itemCount } mục vào lịch "{ $targetCalendar }"
    }
# $targetCalendar (string) - name of the calendar that will be created
calendar-summary-description = Lịch mới có tên "{ $targetCalendar }" sẽ được tạo.

## Import dialog

# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-importing2 = Đang nhập… { $progressPercent }
# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-exporting2 = Đang xuất… { $progressPercent }
progress-pane-finished-desc2 = Hoàn tất.
error-pane-title = Lỗi
error-message-zip-file-too-big2 = Tập tin ZIP đã chọn lớn hơn 2GB. Vui lòng giải nén nó trước, sau đó nhập từ thư mục đã giải nén.
error-message-extract-zip-file-failed2 = Không giải nén được tập tin ZIP. Vui lòng giải nén nó theo cách thủ công, sau đó nhập từ thư mục đã giải nén để thay thế.
error-message-failed = Nhập không thành công đột ngột, có thể xem thêm thông tin trong bảng điều khiển.
error-failed-to-parse-ics-file = Không tìm thấy mục có thể nhập trong tập tin.
error-export-failed = Đã xảy ra lỗi không mong muốn khi xuất, có thể xem thêm thông tin trong bảng điều khiển lỗi.
error-message-no-profile = Không tìm thấy hồ sơ.

## <csv-field-map> element

csv-first-row-contains-headers = Hàng đầu tiên chứa tên trường
csv-source-field = Trường nguồn
csv-source-first-record = Bản ghi đầu tiên
csv-source-second-record = Bản ghi thứ hai
csv-target-field = Trường sổ địa chỉ

## Export tab

export-profile-title = Xuất tài khoản, thư, sổ địa chỉ và cài đặt sang tập tin ZIP.
export-profile-description = Nếu hồ sơ hiện tại của bạn lớn hơn 2GB, chúng tôi khuyên bạn nên tự sao lưu hồ sơ đó.
export-open-profile-folder = Mở thư mục hồ sơ
export-file-picker2 = Xuất sang tập tin ZIP
export-brand-name = { -brand-product-name }

## Summary pane

summary-pane-title = Dữ liệu sẽ được nhập
summary-pane-start = Bắt đầu nhập
summary-pane-warning = { -brand-product-name } sẽ cần được khởi động lại khi quá trình nhập hoàn tất.
summary-pane-start-over = Khởi động lại công cụ nhập

## Footer area

footer-help = Cần trợ giúp?
footer-import-documentation = Nhập tài liệu
footer-export-documentation = Xuất tài liệu
footer-support-forum = Diễn đàn hỗ trợ

## Step navigation on top of the wizard pages

step-list =
    .aria-label = Các bước nhập
step-confirm = Xác nhận
# Variables:
# $number (number) - step number
step-count = { $number }
