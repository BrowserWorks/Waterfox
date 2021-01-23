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
printui-page-custom-range =
    .aria-label = 輸入自訂的頁數範圍
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = 從
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = 到
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
printui-scale-fit-to-page = 填滿頁面
printui-scale-fit-to-page-width = 符合頁面寬度
# Label for input control where user can set the scale percentage
printui-scale-pcent = 縮放比例
# Section title for miscellaneous print options
printui-options = 選項
printui-headers-footers-checkbox = 列印頁首與頁尾
printui-backgrounds-checkbox = 列印背景
printui-color-mode-label = 色彩模式
printui-color-mode-color = 彩色
printui-color-mode-bw = 黑白
printui-margins = 邊界
printui-margins-default = 預設值
printui-margins-min = 最小
printui-margins-none = 無
printui-system-dialog-link = 使用系統對話框列印…
printui-primary-button = 列印
printui-primary-button-save = 儲存
printui-cancel-button = 取消
printui-loading = 正在準備預覽列印
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = 預覽列印

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
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = 列印範圍必須在第 1 頁到第 { $numPages } 頁之間。
printui-error-invalid-start-overflow = 開始頁碼必須小於結束頁碼。
