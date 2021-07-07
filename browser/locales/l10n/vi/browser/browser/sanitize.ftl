# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = Thiết lập cho việc xóa trắng lịch sử
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = Xóa các lịch sử gần đây
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = Xóa toàn bộ lịch sử
    .style = width: 34em

clear-data-settings-label = Khi đóng, { -brand-short-name } sẽ xóa tất cả một cách tự động

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = Khoảng thời gian để xóa:{ " " }
    .accesskey = K

clear-time-duration-value-last-hour =
    .label = Một tiếng gần đây

clear-time-duration-value-last-2-hours =
    .label = Hai tiếng gần đây

clear-time-duration-value-last-4-hours =
    .label = Bốn tiếng gần đây

clear-time-duration-value-today =
    .label = Hôm nay

clear-time-duration-value-everything =
    .label = Mọi lúc

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = Lịch sử

item-history-and-downloads =
    .label = Lịch sử duyệt web & tải xuống
    .accesskey = d

item-cookies =
    .label = Cookie
    .accesskey = C

item-active-logins =
    .label = Đăng nhập đang hoạt động
    .accesskey = L

item-cache =
    .label = Bộ nhớ đệm
    .accesskey = a

item-form-search-history =
    .label = Lịch sử biểu mẫu & tìm kiếm
    .accesskey = b

data-section-label = Dữ liệu

item-site-preferences =
    .label = Tùy chỉnh trang web
    .accesskey = S

item-offline-apps =
    .label = Dữ liệu trang web ngoại tuyến
    .accesskey = O

sanitize-everything-undo-warning = Thao tác này không thể hoàn tác được.

window-close =
    .key = w

sanitize-button-ok =
    .label = Xóa ngay

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = Đang xóa

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = Toàn bộ lịch sử sẽ bị xóa.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = Tất cả các mục đã chọn sẽ bị xóa.
