# This Source Code Form is subject to the terms of the Mozilla Public
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

## Import Key section

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
