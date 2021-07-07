# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Chứng chỉ

## Error messages

certificate-viewer-error-message = Chúng tôi không thể tìm thấy thông tin chứng chỉ, hoặc chứng chỉ bị hỏng. Vui lòng thử lại.
certificate-viewer-error-title = Có gì đó không ổn.

## Certificate information labels

certificate-viewer-algorithm = Thuật toán
certificate-viewer-certificate-authority = Cơ quan cấp chứng chỉ
certificate-viewer-cipher-suite = Bộ mật mã
certificate-viewer-common-name = Tên gọi chung
certificate-viewer-email-address = Địa chỉ email
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Chứng nhận cho { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Quốc gia hợp nhất
certificate-viewer-country = Quốc gia
certificate-viewer-curve = Đường cong
certificate-viewer-distribution-point = Điểm phát hành
certificate-viewer-dns-name = Tên DNS
certificate-viewer-ip-address = Địa chỉ IP
certificate-viewer-other-name = Tên khác
certificate-viewer-exponent = Chỉ số
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Nhóm trao đổi khóa
certificate-viewer-key-id = ID khóa
certificate-viewer-key-size = Kích thước khóa
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Địa phương hợp nhất
certificate-viewer-locality = Thành phố
certificate-viewer-location = Địa chỉ
certificate-viewer-logid = ID bản ghi
certificate-viewer-method = Phương thức
certificate-viewer-modulus = Mô-đun
certificate-viewer-name = Tên
certificate-viewer-not-after = Hiệu lực đến
certificate-viewer-not-before = Hiệu lực từ
certificate-viewer-organization = Tổ chức
certificate-viewer-organizational-unit = Đơn vị tổ chức
certificate-viewer-policy = Chính sách
certificate-viewer-protocol = Giao thức
certificate-viewer-public-value = Giá trị công khai
certificate-viewer-purposes = Mục đích
certificate-viewer-qualifier = Hạn định
certificate-viewer-qualifiers = Hạn định
certificate-viewer-required = Bắt buộc
certificate-viewer-unsupported = &lt;không được hỗ trợ&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Nhà nước/tỉnh hợp nhất
certificate-viewer-state-province = Tỉnh
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Số sê-ri
certificate-viewer-signature-algorithm = Thuật toán chữ ký
certificate-viewer-signature-scheme = Sơ đồ chữ ký
certificate-viewer-timestamp = Dấu thời gian
certificate-viewer-value = Giá trị
certificate-viewer-version = Phiên bản
certificate-viewer-business-category = Hạng mục kinh doanh
certificate-viewer-subject-name = Tên chủ đề
certificate-viewer-issuer-name = Tên nhà cung cấp
certificate-viewer-validity = Tính hiệu lực
certificate-viewer-subject-alt-names = Tên chủ đề thay thế
certificate-viewer-public-key-info = Thông tin khóa công khai
certificate-viewer-miscellaneous = Thông tin khác
certificate-viewer-fingerprints = Dấu vân tay
certificate-viewer-basic-constraints = Những ràng buộc cơ bản
certificate-viewer-key-usages = Công dụng chính
certificate-viewer-extended-key-usages = Công dụng mở rộng
certificate-viewer-ocsp-stapling = OCSP Stapling
certificate-viewer-subject-key-id = ID khóa chủ đề
certificate-viewer-authority-key-id = ID khóa thẩm quyền
certificate-viewer-authority-info-aia = Thông tin thẩm quyền (AIA)
certificate-viewer-certificate-policies = Chính sách chứng chỉ
certificate-viewer-embedded-scts = SCT tích hợp
certificate-viewer-crl-endpoints = Điểm cuối CRL
# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Nội dung
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Có
       *[false] Không
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (chứng chỉ)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (chain)
    .download = { $fileName }-chain.pem
# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Tiện ích mở rộng này đã được đánh dấu là nghiêm trọng, có nghĩa là khách hàng phải từ chối chứng chỉ nếu họ không hiểu nó.
certificate-viewer-export = Xuất
    .download = { $fileName }.pem

##

# Label for a tab where we haven't found a better label:
certificate-viewer-unknown-group-label = (không xác định)

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Chứng nhận của bạn
certificate-viewer-tab-people = Mọi người
certificate-viewer-tab-servers = Máy chủ
certificate-viewer-tab-ca = Nhà thẩm định
certificate-viewer-tab-unkonwn = Không rõ
