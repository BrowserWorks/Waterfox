# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Thông tin xử lý sự cố
page-subtitle = Trang này chứa thông tin kĩ thuật có thể có ích khi bạn đang cố giải quyết một vấn đề. Nếu bạn đang tìm câu trả lời cho các câu hỏi thông thường về { -brand-short-name }, hãy xem <a data-l10n-name="support-link">trang web hỗ trợ</a> của chúng tôi.
crashes-title = Trình báo cáo lỗi
crashes-id = ID báo cáo
crashes-send-date = Đã gửi
crashes-all-reports = Tất cả các báo cáo lỗi
crashes-no-config = Ứng dụng này chưa được thiết lập để hiển thị các báo cáo lỗi.
support-addons-title = Tiện ích
support-addons-name = Tên
support-addons-type = Kiểu
support-addons-enabled = Đã bật
support-addons-version = Phiên bản
support-addons-id = ID
legacy-user-stylesheets-title = Stylesheet của người dùng (cũ)
legacy-user-stylesheets-enabled = Hoạt động
legacy-user-stylesheets-stylesheet-types = Stylesheet
legacy-user-stylesheets-no-stylesheets-found = Không phát hiện stylesheet nào
security-software-title = Phần mềm bảo mật
security-software-type = Kiểu
security-software-name = Tên
security-software-antivirus = Trình chống vi-rút
security-software-antispyware = Trình chống phần mềm do thám
security-software-firewall = Tường lửa
features-title = Tính năng { -brand-short-name }
features-name = Tên
features-version = Phiên bản
features-id = ID
processes-title = Tiến trình từ xa
processes-type = Kiểu
processes-count = Tổng số
app-basics-title = Cơ bản về ứng dụng
app-basics-name = Tên
app-basics-version = Phiên bản
app-basics-build-id = ID bản dựng
app-basics-distribution-id = ID phát hành
app-basics-update-channel = Kênh cập nhật
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Thư mục chứa bản cập nhật
       *[other] Thư mục chứa bản cập nhật
    }
app-basics-update-history = Lịch sử cập nhật
app-basics-show-update-history = Hiển thị lịch sử cập nhật
# Represents the path to the binary used to start the application.
app-basics-binary = Ứng dụng nhị phân
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Thư mục hồ sơ
       *[other] Thư mục hồ sơ
    }
app-basics-enabled-plugins = Phần bổ trợ đã bật
app-basics-build-config = Cấu hình bản dựng
app-basics-user-agent = Chuỗi đại diện người dùng (User Agent)
app-basics-os = Hệ điều hành
app-basics-os-theme = Chủ đề hệ điều hành
# Rosetta is Apple's translation process to run apps containing x86_64
# instructions on Apple Silicon. This should remain in English.
app-basics-rosetta = Rosetta Translated
app-basics-memory-use = Sử dụng bộ nhớ
app-basics-performance = Hiệu suất
app-basics-service-workers = Các Service Worker đã đăng ký
app-basics-third-party = Module của bên thứ ba
app-basics-profiles = Hồ sơ
app-basics-launcher-process-status = Quá trình khởi chạy
app-basics-multi-process-support = Các cửa sổ đa tiến trình
app-basics-fission-support = Fission Windows
app-basics-remote-processes-count = Tiến trình từ xa
app-basics-enterprise-policies = Chính sách doanh nghiệp
app-basics-location-service-key-google = Khóa dịch vụ định vị Google
app-basics-safebrowsing-key-google = Khóa Google Safebrowsing
app-basics-key-mozilla = Khóa dịch vụ định vị BrowserWorks
app-basics-safe-mode = Chế độ an toàn
app-basics-memory-size = Dung lượng bộ nhớ (RAM)
app-basics-disk-available = Không gian đĩa có sẵn
app-basics-pointing-devices = Thiết bị điều khiển con trỏ
# Variables:
#   $value (number) - Amount of data being stored
#   $unit (string) - The unit of data being stored (e.g. MB)
app-basics-data-size = { $value } { $unit }
show-dir-label =
    { PLATFORM() ->
        [macos] Hiển thị trong Finder
        [windows] Mở thư mục
       *[other] Mở thư mục
    }
environment-variables-title = Biến môi trường
environment-variables-name = Tên
environment-variables-value = Giá trị
experimental-features-title = Các tính năng thử nghiệm
experimental-features-name = Tên
experimental-features-value = Giá trị
modified-key-prefs-title = Các tùy chọn quan trọng đã được sửa đổi
modified-prefs-name = Tên
modified-prefs-value = Giá trị
user-js-title = Tinh chỉnh user.js
user-js-description = Thư mục hồ sơ của bạn chứa một tập tin <a data-l10n-name="user-js-link">user.js</a>, bao gồm các tùy chỉnh không được tạo bởi { -brand-short-name }.
locked-key-prefs-title = Các tùy chọn quan trọng đã khóa
locked-prefs-name = Tên
locked-prefs-value = Giá trị
graphics-title = Đồ họa
graphics-features-title = Tính năng
graphics-diagnostics-title = Chẩn đoán
graphics-failure-log-title = Nhật ký lỗi
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Nhật ký quyết định
graphics-crash-guards-title = Vô hiệu hóa tính năng bảo vệ sự cố
graphics-workarounds-title = Cách giải quyết
graphics-device-pixel-ratios = Tỉ lệ Pixel của cửa sổ thiết bị
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Giao thức cửa sổ
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Môi trường máy tính để bàn
place-database-title = Cơ sở dữ liệu địa điểm
place-database-stats = Thống kê
place-database-stats-show = Hiển thị thống kê
place-database-stats-hide = Ẩn thống kê
place-database-stats-entity = Thực thể
place-database-stats-count = Tổng số
place-database-stats-size-kib = Kích thước (KiB)
place-database-stats-size-perc = Kích thước (%)
place-database-stats-efficiency-perc = Hiệu quả (%)
place-database-stats-sequentiality-perc = Tuần tự (%)
place-database-integrity = Tính toàn vẹn
place-database-verify-integrity = Xác nhận tính toàn vẹn
a11y-title = Trợ năng
a11y-activated = Được kích hoạt
a11y-force-disabled = Ngăn các tùy chọn về trợ năng
a11y-handler-used = Xử lý truy cập được sử dụng
a11y-instantiator = Trợ năng truy cập
library-version-title = Phiên bản thư viện
copy-text-to-clipboard-label = Sao chép văn bản vào bộ nhớ tạm
copy-raw-data-to-clipboard-label = Sao chép dữ liệu thô vào bộ nhớ tạm
sandbox-title = Hộp cát
sandbox-sys-call-log-title = System Call bị từ chối
sandbox-sys-call-index = #
sandbox-sys-call-age = Cách đây vài giây
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Kiểu quy trình
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = Tham số
troubleshoot-mode-title = Chẩn đoán sự cố
restart-in-troubleshoot-mode-label = Chế độ xử lý sự cố…
clear-startup-cache-title = Hãy thử xóa bộ nhớ đệm khởi động
clear-startup-cache-label = Xóa bộ nhớ đệm khởi động…
startup-cache-dialog-title2 = Khởi động lại { -brand-short-name } để xóa bộ nhớ đệm khởi động?
startup-cache-dialog-body2 = Điều này sẽ không thay đổi cài đặt của bạn hoặc xóa tiện ích mở rộng.
restart-button-label = Khởi động lại

## Media titles

audio-backend = Âm thanh đầu cuối
max-audio-channels = Kênh tối đa
sample-rate = Tỷ lệ mẫu ưu tiên
roundtrip-latency = Thời gian trễ trọn vòng (độ lệch chuẩn)
media-title = Đa phương tiện
media-output-devices-title = Các thiết bị đầu ra
media-input-devices-title = Thiết bị đầu vào
media-device-name = Tên
media-device-group = Nhóm
media-device-vendor = Nhà cung cấp
media-device-state = Tình trạng
media-device-preferred = Ưu tiên
media-device-format = Định dạng
media-device-channels = Kênh
media-device-rate = Tỉ lệ
media-device-latency = Độ trễ
media-capabilities-title = Khả năng truyền thông
media-codec-support-info = Thông tin hỗ trợ Codec
# List all the entries of the database.
media-capabilities-enumerate = Liệt kê cơ sở dữ liệu

## Codec support table

media-codec-support-sw-decoding = Giải mã phần mềm
media-codec-support-hw-decoding = Giải mã phần cứng
media-codec-support-codec-name = Tên codec
media-codec-support-supported = Được hỗ trợ
media-codec-support-unsupported = Không hỗ trợ
media-codec-support-error = Không có thông tin Codec được hỗ trợ. Hãy thử lại sau khi phát tập tin phương tiện.

##

intl-title = Quốc tế hóa & bản địa hóa
intl-app-title = Cài đặt ứng dụng
intl-locales-requested = Yêu cầu ngôn ngữ
intl-locales-available = Ngôn ngữ có sẵn
intl-locales-supported = Ngôn ngữ ứng dụng
intl-locales-default = Ngôn ngữ mặc định
intl-os-title = Hệ điều hành
intl-os-prefs-system-locales = Ngôn ngữ hệ thống
intl-regional-prefs = Cài đặt khu vực

## Remote Debugging
##
## The Waterfox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Gỡ lỗi từ xa (Giao thức Chromium)
remote-debugging-accepting-connections = Cho phép kết nối
remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days = Báo cáo lỗi trong { $days } ngày gần đây
# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes = { $minutes } phút trước
# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours = { $hours } giờ trước
# Variables
# $days (integer) - Number of days since crash
crashes-time-days = { $days } ngày trước
# Variables
# $reports (integer) - Number of pending reports
pending-reports = Tất cả các báo cáo lỗi (bao gồm cả { $reports } báo cáo chưa gửi trong khoảng thời gian đã cho)
raw-data-copied = Đã sao chép dữ liệu thô vào bộ nhớ tạm
text-copied = Đã sao chép văn bản vào bộ nhớ tạm

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Bị chặn đối với phiên bản trình điều khiển đồ họa của bạn.
blocked-gfx-card = Bị chặn đối với card đồ họa của bạn vì vấn đề trình điều khiển chưa giải quyết được.
blocked-os-version = Bị chặn đối với phiên bản hệ điều hành của bạn.
blocked-mismatched-version = Bị chặn đối với phiên bản trình điều khiển đồ họa của bạn không khớp giữa registry và DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Bị chặn đối với phiên bản trình điều khiển đồ họa của bạn. Hãy thử cập nhật trình điều khiển đồ họa lên phiên bản { $driverVersion } hoặc mới hơn.
# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Tham số ClearType
compositing = Cách tổng hợp
hardware-h264 = Giải mã phần cứng H264
main-thread-no-omtc = chủ đề chính, không có OMTC
yes = Có
no = Không
unknown = Không rõ
virtual-monitor-disp = Màn hình ảo

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Đã tìm thấy
missing = Còn thiếu
gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Mô tả
gpu-vendor-id = ID Nhà cung cấp
gpu-device-id = ID Thiết bị
gpu-subsys-id = ID hệ thống con
gpu-drivers = Trình điều khiển
gpu-ram = RAM
gpu-driver-vendor = Nhà cung cấp trình điều khiển
gpu-driver-version = Phiên bản trình điều khiển
gpu-driver-date = Ngày ra mắt trình điều khiển
gpu-active = Hoạt động
webgl1-wsiinfo = Thông tin WSI Trình điều khiển WebGL 1
webgl1-renderer = Trình kết xuất trình điều khiển WebGL 1
webgl1-version = Phiên bản trình điều khiển WebGL 1
webgl1-driver-extensions = Tiện ích mở rộng trình điều khiển WebGL 1
webgl1-extensions = Tiện ích mở rộng WebGL 1
webgl2-wsiinfo = Thông tin WSI Trình điều khiển WebGL 2
webgl2-renderer = Trình kết xuất trình điều khiển WebGL 2
webgl2-version = Phiên bản trình điều khiển WebGL 2
webgl2-driver-extensions = Tiện ích mở rộng trình điều khiển WebGL 2
webgl2-extensions = Tiện ích mở rộng WebGL 2
webgpu-default-adapter = Adapter WebGPU mặc định
webgpu-fallback-adapter = Adapter WebGPU dự phòng
# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = Bị chặn trong danh sách do các sự cố đã biết: <a data-l10n-name="bug-link">mã lỗi { $bugNumber }</a>
# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Danh sách chặn; mã lỗi { $failureCode }
d3d11layers-crash-guard = Bộ soạn nhạc D3D11
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = Bộ giải mã video WMF VPX
reset-on-next-restart = Đặt lại vào lần khởi động lại tiếp theo
gpu-process-kill-button = Buộc dừng quá trình GPU
gpu-device-reset = Đặt lại thiết bị
gpu-device-reset-button = Bắt đầu thiết lập lại phần cứng
uses-tiling = Sử dụng ốp lát
content-uses-tiling = Sử dụng ốp lát (Nội dung)
off-main-thread-paint-enabled = Off Main Thread Painting được kích hoạt
off-main-thread-paint-worker-count = Bộ đếm Off Main Thread Painting Worker
target-frame-rate = Tỷ lệ khung mục tiêu
min-lib-versions = Phiên bản tối thiểu dự kiến
loaded-lib-versions = Phiên bản đang dùng
has-seccomp-bpf = Seccomp-BPF (Lọc cuộc gọi hệ thống)
has-seccomp-tsync = Đồng bộ hóa chủ đề Seccomp
has-user-namespaces = User Namespaces
has-privileged-user-namespaces = User Namespaces với các tiến trình ưu tiên
can-sandbox-content = Nội dung tiến trình Sandboxing
can-sandbox-media = Media Plugin Sandboxing
content-sandbox-level = Cấp độ quy trình nội dung hộp cát
effective-content-sandbox-level = Cấp độ hiệu quả nội dung hộp cát
content-win32k-lockdown-state = Trạng thái Win32k Lockdown cho tiến trình nội dung
support-sandbox-gpu-level = Mức độ tiến trình GPU hộp cát
sandbox-proc-type-content = nội dung
sandbox-proc-type-file = nội dung tập tin
sandbox-proc-type-media-plugin = phần bổ trợ phương tiện
sandbox-proc-type-data-decoder = bộ giải mã dữ liệu
startup-cache-title = Bộ nhớ đệm khởi động
startup-cache-disk-cache-path = Đường dẫn bộ nhớ đệm trên đĩa
startup-cache-ignore-disk-cache = Bỏ qua bộ nhớ đệm trên đĩa
startup-cache-found-disk-cache-on-init = Tìm thấy bộ nhớ đệm trên đĩa khi khởi tạo
startup-cache-wrote-to-disk-cache = Ghi vào bộ nhớ đệm trên đĩa
launcher-process-status-0 = Đã bật
launcher-process-status-1 = Vô hiệu hóa do thất bại
launcher-process-status-2 = Bắt buộc vô hiệu hóa
launcher-process-status-unknown = Tình trạng không xác định
# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
# Variables
# $fissionWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
fission-windows = { $fissionWindows }/{ $totalWindows }
fission-status-experiment-control = Đã tắt bởi thử nghiệm
fission-status-experiment-treatment = Đã bật bởi thử nghiệm
fission-status-disabled-by-e10s-env = Đã tắt bởi môi trường
fission-status-enabled-by-env = Đã bật bởi môi trường
fission-status-disabled-by-env = Đã tắt bởi môi trường
fission-status-enabled-by-default = Đã bật theo mặc định
fission-status-disabled-by-default = Đã tắt theo mặc định
fission-status-enabled-by-user-pref = Đã bật bởi người dùng
fission-status-disabled-by-user-pref = Đã tắt bởi người dùng
fission-status-disabled-by-e10s-other = E10s bị vô hiệu hóa
fission-status-enabled-by-rollout = Được kích hoạt bằng cách phát hành theo từng giai đoạn
async-pan-zoom = Pan/Zoom không đồng bộ
apz-none = không có
wheel-enabled = con lăn được bật
touch-enabled = cảm ứng được bật
drag-enabled = thanh cuộn kéo được bật
keyboard-enabled = bàn phím được bật
autoscroll-enabled = tự động cuộn được bật
zooming-enabled = pinch-zoom mượt được bật

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = đầu vào con lăn bất đối xứng đã tắt vì có thiết lập không được hỗ trợ: { $preferenceKey }
touch-warning = đầu vào cảm ứng không đồng bộ đã tắt vì có thiết lập không được hỗ trợ: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Không hoạt động
policies-active = Hoạt động
policies-error = Lỗi

## Printing section

support-printing-title = Đang In
support-printing-troubleshoot = Khắc phục sự cố
support-printing-clear-settings-button = Xóa cài đặt in đã lưu
support-printing-modified-settings = Đã sửa đổi cài đặt in
support-printing-prefs-name = Tên
support-printing-prefs-value = Giá trị

## Normandy sections

support-remote-experiments-title = Thử nghiệm từ xa
support-remote-experiments-name = Tên
support-remote-experiments-branch = Nhánh thử nghiệm
support-remote-experiments-see-about-studies = Xem trang <a data-l10n-name="support-about-studies-link">about:studies</a> để biết thêm thông tin, bao gồm cách tắt các thử nghiệm riêng lẻ hoặc tắt { -brand-short-name } từ việc chạy loại thử nghiệm này trong tương lai.
support-remote-features-title = Tính năng từ xa
support-remote-features-name = Tên
support-remote-features-status = Trạng thái

## Pointing devices

pointing-device-mouse = Chuột
pointing-device-touchscreen = Màn hình cảm ứng
pointing-device-pen-digitizer = Bút kỹ thuật số
pointing-device-none = Không có thiết bị điều khiển con trỏ
