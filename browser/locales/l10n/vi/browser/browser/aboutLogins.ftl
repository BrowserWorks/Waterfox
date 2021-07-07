# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Thông tin đăng nhập & mật khẩu
login-filter =
    .placeholder = Tìm kiếm thông tin đăng nhập
create-login-button = Tạo thông tin đăng nhập mới
fxaccounts-sign-in-text = Nhận mật khẩu của bạn trên các thiết bị khác của bạn
fxaccounts-sign-in-sync-button = Đăng nhập vào đồng bộ hóa
fxaccounts-avatar-button =
    .title = Quản lý tài khoản

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Mở menu
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Nhập dữ liệu từ trình duyệt khác…
about-logins-menu-menuitem-import-from-a-file = Nhập từ tập tin…
about-logins-menu-menuitem-export-logins = Xuất thông tin đăng nhập…
about-logins-menu-menuitem-remove-all-logins = Xóa tất cả thông tin đăng nhập…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Tùy chọn
       *[other] Tùy chỉnh
    }
about-logins-menu-menuitem-help = Trợ giúp

## Login List

login-list =
    .aria-label = Thông tin đăng nhập phù hợp với truy vấn tìm kiếm
login-list-count =
    { $count ->
       *[other] { $count } thông tin đăng nhập
    }
login-list-sort-label-text = Sắp xếp theo:
login-list-name-option = Tên (A-Z)
login-list-name-reverse-option = Tên (Z-A)
login-list-username-option = Tên người dùng (A-Z)
login-list-username-reverse-option = Tên người dùng (Z-A)
about-logins-login-list-alerts-option = Cảnh báo
login-list-last-changed-option = Sửa đổi lần cuối
login-list-last-used-option = Sử dụng lần cuối
login-list-intro-title = Không tìm thấy thông tin đăng nhập
login-list-intro-description = Khi bạn lưu mật khẩu trong { -brand-product-name }, nó sẽ hiển thị ở đây.
about-logins-login-list-empty-search-title = Không tìm thấy thông tin đăng nhập
about-logins-login-list-empty-search-description = Không có kết quả phù hợp với tìm kiếm của bạn.
login-list-item-title-new-login = Đăng nhập mới
login-list-item-subtitle-new-login = Nhập thông tin đăng nhập của bạn
login-list-item-subtitle-missing-username = (không có tên người dùng)
about-logins-list-item-breach-icon =
    .title = Trang web bị rò rỉ
about-logins-list-item-vulnerable-password-icon =
    .title = Mật khẩu dễ bị tấn công
about-logins-list-section-breach = Trang web bị rò rỉ
about-logins-list-section-vulnerable = Mật khẩu dễ bị tấn công
about-logins-list-section-nothing = Không có cảnh báo
about-logins-list-section-today = Hôm nay
about-logins-list-section-yesterday = Hôm qua
about-logins-list-section-week = 7 ngày trước

## Introduction screen

about-logins-login-intro-heading-logged-out2 = Tìm kiếm thông tin đăng nhập đã lưu của bạn? Bật đồng bộ hóa hoặc nhập chúng.
about-logins-login-intro-heading-logged-in = Không tìm thấy thông tin đăng nhập được đồng bộ hóa.
login-intro-description = Nếu bạn đã lưu thông tin đăng nhập của mình vào { -brand-product-name } trên một thiết bị khác, thì đây là cách để có được chúng ở đây:
login-intro-instructions-fxa = Tạo hoặc đăng nhập vào { -fxaccount-brand-name } của bạn trên thiết bị lưu thông tin đăng nhập của bạn.
login-intro-instructions-fxa-settings = Đi đến Cài đặt > Đồng bộ hóa > Bật đồng bộ hóa… Chọn hộp kiểm Thông tin đăng nhập và mật khẩu.
login-intro-instructions-fxa-help = Truy cập <a data-l10n-name="help-link">hỗ trợ của { -lockwise-brand-short-name }</a> để được trợ giúp.
about-logins-intro-import = Nếu thông tin đăng nhập của bạn được lưu trong một trình duyệt khác, bạn có thể <a data-l10n-name="import-link">nhập chúng vào { -lockwise-brand-short-name }</a>
about-logins-intro-import2 = Nếu thông tin đăng nhập của bạn được lưu bên ngoài { -brand-product-name }, bạn có thể <a data-l10n-name="import-browser-link">nhập chúng từ trình duyệt khác</a> hoặc <a data-l10n-name="import-file-link">từ một tập tin</a>

## Login

login-item-new-login-title = Tạo thông tin đăng nhập mới
login-item-edit-button = Chỉnh sửa
about-logins-login-item-remove-button = Xóa
login-item-origin-label = Địa chỉ trang web
login-item-tooltip-message = Đảm bảo rằng địa chỉ này khớp với địa chỉ chính xác của trang web mà bạn đăng nhập.
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Tên đăng nhập
about-logins-login-item-username =
    .placeholder = (không có tên người dùng)
login-item-copy-username-button-text = Sao chép
login-item-copied-username-button-text = Đã sao chép!
login-item-password-label = Mật khẩu
login-item-password-reveal-checkbox =
    .aria-label = Hiện mật khẩu
login-item-copy-password-button-text = Sao chép
login-item-copied-password-button-text = Đã sao chép!
login-item-save-changes-button = Lưu thay đổi
login-item-save-new-button = Lưu
login-item-cancel-button = Hủy bỏ
login-item-time-changed = Sửa đổi lần cuối: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Được tạo: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Lần sử dụng cuối: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Waterfox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Để chỉnh sửa thông tin đăng nhập của bạn, hãy nhập thông tin đăng nhập Windows của bạn. Điều này giúp bảo vệ tính bảo mật của tài khoản của bạn.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = chỉnh sửa thông tin đăng nhập đã lưu
# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Để xem mật khẩu của bạn, nhập thông tin đăng nhập Windows của bạn. Điều này giúp bảo vệ tính bảo mật của tài khoản của bạn.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = hiển thị mật khẩu đã lưu
# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Để sao chép mật khẩu của bạn, hãy nhập thông tin đăng nhập Windows của bạn. Điều này giúp bảo vệ tính bảo mật của tài khoản của bạn.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = sao chép mật khẩu đã lưu
# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Để xuất ra thông tin đăng nhập của bạn, hãy nhập thông tin đăng nhập Windows của bạn. Điều này giúp bảo mật tài khoản của bạn.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = xuất thông tin đăng nhập và mật khẩu

## Primary Password notification

about-logins-primary-password-notification-message = Vui lòng nhập mật khẩu chính của bạn để xem thông tin đăng nhập và mật khẩu đã lưu
master-password-reload-button =
    .label = Đăng nhập
    .accesskey = L

## Dialogs

confirmation-dialog-cancel-button = Hủy bỏ
confirmation-dialog-dismiss-button =
    .title = Hủy bỏ
about-logins-confirm-remove-dialog-title = Xoá thông tin đăng nhập này?
confirm-delete-dialog-message = Thao tác này không thể hoàn tác được.
about-logins-confirm-remove-dialog-confirm-button = Xóa
about-logins-confirm-remove-all-dialog-confirm-button-label =
    { $count ->
        [1] Xóa
       *[other] Xóa tất cả
    }
about-logins-confirm-remove-all-dialog-checkbox-label =
    { $count ->
        [1] Có, xóa thông tin đăng nhập này
       *[other] Có, xóa các thông tin đăng nhập này
    }
about-logins-confirm-remove-all-dialog-title =
    { $count ->
       *[other] Xóa tất cả { $count } thông tin đăng nhập?
    }
about-logins-confirm-remove-all-dialog-message =
    { $count ->
        [1] Thao tác này sẽ xóa thông tin đăng nhập bạn đã lưu vào { -brand-short-name } và mọi cảnh báo rò rỉ xuất hiện ở đây. Bạn sẽ không thể hoàn tác hành động này.
       *[other] Thao tác này sẽ xóa các thông tin đăng nhập bạn đã lưu vào { -brand-short-name } và mọi cảnh báo rò rỉ xuất hiện ở đây. Bạn sẽ không thể hoàn tác hành động này.
    }
about-logins-confirm-remove-all-sync-dialog-title =
    { $count ->
       *[other] Xóa tất cả { $count } thông tin đăng nhập khỏi tất cả các thiết bị?
    }
about-logins-confirm-remove-all-sync-dialog-message =
    { $count ->
        [1] Thao tác này sẽ xóa thông tin đăng nhập bạn đã lưu vào { -brand-short-name } trên tất cả các thiết bị được đồng bộ hóa với { -fxaccount-brand-name } của bạn. Thao tác này cũng sẽ xóa các cảnh báo rò rỉ xuất hiện ở đây. Bạn sẽ không thể hoàn tác hành động này.
       *[other] Thao tác này sẽ xóa tất cả các thông tin đăng nhập bạn đã lưu vào { -brand-short-name } trên tất cả các thiết bị được đồng bộ hóa với { -fxaccount-brand-name } của bạn. Thao tác này cũng sẽ xóa các cảnh báo rò rỉ xuất hiện ở đây. Bạn sẽ không thể hoàn tác hành động này.
    }
about-logins-confirm-export-dialog-title = Xuất thông tin đăng nhập và mật khẩu
about-logins-confirm-export-dialog-message = Mật khẩu của bạn sẽ được lưu dưới dạng văn bản có thể đọc được (ví dụ: BadP@ssw0rd) để bất kỳ ai có thể mở tập tin được xuất đều có thể xem chúng.
about-logins-confirm-export-dialog-confirm-button = Xuất…
about-logins-alert-import-title = Hoàn thành nhập
about-logins-alert-import-message = Xem tóm tắt chi tiết nhập
confirm-discard-changes-dialog-title = Hủy bỏ những thay đổi chưa lưu?
confirm-discard-changes-dialog-message = Tất cả các thay đổi chưa được lưu sẽ bị mất.
confirm-discard-changes-dialog-confirm-button = Loại bỏ

## Breach Alert notification

about-logins-breach-alert-title = Trang web rò rỉ dữ liệu
breach-alert-text = Mật khẩu đã bị rò rỉ hoặc đánh cắp từ trang web này kể từ lần cuối bạn cập nhật thông tin đăng nhập. Thay đổi mật khẩu của bạn để bảo vệ tài khoản của bạn.
about-logins-breach-alert-date = Rò rỉ này xảy ra vào { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Đi đến { $hostname }
about-logins-breach-alert-learn-more-link = Tìm hiểu thêm

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Mật khẩu dễ bị tấn công
about-logins-vulnerable-alert-text2 = Mật khẩu này đã được sử dụng trên một tài khoản khác có khả năng bị rò rỉ dữ liệu. Việc sử dụng lại thông tin đăng nhập sẽ khiến tất cả các tài khoản của bạn gặp rủi ro. Thay đổi mật khẩu này.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Đi đến { $hostname }
about-logins-vulnerable-alert-learn-more-link = Tìm hiểu thêm

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Một mục nhập cho { $loginTitle } với tên người dùng đã tồn tại. <a data-l10n-name="duplicate-link">Chuyển đến giá trị hiện có?</a>
# This is a generic error message.
about-logins-error-message-default = Đã xảy ra lỗi trong khi cố gắng lưu mật khẩu này.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Xuất tập tin đăng nhập
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Xuất
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Tài liệu CSV
       *[other] Tập tin CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Nhập tập tin đăng nhập
about-logins-import-file-picker-import-button = Nhập
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Tài liệu CSV
       *[other] Tập tin CSV
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
about-logins-import-file-picker-tsv-filter-title =
    { PLATFORM() ->
        [macos] Tài liệu TSV
       *[other] Tập tin TSV
    }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-dialog-title = Hoàn thành nhập
about-logins-import-dialog-items-added =
    { $count ->
       *[other] <span>Đã thêm thông tin đăng nhập mới:</span> <span data-l10n-name="count">{ $count }</span>
    }
about-logins-import-dialog-items-modified =
    { $count ->
       *[other] <span>Đã cập nhật thông tin đăng nhập đã có:</span> <span data-l10n-name="count">{ $count }</span>
    }
about-logins-import-dialog-items-no-change =
    { $count ->
       *[other] <span>Tìm thấy thông tin đăng nhập bị trùng:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(không nhập)</span>
    }
about-logins-import-dialog-items-error =
    { $count ->
       *[other] <span>Lỗi:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(không nhập)</span>
    }
about-logins-import-dialog-done = Xong
about-logins-import-dialog-error-title = Lỗi khi nhập
about-logins-import-dialog-error-conflicting-values-title = Nhiều giá trị xung đột cho một thông tin đăng nhập
about-logins-import-dialog-error-conflicting-values-description = Ví dụ: nhiều tên người dùng, mật khẩu, URL, v.v. cho một thông tin đăng nhập.
about-logins-import-dialog-error-file-format-title = Vấn đề định dạng tập tin
about-logins-import-dialog-error-file-format-description = Header cột không chính xác hoặc bị thiếu. Đảm bảo rằng tập tin bao gồm các cột cho tên người dùng, mật khẩu và URL.
about-logins-import-dialog-error-file-permission-title = Không thể đọc tập tin
about-logins-import-dialog-error-file-permission-description = { -brand-short-name } không có quyền đọc tập tin. Thử thay đổi quyền đối với tập tin.
about-logins-import-dialog-error-unable-to-read-title = Không thể phân tích cú pháp tập tin
about-logins-import-dialog-error-unable-to-read-description = Đảm bảo rằng bạn đã chọn đúng tập tin CSV hoặc TSV.
about-logins-import-dialog-error-no-logins-imported = Không có thông tin đăng nhập nào được nhập
about-logins-import-dialog-error-learn-more = Tìm hiểu thêm
about-logins-import-dialog-error-try-import-again = Thử nhập lần nữa...
about-logins-import-dialog-error-cancel = Hủy bỏ
about-logins-import-report-title = Tóm tắt nhập
about-logins-import-report-description = Thông tin đăng nhập và mật khẩu được nhập vào { -brand-short-name }.
#
# Variables:
#  $number (number) - The number of the row
about-logins-import-report-row-index = Hàng { $number }
about-logins-import-report-row-description-no-change = Trùng lặp: Đối sánh chính xác thông tin đăng nhập hiện có
about-logins-import-report-row-description-modified = Thông tin đăng nhập hiện tại đã được cập nhật
about-logins-import-report-row-description-added = Đã thêm thông tin đăng nhập mới
about-logins-import-report-row-description-error = Lỗi: Thiếu trường

##
## Variables:
##  $field (String) - The name of the field from the CSV file for example url, username or password

about-logins-import-report-row-description-error-multiple-values = Lỗi: Nhiều giá trị cho { $field }
about-logins-import-report-row-description-error-missing-field = Lỗi: Thiếu { $field }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-report-added =
    { $count ->
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">thông tin đăng nhập mới được thêm vào</div>
    }
about-logins-import-report-modified =
    { $count ->
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">thông tin đăng nhập hiện tại đã được cập nhật</div>
    }
about-logins-import-report-no-change =
    { $count ->
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">thông tin đăng nhập trùng lặp</div> <div data-l10n-name="not-imported">(không nhập)</div>
    }
about-logins-import-report-error =
    { $count ->
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">lỗi</div> <div data-l10n-name="not-imported">(không nhập)</div>
    }

## Logins import report page

about-logins-import-report-page-title = Báo cáo tóm tắt nhập
