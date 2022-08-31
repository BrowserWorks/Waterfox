# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printpreview-simplify-page-checkbox =
    .label = 简化页面
    .accesskey = i
    .tooltiptext = 此网页不能被自动简化
printpreview-simplify-page-checkbox-enabled =
    .label = { printpreview-simplify-page-checkbox.label }
    .accesskey = { printpreview-simplify-page-checkbox.accesskey }
    .tooltiptext = 更改便于阅读的布局
printpreview-close =
    .label = 关闭
    .accesskey = C
printpreview-portrait =
    .label = 纵向
    .accesskey = o
printpreview-landscape =
    .label = 横向
    .accesskey = L
printpreview-scale =
    .value = 比例：
    .accesskey = S
printpreview-shrink-to-fit =
    .label = 调整到适合
printpreview-custom =
    .label = 自定义…
printpreview-print =
    .label = 打印…
    .accesskey = P
printpreview-of =
    .value = 页 共
printpreview-custom-scale-prompt-title = 自定义比例
printpreview-page-setup =
    .label = 页面设置…
    .accesskey = u
printpreview-page =
    .value = 第
    .accesskey = a

# Variables
# $sheetNum (integer) - The current sheet number
# $sheetCount (integer) - The total number of sheets to print
printpreview-sheet-of-sheets = 第 { $sheetNum } 页，共 { $sheetCount } 页

## Variables
## $percent (integer) - menuitem percent label
## $arrow (String) - UTF-8 arrow character for navigation buttons

printpreview-percentage-value =
    .label = { $percent }%
printpreview-homearrow =
    .label = { $arrow }
    .tooltiptext = 第一页
printpreview-previousarrow =
    .label = { $arrow }
    .tooltiptext = 上一页
printpreview-nextarrow =
    .label = { $arrow }
    .tooltiptext = 下一页
printpreview-endarrow =
    .label = { $arrow }
    .tooltiptext = 末页

printpreview-homearrow-button =
    .title = 首页
printpreview-previousarrow-button =
    .title = 上一页
printpreview-nextarrow-button =
    .title = 下一页
printpreview-endarrow-button =
    .title = 尾页
