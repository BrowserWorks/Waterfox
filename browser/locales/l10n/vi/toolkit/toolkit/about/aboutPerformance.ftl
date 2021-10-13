# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Trình quản lý tác vụ

## Column headers

column-name = Tên
column-type = Kiểu
column-energy-impact = Mức độ tác động
column-memory = Bộ nhớ

## Special values for the Name column

ghost-windows = Các thẻ đã đóng gần đây
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Đã tải sẵn: { $title }

## Values for the Type column

type-tab = Thẻ
type-subframe = Khung phụ
type-tracker = Trình theo dõi
type-addon = Tiện ích
type-browser = Trình duyệt
type-worker = Worker
type-other = Khác

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Cao ({ $value })
energy-impact-medium = Trung bình ({ $value })
energy-impact-low = Thấp ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Đóng thẻ
show-addon =
    .title = Hiển thị trong Trình quản lý tiện ích

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Công văn sau khi tải: { $totalDispatches } ({ $totalDuration } ms)
        Công văn sau giây cuối cùng: { $dispatchesSincePrevious } ({ $durationSincePrevious } ms)
