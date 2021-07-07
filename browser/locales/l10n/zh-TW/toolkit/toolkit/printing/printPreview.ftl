# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printpreview-simplify-page-checkbox =
    .label = 簡化頁面
    .accesskey = i
    .tooltiptext = 無法自動簡化此頁面
printpreview-simplify-page-checkbox-enabled =
    .label = { printpreview-simplify-page-checkbox.label }
    .accesskey = { printpreview-simplify-page-checkbox.accesskey }
    .tooltiptext = 修改版面，簡化閱讀
printpreview-close =
    .label = 關閉
    .accesskey = C
printpreview-portrait =
    .label = 直式
    .accesskey = o
printpreview-landscape =
    .label = 橫式
    .accesskey = L
printpreview-scale =
    .value = 縮放:
    .accesskey = S
printpreview-shrink-to-fit =
    .label = 縮放至適合大小
printpreview-custom =
    .label = 自訂…
printpreview-print =
    .label = 列印…
    .accesskey = P
printpreview-of =
    .value = ／
printpreview-custom-scale-prompt-title = 自訂縮放
printpreview-page-setup =
    .label = 頁面設定…
    .accesskey = u
printpreview-page =
    .value = 頁:
    .accesskey = a

# Variables
# $sheetNum (integer) - The current sheet number
# $sheetCount (integer) - The total number of sheets to print
printpreview-sheet-of-sheets = 第 { $sheetNum } 頁，共 { $sheetCount } 頁

## Variables
## $percent (integer) - menuitem percent label
## $arrow (String) - UTF-8 arrow character for navigation buttons

printpreview-percentage-value =
    .label = { $percent }%
printpreview-homearrow =
    .label = { $arrow }
    .tooltiptext = 第一頁
printpreview-previousarrow =
    .label = { $arrow }
    .tooltiptext = 上一頁
printpreview-nextarrow =
    .label = { $arrow }
    .tooltiptext = 下一頁
printpreview-endarrow =
    .label = { $arrow }
    .tooltiptext = 最後一頁

printpreview-homearrow-button =
    .title = 第一頁
printpreview-previousarrow-button =
    .title = 上一頁
printpreview-nextarrow-button =
    .title = 下一頁
printpreview-endarrow-button =
    .title = 最後一頁
