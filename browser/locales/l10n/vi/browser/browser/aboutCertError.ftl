# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } sử dụng một chứng nhận bảo mật không hợp lệ.

cert-error-mitm-intro = Các trang web chứng minh danh tính của họ thông qua các chứng nhận, được cấp bởi các cơ quan chứng nhận.

cert-error-mitm-mozilla = { -brand-short-name } được hỗ trợ bởi Waterfox phi lợi nhuận, nơi quản lý một cửa hàng ủy quyền chứng nhận (CA) hoàn toàn mở. Cửa hàng CA giúp đảm bảo rằng các cơ quan cấp chứng nhận đang tuân theo các thực tiễn tốt nhất để bảo mật người dùng.

cert-error-mitm-connection = { -brand-short-name } sử dụng cửa hàng Waterfox CA để xác minh rằng kết nối là an toàn, thay vì các chứng nhận được cung cấp bởi hệ điều hành của người dùng. Vì vậy, nếu chương trình chống vi-rút hoặc mạng đang chặn kết nối với chứng nhận bảo mật do CA không có trong cửa hàng Waterfox CA, kết nối được coi là không an toàn.

cert-error-trust-unknown-issuer-intro = Ai đó có thể đang cố gắng mạo danh trang web và bạn không nên tiếp tục.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Trang web chứng minh danh tính của họ thông qua các chứng nhận. { -brand-short-name } không tin tưởng { $hostname } vì nhà phát hành chứng nhận của nó không xác định, chứng nhận tự ký hoặc máy chủ không gửi chứng nhận trung gian chính xác.

cert-error-trust-cert-invalid = Chứng nhận không đáng tin vì nó được cấp phát bởi một chứng nhận CA không hợp lệ.

cert-error-trust-untrusted-issuer = Chứng nhận không đáng tin cậy vì chứng nhận của bên cấp phát không đáng tin cậy.

cert-error-trust-signature-algorithm-disabled = Chứng nhận không đáng tin cậy vì được ký bằng một thuật toán đã bị vô hiệu do không an toàn.

cert-error-trust-expired-issuer = Chứng nhận không đáng tin cậy vì chứng nhận bên cấp phát đã hết hạn.

cert-error-trust-self-signed = Chứng nhận này không đáng tin cậy vì nó được tự ký.

cert-error-trust-symantec = Chứng nhận do GeoTrust, RapidSSL, Symantec, Thawte và VeriSign cấp không còn được coi là an toàn vì các cơ quan cấp chứng nhận này đã không tuân theo các thực tiễn bảo mật trong quá khứ.

cert-error-untrusted-default = Chứng nhận không thuộc về một nguồn đáng tin cậy.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Trang web chứng minh danh tính của họ thông qua các chứng nhận. { -brand-short-name } không tin tưởng trang web này vì nó sử dụng chứng nhận không hợp lệ cho { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Trang web chứng minh danh tính của họ thông qua các chứng nhận. { -brand-short-name } không tin tưởng trang web này vì nó sử dụng chứng nhận không hợp lệ cho { $hostname }. Chứng nhận chỉ có giá trị cho <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Trang web chứng minh danh tính của họ thông qua các chứng nhận. { -brand-short-name } không tin tưởng trang web này vì nó sử dụng chứng nhận không hợp lệ cho { $hostname }. Chứng nhận chỉ có giá trị cho { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Trang web chứng minh danh tính của họ thông qua các chứng nhận. { -brand-short-name } không tin tưởng trang web này vì nó sử dụng chứng nhận không hợp lệ cho { $hostname }. Chứng nhận chỉ có giá trị cho các tên sau: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Các trang web chứng minh danh tính của họ thông qua các chứng nhận, có giá trị trong một khoảng thời gian đã đặt. Chứng nhận cho { $hostname } đã hết hạn vào { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Các trang web chứng minh danh tính của họ thông qua các chứng nhận, có giá trị trong một khoảng thời gian đã đặt. Chứng nhận cho { $hostname } sẽ không có giá trị cho đến { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Mã lỗi: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Các trang web chứng minh danh tính của họ thông qua các chứng nhận, được cấp bởi các cơ quan chứng nhận. Hầu hết các trình duyệt không còn tin tưởng các chứng chỉ do GeoTrust, RapidSSL, Symantec, Thawte và VeriSign cấp. { $hostname } sử dụng chứng nhận từ một trong những cơ quan này và do đó, danh tính của trang web không thể chứng minh được.

cert-error-symantec-distrust-admin = Bạn có thể thông báo cho quản trị viên trang web về vấn đề này.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Chuỗi chứng nhận:

open-in-new-window-for-csp-or-xfo-error = Mở trang web trong cửa sổ mới

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Để bảo vệ tính bảo mật của bạn, { $hostname } sẽ không cho phép { -brand-short-name } hiển thị trang nếu một trang web khác đã nhúng nó. Để xem trang này, bạn cần mở nó trong một cửa sổ mới.

## Messages used for certificate error titles

connectionFailure-title = Không thể kết nối
deniedPortAccess-title = Địa chỉ này đã bị chặn
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm. Chúng tôi gặp khó khăn khi tìm trang web đó.
fileNotFound-title = Không tìm thấy tập tin
fileAccessDenied-title = Truy cập tập tin bị từ chối
generic-title = Lỗi.
captivePortal-title = Đăng nhập vào mạng
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Địa chỉ không đúng.
netInterrupt-title = Kết nối bị ngắt
notCached-title = Tài liệu đã hết hạn
netOffline-title = Chế độ ngoại tuyến
contentEncodingError-title = Lỗi encoding
unsafeContentType-title = Kiểu tập tin không an toàn
netReset-title = Kết nối bị khởi tạo lại
netTimeout-title = Kết nối đã mất quá nhiều thời gian
unknownProtocolFound-title = Chương trình không hiểu địa chỉ này
proxyConnectFailure-title = Máy chủ proxy từ chối kết nối
proxyResolveFailure-title = Không tìm thấy máy chủ proxy
redirectLoop-title = Trang này không chuyển hướng đúng cách
unknownSocketType-title = Nhận được phản hồi lạ từ máy chủ
nssFailure2-title = Không thể kết nối an toàn
csp-xfo-error-title = { -brand-short-name } không thể mở trang này
corruptedContentError-title = Lỗi nội dung bị hỏng
remoteXUL-title = Remote XUL
sslv3Used-title = Không thể kết nối một cách an toàn
inadequateSecurityError-title = Kết nối của bạn không an toàn
blockedByPolicy-title = Trang bị chặn
clockSkewError-title = Đồng hồ trên máy tính của bạn không đúng
networkProtocolError-title = Lỗi giao thức mạng
nssBadCert-title = Cảnh báo: Rủi ro bảo mật tiềm ẩn
nssBadCert-sts-title = Không kết nối: Sự cố bảo mật tiềm ẩn
certerror-mitm-title = Phần mềm đang ngăn chặn { -brand-short-name } từ kết nối an toàn đến trang web này
