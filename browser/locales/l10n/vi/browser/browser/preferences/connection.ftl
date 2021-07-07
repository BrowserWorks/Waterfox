# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = Cài đặt kết nối
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }

connection-close-key =
    .key = w

connection-disable-extension =
    .label = Vô hiệu hóa tiện ích mở rộng

connection-proxy-configure = Cấu hình proxy để truy cập Internet

connection-proxy-option-no =
    .label = Không dùng proxy
    .accesskey = y
connection-proxy-option-system =
    .label = Dùng các thiết lập proxy của hệ thống
    .accesskey = D
connection-proxy-option-auto =
    .label = Tự động dò thiết lập của proxy cho mạng này
    .accesskey = m
connection-proxy-option-manual =
    .label = Cấu hình proxy thủ công
    .accesskey = m

connection-proxy-http = Proxy HTTP
    .accesskey = x
connection-proxy-http-port = Cổng
    .accesskey = C

connection-proxy-https-sharing =
    .label = Đồng thời sử dụng proxy này cho HTTPS
    .accesskey = s

connection-proxy-https = HTTPS Proxy
    .accesskey = H
connection-proxy-ssl-port = Cổng
    .accesskey = :

connection-proxy-socks = Máy chủ SOCKS
    .accesskey = C
connection-proxy-socks-port = Cổng
    .accesskey = g

connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = 4
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = 5
connection-proxy-noproxy = Không dùng proxy cho
    .accesskey = n

connection-proxy-noproxy-desc = Ví dụ: .mozilla.org, .edu.vn, 192.168.1.0/24

# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = Kết nối đến localhost, 127.0.0.1/8, và ::1 không bao giờ dùng proxy.

connection-proxy-autotype =
    .label = URL cấu hình proxy tự động
    .accesskey = A

connection-proxy-reload =
    .label = Tải lại
    .accesskey = i

connection-proxy-autologin =
    .label = Không yêu cầu xác nhận nếu đã lưu mật khẩu
    .accesskey = n
    .tooltip = Tùy chọn này xác thực ngầm bạn với proxy khi bạn đã lưu thông tin ủy nhiệm của chúng. Bạn sẽ được yêu cầu nếu việc xác thực thất bại.

connection-proxy-socks-remote-dns =
    .label = DNS của proxy khi dùng SOCKS v5
    .accesskey = d

connection-dns-over-https =
    .label = Kích hoạt DNS over HTTPS
    .accesskey = b

connection-dns-over-https-url-resolver = Sử dụng nhà cung cấp
    .accesskey = c

# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Mặc định)
    .tooltiptext = Sử dụng đường dẫn mặc định để phân giải DNS over HTTPS

connection-dns-over-https-url-custom =
    .label = Tùy chỉnh
    .accesskey = C
    .tooltiptext = Nhập URL ưa thích của bạn để phân giải DNS over HTTPS

connection-dns-over-https-custom-label = Tùy biến
