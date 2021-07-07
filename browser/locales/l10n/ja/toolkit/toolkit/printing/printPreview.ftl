# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printpreview-simplify-page-checkbox =
    .label = ページを単純化
    .accesskey = i
    .tooltiptext = このページは自動的に単純化できません
printpreview-simplify-page-checkbox-enabled =
    .label = { printpreview-simplify-page-checkbox.label }
    .accesskey = { printpreview-simplify-page-checkbox.accesskey }
    .tooltiptext = 読みやすいレイアウトに変更します
printpreview-close =
    .label = 閉じる
    .accesskey = C
printpreview-portrait =
    .label = 縦
    .accesskey = o
printpreview-landscape =
    .label = 横
    .accesskey = L
printpreview-scale =
    .value = 拡大/縮小:
    .accesskey = S
printpreview-shrink-to-fit =
    .label = 用紙に合わせて縮小
printpreview-custom =
    .label = ユーザー設定...
printpreview-print =
    .label = 印刷...
    .accesskey = P
printpreview-of =
    .value = /
printpreview-custom-scale-prompt-title = 拡大/縮小の設定
printpreview-page-setup =
    .label = ページ設定...
    .accesskey = u
printpreview-page =
    .value = ページ:
    .accesskey = a

# Variables
# $sheetNum (integer) - The current sheet number
# $sheetCount (integer) - The total number of sheets to print
printpreview-sheet-of-sheets = { $sheetNum } / { $sheetCount }

## Variables
## $percent (integer) - menuitem percent label
## $arrow (String) - UTF-8 arrow character for navigation buttons

printpreview-percentage-value =
    .label = { $percent }%
printpreview-homearrow =
    .label = { $arrow }
    .tooltiptext = 最初のページを表示します
printpreview-previousarrow =
    .label = { $arrow }
    .tooltiptext = 前のページを表示します
printpreview-nextarrow =
    .label = { $arrow }
    .tooltiptext = 次のページを表示します
printpreview-endarrow =
    .label = { $arrow }
    .tooltiptext = 最後のページを表示します

printpreview-homearrow-button =
    .title = 最初のページ
printpreview-previousarrow-button =
    .title = 前のページ
printpreview-nextarrow-button =
    .title = 次のページ
printpreview-endarrow-button =
    .title = 最後のページ
