# This Source Code Form is subject to the terms of the Waterfox Public
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
printui-page-custom-range-input =
  .aria-label = ページ範囲を入力してください
  .placeholder = 例: 2-6, 9, 12-16

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
printui-scale-fit-to-page-width = 用紙幅に合わせる
# Label for input control where user can set the scale percentage
printui-scale-pcent = 倍率

# Section title (noun) for the two-sided print options
printui-two-sided-printing = 両面印刷

printui-two-sided-printing-off = オフ
# Flip the sheet as if it were bound along its long edge.
printui-two-sided-printing-long-edge = 長辺とじ
# Flip the sheet as if it were bound along its short edge.
printui-two-sided-printing-short-edge = 短辺とじ

# Section title for miscellaneous print options
printui-options = オプション
printui-headers-footers-checkbox = ヘッダーとフッターを印刷する
printui-backgrounds-checkbox = 背景画像を印刷する

## The "Format" section, select a version of the website to print. Radio
## options to select between the original page, selected text only, or a version
## where the page is processed with "Reader View".

# The section title.
printui-source-label = 印刷形式
# Option for printing the original page.
printui-source-radio = 元のページ
# Option for printing just the content a user selected prior to printing.
printui-selection-radio = 選択部分のみ
# Option for "simplifying" the page by printing the Reader View version.
printui-simplify-page-radio = ページを単純化

##

printui-color-mode-label = カラーモード
printui-color-mode-color = カラー
printui-color-mode-bw = モノクロ

printui-margins = 余白
printui-margins-default = 既定
printui-margins-min = 最少
printui-margins-none = なし
printui-margins-custom-inches = カスタム (インチ)
printui-margins-custom-mm = カスタム (mm)
printui-margins-custom-top = 上
printui-margins-custom-top-inches = 上 (インチ)
printui-margins-custom-top-mm = 上 (mm)
printui-margins-custom-bottom = 下
printui-margins-custom-bottom-inches = 下 (インチ)
printui-margins-custom-bottom-mm = 下 (mm)
printui-margins-custom-left = 左
printui-margins-custom-left-inches = 左 (インチ)
printui-margins-custom-left-mm = 左 (mm)
printui-margins-custom-right = 右
printui-margins-custom-right-inches = 右 (インチ)
printui-margins-custom-right-mm = 右 (mm)

printui-system-dialog-link = システムダイアログを使用して印刷...

printui-primary-button = 印刷
printui-primary-button-save = 保存
printui-cancel-button = キャンセル
printui-close-button = 閉じる

printui-loading = プレビューの準備中です

# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = 印刷プレビュー

printui-pages-per-sheet = 1 枚あたりのページ数

# This is shown next to the Print button with an indefinite loading spinner
# when the user prints a page and it is being sent to the printer.
printui-print-progress-indicator = 印刷中...
printui-print-progress-indicator-saving = 保存中...

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
printui-error-invalid-margin = 選択した用紙サイズに合う余白を入力してください。
printui-error-invalid-copies = 部数は 1 から 10000 までの間の数字を入力してください。

# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = ページ範囲は 1 から { $numPages } までの間の数字を入力してください。
printui-error-invalid-start-overflow = ページ範囲は開始ページと終了ページを逆に指定することができません。
