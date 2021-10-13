# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-setup-tab-title = Thiết lập tài khoản

## Header

account-setup-title = Thiết lập địa chỉ email hiện tại của bạn
account-setup-description =
    Để sử dụng địa chỉ email hiện tại của bạn, hãy điền thông tin đăng nhập của bạn.<br/>
    { -brand-product-name } sẽ tự động tìm kiếm cấu hình máy chủ đang hoạt động và được đề xuất.
account-setup-secondary-description = { -brand-product-name } sẽ tự động tìm kiếm cấu hình máy chủ đang hoạt động và được đề xuất.
account-setup-success-title = Tạo tài khoản thành công
account-setup-success-description = Bây giờ bạn có thể sử dụng tài khoản này với { -brand-short-name }.
account-setup-success-secondary-description = Bạn có thể cải thiện trải nghiệm bằng cách kết nối các dịch vụ liên quan và định cấu hình cài đặt tài khoản nâng cao.

## Form fields

account-setup-name-label = Tên đầy đủ của bạn
    .accesskey = n
# Note: "John Doe" is a multiple-use name that is used when the true name of a person is unknown. We use this fake name as an input placeholder. Translators should update this to reflect the placeholder name of their language/country.
account-setup-name-input =
    .placeholder = John Doe
account-setup-name-info-icon =
    .title = Tên của bạn, như được hiển thị cho những người khác
account-setup-name-warning-icon =
    .title = { account-setup-name-warning }
account-setup-email-label = Địa chỉ email
    .accesskey = E
account-setup-email-input =
    .placeholder = john.doe@example.com
account-setup-email-info-icon =
    .title = Địa chỉ email hiện tại của bạn
account-setup-email-warning-icon =
    .title = { account-setup-email-warning }
account-setup-password-label = Mật khẩu
    .accesskey = P
    .title = Tùy chọn, sẽ chỉ được sử dụng để xác thực tên người dùng
account-provisioner-button = Tạo một địa chỉ email mới
    .accesskey = G
account-setup-password-toggle =
    .title = Hiển thị/ẩn mật khẩu
account-setup-password-toggle-show =
    .title = Hiển thị mật khẩu dưới dạng văn bản rõ ràng
account-setup-password-toggle-hide =
    .title = Ẩn mật khẩu
account-setup-remember-password = Ghi nhớ mật khẩu
    .accesskey = m
account-setup-exchange-label = Thông tin đăng nhập của bạn
    .accesskey = l
#   YOURDOMAIN refers to the Windows domain in ActiveDirectory. yourusername refers to the user's account name in Windows.
account-setup-exchange-input =
    .placeholder = TENMIENCUABAN\tennguoidungcuaban
#   Domain refers to the Windows domain in ActiveDirectory. We mean the user's login in Windows at the local corporate network.
account-setup-exchange-info-icon =
    .title = Thông tin đăng nhập trong miền

## Action buttons

account-setup-button-cancel = Hủy bỏ
    .accesskey = a
account-setup-button-manual-config = Cấu hình thủ công
    .accesskey = m
account-setup-button-stop = Dừng
    .accesskey = S
account-setup-button-retest = Kiểm tra lại
    .accesskey = t
account-setup-button-continue = Tiếp tục
    .accesskey = C
account-setup-button-done = Xong
    .accesskey = D

## Notifications

account-setup-looking-up-settings = Đang tìm cấu hình…
account-setup-looking-up-settings-guess = Đang tìm cấu hình: Đang thử các tên máy chủ phổ biến…
account-setup-looking-up-settings-half-manual = Đang tìm cấu hình: Đang dò tìm máy chủ…
account-setup-looking-up-disk = Đang tìm cấu hình: Bộ cài đặt { -brand-short-name }…
account-setup-looking-up-isp = Đang tìm cấu hình: Nhà cung cấp dịch vụ email…
# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-looking-up-db = Đang tìm cấu hình: Cơ sở dữ liệu Waterfox ISP…
account-setup-looking-up-mx = Đang tìm cấu hình: Tên miền thư đến…
account-setup-looking-up-exchange = Đang tìm cấu hình: Máy chủ Exchange…
account-setup-checking-password = Đang kiểm tra mật khẩu…
account-setup-installing-addon = Đang tải xuống và cài đặt tiện ích mở rộng…
account-setup-success-half-manual = Các cài đặt sau được tìm thấy bằng cách thăm dò máy chủ nhất định:
account-setup-success-guess = Cấu hình được tìm thấy bằng cách thử các tên máy chủ phổ biến.
account-setup-success-guess-offline = Bạn hiện đang ngoại tuyến. Chúng tôi đã thử đoán một số cài đặt nhưng bạn sẽ cần nhập đúng cài đặt.
account-setup-success-password = Mật khẩu OK
account-setup-success-addon = Đã cài đặt thành công tiện ích mở rộng
# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-success-settings-db = Cấu hình được tìm thấy trong cơ sở dữ liệu Waterfox ISP.
account-setup-success-settings-disk = Cấu hình được tìm thấy trong bộ cài đặt { -brand-short-name }.
account-setup-success-settings-isp = Cấu hình được tìm thấy tại nhà cung cấp email.
# Note: Microsoft Exchange is a product name.
account-setup-success-settings-exchange = Cấu hình được tìm thấy cho máy chủ Microsoft Exchange.

## Illustrations

account-setup-step1-image =
    .title = Thiết lập ban đầu
account-setup-step2-image =
    .title = Đang tải…
account-setup-step3-image =
    .title = Cấu hình được tìm thấy
account-setup-step4-image =
    .title = Lỗi kết nối
account-setup-step5-image =
    .title = Đã tạo tài khoản
account-setup-privacy-footnote2 = Thông tin đăng nhập của bạn sẽ chỉ được lưu trữ cục bộ trên máy tính của bạn.
account-setup-selection-help = Không chắc chắn những gì để chọn?
account-setup-selection-error = Cần trợ giúp?
account-setup-success-help = Không chắc chắn về các bước tiếp theo của mình?
account-setup-documentation-help = Tài liệu thiết lập
account-setup-forum-help = Diễn đàn hỗ trợ
account-setup-privacy-help = Chính sách riêng tư
account-setup-getting-started = Bắt đầu

## Results area

# Variables:
#  $count (Number) - Number of available protocols.
account-setup-results-area-title =
    { $count ->
       *[other] Các cấu hình có sẵn
    }
# Note: IMAP is the name of a protocol.
account-setup-result-imap = IMAP
account-setup-result-imap-description = Giữ cho các thư mục và email của bạn được đồng bộ hóa trên máy chủ của bạn
# Note: POP3 is the name of a protocol.
account-setup-result-pop = POP3
account-setup-result-pop-description = Giữ các thư mục và email của bạn trên máy tính của bạn
# Note: Exchange is the name of a product.
account-setup-result-exchange = Exchange
# Note: Exchange, Office365 are the name of products.
account-setup-result-exchange2-description = Sử dụng máy chủ Microsoft Exchange hoặc các dịch vụ đám mây Office365
account-setup-incoming-title = Hộp thư đến
account-setup-outgoing-title = Hộp thư đi
account-setup-username-title = Tên người dùng
account-setup-exchange-title = Máy chủ
account-setup-result-smtp = SMTP
account-setup-result-no-encryption = Không mã hóa
account-setup-result-ssl = SSL/TLS
account-setup-result-starttls = STARTTLS
account-setup-result-outgoing-existing = Sử dụng máy chủ gửi thư SMTP hiện tại
# Variables:
#  $incoming (String): The email/username used to log into the incoming server
#  $outgoing (String): The email/username used to log into the outgoing server
account-setup-result-username-different = Nhận thư: { $incoming }, Gửi thư: { $outgoing }

## Error messages

# Note: The reference to "janedoe" (Jane Doe) is the name of an example person. You will want to translate it to whatever example persons would be named in your language. In the example, AD is the name of the Windows domain, and this should usually not be translated.
account-setup-credentials-incomplete = Quá trình xác thực thất bại. Thông tin đăng nhập đã nhập không chính xác hoặc cần có tên người dùng riêng để đăng nhập. Tên người dùng này thường là thông tin đăng nhập miền Windows của bạn có hoặc không có miền (ví dụ: janedoe hoặc AD\\janedoe)
account-setup-credentials-wrong = Quá trình xác thực thất bại. Vui lòng kiểm tra tên người dùng và mật khẩu
account-setup-find-settings-failed = { -brand-short-name } không tìm thấy cài đặt cho tài khoản email của bạn
account-setup-exchange-config-unverifiable = Không thể xác minh cấu hình. Nếu tên người dùng và mật khẩu của bạn chính xác, có khả năng quản trị viên máy chủ đã vô hiệu hóa cấu hình đã chọn cho tài khoản của bạn. Hãy thử chọn một giao thức khác.

## Manual configuration area

account-setup-manual-config-title = Cài đặt máy chủ
account-setup-incoming-server-legend = Máy chủ nhận thư
account-setup-protocol-label = Giao thức:
protocol-imap-option = { account-setup-result-imap }
protocol-pop-option = { account-setup-result-pop }
protocol-exchange-option = { account-setup-result-exchange }
account-setup-hostname-label = Tên máy chủ:
account-setup-port-label = Cổng:
    .title = Đặt cổng thành 0 để tự động phát hiện
account-setup-auto-description = { -brand-short-name } sẽ thử tự động phát hiện các trường bị bỏ trống.
account-setup-ssl-label = Bảo mật kết nối:
account-setup-outgoing-server-legend = Máy chủ gửi thư

## Incoming/Outgoing SSL Authentication options

ssl-autodetect-option = Tự động phát hiện
ssl-no-authentication-option = Không xác thực
ssl-cleartext-password-option = Mật khẩu bình thường
ssl-encrypted-password-option = Mật khẩu mã hóa

## Incoming/Outgoing SSL options

ssl-noencryption-option = Không
account-setup-auth-label = Phương thức xác thực:
account-setup-username-label = Tên đăng nhập:
account-setup-advanced-setup-button = Cấu hình nâng cao
    .accesskey = A

## Warning insecure server dialog

account-setup-insecure-title = Cảnh báo!
account-setup-insecure-incoming-title = Cài đặt nhận thư:
account-setup-insecure-outgoing-title = Cài đặt gửi thư:
# Variables:
#  $server (String): The name of the hostname of the server the user was trying to connect to.
account-setup-warning-cleartext = <b>{ $server }</b> không sử dụng mã hóa.
account-setup-warning-cleartext-details = Máy chủ thư không an toàn không sử dụng kết nối được mã hóa để bảo vệ mật khẩu và thông tin cá nhân của bạn. Bằng cách kết nối với máy chủ này, bạn có thể bị tiết lộ mật khẩu và thông tin cá nhân của mình.
account-setup-insecure-server-checkbox = Tôi hiểu các rủi ro
    .accesskey = u
account-setup-insecure-description = { -brand-short-name } có thể cho phép bạn truy cập thư của mình bằng cách sử dụng các cấu hình được cung cấp. Tuy nhiên, bạn nên liên hệ với quản trị viên hoặc nhà cung cấp email của mình về những kết nối không đúng này. Xem <a data-l10n-name="thunderbird-faq-link">câu hỏi thường gặp về Thunderbird</a> để biết thêm thông tin.
insecure-dialog-cancel-button = Thay đổi cài đặt
    .accesskey = S
insecure-dialog-confirm-button = Xác nhận
    .accesskey = C

## Warning Exchange confirmation dialog

# Variables:
#  $domain (String): The name of the server where the configuration was found, e.g. rackspace.com.
exchange-dialog-question = { -brand-short-name } đã tìm thấy thông tin thiết lập tài khoản của bạn trên { $domain }. Bạn có muốn tiếp tục và gửi thông tin đăng nhập của mình không?
exchange-dialog-confirm-button = Đăng nhập
exchange-dialog-cancel-button = Huỷ bỏ

## Dismiss account creation dialog

exit-dialog-title = Không có tài khoản email nào được cấu hình
exit-dialog-description = Bạn có chắc chắn muốn hủy quá trình thiết lập không? Bạn vẫn có thể sử dụng { -brand-short-name } mà không cần tài khoản email nhưng nhiều tính năng sẽ không khả dụng.
account-setup-no-account-checkbox = Sử dụng { -brand-short-name } mà không cần tài khoản email
    .accesskey = U
exit-dialog-cancel-button = Tiếp tục thiết lập
    .accesskey = C
exit-dialog-confirm-button = Thoát thiết lập
    .accesskey = E

## Alert dialogs

account-setup-creation-error-title = Lỗi khi tạo tài khoản
account-setup-error-server-exists = Máy chủ nhận thư đã tồn tại.
account-setup-confirm-advanced-title = Xác nhận cấu hình nâng cao
account-setup-confirm-advanced-description = Hộp thoại này sẽ bị đóng và một tài khoản với các cài đặt hiện tại sẽ được tạo, ngay cả khi cấu hình không chính xác. Bạn có muốn tiếp tục?

## Addon installation section

account-setup-addon-install-title = Cài đặt
account-setup-addon-install-intro = Một tiện ích mở rộng của bên thứ ba có thể cho phép bạn truy cập tài khoản email của mình trên máy chủ này:
account-setup-addon-no-protocol = Máy chủ email này không hỗ trợ các giao thức mở. { account-setup-addon-install-intro }

## Success view

account-setup-settings-button = Cài đặt tài khoản
account-setup-encryption-button = Mã hóa đầu cuối
account-setup-signature-button = Thêm chữ ký
account-setup-dictionaries-button = Tải xuống từ điển
account-setup-address-book-carddav-button = Kết nối đến sổ địa chỉ CardDAV
account-setup-address-book-ldap-button = Kết nối đến sổ địa chỉ LDAP
account-setup-calendar-button = Kết nối đến lịch từ xa
account-setup-linked-services-title = Kết nối các dịch vụ được liên kết của bạn
account-setup-linked-services-description = { -brand-short-name } đã phát hiện thấy các dịch vụ khác được liên kết với tài khoản email của bạn.
account-setup-no-linked-description = Thiết lập các dịch vụ khác để tận dụng tối đa trải nghiệm { -brand-short-name } của bạn.
# Variables:
# $count (Number) - The number of address books found during autoconfig.
account-setup-found-address-books-description =
    { $count ->
       *[other] { -brand-short-name } đã tìm thấy { $count } sổ địa chỉ được liên kết với tài khoản email của bạn.
    }
# Variables:
# $count (Number) - The number of calendars found during autoconfig.
account-setup-found-calendars-description =
    { $count ->
       *[other] { -brand-short-name } đã tìm thấy { $count } lịch được liên kết với tài khoản email của bạn.
    }
account-setup-button-finish = Hoàn thành
    .accesskey = F
account-setup-looking-up-address-books = Đang tra cứu sổ địa chỉ…
account-setup-looking-up-calendars = Đang tra cứu lịch…
account-setup-address-books-button = Sổ địa chỉ
account-setup-calendars-button = Lịch
account-setup-connect-link = Kết nối
account-setup-existing-address-book = Đã kết nối
    .title = Sổ địa chỉ đã được kết nối trước đó
account-setup-existing-calendar = Đã kết nối
    .title = Lịch đã được kết nối trước đó
account-setup-connect-all-calendars = Kết nối tất cả các lịch
account-setup-connect-all-address-books = Kết nối tất cả các sổ địa chỉ

## Calendar synchronization dialog

calendar-dialog-title = Kết nối lịch
calendar-dialog-cancel-button = Hủy bỏ
    .accesskey = C
calendar-dialog-confirm-button = Kết nối
    .accesskey = n
account-setup-calendar-name-label = Tên
account-setup-calendar-name-input =
    .placeholder = Lịch của tôi
account-setup-calendar-color-label = Màu
account-setup-calendar-refresh-label = Làm mới
account-setup-calendar-refresh-manual = Thủ công
account-setup-calendar-refresh-interval =
    { $count ->
       *[other] Mỗi { $count } phút một lần
    }
account-setup-calendar-read-only = Chỉ đọc
    .accesskey = R
account-setup-calendar-show-reminders = Hiển thị lời nhắc
    .accesskey = S
account-setup-calendar-offline-support = Hỗ trợ ngoại tuyến
    .accesskey = O
