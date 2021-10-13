# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = ตัวจัดการงาน

## Column headers

column-name = ชื่อ
column-type = ชนิด
column-energy-impact = ผลกระทบด้านพลังงาน
column-memory = หน่วยความจำ

## Special values for the Name column

ghost-windows = แท็บที่ปิดล่าสุด
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = โหลดไว้ล่วงหน้า: { $title }

## Values for the Type column

type-tab = แท็บ
type-subframe = เฟรมย่อย
type-tracker = ตัวติดตาม
type-addon = ส่วนเสริม
type-browser = เบราว์เซอร์
type-worker = ตัวทำงาน
type-other = อื่น ๆ

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = สูง ({ $value })
energy-impact-medium = ปานกลาง ({ $value })
energy-impact-low = ต่ำ ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = ปิดแท็บ
show-addon =
    .title = แสดงในตัวจัดการส่วนเสริม

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occurred for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occurred in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        การแยกส่งตั้งแต่โหลด: { $totalDispatches } ({ $totalDuration }ms)
        การแยกส่งในช่วงวินาทีที่ผ่านมา: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
