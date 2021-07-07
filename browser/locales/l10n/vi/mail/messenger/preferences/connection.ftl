# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-dns-over-https-url-resolver = Sử dụng nhà cung cấp
    .accesskey = r
# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (Mặc định)
    .tooltiptext = Sử dụng URL mặc định để xử lý DNS qua HTTPS
connection-dns-over-https-url-custom =
    .label = Tùy chỉnh
    .accesskey = C
    .tooltiptext =
        Nhập URL ưa thích của bạn để giải quyết DNS qua HTTPS
        Nhập URL ưa thích của bạn để giải quyết DNS qua HTTPS
        Nhập URL ưa thích của bạn để giải quyết DNS qua HTTPS
        Nhập URL ưa thích của bạn để xử lí DNS qua HTTPS
connection-dns-over-https-custom-label = Tùy chỉnh
connection-dialog-window =
    .title = Cài đặt kết nối
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 49em !important
        }
connection-disable-extension =
    .label = Vô hiệu hóa tiện ích mở rộng
connection-proxy-legend = Định cấu hình proxy để truy cập Internet
proxy-type-no =
    .label = Không dùng proxy
    .accesskey = y
proxy-type-wpad =
    .label = Tự động phát hiện cài đặt proxy cho mạng này
    .accesskey = w
proxy-type-system =
    .label = Sử dụng cài đặt proxy của hệ thống
    .accesskey = u
proxy-type-manual =
    .label = Cấu hình proxy thủ công:
    .accesskey = m
proxy-http-label =
    .value = Proxy HTTP:
    .accesskey = h
http-port-label =
    .value = Cổng:
    .accesskey = p
proxy-http-sharing =
    .label = Đồng thời sử dụng proxy này cho HTTPS
    .accesskey = x
proxy-https-label =
    .value = HTTPS Proxy:
    .accesskey = S
ssl-port-label =
    .value = Cổng:
    .accesskey = o
proxy-socks-label =
    .value = Máy chủ SOCKS:
    .accesskey = c
socks-port-label =
    .value = Cổng:
    .accesskey = t
proxy-socks4-label =
    .label = SOCKS v4
    .accesskey = k
proxy-socks5-label =
    .label = SOCKS v5
    .accesskey = v
proxy-type-auto =
    .label = URL cấu hình proxy tự động:
    .accesskey = A
proxy-reload-label =
    .label = Tải lại
    .accesskey = l
no-proxy-label =
    .value = Không dùng proxy cho:
    .accesskey = n
no-proxy-example = Ví dụ: .mozilla.org, .net.nz, 192.168.1.0/24
# Note: Do not translate localhost, 127.0.0.1 and ::1.
no-proxy-localhost-label = Các kết nối với localhost, 127.0.0.1 và :: 1 không bao giờ được ủy quyền.
# Do not translate "localhost", "127.0.0.1/8" and "::1". (You can translate "and".)
connection-proxy-noproxy-localhost-desc-2 = Kết nối đến localhost, 127.0.0.1/8, và ::1 không bao giờ dùng proxy.
proxy-password-prompt =
    .label = Không yêu cầu xác nhận nếu đã lưu mật khẩu
    .accesskey = i
    .tooltiptext = Tùy chọn này âm thầm xác thực bạn với proxy khi bạn đã lưu thông tin đăng nhập cho họ. Bạn sẽ được nhắc nếu xác thực thất bại.
proxy-remote-dns =
    .label = DNS của proxy khi dùng SOCKS v5
    .accesskey = d
proxy-enable-doh =
    .label = Kích hoạt DNS qua HTTPS
    .accesskey = b
