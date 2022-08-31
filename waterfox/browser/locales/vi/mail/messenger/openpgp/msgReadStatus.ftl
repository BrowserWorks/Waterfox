# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Message Header Encryption Button

message-header-show-security-info-key = S
#   $type (String) - the shortcut key defined in the message-header-show-security-info-key
message-security-button =
    .title =
        { PLATFORM() ->
            [macos] Hiển thị bảo mật thư (⌘ ⌥ { message-header-show-security-info-key })
           *[other] Hiển thị bảo mật thư (Ctrl+Alt+{ message-header-show-security-info-key })
        }
openpgp-view-signer-key =
    .label = Xem khóa của người ký
openpgp-view-your-encryption-key =
    .label = Xem khóa giải mã của bạn
openpgp-openpgp = OpenPGP
openpgp-no-sig = Không có chữ ký số
openpgp-no-sig-info = Thư này không có chữ kí điện tử của người gửi. Việc thiếu chữ kí điện tử có nghĩa là lá thư có thể đã được gửi bởi một người giả dạng địa chỉ email này. Cũng có thể lá thư đã bị sửa đổi trong khi truyền tải qua hệ thống mạng.
openpgp-uncertain-sig = Chữ ký số không chắc chắn
openpgp-invalid-sig = Chữ ký số không hợp lệ
openpgp-good-sig = Chữ ký số tốt
openpgp-sig-uncertain-no-key = Thư này có chứa chữ ký số, nhưng không chắc liệu nó có đúng hay không. Để xác minh chữ ký, bạn cần lấy bản sao khóa công khai của người gửi.
openpgp-sig-uncertain-uid-mismatch = Thư này chứa chữ ký số nhưng đã phát hiện thấy không khớp. Thư được gửi từ một địa chỉ email không khớp với khóa công khai của người ký.
openpgp-sig-uncertain-not-accepted = Thư này chứa chữ ký số, nhưng bạn vẫn chưa quyết định xem khóa của người ký có được bạn chấp nhận hay không.
openpgp-sig-invalid-rejected = Thư này chứa chữ ký số, nhưng trước đó bạn đã quyết định từ chối khóa người ký.
openpgp-sig-invalid-technical-problem = Thư này chứa chữ ký số, nhưng đã phát hiện ra lỗi kỹ thuật. Thư đã bị hỏng hoặc đã bị người khác sửa đổi.
openpgp-sig-valid-unverified = Thư này bao gồm một chữ ký số hợp lệ từ một khóa mà bạn đã chấp nhận. Tuy nhiên, bạn vẫn chưa xác minh được rằng khóa có thực sự thuộc sở hữu của người gửi hay không.
openpgp-sig-valid-verified = Thư này bao gồm một chữ ký số hợp lệ từ một khóa đã được xác minh.
openpgp-sig-valid-own-key = Thư này bao gồm một chữ ký số hợp lệ từ khóa cá nhân của bạn.
openpgp-sig-key-id = ID khóa người ký: { $key }
openpgp-sig-key-id-with-subkey-id = ID khóa người ký: { $key } (ID khóa phụ: { $subkey })
openpgp-enc-key-id = ID khóa giải mã của bạn: { $key }
openpgp-enc-key-with-subkey-id = ID khóa giải mã của bạn: { $key } (ID khóa phụ: { $subkey })
openpgp-enc-none = Thư không được mã hóa
openpgp-enc-none-label = Thư này không được mã hóa trước khi gửi. Thông tin gửi qua Internet mà không mã hóa có thể bị thấy bởi người khác trong quá trình truyền tải.
openpgp-enc-invalid-label = Thư không thể giải mã
openpgp-enc-invalid = Thư này đã được mã hóa trước khi được gửi đến bạn, nhưng nó không thể giải mã được.
openpgp-enc-clueless = Có những vấn đề chưa biết đối với thư mã hóa này.
openpgp-enc-valid-label = Thư được mã hóa
openpgp-enc-valid = Thư này đã được mã hóa trước khi nó được gửi cho bạn. Mã hóa đảm bảo chỉ những người nhận mới có thể đọc được thư đó.
openpgp-unknown-key-id = Khóa không xác định
openpgp-other-enc-additional-key-ids = Ngoài ra, thư đã được mã hóa cho chủ sở hữu của các khóa sau:
openpgp-other-enc-all-key-ids = Thư đã được mã hóa cho chủ sở hữu của các khóa sau:
openpgp-message-header-encrypted-ok-icon =
    .alt = Giải mã thành công
openpgp-message-header-encrypted-notok-icon =
    .alt = Giải mã thất bại
openpgp-message-header-signed-ok-icon =
    .alt = Chữ ký tốt
# Mismatch icon is used for notok state as well
openpgp-message-header-signed-mismatch-icon =
    .alt = Chữ ký lỗi
openpgp-message-header-signed-unknown-icon =
    .alt = Trạng thái chữ ký không xác định
openpgp-message-header-signed-verified-icon =
    .alt = Chữ ký đã xác minh
openpgp-message-header-signed-unverified-icon =
    .alt = Chữ ký chưa được xác minh
