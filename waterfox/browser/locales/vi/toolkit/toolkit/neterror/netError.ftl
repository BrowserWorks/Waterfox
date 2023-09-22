# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = Sự cố khi tải trang
certerror-page-title = Cảnh báo: Rủi ro bảo mật tiềm ẩn
certerror-sts-page-title = Không kết nối: Sự cố bảo mật tiềm ẩn
neterror-blocked-by-policy-page-title = Trang bị chặn
neterror-captive-portal-page-title = Đăng nhập vào mạng
neterror-dns-not-found-title = Không tìm thấy máy chủ
neterror-malformed-uri-page-title = URL không hợp lệ

## Error page actions

neterror-advanced-button = Nâng cao…
neterror-copy-to-clipboard-button = Sao chép văn bản vào bộ nhớ tạm
neterror-learn-more-link = Tìm hiểu thêm…
neterror-open-portal-login-page-button = Mở trang đăng nhập mạng
neterror-override-exception-button = Chấp nhận rủi ro và tiếp tục
neterror-pref-reset-button = Khôi phục cài đặt mặc định
neterror-return-to-previous-page-button = Quay lại
neterror-return-to-previous-page-recommended-button = Quay lại (Khuyến nghị)
neterror-try-again-button = Thử lại
neterror-add-exception-button = Luôn luôn tiếp tục cho trang web này
neterror-settings-button = Thay đổi cài đặt DNS
neterror-view-certificate-link = Xem chứng chỉ
neterror-trr-continue-this-time = Tiếp tục lần này
neterror-disable-native-feedback-warning = Luôn luôn tiếp tục

##

neterror-pref-reset = Dường như là cài đặt bảo mật mạng của bạn có thể gây ra điều này. Bạn có muốn khôi phục cài đặt mặc định?
neterror-error-reporting-automatic = Báo cáo những lỗi như thế này để giúp { -vendor-short-name } nhận diện và chặn những trang độc hại

## Specific error messages

neterror-generic-error = Vì lý do nào đó, { -brand-short-name } không thể mở trang này.
neterror-load-error-try-again = Trang web này có thể bị gián đoạn tạm thời hoặc do quá tải. Hãy thử lại trong chốc lát.
neterror-load-error-connection = Nếu bạn không thể mở bất kì trang nào, hãy kiểm tra kết nối mạng.
neterror-load-error-firewall = Nếu máy tính hoặc mạng của bạn được bảo vệ bởi tường lửa hoặc proxy, hãy chắc chắn rằng { -brand-short-name } được phép truy cập Web.
neterror-captive-portal = Bạn cần đăng nhập vào mạng trước khi có thể truy cập Internet.
# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = Ý bạn là truy cập đến trang web <a data-l10n-name="website">{ $hostAndPath }</a>?
neterror-dns-not-found-hint-header = <strong>Nếu bạn đã nhập đúng địa chỉ, bạn có thể:</strong>
neterror-dns-not-found-hint-try-again = Thử lại sau
neterror-dns-not-found-hint-check-network = Kiểm tra kết nối mạng của bạn
neterror-dns-not-found-hint-firewall = Kiểm tra xem { -brand-short-name } có quyền truy cập web hay không (bạn có thể được kết nối nhưng có tường lửa)

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = { -brand-short-name } không thể bảo vệ yêu cầu của bạn về địa chỉ trang web này thông qua trình phân giải DNS đáng tin cậy của chúng tôi. Đây là lý do tại sao:
neterror-dns-not-found-trr-third-party-warning2 = Bạn có thể tiếp tục với trình phân giải DNS mặc định của mình. Tuy nhiên, bên thứ ba có thể xem những trang web bạn truy cập.
neterror-dns-not-found-trr-only-could-not-connect = { -brand-short-name } không thể kết nối đến { $trrDomain }.
neterror-dns-not-found-trr-only-timeout = Kết nối tới { $trrDomain } mất nhiều thời gian hơn dự kiến.
neterror-dns-not-found-trr-offline = Bạn không kết nối với Internet.
neterror-dns-not-found-trr-unknown-host2 = { $trrDomain } không tìm thấy trang web này.
neterror-dns-not-found-trr-server-problem = Đã xảy ra sự cố với { $trrDomain }.
neterror-dns-not-found-bad-trr-url = URL không hợp lệ.
neterror-dns-not-found-trr-unknown-problem = Sự cố không xác định.

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = { -brand-short-name } không thể bảo vệ yêu cầu của bạn về địa chỉ trang web này thông qua trình phân giải DNS đáng tin cậy của chúng tôi. Đây là lý do tại sao:
neterror-dns-not-found-native-fallback-heuristic = DNS qua HTTPS đã bị tắt trên mạng của bạn.
neterror-dns-not-found-native-fallback-not-confirmed2 = { -brand-short-name } không thể kết nối với { $trrDomain }.

##

neterror-file-not-found-filename = Kiểm tra tên xem có lỗi gõ HOA-thường hay lỗi nào khác không.
neterror-file-not-found-moved = Kiểm tra xem tập tin có bị di chuyển, đổi tên hay bị xóa không.
neterror-access-denied = Nó có thể đã bị xóa, chuyển đi, hay quyền truy cập tập tin đã bị chặn.
neterror-unknown-protocol = Có lẽ bạn cần phải cài đặt phần mềm khác mới mở được.
neterror-redirect-loop = Vấn đề này thỉnh thoảng có thể xảy ra do bạn vô hiệu hóa hoặc từ chối cookie.
neterror-unknown-socket-type-psm-installed = Kiểm tra để chắc chắn rằng hệ thống của bạn có Trình quản lí Bảo mật Cá nhân đã được cài đặt.
neterror-unknown-socket-type-server-config = Điều này có thể là do cấu hình không chuẩn trên máy chủ.
neterror-not-cached-intro = Tài liệu được yêu cầu không có sẵn trong bộ đệm của { -brand-short-name }.
neterror-not-cached-sensitive = Vì lí do bảo mật, { -brand-short-name } không tự động tải lại các tài liệu nhạy cảm.
neterror-not-cached-try-again = Nhấn nút Thử Lại để yêu cầu tải lại tài liệu từ trang web.
neterror-net-offline = Nhấn “Thử lại” để chuyển sang chế độ trực tuyến và tải lại trang.
neterror-proxy-resolve-failure-settings = Kiểm tra thiết lập proxy.
neterror-proxy-resolve-failure-connection = Kiểm tra kết nối mạng.
neterror-proxy-resolve-failure-firewall = Nếu máy tính hoặc mạng được bảo vệ bởi tường lửa hoặc proxy, hãy chắc chắn rằng { -brand-short-name } được phép truy cập Web.
neterror-proxy-connect-failure-settings = Kiểm tra thiết lập proxy để chắc chắn rằng mọi thứ đều đúng.
neterror-proxy-connect-failure-contact-admin = Liên hệ với quản trị mạng của bạn để chắc chắn rằng máy chủ proxy  vẫn đang hoạt động.
neterror-content-encoding-error = Vui lòng liên hệ với chủ trang web để báo với họ về vấn đề này.
neterror-unsafe-content-type = Vui lòng liên hệ với chủ trang web để báo với họ về vấn đề này.
neterror-nss-failure-not-verified = Không thể hiển thị trang bạn muốn xem vì không thể kiểm tra tính xác thực của dữ liệu nhận được.
neterror-nss-failure-contact-website = Vui lòng liên hệ chủ trang web để báo với họ vấn đề này.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = { -brand-short-name } phát hiện một mối đe dọa bảo mật và không tiếp tục đến <b>{ $hostname }</b>. Nếu bạn truy cập trang web này, kẻ tấn công có thể cố gắng lấy cắp thông tin như mật khẩu, email hoặc chi tiết thẻ tín dụng của bạn.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = { -brand-short-name } phát hiện một mối đe dọa bảo mật tiềm năng và không tiếp tục đến <b>{ $hostname }</b> vì trang web này yêu cầu kết nối an toàn.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = { -brand-short-name } đã phát hiện sự cố và không tiếp tục đến <b>{ $hostname }</b>. Trang web định cấu hình sai hoặc đồng hồ máy tính của bạn không đúng.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b> rất có thể là một trang web an toàn, nhưng không thể thiết lập kết nối an toàn. Sự cố này xảy ra do <b>{ $mitm }</b>, có thể là phần mềm trên máy tính hoặc mạng của bạn.
neterror-corrupted-content-intro = Không thể hiển thị được trang mà bạn muốn xem vì có lỗi trong truyền tải dữ liệu.
neterror-corrupted-content-contact-website = Vui lòng liên hệ chủ trang web để báo họ về vấn đề này.
# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = Thông tin bổ sung: SSL_ERROR_UNSUPPORTED_VERSION
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> sử dụng công nghệ bảo mật lỗi thời và dễ bị tấn công. Một kẻ tấn công có thể dễ dàng làm lộ những thông tin mà bạn nghĩ là an toàn. Người quản lý trang web trước tiên sẽ cần phải sửa lỗi máy chủ trước khi bạn có thể vào trang.
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = Mã lỗi: NS_ERROR_NET_INADEQUATE_SECURITY
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = Đồng hồ máy tính của bạn hiện tại là { DATETIME($now, dateStyle: "medium") }, việc này ngăn chặn { -brand-short-name } từ kết nối an toàn. Để truy cập <b>{ $hostname }</b>, hãy cập nhật đồng hồ máy tính trong cài đặt hệ thống của bạn thành ngày, giờ và múi giờ hiện tại, sau đó làm mới <b>{ $hostname }</b>.
neterror-network-protocol-error-intro = Không thể hiển thị trang bạn đang cố xem vì lỗi trong giao thức mạng đã được phát hiện.
neterror-network-protocol-error-contact-website = Vui lòng liên hệ với chủ sở hữu trang web để thông báo cho họ về sự cố này.
certerror-expired-cert-second-para = Có vẻ như chứng chỉ của trang web đã hết hạn, việc này sẽ ngăn chặn { -brand-short-name } từ kết nối an toàn. Nếu bạn truy cập trang này, kẻ tấn công có thể cố gắng lấy cắp thông tin như mật khẩu, email hoặc chi tiết thẻ tín dụng của bạn.
certerror-expired-cert-sts-second-para = Có vẻ như chứng chỉ của trang web đã hết hạn, việc này sẽ ngăn chặn { -brand-short-name } từ kết nối an toàn.
certerror-what-can-you-do-about-it-title = Bạn có thể làm gì về nó?
certerror-unknown-issuer-what-can-you-do-about-it-website = Vấn đề rất có thể xảy ra với trang web và bạn không thể làm gì để giải quyết nó.
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = Nếu bạn đang sử dụng mạng công ty hoặc sử dụng phần mềm chống vi-rút, bạn có thể liên hệ với nhóm hỗ trợ để được trợ giúp. Bạn cũng có thể thông báo cho quản trị viên của trang web về sự cố.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = Đồng hồ máy tính của bạn được đặt thành { DATETIME($now, dateStyle: "medium") }. Đảm bảo máy tính của bạn được đặt đúng ngày, giờ và múi giờ trong cài đặt hệ thống của bạn, sau đó làm mới <b>{ $hostname }</b>.
certerror-expired-cert-what-can-you-do-about-it-contact-website = Nếu đồng hồ của bạn đã được đặt đúng thời điểm, trang web có thể bị định cấu hình sai và bạn không thể làm gì để giải quyết vấn đề. Bạn có thể thông báo cho quản trị viên của trang web về sự cố.
certerror-bad-cert-domain-what-can-you-do-about-it = Vấn đề rất có thể xảy ra với trang web và bạn không thể làm gì để giải quyết vấn đề này. Bạn có thể thông báo cho quản trị viên của trang web về sự cố.
certerror-mitm-what-can-you-do-about-it-antivirus = Nếu phần mềm chống vi-rút của bạn bao gồm một tính năng quét các kết nối được mã hóa (thường được gọi là “quét trang web” hoặc “quét https”), bạn có thể tắt tính năng đó. Nếu điều đó không hoạt động, bạn có thể gỡ bỏ và cài đặt lại phần mềm chống vi-rút.
certerror-mitm-what-can-you-do-about-it-corporate = Nếu bạn đang ở trong một mạng công ty, bạn có thể phải liên hệ với bộ phận CNTT của bạn.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = Nếu bạn không quen với <b>{ $mitm }</b>, thì đây có thể là một cuộc tấn công và bạn không nên tiếp tục đến trang web.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = Nếu bạn không quen với <b>{ $mitm }</b>, thì đây có thể là một cuộc tấn công và bạn không thể làm gì để truy cập trang web.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = <b>{ $hostname }</b> có chính sách bảo mật được gọi là HTTP Strict Transport Security (HSTS), có nghĩa là { -brand-short-name } chỉ có thể kết nối với nó một cách an toàn. Bạn không thể thêm ngoại lệ để truy cập trang web này.
