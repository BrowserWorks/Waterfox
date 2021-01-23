# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = 印刷

# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = 名前を付けて保存

# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
        [one] { $sheetCount } 枚
       *[other] { $sheetCount } 枚
    }

printui-page-range-all = すべて
printui-page-range-custom = 指定範囲
printui-page-range-label = ページ指定
printui-page-range-picker =
  .aria-label = ページ範囲を選択してください
printui-page-custom-range =
  .aria-label = ページ範囲を入力してください

# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = ページ指定
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = –

# Section title for the number of copies to print
printui-copies-label = 部数

printui-orientation = 用紙の向き
printui-landscape = 横
printui-portrait = 縦

# Section title for the printer or destination device to target
printui-destination-label = プリンター

printui-destination-pdf-label = PDF に保存

printui-more-settings = 詳細設定
printui-less-settings = 簡易設定

printui-paper-size-label = 用紙サイズ

# Section title (noun) for the print scaling options
printui-scale = 倍率
printui-scale-fit-to-page = 用紙全体に合わせる
printui-scale-fit-to-page-width = 用紙幅に合わせる
# Label for input control where user can set the scale percentage
printui-scale-pcent = 倍率

# Section title for miscellaneous print options
printui-options = オプション
printui-headers-footers-checkbox = ヘッダーとフッターを印刷する
printui-backgrounds-checkbox = 背景画像を印刷する

printui-color-mode-label = カラーモード
printui-color-mode-color = カラー
printui-color-mode-bw = モノクロ

printui-margins = 余白
printui-margins-default = 既定
printui-margins-min = 最少
printui-margins-none = なし

printui-system-dialog-link = システムダイアログを使用して印刷...

printui-primary-button = 印刷
printui-primary-button-save = 保存
printui-cancel-button = キャンセル

printui-loading = プレビューの準備中です

# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = 印刷プレビュー

## Paper sizes that may be supported by the Save to PDF destination:
## (^m^) /widget/nsPrinterListBase.cpp (Bug 1659781)

printui-paper-a5 = A5
printui-paper-a4 = A4
printui-paper-a3 = A3
printui-paper-a2 = A2
printui-paper-a1 = A1
printui-paper-a0 = A0
printui-paper-b5 = B5 (ISO)
printui-paper-b4 = B4 (ISO)
printui-paper-jis-b5 = B5 (JIS)
printui-paper-jis-b4 = B4 (JIS)
printui-paper-letter = レター (8.5"x11")
printui-paper-legal = リーガル (8.5"x14")
printui-paper-tabloid = タブロイド (11"x17")

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = 倍率は 10 から 200 までの間の数字を入力してください。

# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = ページ範囲は 1 から { $numPages } までの間の数字を入力してください。
printui-error-invalid-start-overflow = ページ範囲は開始ページと終了ページを逆に指定することができません。
