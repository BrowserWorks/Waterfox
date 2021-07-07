# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = พิมพ์
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = บันทึกเป็น
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
       *[other] กระดาษ { $sheetCount } แผ่น
    }
printui-page-range-all = ทั้งหมด
printui-page-range-custom = กำหนดเอง
printui-page-range-label = หน้า
printui-page-range-picker =
    .aria-label = เลือกช่วงหน้ากระดาษ
printui-page-custom-range-input =
    .aria-label = ใส่ช่วงหน้ากระดาษที่กำหนดเอง
    .placeholder = เช่น 2-6, 9, 12-16
# Section title for the number of copies to print
printui-copies-label = สำเนา
printui-orientation = การวางแนว
printui-landscape = แนวนอน
printui-portrait = แนวตั้ง
# Section title for the printer or destination device to target
printui-destination-label = ปลายทาง
printui-destination-pdf-label = บันทึกไปเป็น PDF
printui-more-settings = การตั้งค่าเพิ่มเติม
printui-less-settings = การตั้งค่าน้อยลง
printui-paper-size-label = ขนาดกระดาษ
# Section title (noun) for the print scaling options
printui-scale = มาตราส่วน
printui-scale-fit-to-page-width = พอดีกับความกว้างของหน้า
# Label for input control where user can set the scale percentage
printui-scale-pcent = มาตราส่วน
# Section title (noun) for the two-sided print options
printui-two-sided-printing = การพิมพ์สองด้าน
printui-two-sided-printing-off = ปิด
# Flip the sheet as if it were bound along its long edge.
printui-two-sided-printing-long-edge = พลิกตามขอบยาว
# Flip the sheet as if it were bound along its short edge.
printui-two-sided-printing-short-edge = พลิกตามขอบสั้น
# Section title for miscellaneous print options
printui-options = ตัวเลือก
printui-headers-footers-checkbox = พิมพ์หัวกระดาษและท้ายกระดาษ
printui-backgrounds-checkbox = พิมพ์พื้นหลัง
printui-selection-checkbox = พิมพ์ที่เลือกเท่านั้น
printui-color-mode-label = โหมดสี
printui-color-mode-color = สี
printui-color-mode-bw = ขาวดำ
printui-margins = ระยะขอบ
printui-margins-default = ค่าเริ่มต้น
printui-margins-min = ต่ำสุด
printui-margins-none = ไม่มี
printui-margins-custom-inches = กำหนดเอง (นิ้ว)
printui-margins-custom-mm = กำหนดเอง (มม.)
printui-margins-custom-top = ด้านบน
printui-margins-custom-top-inches = ด้านบน (นิ้ว)
printui-margins-custom-top-mm = บน (มม.)
printui-margins-custom-bottom = ด้านล่าง
printui-margins-custom-bottom-inches = ด้านล่าง (นิ้ว)
printui-margins-custom-bottom-mm = ล่าง (มม.)
printui-margins-custom-left = ด้านซ้าย
printui-margins-custom-left-inches = ด้านซ้าย (นิ้ว)
printui-margins-custom-left-mm = ซ้าย (มม.)
printui-margins-custom-right = ด้านขวา
printui-margins-custom-right-inches = ด้านขวา (นิ้ว)
printui-margins-custom-right-mm = ขวา (มม.)
printui-system-dialog-link = พิมพ์โดยใช้กล่องโต้ตอบระบบ…
printui-primary-button = พิมพ์
printui-primary-button-save = บันทึก
printui-cancel-button = ยกเลิก
printui-close-button = ปิด
printui-loading = กำลังเตรียมตัวอย่าง
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = ตัวอย่างก่อนพิมพ์
printui-pages-per-sheet = หน้าต่อแผ่น
# This is shown next to the Print button with an indefinite loading spinner
# when the user prints a page and it is being sent to the printer.
printui-print-progress-indicator = กำลังพิมพ์…
printui-print-progress-indicator-saving = กำลังบันทึก…

## Paper sizes that may be supported by the Save to PDF destination:

printui-paper-a5 = A5
printui-paper-a4 = A4
printui-paper-a3 = A3
printui-paper-a2 = A2
printui-paper-a1 = A1
printui-paper-a0 = A0
printui-paper-b5 = B5
printui-paper-b4 = B4
printui-paper-jis-b5 = JIS-B5
printui-paper-jis-b4 = JIS-B4
printui-paper-letter = US Letter
printui-paper-legal = US Legal
printui-paper-tabloid = Tabloid

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = มาตราส่วนต้องเป็นตัวเลขระหว่าง 10 ถึง 200
printui-error-invalid-margin = โปรดป้อนระยะขอบที่ถูกต้องสำหรับขนาดกระดาษที่เลือก
printui-error-invalid-copies = สำเนาต้องเป็นตัวเลขระหว่าง 1 และ 10000
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = ช่วงต้องเป็นตัวเลขระหว่าง 1 ถึง { $numPages }
printui-error-invalid-start-overflow = หมายเลขหน้า “จาก” ต้องน้อยกว่าหมายเลขหน้า “ถึง”
