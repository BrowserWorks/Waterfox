# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = In
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = Lưu thành

# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
       *[other] { $sheetCount } tờ giấy
    }

printui-page-range-all = Tất cả
printui-page-range-custom = Tùy chọn
printui-page-range-label = Trang
printui-page-range-picker =
    .aria-label = Chọn phạm vi trang
printui-page-custom-range-input =
    .aria-label = Nhập phạm vi trang tùy chỉnh
    .placeholder = ví dụ: 2-6, 9, 12-16

# Section title for the number of copies to print
printui-copies-label = Bản sao

printui-orientation = Hướng
printui-landscape = Ngang
printui-portrait = Dọc

# Section title for the printer or destination device to target
printui-destination-label = Thiết bị đích
printui-destination-pdf-label = Lưu thành PDF

printui-more-settings = Nhiều cài đặt hơn
printui-less-settings = Ít cài đặt hơn

printui-paper-size-label = Khổ giấy

# Section title (noun) for the print scaling options
printui-scale = Tỷ lệ
printui-scale-fit-to-page-width = Vừa với chiều rộng trang
# Label for input control where user can set the scale percentage
printui-scale-pcent = Tỷ lệ

# Section title (noun) for the two-sided print options
printui-two-sided-printing = In hai mặt
printui-two-sided-printing-off = Tắt
# Flip the sheet as if it were bound along its long edge.
printui-two-sided-printing-long-edge = Lật theo chiều dài
# Flip the sheet as if it were bound along its short edge.
printui-two-sided-printing-short-edge = Lật theo chiều rộng

# Section title for miscellaneous print options
printui-options = Tùy chọn
printui-headers-footers-checkbox = In đầu trang và chân trang
printui-backgrounds-checkbox = In phần nền

## The "Format" section, select a version of the website to print. Radio
## options to select between the original page, selected text only, or a version
## where the page is processed with "Reader View".

# The section title.
printui-source-label = Định dạng
# Option for printing the original page.
printui-source-radio = Gốc
# Option for printing just the content a user selected prior to printing.
printui-selection-radio = Phần được chọn
# Option for "simplifying" the page by printing the Reader View version.
printui-simplify-page-radio = Đơn giản hóa

##

printui-color-mode-label = Chế độ màu
printui-color-mode-color = Màu
printui-color-mode-bw = Đen và trắng

printui-margins = Lề
printui-margins-default = Mặc định
printui-margins-min = Tối thiểu
printui-margins-none = Không có
printui-margins-custom-inches = Tùy chỉnh (inch)
printui-margins-custom-mm = Tùy chỉnh (mm)
printui-margins-custom-top = Trên
printui-margins-custom-top-inches = Trên (inch)
printui-margins-custom-top-mm = Trên (mm)
printui-margins-custom-bottom = Dưới
printui-margins-custom-bottom-inches = Dưới (inch)
printui-margins-custom-bottom-mm = Dưới (mm)
printui-margins-custom-left = Trái
printui-margins-custom-left-inches = Trái (inch)
printui-margins-custom-left-mm = Trái (mm)
printui-margins-custom-right = Phải
printui-margins-custom-right-inches = Phải (inch)
printui-margins-custom-right-mm = Phải (mm)

printui-system-dialog-link = In bằng hộp thoại hệ thống…

printui-primary-button = In
printui-primary-button-save = Lưu
printui-cancel-button = Hủy bỏ
printui-close-button = Đóng

printui-loading = Đang chuẩn bị xem trước

# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = Xem trước trang in

printui-pages-per-sheet = Số trang trên mỗi tờ

# This is shown next to the Print button with an indefinite loading spinner
# when the user prints a page and it is being sent to the printer.
printui-print-progress-indicator = Đang in...
printui-print-progress-indicator-saving = Đang lưu...

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
printui-paper-tabloid = Báo khổ nhỏ

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = Tỉ lệ phải là số từ 10 đến 200.
printui-error-invalid-margin = Vui lòng nhập lề hợp lệ cho khổ giấy đã chọn.
printui-error-invalid-copies = Bản sao phải là một số từ 1 đến 10000.

# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = Phạm vi phải là số từ 1 đến { $numPages }.
printui-error-invalid-start-overflow = Số trang “từ” phải nhỏ hơn số trang “đến”.
