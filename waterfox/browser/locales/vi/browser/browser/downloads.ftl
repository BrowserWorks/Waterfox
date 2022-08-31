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

downloads-cmd-show-menuitem-2 =
    .label =
        { PLATFORM() ->
            [macos] Hiển thị trong thư mục
           *[other] Hiển thị trong thư mục
        }
    .accesskey = F

## Displayed in the downloads context menu for files that can be opened.
## Variables:
##   $handler (String) - The name of the mime type's default file handler.
##   Example: "Notepad", "Acrobat Reader DC", "7-Zip File Manager"

downloads-cmd-use-system-default =
    .label = Mở trong Trình xem hệ thống
    .accesskey = V
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-use-system-default-named =
    .label = Mở trong { $handler }
    .accesskey = I

# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-use-system-default =
    .label = Luôn mở trong Trình xem hệ thống
    .accesskey = w
# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-always-use-system-default-named =
    .label = Luôn mở trong { $handler }
    .accesskey = w

##

# We can use the same accesskey as downloads-cmd-always-use-system-default.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-open-similar-files =
    .label = Luôn mở các tập tin tương tự
    .accesskey = w

downloads-cmd-show-button-2 =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Hiển thị trong thư mục
           *[other] Hiển thị trong thư mục
        }

downloads-cmd-show-panel-2 =
    .aria-label =
        { PLATFORM() ->
            [macos] Hiển thị trong thư mục
           *[other] Hiển thị trong thư mục
        }
downloads-cmd-show-description-2 =
    .value =
        { PLATFORM() ->
            [macos] Hiển thị trong thư mục
           *[other] Hiển thị trong thư mục
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
downloads-cmd-delete-file =
    .label = Xóa
    .accesskey = D

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
    .value = Hiển thị thêm thông tin

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
downloading-file-click-to-open =
    .value = Mở khi hoàn thành

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

## Displayed when a site attempts to automatically download many files.
## Variables:
##   $num (number) - Number of blocked downloads.
##   $url (string) - The url of the suspicious site, stripped of http, https and www prefix.

downloads-files-not-downloaded =
    { $num ->
       *[other] { $num } tập tin chưa được tải xuống.
    }
downloads-blocked-from-url = Tải xuống bị chặn từ { $url }.
downloads-blocked-download-detailed-info = { $url } đã cố gắng tự tải xuống nhiều tập tin. Trang web có thể bị hỏng hoặc đang cố gắng lưu trữ các tập tin rác trên thiết bị của bạn.

##

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

# This is displayed in an item at the bottom of the Downloads Panel when there
# are more downloads than can fit in the list in the panel.
#   $count (number) - number of files being downloaded that are not shown in the
#                     panel list.
downloads-more-downloading =
    { $count ->
       *[other] { $count } tập tin khác đang tải xuống
    }
