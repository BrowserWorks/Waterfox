# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Thêm Khóa OpenPGP Cá nhân cho { $identity }

key-wizard-button =
    .buttonlabelaccept = Tiếp tục
    .buttonlabelhelp = Quay lại

key-wizard-warning = <b>Nếu bạn có khóa cá nhân hiện tại</b> cho địa chỉ email này, bạn nên nhập khóa đó. Nếu không, bạn sẽ không có quyền truy cập vào kho lưu trữ email được mã hóa của mình, cũng như không thể đọc các email được mã hóa đến từ những người vẫn đang sử dụng khóa hiện có của bạn.

key-wizard-learn-more = Tìm hiểu thêm

radio-create-key =
    .label = Tạo khóa OpenPGP mới
    .accesskey = C

radio-import-key =
    .label = Nhập khóa OpenPGP hiện có
    .accesskey = I

radio-gnupg-key =
    .label = Sử dụng khóa ngoài của bạn thông qua GnuPG (ví dụ: từ thẻ thông minh)
    .accesskey = U

## Generate key section

openpgp-generate-key-title = Tạo khóa OpenPGP

openpgp-generate-key-info = <b>Quá trình tạo khóa có thể mất đến vài phút để hoàn tất.</b> Không thoát ứng dụng khi đang tiến hành tạo khóa. Tích cực duyệt hoặc thực hiện các thao tác sử dụng nhiều đĩa trong quá trình tạo khóa sẽ bổ sung 'nhóm ngẫu nhiên' và tăng tốc quá trình. Bạn sẽ được thông báo khi quá trình tạo khóa hoàn tất.

openpgp-keygen-expiry-title = Khóa hết hạn

openpgp-keygen-expiry-description = Xác định thời gian hết hạn của khóa mới tạo của bạn. Sau đó, bạn có thể kiểm soát ngày để gia hạn nếu cần.

radio-keygen-expiry =
    .label = Khóa hết hạn sau
    .accesskey = e

radio-keygen-no-expiry =
    .label = Khóa không hết hạn
    .accesskey = d

openpgp-keygen-days-label =
    .label = ngày
openpgp-keygen-months-label =
    .label = tháng
openpgp-keygen-years-label =
    .label = năm

openpgp-keygen-advanced-title = Cài đặt nâng cao

openpgp-keygen-advanced-description = Kiểm soát cài đặt nâng cao của khóa OpenPGP của bạn.

openpgp-keygen-keytype =
    .value = Loại khóa:
    .accesskey = t

openpgp-keygen-keysize =
    .value = Kích thước khóa:
    .accesskey = s

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (Elliptic Curve)

openpgp-keygen-button = Tạo khóa

openpgp-keygen-progress-title = Đang tạo khóa OpenPGP mới của bạn…

openpgp-keygen-import-progress-title = Nhập khóa OpenPGP của bạn…

openpgp-import-success = Đã nhập thành công khóa OpenPGP!

openpgp-import-success-title = Hoàn tất quá trình nhập

openpgp-import-success-description = Để bắt đầu sử dụng khóa OpenPGP đã nhập của bạn để mã hóa email, hãy đóng hộp thoại này và truy cập Cài đặt tài khoản của bạn để chọn nó.

openpgp-keygen-confirm =
    .label = Xác nhận

openpgp-keygen-dismiss =
    .label = Hủy bỏ

openpgp-keygen-cancel =
    .label = Hủy bỏ quá trình…

openpgp-keygen-import-complete =
    .label = Đóng
    .accesskey = C

openpgp-keygen-missing-username = Không có tên được chỉ định cho tài khoản hiện tại. Vui lòng nhập giá trị vào trường  "Tên của bạn" trong cài đặt tài khoản.
openpgp-keygen-long-expiry = Bạn không thể tạo khóa hết hạn sau hơn 100 năm.
openpgp-keygen-short-expiry = Khóa của bạn phải có giá trị trong ít nhất một ngày.

openpgp-keygen-ongoing = Đã ở trong quá trình tạo khóa!

openpgp-keygen-error-core = Không thể khởi tạo OpenPGP Core Service

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = Đã tạo thành công khóa OpenPGP nhưng không thể thu hồi khóa { $key }

openpgp-keygen-abort-title = Hủy việc tạo khóa?
openpgp-keygen-abort = Khóa OpenPGP hiện đang được tạo, bạn có chắc chắn muốn hủy nó không?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Tạo khóa công khai và khóa bí mật cho { $identity }?

## Import Key section

openpgp-import-key-title = Nhập khóa OpenPGP cá nhân hiện có

openpgp-import-key-legend = Chọn một tập tin đã sao lưu trước đó.

openpgp-import-key-description = Bạn có thể nhập các khóa cá nhân đã được tạo bằng phần mềm OpenPGP khác.

openpgp-import-key-info = Phần mềm khác có thể mô tả khóa cá nhân bằng các thuật ngữ thay thế như khóa riêng, khóa bí mật, khóa cá nhân hoặc cặp khóa.

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
       *[other] Thunderbird đã tìm thấy { $count } khóa có thể nhập được.
    }

openpgp-import-key-list-description = Xác nhận khóa nào có thể được coi là khóa cá nhân của bạn. Chỉ những khóa do bạn tự tạo và thể hiện danh tính của riêng bạn mới được sử dụng làm khóa cá nhân. Bạn có thể thay đổi tùy chọn này sau trong hộp thoại Thuộc tính khóa.

openpgp-import-key-list-caption = Các khóa được đánh dấu được coi là Khóa cá nhân sẽ được liệt kê trong phần Mã hóa đầu cuối. Những cái khác sẽ có sẵn bên trong Trình quản lý khóa.

openpgp-passphrase-prompt-title = Yêu cầu cụm mật khẩu

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Vui lòng nhập cụm mật khẩu để mở khóa sau: { $key }

openpgp-import-key-button =
    .label = Chọn tập tin để nhập…
    .accesskey = S

import-key-file = Nhập tập tin khóa OpenPGP

import-key-personal-checkbox =
    .label = Coi khóa này như một khóa cá nhân

gnupg-file = Tập tin GnuPG

import-error-file-size = <b>Lỗi!</b> Các tập tin lớn hơn 5MB không được hỗ trợ.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Lỗi!</b> Không thể nhập tập tin. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Lỗi!</b> Không thể nhập khóa. { $error }

openpgp-import-identity-label = Danh tính

openpgp-import-fingerprint-label = Vân tay

openpgp-import-created-label = Đã tạo

openpgp-import-bits-label = Bit

openpgp-import-key-props =
    .label = Thuộc tính khóa
    .accesskey = K

## External Key section

openpgp-external-key-title = Khóa GnuPG bên ngoài

openpgp-external-key-description = Định cấu hình khóa GnuPG bên ngoài bằng cách nhập ID khóa

openpgp-external-key-info = Ngoài ra, bạn phải sử dụng Trình quản lý khóa để nhập và chấp nhận khóa công khai tương ứng.

openpgp-external-key-warning = <b>Bạn chỉ có thể định cấu hình một khóa GnuPG bên ngoài.</b> Mục nhập trước đó của bạn sẽ được thay thế.

openpgp-save-external-button = Lưu ID khóa

openpgp-external-key-label = ID khóa bí mật:

openpgp-external-key-input =
    .placeholder = 123456789341298340
