# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = Cài đặt Profiler
perftools-intro-description =
    Bản ghi khởi chạy profiler.firefox.com trong một thẻ mới. Tất cả dữ liệu được lưu trữ
    cục bộ, nhưng bạn có thể chọn tải lên để chia sẻ.

## All of the headings for the various sections.

perftools-heading-settings = Tất cả cài đặt
perftools-heading-buffer = Cài đặt bộ đệm
perftools-heading-features = Tính năng
perftools-heading-features-default = Tính năng (Được khuyến nghị bật theo mặc định)
perftools-heading-features-disabled = Tính năng đã tắt
perftools-heading-features-experimental = Thử nghiệm

##

perftools-description-intro =
    Bản ghi sẽ khởi chạy <a>profiler.firefox.com</a> trong một thẻ mới. Tất cả dữ liệu được lưu trữ
    cục bộ, nhưng bạn có thể chọn tải lên để chia sẻ.

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = Khoảng thời gian lấy mẫu:
perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } ms

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = Kích thước đệm:
perftools-devtools-interval-label = Khoảng thời gian
perftools-devtools-settings-label = Cài đặt

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-private-browsing-notice =
    Profiler bị tắt khi Duyệt web riêng tư được bật.
    Đóng tất cả Cửa sổ riêng tư để kích hoạt lại Profiler
perftools-status-recording-stopped-by-another-tool = Việc ghi đã bị dừng bởi một công cụ khác.
perftools-status-restart-required = Trình duyệt phải được khởi động lại để kích hoạt tính năng này.

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = Đang dừng ghi
perftools-request-to-get-profile-and-stop-profiler = Đang ghi hồ sơ

##

perftools-button-start-recording = Bắt đầu ghi
perftools-button-save-settings = Lưu cài đặt và quay lại
perftools-button-restart = Khởi động lại
perftools-button-add-directory = Thêm một thư mục
perftools-button-remove-directory = Xóa mục đã chọn
perftools-button-edit-settings = Chỉnh sửa cài đặt…

## These messages are descriptions of the threads that can be enabled for the profiler.


##


## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## both devtools.performance.new-panel-onboarding & devtools.performance.new-panel-enabled
## preferences are true.

-profiler-brand-name = Waterfox Profiler
perftools-onboarding-message = <b>Mới</b>: { -profiler-brand-name } hiện được tích hợp vào Công cụ nhà phát triển. <a>Tìm hiểu thêm</a> về công cụ mới mạnh mẽ này.
# `options-context-advanced-settings` is defined in toolbox-options.ftl
perftools-onboarding-reenable-old-panel = (Trong thời gian giới hạn, bạn có thể truy cập bảng hiệu suất ban đầu qua <a>{ options-context-advanced-settings }</a>)
