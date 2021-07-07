# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Trình quản lí chứng chỉ

certmgr-tab-mine =
    .label = Chứng chỉ của bạn

certmgr-tab-remembered =
    .label = Quyết định chứng thực

certmgr-tab-people =
    .label = Người khác

certmgr-tab-servers =
    .label = Máy chủ

certmgr-tab-ca =
    .label = Nhà thẩm định

certmgr-mine = Bạn có các chứng thực từ các tổ chức để nhận biết bạn
certmgr-remembered = Những chứng nhận này được sử dụng để nhận dạng bạn với các trang web
certmgr-people = Bạn có các tập tin chứng thực để nhận biết những người này
certmgr-server = Các mục này xác định các ngoại lệ lỗi chứng chỉ máy chủ
certmgr-ca = Bạn có những tập tin chứng thực để nhận biết các nhà thẩm định chứng thực này

certmgr-edit-ca-cert =
    .title = Chỉnh thiết lập độ tin cậy chứng chỉ CA
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Chỉnh thiết lập tin cậy:

certmgr-edit-cert-trust-ssl =
    .label = Chứng chỉ này có thể nhận diện trang web.

certmgr-edit-cert-trust-email =
    .label = Chứng chỉ này có thể nhận diện người dùng email.

certmgr-delete-cert =
    .title = Xóa chứng nhận
    .style = width: 48em; height: 24em;

certmgr-cert-host =
    .label = Máy chủ

certmgr-cert-name =
    .label = Tên chứng nhận

certmgr-cert-server =
    .label = Máy chủ

certmgr-override-lifetime =
    .label = Chu kì

certmgr-token-name =
    .label = Thiết bị bảo mật

certmgr-begins-label =
    .label = Bắt đầu

certmgr-expires-label =
    .label = Hết hạn vào

certmgr-email =
    .label = Địa chỉ email

certmgr-serial =
    .label = Số sê-ri

certmgr-view =
    .label = Xem…
    .accesskey = e

certmgr-edit =
    .label = Chỉnh sửa tin tưởng…
    .accesskey = E

certmgr-export =
    .label = Xuất…
    .accesskey = u

certmgr-delete =
    .label = Xóa…
    .accesskey = X

certmgr-delete-builtin =
    .label = Xóa hoặc không tin tưởng…
    .accesskey = D

certmgr-backup =
    .label = Sao lưu…
    .accesskey = l

certmgr-backup-all =
    .label = Sao lưu toàn bộ…
    .accesskey = k

certmgr-restore =
    .label = Nhập…
    .accesskey = N

certmgr-add-exception =
    .label = Thêm ngoại lệ…
    .accesskey = x

exception-mgr =
    .title = Thêm ngoại lệ bảo mật

exception-mgr-extra-button =
    .label = Xác nhận ngoại lệ bảo mật
    .accesskey = C

exception-mgr-supplemental-warning = Ngân hàng, cửa hiệu và trang công cộng hợp pháp khác sẽ không yêu cầu bạn làm việc này.

exception-mgr-cert-location-url =
    .value = Địa chỉ:

exception-mgr-cert-location-download =
    .label = Nhận chứng nhận
    .accesskey = G

exception-mgr-cert-status-view-cert =
    .label = Xem…
    .accesskey = V

exception-mgr-permanent =
    .label = Lưu trữ ngoại lệ này vĩnh viễn
    .accesskey = L

pk11-bad-password = Mật khẩu nhập vào không đúng.
pkcs12-decode-err = Không giải mã tập tin được.  Do nó không ở định dạng PKCS #12, bị hỏng, hoặc mật khẩu đã nhập sai.
pkcs12-unknown-err-restore = Thất bại trong khi khôi phục tập tin PKCS #12 vì những lí do chưa rõ ràng.
pkcs12-unknown-err-backup = Thất bại trong khi tạo tập tin sao lưu PKCS #12 vì những lí do chưa rõ ràng.
pkcs12-unknown-err = Thao tác với PKCS #12 thất bại nhưng không rõ lí do.
pkcs12-info-no-smartcard-backup = Không thể sao lưu các chứng chỉ từ một phần cứng bảo mật, ví dụ như thẻ thông minh.
pkcs12-dup-data = Chứng chỉ và khóa cá nhân đã có sẵn trên thiết bị bảo mật.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Tên tập tin để sao lưu
file-browse-pkcs12-spec = Tập tin PKCS12
choose-p12-restore-file-dialog = Chứng chỉ tập tin để nhập

## Import certificate(s) file dialog

file-browse-certificate-spec = Tập tin chứng chỉ
import-ca-certs-prompt = Chọn tập tin chứa (các) chứng chỉ CA để nhập
import-email-cert-prompt = Chọn Tập Tin chứa chứng chỉ Email của ai đó để nhập

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Chứng chỉ "{ $certName }" đại diện cho một nhà thẩm định chứng chỉ.

## For Deleting Certificates

delete-user-cert-title =
    .title = Xóa chứng chỉ của bạn
delete-user-cert-confirm = Bạn có chắc muốn xóa các chứng chỉ này không?
delete-user-cert-impact = Nếu bạn xóa một trong các chứng chỉ của riêng bạn, bạn không thể dùng nó để nhận diện chính mình được nữa.


delete-ssl-override-title =
    .title = Xóa ngoại lệ chứng chỉ máy chủ
delete-ssl-override-confirm = Bạn có chắc bạn muốn xóa ngoại lệ máy chủ này không?
delete-ssl-override-impact = Nếu bạn xóa một ngoại lệ máy chủ, bạn khôi phục việc kiểm tra bảo mật thông thường cho máy chủ đó và yêu cầu nó dùng một chứng thư hợp lệ.

delete-ca-cert-title =
    .title = Xóa hoặc không tin cậy chứng chỉ CA
delete-ca-cert-confirm = Bạn đã yêu cầu xóa các chứng chỉ CA này. Đối với chứng chỉ có sẵn, tất cả tin tưởng sẽ bị xóa, gây ra cùng hiệu ứng. Bạn có chắc bạn muốn xóa hoặc không tin tưởng?
delete-ca-cert-impact = Nếu bạn xóa hoặc không tin tưởng một chứng chỉ của nhà thẩm định chứng chỉ (CA), ứng dụng này sẽ không còn tin bất kì chứng chỉ nào được cấp phát bởi CA đó.


delete-email-cert-title =
    .title = Xóa các chứng chỉ email
delete-email-cert-confirm = Bạn có muốn xóa các chứng chỉ email của những người này không?
delete-email-cert-impact = Nếu bạn xóa chứng chỉ email của một người, bạn sẽ không thể gửi e-mail mật hóa tới người đó được nữa.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Chứng chỉ có số sê-ri: { $serialNumber }

## Cert Viewer

# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = Không gửi chứng chỉ máy khách

# Used when no cert is stored for an override
no-cert-stored-for-override = (Không được lưu trữ)

# When a certificate is unavailable (for example, it has been deleted or the token it exists on has been removed).
certificate-not-available = (Không có sẵn)

## Used to show whether an override is temporary or permanent

permanent-override = Vĩnh viễn
temporary-override = Tạm thời

## Add Security Exception dialog

add-exception-branded-warning = Bạn đang chuẩn bị thay thế cách { -brand-short-name } định danh trang này.
add-exception-invalid-header = Trang này đang cố định danh chính nó bằng thông tin bất hợp lệ.
add-exception-domain-mismatch-short = Trang web sai
add-exception-domain-mismatch-long = Chứng chỉ thuộc về một trang web khác, điều đó có thể có nghĩa là ai đó đang cố gắng mạo danh trang web này.
add-exception-expired-short = Thông tin lỗi thời
add-exception-expired-long = Chứng chỉ hiện không hợp lệ. Nó có thể đã bị đánh cắp hoặc bị mất và có thể được sử dụng bởi ai đó để mạo danh trang web này.
add-exception-unverified-or-bad-signature-short = Không xác định nhận dạng
add-exception-unverified-or-bad-signature-long = Chứng chỉ không đáng tin vì không được chứng thực bằng chữ kí bảo mật bởi một hãng đã biết.
add-exception-valid-short = Chứng chỉ hợp lệ
add-exception-valid-long = Trang này cung cấp định danh hợp lệ, đã được xác minh. Không cần phải thêm ngoại lệ.
add-exception-checking-short = Đang kiểm tra thông tin
add-exception-checking-long = Đang cố gắng nhận dạng trang web này…
add-exception-no-cert-short = Không có thông tin
add-exception-no-cert-long = Không thể có được trạng thái nhận dạng cho trang web này.

## Certificate export "Save as" and error dialogs

save-cert-as = Lưu chứng chỉ vào tập tin
cert-format-base64 = Chứng chỉ X.509 (PEM)
cert-format-base64-chain = Chứng chỉ có mạch chuỗi X.509 (PEM)
cert-format-der = Chứng chỉ X.509 (DER)
cert-format-pkcs7 = Chứng chỉ X.509 (PKCS#7)
cert-format-pkcs7-chain = Chứng chỉ có mạch chuỗi X.509 (PKCS#7)
write-file-failure = Lỗi tập tin
