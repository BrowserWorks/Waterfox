# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
       *[other] { -brand-short-name } đã chặn { $count } trình theo dõi trong tuần qua
    }
# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
       *[other] <b>{ $count }</b> trình theo dõi bị chặn kể từ { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }
# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } tiếp tục  chặn trình theo dõi trong cửa sổ riêng tư, nhưng không lưu giữ hồ sơ về những gì đã bị chặn.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Trình theo dõi mà { -brand-short-name } đã chặn trong tuần này
protection-report-webpage-title = Bảng điều khiển bảo vệ
protection-report-page-content-title = Bảng điều khiển bảo vệ
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } có thể bảo vệ quyền riêng tư của bạn đằng sau hậu trường trong khi bạn duyệt. Đây là bản tóm tắt được cá nhân hóa về các biện pháp bảo vệ đó, bao gồm các công cụ để kiểm soát an ninh trực tuyến của bạn.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } có thể bảo vệ quyền riêng tư của bạn đằng sau hậu trường trong khi bạn duyệt. Đây là bản tóm tắt được cá nhân hóa về các biện pháp bảo vệ đó, bao gồm các công cụ để kiểm soát an ninh trực tuyến của bạn.
protection-report-settings-link = Quản lý cài đặt bảo mật và quyền riêng tư của bạn
etp-card-title-always = Trình chống theo dõi nâng cao: Luôn bật
etp-card-title-custom-not-blocking = Trình chống theo dõi nâng cao: TẮT
etp-card-content-description = { -brand-short-name } tự động ngăn các công ty bí mật theo dõi bạn trên web.
protection-report-etp-card-content-custom-not-blocking = Tất cả các bảo vệ hiện đang tắt. Chọn trình theo dõi nào sẽ chặn bằng cách quản lý cài đặt bảo vệ { -brand-short-name } của bạn.
protection-report-manage-protections = Quản lý cài đặt
# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Hôm nay
# This string is used to describe the graph for screenreader users.
graph-legend-description = Một biểu đồ chứa tổng số lượng của từng loại trình theo dõi bị chặn trong tuần này.
social-tab-title = Trình theo dõi truyền thông xã hội
social-tab-contant = Mạng xã hội đặt trình theo dõi trên các trang web khác để theo dõi những gì bạn làm, xem và xem trực tuyến. Điều này cho phép các công ty truyền thông xã hội tìm hiểu thêm về bạn ngoài những gì bạn chia sẻ trên hồ sơ truyền thông xã hội của mình. <a data-l10n-name="learn-more-link">Tìm hiểu thêm</a>
cookie-tab-title = Cookie theo dõi trên nhiều trang web
cookie-tab-content = Những cookie này theo bạn từ trang này sang trang khác để thu thập dữ liệu về những gì bạn làm trực tuyến. Chúng được đặt bởi các bên thứ ba như nhà quảng cáo và công ty phân tích. Chặn cookie theo dõi nhiều trang web làm giảm số lượng quảng cáo theo bạn xung quanh. <a data-l10n-name="learn-more-link">Tìm hiểu thêm</a>
tracker-tab-title = Trình theo dõi nội dung
tracker-tab-description = Trang web có thể tải quảng cáo bên ngoài, video và nội dung khác với đoạn mã theo dõi. Chặn nội dung theo dõi có thể giúp các trang web tải nhanh hơn, nhưng một số nút, biểu mẫu và trường đăng nhập có thể không hoạt động. <a data-l10n-name="learn-more-link">Tìm hiểu thêm</a>
fingerprinter-tab-title = Dấu vết
fingerprinter-tab-content = Dấu vết thu thập cài đặt từ trình duyệt và máy tính của bạn để tạo hồ sơ về bạn. Sử dụng dấu vết kỹ thuật số này, họ có thể theo dõi bạn trên các trang web khác nhau. <a data-l10n-name="learn-more-link">Tìm hiểu thêm</a>
cryptominer-tab-title = Tiền điện tử
cryptominer-tab-content = Tiền điện tử sử dụng sức mạnh tính toán của hệ thống của bạn để khai thác tiền kỹ thuật số. Các tập lệnh mã hóa làm cạn kiệt pin của bạn, làm chậm máy tính của bạn và có thể tăng hóa đơn năng lượng của bạn. <a data-l10n-name="learn-more-link">Tìm hiểu thêm</a>
protections-close-button2 =
    .aria-label = Đóng
    .title = Đóng
mobile-app-title = Chặn trình theo dõi quảng cáo trên nhiều thiết bị hơn
mobile-app-card-content = Sử dụng trình duyệt di động có bảo vệ tích hợp chống theo dõi quảng cáo.
mobile-app-links = Trình duyệt { -brand-product-name } dành cho <a data-l10n-name="android-mobile-inline-link">Android</a> và <a data-l10n-name="ios-mobile-inline-link">iOS</a>
lockwise-title = Không bao giờ quên mật khẩu lần nữa
lockwise-title-logged-in2 = Quản lý mật khẩu
lockwise-header-content = { -lockwise-brand-name } lưu trữ an toàn mật khẩu của bạn trong trình duyệt của bạn.
lockwise-header-content-logged-in = Lưu trữ an toàn và đồng bộ hóa mật khẩu của bạn với tất cả các thiết bị của bạn.
protection-report-save-passwords-button = Lưu mật khẩu
    .title = Lưu mật khẩu trên { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Quản lý mật khẩu
    .title = Quản lý mật khẩu trên { -lockwise-brand-short-name }
lockwise-mobile-app-title = Mang mật khẩu của bạn đi khắp mọi nơi
lockwise-no-logins-card-content = Sử dụng mật khẩu được lưu trong { -brand-short-name } trên bất kỳ thiết bị nào.
lockwise-app-links = { -lockwise-brand-name } dành cho <a data-l10n-name="lockwise-android-inline-link">Android</a> và <a data-l10n-name="lockwise-ios-inline-link">iOS</a>
# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
       *[other] { $count } mật khẩu có thể đã bị lộ do rò rỉ dữ liệu.
    }
# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
       *[other] Mật khẩu của bạn đang được lưu trữ an toàn.
    }
lockwise-how-it-works-link = Nó hoạt động như thế nào
turn-on-sync = Bật { -sync-brand-short-name }…
    .title = Đi đến tùy chọn đồng bộ hóa
monitor-title = Xem các rò rỉ dữ liệu
monitor-link = Nó hoạt động như thế nào
monitor-header-content-no-account = Kiểm tra tại { -monitor-brand-name } để xem bạn có phải là một phần của rò rỉ dữ liệu hay không và nhận thông báo về các rò rỉ mới.
monitor-header-content-signed-in = { -monitor-brand-name } cảnh báo bạn nếu thông tin của bạn xuất hiện trong một vụ rò rỉ dữ liệu đã biết.
monitor-sign-up-link = Đăng ký cảnh báo vụ rò rỉ
    .title = Đăng ký cảnh báo vụ rò rỉ trên { -monitor-brand-name }
auto-scan = Tự động quét ngày hôm nay
monitor-emails-tooltip =
    .title = Xem địa chỉ email được giám sát trên { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Xem các rò rỉ dữ liệu đã biết trên { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Xem mật khẩu bị lộ trên { -monitor-brand-short-name }
# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
       *[other] Địa chỉ email đang được giám sát
    }
# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
       *[other] Rò rỉ dữ liệu đã biết đã tiết lộ thông tin của bạn
    }
# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
       *[other] Rò rỉ dữ liệu đã biết được đánh dấu là đã giải quyết
    }
# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
       *[other] Mật khẩu tiếp xúc trên tất cả các vụ rò rỉ
    }
# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
       *[other] Mật khẩu bị lộ trong các rò rỉ dữ liệu chưa được giải quyết
    }
monitor-no-breaches-title = Tin tốt!
monitor-no-breaches-description = Bạn không có vụ rò rỉ nào được biết đến. Nếu có, chúng tôi sẽ cho bạn biết.
monitor-view-report-link = Xem báo cáo
    .title = Giải quyết rò rỉ trên { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Giải quyết rò rỉ dữ liệu của bạn
monitor-breaches-unresolved-description = Sau khi xem xét chi tiết rò rỉ và thực hiện các bước để bảo vệ thông tin của bạn, bạn có thể đánh dấu các rò rỉ là đã được giải quyết.
monitor-manage-breaches-link = Quản lí vụ rò rỉ
    .title = Quản lí các vụ rò rỉ trên { -monitor-brand-short-name }
monitor-breaches-resolved-title = Tốt! Bạn đã giải quyết tất cả các rò rỉ được biết đến.
monitor-breaches-resolved-description = Nếu email của bạn xuất hiện trong bất kỳ rò rỉ mới, chúng tôi sẽ cho bạn biết.
# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
       *[other] { $numBreachesResolved } trong số { $numBreaches } vụ rò rỉ đã được đánh dấu là giải quyết
    }
# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% hoàn thành
monitor-partial-breaches-motivation-title-start = Khởi đầu tuyệt vời!
monitor-partial-breaches-motivation-title-middle = Hãy giữ nó!
monitor-partial-breaches-motivation-title-end = Sắp xong! Hãy giữ nó.
monitor-partial-breaches-motivation-description = Giải quyết các rò rỉ còn lại của bạn trên { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Giải quyết các rò rỉ
    .title = Giải quyết các rò rỉ trên { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Trình theo dõi truyền thông xã hội
    .aria-label =
        { $count ->
           *[other] { $count } trình theo dõi truyền thông xã hội ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Cookie theo dõi trên nhiều trang web
    .aria-label =
        { $count ->
           *[other] { $count } cookie theo dõi trên nhiều trang web ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Trình theo dõi nội dung
    .aria-label =
        { $count ->
           *[other] { $count } trình theo dõi nội dung ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Dấu vết
    .aria-label =
        { $count ->
           *[other] { $count } dấu vết ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Tiền điện tử
    .aria-label =
        { $count ->
           *[other] { $count } tiền điện tử ({ $percentage }%)
        }
