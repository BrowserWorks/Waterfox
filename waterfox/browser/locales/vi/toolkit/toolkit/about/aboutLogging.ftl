# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This is the title of the page
about-logging-title = Giới thiệu về ghi nhật ký
about-logging-page-title = Trình quản lý ghi nhật ký
about-logging-current-log-file = Tập tin nhật ký hiện tại:
about-logging-new-log-file = Tập tin nhật ký mới:
about-logging-currently-enabled-log-modules = Các mô-đun nhật ký hiện được bật:
about-logging-log-tutorial = Xem <a data-l10n-name="logging">nhật ký HTTP</a> để biết hướng dẫn về cách sử dụng công cụ này.
# This message is used as a button label, "Open" indicates an action.
about-logging-open-log-file-dir = Mở thư mục
about-logging-set-log-file = Đặt tập tin nhật ký
about-logging-set-log-modules = Đặt mô-đun nhật ký
about-logging-start-logging = Bắt đầu ghi
about-logging-stop-logging = Dừng ghi
about-logging-buttons-disabled = Ghi nhật ký được định cấu hình thông qua các biến môi trường, cấu hình động không khả dụng.
about-logging-some-elements-disabled = Ghi nhật ký được định cấu hình qua URL, một số tùy chọn cấu hình hiện không khả dụng
about-logging-info = Thông tin:
about-logging-log-modules-selection = Lựa chọn mô-đun nhật ký
about-logging-new-log-modules = Mô-đun nhật ký mới:
about-logging-logging-output-selection = Nơi xuất ghi nhật ký
about-logging-logging-to-file = Ghi vào một tập tin
about-logging-logging-to-profiler = Ghi vào { -profiler-brand-name }
about-logging-no-log-modules = Không
about-logging-no-log-file = Không
about-logging-logging-preset-selector-text = Ghi nhật ký đặt trước:

## Logging presets

about-logging-preset-networking-label = Kết nối mạng
about-logging-preset-networking-description = Ghi nhật ký các mô-đun để chẩn đoán các sự cố mạng
about-logging-preset-networking-cookie-label = Cookie
about-logging-preset-networking-cookie-description = Ghi nhật ký của các module để chẩn đoán các vấn đề về cookie
about-logging-preset-networking-websocket-label = WebSockets
about-logging-preset-networking-websocket-description = Ghi nhật ký của các module để chẩn đoán các sự cố WebSocket
about-logging-preset-networking-http3-label = HTTP/3
about-logging-preset-networking-http3-description = Ghi nhật ký của các module để chẩn đoán các sự cố HTTP/3 và QUIC
about-logging-preset-media-playback-label = Trình phát phương tiện
about-logging-preset-media-playback-description = Ghi nhật ký mô-đun để chẩn đoán sự cố trình phát phương tiện (không phải sự cố về cuộc gọi trực tuyến)
about-logging-preset-webrtc-label = WebRTC
about-logging-preset-webrtc-description = Ghi nhật ký của các module để chẩn đoán cuộc gọi WebRTC
about-logging-preset-custom-label = Tùy chọn
about-logging-preset-custom-description = Ghi nhật ký mô-đun được chọn theo cách thủ công
# Error handling
about-logging-error = Lỗi:

## Variables:
##   $k (String) - Variable name
##   $v (String) - Variable value

about-logging-invalid-output = Giá trị không hợp lệ “{ $v }“ cho khóa “{ $k }“
about-logging-unknown-logging-preset = Cài đặt trước ghi nhật ký không xác định “{ $v }“
about-logging-unknown-profiler-preset = Giá trị đặt trước của profiler không xác định “{ $v }“
about-logging-unknown-option = Tùy chọn about:logging không xác định “{ $k }“
about-logging-configuration-url-ignored = URL cấu hình bị bỏ qua
about-logging-file-and-profiler-override = Không thể buộc nơi xuất tập tin và ghi đè các tùy chọn profiler cùng một lúc
about-logging-configured-via-url = Tùy chọn được định cấu hình qua URL
