# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = 列印
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = 另存新檔
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
       *[other] { $sheetCount } 張紙
    }
printui-page-range-all = 全部
printui-page-range-custom = 自訂
printui-page-range-label = 頁面
printui-page-range-picker =
    .aria-label = 選擇頁數範圍
printui-page-custom-range-input =
    .aria-label = 輸入自訂頁面範圍
    .placeholder = 例如 2-6, 9, 12-16
# Section title for the number of copies to print
printui-copies-label = 份數
printui-orientation = 方向
printui-landscape = 橫式
printui-portrait = 直式
# Section title for the printer or destination device to target
printui-destination-label = 列印到
printui-destination-pdf-label = 儲存為 PDF
printui-more-settings = 更多設定
printui-less-settings = 更少設定
printui-paper-size-label = 紙張大小
# Section title (noun) for the print scaling options
printui-scale = 縮放
printui-scale-fit-to-page-width = 符合頁面寬度
# Label for input control where user can set the scale percentage
printui-scale-pcent = 縮放比例
# Section title (noun) for the two-sided print options
printui-two-sided-printing = 雙面列印
printui-two-sided-printing-off = 關閉
# Flip the sheet as if it were bound along its long edge.
printui-two-sided-printing-long-edge = 長邊翻轉
# Flip the sheet as if it were bound along its short edge.
printui-two-sided-printing-short-edge = 短邊翻轉
# Section title for miscellaneous print options
printui-options = 選項
printui-headers-footers-checkbox = 列印頁首與頁尾
printui-backgrounds-checkbox = 列印背景
printui-selection-checkbox = 只印選取範圍
printui-color-mode-label = 色彩模式
printui-color-mode-color = 彩色
printui-color-mode-bw = 黑白
printui-margins = 邊界
printui-margins-default = 預設值
printui-margins-min = 最小
printui-margins-none = 無
printui-margins-custom-inches = 自訂（英寸）
printui-margins-custom-mm = 自訂（mm）
printui-margins-custom-top = 頂端
printui-margins-custom-top-inches = 頂端（英寸）
printui-margins-custom-top-mm = 頂端（mm）
printui-margins-custom-bottom = 底端
printui-margins-custom-bottom-inches = 底端（英寸）
printui-margins-custom-bottom-mm = 底端（mm）
printui-margins-custom-left = 左邊
printui-margins-custom-left-inches = 左方（英寸）
printui-margins-custom-left-mm = 左邊（mm）
printui-margins-custom-right = 右邊
printui-margins-custom-right-inches = 右方（英寸）
printui-margins-custom-right-mm = 右邊（mm）
printui-system-dialog-link = 使用系統對話框列印…
printui-primary-button = 列印
printui-primary-button-save = 儲存
printui-cancel-button = 取消
printui-close-button = 關閉
printui-loading = 正在準備預覽列印
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = 預覽列印
printui-pages-per-sheet = 每張紙要印的頁面數
# This is shown next to the Print button with an indefinite loading spinner
# when the user prints a page and it is being sent to the printer.
printui-print-progress-indicator = 列印中…
printui-print-progress-indicator-saving = 儲存中…

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

printui-error-invalid-scale = 縮放比例必須在 10 到 200 之間。
printui-error-invalid-margin = 請輸入所選紙張尺寸的有效邊界大小。
printui-error-invalid-copies = 份數必須是 1 到 10000 之間的數字。
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = 列印範圍必須在第 1 頁到第 { $numPages } 頁之間。
printui-error-invalid-start-overflow = 開始頁碼必須小於結束頁碼。
