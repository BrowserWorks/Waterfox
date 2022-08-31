# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = Để gửi thư được mã hóa hoặc được ký điện tử, bạn cần định cấu hình công nghệ mã hóa, OpenPGP hoặc S/MIME.
e2e-intro-description-more = Chọn khóa cá nhân của bạn để cho phép sử dụng OpenPGP hoặc chứng chỉ cá nhân của bạn để cho phép sử dụng S/MIME. Đối với khóa cá nhân hoặc chứng chỉ, bạn sở hữu khóa bí mật tương ứng.
e2e-signing-description = Chữ ký điện tử cho phép người nhận xác minh rằng thư đã được bạn gửi và nội dung của nó không bị thay đổi. Các thư được mã hóa luôn được ký theo mặc định.
e2e-sign-message =
    .label = Ký các thư không được mã hóa
    .accesskey = u
e2e-disable-enc =
    .label = Tắt mã hóa cho thư mới
    .accesskey = D
e2e-enable-enc =
    .label = Bật mã hóa cho thư mới
    .accesskey = n
e2e-enable-description = Bạn sẽ có thể tắt mã hóa cho từng thư.
e2e-advanced-section = Cài đặt nâng cao
e2e-attach-key =
    .label = Đính kèm khóa công khai của tôi khi thêm chữ ký số OpenPGP
    .accesskey = P
e2e-encrypt-subject =
    .label = Mã hóa chủ đề của thư OpenPGP
    .accesskey = b
e2e-encrypt-drafts =
    .label = Lưu trữ thư nháp ở định dạng được mã hóa
    .accesskey = r
openpgp-key-user-id-label = Tài khoản / ID người dùng
openpgp-keygen-title-label =
    .title = Tạo khóa OpenPGP
openpgp-cancel-key =
    .label = Hủy bỏ
    .tooltiptext = Hủy bỏ tạo khóa
openpgp-key-gen-expiry-title =
    .label = Khóa hết hạn
openpgp-key-gen-expire-label = Khóa hết hạn sau
openpgp-key-gen-days-label =
    .label = ngày
openpgp-key-gen-months-label =
    .label = tháng
openpgp-key-gen-years-label =
    .label = năm
openpgp-key-gen-no-expiry-label =
    .label = Khóa không hết hạn
openpgp-key-gen-key-size-label = Kích thước khóa
openpgp-key-gen-console-label = Trình tạo khóa
openpgp-key-gen-key-type-label = Loại khóa
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC (Elliptic Curve)
openpgp-generate-key =
    .label = Tạo khóa
    .tooltiptext = Tạo khóa tuân thủ OpenPGP mới để mã hóa và/hoặc ký
openpgp-advanced-prefs-button-label =
    .label = Nâng cao…
openpgp-keygen-desc = <a data-l10n-name="openpgp-keygen-desc-link">LƯU Ý: Quá trình tạo khóa có thể mất đến vài phút để hoàn thành.</a> Không thoát ứng dụng khi đang trong quá trình tạo khóa. Tích cực duyệt hoặc thực hiện các thao tác sử dụng nhiều ổ đĩa trong quá trình tạo khóa sẽ bổ sung 'nhóm ngẫu nhiên' và tăng tốc quá trình. Bạn sẽ được thông báo khi quá trình tạo khóa hoàn tất.
openpgp-key-created-label =
    .label = Đã tạo
openpgp-key-expiry-label =
    .label = Hết hạn
openpgp-key-id-label =
    .label = ID khóa
openpgp-cannot-change-expiry = Đây là khóa có cấu trúc phức tạp, việc thay đổi ngày hết hạn không được hỗ trợ.
openpgp-key-man-title =
    .title = Trình quản lý khóa OpenPGP
openpgp-key-man-generate =
    .label = Cặp khóa mới
    .accesskey = K
openpgp-key-man-gen-revoke =
    .label = Chứng nhận thu hồi
    .accesskey = R
openpgp-key-man-ctx-gen-revoke-label =
    .label = Tạo & lưu chứng nhận thu hồi
openpgp-key-man-file-menu =
    .label = Tập tin
    .accesskey = F
openpgp-key-man-edit-menu =
    .label = Chỉnh sửa
    .accesskey = E
openpgp-key-man-view-menu =
    .label = Xem
    .accesskey = V
openpgp-key-man-generate-menu =
    .label = Tạo
    .accesskey = G
openpgp-key-man-keyserver-menu =
    .label = Keyserver
    .accesskey = K
openpgp-key-man-import-public-from-file =
    .label = Nhập (các) khóa công khai từ tập tin
    .accesskey = I
openpgp-key-man-import-secret-from-file =
    .label = Nhập (các) khóa bí mật từ tập tin
openpgp-key-man-import-sig-from-file =
    .label = Nhập (các) chứng nhận thư hồi từ tập tin
openpgp-key-man-import-from-clipbrd =
    .label = Nhập (các) khóa từ bộ nhớ tạm
    .accesskey = I
openpgp-key-man-import-from-url =
    .label = Nhập (các) khóa từ URL
    .accesskey = U
openpgp-key-man-export-to-file =
    .label = Xuất (các) khóa công khai vào tập tin
    .accesskey = E
openpgp-key-man-send-keys =
    .label = Gửi (các) khóa công khai qua email
    .accesskey = S
openpgp-key-man-backup-secret-keys =
    .label = Sao lưu (các) khóa bí mật vào tập tin
    .accesskey = B
openpgp-key-man-discover-cmd =
    .label = Khám phá khóa trực tuyến
    .accesskey = D
openpgp-key-man-discover-prompt = Để khám phá các khóa OpenPGP trực tuyến, trên máy chủ hoặc sử dụng giao thức WKD, hãy nhập địa chỉ email hoặc ID khóa.
openpgp-key-man-discover-progress = Đang tìm kiếm…
openpgp-key-copy-key =
    .label = Sao chép khóa công khai
    .accesskey = C
openpgp-key-export-key =
    .label = Xuất khóa công khai vào tập tin
    .accesskey = E
openpgp-key-backup-key =
    .label = Sao lưu khóa bí mật vào tập tin
    .accesskey = B
openpgp-key-send-key =
    .label = Gửi khóa công khai qua email
    .accesskey = S
openpgp-key-man-copy-key-ids =
    .label =
        { $count ->
           *[other] Sao chép ID khóa vào khay nhớ tạm
        }
    .accesskey = K
openpgp-key-man-copy-fprs =
    .label =
        { $count ->
           *[other] Sao chép dấu vân tay vào khay nhớ tạm
        }
    .accesskey = F
openpgp-key-man-copy-to-clipboard =
    .label =
        { $count ->
           *[other] Sao chép khóa công khai vào khay nhớ tạm
        }
    .accesskey = P
openpgp-key-man-ctx-expor-to-file-label =
    .label = Xuất khóa sang tập tin
openpgp-key-man-ctx-copy =
    .label = Sao chép
    .accesskey = C
openpgp-key-man-ctx-copy-fprs =
    .label =
        { $count ->
           *[other] Dấu vân tay
        }
    .accesskey = F
openpgp-key-man-ctx-copy-key-ids =
    .label =
        { $count ->
           *[other] ID khóa
        }
    .accesskey = K
openpgp-key-man-ctx-copy-public-keys =
    .label =
        { $count ->
           *[other] Khóa công khai
        }
    .accesskey = P
openpgp-key-man-close =
    .label = Đóng
openpgp-key-man-reload =
    .label = Tải lại bộ nhớ đệm khóa
    .accesskey = R
openpgp-key-man-change-expiry =
    .label = Thay đổi ngày hết hạn
    .accesskey = E
openpgp-key-man-refresh-online =
    .label = Làm mới trực tuyến
    .accesskey = R
openpgp-key-man-ignored-ids =
    .label = Địa chỉ email
openpgp-key-man-del-key =
    .label = Xóa (các) khóa
    .accesskey = D
openpgp-delete-key =
    .label = Xóa khóa
    .accesskey = D
openpgp-key-man-revoke-key =
    .label = Thu hồi khóa
    .accesskey = R
openpgp-key-man-key-props =
    .label = Thuộc tính khóa
    .accesskey = K
openpgp-key-man-key-more =
    .label = Thêm
    .accesskey = m
openpgp-key-man-view-photo =
    .label = ID ảnh
    .accesskey = p
openpgp-key-man-ctx-view-photo-label =
    .label = Xem ID ảnh
openpgp-key-man-show-invalid-keys =
    .label = Hiển thị các khóa không hợp lệ
    .accesskey = D
openpgp-key-man-show-others-keys =
    .label = Hiển thị chìa khóa từ người khác
    .accesskey = O
openpgp-key-man-user-id-label =
    .label = Tên
openpgp-key-man-fingerprint-label =
    .label = Vân tay
openpgp-key-man-select-all =
    .label = Chọn tất cả các khóa
    .accesskey = a
openpgp-key-man-empty-tree-tooltip =
    .label = Nhập cụm từ tìm kiếm vào ô bên trên
openpgp-key-man-nothing-found-tooltip =
    .label = Không có khóa nào phù hợp với cụm từ tìm kiếm của bạn
openpgp-key-man-please-wait-tooltip =
    .label = Vui lòng đợi trong khi các khóa đang được tải…
openpgp-key-man-filter-label =
    .placeholder = Tìm kiếm khóa
openpgp-key-man-select-all-key =
    .key = A
openpgp-key-man-key-details-key =
    .key = I
openpgp-ign-addr-intro = Bạn chấp nhận sử dụng khóa này cho các địa chỉ email đã chọn sau:
openpgp-key-details-doc-title = Thuộc tính khóa
openpgp-key-details-signatures-tab =
    .label = Chứng chỉ
openpgp-key-details-structure-tab =
    .label = Cấu trúc
openpgp-key-details-uid-certified-col =
    .label = ID người dùng / Được chứng nhận bởi
openpgp-key-details-key-id-label = ID khóa
openpgp-key-details-id-label =
    .label = ID
openpgp-key-details-key-type-label = Kiểu
openpgp-key-details-attr-ignored = Cảnh báo: Khóa này có thể không hoạt động như mong đợi vì một số thuộc tính của nó không an toàn và có thể bị bỏ qua.
openpgp-key-details-attr-upgrade-sec = Bạn nên nâng cấp các thuộc tính không an toàn.
openpgp-key-details-attr-upgrade-pub = Bạn nên yêu cầu chủ khóa này nâng cấp các thuộc tính không an toàn.
openpgp-key-details-upgrade-unsafe =
    .label = Nâng cấp thuộc tính không an toàn
    .accesskey = P
openpgp-key-details-upgrade-ok = Đã nâng cấp khóa thành công. Bạn nên chia sẻ khóa công khai đã nâng cấp với các đối tác của mình.
openpgp-key-details-algorithm-label =
    .label = Thuật toán
openpgp-key-details-size-label =
    .label = Kích thước
openpgp-key-details-created-label =
    .label = Được tạo
openpgp-key-details-created-header = Được tạo
openpgp-key-details-expiry-label =
    .label = Hết hạn
openpgp-key-details-expiry-header = Hết hạn
openpgp-key-details-usage-label =
    .label = Sử dụng
openpgp-key-details-fingerprint-label = Vân tay
openpgp-key-details-legend-secret-missing = Đối với các khóa được đánh dấu bằng (!), khóa bí mật không khả dụng.
openpgp-key-details-sel-action =
    .label = Chọn hành động…
    .accesskey = S
openpgp-card-details-close-window-label =
    .buttonlabelaccept = Đóng
openpgp-acceptance-rejected-label =
    .label = Không, từ chối khóa này.
openpgp-acceptance-undecided-label =
    .label = Chưa, để sau.
openpgp-acceptance-unverified-label =
    .label = Có, nhưng tôi chưa xác minh rằng đó là khóa chính xác.
openpgp-acceptance-verified-label =
    .label = Có, tôi đã trực tiếp xác minh chìa khóa này có vân tay chính xác.
key-accept-personal =
    Đối với khóa này, bạn có cả phần công khai và phần bí mật. Bạn có thể sử dụng nó như một chìa khóa cá nhân.
    Nếu khóa này được người khác đưa cho bạn, thì đừng sử dụng nó làm khóa cá nhân.
openpgp-personal-no-label =
    .label = Không, đừng sử dụng nó làm khóa cá nhân của tôi.
openpgp-personal-yes-label =
    .label = Có, hãy coi khóa này như một khóa cá nhân.
openpgp-copy-cmd-label =
    .label = Sao chép

## e2e encryption settings

#   $identity (String) - the email address of the currently selected identity
openpgp-description-no-key = { -brand-short-name } không có khóa OpenPGP cá nhân cho <b>{ $identity }</b>
#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description-has-keys =
    { $count ->
       *[other] { -brand-short-name } đã tìm thấy { $count } khóa OpenPGP cá nhân được liên kết với <b>{ $identity }</b>
    }
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-have-key = Cấu hình hiện tại của bạn sử dụng ID khóa <b>{ $key }</b>
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-error = Cấu hình hiện tại của bạn sử dụng khóa <b>{ $key }</b>, khóa này đã hết hạn.
openpgp-add-key-button =
    .label = Thêm khóa…
    .accesskey = A
e2e-learn-more = Tìm hiểu thêm
openpgp-keygen-success = Khóa OpenPGP đã được tạo thành công!
openpgp-keygen-import-success = Đã nhập khóa OpenPGP thành công!

## OpenPGP Key selection area

openpgp-radio-none =
    .label = Không có
openpgp-radio-none-desc = Đừng sử dụng OpenPGP cho danh tính này.
openpgp-radio-key-not-usable = Không thể sử dụng khóa này làm khóa cá nhân vì khóa bí mật bị thiếu!
openpgp-radio-key-not-accepted = Để sử dụng khóa này, bạn phải phê duyệt nó như một khóa cá nhân!
openpgp-radio-key-not-found = Không thể tìm thấy khóa này! Nếu bạn muốn sử dụng nó, bạn phải nhập nó vào { -brand-short-name }.
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expires = Hết hạn vào: { $date }
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expired = Đã hết hạn vào: { $date }
openpgp-key-expires-within-6-months-icon =
    .title = Khóa sẽ hết hạn sau chưa đầy 6 tháng
openpgp-key-has-expired-icon =
    .title = Khóa đã hết hạn
openpgp-key-expand-section =
    .tooltiptext = Thêm thông tin
openpgp-key-revoke-title = Thu hồi khóa
openpgp-key-edit-title = Thay đổi khóa OpenPGP
openpgp-key-edit-date-title = Gia hạn ngày hết hạn
openpgp-manager-description = Sử dụng Trình quản lý khóa OpenPGP để xem và quản lý khóa công khai của các đối tác của bạn và tất cả các khóa khác không được liệt kê ở trên.
openpgp-manager-button =
    .label = Trình quản lý khóa OpenPGP
    .accesskey = K
# Strings in keyDetailsDlg.xhtml
key-type-public = khóa công khai
key-type-primary = khóa chính
key-type-subkey = khóa con
key-type-pair = cặp khóa (khóa bí mật và khóa công khai)
key-expiry-never = không bao giờ
key-usage-encrypt = Mã hóa
key-usage-sign = Ký
key-usage-authentication = Xác thực
key-does-not-expire = Khóa không hết hạn
key-expired-date = Khóa hết hạn vào { $keyExpiry }
key-expired-simple = Khóa đã hết hạn
key-revoked-simple = Khóa đã bị thu hồi
key-do-you-accept = Bạn có chấp nhận khóa này để xác minh chữ ký số và mã hóa tin nhắn không?
key-verification = Xác minh dấu vân tay của khóa bằng kênh liên lạc an toàn không phải email để đảm bảo rằng đó thực sự là khóa của { $addr }.
# Strings enigmailMsgComposeOverlay.js
cannot-use-own-key-because = Không thể gửi tin nhắn vì có sự cố với khóa cá nhân của bạn. { $problem }
cannot-encrypt-because-missing = Không thể gửi thư này bằng mã hóa đầu cuối vì có vấn đề với khóa của những người nhận sau: { $problem }
window-locked = Cửa sổ soạn thảo bị khóa; đã hủy gửi
# Strings in mimeDecrypt.jsm
mime-decrypt-encrypted-part-concealed-data = Đây là một phần tin nhắn được mã hóa. Bạn cần mở nó trong một cửa sổ riêng tư bằng cách nhấp vào đính kèm.
# Strings in keyserver.jsm
keyserver-error-aborted = Đã hủy
keyserver-error-unknown = Đã có lỗi xảy ra
keyserver-error-import-error = Không thể nhập khóa đã tải xuống.
# Strings in mimeWkdHandler.jsm
wkd-message-body-req =
    Nhà cung cấp dịch vụ email của bạn đã xử lý yêu cầu tải khóa công khai của bạn lên Thư mục khóa web OpenPGP.
    Vui lòng xác nhận để hoàn tất việc xuất bản khóa công khai của bạn.
wkd-message-body-process =
    Đây là email liên quan đến quá trình xử lý tự động để tải khóa công khai của bạn lên Thư mục khóa web OpenPGP.
    Bạn không cần phải thực hiện bất kỳ thao tác thủ công nào tại thời điểm này.
# Strings in persistentCrypto.jsm
converter-decrypt-body-failed =
    Không thể giải mã thư có chủ đề
    { $subject }.
    Bạn muốn thử lại bằng một cụm mật khẩu khác hay bạn muốn bỏ qua tin nhắn?
# Strings filters.jsm
filter-folder-required = Bạn phải chọn một thư mục đích.
filter-decrypt-move-warn-experimental =
    Cảnh báo - hành động bộ lọc “Giải mã vĩnh viễn” có thể dẫn đến các thư bị phá hủy.
    Chúng tôi thực sự khuyên bạn trước tiên nên thử bộ lọc “Tạo bản sao được giải mã”, kiểm tra kết quả một cách cẩn thận và chỉ bắt đầu sử dụng bộ lọc này khi bạn hài lòng với kết quả.
filter-term-pgpencrypted-label = OpenPGP được mã hóa
filter-key-required = Bạn phải chọn một khóa người nhận.
filter-key-not-found = Không thể tìm thấy khóa mã hóa cho ‘{ $desc }’.
filter-warn-key-not-secret =
    Cảnh báo - hành động bộ lọc “Mã hóa thành khóa” thay thế người nhận.
    Nếu bạn không có khóa bí mật cho ‘{ $desc }’, bạn sẽ không thể đọc email được nữa.
# Strings filtersWrapper.jsm
filter-decrypt-move-label = Giải mã vĩnh viễn (OpenPGP)
filter-decrypt-copy-label = Tạo bản sao được giải mã (OpenPGP)
filter-encrypt-label = Mã hóa thành khóa (OpenPGP)
# Strings in enigmailKeyImportInfo.js
import-info-title =
    .title = Thành công! Các khóa đã được nhập
import-info-bits = Bit
import-info-created = Đã tạo
import-info-fpr = Dấu vân tay
import-info-no-keys = Không có khóa nào được nhập.
# Strings in enigmailKeyManager.js
import-from-clip = Bạn có muốn nhập (các) khóa từ khay nhớ tạm không?
import-from-url = Tải xuống khóa công khai từ URL này:
copy-to-clipbrd-failed = Không thể sao chép (các) khóa đã chọn vào khay nhớ tạm.
copy-to-clipbrd-ok = Đã sao chép (các) khóa vào khay nhớ tạm
delete-secret-key =
    CẢNH BÁO: Bạn sắp xóa khóa bí mật!
    
    Nếu bạn xóa khóa bí mật của mình, bạn sẽ không thể giải mã bất kỳ thông báo nào được mã hóa cho khóa đó nữa, cũng như không thể thu hồi nó.
    
    Bạn có thực sự muốn xóa CẢ HAI, khóa bí mật và khóa công khai
    ‘{ $userId }’?
delete-mix =
    CẢNH BÁO: Bạn sắp xóa khóa bí mật!
    Nếu bạn xóa khóa bí mật của mình, bạn sẽ không thể giải mã bất kỳ thư nào được mã hóa cho khóa đó nữa.
    Bạn có thực sự muốn xóa CẢ HAI, khóa bí mật và khóa công khai đã chọn không?
delete-pub-key =
    Bạn có muốn xóa khóa công khai không
    "{ $userId }"?
delete-selected-pub-key = Bạn có muốn xóa các khóa công khai không?
refresh-all-question = Bạn đã không chọn bất kỳ khóa nào. Bạn có muốn làm mới TẤT CẢ các khóa không?
key-man-button-export-sec-key = Xuất &khóa bí mật
key-man-button-export-pub-key = Chỉ xuất khóa &công khai
key-man-button-refresh-all = &Làm mới tất cả các khóa
key-man-loading-keys = Đang tải khóa, vui lòng đợi…
no-key-selected = Bạn nên chọn ít nhất một khóa để thực hiện thao tác đã chọn
export-to-file = Xuất khóa công khai vào tập tin
export-keypair-to-file = Xuất khóa bí mật và khóa công khai thành tập tin
export-secret-key = Bạn có muốn đưa khóa bí mật vào tập tin khóa OpenPGP đã lưu không?
save-keys-ok = Khóa đã được lưu thành công
save-keys-failed = Không thể lưu khóa
refresh-key-warn = Cảnh báo: tùy thuộc vào số lượng khóa và tốc độ kết nối, việc làm mới tất cả các khóa có thể là một quá trình khá dài!
preview-failed = Không thể đọc tập tin khóa công khai.
general-error = Lỗi: { $reason }
dlg-button-delete = Xóa (&D)

## Account settings export output

openpgp-export-public-success = <b>Đã xuất thành công khóa công khai!</b>
openpgp-export-public-fail = <b>Không thể xuất khóa công khai đã chọn!</b>
openpgp-export-secret-success = <b>Đã xuất khóa bí mật!</b>
openpgp-export-secret-fail = <b>Không thể xuất khóa bí mật đã chọn!</b>
# Strings in keyObj.jsm
key-ring-pub-key-revoked = Khóa { $userId } (ID khóa { $keyId }) đã bị thu hồi.
key-ring-pub-key-expired = Khóa { $userId } (ID khóa { $keyId }) đã hết hạn.
key-ring-no-secret-key = Dường như bạn không có khóa bí mật cho { $userId } (ID khóa { $keyId }) trên khóa của mình; bạn không thể sử dụng khóa để ký.
key-ring-pub-key-not-for-signing = Không thể sử dụng khóa { $userId } (ID khóa { $keyId }) để ký.
key-ring-pub-key-not-for-encryption = Không thể sử dụng khóa { $userId } (ID khóa { $keyId }) để mã hóa.
key-ring-enc-sub-keys-revoked = Tất cả các khóa mã hóa con của khóa { $userId } (ID khóa { $keyId }) đã bị thu hồi.
key-ring-enc-sub-keys-expired = Tất cả các khóa mã hóa con của khóa { $userId } (ID khóa { $keyId }) đã hết hạn.
# Strings in gnupg-keylist.jsm
keyring-photo = Hình ảnh
user-att-photo = Thuộc tính người dùng (hình ảnh JPEG)
# Strings in key.jsm
already-revoked = Khóa này đã bị thu hồi trước đó.
#   $keyId (String) - the id of the key being revoked
revoke-key-already-revoked = Khóa 0x{ $keyId } đã bị thu hồi trước đó.
key-man-button-revoke-key = Thu hồi khóa (&R)
openpgp-key-revoke-success = Đã thu hồi khóa thành công.
after-revoke-info =
    Khóa đã bị thu hồi.
    Chia sẻ lại khóa công khai này bằng cách gửi qua email hoặc tải lên máy chủ để cho người khác biết rằng bạn đã thu hồi khóa của mình.
    Ngay sau khi phần mềm được người khác sử dụng biết về việc thu hồi, nó sẽ ngừng sử dụng khóa cũ của bạn.
    Nếu bạn đang sử dụng khóa mới cho cùng một địa chỉ email và bạn đính kèm khóa công khai mới vào các email bạn gửi, thì thông tin về khóa cũ đã thu hồi của bạn sẽ tự động được đưa vào.
# Strings in keyRing.jsm & decryption.jsm
key-man-button-import = Nhập (&I)
delete-key-title = Xóa khóa OpenPGP
key-in-use-title = Khóa OpenPGP hiện đang được sử dụng
delete-key-in-use-description = Không thể tiếp tục! Chìa khóa bạn đã chọn để xóa hiện đang được sử dụng bởi danh tính này. Chọn một khóa khác hoặc chọn không có khóa nào và thử lại.
revoke-key-in-use-description = Không thể tiếp tục! Chìa khóa bạn đã chọn để thu hồi hiện đang được sử dụng bởi danh tính này. Chọn một khóa khác hoặc chọn không có khóa nào và thử lại.
key-error-not-accepted-as-personal = Bạn chưa xác nhận rằng khóa có ID ‘{ $keySpec }’ là khóa cá nhân của bạn.
# Strings used in enigmailKeyManager.js & windows.jsm
need-online = Chức năng bạn đã chọn không khả dụng ở chế độ ngoại tuyến. Vui lòng truy cập trực tuyến và thử lại.
# Strings used in keyRing.jsm & keyLookupHelper.jsm
no-key-found2 = Chúng tôi không thể tìm thấy bất kỳ khóa có thể sử dụng nào phù hợp với tiêu chí tìm kiếm được chỉ định.
no-update-found = Bạn đã có các khóa được phát hiện trực tuyến.
fail-key-import = Lỗi - nhập khóa không thành công
file-write-failed = Không thể ghi vào tập tin { $output }
confirm-permissive-import = Nhập không thành công. Khóa bạn đang cố gắng nhập có thể bị hỏng hoặc sử dụng các thuộc tính không xác định. Bạn có muốn cố gắng nhập các bộ phận chính xác không? Điều này có thể dẫn đến việc nhập các khóa không đầy đủ và không sử dụng được.
# Strings used in trust.jsm
key-valid-unknown = không rõ
key-valid-invalid = không hợp lệ
key-valid-disabled = đã vô hiệu hóa
key-valid-revoked = bị thu hồi
key-valid-expired = đã hết hạn
key-trust-untrusted = không đáng tin cậy
key-trust-full = đáng tin cậy
key-trust-group = (nhóm)
# Strings used in commonWorkflows.js
import-key-file = Nhập tập tin khóa OpenPGP
gnupg-file = Tập tin GnuPG
import-keys-failed = Nhập khóa không thành công
passphrase-prompt = Vui lòng nhập cụm mật khẩu để mở khóa sau: { $key }
file-to-big-to-import = Tập tin này quá lớn. Vui lòng không nhập một bộ khóa lớn cùng một lúc.
gen-going = Đã ở trong quá trình tạo khóa!
keygen-missing-user-name = Không có tên được chỉ định cho tài khoản/danh tính đã chọn. Vui lòng nhập một giá trị vào trường  “Tên của bạn” trong cài đặt tài khoản.
expiry-too-short = Khóa của bạn phải có giá trị trong ít nhất một ngày.
expiry-too-long = Bạn không thể tạo khóa hết hạn sau hơn 100 năm.
key-confirm = Tạo khóa công khai và khóa bí mật cho ‘{ $id }’?
key-man-button-generate-key = &Tạo khóa
key-abort = Hủy việc tạo khóa?
key-man-button-generate-key-abort = &Huỷ bỏ tạo khoá
key-man-button-generate-key-continue = &Tiếp tục tạo khóa

# Strings used in enigmailMessengerOverlay.js

failed-decrypt = Lỗi - giải mã không thành công
fix-broken-exchange-msg-failed = Không thể sửa chữa thư này.
attachment-no-match-from-signature = Tập tin chữ ký ‘{ $attachment }’ với tập tin đính kèm không khớp
attachment-no-match-to-signature = Tập tin đính kèm ‘{ $attachment }’ với tập tin chữ ký không khớp
signature-verified-ok = Chữ ký cho tập tin đính kèm { $attachment } đã được xác minh thành công
signature-verify-failed = Không thể xác minh chữ ký cho tập tin đính kèm { $attachment }
decrypt-ok-no-sig =
    Cảnh báo
    Giải mã thành công nhưng không thể xác minh chính xác chữ ký
msg-ovl-button-cont-anyway = &Vẫn tiếp tục
enig-content-note = *Các tập tin đính kèm cho thư này chưa được ký hoặc chưa được mã hóa*
# Strings used in enigmailMsgComposeOverlay.js
msg-compose-button-send = &Gửi thư
msg-compose-details-button-label = Chi tiết…
msg-compose-details-button-access-key = D
send-aborted = Thao tác gửi đã bị hủy bỏ.
key-not-trusted = Không đủ tin cậy cho khóa ‘{ $key }’
key-not-found = Không tìm thấy khóa ‘{ $key }’
key-revoked = Đã thu hồi khóa ‘{ $key }’
key-expired = Khóa ‘{ $key }’ đã hết hạn
msg-compose-internal-error = Đã xảy ra một lỗi nội bộ.
keys-to-export = Chọn khóa OpenPGP để chèn
msg-compose-partially-encrypted-inlinePGP =
    Thư bạn đang trả lời chứa cả phần không được mã hóa và phần được mã hóa. Nếu ban đầu người gửi không thể giải mã một số phần thư, bạn có thể đang làm rò rỉ thông tin bí mật mà ban đầu người gửi không thể giải mã.
    Vui lòng xem xét xóa tất cả văn bản được trích dẫn khỏi thư trả lời của bạn cho người gửi này.
msg-compose-cannot-save-draft = Lỗi khi lưu bản nháp
msg-compose-partially-encrypted-short = Cẩn thận với việc rò rỉ thông tin nhạy cảm - email được mã hóa một phần.
minimal-line-wrapping =
    Bạn đã đặt số lượng ký tự trong một dòng là { $width } kí tự. Để mã hóa và/hoặc ký chính xác, giá trị này ít nhất phải là 68.
    Bạn có muốn đặt lại giá trị của nó thành 68 kí tự ngay bây giờ không?
sending-news =
    Thao tác gửi được mã hóa đã bị hủy bỏ.
    Không thể mã hóa thư này vì có người nhận trong nhóm tin. Vui lòng gửi lại tin nhắn mà không mã hóa.
send-to-news-warning =
    Cảnh báo: bạn sắp gửi một email được mã hóa đến một nhóm tin.
    Điều này không được khuyến khích vì nó chỉ có ý nghĩa nếu tất cả các thành viên trong nhóm có thể giải mã thông điệp, tức là tin nhắn cần được mã hóa bằng khóa của tất cả những người tham gia nhóm. Vui lòng chỉ gửi tin nhắn này nếu bạn biết chính xác những gì bạn đang làm.
    Tiếp tục?
save-attachment-header = Lưu tập tin đính kèm được giải mã
cannot-send-sig-because-no-own-key = Không thể ký điện tử thông báo này vì bạn chưa định cấu hình mã hóa đầu cuối cho <{ $key }>
cannot-send-enc-because-no-own-key = Không thể gửi thư đã mã hóa này vì bạn chưa định cấu hình mã hóa đầy cuối cho <{ $key }>
# Strings used in decryption.jsm
do-import-multiple =
    Nhập các khóa sau?
    { $key }
do-import-one = Nhập { $name } ({ $id })?
cant-import = Lỗi khi nhập khóa công khai
unverified-reply = Phần thư thụt lề (trả lời) có thể đã được sửa đổi
key-in-message-body = Một khóa đã được tìm thấy trong nội dung thư. Nhấp vào 'Nhập khóa' để nhập khóa
sig-mismatch = Lỗi - Chữ ký không khớp
invalid-email = Lỗi - (Các) địa chỉ email không hợp lệ
attachment-pgp-key =
    Tập tin đính kèm ‘{ $name }’ mà bạn đang mở có vẻ là một tập tin khóa OpenPGP.
    Nhấp vào 'Nhập' để nhập các khóa có trong hoặc 'Xem' để xem nội dung tập tin trong cửa sổ trình duyệt
dlg-button-view = &Xem
# Strings used in enigmailMsgHdrViewOverlay.js
decrypted-msg-with-format-error = Thư đã được giải mã (đã khôi phục định dạng email PGP bị hỏng có thể do máy chủ Exchange cũ gây ra, do đó, kết quả có thể không hoàn hảo để đọc)
# Strings used in encryption.jsm
not-required = Lỗi - không cần mã hóa
# Strings used in windows.jsm
no-photo-available = Không có sẵn ảnh
error-photo-path-not-readable = Không thể đọc đường dẫn ảnh ‘{ $photo }’
debug-log-title = Nhật ký gỡ lỗi OpenPGP
# Strings used in dialog.jsm
repeat-prefix = Cảnh báo này sẽ lặp lại { $count }
repeat-suffix-singular = lần nữa.
repeat-suffix-plural = lần nữa.
no-repeat = Cảnh báo này sẽ không được hiển thị lại.
dlg-keep-setting = Nhớ câu trả lời của tôi và không hỏi lại tôi
dlg-button-ok = &OK
dlg-button-close = Đóng (&C)
dlg-button-cancel = &Hủy bỏ
dlg-no-prompt = Không hiện lại hộp thoại này
enig-prompt = Lời nhắc OpenPGP
enig-confirm = Xác nhận OpenPGP
enig-alert = Cảnh báo OpenPGP
enig-info = Thông tin OpenPGP
# Strings used in persistentCrypto.jsm
dlg-button-retry = &Thử lại
dlg-button-skip = &Bỏ qua
# Strings used in enigmailMsgBox.js
enig-alert-title =
    .title = Cảnh báo OpenPGP
