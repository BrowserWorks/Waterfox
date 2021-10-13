# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Trang tải xuống
downloads-panel =
    .aria-label = Trang tải xuống

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch
# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-items =
    .style = width: 35em
downloads-cmd-pause =
    .label = Tạm dừng
    .accesskey = m
downloads-cmd-resume =
    .label = Tiếp tục
    .accesskey = T
downloads-cmd-cancel =
    .tooltiptext = Hủy bỏ
downloads-cmd-cancel-panel =
    .aria-label = Hủy bỏ
# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Mở thư mục chứa
    .accesskey = m
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Hiển thị trong Finder
    .accesskey = F
downloads-cmd-use-system-default =
    .label = Mở trong Trình xem hệ thống
    .accesskey = V
downloads-cmd-always-use-system-default =
    .label = Luôn mở trong Trình xem hệ thống
    .accesskey = w
downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Hiển thị trong Finder
           *[other] Mở thư mục chứa
        }
downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Hiển thị trong Finder
           *[other] Mở thư mục chứa
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Hiển thị trong Finder
           *[other] Mở thư mục chứa
        }
downloads-cmd-show-downloads =
    .label = Mở thư mục tải xuống
downloads-cmd-retry =
    .tooltiptext = Thử lại
downloads-cmd-retry-panel =
    .aria-label = Thử lại
downloads-cmd-go-to-download-page =
    .label = Đến trang tải xuống
    .accesskey = g
downloads-cmd-copy-download-link =
    .label = Sao chép liên kết tải xuống
    .accesskey = l
downloads-cmd-remove-from-history =
    .label = Xóa khỏi nhật ký
    .accesskey = X
downloads-cmd-clear-list =
    .label = Dọn bảng xem trước
    .accesskey = D
downloads-cmd-clear-downloads =
    .label = Xóa các tải xuống
    .accesskey = v
# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Cho phép tải xuống
    .accesskey = o
# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Xóa tập tin
downloads-cmd-remove-file-panel =
    .aria-label = Xóa tập tin
# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Xóa tập tin hoặc cho phép tải xuống
downloads-cmd-choose-unblock-panel =
    .aria-label = Xóa tập tin hoặc cho phép tải xuống
# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Mở hoặc xóa tập tin
downloads-cmd-choose-open-panel =
    .aria-label = Mở hoặc xóa tập tin
# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Hiện thêm thông tin
# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Mở tập tin

## Displayed when the user clicked on a download in process. Indicates that the
## downloading file will be opened after certain amount of time using an app
## available in the system.
## Variables:
##   $hours (number) - Amount of hours left till the file opens.
##   $seconds (number) - Amount of seconds left till the file opens.
##   $minutes (number) - Amount of minutes till the file opens.

downloading-file-opens-in-hours-and-minutes = Sẽ mở sau { $hours } giờ { $minutes } phút…
downloading-file-opens-in-minutes = Sẽ mở sau { $minutes } phút…
downloading-file-opens-in-minutes-and-seconds = Sẽ mở sau { $minutes } phút { $seconds } giây…
downloading-file-opens-in-seconds = Sẽ mở sau { $seconds } giây…
downloading-file-opens-in-some-time = Sẽ mở sau khi hoàn thành…

##

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Thử tải lại
# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Hủy bỏ tải xuống
# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Xem tất cả tải xuống
    .accesskey = c
# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Chi tiết tải xuống
downloads-clear-downloads-button =
    .label = Xóa các tải xuống
    .tooltiptext = Xóa các tải xuống thành công, bị hủy và thất bại
# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Không có tải xuống nào.
# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Không có tải xuống cho phiên làm việc này.
