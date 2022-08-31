# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printpreview-simplify-page-checkbox =
    .label = หน้าแบบเรียบง่าย
    .accesskey = ร
    .tooltiptext = หน้านี้ไม่สามารถทำให้เรียบง่ายได้โดยอัตโนมัติ
printpreview-simplify-page-checkbox-enabled =
    .label = { printpreview-simplify-page-checkbox.label }
    .accesskey = { printpreview-simplify-page-checkbox.accesskey }
    .tooltiptext = เปลี่ยนเค้าโครงเพื่อการอ่านที่ง่ายขึ้น
printpreview-close =
    .label = ปิด
    .accesskey = ด
printpreview-portrait =
    .label = แนวตั้ง
    .accesskey = น
printpreview-landscape =
    .label = แนวนอน
    .accesskey = ว
printpreview-scale =
    .value = มาตราส่วน:
    .accesskey = ม
printpreview-shrink-to-fit =
    .label = ย่อให้พอดี
printpreview-custom =
    .label = กำหนดเอง…
printpreview-print =
    .label = พิมพ์…
    .accesskey = พ
printpreview-of =
    .value = จาก
printpreview-custom-scale-prompt-title = มาตราส่วนที่กำหนดเอง
printpreview-page-setup =
    .label = ตั้งค่าหน้ากระดาษ…
    .accesskey = ง
printpreview-page =
    .value = หน้า:
    .accesskey = ห

# Variables
# $sheetNum (integer) - The current sheet number
# $sheetCount (integer) - The total number of sheets to print
printpreview-sheet-of-sheets = { $sheetNum } จาก { $sheetCount }

## Variables
## $percent (integer) - menuitem percent label
## $arrow (String) - UTF-8 arrow character for navigation buttons

printpreview-percentage-value =
    .label = { $percent }%
printpreview-homearrow =
    .label = { $arrow }
    .tooltiptext = หน้าแรก
printpreview-previousarrow =
    .label = { $arrow }
    .tooltiptext = หน้าก่อนหน้า
printpreview-nextarrow =
    .label = { $arrow }
    .tooltiptext = หน้าถัดไป
printpreview-endarrow =
    .label = { $arrow }
    .tooltiptext = หน้าสุดท้าย

printpreview-homearrow-button =
    .title = หน้าแรก
printpreview-previousarrow-button =
    .title = หน้าก่อนหน้า
printpreview-nextarrow-button =
    .title = หน้าถัดไป
printpreview-endarrow-button =
    .title = หน้าสุดท้าย
